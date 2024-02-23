% this is a generic raytracer
clc;
clear;
format bank
if 0==0
    
    clear rx ry rz nx ny nz
    %load('electron_density.mat');
    
    d=1e-8;  % [m]
    c=3e8;   % seed of the light [m/s]
    h=1e-6;  % [s]
    m=1;     % starting point
    
    rx=1;    
    ry=0;
    
    rz=6370001;
    
    %takeoff angle
    
    t=30*pi/180;
    
    nx=cos(t);
    ny=0;
    nz=sin(t);
    
    aboveground=1;
    
    %start loop for integration
    
    while aboveground==1
        
        %do integration
        
        dg_drx=(cal_g(rx(m)+d/2,ry(m),rz(m),nx(m),ny(m),nz(m))-cal_g(rx(m)-d/2,ry(m),rz(m),nx(m),ny(m),nz(m)))/d;
        dg_dry=(cal_g(rx(m),ry(m)+d/2,rz(m),nx(m),ny(m),nz(m))-cal_g(rx(m),ry(m)-d/2,rz(m),nx(m),ny(m),nz(m)))/d;
        dg_drz=(cal_g(rx(m),ry(m),rz(m)+d/2,nx(m),ny(m),nz(m))-cal_g(rx(m),ry(m),rz(m)-d/2,nx(m),ny(m),nz(m)))/d;
        dg_dnx=(cal_g(rx(m),ry(m),rz(m),nx(m)+d/2,ny(m),nz(m))-cal_g(rx(m),ry(m),rz(m),nx(m)-d/2,ny(m),nz(m)))/d;
        dg_dny=(cal_g(rx(m),ry(m),rz(m),nx(m),ny(m)+d/2,nz(m))-cal_g(rx(m),ry(m),rz(m),nx(m),ny(m)-d/2,nz(m)))/d;
        dg_dnz=(cal_g(rx(m),ry(m),rz(m),nx(m),ny(m),nz(m)+d/2)-cal_g(rx(m),ry(m),rz(m),nx(m),ny(m),nz(m)-d/2))/d;
        
        rx(m+1)=rx(m)+h*c*real(dg_dnx);
        ry(m+1)=ry(m)+h*c*real(dg_dny);
        rz(m+1)=rz(m)+h*c*real(dg_dnz);
        nx(m+1)=nx(m)-h*c*real(dg_drx);
        ny(m+1)=ny(m)-h*c*real(dg_dry);
        nz(m+1)=nz(m)-h*c*real(dg_drz);
        
        [rx(m),rz(m),sqrt(rx(m)^2+rz(m)^2)-6370000];
        
        % determine if above ground
        aboveground=sqrt(rx(m)^2+rz(m)^2)>6370000;
        %aboveground=sign(1500000-rx(m));
        m=m+1;
        drawnow
        
    end
    
    
    m=m-1;
    
end

rx_range=-100000:2500:2000000;
rz_range=6000000:2500:6800000;
clear dens
dens_max=5e11;
for p=1:length(rx_range)
    for q=1:length(rz_range)
        r=sqrt(rx_range(p)^2+rz_range(q)^2);
        rzp=(r-300000-6370000)/30000;
        u=(180/pi)*atan(rx_range(p)/rz_range(q));
        dens(q,p)=(exp(-(u/2.65).^2)+exp(-((u-14)/2.65).^2))*dens_max*exp(0.5*(1-rzp-exp(-rzp)));
    end
end

figure(1)
plot(dens)

disp('here');
size(dens)

figure(2)
imagesc(-100000:2000000,6000000:6800000,log10(dens))
set(gca,'ydir','normal')
set(gca,'clim',[7 12])
colormap hot
hold on
plot(-100000:1000:2000000,sqrt(6370000^2-[-100000:1000:2000000].^2),'linewidth',3,'color','white')
plot(rx,rz,'linewidth',3)
hold off
grounrange=atan(rx(m)/rz(m))*6370000
colorbar
set(gcf,'color','white')