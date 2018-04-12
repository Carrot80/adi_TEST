function [] = adi_appenddataSingleSubj(pathInterpolated, pathAppended)


 list = dir(fullfile(strcat(inPath, '*.mat'))); 
    for k=1:length(list)
        load(strcat(inPath, list(k).name)); 
        
        
        
        
    end
path2subj_Run1 = 'E:\Kirsten\adidas\nl_adi_06\500\Run1\';
path2subj_Run2 = 'E:\Kirsten\adidas\nl_adi_06\500\Run2\';
path2subj_Run3 = 'E:\Kirsten\adidas\nl_adi_06\500\Run3\';

Like_Run1 = load (strcat (path2subj_Run1, 'data_like_Run1'));
Like_Run2 = load (strcat (path2subj_Run2, 'data_like_Run2'));
Like_Run3 = load (strcat (path2subj_Run3, 'data_like_Run3'));

[data_like_appended] = adi_06_appenddata (Like_Run1, Like_Run2, Like_Run3)

Dislike_Run1 = load (strcat (path2subj_Run1, 'data_dislike_Run1'));
Dislike_Run2 = load (strcat (path2subj_Run2, 'data_dislike_Run2'));
Dislike_Run3 = load (strcat (path2subj_Run3, 'data_dislike_Run3'));

[data_dislike_appended] = adi_06_appenddata (Dislike_Run1, Dislike_Run2, Dislike_Run3)



end




function [data_appended] = adi_06_appenddata (Run1, Run2, Run3)

cfg = []; 
[data_appended] = ft_appenddata(cfg, Run1.data_bpf_clean, Run2.data_bpf_clean, Run3.data_bpf_clean)

end