# InaBox - Rails Monitoring Application

## What is InaBox?
InaBox is a Rails-based system that allows developers and system admins to obtain data regarding system utilization, as well as some basic data visualization. This is acheived through use of the [VMStat](https://github.com/threez/ruby-vmstat) written by [threez](https://github.com/threez). In a way, InaBox can be thought of as a front-end for this gem. All credit for the ability to gather system statistics in a ruby environment goes to [VMStat](https://github.com/threez/ruby-vmstat)

## Why use this?
True, if you have a VMWare environment that provides this statistics, they can provide much better real-time statistics as they do not have to rely on the HTTP protocol to transmit the data back and forth. I am not presuming that there is any inherent advantage to using InaBox over these VMWare utilities, however for those whose systems are not running in a convenient VMWare environment, or 
