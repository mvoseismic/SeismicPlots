% testFetchSelect

clear;

setup = setupGlobals();
reFetch( setup );

datimBeg = datenum( 2007,1,1,0,0,0);
datimEnd = datenum( 2007,11,1,0,0,0);

Hypo = getHypo( setup );
Hypo2 = hypoSubset( Hypo, 'LV', datimBeg, datimEnd );

data_file = fullfile( setup.DirMegaplotData, 'fetchedHypoCollect.mat' );
load( data_file );
