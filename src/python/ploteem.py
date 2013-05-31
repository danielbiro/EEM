# import libraries
import sys
import os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
#import scipy.stats as sps
from itertools import chain

# import local
import dbeem

def ploteem(figdir="fig",plotend=1,saveplot=1,showplot=0):
		
	# binary flags
	# plotend = 1
	# saveplot = 1 
	# showplot = 0

	session, Simulation, Individual = dbeem.simdbsm(psqlflag=1,schemaflag=0,jobid=1)

	simids = session.query(Simulation.id).all()
	simids = list(chain.from_iterable(simids))

	for i in simids:
		rows = session.query\
				(Individual.proportion, Individual.mean, Individual.std).\
				filter_by(simulation_id=i).all()
		Pop = zip(*rows)
		Pop = np.array([tuple(j) for j in Pop])

		# plot
		# ============================
		if plotend:
		    # make directory for figure output
		    if saveplot:
		        #figdir = "fig"
		        
		        if not os.path.exists(figdir):
		            os.makedirs(figdir)

	        	nameroot = "sim" + str(i)
		    #define font size
		    plt.rc("font", size=20)
		    #plt.rc("text", usetex=True)
		    plt.rc("text", usetex=False)
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
if __name__ == "__main__":

    args = sys.argv[1:]
    if len(args) < 1:
        print "Usage: python %s figdirpath" % __file__
        sys.exit(-1)
    
    fDir = str(sys.argv[1])
    #pEnd = int(sys.argv[2])
    #saPl = int(sys.argv[3])
    #shPl = int(sys.argv[4])
    
    # filename = None 
    # if len(args) == 7:
    #     filename = str(sys.argv[7])
    #ploteem(fDir,pEnd,saPl,shPl)
    ploteem(figdir=fDir)
    sys.exit(0)