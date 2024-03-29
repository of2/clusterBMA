#' Point reticulate and tensorflow to the correct conda environment
#'
#' @export
#'
#' @examples Run at start when setting up a session for clusterBMA: clusterBMA_use_condaenv()
clusterBMA_use_condaenv <- function(){
  print("Now telling Reticulate and Tensorflow to use conda environment 'clusterBMA-pyenv_newpkgs'. Check the output below from tensorflow::tf_config() and reticulate::py_config() which should show this environment, running Python 3.10.9 and Tensorflow 2.11.X. You might have an error here if you previously were using reticulate with a different python installation. In this case, restart your R Session and before anything else run clusterBMA::clusterBMA_use_condaenv()")
  reticulate::use_condaenv(condaenv = "clusterBMA-pyenv_newpkgs", required = TRUE)
  tensorflow::use_condaenv(condaenv="clusterBMA-pyenv_newpkgs", required = T)

  print("running tensorflow::tf_config() - check if correct environment and Tensorflow versions are used as described above. If not, try restarting R session and running clusterBMA::clusterBMA_use_condaenv()")
  tensorflow::tf_config()
  print("running reticulate::py_config() - check if correct environment and Python/Tensorflow versions are used as described above. If not, try restarting R session and running clusterBMA::clusterBMA_use_condaenv()")
  reticulate::py_config()
}
