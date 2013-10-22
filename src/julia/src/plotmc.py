#!/usr/bin/env python

"""
plotmc.py

Read data from csv file
into pandas dataframe, filter, and
plot data

input: DATA-FILENAME.csv
output: OUTPUT-FILENAME.pdf
"""

import os
import sys
import argparse
import subprocess
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import rc
import pandas as pd
#import d3py

def readdata(filename,printlevel=0):
    """
    input: filehandle
    output: dataframe object containing data from filename
    """

    fhandle = open(filename,'r')
    datframe = pd.read_csv(fhandle,error_bad_lines=False)
    fhandle.close()

    if printlevel:
        print datframe
        print datframe['first_name']
        print datframe.describe()
        print 'number of columns: ' + str(datframe.columns.size)
        print datframe.columns.tolist()

    return datframe

def main(argv):
    # Read the arguments
    parser = argparse.ArgumentParser(description="Plot data from csv file")
    parser.add_argument('-d', '--data-directory', type=str,
            help="the directory for reading and writing data", required=True)
    options = parser.parse_args(argv[1:])

    df = readdata(os.path.join(options.data_directory,"sim.csv"))

    rc('text', usetex=True)
    rc('font', family='serif')


    fig1=plt.figure(num=1,figsize=(12,9),facecolor='w')
    ax1f1 = fig1.add_subplot(111)
    ax1f1.set_ylabel('count',
                     fontsize=30,labelpad=20,fontweight='normal')
    ax1f1.set_xlabel('minimum description length (bits)',fontsize=30,labelpad=10)
    ax1f1.tick_params(axis='both', which='major', labelsize=30)
    plt.grid(True)
    df.hist(column=["modularity","environment"], by="environment",ax=ax1f1, sharex=True, sharey=True, bins=75)

    output_filename = os.path.join(options.data_directory,"env.pdf")
    plt.savefig(output_filename,bbox_inches='tight',
        facecolor=fig1.get_facecolor(), edgecolor='none')
    plt.close()

    #vnc = subprocess.check_output(["evince",options.output_filename])

if __name__ == "__main__":
    main(sys.argv)
