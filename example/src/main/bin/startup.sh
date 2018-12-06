#!/bin/bash 

current_path=`pwd`
case "`uname`" in
    Linux)
		bin_abs_path=$(readlink -f $(dirname $0))
		;;
	*)
		bin_abs_path=`cd $(dirname $0); pwd`
		;;
esac
base=${bin_abs_path}/..
client_mode="Cluster"
logback_configurationFile=$base/conf/logback.xml

canal_destination=example
canal_zookeeper=127.0.0.1:2181
canal_batch_size=5120
canal_sleep_time=1
canal_ip=127.0.0.1
canal_port=11111

export LANG=en_US.UTF-8
export BASE=$base

if [ -f $base/conf/canal.pid ] ; then
	echo "found canal.pid , Please run stop.sh first ,then startup.sh" 2>&2
    exit 1
fi

## set java path
if [ -z "$JAVA" ] ; then
  JAVA=$(which java)
fi

ALIBABA_JAVA="/usr/alibaba/java/bin/java"
TAOBAO_JAVA="/opt/taobao/java/bin/java"
if [ -z "$JAVA" ]; then
  if [ -f $ALIBABA_JAVA ] ; then
  	JAVA=$ALIBABA_JAVA
  elif [ -f $TAOBAO_JAVA ] ; then
  	JAVA=$TAOBAO_JAVA
  else
  	echo "Cannot find a Java JDK. Please set either set JAVA or put java (>=1.5) in your PATH." 2>&2
    exit 1
  fi
fi

case "$#" 
in
0 ) 
	;;
1 )	
	client_mode=$*
	;;
2 )	
	if [ "$1" = "debug" ]; then
		DEBUG_PORT=$2
		DEBUG_SUSPEND="y"
		JAVA_DEBUG_OPT="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=$DEBUG_PORT,server=y,suspend=$DEBUG_SUSPEND"
	else 
		client_mode=$1
 	fi;;
* )
	echo "THE PARAMETERS MUST BE TWO OR LESS.PLEASE CHECK AGAIN."
	exit;;
esac

str=`file $JAVA_HOME/bin/java | grep 64-bit`
if [ -n "$str" ]; then
	JAVA_OPTS="-server -Xms2048m -Xmx3072m -Xmn1024m -XX:SurvivorRatio=2 -XX:PermSize=96m -XX:MaxPermSize=256m -Xss256k -XX:-UseAdaptiveSizePolicy -XX:MaxTenuringThreshold=15 -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:+HeapDumpOnOutOfMemoryError"
else
	JAVA_OPTS="-server -Xms1024m -Xmx1024m -XX:NewSize=256m -XX:MaxNewSize=256m -XX:MaxPermSize=128m "
fi

JAVA_OPTS=" $JAVA_OPTS -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8"
CANAL_OPTS="-DappName=otter-canal-example -Dlogback.configurationFile=$logback_configurationFile"
CANAL_OPTS="$CANAL_OPTS -Dcanal.destination=${canal_destination} -Dcanal.zookeeper=${canal_zookeeper} -Dcanal.batch.size=${canal_batch_size} -Dcanal.sleep.time=${canal_sleep_time} -Dcanal.ip=${canal_ip} -Dcanal.port=${canal_port}"

if [ -e $logback_configurationFile ]
then 
	
	for i in $base/lib/*;
		do CLASSPATH=$i:"$CLASSPATH";
	done
 	CLASSPATH="$base/conf:$CLASSPATH";
 	
 	echo "cd to $bin_abs_path for workaround relative path"
  	cd $bin_abs_path
 	
	echo LOG CONFIGURATION : $logback_configurationFile
	echo client mode : $client_mode 
	echo CLASSPATH :$CLASSPATH
	if [ $client_mode == "Cluster" ] ; then 
		$JAVA $JAVA_OPTS $JAVA_DEBUG_OPT $CANAL_OPTS -classpath .:$CLASSPATH com.alibaba.otter.canal.example.ClusterCanalClientTest 1>>$base/logs/metric.log 2>&1 &
	else 
		$JAVA $JAVA_OPTS $JAVA_DEBUG_OPT $CANAL_OPTS -classpath .:$CLASSPATH com.alibaba.otter.canal.example.SimpleCanalClientTest 1>>$base/logs/metric.log 2>&1 &
	fi
	
	echo $! > $base/conf/canal.pid 
	echo "cd to $current_path for continue"
  	cd $current_path
else 
	echo "client mode("$client_mode") OR log configration file($logback_configurationFile) is not exist,please create then first!"
fi
