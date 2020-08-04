%% Limpio todo
clear all; %limpia variables
close all; % cierra toda ventana/grafico abierta
clc; % limpia la consola

%graphics_toolkit('gnuplot');

xcyan = (1/255)*[0,153,153];
dblue = (1/255)*[0,0,51];
%% Cargo paquete de control y simbolico (para octave)
pkg load control
%pkg load symbolic
%pkg list
%pkg -forge install <paquete>

%%%%%%%%%%%%%Ejercicio j%%%%%%%%%%%%%

%hayo las expresiones analiticas de las respuestas al impulso y al escalon:

%constantes de los componentes

%%
% Graficos

% La variable es s
 s = tf('s');
 
 H = 3948*s^2/(s^4+88.86*s^3+7.935*10^5*s^2+3.508*10^7*s+1.559*10^11) 
 
%rta al impulso:

[y,t] = impulse(H);
%deltat=t[2]-t[1]
%diff(y)/deltat
figure(1)
plot(t, y,'linewidth',2,'color',xcyan);
title("Respuesta al impulso del sistema");
xlabel("Tiempo (s)");
ylabel("Tension (V)");
grid on
grid minor

%%
% Respuesta al escalon
[y_step,t_step] = step(H);

figure(2)
plot(t_step, y_step,'linewidth',2,'color',xcyan);
title("Respuesta al escalon del sistema");
xlabel("Tiempo (s)");
ylabel("Tension (V)");
grid on
grid minor


%%
%%% Respuestas a ambas entradas
figure(3)
plot(t, y,'linewidth',2,'color',xcyan)
hold on
% escalada la rta al escalon * 500
plot(t_step,500*y_step,'linewidth',2,'color','r')
title("Respuesta Step Vs. Impulse")
legend(["rta_{impulso}","rta_{escalon}"])
grid on
grid minor
hold off


%%

w0 = 5000;
f0 = w0/(2*pi);
%%% Respuesta a la cuadrada
% Defino una cuadrada de periodo 1/f0 y dura 10 periodos
[cuad,t] = gensig("SQUARE" , 1/f0 , 15/f0); 
%Ahora busco la respuesta al filtro con esto:
figure(4)
[y_cuad,t_cuad] = lsim(H,cuad,t); 
plot(t_cuad,y_cuad, 'linewidth',2,'color',xcyan)
hold on
plot(t,cuad, 'color','r')
xlabel("Tiempo [s]")
ylabel("Tension [V]")
title("Respuesta a la cuadrada f0")
grid on
grid minor
hold off


%%
% Defino una cuadrada de periodo 10/f0 y dura 5 periodos
[cuad,t] = gensig("SQUARE" , 10/f0 , 80/f0); 
%Ahora busco la respuesta al filtro con esto:
figure(5)
[y_cuad,t_cuad] = lsim(H,cuad,t); 
plot(t_cuad,y_cuad, 'linewidth',2,'color',xcyan)
hold on
plot(t,cuad,'color','r')
xlabel("Tiempo [s]")
ylabel("Tension [V]")
title("Respuesta a la cuadrada f0/10")
grid on
grid minor
hold off



%%
% Defino una cuadrada de periodo 1/10f0 y dura 5 periodos
[cuad,t] = gensig("SQUARE" , 1/(10*f0) , 50/(10*f0)); 
%Ahora busco la respuesta al filtro con esto:
figure(6)
[y_cuad,t_cuad] = lsim(H,cuad,t); 
plot(t_cuad,y_cuad, 'linewidth',2,'color',xcyan)
hold on
plot(t,cuad,'color','r')
xlabel("Tiempo [s]")
ylabel("Tension [V]")
title("Respuesta a la cuadrada 10f0")
grid on
grid minor
hold off
%%
%%% Respuesta a senoidales

% genero senales
[sin_f0_10,t_f0_10] = gensig("SIN" , 10/f0 , 5*10/f0); 
[sin_10f0,t_10f0] = gensig("SIN" , 1/(10*f0) , 5*10/f0); 
[sin_f0,t_f0] = gensig("SIN" , 1/f0 , 25*10/f0); 

figure(7)
hold on
%genero respuestas a las senales
[y_sin_f0_10,t_sin_f0_10] = lsim(H,sin_f0_10,t_f0_10); 
[y_sin_10f0,t_sin_10f0] = lsim(H,sin_10f0,t_10f0); 
[y_sin_f0,t_sin_f0] = lsim(H,sin_f0,t_f0); 
% plots
%plot(t_sin_f0_10,y_sin_f0_10, 'linewidth',2)
%plot(t_sin_10f0,y_sin_10f0, 'linewidth',2)
plot(t_sin_f0,y_sin_f0, 'linewidth',2)

xlabel("Tiempo [s]")
ylabel("Tension [V]")
title("Respuesta a senoidal de frecuencia w = 5000r/s")
%legend(["f0/10","10f0","f0"])
grid on
grid minor

hold off