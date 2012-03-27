function output = checkForGaps(input)
    [L blobcount] = bwlabel(input);
    if blobcount>1, % �� � �������
        P = regionprops(L,'BoundingBox');
        for i=1:blobcount-1, % ���������� ������
            bbCurrent = round(P(i).BoundingBox);
            bbNext    = round(P(i+1).BoundingBox);
            
            Xes= [bbCurrent(1) bbCurrent(3)-1 bbNext(1) bbNext(3)-1]; % �� ���� 2 ������ �����
            Ys = [bbCurrent(2) bbCurrent(4)-1 bbNext(2) bbNext(4)-1]; % �� ������ 2 ������ �����
            sort(Xes);
            sort(Ys);

            %endX = bbCurrent(3)-1; % ���������� ������ ����� �� �������� ������� (�� �������)
            %endY = bbCurrent(4)-1;
            %nextX = bbNext(1);
            %nextY = bbNext(2);
           
            endX = Xes(2); % ���������� ������ ����� �� �������� ������� (�� �������)
            endY = Ys(2);
            nextX = Xes(3);
            nextY = Ys(3);
            
            if endY+1==nextY, 
                % ������ � ����� ���� ��������������
                deltaX = nextX - endX - 1; % ������ ��������������� �������
                patch = ones(deltaX,1); % ������ ������������� �����
                input(endX+1:nextX-1, endY) = patch; % ������
            elseif endX+1==nextX, 
                % ������ � ����� ���� ������������
                deltaY = nextY - endY - 1; % ������ ������������� �������
                patch = ones(1,deltaY); % ������ ����������� �����
                input(endX,endY+1:nextY-1) = patch; % ������
            end;
            
        end;
    end;
    output = input;
end