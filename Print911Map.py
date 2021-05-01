
import os
import json
import xmltodict
import matplotlib.pyplot as plt

# ====================================================================================

def main():
	fileName = 'test-small-out-911.xml'
	allEdgesFN = 'allEdges.xml'

	# Extract data from files
	fileDump = parseXMLToDict(fileName)

	startVs = list(zip(fileDump['xloc'], fileDump['yloc'], fileDump['vertexTypesPreEvent']))
	endVs = list(zip(fileDump['xloc'], fileDump['yloc'], fileDump['vertexTypesPostEvent']))
	edgesAdded = fileDump['edgesAdded']
	edgesDeleted = fileDump['edgesDeleted']
	startEdges = getAllEdges(allEdgesFN)

	# An edge that is added but later deleted also shows up :(
	endEdges = startEdges.copy()
	endEdges.extend(edgesAdded)
	endEdges = [each for each in endEdges if each not in edgesDeleted]

	# makeplot(startVs, startEdges)
	makeplot(endVs, endEdges)

# ====================================================================================
# Take in a 911 output xml file and convert it to a python dict for easier use

def parseXMLToDict(fileName):
	# List of items with same data organization
	listNames = ['xloc', 'yloc', 'vertexTypesPreEvent', 'vertexTypesPostEvent', 'verticesDeleted']
	edgeNames = ['edgesAdded', 'edgesDeleted']

	# Get xml file to read from
	with open(fileName, 'r') as reader:
		xmlStr = reader.read()

	fileDump = dict(xmltodict.parse(xmlStr)['SimState'])['Matrix']
	retDict = {	'xloc'	: [],
				'yloc'	: [],
				'vertexTypesPreEvent'	: [],
				'vertexTypesPostEvent'	: [],
				'verticesDeleted'		: [],
				'edgesDeleted'	: [],
				'edgesAdded'	: [],
				'Tsim'			: 0,
				'simulationEndTime'	: 0 }

	for each in fileDump:
		item = dict(each)

		# xloc, yloc, vertexTypesPreEvent, vertexTypesPostEvent, verticesDeleted
		# [. . .]
		if item['@name'] in listNames:
			if '#text' not in item: continue
			retDict[item['@name']] = list(map(int, item['#text'].split(' ')))

		# edgesAdded, edgesDeleted
		# [srcVertex, dstVertex, type]
		elif item['@name'] in edgeNames:
			ret = []

			if 'item' not in item: continue
			for row in item['item']:
				rowSplit = row.split(' ')
				ret.append((int(rowSplit[0]), int(rowSplit[1]), rowSplit[2]))

			retDict[item['@name']] = ret

		# Tsim, simulationEndTime
		else:
			if '#text' not in item: continue			
			retDict[item['@name']] = int(item['#text'])

	return retDict

# ====================================================================================
# Take in a 911 output xml file and convert it to a python dict for easier use

def getAllEdges(fileName):
	# Get xml file to read from
	with open(fileName, 'r') as reader:
		xmlStr = reader.read()

	fileDump = dict(dict(xmltodict.parse(xmlStr)['SimState'])['Matrix'])['item']
	fileDump = [each.split(' ') for each in fileDump]
	fileDump = [(int(each[0]), int(each[1]), each[2]) for each in fileDump]

	return fileDump

# ====================================================================================
# Draw a plot of the vertex and edge type map

def makeplot(vertices, edges):
	# xRange = (min(vertices, key=lambda x:x[0])[0], max(vertices, key=lambda x:x[0])[0])
	# yRange = (min(vertices, key=lambda x:x[1])[1], max(vertices, key=lambda x:x[1])[1])

	for each in edges:
		# Too many RC edges to make any sense
		if (each[2] == 'RC'): continue	

		src = vertices[each[0]]
		dst = vertices[each[1]]

		colorList = {	'PP' : 'g',
						'CP' : 'y',
						'PR' : 'b'}

		color = colorList[each[2]]

		# Draw a line between src and dst vertices
		plt.plot([src[0], dst[0]], [src[1], dst[1]], color)

	for each in vertices:
		if (each[2] == 0): continue

		colorList = {	3 : 'yo',
						4 : 'ro',
						5 : 'bo' }

		color = colorList[each[2]]

		# Draw a dot at the x-y locations of each vertex
		plt.plot(each[0], each[1], color)

	# Display map
	plt.show()

# ====================================================================================

main()
