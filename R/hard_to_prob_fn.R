
hard_to_prob_fn <- function(hard_clusters,n_clust){
  prob_mat <- matrix(0,nrow=length(hard_clusters),ncol=n_clust)
  for(i in 1:length(hard_clusters)){
    prob_mat[i,hard_clusters[i]] <- 1
  }
  prob_mat
}
