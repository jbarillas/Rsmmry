[![Travis-CI Build Status](https://travis-ci.org/nevrome/Rsmmry.svg?branch=master)](https://travis-ci.org/nevrome/Rsmmry) [![Coverage Status](https://img.shields.io/codecov/c/github/nevrome/Rsmmry/master.svg)](https://codecov.io/github/nevrome/Rsmmry?branch=master)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/Rsmmry)](http://cran.r-project.org/package=Rsmmry)
[![license](https://img.shields.io/badge/license-GPL%202-B50B82.svg)](https://www.r-project.org/Licenses/GPL-2)

Rsmmry
--------

[SMMRY](http://smmry.com/) offers a service to automatically summarize a webpage or simply text. rsmmry allows to access this service from within R. 

Installation
------------

Rsmmry is currently not on [CRAN](http://cran.r-project.org/), but you can use [devtools](http://cran.r-project.org/web/packages/devtools/index.html) to install the development version. To do so:

    if(!require('devtools')) install.packages('devtools')
    library(devtools)
    install_github('nevrome/Rsmmry')

Usage
-----

To use rsmmry you first of all need a SMMRY API Key (http://smmry.com/api) that has to be [set as a environment variable SMMRY_PAT](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html#appendix-storing-api-authentication-keystokens).  

With this done, you can call the main function smmry_api() to summarize text or a website. 

```{r}
lorem_ipsum <- "Lorem ipsum dolor sit amet, consetetur 
                sadipscing elitr, sed diam nonumy eirmod 
                tempor invidunt ut labore et dolore magna 
                aliquyam erat, sed diam voluptua. At vero 
                eos et accusam et justo duo dolores et ea 
                rebum. Stet clita kasd gubergren, no sea 
                takimata sanctus est Lorem ipsum dolor sit 
                amet. Lorem ipsum dolor sit amet, consetetur 
                sadipscing elitr, sed diam nonumy eirmod 
                tempor invidunt ut labore et dolore magna 
                aliquyam erat, sed diam voluptua. At vero 
                eos et accusam et justo duo dolores et ea 
                rebum. Stet clita kasd gubergren, no sea 
                takimata sanctus est Lorem ipsum dolor sit 
                amet."

testurl <- "https://en.wikipedia.org/wiki/Aregund"

smmry_api(x = lorem_ipsum)
smmry_api(x = testurl)
```

The package provides a RStudio Addin named rsmmry that binds to smmry_api() to summarize text (or homepages) in the clipboard. smmry_api() can therefore be called with a keyboard shortcut in RStudio.

Licence
-------

Rsmmry is released under the [GNU General Public Licence, version 2](http://www.r-project.org/Licenses/GPL-2). Comments and feedback are welcome, as are code contributions.

I'm not affiliated with the the team behind SMMRY - I just wanted to provide a convinient way to use their API. 