function [ out ] = ncc(img_src, img_fixed)
%ssd function returns normalized cross-correlation of two images
    d1 = img_src - mean(img_src(:));
    d2 = img_fixed - mean(img_fixed(:));
    
    numer = sum(sum(d1 .* d2));
    denom1 = sqrt(sum(sum(d1 .^ 2)));
    denom2 = sqrt(sum(sum(d2 .^ 2)));
    
    out = numer / (denom1 * denom2);
end

