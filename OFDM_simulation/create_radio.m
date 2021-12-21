function [outputArg1,outputArg2] = create_radio(inputArg1,inputArg2)
%CREATE_RADIO Summary of this function goes here
%   Detailed explanation goes here
connectedRadios = findsdru;
if strncmp(connectedRadios(1).Status, 'Success', 7)
  radioFound = true;
  switch connectedRadios(1).Platform
    case {'B200','B210'}
      address = connectedRadios(1).SerialNum;
      platform = connectedRadios(1).Platform;
    case {'N200/N210/USRP2'}
      address = connectedRadios(1).IPAddress;
      platform = 'N200/N210/USRP2';
    case {'X300','X310'}
      address = connectedRadios(1).IPAddress;
      platform = connectedRadios(1).Platform;
  end
else
  radioFound = false;
  address = '192.168.10.2';
  platform = 'N200/N210/USRP2';
end

WiFiFreqList = [2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484];

Rx.Fs = 20e6; % sps
Rx.USRPCenterFrequency = 2.45e9; %Hz
Rx.USRPGain = 20; % dB max 76dB
Rx.USRPFrameLength = 200000;
Rx.USRPTransportDataType = 'double';

Fs,Fc,gain,FrameLength,
radio = comm.SDRuReceiver(...
                'Platform',             platform, ...
                'SerialNum',            address, ...
                'CenterFrequency',      Rx.USRPCenterFrequency, ...
                'Gain',                 Rx.USRPGain, ...
                'SamplesPerFrame',      Rx.USRPFrameLength, ...
                'OutputDataType',       Rx.USRPTransportDataType);

end

