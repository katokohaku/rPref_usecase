# Get Started: pRef package --------------------------------------------- 
#
# install.packages("rPref") 
# install.packages("dplyr") 
# install.packages("igraph") 
# install.packages("ggplot2")
# source("https://bioconductor.org/biocLite.R")
# biocLite("Rgraphviz")
# biocLite("graph")

require("rPref") 
require("dplyr") 
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
gp 
gp + geom_step(direction = "vh")


# Grouped Skyline ---------------------------------------------------------
# Get grouped data set using dplyr
df <- group_by(mtcars, cyl)

# Calculate Grouped Skyline
sky2 <- psel(df, high(mpg) * high(hp))

summarise(sky2, skyline_size = n())
ggplot(mtcars, aes(x = mpg, y = hp)) + 
  geom_point(shape = 21) + 
  geom_point(aes(color = factor(sky2$cyl)), sky2, size = 3)


# Better-Than-Graph for the preference order ------------------------------
# Pick a small data set and create preference / BTG 
df <- mtcars[1:8,] 
pref <- high(mpg) * low(wt) 
btg <- get_btg(df, pref) 
str(btg)

# Create labels for the nodes containing relevant values 
labels <- paste0("mpg:", df$mpg, ", wt:", df$wt)
plot_btg(df, pref, labels = labels, use_dot = TRUE)


# end ---------------------------------------------------------------------

