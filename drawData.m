[az,el] = view;
%plot3(0,0,0,'ok','MarkerFaceColor','g','MarkerSize',10);        
hold on;    
if exist('surf','var') 
    set(surf,'vertices',[((-1)^revertX)*mesh.coords(:,axisX),((-1)^revertY)*mesh.coords(:,axisY),((-1)^revertZ)*mesh.coords(:,axisZ)], 'faces', mesh.tri, 'FaceAlpha',alpha);
    [newlightPos, ~] = camrotate( campos,get(gca, 'cameratarget'   ),get(gca, 'dataaspectratio'),get(gca, 'cameraupvector' ),30,30,'camera',[]);
    set(lght, 'Position', newlightPos);
else
    if (noncoloredMesh)
        surf = trisurf(mesh.tri,((-1)^revertX)*mesh.coords(:,axisX),((-1)^revertY)*mesh.coords(:,axisY),((-1)^revertZ)*mesh.coords(:,axisZ),...   
            'FaceVertexCData',mesh.colors,...
            'FaceColor','interp',...        
            'EdgeColor','none',...    
            'FaceAlpha',alpha);      
    else
        surf = trisurf(mesh.tri,((-1)^revertX)*mesh.coords(:,axisX),((-1)^revertY)*mesh.coords(:,axisY),((-1)^revertZ)*mesh.coords(:,axisZ),...    
            'FaceVertexCData',mesh.colors,...
            'FaceColor','interp',...        
            'EdgeColor','none',...
            'FaceAlpha',alpha);      


        grid on;
        daspect([1,1,1]);
        axis tight;     axis([Xmin Xmax Ymin Ymax Zmin Zmax]);

        view(az,el);
        lght = camlight;      lighting gouraud;
    end
end



if SklFlag~=0    
    if exist('joints','var') 
        set(joints, 'XData', ((-1)^revertX)*joints_tmp(:,axisX), 'YData', ((-1)^revertY)*joints_tmp(:,axisY), 'ZData', ((-1)^revertZ)*joints_tmp(:,axisZ));
        %     text(((-1)^revertX)*joints_tmp(3,axisX)-0.05,((-1)^revertY)*joints_tmp(3,axisY)-0.05,((-1)^revertZ)*joints_tmp(3,axisZ),'LKNEE');  
        %     text(((-1)^revertX)*joints_tmp(14,axisX)-0.05,((-1)^revertY)*joints_tmp(14,axisY)-0.05,((-1)^revertZ)*joints_tmp(14,axisZ),'RELBOW');  
    else
        joints = plot3(((-1)^revertX)*joints_tmp(:,axisX),((-1)^revertY)*joints_tmp(:,axisY),((-1)^revertZ)*joints_tmp(:,axisZ),'or','MarkerFaceColor','r','MarkerSize',5);     
    end

    
    if exist('bone','var')
        for b = 1:14            % assuming one component!
            set(bone(b),'XData', ((-1)^revertX)*[joints_tmp(ci*15+Parents(b+1),axisX) joints_tmp(ci*15+b+1,axisX)]',...
                        'YData', ((-1)^revertY)*[joints_tmp(ci*15+Parents(b+1),axisY) joints_tmp(ci*15+b+1,axisY)]',...
                        'ZData', ((-1)^revertZ)*[joints_tmp(ci*15+Parents(b+1),axisZ) joints_tmp(ci*15+b+1,axisZ)]');
        end
    else
        for ci = 0:(length(joints_tmp(:,1))/15)-1   % assuming one component! bone will be replace if there's multiple components
            bone = plot3(((-1)^revertX)*[joints_tmp(ci*15+Parents(2:15),axisX) joints_tmp(ci*15+2:ci*15+15,axisX)]',...
                  ((-1)^revertY)*[joints_tmp(ci*15+Parents(2:15),axisY) joints_tmp(ci*15+2:ci*15+15,axisY)]',...
                  ((-1)^revertZ)*[joints_tmp(ci*15+Parents(2:15),axisZ) joints_tmp(ci*15+2:ci*15+15,axisZ)]','-r','LineWidth',2);
        end
    end
end
if CloudFlag~=0
    if exist('clouds','var')
        set(clouds, 'XData', ((-1)^revertX)*cloud.coords(:,axisX), 'YData', ((-1)^revertY)*cloud.coords(:,axisY), 'ZData', ((-1)^revertZ)*cloud.coords(:,axisZ));        
    else
        clouds = plot3(((-1)^revertX)*cloud.coords(:,axisX),((-1)^revertY)*cloud.coords(:,axisY),((-1)^revertZ)*cloud.coords(:,axisZ),'k.');               
    end
end

hold off;

