function results_repeated=analyzeRepeatData(dataRepeated)
%analyzeData generates values across trials for all files - this assumes
%that runs 1 and 2 are combined!!

results_repeated={'Subject','Day','File','No Response', 'No Trials',...
    'Repeated Correct Rate', 'Repeated Hit Rate', 'Repeated False Alarm Rate', 'Repeated Miss Rate', 'Repeated Correct Rejection Rate', 'Repeated d Prime', 'Repeated beta', 'Repeated F1'...
    'General Correct Rate', 'General Hit Rate', 'General False Alarm Rate', 'General Miss Rate', 'General Correct Rejection Rate', 'General d Prime', 'General beta', 'General F1'};
nSubjects=length(dataRepeated);
for i=1:nSubjects
    subjectID=dataRepeated(i).subject;
    dayFields=fieldnames(dataRepeated(i));
    dayFields=dayFields(2:end,:);   %first field is always subject, so drop i
    nDays=length(dayFields);        %no of days worth of data for ith subject
    for j=1:nDays
        dayID=cell2mat(dayFields(j));
        nFiles=length(dataRepeated(i).(cell2mat(dayFields(j)))); %no of files for this day
        for k=1:nFiles
            fileID=dataRepeated(i).(cell2mat(dayFields(j)))(k).files;
            trials=dataRepeated(i).(cell2mat(dayFields(j)))(k).variables;
            nTrials=120;
            nTrialsSD=60;
            nTrialsSDrepeated = 30;
            type={trials(:).Type}';
            %code={trials(:).Code}';
            %type=dataRepeated(i).(cell2mat(dayFields(j)))(k).variables.Type;
            repeated={trials(:).Repeated}';
            response={trials(:).Response}';
            
            % Overall no Response Count
            noResponseIndices=strcmp(type,'miss');
            noResponse=sum(noResponseIndices);
            
            
%% Take OUT no response trials
           
            
            
            
 %% Overall Scores
%  % CorrectRate
%             CorrectIndices=strcmp(type,'hit');
%             Correct = (sum(CorrectIndices))/nTrials;
%                     
%             % Hit Rate
%             hitIndices=strcmp(type,'hit');
%             response2Indiceshit=(2==cell2mat(response));
%             totalhit=sum(hitIndices & response2Indiceshit);
%             hitRate=(totalhit/nTrialsSD) + .00000000001;
%             
%             % False Alarm Rate
%             FAIndices=strcmp(type,'incorrect');
%             response2IndicesFA=(2==cell2mat(response));
%             totalFA=sum(FAIndices & response2IndicesFA);
%             FARate=(totalFA/nTrialsSD) + .00000000001; % Added a tiny value to result in case FARate = .50
%             
%             %Miss Rate
%             missIndices=strcmp(type,'incorrect');
%             response2IndicesMiss=(1==cell2mat(response));
%             totalmiss=sum(missIndices & response2IndicesMiss);
%             missRate=totalmiss/nTrialsSD;
%             
%             %Correct Rejection Rate
%             CRIndices=strcmp(type,'hit');
%             response2IndicesCR=(1==cell2mat(response));
%             totalCR=sum(CRIndices & response2IndicesCR);
%             CRRate=totalCR/nTrialsSD;
%             
%             % d-Prime
%             zHit = norminv(hitRate);
%             zFA = norminv(FARate);
%             dPrime = zHit-zFA;
%             
%             % Beta
%             beta = -0.5*(norminv(hitRate)+ norminv(FARate));
%             
%             % F1 Score
%              precision = hitRate/(hitRate+missRate);
%              recall = hitRate/(hitRate+FARate);
%              F1 = 2*((precision*recall)/(precision+recall));
           
 
 %% Repeated Scores
            % CorrectRate for repeated images
            repeated2IndicesCorrect=(1==cell2mat(repeated));
            CorrectIndicesRepeat=strcmp(type,'hit');
            totalCorrectRepeat=sum(CorrectIndicesRepeat & repeated2IndicesCorrect);
            CorrectRepeat = (sum(totalCorrectRepeat))/nTrialsSD;
            
            % Hit Rate for repeated images
            repeated2IndicesHR=(1==cell2mat(repeated));
            HRIndicesRepeat=strcmp(type,'hit');
            response2Indiceshit=(2==cell2mat(response));
            totalHRRepeat=sum(HRIndicesRepeat & repeated2IndicesHR & response2Indiceshit);
            hitRateRepeat = (sum(totalHRRepeat))/nTrialsSDrepeated + .00000000001;
            
            %False Alarm Rate for repeated images
            repeated2IndicesFA=(1==cell2mat(repeated));
            FAIndicesRepeat=strcmp(type,'incorrect');
            response2IndicesFA=(2==cell2mat(response));
            totalFARepeat=sum(FAIndicesRepeat & repeated2IndicesFA & response2IndicesFA);
            FARateRepeat = (sum(totalFARepeat))/nTrialsSDrepeated + .00000000001;
            
            %Miss Rate for repeated images
            repeated2Indicesmiss=(1==cell2mat(repeated));
            missIndicesRepeat=strcmp(type,'incorrect');
            response2Indicesmiss=(1==cell2mat(response));
            totalmissRepeat=sum(missIndicesRepeat & repeated2Indicesmiss & response2Indicesmiss);
            missRateRepeat = (sum(totalmissRepeat))/nTrialsSDrepeated;
            
            %Correct Rejection Rate for repeated images
            repeated2IndicesCR=(1==cell2mat(repeated));
            CRIndicesRepeat=strcmp(type,'hit');
            response2IndicesCR=(1==cell2mat(response));
            totalCRRepeat=sum(CRIndicesRepeat & repeated2IndicesCR & response2IndicesCR);
            CRRateRepeat = (sum(totalCRRepeat))/nTrialsSDrepeated;
            
            % d-Prime for repeated images
            zHitrepeated = norminv(hitRateRepeat);
            zFArepeated = norminv(FARateRepeat);
            dPrimeRepeat = zHitrepeated-zFArepeated;
            
            % Beta for repeated images
            betaRepeat = -0.5*(norminv(hitRateRepeat)+ norminv(FARateRepeat));
            
            % F1 Score for repeated images
            precisionRepeat = hitRateRepeat/(hitRateRepeat+missRateRepeat);
            recallRepeat = hitRateRepeat/(hitRateRepeat+FARateRepeat);
            F1Repeat = 2*((precisionRepeat*recallRepeat)/(precisionRepeat+recallRepeat));
            
 %% Generalized Scores           
            % CorrectRate for Generalized images
            General2IndicesCorrect=(0==cell2mat(repeated));
            CorrectIndicesGeneral=strcmp(type,'hit');
            totalCorrectGeneral=sum(CorrectIndicesGeneral & General2IndicesCorrect);
            CorrectGeneral = (sum(totalCorrectGeneral))/nTrialsSD;
            
            % Hit Rate for Generalized images
            General2IndicesHR=(0==cell2mat(repeated));
            HRIndicesGeneral=strcmp(type,'hit');
            response2Indiceshit=(2==cell2mat(response));
            totalHRGeneral=sum(HRIndicesGeneral & General2IndicesHR & response2Indiceshit);
            hitRateGeneral = (sum(totalHRGeneral))/nTrialsSDrepeated + .00000000001;;
            
            %False Alarm Rate for Generalized images
            General2IndicesFA=(0==cell2mat(repeated));
            FAIndicesGeneral=strcmp(type,'incorrect');
            response2IndicesFA=(2==cell2mat(response));
            totalFAGeneral=sum(FAIndicesGeneral & General2IndicesFA & response2IndicesFA);
            FARateGeneral = (sum(totalFAGeneral))/nTrialsSDrepeated + .00000000001;;
            
            %Miss Rate for Generalized images
            General2Indicesmiss=(0==cell2mat(repeated));
            missIndicesGeneral=strcmp(type,'incorrect');
            response2Indicesmiss=(1==cell2mat(response));
            totalmissGeneral=sum(missIndicesGeneral & General2Indicesmiss & response2Indicesmiss);
            missRateGeneral = (sum(totalmissGeneral))/nTrialsSDrepeated;
            
            %Correct Rejection Rate for Generalized images
            General2IndicesCR=(0==cell2mat(repeated));
            CRIndicesGeneral=strcmp(type,'hit');
            response2IndicesCR=(1==cell2mat(response));
            totalCRGeneral=sum(CRIndicesGeneral & General2IndicesCR & response2IndicesCR);
            CRRateGeneral = (sum(totalCRGeneral))/nTrialsSDrepeated;
            
            % d-Prime for Generalized images
            zHitGeneral = norminv(hitRateGeneral);
            zFAGeneral = norminv(FARateGeneral);
            dPrimeGeneral = zHitGeneral-zFAGeneral;
            
            % Beta for Generalized images
            betaGeneral = -0.5*(norminv(hitRateGeneral)+ norminv(FARateGeneral));
            
            % F1 Score for Generalized images
            precisionGeneral = hitRateGeneral/(hitRateGeneral+missRateGeneral);
            recallGeneral = hitRateGeneral/(hitRateGeneral+FARateGeneral);
            F1General = 2*((precisionGeneral*recallGeneral)/(precisionGeneral+recallGeneral));     
            
              %% Compile Results in one big ass database         
            results_repeated=[results_repeated;[{subjectID},{dayID},{fileID},{noResponse},{nTrials},...
                {CorrectRepeat},{hitRateRepeat},{FARateRepeat},{missRateRepeat},{CRRateRepeat},{dPrimeRepeat},{betaRepeat},{F1Repeat},...
                {CorrectGeneral},{hitRateGeneral},{FARateGeneral},{missRateGeneral},{CRRateGeneral},{dPrimeGeneral},{betaGeneral},{F1General}]];  
        end
     end
end %for subject

end
