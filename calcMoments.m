clear;

setup = setupGlobals();
reFetch( setup );

[plotBeg, plotEnd] = askDates();

setup.DatimBeg = plotBeg;
setup.DatimEnd = plotEnd;

magCutoff = inputd( 'Magnitude cutoff', 'r', -1.0 );

Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt', [setup.DatimBeg], [setup.DatimEnd] );

if( magCutoff > 0)
    Ranges.mag = [magCutoff 9.9];
    Hypo2 = hypoSubsetRanges( Hypo2, Ranges );
end

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

localMoment2 = localMoment2 ./ 1.0e12;

nEv = length( localMoment2 );

for iEv = 1:nEv

    fprintf( "%s  %7.2f\n", datestr(localDatim2(iEv)),  localMoment2(iEv) );

end
