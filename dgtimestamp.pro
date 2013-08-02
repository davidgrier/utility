;+
; NAME:
;    dgtimestamp
;
; PURPOSE:
;    Returns the current time as a string suitable for use
;    as a timestamp or filename.
;
; CATEGORY:
;    Time, utility
;
; CALLING SEQUENCE:
;    ts = dgtimestamp()
;
; KEYWORD FLAGS:
;    By default, the time is returned as a string with millisecond
;    resolution.  If any of the flags is set, only the requested
;    elements are returned, separated by underscores.
;
;    date: include date in the format YYYYMMDD
;
;    day: include day of the week
;
;    time: include time
;
;    hms: format time as HH:MM:SS.FFFFFF
;
; OUTPUTS:
;    ts: timestamp
;
; RESTRICTIONS:
;    Default timestamp rolls over at midnight.
;
; PROCEDURE:
;    Based on Craig Markwardt's CMSYSTIME.
;    CMSYSTIME is available from
;    http://www.physics.wisc.edu/~craigm/idl/down/cmsystime.pro
;
; EXAMPLES:
;    IDL> print, dgtimestamp()
;    026056.132910
;
;    IDL> print, dgtimestamp(/hms)
;    07:14:48.51624
;
;    IDL> print, dgtimestamp(/date,/time,/hms)
;    20110411_07:15:29.658884
;
;    IDL> print, dgtimestamp(/date,/day)
;    20110411_Mon
;
;    IDL> print, dgtimestamp(/date,/day,/time,/hms)
;    20110411_Mon_07:17:22.439246
;
; MODIFICATION HISTORY:
; CMSYSTIME was written by Craig Markwardt with the following
; copyright and licensing statements:
;
;; Copyright (C) 2000,2002,2005, Craig Markwardt
;; This software is provided as is without any warranty whatsoever.
;; Permission to use, copy, modify, and distribute modified or
;; unmodified copies is granted, provided this copyright and disclaimer
;; are included unchanged.
;
; 04/10/2011 Adapted by David G. Grier, New York University
; 03/16/2013 DGG Added COMPILE_OPT
; 08/02/2013 DGG Added HMS
;
; Copyright (c) 2013 David G. Grier
;-

;;;;;
;
; dgts_xmod
;
function dgts_xmod, x, m

COMPILE_OPT IDL2, HIDDEN

return, (((x mod m) + m) mod m)
end

;;;;;
;
; dgts_mjd2ymd
;
pro dgts_mjd2ymd, mjd, yr, mo, da

COMPILE_OPT IDL2, HIDDEN

offset = 2400000.5D
offset_int = floor(offset)
offset_fra = offset - offset_int
nn = offset_fra + mjd
jd_fra = dgts_xmod(nn + 0.5D, 1D) - 0.5D
nn += offset_int - jd_fra
nn += floor(floor((nn - 4479.5D)/36524.25D) * 0.75D + 0.5D) - 37.D
yr = long(floor(nn/365.25D) - 4712.D)
dd = floor(dgts_xmod(nn - 59.25D, 365.25D))
mo = floor(dgts_xmod(floor((dd + 0.5D)/30.6D) + 2.D, 12.D) + 1.D)
da = floor(dgts_xmod(dd + 0.5D, 30.6D) + 1.D) + 0.5D + jd_fra
end

;;;;;
;
; dgtimestamp
;
function dgtimestamp, date = date, $
                      day = day, $
                      time = time, $
                      hms = hms

COMPILE_OPT IDL2

MJD_1970 = 40587D
TZ = -4D * 3600D

t = systime(1) + TZ             ; time now in local timezone
dsecs = t - floor(t/86400D) * 86400D
mjd = floor(t/86400D) + MJD_1970

str = ''
if keyword_set(date) or arg_present(date) then begin
   dgts_mjd2ymd, mjd, yr, mo, da
   date = string(yr, mo, da, format = '(I4,I02,I02)')
   str = date
endif

if keyword_set(day) or arg_present(day) then begin
   dow = ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat']
   day = dow[dgts_xmod(mjd - 51678D, 7L)]
   str += ((str) ? '_' : '') + day
endif

if ~str or keyword_set(time) or arg_present(time) then begin
   if keyword_set(hms) then begin
      hr = floor(dsecs / 3600)  ; hour
      se = dsecs - hr * 3600
      mi = floor(se / 60)       ; minute
      se -= mi * 60
      sei = floor(se)                 ; integer seconds
      sef = floor((se - sei) * 1000000D) ; fractional seconds
      time = string(hr, mi, sei, sef, format = '(I02,":",I02,":",I02,".",I06)') 
   endif else $
      time = string(dsecs, format = '(F012.6)')
   str += ((str) ? '_' : '') + time
endif 

return, str
end
