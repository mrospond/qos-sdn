"""Custom topology example

Two directly connected switches plus a host for each switch:

   h1 --- s1 --- s2 --- h2
   h3 ----^

Adding the 'topos' dict with a key/value pair to generate our newly defined
topology enables one to pass in '--topo=mytopo' from the command line.
"""

from mininet.topo import Topo

class MyTopo( Topo ):
    "Simple topology example."

    def __init__( self ):
        "Create custom topo."

        # Initialize topology
        Topo.__init__( self )

        # Add hosts and switches
        h1 = self.addHost('h1', ip='172.16.10.9/24')
        h2 = self.addHost('h2', ip='172.16.20.9/24')
        h3 = self.addHost('h3', ip='172.16.30.9/24')
        s1 = self.addSwitch('s1')
        s2 = self.addSwitch('s2')

        # Add links
        self.addLink(h1, s1)
        self.addLink(h3, s1)
        self.addLink(s1, s2)
        self.addLink(h2, s2)


topos = { 'mytopo': ( lambda: MyTopo() ) }
