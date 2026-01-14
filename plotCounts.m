% Plot daily counts and rockfalls for a period
%
% R.C. Stewart, 6-October-2021
%               9-January 2025 modified for sub-daily counts

setup = setupGlobals();
reFetch( setup );

[datesBeg, datesEnd] = askDates();
setup.DatimBeg = datesBeg;
setup.DatimEnd = datesEnd;
setup.PlotBeg = setup.DatimBeg;
setup.PlotEnd = setup.DatimEnd;

countBin = inputd( 'Count interval (h/d/w/m)', 's', 'd' );

if ~strcmp( countBin, 'h' )

    switch countBin
        case 'm'
            setup.CountBinResamp = 'monthly';
        case 'w'
            setup.CountBinResamp = 'weekly';
        otherwise
            setup.CountBinResamp = 'no';
    end

    %plotSeismicCounts( setup, 'all5' );
    %plotSeismicCounts( setup, 'all5a' );
    %plotSeismicCounts( setup, 'all4s' );
    %plotSeismicCounts( setup, 'all9' );
    %plotSeismicCounts( setup, 'vtt' );
    plotSeismicCounts( setup, 'vtt' );

else

    figure;
    figure_size( 'l' );
    tiledlayout( 'vertical' );

    countBin = inputd( 'Bin width (hours)', 'r', 6.0 );
    binWidth = countBin/24.0;
    edges = datesBeg : binWidth : datesEnd;

    data_file = fullfile( setup.DirMegaplotData, 'fetchedHypoSelect.mat' );
    load( data_file );

    for iEvType = 1:3
        switch iEvType
            case 1
                Hypo2 = hypoSubset( Hypo, 'LV_vt', [setup.DatimBeg], [setup.DatimEnd] );
                eventType = "VT";
            case 2
                Hypo2 = hypoSubset( Hypo, 'LV_alllf', [setup.DatimBeg], [setup.DatimEnd] );
                eventType = "All LF";
            case 3
                Hypo2 = hypoSubset( Hypo, 'LV_allrf', [setup.DatimBeg], [setup.DatimEnd] );
                eventType = "All RF";
        end
    
        eventDatim = extractfield( Hypo2, 'datim' );

        nexttile();
        histogram( eventDatim, edges );

        xlim( [setup.DatimBeg setup.DatimEnd] );
        datetick( 'x', 'keeplimits' );
        title( eventType );
        grid on;

    end

    tit = sprintf( "Seismic events per %2d hours", countBin );
    plotOverTitle( tit );

end


fileSave = 'fig-counts.png';
saveas( gcf, fileSave );
