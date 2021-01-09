from random import randint,seed
seed(10)
N=16
base = f"{N}'h"
after=","
d=[]
for i in range(32):
    d.append(base+hex(randint(17,2**N-1))[-4:]+after)

for D in d: print(D)