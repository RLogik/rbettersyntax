#' rbettersyntax | install.from.url
#'
#' Allow for simpler syntax in R. Loads packages from URL, potentially unzipping if necessary. By contrast to \code{installr}, the URLs with parameters do not lead to problems.
#'
#' \code{install.from.url(url='...', unzip=TRUE/FALSE, install=TRUE/FALSE)}
#'
#' @param url a character string. A url.
#' @param unzip boolean. Default \code{FALSE}. If set to \code{TRUE}, then will the downloaded object will be unpacked.
#' @param install boolean. Default \code{TRUE}. If set to \code{TRUE}, then the package in the downloaded object will be installed, otherwise the path of the downloaded package will be returned.
#'
#' @export install.from.url
#'
#' @examples rbettersyntax::install.from.url(url='http://domain.de/mypackage.zip?parameters=areok', unzip=TRUE);
#' @examples rbettersyntax::install.from.url(url='http://domain.de/mypackage.gz?parameters=areok', unzip=TRUE);
#' @examples rbettersyntax::install.from.url(url='http://domain.de/mypackage?parameters=areok');
#' @examples path <- rbettersyntax::install.from.url(url='http://domain.de/mypackage?parameters=areok', install=FALSE);
#' @examples install.packages(pkgs=path, repos=NULL, type='source');
#'
#' @keywords syntax load install packages URL




install.from.url <- function(url=NULL, unzip=FALSE, install=TRUE) {
	## Erstelle downloaded_packages-Ordner, falls dies nicht existiert:
	downloadfolder <- base::file.path(base::tempdir(), 'downloaded_packages');
	if(!('downloaded_packages' %in% base::list.dirs(path=base::tempdir(), full.names=FALSE, recursive=FALSE))) base::dir.create(downloadfolder);
	## Datei von URL herunterladen:
	file <- base::tempfile(tmpdir=downloadfolder);
	utils::download.file(url, destfile=file, mode='wb');
	if(unzip) {
		## Temp-Ordner erstellen:
		currenttmpfolders <- base::list.dirs(path=downloadfolder, full.names=FALSE, recursive=FALSE);
		i <- 0;
		while(paste0('tmp', i) %in% currenttmpfolders) i <- i + 1;
		tmpdir <- base::file.path(base::tempdir(), paste0('tmp', i));
		## Datei entpacken:
		utils::unzip(zipfile=file, exdir=tmpdir);
		base::unlink(file);
		## Package-Root finden:
		findDESCRIPTION <- function(p) {
			if('DESCRIPTION' %in% base::list.files(path=p, full.names=FALSE, recursive=FALSE)) {
				path <- p;
			} else {
				subfolders <- base::list.dirs(path=p, full.names=TRUE, recursive=FALSE);
				path <- NULL;
				for(pp in subfolders) {
					path <- findDESCRIPTION(pp);
					if(is.character(path)) break;
				}
			}
			return(path);
		};
		pfad <- findDESCRIPTION(tmpdir);
	} else {
		pfad <- file;
		tmpdir <- file;
	}
	## vom Root installieren:
	if(is.character(pfad)) {
		if(install) install.packages(pkgs=pfad, repos=NULL, type='soure');
	} else {
		warning('No package contents could be found!');
		pfad <- tmpdir;
	}
	if(install) {
		## Temp-Ordner entfernen:
		base::unlink(tmpdir, recursive=TRUE);
		invisible(NULL);
	} else {
		return(pfad);
	}
};