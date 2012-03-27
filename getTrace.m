function trace=getTrace(im, imageMask) % ���� ���������� ����� ��� �����
maxblobcount=2000;
im=double(rgb2gray(im));
[gx gy]=gradient(im);
gx=abs(gx);
gy=abs(gy);
bestmatchcount=0;
prevloopscounter=0;
gradmask=zeros(100,100,maxblobcount);    %���������� ��� ��������� ����� �����
sizeX=zeros(maxblobcount);
sizeY=zeros(maxblobcount);
for XY=0:1,
    prevloopscounter=0;
    if XY==0,
        maxgrad=max(max(gx));
    else
        maxgrad=max(max(gy));
    end;
    threshold=uint8(maxgrad*0.5);
    oldmask=[];
while threshold<=maxgrad,
    threshold %#ok<NOPRT>
    if XY==0,
        mask=gx>threshold;
    else
        mask=gy>threshold;
    end;
    if isequal(oldmask,mask), threshold=threshold+1; continue; end; oldmask=mask;
    [L blobcount] = bwlabel(mask);
    P = regionprops(L,'BoundingBox','Area');
    for ind=1:blobcount,
        bb = P(ind).BoundingBox;
        if P(ind).Area<2, continue; end; % ������� ������ �����
        bb = round(bb);
        x = bb(1);
        y = bb(2);
        w = bb(3)-1;
        h = bb(4)-1;
        maskTemp=mask(y:(y+h), x:(x+w));
        [gradmaskL gradmaskR]=findEdge(maskTemp,XY); % ������ ���䳺���, 0 - �� �, 1 - �� �
        
        %�� ���
        if sum(sum(gradmaskL))>1, % ������� ������ �����
            [tempmask dim1 dim2]=clearinitzeros2D(gradmaskL); %�������� �������� ��� � ������� ��������� �����
            gradmask(1:dim1,1:dim2,prevloopscounter+ind*2-1)=tempmask;
            sizeX(prevloopscounter+ind*2-1)=dim2;
            sizeY(prevloopscounter+ind*2-1)=dim1;
            matchcount=0;
            for k=1:(prevloopscounter+ind*2-2),
                [match biggerone]=ismatch(tempmask,gradmask(1:sizeY(k),1:sizeX(k),k));
                if match,
                    matchcount=matchcount+1;
                    tempmask=biggerone;
                end; 
            end;
            if matchcount>bestmatchcount, bestblob=tempmask; 
                bestmatchcount=matchcount; end;
        end;
   
        %���� ���
        if sum(sum(gradmaskR))>1, % ������� ������ �����
            [tempmask dim1 dim2]=clearinitzeros2D(gradmaskR); %�������� �������� ��� � ������� ��������� �����
            gradmask(1:dim1,1:dim2,prevloopscounter+ind*2)=tempmask;
            sizeX(prevloopscounter+ind*2)=dim2;
            sizeY(prevloopscounter+ind*2)=dim1;
            matchcount=0;
            for k=1:(prevloopscounter+ind*2-1),
                [match biggerone]=ismatch(tempmask,gradmask(1:sizeY(k),1:sizeX(k),k));
                if match,
                    matchcount=matchcount+1;
                    tempmask=biggerone;
                end; 
            end;
            if matchcount>bestmatchcount, bestblob=tempmask; 
                bestmatchcount=matchcount; end;
        end;
    end;
    prevloopscounter=prevloopscounter+(blobcount*2); % ����� �� ��������
    %prevloopscounter %#ok<NOPRT>
    threshold=threshold+1;
end;
end;
trace=bestblob;
end