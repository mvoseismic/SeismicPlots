% plot_seismic_vt_depths

clear;

setup = setupGlobals();

reFetch( setup );

setup.DatimBeg = dateCommon( 'begPause5' );
setup.PlotBeg = setup.DatimBeg;
setup.DatimEnd = dateCommon( 'endMonth' );
setup.PlotEnd = setup.DatimEnd;
setup.SubplotSpace = 'normal';
setup.PlotXaxis = 'normal';




Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );
mags = [Hypo2.mag];

datimBeg = dateCommon( 'begPause5' );
datimEnd = datenum( 2019, 12, 1, 0, 0 ,0 );
HypoA = hypoSubset( Hypo2, '', datimBeg, datimEnd );
datimBeg = datenum( 2019, 12, 1, 0, 0 ,0 );
datimEnd = datenum( 2022, 8, 1, 0, 0 ,0 );
HypoB = hypoSubset( Hypo2, '', datimBeg, datimEnd );
datimBeg = datenum( 2022, 8, 1, 0, 0 ,0 );
%datimEnd = dateCommon( 'endMonth' );
datimEnd = datenum( 2024, 11, 19, 0, 0 ,0 );
HypoC = hypoSubset( Hypo2, '', datimBeg, datimEnd );


% b-value
edges = [0.0:0.25:5.0];

figure_size( 's' );
subplot(3,1,1);
mags = [HypoA.mag];
h1 = histogram( mags, edges );
xlim( [0.0 5.0] );
title( '' );
set( gca, 'FontSize', 14 );
xlabel( 'magnitude' );
ylabel( 'N' );
title( 'Before 1/12/2019' );

X1 = h1.BinEdges;
X1 = X1(1:length(X1)-1);
Y1 = h1.BinCounts;
Y1 = cumsum( Y1, 'reverse' );

subplot(3,1,2);
mags = [HypoB.mag];
h2 = histogram( mags, edges );
xlim( [0.0 5.0] );
title( '' );
set( gca, 'FontSize', 14 );
xlabel( 'magnitude' );
ylabel( 'N' );
title( '1/12/2019-1/8/2022' );

X2 = h2.BinEdges;
X2 = X2(1:length(X2)-1);
Y2 = h2.BinCounts;
Y2 = cumsum( Y2, 'reverse' );

subplot(3,1,3);
mags = [HypoC.mag];
h3 = histogram( mags, edges );
xlim( [0.0 5.0] );
title( '' );
set( gca, 'FontSize', 14 );
xlabel( 'magnitude' );
ylabel( 'N' );
title( 'After 1/8/2022' );

X3 = h3.BinEdges;
X3 = X3(1:length(X3)-1);
Y3 = h3.BinCounts;
Y3 = cumsum( Y3, 'reverse' );

figure;
figure_size( 's' );


%semilogy(X1,Y1/max(Y1), 'b*-', 'LineWidth', 2);
semilogy(X1,Y1/Y1(7), 'b*-', 'LineWidth', 2);
hold on;
%semilogy(X2,Y2/max(Y2), 'g*-', 'LineWidth', 2);
%semilogy(X3,Y3/max(Y3), 'r*-', 'LineWidth', 2);
semilogy(X2,Y2/Y2(7), 'g*-', 'LineWidth', 2);
semilogy(X3,Y3/Y3(7), 'r*-', 'LineWidth', 2);

Xline = [6 2];
Yline = [1.e-04 1];
plot(Xline,Yline,'k:', 'LineWidth', 0.1 );
Xline = [5 1];
Yline = [1.e-04 1];
plot(Xline,Yline,'k:', 'LineWidth', 0.1 );


xlim( [0.5 5.0] );
ylim( [1e-3 2] );
set( gca, 'FontSize', 14 );
xlabel( 'magnitude' );
ylabel( 'N normalised' );
title( 'Pause 5 VT cumulative magnitude distribution' );
legend( '20100212-20191201', '20191201-20220801', '20220801-20241119', 'b = 1.0' );

fileSave = 'fig-VtBvalueSplit.png';
saveas( gcf, fileSave );