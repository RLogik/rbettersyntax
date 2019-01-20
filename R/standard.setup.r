#' rbettersyntax | standard.setup
#'
#' Provides standard ok.comma'd functions and enables via option a disabling of menu and sys.pause.
#'
#' \code{standard.setup()}
#' \code{menu(options, title=title)}
#'
#' @export standard.setup
#'
#' @param options character string vector. As per the definition of base::menu
#'
#' @examples options('rbettersyntax::silent'=TRUE);
#' @examples rbettersyntax::standard.setup();
#' @examples menu(c('Yes','No'), title='Proceed with script?'); # will skip user interaction and return NULL.
#' @examples rbettersyntax::sys.pause(); # will skip user interaction proceed with code.
#' @examples rbettersyntax::sys.pause(1); # will still pause for 1s.
#' @examples rbettersyntax::console.log(tabs=0, 'My message.'); # will not display.
#' @examples rbettersyntax::console.log(tabs=0, silent.off=TRUE, 'My message.'); # will not display.
#' @examples rbettersyntax::console.log(tabs=0, silent.off=FALSE, 'My message.'); # will show.
#' @examples options('rbettersyntax::silent'=FALSE); # reactivates menu, sys.pause, console.log, etc.
#'
#' @keywords syntax rbettersyntax standard setup




standard.setup <- function() {
	env <- environment();

	c <- ok.comma(base::c);
	list <- ok.comma(base::list);
	menu <- function(...) {
		rsilent <- getOption('rbettersyntax::silent');
		if(!is.logical(rsilent)) rsilent <- FALSE;
		if(rsilent) {
			return(NULL);
		} else {
			args <- as.list(sys.call())[-1L];
			env <- parent.frame();
			do.call(utils::menu, args, envir=env);
		}
	};

	for(obj in ls(all=TRUE)) assign(obj, get(obj, envir=env), .GlobalEnv);
};