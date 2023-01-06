library(reshape2)
library(ggplot2)

# Constants
R <- 0.2
K <- 10
STEPS <- 60
INITIAL_BIOMASSES <- c(0.1, 0.3, 5, 11)
COLORS <- c("#4D6EBB", "#DE8243", "#A5A5A5", "#F5C342")

# Return the logistic growth function defined by two parameters,
# growth rate R and carrying capacity K:
# f(x) = x + R * (1 - x / K)
logisticGrowthFunction <- function(growthRate, carryingCapacity) {
  function(x) {
    x + growthRate * x * (1 - x / carryingCapacity)
  }
}

# Simulate the growths of the initial biomass based on the given
# growth function. Return the array of biomass values at each step
growBiomass <- function(initialBiomass, growthFunction, numSteps) {
  biomassValues <- c(initialBiomass)
  
  for(i in 1:numSteps) {
    nextValue <- growthFunction(biomassValues[i])
    biomassValues <- c(biomassValues, nextValue)
  }
  return(biomassValues)
}

growthFunction <- logisticGrowthFunction(R, K)

# Constructing a data frame
df <- data.frame(step=c(0:STEPS))

for (initialBiomass in INITIAL_BIOMASSES) {
  biomassValues <- growBiomass(initialBiomass, growthFunction, STEPS)
  df <- cbind(df, biomassValues)
}

# Setting column names to ("step", "x1", "x2", ..., "xn")
colnames(df) <- c("step", paste("x", 1:length(INITIAL_BIOMASSES), sep = ""))

melted.df <- melt(df,"step")

plot <- ggplot(data = melted.df) +
  ggtitle(sprintf("Logistic growth of biomass with r=%s and K=%s", R, K)) + 
  geom_line(aes(x = step, y = value, colour = variable), linewidth=1.4) +
  labs(x = "Step", y = "Biomass") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_colour_manual(
    values=COLORS,
    name="Initial biomass:",
    labels=paste("Xo", INITIAL_BIOMASSES, sep = " = "),
    breaks=colnames(df)[-1]) +
  theme_light() +
  theme(legend.position="bottom")
plot

ggsave("../figures/logisticCurves.png", plot = plot, width = 6, height=4)
