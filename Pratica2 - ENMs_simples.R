rm(list=ls())

#leia os pacotes abaixo:

library(sp)
library(raster)
library(dismo)
library(kernlab) # SVM
library(rJava)

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
	
	plot(Bioclim.model)
	response(Bioclim.model)

	#fazendo predicoes
	Bioclim0k <- predict(clima0k.r, Bioclim.model)
	Bioclim21k <- predict(clima21k.r, Bioclim.model)
	Bioclimrcp45 <- predict(climarcp45.r, Bioclim.model)

	par(mfrow=c(2,2))
	plot(Bioclim0k, main= "0k")
	plot(Bioclim21k, main= "21k")
 	plot(Bioclimrcp45, main= "rcp45")
 	
 	par(mfrow=c(1,1))
	plot(Bioclim0k, main= "0k")
	points(treino[treino[,"pb"]==1,"x"], treino[treino[,"pb"]==1,"y"], pch=20)
	
	summary(values(Bioclim0k))
	plot(Bioclim0k > 0.5)
	plot(Bioclim0k > 0.4)
	plot(Bioclim0k > 0.3)
	plot(Bioclim0k > 0.2)
	
	#avaliando o modelo
	Bioclim.eval <- evaluate(p= teste[teste[,"pb"]==1, -c(1:3)], a= teste[teste[,"pb"]==0, -c(1:3)], model= Bioclim.model)
	Bioclim.eval <- evaluate(p= teste[teste[,"pb"]==1, 1:2], a= teste[teste[,"pb"]==0, 1:2], x= clima0k.r, model= Bioclim.model)
	Bioclim.eval <- evaluate(p= extract(Bioclim0k, teste[teste[,"pb"]==1, 1:2]), a= extract(Bioclim0k, teste[teste[,"pb"]==0, 1:2]), model= Bioclim.model)

	
	
	str(Bioclim.eval) #varios resultados
	Bioclim.eval@presence #adequabilidades nos pontos de presenca
	Bioclim.eval@confusion #matriz de confusão tomando cada adequabilidades acima como "threshold"
	
	plot(Bioclim.eval, "ROC")
	plot(Bioclim.eval, "kappa")
	plot(Bioclim.eval, "FPR")
	
	density(Bioclim.eval)
	boxplot(Bioclim.eval, col= c("blue", "red"))
	
	
	#encontrando threshold
	Bioclim.thr <- threshold(Bioclim.eval)
	
	plot(Bioclim0k >= Bioclim.thr$spec_sens)
	plot(Bioclim0k >= Bioclim.thr$no_omission)
	points(treino[treino[,"pb"]==1,"x"], treino[treino[,"pb"]==1,"y"], pch=20)
	



######
## Gower
	
	#ajustando o modelo
	Gower.model <- domain(treino[treino[,"pb"]==1, -c(1:3)])
	
#	plot(Gower.model)
#	response(Gower.model)

	#fazendo predicoes
	Gower0k <- predict(clima0k.r, Gower.model)
	Gower21k <- predict(clima21k.r, Gower.model)
	Gowerrcp45 <- predict(climarcp45.r, Gower.model)

#	par(mfrow=c(2,2))
#	plot(Gower0k, main= "0k")
#	plot(Gower21k, main= "21k")
#	plot(Gowerrcp45, main= "rcp45")
 	
# 	par(mfrow=c(1,1))
#	plot(Gower0k, main= "0k")
#	points(treino[treino[,"pb"]==1,"x"], treino[treino[,"pb"]==1,"y"], pch=20)
	
	
	#avaliando o modelo
	Gower.eval <- evaluate(p= teste[teste[,"pb"]==1, -c(1:3)], a= teste[teste[,"pb"]==0, -c(1:3)], model= Gower.model)
	
#	str(Gower.eval) #varios resultados
#	Gower.eval@presence #adequabilidades nos pontos de presenca
#	Gower.eval@confusion #matriz de confusão tomando cada adequabilidades acima como "threshold"
	
	
	#encontrando threshold
	Gower.thr <- threshold(Gower.eval)
	
#	plot(Gower0k >= Gower.thr$spec_sens)
#	plot(Gower0k >= Gower.thr$no_omission)
#	points(treino[treino[,"pb"]==1,"x"], treino[treino[,"pb"]==1,"y"], pch=20)
	
	




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
	
#	plot(SVM0k >= SVM.thr$spec_sens)




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
	
#	plot(GLM0k >= GLM.thr$spec_sens)
	






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
	
#	plot(Maxent0k >= Maxent.thr$spec_sens)
	






# AUC (uma metrica de ranqueamento)


p= extract(Bioclim0k, teste[teste[,"pb"]==1, 1:2])
a= extract(Bioclim0k, teste[teste[,"pb"]==0, 1:2])

mv <- wilcox.test(p,a)
auc <- as.numeric(mv$statistic)/(length(p)*length(a))
auc

evaluate(p= teste[teste[,"pb"]==1, -c(1:3)], a= teste[teste[,"pb"]==0, -c(1:3)], model= Bioclim.model)

###ensinar calcular AUC. O AUC do dismo (funcao evaluate) é baseado nos dados de teste, nao treino. comparar com o auc calculado pelo maxente na aba da internet.