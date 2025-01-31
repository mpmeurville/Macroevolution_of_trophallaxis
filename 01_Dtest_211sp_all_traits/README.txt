

01: Produce empirical Bayesian models (in /models/Bayes/)

02: Launch 02_Bayes_pp_212sp.sh (produce the inference for all models)

03: Collect the marg likelihood values ( tail */*marginal.likelihood.txt> marg_likelihood.txt) for every model and calculate the weights

04: Blend the Bayesian models together **with the appropriate weights** collected at the previous step, using 03_blend_212_sp.sh

05: Merge models two by two: script 04_merge_212sp.sh. Merge each trait with trophallaxis.

09: Launch the script 05_d-tests_212sp.sh to calculate the correlations. 






