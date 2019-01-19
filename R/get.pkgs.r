#' rbettersyntax | get.pkgs
#'
#' Allow for simpler syntax in R. Loads packages. If not available, then an install attempt will be carried out.
#'
#' \code{get.pkgs(mirror, pkg1, pkg2, ...)}
#'
#' @param mirror an integer between 0 and (currently) 94. If set to \code{NULL}, will ask for user input.
#' @param pkg1 a character string or list. If a character string, then the package \code{pkg1} will be loaded via cran. Otherwise if a list and if \code{mode=github} or \code{mode=biocmanager} is set, then an appropriate alternative will be used.
#' @param pkg2 similar. User can set 0 or more 
#'
#' @export get.pkgs
#'
#' @examples rbettersyntax::get.pkgs(53, 'tidyverse', list('clusterby', mode='github', lib='RLogik'), list('cow_plot', dep=TRUE));
#'
#' @keywords syntax load install packages




get.pkgs <- function(mirror=NULL, ...) {
	args <- as.list(sys.call())[-1L];
	len <- length(args);
	if(len > 1L) {
		last <- args[[len]];
		if(missing(last)) args <- args[-len];
	}
	args <- args[-1];

	if(is.null(mirror)) {
		chooseCRANmirror(graphics=FALSE);
	} else {
		chooseCRANmirror(mirror, graphics=FALSE);
	}

	for(opt in args) {
		pkg <- opt[1];
		if(require(pkg, character.only=TRUE)) next;
		args <- as.list(opt);
		mode <- rbettersyntax::read.args(args, 'mode', is.character, 'cran');
		lib <- rbettersyntax::read.args(args, 'lib', is.character, '');
		force <- rbettersyntax::read.args(args, 'force', is.logical, FALSE);
		dep <- rbettersyntax::read.args(args, 'dep', is.logical, TRUE);
		ver <- rbettersyntax::read.args(args, 'version', is.character, NULL);
		stoponerror_ <- rbettersyntax::read.args(args, 'stop', is.logical, stoponerror);
		if(mode == 'github') {
			nom <- paste(c(lib, pkg), collapse='/');a
			if(is.null(ver)) {
				devtools::install_github(nom, dep=dep ,force=force);
			} else {
				devtools::install_github(nom, dep=dep ,force=force, version=ver);
			}
		} else if(mode == 'biocmanager') {
			if(is.null(ver)) {
				BiocManager::install(pkg, dep=dep, force=force);
			} else {
				BiocManager::install(pkg, dep=dep, force=force, version=ver);
			}
		} else { # if (mode == 'cran') {
			if(is.null(ver)) {
				install.packages(pkg, dep=dep, force=force); #character.only=TRUE);
			} else {
				devtools::install.packages(pkg, dep=dep, force=force, version=ver); #character.only=TRUE);
			}
		}
		if(require(pkg, character.only=TRUE)) next;
		if(stoponerror_) stop(paste0('Package ',pkg,' nicht gefunden!'));
		cat('FEHLER: Package ',pkg,' nicht gefunden!');
	}
};
