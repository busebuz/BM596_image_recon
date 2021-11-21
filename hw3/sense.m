p = phantom('Modified Shepp-Logan',256);
nx = 256;
ny = 256;
sd=1/2; 
RF=2; 

x=linspace(0,1,nx); 
y=linspace(0,1,ny);

x1=[1 1 1 0 0 0 1 0]; 
y1=[0 0 0 1 1 1 0 1]; 

%create sensitivities
S = zeros(8, nx, ny);
reduced =zeros(8,nx/RF,ny);
partial =zeros(8, nx, ny);
reduced =zeros(8, nx/RF, ny);
halved =zeros(8, nx/RF, ny);

for k=1:8
    for i=1:nx
        for j=1:ny
            S(k,i,j) = 1/exp(((x(i)-x1(k)).^2+(y(j)-y1(k)).^2)/(2*(sd^2)));
        end
    end
end

for k=1:8
    partial(k,:,:) = squeeze(S(k,:,:)).*p;
    kspace(k,:,:)=fftshift(fft2(partial(k,:,:))); 
    for i=1:(ny/RF)
        halved(k,i,:)=kspace(k,RF*i,:);
    end
    aliased(k,:,:)=ifft2(ifftshift(halved(k,:,:)));
end

subplot(4,2,1);
imshow(squeeze(partial(1,:,:)), []);
subplot(4,2,2);
imshow(squeeze(partial(2,:,:)), []);
subplot(4,2,3);
imshow(squeeze(partial(3,:,:)), []);
subplot(4,2,4);
imshow(squeeze(partial(4,:,:)), []);
subplot(4,2,5);
imshow(squeeze(partial(5,:,:)), []);
subplot(4,2,6);
imshow(squeeze(partial(6,:,:)), []);
subplot(4,2,7);
imshow(squeeze(partial(7,:,:)), []);
subplot(4,2,8);
imshow(squeeze(partial(8,:,:)), []);


sense = zeros(nx,ny);
for i=1:nx/RF
    for j=1:ny
        for k=1:8
            %conjaguate
           A(k,1)=aliased(k,i,j);
           S_(k,1)=S(k,i,j);
           S_(k,2)=S(k,i+(nx/RF),j);
        end
        U=pinv(S_); 
        V=U*A;
        sense(i,j)=sense(i,j)+V(1); 
        sense(i+nx/RF,j)=sense(i+nx/RF,j)+V(2);
    end
end

figure;
imagesc(real(squeeze(aliased(1,:,:))));
figure;
imagesc(real(squeeze(aliased(8,:,:))));

figure;
imagesc(abs(sense)); 
colormap(bone);