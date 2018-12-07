@echo off
@if not "%ECHO%" == ""  echo %ECHO%
@if "%OS%" == "Windows_NT"  setlocal

set ENV_PATH=.\
if "%OS%" == "Windows_NT" set ENV_PATH=%~dp0%

set conf_dir=%ENV_PATH%\..\conf
set logback_configurationFile=%conf_dir%\logback.xml
set client_mode=Cluster
if "%1%" != "" set client_mode=%1%

set canal_destination=example
set canal_zookeeper=127.0.0.1:2181
set canal_batch_size=5120
set canal_sleep_time=1
set canal_ip=127.0.0.1
set canal_port=11111
set canal_metric_period=5
set canal_metric_debug=true
set canal_dump_debug=false
set canal_parse_debug=false

set CLASSPATH=%conf_dir%
set CLASSPATH=%conf_dir%\..\lib\*;%CLASSPATH%

set JAVA_MEM_OPTS= -Xms128m -Xmx512m -XX:PermSize=128m
set JAVA_OPTS_EXT= -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Dapplication.codeset=UTF-8 -Dfile.encoding=UTF-8
set JAVA_DEBUG_OPT= -server -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=9199,server=y,suspend=n
set CANAL_EXT_OPTS= -Dcanal.destination="%canal_destination%" -Dcanal.zookeeper="%canal_zookeeper%" -Dcanal.batch.size="%canal_batch_size%" -Dcanal.sleep.time="%canal_sleep_time%" -Dcanal.ip="%canal_ip%" -Dcanal.port="%canal_port% -Dcanal.metric.period="%canal_metric_period%  -Dcanal.metric.debug=%canal_metric_debug% -Dcanal.dump.debug=%canal_dump_debug% -Dcanal.parse.debug=%canal_parse_debug%"
set CANAL_OPTS= %CANAL_EXT_OPTS% -DappName=otter-canal-example -Dlogback.configurationFile="%logback_configurationFile%"

set JAVA_OPTS= %JAVA_MEM_OPTS% %JAVA_OPTS_EXT% %JAVA_DEBUG_OPT% %CANAL_OPTS%

if "%client_mode%" == "Cluster"  
	java %JAVA_OPTS% -classpath "%CLASSPATH%" com.alibaba.otter.canal.example.ClusterCanalClientTest
else 
	java %JAVA_OPTS% -classpath "%CLASSPATH%" com.alibaba.otter.canal.example.SimpleCanalClientTest
