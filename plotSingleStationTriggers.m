% plotSingleStationTriggers
% Plots trigger counts
%
% R.C. Stewart, 2024-06-07

clear;
close all;
setup = setupGlobals();


% User input
[datesBeg, datesEnd] = askDates('now-1','now');
binWidthHours = double( inputd( 'Bin width (hours)', 'i', 3 ) );


datimBegVec = datevec( datesBeg );
datimBegYear = datimBegVec(1);
datimEndVec = datevec( datesEnd );
datimEndYear = datimEndVec(1);
xLimits = [ datesBeg datesEnd ];





switch binWidthHours
    case 1
        tit = 'MSS1 triggers per hour';
    case 24
        tit = 'MSS1 triggers per day';
    otherwise
        tit = sprintf( "MSS1 triggers per %d hours", binWidthHours );
end



fileTriggers = "/home/seisan/tmp--DONT_USE/mseedTriggers/triggerLists/mseed_trigger_list-MSS1.txt";
T = readtable( fileTriggers );

trigDatetime = T.Var1 + T.Var2;
trigDatetime.Format = 'yyyy-MM-dd HH:mm:ss';
trigAmpPeak = T.Var10;
trigAmpRms = T.Var12;

trigDatenum = datenum( trigDatetime );
%datenumBeg = floor( trigDatenum(1) );
%datenumEnd = ceil( trigDatenum(end) );
datenumBeg = floor( datesBeg );
datenumEnd = ceil( datesEnd );
bins = datenumBeg:binWidthHours/24:datenumEnd;



dirRsam = '/mnt/earthworm3/monitoring_data/rsam/';
stachan = 'MSS1_SHZ';
dataRsam = [];
datimRsam = [];
nrmean = 1;
nrmedian = 1;

for iYear = datimBegYear:datimEndYear

    fileRsam = sprintf( '%4d_rsam_%s_60sec.dat', iYear, stachan );
    fileRsam = fullfile( dirRsam, fileRsam );
    [dataRsam1,datimRsam1] = readRsamFile( fileRsam );
    dataRsam = [ dataRsam; dataRsam1 ];
    datimRsam = [ datimRsam; datimRsam1 ];

end

if nrmean > 1
    dataRsam = nan_rmean( dataRsam, nrmean );
elseif nrmedian > 1
    dataRsam = nan_rmedian( dataRsam, nrmean );
end




figure;
figure_size( 'p' );

tiledlayout('vertical');

nexttile(1);
histogram( trigDatenum, bins );
xlim( xLimits );
datetick( 'x', 10, 'keeplimits' );
ylabel( "Count" );
grid on;
xlabel( 'UTC' );
title( tit );
set( gca, 'FontSize', 16 );


nexttile(3);
plot( trigDatenum, trigAmpPeak, 'ko', 'MarkerFaceColor', 'r' );
xlim( xLimits );
datetick( 'x', 10, 'keeplimits' );
ylim( [10e0 10e4] );
ylabel( "Amplitude" );
grid on;
xlabel( 'UTC' );
title( 'Event peak amplitude (MSS1)' );
set(gca, 'YScale', 'log');
set( gca, 'FontSize', 16 );

%{
nexttile(4);
[datimRsam, dataRsam] = getMedianDailyRsam(datimRsam,dataRsam);
plot( datimRsam, dataRsam, 'k-' );
xlim( xLimits );
datetick( 'x', 10, 'keeplimits' );
ylabel( "MSS1 RSAM" );
grid on;
xlabel( 'UTC' );
title( 'MSS1 median daily RSAM' );
set( gca, 'FontSize', 16 );
%ylim( [0 5000] );
%}

nexttile(2);
data_file = fullfile( setup.DirMegaplotData, 'fetchedCountVolcstat.mat' );
load( data_file );
datim = CountVolcstatALL.datim;
data = CountVolcstatALL.data;
stem( datim, data, 'b.' );
xlim( xLimits );
datetick( 'x', 10, 'keeplimits' );
ylabel( "Count" );
grid on;
xlabel( 'UTC' );
tit = "Seismic network triggered events per day";
title( tit );
set( gca, 'FontSize', 16 );


fileSave = 'fig-singleStationTriggers.png';
saveas( gcf, fileSave );

