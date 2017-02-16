##-----------------------------------------------------------
##INICIO DA FUNÇÃO dedo de moça
##-----------------------------------------------------------

dedo_de_moca<-function(data=dados,prop.treino=70,n.aleat=10){
  ##-----------------------------------
  #data<-conjunto de dados
  #prop.treino<-porcentagem dos pontos a ser usado com treino.
  #o deflaut para prop.treino é 70%, mas pode ser modificado
  #se o valor de 70% não for um numero inteiro, este será tranformado em um abaixo.
  #por exemplo: 70% de 99 é 69.3 então 86.1 será 86 e os 30% restantes será 123-86. 30
  #n.aleat<-numero de combinações.
  #o deflaut para n.aleat é 10X, mas pode ser modificado
  ##-----------------------------------
  n.pontos<-nrow(data)
  trein<-as.integer(n.pontos*(prop.treino/100))
  test<-(n.pontos-trein)
  resu.teste<-matrix(0,0,0)#resultado do teste
  resu.treino<-matrix(0,0,0)#resultado do treino
  
  for (i in 1:n.aleat){
    aleat<-sample(n.pontos)
    teste<-data[aleat[1:test],]#extraindo 30% das linhas aleatorizadas para o teste
    teste[,1]<-paste(teste[,1],"_",i,sep="")#dando nome para as espécies do teste
    treino<-data[aleat[(test+1):n.pontos],]#extraindo o restante para o treino
    treino[,1]<-paste(treino[,1],"_",i,sep="")#dando nome para as espécies do treino
    resu.treino<-rbind(resu.treino,treino)
    resu.teste<-rbind(resu.teste,teste)
  }
  resu<-list(treino=resu.treino,teste=resu.teste)
  return(resu)
}

##-----------------------------------------------------------
##FIM DA FUNÇÃO
##-----------------------------------------------------------
x<-read.table(file=choose.files(), head=T)
data<-dedo_de_moca(x)
data$teste#CONJUNTO TESTE
data$treino#CONJUNTO TREINO

##-----------------------------------------------------------
##salvando as matrizes em um arquivo .txt
##-----------------------------------------------------------

#para salvar tire os "#" da frente do "write.table"
write.table(data$treino,file=choose.files(), sep = ",", na = "NA", dec = ".", row.names = TRUE, col.names = TRUE)
write.table(data$teste,file=choose.files(), sep = ",", na = "NA", dec = ".", row.names = TRUE, col.names = TRUE)