% plotRsam6
% 
% Plots six RSAM channels
%
% R.C. Stewart, 2023-04-18

close all;
clear;
setup = setupGlobals();

dirRsam = setup.DirRsam;
dirRsam = '/mnt/earthworm3/monitoring_data/rsam/';

% User input
[datesBeg, datesEnd] = askDates('now-1','now');
dataBand = inputd( 'Broadband or short-period (b/s)', 's', 'b' );
nrmean = inputd( 'Running mean', 'i', 1 );
nrmedian = inputd( 'Running median', 'i', 1 );
yLogScale = inputd( 'Log Y scale (y/n)', 's', 'n' );
yLimScale = inputd( 'Limit Y scale (y/n)', 's', 'n' );

%datesBeg = datenum( 2024, 6, 4, 6, 0, 0);
%datesEnd = datenum( 2024, 6, 4, 14, 0, 0);

datimBegVec = datevec( datesBeg );
datimBegYear = datimBegVec(1);
datimEndVec = datevec( datesEnd );
datimEndYear = datimEndVec(1);
xLimits = [ datesBeg datesEnd ];

tit= sprintf( 'RSAM: %s to %s', ...
    datestr( datesBeg ), datestr( datesEnd ) );

figure_size( 's' );

for ista = 1:6
    switch ista
        case 1
            stachan = 'MSS1_SHZ';
%            yLimits = [0 200];
            yLimits = [0 2500];
        case 2
            if strcmp( dataBand, 's' )
                stachan = 'MBFR_EHZ';
%                yLimits = [0 2000];
                yLimits = [0 10000];
            else
                stachan = 'MBFR_HHZ';
                yLimits = [0 2000];
            end
        case 3
            if strcmp( dataBand, 's' )
%                yLimits = [0 2000];
                yLimits = [0 10000];
            else
                stachan = 'MBLG_HHZ';
                yLimits = [0 2000];
            end
        case 4
            if strcmp( dataBand, 's' )
%                yLimits = [0 2000];
                yLimits = [0 10000];
            else
                stachan = 'MBLY_HHZ';
                yLimits = [0 2000];
            end
        case 5
            if strcmp( dataBand, 's' )
                stachan = 'MBGH_EHZ';
                yLimits = [0 2000];
            else
                stachan = 'MBGH_HHZ';
                yLimits = [0 2000];
            end
        case 6
            if strcmp( dataBand, 's' )
                stachan = 'MBWH_EHZ';
                yLimits = [0 2000];
            else
                stachan = 'MBWH_HHZ';
                yLimits = [0 1500];
            end
    end

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

    subplot(6,1,ista);

    if strcmp( yLogScale, 'y' )
        semilogy( datimRsam1, dataRsam1, 'b-' );
    else
        plot( datimRsam1, dataRsam1, 'b-' );
    end

    if strcmp( yLimScale, 'y' )
        ylim( yLimits );
    end

    xlim( xLimits );
    datetick( 'x', 'keeplimits' );
    ylabel( strrep( stachan, '_', ' ') );

    grid on;

end

plotOverTitle( tit );
fileSave = 'fig-rsam6.png';
saveas( gcf, fileSave );