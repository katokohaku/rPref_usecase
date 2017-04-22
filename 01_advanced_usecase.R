# Advanced usecase: pRef package --------------------------------------------- 

require("rPref") 
require("dplyr") 
require("igraph") 
require("ggplot2")


# Base Preferences -------------------------------------------------------
# define a preference with a score value combining mpg and hp
p1 <- high(4 * mpg + hp)
# perform the preference selection
psel(mtcars, p1)
# define a preference with a given function
f <- function(x, y) (abs(x - mean(x))/max(x) + abs(y - mean(y))/max(y))
p2 <- low(f(mpg, hp))
psel(mtcars, p2)

# use partial evaluation for weighted scoring
p3 <- high(mpg/sum(mtcars$mpg) + hp/sum(mtcars$hp), df = mtcars)
p3
# select Pareto optima
peval(p3)


# Useful Base Preference Macros -------------------------------------------
# define preference for cars with low consumption (high mpg-value)
# and simultaneously high horsepower
p1 <- high(mpg) * high(hp)
# perform the preference search
psel(mtcars, p1)
# alternative way: create preference with associated data set
p2 <- high(mpg, df = mtcars) * high(hp)
peval(p2)


# Utility Functions for Preferences ---------------------------------------
# Same as low(a) * low(b)
p <- low(a) * low(b) * empty()
# returns 2, as empty() does not count
length(p)
# the preference expression (without empty())
as.expression(p)
p %>% str

# Complex Preferences ----------------------------------------------------

res1 <- psel(mtcars, high(mpg) * high(hp))#, top = nrow(mtcars)) 
res1 %>% 
  ggplot(aes(x = mpg, y = hp, color = factor(.level))) + 
  geom_point(size = 3) + geom_step(direction = "vh")

# p1 & p2
res2 <- psel(mtcars, high(mpg) & high(hp), top = nrow(mtcars)) 
res2 %>% 
  ggplot(aes(x = mpg, y = hp, color = factor(.level))) + 
  geom_point(size = 3) + geom_step(direction = "vh")

# p1 | p2
res3 <- psel(mtcars, high(mpg) | high(hp)) 
res1;
res3
res3 <- psel(mtcars, high(mpg) | high(hp), top = nrow(mtcars)) 
res3 %>% 
  ggplot(aes(x = mpg, y = hp, color = factor(.level))) + 
  geom_point(size = 3) + geom_step(direction = "vh")

# p1 + p2
res4 <- psel(mtcars, high(mpg) + high(hp), top = 5) 
res1;
res4

res4 %>% 
  ggplot(aes(x = mpg, y = hp, color = factor(.level))) + 
  geom_point(size = 3) + geom_step(direction = "vh")

# reverse
res4 <- psel(mtcars, -(high(mpg) * high(hp)), top = nrow(mtcars)) 
res4 <- psel(mtcars, reverse(high(mpg) * high(hp)), top = nrow(mtcars)) 
res4 %>% 
  ggplot(aes(x = mpg, y = hp, color = factor(.level))) + 
  geom_point(size = 3) + geom_step(direction = "vh")


# Useful Base Preference Macros -------------------------------------------
# search for cars where mpg is near to 25
mtcars %>% psel(around(mpg, 25))
mtcars %>% psel(around(mpg, 25), top=4)

mtcars %>% psel(pos(mpg, 21))
mtcars %>% psel(pos(mpg, 25), top=4)



p1 <- rPref::between(mpg, left = 17, right = 25) &
  (high(mpg)* high(hp))
res <- psel(mtcars, p1 , top=NROW(mtcars))

gp <- ggplot(res, aes(x = mpg, y = hp, color = factor(.level))) + 
  geom_point(size = 3) 
gp + geom_step(direction = "vh")


# cyl = 2 and cyl = 4 are equally good, cyl = 6 is worse
psel(mtcars, layered(cyl, c(2, 4), 6))

mtcars


# end ---------------------------------------------------------------------
