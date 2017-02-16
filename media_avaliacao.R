setwd('E:/Modelos/Modelo_aranha_bromelia/Psecas chapoda')

aval1 <- read.table('zEval_CCSM_Bioclim_Psecas.txt')
aval2 <-read.table('zEval_CCSM_Gower_Psecas.txt')
aval3 <-read.table('zEval_CCSM_Maha_Psecas.txt')
aval4 <-read.table('zEval_CCSM_Maxent_Psecas.txt')
aval5 <-read.table('zEval_CCSM_SVM_Psecas.txt')

aval <- c ((aval1),(aval2),(aval3), (aval4), (aval5))
aval
write.table(aval, 'zEVal_CCSM_Psecas.txt', sep=" ")


aval1 <- read.table('zEval_CNRM_Bioclim_Psecas.txt')
aval2 <-read.table('zEval_CNRM_Gower_Psecas.txt')
aval3 <-read.table('zEval_CNRM_Maha_Psecas.txt')
aval4 <-read.table('zEval_CNRM_Maxent_Psecas.txt')
aval5 <-read.table('zEval_CNRM_SVM_Psecas.txt')

aval <- c ((aval1),(aval2),(aval3), (aval4), (aval5))

write.table(aval, 'zEVal_CNRM_Psecas.txt', sep=" ")

aval1 <- read.table('zEval_MRI_Bioclim_Psecas.txt')
aval2 <-read.table('zEval_MRI_Gower_Psecas.txt')
aval3 <-read.table('zEval_MRI_Maha_Psecas.txt')
aval4 <-read.table('zEval_MRI_Maxent_Psecas.txt')
aval5 <-read.table('zEval_MRI_SVM_Psecas.txt')


aval <- c ((aval1),(aval2),(aval3), (aval4), (aval5))
aval
write.table(aval, 'zEVal_MRI_Psecas.txt', sep=" ")


aval1 <- read.table('zEval_MIROC_Bioclim_Psecas.txt')
aval2 <-read.table('zEval_MIROC_Gower_Psecas.txt')
aval3 <-read.table('zEval_MIROC_Maha_Psecas.txt')
aval4 <-read.table('zEval_MIROC_Maxent_Psecas.txt')
aval5 <-read.table('zEval_MIROC_SVM_Psecas.txt')


aval <- c ((aval1),(aval2),(aval3), (aval4), (aval5))
aval
write.table(aval, 'zEVal_MIROC_Psecas.txt', sep=" ")

