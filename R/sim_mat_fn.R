#cluster_probs should be a probability matrix of cluster membership

sim_mat_fn <- function(cluster_probs){

  # starting as a for loop - can try vectorising later if it's too slow

  # sim_mat_out <- matrix(NA,nrow=nrow(cluster_probs),ncol=nrow(cluster_probs))

  sim_mat_out <- cluster_probs %*% t(cluster_probs)

  diag(sim_mat_out) <- 1


  sim_mat_out
}
