# Probabilistic Synapse Detection Python 

Running this notebook will run the sample data provided in this repository. 
This file does the following: 

1) Loads the data. For this example, it loads the presynaptic marker synapsin, and postsynaptic marker PSD-95, and postsynaptic marker GluR1. 

2) These 3D arrays are formatted into a dictionary object. 

3) The next step is to create a "query." 'preIF' contains the string name of the presynaptic marker. For this example, that is synapsin. 'preIF_z' lists how many slices the marker should span in the z direction. The same for the postsynaptic side. 'punctumSize' is the number of pixels that the blob should span in the x/y directions. 

4) 'getSynapseDetections' takes the query definition and the image volumes and outputs a probability map where the value at every pixel is the probability it belongs to that query. 

5) Threshold and count the number of detections. 

