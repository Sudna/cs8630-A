% Provide the full path to the file
filePath = '/Users/yanmeichen/Library/CloudStorage/OneDrive-UniversityofMissouri/Cu-based perovskites/Cs3Cu2Cl5-Cs3Cu2Br5-Yanmei/paper 2/24.02.28-PL-PLE-3D spectrum/Cs3Cu2I5/Cs3Cu2I5 - excitation-250-380 nm-em-390-500-3D-filter-310nm.txt';

% Use readmatrix to read the data from the text file
data = readmatrix(filePath);

% Check the size of the data to understand its dimensions
[nRows, nCols] = size(data);

% Define the desired range for excitation and emission, 
% or use the entire range by default
desiredExcitationRange = [245, 330]; % Example: [minValue, maxValue]
desiredEmissionRange = [375, 520];   % Example: [minValue, maxValue]

% Generate the X and Y axes based on the assumed excitation and emission ranges
emissionRange = linspace(370, 520, nCols);   % Emission from 370 to 520 nm (can be customized)
excitationRange = linspace(230, 360, nRows); % Excitation from 230 to 360 nm (can be customized)

% Optional: Trim the data based on the desired ranges
% This will only use the subset of data that fits within the desired ranges
excitationMask = (excitationRange >= desiredExcitationRange(1)) & (excitationRange <= desiredExcitationRange(2));
emissionMask = (emissionRange >= desiredEmissionRange(1)) & (emissionRange <= desiredEmissionRange(2));

X = emissionRange(emissionMask);
Y = excitationRange(excitationMask);
Z = data(excitationMask, emissionMask);

% Interpolate data for a smoother plot
[Xq, Yq] = meshgrid(linspace(min(X), max(X), 1000), linspace(min(Y), max(Y), 1000)); % Increase grid resolution
Zq = interp2(X, Y, Z, Xq, Yq, 'cubic'); % Cubic interpolation for smoothness

% Create a figure with tight layout
figure('Position', [100, 100, 800, 800], 'Color', 'none'); % Set figure size and make background transparent

% Plot the interpolated data using contourf for a smooth gradient plot
contourf(Xq, Yq, Zq, 200, 'LineColor', 'none'); % Increase levels to 200 for smoother color transitions

% Set the colormap to 'jet' to match the provided image colors
colormap(jet);

% Create and label the colorbar
cbar = colorbar('eastoutside');
cbar.Label.String = 'Intensity (a.u.)'; % Explicitly set the colorbar label string
cbar.Label.FontSize = 16; % Set the colorbar label font size to 16
cbar.Label.FontWeight = 'normal'; % Ensure the font weight is normal

% Set the axis labels with the desired font size
xlabel('Emission wavelength (nm)', 'FontSize', 16); % Emission on the x-axis
ylabel('Excitation wavelength (nm)', 'FontSize', 16); % Excitation on the y-axis

% Adjust the plot appearance
axis square; % Keep the aspect ratio square to match the example image
set(gca, 'FontSize', 16); % Set the x and y axis tick label font sizes to 16

% Tighten layout to remove excess white space around the plot
set(gca, 'LooseInset', get(gca, 'TightInset')); % Remove loose inset margins

% Save the figure with a transparent background
set(gcf, 'PaperPositionMode', 'auto');
print('high_res_plot_transparent_bg_smooth', '-dpng', '-r300', '-transparent'); % Save with transparent background

% Display the plot
shg; % Show the generated figure
