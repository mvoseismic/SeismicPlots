file_data = fullfile( setup.DirMeteostat, 'meteostat.mat' );
load( file_data );
tit = 'Geralds Airport weather station (meteostat.com)';

tLimits = [ datenum(2024,5,10) datenum( 2024, 5, 23 ) ];
idWant = datimGeralds < now;

figure;
figure_size( 'l' );
tiledlayout('vertical');

nexttile;
plot( datimGeralds, windDirGeralds, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'b' );
ylim( [-90 270] );
yticks( [-90 0 90 180 270] );
title( {'Wind direction','(degrees from N)'} );
xlim( tLimits );
datetick( 'x', 'keeplimits' );

nexttile;
plot( datimGeralds, windSpeedGeralds, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'b' );
title( {'Wind speed','(mph)'} );
xlim( tLimits );
datetick( 'x', 'keeplimits' );

nexttile;
plot( datimGeralds, tempGeralds, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'b' );
title( {'Temperature (C)'} );
xlim( tLimits );
datetick( 'x', 'keeplimits' );

plotOverTitle(tit);


