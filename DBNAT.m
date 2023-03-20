function varargout = DBNAT(varargin)
% DBNAT MATLAB code for DBNAT.fig
%      DBNAT, by itself, creates a new DBNAT or raises the existing
%      singleton*.
%
%      H = DBNAT returns the handle to a new DBNAT or the handle to
%      the existing singleton*.
%
%      DBNAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DBNAT.M with the given input arguments.
%
%      DBNAT('Property','Value',...) creates a new DBNAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DBNAT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DBNAT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DBNAT

% Last Modified by GUIDE v2.5 18-Mar-2023 17:59:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DBNAT_OpeningFcn, ...
                   'gui_OutputFcn',  @DBNAT_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before DBNAT is made visible.
function DBNAT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DBNAT (see VARARGIN)

% Choose default command line output for DBNAT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DBNAT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DBNAT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
W = str2double(get(handles.windowlength,'String'));
s = str2double(get(handles.stepsize,'String'));
runs = str2double(get(handles.repeated,'String'));
database_path = get(handles.filepath,'String');
savefiles = get(handles.saveprocessfiles,'Value');

MethodCell = get(handles.dFCmethod,'String');
dFCmethod = MethodCell{get(handles.dFCmethod,'Value')};

filematCell = get(handles.filemat,'String');
filemat = filematCell{get(handles.filemat,'Value')};

% load([database_path,'\',filemat]);
cluster_test(database_path,filemat,W,s,dFCmethod,savefiles,runs);


% --- Executes on button press in clusterstatedistribution.
function clusterstatedistribution_Callback(hObject, eventdata, handles)
% hObject    handle to clusterstatedistribution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of clusterstatedistribution



function filepath_Callback(hObject, eventdata, handles)
% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filepath as text
%        str2double(get(hObject,'String')) returns contents of filepath as a double


% --- Executes during object creation, after setting all properties.
function filepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filemat.
function filemat_Callback(hObject, eventdata, handles)
% hObject    handle to filemat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filemat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filemat


% --- Executes during object creation, after setting all properties.
function filemat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filemat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in change.
function change_Callback(hObject, eventdata, handles)
% hObject    handle to change (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
database_path = uigetdir('*.*','Select Database Path');
if isequal(database_path,0)
    errordlg('No database path selected','Error');
else
    set(handles.filepath,'String',database_path);

    dirData = struct2cell(dir([database_path,'/*.mat']));
    set(handles.filemat,'String',dirData(1,:));
end



% --- Executes on selection change in dFCmethod.
function dFCmethod_Callback(hObject, eventdata, handles)
% hObject    handle to dFCmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MethodCell = get(handles.dFCmethod,'String');
fprintf('You chose: %s\n',MethodCell{get(handles.dFCmethod,'Value')});

cell_name = {'sliding window','tapered sliding window','correlation''s correlation'};
% {'spatial clustering', 'spatial distance'}
if find(strcmp(MethodCell{get(handles.dFCmethod,'Value')},cell_name) == 1)
    set(handles.windowlength,'Enable','on');
    set(handles.windowlengthtext,'Enable','on');
    set(handles.stepsize,'Enable','on');
    set(handles.stepsizetext,'Enable','on');
elseif strcmp(MethodCell{get(handles.dFCmethod,'Value')},'temporal derivatives')
    set(handles.windowlength,'Enable','on');
    set(handles.windowlengthtext,'Enable','on');
    set(handles.stepsize,'Enable','off');
    set(handles.stepsizetext,'Enable','off');
else
    set(handles.windowlength,'Enable','off');
    set(handles.windowlengthtext,'Enable','off');
    set(handles.stepsize,'Enable','off');
    set(handles.stepsizetext,'Enable','off');
end
% class(get(handles.saveprocessfiles,'Value'))
% Hints: contents = cellstr(get(hObject,'String')) returns dFCmethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dFCmethod


% --- Executes during object creation, after setting all properties.
function dFCmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dFCmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function windowlength_Callback(hObject, eventdata, handles)
% hObject    handle to windowlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowlength as text
%        str2double(get(hObject,'String')) returns contents of windowlength as a double


% --- Executes during object creation, after setting all properties.
function windowlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stepsize_Callback(hObject, eventdata, handles)
% hObject    handle to stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepsize as text
%        str2double(get(hObject,'String')) returns contents of stepsize as a double


% --- Executes during object creation, after setting all properties.
function stepsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveprocessfiles.
function saveprocessfiles_Callback(hObject, eventdata, handles)
% hObject    handle to saveprocessfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveprocessfiles



function repeated_Callback(hObject, eventdata, handles)
% hObject    handle to repeated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repeated as text
%        str2double(get(hObject,'String')) returns contents of repeated as a double


% --- Executes during object creation, after setting all properties.
function repeated_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repeated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function clusters_Callback(hObject, eventdata, handles)
% hObject    handle to clusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clusters as text
%        str2double(get(hObject,'String')) returns contents of clusters as a double


% --- Executes during object creation, after setting all properties.
function clusters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ttest_Callback(hObject, eventdata, handles)
% hObject    handle to ttest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ttest as text
%        str2double(get(hObject,'String')) returns contents of ttest as a double


% --- Executes during object creation, after setting all properties.
function ttest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double


% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clusterstatematrix.
function clusterstatematrix_Callback(hObject, eventdata, handles)
% hObject    handle to clusterstatematrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of clusterstatematrix


% --- Executes on button press in subjectdistribution.
function subjectdistribution_Callback(hObject, eventdata, handles)
% hObject    handle to subjectdistribution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of subjectdistribution


% --- Executes on button press in fractiontimemeandwelltime.
function fractiontimemeandwelltime_Callback(hObject, eventdata, handles)
% hObject    handle to fractiontimemeandwelltime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fractiontimemeandwelltime


% --- Executes on button press in numberoftransitions.
function numberoftransitions_Callback(hObject, eventdata, handles)
% hObject    handle to numberoftransitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of numberoftransitions


% --- Executes on button press in graphtheoryattribute.
function graphtheoryattribute_Callback(hObject, eventdata, handles)
% hObject    handle to graphtheoryattribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of graphtheoryattribute


% --- Executes on button press in circularGraph.
function circularGraph_Callback(hObject, eventdata, handles)
% hObject    handle to circularGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of circularGraph


% --- Executes on button press in exportcluster.
function exportcluster_Callback(hObject, eventdata, handles)
% hObject    handle to exportcluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exportcluster


% --- Executes on button press in exportgraph.
function exportgraph_Callback(hObject, eventdata, handles)
% hObject    handle to exportgraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exportgraph


% --- Executes on button press in GenerateBrainNet.
function GenerateBrainNet_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateBrainNet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GenerateBrainNet


% --- Executes on button press in GenerateDynamicBC.
function GenerateDynamicBC_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateDynamicBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GenerateDynamicBC


% --- Executes on button press in RUN.
function RUN_Callback(hObject, eventdata, handles)
% hObject    handle to RUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
database_path = get(handles.filepath,'String');
filematCell = get(handles.filemat,'String');
filemat = filematCell{get(handles.filemat,'Value')};
% load([database_path,'\',filemat]);

MethodCell = get(handles.dFCmethod,'String');
dFCmethod = MethodCell{get(handles.dFCmethod,'Value')};

savefiles = logical(get(handles.saveprocessfiles,'Value'));
savedrawingfile = logical(get(handles.savedrawingfile,'Value'));

% gparameter
W = str2double(get(handles.windowlength,'String'));
s = str2double(get(handles.stepsize,'String'));
K = str2double(get(handles.clusters,'String'));
ttest = str2double(get(handles.ttest,'String'));
threshold = str2double(get(handles.threshold,'String'));

% plot_matrix
clusterstatus = logical(get(handles.clusterstatedistribution,'Value'));
clusteringmatrix = logical(get(handles.clusterstatematrix,'Value'));
statedistribution = logical(get(handles.subjectdistribution,'Value'));
timefraction = logical(get(handles.fractiontimemeandwelltime,'Value'));
conversions = logical(get(handles.numberoftransitions,'Value'));
graph = logical(get(handles.graphtheoryattribute,'Value'));
circularGraph = logical(get(handles.circularGraph,'Value'));

% save_matrix
Outputclustering = logical(get(handles.exportcluster,'Value'));
Outputgraph = logical(get(handles.exportgraph,'Value'));
GenerateBrainNet = logical(get(handles.GenerateBrainNet,'Value'));
GenerateDynamicBC = logical(get(handles.GenerateDynamicBC,'Value'));

gparameter = [W,s,K,ttest,threshold];
plot_matrix = {clusterstatus,clusteringmatrix,statedistribution,timefraction,conversions,graph,circularGraph};
save_matrix = {Outputclustering,Outputgraph,GenerateBrainNet,GenerateDynamicBC};

save_file = {savefiles,savedrawingfile};

FunMain(database_path,filemat,gparameter,dFCmethod,save_file,plot_matrix,save_matrix);


% --- Executes on button press in savedrawingfile.
function savedrawingfile_Callback(hObject, eventdata, handles)
% hObject    handle to savedrawingfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of savedrawingfile
