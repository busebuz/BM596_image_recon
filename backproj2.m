P = phantom('Modified Shepp-Logan',256);
figure;
imshow(P, [])

theta = 0:179; %180 projections
theta1 = deg2rad(theta);
%radon transform
R1 = radon(P,theta);

filt = fftshift(fftn(R1));

n = size(R1,1);
nproj = size(R1,2);

center = round(n/2);

[X,Y] = meshgrid(round(-n/2)+1:round(n/2)-1);

rec_img = zeros(n,n);

for i= 1:nproj
    cur_pts = round(center + X.*cos(theta1(i)) + Y.*sin(theta1(i)));
    
    new_img = zeros(n,n);
    in_bounds = find((cur_pts >0) & (cur_pts<=n));
    new_pts = cur_pts(in_bounds);
    
    new_img(in_bounds) = filt(new_pts(:),i);
    rec_img = rec_img + new_img;
end
rec_img = rec_img./nproj;


figure;
imshow(imrotate(real(rec_img), 90))
