
#update namespace file (required to export functions)
devtools::document()

#note, if you get something like "... *.rdb is corrupt" restart r session and try again
.rs.restartR()

#get the full path of a specified file in a package
system.file("external/test.grd", package="raster")
