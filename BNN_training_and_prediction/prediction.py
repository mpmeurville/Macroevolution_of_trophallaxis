import sys
import argparse
import numpy as np
np.set_printoptions(suppress=True, precision=3)
# load BNN package
import np_bnn as bn

# Collect arguments
p = argparse.ArgumentParser()
p.add_argument('-p', type=str, help='path')
#p.add_argument('-w', type=str, help='n. nodes', default = [64], nargs="+")

args=p.parse_args()
path_to_pkl = args.p

new_dat = bn.get_data(f="./input/prediction_traits.txt",
                      header=1, # input data has a header
                      instance_id=1) # input data includes names of instances


#comb_file = bn.combine_pkls(dir="./output/%s" % path_to_pkl, tag = "l%s" % path_to_pkl)
comb_file = bn.combine_pkls(dir="./output/%s" % path_to_pkl, tag = "%s" % path_to_pkl)


#print("./output/%s" % path_to_pkl)
#print("l%s" % path_to_pkl)

post_pr_new = bn.predictBNN(new_dat['data'],
                            pickle_file = comb_file,
                            instance_id=new_dat['id_data'],
                            fname=new_dat['file_name'])
