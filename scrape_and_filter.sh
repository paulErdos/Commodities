#!/bin/bash

# URLs of the pages we want to scrape
url_gold='https://www.investing.com/commodities/gold-historical-data'
url_silver='https://www.investing.com/commodities/silver-historical-data'

# Grab the page source and put it into a file
curl --user-agent "Mozilla/5.0" $url_gold > page_gold
curl --user-agent "Mozilla/5.0" $url_silver > page_silver

# Create files to store the data
echo "Date,Price" > data_gold.csv
echo "Date,Price" > data_silver.csv

# For all the lines in the file, grab the ones that contain "data-real-value"
# For all of those, grab the ones that contain "class"
# For all of those, grab all the ones that don't contain a "%"
# Then remove the HTML tags and commas, replace every other newline with a
# comma and write the results to a file.
cat page_gold | grep data-real-value | grep class | egrep -v "%" | sed 's:[ ]*<[^>]*>::g' | sed 's/,//' | sed 'N;s/\n/,/' >> data_gold.csv
cat page_silver | grep data-real-value | grep class | egrep -v "%" | sed 's:[ ]*<[^>]*>::g' | sed 's/,//' | sed 'N;s/\n/,/' >> data_silver.csv

# Remove the page sources.
rm page_gold page_silver
