'PROBABILITY DISTRIBUTION'

###################################
## Gaussian Distribution
###################################

# Allowing reproduction of the results
set.seed(1234)

# densidade de probabilidades, distribuição cumulativa e percentil da distribuição cumulativa
par(mfrow=c(1,4)) # 4 figures side by side
x = seq(-4, 4, by = .1) # sequence of points for x
# Density of probability
plot(x,dnorm(x,mean=0,sd=1),main="Gaussian pdf", type="l", lwd=2,col='darkgoldenrod1')
# distribuição cumulativa
plot(x,pnorm(x,mean=0,sd=1),main="Cumulative distribution",type="l",lwd=2,col='darkgoldenrod1')
# percentil da distribuição cumulativa
p = seq(0, 1, by = .01)
x = qnorm(p)
plot(p,x,main="Quantile function",type="l",lwd=2,col='darkgoldenrod1')
# geração de números aleatórios
hist(rnorm(100,mean=10,sd=5),main='Simulation',col='salmon')

##################################
## Binomial Distribution
##################################

par(mfrow=c(2,2)) # 2X2 canvas

# Binomial distribution considering p=0.1
N=15   # Total of attempts
n = seq(0,20,1) # amount succeded
y = dbinom(n,N,prob=0.10) 
N=30
plot(n,y,main="Binomial distribution (N,p)=(15,0.1)",type="h",lwd=2,col='green2')
y = dbinom(n,N,prob=0.10) 
plot(n,y,main="Binomial distribution (N,p)=(30,0.1)",type="h",lwd=2,col='green2')

# Binomial distribution considering p=0.5
N=15
y = dbinom(n,N,prob=0.5) 
plot(n,y,main="Binomial distribution (N,p)=(15,0.5)",type="h",lwd=2,col='green2')
N=30
y = dbinom(n,N,prob=0.5) 
plot(n,y,main="Binomial distribution (N,p)=(30,0.5)",type="h",lwd=2,col='green2')

##################################
## Exponential Distribution
##################################

# Allowing reproduction of the results
set.seed(321)

# half-life (arbitrary units)
halflife = 2

# Rate: decay by unit of time
lambda = 1/halflife

# Initial number of nucleis
n0 = 1000

# decay time for each nuclei
td = rexp(n0,rate=lambda)
hist(td,breaks=20, col='salmon', main='Time of decay')

# Probability of a nuclei survives without decay for at least 10 units of time:
nn = sort(td)
p10 = length(nn[nn > 10])/n0
p10

##################################
## Poisson Distribution
##################################

par(mfrow=c(2,2)) # 2x2 canvas
# Sequence of integers from 0 to 20 
n = seq(0,20,1) 
lambda=4
y = dpois(n,lambda) 
plot(n,y,main="Poisson distribution (lambda=4)",type="h",lwd=2,col='blue3')
y = ppois(n,lambda) 
plot(n,y,main="Cumulative distribution",type="s",lwd=2,col='blue3')
# 100 números uniformemente distribuídos entre 0 e 1
x = seq(0,1,0.001)
y = qpois(x,lambda) 
plot(x,y,main="Quantile vector",type="l",lwd=2,col='blue3')
x=rpois(100,lambda)
hist(x,main="Random distribution with lambda=4",lwd=2,col='skyblue')