;+
; NAME:
;		read_gdf
; PURPOSE:
;		Read in data files created by WRITE_GDF.
;
; CATEGORY:
;		General Purpose Utility
; CALLING SEQUENCE:
;		data = read_gdf(file)
; INPUTS:
;		file:	Complete pathname of the file to be read.
; OUTPUTS:
;		data:	Data structure.  For example, if the original
;			data was stored as an array of bytes, then
;			DATA will be returned as an array of bytes also.	
; RESTRICTIONS:
;		Current implementation does not support structures or
;		arrays of structures.
; PROCEDURE:
;		Reasonably straightforward.
;		Determines if the file is ASCII or binary, reads the size
;		and dimension info from the header, and reads in the data
; MODIFICATION HISTORY:
; Written by David G. Grier, AT&T Bell Laboratories, 9/91
; 12/01/1995 DGG: Figures out how to deal with data from different-endian
;   machines.
; 03/17/2010 DGG: Use file_search to find files.  Code and documentation
;   cleanups.
;
; Copyright (c) 1991-2010 David G. Grier
;-
function read_gdf, filespec
on_error,2			; return to caller on error

MAGIC = 082991L
HEADER = 'GDF v. 1.0'
debug = keyword_set(debug)

file = file_search(filespec, count=nfiles)

if nfiles eq 0 then message,'No files matched specification '+filespec

d = -1
ascii = 0

openr, lun, file[0], /get_lun

mgc = 0L
readu, lun, mgc
doswap = swap_endian(mgc) eq MAGIC	; Check for binary GDF file written on 
					; different-endian machine
					
					; Check for ASCII GDF file
if (mgc ne MAGIC) and (not doswap) then begin
	point_lun, lun, 0
	str = ''
	fmt = '(A'+strtrim(strlen(HEADER),2)+')'
	readf, lun, format=fmt, str
	if str eq HEADER then $
		ascii = 1 $
	else begin
		message, filespec+' is not a GDF file', /inf
		goto, done
		endelse
	endif
ndim = 0L

					; Get number of data dimensions
if ascii then $
	readf, lun, ndim $
else $
	readu, lun, ndim
if doswap then ndim = swap_endian(ndim)
sz = lonarr(ndim+2, /nozero)
					; Get data type description
if ascii then $
	readf, lun, sz $
else $
	readu, lun, sz
if doswap then sz = swap_endian(sz)
sz = [ndim, sz]

d = make_array(size=sz, /nozero)
if ascii then readf,lun,d else readu,lun,d
if doswap then d = swap_endian(d)

done:
close, lun
free_lun, lun
return, d
end
