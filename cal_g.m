function [g]=cal_g(rx,ry,rz,nx,ny,nz)



%find haselgrove function G given rx, ry, rz, nx, ny, nz

% % assume 5 MHz fof2, 1.35 MHz fce
% dens_max=5e11;
% %fce=1.35e6;
% 
% % to get spherical, we convert rx,rz into spherical and compute chapman
% 
% r=sqrt(rx^2+rz^2);
% 
% % subtract out height of ionosphere and earth radius
% rzp=(r-300000-6370000)/30000;
% u=(180/pi)*atan(rx/rz);
% dens1=(exp(-(u/2.65).^2)+exp(-((u-14)/2.65).^2))*dens_max*exp(0.5*(1-rzp-exp(-rzp)));


rx  %degrees
ry  %degrees
rz  %km    (80-2000)Km
dens1 = electronDens(rx,ry,(rz-6370001));

fpe=9*sqrt(dens1);
f=5e6;
%y=fce/f;
x=(fpe/f)^2;
n=1-x;
%full appleton-hartree
%n_top=x*(1-x);
%n_bot=1-x-0.5*y^2*sin(theta)^2+(mode)*sqrt(0.25*y^4*sin(theta)^4+y^2*cos(theta)^2*(1-x)^2);
%n=sqrt(1-n_top/n_bot);

g=sqrt(sum([nx;ny;nz].^2))/n;
