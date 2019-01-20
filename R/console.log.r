#' rbettersyntax | console.log
#'
#' Allow for simpler syntax in R. Output messages to console. Use \code{options('rbettersyntax::silent'=TRUE)} to disable console output.
#'
#' \code{console.log(tabs=tabs, tab.char=tab.char, silent.off=silent.off, m1, m2, ..)}
#'
#' @param tabs a non-negative integer. Default \code{0}. Number of tab sets to be produced on each new line.
#' @param tab.char character. Default \code{'  '}. This will be used as the indentation string.
#' @param silent.off boolean. Default \code{FALSE}. If true, then no output will be shown under the option \code{'rbettersyntax::silent'=TRUE}.
#' @param m1 character string / vector of character strings. The strings will be concatenated with no spaces, prepended by tab stops and followed by a \code{'\n'} character.
#' @param m2 similar. User can set 0 or more 'messages' to be printed in the console.
#'
#' @export console.log
#'
#' @examples console.log(tabs=0, 'Test');
#' @examples console.log(tabs=1, silent.off=TRUE, 'Starting Method', c('Scanning data set ',k,' for solutions:'));
#'
#' @keywords syntax console.log console log




console.log <- function(...) {
	INPUTARGS <- list(...);
	silent.off <- INPUTARGS[['silent.off']];
	if(!is.logical(silent.off)) silent.off <- TRUE;
	rsilent <-  FALSE;
	if(silent.off) {
		rsilent <- getOption('rbettersyntax::silent');
		if(!is.logical(rsilent)) rsilent <- FALSE;
	}
	if(!rsilent) {
		tabs <- INPUTARGS[['tabs']]; if(!is.numeric(tabs)) tabs <- 0;
		tab.char <- INPUTARGS[['tab.char']]; if(!is.character(tab.char)) tab.char <- '  ';
		lines <- INPUTARGS[which(!(names(INPUTARGS) %in% c('tabs','tab.char','silent.off')))];
		indent <- rep(tab.char, tabs);
		for(s in lines) cat(c(indent,s,'\n'),sep='');
	}
};