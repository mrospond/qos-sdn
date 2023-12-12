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
bw = 8
link = customClass({'tc':TCLink}, f'tc,bw={bw}')

class CustomTopo(Topo):

    def build(self):
        s1 = self.addSwitch('s1')

        h1 = self.addHost('h1', ip='172.16.20.1/24')
        h2 = self.addHost('h2', ip='172.16.20.9/24')
        h3 = self.addHost('h3', ip='172.16.20.3/24')

        self.addLink(h1, s1)
        self.addLink(h2, s1)
        self.addLink(h3, s1)

def simpleTest():
    pass

if __name__ == '__main__':
    setLogLevel('info')
    intf = custom(TCIntf, bw=bw)
    
    topo = CustomTopo()
    c1 = RemoteController('c1', ip='127.0.0.1')
    net = Mininet(topo=topo, intf=intf, link=link, controller=c1)
    net.start()
    net.pingAll()
    dumpNodeConnections(net.hosts)
    CLI(net)
    net.stop()