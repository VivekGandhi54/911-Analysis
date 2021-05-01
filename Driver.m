
close all
clear
clc

outputFileName = 'test-small-out-911.xml';
edgesFileName = 'allEdges.xml';
ouputSt = parseOutput(outputFileName, edgesFileName);

eList = ouputSt.newEdges;
vList = ouputSt.vertexTypesPostEvent;

% eList = ouputSt.oldEdges;
% vList = ouputSt.vertexTypesPreEvent;

makeMap(eList, vList, ouputSt)

