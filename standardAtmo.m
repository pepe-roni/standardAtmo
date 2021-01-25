clear
clc
close all

%load external data
rawdata = readtable('stdAtmosphere.csv');
altitude = rawdata.GeoPotAlt;
temp = rawdata.Temp;
localg = rawdata.Accel;
airPressure = rawdata.AbsPress;
airDensity = rawdata.Density;
dViscosity = rawdata.DynVisc;

%identify closest values
disp('Calculate standard atmosphere values between -5000 to 250000ft')
requestAlt = input('What altitude(ft) is of interest: ');
for i=1:numel(altitude)
    difference(i,1) = abs(altitude(i) - requestAlt);
end
[closest,closestInd] = min(difference);
difference(closestInd) = inf; 
[closest2,closestInd2] = min(difference);

%interpolate
altitude1 = altitude(closestInd);
altitude2 = altitude(closestInd2);
outTemp = interpo(altitude1, altitude2, requestAlt, temp(closestInd), temp(closestInd2));
outLocalg = interpo(altitude1, altitude2, requestAlt, localg(closestInd), localg(closestInd2));
outAirPressure = interpo(altitude1, altitude2, requestAlt, airPressure(closestInd), airPressure(closestInd2));
outAirDensity = interpo(altitude1, altitude2, requestAlt, airDensity(closestInd), airDensity(closestInd2));
outViscocity = interpo(altitude1, altitude2, requestAlt, dViscosity(closestInd), dViscosity(closestInd2));

fprintf('At altitude %f ft\n', requestAlt)
fprintf('\nAtmospheric temperature is %f F\n', outTemp)
fprintf('Local gravity is %f ft/s^2\n', outLocalg)
fprintf('Air pressure is %f lbs/in^2\n', outAirPressure)
fprintf('Air density is %f*10^-4 slugs/ft^3\n', outAirDensity)
fprintf('Dynamic viscosity is %f*10^-7 lb*s/ft^2\n', outViscocity)

function interpValue = interpo(x1,x2,x3,y1,y2)
    interpValue = (((x2-x3)*y1) + ((x3-x1)*y2))/(x2-x1);
end


