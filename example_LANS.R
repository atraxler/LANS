# Run LANS backbone extraction on simple and complex star example networks from Foti et al. (2011).
# Last modified:  11/11/18 (cleaning up comments and plotting)
# 
# Status: Works.

rm(list = ls())
setwd("~/../Box Sync/Research/R code/LANS backbone extraction/")

library(igraph)
source("backbone_extract.R")

# First network: Foti et al. Fig. 2 "simple star"
star1 <- matrix(c(0,1,0,1,2,
                  1,0,1,0,2,
                  0,1,0,1,2,
                  1,0,1,0,2,
                  2,2,2,2,0),nrow=5,byrow=TRUE)

# Second network: Foti et al. Fig. 2 "complex star"
star2 <- matrix(0,nrow=25,ncol=25)
star2[1:5,1:5] <- star1
star2[6:10,6:10] <- star1
star2[11:15,11:15] <- star1
star2[16:20,16:20] <- star1
star2[21:25,21:25] <- 100*star1
star2[3,21] <- 100
star2[9,22] <- 100
star2[12,24] <- 100
star2[16,23] <- 100
star2[lower.tri(star2)] <- t(star2)[lower.tri(star2)]

# Turn adjacency matrices into graphs
gstar1 <- graph.adjacency(as.matrix(star1),weighted=TRUE)
gstar2 <- graph.adjacency(as.matrix(star2),weighted=TRUE)

# Check plots
plot(gstar1,edge.label=E(gstar1)$weight,edge.width=E(gstar1)$weight,
     layout=layout.star(gstar1,center=5))
plot(gstar2,edge.label=E(gstar2)$weight,vertex.size=5,vertex.label=NA)


## Run LANS on adjacency matrices
# I was curious about how long this might take... (not long)
ptm <- proc.time()
Astar1 <- LANS(star1)
time1 <- proc.time() - ptm

ptm <- proc.time()
Astar2 <- LANS(star2)
time2 <- proc.time() - ptm


## Make new networks and plot. Compare with second row of Foti et al. Figure 2

# First network: Should keep edges to center (both ways)
bstar1 <- graph.adjacency(Astar1,weighted=TRUE)
plot(bstar1,edge.width=E(bstar1)$weight,edge.label=E(bstar1)$weight)

# Second network: Should keep weight-200 central cross and weight-100 connecting arms to sub-stars.
bstar2 <- graph.adjacency(Astar2,weighted=TRUE)
plot(bstar2,edge.label=E(bstar2)$weight,vertex.size=5,vertex.label=NA)
