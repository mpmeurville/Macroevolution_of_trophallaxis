This repo contains the files used for the analysis of the evolution of trophallaxis. 

- SI_File1.xlsx contains the data collected from literature and corresponding references. The legend is included in the file.
- SI_File2.xlsx contains the values of the first nine eigenvalues per species.
- SI_File3.xlsx contains the minimum and maximum values for temperature and humity used. 
- SI_File4.csv contains the predicted trophallaxis behavior for the 252 species.
- tree_212.tre contains the tree used with the 212 species with known trophallaxis behaviour.
- tree_417.tre contains the tree used with the 417 species with known and predicted trophallaxis behaviour. 

# 01_Dtest_211sp_all_traits
Code and data to run the Dtest analysis on 212 species.
  - input: files with the traits
    - clonal = whether species in clonal (C) or not (N)
    - col = colony size, small (S), medium (M), large (L)
    - GamOvSt = whether species are fully sterile (S). can lay haploid eggs (R), or lay diploid eggs (G)
    - Liq = Whther the species drinks sugary liquids (L) or not (N)
    - Ova = Whether the workers have ovaries (O) or not (N)
    - Sperm = Whether the workers have spermatheca (U) or not (N)
    - Sting = whether the workers have a sting (S) or not (N)
    - Troph = whether workers use trophallaxis (T) or not (N)
  - models/Bayes: the models used to run the ancestral state reconstruction (see the sMap manual for clarification on the format)
  - scripts: to run the analysis for species with known trophallaxis behavior. Walkthroug in the dedicated README.

# 02_BNN: Predicting trophallaxis behaviour
Contains the files necessary to train a Bayesian Neural Network for trophallaxis inference.
  - input contains the features (Features_train.txt) and labels (labels_train.txt) for training as well as the features for prediction (prediction_feature.txt)
  - npBNN-master contains the core model
  - run_5_5 contains
      - the 10 cross validations folders (CV0 to 9) containing bnn_classify.py script with your parameters
      - the script to launch the inference on the 10 cross validations: launch.sh
      - the stats of the model (models_stats) and the script to build the confusion matrix on the 10 CV
      - the outputs of the model:
          - the .log of the run
          - the .pkl of the trained model
          - the feature importance (feature_imp.csv)
          - the predicted trophallaxis behavior (prediction_feature_BNN_Full_p1_h0_l5_5_s1_binf_1234_pred_mean_pr.txt)

# 03_PGLS_212
Contains the script to replicates the phylogenetic path analysis and replicate Fig1. 
- PGLS_212.R: the script to run the analysis.
- The input files are located in the 01_Dtest_211sp_all_traits/input, and the tree used is tree_212.tre.

# 05_100_trees_gamma 
Contains the data and scripts for infering the ancestral state of our traits of interest using sMap, on 100 trees.

- 00_input_production
    - output contains the 100_trees_renamed.tre file, containing the 100 pruned trees with each 417 speices.
    - 100_trees_production.R takes the 100 trees produced by https://doi.org/10.1038/s41467-018-04218-4 and reduces them to our 417 species of interest. It takes as an input, tree_417.tre and the 100 unpruned trees.

- 01_input: Contains the 100 trees (in folder 100_trees) and 6 files containing the status of each trait:
    - clonal = whether species in clonal (C) or not (N)
    - col = colony size, small (S), medium (M), large (L)
    - GamOvSt = whether species are fully sterile (S). can lay haploid eggs (R), or lay diploid eggs (G)
    - Liq = Whther the species drinks sugary liquids (L) or not (N)
    - Sting = whether the workers have a sting (S) or not (N)
    - Troph = whether workers use trophallaxis (T) or not (N)

- Bayes/gamma22 contains the Bayes models for the sMap analysis on 100 trees.

- scripts contains the code to replicate the analysis:
    - 01_Bayes.sh: runs sMap on 100 trees for each model and each trait.
    - xx_blend.sh files are the scripts that allow the blending of the sMap outputs of the models on each tree, with the corresponding weights and for the respective xx trait. 
    - get_nodes_prob.sh: loops over each sMap output and collects the root node value for each tree and each trait.
    - ancestral_state_distr_100_trees.R: plots the distribution of the ancestral state for each trait (fig S4)
    - marg:lik_blend_100_trees.R: processes marginal likelihood data from Bayesian model analyses, extracts relevant values, calculates model weights, and generates bash scripts for blending models by trait.

      
# 11_constrained_root 
Contains the scripts for running the analyses on subtrees for **nodes with undlear trophallaxis behaviour** (ponerines, and Formicoid minus dorylines).
  - models/Bayes: contains the Bayes models for ponerines node being set to respectively 0 (workers don't use trophallaxis) and 1 (workers use trophallaxis), as well as the models for testing the unclear trophallaxis behaviour at the Formicoid minus dorylinae node (troph.model.ML.ARD.nex and troph.model.ML.ER.nex).
  - input: contains the input tree with 326 species and the corresponding trophallaxis trait status, and the 
  - scripts:
    - producing_input_files.R: produce the tree and dataset for running the analysis from the tree_417.tre and the trophallaxis data for the 417 sp. 
    - producing_input_files.R: produce reduced trees and datasets
    - 02_Bayes_pp_326.sh: run sMap on the models for the 326 species tree
    - 03_blend_326sp.sh: blend the models parameters form the previous step
    - 02_Bayes_47sp.sh: run sMap on the models for the 47 species tree
    - 03_blend_47sp.sh: blend the models parameters form the previous step
    - bayes_factor.R: calculate Bayes factor form the analyses

# 08_speciation 
Contains the scripts to run the speciation / extinction analyses with BAMM and HiSSE.
  - BAMM:
      - input: contains the input tree tree_417.tre, the species names that are valid according to AntWiki in 2022, the percentage of the genus represented in the tree (sampling_frac_genus.txt), the trophallaxis behaviour (input_binary.csv), the BAMM priors (myPriors.txt) and the BAMM parameters (ControlFile_redo.txt).
      - Scripts:
          - data_prep.R: shape the data
          - command_line.txt: run the BAMM analysis
          - analysis.R: analyse the BAMM results.
      - Output:
          - Contains the log (run_info_ReDo.txt), the mcmc (mcmc_out_ReDo.txt) and the events (event_data_ReDo.txt).
    - HiSSE: all_sp_analysis.R is the srcipt ran to conduct the HiSSE analysis. It takes as inputs the 15k_NCuniform_stem_mcc.tre from https://doi.org/10.1038/s41467-018-04218-4 and troph_417.txt.
