%% This code aim to send a basic sine wave through the USRP device

% we will use simple function of the package USRP comm

%% Implementation 

radio = comm.SDRuReceiver(); % create de receiver object 

data  = radio(); %receiving data from the antenna

for i = 1:100
    plot(data);
    pause(1);
end