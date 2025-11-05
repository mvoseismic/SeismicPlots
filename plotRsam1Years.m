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

station = 'MBGH';
nrmean = 31;

figure_size( 'l' );
hold on;

year1 = 2010;
year2 = 2025;
nyears = year2 - year1 + 1;

for year = year1:year2

    datimBegYear = datenum( year, 1, 1, 0, 0, 0 );
    datimEndYear = datenum( year+1, 1, 1, 0, 0, 0 );
    xLimits = [ datimBegYear datimEndYear ];

    stachan = 'MBGH_SHZ';
    fileRsam = sprintf( '%4d_rsam_%s_60sec.dat', year, stachan );
    fileRsam = fullfile( dirRsam, fileRsam );
    [dataRsam1,datimRsam1] = readRsamFile( fileRsam );
    dataRsam1 = nan_rmean( dataRsam1, nrmean );

    stachan = 'MBGH_EHZ';
    fileRsam = sprintf( '%4d_rsam_%s_60sec.dat', year, stachan );
    fileRsam = fullfile( dirRsam, fileRsam );
    [dataRsam2,datimRsam2] = readRsamFile( fileRsam );
    dataRsam2 = 1.5 * dataRsam2;
    dataRsam2 = nan_rmean( dataRsam2, nrmean );

    subplot( nyears, 1, year-year1+1 );
    plot( datimRsam1, dataRsam1, 'b-' );
    hold on;
    plot( datimRsam2, dataRsam2, 'r-' );
    box on;

    xlim( xLimits );
    ylim( [0 12000] );
    datetick( 'x', 3 );
    ylabel( sprintf( '%4d', year ),"Rotation",0 );
    set(gca,'YTick',[])

    set(gca,'TickDir','out');
    ax = gca;
    ax.TickLength = ax.TickLength/5.0;

    if year < year2
        set(gca,'Xticklabel',[]);
    end

    set(gca,'fontsize', 14);
    

end
    

plotOverTitle( 'MBGH SP RSAM (31-point running mean) (Radian data in red)' );

