#' rbettersyntax | ok.comma
#'
#' Allow for simpler syntax in R. This method enables trailing commata. Modification of flodel's method.
#'
#' \code{f <- ok.comma(f)}
#'
#' @param f Function to be modified to allow trailing commas
#'
#' @export ok.comma
#' @export read.args
#' @export console.log
#'
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

## print to console:
console.log <- function(tabs=0, ...) {
	lines <- list(...);
	tabs <- rep('  ',tabs);
	for(s in lines) {
		if(!(length(s) == 1)) s <- paste0(s);
		cat(tabs,s,'\n',sep='');
	}
};

## System pause:
sys.pause <- function(t=NULL) {
	if(!is.numeric(t)) {
		cat('\nPaused. Press any key to continue...');
		invisible(readline());
		cat('\n');
	} else {
		Sys.sleep(t);
	}
};

## method to extract parameters from ...
read.args <- function(vars, key, type, defaultval) {
	if(!(key %in% names(vars))) return(defaultval);
	val <- vars[[key]];
	if(is.character(type)) {
		if(type %in% c('character','chr','string')) type <- is.character;
		if(type %in% c('numeric','int','integer','double','float')) type <- is.numeric;
		if(type %in% c('logical','boolean','bool')) type <- is.numeric;
		if(type %in% c('list')) type <- is.list;
	}
	if(is.function(type)) {
		if(!type(key)) return(defaultval);
		return(val);
	}
	return(defaultval);
};