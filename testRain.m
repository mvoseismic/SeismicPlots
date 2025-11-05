dirWeather = fullfile( setup.DirHome, 'data/weather/MVO/0-new' );

fileWeatherRainSave = fullfile(dirWeather, 'ChanWxRain1m.mat');
load( fileWeatherRainSave );
plot( datimRain, cumsum(rain1minute), 'b-' );
hold on;

fileWeatherRainSave = fullfile(dirWeather, 'HermWxRain1m.mat');
load( fileWeatherRainSave );
plot( datimRain, cumsum(rain1minute), 'g-' );

fileWeatherRainSave = fullfile(dirWeather, 'LeesWxRain1m.mat');
load( fileWeatherRainSave );
plot( datimRain, cumsum(rain1minute), 'r-' );

datetick( 'x' );
