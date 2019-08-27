clear all
close all
clc

% Numero de Bits
num_bits = 1e6;

% Taxa de simbolos (equivalente a taxa de transmissão)
Rs = 100e3;

% Efeito Doppler
fd = 300;

% K da formula Rice, quanto maior menor a influencia do multipercurso
k = 1;

%Ordem da modulação (representa a eração de bits)
M = 2; 

% Gerando Iinformação a ser transmitida (utilizando o BPSK)
info = randint(num_bits,1,M);
info_mod = pskmod(info,M);

% Gerando os canais de rayleigh e Rice
canal_ray = rayleighchan(1/Rs, fd);
canal_ric = ricianchan(1/Rs,fd,k);

canal_ray.StoreHistory = 1;
canal_ric.StoreHistory = 1;

% Sinal Transmitido do Transmissor
sinal_rec_ray = filter(canal_ray, info_mod);
sinal_rec_ric = filter(canal_ric, info_mod);

% Ganho dos canais
ganho_ray = canal_ray.PathGains;
ganho_ric = canal_ric.PathGains;

for SNR = 0:30
    % Adicionando o ruido branco
    Rxray_awgn = awgn(sinal_rec_ray,SNR);
    Rxric_awgn = awgn(sinal_rec_ric,SNR);
    
    % Equalizando o canal
    SinalEqRay = Rxray_awgn./ganho_ray;
    SinalEqRic = Rxric_awgn./ganho_ric;

    %Demodulando
    Dem_Ray = pskdemod(SinalEqRay,M);
    Dem_Ric = pskdemod(SinalEqRic,M);
    
    % Calculando o numero de erros
    [num_ray(SNR + 1), taxa_ray(SNR + 1)] = symerr(info,Dem_Ray); % Compara cada posição e calcula o numero de erros e a taxa
    [num_ric(SNR + 1), taxa_ric(SNR + 1)] = symerr(info,Dem_Ric);
end

figure(1)
% Plotando em escala logaritma no Y
semilogy([0:30],taxa_ray,'r',[0:30],taxa_ric,'b');
grid on

