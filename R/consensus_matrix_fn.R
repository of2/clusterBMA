#' Generate consensus matrix from input similarity matrices, and calculate key outputs (internal function)
#'

#' @export
#'
#'
consensus_matrix_fn <- function(sim_mat_list,algo_weights,n_final_clust,prior_vec){

  # stack similarity matrices into array

  n <- length(sim_mat_list); 	   rc <- dim(sim_mat_list[[1]]); 	   ar1 <- array(unlist(sim_mat_list), c(rc, n))


  # 060721

  # Old version works fine - updated to use Hmisc:: wtd.mean so I can also calculated Hmisc:: wtd.var for weighted variance and SD across methods
  # consensus_matrix <- Reduce(`+`,Map(`*`, sim_mat_list, algo_weights))

  # See this discussion on weighted variance https://r.789695.n4.nabble.com/Problem-with-Weighted-Variance-in-Hmisc-td826437.html
  # essential to use normwt=T for Hmisc::wtd.var below


  # multiply BMA weights by prior weights and normalise

  combined_algo_prior_weights <- algo_weights * prior_vec

  combined_algo_prior_weights <- combined_algo_prior_weights/sum(combined_algo_prior_weights)

  consensus_matrix <- apply(ar1, c(1, 2), function(x) Hmisc::wtd.mean(x,weights=combined_algo_prior_weights))

  consensus_matrix

  consensus_matrix_heatmap <- pheatmap::pheatmap(consensus_matrix, treeheight_row = 0, treeheight_col = 0, main = "BMA - Consensus matrix")


  consensus_SSMF <- SimplexClust(S=consensus_matrix,G=n_final_clust)

  bma_probs <- consensus_SSMF[[1]]

  bma_prob_to_hard <- prob_to_hard_fn(bma_probs)

  bma_labels_df <- bma_prob_to_hard[[1]]

  bma_table <- bma_prob_to_hard[[2]]

  consensus_matrix_heatmap


  return(list(consensus_matrix,bma_probs,bma_labels_df,bma_table,algo_weights,combined_algo_prior_weights,consensus_matrix_heatmap))
  #print(consensus_dendro)
}
