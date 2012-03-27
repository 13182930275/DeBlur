function psf = getPSFValues(im,imageMask,trace) % ���������� �������� ����������
    [PSFheight PSFwidth] = size(trace);
    psf = zeros(PSFheight, PSFwidth);
    counter = 0;
    [height width] = size(im(:,:,1));
    for y=1:height-PSFheight,
        for x=1:width-PSFwidth,
            if imageMask(y,x) && imageMask(y+PSFheight-1,x+PSFwidth-1), % �� ���� �������� � �����
                psf = psf + updatePsf(y,x,im,trace);
                counter = counter +1;
            end;
        end;
    end;
    psf = psf./counter;
    psf = psf./sum(sum(psf)); % ������������ �� 1
end