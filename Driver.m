
close all
clear global
clear
clc

% -----------------------------
% colorMap to control coloring in output figure
% -----------------------------
global colorMap2;
colorMap2.CP = [167,162,169]/255;   % light grey
colorMap2.PR = [115,113,252]/255;   % lavender
colorMap2.PP = [255,46,140]/255;    % pink
colorMap2.CALR = [114,239,221]/255; % light blue
colorMap2.PSAP = [255,46,140]/255;  % pink
colorMap2.RESP = [115,113,252]/255; % lavender

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
jpgFileName = 'output.svg';
makeMap(eList, vList, outputSt, jpgFileName, false)

