# Backbone extraction code following the method of Foti et al. (2011)
# Last updated: 11/11/16 (copied working version from report)

# Usage: Will usually just call LANS function, which calls the others. This creates a 
#  backbone adjacency matrix, which can then be re-cast as a network.

## fracwt: Calculate the fractional edge weight matrix for a network
# Input a weighted adjacency matrix
# Outputs equivalent fractional edge weight matrix
fracwt <- function(wt) {
  P <- data.matrix(wt/rowSums(wt))
  P[is.na(P)] <- 0  # clear zeros (occur when rowSum=0, for isolates)
  return(P)
}

## Fmat: Calculate the empirical CDF for each row of an adjacency matrix
# Input an NxN matrix of fractional edge weights
# Outputs an NxN matrix of the empirical CDF for all present edges of each node i
Fmat <- function(P) {
  P <- data.matrix(P) # Make sure we're using a matrix, not rows of data frames
  Ntot <- dim(P)[1]
  Fcdf <- matrix(data=0,nrow=Ntot,ncol=Ntot)
  for (i in 1:Ntot) {
    if (sum(P[i,])>0) {  # skip rows for isolates
      Frow <- ecdf(P[i,P[i,]>0])
      Fcdf[i,P[i,]>0] <- Frow(P[i,P[i,]>0])
    }
  }
  return(Fcdf)
}

## LANS: take a weighted adjacency matrix and p-value cutoff, return extracted backbone matrix
LANS <- function(wt,alpha=0.05) {
  wt <- data.matrix(wt)
  Ntot <- dim(wt)[1]
  # initialize Pij to Sij/sum(Sik), reduced adjacency matrix to zero
  P <- data.matrix(fracwt(wt))  # You get weird errors when quantiles below get data frames
  A <- matrix(data=0,nrow=Ntot,ncol=Ntot)
  Fcdf <- Fmat(P)  # compute empirical CDF matrix
  for (i in 1:Ntot) { 
    # If 1-F(pij) < alpha, keep edge ij
    jkeep <- (1-Fcdf[i,]) < alpha
    # if Pij > pa, set Aij = Sij (also set Aji = Sij if symmetric backbone)
    if (sum(jkeep) > 0) A[i,jkeep] <- wt[i,jkeep]  # non-isolates only
  }
  return(A)
}