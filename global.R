library(dplyr)

grocery_all <- read.csv('Grocery_Store_Locations.csv')
grocery_all$WARD <- gsub('Ward ', '', grocery_all$WARD)
grocery_all$TYPE <- 'grocery'
colnames(grocery_all)[colnames(grocery_all)=="STORENAME"] <- "NAME"

groupmeal_all <- read.csv('Group_Meal_Centers.csv')
groupmeal_all$TYPE <- 'groupmeal'

corner_all <- read.csv('Healthy_Corner_Stores.csv')
corner_all$TYPE <- 'corner'
colnames(corner_all)[colnames(corner_all)=="STORE"] <- "NAME"

farmersmark <- read.csv('Farmers_Markets.csv')
farmersmark$TYPE <- 'farmersmarket'
farmersmark$SNAP <- ifelse(grepl('SNAP', farmersmark$VOUCHERS), 1, 0)
farmersmark$WIC <- ifelse(grepl('WIC', farmersmark$VOUCHERS), 1, 0)
farmersmark$senior <- ifelse(grepl('senior', farmersmark$VOUCHERS), 1, 0)
farmersmark$produceplus <- ifelse(grepl('Produce', farmersmark$VOUCHERS), 1, 0)
farmersmark$EBT <- ifelse(grepl('EBT', farmersmark$VOUCHERS), 1, 0)

byward <- grocery_all %>% group_by(WARD) %>% summarise(count=n())
byward2 <- groupmeal_all %>% group_by(WARD) %>% summarise(count=n())

names <- intersect(names(grocery_all), names(corner_all))
grocery <- select(grocery_all, names)
corner <- select(corner_all, names)
groupmeal <- select(groupmeal_all, names)
farmers <- select(farmersmark, names)
dat <- rbind(grocery, corner, groupmeal, farmers)