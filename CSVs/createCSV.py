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


# For File in Passed Directory
for file in os.listdir('./' + movie):
    # If file is ".json"
    if file.endswith(".json"):
        # Get File Data
        data = json.load(open('./' + movie + '/' + file))
        total = 0
        # For Key,Value in Data
        for key, value in data.items():
            # Add Value to Array
            array[total].append(value)

            total += 1


total_time = 0

# If only 2 active
if(len(array[0]) == 2):
    for x in array:
        CSV += '"' + str(total_time) + '",' + '"' + str(x[0]) + '",' + '"' + str(x[1]) + '"'
        CSV += '\n'
        # CSV = CSV[:-1]
        total_time += 2

# If only 3 active
elif(len(array[0]) == 3):
    for x in array:
        CSV += '"' + str(total_time) + '",' + '"' + str(x[0]) + '",' + '"' + str(x[1]) + '",' + '"' + str(x[2]) + '"'
        CSV += '\n'
        # CSV = CSV[:-1]
        total_time += 2

# If only 4 active
elif(len(array[0]) == 4):
    for x in array:
        CSV += '"' + str(total_time) + '",' + '"' + str(x[0]) + '",' + '"' + str(x[1]) + '",' + '"' + str(x[2]) + '",' + '"' + str(x[3]) + '"'
        CSV += '\n'
        # CSV = CSV[:-1]
        total_time += 2

# If only 5 active
elif(len(array[0]) == 5):
    for x in array:
        CSV += '"' + str(total_time) + '",' + '"' + str(x[0]) + '",' + '"' + str(x[1]) + '",' + '"' + str(x[2]) + '",' + '"' + str(x[3]) + '",' + '"' + str(x[3]) + '"'
        CSV += '\n'
        # CSV = CSV[:-1]
        total_time += 2



# print(array)

'''''''''''''''''''''
PRINT CSV
'''''''''''''''''''''
CSV_out_file = open('./' + movie + '/' + movie + '.csv', 'w')
CSV_out_file.write(CSV)
CSV_out_file.close()




# END - getInstitutions.py