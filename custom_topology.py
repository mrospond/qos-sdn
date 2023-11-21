#!/usr/bin/python

from mininet.topo import Topo
from mininet.net import Mininet
from mininet.log import setLogLevel, info
from mininet.cli import CLI
from mininet.link import TCIntf, TCLink
from mininet.node import OVSSwitch, Controller, RemoteController
from mininet.util import custom, quietRun, customClass

# Compile and run sFlow helper script
# - configures sFlow on OVS
# - posts topology to sFlow-RT
# execfile('/home/test/sflow-rt/extras/sflow.py') 
filename = '/home/test/sflow-rt/extras/sflow.py'

with open(filename, "rb") as source_file:
    code = compile(source_file.read(), filename, "exec")
exec(code)

# Rate limit links to 10Mbps
link = customClass({'tc':TCLink}, 'tc,bw=10')

class CustomTopo(Topo):

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

def testLinkLimit(net, bw):
    info('*** Testing network %.2f Mbps bandwidth limit\n' % bw)
    net.iperf()

def limit(bw=10):
    """Example/test of link and CPU bandwidth limits
       bw: interface bandwidth limit in Mbps
       cpu: cpu limit as fraction of overall CPU time"""
    intf = custom(TCIntf, bw=bw)
    myTopo = CustomTopo()
    for sched in 'rt', 'cfs':
        info( '*** Testing with', sched, 'bandwidth limiting\n' )
        if sched == 'rt':
            release = quietRun( 'uname -r' ).strip('\r\n')
            output = quietRun( 'grep CONFIG_RT_GROUP_SCHED /boot/config-%s'
                               % release )
            if output == '# CONFIG_RT_GROUP_SCHED is not set\n':
                info( '*** RT Scheduler is not enabled in your kernel. '
                      'Skipping this test\n' )
                continue
        # host = custom( CPULimitedHost, sched=sched, cpu=cpu )
        c1 = RemoteController('c1', ip='127.0.0.1')
        net = Mininet(topo=myTopo, intf=intf, waitConnected=True, controller=c1, link=link)
        net.start()
        testLinkLimit(net, bw=bw)

        CLI(net)

        net.stop()

def verySimpleLimit( bw=150 ):
    "Absurdly simple limiting test"
    intf = custom( TCIntf, bw=bw )
    net = Mininet( intf=intf, waitConnected=True )
    h1, h2 = net.addHost( 'h1' ), net.addHost( 'h2' )
    net.addLink( h1, h2 )
    net.start()
    net.pingAll()
    net.iperf()
    h1.cmdPrint( 'tc -s qdisc ls dev', h1.defaultIntf() )
    h2.cmdPrint( 'tc -d class show dev', h2.defaultIntf() )
    h1.cmdPrint( 'tc -s qdisc ls dev', h1.defaultIntf() )
    h2.cmdPrint( 'tc -d class show dev', h2.defaultIntf() )
    net.stop()

def run_mininet():
    setLogLevel('info')
    topo = CustomTopo()
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
    # run_mininet()
    limit()
