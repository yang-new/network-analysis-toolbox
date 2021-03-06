function COM_3D = convertMAT3D_MYcom_wei(subject_array_3D,order,up_to_and_including,af)
%CONVERTMAT3D_MYCOM_WEI     Convert edges of adjacency matrix to
%modified communicability scores
%
%   COM_3D = convertMAT3D_MYcom_wei(subject_array_3D,order,up_to_and_including,af);
%
%   Inputs:
%   - subject_array_3D is a 3D matrix of individual 2D weighted
%   (un)directed matrices with subjects in 3rd dimension
%   diagonal of 2D matrices should be 0
%   - order means you want to include walks up to what length (1 is
%   monosynaptic, 2 is disynaptic, 3 trisynaptic, etc.). 
%   .... set order to 0 if you want to include walks of infinity length
%   - up_to_and_including means that you include all walks up to and
%   including the length specified by order (1) or walks only of the
%   length specified by order (0).
%   - af is attenuation factor: the penalty factor by which you multiply
%   for every additional step taken (0<af<1)
%   .... set af to '!' if you want to use factorial attentuation
%
%   Example: G_3D = convertMAT3D_MYcom_wei(subject_array_3D,5,1,'!');
%
% -David Grayson 2015

[sx,sy,slen]=size(subject_array_3D);

for s=1:slen
    W=subject_array_3D(:,:,s);
    nodeStren=(sum(W)+sum(W'))/2;
    W=W./sqrt(nodeStren'*nodeStren);            %normalize matrix
    
    if order == 0
        G=expm(W);            %communicability matrix
        COM_3D(:,:,s)=G;
        continue
    end

    G=zeros(sx,sy); %initialize MY communicability matrix
    for o=1:order
        if up_to_and_including == 0 && o ~= order
            continue %skip to last walk length
        end
        if strcmp(af,'!')
            G=G+(W^o)./factorial(o);      %add to MY communicability matrix
        else
            G=G+(W^o).*af^(o-1);      %add to MY communicability matrix
        end
    end
    
    COM_3D(:,:,s)=G;
end
