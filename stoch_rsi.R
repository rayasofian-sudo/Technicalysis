# BDA400 Assignment 5 - stoch_rsi
stoch_rsi <- function(data, period, k_period, d_period) {
  rsi_values <- rsi(data, period)
  valid_rsi <- rsi_values[!is.na(rsi_values)]
  min_rsi <- min(valid_rsi)
  max_rsi <- max(valid_rsi)
  k_values <- rep(NA_real_, length(rsi_values))
  if (max_rsi == min_rsi) {
    k_values[!is.na(rsi_values)] <- 0
  } else {
    k_values[!is.na(rsi_values)] <-
      (valid_rsi - min_rsi) / (max_rsi - min_rsi)
  }
  # Remove leading NA values before applying the assignment's SMA formula.
  valid_k <- k_values[!is.na(k_values)]
  k_line <- sma(valid_k, k_period)
  d_line <- sma(k_line, d_period)
  result <- list(k_line = k_line, d_line = d_line)
  return(result)
}
