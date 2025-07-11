% plot_seismic_vt_depths

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

dv = datevec( plotBeg );
yearBeg = dv(1);
dv = datevec( plotEnd );
yearEnd = dv(1);

Msplit = 3.0;

Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV_vt_loc', [setup.DatimBeg], [setup.DatimEnd] );
magVT = [Hypo2.mag];
datimVT = [Hypo2.datim];
nVT = length( datimVT );

stepVT = 20;

datimBOS = [];
ratioBOS = [];

for istep = 1:stepVT:nVT

        datimBOS = [ datimBOS datenum( iyr, imo+1, 14, 0, 0, 0 ) ];
        
        idWant = datimVT >= datenum(iyr,imo,1) & datimVT < datenum(iyr,imo+1,1);
        mags = magVT(idWant);

        nAll = length( mags );
        nBig = sum( mags >= Msplit );
        nWee = sum( mags < Msplit );

        %fprintf( "%4d %2d  %4d  %4d  %4d\n", iyr, imo, nAll, nBig, nWee );

        rat = nBig/nAll;
        ratioBOS = [ratioBOS rat ];


        


    end
end

figure;
figure_size( 'l' );

plot(datimBOS, ratioBOS, 'ro' );
xlim( [plotBeg plotEnd] );
datetick( 'x', 'keeplimits' );



