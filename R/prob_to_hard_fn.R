# Function to get 'hard' allocations and probability/uncertainty from soft allocation probability matrix ($P output from SimplexClust())

prob_to_hard_fn <- function(soft_alloc_matrix){
  alloc_vector <- vector(mode="numeric",length=length(soft_alloc_matrix[,1]))

  alloc_vector <- apply(soft_alloc_matrix,1,which.max)

  alloc_out <- data.frame(alloc_vector)

  alloc_out$alloc_prob <- apply(soft_alloc_matrix,1,max)

  alloc_out$alloc_uncertainty <- 1 - apply(soft_alloc_matrix,1,max)

  cluster_table <-  sort(table(alloc_vector),decreasing=T)

  # DO A FOR LOOP HERE

  alloc_out$alloc_ordered <- rep(NA,length(alloc_out[,1]))

  for (i in 1:length(alloc_out[,1])){
    alloc_out$alloc_ordered[i] <- which(alloc_vector[i] == as.numeric(names(cluster_table)))
  }

  cluster_table_ordered <-  sort(table(alloc_out$alloc_ordered),decreasing=T)

  return(list(alloc_out,cluster_table_ordered))
}
