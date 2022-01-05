formate_fiche=function(espece){
  fiche_brute=readr::read_csv2(paste0("http://perso.ens-lyon.fr/lise.vaudor/datasets/zoo/",
                                      "fiches_especes/fiche_",
                                      espece,
                                      ".csv"), col_names=FALSE)
  fiche_temp=str_split_fixed(fiche_brute$X1,":", n=2) %>%
    as_tibble() %>% 
    setNames(c("categorie","quantite")) %>% 
    mutate(quantite=str_replace_all(quantite,"[\\s%kg]","")) %>% 
    mutate(quantite=as.numeric(quantite))
  
  quantite_totale=fiche_temp %>%
    filter(categorie=="quantite") %>% 
    pull(quantite)
  quantite_totale
  
  fiche_formatee=fiche_temp %>% 
    filter(categorie!="quantite") %>%
    mutate(pourcentage=quantite/100) %>% 
    mutate(poids=quantite_totale*pourcentage)
  return(fiche_formatee)
}