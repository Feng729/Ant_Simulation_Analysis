# Calculate MEAN PATH LENGTH

import csv, sys, argparse
import os
import numpy as np
from array import *
import locale
import numbers
import glob
import decimal
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import matplotlib.pyplot as plt
import pylab as pl
from helper import *

tick = []
xList = []
yList = []
pheromoneAmount = []
rowList = []
tickList = []
length = []
lengthList = []
csvfileList = []
sim_index = 953

np.set_printoptions(threshold='nan')

csvfile = csv.reader(open('/Users/wangyaofeng/Desktop/Ant_Research/Data_Files/3/Mean Path Length.csv', 'r'),
                            delimiter=",", quotechar='|')


# create sorted array for tick column
for row in csvfile:
    rowList.append(row)  # create the array of rows

# create an all tick value
for i in range (0, 11):
    rowList.pop(0)

print("len(rowList) is %d \n" % len(rowList))

# for i in range(0,len(rowList)):
#     print(i)
#     print(len(rowList))
#     print("innnnndex = %d" % sim_index)
#     print("rowList[i][0] = %s" % rowList[i][0])
#     if rowList[i][0] == '"Current Sim: "':
#         sim_index = atoi(rowList[i][1]) - 1
#         print("sim_index = %d\n" % sim_index)
#         tickList.append(tick)
#     else:
#         tickList[sim_index].append(float(rowList[i][0]))
# print(tickList)
for i in range(0,279):
    print(i)
    print(len(rowList))
    print("innnnndex = %d" % sim_index)
    print("rowList[i][0] = %s" % rowList[i][0])
    if rowList[i][0] == '"Current Sim: "':
        sim_index = atoi(rowList[i][1]) - 1
        print("sim_index = %d\n" % sim_index)
        tickList.append(tick)
    else:
        tickList[sim_index].append(float(rowList[i][0]))
print(tickList)

for i in range(len(rowList)):
    length.append(rowList[i][1])
for i in range(len(length)):
    length[i] = float(length[i])
print("Received lengh")
lengthList.append(length)
# print(lengthList)

print(sumLength(lengthList[0]))
print(sumLength(lengthList[1]))
print(sumLength(lengthList[2]))


filename = "newfile.txt"
file = open(filename, "a")

file.write("Calculate the mean path length of EACH SIMULATIONS base on ALL TICKS:\n")
for i in range(len(csvfileList)):
    a = i+1
    file.write("csv file NO.%d:\n" % a)
    sumlen = sumLength(lengthList[i])
    file.write("The sum of mean path length is %f\n" % sumlen)
    file.write("The amount of ticks is %d\n" % len(tickList[i]))
    meanLen_Tick = sumlen / len(tickList[i])
    file.write("The mean path length base on ticks is %f\n\n" % meanLen_Tick)

file.write("----------------------------------------------------------------\n\n")

file.write("Calculate the mean path length of EACH TICKS base on ALL SIMULATIONS:")

file.close()

# x= tickList
# y= length
pl.plot(tickList[0], lengthList[0])
pl.plot(tickList[1], lengthList[1])
pl.plot(tickList[2], lengthList[2])

pl.show()
