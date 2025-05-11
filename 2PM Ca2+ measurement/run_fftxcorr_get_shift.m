function [shiftX,shiftY] = run_fftxcorr_get_shift(current_frame,ref_frame)

         [sy,sx]=size(ref_frame);

        
        ref_frame_fft = fft2(ref_frame);  % perform 2D fourier transform         
        current_frame_fft = fft2(current_frame);

        cc=fftshift(ifft2(ref_frame_fft.*conj(current_frame_fft)));  % xcorr

        [shiftY,shiftX]=find(cc==max(cc(:)));
        
        shiftY=shiftY-fix(sy/2)-1;  
        shiftX=shiftX-fix(sx/2)-1;  

end