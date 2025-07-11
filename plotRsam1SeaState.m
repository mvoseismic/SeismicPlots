% plotRsam1SeaState
% 
% Just plots one RSAM channel, with sea state at buoy 42060
%
% R.C. Stewart, 2024-05-07

close all;
clear;
setup = setupGlobals();

%dirRsam = setup.DirRsam;
dirRsam = '/mnt/earthworm3/monitoring_data/rsam/';


% User input
[datesBeg, datesEnd] = askDates('now-1','now');
%datesBeg = datenum( 2023, 9, 19, 0,0,0);
%datesEnd = datenum( 2023,9,19,12,0,0);
station = inputd( 'Station (MSS1)', 's', 'MSS1' );
dataBand = inputd( 'Broadband or short-period (b/s)', 's', 'b' );
nrmedian = inputd( 'Running median', 'i', 1 );
yLimScale = inputd( 'Limit Y scale (y/n)', 's', 'n' );

datimBegVec = datevec( datesBeg );
datimBegYear = datimBegVec(1);
datimEndVec = datevec( datesEnd );
datimEndYear = datimEndVec(1);
xLimits = [ datesBeg datesEnd ];



switch station
    case 'MBBY'
        if strcmp( dataBand, 's' )
            stachan = 'MBBY_EHZ';
        else
            stachan = 'MBBY_HHZ';
        end
    case 'MBFR'
        if strcmp( dataBand, 's' )
            stachan = 'MBFR_EHZ';
        else
            stachan = 'MBFR_HHZ';
        end
    case 'MBGH'
        if strcmp( dataBand, 's' )
            stachan = 'MBGH_EHZ';
        else
            stachan = 'MBGH_HHZ';
        end
    case 'MBHA'
        stachan = 'MBHA_SHZ';
    case 'MBLG'
        if strcmp( dataBand, 's' )
            stachan = 'MBLG_EHZ';
        else
            stachan = 'MBLG_HHZ';
        end
    case 'MBLY'
        if strcmp( dataBand, 's' )
            stachan = 'MBLY_EHZ';
        else
            stachan = 'MBLY_HHZ';
        end
    case 'MBWH'
        if strcmp( dataBand, 's' )
            stachan = 'MBWH_BHZ';
        else
            stachan = 'MBWH_SHZ';
        end
    case 'MSS1'
        stachan = 'MSS1_SHZ';
        yLimits = [0 500];
end


tit= sprintf( '%s RSAM: %s to %s', strrep( stachan, '_', ' '), ...
    datestr( datesBeg ), datestr( datesEnd ) );


fileRsam = sprintf( '%4d_rsam_%s_60sec.dat', datimBegYear, stachan );
fileRsam = fullfile( dirRsam, fileRsam );
[dataRsam1,datimRsam1] = readRsamFile( fileRsam );

if datimBegYear ~= datimEndYear
    fileRsam = sprintf( '%4d_rsam_%s_60sec.dat', datimEndYear, stachan );
    fileRsam = fullfile( dirRsam, fileRsam );
    [dataRsam1a,datimRsam1a] = readRsamFile( fileRsam );
    dataRsam1 = [dataRsam1; dataRsam1a];
    datimRsam1 = [datimRsam1; datimRsam1a];
end

if nrmedian > 1
    dataRsam1rmedian = nan_rmedian( dataRsam1, nrmedian );
    dataRsam1 = dataRsam1 - dataRsam1rmedian;
end


data_file = fullfile( setup.DirMegaplotData, 'fetchedWeatherNDBCrt.mat' );
load( data_file );
datim = datimB42060;
waveDir = waveDirB42060;
waveDir( waveDir > 270 ) = ...
waveDir( waveDir > 270 ) - 360;
waveHeight = waveHeightB42060;
titb = 'Buoy 42060 (63 NM WSW of Montserrat)';


figure;
figure_size( 'l' );

tiledlayout(5,1);

nexttile(5);

plot( datimRsam1, dataRsam1, 'b-' );
xlim( xLimits );
datetick( 'x', 'keeplimits' );
title( tit );
grid on;
if strcmp( yLimScale, 'y' )
    ylim( yLimits );
end
ylabel( 'Modified RSAM');
xlabel( 'UTC' );


nexttile(1);
yyaxis left
plot( datim, waveDir, 'o', 'MarkerSize', 3 );
ylim( [-90 360] );
yticks( [-90 0 90 180 270] );
ylabel( {'Wave direction','(degrees from N)'} );

yyaxis right;
plot( datim, waveHeight, 'o', 'MarkerSize', 3 );
ylim( [-1 2] );
yticks( [0 1 2] );
ylabel( {'Wave height','(metres)'} );

xlim( xLimits );
datetick( 'x', 'keeplimits' );
title( titb );

nexttile(2);
title( 'Stacked SP helicorders' );
xticks([]);
yticks([]);

stations = {'MBRY','','','','','','MBFR','','','','','','MBLY','','','','','','MSS1'};
annotation( 'textbox', 'String', stations, 'Color', 'black', ...
            'FontSize', 14, 'Units', 'normalized', 'EdgeColor', 'none', ...
            'Position', [0.03,0.3,0.1,0.4], ...
            'VerticalAlignment', 'middle')


fileSave = 'fig-rsam1SeaState.png';
saveas( gcf, fileSave );

