# Synthetic

This project introduces the invariant coordinate selection (ICS) transformation method for creating synthetic data.
The algorithm is implemented both in Mathematica and MATLAB in the initial version. Since only linear algebra routines
are needed, porting the transformation to other platforms should be relatively straightforward.

In the examples two different cases are examined. In the ideal case the initial data set is constructed so that the
transformation is exact and all the errors are due to discrete sampling error. In the second case, synthetic handwriting
samples are generated using the MNIST database. Here the emphasis is not on generating the best possible synthetic
samples but to illustrate the performance of the basic method as is.

## Getting Started

### Prerequisites
You must have a Mathematica license to run the full suite of examples. The MATLAB routines are available for the experienced
users only. It is assumed that the user can export the data from mathematica to MATLAB in some suitable way. We shall provide examples in the future versions.

### Installing
Install the Synthetic package to Mathematica's path.

## Testing
There are two Mathematica Notebooks for testing. Notice that the notebooks do not fit to the versioning model very well. The examples distributed here contain example outcomes and it is a good idea to keep the originals safe and test with copies only.

### Installing
Install the SyntheticMNIST package to Mathematica's path.

### Running Tests
In the ideal data case, change the number of realisations and see how the discrete sampling error changes the accuracy.
In the MNIST example, test with different filters.

## Authors
Harri Hakula

## Reference
H. Hakula, P. Ilmonen, SYNTHETIC AUGMENTATION OF DATASTREAMS WITH INVARIANT COORDINATE TRANSFORMATION, submitted, 2019.
