function run_SVMRepsVaryConditions
% This is the script used to assess the impact of different # of trials on the SVM-based CSF
%  
    % How to split the computation
    % 16 or 32 (already did 32 with 64K reps)
    computationInstance =  32;
    
    % Whether to make a summary figure with CSF from all examined conditions
    makeSummaryFigure = true;
    
    % Mosaic to use
    mosaicName = 'ISETbioHexEccBasedLMSrealistic'; 
    
    % Optics to use
    opticsName = 'ThibosBestPSFSubject3MMPupil';
    
    params = getCSFpaperDefaultParams(mosaicName, computationInstance);
    
    params.opticsModel = opticsName;
    
    params.frameRate = 10; %(10 frames/sec, so 1 frame, 100 msec long)
    params.responseStabilizationMilliseconds = 40;
    params.responseExtinctionMilliseconds = 40;
    
     % Eye movement setup
    params.emPathType = 'random';
    params.centeredEMPaths = true;
    emLegend = 'drifts+\mu-saccades (random)';
     % Contrast range to examine and trials num
    if (computationInstance == 32)
        params.lowContrast = 0.01;
        params.highContrast =  0.3;
        params.nContrastsPerDirection =  20;
        % Trials to generate
        params.nTrainingSamples = 1024*64;
    elseif (computationInstance == 16)
        params.lowContrast = 0.001;
        params.highContrast =  0.3;
        params.nContrastsPerDirection =  15;
        % Trials to generate
        params.nTrainingSamples = 1024*32;
    end
    
    % Trials to use in the classifier - vary this one
    params.performanceTrialsUsed = params.nTrainingSamples;
    
    trainingSamples = 2.^[10 11 12 13 14 15];
    maxK = 8;
    for k = 1:numel(trainingSamples)
        kk = k;
        performanceTrialsUsed = trainingSamples(k);
        examinedCond(kk).classifier = 'svmV1FilterBank';
        examinedCond(kk).performanceTrialsUsed = performanceTrialsUsed;
        legends{kk} = sprintf('QPhE SVM, %d trials', performanceTrialsUsed);
        legendsForPsychometricFunctions{kk} = sprintf('%d trials', performanceTrialsUsed);
    end
    
    theTitle = ''; %sprintf('%2.0f c/deg, %s\n%s', computationInstance, examinedCond(1).classifier, emLegend);
    fixedParamName = sprintf('%2.0fCPD_%s_%s', computationInstance, examinedCond(1).classifier, emLegend);
    
    % Simulation steps to perform
    params.computeMosaic = ~true; 
    params.visualizeMosaic = ~true;
    
    params.computeResponses = ~true;
    params.computePhotocurrentResponseInstances = ~true;
    params.visualizeResponses = ~true;
    params.visualizeSpatialScheme = ~true;
    params.visualizeOIsequence = ~true;
    params.visualizeOptics = ~true;
    params.visualizeMosaicWithFirstEMpath = ~true;
    params.visualizeSpatialPoolingScheme = ~true;
    params.visualizeStimulusAndOpticalImage = ~true;
    
    params.visualizeKernelTransformedSignals = ~true;
    params.findPerformance = ~true;
    params.visualizePerformance = true;
    params.deleteResponseInstances = ~true;
    
    % Go
    for condIndex = 1:numel(examinedCond)
        params.performanceClassifier = examinedCond(condIndex).classifier;
        params.performanceTrialsUsed = examinedCond(condIndex).performanceTrialsUsed;
        [~, thePsychometricFunctions, theFigData{condIndex}] = run_BanksPhotocurrentEyeMovementConditions(params);
       
        if (numel(thePsychometricFunctions) > 1)
            error('There were more than 1 spatial frequency point\n');
        end
        thePsychometricFunctions =  thePsychometricFunctions{:};
        thePsychometricFunctions = thePsychometricFunctions{1};
        sf0PsychometricFunctions{condIndex} = thePsychometricFunctions;
        theTrials(condIndex) = params.performanceTrialsUsed ;
    end
    
    
    if (makeSummaryFigure)
        
            if (computationInstance ==16)
        csLims = [30 35];
    else
        csLims = [5 10];
            end
    
        generatePsychometricFunctionsPlot(sf0PsychometricFunctions, csLims, theTrials, legendsForPsychometricFunctions, theTitle, fixedParamName);
        variedParamName = 'SVMTrials';
        theRatioLims = [0.05 0.5];
        theRatioTicks = [0.05 0.1 0.2 0.5];
        generateFigureForPaper(theFigData, legends, variedParamName, '', ...
            'figureType', 'CSF', ...
            'inGraphText', ' A ', ...
            'plotFirstConditionInGray', true, ...
            'plotRatiosOfOtherConditionsToFirst', true, ...
            'theRatioLims', theRatioLims, ...
            'theRatioTicks', theRatioTicks ...
            );
    end
end

function generatePsychometricFunctionsPlot(psychometricFunctions, csLims,  theTrials, trialLegends, theTitle, fixedParamName)
    conditionsNum = numel(psychometricFunctions);
    
    hFig = figure(15); clf;
    [theAxes, theRatioAxes] = formatFigureForPaper(hFig, ...
        'figureType', 'PSYCHOMETRIC_FUNCTIONS');

    colors(1,:) = [0.5 0.5 0.5];
    if (conditionsNum>1)
            colors(2:conditionsNum,:) = brewermap(conditionsNum-1, 'Set1');
    end
    
    for cond = 1:numel(psychometricFunctions)
        psyF = psychometricFunctions{cond};
        hold(theAxes, 'on');
        plot(theAxes, psyF.x, psyF.y, 'ko-', 'MarkerSize', 10, ...
            'MarkerFaceColor', [0.5 0.5 0.5] + 0.5*(squeeze(colors(cond,:))), ...
            'Color', squeeze(colors(cond,:)), 'LineWidth', 1.5);
    end
    
    for cond = 1:numel(psychometricFunctions)
        psyF = psychometricFunctions{cond};
        theThresholds(cond) = psyF.thresholdContrast;
%         plot(theAxes, psyF.xFit, psyF.yFit, '-', ...
%             'Color', squeeze(colors(cond,:)), 'LineWidth', 1.5);
        plot(theAxes, psyF.x, psyF.y, 'ko', 'MarkerSize', 10, ...
            'MarkerFaceColor', [0.5 0.5 0.5] + 0.5*(squeeze(colors(cond,:))));
    end
    hold(theAxes, 'off');
    xlabel(theAxes, 'contrast', 'FontWeight', 'Bold');
    ylabel(theAxes, 'percent correct', 'FontWeight', 'Bold');
    hL = legend(theAxes, trialLegends);
    
    plot(theRatioAxes, theTrials, 1./theThresholds, 'ko-', 'MarkerSize', 10, 'MarkerFaceColor', [0.75 0.75 0.75]);
    xlabel(theRatioAxes, 'trials', 'FontWeight', 'Bold');
    ylabel(theRatioAxes, 'contrast sensitivity', 'FontWeight', 'Bold');
    
    inGraphTextFontSize = [];
    % Format figure
    formatFigureForPaper(hFig, ...
        'figureType', 'PSYCHOMETRIC_FUNCTIONS', ...
        'plotRatiosOfOtherConditionsToFirst', false, ...
        'theAxes', theAxes, ...
        'theRatioAxes', theRatioAxes, ...
        'theLegend', hL, ...
        'theTextFontSize', inGraphTextFontSize);
    

    
    
    
    csTicks = [2 5 6 7 8 9 10  20 30 31 32 33 34 35 50 100 200 500 1000 2000 5000 10000];
    theText = text(2000, csLims(2)*0.97, theTitle);
    set(theText, 'FontSize', 16, ...
                    'FontWeight', 'Normal', ...
                    'BackgroundColor', [1 1 1], ...
                    'EdgeColor', [ 0 0 0], ...
                    'LineWidth', 1.0);
                
    set(theAxes, 'XLim', [0.001 0.35], 'XTick', [0.01 0.03 0.1 0.3], 'YLim', [0.4 1.0], 'XTick', [0.003 0.01 0.03 0.1 0.3]);
    set(theRatioAxes, 'XTick', [300 1000 3000 10000 30000 100000],  ...
        'YScale', 'log', 'XLim', [300 100000], ...
        'YLim', csLims, 'YTick', csTicks);
    
    exportsDir = strrep(isetRootPath(), 'toolboxes/isetbio/isettools', 'projects/IBIOColorDetect/paperfigs/CSFpaper/exports');
    variedParamName = 'TrialsNum';
    fixedParamName = strrep(fixedParamName, '\mu', 'micro');
    figureName = fullfile(exportsDir, sprintf('%sVary%s.pdf', variedParamName, fixedParamName));
    NicePlot.exportFigToPDF(figureName, hFig, 300);
    
end
