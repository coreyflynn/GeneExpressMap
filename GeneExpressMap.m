function varargout = GeneExpressMap(varargin)
% GENEEXPRESSMAP M-file for GeneExpressMap.fig
%      GENEEXPRESSMAP, by itself, creates a new GENEEXPRESSMAP or raises the existing
%      singleton*.
%
%      H = GENEEXPRESSMAP returns the handle to a new GENEEXPRESSMAP or the handle to
%      the existing singleton*.
%
%      GENEEXPRESSMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENEEXPRESSMAP.M with the given input arguments.
%
%      GENEEXPRESSMAP('Property','Value',...) creates a new GENEEXPRESSMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeneExpressMap_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeneExpressMap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 13-Jun-2011 14:43:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GeneExpressMap_OpeningFcn, ...
                   'gui_OutputFcn',  @GeneExpressMap_OutputFcn, ...
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


% --- Executes just before GeneExpressMap is made visible.
function GeneExpressMap_OpeningFcn(hObject, eventdata, handles, varargin)
%set the initial state of axes and GUI objects
axes(handles.axes1);axis off;
axes(handles.axes2);axis off;
axes(handles.axes3);axis off;
axes(handles.axes4);axis off;
set(handles.pathEdit,'String','~/Desktop');
set(handles.NucThreshButton,'Enable','off');
set(handles.FISHThreshButton,'Enable','off');
set(handles.FISHThresh2Button,'Enable','off');
set(handles.OpenNucButton,'Enable','off');
set(handles.OpenFISHButton,'Enable','off');
set(handles.OpenFISH2Button,'Enable','off');
set(handles.DilateFISHButton,'Enable','off');
set(handles.DilateFISH2Button,'Enable','off');
set(handles.FindNucButton,'Enable','off');
set(handles.FindPosNucButton,'Enable','off');
set(handles.menu_CheckCenters,'Enable','off');
set(handles.menu_Mline,'Enable','off');
set(handles.menu_3D,'Enable','off');
set(handles.menu_visMode,'Enable','off');
set(handles.menu_visMult,'Enable','off');
set(handles.menu_visBinary,'Enable','off');
set(handles.menu_visHeat,'Enable','off');
set(handles.menu_checkOverlap,'Enable','off');
set(handles.menu_surf,'Enable','off');
set(handles.toolbar3Dplot,'Enable','off');
set(handles.toolbarMline,'Enable','off');
set(handles.popupmenu3,'Value',2);

%set up processing flags for later use
handles.flags=[0 0 0 0 0 0 0 0 0 0 0 0];
handles.LUTFlag=0;


% Choose default command line output for GeneExpressMap
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = GeneExpressMap_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function ImageSlider_Callback(hObject, eventdata, handles)
Val=round(get(handles.ImageSlider,'Value'));
axes(handles.axes1);
handles.hImg1=imagesc(handles.currentstack1(:,:,Val));colormap(gray);axis off;
axes(handles.axes2);
handles.hImg2=imagesc(handles.currentstack2(:,:,Val));colormap(gray);axis off;
axes(handles.axes4);
handles.hImg4=imagesc(handles.currentstack3(:,:,Val));colormap(gray);axis off;
switch get(handles.popupmenu3,'Value')
    case 1 %pseudo color display
        axes(handles.axes3);
        handles.hImg3=imagesc(handles.overlap(:,:,Val));colormap(gray);axis off;
    case 2 %RGB display
        tmp=double(handles.currentstack1(:,:,Val));        
        handles.overlap(:,:,3)=tmp/max(max(tmp));
        tmp=double(handles.currentstack2(:,:,Val));
        handles.overlap(:,:,2)=tmp/max(max(tmp));
        tmp=double(handles.currentstack3(:,:,Val));
        handles.overlap(:,:,1)=tmp/max(max(tmp));
        axes(handles.axes3);
        handles.hImg3=imagesc(handles.overlap);colormap(gray);axis off;
end
handles.XData=get(handles.hImg1,'XData');
handles.YData=get(handles.hImg1,'YData');
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function ImageSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in NucThreshButton.
function NucThreshButton_Callback(hObject, eventdata, handles)
%set the user data of the stopbutton to 0
set(handles.stopButton,'UserData',0);

%threshold the raw nucleus stack at the value provided by the user
set(handles.statusEdit,'String','Thresholding Nucleus Stack');drawnow;
handles.thresh=str2num(get(handles.NucThreshEdit,'String'));
handles.threshstack=handles.nucstack*0;
handles.threshstack=handles.nucstack>handles.thresh;

%update the current image stacks and pull down list
handles.currentstack1=handles.threshstack;
set(handles.FISHThreshButton,'Enable','on');
if handles.flags(3)==0
    add_to_listbox(handles,'Thresholded Nucleus Data',[1 2 4]);
    handles.flags(3)=1;
end
set(handles.popupmenu1,'Value',4);
guidata(hObject, handles);
update_images(hObject,handles);
set(handles.statusEdit,'String','');drawnow;



function NucThreshEdit_Callback(hObject, eventdata, handles)
%empty callback for NucTreshEdit


% --- Executes during object creation, after setting all properties.
function NucThreshEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dilateButton.
function dilateButton_Callback(hObject, eventdata, handles)
% dilate the binary image held in openstack
openVal=str2double(get(handles.NucOpenEdit,'String'));
set(handles.statusEdit,'String','Opening FISH Stack');drawnow;
handles.dilatestack=double(handles.openstack*0);
s=strel('disk',openVal);
for N=size(handles.openstack,3)
    handles.dilatestack(:,:,N)=imerode(handles.FISHstack(:,:,N)>...
        handles.thresh,s);
end

for N=size(handles.openstack,3)
    handles.dilatestack(:,:,N)=imdilate(handles.dilatestack(:,:,N),s);
end

set(handles.statusEdit,'String','Dilating FISH Stack');drawnow;
for N=size(handles.openstack,3)
    handles.dilatestack(:,:,N)=imdilate(handles.dilatestack(:,:,N),s);
end

handles.overlapstack=handles.threshstack.*handles.dilatestack;

Val=round(get(handles.ImageSlider,'Value'));
axes(handles.axes1);imagesc(handles.threshstack(:,:,Val));colormap(gray);axis off;
axes(handles.axes2);imagesc(handles.dilatestack(:,:,Val));colormap(gray);axis off;
axes(handles.axes3);imagesc(handles.overlapstack(:,:,Val));colormap(gray);axis off;
guidata(hObject, handles);
handles.numim=size(handles.nucstack,3);
set(handles.ImageSlider,'Max',handles.numim,'Min',1,'SliderStep',[1/handles.numim 5/handles.numim],'Value',Val);
guidata(hObject, handles);

set(handles.statusEdit,'String','');

handles.processflag=2;
guidata(hObject, handles);




function NucOpenEdit_Callback(hObject, eventdata, handles)
%empty callback for NucOpenEdit

% --- Executes during object creation, after setting all properties.
function NucOpenEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overlapButton.
function overlapButton_Callback(hObject, eventdata, handles)


function overlapEdit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function overlapEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pathEdit_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function pathEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imageExport.
function imageExport_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menu_startDouble_Callback(hObject, eventdata, handles)
%begin double label analysis.  This is the default and is now called by
%start new analysis in the menu

%load the nucleus image stack from user specified path
path=get(handles.pathEdit,'String');
set(handles.statusEdit,'String','Reading Nucleus Image Data');drawnow;
[nucfile,nucpath]=uigetfile({'*.tif;*.tiff'},'select nucleus stack',path);
try
	nucstack=tiffread2(sprintf('%s/%s',nucpath,nucfile));
catch
	errordlg('GeneExpressMap requires tif stacks','Image Stack Import Error');
	set(handles.statusEdit,'String','');drawnow;
	return;
end

%load the FISH image stack from user specified path
set(handles.statusEdit,'String','Reading FISH Image Data');drawnow;
[FISHfile,FISHpath]=uigetfile({'*.tif;*.tiff'},'select FISH stack',nucpath);
try
	FISHstack=tiffread2(sprintf('%s/%s',FISHpath,FISHfile));
catch
	errordlg('GeneExpressMap requires tif stacks','Image Stack Import Error');
	set(handles.statusEdit,'String','');drawnow;
	return;
end

%load the FISH2 image stack from user specified path
set(handles.statusEdit,'String','Reading FISH Image 2 Data');drawnow;
[FISHfile,FISHpath]=uigetfile({'*.tif;*.tiff'},'select FISH stack 2',nucpath);
try
	FISHstack2=tiffread2(sprintf('%s/%s',FISHpath,FISHfile));
catch
	errordlg('GeneExpressMap requires tif stacks','Image Stack Import Error');
	set(handles.statusEdit,'String','');drawnow;
	return;
end

%check for dimension mismatch in the loaded data sets
nucSize = size(nucstack);
FISHSize = size(FISHstack);
FISHSize2 = size(FISHstack2);

if nucSize(1) ~= FISHSize(1) ||  nucSize(1) ~= FISHSize2(1)
	errordlg('GeneExpressMap requires image stacks of equal size','Image Size Error');
	set(handles.statusEdit,'String','');drawnow;
	return;
end

if nucSize(2) ~= FISHSize(2) ||  nucSize(2) ~= FISHSize2(2)
	errordlg('GeneExpressMap requires image stacks of equal size','Image Size Error');
	set(handles.statusEdit,'String','');drawnow;
	return;
end

%convert the nucleus data into a double stack and normalize from 0 to 1 for display
set(handles.statusEdit,'String','Converting Nucleus Data to Stack');drawnow;
handles.nucstack=zeros(nucstack(1).height,nucstack(1).width,length(nucstack));
for N=1:length(nucstack)
    handles.nucstack(:,:,N)=double(nucstack(N).data);
    handles.nucstack(:,:,N)=handles.nucstack(:,:,N)/max(max(handles.nucstack(:,:,N)));
end
handles.currentstack1=handles.nucstack;

%convert the FISH data into a double stack and normalize from 0 to 1 for display
set(handles.statusEdit,'String','Converting FISH Data to Stack');drawnow;
handles.FISHstack=zeros(FISHstack(1).height,FISHstack(1).width,length(FISHstack));
for N=1:length(FISHstack)
    handles.FISHstack(:,:,N)=double(FISHstack(N).data);
    handles.FISHstack(:,:,N)=handles.FISHstack(:,:,N)/max(max(handles.FISHstack(:,:,N)));
end
handles.currentstack2=handles.FISHstack;

%convert the FISH2 data into a double stack and normalize from 0 to 1 for display
set(handles.statusEdit,'String','Converting FISH Data 2 to Stack');drawnow;
handles.FISHstack2=zeros(FISHstack2(1).height,FISHstack2(1).width,length(FISHstack2));
for N=1:length(FISHstack)
    handles.FISHstack2(:,:,N)=double(FISHstack2(N).data);
    handles.FISHstack2(:,:,N)=handles.FISHstack2(:,:,N)/max(max(handles.FISHstack2(:,:,N)));
end
handles.currentstack3=handles.FISHstack2;

%set up the slider limit based on the loaded images
handles.numim=size(handles.nucstack,3);
set(handles.ImageSlider,'Max',handles.numim,'Min',1,'SliderStep',[1/handles.numim 5/handles.numim],'Value',1);
set(handles.pathEdit,'String',nucpath);drawnow;

%build the blank display array
handles.blank=handles.currentstack1*0;

%set the status of UI widgets apropriately
set(handles.popupmenu1,'Value',2);
set(handles.popupmenu2,'Value',3);
set(handles.popupmenu4,'Value',3);
set(handles.menu_Mline,'Enable','on');
set(handles.toolbarMline,'Enable','on');
set(handles.NucThreshButton,'Enable','on');

%set Thresholds based on MCT
set(handles.statusEdit,'String','Computing Thresholds');drawnow;
set(handles.NucThreshEdit,'String',...
    num2str(getThresh(handles.nucstack*255)/255));
set(handles.FISHThreshEdit,'String',...
    num2str(getThresh(handles.FISHstack*255)/255));
set(handles.FISHThreshEdit2,'String',...
    num2str(getThresh(handles.FISHstack2*255)/255));
handles.double=1;
set(handles.statusEdit,'String','');drawnow;
guidata(hObject, handles);
update_images(hObject,handles);



function statusEdit_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function statusEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function update_images(hObject,handles)
%update the display of all the images based on the currently active stacks and the 
%position of the image slider.
set(handles.statusEdit,'String','Updating Stacks');drawnow;
Val=round(get(handles.ImageSlider,'Value'));
switch get(handles.popupmenu3,'Value')
    case 1
        handles.overlap=handles.currentstack1.*handles.currentstack2;
        axes(handles.axes3);
        handles.hImg3=imagesc(handles.overlap(:,:,Val));colormap(gray);axis off;
    case 2
        handles.overlap=zeros(size(handles.currentstack1,1),...
            size(handles.currentstack1,2),3);
        tmp=double(handles.currentstack1(:,:,Val));        
        handles.overlap(:,:,3)=tmp/max(max(tmp));
        tmp=double(handles.currentstack2(:,:,Val));
        handles.overlap(:,:,2)=tmp/max(max(tmp));
        tmp=double(handles.currentstack3(:,:,Val));
        handles.overlap(:,:,1)=tmp/max(max(tmp));
        axes(handles.axes3);
        handles.hImg3=imagesc(handles.overlap);colormap(gray);axis off;
end
        
axes(handles.axes1);
handles.hImg1=imagesc(handles.currentstack1(:,:,Val));colormap(gray);axis off;

axes(handles.axes2);
handles.hImg2=imagesc(handles.currentstack2(:,:,Val));colormap(gray);axis off;

axes(handles.axes4);
handles.hImg4=imagesc(handles.currentstack3(:,:,Val));colormap(gray);axis off;

handles.XData=get(handles.hImg1,'XData');
handles.YData=get(handles.hImg1,'YData');
set(handles.statusEdit,'String','');drawnow;
guidata(hObject, handles);


% --- Executes on button press in stlExport.
function stlExport_Callback(hObject, eventdata, handles)
%export data in .stl format for basic use in 3D visualizations
[file,path]=uiputfile('~/Desktop','Specify .stl base name');
 filetok=strtok(file,'.');

nucstack=normalize_stack(handles.nucstack);
set(handles.statusEdit,'String','Writing Nucleus .stl file');drawnow;
nucv = isosurface(nucstack, 0.99);
patch2stl(sprintf('%s%s_nuc.stl',path,filetok),nucv);

% posstack=normalize_stack(handles.posstack);
% set(handles.statusEdit,'String','Writing Positive .stl file');drawnow;
% posv = isosurface(posstack, 0.99);
% patch2stl(sprintf('%s%s_pos.stl',path,filetok),posv);

% hObject    handle to stlExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function stack=normalize_stack(stack)
for N=size(stack,3)
    stack(:,:,N)=double(stack(:,:,N))/max(max(double(stack(:,:,N))));
end


% --------------------------------------------------------------------
function menu_Export_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_stlExport_Callback(hObject, eventdata, handles)
%export in .stl format for basic use in 3D visualizations 
dir=uigetdir('~/Desktop');
set(handles.statusEdit,'String','generating nucleus isosurface'); 
fv=isosurface(handles.nucopenstack,.99);
set(handles.statusEdit,'String','writing .stl file'); 
patch2stl(sprintf('%s/Nucleus.stl',dir),fv);

set(handles.statusEdit,'String','generating FISH isosurface'); 
fv=isosurface(handles.FISHopenstack,.99);
set(handles.statusEdit,'String','writing .stl file'); 
patch2stl(sprintf('%s/FISH.stl',dir),fv);
set(handles.statusEdit,'String',''); 



% --------------------------------------------------------------------
function menu_imageExport_Callback(hObject, eventdata, handles)
%export the visible image stacks to a user defined directory
savepath=uigetdir('~/Desktop');
switch get(handles.popupmenu3,'Value')
    case 1
        for N=1:size(handles.currentstack1,3)
			set(handles.statusEdit,'String','Saving images');
			%write single image files
			imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack1_%g.tif',savepath,N));
			imwrite(handles.currentstack2(:,:,N),sprintf('%s/Stack2_%g.tif',savepath,N));
			imwrite(handles.currentstack3(:,:,N),sprintf('%s/Stack3_%g.tif',savepath,N));
			imwrite(handles.overlap(:,:,N),sprintf('%s/overlap_%g.tif',savepath,N));
			%write tiff stack files
			if N==1
				imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack1.tif',savepath),'WriteMode','overwrite');
				imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack2.tif',savepath),'WriteMode','overwrite');
				imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack3.tif',savepath),'WriteMode','overwrite');
			else
				imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack1.tif',savepath),'WriteMode','append');
				imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack2.tif',savepath),'WriteMode','append');
				imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack3.tif',savepath),'WriteMode','append');
		   end
       end
    case 2
        tmpim=zeros(size(handles.currentstack1,1),size(handles.currentstack1,2),3);
        for N=1:size(handles.currentstack1,3)
			set(handles.statusEdit,'String','Saving images');
			imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack1_%g.tif',savepath,N));
			imwrite(handles.currentstack2(:,:,N),sprintf('%s/Stack2_%g.tif',savepath,N));
			imwrite(handles.currentstack3(:,:,N),sprintf('%s/Stack3_%g.tif',savepath,N));
			tmpim(:,:,3)=handles.currentstack1(:,:,N);
			tmpim(:,:,2)=handles.currentstack2(:,:,N);
			tmpim(:,:,1)=handles.currentstack3(:,:,N);
			imwrite(tmpim,sprintf('%s/overlap_%g.tif',savepath,N)...
				);
			%write tiff stack files
			if N==1
				imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack1.tif',savepath),'WriteMode','overwrite','Compression','none');
				imwrite(handles.currentstack2(:,:,N),sprintf('%s/Stack2.tif',savepath),'WriteMode','overwrite','Compression','none');
				imwrite(handles.currentstack3(:,:,N),sprintf('%s/Stack3.tif',savepath),'WriteMode','overwrite','Compression','none');
			else
				imwrite(handles.currentstack1(:,:,N),sprintf('%s/Stack1.tif',savepath),'WriteMode','append','Compression','none');
				imwrite(handles.currentstack2(:,:,N),sprintf('%s/Stack2.tif',savepath),'WriteMode','append','Compression','none');
				imwrite(handles.currentstack3(:,:,N),sprintf('%s/Stack3.tif',savepath),'WriteMode','append','Compression','none');
		   end
        end
end
set(handles.statusEdit,'String','');


% --------------------------------------------------------------------
function menu_workspaceExport_Callback(hObject, eventdata, handles)
%export program variables to the base workspace
assignin('base','nucstack',handles.nucstack);
assignin('base','FISHstack',handles.FISHstack);
assignin('base','nucthreshstack',handles.threshstack);
assignin('base','nucopenstack',handles.nucopenstack);
assignin('base','posstack',handles.posstack);
assignin('base','posstackbi',handles.posstackbi);
assignin('base','L',handles.L);
assignin('base','D',handles.D);
assignin('base','X',handles.X);
assignin('base','Y',handles.Y);
assignin('base','Z',handles.Z);
assignin('base','conX',handles.conX);
assignin('base','conY',handles.conY);
assignin('base','conZ',handles.conZ);
assignin('base','conposlist',handles.conposlist);
assignin('base','poslist',handles.poslist);




% --- Executes on button press in OpenNucButton.
function OpenNucButton_Callback(hObject, eventdata, handles)
%binary opening of nucleus data using a circular structuring element of user specified
%size in microns
open_val=str2double(get(handles.NucOpenEdit,'String'));
res=str2double(get(handles.xyresEdit,'String'));
S_size=round(open_val/res);
set(handles.statusEdit,'String','Opening Nucleus Stack');drawnow;
handles.s=strel('disk',S_size);
handles.nucopenstack=imopen(handles.threshstack,handles.s);
handles.currentstack1=handles.nucopenstack;
set(handles.statusEdit,'String','');drawnow;
set(handles.OpenFISHButton,'Enable','on');
if handles.flags(5)==0
    add_to_listbox(handles,'Opened Nucleus Data',[1 2 4]);
    handles.flags(5)=1;
end
set(handles.popupmenu1,'Value',6);
guidata(hObject, handles);
update_images(hObject,handles);



% --- Executes on button press in FindPosNucButton.
function FindPosNucButton_Callback(hObject, eventdata, handles)
%find positive nuclei in the first FISH stack
handles.posstack=handles.nucstack*0;
handles.posval=str2double(get(handles.overlapEdit,'String'))/100;
handles.poslist=[];
handles.nuclist=[];
set(handles.stopButton,'Enable','on');
for N=1:size(handles.nucstack,3)
    tmpL=handles.L(:,:,N);
    tmpO=handles.FISHdilatestack(:,:,N);
    tmpP=handles.posstack(:,:,N);
    set(handles.statusEdit,'String',...
        sprintf('Finding Labeled Slices: slice %g of %g',N,...
        size(handles.nucstack,3)));drawnow;
    handles.poslist=horzcat(handles.poslist,0);
    handles.nuclist=horzcat(handles.nuclist,1);
    for M=2:max(tmpL(:))
        %check for user interupt
        if get(handles.stopButton,'UserData') == 1
            set(handles.statusEdit,'String','');drawnow;
            set(handles.stopButton,'UserData',0);
            update_images(hObject,handles);
            set(handles.stopButton,'Enable','off');
            return;
        end
        found=find(tmpL==M);
        %flag nucleus slices as positive if more than a user defined
        %percentage of the nucleus is overlapping a region of FISH
        %expression
        pos=sum(tmpO(found));
        nuc=length(found);
        handles.poslist=horzcat(handles.poslist,pos);
        handles.nuclist=horzcat(handles.nuclist,nuc);
    end
end
handles.posstackbi=handles.posstack;


handles.posstack=handles.posstack.*handles.nucstack;
handles.currentstack2=handles.posstack;



%do the same for the second FISH stack
if handles.double==1
    handles.posstack2=handles.nucstack*0;
    handles.poslist2=[];
    handles.nuclist2=[];
    for N=1:size(handles.nucstack,3)
        tmpL=handles.L(:,:,N);
        tmpO=handles.FISHdilatestack2(:,:,N);
        set(handles.statusEdit,'String',...
            sprintf('Finding Labeled Slices: slice %g of %g',N,...
            size(handles.nucstack,3)));drawnow;
        handles.poslist2=horzcat(handles.poslist2,0);
        handles.nuclist2=horzcat(handles.nuclist2,1);
        for M=2:max(tmpL(:))
            %check for user interupt
            if get(handles.stopButton,'UserData') == 1
                set(handles.statusEdit,'String','');drawnow;
                set(handles.stopButton,'UserData',0);
                update_images(hObject,handles);
                set(handles.stopButton,'Enable','off');
                return;
            end
            found=find(tmpL==M);
            %flag nucleus slices as positive if more than a user defined
            %percentage of the nucleus is overlapping a region of FISH
            %expression
            pos=sum(tmpO(found));
            nuc=length(found);
            handles.poslist2=horzcat(handles.poslist2,pos);
            handles.nuclist2=horzcat(handles.nuclist2,nuc);
        end
    end
end

%update listboxes and availability of menu items
if handles.flags(9)==0
    add_to_listbox(handles,'Positive Nucleus Data',[1 2]);
    add_to_listbox(handles,'Positive Nucleus Data 2',4);
    handles.flags(9)=1;
    set(handles.toolbar3Dplot,'Enable','on');
    set(handles.menu_3D,'Enable','on');
    set(handles.menu_visMode,'Enable','on');
    set(handles.menu_visMult,'Enable','on');
    set(handles.menu_visBinary,'Enable','on');
    set(handles.menu_visHeat,'Enable','on');
    set(handles.menu_checkOverlap,'Enable','on');
    set(handles.menu_surf,'Enable','on');
end
set(handles.popupmenu2,'Value',10);
set(handles.popupmenu4,'Value',10);


%generate lists of connected nuclear slice centers and determine if the
%nuclei represented by these connected centers is positively labeled
set(handles.statusEdit,'String','Building 3D Expression Model');drawnow;
handles.links=find_links(handles);
handles.conX=[];
handles.conY=[];
handles.conZ=[];
handles.conposlist=[];
handles.Pos=[];
handles.conposlist2=[];
handles.Pos2=[];
handles.condoublelist=[];
handles.doublePos=[];
handles.ratios=[];
handles.ratios2=[];
xyres=str2num(get(handles.xyresEdit,'String'));
zres=str2num(get(handles.zresEdit,'String'));
for N=1:length(handles.links)
        %check for user interupt
        if get(handles.stopButton,'UserData') == 1
        set(handles.statusEdit,'String','');drawnow;
        set(handles.stopButton,'UserData',0);
        update_images(hObject,handles);
        set(handles.stopButton,'Enable','off');
        return;
    end
    handles.conX=horzcat(handles.conX,mean(handles.X(handles.links{N}))...
        *xyres);
    handles.conY=horzcat(handles.conY,mean(handles.Y(handles.links{N}))...
        *xyres);
    handles.conZ=horzcat(handles.conZ,mean(handles.Z(handles.links{N}))...
        *zres);
    if sum(handles.poslist(handles.links{N}))...
            /sum(handles.nuclist(handles.links{N}))>handles.posval;
        handles.Pos=horzcat(handles.Pos,1);
        handles.conposlist=horzcat(handles.conposlist,1);
        ratio=sum(handles.poslist(handles.links{N}))...
            /sum(handles.nuclist(handles.links{N}));
        handles.ratios=horzcat(handles.ratios,ratio);
    else
        handles.Pos=horzcat(handles.Pos,0);
        handles.conposlist=horzcat(handles.conposlist,0);
        ratio=sum(handles.poslist(handles.links{N}))...
            /sum(handles.nuclist(handles.links{N}));
        handles.ratios=horzcat(handles.ratios,ratio);
    end
    if handles.double==1
        if sum(handles.poslist2(handles.links{N}))...
                /sum(handles.nuclist(handles.links{N}))>handles.posval;
            handles.Pos2=horzcat(handles.Pos2,1);
            handles.conposlist2=horzcat(handles.conposlist2,1);
            ratio=sum(handles.poslist2(handles.links{N}))...
                /sum(handles.nuclist(handles.links{N}));
            handles.ratios2=horzcat(handles.ratios2,ratio);
        else
            handles.Pos2=horzcat(handles.Pos2,0);
            handles.conposlist2=horzcat(handles.conposlist2,0);
            ratio=sum(handles.poslist2(handles.links{N}))...
                /sum(handles.nuclist(handles.links{N}));
            handles.ratios2=horzcat(handles.ratios2,ratio);
        end
    end
end
if handles.double==1
    for N=1:length(handles.conposlist)
        if handles.conposlist(N)==1 && handles.conposlist2(N)==1
            handles.doublePos=horzcat(handles.doublePos,1);
        else
            handles.doublePos=horzcat(handles.doublePos,0);
        end
    end
end


guidata(hObject, handles);
fillPosNucs(hObject, handles);
set(handles.stopButton,'Enable','off');
set(handles.statusEdit,'String','');
display_table(hObject,handles);



% --- Executes on button press in FindNucButton.
function FindNucButton_Callback(hObject, eventdata, handles)
%use a watershed segmentation followed by object size check to identify nuclei in each
%2D image slice
handles.L=handles.nucstack*0;
D=handles.nucstack*0;
handles.W=handles.nucstack*0;
Lsize=size(handles.L,3);
set(handles.stopButton,'Enable','on');
for N=1:Lsize
    %check for user interupt
	if get(handles.stopButton,'UserData') == 1
		set(handles.statusEdit,'String','');drawnow;
        set(handles.stopButton,'UserData',0);
        update_images(hObject,handles);
        set(handles.stopButton,'Enable','off');
		return;
	end
    set(handles.statusEdit,'String',sprintf('Computing Distance Image: Slice %g of %g'...
       ,N,Lsize));drawnow;
    tmp=handles.nucopenstack(:,:,N);
    D(:,:,N)=bwdist(~imfill(tmp,'holes'));
    D(:,:,N)=-D(:,:,N);
    Dtmp=D(:,:,N);
    Dtmp(~tmp)=-Inf;
    D(:,:,N)=medfilt2(Dtmp,[5 5]);
    set(handles.statusEdit,'String',sprintf('Computing Watershed Image: Slice %g of %g'...
       ,N,Lsize));drawnow;
    handles.W(:,:,N)=watershed(D(:,:,N));
    set(handles.statusEdit,'String',sprintf('Labeling Nuclei: Slice %g of %g'...
       ,N,Lsize));drawnow;
    Ltmp=bwlabel(handles.W(:,:,N)>1);
    set(handles.statusEdit,'String',sprintf('Checking Nuclei: Slice %g of %g'...
       ,N,Lsize));drawnow;
    Ltmp=nuc_check(handles,Ltmp,N);
    %Ltmp(~tmp)=1;
    handles.L(:,:,N)=Ltmp;
    axes(handles.axes3);imagesc(Ltmp>0);drawnow;
end
set(handles.stopButton,'Enable','off');
handles.D=D;
handles.X=[];
handles.Y=[];
handles.Z=[];
[handles.X,handles.Y,handles.Z]=get_centroids(hObject,handles);

set(handles.statusEdit,'String','');drawnow;

handles.currentstack1=handles.L>0;
set(handles.FindPosNucButton,'Enable','on');
if handles.flags(8)==0
    add_to_listbox(handles,'Segmented Nucleus Data',[1 2 4]);
    handles.flags(8)=1;
end
set(handles.popupmenu1,'Value',9);
guidata(hObject, handles);
update_images(hObject,handles);


function [X,Y,Z]=get_centroids(hObject,handles)
%compute the centroids of all nuclei in 3D space
L=handles.L;
X=[];
Y=[];
Z=[];
Lsize=size(L,3);
set(handles.stopButton,'Enable','on');
for N=1:Lsize
        %check for user interupt
        if get(handles.stopButton,'UserData') == 1
            set(handles.statusEdit,'String','');drawnow;
            set(handles.stopButton,'UserData',0);
            update_images(hObject,handles);
            set(handles.stopButton,'Enable','off');
            return;
        end
    set(handles.statusEdit,'String',sprintf('Getting Centroids: slice %g of %g'...
                                                                                     ,N,Lsize));drawnow;    
    props=regionprops(L(:,:,N));
    for M=1:length(props)
        tmp=props(M).Centroid;
        X=horzcat(X,tmp(1));
        Y=horzcat(Y,tmp(2));
    end
    Z=horzcat(Z,ones(1,length(props))*N);
end
set(handles.stopButton,'Enable','off');
set(handles.statusEdit,'String','');drawnow;

function links=find_links(handles)
%find the list of indices of linked pixels across each nucleus
links={};
refs=1:length(handles.X);
dist_thresh=get(handles.DistThreshEdit,'String');
xyres=str2num(get(handles.xyresEdit,'String'));
zres=str2num(get(handles.zresEdit,'String'));
set(handles.stopButton,'Enable','on');
while numel(handles.X)>0
        %check for user interupt
        if get(handles.stopButton,'UserData') == 1
            set(handles.statusEdit,'String','');drawnow;
            set(handles.stopButton,'UserData',0);
            update_images(hObject,handles);
            set(handles.stopButton,'Enable','off');
            return;
        end
        eudist=(sqrt(((handles.X-handles.X(1))*xyres).^2+...
        ((handles.Y-handles.Y(1))*xyres).^2+...
            ((handles.Z-handles.Z(1))*zres).^2));
        [found,eudist]=pop(eudist,sprintf('<%s',num2str(dist_thresh)));
            links=horzcat(links,refs(found));
            refs(found)=[];
            handles.X(found)=[];
            handles.Y(found)=[];
            handles.Z(found)=[];
end
set(handles.stopButton,'Enable','off');
set(handles.menu_CheckCenters,'Enable','on');

function display_table(hObject,handles)
%display summary table of nucleus data
if handles.double==0
    f=figure('Position',[300 300 450 270]);
    cnames = {'X','Y','Z','Expression'}; 
    dat=horzcat(handles.conX',handles.conY',handles.conZ',handles.Pos');
    uitable('Data',dat,'ColumnName',cnames,... 
                'Parent',f,'Position',[20 20 400 200]);

    cnames={'# Found','# Positive','%Positive'};
    dat=horzcat(length(handles.conX),sum(handles.Pos),...
        sum(handles.Pos)/length(handles.conX)*100);
    uitable('Data',dat,'ColumnName',cnames,... 
                'Parent',f,'Position',[20 220 265 40]);
elseif handles.double==1
    f=figure('Position',[300 300 600 270]);
    cnames = {'X','Y','Z','Expression 1', 'Expression 2','Double Label'}; 
    dat=horzcat(handles.conX',handles.conY',handles.conZ',handles.Pos'...
        ,handles.Pos2',handles.doublePos');
    uitable('Data',dat,'ColumnName',cnames,... 
                'Parent',f,'Position',[20 20 510 200]);

    cnames={'# Found','# Positive 1','%Positive 1'...
        ,'# Positive 2','%Positive 2','# Double Pos', '%Double Pos'};
    dat=horzcat(length(handles.conX),sum(handles.Pos),...
        sum(handles.Pos)/length(handles.conX)*100,sum(handles.Pos2),...
        sum(handles.Pos2)/length(handles.conX)*100,...
        sum(handles.doublePos),sum(handles.doublePos)/length(handles.conX)*100);
    uitable('Data',dat,'ColumnName',cnames,... 
                'Parent',f,'Position',[20 220 570 40]);
end



% --- Executes on button press in FISHThreshButton.
function FISHThreshButton_Callback(hObject, eventdata, handles)
%threshold the image stack in FISHStack using the user suplied cutoff
set(handles.statusEdit,'String','Thresholding FISH Stack');drawnow;
handles.thresh=str2num(get(handles.FISHThreshEdit,'String'));
handles.FISHthreshstack=handles.FISHstack>handles.thresh;
handles.currentstack2=handles.FISHthreshstack;
if handles.double==0
    set(handles.OpenNucButton,'Enable','on');
elseif handles.double==1
    set(handles.FISHThresh2Button,'Enable','on');
end
if handles.flags(4)==0
    add_to_listbox(handles,'Thresholded FISH Data',[1 2]);
    handles.flags(4)=1;
end
set(handles.popupmenu2,'Value',5);
guidata(hObject, handles);
update_images(hObject,handles);
set(handles.statusEdit,'String','');drawnow;



function FISHThreshEdit_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function FISHThreshEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenFISHButton.
function OpenFISHButton_Callback(hObject, eventdata, handles)
%open the stack in FISHThreshStack with the user suplied value in
%for the size of the circular structuring element
open_val=str2double(get(handles.FISHOpenEdit,'String'));
res=str2double(get(handles.xyresEdit,'String'));
S_size=round(open_val/res);
set(handles.statusEdit,'String','Opening FISH Stack');drawnow;
handles.s=strel('disk',S_size);
handles.FISHopenstack=imopen(handles.FISHthreshstack,handles.s);
handles.currentstack2=handles.FISHopenstack;
set(handles.DilateFISHButton,'Enable','on');
set(handles.statusEdit,'String','');drawnow;
if handles.flags(6)==0
    add_to_listbox(handles,'Opened FISH Data',[1 2]);
    handles.flags(6)=1;
end
set(handles.popupmenu2,'Value',7);
guidata(hObject, handles);
update_images(hObject,handles);


% --- Executes on button press in DilateFISHButton.
%dilate the FISH data using a user specified size of circular
%structuring element
function DilateFISHButton_Callback(hObject, eventdata, handles)
dilate_val=str2double(get(handles.FISHDilateEdit,'String'));
res=str2double(get(handles.xyresEdit,'String'));
S_size=round(dilate_val/res);
set(handles.statusEdit,'String','Dilating FISH Stack');drawnow;
handles.s=strel('disk',S_size);
handles.FISHdilatestack=imdilate(handles.FISHopenstack,handles.s);
handles.currentstack2=handles.FISHdilatestack;
set(handles.statusEdit,'String','');drawnow;
if handles.double==0
    set(handles.FindNucButton,'Enable','on');
elseif handles.double==1
    set(handles.OpenFISH2Button,'Enable','on');
end
if handles.flags(7)==0
    add_to_listbox(handles,'Dilated FISH Data',[1 2]);
    handles.flags(7)=1;
end
set(handles.popupmenu2,'Value',8);
guidata(hObject, handles);
update_images(hObject,handles);



function FISHDilateEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function FISHDilateEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FISHOpenEdit_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function FISHOpenEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DistThreshEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function DistThreshEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xyresEdit_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function xyresEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zresEdit_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function zresEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
%change the active stack for currentstack1
switch get(handles.popupmenu1,'Value')
    case 1
        handles.currentstack1=handles.blank;
    case 2
        handles.currentstack1=handles.nucstack;
    case 3
        handles.currentstack1=handles.FISHstack;
    case 4
        handles.currentstack1=handles.threshstack;
    case 5
        handles.currentstack1=handles.FISHthreshstack;
    case 6
        handles.currentstack1=handles.nucopenstack;
    case 7
        handles.currentstack1=handles.FISHopenstack;
    case 8
        handles.currentstack1=handles.FISHdilatestack;
    case 9
        handles.currentstack1=handles.W>1;
    case 10
        handles.currentstack1=handles.posstack;
end
guidata(hObject, handles);
update_images(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
%change the active stack for currentstack2
switch get(handles.popupmenu2,'Value')
    case 1
        handles.currentstack2=handles.blank;
    case 2
        handles.currentstack2=handles.nucstack;
    case 3
        handles.currentstack2=handles.FISHstack;
    case 4
        handles.currentstack2=handles.threshstack;
    case 5
        handles.currentstack2=handles.FISHthreshstack;
    case 6
        handles.currentstack2=handles.nucopenstack;
    case 7
        handles.currentstack2=handles.FISHopenstack;
    case 8
        handles.currentstack2=handles.FISHdilatestack;
    case 9
        handles.currentstack2=handles.W>1;
    case 10
        handles.currentstack2=handles.posstack;
end
guidata(hObject, handles);
update_images(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
update_images(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function add_to_listbox(handles,input_string,IDs)
%append new menu items to list boxes
for ii=1:length(IDs)
    switch IDs(ii)
        case 1
            cell1=get(handles.popupmenu1,'String');
            cell1{end+1}=input_string;
            set(handles.popupmenu1,'String',cell1);
        case 2
            cell2=get(handles.popupmenu2,'String');
            cell2{end+1}=input_string;
            set(handles.popupmenu2,'String',cell2);
        case 4
            cell4=get(handles.popupmenu4,'String');
            cell4{end+1}=input_string;
            set(handles.popupmenu4,'String',cell4);
    end
end

function out=nuc_check(handles,Ltmp,slice)
%check to see if the size of binarized objects is reasonable given the xy 
%resolution 
flag=1;
xyres=str2num(get(handles.xyresEdit,'String'));
while flag==1
    Ltmp=bwlabel(Ltmp>0);
    nuc_stats=regionprops(Ltmp,'BoundingBox');
    flag=0;
    for N=1:length(nuc_stats)
        x=round(nuc_stats(N).BoundingBox);
        if x(3)>10/xyres || x(4)>10/xyres
            try
                if x(3)/x(4)<=.9
                    tmpim=handles.nucstack(x(2):x(2)+x(4),x(1):x(1)+x(3),slice);
                    tmpline=sum(tmpim,2);
                    tmpmin=find(tmpline==min(tmpline(5:length(tmpline)-5)));
                    tmpim=Ltmp(x(2):x(2)+x(4),x(1):x(1)+x(3));
                    tmpim(tmpmin,:)=0;
                    Ltmp(x(2):x(2)+x(4),x(1):x(1)+x(3))=tmpim;
                    axes(handles.axes3);imagesc(Ltmp);drawnow;
                    flag=1;
                end
                if x(3)/x(4)>=1.11
                    tmpim=handles.nucstack(x(2):x(2)+x(4),x(1):x(1)+x(3),slice);
                    tmpline=sum(tmpim,1);
                    tmpmin=find(tmpline==min(tmpline(5:length(tmpline)-5)));
                    tmpim=Ltmp(x(2):x(2)+x(4),x(1):x(1)+x(3));
                    tmpim(:,tmpmin)=0;
                    Ltmp(x(2):x(2)+x(4),x(1):x(1)+x(3))=tmpim;
                    axes(handles.axes3);imagesc(Ltmp);drawnow;
                    flag=1;
                end
            end
        end
    end
end
out=bwlabel(Ltmp>0);


% --------------------------------------------------------------------
function menu_SaveSet_Callback(hObject, eventdata, handles)
%save the current process settings to file
xyres=get(handles.xyresEdit,'String');
zres=get(handles.zresEdit,'String');
nucthresh=get(handles.NucThreshEdit,'String');
FISHthresh=get(handles.FISHThreshEdit,'String');
FISHthresh2=get(handles.FISHThreshEdit2,'String');
nucopen=get(handles.NucOpenEdit,'String');
FISHopen=get(handles.FISHOpenEdit,'String');
FISHopen2=get(handles.FISHOpenEdit2,'String');
FISHdilate=get(handles.FISHDilateEdit,'String');
FISHdilate2=get(handles.FISHDilateEdit2,'String');
overlap=get(handles.overlapEdit,'String');
distthresh=get(handles.DistThreshEdit,'String');

[file,path]=uiputfile('.mat','Save Preferences',...
    sprintf('GeneExpressMapPrefs%s.mat',date));
save(sprintf('%s%s',path,file),'xyres','zres','nucthresh'...
    ,'FISHthresh','nucopen','FISHopen','FISHdilate'...
    ,'overlap','distthresh','FISHthresh2','FISHopen2'...
    ,'FISHdilate2');


% --------------------------------------------------------------------
function menu_LoadSet_Callback(hObject, eventdata, handles)
%load process settings from a file
[file,path]=uigetfile('.mat','Select Preferences File');
load(sprintf('%s%s',path,file));
set(handles.xyresEdit,'String',xyres);
set(handles.zresEdit,'String',zres);
set(handles.NucThreshEdit,'String',nucthresh);
set(handles.FISHThreshEdit,'String',FISHthresh);
set(handles.FISHThreshEdit2,'String',FISHthresh2);
set(handles.NucOpenEdit,'String',nucopen);
set(handles.FISHOpenEdit,'String',FISHopen);
set(handles.FISHOpenEdit2,'String',FISHopen2);
set(handles.FISHDilateEdit,'String',FISHdilate);
set(handles.FISHDilateEdit2,'String',FISHdilate2);
set(handles.overlapEdit,'String',overlap);
set(handles.DistThreshEdit,'String',distthresh);



% --------------------------------------------------------------------
function menu_Tools_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function menu_Mline_Callback(hObject, eventdata, handles)
% get the xy_resolution
%update_images;
xyres=str2num(get(handles.xyresEdit,'String'));

% Convert XData and YData to microns using the xyres value.
XDataInMicrons = handles.XData*xyres; 
YDataInMicrons = handles.YData*xyres;


% Set XData and YData of images to microns.    
set(handles.hImg1,'XData',XDataInMicrons,'YData',YDataInMicrons);    
set(handles.axes1,'XLim',XDataInMicrons,'YLim',YDataInMicrons);

set(handles.hImg2,'XData',XDataInMicrons,'YData',YDataInMicrons);    
set(handles.axes2,'XLim',XDataInMicrons,'YLim',YDataInMicrons);

set(handles.hImg3,'XData',XDataInMicrons,'YData',YDataInMicrons);    
set(handles.axes3,'XLim',XDataInMicrons,'YLim',YDataInMicrons);

set(handles.hImg4,'XData',XDataInMicrons,'YData',YDataInMicrons);    
set(handles.axes4,'XLim',XDataInMicrons,'YLim',YDataInMicrons);

%place an instance of imdistline on axes1 
axes(handles.axes3);imdistline;




% --------------------------------------------------------------------
function menu_CheckCenters_Callback(hObject, eventdata, handles)
%max intensity projection of raw nucleus data
xyres=str2num(get(handles.xyresEdit,'String'));
zres=str2num(get(handles.zresEdit,'String'));
maxProj=max(handles.nucstack,[],3);
figure;imagesc(maxProj);colormap(gray);
title('Max projection with nucleus centers');hold on;
scatter(handles.conX/xyres,handles.conY/xyres,'r+');

%3D version with labeled nucleus spots
sizes=size(handles.nucstack);
RGBholder=zeros(sizes(1),sizes(2),3,sizes(3));
RGBholder(:,:,1,:)=handles.nucstack;
RGBholder(:,:,2,:)=handles.nucstack;
RGBholder(:,:,3,:)=handles.nucstack;
cross_size=16;
for ii=1:length(handles.conX)
    X=round(handles.conX(ii)/xyres);
    Y=round(handles.conY(ii)/xyres);
    Z=round(handles.conZ(ii)/zres);
    try
        RGBholder(Y-round(cross_size/2):Y+round(cross_size/2),X-1:X+1,1,Z)=1;
        RGBholder(Y-1:Y+1,X-round(cross_size/2):X+round(cross_size/2),1,Z)=1;
        RGBholder(Y-round(cross_size/2):Y+round(cross_size/2),X-1:X+1,2,Z)=0;
        RGBholder(Y-1:Y+1,X-round(cross_size/2):X+round(cross_size/2),2,Z)=0;
        RGBholder(Y-round(cross_size/2):Y+round(cross_size/2),X-1:X+1,3,Z)=0;
        RGBholder(Y-1:Y+1,X-round(cross_size/2):X+round(cross_size/2),3,Z)=0;
    catch
        disp('some Nuclear centers were too close to the image edge to mark properly in 3D')
        RGBholder(Y,X,1,Z)=1;
        RGBholder(Y,X,2,Z)=0;
        RGBholder(Y,X,3,Z)=0;
    end
end
stackviewRGB(RGBholder);




% --------------------------------------------------------------------
function toolbarsavepref_ClickedCallback(hObject, eventdata, handles)
xyres=get(handles.xyresEdit,'String');
zres=get(handles.zresEdit,'String');
nucthresh=get(handles.NucThreshEdit,'String');
FISHthresh=get(handles.FISHThreshEdit,'String');
nucopen=get(handles.NucOpenEdit,'String');
FISHopen=get(handles.FISHOpenEdit,'String');
FISHdilate=get(handles.FISHDilateEdit,'String');
overlap=get(handles.overlapEdit,'String');
distthresh=get(handles.DistThreshEdit,'String');

[file,path]=uiputfile('.mat','Save Preferences',...
    sprintf('Embryo3DPref%s.mat',date));
save(sprintf('%s%s',path,file),'xyres','zres','nucthresh'...
    ,'FISHthresh','nucopen','FISHopen','FISHdilate'...
    ,'overlap','distthresh');



% --------------------------------------------------------------------
function toolbarloadpref_ClickedCallback(hObject, eventdata, handles)
[file,path]=uigetfile('.mat','Select Preferences File');
load(sprintf('%s%s',path,file));
set(handles.xyresEdit,'String',xyres);
set(handles.zresEdit,'String',zres);
set(handles.NucThreshEdit,'String',nucthresh);
set(handles.FISHThreshEdit,'String',FISHthresh);
set(handles.NucOpenEdit,'String',nucopen);
set(handles.FISHOpenEdit,'String',FISHopen);
set(handles.FISHDilateEdit,'String',FISHdilate);
set(handles.overlapEdit,'String',overlap);
set(handles.DistThreshEdit,'String',distthresh);



% --------------------------------------------------------------------
function toolbar3Dplot_ClickedCallback(hObject, eventdata, handles)
display3D(handles);



% --------------------------------------------------------------------
function menu_textExport_Callback(hObject, eventdata, handles)
upath=uigetdir('~/Desktop');
negx=[];
negy=[];
negz=[];
posx=[];
posy=[];
posz=[];
for N=1:length(handles.Pos)
    if handles.Pos(N)==1
        posx=horzcat(posx,handles.conX(N));
        posy=horzcat(posy,handles.conY(N));
        posz=horzcat(posz,handles.conZ(N));
    else
        negx=horzcat(negx,handles.conX(N));
        negy=horzcat(negy,handles.conY(N));
        negz=horzcat(negz,handles.conZ(N));
    end
end
posx=posx-mean(posx);
posy=posy-mean(posy);
posz=posz-mean(posz);
negx=negx-mean(negx);
negy=negy-mean(negy);
negz=negz-mean(negz);

f=fopen([upath '/neg.txt'],'w');
fprintf(f,'[');
for ii=1:length(negx)-1
    fprintf(f,sprintf('[%g,%g,%g]',negx(ii),negy(ii),negz(ii)));
    fprintf(f,',');
end
fprintf(f,sprintf('[%g,%g,%g]]\n',negx(ii+1),negy(ii+1),negz(ii+1)));
fclose(f);
f=fopen([upath '/pos.txt'],'w');
fprintf(f,'[');
for ii=1:length(posx)-1
    fprintf(f,sprintf('[%g,%g,%g]',posx(ii),posy(ii),posz(ii)));
    fprintf(f,',');
end
fprintf(f,sprintf('[%g,%g,%g]]\n',posx(ii+1),posy(ii+1),posz(ii+1)));
fclose(f);



% --------------------------------------------------------------------
function toolbarMline_ClickedCallback(hObject, eventdata, handles)
menu_Mline_Callback(hObject, eventdata, handles)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
switch get(handles.popupmenu4,'Value')
    case 1
        handles.currentstack3=handles.blank;
    case 2
        handles.currentstack3=handles.nucstack;
    case 3
        handles.currentstack3=handles.FISHstack2;
    case 4
        handles.currentstack3=handles.threshstack;
    case 5
        handles.currentstack3=handles.FISHthreshstack2;
    case 6
        handles.currentstack3=handles.nucopenstack;
    case 7
        handles.currentstack3=handles.FISHopenstack2;
    case 8
        handles.currentstack3=handles.FISHdilatestack2;
    case 9
        handles.currentstack3=handles.W>1;
    case 10
        handles.currentstack3=handles.posstack2;
end
guidata(hObject, handles);
update_images(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenFISH2Button.
function OpenFISH2Button_Callback(hObject, eventdata, handles)
open_val=str2double(get(handles.FISHOpenEdit2,'String'));
res=str2double(get(handles.xyresEdit,'String'));
S_size=round(open_val/res);
set(handles.statusEdit,'String','Opening FISH Stack');drawnow;
handles.s=strel('disk',S_size);
handles.FISHopenstack2=imopen(handles.FISHthreshstack2,handles.s);
handles.currentstack3=handles.FISHopenstack2;
set(handles.DilateFISH2Button,'Enable','on');
set(handles.statusEdit,'String','');drawnow;
if handles.flags(11)==0
    add_to_listbox(handles,'Opened FISH Data 2',4);
    handles.flags(11)=1;
end
set(handles.popupmenu4,'Value',7);
guidata(hObject, handles);
update_images(hObject,handles);
% hObject    handle to OpenFISH2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DilateFISH2Button.
function DilateFISH2Button_Callback(hObject, eventdata, handles)
dilate_val=str2double(get(handles.FISHDilateEdit2,'String'));
res=str2double(get(handles.xyresEdit,'String'));
S_size=round(dilate_val/res);
set(handles.statusEdit,'String','Dilating FISH Stack 2');drawnow;
handles.s=strel('disk',S_size);
handles.FISHdilatestack2=imdilate(handles.FISHopenstack2,handles.s);
handles.currentstack3=handles.FISHdilatestack2;
set(handles.statusEdit,'String','');drawnow;
set(handles.FindNucButton,'Enable','on');
if handles.flags(12)==0
    add_to_listbox(handles,'Dilated FISH Data 2',4);
    handles.flags(12)=1;
end
set(handles.popupmenu4,'Value',8);
guidata(hObject, handles);
update_images(hObject,handles);
% hObject    handle to DilateFISH2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function FISHDilateEdit2_Callback(hObject, eventdata, handles)
% hObject    handle to FISHDilateEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FISHDilateEdit2 as text
%        str2double(get(hObject,'String')) returns contents of FISHDilateEdit2 as a double


% --- Executes during object creation, after setting all properties.
function FISHDilateEdit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FISHDilateEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FISHOpenEdit2_Callback(hObject, eventdata, handles)
% hObject    handle to FISHOpenEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FISHOpenEdit2 as text
%        str2double(get(hObject,'String')) returns contents of FISHOpenEdit2 as a double


% --- Executes during object creation, after setting all properties.
function FISHOpenEdit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FISHOpenEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FISHThresh2Button.
function FISHThresh2Button_Callback(hObject, eventdata, handles)
set(handles.statusEdit,'String','Thresholding FISH 2 Stack');drawnow;
handles.thresh=str2num(get(handles.FISHThreshEdit2,'String'));
handles.FISHthreshstack2=handles.FISHstack2>handles.thresh;
handles.currentstack3=handles.FISHthreshstack2;
set(handles.OpenNucButton,'Enable','on');
if handles.flags(10)==0
    add_to_listbox(handles,'Thresholded FISH 2 Data',4);
    handles.flags(10)=1;
end
set(handles.popupmenu4,'Value',5);
guidata(hObject, handles);
update_images(hObject,handles);
set(handles.statusEdit,'String','');drawnow;
% hObject    handle to FISHThresh2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function FISHThreshEdit2_Callback(hObject, eventdata, handles)
% hObject    handle to FISHThreshEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FISHThreshEdit2 as text
%        str2double(get(hObject,'String')) returns contents of FISHThreshEdit2 as a double


% --- Executes during object creation, after setting all properties.
function FISHThreshEdit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FISHThreshEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function write_python_nucs(name,cx,cy,cz)
basepath=pwd;
f=fopen([basepath '/Embryo3DViewer.app/Contents/Resources/' name],'w');
fprintf(f,'[');
for ii=1:length(cx)-1
    fprintf(f,sprintf('[%g,%g,%g]',cx(ii),cy(ii),cz(ii)));
    fprintf(f,',');
end
fprintf(f,sprintf('[%g,%g,%g]]\n',cx(ii+1),cy(ii+1),cz(ii+1)));
fclose(f);

function remove_python_nucs(name)
basepath=pwd;
call=['rm ' basepath '/Embryo3DViewer.app/Contents/Resources/' name];
system(call);

function thresh=getThresh(in)
[bi,thresh]=MCTstack(in);


% --------------------------------------------------------------------
function menu_3D_Callback(hObject, eventdata, handles)
display3D(handles);

function display3D(handles)
%split into pos and neg nuclei
negx=[];
negy=[];
negz=[];
posx=[];
posy=[];
posz=[];
posx2=[];
posy2=[];
posz2=[];
posxbi=[];
posybi=[];
poszbi=[];
if handles.double==1
    for N=1:length(handles.Pos)
        if handles.Pos(N)==1 && handles.Pos2(N)==1
            posxbi=horzcat(posxbi,handles.conX(N));
            posybi=horzcat(posybi,handles.conY(N));
            poszbi=horzcat(poszbi,handles.conZ(N));
        elseif handles.Pos(N)==1
            posx=horzcat(posx,handles.conX(N));
            posy=horzcat(posy,handles.conY(N));
            posz=horzcat(posz,handles.conZ(N));
        elseif handles.Pos2(N)==1
            posx2=horzcat(posx2,handles.conX(N));
            posy2=horzcat(posy2,handles.conY(N));
            posz2=horzcat(posz2,handles.conZ(N));
        else
            negx=horzcat(negx,handles.conX(N));
            negy=horzcat(negy,handles.conY(N));
            negz=horzcat(negz,handles.conZ(N));
        end
    end
else
    for N=1:length(handles.Pos)
        if handles.Pos(N)==1
            posx=horzcat(posx,handles.conX(N));
            posy=horzcat(posy,handles.conY(N));
            posz=horzcat(posz,handles.conZ(N));
        else
            negx=horzcat(negx,handles.conX(N));
            negy=horzcat(negy,handles.conY(N));
            negz=horzcat(negz,handles.conZ(N));
        end
    end
end
meanX=mean(handles.conX);
meanY=mean(handles.conY);
meanZ=mean(handles.conZ);
posxbi=posxbi-meanX;
posybi=posybi-meanY;
poszbi=poszbi-meanZ;
posx=posx-meanX;
posy=posy-meanY;
posz=posz-meanZ;
posx2=posx2-meanX;
posy2=posy2-meanY;
posz2=posz2-meanZ;
negx=negx-meanX;
negy=negy-meanY;
negz=negz-meanZ;

%use if Embryo3DViewer is installed as well.  Only available for mac%
basepath=pwd;
pathtest=[basepath '/Embryo3DViewer.app/Contents/Resources/'];
if isdir(pathtest)==1
    disp('Launching python GeneExpressMap viewer')
    remove_python_nucs('neg.txt');
    remove_python_nucs('pos.txt');
    remove_python_nucs('posbi.txt');
    remove_python_nucs('pos2.txt');
    if handles.double==1
        write_python_nucs('neg.txt',negx,negy,negz);
        write_python_nucs('pos.txt',posx,posy,posz);
        write_python_nucs('posbi.txt',posxbi,posybi,poszbi);
        write_python_nucs('pos2.txt',posx2,posy2,posz2);
    else
        write_python_nucs('neg.txt',negx,negy,negz);
        write_python_nucs('pos.txt',posx,posy,posz);

    end
    call=['open ' pwd '/Embryo3DViewer.app'];
    system(call);
else
    disp('Python GeneExpressMap viewer not available. Using MATLAB internal instead')
    h=figure;
    set(h,'Color','k');
    set(h,'Units','Pixels');
    title('Nucleus Center Locations');
    scatter3(posx,posy,posz,100,'g','filled');hold on;
    if handles.double==1
        scatter3(posxbi,posybi,poszbi,100,'y','filled');hold on;
        scatter3(posx2,posy2,posz2,100,'r','filled');hold on;
    end
    scatter3(negx,negy,negz,100,'b','filled');hold on;
    axis off;axis equal;
end
%use if Embryo3DViewer is installed as well.  Only available for mac%

function outVal=heatmapLookup(ratiosNorm,val)
%calculate the value to put in a color map from the relation between
%In and Out
in=.9:-.1:0;
out=1:-.1:.1;
ratiosNormMax=max(ratiosNorm);
for ii=1:length(in)
    if val>ratiosNormMax*in(ii)
        outVal=out(ii);
        return
    else
        outVal=0;%ensure that we always return something
    end
end


function fillPosNucs(hObject,handles)
%fill in positive nuclei posstack
tmpStack1=handles.posstack*0;
tmpStack2=handles.posstack*0;
ratiosNorm=handles.ratios/max(handles.ratios);
for ii=1:length(handles.links)
    if handles.Pos(ii)==1
        for jj=1:length(handles.links{ii})
            currentX=round(handles.X(handles.links{ii}(jj)));
            currentY=round(handles.Y(handles.links{ii}(jj)));
            currentZ=handles.Z(handles.links{ii}(jj));
            try
                found=find(handles.L(:,:,currentZ)==handles.L(currentY,currentX,currentZ));
            end;
            tmp=handles.L(:,:,currentZ)*0;
            if length(found)<size(handles.posstack,1)^2/2
                if handles.LUTFlag==0 || handles.LUTFlag==1
                    tmp(found)=1;
                elseif handles.LUTFlag==2
                    tmp(found)=heatmapLookup(ratiosNorm,ratiosNorm(ii));
                end
            end
            tmpStack1(:,:,currentZ)=tmpStack1(:,:,currentZ)+tmp;
        end
    end
end

%fill in positive nuclei for posstack2
ratiosNorm2=handles.ratios2/max(handles.ratios2);
if handles.double==1
    for ii=1:length(handles.links)
        if handles.Pos2(ii)==1
            for jj=1:length(handles.links{ii})
                currentX=round(handles.X(handles.links{ii}(jj)));
                currentY=round(handles.Y(handles.links{ii}(jj)));
                currentZ=handles.Z(handles.links{ii}(jj));
                try
                    found=find(handles.L(:,:,currentZ)==handles.L(currentY,currentX,currentZ));
                end;
                tmp=handles.L(:,:,currentZ)*0;
                if length(found)<size(handles.posstack,1)^2/2
                    if handles.LUTFlag==0 ||handles.LUTFlag==1
                        tmp(found)=1;
                    elseif handles.LUTFlag==2
                        tmp(found)=heatmapLookup(ratiosNorm2,ratiosNorm2(ii));
                    end
                end
                tmpStack2(:,:,currentZ)=tmpStack2(:,:,currentZ)+tmp;
            end
        end
    end
end

handles.posstackbi=tmpStack1>0;
if handles.LUTFlag==0
    handles.posstack=tmpStack1.*handles.nucstack;
elseif handles.LUTFlag==1
    handles.posstack=handles.posstackbi;
else
    handles.posstack=tmpStack1;
end
if handles.double==1
    handles.posstackbi2=tmpStack2>0;
    if handles.LUTFlag==0
        handles.posstack2=tmpStack2.*handles.nucstack;
    elseif handles.LUTFlag==1
        handles.posstack2=tmpStack2>0;
    else
        handles.posstack2=tmpStack2;
    end
end

handles.currentstack2=handles.posstack;
if handles.double==1
    handles.currentstack3=handles.posstack2;
end
set(handles.statusEdit,'String','');
update_images(hObject,handles);

% --------------------------------------------------------------------
function menu_visMult_Callback(hObject, eventdata, handles)
handles.LUTFlag=0;
guidata(hObject, handles);
fillPosNucs(hObject,handles)


% --------------------------------------------------------------------
function menu_visBinary_Callback(hObject, eventdata, handles)
handles.LUTFlag=1;
guidata(hObject, handles);
fillPosNucs(hObject,handles)


% --------------------------------------------------------------------
function menu_visHeat_Callback(hObject, eventdata, handles)
handles.LUTFlag=2;
guidata(hObject, handles);
fillPosNucs(hObject,handles)


% --------------------------------------------------------------------
function menu_visMode_Callback(hObject, eventdata, handles)
%this is an empty call back needed for nested menus

% --------------------------------------------------------------------
function menu_checkOverlap_Callback(hObject, eventdata, handles)
posval=str2double(get(handles.overlapEdit,'String'));
figure;
threshline=ones(1,length(handles.ratios2))*0+posval;
line(1:length(handles.ratios2),threshline,'LineWidth',5,'Color',[0 0 0]);
hold on;
line([1;1],[0;handles.ratios(1)*100],'LineWidth',4,'Color',[0 1 0]);
line([1;1],[0;handles.ratios2(1)*100],'LineWidth',4,'Color',[1 0 0]);
legend('Threshold','FISH1','FISH2');
for ii=2:length(handles.ratios)
	line([ii;ii],[0;handles.ratios(ii)*100],'LineWidth',4,'Color',[0 .5 0]);
end
for ii=2:length(handles.ratios)
	line([ii;ii],[0;handles.ratios2(ii)*100],'LineWidth',2,'Color',[.5 0 0]);
end
scatter(1:length(handles.ratios),handles.ratios*100,50,[0 1 0],'filled');
scatter(1:length(handles.ratios),handles.ratios2*100,50,[1 0 0],'filled');
line(1:length(handles.ratios2),threshline,'LineWidth',5,'Color',[0 0 0]);
hold off;
xlabel('Nucleus Number','fontsize',20,'fontweight','b')
ylabel('Percent Overlap','fontsize',20,'fontweight','b')


% --------------------------------------------------------------------
function menu_surf_Callback(hObject, eventdata, handles)
handles.xyres=str2double(get(handles.xyresEdit,'String'));
handles.zres	=str2double(get(handles.zresEdit,'String'));
GeneExpressMapSurfaceView(handles);


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
set(handles.stopButton,'UserData',1);
guidata(hObject, handles); 
