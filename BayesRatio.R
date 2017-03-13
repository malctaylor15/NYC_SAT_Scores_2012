
setwd("C:/Users/board/Desktop/Kaggle/SAT_Scores")

source("MeanScoreByBorough.R")

state <- "Bronx" 

test <- col_names[3]

mean(data5[,test])

score <-mean(data5$SAT.Math.Avg..Score)


ConditionalTable <- data.frame(matrix(0, nrow = 35, ncol = 6))
names(ConditionalTable)[1:6] <- c("Borough", "Test", "p_state", "p_score",
                                  "p_state_score", "p_score_state")
index <- 1
for (state in bor_names_first){
  for(test in col_names2){ 

  p_state <- length(which(data5$Borough == state)) / nrow(data5)

  p_score <- length(which(data5[, test] > score)) / nrow(data5)

  p_state_score <- length(which(data5[, test] > score & data5$Borough == state)) / length(which(data5[, test] > score))

  p_score_state <- length(which(data5[, test] > score & data5$Borough == state)) / length(which(data5$Borough == state)) 

  ConditionalTable[index ,1:6] <- c(state, test, p_state, p_score, 
                             p_state_score, p_score_state)

  index <- index + 1 
}
}



BayesFactors <- data.frame(matrix(0, nrow = 10, ncol = 4))
names(BayesFactors)[1:4] <- c("Test", "State_top", "State_bottom", "BayesFactor")

index <- 1 

for(state_t_index in 1:length(bor_names_first)){
  
  state_top <- bor_names_first[state_t_index]
  state_b_start_i <- state_t_index + 1 
  
  if (state_b_start_i <= length(bor_names_first)){
  for(state_b_index in state_b_start_i:length(bor_names_first)){
    
    state_bottom <- bor_names_first[state_b_index]
    
    row_top <- which(ConditionalTable$Borough == state_top & 
                       ConditionalTable$Test == test)
    row_bottom <- which(ConditionalTable$Borough == state_bottom & 
                          ConditionalTable$Test == test)
    
    BF <- as.double(ConditionalTable$p_score_state[row_top])/as.double(ConditionalTable$p_score_state[row_bottom])
    
    BayesFactors[index, 1:4] <- c(test, state_top, state_bottom, BF)
    index <- index + 1 
  
      }
  }
}
 
(BayesFactors <- BayesFactors[order(BayesFactors$BayesFactor, decreasing = T),])




