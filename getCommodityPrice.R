#!/usr/bin/local/r

args = commandArgs(trailingOnly=TRUE)
start_date = as.Date(args[[1]], format='%Y-%m-%d')
end_date   = as.Date(args[[2]], format='%Y-%m-%d')

filename = paste("data_", args[[3]], ".csv", sep="")

commodity = read.csv(filename, stringsAsFactors=FALSE)
dates = commodity[1]
prices = commodity[2]
selected_prices <- prices
for (i in 1:length(commodity[[1]])) {
    current_date = as.Date(commodity[[1]][i], format='%b %d %Y')
    if(current_date < start_date || current_date > end_date) {
        selected_prices[[1]][i] <- 0
    }
}

cond = sapply(selected_prices, function(x) x > 0)
mean = mean(selected_prices[cond])
variance = var(selected_prices[cond])

print(args[[3]])
print("Mean:")
print(mean)
print("Variance (sample variance):")
print(variance)

#output = paste(args[[3]], mean, variance)
#print(output)
