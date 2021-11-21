p = phantom('Modified Shepp-Logan',256);
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

subplot(2,2,1);
imshow(img1, []);
subplot(2,2,2);
imshow(img2, []);
subplot(2,2,3);
imshow(img3, []);
subplot(2,2,4);
imshow(img4, []);

k1=fft2(img1);
k2=fft2(img2);
k3=fft2(img3);
k4=fft2(img4);

x1=zeros(86,256);
x2=zeros(86,256);
x3=zeros(86,256);
x4=zeros(86,256);

for j=1:86
x1(j,:)=k1(3*j-2,:);
x2(j,:)=k2(3*j-2,:);
x3(j,:)=k3(3*j-2,:);
x4(j,:)=k4(3*j-2,:);
end
H_1m=(x1+x2+x3+x4)/4;

for j=1:85
x1(j,:)=k1(3*j-1,:);
x2(j,:)=k2(3*j-1,:);
x3(j,:)=k3(3*j-1,:);
x4(j,:)=k4(3*j-1,:);
end

H0m=(x1+x2+x3+x4)/4;

for j=1:85
x1(j,:)=k1(3*j,:);
x2(j,:)=k2(3*j,:);
x3(j,:)=k3(3*j,:);
x4(j,:)=k4(3*j,:);
end

H1m=(x1+x2+x3+x4)/4;
recon=zeros(256);

for j=1:85
    recon(3*j-2,:)=H_1m(j,:);  
    recon(3*j-1,:)=H0m(j,:);   
    recon(3*j,:)=H1m(j,:); 
end

figure;
imshow(ifft2(recon));