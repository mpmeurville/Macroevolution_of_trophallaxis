### Bayes Factor calculation 


### Troph subtree : Higher Marg likelihood = best model
marg_r1_ARD = -79.4151367889462
marg_r1_ER = -79.05961379188611
marg_r0_ARD = -83.65635049510196
marg_r0_ER = -84.3443167018145

BF1ARD = 2*(marg_r1_ER - marg_r1_ARD)

BF0ARD = 2*(marg_r1_ER - marg_r0_ARD)

BF0ER = 2*(marg_r1_ER - marg_r0_ER)

# Probabilities
p1 = exp(marg_r1_ER) /(exp(marg_r1_ARD) + 
                    exp(marg_r1_ER) +
                    exp(marg_r0_ARD) +
                    exp(marg_r0_ER))

p2 = exp(marg_r1_ARD) /(exp(marg_r1_ARD) + 
                         exp(marg_r1_ER) +
                         exp(marg_r0_ARD) +
                         exp(marg_r0_ER))
p3 = exp(marg_r0_ER) /(exp(marg_r1_ARD) + 
                         exp(marg_r1_ER) +
                         exp(marg_r0_ARD) +
                         exp(marg_r0_ER))

p4 = exp(marg_r0_ARD) /(exp(marg_r1_ARD) + 
                         exp(marg_r1_ER) +
                         exp(marg_r0_ARD) +
                         exp(marg_r0_ER))

p1 + p2
# Proba root 1 = p1 + p2 = 99 %


### Gamergates subtree
marg_r1_ARD = -127.4557175
marg_r1_ER = -133.789655
marg_r0_ARD = -127.4292635
marg_r0_ER = -126.8114302
marg_r0_ARD_st = -132.04242092056654
marg_r0_ER_st = -133.86754435085822


BF1ARD = 2*(marg_r0_ER - marg_r1_ARD)
BF1ARD
BF1ER = 2*(marg_r0_ER - marg_r1_ER)
BF1ER
BF0ARD = 2*(marg_r0_ER - marg_r0_ARD)
BF0ARD
BF0ARDST = 2*(marg_r0_ER - marg_r0_ARD_st)
BF0ARDST
BF0ERST = 2*(marg_r0_ER - marg_r0_ER_st)
BF0ERST

# Probabilities
p1 = exp(marg_r1_ER) /(exp(marg_r1_ARD) + 
                         exp(marg_r1_ER) +
                         exp(marg_r0_ARD) +
                         exp(marg_r0_ER_st) +
                         exp(marg_r0_ARD_st) +
                         exp(marg_r0_ER))

p2 = exp(marg_r1_ARD) /(exp(marg_r1_ARD) + 
                          exp(marg_r1_ER) +
                          exp(marg_r0_ARD) +
                          exp(marg_r0_ER_st) +
                          exp(marg_r0_ARD_st) +
                          exp(marg_r0_ER))

p3 = exp(marg_r0_ER) /(exp(marg_r1_ARD) + 
                         exp(marg_r1_ER) +
                         exp(marg_r0_ARD) +
                         exp(marg_r0_ER_st) +
                         exp(marg_r0_ARD_st) +
                         exp(marg_r0_ER))

p4 = exp(marg_r0_ARD) /(exp(marg_r1_ARD) + 
                          exp(marg_r1_ER) +
                          exp(marg_r0_ARD) +
                          exp(marg_r0_ER_st) +
                          exp(marg_r0_ARD_st) +
                          exp(marg_r0_ER))

p5 = exp(marg_r0_ARD_st) /(exp(marg_r1_ARD) + 
                          exp(marg_r1_ER) +
                          exp(marg_r0_ARD) +
                          exp(marg_r0_ER_st) +
                          exp(marg_r0_ARD_st) +
                          exp(marg_r0_ER))

p6 = exp(marg_r0_ER_st) /(exp(marg_r1_ARD) + 
                          exp(marg_r1_ER) +
                          exp(marg_r0_ARD) +
                          exp(marg_r0_ER_st) +
                          exp(marg_r0_ARD_st) +
                          exp(marg_r0_ER))

p3 + p4 + p5 + p6
# Proba root 1 = p3 + p4 : 75%




### Troph subtree 47 ponerines : Higher Marg likelihood = best model
marg_r1_ARD = -29.9336922926059
marg_r1_ER = -29.8423280230929 # Best model
marg_r0_ARD = -31.2730438482335 
marg_r0_ER = -32.1873105177503

BF1ARD = 2*(marg_r1_ER - marg_r1_ARD)

BF0ARD = 2*(marg_r1_ER - marg_r0_ARD)

BF0ER = 2*(marg_r1_ER - marg_r0_ER)

# Probabilities
p1 = exp(marg_r1_ER) /(exp(marg_r1_ARD) + 
                         exp(marg_r1_ER) +
                         exp(marg_r0_ARD) +
                         exp(marg_r0_ER))

p2 = exp(marg_r1_ARD) /(exp(marg_r1_ARD) + 
                          exp(marg_r1_ER) +
                          exp(marg_r0_ARD) +
                          exp(marg_r0_ER))
p3 = exp(marg_r0_ER) /(exp(marg_r1_ARD) + 
                         exp(marg_r1_ER) +
                         exp(marg_r0_ARD) +
                         exp(marg_r0_ER))

p4 = exp(marg_r0_ARD) /(exp(marg_r1_ARD) + 
                          exp(marg_r1_ER) +
                          exp(marg_r0_ARD) +
                          exp(marg_r0_ER))

p1 + p2
# Proba root 1 = p1 + p2 = 85%