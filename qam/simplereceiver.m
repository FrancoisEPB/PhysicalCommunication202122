clear all
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

Rx.MasterClockRate = 100e6;  %Hz
Rx.Fs = 1e6; % sps
Rx.USRPDecimationFactor = Rx.MasterClockRate/Rx.Fs;
Rx.USRPGain = 76; % dB max 76dB
Rx.USRPFrameLength = 200000;
Rx.USRPTransportDataType = 'double';

%Rx.USRPCenterFrequency = WiFiFreqList(6)*1e6; %Hz
Rx.USRPCenterFrequency = 2.4e9; %Hz
radio = comm.SDRuReceiver(...
                'Platform',             platform, ...
                'SerialNum',            address, ...
                'MasterClockRate',      Rx.MasterClockRate, ...
                'CenterFrequency',      Rx.USRPCenterFrequency, ...
                'Gain',                 Rx.USRPGain, ...
                'DecimationFactor',     Rx.USRPDecimationFactor, ...
                'SamplesPerFrame',      Rx.USRPFrameLength, ...
                'OutputDataType',       Rx.USRPTransportDataType);

% Initialize variables
len = uint32(0);
rcvdSignal = complex(zeros(Rx.USRPFrameLength,1));
currentTime = 0;
maxIFrame = 300;
Rx.allRcvdSignals=zeros(Rx.USRPFrameLength,maxIFrame);
pAGC = comm.AGC(...
    "DesiredOutputPower", 2, ...
    'AveragingLength',    50, ...
    'MaxPowerGain',       20);
pRxFilter = comm.RaisedCosineReceiveFilter( ...
    'RolloffFactor',            0.5, ...
    'FilterSpanInSymbols',      10, ...
    'InputSamplesPerSymbol',    2, ...
    'DecimationFactor',         1);
pCoarseFreqEstimator = comm.CoarseFrequencyCompensator( ...
    'Modulation',               'QAM', ...
    'Algorithm',                'FFT-based', ...
    'MaximumFrequencyOffset',   6e3, ....
    'FrequencyResolution',      10, ...
    'SampleRate',               Rx.Fs);
pCoarseFreqCompensator = comm.PhaseFrequencyOffset( ...
    'PhaseOffset',              0, ...
    'FrequencyOffsetSource',    'Input port', ...
    'SampleRate',               Rx.Fs);

pMeanFreqOff = 0;
            
pCnt = 0;
            
pFineFreqCompensator = comm.CarrierSynchronizer( ...
     'Modulation',               'QAM', ...
     'ModulationPhaseOffset',    'Auto', ...
     'SamplesPerSymbol',         3, ...
     'DampingFactor',            1, ...
     'NormalizedLoopBandwidth',  0.01);

for iFrame=1:maxIFrame
    % Keep accessing the SDRu System object output until it is valid

%     Rx.USRPCenterFrequency = WiFiFreqList(iFrame)*1e6; %Hz
%     radio = comm.SDRuReceiver(...
%                 'Platform',             platform, ...
%                 'SerialNum',            address, ...
%                 'MasterClockRate',      Rx.MasterClockRate, ...
%                 'CenterFrequency',      Rx.USRPCenterFrequency, ...
%                 'Gain',                 Rx.USRPGain, ...
%                 'DecimationFactor',     Rx.USRPDecimationFactor, ...
%                 'SamplesPerFrame',      Rx.USRPFrameLength, ...
%                 'OutputDataType',       Rx.USRPTransportDataType);

    while len <= 0
        [rcvdSignal, len, overrun] = radio();
    end
    if (overrun)
        warning("Overrun!!!")
    end
    % Process signal
    %AGCSignal = pAGC(rcvdSignal);
    %RCRxSignal = pRxFilter(AGCSignal);
    %[~, freqOffsetEst] = pCoarseFreqEstimator(RCRxSignal);
    %freqOffsetEst = (freqOffsetEst + pCnt * pMeanFreqOff)/(pCnt+1);
    %pCnt = pCnt + 1;            % update state
    %pMeanFreqOff = freqOffsetEst;
    %coarseCompSignal = pCoarseFreqCompensator(AGCSignal, -freqOffsetEst);
    %fineCompSignal = pFineFreqCompensator(coarseCompSignal);
    
    symbolmap = [ 2 3 1 0 6 7 5 4 14 15 13 12 10 11 9 8];
    % Recovering the message from the data
    message = qam2char(rcvdSignal, symbolmap, 16);
    fprintf('%s', message);

    Rx.allRcvdSignals(:,iFrame)=rcvdSignal;
    %disp([iFrame len]);
    len=uint32(0);
    %pause(0.5)
    %plot(fftshift(20*log10(abs(fft(fineCompSignal)))),'b*')
    %plot(real(rcvdSignal), imag(rcvdSignal),'*')
    %shg;
end


release(radio);