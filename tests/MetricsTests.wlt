Get[FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]], "src", "Morphologies.wl"}]];
Get[FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]], "src", "ModelCore.wl"}]];
Get[FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]], "src", "Metrics.wl"}]];

Needs["RuliologyUrbanDynamics`Morphologies`"];
Needs["RuliologyUrbanDynamics`ModelCore`"];
Needs["RuliologyUrbanDynamics`Metrics`"];

morphology = CreateMorphology["Corridor", 20];
state = CreateInitialState[20, morphology, DefaultParameters[], 1234];
history = RunSimulation[state, DefaultParameters[], 5];
metrics = HistoryMetrics[history];

VerificationTest[0 <= TrapIndex[state] <= 1, True, TestID -> "TrapIndex range"]

VerificationTest[KeyExistsQ[StateMetrics[state], "PMean"], True, TestID -> "StateMetrics includes PMean"]

VerificationTest[Length[metrics], 6, TestID -> "HistoryMetrics length"]

VerificationTest[NumericQ[FieldEntropy[state, "A"]], True, TestID -> "FieldEntropy numeric"]
