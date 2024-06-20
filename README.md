# MasterThesis
This repository contains the MATLAB files used to train the ANNs, and the files which generated the main results. Following is a description to each file.

<br/> **Folder: Results** <br/> 
*resultsAll.m:*<br/> 
The main file for result generation.
Solves the SoA mechanistic model and computes the RRMSE.
Finds the hybrid models with the lowest cost in each phase, combines them into one model for the whole process (for models 1-4). Calculates RRMSE.
Plots the results from the model simulations.
This file applies the functions described below.

*odeRMSE.m:* <br/> 
Simulates the SoA mechanistic model and calculates RRMSE.

*combResFunc2.m:*<br/> 
Calculates RRMSE and plots the model simulations.

*saveHypSearchRes.m:*<br/> 
Reads all files in a folder, calculates RRMSE and saves the results.

*rmseRelCalc.m*<br/> 
Function that calculate the RRMSE.

*plotSubplotsCompactAll.m*<br/> 
Function that plots the state predictions (X, S and CO2) along with the experimental data.

*minCostFile.m:*<br/> 
Function that iterates through files, computes the cost and returns the file with the lowest cost.

<br/> **Folder: ANN training**<br/> 
This folder contains subfolders for ANN training for each phase and number of ANN outputs. All folders have the same content, but the scripts are different in definitions of number of outputs, and what training data is used (different between phase 1 and phase 2).

Here, an explanation is provided for the folder "ANN phase 1 - lsqnonlin - 1 output":

*ANNmu_lsqnonlin:* <br/> Script for ANN training. Loads training data from the folder "expdata", and saves the results to the folder "results".

*hybridODE.m* <br/> Function defining the hybrid model.

<br/> **Folder: Parameter Estimation**<br/> 


