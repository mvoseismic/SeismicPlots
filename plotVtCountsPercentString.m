% Plot VT counts and % string VTs
%
% R.C. Stewart, 23-Nov-2023

clear;

setup = setupGlobals();
reFetch();

[setup.PlotBeg, setup.PlotEnd] = askDates();
countBin = inputd( 'Count interval (d/w/m/3)', 's', 'd' );

switch countBin
    case '3'
        setup.CountBinResamp = '3monthly';
    case 'm'
        setup.CountBinResamp = 'monthly';
    case 'w'
        setup.CountBinResamp = 'weekly';
    otherwise
        setup.CountBinResamp = 'no';
end

data_file = fullfile( setup.DirMegaplotData, 'fetchedCountVolcstat.mat' );
load( data_file );

CountVT = countResamp( setup, CountVolcstatVT );
CountVTSTR = countResamp( setup, CountVolcstatVTSTR );

figure;
figure_size( 's' );

subplot(3,1,1);
bar(CountVT.datim,CountVT.data,'r');
xlim( [setup.PlotBeg setup.PlotEnd ] );
datetick( 'x', 'keeplimits' );
title( 'All VTs' );
grid on;
set( gca, 'FontSize', 16 );

subplot(3,1,2);
bar(CountVTSTR.datim,CountVTSTR.data,'r');
xlim( [setup.PlotBeg setup.PlotEnd ] );
datetick( 'x', 'keeplimits' );
title( 'String VTs' );
grid on;
set( gca, 'FontSize', 16 );

data1 = CountVT.data;
data2 = CountVTSTR.data;
data1( isnan(data1) ) = 0;
data2( isnan(data2) ) = 0;
data = 100*(data2./data1);
dataM = movmean( data, 13 );
datimVTpc = CountVT.datim;
dataVTpc = dataM;

save( "plotSummaryPause5DataVTpcstr", "datimVTpc", "dataVTpc" );


subplot(3,1,3);
plot( CountVT.datim, data, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 4 );
hold on;
plot( CountVT.datim, dataM, 'k-', 'LineWidth', 2.0 );
xlim( [setup.PlotBeg setup.PlotEnd ] );
ylim( [0 100] );
datetick( 'x', 'keeplimits' );
title( 'Percentage string VTs' );
grid on;
set( gca, 'FontSize', 16 );

%plotOverTitle( 'Monthly VT Counts' );

fileSave = 'fig-VtCountsPercentString.png';
saveas( gcf, fileSave );