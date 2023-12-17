#!/usr/bin/python                                                                            
                                                                                             
from mininet.topo import Topo
from mininet.net import Mininet
from mininet.node import RemoteController, Host, OVSSwitch
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel
from mininet.util import customClass, custom
from mininet.link import TCLink, TCIntf
from mininet.cli import CLI

# from time import sleep

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
        s1 = self.addSwitch('s1', cls=OVSSwitch, protocols="OpenFlow13")
        s2 = self.addSwitch('s2', cls=OVSSwitch, protocols="OpenFlow13")

        h1 = self.addHost('h1', ip='172.16.10.9/24')
        h2 = self.addHost('h2', ip='172.16.20.9/24')
        h3 = self.addHost('h3', ip='172.16.30.9/24')

        self.addLink(h1, s1)
        self.addLink(h3, s1)
        self.addLink(s1, s2)
        self.addLink(h2, s2)


if __name__ == '__main__':
    setLogLevel('info')

    intf = custom(TCIntf, bw=bw)
    
    topo = CustomTopo()
    c1 = RemoteController('c1', ip='127.0.0.1', protocols='OpenFlow13')
    # net = Mininet(topo=topo, intf=intf, link=link, controller=c1)
    net = Mininet(topo=topo, link=link, controller=c1)
    # net = Mininet(topo=topo, controller=c1)
    net.start()

    dumpNodeConnections(net.hosts)

    # get the host objects
    h1, h2, h3 = net.get('h1', 'h2', 'h3')

    h1.cmd('ip route add default via 172.16.10.1')
    h2.cmd('ip route add default via 172.16.20.2')
    h3.cmd('ip route add default via 172.16.30.1')

    CLI(net)
    net.stop()