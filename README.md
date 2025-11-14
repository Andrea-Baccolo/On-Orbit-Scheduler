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
   git clone <repository-url>
   ```
   Or download the ZIP file and extract it.
2. **Open MATLAB**
3. **Open the MATLAB project file "OnOrbit_Scheduler.prj"**  
   In MATLAB, navigate to:  
   **Home → Open → Project**  
   Then select the file "OnOrbit_Scheduler.prj" included in this repository.  
   Alternatively, you can open the project by double-clicking the project file from your file explorer.
4. **Wait for MATLAB to load the project**  
   MATLAB will automatically configure the project paths and load the project environment as defined by the project file.

# Required Toolboxes
No Toolboxes have been used in this project.

## Notes
- Keep the original folder structure unchanged; MATLAB depends on it when loading the project.  
- If the project includes startup scripts defined in the `.prj`, MATLAB will run them automatically.

# Project Structure

# How to use the project

# Authors
- Andrea Baccolo – Project developer.

