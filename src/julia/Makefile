.PHONY: default parallel clean test

#---------------------------------------------
# Define variables

# list of automatic variables
# http://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables
SHELL=/bin/bash
TOPFILE=main.jl
TESTFILE=run_tests.jl
PARDEP=parload.jl

#---------------------------------------------
# Default target
# will run with
# >make
# alone

default:
	cd src; julia $(TOPFILE); cd ..

parallel:
	declare -i PNUM; \
	export PNUM=`nproc`-2; \
	cd src; \
	/usr/bin/time -f "%E real\n%U user\n%S sys\n%K memory (kB)" \
	julia -p $(PNUM) -L $(PARDEP) $(TOPFILE); \
	cd ..

#----------------------------------------------
# Additional targets

clean:
	rm -rf output/*

test:
	julia $(TESTFILE)

#---------------------------------------------
