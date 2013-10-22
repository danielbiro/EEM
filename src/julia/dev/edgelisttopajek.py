#!/usr/bin/env python

"""
edgelisttopajek.py

Read data from tsv file
containing a linklist i.e.

node1 node2 weight
1       2   1.75

export pajek file

input: DATA-FILENAME.tsv
output: OUTPUT-FILENAME.net
"""

# import os
import sys
import argparse
import networkx as nx
# import subprocess
# import numpy as np
# import matplotlib.pyplot as plt
# from matplotlib import rc
# import pandas as pd
#import d3py

def readdata(filename,printlevel=0):
    """
    input: filename
    output: graph
    """
    G=nx.read_edgelist(filename,delimiter='\t',data=(('weight',float),),
                        create_using=nx.DiGraph())

    return G

def main(argv):
    # Read the arguments
    parser = argparse.ArgumentParser(description="Convert linklist to Pajek format")
    parser.add_argument('-d', '--data-filename', type=str,
            help="the .tsv file to use as the source", required=True)
    parser.add_argument('-o', '--output-filename', type=str,
            help="the .net output file", required=True)
    options = parser.parse_args(argv[1:])

    G = readdata(options.data_filename)
    nx.write_pajek(G,options.output_filename)


if __name__ == "__main__":
    main(sys.argv)
