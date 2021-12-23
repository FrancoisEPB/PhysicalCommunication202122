htx = 16; %m
hrx = 12;%m
Gtx = db2mag(76); %dB -> gain
Grx = Gtx; %gain
Ptx = 100; %mW
d =320;%m
high_f = 6e9;%Hz
low_f = 900e6;%Hz
c = 3e8;%m/s

d_breakpoint_low_f  = 4*pi*htx*hrx*low_f/c

d_breakpoint_high_f  = 4*pi*htx*hrx*high_f/c

f_breakpoint = d*c/(4*pi*htx*hrx)

disp('received power in mW')
Prx = Ptx*Grx*Gtx*(htx^2)*(hrx^2)/(d^4)

disp('received power in dBm')

PrxdBm = pow2db(Prx)

disp('Path loss in dB')

Ploss =  pow2db(Ptx) - PrxdBm

disp('Okumura-Hata model')
n = 4.49 -0.655*log(htx);%model order here similar to OTG model
d0 = 1000;%m
a = 3.2*(log10(11.75*hrx))^2 -4.97;

Ploss_OH = 69.55 +n*10*log(d/d0) +26.16*log10(low_f/1e6)-13.82*log10(htx)-a


disp('LOS communications')
n = 2;
Ploss_LOS = 10*n*log10(d)+20*log10(low_f) -147.5