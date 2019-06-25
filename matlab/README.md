# Probabilistic Synapse Detection MATLAB 

Running the 'main.m' file will run the sample data provided in this repository. Please note, the python notebook file represents the second version of the codebase and allows for more flexibility. 

This file does the following: 

1) Loads the data. For this example, it loads the presynaptic marker synapsin, postsynaptic marker PSD-95, and postsynaptic marker GluR1. 

2) These 3D arrays are formatted into an object. 

3) The next step is to create a "query." 'query.preIF' contains the string name of the presynaptic marker. For this example, that is synapsin. 'query.preIF_z' lists how many slices the marker should span in the z direction. The same for the postsynaptic side. 

4) 'runQuery' takes the query definition and the image volumes and outputs a probability map where the value at every pixel is the probability it belongs to that query. 

5) Threshold and count the number of detections. 

