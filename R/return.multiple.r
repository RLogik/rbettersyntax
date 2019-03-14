#' @title rbettersyntax | return.multiple
#' @description Allow for simpler syntax in R. Handles functions with multiple outputs better without messy intermediate list-objects.
#' @export return.multiple
#'
#' @usage \code{return.multiple(map, f)(<INPUTARGS>)}
#' @param f Function which returns a list-objet as output.
#' @param <INPUTARGS> Input arguments for f.
#' @param map A list mapping external names to local-names of return-entities in output of f.
#'
#' @examples \dontrun{
#'	infos <- function(firstname='',surname='',age=0) {
#'		underage <- (age < 18);
#'		fullname <- gsub('^\\s+|\\s+$', '', print0(firstname,' ',surname));
#'
#'		return(list(
#'			voter = !underage,
#'			fullname = fullname,
#'			validname = !(fullname == '')
#'		));
#'	};
#'	return.multiple(list(valid='validname', isvoter='voter'), f)(firstname='Richard', surname='Feynman', age=100);
#'
#'	# equivalent to:
#'	obj <- f(firstname='Richard', surname='Feynman', age=100);
#'	valid <- obj$validname;
#'	isvoter <- obj$voter;
#' }
#' @examples \dontrun{
#'	f <- function(<INPUTARGS>) {
#'		·
#'		·
#'		·
#'		return(list(
#'			localoutput1 = <RETURN-OUTPUT1>,
#'			localoutput2 = <RETURN-OUTPUT2>,
#'			·
#'			·
#'		));
#'	};
#'  ·
#'  ·
#'  ·
#'	return.multiple(list(var1=localoutput1, var2=localoutput2, ...), f)(<INPUTARGS>);
#'
#'	# äquivalent zu:
#'	obj <- f(<INPUTARGS>);
#'	var1 <- obj$localoutput1;
#'	var2 <- obj$localoutput1;
#'  ·
#'  ·
#'  ·
#' }
#'
#' @keywords syntax return multiple arguments




return.multiple <- function(map, f) {
	FUN <- f;
	return(function(...) {
		env <- parent.frame();
		args <- as.list(sys.call())[-1L];
		len <- length(args);
		if(len > 1L) {
			last <- args[[len]];
			if(missing(last)) args <- args[-len];
		}
		obj <- do.call(FUN, args, envir=env);
		if(!is.list(map) && !is.vector(map)) map <- list();
		for(key in names(map)) {
			val <- NULL;
			if(key %in% names(map)) val <- obj[[map[[key]]]];
			assign(key, val, env);
		}
		invisible(NULL);
	});
};
