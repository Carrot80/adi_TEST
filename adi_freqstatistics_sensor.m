function adi_freqstatistics_sensor (inPath, outPath, freqbandname, condition1, condition2, latency)

time =  latency(1,:);
NameCond1vs2 = strcat(condition1, '_vs_', condition2);
if exist(strcat(outPath, NameCond1vs2, '_', freqbandname, '.mat'), 'file')
    return
end

%run 1:
condition1run1 = strcat(inPath, condition1, '500_1_', freqbandname, '.mat');
condition2run1 = strcat(inPath, condition2, '500_1_', freqbandname, '.mat');
if exist(condition1run1, 'file') && exist(condition2run1, 'file')
    [Condition1vs2] = adi_crossvalidation (condition1run1, condition2run1, freqbandname, NameCond1vs2, latency, outPath)
end
adi_figureTPRcrossval (Condition1vs2, time, condition1, condition2, NameCond1vs2, outPath, freqbandname)
  

%run2:
condition1run2 = strcat(inPath, condition1, '500_2_', freqbandname, '.mat');
condition2run2 = strcat(inPath, condition2, '500_2_', freqbandname, '.mat');
if exist(condition1run2, 'file') && exist(condition2run2, 'file')
    adi_crossvalidation (condition1run2, condition2run2, freqbandname, NameCond1vs2, latency, outPath)
end

%run3:
condition1run3 = strcat(inPath, condition1, '500_2_', freqbandname, '.mat');
condition2run3 = strcat(inPath, condition2, '500_2_', freqbandname, '.mat');
if exist(condition1run3, 'file') && exist(condition2run3, 'file')
    adi_crossvalidation (condition1run3, condition2run3, freqbandname, NameCond1vs2, latency, outPath)
end
end

function [Condition1vs2] = adi_crossvalidation (condition1run, condition2run, freqbandname, NameCond1vs2, latency, outPath)

condition1run = load (condition1run);
condition2run = load (condition2run);

cfg             = [];
cfg.parameter   = 'trial';
cfg.keeptrials  = 'yes'; % classifiers operate on individual trials
cfg.channel     = 'MEG';
tCondition1     = ft_timelockanalysis(cfg, condition1run.data_bpfreq);    
tCondition2     = ft_timelockanalysis(cfg, condition2run.data_bpfreq); 

cfg         = [];
cfg.method  = 'crossvalidate'; % layout braucht es nicht, verschiedene layouts f�hren zum gleichen ergebnis
cfg.channel = 'MEG';
cfg.statistic = {'accuracy', 'binomial', 'contingency'};
cfg.design  = [ones(size(condition1run.data_bpfreq.trial,2),1); 2*ones(size(condition2run.data_bpfreq.trial,2),1)]';
cfg.resample = 'true';
%     cfg.mva = {dml.standardizer dml.enet 'family', 'binomial', 'alpha', 0.3};

Condition1vs2 = [];
Condition1vs2.Accuracy=[];
Condition1vs2.Binominal=[];
Condition1vs2.Latency=latency;
Condition1vs2.stats='5f-crossvalidation';

    for i=1:length(latency)  
        cfg.latency = [latency(1,i) latency(2,i)]; 
        stat = ft_timelockstatistics(cfg, tCondition1, tCondition2);
        Condition1vs2.Accuracy(1,i)=stat.statistic.accuracy;
        Condition1vs2.Binominal(1,i)=stat.statistic.binomial;
        Condition1vs2.Contingency{1,i}=stat.statistic.contingency;
    end

    Condition1vs2.latency = latency;
    Condition1vs2.design = cfg.design;
    save (strcat(outPath, NameCond1vs2, '_', freqbandname, '.mat'), 'Condition1vs2'); 
end