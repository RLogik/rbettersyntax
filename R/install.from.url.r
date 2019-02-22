#' @title rbettersyntax | install.from.url
#'
#' @description Allow for simpler syntax in R. Loads packages from URL, potentially unzipping if necessary. By contrast to \code{installr}, the URLs with parameters do not lead to problems.
#'
#' \code{install.from.url(pkg.name='...', url='...', file.type='...', install=TRUE/FALSE, require.pkg=TRUE/FALSE, force=TRUE/FALSE)}
#'
#' @param url a character string. A url.
#' @param file.type character. Default \code{NULL}. If not set, then system will attempt to determin whether the file is to be extracted and by what method. If set to \code{'zip'}, \code{'gz'}, \code{'7z'}, etc., then an appropriate method will be applied to unpack the downloaded object.
#' @param install boolean. Default \code{TRUE}. If set to \code{TRUE}, then the package in the downloaded object will be installed, otherwise the path of the downloaded package will be returned.
#' @param pkg.name a character string. Optional. Name of Package, if known. Otherwise, the proceedure extracts this from the downloaded file.
#' @param require.pkg boolean. Default \code{FALSE}. If \code{require.pkg=TRUE} and \code{force=FALSE} and \code{pkg.name} is defined, \code{require(pkg.name)} will be called at the start. If it succeeds, no installation will take place. If \code{require.pkg=TRUE}, then \code{require(···)} will be called at the end.
#' @param force boolean. Defaut \code{FALSE}. If set to \code{FALSE}, determines, whether \code{library(···)} / \code{require(···)} will be attempted first before installation.
#'
#' @export install.from.url
#'
#' @examples \dontrun{
#'	rbettersyntax::install.from.url(url='http://domain.de/mypackage.zip?parameters=areok', file.type='zip');
#'	rbettersyntax::install.from.url(url='http://domain.de/mypackage.gz?parameters=areok', file.type='gz');
#'	rbettersyntax::install.from.url(url='http://domain.de/mypackage.gz?parameters=areok'); ## file type will be automatically detected
#'	rbettersyntax::install.from.url(url='http://domain.de/mypackage?parameters=areok');
#'	path <- rbettersyntax::install.from.url(url='http://domain.de/mypackage?parameters=areok', install=FALSE);
#'	install.packages(pkgs=path, repos=NULL, type='source');
#'	path <- rbettersyntax::install.from.url(url='http://domain.de/mypackage?parameters=areok', install=FALSE, pkg.name='mypackage', require.pkg=TRUE); ## tries require('mypackage') first, otherwise installs package afresh.
#'	path <- rbettersyntax::install.from.url(url='http://domain.de/mypackage?parameters=areok', install=FALSE, require.pkg=TRUE, force=TRUE); ## forces a fresh installation of the package followed by a require(···) command (package name will be automatically detected).
#' }
#'
#' @keywords syntax load install packages URL




install.from.url <- function(pkg.name=NULL, url=NULL, file.type=NULL, install=TRUE, require.pkg=FALSE, force=FALSE) {
	## Versuche Package zu laden, solange force=FALSE;
	if(is.character(pkg.name) && !force && require.pkg) if(base::require(pkg.name, character.only=TRUE)) return(TRUE);
	## Erstelle downloaded_packages-Ordner, falls dies nicht existiert:
	downloadfolder <- base::file.path(base::tempdir(), 'downloaded_packages');
	if(!('downloaded_packages' %in% base::list.dirs(path=base::tempdir(), full.names=FALSE, recursive=FALSE))) base::dir.create(downloadfolder);
	## Datei von URL herunterladen:
	file <- base::tempfile(tmpdir=downloadfolder);
	utils::download.file(url, destfile=file, mode='wb');

	if(base::file.info(file)$isdir) {
		pfad <- file;
		tmpdir <- file;
	} else {
		if(!is.character(file.type)) {
			if(.Platform$OS.type == 'unix') { ## MAC OSX / Linux
				file_infos <- base::system(paste0('file -I ',file), intern=TRUE);
				file.type <- gsub('^.*:\\s*\\w*\\s*\\/\\s*(\\w*)\\s*;\\s*\\w*\\s*\\=\\s*\\w*\\s*.*$', '\\1', file_infos, perl=TRUE)
			} else { ## Windows
				## daran muss noch gebastelt werden:
				# file_infos <- base::shell(paste0('filetype -i ',file), intern=TRUE);
				file.type <- 'zip';
			}
		}
		## Temp-Ordner erstellen:
		currenttmpfolders <- base::list.dirs(path=downloadfolder, full.names=FALSE, recursive=FALSE);
		i <- 0;
		while(paste0('tmp', i) %in% currenttmpfolders) i <- i + 1;
		tmpdir <- base::file.path(downloadfolder, paste0('tmp', i));
		## Datei entpacken:
		is_unpacked <- FALSE;
		if(is.character(file.type)) {
			is_unpacked <- TRUE;
			if(file.type=='zip') {
				utils::unzip(zipfile=file, exdir=tmpdir);
			} else if(file.type=='tar') {
				utils::untar(file, exdir=tmpdir);
			} else if(file.type=='gz') {
				utils::untar(file, exdir=tmpdir);
			## daran muss noch gebastelt werden:
			# } else if(file.type=='7z') {
			# 	# utils::unzip(zipfile=file, exdir=tmpdir);
			} else {
				is_unpacked <- FALSE;
			}
		}
		base::unlink(file);
		if(is_unpacked) {
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
			pfad <- NULL;
		}
	}

	## vom Package-Root installieren:
	if(is.character(pfad)) {
		if(install) {
			## Package-Namen von der Description-Datei zu extrahieren versuchen:
			descr <- utils::read.delim(file=file.path(pfad, 'DESCRIPTION'), sep=':', head=FALSE, col.names=c('key','value'), stringsAsFactors=FALSE);
			ind <- which(grepl('Package', descr$key, ignore.case=TRUE));
			if(length(ind) > 0) pkg.name <- gsub('^\\s*(\\w*).*', '\\1', descr$value[ind[1]]);
			## Package vom Temp-Ordner installieren:
			install.packages(pkgs=pfad, repos=NULL, type='soure', dependencies=TRUE);
			base::unlink(tmpdir, recursive=TRUE);
			## Versuche ggf. Package zu laden:
			if(require.pkg) {
				if(!is.character(pkg.name)) return(FALSE);
				return(base::require(pkg.name, character.only=TRUE));
			}
			invisible(NULL);
		} else {
			return(pfad);
		}
	} else {
		warning('No package contents could be found!');
		if(install) {
			base::unlink(tmpdir, recursive=TRUE);
			if(require.pkg) return(FALSE);
			invisible(NULL);
		} else {
			return(tmpdir);
		}
	}
};