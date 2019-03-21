gestures = {'about.csv','and.csv','can.csv','cop.csv','deaf.csv','decide.csv','father.csv','find.csv','go out.csv','hearing.csv'};
for user = 1:37
    actionRows = [];
    actions = [];
    labelCol = [];
     if exist(strcat(num2str(user),"_","newdatamatrix.csv"),'file')
        classLabelCol = [];       
        initialTable = readtable(strcat(num2str(user),"_","newdatamatrix.csv"));
    
        for i = 1:height(initialTable)
            labelCol{i,1} = 0;
        end
        
        k = 1;
        for i = 1:10
             rawData = readtable(strcat(num2str(user),'_',char(gestures(i))));
             actionRows{i} = height(rawData)/34 ;
             
             gestureTable  = initialTable(:,:);
             classLabelCol = labelCol(:,:);
             for j = 1:actionRows{i}
                 classLabelCol{k,1} = 1;
                 k = k + 1;
             end
             gestuteWithClassColTable = [gestureTable classLabelCol];
             writetable(gestuteWithClassColTable,user + "_datamatrix_" + gestures{i} ,'WriteVariableNames', false)
        end     
    end
end