#' rbettersyntax | standard.setup
#'
#' Provides standard ok.comma'd functions and enables via option a disabling of menu and sys.pause.
#'
#' \code{ok.comma.standard.setup()}
#'
#' @export standard.setup
#'
#' @examples options('rbettersyntax::silent'=TRUE);
#' @examples options('rbettersyntax::silent'=FALSE);
#' @examples rbettersyntax::standard.setup();
#'
#' @keywords syntax rbettersyntax standard setup




standard.setup <- function() {
	env <- environment();

	c <- ok.comma(base::c);
	list <- ok.comma(base::list);
	menu <- function(...) {
		rmd_on <- getOption('rbettersyntax::silent');
		if(!is.logical(rmd_on)) rmd_on <- FALSE;
		if(!rmd_on) {
			args <- as.list(sys.call())[-1L];
			env <- parent.frame();
			do.call(base::menu, args, envir=env);
		}
	};

	for(obj in ls(all=TRUE)) assign(obj, get(obj, envir=env), .GlobalEnv);
};