% Read input image
inputImage = imread("C:\Users\omurs\OneDrive\Belgeler\MATLAB\soloturk.jpg");

% Define zoom factor and threshold
zoomFactor = 2; % Example zoom factor
threshold = 1; % Example threshold

% Call the function and display the result
zoomedImage = adaptiveEdgeEnhancement(inputImage, zoomFactor, threshold);

% Convert to uint8
zoomedImage = uint8(zoomedImage);                             

% Define the adaptiveEdgeEnhancement function
function zoomedImage = adaptiveEdgeEnhancement(inputImage, zoomFactor, threshold)
    % Get image dimensions
    [M, N, C] = size(inputImage);
    
    % Initialize the zoomed image
    zoomedImage = zeros(M * zoomFactor, N * zoomFactor, C, 'like', inputImage);
    
    % Apply edge enhancement and zooming
    for i = 1:M-1
        for j = 1:N-1
            for c = 1:C
                dU = abs(inputImage(i+1, j, c) - inputImage(i, j, c));
                dD = abs(inputImage(i, j, c) - inputImage(i+1, j, c));
                dL = abs(inputImage(i, j+1, c) - inputImage(i, j, c));
                dR = abs(inputImage(i, j+1, c) - inputImage(i, j, c));
                
                if dU >= threshold || dD >= threshold || dL >= threshold || dR >= threshold
                    zoomedImage((i-1)*zoomFactor+1:i*zoomFactor, (j-1)*zoomFactor+1:j*zoomFactor, c) = ...
                        repmat(inputImage(i, j, c), zoomFactor, zoomFactor);
                else
                    % Bilinear interpolation
                    for m = 0:zoomFactor-1
                        for n = 0:zoomFactor-1
                            t1 = m / (zoomFactor-1);
                            t2 = n / (zoomFactor-1);

                            if i+1 <= M && j+1 <= N
                                f00 = double(inputImage(i, j, c));
                                f10 = double(inputImage(i+1, j, c));
                                f01 = double(inputImage(i, j+1, c));
                                f11 = double(inputImage(i+1, j+1, c));

                                zoomedImage((i-1)*zoomFactor+m+1, (j-1)*zoomFactor+n+1, c) = ...
                                    (1-t1)*(1-t2)*f00 + t1*(1-t2)*f10 + (1-t1)*t2*f01 + t1*t2*f11;
                                    imwrite(zoomedImage,"zoomed_image_soloturk.jpg");

                            else
                                zoomedImage((i-1)*zoomFactor+m+1, (j-1)*zoomFactor+n+1, c) = ...
                                    inputImage(i, j, c); % Boundary case
                                    imwrite(zoomedImage,"zoomed_image_soloturk.jpg"); 

                            end
                        end
                    end
                end
            end
        end
    end
end
