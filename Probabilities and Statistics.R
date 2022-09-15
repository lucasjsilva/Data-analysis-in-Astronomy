'PROBABILITIES AND STATISTICS'

##
## Monty Hall problem
##

mHall <- function(){
  
  n = 10000 # Number of events simulated
  
  # if we want to stablish the reprodubility of the problem:
  # set.seed(30) # any number can be choosen
  
  # Defining where is the prize
  prize <- sample(c('1', '2', '3'), size = n, replace = TRUE)
  #print(prize)
  
  # Without losing generality, let's assume you choose the door 2, so
  # the 1 or 3 will be opened, randomly
  
  first_opened <- ifelse(prize == '2',     # if prize in 2
                         sample(c('1', '3'), size = n, replace = TRUE), # choose randomly
                         ifelse(prize == '1', '3', '1')) # choose the door without a prize
  
  
  # Case in which the choice isn't changed
  nc_doors <- sum(prize == '2')
  prob_nc <- nc_doors/n
  sigma_nc <- sqrt(nc_doors*(1-prob_nc))/n
  
  # Case in which the choice is changed
  door <- ifelse(first_opened == '1', '3', '1')
    
  c_doors <- sum(prize == door) 
  prob_c <- c_doors/n
  sigma_c <- sqrt(c_doors*(1-prob_c))/n
    
  # Printing the statistics to both cases
  print(paste("Probability not changing =",prob_nc, "+-", round(sigma_nc,5)))
  print(paste("Probability changing=",prob_c, "+-", round(sigma_c,5)))
  
  # Plotting a pie graphic to visualize the percentage:
  change <- c(c_doors, n - c_doors) 
  nchange <- c(nc_doors, n - nc_doors) 
  
  par(mfrow =c(1,2))
  
  # Graphic for changing the door
  g_change <- pie(change,
                  clockwise = TRUE,col = c("green", "red"),
                  labels = paste0(c(prob_c*100, (1-prob_c)*100),"%",
                                  c(" Right guess"," Wrong guess")),
                  main = "Change the door")
  # Graphic for not changing the door
  g_nchange <- pie(nchange,
                   clockwise = TRUE,col = c("green", "red"),
                   labels = paste0(c(prob_nc*100, (1-prob_nc)*100),"%",
                                   c(" Right guess"," Wrong guess")),
                   main = "Don't change the door")
  
  return()
  
}

##
## The prisioner's dillemma
##

prisioner <- function(){
  
  n <- 10000 # Number of events
  
  freedom <- sample(c('1', '2', '3', '4'), size = n, replace = TRUE)
  
  # Assuming the door 2 has been choosen, one the remaining doors will
  # be opened randomly
  
  first_opened <- ifelse(freedom == '2',
                         sample(c('1', '3', '4'), size = n, replace = TRUE),
                         ifelse(freedom == '1',
                                sample(c('3', '4'), size = n, replace = TRUE),
                                ifelse(freedom == '3',
                                       sample(c('1','4'), size = n, replace = TRUE),
                                       sample(c('1','3'), size = n, replace = TRUE))))
  
  # Case in which the choice isn't changed
  nc_doors <- sum(freedom == '2')
  prob_nc <- nc_doors/n #
  sigma_nc <- sqrt(nc_doors*(1-prob_nc))/n
    
  
  # Case in which the door is changed
  door <- ifelse(first_opened == '1',
                   sample(c('3','4'), size = n, replace = TRUE),
                   ifelse(first_opened == '3',
                          sample(c('1','4'), size = n, replace = TRUE),
                          sample(c('1','3'), size = n, replace = TRUE)))
    
  c_doors <- sum(freedom == door)
  prob_c <- c_doors/n
  sigma_c <- sqrt(c_doors*(1-prob_c))/n
           
  # Printing the statistics to both cases
  print(paste("Probability not changing =",prob_nc, "+-", round(sigma_nc,5)))
  print(paste("Probability changing=",prob_c, "+-", round(sigma_c,5)))
  
  # Plotting a pie graphic to visualize the percentage:
  change <- c(c_doors, n - c_doors) 
  nchange <- c(nc_doors, n - nc_doors) 
  
  par(mfrow =c(1,2))
  
  # Graphic for changing the door
  g_change <- pie(change,
               clockwise = TRUE,col = c("green", "red"),
               labels = paste0(c(prob_c*100, (1-prob_c)*100),"%",
                               c(" Right guess"," Wrong guess")),
               main = "Change the door")
  # Graphic for not changing the door
  g_nchange <- pie(nchange,
                   clockwise = TRUE,col = c("green", "red"),
                   labels = paste0(c(prob_nc*100, (1-prob_nc)*100),"%",
                                   c(" Right guess"," Wrong guess")),
                   main = "Don't change the door")
 
  return()
  
}

# =======================================================================


