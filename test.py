#!/usr/bin/python                                                                            
                                                                                             
from mininet.topo import Topo
from mininet.net import Mininet
from mininet.node import RemoteController
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel
from mininet.util import customClass, custom
from mininet.link import TCLink, TCIntf
from mininet.cli import CLI

from time import sleep

# Compile and run sFlow helper script
# - configures sFlow on OVS
# - posts topology to sFlow-RT
# execfile('sflow-rt/extras/sflow.py') 

filename = '/home/test/sflow-rt/extras/sflow.py'

with open(filename, "rb") as source_file:
    code = compile(source_file.read(), filename, "exec")
exec(code)


# Rate limit links to x Mbps
bw = 7
link = customClass({'tc':TCLink}, f'tc,bw={bw}')

class CustomTopo(Topo):

    def build(self):
        s1 = self.addSwitch('s1')
        s2 = self.addSwitch('s2')

        h1 = self.addHost('h1', ip='172.16.10.9/24')
        h2 = self.addHost('h2', ip='172.16.20.9/24')
        h3 = self.addHost('h3', ip='172.16.30.9/24')

        self.addLink(h1, s1)
        self.addLink(h3, s1)
        self.addLink(s1, s2)
        self.addLink(h2, s2)

def simpleTest():
    pass

if __name__ == '__main__':
    # Tell mininet to print useful information
    setLogLevel('info')
    # simpleTest()

    # "Create and test a simple network"
    # topo = CustomTopo()
    # c1 = RemoteController('c1', ip='127.0.0.1', protocols='OpenFlow13')
    # net = Mininet(topo,link=link, controller=c1)
    # net.start()
    # # net.cmd('source ipconf')

    # print("Dumping host connections")
    # dumpNodeConnections(net.hosts)
    # CLI(net)

    # #?????????
    # h1 = net.get('h1')
    # result = h1.cmd('ifconfig')
    # print(result)

    # # net.cmd('source ipconf')
    # net.stop()

    intf = custom(TCIntf, bw=bw)
    
    topo = CustomTopo()
    c1 = RemoteController('c1', ip='127.0.0.1')
    net = Mininet(topo=topo, intf=intf, link=link, controller=c1)
    # net = Mininet(topo=topo, link=link, controller=c1)
    net.start()
    sleep(5)
    # net.pingAll()
    dumpNodeConnections(net.hosts)

    # get the host objects
    h1, h2, h3 = net.get('h1', 'h2', 'h3')
    # h2 = net.get('h2')
    # h3 = net.get('h3')
    h1.cmd('ip route add default via 172.16.10.1')
    h2.cmd('ip route add default via 172.16.20.2')
    h3.cmd('ip route add default via 172.16.30.1')

    # h1.cmd('iperf -s &')
    # result = h2.cmd('iperf -c 192.168.1.1')
    # print(result)
    result = h1.cmd('route -n')
    print(result)
    CLI(net)
    net.stop()