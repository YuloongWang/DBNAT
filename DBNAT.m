classdef DBNAT < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DBNATUIFigure                 matlab.ui.Figure
        SaveLabel                     matlab.ui.control.Label
        FigureLabel                   matlab.ui.control.Label
        RUNButton                     matlab.ui.control.Button
        graphtheoryattributeCheckBox  matlab.ui.control.CheckBox
        exportgraphtheoryparameterttestresultsCheckBox  matlab.ui.control.CheckBox
        exportclusterparameterttestresultsCheckBox  matlab.ui.control.CheckBox
        numberoftransitionsCheckBox   matlab.ui.control.CheckBox
        fractiontimemeandwelltimeCheckBox  matlab.ui.control.CheckBox
        subjectdistributionCheckBox   matlab.ui.control.CheckBox
        clusterstatematrixCheckBox    matlab.ui.control.CheckBox
        clusterstatedistributionCheckBox  matlab.ui.control.CheckBox
        circularGraphCheckBox         matlab.ui.control.CheckBox
        ttestpEditField               matlab.ui.control.NumericEditField
        ttestpEditFieldLabel          matlab.ui.control.Label
        GenerateDynamicBCdrawingfileCheckBox  matlab.ui.control.CheckBox
        GenerateBrainNetdrawingfileCheckBox  matlab.ui.control.CheckBox
        thresholdEditField            matlab.ui.control.NumericEditField
        thresholdEditFieldLabel       matlab.ui.control.Label
        changeButton                  matlab.ui.control.Button
        filematDropDown               matlab.ui.control.DropDown
        filematDropDownLabel          matlab.ui.control.Label
        saveprocessfilesCheckBox      matlab.ui.control.CheckBox
        runButton                     matlab.ui.control.Button
        repeatedEditField             matlab.ui.control.NumericEditField
        repeatedEditFieldLabel        matlab.ui.control.Label
        clusterskEditField            matlab.ui.control.NumericEditField
        clusterskEditFieldLabel       matlab.ui.control.Label
        FilepathEditField             matlab.ui.control.EditField
        FilepathEditFieldLabel        matlab.ui.control.Label
        stepsizesEditField            matlab.ui.control.NumericEditField
        stepsizesEditFieldLabel       matlab.ui.control.Label
        windowlengthWEditField        matlab.ui.control.NumericEditField
        windowlengthWLabel            matlab.ui.control.Label
        dFCmethodDropDown             matlab.ui.control.DropDown
        dFCmethodDropDownLabel        matlab.ui.control.Label
    end

    
    properties (Access = public)
%         Property % Description
        database_path;
%         W;s;
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: FilepathEditField
        function FilepathEditFieldValueChanged(app, event)
%             value = app.FilepathEditField.Value;
            
        end

        % Value changing function: FilepathEditField
        function FilepathEditFieldValueChanging(app, event)
%             changingValue = event.Value;
            
        end

        % Button pushed function: changeButton
        function changeButtonPushed(app, event)
            app.database_path = uigetdir('*.*','Select Database Path');
            if isequal(app.database_path,0)
                errordlg('No database path selected','Error');
            else
                app.FilepathEditField.Value = app.database_path;
                
                dirData = struct2cell(dir([app.FilepathEditField.Value,'/*.mat']));
                app.filematDropDown.Items = dirData(1,:);
            end
        end

        % Drop down opening function: filematDropDown
        function filematDropDownOpening(app, event)
%             dirData = struct2cell(dir([app.FilepathEditField.Value,'/*.mat']));
%             app.filematDropDown.Items = dirData(1,:);
           
        end

        % Value changed function: windowlengthWEditField
        function windowlengthWEditFieldValueChanged(app, event)
%             app.W = app.windowlengthWEditField.Value;
            
        end

        % Value changed function: stepsizesEditField
        function stepsizesEditFieldValueChanged(app, event)
%             app.s = app.stepsizesEditField.Value;
            
        end

        % Button pushed function: RUNButton
        function RUNButtonPushed(app, event)
            load([app.database_path,'\',app.filematDropDown.Value]);
            
            dFCmethod = app.dFCmethodDropDown.Value;
            
            savefiles = app.saveprocessfilesCheckBox.Value;
            
            % gparameter
            W = app.windowlengthWEditField.Value;
            s = app.stepsizesEditField.Value;
            K = app.clusterskEditField.Value;
            ttest = app.ttestpEditField.Value;
            threshold = app.thresholdEditField.Value;
            
            % plot_matrix
            clusterstatus = app.clusterstatedistributionCheckBox.Value;
            clusteringmatrix = app.clusterstatematrixCheckBox.Value;
            statedistribution = app.subjectdistributionCheckBox.Value;
            timefraction = app.fractiontimemeandwelltimeCheckBox.Value;
            conversions = app.numberoftransitionsCheckBox.Value;
            graph = app.graphtheoryattributeCheckBox.Value;
            circularGraph = app.circularGraphCheckBox.Value;
            
            % save_matrix
            Outputclustering = app.exportclusterparameterttestresultsCheckBox.Value;
            Outputgraph = app.exportgraphtheoryparameterttestresultsCheckBox.Value;
            GenerateBrainNet = app.GenerateBrainNetdrawingfileCheckBox.Value;
            GenerateDynamicBC = app.GenerateDynamicBCdrawingfileCheckBox.Value;
            
            gparameter = [W,s,K,ttest,threshold];
            plot_matrix = {clusterstatus,clusteringmatrix,statedistribution,timefraction,conversions,graph,circularGraph};
            save_matrix = {Outputclustering,Outputgraph,GenerateBrainNet,GenerateDynamicBC};
            
            FunMain(ROISignals_HE,ROISignals_PA,gparameter,dFCmethod,savefiles,plot_matrix,save_matrix);
        end

        % Value changed function: dFCmethodDropDown
        function dFCmethodDropDownValueChanged(app, event)
%             value = app.dFCmethodDropDown.Value;
            fprintf('You chose: %s\n',app.dFCmethodDropDown.Value);
            cell_name = {'sliding window','tapered sliding window','correlation''s correlation'};
%           {'Spatial clustering', 'Spatial distance'}
            if find(strcmp(app.dFCmethodDropDown.Value,cell_name) == 1)
                app.windowlengthWEditField.Enable = 'on';
                app.windowlengthWLabel.Enable = 'on';
                app.stepsizesEditField.Enable = 'on';
                app.stepsizesEditFieldLabel.Enable = 'on';
            elseif strcmp(app.dFCmethodDropDown.Value,'temporal derivatives')
                app.windowlengthWEditField.Enable = 'on';
                app.windowlengthWLabel.Enable = 'on';
                app.stepsizesEditField.Enable = 'off';
                app.stepsizesEditFieldLabel.Enable = 'off';
            else
                app.windowlengthWEditField.Enable = 'off';
                app.windowlengthWLabel.Enable = 'off';
                app.stepsizesEditField.Enable = 'off';
                app.stepsizesEditFieldLabel.Enable = 'off';
            end
        end

        % Button pushed function: runButton
        function runButtonPushed(app, event)
            W = app.windowlengthWEditField.Value;
            s = app.stepsizesEditField.Value;
            dFCmethod = app.dFCmethodDropDown.Value;
            savefiles = app.saveprocessfilesCheckBox.Value;
            runs = app.repeatedEditField.Value;
            
            load([app.database_path,'\',app.filematDropDown.Value]);
            cluster_test(ROISignals_HE,ROISignals_PA,W,s,dFCmethod,savefiles,runs);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create DBNATUIFigure and hide until all components are created
            app.DBNATUIFigure = uifigure('Visible', 'off');
            app.DBNATUIFigure.AutoResizeChildren = 'off';
            app.DBNATUIFigure.Position = [100 100 640 431];
            app.DBNATUIFigure.Name = 'DBNAT';
            app.DBNATUIFigure.Resize = 'off';

            % Create dFCmethodDropDownLabel
            app.dFCmethodDropDownLabel = uilabel(app.DBNATUIFigure);
            app.dFCmethodDropDownLabel.HorizontalAlignment = 'right';
            app.dFCmethodDropDownLabel.Position = [5 359 71 22];
            app.dFCmethodDropDownLabel.Text = 'dFC method';

            % Create dFCmethodDropDown
            app.dFCmethodDropDown = uidropdown(app.DBNATUIFigure);
            app.dFCmethodDropDown.Items = {'option...', 'sliding window', 'tapered sliding window', 'temporal derivatives', 'correlation''s correlation'};
            app.dFCmethodDropDown.ValueChangedFcn = createCallbackFcn(app, @dFCmethodDropDownValueChanged, true);
            app.dFCmethodDropDown.Position = [82 359 162 22];
            app.dFCmethodDropDown.Value = 'option...';

            % Create windowlengthWLabel
            app.windowlengthWLabel = uilabel(app.DBNATUIFigure);
            app.windowlengthWLabel.HorizontalAlignment = 'right';
            app.windowlengthWLabel.Position = [273 359 104 22];
            app.windowlengthWLabel.Text = 'window length (W)';

            % Create windowlengthWEditField
            app.windowlengthWEditField = uieditfield(app.DBNATUIFigure, 'numeric');
            app.windowlengthWEditField.Limits = [10 Inf];
            app.windowlengthWEditField.ValueChangedFcn = createCallbackFcn(app, @windowlengthWEditFieldValueChanged, true);
            app.windowlengthWEditField.HorizontalAlignment = 'left';
            app.windowlengthWEditField.Enable = 'off';
            app.windowlengthWEditField.Position = [383 359 42 22];
            app.windowlengthWEditField.Value = 20;

            % Create stepsizesEditFieldLabel
            app.stepsizesEditFieldLabel = uilabel(app.DBNATUIFigure);
            app.stepsizesEditFieldLabel.HorizontalAlignment = 'right';
            app.stepsizesEditFieldLabel.Position = [303 325 74 22];
            app.stepsizesEditFieldLabel.Text = ' step size (s)';

            % Create stepsizesEditField
            app.stepsizesEditField = uieditfield(app.DBNATUIFigure, 'numeric');
            app.stepsizesEditField.Limits = [1 Inf];
            app.stepsizesEditField.ValueChangedFcn = createCallbackFcn(app, @stepsizesEditFieldValueChanged, true);
            app.stepsizesEditField.HorizontalAlignment = 'left';
            app.stepsizesEditField.Enable = 'off';
            app.stepsizesEditField.Position = [383 325 42 22];
            app.stepsizesEditField.Value = 11;

            % Create FilepathEditFieldLabel
            app.FilepathEditFieldLabel = uilabel(app.DBNATUIFigure);
            app.FilepathEditFieldLabel.HorizontalAlignment = 'right';
            app.FilepathEditFieldLabel.Position = [25 395 51 22];
            app.FilepathEditFieldLabel.Text = 'File path';

            % Create FilepathEditField
            app.FilepathEditField = uieditfield(app.DBNATUIFigure, 'text');
            app.FilepathEditField.ValueChangedFcn = createCallbackFcn(app, @FilepathEditFieldValueChanged, true);
            app.FilepathEditField.ValueChangingFcn = createCallbackFcn(app, @FilepathEditFieldValueChanging, true);
            app.FilepathEditField.Position = [82 395 248 22];

            % Create clusterskEditFieldLabel
            app.clusterskEditFieldLabel = uilabel(app.DBNATUIFigure);
            app.clusterskEditFieldLabel.HorizontalAlignment = 'right';
            app.clusterskEditFieldLabel.Position = [11 269 65 22];
            app.clusterskEditFieldLabel.Text = 'clusters (k)';

            % Create clusterskEditField
            app.clusterskEditField = uieditfield(app.DBNATUIFigure, 'numeric');
            app.clusterskEditField.Limits = [2 Inf];
            app.clusterskEditField.HorizontalAlignment = 'left';
            app.clusterskEditField.Position = [84 269 95 22];
            app.clusterskEditField.Value = 4;

            % Create repeatedEditFieldLabel
            app.repeatedEditFieldLabel = uilabel(app.DBNATUIFigure);
            app.repeatedEditFieldLabel.HorizontalAlignment = 'right';
            app.repeatedEditFieldLabel.Position = [23 301 53 22];
            app.repeatedEditFieldLabel.Text = 'repeated';

            % Create repeatedEditField
            app.repeatedEditField = uieditfield(app.DBNATUIFigure, 'numeric');
            app.repeatedEditField.Limits = [1 Inf];
            app.repeatedEditField.HorizontalAlignment = 'left';
            app.repeatedEditField.Position = [84 301 45 22];
            app.repeatedEditField.Value = 10;

            % Create runButton
            app.runButton = uibutton(app.DBNATUIFigure, 'push');
            app.runButton.ButtonPushedFcn = createCallbackFcn(app, @runButtonPushed, true);
            app.runButton.Position = [137 301 42 22];
            app.runButton.Text = 'run';

            % Create saveprocessfilesCheckBox
            app.saveprocessfilesCheckBox = uicheckbox(app.DBNATUIFigure);
            app.saveprocessfilesCheckBox.Text = 'save process files';
            app.saveprocessfilesCheckBox.Position = [467 359 117 22];
            app.saveprocessfilesCheckBox.Value = true;

            % Create filematDropDownLabel
            app.filematDropDownLabel = uilabel(app.DBNATUIFigure);
            app.filematDropDownLabel.HorizontalAlignment = 'right';
            app.filematDropDownLabel.Position = [405 395 55 22];
            app.filematDropDownLabel.Text = 'file (.mat)';

            % Create filematDropDown
            app.filematDropDown = uidropdown(app.DBNATUIFigure);
            app.filematDropDown.Items = {};
            app.filematDropDown.DropDownOpeningFcn = createCallbackFcn(app, @filematDropDownOpening, true);
            app.filematDropDown.Position = [467 395 160 22];
            app.filematDropDown.Value = {};

            % Create changeButton
            app.changeButton = uibutton(app.DBNATUIFigure, 'push');
            app.changeButton.ButtonPushedFcn = createCallbackFcn(app, @changeButtonPushed, true);
            app.changeButton.Position = [336 395 58 22];
            app.changeButton.Text = 'change';

            % Create thresholdEditFieldLabel
            app.thresholdEditFieldLabel = uilabel(app.DBNATUIFigure);
            app.thresholdEditFieldLabel.HorizontalAlignment = 'right';
            app.thresholdEditFieldLabel.Position = [377 269 57 22];
            app.thresholdEditFieldLabel.Text = 'threshold';

            % Create thresholdEditField
            app.thresholdEditField = uieditfield(app.DBNATUIFigure, 'numeric');
            app.thresholdEditField.Limits = [-1 1];
            app.thresholdEditField.HorizontalAlignment = 'left';
            app.thresholdEditField.Position = [439 269 51 22];
            app.thresholdEditField.Value = 0.7;

            % Create GenerateBrainNetdrawingfileCheckBox
            app.GenerateBrainNetdrawingfileCheckBox = uicheckbox(app.DBNATUIFigure);
            app.GenerateBrainNetdrawingfileCheckBox.Text = 'Generate BrainNet drawing file';
            app.GenerateBrainNetdrawingfileCheckBox.Position = [361 81 204 22];
            app.GenerateBrainNetdrawingfileCheckBox.Value = true;

            % Create GenerateDynamicBCdrawingfileCheckBox
            app.GenerateDynamicBCdrawingfileCheckBox = uicheckbox(app.DBNATUIFigure);
            app.GenerateDynamicBCdrawingfileCheckBox.Text = 'Generate DynamicBC drawing file';
            app.GenerateDynamicBCdrawingfileCheckBox.Position = [361 56 204 22];
            app.GenerateDynamicBCdrawingfileCheckBox.Value = true;

            % Create ttestpEditFieldLabel
            app.ttestpEditFieldLabel = uilabel(app.DBNATUIFigure);
            app.ttestpEditFieldLabel.HorizontalAlignment = 'right';
            app.ttestpEditFieldLabel.Position = [248 269 57 22];
            app.ttestpEditFieldLabel.Text = 't-test (p)';

            % Create ttestpEditField
            app.ttestpEditField = uieditfield(app.DBNATUIFigure, 'numeric');
            app.ttestpEditField.Limits = [0 1];
            app.ttestpEditField.HorizontalAlignment = 'left';
            app.ttestpEditField.Position = [310 269 51 22];
            app.ttestpEditField.Value = 0.01;

            % Create circularGraphCheckBox
            app.circularGraphCheckBox = uicheckbox(app.DBNATUIFigure);
            app.circularGraphCheckBox.Text = 'circularGraph';
            app.circularGraphCheckBox.Position = [310 198 210 22];
            app.circularGraphCheckBox.Value = true;

            % Create clusterstatedistributionCheckBox
            app.clusterstatedistributionCheckBox = uicheckbox(app.DBNATUIFigure);
            app.clusterstatedistributionCheckBox.Text = 'cluster state distribution';
            app.clusterstatedistributionCheckBox.Position = [84 223 210 22];
            app.clusterstatedistributionCheckBox.Value = true;

            % Create clusterstatematrixCheckBox
            app.clusterstatematrixCheckBox = uicheckbox(app.DBNATUIFigure);
            app.clusterstatematrixCheckBox.Text = 'cluster state matrix';
            app.clusterstatematrixCheckBox.Position = [84 198 210 22];
            app.clusterstatematrixCheckBox.Value = true;

            % Create subjectdistributionCheckBox
            app.subjectdistributionCheckBox = uicheckbox(app.DBNATUIFigure);
            app.subjectdistributionCheckBox.Text = 'subject distribution';
            app.subjectdistributionCheckBox.Position = [84 173 210 22];
            app.subjectdistributionCheckBox.Value = true;

            % Create fractiontimemeandwelltimeCheckBox
            app.fractiontimemeandwelltimeCheckBox = uicheckbox(app.DBNATUIFigure);
            app.fractiontimemeandwelltimeCheckBox.Text = 'fraction time & mean dwell time';
            app.fractiontimemeandwelltimeCheckBox.Position = [84 148 190 22];
            app.fractiontimemeandwelltimeCheckBox.Value = true;

            % Create numberoftransitionsCheckBox
            app.numberoftransitionsCheckBox = uicheckbox(app.DBNATUIFigure);
            app.numberoftransitionsCheckBox.Text = 'number of transitions';
            app.numberoftransitionsCheckBox.Position = [84 123 210 22];
            app.numberoftransitionsCheckBox.Value = true;

            % Create exportclusterparameterttestresultsCheckBox
            app.exportclusterparameterttestresultsCheckBox = uicheckbox(app.DBNATUIFigure);
            app.exportclusterparameterttestresultsCheckBox.Text = 'export cluster parameter t-test results';
            app.exportclusterparameterttestresultsCheckBox.Position = [84 81 255 22];
            app.exportclusterparameterttestresultsCheckBox.Value = true;

            % Create exportgraphtheoryparameterttestresultsCheckBox
            app.exportgraphtheoryparameterttestresultsCheckBox = uicheckbox(app.DBNATUIFigure);
            app.exportgraphtheoryparameterttestresultsCheckBox.Text = 'export graph theory parameter t-test results';
            app.exportgraphtheoryparameterttestresultsCheckBox.Position = [84 56 255 22];
            app.exportgraphtheoryparameterttestresultsCheckBox.Value = true;

            % Create graphtheoryattributeCheckBox
            app.graphtheoryattributeCheckBox = uicheckbox(app.DBNATUIFigure);
            app.graphtheoryattributeCheckBox.Text = 'graph theory attribute';
            app.graphtheoryattributeCheckBox.Position = [310 223 210 22];
            app.graphtheoryattributeCheckBox.Value = true;

            % Create RUNButton
            app.RUNButton = uibutton(app.DBNATUIFigure, 'push');
            app.RUNButton.ButtonPushedFcn = createCallbackFcn(app, @RUNButtonPushed, true);
            app.RUNButton.Position = [488 18 100 22];
            app.RUNButton.Text = 'RUN';

            % Create FigureLabel
            app.FigureLabel = uilabel(app.DBNATUIFigure);
            app.FigureLabel.HorizontalAlignment = 'right';
            app.FigureLabel.Position = [37 223 39 22];
            app.FigureLabel.Text = 'Figure';

            % Create SaveLabel
            app.SaveLabel = uilabel(app.DBNATUIFigure);
            app.SaveLabel.HorizontalAlignment = 'right';
            app.SaveLabel.Position = [43 81 33 22];
            app.SaveLabel.Text = 'Save';

            % Show the figure after all components are created
            app.DBNATUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DBNAT

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DBNATUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DBNATUIFigure)
        end
    end
end