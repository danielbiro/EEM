# import libraries
import numpy as np

# import local
import eem
import dbeem

# run simulation across sets of parameters
# ========================================

minamp = 1
maxamp = 3
amps = range(minamp,maxamp)

minperiod = 3
maxperiod = 5
periods = range(minperiod,maxperiod)

minmix = 0.5
maxmix = 0.7
ssmixs = np.arange(minmix,maxmix,0.1)

mutrate = 0.1
popsize = 100
maxtime = 10**3

session, Simulation, Individual = dbeem.simdbsm("jigga.db")

for amp in amps:
	for period in periods:
		for ssmix in ssmixs:
			# run simulation
			Pop, avggen = eem.eemsim(amp,period,ssmix,mutrate,popsize,maxtime)
			
			sim = Simulation(amp,period,ssmix,mutrate,popsize)
			sim.individuals = []
			for row in Pop:
				sim.individuals.append(Individual(row[0],row[1],row[2]))
			session.add(sim)
			session.commit()	
