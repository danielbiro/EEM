# Scripts
1. eem.py - function form of core.py stripped of plotting
1. parscaneem.py - batch script to iterate through parameter values in eem
1. dbeem.py - database model of data output from a batch run of parscaneem
1. ploteem.py - query the database produced by parscaneem and plot data
1. core.py - (may be removed) raw translation of the matlab/octave to python

# Dependencies
## Python
On ubuntu 12.04

    sudo apt-get install python python-dev

currently installs Python 2.7.3 and the necessary development headers for compiling some python packages.

## Python packages
1. [numpy/scipy](http://docs.scipy.org/doc/)
1. [matplotlib](http://matplotlib.org/contents.html)
1. [sqlalchemy](http://docs.sqlalchemy.org/en/rel_0_8/)
1. [saga-python](http://saga-project.github.io/saga-python/)

[pip](http://www.pip-installer.org/en/latest/installing.html#using-get-pip) is the best method for installing these packages.

For site installation
    
    $ curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
    $ [sudo] python get-pip.py

For [instant](http://saga-project.github.io/saga-python/doc/usage/install.html#using-virtualenv) [virtualenv](http://www.virtualenv.org/) installation where there may be no direct access to pip or virtualenv (e.g. on a remote cluster)
    
    $ curl --insecure -s https://raw.github.com/pypa/virtualenv/master/virtualenv.py | python - $HOME/sagaenv
    $ . $HOME/sagaenv/bin/activate

To install dependencies

    $ [sudo] pip install numpy scipy matplotlib sqlalchemy saga-python

Virtualenv (i.e. sagaenv in this case) can be deactivated with

    (sagaenv)$ deactivate

but it needs to be active to make use of the libraries it contains.

# Cluster information

For Python 2.7.3 you may need to add something like
  
    PATH=/apps1/python/2.7.3/intel/bin:$PATH

to your .bash_profile file on your remote cluster.

For e-mail notification of job completion add a .sge_request file to your home directory on the cluster with contents
    
    -m e
	-M user@host.ext