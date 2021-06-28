#Kai Man Jim S133AU
#Sami Eljabali S133BQ
#Statistics 133 Project 1
#4/3/2008

# load in the csv spreadsheet that we got from the website.
data = read.csv(file="data.csv")

# creating three different data frame, which are Humor, Animals, and 
# Celebrities.
Humor=data.frame(data[c(2:11)], data$Humor)
Animals=data.frame(data[c(2:11)], data$Animals)
Celebrities=data.frame(data[c(2:11)], data$Celebrities)

# create a table that doesn't have Humor, Animals, and Celebrities.
Table = data[c(2:11)]

# and then we have a column with sum of every row in Table.
sumTable = apply(Table, 1, sum)

# create function calls
# AvgRow is a helper function which calculates the average of an specific
# item with respect to all items in that row.  
AvgRow <- function (sumtable, type, category, index){
return <- type[index] / sumtable[index] * category[index]
return
}

# AvgType is the main function which calls AvgRow and loop 25 times to 
# calculate an average for a certain item from year 1984 to 2008.
AvgType <- function (sumtable, type, category){
arg = 0
for ( i in 1:25){
arg = arg + AvgRow(sumtable, type, category, i)
}
return <- arg / 25
return 
}

# we create 30 variables and have them to store the value of each item 
# with respect to Humor, Animals, and Celebrities.
totalHumorVehicles = AvgType(sumTable, Humor$Vehicles, Humor$data.Humor)
totalHumorTech = AvgType(sumTable, Humor$Tech.Financial, Humor$data.Humor)
totalHumorFood = AvgType(sumTable, Humor$Food, Humor$data.Humor)
totalHumorFilms = AvgType(sumTable, Humor$Films, Humor$data.Humor)
totalHumorApparel = AvgType(sumTable, Humor$Apparel, Humor$data.Humor)
totalHumorConsumer = AvgType(sumTable, Humor$Consumer.goods, Humor$data.Humor)
totalHumorTravel = AvgType(sumTable, Humor$Travel, Humor$data.Humor)
totalHumorDrugs = AvgType(sumTable, Humor$Drugs, Humor$data.Humor)
totalHumorCredit = AvgType(sumTable, Humor$Credit.cards, Humor$data.Humor)
totalHumorBeverages = AvgType (sumTable, Humor$Beverages, Humor$data.Humor)

totalCelebritiesVehicles = AvgType(sumTable, Celebrities$Vehicles, Celebrities$data.Celebrities)
totalCelebritiesTech = AvgType(sumTable, Celebrities$Tech.Financial, Celebrities$data.Celebrities)
totalCelebritiesFood = AvgType(sumTable, Celebrities$Food, Celebrities$data.Celebrities)
totalCelebritiesFilms = AvgType(sumTable, Celebrities$Films, Celebrities$data.Celebrities)
totalCelebritiesApparel = AvgType(sumTable, Celebrities$Apparel, Celebrities$data.Celebrities)
totalCelebritiesConsumer = AvgType(sumTable, Celebrities$Consumer.goods, Celebrities$data.Celebrities)
totalCelebritiesTravel = AvgType(sumTable, Celebrities$Travel, Celebrities$data.Celebrities)
totalCelebritiesDrugs = AvgType(sumTable, Celebrities$Drugs, Celebrities$data.Celebrities)
totalCelebritiesCredit = AvgType(sumTable, Celebrities$Credit.cards, Celebrities$data.Celebrities)
totalCelebritiesBeverages = AvgType(sumTable, Celebrities$Beverages, Celebrities$data.Celebrities)

totalAnimalTech = AvgType(sumTable, Animals$Tech.Financial , Animals$data.Animals)
totalAnimalVehicles = AvgType(sumTable, Animals$Vehicles, Animals$data.Animals)
totalAnimalApparel = AvgType(sumTable, Animals$Apparel , Animals$data.Animals)
totalAnimalBeverages = AvgType(sumTable, Animals$Beverages , Animals$data.Animals)
totalAnimalTravel = AvgType(sumTable, Animals$Travel , Animals$data.Animals)
totalAnimalFood = AvgType(sumTable, Animals$Food , Animals$data.Animals)
totalAnimalCredit = AvgType(sumTable, Animals$Credit , Animals$data.Animals)
totalAnimalDrugs = AvgType(sumTable, Animals$Drugs , Animals$data.Animals)
totalAnimalFilms = AvgType(sumTable, Animals$Films , Animals$data.Animals)
totalAnimalConsumer = AvgType(sumTable,Animals$Consumer.goods , Animals$data.Animals)
# Done with storing all values into 30 variables.

# calculate the total for variables with respect to their categories.
# summation for Animal items.
totalAnimal = sum(totalAnimalTech, totalAnimalVehicles, totalAnimalApparel, totalAnimalBeverages, totalAnimalTravel, totalAnimalFood, totalAnimalCredit, totalAnimalDrugs, totalAnimalFilms, totalAnimalConsumer)

# summation for Humor items.
totalHumor = sum (totalHumorVehicles, totalHumorTech, totalHumorFood, totalHumorFilms, totalHumorApparel,
totalHumorConsumer, totalHumorTravel, totalHumorDrugs, totalHumorCredit, totalHumorBeverages)

# summation for Celebrities items.
totalCelebrities = sum (totalCelebritiesVehicles, totalCelebritiesTech, totalCelebritiesFood, totalCelebritiesFilms, totalCelebritiesApparel, totalCelebritiesConsumer, totalCelebritiesTravel, totalCelebritiesDrugs, totalCelebritiesCredit, totalCelebritiesBeverages)

# create a vector to for each category
# vector for Animal
pieAnimal = c("Tech/Financial" = totalAnimalTech/totalAnimal, 
"Vehicles" = totalAnimalVehicles/totalAnimal,
"Apparel" = totalAnimalApparel/totalAnimal,
"Beverages" = totalAnimalBeverages/totalAnimal,
"Travel" = totalAnimalTravel/totalAnimal,
"Food" = totalAnimalFood/totalAnimal,
"Credit cards" = totalAnimalCredit/totalAnimal,
"Drugs" = totalAnimalDrugs/totalAnimal,
"Films" = totalAnimalFilms/totalAnimal,
"Consumer goods" = totalAnimalConsumer/totalAnimal)

# vector for Humor
pieHumor = c("Tech/Financial" = totalHumorTech/totalHumor,
"Vehicles" = totalHumorVehicles/totalHumor,
"Apparel" = totalHumorApparel/totalHumor,
"Beverages" = totalHumorBeverages/totalHumor,
"Travel"=totalHumorTravel/totalHumor,
"Food" = totalHumorFood/totalHumor,
"Credit cards" = totalHumorCredit/totalHumor,
"Drugs" = totalHumorDrugs/totalHumor,
"Films" = totalHumorFilms/totalHumor,
"Consumer goods" = totalHumorConsumer/totalHumor)

# vector for Celebrities
pieCelebrities = c("Tech/Financial" = totalCelebritiesTech/totalCelebrities,
"Vehicles" = totalCelebritiesVehicles/totalCelebrities,
"Apparel" = totalCelebritiesApparel/totalCelebrities,
"Beverages" = totalCelebritiesBeverages/totalCelebrities,
"Travel" = totalCelebritiesTravel/totalCelebrities,
"Food" = totalCelebritiesFood/totalCelebrities,
"Credit cards" = totalCelebritiesCredit/totalCelebrities,
"Drugs" = totalCelebritiesDrugs/totalCelebrities,
"Films" = totalCelebritiesFilms/totalCelebrities,
"Consumer goods" = totalCelebritiesConsumer/totalCelebrities)

# creating piechart for three vectors above and save them as png file.
png("Humor.png")
pie(pieHumor, main = "Humor")
dev.off()

png("Animals.png")
pie(pieAnimal, main ="Animals")
dev.off()

png("Celebrities.png")
pie(pieCelebrities, main = "Celebrities")
dev.off()

# create a vector called bargraph which contains the average for each category column
 bargraph = c("Humor" = mean (data$Humor), "Celebrities" = mean (data$Celebrities), "Animals" = mean (data$Animals))

# create a barplot for this bargraph
png("bargraph.png")
barplot (bargraph, ylab="Total Use of Tactics")
dev.off()
