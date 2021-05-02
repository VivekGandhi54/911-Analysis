
% makeMap takes in an edge list (eList), vertex list (vList), and output
%   file info struct (ouputSt), and draws the 911 vertex and edge map.
% 
% Usage:
%   ouputSt = parseOutput(outputFileName, edgesFileName);
%   eList = ouputSt.oldEdges;
%   vList = ouputSt.vertexTypesPreEvent;
%   makeMap(eList, vList, ouputSt);
%
% Run `opengl('save','software')` and reload shell to run on Raiju/Otachi

% ======================================================

function makeMap(eList, vList, ouputSt, filename)
    fig = figure;
    hold on

    % Set figure limits and stuff
    xlim([min(ouputSt.xloc) - 1, max(ouputSt.xloc) + 1])
    ylim([min(ouputSt.xloc) - 1, max(ouputSt.xloc) + 1])

    % For each edge
    for i = 1:length(eList)
        edges = sortrows(eList, 3); % Helps to draw PP and PR on top

        if (edges(i, 3) == 6)       % Do not draw RC
            continue
        end

        if (edges(i, 3) == 4)       % CP
            color = 'y';
        elseif (edges(i, 3) == 5)   % PR
            color = 'g';
        else                        % PP
            color = 'r';
        end

        srcV = edges(i, 1) + 1;
        dstV = edges(i, 2) + 1;

        % Draw line segment edge
        plot([ouputSt.xloc(srcV), ouputSt.xloc(dstV)], [ouputSt.yloc(srcV), ouputSt.yloc(dstV)], color);
    end

    % For each vertex (draw vertices over edges)
    for i = 1:length(vList)
        if (vList(i) == 0)          % VTYPE_UNDEF (Deleted vertex)
            continue
        end

        if (vList(i) == 3)          % CALR
            color = 'y';
        elseif (vList(i) == 4)      % PSAP
            color = 'r';
        else                        % RESP
            color = 'b';
        end
        
        % Plot each vertex
        scatter(ouputSt.xloc(i), ouputSt.yloc(i), '', 'MarkerFaceColor', color)
    end

    hold off
    saveas(fig, filename)

end

% ======================================================
