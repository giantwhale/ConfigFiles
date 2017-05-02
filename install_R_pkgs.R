install <- function(pkg) {
    install.packages(pkg, repos="https://cloud.r-project.org")
}

install("Rcpp")
install("BH")
install("data.table")
install("plyr")
install("dplyr")
install("dtplyr")
install("ggplot2")
install("gridExtra")
