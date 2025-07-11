% plotRsam6
% 
% Tests RSAM channels
%
% R.C. Stewart, 2023-04-18

close all;
clear;
setup = setupGlobals();

dirRsam = setup.DirRsam;
dirRsam = '/mnt/earthworm3/monitoring_data/rsam/';

% User input
[datesBeg, datesEnd] = askDates('now-1','now');

datimBegVec = datevec( datesBeg );
datimBegYear = datimBegVec(1);
datimEndVec = datevec( datesEnd );
datimEndYear = datimEndVec(1);
xLimits = [ datesBeg datesEnd ];

tit= sprintf( 'RSAM: %s to %s', ...
    datestr( datesBeg ), datestr( datesEnd ) );

figure_size( 's' );

for ista = 1:4
    switch ista
        case 1
            stachan = 'MBWH_BHZ';
        case 2
            stachan = 'MBWH_SHZ';
        case 3
            stachan = 'MBWH_HHZ';
        case 4
            stachan = 'MBWH_EHZ';
    end

    fileRsam = sprintf( '%4d_rsam_%s_60sec.dat', datimBegYear, stachan );
    fileRsam = fullfile( dirRsam, fileRsam );
    [dataRsam1,datimRsam1] = readRsamFile( fileRsam );

    subplot(4,1,ista);

    plot( datimRsam1, dataRsam1, 'b-' );
    xlim( xLimits );
    datetick( 'x', 'keeplimits' );
    ylabel( strrep( stachan, '_', ' ') );

    grid on;

end

plotOverTitle( tit );
