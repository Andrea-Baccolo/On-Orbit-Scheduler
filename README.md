# On-Orbit_Scheduler 
This Repository contains the code used in my thesis project at Politecnico di Torino.

**Title**: Simulation-Based Optimization of On-Orbit Refueling Mission Scheduling for Satellites.

**Abstract**: 
The increasing demand for satellite servicing and the high cost involved in keeping them operative has led on-orbit refueling to be considered one of the most effective ways to extend satellite lifespan and mission flexibility.
This thesis presents a simulation-based optimization framework for scheduling refueling missions for satellites in geosynchronous orbits. The optimization problem addresses the travel mission of multiple Service Spacecraft from an on-orbit station to multiple target satellites that need refueling. The mission objective is to find the optimal sequence of targets to refuel for every Service Spacecraft, minimizing the total fuel consumption during all rendezvous.
Firstly, a simulator that computes and executes the maneuvers is proposed. The optimization method used is the Adaptive Large Neighborhood Search Heuristic, this method uses some proposed "destroy" and "repair" operators to generate new solutions. Finally, some experiments using a fixed scenario are performed to explore various strategies and evaluate different operators.

# How to Open the MATLAB Project
The following instructions can be used to open the project folder.
1. **Download or clone the repository**
   ```bash
   git clone https://github.com/Andrea-Baccolo/On-Orbit-Scheduler
   ```
   Or download the ZIP file and extract it.
2. **Open MATLAB**
3. **Open the MATLAB project file "OnOrbit_Scheduler.prj"**  
   In MATLAB, navigate to:  
   **Home → Open → Project**  
   Then select the file ```OnOrbit_Scheduler.prj``` included in this repository.  
   Alternatively, you can open the project by double-clicking the project file from your file explorer.
4. **Wait for MATLAB to load the project**  
   MATLAB will automatically configure the project paths and load the project environment as defined by the project file.

# Project Structure
```./AstroObj/Maneuvers```    → presents some classes and functions on orbital Maneuvers.

```./AstroObj/Satellites```   → presents some classes and functions on the Spacescrafts.

```./Destroy```              → presents some classes and functions on the destroyers used to optimize.

```./Optimizer```             → presents some classes and functions on the optimization method.

```./Repair```                → presents some classes and functions on the repairers used to optimize.

```./results```               → presents results of the thesis.

```./Simulator```             → presents some classes and functions for simulating the On-orbit scheduling.

```./Test```                  → presents some classes and functions used for testing.

```./Class_Diagram.pdf```     → visualization of project classes.

```./Helper.pdf```            → file with a summary of all classes and functions.

```./OnOrbit_Scheduler.prj``` → MATLAB project file.

```./addToProject.m```        → script used to add a file in the MATLAB project.

```./finish.m```              → file executed by the MATLAB project when it's closed.

```./gitCommit.m```           → function used to commit from MATLAB.

```./gitPush.m```             → function used to push from MATLAB.

```./startup.m```             → file executed by the MATLAB project when it's open.

# How to use the project
This project addresses two task, simulation and Optimization. The optimization requires the Simulation, but the simulation does not needthe Optimization.

#### Problem instance
Before simulating, a problem instance is required to give proper informations about satellite's positions and the sequence to simulate.
In the test folder, a function ```createInstance``` has been implemented to help creating the instance. For the inputs required, check the helper file, an example of instance creation is  the file ```SaveProblem.m``` in the test folder. The problem instance is tipycally composed by two objects: a solution object and a state oblect.

#### Simulation
A simulator object needs to be created before starting the simulation. An example of simulation has been done in the file ```simulationExample.m```.

#### Optimization
The optimization process is composed by three part: an object from the Optimizer folder, a Problem Instance and two cell array of destroyers and repairers. An exampole of optimization is the ```currResult.m``` script in the Result folder. 
# Authors
- Andrea Baccolo – Project developer.

