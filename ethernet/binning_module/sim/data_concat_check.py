BW=18
N_prl=4
BW_out=8

import random
def rand_key(p): 
    key1 = "" 
    for i in range(p): 
        temp = str(random.randint(0, 1)) 
        key1 += temp     
    return(key1) 
  
x=["100101011000001010","011001101100100000","111101001001110010","100001000001110011"]

for i in range(0, BW*N_prl//BW_out):
    print(f"{i}|",end="")
print()

xxx=""
for X in x:
    print(f"{X} - {hex(int(X,2))}")
    xxx+=X
print(xxx)
for i in range(0, BW*N_prl//BW_out):
    hi=BW_out*(i+1)-1
    lo=BW_out*i
    num=xxx[lo:hi]
    print(f"ind:{i} \t from {hi} to {lo} - {num} - {hex(int(num,2))}")

    
