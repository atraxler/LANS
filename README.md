# LANS
Locally Adaptive Network Sparsification (backbone extraction)

This code implements the LANS backbone extraction method of Foti et al. 2011 (doi:10.1371/journal.pone.0016431). It takes a weighted network adjacency matrix, a cutoff alpha value, and returns a "backbone" matrix with all edges below the (1-alpha) percentile discarded.

The output adjacency matrix is directed (asymmetric), because an edge that is imortant to one node in the pairing may not be significant enough for the other node to keep. 

If you find this code useful, consider citing the paper where I published it! It's in the the Supplemental Material (doi:10.1103/PhysRevPhysEducRes.14.020107): A. Traxler, A. Gavrin, and R. Lindell, "Networks identify productive forum discussions," Phys. Rev. Phys. Educ. Res. 14, 020107 (2018).
