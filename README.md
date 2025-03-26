# FS25_FieldRotation

BETA

A Farming Simulator 25 mod that implements a comprehensive field rotation system to enhance crop management and yields.

## Features
- Dynamic yield adjustments based on previous crops harvested on each field
- Field HUD display showing recently harvested crops
- Smart recommendations for optimal crop selection after harvest
- Random field history generation upon initial installation

## Crop Rotation System

The mod implements a sophisticated crop rotation system where the yield of each field is influenced by previously harvested crops. This creates a more realistic and strategic farming experience.

### Rotation Multipliers

| Predecessor ↓ / Following → | WHEAT  | BARLEY | OAT  | CANOLA  | MAIZE  | SOYBEAN  | SUNFLOWER | POTATO  | SUGARBEET | COTTON  | SORGHUM  | CARROT  | BEETROOT  | PARSNIP  |
|-----------------------------|--------|--------|------|---------|--------|----------|-----------|---------|-----------|---------|----------|---------|-----------|----------|
| WHEAT                       | -20%   | -20%   | -20% | +10%    | -20%   | +10%     | +10%      | +10%    | +10%      | +10%    | -20%     | +10%    | +10%      | +10%     |
| BARLEY                      | -20%   | -20%   | -20% | +10%    | -20%   | +10%     | +10%      | +10%    | +10%      | -       | -20%     | +10%    | +10%      | +10%     |
| OAT                         | -20%   | -20%   | -20% | +10%    | -20%   | +10%     | -         | +10%    | +10%      | -       | -20%     | +10%    | +10%      | +10%     |
| CANOLA                      | -      | -      | -    | -20%    | -      | -        | -20%      | -       | -         | -10%    | -        | -       | -         | -        |
| MAIZE                       | -20%   | -20%   | -20% | -       | -20%   | +10%     | -         | -       | -20%      | +10%    | -20%     | -       | -         | -        |
| SOYBEAN                     | +20%   | +20%   | +20% | +20%    | +20%   | -20%     | +20%      | +20%    | +20%      | +20%    | +20%     | +20%    | +20%      | +20%     |
| SUNFLOWER                   | -      | -      | -    | -20%    | -      | -        | -20%      | -       | -         | -10%    | -        | -       | -         | -        |
| POTATO                      | +10%   | +10%   | -    | -       | -      | +10%     | -         | -20%    | -20%      | -       | -        | -10%    | -10%      | -10%     |
| SUGARBEET                   | -      | -      | -    | -       | -      | +10%     | -         | -20%    | -20%      | -       | -        | -10%    | -20%      | -10%     |
| GRASS                       | +10%   | +10%   | +10% | -       | +10%   | -        | -         | +10%    | +10%      | -       | +10%     | +10%    | +10%      | +10%     |
| COTTON                      | -      | -      | -    | -10%    | -      | -        | -10%      | -       | -         | -20%    | -        | -       | -         | -        |
| SORGHUM                     | -      | -      | -    | -       | -20%   | -        | -         | -       | -         | -       | -20%     | -       | -         | -        |
| MEADOW                      | +10%   | +10%   | +10% | -       | +10%   | -        | -         | +10%    | +10%      | -       | +10%     | +10%    | +10%      | +10%     |
| CARROT                      | -      | -      | -    | -       | -      | -        | -         | -10%    | -10%      | -       | -        | -20%    | -10%      | -20%     |
| BEETROOT                    | -      | -      | -    | -       | -      | -        | -         | -10%    | -10%      | -       | -        | -10%    | -20%      | -10%     |
| PARSNIP                     | -      | -      | -    | -       | -      | -        | -         | -10%    | -10%      | -       | -        | -20%    | -10%      | -20%     |

### Customization
- All rotation multipliers can be modified in the `FieldRotation.xml` file within the modSettings folder
- Support for additional crop types can be added by updating the `FieldRotation.xml` file

## Upcoming Features
- Fallow field yield bonus system
- Rotation bonus display when selecting crops with seeders/planters
- In-game visualization of the rotation multiplier matrix

