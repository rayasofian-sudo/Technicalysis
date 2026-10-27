# BDA400 Assignment 5 - rsi
rsi <- function(data, period) {
  if (!is.numeric(data) || length(period) != 1 || is.na(period) ||
      period < 1 || period != as.integer(period)) stop("Invalid data or period")
  if (length(data) <= period) stop("Data must contain more values than the period")
  diff_values <- diff(data)
  gains <- pmax(diff_values, 0)
  losses <- pmax(-diff_values, 0)
  avg_gain <- sum(gains[1:period]) / period
  avg_loss <- sum(losses[1:period]) / period
  rsi_values <- rep(NA_real_, length(data))
  calculate_rsi <- function(gain, loss) {
    if (loss == 0 && gain == 0) return(50)
    if (loss == 0) return(100)
    100 - (100 / (1 + gain / loss))
  }
  rsi_values[period + 1] <- calculate_rsi(avg_gain, avg_loss)
  if (length(data) > period + 1) {
    for (i in (period + 2):length(data)) {
      avg_gain <- (avg_gain * (period - 1) + gains[i - 1]) / period
      avg_loss <- (avg_loss * (period - 1) + losses[i - 1]) / period
      rsi_values[i] <- calculate_rsi(avg_gain, avg_loss)
    }
  }
  return(rsi_values)
}
