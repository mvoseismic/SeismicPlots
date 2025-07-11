clear all;
close all;
setup = setupGlobals();

figure;
figure_size( 'l' );

fileRain = fullfile( setup.DirWeather, 'LeesWx_AllRain.mat' );
load( fileRain );
cumrain = cumsum( rain );
cumrain = cumrain - cumrain(1);
idWant = cumrain < 6400;
plot( datim(idWant), cumrain(idWant), 'r-', 'LineWidth', 1.0 );
hold on;
fileRain = fullfile( setup.DirWeather, 'HermWx_AllRain.mat' );
load( fileRain );
cumrain = cumsum( rain );
cumrain = cumrain - cumrain(1);
plot( datim, cumrain, 'b-', 'LineWidth', 1.0 );
%xlim( [datesBeg datesEnd] );
datetick( 'x', 28, 'keeplimits' );
title( 'Cumulative Rainfall (mm)' );
legend( 'LeesWx', 'HermWx', 'location', 'northwest' );
grid on;

title( 'MVO cumulative rainfall data' );
ylabel( "mm" );

fileSave = 'fig--Rain.png';
saveas( gcf, fileSave );
