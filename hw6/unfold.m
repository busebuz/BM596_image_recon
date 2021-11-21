
p = phantom('Modified Shepp-Logan',256);
figure;
imshow(p)

kspace=fftshift(fft2(p));
nx=256

partial_k= zeros(256,256);
partial_k(1:2:end,:)= kspace(1:2:end,:);


img = ifft2(ifftshift(partial_k));

figure;
imshow(real(img))

middle = floor(nx/2);
for k=-middle+1:middle
    img(k+middle,:)= img(k+middle,:) + img(k+middle,:)*exp(-i*2*pi*k/nx);  
end

figure;
imshow(real(img)) 

plot(real(fft(img)))