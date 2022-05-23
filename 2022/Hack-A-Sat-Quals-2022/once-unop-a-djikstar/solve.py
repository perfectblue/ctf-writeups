import networkx as nx
"""
Intent of the challenge was to "fix" the original buggy binary which had calls
randomly nop'd out. Instead we found it easier to reimplement in python
"""

G = nx.DiGraph()
"""
The binary assigns weight multipliers to edges in the directed graph
"""

UserOrGatewayStation = 1999.9000000000001
Starzard = 4.04
Starmeleon = 3.141
Starmander = 2.718

for i in open("gateways.csv", "r").readlines()[1:]:
    src, dst, wt = i.rstrip().split(",")
    w = UserOrGatewayStation
    G.add_edge(dst, src, weight=float(wt) * w)

for i in open("sats.csv", "r").readlines()[1:]:
    src, dst, wt = i.rstrip().split(",")
    """
    Edge "type" decided by the last digit of the node name (mod 3)

    Starlunk-35-16 has type 0 (mod 3) = Starmander
    """

    x = int(dst[-1]) % 3
    if x == 0:
        w = Starmander
    elif x == 1:
        w = Starmeleon
    elif x == 2:
        w = Starzard

    G.add_edge(src, dst, weight=float(wt) * w)

for i in open("users.csv", "r").readlines()[1:]:
    src, dst, wt = i.rstrip().split(",")
    G.add_edge(src, dst, weight=float(wt) * UserOrGatewayStation)
"""
Find SHP from ShippyMcShipFace to Honolulu and output in format required by
server
"""

x = []
for i in nx.dijkstra_path(G, "ShippyMcShipFace", "Honolulu")[1:-1]:
    x.append("-".join(i.split("-")[1:]))
print(", ".join(x))
