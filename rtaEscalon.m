pkg load control
SPICE = dlmread('rtaSenoidalAlto.txt',',',0,0);
plot(SPICE(:,1), SPICE(:,2), 'Color', 'b', 'LineWidth', 1, 'g');
axis ([0, 0.3]);
grid on;
xlabel ("Tiempo [s]");
ylabel ("Tensión [V]");
title ("Respuesta a senoidal de frecuencia w = 5000r/s LTSpice");
hold on;
w0 = 5000;
f0 = w0/(2*pi);
s = tf('s');
H = 3948*s^2/(s^4+88.86*s^3+7.935*10^5*s^2+3.508*10^7*s+1.559*10^11);
%Hn = 3637*s^2/((s^2 + 42.55*s + 614.30^2)*(s^2+46.51*s+656.34^2))
[sin_f0,t_f0] = gensig("SIN" , 1/f0 , 250/f0); 
[y_sin_f0,t_sin_f0] = lsim(H,sin_f0,t_f0); 
%[y1_sin_f0,t1_sin_f0] = lsim(Hn,sin_f0,t_f0); 
%[y, t] = step (H);
plot(t_sin_f0, y_sin_f0, 'Color', 'r', 'LineWidth', 1);
%plot(t1_sin_f0, y1_sin_f0, 'Color', 'b', 'LineWidth', 1);
legend("Spice", "H");
