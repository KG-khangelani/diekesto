# Rule Schema

Prototype 0.1 updates four fields using local Moore-neighbourhood means. Let `N[X]` be the local mean of field `X` over radius 1.

## Update Equations

```text
A(t+1) = clip[A + accessDiffusion * (N[A] - A) - riskAccessDamage * R]

B(t+1) = clip[
  B
  + accessActivityCoupling * A * (1 - B)
  - riskActivityDamping * R * B
  + activityDiffusion * (N[B] - B)
]

P(t+1) = clip[
  P
  + activityPressureCoupling * B * (1 - P)
  - riskPressureRepulsion * R * P
  + pressureDiffusion * (N[P] - P)
]

R(t+1) = clip[
  R
  + pressureRiskCoupling * P * (1 - A)
  - activityRiskAbsorption * B * R
  + riskDiffusion * (N[R] - R)
  + shockNoise
]
```

These equations are bootstrapping rules for synthetic experiments. They are not truth claims about real urban systems.

## Parameters

- `AccessDiffusion`: local smoothing of accessibility.
- `ActivityDiffusion`: local smoothing of activity.
- `PressureDiffusion`: local smoothing of population pressure.
- `RiskDiffusion`: local smoothing of risk.
- `AccessActivityCoupling`: effect of accessibility on activity.
- `ActivityPressureCoupling`: effect of activity on pressure.
- `PressureRiskCoupling`: effect of pressure under low access on risk.
- `RiskActivityDamping`: damping effect of risk on activity.
- `RiskPressureRepulsion`: damping effect of risk on pressure.
- `RiskAccessDamage`: damping effect of risk on accessibility.
- `ActivityRiskAbsorption`: reduction of risk through activity.
- `ShockNoise`: seeded random disturbance amplitude added to risk.
- `SaturationStrength`: reserved for later saturation experiments.

All current default parameters are in `[0, 1]`.
