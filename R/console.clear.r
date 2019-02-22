#' @title rbettersyntax | console.clear
#' @description Allow for simpler syntax in R. Clear console.
#' @export console.clear
#'
#' @usage \code{console.clear()}
#'
#' @examples \dontrun{
#'	console.clear();
#' }
#'
#' @keywords syntax console.clear



console.clear <- function() {
	if(.Platform$OS.type == 'unix') { ## MAC OSX / Linux
		base::system('clear');
	} else { ## Windows
		base::shell('cls');
	}
};