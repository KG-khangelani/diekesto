projectRoot = If[StringQ[$InputFileName] && $InputFileName =!= "", DirectoryName[DirectoryName[$InputFileName]], Directory[]];

Get[FileNameJoin[{projectRoot, "src", "Morphologies.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "ModelCore.wl"}]];

Needs["RuliologyUrbanDynamics`Morphologies`"];
Needs["RuliologyUrbanDynamics`ModelCore`"];

morphology = CreateMorphology["OpenGrid", 20];
params = DefaultParameters[];
stateA = CreateInitialState[20, morphology, params, 1234];
stateB = CreateInitialState[20, morphology, params, 1234];
history = RunSimulation[stateA, params, 10];

VerificationTest[Dimensions[stateA["P"]], {20, 20}, TestID -> "P field dimensions"]

VerificationTest[AllTrue[Flatten[stateA["R"]], 0 <= # <= 1 &], True, TestID -> "Initial risk in range"]

VerificationTest[stateA["P"] == stateB["P"] && stateA["B"] == stateB["B"] && stateA["R"] == stateB["R"], True, TestID -> "Seeded initial state reproducible"]

VerificationTest[Length[history], 11, TestID -> "RunSimulation includes initial state"]

VerificationTest[AllTrue[Flatten[Last[history]["P"]], 0 <= # <= 1 &], True, TestID -> "Final pressure in range"]
