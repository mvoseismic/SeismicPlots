clear;
close all;

setup = setupGlobals();
reFetch( setup );

[plotBeg, plotEnd] = askDates( 'begPause5', 'endYear' );

setup.DatimBeg = plotBeg;
setup.PlotBeg = setup.DatimBeg;
setup.DatimEnd = plotEnd;
setup.PlotEnd = setup.DatimEnd;
setup.SubplotSpace = 'normal';
setup.PlotXaxis = 'normal';

magCutoff = inputd( 'Magnitude cutoff', 'r', -1.0 );
addCounts = inputd( 'Add VT counts', 'l', 'n');
addFits = inputd( 'Add fitted lines', 'l', 'n');
showStrings = inputd( 'Show VT strings', 'l', 'n');

Vlines(1).datim = datenum( 2019, 12, 1 );
Vlines(2).datim = datenum( 2022, 8, 1 );
Vlines(3).datim = datenum( 2023, 6, 1 );
Vlines(1).style = 'g-';
Vlines(2).style = 'g-';
Vlines(3).style = 'g-';
Vlines(1).width = 1.0;
Vlines(2).width = 1.0;
Vlines(3).width = 1.0;
datimLines = [ datenum(2019,12,1) datenum(2022,8,1) datenum(2023,6,1) ];

%dateTicks = [ datenum(2010,1,1,0,0,0) datenum(2011,1,1,0,0,0) datenum(2012,1,1,0,0,0) datenum(2013,1,1,0,0,0) datenum(2014,1,1,0,0,0) datenum(2015,1,1,0,0,0) datenum(2016,1,1,0,0,0) ...
 %   datenum(2017,1,1,0,0,0) datenum(2018,1,1,0,0,0) datenum(2019,1,1,0,0,0) datenum(2020,1,1,0,0,0) datenum(2021,1,1,0,0,0) datenum(2022,1,1,0,0,0) datenum(2023,1,1,0,0,0) ] ;

Hypo = getHypo( setup );
%Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );
Hypo2 = hypoSubset( Hypo, 'LV_vt', [setup.DatimBeg], [setup.DatimEnd] );
Hypo3 = hypoSubset( Hypo, 'LV_str', [setup.DatimBeg], [setup.DatimEnd] );
Hypo4 = hypoSubset( Hypo, 'LV_nst', [setup.DatimBeg], [setup.DatimEnd] );

if( magCutoff > 0)
    Ranges.mag = [magCutoff 9.9];
    Hypo2 = hypoSubsetRanges( Hypo2, Ranges );
    Hypo3 = hypoSubsetRanges( Hypo3, Ranges );
    Hypo4 = hypoSubsetRanges( Hypo4, Ranges );
end


figure;
figure_size('s');


magNoLoc = 1.0;
magNoDet = 0.5;

nev = length(Hypo2);
localDatim2 = NaN( 1, nev );
localMoment2 = NaN( 1, nev );
for iev = 1:nev        
    mag = [Hypo2(iev).mag];
    if isnan( mag ) 
        mag = magNoLoc;
    elseif isempty( mag )
        mag = magNoLoc;
    end        
    mw = 0.6667 * mag + 1.15;
    localMoment2(iev) = 10 ^ (1.5 * (mw + 6.07));
    localDatim2(iev) = [Hypo2(iev).datim];        
end

nev = length(Hypo4);
localDatim4 = NaN( 1, nev );
localMoment4 = NaN( 1, nev );
for iev = 1:nev        
    mag = [Hypo2(iev).mag];
    if isnan( mag ) 
        mag = magNoLoc;
    elseif isempty( mag )
        mag = magNoLoc;
    end        
    mw = 0.6667 * mag + 1.15;
    localMoment4(iev) = 10 ^ (1.5 * (mw + 6.07));
    localDatim4(iev) = [Hypo4(iev).datim];        
end

nev = length(Hypo3);
localDatim3 = NaN( 1, nev );
localMoment3 = NaN( 1, nev );
for iev = 1:nev        
    mag = [Hypo3(iev).mag];
    if isnan( mag ) 
        mag = magNoLoc;
    elseif isempty( mag )
        mag = magNoLoc;
    end        
    mw = 0.6667 * mag + 1.15;
    localMoment3(iev) = 10 ^ (1.5 * (mw + 6.07));
    localDatim3(iev) = [Hypo3(iev).datim];        
end

if addCounts
    subplot(3,1,2:3);
end

lineWidth = 2;
if addFits
    lineWidth = 3;
end

%yyaxis left;
h1 = plot( localDatim2, cumsum(localMoment2), 'k-', 'LineWidth', lineWidth );
if showStrings
    hold on;
    h2 = plot( localDatim3, cumsum(localMoment3), 'b-', 'LineWidth', lineWidth );
    h3 = plot( localDatim4, cumsum(localMoment4), 'r-', 'LineWidth', lineWidth );
    legend( {'All VTs','String VTs','Non-string VTs'}, 'Location','northwest');
end

%h1=plot( localDatim, cumsum(localMoment), 'r-', 'LineWidth', 2, 'HandleVisibility', 'off' );
%hax=get(h1,'Parent');
xlim( [ setup.PlotBeg setup.PlotEnd ] );
%ylim( [0 Inf] );
%set(hax, 'XTick', dateTicks );
datetick( 'x', 'keeplimits' );
grid on;
set( gca, 'FontSize', 14 );
grid on;
if ~addCounts
    xlabel( 'Date' );
end
title( 'Cumulative Seismic Moment (Nm)' );
hold on;


localMoment = localMoment2;
localDatim = localDatim2;

if addFits
    legItems = {};
    %{
    %legItems = cellstr( 'Cumulative seismic moment (Nm)' );
    %}
    yc = cumsum( localMoment );
    
    h1.HandleVisibility = 'off';

    for iFit = 1:3

        switch iFit
            case 1
                datimFitBeg = plotBeg;
                datimFitEnd = datenum( 2019,12,1,0,0,0);
                lineColour = [0 0.4470 0.7410];
            case 2
                datimFitBeg = datenum( 2019,12,1,0,0,0);
                datimFitEnd = datenum( 2022,8,1,0,0,0);
                lineColour = [0.4660 0.6740 0.1880];
            case 3
                datimFitBeg = datenum( 2022,8,1,0,0,0);
                datimFitEnd = plotEnd;
                lineColour = [0.6350 0.0780 0.1840];
        end

        if iFit == 1
            min1 = min( abs( localDatim - datimFitBeg ) );
            idWant1 = find( abs(localDatim - datimFitBeg) == min1 );
            min2 = min( abs( localDatim - datimFitEnd ) );
            idWant2 = find( abs(localDatim - datimFitEnd) == min2 );
            idWant = [idWant1 idWant2];
            x = localDatim( idWant );
            y_est = yc( idWant );
            c = ( y_est(2)-y_est(1) ) / ( x(2)-x(1) );
            plot(x,y_est,'-', 'Color', lineColour, 'LineWidth',1);
        else
            idWant = (localDatim >= datimFitBeg) & (localDatim <= datimFitEnd);
            x = localDatim(idWant);
            y = yc(idWant);
            c = polyfit(x,y,1);
            y_est = polyval(c,localDatim);
            idWant = y_est >= 0.0;
            plot(localDatim(idWant),y_est(idWant),'-', 'Color', lineColour, 'LineWidth',1);
        end

    
        legItem = sprintf( '%s - %s: %sNm/day', datestr(datimFitBeg), ...
            datestr(datimFitEnd), num2eng(c(1),true,false,false,3) );
        legItems{end + 1} = legItem;

        legend( legItems, 'Location', 'northwest' );
        grid off;
    end
end

%plotVertLines( Vlines );
xline( datimLines, 'k--', cellstr(datestr(datimLines)), 'LineWidth', 1.0,'HandleVisibility','off');


if ~addCounts
    overTitle = sprintf( 'VT Cumulative Seismic Moment: %s to %s ', ...
        datestr( plotBeg ), datestr( plotEnd ) );
    if( magCutoff > 0)
        overTitle = sprintf( '%s (M>=%3.1f)', overTitle, magCutoff );
    end
    title( overTitle );
end

if addCounts    

    subplot(3,1,1);
    data_file = fullfile( setup.DirMegaplotData, 'fetchedCountVolcstat.mat' );
    load( data_file );

    %{
    Count = CountVolcstatVT;
    setup.CountBinResamp = 'monthly';
    Count = countResamp( setup, Count );
    data2 = Count.data;
    datim2 = Count.datim;
    idWant = (datim2 >= setup.DatimBeg) & (datim2 <= setup.DatimEnd);
    data2 = data2(idWant);
    datim2 = datim2(idWant);
    %}

    Count1 = CountVolcstatVT;
    setup.CountBinResamp = 'weekly';
    Count1 = countResamp( setup, Count1 );
    data21 = Count1.data;
    datim21 = Count1.datim;
    idWant = (datim21 >= setup.DatimBeg) & (datim21 <= setup.DatimEnd);
    data21 = data21(idWant);
    datim21 = datim21(idWant);
    Count2 = CountVolcstatVTSTR;
    setup.CountBinResamp = 'weekly';
    Count2 = countResamp( setup, Count2 );
    data22 = Count2.data;
    datim22 = Count2.datim;
    idWant = (datim22 >= setup.DatimBeg) & (datim22 <= setup.DatimEnd);
    data22 = data22(idWant);
    datim22 = datim22(idWant);

    bar( datim21, data21, 1, 'r' );
    if showStrings
        hold on;
        bar( datim22, data22, 1, 'b' );
        legend( {'Non-string VTs', 'String VTs'}, 'Location', 'north' );
    end
    
    xlim( [ setup.PlotBeg setup.PlotEnd ] );
    datetick( 'x', 'keeplimits' );
    title( 'Weekly count of VTs' );
    grid on;
    hold on;
    plotVertLines( Vlines );
    

    %{
    subplot(4,1,4);
%    Hypo = getHypo( setup );
%    Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );
    data_type = 'depth';
    plot_type = 'symbol';
    plot_symcol = 'ro';
    cum = 0;
    plotHypo( setup, Hypo2, data_type, plot_type, plot_symcol, cum );
    ylabel( 'Depth (km)' );
    xlabel( 'Date' );
    grid on;
    hold on;
    plotVertLines( Vlines );
    %}


end

fontsize(gcf, 18, 'points');
fileSave = 'fig-vt_cummoment.png';
saveas( gcf, fileSave );


