# Morphology Schema

Morphologies are synthetic spatial conditions that initialize accessibility. They are process abstractions, not imported maps.

Each morphology returns an association:

```wolfram
<|
  "Type" -> type,
  "GridSize" -> n,
  "AccessMask" -> matrix,
  "BarrierMask" -> matrix,
  "Metadata" -> <|...|>
|>
```

## OpenGrid

All cells begin with high accessibility and no barriers. This is the baseline morphology.

## Barrier

A vertical barrier reduces accessibility across part of the grid. A configurable gap allows limited passage.

## Corridor

A cross-shaped corridor has high accessibility, while surrounding cells retain lower background accessibility.

## Accessibility

`MorphologyToAccessibility` returns the morphology access mask clipped to `[0, 1]`. The model core uses it as the initial `A` field.
