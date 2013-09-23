#!/usr/bin/python

import cProfile
import pstats

import wagbergmod as wbm


cProfile.run('wbm.SimPop()','wbmstats.prof')
p = pstats.Stats('wbmstats.prof')
p.sort_stats('time').print_stats(10)
