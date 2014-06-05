;+
; NAME:
;    circ
;
; PURPOSE:
;    Sets the usersymbol to be an open circle and returns
;    the number 8
;
; CATEGORY:
;    Plotting, direct graphics
;
; CALLING SEQUENCE:
;    psym = circ()
;
; KEYWORD PARAMETERS:
;    radius: floating point radius of plot circle
;        Default: 1
;
;    thick: floating point thickness of line use to plot circle
;        Default: 1
;
;    dx: offset of circle center along x in data units
;        Default: 0.
;
;    dy: offset of circle center along y in data units
;        Default: 0.
;
; KEYWORD FLAGS:
;    fill: If set, fill the circle with the current color
;
;    right: Plot right half-circle
;
;    left: Plot left half-circle
;
; OUTPUTS:
;    psym: 8
;
; EXAMPLE:
;    plot, findgen(5), findgen(5), psym = circ()
;
; MODIFICATION HISTORY:
;    09/01/1992 Written by John C. Crocker, The University of Chicago
;    05/05/2014 Updated for public release by David G. Grier, New York University
;
; Copyright (c) 2014 John C. Crocker and David G. Grier
;-

function circ, radius = radius, $
               thick = thick, $
               fill = fill, $
               dx = dx, dy = dy, $
               left = left, right = right

radius =  isa(radius, /scalar, /number) ? float(radius) > 0 : 1.
thick = isa(thick, /scalar, /number) ? float(thick) > 0 : 1.
dx = isa(dx, /scalar, /number) ? float(dx) : 0.
dy = isa(dy, /scala, /number) ? float(dy) : 0.

t = findgen(37) * (!pi*2/36)

if keyword_set(right) then t = t[0:18]
if keyword_set(left) then t = [t(18:*),t(0)]

x = sin(t)*radius + dx
y = cos(t)*radius + dy

if keyword_set(fill) then $
	usersym, x, y, /fill $
else	usersym, x, y, thick=thick

return, 8
end
