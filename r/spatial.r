#http://www.maths.lancs.ac.uk/~rowlings/Teaching/UseR2012/cheatsheet.html

#-----------------#
#---- rasters ----#
#-----------------#

env <- raster('misc/tinamus_env.tif') #read raster
writeRaster(env,'misc/tinamus_env.tif','GTiff') #write a raster to tif

nlayers(mystack) #number of RasterLayers in the RasterStack
names(mystack) #the names of the RasterLayers in the RasterStack
extent(mystack) #extent of the RasterLayers in the RasterStack
mystack[[1]] #extract the first RasterLayer from the RasterStack
names(layer) <- 'layername' #set the name of RasterLayer to 'layername'
ncell(layer) #number of cells
calc(layer, function(x) { f(x) }) #apply function f to layer
cellStats(layer,sum) #returns the sum of all cells in layer. can also use mean, min, etc.
metadata(layer) <- metadata #adds metadata to layer
rdist_r@data@min;rdist_r@data@max #see min and max values for a rasterLayer

env_tif <- raster('misc/tinamus_env.tif') #load the raster from tif
raster::extract(env_rdata,pts,df=T,ID=F) #extract raster values given a set of points (here, a SpatialPoints object)
bbox(obj) #get the bounding box of spatial object obj

#---------------------#     
#---- Vector Data ----#
#---------------------#

#libraries that can read shapefiles. 'raster', 'shapefile', 'maptools' (?)

getGDALVersionInfo()

# reading shapefiles
shapefile('myshapefile.shp') #part of raster package. load shapefile into a SpatialPolygonsDataFrame
maptools::readShapePoints('myshpfile.shp') #maptools. also see readShapeLines
maptools::readShapeSpatial('myshpfile.shp')
readOGR(dsn="shapefiledir", layer="shpefilename")

#writing shapefiles
#make sure to create polys using a dataframe, not a tibble, otherwise writeOGR will give cryptic errors
writeOGR(obj=polys, dsn="shapefiledir", layer="shapefilename", driver="ESRI Shapefile") #polys is SpatialPolygonsDataFrame (or Points)

df <- as.data.frame(spdf) #convert SpatialPointsDataFrame spdf to a dataframe

#---- Create Spatial objects ----

# Create a SpatialPoints object from a matrix. Not sure how to set the column names
coords<-matrix(c(-45.1692940000,-23.4697250000),nrow=1)
pts<-SpatialPoints(m, proj4string=CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))

# Create a SpatialPointsDataFrame object from data.frame dat1 (with cols 'lon' and 'lat')
spdf <- SpatialPointsDataFrame(
  coords=as.data.frame(dat1[,c('lon','lat')]), data=dat1,
  proj4string=CRS("+proj=longlat +datum=WGS84"))

# Promote a data frame to an SP or SPDF object.
coordinates(df)=~Longitude+Latitude #turn df into a SpatialPointsDataFrame. set Longitude and Latitude as coordinates
proj4string(df) <- CRS('+proj=longlat +datum=WGS84') #set the crs of the spatialpointsdataframe
proj4string(df) <- CRS('+proj=longlat') #set the crs of the spatialpointsdataframe

#---- Spatial*DataFrame ----
na.omit(spdf) #remove rows with NA (not sure if this works)
which(is.na(spdf['mycol']@data)) #shows which rows contain NA

#---- SpatialPointsDataFrame ----
spdf[,'mycol'] #this will return an spdf with just the column 'mycol'
spdf$mycol #returns a vector
spdf@data$mycol #also returns a vectors (seems same as spdf$)
spdf[['mycol']]] #also returns a vector
crs(spdf) #see the projection
mydata@proj4string #see the projection (same as crs())
coordinates(spdf) #see the coordinates

zerodist(df) #find point pairs with equal spatial coordinates

#https://gis.stackexchange.com/questions/63577/joining-polygons-in-r
spainportu <- subset(world,world$NAME=='Spain' | world$NAME=='Portugal')
spainportu$ID <- 1
dissolved <- unionSpatialPolygons(spainportu,spainportu$ID) #in maptools library

ptsClip <- pts[poly,] #spatial subset pts by poly (return all points that are within poly
     
#raster    


### plotting polygons ###
splancs::polymap(mymatrix) #plot a polygon for a [,2] matrix
     
### projections ###
CRS("+proj=longlat") #WGS84
CRS("+proj=longlat +ellps=WGS84") #WGS84
CRS("+proj=longlat +datum=WGS84") #WGS84
CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") #WGS84
CRS('+proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m +no_defs') #albers
CRS('+proj=utm +zone=33 +ellps=WGS84 +units=m +no_defs') #UTM zone 33N
CRS('+proj=utm +zone=33 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs') #UTM zone 33S (note +south)
