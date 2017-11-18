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

# helper 1: converting a char into a int
def atoi(s):
    rtr=0
    for c in s:
        rtr=rtr*10 + ord(c) - ord('0')
    return rtr

def sumLength(lengthList):
    sumLen = 0
    for i in range(len(lengthList)):
        sumLen = sumLen + lengthList[i]
    return sumLen
