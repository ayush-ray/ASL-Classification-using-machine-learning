gestures = {'about.csv','and.csv','can.csv','cop.csv','deaf.csv','decide.csv','father.csv','find.csv','go out.csv','hearing.csv'};
accuracyTable=table;
accuracyTable=[accuracyTable,{'User','Accuracy','Recall','Precision','F_score'}];
for user = 1:37
    actionRows = [];
    for i = 1:10
        rawData = readtable(strcat(num2str(user),'_',char(gestures(i))));
        actionRows{i} = height(rawData)/34 ;
    end
    for i = 1:10
        if exist(strcat(num2str(user),"_","datamatrix","_",char(gestures(i))),'file')
            initialtable = readtable(strcat(num2str(user),"_","datamatrix","_",char(gestures(i))));
            x= initialtable(:,1:7)
            t= initialtable(:,8:8)
            x= table2array(x)
            t=table2array(t)
            x = x'
            t = t'
            net = patternnet(10);
            net = train(net,x,t);
            view(net)
            y = net(x);
            [c,cm,ind,per] = confusion(t,y);
            accuracy=(cm(1,1)+cm(2,2))/(cm(1,1)+cm(2,2)+cm(1,2)+cm(2,1));
            recall=cm(1,1)/(cm(1,1)+cm(2,1));
            precision=cm(1,1)/(cm(1,1)+cm(1,2));
            f_score=2*recall*precision/(precision+recall);
            accuracyTable=[accuracyTable;{user,accuracy,recall,precision,f_score}];
        end
    end
end
writetable(accuracyTable,'metricneural.csv','WriteVariableNames', false)
