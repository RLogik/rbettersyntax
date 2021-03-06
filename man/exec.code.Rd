% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.r
\name{exec.code}
\alias{exec.code}
\title{exec.code}
\usage{
\code{val <- exec.code(<expr1>, <expr2>, ..., multi.lines=<BOOL>)}
}
\arguments{
\item{multi.lines}{boolean. Default \code{FALSE}. If \code{TRUE}, the expressions are interpretted as separate lines of code. If \code{FALSE}, the expressions will be concatenated with no spaces and interpretted as a single expression to be executed.}

\item{<expr1>}{String. 1 or more. R code as string expressions.}
}
\value{
val Optional. Returns the value of the last line executed.
}
\description{
Execute code from string.
}
\examples{
\dontrun{
	key <- 'fleisch';
	basket <- list('obst'='Birne', 'fleisch'='Hähnchen', 'vegetable'='Spinat');
x <- exec.code('basket$',key); # 'Hähnchen'
exec.code("key <- 'fleisch';", "x<-basket[[key]];", "show(x);", multi.lines=TRUE);
 }

}
\keyword{arguments}
\keyword{default}
\keyword{parameters}
\keyword{read}
\keyword{syntax}
\keyword{value}
