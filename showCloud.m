if(exist('clouds','var')) 
    if(CloudFlag) 
        set(clouds, 'Visible', 'on'); 
    else
        set(clouds, 'Visible', 'off');
    end
else
    loadData; 
    drawData; 
end