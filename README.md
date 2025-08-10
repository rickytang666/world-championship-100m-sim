<div align="center">

<img src="https://cdn-icons-png.flaticon.com/512/763/763812.png" width="100" alt="Sprinting">

# World Championships 100m Simulator

</div>

## Overview

A simulation of the Men's 100m World Championships featuring the top 56 athletes.
The program simulates realistic race conditions by incorporating weather effects (wind, altitude, temperature, humidity, barometer), athlete health factors, and performance variations to generate race results throughout the prelimary heats, semifinals, and final.

## Features

- **Realistic Simulation**: Models top 56 athletes with actual performance data
- **Dynamic Factors**: Incorporates comprehensive calculations based on weather conditions and [the formulae from Jonas Mureika's research](https://jmureika.lmu.build/track/index.html?viewpapers=Related+Publications), athlete health, and performance variations (mental variations, health, luck variations, etc.)
- **Dual Modes**: Choose between animated visualization or console commentary (commentator mode is the default)
- **Professional Output**: Generates comprehensive and well-formatted results document in .txt format
- **Multi-Stage Competition**: Simulates heats, semifinals, and final
- **Precise Timing**: Implements proper track & field rounding rules (using rigorous rounding to 3 decimal places)

## Tech Stack

- **Language**: Processing 4.3

## Getting Started

### Installation and Usage

1. **Prerequisites**: Install [Processing](https://processing.org/download/)
2. **Download**: Clone or download this repository
3. **Open**: Launch `World_Champ_100m_Sim.pde` in Processing
4. **Configure**: Modify the `mode` variable in the main file:
   - `"animation"` - Visual race simulation with graphics
   - `"commentator"` - Console-based commentary only
5. **Run**: Execute the sketch to start the simulation

### Output

The simulation generates a comprehensive results booklet (`Full Results.txt`) containing:

- Heat results and qualifying times
- Semifinal results and advancement
- Final results with medal placements
- Detailed performance statistics
- Weather conditions during competition

## Acknowledgements

- [Jonas Mureika's research](https://jmureika.lmu.build/track/index.html?viewpapers=Related+Publications)
- [World Athletics's](https://www.worldathletics.org) for providing the 100m rankings data

## License

This project is licensed under the [BSD 3-Clause License](LICENSE).
