% Plot daily counts and rockfalls for a period
%
% R.C. Stewart, 6-October-2021

setup = setupGlobals();
reFetch( setup );

%figure_size( 'a4_landscape' );

[datesBeg, datesEnd] = askDates();
setup.DatimBeg = datesBeg;
setup.DatimEnd = datesEnd;
setup.PlotBeg = setup.DatimBeg;
setup.PlotEnd = setup.DatimEnd;

setup.CountBinResamp = 'monthly';
%setup.CountBinResamp = 'weekly';
%setup.CountBinResamp = 'daily';

plotVolcstat( setup, 'vt', 'bar', 'r', 0 );
