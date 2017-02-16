rm(list=ls())

#leia os pacotes abaixo:

library(sp)
library(raster)
library(dismo)
library(kernlab) # SVM
library(rJava)

cross_validation <- 20 #numero de repeticoes do cross validation






# lendo arquivos climaticos, ocorrencia, background
setwd("/Users/matheusribeiro/Dropbox/aaa_Matheus_Ribeiro-2014-11-06/UFG - campus Jatai/Disciplinas/ENMs/dados/AS")
clima0k <- read.table("clima_AS_0k.txt", h=T)
clima21k <- read.table("clima_AS_21k.txt", h=T)
climarcp45 <- read.table("clima_AS_rcp45.txt", h=T)

gridded(clima0k) <- ~x+y
gridded(clima21k) <- ~x+y
gridded(climarcp45) <- ~x+y

clima0k.r <- stack(clima0k)
clima21k.r <- stack(clima21k)
climarcp45.r <- stack(climarcp45)


setwd("/Users/matheusribeiro/Dropbox/aaa_Matheus_Ribeiro-2014-11-06/UFG - campus Jatai/Disciplinas/ENMs/dados/ocorrencias")
back <- read.table("Background_random.txt", h=T)
ocor <- read.table("Taurea_var.txt", h=T)







#objetos para guardar os resultados parciais a cada loop do cross-validation

Bioclim.Pout0k <- NULL
Gower.Pout0k <- NULL
SVM.Pout0k <- NULL
GLM.Pout0k <- NULL
Maxent.Pout0k <- NULL

Bioclim.Pout21k <- NULL
Gower.Pout21k <- NULL
SVM.Pout21k <- NULL
GLM.Pout21k <- NULL
Maxent.Pout21k <- NULL

Bioclim.Poutrcp45 <- NULL
Gower.Poutrcp45 <- NULL
SVM.Poutrcp45 <- NULL
GLM.Poutrcp45 <- NULL
Maxent.Poutrcp45 <- NULL


###
# loop para cross-validation
for(i in 1:cross_validation){

# dados de treino e teste
sample.ocor <- sample(1:nrow(ocor), round(0.75*nrow(ocor)))
sample.back <- sample(1:nrow(back), round(0.75*nrow(back)))

treino <- prepareData(x= clima0k.r, p= ocor[sample.ocor,1:2], b= back[sample.back,1:2], xy=T)
#treino1 <- prepareData(x= clima0k.r, p= ocor[sample.ocor,"cells"], b= back[sample.back,"cells"]) #compare os dados de treino (extraidos com lat/long) e treino1 (extraido com cellNumber)

teste <- prepareData(x= clima0k.r, p= ocor[-sample.ocor,1:2], b= back[-sample.back,1:2], xy=T)



######
## Bioclim
	
	#ajustando o modelo
	Bioclim.model <- bioclim(treino[treino[,"pb"]==1, -c(1:3)])
	
	#fazendo predicoes
	Bioclim0k <- predict(clima0k.r, Bioclim.model)
	Bioclim21k <- predict(clima21k.r, Bioclim.model)
	Bioclimrcp45 <- predict(climarcp45.r, Bioclim.model)

	#avaliando o modelo
	Bioclim.eval <- evaluate(p= teste[teste[,"pb"]==1, -c(1:3)], a= teste[teste[,"pb"]==0, -c(1:3)], model= Bioclim.model)
	
	#encontrando threshold
	Bioclim.thr <- threshold(Bioclim.eval)



######
## Gower
	
	#ajustando o modelo
	Gower.model <- domain(treino[treino[,"pb"]==1, -c(1:3)])
	
	#fazendo predicoes
	Gower0k <- predict(clima0k.r, Gower.model)
	Gower21k <- predict(clima21k.r, Gower.model)
	Gowerrcp45 <- predict(climarcp45.r, Gower.model)
	
	#avaliando o modelo
	Gower.eval <- evaluate(p= teste[teste[,"pb"]==1, -c(1:3)], a= teste[teste[,"pb"]==0, -c(1:3)], model= Gower.model)
		
	#encontrando threshold
	Gower.thr <- threshold(Gower.eval)
		




######
## SVM
	
	#ajustando o modelo
	SVM.model <- ksvm(pb ~ bio.1+bio.2+bio.3+bio.16+bio.17, data= treino)
	
	#fazendo predicoes
	SVM0k <- predict(clima0k.r, SVM.model)
	SVM21k <- predict(clima21k.r, SVM.model)
	SVMrcp45 <- predict(climarcp45.r, SVM.model)
	
	#avaliando o modelo
	SVM.eval <- evaluate(p= teste[teste[,"pb"]==1, -c(1:3)], a= teste[teste[,"pb"]==0, -c(1:3)], model= SVM.model)
	
	#encontrando threshold
	SVM.thr <- threshold(SVM.eval)
	




######
## GLM
	
	#ajustando o modelo
	GLM.model <- glm(pb ~ bio.1+bio.2+bio.3+bio.16+bio.17, family= binomial(link="logit"), data= treino)
	
	#fazendo predicoes
	GLM0k <- predict(clima0k.r, GLM.model)
	GLM21k <- predict(clima21k.r, GLM.model)
	GLMrcp45 <- predict(climarcp45.r, GLM.model)
	
	#avaliando o modelo
	GLM.eval <- evaluate(p= teste[teste[,"pb"]==1, -c(1:3)], a= teste[teste[,"pb"]==0, -c(1:3)], model= GLM.model)
	
	#encontrando threshold
	GLM.thr <- threshold(GLM.eval)
	





######
## Maxent

#   MaxEnt is available as a standalone Java program. Dismo has a function 'maxent' that communicates with this program. To use it you must first download the program from http://www.cs.princeton.edu/~schapire/maxent/. Put the le 'maxent.jar' in the 'java' folder of the 'dismo' package. That is the folder returned by system.file("java", package="dismo"). You need MaxEnt version 3.3.3b or higher.

# checking if the jar file is present. If not, skip this bit
# 	jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')
#	 file.exists(jar)
	
	
	
	#ajustando o modelo
	Sys.setenv(NOAWT=TRUE)
	Maxent.model <- maxent(treino[,-c(1:3)], treino[,"pb"])
	
	#fazendo predicoes
	Maxent0k <- predict(clima0k.r, Maxent.model)
	Maxent21k <- predict(clima21k.r, Maxent.model)
	Maxentrcp45 <- predict(climarcp45.r, Maxent.model)
	
	#avaliando o modelo
	Maxent.eval <- evaluate(p= teste[teste[,"pb"]==1, -c(1:3)], a= teste[teste[,"pb"]==0, -c(1:3)], model= Maxent.model)
	
	#encontrando threshold
	Maxent.thr <- threshold(Maxent.eval)
	
	

# salvando outputs particiais a cada loop 'i' cross-validation

Bioclim.Pout0k <- cbind(Bioclim.Pout0k, values(Bioclim0k))
Gower.Pout0k <- cbind(Gower.Pout0k, values(Gower0k))
SVM.Pout0k <- cbind(SVM.Pout0k, values(SVM0k))
GLM.Pout0k <- cbind(GLM.Pout0k, values(GLM0k))
Maxent.Pout0k <- cbind(Maxent.Pout0k, values(Maxent0k))

Bioclim.Pout21k <- cbind(Bioclim.Pout21k, values(Bioclim21k))
Gower.Pout21k <- cbind(Gower.Pout21k, values(Gower21k))
SVM.Pout21k <- cbind(SVM.Pout21k, values(SVM21k))
GLM.Pout21k <- cbind(GLM.Pout21k, values(GLM21k))
Maxent.Pout21k <- cbind(Maxent.Pout21k, values(Maxent21k))

Bioclim.Poutrcp45 <- cbind(Bioclim.Poutrcp45, values(Bioclimrcp45))
Gower.Poutrcp45 <- cbind(Gower.Poutrcp45, values(Gowerrcp45))
SVM.Poutrcp45 <- cbind(SVM.Poutrcp45, values(SVMrcp45))
GLM.Poutrcp45 <- cbind(GLM.Poutrcp45, values(GLMrcp45))
Maxent.Poutrcp45 <- cbind(Maxent.Poutrcp45, values(Maxentrcp45))


} #fecha for 'i' - cross-validation




#calculando as medias dos modelos parciais cross-validation

Bioclim.Pout0k.mean <- apply(Bioclim.Pout0k, 1, mean)
Gower.Pout0k.mean <- apply(Gower.Pout0k, 1, mean)
SVM.Pout0k.mean <- apply(SVM.Pout0k, 1, mean)
GLM.Pout0k.mean <- apply(GLM.Pout0k, 1, mean)
Maxent.Pout0k.mean <- apply(Maxent.Pout0k, 1, mean)

Bioclim.Pout21k.mean <- apply(Bioclim.Pout21k, 1, mean)
Gower.Pout21k.mean <- apply(Gower.Pout21k, 1, mean)
SVM.Pout21k.mean <- apply(SVM.Pout21k, 1, mean)
GLM.Pout21k.mean <- apply(GLM.Pout21k, 1, mean)
Maxent.Pout21k.mean <- apply(Maxent.Pout21k, 1, mean)

Bioclim.Poutrcp45.mean <- apply(Bioclim.Poutrcp45, 1, mean)
Gower.Poutrcp45.mean <- apply(Gower.Poutrcp45, 1, mean)
SVM.Poutrcp45.mean <- apply(SVM.Poutrcp45, 1, mean)
GLM.Poutrcp45.mean <- apply(GLM.Poutrcp45, 1, mean)
Maxent.Poutrcp45.mean <- apply(Maxent.Poutrcp45, 1, mean)



Output0k <- cbind(Bioclim= Bioclim.Pout0k.mean, Gower= Gower.Pout0k.mean, SVM= SVM.Pout0k.mean, GLM= GLM.Pout0k.mean, Maxent= Maxent.Pout0k.mean)
Output21k <- cbind(Bioclim= Bioclim.Pout21k.mean, Gower= Gower.Pout21k.mean, SVM= SVM.Pout21k.mean, GLM= GLM.Pout21k.mean, Maxent= Maxent.Pout21k.mean)
Outputrcp45 <- cbind(Bioclim= Bioclim.Poutrcp45.mean, Gower= Gower.Poutrcp45.mean, SVM= SVM.Poutrcp45.mean, GLM= GLM.Poutrcp45.mean, Maxent= Maxent.Poutrcp45.mean)






