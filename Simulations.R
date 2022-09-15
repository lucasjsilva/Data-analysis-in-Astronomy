'Simulations'

#############################################################
## Bootstrap

n <- 20 # Number of points
x <- runif(n, min = 0, max = 15) 

# Line parameters and line equation 
afit <- 1
bfit <- 2
y <- bfit*x + afit 

# errors: standard deviation = 1.8
err <- rnorm(n, mean = 0, sd = 1.8)
y <- y + err

# Data visualization
plot(x, y, main = "y = 1 + 2x", col = 'blue', pch = 20, cex = 2)
abline(a = 1, b =2, lwd = 2)

# The real values of the parameters a and b can be seen applying the lm function
lmodel <- lm(y~x)
a <- lmodel$coefficients[,1]
b <- lmodel$coefficients[2,]

# Starting the bootstrap for the distribution of a and b
nboot <- 10000 # number of simulations

# matrix that will store the two parameters for each simulation
m <- matrix(0, ncol = 2, nrow = nboot) 

d0 <- 1:n # this vector has the indexes that will be sampled

for (i in 1:nboot){
  # Creating a vector that samples d0 with replacement
  dboot <- sample(d0, n, replace = TRUE)
  xl <- x[dboot]
  yl <- y[dboot]
  
  lm2 <- lm(yl~xl)
  m[i,] <-lm2$coefficients
  
}
asim <- mean(m[,1])
bsim <- mean(m[,2])

# Verifying the both results for the parameters in a graphic
plot(x, y, main = 'Bootstrap comparison', col = 'blue', pch = 20, cex = 2)
abline(a = 1, b = 2, lwd = 2)
abline(a = asim, b = bsim, lwd = 2, col = 'red')
legend('topleft', legend = c('y = 1 + 2x', 'Simulation'), col = c('black', 'red'),
       text.col = c('black', 'red'), bty = 'n')
#####################################################################
## Monte Carlo -- Pi value

# Value of Pi
P <- 3.141592

# Vector with the number of simulations used
nsim <- c(10, 100, 1000, 10000, 100000)

# Vectors that will store the different estimations for pi and the differences 
# from the true value
Values <- c(P) # the first value is the true value
Difference <- c(0)

for (i in nsim){
  # Counter of points inside the circle
  inside <- 0
  
  # Generating randomly x and y between 0 and 1
  x <- runif(i) 
  y <- runif(i)
  
  # Check which points are inside the circle
  for (j in 1:i) {
    if (x[j]^2 + y[j]^2 <= 1){inside <- inside + 1}
  }
  Values <- c(Values, 4*(inside/i))
  Difference <- c(Difference, abs(P - 4*(inside/i)))
}

table <- data.frame(Values, Difference,
                    row.names = c("True value", "N=10","N=100",
                                  "N=1000", "N=10000", "N=100000"))
table 


## Monte Carlo -- Integration

# Generating random 10000 points
N <- 10000
x <- runif(N)*P
y <- runif(N)

counter <- 0 # counter of points under the function
x_under <- c() # vector that will store all the ponits under the function
y_under <- c()
x_above <- c() # vector that will store all the points above the function
y_above <- c()

for (i in 1:N) {
  if (y[i] <= sin(x[i])){
    counter <- counter + 1
    x_under <- c(x_under, x[i])
    y_under <- c(y_under, y[i])
  }
  else{
    x_above <- c(x_above, x[i])
    y_above <- c(y_above, y[i])
  }
    
}
area <- (P*1)*counter/N

# Plotting the function and the points that
ax_x <- seq(0, P+0.2, 0.2)
ax_y <- sin(ax_x)

plot(ax_x, ax_y, main = 'Monte Carlo Integration', lwd = 3, type = 'l',
     xlab = 'x (rad)', ylab = 'Sine(x)')
points(x_under, y_under, col = 'green', pch = 20)
points(x_above, y_above, col = 'red',  pch = 20)
 
print(paste("The are of this function is", area))
