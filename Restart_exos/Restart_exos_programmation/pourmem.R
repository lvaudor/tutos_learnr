ter une fiche: une colonne=une variable (et une unité)

Chaque fiche comprend le poids total d'aliment (categorie== "quantite") et les proportions des différents types d'aliments. C'est en fait un peu mélanger les torchons et les serviettes!!

On va plutôt essayer d'indiquer un pourcentage et le poids correspondant pour chaque catégorie d'aliment...

```{r, echo=FALSE}
lit_fiche=function(espece){
  fiche=readr::read_csv2(paste0("http://perso.ens-lyon.fr/lise.vaudor/datasets/zoo/",
                         "fiches_especes/fiche_",
                         espece,
                         ".csv"), col_names=FALSE)
  return(fiche)
}
```

C'est ce que permettent de réaliser les lignes suivantes, ici par exemple pour la fiche "antilope":
  
  ```{r montre_formatage, echo=TRUE, exercise=FALSE}
# lecture de la fiche brute
fiche_brute=readr::read_csv2(paste0("http://perso.ens-lyon.fr/lise.vaudor/datasets/zoo/",
                                    "fiches_especes/fiche_",
                                    "antilope",
                                    ".csv"), col_names=FALSE)
fiche_brute

# mise en forme
fiche_temp=str_split_fixed(fiche_brute$X1,":", n=2) %>%
  as_tibble() %>% 
  setNames(c("categorie","quantite")) %>% 
  mutate(quantite=str_replace_all(quantite,"[\\s%kg]","")) %>% 
  mutate(quantite=as.numeric(quantite))
fiche_temp


# recup quantite totale
quantite_totale=fiche_temp %>%
  filter(categorie=="quantite") %>% 
  pull(quantite)
quantite_totale

# calcul du pourcentage et du poids pour chaque catégorie d'aliment
fiche_formatee=fiche_temp %>% 
  filter(categorie!="quantite") %>%
  mutate(pourcentage=quantite/100) %>% 
  mutate(poids=quantite_totale*pourcentage)
fiche_formatee
```

Pour l'instant, la fonction `lit_fiche()` lit la fiche et la renvoie dans sa **forme brute**: il faut donc ajouter quelques lignes pour que cette fonction renvoie la **fiche formatée** (comme on l'attend vu son nom...). La librairie `tidyverse` est déjà chargée dans l'environnement. Je vous laisse **compléter la fonction** en vous inspirant des lignes de code ci-dessus:

```{r ajoute_formatage-setup}
library(tidyverse)
```


```{r ajoute_formatage, exercise=TRUE}
formate_fiche=function(espece){
  fiche_brute=lit_fiche(espece)
  fiche_formatee=_____
  ________
  ________
  ________

  return(fiche_formatee)
}
formate_fiche("lion")
```


```{r ajoute_formatage-solution}
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
  
  fiche_formatee=fiche_temp %>% 
    filter(categorie!="quantite") %>%
    mutate(pourcentage=quantite/100) %>% 
    mutate(poids=quantite_totale*pourcentage)
    return(fiche_formatee)
}
formate_fiche("lion")
```

## Appliquer cette fonction, en boucle

Voici les espèces pour lesquelles vous disposez d'une fiche d'alimentation:


```{r, echo=TRUE}
especes=c("antilope","autruche","chameau","lion","elephant",
                      "fennec","flamand_rose","girafes","guepard","hyene",
                      "iguane","lion","loup","lynx","otarie","ours_polaire",
                      "ours","panthere","perroquets","phacochere","rhinoceros",
                      "serpent","singe","suricate","tigre","tortue")
```

```{r boucle_espece-setup}
library(tidyverse)
source("scripts/formate_fiche.R")
```

Faites tourner une fonction de purrr sur l'ensemble du vecteur "especes" de manière à obtenir une tibble unique en sortie.

```{r boucle_espece, exercise=TRUE}
alim=________(especes, .f=___) %>% 
  bind_rows()
```


```{r boucle_espece-solution}
alim=map(especes,.f=formate_fiche) %>% 
  bind_rows()
```

Remarque: vous auriez pu éviter l'appel à bind_rows en faisant directement `map_df()`
