function [Y,active,centres] = simulateSEMG(mu,N,stdWhite,stdPoiss,nTemplate)
%Simulates a SEMG chain without crosstalk
%Inputs:
% mu, mean interarrival time of pulses
% N, number of pulses
% stdWhite, stdev of added white noise
% stdPoiss, stdev of added poisson noise 
% nTemplate, size of pulse template to use in samples
%Outputs:
% Y, simulated data
% active, locations of pulses
% centres, central points of the pulses

fish = poissrnd(mu,[1,N]);
if isempty(nTemplate)
    nTemplate = 240;
end
template = mexihat(-5,5,nTemplate);
prototype = ones(1,sum(fish)+length(fish));
count = 0;
for i = 1:length(fish)
    prototype(count+1:count+fish(i)) = 0;
    count = 1+ count + fish(i);
end
%prototype = [0,prototype,0];
count = 1;
MUAPS = cell(1,N);
centres = upsample(prototype,nTemplate);

for i = 1:length(prototype)
    if prototype(i) == 1
        center = zeros(size(prototype));
        center(i) = 1;
        
        
        sfEMD = 3;
        [IMF,~,~,~] = SWEMD_LS(randn(1,ceil(nTemplate/sfEMD)),[],[],[],[],[],[],[]);
        %recons = sum(IMF(:,2:3),2);
        recons = zeros(size(IMF(:,1)));
        recons = recons + IMF(:,1)*0.1;
        recons = recons + IMF(:,2)*0.8;
        recons = recons + IMF(:,3)*1.2;
        recons = recons + IMF(:,4)*0.3;
        recons = resample(recons',sfEMD,1);
        MUAPS{count} = conv(template.*recons(1:length(template)),upsample(center,nTemplate));
        
        %MUAPS{count} = conv(template.*(randn(1,nTemplate)),upsample(center,nTemplate));
        
        %{
        modWav = template.*(randn(1,nTemplate));
        [IMF,~,~,~] = SWEMD_LS(modWav,[],[],[],[],[],[],[]);
        modWav = sum(IMF(:,3:3),2);
        MUAPS{count} = conv(modWav,upsample(center,nTemplate));
        %}
        
        %{
        model = arima('Constant',0,'AR',{0.5,0.01},'Variance',.001);
        modWav = randn(1,nTemplate);model.simulate(nTemplate)';
        [IMF,~,~,~] = SWEMD_LS(modWav,[],[],[],[],[],[],[]);
        modWav = sum(IMF(:,2:3),2)';
        MUAPS{count} = conv(template.*modWav,upsample(center,nTemplate));
        %}
        
        
        %MUAPS{count} = conv(template,upsample(temp,nTemplate));
        
        %{
        modTemplate = template.*(randn(1,nTemplate));
        [IMF,~,~,~] = SWEMD_LS(modTemplate,[],[],[],[],[],[],[]);
        recons = sum(IMF(:,3:end),2);
        MUAPS{count} = conv(recons,upsample(temp,nTemplate));
        %}
        count = count+1;
    end
end

Y = zeros(size(MUAPS{1}));
for i = 1:N
    Y = Y + MUAPS{i};
end
nAdd = randn(size(Y))*stdWhite+stdPoiss*randn(size(Y)).*poissrnd(0.05,size(Y));
active = maFilter(abs(Y),5)>0.01;
Y = Y + nAdd;
Y = Y * 10^-4;
SNR = snr(Y,nAdd);
