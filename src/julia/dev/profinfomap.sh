#!/bin/bash

for i in {1..500}
do
   ../bin/infomap modgraph.txt . -i link-list -N 10 --directed -w -0 | grep -Po "((?<=Codelengths for 10 trials: )\[.*\])|(?<=total:\s{10})\[.*\]"
done
