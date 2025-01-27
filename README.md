This repo contains the files used for the analysis of the evolution of trophallaxis. 

- SI_File1.xlsx contains the data collected from literature and corresponding references. The legend is included in the file.
- SI_File2.xlsx contains the values of the first nine eigenvalues per species.
- SI_File3.xlsx contains the minimum and maximum values for temperature and humity used. 
- SI_File4.csv contains the predicted trophallaxis behavior for the 252 species.

* 01_Dtest_211sp_all_traits
  # Code and data to run the Dtest analysis.
  - input: files with the traits,
  - models/Bayes: the models used to run the ancestral state reconstruction,
  - scripts: to run the analysis for species with known trophallaxis behavior. Walkthroug in the dedicated README.

* 02_BNN: Predicting trophallaxis behaviour
  # contains the files necessary to train a Bayesian Neural Network for trophallaxis inference.
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
* 03_PGLS_212
  # Contains the files to replicates the phylogenetic path analysis and replicate Fig1. 
* contains the scripts for doing the PGL analyses with our 5 traits of interest
- 05_100_trees_gamma contains the data and scripts for infering the ancestral state of our traits of interest using sMap, on 100 trees.
- 07_subtree and 11_constrained_root contain the scripts for running the analyses on subtrees, and with fixed root node probabilities for the ambiguous traits at the corresponding node.
- 08_speciation contains the scripts to run the speciation / extinction analyses with BAMM and HiSSE. 
