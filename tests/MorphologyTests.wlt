projectRoot = If[StringQ[$InputFileName] && $InputFileName =!= "", DirectoryName[DirectoryName[$InputFileName]], Directory[]];

Get[FileNameJoin[{projectRoot, "src", "Morphologies.wl"}]];

Needs["RuliologyUrbanDynamics`Morphologies`"];

open = CreateMorphology["OpenGrid", 20];
barrier = CreateMorphology["Barrier", 20];
corridor = CreateMorphology["Corridor", 20];

VerificationTest[Dimensions[open["AccessMask"]], {20, 20}, TestID -> "OpenGrid access dimensions"]

VerificationTest[Dimensions[barrier["BarrierMask"]], {20, 20}, TestID -> "Barrier mask dimensions"]

VerificationTest[open["AccessMask"] != barrier["AccessMask"], True, TestID -> "Barrier differs from open grid"]

VerificationTest[barrier["AccessMask"] != corridor["AccessMask"], True, TestID -> "Corridor differs from barrier"]
