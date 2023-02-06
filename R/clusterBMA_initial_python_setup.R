# install python 3.7 in a conda environment "clusterBMA-pyenv", and tensorflow 1.15.5 - for symmetric simplex matrix factorisation in TF


library(reticulate)
library(tensorflow)

clusterBMA_initial_python_setup <- function(){

  # NEED TO CHECK IF MINICONDA IS INSTALLED HERE

  # print("Installing miniconda")
  #
  # reticulate::install_miniconda()

  print("Setting up virtual environment 'clusterBMA-pyenv' with Python 3.7.9, numpy 1.18.5, protobuf 3.20.1, and TensorFlow 1.15.5")


  # OLD v1

  # reticulate::conda_create(
  #    envname = "clusterBMA-pyenv",
  #    python_version = "3.7.9",
  #    packages=("tensorflow")
  #  )

  # OLD v2
  # reticulate::py_install(
  #   packages=c("numpy==1.18.5",
  #              "protobuf==3.20.1",
  #              "tensorflow=1.15.5"),
  #   envname = "clusterBMA-pyenv",
  #   method = "conda",
  #   conda = "auto",
  #   python_version = "3.7.9"
  # )

  cbma_pyversion <- "3.7.9"
  reticulate::install_python(version=cbma_pyversion)
  reticulate::virtualenv_create(envname = "clusterBMA-pyenv2", python_version = cbma_pyversion, packages=c("numpy==1.18.5","protobuf==3.20.1","tensorflow"))

  #print("Installing TensorFlow v1.15.5 in virtual environment 'clusterBMA-pyenv'")

  #tensorflow::install_tensorflow(version = "1.15.5",envname = "clusterBMA-pyenv2",python_version = "3.7.9")

  #tensorflow::install_tensorflow(method="conda",version = "1.15.5",envname = "clusterBMA-pyenv",python_version = "3.7.9")

  reticulate::use_virtualenv(virtualenv = "clusterBMA-pyenv2", required = TRUE)
  tensorflow::use_virtualenv(virtualenv="clusterBMA-pyenv2", required = TRUE)

  reticulate::py_config()

  print("Python 3.7.9 & Tensorflow 1.15.5 have been set up in conda environment 'clusterBMA-pyenv'")
}
