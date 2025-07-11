clear;

setup = setupGlobals();
reFetch( setup );

[plotBeg, plotEnd] = askDates();

setup.DatimBeg = plotBeg;
setup.PlotBeg = setup.DatimBeg;
setup.DatimEnd = plotEnd;
setup.PlotEnd = setup.DatimEnd;
setup.SubplotSpace = 'normal';
setup.PlotXaxis = 'normal';

%dateTicks = [ datenum(2010,1,1,0,0,0) datenum(2011,1,1,0,0,0) datenum(2012,1,1,0,0,0) datenum(2013,1,1,0,0,0) datenum(2014,1,1,0,0,0) datenum(2015,1,1,0,0,0) datenum(2016,1,1,0,0,0) ...
 %   datenum(2017,1,1,0,0,0) datenum(2018,1,1,0,0,0) datenum(2019,1,1,0,0,0) datenum(2020,1,1,0,0,0) datenum(2021,1,1,0,0,0) datenum(2022,1,1,0,0,0) datenum(2023,1,1,0,0,0) ] ;

Vlines(1).datim = datenum( 2019, 12, 1 );;
Vlines(2).datim = datenum( 2022, 8, 1 );
Vlines(1).style = 'g-';
Vlines(2).style = 'g-';
Vlines(1).width = 0.5;
Vlines(2).width = 0.5;



Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );

figure_size('s');

subplot(4,1,1);
data_file = fullfile( setup.DirMegaplotData, 'fetchedCountVolcstat.mat' );
load( data_file );

Count = CountVolcstatVT;
setup.CountBinResamp = 'monthly';
Count = countResamp( setup, Count );
data2 = Count.data;
datim2 = Count.datim;
idWant = (datim2 >= setup.DatimBeg) & (datim2 <= setup.DatimEnd);
data2 = data2(idWant);
datim2 = datim2(idWant);

bar( datim2, data2, 1, 'b' );
xlim( [ setup.PlotBeg setup.PlotEnd ] );
datetick( 'x', 'keeplimits' );
title( 'Monthly count of VTs' );
grid on;
hold on;
hold on;
plotVertLines( Vlines );

subplot(4,1,2);
data_type = 'mag3plus';
plot_type = 'symbol';
plot_symcol = 'ro';
cum = 0;
plotHypo( setup, Hypo2, data_type, plot_type, plot_symcol, cum );
ylim( [2.9 4.0] );
ylabel( 'ML' );
grid on;
hold on;
plotVertLines( Vlines );

subplot(4,1,4);
data_type = 'depth';
plot_type = 'symbol';
plot_symcol = 'ro';
cum = 0;
plotHypo( setup, Hypo2, data_type, plot_type, plot_symcol, cum );
ylabel( 'Depth (km)' );
grid on;
hold on;
plotVertLines( Vlines );

subplot(4,1,3);
vtStrings = read_string_spreadsheet( setup );
vtStrings = get_string_subset( vtStrings, 'VT string' );
datimStrings = datenum( vtStrings.DatimFirst );
edges = plotBeg:7:plotEnd;
histogram(datimStrings, edges );
xlim( [ setup.PlotBeg setup.PlotEnd ] );
datetick( 'x', 'keeplimits' );
title( 'Weekly count of strings' );
grid on;
hold on;
plotVertLines( Vlines );

fileSave = 'fig-vt_counts_mags_depths_strings.png';
saveas( gcf, fileSave );