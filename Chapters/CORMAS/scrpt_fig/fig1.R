library(tidyverse)
library(reshape2)

evol <- function(x,iteration){
  fx <- x
  for(i in 1:iteration){
    xt <- fx[i] + 0.2 *(1 - fx[i] / 10)
    fx <- c(fx,xt)
  }
  return(fx)
}

my.df <- data.frame(t=c(0:1000),
                    x5=evol(5,1000),
                    x12=evol(12,1000),
                    x02=evol(0.2,1000))

my.dfgg <- melt(my.df,"t")

ggl <- ggplot(data = my.dfgg)+
  geom_line(aes(x = t, y = value, colour = variable))+
  labs(x = "Time", y = "Biomass")+
  scale_colour_manual(
    values=c("#999999", "#E69F00", "#56B4E9"),
    name="Init X value",
    labels=c("x = 5", "x = 12", "x = 0.2"),
    breaks=c("x5", "x12", "x02"))+
  theme(legend.position="top")
ggl

ggsave("figures/fig1.png", plot = ggl, width = 8)
