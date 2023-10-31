






00: Production of the files done with R (scripts folder).

01: Setting the models for the ML analysis. 

02: Run the srcipt 00_ML_212sp.sh

03: 

    tail -n +1 */*mean.params* > ml_estimates_ML_all.txt
-> To extract all the rates and build the empirical bayesian models.

    tail -n +1 */*modelstat.txt* > modelstat_ML.txt
-> Extract AIC, BIC etc.

04: Produce empirical Bayesian models: /home/meurvill/Documents/troph_inference/re-do_v1/01_Dtest_211sp_all_traits/models/Bayes/

04: Launch Bayes_pp_212sp.sh

05: Collect the marg likelihood values ( tail */*marginal.likelihood.txt> marg_likelihood.txt) for every model and calculate the weights : https://docs.google.com/spreadsheets/d/1md_IuRSf2DK05ctohloeGKb9IYHehIPDNnmHAlWeQo8/edit#gid=2046433936 on page Dtest_all_sp_no_thresh

06: Blend the Bayesian models together with the appropriate weights using blend_Bayes.sh

07: Merge models two by two: script merge_Bayes_pp.sh

08: Launch the dtests: dtests.sh

09: transfer the files on the computer :
        scp -r meurvill@biolpc182:~/Documents/troph_inference/smap/dataset_pred_verif/* D>




