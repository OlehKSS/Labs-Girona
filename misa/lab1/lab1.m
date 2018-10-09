% This Matlab file demomstrates the method for simultaneous segmentation and bias field correction
% in Chunming Li et al's paper:
%    "Multiplicative intrinsic component optimization (MICO) for MRI bias field estimation and tissue segmentation",
%     Magnetic Resonance Imaging, vol. 32 (7), pp. 913-923, 2014
% Author: Chunming Li, all rights reserved
% E-mail: li_chunming@hotmail.com
% URL:  http://imagecomputing.org/~cmli/

clc;
close all;
clear all;
% path to the NIfTI module
addpath('C:\Users\bmzem\Desktop\MISA\labs\l1_preprocessing\NIfTI_20140122');

% path to the original images
imgs_dir = 'C:\Users\bmzem\Desktop\MISA\labs\l1_preprocessing\braindata\';
% path to the processed images
imgs_dir_corr = 'C:\Users\bmzem\Desktop\MISA\labs\l1_preprocessing\braindata_processed\';
nii_or = load_nii(strcat(imgs_dir, 't1_icbm_normal_1mm_pn0_rf0.nii'));

files = dir(imgs_dir_corr);
n_files =  length(files) - 2;
rfs = -1 * ones(1, n_files);
its = -1 * ones(1, n_files);
qs = -1 * ones(1, n_files);
info = cell(1, n_files);
reg = '_rf(?<rf>\d+)\w+_it(?<it>\d+)_q(?<q>\d+)';

for i = 1:length(files)
    file = files(i);
    if ~file.isdir
        file_info = regexp(file.name, reg, 'names');
        if str2num(file_info.rf) ~= 0
            nii_corr = load_nii(strcat(imgs_dir_corr, file.name));
            file_info.ssd = ssd_nii(nii_or, nii_corr);
            info{i - 2} = file_info;
            rfs(i) = str2num(file_info.rf);
            its(i) = str2num(file_info.it);
            qs(i) = str2num(file_info.q);
        end
    end
end

% delete repeting elements
rfs = unique(rfs(rfs > 0));
rfs = sort(rfs);
its = unique(its(its > 0));
its = sort(its);
qs = unique(qs(qs > 0));
qs = sort(qs);

% iterate over avialble rf values
for i = 1:length(rfs)
    rf_temp = rfs(i);
    sorted_info = containers.Map();
    ssd_temp = [];
    % iterate over available q values
    for j = 1:length(qs)
        q_temp = qs(j);
        % iterate over available iteration values
        data = zeros(length(file_info.ssd), length(its));
        labels = cell(1, length(its));
        for k = 1:length(its)
            it_temp = its(k);
            labels{k} = strcat('it=', num2str(it_temp));
            % select a file that has specified rf, q, it
            for l = 1:length(info)
                file = info{l};
                if str2num(file.rf) == rf_temp && str2num(file.it) == it_temp && str2num(file.q) == q_temp
                   data(:, k) = file.ssd;
%                    display(strcat('file', num2str(it_temp), num2str(rf_temp)));
                end
            end
        end
        figure;
        %it should be of N-boxes by data, I have 1 by smth
        boxplot(data, 'Labels', labels);
        title(strcat('SSD boxplot, rf=', num2str(rf_temp), ', q=', num2str(q_temp)));
        ylabel('Sum of Square Differences');
        xlabel('Number of Iterations');
    end
end

