get_nldi_basin_new=function (nldi_feature, simplify = TRUE, split = FALSE) 
{
  tryCatch({
    nldi_feature <- nhdplusTools:::check_nldi_feature(nldi_feature, convert = FALSE)
    o <- nhdplusTools:::query_nldi(paste0(nldi_feature[["featureSource"]], 
                           "/", nldi_feature[["featureID"]], "/", "basin?f=json&simplify=", 
                           ifelse(simplify, "true", "false"), "&", "splitCatchment=", 
                           ifelse(split, "true", "false")), parse_json = FALSE)
    if (is.null(o)) 
      return(NULL)
    read_sf(o)
  }, error = function(e) {
    warning(e)
    return(NULL)
  })
}
