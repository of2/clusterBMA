# clusterBMA: Bayesian Model Averaging for Clustering

### ALPHA VERSION / WORK IN PROGRESS - this will continue to be iterated and expanded with better documentation, vignettes and bug fixes in the coming months.

This R package provides tools for Bayesian Model Averaging (BMA) to combine results across multiple different clustering algorithms. BMA offers some attractive benefits over other existing approaches for combining multiple sets of clustering results. Benefits include intuitive probabilistic interpretation of an overall cluster structure integrated across multiple sets of clustering results, with quantification of model-based uncertainty.

The motivation and methods for this approach are described in an accompanying publication: **CITATION HERE**

To get started in R, run:

```
devtools::install_github("of2/clusterBMA")
```

This should also install the dependencies:
    reticulate,
    tensorflow,
    clusterCrit,
    Hmisc,
    pheatmap

If you have not previously installed miniconda, please run:

```
reticulate::install_miniconda()
```

**To install required Python 3.7.9 & Tensorflow 1.15.5 in dedicated Conda environment, run:**

```
clusterBMA::clusterBMA_initial_python_setup()
```

**and then restart your R session.**



## Basic example vignette

You can run the test code below to get an idea of the basic functionality. This example simulates some data from 5 clusters, runs k-means and Gaussian mixture model with K=5, and combines the two results with weighted averaging, probabilistic combined cluster allocation, and quantification of model-based uncertainty.

```
#test

library(clusterBMA)
library(clusterGeneration)
library(ClusterR)
library(plotly)


#simulate data
test_data <- clusterGeneration::genRandomClust(numClust=5,sepVal=0.15,numNonNoisy=2,numNoisy=0,clustSizes=c(rep(100,5)),numReplicate = 1,clustszind = 3)

test_data <- test_data$datList$test_1

#k-means, k=5, get allocation probabilities matrix
test_kmeans <- kmeans(test_data,centers = 5)

km_labs <- test_kmeans$cluster

km_probs <- hard_to_prob_fn(km_labs,n_clust=5)

#gmm, k=5, get allocation probs matrix
test_gmm <- ClusterR::GMM(test_data,gaussian_comps=5)

test_gmm_predict <- ClusterR::predict_GMM(test_data,CENTROIDS=test_gmm$centroids,COVARIANCE = test_gmm$covariance_matrices,WEIGHTS=test_gmm$weights)

# gmm probs
gmm_probs <- test_gmm_predict$cluster_proba

# Put cluster allocation probability matrices into list, format required for function clusterBMA::clusterBMA()
input_probs <- list(km_probs,gmm_probs)

# Run clusterBMA function to combine results from k-means and GMM
# Need to specify input dataset, list of cluster allocation probability matrices, and the number of final clusters selected
test_bma_results <- clusterBMA(input_data = test_data, cluster_prob_matrices = input_probs, n_final_clust = 5)


# add BMA outputs as columns onto original dataframe
test_data <- cbind(test_data,test_bma_results[[3]])


# plot BMA cluster results - larger points have greater uncertainty

test_plot_BMA_uncertainty <- plot_ly(data=test_data,x=test_data[,1],y=test_data[,2],color=factor(test_data$alloc_vector),colors = RColorBrewer::brewer.pal(5,"Dark2"), size=test_data$alloc_uncertainty,marker=list(sizeref=0.3, sizemode="area"))
test_plot_BMA_uncertainty
```
