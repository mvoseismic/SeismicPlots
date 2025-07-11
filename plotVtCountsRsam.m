% Plot VT counts and RSAM
%
% R.C. Stewart, 21-Feb-2024

setup = setupGlobals();
reFetch();

[setup.PlotBeg, setup.PlotEnd] = askDates();

data_file = fullfile( setup.DirMegaplotData, 'fetchedCountVolcstat.mat' );
load( data_file );
datim = CountVolcstatVT.datim;
nvt = CountVolcstatVT.data;

figure;
figure_size('l');
tiledlayout(3,1);

nexttile;
ax1 = bar(datim,nvt,1.0);
xlim( [setup.PlotBeg setup.PlotEnd] );
datetick( 'x', 'keeplimits' );


dirRsam = '/mnt/earthworm3/monitoring_data/rsam/';
fileRsam = '2023_rsam_MSS1_SHZ_60sec.dat';
fileRsam = fullfile( dirRsam, fileRsam );
[dataRsam1,datimRsam1] = readRsamFile( fileRsam );
fileRsam = '2024_rsam_MSS1_SHZ_60sec.dat';
fileRsam = fullfile( dirRsam, fileRsam );
[dataRsam2,datimRsam2] = readRsamFile( fileRsam );

dataRsam = [dataRsam1;dataRsam2];
datimRsam = [datimRsam1;datimRsam2];

dataRsam = nan_rmedian( dataRsam, 11, 5 );

nexttile;
ax2 = plot( datimRsam, dataRsam );
xlim( [setup.PlotBeg setup.PlotEnd] );
datetick( 'x', 'keeplimits' );


fileRsam = '2023_rsam_MBGH_EHZ_60sec.dat';
fileRsam = fullfile( dirRsam, fileRsam );
[dataRsam1,datimRsam1] = readRsamFile( fileRsam );
fileRsam = '2024_rsam_MBGH_EHZ_60sec.dat';
fileRsam = fullfile( dirRsam, fileRsam );
[dataRsam2,datimRsam2] = readRsamFile( fileRsam );

dataRsam = [dataRsam1;dataRsam2];
datimRsam = [datimRsam1;datimRsam2];

dataRsam = nan_rmedian( dataRsam, 11, 5 );

nexttile;
ax3 = plot( datimRsam, dataRsam );
xlim( [setup.PlotBeg setup.PlotEnd] );
datetick( 'x', 'keeplimits' );