# Contents

The script [`script_M_algorithm_matlab.m`](script_M_algorithm_matlab.m) tries to obtain a _binary 2-separating
code_ through a Matlab implementation of the M-algorithm described in the references. 

The desired dimensions $$(M,n)$$ of the code are set at the beginning of the script. In this version, a maximum of
100 resamples are performed. If the resulting code is not _2-separating_, the program stops.
