library(raster)
library(rgdal)
library(raster)

setwd('C:/Users/Thadeu Sobral/Documents/Modelos/Modelagem_grupos_venatrix/modelagemfiltrada')

presencias <- read.table("Araneus_venatrix_cladeI_pontos_filtrados.txt")

myshp <- readOGR("c2.shp", layer= "c2")
e<- extent(myshp)
e


plot(myshp)

sp <-SpatialPolygons(myshp)
atual <- raster ('ensemble_A.venatrix_cladeII_0k.asc')
plot(atual)

atual <- atual/400
plot(myshp,atual)

extrac <- extract(atual,myshp)
write.table(extrac, 'cladeII_suitability.txt')


###usando LPT

ci0k <- raster('ensemble_A.venatrix_cladeII_0k.asc')
ci6k <- raster('ensemble_A.venatrix_cladeII_6k.asc')
ci21k <- raster('ensemble_A.venatrix_cladeII_21k.asc')

ci0klpt <- ci0k>=232
plot(ci0klpt)
ci6klpt <- ci6k>=232
plot(ci6klpt)
ci21klpt <- ci21k>=232
plot(ci21klpt)

writeRaster(ci0klpt, 'cladeii_0k_lpt.asc')
writeRaster(ci6klpt, 'cladeii_6k_lpt.asc')
writeRaster(ci21klpt, 'cladeii_21k_lpt.asc')
