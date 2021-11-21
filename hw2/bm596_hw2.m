p = phantom('Modified Shepp-Logan',256);
f=fftshift(fftn(p));

%zero filling
partial_k= zeros(256,256);
partial_k(1:144,:)= f(1:144,:);
pk = ifftn(ifftshift(partial_k));

sym = zeros(256,256);
sym(113:144, :) = f(113:144,:);
p_sym = ifftn(ifftshift(sym));
zerofilled = pk .* exp(-i*angle(p_sym));

corr = fftshift(fftn(zerofilled));
conj_ = conj(corr);
final_zf = ifftn(ifftshift(conj_));

%homodyne recon
weighted_f = zeros(256,256);
weighted_f(1:112,:) = 0;
weighted_f(113:144,:) = 1;
weighted_f(145:256,:) = 2;

mpk= ifftn(ifftshift(weighted_f .* partial_k));
homodyne= mpk.* exp(-1i*angle(p_sym));
homodyne = real(homodyne);

%pocs

%try for 10 50 100 iterations
for turn = 1:100
    f_cons = pk; 
    p_cons_image = abs(f_cons) .* exp(1i*angle(p_sym));
    temp = (fftshift(fft2(p_cons_image)));
    f_cons(145:256,:) = temp(145:256,:);
end

figure;
subplot(1,4,1)
imshow(p);
title("original");
subplot(1,4,2)
imshow(imrotate(final_zf,180))
title("zero-filling");
subplot(1,4,3)
imshow(homodyne)
title("homodyne recon")
subplot(1,4,4)
imshow(real(p_cons_image));
title("pocs")


