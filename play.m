while (pauseFlag==0)&&(f<last)
    f = f + 1;
    loadData;
    set(edit3,'String',num2str(f));
    drawData;
    pause(0.1);
end

