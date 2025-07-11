% plot_seismic_vt_depths

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




Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );
mags = [Hypo2.mag];

% b-value
edges = [0.0:0.2:5.0];

figure_size( 'l' );

subplot(1,2,1);
h1 = histogram( mags, edges );
xlim( [0.0 5.0] );
title( '' );
set( gca, 'FontSize', 14 );
xlabel( 'magnitude' );
ylabel( 'N' );
title( 'VT magnitude' );

subplot(1,2,2);

X1 = h1.BinEdges;
X1 = X1(1:length(X1)-1);
Y1 = h1.BinCounts;
Y1 = cumsum( Y1, 'reverse' );

semilogy(X1,Y1, 'b*');
xlim( [0.0 5.0] );
ylim( [1 10000] );
set( gca, 'FontSize', 14 );
xlabel( 'magnitude' );
ylabel( 'N' );
title( 'VT cumulative magnitude' );
grid on;