# InaBox - Rails Monitoring Application

## What is InaBox?
InaBox is a Rails-based system that allows developers and system admins to obtain data regarding system utilization, as well as some basic data visualization. This is acheived through use of the [VMStat](https://github.com/threez/ruby-vmstat) written by [threez](https://github.com/threez). In a way, InaBox can be thought of as a front-end for this gem. All credit for the ability to gather system statistics in a ruby environment goes to [VMStat](https://github.com/threez/ruby-vmstat)

## Why use this?
True, if you have a VMWare environment that provides this statistics, they can provide much better real-time statistics as they do not have to rely on the HTTP protocol to transmit the data back and forth. I am not presuming that there is any inherent advantage to using InaBox over these VMWare utilities, however for those whose systems are not running in a convenient VMWare environment, or have older systems which are relevant enough to warrant monitoring it, but are not relevant enough to justify a complete migration to newer architecture, InaBox can be installed.

Another use case is for small developers that may have services spread across several providers. I personally use several boxes across AWS, DO, and another European provider. By utilizing InaBox's end-to-end philosophy a small de veloper can monitor any Linux box across providers, or even over vast geographical distances in the real world. InaBox was built on the understanding that as long as a human can ping an address on the command-line, and the networking port used to transmit the data is accessible, monitoring will begin immediately after input into the InaBox Control Panel, with the first transmission being queued as the `Server` object is created within the database.

## Overview of InaBox
![image](https://user-images.githubusercontent.com/12615997/43338936-e0bad144-91a5-11e8-89cb-5589e6bb20fd.png)
The InaBox system can be broken down into three parts. The first two are: The web application that receives transmitted statistics from "slave" servers (aka. "Control Panel"), and the slave servers themselves which are running a compatible version of the [InaBox API](). The InaBox API is a small API that is created on Rails, which also uses the exact same stack as the Control Panel. The API contains __no create, update, or destroy__ capacity, making it a read-only system, and by extension giving potential actors no extra avenue of attack. This application also does not require root access natively. If the Ruby environment is not installed properly outside of the _sudo_ environment, you may still need root access to install either part of the system, but will not require continued sudo access after installation.

### Control Panel
The Control Panel does the following functions and carries the following responsibilities:
1. Provides readable UI for adding servers to be monitored, editing those server's addresses, ports, or human readable names. 
2. Provides data storage for server metadata(hostname, port, etc.)
3. Makes periodic HTTP GET requests to every server whose metadata is listed in the database.
4. Provides data storage for statistics gathered by using a server's metadata.
5. Provides UI for monitoring any server within the database and displaying real-time HTML 5 graphs of collected data points.

### API
The API does the following functions and carries the following responsibilities:
1. Collects data from the hardware of the machine and wrap it in ruby objects (via. [VMStat](https://github.com/threez/ruby-vmstat))
2. Parses all this data into a ruby hash.
3. Exposes this data in the form of a JSON string when the API endpoint `/stats` receives a GET request.

### Query Manager
The third, smaller part of the InaBox system is the Query Manager rake tasks. These rake tasks are scripts that run indefinitely, much like how the queueing engine `Resque` works. This query manager is the script that automates the Control Panel's HTTP requests to all servers in the database. The query manager is essential to running this software. __If the query manager is not running, your control application is not collecting data!__

To start the query manager, you should use a combination of a terminal multiplexer like `screen` or `tmux` and the rake commands. I personally recommend using `screen` to start a new terminal session, run the appropriate rake command, then Ctrl-A + D to detach from the now backgrounded query manager thread. You can reconnect using the command `screen -R`. At the risk of becoming a `screen` how-to, this readme will not go into further detail, but the process of using screen to manage multiple sessions is a very powerful tool, and if this seems scary to you, you should probably reference `man screen` and get yourself comfortable wih using it. But any way that enables you to run a command-line command and then background the process will work just fine.

The most basic query manager command is just: `bundle exec rake query:manager:start` but there are several other query manager commands used for cleaning the job queue. These other commands are destructive actions that clear out the Redis data store completely and they should be used with caution, only when neeeded.

The Query Manager is an unfortunate side effect of having a limited amount of time for a senior design project. Managing these queries can be handled more efficiently, but that will be discussed later in this readme.

## Installation Guide and Network Setup
InaBox relies entirely on the HTTP network protocol and as such requires a few things in the network layer to be true. The first thing is for a networking port to be available for use by the slave server, while also being accessible to the control panel. The requirements for this change drastically depending on what the network your systems operate in look like, and whether or not the slave system and API are on the same network/subnet, or whether there is a gateway separating the two. 

In the former case you should be able to communicate directly on whatever port the API is running on, while in the latter case of a gateway between the two, you will need either someone with network administrator access, or network administrator access yourself to configure a port forward for the API.
