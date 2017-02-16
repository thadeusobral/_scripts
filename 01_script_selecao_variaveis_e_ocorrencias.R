### disciplina - modelagem de  nicho ecológico: teoria e prática ###
### ppg ecologia - unicamp 2016 ###

# Thadeu Sobral de Souza 
# Maurício Humberto Vancine


###=========================================================================================###
### script montagem das variaveis e analise fatorial ### 
###=========================================================================================###


# limpar o workspace e aumentar a memoria para o r
rm(list = ls())
memory.limit(size = 10000000000) 

# instalar e carregar pacotes
ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, 'Package'])]
    if (length(new.pkg)) 
        install.packages(new.pkg, dep = T)
    sapply(pkg, require, character.only = T)}

packages <- c('sp', 'raster', 'psych', 'maptools', 'dismo', 'foreign', 'rgdal', 'vegan', 'corrplot')

ipak(packages)

###=========================================================================================###

# diretorio
setwd('C:/Users/leec/Dropbox/disciplina_enm_R_unicamp_2016/scripts_r/variaveis_asc')
getwd()

# listar o nome dos arquivos no diretorio com um padrao
asc <- list.files(pattern = '.asc')
asc

# selecionar o nome dos arquivos especificos
pres <- asc[grepl('0k', asc)]
pres
lgm <- asc[grepl('21k', asc)]
lgm
hol <- asc[grepl('6k', asc)]
hol

# carregar os arquivos .asc
pres.stack <- stack(pres)
pres.stack
names(pres.stack)
plot(pres.stack)

lgm.stack <- stack(lgm)
hol.stack <- stack(hol)

# extraindo valores dos arquivos .asc e omitindo os NAs
pres.val <- na.omit(values(pres.stack))
dim(pres.val)
head(pres.val)

lgm.val <- na.omit(values(lgm.stack))
hol.val <- na.omit(values(hol.stack))

# extraindo as coordenadas das celulas
id <- cbind(1:ncell(pres.stack), values(pres.stack)[, 1])
head(id)
dim(id)

id.na <- na.omit(id)
head(id.na)
dim(id.na)

coords <- xyFromCell(pres.stack, id.na[, 1])
head(coords)
dim(coords)

colnames(coords) <- c('long','lat')
head(coords)

# juntando coordenadas com valores
pres.table <- cbind(coords, pres.val)
head(pres.table)[, c(1:5)]

lgm.table <- cbind(coords, lgm.val)
hol.table <- cbind(coords, hol.val)

# criar pasta para exportar essas tabelas
setwd('..') # volta uma pasta no diretorio
getwd() # formece o diretorio
dir.create('variaveis_tabelas') # cria uma pasta
setwd('./variaveis_tabelas') # muda o diretorio
getwd()

# salvar tabela com as variaveis
write.table(pres.table, 'presente.txt', row.names = F)
write.table(lgm.table, 'lgm.txt', row.names = F)
write.table(hol.table, 'hol.txt', row.names = F)

###=========================================================================================###

# Abrindo as tabelas
pres.imp <- read.table('presente.txt', h = T)
head(pres.imp)
lgm.imp <- read.table('lgm.txt', h = T)
hol.imp <- read.table('hol.txt', h = T)

# transformando em arquivos espacializados - grid
gridded(pres.imp) <- ~long + lat
gridded(lgm.imp) <- ~long + lat
gridded(hol.imp) <- ~long + lat

# transformando em arquivos stack raster
pres.s <- stack(pres.imp)
lgm.s <- stack(lgm.imp)
hol.s <- stack(hol.imp)

# plot
plot(pres.s)
plot(lgm.s)
plot(hol.s)

###=========================================================================================###

# cortando raster - America do Sul (xmin, xmax, ymin, ymax)
# importar shape
# e <- shapefile('brazil.shp')
e <- extent(c(-90, -30, -60, 15))
pres.c <- crop(pres.s, e)
lgm.c <- crop(lgm.s, e)
hol.c <- crop(hol.s, e)

# visualizando o corte dos rasters
plot(pres.c)
plot(lgm.c)
plot(hol.c)

# contando o numero de celulas
ncell(pres.c)
ncell(lgm.c)
ncell(hol.c)

# extraindo valores dos rasters cortados
pres.c.v <- values(pres.c)
lgm.c.v <- values(lgm.c)
hol.c.v <- values(hol.c)

# contando o numero de linhas
nrow(pres.c.v)
nrow(lgm.c.v)
nrow(hol.c.v)

# extraindo as coordenadas
coord.AS <- xyFromCell(pres.c, 1:ncell(pres.c))
head(coord.AS)
nrow(coord.AS)
colnames(coord.AS) <- c('long', 'lat')
head(coord.AS)

# combinando valores com as coordenadas
pres.AS <- cbind(coord.AS, pres.c.v)
lgm.AS <- cbind(coord.AS, lgm.c.v)
hol.AS <- cbind(coord.AS, hol.c.v)
dim(pres.AS)

# omitindo NA
pres.AS.na <- na.omit(pres.AS)
lgm.AS.na <- na.omit(lgm.AS)
hol.AS.na <- na.omit(hol.AS)
dim(pres.AS.na)
nrow(lgm.AS.na)
nrow(hol.AS.na)

# criar pasta para exportar essas tabelas para AS
setwd('..')
getwd() 
dir.create('variaveis_tabelas_AS') 
setwd('./variaveis_tabelas_AS') 

# salvar tabela com as variaveis
write.table(pres.AS.na, 'pres_AS.txt', row.names = F)
write.table(lgm.AS.na, 'lgm_AS.txt', row.names = F)
write.table(hol.AS.na, 'hol_AS.txt', row.names = F)

###=========================================================================================###

# correlacao

# criar pasta para exportar
setwd('..') 
getwd() 
dir.create('analise_selecao_variaveis') 
setwd('./analise_selecao_variaveis') 
dir.create('correlacao') 
setwd('./correlacao') 
getwd() 

# presente
cor.pres <- cor(pres.AS.na[, -c(1, 2)])
cor.pres

write.table(cor.pres, 'cor_pres.txt', row.names = F)

png('cor_pres.png')
corrplot(cor(pres.AS.na[, -c(1, 2)]), type = "lower", diag = F, title = 'Correlações entre Biovariáveis',
	   mar = c(3, 0.5, 2, 1), tl.srt = 45)
dev.off()

###=========================================================================================###

# pca

# criar pasta para exportar
setwd('..') 
getwd() 
dir.create('pca') 
setwd('./pca') 
getwd() 

# selecionar apenas as variaveis bioclimaticas
pres.bio <- pres.AS.na[, - c(1, 2)] 
head(pres.bio)

# verificar NAs
any(is.na(pres.bio))

# padronizar as variaveis
pres.bio.p <- decostand(pres.bio, 'stan')

cor(pres.bio[, 1], pres.bio.p[, 1])
cor(pres.bio[, 2], pres.bio.p[, 2])

summary(pres.bio)
summary(pres.bio.p)

# pca
pca <- rda(pres.bio.p)

# plot pca
biplot(pca)
plot(pca)

# screeplot 
screeplot(pca)

# porcentagem de explicacao de cada eixo
head(summary(pca))

# lodings das variaveis
summary(pca)$species

# correlacao entre cada variavel e as PCs
cor.pca <- cor(pres.bio,(summary(pca)$sites))
write.table(cor.pca, 'cor_pca.txt', row.names = F)

###=========================================================================================###

# analise fatorial

# criar pasta para exportar
setwd('..') 
getwd() 
dir.create('fatorial') 
setwd('./fatorial') 
getwd() 

# screeplot
fa.parallel(pres.AS.na[, -c(1:2)], fa = 'fa') 

# exportar screeplot
png('screeplot_fatorial.png')
fa.parallel(pres.AS.na[, -c(1:2)], fa = 'fa') 
dev.off()

# analise fatorial
pres.fa <- fa(pres.AS.na[, -c(1:2)], nfactors = 5, rotate = 'varimax')
pres.loadings <- loadings(pres.fa)
pres.loadings

# exportar tabela dos resultados
write.table(pres.loadings, 'fa_loadings_AS.txt')

# bios escolhidas
# bio1, bio2, bio3, bio16, bio17

# significado das bios
# BIO1 = Annual Mean Temperature
# BIO2 = Mean Diurnal Range (Mean of monthly (max temp - min temp))
# BIO3 = Isothermality (BIO2/BIO7) (* 100)
# BIO4 = Temperature Seasonality (standard deviation *100)
# BIO5 = Max Temperature of Warmest Month
# BIO6 = Min Temperature of Coldest Month
# BIO7 = Temperature Annual Range (BIO5-BIO6)
# BIO8 = Mean Temperature of Wettest Quarter
# BIO9 = Mean Temperature of Driest Quarter
# BIO10 = Mean Temperature of Warmest Quarter
# BIO11 = Mean Temperature of Coldest Quarter
# BIO12 = Annual Precipitation
# BIO13 = Precipitation of Wettest Month
# BIO14 = Precipitation of Driest Month
# BIO15 = Precipitation Seasonality (Coefficient of Variation)
# BIO16 = Precipitation of Wettest Quarter
# BIO17 = Precipitation of Driest Quarter
# BIO18 = Precipitation of Warmest Quarter
# BIO19 = Precipitation of Coldest Quarter

###=========================================================================================###

# abrindo as tabelas
setwd('..') 
setwd('C:/Users/leec/Dropbox/disciplina_enm_R_unicamp_2016/scripts_r/variaveis_tabelas_AS')
getwd() 

# importar tabelas da america do sul sem NAs
pres.AS <- read.table('pres_AS.txt', h = T)
head(pres.AS)

lgm.AS <- read.table('lgm_AS.txt', h = T)
hol.AS <- read.table('hol_AS.txt', h = T)

# criar pasta para exportar as variaveis selecionadas
setwd('..')
getwd()  
dir.create('variaveis_selecionadas_fatorial') 
setwd('./variaveis_selecionadas_fatorial') 
getwd() 

# salvando matriz com variaveis selecionadas
pres.AS.sub <- subset(pres.AS, select = c('long', 'lat', 'CCSM_0k_neotropic_bio01', 
				'CCSM_0k_neotropic_bio02', 'CCSM_0k_neotropic_bio03', 
				'CCSM_0k_neotropic_bio16', 'CCSM_0k_neotropic_bio17'))
head(pres.AS.sub)
write.table(pres.AS.sub, 'clima_AS_0k.txt', row.names = F, sep = ' ')  


lgm.AS.sub <- subset(lgm.AS, select = c('long', 'lat', 'CCSM_21k_neotropic_bio01', 
				'CCSM_21k_neotropic_bio02', 'CCSM_21k_neotropic_bio03', 
				'CCSM_21k_neotropic_bio16', 'CCSM_21k_neotropic_bio17'))
head(lgm.AS.sub)
write.table(lgm.AS.sub, 'clima_AS_21k.txt', row.names = F, sep = ' ')  


hol.AS.sub <- subset(hol.AS, select = c('long', 'lat', 'CCSM_6k_neotropic_bio01', 
				'CCSM_6k_neotropic_bio02', 'CCSM_6k_neotropic_bio03', 
				'CCSM_6k_neotropic_bio16', 'CCSM_6k_neotropic_bio17'))
head(hol.AS.sub)
write.table(hol.AS.sub, 'clima_AS_6k.txt', row.names = F, sep = ' ')  


# transformando em arquivos espacializados - grid
gridded(pres.AS.sub) <- ~long + lat
gridded(lgm.AS.sub) <- ~long + lat
gridded(hol.AS.sub) <- ~long + lat

# transformando em arquivos stack raster
pres.AS.s <- stack(pres.AS.sub)
lgm.AS.s <- stack(lgm.AS.sub)
hol.AS.s <- stack(hol.AS.sub)

# plot
plot(pres.AS.s)
plot(lgm.AS.s)
plot(hol.AS.s)

# salvando .asc para variaveis selecionadas na AS
writeRaster(pres.AS.s$CCSM_0k_neotropic_bio01, 'bio1_AS_0k.asc', format = 'ascii')
writeRaster(pres.AS.s$CCSM_0k_neotropic_bio02, 'bio2_AS_0k.asc', format = 'ascii')
writeRaster(pres.AS.s$CCSM_0k_neotropic_bio03, 'bio3_AS_0k.asc', format = 'ascii')
writeRaster(pres.AS.s$CCSM_0k_neotropic_bio16, 'bio16_AS_0k.asc', format = 'ascii')
writeRaster(pres.AS.s$CCSM_0k_neotropic_bio17, 'bio17_AS_0k.asc', format = 'ascii')
 
writeRaster(lgm.AS.s$CCSM_21k_neotropic_bio01, 'bio1_AS_21k.asc', format = 'ascii')
writeRaster(lgm.AS.s$CCSM_21k_neotropic_bio02, 'bio2_AS_21k.asc', format = 'ascii')
writeRaster(lgm.AS.s$CCSM_21k_neotropic_bio03, 'bio3_AS_21k.asc', format = 'ascii')
writeRaster(lgm.AS.s$CCSM_21k_neotropic_bio16, 'bio16_AS_21k.asc', format = 'ascii')
writeRaster(lgm.AS.s$CCSM_21k_neotropic_bio17, 'bio17_AS_21k.asc', format = 'ascii')

writeRaster(hol.AS.s$CCSM_6k_neotropic_bio01, 'bio1_AS_6k.asc', format = 'ascii')
writeRaster(hol.AS.s$CCSM_6k_neotropic_bio02, 'bio2_AS_6k.asc', format = 'ascii')
writeRaster(hol.AS.s$CCSM_6k_neotropic_bio03, 'bio3_AS_6k.asc', format = 'ascii')
writeRaster(hol.AS.s$CCSM_6k_neotropic_bio16, 'bio16_AS_6k.asc', format = 'ascii')
writeRaster(hol.AS.s$CCSM_6k_neotropic_bio17, 'bio17_AS_6k.asc', format = 'ascii')





