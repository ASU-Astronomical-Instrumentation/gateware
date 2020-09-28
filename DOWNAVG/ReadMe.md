# Averaging and Downcovert IP 

This ip will take sequential inputs, add them together, then divide them by two. To increase 
the average length wrappers are used (lengths scale by 2^N).

Mathematical equivalent would be.

<a href="https://www.codecogs.com/eqnedit.php?latex=\\&space;f_0[n]&space;=&space;\frac{x[2n]&space;&plus;&space;x[2n&plus;1]}{2}&space;\\&space;\\&space;f_1[n]&space;=&space;\frac{f_0[2n]&space;&plus;&space;f_0[2n&plus;1]&space;}{2}&space;\\&space;\\&space;f_N[n]&space;=&space;\frac{&space;f_{N-1}[2n]&space;&plus;&space;f_{N-1}[2n&plus;1]&space;}{2}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\\&space;f_0[n]&space;=&space;\frac{x[2n]&space;&plus;&space;x[2n&plus;1]}{2}&space;\\&space;\\&space;f_1[n]&space;=&space;\frac{f_0[2n]&space;&plus;&space;f_0[2n&plus;1]&space;}{2}&space;\\&space;\\&space;f_N[n]&space;=&space;\frac{&space;f_{N-1}[2n]&space;&plus;&space;f_{N-1}[2n&plus;1]&space;}{2}" title="\\ f_0[n] = \frac{x[2n] + x[2n+1]}{2} \\ \\ f_1[n] = \frac{f_0[2n] + f_0[2n+1] }{2} \\ \\ f_N[n] = \frac{ f_{N-1}[2n] + f_{N-1}[2n+1] }{2}" /></a>


where N is the number of stages

### Status

- Individal Modules have been tested with a sawtooth waveform. 

- Though a large module should be re-tested for 32b operation. 

- (also since we aren't constraining ourselves to arbitrary bit widths we could also experiment with other ways of averaging...)
