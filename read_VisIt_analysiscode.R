# Clears any previous data
rm(list=ls())

#This is a new comment.
project<-c("dynamic_suction")
morph<- "branched"

Wo<-c(15)
freq<-c(1.0)
dia<-c(0.1)

s1<-morph
s2<- paste("Wo",Wo,sep="")

#Creates working directory
working<-paste("/Volumes/LaCie_New/IBAMR/",project,"/",morph,"/",morph,"_",Wo," 1/graphs",sep="")

# Sets working directory
setwd(working)

# Displays the current working directory.
getwd()


###### AVERAGE SPEED ######

base1<-"Uavg_left.curve"
base1<-paste(s1, s2, base1, sep = "_")
#Reads in data from the ".curve" files produced by VisIt.
data1 <- read.table(base1, header=FALSE, sep="")
summary(data1)

base2<-"Uavg_right.curve"
base2<-paste(s1, s2, base2, sep = "_")
#Reads in data from the ".curve" files produced by VisIt.
data2 <- read.table(base2, header=FALSE, sep="")
summary(data2)

var1<-"Non-dimensional average speed" #Change the variable name here to automatically plot it. 
#Makes a basic line plot of the data in the VisIt curve file.
name1<-"Uavg_"
name2<-".eps"
nameit<-paste(name1,s1,s2,name2,sep="")
setEPS()
postscript(nameit,width=6, height=4.5)
plot(V2/dia~V1,data=data1,type="l",col="red",
xlab=list("Non-dimensional time",cex=1),ylab=list(var1,cex=1),ylim=c(min(data1$V2/dia),max(data1$V2/dia)))
lines(V2/dia~V1,data=data2,type="l",col="blue")
legend("topleft",legend=c("Left","Right"),col=c("red","blue"),lty=c(1,1))
dev.off()


###### X-COMPONENT VELOCITY ######

base21<-"Uxavg_left.curve"
base21<-paste(s1, s2, base21, sep = "_")
#Reads in data from the ".curve" files produced by VisIt.
data21 <- read.table(base21, header=FALSE, sep="")
summary(data21)

base22<-"Uxavg_right.curve"
base22<-paste(s1, s2, base22, sep = "_")
#Reads in data from the ".curve" files produced by VisIt.
data22 <- read.table(base22, header=FALSE, sep="")
summary(data22)

var2<-"Non-dimensional X-component velocity" #Change the variable name here to automatically plot it. 
#Makes a basic line plot of the data in the VisIt curve file.
name1<-"Uxavg_"
name2<-".eps"
nameit<-paste(name1,s1,s2,name2,sep="")
setEPS()
postscript(nameit,width=6, height=4.5)
plot(V2/dia~V1,data=data21,type="l",col="red",
     xlab=list("Non-dimensional time",cex=1),ylab=list(var2,cex=1),ylim=c(min(data21$V2/dia),max(data21$V2/dia)))
lines(V2/dia~V1,data=data22,type="l",col="blue")
legend("topleft",legend=c("Left","Right"),col=c("red","blue"),lty=c(1,1))
dev.off()

#### Find Means #### 

left_Uavg_mean<-mean(data1$V2/dia)
right_Uavg_mean<-mean(data2$V2/dia)

left_Uxavg_mean<-mean(data21$V2/dia)
right_Uxavg_mean<-mean(data22$V2/dia)

#### Report Means ####

left_Uavg_mean #Non-dimensional Average Speed
right_Uavg_mean #Non-dimensional Average Speed
left_Uxavg_mean #Non-dimensional X-component Velocity
right_Uxavg_mean #Non-dimensional X-component Velocity

###########################################################
###########################################################
###########################################################

# Other things not finished...

###### POINT SPEED ######

base<-"point_Um.curve"
base31<-paste(s1, base, sep = "_")
base<-"point_Ux.curve"
base32<-paste(s1, base, sep = "_")
#Reads in data from the ".curve" files produced by VisIt.
data31 <- read.table(base31, header=FALSE, sep="")
summary(data31)
data32 <- read.table(base32, header=FALSE, sep="")
summary(data32)

var3<-"Speed (m/s)" #Change the variable name here to automatically plot it. 
#Makes a basic line plot of the data in the VisIt curve file.
name1<-"point_speed_"
name2<-".eps"
nameit<-paste(name1,s1,name2,sep="")
setEPS()
postscript(nameit,width=6, height=4.5)
plot(V2~V1,data=data31,type="l",col="red",
xlab=list("Time (s)",cex=1),ylab=list(var3,cex=1),ylim=c(min(data32$V2),max(data31$V2)))
lines(V2~V1,data=data32,col="blue")
legend("bottomright",legend=c(base31,base32),col=c("red","blue"),lty=c(1,1))
dev.off()



#### Pressure #####

base<-"aorta_avgp.curve"
base41<-paste(s1, base, sep = "_")
base<-"vc_avgp.curve"
base42<-paste(s1, base, sep = "_")
data41 <- read.table(base41, header=FALSE, sep="")
summary(data41)
data42 <- read.table(base42, header=FALSE, sep="")
summary(data42)

diff<-data41$V2-data42$V2

var4<-"Pressure (Pa)" #Change the variable name here to automatically plot it. 
#Makes a basic line plot of the data in the VisIt curve file.
name1<-"pressure_"
name2<-".eps"
nameit<-paste(name1,s1,name2,sep="")
setEPS()
postscript(nameit,width=6, height=4.5)
plot(V2~V1,data=data41,type="l",col="red",
xlab=list("Time (s)",cex=1),ylab=list(var4,cex=1),ylim=c(min(data42$V2),max(data41$V2)))
lines(V2~V1,data=data42,col="blue")
legend("bottomright",legend=c(base41,base42),col=c("red","blue"),lty=c(1,1))
dev.off()


var5<-"Pressure difference (Pa)" #Change the variable name here to automatically plot it. 
#Makes a basic line plot of the data in the VisIt curve file.
name1<-"pdiff_"
name2<-".eps"
nameit<-paste(name1,s1,name2,sep="")
setEPS()
postscript(nameit,width=6, height=4.5)

plot(data41$V1,diff,type="l",col="red",
xlab=list("Time (s)",cex=1),ylab=list(var5,cex=1),ylim=c(min(diff),max(diff)))

dev.off()



