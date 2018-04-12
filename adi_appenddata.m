
function  adi_appenddata(inPath, outPath)

% Testcahnge

% append Runs 
% Channels   --> Configuration of Brainstorm MEG Channels    
         
% dislike
 if ~exist (strcat(outPath, 'dislike_allRuns.mat'))
        files_dislike = dir(fullfile(inPath, 'dislike*.mat'));
        size_files_dislike = size(files_dislike);

    for i = 1:(size_files_dislike(1,1))
        load (strcat(inPath, files_dislike(i).name));
        var(:,i) = cleanMEG_interp;
        clear cleanMEG_interp
    end

    cfg = [];
    switch size_files_dislike(1)
        case 3
            dislike_allRuns = ft_appenddata(cfg, var(1), var(2), var(3))
            % dislike_allRuns=setfield(dislike_allRuns, 'grad', var(1).grad)
        case 2
             dislike_allRuns = ft_appenddata(cfg, var(1), var(2))
        %      dislike_allRuns=setfield(dislike_allRuns, 'grad', var(1).grad)
    end
         save (strcat(outPath, 'dislike_allRuns.mat'), 'dislike_allRuns');
         clear var
 end

%% like 
    if ~exist (strcat(outPath, 'like_allRuns.mat'))

        files_like = dir(fullfile(inPath, 'like*.mat'));
        size_files_like = size(files_like);

        for i = 1:(size_files_like(1,1))
            load (strcat(inPath, files_like(i).name));
            var(:,i)= cleanMEG_interp;
            clear cleanMEG_interp;    
        end

        cfg=[];
        switch size_files_like(1) 
            case 3
                like_allRuns = ft_appenddata(cfg, var(1), var(2), var(3))
            %     like_allRuns=setfield(like_allRuns, 'grad', var(1).grad)

            case 2
                like_allRuns = ft_appenddata(cfg, var(1), var(2))
            %     like_allRuns=setfield(like_allRuns, 'grad', var(1).grad)
        end

        save (strcat(outPath, 'like_allRuns.mat'), 'like_allRuns');
        clear var 
    end
    
  %% dontcare
    if ~exist (strcat(outPath, 'dontcare_allRuns.mat'))
        files_dontcare = dir(fullfile(inPath, 'dont*.mat'));
        size_files_dontcare = size(files_dontcare);

        if size_files_dontcare(1,1) == 0
            return
        else
            for i=1:(size_files_dontcare(1,1))
                load (strcat(inPath, files_dontcare(i).name))
                if ~isfield(cleanMEG_interp, 'dimord')
                    cleanMEG_interp = setfield(cleanMEG_interp, 'dimord', 'chan_time')
                    cleanMEG_interp = orderfields(cleanMEG_interp, var(1))
                end
                   var(:,i)= cleanMEG_interp;
                   clear cleanMEG_interp;      
            end

            cfg=[];
            switch size_files_dontcare(1)
                case 3
                    dontcare_allRuns = ft_appenddata(cfg, var(1), var(2), var(3))
            %       dontcare_allRuns=setfield(dontcare_allRuns, 'grad', var(1).grad)
                    save (strcat(outPath, filesep, 'dontcare_allRuns.mat'), 'dontcare_allRuns');

                case 2
                    dontcare_allRuns = ft_appenddata(cfg, var(1), var(2))
            %       dontcare_allRuns=setfield(dontcare_allRuns, 'grad', var(1).grad)
                    save (strcat(outPath, filesep, 'dontcare_allRuns.mat'), 'dontcare_allRuns');
                case 1
                    dontcare_allRuns = var; 
                    save (strcat(outPath, 'dontcare_allRuns.mat'), 'dontcare_allRuns');
            end
        end
    end
end