#' @title trailing.comma
#' @description This method enables trailing commata. Modification of flodel's method.
#' @export trailing.comma
#'
#' @usage \code{f <- trailing.comma(f)}
#' @param f Function to be modified to allow trailing commas
#'
#' @examples \dontrun{
#'	c <- trailing.comma(base::c);
#'	list <- trailing.comma(base::list);
#'	myfun <- trailing.comma(myfun);
#' }
#'
#' @keywords syntax trailing comma

trailing.comma <- function(f) {
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




#' @title read.args
#' @description Read input arguments from ... with expected type and default values.
#' @export read.args
#'
#' @usage \code{val <- read.args(args, key, type, defaultval)}
#' @param args Liste of arguments extracted from ... . Usage: inside a function first set \code{args <- list(...);}.
#' @param key character string. This is the name of the parameter you wish to extract.
#' @param type function or string. If a boolean-valued function like \code{is.character}, \code{is.logical}, etc., this will be used to check the type of the argument. If a string, then a standard type-checking function will be called.
#' @param defaultval Default value. Will be set, if argument is missing or is not of the correct type.
#'
#' @examples \dontrun{
#'	f <- function(...) {
#'		args <- list(...);
#'		val <- read.args(args, key='name', type=is.character, default='N/A');
#'		## Rest of the function definition
#'	};
#' }
#'
#' @keywords syntax read arguments parameters default value

read.args <- function(vars, key='', type=NULL, default=NULL) {
	if(!is.list(vars)) {
		if(is.vector(vars)) {
			vars <- as.list(vars);
		} else {
			vars <- list();
		}
	}

	if(!(key %in% names(vars))) return(defaultval);
	val <- vars[[key]];
	if(is.character(type)) {
		if(type %in% c('character','chr','string')) type <- is.character;
		if(type %in% c('numeric','int','integer','double','float')) type <- is.numeric;
		if(type %in% c('logical','boolean','bool')) type <- is.numeric;
		if(type %in% c('list')) type <- is.list;
	}
	if(is.function(type)) {
		if(!type(val)) return(defaultval);
		return(val);
	}
	return(defaultval);
};




#' @title return.multiple
#' @description Handles functions with multiple outputs better without messy intermediate list-objects.
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
#'	# equivalent to:
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
