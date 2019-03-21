for user = 1:37
    featuremat = readtable(strcat(num2str(user),"_","featurematrix.csv"))
    inparr = table2array(featuremat)
    disp(height(featuremat))
    %N=1:size(feature_matrix,2);
    inp = inparr(1:height(featuremat),:)
    %legendCell = cellstr(num2str(N', 'N=%-d'))
    if ~isempty(inp)
        [coeff,score,latent,t,explained] = pca(inp);
        biplot(coeff(1:3,1:2),'scores',score(1:3 ,1:2),'VarLabels',{'V_36','V_38','V_15'});
        disp(explained)
        
        projection=inp*coeff;
        
        newfeaturematrix = projection(:,1:7);
        csvwrite(strcat(num2str(user),"_","newdatamatrix.csv"),newfeaturematrix);
    end
end 
