function dcm = quatToDcm(q)

dcm = zeros(3);

dcm(1, 1) = q(1)^2 + q(2)^2 - q(3)^2 - q(4)^2;
dcm(1, 2) = 2*(q(2)*q(3) + q(1)*q(4));
dcm(1, 3) = 2*(q(2)*q(4) - q(1)*q(3));
dcm(2, 1) = 2*(q(2)*q(3) - q(1)*q(4));
dcm(2, 2) = q(1)^2 - q(2)^2 + q(3)^2 - q(4)^2;
dcm(2, 3) = 2*(q(3)*q(4) + q(1)*q(2));
dcm(3, 1) = 2*(q(2)*q(4) + q(1)*q(3));
dcm(3, 2) = 2*(q(3)*q(4) - q(1)*q(2));
dcm(3, 3) = q(1)^2 - q(2)^2 - q(3)^2 + q(4)^2;
