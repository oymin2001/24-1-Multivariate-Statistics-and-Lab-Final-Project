install.packages(c("psych","GPArotation"))
install.packages('corrplot')
install.packages("leaps")
install.packages("pls")
install.packages("nFactors")
library(leaps)
library(psych)
library(GPArotation)
library(dplyr)
library(corrplot)
library(mgcv)
library(pls)
library(stats)
library(nFactors)


############### preprocess 
set.seed(1)

file_dir <- "" # train.csv file directory
df <- read.table(file_dir, header=T, row.names = 1, sep=",");head(df)
hist(df$Chance.of.Admit)
head(df[,-7])
df.continuous <- df[,-8]
df.r <- cor(df.continuous)
nScree(cor(df[,-8]))
corrplot.mixed(df.r,upper = 'ellipse')


df.pca <-prcomp(df.continuous, center=T, scale=T)
df.pca$rotation
summary(df.pca)
df.pca$sdev
plot(df.pca) # 1 or 2 is proper

summary(aov(`Chance.of.Admit` ~ as.factor(Research), data=df)) # factor


######### PCR #################################################################################

colMeans(df.continuous[,-7])


df.continuous[,-7] %>% mutate_all(~(scale(.) %>% as.vector)) -> df.con.scaled

df.pc2 <- as.matrix(df.con.scaled) %*% as.matrix(df.pca$rotation)[,1:2]
df.pc2 <- cbind(df.pc2, df$Chance.of.Admit)
colnames(df.pc2) <- c("PC1", "PC2", "target")
df.pc2 <- data.frame(df.pc2)
head(df.pc2)

plot(df.pc2$PC1, df.pc2$target)
lm.pc1 <- lm(target ~ PC1, data=df.pc2); summary(lm.pc1)
xx1 <- seq(min(df.pc2$PC1)-0.1, max(df.pc2$PC1)+0.1,length.out = 100)
lines(xx1, 0.544 - 0.084 * xx1, col='red')


plot(df.pc2$PC2, df.pc2$target)
xx <- seq(-2.5,2.3,length.out = 100)
lines(xx, xx*0.031 + 0.55,col='red')



lm.pc2 <- lm(target ~ PC1 + PC2, data=df.pc2); summary(lm.pc2)
plot(lm.pc)

df.pc2.rm.outlier <- df.pc2[-c(10,65,66),]
lm.pc2 <- lm(target ~ PC1 + PC2, data=df.pc2.rm.outlier); summary(lm.pc2)
plot(lm.pc2)




model <- pcr(Chance.of.Admit ~ ., data=df.continuous, scale=TRUE, validation="CV")
summary(model)

validationplot(model, val.type="MSEP")
validationplot(model, val.type="R2")






################ Factor Analysis ####################################################
df.fa.none <- factanal(df.continuous[,-7], factors=2, rotation='none')
df.fa.varimax <- factanal(df[,-8], factors=3, rotation='varimax')

df.fa.none$loadings
df.fa.varimax$loadings
# varimax is proper

library(psych)
library(GPArotation)

fa3 = fa(df[,-8], 2, rotate = "varimax")
fa.diagram(fa3, col="red")


print(fa3, digits = 2, sort = T)  
  
# first factor: GRE > TOEFL > CPGA : higher -> more objective
# second factor: SOP > LOR > Univ.rating > CGPA : higher -> more subjective 

plot(df.fa.varimax$loadings[, 1],
     df.fa.varimax$loadings[, 2],
     xlab = "Factor 1",
     ylab = "Factor 2",
     ylim = c(-1, 1),
     xlim = c(-1, 1),
     main = "Varimax rotation")

text(df.fa.varimax$loadings[, 1] - 0.08,
     df.fa.varimax$loadings[, 2] + 0.08,
     colnames(df.continuous),
     col = "blue")

abline(h = 0, v = 0)


df.fa.wls <- factanal(df.continuous[,-8], factors=2, rotation='varimax', scores='Bartlett')





############################## Factor Scores Regression Model ##############################

df.fa.wls$scores -> df.factors2
df.factors2 <- as.data.frame(df.factors2)
df.factors2$target <- df$Chance.of.Admit
head(df.factors2)
cor(df.factors2)

plot(df.factors2$Factor1, df.factors2$target)
plot(df.factors2$Factor2, df.factors2$target)

summary(lm(target~Factor1+Factor2, data=df.factors2))
?factanal

df.factors2




######################## Multiple Regression & Low-order interaction model ###################


lm.full <- lm(Chance.of.Admit ~ GRE.Score + TOEFL.Score + University.Rating + SOP + LOR + CGPA + Research, data = df)
summary(lm.full)


lm.full.interaction <- lm(Chance.of.Admit ~ GRE.Score*TOEFL.Score*University.Rating*SOP*LOR*CGPA*Research, data = df)
summary(lm.full.interaction)

lm.interaction <- lm(Chance.of.Admit ~ GRE.Score + TOEFL.Score + University.Rating + SOP + LOR + CGPA + Research +
                       GRE.Score:TOEFL.Score + GRE.Score:CGPA + TOEFL.Score:CGPA +
                       GRE.Score:TOEFL.Score:CGPA, data = df)
summary(lm.interaction)
# mod_lm = gam(Chance.of.Admit ~ GRE.Score + TOEFL.Score + University.Rating + SOP + LOR + CGPA + Research, data = df)
# summary(mod_lm)

interaction.leaps = leaps(x = X, y = df$Chance.of.Admit, nbest = 3, method = 'Cp')

ind3 = which.min(interaction.leaps$Cp - interaction.leaps$size)
best.model.Cp = interaction.leaps$which[ind3,]
best.model.Cp

plot(interaction.leaps$size, interaction.leaps$Cp,
     pch = 23, bg = 'orange', cex = 2)

interaction.step.forward = step(lm(Chance.of.Admit ~ 1, df), 
                             list(upper = ~ GRE.Score + TOEFL.Score + University.Rating + SOP + LOR + CGPA + Research +
                                    GRE.Score:TOEFL.Score + GRE.Score:CGPA + TOEFL.Score:CGPA +
                                    GRE.Score:TOEFL.Score:CGPA), 
                             direction = 'forward', k=2)
interaction.step.forward ## AIC 

step(lm.interaction, direction ='both')
###############################################################



############ Polynomials with Factore analysis
df.poly <- df.continuous[,1:6]

colnames(df.poly) <- c("GRE", "TOEFL", "Rating", "SOP", "LOR", "CGPA")
head(df.poly)

df.poly$`GRE_sq` <- df.poly$GRE**2
df.poly$`TOEFL_sq` <- df.poly$TOEFL**2
df.poly$`Rating_sq` <- df.poly$Rating**2
df.poly$`SOP_sq` <- df.poly$SOP**2
df.poly$`LOR_sq` <- df.poly$LOR**2
df.poly$`CGPA_sq` <- df.poly$CGPA**2

df.poly['GRExTOEFL'] <- df.poly['GRE']* df.poly['TOEFL']
df.poly['GRExRating'] <- df.poly['GRE']* df.poly['Rating']
df.poly['GRExSOP'] <- df.poly['GRE']* df.poly['SOP']
df.poly['GRExLOR'] <- df.poly['GRE']* df.poly['LOR']
df.poly['GRExCGPA'] <- df.poly['GRE']* df.poly['CGPA']

df.poly['TOEFLxRating'] <- df.poly['TOEFL']* df.poly['Rating']
df.poly['TOEFLxSOP'] <- df.poly['TOEFL']* df.poly['SOP']
df.poly['TOEFLxLOR'] <- df.poly['TOEFL']* df.poly['LOR']
df.poly['TOEFLxCGPA'] <- df.poly['TOEFL']* df.poly['CGPA']

df.poly['RatingxSOP'] <- df.poly['Rating']* df.poly['SOP']
df.poly['RatingxLOR'] <- df.poly['Rating']* df.poly['LOR']
df.poly['RatingxCGPA'] <- df.poly['Rating']* df.poly['CGPA']

df.poly['SOPxLOR'] <- df.poly['SOP']* df.poly['LOR']
df.poly['SOPxCGPA'] <- df.poly['SOP']* df.poly['CGPA']

df.poly['LORxCGPA'] <- df.poly['LOR']* df.poly['CGPA']

df.poly <- data.frame(scale(df.poly))
head(df.poly)




df.fa.varimax <- factanal(df.poly, factors=2, rotation='varimax',lower = 0.01)


df.fa.varimax$loadings
# varimax is proper

# first factor: GRE > TOEFL > CPGA : higher -> more objective
# second factor: SOP > LOR > Univ.rating > CGPA : higher -> more subjective 

plot(df.fa.varimax$loadings[, 1],
     df.fa.varimax$loadings[, 2],
     xlab = "Factor 1",
     ylab = "Factor 2",
     ylim = c(-1, 1),
     xlim = c(-1, 1),
     main = "Varimax rotation")

text(df.fa.varimax$loadings[, 1] - 0.08,
     df.fa.varimax$loadings[, 2] + 0.08,
     colnames(df.continuous),
     col = "blue")

abline(h = 0, v = 0)


df.fa.wls <- factanal(df.poly, factors=2, rotation='varimax', scores='Bartlett',lower = 0.01)

df.fa.wls$scores -> df.factors2
df.factors2 <- as.data.frame(df.factors2)
df.factors2$target <- df$Chance.of.Admit
head(df.factors2)
cor(df.factors2)


plot(df.factors2$Factor1, df.factors2$target)
plot(df.factors2$Factor2, df.factors2$target)


summary(lm(target~Factor1+Factor2, data=df.factors2))



