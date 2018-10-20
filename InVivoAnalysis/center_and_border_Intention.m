XX=40;
YY=32;
fps=20;

XBound=max(Coord(:,1));
YBound=max(Coord(:,2));

CoordCM_X=(Coord(:,1)./XBound(1))*XX;
CoordCM_Y=(Coord(:,2)./YBound(1))*YY;

yT=[8]
yB=[YY-8];

xL=[8];
xR=[XX-8];

Center=zeros(length(CoordCM_X),1);
InOut=zeros(length(CoordCM_X),1);

%plot(CoordCM_X,CoordCM_Y)
for ii=1:length(CoordCM_X)
    if (CoordCM_X(ii)>xL & CoordCM_X(ii)<xR) & (CoordCM_Y(ii)>yT & CoordCM_Y(ii)<yB)
        Center(ii)=1;
        if ii>1 & ii<length(CoordCM_X)
            if Center(ii-1)==0 | Center(ii-2)==0
                InOut(ii)=1; % Animal is entering center
            end
            
            if not((CoordCM_X(ii+1)>xL & CoordCM_X(ii+1)<xR) & (CoordCM_Y(ii+1)>yT & CoordCM_Y(ii+1)<yB) | (CoordCM_X(ii+2)>xL & CoordCM_X(ii+2)<xR) & (CoordCM_Y(ii+2)>yT & CoordCM_Y(ii+2)<yB))
                InOut(ii)=2;
            end
        end
    end
end

%%
plot(CoordCM_X(Center==1),CoordCM_Y(Center==1),'LineStyle','none','Marker','o','Color',[.5 .5 .5])
hold on
plot(CoordCM_X(InOut==1),CoordCM_Y(InOut==1),'LineStyle','none','Marker','o','Color',[.5 .5 .5],'MarkerFaceColor','r')
plot(CoordCM_X(InOut==2),CoordCM_Y(InOut==2),'LineStyle','none','Marker','o','Color',[.5 .5 .5],'MarkerFaceColor','b')
plot(CoordCM_X(Center==0),CoordCM_Y(Center==0),'LineStyle','none','Marker','o','Color',[0 0 0])

hold off

%%
% First points
hold on
gg=find(Center==1);
for ii=1700:1850
    plot(CoordCM_X(gg(ii)),CoordCM_Y(gg(ii)),'m+')
end

%%
% Coherence border and center
[pks,locs]=findpeaks(aux1000);
DataFilm=detrend(data1000(locs(1):locs(end)+50,:));
DataBorder(1,1:16)=0;
DataCenter(1,1:16)=0;
tVideoKwik=locs(end)+50-locs(1);
disp('Inter frame interval');
1/(length(Center)/(tVideoKwik))
for ii=1:length(Center)
    I1=(ii-1)*10+1;
    I2=ii*10;
    if (Center(ii)==0)
        DataBorder=[DataBorder;DataFilm(I1:I2,:)];
    else
        DataCenter=[DataCenter;DataFilm(I1:I2,:)];
    end
end
%%

PFC_ch = 4;
VH_ch = 11;
DH_ch = 2;

[CdfC,fc]=mscohere(detrend(DataCenter(:,DH_ch)),detrend(DataCenter(:,PFC_ch)),2000,1500,2^18,1000);
[CdvC,fc]=mscohere(detrend(DataCenter(:,DH_ch)),detrend(DataCenter(:,VH_ch)),2000,1500,2^18,1000);
[CvfC,fc]=mscohere(detrend(DataCenter(:,VH_ch)),detrend(DataCenter(:,PFC_ch)),2000,1500,2^18,1000);

[CdfB,fb]=mscohere(detrend(DataBorder(:,DH_ch)),detrend(DataBorder(:,PFC_ch)),2000,1500,2^18,1000);
[CdvB,fb]=mscohere(detrend(DataBorder(:,DH_ch)),detrend(DataBorder(:,VH_ch)),2000,1500,2^18,1000);
[CvfB,fb]=mscohere(detrend(DataBorder(:,VH_ch)),detrend(DataBorder(:,PFC_ch)),2000,1500,2^18,1000);

%%
subplot(2,2,1),
plot(fc,CdfC,'r')
hold on
plot(fb,CdfB,'k')
hold off
xlim([0 20])
title('DH x PFC')

subplot(2,2,2),
plot(fc,CvfC,'r')
hold on
plot(fb,CvfB,'k')
hold off
xlim([0 20])
title('VH x PFC')

subplot(2,2,3),
plot(fc,CdvC,'r')
hold on
plot(fb,CdvB,'k')
hold off
xlim([0 20])
title('VH x DH')