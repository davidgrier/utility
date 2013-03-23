;+
; NAME:
;		write_gdf
; PURPOSE:
;		Writes IDL-style data to disk in a format which can be
;		read back in easily.
;
; CATEGORY:
;		General Purpose Utility
; CALLING SEQUENCE:
;		write_gdf,data,file
; INPUTS:
;		data:	Data structure to be written to disk.
;		file:	Complete pathname of the file to be written.
; KEYWORD:
;		ascii:	Produce an ASCII file rather than the default
;			binary file.
; SIDE EFFECTS:
;		Creates a file.
; RESTRICTIONS:
;		Current version does not support structures or arrays of
;		structures.
; PROCEDURE:
;		Writes a header consisting of a long MAGIC number followed
;		by the long array produced by SIZE(DATA), followed by the
;		data itself.
;		If the file is ASCII, the header tag is an identifying
;		statement, followed by all of the same information in
;		ASCII format.
; MODIFICATION HISTORY:
; Written by David G. Grier, AT&T Bell Laboratories, 09/01/1991
; 03/17/2010 DGG: Code and documentation cleanups.
;
; Copyright (c) 1991-2010 David G. Grier
;-
pro write_gdf, data, file, ascii=ascii
on_error,2			; return to caller on error

MAGIC = 082991L
HEADER = 'GDF v. 1.0'
openw, lun, file, /get_lun
sz = size(data)
if keyword_set(ascii) then begin
	printf, lun, HEADER
	printf, lun, sz[0]
	printf, lun, sz[1:*]
	printf, lun, data
	endif $
else begin
	writeu, lun, MAGIC
	writeu, lun, sz
	writeu, lun, data
	endelse
close, lun
free_lun, lun
end
