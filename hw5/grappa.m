p = phantom('Modified Shepp-Logan',256);
figure;
imshow(p);

nx = 256;
ny = 256;
sd=1/2; 

x=linspace(0,1,nx); 
y=linspace(0,1,ny);

x1=[1 1 0 0]; 
y1=[0 1 0 1]; 

%create sensitivities
S = zeros(4, nx, ny);
partial =zeros(4, nx, ny);

for k=1:4
    for i=1:nx
        for j=1:ny
            S(k,i,j) = 1/exp(((x(i)-x1(k)).^2+(y(j)-y1(k)).^2)/(2*(sd^2)));
            
        end
    end
    partial(k,:,:) = squeeze(S(k,:,:)).*p;
end

img1 = squeeze(partial(1,:,:));
img2 = squeeze(partial(2,:,:));
img3 = squeeze(partial(3,:,:));
img4 = squeeze(partial(4,:,:));

%different images from 4 channels
figure;
subplot(2,2,1);
imshow(img1, []);
subplot(2,2,2);
imshow(img2, []);
subplot(2,2,3);
imshow(img3, []);
subplot(2,2,4);
imshow(img4, []);

%original kspace
k1=fftshift(fft2(img1));
k2=fftshift(fft2(img2));
k3=fftshift(fft2(img3));
k4=fftshift(fft2(img4));

%undersampled kspace RF=3

k1_u = zeros(size(k1));
k2_u = zeros(size(k2)); 
k3_u = zeros(size(k3)); 
k4_u = zeros(size(k4)); 

k1_u(1:3:end,:) = k1(1:3:end,:);
k2_u(1:3:end,:) = k2(1:3:end,:);
k3_u(1:3:end,:) = k3(1:3:end,:);
k4_u(1:3:end,:) = k4(1:3:end,:);

%acs lines
acs_c1 = [k1(128:129,:)]';
acs_c2 = [k2(128:129,:)]';
acs_c3 = [k3(128:129,:)]';
acs_c4 = [k4(128:129,:)]';

figure;
subplot(2,2,1)
imshow(abs(acs_c1'),[1 100]);
subplot(2,2,2)
imshow(abs(acs_c2'),[1 100]);
subplot(2,2,3)
imshow(abs(acs_c3'),[1 100]);
subplot(2,2,4)
imshow(abs(acs_c4'),[1 100]);


src1 = [];
src2 = [];
src3 = [];
src4 = [];
for i=1:3:10
    src1 = [src1; k1_u(nx/2 -5 +i,:)];
    src2 = [src2; k2_u(nx/2 -5 +i,:)];
    src3 = [src3; k3_u(nx/2 -5 +i,:)];
    src4 = [src4; k4_u(nx/2 -5 +i,:)];
end

n1 = pinv(src1') * acs_c1;
n2 = pinv(src2') * acs_c2;
n3 = pinv(src3') * acs_c3;
n4 = pinv(src4') * acs_c4;

I = zeros(nx,ny,4);

for i=1:3:nx-6
    new_c1= [];
    new_c2= [];
    new_c3= [];
    new_c4= [];
    
    for j=0:2:6
    
        new_c1=[new_c1; k1_u(i+j,:)];
        new_c2=[new_c2; k2_u(i+j,:)];
        new_c3=[new_c3; k3_u(i+j,:)];
        new_c4=[new_c4; k4_u(i+j,:)];
    end
    
    I(i+1:i+2,:,1)=transpose(new_c1'*n1);
    I(i+1:i+2,:,2)=transpose(new_c2'*n2);
    I(i+1:i+2,:,3)=transpose(new_c3'*n3);
    I(i+1:i+2,:,4)=transpose(new_c4'*n4);
    
end

real_img = ifft2(fftshift(I));
recon_img = sqrt( real_img(:,:,1).^2 + real_img(:,:,2).^2 + real_img(:,:,3).^2 + real_img(:,:,4).^2);

figure;
imshow(real(recon_img),[]); 
