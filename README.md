# Package: rbettersyntax
Verschafft Methoden für einfachere Syntax für die Sprache R.

## Beispiele: standard.setup

Manchmal will man Konsole-Interaktion mit einem einzigen Befehl im ganzen Code ausschalten.
Dies wird mittels der `rbettersyntax::silent`-Option sowie
der Methode `standard.setup` ermöglicht.

```r
options('rbettersyntax::silent'=TRUE);
rbettersyntax::standard.setup(); # man braucht diese Zeile nur ein Mal im Code, am besten nachdem alle Packages geladen sind.

menu(c('Ja','Nein'), title='Willst du fortsetzen?'); ## macht nichts, gibt den Wert 0 zurück.
rbettersyntax::sys.pause(); ## macht nichts
rbettersyntax::sys.pause(10); ## funktioniert (weil keine User-Interaktion erforderlich)
rbettersyntax::console.log(silent.off=FALSE,'Schritt I wird ausgeführt.'); ## funktioniert
rbettersyntax::console.log('Schritt I wird ausgeführt.'); ## macht nichts
rbettersyntax::console.log(silent.off=TRUE,'Schritt I wird ausgeführt.'); ## macht nichts
```

```r
options('rbettersyntax::silent'=FALSE); # oder die Option einfach nicht setzen.

menu(c('Ja','Nein'), title='Willst du fortsetzen?'); ## funktioniert
rbettersyntax::sys.pause(10); ## funktioniert
rbettersyntax::console.log(silent.off=FALSE,'Schritt I wird ausgeführt.'); ## funktioniert
rbettersyntax::console.log('Schritt I wird ausgeführt.'); ## funktioniert
rbettersyntax::console.log(silent.off=TRUE,'Schritt I wird ausgeführt.'); ## funktioniert
```

## Beispiele: get.pkgs

```r
rbettersyntax::get.pkgs(53,
	'tidyverse',
	list('clusterby', mode='github', lib='RLogik', force=TRUE),
	list('cowplot', dep=TRUE),
	list('GenomicRanges', mode='biocmanager', version='3.5'), # <- ja, ein trailing comma ist erlaubt!
);
```

## Beispiele: console.log

```r
console.log(tabs=0, tab.char='\t', 'Starting code.');
console.log(tabs=0, silent.off=TRUE, 'Starting code.');
console.log(tab.char='  ', silent.off=FALSE, 'Starting code.');
## zwei Zeilen, die jeweils durch 3 Tabs eingerückt sind:
console.log(tabs=3, 'Starting Method', c('Scanning data set ',k,' for solutions:'));
```

## Beispiele: ok.comma

Diese Methode stammt ursprünglich von [**flodel**](https://gist.github.com/flodel/5283216) und wurde von mir leicht modifiziert, um endlose Schleifen zu vermeiden.

```r
c <- rbettersyntax::ok.comma(base::c);
list <- rbettersyntax::ok.comma(base::list);
```

oder einfach:

```r
rbettersyntax::standard.setup();
```

Unter diesen Definitionen kann man bspw.

```r
names <- c(
	'Arthur',
	'Lisette',
	'Heike',
	'Jonas',
	'Christian', # <- jetzt brauchst du dieses Komma nicht nicht mehr zu löschen!
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
	col <- rbettersyntax::read.args(args, key='column', type=is.character, default=c());
	rowindex <- rbettersyntax::read.args(args, key='row', type=is.integer, default=1);
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