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

#' No randomness, y is a perfect linear function of x
#' 

df <- x_plus_noise(randomness=0)
plotly::plot_ly(data=df, x = ~x, y = ~y, type="scatter")
printf("perfectly correlated x and y: %g\n", cor(x=df$x, y=df$y))

#' Now we add just a bit of noise
#' 
df <- x_plus_noise(randomness=0.1)
plotly::plot_ly(data=df, x = ~x, y = ~y, type="scatter")
printf("correlation when y is a function of x but with a bit of noise: %g\n", cor(x=df$x, y=df$y,method=c("spearman")))

#' This time let's add a good bit of noise
#' 
df <- x_plus_noise(randomness=1)
plotly::plot_ly(data=df, x = ~x, y = ~y, type="scatter")
printf("correlation when y is a function of x but with lots of noise: %g\n", cor(x=df$x, y=df$y,method=c("spearman")))

#' And now let's check out some negative correlation
#' 
df <- x_plus_noise(randomness=0, slope=-1)
plotly::plot_ly(data=df, x = ~x, y = ~y, type="scatter")
printf("with slope=-1, perfect negative correlation: %g\n", cor(x=df$x, y=df$y,method=c("spearman")))

