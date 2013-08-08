;+
; NAME:
;    refractiveindex
;
; PURPOSE:
;    Returns the real part of the refractive index of water
;    as a function of the wavelength of light and the
;    temperature
;
; CATEGORY:
;    Physical constants
;
; CALLING SEQUENCE:
;     n = refractiveindex(lambda,T)
;
; INPUTS:
;     lambda: vacuum wavelength of light [micrometers]
;     T: temperature [C]
;
; OUTPUTS:
;     n: refractive index
;
; PROCEDURE:
; 1. The International Association for the Properties of Water and Steam,
;    Release on the Refractive Index of Ordinary Water Substance
;    as a Function of Wavelength, Temperature and Pressure (1997)
;    http://www.iapws.org/relguide/rindex.pdf
;
; 2. CRC Handbook of Chemistry and Physics: Thermophysical properties
;    of water and steam.
;
; MODIFICATION HISTORY:
; 06/10/2007 Created by David G. Grier, New York University
; 03/01/2012 DGG Spelling of Celsius (sheesh)
; 03/11/2013 DGG Correction for temperature-dependent changes in density of water.  COMPILE_OPT.
;   Double precision throughout.
;
; Copyright (c) 2007-2013 David G. Grier    
;-

function refractiveindex, wavelength, temperature

COMPILE_OPT IDL2

umsg = 'USAGE: n = refractiveindex(wavelength, temperature)'

if n_params() ne 2 then begin
   message, umsg, /inf
   return, -1
endif

if ~isa(wavelength, /number, /scalar) then begin
   message, umsg, /inf
   message, 'WAVELENGTH should be specified in micrometers', /inf
   return, -1
endif

if ~isa(temperature, /number, /scalar) then begin
   message, 'TEMPERATURE should be specified in degrees Celsius', /inf
   return, -1
endif

;;; water
Tref = 273.15d            ; [K] reference temperature -- freezing point of water
rhoref = 1000.d           ; [kg/m^3] reference density
lambdaref = 0.589d        ; [micrometer] reference wavelength

density = ((999.83952d + 16.945176d*temperature) - $
           (7.9870401d-3*temperature^2 - 46.170461d-6*temperature^3) + $
           (105.56302d-9*temperature^4 - 280.54235d-12*temperature^5)) * $
          1.000028d/(1.d + 16.879850d-3*temperature)

T = temperature/Tref + 1.d       ; Temperature in degrees Celsius
rho = density/rhoref

lambda = wavelength/lambdaref

a0 = 0.244257733
a1 = 9.74634476d-3
a2 = -3.73234996d-3
a3 = 2.68678472d-4
a4 = 1.58920570d-3
a5 = 2.45934259d-3
a6 = 0.900704920
a7 = -1.66626219d-2

lambdauv = 0.2292020d
lambdair = 5.432937d

A = a0 + a1*rho + a2*T + a3*lambda^2*T + a4/lambda^2 + $
    a5/(lambda^2 - lambdauv^2) + a6/(lambda^2 - lambdair^2) + $
    a7*rho^2

A *= rho

n = sqrt((1.d + 2.d*A)/(1.d - A))

;lambda = [0.442, 0.488, 0.5145, 0.543, 0.5682, $
;          0.594, 0.6328, 0.6471, 0.6943, 0.890, 1.060]
;nPMMA  = [1.4995, 1.4956, 1.4945, 1.4932, 1.4919, $
;          1.4906, 1.4888, 1.4881, 1.4864, 1.4833, 1.4812]
;nPS    = [1.6135, 1.6037, 1.5995, 1.5957, 1.5928, $
;          1.5901, 1.5867, 1.5855, 1.5824, 1.5752, 1.5717]

return, n
end

