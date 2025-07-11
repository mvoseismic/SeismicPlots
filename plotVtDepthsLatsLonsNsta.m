% plot_vt_depths_lats_lons_nsta

clear;

setup = setupGlobals();
reFetch( setup );

[datesBeg, datesEnd] = askDates();
setup.DatimBeg = datesBeg;
setup.PlotBeg = setup.DatimBeg;
setup.DatimEnd = datesEnd;
setup.PlotEnd = setup.DatimEnd;
setup.SubplotSpace = 'normal';
setup.PlotXaxis = 'normal';

Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );

% Temporary hack for good events
Ranges.mag = [1.5 9.0];
Hypo2 = hypoSubsetRanges( Hypo2, Ranges );

% Temporary hack for vlines
datimLines = [ datenum(2019,12,1) datenum(2022,8,1) datenum( 2023,6,1); ];


figure;
figure_size( 'l' );

subplot( 4, 1, 1 );
data_type = 'depth';
plot_type = 'symbol';
plot_symcol = 'ro';
cum = 0;
plotHypo( setup, Hypo2, data_type, plot_type, plot_symcol, cum );
%ylabel( 'Depth (km)' );
grid on;
set( gca, 'FontSize', 14 );
% Temporary hack for vlines
hold on;
xline( datimLines, 'b-', 'LineWidth', 2.0,'HandleVisibility','off');

subplot( 4, 1, 2 );
data_type = 'lat';
plot_type = 'symbol';
plot_symcol = 'ro';
cum = 0;
plotHypo( setup, Hypo2, data_type, plot_type, plot_symcol, cum );
%ylabel( 'Latitude' );
grid on;
set( gca, 'FontSize', 14 );
% Temporary hack for vlines
hold on;
xline( datimLines, 'b-', 'LineWidth', 2.0,'HandleVisibility','off');

subplot( 4, 1, 3 );
data_type = 'lon';
plot_type = 'symbol';
plot_symcol = 'ro';
cum = 0;
plotHypo( setup, Hypo2, data_type, plot_type, plot_symcol, cum );
%ylabel( 'Longitude' );
grid on;
set( gca, 'FontSize', 14 );
% Temporary hack for vlines
hold on;
xline( datimLines, 'b-', 'LineWidth', 2.0,'HandleVisibility','off');

subplot( 4, 1, 4 );
ev_type = 'nsta';
plot_type = 'bar';
plot_symcol = 'r';
cum = 0;
plotVolcstat( setup, ev_type, plot_type, plot_symcol, cum );
set( gca, 'FontSize', 14 );
% Temporary hack for vlines
%hold on;
%xline( datimLines, 'b-', 'LineWidth', 2.0,'HandleVisibility','off');


plotOverTitle( 'VT locations and number of stations' );


fileSave = 'fig-vt_depths_lats_lons_stas.png';
saveas( gcf, fileSave );


