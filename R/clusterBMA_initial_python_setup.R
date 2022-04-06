# install python 3.7 in a conda environment "clusterBMA-pyenv", and tensorflow 1.15.5 - for symmetric simplex matrix factorisation in TF


library(reticulate)
library(tensorflow)

clusterBMA_initial_python_setup <- function(){

  # NEED TO CHECK IF MINICONDA IS INSTALLED HERE

  # print("Installing miniconda")
  #
  # reticulate::install_miniconda()

  print("Setting up conda environment 'clusterBMA-pyenv' with Python 3.7.9")

  # reticulate::conda_create(
  #    envname = "clusterBMA-pyenv",
  #    python_version = "3.7.9",
  #    packages=("tensorflow")
  #  )

  reticulate::py_install(
    envname = "clusterBMA-pyenv",
    method = "conda",
    conda = "auto",
    python_version = "3.7.9"
  )

  print("Installing TensorFlow v1.15.5 in conda environment 'clusterBMA-pyenv'")

  tensorflow::install_tensorflow(method="conda",version = "1.15.5",envname = "clusterBMA-pyenv",python_version = "3.7.9")

  reticulate::use_condaenv(condaenv = "clusterBMA-pyenv", required = TRUE)
  tensorflow::use_condaenv(condaenv="clusterBMA-pyenv", required = T)

  print("Python 3.7.9 & Tensorflow 1.15.5 have been set up in conda environment 'clusterBMA-pyenv'")
}
