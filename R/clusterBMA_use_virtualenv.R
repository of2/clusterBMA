clusterBMA_use_virtualenv <- function(){
  print("Now telling Reticulate and Tensorflow to use virtual environment 'clusterBMA-pyenv'. Check the output below from tensorflow::tf_config() and reticulate::py_config() which should show this environment, running Python 3.7.9 and Tensorflow 1.15.5. You might have an error here if you previously were using reticulate with a different python installation. In this case, restart your R Session and before anything else run clusterBMA::clusterBMA_use_virtualenv()")
  reticulate::use_virtualenv(virtualenv = "clusterBMA-pyenv2", required = TRUE)
  tensorflow::use_virtualenv(virtualenv="clusterBMA-pyenv2", required = T)

  print("running tensorflow::tf_config() - check if correct environment and Tensorflow versions are used as described above. If not, try restarting R session and running clusterBMA::clusterBMA_use_virtualenv()")
  tensorflow::tf_config()
  print("running reticulate::py_config() - check if correct environment and Python/Tensorflow versions are used as described above. If not, try restarting R session and running clusterBMA::clusterBMA_use_virtualenv()")
  reticulate::py_config()
}
