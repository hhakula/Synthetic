(* ::Package:: *)

BeginPackage["Synthetic`"]


ICSTransformation::usage="";


ICSProduction::usage="";


Options[ICSTransformation]={"Verbose"->False};


Options[ICSProduction]={};
Options[ICSConstrainedProduction]={"Mask"->All, "Filter"->Function[{var,mean,std},var]};


Begin["`Private`"]


(* ::Code::Initialization:: *)
ICSTransformation[ndata_?MatrixQ,opt:OptionsPattern[]]:=Block[
{mean,cov,covsol,sdata,one,F,D2,V,Z,zc,DD,\[CapitalGamma],Zx,sortedPixels,zsimu,xsimu,hds,p,m,fg,GI},

{p,m}=Dimensions[ndata];
mean=Mean[ndata];
If[OptionValue["Verbose"],Echo["Covariance"]];
cov=Covariance[ndata];
If[OptionValue["Verbose"],Echo["Factorize"]];
covsol=LinearSolve[cov];
sdata=Map[#-mean&,ndata];
one=Function[ai,
With[{ci=covsol[ai]},
(ai.ci)KroneckerProduct[ci,ai]
]];

F=one[sdata[[1]]];
If[OptionValue["Verbose"],
Block[{up=Length[sdata]},
Monitor[Do[
	F+=one[sdata[[k]]],{k,2,up}
],{k,up}]
],
Do[
	F+=one[sdata[[k]]],{k,2,Length[sdata]}
];
];
F=F/((p+2)m);
{D2,V}=Eigensystem[F];

If[OptionValue["Verbose"],
Echo[D2];
Echo[ListPlot[D2,PlotRange->All]];
];

Z=sdata.Transpose[V];
zc=Covariance[Z];
DD=SparseArray[Band[{1,1}]->1/Sqrt[Diagonal[zc]],{Length[Diagonal[zc]],Length[Diagonal[zc]]}];
If[OptionValue["Verbose"],
Echo[DD];
Echo[ListPlot[DD,PlotRange->All]];
];
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


(* ::Code::Initialization:: *)
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
