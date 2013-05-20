function[avggen] = core(ampsize,P,ssmix)

clear 

%% parameter values

% binary flags
plotreal = 0;
plotend = 1;
randenv = 0;

% parameters constructing the space to characterize
if nargin < 1
    ampsize = 2; % amplitude of fluctuations
    P = 25; % period 
    ssmix = 0.9; % square / sinusoid mixing proportion    
elseif nargin < 2
    P = 4; % period 
    ssmix = 0.9; % square / sinusoid mixing proportion
elseif nargin < 3
    ssmix = 0.9; % square / sinusoid mixing proportion
end

mutrate = .1;
mutmag = [0.05, 0.05];

popsize = 100; % 1000 is base
k = 1;

% stable parameters
maxtime = 10^3; % 10^5/2 is a good runtime
tS = 0.2; % time step

%time = linspace(1,tS*maxtime,maxtime);
time = 1:maxtime;

if randenv
    % Env = ampsize.*(round(rand(length(time),1)').*2 - 1);
    Env = ampsize.*(rand(length(time),1)'.*2 - 1);
else
    Env1 = ampsize.*(-1).^(round(time./P));
    Env2 = ampsize.*cos(time.*(pi./P));
    Env = ssmix*Env1 + (1-ssmix)*Env2;
end

Pop = zeros(popsize,3);
Pop(1,1) = 1; %isogenic initial pop
Pop(1,2) = 0; %center at mean
Pop(1,3) = 0.1;

avggen = zeros(maxtime,1);
Hmean = zeros(maxtime,1);
extinct = 0.001;
newstrain = 0.01;

%% time loop

for i = 1:maxtime
    
    %Population growth
    temp3 = find(Pop(:,1) ~=0);
    Pop(temp3,1) = Pop(temp3,1).*exp((normpdf(Env(i),Pop(temp3,2),Pop(temp3,3)))./(normpdf(0,0,Pop(temp3,3))).*(k./(Pop(temp3,3).^2+k)));
    Pop(:,1) = Pop(:,1)./sum(Pop(:,1));
    
    %Calculate average stdev
    avggen(i) = sum(Pop(:,1).*Pop(:,3));

    %extinction
    Pop(Pop(:,1)<extinct) = 0;
        
    %Mutation
    if sum(Pop(:,1)~=0) < popsize
        if rand(1) < mutrate
            temp = find(Pop(:,1)>0);
            newmut = randperm(sum(Pop(:,1)>0));
            temp2 = find(Pop(:,1) == 0);
            Pop(temp2(1),1) = newstrain;
            Pop(temp2(1),2) = mutmag(1).*randn(1)+Pop(temp(newmut(1)),2);
            Pop(temp2(1),3) = abs(mutmag(2).*randn(1)+Pop(temp(newmut(1)),3));
        end
    end
%     
%     if rem(i,1000) == 0
%         figure(1)
%         bar(sort(Pop(:,1),'descend'))
%     end

    if plotreal
    if rem(i,1000) == 0
        figure(1)
%        bar(sort(Pop(:,1),'descend'))
        [varS,I] = sort(Pop(:,3));
        stem(varS(varS~=0),Pop(I(varS~=0),1));
    end
    end

end

%% plotting

if plotend
    figure(2)
    plot(avggen)
    figure(3)
    [varS,I] = sort(Pop(:,3));
    stem(varS(varS~=0),Pop(I(varS~=0),1));
    figure(4)
    plot(Env(1,1:50),'ko')
    figure(5)
    plot(Env,'ko')
end
