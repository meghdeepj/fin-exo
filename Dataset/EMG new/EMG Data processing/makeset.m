function [SVMModel tr_feat te_feat tr_label te_label] = makeset(emg, tim)

feat=zeros(500,21);
load('mf_flex_trimmed.mat')
feat(1:250,:) = feat_ext(emg,tim);
load('stall_trimmed_3.mat')
feat(251:500,:) = feat_ext(emg,tim);

label = zeros(500,1);
label(1:250,1)=2;
label(251:500,1)=1;

tr_label=zeros(400,1);
te_label=zeros(100,1);
tr_feat = zeros(400,21);
te_feat=zeros(100,21);

tr_feat(1:200,:) = feat(1:200,:);
tr_feat(201:400,:) = feat(251:450,:);

te_feat(1:50,:) = feat(201:250,:);
te_feat(51:100,:) = feat(451:500,:);

tr_label(1:200,:) = label(1:200,:);
tr_label(201:400,:) = label(251:450,:);

te_label(1:50,:) = label(201:250,:);
te_label(51:100,:) = label(451:500,:);

SVMModel = fitcsvm(tr_feat,tr_label,'KernelFunction','rbf',...
'Standardize',true,'ClassNames',[2,1]);

end
