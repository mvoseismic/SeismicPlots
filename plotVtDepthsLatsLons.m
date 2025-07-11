% plot_vt_depths_lats_lons

clear;

setup = setupGlobals();

reFetch( setup );

[datesBeg, datesEnd] = askDates();
setup.DatimBeg = datesBeg;
setup.DatimEnd = datesEnd;

prompt = 'From select file? Y/N [N]: ';
fromSelectFile = input(prompt,'s');

%setup.DatimBeg = dateCommon( 'begPause5' );
%setup.DatimBeg = datenum( 2021, 1, 1, 0, 0, 0 );
setup.PlotBeg = setup.DatimBeg;
%setup.DatimEnd = dateCommon( 'endMonth' );
setup.PlotEnd = setup.DatimEnd;
setup.SubplotSpace = 'normal';
setup.PlotXaxis = 'normal';

if strcmp( fromSelectFile, 'Y' )
    infile = "/home/seisan/seismo/WOR/select.out";
    fetchSelect( setup, '', infile );
    data_file = fullfile( setup.DirMegaplotData, 'fetchedHypoSelectSpecial.mat' );
    load( data_file );
    Hypo2 = Hypo;
else
    Hypo = getHypo( setup );
    Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );
%    Hypo2 = hypoSubset( Hypo, 'LV_str_loc', [setup.DatimBeg], [setup.DatimEnd] );
end

% Temporary hack for good events
%Ranges.mag = [1.5 9.0];
%Hypo2 = hypoSubsetRanges( Hypo2, Ranges );

% Temporary hack for vlines
%datimLines = [ datenum(2019,12,1) datenum(2022,8,1) datenum( 2023,6,1); ];

figure;
figure_size( 's' );

subplot( 3, 1, 1 );
data_type = 'depth';
plot_type = 'symbol';
plot_symcol = 'ro';
cum = 0;
plotHypo( setup, Hypo2, data_type, plot_type, plot_symcol, cum );
%ylabel( 'Depth (km)' );
grid on;
set( gca, 'FontSize', 14 );
% Temporary hack for vlines
%hold on;
%xline( datimLines, 'b-', 'LineWidth', 1.0,'HandleVisibility','off');

subplot( 3, 1, 2 );
data_type = 'lat';
plot_type = 'symbol';
plot_symcol = 'ro';
cum = 0;
plotHypo( setup, Hypo2, data_type, plot_type, plot_symcol, cum );
%ylabel( 'Latitude' );
grid on;
set( gca, 'FontSize', 14 );
% Temporary hack for vlines
%hold on;
%xline( datimLines, 'b-', 'LineWidth', 1.0,'HandleVisibility','off');

subplot( 3, 1, 3 );
data_type = 'lon';
plot_type = 'symbol';
plot_symcol = 'ro';
cum = 0;
plotHypo( setup, Hypo2, data_type, plot_type, plot_symcol, cum );
%ylabel( 'Longitude' );
grid on;
set( gca, 'FontSize', 14 );
% Temporary hack for vlines
%hold on;
%xline( datimLines, 'b-', 'LineWidth', 1.0,'HandleVisibility','off');


plotOverTitle( 'VT locations' );


fileSave = 'fig-vtDepthsLatsLons.png';
saveas( gcf, fileSave );






