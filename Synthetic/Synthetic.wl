(* ::Package:: *)

BeginPackage["Synthetic`"]


ICSTransformation::usage="ICSTransformation[ndata] Compute the transformation using the matrix of samples.";


ICSProduction::usage="ICSProduction[model] Create a new realisation using a transformation stored in model.";


ICSConstrainedProduction::usage="ICSConstrainedProduction[model,options] Create a new realisation using a transformation stored in model.
Select coordinates using \"Mask\". Process data with a filter function \"Filter\". Default filter is an identity function.";


Options[ICSProduction]={};
Options[ICSConstrainedProduction]={"Mask"->All, "Filter"->Function[{variable,mean,std},variable]};


Begin["`Private`"]


ICSTransformation[ndata_?MatrixQ,opt:OptionsPattern[]]:=Block[
{mean,cov,covsol,sdata,one,F,D2,V,Z,zc,DD,\[CapitalGamma],Zx,sortedPixels,zsimu,xsimu,hds,p,m,fg,GI},

{p,m}=Dimensions[ndata];
mean=Mean[ndata];
cov=Covariance[ndata];
covsol=LinearSolve[cov];
sdata=Map[#-mean&,ndata];
one=Function[ai,
With[{ci=covsol[ai]},
	(ai.ci)KroneckerProduct[ci,ai]
]];

F=one[sdata[[1]]];
Do[
	F+=one[sdata[[k]]],{k,2,Length[sdata]}
];
F=F/((p+2)m);
{D2,V}=Eigensystem[F];

Z=sdata.Transpose[V];
zc=Covariance[Z];
DD=SparseArray[Band[{1,1}]->1/Sqrt[Diagonal[zc]],{Length[Diagonal[zc]],Length[Diagonal[zc]]}];
\[CapitalGamma]=DD.V;
Zx=sdata.\[CapitalGamma]\[Transpose];
sortedPixels=Sort/@(Zx\[Transpose]);
hds=HistogramDistribution/@sortedPixels;
GI=LinearSolve[\[CapitalGamma]];
fg=Function[v,Evaluate[GI[v]]];

<|
"Mean"->mean,
"\[CapitalGamma]"->fg,
"Distributions"->hds
|>
]


ICSProduction[model_Association]:=model["\[CapitalGamma]"][RandomVariate/@model["Distributions"]]+model["Mean"] 


ICSConstrainedProduction[model_Association,opt:OptionsPattern[]]:=
Block[{mean,std,var,draw,data,maskedDistributions,mask},
mask=OptionValue["Mask"];
maskedDistributions=model["Distributions"][[mask]];
mean=Mean/@maskedDistributions;
std=StandardDeviation/@maskedDistributions;
var=RandomVariate/@maskedDistributions;
data=MapThread[OptionValue["Filter"],{var,mean,std}];
draw=ConstantArray[0,Length[model["Distributions"]]];
draw[[mask]]=data;
model["\[CapitalGamma]"][draw]+model["Mean"] 
]


End[]


EndPackage[]
