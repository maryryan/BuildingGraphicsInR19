#################
###################### Building Graphics in R
###################### NICAR 2019
###################### March 7-10
###################### INSTRUCTOR: Mary Ryan
###################### CREATED 1.30.2019
###################### UPDATED 
##################

#### LOAD LIBRARIES ####
# install.packages( 'tidyverse' )
# install.packages( 'readxl' )
# install.packages( 'ggmap' )
# install.packages( 'maps' )
# install.packages( 'mapdata' )

# ggplot2, one of our main plotting functions, is part of the tidyverse #
library( tidyverse )
# also going to load in a library that lets us pull data from Excel files #
library( readxl )
# some libraries for making maps -- bonus section you can try on your own #
library(ggmap)
library(maps)
library(mapdata)

#### SCATTERPLOTS ####
# read in our data: average avocado prices through the U.S. from 2015-2018 #
avocado <- read_excel( "avocado.xlsx" )
avocado$Date.ymd <- ymd(avocado$Date)
# in base R, x-axis variable goes first, then the y-axis variable #
plot( avocado$`Total Volume`, avocado$AveragePrice )

# we can add titles and change axis labels by using the `main=`, `xlab=`, and `ylab=` arugments #
plot( avocado$`Total Volume`, avocado$AveragePrice,
      main="Avocados",
      xlab="Total Volume", ylab="Average Price ($)")


# in ggplot2, ggplot() acts as the call that we want to graph #
# aes() within ggplot() tells the plot the aesthetics -- here, what data to plot #
# adding geom_SOMETHING() at the end tells ggplot what type of plot to make #
# + geom_point() gets us a scatter (point) plot #
avocado %>% 
   ggplot( aes(`Total Volume`, AveragePrice) ) +
   geom_point()

# and we can rename our axes, or even add a main title, by adding `labs()`, `xlab()`, and `ylab()` #
avocado %>% 
   ggplot( aes(`Total Volume`, AveragePrice) ) +
   geom_point() + 
   labs(title = "Avocados") +
   xlab("Total Volume") + ylab("Average Price ($)")


#### LINE GRAPHS ####
# (I'll be using a different dataset just for line graphs -- it's already loaded into R) #

# there's actually a `type` argument in the plot() function that tells R what type of plot to make #
# the default for type is "p", which stands for "point #
# to make a line plot we need to set it to "l" for line #
plot( ChickWeight$Time, ChickWeight$weight, type="l",
      xlab="Weight", ylab="Time")

# To get different lines by chick, we plot one chick's data in the plot first, then we add more #
# lines using the `lines()` function for the other chicks we want #
plot(ChickWeight[which(ChickWeight$Chick==1), "Time"],
     ChickWeight[which(ChickWeight$Chick==1),"weight"],
     type="l",
     xlab="Weight", ylab="Time")
lines(ChickWeight[which(ChickWeight$Chick==5), "Time"],
      ChickWeight[which(ChickWeight$Chick==5),"weight"])
lines(ChickWeight[which(ChickWeight$Chick==27), "Time"],
      ChickWeight[which(ChickWeight$Chick==27),"weight"])

# It's a little hard to tell the difference between the lines, so we can give each #
# line its own color using the `col=` argument in both `plot()` and `lines()`
plot(ChickWeight[which(ChickWeight$Chick==1), "Time"],
     ChickWeight[which(ChickWeight$Chick==1),"weight"],
     type="l", col="red",
     xlab="Weight", ylab="Time")
lines(ChickWeight[which(ChickWeight$Chick==5), "Time"],
      ChickWeight[which(ChickWeight$Chick==5),"weight"], col="blue")
lines(ChickWeight[which(ChickWeight$Chick==27), "Time"],
      ChickWeight[which(ChickWeight$Chick==27),"weight"], col="green")

# We can also add a legend to the plot for the reader to be able to tell which line #
# color belongs to which chick. This is done using the `legend()` function after we've #
# called the plot #
# What you need in the `legend()` function: #
# - location: can be the coordinates where you want the box to appear or phrases like "topleft" or "bottomright"
# - legend: what sort of text do you want appearing in the legend?
   # - parameters: these are things like `lty`, `pch`, or `bty` that tells R
      # what line pattern or  dot symbol you want to appear , or if you want a box (respectively)
# - col: what kind of colors do you want your lines/symbols to be? 
plot(ChickWeight[which(ChickWeight$Chick==1), "Time"],
     ChickWeight[which(ChickWeight$Chick==1),"weight"],
     type="l", col="red",
     xlab="Weight", ylab="Time")
lines(ChickWeight[which(ChickWeight$Chick==5), "Time"],
      ChickWeight[which(ChickWeight$Chick==5),"weight"], col="blue")
lines(ChickWeight[which(ChickWeight$Chick==27), "Time"],
      ChickWeight[which(ChickWeight$Chick==27),"weight"], col="green")

legend("topleft", legend = c("Chick 1", "Chick 5", "Chick 27"),
       lty=1, bty="n", col=c("red", "blue", "green") )


# in ggplot, using `+ geom_line()` instead of `+ geom_point()` will get us a line graph #
ChickWeight %>% 
   ggplot( aes(Time, weight) ) +
   geom_line()
# this looks way different than in base R! that's because ggplot is taking the average weight #
# at each time point, while base R was connecting all the lines of all the chicks #

# We can make different lines by chick if we `filter()` the data before before sending #
# it to `ggplot()`, and grouping by the variable Chick #
ChickWeight %>% 
   filter( Chick %in% c(1, 5, 27) ) %>% 
   ggplot( aes(Time, weight, group=factor(Chick)) ) +
   geom_line()

# We can can give the lines different colors by using the `color` #
# argument within `aes()` #
ChickWeight %>% 
   filter( Chick %in% c(1, 5, 27) ) %>% 
   ggplot( aes(Time, weight, color=factor(Chick)) ) +
   geom_line()

# if you want the chicks to be specific colors you can add `scale_color_manual()` #
# along with setting color to the Chick variable in `geom_line()` #
ChickWeight %>% 
   filter( Chick %in% c(1, 5, 27) ) %>% 
   ggplot( aes(Time, weight, group=factor(Chick)) ) +
   geom_line( aes(color=factor(Chick)) ) +
   scale_color_manual(values=c("red", "blue", "green"))

# that's also an ugly legend title so we'll change it by adding a new title #
# to `scale_color_manual()` #
ChickWeight %>% 
   filter( Chick %in% c(1, 5, 27) ) %>% 
   ggplot( aes(Time, weight, group=factor(Chick)) ) +
   geom_line( aes(color=factor(Chick)) ) +
   scale_color_manual( "Chick", values=c("red", "blue", "green") ) + 


#### BAR CHARTS ####
# in base R we need count data to use the `barplot()` function #
# so we need to do some data management to get the total bags used by avocado type. #
# Here I'm just adding up all the Total Bags for conventional avocados and organic avocados #
counts.av <- c( sum(avocado[which(avocado$type=="conventional"),"Total Bags"]),
               sum(avocado[which(avocado$type=="organic"),"Total Bags"]) )
# give the numbers names so each bar will have a name when we plot #
names( counts.av ) <- c("conventional", "organic")

barplot( counts.av )

# we can color the bars by type #
barplot( counts.av, col=c("red", "blue"))

# we can also do stacked barcharts #
# need to do some more data management to get total bag counts by avocado type and region #
counts.grp <- rbind( c(sum(avocado[which(avocado$type=="conventional" & avocado$region=="TotalUS"),"Total Bags"]),
                         sum(avocado[which(avocado$type=="organic" & avocado$region=="TotalUS"),"Total Bags"])),
                     c(sum(avocado[which(avocado$type=="conventional" & avocado$region=="LosAngeles"),"Total Bags"]),
                       sum(avocado[which(avocado$type=="organic" & avocado$region=="LosAngeles"),"Total Bags"])),
                     c(sum(avocado[which(avocado$type=="conventional" & avocado$region=="SanDiego"),"Total Bags"]),
                       sum(avocado[which(avocado$type=="organic" & avocado$region=="SanDiego"),"Total Bags"])) )
colnames( counts.grp ) <- unique( avocado$type )
rownames( counts.grp ) <- c("TotalUS", "LosAngeles", "SanDiego")

# if you don't specify colors it will just be grayscale #
# `barplot()` also comes with a `legend` argument to create a legend #
barplot( counts.grp,  col=c("red","blue", "green"),
         legend = rownames(counts.grp) )

# `beside=TRUE` gets you the grouped aesthetic #
barplot( counts.grp, col=c("red","blue", "green"),
        legend = rownames(counts.grp),
        beside=TRUE )

# `horiz=TRUE` will get you a horizontal barchart #
barplot( counts.grp, col=c("red","blue", "green"),
         legend = rownames(counts.grp),
         beside=TRUE,
         horiz=TRUE )



## In ggplot, we can just plug in the data as it exists ##
avocado %>% 
   ggplot( aes(type, `Total Bags`)) +
   geom_bar( stat='identity' )

# we can color the bars by type #
avocado %>% 
   ggplot( aes(type, `Total Bags`, fill=type)) +
   geom_bar( stat='identity' )

# we can specify our own colors by adding `scale_fill_manual()` #
avocado %>% 
   ggplot( aes(type, `Total Bags`, fill=type) ) +
   geom_bar( stat='identity', aes(color=type, fill=type) ) +
   scale_color_manual( values=c("red", "blue") )


# We can get stacked bars by using the `col=` argument in the `aes()` of `ggplot()` and #
# `fill=` in the `aes()` of `geom_bar` #
avocado %>% 
   filter( region %in% c("TotalUS", "LosAngeles", "SanDiego") ) %>% 
   ggplot( aes(type, `Total Bags`, col=factor(region) ) ) +
   geom_bar( stat='identity', aes( fill=factor(region) ) )

# or we can grouped bars if we set `position='dodge'` in `geom_bar` #
avocado %>% 
   filter( region %in% c("TotalUS", "LosAngeles", "SanDiego") ) %>% 
   ggplot( aes(type, `Total Bags`, col=factor(region) ) ) +
   geom_bar( position='dodge', stat='identity', aes( fill=factor(region) ) )

# we can even get a horizontal barchart by adding `coord_flip()`
avocado %>% 
   filter( region %in% c("TotalUS", "LosAngeles", "SanDiego") ) %>% 
   ggplot( aes(type, `Total Bags`, col=factor(region) ) ) +
   geom_bar( position='dodge', stat='identity', aes( fill=factor(region) ) ) +
   coord_flip()




#### BOXPLOTS ####
# overall boxplot pretty easy in base R #
boxplot( avocado$AveragePrice )

# but different syntax than we've had before if we want to do multiple boxplots per window #
# y axis variable first, tilde, then x axis variable #
boxplot( AveragePrice ~ type, data=avocado )

# but if we want to do multiple regions per type... (i.e., like grouped bar charts) #
# set up the 'bones' of the plot (won't actually give us any boxes) #
boxplot( avocado.region$AveragePrice ~ avocado.region$type,
        xlim = c(0.5, 2+0.5),
        boxfill=rgb(1, 1, 1, alpha=1), border=rgb(1, 1, 1, alpha=1),
        ylab="Average Price" ) #invisible boxes

# plot Total US boxplots #
# `boxfill=` controls the box-fill color (not the border color) #
# `border=` would control the border color of the box (default is black) #
# `boxwex` controls how wide the boxes will be #
# `xaxt="n"` tells the plot not to include a new x-axis #
# (because we already created that in the "bones" above) #
boxplot( unlist(avocado[which(avocado$region=="TotalUS"), "AveragePrice"]) ~ unlist(avocado[which(avocado$region=="TotalUS"), "type"]),
        xaxt="n", add=TRUE, boxfill="blue", boxwex=0.25 )

# plot LA boxplots #
# the `at=` argument shifts the LA boxes 0.3 to left at points 1 (conventional) and 2 (organic) #
boxplot( unlist(avocado[which(avocado$region=="LosAngeles"), "AveragePrice"]) ~ unlist(avocado[which(avocado$region=="LosAngeles"), "type"]),
        xaxt="n", add=TRUE, boxfill="red", boxwex=0.25, at=c(1,2) - 0.3 ) 

# plot San Diego boxplots #
# here we're shifting the San Diego boxes 0.3 to the right #
boxplot( unlist(avocado[which(avocado$region=="SanDiego"), "AveragePrice"]) ~ unlist(avocado[which(avocado$region=="SanDiego"), "type"]),
        xaxt="n", add=TRUE, boxfill="green", boxwex=0.25, at=c(1,2) + 0.3 )

# add a legend #
# the `pch=` argument controls what symbols you want for the symbols #
# this would be in place of using a `lty=` argument that would specify the line pattern #
# I can never remember which `pch` code corresponds to what, so I usually google: #
# http://www.endmemo.com/program/R/pchsymbols.php #
# finally `cex=` tells us how large we want the text; 0.7 is 70% of the normal size #
legend( "topleft", c("Total US", "Los Angeles", "San Diego"),
       pch=15, bty="n",col=c("blue", "red", "green"),
       cex=0.7 )

# but man that was a lot of work! #


# in ggplot2, you get boxplots using `geom_boxplot` #
avocado %>% 
   ggplot( aes(x="", y=AveragePrice) ) +
   geom_boxplot()

# you can do boxplots factored by a variable #
avocado %>% 
   ggplot( aes(type, AveragePrice) ) +
   geom_boxplot()

# can even do a horizontal boxplot by adding `coord_flip()` like with barcharts #
avocado %>% 
   ggplot( aes(type, AveragePrice) ) +
   geom_boxplot() +
   coord_flip()

# and it's a snap to do grouped boxplots when you color by factored region #
avocado %>% 
   filter( region %in% c("TotalUS", "LosAngeles", "SanDiego") ) %>% 
   ggplot( aes(type, AveragePrice, fill=factor(region) ) ) +
   geom_boxplot()

# whew! so much less work! #

#### THEMES ####
# You can also apply pre-set color schemes to you ggplots by using themes: #
# classic theme gets rid of the background color and grid lines #
avocado %>% 
   filter( region %in% c("TotalUS", "LosAngeles", "SanDiego") ) %>% 
   ggplot( aes(type, AveragePrice, fill=factor(region) ) ) +
   geom_boxplot() +
   theme_classic()

# bw theme gives you white background and gray lines #
avocado %>% 
   filter( region %in% c("TotalUS", "LosAngeles", "SanDiego") ) %>% 
   ggplot( aes(type, AveragePrice, fill=factor(region) ) ) +
   geom_boxplot() +
   theme_bw()

# void theme takes pretty much everything away #
avocado %>% 
   filter( region %in% c("TotalUS", "LosAngeles", "SanDiego") ) %>% 
   ggplot( aes(type, AveragePrice, fill=factor(region) ) ) +
   geom_boxplot() +
   theme_void()

# you can find a complete list of the themes here: #
# https://ggplot2.tidyverse.org/reference/ggtheme.html #

#### MAPS ####
# mostly taken from this reproducible research course by Eric C. Anderson for (NOAA/SWFSC) #
# http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html #

# the key to making maps is you either need latitude and longitude data or polygon data #
# (in the case of base R) #

# load up USA coordinate data in a usable form using map_data #
usa <- map_data("usa")

# create our map using `geom_polygon` #
usa %>% 
   ggplot() +
   geom_polygon( aes(x=long, y = lat, group = group) )
   
# make it look less squished by playing with the aspect ratio using `coord_fixed()` #
usa %>% 
   ggplot() +
   geom_polygon( aes(x=long, y = lat, group = group)) + 
   coord_fixed(1.3)
   
# we can add some points to the map #
labs <- data.frame(
   long = c(-122.064873, -122.306417),
   lat = c(36.951968, 47.644855),
   stringsAsFactors = FALSE
)  

usa %>% 
   ggplot() + 
   geom_polygon( aes(x=long, y = lat, group = group) ) + 
   geom_point( data = labs, aes(x = long, y = lat), color = "black", size = 5 ) +
   geom_point( data = labs, aes(x = long, y = lat), color = "yellow", size = 4 ) +
   coord_fixed(1.3)

# and we can do a map with states! #
# load state map data #
states <- map_data("state")

# `color=white` will get us white state borders #
# `guides(fill=FALSE)` will block the automatic color legend #
states %>% 
   ggplot() + 
   geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") + 
   coord_fixed(1.3) +
   guides(fill=FALSE) 

# and here we get some specific states #
west_coast <- subset(states, region %in% c("california", "oregon", "washington"))

west_coast %>% 
   ggplot() + 
   geom_polygon(aes(x = long, y = lat, group = group), fill = "violet", color = "white") + 
   coord_fixed(1.3)
