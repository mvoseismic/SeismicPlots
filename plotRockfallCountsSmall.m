% Plot rockfall counts, with small rockfalls
%
% R.C. Stewart, 15-March-2024

clear;

setup = setupGlobals();
reFetch();

[plotBeg, plotEnd] = askDates();
countBin = inputd( 'Count interval (d/w/m)', 's', 'd' );
tLimits = [ plotBeg plotEnd ];

        
data_file = fullfile( setup.DirMegaplotData, 'fetchedCountVolcstat.mat' );
load( data_file );
datimCountRF = CountVolcstatRO.datim;
dataCountRF = CountVolcstatRO.data;



tiledlayout( 'vertical', 'TileSpacing', 'tight' );

nexttile;
bar( datimCountRF, dataCountRF );
xlim( tLimits );
datetick( 'x', 'keeplimits' );


%{
events = read_events_spreadsheet( setup );
whats = events.What;
wheres = events.Where;
datimStart = events.DatimStart;
firstSta = events.FirstSta;

idWant = contains( whats, 'ockfall' );

whats = whats( idWant );
wheres = wheres( idWant );
datetimeStart = datimStart( idWant );
datimStart = datenum( datetimeStart );
firstSta = firstSta( idWant );

edges = tLimits(1):tLimits(2);
[N,edges] = histcounts(datimStart,edges);

nexttile;
bar(edges(1:end-1),N);
xlim( tLimits );
datetick( 'x', 'keeplimits' );
%}