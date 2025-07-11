% plot_vt_hypocentres
%
% R.C. Stewart 2023-03-30

close all;
clear;
setup = setupGlobals();
reFetch( setup );

% For subplot positions
xPos1 = 0.1;
yPos1 = 0.5;
xLen1 = 0.42;
yLen1 = xLen1;

xPos2 = 0.53;
yPos2 = yPos1;
xLen2 = 0.15;
yLen2 = yLen1;

xPos3 = xPos1;
yPos3 = 0.34;
xLen3 = xLen1;
yLen3 = xLen2;

xPos4 = xPos2;
yPos4 = yPos3;
xLen4 = xLen2;
yLen4 = 0.14;

xPos5 = xPos1;
yPos5 = 0.15;
xLen5 = 0.58;
yLen5 = xLen2;

% User input
[datesBeg, datesEnd] = askDates();
mapScale = inputd( 'Scale of map (n/c/w)', 's', 'n' );
showDem = inputd( 'Show DEM (y/n)', 's', 'y' );
symbolType = inputd( 'Symbol type( f, m, md)', 's', 'f' );
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
setup.SubplotSpace = 'normal';
setup.PlotXaxis = 'normal';

% Other fixed variables
depLimits = [-1.2 5];
dTicks = 0:1:depLimits(2);
latSummit =  16.7109182;
lonSummit = -62.1774199;
latKmTicks = latSummit-5*km2deg(1):km2deg(1):latSummit+5*km2deg(1);
lonKmTicks = lonSummit-5*km2deg(1):km2deg(1):lonSummit+5*km2deg(1);

% DEM
[I,R] = fetchDem2014Shaded0( setup );
% Fiddle for plotting
I(isnan(I)) = 180.0;
I(I==0) = 180.0;

% Create profiles
[latProfNS,altProfNS] = fetchDem2014Profile( setup, 'NS', lonSummit );
altProfNS = -1* altProfNS/1000;
[lonProfEW,altProfEW] = fetchDem2014Profile( setup, 'EW', latSummit );
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

% Seismic stations
fileStations = '/home/seisan/src/SeismicStations/created/DataFiles/20230328-MVO.txt';
S = readtable( fileStations );

% Set map scale
if strcmp( mapScale, 'c' )
    lonLimits =  [-62.195 -62.160];
    latLimits = [16.7 16.735];
elseif strcmp( mapScale, 'w')
    lonLimits =  [-62.22 -62.135];
    latLimits = [16.675 16.76];
else
    lonLimits =  [-62.215 -62.14];
    latLimits = [16.675 16.75];
end
boxX = [lonLimits(1) lonLimits(2) lonLimits(2) lonLimits(1) lonLimits(1) ];
boxY = [latLimits(1) latLimits(1) latLimits(2) latLimits(2) latLimits(1) ];

% Plot
figure_size( 's');



% Map
subplot(4,4,[1 2 5 6]);

yyaxis left;
if strcmp( showDem, 'y' )
    geoshow( I, R, 'DisplayType', 'surface' );
    cmap = (gray/2)+0.5;
    colormap( cmap );
else
    plot( lonSummit, latSummit, 'w.' );
end
%axis square;
xlim( lonLimits );
ylim( latLimits );
set(gca,'xtick',[]);
set(gca,'ytick',[]);

yyaxis right;
switch symbolType
    case 'f'
        plot( [Hypo2.lon], [Hypo2.lat], 'ro', 'MarkerSize', 4 );
    case 'm'
        scatter( [Hypo2.lon], [Hypo2.lat], hypo2MagSymbolSize, 'r', 'LineWidth', 1 );
end
hold on;
xline( lonSummit, 'k:' );
yline( latSummit, 'k:' );
if strcmp( addStations, 'y' )
    plot( S.Longitude, S.Latitude, 'ko', 'MarkerFaceColor', 'g' );
end
plot( boxX, boxY, 'k-' );
if strcmp( showDem, 'y' )
    plot( boxX(3:4), boxY(3:4), 'k-', 'LineWidth', 2 );
end
xlim( lonLimits );
ylim( latLimits );
set(gca,'xtick',[]);
set(gca,'ytick',[]);

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

pos1 = tightPosition( gca );
pos1(1) = xPos1;
pos1(2) = yPos1;
pos1(3) = xLen1;
pos1(4) = yLen1;
set( gca, 'Position', pos1 );



% N-S section
subplot(4,4,[3 7]);
switch symbolType
    case 'f'
        plot( [Hypo2.dep], [Hypo2.lat], 'ro', 'MarkerSize', 4 );
    case 'm'
        scatter( [Hypo2.dep], [Hypo2.lat], hypo2MagSymbolSize, 'r' );
end
hold on;
plot( altProfNS, latProfNS, 'k-' );
xline( 0, 'k:' );
yline( latSummit, 'k:' );
xlim( depLimits );
ylim( latLimits );
%xlabel( 'Depth (km)' );
xticks( dTicks );
yticks( latKmTicks );
set(gca,'YTickLabel',[]);
ylabel( 'N-S Section' );
set( gca, 'YAxisLocation', 'right' );
box on;
%grid on;

pos2 = tightPosition( gca );
pos2(1) = xPos2;
pos2(2) = yPos2;
pos2(3) = xLen2;
pos2(4) = yLen2;
set( gca, 'Position', pos2 );



% E-W section
subplot(4,4,[9 10]);
switch symbolType
    case 'f'
        plot( [Hypo2.lon], [Hypo2.dep], 'ro', 'MarkerSize', 4 );
    case 'm'
        scatter( [Hypo2.lon], [Hypo2.dep], hypo2MagSymbolSize, 'r' );
end
hold on;
plot( lonProfEW, altProfEW, 'k-' );
xline( lonSummit, 'k:' );
yline( 0, 'k:' );
xlim( lonLimits );
ylim( depLimits );
set( gca, 'YDir', 'reverse' );
xticks( lonKmTicks );
set(gca,'XTickLabel',[]);
yticks( dTicks );
xlabel( 'E-W Section' );
ylabel( 'Depth (km)' );
box on;
%grid on;

pos3 = tightPosition( gca );
pos3(1) = xPos3;
pos3(2) = yPos3;
pos3(3) = xLen3;
pos3(4) = yLen3;
set( gca, 'Position', pos3 );



% Legend
if strcmp( symbolType, 'm' )
    subplot(4,4,11);
    hold on;
    text( 1.5, 5.5, 'M_L', 'FontWeight', 'bold' );
    for mag = 1:5
        switch mag
            case 1
                symbolSize = 1;
            otherwise
                symbolSize = 30*(mag-1);
        end
        scatter( 1, mag-0.5, symbolSize, 'r' );
        text( 1.5, mag-0.5, sprintf( '%3.1f', mag) );
    end

    xlim( [0 6.5] );
    ylim( [0 6] );
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    box on;
    pos4 = tightPosition( gca );
    pos4(1) = xPos4;
    pos4(2) = yPos4;
    pos4(3) = xLen4;
    pos4(4) = yLen4;
    set( gca, 'Position', pos4 );

end


% Time section
subplot(4,4,13:15);
switch symbolType
    case 'f'
        plot( [Hypo2.otime], [Hypo2.dep], 'ro', 'MarkerSize', 4 );
    case 'm'
        scatter( [Hypo2.otime], [Hypo2.dep], hypo2MagSymbolSize, 'r' );
end
hold on;
yline( 0, 'k:' );
xlim( dateLimits );
ylim( depLimits );
set( gca, 'YDir', 'reverse' );
datetick( 'x', 'keeplimits' );
yticks( dTicks );
xlabel( 'Date (UTC)' );
ylabel( 'Depth (km)' );
box on;
%grid on;

pos5 = tightPosition( gca );
pos5(1) = xPos5;
pos5(2) = yPos5;
pos5(3) = xLen5;
pos5(4) = yLen5;
set( gca, 'Position', pos5 );

overTitle = sprintf( 'VT hypocentres: %s to %s                     ', ...
    datestr( datesBeg ), datestr( datesEnd ) );
if magCutoff > -1.0
    overTitle = strcat( overTitle, sprintf( "  (ML > %3.1f)", magCutoff ) );
end
plotOverTitle( overTitle );

fileSave = 'fig-vt_hypocentres.png';
saveas( gcf, fileSave );

%cmd = join( ['magick mogrify -crop 1350x1550+0+0', ' ', fileSave] );
%system( cmd );