rm(list=ls())

#leia os pacotes abaixo:

library(sp)
library(raster)



### manipulando arquivos ambientais - GIS

#lendo arquivos txt
setwd("/Users/matheusribeiro/Dropbox/aaa_Matheus_Ribeiro-2014-11-06/UFG - campus Jatai/Disciplinas/ENMs/dados/ambientais")

ccsm.0k <- read.table("bio_var_CCSM_0k_global.txt", h=T)
ccsm.0k[1:5,]
ccsm.0k <- ccsm.0k[,-1]


# transformando em arquivo espacializado - gride
gridded(ccsm.0k) <- ~long+lat
ccsm.0k[1:5,]

#raster
ccsm.0k.r <- raster(ccsm.0k)
ccsm.0k.r

ccsm.0k.r <- stack(ccsm.0k)
ccsm.0k.r
plot(ccsm.0k.r$bio.1)

# cortando raster - América do Sul (xmin, xmax, ymin, ymax)
e <- extent(c(-90, -30, -60, 15))
ccsm.0k.ASr <- crop(ccsm.0k.r, e)
plot(ccsm.0k.ASr$bio.1)
ncell(ccsm.0k.ASr)

#extraindo valores do raster
ccsm.0k.val <- values(ccsm.0k.ASr)
ccsm.0k.val[1:5,]
nrow(ccsm.0k.val)

coord.AS <- xyFromCell(ccsm.0k.ASr, 1:ncell(ccsm.0k.ASr))
coord.AS[1:5,]
nrow(coord.AS)

ccsm.0k.ASm <- cbind(coord.AS, ccsm.0k.val)
ccsm.0k.ASm[1:5,]
nrow(ccsm.0k.ASm)
ccsm.0k.ASm <- na.omit(ccsm.0k.ASm)
nrow(ccsm.0k.ASm)


### ANALISE FATORIAL - SELECAO DE VARIAVEIS

library(psych)

fa.parallel(ccsm.0k.ASm[,-c(1:2)], fa='fa') #scree plot
ccsm.0k.fa <- fa(ccsm.0k.ASm[,-c(1:2)], nfactors= 5, rotate= 'varimax')
ccsm.0k.loadings <- loadings(ccsm.0k.fa)
#bio1, bio2, bio3, bio16, bio17

#BIO1 = Annual Mean Temperature #BIO2 = Mean Diurnal Range (Mean of monthly (max temp - min temp)) #BIO3 = Isothermality (BIO2/BIO7) (* 100) #BIO4 = Temperature Seasonality (standard deviation *100) #BIO5 = Max Temperature of Warmest Month #BIO6 = Min Temperature of Coldest Month #BIO7 = Temperature Annual Range (BIO5-BIO6) #BIO8 = Mean Temperature of Wettest Quarter #BIO9 = Mean Temperature of Driest Quarter #BIO10 = Mean Temperature of Warmest Quarter #BIO11 = Mean Temperature of Coldest Quarter #BIO12 = Annual Precipitation #BIO13 = Precipitation of Wettest Month #BIO14 = Precipitation of Driest Month #BIO15 = Precipitation Seasonality (Coefficient of Variation) #BIO16 = Precipitation of Wettest Quarter #BIO17 = Precipitation of Driest Quarter #BIO18 = Precipitation of Warmest Quarter #BIO19 = Precipitation of Coldest Quarter



#salvando matriz com variaveis selecionadas

setwd("/Users/matheusribeiro/Dropbox/aaa_Matheus_Ribeiro-2014-11-06/UFG - campus Jatai/Disciplinas/ENMs/dados/AS")

write.table(ccsm.0k.ASm[,c("x", "y", "bio.1", "bio.2", "bio.3", "bio.16", "bio.17")], "clima_AS_0k.txt", row.names=F, sep=" ")  #se o arquivo txt der erro, salve em csv, abaixo:
#write.table(ccsm.0k.ASm[,c("x", "y", "bio.1", "bio.2", "bio.3", "bio.16", "bio.17")], "clima_AS.csv", row.names=F, sep=",")


# salvando raster para variaveis selecionadas na AS
writeRaster(ccsm.0k.ASr$bio.1, "bio1_AS_0k.grd", format="raster")
writeRaster(ccsm.0k.ASr$bio.2, "bio2_AS_0k.grd", format="raster")
writeRaster(ccsm.0k.ASr$bio.3, "bio3_AS_0k.grd", format="raster")
writeRaster(ccsm.0k.ASr$bio.16, "bio16_AS_0k.grd", format="raster")
writeRaster(ccsm.0k.ASr$bio.17, "bio17_AS_0k.grd", format="raster")

#lendo os arquivos raster salvos a partir do hd
bio1 <- raster("bio1_AS_0k.grd")
bio2 <- raster("bio2_AS_0k.grd")
bio3 <- raster("bio3_AS_0k.grd")
bio16 <- raster("bio16_AS_0k.grd")
bio17 <- raster("bio17_AS_0k.grd")


clima.AS <- stack(c(bio1,bio2, bio3, bio16, bio17))
names(clima.AS) <- c("bio1","bio2", "bio3", "bio16", "bio17")
plot(clima.AS)


### PONTOS DE OCORRENCIA
#lendo arquivo com ocorrencias especie

setwd("/Users/matheusribeiro/Dropbox/aaa_Matheus_Ribeiro-2014-11-06/UFG - campus Jatai/Disciplinas/ENMs/dados/ocorrencias")
Taurea <- read.table("Taurea.txt", h=T)
Taurea[1:5,]
Taurea <- Taurea[,-1]

plot(clima.AS$bio1)
points(Taurea[,"long"], Taurea[,"lat"], pch= 20)


# extraindo variáveis a partir dos pontos de ocorrencia Taurea
Taurea_var <- extract(clima.AS, Taurea, cellnumbers=T)
Taurea_var <- cbind(Taurea, Taurea_var)
Taurea_var         #note que existem NAs na matriz e células repetidas (duas ou mais ocorrencias em uma mesma celula)

duplicated(Taurea_var[,"cells"])
dup <- which(duplicated(Taurea_var[,"cells"]) == TRUE)

Taurea_var <- Taurea_var[-dup,]  #note que ainda restaram NAs
Taurea_var <- na.omit(Taurea_var)
nrow(Taurea_var)

write.table(Taurea_var, "Taurea_var.txt", row.names=F, sep=" ") #se o arquivo txt der erro, salve em csv, abaixo:
#write.table(Taurea_var, "Taurea_var.csv", row.names=F, sep=",")




#### AMOSTRANDO BACKGROUND (aleatorio)
AS <- extract(clima.AS, 1:ncell(clima.AS))
AS.coords <- xyFromCell(clima.AS, 1:ncell(clima.AS)) 
AS <- cbind(AS.coords, cells= 1:ncell(clima.AS), AS)
AS <- na.omit(AS)

back.id <- sample(1:nrow(AS), nrow(Taurea_var))  # mantendo prevalencia 0.5
back <- AS[back.id,]
points(back[,"x"], back[,"y"], pch=20, col='red')

write.table(back, "Background_random.txt", row.names=F, sep=" ") #se o arquivo txt der erro, salve em csv, abaixo:
#write.table(Taurea_var, "Taurea_var.csv", row.names=F, sep=",")





### PROCESSANDO DADOS CLIMATICOS DO LGM E FUTURO (repetindo o mesmo procedimento GIS; cortar pra America do Sul)

setwd("/Users/matheusribeiro/Dropbox/aaa_Matheus_Ribeiro-2014-11-06/UFG - campus Jatai/Disciplinas/ENMs/dados/ambientais")

ccsm.21k <- read.table("bio_var_CCSM_21k_global.txt", h=T)
ccsm.rcp45 <- read.table("bio_var_CCSM_rcp45_global.txt", h=T)

ccsm.21k <- ccsm.21k[, c("long", "lat", "bio.1", "bio.2", "bio.3", "bio.16", "bio.17")]
ccsm.rcp45 <- ccsm.rcp45[, c("long", "lat", "bio.1", "bio.2", "bio.3", "bio.16", "bio.17")]


# transformando em arquivo espacializado - gride
gridded(ccsm.21k) <- ~long+lat
gridded(ccsm.rcp45) <- ~long+lat

#stack
ccsm.21k.r <- stack(ccsm.21k)
ccsm.rcp45.r <- stack(ccsm.rcp45)

# cortando raster - América do Sul (xmin, xmax, ymin, ymax)
e <- extent(c(-90, -30, -60, 15))
ccsm.21k.ASr <- crop(ccsm.21k.r, e)
ccsm.rcp45.ASr <- crop(ccsm.rcp45.r, e)

#extraindo valores do raster
ccsm.21k.val <- values(ccsm.21k.ASr)
ccsm.rcp45.val <- values(ccsm.rcp45.ASr)

coords <- xyFromCell(ccsm.21k.ASr, 1:ncell(ccsm.21k.ASr))

ccsm.21k.ASm <- cbind(coords, ccsm.21k.val)
ccsm.rcp45.ASm <- cbind(coords, ccsm.rcp45.val)

ccsm.21k.ASm <- na.omit(ccsm.21k.ASm)
ccsm.rcp45.ASm <- na.omit(ccsm.rcp45.ASm)

setwd("/Users/matheusribeiro/Dropbox/aaa_Matheus_Ribeiro-2014-11-06/UFG - campus Jatai/Disciplinas/ENMs/dados/AS")
write.table(ccsm.21k.ASm, "clima_AS_21k.txt", row.names=F, sep="	") #se o arquivo txt der erro, salve em csv, abaixo:
#write.table(ccsm.21k.ASm, "clima_AS_21k.csv", row.names=F, sep=",")

write.table(ccsm.rcp45.ASm, "clima_AS_rcp45.txt", row.names=F, sep="	") #se o arquivo txt der erro, salve em csv, abaixo:
#write.table(ccsm.rcp45.ASm, "clima_AS_rcp45.csv", row.names=F, sep=",")


