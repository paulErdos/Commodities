#!/usr/bin/python

import os
import re
import sys
import datetime
import numpy as np

def init():
    if len(sys.argv) is not 4:
        print "Usage: $./compute.py start_date end_date commodity_type"
        sys.exit(-1)

    # Check that arguments are formatted properly
    # Check that end date is strictly later than start date

    start_year, start_month, start_day = sys.argv[1].split('-')
    start = datetime.date(int(start_year), int(start_month), int(start_day))

    end_year, end_month, end_day = sys.argv[2].split('-')
    end   = datetime.date(int(end_year), int(end_month), int(end_day))

    if not start < end:
        print "Error: Start date does not precede end date.\n"
        exit(-1)

    return {'start': start, 'end': end, 'ctype': sys.argv[3]}

def read_and_format(ctype):
    table = []

    months = {
        "Jan": 1,
        "Feb": 2,
        "Mar": 3,
        "Apr": 4,
        "May": 5,
        "Jun": 6,
        "Jul": 7,
        "Aug": 8,
        "Sep": 9,
        "Oct": 10,
        "Nov": 11,
        "Dec": 12,
    }

    filename = 'data_' + ctype + '.csv'
    if os.path.isfile(filename):
        with open(filename) as f:
            # Discard the header line
            f.readline()

            for line in f:
                line = line.rstrip()
                date, price = line.split(',')

                # Convert date
                month, day, year = date.split(' ')
                month = months[month]
                date = datetime.date(int(year), month, int(day))

                table.append((date, float(price)))
    return table

def select(start, end, table):
    # Make sure start and end dates are strictly on the table
    if start < (table[-1])[0]:
        print "Error: Start date before earliest datum."
        exit(-1)
    if end > (table[0])[0]:
        print "Error: End date after latest datum."
        exit(-1)

    # Grab the prices we're interested in
    selection = [x[1] for x in table if x[0] >= start and x[0] <= end]
    return selection

Parameters = init()
Table = read_and_format(Parameters['ctype'])
Selection = select(Parameters['start'], Parameters['end'], Table)

mean = np.mean(Selection)
variance = np.var(Selection)

print Parameters['ctype'] + " " + str(mean) + " " + str(variance)
