#!/bin/bash

#########test file 4GB,and block size:4KB#######
rm -f ./tiobench.log
for i in 1 2 4 8;do
	echo "-----------file :4GB,block size:4KB,threads:$i---------" >> ./tiobench.log
	./tiotest -b 4096 -r 10000 -t $i -f 4096 >> ./tiobench.log
done

#########test file 4GB,and block size:32KB#######
for i in 1 2 4 8;do
        echo "-----------file :4GB,block size:32KB,threads:$i---------" >> ./tiobench.log
        ./tiotest -b 32768 -r 10000 -t $i -f 4096 >> ./tiobench.log
done

exit 0
