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

magCutoff = inputd( 'Magnitude cutoff', 'r', -1.0 );


Vlines(1).datim = datenum( 2019, 12, 1 );
Vlines(2).datim = datenum( 2022, 8, 1 );
Vlines(1).style = 'g-';
Vlines(2).style = 'g-';
Vlines(1).width = 1.0;
Vlines(2).width = 1.0;
datimLines = [ datenum(2019,12,1) datenum(2022,8,1) ];

Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );

if( magCutoff > 0)
    Ranges.mag = [magCutoff 9.9];
    Hypo2 = hypoSubsetRanges( Hypo2, Ranges );
end


figure;
figure_size('l');
nPanels = 4;
[ha, pos] = tight_subplot( nPanels, 1, 0, [0.1 0.12], 0.1);


magNoLoc = 1.0;
magNoDet = 0.5;
nev = length(Hypo2);
localDatim = NaN( 1, nev );
localMoment = NaN( 1, nev );


% Calculate moments
for iev = 1:nev
        
    mag = [Hypo2(iev).mag];
    if isnan( mag ) 
        mag = magNoLoc;
    elseif isempty( mag )
        mag = magNoLoc;
    end
        
    mw = 0.6667 * mag + 1.15;
    localMoment(iev) = 10 ^ (1.5 * (mw + 6.07));
    localDatim(iev) = [Hypo2(iev).datim];
        
end

% VT counts
%subplot(4,1,1);
axes(ha(1));
data_file = fullfile( setup.DirMegaplotData, 'fetchedCountVolcstat.mat' );
load( data_file );

Count1 = CountVolcstatVT;
setup.CountBinResamp = 'monthly';
Count1 = countResamp( setup, Count1 );
data21 = Count1.data;
datim21 = Count1.datim;
idWant = (datim21 >= setup.DatimBeg) & (datim21 <= setup.DatimEnd);
data21 = data21(idWant);
datim21 = datim21(idWant);
Count2 = CountVolcstatVTSTR;
setup.CountBinResamp = 'monthly';
Count2 = countResamp( setup, Count2 );
data22 = Count2.data;
datim22 = Count2.datim;
idWant = (datim22 >= setup.DatimBeg) & (datim22 <= setup.DatimEnd);
data22 = data22(idWant);
datim22 = datim22(idWant);

bar( datim21, data21, 1, 'r' );
hold on;
bar( datim22, data22, 1, 'b' );
xlim( [ setup.PlotBeg setup.PlotEnd ] );
datetick( 'x', 'keeplimits' );
ylabel( 'VTs/month' );
grid on;
plotVertLines( Vlines );
legend( {'Non-string VTs', 'String VTs'}, 'Location','northwest' );
set(gca,'xaxisLocation','top')


% VT depths
%subplot(4,1,2);
axes(ha(2));
datimDepth = extractfield( Hypo2, "datim" );
dataDepth = extractfield( Hypo2, "dep" );
errorDepth = extractfield( Hypo2, "err_dep" );
%nphDepth = extractfield( Hypo2, "nph" );
idWant = datimDepth > datenum(2023,4,19,18,17,0) | datimDepth < datenum(2017,2,1);
plot( datimDepth(idWant), dataDepth(idWant), 'ro','MarkerSize', 4 );
%errorbar( datimDepth, dataDepth, errorDepth, 'ko','MarkerFaceColor',[1 0 0],'MarkerSize', 4,'Color',0.5*[1 1 1] );
hold on;
plot( datimDepth(~idWant), dataDepth(~idWant), 'o','MarkerSize', 4, 'Color', [0.93 0.67 0.67] );
plotVertLines( Vlines );
legend( 'Southernly control on hypocentre', 'No southernly control on hypocentre', 'Location','northwest' );
set( gca, 'Ydir', 'reverse' );
xlim( [ setup.PlotBeg setup.PlotEnd ] );
ylim( [-1 4] );
datetick( 'x', 'keeplimits' );
ylabel( 'VT Depth (km)' );
grid on;
set(gca,'XTickLabel',[]);
yticklabels = get(gca, 'YTickLabel');
yticklabels{1} = ''; 
set(gca, 'YTickLabel', yticklabels);


% Cum moment
%subplot(4,1,3);
axes(ha(3));
plot( localDatim, cumsum(localMoment), 'r-', 'LineWidth', 2.0 );
hold on;
plotVertLines( Vlines );
xlim( [ setup.PlotBeg setup.PlotEnd ] );
ylim( [0 4.1e16] );
datetick( 'x', 'keeplimits' );
grid on;
ylabel( {'Cumulative';'Seismic Moment'} );
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);



%subplot(4,1,4);
axes(ha(4));
load( '/home/seisan/src/megaplot/data/gas/gas_so2_auto' );
gdata = get( gas_so2, 'Data' );
tdata = get( gas_so2, 'Time' );
tstart = datenum( gas_so2.TimeInfo.StartDate );
% change by PJS 31-08-2011 - removed -1 as discovered a 1 day offset
tdata = tdata + tstart;% - 1;
DOAS_start = datenum('01-Jan-2002');
NEW_DOAS_start = datenum('01-Jan-2017');
[idx_doas,~]=find(tdata>=DOAS_start&tdata<NEW_DOAS_start); 
plot( tdata(idx_doas), gdata(idx_doas), 'bo', 'MarkerSize', 4 );
hold on;
load('/home/seisan/src/megaplot/data/gas/gas_so2_traverse.mat');
plot(gas_dates,gas_so2_trav,'ro','MarkerSize', 4);
legend( 'DOAS', 'Traverse', 'Location','northwest'  );

xlim( [ setup.PlotBeg setup.PlotEnd ] );
ylim( [0 1500] );
datetick( 'x', 'keeplimits' );
ylabel( 'SO_{2} Flux (tons/day)', 'Interpreter', 'tex' );
grid on;
plotVertLines( Vlines );

plotOverTitle( 'Pause 5' );

fileSave = 'fig-VtCummomentCountsDepthGas.png';
saveas( gcf, fileSave );

