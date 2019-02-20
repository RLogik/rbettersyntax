#' rbettersyntax | install.from.url
#'
#' Allow for simpler syntax in R. Loads packages from URL, potentially unzipping if necessary. By contrast to \code{installr}, the URLs with parameters do not lead to problems.
#'
#' \code{install.from.url(pkg.name='...', url='...', unzip=TRUE/FALSE, install=TRUE/FALSE, use.pkg=TRUE/FALSE, require.pkg=TRUE/FALSE, force=TRUE/FALSE)}
#'
#' @param url a character string. A url.
#' @param unzip boolean. Default \code{FALSE}. If set to \code{TRUE}, then will the downloaded object will be unpacked.
#' @param install boolean. Default \code{TRUE}. If set to \code{TRUE}, then the package in the downloaded object will be installed, otherwise the path of the downloaded package will be returned.
#' @param pkg.name a character string. Optional. Name of Package, if known.
#' @param use.pkg boolean. Default \code{FALSE}. If \code{use.pkg=TRUE} and \code{force=FALSE} and \code{pkg.name} is defined, \code{library(pkg.name)} will be called at the start. If it succeeds, no installation will take place. If \code{use.pkg=TRUE}, then \code{library(···)} will be called at the end.
#' @param require.pkg boolean. Default \code{FALSE}. If \code{require.pkg=TRUE} and \code{force=FALSE} and \code{pkg.name} is defined, \code{require(pkg.name)} will be called at the start. If it succeeds, no installation will take place. If \code{require.pkg=TRUE}, then \code{require(···)} will be called at the end.
#' @param force boolean. Defaut \code{FALSE}. If set to \code{FALSE}, determines, whether \code{library(···)} / \code{require(···)} will be attempted first before installation.
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




install.from.url <- function(pkg.name=NULL, url=NULL, unzip=FALSE, install=TRUE, use.pkg=FALSE, require.pkg=FALSE, force=FALSE) {
	## Versuche Package zu laden, solange force=FALSE;
	if(is.character(pkg.name) && !force) {
		bool <- FALSE;
		if(use.pkg) {
			try({
				base::library(pkg.name, character.only=TRUE);
				bool <- TRUE;
			}, silent=TRUE);
		} else if(require.pkg) {
			bool <- base::require(pkg.name, character.only=TRUE);
		}
		if(bool) return(TRUE);
	}
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
		tmpdir <- base::file.path(downloadfolder, paste0('tmp', i));
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

	## vom Package-Root installieren:
	if(is.character(pfad)) {
		if(install) {
			install.packages(pkgs=pfad, repos=NULL, type='soure', dependencies=TRUE);
			## Package-Namen von der Description-Datei zu extrahieren versuchen:
			descr <- utils::read.delim(file=file.path(pfad, 'DESCRIPTION'), sep=':', head=FALSE, col.names=c('key','value'), stringsAsFactors=FALSE);
			ind <- which(grepl('Package', descr$key, ignore.case=TRUE));
			if(length(ind) > 0) pkg.name <- gsub('^\\s*(\\w*).*', '\\1', descr$value[ind[1]]);
		} else {
			return(pfad);
		}
	} else {
		warning('No package contents could be found!');
		if(install) {
			if(use.pkg || require.pkg) return(FALSE);
		} else {
			return(tmpdir);
		}
	}

	## Temp-Ordner entfernen:
	base::unlink(tmpdir, recursive=TRUE);
	## Versuche ggf. Package zu laden:
	bool <- FALSE;
	if(use.pkg) {
		if(!is.character(pkg.name)) return(bool);
		try({
			base::library(pkg.name, character.only=TRUE);
			bool <- TRUE;
		}, silent=FALSE);
		return(bool);
	} else if(require.pkg) {
		if(!is.character(pkg.name)) return(bool);
		bool <- base::require(pkg.name, character.only=TRUE);
		return(bool);
	}

	invisible(NULL);
};