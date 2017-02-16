##############################
#################
########

#####SVM


setwd('C:/Users/Thadeu Sobral/Documents/Modelos/Modelo_zikani/Mikania/modelos')
bc1.0k <- raster('WC_Bioclim_0k_Mikania1.asc')
bc2.0k <- raster('WC_Bioclim_0k_Mikania2.asc')
bc3.0k <- raster('WC_Bioclim_0k_Mikania3.asc')
bc4.0k <- raster('WC_Bioclim_0k_Mikania4.asc')
bc5.0k <- raster('WC_Bioclim_0k_Mikania5.asc')
bc6.0k <- raster('WC_Bioclim_0k_Mikania6.asc')
bc7.0k <- raster('WC_Bioclim_0k_Mikania7.asc')
bc8.0k <- raster('WC_Bioclim_0k_Mikania8.asc')
bc9.0k <- raster('WC_Bioclim_0k_Mikania9.asc')
bc10.0k <- raster('WC_Bioclim_0k_Mikania10.asc')
bc11.0k <- raster('WC_Bioclim_0k_Mikania11.asc')
bc12.0k <- raster('WC_Bioclim_0k_Mikania12.asc')
bc13.0k <- raster('WC_Bioclim_0k_Mikania13.asc')
bc14.0k <- raster('WC_Bioclim_0k_Mikania14.asc')
bc15.0k <- raster('WC_Bioclim_0k_Mikania15.asc')
bc16.0k <- raster('WC_Bioclim_0k_Mikania16.asc')
bc17.0k <- raster('WC_Bioclim_0k_Mikania17.asc')
bc18.0k <- raster('WC_Bioclim_0k_Mikania18.asc')
bc19.0k <- raster('WC_Bioclim_0k_Mikania19.asc')
bc20.0k <- raster('WC_Bioclim_0k_Mikania20.asc')



bc1.21k <- raster('WC_Gower_0k_Mikania1.asc')
bc2.21k <- raster('WC_Gower_0k_Mikania2.asc')
bc3.21k <- raster('WC_Gower_0k_Mikania3.asc')
bc4.21k <- raster('WC_Gower_0k_Mikania4.asc')
bc5.21k <- raster('WC_Gower_0k_Mikania5.asc')
bc6.21k <- raster('WC_Gower_0k_Mikania6.asc')
bc7.21k <- raster('WC_Gower_0k_Mikania7.asc')
bc8.21k <- raster('WC_Gower_0k_Mikania8.asc')
bc9.21k <- raster('WC_Gower_0k_Mikania9.asc')
bc10.21k <- raster('WC_Gower_0k_Mikania10.asc')
bc11.21k <- raster('WC_Gower_0k_Mikania11.asc')
bc12.21k <- raster('WC_Gower_0k_Mikania12.asc')
bc13.21k <- raster('WC_Gower_0k_Mikania13.asc')
bc14.21k <- raster('WC_Gower_0k_Mikania14.asc')
bc15.21k <- raster('WC_Gower_0k_Mikania15.asc')
bc16.21k <- raster('WC_Gower_0k_Mikania16.asc')
bc17.21k <- raster('WC_Gower_0k_Mikania17.asc')
bc18.21k <- raster('WC_Gower_0k_Mikania18.asc')
bc19.21k <- raster('WC_Gower_0k_Mikania19.asc')
bc20.21k <- raster('WC_Gower_0k_Mikania20.asc')

bc1.2050 <- raster('WC_Maxent_0k_Mikania1.asc')
bc2.2050 <- raster('WC_Maxent_0k_Mikania2.asc')
bc3.2050 <- raster('WC_Maxent_0k_Mikania3.asc')
bc4.2050 <- raster('WC_Maxent_0k_Mikania4.asc')
bc5.2050 <- raster('WC_Maxent_0k_Mikania5.asc')
bc6.2050 <- raster('WC_Maxent_0k_Mikania6.asc')
bc7.2050 <- raster('WC_Maxent_0k_Mikania7.asc')
bc8.2050 <- raster('WC_Maxent_0k_Mikania8.asc')
bc9.2050 <- raster('WC_Maxent_0k_Mikania9.asc')
bc10.2050 <- raster('WC_Maxent_0k_Mikania10.asc')
bc11.2050 <- raster('WC_Maxent_0k_Mikania11.asc')
bc12.2050 <- raster('WC_Maxent_0k_Mikania12.asc')
bc13.2050 <- raster('WC_Maxent_0k_Mikania13.asc')
bc14.2050 <- raster('WC_Maxent_0k_Mikania14.asc')
bc15.2050 <- raster('WC_Maxent_0k_Mikania15.asc')
bc16.2050 <- raster('WC_Maxent_0k_Mikania16.asc')
bc17.2050 <- raster('WC_Maxent_0k_Mikania17.asc')
bc18.2050 <- raster('WC_Maxent_0k_Mikania18.asc')
bc19.2050 <- raster('WC_Maxent_0k_Mikania19.asc')
bc20.2050 <- raster('WC_Maxent_0k_Mikania20.asc')

bc1.2070 <- raster('WC_SVM_0k_Mikania1.asc')
bc2.2070 <- raster('WC_SVM_0k_Mikania2.asc')
bc3.2070 <- raster('WC_SVM_0k_Mikania3.asc')
bc4.2070 <- raster('WC_SVM_0k_Mikania4.asc')
bc5.2070 <- raster('WC_SVM_0k_Mikania5.asc')
bc6.2070 <- raster('WC_SVM_0k_Mikania6.asc')
bc7.2070 <- raster('WC_SVM_0k_Mikania7.asc')
bc8.2070 <- raster('WC_SVM_0k_Mikania8.asc')
bc9.2070 <- raster('WC_SVM_0k_Mikania9.asc')
bc10.2070 <- raster('WC_SVM_0k_Mikania10.asc')
bc11.2070 <- raster('WC_SVM_0k_Mikania11.asc')
bc12.2070 <- raster('WC_SVM_0k_Mikania12.asc')
bc13.2070 <- raster('WC_SVM_0k_Mikania13.asc')
bc14.2070 <- raster('WC_SVM_0k_Mikania14.asc')
bc15.2070 <- raster('WC_SVM_0k_Mikania15.asc')
bc16.2070 <- raster('WC_SVM_0k_Mikania16.asc')
bc17.2070 <- raster('WC_SVM_0k_Mikania17.asc')
bc18.2070 <- raster('WC_SVM_0k_Mikania18.asc')
bc19.2070 <- raster('WC_SVM_0k_Mikania19.asc')
bc20.2070 <- raster('WC_SVM_0k_Mikania20.asc')

eval.bc <- read.table('zEval_WC_SVM_Mikania.txt')
eval.bc1 <- read.table('zEval_WC_Gower_Mikania.txt')
eval.bc2 <- read.table('zEval_WC_Maxent_Mikania.txt')
eval.bc3 <- read.table('zEval_WC_SVM_Mikania.txt')

bc.sum0k <- sum(bc1.0k >= eval.bc[1,1], 
bc2.0k >= eval.bc[2,1],
bc3.0k >= eval.bc[3,1],
bc4.0k >= eval.bc[4,1],
bc5.0k >= eval.bc[5,1],
bc6.0k >= eval.bc[6,1],
bc7.0k >= eval.bc[7,1],
bc8.0k >= eval.bc[8,1],
bc9.0k >= eval.bc[9,1],
bc10.0k >= eval.bc[10,1],
bc11.0k >= eval.bc[11,1],
bc12.0k >= eval.bc[12,1],
bc13.0k >= eval.bc[13,1],
bc14.0k >= eval.bc[14,1],
bc15.0k >= eval.bc[15,1],
bc16.0k >= eval.bc[16,1],
bc17.0k >= eval.bc[17,1],
bc18.0k >= eval.bc[18,1],
bc19.0k >= eval.bc[19,1],
bc20.0k >= eval.bc[20,1])


par(mfrow=c(1,2))
plot(bc.sum0k)

writeRaster(bc.sum0k, 'WC_Mikania_Bioclim.asc', format= 'ascii')



bc.sum21k <- sum(bc1.21k >= eval.bc1[1,1], 
bc2.21k >= eval.bc1[2,1],
bc3.21k >= eval.bc1[3,1],
bc4.21k >= eval.bc1[4,1],
bc5.21k >= eval.bc1[5,1],
bc6.21k >= eval.bc1[6,1],
bc7.21k >= eval.bc1[7,1],
bc8.21k >= eval.bc1[8,1],
bc9.21k >= eval.bc1[9,1],
bc10.21k >= eval.bc1[10,1],
bc11.21k >= eval.bc1[11,1],
bc12.21k >= eval.bc1[12,1],
bc13.21k >= eval.bc1[13,1],
bc14.21k >= eval.bc1[14,1],
bc15.21k >= eval.bc1[15,1],
bc16.21k >= eval.bc1[16,1],
bc17.21k >= eval.bc1[17,1],
bc18.21k >= eval.bc1[18,1],
bc19.21k >= eval.bc1[19,1],
bc20.21k >= eval.bc1[20,1])

plot(bc.sum21k)
writeRaster(bc.sum21k, 'WC_Gower_Mikania.asc', format= 'ascii')

bc.sum2050 <- sum(bc1.2050 >= eval.bc2[1,1], 
                 bc2.2050 >= eval.bc2[2,1],
                 bc3.2050 >= eval.bc2[3,1],
                 bc4.2050 >= eval.bc2[4,1],
                 bc5.2050 >= eval.bc2[5,1],
                 bc6.2050 >= eval.bc2[6,1],
                 bc7.2050 >= eval.bc2[7,1],
                 bc8.2050 >= eval.bc2[8,1],
                 bc9.2050 >= eval.bc2[9,1],
                 bc10.2050 >= eval.bc2[10,1],
                 bc11.2050 >= eval.bc2[11,1],
                 bc12.2050 >= eval.bc2[12,1],
                 bc13.2050 >= eval.bc2[13,1],
                 bc14.2050 >= eval.bc2[14,1],
                 bc15.2050 >= eval.bc2[15,1],
                 bc16.2050 >= eval.bc2[16,1],
                 bc17.2050 >= eval.bc2[17,1],
                 bc18.2050 >= eval.bc2[18,1],
                 bc19.2050 >= eval.bc2[19,1],
                 bc20.2050 >= eval.bc2[20,1])

plot(bc.sum2050)
writeRaster(bc.sum2050, 'WC_Maxent_Mikania.asc', format= 'ascii')

bc.sum2070 <- sum(bc1.2070 >= eval.bc3[1,1], 
                  bc2.2070 >= eval.bc3[2,1],
                  bc3.2070 >= eval.bc3[3,1],
                  bc4.2070 >= eval.bc3[4,1],
                  bc5.2070 >= eval.bc3[5,1],
                  bc6.2070 >= eval.bc3[6,1],
                  bc7.2070 >= eval.bc3[7,1],
                  bc8.2070 >= eval.bc3[8,1],
                  bc9.2070 >= eval.bc3[9,1],
                  bc10.2070 >= eval.bc3[10,1],
                  bc11.2070 >= eval.bc3[11,1],
                  bc12.2070 >= eval.bc3[12,1],
                  bc13.2070 >= eval.bc3[13,1],
                  bc14.2070 >= eval.bc3[14,1],
                  bc15.2070 >= eval.bc3[15,1],
                  bc16.2070 >= eval.bc3[16,1],
                  bc17.2070 >= eval.bc3[17,1],
                  bc18.2070 >= eval.bc3[18,1],
                  bc19.2070 >= eval.bc3[19,1],
                  bc20.2070 >= eval.bc3[20,1])
plot(bc.sum2070)
writeRaster(bc.sum2070, 'WC_SVM_Mikania.asc', format= 'ascii')


###CONCATENANDO##

##0K


bcall.0k <- raster('WC_Mikania_Bioclim.asc')
bcall1.0k <- raster('WC_Gower_Mikania.asc')
bcall3.0k <- raster('WC_Maxent_Mikania.asc')
bcall4.0k <- raster('WC_SVM_Mikania.asc')

bc.all.sum <- bcall.0k + bcall1.0k + bcall3.0k + bcall4.0k

plot(bc.all.sum)
writeRaster(bc.all.sum, 'Mikania_ensemble.asc', format= 'ascii')

# 2050_CCSM

bcal.0k <- raster('WC_Bioclim_2050_ccsm.asc')
bcal1.0k <- raster('WC_Gower_2050_ccsm.asc')
bcal2.0k <- raster('WC_Maha_2050_ccsm.asc')
bcal3.0k <- raster('WC_Maxent_2050_ccsm.asc')
bcal4.0k <- raster('WC_SVM_2050_ccsm.asc')

bc.al.sum <- bcal.0k + bcal1.0k + bcal2.0k + bcal3.0k + bcal4.0k

plot(bc.al.sum)
writeRaster(bc.al.sum, 'WC_all_2050_ccsm.asc', format= 'ascii')

#2050_miroc

bca.0k <- raster('WC_Bioclim_2050_miroc.asc')
bca1.0k <- raster('WC_Gower_2050_miroc.asc')
bca2.0k <- raster('WC_Maha_2050_miroc.asc')
bca3.0k <- raster('WC_Maxent_2050_miroc.asc')
bca4.0k <- raster('WC_SVM_2050_miroc.asc')

bc.a.sum <- bca.0k + bca1.0k + bca2.0k + bca3.0k + bca4.0k

plot(bc.a.sum)
writeRaster(bc.a.sum, 'WC_all_2050_miroc.asc', format= 'ascii')

#2070_CCSM
bc.0k <- raster('WC_Bioclim_2070_ccsm.asc')
bc1.0k <- raster('WC_Gower_2070_ccsm.asc')
bc2.0k <- raster('WC_Maha_2070_ccsm.asc')
bc3.0k <- raster('WC_Maxent_2070_ccsm.asc')
bc4.0k <- raster('WC_SVM_2070_ccsm.asc')

bc.sum <- bc.0k + bc1.0k + bc2.0k + bc3.0k + bc4.0k

plot(bc.sum)
writeRaster(bc.sum, 'WC_all_2070_ccsm.asc', format= 'ascii')

#2070_Miroc
b.0k <- raster('WC_Bioclim_2070_miroc.asc')
b1.0k <- raster('WC_Gower_2070_miroc.asc')
b2.0k <- raster('WC_Maha_2070_miroc.asc')
b3.0k <- raster('WC_Maxent_2070_miroc.asc')
b4.0k <- raster('WC_SVM_2070_miroc.asc')

b.sum <- b.0k + b1.0k + b2.0k + b3.0k + b4.0k
plot(b.sum)
writeRaster(b.sum, 'WC_all_2070_miroc.asc', format= 'ascii')
