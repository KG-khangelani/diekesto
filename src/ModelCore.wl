BeginPackage["RuliologyUrbanDynamics`ModelCore`", {"RuliologyUrbanDynamics`Morphologies`"}]

DefaultParameters::usage = "DefaultParameters[] returns the default Prototype 0.1 parameter association.";
ValidateParameters::usage = "ValidateParameters[params] merges params with defaults and validates numeric values.";
ClipField::usage = "ClipField[field] clips a numeric grid to the interval [0, 1].";
NeighbourhoodMean::usage = "NeighbourhoodMean[field] computes a Moore-neighbourhood radius 1 mean using reflected boundaries.";
CreateInitialState::usage = "CreateInitialState[gridSize, morphology, params, seed] creates the initial four-field model state.";
StepModel::usage = "StepModel[state, params] advances the model by one timestep.";
RunSimulation::usage = "RunSimulation[initialState, params, steps] runs the model and returns the state history including the initial state.";

Begin["`Private`"]

FieldNames = {"P", "A", "B", "R"};

DefaultParameters[] := <|
  "AccessDiffusion" -> 0.08,
  "ActivityDiffusion" -> 0.05,
  "PressureDiffusion" -> 0.04,
  "RiskDiffusion" -> 0.06,
  "AccessActivityCoupling" -> 0.35,
  "ActivityPressureCoupling" -> 0.30,
  "PressureRiskCoupling" -> 0.25,
  "RiskActivityDamping" -> 0.30,
  "RiskPressureRepulsion" -> 0.15,
  "RiskAccessDamage" -> 0.08,
  "ActivityRiskAbsorption" -> 0.12,
  "ShockNoise" -> 0.015,
  "SaturationStrength" -> 0.20,
  "InitialCondition" -> "CentralActivity"
|>

ValidateParameters::nonnumeric = "Parameter `1` must be numeric.";
ValidateParameters::range = "Parameter `1` should be in [0, 1] for Prototype 0.1.";

ValidateParameters[params_: <||>] := Module[{merged, numericKeys},
  merged = Join[DefaultParameters[], params];
  numericKeys = Keys[KeyDrop[merged, {"InitialCondition"}]];
  Do[
    If[! NumericQ[merged[key]], Message[ValidateParameters::nonnumeric, key]; Return[$Failed]];
    If[merged[key] < 0 || merged[key] > 1, Message[ValidateParameters::range, key]; Return[$Failed]],
    {key, numericKeys}
  ];
  merged
]

ClipField[field_] := Clip[N[field], {0, 1}]

NeighbourhoodMean[field_] := N @ ListCorrelate[ConstantArray[1/9, {3, 3}], field, {2, 2}, "Reflected"]

CentralAnchor[gridSize_Integer] := Module[{center = (gridSize + 1)/2., scale = gridSize/7.},
  Table[Exp[-((i - center)^2 + (j - center)^2)/(2 scale^2)], {i, gridSize}, {j, gridSize}]
]

CorridorAnchor[access_] := ClipField[0.15 + 0.75 access]

ShockPatch[gridSize_Integer] := Module[{center = (gridSize + 1)/2., radius = gridSize/8.},
  Table[If[(i - center)^2 + (j - center)^2 <= radius^2, 0.35, 0.], {i, gridSize}, {j, gridSize}]
]

CreateInitialState[gridSize_Integer?Positive, morphology_Association, params_: <||>, seed_Integer] := Module[
  {p, a, b, r, validated, condition, lowNoise, activityAnchor, riskPatch},
  validated = ValidateParameters[params];
  If[validated === $Failed, Return[$Failed]];
  condition = validated["InitialCondition"];
  a = MorphologyToAccessibility[morphology];
  BlockRandom[
    SeedRandom[seed];
    lowNoise = RandomReal[{0, 1}, {gridSize, gridSize}];
    activityAnchor = Switch[condition,
      "RandomLow", 0.08 RandomReal[{0, 1}, {gridSize, gridSize}],
      "CorridorActivity", 0.30 CorridorAnchor[a] + 0.04 RandomReal[{0, 1}, {gridSize, gridSize}],
      _, 0.28 CentralAnchor[gridSize] + 0.04 RandomReal[{0, 1}, {gridSize, gridSize}]
    ];
    riskPatch = If[condition === "RiskShock", ShockPatch[gridSize], ConstantArray[0., {gridSize, gridSize}]];
    p = ClipField[0.05 + 0.12 lowNoise + 0.10 activityAnchor];
    b = ClipField[activityAnchor];
    r = ClipField[0.03 + 0.04 RandomReal[{0, 1}, {gridSize, gridSize}] + riskPatch];
  ];
  <|
    "P" -> p,
    "A" -> ClipField[a],
    "B" -> b,
    "R" -> r,
    "Morphology" -> morphology,
    "Step" -> 0,
    "Seed" -> seed,
    "Params" -> validated
  |>
]

StepModel[state_Association, params_: <||>] := Module[
  {validated, p, a, b, r, nP, nA, nB, nR, noise, dims, nextA, nextB, nextP, nextR},
  validated = ValidateParameters[Join[state["Params"], params]];
  If[validated === $Failed, Return[$Failed]];
  {p, a, b, r} = state /@ FieldNames;
  {nP, nA, nB, nR} = NeighbourhoodMean /@ {p, a, b, r};
  dims = Dimensions[p];
  BlockRandom[
    SeedRandom[state["Seed"] + state["Step"] + 1];
    noise = RandomReal[{-validated["ShockNoise"], validated["ShockNoise"]}, dims];
  ];
  nextA = ClipField[a + validated["AccessDiffusion"] (nA - a) - validated["RiskAccessDamage"] r];
  nextB = ClipField[
    b + validated["AccessActivityCoupling"] a (1 - b) -
      validated["RiskActivityDamping"] r b + validated["ActivityDiffusion"] (nB - b)
  ];
  nextP = ClipField[
    p + validated["ActivityPressureCoupling"] b (1 - p) -
      validated["RiskPressureRepulsion"] r p + validated["PressureDiffusion"] (nP - p)
  ];
  nextR = ClipField[
    r + validated["PressureRiskCoupling"] p (1 - a) -
      validated["ActivityRiskAbsorption"] b r + validated["RiskDiffusion"] (nR - r) + noise
  ];
  Join[state, <|"P" -> nextP, "A" -> nextA, "B" -> nextB, "R" -> nextR, "Step" -> state["Step"] + 1, "Params" -> validated|>]
]

RunSimulation[initialState_Association, params_: <||>, steps_Integer?NonNegative] := NestList[StepModel[#, params] &, initialState, steps]

End[]
EndPackage[]
