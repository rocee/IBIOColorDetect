function varargout = v_BanksEtAlReplicate(varargin)
% varargout = v_anksEtAlReplicate(varargin)
%
% Works by running t_coneIsomerizationsMovie with various arguments and comparing
% results with those stored.

    varargout = UnitTest.runValidationRun(@ValidationFunction, nargout, varargin);
end

%% Function implementing the isetbio validation code
function ValidationFunction(runTimeParams)
    
    %% Hello
    UnitTest.validationRecord('SIMPLE_MESSAGE', '***** v_IBIOCDIBanksEtAlReplicate *****');
    
    %% Freeze reandom number generator seed
    rng('default');
    
    %% Basic validation
    computeResponses = true;
 
    [validationData1, extraData1] = c_BanksEtAlReplicate('compute', computeResponses, 'nTrainingSamples',100,...
        'cyclesPerDegree',10,'luminances',340,'pupilDiamMm',2,'generatePlots',runTimeParams.generatePlots);
    UnitTest.validationData('validationData1',validationData1);
    UnitTest.extraData('extraData1',extraData1);
    
    [validationData2, extraData2] = c_BanksEtAlReplicate('compute', computeResponses, 'nTrainingSamples',100,...
        'cyclesPerDegree',10,'luminances',340,'pupilDiamMm',4,'generatePlots',runTimeParams.generatePlots);
    UnitTest.validationData('validationData2',validationData2);
    UnitTest.extraData('extraData2',extraData2);
 
    
    doSimulationWithOLDmosaicParams = false;
    if (doSimulationWithOLDmosaicParams)
    [validationData1, extraData1] = c_BanksEtAlReplicate('compute', computeResponses, 'nTrainingSamples',100,...
                'conePacking', 'rect', 'innerSegmentDiamMicrons', 1.4, 'coneSpacingMicrons', 2.0, ...   % old mosaic
        'cyclesPerDegree',10,'luminances',340,'pupilDiamMm',2,'generatePlots',runTimeParams.generatePlots);
    UnitTest.validationData('validationData1',validationData1);
    UnitTest.extraData('extraData3',extraData3);
    
    [validationData2, extraData2] = c_BanksEtAlReplicate('compute', computeResponses, 'nTrainingSamples',100,...
                'conePacking', 'rect', 'innerSegmentDiamMicrons', 1.4, 'coneSpacingMicrons', 2.0, ...   % old mosaic
        'cyclesPerDegree',10,'luminances',340,'pupilDiamMm',4,'generatePlots',runTimeParams.generatePlots);
    UnitTest.validationData('validationData2',validationData2);
    UnitTest.extraData('extraData4',extraData4);
    end
    
end



