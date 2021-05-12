
% parseOutput reads the XML output files and returns a
%   struct with any useful information.
% 
% Usage:
%   outputFileName = 'test-small-out-911.xml';
%   edgesFileName = 'allEdges.xml';
%   retVal = parseOutput(outputFileName, edgesFileName);
% 
% Field names:
%     'xloc'                
%     'yloc'                
%     'vertexTypesPreEvent' 
%     'vertexTypesPostEvent'
%     'verticesDeleted'     
%     'edgesDeleted'        
%     'edgesAdded'          
%     'Tsim'                
%     'simulationEndTime'   
%     'oldEdges'            
%     'newEdges'            

% ======================================================

function retVal = parseOutput(outputFile, oldEdgesFile)
    % --------------------------------------------------
    % Unwrap output
    
    mlStruct = parseXML(outputFile);
    allFields = mlStruct(2).Children;

    for c = 1:length(allFields)
        eachField = allFields(c);

        % Ignore comments
        if strcmp(eachField.Name, '#text')
            continue
        end

        % find fieldName
        for i = 1:length(eachField.Attributes)
            if strcmp(eachField.Attributes(i).Name, 'name')
                fieldName = eachField.Attributes(i).Value;
                break;
            end
        end

        % Convert all to data
        data = str2num(eachField.Children.Data);

        % Save to struct
        if strcmp(fieldName, 'xloc')
            retVal.xloc = data;
        elseif strcmp(fieldName, 'yloc')
            retVal.yloc = data;
        elseif strcmp(fieldName, 'vertexTypesPreEvent')
            retVal.vertexTypesPreEvent = data;
        elseif strcmp(fieldName, 'vertexTypesPostEvent')
            retVal.vertexTypesPostEvent = data;
        elseif strcmp(fieldName, 'verticesDeleted')
            retVal.verticesDeleted = data;
        elseif strcmp(fieldName, 'edgesDeleted')
            retVal.edgesDeleted = data;
        elseif strcmp(fieldName, 'edgesAdded')
            retVal.edgesAdded = data;
        elseif strcmp(fieldName, 'Tsim')
            retVal.Tsim = data;
        elseif strcmp(fieldName, 'simulationEndTime')
            retVal.simulationEndTime = data;
        end
    end
    
    % --------------------------------------------------
    % Unwrap oldEdges
    
    oldEdgesStruct = parseXML(oldEdgesFile);
    data = oldEdgesStruct(2).Children(2).Children.Data;
    retVal.oldEdges = str2num(data);
    
    % --------------------------------------------------
    % Generate new edge list
    % newEdges = (oldEdges + edgesAdded) - edgesDeleted

    retVal.newEdges = [retVal.oldEdges ; retVal.edgesAdded];
    retVal.disconnected = retVal.oldEdges;

    for c = 1:length(retVal.edgesDeleted)
        row = retVal.edgesDeleted(c,:);
        [Result,~] = ismember(retVal.newEdges,row,'rows');
        location = find(Result == 1);
        retVal.newEdges(location,:) = [];

        [Result,~] = ismember(retVal.disconnected,row,'rows');
        location = find(Result == 1);
        retVal.disconnected(location,:) = [];
    end
    
% ======================================================
% Take XML and convert it to MATLAB struct

function theStruct = parseXML(filename)
% PARSEXML Convert XML file to a MATLAB structure.
try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
try
   theStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML file %s.',filename);
end

% ======================================================
% ----- Local function PARSECHILDNODES -----
function children = parseChildNodes(theNode)
% Recurse over node children.
children = [];
if theNode.hasChildNodes
   childNodes = theNode.getChildNodes;
   numChildNodes = childNodes.getLength;
   allocCell = cell(1, numChildNodes);

   children = struct(             ...
      'Name', allocCell, 'Attributes', allocCell,    ...
      'Data', allocCell, 'Children', allocCell);

    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        children(count) = makeStructFromNode(theChild);
    end
end

% ======================================================
% ----- Local function MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

nodeStruct = struct(                        ...
   'Name', char(theNode.getNodeName),       ...
   'Attributes', parseAttributes(theNode),  ...
   'Data', '',                              ...
   'Children', parseChildNodes(theNode));

if any(strcmp(methods(theNode), 'getData'))
   nodeStruct.Data = char(theNode.getData); 
else
   nodeStruct.Data = '';
end

% ======================================================
% ----- Local function PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.

attributes = [];
if theNode.hasAttributes
   theAttributes = theNode.getAttributes;
   numAttributes = theAttributes.getLength;
   allocCell = cell(1, numAttributes);
   attributes = struct('Name', allocCell, 'Value', ...
                       allocCell);

   for count = 1:numAttributes
      attrib = theAttributes.item(count-1);
      attributes(count).Name = char(attrib.getName);
      attributes(count).Value = char(attrib.getValue);
   end
end

% ======================================================
