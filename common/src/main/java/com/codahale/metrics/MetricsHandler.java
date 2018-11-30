package com.codahale.metrics;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class MetricsHandler {
	private static MetricRegistry registry = new MetricRegistry();
	private volatile static Map<String,Meter> meters = new ConcurrentHashMap<String,Meter>();
	private volatile static Map<String,Counter> counters = new ConcurrentHashMap<String,Counter>();
	private volatile static Map<String,Histogram> histograms = new ConcurrentHashMap<String,Histogram>();
	private volatile static Map<String,Timer> timers = new ConcurrentHashMap<String,Timer>();
	public static ConsoleReporter console(){
		ConsoleReporter console = ConsoleReporter.forRegistry(registry).build();
		return console;
	}
	public static Slf4jReporter slf4j(){
		Slf4jReporter slf4j = Slf4jReporter.forRegistry(registry).build();
		return slf4j;
	}
	public static Meter meter(String name){
		Meter metric = registry.meter(name);
		meters.put(name,metric);
		return metric;
	}
	public static Counter counter(String name){
		Counter metric = registry.counter(name);
		counters.put(name,metric);
		return metric;
	}
	public static Histogram histogram(String name){
		Histogram metric = registry.histogram(name);
		histograms.put(name,metric);
		return metric;
	}
	public static Timer timer(String name){
		Timer metric = registry.timer(name);
		timers.put(name,metric);
		return metric;
	}
	public static String printlnMeters() {
		String print = "\n\n";
		if(meters!=null&&!meters.isEmpty()) {
			for (String name : meters.keySet()) {
				Meter obj = meters.get(name);
				long count = obj.getCount();
				double rate_1m = obj.getOneMinuteRate();
				double rate_5m = obj.getFiveMinuteRate();
				double rate_15m = obj.getFifteenMinuteRate();
				double rate_avg = obj.getMeanRate();
				print += "-- Meter["+name+"] ----------------------------------------------------------------------\n";
				print += "         count = "+count+"\n";
				print += "     mean rate = "+String.format("%.2f", rate_avg)+" calls/second\n";
				print += " 1-minute rate = "+String.format("%.2f",rate_1m)+" calls/second\n";
				print += " 5-minute rate = "+String.format("%.2f",rate_5m)+" calls/second\n";
				print += "15-minute rate = "+String.format("%.2f",rate_15m)+" calls/second\n";
			}
		}
		print += "\n\n";
		return print;
	}
	public static String printlnCounters() {
		String print = "\n\n";
		if(counters!=null&&!counters.isEmpty()) {
			for (String name : counters.keySet()) {
				Counter obj = counters.get(name);
				long count = obj.getCount();
				print += "-- Counter["+name+"] ----------------------------------------------------------------------\n";
				print += "         count = "+count+"\n";
			}
		}
		print += "\n\n";
		return print;
	}
	public static String printlnHistograms() {
		String print = "\n\n";
		if(histograms!=null&&!histograms.isEmpty()) {
			for (String name : histograms.keySet()) {
				Histogram obj = histograms.get(name);
				long count = obj.getCount();
				Snapshot snapshot = obj.getSnapshot();
				double pct_75th = snapshot.get75thPercentile();
				double pct_95th = snapshot.get95thPercentile();
				double pct_98th = snapshot.get98thPercentile();
				double pct_99th = snapshot.get99thPercentile();
				double pct_999th = snapshot.get999thPercentile();
				double max = snapshot.getMax();
				double min = snapshot.getMin();
				double avg = snapshot.getMean();
				double median = snapshot.getMedian();
				double stddev = snapshot.getStdDev();
				print += "-- Histogram["+name+"] ----------------------------------------------------------------------\n";
				print += "         count = "+count+"\n";
				print += "           min = "+String.format("%.2f",min)+" milliseconds\n";
				print += "           max = "+String.format("%.2f",max)+" milliseconds\n";
				print += "          mean = "+String.format("%.2f",avg)+" milliseconds\n";
				print += "        stddev = "+String.format("%.2f",stddev)+" milliseconds\n";
				print += "        median = "+String.format("%.2f",median)+" milliseconds\n";
				print += "          75% <= "+String.format("%.2f",pct_75th)+" milliseconds\n";
				print += "          95% <= "+String.format("%.2f",pct_95th)+" milliseconds\n";
				print += "          98% <= "+String.format("%.2f",pct_98th)+" milliseconds\n";
				print += "          99% <= "+String.format("%.2f",pct_99th)+" milliseconds\n";
				print += "        99.9% <= "+String.format("%.2f",pct_999th)+" milliseconds\n";
			}
		}
		print += "\n\n";
		return print;
	}
	public static String printlnTimers() {
		String print = "\n\n";
		if(timers!=null&&!timers.isEmpty()) {
			for (String name : timers.keySet()) {
				Timer obj = timers.get(name);
				long count = obj.getCount();
				double rate_1m = obj.getOneMinuteRate();
				double rate_5m = obj.getFiveMinuteRate();
				double rate_15m = obj.getFifteenMinuteRate();
				double rate_avg = obj.getMeanRate();
				Snapshot snapshot = obj.getSnapshot();
				double pct_75th = snapshot.get75thPercentile();
				double pct_95th = snapshot.get95thPercentile();
				double pct_98th = snapshot.get98thPercentile();
				double pct_99th = snapshot.get99thPercentile();
				double pct_999th = snapshot.get999thPercentile();
				double max = snapshot.getMax();
				double min = snapshot.getMin();
				double avg = snapshot.getMean();
				double median = snapshot.getMedian();
				double stddev = snapshot.getStdDev();
				print += "-- Timer["+name+"] ----------------------------------------------------------------------\n";
				print += "         count = "+count+"\n";
				print += "     mean rate = "+String.format("%.2f", rate_avg)+" calls/second\n";
				print += " 1-minute rate = "+String.format("%.2f",rate_1m)+" calls/second\n";
				print += " 5-minute rate = "+String.format("%.2f",rate_5m)+" calls/second\n";
				print += "15-minute rate = "+String.format("%.2f",rate_15m)+" calls/second\n";
				print += "           min = "+String.format("%.2f",min)+" milliseconds\n";
				print += "           max = "+String.format("%.2f",max)+" milliseconds\n";
				print += "          mean = "+String.format("%.2f",avg)+" milliseconds\n";
				print += "        stddev = "+String.format("%.2f",stddev)+" milliseconds\n";
				print += "        median = "+String.format("%.2f",median)+" milliseconds\n";
				print += "          75% <= "+String.format("%.2f",pct_75th)+" milliseconds\n";
				print += "          95% <= "+String.format("%.2f",pct_95th)+" milliseconds\n";
				print += "          98% <= "+String.format("%.2f",pct_98th)+" milliseconds\n";
				print += "          99% <= "+String.format("%.2f",pct_99th)+" milliseconds\n";
				print += "        99.9% <= "+String.format("%.2f",pct_999th)+" milliseconds\n";
			}
		}
		print += "\n\n";
		return print;
	}
}
