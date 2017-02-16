library(raster)
library(rgdal)
setwd('C:/Users/Thadeu Sobral/Documents/Modelos/Modelos_quelonios')

library(raster)
# Reading the shapefile
myshp <- readOGR("ma_ribeiro_gcs_wgs84.shp", layer= "ma_ribeiro_gcs_wgs84")
extent(myshp)
plot(myshp)
# Getting the spatial extent of the shapefile
e <- extent(myshp)
# Reading the raster you want to crop
myraster <- raster("ensemble_carbonaria_0k_0_1.asc")
myraster1 <- raster ("ensemble_denticulata_0k_0_1.asc")
#myraster2 <- raster ("bio_17_2050_miroc.asc")
#myraster3 <- raster ("bio_17_2070_ccsm4.asc")  
#myraster4 <- raster ("bio_17_2070_miroc.asc")    
  
extent(myraster)
plot(myraster)
# Cropping the raster to the shapefile spatial extent
myraster.crop <- crop(myraster, e, snap="out")
myraster.crop1 <- crop(myraster1, e, snap="out")
#myraster.crop2 <- crop(myraster2, e, snap="out")
#myraster.crop3 <- crop(myraster3, e, snap="out")
#myraster.crop4 <- crop(myraster4, e, snap="out")
plot(myraster.crop)
# Dummy raster with a spatial extension equal to the cropped raster,
# but full of NA values
crop <- setValues(myraster.crop, NA)
crop1 <- setValues(myraster.crop1, NA)
crop2 <- setValues(myraster.crop2, NA)
crop3 <- setValues(myraster.crop3, NA)
crop4<- setValues(myraster.crop4, NA)


#  Rasterize the catchment boundaries, with NA outside the catchmentboundaries
myshp.r <- rasterize(myshp, crop)
myshp.r1 <- rasterize(myshp, crop1)
myshp.r2 <- rasterize(myshp, crop2)
myshp.r3 <- rasterize(myshp, crop3)
myshp.r4 <- rasterize(myshp, crop4)
plot(myshp.r)
# Putting NA values in all the raster cells outside the shapefile boundaries
myraster.masked <- mask(x=myraster.crop, mask=myshp.r)
myraster.masked1 <- mask(x=myraster.crop1, mask=myshp.r1)
myraster.masked2 <- mask(x=myraster.crop2, mask=myshp.r2)
myraster.masked3 <- mask(x=myraster.crop3, mask=myshp.r3)
myraster.masked4 <- mask(x=myraster.crop4, mask=myshp.r4)

plot(myraster.masked)
plot(myraster.masked1)
plot(myraster.masked2)
plot(myraster.masked3)
plot(myraster.masked4)


writeRaster (myraster.masked, 'ensemble_carbonaria_0k_0_1_MA.asc', format='ascii')
writeRaster (myraster.masked1, 'ensemble_denticulata_0k_0_1_MA.asc', format='ascii')
writeRaster (myraster.masked2, 'bio_17_2050_miroc_alt.asc', format='ascii')
writeRaster (myraster.masked3, 'bio_17_2070_ccsm_alt.asc.asc', format='ascii')
writeRaster (myraster.masked4, 'bio_17_2070_miroc_alt.asc', format='ascii')