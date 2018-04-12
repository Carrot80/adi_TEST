
function adi_appenddata_all_subj (inPath, outPath)
    

    
%%   dislike:
    dislike_all_subj = struct('label', [] ,  'sampleinfo', [], 'trial', [], 'time', [], 'cfg', []);
    num_dislike = 0;
 
    for i =  2:length(subjList) 
        [num_dislike, dislike_all_subj]  =  kh_appendalldata( strcat(subjFolder, subjList(i,1).name), subjList(i,1).name, filter, num_dislike, dislike_all_subj, 'dislike_allRuns');
    end   
    
    size_dislike_all_subj=size(dislike_all_subj);
    cfg=[];
    dislike_all_subj_appended = ft_appenddata(cfg, dislike_all_subj(:,1), dislike_all_subj(:,2));
    
    for k = 3:size_dislike_all_subj (2)
        dislike_all_subj_appended = ft_appenddata(cfg, dislike_all_subj_appended, dislike_all_subj(:,k)) ;   
    end
    
    save (strcat('D:\Arbeit\Adidas\Auswertung\Fieldtrip_Auswertung\Studie_1_visuell\group_analysis\MEG\', filter, filesep, 'appended_data_interp\dislike_all_subj_appended'), 'dislike_all_subj_appended', '-v7.3');
    clear dislike_all_subj_appended
    
    %% like:
    
    like_all_subj = struct('label', [] ,  'sampleinfo', [], 'trial', [], 'time', [], 'cfg', [] );
    num_like = 0;
        for i =  2:length(subjList) 
            [num_like, like_all_subj]  =  kh_appendalldata( strcat(subjFolder, subjList(i,1).name), subjList(i,1).name, filter, num_like, like_all_subj, 'like_allRuns');
        end   
    
    size_like_all_subj=size(like_all_subj);
    cfg=[];
    like_all_subj_appended = ft_appenddata(cfg, like_all_subj(:,1), like_all_subj(:,2));
    
    for k = 3:size_like_all_subj (2)
        like_all_subj_appended = ft_appenddata(cfg, like_all_subj_appended, like_all_subj(:,k))  ;  
    end
    
    save (strcat('D:\Arbeit\Adidas\Auswertung\Fieldtrip_Auswertung\Studie_1_visuell\group_analysis\MEG\', filter, filesep, 'appended_data_interp\like_all_subj_appended'), 'like_all_subj_appended', '-v7.3');
    clear like_all_subj_appended
    
    %% dontcare:
    dontcare_all_subj = struct('label', [] ,  'sampleinfo', [], 'trial', [], 'time', [], 'cfg', []);
    num_dontcare = 0;
    
        for i =  2:length(subjList) 
            [num_dontcare, dontcare_all_subj]  =  kh_appendalldata( strcat(subjFolder, subjList(i,1).name), subjList(i,1).name, filter, num_dontcare, dontcare_all_subj, 'dontcare_allRuns');
        end 
    size_dontcare_all_Runs = size(dontcare_all_subj);
    cfg = [];
    dontcare_all_subj_appended = ft_appenddata(cfg, dontcare_all_subj(:,1), dontcare_all_subj(:,2));
    
    for k = 3:size_dontcare_all_Runs (2)
        dontcare_all_subj_appended = ft_appenddata(cfg, dontcare_all_subj_appended, dontcare_all_subj(:,k));    
    end
    
    save (strcat('D:\Arbeit\Adidas\Auswertung\Fieldtrip_Auswertung\Studie_1_visuell\group_analysis\MEG\', filter, filesep, 'appended_data_interp\dontcare_all_subj_appended'), 'dontcare_all_subj_appended');
    
    
end


function [num, condition_all_subj]=kh_appendalldata ( subjFolder, subj, filter, num, condition_all_subj, name_condition)

    path_appended = (strcat(subjFolder, filesep, 'MEG\', filter, filesep, '02_appended_data\'));
% 
    files_condition   =   dir(fullfile(path_appended, strcat(name_condition, '.mat')));
    size_files = size(files_condition);
    
    for i=1:(size_files(1,1))
      condition =  load (strcat(path_appended, files_condition(i).name));

        if isfield(condition.(name_condition), 'elec')    % Position von grad stimmt bei einigen Probanden nicht, kommt sonst zu Fehlermeldung
           condition.(name_condition) = rmfield(condition.(name_condition), 'elec');
        end
         if isfield(condition.(name_condition), 'grad')    % Position von grad stimmt bei einigen Probanden nicht, kommt sonst zu Fehlermeldung
           condition.(name_condition) = rmfield(condition.(name_condition), 'grad');
         end
        
        if isfield(condition.(name_condition), 'fsample')   
           condition.(name_condition) = rmfield(condition.(name_condition), 'fsample');
        end
        condition.(name_condition) = orderfields (condition.(name_condition), {'label',  'sampleinfo', 'trial', 'time', 'cfg'});
        
        condition_all_subj(i+num) = condition.(name_condition);
        clear condition        
    end
   
 num = num+size_files(1);

end
