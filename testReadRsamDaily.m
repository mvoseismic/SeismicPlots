clear;
setup = setupGlobals();

fileRsamDaily = fullfile( setup.DirMegaplotData, 'fetchedRsamDaily.mat' );
load( fileRsamDaily );

subplot(3,1,1);
plot( datimRsamDaily, dataRsamDaily(1,:) );

subplot(3,1,2);
plot( datimRsamDaily, dataRsamDaily(2,:) );

subplot(3,1,3);
plot( datimRsamDaily, dataRsamDaily(3,:) );
