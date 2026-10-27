# BDA400 Assignment 5 - sma
sma <- function(data, period) {
  if (!is.numeric(data) || length(period) != 1 || is.na(period) ||
      period < 1 || period != as.integer(period)) stop("Invalid data or period")
  if (length(data) < period) stop("Data length should be greater than or equal to the period")
  sma_values <- numeric(length(data) - period + 1)
  for (i in seq_along(sma_values)) {
    sma_values[i] <- sum(data[i:(i + period - 1)]) / period
  }
  return(sma_values)
}
