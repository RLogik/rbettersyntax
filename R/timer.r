#' @title timer
#' @description Method to pause execution. Use \code{options('rbettersyntax::silent'=TRUE)} to disable all sys.pause commands in e. g. markdown mode.
#' @export timer
#' @exportClass timer
#'
#' @usage \code{clock <- timer()}
#'
#' @examples \dontrun{
#'	clock <- timer();
#'
#'	clock$time.absolute(); # return absolute time in seconds.
#'	clock$time(); # return relative time since last reset.
#'	clock$duration(); # return relative time since last stop.
#'	clock$reset(); # resets start time.
#'	clock$stop(); # preserves start time, but starts a new lap.
#'
#'	clock$pause(); # pause until user presses any key.
#'	clock$pause(0.5); # pause for 0.5 seconds
#'	clock$pause(10); # pause for 10 seconds
#' }
#'
#' @keywords syntax time pause




timer <- setRefClass('timer',
	fields = list(
		start='numeric',
		stop='numeric',
		n='integer'
	),
	methods = list(
		initialize = function() {
			t <- .self$time.absolute();
			.self$start <- t;
			.self$stop <- t;
			.self$n <- 0;
			invisible(NULL);
		},
		time = function() {
			t <- as.numeric(base::Sys.time());
			dt <- t - .self$start();
			return(dt);
		},
		duration = function() {
			t <- as.numeric(base::Sys.time());
			dt <- t - .self$stop();
			return(dt);
		},
		time.absolute = function() {
			t <- as.numeric(base::Sys.time());
			return(t);
		},
		reset = function() {
			t <- .self$time.absolute();
			dt <- t - .self$start;
			.self$start <- t;
			.self$stop <- t;
			.self$n <- 0;
			return(dt);
		},
		stop = function() {
			t <- .self$time.absolute();
			dt <- t - .self$stop;
			.self$stop <- t;
			.self$n <- .self$n + 1;
			return(dt);
		},
		pause = function(t=NULL) {
			if(!is.numeric(t)) {
				rsilent <- getOption('rbettersyntax::silent');
				if(!is.logical(rsilent)) rsilent <- FALSE;
				if(!rsilent) {
					message('Paused. Press any key to continue...');
					invisible(readline());
				}
			} else if(t > 0) {
				base::Sys.sleep(t);
			}
		}
	)
);