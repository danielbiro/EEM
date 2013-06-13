# import libraries
#import numpy as np
import sys

# import local
import eem
import dbeem

# run simulation across sets of parameters
# ========================================

def writesim(amp, period, ssmix, mutrate, popsize, maxtime, db_url, schemaid):
    Pop, avggen = eem.eemsim(amp,period,ssmix,mutrate,popsize,maxtime)
    session, Simulation, Individual = dbeem.simdbsm(db_url=db_url, schemaid=schemaid)

    # write data to db
    # ====================
    sim = Simulation(amp,period,ssmix,mutrate,popsize)
    sim.individuals = []
    for row in Pop:
    	sim.individuals.append(Individual(row[0],row[1],row[2]))
    session.add(sim)
    session.commit()
    session.close()

if __name__ == "__main__":

    args = sys.argv[1:]
    if len(args) < 7:
        print "Usage: python %s ampsize=2 P=25 ssmix=0.9 mutrate=0.1 popsize=1000 maxtime=10**5/2 db_url='sqlite:///:memory:' schemaid=1" % __file__
        sys.exit(-1)

#example: python writesimeem.py 2 25 0.9 0.1 1000 10**5/2 test.db

    sAmp = int(sys.argv[1])
    tPer = int(sys.argv[2])
    sMix = float(sys.argv[3])
    mRat = float(sys.argv[4])
    pSiz = int(sys.argv[5])
    mTim = int(sys.argv[6])
    dbnm = str(sys.argv[7])
    schid  = str(sys.argv[8])

    # filename = None
    # if len(args) == 7:
    #     filename = str(sys.argv[7])
    writesim(sAmp, tPer, sMix, mRat, pSiz, mTim, dbnm, schid)
    sys.exit(0)
