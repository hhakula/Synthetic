(* ::Package:: *)

BeginPackage["SyntheticMNIST`"]


ReadDatabase::usage="ReadDatabase[target] Read database from the paths pointed to by 
target[\"Labels\"] and target[\"Images\"]"


PickDigits::usage="PickDigits[digit,db] Select data of digit from database db."


ViewRefDigit::usage="ViewRefDigit[L] Show L as a pixel map."


ViewSyntheticDigit::usage="ViewSyntheticDigit[L] Show L as a scaled pixel map."


Begin["`Private`"]


Options[ReadDatabase]={"Mirror"->False};
ReadDatabase[target_Association,opt:OptionsPattern[]]:=Block[{X,Y},
(* There are 8 bytes of metadata at the beginning of the file. *)
Y = BinaryReadList[target["Labels"]];
Y = Delete[Y,{{1},{2},{3},{4},{5},{6},{7},{8}}];
(* There are 16 bytes of metadata at the beginning of the file. The images are 28x28 pixel tables. *)
X = BinaryReadList[target["Images"]];
X = Delete[X,{{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16}}];
X =Join[Table[0,{2*32}],Riffle[Riffle[Riffle[Riffle[
#,0,{1,28*29,29}],0,{1,28*30,30}],0,{31,28*31,31}],0,{32,28*32,32}],Table[0,{2*32}]] &/@ Partition[X,28*28];
If[OptionValue["Mirror"],
X=Flatten[Transpose[Partition[#,32]]]&/@X;
];
<|
"Labels"->Y,
"Images"->X
|>
]


PickDigits[digit_Integer,db_Association]:=Pick[db["Images"],db["Labels"],digit]


ViewRefDigit[L_] := Image[Abs[Partition[L,32][[3;;-3,3;;-3]]-1-255],"Byte",ImageSize->Small]


ViewSyntheticDigit[L_] := Image[Identity[Partition[Rescale[-L,MinMax[-L],{0,255}],32][[3;;-3,3;;-3]]],"Byte",ImageSize->Small]


End[]


EndPackage[]
