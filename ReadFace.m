function [f_matrix,realclass]=ReadFace(npersons,flag)
%��ȡORL��������Ƭ������ݵ�����
%���룺
%    npersons-��Ҫ�����������ÿ���˵�ǰ���ͼΪѵ�������������Ϊ��֤����
%    imgrow-ͼ���������Ϊȫ�ֱ���
%    imgcol-ͼ���������Ϊȫ�ֱ���
%    flag-��־��0��ʾ����ѵ��������1��ʾ�����������
%�����
%��֪ȫ�ֱ�����imgrow=112;imgcol=92;
global imgrow;
global imgcol;
realclass=zeros(npersons*5,1);%zeros ����ȫ������ ���󴴽���һ��200*1�������
f_matrix=zeros(npersons*5,imgrow*imgcol);%������һ��200*��112*92��������󣬰�ѵ���������е��������������f_matrix��
for i=1:npersons
    facepath='C:\Users\Administrator\Desktop\����ʶ��\�Ľ�\orl_faces\s';%ѵ����������·��
    facepath=strcat(facepath,num2str(i));%strcat �ַ���ƴ�� num2str()������תΪ�ַ���
    facepath=strcat(facepath,'/');
    cachepath=facepath;%�õ�ͼƬ��·��
    for j=1:5
        facepath=cachepath;
        if flag==0 %����ѵ�����������ݣ�matlab��=�൱�ڸ�ֵ��==���ǱȽϣ�
            facepath=strcat(facepath,'0'+j);
        else %���������������
            facepath=strcat(facepath,num2str(5+j));
            realclass((i-1)*5+j)=i;
        end
        facepath=strcat(facepath,'.pgm');
        img=imread(facepath);
        f_matrix((i-1)*5+j,:)=img(:)';%img(:)ת����112*92��1��
    end
end
end