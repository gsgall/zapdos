clc
clear

NA = 6.022e23;

% Tracked species and ground state Ar
SpeciesKey = {'Ar',... 
              'Ar(1s5)',... 
              'Ar(1s4)',... 
              'Ar(1s3)',... 
              'Ar(1s2)',... 
              'Ar(2p10)',... 
              'Ar(2p9)',... 
              'Ar(2p8)',... 
              'Ar(2p7)',... 
              'Ar(2p6)',... 
              'Ar(2p5)',... 
              'Ar(2p4)',... 
              'Ar(2p3)',... 
              'Ar(2p2)',... 
              'Ar(2p1)',... 
              'Ar(3d12)',... 
              'Ar(3d11)',... 
              'Ar(3d10)',... 
              'Ar(3d9)',...
              'Ar(3d8)',... 
              'Ar(3d7)',... 
              'Ar(2s5)',... 
              'Ar(2s4)',... 
              'Ar(3d6)',... 
              'Ar(3d5)',... 
              'Ar(3d4)',... 
              'Ar(3d3)',... 
              'Ar(3d2)',... 
              'Ar(2s3)',... 
              'Ar(2s2)',... 
              'Ar(3d1)',... 
              'Ar(3p10)',... 
              'Ar(3p9)',... 
              'Ar(3p8)',... 
              'Ar(3p7)',... 
              'Ar(3p6)',... 
              'Ar(3p5)',... 
              'Ar(3p4)',... 
              'Ar(3p3)',... 
              'Ar(3p2)',... 
              'Ar(3p1)'};

Species = ["gs" 
           "1s5"
           "1s4"
           "1s3"
           "1s2"
           "2p10"
           "2p9"
           "2p8"
           "2p7"
           "2p6"
           "2p5"
           "2p4"
           "2p3"
           "2p2"
           "2p1"
           "3d12"
           "3d11"
           "3d10"
           "3d9"
           "3d8"
           "3d7"
           "2s5"
           "2s4"
           "3d6"
           "3d5"
           "3d4"
           "3d3"
           "3d2"
           "2s3"
           "2s2"
           "3d1"
           "3p10"
           "3p9"
           "3p8"
           "3p7"
           "3p6"
           "3p5"
           "3p4"
           "3p3"
           "3p2"
           "3p1"];

SpeciesMap = containers.Map(SpeciesKey,Species);

% %Ground State Reactions
% for i = 2:41
%     reaction_string = append('Ar(',Species(1),') + em -> Ar(',Species(i),') + em');
%     reaction_name = append(Species(1),'_To_',Species(i));
%     fprintf(reaction_string);
%     fprintf('  \t : EEDF (');
%     fprintf(reaction_name);
%     fprintf(') \n');
%     reaction_string = append('Ar(',Species(i),') + em -> Ar(',Species(1),') + em');
%     reaction_name = append(Species(i),'_To_',Species(1));
%     fprintf(reaction_string);
%     fprintf('  \t : EEDF (');
%     fprintf(reaction_name);
%     fprintf(') \n');
% end
% 
% %1s <-> 1s, 2p <-> 2p, 1s <-> 2p Reactions
% for i = 2:15
%     for j = 2:15
%         if i ~= j
%             reaction_string = append('Ar(',Species(i),') + em -> Ar(',Species(j),') + em');
%             reaction_name = append(Species(i),'_To_',Species(j));
%             fprintf(reaction_string);
%             fprintf('\t : EEDF (');
%             fprintf(reaction_name);
%             fprintf(') \n');
%         end
%     end
% end


%%%%%%%%%%%%%%

fname = 'BSR-Argon.txt';
opts = detectImportOptions(fname);
opts = setvartype(opts, 1:2,'string');
opts.DataLines = 66;
dataTab = readtable(fname,opts);

rate_energy = cell(1,5);
coeffSetKey = cell(1,1);
coeffSetVar = [""];

rate_energy{1,1} = "Reaction";
rate_energy{1,2} = "Main Species";
rate_energy{1,3} = "Type";
rate_energy{1,4} = "Energy: eV";
rate_energy{1,5} = "Coeff. Name";
j = 2;

num = height(dataTab);
for i = 1:num

    sample = dataTab(i,1);
    sample = table2array(sample);
    if sample == 'EXCITATION'
        action = dataTab(i+1,1);
        action = table2array(action);
        actionSplit = split(action);

        mainSpecies = actionSplit(1);
        secondSpecies = actionSplit(3);
        actType = "Excitation";
        coeffName = append(SpeciesMap(mainSpecies),'_To_',SpeciesMap(secondSpecies));

        energyArray = dataTab(i+5,1);
        energyArray = table2array(energyArray);
        energySplit = split(energyArray);
        energy_nonRound = energySplit(4);
        energy = str2num(energy_nonRound);

        switch energy
            case 0.105
                energy = 0.1;
            case 1.525
                energy = 1.52;
            case 2.045
                energy = 2.04;
            case 0.215
                energy = 0.21;
            case 0.295
                energy = 0.29;
            case 14.165
                energy = 14.16;
            otherwise
                if energy < 0.01
                    energy = round(energy,4);
                elseif  energy < 0.1
                    energy = round(energy,3);
                else
                    energy = round(energy,2);
                end
        end

        rate_energy{j,1} = action;
        rate_energy{j,2} = mainSpecies;
        rate_energy{j,3} = actType;
        rate_energy{j,4} = energy;
        %rate_energy{j,5} = energy_nonRound;
        rate_energy{j,5} = coeffName;

        coeffSetKey{j-1} = char(mainSpecies + " " + actType + " " + energy);
        coeffSetVar(j-1) = coeffName;

        j = j + 1;

        if actionSplit(2) == "<->"
            actType = "De-excitation";
            coeffName = append(SpeciesMap(secondSpecies),'_To_',SpeciesMap(mainSpecies));

            rate_energy{j,1} = action;
            rate_energy{j,2} = secondSpecies;
            rate_energy{j,3} = actType;
            rate_energy{j,4} = energy;
            rate_energy{j,5} = coeffName;

            coeffSetKey{j-1} = char(secondSpecies + " " + actType + " " + energy);
            coeffSetVar(j-1) = coeffName;
    
            j = j + 1;
        end
    end
end

coeffMap = containers.Map(coeffSetKey,coeffSetVar);


fname = 'output.dat';
opts = detectImportOptions(fname);
opts = setvartype(opts, 1:2,'string');
opts.DataLines = 126;
dataTab = readtable(fname,opts);

num = height(dataTab);
count = [""];
j = 1;
done = 0;
for i = 1:num
    % Checking for start of coeff. list
    sample = dataTab(i,1);
    sample = table2array(sample);
    isExcitation = contains(sample,"Excitation");
    isDeExcitation = contains(sample,"De-excitation");
    isIonization = contains(sample,"Ionization");

    if (isIonization == 1)
        % Checking if coeff. is desired
        titleSplit = split(sample);

        coeffTitle = char(SpeciesMap(titleSplit{2}) + "-" + titleSplit{3});

        fileName = append('excitation_rates/',coeffTitle,'.txt');
        fid = fopen(fileName, 'wt' );

        j = i+2;

        dataSample = dataTab(j,1);
        dataSample = table2array(dataSample);
        charSample = char(dataSample);
        charSample = charSample(1);
        while (charSample ~= 'C')
            if charSample == 'A'
                fclose(fid);
                done = 1;
                break
            end
                %Pull rate data
                data = dataTab(j,:);
                data = table2array(data);
                data(2) = str2num(data(2))*NA;
                tab = sprintf('\t');
                nl = sprintf('\n');
                data = append(data(1),tab,data(2),nl);
    
                fprintf( fid, data);
    
                j = j + 1;
    
                %Update end of list check
                dataSample = dataTab(j,1);
                dataSample = table2array(dataSample);
                charSample = char(dataSample);
                charSample = charSample(1);
        end
        if done == 1
            break
        end
        fclose(fid);
    end

    if (isExcitation == 1) || (isDeExcitation == 1)
        % Checking if coeff. is desired
        titleSplit = split(sample);

        % Need to Reformate Energy due to Matlab's str2num previously used
        energy = str2num(titleSplit{4});
        title = char(titleSplit{2} + " " + titleSplit{3} + " " + energy);

        % %Used if coeffMap breaks
        % if ~any(strcmp(coeffSetKey,title))
        %     title
        % end

        coeffTitle = coeffMap(title);
        fileName = append('excitation_rates/',coeffTitle,'.txt');
        fid = fopen(fileName, 'wt' );

        j = i+2;

        dataSample = dataTab(j,1);
        dataSample = table2array(dataSample);
        charSample = char(dataSample);
        charSample = charSample(1);
        while (charSample ~= 'C')
            if charSample == 'A'
                fclose(fid);
                done = 1;
                break
            end
                %Pull rate data
                data = dataTab(j,:);
                data = table2array(data);
                data(2) = str2num(data(2))*NA;
                tab = sprintf('\t');
                nl = sprintf('\n');
                data = append(data(1),tab,data(2),nl);
    
                fprintf( fid, data);
    
                j = j + 1;
    
                %Update end of list check
                dataSample = dataTab(j,1);
                dataSample = table2array(dataSample);
                charSample = char(dataSample);
                charSample = charSample(1);
        end
        if done == 1
            break
        end
        fclose(fid);
    end
end

% action = dataTab(1,1);
% action = table2array(action);
% actionSplit = split(action);
% key = actionSplit(2) + " " + actionSplit(3) + " " + actionSplit(4);
% 
% coeffMap(key)



% Backup
% fname = 'output.dat';
% opts = detectImportOptions(fname);
% opts = setvartype(opts, 1:2,'string');
% opts.DataLines = 126;
% dataTab = readtable(fname,opts);
% 
% num = height(dataTab);
% count = [""];
% j = 1;
% for i = 1:100
%     % Checking for start of coeff. list
%     sample = dataTab(i,1);
%     sample = table2array(sample);
%     isExcitation = contains(sample,"Excitation");
%     isDeExcitation = contains(sample,"De-excitation");
% 
%     if (isExcitation == 1) || (isDeExcitation == 1)
%         % Checking if coeff. is desired
%         titleSplit = split(sample);
% 
%         % Need to Reformate Energy due to Matlab's str2num previously used
%         energy = str2num(titleSplit{4});
%         title = char(titleSplit{2} + " " + titleSplit{3} + " " + energy);
% 
%         % Used if coeffMap breaks
%         % if ~any(strcmp(coeffSetKey,title))
%         %     title
%         % end
% 
%         coeffTitle = coeffMap(title);
%         
%         count(j) = coeffTitle;
% 
%         j = j + 1;
%     end
% end