# MasterThesis
This repository contains the MATLAB files used to train the ANNs, and the files which generated the main results. Following is a description to each file.

<br/> **Folder: Results** <br/> 
*resultsAll.m:*
The main file for result generation.
Solves the SoA mechanistic model and computes the RRMSE.
Finds the hybrid models with the lowest cost in each phase, combines them into one model for the whole process (for models 1-4). Calculates RRMSE.
Plots the results from the model simulations.
This file applies the functions described below.

*odeRMSE.m:* 
Simulates the SoA mechanistic model and calculates RRMSE.

*combResFunc2.m:*
Calculates RRMSE and plots the model simulations.

*saveHypSearchRes.m:*
Reads all files in a folder, calculates RRMSE and saves the results.

*rmseRelCalc.m*
Function that calculate the RRMSE.

*plotSubplotsCompactAll.m*
Function that plots the state predictions (X, S and CO2) along with the experimental data.

*minCostFile.m:*
Function that iterates through files, computes the cost and returns the file with the lowest cost.

<br/> **Folder: ANN training**<br/> 
This folder contains folders for ANN training for each phase and number of ANN outputs. All files have the same content, but they have different definitions of number of outputs and different loading of training data.
For example:
<br/>**Subfolder: ANN phase 1 - lsqnonlin - 1 output**<br/> 
Contains a folder _expdata_, cosisting of the training data, and _results_, which consists of the results from ANN training.
*ANNmu_lsqnonlin:* Script for ANN training.
*hybridODE.m* The definition of the hybrid model.

<br/> **Folder: Parameter Estimation**<br/> 


