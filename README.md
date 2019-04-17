# Synthetic

This project introduces the invariant coordinate selection (ICS) transformation method for creating synthetic data.
The algorithm is implemented both in Mathematica and MATLAB in the initial version. Since only linear algebra routines
are needed, porting the transformation to other platforms should be relatively straightforward.

In the examples two different cases are examined. In the ideal case the initial data set is constructed so that the
transformation is exact and all the errors are due to discrete sampling error. In the second case, synthetic handwriting
samples are generated using the MNIST database. Here the emphasis is not on generating the best possible synthetic
samples but to illustrate the performance of the basic method as is.
