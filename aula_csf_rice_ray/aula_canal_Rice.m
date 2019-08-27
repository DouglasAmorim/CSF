close all

clear all
clc

Rs = 100e3;
fd = 30;

%tau = [0 2 3 5]*1e-6;
%pdb = [-20 -10 -10 0];

num_bits = 1e5;
k = 10;

t - [0: 1/Rs: num_bits/Rs-(1/Rs)];

info = randint(1,num_bits,2);
info_mod = pskmod(info,2);

canal_ray = rayleighchan(1/Rs, 120, tau, pdb);
canal_ric = ricechan(1/Rs,fd,k);

canal_ray.StoreHistory = 1;
canal_ric.StoreHistory = 1;

sinal_rec_ray = filter(canal_ray, info_mod);
sinal_rec_ric = filter(canal_ric, info_mod);

ganho_ray = canal_ray.PathGains;
ganho_ric = canal_ric.PathGains;

figure(1)
subplot(211)
plot(t,20*log10(abs(ganho_ray)))
subplot(212)
plot(t,20*log10(abs(ganho_ric)))
