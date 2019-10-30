function [SVMModel tr_feat te_feat tr_label te_label] = makeset(feat)

feat=zeros(209,21);
load('emg_flex_sampleset1_trimmed.mat')
feat(1:84,:) = feat_ext(emg,tim);
load('emg_flex_sampleset2_trimmed.mat')
feat(85:109,:) = feat_ext(emg,tim);
load('emg_stall_sampleset2_trimmed.mat')
feat(110:134,:) = feat_ext(emg,tim);
load('emg_stall_sampleset3_trimmed.mat')
feat(135:159,:) = feat_ext(emg,tim);
load('emg_stall_sampleset4_trimmed.mat')
feat(160:184,:) = feat_ext(emg,tim);
load('emg_stall_sampleset5_trimmed.mat')
feat(185:209,:) = feat_ext(emg,tim);


label = zeros(209,1);
label(1:109,1)=2;
label(110:209,1)=1;

tr_label=zeros(168,1);
te_label=zeros(41,1);
tr_feat = zeros(168,21);
te_feat=zeros(41,21);

tr_feat(1:88,:) = feat(1:88,:);
tr_feat(89:end,:) = feat(110:189,:);

te_feat(1:21,:) = feat(89:109,:);
te_feat(22:41,:) = feat(190:209,:);

tr_label(1:88,:) = label(1:88,:);
tr_label(89:end,:) = label(110:189,:);

te_label(1:21,:) = label(89:109,:);
te_label(22:41,:) = label(190:209,:);

SVMModel = fitcsvm(tr_feat,tr_label,'KernelFunction','rbf',...
'Standardize',true,'ClassNames',[2,1]);


end
