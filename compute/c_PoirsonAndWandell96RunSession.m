function c_PoirsonAndWandell96RunSession()
% Conduct batch runs using the c_PoirsonAndWandel executive script
%
    % Parameters varied
    nTrainingSamples = 512;
    spatialFrequency = 10;
    meanLuminance = 200;
        
    % Actions to perform
    computeResponses = true;
    visualizeResponses = false;
    findPerformances = false;
           
    % Go!
    if (computeResponses)
        computeTheResponses(spatialFrequency, meanLuminance, nTrainingSamples);
    end
    
    if (visualizeResponses)
        c_PoirsonAndWandell96Replicate(...
                'spatialFrequency', spatialFrequency, 'meanLuminance', meanLuminance, ...
                'nTrainingSamples', nTrainingSamples, 'emPathType', 'random', ...
                'computeResponses', false, 'visualizeResponses', true, ...
                'displayTrialBlockPartitionDiagnostics', false,  ...
                'findPerformance', false);
    end
    
    if (findPerformances)
        findPerformancesForDifferentEvidenceIntegrationTimes(spatialFrequency, meanLuminance, nTrainingSamples);
        %findThePerformances(spatialFrequency, meanLuminance, nTrainingSamples)
    end
end

function computeTheResponses(spatialFrequency, meanLuminance, nTrainingSamples)   
    c_PoirsonAndWandell96Replicate(...
        'spatialFrequency', spatialFrequency, ...
        'meanLuminance', meanLuminance, ...
        'nTrainingSamples', nTrainingSamples, ...
        'computeResponses', true, ...
        'emPathType', 'random', ...
        'visualizeResponses', false, ...
        'findPerformance', false);

    c_PoirsonAndWandell96Replicate(...
        'spatialFrequency', spatialFrequency, ...
        'meanLuminance', meanLuminance, ...
        'nTrainingSamples', nTrainingSamples, ...
        'computeResponses', true, ...
        'emPathType', 'frozen', ...
        'visualizeResponses', false, ...
        'findPerformance', false);

    c_PoirsonAndWandell96Replicate(...
        'spatialFrequency', spatialFrequency, ...
        'meanLuminance', meanLuminance, ...
        'nTrainingSamples', nTrainingSamples, ...
        'computeResponses', true, ...
        'emPathType', 'none', ...
        'visualizeResponses', false, ...
        'findPerformance', false);
end


function findPerformancesForDifferentEvidenceIntegrationTimes(spatialFrequency, meanLuminance, nTrainingSamples)

    emPathType = 'random';
    classifier = 'mlpt';
    performanceSignal = 'isomerizations';
    
    % Examine a range of integration times
    evidenceIntegrationTimes =   -([6 18 30 48 60 78 90 108 120 138 150 168 186 210]-1); % (5:10:250); %-([6 18 30 48 60 78 90 108 120 138 150 168 186 210]-1); % (5:10:250);
    for k = 1:numel(evidenceIntegrationTimes)
        evidenceIntegrationTime = evidenceIntegrationTimes(k);
        fprintf(2, 'Finding performance for ''%s'' EMpaths using an %s classifier operating on %2.1f milliseconds of the %s signals.\n', emPathType, classifier, evidenceIntegrationTime, performanceSignal);
        c_PoirsonAndWandell96Replicate(...
                'spatialFrequency', spatialFrequency, ...
                'meanLuminance', meanLuminance, ...
                'nTrainingSamples', nTrainingSamples, ...
                'computeResponses', false, ...
                'emPathType', emPathType, ...
                'visualizeResponses', false, ...
                'findPerformance', true, ...
                'performanceSignal', performanceSignal, ...
                'performanceClassifier', classifier, ...
                'performanceEvidenceIntegrationTime', evidenceIntegrationTime ....
                );
    end % k
    
    % And the the full time course
    c_PoirsonAndWandell96Replicate(...
                'spatialFrequency', spatialFrequency, ...
                'meanLuminance', meanLuminance, ...
                'nTrainingSamples', nTrainingSamples, ...
                'computeResponses', false, ...
                'emPathType', emPathType, ...
                'visualizeResponses', false, ...
                'findPerformance', true, ...
                'performanceSignal', performanceSignal, ...
                'performanceClassifier', classifier, ...
                'performanceEvidenceIntegrationTime', [] ....
                );
            
            
end

function findThePerformances(spatialFrequency, meanLuminance, nTrainingSamples)  
    for tableColumn = 3:3  % 1:4
        switch tableColumn
            case 1 
                % First column: mlpt on isomerizations 
                % for all 3 path types
                emPathTypes = {'none', 'frozen', 'random'};
                classifier = 'mlpt';
                performanceSignal = 'isomerizations';
            case 2
                % Second column: svm on isomerizations 
                % for all 3 path types
                emPathTypes = {'none', 'frozen', 'random'};
                classifier = 'svm';
                performanceSignal = 'isomerizations';
            case 3
                % Third column: svm on photocurrents 
                % for the 2 non-static path types
                emPathTypes = {'frozen', 'random'};
                classifier = 'svm';
                performanceSignal = 'photocurrents';
            case 4
                % Fourth column: svm on V1 filter bank (operating on photocurrents) 
                % for the 2 non-static path types
                emPathTypes = {'frozen', 'random'};
                classifier = 'svmV1FilterBank';
                performanceSignal = 'photocurrents';
            otherwise
                error('No params for table column: %d', tableColumn);
        end % switch

        for emPathTypeIndex = 1:numel(emPathTypes)
            emPathType = emPathTypes{emPathTypeIndex};
            fprintf(2, 'Finding performance for ''%s'' EMpaths using an %s classifier on the %s signals.\n', emPathType, classifier, performanceSignal);
            c_PoirsonAndWandell96Replicate(...
                'spatialFrequency', spatialFrequency, ...
                'meanLuminance', meanLuminance, ...
                'nTrainingSamples', nTrainingSamples, ...
                'computeResponses', false, ...
                'emPathType', emPathType, ...
                'visualizeResponses', false, ...
                'findPerformance', true, ...
                'performanceSignal', performanceSignal, ...
                'performanceClassifier', classifier ...
                );
        end %  for emPathTypeIndex
    end % tableColumn
 end
