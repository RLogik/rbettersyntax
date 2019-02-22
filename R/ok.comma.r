#' @title rbettersyntax | ok.comma
#' @description Allow for simpler syntax in R. This method enables trailing commata. Modification of flodel's method.
#' @export ok.comma
#'
#' @usage \code{f <- ok.comma(f)}
#' @param f Function to be modified to allow trailing commas
#'
#' @examples \dontrun{
#'	c <- rbettersyntax::ok.comma(base::c);
#'	list <- rbettersyntax::ok.comma(base::list);
#'	myfun <- rbettersyntax::ok.comma(myfun);
#' }
#'
#' @keywords syntax trailing comma




ok.comma <- function(f) {
	FUN <- f;
	return(function(...) {
		env <- parent.frame();
		args <- as.list(sys.call())[-1L];
		len <- length(args);
		if(len > 1L) {
			last <- args[[len]];
			if(missing(last)) args <- args[-len];
		}
		do.call(FUN, args, envir=env);
	});
};