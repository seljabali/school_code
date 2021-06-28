#Sami Eljabali
#Stat133 – BQ

#Read In Data
file = file("http://www.stat.berkeley.edu/users/nolan/stat133/data/wirelepWifi.txt")
data = read.table(file,header = TRUE, sep = " ")

AP = data.frame(x=data$x[250:254], y = data$y[250:254])

dist = sqrt((rep(data$x[1:254], 5) - rep(AP$x, rep(254, 5)))^2 + (rep(data$y[1:254], 5) - rep(AP$y, rep(254, 5)))^2)


#Create pWifi, with the distance variable added to it
pWifi = data.frame(x=data$x[1:254], y=data$y[1:254], signal = c(data$S1[1:254], data$S2[1:254], data$S3[1:254],data$S4[1:254],data$S5[1:254]), accessPoint = rep(c(1,2,3,4,5), c(254,254,254,254,254)), client = rep(c(1:254),5), distance)


signal1 = density (pWifi$signal [1:254])
signal2 = density (pWifi$signal [255:508])
signal3 = density (pWifi$signal [509:762])
signal4 = density (pWifi$signal [763:1016])
signal5 = density (pWifi$signal [1017:1270])

#Plot Density Signal Strength
jpeg("Signal Plot.jpg")
plot(signal2)
points(signal1, col="cyan", type="l")
points(signal3, col="purple", type="l")
points(signal4, col="black", type="l")
points(signal5, col="orange", type="l")
dev.off()


#Log of Signal Strength
jpeg("Log Normal.jpg")
qqnorm(log(pWifi$signal + 100))
dev.off()

#Log of the normal distance
jpeg("Log_Distance.jpg")
qqnorm(log(pWifi$distance))
dev.off()

#Distance vs Signal Scatter Plot
jpeg("Distance_vs_Signal_Scatter_Plot.jpg")
plot(pWifi$distance, pWifi$signal, col=c("cyan","blue","red","black","yellow"))
dev.off()

# Log of normal distance vs signal strength scatter plot
jpeg("normal distance vs signal strength.jpg")
plot(pWifi$signal, log(pWifi$distance), col=c("cyan","blue","red","black","yellow"))
dev.off()


#Q)Is the distribution of signal strength roughly the same for the five accepWifi points? And, is it log-normal, i.e. when you look at the log of signal strength, does it’s distribution appear approximately normal?

#We can see that the signal strength is not distributed equally. There are also not log normal. 

#Q)Do these signal strengths follow the properties described above, as being linear in log distance?
#No, observing the log normal plot of the distance we can see that it is not linear. 

#Q)Are there any anomalies in the data?
#No, we can see that the data fits the context, meaning that the signal strength is weaker when the distance increases which can be seen in the plots.