BeginPackage["RuliologyUrbanDynamics`Morphologies`"]

CreateMorphology::usage = "CreateMorphology[type, gridSize] creates a synthetic morphology association.";
OpenGridMorphology::usage = "OpenGridMorphology[gridSize] creates a morphology with uniform accessibility.";
BarrierMorphology::usage = "BarrierMorphology[gridSize] creates a morphology with a vertical barrier and configurable gap.";
CorridorMorphology::usage = "CorridorMorphology[gridSize] creates a morphology with cross-shaped high accessibility corridors.";
MorphologyToAccessibility::usage = "MorphologyToAccessibility[morphology] returns the numeric accessibility mask for a morphology.";

Begin["`Private`"]

ClipMask[m_] := Clip[N[m], {0, 1}]

OpenGridMorphology[gridSize_Integer?Positive] := <|
  "Type" -> "OpenGrid",
  "GridSize" -> gridSize,
  "AccessMask" -> ConstantArray[1., {gridSize, gridSize}],
  "BarrierMask" -> ConstantArray[0., {gridSize, gridSize}],
  "Metadata" -> <|"Description" -> "Uniform synthetic accessibility baseline."|>
|>

Options[BarrierMorphology] = {"BarrierColumn" -> Automatic, "GapCenter" -> Automatic, "GapWidth" -> 7, "BarrierAccess" -> 0.12};

BarrierMorphology[gridSize_Integer?Positive, opts : OptionsPattern[]] := Module[
  {column, gapCenter, gapWidth, lowAccess, access, barrier, gapStart, gapEnd},
  column = Replace[OptionValue["BarrierColumn"], Automatic :> Ceiling[gridSize/2]];
  gapCenter = Replace[OptionValue["GapCenter"], Automatic :> Ceiling[gridSize/2]];
  gapWidth = Max[1, OptionValue["GapWidth"]];
  lowAccess = OptionValue["BarrierAccess"];
  access = ConstantArray[1., {gridSize, gridSize}];
  barrier = ConstantArray[0., {gridSize, gridSize}];
  gapStart = Max[1, gapCenter - Floor[gapWidth/2]];
  gapEnd = Min[gridSize, gapCenter + Floor[gapWidth/2]];
  access[[All, column]] = lowAccess;
  barrier[[All, column]] = 1.;
  access[[gapStart ;; gapEnd, column]] = 1.;
  barrier[[gapStart ;; gapEnd, column]] = 0.;
  <|
    "Type" -> "Barrier",
    "GridSize" -> gridSize,
    "AccessMask" -> ClipMask[access],
    "BarrierMask" -> ClipMask[barrier],
    "Metadata" -> <|"BarrierColumn" -> column, "GapCenter" -> gapCenter, "GapWidth" -> gapWidth|>
  |>
]

Options[CorridorMorphology] = {"CorridorRow" -> Automatic, "CorridorColumn" -> Automatic, "CorridorWidth" -> 5, "BackgroundAccess" -> 0.35};

CorridorMorphology[gridSize_Integer?Positive, opts : OptionsPattern[]] := Module[
  {row, column, width, background, access, barrier, rowStart, rowEnd, colStart, colEnd},
  row = Replace[OptionValue["CorridorRow"], Automatic :> Ceiling[gridSize/2]];
  column = Replace[OptionValue["CorridorColumn"], Automatic :> Ceiling[gridSize/2]];
  width = Max[1, OptionValue["CorridorWidth"]];
  background = OptionValue["BackgroundAccess"];
  access = ConstantArray[background, {gridSize, gridSize}];
  barrier = ConstantArray[0., {gridSize, gridSize}];
  rowStart = Max[1, row - Floor[width/2]];
  rowEnd = Min[gridSize, row + Floor[width/2]];
  colStart = Max[1, column - Floor[width/2]];
  colEnd = Min[gridSize, column + Floor[width/2]];
  access[[rowStart ;; rowEnd, All]] = 1.;
  access[[All, colStart ;; colEnd]] = 1.;
  <|
    "Type" -> "Corridor",
    "GridSize" -> gridSize,
    "AccessMask" -> ClipMask[access],
    "BarrierMask" -> barrier,
    "Metadata" -> <|"CorridorRow" -> row, "CorridorColumn" -> column, "CorridorWidth" -> width|>
  |>
]

CreateMorphology[type_String, gridSize_Integer?Positive, opts___] := Switch[ToLowerCase[type],
  "opengrid" | "open" | "open-grid", OpenGridMorphology[gridSize],
  "barrier", BarrierMorphology[gridSize, opts],
  "corridor", CorridorMorphology[gridSize, opts],
  _, Message[CreateMorphology::unknown, type]; $Failed
]

CreateMorphology::unknown = "Unknown morphology type `1`. Use OpenGrid, Barrier, or Corridor.";

MorphologyToAccessibility[morphology_Association] := ClipMask[morphology["AccessMask"]]

End[]
EndPackage[]
