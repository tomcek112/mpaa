%% Generates all Excel sheets for Tasks 1,2,3,4 



disp('Running CCR-IO...')
DEA('CCR', 'io');
disp('Done');
disp('Running CCR-OO...')
DEA('CCR', 'oo');
disp('Done');
disp('Running BCC-IO...')
DEA('BCC', 'io');
disp('Done');
disp('Running BCC-OO...')
DEA('BCC', 'oo');
disp('Done');
disp('Terminating...');