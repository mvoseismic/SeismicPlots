clear;

setup = setupGlobals();
fetchWeather();

dirWeatherSave = fullfile( setup.DirStuff, 'data/weather/MVO' );
dirRsam = setup.DirRsam;

begPlot = inputd( 'Start date for plot (dd/mm/yyyy)', 's', 'now-7' );
plotBeg = dateCommon( begPlot );
endPlot = inputd( 'End date for plot (dd/mm/yyyy)', 's', 'now' );
plotEnd = dateCommon( endPlot );
tLimits = [ plotBeg plotEnd ];

staSeismic = inputd( 'Seismic station', 's', 'MSS1' );
staWeather = inputd( 'Weather station', 's', 'HermWx' );

figShape = inputd( 'Figure shape (p|l|s)', 's', 's' );

figure;
figure_size( figShape );
tiledlayout( 'vertical' );


nexttile;
fileWeather = sprintf( '%s_%s.mat', staWeather, 'AllRain' );
fileWeather = fullfile( dirWeatherSave, fileWeather );
load( fileWeather );