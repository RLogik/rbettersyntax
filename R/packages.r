#' @title load.packages
#' @description Loads packages. If not available, then an install attempt will be carried out.
#' @export load.packages
#'
#' @usage \code{load.packages(mode=STRING, package=STRING/s, url=STRING/s, mirror=INT, force=BOOL, dependencies=BOOL/STRINGS, quietly=BOOL, stoponerror=BOOL, lib=STRING, file.type=STRING, version=STRING)}
#' @param mode one of \code{'cran'} (Default), \code{'url'}, \code{'github'} or \code{'biocmanager'}. Determines how the package will be loaded. If \code{mode='url'} is set, then there setting the \code{package} vector is optional.
#' @param package a vector of strings.
#' @param url a vector of strings. Either \code{package} or \code{url} should be non-empty.
#' @param mirror an integer between 0 and (currently) 94. If not set, will ask for user input, upon the first time that CRAN-sources are loaded.
#' @param force if set \code{TRUE}, will force an installation. If \code{FALSE} (Default), will first attempt to load the package and then install.
#' @param dependencies either \code{TRUE}, \code{FALSE} or a string-vector. A string-vector is only useful in the case of installing under \code{mode='url'}, and in this one may use either boolean values or a subset of \code{c('Depends', 'Imports', 'LinkingTo', 'Suggests', 'Enhances')}.
#' @param quietly boolean value to control the verbosity of installers.
#' @param stoponerror a boolean value (default \code{FALSE}). If set as \code{TRUE}, will stop, if loading any package (after attempting to install it) fails.
#' @param lib an optional string, the Git-repository name.
#' @param file.type an optional string, e.g. \code{'zip'} or \code{'gz'}, to be use under \code{mode='url'}, if the downloaded file is to be first unzipped.
#' @param version a string for package versioning. Useful only under \code{mode='biocmanager'}.
#'
#' @examples \dontrun{
#'	load.packages(mirror=53, package='tidyverse', force=TRUE);
#'	load.packages(mirror=53, package=c('tidyverse', 'Matrix'), stoponerror=TRUE, force=TRUE);
#'	load.packages(mirror=53, package=c('tidyverse', 'Motrix', 'cowplot'), stoponerror=TRUE, force=TRUE); # this will stop!
#'	load.packages(mode='github', package=c('RLogik/clusterby', 'RLogik/rbettersyntax'), dependencies=TRUE);
#'	load.packages(mode='github', url='https://github.com/RLogik/clusterby/archive/master.zip', file.type='zip', force=TRUE, dependencies=FALSE);
#'
#'	## require('clusterby') will be tried first, then potentially an install, then a require.
#'	load.packages(mode='github', package='clusterby', url='https://github.com/RLogik/clusterby/archive/master.zip', file.type='zip', dependencies=TRUE);
#' };
#'
#' @keywords syntax load install packages

load.packages <- function(mode='cran', package=c(), url=c(), mirror=NULL, file.type=NULL, lib=NULL, dependencies=TRUE, force=FALSE, quietly=FALSE, stoponerror=FALSE, version=NULL) {
	isset_cranmirror <- !is.numeric(mirror) && (base::getOption('repos')[['CRAN']] == '@CRAN@');
	n <- max(length(package), length(url));

	trypackage <- function(pkg, stoponerror) {
		if(stoponerror) {
			base::library(pkg, character.only=TRUE);
		} else {
			return(base::require(pkg, character.only=TRUE));
		}
	};

	for(k in c(1:n)) {
		package_ <- package[k];
		url_ <- url[k];
		if(!is.character(package_)) mode <- 'url';

		## versuche ggf. Package zu laden, solange force == FALSE:
		if(!force && is.character(package_)) if(trypackage(package_, FALSE)) next;

		if(mode == 'github') {
			nom <- package_;
			if(is.character(lib)) nom <- paste0(lib, nom, sep='/');
			devtools::install_github(nom, dependencies=dependencies ,force=force);
		} else if(mode == 'url') {
			if(!is.character(url_)) next;
			dep <- dependencies;
			if(is.logical(dependencies)) if(dependencies) dep <- c('Imports', 'Depends');
			bool <- utilsRL::install.from.url(url=url_, file.type=file.type, install=TRUE, require.pkg=TRUE, force=force);
			if(!bool) {
				if(stoponerror) base::stop(paste0('Package von URL {',url_,'} konnte nicht geladen werden!'));
				base::warning(paste0('Package von URL {',url_,'} konnte nicht geladen werden!'));
			}
			next;
		} else if(mode == 'biocmanager') {
			if(is.null(version)) {
				BiocManager::install(package_, dependencies=dependencies, force=force);
			} else {
				BiocManager::install(package_, dependencies=dependencies, force=force, version=ver);
			}
		} else { # if (mode == 'cran') {
			if(!isset_cranmirror) utils::chooseCRANmirror(ind=mirror, graphics=FALSE);
			isset_cranmirror <- TRUE;
			utils::install.packages(package_, dependencies=dependencies, force=force, quietly=quietly);
		}

		## versuche Package zu laden:
		if(!(mode=='url') && trypackage(package_, stoponerror)) next;
		base::warning('Package ',package_,' konnte nicht geladen werden!');
	}

	return(TRUE);
};




#' @title install.from.url
#' @description Allow for simpler syntax in R. Loads packages from URL, potentially unzipping if necessary. By contrast to \code{installr}, the URLs with parameters do not lead to problems.
#' @export install.from.url
#'
#' @usage \code{install.from.url(pkg.name='...', url='...', file.type='...', install=TRUE/FALSE, require.pkg=TRUE/FALSE, force=TRUE/FALSE)}
#' @param url a character string. A url.
#' @param file.type character. Default \code{NULL}. If not set, then system will attempt to determin whether the file is to be extracted and by what method. If set to \code{'zip'}, \code{'gz'}, \code{'7z'}, etc., then an appropriate method will be applied to unpack the downloaded object.
#' @param install boolean. Default \code{TRUE}. If set to \code{TRUE}, then the package in the downloaded object will be installed, otherwise the path of the downloaded package will be returned.
#' @param pkg.name a character string. Optional. Name of Package, if known. Otherwise, the proceedure extracts this from the downloaded file.
#' @param require.pkg boolean. Default \code{FALSE}. If \code{require.pkg=TRUE} and \code{force=FALSE} and \code{pkg.name} is defined, \code{require(pkg.name)} will be called at the start. If it succeeds, no installation will take place. If \code{require.pkg=TRUE}, then \code{require(···)} will be called at the end.
#' @param force boolean. Defaut \code{FALSE}. If set to \code{FALSE}, determines, whether \code{library(···)} / \code{require(···)} will be attempted first before installation.
#'
#' @examples \dontrun{
#'	install.from.url(url='http://domain.de/mypackage.zip?parameters=areok', file.type='zip');
#'	install.from.url(url='http://domain.de/mypackage.gz?parameters=areok', file.type='gz');
#'	install.from.url(url='http://domain.de/mypackage.gz?parameters=areok'); ## file type will be automatically detected
#'	install.from.url(url='http://domain.de/mypackage?parameters=areok');
#'	path <- install.from.url(url='http://domain.de/mypackage?parameters=areok', install=FALSE);
#'	install.packages(pkgs=path, repos=NULL, type='source');
#'	path <- install.from.url(url='http://domain.de/mypackage?parameters=areok', install=FALSE, pkg.name='mypackage', require.pkg=TRUE); ## tries require('mypackage') first, otherwise installs package afresh.
#'	path <- install.from.url(url='http://domain.de/mypackage?parameters=areok', install=FALSE, require.pkg=TRUE, force=TRUE); ## forces a fresh installation of the package followed by a require(···) command (package name will be automatically detected).
#' }
#'
#' @keywords syntax load install packages URL

install.from.url <- function(pkg.name=NULL, url=NULL, file.type=NULL, install=TRUE, require.pkg=FALSE, dependencies=c('Depends', 'Imports'), force=FALSE) {
	## Versuche Package zu laden, solange force=FALSE;
	if(is.character(pkg.name) && !force && require.pkg) {
		base::message(paste0('Attempting to load Package `',pkg.name,'`.'));
		if(base::require(pkg.name, character.only=TRUE)) return(TRUE);
	}
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
			idx <- which(grepl('Package', descr$key, ignore.case=TRUE))[1];
			if(!is.na(idx)) pkg.name <- gsub('^\\s*(\\w*).*', '\\1', descr$value[idx]);
			## Versuche ggf. Package zu laden (solange force=FALSE, require.pkg=TRUE und pkg.name ein String):
			skip_install <- FALSE;
			if(is.character(pkg.name) && !force && require.pkg) {
				base::message(paste0('Attempting to load Package `',pkg.name,'`.'));
				skip_install <- base::require(pkg.name, character.only=TRUE);
			}
			## Package vom Temp-Ordner installieren (außer voriges require erfolgreich durchgeführt):
			if(!skip_install) {
				if(is.character(pkg.name)) base::message(paste0('Attempting to install Package `',pkg.name,'`.'));
				utils::install.packages(pkgs=pfad, repos=NULL, type='source', dependencies=dependencies);
			}
			base::unlink(tmpdir, recursive=TRUE);
			## Versuche ggf. Package zu laden:
			if(require.pkg) {
				pkg_loaded <- skip_install; ## wenn Intall übersprungen wurde, dann wurde Pkg schon geladen.
				if(!pkg_loaded && is.character(pkg.name)) {
					base::message(paste0('Attempting to load Package `',pkg.name,'`.'));
					pkg_loaded <- base::require(pkg.name, character.only=TRUE);
				}
				return(pkg_loaded);
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


findDESCRIPTION <- function(p) {
	path <- p;
	if(!('DESCRIPTION' %in% base::list.files(path=p, full.names=FALSE, recursive=FALSE))) {
		subfolders <- base::list.dirs(path=p, full.names=TRUE, recursive=FALSE);
		path <- NULL;
		for(pp in subfolders) {
			path <- findDESCRIPTION(pp);
			if(is.character(path)) break;
		}
	}
	return(path);
};




#' @title compile.package
#' @description Compiles R package using roxygen2.
#' @export compile.package
#'
#' @usage \code{compile.package(path=STRING, as.test=BOOL)}
#' @param path path name of package.
#' @param as.test default to \code{FALSE}. If set to \code{TRUE}, will install package locally without compilation. If set to \code{FALSE}/unset will compile via roxygen.
#'
#' @examples \dontrun{
#'	compile.package(path='~/Documents/R/packages/mytestpackage');
#'	compile.package(path='~/Documents/R/packages/mytestpackage', as.test=TRUE);
#' };
#'
#' @keywords syntax compile package

compile.package <- function(path='.', as.test=FALSE) {
	if(!require('roxygen2')) {
		devtools::install_github('klutometis/roxygen');
		library('roxygen2');
	}

	if(as.test) {
		utils::install.packages(pkgs=path, repos=NULL, type='source', dependencies=c('Imports', 'Dependencies'));
	} else {
		name <- gsub('.*(\\\\|\\/)', '', path, perl=TRUE);
		currdir <- getwd();
		setwd(path);
		devtools::document();
		setwd('..');
		devtools::install(name);
		setwd(currdir);
	}
};