# Package: rbettersyntax
Verschafft Methoden für einfachere Syntax für die Sprache R.

## Beispiele: console.log

```r
console.log(0, 'Starting code.');
console.log(1, 'Starting Method', c('Scanning data set ',k,' for solutions:'));
```

## Beispiele: ok.comma

Diese Methode stammt ursprünglich von [**flodel**](https://gist.github.com/flodel/5283216) und wurde von mir leicht modifiziert, um endlose Schleifen zu vermeiden.

```r
c <- rbettersyntax::ok.comma(base::c);
list <- rbettersyntax::ok.comma(base::list);

f <- function(...) {
	...
};
f <- rbettersyntax::ok.comma(f);
```

Unter diesen Definitionen kann man bspw.

```r
names <- c(
	'Arthur',
	'Lise',
	'Heike',
	'Jonas',
	'Christian',
);
```

schreiben, wie in den meisten Programmiersprachen.
Damit muss man sich nicht mehr um das sogenannte „trailing comma“ Gedanken machen.

## Beispiele: read.args

```r
f <- function(df, ...) {
	args <- list(...);
	col <- rbettersyntax::read.args(args, 'column', is.character, c());
	rowindex <- rbettersyntax::read.args(args, 'row', is.integer, 1);
	## rest of code
	## ...
};
```

## Beispiele: sys.pause

```r
## code...
sys.pause(); # warte auf Usereingabe!
sys.pause(0.5); # warte 0.5 Sekunden!
sys.pause(10); # warte 10 Sekunden!
## code...
```