# clusterBMA::clusterBMA()

# input arguments: input_data = DATA FRAME of input data for clustering; cluster_prob_matrices = list of allocation probability matrices from clustering solutions;
# n_final_clust = number of clusters for final BMA solution (e.g. maximum number of clusters across any input solution; or desired final number for K based on
# clustering internal validation criteria)

# Each entry in cluster_prob_matrices should be a NxK_m matrix A_m where N = number of datapoints (rows), and K_m = number of clusters (columns).
# Each entry A_ik represents the probability that point i is allocated to cluster k in each solution

# For 'hard' clustering solutions (1 or 0 probability of cluster allocation) such as k-means or hierarchical clustering, \
# the allocation matrix can be created using the function clusterBMA::hard_to_prob_fn()

# For 'soft' clustering solutions e.g. GMM, this is usually accessible from the model output. E.g. the object cluster_proba within the result from
# ClusterR::predictGMM() on a GMM object produced from ClusterR::GMM()




# suggest adding BMA outputs to original input_data DF for plotting/further analyses
# e.g.
# # save cluster allocations for plotting DF
# input_data$bma_cluster_labs <- bma_cluster_labels_df$alloc_ordered
#
# input_data$bma_cluster_probability <- bma_cluster_labels_df$alloc_prob
#
# # save cluster allocation uncertainty for plotting DF
# input_data$bma_cluster_uncertainty <- bma_cluster_labels_df$alloc_uncertainty

clusterBMA <- function(input_data,cluster_prob_matrices,n_final_clust,prior_weights="equal", wt_crit_name="Xie_Beni",wt_crit_direction = "min"){

  n_models <- length(cluster_prob_matrices)

  if(prior_weights == "equal"){
    prior_vec <- rep(1/n_models,n_models) #e.g. c(0.2, 0.2, 0.2) for M = 3
  } else {
    prior_vec <- prior_weights # user-supplied vector of prior weights that sum to 1, of length M = n. of models
  }


  # can suppress warnings (coming up because of outdated python syntax but it still works fine)
  #oldw <- getOption("warn")
  #options(warn = -1)



  clusterBMA_use_condaenv() #specify conda environment to use

  if(class(input_data) != "data.frame") {input_data <- as.data.frame(input_data)}

  conda_existing <- reticulate::conda_list()
  if(!("clusterBMA-pyenv"%in% conda_existing$name)){
    stop("Please run clusterBMA_initial_python_setup() first to install Python 3.7.9 and Tensorflow 1.15.5 in a dedicated miniconda environment, then restart your R session. You may want to save any data/variables in the environment before installing & restarting.")
    }



  #calculate similarity matrix for each model
  similarity_matrix_list <- vector(mode = "list", length = n_models)

  for (i in 1:n_models){
    similarity_matrix_list[[i]] <- sim_mat_fn(cluster_prob_matrices[[i]])
  }

  # calculate cluster allocation (max prob) vectors

  cluster_labels_list <- vector(mode = "list", length = n_models)

  for (i in 1:n_models){

    temp_pthf <- prob_to_hard_fn(soft_alloc_matrix = cluster_prob_matrices[[i]])

    cluster_labels_list[[i]] <- temp_pthf[[1]]$alloc_vector
  }

  cluster_labels_df <- as.data.frame(cluster_labels_list)


  # calculate weights
  # Changing to try using new_weight_fn

  bma_weights_df <- new_weight_fn(input_data=input_data,cluster_label_df = cluster_labels_df,n_sols = n_models, wt_crit_name = wt_crit_name, wt_crit_direction = wt_crit_direction)
  #bma_weights_df <- ch_xb_weight_fn(input_data=input_data,cluster_label_df = cluster_labels_df,n_sols = n_models)


  # calculate BMA results!
  bma_results <- consensus_matrix_fn(sim_mat_list = similarity_matrix_list,algo_weights=bma_weights_df$W_m,n_final_clust=n_final_clust, prior_vec=prior_vec)


  #consensus_matrix <- bma_results[[1]]
  #bma_probabilities <- bma_results[[2]]
  #bma_cluster_labels_df <- bma_results[[3]]
  #bma_allocs_table <- bma_results[[4]]


  #options(warn = oldw) #possibility to suppress warnings if desired

  return(bma_results)
}
