%% Loading .ply files (point cloud)

clear
close all

% select a .ply file
[file,path] = uigetfile('*.ply','Please select the point cloud files', ...
    './data', 'MultiSelect','off');
if isequal(file, 0)
    error('No point cloud selected.');
end

% read point cloud and transform into array
pc = pcread([path, file]);
point = pc.Location';

% show input point cloud
if strcmp(file(1 : 3), 'cat')
    view_vector = [110 80];
    roll = 108;
else
    if strcmp(file(1 : 3), 'dog')
        view_vector = [110 80];
        roll = 108;
    else
        if strcmp(file(1 : 6), 'turtle')
            view_vector = [180 0];
            roll = 0;
        else
            view_vector = [0 0];
            roll = 0;
        end
    end
end

close(figure(1))
figure(1)

showPoints(point, 'MarkerSize', 10, 'ViewAxis', view_vector, 'CamRoll', roll)
title('Input Point Cloud')

%% fitting

[x, point_seg, point_outlier] = Hierarchical_EMS(point);

%% show segmentation

% set color list
rng(10);
color = rand(100, 3);

% show segementation of point cloud
color_set = 1;
close(figure(2))
figure(2)
for i = 1 : size(point_seg, 2)
    for k = 1 : size(point_seg{i}, 2)
        hold on
        showPoints(point_seg{i}{k}, 'Color', color(color_set, :), 'MarkerSize', 80)
        color_set = color_set + 1;
    end
end
hold off
view(view_vector)
camroll(roll)

%% show superquadrics

% set color list
rng(10);
color = rand(100, 3);

show_original_point = 0;

% rendering superquadric representation
close(figure(3))
figure(3)
hold on

if show_original_point == 1
    showPoints(point, 'MarkerSize', 10)
end
color_set = 1;

for i = 1 : size(x, 2)
    for k = 1 : size(x{i}, 2)
        hold on
        showSuperquadrics(x{i}{k}, 'FaceAlpha', 1, 'Light', 0, 'Arclength', 0.1, 'Color', color(color_set, :))
        color_set = color_set + 1;
    end
end
hold off

view(view_vector)
camroll(roll)
light
material dull
