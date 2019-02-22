#' @export read.args
#' @title rbettersyntax | read.args
#' @description Allow for simpler syntax in R. Read input arguments from ... with expected type and default values.
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
#'		val <- rbettersyntax::read.args(args, key='name', type=is.character, default='N/A');
#'		## Rest of the function definition
#'	};
#' }
#'
#' @keywords syntax read arguments parameters default value




read.args <- function(vars, ...) {
	if(!is.list(vars)) {
		if(is.vector(vars)) {
			vars <- as.list(vars);
		} else {
			vars <- list();
		}
	}
	args <- list(...);
	type <- args$type;
	defaultval <- args$default;
	key <- args$key;
	if(!is.character(key)) key <- '';

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