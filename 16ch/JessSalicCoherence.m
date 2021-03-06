% Coherence and coordinate
PFC_ch = 4;
VH_ch = 10;
DH_ch = 2;
[pks,locs]=findpeaks(aux1000);

ChannelsReg = [PFC_ch VH_ch DH_ch];

[Cdf,tc,fc]=ch_time(detrend(data1000(locs(1):locs(end)+50,DH_ch)),detrend(data1000(:,PFC_ch)),2000,1500,[1 20],1000);
[Cdv,tc,fc]=ch_time(detrend(data1000(locs(1):locs(end)+50,DH_ch)),detrend(data1000(:,VH_ch)),2000,1500,[1 20],1000);
[Cvf,tc,fc]=ch_time(detrend(data1000(locs(1):locs(end)+50,VH_ch)),detrend(data1000(:,PFC_ch)),2000,1500,[1 20],1000);

save Coherence Cdf Cdv Cvf tc fc ChannelsReg

%%
% Theta Coherence

T1 = [7 10];
for ii=1:length(tc)
    DFT1(ii,1)=mean(Cdf(fc>T1(1) & fc<T1(2),ii));
    DVT1(ii,1)=mean(Cdv(fc>T1(1) & fc<T1(2),ii));
    VFT1(ii,1)=mean(Cvf(fc>T1(1) & fc<T1(2),ii));
end

T2 = [4 7];
for ii=1:length(tc)
    DFT2(ii,1)=mean(Cdf(fc>T2(1) & fc<T2(2),ii));
    DVT2(ii,1)=mean(Cdv(fc>T2(1) & fc<T2(2),ii));
    VFT2(ii,1)=mean(Cvf(fc>T2(1) & fc<T2(2),ii));
end

if size(aux1000,2)>size(aux1000,1)
    aux1000=aux1000';
end

for ii=1:size(aux1000,2)
AA(ii)=mean(aux1000(:,ii));
end
AuxCh=find(AA>0);

[pks locs]=findpeaks(aux1000(:,AuxCh));
fps=1000/(locs(2)-locs(1));
TCoord=round(locs);

tc1000=tc*1000;
% Coord=Coord(1:length(TCoord),:);
%%
% Velocity
V(1)=0;
D(1)=0;
xx=Coord(1,1);
yy=Coord(1,2);
for ii=2:length(Coord)
    D(ii)=sqrt((Coord(ii,1)-xx)^2+(Coord(ii,2)-yy)^2);
    xx=Coord(ii,1);
    yy=Coord(ii,2);
end

V=[0;smooth(abs(diff(D)))];
%%
% Theta 1 coherences

figure(101)
subplot(2,2,1),
Corner=50;

DF=resample(smooth(DFT1,20),length(Coord),length(DFT1));
DF=DF(Corner:end-Corner);

    scatter(Coord(Corner:length(DF)+Corner-1,1),Coord(Corner:length(DF)+Corner-1,2),25,DF,'fill')
    colormap('jet')
    colorbar
    %caxis([0 1])

%     hold on
%     
%     plot(Coord(Corner,1),Coord(Corner,2),'k+')
%     plot(Coord(length(DF)+Corner-1,1),Coord(length(DF)+Corner-1,2),'k*')
%     
%     hold off

title('Dorsal PFC coherence')

subplot(2,2,2),

DF=resample(smooth(DVT1,20),length(Coord),length(DVT1));

DF=DF(Corner:end-Corner);

    scatter(Coord(Corner:length(DF)+Corner-1,1),Coord(Corner:length(DF)+Corner-1,2),25,DF,'fill')
    colormap('jet')
    colorbar
    %caxis([0 1])

title('Dorsal Ventral coherence')

subplot(2,2,3),

DF=resample(smooth(VFT1,20),length(Coord),length(VFT1));

DF=DF(Corner:end-Corner);

    scatter(Coord(Corner:length(DF)+Corner-1,1),Coord(Corner:length(DF)+Corner-1,2),25,DF,'fill')
    colormap('jet')
    colorbar
    %caxis([0 1])

title('Ventral mPFC coherence')


subplot(2,2,4),

DF=V/max(V);

DF=DF(Corner:end-Corner);

    scatter(Coord(Corner:length(DF)+Corner-1,1),Coord(Corner:length(DF)+Corner-1,2),25,DF,'fill')
    colormap('jet')
    colorbar
%    caxis([0 1])

title('Speed')

%%
% Theta 2 coherences

figure(102)
subplot(2,2,1),
Corner=50;

DF=resample(smooth(DFT2,20),length(Coord),length(DFT2));
DF=DF(Corner:end-Corner);

    scatter(Coord(Corner:length(DF)+Corner-1,1),Coord(Corner:length(DF)+Corner-1,2),25,DF,'fill')
    colormap('jet')
    colorbar
    %caxis([0 1])

%     hold on
%     
%     plot(Coord(Corner,1),Coord(Corner,2),'k+')
%     plot(Coord(length(DF)+Corner-1,1),Coord(length(DF)+Corner-1,2),'k*')
%     
%     hold off

title('Dorsal PFC coherence - T2')

subplot(2,2,2),

DF=resample(smooth(DVT2,20),length(Coord),length(DVT2));

DF=DF(Corner:end-Corner);

    scatter(Coord(Corner:length(DF)+Corner-1,1),Coord(Corner:length(DF)+Corner-1,2),25,DF,'fill')
    colormap('jet')
    colorbar
%    caxis([0 1])

title('Dorsal Ventral coherence - T2')

subplot(2,2,3),

DF=resample(smooth(VFT2,20),length(Coord),length(VFT2));

DF=DF(Corner:end-Corner);

    scatter(Coord(Corner:length(DF)+Corner-1,1),Coord(Corner:length(DF)+Corner-1,2),25,DF,'fill')
    colormap('jet')
    colorbar
%    caxis([0 1])

title('Ventral mPFC coherence - T2')


%%
%General coherence
%ChannelsReg = [PFC_ch VH_ch DH_ch];
[Cpd f]=mscohere(data1000(:,ChannelsReg(1)),data1000(:,ChannelsReg(3)),2000,1500,2^18,1000);
[Cpv f]=mscohere(data1000(:,ChannelsReg(1)),data1000(:,ChannelsReg(2)),2000,1500,2^18,1000);
[Cdv f]=mscohere(data1000(:,ChannelsReg(3)),data1000(:,ChannelsReg(2)),2000,1500,2^18,1000);

ii=5;

Animal(ii).Cpd = Cpd;
Animal(ii).Cpv = Cpv;
Animal(ii).Cdv = Cdv;
Animal(ii).f = f;
Animal(ii).cd = cd;