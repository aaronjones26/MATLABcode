function dataRepeated = getData_repeated
%getData creates data structure for Aaron's data files

%% get list of all subject folders
dirListing=dir;
subjects=getFolders(dirListing);
%% for each subject get folders
for i=1:length(subjects)
    dirListing=dir(subjects{i});
    days=getFolders(dirListing); %folder names for days
    mDayNames=matlab.lang.makeValidName(days); %acceptable matlab variable names
    dataRepeated(i).subject=subjects{i};
    for j=1:length(days)
        dat=getFolderData([subjects{i},'\',days{j}]);
        dataRepeated(i).(cell2mat(mDayNames(j)))=dat;
    end
end
end %function getData

%% subfunctions exist below this point
function folders=getFolders(dirListing)
%returns list of valid folders contained within dirListing
    folders=[];
    for i=1:length(dirListing)
       if dirListing(i).isdir %we have a folder 
           if ~(strcmp(dirListing(i).name,'.') || strcmp(dirListing(i).name,'..'))
               folders=[folders,{dirListing(i).name}];
           end
       end
    end
end %function getFolders


function dat=getFolderData(folder)
%getFolderData returns structured variable containing data from .log files within folder
%folder is string naming a folder (directory)
%dat contains 12 variables (see below) as columns and lines of data within files as rows

%ascii code 9 Horizontal Tab \t
%ascii code 10 Line Feed \n
%ascii code 13	Carriage Return \r

    if ~isempty(folder) % not the current folder but subfolder
        folder=[folder,'\']; %needed for subfolder
    end

    dat=struct([]);
    variables={'Event Type','Code','Type','Response','RT','RT Uncertainty','Time','Uncertainty', 'Duration','Uncertainty','ReqTime','Repeated'};
    mVarNames=matlab.lang.makeValidName(variables); %acceptable matlab variable names
    nVariables=length(variables);
    files=dir([folder,'*.log']);
    for k=1:length(files) %this loop works through all of the files in the folder
        filename=files(k).name;
        fileID=filename(6:end-4);
        dat(k).files=fileID;
        fid=fopen([folder,'\',filename]);
        tline = fgets(fid); %get a line of data
        start=false; %start of data to record
    %% read through and ignore first part of data file
        while ~start && ischar(tline)
            tline=textscan(tline,'%s','delimiter','\t');
            tline=tline{:}';
            if length(tline)==length(variables)
                if sum(strcmp(variables,tline))==length(variables)
                    start=true; %we have the row containing column variables
                end
            end
            tline = fgets(fid); %get next line of data
        end %tline is blank line as it exits this while loop
    %% now obtain and store data from second part of file
        row=1;
        tline=fgets(fid); %read first line of actual data
        while start && ischar(tline) %we have valid line of data
            tline=textscan(tline,'%s','delimiter','\t','EndOfLine','\r\n');
            tline=tline{:}';
            if length(tline)==nVariables-1 %missing last column
                tline=[tline,{' '}];
            end
            for i=1:nVariables %first 3 are strings, remaining are numeric
                if i<=3 %character variable
                  dat(k).variables(row).(cell2mat(mVarNames(i)))=cell2mat(tline(i));
                else %numeric variable
                    dat(k).variables(row).(cell2mat(mVarNames(i)))=str2double(tline(i));                    
                end
            end
            row=row+1;
            tline = fgets(fid);
            if length(double(tline))==2 %empty line (contains 10 & 13 only)
                start=false; %no longer reading data
            end
        end %while
        fclose(fid);
    end % for k=1:length(files)
end % function getFolderData