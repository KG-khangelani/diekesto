# Variable Semantics

Prototype 0.1 uses four continuous fields on a synthetic two-dimensional lattice. Each field is clipped to `[0, 1]`. These variables are operational abstractions for exploratory simulation, not direct empirical measurements.

## P: Population Pressure

Operational meaning: occupancy pressure, settlement demand, crowding tendency, or local pressure to concentrate.

Not claimed: this is not a count of people, a demographic measure, or a direct model of lived social behaviour.

Update role: activity can increase pressure; risk can repel or reduce pressure; diffusion allows local smoothing.

Possible later empirical proxies: population density, dwelling density, occupancy pressure, or growth-rate indicators.

## A: Accessibility

Operational meaning: permeability, connection, ease of movement, and access to opportunity.

Not claimed: this is not a validated transport model or a complete measure of infrastructure quality.

Update role: morphology initializes accessibility; local diffusion spreads access effects; risk can damage accessibility.

Possible later empirical proxies: road-network centrality, public transport access, travel time, or service access.

## B: Economic Activity

Operational meaning: local activity intensity, opportunity density, and exchange potential.

Not claimed: this is not income, employment, GDP, or business ownership.

Update role: access can raise activity; risk can damp activity; diffusion allows spillover.

Possible later empirical proxies: business density, employment access, night lights, or land-use intensity.

## R: Disruption / Risk Load

Operational meaning: instability, friction, hazard, service failure, or stress load.

Not claimed: this is not a direct measure of crime, conflict, poverty, or historical harm.

Update role: pressure under low access can raise risk; activity can absorb some risk; risk diffuses and receives seeded shock noise.

Possible later empirical proxies: service interruption, environmental hazard exposure, infrastructure failure, or localized vulnerability indicators.
