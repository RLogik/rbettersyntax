#' rbettersyntax | console.clear
#'
#' Allow for simpler syntax in R. Clear console.
#'
#' \code{console.clear()}
#'
#' @export console.clear
#'
#' @examples console.clear();
#'
#' @keywords syntax console.clear



console.clear <- function() {
	if(.Platform$OS.type == 'unix') { ## MAC OSX / Linux
		base::system('clear');
	} else { ## Windows
		base::shell('cls');
	}
};