import sys
import argparse
#import os
import numpy as np
np.set_printoptions(suppress=True, precision=3)
# load BNN package
#import np_bnn as bn
#import sys
#sys.path.insert(0, '~/Documents/troph_inference/BNN/evolutionnary_analysis/npBNN-0.1.12/') 
#from np_bnn import BNN_env, BNN_files, BNN_lib, BNN_mcmc, BNN_plot

import np_bnn as bn

# Collect arguments
p = argparse.ArgumentParser()
p.add_argument('-r', type=int, help='seed', default = 1234)
#p.add_argument('-w', type=str, help='n. nodes', default = [64], nargs="+")
p.add_argument('-b', type=int, help='cross validation batch', default = 0)

args=p.parse_args()
rseed = args.r
batch = args.b
#dataset_nb = args.n

# load data (2 files: features and labels)
f= "./input/feat_train.txt"
l= "./input/troph_train.txt"

# with testsize=0.1, 10% of the data are randomly selected as test set
# if all_class_in_testset = 1: 10% of the samples and a minimum of 1 sample
# for each class are represented in the test set
cross_validation_batch = batch # cross validation (1st batch; set to 1,2,... to run on subsequent batches)


dat = bn.get_data(f,l,
                  seed=rseed,
                  testsize=0.1, # 10% test set
                  all_class_in_testset=1,
                  header=1, # input data has a header
                  cv=cross_validation_batch,
                  instance_id=1) # input data includes names of instances


# set up model architecture and priors
n_nodes_list = [20, 10] # 2 hidden layers with 5 nodes each
# default ReLU:
activation_function = bn.ActFun(fun="ReLU")
# to use a leaky ReLU (set trainable=True for generalized ReLU):
# alphas = np.zeros(len(n_nodes_list)) + 0.01
# activation_function = bn.ActFun(fun="genReLU", prm=alphas, trainable=False)
# alternatively for swish function:
# activation_function = bn.ActFun(fun="swish")
prior = 1 # 0) uniform, 1) normal, 2) Cauchy, 3) Laplace
p_scale = 1 # std for Normal, scale parameter for Cauchy and Laplace, boundaries for Uniform
use_class_weight = 0 # set to 1 to use class weights for unbalanced classes
init_std = 0.1 # st dev of the initial weights
use_bias_node = 3 # 0) no bias node, 1) bias in input layer, 2) bias in input and hidden layers, 3) bias in input/hidden/output
# set up the BNN model
bnn_model = bn.npBNN(dat,
                     n_nodes = n_nodes_list,
                     use_class_weights=use_class_weight,
                     actFun=activation_function,
                     use_bias_node=use_bias_node,
                     prior_f=prior,
                     p_scale=p_scale,
                     seed=rseed,
                     init_std=init_std)


# set up the MCMC environment
sample_from_prior = 0 # set to 1 to run an MCMC sampling the parameters from the prior only

mcmc = bn.MCMC(bnn_model,
               update_f=[0.05, 0.05, 0.07],
               update_ws=[0.075, 0.075, 0.075],
               temperature = 1,
               n_iteration= 5000,#2000000,
               sampling_f=10,
               print_f=1000,
               n_post_samples=100,
               sample_from_prior=sample_from_prior,
               likelihood_tempering=1,
               adapt_f=0.3,
               adapt_fM=0.6)



# initialize output files
out_file_name = "./output/20_10_feat_perm/BNN_cv%s" % cross_validation_batch
logger = bn.postLogger(bnn_model, filename=out_file_name, log_all_weights=0)

# run MCMC
bn.run_mcmc(bnn_model, mcmc, logger)

# make predictions based on MCMC's estimated weights
# test data
post_pr_test = bn.predictBNN(dat['test_data'],
                             pickle_file=logger._pklfile,
                             test_labels=dat['test_labels'],
                             instance_id=dat['id_test_data'],
                             fname=dat['file_name'],
                             post_summary_mode=0)

post_pr_test['confusion_matrix']

# determine feature importance with test data
#feature_importance = bn.feature_importance(dat['test_data'], 
#                                           weights_pkl=logger._pklfile,
#                                           true_labels=dat['test_labels'],
#                                           fname_stem=dat['file_name'],
#                                           feature_names=dat['feature_names'],
#                                           n_permutations=100,
#                                           feature_blocks = [[0,1,2,3,4,5,6,7,8,9,10],[11],[12],[13,14,15,16],[17,18],[19,20], [21]],
#                                           unlink_features_within_block = True)

feature_importance = bn.feature_importance(dat['test_data'], 
                                           weights_pkl=logger._pklfile,
                                           true_labels=dat['labels'],
                                           fname_stem=dat['file_name'],
                                           feature_names=dat['feature_names'],
                                           n_permutations=100,
                                           feature_blocks = [[0,1,2,3,4,5,6,7,8,9,10],[11],[12],[13,14,15,16],[17,18],[19,20],[21]],
                                           unlink_features_within_block = True)

# train+test data
dat_all = bn.get_data(f,l,
                      testsize=0, # no test set
                      header=1, # input data has a header
                      instance_id=1) # input data includes names of instances

post_pr_all = bn.predictBNN(dat_all['data'],
                            pickle_file=logger._pklfile,
                            test_labels=dat_all['labels'],
                            instance_id=dat_all['id_data'],
                            fname="all_data")


# Get the threshold tradeoffs

import numpy as np
import pandas as pd
sys.path.insert(0, r'~/Documents/troph_inference/BNN/evolutionnary_analysis/npBNN-0.1.12/np_bnn/')
import np_bnn as bn
#predict
post_pr_test = bn.predictBNN(dat['test_data'],
				pickle_file=logger._pklfile,
				test_labels=dat['test_labels'],
				instance_id=dat['id_test_data'],
				fname=dat['file_name'],
				post_summary_mode=1,
				threshold=0.95)

    # CALC TRADEOFFS
res = post_pr_test['post_prob_predictions']
labels=dat['test_labels']

tbl_results = []
for i in np.linspace(0.01, 0.99, 99):
        scores = bn.get_accuracy_threshold(res, labels, threshold=i)
        tbl_results.append([i, scores['accuracy'], scores['retained_samples']])

df = pd.DataFrame(tbl_results, columns =['Threshold','Accuracy','Retained_data'])
df = np.round(df, 3)



df.to_csv("./output/20_10/threshold_tradeoff_%s_batch%s.txt" % (rseed, batch) ,sep='	', index=False, header=True)

#print(df)


### predict new unlabeled data
#new_dat = bn.get_data(f="./input/prediction_traits.txt",
#                      header=1, # input data has a header
#                      instance_id=1) # input data includes names of instances

#comb_file = bn.combine_pkls(dir="~/Documents/troph_inference/BNN/evolutionnary_analysis/output/10-5", tag = "l10_5")

#post_pr_new = bn.predictBNN(new_dat['data'],
#                            pickle_file=logger._pklfile,
#                            pickle_file = comb_file,
#                            instance_id=new_dat['id_data'],
#                            fname=new_dat['file_name'])


# ADDITIONAL OPTIONS
# to restart a previous run you can provide the pickle file with the posterior parameters
# when initializing the BNN environment
#pickle_file = logger._pklfile

#bnn_model = bn.npBNN(dat,
#                     n_nodes = n_nodes_list,
#                     use_bias_node = 1,
#                     prior_f = prior,
#                     p_scale = p_scale,
#                     pickle_file=pickle_file,
#                     seed=rseed,
#                     actFun=activation_function)

#mcmc = bn.MCMC(bnn_model,
#               update_f=[0.05, 0.04, 0.07],
#               update_ws=[0.075, 0.075, 0.075],
#               temperature = 1,
#               n_iteration=5000,
#               sampling_f=100,
#               print_f=1000,
#               n_post_samples=100)

# bn.run_mcmc(bnn_model, mcmc, logger)

