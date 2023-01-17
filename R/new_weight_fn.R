# Needs to be updated to allow choice of metric - from clusterCrit

# Also needs to account for some metrics want to be maximised, some want to be minimised!!

# clusterCrit::getCriteriaNames(isInternal=T)
# [1] "Ball_Hall"         "Banfeld_Raftery"   "C_index"           "Calinski_Harabasz" "Davies_Bouldin"    "Det_Ratio"         "Dunn"             
# [8] "Gamma"             "G_plus"            "GDI11"             "GDI12"             "GDI13"             "GDI21"             "GDI22"            
# [15] "GDI23"             "GDI31"             "GDI32"             "GDI33"             "GDI41"             "GDI42"             "GDI43"            
# [22] "GDI51"             "GDI52"             "GDI53"             "Ksq_DetW"          "Log_Det_Ratio"     "Log_SS_Ratio"      "McClain_Rao"      
# [29] "PBM"               "Point_Biserial"    "Ray_Turi"          "Ratkowsky_Lance"   "Scott_Symons"      "SD_Scat"           "SD_Dis"           
# [36] "S_Dbw"             "Silhouette"        "Tau"               "Trace_W"           "Trace_WiB"         "Wemmert_Gancarski" "Xie_Beni"    


# Expects cluster_labels to be data frame with columns of cluster labels from different algorithms (hard projection from soft algos), and n_sols to be the number of solutions input
new_weight_fn <- function(input_data,cluster_label_df,n_sols,wt_crit_name,wt_crit_direction){
  
  out_df <- data.frame(crit = NA, W_m = NA)
  
  #050721 trying quick fix here braindead 3am
  input_data <- as.matrix(input_data)
  
  for (i in 1:n_sols){
    wt_temp <- clusterCrit::intCriteria(traj=input_data,part=as.integer(cluster_label_df[,i]),crit=c(wt_crit_name))

    row_temp <- c(wt_temp[[1]],NA)
    out_df <- rbind(out_df,row_temp)
  }
  
  #remove NA row
  out_df <- out_df[-1,]
  
  if(wt_crit_direction=="max"){
  for (i in 1:n_sols){
    out_df[i,"W_m"] <- out_df$crit[i]/sum(out_df$crit)
  }
  } else if(wt_crit_direction=="min") {
    for (i in 1:n_sols){
      out_df[i,"W_m"] <- (1/out_df$crit[i])/sum(1/out_df$crit)
    }
  } else {print ("set wt_crit_direction to 'max' if weighting internal validation criterion should be maximised, or 'min' if it should be minimised")}
  
  
  names(out_df)[1] <- wt_crit_name
  
  return(out_df)
}
