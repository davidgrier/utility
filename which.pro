
;+
; NAME:
;       WHICH
;
; PURPOSE:
;       Searches the !PATH for a given file.
;
; CATEGORY:
;       Programming.
;
; CALLING SEQUENCE:
;
;       Result = WHICH (FileName)
; 
; INPUTS:
;       FileName    The name of the file to look for. The '.pro'
;                   extension can be omitted.
;
; KEYWORD PARAMETERS:
;       PATH        A string containing an alternative path to search.
;                   If this keyword is omitted, !PATH is used.
;
; OUTPUTS:
;       The function returns the path to the file name. If the file is
;       not found, an empty string '' is returned.
;
; COMMON BLOCKS:
;       None.
;
; SIDE EFFECTS:
;       None.
;
; RESTRICTIONS:
;       Should work on DOS and Unix platforms.
;
; MODIFICATION HISTORY:
;
;       Jun 13, 1994 (Frank Robijn, Robijn@Strw.LeidenUniv.NL)
;		Written.
;-
FUNCTION Which, File, PATH=Path

if (NOT Keyword_Set (File)) then return, ''
if (NOT Keyword_Set (Path)) then Path = !PATH

case !VERSION.OS of
    'windows': begin SepDir = '\' & SepPath = ';' & end
    else:      begin SepDir = '/' & SepPath = ':' & end
endcase

SearchDir = ['.']
Pos = -1
repeat begin
    NewPos = StrPos (Path, SepPath, Pos + 1)
    if (NewPos LT 0) then Len = StrLen (Path) else Len = NewPos-Pos-1
    SearchDir = [Temporary (SearchDir), StrMid (Path, Pos+1, Len)]
    Pos = NewPos
endrep until (NewPos LT 0)

FileName = ''
On_IOError, Continue
Get_LUn, Unit
for i = 0, N_Elements (SearchDir) - 1 do begin
    OpenR, Unit, SearchDir(i) + SepDir + File
    Close, Unit
    FileName = SearchDir(i) + SepDir + File
    GoTo, FileFound
Continue:
endfor

On_IOError, GoOn
Get_LUn, Unit
for i = 0, N_Elements (SearchDir) - 1 do begin
    OpenR, Unit, SearchDir(i) + SepDir + File + '.pro'
    Close, Unit
    FileName = SearchDir(i) + SepDir + File + '.pro'
    GoTo, FileFound
GoOn:
endfor

FileFound:
On_IOError, NULL
return, FileName
END
