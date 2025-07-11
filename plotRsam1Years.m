% plotRsam1Years
% 
% Just plots one RSAM channel
%
% R.C. Stewart, 2023-04-18

close all;
clear;
setup = setupGlobals();

dirRsam = setup.DirRsam;
%dirRsam = '/mnt/earthworm3/monitoring_data/rsam/';

station = 'MSS1';
stachan = 'MSS1_SHZ';
nrmean = 11;

figure_size( 'l' );
hold on;

year1 = 2014;
year2 = 2023;
nyears = year2 - year1 + 1;

for year = year1:year2

    datimBegYear = datenum( year, 1, 1, 0, 0, 0 );
    datimEndYear = datenum( year+1, 1, 1, 0, 0, 0 );
    xLimits = [ datimBegYear datimEndYear ];

    fileRsam = sprintf( '%4d_rsam_%s_60sec.dat', year, stachan );
    fileRsam = fullfile( dirRsam, fileRsam );
    [dataRsam1,datimRsam1] = readRsamFile( fileRsam );

    dataRsam1 = nan_rmean( dataRsam1, nrmean );

    subplot( nyears, 1, year-year1+1 );
    semilogy( datimRsam1, dataRsam1, 'b-' );

    xlim( xLimits );
    ylim([8 300]);
    datetick( 'x', 3 );
    ylabel( sprintf( '%4d', year ) );
    grid on;

    set(gca,'TickDir','out');

    if year < year2
        set(gca,'Xticklabel',[]);
    end
    

end
    

plotOverTitle( 'MSS1.SHZ RSAM (11-point running mean)' );
%plotOverTitle( 'MSS1.SHZ RSAM 2014-2023' );

