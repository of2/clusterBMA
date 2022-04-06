#test

library(clusterGeneration)
library(ClusterR)
library(plotly)

#simulate data
test_data <- clusterGeneration::genRandomClust(numClust=5,sepVal=0.15,numNonNoisy=2,numNoisy=0,clustSizes=c(rep(100,5)),numReplicate = 1,clustszind = 3)

test_data <- test_data$datList$test_1

#k-means, k=5, get allocation probs matrix
test_kmeans <- kmeans(test_data,centers = 5)

km_labs <- test_kmeans$cluster

km_probs <- hard_to_prob_fn(km_labs,n_clust=5)

#gmm, k=5, get allocation probs matrix
test_gmm <- ClusterR::GMM(test_data,gaussian_comps=5)

test_gmm_predict <- ClusterR::predict_GMM(test_data,CENTROIDS=test_gmm$centroids,COVARIANCE = test_gmm$covariance_matrices,WEIGHTS=test_gmm$weights)

# gmm probs
gmm_probs <- test_gmm_predict$cluster_proba


# TEST clusterBMA

input_probs <- list(km_probs,gmm_probs)

test_bma_results <- clusterBMA(input_data = test_data, cluster_prob_matrices = input_probs, n_final_clust = 5)


# add BMA outputs as columns onto original dataframe
test_data <- cbind(test_data,test_bma_results[[3]])


# plot BMA cluster results - larger points have greater uncertainty

test_plot_BMA_uncertainty <- plot_ly(data=test_data,x=test_data[,1],y=test_data[,2],color=factor(test_data$alloc_vector),colors = RColorBrewer::brewer.pal(5,"Dark2"), size=test_data$alloc_uncertainty,marker=list(sizeref=0.3, sizemode="area"))
test_plot_BMA_uncertainty

