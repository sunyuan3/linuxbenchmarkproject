#!/bin/bash

for i in 1 2 3 5 10 20;do
	echo "--------pipe process num=$i----------" >> ./hackbench.log
	for j in $(seq 1 10);do
		./hackbench -pipe $i process 1000 >> ./hackbench.log
	done
done

for i in 1 2 3 5 10 20;do
	echo "--------pipe thread num=$i----------" >> ./hackbench.log
        for j in $(seq 1 10);do           
                ./hackbench -pipe $i thread 1000 >> ./hackbench.log            
        done
done

for i in 1 2 3 5 10 20;do
	echo "--------socket process num=$i----------" >> ./hackbench.log
        for j in $(seq 1 10);do           
                ./hackbench  $i process 1000 >> ./hackbench.log            
        done
done

for i in 1 2 3 5 10 20;do
	echo "--------socket thread num=$i----------" >> ./hackbench.log
        for j in $(seq 1 10);do           
                ./hackbench $i thread 1000 >> ./hackbench.log            
        done
done
