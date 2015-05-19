# This Script is using ggmap: google map apis for data visualization 
# Written by pmutyala@ca.ibm.com
# data used is from https://data.cityofnewyork.us/Public-Safety/NYPD-Motor-Vehicle-Collisions/h9gi-nx95?

library(ibmdbR) # IBM R package for in db analytics
library(ggmap) # google map api
library(ggplot2) # grammar of graphics plots pakage


con <- idaConnect("bludb")
idaInit(con)
idaShowTables(showAll = FALSE)
df <- ida.data.frame('PMUTYALA.COLLISIONS')
borough <- idaQuery("select distinct BOROUGH from PMUTYALA.COLLISIONS")
print(borough)


######################## Bronx Collisions for Year 2015#######################################
collisions_bronx <- idaQuery('SELECT substr("DATE",1,4) as "YEAR","TIME","BOROUGH","ZIP_CODE","LATITUDE","LONGITUDE","ON_STREET_NAME","CROSS_STREET_NAME","OFF_STREET_NAME","NUMBER_OF_PERSONS_INJURED","NUMBER_OF_PERSONS_KILLED","NUMBER_OF_PEDESTRIANS_INJURED","NUMBER_OF_PEDESTRIANS_KILLED","NUMBER_OF_CYCLIST_INJURED","NUMBER_OF_CYCLIST_KILLED","NUMBER_OF_MOTORIST_INJURED","NUMBER_OF_MOTORIST_KILLED","CONTRIBUTING_FACTOR_VEHICLE_1","CONTRIBUTING_FACTOR_VEHICLE_2","CONTRIBUTING_FACTOR_VEHICLE_3","CONTRIBUTING_FACTOR_VEHICLE_4","CONTRIBUTING_FACTOR_VEHICLE_5","UNIQUE_KEY","VEHICLE_TYPE_CODE_1","VEHICLE_TYPE_CODE_2","VEHICLE_TYPE_CODE_3","VEHICLE_TYPE_CODE_4","VEHICLE_TYPE_CODE_5","STATE" FROM PMUTYALA.COLLISIONS WHERE "BOROUGH" = \'BRONX\' AND "ON_STREET_NAME" <> \'\'')
year <- collisions_bronx$YEAR
long <- as.numeric(collisions_bronx$LONGITUDE)
lat <- as.numeric(collisions_bronx$LATITUDE)
street_name <- collisions_bronx$ON_STREET_NAME
data_bronx <- data.frame(year,long,lat,street_name)
tab_bronx<-data.frame(table(data_bronx$street_name))
d_merge_bronx <- merge(x=data_bronx,y=tab_bronx,by.x=c('street_name'),by.y=c('Var1'))
d_merge_bronx$freqPerc <- round((d_merge_bronx$Freq/length(data_bronx$street_name))*1000,digits=0)
d_merge_bronx$freqPerc <- ifelse(d_merge_bronx$freqPerc==0,1,d_merge_bronx$freqPerc)
pallette <- colorRampPalette(c('white','red'))
colors <- pallette(max(d_merge_bronx$freqPerc))
bronx_plot <- ggmap(get_map('New York, New York, The Bronx',zoom=12,maptype = c("roadmap"),color = c("color"),crop = TRUE))
plot_bronx_collisions <- bronx_plot+ geom_path(data=d_merge_bronx,size=1,aes(x=d_merge_bronx$long, y=d_merge_bronx$lat,group=d_merge_bronx$street_name),col=colors[d_merge_bronx$freqPerc]) + ggtitle("Bronx Collisions frequency Percentage across Streets for Year 2015")
plot_bronx_collisions


############### Manhattan Collisions in 2015 ##################################################

collisions_man <- idaQuery('SELECT substr("DATE",1,4) as "YEAR","TIME","BOROUGH","ZIP_CODE","LATITUDE","LONGITUDE","ON_STREET_NAME","CROSS_STREET_NAME","OFF_STREET_NAME","NUMBER_OF_PERSONS_INJURED","NUMBER_OF_PERSONS_KILLED","NUMBER_OF_PEDESTRIANS_INJURED","NUMBER_OF_PEDESTRIANS_KILLED","NUMBER_OF_CYCLIST_INJURED","NUMBER_OF_CYCLIST_KILLED","NUMBER_OF_MOTORIST_INJURED","NUMBER_OF_MOTORIST_KILLED","CONTRIBUTING_FACTOR_VEHICLE_1","CONTRIBUTING_FACTOR_VEHICLE_2","CONTRIBUTING_FACTOR_VEHICLE_3","CONTRIBUTING_FACTOR_VEHICLE_4","CONTRIBUTING_FACTOR_VEHICLE_5","UNIQUE_KEY","VEHICLE_TYPE_CODE_1","VEHICLE_TYPE_CODE_2","VEHICLE_TYPE_CODE_3","VEHICLE_TYPE_CODE_4","VEHICLE_TYPE_CODE_5","STATE" FROM PMUTYALA.COLLISIONS WHERE "BOROUGH" = \'MANHATTAN\' AND "ON_STREET_NAME" <> \'\'')
year <- collisions_man$YEAR
long <- as.numeric(collisions_man$LONGITUDE)
lat <- as.numeric(collisions_man$LATITUDE)
street_name <- collisions_man$ON_STREET_NAME
data_man <- data.frame(year,long,lat,street_name)
tab_man<-data.frame(table(data_man$street_name))
d_merge_man <- merge(x=data_man,y=tab_man,by.x=c('street_name'),by.y=c('Var1'))
d_merge_man$freqPerc <- round((d_merge_man$Freq/length(data_man$street_name))*1000,digits=0)
d_merge_man$freqPerc <- ifelse(d_merge_man$freqPerc==0,1,d_merge_man$freqPerc)
pallette <- colorRampPalette(c('white','darkgreen'))
colors <- pallette(max(d_merge_man$freqPerc))
man_plot <- ggmap(get_map('New York, New York, Manhattan',zoom=12,maptype = c("roadmap"),color = c("color"),crop = TRUE))
plot_man_collisions <- man_plot+ geom_path(data=d_merge_man,size=1,aes(x=d_merge_man$long, y=d_merge_man$lat,group=d_merge_man$street_name),col=colors[d_merge_man$freqPerc]) + ggtitle("Manhanttan Collisions frequency Percentage across streets for Year 2015")
plot_man_collisions

########################## Queens Collisions in 2015 ##########################################

collisions_queens <- idaQuery('SELECT substr("DATE",1,4) as "YEAR","TIME","BOROUGH","ZIP_CODE","LATITUDE","LONGITUDE","ON_STREET_NAME","CROSS_STREET_NAME","OFF_STREET_NAME","NUMBER_OF_PERSONS_INJURED","NUMBER_OF_PERSONS_KILLED","NUMBER_OF_PEDESTRIANS_INJURED","NUMBER_OF_PEDESTRIANS_KILLED","NUMBER_OF_CYCLIST_INJURED","NUMBER_OF_CYCLIST_KILLED","NUMBER_OF_MOTORIST_INJURED","NUMBER_OF_MOTORIST_KILLED","CONTRIBUTING_FACTOR_VEHICLE_1","CONTRIBUTING_FACTOR_VEHICLE_2","CONTRIBUTING_FACTOR_VEHICLE_3","CONTRIBUTING_FACTOR_VEHICLE_4","CONTRIBUTING_FACTOR_VEHICLE_5","UNIQUE_KEY","VEHICLE_TYPE_CODE_1","VEHICLE_TYPE_CODE_2","VEHICLE_TYPE_CODE_3","VEHICLE_TYPE_CODE_4","VEHICLE_TYPE_CODE_5","STATE" FROM PMUTYALA.COLLISIONS WHERE "BOROUGH" = \'QUEENS\' AND "ON_STREET_NAME" <> \'\'')
year <- collisions_queens$YEAR
long <- as.numeric(collisions_queens$LONGITUDE)
lat <- as.numeric(collisions_queens$LATITUDE)
street_name <- collisions_queens$ON_STREET_NAME
data_queens <- data.frame(year,long,lat,street_name)
tab_queens<-data.frame(table(data_queens$street_name))
d_merge_queens <- merge(x=data_queens,y=tab_queens,by.x=c('street_name'),by.y=c('Var1'))
d_merge_queens$freqPerc <- round((d_merge_queens$Freq/length(data_queens$street_name))*1000,digits=0)
d_merge_queens$freqPerc <- ifelse(d_merge_queens$freqPerc==0,1,d_merge_queens$freqPerc)
pallette <- colorRampPalette(c('white','darkorange'))
colors <- pallette(max(d_merge_queens$freqPerc))
queens_plot <- ggmap(get_map('New York, New York, Queens',zoom=12,maptype = c("roadmap"),color = c("color"),crop = TRUE))
plot_queens_collisions <- queens_plot+ geom_path(data=d_merge_queens,size=1,aes(x=d_merge_queens$long, y=d_merge_queens$lat,group=d_merge_queens$street_name),col=colors[d_merge_queens$freqPerc]) + ggtitle("Queens Collisions frequency Percentage across streets for Year 2015")
plot_queens_collisions


########################## STATEN ISLAND Collisions in 2015 ##########################################

collisions_si <- idaQuery('SELECT substr("DATE",1,4) as "YEAR","TIME","BOROUGH","ZIP_CODE","LATITUDE","LONGITUDE","ON_STREET_NAME","CROSS_STREET_NAME","OFF_STREET_NAME","NUMBER_OF_PERSONS_INJURED","NUMBER_OF_PERSONS_KILLED","NUMBER_OF_PEDESTRIANS_INJURED","NUMBER_OF_PEDESTRIANS_KILLED","NUMBER_OF_CYCLIST_INJURED","NUMBER_OF_CYCLIST_KILLED","NUMBER_OF_MOTORIST_INJURED","NUMBER_OF_MOTORIST_KILLED","CONTRIBUTING_FACTOR_VEHICLE_1","CONTRIBUTING_FACTOR_VEHICLE_2","CONTRIBUTING_FACTOR_VEHICLE_3","CONTRIBUTING_FACTOR_VEHICLE_4","CONTRIBUTING_FACTOR_VEHICLE_5","UNIQUE_KEY","VEHICLE_TYPE_CODE_1","VEHICLE_TYPE_CODE_2","VEHICLE_TYPE_CODE_3","VEHICLE_TYPE_CODE_4","VEHICLE_TYPE_CODE_5","STATE" FROM PMUTYALA.COLLISIONS WHERE "BOROUGH" = \'STATEN ISLAND\' AND "ON_STREET_NAME" <> \'\'')
year <- collisions_si$YEAR
long <- as.numeric(collisions_si$LONGITUDE)
lat <- as.numeric(collisions_si$LATITUDE)
street_name <- collisions_si$ON_STREET_NAME
data_si <- data.frame(year,long,lat,street_name)
tab_si<-data.frame(table(data_si$street_name))
d_merge_si <- merge(x=data_si,y=tab_si,by.x=c('street_name'),by.y=c('Var1'))
d_merge_si$freqPerc <- round((d_merge_si$Freq/length(data_si$street_name))*1000,digits=0)
d_merge_si$freqPerc <- ifelse(d_merge_si$freqPerc==0,1,d_merge_si$freqPerc)
pallette <- colorRampPalette(c('white','darkviolet'))
colors <- pallette(max(d_merge_si$freqPerc))
si_plot <- ggmap(get_map('New York, New York, Staten Island',zoom=12,maptype = c("roadmap"),color = c("color"),crop = TRUE))
plot_si_collisions <- si_plot+ geom_path(data=d_merge_si,size=1,aes(x=d_merge_si$long, y=d_merge_si$lat,group=d_merge_si$street_name),col=colors[d_merge_si$freqPerc]) + ggtitle("Staten Island Collisions frequency Percentage across streets for Year 2015")
plot_si_collisions



########################## Brooklyn Collisions in 2015 ##########################################

collisions_brooklyn <- idaQuery('SELECT substr("DATE",1,4) as "YEAR","TIME","BOROUGH","ZIP_CODE","LATITUDE","LONGITUDE","ON_STREET_NAME","CROSS_STREET_NAME","OFF_STREET_NAME","NUMBER_OF_PERSONS_INJURED","NUMBER_OF_PERSONS_KILLED","NUMBER_OF_PEDESTRIANS_INJURED","NUMBER_OF_PEDESTRIANS_KILLED","NUMBER_OF_CYCLIST_INJURED","NUMBER_OF_CYCLIST_KILLED","NUMBER_OF_MOTORIST_INJURED","NUMBER_OF_MOTORIST_KILLED","CONTRIBUTING_FACTOR_VEHICLE_1","CONTRIBUTING_FACTOR_VEHICLE_2","CONTRIBUTING_FACTOR_VEHICLE_3","CONTRIBUTING_FACTOR_VEHICLE_4","CONTRIBUTING_FACTOR_VEHICLE_5","UNIQUE_KEY","VEHICLE_TYPE_CODE_1","VEHICLE_TYPE_CODE_2","VEHICLE_TYPE_CODE_3","VEHICLE_TYPE_CODE_4","VEHICLE_TYPE_CODE_5","STATE" FROM PMUTYALA.COLLISIONS WHERE "BOROUGH" = \'BROOKLYN\' AND "ON_STREET_NAME" <> \'\'')
year <- collisions_brooklyn$YEAR
long <- as.numeric(collisions_brooklyn$LONGITUDE)
lat <- as.numeric(collisions_brooklyn$LATITUDE)
street_name <- collisions_brooklyn$ON_STREET_NAME
data_brooklyn <- data.frame(year,long,lat,street_name)
tab_brooklyn<-data.frame(table(data_brooklyn$street_name))
d_merge_brooklyn <- merge(x=data_brooklyn,y=tab_brooklyn,by.x=c('street_name'),by.y=c('Var1'))
d_merge_brooklyn$freqPerc <- round((d_merge_brooklyn$Freq/length(data_brooklyn$street_name))*1000,digits=0)
d_merge_brooklyn$freqPerc <- ifelse(d_merge_brooklyn$freqPerc==0,1,d_merge_brooklyn$freqPerc)
pallette <- colorRampPalette(c('white','navyblue'))
colors <- pallette(max(d_merge_brooklyn$freqPerc))
brooklyn_plot <- ggmap(get_map('New York, New York, Brooklyn',zoom=12,maptype = c("roadmap"),color = c("color"),crop = TRUE))
plot_brooklyn_collisions <- brooklyn_plot+ geom_path(data=d_merge_brooklyn,size=1,aes(x=d_merge_brooklyn$long, y=d_merge_brooklyn$lat,group=d_merge_brooklyn$street_name),col=colors[d_merge_brooklyn$freqPerc]) + ggtitle("Brooklyn Collisions frequency Percentage across streets for Year 2015")
plot_brooklyn_collisions
