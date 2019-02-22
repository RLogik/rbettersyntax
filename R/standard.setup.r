#' @title rbettersyntax | standard.setup
#'
#' @description Provides standard ok.comma'd functions and enables via option a disabling of menu and sys.pause.
#'
#' \code{standard.setup()}
#' \code{menu(options, title=title)}
#'
#' @export standard.setup
#'
#' @param options character string vector. As per the definition of base::menu
#'
#' @examples \dontrun{
#'	options('rbettersyntax::silent'=TRUE);
#'	standard.setup();
#'	# will skip user interaction and return \code{0}:
#'	menu(c('Yes','No'), title='Proceed with script?');
#'	sys.pause(); # will skip user interaction proceed with code.
#'	sys.pause(1); # will still pause for 1s.
#'	console.log(tabs=0, 'My message.'); # will not display.
#'	console.log(tabs=0, silent.off=TRUE, 'My message.'); # will not display.
#'	console.log(tabs=0, silent.off=FALSE, 'My message.'); # will show.
#'	# reactivates menu, sys.pause, console.log, etc.
#'	options('rbettersyntax::silent'=FALSE);
#' }
#'
#' @keywords syntax rbettersyntax standard setup




standard.setup <- function() {
	c <- ok.comma(base::c);
	list <- ok.comma(base::list);
	menu <- function(...) {
		rsilent <- getOption('rbettersyntax::silent');
		if(!is.logical(rsilent)) rsilent <- FALSE;
		if(rsilent) {
			return(0);
		} else {
			args <- as.list(sys.call())[-1L];
			env <- parent.frame();
			do.call(utils::menu, args, envir=env);
		}
	};

	for(obj in ls(all=TRUE)) assign(obj, get(obj, envir=environment()), .GlobalEnv);
};
