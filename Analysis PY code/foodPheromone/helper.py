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

# helper 2: user command to decide if write matrices into .txt file
def typein_WriteHa(i, matrix):
    writeHa = int(input("Write and save to file? [1--Yes] [2--No]: "))
    if writeHa == 1:
        # filename = input("Enter the file name you want to create1: ")
        # write to file
        print "will write matrix to file!!"
    elif writeHa == 2:
        print "Not writing to file"
    else:
         print "Wrong input! Enter again!"
         typein_WriteHa(i, matrix)
    return writeHa

# helper 3: write a matrix into .txt file
def typein_Write(i, matrix, file):
    print "writing matrix to file!!"
    file.write("tick == %d\n" % i)
    print "tick == %d\n" % i
    np.savetxt(file, matrix)
    file.write("\n")

# helper 4: user command to decide if draw a 3D plot
def draw3DHa(matrixArray):
    drawHa = int(input("Draw 3D-Plot? [1--Yes] [2--No]: "))
    if drawHa == 1:
        print "Draw!"
        draw_tick = int(input("Which tick do you want to draw? : "))
        print "Draw tick = %d\n" % draw_tick
        draw3D(draw_tick, matrixArray)
        draw3DHa(matrixArray)
    elif drawHa == 2:
        print "Don't draw"
    else:
        print "Wrong input! Enter again!"
        draw3DHa(matrixArray)

# helper 5: draw a 3D plot
def draw3D(draw_tick, matrixArray):
    # print "Drawing tick = %d\n" % draw_tick
    # matrix = np.matrix(matrixArray[draw_tick - 450])
    # fig = plt.figure()
    # ax = fig.gca(projection='3d')
    # X = np.arange(-40, 40, 1)
    # Y = np.arange(-40, 40, 1)
    # X, Y = np.meshgrid(X, Y)
    # # matrix[y+40][x+40] = pheromoneAmount
    # Z = matrix[Y+40][X+40]
    # surf = ax.plot_surface(X, Y, Z, rstride=1, cstride=1, cmap=cm.coolwarm,
    #                        linewidth=0, antialiased=False)
    # ax.set_zlim(0, 20)
    #
    # ax.zaxis.set_major_locator(LinearLocator(10))
    # ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))
    #
    # fig.colorbar(surf, shrink=0.5, aspect=5)
    #
    # plt.show()
    # plt.close()
    # plt.savefig("%d_3D.ps" % draw_tick)

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    u = np.linspace(0, 2 * np.pi, 100)
    v = np.linspace(0, np.pi, 100)

    x = 10 * np.outer(np.cos(u), np.sin(v))
    y = 10 * np.outer(np.sin(u), np.sin(v))
    z = 10 * np.outer(np.ones(np.size(u)), np.cos(v))
    ax.plot_surface(x, y, z, rstride=4, cstride=4, color='b')

    plt.show()


def customHa():
    custom = int(input("Want to custom the range to do matrix? [1--No] [2--Yes]"))
    return custom
