clear;
close all;

setup = setupGlobals();
reFetch( setup );

[plotBeg, plotEnd] = askDates( 'begPause5', 'endYear' );
magCutoff = inputd( 'Magnitude cutoff', 'r', -1.0 );

setup.DatimBeg = plotBeg;
setup.PlotBeg = setup.DatimBeg;
setup.DatimEnd = plotEnd;
setup.PlotEnd = setup.DatimEnd;
setup.SubplotSpace = 'normal';
setup.PlotXaxis = 'normal';

Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt', [setup.DatimBeg], [setup.DatimEnd] );

if( magCutoff > 0)
    Ranges.mag = [magCutoff 9.9];
    Hypo2 = hypoSubsetRanges( Hypo2, Ranges );
end

figure;
figure_size('s');

datimMags = [Hypo2.datim];
magMags = [Hypo2.mag];

plot( datimMags, magMags, 'ko', 'MarkerFaceColor', 'r' );

xlim( [ setup.PlotBeg setup.PlotEnd ] );
ylim( [0 5] );

datetick( 'x', 'keeplimits' );
title( 'VT magnitudes' );
grid on;