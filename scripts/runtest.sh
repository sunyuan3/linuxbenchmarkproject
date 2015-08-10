#!/bin/bash

testsuite=""
config_file=""

export TMPTEMPLATE="/tmp/benchmark-XXXXXXXXXX"
TMP=`mktemp -d $TMPTEMPLATE`
echo TMP= $TMP

usage()
{
	echo usage
}

buildtestsuite()
{
	echo "start to build ${testsuite}"

	case $testsuite in
		stream) 	runcmd=stream100M;
				buildcmd="$CC -O -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream100M";;
		hackbench)	runcmd="src/hackbench"
				buildcmd="cd src && $CC -o hackbench hackbench.c -lpthread -static";;
		*)		echo "invald testsuite name";;
	esac

	cd ${TMP}
	#git clone https://github.com/sunyuan3/linuxbenchmarkproject.git
	cp -rf /tmp/benchmark-b1hquYEWVf/linuxbenchmarkproject ${TMP}/
	cd ${TMP}/linuxbenchmarkproject/testsuites/${testsuite}
	echo pwd=`pwd`
	#docker run -ti -v `pwd`:/project/stream ${buildimage} "cd /project/stream && ${buildcmd}"
	#docker run -ti -v `pwd`:/project/ e6000:2 bash -c "cd /project/ && gcc -O -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream100M"
	#docker run -ti -v `pwd`:/project/ ${buildimage} bash -c "cd /project/ && gcc -O -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream100M"
	docker run -ti -v `pwd`:/project/ ${buildimage} bash -c "cd /project/ && $buildcmd"
	echo "dir:${TMP}/linuxbenchmarkproject/testsuites/${testsuite}"
}

run_testsuite_on_target()
{
	echo "start to run ${testsuite}"
	ssh -C root@${targetip} "mkdir -p ${TMP}"
	scp -r ${TMP}/linuxbenchmarkproject/testsuites/${testsuite} root@${targetip}:${TMP}
	ssh -C root@${targetip} "cd ${TMP}/${testsuite}/ && ./$runcmd > testlog 2>&1"
	scp -r root@${targetip}:${TMP} ${TMP}/testlogdir
	echo "logdir: ${TMP}/testlogdir"
}

main()
{
	while getopts t:hc: arg
	do case $arg in
		t) testsuite=$OPTARG;;
		h) usage;;
		c) config_file=$OPTARG;;
	   esac
	done

	echo "testsuite=$testsuite"
	echo "config_file=$config_file"
	. $config_file
	echo CC=$CC
	echo OS=$OS
	echo config_file=${config_file}
	buildtestsuite
	run_testsuite_on_target
}

main "$@"
