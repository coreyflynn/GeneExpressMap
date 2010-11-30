function varargout = GeneExpress3DSurfaceView(varargin)
% GENEEXPRESS3DSURFACEVIEW M-file for GeneExpress3DSurfaceView.fig
%      GENEEXPRESS3DSURFACEVIEW, by itself, creates a new GENEEXPRESS3DSURFACEVIEW or raises the existing
%      singleton*.
%
%      H = GENEEXPRESS3DSURFACEVIEW returns the handle to a new GENEEXPRESS3DSURFACEVIEW or the handle to
%      the existing singleton*.
%
%      GENEEXPRESS3DSURFACEVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENEEXPRESS3DSURFACEVIEW.M with the given input arguments.
%
%      GENEEXPRESS3DSURFACEVIEW('Property','Value',...) creates a new GENEEXPRESS3DSURFACEVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeneExpress3DSurfaceView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeneExpress3DSurfaceView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GeneExpress3DSurfaceView

% Last Modified by GUIDE v2.5 18-Oct-2010 11:01:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GeneExpress3DSurfaceView_OpeningFcn, ...
                   'gui_OutputFcn',  @GeneExpress3DSurfaceView_OutputFcn, ...
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


% --- Executes just before GeneExpress3DSurfaceView is made visible.
function GeneExpress3DSurfaceView_OpeningFcn(hObject, eventdata, handles, varargin)
inputStruct=varargin{1};
handles.is=inputStruct;

%set popupmenu defaults
set(handles.RedMenu,'Value',3);
set(handles.GreenMenu,'Value',4);
set(handles.BlueMenu,'Value',2);

%set stack defaults
handles.RedStack=handles.is.FISHthreshstack;
handles.GreenStack=handles.is.FISHthreshstack2;
handles.BlueStack=handles.is.threshstack;

%pull resolution info
handles.xyres=handles.is.xyres;
handles.zres=handles.is.zres;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GeneExpress3DSurfaceView (see VARARGIN)

% Choose default command line output for GeneExpress3DSurfaceView
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GeneExpress3DSurfaceView wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GeneExpress3DSurfaceView_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in RedMenu.
function RedMenu_Callback(hObject, eventdata, handles)
switch get(handles.RedMenu,'Value')
     case 1
        handles.RedStack=handles.is.blank;
    case 2
        handles.RedStack=handles.is.threshstack;
    case 3
        handles.RedStack=handles.is.FISHthreshstack;
    case 4
        handles.RedStack=handles.is.FISHthreshstack2;
    case 5
        handles.RedStack=handles.is.nucopenstack;
    case 6
        handles.RedStack=handles.is.FISHopenstack;
    case 7
        handles.RedStack=handles.is.FISHopenstack2;
    case 8
        handles.RedStack=handles.is.FISHdilatestack;
    case 9
        handles.RedStack=handles.is.FISHdilatestack2;
    case 10
        handles.RedStack=handles.is.posstack>0;
	case 11
        handles.RedStack=handles.is.posstack2>0;
end
guidata(hObject, handles);
% hObject    handle to RedMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns RedMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RedMenu


% --- Executes during object creation, after setting all properties.
function RedMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RedMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in GreenMenu.
function GreenMenu_Callback(hObject, eventdata, handles)
switch get(handles.GreenMenu,'Value')
     case 1
        handles.GreenStack=handles.is.blank;
    case 2
        handles.GreenStack=handles.is.threshstack;
    case 3
        handles.GreenStack=handles.is.FISHthreshstack;
    case 4
        handles.GreenStack=handles.is.FISHthreshstack2;
    case 5
        handles.GreenStack=handles.is.nucopenstack;
    case 6
        handles.GreenStack=handles.is.FISHopenstack;
    case 7
        handles.GreenStack=handles.is.FISHopenstack2;
    case 8
        handles.GreenStack=handles.is.FISHdilatestack;
    case 9
        handles.GreenStack=handles.is.FISHdilatestack2;
    case 10
        handles.GreenStack=handles.is.posstack>0;
	case 11
        handles.GreenStack=handles.is.posstack2>0;
end
guidata(hObject, handles);
% hObject    handle to GreenMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns GreenMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GreenMenu


% --- Executes during object creation, after setting all properties.
function GreenMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GreenMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BlueMenu.
function BlueMenu_Callback(hObject, eventdata, handles)
switch get(handles.BlueMenu,'Value')
    case 1
        handles.BlueStack=handles.is.blank;
    case 2
        handles.BlueStack=handles.is.threshstack;
    case 3
        handles.BlueStack=handles.is.FISHthreshstack;
    case 4
        handles.BlueStack=handles.is.FISHthreshstack2;
    case 5
        handles.BlueStack=handles.is.nucopenstack;
    case 6
        handles.BlueStack=handles.is.FISHopenstack;
    case 7
        handles.BlueStack=handles.is.FISHopenstack2;
    case 8
        handles.BlueStack=handles.is.FISHdilatestack;
    case 9
        handles.BlueStack=handles.is.FISHdilatestack2;
    case 10
        handles.BlueStack=handles.is.posstack>0;
	case 11
        handles.BlueStack=handles.is.posstack2>0;
end
guidata(hObject, handles);
% hObject    handle to BlueMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BlueMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BlueMenu


% --- Executes during object creation, after setting all properties.
function BlueMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlueMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RedAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to RedAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RedAlpha as text
%        str2double(get(hObject,'String')) returns contents of RedAlpha as a double


% --- Executes during object creation, after setting all properties.
function RedAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RedAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GreenAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to GreenAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GreenAlpha as text
%        str2double(get(hObject,'String')) returns contents of GreenAlpha as a double


% --- Executes during object creation, after setting all properties.
function GreenAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GreenAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BlueAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to BlueAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BlueAlpha as text
%        str2double(get(hObject,'String')) returns contents of BlueAlpha as a double


% --- Executes during object creation, after setting all properties.
function BlueAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlueAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DisplayButton.
function DisplayButton_Callback(hObject, eventdata, handles)
%grab strings from popups
RedString=grabPopupString(handles,handles.RedMenu);
GreenString=grabPopupString(handles,handles.GreenMenu);
BlueString=grabPopupString(handles,handles.BlueMenu);

%grab alpha values
RedAlpha=str2double(get(handles.RedAlpha,'String'));
GreenAlpha=str2double(get(handles.GreenAlpha,'String'));
BlueAlpha=str2double(get(handles.BlueAlpha,'String'));

%shrink datasets to a more manageable size
ShrinkSize=round(size(handles.RedStack)/4);
disp(sprintf('Shrinking %s',RedString));
RedShrink=shrink3D(handles.RedStack,ShrinkSize)>0;
disp(sprintf('Shrinking %s',GreenString));
GreenShrink=shrink3D(handles.GreenStack,ShrinkSize)>0;
disp(sprintf('Shrinking %s',BlueString));
BlueShrink=shrink3D(handles.BlueStack,ShrinkSize)>0;

%set of figure for surface views
h=figure;
set(h,'Color','k');
set(h,'Name','Surface View','NumberTitle','off');
hold on;

%calculate and display surfaces
AspectRatio=[1 1 handles.xyres/handles.zres];
disp(sprintf('Calculating %s surface',RedString));
plotSurface(RedShrink,.5,[1 0 0],AspectRatio,RedAlpha);drawnow;
disp(sprintf('Calculating %s surface',GreenString));
plotSurface(GreenShrink,.5,[0 1 0],AspectRatio,GreenAlpha);drawnow;
disp(sprintf('Calculating %s surface',BlueString));
plotSurface(BlueShrink,.5,[0 0 1],AspectRatio,BlueAlpha);drawnow;
hold off;


% --- Executes on button press in ExportSurface.
function ExportSurface_Callback(hObject, eventdata, handles)
% hObject    handle to ExportSurface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function selected_string=grabPopupString(handles,popup)
val = get(popup,'Value');
string_list = get(popup,'String');
selected_string = string_list{val};


