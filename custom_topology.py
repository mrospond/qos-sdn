#!/usr/bin/python


"""Custom topology example

Two directly connected switches plus a host for each switch:

    h1 --- s1 --- s2 --- h2
        /
    h3

MAC,IP, Controller, CLI stuff configured

"""

from mininet.topo import Topo
from mininet.net import Mininet
from mininet.log import setLogLevel
from mininet.cli import CLI
from mininet.node import OVSSwitch, Controller, RemoteController

class SingleSwitchTopo(Topo):

    def build(self):
        s1 = self.addSwitch('s1')
        s2 = self.addSwitch('s2')
        h1 = self.addHost('h1', mac='00:00:00:00:00:11', ip='10.1.0.1/24')
        h2 = self.addHost('h2', mac='00:00:00:00:00:22', ip='10.1.0.2/24')
        h3 = self.addHost('h3', mac='00:00:00:00:00:33', ip='10.1.0.3/24')

        self.addLink(h1, s1)
        self.addLink(h3, s1)
        self.addLink(s1, s2)
        self.addLink(h2, s2)

def run_mininet():
    setLogLevel('info')
    topo = SingleSwitchTopo()
    c1 = RemoteController('c1', ip='127.0.0.1')
    net = Mininet(topo=topo, controller=c1)
    net.start()
    # net.pingAll()

    h1, h2 = net.get('h1', 'h2')
    h1.cmd('su test &')
    h1.cmd('xterm -xrm "XTerm.vt100.allowTitleOps: false" -T h1 &')
    h2.cmd('xterm -xrm "XTerm.vt100.allowTitleOps: false" -T h2 &')

    CLI(net)
    net.stop()

if __name__ == '__main__':
    run_mininet()
