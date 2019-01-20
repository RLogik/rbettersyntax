#' rbettersyntax | console.log
#'
#' Allow for simpler syntax in R. Output messages to console. Use \code{options('rbettersyntax::silent'=TRUE)} to disable console output.
#'
#' \code{console.log(tabs, m1, m2, ..)}
#'
#' @param tabs a non-negative integer. Number of tab sets to be produced on each new line.
#' @param m1 character string / vector of character strings. The strings will be concatenated with no spaces, prepended by tab stops and followed by a \code{'\n'} character.
#' @param m2 similar. User can set 0 or more 'messages' to be printed in the console.
#'
#' @export console.log
#'
#' @examples console.log(0, 'Test');
#' @examples console.log(1, 'Starting Method', c('Scanning data set ',k,' for solutions:'));
#'
#' @keywords syntax console.log console log




console.log <- function(tabs=0, ...) {
	rmd_on <- getOption('rbettersyntax::silent');
	if(!is.logical(rmd_on)) rmd_on <- FALSE;
	cat(c('\n rbettersyntax::silent option auf ',rmd_on,' eingestellt.'), sep='');
	if(!rmd_on) {
		lines <- list(...);
		tabs <- rep('  ',tabs);
		for(s in lines) {
			if(!(length(s) == 1)) s <- paste0(s);
			cat(tabs,s,'\n',sep='');
		}
	}
};