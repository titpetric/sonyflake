# A ID generator service suitable for docker swarm

This is a test of an ID generator service which can be deployed on docker swarm.
Currently a HTTP interface is provided, which spits out IDS created by [sony/sonyflake](https://github.com/sony/sonyflake).

Sonyflake uses:

```
39 bits for time in units of 10 msec
 8 bits for a sequence number
16 bits for a machine id
```

The order of the bits mean that the returned ID is K-sortable. As long as the time between hosts is
synched and accurate, returned id's will be sortable up to 10ms. This means that you can for example
order database records by ID (asc/desc) and expect they will be sorted within 10ms. I believe the
original twitter snowflake ID generator was K-sortable up to 1 second.

The 16 bits for a machine id would mean there's a physical limit of running 65535 containers before it
would be possible to have an ID collision. Since the precision is 8 bits in 10 msec, there's a hard limit
on how many IDs you can possibly generate (256 in 10ms, 25,600 in one second).

It would be possible to replace sonyflake with a different ID generator, that has different constraints
in regards to how many sequences you can generate, or make trade-offs in terms of precision if you're
not planning to have so many machines. Ie, We could limit snowflakes to 8 bits, leaving 16 bits for the
sequence, and you'll most likely never hit any limitation. However, the above is pretty reasonable already.

```
$ for LOOPVAR in $(seq 1 50); do printf "GET / HTTP/1.0\r\nConnection: close\r\n\r\n" | nc localhost 80 | tail -n 1 ; echo; done
...
{"id":133591991580950539,"machine-id":11,"msb":0,"sequence":5,"time":7962703203}
{"id":133591991597400075,"machine-id":11,"msb":0,"sequence":0,"time":7962703204}
{"id":133591991597465611,"machine-id":11,"msb":0,"sequence":1,"time":7962703204}
{"id":133591991597531147,"machine-id":11,"msb":0,"sequence":2,"time":7962703204}
{"id":133591991597596683,"machine-id":11,"msb":0,"sequence":3,"time":7962703204}
{"id":133591991597662219,"machine-id":11,"msb":0,"sequence":4,"time":7962703204}
{"id":133591991597727755,"machine-id":11,"msb":0,"sequence":5,"time":7962703204}
{"id":133591991597793291,"machine-id":11,"msb":0,"sequence":6,"time":7962703204}
{"id":133591991597858827,"machine-id":11,"msb":0,"sequence":7,"time":7962703204}
{"id":133591991614177291,"machine-id":11,"msb":0,"sequence":0,"time":7962703205}
...
```

In a very naive test, I can make about 5-7 requests in 10ms. Of course this is not a proper benchmark.
Or if you like a siege benchmark (from a different docker container):

~~~
Transactions:                   2577 hits
Availability:                 100.00 %
Elapsed time:                   4.43 secs
Data transferred:               0.20 MB
Response time:                  0.19 secs
Transaction rate:             581.72 trans/sec
Throughput:                     0.04 MB/sec
Concurrency:                  110.10
Successful transactions:        2577
Failed transactions:               0
Longest transaction:            2.30
Shortest transaction:           0.00
~~~

It must be one of the first times I ran `siege`, so I hope that the results are somehow relevant.

I'm running on a single CPU so the transaction limit can go higher. I have seen benchmarks in the high
10k/s so it is theoretically possible to saturate a single sonyflake instance on a more high-end machine.
In the most physical way, it really depends on things like CPU clock speed and opcode pipelines.

## How to run it?

~~~
./build.sh
./run.sh
~~~

You need Docker. Both scripts use minimal alpine images to do it's work. The server is run in
a container.

## TODO

* Set up a swarm service
* Use docker chaos monkey to kill it
* Test resilience to death (have a haproxy/nginx as a LB while agressively killing instances)