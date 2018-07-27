# InaBox - Rails Monitoring Application

## What is InaBox?
InaBox is a Rails-based system that allows developers and system admins to obtain data regarding system utilization, as well as some basic data visualization. This is acheived through use of the [VMStat](https://github.com/threez/ruby-vmstat) written by [threez](https://github.com/threez). In a way, InaBox can be thought of as a front-end for this gem. All credit for the ability to gather system statistics in a ruby environment goes to [VMStat](https://github.com/threez/ruby-vmstat)

## Why use this?
True, if you have a VMWare environment that provides this statistics, they can provide much better real-time statistics as they do not have to rely on the HTTP protocol to transmit the data back and forth. I am not presuming that there is any inherent advantage to using InaBox over these VMWare utilities, however for those whose systems are not running in a convenient VMWare environment, or have older systems which are relevant enough to warrant monitoring it, but are not relevant enough to justify a complete migration to newer architecture, InaBox can be installed.

Another use case is for small developers that may have services spread across several providers. I personally use several boxes across AWS, DO, and another European provider. By utilizing InaBox's end-to-end philosophy a small de veloper can monitor any Linux box across providers, or even over vast geographical distances in the real world. InaBox was built on the understanding that as long as a human can ping an address on the command-line, and the networking port used to transmit the data is accessible, monitoring will begin immediately after input into the InaBox Control Panel, with the first transmission being queued as the `Server` object is created within the database.

## Overview of InaBox
The InaBox system can be broken down into two parts: The web application that receives transmitted statistics from "slave" servers (aka. "Control Panel"), and the slave servers themselves which are running a compatible version of the [InaBox API](). The InaBox API is a small API that is created on Rails, which also uses the exact same stack as the Control Panel. The API contains __no create, update, or destroy__ capacity, making it a read-only system, and by extension giving potential actors no extra avenue of attack. This application also does not require root access natively. If the Ruby environment is not installed properly outside of the _sudo_ environment, you may still need root access to install either part of the system, but will not require continued sudo access after installation.

The Control Panel does the following functions and carries the following responsibilities:
1. Provides readable UI for adding servers to be monitored, editing those server's addresses, ports, or human readable names. 
2. Provides data storage for server metadata(hostname, port, etc.)
3. Makes periodic HTTP GET requests to every server whose metadata is listed in the database.
4. Provides data storage for statistics gathered by using a server's metadata.
5. Provides UI for monitoring any server within the database and displaying real-time HTML 5 graphs of collected data points.

The API does the following functions and carries the following responsibilities:
1. Collects data from the hardware of the machine and wrap it in ruby objects (via. [VMStat](https://github.com/threez/ruby-vmstat))
2. Parses all this data into a ruby hash.
3. Exposes this data in the form of a JSON string when the API endpoint `/stats` receives a GET request.

The third, smaller part of the InaBox system is the Query Manager raketasks. These raketasks are tasks that run indefinitely, much like how the queueing engine `Resque` works. This query manager is the script that automates the Control Panel's HTTP requests to all servers in the database.
