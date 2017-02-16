### disciplina - modelagem de  nicho ecológico: teoria e pratica ###
### ppg ecologia e biodiversidade - unesp 2017 ###

# Thadeu Sobral de Souza - thadeusobral@gmail.com 
# Maurício Humberto Vancine - mauricio.vancine@gmail.com


###-----------------------------------------------------------------------------------------###
### script preparacao e selecao das variaveis ambientais ### 
###-----------------------------------------------------------------------------------------###

# 0. limpara a memoria e carregar os pacotes 
# limpar o workspace e aumentar a memoria para o r
rm(list = ls())
memory.limit(size = 10000000000000) 

# instalar e carregar pacotes
# install.packages(c("raster", "rgdal", "corrplot", "RStoolbox", "vegan", "psych"), dep = T)

# carregar pacotes
library(raster) # manejo de arquivos sig 
library(rgdal) # manejo de arquivos sig
library(corrplot) # graficos de correlacao
library(RStoolbox) # pca de raster
library(vegan) # diversas analises multivariadas
library(psych) # analise fatorial

###-----------------------------------------------------------------------------------------###

# 2. importar os dados
# diretorio
setwd("D:/90_aulas_montadas/_disciplina_enm_R_unesp_2017/scripts_r/variaveis_asc")
getwd()

# listar o nome dos arquivos no diretorio com um padrao
asc <- list.files(pattern = ".asc")
asc

# selecionar o nome dos arquivos especificos
pres <- asc[grepl("0k", asc)]
pres

lgm <- asc[grepl("21k", asc)]
lgm

hol <- asc[grepl("6k", asc)]
hol

# carregar os arquivos .asc em uma variavel rasterstack e renomea-los
pres.s <- stack(pres)
pres.s

names(pres.s)
names(pres.s) <- paste0("pres_", "bio", 1:19)
names(pres.s)

plot(pres.s)
plot(pres.s[[1]])

# bioclim - descricao
# http://www.worldclim.org/bioclim

lgm.s <- stack(lgm)
lgm.s
names(lgm.s) <- paste0("lgm_", "bio", 1:19)
plot(lgm.s)

hol.s <- stack(hol)
hol.s
names(hol.s) <- paste0("hol_", "bio", 1:19)
plot(hol.s)

###-----------------------------------------------------------------------------------------###

# 3. cortar raster para a area de interesse - mascara
# 3.1. limite de interesse
# extensao
e <- extent(c(-90, -34, -60, 15)) # xmin, xmax, ymin, ymax
plot(e, xlab = "long", ylab = "lat", cex.lab = 1.3, col = "red")

# corte
pres.e <- crop(pres.s, e)
pres.e
pres.s

pres.e <- stack(pres.e)
pres.e

plot(pres.e)

plot(pres.s[[1]])
plot(e, col = "red", add = T)

par(mfrow = c(1, 2))
plot(pres.s$pres_bio1)
plot(pres.e$pres_bio1)

lgm.e <- crop(lgm.s, e)
lgm.e

hol.e <- crop(hol.s, e)
hol.e


# 3.2 a partir de um shapefile
# importar shapefile
br <- shapefile("brasil_gcs_wgs84.shp")
plot(br, axes = T)

# ajuste ao limite
ma <- mask(pres.s, br)
plot(ma[[1]])
plot(br, add = T)

# ajuste da extensao
cr <- crop(pres.s, br)
plot(cr[[1]])
plot(br, add = T)

# ajustar o limite e a extesao
ma <- mask(pres.s, br)
cr <- crop(ma, br)
plot(cr[[1]])

cr <- crop(pres.s, br)
ma <- mask(cr, br)
plot(ma[[1]])

# juntos
pres.br <- mask(crop(pres.s, br), br)
plot(pres.br)

lgm.br <- mask(crop(lgm.s, br), br)
plot(lgm.br)

hol.br <- mask(crop(hol.s, br), br)
plot(hol.br)

###-----------------------------------------------------------------------------------------###

4. extrair os valores das celulas
# extraindo valores dos rasters cortados
pres.e.v <- values(pres.e)
head(pres.e.v)
head(pres.e.v, 10)
head(pres.e.v, 50)

# contando o numero de linhas
nrow(pres.e.v)

# dimensao
dim(pres.e.v)

# omitir os NAs
pres.e.v.na <- na.omit(pres.e.v)
head(pres.e.v.na, 50)
dim(pres.e.v.na)

# perguntar se ha NAs
any(is.na(pres.e.v.na))

###-----------------------------------------------------------------------------------------###

# 5.correlacao

# criar pasta e definir diretorio para analise exploratoria - correlacao

dir.create("analise_selecao_variaveis")  # criar uma pasta no diretorio

setwd("./analise_selecao_variaveis")  # mudar o diretorio para a pasta criada

dir.create("correlacao")  # criar pasta no diretorio da pasta criada

setwd("./correlacao") # mudar o diretorio para a pasta criada, da pasta criada

getwd() 

# tabela da correlacao
corr <- cor(pres.e.v.na)
corr
round(corr, 2) # arredondamento dos valores para dois valores decimais
abs(round(corr, 2)) # arredondamento e valor absoluto

# exportar tabela com a correlacao
write.table(abs(round(corr, 2)), "cor_pres.xls", row.names = T, sep = "\t")
write.table(ifelse(corr >= 0.7, "Sim", "Não"), "cor_pres_afirmacao.xls", row.names = T, 
		sep = "\t")

# plot da correlacao
corrplot(corr, type = "lower", diag = F, tl.srt = 45, mar = c(3, 0.5, 2, 1),
	   title = "Correlações entre variáveis Bioclimáticas")

# apenas azul
corrplot(abs(corr), type = "lower", diag = F, tl.srt = 45, mar = c(3, 0.5, 2, 1),
	   title = "Correlações entre variáveis Bioclimáticas")

# apenas vermelho
corrplot(-1 * (abs(corr)), type = "lower", diag = F, tl.srt = 45, mar = c(3, 0.5, 2, 1),
	   title = "Correlações entre variáveis Bioclimáticas")

# exportar figura na pasta do diretorio
tiff("cor_ma.tif", width = 18, height = 18, units = "cm", res = 300, compression = "lzw")

corrplot(abs(corr), type = "lower", diag = F, tl.srt = 45, mar = c(3, 0.5, 2, 1),
	   title = "Correlações entre variáveis Bioclimáticas")

dev.off()

###-----------------------------------------------------------------------------------------###

# 6. pca

# criar pasta e definir diretorio para analise exploratoria - pca
setwd("..") # voltar uma pasta no diretorio
getwd() # conferir o diretorio
dir.create("pca") # criar pasta no diretorio
setwd("./pca") # mudar o diretorio para a pasta criada
getwd() # conferir o diretorio

# 6.1. pca para escolher variaveis
# pca do pacote "stats"
# pca com normalizacao interna
pca <- prcomp(pres.e.v.na, scale = T)
pca

# contribuicao de cada eixo (eigenvalues - autovalores)
summary(pca)

# grafico de barras com as contribuicoes
screeplot(pca, main = "Contribuição de cada PC", ylab = "Autovalores")
abline(h = 1, col = "red", lty = 2)

tiff("screeplot.tif", wid = 18, hei = 18, un = "cm", res = 300, comp = "lzw")
screeplot(pca, main = "Contribuição de cada PC", ylab = "Autovalores")
abline(h = 1, col = "red", lty = 2)
dev.off()

# valores de cada eixo (eigenvectors - autovetores - escores)
pca$x

# relacao das variaveis com cada eixo (loadings - cargas)
pca$rotation[, 1:5]
abs(pca$rotation[, 1:5])

# exportar tabela com a contribuicao
write.table(round(abs(pca$rotation[, 1:5]), 2), "contr_pca.xls", row.names = T, sep = "\t")

# plot
biplot(pca)



# 6.2. pca como novas variaveis
# pca dos raster
pca.e <- rasterPCA(pres.e, spca = T) 
pca.e

# contribuicao dos componentes
summary(pca.e$model)
summary(pca)

# grafico de barras com as contribuicoes
screeplot(pca.e$model, main = "Contribuição de cada PC", ylab = "Autovalores")
abline(h = 1, col = "red", lty = 2)

screeplot(pca, main = "Autovalores")
abline(h = 1, col = "red", lty = 2)

tiff("screeplot_raster.tif", wid = 18, hei = 18, un = "cm", res = 300, comp = "lzw")
screeplot(pca.e$model, main = "Contribuição de cada PC", ylab = "Autovalores")
abline(h = 1, col = "red", lty = 2)
dev.off()

# plot das pcs como novas variaveis
plot(pca.e$map)

plot(pca.e$map[[1:5]])

# exportar as novas variaveis
# exportar apenas uma variavel
writeRaster(pca.e$map[[1]], "pc1_br.asc", format = "ascii")

# exportar as cinco variaveis
print(1)
print(2)
print(3)
print(4)
print(5)

for(i in 1:5){
  print(i)}

for(i in 1:5000){
  print(i)}

for(i in 1:5){
  writeRaster(pca.e$map[[i]], paste0("pc", i, "_e.asc"), format = "ascii")}

###-----------------------------------------------------------------------------------------###

# 7. analise fatorial

# criar pasta e definir diretorio para analise exploratoria - fatorial
setwd("..") 
getwd() 
dir.create("fatorial") 
setwd("./fatorial") 
getwd() 

# analises preliminares de possibilidade de uso da analise fatorial
# kmo e bartlett
KMO(cor(pres.e.v.na)) # deve ser acima de 0.5
cortest.bartlett(cor(pres.e.v.na), n = nrow(pres.e.v.na)) # deve ser significativo (p < 0.05)

# numero de eixos - semelhante a pca
# screeplot
fa <- fa.parallel(pres.e.v.na, fm = "ml", fa = "fa") # sugere 5 eixos
fa

# exportar screeplot
tiff("screeplot_fatorial.tif", wid = 18, hei = 18, un = "cm", res = 300, comp = "lzw")
fa.parallel(pres.e.v.na, fm = "ml", fa = "fa") 
dev.off()

# fatorial
fa.e <- fa(pres.e.v.na, nfactors = 5, rotate = "varimax", fm = "ml")
e.loadings <- loadings(fa.e)
e.loadings

# exportar tabela dos resultados
write.table(abs(round(as.loadings, 2)), "as_loadings.xls", row.names = T, sep = "\t")

# bios escolhidas
# bio02, bio04, bio10, bio16, bio17

# significado das bios
# BIO1 = Temperatura media anual
# BIO2 = Variacao da media diurna (media por mes (temp max - temp min))
# BIO3 = Isotermalidade (BIO2/BIO7) (* 100)
# BIO4 = Sazonalidade da temperatura (desvio padrao deviation *100)
# BIO5 = Temperatura maxima do mes mais quente
# BIO6 = Temperatura minima do mes mais frio
# BIO7 = Variacao da temperatura anual (BIO5-BIO6)
# BIO8 = Temperatura media do trimestre mais chuvoso
# BIO9 = Temperatura media do trimestre mais seco
# BIO10 = Temperatura media do trimestre mais quente
# BIO11 = Temperatura media do trimestre mais frio
# BIO12 = Precipitacao anual
# BIO13 = Precipitacao do mes mais chuvoso
# BIO14 = Precipitacao do mes mais seco
# BIO15 = Sazonalidade da precipitacao (coeficiente de variacao)
# BIO16 = Precipitacao do trimestre mais chuvoso
# BIO17 = Precipitacao do trimestre mais seco
# BIO18 = Precipitacao do trimestre mais quente
# BIO19 = Precipitacao do trimestre mais frio

###-----------------------------------------------------------------------------------------###

# 8. exportar as variaveis escolhidas
pres.e
names(pres.e)

lista <- list(2, 4, 10, 16, 17)

for(i in lista){
  writeRaster(pres.e[[i]], paste0("pres_bio", i, "_e.asc"), format = "ascii")}

###-----------------------------------------------------------------------------------------###
