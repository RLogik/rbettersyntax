#' @title exec.code
#' @description Execute code from string.
#' @export exec.code
#'
#' @usage \code{val <- exec.code(<expr1>, <expr2>, ..., multi.lines=<BOOL>)}
#' @param <expr1> String. 1 or more. R code as string expressions.
#' @param multi.lines boolean. Default \code{FALSE}. If \code{TRUE}, the expressions are interpretted as separate lines of code. If \code{FALSE}, the expressions will be concatenated with no spaces and interpretted as a single expression to be executed.
#' @return val Optional. Returns the value of the last line executed.
#'
#' @examples \dontrun{
#' 	key <- 'fleisch';
#' 	basket <- list('obst'='Birne', 'fleisch'='Hähnchen', 'vegetable'='Spinat');
#'	x <- exec.code('basket$',key); # 'Hähnchen'
#'	exec.code("key <- 'fleisch';", "x<-basket[[key]];", "show(x);", multi.lines=TRUE);
#' }
#'
#' @keywords syntax read arguments parameters default value

exec.code <- function(..., multi.lines=FALSE) {
	env <- parent.frame();

	exprs <- list(...);
	if(!multi.lines) exprs <- list(base::paste(exprs, collapse=''));

	val <- NULL;
	for(e in exprs) val <- eval(parse(text=e), envir=env);
	return(val);
};