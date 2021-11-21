
P = phantom('Modified Shepp-Logan',256);
figure;
imshow(P)
title('Original image')


%different number of projections
theta1 = 0:179 %180 projections
theta2 = 0:10:179 % 18 projections
theta3 = 0:60:179 % 3 projections

%radon transform
R1 = radon(P,theta1);
R2 = radon(P,theta2);
R3 = radon(P,theta3);

%filtered backprojection for different number of projections
I1 = iradon(R1,theta1, 'none');
I2 = iradon(R2,theta2, 'none');
I3 = iradon(R3,theta3, 'none');


%different noise
RP = radon(P,theta1);
RN1 = RP .*(1 + 0.2*randn(size(RP)));
RN2 = RP .*(1 + 0.5*randn(size(RP)));
RN3 = RP .*(1 + 0.9*randn(size(RP)));

%filtered backprojection for noisy transforms
I4 = iradon(RN1,theta1, 'none');
I5 = iradon(RN2,theta1, 'none');
I6 = iradon(RN3,theta1, 'none');


hold on;
figure;
subplot(2,3,1)
imshow(I1, [])
title('180 projections, no noise')
subplot(2,3,2)
imshow(I2, [])
title('18 projections, no noise')
subplot(2,3,3)
imshow(I3, [])
title('3 projections, no noise')
subplot(2,3,4)
imshow(I4, [])
title('180 projections, 0.2 noise')
subplot(2,3,5)
imshow(I5, [])
title('180 projections, 0.5 noise')
subplot(2,3,6)
imshow(I6, [])
title('180 projections, 0.9 noise')
