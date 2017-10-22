
# Packages used 
library(dplyr)
library(sm)             

# Set working directory 
setwd("C:/Users/board/Desktop/Kaggle/SAT_Scores")

# import data 
data2 <- read.csv("New_York_City_SAT_Results.csv")

# Look into data 
colnames(data2)
head(data2)
summary(data2)

# Save column names of continous variables 
continous_var_names <- colnames(data2)[3:6]

# There is an s character in some rows 
# Use dplyr package to help get rid of those rows 
library(dplyr)
# Remove columns where 's' is in the writing average score 
filtered_s_data <- filter(data2, data2[[6]] !='s')
# Make sure there are no more 's's 
summary(filtered_s_data)
# Want to convert continous variables to integers* 
data5 <- data.frame(apply(filtered_s_data[,3:6], 2,
               function(x) as.numeric(x)))

# Check 
summary(data5)
hist(data5[[2]], main = "Critical Reading of All Boroughs"
     , xlab = "Critical Reading Score") 

# Create column of borough - we know it is embedded in the DBN code 

# Function that returns borough if the DBN string contains one of the characters 
borough_checker <- function(code){
  borough <- 'NA'
  if(grepl('X' ,code)) borough <- "Bronx"
  if(grepl('K', code)) borough <- "Brooklyn"
  if(grepl('Q', code)) borough <- "Queens"
  if(grepl('M', code)) borough <- "Manhattan"
  if(grepl('R', code)) borough <- "Staten Island"

  return(borough)
}

# Save DBN's separately  
filt_DBN <- as.character(filtered_s_data$DBN)

# Preallocate space for boroughs 
bors <- rep(0,length(filt_DBN))

# For loop to check each entry and check the boroughs 
for ( i in 1:length(filt_DBN)){
  bors[i] <- borough_checker(filt_DBN[i]) 
}

# Count how many rows were not assigned a borough 
sum(bors == "NA")

# Combine boroughs with filtered data 
data5$Borough <- as.factor(bors)

# Mean of columns by borough 
aggregate(data5[,1:4], by=list(data5[,5]), FUN=mean)    



# Plot densities for all types of one column 
library(sm)             

# Plot densities for each test by Borough 
for (i in 1:4){
sm.density.compare(data5[,i], data5$Borough,
                   lwd = 3,
                   xlab = colnames(data5)[i])
# Add title to plot 
title(main = colnames(data5)[i])
# Add legend to plot 
legend("topright", levels(data5$Borough), fill=2+(0:nlevels(data5$Borough)))
}

# Need these two for the loop
bor_names_first <- unique(bors)
bor_names_last <- bor_names_first

col_names <- colnames(data5)
# Remove Borough column 
col_names2 <- col_names[-5]

# Pre allocate space for data frames 
df <- data.frame(matrix(0, nrow = 5*4*2, ncol = 7))
# Name columns 
names(df)[1:7] <- c("CategoryName", "Borough1", "Borough2", "P-value", 
                    "Borough 1 Score", "Borough 2 Score" ,"Mean the same" )

# Compare each borough series against each other for the same category 
index <- 1
for (bor_first in bor_names_first){
  # Remove first element in borough array (the one that will be compared)
  bor_names_last <- bor_names_last[-1]
  # Loop through second list of boroughs 
  for (bor_last in bor_names_last){
    # Loop through the various categories of tests
    for (name in col_names2 ){
    # Conduct hypothesis test for similar means 
    ttester <- t.test(data5[data5$Borough == bor_first, name],
                      data5[data5$Borough == bor_last, name])
    # Store temp p value 
    temp_pval <- ttester$p.value
    # H0 mean are the same 
    # P low reject H0 --> Bx mean =/= bor mean
    same_mean <- if(abs(temp_pval) < 0.05) F else T
    temp_mean_values <- ttester$estimate
    # Store values to data frame 
    df[index,1:7] <- c(name, bor_first, bor_last, temp_pval, 
                       temp_mean_values ,same_mean)
    # Increase data frame index 
    index <- index+1
    
    }
  }
}


# Number of similar statistics
length(which(df$`Mean the same` == T))
# Similar statistics 
df[which(df$`Mean the same` == T),]
