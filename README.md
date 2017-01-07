# NYC_SAT_Scores_2012
By Borough analysis of 2012 SAT scores

The data is the most recent school level results for New York City on the SAT from datazar. 

The data set contains the following columns- 

1. Unique school identifier
2. School Name 
3. Number of Sat Test Takers
4. SAT Critical Reading Average Score 
5. SAT Math Average Score 
6. SAT Writing Average Score 

# Analysis 

In this analysis, I remove the columns with missing (or incomplete) data. They have an 's' in place of the SAT information. 
We are able to obtain the borough from the unique school identifier. 
After we obtain the borough we can visually compare the distribution of each SAT score against the other boroughs. 
Finally we use a t test to compare the means to determine which scores are the same.
(Null hypothesis is that the difference is 0)

# Results 
* We find that 12 of the SAT scores between the 5 boroughs are statistically similar.
* All 3 of the scores (Reading, Math, Writing) are statistically similar within Manhattan, Queens and Staten Island. 
  ..* This accounts for 9 scores (M = Q, M = SI, Q = SI for 3 scores)
* All 3 of the scores (Reading, Math, Writing) are statistically similar within Brooklyn and the Bronx. 
* The scores of the Manhattan Group are higher than those of the Brooklyn Group. 


## Thank You
I would like to thank @CoolDatasets on twitter for initially telling me about this dataset. 

I would appreciate any feedback on the analysis and code. 

Data was found first found here
https://www.datazar.com/file/f0a5ba9a7-d895-476d-9696-79a19ed2f733 

