
setwd("C:/Users/board/Desktop/Kaggle/SAT_Scores")

source("MeanScoreByBorough.R")

# Remove non relevant variables 
# rm("data2", "filtered_s_data", "bor_first", "bor_last",
#    "bors", "bor_names_first", "bor_names_last", "continous_var_names", 
#    "col_names", "col_names2", "filt_DBN", "i",
#    "index", "name", "same_mean", "temp_mean_values", "temp_pval",
#    "ttester", "borough_checker")

den1 <- density(data5[data5$Borough == "Bronx" ,3] )

den2 <- density(data5[ ,3])
plot(den2)
lines(den1)

# Save unique boroughs 
borough_name <- unique(data5$Borough)
numb_bor <- length(borough_name)

# Function to generate data for density of data and normal approximation 
bor_density_and_norm <- function(bor_col_data, col_name, numb_std_away = 3) {
  bor_density <- density(bor_col_data)
  bor_mean <- mean(bor_col_data)
  bor_sd <- sd(bor_col_data)
  distance_from_mean <- numb_std_away * bor_sd
  norm_quantiles <- seq(from = bor_mean - distance_from_mean,
                        to = bor_mean + distance_from_mean, length = 512)
  bor_norm_density <- dnorm(norm_quantiles, mean = bor_mean,
                            sd = bor_sd)
  # Plot the smoothed density
  plot(bor_density$x, bor_density$y, 
       col = "red", type = 'l', lwd = 3,
       main = col_name, xlab = "Score Value", ylab = "Probability")
  # Plot the histogram 
  hist(bor_col_data, breaks = 30 , add = T , 
       probability = T, col = rgb(0, 1, 0, 0.3))
  # Add the normal assumption 
  lines(norm_quantiles, bor_norm_density, lwd = 3)
  # Plot the mean 
  abline(v=bor_mean, lwd = 3, col = "blue")
  # Create legend 
  legend("topright", 
         c("Smoothed Density", "Histogram", "Normal Assumption", "Mean"),
         col = c("red", rgb(0, 1, 0, 0.7), "black", "blue"), lwd = 3)
  
  return (data.frame(bor_density$x, bor_density$y,
                     bor_norm_density, norm_quantiles))
}


# Pre allocate space 
borough_densities <- data.frame(matrix(0, nrow = 512, ncol = 4 * numb_bor))
# The number of rows is 512 because that is the default for the density command   

index <- 1
for (bor in borough_name) {
  borough_densities[ , c(index, (index+1), (index+2), (index+3) )] <- 
    bor_density_and_norm(data5[data5$Borough == bor, 3], c(bor, " ", "MATH") ) 
  index <- index + 4
}

prior_den <- density(data5[ , 3])
prior_mean <- mean(data5[,3])
prior_sd <- sd(data5[, 3])
