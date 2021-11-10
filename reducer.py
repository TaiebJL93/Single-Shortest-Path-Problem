#!/usr/bin/python

import sys

current_distance = None
current_nodeID = None
current_path = None
current_neighbours=None
for line in sys.stdin:
    line = line.strip().split('\t')
    nodeID = line[0]
    distance = int(line[1])
    #identify which is a neighbor noden(len()==3) and which is a source node (len()==4)
    if len(line) == 3:
        path = line[2]
    if len(line) == 4:
        path = line[3]
        current_neighbours = line[2]
    #Check for the min distance and update the source node distance and path 
    if current_nodeID == nodeID:
        if distance < current_distance:
            current_distance = distance
            current_path = path
    else:
        if current_nodeID:
            print('%s\t%s\t%s\t%s' % (current_nodeID, current_distance, current_neighbours, current_path))
        current_nodeID = nodeID
        current_distance = int(distance)
        current_path = path
   
# the below is needed to output the last value in the reducer
print('%s\t%s\t%s\t%s' % (current_nodeID, current_distance, current_neighbours, current_path))
