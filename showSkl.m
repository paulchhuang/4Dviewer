if exist('joints','var')
    if(SklFlag) 
        set(joints, 'Visible', 'on'); 
        set(bone, 'Visible', 'on'); 
    else
        set(joints, 'Visible', 'off');
        set(bone, 'Visible', 'off'); 
    end
else
    loadData; 
    drawData; 
end