library(plotly)
#' Function definitions
#' 

x_plus_noise <- function(num_points=100, slope=1, randomness=0.1){
  if(randomness >1 || randomness < 0){
    stop("randomness must be between 0 and 1 (inclusive).")
  }
  x <- rnorm(n=num_points)
  return(data.frame(
    x = x,
    y = slope * x + rnorm(sd=randomness, n=num_points)
  ))
}

printf <- function(...) cat(sprintf(...))

#' ## Correlation Matrix
#' 
#' By calling `cor()` with the `DataFrame` variabel will return a square matrix containing all pairs of correlations.
#' By plotting them as a heatmap, you can visualize many correlations more efficiently.
df <- x_plus_noise(randomness=0)
plotly::plot_ly(x=c("x","y") ,y=c("x","y") ,z=cor(df), type = "heatmap")
cor(df)

#' ## Correlation matrix with mildly-correlated features
#' 
df <- x_plus_noise(randomness=0.5)
plotly::plot_ly(x=c("x","y") ,y=c("x","y") ,z=cor(df), type = "heatmap")
cor(df)

#' ## Correlation matrix with not-very-correlated features
#' 
df <- x_plus_noise(randomness=1)
plotly::plot_ly(x=c("x","y") ,y=c("x","y") ,z=cor(df), type = "heatmap")
cor(df)

