#' rbettersyntax | sys.pause
#'
#' Allow for simpler syntax in R. Method to pause execution. Use \code{options('rbettersyntax::silent'=TRUE)} to disable all sys.pause commands in e. g. markdown mode.
#'
#' \code{sys.pause(* t)}
#'
#' @param t non-negative double. Argument is optional. If \code{t} is set, then the script will be paused for \code{t} seconds. If it is not set, then a user key-response will be awaited.
#'
#' @export sys.pause
#'
#' @examples sys.pause(); # pause until user presses any key.
#' @examples sys.pause(0.5); # pause for 0.5 seconds
#' @examples sys.pause(10); # pause for 10 seconds
#'
#' @keywords syntax system pause




sys.pause <- function(t=NULL) {
	if(!is.numeric(t)) {
		rsilent <- getOption('rbettersyntax::silent');
		if(!is.logical(rsilent)) rsilent <- FALSE;
		if(!rsilent) {
			cat('\nPaused. Press any key to continue...');
			invisible(readline());
			cat('\n');
		}
	} else {
		Sys.sleep(t);
	}
};