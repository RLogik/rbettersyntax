#' @title standard.setup
#' @description Provides standard trailing.comma'd functions and enables via option a disabling of menu and sys.pause.
#' @export standard.setup
#'
#' @usage \code{standard.setup();}
#'
#' @param options character string vector. As per the definition of base::menu
#'
#' @examples \dontrun{
#'	options('utilsRL::silent'=TRUE);
#'	standard.setup();
#'	# will skip user interaction and return \code{0}:
#'	menu(c('Yes','No'), title='Proceed with script?');
#'	sys.pause(); # will skip user interaction proceed with code.
#'	sys.pause(1); # will still pause for 1s.
#'	console.log(tabs=0, 'My message.'); # will not display.
#'	console.log(tabs=0, silent.off=TRUE, 'My message.'); # will not display.
#'	console.log(tabs=0, silent.off=FALSE, 'My message.'); # will show.
#'	# reactivates menu, sys.pause, console.log, etc.
#'	options('utilsRL::silent'=FALSE);
#' }
#'
#' @keywords syntax rbettersyntax standard setup

standard.setup <- function() {
	c <- trailing.comma(base::c);
	list <- trailing.comma(base::list);
	menu <- function(...) {
		rsilent <- getOption('utilsRL::silent');
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




#' @title this.dir
#' @description Change the current directory (for RStudio).
#' @export this.dir
#'
#' @usage \code{this.dir(chdir=<BOOL>);}
#'
#' @param chdir boolean. Default \code{chdir=TRUE}. Whether or not to change directory to location of current script, or simply return the path.
#'
#' @examples \dontrun{
#'	# Prefix script with:
#'	bool <- this.dir();
#'	# or
#'	bool <- this.dir(chdir=TRUE);
#'	# to change to current directory.
#'	# Return value: bool = TRUE <==> succesfully found currently and changed to this path.
#'
#'	path <- this.dir(chdir=TRUE);
#'	# does not change directory, but attempts to get
#'	# the folder location of current script.
#'	# If unsuccessful, returns path = NULL.
#' }
#'
#' @keywords syntax change direcctory RStudio

this.dir <- function(chdir=TRUE) {
	path <- NULL;
	for(fm in base::sys.frames()) {
		if('ofile' %in% base::names(fm)) {
			path <- base::dirname(fm$ofile);
			break;
		}
	}
	if(chdir) {
		if(is.character(path)) {
			setwd(path);
			return(TRUE);
		}
		return(FALSE);
	}
	return(path);
};
