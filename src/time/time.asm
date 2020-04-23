;░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
;░This file is part of libfastasm.										░
;░																		░
;░libfastasm is free software: you can redistribute it and/or modify	░
;░it under the terms of the GNU General Public License as published by	░
;░the Free Software Foundation, either version 3 of the License, or		░
;░(at your option) any later version.									░
;░																		░
;░libfastasm is distributed in the hope that it will be useful,			░
;░but WITHOUT ANY WARRANTY; without even the implied warranty of		░
;░MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the			░
;░GNU General Public License for more details.							░
;░																		░
;░You should have received a copy of the GNU General Public License		░
;░along with Foobar.  If not, see <https://www.gnu.org/licenses/>.		░
;░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
;┌──────────────────────────────┐
;│ get unix time				│
;│ input:						│
;│			NaN					│
;│ output:						│
;│			rax = unix time		│
;└──────────────────────────────┘
proc fa_time c
	; get system time -> convert to file time -> convert to unix time
	locals
		system_time		SYSTEMTIME ?
		file_time		FILETIME ?
		ElapsedSeconds	dq ?
	endl

	;╔══════════════════════════╗
	;║ void GetSystemTime(		║
	;║ LPSYSTEMTIME lpSystemTime║
	;║ );						║
	;╚══════════════════════════╝
	lea		rcx,[system_time]
	call	[GetSystemTime]

	;╔══════════════════════════════════╗
	;║ BOOL SystemTimeToFileTime(		║
	;║ const SYSTEMTIME *lpSystemTime,	║
	;║ LPFILETIME       lpFileTime		║
	;║ );								║
	;╚══════════════════════════════════╝
	lea		rcx,[system_time]
	lea		rdx,[file_time]
	call	[SystemTimeToFileTime]

	;╔══════════════════════════════════════╗
	;║ BOOLEAN RtlTimeToSecondsSince1970(	║
	;║ PLARGE_INTEGER Time,					║
	;║ PULONG         ElapsedSeconds		║
	;║ );									║
	;╚══════════════════════════════════════╝
	lea		rcx,[file_time]
	lea		rdx,[ElapsedSeconds]
	call	[RtlTimeToSecondsSince1970]
	mov		rax,[ElapsedSeconds]
	ret
endp