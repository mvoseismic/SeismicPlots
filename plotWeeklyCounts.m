% Plot weekly counts for a period
%
% R.C. Stewart, 2023-11-02

clear;

setup = setupGlobals();
dirHOME = getenv('HOME');

[datesBeg, datesEnd] = askDates( '30/11/2012', 'now' );
setup.DatimBeg = datesBeg;
setup.DatimEnd = datesEnd;
setup.PlotBeg = setup.DatimBeg;
setup.PlotEnd = setup.DatimEnd;
tLimits = [ datetime(setup.PlotBeg,'ConvertFrom','datenum') datetime(setup.PlotEnd,'ConvertFrom','datenum') ];

fileSeismicityDiary = fullfile( dirHOME, 'projects/SeismicityDiary', 'SeismicityDiary.xlsx' );

WC = readtable( fileSeismicityDiary, 'Sheet', 'WeeklyCounts' );

figure( 'Renderer','painters');
figure_size( 'l' );

subplot(4,1,1);
stem(WC.WeekEnding,WC.VT,'r', 'Marker', 'none', 'LineWidth', 1.0 );
ylabel( 'VTs' );
grid on;
xlim( tLimits );

subplot(4,1,2);
stem(WC.WeekEnding,WC.hybrid,'r', 'Marker', 'none', 'LineWidth', 1.0 );
ylabel( 'Hybrids' );
grid on;
xlim( tLimits );

subplot(4,1,3);
stem(WC.WeekEnding,WC.LP,'r', 'Marker', 'none', 'LineWidth', 1.0 );
ylabel( 'LPs' );
grid on;
xlim( tLimits );

subplot(4,1,4);
stem(WC.WeekEnding,WC.rockfall,'r', 'Marker', 'none', 'LineWidth', 1.0 );
ylabel( 'Rockfalls' );
grid on;
xlim( tLimits );

plotOverTitle( 'Reported Weekly Counts of Volcanic Earthquakes' );

filePlot = 'fig-weeklyCounts.png';
exportgraphics(gcf,filePlot,'Resolution',300);
