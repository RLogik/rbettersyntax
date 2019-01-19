# Package: rbettersyntax
Verschafft Methoden für einfachere Syntax für die Sprache R.

## Beispiele: get.pkgs

```r
rbettersyntax::get.pkgs(53,
	'tidyverse',
	list('clusterby', mode='github', lib='RLogik', force=TRUE),
	list('cowplot', dep=TRUE), # <- ja, ein trailing comma ist erlaubt!
	list('GenomicRanges', mode='biocmanager', version='3.5')
);
```

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
```

oder einfach:

```r
rbettersyntax::ok.comma.standard();
```

Unter diesen Definitionen kann man bspw.

```r
names <- c(
	'Arthur',
	'Lisette',
	'Heike',
	'Jonas',
	'Christian', # <- jetzt brauchst du diese nicht nicht mehr zu löschen!
	# 'Jannik',
);
```

schreiben, wie in den meisten Programmiersprachen.
Damit muss man sich nicht mehr um das sogenannte „trailing comma“ Gedanken machen.
Man kann auch `ok.comma` bei beliebigen Funktionen einsetzen.

```r
f <- function(x, ...) {
	## Funktioninhalt
};
f <- rbettersyntax::ok.comma(f);
```

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