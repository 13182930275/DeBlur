function output = checkForGaps(input, seekVertical)
    [L blobcount] = bwlabel(input);
    if blobcount>1, % �� � �������
        P = regionprops(L,'BoundingBox');
        for i=1:blobcount, % ���������� ������ �������
          for j=1:blobcount,
            if i==j, continue; end;
            
            bbCurrent = round(P(i).BoundingBox);
            bbNext    = round(P(j).BoundingBox);
            
            Xes= [bbCurrent(1) bbCurrent(1)+bbCurrent(3)-1 bbNext(1) bbNext(1)+bbNext(3)-1]; % �� ���� 2 ������ �����
            Ys = [bbCurrent(2) bbCurrent(2)+bbCurrent(4)-1 bbNext(2) bbNext(2)+bbNext(4)-1]; % �� ������ 2 ������ �����
            Xes = sort(Xes);
            Ys =  sort(Ys);
           
            endX = Xes(2); % ���������� ������ ����� �� �������� ������� (�� �������)
            endY = Ys(2);
            nextX = Xes(3);
            nextY = Ys(3);
            
            if ~seekVertical && endY+1==nextY, 
                % ������ � ����� ���� ��������������
                deltaX = nextX - endX - 1; % ������ ��������������� �������
                patch = ones(deltaX,1); % ������ ������������� �����
                input(endY, endX+1:nextX-1) = patch; % ������
            elseif seekVertical && endX+1==nextX, 
                % ������ � ����� ���� ������������
                deltaY = nextY - endY - 1; % ������ ������������� �������
                patch = ones(1,deltaY); % ������ ����������� �����
                input(endY+1:nextY-1, endX) = patch; % ������
            end;
            
          end;
        end;
    end;
    output = input;
end