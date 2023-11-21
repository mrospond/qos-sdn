from mininet.net import Mininet
from mininet.cli import CLI
from mininet.topo import Topo
from mininet.link import TCLink
from mininet.util import customClass
# from mininet.node import UserSwitch
from mininet.node import RemoteController, OVSSwitch

# class SliceableSwitch(UserSwitch):
#     def __init__(self, name, **kwargs):
#         UserSwitch.__init__(self, name, '', **kwargs)

class MyTopo(Topo):
    def __init__( self ):
    # "Create custom topo."
    # Initialize topology
        Topo.__init__( self )
        # Add hosts and switches
        h1 = self.addHost('h1')
        h2 = self.addHost('h2')
        h3 = self.addHost('h3')
        
        s1 = self.addSwitch('s1', cls=OVSSwitch, protocols="OpenFlow13")
        s2 = self.addSwitch('s2', cls=OVSSwitch, protocols="OpenFlow13")
        s3 = self.addSwitch('s3', cls=OVSSwitch, protocols="OpenFlow13")

        # Add links
        self.addLink(h1, s1)
        self.addLink(h2, s2)
        self.addLink(h3, s3)
        self.addLink(s1, s2)
        self.addLink(s1, s3)

def run(net):
    s1 = net.getNodeByName('s1')
    s1.cmdPrint('dpctl unix:/tmp/s1 queue-mod 1 1 80')
    s1.cmdPrint('dpctl unix:/tmp/s1 queue-mod 1 2 120')
    s1.cmdPrint('dpctl unix:/tmp/s1 queue-mod 1 3 800')

def genericTest(topo):

    c1 = RemoteController('c1', ip='127.0.0.1')

    # Rate limit links to 1Mbps
    link = customClass({'tc':TCLink}, 'tc,bw=1')

    net = Mininet(topo=topo, link=link, controller=c1)
    net.start()
    run(net)
    CLI(net)
    net.stop()

def main():
    topo = MyTopo()
    genericTest(topo)

if __name__ == '__main__':
    main()
