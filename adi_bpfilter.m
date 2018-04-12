function [data_bpfreq] = adi_bpfilter(inPath, outPath, bpname)


switch bpname
    case 'delta'
        bpfreq = 4;
    case 'theta'
        bpfreq = [4 8];
    case 'alpha'
        bpfreq = [8 13];
    case 'beta'
        bpfreq = [13 25];
    case 'low_gamma'
        bpfreq = [25 45];
    case 'high_gamma'
        bpfreq = [55 90];
end

cfg=[];
cfg.trials        = 'all'; 
cfg.feedback = 'yes';
if 1 == strcmp(bpname, 'delta')
    cfg.lpfilter      = 'yes';
    cfg.lpfreq        = bpfreq;
else
    cfg.bpfilter      = 'yes'; 
    cfg.bpfreq        = bpfreq;
end


list = dir(fullfile(strcat(inPath, '*.mat'))); 
for k=1:length(list)
%     if ~exist(strcat(outPath, list(k).name(1:end-4), '_', bpname, '.mat'), 'file')
        load(strcat(inPath, list(k).name)); 

        [data_bpfreq] = ft_preprocessing(cfg, cleanMEG_interp);
        data_bpfreq.ChannelFlag_Bst = cleanMEG_interp.ChannelFlag_Bst;
        save (strcat(outPath, list(k).name(1:end-4), '_', bpname, '.mat'), 'data_bpfreq')
        clear data_bpfreq cleanMEG_interp
%     end
end
     
