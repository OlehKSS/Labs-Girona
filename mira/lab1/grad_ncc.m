function [ out ] = grad_ncc( img_src, img_fixed )
%grad_ncc Return gradient normalized cross correlation
    img_src = imgaussfilt(img_src);
    img_src = imgaussfilt(img_src);
    [gx_src, gy_src] = imgradientxy(img_src);
    [gx_fixed, gy_fixed] = imgradientxy(img_fixed);
    numer = sum(sum(abs(gx_src .* gx_fixed + gy_src .* gy_fixed)));
    denom1 = sqrt(sum(sum(gx_src .^2 + gy_src .^2)));
    denom2 = sqrt(sum(sum(gx_fixed .^2 + gy_fixed .^2)));
    
    out = numer / (denom1 * denom2);
end

