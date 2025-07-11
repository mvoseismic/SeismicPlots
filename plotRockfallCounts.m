% Plot rockfall counts
%
% R.C. Stewart, 2-March-2020

clear;

setup = setupGlobals();
reFetch();

[setup.PlotBeg, setup.PlotEnd] = askDates();
countBin = inputd( 'Count interval (d/w/m)', 's', 'd' );

switch countBin
    case 'm'
        setup.CountBinResamp = 'monthly';
    case 'w'
        setup.CountBinResamp = 'weekly';
    otherwise
        setup.CountBinResamp = 'no';
end
        
plot_type = 'bar';
plot_symcol = 'r';

figure_size( 'l' );

plotVolcstat( setup, 'ro', plot_type, plot_symcol, 0 );

%xTicks = datenum( 2010:2025, 1, 1, 0, 0, 0 );

fileSave = 'fig-RockfallCounts.png';
saveas( gcf, fileSave );