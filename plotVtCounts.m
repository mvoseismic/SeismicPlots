% Plot VT counts and other info
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

%setup.CountBinResamp = askResamp( setup.PlotBeg, setup.PlotEnd );

%plotSeismicCounts( setup, 'lpall' );
plotSeismicCounts( setup, 'vtt' );

%{
Vlines = vlinesMisc( 'pause5' );
for iplot = 1:2
    
    switch iplot
        case 1
            setup.PlotBeg = datenum( 2020, 1, 1, 0, 0, 0 );
%            setup.PlotEnd = dateCommon( 'endMonth' );
            setup.PlotEnd = datenum( 2022, 1, 1, 0, 0, 0 );
            setup.CountBinResamp = 'no';
            
        case 2
            setup.PlotBeg = dateCommon( 'begPause5' );
            setup.PlotEnd = dateCommon( 'endYear' );
            setup.CountBinResamp = 'yes';
            
    end
    
    plotSeismicCounts( setup, 'vtt' );
    
    plotSeismicCountsCum( setup, 'vt' );
    
    plotSeismicCountsCum( setup, 'vtnst' );
    plotVertLines( Vlines );
    calcSpanRates( setup, 'vtnst', Vlines );
    calcSpanRates( setup, 'vt', Vlines );
    
    
end
%}
