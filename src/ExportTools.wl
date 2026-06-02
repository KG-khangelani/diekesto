BeginPackage["RuliologyUrbanDynamics`ExportTools`"]

ExportRunJSON::usage = "ExportRunJSON[result, path] exports a run association as JSON.";
ExportMetricsCSV::usage = "ExportMetricsCSV[metrics, path] exports metric associations as CSV.";
ExportFigure::usage = "ExportFigure[figure, path] exports a visual figure.";

Begin["`Private`"]

EnsureDirectory[path_String] := If[! DirectoryQ[DirectoryName[path]], CreateDirectory[DirectoryName[path], CreateIntermediateDirectories -> True]]

ExportRunJSON[result_Association, path_String] := Module[{},
  EnsureDirectory[path];
  Export[path, result, "JSON"]
]

ExportMetricsCSV[metrics_List, path_String] := Module[{keys, rows},
  EnsureDirectory[path];
  keys = Keys[First[metrics]];
  rows = Prepend[(Lookup[#, keys] & /@ metrics), keys];
  Export[path, rows, "CSV"]
]

ExportFigure[figure_, path_String] := Module[{},
  EnsureDirectory[path];
  Export[path, figure]
]

End[]
EndPackage[]
