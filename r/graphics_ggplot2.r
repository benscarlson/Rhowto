
#nice example of heat map and a bunch of other best practices for ggplot2
#https://rud.is/projects/facetedheatmaps.html

geom_text_repel(data=dat, aes(x=lon, y=lat,label=study_num),size=3,force=3) + #segment.color = NA (use this to turn off lines) 

#create a three part color gradient
scale_color_gradient2('Legend title',low="red", mid='green', high='blue',
  midpoint=median(x),
  breaks=c(1,2,3,4),
  labels=c('one','two','three','four'))

#---- Themes ----
theme_tufte(base_family="Helvetica") #library(ggthemes)

#http://docs.ggplot2.org/dev/vignettes/themes.html
theme_set(theme_bw()) #sets theme to theme_bw for every plot in r session

#set legend fonts
theme(
  legend.text = element_text(size = 8),
  legend.title = element_text(size = 10))

#set the legend position and remove the boxes around  the legend shapes
theme(legend.position = c(.8, .8), legend.key = element_blank()) +

#theme with no grey background, black lines for axes
theme_bw() +
theme(panel.border = element_blank(), panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  axis.line.x = element_line(color="black", size = 0.5),
  axis.line.y = element_line(color="black", size = 0.5))

#theme that looks similar to the above theme
plotTheme <-   theme(panel.background = element_blank(),
                     panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(),
                     axis.text=element_text(size=20),
                     axis.title=element_text(size=20),
                     axis.line = element_line(colour = "black"),
                     legend.text = element_text(size=12),
                     legend.title = element_text(size=14))

# Use this theme for maps in presentations
theme_map <- theme(
  panel.background = element_blank(),
  panel.grid.major = element_blank(), 
  panel.grid.minor = element_blank(),
  #axis.line = element_line(colour = "black"),
  axis.ticks = element_blank(),
  axis.text = element_text(size=18), #element_blank(),
  axis.title = element_text(size=20), #element_blank(),
  legend.key = element_blank(),
  legend.text = element_text(size=16),
  legend.title = element_text(size=18))

#Guides/legends
guides(colour = guide_legend(override.aes = list(shape=16,size=3))) #override legend size and shape. 16 is filled circle.
#set labels on the 
scale_fill_continuous(
  labels=c(0,0.25,0.5,0.75,1))

#put legend on the bottom. guide_colorbar() is for continuous, while guide_legend does discrete.
  guides(fill=guide_colorbar(
    title.position='top',
    label.position='bottom'))

#----------
# cowplot
#----------

#to set a blank theme, just use plot_grid. it will automatically set the theme to blank/classic

#legends can really throw off plot_grid. It seems that legends aren't scaled correctly. 
# so, the legend will be unscaled (often too big) and then the rest of the figure will be scaled
# to fit the default size. This results in a figure that is way to small. To get around this, specifically 
# set the base_width and base_height parameters in save_plot. Get the graph the way you want it,
# then play around with the size of the legend by using theme(). Finally, make final adjustments to base_width and base_height

save_plot('~/scratch/dualplot.png', dualPlot,
          ncol = 2, nrow = 1,
          base_width=8,
          base_height=6)