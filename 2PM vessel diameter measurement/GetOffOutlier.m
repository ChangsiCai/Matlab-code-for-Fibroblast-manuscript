function Matrix1=GetOffOutlier(Matrix0,thld)

[xsize,ysize]=size(Matrix0);
Matrix0N = reshape(Matrix0,[],1);

MMean=mean(Matrix0N);
MStd=std(Matrix0N);
I=find(Matrix0N>MMean+MStd*thld | Matrix0N<MMean-MStd*thld);


MatrixTemp=Matrix0N;
MatrixTemp(I)=[];

Matrix0N(I)=mean(MatrixTemp);

Matrix1 = reshape(Matrix0N,xsize,ysize);
