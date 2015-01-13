%% mesh
mesh.name = [meshName_prefix num2str(f,format) meshName_suffix '.off'];
mesh_tmp = importdata(mesh.name);
numV = mesh_tmp.data(1,1);  numT = mesh_tmp.data(1,2);
if (noncoloredMesh)
    idx_v = 2:1:(2+(numV-1)*1);
    idx_T = idx_v(end)+1:2:(idx_v(end)+1+2*(numT-1));
    mesh.colors = 0.5*ones(numV,3);
else
    idx_v = 2:3:(2+(numV-1)*3);
    idx_T = idx_v(end)+3:2:(idx_v(end)+3+2*(numT-1));
    mesh.colors = mesh_tmp.data(idx_v+1,:);
end
% mesh.colors = 0.5*ones(numV,3);

mesh.coords = mesh_tmp.data(idx_v,:);
if(mmscale) 
    mesh.coords = mesh.coords/1000;
end
mesh.tri = mesh_tmp.data(idx_T,2:3);
mesh.tri = [mesh.tri mesh_tmp.data(idx_T+1,1)] + 1;
%% skeleton
if SklFlag~=0
    SklName = [jointsName_prefix num2str(f,format)];
    joints_tmp = load(SklName); 
    if(mmscale) 
        joints_tmp = joints_tmp/1000;   
    end
end
%% point cloud
if CloudFlag~=0
    CloudName = [cloudName_prefix num2str(f,format2) cloudName_suffix '.off'];
    cloud_tmp = importdata(CloudName);
    numV = cloud_tmp.data(1,1);  numT = cloud_tmp.data(1,2);
    if(coloredCloud)
        idx_v = 2:3:(2+(numV-1)*3);
    else
        idx_v = 2:1:(2+(numV-1)*1);
    end
    cloud.coords = cloud_tmp.data(idx_v,:);    
    if(mmscale) 
        cloud.coords = cloud.coords/1000;
    end

end

