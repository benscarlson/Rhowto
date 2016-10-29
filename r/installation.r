#if r says something like 'not available for xyz version'
#http://stackoverflow.com/questions/25721884/how-should-i-deal-with-package-xxx-is-not-available-for-r-version-x-y-z-wa
# see second answer
install.packages('hypervolume',dependencies=TRUE,repos='http://cran.rstudio.com/') #seems to install all dependencies, no matter what
install.packages('hypervolume',repos='http://cran.rstudio.com/') #this is probably faster

.libPaths() #see library paths. by default the first one is picked as the install location
#path seem to be built from here file below. see: http://stackoverflow.com/questions/6218358/how-do-i-set-r-libs-site-on-ubuntu-so-that-libpaths-is-set-properly-for-all-u
/etc/R/Renviron
#to install into a 'local' directory, these is a line like:
R_LIBS_USER=${R_LIBS_USER-'~/R/x86_64-pc-linux-gnu-library/3.2'}
#if the folder ~/R/x86_64-pc-linux-gnu-library/3.2 exists, then when you start R it will be the default place to install libraries