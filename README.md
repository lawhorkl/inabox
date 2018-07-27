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

Reiterating the InaBox rule-of-thumb from earlier, for InaBox to work you need two things:
1. You need to be able to ping the address of the slave box from the command-line of the control panel (external IP in cases of a gateway).
2. The port the API is running on must be accessible (port forwarding from the external network IP to the internal IP of the API-enabled service in cases of a gateway.)

So, continuing under the assumption that you've already sorted this out, and these two conditions are met, you would then clone the Control Panel (this repo) onto the box which will serve as your primary way of interacting with and monitoring the boxes that are configured for InaBox, and the [API]() onto the boxes that will be monitored. Since both applications run on the same stack, the next few parts are easy:

1. Install Ruby 2.4: InaBox runs on Ruby 2.4. It was developed on 2.4.3, but has been tested to work fully on older and newer versions of 2.4 (You should probably install Ruby 2.4 using a version manager like rvm, or rbenv. This readme recommends rvm.)
2. Clone the repos: `git clone https://github.com/lawhorkl/inabox.git` and `
git clone https://github.com/lawhorkl/inabox-api.git`
3. Run bundler: `bundle install`
5. Resolve any bundler issues (none known currently)
6. Configure your database: InaBox supports anything the Rails ORM system does, so most commonly MySQL, PostgreSQL, etc. Even NoSQL databases like MongoDB. (Note: The API makes no use of a data layer, and so this step should be skipped when setting up the API.)
7. Choose (a) or (b). (a): Load the included schema: `bundle exec rake db:schema:load` (b): If you require more from the data layer, modify the data migrations to your requirements, and then run the migrations to generate a new schema: `bundle exec rake db:migrate`
8. Start Sidekiq, Query Manager, and Application Server: These should be swtarted in a way that they can be backgrounded, obviously. Launching Sidekiq and the Query Manager is the same in development as production: `bundle exec sidekiq`, `bundle exec rake query:manager:start`, respectively. If you are running in development, you should be using the `rails server` command, while in production the Rails instance should be deployed with something like [Phusion Passenger](https://www.phusionpassenger.com/) or another method of deploying the Rails application with a full web server. I personally run the API using the development server even in production, as it is not a heavily loaded component and the memory consumed by a Rails instance deployed through an Apache server is quite high.
9. Create a new `Server` in the Control Panel that has the API installed on it, you should see the first data point craeted and graphed within the first thirty seconds to a minute.

## What information does the API expose?
Systems with the API installed expose the data collected by the Control Application. This data, which is mostly harmless from a security point of view and is still accessible to anyone with access to the `/stats` endpoint. InaBox currently does not include any sort of security measures between the Control Panel and API. If the communication between the two becomes more complex, excryption may be added between end points.

To some, it may seem insane to not include encryption for any sort of API, but keep in mind *how* the API was built. the InaBox API does not ship with *any* ability to change or destroy parts of its host system. It is only capable of reading information and displaying it in a very *dumb* way, and by *dumb* I mean it does not access any part of the system which is sensitive while collecting this data, and there are no endpoints within the API or the Control Panel that permits the creation or destruction of database objects. The only way to cause a change in this system is to pass the authentication provided by [Devise](https://github.com/plataformatec/devise) within the Control Panel. This authentication for application users comes very highly configurable and even provides support for SSO systems. Consult Devise documentation for more.

The API exposes these bits of information with a JSON string:
* Ram capacity
* Free ram (Computed per request)
* Disk count
* File system type
* Block size
* Storage capacity
* Free storage (Computed per request)
* Percentage of disk utilization (Computed per request)
* Mount Point
* CPU Core Count
* CPU Load Averages for the last one, five, and fifteen minutes

If you consider any of this to be security sensitive information, you should probably enable some encryption between the API and the Control Panel. It is a straight forward enough process to do, and the only real reason it hasn't been added yet is that it was out of scope for my senior design.

## Compatibility, Security, and Alternate APIs
