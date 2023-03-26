# install python 3.7 in a conda environment "clusterBMA-pyenv", and tensorflow 1.15.5 - for symmetric simplex matrix factorisation in TF


library(reticulate)
library(tensorflow)

#' Set up Conda environment using `miniconda` with Python and Tensorflow (Run once on first install)
#'
#' @return Sets up conda environment with Python and Tensorflow
#' @export
#'

clusterBMA_initial_python_setup <- function(){

  # NEED TO CHECK IF MINICONDA IS INSTALLED HERE

  # print("Installing miniconda")
  #
  # reticulate::install_miniconda()

  print("Setting up virtual environment 'clusterBMA-pyenv' with Python 3.10.9, TensorFlow 2.11, numpy, protobuf")


  # OLD v1

  # reticulate::conda_create(
  #    envname = "clusterBMA-pyenv",
  #    python_version = "3.7.9",
  #    packages=("tensorflow")
  #  )

 #OLD v2
  # reticulate::py_install(
  #   packages=c("numpy==1.18.5",
  #              "protobuf==3.20.1",
  #              "tensorflow=1.15.5"), #need to use newer version of TF (and python?)
  #   envname = "clusterBMA-pyenv",
  #   method = "conda",
  #   conda = "auto",
  #   python_version = "3.7.9"
  # )


  # v3 trying updated packages

  reticulate::py_install(
    packages=c("numpy",
               "protobuf",
               "tensorflow"), #need to use newer version of TF (and python?)
    envname = "clusterBMA-pyenv_newpkgs",
    method = "conda",
    conda = "auto",
    python_version = "3.10"
  )


  #print("Installing TensorFlow v1.15.5 in virtual environment 'clusterBMA-pyenv'")

  tensorflow::install_tensorflow(envname = "clusterBMA-pyenv_newpkgs",python_version = "3.10")

  #tensorflow::install_tensorflow(method="conda",version = "1.15.5",envname = "clusterBMA-pyenv",python_version = "3.7.9")

  reticulate::use_condaenv(condaenv = "clusterBMA-pyenv_newpkgs", required = TRUE)
  tensorflow::use_condaenv(condaenv="clusterBMA-pyenv_newpkgs", required = TRUE)

  reticulate::py_config()

  print("Python 3.7.9 & Tensorflow 1.15.5 have been set up in conda environment 'clusterBMA-pyenv'")
}
