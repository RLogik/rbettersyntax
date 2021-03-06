[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/rbettersyntax)](https://cran.r-project.org/package=rbettersyntax)
<!-- ![](http://cranlogs.r-pkg.org/badges/rbettersyntax?color=yellow)
![](http://cranlogs.r-pkg.org/badges/grand-total/rbettersyntax?color=yellowgreen) -->


# rbettersyntax

Verschafft Methoden für einfachere Syntax für die Sprache R.

## Beispiele: standard.setup

Manchmal will man Konsole-Interaktion mit einem einzigen Befehl im ganzen Code ausschalten.
Dies wird mittels der `utilsRL::silent`-Option sowie
der Methode `standard.setup` ermöglicht.

```r
options('utilsRL::silent'=TRUE);
standard.setup(); # man braucht diese Zeile nur ein Mal im Code, am besten nachdem alle Packages geladen sind.

menu(c('Ja','Nein'), title='Willst du fortsetzen?'); ## macht nichts, gibt den Wert 0 zurück.
sys.pause(); ## macht nichts
sys.pause(10); ## funktioniert (weil keine User-Interaktion erforderlich)
console.log(silent.off=FALSE,'Schritt I wird ausgeführt.'); ## funktioniert
console.log('Schritt I wird ausgeführt.'); ## macht nichts
console.log(silent.off=TRUE,'Schritt I wird ausgeführt.'); ## macht nichts
```

## Beispiele: load.packages

```r
load.packages(mirror=53, package='tidyverse', force=TRUE);
load.packages(mirror=53, package=c('tidyverse', 'Matrix'), stoponerror=TRUE, force=TRUE);
# this will stop:
load.packages(mirror=53, package=c('tidyverse', 'Motrix', 'cowplot'), stoponerror=TRUE, force=TRUE);

load.packages(package='GenomicRanges', mode='biocmanager', version='3.5', quietly=TRUE);

load.packages(mode='github', package=c('RLogik/clusterby', 'RLogik/rbettersyntax'), dependencies=TRUE);
load.packages(mode='github', url='https://github.com/RLogik/clusterby/archive/master.zip', file.type='zip', force=TRUE, dependencies=FALSE);
## require('clusterby') will be tried first, then potentially an install, then a require.
load.packages(mode='github', package='clusterby', url='https://github.com/RLogik/clusterby/archive/master.zip', file.type='zip', dependencies=TRUE);
```

## Beispiele: install.from.url

Das Package, [`installr`](https://github.com/talgalili/installr), liefert Methode für Package-Installation von URLs inkl. unzip. Diese Algorithmen sind einem großen Problem ausgesetzt: die Namen der heruntergeladenen Dateien leiten sich direkt aus der URL ab, und, falls eine URL Parameter enthält, führt dies wiederum dazu, dass die lokal gespeicherten Dateien mit problematischen Namen versehen werden. Dies bereitet dem Installationsprozess Probleme. Die entsprechenden Methode in `rbettersyntax` vermeiden dieses Problem. Jetzt kann man jegliche URLs verwenden!

```r
install.from.url(url='http://mydomain.co.uk/repository/mynonzippedpackage');
install.from.url(url='http://mydomain.co.uk/repository/mypackage.zip'); ## <- erkennt an der Datei, dass es sich um eine zip-Datei handelt
install.from.url(url='http://mydomain.co.uk/repository/mypackage.zip', file.type='zip'); ## ansonsten kann man explizit den Dateityp eingeben.
install.from.url(url='http://mydomain.co.uk/repository/get?mode=gz&name=test', file.type='gz'); ## kein Problem mit URLs mit Parametern!

## Falls man selber installieren möchte, dann etwa folgende Befehle ausführen:
path1 <- install.from.url(url='http://mydomain.co.uk/repository/mynonzippedpackage', install=FALSE);
path2 <- install.from.url(url='http://mydomain.co.uk/repository/my2ndonzippedpackage', install=FALSE);
install.packages(pkgs=c(path1,path2), repos=NULL, type='source');
## ggf. die Pfade nachher löschen:
base::unlink(path1, recursive=TRUE);
base::unlink(path2, recursive=TRUE);

## Folgende Befehle sind äquivalent und versucht require(···), dann ggf. Installation, dann require(···):
install.from.url(package='mypackage', url='http://mydomain.co.uk/repository/mypackage.zip', require.pkg=TRUE);
install.from.url(package='mypackage', url='http://mydomain.co.uk/repository/mypackage.zip', require.pkg=TRUE, force=FALSE);

## Folgende Befehle sind äquivalent und erzwingen Installation bevor require(···):
install.from.url(url='http://mydomain.co.uk/repository/mypackage.zip', require.pkg=TRUE);
install.from.url(url='http://mydomain.co.uk/repository/mypackage.zip', require.pkg=TRUE, force=TRUE);
install.from.url(package='mypackage', url='http://mydomain.co.uk/repository/mypackage.zip', require.pkg=TRUE, force=TRUE);
```

## Beispiele: console.clear

```r
console.clear(); ## löscht die Console
```

## Beispiele: console.log

```r
console.log(tabs=0, tab.char='\t', 'Starting code.');
console.log(tabs=0, silent.off=TRUE, 'Starting code.');
console.log(tab.char='  ', silent.off=FALSE, 'Starting code.');
## zwei Zeilen, die jeweils durch 3 Tabs eingerückt sind:
console.log(tabs=3, 'Starting Method', c('Scanning data set ',k,' for solutions:'));
```

## Beispiele: trailing.comma

Diese Methode stammt ursprünglich von [**flodel**](https://gist.github.com/flodel/5283216) und wurde von mir leicht modifiziert, um endlose Schleifen zu vermeiden.

```r
c <- trailing.comma(base::c);
list <- trailing.comma(base::list);
```

oder einfach:

```r
standard.setup();
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
Man kann auch `trailing.comma` bei beliebigen Funktionen einsetzen.

```r
f <- function(x, ...) {
	## Funktioninhalt
};
f <- trailing.comma(f);
```

## Beispiele: read.args

```r
f <- function(df, ...) {
	args <- list(...);
	col <- read.args(args, key='column', type=is.character, default=c());
	rowindex <- read.args(args, key='row', type=is.integer, default=1);
	## rest of code
	## ...
};
```

## Beispiele: timer

```r
## code...
uhr <- timer();
uhr$pause(); # warte auf Usereingabe!

uhr$pause(0.4); # warte 0,4 Sekunden!
uhr$stop();
uhr$pause(10); # warte 10 Sekunden!

uhr$time(); # Zeit seit letztem Reset (=10,4 s)
uhr$duration(); # Zeit seit letztem Stop (=10 s)

uhr$stop();
uhr$pause(3); # warte 10 Sekunden!

uhr$time(); # Zeit seit letztem Reset (=13,4 s)
uhr$duration(); # Zeit seit letztem Stop (=3 s)

uhr$reset();
uhr$pause(5.8); # warte 10 Sekunden!

uhr$time(); # Zeit seit letztem Reset (=5,8 s)
uhr$duration(); # Zeit seit letztem Stop (=5,8 s)
## code...
```