function out = ssd_nii(nii_src, nii_target)
% nii_src is the baseline
% nii_target is a corrected image, which was corrupted before
    [~, ~, N] = size(nii_src.img);
    out = zeros(1, N);
    % normalization of the images, so intensities will be in range
    % [0, 255]
    for i = 1:N
        % source image normalization
        img_src = nii_src.img(:, :, i);
        img_src = double(img_src);
        max_intens = max(max(img_src));
        if max_intens ~= 0
            img_src = 255 * img_src ./ max_intens;
        end
        % target image normalization
        img_target = nii_target.img(:, :, i);
        img_target = double(img_target);
        max_intens = max(max(img_target));
        if max_intens ~= 0
            img_target = 255 * img_target ./ max_intens;
        end

        out(i) = sum(sum((img_src - img_target).^2))/numel(img_src);
    end
end