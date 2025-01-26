
01: Setting the models for the Maximum Likelihood analysis. 

02: Run the srcipt 00_ML_212sp.sh

03: 

    tail -n +1 */*mean.params* > ml_estimates_ML_all.txt
-> To extract all the rates and build the empirical bayesian models.

    tail -n +1 */*modelstat.txt* > modelstat_ML.txt
-> Extract AIC, BIC etc.

04: Produce empirical Bayesian models (in /models/Bayes/)

05: Launch Bayes_pp_212sp.sh

06: Collect the marg likelihood values ( tail */*marginal.likelihood.txt> marg_likelihood.txt) for every model and calculate the weights

07: Blend the Bayesian models together with the appropriate weights using blend_Bayes.sh

08: Merge models two by two: script merge_Bayes_pp.sh

09: Launch the dtests: dtests.sh






