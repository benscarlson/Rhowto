
#nice example of heat map and a bunch of other best practices for ggplot2
#https://rud.is/projects/facetedheatmaps.html

#Include images almost anywhere in ggplot
# https://mrcaseb.github.io/ggpath/


geom_text_repel(data=dat, aes(x=lon, y=lat,label=study_num),size=3,force=3) + #segment.color = NA (use this to turn off lines) 

#---- geoms ----#

#-- density/histograms

#to show relative density or relative frequency
geom_density(..scaled..) #relative density
#Both of these approaches work
geom_histogram(aes(y=stat(count) / sum(count))) #relative frequency
geom_histogram(aes(y=stat(count / sum(count))))

ggConvexHull::geom_convexhull() #convex hull

# NOTE seems using geom_linerange is often a better approach
# to acheive a horizontal line segment with a point in the middle, use the following
dat %>%
  ggplot(aes(x = beta, y = Level)) +
  geom_errorbarh(aes(xmin = ulower, xmax = uupper), 
      show.legend=FALSE,size=.8,height=0) +
  geom_point()

#Here is how to do a horizontal line range
#Tricky to just output linerange geometry. If we have min and max
# for the line range, what do we put as x? The trick is to 
# just put the min value. That seems to set up the axes correctly.
# to do vertical, switch aes(x,y) mapping and use ymin, ymax in linerange
dat %>%
  group_by(local_identifier) %>%
  summarize(mints=as.Date(min(timestamp)),
            maxts=as.Date(max(timestamp))) %>%
  ggplot(aes(x=mints,y=local_identifier,color=local_identifier)) +
  geom_linerange(aes(xmin=mints,xmax=maxts),show.legend=FALSE)

#---- colors ----#
# See colors.r


# The order that items are drawn on the plot is based on the order of the data frame. 
#   The first item is drawn first and the last item drawn last.

#--------------#
#---- axes ----#
#--------------#

#-- axis limits
xlim(0,100) #limit scale from 0 to 100
scale_x_continuous(limits=c(0,100)) #limit scale from 0 to 100
scale_x_continuous(expand=c(0,0)) #this removes padding between axis and data

#-- limits and breaks
scale_x_continuous(limits=c(0,1), breaks=c(0,1)) #using scale_x_continuous() and lims() together doesn't work. Use this instead.

#-- formatting
scale_x_continuous(labels=number_format(accuracy = 1, big.mark='')) #formats numbers to have no decimal place
scale_x_continuous(labels = function(x) {format(as.Date(as.character(x), "%j"), "%d-%b")}) #x is doy, prints 'Month-Day' on axis
scale_x_continuous(breaks=4:12,labels=2^(4:12)) #Label a logged axis with the actual values
scale_x_date() #this is prints out dates on axis

#roate axis text
theme(axis.text.x = element_text(angle = 45, hjust = 1))

#---- mapping aethetics ----#

#to manually set mappings, use scale_*_manual(). This assumes that var1 and var2 are factors with two levels
ggplot(data=dat, aes(x=x,y=y, alpha=var1, shape=var2)) +
  geom_point() +
  scale_shape_manual(values=c(3,16)) + 
  scale_alpha_manual(values=c(0.2,1))

#---- Order of elements ----#

#NOTE: Sometimes ggplot does not respect levels, but instead respects sort order

#ggplot respects order levels. So, this will draw/order levels with B first, A second
type=factor(c('A','B'), levels=c('B','A')) 

dat %>% arrange(desc(category))

#---- Guides/legends ----

#--- Breaks

#This is how scale_*_continuous makes default breaks
#https://stackoverflow.com/questions/38486102/how-does-ggplot-calculate-its-default-breaks
#But breaks_pretty is mainly used for dates
labeling::extended(min(x),max(x),m=3,only.loose=FALSE)

#This returns prettier intervals for dates.
scales::breaks_pretty(n=5)(dayPts$date) #default is n=5
scale_color_viridis_c(trans='date',breaks = scales::breaks_pretty(12)) #might not work

#Manual breaks using consistently sized intervals
rng <- range(as.numeric(dayPts$date))
b <- as.Date(round(seq(rng[1],rng[2],by=(rng[2]-rng[1])/4)),origin='1970-01-01')

scale_color_viridis_c(trans='date',breaks=b)

#Prettier breaks but need to manually set min/max
b <- scales::breaks_pretty()(dayPts$date) #default is n=5
b[c(1,length(b))] <- range(dayPts$date) #replace min/max b/c they may not equal min/max of the data
names(b) <- NULL

scale_color_viridis_c(trans='date',breaks=b)


#--- Remove legends
# Several different methods. See: https://stackoverflow.com/questions/35618260/remove-legend-ggplot-2-2
guides(fill=FALSE)
geom_point(..., show.legend=FALSE)

#--- legend title
labs(color='My Legend Title')
labs(color=NULL) #Don't show legend title
scale_color_discrete(name='My legend title') #use this if the legend variable is mapped to 'color' in aes()

#-- legend labels
scale_color_discrete(labels=c('label 1', 'label 2'))
scale_fill_gradientn(colours = pal,name='Niche occupancy', labels=scales::percent) #show labels as percentages

#Can also set these in scale_*_*()
guides(colour = guide_legend(override.aes = list(shape=16,size=3))) #override legend size and shape. 16 is filled circle.
guides(fill=guide_legend(reverse=TRUE)) #Reorder the lables in the guide
guides(fill=guide_legend(ncol=2)) #make 2 column legend.

theme(legend.background = element_rect(color='black',size=0.3)) #put a black box around legend

#set legend font size
theme(
  legend.text = element_text(size = 8),
  legend.title = element_text(size = 10))

theme(legend.key = element_blank()) #remove the boxes around  the legend shapes


#set labels on the 
scale_fill_continuous(
  labels=c(0,0.25,0.5,0.75,1))

#--- legend position

#put legend on the bottom. guide_colorbar() is for continuous, while guide_legend does discrete.
  guides(fill=guide_colorbar(
    title.position='top',
    label.position='bottom'))

#set the legend position first is x, second is y. for y, top is 1, bottom is 0
theme(legend.position = c(.8, .8), legend.key = element_blank())
theme(legend.position='bottom') #can do top, bottom, left, right

#put legend on bottom, but align items vertically
theme(legend.position="bottom", legend.direction="vertical")

#-- themes for faceting
strip.text = element_text(size=9) #change font size on facets
strip.background = element_blank() #remove border around facet labels
panel.border = element_rect(color = "black", fill=NA) #make a black border around facet panels

#----------------#
#---- Themes ----#
#----------------#

#Try this theme font, looks nice
#https://mattherman.info/blog/fix-facet-width/
theme_minimal(base_family = "Roboto Condensed")


theme_classic(base_family="Helvetica") #this theme usually works fine
theme_tufte(base_family="Helvetica") #library(ggthemes)
theme_bw()
#http://docs.ggplot2.org/dev/vignettes/themes.html
theme_set(theme_classic(base_family="Helvetica")) #sets theme for every plot in r session

#---- Tidy evaluation ----#

x <- 'var1'; y <- 'var2'
ggplot(dat, aes(x=!!sym(x),y=!!sym(y))) 

#---- Density plots ----#

#if color of fill is numeric, need to make it into a factor
sim.data$y <- factor(sim.data$y,levels=c(0,1),labels=c('avail','used'))

cols <- c('avail'='#0073C2FF','used'='#FC4E07')

#set ..scaled.. to make both groups max at 1
ggplot(sim.data,aes(x=elev,fill=y,color=y,..scaled..)) +
  geom_density(alpha=0.5) +
  scale_fill_manual(values=cols,aesthetics=c('color','fill'))

#---------------------#
#---- Programming ----#
#---------------------#

#How to refer to a dataset passed in through a pipe inside later graphic elements
#Enclose with {} then refer to the dataset with .
dat %>%
  filter(!is.na(spec) & hs_name != 'species') %>%
{ggplot(data=., aes(x=spec,y=hs_name)) +
  geom_point() +
  scale_y_discrete(labels=.$hs_label)}

#---- PCA ----#
https://github.com/vqv/ggbiplot

#-----
# multipanel plots
#-----

#TrelliscopeJS. Visualizing big data.
# https://hafen.github.io/trelliscopejs/
# https://www.business-science.io/code-tools/2022/03/30/how-i-analyze-100-ggplots-at-once.html

#----
# patchwork
#----

#-- use patchwork with a list of plots
#TODO: should be able to do this using map()

plots <- list()

for(item in items) {

  p <- ggplot(dat) + etc...
  
  plots[[item]] <- p
}

#Seems I can just do wrap_plots without need to do wrap_elements
#wrap_elements seems to be used to make subpanels. Note below will 
# result in a single tag for the whole subpanel
p <- wrap_elements(wrap_plots(plots,nrow=3))

#This is generally what you want
p <- wrap_plots(plots,nrow=3)

#Add themes and annotations to patchwork
p + plot_annotation(tag_levels = 'A') & theme(plot.tag = element_text(size = 8))
p + plot_annotation() & theme_minimal()

#-- Faceting
facet_grid(vars(population),vars(term),scales='free_y',switch='y',space='free_y')
facet_wrap(vars(group)) #one facet per group

#Workaround for common y-axis label
#https://stackoverflow.com/questions/66778174/how-to-allow-common-central-y-axis-label-to-extend-into-the-bottom-graph/66778622#66778622

#-----
# color palettes
#-----

#http://tools.medialab.sciences-po.fr/iwanthue/
#https://visme.co/blog/color-combinations/

#----------
# cowplot
#----------

#to set a blank theme, just use plot_grid. it will automatically set the theme to blank/classic

#legends can really throw off plot_grid. It seems that legends aren't scaled correctly. 
# so, the legend will be unscaled (often too big) and then the rest of the figure will be scaled
# to fit the default size. This results in a figure that is way to small. To get around this, specifically 
# set the base_width and base_height parameters in save_plot. Get the graph the way you want it,
# then play around with the size of the legend by using theme(). Finally, make final adjustments to base_width and base_height

#Snippet for how Ruth uses cowplot
xi <- 0.5
pdf("~/Desktop/test.pdf")
ggdraw() +
  draw_plot(p1, x = 0, y = xi, width = 1, height = xi) +
  draw_plot(p2, x = 0, y = 0, width = 1, height = xi)
dev.off()

#--------------------#
#---- save plots ----#
#--------------------#

#-- cowplot
save_plot('~/scratch/dualplot.png', dualPlot,
          ncol = 2, nrow = 1,
          base_width=8,
          base_height=6)

ggsave(.figout,plot=p,height=6,width=12,device=cairo_pdf) #save pdf

#should always use cairo. Can also use cairo for pdf by saying device=cairo_pdf
#https://www.andrewheiss.com/blog/2017/09/27/working-with-r-cairo-graphics-custom-fonts-and-ggplot/
ggsave(file.path(.figP,glue('rsf_spider_by_coef_myear.png')),plot=p,height=6,width=12,type='cairo')


#---- ggplot and sf ----#
#-----------------------#

#this is how to use two different geometry columns
# the geometry column is polygons
# pts is a second list column of sf geoms
ggplot(bg) +
  geom_sf(aes(color=bin),fill=NA) +
  geom_sf(aes(color=bin,geometry=pts))
