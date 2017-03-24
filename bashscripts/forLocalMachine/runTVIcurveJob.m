function runTVIcurveJob()

    close all;
    
    % Set 
    nTrainingSamples = 4;
    freezeNoise = false;
    emPathType = 'frozen0';
    
    lowContrast =  1e-3;
    highContrast = 0.3;
    nContrastsPerPedestalLuminance = 12;
    
    lowPedestalLuminance = 3.3;
    highPedestalLuminance = 450;
    nPedestalLuminanceLevels = 12;
        
    fieldOfViewDegs = 1.5;
    testDiameterDegs = [3.5 10 50]/60;      % spot diameters in Geisler 1979 paper
    testDiameterDegs = testDiameterDegs(1);
    
    stimulusDurationSecs = 30/1000;         % 30 milliseconds, as in Geisler 1979
    stimulusTemporalEnvelope = 'square';    % choose between 'square', and 'Gaussian'
    
    coneMosaicFOVDegs = fieldOfViewDegs*0.95;
    coneIntegrationTime = 5/1000;
    osNoise = 'random';
    
    responseStabilizationMilliseconds = 100;
    responseExtinctionMilliseconds = 400;
    
    
    computationIntance = 0;
    if (computationIntance == 0)
        % All conditions in 1 MATLAB session
        ramPercentageEmployed = 1.0;  % use all the RAM
        pedestalLuminanceListIndicesUsed = 1:nPedestalLuminanceLevels;
    elseif (computationIntance == 1)
        % First half of the conditions in session 1 of 2 parallel MATLAB sessions
        ramPercentageEmployed = 0.5;  % use 1/2 the RAM
        pedestalLuminanceListIndicesUsed = 0 + (1:(nPedestalLuminanceLevels/2));
    elseif (computationIntance == 2)
        % Second half of the conditions in session 2 of 2 parallel MATLAB sessions
        ramPercentageEmployed = 0.5;  % use 1/2 the RAM
        pedestalLuminanceListIndicesUsed = nPedestalLuminanceLevels/2 + (1:(nPedestalLuminanceLevels/2));
    end
    
    computeMosaic = ~true;
    computeResponses = ~true;
    visualizeResponses = true;
    visualizeOuterSegmentFilters = ~true;
    findPerformance = ~true;
    visualizePerformance = ~true;
    visualizeSpatialScheme = ~true;
    
    if (computeResponses) || (visualizeResponses) || (visualizeOuterSegmentFilters)
        c_TVIcurve(...
            'pupilDiamMm', 3.0, ...
            'lowContrast', lowContrast, ...
            'highContrast', highContrast, ...
            'nContrastsPerPedestalLuminance', nContrastsPerPedestalLuminance, ...
            'lowPedestalLuminance', lowPedestalLuminance, ...
            'highPedestalLuminance', highPedestalLuminance, ...
            'nPedestalLuminanceLevels', nPedestalLuminanceLevels, ...
            'pedestalLuminanceListIndicesUsed', pedestalLuminanceListIndicesUsed, ...
            'fieldOfViewDegs', fieldOfViewDegs, ...
            'testDiameterDegs', testDiameterDegs, ...
            'stimulusTemporalEnvelope', stimulusTemporalEnvelope, ...
            'stimulusDurationSecs', stimulusDurationSecs, ...
            'computeMosaic',computeMosaic, ...
            'coneMosaicFOVDegs', coneMosaicFOVDegs, ...
            'integrationTime', coneIntegrationTime, ...
            'osNoise', osNoise, ...
            'emPathType', emPathType, ...
            'responseStabilizationMilliseconds', responseStabilizationMilliseconds, ...
            'responseExtinctionMilliseconds', responseExtinctionMilliseconds, ...
            'freezeNoise', freezeNoise, ...
            'computeResponses', computeResponses, ...
            'ramPercentageEmployed', ramPercentageEmployed, ...
            'nTrainingSamples', nTrainingSamples, ...
            'visualizeSpatialScheme', visualizeSpatialScheme, ...
            'visualizeResponses', visualizeResponses, ...
            'visualizeOuterSegmentFilters', visualizeOuterSegmentFilters, ...
            'findPerformance', false, ...
            'visualizePerformance', false ...
            );
    end
    
    if (findPerformance) || (visualizePerformance) || (visualizeSpatialScheme)
        c_TVIcurve( ...
            'pupilDiamMm', 3.0, ...
            'lowContrast', lowContrast, ...
            'highContrast', highContrast, ...
            'nContrastsPerPedestalLuminance', nContrastsPerPedestalLuminance, ...
            'lowPedestalLuminance', lowPedestalLuminance, ...
            'highPedestalLuminance', highPedestalLuminance, ...
            'nPedestalLuminanceLevels', nPedestalLuminanceLevels, ...
            'pedestalLuminanceListIndicesUsed', pedestalLuminanceListIndicesUsed, ...
            'fieldOfViewDegs', fieldOfViewDegs, ...
            'testDiameterDegs', testDiameterDegs, ...
            'stimulusTemporalEnvelope', stimulusTemporalEnvelope, ...
            'stimulusDurationSecs', stimulusDurationSecs, ...
            'coneMosaicFOVDegs', coneMosaicFOVDegs, ...
            'integrationTime', coneIntegrationTime, ...
            'osNoise', osNoise, ...
            'emPathType', emPathType, ...
            'responseStabilizationMilliseconds', responseStabilizationMilliseconds, ...
            'responseExtinctionMilliseconds', responseExtinctionMilliseconds, ...
            'nTrainingSamples', nTrainingSamples, ...
            'freezeNoise', freezeNoise, ...
            'computeResponses', false, ...
            'visualizeSpatialScheme', visualizeSpatialScheme, ...
            'visualizeTransformedSignals', true, ...
            'findPerformance', findPerformance, ...
            'visualizePerformance', visualizePerformance, ...
            'performanceSignal', 'photocurrents', ... % 'isomerizations', ... % 'photocurrents', ...
            'performanceClassifier', 'svmSpaceTimeSeparable', ... % 'mlpt', 'svmGaussianRF', ...
            'visualizeResponses', false);
    end
    
end


