% plot_seismic_vt_depths

clear;

setup = setupGlobals();

reFetch( setup );



%datimBeg = datenum( 2023, 6, 1, 0, 0 ,0 );
%datimEnd = datenum( 2024, 11, 19, 0, 0 ,0 );
datimBeg = datenum( 2010, 2, 13, 0, 0 ,0 );
datimEnd = datenum( 2023, 6, 1, 0, 0 ,0 );

Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', datimBeg, datimEnd );


HypoA = Hypo2;
HypoB = hypoSubset( Hypo2, 'str', datimBeg, datimEnd );
HypoC = hypoSubset( Hypo2, 'nst', datimBeg, datimEnd );


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
title( 'All VTs' );

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
title( 'String Vts' );

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
title( 'Non-string VTs' );

X3 = h3.BinEdges;
X3 = X3(1:length(X3)-1);
Y3 = h3.BinCounts;
Y3 = cumsum( Y3, 'reverse' );



figure;
figure_size( 's' );


semilogy(X1,Y1/Y1(7), 'b*-', 'LineWidth', 2);
hold on;
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
set( gca, 'FontSize', 28 );
xlabel( 'Magnitude' );
ylabel( 'N normalised' );
tit = sprintf( "VT cumulative magnitude distribution: %s - %s", datestr(datimBeg), datestr(datimEnd) );
title( tit );
legend( 'All VTs', 'String VTs', 'Non-string VTs', 'b = 1.0' );

fileSave = 'fig-VtBvalueSplitString.png';
saveas( gcf, fileSave );