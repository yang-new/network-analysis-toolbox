function COM_3D = tmpconvertMAT3D_com_wei(subject_array_3D,mat3d_2)
%tmpCONVERTMAT3D_COM_WEI     Convert edges of lesioned adjacency matrix to
%communicability scores
%
%   COM_3D = convertMAT3D_COM_WEI(subject_array_3D);
%
%   Inputs:
%   subject_array_3D is a 3D matrix of individual 2D weighted
%   (un)directed matrices (lesioned) with subjects in 3rd dimension
%   diagonal of 2D matrices should be 0
%
%   mat3d_2 is the same but represents the unlesioned matrices
%
% -David Grayson 2015


slen=size(subject_array_3D,3);

for s=1:slen
    W=subject_array_3D(:,:,s); %lesioned SC matrix
    X=mat3d_2(:,:,s); %unlesioned SC matrix
    
%     norm=sqrt(sum(X)'*sum(X));
%     norm(:,27)=[];norm(27,:)=[]; %removing amygdala
%     W(:,27)=[];W(27,:)=[]; %removing amygdala
%     G=expm(W./norm);            %communicability matrix of lesioned SC matrix using rescaling factor from unlesioned SC matrix

    nodeStren=(sum(X)+sum(X'))/2;
    G=expm(W./sqrt(nodeStren'*nodeStren));            %communicability matrix of lesioned SC matrix using rescaling factor from unlesioned SC matrix
    
%     newm=zeros(40,40); %piecing the matrix back together
%     newm(1:26,1:26)=G(1:26,1:26);
%     newm(28:40,1:26)=G(27:39,1:26);
%     newm(1:26,28:40)=G(1:26,27:39);
%     newm(28:40,28:40)=G(27:39,27:39);
%     G=newm;

    COM_3D(:,:,s)=G;
end
