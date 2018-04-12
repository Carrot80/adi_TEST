function adi_interpolate_MEG (inPath, outPath)

list = dir(fullfile(strcat(inPath, '*.mat'))); 
for k=1:length(list)
    if exist(strcat(outPath, list(k).name, '.mat'), 'file');
        delete(strcat(outPath, list(k).name, '.mat'));
    end
        load(strcat(inPath, list(k).name)); 
        
        [pos]       = isnan (cleanMEG.trial{1,1}(1:248,1));
        [chans]     = find (pos');
        chans_cell  = cleanMEG.label(chans);

        if ~isempty (chans)
            [neighbours] = MEG_neighbours (cleanMEG);
            cfgn                = [];
            cfgn.method         = 'weighted';   % 'average', 'spline', 'slap' or 'nan' (default = 'weighted')
    %         cfgn.missingchannel = chans_cell;   % cell-array, see FT_CHANNELSELECTION for details
            cfgn.neighbours     = neighbours;   % bourhood structure, see also FT_PREPARE_NEIGHBOURS
            cfgn.trials         = 'all';        % or a selection given as a 1xN vector (default = 'all')
            cfgn.badchannel    = chans_cell; % wichtig: semicolon, sonst funktioniert es nicht!
%             cfgn.layout        = '4D248.lay'; % weglassen, da grad sonst aus layout-file aufgebaut wird
            cfgn.senstype     = 'MEG';
            [cleanMEG_interp] = ft_channelrepair(cfgn, cleanMEG)     
        end
        
        if isempty (chans)
            cleanMEG_interp = cleanMEG;
        end
        save (strcat(outPath, list(k).name), 'cleanMEG_interp');
        clearvars -except k list inPath outPath
        close all
    end
end
 


%  haslayout
%   display('Using the 2-D layout to determine the sensor position\n');
%   lay = ft_prepare_layout(cfg);
