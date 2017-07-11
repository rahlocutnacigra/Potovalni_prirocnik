
#Latitude: 1 deg = 110.54 km

#Longitude: 1 deg = 111.320*cos(latitude) km

#ideja:
#  input = sprejemljivo št. km
#Lat = lat(letališča) +/- input/110.54
#Lon = lon(letalisca) +/- input(111.320*cos(Lat))

input <- 100

Lat <-  input/110.54
Lon <- input/(111.320*cos(Lat))

pretvornik<-function(km){
  Lat <-  km/110.54
  Lon <- km/(111.320*cos(Lat))
  c(Lat, Lon)
}
pretvornik(82.65)
