#!/usr/bin/python

import sys
from itertools import dropwhile

#function to identify header starting with predefined character to skip
def header(s):
    return s.startswith('#')

for line in dropwhile(header, sys.stdin):
        line = line.strip().split('\t')
        nodeID = line[0]
        distance = int(line[1])
        # For each node check if they have neighbors or not 
        if len(line) > 2:
            neighbors_list = line[2] 
        else:
            neighbors_list = "empty"
        # Update previous path if it was not intialised else do so by setting all path equal to source node
        if len(line) == 4:
            path = line[3] 
        else:
            path = nodeID       
        # keeps the complete nodes data  
        print('{}\t{}\t{}\t{}'.format(nodeID, distance, neighbors_list, path))
        # desagregate the neighbors and the relevant distance to their parent 
        if neighbors_list!="empty":
            neighbors_list = neighbors_list.strip().split(',')
            for neighbors in neighbors_list:
                neighbor_nodeID, neighbor_distance = neighbors.strip().split(':', 1)
                neighbor_distance=int(neighbor_distance)
                neighbor_distance += distance
                neighbor_path = '{}->{}'.format(path, neighbor_nodeID)
                print('{}\t{}\t{}'.format(neighbor_nodeID, neighbor_distance, neighbor_path))
