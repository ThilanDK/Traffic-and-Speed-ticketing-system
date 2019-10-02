foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50);

videoReader = vision.VideoFileReader('11462297-preview.mp4');
x=0;
y=0;
count1=1;
count2=1;
out1=0;
out2=0;
o1=0;
o2=0;
list=[];
for i = 1:150
    frame = step(videoReader);
    foreground = step(foregroundDetector, frame);
end

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 150);

videoPlayer = vision.VideoPlayer('Name', 'Galle');
videoPlayer.Position(1:2:3:4) = [100,50,300,400];
videoPlayer2 = vision.VideoPlayer('Name', 'colombo');
videoPlayer2.Position(1:2:3:4) =[1000,50,300,400] ;
videoPlayer3 = vision.VideoPlayer('Name', 'CCTV');
videoPlayer3.Position(1:2:3:4) =[500,300,400,400] ; 
se = strel('square', 3); 

while ~isDone(videoReader)

    frame = step(videoReader);
    n=fix(size(frame,1)/1);
    count1=count1+1;
    C=frame(:,1:n,:);
    D=frame(:,n-20:end,:);
    foreground = step(foregroundDetector, frame);
    A=foreground(:,1:n,:);
    B=foreground(:,n-20:end,:);
    filteredForeground = imopen(A, se);
    filteredForeground2 = imopen(B, se);
    bbox = step(blobAnalysis, filteredForeground);
    bbox2 = step(blobAnalysis, filteredForeground2);
    result = insertShape(C, 'Rectangle', bbox, 'Color', 'green');
    result2 = insertShape(D, 'Rectangle', bbox2, 'Color', 'blue');
    numCars  = size(bbox, 1);
    numCars2  = size(bbox2, 1);
    if(numCars>0)
        x=x+1;
    
    end
    if(numCars2>0)
        y=y+1;
    end
    s = num2str(x/29.97);
    u = num2str(y/29.97);
    result = insertText(result, [10 10], s,'BoxColor','red', 'BoxOpacity', 0.5, ...
        'FontSize', 15);
    result2 = insertText(result2, [200 10], u,'BoxColor','green', 'BoxOpacity', 1, ...
        'FontSize', 15);
     step(videoPlayer3,frame);
    step(videoPlayer, result);
    step(videoPlayer2, result2)
end

figure('Name','Speedometer','NUmberTitle','off')
name={'speed'};
q=(20/1000)/((x/29.97)/3600);
p=[1];
bar(p,q);
set(gca,'xticklabel',name);
ylabel('Km/h')
release(videoReader);