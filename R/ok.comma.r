#' rbettersyntax | ok.comma
#'
#' Allow for simpler syntax in R. This method enables trailing commata. Modification of flodel's method.
#'
#' \code{f <- ok.comma(f)}
#' \code{ok.comma.standard()}
#'
#' @param f Function to be modified to allow trailing commas
#'
#' @export ok.comma
#' @export ok.comma.standard
#'
#' @examples rbettersyntax::ok.comma.standard();
#' @examples c <- rbettersyntax::ok.comma(base::c);
#' @examples list <- rbettersyntax::ok.comma(base::list);
#' @examples myfun <- rbettersyntax::ok.comma(myfun);
#'
#' @keywords syntax trailing comma


ok.comma <- function(f) {
	FUN <- f;
	return(function(...) {
		args <- as.list(sys.call())[-1L];
		len <- length(args);
		if(len > 1L) {
			last <- args[[len]];
			if(missing(last)) args <- args[-len];
		}
		do.call(FUN, args);
	});
};

ok.comma.standard <- function() {
	c <- ok.comma(base::c);
	list <- ok.comma(base::list);
	env <- environment();
	for(obj in ls(all=TRUE)) assign(obj, get(obj, envir=env), .GlobalEnv);
};