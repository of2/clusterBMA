# Returns c(Xie-Beni,Calinski-Harabasz)
# Expects cluster_labels to be data frame with columns of cluster labels from different algorithms (hard projection from soft algos), and n_sols to be the number of solutions input
ch_xb_weight_fn <- function(input_data,cluster_label_df,n_sols){

  out_df <- data.frame(XB = NA, CH = NA, XB_w = NA, CH_w = NA, W_each = NA, W_m = NA)

  #050721 trying quick fix here braindead 3am
  input_data <- as.matrix(input_data)

  for (i in 1:n_sols){
    xb_temp <- clusterCrit::intCriteria(traj=input_data,part=as.integer(cluster_label_df[,i]),crit=c("Xie_Beni"))
    ch_temp <- clusterCrit::intCriteria(traj=input_data,part=as.integer(cluster_label_df[,i]),crit=c("Calinski_Harabasz"))

    row_temp <- c(xb_temp$xie_beni,ch_temp$calinski_harabasz,NA,NA,NA,NA)
    out_df <- rbind(out_df,row_temp)
  }

  #remove NA row
  out_df <- out_df[-1,]

  for (i in 1:n_sols){
    out_df[i,"XB_w"] <- out_df$XB[i]/sum(out_df$XB)
    out_df[i,"CH_w"] <- (1/out_df$CH[i])/sum(1/out_df$CH)
  }

  out_df$W_each <- out_df$XB_w + out_df$CH_w

  for (i in 1:n_sols){
    out_df[i,"W_m"] <- out_df$W_each[i]/sum(out_df$W_each)
  }

  return(out_df)
}
