function varargout = GUI_part(varargin)
% GUI_PART MATLAB code for GUI_part.fig
%      GUI_PART, by itself, creates a new GUI_PART or raises the existing
%      singleton*.
%
%      H = GUI_PART returns the handle to a new GUI_PART or the handle to
%      the existing singleton*.
%
%      GUI_PART('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PART.M with the given input arguments.
%
%      GUI_PART('Property','Value',...) creates a new GUI_PART or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_part_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_part_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_part

% Last Modified by GUIDE v2.5 16-Apr-2014 18:09:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_part_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_part_OutputFcn, ...
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


% --- Executes just before GUI_part is made visible.
function GUI_part_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_part (see VARARGIN)

% Choose default command line output for GUI_part
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_part wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_part_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in UI_Load.
function UI_Load_Callback(hObject, eventdata, handles)
% hObject    handle to UI_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global IMG;
[filename, pathname] =  uigetfile({'*.tif'; '*.jpg'; '*.bmp';'*.*'},'File Selector');
if isequal(filename,0)
    msgbox(sprintf('Please select image :)'),'No Image Selected','warn');
    return;
end

IMG =imread(filename);
axes(handles.UI_origin);
imshow(IMG);



% --- Executes on button press in UI_process.
function UI_process_Callback(hObject, eventdata, handles)
% hObject    handle to UI_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMG;

%generate detected image and tag image
[Img, Img_tag] = GeneratorCore(IMG); %use Hough transform to detect rain and tag area

axes(handles.UI_hough);
imshow(Img);
axes(handles.UI_mask);
imshow(Img_tag);

mu = 20;
[xlen,ylen, ~] =size(Img_tag);
IMG2= imresize(IMG,[max(xlen,ylen),max(xlen,ylen)]);
for i = 1:3
    IMGt = IMG2(:,:,i)
    Origin_resize = double(imresize(IMGt,[max(size(IMGt)),max(size(IMGt))]));
    [x,y] = size(Origin_resize);
    Structure_img(:,:,i) = uint8(reshape(SB_ATV(Origin_resize, mu), x, y)); %use PDE to get structure information
    Texture_img(:,:,i) = uint8(Origin_resize-double(Structure_img(:,:,i)));
end
% figure;subplot(1,2,1);
axes(handles.UI_PDE_low);
imshow(Structure_img);
% title('Structure Image');

% Texture_img = Origin_resize-Structure_img;
% subplot(1,2,2);
axes(handles.UI_PDE_high);
imshow(Texture_img);
% title('Texture Image');

mask = imresize(Img_tag,[max(xlen,ylen),max(xlen,ylen)]);

%Use texture patch to repair image
for i = 1:3
    New_i(:,:,i)= Texture_core(double(Structure_img(:,:,i)),double(mask));
    New_i(:,:,i) = medfilt2(New_i(:,:,i),[5,5]);
end
% figure;
axes(handles.UI_final);
imshow(uint8(New_i),[0,255]);


% --- Executes on button press in UI_hough_step.
function UI_hough_step_Callback(hObject, eventdata, handles)
% hObject    handle to UI_hough_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UI_hough_step
global IMG;
if( get(hObject,'Value') == 1)
    [Img, Img_tag] = GeneratorCore(IMG); %use Hough transform to detect rain and tag area
    figure;
    subplot(1,2,1);
    imshow(Img);
    subplot(1,2,2);
    imshow(Img_tag);
end



% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
global IMG;
if( get(hObject,'Value') == 1)
    mu = 20;
    [xlen,ylen, ~] =size(IMG);
    IMG2= imresize(IMG,[max(xlen,ylen),max(xlen,ylen)]);
    for i = 1:3
        IMGt = IMG2(:,:,i)
        Origin_resize = double(imresize(IMGt,[max(size(IMGt)),max(size(IMGt))]));
        [x,y] = size(Origin_resize);
        Structure_img(:,:,i) = uint8(reshape(SB_ATV(Origin_resize, mu), x, y)); %use PDE to get structure information
        Texture_img(:,:,i) = uint8(Origin_resize-double(Structure_img(:,:,i)));
    end
    figure;
    subplot(1,2,1);
    imshow(Structure_img);
    subplot(1,2,2);
    imshow(Texture_img);
end
