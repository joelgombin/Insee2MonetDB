% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/INSEE2MonetDB.R
\name{Insee2MonetDB}
\alias{Insee2MonetDB}
\title{Télécharge une base de données INSEE et la charge dans une BDD MonetDB}
\usage{
Insee2MonetDB(url = NULL, zipfile = NULL, csvfile = NULL,
  folder = "./MonetDB", tablename = tolower(gsub(".(csv|txt)", "",
  gsub("^FD_", "", basename(csv_path)))), weight = "IPONDI",
  all_char = TRUE, print_head = TRUE)
}
\arguments{
\item{url}{URL de la base de données à télécharger}

\item{zipfile}{chemin de la base données zippée déjà téléchargée}

\item{csvfile}{chemin du fichier csv (dézippé) déjà téléchargé}

\item{folder}{dossier dans lequel la base de données MonetDBLite doit être créée (par défaut, dans un sous-dossier du répertoire de travail)}

\item{tablename}{nom à donner à la table créée dans la BDD}

\item{weight}{nom de la variable de pondération (généralement POND ou IPONDI)}

\item{all_char}{Faut-il définir toutes les variables (à l'excption de celle de poids) comme des character strings?}

\item{print_head}{Faut-il afficher les premières lignes de la nouvelle table créée ?}
}
\value{
Retourne (silencieusement) un objet de type \code{tbl.src_monetdblite} qui peut ensuite être utilisé avec dplyr.
}
\description{
Télécharge une base de données INSEE et la charge dans une BDD MonetDB
}
\examples{
\dontrun{tbl_mobsco_2012 <- Insee2MonetDB("http://telechargement.insee.fr/fichiersdetail/RP2012/txt/RP2012_MOBSCO_txt.zip")}
}
