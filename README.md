# SOFTWARE FOR GENERATION OF BINARY 2-SEPARARING CODES

<a href="https://github.com/GTAC-ITEAM-UPV/separating-codes/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/GTAC-ITEAM-UPV/separating-codes?color=2b9348"></a>
<img alt="Stars" src="https://img.shields.io/github/stars/GTAC-ITEAM-UPV/separating-codes?style=flat-square&labelColor=343b41"/></td>
<img alt="Forks" src="https://img.shields.io/github/forks/GTAC-ITEAM-UPV/separating-codes?style=flat-square&labelColor=343b41"/></td>
<img alt="Issues" src="https://img.shields.io/github/issues/GTAC-ITEAM-UPV/tseparating-codesest?style=flat-square&labelColor=343b41"/></td>
<img alt="Pull Requests" src="https://img.shields.io/github/issues-pr/GTAC-ITEAM-UPV/separating-codes?style=flat-square&labelColor=343b41"/></td>


![GitHub all releases](https://img.shields.io/github/downloads/GTAC-ITEAM-UPV/separating-codes/total)


This repository contains the source code of several algorithms for **generation of separating codes**, written by Francisco José Martínez Zaldívar<sup>1</sup> and Víctor Manuel García Mollá<sup>2</sup>.

 

- [Overview](#overview)

- [Contents](#contents)

- [Acknowledgements](#ack) 
   
- [References](#references)






<sup>1</sup> Department of Communications. Universitat Politècnica de València, València (Spain)<br>
<sup>2</sup> Department of Informatics Systems and Computation. Universitat Politècnica de València, València (Spain)


<div id="overview">
 
## Overview 

This software addresses the generation of *binary 2-separating codes*, and the study of the code rates
that can be achieved in practice. 

In a *separating code* any two disjoint subsets (of maximum
specified size) of code words have at least one position in which the sets of entries are disjoint. In
the case of *binary 2-separating codes* there exist lower and upper theoretical bounds in the rates
that can be achieved. 

The generation of 2-separating codes has been studied in the literature from a theoretical
point of view, but, as far as we know, it has not been tackled from a practical point of view. 
Here we consider two different generation algorithms. The first one is inspired
by the Moser-Tardos algorithm, based on the Local Lovàsz Lemma. This algorithm has a strong
theoretical appeal; codes obtained through this first algorithm can be shown to match the best
known lower bound. A second algorithm has been implemented, which was designed to generate
codes with rates as large as possible. The rates achieved are larger than those achieved with
the first algorithm, but they still are very far form the theoretical upper bound. 

</div>


<div id="contents">

## Contents

- The folder [`version_matlab_paper`](./version_matlab_paper/) has a version that only needs Matlab.

- The folder [`version_matlab_gpu_paper`](./version_matlab_gpu_paper/) has a version that requires Matlab, a CUDA programmable GPU and the Matlab Parallel Toolbox.

- The folder [`version_cuda_seq_add`](./version_cuda_seq_add/) has a CUDA version of the sequential addition algorithm. Requires a CUDA programmable GPU and the 
nvcc CUDA compiler.

</div>



<div id="ack">

## Acknowledgements

This work was supported in part by MICIN under grant PID2021-125736OB-I00 (MCIN/AEI
/10.13039/501100011033/, “ERDF A way of making Europe”), and by GVA under grant
CIPROM/2022/20. 

</div>




<div id="references">

## References

[1] Y. L. Sagalovich, _Separating systems_, Problemy Peredachi Informatsii 30 (2) (1994) 14–35.

[2] Y. L. Sagalovich, _Separating systems_, Problems Inform. Transmission 30 (2) (1994) 105–123.

[3] A. Barg, G. R. Blakley, G. A. Kabatiansky, _Digital fingerprinting codes: Problem statements,
constructions, identification of traitors_, IEEE Transactions on Information Theory 49 (4)
(2003) 852–865.

[4] J. Moreira, M. Fernández, G. Kabatiansky, _Almost separating and almost secure frameproof
codes over q-ary alphabets_, Des. Codes Cryptogr. 80 (1) (2016) 11–28.

[5] J. Körner, G. Simonyi, _Separating partition systems and locally different sequences_, SIAM
journal on discrete mathematics 1 (3) (1988) 355–359.

[6] I. V. Vorob’ev, V. S. Lebedev, _Improved upper bounds for the rate of separating and completely
separating codes_, Probl. Inf. Transm. 58 (3) (2022) 242–253.

[7] P. Erdös, L. Lovàsz, _Problems and results on 3-chromatic hypergraphs and some related
questions_, Infinite and finite sets 10 (1975) 609–627.

[8] R. A. Moser, _A constructive proof of the Lov´asz local lemma_, in: Proceedings 41st Annual
ACM Symposium on Theory of Computing (STOC), ACM, 2009, pp. 343–350.

[9] R. A. Moser, G. Tardos, _A constructive proof of the general Lovàsz local lemma_, Journal of
the ACM (JACM) 57 (2) (2010) 11.

[10] I. Giotis, L. Kirousis, K. I. Psaromiligkos, D. M. Thilikos, _On the algorithmic Lov´asz local
lemma and acyclic edge coloring_, in: Proceedings of the twelfth workshop on analytic algorithmics
and combinatorics, Society for Industrial and Applied Mathematics, 2015, pp. 16–25.

[11] M. Fernández, J. Livieratos, _Algorithmic aspects on the construction of separating codes_, in:
Analysis of Experimental Algorithms - Special Event, SEA2 2019, Kalamata, Greece, June 24-
29, 2019, Revised Selected Papers, Vol. 11544 of Lecture Notes in Computer Science, Springer,
2019, pp. 513–526.

[12] NVIDIA Corporation, _NVIDIA CUDA Compute Unified Device Architecture Programming
Guide_, NVIDIA Corporation, 2007.

[13] J. Spencer, _Asymptotic lower bounds for ramsey functions_, Discrete Mathematics 20 (1977)
69–76.

[14] _MATLAB, version 9.8.0.1323502 (R2020a)_, Natick, Massachusetts, 2020.

[15] _MATLAB, Parallel computing toolbox version 7.2_ (r2020a) (2022).

</div>



