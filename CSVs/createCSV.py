# get_ACGME_Institutions.py


'''
------------------------------
IMPORTS
------------------------------
'''

# JSON 
import json
# CSV Reads
# https://pandas.pydata.org/pandas-docs/stable/generated/pandas.read_csv.html
import pandas
import os
import sys


'''
---------------------------
MAIN
---------------------------
'''

# CSV String
CSV = ''

total = 0

movie = sys.argv[1]
print(movie)

TITLES = '"Time",'

array = []
array_length = 0

for file in os.listdir('./' + movie):
    if file.endswith(".json"):
        name = file
        name = name.split('.json')
        
        name = name[0]
        print(name)
        TITLES += '"' + name.title() + '",'
        # For Array Length
        data = json.load(open('./' + movie + '/' + file))

        array_length = data.items()

        array = [[] for i in range(len(array_length))]

TITLES = TITLES[:-1]

TITLES += '\n'

CSV += TITLES



for file in os.listdir('./' + movie):
    if file.endswith(".json"):

        data = json.load(open('./' + movie + '/' + file))
        total = 0

        for key, value in data.items():
            # print(key)
            # CSV += '"' + str(total) + '",' + '"' + str(value) + '",' + '"' + str(value) + '",'
            # CSV = CSV[:-1]
            # CSV += '\n'
            # print(total)
            array[total].append(value)

            total += 1



 # Remove final ',' from CSV String
total_time = 0

if(len(array[0]) == 2):
    for x in array:
        CSV += '"' + str(total_time) + '",' + '"' + str(x[0]) + '",' + '"' + str(x[1]) + '"'
        CSV += '\n'

        total_time += 2



# print(array)

'''''''''''''''''''''
PRINT CSV
'''''''''''''''''''''
CSV_out_file = open(movie + '.csv', 'w')
CSV_out_file.write(CSV)
CSV_out_file.close()




# END - getInstitutions.py