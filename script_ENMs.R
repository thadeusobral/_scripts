#############SCRIPT PARA GERAR MODELOS DE NICHO ECOLOGICO #########


#INSTALANDO OS PACOTES NECESSARIOS####
rm(list=ls())


library('raster')
library('dismo')
library('gam')
library('randomForest')
library('kernlab')
library('rJava')


AOGCM <- 'WC'


####CAMADAS DE CLIMA###
setwd('C:/Users/Thadeu Sobral/Documents/Modelos/Modelo_zikani/Mikania/modelos')
env.stack.0k <- stack("alt_MA_SM.asc", "bio_7_MA_SM.asc", "bio_10_MA_SM.asc", "bio_17_MA_SM.asc", "bio_18_MA_SM.asc"); names(env.stack.0k) <- c('alt', 'bio7', 'bio10', 'bio17', 'bio18')

##Extraindo os valores de cada Célula e colocando as coordenadas##
id.na <- na.omit(cbind(1:ncell(env.stack.0k), values(env.stack.0k)[,1]))
coords <- xyFromCell(env.stack.0k, id.na[,1])
colnames(coords) <- c('long','lat')

#pontos de Presença da espécies, fóssil, etc###
pr.points <- read.table('Mikania_filtered.txt', h=T)

for(i in 1:length(levels(pr.points[,1]))){

eval.Bioclim <- NULL
eval.Gower <- NULL
eval.Maha <- NULL
eval.Maxent <- NULL
eval.SVM <- NULL

eval.names <- NULL

#Selecionando presença e ausência da espécie#
	id.specie <- levels(pr.points[,1])[i]
	pr.specie <- pr.points[which(pr.points[,1] == id.specie), 2:3]
	id.background <- sample(nrow(coords), nrow(pr.specie))
	bc.specie <- coords[id.background,]
	

for(r in 1:20){	
##preparando os modelos!!
#data	treino e teste!!!	
	pr.sample.train <- sample(nrow(pr.specie), round(0.75 * nrow(pr.specie)))
	bc.sample.train <- sample(nrow(bc.specie), round(0.75 * nrow(bc.specie)))
	test <- na.omit(prepareData(x= env.stack.0k, p= pr.specie[-pr.sample.train,], b= bc.specie[-bc.sample.train,]))
	train <- na.omit(prepareData(x= env.stack.0k, p= pr.specie[pr.sample.train,], b= bc.specie[bc.sample.train,]))

  
  #######ALGORITMOS
##Bioclim	
	Bioclim <- bioclim(train[which(train[,1]==1), -1])	
	
	writeRaster(predict(env.stack.0k, Bioclim), paste(AOGCM, '_Bioclim_0k_', id.specie, r, ".asc", sep=""), format= "ascii")	

	eBioclim <- evaluate(p= test[test[,1]==1, -1], a= test[test[,1]==0, -1], model= Bioclim)
	idBioclim <- which(eBioclim@t == as.numeric(threshold(eBioclim, 'spec_sens')))
	eval.Bioclim.sp <- c(eBioclim@t[idBioclim], eBioclim@auc, (eBioclim@TPR[idBioclim]+eBioclim@TNR[idBioclim]-1))
	eval.Bioclim <- rbind(eval.Bioclim, eval.Bioclim.sp)


##Gower	
	Gower <- domain(train[which(train[,1]==1), -1])	

  writeRaster(predict(env.stack.0k, Gower), paste(AOGCM, '_Gower_0k_', id.specie, r, ".asc", sep=""), format= "ascii")  

	eGower <- evaluate(p= test[test[,1]==1, -1], a= test[test[,1]==0, -1], model= Gower)
	idGower <- which(eGower@t == as.numeric(threshold(eGower, 'spec_sens')))
	eval.Gower.sp <- c(eGower@t[idGower], eGower@auc, (eGower@TPR[idGower]+eGower@TNR[idGower]-1))
	eval.Gower <- rbind(eval.Gower, eval.Gower.sp)


##Maxent	
	Maxent <- maxent(train[,-1], train[,1])	

  writeRaster(predict(env.stack.0k, Maxent), paste(AOGCM, '_Maxent_0k_', id.specie, r, ".asc", sep=""), format= "ascii")  
 
	eMaxent <- evaluate(p= test[test[,1]==1, -1], a= test[test[,1]==0, -1], model= Maxent)
	idMaxent <- which(eMaxent@t == as.numeric(threshold(eMaxent, 'spec_sens')))
	eval.Maxent.sp <- c(eMaxent@t[idMaxent], eMaxent@auc, (eMaxent@TPR[idMaxent]+eMaxent@TNR[idMaxent]-1))
	eval.Maxent <- rbind(eval.Maxent, eval.Maxent.sp)


##SVM	
	SVM <- ksvm(pb ~ alt+bio7+bio10+bio17+bio18, data= train)	

  writeRaster(predict(env.stack.0k, SVM), paste(AOGCM, '_SVM_0k_', id.specie, r, ".asc", sep=""), format= "ascii")  

	eSVM <- evaluate(p= test[test[,1]==1, -1], a= test[test[,1]==0, -1], model= SVM)
	idSVM <- which(eSVM@t == as.numeric(threshold(eSVM, 'spec_sens')))
	eval.SVM.sp <- c(eSVM@t[idSVM], eSVM@auc, (eSVM@TPR[idSVM]+eSVM@TNR[idSVM]-1))
	eval.SVM <- rbind(eval.SVM, eval.SVM.sp)


	eval.names <- c(eval.names, paste(id.specie, r, sep=""))		
}#ends for'r'

dimnames(eval.Bioclim) <- list(eval.names, c('thrs','AUC','TSS'))
dimnames(eval.Gower) <- list(eval.names, c('thrs','AUC','TSS'))
dimnames(eval.Maxent) <- list(eval.names, c('thrs','AUC','TSS'))
dimnames(eval.SVM) <- list(eval.names, c('thrs','AUC','TSS'))


write.table(eval.Bioclim, paste("zEval_", AOGCM, '_Bioclim_', id.specie, ".txt", sep=""))
write.table(eval.Gower, paste("zEval_", AOGCM, '_Gower_', id.specie, ".txt", sep=""))
write.table(eval.Maxent, paste("zEval_", AOGCM, '_Maxent_', id.specie, ".txt", sep=""))
write.table(eval.SVM, paste("zEval_", AOGCM, '_SVM_', id.specie, ".txt", sep=""))

}#ends for'i'





