
% adi_mk_ft_structure_KH
% Convertion of Brainstorm Structure to FieldTrip Structure
% using Brainstorm function "out_fieldtrip_data"
% Channels   --> Configuration of MEG Channels
% List       --> List of Mat-Files, that should be used
% isTimelock --> RawData (0) or TimeLock Data (1)
% RetVal     --> Fieldtrip Data Structure

function [RetVal]= mk_ft_structure_KH(Channels, List, isTimelock) 
   
% Create RetVal Structure
    RetVal              = [];
    RetVal.trial        = [];
    RetVal.label        = [];
    RetVal.time         = [];
    RetVal.fsample      = 1017.25;
    RetValPos           = 1;

    for i = 1 : size (List)
        % Load File, if not a Channels.mat
        if   0 == contains(List(i,1).name, 'average') % avg soll nicht geladen werden; brainstormstudy.mat wird nicht gebraucht
            % Load Trial-File
            DataMat = load (strcat(List(i,1).name)); % lade Brainstorm-Trials
            % Hier werden die Fertigen Datein gelesen
            if  isfield (DataMat, 'dimord')
                ftData = DataMat; % brauchen nur noch der Datei RetVal zugef�gt werden
                
            % hier werden die noch nicht gelesenen Daten gelesen und
            % weiterverarbeitet:
            else
                SensorTypes_Cell{1,1}       = Channels.Channel(1, 1).Name; %  Eingangsdaten f�r out_fieldtrip_data werden geschaffen
                for k = 1:length(Channels.Channel)
                    SensorTypes_Cell{1,k}   = Channels.Channel(1, k).Name;
                end

                SensorTypes = strcat(SensorTypes_Cell{1});
                for j = 2:numel(SensorTypes_Cell)
                    SensorTypes = strcat(SensorTypes, ',', SensorTypes_Cell{1,j});
                end
               [ftData, DataMat, ChannelMat, iChannels] = out_fieldtrip_data( DataMat, Channels, SensorTypes, isTimelock )   ;      
           end
          
           RetVal.trial{1,RetValPos}            = ftData.avg;
          % RetVal.label{RetValPos,1}           = ftData.label; 
           RetVal.label                         = ftData.label; 
           RetVal.time{1,RetValPos}             = ftData.time; 
           RetVal.ChannelFlag_Bst{1,RetValPos}  = DataMat.ChannelFlag;
%            RetVal.BstDataFile{1,RetValPos}      = DataMat; % speichere die Infos aus den Brainstorm-Dateien 
%            RetVal.BstChannelFile{1,RetValPos}   = Channels; % speichere
%            Brainstorm ChannelFile; auskommentiert, da Datei zu gro� wird
%            RetVal.ftData{1,RetValPos}           = ftData; 
           RetVal.grad                          = ftData.grad;
           RetVal.elec                          = ftData.elec;
           RetVal.dimord                        = ftData.dimord;
           RetValPos                            = RetValPos+1;
        end
    end
end



