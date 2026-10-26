# BDA400 Assignment 2 - Technical Analysis using R (preliminary stage)
# Run from inside the Assignment2 directory (or use RStudio Project).
# Market data source: Yahoo Finance via quantmod; requires internet access.

if (!requireNamespace("quantmod", quietly = TRUE) ||
    !requireNamespace("TTR", quietly = TRUE)) {
  stop("Install packages first by running 01_install_packages.R")
}

# Locate portfolio in current folder, or under TechnicalAnalysis/Assignment2.
portfolio_path <- if (file.exists("portfolio.txt")) {
  "portfolio.txt"
} else {
  file.path("TechnicalAnalysis", "Assignment2", "portfolio.txt")
}
if (!file.exists(portfolio_path)) stop("Could not find portfolio.txt. Set RStudio working directory to Assignment2.")
output_dir <- file.path(dirname(portfolio_path), "output")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

load_stock_data <- function(path = portfolio_path, from = Sys.Date() - 365, to = Sys.Date()) {
  symbols <- trimws(readLines(path, warn = FALSE))
  symbols <- unique(symbols[nzchar(symbols) & !startsWith(symbols, "#")])
  if (!length(symbols)) stop("No stock symbols found in portfolio.txt")
  stocks <- list()
  for (symbol in symbols) {
    tryCatch({
      raw <- quantmod::getSymbols(symbol, src = "yahoo", from = from, to = to,
                                   auto.assign = FALSE, warnings = FALSE)
      if (NROW(raw) == 0L) stop("No rows returned")
      data <- data.frame(Date = as.Date(zoo::index(raw)),
                         Open = as.numeric(quantmod::Op(raw)),
                         High = as.numeric(quantmod::Hi(raw)),
                         Low = as.numeric(quantmod::Lo(raw)),
                         Close = as.numeric(quantmod::Cl(raw)),
                         Volume = as.numeric(quantmod::Vo(raw)),
                         Adjusted = as.numeric(quantmod::Ad(raw)))
      stocks[[symbol]] <- data
      message("Loaded ", symbol, ": ", nrow(data), " trading days")
    }, error = function(e) {
      warning(sprintf("Skipping %s: %s", symbol, conditionMessage(e)))
    })
  }
  if (!length(stocks)) stop("No stock data was downloaded. Check internet / symbols / Yahoo availability.")
  stocks
}

# Mode: most frequent closing price rounded to cents; ties take the lowest value.
# R's built-in mode() is a storage-type function, not the statistical mode.
statistical_mode <- function(x) {
  x <- round(x[is.finite(x)], 2)
  if (!length(x)) return(NA_real_)
  freq <- table(x)
  as.numeric(names(freq)[which.max(freq)])
}

calculate_statistics <- function(stock_df, symbol, window = 20L) {
  close <- stock_df$Close
  valid <- close[is.finite(close)]
  if (!length(valid)) stop(sprintf("No valid closing prices for %s", symbol))
  stock_df$SMA20 <- as.numeric(TTR::SMA(close, n = window))
  summary <- data.frame(
    Symbol = symbol,
    Observations = length(valid),
    Mean = mean(valid),
    Mode = statistical_mode(valid),
    Median = median(valid),
    StdDev = if (length(valid) >= 2L) sd(valid) else NA_real_,
    Latest_Close = tail(valid, 1L),
    Latest_SMA20 = if (all(is.na(stock_df$SMA20))) NA_real_ else tail(na.omit(stock_df$SMA20), 1L),
    stringsAsFactors = FALSE
  )
  # Avoid zero-length values if there are fewer than window days.
  if (nrow(stock_df) < window || all(is.na(stock_df$SMA20))) summary$Latest_SMA20 <- NA_real_
  list(data = stock_df, summary = summary)
}

display_stock <- function(stock_df, symbol) {
  cat("\n---", symbol, "---\n")
  print(utils::head(stock_df, 6))
  cat("Last 6 rows:\n")
  print(utils::tail(stock_df, 6))
}

save_stock_chart <- function(stock_df, symbol, out_dir = output_dir) {
  png(file.path(out_dir, paste0(symbol, "_close_SMA20.png")),
      width = 1100, height = 650, res = 120)
  plot(stock_df$Date, stock_df$Close, type = "l", col = "steelblue", lwd = 2,
       main = paste(symbol, "- Closing Price and 20-Day Moving Average"),
       xlab = "Date", ylab = "Price (USD)")
  lines(stock_df$Date, stock_df$SMA20, col = "darkorange", lwd = 2)
  legend("topleft", legend = c("Close", "20-day SMA"),
         col = c("steelblue", "darkorange"), lty = 1, lwd = 2, bty = "n")
  grid()
  dev.off()
}

stock_data <- load_stock_data()
results <- list()
for (symbol in names(stock_data)) {
  results[[symbol]] <- calculate_statistics(stock_data[[symbol]], symbol)
  display_stock(results[[symbol]]$data, symbol)
  write.csv(results[[symbol]]$data, file.path(output_dir, paste0(symbol, "_data.csv")), row.names = FALSE)
  save_stock_chart(results[[symbol]]$data, symbol)
}
statistics_table <- do.call(rbind, lapply(results, function(x) x$summary))
print(statistics_table, row.names = FALSE, digits = 5)
write.csv(statistics_table, file.path(output_dir, "statistics_summary.csv"), row.names = FALSE)
message("Results saved to: ", normalizePath(output_dir))
