library(rgdal); library(googleway); library(ggrepel);library(data.table)
library(ggspatial); library(sf); library(rnaturalearth); library(ggmap)
library(rnaturalearthdata); library(lubridate); library(Hmisc); library(readxl);
options("scipen"=100, "digits"=4)

# All Types of Maps in R
sd <- readOGR("/Users/parthkhare/Data/India Administrative/2011/AllIndiaSubDists_Districts_States/AllIndiaSubDis/AllIndiaSubDistrict.shp")
ggmap::register_google(key = "AIzaSyB09J8woJyZjs9mu2tIv-AnFqj3YWzXSPo")


# DataSets
# ========================================================================================
# Groundwater Station
# ----------------------
gw16 <- readOGR("/Users/parthkhare/Desktop/MSCAPP Quarters/Quarter 4/Q4 Hydropolitics/Seminal Paper/India groundwater/Ind2016_gw_sites.shp")
class(gw16)
dim(gw16)

# Weather Stations: Rainfall
# ----------------------
load("/Users/parthkhare/Desktop/MOF Team CEA All Projects 2016-18/Rainfall Index/Data/Processed/District from source_Nov/Station Inside India/Rfall_30Nov.RData")
rfm1 <- data.table(rfm1)
rfm1$Stnll <- paste0(substr(as.character(rfm1$lat),1,6),"-",
                     substr(as.character(rfm1$lon),1,6))
r1990 <- subset(rfm1, yr=="1990")
r2010 <- subset(rfm1, yr=="2010")

# Protests
# ----------------------
pro <- read.csv("/Users/parthkhare/Desktop/Projects/Protests India/2019-06-01-2020-01-31-India.csv")
dim(pro)

View(head(pro))
# ========================================================================================



# GGMAP
# ========================================================================================
library(ggmap)
#Set your API Key
ggmap::register_google(key = "AIzaSyB09J8woJyZjs9mu2tIv-AnFqj3YWzXSPo")
# ========================================================================================

# ========================================================================================
# Fix Centroid for map Scale
# -------------------------------
india_centroid <- c(68.18625, 6, 97.41529, 37)                 # Optimal

# Base Maps: Google
# -------------------------------
# Google: Black n White Satellite
go_bw_sat <- get_map(location=india_centroid, color="bw", zoom=4, maptype="satellite")
ggmap(go_bw_sat)

# Google: Hybrid
go_hyb <- get_map(location=india_centroid,zoom=4, maptype = "hybrid")
ggmap(go_hyb)

# Google: Terrain
go_ter <- get_map(location=india_centroid, zoom=4, maptype = "terrain")
ggmap(go_ter)

# Base Maps: Stamen
# -------------------------------
# Stamen: watercolor
st_wc <- get_map(location=india_centroid, zoom=4, maptype="watercolor",source="stamen")
ggmap(st_wc)

# Stamen: Toner
st_ton <- get_map(location=india_centroid, zoom=4, maptype="toner", 
                     source="stamen")
ggmap(st_ton)

# Stamen: Terrain
st_ter <- get_map(location=india_centroid, zoom=4, maptype="terrain", source="stamen")
ggmap(st_ter)
# ========================================================================================


# Different Formats: Points
# ========================================================================================
# Crop to India
Ind3 <- ggmap(bw_map_base, extent = "device",legend = "bottomright", size = c(500,600)) +
  scale_x_continuous(limits = c(68.18625, 97.41529), expand = c(0, 0)) +
  scale_y_continuous(limits = c(8, 36.8), expand = c(0, 0))

# District Centroids: Stamen
# -------------------------------
myMap <- get_map(location=india_centroid, source="stamen", 
                 maptype="toner",crop=T, zoom=5)
ggmap(myMap) + geom_point(aes(x = lg, y = lt), data = rfm1,
                         alpha = .5, color="darkred", size = 0.4)

# District Centroids: Google
# -------------------------------
p <- ggmap(get_googlemap(center = c(lon = 82, lat = 22),
                         zoom = 5, scale = 4,maptype ='toner',color = 'color'))
p <- p + geom_point(aes(x = lg, y = lt,  colour = State.Name), 
                    data = rfm1, size = 0.5) + theme(legend.position="bottom")
p + theme(legend.position = "none") + ggtitle("District Centroids")



# District Centroids: SF
# -------------------------------
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

# Read State Boundaries
# -------------------------------
sts <- st_read("/Users/parthkhare/Data/India Administrative/2011/AllIndiaSubDists_Districts_States/AllIndiaStates/AllIndiaStates.shp")
class(sts)

ggplot(data = world) +
  geom_sf() +
  geom_point(data = rfm1, aes(x = lg, y = lt), size = 0.5, 
             shape = 16, fill = "darkred") +
  coord_sf(xlim = c(67.5, 97.5), ylim = c(6, 37), expand = FALSE) +
  ggtitle("District Centroids")




# ========================================================================================

### Spatial Spread of Stations
# ```{r, echo=F, message=F}
#Subset Data for 1950
r1950 <- subset(rfm1, yr=="1950")
r1960 <- subset(rfm1, yr=="1960")
r1990 <- subset(rfm1, yr=="1990")
r2010 <- subset(rfm1, yr=="2010")

#SetAPI Key
ggmap::register_google(key = "AIzaSyB09J8woJyZjs9mu2tIv-AnFqj3YWzXSPo")
# India Extent
bha <- c(68.18625, 6, 97.41529, 37)                 # Optimal
# Black n White Satellite
# ww3 <- get_map(location=bha, color = "bw", zoom=5, maptype = "satellite")
ww3 <- get_map(location=bha, color = "bw", zoom=5, maptype = "terrain")
Ind3 <- ggmap(ww3, extent = "device",legend = "bottomright", size = c(500,600))

# Plot Stations: 1960
Ind3 + geom_point(aes(x = lon, y = lat), data = r1960, alpha = .6,
                  color="darkgreen", size = 0.15) +
  ggtitle("3123 Precip Stations: 1960")

# Plot Stations: 1990
Ind3 + geom_point(aes(x = lon, y = lat), data = r1990, alpha = .6,
                  color="darkblue", size = 0.15) +
  ggtitle("4430 Precip Stations: 1990")

# Plot Stations: 2010
Ind3 + geom_point(aes(x = lon, y = lat), data = r2010, alpha = .6,
                  color="darkred", size = 0.15) +
  ggtitle("5911 Precip Stations: 2010")
# ========================================================================================

# Actual Maps
# ========================================================================================
# GW
go_bw_sat <- get_map(location=india_centroid, color="bw", zoom=4, maptype="satellite")
fix_crop_gw <- ggmap(go_bw_sat, extent="device",legend="bottomright", size=c(500,600))
fix_crop_gw + geom_point(aes(x=lond, y=latd, colour=Nov_s4), 
                         data=gw16, alpha = .6,size = 0.15) +
              scale_color_gradient2(low = muted("red"), high = muted("blue"), 
                                    mid = muted("lightblue"))


# Protest
go_ter <- get_map(location=india_centroid, zoom=4, maptype = "terrain")
fix_crop_tr <- ggmap(go_ter, extent="device",legend="bottomright", size=c(500,600))
fix_crop_tr + geom_point(aes(x=longitude, y=latitude),data=pro, 
                         color=muted("red"), alpha = .6,size = 0.15) +
  scale_color_gradient2(low = muted("red"), high = muted("blue"), 
                        mid = muted("lightblue")) +
  ggtitle("Protests in India 2019:2020")

# ========================================================================================






