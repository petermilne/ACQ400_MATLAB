% SPAN 0-5V
% dc0(1:16384) = -32768; dc0 = dc0';
% dc1(1:16384) = -19661; dc1 = dc1';
% dc2(1:16384) = -6554; dc2 = dc2';
% dc2_5(1:16384) = 0; dc2_5 = dc2_5';
% dc3(1:16384) = 6554; dc3 = dc3';
% dc4(1:16384) = 19661; dc4 = dc4';
% dc5(1:16384) = 32768; dc5 = dc5';

% SPAN +/- 5V
dc0(1:16384) = 0; dc0 = dc0';
dc1(1:16384) = 6554; dc1 = dc1';
dc2(1:16384) = 13107; dc2 = dc2';
dc2_5(1:16384) = 16384; dc2_5 = dc2_5';
dc3(1:16384) = 19660; dc3 = dc3';
dc4(1:16384) = 26214; dc4 = dc4';
dc5(1:16384) = 32768; dc5 = dc5';


%dc10(1:16384) = 32768; dc10 = dc10';