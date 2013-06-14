# TODO
1. Add new key and foreign key relationship between simulation and individual tables to allow for processing of replicate simulations
1. Implement [config files](http://docs.python.org/2/library/configparser.html) for running simulations
1. Properly parse command line arguments using [argparse](http://docs.python.org/2/library/argparse.html#module-argparse)
1. [Combine](http://blog.vwelch.com/2011/04/combining-configparser-and-argparse.html) configparser and argparse
1. Document simulation id string (e.g. 20130614143909) within config files
1. Implement a test framework such as [doctest](http://docs.python.org/2/library/doctest.html), [unittest](http://docs.python.org/2/library/unittest.html), [pytest](http://pytest.org/latest/), [nose](https://nose.readthedocs.org/en/latest/)
1. Implement code profiling
1. Consider using [BigJob](https://github.com/saga-project/BigJob/wiki/BigJob-Tutorial) [pilot job](http://en.wikipedia.org/wiki/Pilot_job) framework.


# Completed
1. configure for sun grid engine: used [saga](http://saga-project.github.io/) / [saga-python](http://saga-project.github.io/saga-python/). didn't use [pythongrid](https://code.google.com/p/pythongrid/)
1. convert to function (eem.py)
1. write script for parameter scan (parscaneem.py)
1. output sim data to sqlite db e.g. [pyNEURON](http://www.paedia.info/quickstart/simulation.html) (dbeem.py)
1. plot sim data from sqlite db (ploteem.py)
1. Deal with concurrent writing to db (which is not safe on [NFS in sqlite](http://www.sqlite.org/faq.html#q5)) by breaking up files by node or switching to MySQL or PostgreSQL.
1. Reconfigure post param-scan plotting
