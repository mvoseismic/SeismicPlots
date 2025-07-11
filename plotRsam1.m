% plotRsam1
% 
% Just plots one RSAM channel
%
% R.C. Stewart, 2023-04-18

close all;
clear;
setup = setupGlobals();

%dirRsam = setup.DirRsam;
dirRsam = '/mnt/earthworm3/monitoring_data/rsam/';


% User input
[datesBeg, datesEnd] = askDates('now-1','now');
datesBeg = datesBeg + 4.0/24.0;
datesEnd = datesEnd + 4.0/24.0;
%datesBeg = datenum( 2023, 9, 19, 0,0,0);
%datesEnd = datenum( 2023,9,19,12,0,0);
station = inputd( 'Station (MSS1)', 's', 'MSS1' );
dataBand = inputd( 'Broadband or short-period (b/s)', 's', 'b' );
nrmean = inputd( 'Running mean', 'i', 1 );
nrmedian = inputd( 'Running median', 'i', 1 );
yLogScale = inputd( 'Log Y scale (y/n)', 's', 'n' );
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
        if strcmp( dataBand, 's' )
            stachan = 'MBHA_EHZ';
        else
            stachan = 'MBHA_HHZ';
        end
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
        yLimits = [0 1000];
    case 'MBWH'
        if strcmp( dataBand, 's' )
            stachan = 'MBWH_EHZ';
        else
            stachan = 'MBWH_HHZ';
        end
    case 'MSS1'
        stachan = 'MSS1_SHZ';
        yLimits = [0 1000];
end


tit= sprintf( '%s RSAM: %s to %s', strrep( stachan, '_', ' '), ...
    datestr( datesBeg ), datestr( datesEnd ) );


figure_size( 's' );

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

if nrmean > 1
    dataRsam1 = nan_rmean( dataRsam1, nrmean );
elseif nrmedian > 1
    dataRsam1 = nan_rmedian( dataRsam1, nrmean );
end

if strcmp( yLogScale, 'y' )
    semilogy( datimRsam1, dataRsam1, 'b-' );
else
    plot( datimRsam1, dataRsam1, 'b-' );
end

xlim( xLimits );
datetick( 'x', 'keeplimits' );
title( tit );

if strcmp( yLimScale, 'y' )
    ylim( yLimits );
end

grid on;

fileSave = 'fig-rsam1.png';
saveas( gcf, fileSave );