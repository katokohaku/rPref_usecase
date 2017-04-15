# Get Started: pRef package

# install.packages("rPref") 
requie("rPref") 
requirer("dplyr") 
require("ggplot2")

# Calculate Skyline 
mtcars %>% 
  psel(low(mpg) * low(hp)) %>% 
  arrange(mpg)

# Calculate the level-value w.r.t. p by using top-all 
p <- low(mpg) * low(hp)
mtcars %>% 
  psel(p, top = nrow(.)) %>% 
  ggplot(aes(x = mpg, y = hp,
             color = factor(.level))) + 
  geom_point(size = 3) +
  geom_step(direction = "vh")


