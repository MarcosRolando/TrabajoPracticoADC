pkg load control
SPICE = dlmread('tpSimulacion.txt',',',0,0);
semilogx(2*pi*SPICE(:,1), SPICE(:,3), 'Color', 'b', 'LineWidth', 1, 'g');
axis ([10, 10^4, -200, 200]);
grid on;
xlabel ("Frequency [rad/s]");
ylabel ("Phase [degree]");
title ("Diagrama de Bode del LTSpice vs H(s)");
hold on;
s = tf('s');
H = 3948*s^2/(s^4+88.86*s^3+7.935*10^5*s^2+3.508*10^7*s+1.559*10^11);
[mag, pha, w] = bode (H);
semilogx(w, pha, 'Color', 'r', 'LineWidth', 1);
legend("Spice", "H");
