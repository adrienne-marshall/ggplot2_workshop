# This script will list a set of packages, check whether you already have them installed, 
# and install them if they are not currently installed.
# It may take several minutes to run.

#List the packages we need.
packages <- c("ggplot2", "dplyr", "data.table", "viridis", "RColorBrewer",
              "wesanderson", "ggthemes", "ggjoy", "gapminder", "maptools")

#Install packages if they are not already installed. 
for(i in 1:length(packages)){
  test <- is.element(packages[i], installed.packages()[,1])
  if(test == FALSE){
    try({
      install.packages(packages[i])
    }) #end of try statement
    } #end of if statement
} # end of package installation



