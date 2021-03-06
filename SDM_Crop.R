###Pacotes necess�rios

########################################################################
###########################instale os pacotes###########################
########################################################################

install.packages("dismo")
install.packages("raster")
install.packages("maptools")
install.packages("rgdal")

########################################################################
########################### instale a fun��o ###########################
########################################################################

########################################################################
############### selecione as linhas 20 a 56 e apert ctrl + r ###########
########################################################################

SDM.Crop<-function(dir,Xmin, Xmax, Ymin, Ymax,NoData=-9999){

#esta fun��o serve para cortar as vari�veis ambientais que est�o no diret�rio
#"dir" com o poligono cujos vertices s�o descritas por Xmin, Xmax, Ymin, Ymax!

  #duvidas... thiagobernardi007@gamil.com
  
  ### dir = diretorio onde se encontram os arquivos .asc, lembre-se
  ### retire os arquivos .asc.aux caso existam!!!!! o dir deve 
  ### vir entre "" e com barras invertidas / ex: "G:/Neotrop8km/Variaveis"
  
  ### Xmin = limite da extencao mais a oeste
  ### Ymin = limite da extencao mais ao sul
  ### Xmax = limite da extencao mais a leste
  ### Ymax = limite da extencao mais ao norte
  
  ### NoData = qual o valor desejado de nodata? Pelo nosso padr�o ele � =-999
 
  
require("dismo")
require("raster")
require("maptools")
require("rgdal")

setwd(dir)
arq<-list.files(pattern=".asc") 
variables<-sapply(arq,raster,simplify=F,h=T)
extencao<- extent(Xmin, Xmax, Ymin, Ymax)  
dir.create("cortados")
setwd("cortados")
for (i in 1:length(arq)){
  extencaofinal<- crop(variables[[i]], extencao)
  writeRaster (extencaofinal, arq[i], format="ascii", NAflag=NoData)
}
return("Tudo Feito, Manolo!")
}

########################################################################
############## agora e so rodar a fun��o com os seus dados #############
########################################################################


#exemplo!!
#Substitua o seu diretorio e a extens�o desejada
SDM.Crop("G:/Neotrop8km/Variaveis",-30,0,-30,0)

SDM.Crop("C:/Users/Thadeu Sobral/Documents/Modelos/Modelo_algas",-170,170,-78,-50)
