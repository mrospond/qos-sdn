#!/usr/bin/python                                                                            
                                                                                             
from mininet.topo import Topo
from mininet.net import Mininet
from mininet.node import OVSSwitch, Controller, RemoteController
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel
from mininet.util import customClass
from mininet.link import TCLink
from mininet.cli import CLI

# Compile and run sFlow helper script
# - configures sFlow on OVS
# - posts topology to sFlow-RT
# execfile('sflow-rt/extras/sflow.py') 

filename = '/home/test/sflow-rt/extras/sflow.py'

with open(filename, "rb") as source_file:
    code = compile(source_file.read(), filename, "exec")
exec(code)


# Rate limit links to x Mbps
link = customClass({'tc':TCLink}, 'tc,bw=10')

class CustomTopo(Topo):

    def build(self):
        s1 = self.addSwitch('s1')
        s2 = self.addSwitch('s2')
        h1 = self.addHost('h1', mac='00:00:00:00:00:11', ip='172.16.10.9/24')
        h2 = self.addHost('h2', mac='00:00:00:00:00:22', ip='172.16.20.9/24')
        h3 = self.addHost('h3', mac='00:00:00:00:00:33', ip='172.16.30.9/24')

        self.addLink(h1, s1)
        self.addLink(h3, s1)
        self.addLink(s1, s2)
        self.addLink(h2, s2)

def simpleTest():
    # "Create and test a simple network"
    topo = CustomTopo()
    c1 = RemoteController('c1', ip='127.0.0.1')
    net = Mininet(topo,link=link, controller=c1)
    net.start()
    print("Dumping host connections")
    dumpNodeConnections(net.hosts)
    print ("Testing bandwidth between h1 and h4")
    # h1, h4 = net.get( 'h1', 'h4' )
    # net.iperf( (h1, h4) )
    CLI(net)

    h1, h2, h3 = net.get('h1', 'h2', 'h3')
    h1.cmd('ip route add default via 172.16.10.1')
    h2.cmd('ip route add default via 172.16.20.2')  
    h3.cmd('ip route add default via 172.16.30.1')
    
    net.stop()

if __name__ == '__main__':
    # Tell mininet to print useful information
    setLogLevel('info')
    simpleTest()