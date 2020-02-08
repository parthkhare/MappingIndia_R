# MappingIndia_R
Variants of R maps on India
---
title: "Mapping Indian Data"
author: "Using geo-spatial packages in R"
output: rmarkdown::github_document #html_document # pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(out.width='700px', dpi=200, echo=T) # Chaneg
# knitr::opts_chunk$set(echo = TRUE)
library(wbstats); library(ggplot2); library(treemapify);library(treemap)
library(readxl); library(scales); library(sf); library(leaflet);library(colorspace)
library(ggmap); library(rgdal);library(maptools); library(data.table)

#Set your API Key: Register for GGmap
ggmap::register_google(key = "AIzaSyB09J8woJyZjs9mu2tIv-AnFqj3YWzXSPo")
```

### Get Data
```{r, echo=F, message=F}
# Groundwater Station
# ----------------------
gw16 <- readOGR("/Users/parthkhare/Desktop/MSCAPP Quarters/Quarter 4/Q4 Hydropolitics/Seminal Paper/India groundwater/Ind2016_gw_sites.shp")
gw16 <- gw16@data

# Weather Stations: Rainfall
load("/Users/parthkhare/Desktop/MOF Team CEA All Projects 2016-18/Rainfall Index/Data/Processed/District from source_Nov/Station Inside India/Rfall_30Nov.RData")
rfm1 <- data.table(rfm1)
r2010 <- subset(rfm1, yr=="2010")

# Protests
pro <- read.csv("/Users/parthkhare/Desktop/Projects/Protests India/2019-06-01-2020-01-31-India.csv")
```


## Mapping India: Fixing Span
```{r}
# Fix Centroid for map Scale
india_centroid <- c(68.18625, 6, 97.41529, 37)                 # Optimal

# Map Type I: Groundwater
go_bw_sat <- get_map(location=india_centroid, color="bw", zoom=4, maptype="satellite")
fix_crop_gw <- ggmap(go_bw_sat, extent="device",legend="bottomright", size=c(500,600))
fix_crop_gw + geom_point(aes(x=lond, y=latd, colour=Jan_s1), 
                         data=gw16, alpha = .6,size = 0.15) +
              scale_color_gradient2(low = muted("red"), high = muted("blue"), 
                                    mid = muted("lightblue")) +
              ggtitle("Groundwater Stations in India")



# Map Type II: Protests in India 2019:2020 (ACLED)
go_ter <- get_map(location=india_centroid, zoom=4, maptype = "terrain")
fix_crop_tr <- ggmap(go_ter, extent="device",legend="bottomright", size=c(500,600))
fix_crop_tr + geom_point(aes(x=longitude, y=latitude),data=pro, 
                         color=muted("red"), alpha = .6,size = 0.15) +
              scale_color_gradient2(low = muted("red"), high = muted("blue"), 
                                    mid = muted("lightblue")) +
              ggtitle("Protests in India 2019:2020")


# Rainfall
st_ton <- get_map(location=india_centroid, zoom=4, maptype="toner", 
                     source="stamen")
fix_crop_st <- ggmap(st_ton, extent="device",legend="bottomright", size=c(500,600))
fix_crop_st + geom_point(aes(x=lg, y=lt),data=r2010, 
                         color=muted("red"), alpha = .6,size = 0.15) +
              scale_color_gradient2(low = muted("red"), high = muted("blue"), 
                                    mid = muted("lightblue")) +
              ggtitle("Rainfall in 2010")

```


## Display All Map Types
```{r, echo=F, message=F}
# Base Maps
# Google: Black n White Satellite
go_bw_sat <- get_map(location=india_centroid, color="bw", zoom=4, maptype="satellite")
ggmap(go_bw_sat)

# Google: Hybrid
go_hyb <- get_map(location=india_centroid,zoom=4, maptype = "hybrid")
ggmap(go_hyb)

# Google: Terrain
go_ter <- get_map(location=india_centroid, zoom=4, maptype = "terrain")
ggmap(go_ter)

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
```

<!-- ## Demographic Dividend: 2017-18 -->
<!-- Youth Population from Atlas of Human Settlements [Gridded Population of India (GHSL)] -->
<!-- ```{r, echo=F, message=F} -->
<!-- var <- 'ypop' -->
<!-- qpal <- colorQuantile("RdYlBu", domain = sr$var, n = 4) -->

<!-- leaflet(sr) %>% -->
<!--   addProviderTiles(providers$CartoDB.DarkMatter) %>% -->
<!--   addPolygons(color = "#B0B0B0", weight = 1, smoothFactor = 0.5, -->
<!--               opacity = 0.2, fillOpacity = 0.8, -->
<!--               fillColor = ~qpal(get(var)), -->
<!--               highlightOptions = highlightOptions(color = "white", weight = 2, -->
<!--                                                    bringToFront = TRUE)) %>% -->
<!--    addLegend("bottomright", pal = qpal, values = ~get(var), -->
<!--             opacity = 0.3, title = "Applicants") -->
<!-- ``` -->

