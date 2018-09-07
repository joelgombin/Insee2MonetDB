## Motivation
Ce petit package est essentiellement utilitaire et vise à automatiser la tâche de télécharger une [base de données détail de l'INSEE](http://www.insee.fr/fr/bases-de-donnees/fichiers-detail.asp) et la mettre dans une base de données MonetDB qui peut ensuite etre interfacée depuis R via les packages [MonetDBlite](https://github.com/hannesmuehleisen/MonetDBLite) et [dplyr](https://cran.r-project.org/web/packages/dplyr/vignettes/databases.html). 

## Installation 
```r
devtools::install_github("joelgombin/Insee2MonetDB")
```
