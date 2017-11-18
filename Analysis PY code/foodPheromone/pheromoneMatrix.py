# get food pheromone matrices for each second
# 000000000000000000
# 00000xxxxx0000000
# 00xxx00000xxxx000
# 00000000000000xxx
# 00000000000000000
# 00000000000000000
#
# draw 3D graph for the one matrix

import csv, sys, argparse
import os
import numpy as np
from array import *
import locale
import numbers
import decimal
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import matplotlib.pyplot as plt
from helper import *

np.set_printoptions(threshold='nan')

csvfile = csv.reader(open('/Users/wangyaofeng/Desktop/Ant_Research/Data_Files/Food pheromone record 01.31.12 PM 05-Dec-2016.csv', 'r'),
                            delimiter=",", quotechar='|')
tick = []
xList = []
yList = []
pheromoneAmount = []
rowList = []
tickList=[]



# create sorted array for tick column
for row in csvfile:
    rowList.append(row)  # create the array of rows
    tick.append(row[0])  # create the array of tick column

# create an all tick value
for i in range (0, 11):
    tick.pop(0)
    rowList.pop(0)
tickSet = set(tick)
# print tickSet
tickList = list(tickSet)

# create integer list
for i in range(len(tickList)):
    tickList[i] = atoi(tickList[i])
print "created integer tick list:"
# sort the tickList
tickList.sort()
print "Sorted tick list:"
# print tickList
matrix = np.zeros((81, 81))  # declare an empty matrix to store values

writeHa = typein_WriteHa(i, matrix) # 1 == write file
if writeHa == 1:
    filename = "newfile.txt"
    file = open(filename, "a")

custom = customHa()
if custom == 1:
    range1 = 450
    range2 = 501
elif custom == 2:
    range1 = int(input("create matrix from : "))
    range2 = int(input("create matrix to : "))
else:
    print "Wrong input! enter again!"
    customHa()

print range1
print range2

for i in range(range1, range2):
    print "i == %d" % i
    print "creating new matrix!!"
    for row in rowList:
        # print "row"
        # print row[0]
        if atoi(row[0]) == i:
            pheromoneAmount = float(row[3])
            # print "pheromoneAmount is %f" % pheromoneAmount
            format(pheromoneAmount, '.5f')
            x = float(row[1])
            # print "x-axis is %d" % float(row[1])
            y = float(row[2])
            # print "y-axis is %d" % float(row[2])
            matrix[y+40][x+40] = pheromoneAmount  # store the pheromone value in matrix
        if  atoi(row[0]) == i+1:
            # print "row[0] is %d " % atoi(row[0])
            # print "going to break!"
            break
    if np.count_nonzero(matrix) != 0:
        print np.count_nonzero(matrix)
        matrixArray = np.array([])
        matrixArray = np.append(matrixArray,matrix)
        # print matrixArray
        if writeHa == 1:
            typein_Write(i, matrix, file) # Write a matrix!

draw3DHa(matrixArray)

if writeHa == 1:
    file.close()
