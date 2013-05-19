import sys
import os
import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as sps
from itertools import chain

import dbeem as db

#binary flags
plotend = 1
saveplot = 1 
showplot = 0

simids = db.session.query(db.Simulation.id).all()
simids = list(chain.from_iterable(simids))

for i in simids:
	rows = db.session.query\
			(db.Individual.proportion, db.Individual.mean, db.Individual.std).\
			filter_by(simulation_id=i).all()
	Pop = zip(*rows)
	Pop = np.array([tuple(j) for j in Pop])

	# plot
	# ============================
	if plotend:
	    # make directory for figure output
	    if saveplot:
	        figdir = "fig"
	        
	        if not os.path.exists(figdir):
	            os.makedirs(figdir)

        	nameroot = "sim" + str(i)
	    #define font size
	    plt.rc("font", size=20)
	    plt.rc("text", usetex=True)
	    # figure(2)
	    # fig1 = plt.figure(1)
	    # f1p1 = plt.plot(avggen,linestyle='none',marker='o',mec='r',mfc='r')
	    
	    # if saveplot:
	    #     plt.savefig(figdir + '/avggen')

	    #     if showplot:
	    #         plt.show()

	    # figure(3)
	    fig2 = plt.figure(2)
	    I = np.argsort(Pop[:,2])
	    f2p1 = plt.stem(Pop[I,2], Pop[I,0], linefmt='b-', markerfmt='bo', basefmt='r-')
	    
	    if saveplot:
	        plt.savefig(figdir + '/' + nameroot + 'stem')

	        if showplot:
	            plt.show()

	    # # figure(4)
	    # fig3 = plt.figure(3)
	    # f3p1 = plt.plot(Env[1:50],linestyle='none',marker='o',mec='k',mfc='k')
	    # if saveplot:
	    #     plt.savefig(figdir + '/envshort')

	    #     if showplot:
	    #         plt.show()

	    # # figure(5)
	    # fig4 = plt.figure(4)
	    # f4p1 = plt.plot(Env,linestyle='none',marker='o',mec='k',mfc='k')
	    # if saveplot:
	    #     plt.savefig(figdir + '/envlong')

	    #     if showplot:
	    #         plt.show()