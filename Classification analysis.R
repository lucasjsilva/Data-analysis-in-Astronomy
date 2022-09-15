# Loading some useful libraries
library(caret)
library(ggplot2)
library(dplyr)
library(skimr)
library(corrplot)
library(KernSmooth)
library(e1071)

# Reading the data
data <- as.data.frame(read.table('splus_classification.dat', sep = '', header = TRUE))
# Considering only the first 5000 objects
data.1 <- data[1:5000,] 

# Checking the summary of the dataframe
sumry <- skim(data.1)
sumry

# Visualization of some parameters according to the object class
par(mfrow = c(2,2))

# 1st set: Color-magnitude diagram
ca <- data.1$g_petro - data.1$r_petro # g-r
cb <- data.1$r_petro - data.1$i_petro # r-i
smoothScatter(ca, cb, nrpoints = 0, add = FALSE, xlab = 'g-r', ylab = 'r-i',
              main = "All", xlim = c(-1, 3), ylim = c(-1, 2.25))

ca <- data.1$g_petro[data.1$class_Spec == "GALAXY"] - data.1$r_petro[data.1$class_Spec == "GALAXY"]
cb <- data.1$r_petro[data.1$class_Spec == "GALAXY"] - data.1$i_petro[data.1$class_Spec == "GALAXY"]
smoothScatter(ca, cb, nrpoints = 0, add = FALSE, xlab = 'g-r', ylab = 'r-i',
              main = "GALAXY", xlim = c(-1, 3), ylim = c(-1, 2.25))

ca <- data.1$g_petro[data.1$class_Spec == "STAR"] - data.1$r_petro[data.1$class_Spec == "STAR"]
cb <- data.1$r_petro[data.1$class_Spec == "STAR"] - data.1$i_petro[data.1$class_Spec == "STAR"]
smoothScatter(ca, cb, nrpoints = 0, add = FALSE, xlab = 'g-r', ylab = 'r-i',
              main = "STAR", xlim = c(-1, 3), ylim = c(-1, 2.25))

ca <- data.1$g_petro[data.1$class_Spec == "QSO"] - data.1$r_petro[data.1$class_Spec == "QSO"]
cb <- data.1$r_petro[data.1$class_Spec == "QSO"] - data.1$i_petro[data.1$class_Spec == "QSO"]
smoothScatter(ca, cb, nrpoints = 0, add = FALSE, xlab = 'g-r', ylab = 'r-i',
              main = "QSO", xlim = c(-1, 3), ylim = c(-1, 2.25))

# 2nd set: Object's size (in pixels)
hist(data$KRON_RADIUS, main = 'All', xlab = 'KRON_RADIUS')
hist(data$KRON_RADIUS[data$class_Spec == 'GALAXY'], main = 'GALAXY', xlab = 'KRON_RADIUS', xlim = c(2,6))
hist(data$KRON_RADIUS[data$class_Spec == 'STAR'], main = 'STAR', xlab = 'KRON_RADIUS', xlim = c(2,6))
hist(data$KRON_RADIUS[data$class_Spec == 'QSO'], main = 'QSO', xlab = 'KRON_RADIUS', xlim = c(2,6))

# 3rd set: Maximum supperficial brightness
hist(data$MU_MAX, main = 'All', xlab = 'MU_MAX')
hist(data$MU_MAX[data$class_Spec == 'GALAXY'], main = 'GALAXY', xlab = 'MU_MAX', xlim = c(10,18))
hist(data$MU_MAX[data$class_Spec == 'STAR'], main = 'STAR', xlab = 'MU_MAX', xlim = c(10,18))
hist(data$MU_MAX[data$class_Spec == 'QSO'], main = 'QSO', xlab = 'MU_MAX', xlim = c(10,18))

# 4th set: Object's number of pixels over certain isophote
hist(data$ISOarea, main = 'All', xlab = 'ISOarea', xlim = c(0, 5000))
hist(data$ISOarea[data$class_Spec == 'GALAXY'], main = 'GALAXY', xlab = 'ISOarea', xlim = c(0, 3000))
hist(data$ISOarea[data$class_Spec == 'STAR'], main = 'STAR', xlab = 'ISOarea', xlim = c(0, 1000))
hist(data$ISOarea[data$class_Spec == 'QSO'], main = 'QSO', xlab = 'ISOarea', xlim = c(0, 2000))

# 7 Training sets will be used: the first one considering only color-magnitude parameters (1st set);
# the second one considering the 2nd, 3rd and 4th set; and the remaining ones combining the 3rd set with some 
# color-magnitude parameters, but in different amounts
f1 <- data.1[, 6:17]
f2 <- data.1[, 2:4]
f3 <- data.frame(MU_MAX = data.1$MU_MAX, u_petro = data.1$u_petro, g_petro = data.1$g_petro,
                 r_petro = data.1$r_petro, i_petro = data.1$i_petro, j0861_petro = data.1$J0861_petro)
f4 <- data.frame(MU_MAX = data.1$MU_MAX, u_petro = data.1$u_petro, g_petro = data.1$g_petro,
                 r_petro = data.1$r_petro, i_petro = data.1$i_petro)
f5 <- data.frame(MU_MAX = data.1$MU_MAX, u_petro = data.1$u_petro, g_petro = data.1$g_petro, data.1$r_petro)
f6 <- data.frame(MU_MAX = data.1$MU_MAX, u_petro = data.1$u_petro, r_petro = data.1$r_petro)
f7 <- data.frame(MU_MAX = data.1$MU_MAX, r_petro = data.1$r_petro)
f8 <- data.frame(u_petro = data.1$u_petro, g_petro = data.1$g_petro,
                 i_petro = data.1$i_petro, r_petro = data.1$r_petro)
f9 <- data.frame(i_petro = data.1$i_petro, g_petro = data.1$g_petro)
features <- list(f1, f2, f3, f4, f5, f6, f7, f8, f9)

# For each result validation set the values for accuracy and Kappa will be stored in a vector, such as the time
results <- c()
duration <- c()

# Classification for each feature
for (i in 1:length(features)) {
  # Data normalization
  maxs <- apply(features[[i]], 2, max)
  mins <- apply(features[[i]], 2, min)
  normalization <- as.data.frame(scale(features[[i]], center = mins, scale = maxs - mins))
  
  # Training and validation
  ntrain <- round(0.75*nrow(data.1))
  ntest <- nrow(data.1) - ntrain
  
  # 75% of the data will be used for training and 25% will be used for validation
  ntrain <- round(0.75*nrow(data.1))
  ntest <- nrow(data.1) - ntrain
  
  # Setting a seed for reobtaining the same training results
  set.seed(100)
  index <- createDataPartition(data.1$class_Spec, p = 0.75, list = FALSE)
  xtrain <- normalization[index,]
  # the y variable must be factor type
  ytrain <- as.factor(data.1[index, 19])
  
  xtest <- normalization[-index,]
  ytest <- as.factor(data.1[-index, 19]) # normalization only has 12 columns
  
  ## Using the Support Vector Machines algorithm (SVM)
  t0 <- Sys.time()
  model_svm <- train(xtrain, ytrain, method = 'svmRadial', tuneLength = 10,
                     trControl = trainControl(method = 'cv'))
  duration <- c(duration, Sys.time() - t0)
  
  print(model_svm)
  
  prediction <- predict(model_svm, xtest)
  
  
  comparison <- data.frame(prediction, ytest)
  # Prediction table and values for the magnitude case
  tab_mag <- table(prediction, ytest)
  
  # Definition of accuracy function
  accuracy <- function(x){sum((diag(x)/sum(rowSums(x))))*100}
  
  # Accuracy of the magnitude
  mag_accuracy <- accuracy(tab_mag)
  results <- c(results, mag_accuracy)
}

print("Accuracy values:")
for (j in 1:length(results)) {
  print(paste("Feature", j, ": ", results[j], ". Duration:", duration[j]))
}
