setup = setupGlobals();
plot_type = 'bar';
plot_symcol = 'r';

[datesBeg, datesEnd] = askDates();
datesEnd = floor( datesEnd );
setup.PlotBeg = datesBeg;
setup.PlotEnd = datesEnd;
setup.CountBinResamp = 'daily';

figure_size( 's' );

subplot(2,1,1);
plotVolcstat( setup, 'ro', plot_type, plot_symcol, 0 );

% MVO rain data
fileRain = fullfile( setup.DirWeather, 'LeesWx_AllRain.mat' );
load( fileRain );
subplot(2,1,2);
idWant = datim >= datesBeg & datim <= datesEnd;
datim2 = datim( idWant );
rain2 = rain( idWant );
cumrain = cumsum( rain2 );
cumrain = cumrain - cumrain(1);
plot( datim2, cumrain, 'r-', 'LineWidth', 1.0 );
hold on;
fileRain = fullfile( setup.DirWeather, 'ChanWx_AllRain.mat' );
load( fileRain );
idWant = datim >= datesBeg & datim <= datesEnd;
datim2 = datim( idWant );
rain2 = rain( idWant );
cumrain = cumsum( rain2 );
cumrain = cumrain - cumrain(1);
plot( datim2, cumrain, 'g-', 'LineWidth', 1.0 );
fileRain = fullfile( setup.DirWeather, 'HermWx_AllRain.mat' );
load( fileRain );
idWant = datim >= datesBeg & datim <= datesEnd;
datim2 = datim( idWant );
rain2 = rain( idWant );
cumrain = cumsum( rain2 );
cumrain = cumrain - cumrain(1);
plot( datim2, cumrain, 'b-', 'LineWidth', 1.0 );
xlim( [datesBeg datesEnd] );
datetick( 'x', 'keeplimits' );
title( 'Cumulative Rainfall (mm)' );
legend( 'LeesWx', 'ChanWx', 'HermWx', 'location', 'northwest' );
grid on;

plotOverTitle( sprintf( '%s  -  %s', datestr(datesBeg), datestr(datesEnd) ) );


fileSave = 'fig--RockfallCountsRain.png';
saveas( gcf, fileSave );