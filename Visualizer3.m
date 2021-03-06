%%
clc;
% close all;
load Color_Parents;
screenSpec = get(0,'Screensize');
fig = figure('name','Visualizer v3','Toolbar','figure','position',screenSpec/1.1);
set(fig, 'renderer', 'zbuffer');
axes('position',[0.03 0.03 .85 .85]);       

plot3(0,0,0,'ok','MarkerFaceColor','g','MarkerSize',10);
Xmin = -1;  Xmax = 1;   
Ymin = -1;  Ymax = 1;                 
Zmin = 0;   Zmax = 3;
daspect([1,1,1]);
axis tight;     axis([Xmin Xmax Ymin Ymax Zmin Zmax]);  grid on;  %axis vis3d;
%% Playback UI
uipanel('Title', 'Playback panel',...
            'BackgroundColor',[.94 .94 .94],...
            'FontSize',12,...
            'Unit','normalized',...                        
            'Position', [.79 .08 .2 .45]);
pushbotton1 = uicontrol('Style','pushbutton',...
                        'String', 'Play/Replay',...
                        'FontSize',12,...
                        'FontWeight', 'bold',...
                        'Unit','normalized',...                        
                        'Position', [0.90 .23 .07 .05],...
                        'callback', 'reset2first; pauseFlag = 0; play;');
pushbotton2 = uicontrol('Style','pushbutton',...
                        'String', 'Pause',...
                        'FontSize',12,...
                        'FontWeight', 'bold',...
                        'Unit','normalized',...
                        'Position', [.81 .17 .07 .05],...
                        'callback', 'pauseFlag = 1;');  pauseFlag = 0;
pushbotton3 = uicontrol('Style','pushbutton',...
                        'String', 'Resume',...
                        'FontWeight', 'bold',...
                        'FontSize',12,...
                        'Unit','normalized',...
                        'Position', [.90 .17 .07 .05],...
                        'callback', 'pauseFlag = 0; play;');                    
pushbotton4 = uicontrol('Style','pushbutton',...
                        'String', 'Load',...
                        'FontSize',12,...
                        'FontWeight', 'bold',...
                        'Unit','normalized',...
                        'Position', [.81 .23 .07 .05],...
                        'callback', 'loadData; drawData;');
pushbotton5 = uicontrol('Style','pushbutton',...
                        'String', 'Prev',...
                        'FontSize',12,...
                        'FontWeight', 'bold',...
                        'Unit','normalized',...
                        'Position', [.81 .11 .07 .05],...
                        'callback', 'prevF');
pushbotton6 = uicontrol('Style','pushbutton',...
                        'String', 'Next',...
                        'FontSize',12,...
                        'FontWeight', 'bold',...
                        'Unit','normalized',...
                        'Position', [.90 .11 .07 .05],...
                        'callback', 'nextF');
uicontrol('Style','text',...
            'Unit','normalized',...
            'BackgroundColor',[.94 .94 .94],...
            'FontSize',10,...
            'Position',[.85 .33 .05 .02],...
            'String','Frame: ');       

edit3 = uicontrol('Style','edit',...
                    'String', '-','backgroundColor', [1 1 1],...
                    'FontSize',10,...
                    'Unit','normalized',...
                    'Position', [0.893 .325 .05 .03],'callback','f = str2double(get(edit3,''string''));');        
checkbox1 = uicontrol('Style','checkbox',...
                    'String', 'Show Skeleton',...
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.85 .45 .07 .03],...
                    'callback', 'SklFlag = get(checkbox1,''value'');  showSkl; ');     SklFlag = 0;
checkbox2 = uicontrol('Style','checkbox',...
                    'String', 'Show Cloud',...
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.85 .40 .07 .03],...
                    'callback', 'CloudFlag = get(checkbox2,''value'');  showCloud');   CloudFlag = 0;

%% IO UI
uipanel('Title', 'IO panel',...
            'BackgroundColor',[.94 .94 .94],...
            'FontSize',12,...
            'Unit','normalized',...                        
            'Position', [.02 .86 .75 .14]);

uicontrol('Style','text',...
            'Unit','normalized',...
            'BackgroundColor',[.94 .94 .94],...
            'Position',[.505 .875 .05 .02],...
            'String','First frame: ');
uicontrol('Style','text',...
            'Unit','normalized',...
            'BackgroundColor',[.94 .94 .94],...
            'Position',[.575 .875 .05 .02],...
            'String','Last frame: ');        

        
popmenu = uicontrol('Style', 'popup',...
           'String', '3|4|5|6',...
           'Unit','normalized',...         
           'Position', [.72 .94 .03 .02],...
            'Callback', 'str = get(popmenu,''string''); format = [''%.'' str(get(popmenu,''value'')) ''d''];');     format = '%.4d';
                
uicontrol('Style','text',...
            'Unit','normalized',...
            'BackgroundColor',[.94 .94 .94],...
            'Position',[.71 .96 .05 .02],...
            'String','# digit of mesh');
        
popmenu2 = uicontrol('Style', 'popup',...
           'String', '3|4|5|6',...
           'Unit','normalized',...         
           'Position', [.72 .88 .03 .02],...
            'Callback', 'str = get(popmenu2,''string''); format2 = [''%.'' str(get(popmenu2,''value'')) ''d''];');     format2 = '%.3d';
                
uicontrol('Style','text',...
            'Unit','normalized',...
            'BackgroundColor',[.94 .94 .94],...
            'Position',[.71 .90 .05 .02],...
            'String','# digit of cloud');        
                    
edit1 = uicontrol('Style','edit',...
                    'String', 'First','backgroundColor', [1 1 1],...
                    'Unit','normalized',...
                    'Position', [.545 .877 .03 .02],'callback','first = str2double(get(edit1,''string''));    f = first;  set(edit3,''string'',num2str(f))');

edit2 = uicontrol('Style','edit',...
                    'String', 'Last','backgroundColor', [1 1 1],...
                    'Unit','normalized',...
                    'Position', [.615 .877 .03 .02],'callback','last = str2double(get(edit2,''string''));');

edit4 = uicontrol('Style','edit',...
                    'String', '-','backgroundColor', [1 1 1],...
                    'Unit','normalized',...
                    'Position', [.05 .92 .2 .03],'callback','meshName_prefix = get(edit4,''string'');');    meshName_prefix = [];
uicontrol('Style','text',...
                    'Unit','normalized',...
                    'BackgroundColor',[.94 .94 .94],...
                    'FontSize',10,...
                    'Position',[.05 .952 .1 .015],...
                    'String','meshName prefix: ');

edit5 = uicontrol('Style','edit',...
                    'String', '-','backgroundColor', [1 1 1],...
                    'Unit','normalized',...
                    'Position', [.05 .865 .15 .03],'callback','meshName_suffix = get(edit5,''string'');');    meshName_suffix = [];
                
noncoloredMesh = 0;                
checkbox12 = uicontrol('Style','checkbox',...
                    'String', 'no color',...                    
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.215 .8725 .05 .015],...
                    'callback', 'noncoloredMesh = get(checkbox12,''value'');');                     
                
uicontrol('Style','text',...
                    'Unit','normalized',...
                    'FontSize',10,...
                    'backgroundColor', [.94 .94 .94],...
                    'Position',[.05 .897 .1 .015],...
                    'String','meshName suffix: ');

edit6 = uicontrol('Style','edit',...
                    'String', '-','backgroundColor', [1 1 1],...
                    'Unit','normalized',...
                    'Position', [.28 .92 .2 .03],'callback','cloudName_prefix = get(edit6,''string'');');   cloudName_prefix = [];
uicontrol('Style','text',...
                    'Unit','normalized',...
                    'FontSize',10,...
                    'BackgroundColor',[.94 .94 .94],...
                    'Position',[.28 .952 .1 .015],...
                    'String','cloudName prefix: ');
                
edit7 = uicontrol('Style','edit',...
                    'String', ' ','backgroundColor', [1 1 1],...
                    'Unit','normalized',...
                    'Position', [.28 .865 .15 .03],'callback','cloudName_suffix = get(edit7,''string'');');   cloudName_suffix = [];
uicontrol('Style','text',...
                    'Unit','normalized',...
                    'FontSize',10,...
                    'BackgroundColor',[.94 .94 .94],...
                    'Position',[.28 .897 .1 .015],...
                    'String','cloudName suffix: ');
coloredCloud = 0;                
checkbox11 = uicontrol('Style','checkbox',...
                    'String', 'color cloud',...                    
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.445 .8725 .05 .015],...
                    'callback', 'coloredCloud = get(checkbox11,''value'');');     
                
edit8 = uicontrol('Style','edit',...
                    'String', '-','backgroundColor', [1 1 1],...
                    'Unit','normalized',...
                    'Position', [.51 .92 .19 .03],'callback','jointsName_prefix = get(edit8,''string'');');
uicontrol('Style','text',...
                    'Unit','normalized',...
                    'FontSize',10,...
                    'BackgroundColor',[.94 .94 .94],...
                    'Position',[.51 .952 .1 .015],...
                    'String','jointName prefix: ');

mmscale = 0;                
checkbox10 = uicontrol('Style','checkbox',...
                    'String', 'mm scale',...                    
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.665 .877 .05 .015],...
                    'callback', 'mmscale = get(checkbox10,''value'');');                  
                
                  
                
                
%% Axes, graphic control UI
uipanel('Title', 'Axes and Graphic control panel',...
            'BackgroundColor',[.94 .94 .94],...
            'FontSize',12,...
            'Unit','normalized',...                        
            'Position', [.79 .55 .2 .45]);

alpha = 0.5;
slideBar = uicontrol('Style','slider',...
                    'Unit','normalized',...                    
                    'Min',0,'Max',1,'Value',alpha,...
                    'Position',[.85 .58 .08 .02],...
                    'Callback','alpha = get(slideBar,''value'');  set(edit9,''string'',num2str(alpha,''%.2d''));  set(surf,''FaceAlpha'',alpha);');      

edit9 = uicontrol('Style','edit',...
                    'String', num2str(alpha,'%.4f'),'backgroundColor', [1 1 1],...
                    'Unit','normalized',...
                    'Position', [.935 .58 .03 .02],'callback','alpha = str2double(get(edit9,''string'')); set(slideBar,''value'',alpha); set(surf,''FaceAlpha'',alpha);');
uicontrol('Style','text',...
            'Unit','normalized',...
            'BackgroundColor',[.94 .94 .94],...
            'FontSize',9,...
            'Position',[.815 .58 .03 .02],...
            'String','Alpha: ');
axisX = 1;  axisY = 2;  axisZ = 3;
checkbox3 = uicontrol('Style','checkbox',...
                    'String', 'swap x & y axes',...
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.82 .77 .07 .03],...
                    'callback', 'tmp = axisX;  axisX = axisY;  axisY = tmp; clear tmp; drawData;'); 
checkbox4 = uicontrol('Style','checkbox',...
                    'String', 'swap y & z axes',...
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.82 .74 .07 .03],...
                    'callback', 'tmp = axisY;  axisY = axisZ;  axisZ = tmp; clear tmp; drawData;'); 
checkbox5 = uicontrol('Style','checkbox',...
                    'String', 'swap z & x axes',...
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.82 .71 .07 .03],...
                    'callback', 'tmp = axisZ;  axisZ = axisX;  axisX = tmp; clear tmp; drawData;');
                
revertX = 0;  revertY = 0;  revertZ = 0;                
checkbox6 = uicontrol('Style','checkbox',...
                    'String', 'invert x axis',...
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.82 .68 .07 .03],...
                    'callback', 'revertX = revertX + 1; revertX = mod(revertX,2); drawData;'); 
checkbox7 = uicontrol('Style','checkbox',...
                    'String', 'invert y axis',...
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.82 .65 .07 .03],...
                    'callback', 'revertY = revertY + 1; revertY = mod(revertY,2); drawData;'); 
checkbox8 = uicontrol('Style','checkbox',...
                    'String', 'invert z axis',...
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.82 .62 .07 .03],...
                    'callback', 'revertZ = revertZ + 1; revertZ = mod(revertZ,2); drawData;');    
checkbox9 = uicontrol('Style','checkbox',...
                    'String', 'top view',...
                    'BackgroundColor',[.94 .94 .94],...
                    'Unit','normalized',...
                    'Position', [.88 .62 .07 .03],...
                    'callback', 'if(get(checkbox9,''value''))[az,el] = view; view(2);else view(az,el);end');                          
                
pushbotton7 = uicontrol('Style','pushbutton',...
                        'String', 'Reset Axes',...
                        'FontSize',10,...
                        'Unit','normalized',...
                        'Position', [.93 .665 .05 .02],...
                        'callback', 'revertX = 0;  revertY = 0;  revertZ = 0;  axisX = 1;  axisY = 2;  axisZ = 3;  set(checkbox3,''value'',0); set(checkbox4,''value'',0); set(checkbox5,''value'',0); set(checkbox6,''value'',0); set(checkbox7,''value'',0); set(checkbox8,''value'',0); view(3);drawData;');
                    
                 
slideBar2 = uicontrol('Style','slider',...
                    'Unit','normalized',...                    
                    'Min',-5,'Max',0,'Value',Xmin,...
                    'Position',[.83 .91 .08 .02],...
                    'Callback','Xmin = get(slideBar2,''value'');  set(XminTXT,''string'',[''Xmin: ''  num2str(Xmin,''%.2f'')]);  axis([Xmin Xmax Ymin Ymax Zmin Zmax]);');      
XminTXT = uicontrol('Style','text',...
                    'Unit','normalized',...
                    'BackgroundColor',[.94 .94 .94],...
                    'FontSize',10,...
                    'Position',[.91 .91 .05 .02],...
                    'String',['Xmin: ' num2str(Xmin,'%.2f')]); 
                 
slideBar3 = uicontrol('Style','slider',...
                    'Unit','normalized',...                    
                    'Min',0,'Max',5,'Value',Xmax,...
                    'Position',[.83 .94 .08 .02],...
                    'Callback','Xmax = get(slideBar3,''value'');  set(XmaxTXT,''string'',[''Xmax: ''  num2str(Xmax,''%.2f'')]); axis([Xmin Xmax Ymin Ymax Zmin Zmax]);');      
XmaxTXT = uicontrol('Style','text',...
                    'Unit','normalized',...
                    'BackgroundColor',[.94 .94 .94],...
                    'FontSize',10,...
                    'Position',[.91 .94 .05 .02],...
                    'String',['Xmax: ' num2str(Xmax,'%.2f')]);                 
                
slideBar4 = uicontrol('Style','slider',...
                    'Unit','normalized',...                    
                    'Min',-5,'Max',0,'Value',Ymin,...
                    'Position',[.83 .85 .08 .02],...
                    'Callback','Ymin = get(slideBar4,''value'');  set(YminTXT,''string'',[''Ymin: ''  num2str(Ymin,''%.2f'')]);  axis([Xmin Xmax Ymin Ymax Zmin Zmax]);');      
YminTXT = uicontrol('Style','text',...
                    'Unit','normalized',...
                    'BackgroundColor',[.94 .94 .94],...
                    'FontSize',10,...
                    'Position',[.91 .85 .05 .02],...
                    'String',['Ymin: ' num2str(Ymin,'%.2f')]); 
                   
slideBar5 = uicontrol('Style','slider',...
                    'Unit','normalized',...                    
                    'Min',0,'Max',5,'Value',Ymax,...
                    'Position',[.83 .88 .08 .02],...
                    'Callback','Ymax = get(slideBar5,''value'');  set(YmaxTXT,''string'',[''Ymax: ''  num2str(Ymax,''%.2f'')]);  axis([Xmin Xmax Ymin Ymax Zmin Zmax]);');      
YmaxTXT = uicontrol('Style','text',...
                    'Unit','normalized',...
                    'BackgroundColor',[.94 .94 .94],...
                    'FontSize',10,...
                    'Position',[.91 .88 .05 .02],...
                    'String',['Ymax: ' num2str(Ymax,'%.2f')]);                   
                    
slideBar7 = uicontrol('Style','slider',...
                    'Unit','normalized',...                    
                    'Min',0,'Max',5,'Value',Zmax,...
                    'Position',[.83 .82 .08 .02],...
                    'Callback','Zmax = get(slideBar7,''value'');  set(ZmaxTXT,''string'',[''Zmax: ''  num2str(Zmax,''%.2f'')]);  axis([Xmin Xmax Ymin Ymax Zmin Zmax]);');      
ZmaxTXT = uicontrol('Style','text',...
                    'Unit','normalized',...
                    'BackgroundColor',[.94 .94 .94],...
                    'FontSize',10,...
                    'Position',[.91 .82 .05 .02],...
                    'String',['Zmax: ' num2str(Zmax,'%.2f')]);                      
xlabel('x');    ylabel('y');    zlabel('z');                
