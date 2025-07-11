% Plot Rockfall counts, with 60-day median filter
%
% R.C. Stewart, 6-Oct-2021

setup = setupGlobals();
plot_type = 'bar';
plot_symcol = 'r';

plotBeg = dateCommon( 'begPause5' ) + 2;
plotEnd = datenum( 2024, 4, 1, 0, 0, 0 );
xLimits = [plotBeg plotEnd];

data_file = fullfile( setup.DirMegaplotData, 'fetchedCountVolcstat.mat' );
load( data_file );

datim = CountVolcstatRO.datim;
data = CountVolcstatRO.data;

datarm = nan_rmean( data', 61 );
datarm = datarm';

bar( datim, data, 'b', 'BarWidth', 1 );
hold on;
plot( datim, datarm, 'r-', 'LineWidth', 2 );
xlim( xLimits );
ylim( [0 10] );
datetick( 'x', 'keeplimits' );
