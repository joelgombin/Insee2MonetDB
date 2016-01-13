

#' Télécharge une base de données INSEE et la charge dans une BDD MonetDB
#'
#' @param url URL de la base de données à télécharger
#' @param zipfile chemin de la base données zippée déjà téléchargée
#' @param csvfile chemin du fichier csv (dézippé) déjà téléchargé
#' @param folder dossier dans lequel la base de données MonetDBLite doit être créée (par défaut, dans un sous-dossier du répertoire de travail)
#' @param tablename nom à donner à la table créée dans la BDD
#' @param weight nom de la variable de pondération (généralement POND ou IPONDI)
#' @param all_char Faut-il définir toutes les variables (à l'excption de celle de poids) comme des character strings?
#' @param print_head Faut-il afficher les premières lignes de la nouvelle table créée ?
#'
#' @import dplyr DBI MonetDBLite MonetDB.R
#'
#' @return Retourne (silencieusement) un objet de type \code{tbl.src_monetdb} qui peut ensuite être utilisé avec dplyr.
#' @export
#'
#' @examples
#' \dontrun{tbl_mobsco_2012 <- Insee2MonetDB("http://telechargement.insee.fr/fichiersdetail/RP2012/txt/RP2012_MOBSCO_txt.zip")}
Insee2MonetDB <- function(url = NULL, zipfile = NULL, csvfile = NULL, folder = "./MonetDB", tablename = tolower(gsub(".(csv|txt)", "", gsub("^FD_", "", basename(csv_path)))), weight = "IPONDI", all_char = TRUE, print_head = TRUE) {

  library("MonetDB.R") # ugly but can't seem to make it work otherwise

  if (!dir.exists(folder)) {
    dir.create(folder)
  }
  if (is.null(csvfile)) {
    tmp <- tempdir()
    if (is.null(zipfile)) {
      file <- basename(url)
      downloader::download(url, destfile = file.path(tmp, file))
      path <- file.path(tmp, file)
    }
    if (is.null(url)) {
      path <- zipfile
    }
    unzip(path, unzip = "unzip", exdir = tmp, junkpaths = TRUE)
    csv_path <- file.path(tmp, grep("FD_", grep("^FD", list.files(tmp), value = TRUE), value = TRUE))
  } else {
    csv_path <- normalizePath(csvfile)
  }

  mdb <- dbConnect(MonetDB.R(), embedded = folder)

  try(invisible(dbSendQuery(mdb, paste0("DROP TABLE ", tablename))), silent = TRUE)

  sep <- "';'"
  guess <- read.csv(file = csv_path, sep = ";", stringsAsFactors=FALSE, nrows=1000)
  if (dim(guess)[2] < 2) {
    guess <- read.csv(file = csv_path, sep = ",", stringsAsFactors=FALSE, nrows=1000)
    sep <- "','"
  }

  create <- sprintf(paste0("CREATE TABLE ", tablename, " ( %s )"),
                    paste0(sprintf('"%s" %s', tolower(colnames(guess)),  # garder tolower ou pas ?
                                   sapply(guess, dbDataType, dbObj=mdb)), collapse = ","))
  if (all_char) {
    create <- gsub('INTEGER', 'STRING', create, fixed = TRUE)
  }

  invisible(dbSendQuery(mdb, create))

  if (grepl("\r", readChar(file(csv_path), 10000), fixed = TRUE, useBytes = TRUE)) {# cas étrange où l'insee utilise \r\n en fin de ligne plutot que \n
    sep <- paste0(sep, ",'\\r\\n'")
  }

  invisible(dbSendQuery(mdb, paste0("COPY OFFSET 2 INTO ", tablename, " FROM '", csv_path, "' USING  DELIMITERS ", sep)))

  conn <- MonetDB.R::src_monetdb(embedded = folder)
  table <- tbl(conn, from = tablename)

  if (print_head) {
    glimpse(table)
  }
  if (is.null(csvfile)) unlink(tmp, recursive = TRUE)
  invisible(table)
}
