# TODO
1. Deal with concurrent writing to db (which is not safe on [NFS in sqlite](http://www.sqlite.org/faq.html#q5)) by breaking up files by node or switching to MySQL or PostgreSQL.
1. Add db class for avggen
1. Reconfigure post param-scan plotting

# Completed
1. configure for sun grid engine: used [saga](http://saga-project.github.io/) / [saga-python](http://saga-project.github.io/saga-python/). didn't use [pythongrid](https://code.google.com/p/pythongrid/)
1. convert to function (eem.py)
1. write script for parameter scan (parscaneem.py)
1. output sim data to sqlite db e.g. [pyNEURON](http://www.paedia.info/quickstart/simulation.html) (dbeem.py)
1. plot sim data from sqlite db (ploteem.py)


