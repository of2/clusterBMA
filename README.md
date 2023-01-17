# clusterBMA: Bayesian Model Averaging for Clustering

# v 0.1.1

## PREPRINT HERE: https://arxiv.org/abs/2209.04117

All code and instructions are provided at https://github.com/of2/clusterBMA

## For any bugs/issues, please email me at owen(dot)forbes(at)hdr.qut.edu.au

##### ALPHA VERSION / WORK IN PROGRESS - this will continue to be iterated and expanded with better documentation, vignettes and bug fixes in the coming months.

`clusterBMA` is an R package for Bayesian Model Averaging (BMA) to combine multiple sets of clustering results for a given dataset, that can combine results across multiple different clustering algorithms. BMA offers some attractive benefits over other existing approaches for combining multiple sets of clustering results. Benefits include intuitive probabilistic interpretation of an overall cluster structure integrated across multiple sets of clustering results, with quantification of model-based uncertainty.

The motivation and methods for this approach are described in an accompanying publication: **(citation to go here)**

-----------------------------------------------------------------------------------------

# To get started in R:


**First, install this package using `devtools`**
```
devtools::install_github("of2/clusterBMA")
```

This should also install the dependencies:
    `reticulate`,
    `tensorflow`,
    `clusterCrit`,
    `Hmisc`, and 
    `pheatmap`

--

**If you have not previously installed** `miniconda`, **please run:**

```
reticulate::install_miniconda()
```

--

**To install required versions of Python (3.7.9) & Tensorflow (1.15.5) in a dedicated `conda` environment "clusterBMA-pyenv", with dependencies numpy (v1.18.5) and protobuf (v3.20.1) run:**

```
clusterBMA::clusterBMA_initial_python_setup()
```

**and then restart your R session.**


-----------------------------------------------------------------------------------------

## Basic example vignette

Once installation is successful, you can run the test code below line-by-line to get an idea of the basic functionality of this package. This example simulates some data from 5 clusters, runs k-means and Gaussian mixture model with K=5, and combines the two results with clusterBMA that includes: model averaging weighted by a novel approximation of posterior model probability; probabilistic combined cluster allocation; and quantification of model-based uncertainty.

The results of each input clustering algorithm need to be represented as a NxK matrix containing probabilities of cluster allocations (datapoints in rows, clusters in columns, each cell represents probability that point i is allocated to cluster k).

The main function, clusterBMA::clusterBMA() takes as an input argument a list of cluster allocation probability matrices. Each item in the list needs to be a NxK matrix A_m for each input algorithm. For 'soft' clustering algorithms like ClusterR::GMM(), this is often an available output - e.g. from the object generated by ClusterR::predict_GMM() it is stored in $cluster_proba. For 'hard' clustering algorithms like k-means, a helper function clusterBMA::hard_to_prob_fn() can be used to convert a vector of cluster allocation labels to a NxK matrix of cluster allocation probabilities. The number of clusters K can vary between input models.

```
#test

library(clusterBMA)
library(clusterGeneration)
library(ClusterR)
library(plotly)


#simulate data
test_data <- clusterGeneration::genRandomClust(numClust=5,sepVal=0.15,numNonNoisy=2,numNoisy=0,clustSizes=c(rep(100,5)),numReplicate = 1,clustszind = 3)

test_data <- test_data$datList$test_1

# convert test_data to data frame to avoid later error message

test_data <- as.data.frame(test_data)

# k-means, k=5, get allocation probabilities matrix
test_kmeans <- kmeans(test_data,centers = 5)

km_labs <- test_kmeans$cluster

# turn cluster labels into cluster allocation probability matrix
km_probs <- hard_to_prob_fn(km_labs,n_clust=5)

# gmm, k=5, get allocation probs matrix
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

# Example plot BMA cluster results - larger points have greater uncertainty

test_plot_BMA_uncertainty <- plot_ly(data=test_data,x=test_data[,1],y=test_data[,2],color=factor(test_data$alloc_vector),colors = RColorBrewer::brewer.pal(5,"Dark2"), size=test_data$alloc_uncertainty,marker=list(sizeref=0.3, sizemode="area"))
test_plot_BMA_uncertainty
```
## Example plot showing BMA combined results from k-means and GMM (simulated data)
### Larger points show greater across-model uncertainty in model averaged cluster allocation

![Example BMA plot - k-means and GMM combined (simulated data)](https://github.com/of2/clusterBMA/blob/main/example_BMA_plot.png?raw=true)
