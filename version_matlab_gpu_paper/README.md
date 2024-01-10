# Contents

The script [`script_M_algorithm_gpu.m`](./script_M_algorithm_gpu.m) tries to obtain a binary _2-separating_
code through the GPU version of the M-algorithm described in the paper. The
desired dimensions $(M,n)$ of the code are set at the beginning of the script. 
In this version, a maximum of 100 resamples are performed; if the resulting
 code is not _2-separating_, the program stops.

This version is quite similar to the matlab basic version (folder [version_matlab_paper](../version_matlab_paper)).
