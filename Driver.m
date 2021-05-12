
close all
clear global
clear
clc

% -----------------------------
% colorMap to control coloring in output figure
% -----------------------------
global colorMap; 
colorMap.CP = 'y';
colorMap.PR = 'g';
colorMap.PP = 'r';
colorMap.CALR = 'y';
colorMap.PSAP = 'r';
colorMap.RESP = 'b';

% -----------------------------
% Unwrap and parse file data
% -----------------------------
outputFileName = 'test-small-out-911.xml';
edgesFileName = 'allEdges.xml';
outputSt = parseOutput(outputFileName, edgesFileName);

% -----------------------------
% Pick edge and vertex lists
% -----------------------------
eList = outputSt.oldEdges;
% eList = outputSt.disconnected;
% eList = outputSt.newEdges;

vList = outputSt.vertexTypesPreEvent;
% vList = outputSt.vertexTypesPostEvent;

% -----------------------------
% Draw figure
% -----------------------------
makeMap(eList, vList, outputSt)



