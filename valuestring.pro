;+
; NAME:
;    valuestring
;
; PURPOSE:
;    format a value, its error estimate and its unit as a string in
;    scientific notation.
;
; CATEGORY:
;    strings
;
; CALLING SEQUENCE:
;    str = valuestring(value, error[, unit])
;
; INPUTS:
;    value: numeric value to be formatted
;    error: numeric error in the value
;
; OPTIONAL INPUTS:
;    unit: string describing unit of value.
;
; KEYWORD PARAMETERS:
;    digits: Number of digits after the decimal point.
;        Default: computed from error.
;
; OUTPUTS:
;    str: string containing the formatted value.
;
; EXAMPLE:
;    IDL> print, valuestring(123.456, 0.012, 'm')
;    123.45 +/- 0.01 m
;
; MODIFICATION HISTORY:
; 03/23/2013 Written by David G. Grier, New York University
;
; Copyright (c) 2013 David G. Grier
;-

function valuestring, value, error, unit, digits = digits

COMPILE_OPT IDL2

umsg = 'str = valuestring(value, error[, unit])'

if n_params() lt 1 then begin
   message, umsg, /inf
   return, ""
endif

if ~isa(value, /number, /scalar) then begin
   message, umsg, /inf
   message, 'VALUE should be a numerical scalar', /inf
   return, ""
endif

sgn = (value lt 0) ? '-' : ''
exponent = (value ne 0.) ? floor(alog10(abs(value))) : 0
order = 10.^exponent

mant = abs(value) / order
errmant = error / order
if ~isa(digits, /number, /scalar) then $
   digits = -floor(alog10(errmant))
mant = round(mant * 10.^digits)/10.^digits
errmant = round(errmant * 10.^digits)/10.^digits

fmt = '(%"%' + strtrim(digits+2, 2) + '.' + strtrim(digits, 2) + 'f")'
strmant = string(mant, format = fmt)
strerrmant = string(errmant, format = fmt)
str = sgn + strmant + ' +/- ' + strerrmant
if exponent ne 0 then $
   str = '(' + str + ') x 10^' + strtrim(exponent, 2)

if isa(unit, 'string') then $
   str += ' ' + unit

return, str
end
