# SOFTWARE FOR GENERATION OF BINARY 2-SEPARARING CODES


This repository contains the source code of three algorithms for **generation of separating codes**, written by Francisco José Martínez Zaldívar<sup>1</sup> and Víctor Manuel García Mollá<sup>2</sup>.

 

- [Overview](#overview)
  
- References

- Contents

- The folder `version_matlab_paper` has a version that only needs Matlab.

- The folder `version_matlab_gpu_paper` has a version that requires Matlab, a CUDA programmable GPU and the Matlab Parallel Toolbox.

- The folder `version_cuda_seq_add` has a CUDA version of the sequential addition algorithm. Requires a CUDA programmable GPU and the 
nvcc CUDA compiler.

<sup>1</sup> Department of Communications. Universitat Politècnica de València, València (Spain)
<sup>2</sup> Department of Informatics Systems and Computation. Universitat Politècnica de València, València (Spain)


<div id="overview">
 
## Overview 

This software addresses the generation of *binary 2-separating codes*, and the study of the code rates
that can be achieved in practice. 

In a separating code any two disjoint subsets (of maximum
specified size) of code words have at least one position in which the sets of entries are disjoint. In
the case of binary 2-separating codes there exist lower and upper theoretical bounds in the rates
that can be achieved. 

The generation of 2-separating codes has been studied from a theoretical
point of view, but, as far as we know, it has not been tackled from a practical point of view. In
this paper we consider and analyze two different generation algorithms. The first one is inspired
by the Moser-Tardos algorithm, based on the Local Lov´asz Lemma. This algorithm has a strong
theoretical appeal; codes obtained through this first algorithm can be shown to match the best
known lower bound. A second algorithm has been implemented, which was designed to generate
codes with rates as large as possible. The rates achieved are larger than those achieved with
the first algorithm, but they still are very far form the theoretical upper bound. 

</div>
