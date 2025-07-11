% Plot rockfall counts, with rainfall for zoomed bit
%
% R.C. Stewart, 2-March-2020

clear;

setup = setupGlobals();
reFetch();

[setup.PlotBeg, setup.PlotEnd] = askDates();
countBin = inputd( 'Count interval (d/w/m)', 's', 'd' );

switch countBin
    case 'm'
        setup.CountBinResamp = 'monthly';
    case 'w'
        setup.CountBinResamp = 'weekly';
    otherwise
        setup.CountBinResamp = 'no';
end
        
plot_type = 'bar';
plot_symcol = 'r';

figure_size( 's' );
tiledlayout('vertical');

nexttile;
plotVolcstat( setup, 'ro', plot_type, plot_symcol, 0 );
set( gca, 'FontSize', 16 );
ylim( [0 60] );

nexttile;
fileRain = fullfile( setup.DirWeather, 'LeesWx_HourlyRain.mat' );
load( fileRain );
idWant = datim >= setup.PlotBeg & datim < setup.PlotEnd;
datim2 = datim( idWant );
rain2 = rain( idWant );
plot( datim2, cumsum(rain2), 'b-', 'LineWidth', 1.0 );
ylabel( 'mm' );

xlim( [setup.PlotBeg setup.PlotEnd] );
datetick( 'x', 'keeplimits' );
tit = 'LessWx cumulative rainfall';
title( tit );
grid on;
set( gca, 'FontSize', 16 );

fileSave = 'fig-RockfallCountsRain2.png';
saveas( gcf, fileSave );