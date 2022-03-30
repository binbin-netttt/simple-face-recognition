function [f_matrix,realclass]=ReadFace(npersons,flag)
%读取ORL人脸库照片里的数据到矩阵
%输入：
%    npersons-需要读入的人数，每个人的前五幅图为训练样本，后五幅为验证样本
%    imgrow-图像的行像素为全局变量
%    imgcol-图像的列像素为全局变量
%    flag-标志，0表示读入训练样本，1表示读入测试样本
%输出：
%已知全局变量：imgrow=112;imgcol=92;
global imgrow;
global imgcol;
realclass=zeros(npersons*5,1);%zeros 创建全零数组 矩阵创建了一个200*1的零矩阵
f_matrix=zeros(npersons*5,imgrow*imgcol);%创建了一个200*（112*92）的零矩阵，把训练集中所有的人脸都放在这个f_matrix中
for i=1:npersons
    facepath='C:\Users\Administrator\Desktop\人脸识别\改进\orl_faces\s';%训练样本集的路径
    facepath=strcat(facepath,num2str(i));%strcat 字符串拼接 num2str()把数字转为字符串
    facepath=strcat(facepath,'/');
    cachepath=facepath;%得到图片的路径
    for j=1:5
        facepath=cachepath;
        if flag==0 %读入训练样本的数据（matlab中=相当于赋值，==才是比较）
            facepath=strcat(facepath,'0'+j);
        else %读入测试样本数据
            facepath=strcat(facepath,num2str(5+j));
            realclass((i-1)*5+j)=i;
        end
        facepath=strcat(facepath,'.pgm');
        img=imread(facepath);
        f_matrix((i-1)*5+j,:)=img(:)';%img(:)转换成112*92行1列
    end
end
end