# Scripts
1. eem.py - function form of core.py stripped of plotting
1. parscaneem.py - batch script to iterate through parameter values in eem
1. dbeem.py - database model of data output from a batch run of parscaneem
1. ploteem.py - query the database produced by parscaneem and plot data

1. core.py - (may be removed) raw translation of the matlab/octave to python

# Dependencies
1. [numpy/scipy](http://docs.scipy.org/doc/)
1. [matplotlib](http://matplotlib.org/contents.html)
1. [sqlalchemy](http://docs.sqlalchemy.org/en/rel_0_8/)
1. [saga-python](http://saga-project.github.io/saga-python/)

Install [pip](http://www.pip-installer.org/en/latest/installing.html#using-get-pip)
```$ curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
$ [sudo] python get-pip.py```

Then install dependencies
```$ [sudo] pip install numpy scipy matplotlib sqlalchemy saga-python```