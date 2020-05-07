%categories=('0','1','2','3','4','5','6','7','8','9','-');
imds=imageDatastore('dataset\number_img\','IncludeSubfolders',true,'LabelSource','foldernames');

imds.ReadFcn=@ (filename)readAndPreprocessImage(filename);
%[training_data,testing_data]=splitEachLabel(imds,.7,'randomized');
[training_data,testing_data]=splitEachLabel(imds,.7,'randomized');
convnet=helperImportMatConvNet('imagenet-caffe-alex.mat');
featureLayer='fc7';
training_features = activations(convnet,training_data,featureLayer, ...
            'MiniBatchSize',32,'OutputAs','columns');
testing_features = activations(convnet, testing_data,featureLayer, ...
            'MiniBatchSize',32,'OutputAs','columns');
 classifier=fitcecoc(training_features,training_data.Labels,...
     'Learners','Linear','Coding','onevsall','ObservationsIn','columns');
 labels=predict(classifier, testing_features');