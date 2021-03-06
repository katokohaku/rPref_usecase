# Basic usage: pRef package

# source("https://bioconductor.org/biocLite.R")
# biocLite("Rgraphviz")
# biocLite("graph")

require("rPref") 
require("dplyr") 
require("magrittr")
require("igraph") 
require("ggplot2")


# Skyline plot ------------------------------------------------------------
# Calculate Skyline 
sky1 <- psel(mtcars, high(mpg) * high(hp)) 
head(mtcars)
# Plot mpg and hp values of mtcars and highlight the skyline 
ggplot(mtcars, aes(x = mpg, y = hp)) +
  geom_point(shape = 21) +
  geom_point(data = sky1, size = 3)

# Consider again the preference from above 
p <- high(mpg) * high(hp) 
p
str(p)

# Calculate the level-value w.r.t. p by using top-all 
res <- psel(mtcars, p, top = nrow(mtcars)) 
str(res)

# Visualize the level values by the color of the points 
gp <- ggplot(res, aes(x = mpg, y = hp, color = factor(.level))) + 
  geom_point(size = 3) 
gp + geom_step(direction = "vh")


# Grouped Skyline ---------------------------------------------------------
# Get grouped data set using dplyr
df <- group_by(mtcars, cyl)

# Calculate Grouped Skyline
sky2 <- mtcars %>% 
  group_by(cyl) %>% 
  psel(high(mpg) * high(hp))

ggplot(mtcars, aes(x = mpg, y = hp)) + 
  geom_point(shape = 21) + 
  geom_point(aes(color = factor(sky2$cyl)),
             sky2, size = 4)

summarise(sky2, skyline_size = n())


# Better-Than-Graph for the preference order ------------------------------
# Pick a small data set and create preference / BTG 
df <- cbind(N=1:8, mtcars[1:8,]) 
pref <- high(mpg) * low(wt) 
btg <- get_btg(df, pref) 
str(btg)

# Create labels for the nodes containing relevant values 
labels <- paste0(df$N,": mpg=", df$mpg, ",wt=", df$wt)
plot_btg(df, pref, labels = labels, use_dot = TRUE)


# end ---------------------------------------------------------------------

