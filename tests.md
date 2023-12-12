* iperf

h2:
```
iperf -s -u -i 1 -p 5004
iperf -s -u -i 1 -p 5201
iperf -s -u -i 1 -p 5202
```

h1:
```
iperf -c 172.16.20.9 -p 5004 -u -b 8M
```

h3:
```
iperf -c 172.16.20.9 -p 5201 -u -b 8M
```