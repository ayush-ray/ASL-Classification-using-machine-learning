gestures = {'about.csv','and.csv','can.csv','cop.csv','deaf.csv','decide.csv','father.csv','find.csv','go out.csv','hearing.csv'};
accuracyTableforsvm=table;
accuracyTableforsvm=[accuracyTableforsvm,{'User','Accuracy','Recall','Precision','F_score'}];
for user = 1:37
    actionRows = [];
    for i = 1:10
        rawData = readtable(strcat(num2str(user),'_',char(gestures(i))));
        actionRows{i} = height(rawData)/34 ;
    end
    for i = 1:10
        if exist(strcat(num2str(user),"_","datamatrix","_",char(gestures(i))),'file')
            initialtable = readtable(strcat(num2str(user),"_","datamatrix","_",char(gestures(i))));
            gestureStartPosition=0;
            gestureTable=table;
            nongestureTable=table;
            if i==1
                gestureTable=initialtable(1:actionRows{i},:);
                initialtable(1:actionRows{i},:)=[];
                nongestureTable=initialtable;
            else
                for j = 1:i-1
                    gestureStartPosition=gestureStartPosition+actionRows{j};
                end
                gestureTable=initialtable(gestureStartPosition+1:gestureStartPosition+actionRows{i},:);
                initialtable(gestureStartPosition+1:gestureStartPosition+actionRows{i},:)=[];
                nongestureTable=initialtable;
            end
            gestureTrainTable=gestureTable(1:round(height(gestureTable)*0.7),:);
            nongestureTrainTable=nongestureTable(1:round(height(nongestureTable)*0.7),:);
            writetraintable=vertcat(gestureTrainTable,nongestureTrainTable);
            gestureTestTable=gestureTable(height(gestureTrainTable)+1:height(gestureTable),:);
            nongestureTestTable=nongestureTable(height(nongestureTrainTable)+1:+height(nongestureTable),:);
            writetesttable=vertcat(gestureTestTable,nongestureTestTable);
            x = table2array(writetraintable(:,1:2))
            y = table2array(writetraintable(:,8:8))
            decisionTreeModel = fitcsvm(x,y,'Standardize',true,'KernelFunction','rbf','ClassNames',[0,1]);
            testdata = table2array(writetesttable(:,1:2))
            decisionTreeLabel = predict(decisionTreeModel,testdata)
            correctLabel = table2array(writetesttable(:,8:8));
            [c,cm,ind,per] = confusion(correctLabel',decisionTreeLabel');
            accuracy=(cm(1,1)+cm(2,2))/(cm(1,1)+cm(2,2)+cm(1,2)+cm(2,1));
            recall=cm(1,1)/(cm(1,1)+cm(2,1));
            precision=cm(1,1)/(cm(1,1)+cm(1,2));
            f_score=2*recall*precision/(precision+recall);
            accuracyTableforsvm=[accuracyTableforsvm;{user,accuracy,recall,precision,f_score}];
            
        end
    end
end
%csvwrite("accuracyforsvm.csv",accuracyTableforsvm);
writetable(accuracyTableforsvm,'metricssvm.csv','WriteVariableNames', false)

