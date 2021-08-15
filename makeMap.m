
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

function makeMap(eList, vList, ouputSt, filename, zones)
    global fig
    fig = figure;
    global colorMap2;
    
    % Default colorMap if undefined
    if isempty(colorMap2)
        colorMap2.CP = 'y';
        colorMap2.PR = 'g';
        colorMap2.PP = 'r';
        colorMap2.CALR = 'y';
        colorMap2.PSAP = 'r';
        colorMap2.RESP = 'b';
    end

    hold on
    box on
    
    % Set figure limits and stuff
    xlim([min(ouputSt.xloc) - 1, max(ouputSt.xloc) + 1])
    ylim([min(ouputSt.xloc) - 1, max(ouputSt.xloc) + 1])
    xticks(-1:10);
    yticks(-1:10);
    
    % Dummy plots for legend
    scatter(NaN,NaN,'','MarkerFaceColor',colorMap2.PSAP);
    scatter(NaN,NaN,'','MarkerFaceColor',colorMap2.RESP);
    scatter(NaN,NaN,'','MarkerFaceColor',colorMap2.CALR);
    plot([NaN,NaN],[NaN,NaN],'color',colorMap2.PP);
    plot([NaN,NaN],[NaN,NaN],'color',colorMap2.PR);
    plot([NaN,NaN],[NaN,NaN],'color',colorMap2.CP);

    % For each edge
    for i = 1:length(eList)
        edges = sortrows(eList, 3); % Helps to draw PP and PR on top

        if (edges(i, 3) == 6)       % Do not draw RC
            continue
        end

        if (edges(i, 3) == 4)       % CP
            color = colorMap2.CP;
            thickness = 0.6;
        elseif (edges(i, 3) == 5)   % PR
            color = colorMap2.PR;
            thickness = 1;
        else                        % PP
            color = colorMap2.PP;
            thickness = 1.4;
        end

        srcV = edges(i, 1) + 1;
        dstV = edges(i, 2) + 1;

        % Draw line segment edge
        plot([ouputSt.xloc(srcV), ouputSt.xloc(dstV)], [ouputSt.yloc(srcV), ouputSt.yloc(dstV)],'color', color,'LineWidth',thickness);
    end

    % For each vertex (draw vertices over edges)
    for i = 1:length(vList)
        if (vList(i) == 0)          % VTYPE_UNDEF (Deleted vertex)
            continue
        end

        if (vList(i) == 3)          % CALR
            color = colorMap2.CALR;
            markerSize = 30;
        elseif (vList(i) == 4)      % PSAP
            color = colorMap2.PSAP;
            markerSize = 90;
        else                        % RESP
            color = colorMap2.RESP;
            markerSize = 65;
        end
        
        % Plot each vertex
        scatter(ouputSt.xloc(i), ouputSt.yloc(i), markerSize, color, 'filled')
    end

    if (zones)
        plot([-0.5,9.5],[4.5,4.5],'color',[20,20,20]/255);
        plot([4.5,4.5],[-0.5,9.5],'color',[20,20,20]/255);
    end
    
    % Add legend
    legend('PSAP','RESP','CALR','PP','PR','CP', 'location', 'NorthEastOutside');

    saveas(fig, filename)

end

% ======================================================
