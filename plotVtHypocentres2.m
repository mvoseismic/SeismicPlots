% plotVtHypocentres2
%
% Like plotVtHypocentres, but has titles and no vertical exaggeration.
%
% R.C. Stewart 2023-03-30

close all;
clear;
setup = setupGlobals();
reFetch( setup );

% User input
[datesBeg, datesEnd] = askDates();
showDem = inputd( 'Show DEM (y/n)', 's', 'y' );
symbolType = inputd( 'Symbol type( f, m, md)', 's', 'm' );
addStations = inputd( 'Add stations (y/n)', 's', 'n' );
magCutoff = inputd( 'Magnitude cutoff', 'r', -1.0 );
% Test input
%datesBeg = datenum( 2023,1,1,0,0,0);
%datesEnd = datenum( 2023,4,1,0,0,0);
%mapScale = 'c';
%showDem = 'n';
%symbolType = 'm';
%addStations = 'n';

% Plot setup
setup.DatimBeg = datesBeg;
setup.DatimEnd = datesEnd;
dateLimits = [ datesBeg datesEnd ];
setup.PlotBeg = setup.DatimBeg;
setup.PlotEnd = setup.DatimEnd;

% Other fixed variables
%xLimits = [-3.1 3.1];
%yLimits = xLimits;
%zLimits = [-1.2 5];
%xTicks = -3:1:3;
%yTicks = xTicks;
%zTicks = 0:1:zLimits(2);
xLimits = [-4.1 4.1];
yLimits = xLimits;
zLimits = [-1.2 8];
xTicks = -4:1:4;
yTicks = xTicks;
zTicks = 0:1:zLimits(2);
latSummit =  16.7109182;
lonSummit = -62.1774199;

% Topography
[I,R] = fetchDem2014shaded( setup );
[X,Y,Z] = dem2xyz( I, R );
X = deg2km( X - lonSummit );
Y = deg2km( Y - latSummit );

% Create profiles
[latProfNS,altProfNS] = fetchDem2014Profile( setup, 'NS', lonSummit );
latProfNS = deg2km( latProfNS - latSummit );
altProfNS = -1* altProfNS/1000;
[lonProfEW,altProfEW] = fetchDem2014Profile( setup, 'EW', latSummit );
lonProfEW = deg2km( lonProfEW - lonSummit );
altProfEW = -1* altProfEW/1000;

% Hypocentres
Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );
if magCutoff > -1.0
    Ranges.mag = [magCutoff 9.9];
    Hypo2 = hypoSubsetRanges(Hypo2, Ranges);
end
hypo2MagSymbolSize = 30*([Hypo2.mag]-1);
hypo2MagSymbolSize(isnan(hypo2MagSymbolSize)) = 1;
hypo2MagSymbolSize( hypo2MagSymbolSize <= 1 ) = 1;
hypoX = deg2km( [Hypo2.lon] - lonSummit );
hypoY = deg2km( [Hypo2.lat] - latSummit );
hypoZ = [Hypo2.dep];
hypoMss = hypo2MagSymbolSize;
hypoOtime = [Hypo2.otime];

% Seismic stations
fileStations = '/home/seisan/src/SeismicStations/created/DataFiles/20230328-MVO.txt';
S = readtable( fileStations );
xStas = deg2km( [S.Longitude] - lonSummit );
yStas = deg2km( [S.Latitude] - latSummit );

% Figure Stuff
figure;
figure_size( 'p');
xStep = 1/210;
yStep = 1/297;

xPos1 = 10 * xStep;
xPos2 = 105 * xStep;
xLen1 = 90 * xStep;
xLen2 = 185 * xStep;

yPos1 = 1.0 - 105 * yStep;
yPos2 = 1.0 - 210 * yStep;
yPos3 = 1.0 - 270 * yStep;
yLen1 = 90 * yStep;
yLen2 = 90 * yStep;

ax1Pos = [xPos1 yPos1 xLen1 yLen1];
ax2Pos = [xPos2 yPos1 xLen1 yLen1];
ax3Pos = [xPos1 yPos2 xLen1 yLen1];
ax4Pos = [xPos2 yPos2 xLen1 yLen1];
ax5Pos = [xPos1 yPos3 xLen2 yLen2];


% Map
ax1 = axes( 'Position', ax1Pos );
if strcmp( showDem, 'y' )
    imagesc( ax1, X, Y, Z );
    gray2 = (gray/2) + 0.5;
    colormap(ax1, gray2);
    set(ax1,'YDir','normal');
end
hold on;
switch symbolType
    case 'f'
        plot( ax1, hypoX, hypoY, 'ro', 'MarkerSize', 4 );
    case 'm'
        scatter( ax1, hypoX, hypoY, 2*hypoMss, 'r' );
end
if strcmp( addStations, 'y' )
    plot( xStas, yStas, 'ko', 'MarkerFaceColor', 'g' );
end

text( -3, 2.85,'\uparrow N', 'BackgroundColor', 'w' );
xlim( xLimits );
ylim( yLimits );
grid(ax1,'on');
ax1.XAxis.FontSize = 8;
ax1.YAxis.FontSize = 8;
box on;

% Legend
ax2 = axes( 'Position', ax2Pos ); 
tit1 = 'VT hypocentres';
tit2 = sprintf( '%s to %s', ...
    datestr( datesBeg ), datestr( datesEnd ) );
if magCutoff > -1.0
    tit2 = strcat( tit2, sprintf( "  (ML > %3.1f)", magCutoff ) );
end
text( ax2, 1.0, 6.5, tit1, 'FontWeight', 'bold' );
text( ax2, 1.0, 6.0, tit2, 'FontWeight', 'bold' );
hold on;
text( ax2, 1.0, 5.5, 'Axes in kilometres.' );
text( ax2, 1.0, 5.1, 'Horizontally centred on conduit.' );
if strcmp( symbolType, 'm' )
    text( ax2, 2.0, 4.0, 'M_L', 'FontWeight', 'bold' );
    for mag = 1:5
        switch mag
            case 1
                symbolSize = 1;
            otherwise
                symbolSize = 30*(mag-1);
        end
        scatter( 1.5, (mag/1.5), symbolSize, 'r' );
        text( 2.0, (mag/1.5), sprintf( '%3.1f', mag) );
    end
end
if strcmp( addStations, 'y' )
    plot( 3.5, 4.0, 'ko', 'MarkerFaceColor', 'g' );
    text( 4.0, 4.0, 'Seismic station' );
end
xlim( [0 7] );
ylim( [0 7] );
set(ax2,'xtick',[]);
set(ax2,'ytick',[]);
set(ax2,'visible','off')

% EW section
ax3 = axes( 'Position', ax3Pos ); 
switch symbolType
    case 'f'
        plot( ax3, hypoX, hypoZ, 'ro', 'MarkerSize', 4 );
    case 'm'
        scatter( ax3, hypoX, hypoZ, hypoMss, 'r' );
end
hold on;
plot( lonProfEW, altProfEW, 'k-' );
xlim( yLimits );
ylim( zLimits );
set( ax3, 'YDir', 'reverse' );
title( 'EW profile');
grid(ax3,'on');
box on;
text( ax3, -3, -0.9, '\leftarrow W', 'BackgroundColor', 'w' );
text( ax3, 3, -0.9, 'E \rightarrow', 'BackgroundColor', 'w', 'HorizontalAlignment', 'right' );
ax3.XAxis.FontSize = 8;
ax3.YAxis.FontSize = 8;

% NS section
ax4 = axes( 'Position', ax4Pos ); 
switch symbolType
    case 'f'
        plot( ax4, hypoY, hypoZ, 'ro', 'MarkerSize', 4 );
    case 'm'
        scatter( ax4, hypoY, hypoZ, hypoMss, 'r' );
end
hold on;
plot( latProfNS, altProfNS, 'k-' );
xlim( xLimits );
ylim( zLimits );
set( ax4, 'YDir', 'reverse', ...
    'YAxisLocation', 'right' );
title( 'NS profile');
grid(ax4,'on');
box on;
text( ax4, -3, -0.9, '\leftarrow S', 'BackgroundColor', 'w' );
text( ax4, 3, -0.9, 'N \rightarrow', 'BackgroundColor', 'w', 'HorizontalAlignment', 'right' );
ax4.XAxis.FontSize = 8;
ax4.YAxis.FontSize = 8;

% Time section
ax5 = axes( 'Position', ax5Pos ); 
switch symbolType
    case 'f'
        plot( ax5, hypoOtime, hypoZ, 'ro', 'MarkerSize', 4 );
    case 'm'
        scatter( ax5, hypoOtime, hypoZ, hypoMss, 'r' );
end
hold on;
xlim( dateLimits );
ylim( zLimits );
set( ax5, 'YDir', 'reverse' );
datetick( 'x', 3, 'keeplimits' );
grid(ax5,'on');
box on;
ax5Pos = tightPosition( ax5 );
ax5Pos(4) = 0.15;
set( ax5, 'Position', ax5Pos );
title( 'Time v Depth');
ax5.XAxis.FontSize = 8;
ax5.YAxis.FontSize = 8;


fontsize(gcf, 16, 'points');

fileSave = 'fig-vt_hypocentres_2.png';
saveas( gcf, fileSave );

