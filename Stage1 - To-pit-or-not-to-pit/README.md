# To Pit or Not to Pit... This Is the Strategy

## Overview
This project simulates the management of sensor data for a Formula 1 team, specifically focusing on the legendary Ferrari team. The goal is to analyze and process data from two types of sensors: Tire Sensors and Power Management Unit (PMU) Sensors. The project aims to help engineers filter out erroneous data and execute various operations based on valid sensor readings.

## Project Structure
The project consists of the following files:
- `main.c`: Contains the implementation of the main program logic.
- `operations.c`: Implements the operations to be performed on sensor data.
- `structs.h`: Defines the data structures used within the implementation.
- `Makefile`: A classic Makefile to build and run the project.

## Sensor Types
The project utilizes two sensor types:
1. **Tire Sensor**: Monitors tire pressure, temperature, wear level, and performance score.
2. **Power Management Unit Sensor**: Monitors battery voltage, current draw, power consumption, energy regeneration, and energy storage.

## Operations
The following operations can be performed on the sensor data:
- **Tire Sensor Operations**:
  - Tire Pressure Status
  - Tire Temperature Status
  - Tire Wear Level Status
  - Tire Performance Score
- **PMU Operations**:
  - Compute Power
  - Regenerate Energy
  - Get Energy Usage
  - Check Battery Health

## Functionality
The program reads commands from the user until the "exit" command is issued. The following commands are supported:
- `print <index>`: Displays the sensor data at the specified index.
- `analyze <index>`: Executes all operations associated with the sensor at the specified index.
- `clear`: Removes invalid sensors from the list.
- `exit`: Deallocates memory and exits the program.

### Memory Management
The project emphasizes dynamic memory management. All structures are allocated dynamically, and memory leaks are checked using Valgrind. The program ensures that:
- Memory is correctly allocated for all structures.
- Deallocation is performed to prevent memory leaks.
