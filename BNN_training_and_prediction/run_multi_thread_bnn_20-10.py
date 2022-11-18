import csv, sys
import os,glob
import time
import argparse
import numpy as np
from numpy import *
import multiprocessing

run = 1
#models=["10 , 5","20 , 5"]

rseeds=5687

def my_job(arg):
	[i,count] = arg
	cmd="python3 bnn_runner_20-10.py -r %s -b %s" % (rseeds, i)
	print(cmd)
	if run:
		os.system(cmd)
	else:
		print(cmd)
list_args = []
count = 0
for i in range(10):
	list_args.append([i,count])
	count += 1
if __name__ =="__main__":
	pool = multiprocessing.Pool(len(list_args))
	pool.map(my_job, list_args)
	pool.close()

