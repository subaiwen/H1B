#create a output .csv
if(!file.exists("./data")) {dir.create("./data")}
download.file("https://www.dropbox.com/s/qalyqxdsnx39343/h1b_tidy.csv?dl=1", destfile = "./h1b1.csv", mode = "wb")
h1b <- read_csv("./h1b1.csv")
h1b <- h1b %>%
  select(-1)
write.csv(h1b, "h1b_tidy.csv")
file.remove("./h1b1.csv")
#read tidy data
h1b <- read_csv("./h1b_tidy.csv")