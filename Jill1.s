Segment 0040 ;; DOS Segment.
Y00400000:
Y0040001a: word	;; 0040001a	;; Handler queue head.
Y0040001c: word ;; 0040001c	;; Handler queue tail.
Y00400063: word	;; 00400063	;; Port number.
Y0040006c: word	;; 0040006c	;; Clock.

;; CS:IP = 0000:0000, SS:SP = 2f84:00e6
;; Relocated to 076a under Linux; previously to 140c under Windows.

;; === Top-Level Runtime System ===
Segment 076a ;; C0L:C0L
;; (@) Unnamed near calls: B076a012f, B076a01a7, B076a0260, B076a03d0, B076a03ff
__turboCrt: ;; 076a0000 ;; (@) Unaccessed.
__cvtfak: ;; 076a0000 ;; (@) Unaccessed.
   mov DX,segment A2a170000
   mov [CS:offset DGROUP@],DX
   mov AH,30
   int 21
   mov BP,[0002]
   mov BX,[002C]
   mov DS,DX
   mov [offset __version],AX
   mov [offset __psp],ES
   mov [offset __envseg],BX
   mov [offset __heaptop+02],BP
   mov word ptr [offset __8087],FFFF
   call near B076a012f
   les DI,[offset __envLng]
   mov AX,DI
   mov BX,AX
   mov CX,7FFF
L076a0039:
   cmp word ptr [ES:DI],3738	;; "87"
   jnz L076a0059
   mov DX,[ES:DI+02]
   cmp DL,3D
   jnz L076a0059
   and DH,DF
   inc word ptr [offset __8087]
   cmp DH,59
   jnz L076a0059
   inc word ptr [offset __8087]
L076a0059:
   repnz scasb
   jcxz L076a0099
   inc BX
   cmp [ES:DI],AL
   jnz L076a0039
   or CH,80
   neg CX
   mov [offset __envLng],CX
   mov CX,0002
   shl BX,CL
   add BX,+10
   and BX,-10
   mov [offset __envSize],BX
   mov DX,SS
   sub BP,DX
   mov DI,[offset __stklen]
   cmp DI,0200
   jnb L076a0090
   mov DI,0200
   mov [offset __stklen],DI
L076a0090:
   mov CL,04
   shr DI,CL
   inc DI
   cmp BP,DI
   jnb L076a009c
L076a0099:
jmp near _abort
L076a009c:
   mov BX,DI
   add BX,DX
   mov [offset __heapbase+02],BX
   mov [offset __brklvl+02],BX
   mov AX,[offset __psp]
   sub BX,AX
   mov ES,AX
   mov AH,4A
   push DI
   int 21
   pop DI
   shl DI,CL
   cli
   mov SS,DX
   mov SP,DI
   sti
   xor AX,AX
   mov ES,[CS:offset DGROUP@]
   mov DI,offset Y2a172c62
   mov CX,offset Y2a17cd64
   sub CX,DI
   repz stosb ;; (@) Initialize the BSS segment to 0.
   push CS
   call near [offset Y2a172c4c]
   call far __setargv
   call far __setenvp
   mov AH,00
   int 1A
   mov [offset __StartTime],DX
   mov [offset __StartTime+02],CX
   push CS
   call near [offset Y2a172c50]
   push [offset _environ+02]
   push [offset _environ]
   push [offset __argv+02]
   push [offset __argv]
   push [offset __argc]
   call far _main
   push AX
   call far _exit

__exit: ;; 076a010d	;; (@) No return.
   mov DS,[CS:offset DGROUP@]
   call far __restorezero
   push CS
   call near [offset Y2a172c4e]
   mov BP,SP
   mov AH,4C
   mov AL,[BP+04]
   int 21		;; (@) No return.

B076a0125:
   mov CX,000E
   nop
   mov DX,offset Y2a17002f
jmp near B076a01b6

B076a012f:
   push DS
   mov AX,3500
   int 21
   mov [offset __Int0Vector],BX
   mov [offset __Int0Vector+02],ES
   mov AX,3504
   int 21
   mov [offset __Int4Vector],BX
   mov [offset __Int4Vector+02],ES
   mov AX,3505
   int 21
   mov [offset __Int5Vector],BX
   mov [offset __Int5Vector+02],ES
   mov AX,3506
   int 21
   mov [offset __Int6Vector],BX
   mov [offset __Int6Vector+02],ES
   mov AX,2500
   mov DX,CS
   mov DS,DX
   mov DX,offset B076a0125
   int 21
   pop DS
ret near

__restorezero: ;; 076a0172
   push DS
   mov AX,2500
   lds DX,[offset __Int0Vector]
   int 21
   pop DS
   push DS
   mov AX,2504
   lds DX,[offset __Int4Vector]
   int 21
   pop DS
   push DS
   mov AX,2505
   lds DX,[offset __Int5Vector]
   int 21
   pop DS
   push DS
   mov AX,2506
   lds DX,[offset __Int6Vector]
   int 21
   pop DS
ret far

A076a019f:
   mov word ptr [offset __8087],0000
ret far

X076a01a6:
ret far

B076a01a7:
   mov AH,40
   mov BX,0002
   int 21
ret near

_abort: ;; 076a01af	;; (@) No return.
   mov CX,001E
   nop
   mov DX,offset Y2a17003d

B076a01b6:		;; (@) No return.
   mov DS,[CS:offset DGROUP@]
   call near B076a01a7
   mov AX,0003
   push AX
   call far __exit

DGROUP@:	word	;; 076a01c7
Y076a01c9:	byte	;; 076a01c9
Y076a01ca:	dword	;; 076a01ca	;; TopLevelOp
Y076a01ce:	dword	;; 076a01ce	;; TopLevelDS

__setargv: ;; 076a01d2
   pop [CS:offset Y076a01ca]
   pop [CS:offset Y076a01ca+02]
   mov [CS:offset Y076a01ce],DS
   cld
   mov ES,[offset __psp]
   mov SI,0080
   xor AH,AH
   ES:lodsb
   inc AX
   mov BP,ES
   xchg DX,SI
   xchg BX,AX
   mov SI,[offset __envLng]
   add SI,+02
   mov CX,0001
   cmp byte ptr [offset __version],03
   jb L076a0215
   mov ES,[offset __envseg]
   mov DI,SI
   mov CL,7F
   xor AL,AL
   repnz scasb
   jcxz L076a0288
   xor CL,7F
L076a0215:
   sub SP,+02
   mov AX,0001
   add AX,BX
   add AX,CX
   and AX,FFFE
   mov DI,SP
   sub DI,AX
   jb L076a0288
   mov SP,DI
   mov AX,ES
   mov DS,AX
   mov AX,SS
   mov ES,AX
   push CX
   dec CX
   repz movsb
   xor AL,AL
   stosb
   mov DS,BP
   xchg SI,DX
   xchg BX,CX
   mov AX,BX
   mov DX,AX
   inc BX
L076a0244:
   call near B076a0260
   ja L076a0250
L076a0249:
   jb L076a028d
   call near B076a0260
   ja L076a0249
L076a0250:
   cmp AL,20
   jz L076a025c
   cmp AL,0D
   jz L076a025c
   cmp AL,09
   jnz L076a0244
L076a025c:
   xor AL,AL
jmp near L076a0244

B076a0260:
   or AX,AX
   jz L076a026b
   inc DX
   stosb
   or AL,AL
   jnz L076a026b
   inc BX
L076a026b:
   xchg AH,AL
   xor AL,AL
   stc
   jcxz L076a0287
   lodsb
   dec CX
   sub AL,22
   jz L076a0287
   add AL,22
   cmp AL,5C
   jnz L076a0285
   cmp byte ptr [SI],22
   jnz L076a0285
   lodsb
   dec CX
L076a0285:
   or SI,SI
L076a0287:
ret near
L076a0288:
jmp far _abort
L076a028d:
   pop CX
   add CX,DX
   mov DS,[CS:offset Y076a01ce]
   mov [offset __argc],BX
   inc BX
   add BX,BX
   add BX,BX
   mov SI,SP
   mov BP,SP
   sub BP,BX
   jb L076a0288
   mov SP,BP
   mov [offset __argv],BP
   mov [offset __argv+02],SS
L076a02b0:
   jcxz L076a02c3
   mov [BP+00],SI
   mov [BP+02],SS
   add BP,+04
L076a02bb:
   SS:lodsb
   or AL,AL
   loopnz L076a02bb
   jz L076a02b0
L076a02c3:
   xor AX,AX
   mov [BP+00],AX
   mov [BP+02],AX
jmp far [CS:offset Y076a01ca]

__setenvp: ;; 076a02d0
   mov ES,[offset __envseg]
   xor DI,DI
   push ES
   push [offset __envSize]
   call far _malloc
   add SP,+02
   mov BX,AX
   pop ES
   mov [offset _environ],AX
   mov [offset _environ+02],DX
   push DS
   mov DS,DX
   or AX,DX
   jnz L076a02f9
jmp far _abort
L076a02f9:
   xor AX,AX
   mov CX,FFFF
L076a02fe:
   mov [BX],DI
   mov [BX+02],ES
   add BX,+04
   repnz scasb
   cmp [ES:DI],AL
   jnz L076a02fe
   mov [BX],AX
   mov [BX+02],AX
   pop DS
ret far

PADD@: ;; 076a0314
   or CX,CX
   jge L076a0325
   not BX
   not CX
   add BX,+01
   adc CX,+00
jmp near L076a0351
X076a0324:
   nop
L076a0325:
   add AX,BX
   jnb L076a032d
   add DX,1000
L076a032d:
   mov CH,CL
   mov CL,04
   shl CH,CL
   add DH,CH
   mov CH,AL
   shr AX,CL
   add DX,AX
   mov AL,CH
   and AX,000F
ret far

PSUB@: ;; 076a0341 ;; (@) Unaccessed.
   or CX,CX
   jge L076a0351
   not BX
   not CX
   add BX,+01
   adc CX,+00
jmp near L076a0325
L076a0351:
   sub AX,BX
   jnb L076a0359
   sub DX,1000
L076a0359:
   mov BH,CL
   mov CL,04
   shl BH,CL
   xor BL,BL
   sub DX,BX
   mov CH,AL
   shr AX,CL
   add DX,AX
   mov AL,CH
   and AX,000F
ret far

PCMP@: ;; 076a036f
   push CX
   mov CH,AL
   mov CL,04
   shr AX,CL
   add DX,AX
   mov AL,CH
   mov AH,BL
   shr BX,CL
   pop CX
   add CX,BX
   mov BL,AH
   and AX,000F
   and BX,+0F
   cmp DX,CX
   jnz L076a038f
   cmp AX,BX
L076a038f:
ret far

LXMUL@: ;; 076a0390
   push SI
   xchg SI,AX
   xchg DX,AX
   test AX,AX
   jz L076a0399
   mul BX
L076a0399:
   xchg CX,AX
   test AX,AX
   jz L076a03a2
   mul SI
   add CX,AX
L076a03a2:
   xchg SI,AX
   mul BX
   add DX,CX
   pop SI
ret far

A076a03a9:
   mov DX,offset Y2a172b86+00
jmp near L076a03b1

A076a03ae:
   mov DX,offset Y2a172b86+05
L076a03b1:
   mov CX,0005
   nop
   mov AH,40
   mov BX,0002
   int 21
   mov CX,0027
   nop
   mov DX,offset Y2a172b86+0a
   mov AH,40
   int 21
jmp far _abort

__REALCVT: ;; 076a03cc
jmp far [offset __RealCvtVector]

B076a03d0:
   push BP
   mov BP,SP
jmp near L076a03ed
L076a03d5:
   les BX,[BP+04]
   inc word ptr [BP+04]
   mov AL,[ES:BX]
   les BX,[BP+08]
   inc word ptr [BP+08]
   cmp AL,[ES:BX]
   jz L076a03ed
   xor AX,AX
jmp near L076a03fb
L076a03ed:
   les BX,[BP+04]
   cmp byte ptr [ES:BX],00
   jnz L076a03d5
   mov AX,0001
jmp near L076a03fb
L076a03fb:
   pop BP
ret near 0008

B076a03ff:
   mov AX,1130
   mov BH,00
   mov DL,FF
   call far __VideoInt
   mov AL,DL
   inc AL
   mov AH,00
jmp near L076a0413
L076a0413:
ret near

__VideoInt: ;; 076a0414
   push SI
   push DI
   mov [offset Y2a17cd62],BP
   int 10
   mov BP,[offset Y2a17cd62]
   pop DI
   pop SI
ret far

__c0crtinit: ;; 076a0423
   mov AH,0F
   push CS
   call near offset __VideoInt
   push AX
   call far __crtinit
   pop CX
   mov AH,08
   mov BH,00
   push CS
   call near offset __VideoInt
   and AH,7F
   mov [offset __video+05],AH
   mov [offset __video+04],AH
ret far

__crtinit: ;; 076a0444
   push BP
   mov BP,SP
   mov AL,[BP+06]
   cmp AL,03
   jbe L076a0454
   cmp AL,07
   jz L076a0454
   mov AL,03
L076a0454:
   mov [offset __video+06],AL
   mov AH,0F
   push CS
   call near offset __VideoInt
   cmp AL,[offset __video+06]
   jz L076a0475
   mov AL,[offset __video+06]
   mov AH,00
   push CS
   call near offset __VideoInt
   mov AH,0F
   push CS
   call near offset __VideoInt
   mov [offset __video+06],AL
L076a0475:
   mov [offset __video+08],AH
   cmp byte ptr [offset __video+06],03
   jbe L076a048c
   cmp byte ptr [offset __video+06],07
   jz L076a048c
   mov AX,0001
jmp near L076a048e
L076a048c:
   xor AX,AX
L076a048e:
   mov [offset __video+09],AL
   mov byte ptr [offset __video+07],19
   cmp byte ptr [offset __video+06],07
   jz L076a04bd
   mov DX,F000
   mov AX,FFEA
   push DX
   push AX
   push DS
   mov AX,offset Y2a172c41
   push AX
   call near B076a03d0
   or AX,AX
   jnz L076a04bd
   call near B076a03ff
   or AX,AX
   jnz L076a04bd
   mov AX,0001
jmp near L076a04bf
L076a04bd:
   xor AX,AX
L076a04bf:
   mov [offset __video+0a],AL
   cmp byte ptr [offset __video+06],07
   jnz L076a04ce
   mov AX,B000
jmp near L076a04d1
L076a04ce:
   mov AX,B800
L076a04d1:
   mov [offset __video+0d],AX
   mov word ptr [offset __video+0b],0000
   mov AL,00
   mov [offset __video+01],AL
   mov [offset __video],AL
   mov AL,[offset __video+08]
   add AL,FF
   mov [offset __video+02],AL
   mov byte ptr [offset __video+03],18
   pop BP
ret far

X076a04f1:
ret far

LDIV@: ;; 076a04f2
   xor CX,CX
jmp near L076a0503

LUDIV@: ;; 076a04f6 ;; (@) Unaccessed.
   mov CX,0001
jmp near L076a0503

LMOD@: ;; 076a04fb ;; (@) Unaccessed.
   mov CX,0002
jmp near L076a0503

LUMOD@: ;; 076a0500 ;; (@) Unaccessed.
   mov CX,0003
L076a0503:
   push BP
   push SI
   push DI
   mov BP,SP
   mov DI,CX
   mov AX,[BP+0A]
   mov DX,[BP+0C]
   mov BX,[BP+0E]
   mov CX,[BP+10]
   or CX,CX
   jnz L076a0522
   or DX,DX
   jz L076a0587
   or BX,BX
   jz L076a0587
L076a0522:
   test DI,0001
   jnz L076a0544
   or DX,DX
   jns L076a0536
   neg DX
   neg AX
   sbb DX,+00
   or DI,+0C
L076a0536:
   or CX,CX
   jns L076a0544
   neg CX
   neg BX
   sbb CX,+00
   xor DI,+04
L076a0544:
   mov BP,CX
   mov CX,0020
   push DI
   xor DI,DI
   xor SI,SI
L076a054e:
   shl AX,1
   rcl DX,1
   rcl SI,1
   rcl DI,1
   cmp DI,BP
   jb L076a0565
   ja L076a0560
   cmp SI,BX
   jb L076a0565
L076a0560:
   sub SI,BX
   sbb DI,BP
   inc AX
L076a0565:
   loop L076a054e
   pop BX
   test BX,0002
   jz L076a0574
   mov AX,SI
   mov DX,DI
   shr BX,1
L076a0574:
   test BX,0004
   jz L076a0581
   neg DX
   neg AX
   sbb DX,+00
L076a0581:
   pop DI
   pop SI
   pop BP
ret far 0008
L076a0587:
   div BX
   test DI,0002
   jz L076a0591
   mov AX,DX
L076a0591:
   xor DX,DX
jmp near L076a0581

LXRSH@: ;; 076a0595
   cmp CL,10
   jnb L076a05aa
   mov BX,DX
   shr AX,CL
   sar DX,CL
   neg CL
   add CL,10
   shl BX,CL
   or AX,BX
ret far
L076a05aa:
   sub CL,10
   mov AX,DX
   cwd
   sar AX,CL
ret far

PSBP@: ;; 076a05b3
   push DI
   mov DI,CX
   mov CH,DH
   mov CL,04
   shl DX,CL
   shr CH,CL
   add DX,AX
   adc CH,00
   mov AX,DI
   shl DI,CL
   shr AH,CL
   add BX,DI
   adc AH,00
   sub DX,BX
   sbb CH,AH
   mov AL,CH
   cbw
   xchg DX,AX
   pop DI
ret far

SCOPY@: ;; 076a05d8
   push BP
   mov BP,SP
   push SI
   push DI
   push DS
   lds SI,[BP+06]
   les DI,[BP+0A]
   cld
   shr CX,1
   repz movsw
   adc CX,CX
   repz movsb
   pop DS
   pop DI
   pop SI
   pop BP
ret far 0008

;; === Program Files ===
Segment 07c9 ;; COPYFILE.C:COPYFILE
_copyfile: ;; 07c90004
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov AX,1000
   push AX
   call far _malloc
   pop CX
   mov [BP-04],DX
   mov [BP-06],AX
   or AX,DX
   jnz L07c90023
jmp near L07c9009d
L07c90023:
   mov AX,8001
   push AX
   push [BP+08]
   push [BP+06]
   call far __open
   add SP,+06
   mov SI,AX
   or SI,SI
   jl L07c90090
   xor AX,AX
   push AX
   push [BP+0C]
   push [BP+0A]
   call far __creat
   add SP,+06
   mov DI,AX
   or DI,DI
   jl L07c90089
L07c90052:
   mov AX,1000
   push AX
   push [BP-04]
   push [BP-06]
   push SI
   call far __read
   add SP,+08
   mov [BP-02],AX
   or AX,AX
   jle L07c9007c
   push AX
   push [BP-04]
   push [BP-06]
   push DI
   call far __write
   add SP,+08
L07c9007c:
   cmp word ptr [BP-02],+00
   jg L07c90052
   push DI
   call far __close
   pop CX
L07c90089:
   push SI
   call far __close
   pop CX
L07c90090:
   push [BP-04]
   push [BP-06]
   call far _free
   pop CX
   pop CX
L07c9009d:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 07d3 ;; SHM.C:SHM
_shm_init: ;; 07d30003
   push BP
   mov BP,SP
   push SI
   push [BP+08]
   push [BP+06]
   push DS
   mov AX,offset _shm_fname
   push AX
   call far _strcpy
   add SP,+08
   xor SI,SI
jmp near L07d3003b
L07d3001e:
   mov BX,SI
   shl BX,1
   mov word ptr [BX+offset _shm_want],0000
   mov BX,SI
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _shm_tbladdr+02],0000
   mov word ptr [BX+offset _shm_tbladdr],0000
   inc SI
L07d3003b:
   cmp SI,+40
   jl L07d3001e
   mov AX,8001
   push AX
   push DS
   mov AX,offset _shm_fname
   push AX
   call far __open
   add SP,+06
   mov [offset _shafile],AX
   or AX,AX
   jge L07d30062
   mov AX,0073
   push AX
   call far _rexit
   pop CX
L07d30062:
   mov AX,0200
   push AX
   push DS
   mov AX,offset _shoffset
   push AX
   push [offset _shafile]
   call far _read
   add SP,+08
   or AX,AX
   jnz L07d30085
   mov AX,0066
   push AX
   call far _rexit
   pop CX
L07d30085:
   mov AX,0100
   push AX
   push DS
   mov AX,offset _shlen
   push AX
   push [offset _shafile]
   call far _read
   add SP,+08
   or AX,AX
   jnz L07d300a8
   mov AX,0066
   push AX
   call far _rexit
   pop CX
L07d300a8:
   pop SI
   pop BP
ret far

_init8bit: ;; 07d300ab
   push BP
   mov BP,SP
   sub SP,+02
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L07d300c9
   cmp AX,0002
   jz L07d300e8
   cmp AX,0004
   jz L07d30100
jmp near L07d3011b
L07d300c9:
   mov word ptr [BP-02],0000
jmp near L07d300df
L07d300d0:
   mov AL,[BP-02]
   and AL,03
   mov BX,[BP-02]
   mov [BX+offset _colortab],AL
   inc word ptr [BP-02]
L07d300df:
   cmp word ptr [BP-02],0100
   jl L07d300d0
jmp near L07d3011b
L07d300e8:
   mov AX,0100
   push AX
   push DS
   mov AX,offset _egatab
   push AX
   push DS
   mov AX,offset _colortab
   push AX
   call far _memcpy
   add SP,+0A
jmp near L07d3011b
L07d30100:
   mov word ptr [BP-02],0000
jmp near L07d30114
L07d30107:
   mov AL,[BP-02]
   mov BX,[BP-02]
   mov [BX+offset _colortab],AL
   inc word ptr [BP-02]
L07d30114:
   cmp word ptr [BP-02],0100
   jl L07d30107
L07d3011b:
   mov word ptr [BP-02],0000
jmp near L07d3012f
L07d30122:
   mov AL,[BP-02]
   mov BX,[BP-02]
   mov [BX+offset _colortab],AL
   inc word ptr [BP-02]
L07d3012f:
   cmp word ptr [BP-02],0100
   jl L07d30122
   mov SP,BP
   pop BP
ret far

_xlate_table: ;; 07d3013a
   push BP
   mov BP,SP
   sub SP,+2C
   push SI
   push DI
   mov byte ptr [BP-2C],00
   mov byte ptr [BP-2B],01
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-2C]
   push AX
   call far _memcpy
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-2A]
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-24]
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-22]
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-20]
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-2B]
   push AX
   call far _memcpy
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-14]
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP+08],+02
   cmp byte ptr [offset _x_ourmode],00
   jnz L07d30221
   mov AX,[BP-24]
   add AX,0010
   mov [BP-1E],AX
   mov word ptr [BP-0C],0003
   mov word ptr [BP-0A],0000
jmp near L07d30250
L07d30221:
   cmp byte ptr [offset _x_ourmode],02
   jnz L07d3023d
   mov AX,[BP-22]
   add AX,0010
   mov [BP-1E],AX
   mov word ptr [BP-0C],000F
   mov word ptr [BP-0A],0008
jmp near L07d30250
L07d3023d:
   mov AX,[BP-20]
   add AX,0010
   mov [BP-1E],AX
   mov word ptr [BP-0C],00FF
   mov word ptr [BP-0A],0010
L07d30250:
   test word ptr [BP-14],0001
   jz L07d30281
   mov byte ptr [BP-17],00
jmp near L07d3026e
L07d3025d:
   mov AL,[BP-17]
   mov DL,[BP-17]
   mov DH,00
   mov BX,DX
   mov [BX+offset _colortab],AL
   inc byte ptr [BP-17]
L07d3026e:
   mov AX,0001
   mov CL,[BP-2B]
   shl AX,CL
   mov DL,[BP-17]
   mov DH,00
   cmp AX,DX
   jg L07d3025d
jmp near L07d302de
L07d30281:
   cmp byte ptr [BP-2B],08
   jnz L07d3028d
   push CS
   call near offset _init8bit
jmp near L07d302de
L07d3028d:
   mov byte ptr [BP-17],00
jmp near L07d302cd
L07d30293:
   mov AX,0004
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-28]
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP+08],+04
   mov DX,[BP-26]
   mov AX,[BP-28]
   mov CL,[BP-0A]
   call far LXRSH@
   and AL,[BP-0C]
   mov DL,[BP-17]
   mov DH,00
   mov BX,DX
   mov [BX+offset _colortab],AL
   inc byte ptr [BP-17]
L07d302cd:
   mov AX,0001
   mov CL,[BP-2B]
   shl AX,CL
   mov DL,[BP-17]
   mov DH,00
   cmp AX,DX
   jg L07d30293
L07d302de:
   push [BP-1E]
   call far _malloc
   pop CX
   mov [BP-06],DX
   mov [BP-08],AX
   or AX,DX
   jnz L07d302fb
   mov AX,0064
   push AX
   call far _rexit
   pop CX
L07d302fb:
   mov AX,[BP-1E]
   mov BX,[BP+06]
   shl BX,1
   mov [BX+offset _shm_tbllen],AX
   mov DX,[BP-06]
   mov AX,[BP-08]
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   mov [BX+offset _shm_tbladdr+02],DX
   mov [BX+offset _shm_tbladdr],AX
   mov AX,[BP-14]
   mov BX,[BP+06]
   shl BX,1
   mov [BX+offset _shm_flags],AX
   mov word ptr [BP-04],0000
   mov AL,[BP-2C]
   mov AH,00
   shl AX,1
   shl AX,1
   mov [BP-02],AX
   mov byte ptr [BP-17],00
jmp near L07d3073c
L07d30340:
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-1B]
   push AX
   call far _memcpy
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-19]
   push AX
   call far _memcpy
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-18]
   push AX
   call far _memcpy
   add SP,+0A
   inc word ptr [BP+08]
   les BX,[BP+0C]
   mov [BP-10],ES
   mov [BP-12],BX
   mov AL,[BP-1B]
   mov AH,00
   mov DL,[BP-19]
   mov DH,00
   mul DX
   push AX
   push [BP+0A]
   push [BP+08]
   push [BP-10]
   push BX
   call far _memcpy
   add SP,+0A
   mov AL,[BP-1B]
   mov AH,00
   mov DL,[BP-19]
   mov DH,00
   mul DX
   add [BP+08],AX
   cmp byte ptr [BP-2B],08
   jnz L07d303fa
   cmp byte ptr [BP-1B],40
   jnz L07d303fa
   cmp byte ptr [BP-19],0C
   jnz L07d303fa
   cmp byte ptr [offset _x_ourmode],04
   jnz L07d303fa
   mov AX,0300
   push AX
   push [BP-10]
   push [BP-12]
   push DS
   mov AX,offset _vgapal
   push AX
   call far _memmove
   add SP,+0A
   call far _vga_setpal
L07d303fa:
   cmp byte ptr [offset _x_ourmode],00
   jz L07d30404
jmp near L07d304cb
L07d30404:
   mov AL,[BP-1B]
   mov AH,00
   add AX,0003
   mov BX,0004
   cwd
   idiv BX
   mov [BP-1A],AL
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   mov DX,[BP-06]
   mov AX,[BP-08]
   add AX,[BP-04]
   push DX
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP-04],+02
   mov AL,[BP-1A]
   les BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   mov AL,[BP-19]
   mov BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   mov byte ptr [BP-0D],00
   xor DI,DI
jmp near L07d304bf
L07d3045b:
   xor SI,SI
jmp near L07d304b5
L07d3045f:
   les BX,[BP-12]
   add BX,SI
   mov AL,[BP-1B]
   mov AH,00
   mul DI
   add BX,AX
   mov AL,[ES:BX]
   mov AH,00
   mov BX,AX
   mov AL,[BX+offset _colortab]
   mov [BP-0E],AL
   mov AX,SI
   and AL,03
   shl AL,1
   mov CL,06
   sub CL,AL
   mov AL,[BP-0E]
   shl AL,CL
   or [BP-0D],AL
   mov AX,SI
   and AX,0003
   cmp AX,0003
   jz L07d304a1
   mov AL,[BP-1B]
   mov AH,00
   dec AX
   cmp AX,SI
   jnz L07d304b4
L07d304a1:
   mov AL,[BP-0D]
   les BX,[BP-08]
   add BX,[BP-02]
   mov [ES:BX],AL
   inc word ptr [BP-02]
   mov byte ptr [BP-0D],00
L07d304b4:
   inc SI
L07d304b5:
   mov AL,[BP-1B]
   mov AH,00
   cmp AX,SI
   jg L07d3045f
   inc DI
L07d304bf:
   mov AL,[BP-19]
   mov AH,00
   cmp AX,DI
   jg L07d3045b
jmp near L07d30727
L07d304cb:
   cmp byte ptr [offset _x_ourmode],02
   jz L07d304dc
   cmp byte ptr [offset _x_ourmode],03
   jz L07d304dc
jmp near L07d30635
L07d304dc:
   mov AL,[BP-1B]
   mov [BP-1A],AL
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   mov DX,[BP-06]
   mov AX,[BP-08]
   add AX,[BP-04]
   push DX
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP-04],+02
   mov AL,[BP-1A]
   les BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   mov AL,[BP-19]
   mov BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   test word ptr [BP-14],0004
   jnz L07d30596
   xor DI,DI
jmp near L07d3058a
L07d3052b:
   xor SI,SI
jmp near L07d30580
L07d3052f:
   les BX,[BP-12]
   add BX,SI
   mov AL,[BP-1B]
   mov AH,00
   mul DI
   add BX,AX
   mov AL,[ES:BX]
   mov AH,00
   mov BX,AX
   mov AL,[BX+offset _colortab]
   mov BX,[BP-12]
   add BX,SI
   mov DL,[BP-1B]
   mov DH,00
   push AX
   mov AX,DX
   mul DI
   add BX,AX
   mov AL,[ES:BX+01]
   mov AH,00
   mov BX,AX
   mov AL,[BX+offset _colortab]
   mov CL,04
   shl AL,CL
   pop DX
   or DL,AL
   mov [BP-0D],DL
   mov AL,[BP-0D]
   les BX,[BP-08]
   add BX,[BP-02]
   mov [ES:BX],AL
   inc word ptr [BP-02]
   inc SI
   inc SI
L07d30580:
   mov AL,[BP-1B]
   mov AH,00
   cmp AX,SI
   jg L07d3052f
   inc DI
L07d3058a:
   mov AL,[BP-19]
   mov AH,00
   cmp AX,DI
   jg L07d3052b
jmp near L07d30727
L07d30596:
   mov word ptr [BP-16],0008
jmp near L07d30629
L07d3059e:
   xor DI,DI
jmp near L07d3061a
L07d305a3:
   mov byte ptr [BP-0D],00
   xor SI,SI
jmp near L07d30610
L07d305ab:
   les BX,[BP-12]
   add BX,SI
   mov AL,[BP-1B]
   mov AH,00
   mul DI
   add BX,AX
   mov AL,[ES:BX]
   mov AH,00
   mov BX,AX
   mov AL,[BX+offset _colortab]
   mov [BP-0E],AL
   mov AX,[BP-16]
   mov DL,[BP-0E]
   mov DH,00
   test DX,AX
   jz L07d305d8
   mov AX,0001
jmp near L07d305da
L07d305d8:
   xor AX,AX
L07d305da:
   mov DX,SI
   and DL,07
   mov CL,07
   sub CL,DL
   shl AL,CL
   or [BP-0D],AL
   mov AX,SI
   and AX,0007
   cmp AX,0007
   jz L07d305fc
   mov AL,[BP-1B]
   mov AH,00
   dec AX
   cmp AX,SI
   jnz L07d3060f
L07d305fc:
   mov AL,[BP-0D]
   les BX,[BP-08]
   add BX,[BP-02]
   mov [ES:BX],AL
   inc word ptr [BP-02]
   mov byte ptr [BP-0D],00
L07d3060f:
   inc SI
L07d30610:
   mov AL,[BP-1B]
   mov AH,00
   cmp AX,SI
   jg L07d305ab
   inc DI
L07d3061a:
   mov AL,[BP-19]
   mov AH,00
   cmp AX,DI
   jle L07d30626
jmp near L07d305a3
L07d30626:
   sar word ptr [BP-16],1
L07d30629:
   cmp word ptr [BP-16],+00
   jle L07d30632
jmp near L07d3059e
L07d30632:
jmp near L07d30727
L07d30635:
   mov AL,[BP-1B]
   mov [BP-1A],AL
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   mov DX,[BP-06]
   mov AX,[BP-08]
   add AX,[BP-04]
   push DX
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP-04],+02
   mov AL,[BP-1A]
   les BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   mov AL,[BP-19]
   mov BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   test word ptr [BP-14],0004
   jnz L07d306c9
   xor DI,DI
jmp near L07d306be
L07d30684:
   xor SI,SI
jmp near L07d306b4
L07d30688:
   les BX,[BP-12]
   add BX,SI
   mov AL,[BP-1B]
   mov AH,00
   mul DI
   add BX,AX
   mov AL,[ES:BX]
   mov AH,00
   mov BX,AX
   mov AL,[BX+offset _colortab]
   mov [BP-0D],AL
   mov AL,[BP-0D]
   les BX,[BP-08]
   add BX,[BP-02]
   mov [ES:BX],AL
   inc word ptr [BP-02]
   inc SI
L07d306b4:
   mov AL,[BP-1B]
   mov AH,00
   cmp AX,SI
   jg L07d30688
   inc DI
L07d306be:
   mov AL,[BP-19]
   mov AH,00
   cmp AX,DI
   jg L07d30684
jmp near L07d30727
L07d306c9:
   mov word ptr [BP-16],0003
jmp near L07d30721
L07d306d0:
   xor DI,DI
jmp near L07d30715
L07d306d4:
   xor SI,SI
jmp near L07d3070b
L07d306d8:
   mov AX,SI
   add AX,[BP-16]
   les BX,[BP-12]
   add BX,AX
   mov AL,[BP-1B]
   mov AH,00
   mul DI
   add BX,AX
   mov AL,[ES:BX]
   mov AH,00
   mov BX,AX
   mov AL,[BX+offset _colortab]
   mov [BP-0D],AL
   mov AL,[BP-0D]
   les BX,[BP-08]
   add BX,[BP-02]
   mov [ES:BX],AL
   inc word ptr [BP-02]
   add SI,+04
L07d3070b:
   mov AL,[BP-1B]
   mov AH,00
   cmp AX,SI
   jg L07d306d8
   inc DI
L07d30715:
   mov AL,[BP-19]
   mov AH,00
   cmp AX,DI
   jg L07d306d4
   dec word ptr [BP-16]
L07d30721:
   cmp word ptr [BP-16],+00
   jge L07d306d0
L07d30727:
   mov AX,[BP-02]
   cmp AX,[BP-1E]
   jl L07d30739
   mov AX,00C7
   push AX
   call far _exit
   pop CX
L07d30739:
   inc byte ptr [BP-17]
L07d3073c:
   mov AL,[BP-17]
   cmp AL,[BP-2C]
   jnb L07d30747
jmp near L07d30340
L07d30747:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_shm_do: ;; 07d3074d
   push BP
   mov BP,SP
   sub SP,+08
   push SI
   mov AX,1000
   push AX
   call far _malloc
   pop CX
   mov [BP-06],DX
   mov [BP-08],AX
   or AX,DX
   jnz L07d30772
   mov AX,0065
   push AX
   call far _rexit
   pop CX
L07d30772:
   xor SI,SI
jmp near L07d307b9
L07d30776:
   mov BX,SI
   shl BX,1
   cmp word ptr [BX+offset _shm_want],+00
   jnz L07d307b8
   mov BX,SI
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr]
   or AX,[BX+offset _shm_tbladdr+02]
   jz L07d307b8
   mov BX,SI
   shl BX,1
   shl BX,1
   push [BX+offset _shm_tbladdr+02]
   push [BX+offset _shm_tbladdr]
   call far _free
   pop CX
   pop CX
   mov BX,SI
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _shm_tbladdr+02],0000
   mov word ptr [BX+offset _shm_tbladdr],0000
L07d307b8:
   inc SI
L07d307b9:
   cmp SI,+40
   jl L07d30776
   xor SI,SI
jmp near L07d3086a
L07d307c3:
   mov BX,SI
   shl BX,1
   cmp word ptr [BX+offset _shm_want],+00
   jnz L07d307d1
jmp near L07d30869
L07d307d1:
   mov BX,SI
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr]
   or AX,[BX+offset _shm_tbladdr+02]
   jz L07d307e4
jmp near L07d30869
L07d307e4:
   mov BX,SI
   shl BX,1
   cmp word ptr [BX+offset _shlen],+00
   jz L07d30869
   xor AX,AX
   push AX
   mov BX,SI
   shl BX,1
   shl BX,1
   push [BX+offset _shoffset+02]
   push [BX+offset _shoffset]
   push [offset _shafile]
   call far _lseek
   add SP,+08
   mov BX,SI
   shl BX,1
   push [BX+offset _shlen]
   call far _malloc
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   or AX,DX
   jnz L07d3082e
   mov AX,0067
   push AX
   call far _rexit
   pop CX
L07d3082e:
   mov BX,SI
   shl BX,1
   push [BX+offset _shlen]
   push [BP-02]
   push [BP-04]
   push [offset _shafile]
   call far _read
   add SP,+08
   push [BP-06]
   push [BP-08]
   push [BP-02]
   push [BP-04]
   push SI
   push CS
   call near offset _xlate_table
   add SP,+0A
   push [BP-02]
   push [BP-04]
   call far _free
   pop CX
   pop CX
L07d30869:
   inc SI
L07d3086a:
   cmp SI,+40
   jge L07d30872
jmp near L07d307c3
L07d30872:
   push [BP-06]
   push [BP-08]
   call far _free
   pop CX
   pop CX
   pop SI
   mov SP,BP
   pop BP
ret far

_shm_exit: ;; 07d30884
   push SI
   push [offset _shafile]
   call far _close
   pop CX
   xor SI,SI
jmp near L07d308cb
L07d30893:
   mov BX,SI
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr]
   or AX,[BX+offset _shm_tbladdr+02]
   jz L07d308ca
   mov BX,SI
   shl BX,1
   shl BX,1
   push [BX+offset _shm_tbladdr+02]
   push [BX+offset _shm_tbladdr]
   call far _free
   pop CX
   pop CX
   mov BX,SI
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _shm_tbladdr+02],0000
   mov word ptr [BX+offset _shm_tbladdr],0000
L07d308ca:
   inc SI
L07d308cb:
   cmp SI,+40
   jl L07d30893
   pop SI
ret far

Segment 0860 ;; GR.C:GR
_pixaddr_cga: ;; 08600002
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov BX,0004
   cwd
   idiv BX
   cwd
   push DX
   push AX
   mov AX,[BP+08]
   and AX,0001
   mov CL,0D
   shl AX,CL
   cwd
   pop BX
   pop CX
   add BX,AX
   adc CX,DX
   mov AX,[BP+08]
   push CX
   push BX
   mov BX,0002
   cwd
   idiv BX
   mov DX,0050
   mul DX
   cwd
   pop BX
   pop CX
   add BX,AX
   adc CX,DX
   add BX,+00
   adc CX,B800
   push CX
   push BX
   les BX,[BP+0A]
   pop AX
   pop DX
   mov [ES:BX+02],DX
   mov [ES:BX],AX
   mov AL,[BP+06]
   and AL,03
   shl AL,1
   les BX,[BP+0E]
   mov [ES:BX],AL
   pop BP
ret far

_pixaddr_ega: ;; 0860005d
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov DX,0028
   mul DX
   cwd
   push DX
   push AX
   mov AX,[BP+06]
   mov BX,0008
   cwd
   idiv BX
   cwd
   pop BX
   pop CX
   add BX,AX
   adc CX,DX
   mov AX,[offset _drawofs]
   cwd
   add BX,AX
   adc CX,DX
   add BX,+00
   adc CX,A000
   push CX
   push BX
   les BX,[BP+0A]
   pop AX
   pop DX
   mov [ES:BX+02],DX
   mov [ES:BX],AX
   mov AL,[BP+06]
   and AL,07
   les BX,[BP+0E]
   mov [ES:BX],AL
   pop BP
ret far

_pixaddr_vga: ;; 086000a5
   push BP
   mov BP,SP
   mov AX,[offset _drawofs]
   cwd
   push DX
   push AX
   mov AX,[BP+08]
   mov DX,0050
   mul DX
   cwd
   pop BX
   pop CX
   add BX,AX
   adc CX,DX
   mov AX,[BP+06]
   sar AX,1
   sar AX,1
   cwd
   add BX,AX
   adc CX,DX
   add BX,+00
   adc CX,A000
   push CX
   push BX
   les BX,[BP+0A]
   pop AX
   pop DX
   mov [ES:BX+02],DX
   mov [ES:BX],AX
   mov AL,[BP+06]
   and AL,03
   les BX,[BP+0E]
   mov [ES:BX],AL
   pop BP
ret far

_drawshape: ;; 086000eb
   push BP
   mov BP,SP
   sub SP,+0E
   push SI
   push DI
   mov DI,[BP+0C]
   mov AX,[BP+0A]
   and AX,00FF
   mov [BP-02],AX
   mov SI,[BP+0A]
   mov CL,08
   sar SI,CL
   test SI,0040
   jz L08600117
   mov word ptr [BP-04],0003
   xor SI,0040
jmp near L08600125
L08600117:
   mov BX,SI
   shl BX,1
   mov AX,[BX+offset _shm_flags]
   and AX,0001
   mov [BP-04],AX
L08600125:
   or SI,SI
   jg L0860012c
jmp near L086002ab
L0860012c:
   cmp SI,+40
   jl L08600134
jmp near L086002ab
L08600134:
   mov BX,SI
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr]
   or AX,[BX+offset _shm_tbladdr+02]
   jnz L08600178
   mov BX,SI
   shl BX,1
   mov word ptr [BX+offset _shm_want],0001
   call far _shm_do
   mov BX,SI
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr]
   or AX,[BX+offset _shm_tbladdr+02]
   jnz L08600178
   mov DX,[offset _LOST+02]
   mov AX,[offset _LOST]
   mov BX,SI
   shl BX,1
   shl BX,1
   mov [BX+offset _shm_tbladdr+02],DX
   mov [BX+offset _shm_tbladdr],AX
L08600178:
   mov BX,SI
   shl BX,1
   shl BX,1
   mov DX,[BX+offset _shm_tbladdr+02]
   mov AX,[BX+offset _shm_tbladdr]
   cmp DX,[offset _LOST+02]
   jnz L08600195
   cmp AX,[offset _LOST]
   jnz L08600195
jmp near L086002ab
L08600195:
   mov BX,SI
   shl BX,1
   shl BX,1
   les BX,[BX+offset _shm_tbladdr]
   mov AX,[BP-02]
   shl AX,1
   shl AX,1
   add BX,AX
   mov [BP-0C],ES
   mov [BP-0E],BX
   mov BX,SI
   shl BX,1
   shl BX,1
   les BX,[BX+offset _shm_tbladdr]
   push ES
   push BX
   les BX,[BP-0E]
   pop AX
   pop DX
   add AX,[ES:BX]
   mov [BP-08],DX
   mov [BP-0A],AX
   mov AL,[ES:BX+02]
   mov [BP-06],AL
   mov AL,[ES:BX+03]
   mov [BP-05],AL
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   sub DI,AX
   mov AX,[ES:BX+0A]
   sub [BP+0E],AX
   mov AX,[ES:BX+06]
   cmp AX,[BP+0E]
   jg L086001f2
jmp near L086002ab
L086001f2:
   mov AL,[BP-05]
   mov AH,00
   add AX,[BP+0E]
   jge L086001ff
jmp near L086002ab
L086001ff:
   mov AX,[ES:BX+04]
   cmp AX,DI
   jg L0860020a
jmp near L086002ab
L0860020a:
   mov AL,[BP-06]
   mov AH,00
   mul word ptr [offset _pixelsperbyte]
   add AX,DI
   jge L0860021a
jmp near L086002ab
L0860021a:
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L08600232
   cmp AX,0002
   jz L0860025b
   cmp AX,0004
   jz L08600284
jmp near L086002ab
L08600232:
   push [BP-04]
   push [BP-08]
   push [BP-0A]
   mov AL,[BP-05]
   mov AH,00
   push AX
   mov AL,[BP-06]
   mov AH,00
   push AX
   push [BP+0E]
   push DI
   push [BP+08]
   push [BP+06]
   call far _ldrawsh_cga
   add SP,+12
jmp near L086002ab
L0860025b:
   push [BP-04]
   push [BP-08]
   push [BP-0A]
   mov AL,[BP-05]
   mov AH,00
   push AX
   mov AL,[BP-06]
   mov AH,00
   push AX
   push [BP+0E]
   push DI
   push [BP+08]
   push [BP+06]
   call far _ldrawsh_ega
   add SP,+12
jmp near L086002ab
L08600284:
   push [BP-04]
   push [BP-08]
   push [BP-0A]
   mov AL,[BP-05]
   mov AH,00
   push AX
   mov AL,[BP-06]
   mov AH,00
   push AX
   push [BP+0E]
   push DI
   push [BP+08]
   push [BP+06]
   call far _ldrawsh_vga
   add SP,+12
L086002ab:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_plot: ;; 086002b1
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+0C]
   mov SI,[BP+0A]
   or SI,SI
   jge L086002c3
jmp near L08600356
L086002c3:
   or DI,DI
   jge L086002ca
jmp near L08600356
L086002ca:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,SI
   jg L086002d8
jmp near L08600356
L086002d8:
   mov AX,[ES:BX+06]
   cmp AX,DI
   jg L086002e3
jmp near L08600356
L086002e3:
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L086002fb
   cmp AX,0002
   jz L0860031b
   cmp AX,0004
   jz L0860033b
jmp near L08600356
L086002fb:
   mov AL,[BP+0E]
   and AL,03
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,DI
   push AX
   mov AX,[ES:BX]
   add AX,SI
   push AX
   call far _plot_cga
   add SP,+06
jmp near L08600356
L0860031b:
   mov AL,[BP+0E]
   and AL,0F
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,DI
   push AX
   mov AX,[ES:BX]
   add AX,SI
   push AX
   call far _plot_ega
   add SP,+06
jmp near L08600356
L0860033b:
   push [BP+0E]
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,DI
   push AX
   mov AX,[ES:BX]
   add AX,SI
   push AX
   call far _plot_vga
   add SP,+06
L08600356:
   pop DI
   pop SI
   pop BP
ret far

_linex: ;; 0860035a ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L0860036b
jmp near L08600381
L0860036b:
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far _line_cga
   mov SP,BP
L08600381:
   pop BP
ret far

_waitsafe: ;; 08600383
L08600383:
   mov DX,03DA
   in AL,DX
   test AL,08
   jz L08600383
ret far

_setcm_cga: ;; 0860038c
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov AX,[BP+10]
   mov CL,08
   shl AX,CL
   or AX,[BP+08]
   mov [BP-0A],AX
   mov AX,[BP+12]
   mov CL,08
   shl AX,CL
   or AX,[BP+0A]
   mov [BP-08],AX
   mov AX,[BP+14]
   mov CL,08
   shl AX,CL
   or AX,[BP+0C]
   mov [BP-06],AX
   mov AX,[BP+16]
   mov CL,08
   shl AX,CL
   or AX,[BP+0E]
   mov [BP-04],AX
   xor SI,SI
jmp near L08600412
L086003cc:
   xor DI,DI
   mov [BP-02],DI
jmp near L086003f5
L086003d3:
   mov BX,SI
   mov CL,[BP-02]
   shr BX,CL
   and BX,0003
   shl BX,1
   lea AX,[BP-0A]
   add BX,AX
   mov AX,[SS:BX]
   mov CL,[BP-02]
   shl AX,CL
   or AX,DI
   mov DI,AX
   add word ptr [BP-02],+02
L086003f5:
   cmp word ptr [BP-02],+08
   jl L086003d3
   mov BX,[BP+06]
   mov CL,09
   shl BX,CL
   add BX,offset _cmtab
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov [ES:BX],DI
   inc SI
L08600412:
   cmp SI,0100
   jb L086003cc
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_fontcolor_cga: ;; 0860041e
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
   mov DI,SI
jmp near L0860042a
L08600429:
   inc SI
L0860042a:
   mov AX,[BP+06]
   cmp AX,SI
   jz L08600429
   mov AX,[BP+08]
   cmp AX,SI
   jz L08600429
   mov AX,[BP+0A]
   cmp AX,SI
   jz L08600429
   cmp AX,FFFF
   jnz L08600479
jmp near L08600447
L08600446:
   inc DI
L08600447:
   mov AX,[BP+06]
   cmp AX,DI
   jz L08600446
   mov AX,[BP+08]
   cmp AX,DI
   jz L08600446
   cmp SI,DI
   jz L08600446
   xor AX,AX
   push AX
   mov AX,0003
   push AX
   push AX
   xor AX,AX
   push AX
   push DI
   push [BP+08]
   push [BP+06]
   push SI
   mov AX,0001
   push AX
   push CS
   call near offset _setcm_cga
   add SP,+12
jmp near L08600497
L08600479:
   mov AX,0003
   push AX
   push AX
   push AX
   xor AX,AX
   push AX
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push SI
   mov AX,0001
   push AX
   push CS
   call near offset _setcm_cga
   add SP,+12
L08600497:
   pop DI
   pop SI
   pop BP
ret far

_fontcolor_ega: ;; 0860049b
   push BP
   mov BP,SP
   mov word ptr [offset _cmtab+1*0200],0010
   mov AX,[BP+08]
   mov [offset _cmtab+1*0200+02],AX
   mov AX,[BP+06]
   mov [offset _cmtab+1*0200+04],AX
   cmp word ptr [BP+0A],-01
   jnz L086004be
   mov word ptr [offset _cmtab+1*0200+06],0010
jmp near L086004c4
L086004be:
   mov AX,[BP+0A]
   mov [offset _cmtab+1*0200+06],AX
L086004c4:
   pop BP
ret far

_fontcolor_vga: ;; 086004c6
   push BP
   mov BP,SP
   mov word ptr [offset _cmtab+1*0200],00FF
   mov AX,[BP+08]
   mov [offset _cmtab+1*0200+02],AX
   mov AX,[BP+06]
   mov [offset _cmtab+1*0200+04],AX
   cmp word ptr [BP+0A],-01
   jnz L086004e9
   mov word ptr [offset _cmtab+1*0200+06],00FF
jmp near L086004ef
L086004e9:
   mov AX,[BP+0A]
   mov [offset _cmtab+1*0200+06],AX
L086004ef:
   pop BP
ret far

_fntcolor: ;; 086004f1
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+0A]
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L08600510
   cmp AX,0002
   jz L08600538
   cmp AX,0004
   jz L08600548
jmp near L08600556
L08600510:
   cmp SI,-01
   jnz L08600524
   push SI
   mov AX,0002
   push AX
   push AX
   push CS
   call near offset _fontcolor_cga
   add SP,+06
jmp near L08600556
L08600524:
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   mov AX,0003
   push AX
   push CS
   call near offset _fontcolor_cga
   add SP,+06
jmp near L08600556
L08600538:
   push SI
   push [BP+06]
   push [BP+08]
   push CS
   call near offset _fontcolor_ega
   add SP,+06
jmp near L08600556
L08600548:
   push SI
   push [BP+06]
   push [BP+08]
   push CS
   call near offset _fontcolor_vga
   add SP,+06
L08600556:
   pop SI
   pop BP
ret far

_initcolortabs_cga: ;; 08600559
   mov AX,0003
   push AX
   push AX
   push AX
   xor AX,AX
   push AX
   mov AX,0003
   push AX
   mov AX,0002
   push AX
   mov AX,0001
   push AX
   xor AX,AX
   push AX
   push AX
   push CS
   call near offset _setcm_cga
   add SP,+12
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   mov AX,0003
   push AX
   push CS
   call near offset _fontcolor_cga
   add SP,+06
   mov AX,0003
   push AX
   push AX
   push AX
   xor AX,AX
   push AX
   push AX
   push AX
   push AX
   push AX
   mov AX,0002
   push AX
   push CS
   call near offset _setcm_cga
   add SP,+12
   mov AX,0003
   push AX
   push AX
   push AX
   push AX
   push AX
   mov AX,0002
   push AX
   mov AX,0001
   push AX
   xor AX,AX
   push AX
   mov AX,0003
   push AX
   push CS
   call near offset _setcm_cga
   add SP,+12
ret far

_initcolortabs_ega: ;; 086005c2
   push SI
   xor SI,SI
jmp near L086005e2
L086005c7:
   mov BX,SI
   shl BX,1
   mov [BX+offset _cmtab],SI
   mov BX,SI
   shl BX,1
   mov word ptr [BX+offset _cmtab+2*0200],0000
   mov BX,SI
   shl BX,1
   mov [BX+offset _cmtab+2*0200+0200],SI
   inc SI
L086005e2:
   cmp SI,+10
   jl L086005c7
   mov word ptr [offset _cmtab],0010
   mov word ptr [offset _cmtab+2*0200],0010
   pop SI
ret far

_initcolortabs_vga: ;; 086005f5
   push SI
   xor SI,SI
jmp near L08600615
L086005fa:
   mov BX,SI
   shl BX,1
   mov [BX+offset _cmtab],SI
   mov BX,SI
   shl BX,1
   mov word ptr [BX+offset _cmtab+2*0200],0000
   mov BX,SI
   shl BX,1
   mov [BX+offset _cmtab+2*0200+0200],SI
   inc SI
L08600615:
   cmp SI,0100
   jl L086005fa
   mov word ptr [offset _cmtab],00FF
   mov word ptr [offset _cmtab+2*0200],00FF
   pop SI
ret far

_setpages: ;; 08600629
   mov AX,[offset _pageshow]
   mul word ptr [offset _pagelen]
   mov [offset _showofs],AX
   mov AX,[offset _pagedraw]
   mul word ptr [offset _pagelen]
   mov [offset _drawofs],AX
ret far

_setpagemode: ;; 0860063e
   push BP
   mov BP,SP
   cmp word ptr [BP+06],+00
   jz L08600669
   test byte ptr [offset _x_ourmode],FE
   jz L08600669
   mov word ptr [offset _pagemode],0001
   mov AX,0001
   sub AX,[offset _pageshow]
   mov [offset _pagedraw],AX
   push CS
   call near offset _setpages
   call far _lcopypage
jmp near L0860067b
L08600669:
   mov word ptr [offset _pagemode],0000
   mov AX,[offset _pageshow]
   mov [offset _pagedraw],AX
   mov AX,[offset _showofs]
   mov [offset _drawofs],AX
L0860067b:
   pop BP
ret far

_getportnum: ;; 0860067d
   mov BX,segment Y00400063
   mov ES,BX
   mov BX,offset Y00400063
   mov AX,[ES:BX]
ret far

_pageflip: ;; 08600689
   push SI
   test byte ptr [offset _x_ourmode],FE
   jz L086006e9
   mov AX,[offset _pageshow]
   neg AX
   sbb AX,AX
   inc AX
   mov [offset _pageshow],AX
   mov AX,[offset _pagedraw]
   neg AX
   sbb AX,AX
   inc AX
   mov [offset _pagedraw],AX
   push CS
   call near offset _setpages
   push CS
   call near offset _getportnum
   mov SI,AX
L086006b1:
   mov DX,03DA
   in AL,DX
   test AL,08
   jnz L086006b1
   mov AX,[offset _showofs]
   and AX,FF00
   add AX,000C
   push AX
   push SI
   call far _outport
   pop CX
   pop CX
   mov AX,[offset _showofs]
   and AX,00FF
   mov CL,08
   shl AX,CL
   add AX,000D
   push AX
   push SI
   call far _outport
   pop CX
   pop CX
L086006e1:
   mov DX,03DA
   in AL,DX
   test AL,08
   jz L086006e1
L086006e9:
   pop SI
ret far

_wait_vbi: ;; 086006eb ;; (@) Unaccessed.
   cmp byte ptr [offset _x_ourmode],04
   jnz L08600702
L086006f2:
   mov DX,03DA
   in AL,DX
   test AL,08
   jnz L086006f2
L086006fa:
   mov DX,03DA
   in AL,DX
   test AL,08
   jz L086006fa
L08600702:
ret far

_vga_setpal: ;; 08600703
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   xor SI,SI
   mov DI,0100
   cmp byte ptr [offset _x_ourmode],04
   jnz L08600780
   cmp SI,DI
   jg L08600780
   cmp SI,SI
   jl L08600780
   mov AX,SI
   add AX,DI
   cmp AX,DI
   jg L08600780
   push CS
   call near offset _waitsafe
   mov [BP-02],SI
jmp near L08600777
L08600730:
   mov AL,[BP-02]
   mov DX,[offset _DacWrite]
   out DX,AL
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   mov BX,AX
   mov AL,[BX+offset _vgapal]
   mov DX,[offset _DacData]
   out DX,AL
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   mov BX,AX
   inc BX
   mov AL,[BX+offset _vgapal]
   mov DX,[offset _DacData]
   out DX,AL
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   mov BX,AX
   inc BX
   inc BX
   mov AL,[BX+offset _vgapal]
   mov DX,[offset _DacData]
   out DX,AL
   inc word ptr [BP-02]
L08600777:
   mov AX,SI
   add AX,DI
   cmp AX,[BP-02]
   ja L08600730
L08600780:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_readpal: ;; 08600786 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   xor SI,SI
   mov DI,0100
   cmp byte ptr [offset _x_ourmode],04
   jz L0860079d
jmp near L0860082e
L0860079d:
   cmp SI,DI
   jle L086007a6
   mov AX,0001
jmp near L086007a8
L086007a6:
   xor AX,AX
L086007a8:
   push AX
   or SI,SI
   jge L086007b2
   mov AX,0001
jmp near L086007b4
L086007b2:
   xor AX,AX
L086007b4:
   pop DX
   or DX,AX
   push DX
   mov AX,SI
   add AX,DI
   cmp AX,0100
   jle L086007c6
   mov AX,0001
jmp near L086007c8
L086007c6:
   xor AX,AX
L086007c8:
   pop DX
   or DX,AX
   jnz L0860082e
   mov [BP-02],SI
jmp near L08600825
L086007d2:
   mov AL,[BP-02]
   mov DX,[offset _DacRead]
   out DX,AL
   mov DX,[offset _DacData]
   in AL,DX
   push AX
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   les BX,[BP+06]
   add BX,AX
   pop AX
   mov [ES:BX],AL
   mov DX,[offset _DacData]
   in AL,DX
   push AX
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   inc AX
   mov BX,[BP+06]
   add BX,AX
   pop AX
   mov [ES:BX],AL
   mov DX,[offset _DacData]
   in AL,DX
   push AX
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   inc AX
   inc AX
   mov BX,[BP+06]
   add BX,AX
   pop AX
   mov [ES:BX],AL
   inc word ptr [BP-02]
L08600825:
   mov AX,SI
   add AX,DI
   cmp AX,[BP-02]
   ja L086007d2
L0860082e:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_clrpal: ;; 08600834
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   xor SI,SI
   mov DI,0100
   cmp byte ptr [offset _x_ourmode],04
   jnz L0860089e
   cmp SI,DI
   jle L08600851
   mov AX,0001
jmp near L08600853
L08600851:
   xor AX,AX
L08600853:
   push AX
   or SI,SI
   jge L0860085d
   mov AX,0001
jmp near L0860085f
L0860085d:
   xor AX,AX
L0860085f:
   pop DX
   or DX,AX
   push DX
   mov AX,SI
   add AX,DI
   cmp AX,0100
   jle L08600871
   mov AX,0001
jmp near L08600873
L08600871:
   xor AX,AX
L08600873:
   pop DX
   or DX,AX
   jnz L0860089e
   mov [BP-02],SI
jmp near L08600895
L0860087d:
   mov AL,[BP-02]
   mov DX,[offset _DacWrite]
   out DX,AL
   mov AL,00
   mov DX,[offset _DacData]
   out DX,AL
   mov AL,00
   out DX,AL
   mov AL,00
   out DX,AL
   inc word ptr [BP-02]
L08600895:
   mov AX,SI
   add AX,DI
   cmp AX,[BP-02]
   ja L0860087d
L0860089e:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_fadein: ;; 086008a4
   push BP
   mov BP,SP
   sub SP,0302
   push SI
   push DI
   cmp byte ptr [offset _x_ourmode],04
   jnz L08600904
   xor DI,DI
jmp near L086008ff
L086008b8:
   xor SI,SI
jmp near L086008d7
L086008bc:
   mov AL,[SI+offset _vgapal]
   mov AH,00
   mov [BP-02],AX
   mul DI
   mov CL,06
   sar AX,CL
   mov [BP-02],AX
   mov AL,[BP-02]
   mov [SS:BP+SI-0302],AL
   inc SI
L086008d7:
   cmp SI,0300
   jl L086008bc
   push CS
   call near offset _waitsafe
   mov AL,00
   mov DX,[offset _DacWrite]
   out DX,AL
   xor SI,SI
jmp near L086008f7
L086008ec:
   mov AL,[SS:BP+SI-0302]
   mov DX,[offset _DacData]
   out DX,AL
   inc SI
L086008f7:
   cmp SI,0300
   jl L086008ec
   inc DI
   inc DI
L086008ff:
   cmp DI,+40
   jl L086008b8
L08600904:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_setcolor: ;; 0860090a ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AL,[BP+06]
   mov DX,[offset _DacWrite]
   out DX,AL
   mov AL,[BP+08]
   mov DX,[offset _DacData]
   out DX,AL
   mov AL,[BP+0A]
   out DX,AL
   mov AL,[BP+0C]
   out DX,AL
   pop BP
ret far

_fadeout: ;; 08600927
   push BP
   mov BP,SP
   sub SP,0302
   push SI
   push DI
   cmp byte ptr [offset _x_ourmode],04
   jnz L08600987
   mov DI,003F
jmp near L08600983
L0860093c:
   xor SI,SI
jmp near L0860095b
L08600940:
   mov AL,[SI+offset _vgapal]
   mov AH,00
   mov [BP-02],AX
   mul DI
   mov CL,06
   sar AX,CL
   mov [BP-02],AX
   mov AL,[BP-02]
   mov [SS:BP+SI-0302],AL
   inc SI
L0860095b:
   cmp SI,0300
   jl L08600940
   push CS
   call near offset _waitsafe
   mov AL,00
   mov DX,[offset _DacWrite]
   out DX,AL
   xor SI,SI
jmp near L0860097b
L08600970:
   mov AL,[SS:BP+SI-0302]
   mov DX,[offset _DacData]
   out DX,AL
   inc SI
L0860097b:
   cmp SI,0300
   jl L08600970
   dec DI
   dec DI
L08600983:
   or DI,DI
   jge L0860093c
L08600987:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_gr_config: ;; 0860098d
   push SI
   push DS
   mov AX,offset Y2a17049e
   push AX
   call far _cputs
   pop CX
   pop CX
L0860099a:
   call far _k_read
   push AX
   call far _toupper
   pop CX
   mov SI,AX
   cmp SI,+43
   jz L086009bc
   cmp SI,+45
   jz L086009bc
   cmp SI,+56
   jz L086009bc
   cmp SI,+1B
   jnz L0860099a
L086009bc:
   mov AX,SI
   mov CX,0004
   mov BX,offset Y086009d3
L086009c4:
   cmp AX,[CS:BX]
   jz L086009cf
   inc BX
   inc BX
   loop L086009c4
jmp near L086009fc
L086009cf:
jmp near [CS:BX+08]
Y086009d3:	dw 001b,0043,0045,0056
		dw L086009f8,L086009e3,L086009ea,L086009f1
L086009e3:
   mov byte ptr [offset _x_ourmode],00
jmp near L086009fc
L086009ea:
   mov byte ptr [offset _x_ourmode],02
jmp near L086009fc
L086009f1:
   mov byte ptr [offset _x_ourmode],04
jmp near L086009fc
L086009f8:
   xor AX,AX
jmp near L086009ff
L086009fc:
   mov AX,0001
L086009ff:
   pop SI
ret far

_gr_init: ;; 08600a01
   push BP
   mov BP,SP
   sub SP,+14
   push SI
   mov word ptr [BP-14],0F00
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   mov AX,[BP-14]
   and AX,00FF
   mov [offset _origmode],AX
   mov word ptr [offset _pagemode],0000
   mov word ptr [offset _pageshow],0000
   mov word ptr [offset _pagedraw],0000
   mov word ptr [offset _showofs],0000
   mov word ptr [offset _drawofs],0000
   mov word ptr [offset _mainvp],0000
   mov word ptr [offset _mainvp+02],0000
   mov word ptr [offset _mainvp+04],0140
   mov word ptr [offset _mainvp+06],00C8
   mov word ptr [offset _mainvp+08],0000
   mov word ptr [offset _mainvp+0a],0000
   mov AL,[offset _x_ourmode]
   mov AH,00
   or AX,AX
   jz L08600a82
   cmp AX,0002
   jz L08600acb
   cmp AX,0004
   jnz L08600a7f
jmp near L08600b61
L08600a7f:
jmp near L08600c38
L08600a82:
   mov word ptr [BP-14],0004
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   mov word ptr [BP-14],0B00
   mov word ptr [BP-12],0001
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   mov AL,11
   mov DX,03D9
   out DX,AL
   push CS
   call near offset _initcolortabs_cga
   mov byte ptr [offset _x_ourmode],00
   mov word ptr [offset _pixelsperbyte],0004
jmp near L08600b4e
L08600acb:
   mov word ptr [offset _pagelen],2000
   mov byte ptr [offset _x_ourmode],02
   mov word ptr [BP-14],1200
   mov word ptr [BP-12],0031
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   xor SI,SI
jmp near L08600b17
L08600af5:
   mov word ptr [BP-14],1000
   mov AX,SI
   mov CL,08
   shl AX,CL
   add AX,SI
   mov [BP-12],AX
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   inc SI
L08600b17:
   cmp SI,+10
   jl L08600af5
   mov word ptr [BP-14],000D
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   push CS
   call near offset _initcolortabs_ega
   xor AX,AX
   push AX
   mov AX,0009
   push AX
   mov AX,0001
   push AX
   push CS
   call near offset _fontcolor_ega
   add SP,+06
   mov word ptr [offset _pixelsperbyte],0008
L08600b4e:
   mov AL,00
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clrvp
   add SP,+06
jmp near L08600c38
L08600b61:
   mov word ptr [offset _pagelen],4000
   mov byte ptr [offset _x_ourmode],04
   xor SI,SI
jmp near L08600b92
L08600b70:
   mov word ptr [BP-14],1000
   mov AX,SI
   mov CL,08
   shl AX,CL
   add AX,SI
   mov [BP-12],AX
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   inc SI
L08600b92:
   cmp SI,+10
   jl L08600b70
   mov word ptr [BP-14],1200
   mov word ptr [BP-12],0031
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   mov word ptr [BP-14],0013
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   push CS
   call near offset _initcolortabs_vga
   xor AX,AX
   push AX
   mov AX,0022
   push AX
   mov AX,002A
   push AX
   push CS
   call near offset _fontcolor_vga
   add SP,+06
   mov word ptr [offset _pixelsperbyte],0001
   push CS
   call near offset _clrpal
   mov AX,0604
   push AX
   mov AX,03C4
   push AX
   call far _outport
   pop CX
   pop CX
   mov AX,4005
   push AX
   mov AX,03CE
   push AX
   call far _outport
   pop CX
   pop CX
   mov AX,0014
   push AX
   mov AX,03D4
   push AX
   call far _outport
   pop CX
   pop CX
   mov AX,E317
   push AX
   mov AX,03D4
   push AX
   call far _outport
   pop CX
   pop CX
   mov AL,00
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clrvp
   add SP,+06
   push CS
   call near offset _vga_setpal
L08600c38:
   mov AX,0001
   push AX
   call far _malloc
   pop CX
   mov [offset _LOST+02],DX
   mov [offset _LOST],AX
   pop SI
   mov SP,BP
   pop BP
ret far

_gr_exit: ;; 08600c4e
   push BP
   mov BP,SP
   sub SP,+14
   mov AX,[offset _origmode]
   add AX,0000
   mov [BP-14],AX
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   mov SP,BP
   pop BP
ret far

Segment 0927 ;; GAMEGRL.C:GRL
_ldrawsh_cga: ;; 09270002
   push BP
   mov BP,SP
   sub SP,+1C
   push SI
   push DI
   cmp word ptr [BP+0C],+00
   jl L09270025
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   mov [BP-10],AX
   mov AX,[BP+10]
   mov [BP-08],AX
jmp near L09270043
L09270025:
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   mov [BP-10],AX
   mov AX,[BP+10]
   add AX,[BP+0C]
   mov [BP-08],AX
   mov AX,[BP+0C]
   neg AX
   mul word ptr [BP+0E]
   add [BP+12],AX
L09270043:
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov DX,[BP+0C]
   add DX,[BP+10]
   cmp AX,DX
   jg L09270066
   les BX,[BP+06]
   mov AX,[BP+0C]
   add AX,[BP+10]
   mov DX,[ES:BX+06]
   sub AX,DX
   sub [BP-08],AX
L09270066:
   cmp word ptr [BP-08],+00
   jg L0927006f
jmp near L0927026a
L0927006f:
   test word ptr [BP-10],0001
   jz L0927007b
   mov AX,E050
jmp near L0927007e
L0927007b:
   mov AX,2000
L0927007e:
   mov [BP-06],AX
   cmp word ptr [BP+16],+03
   jz L0927008a
jmp near L09270171
L0927008a:
   test word ptr [BP+0A],0003
   jz L09270094
jmp near L09270171
L09270094:
   cmp word ptr [BP+0A],+00
   jl L092700b3
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-12],AX
   mov AX,[BP+0E]
   mov [BP-0A],AX
   mov word ptr [BP-02],0000
jmp near L092700df
L092700b3:
   les BX,[BP+06]
   mov AX,[ES:BX]
   mov [BP-12],AX
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   add AX,[BP+0E]
   mov [BP-0A],AX
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   sub [BP+12],AX
   mov AX,[BP+0A]
   neg AX
   sar AX,1
   sar AX,1
   mov [BP-02],AX
L092700df:
   mov AX,[BP+0E]
   shl AX,1
   shl AX,1
   add AX,[BP+0A]
   les BX,[BP+06]
   cmp AX,[ES:BX+04]
   jl L09270126
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   add AX,[BP+0E]
   les BX,[BP+06]
   mov DX,[ES:BX+04]
   sar DX,1
   sar DX,1
   sub AX,DX
   sub [BP-0A],AX
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   add AX,[BP+0E]
   les BX,[BP+06]
   mov DX,[ES:BX+04]
   sar DX,1
   sar DX,1
   sub AX,DX
   add [BP-02],AX
L09270126:
   cmp word ptr [BP-0A],+00
   jg L0927012f
jmp near L0927026a
L0927012f:
   push SS
   lea AX,[BP-13]
   push AX
   push SS
   lea AX,[BP-1C]
   push AX
   push [BP-10]
   push [BP-12]
   call far _pixaddr_cga
   add SP,+0C
   push DS
   push ES
   cld
   mov AX,[BP-0A]
   mov BX,[BP-02]
   les DI,[BP-1C]
   lds SI,[BP+12]
   mov DX,[BP-08]
L09270159:
   mov CX,AX
   repz movsb
   add DI,[BP-06]
   sub DI,AX
   xor word ptr [BP-06],C050
   add SI,BX
   dec DX
   jnz L09270159
   pop ES
   pop DS
jmp near L0927026a
L09270171:
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-12],AX
   push SS
   lea AX,[BP-13]
   push AX
   push SS
   lea AX,[BP-18]
   push AX
   push [BP-10]
   push [BP-12]
   call far _pixaddr_cga
   add SP,+0C
   mov AL,08
   sub AL,[BP-13]
   mov [BP-13],AL
   mov AX,[BP+0A]
   add AX,FFFD
   mov BX,0004
   cwd
   idiv BX
   inc AX
   neg AX
   mov [BP-0E],AX
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov BX,0004
   cwd
   idiv BX
   push AX
   mov AX,[BP+0A]
   mov BX,0004
   cwd
   idiv BX
   pop DX
   sub DX,AX
   add DX,-02
   mov [BP-0C],DX
   xor AX,AX
   mov DX,[BP-0E]
   inc DX
   cmp AX,DX
   jl L092701df
   mov AX,[BP-0C]
   inc AX
   jge L092701e3
L092701df:
   xor AX,AX
jmp near L092701e6
L092701e3:
   mov AX,FF00
L092701e6:
   mov [BP-04],AX
   mov AX,[BP-16]
   mov [BP-1A],AX
jmp near L09270262
X092701f1:
   nop
L092701f2:
   mov AX,[BP-18]
   mov [BP-1C],AX
   push ES
   mov DX,[BP-04]
   mov BX,0000
L092701ff:
   push BX
   mov DL,DH
   xor DH,DH
   cmp BX,[BP-0E]
   jl L09270210
   cmp BX,[BP-0C]
   jg L09270210
   mov DH,FF
L09270210:
   les DI,[BP+12]
   mov BL,[ES:DI]
   inc word ptr [BP+12]
   mov BH,[BP+16]
   shl BX,1
   mov BX,[BX+offset _cmtab]
   mov AL,BH
   xor BH,BH
   xor AH,AH
   mov CL,[BP-13]
   shl BX,CL
   xchg BL,BH
   shl AX,CL
   xchg AL,AH
   and AX,DX
   les DI,[BP-1C]
   mov CX,[ES:DI]
   and BX,AX
   xor AX,FFFF
   and CX,AX
   or BX,CX
   mov [ES:DI],BX
   inc word ptr [BP-1C]
   pop BX
   inc BX
   cmp BX,[BP+0E]
   jge L09270253
jmp near L092701ff
L09270253:
   mov AX,[BP-06]
   add [BP-18],AX
   xor word ptr [BP-06],C050
   pop ES
   dec word ptr [BP-08]
L09270262:
   cmp word ptr [BP-08],+00
   jle L0927026a
jmp near L092701f2
L0927026a:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_ldrawsh_ega: ;; 09270270
   push BP
   mov BP,SP
   sub SP,+20
   push SI
   push DI
   mov word ptr [BP-0C],0000
   mov word ptr [BP-0A],0000
   mov word ptr [BP-08],0000
   mov word ptr [BP-06],0000
   cmp word ptr [BP+0C],+00
   jl L092702a7
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   mov [BP-16],AX
   mov AX,[BP+10]
   mov [BP-0E],AX
jmp near L092702c5
L092702a7:
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   mov [BP-16],AX
   mov AX,[BP+10]
   add AX,[BP+0C]
   mov [BP-0E],AX
   mov AX,[BP+0C]
   neg AX
   mul word ptr [BP+0E]
   mov [BP-0C],AX
L092702c5:
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov DX,[BP+0C]
   add DX,[BP+10]
   cmp AX,DX
   jg L092702ff
   les BX,[BP+06]
   mov AX,[BP+0C]
   add AX,[BP+10]
   mov DX,[ES:BX+06]
   sub AX,DX
   sub [BP-0E],AX
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   push AX
   mov AX,[BP+0C]
   add AX,[BP+10]
   pop DX
   sub AX,DX
   mul word ptr [BP+0E]
   mov [BP-0A],AX
L092702ff:
   cmp word ptr [BP-0E],+00
   jg L09270308
jmp near L09270551
L09270308:
   cmp word ptr [BP+16],+03
   jz L09270311
jmp near L09270442
L09270311:
   test word ptr [BP+0A],0007
   jz L0927031b
jmp near L09270442
L0927031b:
   sar word ptr [BP+0E],1
   sar word ptr [BP+0E],1
   sar word ptr [BP+0E],1
   sar word ptr [BP-0C],1
   sar word ptr [BP-0C],1
   sar word ptr [BP-0C],1
   sar word ptr [BP-0A],1
   sar word ptr [BP-0A],1
   sar word ptr [BP-0A],1
   cmp word ptr [BP+0A],+00
   jl L09270350
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-18],AX
   mov AX,[BP+0E]
   mov [BP-10],AX
jmp near L09270376
L09270350:
   les BX,[BP+06]
   mov AX,[ES:BX]
   mov [BP-18],AX
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   sar AX,1
   add AX,[BP+0E]
   mov [BP-10],AX
   mov AX,[BP+0A]
   neg AX
   sar AX,1
   sar AX,1
   sar AX,1
   mov [BP-08],AX
L09270376:
   mov AX,[BP+0E]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,[BP+0A]
   les BX,[BP+06]
   cmp AX,[ES:BX+04]
   jl L092703c7
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   sar AX,1
   add AX,[BP+0E]
   les BX,[BP+06]
   mov DX,[ES:BX+04]
   sar DX,1
   sar DX,1
   sar DX,1
   sub AX,DX
   sub [BP-10],AX
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   sar AX,1
   add AX,[BP+0E]
   les BX,[BP+06]
   mov DX,[ES:BX+04]
   sar DX,1
   sar DX,1
   sar DX,1
   sub AX,DX
   mov [BP-06],AX
L092703c7:
   cmp word ptr [BP-10],+00
   jg L092703d0
jmp near L09270551
L092703d0:
   push SS
   lea AX,[BP-03]
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   push [BP-16]
   push [BP-18]
   call far _pixaddr_ega
   add SP,+0C
   push DS
   push ES
   cld
   mov byte ptr [BP-01],08
   mov DX,03CE
   mov AX,0805
   out DX,AX
   mov AX,0007
   out DX,AX
   mov AX,0001
   out DX,AX
   mov AX,0003
   out DX,AX
   mov AX,FF08
   out DX,AX
   lds SI,[BP+12]
L09270409:
   mov DX,03C4
   mov AL,02
   mov AH,[BP-01]
   out DX,AX
   mov BX,[BP-10]
   les DI,[BP-20]
   add SI,[BP-0C]
   mov DX,[BP-0E]
L0927041e:
   add SI,[BP-08]
   mov CX,BX
L09270423:
   lodsb
   and [ES:DI],AL
   inc DI
   loop L09270423
   add DI,+28
   sub DI,BX
   add SI,[BP-06]
   dec DX
   jnz L0927041e
   add SI,[BP-0A]
   ror byte ptr [BP-01],1
   jnb L09270409
   pop ES
   pop DS
jmp near L09270551
L09270442:
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-18],AX
   mov AX,[BP-0C]
   sar AX,1
   add [BP+12],AX
   push SS
   lea AX,[BP-03]
   push AX
   push SS
   lea AX,[BP-1C]
   push AX
   push [BP-16]
   push [BP-18]
   call far _pixaddr_ega
   add SP,+0C
   mov AX,[BP+0A]
   neg AX
   mov [BP-14],AX
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   add AX,[BP-14]
   dec AX
   mov [BP-12],AX
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far _outport
   add SP,+04
   mov AX,0A05
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0F01
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0003
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0007
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
jmp near L09270549
X092704d6:
   nop
L092704d7:
   les BX,[BP-1C]
   mov [BP-1E],ES
   mov [BP-20],BX
   mov byte ptr [BP-04],00
   mov AX,0080
   mov CL,[BP-03]
   sar AX,CL
   mov [BP-02],AL
   mov DX,03CE
   push ES
   mov BX,0000
L092704f6:
   push BX
   cmp BX,[BP-14]
   jl L09270529
   cmp BX,[BP-12]
   jg L09270529
   les DI,[BP+12]
   mov BX,[ES:DI]
   mov CL,[BP-04]
   shr BX,CL
   and BX,+0F
   mov BH,[BP+16]
   shl BX,1
   mov CX,[BX+offset _cmtab]
   cmp CL,10
   jz L09270529
   mov AL,08
   mov AH,[BP-02]
   out DX,AX
   les DI,[BP-20]
   and [ES:DI],CL
L09270529:
   ror byte ptr [BP-02],1
   jnb L09270531
   inc word ptr [BP-20]
L09270531:
   xor byte ptr [BP-04],04
   jnz L0927053a
   inc word ptr [BP+12]
L0927053a:
   pop BX
   inc BX
   cmp BX,[BP+0E]
   jl L092704f6
   pop ES
   add word ptr [BP-1C],+28
   dec word ptr [BP-0E]
L09270549:
   cmp word ptr [BP-0E],+00
   jle L09270551
jmp near L092704d7
L09270551:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_ldrawsh_vga: ;; 09270557
   push BP
   mov BP,SP
   sub SP,+20
   push SI
   push DI
   mov word ptr [BP-0C],0000
   mov word ptr [BP-0A],0000
   mov word ptr [BP-08],0000
   mov word ptr [BP-06],0000
   cmp word ptr [BP+0C],+00
   jl L0927058e
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   mov [BP-16],AX
   mov AX,[BP+10]
   mov [BP-0E],AX
jmp near L092705ac
L0927058e:
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   mov [BP-16],AX
   mov AX,[BP+10]
   add AX,[BP+0C]
   mov [BP-0E],AX
   mov AX,[BP+0C]
   neg AX
   mul word ptr [BP+0E]
   mov [BP-0C],AX
L092705ac:
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov DX,[BP+0C]
   add DX,[BP+10]
   cmp AX,DX
   jg L092705e6
   les BX,[BP+06]
   mov AX,[BP+0C]
   add AX,[BP+10]
   mov DX,[ES:BX+06]
   sub AX,DX
   sub [BP-0E],AX
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   push AX
   mov AX,[BP+0C]
   add AX,[BP+10]
   pop DX
   sub AX,DX
   mul word ptr [BP+0E]
   mov [BP-0A],AX
L092705e6:
   cmp word ptr [BP-0E],+00
   jg L092705ef
jmp near L0927082f
L092705ef:
   cmp word ptr [BP+16],+03
   jz L092705f8
jmp near L09270737
L092705f8:
   test word ptr [BP+0A],0003
   jz L09270602
jmp near L09270737
L09270602:
   sar word ptr [BP+0E],1
   sar word ptr [BP+0E],1
   sar word ptr [BP-0C],1
   sar word ptr [BP-0C],1
   sar word ptr [BP-0A],1
   sar word ptr [BP-0A],1
   cmp word ptr [BP+0A],+00
   jl L0927062e
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-18],AX
   mov AX,[BP+0E]
   mov [BP-10],AX
jmp near L09270650
L0927062e:
   les BX,[BP+06]
   mov AX,[ES:BX]
   mov [BP-18],AX
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   add AX,[BP+0E]
   mov [BP-10],AX
   mov AX,[BP+0A]
   neg AX
   sar AX,1
   sar AX,1
   mov [BP-08],AX
L09270650:
   mov AX,[BP+0E]
   shl AX,1
   shl AX,1
   add AX,[BP+0A]
   les BX,[BP+06]
   cmp AX,[ES:BX+04]
   jl L09270697
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   add AX,[BP+0E]
   les BX,[BP+06]
   mov DX,[ES:BX+04]
   sar DX,1
   sar DX,1
   sub AX,DX
   sub [BP-10],AX
   mov AX,[BP+0A]
   sar AX,1
   sar AX,1
   add AX,[BP+0E]
   les BX,[BP+06]
   mov DX,[ES:BX+04]
   sar DX,1
   sar DX,1
   sub AX,DX
   mov [BP-06],AX
L09270697:
   cmp word ptr [BP-10],+00
   jg L092706a0
jmp near L0927082f
L092706a0:
   push SS
   lea AX,[BP-03]
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   push [BP-16]
   push [BP-18]
   call far _pixaddr_vga
   add SP,+0C
   mov AX,4005
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0001
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0003
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,FF08
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   push DS
   push ES
   cld
   mov byte ptr [BP-01],08
   lds SI,[BP+12]
L09270702:
   mov DX,03C4
   mov AL,02
   mov AH,[BP-01]
   out DX,AX
   mov BX,[BP-10]
   les DI,[BP-20]
   add SI,[BP-0C]
   mov DX,[BP-0E]
L09270717:
   add SI,[BP-08]
   mov CX,BX
   repz movsb
   add DI,+50
   sub DI,BX
   add SI,[BP-06]
   dec DX
   jnz L09270717
   add SI,[BP-0A]
   ror byte ptr [BP-01],1
   jnb L09270702
   pop ES
   pop DS
   out DX,AX
jmp near L0927082f
L09270737:
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-18],AX
   mov AX,[BP-0C]
   add [BP+12],AX
   push SS
   lea AX,[BP-03]
   push AX
   push SS
   lea AX,[BP-1C]
   push AX
   push [BP-16]
   push [BP-18]
   call far _pixaddr_vga
   add SP,+0C
   mov AX,[BP+0A]
   neg AX
   mov [BP-14],AX
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   add AX,[BP-14]
   dec AX
   mov [BP-12],AX
   mov AX,4005
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
jmp near L09270826
L0927078a:
   les BX,[BP-1C]
   mov [BP-1E],ES
   mov [BP-20],BX
   mov AL,11
   mov CL,[BP-03]
   shl AL,CL
   mov [BP-02],AL
   mov DX,03C4
   push ES
   mov BX,0000
   cmp byte ptr [BP+16],00
   jnz L092707e1
L092707aa:
   push BX
   cmp BX,[BP-14]
   jl L092707cc
   cmp BX,[BP-12]
   jg L092707cc
   les DI,[BP+12]
   mov CL,[ES:DI]
   cmp CL,00
   jz L092707cc
   mov AL,02
   mov AH,[BP-02]
   out DX,AX
   les DI,[BP-20]
   mov [ES:DI],CL
L092707cc:
   rol byte ptr [BP-02],1
   jnb L092707d4
   inc word ptr [BP-20]
L092707d4:
   inc word ptr [BP+12]
   pop BX
   inc BX
   cmp BX,[BP+0E]
   jl L092707aa
jmp near L0927081e
X092707e0:
   nop
L092707e1:
   push BX
   cmp BX,[BP-14]
   jl L0927080c
   cmp BX,[BP-12]
   jg L0927080c
   les DI,[BP+12]
   mov BX,[ES:DI]
   mov BH,[BP+16]
   shl BX,1
   mov CX,[BX+offset _cmtab]
   cmp CL,FF
   jz L0927080c
   mov AL,02
   mov AH,[BP-02]
   out DX,AX
   les DI,[BP-20]
   mov [ES:DI],CL
L0927080c:
   rol byte ptr [BP-02],1
   jnb L09270814
   inc word ptr [BP-20]
L09270814:
   inc word ptr [BP+12]
   pop BX
   inc BX
   cmp BX,[BP+0E]
   jl L092707e1
L0927081e:
   pop ES
   add word ptr [BP-1C],+50
   dec word ptr [BP-0E]
L09270826:
   cmp word ptr [BP-0E],+00
   jle L0927082f
jmp near L0927078a
L0927082f:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_ldrawsh_mcga: ;; 09270835 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+18
   push SI
   push DI
   cmp word ptr [BP+0C],+00
   jl L09270858
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   mov [BP-0E],AX
   mov AX,[BP+10]
   mov [BP-04],AX
jmp near L09270876
L09270858:
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   mov [BP-0E],AX
   mov AX,[BP+10]
   add AX,[BP+0C]
   mov [BP-04],AX
   mov AX,[BP+0C]
   neg AX
   mul word ptr [BP+0E]
   add [BP+12],AX
L09270876:
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov DX,[BP+0C]
   add DX,[BP+10]
   cmp AX,DX
   jg L09270899
   les BX,[BP+06]
   mov AX,[BP+0C]
   add AX,[BP+10]
   mov DX,[ES:BX+06]
   sub AX,DX
   sub [BP-04],AX
L09270899:
   cmp word ptr [BP-04],+00
   jg L092708a2
jmp near L092709f2
L092708a2:
   cmp word ptr [BP+16],+03
   jz L092708ab
jmp near L09270966
L092708ab:
   cmp word ptr [BP+0A],+00
   jl L092708ca
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-10],AX
   mov AX,[BP+0E]
   mov [BP-06],AX
   mov word ptr [BP-02],0000
jmp near L092708ea
L092708ca:
   les BX,[BP+06]
   mov AX,[ES:BX]
   mov [BP-10],AX
   mov AX,[BP+0E]
   add AX,[BP+0A]
   mov [BP-06],AX
   mov AX,[BP+0A]
   sub [BP+12],AX
   mov AX,[BP+0A]
   neg AX
   mov [BP-02],AX
L092708ea:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov DX,[BP+0A]
   add DX,[BP+0E]
   cmp AX,DX
   jg L0927091f
   les BX,[BP+06]
   mov AX,[BP+0A]
   add AX,[BP+0E]
   mov DX,[ES:BX+04]
   sub AX,DX
   sub [BP-06],AX
   les BX,[BP+06]
   mov AX,[BP+0A]
   add AX,[BP+0E]
   mov DX,[ES:BX+04]
   sub AX,DX
   add [BP-02],AX
L0927091f:
   cmp word ptr [BP-06],+00
   jg L09270928
jmp near L092709f2
L09270928:
   push SS
   lea AX,[BP-0B]
   push AX
   push SS
   lea AX,[BP-18]
   push AX
   push [BP-0E]
   push [BP-10]
   call far _pixaddr_vga
   add SP,+0C
   push DS
   push ES
   cld
   mov AX,[BP-06]
   mov BX,[BP-02]
   les DI,[BP-18]
   lds SI,[BP+12]
   mov DX,[BP-04]
L09270952:
   mov CX,AX
   repz movsb
   add DI,0140
   sub DI,AX
   add SI,BX
   dec DX
   jnz L09270952
   pop ES
   pop DS
jmp near L092709f2
L09270966:
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-10],AX
   push SS
   lea AX,[BP-0B]
   push AX
   push SS
   lea AX,[BP-14]
   push AX
   push [BP-0E]
   push [BP-10]
   call far _pixaddr_vga
   add SP,+0C
   mov AX,[BP+0A]
   neg AX
   mov [BP-0A],AX
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   add AX,[BP-0A]
   dec AX
   mov [BP-08],AX
jmp near L092709ea
X092709a2:
   nop
L092709a3:
   les BX,[BP-14]
   mov [BP-16],ES
   mov [BP-18],BX
   push ES
   mov DX,0000
L092709b0:
   cmp DX,[BP-0A]
   jl L092709d5
   cmp DX,[BP-08]
   jg L092709d5
   les DI,[BP+12]
   mov BL,[ES:DI]
   mov BH,[BP+16]
   shl BX,1
   mov AL,[BX+offset _cmtab]
   xor AH,AH
   cmp AL,FF
   jz L092709d5
   les DI,[BP-18]
   mov [ES:DI],AL
L092709d5:
   inc word ptr [BP+12]
   inc word ptr [BP-18]
   inc DX
   cmp DX,[BP+0E]
   jl L092709b0
   pop ES
   add word ptr [BP-14],0140
   dec word ptr [BP-04]
L092709ea:
   cmp word ptr [BP-04],+00
   jle L092709f2
jmp near L092709a3
L092709f2:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_scroll: ;; 092709f8
   push BP
   mov BP,SP
   sub SP,+16
   push SI
   push DI
   cmp word ptr [BP+0A],+00
   jge L09270a0d
   mov word ptr [BP+0A],0000
jmp near L09270a23
L09270a0d:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+0A]
   jge L09270a23
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov [BP+0A],AX
L09270a23:
   cmp word ptr [BP+0E],+00
   jge L09270a30
   mov word ptr [BP+0E],0000
jmp near L09270a46
L09270a30:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+0E]
   jge L09270a46
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov [BP+0E],AX
L09270a46:
   cmp word ptr [BP+0C],+00
   jge L09270a53
   mov word ptr [BP+0C],0000
jmp near L09270a69
L09270a53:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+0C]
   jge L09270a69
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov [BP+0C],AX
L09270a69:
   cmp word ptr [BP+10],+00
   jge L09270a76
   mov word ptr [BP+10],0000
jmp near L09270a8c
L09270a76:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+10]
   jge L09270a8c
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov [BP+10],AX
L09270a8c:
   mov AX,[BP+0A]
   cmp AX,[BP+0E]
   jge L09270a9c
   mov AX,[BP+0C]
   cmp AX,[BP+10]
   jl L09270a9f
L09270a9c:
jmp near L09270df2
L09270a9f:
   les BX,[BP+06]
   mov AX,[ES:BX]
   add [BP+0A],AX
   les BX,[BP+06]
   mov AX,[ES:BX]
   add [BP+0E],AX
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add [BP+0C],AX
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add [BP+10],AX
   cmp word ptr [BP+12],+00
   jle L09270ad3
   mov AX,[BP+12]
   sub [BP+0E],AX
jmp near L09270ad9
L09270ad3:
   mov AX,[BP+12]
   sub [BP+0A],AX
L09270ad9:
   cmp word ptr [BP+14],+00
   jle L09270ae7
   mov AX,[BP+14]
   sub [BP+10],AX
jmp near L09270aed
L09270ae7:
   mov AX,[BP+14]
   sub [BP+0C],AX
L09270aed:
   mov AX,[BP+10]
   sub AX,[BP+0C]
   mov [BP-0C],AX
   mov AX,[BP+0E]
   sub AX,[BP+0A]
   mov [BP-0E],AX
   mov word ptr [BP-08],0001
   mov word ptr [BP-0A],0001
   cmp word ptr [BP+14],+00
   jle L09270b1d
   mov AX,[BP+10]
   dec AX
   mov [BP+0C],AX
   mov word ptr [BP-08],FFFF
jmp near L09270b34
L09270b1d:
   cmp word ptr [BP+14],+00
   jnz L09270b34
   cmp word ptr [BP+12],+00
   jle L09270b34
   mov AX,[BP+0E]
   mov [BP+0A],AX
   mov word ptr [BP-0A],FFFF
L09270b34:
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0006
   jbe L09270b44
jmp near L09270df2
L09270b44:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y09270b4d]
Y09270b4d:	dw L09270b5b,L09270df2,L09270c21,L09270df2,L09270cde,L09270df2,L09270d7c
L09270b5b:
   sar word ptr [BP-0E],1
   sar word ptr [BP-0E],1
   sar word ptr [BP-0E],1
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-16]
   push AX
   push [BP+0C]
   push [BP+0A]
   call far _pixaddr_cga
   add SP,+0C
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   mov AX,[BP+0C]
   add AX,[BP+14]
   push AX
   mov AX,[BP+0A]
   add AX,[BP+12]
   push AX
   call far _pixaddr_cga
   add SP,+0C
   mov AX,[BP-08]
   dec AX
   mov BX,0002
   cwd
   idiv BX
   add AX,[BP+0C]
   test AX,0001
   jz L09270bb3
   mov AX,E050
jmp near L09270bb6
L09270bb3:
   mov AX,2000
L09270bb6:
   mov [BP-06],AX
   mov AX,[BP-08]
   dec AX
   mov BX,0002
   cwd
   idiv BX
   add AX,[BP+0C]
   add AX,[BP+14]
   test AX,0001
   jz L09270bd3
   mov AX,E050
jmp near L09270bd6
L09270bd3:
   mov AX,2000
L09270bd6:
   mov [BP-04],AX
   push ES
   push DS
   mov DX,[BP-0C]
   cld
   cmp word ptr [BP-0A],+00
   jge L09270bee
   std
   sub word ptr [BP-16],+02
   sub word ptr [BP-12],+02
L09270bee:
   lds SI,[BP-16]
   les DI,[BP-12]
   mov CX,[BP-0E]
   repz movsw
   mov AX,[BP-06]
   mov BX,[BP-04]
   cmp word ptr [BP-08],+00
   jge L09270c09
   neg AX
   neg BX
L09270c09:
   add [BP-16],AX
   add [BP-12],BX
   mov AX,C050
   xor [BP-06],AX
   xor [BP-04],AX
   dec DX
   jnz L09270bee
   cld
   pop DS
   pop ES
jmp near L09270df2
L09270c21:
   sar word ptr [BP-0E],1
   sar word ptr [BP-0E],1
   sar word ptr [BP-0E],1
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-16]
   push AX
   push [BP+0C]
   push [BP+0A]
   call far _pixaddr_ega
   add SP,+0C
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   mov AX,[BP+0C]
   add AX,[BP+14]
   push AX
   mov AX,[BP+0A]
   add AX,[BP+12]
   push AX
   call far _pixaddr_ega
   add SP,+0C
   mov AX,[BP-08]
   mov DX,0028
   mul DX
   mov [BP-08],AX
   mov AX,0105
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far _outport
   add SP,+04
   mov AX,0104
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   push ES
   push DS
   mov BX,[BP-0C]
   mov AX,[BP-08]
   cld
   cmp word ptr [BP-0A],+00
   jge L09270cb3
   std
   dec word ptr [BP-16]
   dec word ptr [BP-12]
L09270cb3:
   push AX
   push DX
   mov DX,03CE
   mov AX,0105
   out DX,AX
   mov DX,03C4
   mov AX,0F02
   out DX,AX
   pop DX
   pop AX
   lds SI,[BP-16]
   les DI,[BP-12]
   mov CX,[BP-0E]
   repz movsb
   add [BP-16],AX
   add [BP-12],AX
   dec BX
   jnz L09270cb3
   pop DS
   pop ES
jmp near L09270df2
L09270cde:
   sar word ptr [BP-0E],1
   sar word ptr [BP-0E],1
   mov AX,[BP-08]
   mov DX,0050
   mul DX
   mov [BP-08],AX
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-16]
   push AX
   push [BP+0C]
   push [BP+0A]
   call far _pixaddr_vga
   add SP,+0C
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   mov AX,[BP+0C]
   add AX,[BP+14]
   push AX
   mov AX,[BP+0A]
   add AX,[BP+12]
   push AX
   call far _pixaddr_vga
   add SP,+0C
   mov AX,4905
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far _outport
   add SP,+04
   push ES
   push DS
   mov BX,[BP-0C]
   mov AX,[BP-08]
   cld
   mov DX,[BP-0E]
   sub AX,DX
   cmp word ptr [BP-0A],+00
   jge L09270d66
   std
   add AX,DX
   add AX,DX
   dec word ptr [BP-16]
   dec word ptr [BP-12]
L09270d66:
   lds SI,[BP-16]
   les DI,[BP-12]
L09270d6c:
   mov CX,DX
   repz movsb
   add SI,AX
   add DI,AX
   dec BX
   jnz L09270d6c
   pop DS
   pop ES
jmp near L09270df2
X09270d7b:
   nop
L09270d7c:
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-16]
   push AX
   push [BP+0C]
   push [BP+0A]
   call far _pixaddr_vga
   add SP,+0C
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   mov AX,[BP+0C]
   add AX,[BP+14]
   push AX
   mov AX,[BP+0A]
   add AX,[BP+12]
   push AX
   call far _pixaddr_vga
   add SP,+0C
   mov AX,[BP-08]
   mov DX,0140
   mul DX
   mov [BP-08],AX
   sar word ptr [BP-0E],1
   push ES
   push DS
   mov BX,[BP-0C]
   mov AX,[BP-08]
   cld
   cmp word ptr [BP-0A],+00
   jge L09270dda
   std
   sub word ptr [BP-16],+02
   sub word ptr [BP-12],+02
L09270dda:
   lds SI,[BP-16]
   les DI,[BP-12]
   mov CX,[BP-0E]
   repz movsw
   add [BP-16],AX
   add [BP-12],AX
   dec BX
   jnz L09270dda
   pop DS
   pop ES
jmp near L09270df2
L09270df2:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_lcopypage: ;; 09270df8
   push SI
   push DI
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jz L09270e17
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0004
   jz L09270e17
jmp near L09270e70
X09270e16:
   nop
L09270e17:
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jnz L09270e36
   mov AX,0105
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
jmp near L09270e46
L09270e36:
   mov AX,4105
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
L09270e46:
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far _outport
   add SP,+04
   push ES
   push DS
   cld
   mov CX,[offset _pagelen]
   mov SI,[offset _showofs]
   mov DI,[offset _drawofs]
   mov AX,A000
   mov ES,AX
   mov DS,AX
   repnz movsb
   pop DS
   pop ES
L09270e70:
   pop DI
   pop SI
ret far

_scrollvp: ;; 09270e73
   push BP
   mov BP,SP
   push [BP+0C]
   push [BP+0A]
   les BX,[BP+06]
   push [ES:BX+06]
   les BX,[BP+06]
   push [ES:BX+04]
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _scroll
   mov SP,BP
   pop BP
ret far

_clrvp: ;; 09270e9e
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0006
   jbe L09270eb6
jmp near L092710b9
L09270eb6:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y09270ebf]
Y09270ebf:	dw L09270ecd,L092710b9,L09270f6a,L092710b9,L09271012,L092710b9,L092710b7
L09270ecd:
   mov AL,[BP+0A]
   and AL,03
   mov [BP-01],AL
   mov byte ptr [BP-01],00
   mov AL,[BP-01]
   shl AL,1
   shl AL,1
   or AL,[BP-01]
   mov DL,[BP-01]
   mov CL,04
   shl DL,CL
   or AL,DL
   mov DL,[BP-01]
   mov CL,06
   shl DL,CL
   or AL,DL
   mov [BP-01],AL
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   sar AX,1
   sar AX,1
   sar AX,1
   mov [BP-0C],AX
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov [BP-0A],AX
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   les BX,[BP+06]
   push [ES:BX+02]
   les BX,[BP+06]
   push [ES:BX]
   call far _pixaddr_cga
   add SP,+0C
   les BX,[BP+06]
   test word ptr [ES:BX+02],0001
   jz L09270f41
   mov AX,E050
jmp near L09270f44
L09270f41:
   mov AX,2000
L09270f44:
   mov [BP-08],AX
   push ES
   cld
   mov DX,[BP-08]
   mov BX,[BP-0A]
   mov AL,[BP-01]
   mov AH,AL
L09270f54:
   les DI,[BP-06]
   mov CX,[BP-0C]
   repz stosw
   add [BP-06],DX
   xor DX,C050
   dec BX
   jnz L09270f54
   pop ES
jmp near L092710b9
L09270f6a:
   and byte ptr [BP+0A],0F
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   les BX,[BP+06]
   push [ES:BX+02]
   les BX,[BP+06]
   push [ES:BX]
   call far _pixaddr_ega
   add SP,+0C
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov [BP-0A],AX
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   sar AX,1
   sar AX,1
   sar AX,1
   mov [BP-0C],AX
   mov AX,0205
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0F01
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0003
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,FF08
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far _outport
   add SP,+04
   push ES
   cld
   mov BX,[BP-0A]
L09270ffc:
   les DI,[BP-06]
   mov AL,[BP+0A]
   mov CX,[BP-0C]
   repz stosb
   add word ptr [BP-06],+28
   dec BX
   jnz L09270ffc
   pop ES
jmp near L092710b9
L09271012:
   push SS
   lea AX,[BP-01]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   les BX,[BP+06]
   push [ES:BX+02]
   les BX,[BP+06]
   push [ES:BX]
   call far _pixaddr_vga
   add SP,+0C
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov [BP-0A],AX
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   sar AX,1
   sar AX,1
   sar AX,1
   mov [BP-0C],AX
   mov AX,0003
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0001
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,4005
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,FF08
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far _outport
   add SP,+04
   push ES
   cld
   mov BX,[BP-0A]
L092710a0:
   les DI,[BP-06]
   mov AL,[BP+0A]
   mov AH,AL
   mov CX,[BP-0C]
   repnz stosw
   add word ptr [BP-06],+50
   dec BX
   jnz L092710a0
   pop ES
jmp near L092710b9
L092710b7:
jmp near L092710b9
L092710b9:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Y092710bf:	byte

Segment 0a33 ;; GRASM.ASM:GRASM
;; (@) Unnamed far calls: A0a330000, A0a330024, A0a330047
A0a330000:
   mov CL,BL
   xchg AH,AL
   shr AX,1
   add BH,AL
   xor AL,AL
   add BX,AX
   shr AX,1
   shr AX,1
   add BX,AX
   shr BX,1
   shr BX,1
   mov AX,B800
   mov ES,AX
   mov AH,03
   and CL,AH
   xor CL,AH
   shl CL,1
ret far

A0a330024:
   mov CL,BL
   push DX
   mov DX,0028
   mul DX
   pop DX
   shr BX,1
   shr BX,1
   shr BX,1
   add BX,AX
   add BX,[offset _drawofs]
   mov AX,A000
   mov ES,AX
   and CL,07
   xor CL,07
   mov AH,01
ret far

A0a330047:
   mov CL,BL
   push DX
   mov DX,0050
   mul DX
   pop DX
   shr BX,1
   shr BX,1
   add BX,AX
   add BX,[offset _drawofs]
   mov AX,A000
   mov ES,AX
   and CL,03
   mov AH,01
ret far

X0a330065:
   xchg AH,AL
   add BX,AX
   shr AX,1
   shr AX,1
   add BX,AX
   mov AX,A000
   mov ES,AX
ret far

_plot_cga: ;; 0a330075
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a330000
   mov AL,[BP+0A]
   shl AX,CL
   not AH
   and [ES:BX],AH
   or [ES:BX],AL
   mov SP,BP
   pop BP
ret far

_plot_ega: ;; 0a330094
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a330024
   shl AH,CL
   mov DX,03CE
   mov AL,08
   out DX,AX
   mov AX,0205
   out DX,AX
   mov AX,0003
   out DX,AX
   mov AX,0001
   out DX,AX
   mov AL,[ES:BX]
   mov AL,[BP+0A]
   mov [ES:BX],AL
   mov AX,0005
   out DX,AX
   mov SP,BP
   pop BP
ret far

X0a3300c7:
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a330047
   mov AL,[BP+0A]
   mov [ES:BX],AL
   mov SP,BP
   pop BP
ret far

_plot_vga: ;; 0a3300df
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a330047
   shl AH,CL
   mov AL,02
   mov DX,03C4
   out DX,AX
   mov DX,03CE
   mov AX,4005
   out DX,AX
   mov AX,0001
   out DX,AX
   mov AX,FF08
   out DX,AX
   mov AL,[BP+0A]
   mov [ES:BX],AL
   mov SP,BP
   pop BP
ret far

_readpix_vga: ;; 0a33010e
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a330047
   shl AH,CL
   mov AL,02
   mov DX,03C4
   out DX,AX
   mov DX,03CE
   mov AL,04
   mov AH,CL
   out DX,AX
   mov AX,4005
   out DX,AX
   mov AX,0001
   out DX,AX
   mov AX,FF08
   out DX,AX
   mov AL,[ES:BX]
   mov SP,BP
   pop BP
   mov [offset _pixvalue],AL
ret far

_line_cga: ;; 0a330142
   push BP
   mov BP,SP
   sub SP,+08
   push SI
   push DI
   mov SI,2000
   mov DI,E050
   mov CX,[BP+0A]
   sub CX,[BP+06]
   jz L0a3301c7
   jns L0a33016e
   neg CX
   mov BX,[BP+0A]
   xchg BX,[BP+06]
   mov [BP+0A],BX
   mov BX,[BP+0C]
   xchg BX,[BP+08]
   mov [BP+0C],BX
L0a33016e:
   mov BX,[BP+0C]
   sub BX,[BP+08]
   jnz L0a330179
jmp near L0a3301fe
L0a330179:
   jns L0a330183
   neg BX
   neg SI
   neg DI
   xchg SI,DI
L0a330183:
   mov [BP-02],DI
   mov word ptr [BP-08],0262
   cmp BX,CX
   jle L0a330196
   mov word ptr [BP-08],02AB
   xchg BX,CX
L0a330196:
   shl BX,1
   mov [BP-04],BX
   sub BX,CX
   mov DI,BX
   sub BX,CX
   mov [BP-06],BX
   push CX
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a330000
   mov AL,[BP+0E]
   shl AX,CL
   mov DX,AX
   not DH
   pop CX
   inc CX
   test BX,2000
   jz L0a3301c4
   xchg SI,[BP-02]
L0a3301c4:
jmp near [BP-08]
L0a3301c7:
   mov AX,[BP+08]
   mov BX,[BP+0C]
   mov CX,BX
   sub CX,AX
   jge L0a3301d7
   neg CX
   mov AX,BX
L0a3301d7:
   inc CX
   mov BX,[BP+06]
   push CX
   call far A0a330000
   mov AL,[BP+0E]
   shl AX,CL
   not AH
   pop CX
   test BX,SI
   jz L0a3301ef
   xchg SI,DI
L0a3301ef:
   and [ES:BX],AH
   or [ES:BX],AL
   add BX,SI
   xchg SI,DI
   loop L0a3301ef
jmp near L0a3302d2
L0a3301fe:
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a330000
   mov DI,BX
   mov DH,AH
   not DH
   mov DL,FF
   shl DH,CL
   not DH
   mov CX,[BP+0A]
   and CL,03
   xor CL,03
   shl CL,1
   shl DL,CL
   mov AX,[BP+0A]
   mov BX,[BP+06]
   mov CL,02
   shr AX,CL
   shr BX,CL
   mov CX,AX
   sub CX,BX
   mov BX,offset Y0a3302d8
   mov AL,[BP+0E]
   xlat
   or DH,DH
   js L0a330253
   or CX,CX
   jnz L0a330245
   and DL,DH
jmp near L0a330255
L0a330245:
   mov AH,AL
   and AH,DH
   not DH
   and [ES:DI],DH
   or [ES:DI],AH
   inc DI
   dec CX
L0a330253:
   repz stosb
L0a330255:
   and AL,DL
   not DL
   and [ES:DI],DL
   or [ES:DI],AL
jmp near L0a3302d2
X0a330261:
   nop
L0a330262:
   mov AH,[ES:BX]
L0a330265:
   and AH,DH
   or AH,DL
   ror DL,1
   ror DL,1
   ror DH,1
   ror DH,1
   jnb L0a330290
   or DI,DI
   jns L0a330281
   add DI,[BP-04]
   loop L0a330265
   mov [ES:BX],AH
jmp near L0a3302d2
L0a330281:
   add DI,[BP-06]
   mov [ES:BX],AH
   add BX,SI
   xchg SI,[BP-02]
   loop L0a330262
jmp near L0a3302d2
L0a330290:
   mov [ES:BX],AH
   inc BX
   or DI,DI
   jns L0a33029f
   add DI,[BP-04]
   loop L0a330262
jmp near L0a3302d2
L0a33029f:
   add DI,[BP-06]
   add BX,SI
   xchg SI,[BP-02]
   loop L0a330262
jmp near L0a3302d2
L0a3302ab:
   and [ES:BX],DH
   or [ES:BX],DL
   add BX,SI
   xchg SI,[BP-02]
   or DI,DI
   jns L0a3302c1
   add DI,[BP-04]
   loop L0a3302ab
jmp near L0a3302d2
L0a3302c1:
   add DI,[BP-06]
   ror DL,1
   ror DL,1
   ror DH,1
   ror DH,1
   cmc
   adc BX,+00
   loop L0a3302ab
L0a3302d2:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Y0a3302d8:	db 00,55,aa,ff

_drawsh_cga: ;; 0a3302dc ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+02
   push DS
   push SI
   push DI
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a330000
   mov DI,BX
   mov BX,2000
   test DI,2000
   jz L0a3302fe
   mov BX,E050
L0a3302fe:
   mov [BP-02],BX
   cmp CL,00
   jnz L0a33032b
   mov CX,[BP+0A]
L0a330309:
   push DI
   push CX
   push DS
   lds SI,[BP+06]
   mov AX,SI
   repz movsb
   pop DS
   pop CX
   pop DI
   add AX,CX
   mov [BP+08],AX
   add DI,[BP-02]
   xor word ptr [BP-02],C050
   dec word ptr [BP+0C]
   jnz L0a330309
jmp near L0a330360
X0a33032a:
   nop
L0a33032b:
   mov DX,00FF
   ror DX,CL
   mov BX,[BP+0A]
L0a330333:
   push DI
   push BX
   push DS
   lds SI,[BP+06]
L0a330339:
   and [ES:DI],DX
   lodsb
   xor AH,AH
   rol AX,CL
   or [ES:DI],AX
   inc DI
   dec BX
   jnz L0a330339
   pop DS
   pop BX
   pop DI
   mov CX,[BP+08]
   add CX,BX
   mov [BP+08],CX
   add DI,[BP-02]
   xor word ptr [BP-02],C050
   dec word ptr [BP+0C]
   jnz L0a330333
L0a330360:
   pop DI
   pop SI
   pop DS
   mov SP,BP
   pop BP
ret far

Segment 0a69 ;; KEYBOARD.C:KEYBOARD
_k_pressed: ;; 0a690007
   push BP
   mov BP,SP
   sub SP,+14
   mov word ptr [BP-14],0100
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0016
   push AX
   call far _intr
   add SP,+06
   mov AX,[BP-02]
   mov CL,06
   shr AX,CL
   test AX,0001
   jnz L0a690056
   mov AX,[BP-14]
   mov CL,08
   shr AX,CL
   or AX,0080
   push AX
   test word ptr [BP-14],00FF
   jnz L0a690046
   mov DX,0001
jmp near L0a690048
L0a690046:
   xor DX,DX
L0a690048:
   pop AX
   mul DX
   mov DX,[BP-14]
   and DX,00FF
   add AX,DX
jmp near L0a690058
L0a690056:
   xor AX,AX
L0a690058:
   mov SP,BP
   pop BP
ret far

_k_read: ;; 0a69005c
   push BP
   mov BP,SP
   sub SP,+14
   mov word ptr [BP-14],0000
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0016
   push AX
   call far _intr
   add SP,+06
   mov AX,[BP-14]
   mov CL,08
   shr AX,CL
   or AX,0080
   push AX
   test word ptr [BP-14],00FF
   jnz L0a69008f
   mov DX,0001
jmp near L0a690091
L0a69008f:
   xor DX,DX
L0a690091:
   pop AX
   mul DX
   mov DX,[BP-14]
   and DX,00FF
   add AX,DX
   mov SP,BP
   pop BP
ret far

_k_status: ;; 0a6900a1
   push BP
   mov BP,SP
   sub SP,+14
   mov word ptr [BP-14],0200
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0016
   push AX
   call far _intr
   add SP,+06
   mov AL,[BP-14]
   and AL,01
   mov [offset _k_rshift],AL
   mov AX,[BP-14]
   shr AX,1
   and AL,01
   mov [offset _k_lshift],AL
   mov AX,[BP-14]
   shr AX,1
   shr AX,1
   and AL,01
   mov [offset _k_ctrl],AL
   mov AX,[BP-14]
   shr AX,1
   shr AX,1
   shr AX,1
   and AL,01
   mov [offset _k_alt],AL
   mov AX,[BP-14]
   mov CL,05
   shr AX,CL
   and AL,01
   mov [offset _k_numlock],AL
   mov AL,[offset _k_rshift]
   or AL,[offset _k_lshift]
   mov [offset _k_shift],AL
   mov SP,BP
   pop BP
ret far

_installhandler: ;; 0a690103
   push BP
   mov BP,SP
   mov word ptr [offset _bhead+02],segment Y0040001a
   mov word ptr [offset _bhead],offset Y0040001a
   mov word ptr [offset _btail+02],segment Y0040001c
   mov word ptr [offset _btail],offset Y0040001c
   xor AX,AX
   push AX
   mov AX,0200
   push AX
   push DS
   mov AX,offset _keydown
   push AX
   call far _memset
   mov SP,BP
   mov AX,0009
   push AX
   call far _getvect
   pop CX
   mov [offset _oldint9+02],DX
   mov [offset _oldint9],AX
   mov AL,[BP+06]
   mov [offset _bioscall],AL
   mov AX,segment _handler
   push AX
   mov AX,offset _handler
   push AX
   mov AX,0009
   push AX
   call far _setvect
   mov SP,BP
   pop BP
ret far

_removehandler: ;; 0a69015d
   push [offset _oldint9+02]
   push [offset _oldint9]
   mov AX,0009
   push AX
   call far _setvect
   add SP,+06
ret far

_disablebios: ;; 0a690172 ;; (@) Unaccessed.
   mov byte ptr [offset _bioscall],00
ret far

_enablebios: ;; 0a690178 ;; (@) Unaccessed.
   les BX,[offset _btail]
   mov AX,[ES:BX]
   les BX,[offset _bhead]
   mov [ES:BX],AX
   mov byte ptr [offset _bioscall],01
ret far

_biosstatus: ;; 0a69018c ;; (@) Unaccessed.
   cmp byte ptr [offset _bioscall],00
   jnz L0a690197
   xor AX,AX
jmp near L0a69019a
L0a690197:
   mov AX,0001
L0a69019a:
ret far

Segment 0a82 ;; WIN.C:WIN
_defwin: ;; 0a82000b
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+12]
   mov DI,[BP+0A]
   mov AX,[BP+16]
   les BX,[BP+06]
   mov [ES:BX],AX
   xor AX,AX
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _initvp
   add SP,+06
   mov AX,DI
   shl AX,1
   shl AX,1
   shl AX,1
   les BX,[BP+06]
   mov [ES:BX+18],AX
   mov AX,[BP+0C]
   mov [ES:BX+1A],AX
   mov AX,[BP+0E]
   mov CL,04
   shl AX,CL
   add AX,0010
   mov [ES:BX+1C],AX
   mov AX,[BP+10]
   mov CL,04
   shl AX,CL
   push AX
   test word ptr [BP+16],0002
   jz L0a82006c
   mov AX,0010
jmp near L0a82006f
L0a82006c:
   mov AX,001C
L0a82006f:
   pop DX
   add DX,AX
   les BX,[BP+06]
   mov [ES:BX+1E],DX
   xor AX,AX
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0028
   push DX
   push AX
   call far _initvp
   add SP,+06
   mov AX,DI
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,0008
   les BX,[BP+06]
   mov [ES:BX+28],AX
   test word ptr [BP+16],0002
   jz L0a8200ac
   mov AX,0008
jmp near L0a8200af
L0a8200ac:
   mov AX,0010
L0a8200af:
   add AX,[BP+0C]
   les BX,[BP+06]
   mov [ES:BX+2A],AX
   mov AX,[BP+0E]
   mov CL,04
   shl AX,CL
   mov [ES:BX+2C],AX
   mov AX,[BP+10]
   mov CL,04
   shl AX,CL
   mov [ES:BX+2E],AX
   or SI,SI
   jz L0a8200ed
   mov AX,SI
   mov CL,04
   shl AX,CL
   add AX,0008
   sub [ES:BX+2C],AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   add AX,0008
   add [ES:BX+28],AX
L0a8200ed:
   mov AX,0008
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0038
   push DX
   push AX
   call far _initvp
   add SP,+06
   mov AX,DI
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,0008
   les BX,[BP+06]
   mov [ES:BX+38],AX
   mov AX,[BP+0C]
   add AX,0010
   mov [ES:BX+3A],AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   mov [ES:BX+3C],AX
   mov AX,[BP+14]
   mov CL,04
   shl AX,CL
   add AX,0005
   mov [ES:BX+3E],AX
   mov AX,0008
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0048
   push DX
   push AX
   call far _initvp
   add SP,+06
   mov AX,DI
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,0008
   les BX,[BP+06]
   mov [ES:BX+48],AX
   mov AX,[BP+14]
   mov CL,04
   shl AX,CL
   add AX,[BP+0C]
   add AX,001B
   mov [ES:BX+4A],AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   mov [ES:BX+4C],AX
   mov AX,[BP+10]
   mov CL,04
   shl AX,CL
   mov DX,[BP+14]
   mov CL,04
   shl DX,CL
   sub AX,DX
   add AX,FFF5
   mov [ES:BX+4E],AX
   mov [ES:BX+04],DI
   mov AX,DI
   shl AX,1
   shl AX,1
   shl AX,1
   mov [ES:BX+02],AX
   mov AX,[BP+0C]
   mov [ES:BX+06],AX
   mov AX,[BP+0E]
   mov [ES:BX+0A],AX
   mov CL,04
   shl AX,CL
   mov [ES:BX+08],AX
   mov AX,[BP+10]
   mov [ES:BX+0E],AX
   mov CL,04
   shl AX,CL
   mov [ES:BX+0C],AX
   mov [ES:BX+12],SI
   mov AX,SI
   mov CL,04
   shl AX,CL
   mov [ES:BX+10],AX
   mov AX,[BP+14]
   mov [ES:BX+16],AX
   mov CL,04
   shl AX,CL
   mov [ES:BX+14],AX
   pop DI
   pop SI
   pop BP
ret far

_drawwin: ;; 0a8201e8
   push BP
   mov BP,SP
   push SI
   push DI
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _clearvp
   pop CX
   pop CX
   les BX,[BP+06]
   test word ptr [ES:BX],0002
   jnz L0a82020c
jmp near L0a8203a9
L0a82020c:
   xor AX,AX
   push AX
   push AX
   mov AX,4701
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   xor AX,AX
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,4703
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   add AX,0008
   push AX
   xor AX,AX
   push AX
   mov AX,4706
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   add AX,0008
   push AX
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,4708
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   mov SI,0001
jmp near L0a8202ea
L0a82029c:
   xor AX,AX
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,4702
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   add AX,0008
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,4707
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   inc SI
L0a8202ea:
   les BX,[BP+06]
   mov AX,[ES:BX+0A]
   shl AX,1
   inc AX
   cmp AX,SI
   jg L0a82029c
   mov SI,0001
jmp near L0a82034b
L0a8202fd:
   mov AX,SI
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   xor AX,AX
   push AX
   mov AX,4704
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   mov AX,SI
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,4705
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   inc SI
L0a82034b:
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   shl AX,1
   inc AX
   cmp AX,SI
   jg L0a8202fd
   xor SI,SI
jmp near L0a820399
L0a82035d:
   xor DI,DI
jmp near L0a82038b
L0a820361:
   mov AX,DI
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,4709
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0028
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   inc DI
L0a82038b:
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   shl AX,1
   cmp AX,DI
   jg L0a820361
   inc SI
L0a820399:
   les BX,[BP+06]
   mov AX,[ES:BX+0A]
   shl AX,1
   cmp AX,SI
   jg L0a82035d
jmp near L0a8206a4
L0a8203a9:
   xor AX,AX
   push AX
   push AX
   mov AX,4302
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   add AX,0010
   push AX
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,4307
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   add AX,0010
   push AX
   xor AX,AX
   push AX
   mov AX,4305
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   xor SI,SI
jmp near L0a820488
L0a820415:
   les BX,[BP+06]
   mov AX,[ES:BX+12]
   cmp AX,SI
   jz L0a820425
   mov AX,0001
jmp near L0a820427
L0a820425:
   xor AX,AX
L0a820427:
   push AX
   or SI,SI
   jnz L0a820431
   mov AX,0001
jmp near L0a820433
L0a820431:
   xor AX,AX
L0a820433:
   pop DX
   or DX,AX
   jz L0a820487
   xor AX,AX
   push AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   add AX,0008
   push AX
   mov AX,4304
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   add AX,0010
   push AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   add AX,0008
   push AX
   mov AX,4306
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
L0a820487:
   inc SI
L0a820488:
   les BX,[BP+06]
   mov AX,[ES:BX+0A]
   cmp AX,SI
   jle L0a820496
jmp near L0a820415
L0a820496:
   xor AX,AX
   push AX
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,4303
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   xor SI,SI
jmp near L0a82051a
L0a8204bb:
   mov AX,SI
   mov CL,04
   shl AX,CL
   add AX,0010
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,4301
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   or SI,SI
   jz L0a8204f5
   les BX,[BP+06]
   mov AX,[ES:BX+16]
   cmp AX,SI
   jz L0a820519
L0a8204f5:
   mov AX,SI
   mov CL,04
   shl AX,CL
   add AX,0010
   push AX
   xor AX,AX
   push AX
   mov AX,4300
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
L0a820519:
   inc SI
L0a82051a:
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   cmp AX,SI
   jg L0a8204bb
   test word ptr [ES:BX],0001
   jz L0a820577
   mov AX,0020
   push AX
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,430E
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   add AX,FFF0
   push AX
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,430F
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
L0a820577:
   les BX,[BP+06]
   cmp word ptr [ES:BX+12],+00
   jg L0a820584
jmp near L0a8206a4
L0a820584:
   xor AX,AX
   push AX
   mov AX,[ES:BX+10]
   add AX,0008
   push AX
   mov AX,430A
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   xor SI,SI
jmp near L0a8205e4
L0a8205a9:
   or SI,SI
   jz L0a8205b8
   les BX,[BP+06]
   mov AX,[ES:BX+16]
   cmp AX,SI
   jz L0a8205e3
L0a8205b8:
   mov AX,SI
   mov CL,04
   shl AX,CL
   add AX,0010
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+10]
   add AX,0008
   push AX
   mov AX,4309
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
L0a8205e3:
   inc SI
L0a8205e4:
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   cmp AX,SI
   jg L0a8205a9
   mov AX,[ES:BX+0C]
   add AX,0010
   push AX
   mov AX,[ES:BX+10]
   add AX,0008
   push AX
   mov AX,4308
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   les BX,[BP+06]
   cmp word ptr [ES:BX+14],+00
   jg L0a820622
jmp near L0a8206a4
L0a820622:
   mov AX,[ES:BX+14]
   add AX,0010
   push AX
   xor AX,AX
   push AX
   mov AX,430D
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   xor SI,SI
jmp near L0a820673
L0a820647:
   les BX,[BP+06]
   mov AX,[ES:BX+14]
   add AX,0010
   push AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   add AX,0008
   push AX
   mov AX,430C
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   inc SI
L0a820673:
   les BX,[BP+06]
   mov AX,[ES:BX+12]
   cmp AX,SI
   jg L0a820647
   mov AX,[ES:BX+14]
   add AX,0010
   push AX
   mov AX,[ES:BX+10]
   add AX,0008
   push AX
   mov AX,430B
   push AX
   mov DX,[BP+08]
   mov AX,BX
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
L0a8206a4:
   pop DI
   pop SI
   pop BP
ret far

_undrawwin: ;; 0a8206a8
   push BP
   mov BP,SP
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _clearvp
   mov SP,BP
   pop BP
ret far

_wprint: ;; 0a8206bf
   push BP
   mov BP,SP
   push SI
   push DI
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   cmp AX,[offset _curhi]
   jnz L0a8206db
   mov AX,[ES:BX+0E]
   cmp AX,[offset _curback]
   jz L0a8206f2
L0a8206db:
   les BX,[BP+06]
   push [ES:BX+0E]
   push [ES:BX+0C]
   push [BP+08]
   push BX
   call far _fontcolor
   add SP,+08
L0a8206f2:
   mov AX,[BP+0E]
   cmp AX,0001
   jz L0a820701
   cmp AX,0002
   jz L0a820706
jmp near L0a82070b
L0a820701:
   mov SI,0008
jmp near L0a82070d
L0a820706:
   mov SI,0006
jmp near L0a82070d
L0a82070b:
   xor SI,SI
L0a82070d:
   or SI,SI
   jz L0a820756
   xor DI,DI
jmp near L0a820745
L0a820715:
   push [BP+0C]
   mov AX,SI
   mul DI
   add AX,[BP+0A]
   push AX
   mov AX,[BP+0E]
   mov CL,08
   shl AX,CL
   les BX,[BP+10]
   push AX
   mov AL,[ES:BX+DI]
   cbw
   and AX,007F
   pop DX
   add DX,AX
   push DX
   push [BP+08]
   push [BP+06]
   call far _drawshape
   add SP,+0A
   inc DI
L0a820745:
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   cmp AX,DI
   ja L0a820715
L0a820756:
   pop DI
   pop SI
   pop BP
ret far

_wgetkey: ;; 0a82075a
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   mov byte ptr [BP-01],00
jmp near L0a8207a4
L0a820767:
   les BX,[offset _myclock]
   mov SI,[ES:BX]
L0a82076e:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   cmp AX,SI
   jz L0a82076e
   mov AL,[offset _cursorchar]
   and AL,07
   inc AL
   mov [offset _cursorchar],AL
   mov AL,[offset _cursorchar]
   mov [BP-02],AL
   push SS
   lea AX,[BP-02]
   push AX
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wprint
   add SP,+0E
L0a8207a4:
   call far _k_pressed
   or AX,AX
   jz L0a820767
   push DS
   mov AX,offset Y2a1704be
   push AX
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wprint
   add SP,+0E
   call far _k_read
   pop SI
   mov SP,BP
   pop BP
ret far

_winput: ;; 0a8207d2
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov SI,0001
   mov AX,[BP+0E]
   cmp AX,SI
   jz L0a8207eb
   cmp AX,0002
   jz L0a8207f0
jmp near L0a8207f5
L0a8207eb:
   mov DI,0008
jmp near L0a8207f7
L0a8207f0:
   mov DI,0006
jmp near L0a8207f7
L0a8207f5:
   xor DI,DI
L0a8207f7:
   push [BP+12]
   push [BP+10]
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wprint
   add SP,+0E
   mov byte ptr [BP-01],00
L0a820817:
   push [BP+0E]
   push [BP+0C]
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   mul DI
   add AX,[BP+0A]
   push AX
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wgetkey
   add SP,+0A
   mov [BP-06],AX
   cmp AX,0020
   jge L0a820848
jmp near L0a8208f8
L0a820848:
   cmp AX,0080
   jl L0a820850
jmp near L0a8208f8
L0a820850:
   or SI,SI
   jz L0a820893
   xor SI,SI
jmp near L0a820860
L0a820858:
   les BX,[BP+10]
   mov byte ptr [ES:BX+SI],20
   inc SI
L0a820860:
   les BX,[BP+10]
   cmp byte ptr [ES:BX+SI],00
   jnz L0a820858
   mov byte ptr [ES:BX+SI],20
   inc SI
   mov byte ptr [ES:BX+SI],00
   push [BP+12]
   push BX
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wprint
   add SP,+0E
   les BX,[BP+10]
   mov byte ptr [ES:BX],00
L0a820893:
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   cmp AX,[BP+14]
   jb L0a8208a8
jmp near L0a82092d
L0a8208a8:
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   mov [BP-04],AX
   mov AL,[BP-06]
   les BX,[BP+10]
   add BX,[BP-04]
   mov [ES:BX],AL
   mov BX,[BP+10]
   add BX,[BP-04]
   mov byte ptr [ES:BX+01],00
   mov AL,[BP-06]
   mov [BP-02],AL
   push SS
   lea AX,[BP-02]
   push AX
   push [BP+0E]
   push [BP+0C]
   mov AX,DI
   mul word ptr [BP-04]
   add AX,[BP+0A]
   push AX
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wprint
   add SP,+0E
jmp near L0a82092d
L0a8208f8:
   cmp word ptr [BP-06],+08
   jz L0a820905
   cmp word ptr [BP-06],00CB
   jnz L0a82092d
L0a820905:
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   or AX,AX
   jbe L0a82092d
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   dec AX
   les BX,[BP+10]
   add BX,AX
   mov byte ptr [ES:BX],00
L0a82092d:
   xor SI,SI
   cmp word ptr [BP-06],+0D
   jz L0a82093e
   cmp word ptr [BP-06],+1B
   jz L0a82093e
jmp near L0a820817
L0a82093e:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_wprintc: ;; 0a820944 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push SI
   mov AX,[BP+0C]
   cmp AX,0001
   jz L0a820957
   cmp AX,0002
   jz L0a82095c
jmp near L0a820961
L0a820957:
   mov SI,0008
jmp near L0a820963
L0a82095c:
   mov SI,0006
jmp near L0a820963
L0a820961:
   xor SI,SI
L0a820963:
   push [BP+10]
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+10]
   push [BP+0E]
   call far _strlen
   pop CX
   pop CX
   mul SI
   shr AX,1
   les BX,[BP+06]
   mov DX,[ES:BX+04]
   sub DX,AX
   push DX
   push [BP+08]
   push BX
   push CS
   call near offset _wprint
   add SP,+0E
   pop SI
   pop BP
ret far

_titlewin: ;; 0a820998
   push BP
   mov BP,SP
   push [BP+0C]
   push [BP+0A]
   mov AX,0001
   push AX
   mov AX,0004
   push AX
   push [BP+0C]
   push [BP+0A]
   call far _strlen
   pop CX
   pop CX
   shl AX,1
   shl AX,1
   les BX,[BP+06]
   push AX
   mov AX,[ES:BX+08]
   add AX,[ES:BX+10]
   mov BX,0002
   cwd
   idiv BX
   add AX,0010
   pop DX
   sub AX,DX
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   push CS
   call near offset _wprint
   mov SP,BP
   pop BP
ret far

_titletop: ;; 0a8209e6
   push BP
   mov BP,SP
   push [BP+0C]
   push [BP+0A]
   mov AX,0002
   push AX
   mov AX,0005
   push AX
   push [BP+0C]
   push [BP+0A]
   call far _strlen
   pop CX
   pop CX
   mov DX,0003
   mul DX
   les BX,[BP+06]
   push AX
   mov AX,[ES:BX+10]
   mov BX,0002
   cwd
   idiv BX
   add AX,0008
   pop DX
   sub AX,DX
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   push CS
   call near offset _wprint
   mov SP,BP
   pop BP
ret far

_titlebot: ;; 0a820a31
   push BP
   mov BP,SP
   push [BP+0C]
   push [BP+0A]
   mov AX,0002
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   add AX,0013
   push AX
   push [BP+0C]
   push [BP+0A]
   call far _strlen
   pop CX
   pop CX
   mov DX,0003
   mul DX
   les BX,[BP+06]
   push AX
   mov AX,[ES:BX+10]
   mov BX,0002
   cwd
   idiv BX
   add AX,0008
   pop DX
   sub AX,DX
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   push CS
   call near offset _wprint
   mov SP,BP
   pop BP
ret far

_initvp: ;; 0a820a83
   push BP
   mov BP,SP
   les BX,[BP+06]
   mov word ptr [ES:BX+08],0000
   mov word ptr [ES:BX+0A],0000
   mov word ptr [ES:BX+0C],0001
   mov AX,[BP+0A]
   mov [ES:BX+0E],AX
   pop BP
ret far

_clearvp: ;; 0a820aa4
   push BP
   mov BP,SP
   les BX,[BP+06]
   mov AL,[ES:BX+0E]
   push AX
   push [BP+08]
   push BX
   call far _clrvp
   mov SP,BP
   pop BP
ret far

_fontcolor: ;; 0a820abc
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov DI,[BP+0C]
   mov SI,[BP+0A]
   mov AX,SI
   cwd
   xor AX,DX
   sub AX,DX
   neg AX
   mov SI,AX
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jz L0a820ae9
   cmp AX,0004
   jz L0a820b21
jmp near L0a820b4b
L0a820ae9:
   or SI,SI
   jl L0a820b01
   mov AX,SI
   and AX,0007
   add AX,0008
   mov SI,AX
   mov AX,SI
   and AX,0007
   mov [BP-02],AX
jmp near L0a820b13
L0a820b01:
   mov AX,SI
   cwd
   xor AX,DX
   sub AX,DX
   and AX,0007
   add AX,0008
   mov SI,AX
   mov [BP-02],SI
L0a820b13:
   cmp DI,-01
   jz L0a820b4b
   mov AX,DI
   and AX,000F
   mov DI,AX
jmp near L0a820b4b
L0a820b21:
   or SI,SI
   jl L0a820b39
   mov AX,SI
   and AX,0007
   add AX,0008
   mov SI,AX
   mov AX,SI
   and AX,0007
   mov [BP-02],AX
jmp near L0a820b4b
L0a820b39:
   mov AX,SI
   cwd
   xor AX,DX
   sub AX,DX
   and AX,0007
   add AX,0008
   mov SI,AX
   mov [BP-02],SI
L0a820b4b:
   push DI
   push [BP-02]
   push SI
   call far _fntcolor
   add SP,+06
   les BX,[BP+06]
   mov [ES:BX+0C],SI
   mov [ES:BX+0E],DI
   mov [offset _curhi],SI
   mov [offset _curback],DI
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 0b39 ;; GAMECTRL.C:GAMECTRL
_buttona1: ;; 0b390001
   mov DX,0201
   in AL,DX
   test AL,10
   jnz L0b39000e
   mov AX,0001
jmp near L0b390010
L0b39000e:
   xor AX,AX
L0b390010:
ret far

_buttona2: ;; 0b390011
   mov DX,0201
   in AL,DX
   test AL,20
   jnz L0b39001e
   mov AX,0001
jmp near L0b390020
L0b39001e:
   xor AX,AX
L0b390020:
ret far

_readspeed: ;; 0b390021
   push SI
   mov word ptr [offset _systime+02],0000
   mov word ptr [offset _systime],0000
   les BX,[offset _myclock]
   mov AL,[ES:BX]
   cbw
   mov SI,AX
L0b390038:
   les BX,[offset _myclock]
   mov AL,[ES:BX]
   cbw
   cmp AX,SI
   jz L0b390038
L0b390044:
   add word ptr [offset _systime],+01
   adc word ptr [offset _systime+02],+00
   les BX,[offset _myclock]
   mov AL,[ES:BX]
   cbw
   sub AX,SI
   cmp AX,0005
   jl L0b390044
   xor DX,DX
   mov AX,0004
   push DX
   push AX
   push [offset _systime+02]
   push [offset _systime]
   call far LDIV@
   mov [offset _systime+02],DX
   mov [offset _systime],AX
   pop SI
ret far

_readjoy: ;; 0b39007a
   push BP
   mov BP,SP
   push SI
   cli
   les BX,[BP+06]
   mov word ptr [ES:BX],0000
   les BX,[BP+0A]
   mov word ptr [ES:BX],0000
   xor SI,SI
   mov AL,00
   mov DX,0201
   out DX,AL
L0b390097:
   mov DX,0201
   in AL,DX
   mov AH,00
   and AX,0001
   les BX,[BP+06]
   add [ES:BX],AX
   in AL,DX
   mov AH,00
   and AX,0002
   les BX,[BP+0A]
   add [ES:BX],AX
   inc SI
   in AL,DX
   test AL,03
   jnz L0b3900bd
   mov AX,0001
jmp near L0b3900bf
L0b3900bd:
   xor AX,AX
L0b3900bf:
   push AX
   or SI,SI
   jge L0b3900c9
   mov AX,0001

X0b3900c5:
   add [BX+SI],AX
jmp near L0b3900cb
L0b3900c9:
   xor AX,AX
L0b3900cb:
   pop DX
   or DX,AX
   jz L0b390097
   sti
   les BX,[BP+0A]
   mov AX,[ES:BX]
   mov BX,0002
   cwd
   idiv BX
   mov BX,[BP+0A]
   mov [ES:BX],AX
   or SI,SI
   jge L0b3900f7
   les BX,[BP+06]
   mov word ptr [ES:BX],FFFF
   les BX,[BP+0A]
   mov word ptr [ES:BX],FFFF
L0b3900f7:
   pop SI
   pop BP
ret far

_caldir: ;; 0b3900fa
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   mov SI,DI
   push [BP+08]
   push [BP+06]
   call far _cputs
   pop CX
   pop CX
L0b390110:
   push [BP+10]
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push CS
   call near offset _readjoy
   add SP,+08
   call far _k_pressed
   or AX,AX
   jz L0b390133
   call far _k_read
   mov SI,AX
L0b390133:
   cmp SI,+1B
   jz L0b390140
   push CS
   call near offset _buttona1
   or AX,AX
   jz L0b390110
L0b390140:
   mov AX,0019
   push AX
   call far _delay
   pop CX
   cmp SI,+1B
   jz L0b39016f
   mov DI,0001
L0b390152:
   call far _k_pressed
   or AX,AX
   jz L0b390162
   call far _k_read
   mov SI,AX
L0b390162:
   push CS
   call near offset _buttona1
   or AX,AX
   jz L0b39016f
   cmp SI,+1B
   jnz L0b390152
L0b39016f:
   mov AX,0019
   push AX
   call far _delay
   pop CX
   push DS
   mov AX,offset Y2a1704d4
   push AX
   call far _cputs
   pop CX
   pop CX
   mov AX,DI
   pop DI
   pop SI
   pop BP
ret far

_joypresent: ;; 0b39018b
   push BP
   mov BP,SP
   sub SP,+04
   push SS
   lea AX,[BP-02]
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push CS
   call near offset _readjoy
   add SP,+08
   cmp word ptr [BP-04],+00
   jle L0b3901bf
   cmp word ptr [BP-02],+00
   jle L0b3901bf
   mov AX,[BP-04]
   mov [offset _joyxsense],AX
   mov AX,[BP-02]
   mov [offset _joyysense],AX
   mov AX,0001
jmp near L0b3901c1
L0b3901bf:
   xor AX,AX
L0b3901c1:
   mov SP,BP
   pop BP
ret far

_calibratejoy: ;; 0b3901c5
   push SI
L0b3901c6:
   mov word ptr [offset _joyflag],0000
   push DS
   mov AX,offset Y2a1704d7
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset _joyyc
   push AX
   push DS
   mov AX,offset _joyxc
   push AX
   push DS
   mov AX,offset Y2a170509
   push AX
   push CS
   call near offset _caldir
   add SP,+0C
   or AX,AX
   jnz L0b3901f5
jmp near L0b39029a
L0b3901f5:
   push DS
   mov AX,offset _joyyu
   push AX
   push DS
   mov AX,offset _joyxl
   push AX
   push DS
   mov AX,offset Y2a17052e
   push AX
   push CS
   call near offset _caldir
   add SP,+0C
   or AX,AX
   jnz L0b390212
jmp near L0b39029a
L0b390212:
   push DS
   mov AX,offset _joyyd
   push AX
   push DS
   mov AX,offset _joyxr
   push AX
   push DS
   mov AX,offset Y2a170566
   push AX
   push CS
   call near offset _caldir
   add SP,+0C
   or AX,AX
   jz L0b39029a
   mov AX,[offset _joyxc]
   sub [offset _joyxl],AX
   sub [offset _joyxr],AX
   mov AX,[offset _joyyc]
   sub [offset _joyyu],AX
   sub [offset _joyyd],AX
   cmp word ptr [offset _joyxl],-01
   jge L0b390263
   cmp word ptr [offset _joyxr],+01
   jle L0b390263
   cmp word ptr [offset _joyyu],-01
   jge L0b390263
   cmp word ptr [offset _joyyd],+01
   jle L0b390263
   mov AX,0001
jmp near L0b39029c
L0b390263:
   push DS
   mov AX,offset Y2a17059f
   push AX
   call far _cputs
   pop CX
   pop CX
L0b39026f:
   call far _k_pressed
   or AX,AX
   jz L0b39026f
   push DS
   mov AX,offset Y2a1705c8
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _k_read
   mov SI,AX
   push SI
   call far _toupper
   pop CX
   cmp AX,0059
   jnz L0b39029a
jmp near L0b3901c6
L0b39029a:
   xor AX,AX
L0b39029c:
   pop SI
ret far

_checkctrl: ;; 0b39029e
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov SI,[BP+06]
   cmp word ptr [offset _macplay],+00
   jz L0b3902b8
   call far _getmac
jmp near L0b390511
L0b3902b8:
   mov word ptr [offset _dx1],0000
   mov word ptr [offset _dy1],0000
   mov word ptr [offset _fire1],0000
   mov word ptr [offset _flow1],0000
L0b3902d0:
   mov word ptr [offset _key],0000
   call far _k_pressed
   or AX,AX
   jz L0b390320
   call far _k_read
   mov [offset _key],AX
   or AX,AX
   jnz L0b3902f0
   mov AX,0001
jmp near L0b3902f2
L0b3902f0:
   xor AX,AX
L0b3902f2:
   push AX
   cmp word ptr [offset _key],+01
   jnz L0b3902ff
   mov AX,0001
jmp near L0b390301
L0b3902ff:
   xor AX,AX
L0b390301:
   pop DX
   or DX,AX
   push DX
   cmp word ptr [offset _key],+02
   jnz L0b390311
   mov AX,0001
jmp near L0b390313
L0b390311:
   xor AX,AX
L0b390313:
   pop DX
   or DX,AX
   jz L0b390320
   call far _k_read
   mov [offset _key],AX
L0b390320:
   cmp word ptr [offset _key],+00
   jnz L0b39032a
jmp near L0b3903ae
L0b39032a:
   mov AX,[offset _key]
   mov CX,0008
   mov BX,offset Y0b390342
L0b390333:
   cmp AX,[CS:BX]
   jz L0b39033e
   inc BX
   inc BX
   loop L0b390333
jmp near L0b3903ae
L0b39033e:
jmp near [CS:BX+10]
Y0b390342:	dw 0032,0034,0036,0038,00c8,00cb,00cd,00d0
		dw L0b39039b,L0b390377,L0b390386,L0b390362,L0b390362,L0b390377,L0b390386,L0b39039b
L0b390362:
   or SI,SI
   jz L0b390369
jmp near L0b3902d0
L0b390369:
   mov word ptr [offset _dx1],0000
   mov word ptr [offset _dy1],FFFF
jmp near L0b3903ae
L0b390377:
   or SI,SI
   jz L0b39037e
jmp near L0b3902d0
L0b39037e:
   mov word ptr [offset _dx1],FFFF
jmp near L0b390393
L0b390386:
   or SI,SI
   jz L0b39038d
jmp near L0b3902d0
L0b39038d:
   mov word ptr [offset _dx1],0001
L0b390393:
   mov word ptr [offset _dy1],0000
jmp near L0b3903ae
L0b39039b:
   or SI,SI
   jz L0b3903a2
jmp near L0b3902d0
L0b3903a2:
   mov word ptr [offset _dx1],0000
   mov word ptr [offset _dy1],0001
L0b3903ae:
   call far _k_status
   mov AL,[offset _k_shift]
   cbw
   mov [offset _fire1],AX
   mov AL,[offset _k_alt]
   cbw
   mov [offset _fire2],AX
   cmp word ptr [offset _dx1],+00
   jz L0b3903cb
jmp near L0b390473
L0b3903cb:
   cmp word ptr [offset _dy1],+00
   jz L0b3903d5
jmp near L0b390473
L0b3903d5:
   cmp word ptr [offset _joyflag],+00
   jnz L0b3903df
jmp near L0b390473
L0b3903df:
   push SS
   lea AX,[BP-04]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   push CS
   call near offset _readjoy
   add SP,+08
   mov DI,[BP-06]
   sub DI,[offset _joyxc]
   mov AX,[BP-04]
   sub AX,[offset _joyyc]
   mov [BP-02],AX
   mov AX,DI
   shl AX,1
   cmp AX,[offset _joyxr]
   jle L0b390410
   mov AX,0001
jmp near L0b390412
L0b390410:
   xor AX,AX
L0b390412:
   push AX
   mov AX,DI
   shl AX,1
   cmp AX,[offset _joyxl]
   jge L0b390422
   mov AX,0001
jmp near L0b390424
L0b390422:
   xor AX,AX
L0b390424:
   pop DX
   sub DX,AX
   mov [offset _dx1],DX
   mov AX,[BP-02]
   shl AX,1
   cmp AX,[offset _joyyd]
   jle L0b39043b
   mov AX,0001
jmp near L0b39043d
L0b39043b:
   xor AX,AX
L0b39043d:
   push AX
   mov AX,[BP-02]
   shl AX,1
   cmp AX,[offset _joyyu]
   jge L0b39044e
   mov AX,0001
jmp near L0b390450
L0b39044e:
   xor AX,AX
L0b390450:
   pop DX
   sub DX,AX
   mov [offset _dy1],DX
   push CS
   call near offset _buttona1
   or AX,AX
   jz L0b390465
   mov word ptr [offset _fire1],0001
L0b390465:
   push CS
   call near offset _buttona2
   or AX,AX
   jz L0b390473
   mov word ptr [offset _fire2],0001
L0b390473:
   cmp word ptr [offset _dx1],+00
   jnz L0b3904cd
   cmp word ptr [offset _dy1],+00
   jnz L0b3904cd
   or SI,SI
   jz L0b3904cd
   cmp byte ptr [offset _keydown+0*0100+004b],00
   jnz L0b390493
   cmp byte ptr [offset _keydown+1*0100+004b],00
   jz L0b390497
L0b390493:
   dec word ptr [offset _dx1]
L0b390497:
   cmp byte ptr [offset _keydown+0*0100+004d],00
   jnz L0b3904a5
   cmp byte ptr [offset _keydown+1*0100+004d],00
   jz L0b3904a9
L0b3904a5:
   inc word ptr [offset _dx1]
L0b3904a9:
   cmp byte ptr [offset _keydown+0*0100+0048],00
   jnz L0b3904b7
   cmp byte ptr [offset _keydown+1*0100+0048],00
   jz L0b3904bb
L0b3904b7:
   dec word ptr [offset _dy1]
L0b3904bb:
   cmp byte ptr [offset _keydown+0*0100+0050],00
   jnz L0b3904c9
   cmp byte ptr [offset _keydown+1*0100+0050],00
   jz L0b3904cd
L0b3904c9:
   inc word ptr [offset _dy1]
L0b3904cd:
   cmp word ptr [offset _fire1],+00
   jz L0b3904dd
   mov AX,[offset _fire1off]
   xor [offset _fire1],AX
jmp near L0b3904e3
L0b3904dd:
   mov word ptr [offset _fire1off],0000
L0b3904e3:
   cmp word ptr [offset _fire2],+00
   jz L0b3904f3
   mov AX,[offset _fire2off]
   xor [offset _fire2],AX
jmp near L0b3904f9
L0b3904f3:
   mov word ptr [offset _fire2off],0000
L0b3904f9:
   mov AX,[offset _dx1]
   mov [offset _dx1old],AX
   mov AX,[offset _dy1]
   mov [offset _dy1old],AX
   cmp word ptr [offset _macrecord],+00
   jz L0b390511
   call far _recmac
L0b390511:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_checkctrl0: ;; 0b390517
   push BP
   mov BP,SP
L0b39051a:
   les BX,[offset _myclock]
   mov AL,[ES:BX]
   cbw
   cmp AX,[offset Y2a1704c8]
   jz L0b39051a
   mov AL,[ES:BX]
   cbw
   mov [offset Y2a1704c8],AX
   push [BP+06]
   push CS
   call near offset _checkctrl
   pop CX
   pop BP
ret far

_sensectrlmode: ;; 0b390539 ;; (@) Unaccessed.
   push CS
   call near offset _joypresent
   mov [offset _joyflag],AX
ret far

_gc_config: ;; 0b390541
   push SI
   mov SI,0020
   push CS
   call near offset _joypresent
   or AX,AX
   jz L0b3905a1
   push DS
   mov AX,offset Y2a1705cb
   push AX
   call far _cputs
   pop CX
   pop CX
L0b390559:
   call far _k_pressed
   or AX,AX
   jz L0b390559
   call far _k_read
   push AX
   call far _toupper
   pop CX
   mov SI,AX
   cmp SI,+4B
   jz L0b39057f
   cmp SI,+4A
   jz L0b39057f
   cmp SI,+1B
   jnz L0b390559
L0b39057f:
   push DS
   mov AX,offset Y2a1705f8
   push AX
   call far _cputs
   pop CX
   pop CX
   mov word ptr [offset _joyflag],0000
   mov AX,SI
   cmp AX,004A
   jz L0b39059a
jmp near L0b3905a1
L0b39059a:
   push CS
   call near offset _calibratejoy
   mov [offset _joyflag],AX
L0b3905a1:
   cmp SI,+1B
   jz L0b3905ab
   mov AX,0001
jmp near L0b3905ad
L0b3905ab:
   xor AX,AX
L0b3905ad:
   pop SI
ret far

_getkey: ;; 0b3905af
L0b3905af:
   xor AX,AX
   push AX
   push CS
   call near offset _checkctrl
   pop CX
   cmp word ptr [offset _key],+00
   jz L0b3905af
ret far

_stopmac: ;; 0b3905bf
   mov word ptr [offset _macplay],0000
   mov word ptr [offset _macrecord],0000
   mov AX,[offset _macptr]
   or AX,[offset _macptr+02]
   jz L0b3905ef
   push [offset _macptr+02]
   push [offset _macptr]
   call far _free
   pop CX
   pop CX
   mov word ptr [offset _macptr+02],0000
   mov word ptr [offset _macptr],0000
L0b3905ef:
   mov word ptr [offset _macofs],0000
   mov word ptr [offset _mactime],0001
   mov AX,3039
   push AX
   call far _srand
   pop CX
ret far

_playmac: ;; 0b390606
   push BP
   mov BP,SP
   push SI
   push CS
   call near offset _stopmac
   mov word ptr [offset _macaborted],0000
   mov AX,8000
   push AX
   push [BP+08]
   push [BP+06]
   call far __open
   add SP,+06
   mov SI,AX
   or SI,SI
   jl L0b39068e
   push SI
   call far _filelength
   pop CX
   mov [offset _maclen],AX
   push AX
   call far _malloc
   pop CX
   mov [offset _macptr+02],DX
   mov [offset _macptr],AX
   or AX,DX
   jz L0b39067b
   push [offset _maclen]
   push DX
   push [offset _macptr]
   push SI
   call far __read
   add SP,+08
   or AX,AX
   jl L0b39066c
   mov word ptr [offset _macplay],0001
   mov word ptr [offset _gamecount],0000
jmp near L0b390687
L0b39066c:
   push [offset _macptr+02]
   push [offset _macptr]
   call far _free
   pop CX
   pop CX
L0b39067b:
   mov word ptr [offset _macptr+02],0000
   mov word ptr [offset _macptr],0000
L0b390687:
   push SI
   call far __close
   pop CX
L0b39068e:
   pop SI
   pop BP
ret far

_recordmac: ;; 0b390691
   push BP
   mov BP,SP
   push CS
   call near offset _stopmac
   mov AX,1F40
   push AX
   call far _malloc
   pop CX
   mov [offset _macptr+02],DX
   mov [offset _macptr],AX
   or AX,DX
   jz L0b3906d1
   mov word ptr [offset _macofs],0000
   mov word ptr [offset _macrecord],0001
   push [BP+08]
   push [BP+06]
   push DS
   mov AX,offset _macfname
   push AX
   call far _strcpy
   mov SP,BP
   mov word ptr [offset _gamecount],0000
L0b3906d1:
   pop BP
ret far

_macrecend: ;; 0b3906d3
   push SI
   cmp word ptr [offset _macrecord],+00
   jz L0b390711
   xor AX,AX
   push AX
   push DS
   mov AX,offset _macfname
   push AX
   call far __creat
   add SP,+06
   mov SI,AX
   or SI,SI
   jl L0b39070d
   push [offset _macofs]
   push [offset _macptr+02]
   push [offset _macptr]
   push SI
   call far __write
   add SP,+08
   push SI
   call far __close
   pop CX
L0b39070d:
   push CS
   call near offset _stopmac
L0b390711:
   pop SI
ret far

_recmac: ;; 0b390713
   push BP
   mov BP,SP
   sub SP,+04
   cmp word ptr [offset _key],+5B
   jnz L0b39072c
   mov word ptr [offset _mactime],0000
   mov word ptr [offset _key],0000
L0b39072c:
   cmp word ptr [offset _key],+5D
   jnz L0b39073f
   mov word ptr [offset _mactime],0001
   mov word ptr [offset _key],0000
L0b39073f:
   cmp word ptr [offset _key],+7D
   jnz L0b390749
jmp near L0b390911
L0b390749:
   cmp word ptr [offset _macofs],+00
   jnz L0b39076e
   mov word ptr [offset Y2a1704ca],0000
   mov word ptr [offset Y2a1704cc],0000
   mov word ptr [offset Y2a1704ce],0000
   mov word ptr [offset Y2a1704d0],0000
   mov AX,[offset _gamecount]
   mov [offset Y2a1704d2],AX
L0b39076e:
   mov AX,[offset Y2a1704ca]
   cmp AX,[offset _dx1]
   jz L0b39077c
   mov AX,0001
jmp near L0b39077e
L0b39077c:
   xor AX,AX
L0b39077e:
   push AX
   mov AX,[offset Y2a1704cc]
   cmp AX,[offset _dy1]
   jz L0b39078d
   mov AX,0001
jmp near L0b39078f
L0b39078d:
   xor AX,AX
L0b39078f:
   shl AL,1
   pop DX
   or DL,AL
   push DX
   mov AX,[offset Y2a1704ce]
   cmp AX,[offset _fire1]
   jz L0b3907a3
   mov AX,0001
jmp near L0b3907a5
L0b3907a3:
   xor AX,AX
L0b3907a5:
   shl AL,1
   shl AL,1
   pop DX
   or DL,AL
   push DX
   mov AX,[offset Y2a1704d0]
   cmp AX,[offset _fire2]
   jz L0b3907bb
   mov AX,0001
jmp near L0b3907bd
L0b3907bb:
   xor AX,AX
L0b3907bd:
   shl AL,1
   shl AL,1
   shl AL,1
   pop DX
   or DL,AL
   push DX
   cmp word ptr [offset _key],+00
   jle L0b3907da
   cmp word ptr [offset _key],+7F
   jg L0b3907da
   mov AX,0001
jmp near L0b3907dc
L0b3907da:
   xor AX,AX
L0b3907dc:
   mov CL,04
   shl AL,CL
   pop DX
   or DL,AL
   mov [BP-01],DL
   cmp byte ptr [BP-01],00
   jnz L0b3907ef
jmp near L0b390909
L0b3907ef:
   cmp word ptr [offset _macofs],+00
   jz L0b39085b
   cmp word ptr [offset _mactime],+00
   jnz L0b390804
   mov word ptr [BP-04],0001
jmp near L0b39080e
L0b390804:
   mov AX,[offset _gamecount]
   sub AX,[offset Y2a1704d2]
   mov [BP-04],AX
L0b39080e:
   cmp word ptr [BP-04],0080
   jge L0b39082b
   mov AL,[BP-04]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
jmp near L0b39085b
L0b39082b:
   mov AL,[BP-04]
   and AL,7F
   or AL,80
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
   mov AX,[BP-04]
   mov CL,07
   sar AX,CL
   mov DX,[offset _macofs]
   mov BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b39085b:
   mov AL,[BP-01]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
   test byte ptr [BP-01],01
   jz L0b390889
   mov AL,[offset _dx1]
   mov DX,[offset _macofs]
   mov BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b390889:
   test byte ptr [BP-01],02
   jz L0b3908a3
   mov AL,[offset _dy1]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b3908a3:
   test byte ptr [BP-01],04
   jz L0b3908bd
   mov AL,[offset _fire1]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b3908bd:
   test byte ptr [BP-01],08
   jz L0b3908d7
   mov AL,[offset _fire2]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b3908d7:
   test byte ptr [BP-01],10
   jz L0b3908f1
   mov AL,[offset _key]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b3908f1:
   mov AX,[offset _dx1]
   mov [offset Y2a1704ca],AX
   mov AX,[offset _dy1]
   mov [offset Y2a1704cc],AX
   mov AX,[offset _fire1]
   mov [offset Y2a1704ce],AX
   mov AX,[offset _fire2]
   mov [offset Y2a1704d0],AX
L0b390909:
   cmp word ptr [offset _macofs],7530
   jb L0b390915
L0b390911:
   push CS
   call near offset _macrecend
L0b390915:
   mov SP,BP
   pop BP
ret far

_getmac: ;; 0b390919
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   call far _k_pressed
   or AX,AX
   jz L0b39094d
   call far _k_read
   mov SI,AX
   cmp word ptr [offset _macabort],+00
   jz L0b390943
   cmp word ptr [offset _macabort],+01
   jnz L0b39094d
   cmp SI,+1B
   jnz L0b39094d
L0b390943:
   push CS
   call near offset _stopmac
   mov word ptr [offset _macaborted],0001
L0b39094d:
   mov word ptr [offset _key],0000
   cmp word ptr [offset _macofs],+00
   jnz L0b39097e
   mov word ptr [offset _dx1],0000
   mov word ptr [offset _dy1],0000
   mov word ptr [offset _fire1],0000
   mov word ptr [offset _fire2],0000
   mov AX,[offset _gamecount]
   mov [offset Y2a173d76],AX
   mov word ptr [offset Y2a173d78],0000
L0b39097e:
   mov AX,[offset _gamecount]
   sub AX,[offset Y2a173d76]
   cmp AX,[offset Y2a173d78]
   jge L0b39098e
jmp near L0b390a5d
L0b39098e:
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   mov [BP-01],AL
   inc word ptr [offset _macofs]
   test byte ptr [BP-01],01
   jz L0b3909bb
   mov AX,[offset _macofs]
   mov BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _dx1],AX
   inc word ptr [offset _macofs]
L0b3909bb:
   test byte ptr [BP-01],02
   jz L0b3909d5
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _dy1],AX
   inc word ptr [offset _macofs]
L0b3909d5:
   test byte ptr [BP-01],04
   jz L0b3909ef
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _fire1],AX
   inc word ptr [offset _macofs]
L0b3909ef:
   test byte ptr [BP-01],08
   jz L0b390a09
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _fire2],AX
   inc word ptr [offset _macofs]
L0b390a09:
   test byte ptr [BP-01],10
   jz L0b390a23
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _key],AX
   inc word ptr [offset _macofs]
L0b390a23:
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset Y2a173d78],AX
   inc word ptr [offset _macofs]
   or AX,AX
   jge L0b390a5d
   mov AX,[offset _macofs]
   mov BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov CL,07
   shl AX,CL
   mov DX,[offset Y2a173d78]
   and DX,007F
   add AX,DX
   mov [offset Y2a173d78],AX
   inc word ptr [offset _macofs]
L0b390a5d:
   mov AX,[offset _macofs]
   cmp AX,[offset _maclen]
   jb L0b390a6a
   push CS
   call near offset _stopmac
L0b390a6a:
   pop SI
   mov SP,BP
   pop BP
ret far

_gc_init: ;; 0b390a6f
   mov word ptr [offset _dx1],0000
   mov word ptr [offset _dy1],0000
   mov word ptr [offset _fire1],0000
   mov word ptr [offset _fire1off],0000
   mov word ptr [offset _dx1old],0000
   mov word ptr [offset _dy1old],0000
   mov word ptr [offset _dx1hold],0000
   mov word ptr [offset _dy1hold],0000
   mov byte ptr [offset _keybuf],00
   mov word ptr [offset _macplay],0000
   mov word ptr [offset _macrecord],0000
   mov word ptr [offset _macabort],0001
   mov word ptr [offset _joyflag],0000
   mov AL,01
   push AX
   call far _installhandler
   pop CX
ret far

_gc_exit: ;; 0b390ac6
   call far _removehandler
ret far

Segment 0be5 ;; UNCRUNCH:UNCRUNCH
_uncrunch: ;; 0be5000c
   push BP
   mov BP,SP
   push DS
   push ES
   push SI
   push DI
   push AX
   push BX
   push CX
   push DX
   lds SI,[BP+06]
   les DI,[BP+0A]
   mov CX,[BP+0E]
   jcxz L0be5007d
   mov DX,DI
   xor AX,AX
   cld
L0be50027:
   lodsb
   cmp AL,20
   jb L0be50031
   stosw
L0be5002d:
   loop L0be50027
jmp near L0be5007d
L0be50031:
   cmp AL,10
   jnb L0be5003c
   and AH,F0
   or AH,AL
jmp near L0be5002d
L0be5003c:
   cmp AL,18
   jz L0be50053
   jnb L0be5005b
   sub AL,10
   add AL,AL
   add AL,AL
   add AL,AL
   add AL,AL
   and AH,8F
   or AH,AL
jmp near L0be5002d
L0be50053:
   add DX,00A0
   mov DI,DX
jmp near L0be5002d
L0be5005b:
   cmp AL,1B
   jb L0be50066
   jnz L0be5002d
   xor AH,80
jmp near L0be5002d
L0be50066:
   cmp AL,19
   mov BX,CX
   lodsb
   mov CL,AL
   mov AL,20
   jz L0be50073
   lodsb
   dec BX
L0be50073:
   xor CH,CH
   inc CX
   repz stosw
   mov CX,BX
   dec CX
   loopnz L0be50027
L0be5007d:
   pop DX
   pop CX
   pop BX
   pop AX
   pop DI
   pop SI
   pop ES
   pop DS
   pop BP
ret far

Segment 0bed ;; CONFIG.C:CONFIG
_cfg_getpath: ;; 0bed0007
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L0bed0075
L0bed000f:
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strupr
   pop CX
   pop CX
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   les BX,[ES:BX]
   cmp byte ptr [ES:BX],2F
   jnz L0bed0074
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   les BX,[ES:BX]
   cmp byte ptr [ES:BX+01],50
   jnz L0bed0074
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   inc AX
   inc AX
   push DX
   push AX
   push DS
   mov AX,offset _path
   push AX
   call far _strcpy
   add SP,+08
L0bed0074:
   inc SI
L0bed0075:
   cmp SI,[BP+06]
   jl L0bed000f
   pop SI
   pop BP
ret far

_cfg_init: ;; 0bed007d
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   call far _clrscr
   push DS
   mov AX,offset Y2a170640
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170661
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a17068c
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset _pgmname
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170690
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1706b2
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset _pgmname
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1706b6
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1706d7
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset _pgmname
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1706db
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _readspeed
   xor SI,SI
jmp near L0bed0236
L0bed0117:
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strupr
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1706f9
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L0bed0180
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   push [offset _systime+02]
   push [offset _systime]
   call far _ltoa
   add SP,+0A
   push SS
   lea AX,[BP-10]
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _getkey
jmp near L0bed0235
L0bed0180:
   push DS
   mov AX,offset Y2a1706ff
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L0bed01b2
   mov word ptr [offset _vocflag],0000
   mov word ptr [offset _musicflag],0000
jmp near L0bed0235
L0bed01b2:
   push DS
   mov AX,offset Y2a170705
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jz L0bed0235
   push DS
   mov AX,offset Y2a170709
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L0bed020c
   mov word ptr [offset _vocflag],0000
   mov word ptr [offset _musicflag],0000
   mov word ptr [offset _nosnd],0001
jmp near L0bed0235
L0bed020c:
   push DS
   mov AX,offset Y2a170710
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L0bed0235
   mov word ptr [offset _cfgdemo],0001
L0bed0235:
   inc SI
L0bed0236:
   cmp SI,[BP+06]
   jge L0bed023e
jmp near L0bed0117
L0bed023e:
   pop SI
   mov SP,BP
   pop BP
ret far

_doconfig: ;; 0bed0243
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   mov SI,[offset _cf]
   or SI,SI
   jz L0bed0255
jmp near L0bed02d4
L0bed0255:
   mov AL,[offset _cf+10]
   mov [offset _x_ourmode],AL
   call far _joypresent
   mov [offset _joyflag],AX
   or AX,AX
   jnz L0bed026f
   mov word ptr [offset _cf+02],0000
jmp near L0bed02ba
L0bed026f:
   cmp word ptr [offset _cf+02],+00
   jz L0bed02ba
   mov AX,[offset _cf+04]
   mov [offset _joyxl],AX
   mov AX,[offset _cf+06]
   mov [offset _joyxc],AX
   mov AX,[offset _cf+08]
   mov [offset _joyxr],AX
   mov AX,[offset _cf+0a]
   mov [offset _joyyu],AX
   mov AX,[offset _cf+0c]
   mov [offset _joyyc],AX
   mov AX,[offset _cf+0e]
   mov [offset _joyyd],AX
   xor AX,AX
   push AX
   call far _checkctrl
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L0bed02b1
   cmp word ptr [offset _dy1],+00
   jz L0bed02b6
L0bed02b1:
   mov AX,0001
jmp near L0bed02b8
L0bed02b6:
   xor AX,AX
L0bed02b8:
   or SI,AX
L0bed02ba:
   cmp word ptr [offset _musicflag],+00
   jnz L0bed02c7
   mov word ptr [offset _cf+12],0000
L0bed02c7:
   cmp word ptr [offset _vocflag],+00
   jnz L0bed02d4
   mov word ptr [offset _cf+14],0000
L0bed02d4:
   or SI,SI
   jz L0bed02db
jmp near L0bed03f6
L0bed02db:
   call far _clrscr
   push DS
   mov AX,offset Y2a170716
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170719
   push AX
   call far _cputs
   pop CX
   pop CX
   cmp word ptr [offset _cf+14],+00
   jz L0bed030d
   push DS
   mov AX,offset Y2a170730
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0bed0319
L0bed030d:
   push DS
   mov AX,offset Y2a17075d
   push AX
   call far _cputs
   pop CX
   pop CX
L0bed0319:
   cmp word ptr [offset _cf+12],+00
   jz L0bed032e
   push DS
   mov AX,offset Y2a17077e
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0bed033a
L0bed032e:
   push DS
   mov AX,offset Y2a1707a9
   push AX
   call far _cputs
   pop CX
   pop CX
L0bed033a:
   cmp word ptr [offset _cf+02],+00
   jz L0bed034f
   push DS
   mov AX,offset Y2a1707c6
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0bed035b
L0bed034f:
   push DS
   mov AX,offset Y2a1707d7
   push AX
   call far _cputs
   pop CX
   pop CX
L0bed035b:
   cmp byte ptr [offset _x_ourmode],00
   jnz L0bed037c
   push DS
   mov AX,offset Y2a1707e9
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170811
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0bed039d
L0bed037c:
   cmp byte ptr [offset _x_ourmode],02
   jnz L0bed0391
   push DS
   mov AX,offset Y2a170833
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0bed039d
L0bed0391:
   push DS
   mov AX,offset Y2a17084f
   push AX
   call far _cputs
   pop CX
   pop CX
L0bed039d:
   push DS
   mov AX,offset Y2a17086c
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a17086f
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170892
   push AX
   call far _cputs
   pop CX
   pop CX
L0bed03c1:
   call far _getkey
   push [offset _key]
   call far _toupper
   pop CX
   mov [offset _key],AX
   cmp AX,000D
   jz L0bed03e2
   cmp AX,0043
   jz L0bed03e2
   cmp AX,001B
   jnz L0bed03c1
L0bed03e2:
   cmp word ptr [offset _key],+43
   jnz L0bed03ec
   mov SI,0001
L0bed03ec:
   cmp word ptr [offset _key],+1B
   jnz L0bed03f6
jmp near L0bed0662
L0bed03f6:
   or SI,SI
   jnz L0bed03fd
jmp near L0bed0666
L0bed03fd:
   call far _clrscr
   cmp word ptr [offset _vocflag],+00
   jnz L0bed0445
   cmp word ptr [offset _musicflag],+00
   jnz L0bed0445
   push DS
   mov AX,offset Y2a1708b4
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1708b7
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1708ea
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1708f9
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _getkey
L0bed0445:
   cmp word ptr [offset _vocflag],+00
   jz L0bed04a1
   cmp word ptr [offset _systime+02],+00
   jg L0bed04a1
   jl L0bed045d
   cmp word ptr [offset _systime],0FA0
   jnb L0bed04a1
L0bed045d:
   push DS
   mov AX,offset Y2a170917
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a17091c
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170952
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170989
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a17099a
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _getkey
jmp near L0bed0563
L0bed04a1:
   cmp word ptr [offset _vocflag],+00
   jnz L0bed04ab
jmp near L0bed0563
L0bed04ab:
   push DS
   mov AX,offset Y2a1709b8
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1709e5
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170a17
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170a44
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170a78
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170aaa
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170adb
   push AX
   call far _cputs
   pop CX
   pop CX
L0bed04ff:
   call far _getkey
   push [offset _key]
   call far _toupper
   pop CX
   mov [offset _key],AX
   cmp AX,007E
   jnz L0bed053a
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   call far _coreleft
   push DX
   push AX
   call far _ltoa
   add SP,+0A
   push SS
   lea AX,[BP-10]
   push AX
   call far _cputs
   pop CX
   pop CX
L0bed053a:
   cmp word ptr [offset _key],+1B
   jnz L0bed0544
jmp near L0bed0662
L0bed0544:
   cmp word ptr [offset _key],+59
   jz L0bed0552
   cmp word ptr [offset _key],+4E
   jnz L0bed04ff
L0bed0552:
   cmp word ptr [offset _key],+59
   jnz L0bed055e
   mov AX,0001
jmp near L0bed0560
L0bed055e:
   xor AX,AX
L0bed0560:
   mov [offset _cf+14],AX
L0bed0563:
   cmp word ptr [offset _musicflag],+00
   jz L0bed05d4
   call far _clrscr
   push DS
   mov AX,offset Y2a170af8
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170aff
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170b30
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170b4c
   push AX
   call far _cputs
   pop CX
   pop CX
L0bed059f:
   call far _getkey
   push [offset _key]
   call far _toupper
   pop CX
   mov [offset _key],AX
   cmp AX,001B
   jnz L0bed05b9
jmp near L0bed0662
L0bed05b9:
   cmp AX,0059
   jz L0bed05c3
   cmp AX,004E
   jnz L0bed059f
L0bed05c3:
   cmp word ptr [offset _key],+59
   jnz L0bed05cf
   mov AX,0001
jmp near L0bed05d1
L0bed05cf:
   xor AX,AX
L0bed05d1:
   mov [offset _cf+12],AX
L0bed05d4:
   call far _clrscr
   push DS
   mov AX,offset Y2a170b73
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _gc_config
   or AX,AX
   jz L0bed0662
   mov AX,[offset _joyflag]
   mov [offset _cf+02],AX
   call far _clrscr
   push DS
   mov AX,offset Y2a170b76
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170b79
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170ba0
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170bbc
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170bd9
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170bf7
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170bfa
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a170c28
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _gr_config
   or AX,AX
   jnz L0bed0666
L0bed0662:
   xor AX,AX
jmp near L0bed06ca
L0bed0666:
   cmp word ptr [offset _systime+02],+00
   jg L0bed0683
   jl L0bed0677
   cmp word ptr [offset _systime],0FA0
   jnb L0bed0683
L0bed0677:
   mov word ptr [offset _vocflag],0000
   mov word ptr [offset _cf+14],0000
L0bed0683:
   mov word ptr [offset _cf],0000
   mov AX,[offset _cf+02]
   mov [offset _joyflag],AX
   mov AX,[offset _joyxl]
   mov [offset _cf+04],AX
   mov AX,[offset _joyxc]
   mov [offset _cf+06],AX
   mov AX,[offset _joyxr]
   mov [offset _cf+08],AX
   mov AX,[offset _joyyu]
   mov [offset _cf+0a],AX
   mov AX,[offset _joyyc]
   mov [offset _cf+0c],AX
   mov AX,[offset _joyyd]
   mov [offset _cf+0e],AX
   mov AL,[offset _x_ourmode]
   mov AH,00
   mov [offset _cf+10],AX
   mov AX,[offset _cf+14]
   mov [offset _vocflag],AX
   mov AX,[offset _cf+12]
   mov [offset _musicflag],AX
   mov AX,0001
L0bed06ca:
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 0c59 ;; PIXWRITE.C:PIXWRITE
_pixwrite: ;; 0c59000f
   push BP
   mov BP,SP
   sub SP,+74
   push SI
   push DI
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-70]
   push AX
   push [BP+06]
   call far _itoa
   add SP,+08
   push DS
   mov AX,offset Y2a170c4c
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far _strcpy
   add SP,+08
   push SS
   lea AX,[BP-70]
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset Y2a170c54
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far _strcat
   add SP,+08
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far __creat
   add SP,+06
   mov DI,AX
   cmp DI,-01
   jz L0c5900ca
   mov AX,[offset _pagedraw]
   mov [BP-74],AX
   mov AX,[offset _pageshow]
   mov [offset _pagedraw],AX
   mov word ptr [BP-72],0000
jmp near L0c5900b6
L0c59008b:
   xor SI,SI
jmp near L0c5900ad
L0c59008f:
   push [BP-72]
   push SI
   call far _readpix_vga
   pop CX
   pop CX
   mov AX,0001
   push AX
   push DS
   mov AX,offset _pixvalue
   push AX
   push DI
   call far _write
   add SP,+08
   inc SI
L0c5900ad:
   cmp SI,0140
   jl L0c59008f
   inc word ptr [BP-72]
L0c5900b6:
   cmp word ptr [BP-72],00C8
   jl L0c59008b
   mov AX,[BP-74]
   mov [offset _pagedraw],AX
   push DI
   call far __close
   pop CX
L0c5900ca:
   push DS
   mov AX,offset Y2a170c59
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far _strcpy
   add SP,+08
   push SS
   lea AX,[BP-70]
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset Y2a170c61
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far _strcat
   add SP,+08
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far __creat
   add SP,+06
   mov DI,AX
   cmp DI,-01
   jnz L0c59011a
jmp near L0c590214
L0c59011a:
   xor SI,SI
jmp near L0c590204
L0c59011f:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,SI
   mov DX,0003
   mul DX
   mov BX,AX
   mov AL,[BX+offset _vgapal]
   mov AH,00
   shl AX,1
   shl AX,1
   push AX
   call far _itoa
   add SP,+08
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   mov AX,SI
   mov DX,0003
   mul DX
   mov BX,AX
   mov AL,[BX+offset _vgapal+01]
   mov AH,00
   shl AX,1
   shl AX,1
   push AX
   call far _itoa
   add SP,+08
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   mov AX,SI
   mov DX,0003
   mul DX
   mov BX,AX
   mov AL,[BX+offset _vgapal+02]
   mov AH,00
   shl AX,1
   shl AX,1
   push AX
   call far _itoa
   add SP,+08
   push DS
   mov AX,offset Y2a170c66
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   push SS
   lea AX,[BP-20]
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset Y2a170c68
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   push SS
   lea AX,[BP-10]
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset Y2a170c6a
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   push SS
   lea AX,[BP-40]
   push AX
   call far _strlen
   pop CX
   pop CX
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   push DI
   call far _write
   add SP,+08
   inc SI
L0c590204:
   cmp SI,0100
   jge L0c59020d
jmp near L0c59011f
L0c59020d:
   push DI
   call far __close
   pop CX
L0c590214:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 0c7a ;; KEYINTR.ASM:KEYINTR
_handler: ;; 0c7a000a
   cli
   push AX
   push BX
   push DS
   push BP
   mov BP,segment A2a170000
   mov DS,BP
   xor AX,AX
   in AL,60
   cmp AL,E0
   jnz L0c7a001f
jmp near L0c7a0036
X0c7a001e:
   nop
L0c7a001f:
   test AL,80
   jnz L0c7a002d
   mov BX,AX
   mov byte ptr [BX+offset _keydown],01
jmp near L0c7a0036
X0c7a002c:
   nop
L0c7a002d:
   and AL,7F
   mov BX,AX
   mov byte ptr [BX+offset _keydown],00
L0c7a0036:
   pushf
   call far [offset _oldint9]
   pop BP
   pop DS
   pop BX
   pop AX
iret

Segment 0c7e ;; MUSIC.C:MUSIC
_testintr: ;; 0c7e0000 ;; (@) Unaccessed.
   push AX
   push BX
X0c7e0002:
   push CX
   push DX
   push ES
   push DS
   push SI
   push DI
   push BP
   mov BP,segment A2a170000
   mov DS,BP
   pushf
   call far _spkr_intr
   pushf
   call far [offset _oldint8]
   pop BP
   pop DI
   pop SI
   pop DS
   pop ES
   pop DX
   pop CX
   pop BX
   pop AX
iret

_getvoc: ;; 0c7e0023
   push BP
   mov BP,SP
   sub SP,+08
   call far _nosound
   mov BX,[BP+06]
   shl BX,1
   cmp word ptr [BX+offset _voclen],+00
   jnz L0c7e003d
jmp near L0c7e0189
L0c7e003d:
   mov BX,[BP+06]
   cmp byte ptr [BX+offset _vocnum],FF
   jz L0c7e004a
jmp near L0c7e0189
L0c7e004a:
   mov word ptr [BP-08],0000
   mov word ptr [BP-04],FFFF
   mov word ptr [BP-02],FFFF
   mov word ptr [BP-06],0000
jmp near L0c7e0090
L0c7e0060:
   mov BX,[BP-06]
   cmp byte ptr [BX+offset _vocnum],FF
   jz L0c7e008d
   inc word ptr [BP-08]
   mov BX,[BP-06]
   shl BX,1
   mov AX,[BX+offset _vocused]
   cmp AX,[BP-02]
   jnb L0c7e008d
   mov BX,[BP-06]
   shl BX,1
   mov AX,[BX+offset _vocused]
   mov [BP-02],AX
   mov AX,[BP-06]
   mov [BP-04],AX
L0c7e008d:
   inc word ptr [BP-06]
L0c7e0090:
   cmp word ptr [BP-06],+32
   jl L0c7e0060
   cmp word ptr [BP-08],+04
   jl L0c7e00b4
   mov BX,[BP-04]
   mov AL,[BX+offset _vocnum]
   mov BX,[BP+06]
   mov [BX+offset _vocnum],AL
   mov BX,[BP-04]
   mov byte ptr [BX+offset _vocnum],FF
jmp near L0c7e00be
L0c7e00b4:
   mov AL,[BP-08]
   mov BX,[BP+06]
   mov [BX+offset _vocnum],AL
L0c7e00be:
   mov BX,[BP+06]
   mov AL,[BX+offset _vocnum]
   cbw
   mov [BP-08],AX
   mov AX,0020
   push AX
   push DS
   mov AX,offset _vochdr
   push AX
   mov AX,[BP-08]
   mov DX,1800
   mul DX
   mov CX,[offset _memvoc+02]
   mov BX,[offset _memvoc]
   add BX,AX
   push CX
   push BX
   call far _memcpy
   add SP,+0A
   mov BX,[BP+06]
   shl BX,1
   mov AL,[BX+offset _voclen]
   push AX
   mov AX,[BP-08]
   mov DX,1800
   mul DX
   les BX,[offset _memvoc]
   add BX,AX
   pop AX
   mov [ES:BX+1B],AL
   mov BX,[BP+06]
   shl BX,1
   mov AX,[BX+offset _voclen]
   mov CL,08
   sar AX,CL
   push AX
   mov AX,[BP-08]
   mov DX,1800
   mul DX
   les BX,[offset _memvoc]
   add BX,AX
   pop AX
   mov [ES:BX+1C],AL
   mov AX,[BP-08]
   mov DX,1800
   mul DX
   les BX,[offset _memvoc]
   add BX,AX
   mov byte ptr [ES:BX+1E],60
   xor AX,AX
   push AX
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   push [BX+offset _vocposn+02]
   push [BX+offset _vocposn]
   push [offset _vocfilehandle]
   call far _lseek
   add SP,+08
   mov BX,[BP+06]
   shl BX,1
   push [BX+offset _voclen]
   mov AX,[BP-08]
   mov DX,1800
   mul DX
   mov CX,[offset _memvoc+02]
   mov BX,[offset _memvoc]
   add BX,AX
   add BX,+20
   push CX
   push BX
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
L0c7e0189:
   mov SP,BP
   pop BP
ret far

_snd_init: ;; 0c7e018d
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [offset _clockrate],0000
   mov word ptr [offset _clockcount],0000
   mov word ptr [offset _textmsg+02],0000
   mov word ptr [offset _textmsg],0000
   mov word ptr [BP-02],0000
jmp near L0c7e01f1
L0c7e01b2:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _vocposn+02],FFFF
   mov word ptr [BX+offset _vocposn],FFFF
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+offset _voclen],0000
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+offset _vocrate],0000
   mov BX,[BP-02]
   mov byte ptr [BX+offset _vocnum],FF
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+offset _vocused],0000
   inc word ptr [BP-02]
L0c7e01f1:
   cmp word ptr [BP-02],+32
   jl L0c7e01b2
   mov word ptr [BP-02],0000
jmp near L0c7e0214
L0c7e01fe:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _soundmac+02],0000
   mov word ptr [BX+offset _soundmac],0000
   inc word ptr [BP-02]
L0c7e0214:
   cmp word ptr [BP-02],0080
   jl L0c7e01fe
   call far _StartWorx
   mov AX,0008
   push AX
   call far _getvect
   pop CX
   mov [offset _worxint8+02],DX
   mov [offset _worxint8],AX
   mov AX,segment _WorxBugInt8
   push AX
   mov AX,offset _WorxBugInt8
   push AX
   mov AX,0008
   push AX
   call far _setvect
   add SP,+06
   cmp word ptr [offset _musicflag],+00
   jz L0c7e0254
   call far _AdlibDetect
   mov [offset _musicflag],AX
L0c7e0254:
   cmp word ptr [offset _musicflag],+00
   jnz L0c7e0261
   mov word ptr [offset _vocflag],0000
L0c7e0261:
   les BX,[BP+06]
   cmp byte ptr [ES:BX],00
   jnz L0c7e0273
   mov word ptr [offset _vocflag],0000
jmp near L0c7e0300
L0c7e0273:
   mov AX,8001
   push AX
   push [BP+08]
   push [BP+06]
   call far __open
   add SP,+06
   mov [offset _vocfilehandle],AX
   cmp word ptr [offset _vocfilehandle],-01
   jnz L0c7e0297
   mov word ptr [offset _vocflag],0000
jmp near L0c7e0300
L0c7e0297:
   mov AX,00C8
   push AX
   push DS
   mov AX,offset _vocposn
   push AX
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
   mov AX,0064
   push AX
   push DS
   mov AX,offset _voclen
   push AX
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
   mov AX,0064
   push AX
   push DS
   mov AX,offset _vocrate
   push AX
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
   mov AX,00A0
   push AX
   push DS
   mov AX,offset _textposn
   push AX
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
   mov AX,0050
   push AX
   push DS
   mov AX,offset _textlen
   push AX
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
L0c7e0300:
   mov SP,BP
   pop BP
ret far

_snd_play: ;; 0c7e0304
   push BP
   mov BP,SP
   cmp word ptr [offset _vocflag],+00
   jnz L0c7e0311
jmp near L0c7e0390
L0c7e0311:
   cmp word ptr [offset _soundf],+00
   jnz L0c7e031b
jmp near L0c7e0390
L0c7e031b:
   call far _VOCPlaying
   or AX,AX
   jz L0c7e032d
   mov AX,[BP+06]
   cmp AX,[offset _oldpri]
   jl L0c7e038e
L0c7e032d:
   mov BX,[BP+08]
   cmp byte ptr [BX+offset _mirrortab],00
   jz L0c7e0342
   mov BX,[BP+08]
   mov AL,[BX+offset _mirrortab]
   cbw
   mov [BP+08],AX
L0c7e0342:
   push [BP+08]
   push CS
   call near offset _getvoc
   pop CX
   mov BX,[BP+08]
   cmp byte ptr [BX+offset _vocnum],FF
   jz L0c7e0388
   mov AX,007F
   push AX
   mov BX,[BP+08]
   mov AL,[BX+offset _vocnum]
   cbw
   mov DX,1800
   mul DX
   mov CX,[offset _memvoc+02]
   mov BX,[offset _memvoc]
   add BX,AX
   push CX
   push BX
   call far _PlayVOCBlock
   mov SP,BP
   mov AX,[offset _vocuse]
   mov BX,[BP+08]
   shl BX,1
   mov [BX+offset _vocused],AX
   inc word ptr [offset _vocuse]
L0c7e0388:
   mov AX,[BP+06]
   mov [offset _oldpri],AX
L0c7e038e:
jmp near L0c7e03d3
L0c7e0390:
   cmp word ptr [BP+08],0080
   jge L0c7e03d3
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _soundmac]
   or AX,[BX+offset _soundmac+02]
   jz L0c7e03d3
   mov AX,[offset _freq]
   or AX,[offset _freq+02]
   jz L0c7e03d3
   mov AX,[offset _dur]
   or AX,[offset _dur+02]
   jz L0c7e03d3
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   push [BX+offset _soundmac+02]
   push [BX+offset _soundmac]
   push [BP+06]
   call far _soundadd
   mov SP,BP
L0c7e03d3:
   pop BP
ret far

_snd_do: ;; 0c7e03d5
   push BP
   mov BP,SP
   sub SP,+06
   call far _nosound
   cmp word ptr [offset _nosnd],+00
   jnz L0c7e03f5
   cmp word ptr [offset _musicflag],+00
   jnz L0c7e03f5
   cmp word ptr [offset _vocflag],+00
   jz L0c7e03fd
L0c7e03f5:
   mov word ptr [offset _clockrate],0000
jmp near L0c7e040a
L0c7e03fd:
   cmp word ptr [offset _vocflag],+00
   jnz L0c7e040a
   mov word ptr [offset _clockrate],0040
L0c7e040a:
   cmp word ptr [offset _musicflag],+00
   jz L0c7e041e
   mov AL,0F
   push AX
   mov AL,0F
   push AX
   call far _SetFMVolume
   pop CX
   pop CX
L0c7e041e:
   cmp word ptr [offset _vocflag],+00
   jz L0c7e045a
   call far _DSPReset
   or AX,AX
   jz L0c7e0433
   mov AX,0001
jmp near L0c7e0435
L0c7e0433:
   xor AX,AX
L0c7e0435:
   mov [offset _SetDSP],AX
   mov AX,[offset _SetDSP]
   mov [offset _vocflag],AX
   cmp word ptr [offset _vocflag],+00
   jnz L0c7e044d
   mov word ptr [offset _soundoff],0001
jmp near L0c7e045a
L0c7e044d:
   mov AL,0F
   push AX
   mov AL,0F
   push AX
   call far _SetMasterVolume
   pop CX
   pop CX
L0c7e045a:
   cmp word ptr [offset _vocflag],+00
   jz L0c7e0475
   mov AX,7800
   push AX
   call far _malloc
   pop CX
   mov [offset _memvoc+02],DX
   mov [offset _memvoc],AX
jmp near L0c7e05a3
L0c7e0475:
   mov word ptr [offset _memvoc+02],0000
   mov word ptr [offset _memvoc],0000
   mov AX,2080
   push AX
   call far _malloc
   pop CX
   mov [offset _freq+02],DX
   mov [offset _freq],AX
   mov AX,2080
   push AX
   call far _malloc
   pop CX
   mov [offset _dur+02],DX
   mov [offset _dur],AX
   xor AX,AX
   push AX
   mov AX,[offset _headersize]
   cwd
   push DX
   push AX
   push [offset _vocfilehandle]
   call far _lseek
   add SP,+08
   mov word ptr [BP-04],0000
jmp near L0c7e0544
L0c7e04c0:
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
   cmp word ptr [BP-06],+00
   jz L0c7e052e
   push [BP-06]
   call far _malloc
   pop CX
   mov BX,[BP-04]
   shl BX,1
   shl BX,1
   mov [BX+offset _soundmac+02],DX
   mov [BX+offset _soundmac],AX
   mov BX,[BP-04]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _soundmac]
   or AX,[BX+offset _soundmac+02]
   jnz L0c7e050e
   mov AX,009A
   push AX
   call far _rexit
   pop CX
L0c7e050e:
   push [BP-06]
   mov BX,[BP-04]
   shl BX,1
   shl BX,1
   push [BX+offset _soundmac+02]
   push [BX+offset _soundmac]
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
jmp near L0c7e0541
L0c7e052e:
   mov BX,[BP-04]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _soundmac+02],0000
   mov word ptr [BX+offset _soundmac],0000
L0c7e0541:
   inc word ptr [BP-04]
L0c7e0544:
   cmp word ptr [BP-04],0080
   jge L0c7e054e
jmp near L0c7e04c0
L0c7e054e:
   mov AX,28F0
   push AX
   call far _malloc
   pop CX
   mov [offset _SOUNDS+02],DX
   mov [offset _SOUNDS],AX
   mov AX,8001
   push AX
   push DS
   mov AX,offset Y2a170dda
   push AX
   call far __open
   add SP,+06
   mov [BP-02],AX
   cmp word ptr [BP-02],-01
   jnz L0c7e0583
   mov AX,009B
   push AX
   call far _rexit
   pop CX
L0c7e0583:
   mov AX,28A0
   push AX
   push [offset _SOUNDS+02]
   push [offset _SOUNDS]
   push [BP-02]
   call far __read
   add SP,+08
   push [BP-02]
   call far _close
   pop CX
L0c7e05a3:
   cmp word ptr [offset _clockrate],+00
   jnz L0c7e05b8
   mov word ptr [offset _clockrate],0001
   mov word ptr [offset _soundoff],0001
jmp near L0c7e060d
L0c7e05b8:
   cmp word ptr [offset _clockrate],+01
   jbe L0c7e060d
   mov word ptr [offset _soundoff],0000
   mov AX,0008
   push AX
   call far _getvect
   pop CX
   mov [offset _oldint8+02],DX
   mov [offset _oldint8],AX
   mov AX,segment _spkr_intr
   push AX
   mov AX,offset _spkr_intr
   push AX
   mov AX,0008
   push AX
   call far _setvect
   add SP,+06
   mov AX,[offset _clockrate]
   xor DX,DX
   push DX
   push AX
   mov DX,0001
   xor AX,AX
   push DX
   push AX
   call far LDIV@
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   call far _timerset
   add SP,+06
L0c7e060d:
   mov SP,BP
   pop BP
ret far

_text_get: ;; 0c7e0611
   push BP
   mov BP,SP
   mov word ptr [offset _textmsg+02],0000
   mov word ptr [offset _textmsg],0000
   mov BX,[BP+06]
   shl BX,1
   cmp word ptr [BX+offset _textlen],+00
   jz L0c7e0697
   mov BX,[BP+06]
   shl BX,1
   mov AX,[BX+offset _textlen]
   mov [offset _textmsglen],AX
   push [offset _textmsglen]
   call far _malloc
   pop CX
   mov [offset _textmsg+02],DX
   mov [offset _textmsg],AX
   mov AX,[offset _textmsg]
   or AX,[offset _textmsg+02]
   jz L0c7e0697
   xor AX,AX
   push AX
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   push [BX+offset _textposn+02]
   push [BX+offset _textposn]
   push [offset _vocfilehandle]
   call far _lseek
   mov SP,BP
   push [offset _textmsglen]
   push [offset _textmsg+02]
   push [offset _textmsg]
   push [offset _vocfilehandle]
   call far _read
   mov SP,BP
   cmp AX,FFFF
   jnz L0c7e0697
   mov word ptr [offset _textmsg+02],0000
   mov word ptr [offset _textmsg],0000
L0c7e0697:
   pop BP
ret far

_snd_exit: ;; 0c7e0699
   push BP
   mov BP,SP
   sub SP,+02
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   call far _timerset
   add SP,+06
   call far _nosound
   mov AX,[offset _freq]
   or AX,[offset _freq+02]
   jz L0c7e06ce
   push [offset _freq+02]
   push [offset _freq]
   call far _free
   pop CX
   pop CX
L0c7e06ce:
   mov AX,[offset _dur]
   or AX,[offset _dur+02]
   jz L0c7e06e6
   push [offset _dur+02]
   push [offset _dur]
   call far _free
   pop CX
   pop CX
L0c7e06e6:
   mov word ptr [BP-02],0000
jmp near L0c7e0717
L0c7e06ed:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _soundmac]
   or AX,[BX+offset _soundmac+02]
   jz L0c7e0714
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+offset _soundmac+02]
   push [BX+offset _soundmac]
   call far _free
   pop CX
   pop CX
L0c7e0714:
   inc word ptr [BP-02]
L0c7e0717:
   cmp word ptr [BP-02],0080
   jl L0c7e06ed
   push [offset _memvoc+02]
   push [offset _memvoc]
   call far _free
   pop CX
   pop CX
   cmp word ptr [offset _vocfilehandle],+00
   jl L0c7e073e
   push [offset _vocfilehandle]
   call far _close
   pop CX
L0c7e073e:
   mov AX,[offset _oldint8]
   or AX,[offset _oldint8+02]
   jz L0c7e075b
   push [offset _oldint8+02]
   push [offset _oldint8]
   mov AX,0008
   push AX
   call far _setvect
   add SP,+06
L0c7e075b:
   cmp word ptr [offset _SetDSP],+00
   jz L0c7e0767
   call far _DSPClose
L0c7e0767:
   push [offset _worxint8+02]
   push [offset _worxint8]
   mov AX,0008
   push AX
   call far _setvect
   add SP,+06
   call far _CloseWorx
   mov SP,BP
   pop BP
ret far

_sb_update: ;; 0c7e0784
ret far

_sb_playing: ;; 0c7e0785
   mov AX,0001
jmp near L0c7e078a
L0c7e078a:
ret far

_sb_shutup: ;; 0c7e078b
   cmp word ptr [offset _musicflag],+00
   jz L0c7e07b2
   call far _StopSequence
   push [offset _song+02]
   push [offset _song]
   call far _free
   pop CX
   pop CX
   mov word ptr [offset _song+02],0000
   mov word ptr [offset _song],0000
L0c7e07b2:
ret far

_sb_playtune: ;; 0c7e07b3
   push BP
   mov BP,SP
   cmp word ptr [offset _musicflag],+00
   jnz L0c7e07bf
jmp near L0c7e07f9
L0c7e07bf:
   push CS
   call near offset _sb_shutup
   push [BP+08]
   push [BP+06]
   call far _GetSequence
   mov SP,BP
   mov [offset _song+02],DX
   mov [offset _song],AX
   mov AX,[offset _song]
   or AX,[offset _song+02]
   jz L0c7e07f9
   mov AX,0001
   push AX
   call far _SetLoopMode
   pop CX
   push [offset _song+02]
   push [offset _song]
   call far _PlayCMFBlock
   mov SP,BP
L0c7e07f9:
   pop BP
ret far

_sampadd1: ;; 0c7e07fb ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+12
   mov AX,[BP+06]
   mov CL,07
   shl AX,CL
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov [BP-02],ES
   mov [BP-04],BX
   cmp word ptr [offset _soundoff],+00
   jz L0c7e0820
jmp near L0c7e08cc
L0c7e0820:
   mov word ptr [BP-12],0000
   mov BX,[BP+0C]
   add BX,+10
   shl BX,1
   mov AX,[BX+offset _notetable]
   cwd
   mov [BP-06],DX
   mov [BP-08],AX
   mov word ptr [offset _makesound],0001
L0c7e083e:
   mov AX,[BP-12]
   shl AX,1
   les BX,[BP-04]
   add BX,AX
   mov AX,[ES:BX]
   cwd
   mov [BP-0A],DX
   mov [BP-0C],AX
   inc word ptr [BP-12]
   cmp word ptr [BP-0A],-01
   jnz L0c7e0873
   cmp word ptr [BP-0C],-01
   jnz L0c7e0873
   mov AX,[offset _soundlen]
   shl AX,1
   les BX,[offset _freq]
   add BX,AX
   mov word ptr [ES:BX],FFFF
jmp near L0c7e08a3
L0c7e0873:
   mov DX,[BP-0A]
   mov AX,[BP-0C]
   mov CX,[BP-06]
   mov BX,[BP-08]
   call far LXMUL@
   mov CL,0A
   call far LXRSH@
   mov [BP-0E],DX
   mov [BP-10],AX
   mov AX,[BP-10]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _freq]
   add BX,DX
   mov [ES:BX],AX
L0c7e08a3:
   mov AX,[BP+0A]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
   mov AX,[BP-12]
   cmp AX,[BP+08]
   jge L0c7e08cc
   cmp word ptr [offset _soundlen],1000
   jge L0c7e08cc
jmp near L0c7e083e
L0c7e08cc:
   mov SP,BP
   pop BP
ret far

_soundadd1: ;; 0c7e08d0 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+0A
   mov word ptr [BP-06],FFFF
   cmp word ptr [offset _soundoff],+00
   jz L0c7e08e5
jmp near L0c7e0adc
L0c7e08e5:
   cmp word ptr [offset _makesound],+00
   jz L0c7e0905
   mov AX,[BP+06]
   cmp AX,[offset _notepriority]
   jl L0c7e08fc
   cmp word ptr [offset _notepriority],-01
   jnz L0c7e0905
L0c7e08fc:
   cmp word ptr [BP+06],-01
   jz L0c7e0905
jmp near L0c7e0adc
L0c7e0905:
   cmp word ptr [BP+06],+00
   jge L0c7e0912
   cmp word ptr [offset _makesound],+00
   jnz L0c7e092a
L0c7e0912:
   mov word ptr [offset _makesound],0000
   mov word ptr [offset _soundptr],0000
   mov word ptr [offset _soundlen],0000
   mov word ptr [offset _soundcount],0000
L0c7e092a:
   mov AX,[BP+06]
   mov [offset _notepriority],AX
   mov word ptr [BP-0A],0000
L0c7e0935:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],F0
   jnz L0c7e0954
   inc word ptr [BP-0A]
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-06],AX
   inc word ptr [BP-0A]
L0c7e0954:
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-08],AX
   inc word ptr [BP-0A]
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-04],AX
   inc word ptr [BP-0A]
   cmp word ptr [BP-06],-01
   jnz L0c7e09b5
   mov BX,[BP-08]
   shl BX,1
   mov AX,[BX+offset _notetable]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _freq]
   add BX,DX
   mov [ES:BX],AX
   mov AX,[BP-04]
   mul word ptr [offset _clockrate]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
   mov word ptr [offset _makesound],0001
jmp near L0c7e0ac5
L0c7e09b5:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e09cd
   mov AX,0001
jmp near L0c7e09dd
L0c7e09cd:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov AX,[ES:BX+2800]
L0c7e09dd:
   mov CL,07
   shl AX,CL
   push AX
   mov AX,[BP-04]
   mul word ptr [offset _clockrate]
   pop DX
   sub AX,DX
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jle L0c7e0a58
   push [BP-08]
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0a10
   mov AX,0001
jmp near L0c7e0a20
L0c7e0a10:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov AX,[ES:BX+2800]
L0c7e0a20:
   push AX
   mov AX,0080
   push AX
   push [BP-06]
   call far _sampadd
   add SP,+08
   mov AX,[offset _soundlen]
   shl AX,1
   les BX,[offset _freq]
   add BX,AX
   mov word ptr [ES:BX],FFFF
   mov AX,[BP-02]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
jmp near L0c7e0ac5
L0c7e0a58:
   push [BP-08]
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0a73
   mov AX,0001
jmp near L0c7e0a83
L0c7e0a73:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov AX,[ES:BX+2800]
L0c7e0a83:
   push AX
   mov AX,[BP-04]
   mul word ptr [offset _clockrate]
   push AX
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0aa4
   mov BX,0001
jmp near L0c7e0ab4
L0c7e0aa4:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov BX,[ES:BX+2800]
L0c7e0ab4:
   pop AX
   xor DX,DX
   div BX
   push AX
   push [BP-06]
   call far _sampadd
   add SP,+08
L0c7e0ac5:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],00
   jz L0c7e0adc
   cmp word ptr [offset _soundlen],1000
   jge L0c7e0adc
jmp near L0c7e0935
L0c7e0adc:
   mov SP,BP
   pop BP
ret far

_soundstop: ;; 0c7e0ae0 ;; (@) Unaccessed.
   mov word ptr [offset _makesound],0000
   call far _nosound
ret far

_timerset: ;; 0c7e0aec
   push BP
   mov BP,SP
   mov AL,[BP+06]
   mov CL,06
   shl AL,CL
   mov DL,[BP+08]
   shl DL,1
   add AL,DL
   add AL,30
   out 43,AL
   mov DX,[BP+06]
   add DX,+40
   mov AL,[BP+0A]
   out DX,AL
   mov AX,[BP+0A]
   mov CL,08
   shr AX,CL
   mov DX,[BP+06]
   add DX,+40
   out DX,AL
   pop BP
ret far

_sampadd: ;; 0c7e0b1b
   push BP
   mov BP,SP
   sub SP,+12
   mov AX,[BP+06]
   mov CL,07
   shl AX,CL
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov [BP-10],ES
   mov [BP-12],BX
   cmp word ptr [offset _soundoff],+00
   jz L0c7e0b40
jmp near L0c7e0bec
L0c7e0b40:
   mov word ptr [BP-0E],0000
   mov BX,[BP+0C]
   add BX,+10
   shl BX,1
   mov AX,[BX+offset _notetable]
   cwd
   mov [BP-02],DX
   mov [BP-04],AX
   mov word ptr [offset _makesound],0001
L0c7e0b5e:
   mov AX,[BP-0E]
   shl AX,1
   les BX,[BP-12]
   add BX,AX
   mov AX,[ES:BX]
   cwd
   mov [BP-06],DX
   mov [BP-08],AX
   inc word ptr [BP-0E]
   cmp word ptr [BP-06],-01
   jnz L0c7e0b93
   cmp word ptr [BP-08],-01
   jnz L0c7e0b93
   mov AX,[offset _soundlen]
   shl AX,1
   les BX,[offset _freq]
   add BX,AX
   mov word ptr [ES:BX],FFFF
jmp near L0c7e0bc3
L0c7e0b93:
   mov DX,[BP-06]
   mov AX,[BP-08]
   mov CX,[BP-02]
   mov BX,[BP-04]
   call far LXMUL@
   mov CL,0A
   call far LXRSH@
   mov [BP-0A],DX
   mov [BP-0C],AX
   mov AX,[BP-0C]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _freq]
   add BX,DX
   mov [ES:BX],AX
L0c7e0bc3:
   mov AX,[BP+0A]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
   mov AX,[BP-0E]
   cmp AX,[BP+08]
   jge L0c7e0bec
   cmp word ptr [offset _soundlen],1000
   jge L0c7e0bec
jmp near L0c7e0b5e
L0c7e0bec:
   mov SP,BP
   pop BP
ret far

_soundadd2: ;; 0c7e0bf0 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+0A
   mov word ptr [BP-06],FFFF
   cmp word ptr [offset _soundoff],+00
   jz L0c7e0c05
jmp near L0c7e0dfa
L0c7e0c05:
   cmp word ptr [offset _makesound],+00
   jz L0c7e0c25
   mov AX,[BP+06]
   cmp AX,[offset _notepriority]
   jl L0c7e0c1c
   cmp word ptr [offset _notepriority],-01
   jnz L0c7e0c25
L0c7e0c1c:
   cmp word ptr [BP+06],-01
   jz L0c7e0c25
jmp near L0c7e0dfa
L0c7e0c25:
   cmp word ptr [BP+06],+00
   jge L0c7e0c32
   cmp word ptr [offset _makesound],+00
   jnz L0c7e0c4a
L0c7e0c32:
   mov word ptr [offset _makesound],0000
   mov word ptr [offset _soundptr],0000
   mov word ptr [offset _soundlen],0000
   mov word ptr [offset _soundcount],0000
L0c7e0c4a:
   mov AX,[BP+06]
   mov [offset _notepriority],AX
   mov word ptr [BP-0A],0000
L0c7e0c55:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],F0
   jnz L0c7e0c74
   inc word ptr [BP-0A]
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-06],AX
   inc word ptr [BP-0A]
L0c7e0c74:
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-08],AX
   inc word ptr [BP-0A]
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-04],AX
   inc word ptr [BP-0A]
   cmp word ptr [BP-06],-01
   jnz L0c7e0cd5
   mov BX,[BP-08]
   shl BX,1
   mov AX,[BX+offset _notetable]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _freq]
   add BX,DX
   mov [ES:BX],AX
   mov AX,[BP-04]
   mul word ptr [offset _clockrate]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
   mov word ptr [offset _makesound],0001
jmp near L0c7e0de3
L0c7e0cd5:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0ced
   mov AX,0001
jmp near L0c7e0cfd
L0c7e0ced:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov AX,[ES:BX+2800]
L0c7e0cfd:
   mov CL,07
   shl AX,CL
   push AX
   mov AX,[BP-04]
   mul word ptr [offset _clockrate]
   pop DX
   sub AX,DX
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jle L0c7e0d77
   push [BP-08]
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0d30
   mov AX,0001
jmp near L0c7e0d40
L0c7e0d30:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov AX,[ES:BX+2800]
L0c7e0d40:
   push AX
   mov AX,0080
   push AX
   push [BP-06]
   push CS
   call near offset _sampadd
   add SP,+08
   mov AX,[offset _soundlen]
   shl AX,1
   les BX,[offset _freq]
   add BX,AX
   mov word ptr [ES:BX],FFFF
   mov AX,[BP-02]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
jmp near L0c7e0de3
L0c7e0d77:
   push [BP-08]
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0d92
   mov AX,0001
jmp near L0c7e0da2
L0c7e0d92:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov AX,[ES:BX+2800]
L0c7e0da2:
   push AX
   mov AX,[BP-04]
   mul word ptr [offset _clockrate]
   push AX
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0dc3
   mov BX,0001
jmp near L0c7e0dd3
L0c7e0dc3:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov BX,[ES:BX+2800]
L0c7e0dd3:
   pop AX
   xor DX,DX
   div BX
   push AX
   push [BP-06]
   push CS
   call near offset _sampadd
   add SP,+08
L0c7e0de3:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],00
   jz L0c7e0dfa
   cmp word ptr [offset _soundlen],1000
   jge L0c7e0dfa
jmp near L0c7e0c55
L0c7e0dfa:
   mov SP,BP
   pop BP
ret far

_soundadd: ;; 0c7e0dfe
   push BP
   mov BP,SP
   sub SP,+0A
   mov word ptr [BP-06],FFFF
   cmp word ptr [offset _soundoff],+00
   jz L0c7e0e13
jmp near L0c7e1003
L0c7e0e13:
   cmp word ptr [offset _makesound],+00
   jz L0c7e0e33
   mov AX,[BP+06]
   cmp AX,[offset _notepriority]
   jl L0c7e0e2a
   cmp word ptr [offset _notepriority],-01
   jnz L0c7e0e33
L0c7e0e2a:
   cmp word ptr [BP+06],-01
   jz L0c7e0e33
jmp near L0c7e1003
L0c7e0e33:
   cmp word ptr [BP+06],+00
   jge L0c7e0e40
   cmp word ptr [offset _makesound],+00
   jnz L0c7e0e58
L0c7e0e40:
   mov word ptr [offset _makesound],0000
   mov word ptr [offset _soundptr],0000
   mov word ptr [offset _soundlen],0000
   mov word ptr [offset _soundcount],0000
L0c7e0e58:
   mov AX,[BP+06]
   mov [offset _notepriority],AX
   mov word ptr [BP-0A],0000
L0c7e0e63:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],F0
   jnz L0c7e0e82
   inc word ptr [BP-0A]
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-06],AX
   inc word ptr [BP-0A]
L0c7e0e82:
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-08],AX
   inc word ptr [BP-0A]
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-04],AX
   inc word ptr [BP-0A]
   cmp word ptr [BP-06],-01
   jnz L0c7e0ee3
   mov BX,[BP-08]
   shl BX,1
   mov AX,[BX+offset _notetable]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _freq]
   add BX,DX
   mov [ES:BX],AX
   mov AX,[BP-04]
   mul word ptr [offset _clockrate]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
   mov word ptr [offset _makesound],0001
jmp near L0c7e0fec
L0c7e0ee3:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0efb
   mov AX,0001
jmp near L0c7e0f0b
L0c7e0efb:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov AX,[ES:BX+2800]
L0c7e0f0b:
   mov CL,07
   shl AX,CL
   push AX
   mov AX,[BP-04]
   mul word ptr [offset _clockrate]
   pop DX
   sub AX,DX
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jle L0c7e0f85
   push [BP-08]
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0f3e
   mov AX,0001
jmp near L0c7e0f4e
L0c7e0f3e:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov AX,[ES:BX+2800]
L0c7e0f4e:
   push AX
   mov AX,0080
   push AX
   push [BP-06]
   push CS
   call near offset _sampadd
   add SP,+08
   mov AX,[offset _soundlen]
   shl AX,1
   les BX,[offset _freq]
   add BX,AX
   mov word ptr [ES:BX],FFFF
   mov AX,[BP-02]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
jmp near L0c7e0fec
L0c7e0f85:
   push [BP-08]
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0fa0
   mov AX,0001
jmp near L0c7e0fb0
L0c7e0fa0:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov AX,[ES:BX+2800]
L0c7e0fb0:
   push AX
   mov AX,[BP-02]
   push AX
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   cmp word ptr [ES:BX+2800],+01
   jge L0c7e0fcd
   mov BX,0001
jmp near L0c7e0fdd
L0c7e0fcd:
   mov AX,[BP-06]
   shl AX,1
   les BX,[offset _SOUNDS]
   add BX,AX
   mov BX,[ES:BX+2800]
L0c7e0fdd:
   pop AX
   cwd
   idiv BX
   push AX
   push [BP-06]
   push CS
   call near offset _sampadd
   add SP,+08
L0c7e0fec:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],00
   jz L0c7e1003
   cmp word ptr [offset _soundlen],1000
   jge L0c7e1003
jmp near L0c7e0e63
L0c7e1003:
   mov SP,BP
   pop BP
ret far

Segment 0d7e ;; MUSINTR.ASM:MUSINTR
Y0d7e0005:	byte

X0d7e0006:
   push AX
X0d7e0007:
   push BX
_spkr_intr: ;; 0d7e0008
   push AX
   push BX
   push CX
   push DX
   push ES
   push DS
   push SI
   push DI
   push BP
   mov BP,segment A2a170000
   mov DS,BP
   mov BP,SP
   sub SP,+02
   cmp word ptr [offset _makesound],+00
   jnz L0d7e0025
jmp near L0d7e009e
X0d7e0024:
   nop
L0d7e0025:
   cmp word ptr [offset _soundf],+00
   jnz L0d7e002f
jmp near L0d7e009e
X0d7e002e:
   nop
L0d7e002f:
   dec word ptr [offset _soundcount]
   cmp word ptr [offset _soundcount],+00
   jg L0d7e009c
   mov AX,[offset _soundptr]
   cmp AX,[offset _soundlen]
   jl L0d7e0050
   mov word ptr [offset _makesound],0000
   call far _nosound
jmp near L0d7e009c
L0d7e0050:
   mov AX,[offset _soundptr]
   shl AX,1
   les BX,[offset _freq]
   add BX,AX
   mov AX,[ES:BX]
   mov [BP-02],AX
   cmp word ptr [BP-02],-01
   jnz L0d7e006e
   call far _nosound
jmp near L0d7e0081
L0d7e006e:
   mov AX,[BP-02]
   cmp AX,[offset _oldfreq]
   jz L0d7e0081
   push [BP-02]
   call far _sound
   inc SP
   inc SP
L0d7e0081:
   mov AX,[offset _soundptr]
   shl AX,1
   les BX,[offset _dur]
   add BX,AX
   mov AX,[ES:BX]
   mov [offset _soundcount],AX
   inc word ptr [offset _soundptr]
   mov AX,[BP-02]
   mov [offset _oldfreq],AX
L0d7e009c:
jmp near L0d7e00a3
L0d7e009e:
   call far _nosound
L0d7e00a3:
   mov AX,[offset _clockcount]
   inc word ptr [offset _clockcount]
   cmp AX,0002
   jbe L0d7e00bc
   mov word ptr [offset _clockcount],0000
   pushf
   call far [offset _oldint8]
jmp near L0d7e00c0
L0d7e00bc:
   mov AL,20
   out 20,AL
L0d7e00c0:
   mov SP,BP
   pop BP
   pop DI
   pop SI
   pop DS
   pop ES
   pop DX
   pop CX
   pop BX
   pop AX
iret

_WorxBugInt8: ;; 0d7e00cc
   push AX
   push BX
   push CX
   push DX
   push ES
   push DS
   push SI
   push DI
   push BP
   mov BP,segment A2a170000
   mov DS,BP
   cld
   pushf
   call far [offset _worxint8]
   pop BP
   pop DI
   pop SI
   pop DS
   pop ES
   pop DX
   pop CX
   pop BX
   pop AX
iret

Segment 0d8c ;; JOBJ.C:JOBJ
_initobjinfo: ;; 0d8c000a
   mov word ptr [offset _kindmsg+4*00+02],segment _msg_player
   mov word ptr [offset _kindmsg+4*00+00],offset _msg_player
   mov word ptr [offset _kindxl+2*00],0010
   mov word ptr [offset _kindyl+2*00],0020
   mov [offset _kindname+4*00+02],DS
   mov word ptr [offset _kindname+4*00],offset Y2a170e3e
   mov word ptr [offset _kindflags+2*00],0008
   mov word ptr [offset _kindtable+2*00],0008
   mov word ptr [offset _kindscore+2*00],0000
   mov word ptr [offset _kindmsg+4*01+02],segment _msg_apple
   mov word ptr [offset _kindmsg+4*01+00],offset _msg_apple
   mov word ptr [offset _kindxl+2*01],000C
   mov word ptr [offset _kindyl+2*01],000C
   mov [offset _kindname+4*01+02],DS
   mov word ptr [offset _kindname+4*01],offset Y2a170e45
   mov word ptr [offset _kindflags+2*01],0000
   mov word ptr [offset _kindtable+2*01],0009
   mov word ptr [offset _kindscore+2*01],000C
   mov word ptr [offset _kindmsg+4*02+02],segment _msg_knife
   mov word ptr [offset _kindmsg+4*02+00],offset _msg_knife
   mov word ptr [offset _kindxl+2*02],000A
   mov word ptr [offset _kindyl+2*02],000A
   mov [offset _kindname+4*02+02],DS
   mov word ptr [offset _kindname+4*02],offset Y2a170e4b
   mov word ptr [offset _kindflags+2*02],4008
   mov word ptr [offset _kindtable+2*02],000D
   mov word ptr [offset _kindscore+2*02],0000
   mov word ptr [offset _kindmsg+4*03+02],segment _msg_null
   mov word ptr [offset _kindmsg+4*03+00],offset _msg_null
   mov word ptr [offset _kindxl+2*03],0000
   mov word ptr [offset _kindyl+2*03],0000
   mov [offset _kindname+4*03+02],DS
   mov word ptr [offset _kindname+4*03],offset Y2a170e51
   mov word ptr [offset _kindflags+2*03],0000
   mov word ptr [offset _kindtable+2*03],0000
   mov word ptr [offset _kindscore+2*03],0000
   mov word ptr [offset _kindmsg+4*04+02],segment _msg_bigant
   mov word ptr [offset _kindmsg+4*04+00],offset _msg_bigant
   mov word ptr [offset _kindxl+2*04],0018
   mov word ptr [offset _kindyl+2*04],0010
   mov [offset _kindname+4*04+02],DS
   mov word ptr [offset _kindname+4*04],offset Y2a170e58
   mov word ptr [offset _kindflags+2*04],0480
   mov word ptr [offset _kindtable+2*04],003B
   mov word ptr [offset _kindscore+2*04],0008
   mov word ptr [offset _kindmsg+4*05+02],segment _msg_fly
   mov word ptr [offset _kindmsg+4*05+00],offset _msg_fly
   mov word ptr [offset _kindxl+2*05],0010
   mov word ptr [offset _kindyl+2*05],000E
   mov [offset _kindname+4*05+02],DS
   mov word ptr [offset _kindname+4*05],offset Y2a170e5f
   mov word ptr [offset _kindflags+2*05],0080
   mov word ptr [offset _kindtable+2*05],003C
   mov word ptr [offset _kindscore+2*05],0003
   mov word ptr [offset _kindmsg+4*06+02],segment _msg_macrotrig
   mov word ptr [offset _kindmsg+4*06+00],offset _msg_macrotrig
   mov word ptr [offset _kindxl+2*06],0000
   mov word ptr [offset _kindyl+2*06],0000
   mov [offset _kindname+4*06+02],DS
   mov word ptr [offset _kindname+4*06],offset Y2a170e63
   mov word ptr [offset _kindflags+2*06],0008
   mov word ptr [offset _kindtable+2*06],0000
   mov word ptr [offset _kindscore+2*06],0000
   mov word ptr [offset _kindmsg+4*07+02],segment _msg_demon
   mov word ptr [offset _kindmsg+4*07+00],offset _msg_demon
   mov word ptr [offset _kindxl+2*07],0020
   mov word ptr [offset _kindyl+2*07],0020
   mov [offset _kindname+4*07+02],DS
   mov word ptr [offset _kindname+4*07],offset Y2a170e6d
   mov word ptr [offset _kindflags+2*07],0000
   mov word ptr [offset _kindtable+2*07],002B
   mov word ptr [offset _kindscore+2*07],0014
   mov word ptr [offset _kindmsg+4*08+02],segment _msg_frog
   mov word ptr [offset _kindmsg+4*08+00],offset _msg_frog
   mov word ptr [offset _kindxl+2*08],0008
   mov word ptr [offset _kindyl+2*08],0008
   mov [offset _kindname+4*08+02],DS
   mov word ptr [offset _kindname+4*08],offset Y2a170e73
   mov word ptr [offset _kindflags+2*08],0480
   mov word ptr [offset _kindtable+2*08],003A
   mov word ptr [offset _kindscore+2*08],0002
   mov word ptr [offset _kindmsg+4*09+02],segment _msg_inchworm
   mov word ptr [offset _kindmsg+4*09+00],offset _msg_inchworm
   mov word ptr [offset _kindxl+2*09],0010
   mov word ptr [offset _kindyl+2*09],0008
   mov [offset _kindname+4*09+02],DS
   mov word ptr [offset _kindname+4*09],offset Y2a170e79
   mov word ptr [offset _kindflags+2*09],0480
   mov word ptr [offset _kindtable+2*09],0016
   mov word ptr [offset _kindscore+2*09],0003
   mov word ptr [offset _kindmsg+4*0a+02],segment _msg_zapper
   mov word ptr [offset _kindmsg+4*0a+00],offset _msg_zapper
   mov word ptr [offset _kindxl+2*0a],0020
   mov word ptr [offset _kindyl+2*0a],0010
   mov [offset _kindname+4*0a+02],DS
   mov word ptr [offset _kindname+4*0a],offset Y2a170e82
   mov word ptr [offset _kindflags+2*0a],0000
   mov word ptr [offset _kindtable+2*0a],001C
   mov word ptr [offset _kindscore+2*0a],0000
   mov word ptr [offset _kindmsg+4*0b+02],segment _msg_bobslug
   mov word ptr [offset _kindmsg+4*0b+00],offset _msg_bobslug
   mov word ptr [offset _kindxl+2*0b],0018
   mov word ptr [offset _kindyl+2*0b],0018
   mov [offset _kindname+4*0b+02],DS
   mov word ptr [offset _kindname+4*0b],offset Y2a170e89
   mov word ptr [offset _kindflags+2*0b],0400
   mov word ptr [offset _kindtable+2*0b],0034
   mov word ptr [offset _kindscore+2*0b],0005
   mov word ptr [offset _kindmsg+4*0c+02],segment _msg_checkpt
   mov word ptr [offset _kindmsg+4*0c+00],offset _msg_checkpt
   mov word ptr [offset _kindxl+2*0c],0010
   mov word ptr [offset _kindyl+2*0c],0010
   mov [offset _kindname+4*0c+02],DS
   mov word ptr [offset _kindname+4*0c],offset Y2a170e91
   mov word ptr [offset _kindflags+2*0c],0040
   mov word ptr [offset _kindtable+2*0c],0000
   mov word ptr [offset _kindscore+2*0c],0000
   mov word ptr [offset _kindmsg+4*0d+02],segment _msg_paul
   mov word ptr [offset _kindmsg+4*0d+00],offset _msg_paul
   mov word ptr [offset _kindxl+2*0d],0018
   mov word ptr [offset _kindyl+2*0d],0020
   mov [offset _kindname+4*0d+02],DS
   mov word ptr [offset _kindname+4*0d],offset Y2a170e99
   mov word ptr [offset _kindflags+2*0d],0000
   mov word ptr [offset _kindtable+2*0d],0039
   mov word ptr [offset _kindscore+2*0d],0000
   mov word ptr [offset _kindmsg+4*0e+02],segment _msg_key
   mov word ptr [offset _kindmsg+4*0e+00],offset _msg_key
   mov word ptr [offset _kindxl+2*0e],0010
   mov word ptr [offset _kindyl+2*0e],0008
   mov [offset _kindname+4*0e+02],DS
   mov word ptr [offset _kindname+4*0e],offset Y2a170e9e
   mov word ptr [offset _kindflags+2*0e],0000
   mov word ptr [offset _kindtable+2*0e],000E
   mov word ptr [offset _kindscore+2*0e],0000
   mov word ptr [offset _kindmsg+4*0f+02],segment _msg_pad
   mov word ptr [offset _kindmsg+4*0f+00],offset _msg_pad
   mov word ptr [offset _kindxl+2*0f],0010
   mov word ptr [offset _kindyl+2*0f],0010
   mov [offset _kindname+4*0f+02],DS
   mov word ptr [offset _kindname+4*0f],offset Y2a170ea2
   mov word ptr [offset _kindflags+2*0f],0000
   mov word ptr [offset _kindtable+2*0f],0000
   mov word ptr [offset _kindscore+2*0f],0000
   mov word ptr [offset _kindmsg+4*10+02],segment _msg_wiseman
   mov word ptr [offset _kindmsg+4*10+00],offset _msg_wiseman
   mov word ptr [offset _kindxl+2*10],0010
   mov word ptr [offset _kindyl+2*10],0018
   mov [offset _kindname+4*10+02],DS
   mov word ptr [offset _kindname+4*10],offset Y2a170ea6
   mov word ptr [offset _kindflags+2*10],0040
   mov word ptr [offset _kindtable+2*10],000B
   mov word ptr [offset _kindscore+2*10],0000
   mov word ptr [offset _kindmsg+4*11+02],segment _msg_fatso
   mov word ptr [offset _kindmsg+4*11+00],offset _msg_fatso
   mov word ptr [offset _kindxl+2*11],0014
   mov word ptr [offset _kindyl+2*11],001C
   mov [offset _kindname+4*11+02],DS
   mov word ptr [offset _kindname+4*11],offset Y2a170eae
   mov word ptr [offset _kindflags+2*11],0480
   mov word ptr [offset _kindtable+2*11],002C
   mov word ptr [offset _kindscore+2*11],000C
   mov word ptr [offset _kindmsg+4*12+02],segment _msg_fireball
   mov word ptr [offset _kindmsg+4*12+00],offset _msg_fireball
   mov word ptr [offset _kindxl+2*12],0010
   mov word ptr [offset _kindyl+2*12],0010
   mov [offset _kindname+4*12+02],DS
   mov word ptr [offset _kindname+4*12],offset Y2a170eb4
   mov word ptr [offset _kindflags+2*12],0000
   mov word ptr [offset _kindtable+2*12],001A
   mov word ptr [offset _kindscore+2*12],0000
   mov word ptr [offset _kindmsg+4*13+02],segment _msg_cloud
   mov word ptr [offset _kindmsg+4*13+00],offset _msg_cloud
   mov word ptr [offset _kindxl+2*13],0010
   mov word ptr [offset _kindyl+2*13],0010
   mov [offset _kindname+4*13+02],DS
   mov word ptr [offset _kindname+4*13],offset Y2a170ebd
   mov word ptr [offset _kindflags+2*13],0000
   mov word ptr [offset _kindtable+2*13],000A
   mov word ptr [offset _kindscore+2*13],0000
   mov word ptr [offset _kindmsg+4*14+02],segment _msg_text6
   mov word ptr [offset _kindmsg+4*14+00],offset _msg_text6
   mov word ptr [offset _kindxl+2*14],0006
   mov word ptr [offset _kindyl+2*14],0007
   mov [offset _kindname+4*14+02],DS
   mov word ptr [offset _kindname+4*14],offset Y2a170ec3
   mov word ptr [offset _kindflags+2*14],0040
   mov word ptr [offset _kindtable+2*14],0000
   mov word ptr [offset _kindscore+2*14],0000
   mov word ptr [offset _kindmsg+4*15+02],segment _msg_text8
   mov word ptr [offset _kindmsg+4*15+00],offset _msg_text8
   mov word ptr [offset _kindxl+2*15],0008
   mov word ptr [offset _kindyl+2*15],0008
   mov [offset _kindname+4*15+02],DS
   mov word ptr [offset _kindname+4*15],offset Y2a170ec9
   mov word ptr [offset _kindflags+2*15],0040
   mov word ptr [offset _kindtable+2*15],0000
   mov word ptr [offset _kindscore+2*15],0000
   mov word ptr [offset _kindmsg+4*16+02],segment _msg_frog
   mov word ptr [offset _kindmsg+4*16+00],offset _msg_frog
   mov word ptr [offset _kindxl+2*16],000E
   mov word ptr [offset _kindyl+2*16],000A
   mov [offset _kindname+4*16+02],DS
   mov word ptr [offset _kindname+4*16],offset Y2a170ecf
   mov word ptr [offset _kindflags+2*16],0480
   mov word ptr [offset _kindtable+2*16],003F
   mov word ptr [offset _kindscore+2*16],000F
   mov word ptr [offset _kindmsg+4*17+02],segment _msg_tiny
   mov word ptr [offset _kindmsg+4*17+00],offset _msg_tiny
   mov word ptr [offset _kindxl+2*17],0004
   mov word ptr [offset _kindyl+2*17],000A
   mov [offset _kindname+4*17+02],DS
   mov word ptr [offset _kindname+4*17],offset Y2a170ed4
   mov word ptr [offset _kindflags+2*17],0008
   mov word ptr [offset _kindtable+2*17],0010
   mov word ptr [offset _kindscore+2*17],0000
   mov word ptr [offset _kindmsg+4*18+02],segment _msg_door
   mov word ptr [offset _kindmsg+4*18+00],offset _msg_door
   mov word ptr [offset _kindxl+2*18],0010
   mov word ptr [offset _kindyl+2*18],0018
   mov [offset _kindname+4*18+02],DS
   mov word ptr [offset _kindname+4*18],offset Y2a170ed9
   mov word ptr [offset _kindflags+2*18],0100
   mov word ptr [offset _kindtable+2*18],0000
   mov word ptr [offset _kindscore+2*18],0000
   mov word ptr [offset _kindmsg+4*19+02],segment _msg_falldoor
   mov word ptr [offset _kindmsg+4*19+00],offset _msg_falldoor
   mov word ptr [offset _kindxl+2*19],0010
   mov word ptr [offset _kindyl+2*19],0010
   mov [offset _kindname+4*19+02],DS
   mov word ptr [offset _kindname+4*19],offset Y2a170ede
   mov word ptr [offset _kindflags+2*19],0100
   mov word ptr [offset _kindtable+2*19],000E
   mov word ptr [offset _kindscore+2*19],0000
   mov word ptr [offset _kindmsg+4*1a+02],segment _msg_bridger
   mov word ptr [offset _kindmsg+4*1a+00],offset _msg_bridger
   mov word ptr [offset _kindxl+2*1a],0000
   mov word ptr [offset _kindyl+2*1a],0000
   mov [offset _kindname+4*1a+02],DS
   mov word ptr [offset _kindname+4*1a],offset Y2a170ee7
   mov word ptr [offset _kindflags+2*1a],0100
   mov word ptr [offset _kindtable+2*1a],0000
   mov word ptr [offset _kindscore+2*1a],0000
   mov word ptr [offset _kindmsg+4*1b+02],segment _msg_score
   mov word ptr [offset _kindmsg+4*1b+00],offset _msg_score
   mov word ptr [offset _kindxl+2*1b],0004
   mov word ptr [offset _kindyl+2*1b],0005
   mov [offset _kindname+4*1b+02],DS
   mov word ptr [offset _kindname+4*1b],offset Y2a170eef
   mov word ptr [offset _kindflags+2*1b],0000
   mov word ptr [offset _kindtable+2*1b],0000
   mov word ptr [offset _kindscore+2*1b],0000
   mov word ptr [offset _kindmsg+4*1c+02],segment _msg_token
   mov word ptr [offset _kindmsg+4*1c+00],offset _msg_token
   mov word ptr [offset _kindxl+2*1c],0010
   mov word ptr [offset _kindyl+2*1c],0010
   mov [offset _kindname+4*1c+02],DS
   mov word ptr [offset _kindname+4*1c],offset Y2a170ef5
   mov word ptr [offset _kindflags+2*1c],0008
   mov word ptr [offset _kindtable+2*1c],0000
   mov word ptr [offset _kindscore+2*1c],0000
   mov word ptr [offset _kindmsg+4*1d+02],segment _msg_ant
   mov word ptr [offset _kindmsg+4*1d+00],offset _msg_ant
   mov word ptr [offset _kindxl+2*1d],0020
   mov word ptr [offset _kindyl+2*1d],0010
   mov [offset _kindname+4*1d+02],DS
   mov word ptr [offset _kindname+4*1d],offset Y2a170efb
   mov word ptr [offset _kindflags+2*1d],0480
   mov word ptr [offset _kindtable+2*1d],000A
   mov word ptr [offset _kindscore+2*1d],0006
   mov word ptr [offset _kindmsg+4*1e+02],segment _msg_phoenix
   mov word ptr [offset _kindmsg+4*1e+00],offset _msg_phoenix
   mov word ptr [offset _kindxl+2*1e],0010
   mov word ptr [offset _kindyl+2*1e],0010
   mov [offset _kindname+4*1e+02],DS
   mov word ptr [offset _kindname+4*1e],offset Y2a170eff
   mov word ptr [offset _kindflags+2*1e],0480
   mov word ptr [offset _kindtable+2*1e],000B
   mov word ptr [offset _kindscore+2*1e],0004
   mov word ptr [offset _kindmsg+4*1f+02],segment _msg_fire
   mov word ptr [offset _kindmsg+4*1f+00],offset _msg_fire
   mov word ptr [offset _kindxl+2*1f],0010
   mov word ptr [offset _kindyl+2*1f],0020
   mov [offset _kindname+4*1f+02],DS
   mov word ptr [offset _kindname+4*1f],offset Y2a170f07
   mov word ptr [offset _kindflags+2*1f],0000
   mov word ptr [offset _kindtable+2*1f],000C
   mov word ptr [offset _kindscore+2*1f],0000
   mov word ptr [offset _kindmsg+4*20+02],segment _msg_switch
   mov word ptr [offset _kindmsg+4*20+00],offset _msg_switch
   mov word ptr [offset _kindxl+2*20],0010
   mov word ptr [offset _kindyl+2*20],0010
   mov [offset _kindname+4*20+02],DS
   mov word ptr [offset _kindname+4*20],offset Y2a170f0c
   mov word ptr [offset _kindflags+2*20],0008
   mov word ptr [offset _kindtable+2*20],003C
   mov word ptr [offset _kindscore+2*20],0000
   mov word ptr [offset _kindmsg+4*21+02],segment _msg_gem
   mov word ptr [offset _kindmsg+4*21+00],offset _msg_gem
   mov word ptr [offset _kindxl+2*21],0010
   mov word ptr [offset _kindyl+2*21],0010
   mov [offset _kindname+4*21+02],DS
   mov word ptr [offset _kindname+4*21],offset Y2a170f13
   mov word ptr [offset _kindflags+2*21],0000
   mov word ptr [offset _kindtable+2*21],0009
   mov word ptr [offset _kindscore+2*21],0017
   mov word ptr [offset _kindmsg+4*22+02],segment _msg_txtmsg
   mov word ptr [offset _kindmsg+4*22+00],offset _msg_txtmsg
   mov word ptr [offset _kindxl+2*22],0010
   mov word ptr [offset _kindyl+2*22],0010
   mov [offset _kindname+4*22+02],DS
   mov word ptr [offset _kindname+4*22],offset Y2a170f17
   mov word ptr [offset _kindflags+2*22],0008
   mov word ptr [offset _kindtable+2*22],000E
   mov word ptr [offset _kindscore+2*22],0000
   mov word ptr [offset _kindmsg+4*23+02],segment _msg_boulder
   mov word ptr [offset _kindmsg+4*23+00],offset _msg_boulder
   mov word ptr [offset _kindxl+2*23],0010
   mov word ptr [offset _kindyl+2*23],0010
   mov [offset _kindname+4*23+02],DS
   mov word ptr [offset _kindname+4*23],offset Y2a170f1e
   mov word ptr [offset _kindflags+2*23],0000
   mov word ptr [offset _kindtable+2*23],0000
   mov word ptr [offset _kindscore+2*23],0000
   mov word ptr [offset _kindmsg+4*24+02],segment _msg_expl1
   mov word ptr [offset _kindmsg+4*24+00],offset _msg_expl1
   mov word ptr [offset _kindxl+2*24],0010
   mov word ptr [offset _kindyl+2*24],0020
   mov [offset _kindname+4*24+02],DS
   mov word ptr [offset _kindname+4*24],offset Y2a170f26
   mov word ptr [offset _kindflags+2*24],0000
   mov word ptr [offset _kindtable+2*24],002E
   mov word ptr [offset _kindscore+2*24],0000
   mov word ptr [offset _kindmsg+4*25+02],segment _msg_expl2
   mov word ptr [offset _kindmsg+4*25+00],offset _msg_expl2
   mov word ptr [offset _kindxl+2*25],0010
   mov word ptr [offset _kindyl+2*25],0020
   mov [offset _kindname+4*25+02],DS
   mov word ptr [offset _kindname+4*25],offset Y2a170f2c
   mov word ptr [offset _kindflags+2*25],0000
   mov word ptr [offset _kindtable+2*25],000E
   mov word ptr [offset _kindscore+2*25],0000
   mov word ptr [offset _kindmsg+4*26+02],segment _msg_stalag
   mov word ptr [offset _kindmsg+4*26+00],offset _msg_stalag
   mov word ptr [offset _kindxl+2*26],0010
   mov word ptr [offset _kindyl+2*26],0010
   mov [offset _kindname+4*26+02],DS
   mov word ptr [offset _kindname+4*26],offset Y2a170f32
   mov word ptr [offset _kindflags+2*26],0100
   mov word ptr [offset _kindtable+2*26],0000
   mov word ptr [offset _kindscore+2*26],0000
   mov word ptr [offset _kindmsg+4*27+02],segment _msg_snake
   mov word ptr [offset _kindmsg+4*27+00],offset _msg_snake
   mov word ptr [offset _kindxl+2*27],0038
   mov word ptr [offset _kindyl+2*27],0010
   mov [offset _kindname+4*27+02],DS
   mov word ptr [offset _kindname+4*27],offset Y2a170f39
   mov word ptr [offset _kindflags+2*27],0400
   mov word ptr [offset _kindtable+2*27],000F
   mov word ptr [offset _kindscore+2*27],0023
   mov word ptr [offset _kindmsg+4*28+02],segment _msg_searock
   mov word ptr [offset _kindmsg+4*28+00],offset _msg_searock
   mov word ptr [offset _kindxl+2*28],0010
   mov word ptr [offset _kindyl+2*28],0010
   mov [offset _kindname+4*28+02],DS
   mov word ptr [offset _kindname+4*28],offset Y2a170f3f
   mov word ptr [offset _kindflags+2*28],0000
   mov word ptr [offset _kindtable+2*28],000E
   mov word ptr [offset _kindscore+2*28],0000
   mov word ptr [offset _kindmsg+4*29+02],segment _msg_boll
   mov word ptr [offset _kindmsg+4*29+00],offset _msg_boll
   mov word ptr [offset _kindxl+2*29],000E
   mov word ptr [offset _kindyl+2*29],000E
   mov [offset _kindname+4*29+02],DS
   mov word ptr [offset _kindname+4*29],offset Y2a170f47
   mov word ptr [offset _kindflags+2*29],0000
   mov word ptr [offset _kindtable+2*29],001F
   mov word ptr [offset _kindscore+2*29],0000
   mov word ptr [offset _kindmsg+4*2a+02],segment _msg_mega
   mov word ptr [offset _kindmsg+4*2a+00],offset _msg_mega
   mov word ptr [offset _kindxl+2*2a],0014
   mov word ptr [offset _kindyl+2*2a],0018
   mov [offset _kindname+4*2a+02],DS
   mov word ptr [offset _kindname+4*2a],offset Y2a170f4c
   mov word ptr [offset _kindflags+2*2a],0100
   mov word ptr [offset _kindtable+2*2a],0021
   mov word ptr [offset _kindscore+2*2a],0000
   mov word ptr [offset _kindmsg+4*2b+02],segment _msg_bat
   mov word ptr [offset _kindmsg+4*2b+00],offset _msg_bat
   mov word ptr [offset _kindxl+2*2b],001A
   mov word ptr [offset _kindyl+2*2b],0020
   mov [offset _kindname+4*2b+02],DS
   mov word ptr [offset _kindname+4*2b],offset Y2a170f51
   mov word ptr [offset _kindflags+2*2b],0480
   mov word ptr [offset _kindtable+2*2b],0023
   mov word ptr [offset _kindscore+2*2b],0004
   mov word ptr [offset _kindmsg+4*2c+02],segment _msg_knight
   mov word ptr [offset _kindmsg+4*2c+00],offset _msg_knight
   mov word ptr [offset _kindxl+2*2c],0020
   mov word ptr [offset _kindyl+2*2c],0020
   mov [offset _kindname+4*2c+02],DS
   mov word ptr [offset _kindname+4*2c],offset Y2a170f55
   mov word ptr [offset _kindflags+2*2c],0100
   mov word ptr [offset _kindtable+2*2c],0024
   mov word ptr [offset _kindscore+2*2c],0000
   mov word ptr [offset _kindmsg+4*2d+02],segment _msg_beenest
   mov word ptr [offset _kindmsg+4*2d+00],offset _msg_beenest
   mov word ptr [offset _kindxl+2*2d],0010
   mov word ptr [offset _kindyl+2*2d],0010
   mov [offset _kindname+4*2d+02],DS
   mov word ptr [offset _kindname+4*2d],offset Y2a170f5c
   mov word ptr [offset _kindflags+2*2d],0000
   mov word ptr [offset _kindtable+2*2d],0025
   mov word ptr [offset _kindscore+2*2d],000B
   mov word ptr [offset _kindmsg+4*2e+02],segment _msg_beeswarm
   mov word ptr [offset _kindmsg+4*2e+00],offset _msg_beeswarm
   mov word ptr [offset _kindxl+2*2e],0010
   mov word ptr [offset _kindyl+2*2e],0010
   mov [offset _kindname+4*2e+02],DS
   mov word ptr [offset _kindname+4*2e],offset Y2a170f64
   mov word ptr [offset _kindflags+2*2e],0000
   mov word ptr [offset _kindtable+2*2e],0025
   mov word ptr [offset _kindscore+2*2e],0000
   mov word ptr [offset _kindmsg+4*2f+02],segment _msg_crab
   mov word ptr [offset _kindmsg+4*2f+00],offset _msg_crab
   mov word ptr [offset _kindxl+2*2f],0010
   mov word ptr [offset _kindyl+2*2f],0010
   mov [offset _kindname+4*2f+02],DS
   mov word ptr [offset _kindname+4*2f],offset Y2a170f6d
   mov word ptr [offset _kindflags+2*2f],0480
   mov word ptr [offset _kindtable+2*2f],0026
   mov word ptr [offset _kindscore+2*2f],0002
   mov word ptr [offset _kindmsg+4*30+02],segment _msg_croc
   mov word ptr [offset _kindmsg+4*30+00],offset _msg_croc
   mov word ptr [offset _kindxl+2*30],0040
   mov word ptr [offset _kindyl+2*30],0008
   mov [offset _kindname+4*30+02],DS
   mov word ptr [offset _kindname+4*30],offset Y2a170f72
   mov word ptr [offset _kindflags+2*30],0480
   mov word ptr [offset _kindtable+2*30],0027
   mov word ptr [offset _kindscore+2*30],0003
   mov word ptr [offset _kindmsg+4*31+02],segment _msg_epic
   mov word ptr [offset _kindmsg+4*31+00],offset _msg_epic
   mov word ptr [offset _kindxl+2*31],0020
   mov word ptr [offset _kindyl+2*31],0010
   mov [offset _kindname+4*31+02],DS
   mov word ptr [offset _kindname+4*31],offset Y2a170f77
   mov word ptr [offset _kindflags+2*31],0000
   mov word ptr [offset _kindtable+2*31],0028
   mov word ptr [offset _kindscore+2*31],0023
   mov word ptr [offset _kindmsg+4*32+02],segment _msg_spinblad
   mov word ptr [offset _kindmsg+4*32+00],offset _msg_spinblad
   mov word ptr [offset _kindxl+2*32],0010
   mov word ptr [offset _kindyl+2*32],0010
   mov [offset _kindname+4*32+02],DS
   mov word ptr [offset _kindname+4*32],offset Y2a170f7c
   mov word ptr [offset _kindflags+2*32],4008
   mov word ptr [offset _kindtable+2*32],002D
   mov word ptr [offset _kindscore+2*32],0000
   mov word ptr [offset _kindmsg+4*33+02],segment _msg_skull
   mov word ptr [offset _kindmsg+4*33+00],offset _msg_skull
   mov word ptr [offset _kindxl+2*33],0016
   mov word ptr [offset _kindyl+2*33],001A
   mov [offset _kindname+4*33+02],DS
   mov word ptr [offset _kindname+4*33],offset Y2a170f85
   mov word ptr [offset _kindflags+2*33],0100
   mov word ptr [offset _kindtable+2*33],002F
   mov word ptr [offset _kindscore+2*33],0000
   mov word ptr [offset _kindmsg+4*34+02],segment _msg_button
   mov word ptr [offset _kindmsg+4*34+00],offset _msg_button
   mov word ptr [offset _kindxl+2*34],0010
   mov word ptr [offset _kindyl+2*34],0010
   mov [offset _kindname+4*34+02],DS
   mov word ptr [offset _kindname+4*34],offset Y2a170f8b
   mov word ptr [offset _kindflags+2*34],0008
   mov word ptr [offset _kindtable+2*34],0031
   mov word ptr [offset _kindscore+2*34],0000
   mov word ptr [offset _kindmsg+4*35+02],segment _msg_pac
   mov word ptr [offset _kindmsg+4*35+00],offset _msg_pac
   mov word ptr [offset _kindxl+2*35],0010
   mov word ptr [offset _kindyl+2*35],0010
   mov [offset _kindname+4*35+02],DS
   mov word ptr [offset _kindname+4*35],offset Y2a170f92
   mov word ptr [offset _kindflags+2*35],0400
   mov word ptr [offset _kindtable+2*35],0032
   mov word ptr [offset _kindscore+2*35],0000
   mov word ptr [offset _kindmsg+4*36+02],segment _msg_jillfish
   mov word ptr [offset _kindmsg+4*36+00],offset _msg_jillfish
   mov word ptr [offset _kindxl+2*36],0018
   mov word ptr [offset _kindyl+2*36],0010
   mov [offset _kindname+4*36+02],DS
   mov word ptr [offset _kindname+4*36],offset Y2a170f96
   mov word ptr [offset _kindflags+2*36],0008
   mov word ptr [offset _kindtable+2*36],0033
   mov word ptr [offset _kindscore+2*36],0000
   mov word ptr [offset _kindmsg+4*37+02],segment _msg_jillspider
   mov word ptr [offset _kindmsg+4*37+00],offset _msg_jillspider
   mov word ptr [offset _kindxl+2*37],0010
   mov word ptr [offset _kindyl+2*37],0010
   mov [offset _kindname+4*37+02],DS
   mov word ptr [offset _kindname+4*37],offset Y2a170f9f
   mov word ptr [offset _kindflags+2*37],0008
   mov word ptr [offset _kindtable+2*37],0000
   mov word ptr [offset _kindscore+2*37],0000
   mov word ptr [offset _kindmsg+4*38+02],segment _msg_jillbird
   mov word ptr [offset _kindmsg+4*38+00],offset _msg_jillbird
   mov word ptr [offset _kindxl+2*38],0010
   mov word ptr [offset _kindyl+2*38],0010
   mov [offset _kindname+4*38+02],DS
   mov word ptr [offset _kindname+4*38],offset Y2a170faa
   mov word ptr [offset _kindflags+2*38],0008
   mov word ptr [offset _kindtable+2*38],000B
   mov word ptr [offset _kindscore+2*38],0000
   mov word ptr [offset _kindmsg+4*39+02],segment _msg_jillfrog
   mov word ptr [offset _kindmsg+4*39+00],offset _msg_jillfrog
   mov word ptr [offset _kindxl+2*39],000E
   mov word ptr [offset _kindyl+2*39],000A
   mov [offset _kindname+4*39+02],DS
   mov word ptr [offset _kindname+4*39],offset Y2a170fb3
   mov word ptr [offset _kindflags+2*39],0008
   mov word ptr [offset _kindtable+2*39],003F
   mov word ptr [offset _kindscore+2*39],0000
   mov word ptr [offset _kindmsg+4*3a+02],segment _msg_bubble
   mov word ptr [offset _kindmsg+4*3a+00],offset _msg_bubble
   mov word ptr [offset _kindxl+2*3a],0008
   mov word ptr [offset _kindyl+2*3a],0008
   mov [offset _kindname+4*3a+02],DS
   mov word ptr [offset _kindname+4*3a],offset Y2a170fbc
   mov word ptr [offset _kindflags+2*3a],0000
   mov word ptr [offset _kindtable+2*3a],0033
   mov word ptr [offset _kindscore+2*3a],0000
   mov word ptr [offset _kindmsg+4*3b+02],segment _msg_jellyfish
   mov word ptr [offset _kindmsg+4*3b+00],offset _msg_jellyfish
   mov word ptr [offset _kindxl+2*3b],0010
   mov word ptr [offset _kindyl+2*3b],0018
   mov [offset _kindname+4*3b+02],DS
   mov word ptr [offset _kindname+4*3b],offset Y2a170fc3
   mov word ptr [offset _kindflags+2*3b],0000
   mov word ptr [offset _kindtable+2*3b],0033
   mov word ptr [offset _kindscore+2*3b],0000
   mov word ptr [offset _kindmsg+4*3c+02],segment _msg_badfish
   mov word ptr [offset _kindmsg+4*3c+00],offset _msg_badfish
   mov word ptr [offset _kindxl+2*3c],001C
   mov word ptr [offset _kindyl+2*3c],0010
   mov [offset _kindname+4*3c+02],DS
   mov word ptr [offset _kindname+4*3c],offset Y2a170fcd
   mov word ptr [offset _kindflags+2*3c],0000
   mov word ptr [offset _kindtable+2*3c],0033
   mov word ptr [offset _kindscore+2*3c],0007
   mov word ptr [offset _kindmsg+4*3d+02],segment _msg_elev
   mov word ptr [offset _kindmsg+4*3d+00],offset _msg_elev
   mov word ptr [offset _kindxl+2*3d],0010
   mov word ptr [offset _kindyl+2*3d],0010
   mov [offset _kindname+4*3d+02],DS
   mov word ptr [offset _kindname+4*3d],offset Y2a170fd5
   mov word ptr [offset _kindflags+2*3d],0100
   mov word ptr [offset _kindtable+2*3d],0000
   mov word ptr [offset _kindscore+2*3d],0000
   mov word ptr [offset _kindmsg+4*3e+02],segment _msg_firebullet
   mov word ptr [offset _kindmsg+4*3e+00],offset _msg_firebullet
   mov word ptr [offset _kindxl+2*3e],0010
   mov word ptr [offset _kindyl+2*3e],0010
   mov [offset _kindname+4*3e+02],DS
   mov word ptr [offset _kindname+4*3e],offset Y2a170fda
   mov word ptr [offset _kindflags+2*3e],4008
   mov word ptr [offset _kindtable+2*3e],001A
   mov word ptr [offset _kindscore+2*3e],0000
   mov word ptr [offset _kindmsg+4*3f+02],segment _msg_fishbullet
   mov word ptr [offset _kindmsg+4*3f+00],offset _msg_fishbullet
   mov word ptr [offset _kindxl+2*3f],000C
   mov word ptr [offset _kindyl+2*3f],0005
   mov [offset _kindname+4*3f+02],DS
   mov word ptr [offset _kindname+4*3f],offset Y2a170fe5
   mov word ptr [offset _kindflags+2*3f],4008
   mov word ptr [offset _kindtable+2*3f],0033
   mov word ptr [offset _kindscore+2*3f],0000
   mov word ptr [offset _kindmsg+4*40+02],segment _msg_eyes
   mov word ptr [offset _kindmsg+4*40+00],offset _msg_eyes
   mov word ptr [offset _kindxl+2*40],0010
   mov word ptr [offset _kindyl+2*40],000C
   mov [offset _kindname+4*40+02],DS
   mov word ptr [offset _kindname+4*40],offset Y2a170ff0
   mov word ptr [offset _kindflags+2*40],0180
   mov word ptr [offset _kindtable+2*40],003E
   mov word ptr [offset _kindscore+2*40],0003
   mov word ptr [offset _kindmsg+4*41+02],segment _msg_vineclimb
   mov word ptr [offset _kindmsg+4*41+00],offset _msg_vineclimb
   mov word ptr [offset _kindxl+2*41],0010
   mov word ptr [offset _kindyl+2*41],0008
   mov [offset _kindname+4*41+02],DS
   mov word ptr [offset _kindname+4*41],offset Y2a170ff4
   mov word ptr [offset _kindflags+2*41],0000
   mov word ptr [offset _kindtable+2*41],003D
   mov word ptr [offset _kindscore+2*41],0000
   mov word ptr [offset _kindmsg+4*42+02],segment _msg_flag
   mov word ptr [offset _kindmsg+4*42+00],offset _msg_flag
   mov word ptr [offset _kindxl+2*42],0024
   mov word ptr [offset _kindyl+2*42],0010
   mov [offset _kindname+4*42+02],DS
   mov word ptr [offset _kindname+4*42],offset Y2a170ffe
   mov word ptr [offset _kindflags+2*42],0008
   mov word ptr [offset _kindtable+2*42],0005
   mov word ptr [offset _kindscore+2*42],0000
   mov word ptr [offset _kindmsg+4*43+02],segment _msg_mapdemo
   mov word ptr [offset _kindmsg+4*43+00],offset _msg_mapdemo
   mov word ptr [offset _kindxl+2*43],0040
   mov word ptr [offset _kindyl+2*43],0010
   mov [offset _kindname+4*43+02],DS
   mov word ptr [offset _kindname+4*43],offset Y2a171003
   mov word ptr [offset _kindflags+2*43],0000
   mov word ptr [offset _kindtable+2*43],0003
   mov word ptr [offset _kindscore+2*43],0000
   mov word ptr [offset _kindmsg+4*44+02],segment _msg_roman
   mov word ptr [offset _kindmsg+4*44+00],offset _msg_roman
   mov word ptr [offset _kindxl+2*44],0010
   mov word ptr [offset _kindyl+2*44],0020
   mov [offset _kindname+4*44+02],DS
   mov word ptr [offset _kindname+4*44],offset Y2a17100b
   mov word ptr [offset _kindflags+2*44],0480
   mov word ptr [offset _kindtable+2*44],002C
   mov word ptr [offset _kindscore+2*44],000C
ret far

_msg_null: ;; 0d8c0e0f
   push BP
   mov BP,SP
   xor AX,AX
   pop BP
ret far

_msg_apple: ;; 0d8c0e16
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c0e34
   cmp AX,0001
   jnz L0d8c0e2c
jmp near L0d8c0f01
L0d8c0e2c:
   cmp AX,0002
   jz L0d8c0e92
jmp near L0d8c0ff9
L0d8c0e34:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*01]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c0ff9
L0d8c0e92:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0d8c0ec1
   mov AX,0001
jmp near L0d8c0ec4
L0d8c0ec1:
   mov AX,FFFF
L0d8c0ec4:
   pop DX
   add DX,AX
   and DX,0007
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L0d8c0efc
   mov AX,0001
jmp near L0d8c0efe
L0d8c0efc:
   xor AX,AX
L0d8c0efe:
jmp near L0d8c0ff9
L0d8c0f01:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L0d8c0f74
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jnz L0d8c0f55
   mov AX,0019
   push AX
   mov AX,0006
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+0D]
   call far _dotextmsg
   pop CX
L0d8c0f55:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1D],0004
   push SI
   call far _killobj
   pop CX
jmp near L0d8c0ff6
L0d8c0f74:
   cmp word ptr [BP+0A],+00
   jz L0d8c0f7f
   xor AX,AX
jmp near L0d8c0ff9
L0d8c0f7f:
   cmp word ptr [offset _pl+02],+08
   jge L0d8c0f8a
   inc word ptr [offset _pl+02]
L0d8c0f8a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [offset _kindscore+2*01]
   call far _addscore
   add SP,+06
   or word ptr [offset _statmodflg],C000
   mov AX,000B
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
   push SI
   call far _killobj
   pop CX
   cmp word ptr [offset _first_apple],+00
   jz L0d8c0ff6
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y2a171011
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_apple],0000
L0d8c0ff6:
   mov AX,0001
L0d8c0ff9:
   pop SI
   pop BP
ret far

_msg_knife: ;; 0d8c0ffc
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov DI,[BP+0A]
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c1021
   cmp AX,0001
   jnz L0d8c1019
jmp near L0d8c12a8
L0d8c1019:
   cmp AX,0002
   jz L0d8c1067
jmp near L0d8c13c1
L0d8c1021:
   mov AX,[offset _kindtable+2*02]
   mov CL,08
   shl AX,CL
   mov [BP-06],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-06]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c13c1
L0d8c1067:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jg L0d8c1080
jmp near L0d8c123d
L0d8c1080:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+0E
   jg L0d8c10ac
jmp near L0d8c119f
L0d8c10ac:
   push SS
   lea AX,[BP-02]
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   call far _seekplayer
   add SP,+0A
   mov AX,[BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+08
   jle L0d8c1104
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0008
jmp near L0d8c112f
L0d8c1104:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],-08
   jg L0d8c112f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],FFF8
L0d8c112f:
   mov AX,[BP-02]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+04
   jle L0d8c1174
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0004
jmp near L0d8c119f
L0d8c1174:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-04
   jg L0d8c119f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFC
L0d8c119f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _trymove
   add SP,+06
   neg AX
   sbb AX,AX
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+40
   jle L0d8c121b
   mov AX,0001
jmp near L0d8c121d
L0d8c121b:
   xor AX,AX
L0d8c121d:
   pop DX
   or DX,AX
   jnz L0d8c1225
jmp near L0d8c13be
L0d8c1225:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],FFFF
jmp near L0d8c13be
L0d8c123d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-01
   jnz L0d8c12a3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _trymove
   add SP,+06
   or AX,AX
   jz L0d8c128b
jmp near L0d8c13be
L0d8c128b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
jmp near L0d8c13be
L0d8c12a3:
   xor AX,AX
jmp near L0d8c13c1
L0d8c12a8:
   or DI,DI
   jz L0d8c12af
jmp near L0d8c1334
L0d8c12af:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jle L0d8c12de
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+0A
   jg L0d8c12de
jmp near L0d8c13be
L0d8c12de:
   mov AX,0002
   push AX
   call far _invcount
   pop CX
   cmp AX,0003
   jl L0d8c12f0
jmp near L0d8c13be
L0d8c12f0:
   mov AX,0002
   push AX
   call far _addinv
   pop CX
   mov AX,0007
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
   push SI
   call far _killobj
   pop CX
   cmp word ptr [offset _first_knife],+00
   jnz L0d8c131a
jmp near L0d8c13be
L0d8c131a:
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y2a171028
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_knife],0000
jmp near L0d8c13be
L0d8c1334:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],0080
   jz L0d8c13be
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jle L0d8c13be
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],000F
   push DI
   call far _playerkill
   pop CX
   mov AX,000A
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L0d8c13be:
   mov AX,0001
L0d8c13c1:
   pop DI
   pop SI
   mov SP,BP
   pop BP
X0d8c13c6:
ret far
_msg_nullkind: ;; 0d8c13c7 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   pop BP
ret far

_msg_bigant: ;; 0d8c13cc
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c13ee
   cmp AX,0001
   jnz L0d8c13e3
jmp near L0d8c14cb
L0d8c13e3:
   cmp AX,0002
   jnz L0d8c13eb
jmp near L0d8c14de
L0d8c13eb:
jmp near L0d8c15a2
L0d8c13ee:
   mov DI,[offset _kindtable+2*04]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0d8c1447
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0d8c1427
   mov AX,0001
jmp near L0d8c1429
L0d8c1427:
   xor AX,AX
L0d8c1429:
   mov DX,000A
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   add DI,AX
jmp near L0d8c1491
L0d8c1447:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0d8c1477
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   add AX,0004
   add DI,AX
jmp near L0d8c1491
L0d8c1477:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,000A
   mov DX,[ES:BX+0D]
   sub AX,DX
   add DI,AX
L0d8c1491:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c15a2
L0d8c14cb:
   cmp word ptr [BP+0A],+00
   jz L0d8c14d4
jmp near L0d8c15a2
L0d8c14d4:
   push SI
   call far _hitplayer
   pop CX
jmp near L0d8c15a2
L0d8c14de:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0d8c14f7
jmp near L0d8c158c
L0d8c14f7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0004
   jle L0d8c1528
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0d8c1528:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jnz L0d8c159f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0005
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L0d8c159f
L0d8c158c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L0d8c159f:
   mov AX,0001
L0d8c15a2:
   pop DI
   pop SI
   pop BP
ret far

_msg_ant: ;; 0d8c15a6
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c15c8
   cmp AX,0001
   jnz L0d8c15bd
jmp near L0d8c16ad
L0d8c15bd:
   cmp AX,0002
   jnz L0d8c15c5
jmp near L0d8c16c0
L0d8c15c5:
jmp near L0d8c1784
L0d8c15c8:
   mov DI,[offset _kindtable+2*1d]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0d8c1621
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0d8c1601
   mov AX,0001
jmp near L0d8c1603
L0d8c1601:
   xor AX,AX
L0d8c1603:
   mov DX,0005
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   add DI,AX
jmp near L0d8c1673
L0d8c1621:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0d8c1658
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   mov DX,0005
   mul DX
   mov DX,000E
   sub DX,AX
   add DI,DX
jmp near L0d8c1673
L0d8c1658:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   mov DX,0005
   mul DX
   dec AX
   add DI,AX
L0d8c1673:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c1784
L0d8c16ad:
   cmp word ptr [BP+0A],+00
   jz L0d8c16b6
jmp near L0d8c1784
L0d8c16b6:
   push SI
   call far _hitplayer
   pop CX
jmp near L0d8c1784
L0d8c16c0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0d8c16d9
jmp near L0d8c176e
L0d8c16d9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0003
   jle L0d8c170a
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0d8c170a:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jnz L0d8c1781
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L0d8c1781
L0d8c176e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L0d8c1781:
   mov AX,0001
L0d8c1784:
   pop DI
   pop SI
   pop BP
ret far

_msg_fly: ;; 0d8c1788
   push BP
   mov BP,SP
   sub SP,+1C
   push SI
   push DI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-18]
   push AX
   push DS
   mov AX,offset Y2a170df2
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-10]
   push AX
   push DS
   mov AX,offset Y2a170dfa
   push AX
   mov CX,0010
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c17d1
   cmp AX,0001
   jnz L0d8c17c6
jmp near L0d8c1856
L0d8c17c6:
   cmp AX,0002
   jnz L0d8c17ce
jmp near L0d8c18a9
L0d8c17ce:
jmp near L0d8c1982
L0d8c17d1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   and BX,0003
   shl BX,1
   lea AX,[BP-18]
   add BX,AX
   mov DI,[SS:BX]
   mov AX,[offset _kindtable+2*05]
   mov CL,08
   shl AX,CL
   add DI,AX
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0d8c1817
   mov AX,0004
jmp near L0d8c1819
L0d8c1817:
   xor AX,AX
L0d8c1819:
   pop DI
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c1982
L0d8c1856:
   cmp word ptr [BP+0A],+00
   jz L0d8c185f
jmp near L0d8c1982
L0d8c185f:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   call far _explode1
   add SP,+06
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   call far _p_ouch
   pop CX
   pop CX
   push SI
   call far _killobj
   pop CX
jmp near L0d8c1982
L0d8c18a9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   mov [BP-1C],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-10]
   add BX,AX
   mov AX,[SS:BX]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+03]
   mov [BP-1A],AX
   push AX
   push [BP-1C]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L0d8c1953
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,000F
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L0d8c1953:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,0001
L0d8c1982:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_phoenix: ;; 0d8c1988
   push BP
   mov BP,SP
   sub SP,+24
   push SI
   push DI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,0E0A
   push AX
   mov CX,0010
   call far SCOPY@
   push SS
   lea AX,[BP-10]
   push AX
   push DS
   mov AX,0E1A
   push AX
   mov CX,0010
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c19d1
   cmp AX,0001
   jnz L0d8c19c6
jmp near L0d8c1a72
L0d8c19c6:
   cmp AX,0002
   jnz L0d8c19ce
jmp near L0d8c1ace
L0d8c19ce:
jmp near L0d8c1c2c
L0d8c19d1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-20]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[offset _kindtable+2*1e]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0d8c1a2e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-10]
   add BX,AX
   mov AX,[SS:BX]
jmp near L0d8c1a30
L0d8c1a2e:
   xor AX,AX
L0d8c1a30:
   pop DX
   add DX,AX
   mov [BP-24],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-24]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c1c2c
L0d8c1a72:
   cmp word ptr [BP+0A],+00
   jz L0d8c1a7b
jmp near L0d8c1c2c
L0d8c1a7b:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   call far _explode1
   add SP,+06
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   call far _p_ouch
   pop CX
   pop CX
   xor AX,AX
   push AX
   call far _explode2
   pop CX
   push SI
   call far _killobj
   pop CX
jmp near L0d8c1c2c
L0d8c1ace:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L0d8c1b0a
   xor AX,AX
jmp near L0d8c1c2c
L0d8c1b0a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+05]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-22],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0006
   jz L0d8c1b78
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+07
   jle L0d8c1b8d
L0d8c1b78:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0d8c1b8d:
   push [BP-22]
   push DI
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jz L0d8c1bf0
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+05]
   mov AX,0001
   push AX
   push [BP-22]
   push DI
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L0d8c1c29
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0006
jmp near L0d8c1c29
L0d8c1bf0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,000F
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L0d8c1c29:
   mov AX,0001
L0d8c1c2c:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_inchworm: ;; 0d8c1c32
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c1c54
   cmp AX,0001
   jnz L0d8c1c49
jmp near L0d8c1ccf
L0d8c1c49:
   cmp AX,0002
   jnz L0d8c1c51
jmp near L0d8c1ce2
L0d8c1c51:
jmp near L0d8c1d8d
L0d8c1c54:
   mov DI,[offset _kindtable+2*09]
   mov CL,08
   shl DI,CL
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0d8c1c78
   mov AX,0001
jmp near L0d8c1c7a
L0d8c1c78:
   xor AX,AX
L0d8c1c7a:
   mov DX,0003
   mul DX
   pop DI
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+11]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c1d8d
L0d8c1ccf:
   cmp word ptr [BP+0A],+00
   jz L0d8c1cd8
jmp near L0d8c1d8d
L0d8c1cd8:
   push SI
   call far _hitplayer
   pop CX
jmp near L0d8c1d8d
L0d8c1ce2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jnz L0d8c1d8b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   xor word ptr [ES:BX+11],0001
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jnz L0d8c1d86
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0d8c1d86:
   mov AX,0001
jmp near L0d8c1d8d
L0d8c1d8b:
   xor AX,AX
L0d8c1d8d:
   pop DI
   pop SI
   pop BP
ret far

_msg_zapper: ;; 0d8c1d91
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c1dad
   cmp AX,0001
   jz L0d8c1e05
   cmp AX,0002
   jz L0d8c1e16
jmp near L0d8c1e4a
L0d8c1dad:
   mov DI,[offset _kindtable+2*0a]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+13]
   add DI,4000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c1e4a
L0d8c1e05:
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   call far _p_ouch
   pop CX
   pop CX
jmp near L0d8c1e4a
L0d8c1e16:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0004
   jle L0d8c1e47
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0d8c1e47:
   mov AX,0001
L0d8c1e4a:
   pop DI
   pop SI
   pop BP
ret far

_msg_bobslug: ;; 0d8c1e4e
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c1e70
   cmp AX,0001
   jnz L0d8c1e65
jmp near L0d8c1ef9
L0d8c1e65:
   cmp AX,0002
   jnz L0d8c1e6d
jmp near L0d8c1f0c
L0d8c1e6d:
jmp near L0d8c1fe0
L0d8c1e70:
   mov DI,[offset _kindtable+2*0b]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0d8c1ea5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   add DI,AX
jmp near L0d8c1ebf
L0d8c1ea5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,0006
   mov DX,[ES:BX+0D]
   sub AX,DX
   add DI,AX
L0d8c1ebf:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c1fe0
L0d8c1ef9:
   cmp word ptr [BP+0A],+00
   jz L0d8c1f02
jmp near L0d8c1fe0
L0d8c1f02:
   push SI
   call far _hitplayer
   pop CX
jmp near L0d8c1fe0
L0d8c1f0c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0d8c1f60
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jz L0d8c1f48
jmp near L0d8c1fdd
L0d8c1f48:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
jmp near L0d8c1fdd
L0d8c1f60:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   xor word ptr [ES:BX+11],0001
   mov AX,[ES:BX+11]
   test AX,0001
   jz L0d8c1f82
   xor AX,AX
jmp near L0d8c1fe0
L0d8c1f82:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,[ES:BX+0D]
   cmp AX,0006
   jl L0d8c1fdd
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0d8c1fdd:
   mov AX,0001
L0d8c1fe0:
   pop DI
   pop SI
   pop BP
ret far

_msg_checkpt: ;; 0d8c1fe4
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c2008
   cmp AX,0001
   jnz L0d8c1ffd
jmp near L0d8c216d
L0d8c1ffd:
   cmp AX,0002
   jnz L0d8c2005
jmp near L0d8c2098
L0d8c2005:
jmp near L0d8c22c7
L0d8c2008:
   cmp word ptr [offset _designflag],+00
   jnz L0d8c2012
jmp near L0d8c22c7
L0d8c2012:
   mov AX,FFFF
   push AX
   mov AX,0005
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _fontcolor
   add SP,+08
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _itoa
   add SP,+08
   push SS
   lea AX,[BP-10]
   push AX
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0004
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _wprint
   add SP,+0E
jmp near L0d8c22c7
L0d8c2098:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   cmp AX,[offset _objs+01]
   jg L0d8c20c9
jmp near L0d8c2197
L0d8c20c9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[offset _objs+01]
   add DX,[offset _objs+09]
   cmp AX,DX
   jl L0d8c20eb
jmp near L0d8c2197
L0d8c20eb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   cmp AX,[offset _objs+03]
   jg L0d8c211c
jmp near L0d8c2197
L0d8c211c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[offset _objs+03]
   add DX,[offset _objs+0b]
   cmp AX,DX
   jge L0d8c2197
   mov AX,[offset _objs+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,[offset _objs+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
jmp near L0d8c2197
L0d8c216d:
   cmp word ptr [BP+0A],+00
   jz L0d8c2176
jmp near L0d8c22c7
L0d8c2176:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+03
   jnz L0d8c219c
   call far _macrecend
   mov word ptr [offset _gameover],0002
L0d8c2197:
   xor AX,AX
jmp near L0d8c22c7
L0d8c219c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[offset _pl]
   jnz L0d8c21b8
jmp near L0d8c22c7
L0d8c21b8:
   cmp word ptr [offset _vocflag],+00
   jz L0d8c21c4
   mov AX,0005
jmp near L0d8c21da
L0d8c21c4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   add AX,0032
L0d8c21da:
   push AX
   mov AX,0004
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jz L0d8c2212
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov [offset _pl],AX
L0d8c2212:
   cmp byte ptr [offset _objs],17
   jnz L0d8c224c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   xor AX,AX
   push AX
   call far _moveobj
   add SP,+06
jmp near L0d8c2287
L0d8c224c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov [offset _objs+01],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,FFF0
   mov [offset _objs+03],AX
   mov word ptr [offset _objs+0d],0004
   mov word ptr [offset _objs+11],0000
L0d8c2287:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L0d8c22c4
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push DS
   mov AX,offset _newlevel
   push AX
   call far _strcpy
   add SP,+08
L0d8c22c4:
   mov AX,0001
L0d8c22c7:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_paul: ;; 0d8c22cc
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c22e7
   cmp AX,0001
   jz L0d8c233b
   cmp AX,0002
   jz L0d8c233b
jmp near L0d8c233d
L0d8c22e7:
   mov DI,[offset _kindtable+2*0d]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+0D]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c233d
L0d8c233b:
   xor AX,AX
L0d8c233d:
   pop DI
   pop SI
   pop BP
ret far

_msg_wiseman: ;; 0d8c2341
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c2363
   cmp AX,0001
   jnz L0d8c2358
jmp near L0d8c249d
L0d8c2358:
   cmp AX,0002
   jnz L0d8c2360
jmp near L0d8c23de
L0d8c2360:
jmp near L0d8c24f3
L0d8c2363:
   mov DI,[offset _kindtable+2*10]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0d8c2386
   mov AX,0001
jmp near L0d8c2388
L0d8c2386:
   xor AX,AX
L0d8c2388:
   mov DX,0005
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0D]
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c24f3
L0d8c23de:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jz L0d8c23f7
jmp near L0d8c248a
L0d8c23f7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   inc AX
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0001
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jnz L0d8c2485
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0d8c2485:
   mov AX,0001
jmp near L0d8c24f3
L0d8c248a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
L0d8c249d:
   cmp word ptr [BP+0A],+00
   jnz L0d8c24f3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jnz L0d8c24dd
   mov AX,0007
   push AX
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far _putbotmsg
   add SP,+06
L0d8c24dd:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1D],0003
L0d8c24f3:
   pop DI
   pop SI
   pop BP
ret far

_msg_bridger: ;; 0d8c24f7
   push BP
   mov BP,SP
   sub SP,+0E
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-0E],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L0d8c2554
   mov AX,008C
jmp near L0d8c2557
L0d8c2554:
   mov AX,01B0
L0d8c2557:
   mov [BP-08],AX
   mov word ptr [BP-06],0000
   mov AX,[BP+08]
   cmp AX,0005
   jbe L0d8c256a
jmp near L0d8c267b
L0d8c256a:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y0d8c2573]
Y0d8c2573:	dw L0d8c257f,L0d8c267b,L0d8c267b,L0d8c260a,L0d8c25f8,L0d8c25ce
L0d8c257f:
   cmp word ptr [offset _designflag],+00
   jnz L0d8c2589
jmp near L0d8c267b
L0d8c2589:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0004
   push AX
   mov AX,0123
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c267b
L0d8c25ce:
   mov word ptr [BP-06],0001
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-0E]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-0C],AX
   mov AX,[BP-08]
   mov [BP-0A],AX
jmp near L0d8c267b
L0d8c25f8:
   mov word ptr [BP-06],0001
   mov AX,[BP-08]
   mov [BP-0C],AX
   mov word ptr [BP-0A],0000
jmp near L0d8c267b
L0d8c260a:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-0E]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-08]
   jnz L0d8c2635
   mov word ptr [BP-0A],0000
   mov AX,[BP-08]
   mov [BP-0C],AX
jmp near L0d8c2657
L0d8c2635:
   mov AX,[BP-08]
   mov [BP-0A],AX
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-0E]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-0C],AX
L0d8c2657:
   mov word ptr [BP-06],0001
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],0F
   jnz L0d8c267b
   push [BP+0A]
   call far _killobj
   pop CX
L0d8c267b:
   cmp word ptr [BP-06],+00
   jnz L0d8c2684
jmp near L0d8c276b
L0d8c2684:
   cmp word ptr [BP-0A],+00
   jz L0d8c268d
jmp near L0d8c2748
L0d8c268d:
   mov word ptr [BP-04],FFFF
jmp near L0d8c2706
L0d8c2694:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mul word ptr [BP-04]
   mov BX,AX
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   mov DX,001F
   mul DX
   push ES
   push BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   mul word ptr [BP-04]
   add AX,[BP-0E]
   shl AX,1
   pop BX
   pop ES
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-02],AX
   mov BX,AX
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov AX,[ES:BX+02]
   and AX,0003
   cmp AX,0003
   jnz L0d8c2702
   mov AX,[BP-02]
   mov [BP-0A],AX
L0d8c2702:
   add word ptr [BP-04],+02
L0d8c2706:
   cmp word ptr [BP-04],+01
   jle L0d8c2694
jmp near L0d8c2748
L0d8c270e:
   push [BP-0A]
   push [BP-0E]
   push DI
   call far _setboard
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   add [BP-0E],AX
L0d8c2748:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-0E]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0C]
   jz L0d8c270e
   mov AX,0001
jmp near L0d8c276d
L0d8c276b:
   xor AX,AX
L0d8c276d:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_key: ;; 0d8c2773
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c2792
   cmp AX,0001
   jnz L0d8c278a
jmp near L0d8c2836
L0d8c278a:
   cmp AX,0002
   jz L0d8c27e8
jmp near L0d8c2881
L0d8c2792:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   add AX,0E06
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c2881
L0d8c27e8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L0d8c2830
   mov DI,0001
jmp near L0d8c2832
L0d8c2830:
   xor DI,DI
L0d8c2832:
   mov AX,DI
jmp near L0d8c2881
L0d8c2836:
   cmp word ptr [BP+0A],+00
   jz L0d8c2840
   xor AX,AX
jmp near L0d8c2881
L0d8c2840:
   mov AX,0001
   push AX
   call far _addinv
   pop CX
   mov AX,0006
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
   push SI
   call far _killobj
   pop CX
   cmp word ptr [offset _first_key],+00
   jz L0d8c287e
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y2a17103b
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_key],0000
L0d8c287e:
   mov AX,0001
L0d8c2881:
   pop DI
   pop SI
   pop BP
ret far

_msg_pad: ;; 0d8c2885
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c28a1
   cmp AX,0001
   jz L0d8c28f3
   cmp AX,0002
   jz L0d8c28ef
jmp near L0d8c2952
L0d8c28a1:
   cmp word ptr [offset _designflag],+00
   jnz L0d8c28ab
jmp near L0d8c2952
L0d8c28ab:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0004
   push AX
   mov AX,0140
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c2952
L0d8c28ef:
   xor AX,AX
jmp near L0d8c2952
L0d8c28f3:
   cmp word ptr [BP+0A],+00
   jnz L0d8c294f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],-01
   jnz L0d8c2914
   mov DI,0004
jmp near L0d8c2932
L0d8c2914:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L0d8c292f
   mov DI,0005
jmp near L0d8c2932
L0d8c292f:
   mov DI,0003
L0d8c2932:
   push SI
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _sendtrig
   add SP,+06
L0d8c294f:
   mov AX,0001
L0d8c2952:
   pop DI
   pop SI
   pop BP
ret far

_msg_demon: ;; 0d8c2956
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,offset Y2a170e2a
   push AX
   mov CX,000C
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c298c
   cmp AX,0001
   jnz L0d8c2981
jmp near L0d8c2c75
L0d8c2981:
   cmp AX,0002
   jnz L0d8c2989
jmp near L0d8c2a1a
L0d8c2989:
jmp near L0d8c2d40
L0d8c298c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   mov BX,AX
   shl BX,1
   lea AX,[BP-0C]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[offset _kindtable+2*07]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0d8c29fd
   mov AX,0001
jmp near L0d8c29ff
L0d8c29fd:
   xor AX,AX
L0d8c29ff:
   shl AX,1
   shl AX,1
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c2d40
L0d8c2a1a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,000C
   jl L0d8c2a4b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0d8c2a4b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jz L0d8c2abc
   call far _rand
   mov BX,0024
   cwd
   idiv BX
   or DX,DX
   jz L0d8c2abc
jmp near L0d8c2c40
L0d8c2abc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L0d8c2ad5
jmp near L0d8c2c40
L0d8c2ad5:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   xor AX,AX
   push AX
   call far _pointvect
   add SP,+0E
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0012
   push AX
   call far _addobj
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   push AX
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   or DX,DX
   jnz L0d8c2be4
   call far _rand
   mov BX,0005
   cwd
   idiv BX
   add DX,-02
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far _rand
   mov BX,0005
   cwd
   idiv BX
   add DX,-02
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
jmp near L0d8c2c40
L0d8c2be4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   mov BX,0002
   cwd
   idiv BX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mov BX,0002
   cwd
   idiv BX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L0d8c2c40:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L0d8c2c5b
   mov AX,0001
jmp near L0d8c2c5d
L0d8c2c5b:
   xor AX,AX
L0d8c2c5d:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   sub [ES:BX+0D],AX
jmp near L0d8c2d3d
L0d8c2c75:
   cmp word ptr [BP+0A],+00
   jnz L0d8c2c9b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L0d8c2c9b
   push SI
   call far _hitplayer
   pop CX
jmp near L0d8c2d3d
L0d8c2c9b:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],32
   jz L0d8c2cb4
jmp near L0d8c2d3d
L0d8c2cb4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0d8c2d28
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,[ES:BX+11]
   cmp AX,0005
   jle L0d8c2cf6
   push SI
   call far _explode2
   pop CX
   push SI
   call far _killobj
   pop CX
jmp near L0d8c2d28
L0d8c2cf6:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   call far _explode1
   add SP,+06
L0d8c2d28:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0004
L0d8c2d3d:
   mov AX,0001
L0d8c2d40:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_fatso: ;; 0d8c2d45
   push BP
   mov BP,SP
   sub SP,+08
   push SI
   push DI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,offset Y2a170e36
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c2d7c
   cmp AX,0001
   jnz L0d8c2d71
jmp near L0d8c2e09
L0d8c2d71:
   cmp AX,0002
   jnz L0d8c2d79
jmp near L0d8c2e1c
L0d8c2d79:
jmp near L0d8c2f45
L0d8c2d7c:
   mov DI,[offset _kindtable+2*11]
   mov CL,08
   shl DI,CL
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0d8c2da0
   mov AX,0001
jmp near L0d8c2da2
L0d8c2da0:
   xor AX,AX
L0d8c2da2:
   mov DX,0003
   mul DX
   pop DI
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0004
   cwd
   idiv BX
   mov BX,AX
   shl BX,1
   lea AX,[BP-08]
   add BX,AX
   add DI,[SS:BX]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c2f45
L0d8c2e09:
   cmp word ptr [BP+0A],+00
   jz L0d8c2e12
jmp near L0d8c2f45
L0d8c2e12:
   push SI
   call far _hitplayer
   pop CX
jmp near L0d8c2f45
L0d8c2e1c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0010
   jl L0d8c2e4d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0d8c2e4d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jz L0d8c2e69
   xor AX,AX
jmp near L0d8c2f45
L0d8c2e69:
   call far _rand
   mov BX,001E
   cwd
   idiv BX
   or DX,DX
   jnz L0d8c2ee4
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   call far _seekplayer
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0d8c2ee4:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jnz L0d8c2f33
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L0d8c2f42
L0d8c2f33:
   mov AX,0011
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L0d8c2f42:
   mov AX,0001
L0d8c2f45:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_roman: ;; 0d8c2f4b
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c2f6f
   cmp AX,0001
   jnz L0d8c2f64
jmp near L0d8c2ff1
L0d8c2f64:
   cmp AX,0002
   jnz L0d8c2f6c
jmp near L0d8c301d
L0d8c2f6c:
jmp near L0d8c311d
L0d8c2f6f:
   mov AX,[offset _kindtable+2*44]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0d8c2f92
   mov AX,0001
jmp near L0d8c2f94
L0d8c2f92:
   xor AX,AX
L0d8c2f94:
   shl AX,1
   shl AX,1
   shl AX,1
   pop DX
   add DX,AX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   mov [BP-02],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-02]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c311d
L0d8c2ff1:
   cmp word ptr [BP+0A],+00
   jz L0d8c2ffa
jmp near L0d8c311d
L0d8c2ffa:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L0d8c3013
jmp near L0d8c311d
L0d8c3013:
   push SI
   call far _hitplayer
   pop CX
jmp near L0d8c311d
L0d8c301d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   call far _rand
   mov BX,001E
   cwd
   idiv BX
   or DX,DX
   jnz L0d8c30bc
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0007
   push DX
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   push SI
   call far _seekplayer
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   cwd
   xor AX,DX
   sub AX,DX
   mul word ptr [BP-02]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0d8c30bc:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jnz L0d8c310b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L0d8c311a
L0d8c310b:
   mov AX,0011
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L0d8c311a:
   mov AX,0001
L0d8c311d:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_fireball: ;; 0d8c3122
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c313d
   cmp AX,0001
   jz L0d8c319b
   cmp AX,0002
   jz L0d8c31b7
jmp near L0d8c325f
L0d8c313d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*12]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c325f
L0d8c319b:
   cmp word ptr [BP+0A],+00
   jz L0d8c31a4
jmp near L0d8c325f
L0d8c31a4:
   push SI
   call far _hitplayer
   pop CX
   xor AX,AX
   push AX
   call far _explode2
   pop CX
jmp near L0d8c325f
L0d8c31b7:
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L0d8c31c5
jmp near L0d8c3255
L0d8c31c5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0008
   jl L0d8c31f6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0d8c31f6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L0d8c325c
L0d8c3255:
   push SI
   call far _killobj
   pop CX
L0d8c325c:
   mov AX,0001
L0d8c325f:
   pop SI
   pop BP
ret far

_msg_cloud: ;; 0d8c3262
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c327c
   cmp AX,0002
   jz L0d8c32b9
jmp near L0d8c3378
L0d8c327c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0E0A
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c3378
L0d8c32b9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,000F
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jz L0d8c3376
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+05]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-02],AX
   push AX
   push DI
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L0d8c3371
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0d8c3371:
   mov AX,0001
jmp near L0d8c3378
L0d8c3376:
   xor AX,AX
L0d8c3378:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_text6: ;; 0d8c337e
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c3397
   cmp AX,0002
   jnz L0d8c3394
jmp near L0d8c3451
L0d8c3394:
jmp near L0d8c348a
L0d8c3397:
   cmp byte ptr [offset _x_ourmode],00
   jnz L0d8c33c6
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _fontcolor
   add SP,+08
jmp near L0d8c33fc
L0d8c33c6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _fontcolor
   add SP,+08
L0d8c33fc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   mov AX,0002
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _wprint
   add SP,+0E
jmp near L0d8c348a
L0d8c3451:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jle L0d8c3488
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   jg L0d8c3488
   push SI
   call far _killobj
   pop CX
   mov AX,0001
jmp near L0d8c348a
L0d8c3488:
   xor AX,AX
L0d8c348a:
   pop SI
   pop BP
ret far

_msg_score: ;; 0d8c348d
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c34aa
   cmp AX,0002
   jnz L0d8c34a7
jmp near L0d8c3551
L0d8c34a7:
jmp near L0d8c35e0
L0d8c34aa:
   mov AX,FFFF
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   and AX,0003
   inc AX
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _fontcolor
   add SP,+08
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-0A]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+0D]
   call far _itoa
   add SP,+08
   xor DI,DI
jmp near L0d8c3547
L0d8c34fe:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,DI
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   mov AL,[SS:BP+DI-0A]
   cbw
   add AX,03D0
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   inc DI
L0d8c3547:
   cmp byte ptr [SS:BP+DI-0A],00
   jnz L0d8c34fe
jmp near L0d8c35e0
L0d8c3551:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   jl L0d8c3571
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L0d8c357a
L0d8c3571:
   push SI
   call far _killobj
   pop CX
jmp near L0d8c35e0
L0d8c357a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+01],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+03],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+07]
   mov AX,0001
L0d8c35e0:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_text8: ;; 0d8c35e6
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c35ff
   cmp AX,0002
   jnz L0d8c35fc
jmp near L0d8c36b7
L0d8c35fc:
jmp near L0d8c36f0
L0d8c35ff:
   cmp byte ptr [offset _x_ourmode],00
   jnz L0d8c362e
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _fontcolor
   add SP,+08
jmp near L0d8c3664
L0d8c362e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _fontcolor
   add SP,+08
L0d8c3664:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _wprint
   add SP,+0E
jmp near L0d8c36f0
L0d8c36b7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jle L0d8c36ee
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   jg L0d8c36ee
   push SI
   call far _killobj
   pop CX
   mov AX,0001
jmp near L0d8c36f0
L0d8c36ee:
   xor AX,AX
L0d8c36f0:
   pop SI
   pop BP
ret far

_msg_frog: ;; 0d8c36f3
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov SI,[BP+06]
   xor DI,DI
   mov AX,[BP+08]
   cmp AX,DI
   jz L0d8c371a
   cmp AX,0001
   jnz L0d8c370f
jmp near L0d8c37f7
L0d8c370f:
   cmp AX,0002
   jnz L0d8c3717
jmp near L0d8c380a
L0d8c3717:
jmp near L0d8c39ff
L0d8c371a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+offset _kindtable]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0d8c3755
   mov AX,0001
jmp near L0d8c3757
L0d8c3755:
   xor AX,AX
L0d8c3757:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   mov [BP-06],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L0d8c37bb
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L0d8c3793
   mov AX,0001
jmp near L0d8c3795
L0d8c3793:
   xor AX,AX
L0d8c3795:
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L0d8c37b3
   mov AX,0001
jmp near L0d8c37b5
L0d8c37b3:
   xor AX,AX
L0d8c37b5:
   pop DX
   add DX,AX
   add [BP-06],DX
L0d8c37bb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-06]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c39ff
L0d8c37f7:
   cmp word ptr [BP+0A],+00
   jz L0d8c3800
jmp near L0d8c39ff
L0d8c3800:
   push SI
   call far _hitplayer
   pop CX
jmp near L0d8c39ff
L0d8c380a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0d8c389e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0010
   jg L0d8c383f
jmp near L0d8c39fd
L0d8c383f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   push SS
   lea AX,[BP-02]
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   call far _seekplayer
   add SP,+0A
   mov AX,[BP-04]
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF6
   mov DI,0001
jmp near L0d8c39fd
L0d8c389e:
   mov DI,0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add [ES:BX+07],DI
   mov AX,[ES:BX+07]
   cmp AX,000C
   jle L0d8c38d2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000A
L0d8c38d2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   mov [BP-04],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   mov [BP-02],AX
   push AX
   push [BP-04]
   push SI
   call far _trymove
   add SP,+06
   test AX,0003
   jz L0d8c393d
jmp near L0d8c39fd
L0d8c393d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L0d8c396b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
jmp near L0d8c39fd
L0d8c396b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[BP-02]
   and AX,FFF0
   add AX,0010
   mov DX,[ES:BX+0B]
   sub AX,DX
   mov [BP-02],AX
   push AX
   push [BP-04]
   push SI
   call far _trymove
   add SP,+06
   push SS
   lea AX,[BP-02]
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   call far _seekplayer
   add SP,+0A
   mov AX,[BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   mov AX,0012
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L0d8c39fd:
   mov AX,DI
L0d8c39ff:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_door: ;; 0d8c3a05
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-02],AX
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c3a61
   cmp AX,0002
   jnz L0d8c3a56
jmp near L0d8c3b9c
L0d8c3a56:
   cmp AX,0003
   jnz L0d8c3a5e
jmp near L0d8c3bdb
L0d8c3a5e:
jmp near L0d8c3d84
L0d8c3a61:
   cmp word ptr [offset _designflag],+00
   jz L0d8c3aaa
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0004
   push AX
   mov AX,0E05
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
L0d8c3aaa:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0d8c3ac3
jmp near L0d8c3d84
L0d8c3ac3:
   push [BP-02]
   push DI
   call far _drawcell
   pop CX
   pop CX
   mov AX,[BP-02]
   inc AX
   push AX
   push DI
   call far _drawcell
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+0D]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [offset _info+8*00a1]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0D]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [offset _info+8*00a2]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov AX,[BP-02]
   dec AX
   push AX
   push DI
   call far _drawcell
   pop CX
   pop CX
   mov AX,[BP-02]
   inc AX
   inc AX
   push AX
   push DI
   call far _drawcell
   pop CX
   pop CX
jmp near L0d8c3d84
L0d8c3b9c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0d8c3bf1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,[ES:BX+0D]
   cmp AX,0010
   jle L0d8c3bd5
   push SI
   call far _killobj
   pop CX
L0d8c3bd5:
   mov AX,0001
jmp near L0d8c3d84
L0d8c3bdb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0d8c3bf6
L0d8c3bf1:
   xor AX,AX
jmp near L0d8c3d84
L0d8c3bf6:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,00BE
   jz L0d8c3c17
jmp near L0d8c3cd3
L0d8c3c17:
   mov AX,0003
   push AX
   call far _takeinv
   pop CX
   or AX,AX
   jnz L0d8c3c28
jmp near L0d8c3caf
L0d8c3c28:
   mov AX,0024
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
   cmp word ptr [offset _first_openmapdoor],+00
   jz L0d8c3c55
   mov word ptr [offset _first_openmapdoor],0000
   mov AX,0001
   push AX
   push DS
   mov AX,offset Y2a17104c
   push AX
   call far _putbotmsg
   add SP,+06
L0d8c3c55:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+05]
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   mov DX,001F
   mul DX
   push ES
   push BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   add AX,[BP-02]
   shl AX,1
   pop BX
   pop ES
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   push AX
   push [BP-02]
   push DI
   call far _setboard
   add SP,+06
   push SI
   call far _killobj
   pop CX
jmp near L0d8c3d84
L0d8c3caf:
   cmp word ptr [offset _first_nogem],+00
   jnz L0d8c3cb9
jmp near L0d8c3d84
L0d8c3cb9:
   mov AX,0001
   push AX
   push DS
   mov AX,offset Y2a17105b
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_nogem],0000
jmp near L0d8c3d84
L0d8c3cd3:
   mov AX,0001
   push AX
   call far _takeinv
   pop CX
   or AX,AX
   jnz L0d8c3ce4
jmp near L0d8c3d66
L0d8c3ce4:
   cmp word ptr [offset _first_opendoor],+00
   jz L0d8c3d02
   mov word ptr [offset _first_opendoor],0000
   mov AX,0001
   push AX
   push DS
   mov AX,offset Y2a171072
   push AX
   call far _putbotmsg
   add SP,+06
L0d8c3d02:
   mov AX,000C
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov word ptr [BP-04],0000
jmp near L0d8c3d5e
L0d8c3d2d:
   mov BX,DI
   dec BX
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-02]
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   push AX
   mov AX,[BP-02]
   add AX,[BP-04]
   push AX
   push DI
   call far _setboard
   add SP,+06
   inc word ptr [BP-04]
L0d8c3d5e:
   cmp word ptr [BP-04],+01
   jle L0d8c3d2d
jmp near L0d8c3d84
L0d8c3d66:
   cmp word ptr [offset _first_nokey],+00
   jz L0d8c3d84
   mov word ptr [offset _first_nokey],0000
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y2a171081
   push AX
   call far _putbotmsg
   add SP,+06
L0d8c3d84:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_falldoor: ;; 0d8c3d8a
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0d8c3dac
   cmp AX,0002
   jz L0d8c3de9
   cmp AX,0003
   jnz L0d8c3da9
jmp near L0d8c3f21
L0d8c3da9:
jmp near L0d8c3fa1
L0d8c3dac:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0E10
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L0d8c3fa1
L0d8c3de9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0d8c3e04
   xor AX,AX
jmp near L0d8c3fa1
L0d8c3e04:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jz L0d8c3eaf
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jz L0d8c3e55
jmp near L0d8c3f1b
L0d8c3e55:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-02],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   mov AX,[BP-02]
   dec AX
   push AX
   push DI
   call far _setboard
   add SP,+06
jmp near L0d8c3f1b
L0d8c3eaf:
   mov AX,000E
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-02],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   push [BP-02]
   push DI
   call far _setboard
   add SP,+06
   push SI
   call far _killobj
   pop CX
L0d8c3f1b:
   mov AX,0001
jmp near L0d8c3fa1
L0d8c3f21:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+01]
   mov CL,04
   sar BX,CL
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   mov DX,001F
   mul DX
   push ES
   push BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov CL,04
   sar AX,CL
   dec AX
   shl AX,1
   pop BX
   pop ES
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,000D
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L0d8c3fa1:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1186 ;; JOBJ2.C:JOBJ2
_msg_token: ;; 11860007
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+0A]
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11860029
   cmp AX,0001
   jnz L11860021
jmp near L118600d1
L11860021:
   cmp AX,0002
   jz L1186007f
jmp near L11860211
L11860029:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   mov AX,[BX+offset _inv_shape]
   add AX,0E00
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11860211
L1186007f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+06
   jnz L118600cc
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _trymove
   add SP,+06
   mov AX,0001
jmp near L11860211
L118600cc:
   xor AX,AX
jmp near L11860211
L118600d1:
   or DI,DI
   jz L118600d8
jmp near L118601cb
L118600d8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   cmp word ptr [BX+offset _inv_xfm],+00
   jz L11860110
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _playerxfm
   pop CX
jmp near L118601c3
L11860110:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   cmp word ptr [BX+offset _inv_first],+00
   jz L11860170
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   dec word ptr [BX+offset _inv_first]
   mov AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   shl BX,1
   push [BX+offset _inv_getmsg+02]
   push [BX+offset _inv_getmsg]
   call far _putbotmsg
   add SP,+06
L11860170:
   mov AX,0019
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+06
   jnz L118601a3
   mov AX,0006
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jnz L118601c3
L118601a3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _addinv
   pop CX
   push SI
   call far _killobj
   pop CX
L118601c3:
   or word ptr [offset _statmodflg],C000
jmp near L11860211
L118601cb:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],44
   jz L118601f5
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],07
   jnz L11860211
L118601f5:
   push SI
   call far _killobj
   pop CX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0001
L11860211:
   pop DI
   pop SI
   pop BP
ret far

_msg_fire: ;; 11860215
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11860236
   cmp AX,0001
   jnz L1186022b
jmp near L11860313
L1186022b:
   cmp AX,0002
   jnz L11860233
jmp near L118602ba
L11860233:
jmp near L1186035b
L11860236:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*1f]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   push DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L1186029c
   mov AX,0001
jmp near L1186029e
L1186029c:
   xor AX,AX
L1186029e:
   mov DX,0006
   mul DX
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L1186035b
L118602ba:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,000C
   jge L118602ec
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jge L118602f3
L118602ec:
   push SI
   call far _killobj
   pop CX
L118602f3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L1186030f
   mov AX,0001
jmp near L11860311
L1186030f:
   xor AX,AX
L11860311:
jmp near L1186035b
L11860313:
   cmp word ptr [BP+0A],+00
   jnz L1186035b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jz L1186035b
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   call far _p_ouch
   pop CX
   pop CX
   xor AX,AX
   push AX
   call far _explode2
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L1186035b:
   pop SI
   pop BP
ret far

_msg_switch: ;; 1186035e
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jnz L1186036f
jmp near L118604e4
L1186036f:
   cmp AX,0001
   jz L1186037f
   cmp AX,0002
   jnz L1186037c
jmp near L11860539
L1186037c:
jmp near L1186053b
L1186037f:
   cmp word ptr [BP+0A],+00
   jz L11860388
jmp near L118604df
L11860388:
   cmp word ptr [offset _dy1],+00
   jz L118603a5
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L118603a5:
   cmp word ptr [offset _first_switch],+00
   jz L118603c3
   mov word ptr [offset _first_switch],0000
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y2a1712c3
   push AX
   call far _putbotmsg
   add SP,+06
L118603c3:
   cmp word ptr [offset _dy1],+00
   jge L11860440
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L11860440
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,0017
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+01
   jnz L1186041d
jmp near L1186049d
L1186041d:
   push SI
   mov AX,0005
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _sendtrig
   add SP,+06
jmp near L118604df
L11860440:
   cmp word ptr [offset _dy1],+00
   jg L1186044a
jmp near L118604df
L1186044a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11860463
jmp near L118604df
L11860463:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,0018
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+01
   jnz L118604bf
L1186049d:
   push SI
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _sendtrig
   add SP,+06
jmp near L118604df
L118604bf:
   push SI
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _sendtrig
   add SP,+06
L118604df:
   mov AX,0001
jmp near L1186053b
L118604e4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*20]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0D]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L1186053b
L11860539:
   xor AX,AX
L1186053b:
   pop SI
   pop BP
ret far

_msg_gem: ;; 1186053e
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L1186055c
   cmp AX,0001
   jnz L11860554
jmp near L11860606
L11860554:
   cmp AX,0002
   jz L118605bd
jmp near L1186067c
L1186055c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*21]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   add DX,+04
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L1186067c
L118605bd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   and AX,0001
   neg AX
   sbb AX,AX
   inc AX
jmp near L1186067c
L11860606:
   cmp word ptr [BP+0A],+00
   jnz L1186067c
   cmp word ptr [offset _first_touchgem],+00
   jz L1186062a
   mov word ptr [offset _first_touchgem],0000
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y2a1712e2
   push AX
   call far _putbotmsg
   add SP,+06
L1186062a:
   mov AX,0003
   push AX
   call far _addinv
   pop CX
   mov AX,0010
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [offset _kindscore+2*21]
   call far _addscore
   add SP,+06
   push SI
   call far _killobj
   pop CX
L1186067c:
   pop SI
   pop BP
ret far

_msg_boulder: ;; 1186067f
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L1186069a
   cmp AX,0001
   jz L118606ea
   cmp AX,0002
   jz L118606fd
jmp near L118609ba
L1186069a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   add AX,0E18
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L118609ba
L118606ea:
   cmp word ptr [BP+0A],+00
   jz L118606f3
jmp near L118609ba
L118606f3:
   push SI
   call far _hitplayer
   pop CX
jmp near L118609ba
L118606fd:
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   cmp AX,0003
   jz L1186073a
jmp near L11860839
L1186073a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,[ES:BX+07]
   cmp AX,000C
   jle L1186076c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L1186076c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _trymove
   add SP,+06
   cmp AX,0001
   jnz L118607cf
jmp near L118609b7
L118607cf:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   dec AX
   and AX,FFF0
   mov DX,0010
   sub DX,[offset _kindyl+2*23]
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _trymove
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
jmp near L118609b7
L11860839:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jz L1186085e
   mov AX,002D
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L1186085e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L118608e0
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   call far _seekplayer
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L118608e0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L1186090f
   mov AX,0001
jmp near L11860912
L1186090f:
   mov AX,FFFF
L11860912:
   pop DX
   add DX,AX
   and DX,0003
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _trymove
   add SP,+06
   cmp AX,0001
   jz L118609b7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L118609b7:
   mov AX,0001
L118609ba:
   pop SI
   pop BP
ret far

_explode2: ;; 118609bd
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   sub AX,[offset _kindyl+2*25]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+09]
   sub AX,[offset _kindxl+2*25]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   push DX
   mov AX,0025
   push AX
   call far _addobj
   add SP,+06
   pop SI
   pop BP
ret far

_explode1: ;; 11860a35
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L11860abd
L11860a3e:
   push [BP+08]
   push [BP+06]
   mov AX,0024
   push AX
   call far _addobj
   add SP,+06
   call far _rand
   mov BX,0007
   cwd
   idiv BX
   add DX,-03
   mov AX,[offset _numobjs]
   dec AX
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far _rand
   mov BX,000B
   cwd
   idiv BX
   add DX,-08
   mov AX,[offset _numobjs]
   dec AX
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   call far _rand
   mov BX,0003
   cwd
   idiv BX
   mov AX,[offset _numobjs]
   dec AX
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
   inc SI
L11860abd:
   cmp SI,[BP+0A]
   jge L11860ac5
jmp near L11860a3e
L11860ac5:
   pop SI
   pop BP
ret far

_msg_expl1: ;; 11860ac8
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11860ade
   cmp AX,0002
   jz L11860b59
jmp near L11860c19
L11860ade:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*24]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0D]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0008
   cwd
   idiv BX
   mov DX,0003
   mul DX
   pop DX
   sub DX,AX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11860c19
L11860b59:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0028
   jge L11860b80
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11860b8a
L11860b80:
   push SI
   call far _killobj
   pop CX
jmp near L11860c16
L11860b8a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+07]
   mov AX,[ES:BX+07]
   cmp AX,000C
   jle L11860bbb
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11860bbb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _moveobj
   add SP,+06
L11860c16:
   mov AX,0001
L11860c19:
   pop SI
   pop BP
ret far

_msg_expl2: ;; 11860c1c
   push BP
   mov BP,SP
   sub SP,+12
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-12]
   push AX
   push DS
   mov AX,offset Y2a17110a
   push AX
   mov CX,0012
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11860c47
   cmp AX,0002
   jz L11860ca7
jmp near L11860cd8
L11860c47:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-12]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[offset _kindtable+2*25]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11860cd8
L11860ca7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0009
   jge L11860cce
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11860cd5
L11860cce:
   push SI
   call far _killobj
   pop CX
L11860cd5:
   mov AX,0001
L11860cd8:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_stalag: ;; 11860cdd
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   cmp AX,0005
   jbe L11860cef
jmp near L11860e4f
L11860cef:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y11860cf8]
Y11860cf8:	dw L11860d04,L11860d41,L11860d59,L11860e0c,L11860e4f,L11860e0c
L11860d04:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0E21
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11860e4f
L11860d41:
   cmp word ptr [BP+0A],+00
   jz L11860d4a
jmp near L11860e4f
L11860d4a:
   mov AX,0002
   push AX
   push AX
   call far _p_ouch
   pop CX
   pop CX
jmp near L11860e4f
L11860d59:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11860d72
jmp near L11860e08
L11860d72:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _trymovey
   add SP,+06
   or AX,AX
   jnz L11860dd1
   mov AX,001B
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
   push SI
   call far _killobj
   pop CX
L11860dd1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,[ES:BX+07]
   cmp AX,0010
   jle L11860e03
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0010
L11860e03:
   mov AX,0001
jmp near L11860e4f
L11860e08:
   xor AX,AX
jmp near L11860e4f
L11860e0c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11860e46
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0002
   mov AX,002F
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L11860e46:
   push [BP+0A]
   call far _killobj
   pop CX
L11860e4f:
   pop SI
   pop BP
ret far

_msg_snake: ;; 11860e52
   push BP
   mov BP,SP
   sub SP,+1A
   push SI
   push DI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-1A]
   push AX
   push DS
   mov AX,offset Y2a17111c
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-12]
   push AX
   push DS
   mov AX,offset Y2a171124
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-0A]
   push AX
   push DS
   mov AX,offset Y2a17112c
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[offset _kindtable+2*27]
   mov CL,08
   shl AX,CL
   mov [BP-02],AX
   mov AX,[BP+08]
   or AX,AX
   jz L11860eb7
   cmp AX,0001
   jnz L11860eac
jmp near L11861235
L11860eac:
   cmp AX,0002
   jnz L11860eb4
jmp near L11861191
L11860eb4:
jmp near L118612dc
L11860eb7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jg L11860ed0
jmp near L1186102d
L11860ed0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   add AX,FFF0
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-1A]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov DI,0001
jmp near L11860fac
L11860f45:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,DI
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-12]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   inc DI
L11860fac:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,FFE8
   mov BX,0008
   cwd
   idiv BX
   cmp AX,DI
   jl L11860fcf
jmp near L11860f45
L11860fcf:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-0A]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L118612dc
L1186102d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-1A]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   add AX,0009
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov DI,0001
jmp near L118610f4
L1186108c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,DI
   inc DX
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-12]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   inc DI
L118610f4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,FFE8
   mov BX,0008
   cwd
   idiv BX
   cmp AX,DI
   jl L11861117
jmp near L1186108c
L11861117:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   add AX,FFF8
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-0A]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   add AX,0005
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L118612dc
L11861191:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L118611ba
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L118611ba:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jnz L11861242
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L11861242
L11861235:
   cmp word ptr [BP+0A],+00
   jnz L11861248
   push SI
   call far _hitplayer
   pop CX
L11861242:
   mov AX,0001
jmp near L118612dc
L11861248:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],4000
   jz L118612dc
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L118612dc
   push SI
   call far _notemod
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0010
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   sub word ptr [ES:BX+09],+08
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+09],+18
   jge L118612cd
   push SI
   call far _playerkill
   pop CX
jmp near L118612dc
L118612cd:
   mov AX,001F
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L118612dc:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_boll: ;; 118612e2
   push BP
   mov BP,SP
   sub SP,+18
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   mov [BP-10],AX
   mov word ptr [BP-0E],0001
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,offset Y2a171134
   push AX
   mov CX,000C
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L1186132e
   cmp AX,0001
   jz L11861384
   cmp AX,0002
   jz L11861397
jmp near L118616d0
L1186132e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*29]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L118616d0
L11861384:
   cmp word ptr [BP+0A],+00
   jz L1186138d
jmp near L118616d0
L1186138d:
   push SI
   call far _hitplayer
   pop CX
jmp near L118616d0
L11861397:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-0C]
   add BX,AX
   mov AX,[SS:BX]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-0C]
   add BX,AX
   mov AX,[SS:BX]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov word ptr [BP-16],FFFF
   mov word ptr [BP-14],0060
   xor DI,DI
jmp near L11861472
L11861409:
   mov BX,DI
   shl BX,1
   mov AX,[BX+offset _scrnobjs]
   mov [BP-18],AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],29
   jnz L11861471
   mov AX,[BP-18]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+13]
   jle L11861471
   push [BP-18]
   push SI
   call far _vectdist
   pop CX
   pop CX
   mov [BP-12],AX
   cmp AX,[BP-14]
   jge L11861471
   mov AX,[BP-18]
   mov [BP-16],AX
   mov AX,[BP-12]
   mov [BP-14],AX
L11861471:
   inc DI
L11861472:
   cmp DI,[offset _numscrnobjs]
   jl L11861409
   cmp word ptr [BP-16],+00
   jl L11861498
   mov AX,0004
   push AX
   push SS
   lea AX,[BP-0E]
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   push SI
   push [BP-16]
   call far _pointvect
   add SP,+0E
L11861498:
   mov AX,[BP-10]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+0C
   jle L118614db
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],000C
L118614db:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],-0C
   jge L11861506
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],FFF4
L11861506:
   mov AX,[BP-0E]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+0C
   jle L11861549
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11861549:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-0C
   jge L11861574
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
L11861574:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L118615e7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L118615e7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jz L11861633
jmp near L118616cd
L11861633:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+07]
   and DI,FFF0
   add DI,+10
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   sub DI,[ES:BX+0B]
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L118616cd
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,0009
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L118616cd:
   mov AX,0001
L118616d0:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_mega: ;; 118616d6
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L118616f4
   cmp AX,0002
   jz L1186174a
   cmp AX,0003
   jnz L118616f1
jmp near L11861843
L118616f1:
jmp near L1186185b
L118616f4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*2a]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L1186185b
L1186174a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11861763
jmp near L1186182e
L11861763:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+10
   jle L118617a2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0010
L118617a2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L11861858
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,0002
   mov DX,[ES:BX+07]
   sub AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11861832
L1186182e:
   xor AX,AX
jmp near L1186185b
L11861832:
   mov AX,001C
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L11861858
L11861843:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L11861858:
   mov AX,0001
L1186185b:
   pop SI
   pop BP
ret far

_msg_bat: ;; 1186185e
   push BP
   mov BP,SP
   sub SP,+16
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[offset _kindtable+2*2b]
   mov CL,08
   shl AX,CL
   mov [BP-16],AX
   mov word ptr [BP-14],0000
   xor DI,DI
   push SS
   lea AX,[BP-10]
   push AX
   push DS
   mov AX,offset Y2a171140
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,offset Y2a171148
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L118618b8
   cmp AX,0001
   jnz L118618ad
jmp near L1186198e
L118618ad:
   cmp AX,0002
   jnz L118618b5
jmp near L118619a1
L118618b5:
jmp near L11861bf7
L118618b8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L118618d8
   mov word ptr [BP-14],0006
   mov DI,0002
jmp near L1186194b
L118618d8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   mov BX,AX
   shl BX,1
   lea AX,[BP-10]
   add BX,AX
   mov DI,[SS:BX]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   mov BX,AX
   shl BX,1
   lea AX,[BP-08]
   add BX,AX
   mov AX,[SS:BX]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L1186193e
   mov AX,0001
jmp near L11861940
L1186193e:
   xor AX,AX
L11861940:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   add [BP-16],DX
L1186194b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,DI
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,[BP-14]
   push AX
   push [BP-16]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11861bf7
L1186198e:
   cmp word ptr [BP+0A],+00
   jz L11861997
jmp near L11861bf7
L11861997:
   push SI
   call far _hitplayer
   pop CX
jmp near L11861bf7
L118619a1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11861a4d
   call far _rand
   mov BX,0028
   cwd
   idiv BX
   or DX,DX
   jz L118619f7
   xor AX,AX
jmp near L11861bf7
L118619f7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   shl DX,1
   shl DX,1
   shl DX,1
   add DX,-04
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0002
jmp near L11861bf4
L11861a4d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _trymove
   add SP,+06
   mov [BP-12],AX
   cmp AX,0001
   jnz L11861afe
   call far _rand
   mov BX,0023
   cwd
   idiv BX
   or DX,DX
   jnz L11861ae9
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11861ae9:
   call far _rand
   mov BX,0014
   cwd
   idiv BX
   or DX,DX
   jz L11861afb
jmp near L11861bf4
L11861afb:
jmp near L11861bca
L11861afe:
   cmp word ptr [BP-12],+02
   jnz L11861b31
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L11861bf4
L11861b31:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far _rand
   mov BX,0003
   cwd
   idiv BX
   or DX,DX
   jnz L11861bca
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11861bca
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   and AX,FFF0
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _trymove
   add SP,+06
jmp near L11861bf4
L11861bca:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11861bf4:
   mov AX,0001
L11861bf7:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_knight: ;; 11861bfd
   push BP
   mov BP,SP
   sub SP,+2C
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[offset _kindtable+2*2c]
   mov CL,08
   shl DI,CL
   push SS
   lea AX,[BP-2C]
   push AX
   push DS
   mov AX,offset Y2a171150
   push AX
   mov CX,0016
   call far SCOPY@
   push SS
   lea AX,[BP-16]
   push AX
   push DS
   mov AX,offset Y2a171166
   push AX
   mov CX,0016
   call far SCOPY@
   mov AX,[BP+08]
   cmp AX,0005
   jbe L11861c3f
jmp near L11861e54
L11861c3f:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y11861c48]
Y11861c48:	dw L11861c54,L11861dd8,L11861ccd,L11861d90,L11861dc0,L11861da8
L11861c54:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+11]
   shl BX,1
   lea AX,[BP-2C]
   add BX,AX
   mov AX,[SS:BX]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+11]
   shl BX,1
   lea AX,[BP-16]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11861e54
L11861ccd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+06
   jnz L11861d0d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L11861d0d:
   test word ptr [offset _gamecount],0001
   jz L11861d3f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+11]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+05]
   jnz L11861d44
L11861d3f:
   xor AX,AX
jmp near L11861e54
L11861d44:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,[ES:BX+11]
   cmp AX,000A
   jl L11861d8a
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
L11861d8a:
   mov AX,0001
jmp near L11861e54
L11861d90:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],000A
jmp near L11861e54
L11861da8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0006
jmp near L11861e54
L11861dc0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
jmp near L11861e54
L11861dd8:
   cmp word ptr [BP+0A],+00
   jnz L11861e16
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L11861e16
   mov AX,0007
   push AX
   push DS
   mov AX,offset _xknightmsg
   push AX
   call far _putbotmsg
   add SP,+06
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   call far _p_ouch
   pop CX
   pop CX
jmp near L11861e54
L11861e16:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],4000
   jz L11861e54
   cmp word ptr [offset _first_hitknight],+00
   jz L11861e54
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y2a171304
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_hitknight],0000
L11861e54:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_beenest: ;; 11861e5a
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[offset _kindtable+2*2d]
   mov CL,08
   shl DI,CL
   mov AX,[BP+08]
   or AX,AX
   jz L11861e84
   cmp AX,0001
   jnz L11861e79
jmp near L11861f0d
L11861e79:
   cmp AX,0002
   jnz L11861e81
jmp near L11861fac
L11861e81:
jmp near L118620ab
L11861e84:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+01
   jnz L11861e9d
   inc DI
jmp near L11861ed3
L11861e9d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+02
   jnz L11861ed3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11861ece
   mov AX,0003
jmp near L11861ed1
L11861ece:
   mov AX,0002
L11861ed1:
   add DI,AX
L11861ed3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L118620ab
L11861f0d:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],4000
   jnz L11861f30
jmp near L118620ab
L11861f30:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [offset _kindscore+2*2d]
   call far _addscore
   add SP,+06
   mov AX,000A
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push CS
   call near offset _explode1
   add SP,+06
   push SI
   call far _killobj
   pop CX
   mov AX,0020
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L118620ab
L11861fac:
   mov AX,[offset _gamecount]
   and AX,0003
   cmp AX,0002
   jz L11861fba
jmp near L118620a8
L11861fba:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jnz L11862027
   call far _rand
   mov BX,0020
   cwd
   idiv BX
   or DX,DX
   jnz L11862022
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0001
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   call far _seekplayer
   add SP,+0A
jmp near L118620a8
L11862022:
   xor AX,AX
jmp near L118620ab
L11862027:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0002
   jle L118620a8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   shl AX,1
   shl AX,1
   shl AX,1
   pop DX
   add DX,AX
   push DX
   mov AX,002E
   push AX
   call far _addobj
   add SP,+06
L118620a8:
   mov AX,0001
L118620ab:
   pop DI
   pop SI
   pop BP
ret far

_msg_beeswarm: ;; 118620af
   push BP
   mov BP,SP
   sub SP,+40
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[offset _kindtable+2*2e]
   mov CL,08
   shl DI,CL
   push SS
   lea AX,[BP-40]
   push AX
   push DS
   mov AX,offset Y2a17117c
   push AX
   mov CX,0040
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L118620ee
   cmp AX,0001
   jnz L118620e3
jmp near L11862161
L118620e3:
   cmp AX,0002
   jnz L118620eb
jmp near L11862174
L118620eb:
jmp near L11862331
L118620ee:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L1186211d
   mov AX,0003
jmp near L1186211f
L1186211d:
   xor AX,AX
L1186211f:
   pop DX
   add DX,AX
   add DX,+04
   add DI,DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11862331
L11862161:
   cmp word ptr [BP+0A],+00
   jz L1186216a
jmp near L11862331
L1186216a:
   push SI
   call far _hitplayer
   pop CX
jmp near L11862331
L11862174:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],00A0
   jle L118621a8
   push SI
   call far _killobj
   pop CX
jmp near L1186232e
L118621a8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0002
   jle L118621d9
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L118621d9:
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   call far _seekplayer
   add SP,+0A
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   mov AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   shl AX,1
   mov DX,AX
   pop AX
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+0D]
   and BX,001F
   shl BX,1
   lea AX,[BP-40]
   add BX,AX
   pop AX
   mul word ptr [SS:BX]
   mov BX,0002
   cwd
   idiv BX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   mov AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   shl AX,1
   mov DX,AX
   pop AX
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+0D]
   add BX,+10
   and BX,001F
   shl BX,1
   lea AX,[BP-40]
   add BX,AX
   pop AX
   mul word ptr [SS:BX]
   mov BX,0002
   cwd
   idiv BX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _justmove
   add SP,+06
L1186232e:
   mov AX,0001
L11862331:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_crab: ;; 11862337
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[offset _kindtable+2*2f]
   mov CL,08
   shl DI,CL
   mov AX,[BP+08]
   or AX,AX
   jz L1186235b
   cmp AX,0001
   jz L118623aa
   cmp AX,0002
   jz L118623bd
jmp near L118626e0
L1186235b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   add AX,DI
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L118626e0
L118623aa:
   cmp word ptr [BP+0A],+00
   jz L118623b3
jmp near L118626e0
L118623b3:
   push SI
   call far _hitplayer
   pop CX
jmp near L118626e0
L118623bd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11862402
jmp near L11862516
L11862402:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L11862441
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   shl DX,1
   shl DX,1
   shl DX,1
   add DX,-04
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11862441:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jnz L118624b3
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L118624b3
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   or DX,DX
   jnz L118624b3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L118624b3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11862516
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jnz L11862516
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11862516:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jz L1186252f
jmp near L118626dd
L1186252f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L1186256c
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   shl DX,1
   shl DX,1
   add DX,-02
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L1186256c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L11862624
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
L11862624:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jz L1186263e
jmp near L118626dd
L1186263e:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jz L11862678
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
jmp near L118626dd
L11862678:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jz L118626dd
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L118626dd:
   mov AX,0001
L118626e0:
   pop DI
   pop SI
   pop BP
ret far

_msg_croc: ;; 118626e4
   push BP
   mov BP,SP
   sub SP,+14
   push SI
   push DI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-14]
   push AX
   push DS
   mov AX,offset Y2a1711bc
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,offset Y2a1711c4
   push AX
   mov CX,0008
   call far SCOPY@
   mov DI,[offset _kindtable+2*30]
   mov CL,08
   shl DI,CL
   mov AX,[BP+08]
   or AX,AX
   jz L11862735
   cmp AX,0001
   jnz L1186272a
jmp near L1186295e
L1186272a:
   cmp AX,0002
   jnz L11862732
jmp near L118628ba
L11862732:
jmp near L11862a33
L11862735:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jg L1186274e
jmp near L11862801
L1186274e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0020
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-14]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-0C]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11862a33
L11862801:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-14]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   add AX,0008
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0020
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-0C]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   add AX,0008
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11862a33
L118628ba:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L118628e3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L118628e3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far _crawl
   add SP,+06
   or AX,AX
   jnz L1186296b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L1186296b
L1186295e:
   cmp word ptr [BP+0A],+00
   jnz L11862971
   push SI
   call far _hitplayer
   pop CX
L1186296b:
   mov AX,0001
jmp near L11862a33
L11862971:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   test word ptr [ES:BX+02],4000
   jnz L1186299e
jmp near L11862a33
L1186299e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L118629b7
jmp near L11862a33
L118629b7:
   push SI
   call far _notemod
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0010
   push SS
   lea AX,[BP-02]
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   call far _seekplayer
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   mul word ptr [BP-04]
   or AX,AX
   jle L11862a2c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L11862a33
L11862a2c:
   push SI
   call far _playerkill
   pop CX
L11862a33:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_epic: ;; 11862a39
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11862a54
   cmp AX,0001
   jz L11862aa5
   cmp AX,0002
   jz L11862a9f
jmp near L11862b54
L11862a54:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*31]
   mov CL,08
   shl AX,CL
   mov DX,[offset _gamecount]
   and DX,0007
   add AX,DX
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11862b54
L11862a9f:
   mov AX,0001
jmp near L11862b54
L11862aa5:
   cmp word ptr [BP+0A],+00
   jz L11862aae
jmp near L11862b54
L11862aae:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0019
   push AX
   call far _addscore
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,[ES:BX+0D]
   cmp AX,000A
   jle L11862b45
   mov AX,000A
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push CS
   call near offset _explode1
   add SP,+06
   push SI
   call far _killobj
   pop CX
   mov AX,0030
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L11862b54
L11862b45:
   mov AX,0020
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L11862b54:
   pop SI
   pop BP
ret far

_msg_spinblad: ;; 11862b57
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   mov SI,[BP+06]
   mov word ptr [BP-04],0000
   mov word ptr [BP-02],0000
   mov AX,[BP+08]
   or AX,AX
   jz L11862b83
   cmp AX,0001
   jz L11862bd9
   cmp AX,0002
   jnz L11862b80
jmp near L11862c44
L11862b80:
jmp near L11863054
L11862b83:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*32]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11863054
L11862bd9:
   cmp word ptr [BP+0A],+00
   jnz L11862bff
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+07
   jle L11862bff
   push SI
   call far _killobj
   pop CX
jmp near L11863054
L11862bff:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],0400
   jnz L11862c22
jmp near L11863054
L11862c22:
   push SI
   call far _killobj
   pop CX
   push [BP+0A]
   call far _playerkill
   pop CX
   mov AX,000A
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L11863054
L11862c44:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11862c5f
   mov AX,0001
jmp near L11862c61
L11862c5f:
   xor AX,AX
L11862c61:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11862c7d
   mov AX,0001
jmp near L11862c7f
L11862c7d:
   xor AX,AX
L11862c7f:
   pop DX
   sub DX,AX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+0F]
   mov AX,[ES:BX+0F]
   cmp AX,0040
   jl L11862cce
jmp near L1186304a
L11862cce:
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11862cdc
jmp near L1186304a
L11862cdc:
   mov word ptr [BP-0A],FFFF
   mov word ptr [BP-08],7FFF
   xor DI,DI
jmp near L11862d3d
L11862cea:
   mov BX,DI
   shl BX,1
   mov AX,[BX+offset _scrnobjs]
   mov [BP-0C],AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],0400
   jz L11862d3c
   cmp word ptr [BP-0C],+00
   jz L11862d3c
   push [BP-0C]
   push SI
   call far _vectdist
   pop CX
   pop CX
   mov [BP-06],AX
   cmp AX,[BP-08]
   jge L11862d3c
   cmp AX,0060
   jge L11862d3c
   mov AX,[BP-0C]
   mov [BP-0A],AX
   mov AX,[BP-06]
   mov [BP-08],AX
L11862d3c:
   inc DI
L11862d3d:
   cmp DI,[offset _numscrnobjs]
   jl L11862cea
   cmp word ptr [BP-0A],+00
   jl L11862d63
   mov AX,0003
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   push [BP-0A]
   call far _pointvect
   add SP,+0E
L11862d63:
   mov word ptr [BP-02],0001
   mov AX,[BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+0C
   jle L11862dab
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],000C
L11862dab:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],-0C
   jge L11862dd6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],FFF4
L11862dd6:
   mov AX,[BP-02]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+0C
   jle L11862e19
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11862e19:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-0C
   jge L11862e44
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
L11862e44:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _trybreakwall
   add SP,+06
   mov DX,000A
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+0F],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L11862f2c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11862f2c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+07]
   and DI,FFF0
   add DI,+10
   sub DI,[offset _kindyl+2*32]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L11863017
   mov AX,0023
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,DI
   jz L11862fed
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L11863017
L11862fed:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11863017:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L11863051
L1186304a:
   push SI
   call far _killobj
   pop CX
L11863051:
   mov AX,0001
L11863054:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_skull: ;; 1186305a
   push BP
   mov BP,SP
   sub SP,+18
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[offset _kindtable+2*33]
   mov CL,08
   shl DI,CL
   push SS
   lea AX,[BP-18]
   push AX
   push DS
   mov AX,offset Y2a1711cc
   push AX
   mov CX,0010
   call far SCOPY@
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,offset Y2a1711dc
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L118630ab
   cmp AX,0002
   jnz L118630a0
jmp near L118631e8
L118630a0:
   cmp AX,0003
   jnz L118630a8
jmp near L1186322f
L118630a8:
jmp near L11863285
L118630ab:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+11]
   mov BX,0002
   cwd
   idiv BX
   mov BX,AX
   and BX,0003
   shl BX,1
   lea AX,[BP-08]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11863126
jmp near L11863285
L11863126:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0005
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+11]
   shl BX,1
   lea AX,[BP-18]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0006
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,000A
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+11]
   add BX,+04
   and BX,0007
   shl BX,1
   lea AX,[BP-18]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11863285
L118631e8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11863201
jmp near L11863283
L11863201:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+11]
   inc AX
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+11],AX
jmp near L1186327e
L1186322f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11863283
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
   mov AX,0021
   push AX
   mov AX,0004
   push AX
   call far _snd_play
   pop CX
   pop CX
L1186327e:
   mov AX,0001
jmp near L11863285
L11863283:
   xor AX,AX
L11863285:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_button: ;; 1186328b
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L118632ac
   cmp AX,0001
   jnz L118632a1
jmp near L11863326
L118632a1:
   cmp AX,0002
   jnz L118632a9
jmp near L118633ed
L118632a9:
jmp near L11863418
L118632ac:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*34]
   mov CL,08
   shl AX,CL
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+0D]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L1186330b
   mov AX,0001
jmp near L1186330d
L1186330b:
   xor AX,AX
L1186330d:
   shl AX,1
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11863418
L11863326:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jz L1186333f
jmp near L118633d3
L1186333f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,0001
   mov DX,[ES:BX+0D]
   sub AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L118633a4
   push SI
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _sendtrig
   add SP,+06
jmp near L118633c4
L118633a4:
   push SI
   mov AX,0005
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _sendtrig
   add SP,+06
L118633c4:
   mov AX,002C
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L118633d3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0003
   mov AX,0001
jmp near L11863418
L118633ed:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L11863416
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0F]
L11863416:
   xor AX,AX
L11863418:
   pop SI
   pop BP
ret far

_msg_pac: ;; 1186341b
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[offset _kindtable+2*35]
   mov CL,08
   shl AX,CL
   mov [BP-0C],AX
   mov AX,[BP+08]
   or AX,AX
   jz L1186347a
   cmp AX,0001
   jz L11863447
   cmp AX,0002
   jnz L11863444
jmp near L11863507
L11863444:
jmp near L11863840
L11863447:
   cmp word ptr [BP+0A],+00
   jnz L11863457
   push SI
   call far _hitplayer
   pop CX
jmp near L11863840
L11863457:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],3E
   jz L11863470
jmp near L11863840
L11863470:
   push SI
   call far _killobj
   pop CX
jmp near L11863840
L1186347a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11863495
   inc word ptr [BP-0C]
jmp near L118634cb
L11863495:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L118634b1
   add word ptr [BP-0C],+03
jmp near L118634cb
L118634b1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L118634cb
   add word ptr [BP-0C],+02
L118634cb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-0C]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11863840
L11863507:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jz L11863521
jmp near L118637e2
L11863521:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jz L1186353b
jmp near L118637e2
L1186353b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-08],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-06],AX
   mov BX,[BP-08]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-0A],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L118635a8
   mov DI,0001
jmp near L118635aa
L118635a8:
   xor DI,DI
L118635aa:
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L118635c6
   mov AX,0001
jmp near L118635c8
L118635c6:
   xor AX,AX
L118635c8:
   pop DI
   sub DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L118635e6
   mov AX,0001
jmp near L118635e8
L118635e6:
   xor AX,AX
L118635e8:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11863604
   mov AX,0001
jmp near L11863606
L11863604:
   xor AX,AX
L11863606:
   pop DX
   sub DX,AX
   mov [BP-04],DX
   or DI,DI
   jnz L1186362d
   or DX,DX
   jnz L1186362d
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   or DX,DX
   jnz L11863628
   mov DI,0001
jmp near L1186362d
L11863628:
   mov word ptr [BP-04],0001
L1186362d:
   mov BX,[BP-08]
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-06]
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0A]
   jnz L11863654
jmp near L1186378d
L11863654:
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   shl DX,1
   dec DX
   mov [BP-02],DX
   mov AX,DI
   mul word ptr [BP-02]
   mov DI,AX
   mov AX,[BP-04]
   mul word ptr [BP-02]
   mov [BP-04],AX
   mov [BP-02],DI
   mov DI,AX
   mov AX,[BP-02]
   mov [BP-04],AX
   mov BX,[BP-08]
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-06]
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0A]
   jnz L118636a7
jmp near L1186378d
L118636a7:
   mov AX,DI
   mov DX,FFFF
   mul DX
   mov DI,AX
   mov AX,[BP-04]
   mov DX,FFFF
   mul DX
   mov [BP-04],AX
   mov BX,[BP-08]
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-06]
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0A]
   jnz L118636e2
jmp near L1186378d
L118636e2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L118636fd
   mov DI,0001
jmp near L118636ff
L118636fd:
   xor DI,DI
L118636ff:
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L1186371b
   mov AX,0001
jmp near L1186371d
L1186371b:
   xor AX,AX
L1186371d:
   pop DI
   sub DI,AX
   neg DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L1186373d
   mov AX,0001
jmp near L1186373f
L1186373d:
   xor AX,AX
L1186373f:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L1186375b
   mov AX,0001
jmp near L1186375d
L1186375b:
   xor AX,AX
L1186375d:
   pop DX
   sub DX,AX
   neg DX
   mov [BP-04],DX
   mov BX,[BP-08]
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-06]
   add AX,DX
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0A]
   jz L1186378d
   xor DI,DI
   mov [BP-04],DI
L1186378d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mul DI
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mul word ptr [BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L118637e2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _trymove
   add SP,+06
   mov AX,0001
L11863840:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_bubble: ;; 11863846
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L1186385c
   cmp AX,0002
   jz L118638b5
jmp near L1186395b
L1186385c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*3a]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   add AX,0006
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L1186395b
L118638b5:
   call far _rand
   mov BX,000F
   cwd
   idiv BX
   or DX,DX
   jnz L118638d7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
L118638d7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+02
   jg L11863951
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jz L11863951
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+13]
   dec AX
   push AX
   call far _rand
   mov BX,0003
   cwd
   idiv BX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+01]
   dec AX
   push AX
   push SI
   call far _fishdo
   add SP,+06
   or AX,AX
   jnz L11863958
L11863951:
   push SI
   call far _killobj
   pop CX
L11863958:
   mov AX,0001
L1186395b:
   pop SI
   pop BP
ret far

_msg_jellyfish: ;; 1186395e
   push BP
   mov BP,SP
   sub SP,+14
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-14]
   push AX
   push DS
   mov AX,offset Y2a1711e4
   push AX
   mov CX,0014
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11863991
   cmp AX,0001
   jnz L11863989
jmp near L11863c9c
L11863989:
   cmp AX,0002
   jz L118639f2
jmp near L11863d03
L11863991:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-14]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[offset _kindtable+2*3b]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11863d03
L118639f2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,000A
   jl L11863a23
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L11863a23:
   call far _rand
   mov BX,0003
   cwd
   idiv BX
   mov AX,DX
   dec AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   cwd
   xor AX,DX
   sub AX,DX
   cmp AX,0003
   jge L11863a54
   mov DX,0001
jmp near L11863a56
L11863a54:
   xor DX,DX
L11863a56:
   inc DX
   pop AX
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+06
   jle L11863a8a
   mov AX,0006
jmp near L11863a9d
L11863a8a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
L11863a9d:
   cmp AX,FFFA
   jge L11863aa7
   mov AX,FFFA
jmp near L11863ad5
L11863aa7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+06
   jle L11863ac2
   mov AX,0006
jmp near L11863ad5
L11863ac2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
L11863ad5:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far _rand
   mov BX,0003
   cwd
   idiv BX
   mov AX,DX
   dec AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+02
   jge L11863b14
   mov AX,0001
jmp near L11863b16
L11863b14:
   xor AX,AX
L11863b16:
   cwd
   xor AX,DX
   sub AX,DX
   mov DX,AX
   inc DX
   pop AX
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+06
   jle L11863b51
   mov AX,0006
jmp near L11863b64
L11863b51:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
L11863b64:
   cmp AX,FFFA
   jge L11863b6e
   mov AX,FFFA
jmp near L11863b9c
L11863b6e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+06
   jle L11863b89
   mov AX,0006
jmp near L11863b9c
L11863b89:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
L11863b9c:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _fishdo
   add SP,+06
   or AX,AX
   jnz L11863c24
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11863c24:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _fishdo
   add SP,+06
   or AX,AX
   jnz L11863c97
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11863c97:
   mov AX,0001
jmp near L11863d03
L11863c9c:
   cmp word ptr [BP+0A],+00
   jnz L11863cab
   push SI
   call far _hitplayer
   pop CX
jmp near L11863d03
L11863cab:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],4000
   jz L11863d03
   mov AX,0014
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push CS
   call near offset _explode1
   add SP,+06
   push SI
   call far _killobj
   pop CX
L11863d03:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_badfish: ;; 11863d08
   push BP
   mov BP,SP
   sub SP,+08
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,offset Y2a1711f8
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11863d3e
   cmp AX,0001
   jnz L11863d33
jmp near L11863fb0
L11863d33:
   cmp AX,0002
   jnz L11863d3b
jmp near L11863dcc
L11863d3b:
jmp near L11863fe6
L11863d3e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   and BX,0003
   shl BX,1
   lea AX,[BP-08]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[offset _kindtable+2*3c]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11863dab
   mov AX,0001
jmp near L11863dad
L11863dab:
   xor AX,AX
L11863dad:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   add DX,+0F
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11863fe6
L11863dcc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   call far _rand
   mov BX,0014
   cwd
   idiv BX
   or DX,DX
   jz L11863df1
jmp near L11863e7c
L11863df1:
   call far _rand
   mov BX,0003
   cwd
   idiv BX
   shl DX,1
   shl DX,1
   add DX,-04
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L11863e57
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   shl DX,1
   shl DX,1
   add DX,-02
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
jmp near L11863e7c
L11863e57:
   call far _rand
   mov BX,0003
   cwd
   idiv BX
   shl DX,1
   add DX,-02
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11863e7c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _fishdo
   add SP,+06
   or AX,AX
   jnz L11863eef
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11863eef:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _fishdo
   add SP,+06
   or AX,AX
   jnz L11863f62
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11863f62:
   call far _rand
   mov BX,0004
   cwd
   idiv BX
   or DX,DX
   jnz L11863fab
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,FFFE
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0006
   push AX
   mov AX,003A
   push AX
   call far _addobj
   add SP,+06
L11863fab:
   mov AX,0001
jmp near L11863fe6
L11863fb0:
   cmp word ptr [BP+0A],+00
   jnz L11863fbf
   push SI
   call far _hitplayer
   pop CX
jmp near L11863fe6
L11863fbf:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],4000
   jz L11863fe6
   push SI
   call far _playerkill
   pop CX
L11863fe6:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_elev: ;; 11863feb
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov CL,04
   sar DI,CL
   mov AX,[BP+08]
   or AX,AX
   jnz L11864031
jmp near L1186430b
L11864031:
   cmp AX,0001
   jz L11864041
   cmp AX,0002
   jnz L1186403e
jmp near L1186422f
L1186403e:
jmp near L11864345
L11864041:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],00
   jz L1186405a
jmp near L11864302
L1186405a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0006
   cmp word ptr [offset _first_elev],+00
   jz L1186408d
   mov word ptr [offset _first_elev],0000
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y2a17131f
   push AX
   call far _putbotmsg
   add SP,+06
L1186408d:
   cmp word ptr [offset _dy1],+00
   jl L11864097
jmp near L1186413b
L11864097:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   cmp AX,[offset _dy1]
   jz L118640d5
   mov AX,001D
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L118640d5:
   mov AX,DI
   add AX,FFFE
   mov CL,04
   shl AX,CL
   push AX
   push [offset _objs+01]
   xor AX,AX
   push AX
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L118640f5
jmp near L11864214
L118640f5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,FFF0
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _moveobj
   add SP,+06
   mov AX,008A
   push AX
   push DI
   push [BP-02]
   call far _setboard
   add SP,+06
jmp near L11864214
L1186413b:
   cmp word ptr [offset _dy1],+00
   jg L11864145
jmp near L11864214
L11864145:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   cmp AX,[offset _dy1]
   jz L11864183
   mov AX,001E
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L11864183:
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   inc AX
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,008A
   jnz L11864214
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   push AX
   mov AX,DI
   inc AX
   push AX
   push [BP-02]
   call far _setboard
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _moveobj
   add SP,+06
   mov AX,DI
   mov CL,04
   shl AX,CL
   push AX
   push [offset _objs+01]
   xor AX,AX
   push AX
   call far _justmove
   add SP,+06
L11864214:
   mov AX,[offset _dy1]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0F],AX
jmp near L11864302
L1186422f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11864258
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L11864258:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11864271
jmp near L11864307
L11864271:
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   inc AX
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,008A
   jnz L11864307
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],-01
   jz L11864307
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   push AX
   mov AX,DI
   inc AX
   push AX
   push [BP-02]
   call far _setboard
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _moveobj
   add SP,+06
L11864302:
   mov AX,0001
jmp near L11864345
L11864307:
   xor AX,AX
jmp near L11864345
L1186430b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0E2C
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
L11864345:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_firebullet: ;; 1186434b
   push BP
   mov BP,SP
   sub SP,+28
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-28]
   push AX
   push DS
   mov AX,offset Y2a171200
   push AX
   mov CX,0028
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L1186437e
   cmp AX,0001
   jnz L11864376
jmp near L11864570
L11864376:
   cmp AX,0002
   jz L118643d4
jmp near L118645b2
L1186437e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*3e]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L118645b2
L118643d4:
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L118643e9
L118643df:
   push SI
   call far _killobj
   pop CX
jmp near L118645af
L118643e9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,[ES:BX+0D]
   cmp AX,0014
   jl L11864446
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
L11864446:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _trybreakwall
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+0D]
   shl BX,1
   lea AX,[BP-28]
   add BX,AX
   mov AX,[SS:BX]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L11864551
jmp near L118643df
L11864551:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+0F]
   mov AX,[ES:BX+0F]
   cmp AX,0050
   jl L118645af
jmp near L118643df
L11864570:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],0080
   jz L118645af
   push SI
   call far _killobj
   pop CX
   push [BP+0A]
   call far _playerkill
   pop CX
   mov AX,000A
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L118645af:
   mov AX,0001
L118645b2:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_fishbullet: ;; 118645b7
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L118645cd
   cmp AX,0002
   jz L11864631
jmp near L1186469a
L118645cd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*3f]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11864616
   mov AX,0001
jmp near L11864618
L11864616:
   xor AX,AX
L11864618:
   pop DX
   add DX,AX
   add DX,+15
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L1186469a
L11864631:
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11864647
   push SI
   call far _killobj
   pop CX
   xor AX,AX
jmp near L1186469a
L11864647:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L11864697
   push SI
   call far _killobj
   pop CX
L11864697:
   mov AX,0001
L1186469a:
   pop SI
   pop BP
ret far

_msg_searock: ;; 1186469d
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L118646b3
   cmp AX,0002
   jz L118646f6
jmp near L11864745
L118646b3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*28]
   mov CL,08
   shl AX,CL
   add AX,0022
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11864745
L118646f6:
   call far _rand
   mov BX,000C
   cwd
   idiv BX
   or DX,DX
   jnz L11864743
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   inc AX
   inc AX
   push AX
   mov AX,003A
   push AX
   call far _addobj
   add SP,+06
   mov AX,0001
jmp near L11864745
L11864743:
   xor AX,AX
L11864745:
   pop SI
   pop BP
ret far

_msg_eyes: ;; 11864748
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[offset _kindtable+2*40]
   mov CL,08
   shl DI,CL
   mov AX,[BP+08]
   or AX,AX
   jz L1186476d
   cmp AX,0002
   jnz L1186476a
jmp near L11864813
L1186476a:
jmp near L118648b7
L1186476d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   add AX,0005
   push AX
   mov AX,DI
   inc AX
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L118648b7
L11864813:
   mov AX,0003
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   xor AX,AX
   push AX
   call far _pointvect
   add SP,+0E
   cmp word ptr [BP-02],+01
   jle L1186483a
   mov word ptr [BP-02],0001
jmp near L11864845
L1186483a:
   mov AX,[BP-02]
   dec AX
   jz L11864845
   mov word ptr [BP-02],FFFF
L11864845:
   cmp word ptr [BP-04],-02
   jge L11864850
   mov word ptr [BP-04],FFFE
L11864850:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   cmp AX,[BP-04]
   jnz L11864880
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   cmp AX,[BP-02]
   jz L118648b5
L11864880:
   mov AX,[BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,[BP-02]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,0001
jmp near L118648b7
L118648b5:
   xor AX,AX
L118648b7:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_vineclimb: ;; 118648bd
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L118648dc
   cmp AX,0001
   jz L1186493a
   cmp AX,0002
   jnz L118648d9
jmp near L1186499b
L118648d9:
jmp near L11864ab3
L118648dc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _kindtable+2*41]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11864ab3
L1186493a:
   cmp word ptr [BP+0A],+00
   jz L11864943
jmp near L11864ab3
L11864943:
   mov BX,[offset _objs+0d]
   shl BX,1
   test word ptr [BX+offset _stateinfo],0002
   jnz L11864991
   push [offset _objs+03]
   mov AX,[offset _objs+01]
   add AX,FFF8
   push AX
   xor AX,AX
   push AX
   call far _justmove
   add SP,+06
   mov DI,AX
   or DI,DI
   jnz L11864985
   push [offset _objs+03]
   mov AX,[offset _objs+01]
   add AX,0008
   push AX
   xor AX,AX
   push AX
   call far _justmove
   add SP,+06
   mov DI,AX
L11864985:
   mov word ptr [offset _objs+0d],0000
   mov word ptr [offset _objs+0f],0000
L11864991:
   push SI
   call far _hitplayer
   pop CX
jmp near L11864ab3
L1186499b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L118649f2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0002
L118649f2:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _objdo
   add SP,+08
   or AX,AX
   jnz L11864a86
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _moveobj
   add SP,+06
jmp near L11864ab0
L11864a86:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11864ab0:
   mov AX,0001
L11864ab3:
   pop DI
   pop SI
   pop BP
ret far

_msg_flag: ;; 11864ab7
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11864ad5
   cmp AX,0001
   jnz L11864acd
jmp near L11864b89
L11864acd:
   cmp AX,0002
   jz L11864b37
jmp near L11864c35
L11864ad5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   inc AX
   inc AX
   push AX
   mov AX,[offset _kindtable+2*42]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   inc DX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L11864c35
L11864b37:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0006
   jl L11864b68
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L11864b68:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L11864b84
   mov AX,0001
jmp near L11864b86
L11864b84:
   xor AX,AX
L11864b86:
jmp near L11864c35
L11864b89:
   cmp word ptr [BP+0A],+00
   jz L11864b92
jmp near L11864c32
L11864b92:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11864bab
jmp near L11864c32
L11864bab:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0006
   push AX
   call far _addscore
   add SP,+06
   mov AX,0020
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,0005
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push CS
   call near offset _explode1
   add SP,+06
L11864c32:
   mov AX,0001
L11864c35:
   pop SI
   pop BP
ret far

_msg_macrotrig: ;; 11864c38
   push BP
   mov BP,SP
   mov AX,[BP+08]
   cmp AX,0001
   jz L11864c45
jmp near L11864c48
L11864c45:
   mov AX,0001
L11864c48:
   pop BP
ret far

_msg_txtmsg: ;; 11864c4a
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   cmp AX,0001
   jz L11864c8c
   cmp AX,0002
   jz L11864c61
jmp near L11864ce9
L11864c61:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11864ce9
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
jmp near L11864ce9
L11864c8c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11864cd4
   mov AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far _putbotmsg
   add SP,+06
   mov AX,0014
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L11864cd4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0008
L11864ce9:
   pop SI
   pop BP
ret far

_msg_mapdemo: ;; 11864cec
   push BP
   mov BP,SP
   sub SP,+08
   push SI
   push DI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,offset Y2a171228
   push AX
   mov CX,0004
   call far SCOPY@
   push SS
   lea AX,[BP-04]
   push AX
   push DS
   mov AX,offset Y2a17122c
   push AX
   mov CX,0004
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11864d2d
   cmp AX,0002
   jnz L11864d2a
jmp near L11864dce
L11864d2a:
jmp near L11864e20
L11864d2d:
   cmp byte ptr [offset _x_ourmode],00
   jnz L11864d37
jmp near L11864e20
L11864d37:
   xor DI,DI
jmp near L11864da8
L11864d3b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,DI
   mov CL,04
   shl DX,CL
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+05]
   shl BX,1
   lea AX,[BP-08]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[offset _kindtable+2*43]
   mov CL,08
   shl DX,CL
   add AX,DX
   add AX,DI
   add AX,4000
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   inc DI
L11864da8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+05]
   shl BX,1
   lea AX,[BP-04]
   add BX,AX
   mov AX,[SS:BX]
   cmp AX,DI
   jle L11864dcc
jmp near L11864d3b
L11864dcc:
jmp near L11864e20
L11864dce:
   cmp word ptr [offset _designflag],+00
   jnz L11864e1d
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   add AX,[offset _scrollxd]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+01],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   add AX,[offset _scrollyd]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
L11864e1d:
   mov AX,0001
L11864e20:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1668 ;; JOBJ3.C:JOBJ3
_msg_block: ;; 16680006
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov DI,[BP+06]
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov SI,[ES:BX]
   and SI,3FFF
   mov AX,[offset _gamecount]
   and AX,0003
   mov [BP-0A],AX
   mov AX,DI
   mov CL,04
   shl AX,CL
   mov [BP-08],AX
   mov AX,[BP+08]
   mov CL,04
   shl AX,CL
   mov [BP-06],AX
   mov AX,[BP+0A]
   or AX,AX
   jnz L16680051
jmp near L1668041e
L16680051:
   cmp AX,0001
   jz L16680061
   cmp AX,0002
   jnz L1668005e
jmp near L16680120
L1668005e:
jmp near L16680779
L16680061:
   cmp SI,0186
   jl L16680088
   cmp SI,018B
   jg L16680088
   mov AX,0001
   push AX
   mov AX,0010
   push AX
   call far _p_ouch
   pop CX
   pop CX
   xor AX,AX
   push AX
   call far _explode2
   pop CX
jmp near L16680779
L16680088:
   cmp SI,0141
   jz L166800a6
   cmp SI,0142
   jz L166800a6
   cmp SI,0155
   jz L166800a6
   cmp SI,0156
   jz L166800a6
   cmp SI,00A6
   jnz L166800b8
L166800a6:
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   call far _p_ouch
   pop CX
   pop CX
jmp near L16680779
L166800b8:
   cmp SI,0190
   jl L166800ea
   cmp SI,0197
   jg L166800ea
   cmp byte ptr [offset _objs],39
   jnz L166800ce
jmp near L16680779
L166800ce:
   cmp byte ptr [offset _objs],36
   jnz L166800d8
jmp near L16680779
L166800d8:
   mov AX,0001
   push AX
   mov AX,0010
   push AX
   call far _p_ouch
   pop CX
   pop CX
jmp near L16680779
L166800ea:
   cmp SI,0198
   jge L166800f3
jmp near L16680779
L166800f3:
   cmp SI,01A3
   jle L166800fc
jmp near L16680779
L166800fc:
   mov AX,[offset _gamecount]
   sub AX,[offset _lastwater]
   cmp AX,000A
   jle L16680117
   mov AX,0004
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L16680117:
   mov AX,[offset _gamecount]
   mov [offset _lastwater],AX
jmp near L16680779
L16680120:
   cmp SI,0186
   jl L1668018d
   cmp SI,018A
   jg L1668018d
   cmp word ptr [BP-0A],+00
   jnz L1668018d
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   inc AX
   push AX
   push [BP+08]
   push DI
   call far _setboard
   add SP,+06
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,018A
   jg L1668017a
jmp near L16680418
L1668017a:
   mov AX,0186
   push AX
   push [BP+08]
   push DI
   call far _setboard
   add SP,+06
jmp near L16680418
L1668018d:
   cmp SI,00BE
   jnz L166801a3
   cmp word ptr [BP-0A],+01
   jnz L1668019e
   mov AX,0001
jmp near L166801a0
L1668019e:
   xor AX,AX
L166801a0:
jmp near L1668077b
L166801a3:
   cmp SI,+6E
   jnz L166801b1
   cmp word ptr [BP-0A],+03
   jnz L166801b1
jmp near L16680418
L166801b1:
   cmp SI,00A6
   jnz L166801c0
   cmp word ptr [BP-0A],+01
   jnz L166801c0
jmp near L16680418
L166801c0:
   cmp SI,0081
   jnz L16680213
   mov AX,[offset _gamecount]
   and AX,0007
   cmp AX,0002
   jnz L16680213
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   sar AX,1
   and AX,000F
   mov [BP-0A],AX
   or word ptr [offset _info+8*0081+02],0002
   mov BX,AX
   shl BX,1
   mov AX,[BX+offset _blinkshtab]
   mov DX,[offset _info+8*0081]
   and DX,FF00
   add AX,DX
   mov [offset _info+8*0081],AX
   cmp word ptr [BP-0A],+08
   jl L1668020a
   cmp word ptr [BP-0A],+0D
   jge L1668020a
jmp near L16680418
L1668020a:
   xor word ptr [offset _info+8*0081+02],0002
jmp near L16680418
L16680213:
   cmp SI,015F
   jz L16680222
   cmp SI,0160
   jz L16680222
jmp near L166802a0
L16680222:
   cmp SI,0160
   jnz L16680235
   mov AX,[offset _gamecount]
   sub AX,DI
   and AX,001F
   mov [BP-04],AX
jmp near L16680240
L16680235:
   mov AX,[offset _gamecount]
   add AX,DI
   and AX,001F
   mov [BP-04],AX
L16680240:
   cmp word ptr [BP-04],+10
   jge L16680249
jmp near L16680418
L16680249:
   cmp word ptr [BP-04],+10
   jz L16680252
jmp near L16680779
L16680252:
   cmp SI,015F
   jnz L16680271
   mov AX,[BP-06]
   sub AX,[offset _kindyl+2*1f]
   push AX
   push [BP-08]
   mov AX,001F
   push AX
   call far _addobj
   add SP,+06
jmp near L166802cf
L16680271:
   mov AX,[BP-06]
   add AX,0010
   push AX
   push [BP-08]
   mov AX,001F
   push AX
   call far _addobj
   add SP,+06
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0001
jmp near L166802e6
L166802a0:
   cmp SI,+21
   jnz L166802f8
   mov AX,[offset _gamecount]
   and AX,003F
   mov DX,DI
   and DX,003F
   cmp AX,DX
   jnz L166802f8
   mov AX,[BP-06]
   sub AX,[offset _kindyl+2*1f]
   add AX,0008
   push AX
   push [BP-08]
   mov AX,001F
   push AX
   call far _addobj
   add SP,+06
L166802cf:
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFF
L166802e6:
   mov AX,001A
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L16680779
L166802f8:
   cmp SI,0190
   jge L16680301
jmp near L166803fa
L16680301:
   cmp SI,01A5
   jle L1668030a
jmp near L166803fa
L1668030a:
   test word ptr [BP-0A],0001
   jnz L16680314
jmp near L166803fa
L16680314:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   inc AX
   push AX
   push [BP+08]
   push DI
   call far _setboard
   add SP,+06
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   sub AX,0194
   cmp AX,0012
   jbe L1668035f
jmp near L16680418
L1668035f:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y16680368]
Y16680368:	dw L1668038e,L16680418,L16680418,L16680418,L166803a0,L16680418,L16680418,L16680418
		dw L166803b2,L16680418,L16680418,L16680418,L166803c4,L16680418,L16680418,L166803d6
		dw L16680418,L16680418,L166803e8
L1668038e:
   mov AX,0190
   push AX
   push [BP+08]
   push DI
   call far _setboard
   add SP,+06
jmp near L16680418
L166803a0:
   mov AX,0194
   push AX
   push [BP+08]
   push DI
   call far _setboard
   add SP,+06
jmp near L16680418
L166803b2:
   mov AX,0198
   push AX
   push [BP+08]
   push DI
   call far _setboard
   add SP,+06
jmp near L16680418
L166803c4:
   mov AX,019C
   push AX
   push [BP+08]
   push DI
   call far _setboard
   add SP,+06
jmp near L16680418
L166803d6:
   mov AX,01A0
   push AX
   push [BP+08]
   push DI
   call far _setboard
   add SP,+06
jmp near L16680418
L166803e8:
   mov AX,01A3
   push AX
   push [BP+08]
   push DI
   call far _setboard
   add SP,+06
jmp near L16680418
L166803fa:
   cmp SI,+14
   jge L16680402
jmp near L16680779
L16680402:
   cmp SI,+17
   jle L1668040a
jmp near L16680779
L1668040a:
   mov AX,[offset _gamecount]
   and AX,0007
   cmp AX,0002
   jz L16680418
jmp near L16680779
L16680418:
   mov AX,0001
jmp near L1668077b
L1668041e:
   cmp SI,015F
   jz L1668042a
   cmp SI,0160
   jnz L16680492
L1668042a:
   mov BX,SI
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov AX,[ES:BX]
   mov [BP-02],AX
   cmp SI,0160
   jnz L16680451
   mov AX,[offset _gamecount]
   sub AX,DI
   and AX,001F
   mov [BP-04],AX
jmp near L1668045c
L16680451:
   mov AX,[offset _gamecount]
   add AX,DI
   and AX,001F
   mov [BP-04],AX
L1668045c:
   cmp word ptr [BP-04],+10
   jge L16680476
   mov AX,[BP-04]
   mov BX,0004
   cwd
   idiv BX
   mov BX,AX
   shl BX,1
   mov AX,[BX+offset _pooftab]
   add [BP-02],AX
L16680476:
   push [BP-06]
   push [BP-08]
   push [BP-02]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16680779
L16680492:
   cmp SI,+64
   jl L166804df
   cmp SI,+66
   jg L166804df
   push [BP-06]
   push [BP-08]
   mov BX,DI
   dec BX
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov BX,[ES:BX]
   and BX,3FFF
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   push [ES:BX]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L166805ba
L166804df:
   cmp SI,+67
   jl L1668052c
   cmp SI,+69
   jg L1668052c
   push [BP-06]
   push [BP-08]
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   dec AX
   shl AX,1
   add BX,AX
   mov BX,[ES:BX]
   and BX,3FFF
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   push [ES:BX]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L166805ba
L1668052c:
   cmp SI,00BE
   jnz L1668055a
   push [BP-06]
   push [BP-08]
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   and AX,0003
   add AX,[offset _info+8*00be]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16680779
L1668055a:
   cmp SI,00A6
   jnz L16680588
   push [BP-06]
   push [BP-08]
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   and AX,0003
   add AX,[offset _info+8*00a6]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16680779
L16680588:
   cmp SI,+6E
   jnz L166805b5
   push [BP-06]
   push [BP-08]
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   and AX,0003
   add AX,[offset _info+8*006e]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16680779
L166805b5:
   cmp SI,+2D
   jnz L166805e8
L166805ba:
   push [BP-06]
   push [BP-08]
   mov BX,SI
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov AX,[ES:BX]
   xor AX,4000
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16680779
L166805e8:
   cmp SI,+14
   jge L166805f0
jmp near L16680779
L166805f0:
   cmp SI,+17
   jle L166805f8
jmp near L16680779
L166805f8:
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   sar AX,1
   sub AX,[BP+08]
   mov BX,0003
   cwd
   idiv BX
   mov [BP-04],DX
   or DX,DX
   jge L16680614
   add [BP-04],BX
L16680614:
   push [BP-06]
   push [BP-08]
   mov BX,SI
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov AX,[ES:BX]
   add AX,[BP-04]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov word ptr [BP-04],0001
   mov word ptr [BP-02],0000
   mov AX,[BP+08]
   dec AX
   mov [BP-06],AX
jmp near L1668069b
L16680652:
   mov AX,DI
   dec AX
   mov [BP-08],AX
jmp near L16680690
L1668065a:
   mov BX,[BP-08]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-06]
   shl AX,1
   add BX,AX
   mov SI,[ES:BX]
   and SI,3FFF
   cmp SI,+14
   jl L1668067f
   cmp SI,+17
   jle L16680685
L1668067f:
   mov AX,[BP-04]
   add [BP-02],AX
L16680685:
   mov AX,[BP-04]
   shl AX,1
   mov [BP-04],AX
   inc word ptr [BP-08]
L16680690:
   mov AX,DI
   inc AX
   cmp AX,[BP-08]
   jge L1668065a
   inc word ptr [BP-06]
L1668069b:
   mov AX,[BP+08]
   inc AX
   cmp AX,[BP-06]
   jge L16680652
   mov AX,DI
   mov CL,04
   shl AX,CL
   mov [BP-08],AX
   mov AX,[BP+08]
   mov CL,04
   shl AX,CL
   mov [BP-06],AX
   mov AX,[BP-02]
   and AX,00AA
   cmp AX,00AA
   jnz L166806df
   push [BP-06]
   push [BP-08]
   mov AX,2A05
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16680779
L166806df:
   mov AX,[BP-02]
   and AX,000A
   cmp AX,000A
   jnz L16680706
   push [BP-06]
   push [BP-08]
   mov AX,2A01
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16680779
L16680706:
   mov AX,[BP-02]
   and AX,0022
   cmp AX,0022
   jnz L1668072d
   push [BP-06]
   push [BP-08]
   mov AX,2A02
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16680779
L1668072d:
   mov AX,[BP-02]
   and AX,0088
   cmp AX,0088
   jnz L16680754
   push [BP-06]
   push [BP-08]
   mov AX,2A03
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16680779
L16680754:
   mov AX,[BP-02]
   and AX,00A0
   cmp AX,00A0
   jnz L16680779
   push [BP-06]
   push [BP-08]
   mov AX,2A04
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
L16680779:
   xor AX,AX
L1668077b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 16e0 ;; JPLAYER.C:JPLAYER
_calc_scroll: ;; 16e00001
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov SI,0008
   cmp word ptr [offset _objs+09],+04
   jnz L16e00023
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jz L16e00023
   mov SI,0004
L16e00023:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   add AX,0058
   cmp AX,[offset _objs+01]
   jle L16e00044
   cmp word ptr [ES:BX+08],+08
   jl L16e00077
   mov AX,SI
   neg AX
   mov [offset _scrollxd],AX
jmp near L16e00077
L16e00044:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov DX,[offset _scrnxs]
   mov CL,04
   shl DX,CL
   add AX,DX
   add AX,FF98
   cmp AX,[offset _objs+01]
   jge L16e00077
   mov AX,[ES:BX+08]
   mov DX,0080
   sub DX,[offset _scrnxs]
   dec DX
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jge L16e00077
   mov [offset _scrollxd],SI
L16e00077:
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[offset _scrnys]
   mov CL,04
   shl DX,CL
   mov BX,[offset _objs+03]
   sub BX,DX
   add BX,+60
   cmp AX,BX
   jge L16e000a6
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
jmp near L16e000b7
L16e000a6:
   mov AX,[offset _scrnys]
   mov CL,04
   shl AX,CL
   push AX
   mov AX,[offset _objs+03]
   pop DX
   sub AX,DX
   add AX,0060
L16e000b7:
   or AX,AX
   jge L16e000bf
   xor DI,DI
jmp near L16e000fe
L16e000bf:
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[offset _scrnys]
   mov CL,04
   shl DX,CL
   mov BX,[offset _objs+03]
   sub BX,DX
   add BX,+60
   cmp AX,BX
   jge L16e000ee
   mov DI,0040
   sub DI,[offset _scrnys]
   inc DI
   mov CL,04
   shl DI,CL
jmp near L16e000fe
L16e000ee:
   mov AX,[offset _scrnys]
   mov CL,04
   shl AX,CL
   mov DI,[offset _objs+03]
   sub DI,AX
   add DI,+60
L16e000fe:
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[offset _objs+03]
   add DX,-20
   cmp AX,DX
   jge L16e00123
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
jmp near L16e00129
L16e00123:
   mov AX,[offset _objs+03]
   add AX,FFE0
L16e00129:
   or AX,AX
   jge L16e00131
   xor AX,AX
jmp near L16e0015c
L16e00131:
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[offset _objs+03]
   add DX,-20
   cmp AX,DX
   jge L16e00156
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
jmp near L16e0015c
L16e00156:
   mov AX,[offset _objs+03]
   add AX,FFE0
L16e0015c:
   mov [BP-04],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   add AX,[BP+06]
   mov [BP-02],AX
   cmp AX,DI
   jl L16e0017e
   cmp AX,[BP-04]
   jg L16e0017e
   mov AX,[BP+06]
   mov [offset _scrollyd],AX
jmp near L16e001b0
L16e0017e:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   cmp AX,[BP-04]
   jle L16e00199
   mov AX,[BP-04]
   mov DX,[ES:BX+0A]
   sub AX,DX
   mov [offset _scrollyd],AX
jmp near L16e001b0
L16e00199:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   cmp AX,DI
   jge L16e001b0
   mov AX,DI
   mov DX,[ES:BX+0A]
   sub AX,DX
   mov [offset _scrollyd],AX
L16e001b0:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_player: ;; 16e001b6
   push BP
   mov BP,SP
   sub SP,+30
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[offset _kindtable]
   mov CL,08
   shl DI,CL
   mov word ptr [BP-2C],0000
   push SS
   lea AX,[BP-28]
   push AX
   push DS
   mov AX,offset Y2a171386
   push AX
   mov CX,0007
   call far SCOPY@
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,offset Y2a17138d
   push AX
   mov CX,0007
   call far SCOPY@
   push SS
   lea AX,[BP-18]
   push AX
   push DS
   mov AX,offset Y2a171394
   push AX
   mov CX,0015
   call far SCOPY@
   mov word ptr [BP-02],0000
   cmp word ptr [BP+08],+00
   jz L16e00212
jmp near L16e0081b
L16e00212:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   cmp AX,0005
   jbe L16e0022d
jmp near L16e0076f
L16e0022d:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y16e00236]
Y16e00236:	dw L16e00242,L16e0076f,L16e004a2,L16e00585,L16e005a6,L16e0065c
L16e00242:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jge L16e002c8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L16e00273
   add DI,+3C
jmp near L16e00295
L16e00273:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jle L16e0028e
   mov AX,0008
jmp near L16e00290
L16e0028e:
   xor AX,AX
L16e00290:
   add AX,0024
   add DI,AX
L16e00295:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-04
   jz L16e002c4
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-05
   jz L16e002c4
jmp near L16e0076f
L16e002c4:
   inc DI
jmp near L16e0076f
L16e002c8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L16e002e4
   add DI,+13
jmp near L16e0076f
L16e002e4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+03
   jnz L16e00300
   add DI,+3D
jmp near L16e0076f
L16e00300:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L16e0031c
   add DI,+12
jmp near L16e0076f
L16e0031c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L16e00364
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L16e0034b
jmp near L16e0042b
L16e0034b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+03
   jge L16e00364
jmp near L16e0042b
L16e00364:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+14
   jge L16e003b5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L16e003b5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jle L16e003ab
   mov AX,0001
jmp near L16e003ad
L16e003ab:
   xor AX,AX
L16e003ad:
   add AX,0014
   add DI,AX
jmp near L16e0076f
L16e003b5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],010C
   jle L16e00408
   mov BX,[offset _fidgetnum]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _fidgetseq
   push DS
   pop ES
   mov AX,SI
   mov DX,001F
   mul DX
   push ES
   push BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+11]
   mov BX,0002
   cwd
   idiv BX
   and AX,0003
   shl AX,1
   pop BX
   pop ES
   add BX,AX
   mov AX,[ES:BX]
   add DI,AX
jmp near L16e0076f
L16e00408:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],0096
   jle L16e00425
   add DI,+11
jmp near L16e0076f
L16e00425:
   add DI,+10
jmp near L16e0076f
L16e0042b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+08
   jnz L16e00466
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L16e0045c
   mov AX,0001
jmp near L16e0045e
L16e0045c:
   xor AX,AX
L16e0045e:
   add AX,0014
   add DI,AX
jmp near L16e0076f
L16e00466:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L16e00498
   mov AX,0008
jmp near L16e0049a
L16e00498:
   xor AX,AX
L16e0049a:
   pop DX
   add DX,AX
   add DI,DX
jmp near L16e0076f
L16e004a2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L16e00512
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jnz L16e004d4
   add DI,+38
jmp near L16e0076f
L16e004d4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+01
   jnz L16e004f0
   add DI,+39
jmp near L16e0076f
L16e004f0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L16e0050c
   add DI,+3A
jmp near L16e0076f
L16e0050c:
   add DI,+3C
jmp near L16e0076f
L16e00512:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jnz L16e0052d
   add DI,+20
jmp near L16e00566
L16e0052d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+01
   jnz L16e00548
   add DI,+21
jmp near L16e00566
L16e00548:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L16e00563
   add DI,+22
jmp near L16e00566
L16e00563:
   add DI,+24
L16e00566:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jg L16e0057f
jmp near L16e0076f
L16e0057f:
   add DI,+08
jmp near L16e0076f
L16e00585:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+0F]
   lea AX,[BP-28]
   add BX,AX
   mov AL,[SS:BX]
   cbw
   add DI,AX
jmp near L16e0076f
L16e005a6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+10
   jge L16e005c1
   add DI,+13
jmp near L16e005df
L16e005c1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+18
   jge L16e005dc
   add DI,+10
jmp near L16e005df
L16e005dc:
   add DI,+12
L16e005df:
   mov AX,0010
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   push DS
   mov AX,offset _tempvp
   push AX
   call far _memcpy
   add SP,+0A
   les BX,[offset _gamevp]
   mov AX,[offset _objs+03]
   add AX,[offset _objs+0b]
   mov DX,[ES:BX+0A]
   sub AX,DX
   mov [offset _tempvp+06],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0021
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+11]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push DS
   mov AX,offset _tempvp
   push AX
   call far _drawshape
   add SP,+0A
jmp near L16e0134f
L16e0065c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jnz L16e006af
   add DI,+42
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16e0134f
L16e006af:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   or AX,AX
   jz L16e006d3
   cmp AX,0001
   jz L16e006f3
   cmp AX,0002
   jz L16e00713
jmp near L16e0076f
L16e006d3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+11]
   mov BX,0004
   cwd
   idiv BX
   add AX,0030
   add DI,AX
jmp near L16e0076f
L16e006f3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+11]
   mov BX,0004
   cwd
   idiv BX
   add AX,0040
   add DI,AX
jmp near L16e0076f
L16e00713:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+11]
   lea AX,[BP-18]
   add BX,AX
   mov AL,[SS:BX]
   cbw
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16e0134f
L16e0076f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jg L16e007bf
jmp near L16e01d5b
L16e007bf:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,001A
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   mov DX,0E29
   sub DX,AX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16e01d5b
L16e0081b:
   cmp word ptr [BP+08],+02
   jz L16e00824
jmp near L16e01d53
L16e00824:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   cmp AX,0005
   jbe L16e0083f
jmp near L16e01a69
L16e0083f:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y16e00848]
Y16e00848:	dw L16e00854,L16e01a69,L16e01355,L16e016a4,L16e01107,L16e011ac
L16e00854:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L16e008b5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],FFFF
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
L16e008b5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jz L16e00923
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L16e008e6
   mov AX,0001
jmp near L16e008e8
L16e008e6:
   xor AX,AX
L16e008e8:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L16e00904
   mov AX,0001
jmp near L16e00906
L16e00904:
   xor AX,AX
L16e00906:
   pop DX
   sub DX,AX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   sub [ES:BX+07],AX
   mov word ptr [BP-2C],0001
L16e00923:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jge L16e0096f
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-01
   jz L16e00957
jmp near L16e00cc0
L16e00957:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0003
jmp near L16e00cc0
L16e0096f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L16e00988
jmp near L16e00b25
L16e00988:
   cmp word ptr [offset _dx1],+00
   jz L16e009de
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0007
   mov AX,[offset _dx1]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
L16e009d6:
   mov word ptr [BP-2C],0001
jmp near L16e01a69
L16e009de:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],012C
   jle L16e00a22
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0014
jmp near L16e00a97
L16e00a22:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],010C
   jge L16e00a97
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],0102
   jnz L16e00a81
   call far _rand
   mov BX,0004
   cwd
   idiv BX
   mov [offset _fidgetnum],DX
   mov AX,0002
   push AX
   mov BX,DX
   shl BX,1
   shl BX,1
   push [BX+offset _fidgetmsg+02]
   push [BX+offset _fidgetmsg]
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _bottime],0019
jmp near L16e00a9c
L16e00a81:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+03
   jnz L16e00a9c
L16e00a97:
   mov word ptr [BP-2C],0001
L16e00a9c:
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   and AX,FFF0
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   cmp AX,0003
   jz L16e00ade
jmp near L16e00cc0
L16e00ade:
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0002
jmp near L16e00cc0
L16e00b25:
   cmp word ptr [offset _dx1],+00
   jnz L16e00b2f
jmp near L16e00c50
L16e00b2f:
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   cmp AX,[offset _dx1]
   jz L16e00b50
jmp near L16e00bfc
L16e00b50:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[offset _dx1]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jz L16e00bc7
   mov AX,[offset _dx1]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+01],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L16e00bc7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   inc AX
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0F],AX
   mov word ptr [offset _objs+11],0000
jmp near L16e00cc0
L16e00bfc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+1B],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0004
jmp near L16e00cc0
L16e00c50:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+02
   jl L16e00cc0
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jz L16e00cc0
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
L16e00cc0:
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   and AX,FFF0
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   cmp AX,0003
   jnz L16e00d43
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
L16e00d43:
   cmp word ptr [offset _key],+20
   jz L16e00d4d
jmp near L16e00e25
L16e00d4d:
   mov AX,0006
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jnz L16e00d5e
jmp near L16e00e25
L16e00d5e:
   mov AX,[offset _objs+03]
   add AX,0010
   push AX
   mov AX,[offset _objs+1b]
   mov CL,04
   shl AX,CL
   add AX,[offset _objs+01]
   push AX
   mov AX,001C
   push AX
   call far _addobj
   add SP,+06
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0006
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[offset _numobjs]
   dec AX
   push AX
   call far _trymove
   add SP,+06
   or AX,AX
   jz L16e00e1a
   mov word ptr [BP-2A],0000
jmp near L16e00e0f
L16e00dd6:
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],1C
   jnz L16e00e0c
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+06
   jnz L16e00e0c
   push [BP-2A]
   call far _killobj
   pop CX
L16e00e0c:
   inc word ptr [BP-2A]
L16e00e0f:
   mov AX,[offset _numobjs]
   dec AX
   cmp AX,[BP-2A]
   jg L16e00dd6
jmp near L16e00e25
L16e00e1a:
   mov AX,[offset _numobjs]
   dec AX
   push AX
   call far _killobj
   pop CX
L16e00e25:
   cmp word ptr [offset _fire1],+00
   jz L16e00ea4
   mov word ptr [offset _fire1off],0001
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,0009
   push AX
   call far _invcount
   pop CX
   shl AX,1
   shl AX,1
   add AX,0010
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
   mov AX,[offset _dx1]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L16e017c8
L16e00ea4:
   cmp word ptr [offset _dy1],+00
   jnz L16e00eae
jmp near L16e01a69
L16e00eae:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jz L16e00ec8
jmp near L16e00fb8
L16e00ec8:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[offset _dy1]
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L16e00f0d
jmp near L16e00fb8
L16e00f0d:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[offset _dy1]
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L16e00fb8
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[offset _dy1]
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _moveobj
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0003
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0003
L16e00fb8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L16e00fd1
jmp near L16e01a69
L16e00fd1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L16e00fea
jmp near L16e01a69
L16e00fea:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mov DX,[offset _dy1]
   shl DX,1
   add AX,DX
   cmp AX,FFFD
   jge L16e0100f
   mov AX,FFFD
jmp near L16e0102a
L16e0100f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mov DX,[offset _dy1]
   shl DX,1
   add AX,DX
L16e0102a:
   cmp AX,0003
   jge L16e01071
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mov DX,[offset _dy1]
   shl DX,1
   add AX,DX
   cmp AX,FFFD
   jge L16e01054
   mov AX,FFFD
jmp near L16e0106f
L16e01054:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mov DX,[offset _dy1]
   shl DX,1
   add AX,DX
L16e0106f:
jmp near L16e01074
L16e01071:
   mov AX,0003
L16e01074:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0003
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+01
   jle L16e010e6
   mov word ptr [BP-02],0002
jmp near L16e01a69
L16e010e6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-01
   jl L16e010ff
jmp near L16e01a69
L16e010ff:
   mov word ptr [BP-02],FFFE
jmp near L16e01a69
L16e01107:
   mov word ptr [BP-2C],0001
   mov AX,[offset _kindxl]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov AX,[offset _kindyl]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+20
   jge L16e01155
jmp near L16e01a69
L16e01155:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
jmp near L16e009d6
L16e011ac:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jz L16e011c5
jmp near L16e0128b
L16e011c5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+02
   jz L16e011de
jmp near L16e0128b
L16e011de:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   inc AX
   inc AX
   cmp AX,0010
   jge L16e0120f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   inc AX
   inc AX
jmp near L16e01212
L16e0120f:
   mov AX,0010
L16e01212:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L16e01273
jmp near L16e0133c
L16e01273:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],FFFF
jmp near L16e0133c
L16e0128b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+01
   jnz L16e01316
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+02
   jnz L16e01316
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+09],0020
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0B],0020
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _moveobj
   add SP,+06
jmp near L16e0133c
L16e01316:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+14
   jl L16e0133c
   mov word ptr [offset _pl+02],0006
   mov AX,0001
   push AX
   call far _p_reenter
   pop CX
L16e0133c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+11]
L16e0134f:
   mov AX,0001
jmp near L16e01d5b
L16e01355:
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jnz L16e013da
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L16e013da
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0003
jmp near L16e01a54
L16e013da:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+0F]
   mov AX,[ES:BX+0F]
   cmp AX,0002
   jg L16e013f9
jmp near L16e01a69
L16e013f9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+10
   jle L16e01438
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0010
L16e01438:
   cmp word ptr [offset _dx1],+00
   jz L16e0146c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0002
   mov AX,[offset _dx1]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L16e0146c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+08
   jle L16e01497
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
L16e01497:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[offset _dx1]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far _trymovey
   add SP,+06
   or AX,AX
   jz L16e014f0
jmp near L16e01a69
L16e014f0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L16e01509
jmp near L16e01625
L16e01509:
   mov word ptr [BP-2A],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jz L16e0156c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   and AX,FFF0
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[offset _dx1]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far _trymovey
   add SP,+06
   or AX,AX
   jnz L16e01571
L16e0156c:
   mov word ptr [BP-2A],0001
L16e01571:
   cmp word ptr [BP-2A],+01
   jz L16e0157a
jmp near L16e01a69
L16e0157a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0006
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+10
   jl L16e015bf
   mov AX,FFF9
jmp near L16e015c2
L16e015bf:
   mov AX,FFFC
L16e015c2:
   push AX
   cmp word ptr [offset _dx1],+00
   jz L16e015cf
   mov AX,0001
jmp near L16e015d1
L16e015cf:
   xor AX,AX
L16e015d1:
   pop DX
   add DX,AX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+11],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,0002
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L16e01a69
L16e01625:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   dec AX
   and AX,FFF0
   mov [BP-2E],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP-2E]
   jnz L16e0166f
L16e01657:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
jmp near L16e01a69
L16e0166f:
   push [BP-2E]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[offset _dx1]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far _trymovey
   add SP,+06
   or AX,AX
   jz L16e016a2
jmp near L16e01a69
L16e016a2:
jmp near L16e01657
L16e016a4:
   cmp word ptr [offset _dx1],+00
   jnz L16e016ae
jmp near L16e017ef
L16e016ae:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jnz L16e016c7
jmp near L16e01a69
L16e016c7:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[offset _dx1]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L16e0170e
jmp near L16e01a69
L16e0170e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[offset _dx1]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far _moveobj
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0002
   mov AX,[offset _dx1]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   cmp word ptr [offset _fire1],+00
   jz L16e017d7
   mov word ptr [offset _fire1off],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
L16e017c8:
   mov AX,0001
   push AX
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L16e01a69
L16e017d7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFC
jmp near L16e01a69
L16e017ef:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jnz L16e0182f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
L16e0182f:
   cmp word ptr [offset _dy1],+00
   jnz L16e01839
jmp near L16e01a11
L16e01839:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-2E],AX
   cmp word ptr [offset _dy1],+00
   jge L16e01877
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+0F]
   lea AX,[BP-20]
   add BX,AX
   mov AL,[SS:BX]
   cbw
   sub [BP-2E],AX
jmp near L16e0187b
L16e01877:
   add word ptr [BP-2E],+04
L16e0187b:
   mov AX,0001
   push AX
   push [BP-2E]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L16e0190d
   cmp word ptr [offset _dy1],+00
   jle L16e018c7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   and AX,FFF0
   add AX,0010
   mov [BP-2E],AX
jmp near L16e018e1
L16e018c7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   dec AX
   and AX,FFF0
   mov [BP-2E],AX
L16e018e1:
   mov AX,0001
   push AX
   push [BP-2E]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jnz L16e0190d
   mov word ptr [BP-2E],0000
L16e0190d:
   cmp word ptr [BP-2E],+00
   jnz L16e01916
jmp near L16e01a11
L16e01916:
   cmp word ptr [offset _dy1],+00
   jge L16e01962
   mov AX,[offset _dy1]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+0F],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jl L16e01977
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
jmp near L16e01977
L16e01962:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0002
L16e01977:
   mov word ptr [BP-2C],0001
   push [BP-2E]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _moveobj
   add SP,+06
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jz L16e01a11
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
L16e01a11:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L16e01a3e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0005
jmp near L16e01a69
L16e01a3e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jle L16e01a69
L16e01a54:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0006
L16e01a69:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L16e01aa7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+1B],AX
L16e01aa7:
   cmp word ptr [offset _fire2],+00
   jnz L16e01ab1
jmp near L16e01cfc
L16e01ab1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+0D]
   shl BX,1
   test word ptr [BX+offset _stateinfo],0001
   jnz L16e01ad1
jmp near L16e01cfc
L16e01ad1:
   mov word ptr [offset _fire2off],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L16e01af0
jmp near L16e01cfc
L16e01af0:
   mov word ptr [BP-30],0000
   mov word ptr [BP-2A],0000
jmp near L16e01b25
L16e01afc:
   mov BX,[BP-2A]
   shl BX,1
   mov AX,[BX+offset _scrnobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],32
   jnz L16e01b1d
   mov AX,0001
jmp near L16e01b1f
L16e01b1d:
   xor AX,AX
L16e01b1f:
   add [BP-30],AX
   inc word ptr [BP-2A]
L16e01b25:
   mov AX,[BP-2A]
   cmp AX,[offset _numscrnobjs]
   jl L16e01afc
   mov AX,0008
   push AX
   call far _invcount
   pop CX
   cmp AX,[BP-30]
   jg L16e01b40
jmp near L16e01bd6
L16e01b40:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+1B]
   mov DX,000C
   mul DX
   pop DX
   add DX,AX
   add DX,+04
   push DX
   mov AX,0032
   push AX
   call far _addobj
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+1B]
   mov DX,0006
   mul DX
   push AX
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,0022
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L16e01cfc
L16e01bd6:
   mov AX,0002
   push AX
   call far _takeinv
   pop CX
   or AX,AX
   jnz L16e01be7
jmp near L16e01ced
L16e01be7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+1B]
   mov DX,000C
   mul DX
   pop DX
   add DX,AX
   add DX,+04
   push DX
   mov AX,0002
   push AX
   call far _addobj
   add SP,+06
   mov [BP-2A],AX
   or AX,AX
   jnz L16e01c46
jmp near L16e01cfc
L16e01c46:
   mov AX,0001
   push AX
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-2A]
   call far _cando
   add SP,+08
   cmp AX,0001
   jnz L16e01cda
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+1B]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0003
   mov AX,0003
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L16e01cfc
L16e01cda:
   push [BP-2A]
   call far _killobj
   pop CX
   mov AX,0002
   push AX
   call far _addinv
   pop CX
L16e01ced:
   mov AX,0008
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L16e01cfc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jz L16e01d3d
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
L16e01d3d:
   xor AX,AX
   push AX
   call far _touchbkgnd
   pop CX
   push [BP-02]
   push CS
   call near offset _calc_scroll
   pop CX
   mov AX,[BP-2C]
jmp near L16e01d5b
L16e01d53:
   cmp word ptr [BP+08],+01
   jnz L16e01d5b
   xor AX,AX
L16e01d5b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_tiny: ;; 16e01d61
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,0003
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jz L16e01d7f
   mov DI,0001
L16e01d7f:
   mov AX,[BP+08]
   or AX,AX
   jz L16e01d91
   cmp AX,0002
   jnz L16e01d8e
jmp near L16e01e62
L16e01d8e:
jmp near L16e02063
L16e01d91:
   mov word ptr [BP-02],1000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L16e01de8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+11]
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L16e01dde
   mov AX,0008
jmp near L16e01de0
L16e01dde:
   xor AX,AX
L16e01de0:
   pop DX
   add DX,AX
   add [BP-02],DX
jmp near L16e01e23
L16e01de8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+11]
   and AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L16e01e1a
   mov AX,0006
jmp near L16e01e1d
L16e01e1a:
   mov AX,0004
L16e01e1d:
   pop DX
   add DX,AX
   add [BP-02],DX
L16e01e23:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-02]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16e02063
L16e01e62:
   cmp word ptr [offset _dx1],+00
   jnz L16e01e73
   cmp word ptr [offset _dy1],+00
   jnz L16e01e73
jmp near L16e0200e
L16e01e73:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+11]
   inc AX
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+11],AX
   mov AX,[offset _dx1]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   cmp word ptr [offset _dx1],+00
   jnz L16e01ec1
jmp near L16e01f79
L16e01ec1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jnz L16e01eda
jmp near L16e01f79
L16e01eda:
   cmp word ptr [offset _dx1],+00
   jle L16e01f0c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+10
   jle L16e01f0c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
jmp near L16e01f3c
L16e01f0c:
   cmp word ptr [offset _dx1],+00
   jge L16e01f44
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+10
   jge L16e01f44
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
L16e01f3c:
   mov word ptr [offset _dx1],0000
jmp near L16e01f79
L16e01f44:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+10
   jnz L16e01f79
   mov AX,DI
   inc AX
   mul word ptr [offset _dx1]
   mov [offset _dx1],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L16e01f79:
   mov AX,[offset _dy1]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,0200
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[offset _dy1]
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[offset _dx1]
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far _cando
   add SP,+08
   or AX,AX
   jz L16e0200e
   mov AX,[offset _dx1]
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+01],AX
   mov AX,[offset _dy1]
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+03],AX
L16e0200e:
   xor AX,AX
   push AX
   push CS
   call near offset _calc_scroll
   pop CX
   cmp word ptr [offset _scrollxd],+00
   jle L16e02039
   mov AX,DI
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
jmp near L16e0205a
L16e02039:
   cmp word ptr [offset _scrollxd],+00
   jge L16e0205a
   mov AX,0010
   sub AX,DI
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
L16e0205a:
   xor AX,AX
   push AX
   call far _touchbkgnd
   pop CX
L16e02063:
   mov AX,0001
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_jillfish: ;; 16e0206c
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[offset _kindtable+2*36]
   mov CL,08
   shl AX,CL
   mov [BP-0A],AX
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,offset Y2a1713a9
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L16e020a5
   cmp AX,0002
   jnz L16e020a2
jmp near L16e02125
L16e020a2:
jmp near L16e02669
L16e020a5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-08]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-0A]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L16e02107
   mov AX,0001
jmp near L16e02109
L16e02107:
   xor AX,AX
L16e02109:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16e02669
L16e02125:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   inc AX
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _fishdo
   add SP,+06
   mov [BP-10],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L16e021c1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0F],AX
L16e021c1:
   mov AX,[offset _dx1]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   cmp word ptr [BP-10],+00
   jnz L16e021e8
jmp near L16e022ea
L16e021e8:
   mov AX,[offset _dy1]
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+02
   jge L16e02209
   mov AX,0001
jmp near L16e0220b
L16e02209:
   xor AX,AX
L16e0220b:
   pop DX
   add DX,AX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   call far _rand
   mov BX,0004
   cwd
   idiv BX
   or DX,DX
   jnz L16e0226c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,FFFE
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0006
   push AX
   mov AX,003A
   push AX
   call far _addobj
   add SP,+06
L16e0226c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jle L16e02297
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L16e0229a
L16e02297:
   mov AX,FFF8
L16e0229a:
   cmp AX,0008
   jle L16e022a4
   mov AX,0008
jmp near L16e022d2
L16e022a4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jle L16e022cf
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L16e022d2
L16e022cf:
   mov AX,FFF8
L16e022d2:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
jmp near L16e02379
L16e022ea:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-10
   jle L16e02329
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L16e0232c
L16e02329:
   mov AX,FFF0
L16e0232c:
   cmp AX,0010
   jle L16e02336
   mov AX,0010
jmp near L16e02364
L16e02336:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-10
   jle L16e02361
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L16e02364
L16e02361:
   mov AX,FFF0
L16e02364:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L16e02379:
   cmp word ptr [offset _fire1],+00
   jz L16e023b0
   cmp word ptr [BP-10],+00
   jz L16e023b0
   mov word ptr [offset _fire1off],0001
   mov AX,0025
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFE
L16e023b0:
   cmp word ptr [offset _fire2],+00
   jnz L16e023ba
jmp near L16e024cb
L16e023ba:
   mov word ptr [offset _fire2off],0001
   mov AX,0026
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L16e02411
   mov AX,0001
jmp near L16e02413
L16e02411:
   xor AX,AX
L16e02413:
   mov CL,05
   shl AX,CL
   pop DX
   add DX,AX
   add DX,-08
   push DX
   mov AX,003F
   push AX
   call far _addobj
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L16e02445
   mov AX,0001
jmp near L16e02447
L16e02445:
   xor AX,AX
L16e02447:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L16e02463
   mov AX,0001
jmp near L16e02465
L16e02463:
   xor AX,AX
L16e02465:
   pop DX
   sub DX,AX
   shl DX,1
   shl DX,1
   shl DX,1
   push DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L16e0248a
   mov AX,0001
jmp near L16e0248c
L16e0248a:
   xor AX,AX
L16e0248c:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L16e024a8
   mov AX,0001
jmp near L16e024aa
L16e024a8:
   xor AX,AX
L16e024aa:
   pop DX
   sub DX,AX
   shl DX,1
   shl DX,1
   pop AX
   add AX,DX
   push AX
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L16e024cb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+08
   jle L16e024f8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0008
jmp near L16e02523
L16e024f8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jge L16e02523
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF8
L16e02523:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   mov [BP-0E],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+07]
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jz L16e02598
jmp near L16e0263f
L16e02598:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L16e025bb
   mov AX,DI
   add AX,0010
   and AX,FFF0
   mov [BP-0C],AX
jmp near L16e025f1
L16e025bb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L16e025f1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,DI
   and AX,FFF0
   add AX,0010
   mov DX,[ES:BX+0B]
   sub AX,DX
   mov [BP-0C],AX
L16e025f1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jz L16e0263f
   push [BP-0C]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L16e0263f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L16e0263f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   push [BP-0E]
   push SI
   call far _fishdo
   add SP,+06
   xor AX,AX
   push AX
   push CS
   call near offset _calc_scroll
   pop CX
   mov AX,0001
L16e02669:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_jillspider: ;; 16e0266f
   push BP
   mov BP,SP
   mov AX,[BP+08]
   cmp AX,0002
   jz L16e0267c
jmp near L16e0267e
L16e0267c:
   xor AX,AX
L16e0267e:
   pop BP
ret far

_msg_jillfrog: ;; 16e02680
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L16e0269d
   cmp AX,0002
   jnz L16e0269a
jmp near L16e0275b
L16e0269a:
jmp near L16e029a1
L16e0269d:
   mov AX,[offset _kindtable+2*39]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jle L16e026bf
   xor AX,AX
jmp near L16e026c2
L16e026bf:
   mov AX,0003
L16e026c2:
   pop DX
   add DX,AX
   mov [BP-04],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L16e0271f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L16e026f9
   mov AX,0002
jmp near L16e026fb
L16e026f9:
   xor AX,AX
L16e026fb:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L16e02717
   mov AX,0001
jmp near L16e02719
L16e02717:
   xor AX,AX
L16e02719:
   pop DX
   add DX,AX
   add [BP-04],DX
L16e0271f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-04]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16e029a1
L16e0275b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L16e02799
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+1B],AX
L16e02799:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],0007
   jnz L16e027c6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L16e027e4
L16e027c6:
   mov AX,[offset _dx1]
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L16e02802
L16e027e4:
   mov AX,[offset _dx1]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L16e02802:
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   cmp AX,0003
   jz L16e02896
   cmp word ptr [offset _fire1],+00
   jnz L16e0284a
   cmp word ptr [offset _fire2],+00
   jz L16e02870
L16e0284a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
   mov AX,002B
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L16e028c7
L16e02870:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF8
   mov AX,0012
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L16e028c7
L16e02896:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+07]
   mov AX,[ES:BX+07]
   cmp AX,000C
   jle L16e028c7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L16e028c7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   mov [BP-02],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+07]
   push DI
   push [BP-02]
   push SI
   call far _trymove
   add SP,+06
   test AX,0003
   jnz L16e02996
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jl L16e02981
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,DI
   and AX,FFF0
   add AX,0010
   mov DX,[ES:BX+0B]
   sub AX,DX
   mov DI,AX
   push DI
   push [BP-02]
   push SI
   call far _trymove
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L16e02981:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L16e02996:
   xor AX,AX
   push AX
   push CS
   call near offset _calc_scroll
   pop CX
   mov AX,0001
L16e029a1:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_jillbird: ;; 16e029a7
   push BP
   mov BP,SP
   sub SP,+12
   push SI
   push DI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,offset Y2a1713b1
   push AX
   mov CX,000C
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L16e029d6
   cmp AX,0002
   jnz L16e029d3
jmp near L16e02a5d
L16e029d3:
jmp near L16e02e71
L16e029d6:
   mov AX,[offset _kindtable+2*1e]
   mov CL,08
   shl AX,CL
   mov [BP-12],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-0C]
   add BX,AX
   mov AX,[SS:BX]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L16e02a19
   mov AX,0004
jmp near L16e02a1b
L16e02a19:
   xor AX,AX
L16e02a1b:
   pop DX
   add DX,AX
   add [BP-12],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-12]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L16e02e71
L16e02a5d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L16e02a9b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0F],AX
L16e02a9b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0006
   jl L16e02acc
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L16e02acc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],0007
   jnz L16e02af9
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L16e02b17
L16e02af9:
   mov AX,[offset _dx1]
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L16e02b35
L16e02b17:
   mov AX,[offset _dx1]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L16e02b35:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+07]
   cmp word ptr [offset _fire1],+00
   jnz L16e02b56
   cmp word ptr [offset _fire2],+00
   jz L16e02b80
L16e02b56:
   mov word ptr [offset _fire1off],0001
   mov AX,000F
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFA
L16e02b80:
   cmp word ptr [offset _fire2],+00
   jnz L16e02b8a
jmp near L16e02c90
L16e02b8a:
   mov word ptr [offset _fire2off],0001
   mov AX,0022
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L16e02bcd
   mov AX,0001
jmp near L16e02bcf
L16e02bcd:
   xor AX,AX
L16e02bcf:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L16e02beb
   mov AX,0001
jmp near L16e02bed
L16e02beb:
   xor AX,AX
L16e02bed:
   mov DX,AX
   pop AX
   sub AX,DX
   mov DX,0018
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+01]
   push AX
   mov AX,003E
   push AX
   call far _addobj
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L16e02c34
   mov AX,0001
jmp near L16e02c36
L16e02c34:
   xor AX,AX
L16e02c36:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L16e02c52
   mov AX,0001
jmp near L16e02c54
L16e02c52:
   xor AX,AX
L16e02c54:
   pop DX
   sub DX,AX
   shl DX,1
   shl DX,1
   shl DX,1
   mov AX,[offset _numobjs]
   dec AX
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,[offset _dy1]
   shl AX,1
   push AX
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L16e02c90:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+08
   jle L16e02cbd
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0008
jmp near L16e02ce8
L16e02cbd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jge L16e02ce8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF8
L16e02ce8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   add DI,[ES:BX+05]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   push DI
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L16e02d42
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+01]
L16e02d42:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L16e02d5b
jmp near L16e02e1f
L16e02d5b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   mov [BP-10],AX
   push AX
   push DI
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jz L16e02d98
jmp near L16e02e1f
L16e02d98:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L16e02dbc
   mov AX,[BP-10]
   add AX,0010
   and AX,FFF0
   mov [BP-0E],AX
jmp near L16e02df3
L16e02dbc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L16e02df3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[BP-10]
   and AX,FFF0
   add AX,0010
   mov DX,[ES:BX+0B]
   sub AX,DX
   mov [BP-0E],AX
L16e02df3:
   mov AX,[BP-0E]
   cmp AX,[BP-10]
   jz L16e02e0a
   push AX
   push DI
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L16e02e1f
L16e02e0a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L16e02e1f:
   mov AX,4000
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _objdo
   add SP,+08
   cmp AX,4000
   jz L16e02e66
   mov AX,0001
   push AX
   mov AX,0100
   push AX
   call far _p_ouch
   pop CX
   pop CX
L16e02e66:
   xor AX,AX
   push AX
   push CS
   call near offset _calc_scroll
   pop CX
   mov AX,0001
L16e02e71:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_playerxfm: ;; 16e02e77
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   xor SI,SI
   mov [BP-0A],SI
   mov AL,[offset _objs]
   cbw
   mov [BP-08],AX
   mov AX,[offset _objs+09]
   mov [BP-06],AX
   mov AX,[offset _objs+0b]
   mov [BP-04],AX
   mov AX,[BP+06]
   cmp AX,0004
   jz L16e02eab
   cmp AX,0005
   jz L16e02eb2
   cmp AX,0007
   jz L16e02eb9
jmp near L16e02ebe
L16e02eab:
   mov word ptr [BP-0A],0039
jmp near L16e02ebe
L16e02eb2:
   mov word ptr [BP-0A],0038
jmp near L16e02ebe
L16e02eb9:
   mov word ptr [BP-0A],0036
L16e02ebe:
   mov AL,[offset _objs]
   cbw
   cmp AX,[BP-0A]
   jnz L16e02eca
jmp near L16e02fcc
L16e02eca:
   mov AL,[BP-0A]
   mov [offset _objs],AL
   mov BX,[BP-0A]
   shl BX,1
   mov AX,[BX+offset _kindxl]
   mov [offset _objs+09],AX
   mov BX,[BP-0A]
   shl BX,1
   mov AX,[BX+offset _kindyl]
   mov [offset _objs+0b],AX
   mov AX,[offset _objs+01]
   and AX,FFF8
   mov [BP-02],AX
   mov DI,[offset _objs+03]
   add DI,[BP-04]
   sub DI,[offset _objs+0b]
   mov AX,0001
   push AX
   push DI
   push [BP-02]
   xor AX,AX
   push AX
   call far _cando
   add SP,+08
   or AX,AX
   jnz L16e02f2e
   mov DI,[offset _objs+03]
   mov AX,0001
   push AX
   push DI
   push [BP-02]
   xor AX,AX
   push AX
   call far _cando
   add SP,+08
   or AX,AX
   jz L16e02f31
L16e02f2e:
   mov SI,0001
L16e02f31:
   or SI,SI
   jnz L16e02f38
jmp near L16e02fba
L16e02f38:
   push [BP+06]
   call far _addinv
   pop CX
   mov [offset _objs+03],DI
   mov AX,[BP-02]
   mov [offset _objs+01],AX
   mov word ptr [offset _objs+0d],0000
   mov word ptr [offset _objs+0f],0000
   mov word ptr [offset _objs+13],0000
   mov word ptr [offset _objs+05],0000
   mov word ptr [offset _objs+07],0000
   xor SI,SI
jmp near L16e02f84
L16e02f6d:
   mov BX,SI
   shl BX,1
   cmp word ptr [BX+offset _inv_xfm],+00
   jz L16e02f83
L16e02f78:
   push SI
   call far _takeinv
   pop CX
   or AX,AX
   jnz L16e02f78
L16e02f83:
   inc SI
L16e02f84:
   cmp SI,+0B
   jl L16e02f6d
   mov AX,000A
   push AX
   push [offset _objs+03]
   push [offset _objs+01]
   call far _explode1
   add SP,+06
   mov AX,0007
   push AX
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   push [BX+offset _inv_getmsg+02]
   push [BX+offset _inv_getmsg]
   call far _putbotmsg
   add SP,+06
jmp near L16e02fcc
L16e02fba:
   mov AL,[BP-08]
   mov [offset _objs],AL
   mov AX,[BP-06]
   mov [offset _objs+09],AX
   mov AX,[BP-04]
   mov [offset _objs+0b],AX
L16e02fcc:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 19dd ;; JUNGLE.C:JUNGLE
_fin: ;; 19dd0002
   mov AX,0016
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   call far _fadein
ret far

_fout: ;; 19dd0017
   mov AX,0015
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   call far _fadeout
ret far

_drawkeys: ;; 19dd002c
   mov AL,[offset _objs]
   cbw
   mov CX,0006
   mov BX,offset Y19dd0046
L19dd0036:
   cmp AX,[CS:BX]
   jz L19dd0042
   inc BX
   inc BX
   loop L19dd0036
jmp near L19dd0308
L19dd0042:
jmp near [CS:BX+0C]
Y19dd0046:	dw 0000,0017,0036,0037,0038,0039
		dw L19dd005e,L19dd011f,L19dd0248,L19dd02ae,L19dd017c,L19dd01e2
L19dd005e:
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a171430
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   mov AX,0008
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jz L19dd00c9
   push DS
   mov AX,offset _xbladename
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
jmp near L19dd0308
L19dd00c9:
   mov AX,0002
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jz L19dd00fb
   push DS
   mov AX,offset Y2a171438
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
jmp near L19dd0308
L19dd00fb:
   push DS
   mov AX,offset Y2a171440
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
jmp near L19dd0308
L19dd011f:
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a171448
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171450
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
jmp near L19dd0308
L19dd017c:
   mov AX,0008
   push AX
   mov AX,[offset _pagedraw]
   shl AX,1
   shl AX,1
   mov DX,0007
   sub DX,AX
   push DX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a171458
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171460
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
jmp near L19dd0308
L19dd01e2:
   mov AX,0008
   push AX
   mov AX,[offset _pagedraw]
   shl AX,1
   shl AX,1
   mov DX,0007
   sub DX,AX
   push DX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a171468
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171470
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
jmp near L19dd0308
L19dd0248:
   mov AX,0008
   push AX
   mov AX,[offset _pagedraw]
   mov DX,0006
   mul DX
   mov DX,0007
   sub DX,AX
   push DX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a171478
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171480
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
jmp near L19dd0308
L19dd02ae:
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a171488
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171490
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
L19dd0308:
ret far

_drawcmds: ;; 19dd0309
   mov AX,0008
   push AX
   mov AX,0004
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a171498
   push AX
   mov AX,0001
   push AX
   mov AX,0021
   push AX
   xor AX,AX
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset _v_movename
   push AX
   mov AX,0002
   push AX
   push AX
   mov AX,0005
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,0005
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   mov AX,0009
   push AX
   mov AX,0002
   push AX
   mov AX,0600
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _drawshape
   add SP,+0A
   mov AX,0012
   push AX
   mov AX,0002
   push AX
   mov AX,0601
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _drawshape
   add SP,+0A
   mov AX,001B
   push AX
   mov AX,0002
   push AX
   mov AX,0609
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _drawshape
   add SP,+0A
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a1714a5
   push AX
   mov AX,0002
   push AX
   mov AX,001C
   push AX
   mov AX,001E
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,0003
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a1714aa
   push AX
   mov AX,0001
   push AX
   mov AX,002B
   push AX
   mov AX,0001
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1714ac
   push AX
   mov AX,0001
   push AX
   mov AX,0033
   push AX
   mov AX,0001
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1714ae
   push AX
   mov AX,0001
   push AX
   mov AX,003B
   push AX
   mov AX,0001
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1714b0
   push AX
   mov AX,0001
   push AX
   mov AX,0043
   push AX
   mov AX,0001
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1714b2
   push AX
   mov AX,0001
   push AX
   mov AX,004B
   push AX
   mov AX,0001
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,0002
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a1714b4
   push AX
   mov AX,0002
   push AX
   mov AX,002C
   push AX
   mov AX,000E
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1714ba
   push AX
   mov AX,0002
   push AX
   mov AX,0034
   push AX
   mov AX,000E
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1714bf
   push AX
   mov AX,0002
   push AX
   mov AX,003C
   push AX
   mov AX,000E
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1714c4
   push AX
   mov AX,0002
   push AX
   mov AX,0044
   push AX
   mov AX,000E
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1714cc
   push AX
   mov AX,0002
   push AX
   mov AX,004C
   push AX
   mov AX,000E
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push CS
   call near offset _drawkeys
   call far _drawstats
   or word ptr [offset _statmodflg],C000
ret far

_putbotmsg: ;; 19dd059d
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push DS
   mov AX,offset _botmsg
   push AX
   call far _strcpy
   mov SP,BP
   mov AX,[BP+0A]
   mov [offset _botcol],AX
   mov word ptr [offset _bottime],0050
   or word ptr [offset _statmodflg],C000
   pop BP
ret far

_drawstats: ;; 19dd05c6
   push BP
   mov BP,SP
   sub SP,+20
   push SI
   mov AX,0008
   push AX
   mov AX,FFF9
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   mov AX,002B
   push AX
   mov AX,0035
   push AX
   mov AX,[offset _soundf]
   add AX,060A
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _drawshape
   add SP,+0A
   mov AX,004B
   push AX
   mov AX,0035
   push AX
   mov AX,[offset _turtle]
   add AX,060A
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _drawshape
   add SP,+0A
   cmp word ptr [offset _pl+2a],+00
   jz L19dd0644
   mov AX,0004
   push AX
   mov AX,FFFB
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _fontcolor
   add SP,+08
jmp near L19dd065c
L19dd0644:
   mov AX,0008
   push AX
   mov AX,FFFB
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _fontcolor
   add SP,+08
L19dd065c:
   push [offset _statvp+02]
   push [offset _statvp]
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1714d3
   push AX
   mov AX,0002
   push AX
   push AX
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _wprint
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,FFFC
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _fontcolor
   add SP,+08
   xor SI,SI
jmp near L19dd06c6
L19dd06a2:
   mov AX,0002
   push AX
   mov AX,SI
   mov DX,0003
   mul DX
   add AX,002A
   push AX
   mov AX,offset Y2a170e2a
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _drawshape
   add SP,+0A
   inc SI
L19dd06c6:
   mov AX,[offset _pl+02]
   dec AX
   cmp AX,SI
   jg L19dd06a2
   mov AX,0002
   push AX
   mov AX,[offset _pl+02]
   dec AX
   mov DX,0003
   mul DX
   add AX,0028
   push AX
   mov AX,0E2B
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _drawshape
   add SP,+0A
   push DS
   mov AX,offset Y2a1714da
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0021
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _wprint
   add SP,+0E
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   push [offset _pl+26+02]
   push [offset _pl+26]
   call far _ltoa
   add SP,+0A
   push SS
   lea AX,[BP-20]
   push AX
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _strlen
   pop CX
   pop CX
   mov DX,0006
   mul DX
   inc AX
   mov DX,0040
   sub DX,AX
   push DX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _wprint
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,FFFE
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a1714e0
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0001
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _wprint
   add SP,+0E
   cmp word ptr [offset _pl],+7F
   jnz L19dd07b6
   push DS
   mov AX,offset Y2a1714e6
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _strcpy
   add SP,+08
jmp near L19dd07cd
L19dd07b6:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   mov AX,[offset _pl]
   cwd
   push DX
   push AX
   call far _ltoa
   add SP,+0A
L19dd07cd:
   push SS
   lea AX,[BP-20]
   push AX
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   mov AX,0001
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _wprint
   add SP,+0E
   cmp word ptr [offset _debug],+00
   jz L19dd0847
   cmp word ptr [offset _swrite],+00
   jnz L19dd0847
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _coreleft
   push DX
   push AX
   call far _ltoa
   add SP,+0A
   push DS
   mov AX,offset Y2a1714ea
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _strcat
   add SP,+08
   push SS
   lea AX,[BP-20]
   push AX
   mov AX,0002
   push AX
   mov AX,0040
   push AX
   mov AX,001C
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _wprint
   add SP,+0E
L19dd0847:
   xor SI,SI
jmp near L19dd088d
L19dd084b:
   mov AX,SI
   mov BX,0003
   cwd
   idiv BX
   mov AX,DX
   mov DX,000E
   mul DX
   add AX,001A
   push AX
   mov AX,SI
   cwd
   idiv BX
   mov DX,000E
   mul DX
   inc AX
   push AX
   mov BX,SI
   shl BX,1
   mov BX,[BX+offset _pl+06]
   shl BX,1
   mov AX,[BX+offset _inv_shape]
   add AX,0E00
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _drawshape
   add SP,+0A
   inc SI
L19dd088d:
   cmp SI,[offset _pl+04]
   jl L19dd084b
   push CS
   call near offset _drawkeys
   push DS
   mov AX,offset _botvp
   push AX
   call far _clearvp
   pop CX
   pop CX
   xor AX,AX
   push AX
   push [offset _botcol]
   push DS
   mov AX,offset _botvp
   push AX
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset _botmsg
   push AX
   mov AX,0002
   push AX
   push AX
   push DS
   mov AX,offset _botmsg
   push AX
   call far _strlen
   pop CX
   pop CX
   mov DX,0003
   mul DX
   mov DX,00A0
   sub DX,AX
   push DX
   push DS
   mov AX,offset _botvp
   push AX
   call far _wprint
   add SP,+0E
   pop SI
   mov SP,BP
   pop BP
ret far

_zapobjs: ;; 19dd08ea
   push SI
   xor SI,SI
jmp near L19dd0927
L19dd08ef:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L19dd0926
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far _free
   pop CX
   pop CX
L19dd0926:
   inc SI
L19dd0927:
   cmp SI,[offset _numobjs]
   jl L19dd08ef
   call far _initobjs
   pop SI
ret far

_loadcfg: ;; 19dd0934
   push BP
   mov BP,SP
   sub SP,+40
   push SI
   push DI
   push DS
   mov AX,offset _path
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcpy
   add SP,+08
   push DS
   mov AX,offset _cfgfname
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   mov AX,8001
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far __open
   add SP,+06
   mov DI,AX
   or DI,DI
   jl L19dd0988
   push DI
   call far _filelength
   pop CX
   or DX,DX
   jg L19dd09d6
   jnz L19dd0988
   or AX,AX
   ja L19dd09d6
L19dd0988:
   xor SI,SI
jmp near L19dd09b2
L19dd098c:
   mov AX,SI
   mov DX,000A
   mul DX
   mov BX,AX
   add BX,offset _hiname
   push DS
   pop ES
   mov byte ptr [ES:BX],00
   mov BX,SI
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _hiscore+02],0000
   mov word ptr [BX+offset _hiscore],0000
   inc SI
L19dd09b2:
   cmp SI,+0A
   jl L19dd098c
   xor SI,SI
jmp near L19dd09cf
L19dd09bb:
   mov AX,SI
   mov DX,000C
   mul DX
   mov BX,AX
   add BX,offset _savename
   push DS
   pop ES
   mov byte ptr [ES:BX],00
   inc SI
L19dd09cf:
   cmp SI,+06
   jl L19dd09bb
jmp near L19dd0a22
L19dd09d6:
   mov AX,0078
   push AX
   push DS
   mov AX,offset _hiname
   push AX
   push DI
   call far _read
   add SP,+08
   mov AX,0028
   push AX
   push DS
   mov AX,offset _hiscore
   push AX
   push DI
   call far _read
   add SP,+08
   mov AX,0048
   push AX
   push DS
   mov AX,offset _savename
   push AX
   push DI
   call far _read
   add SP,+08
   mov AX,0016
   push AX
   push DS
   mov AX,offset _cf
   push AX
   push DI
   call far _read
   add SP,+08
   or AX,AX
   jge L19dd0a28
L19dd0a22:
   mov word ptr [offset _cf],0001
L19dd0a28:
   push DI
   call far _close
   pop CX
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_savecfg: ;; 19dd0a35
   push BP
   mov BP,SP
   sub SP,+40
   push SI
   push DS
   mov AX,offset _path
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcpy
   add SP,+08
   push DS
   mov AX,offset _cfgfname
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far __creat
   add SP,+06
   mov SI,AX
   or SI,SI
   jl L19dd0abe
   mov AX,0078
   push AX
   push DS
   mov AX,offset _hiname
   push AX
   push SI
   call far _write
   add SP,+08
   mov AX,0028
   push AX
   push DS
   mov AX,offset _hiscore
   push AX
   push SI
   call far _write
   add SP,+08
   mov AX,0048
   push AX
   push DS
   mov AX,offset _savename
   push AX
   push SI
   call far _write
   add SP,+08
   mov AX,0016
   push AX
   push DS
   mov AX,offset _cf
   push AX
   push SI
   call far _write
   add SP,+08
L19dd0abe:
   push SI
   call far _close
   pop CX
   pop SI
   mov SP,BP
   pop BP
ret far

_loadboard: ;; 19dd0aca
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov SI,0009
jmp near L19dd0ae2
L19dd0ad7:
   mov BX,SI
   shl BX,1
   mov word ptr [BX+offset _shm_want],0000
   inc SI
L19dd0ae2:
   cmp SI,+40
   jl L19dd0ad7
   mov word ptr [offset _shm_want+2*0e],0001
   mov word ptr [offset _shm_want+2*2e],0001
   push [BP+08]
   push [BP+06]
   push DS
   mov AX,offset _curlevel
   push AX
   call far _strcpy
   add SP,+08
   push CS
   call near offset _zapobjs
   mov AX,8001
   push AX
   push [BP+08]
   push [BP+06]
   call far __open
   add SP,+06
   mov DI,AX
   mov AX,4000
   push AX
   push DS
   mov AX,offset _bd
   push AX
   push DI
   call far _read
   add SP,+08
   or AX,AX
   jnz L19dd0b3e
   mov AX,0001
   push AX
   call far _rexit
   pop CX
L19dd0b3e:
   mov AX,0002
   push AX
   push DS
   mov AX,offset _numobjs
   push AX
   push DI
   call far _read
   add SP,+08
   or AX,AX
   jnz L19dd0b5e
   mov AX,0002
   push AX
   call far _rexit
   pop CX
L19dd0b5e:
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   push AX
   push DS
   mov AX,offset _objs
   push AX
   push DI
   call far _read
   add SP,+08
   or AX,AX
   jnz L19dd0b83
   mov AX,0003
   push AX
   call far _rexit
   pop CX
L19dd0b83:
   mov AX,0046
   push AX
   push DS
   mov AX,offset _pl
   push AX
   push DI
   call far _read
   add SP,+08
   or AX,AX
   jnz L19dd0ba3
   mov AX,0004
   push AX
   call far _rexit
   pop CX
L19dd0ba3:
   xor SI,SI
jmp near L19dd0c1e
L19dd0ba7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L19dd0c1d
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   push DI
   call far _read
   add SP,+08
   mov AX,[BP-06]
   inc AX
   push AX
   call far _malloc
   pop CX
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   pop DX
   mov [ES:BX+19],DX
   mov [ES:BX+17],AX
   mov AX,[BP-06]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push DI
   call far _read
   add SP,+08
L19dd0c1d:
   inc SI
L19dd0c1e:
   cmp SI,[offset _numobjs]
   jl L19dd0ba7
   push DI
   call far __close
   pop CX
   mov word ptr [BP-04],0000
jmp near L19dd0c7f
L19dd0c32:
   mov word ptr [BP-02],0000
jmp near L19dd0c76
L19dd0c39:
   mov BX,[BP-04]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   mov BX,[ES:BX]
   and BX,3FFF
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov BX,[ES:BX]
   mov CL,08
   sar BX,CL
   and BX,003F
   shl BX,1
   mov word ptr [BX+offset _shm_want],0001
   inc word ptr [BP-02]
L19dd0c76:
   cmp word ptr [BP-02],+40
   jl L19dd0c39
   inc word ptr [BP-04]
L19dd0c7f:
   cmp word ptr [BP-04],0080
   jl L19dd0c32
   xor SI,SI
jmp near L19dd0cae
L19dd0c8a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov BX,[BX+offset _kindtable]
   shl BX,1
   mov word ptr [BX+offset _shm_want],0001
   inc SI
L19dd0cae:
   cmp SI,[offset _numobjs]
   jl L19dd0c8a
   call far _shm_do
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_saveboard: ;; 19dd0cbf
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   xor AX,AX
   push AX
   push [BP+08]
   push [BP+06]
   call far __creat
   add SP,+06
   mov SI,AX
   or SI,SI
   jge L19dd0ce8
   mov AX,00C9
   push AX
   call far _rexit
   pop CX
L19dd0ce8:
   mov AX,4000
   push AX
   push DS
   mov AX,offset _bd
   push AX
   push SI
   call far _write
   add SP,+08
   or AX,AX
   jge L19dd0d08
   mov AX,00CA
   push AX
   call far _rexit
   pop CX
L19dd0d08:
   mov AX,0002
   push AX
   push DS
   mov AX,offset _numobjs
   push AX
   push SI
   call far _write
   add SP,+08
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   push AX
   push DS
   mov AX,offset _objs
   push AX
   push SI
   call far _write
   add SP,+08
   mov AX,0046
   push AX
   push DS
   mov AX,offset _pl
   push AX
   push SI
   call far _write
   add SP,+08
   xor DI,DI
jmp near L19dd0db9
L19dd0d47:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L19dd0db8
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far _strlen
   pop CX
   pop CX
   mov [BP-02],AX
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   push SI
   call far _write
   add SP,+08
   mov AX,[BP-02]
   inc AX
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push SI
   call far _write
   add SP,+08
L19dd0db8:
   inc DI
L19dd0db9:
   cmp DI,[offset _numobjs]
   jl L19dd0d47
   push SI
   call far __close
   pop CX
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_numlines: ;; 19dd0dcc
   push SI
   push DI
   xor DI,DI
   mov SI,DI
jmp near L19dd0de8
L19dd0dd4:
   les BX,[offset _textmsg]
   cmp byte ptr [ES:BX+SI],0D
   jnz L19dd0de3
   mov AX,0001
jmp near L19dd0de5
L19dd0de3:
   xor AX,AX
L19dd0de5:
   add DI,AX
   inc SI
L19dd0de8:
   cmp SI,[offset _textmsglen]
   jl L19dd0dd4
   mov AX,DI
   pop DI
   pop SI
ret far

_getline: ;; 19dd0df3
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov word ptr [BP-04],0007
   xor SI,SI
   mov DI,SI
jmp near L19dd0e1a
L19dd0e06:
   les BX,[offset _textmsg]
   cmp byte ptr [ES:BX+SI],0D
   jnz L19dd0e15
   mov AX,0001
jmp near L19dd0e17
L19dd0e15:
   xor AX,AX
L19dd0e17:
   add DI,AX
   inc SI
L19dd0e1a:
   cmp DI,[BP+06]
   jge L19dd0e28
   cmp SI,[offset _textmsglen]
   jl L19dd0e06
jmp near L19dd0e28
L19dd0e27:
   inc SI
L19dd0e28:
   les BX,[offset _textmsg]
   cmp byte ptr [ES:BX+SI],20
   jge L19dd0e38
   cmp byte ptr [ES:BX+SI],0D
   jnz L19dd0e27
L19dd0e38:
   les BX,[offset _textmsg]
   cmp byte ptr [ES:BX+SI],30
   jl L19dd0e53
   cmp byte ptr [ES:BX+SI],37
   jg L19dd0e53
   mov AL,[ES:BX+SI]
   cbw
   add AX,FFD0
   mov [BP-04],AX
   inc SI
L19dd0e53:
   xor DI,DI
jmp near L19dd0e7c
L19dd0e57:
   cmp word ptr [BP+0C],+00
   jz L19dd0e71
   mov AL,[BP-01]
   cbw
   push AX
   call far _toupper
   pop CX
   les BX,[BP+08]
   mov [ES:BX+DI],AL
   inc DI
jmp near L19dd0e7b
L19dd0e71:
   mov AL,[BP-01]
   les BX,[BP+08]
   mov [ES:BX+DI],AL
   inc DI
L19dd0e7b:
   inc SI
L19dd0e7c:
   les BX,[offset _textmsg]
   mov AL,[ES:BX+SI]
   mov [BP-01],AL
   cmp AL,0D
   jz L19dd0e95
   cmp SI,[offset _textmsglen]
   jge L19dd0e95
   cmp DI,+4D
   jl L19dd0e57
L19dd0e95:
   les BX,[BP+08]
   mov byte ptr [ES:BX+DI],00
   mov AX,[BP-04]
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_printline: ;; 19dd0ea5
   push BP
   mov BP,SP
   sub SP,+50
   mov AX,0001
   push AX
   push AX
   push SS
   lea AX,[BP-50]
   push AX
   push [BP+0C]
   push CS
   call near offset _getline
   add SP,+08
   push AX
   push [BP+08]
   push [BP+06]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a1714f0
   push AX
   mov AX,0002
   push AX
   push [BP+0A]
   xor AX,AX
   push AX
   push [BP+08]
   push [BP+06]
   call far _wprint
   add SP,+0E
   push SS
   lea AX,[BP-50]
   push AX
   mov AX,0002
   push AX
   push [BP+0A]
   push SS
   lea AX,[BP-50]
   push AX
   call far _strlen
   pop CX
   pop CX
   mov DX,0006
   mul DX
   les BX,[BP+06]
   mov DX,[ES:BX+04]
   sub DX,AX
   shr DX,1
   push DX
   push [BP+08]
   push BX
   call far _wprint
   add SP,+0E
   mov SP,BP
   pop BP
ret far

_ourdelay: ;; 19dd0f24
   push SI
   les BX,[offset _myclock]
   mov SI,[ES:BX]
L19dd0f2c:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,SI
   cmp AX,[offset _xmsgdelay]
   jl L19dd0f2c
   pop SI
ret far

_dotextmsg: ;; 19dd0f3d
   push BP
   mov BP,SP
   sub SP,00AE
   push SI
   push DI
   mov word ptr [offset _dx1hold],0001
   mov word ptr [offset _dy1hold],0001
   push [BP+06]
   call far _text_get
   pop CX
   mov AX,[offset _textmsg]
   or AX,[offset _textmsg+02]
   jnz L19dd0f67
jmp near L19dd1218
L19dd0f67:
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   xor AX,AX
   push AX
   push AX
   push AX
   mov AX,[offset _ourwin+28+06]
   mov BX,0010
   cwd
   idiv BX
   add AX,FFFC
   push AX
   mov AX,[offset _ourwin+28+04]
   cwd
   idiv BX
   add AX,FFFD
   push AX
   mov AX,[offset _ourwin+28+02]
   add AX,BX
   push AX
   mov AX,[offset _ourwin+28+00]
   mov BX,0008
   cwd
   idiv BX
   inc AX
   inc AX
   push AX
   push SS
   lea AX,[BP-00ae]
   push AX
   call far _defwin
   add SP,+12
   push SS
   lea AX,[BP-00ae]
   push AX
   call far _drawwin
   pop CX
   pop CX
   mov AX,0001
   push AX
   mov AX,0007
   push AX
   push SS
   lea AX,[BP-0086]
   push AX
   call far _fontcolor
   add SP,+08
   push SS
   lea AX,[BP-0086]
   push AX
   call far _clearvp
   pop CX
   pop CX
   mov AX,FFFF
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-50]
   push AX
   xor AX,AX
   push AX
   push CS
   call near offset _getline
   add SP,+08
   push AX
   push SS
   lea AX,[BP-0096]
   push AX
   call far _fontcolor
   add SP,+08
   push SS
   lea AX,[BP-50]
   push AX
   push SS
   lea AX,[BP-00ae]
   push AX
   call far _titlewin
   add SP,+08
   xor AX,AX
   push AX
   mov AX,0007
   push AX
   push SS
   lea AX,[BP-0086]
   push AX
   call far _fontcolor
   add SP,+08
   mov AX,[BP-80]
   mov BX,0006
   cwd
   idiv BX
   mov [BP-52],AX
   push CS
   call near offset _numlines
   mov [BP-56],AX
   cmp AX,[BP-52]
   jle L19dd1045
jmp near L19dd10d2
L19dd1045:
   dec AX
   mov DX,0006
   mul DX
   push AX
   mov AX,[BP-80]
   pop DX
   sub AX,DX
   mov BX,0002
   cwd
   idiv BX
   mov [BP-54],AX
   mov SI,0001
jmp near L19dd1076
L19dd1060:
   push SI
   push [BP-54]
   push SS
   lea AX,[BP-0086]
   push AX
   push CS
   call near offset _printline
   add SP,+08
   add word ptr [BP-54],+06
   inc SI
L19dd1076:
   cmp SI,[BP-56]
   jl L19dd1060
   call far _pageflip
   push CS
   call near offset _ourdelay
L19dd1084:
   mov AX,0001
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L19dd1084
   cmp word ptr [offset _dy1],+00
   jnz L19dd1084
   cmp word ptr [offset _key],+00
   jnz L19dd1084
   cmp word ptr [offset _fire1],+00
   jnz L19dd1084
L19dd10aa:
   mov AX,0001
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _key],+20
   jnz L19dd10be
jmp near L19dd11fe
L19dd10be:
   cmp word ptr [offset _key],+0D
   jnz L19dd10c8
jmp near L19dd11fe
L19dd10c8:
   cmp word ptr [offset _fire1],+00
   jz L19dd10aa
jmp near L19dd11fe
L19dd10d2:
   xor DI,DI
   mov [BP-54],DI
   mov SI,0001
jmp near L19dd10f2
L19dd10dc:
   push SI
   push [BP-54]
   push SS
   lea AX,[BP-0086]
   push AX
   push CS
   call near offset _printline
   add SP,+08
   add word ptr [BP-54],+06
   inc SI
L19dd10f2:
   cmp SI,[BP-52]
   jle L19dd10dc
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   mov word ptr [offset _fire1off],0001
L19dd110b:
   mov AX,0001
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L19dd110b
   cmp word ptr [offset _dy1],+00
   jnz L19dd110b
   cmp word ptr [offset _key],+00
   jnz L19dd110b
   push CS
   call near offset _ourdelay
L19dd112e:
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _key],00D1
   jnz L19dd1144
   mov AX,0001
jmp near L19dd1146
L19dd1144:
   xor AX,AX
L19dd1146:
   push AX
   cmp word ptr [offset _key],00C9
   jnz L19dd1154
   mov AX,0001
jmp near L19dd1156
L19dd1154:
   xor AX,AX
L19dd1156:
   pop DX
   sub DX,AX
   add [offset _dx1],DX
   mov AX,[offset _dx1]
   add AX,[offset _dy1]
   jge L19dd1196
   or DI,DI
   jle L19dd1196
   dec DI
   mov AX,0006
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-0086]
   push AX
   call far _scrollvp
   add SP,+08
   mov AX,DI
   inc AX
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-0086]
   push AX
   push CS
   call near offset _printline
   add SP,+08
jmp near L19dd11dc
L19dd1196:
   mov AX,[offset _dx1]
   add AX,[offset _dy1]
   jle L19dd11dc
   mov AX,DI
   add AX,[BP-52]
   cmp AX,[BP-56]
   jge L19dd11dc
   inc DI
   mov AX,FFFA
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-0086]
   push AX
   call far _scrollvp
   add SP,+08
   mov AX,DI
   add AX,[BP-52]
   push AX
   mov AX,[BP-52]
   dec AX
   mov DX,0006
   mul DX
   push AX
   push SS
   lea AX,[BP-0086]
   push AX
   push CS
   call near offset _printline
   add SP,+08
L19dd11dc:
   cmp word ptr [offset _key],+0D
   jz L19dd11f4
   cmp word ptr [offset _key],+1B
   jz L19dd11f4
   cmp word ptr [offset _fire1],+00
   jnz L19dd11f4
jmp near L19dd112e
L19dd11f4:
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
L19dd11fe:
   call far _moddrawboard
   push [offset _textmsg+02]
   push [offset _textmsg]
   call far _free
   pop CX
   pop CX
   mov word ptr [offset _key],0000
L19dd1218:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_initboard: ;; 19dd121e
   push SI
   push DI
   xor SI,SI
jmp near L19dd123c
L19dd1224:
   xor DI,DI
jmp near L19dd1236
L19dd1228:
   xor AX,AX
   push AX
   push DI
   push SI
   call far _setboard
   add SP,+06
   inc DI
L19dd1236:
   cmp DI,+40
   jl L19dd1228
   inc SI
L19dd123c:
   cmp SI,0080
   jl L19dd1224
   les BX,[offset _gamevp]
   mov word ptr [ES:BX+08],0000
   mov word ptr [ES:BX+0A],0000
   pop DI
   pop SI
ret far

_putlevelmsg: ;; 19dd1255
   push BP
   mov BP,SP
   sub SP,+52
   push SI
   push DI
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   mov [offset _levelmsgclock],AX
   cmp word ptr [BP+06],+20
   jl L19dd1270
jmp near L19dd13a6
L19dd1270:
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   les BX,[BX+offset _leveltxt]
   mov [offset _textmsg+02],ES
   mov [offset _textmsg],BX
   push [offset _textmsg+02]
   push BX
   call far _strlen
   pop CX
   pop CX
   mov [offset _textmsglen],AX
   mov AX,[offset _textmsg]
   or AX,[offset _textmsg+02]
   jnz L19dd129e
jmp near L19dd13a6
L19dd129e:
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push DS
   mov AX,offset _levelwin
   push AX
   call far _drawwin
   pop CX
   pop CX
   mov AX,0001
   push AX
   mov AX,0007
   push AX
   push DS
   mov AX,offset _levelwin+28
   push AX
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset _levelwin+28
   push AX
   call far _clearvp
   pop CX
   pop CX
   cmp byte ptr [offset _x_ourmode],04
   jnz L19dd131c
   cmp word ptr [offset _facetable],+00
   jz L19dd131c
   xor SI,SI
jmp near L19dd1317
L19dd12e7:
   mov AX,SI
   sar AX,1
   sar AX,1
   mov CL,04
   shl AX,CL
   push AX
   mov AX,SI
   and AX,0003
   mov CL,04
   shl AX,CL
   push AX
   mov AX,[offset _facetable]
   mov CL,08
   shl AX,CL
   add AX,SI
   add AX,4000
   push AX
   push DS
   mov AX,offset _levelwin+38
   push AX
   call far _drawshape
   add SP,+0A
   inc SI
L19dd1317:
   cmp SI,+10
   jl L19dd12e7
L19dd131c:
   push CS
   call near offset _numlines
   mov DI,AX
   mov AX,DI
   dec AX
   mov DX,0006
   mul DX
   push AX
   mov AX,[offset _levelwin+28+06]
   pop DX
   sub AX,DX
   mov BX,0002
   cwd
   idiv BX
   mov [BP-02],AX
   xor SI,SI
jmp near L19dd1398
L19dd133e:
   mov AX,0001
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-52]
   push AX
   push SI
   push CS
   call near offset _getline
   add SP,+08
   push AX
   push DS
   mov AX,offset _levelwin+28
   push AX
   call far _fontcolor
   add SP,+08
   push SS
   lea AX,[BP-52]
   push AX
   mov AX,0002
   push AX
   push [BP-02]
   push SS
   lea AX,[BP-52]
   push AX
   call far _strlen
   pop CX
   pop CX
   mov DX,0006
   mul DX
   mov DX,[offset _levelwin+28+04]
   sub DX,AX
   shr DX,1
   push DX
   push DS
   mov AX,offset _levelwin+28
   push AX
   call far _wprint
   add SP,+0E
   add word ptr [BP-02],+06
   inc SI
L19dd1398:
   cmp SI,DI
   jl L19dd133e
   call far _pageflip
   call far _moddrawboard
L19dd13a6:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_donelevelmsg: ;; 19dd13ac
   push SI
   push DI
   xor SI,SI
L19dd13b0:
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _key],+00
   jnz L19dd13b0
L19dd13c0:
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,[offset _levelmsgclock]
   mov BX,0012
   cwd
   idiv BX
   mov DI,AX
   cmp word ptr [offset _key],+1B
   jz L19dd1402
   cmp word ptr [offset _key],+0D
   jz L19dd1402
   cmp DI,+02
   jl L19dd13fd
   cmp word ptr [offset _key],+00
   jnz L19dd1402
   cmp word ptr [offset _fire1],+00
   jnz L19dd1402
L19dd13fd:
   cmp DI,+04
   jl L19dd1405
L19dd1402:
   mov SI,0001
L19dd1405:
   or SI,SI
   jz L19dd13c0
   pop DI
   pop SI
ret far

_drawcell: ;; 19dd140c
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   or SI,SI
   jge L19dd1421
jmp near L19dd14a3
L19dd1421:
   cmp SI,0080
   jl L19dd142a
jmp near L19dd14a3
L19dd142a:
   or DI,DI
   jl L19dd14a3
   cmp DI,+40
   jge L19dd14a3
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-02],AX
   mov BX,AX
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   test word ptr [ES:BX+02],0010
   jnz L19dd1496
   mov AX,DI
   mov CL,04
   shl AX,CL
   push AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   push AX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   push [ES:BX]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
jmp near L19dd14a3
L19dd1496:
   xor AX,AX
   push AX
   push DI
   push SI
   call far _msg_block
   add SP,+06
L19dd14a3:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_drawboard: ;; 19dd14a9
   push SI
   push DI
   xor SI,SI
jmp near L19dd14c3
L19dd14af:
   xor DI,DI
jmp near L19dd14bd
L19dd14b3:
   push DI
   push SI
   call far _modboard
   pop CX
   pop CX
   inc DI
L19dd14bd:
   cmp DI,+40
   jl L19dd14b3
   inc SI
L19dd14c3:
   cmp SI,0080
   jl L19dd14af
   xor AX,AX
   push AX
   call far _updobjs
   pop CX
   mov word ptr [offset _statmodflg],0000
   xor AX,AX
   push AX
   call far _refresh
   pop CX
   pop DI
   pop SI
ret far

_moddrawboard: ;; 19dd14e4
   push SI
   push DI
   xor SI,SI
jmp near L19dd14fe
L19dd14ea:
   xor DI,DI
jmp near L19dd14f8
L19dd14ee:
   push DI
   push SI
   call far _modboard
   pop CX
   pop CX
   inc DI
L19dd14f8:
   cmp DI,+40
   jl L19dd14ee
   inc SI
L19dd14fe:
   cmp SI,0080
   jl L19dd14ea
   or word ptr [offset _statmodflg],C000
   pop DI
   pop SI
ret far

_play: ;; 19dd150d
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   xor SI,SI
   mov [BP-04],SI
   mov AX,0004
   push AX
   push DS
   mov AX,offset Y2a171515
   push AX
   push CS
   call near offset _putbotmsg
   add SP,+06
   call far _initinv
   call far _setorigin
   push CS
   call near offset _drawcmds
   push CS
   call near offset _drawstats
   mov byte ptr [offset _newlevel],00
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   call far _dolevelsong
   mov word ptr [offset _gameover],0000
L19dd1556:
   cmp byte ptr [offset _newlevel],00
   jnz L19dd1560
jmp near L19dd175e
L19dd1560:
   cmp byte ptr [offset _newlevel],2A
   jnz L19dd159b
   push DS
   mov AX,offset _newlevel
   push AX
   call far _strlen
   pop CX
   pop CX
   push AX
   push DS
   mov AX,offset _newlevel+1
   push AX
   push DS
   mov AX,offset _newlevel
   push AX
   call far _memmove
   add SP,+0A
   push DS
   mov AX,offset _newlevel
   push AX
   push DS
   mov AX,offset _oursong
   push AX
   call far _strcpy
   add SP,+08
jmp near L19dd1616
L19dd159b:
   cmp byte ptr [offset _newlevel],23
   jnz L19dd15c3
   push DS
   mov AX,offset _newlevel
   push AX
   call far _strlen
   pop CX
   pop CX
   push AX
   push DS
   mov AX,offset _newlevel+1
   push AX
   push DS
   mov AX,offset _newlevel
   push AX
   call far _memmove
   add SP,+0A
jmp near L19dd15fb
L19dd15c3:
   cmp byte ptr [offset _newlevel],26
   jnz L19dd162a
   push DS
   mov AX,offset _newlevel
   push AX
   call far _strlen
   pop CX
   pop CX
   push AX
   push DS
   mov AX,offset _newlevel+1
   push AX
   push DS
   mov AX,offset _newlevel
   push AX
   call far _memmove
   add SP,+0A
   mov word ptr [offset _macabort],0002
   push DS
   mov AX,offset _newlevel
   push AX
   call far _playmac
   pop CX
   pop CX
L19dd15fb:
   push DS
   mov AX,offset _newlevel
   push AX
   push DS
   mov AX,offset _oursong
   push AX
   call far _strcpy
   add SP,+08
   call far _sb_playing
   or AX,AX
   jnz L19dd1622
L19dd1616:
   push DS
   mov AX,offset _newlevel
   push AX
   call far _sb_playtune
   pop CX
   pop CX
L19dd1622:
   mov byte ptr [offset _newlevel],00
jmp near L19dd175e
L19dd162a:
   cmp byte ptr [offset _newlevel],21
   jz L19dd1634
jmp near L19dd1713
L19dd1634:
   xor AX,AX
   push AX
   push CS
   call near offset _putlevelmsg
   pop CX
   mov AX,0003
   push AX
   call far _invcount
   pop CX
   mov DI,AX
   mov [BP-06],DI
   mov AX,[offset _pl+26]
   mov [BP-02],AX
   push DS
   mov AX,offset _tempname
   push AX
   push CS
   call near offset _loadboard
   pop CX
   pop CX
   mov AX,[BP-02]
   cwd
   mov [offset _pl+26+02],DX
   mov [offset _pl+26],AX
   push DS
   mov AX,offset _tempname
   push AX
   call far _unlink
   pop CX
   pop CX
jmp near L19dd167f
L19dd1675:
   mov AX,0003
   push AX
   call far _addinv
   pop CX
L19dd167f:
   mov AX,DI
   dec DI
   or AX,AX
   jg L19dd1675
   mov byte ptr [offset _newlevel],00
   xor AX,AX
   push AX
   call far _p_reenter
   pop CX
   push [offset _pl]
   call far _findcheckpt
   pop CX
   mov DI,AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   cmp AX,0001
   jz L19dd16ba
jmp near L19dd16c0
L19dd16ba:
   cmp word ptr [BP-06],+00
   jle L19dd16ca
L19dd16c0:
   push DI
   call far _killobj
   pop CX
jmp near L19dd175a
L19dd16ca:
   mov AX,0004
   push AX
   push DS
   mov AX,offset Y2a171528
   push AX
   push CS
   call near offset _putbotmsg
   add SP,+06
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   xor AX,AX
   push AX
   call far _moveobj
   add SP,+06
   mov word ptr [offset _pl],0000
jmp near L19dd175a
L19dd1713:
   mov AX,[offset _pl]
   mov [offset _oldlevelnum],AX
   push AX
   push CS
   call near offset _putlevelmsg
   pop CX
   push DS
   mov AX,offset _tempname
   push AX
   push CS
   call near offset _saveboard
   pop CX
   pop CX
   mov AX,[offset _pl+26]
   mov [BP-02],AX
   push DS
   mov AX,offset _newlevel
   push AX
   push CS
   call near offset _loadboard
   pop CX
   pop CX
   mov AX,[BP-02]
   cwd
   mov [offset _pl+26+02],DX
   mov [offset _pl+26],AX
   mov byte ptr [offset _newlevel],00
   mov AX,[offset _oldlevelnum]
   mov [offset _pl],AX
   xor AX,AX
   push AX
   call far _p_reenter
   pop CX
L19dd175a:
   push CS
   call near offset _donelevelmsg
L19dd175e:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   mov [BP-0A],AX
   call far _sb_update
   inc word ptr [offset _gamecount]
   mov AX,0001
   push AX
   call far _checkctrl
   pop CX
   push [offset _key]
   call far _toupper
   pop CX
   mov [offset _key],AX
   or AX,AX
   jnz L19dd178f
jmp near L19dd187a
L19dd178f:
   cmp SI,+2F
   jnz L19dd17db
   cmp word ptr [BP-04],+02
   jnz L19dd17db
   xor SI,SI
   cmp AX,0030
   jz L19dd17ad
   cmp AX,0043
   jz L19dd17c9
   cmp AX,0052
   jz L19dd17bb
jmp near L19dd17d5
L19dd17ad:
   cmp word ptr [offset _macrecord],+00
   jz L19dd17d5
   call far _macrecend
jmp near L19dd17d5
L19dd17bb:
   push DS
   mov AX,offset Y2a171548
   push AX
   call far _recordmac
   pop CX
   pop CX
jmp near L19dd17d5
L19dd17c9:
   push DS
   mov AX,offset Y2a171551
   push AX
   call far _playmac
   pop CX
   pop CX
L19dd17d5:
   mov word ptr [offset _key],0000
L19dd17db:
   mov AX,[offset _key]
   cmp AX,SI
   jnz L19dd17e7
   inc word ptr [BP-04]
jmp near L19dd17f0
L19dd17e7:
   mov word ptr [BP-04],0001
   mov SI,[offset _key]
L19dd17f0:
   cmp SI,+58
   jnz L19dd1835
   cmp word ptr [BP-04],+03
   jnz L19dd1835
   xor SI,SI
   mov word ptr [offset _pl+02],0008
   mov AX,000A
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jnz L19dd181b
   mov AX,000A
   push AX
   call far _addinv
   pop CX
L19dd181b:
   mov AX,0001
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jnz L19dd184d
   mov AX,0001
   push AX
   call far _addinv
   pop CX
jmp near L19dd184d
L19dd1835:
   cmp SI,+5A
   jnz L19dd1855
   cmp word ptr [BP-04],+03
   jnz L19dd1855
   xor SI,SI
   mov AX,[offset _debug]
   neg AX
   sbb AX,AX
   inc AX
   mov [offset _debug],AX
L19dd184d:
   or word ptr [offset _statmodflg],C000
jmp near L19dd187a
L19dd1855:
   cmp SI,+57
   jnz L19dd187a
   cmp word ptr [BP-04],+03
   jnz L19dd187a
   call far _getkey
   mov AX,[offset _key]
   add AX,FFD0
   push AX
   call far _pixwrite
   pop CX
   mov word ptr [offset _swrite],0001
   xor SI,SI
L19dd187a:
   mov AX,[offset _key]
   cmp AX,004E
   jz L19dd188e
   cmp AX,0050
   jz L19dd18ae
   cmp AX,0054
   jz L19dd189b
jmp near L19dd18df
L19dd188e:
   mov AX,[offset _soundf]
   neg AX
   sbb AX,AX
   inc AX
   mov [offset _soundf],AX
jmp near L19dd18a6
L19dd189b:
   mov AX,[offset _turtle]
   neg AX
   sbb AX,AX
   inc AX
   mov [offset _turtle],AX
L19dd18a6:
   or word ptr [offset _statmodflg],C000
jmp near L19dd18df
L19dd18ae:
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   call far _sb_update
   cmp word ptr [offset _key],+00
   jnz L19dd18df
   cmp word ptr [offset _fire1],+00
   jnz L19dd18df
   cmp word ptr [offset _fire2],+00
   jnz L19dd18df
   cmp word ptr [offset _dx1],+00
   jnz L19dd18df
   cmp word ptr [offset _dy1],+00
   jz L19dd18ae
L19dd18df:
   cmp word ptr [BP+06],+00
   jz L19dd190e
   cmp word ptr [offset _xdemoflag],+00
   jnz L19dd190e
   mov AX,0043
   push AX
   call far _countobj
   pop CX
   or AX,AX
   jnz L19dd190e
   push [offset _objs+03]
   push [offset _objs+01]
   mov AX,0043
   push AX
   call far _addobj
   add SP,+06
L19dd190e:
   call far _updbkgnd
   mov AX,0001
   push AX
   call far _updobjs
   pop CX
   call far _updbotmsg
   push [offset _pagemode]
   call far _refresh
   pop CX
   call far _purgeobjs
   push [offset _key]
   call far _toupper
   pop CX
   mov CX,0005
   mov BX,offset Y19dd1951
L19dd1941:
   cmp AX,[CS:BX]
   jz L19dd194d
   inc BX
   inc BX
   loop L19dd1941
jmp near L19dd19f1
L19dd194d:
jmp near [CS:BX+0A]
Y19dd1951:	dw 001b,0051,0052,0053,00bb
		dw L19dd19d2,L19dd19d2,L19dd198c,L19dd1965,L19dd19c7
L19dd1965:
   mov AX,[offset _pagedraw]
   mov [BP-08],AX
   mov AX,[offset _pageshow]
   mov [offset _pagedraw],AX
   call far _setpages
   call far _savegame
   push CS
   call near offset _drawcmds
   mov AX,[BP-08]
   mov [offset _pagedraw],AX
   call far _setpages
jmp near L19dd19bf
L19dd198c:
   mov AX,[offset _pagedraw]
   mov [BP-08],AX
   mov AX,[offset _pageshow]
   mov [offset _pagedraw],AX
   call far _setpages
   call far _loadgame
   call far _dolevelsong
   push CS
   call near offset _drawcmds
   mov AX,[BP-08]
   mov [offset _pagedraw],AX
   call far _setpages
   call far _setorigin
   push CS
   call near offset _moddrawboard
L19dd19bf:
   mov word ptr [offset _key],0020
jmp near L19dd19f1
L19dd19c7:
   mov AX,0001
   push AX
   push CS
   call near offset _dotextmsg
   pop CX
jmp near L19dd19f1
L19dd19d2:
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   call far _askquit
   mov [offset _gameover],AX
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _moddrawboard
L19dd19f1:
   cmp word ptr [BP+06],+00
   jz L19dd1a04
   cmp word ptr [offset _macplay],+00
   jnz L19dd1a04
   mov word ptr [offset _gameover],0001
L19dd1a04:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,[BP-0A]
   mov DX,[offset _turtle]
   inc DX
   cmp AX,DX
   jl L19dd1a04
   cmp word ptr [offset _gameover],+00
   jnz L19dd1a21
jmp near L19dd1556
L19dd1a21:
   mov word ptr [offset _key],0000
   cmp word ptr [offset _gameover],+02
   jnz L19dd1a38
   mov AX,00C8
   push AX
   call far _pageview
   pop CX
L19dd1a38:
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   cmp word ptr [BP+06],+00
   jnz L19dd1a51
   mov AX,0001
   push AX
   call far _printhi
   pop CX
L19dd1a51:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_pleasewait: ;; 19dd1a57
   push BP
   mov BP,SP
   sub SP,+58
   push SI
   push DI
   call far _clrpal
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   cmp byte ptr [offset _xshafile],6F
   jnz L19dd1a7f
   cmp byte ptr [offset _x_ourmode],04
   jnz L19dd1a7f
jmp near L19dd1c66
L19dd1a7f:
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   mov AX,0003
   push AX
   mov AX,000B
   push AX
   mov AX,0038
   push AX
   mov AX,0006
   push AX
   push SS
   lea AX,[BP-58]
   push AX
   call far _defwin
   add SP,+12
   push SS
   lea AX,[BP-58]
   push AX
   call far _drawwin
   pop CX
   pop CX
   mov AX,FFFF
   push AX
   mov AX,000F
   push AX
   push SS
   lea AX,[BP-30]
   push AX
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a17155a
   push AX
   mov AX,0002
   push AX
   mov AX,0003
   push AX
   mov AX,0020
   push AX
   push SS
   lea AX,[BP-30]
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset _v_publisher
   push AX
   mov AX,0001
   push AX
   mov AX,000A
   push AX
   mov AX,001E
   push AX
   push SS
   lea AX,[BP-30]
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a17156d
   push AX
   mov AX,0002
   push AX
   mov AX,0020
   push AX
   mov AX,0030
   push AX
   push SS
   lea AX,[BP-30]
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset _v_producer
   push AX
   mov AX,0002
   push AX
   mov AX,0027
   push AX
   mov AX,0030
   push AX
   push SS
   lea AX,[BP-30]
   push AX
   call far _wprint
   add SP,+0E
   mov AX,FFFF
   push AX
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-30]
   push AX
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset _v_title
   push AX
   mov AX,0001
   push AX
   mov AX,0015
   push AX
   push DS
   mov AX,offset _v_title
   push AX
   call far _strlen
   pop CX
   pop CX
   shl AX,1
   shl AX,1
   shl AX,1
   mov DX,[BP-2C]
   sub DX,AX
   shr DX,1
   push DX
   push SS
   lea AX,[BP-30]
   push AX
   call far _wprint
   add SP,+0E
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a171579
   push AX
   mov AX,0002
   push AX
   mov AX,00A0
   push AX
   mov AX,0040
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _wprint
   add SP,+0E
   cmp byte ptr [offset _xshafile],6F
   jz L19dd1bc2
jmp near L19dd1c50
L19dd1bc2:
   xor SI,SI
jmp near L19dd1c48
L19dd1bc7:
   xor AX,AX
   push AX
   mov AX,SI
   mov CL,05
   shl AX,CL
   push AX
   mov AX,SI
   add AX,0C06
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _drawshape
   add SP,+0A
   xor AX,AX
   push AX
   mov AX,SI
   mov CL,05
   shl AX,CL
   mov DX,0130
   sub DX,AX
   push DX
   mov AX,SI
   add AX,0C06
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _drawshape
   add SP,+0A
   mov AX,00A8
   push AX
   mov AX,SI
   mov CL,05
   shl AX,CL
   push AX
   mov AX,SI
   add AX,0C00
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _drawshape
   add SP,+0A
   mov AX,00A8
   push AX
   mov AX,SI
   mov CL,05
   shl AX,CL
   mov DX,0130
   sub DX,AX
   push DX
   mov AX,SI
   add AX,0C00
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _drawshape
   add SP,+0A
   inc SI
L19dd1c48:
   cmp SI,+05
   jg L19dd1c50
jmp near L19dd1bc7
L19dd1c50:
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   call far _fadein
jmp near L19dd1d90
L19dd1c66:
   mov word ptr [offset _shm_want+2*22],0001
   call far _shm_do
   mov AL,00
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clrvp
   add SP,+06
   xor SI,SI
jmp near L19dd1cb8
L19dd1c85:
   xor DI,DI
jmp near L19dd1cb2
L19dd1c89:
   mov AX,DI
   mov CL,04
   shl AX,CL
   push AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   push AX
   mov AX,DI
   mov DX,0013
   mul DX
   add AX,SI
   add AX,6201
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _drawshape
   add SP,+0A
   inc DI
L19dd1cb2:
   cmp DI,+0C
   jl L19dd1c89
   inc SI
L19dd1cb8:
   cmp SI,+13
   jl L19dd1c85
   call far _clrpal
   call far _pageflip
   call far _fadein
   les BX,[offset _myclock]
   mov SI,[ES:BX]
L19dd1cd3:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,SI
   cmp AX,0050
   jl L19dd1cd3
   call far _fadeout
   mov AL,00
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clrvp
   add SP,+06
   call far _pageflip
   mov AL,00
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clrvp
   add SP,+06
   mov word ptr [offset _shm_want+2*2f],0001
   mov word ptr [offset _shm_want+2*22],0000
   call far _shm_do
   xor SI,SI
jmp near L19dd1d53
L19dd1d20:
   xor DI,DI
jmp near L19dd1d4d
L19dd1d24:
   mov AX,DI
   mov CL,04
   shl AX,CL
   push AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   push AX
   mov AX,DI
   mov DX,0013
   mul DX
   add AX,SI
   add AX,6F01
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _drawshape
   add SP,+0A
   inc DI
L19dd1d4d:
   cmp DI,+0C
   jl L19dd1d24
   inc SI
L19dd1d53:
   cmp SI,+13
   jl L19dd1d20
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   call far _clrpal
   call far _pageflip
   call far _fadein
   les BX,[offset _myclock]
   mov SI,[ES:BX]
L19dd1d77:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,SI
   cmp AX,003C
   jl L19dd1d77
   mov word ptr [offset _shm_want+2*2f],0000
   call far _shm_do
L19dd1d90:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_printhi: ;; 19dd1d96
   push BP
   mov BP,SP
   sub SP,+14
   push SI
   push DI
   cmp word ptr [BP+06],+00
   jz L19dd1da9
   mov AX,0004
jmp near L19dd1dac
L19dd1da9:
   mov AX,0008
L19dd1dac:
   mov [BP-02],AX
   cmp word ptr [BP+06],+00
   jnz L19dd1db8
jmp near L19dd1e5b
L19dd1db8:
   mov DI,000A
jmp near L19dd1dbe
L19dd1dbd:
   dec DI
L19dd1dbe:
   or DI,DI
   jle L19dd1ddf
   mov BX,DI
   dec BX
   shl BX,1
   shl BX,1
   mov DX,[BX+offset _hiscore+02]
   mov AX,[BX+offset _hiscore]
   cmp DX,[offset _pl+26+02]
   jl L19dd1dbd
   jnz L19dd1ddf
   cmp AX,[offset _pl+26]
   jb L19dd1dbd
L19dd1ddf:
   cmp DI,+0A
   jl L19dd1deb
   mov word ptr [BP+06],0000
jmp near L19dd1e5b
L19dd1deb:
   mov SI,0008
jmp near L19dd1e2f
L19dd1df0:
   mov BX,SI
   shl BX,1
   shl BX,1
   mov DX,[BX+offset _hiscore+02]
   mov AX,[BX+offset _hiscore]
   mov BX,SI
   inc BX
   shl BX,1
   shl BX,1
   mov [BX+offset _hiscore+02],DX
   mov [BX+offset _hiscore],AX
   push DS
   mov AX,SI
   mov DX,000A
   mul DX
   add AX,offset _hiname
   push AX
   push DS
   mov AX,SI
   inc AX
   mov DX,000A
   mul DX
   add AX,offset _hiname
   push AX
   call far _strcpy
   add SP,+08
   dec SI
L19dd1e2f:
   cmp SI,DI
   jge L19dd1df0
   mov DX,[offset _pl+26+02]
   mov AX,[offset _pl+26]
   mov BX,DI
   shl BX,1
   shl BX,1
   mov [BX+offset _hiscore+02],DX
   mov [BX+offset _hiscore],AX
   mov AX,DI
   mov DX,000A
   mul DX
   mov BX,AX
   add BX,offset _hiname
   push DS
   pop ES
   mov byte ptr [ES:BX],00
L19dd1e5b:
   push [BP-02]
   mov AX,0005
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a171595
   push AX
   mov AX,0001
   push AX
   mov AX,0004
   push AX
   xor AX,AX
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push [BP-02]
   mov AX,0004
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a1715a2
   push AX
   mov AX,0002
   push AX
   push AX
   mov AX,0004
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push [BP-02]
   mov AX,0002
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   xor SI,SI
jmp near L19dd1f21
L19dd1ef1:
   push DS
   mov AX,SI
   mov DX,000A
   mul DX
   add AX,offset _hiname
   push AX
   mov AX,0002
   push AX
   mov AX,SI
   mov DX,0007
   mul DX
   add AX,000F
   push AX
   mov AX,0002
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   inc SI
L19dd1f21:
   cmp SI,+0A
   jl L19dd1ef1
   push [BP-02]
   mov AX,0006
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   xor SI,SI
jmp near L19dd1fc0
L19dd1f42:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   mov BX,SI
   shl BX,1
   shl BX,1
   push [BX+offset _hiscore+02]
   push [BX+offset _hiscore]
   call far _ltoa
   add SP,+0A
   mov word ptr [BP-14],0000
jmp near L19dd1fb3
L19dd1f68:
   mov AX,SI
   mov DX,0007
   mul DX
   add AX,000F
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   call far _strlen
   pop CX
   pop CX
   shl AX,1
   shl AX,1
   mov DX,003E
   sub DX,AX
   mov AX,[BP-14]
   shl AX,1
   shl AX,1
   add DX,AX
   push DX
   lea BX,[BP-12]
   add BX,[BP-14]
   mov AL,[SS:BX]
   cbw
   add AX,03D0
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _drawshape
   add SP,+0A
   inc word ptr [BP-14]
L19dd1fb3:
   lea BX,[BP-12]
   add BX,[BP-14]
   cmp byte ptr [SS:BX],00
   jnz L19dd1f68
   inc SI
L19dd1fc0:
   cmp SI,+0A
   jge L19dd1fc8
jmp near L19dd1f42
L19dd1fc8:
   cmp word ptr [BP+06],+00
   jnz L19dd1fd1
jmp near L19dd20a2
L19dd1fd1:
   push [BP-02]
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   mov BX,DI
   shl BX,1
   shl BX,1
   push [BX+offset _hiscore]
   call far _itoa
   add SP,+08
   push SS
   lea AX,[BP-12]
   push AX
   call far _strlen
   pop CX
   pop CX
   shl AX,1
   shl AX,1
   push AX
   mov AX,0036
   pop DX
   sub AX,DX
   mov BX,0006
   xor DX,DX
   div BX
   cmp AX,000C
   jnb L19dd2048
   push SS
   lea AX,[BP-12]
   push AX
   call far _strlen
   pop CX
   pop CX
   shl AX,1
   shl AX,1
   push AX
   mov AX,0036
   pop DX
   sub AX,DX
   mov BX,0006
   xor DX,DX
   div BX
   mov SI,AX
jmp near L19dd204b
L19dd2048:
   mov SI,000C
L19dd204b:
   push SI
   push DS
   mov AX,DI
   mov DX,000A
   mul DX
   add AX,offset _hiname
   push AX
   mov AX,0002
   push AX
   mov AX,DI
   mov DX,0007
   mul DX
   add AX,000F
   push AX
   mov AX,0002
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _winput
   add SP,+10
   mov AX,DI
   mov DX,000A
   mul DX
   mov BX,AX
   add BX,offset _hiname
   push DS
   pop ES
   cmp byte ptr [ES:BX],00
   jnz L19dd2096
   push CS
   call near offset _loadcfg
jmp near L19dd209a
L19dd2096:
   push CS
   call near offset _savecfg
L19dd209a:
   xor AX,AX
   push AX
   push CS
   call near offset _printhi
   pop CX
L19dd20a2:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_loadsavewin: ;; 19dd20a8
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   mov word ptr [offset _dx1hold],0001
   mov word ptr [offset _dy1hold],0001
   mov word ptr [offset _fire1off],0001
   mov AX,0001
   push AX
   mov AX,0005
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1715ac
   push AX
   mov AX,0001
   push AX
   mov AX,0004
   push AX
   xor AX,AX
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1715b9
   push AX
   mov AX,0001
   push AX
   mov AX,0038
   push AX
   xor AX,AX
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   mov AX,0001
   push AX
   mov AX,0004
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push [BP+08]
   push [BP+06]
   mov AX,0002
   push AX
   push AX
   mov AX,0006
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   mov AX,0001
   push AX
   mov AX,0003
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   mov word ptr [BP-10],0000
jmp near L19dd21be
L19dd217e:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-0E]
   push AX
   mov AX,[BP-10]
   inc AX
   push AX
   call far _itoa
   add SP,+08
   push DX
   push AX
   mov AX,0002
   push AX
   mov AX,[BP-10]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,000D
   push AX
   mov AX,0008
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   inc word ptr [BP-10]
L19dd21be:
   cmp word ptr [BP-10],+06
   jl L19dd217e
   mov word ptr [BP-10],0000
jmp near L19dd2245
L19dd21cb:
   push DS
   mov AX,[BP-10]
   mov DX,000C
   mul DX
   add AX,offset _savename
   push AX
   call far _strlen
   pop CX
   pop CX
   or AX,AX
   jz L19dd2217
   push DS
   mov AX,[BP-10]
   mov DX,000C
   mul DX
   add AX,offset _savename
   push AX
   mov AX,0002
   push AX
   mov AX,[BP-10]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,000D
   push AX
   mov AX,0014
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
jmp near L19dd2242
L19dd2217:
   push [BP+0C]
   push [BP+0A]
   mov AX,0002
   push AX
   mov AX,[BP-10]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,000D
   push AX
   mov AX,0014
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
L19dd2242:
   inc word ptr [BP-10]
L19dd2245:
   cmp word ptr [BP-10],+06
   jge L19dd224e
jmp near L19dd21cb
L19dd224e:
   mov AX,0001
   push AX
   mov AX,0002
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a1715c6
   push AX
   mov AX,0002
   push AX
   mov AX,0041
   push AX
   mov AX,000E
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1715cc
   push AX
   mov AX,0002
   push AX
   mov AX,004D
   push AX
   mov AX,0006
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   mov AX,0001
   push AX
   mov AX,0004
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y2a1715d5
   push AX
   mov AX,0002
   push AX
   mov AX,0047
   push AX
   mov AX,000C
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   mov AX,0001
   push AX
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
L19dd22f9:
   mov byte ptr [BP-01],00
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   mov AX,[BP-10]
   and AX,0007
   inc AX
   mov [BP-10],AX
   mov AL,[BP-10]
   mov [BP-02],AL
   push SS
   lea AX,[BP-02]
   push AX
   mov AX,0002
   push AX
   mov AX,[offset Y2a1713fa]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,000D
   push AX
   mov AX,0001
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   les BX,[offset _myclock]
   mov SI,[ES:BX]
L19dd2347:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   cmp AX,SI
   jz L19dd2347
   push DS
   mov AX,offset Y2a1715dc
   push AX
   mov AX,0002
   push AX
   mov AX,[offset Y2a1713fa]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,000D
   push AX
   mov AX,0001
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _wprint
   add SP,+0E
   mov AX,[offset Y2a1713fa]
   add AX,[offset _dx1]
   add AX,[offset _dy1]
   cmp AX,0005
   jge L19dd2399
   mov AX,[offset Y2a1713fa]
   add AX,[offset _dx1]
   add AX,[offset _dy1]
jmp near L19dd239c
L19dd2399:
   mov AX,0005
L19dd239c:
   or AX,AX
   jge L19dd23a4
   xor AX,AX
jmp near L19dd23c4
L19dd23a4:
   mov AX,[offset Y2a1713fa]
   add AX,[offset _dx1]
   add AX,[offset _dy1]
   cmp AX,0005
   jge L19dd23c1
   mov AX,[offset Y2a1713fa]
   add AX,[offset _dx1]
   add AX,[offset _dy1]
jmp near L19dd23c4
L19dd23c1:
   mov AX,0005
L19dd23c4:
   mov [offset Y2a1713fa],AX
   cmp word ptr [offset _fire1],+00
   jnz L19dd23df
   cmp word ptr [offset _key],+0D
   jz L19dd23df
   cmp word ptr [offset _key],+1B
   jz L19dd23df
jmp near L19dd22f9
L19dd23df:
   cmp word ptr [offset _key],+1B
   jnz L19dd23eb
   mov AX,FFFF
jmp near L19dd23ee
L19dd23eb:
   mov AX,[offset Y2a1713fa]
L19dd23ee:
   pop SI
   mov SP,BP
   pop BP
ret far

_loadgame: ;; 19dd23f3
   push BP
   mov BP,SP
   sub SP,+50
   push SI
   push DI
   push DS
   mov AX,offset Y2a1715e8
   push AX
   push DS
   mov AX,offset Y2a1715de
   push AX
   push CS
   call near offset _loadsavewin
   add SP,+08
   mov SI,AX
   or SI,SI
   jge L19dd2415
jmp near L19dd251e
L19dd2415:
   push DS
   mov AX,SI
   mov DX,000C
   mul DX
   add AX,offset _savename
   push AX
   call far _strlen
   pop CX
   pop CX
   or AX,AX
   jnz L19dd242f
jmp near L19dd251e
L19dd242f:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-50]
   push AX
   push SI
   call far _itoa
   add SP,+08
   push DS
   mov AX,offset _path
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcpy
   add SP,+08
   push DS
   mov AX,offset _savepfx
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset Y2a1715f0
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   push SS
   lea AX,[BP-50]
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset _path
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _strcpy
   add SP,+08
   push DS
   mov AX,offset _savepfx
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset Y2a1715f2
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _strcat
   add SP,+08
   push SS
   lea AX,[BP-50]
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _strcat
   add SP,+08
   mov AX,8001
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far __open
   add SP,+06
   mov DI,AX
   cmp DI,-01
   jz L19dd250e
   push DI
   call far __close
   pop CX
   push DS
   mov AX,offset _tempname
   push AX
   call far _unlink
   pop CX
   pop CX
   push DS
   mov AX,offset _tempname
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _copyfile
   add SP,+08
L19dd250e:
   push SS
   lea AX,[BP-40]
   push AX
   push CS
   call near offset _loadboard
   pop CX
   pop CX
   mov AX,0001
jmp near L19dd2520
L19dd251e:
   xor AX,AX
L19dd2520:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_savegame: ;; 19dd2526
   push BP
   mov BP,SP
   sub SP,+5C
   push SI
   push DI
   push DS
   mov AX,offset Y2a1715ff
   push AX
   push DS
   mov AX,offset Y2a1715f5
   push AX
   push CS
   call near offset _loadsavewin
   add SP,+08
   mov SI,AX
   or SI,SI
   jge L19dd2548
jmp near L19dd26a6
L19dd2548:
   push DS
   mov AX,SI
   mov DX,000C
   mul DX
   add AX,offset _savename
   push AX
   push SS
   lea AX,[BP-0C]
   push AX
   call far _strcpy
   add SP,+08
   mov AX,0007
   push AX
   push SS
   lea AX,[BP-0C]
   push AX
   mov AX,0002
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,000D
   push AX
   mov AX,0014
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _winput
   add SP,+10
   cmp word ptr [offset _key],+1B
   jnz L19dd2598
jmp near L19dd26a6
L19dd2598:
   push SS
   lea AX,[BP-0C]
   push AX
   call far _strlen
   pop CX
   pop CX
   or AX,AX
   jnz L19dd25ab
jmp near L19dd26a6
L19dd25ab:
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,SI
   mov DX,000C
   mul DX
   add AX,offset _savename
   push AX
   call far _strcpy
   add SP,+08
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-5C]
   push AX
   push SI
   call far _itoa
   add SP,+08
   push DS
   mov AX,offset _path
   push AX
   push SS
   lea AX,[BP-4C]
   push AX
   call far _strcpy
   add SP,+08
   push DS
   mov AX,offset _savepfx
   push AX
   push SS
   lea AX,[BP-4C]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset Y2a171600
   push AX
   push SS
   lea AX,[BP-4C]
   push AX
   call far _strcat
   add SP,+08
   push SS
   lea AX,[BP-5C]
   push AX
   push SS
   lea AX,[BP-4C]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset _path
   push AX
   push SS
   lea AX,[BP-2C]
   push AX
   call far _strcpy
   add SP,+08
   push DS
   mov AX,offset _savepfx
   push AX
   push SS
   lea AX,[BP-2C]
   push AX
   call far _strcat
   add SP,+08
   push DS
   mov AX,offset Y2a171602
   push AX
   push SS
   lea AX,[BP-2C]
   push AX
   call far _strcat
   add SP,+08
   push SS
   lea AX,[BP-5C]
   push AX
   push SS
   lea AX,[BP-2C]
   push AX
   call far _strcat
   add SP,+08
   push SS
   lea AX,[BP-4C]
   push AX
   push CS
   call near offset _saveboard
   pop CX
   pop CX
   mov AX,8001
   push AX
   push DS
   mov AX,offset _tempname
   push AX
   call far __open
   add SP,+06
   mov DI,AX
   cmp DI,-01
   jz L19dd26a2
   push DI
   call far __close
   pop CX
   push SS
   lea AX,[BP-2C]
   push AX
   push DS
   mov AX,offset _tempname
   push AX
   call far _copyfile
   add SP,+08
L19dd26a2:
   push CS
   call near offset _savecfg
L19dd26a6:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_drawgamewin: ;; 19dd26ac
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset _ourwin
   push AX
   call far _drawwin
   pop CX
   pop CX
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _clearvp
   pop CX
   pop CX
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _fontcolor
   add SP,+08
   push [offset _statvp+02]
   push [offset _statvp]
   call far _clearvp
   pop CX
   pop CX
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _fontcolor
   add SP,+08
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _clearvp
   pop CX
   pop CX
   mov AX,FFFF
   push AX
   push [offset _xbordercol]
   push DS
   mov AX,offset _ourwin+18
   push AX
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset _v_title
   push AX
   push DS
   mov AX,offset _ourwin
   push AX
   call far _titlewin
   add SP,+08
   push DS
   mov AX,offset Y2a171605
   push AX
   push DS
   mov AX,offset _ourwin
   push AX
   call far _titlebot
   add SP,+08
   push DS
   mov AX,offset Y2a17160f
   push AX
   push DS
   mov AX,offset _ourwin
   push AX
   call far _titletop
   add SP,+08
ret far

_noisemaker: ;; 19dd2785
   push BP
   mov BP,SP
   sub SP,+34
   push SI
   push SS
   lea AX,[BP-34]
   push AX
   push DS
   mov AX,offset Y2a1713fc
   push AX
   mov CX,0034
   call far SCOPY@
   mov word ptr [offset _fire1off],0000
L19dd27a4:
   call far _sb_update
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   push [offset _key]
   call far _toupper
   pop CX
   mov [offset _key],AX
   xor SI,SI
jmp near L19dd27de
L19dd27c3:
   mov AL,[SS:BP+SI-34]
   cbw
   cmp AX,[offset _key]
   jnz L19dd27dd
   mov AX,SI
   inc AX
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L19dd27dd:
   inc SI
L19dd27de:
   cmp byte ptr [SS:BP+SI-34],00
   jnz L19dd27c3
   cmp word ptr [offset _key],+0D
   jz L19dd27f3
   cmp word ptr [offset _key],+1B
   jnz L19dd27a4
L19dd27f3:
   pop SI
   mov SP,BP
   pop BP
ret far

_pageview: ;; 19dd27f8
   push BP
   mov BP,SP
   sub SP,+12
   push SI
   push DI
   mov word ptr [offset _scrnxs],0014
   mov word ptr [offset _scrnys],000D
L19dd280c:
   mov SI,FFFF
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fout
   xor DI,DI
jmp near L19dd2851
L19dd2821:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],0C
   jnz L19dd2850
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[BP+06]
   jnz L19dd2850
   mov SI,DI
L19dd2850:
   inc DI
L19dd2851:
   cmp DI,[offset _numobjs]
   jl L19dd2821
   or SI,SI
   jg L19dd285e
jmp near L19dd296b
L19dd285e:
   mov AX,0010
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   push SS
   lea AX,[BP-12]
   push AX
   call far _memcpy
   add SP,+0A
   mov AX,0010
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _memcpy
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   les BX,[offset _gamevp]
   mov [ES:BX+08],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   les BX,[offset _gamevp]
   mov [ES:BX+0A],AX
   push CS
   call near offset _drawboard
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fin
   mov AX,0010
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _memcpy
   add SP,+0A
   cmp word ptr [BP+06],+63
   jnz L19dd2901
   push CS
   call near offset _noisemaker
jmp near L19dd293c
L19dd2901:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   mov [BP-02],AX
   mov word ptr [offset _fire1off],0001
L19dd2911:
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   call far _sb_update
   cmp word ptr [offset _key],+00
   jnz L19dd292d
   cmp word ptr [offset _fire1],+00
   jz L19dd2911
L19dd292d:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,[BP-02]
   cmp AX,0012
   jl L19dd2911
L19dd293c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L19dd296b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   mov [BP+06],AX
jmp near L19dd280c
L19dd296b:
   mov word ptr [offset _scrnxs],000F
   mov word ptr [offset _scrnys],000B
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fout
   push CS
   call near offset _drawgamewin
   push CS
   call near offset _drawboard
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fin
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_domenu: ;; 19dd29a5
   push BP
   mov BP,SP
   sub SP,00B2
   push SI
   push DI
   xor DI,DI
   mov [BP-54],DI
   mov word ptr [BP-52],0001
   les BX,[BP+06]
   mov [offset _textmsg+02],ES
   mov [offset _textmsg],BX
   push [offset _textmsg+02]
   push BX
   call far _strlen
   pop CX
   pop CX
   mov [offset _textmsglen],AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push CS
   call near offset _numlines
   mov BX,0002
   cwd
   idiv BX
   inc AX
   push AX
   push [BP+18]
   mov AX,0040
   push AX
   push [BP+16]
   push SS
   lea AX,[BP-00b2]
   push AX
   call far _defwin
   add SP,+12
   push SS
   lea AX,[BP-00b2]
   push AX
   call far _drawwin
   pop CX
   pop CX
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   mov [BP-5A],AX
   push CS
   call near offset _numlines
   mov SI,AX
   dec SI
jmp near L19dd2a82
L19dd2a28:
   mov AX,FFFF
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-50]
   push AX
   push SI
   push CS
   call near offset _getline
   add SP,+08
   push AX
   push SS
   lea AX,[BP-008a]
   push AX
   call far _fontcolor
   add SP,+08
   push SS
   lea AX,[BP-50]
   push AX
   mov AX,0002
   push AX
   mov AX,SI
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,0008
   push AX
   cmp SI,[BP+0E]
   jl L19dd2a6a
   mov AX,0001
jmp near L19dd2a6c
L19dd2a6a:
   xor AX,AX
L19dd2a6c:
   mul word ptr [BP+14]
   add AX,0004
   push AX
   push SS
   lea AX,[BP-008a]
   push AX
   call far _wprint
   add SP,+0E
   dec SI
L19dd2a82:
   or SI,SI
   jge L19dd2a28
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   xor SI,SI
L19dd2a96:
   call far _sb_update
   inc DI
   mov AX,DI
   cmp AX,000C
   jl L19dd2aa5
   xor DI,DI
L19dd2aa5:
   test DI,0001
   jnz L19dd2ab2
   mov AX,[BP-52]
   cmp AX,SI
   jz L19dd2b0d
L19dd2ab2:
   mov AX,[BP+0E]
   add AX,[BP-52]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,0008
   push AX
   mov AX,[BP+14]
   add AX,FFF4
   and AX,FFF8
   push AX
   mov AX,4709
   push AX
   push SS
   lea AX,[BP-008a]
   push AX
   call far _drawshape
   add SP,+0A
   mov AX,[BP+0E]
   add AX,SI
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,0008
   push AX
   mov AX,[BP+14]
   add AX,FFF4
   and AX,FFF8
   push AX
   mov AX,DI
   sar AX,1
   add AX,0201
   push AX
   push SS
   lea AX,[BP-008a]
   push AX
   call far _drawshape
   add SP,+0A
L19dd2b0d:
   mov [BP-52],SI
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   push [offset _key]
   call far _toupper
   pop CX
   mov [offset _key],AX
   mov AX,[offset _dx1]
   add AX,[offset _dy1]
   jz L19dd2b80
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,[BP-54]
   cwd
   xor AX,DX
   sub AX,DX
   cmp AX,0001
   jle L19dd2b80
   mov AX,[ES:BX]
   mov [BP-54],AX
   mov AX,[offset _dx1]
   add AX,[offset _dy1]
   add SI,AX
   or SI,SI
   jge L19dd2b5a
   xor AX,AX
jmp near L19dd2b5c
L19dd2b5a:
   mov AX,SI
L19dd2b5c:
   mov DX,[BP+10]
   dec DX
   cmp AX,DX
   jle L19dd2b6a
   mov AX,[BP+10]
   dec AX
jmp near L19dd2b74
L19dd2b6a:
   or SI,SI
   jge L19dd2b72
   xor AX,AX
jmp near L19dd2b74
L19dd2b72:
   mov AX,SI
L19dd2b74:
   mov SI,AX
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   mov [BP-5A],AX
L19dd2b80:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,[BP-5A]
   cmp AX,012C
   jle L19dd2b9e
   cmp word ptr [BP+12],+00
   jz L19dd2b9e
   mov word ptr [offset _key],0044
jmp near L19dd2c10
L19dd2b9e:
   mov word ptr [BP-58],0000
   cmp word ptr [offset _key],+1B
   jnz L19dd2bb0
   mov word ptr [offset _key],0051
L19dd2bb0:
   cmp word ptr [offset _key],+0D
   jz L19dd2bc5
   cmp word ptr [offset _key],+20
   jz L19dd2bc5
   cmp word ptr [offset _fire1],+00
   jz L19dd2bd6
L19dd2bc5:
   les BX,[BP+0A]
   mov AL,[ES:BX+SI]
   cbw
   mov [offset _key],AX
   mov word ptr [BP-58],0001
jmp near L19dd2c07
L19dd2bd6:
   mov word ptr [BP-56],0000
jmp near L19dd2bf5
L19dd2bdd:
   les BX,[BP+0A]
   add BX,[BP-56]
   mov AL,[ES:BX]
   cbw
   cmp AX,[offset _key]
   jnz L19dd2bf2
   mov word ptr [BP-58],0001
L19dd2bf2:
   inc word ptr [BP-56]
L19dd2bf5:
   push [BP+0C]
   push [BP+0A]
   call far _strlen
   pop CX
   pop CX
   cmp AX,[BP-56]
   ja L19dd2bdd
L19dd2c07:
   cmp word ptr [BP-58],+00
   jnz L19dd2c10
jmp near L19dd2a96
L19dd2c10:
   mov AX,[offset _key]
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_askquit: ;; 19dd2c19
   mov AX,0016
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,0006
   push AX
   mov AX,000D
   push AX
   mov AX,0014
   push AX
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   mov AX,0001
   push AX
   push DS
   mov AX,offset Y2a171630
   push AX
   push DS
   mov AX,offset Y2a171618
   push AX
   push CS
   call near offset _domenu
   add SP,+14
   cmp word ptr [offset _key],+59
   jnz L19dd2c5c
   mov AX,0001
jmp near L19dd2c5e
L19dd2c5c:
   xor AX,AX
L19dd2c5e:
ret far

_dodemo: ;; 19dd2c5f
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   mov word ptr [offset _gamecount],0000
   push CS
   call near offset _fout
   push CS
   call near offset _drawgamewin
   push CS
   call near offset _drawcmds
   mov word ptr [offset _demonum],0000
   mov word ptr [offset _macabort],0000
L19dd2c87:
   cmp word ptr [offset _demonum],+00
   jz L19dd2c9c
   push CS
   call near offset _fout
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
L19dd2c9c:
   mov BX,[offset _demonum]
   cmp byte ptr [BX+offset _demolvl],00
   jnz L19dd2cad
   mov word ptr [offset _demonum],0000
L19dd2cad:
   mov BX,[offset _demonum]
   shl BX,1
   shl BX,1
   push [BX+offset _demoboard+02]
   push [BX+offset _demoboard]
   push CS
   call near offset _loadboard
   pop CX
   pop CX
   mov BX,[offset _demonum]
   mov AL,[BX+offset _demolvl]
   cbw
   mov [offset _pl],AX
   xor AX,AX
   push AX
   call far _p_reenter
   pop CX
   push CS
   call near offset _drawboard
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fin
   mov BX,[offset _demonum]
   shl BX,1
   shl BX,1
   push [BX+offset _demoname+02]
   push [BX+offset _demoname]
   call far _playmac
   pop CX
   pop CX
   cmp word ptr [offset _macplay],+00
   jz L19dd2d20
   mov AX,0001
   push AX
   push CS
   call near offset _play
   pop CX
   call far _stopmac
   inc word ptr [offset _demonum]
jmp near L19dd2d26
L19dd2d20:
   mov word ptr [offset _macaborted],0001
L19dd2d26:
   cmp word ptr [offset _macaborted],+00
   jnz L19dd2d30
jmp near L19dd2c87
L19dd2d30:
ret far

_jmenu: ;; 19dd2d31
   push SI
   push DI
   xor DI,DI
   push DS
   mov AX,offset _introboard
   push AX
   push CS
   call near offset _loadboard
   pop CX
   pop CX
L19dd2d40:
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   call far _setorigin
   push CS
   call near offset _drawboard
   xor AX,AX
   push AX
   push CS
   call near offset _printhi
   pop CX
   push DS
   mov AX,offset _botvp
   push AX
   call far _clearvp
   pop CX
   pop CX
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _fontcolor
   add SP,+08
   push [offset _statvp+02]
   push [offset _statvp]
   call far _clearvp
   pop CX
   pop CX
   cmp word ptr [offset _facetable],+00
   jz L19dd2dda
   cmp byte ptr [offset _x_ourmode],04
   jnz L19dd2dda
   xor SI,SI
jmp near L19dd2dd3
L19dd2da0:
   mov AX,SI
   sar AX,1
   sar AX,1
   mov CL,04
   shl AX,CL
   push AX
   mov AX,SI
   and AX,0003
   mov CL,04
   shl AX,CL
   push AX
   mov AX,[offset _facetable]
   mov CL,08
   shl AX,CL
   add AX,SI
   add AX,4000
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _drawshape
   add SP,+0A
   inc SI
L19dd2dd3:
   cmp SI,+10
   jl L19dd2da0
jmp near L19dd2e20
L19dd2dda:
   push [offset _leveltxt+4*1e+02]
   push [offset _leveltxt+4*1e]
   mov AX,0002
   push AX
   mov AX,001C
   push AX
   xor AX,AX
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _wprint
   add SP,+0E
   push [offset _leveltxt+4*1f+02]
   push [offset _leveltxt+4*1f]
   mov AX,0002
   push AX
   mov AX,0024
   push AX
   xor AX,AX
   push AX
   push [offset _statvp+02]
   push [offset _statvp]
   call far _wprint
   add SP,+0E
L19dd2e20:
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   mov AX,0008
   push AX
   mov AX,0009
   push AX
   mov AX,0018
   push AX
   mov AX,0001
   push AX
   push [offset _menuc]
   push AX
   push DS
   mov AX,offset _menu2
   push AX
   push DS
   mov AX,offset _menu1
   push AX
   push CS
   call near offset _domenu
   add SP,+14
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   cmp word ptr [offset _key],+05
   jnz L19dd2e8c
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _drawgamewin
   push CS
   call near offset _drawboard
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   call far _design
jmp near L19dd300c
L19dd2e8c:
   cmp word ptr [offset _key],+1B
   jz L19dd2e9a
   cmp word ptr [offset _key],+51
   jnz L19dd2ea0
L19dd2e9a:
   mov DI,0001
jmp near L19dd300c
L19dd2ea0:
   cmp word ptr [offset _key],+50
   jnz L19dd2ee4
   mov word ptr [offset _gamecount],0000
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fout
   push CS
   call near offset _drawgamewin
   push CS
   call near offset _drawcmds
   push DS
   mov AX,offset _mapboard
   push AX
   push CS
   call near offset _loadboard
   pop CX
   pop CX
   mov AX,[offset _xstartlevel]
   mov [offset _pl],AX
   xor AX,AX
   push AX
   call far _p_reenter
   pop CX
   push CS
   call near offset _drawboard
jmp near L19dd2f6d
L19dd2ee4:
   cmp word ptr [offset _key],+10
   jnz L19dd2f24
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _drawgamewin
   push CS
   call near offset _drawboard
   push CS
   call near offset _drawcmds
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   call far _dolevelsong
   mov byte ptr [offset _curlevel],00
   xor AX,AX
   push AX
   push CS
   call near offset _play
   pop CX
jmp near L19dd300c
L19dd2f24:
   cmp word ptr [offset _key],+45
   jnz L19dd2f37
   mov AX,0014
   push AX
   push CS
   call near offset _pageview
   pop CX
jmp near L19dd300c
L19dd2f37:
   cmp word ptr [offset _key],+52
   jnz L19dd2f89
   push CS
   call near offset _loadgame
   or AX,AX
   jnz L19dd2f49
jmp near L19dd300c
L19dd2f49:
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fout
   push CS
   call near offset _drawgamewin
   push CS
   call near offset _drawcmds
   call far _setorigin
   push CS
   call near offset _drawboard
   call far _dolevelsong
L19dd2f6d:
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fin
   xor AX,AX
   push AX
   push CS
   call near offset _play
   pop CX
jmp near L19dd2fe3
L19dd2f89:
   cmp word ptr [offset _key],+53
   jnz L19dd2f9b
   xor AX,AX
   push AX
   push CS
   call near offset _pageview
   pop CX
jmp near L19dd300c
L19dd2f9b:
   cmp word ptr [offset _key],+49
   jnz L19dd2fad
   mov AX,0001
   push AX
   push CS
   call near offset _dotextmsg
   pop CX
jmp near L19dd300c
L19dd2fad:
   cmp word ptr [offset _key],+4F
   jz L19dd2fbb
   cmp word ptr [offset _key],+48
   jnz L19dd2fc6
L19dd2fbb:
   mov AX,0008
   push AX
   push CS
   call near offset _pageview
   pop CX
jmp near L19dd300c
L19dd2fc6:
   cmp word ptr [offset _key],+43
   jnz L19dd2fd8
   mov AX,000C
   push AX
   push CS
   call near offset _pageview
   pop CX
jmp near L19dd300c
L19dd2fd8:
   cmp word ptr [offset _key],+44
   jnz L19dd2ffc
   push CS
   call near offset _dodemo
L19dd2fe3:
   push DS
   mov AX,offset _xintrosong
   push AX
   call far _sb_playtune
   pop CX
   pop CX
   push DS
   mov AX,offset _introboard
   push AX
   push CS
   call near offset _loadboard
   pop CX
   pop CX
jmp near L19dd300c
L19dd2ffc:
   cmp word ptr [offset _key],+4E
   jnz L19dd300c
   mov AX,0063
   push AX
   push CS
   call near offset _pageview
   pop CX
L19dd300c:
   or DI,DI
   jnz L19dd3013
jmp near L19dd2d40
L19dd3013:
   pop DI
   pop SI
ret far

_main: ;; 19dd3016
   push BP
   mov BP,SP
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far _cfg_getpath
   mov SP,BP
   push DS
   mov AX,offset _path
   push AX
   push DS
   mov AX,offset _tempname
   push AX
   call far _strcpy
   mov SP,BP
   push DS
   mov AX,offset Y2a171633
   push AX
   push DS
   mov AX,offset _tempname
   push AX
   call far _strcat
   mov SP,BP
   push CS
   call near offset _loadcfg
   call far _clrscr
   push [offset _b_len]
   mov DX,B800
   xor AX,AX
   push DX
   push AX
   push DS
   mov AX,offset _JILLB
   push AX
   call far _uncrunch
   mov SP,BP
   mov AX,0010
   push AX
   mov AX,0046
   push AX
   mov AX,0007
   push AX
   mov AX,000B
   push AX
   call far _window
   mov SP,BP
   mov AX,0001
   push AX
   push AX
   call far _gotoxy
   mov SP,BP
   mov AX,000F
   push AX
   call far _textcolor
   pop CX
   mov AX,0001
   push AX
   call far _textbackground
   pop CX
   call far _clrscr
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far _cfg_init
   mov SP,BP
   push DS
   mov AX,offset _xvocfile
   push AX
   call far _snd_init
   mov SP,BP
   call far _gc_init
   call far _doconfig
   or AX,AX
   jnz L19dd30d4
jmp near L19dd32dd
L19dd30d4:
   call far _gr_init
   call far _clrpal
   push CS
   call near offset _savecfg
   push DS
   mov AX,offset _xshafile
   push AX
   call far _shm_init
   mov SP,BP
   mov word ptr [offset _shm_want+2*01],0001
   mov word ptr [offset _shm_want+2*02],0001
   mov word ptr [offset _shm_want+2*07],0001
   call far _shm_do
   xor AX,AX
   push AX
   mov AX,0009
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _fontcolor
   mov SP,BP
   mov AX,0300
   push AX
   push DS
   mov AX,offset _vgapal
   push AX
   push DS
   mov AX,offset _oldvgapal
   push AX
   call far _memcpy
   mov SP,BP
   push CS
   call near offset _pleasewait
   call far _snd_do
   push DS
   mov AX,offset _xintrosong
   push AX
   call far _sb_playtune
   mov SP,BP
   mov word ptr [offset _shm_want+2*03],0001
   mov word ptr [offset _shm_want+2*04],0001
   mov word ptr [offset _shm_want+2*05],0001
   mov word ptr [offset _shm_want+2*06],0001
   mov word ptr [offset _shm_want+2*08],0001
   mov word ptr [offset _shm_want+2*0e],0001
   call far _shm_do
   push CS
   call near offset _fout
   mov AX,0300
   push AX
   push DS
   mov AX,offset _oldvgapal
   push AX
   push DS
   mov AX,offset _vgapal
   push AX
   call far _memcpy
   mov SP,BP
   mov AX,0001
   push AX
   mov AX,0005
   push AX
   mov AX,0004
   push AX
   mov AX,000A
   push AX
   mov AX,0013
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,offset _ourwin
   push AX
   call far _defwin
   mov SP,BP
   mov [offset _gamevp+02],DS
   mov word ptr [offset _gamevp],offset _ourwin+28
   mov [offset _cmdvp+02],DS
   mov word ptr [offset _cmdvp],offset _ourwin+38
   mov [offset _statvp+02],DS
   mov word ptr [offset _statvp],offset _ourwin+48
   mov word ptr [offset _botvp+2*04],0000
   mov word ptr [offset _botvp+2*05],0000
   mov word ptr [offset _botvp+2*00],0000
   mov word ptr [offset _botvp+2*01],00BC
   mov word ptr [offset _botvp+2*02],0140
   mov word ptr [offset _botvp+2*03],000C
   mov word ptr [offset _scrnxs],000F
   mov word ptr [offset _scrnys],000B
   cmp word ptr [offset _facetable],+00
   jz L19dd3233
   cmp byte ptr [offset _x_ourmode],04
   jnz L19dd3233
   xor AX,AX
   push AX
   push AX
   mov AX,0004
   push AX
   push AX
   mov AX,000B
   push AX
   mov AX,0030
   push AX
   mov AX,000C
   push AX
   push DS
   mov AX,offset _levelwin
   push AX
   call far _defwin
   mov SP,BP
   mov AX,[offset _levelwin+28+02]
   mov [offset _levelwin+38+02],AX
   mov AX,[offset _levelwin+28+06]
   mov [offset _levelwin+38+06],AX
jmp near L19dd3254
L19dd3233:
   xor AX,AX
   push AX
   push AX
   push AX
   mov AX,0004
   push AX
   mov AX,0008
   push AX
   mov AX,0030
   push AX
   mov AX,000D
   push AX
   push DS
   mov AX,offset _levelwin
   push AX
   call far _defwin
   mov SP,BP
L19dd3254:
   call far _initinfo
   call far _initobjinfo
   push CS
   call near offset _initboard
   call far _initobjs
   cmp word ptr [offset _xdemoflag],+00
   jz L19dd329f
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clearvp
   mov SP,BP
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clearvp
   mov SP,BP
   push CS
   call near offset _dodemo
jmp near L19dd32c3
L19dd329f:
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _drawgamewin
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fin
   push CS
   call near offset _jmenu
L19dd32c3:
   push CS
   call near offset _fout
   push DS
   mov AX,offset _ourwin
   push AX
   call far _undrawwin
   mov SP,BP
   call far _shm_exit
   call far _gr_exit
L19dd32dd:
   call far _gc_exit
   call far _snd_exit
   mov AX,0019
   push AX
   mov AX,0050
   push AX
   mov AX,0001
   push AX
   push AX
   call far _window
   mov SP,BP
   mov AX,000F
   push AX
   call far _textcolor
   pop CX
   xor AX,AX
   push AX
   call far _textbackground
   pop CX
   call far _clrscr
   cmp word ptr [offset _e_len],+00
   jz L19dd3340
   push [offset _e_len]
   mov DX,B800
   xor AX,AX
   push DX
   push AX
   push DS
   mov AX,offset _JILLE
   push AX
   call far _uncrunch
   mov SP,BP
   mov AX,0018
   push AX
   mov AX,0001
   push AX
   call far _gotoxy
   mov SP,BP
L19dd3340:
   pop BP
ret far

_rexit: ;; 19dd3342
   push BP
   mov BP,SP
   sub SP,+10
   call far _shm_exit
   call far _gr_exit
   call far _gc_exit
   call far _snd_exit
   mov AX,0019
   push AX
   mov AX,0050
   push AX
   mov AX,0001
   push AX
   push AX
   call far _window
   add SP,+08
   mov AX,000F
   push AX
   call far _textcolor
   pop CX
   xor AX,AX
   push AX
   call far _textbackground
   pop CX
   call far _clrscr
   mov AX,0005
   push AX
   mov AX,0001
   push AX
   call far _gotoxy
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a171638
   push AX
   call far _cputs
   pop CX
   pop CX
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   push [BP+06]
   call far _itoa
   add SP,+08
   push DX
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a171673
   push AX
   call far _cputs
   pop CX
   pop CX
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   call far _coreleft
   push DX
   push AX
   call far _ltoa
   add SP,+0A
   push DX
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a171675
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a171678
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset _erroraddr
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a17167b
   push AX
   call far _cputs
   pop CX
   pop CX
   cmp word ptr [BP+06],+09
   jnz L19dd3469
   push DS
   mov AX,offset Y2a171680
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1716c8
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a1716f4
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a17172c
   push AX
   call far _cputs
   pop CX
   pop CX
   cmp word ptr [offset _vocflag],+00
   jz L19dd3475
   push DS
   mov AX,offset Y2a17175d
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L19dd3475
L19dd3469:
   push DS
   mov AX,offset Y2a1717a9
   push AX
   call far _cputs
   pop CX
   pop CX
L19dd3475:
   mov AX,0001
   push AX
   call far _exit
   pop CX
   mov SP,BP
   pop BP
ret far

Segment 1d25 ;; JINFO.C:JINFO
_initinfo: ;; 1d250003
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov DI,4006
   mov word ptr [BP-06],0000
jmp near L1d250058
L1d250015:
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov word ptr [ES:BX],4700
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov [ES:BX+06],DS
   mov word ptr [ES:BX+04],17E8
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov [ES:BX+02],DI
   inc word ptr [BP-06]
L1d250058:
   cmp word ptr [BP-06],0258
   jl L1d250015
   mov AX,8000
   push AX
   push DS
   mov AX,offset _dmafile
   push AX
   call far _open
   add SP,+06
   mov SI,AX
jmp near L1d250135
L1d250075:
   mov AX,0002
   push AX
   push DS
   mov AX,[BP-06]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,offset _info
   push AX
   push SI
   call far _read
   add SP,+08
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   call far _read
   add SP,+08
   mov AX,[BP-04]
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push AX
   push DS
   pop ES
   pop AX
   xor [ES:BX+02],AX
   mov AX,0001
   push AX
   push SS
   lea AX,[BP-01]
   push AX
   push SI
   call far _read
   add SP,+08
   mov AL,[BP-01]
   cbw
   inc AX
   push AX
   call far _malloc
   pop CX
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DX
   push AX
   push DS
   pop ES
   pop AX
   pop DX
   mov [ES:BX+06],DX
   mov [ES:BX+04],AX
   mov AL,[BP-01]
   cbw
   push AX
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   push [ES:BX+06]
   push [ES:BX+04]
   push SI
   call far _read
   add SP,+08
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   les BX,[ES:BX+04]
   mov AL,[BP-01]
   cbw
   add BX,AX
   mov byte ptr [ES:BX],00
L1d250135:
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   push SI
   call far _read
   add SP,+08
   or AX,AX
   jle L1d25014e
jmp near L1d250075
L1d25014e:
   mov word ptr [BP-06],0000
jmp near L1d250163
L1d250155:
   mov BX,[BP-06]
   shl BX,1
   mov word ptr [BX+offset _stateinfo],0000
   inc word ptr [BP-06]
L1d250163:
   cmp word ptr [BP-06],+06
   jl L1d250155
   or word ptr [offset _stateinfo+08],0002
   or word ptr [offset _stateinfo+00],0001
   or word ptr [offset _stateinfo+04],0001
   or word ptr [offset _stateinfo+06],0000
   or word ptr [offset _stateinfo+0a],0002
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1d3d ;; DESIGN.C:DESIGN
_infname: ;; 1d3d000d
   push BP
   mov BP,SP
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _clearvp
   mov SP,BP
   push [BP+08]
   push [BP+06]
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   mov SP,BP
   mov AX,000C
   push AX
   push [BP+0C]
   push [BP+0A]
   mov AX,0002
   push AX
   mov AX,0008
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _winput
   mov SP,BP
   pop BP
ret far

_printobjinfo: ;; 1d3d0059
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   mov SI,[BP+06]
   push DS
   mov AX,offset Y2a1717ec
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   push [BX+offset _kindname+02]
   push [BX+offset _kindname]
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a1717fe
   push AX
   mov AX,0002
   push AX
   mov AX,0006
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+0D]
   call far _itoa
   add SP,+08
   push DX
   push AX
   mov AX,0002
   push AX
   mov AX,0006
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171810
   push AX
   mov AX,0002
   push AX
   mov AX,000C
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   call far _itoa
   add SP,+08
   push DX
   push AX
   mov AX,0002
   push AX
   mov AX,000C
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171822
   push AX
   mov AX,0002
   push AX
   mov AX,0012
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+07]
   call far _itoa
   add SP,+08
   push DX
   push AX
   mov AX,0002
   push AX
   mov AX,0012
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171834
   push AX
   mov AX,0002
   push AX
   mov AX,0018
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _itoa
   add SP,+08
   push DX
   push AX
   mov AX,0002
   push AX
   mov AX,0018
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],0040
   jz L1d3d0262
   push DS
   mov AX,offset Y2a171846
   push AX
   mov AX,0002
   push AX
   mov AX,001E
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
L1d3d0262:
   pop SI
   mov SP,BP
   pop BP
ret far

_objdesign: ;; 1d3d0267
   push BP
   mov BP,SP
   sub SP,+4A
   push SI
   push DI
   mov DI,[BP+06]
   mov SI,FFFF
   mov word ptr [BP-46],0000
   mov AX,DI
   mov CL,04
   shl AX,CL
   mov DI,AX
   mov AX,[BP+08]
   mov CL,04
   shl AX,CL
   add AX,[offset _disy]
   mov [BP+08],AX
   mov word ptr [BP-4A],0000
jmp near L1d3d02f1
L1d3d0297:
   mov AX,[BP-4A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,DI
   jnz L1d3d02ee
   mov AX,[BP-4A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP+08]
   jnz L1d3d02ee
   mov SI,[BP-4A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   les BX,[BX+offset _kindname]
   mov [BP-42],ES
   mov [BP-44],BX
L1d3d02ee:
   inc word ptr [BP-4A]
L1d3d02f1:
   mov AX,[BP-4A]
   cmp AX,[offset _numobjs]
   jl L1d3d0297
   cmp SI,-01
   jnz L1d3d0307
   mov [BP-42],DS
   mov word ptr [BP-44],1852
L1d3d0307:
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a171857
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171863
   push AX
   mov AX,0002
   push AX
   mov AX,0006
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a17186e
   push AX
   mov AX,0002
   push AX
   mov AX,000C
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   push DS
   mov AX,offset Y2a171878
   push AX
   mov AX,0002
   push AX
   mov AX,0012
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   push [BP-42]
   push [BP-44]
   mov AX,0002
   push AX
   mov AX,0012
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   mov AX,0002
   push AX
   mov AX,0018
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wgetkey
   add SP,+0A
   push AX
   call far _toupper
   pop CX
   mov [offset _key],AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _clearvp
   pop CX
   pop CX
   mov AX,[offset _key]
   sub AX,0041
   cmp AX,000F
   jbe L1d3d03df
jmp near L1d3d0501
L1d3d03df:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y1d3d03e8]
Y1d3d03e8:	dw L1d3d0408,L1d3d0501,L1d3d0501,L1d3d0424,L1d3d0501,L1d3d0501,L1d3d0501,L1d3d0501
		dw L1d3d0501,L1d3d0501,L1d3d04f0,L1d3d0501,L1d3d04fa,L1d3d0501,L1d3d04bb,L1d3d0441
L1d3d0408:
   mov SI,[offset _numobjs]
   push [BP+08]
   push DI
   mov AX,0003
   push AX
   call far _addobj
   add SP,+06
L1d3d041c:
   mov word ptr [BP-46],0001
jmp near L1d3d0501
L1d3d0424:
   or SI,SI
   jg L1d3d042b
jmp near L1d3d09a3
L1d3d042b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov byte ptr [ES:BX],03
jmp near L1d3d09a3
L1d3d0441:
   push [BP+08]
   push DI
   mov AX,[offset Y2a1717ea]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   push AX
   call far _addobj
   add SP,+06
   mov AX,001F
   push AX
   push DS
   mov AX,[offset Y2a1717ea]
   mov DX,001F
   mul DX
   add AX,offset _objs
   push AX
   push DS
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   add AX,offset _objs
   push AX
   call far _memcpy
   add SP,+0A
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov [ES:BX+01],DI
   mov AX,[BP+08]
   push AX
   mov AX,[offset _numobjs]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
jmp near L1d3d09a3
L1d3d04bb:
   mov AX,[offset Y2a1717ea]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov [ES:BX+01],DI
   mov AX,[BP+08]
   push AX
   mov AX,[offset Y2a1717ea]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
   call far _drawboard
jmp near L1d3d09a3
L1d3d04f0:
   or SI,SI
   jl L1d3d0501
   mov [offset Y2a1717ea],SI
jmp near L1d3d0501
L1d3d04fa:
   or SI,SI
   jl L1d3d0501
jmp near L1d3d041c
L1d3d0501:
   cmp word ptr [BP-46],+00
   jnz L1d3d050a
jmp near L1d3d09a8
L1d3d050a:
   push SI
   push CS
   call near offset _printobjinfo
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   push [BX+offset _kindname+02]
   push [BX+offset _kindname]
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcpy
   add SP,+08
   mov AX,000C
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _winput
   add SP,+10
   push SS
   lea AX,[BP-40]
   push AX
   call far _strupr
   pop CX
   pop CX
   mov word ptr [BP-4A],0000
jmp near L1d3d05ae
L1d3d0572:
   mov BX,[BP-4A]
   shl BX,1
   shl BX,1
   push [BX+offset _kindname+02]
   push [BX+offset _kindname]
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L1d3d05ab
   mov AL,[BP-4A]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX],AL
jmp near L1d3d05b4
L1d3d05ab:
   inc word ptr [BP-4A]
L1d3d05ae:
   cmp word ptr [BP-4A],+45
   jl L1d3d0572
L1d3d05b4:
   push SI
   push CS
   call near offset _printobjinfo
   pop CX
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+0D]
   call far _itoa
   add SP,+08
   mov AX,000C
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,0002
   push AX
   mov AX,0006
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _winput
   add SP,+10
   cmp byte ptr [BP-40],00
   jz L1d3d0627
   push SS
   lea AX,[BP-40]
   push AX
   call far _atol
   pop CX
   pop CX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
L1d3d0627:
   push SI
   push CS
   call near offset _printobjinfo
   pop CX
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   call far _itoa
   add SP,+08
   mov AX,000C
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,0002
   push AX
   mov AX,000C
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _winput
   add SP,+10
   cmp byte ptr [BP-40],00
   jz L1d3d069a
   push SS
   lea AX,[BP-40]
   push AX
   call far _atol
   pop CX
   pop CX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L1d3d069a:
   push SI
   push CS
   call near offset _printobjinfo
   pop CX
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+07]
   call far _itoa
   add SP,+08
   mov AX,000C
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,0002
   push AX
   mov AX,0012
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _winput
   add SP,+10
   cmp byte ptr [BP-40],00
   jz L1d3d070d
   push SS
   lea AX,[BP-40]
   push AX
   call far _atol
   pop CX
   pop CX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L1d3d070d:
   push SI
   push CS
   call near offset _printobjinfo
   pop CX
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+13]
   call far _itoa
   add SP,+08
   mov AX,000C
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,0002
   push AX
   mov AX,0018
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _winput
   add SP,+10
   cmp byte ptr [BP-40],00
   jz L1d3d0780
   push SS
   lea AX,[BP-40]
   push AX
   call far _atol
   pop CX
   pop CX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
L1d3d0780:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+offset _kindxl]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+offset _kindyl]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],0040
   jnz L1d3d0802
jmp near L1d3d0975
L1d3d0802:
   push SI
   push CS
   call near offset _printobjinfo
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],15
   jnz L1d3d0824
   mov word ptr [BP-48],0001
jmp near L1d3d0829
L1d3d0824:
   mov word ptr [BP-48],0002
L1d3d0829:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jnz L1d3d0848
   mov byte ptr [BP-40],00
jmp near L1d3d086c
L1d3d0848:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcpy
   add SP,+08
L1d3d086c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+05]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _fontcolor
   add SP,+08
   mov AX,0040
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   push [BP-48]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _winput
   add SP,+10
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1d3d091b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far _free
   pop CX
   pop CX
L1d3d091b:
   push SS
   lea AX,[BP-40]
   push AX
   call far _strlen
   pop CX
   pop CX
   inc AX
   push AX
   call far _malloc
   pop CX
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   pop DX
   mov [ES:BX+19],DX
   mov [ES:BX+17],AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far _strcpy
   add SP,+08
   push SI
   call far _setobjsize
   pop CX
L1d3d0975:
   push SI
   push CS
   call near offset _printobjinfo
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov BX,[BX+offset _kindtable]
   shl BX,1
   mov word ptr [BX+offset _shm_want],0001
   call far _shm_do
L1d3d09a3:
   mov AX,0001
jmp near L1d3d09aa
L1d3d09a8:
   xor AX,AX
L1d3d09aa:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_design: ;; 1d3d09b0
   push BP
   mov BP,SP
   sub SP,+5E
   push SI
   push DI
   mov word ptr [BP-5E],0000
   mov word ptr [BP-5A],0001
   mov word ptr [BP-56],0000
   mov word ptr [offset _disy],0000
   mov word ptr [offset _designflag],0001
   mov byte ptr [BP-54],00
   mov byte ptr [BP-34],00
   call far _setorigin
   mov AX,[offset _objs+01]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
   mov AX,[offset _objs+03]
   cwd
   idiv BX
   mov SI,AX
   call far _drawboard
L1d3d09f8:
   cmp word ptr [BP-56],+00
   jz L1d3d0a19
   push [BP-5A]
   push SI
   push DI
   call far _setboard
   add SP,+06
   push SI
   push DI
   call far _drawcell
   pop CX
   pop CX
   mov word ptr [BP-5E],0001
L1d3d0a19:
   mov AX,SI
   mov CL,04
   shl AX,CL
   add AX,0004
   push AX
   mov AX,DI
   mov CL,04
   shl AX,CL
   add AX,0004
   push AX
   mov AX,0100
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _drawshape
   add SP,+0A
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-14]
   push AX
   call far _coreleft
   push DX
   push AX
   call far _ltoa
   add SP,+0A
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
L1d3d0a73:
   xor AX,AX
   push AX
   call far _checkctrl
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L1d3d0a97
   cmp word ptr [offset _dy1],+00
   jnz L1d3d0a97
   cmp word ptr [offset _key],+00
   jnz L1d3d0a97
   cmp word ptr [BP-5E],+00
   jz L1d3d0a73
L1d3d0a97:
   mov word ptr [BP-5E],0000
   push SI
   push DI
   call far _modboard
   pop CX
   pop CX
   xor AX,AX
   push AX
   call far _updobjs
   pop CX
   xor AX,AX
   push AX
   call far _refresh
   pop CX
   call far _purgeobjs
   cmp word ptr [offset _dx1],+00
   jnz L1d3d0acd
   cmp word ptr [offset _dy1],+00
   jnz L1d3d0acd
jmp near L1d3d0c1b
L1d3d0acd:
   mov AX,[offset _scrnxs]
   mov BX,0002
   cwd
   idiv BX
   dec AX
   mul word ptr [offset _fire1]
   inc AX
   mul word ptr [offset _dx1]
   add DI,AX
   mov AX,[offset _scrnys]
   cwd
   idiv BX
   dec AX
   mul word ptr [offset _fire1]
   inc AX
   mul word ptr [offset _dy1]
   add SI,AX
   or DI,DI
   jge L1d3d0afa
   xor DI,DI
L1d3d0afa:
   cmp DI,0080
   jl L1d3d0b03
   mov DI,007F
L1d3d0b03:
   or SI,SI
   jge L1d3d0b09
   xor SI,SI
L1d3d0b09:
   cmp SI,+40
   jl L1d3d0b11
   mov SI,003F
L1d3d0b11:
   mov AX,DI
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   cmp AX,[ES:BX+08]
   jge L1d3d0b40
   mov AX,[offset _scrnxs]
   shl AX,1
   shl AX,1
   shl AX,1
   sub [ES:BX+08],AX
   cmp word ptr [ES:BX+08],+00
   jge L1d3d0b3b
   mov word ptr [ES:BX+08],0000
L1d3d0b3b:
   call far _drawboard
L1d3d0b40:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov DX,[offset _scrnxs]
   mov CL,04
   shl DX,CL
   add AX,DX
   add AX,FFF0
   mov DX,DI
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jg L1d3d0b99
   mov AX,[offset _scrnxs]
   shl AX,1
   shl AX,1
   shl AX,1
   add [ES:BX+08],AX
   mov AX,[ES:BX+08]
   mov DX,0080
   sub DX,[offset _scrnxs]
   mov CL,04
   shl DX,CL
   add DX,+08
   cmp AX,DX
   jl L1d3d0b94
   mov AX,0080
   sub AX,[offset _scrnxs]
   mov CL,04
   shl AX,CL
   add AX,0008
   mov [ES:BX+08],AX
L1d3d0b94:
   call far _drawboard
L1d3d0b99:
   mov AX,SI
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   cmp AX,[ES:BX+0A]
   jge L1d3d0bc8
   mov AX,[offset _scrnys]
   shl AX,1
   shl AX,1
   shl AX,1
   sub [ES:BX+0A],AX
   cmp word ptr [ES:BX+0A],+00
   jge L1d3d0bc3
   mov word ptr [ES:BX+0A],0000
L1d3d0bc3:
   call far _drawboard
L1d3d0bc8:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov DX,[offset _scrnys]
   dec DX
   mov CL,04
   shl DX,CL
   add AX,DX
   mov DX,SI
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jg L1d3d0c1b
   mov AX,[offset _scrnys]
   shl AX,1
   shl AX,1
   shl AX,1
   add [ES:BX+0A],AX
   mov AX,[ES:BX+0A]
   mov DX,0040
   sub DX,[offset _scrnys]
   inc DX
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jl L1d3d0c16
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
   mov [ES:BX+0A],AX
L1d3d0c16:
   call far _drawboard
L1d3d0c1b:
   push [offset _key]
   call far _toupper
   pop CX
   mov CX,000E
   mov BX,offset Y1d3d0c3b
L1d3d0c2b:
   cmp AX,[CS:BX]
   jz L1d3d0c37
   inc BX
   inc BX
   loop L1d3d0c2b
jmp near L1d3d0ff8
L1d3d0c37:
jmp near [CS:BX+1C]
Y1d3d0c3b:	dw 0009,000d,0020,0048,0049,004b,004c
		dw 004e,004f,0053,0056,0059,005a,0060
Y1d3d0c57:	dw L1d3d0d3b,L1d3d0c73,L1d3d0d67,L1d3d0dcc,L1d3d0d7c,L1d3d0d49,L1d3d0eb1
		dw L1d3d0fa8,L1d3d0e6d,L1d3d0fd5,L1d3d0d95,L1d3d0f2f,L1d3d0e7b,L1d3d0ef1
L1d3d0c73:
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a17187e
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   mov AX,0010
   push AX
   push SS
   lea AX,[BP-54]
   push AX
   mov AX,0002
   push AX
   mov AX,0008
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _winput
   add SP,+10
   push SS
   lea AX,[BP-54]
   push AX
   call far _strupr
   pop CX
   pop CX
   mov word ptr [BP-58],0000
jmp near L1d3d0d32
L1d3d0ccd:
   mov BX,[BP-58]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   push [ES:BX+06]
   push [ES:BX+04]
   push SS
   lea AX,[BP-54]
   push AX
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L1d3d0d2f
   mov AX,[BP-58]
   mov [BP-5A],AX
   push AX
   push SI
   push DI
   call far _setboard
   add SP,+06
   mov BX,[BP-58]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov BX,[ES:BX]
   mov CL,08
   sar BX,CL
   and BX,003F
   shl BX,1
   mov word ptr [BX+offset _shm_want],0001
   call far _shm_do
jmp near L1d3d0d74
L1d3d0d2f:
   inc word ptr [BP-58]
L1d3d0d32:
   cmp word ptr [BP-58],0258
   jl L1d3d0ccd
jmp near L1d3d0d74
L1d3d0d3b:
   mov AX,[BP-56]
   neg AX
   sbb AX,AX
   inc AX
   mov [BP-56],AX
jmp near L1d3d0ff8
L1d3d0d49:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-5A],AX
jmp near L1d3d0ff8
L1d3d0d67:
   push [BP-5A]
   push SI
   push DI
   call far _setboard
   add SP,+06
L1d3d0d74:
   mov word ptr [BP-5E],0001
jmp near L1d3d0ff8
L1d3d0d7c:
   mov word ptr [offset _pl+26],0000
   mov word ptr [offset _pl+26],0064
   mov AX,0001
   push AX
   call far _printhi
   pop CX
jmp near L1d3d0ff8
L1d3d0d95:
   cmp word ptr [offset _pl+04],+00
   jnz L1d3d0da7
   xor AX,AX
   push AX
   call far _addinv
   pop CX
jmp near L1d3d0db2
L1d3d0da7:
   mov word ptr [offset _pl+04],0000
   call far _initinv
L1d3d0db2:
   mov word ptr [offset _pl+26+02],0000
   mov word ptr [offset _pl+26],0000
   mov word ptr [offset _pl],0000
   call far _drawstats
jmp near L1d3d0ff8
L1d3d0dcc:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-58],AX
   mov [BP-5C],DI
jmp near L1d3d0e09
L1d3d0dec:
   push [BP-5A]
   push SI
   push [BP-5C]
   call far _setboard
   add SP,+06
   push SI
   push [BP-5C]
   call far _drawcell
   pop CX
   pop CX
   dec word ptr [BP-5C]
L1d3d0e09:
   mov BX,[BP-5C]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-58]
   jz L1d3d0dec
   mov AX,DI
   inc AX
   mov [BP-5C],AX
jmp near L1d3d0e4c
L1d3d0e2f:
   push [BP-5A]
   push SI
   push [BP-5C]
   call far _setboard
   add SP,+06
   push SI
   push [BP-5C]
   call far _drawcell
   pop CX
   pop CX
   inc word ptr [BP-5C]
L1d3d0e4c:
   mov BX,[BP-5C]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-58]
   jz L1d3d0e2f
jmp near L1d3d0ff8
L1d3d0e6d:
   push SI
   push DI
   push CS
   call near offset _objdesign
   pop CX
   pop CX
   mov [BP-5E],AX
jmp near L1d3d0ff8
L1d3d0e7b:
   push SS
   lea AX,[BP-34]
   push AX
   push DS
   mov AX,offset Y2a171883
   push AX
   push CS
   call near offset _infname
   add SP,+08
   mov AL,[BP-34]
   cbw
   push AX
   call far _toupper
   pop CX
   cmp AX,0059
   jz L1d3d0e9f
jmp near L1d3d0ff8
L1d3d0e9f:
   call far _initboard
   call far _initobjs
L1d3d0ea9:
   call far _drawboard
jmp near L1d3d0ff8
L1d3d0eb1:
   push SS
   lea AX,[BP-34]
   push AX
   push DS
   mov AX,offset Y2a17188a
   push AX
   push CS
   call near offset _infname
   add SP,+08
   cmp byte ptr [BP-34],00
   jnz L1d3d0ecb
jmp near L1d3d0ff8
L1d3d0ecb:
   push SS
   lea AX,[BP-34]
   push AX
   call far _loadboard
   pop CX
   pop CX
   call far _setorigin
   mov AX,[offset _objs+01]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
   mov AX,[offset _objs+03]
   cwd
   idiv BX
   mov SI,AX
jmp near L1d3d0ea9
L1d3d0ef1:
   xor AX,AX
   push AX
   call far _checkctrl
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L1d3d0f08
   cmp word ptr [offset _dy1],+00
   jz L1d3d0ef1
L1d3d0f08:
   mov AX,[offset _dy1]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,[offset _dx1]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _scrollvp
   add SP,+08
jmp near L1d3d0ff8
L1d3d0f2f:
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y2a171890
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _wprint
   add SP,+0E
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-54]
   push AX
   push [offset _disy]
   call far _itoa
   add SP,+08
   mov AX,0010
   push AX
   push SS
   lea AX,[BP-54]
   push AX
   mov AX,0002
   push AX
   mov AX,0008
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _winput
   add SP,+10
   push SS
   lea AX,[BP-54]
   push AX
   call far _atol
   pop CX
   pop CX
   mov [offset _disy],AX
   push SS
   lea AX,[BP-54]
   push AX
   call far _strupr
   pop CX
   pop CX
jmp near L1d3d0ff8
L1d3d0fa8:
   push SS
   lea AX,[BP-34]
   push AX
   push DS
   mov AX,offset Y2a171897
   push AX
   push CS
   call near offset _infname
   add SP,+08
   mov AL,[BP-34]
   cbw
   push AX
   call far _toupper
   pop CX
   cmp AX,0059
   jnz L1d3d0ff8
   call far _zapobjs
   call far _initboard
jmp near L1d3d0ff8
L1d3d0fd5:
   push SS
   lea AX,[BP-34]
   push AX
   push DS
   mov AX,offset Y2a1718a2
   push AX
   push CS
   call near offset _infname
   add SP,+08
   cmp byte ptr [BP-34],00
   jz L1d3d0ff8
   push SS
   lea AX,[BP-34]
   push AX
   call far _saveboard
   pop CX
   pop CX
L1d3d0ff8:
   cmp word ptr [offset _key],+1B
   jz L1d3d1002
jmp near L1d3d09f8
L1d3d1002:
   mov word ptr [offset _key],0000
   mov word ptr [offset _designflag],0000
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1e3e ;; JMAN.C:JMAN, JVOL.C:JVOL
_setboard: ;; 1e3e0004
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   or SI,SI
   jl L1e3e003c
   cmp SI,0080
   jge L1e3e003c
   or DI,DI
   jl L1e3e003c
   cmp DI,+40
   jge L1e3e003c
   mov AX,[BP+0A]
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
L1e3e003c:
   pop DI
   pop SI
   pop BP
ret far

_modboard: ;; 1e3e0040
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   or SI,SI
   jl L1e3e0075
   cmp SI,0080
   jge L1e3e0075
   or DI,DI
   jl L1e3e0075
   cmp DI,+40
   jge L1e3e0075
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
L1e3e0075:
   pop DI
   pop SI
   pop BP
ret far

_initobjs: ;; 1e3e0079
   mov word ptr [offset _numobjs],0001
   mov byte ptr [offset _objs],00
   mov word ptr [offset _objs+01],0020
   mov word ptr [offset _objs+03],0020
   mov word ptr [offset _objs+05],0000
   mov word ptr [offset _objs+07],0000
   mov word ptr [offset _objs+0d],0000
   mov word ptr [offset _objs+0f],0000
   mov word ptr [offset _objs+11],0000
   mov word ptr [offset _objs+13],0000
   mov AX,[offset _kindxl]
   mov [offset _objs+09],AX
   mov AX,[offset _kindyl]
   mov [offset _objs+0b],AX
   mov word ptr [offset _objs+1b],0000
   mov word ptr [offset _objs+1d],0000
   mov word ptr [offset _objs+19],0000
   mov word ptr [offset _objs+17],0000
   mov word ptr [offset _pl+04],0000
   mov word ptr [offset _pl],0001
   call far _initinv
   mov AL,00
   push AX
   mov AX,0016
   push AX
   push DS
   mov AX,offset _pl+30
   push AX
   call far _setmem
   add SP,+08
ret far

_playerkill: ;; 1e3e00fe
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   push [BX+offset _kindscore]
   call far _addscore
   add SP,+06
   push SI
   call far _notemod
   pop CX
   push SI
   call far _killobj
   pop CX
   pop SI
   pop BP
ret far

_countobj: ;; 1e3e015f
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   mov SI,DI
jmp near L1e3e018c
L1e3e016a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   cmp AX,[BP+06]
   jnz L1e3e0187
   mov AX,0001
jmp near L1e3e0189
L1e3e0187:
   xor AX,AX
L1e3e0189:
   add DI,AX
   inc SI
L1e3e018c:
   cmp SI,[offset _numobjs]
   jl L1e3e016a
   mov AX,DI
   pop DI
   pop SI
   pop BP
ret far

_notemod: ;; 1e3e0198
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov CL,04
   sar AX,CL
   mov [BP-0A],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov AX,[BP-06]
   mov [BP-02],AX
jmp near L1e3e025b
L1e3e0243:
   mov DI,[BP-0A]
jmp near L1e3e0253
L1e3e0248:
   push [BP-02]
   push DI
   push CS
   call near offset _modboard
   pop CX
   pop CX
   inc DI
L1e3e0253:
   cmp DI,[BP-08]
   jl L1e3e0248
   inc word ptr [BP-02]
L1e3e025b:
   mov AX,[BP-02]
   cmp AX,[BP-04]
   jl L1e3e0243
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_setobjsize: ;; 1e3e0269
   push BP
   mov BP,SP
   sub SP,+08
   push SI
   push DI
   mov SI,[BP+06]
   xor DI,DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+offset _kindxl]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+offset _kindyl]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1e3e030f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far _strlen
   pop CX
   pop CX
   mov DI,AX
L1e3e030f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],14
   jnz L1e3e0343
   mov AX,DI
   mov DX,0006
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
jmp near L1e3e03d4
L1e3e0343:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],15
   jnz L1e3e0377
   mov AX,DI
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
jmp near L1e3e03d4
L1e3e0377:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],1B
   jnz L1e3e03d4
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-08]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+0D]
   call far _itoa
   add SP,+08
   push DX
   push AX
   call far _strlen
   pop CX
   pop CX
   inc AX
   inc AX
   mul word ptr [offset _kindxl+2*1b]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
L1e3e03d4:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_findcheckpt: ;; 1e3e03da
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L1e3e0414
L1e3e03e2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],0C
   jnz L1e3e0413
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[BP+06]
   jnz L1e3e0413
   mov AX,SI
jmp near L1e3e041c
L1e3e0413:
   inc SI
L1e3e0414:
   cmp SI,[offset _numobjs]
   jl L1e3e03e2
   xor AX,AX
L1e3e041c:
   pop SI
   pop BP
ret far

_dolevelsong: ;; 1e3e041f
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   push [offset _pl]
   push CS
   call near offset _findcheckpt
   pop CX
   mov SI,AX
   or SI,SI
   jg L1e3e0439
jmp near L1e3e04c3
L1e3e0439:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1e3e04c3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   les BX,[ES:BX+17]
   cmp byte ptr [ES:BX],2A
   jz L1e3e049d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   les BX,[ES:BX+17]
   cmp byte ptr [ES:BX],23
   jz L1e3e049d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   les BX,[ES:BX+17]
   cmp byte ptr [ES:BX],26
   jnz L1e3e04c3
L1e3e049d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push DS
   mov AX,offset _newlevel
   push AX
   call far _strcpy
   add SP,+08
jmp near L1e3e0519
L1e3e04c3:
   xor AX,AX
   push AX
   push CS
   call near offset _findcheckpt
   pop CX
   mov [BP-02],AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   les BX,[ES:BX+17]
   mov AL,[ES:BX]
   cbw
   mov DI,AX
   cmp DI,+2A
   jz L1e3e04f4
   cmp DI,+23
   jz L1e3e04f4
   cmp DI,+26
   jnz L1e3e0519
L1e3e04f4:
   mov AX,[BP-02]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push DS
   mov AX,offset _newlevel
   push AX
   call far _strcpy
   add SP,+08
L1e3e0519:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_p_reenter: ;; 1e3e051f
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   or word ptr [offset _statmodflg],C000
   push [offset _pl]
   push CS
   call near offset _findcheckpt
   pop CX
   mov SI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov [BP-0C],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-0A],AX
   cmp byte ptr [offset _objs],17
   jz L1e3e056f
   sub word ptr [BP-0A],+10
L1e3e056f:
   or SI,SI
   jle L1e3e05d2
   cmp word ptr [BP+06],+00
   jz L1e3e05d2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L1e3e05d2
   mov DX,[offset _pl+2c+02]
   mov AX,[offset _pl+2c]
   mov [BP-02],DX
   mov [BP-04],AX
   mov AX,[offset _pl]
   mov [BP-06],AX
   push DS
   mov AX,offset _curlevel
   push AX
   call far _loadboard
   pop CX
   pop CX
   mov AX,[BP-06]
   mov [offset _pl],AX
   mov DX,[BP-02]
   mov AX,[BP-04]
   mov [offset _pl+26+02],DX
   mov [offset _pl+26],AX
   mov word ptr [offset _pl+02],0006
   push [offset _pl]
   push CS
   call near offset _findcheckpt
   pop CX
   mov SI,AX
L1e3e05d2:
   mov DX,[offset _pl+26+02]
   mov AX,[offset _pl+26]
   mov [offset _pl+2c+02],DX
   mov [offset _pl+2c],AX
   push CS
   call near offset _dolevelsong
   and word ptr [BP-0C],FFF8
   mov AX,[BP-0C]
   mov [offset _objs+01],AX
   mov AX,[BP-0A]
   mov [offset _objs+03],AX
   call far _setorigin
   xor DI,DI
jmp near L1e3e0634
L1e3e05fe:
   mov word ptr [BP-08],0000
jmp near L1e3e062d
L1e3e0605:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-08]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   or AX,C000
   push AX
   push [BP-08]
   push DI
   push CS
   call near offset _setboard
   add SP,+06
   inc word ptr [BP-08]
L1e3e062d:
   cmp word ptr [BP-08],+40
   jl L1e3e0605
   inc DI
L1e3e0634:
   cmp DI,0080
   jl L1e3e05fe
   mov word ptr [offset _objs+0d],0004
   mov word ptr [offset _objs+11],0000
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_p_ouch: ;; 1e3e064c
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   cmp byte ptr [offset _objs],17
   jnz L1e3e0661
jmp near L1e3e0715
L1e3e0661:
   cmp byte ptr [offset _objs],00
   jnz L1e3e0679
   mov BX,[offset _objs+0d]
   shl BX,1
   test word ptr [BX+offset _stateinfo],0002
   jz L1e3e0679
jmp near L1e3e0715
L1e3e0679:
   mov AX,000A
   push AX
   call far _invcount
   pop CX
   sub SI,AX
   or SI,SI
   jg L1e3e068c
jmp near L1e3e0715
L1e3e068c:
   or word ptr [offset _statmodflg],C000
   sub [offset _pl+02],SI
   mov word ptr [offset _pl+2a],0001
   cmp word ptr [offset _pl+02],+00
   jle L1e3e06b4
   mov AX,0013
   push AX
   mov AX,0004
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L1e3e0715
L1e3e06b4:
   mov word ptr [offset _pl+02],0000
   mov byte ptr [offset _objs],00
   mov word ptr [offset _objs+09],0010
   mov word ptr [offset _objs+0b],0020
   mov word ptr [offset _objs+0d],0005
   mov word ptr [offset _objs+11],0000
   mov [offset _objs+0f],DI
   cmp DI,+01
   jnz L1e3e06ea
   mov AX,[offset _objs+03]
   dec AX
   and AX,FFF0
   mov [offset _objs+03],AX
L1e3e06ea:
   mov word ptr [offset _objs+07],FFF4
   mov AX,DI
   add AX,0027
   push AX
   mov AX,0004
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,000A
   push AX
   push [offset _objs+03]
   push [offset _objs+01]
   call far _explode1
   add SP,+06
L1e3e0715:
   pop DI
   pop SI
   pop BP
ret far

_seekplayer: ;; 1e3e0719
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,[offset _objs+01]
   jge L1e3e073e
   mov AX,0001
jmp near L1e3e0740
L1e3e073e:
   xor AX,AX
L1e3e0740:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,[offset _objs+01]
   jle L1e3e075f
   mov AX,0001
jmp near L1e3e0761
L1e3e075f:
   xor AX,AX
L1e3e0761:
   pop DX
   sub DX,AX
   les BX,[BP+08]
   mov [ES:BX],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[offset _objs+03]
   jge L1e3e0788
   mov AX,0001
jmp near L1e3e078a
L1e3e0788:
   xor AX,AX
L1e3e078a:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[offset _objs+03]
   jle L1e3e07a9
   mov AX,0001
jmp near L1e3e07ab
L1e3e07a9:
   xor AX,AX
L1e3e07ab:
   pop DX
   sub DX,AX
   les BX,[BP+0C]
   mov [ES:BX],DX
   pop SI
   pop BP
ret far

_modjunglescroll: ;; 1e3e07b7
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   cmp word ptr [BP+06],+00
   jg L1e3e07c8
jmp near L1e3e089f
L1e3e07c8:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   add AX,[ES:BX+04]
   sub AX,[BP+06]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-02],AX
   mov BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,[offset _gamevp]
   add AX,[ES:BX+04]
   dec AX
   mov BX,0010
   cwd
   idiv BX
   cmp AX,007F
   jge L1e3e0815
   mov BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,[offset _gamevp]
   add AX,[ES:BX+04]
   dec AX
   mov BX,0010
   cwd
   idiv BX
jmp near L1e3e0818
L1e3e0815:
   mov AX,007F
L1e3e0818:
   mov [BP-04],AX
   mov DI,[BP-02]
jmp near L1e3e0895
L1e3e0821:
   mov word ptr [BP-0C],0000
jmp near L1e3e088b
L1e3e0828:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   add AX,[BP-0C]
   cmp AX,003F
   jge L1e3e0853
   mov BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
   add SI,[BP-0C]
jmp near L1e3e0856
L1e3e0853:
   mov SI,003F
L1e3e0856:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   or AX,[BP+0A]
   push AX
   push SI
   push DI
   push CS
   call near offset _setboard
   add SP,+06
   cmp word ptr [BP+0A],4000
   jnz L1e3e0888
   push SI
   push DI
   call far _drawcell
   pop CX
   pop CX
L1e3e0888:
   inc word ptr [BP-0C]
L1e3e088b:
   mov AX,[offset _scrnys]
   inc AX
   cmp AX,[BP-0C]
   jg L1e3e0828
   inc DI
L1e3e0895:
   cmp DI,[BP-04]
   jg L1e3e089d
jmp near L1e3e0821
L1e3e089d:
jmp near L1e3e0913
L1e3e089f:
   cmp word ptr [BP+06],+00
   jge L1e3e0913
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-0A],AX
   mov word ptr [BP-0C],0000
jmp near L1e3e090a
L1e3e08bd:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
   add SI,[BP-0C]
   mov BX,[BP-0A]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   or AX,[BP+0A]
   push AX
   push SI
   push [BP-0A]
   push CS
   call near offset _setboard
   add SP,+06
   cmp word ptr [BP+0A],4000
   jnz L1e3e0907
   push SI
   push [BP-0A]
   call far _drawcell
   pop CX
   pop CX
L1e3e0907:
   inc word ptr [BP-0C]
L1e3e090a:
   mov AX,[offset _scrnys]
   inc AX
   cmp AX,[BP-0C]
   jg L1e3e08bd
L1e3e0913:
   cmp word ptr [BP+08],+00
   jg L1e3e091c
jmp near L1e3e09d2
L1e3e091c:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   add AX,[ES:BX+06]
   mov [BP-08],AX
   dec AX
   mov BX,0010
   cwd
   idiv BX
   cmp AX,003F
   jge L1e3e0940
   mov AX,[BP-08]
   dec AX
   cwd
   idiv BX
jmp near L1e3e0943
L1e3e0940:
   mov AX,003F
L1e3e0943:
   mov [BP-06],AX
   mov AX,[BP-08]
   sub AX,[BP+08]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
jmp near L1e3e09c7
L1e3e0956:
   xor DI,DI
jmp near L1e3e09be
L1e3e095a:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
   cmp AX,007F
   jge L1e3e0981
   mov BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
jmp near L1e3e0984
L1e3e0981:
   mov AX,007F
L1e3e0984:
   mov [BP-0A],AX
   mov BX,AX
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   or AX,[BP+0A]
   push AX
   push SI
   push [BP-0A]
   push CS
   call near offset _setboard
   add SP,+06
   cmp word ptr [BP+0A],4000
   jnz L1e3e09bd
   push SI
   push [BP-0A]
   call far _drawcell
   pop CX
   pop CX
L1e3e09bd:
   inc DI
L1e3e09be:
   mov AX,[offset _scrnxs]
   inc AX
   cmp AX,DI
   jg L1e3e095a
   inc SI
L1e3e09c7:
   cmp SI,[BP-06]
   jg L1e3e09cf
jmp near L1e3e0956
L1e3e09cf:
jmp near L1e3e0a77
L1e3e09d2:
   cmp word ptr [BP+08],+00
   jl L1e3e09db
jmp near L1e3e0a77
L1e3e09db:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
jmp near L1e3e0a5e
L1e3e09ed:
   xor DI,DI
jmp near L1e3e0a55
L1e3e09f1:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
   cmp AX,007F
   jge L1e3e0a18
   mov BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
jmp near L1e3e0a1b
L1e3e0a18:
   mov AX,007F
L1e3e0a1b:
   mov [BP-0A],AX
   mov BX,AX
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   or AX,[BP+0A]
   push AX
   push SI
   push [BP-0A]
   push CS
   call near offset _setboard
   add SP,+06
   cmp word ptr [BP+0A],4000
   jnz L1e3e0a54
   push SI
   push [BP-0A]
   call far _drawcell
   pop CX
   pop CX
L1e3e0a54:
   inc DI
L1e3e0a55:
   mov AX,[offset _scrnxs]
   inc AX
   cmp AX,DI
   jg L1e3e09f1
   inc SI
L1e3e0a5e:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   sub AX,[BP+08]
   dec AX
   mov BX,0010
   cwd
   idiv BX
   cmp AX,SI
   jl L1e3e0a77
jmp near L1e3e09ed
L1e3e0a77:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_junglescroll: ;; 1e3e0a7d
   push BP
   mov BP,SP
   sub SP,+1C
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   mov AX,[offset _oldx0]
   mov CL,04
   sar AX,CL
   mov [BP-10],AX
   mov AX,[offset _oldy0]
   mov CL,04
   sar AX,CL
   mov [BP-0E],AX
   mov AX,[offset _oldx0]
   add AX,[offset _objs+09]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   mov AX,[offset _oldy0]
   add AX,[offset _objs+0b]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,[offset _objs+01]
   mov CL,04
   sar AX,CL
   mov [BP-0C],AX
   mov AX,[offset _objs+03]
   mov CL,04
   sar AX,CL
   mov [BP-0A],AX
   mov AX,[offset _objs+01]
   add AX,[offset _objs+09]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov AX,[offset _objs+03]
   add AX,[offset _objs+0b]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   or SI,SI
   jnz L1e3e0b61
   mov word ptr [BP-18],0000
   mov AX,[BP-10]
   cmp AX,[BP-0C]
   jge L1e3e0b0a
jmp near L1e3e0b0d
L1e3e0b0a:
   mov AX,[BP-0C]
L1e3e0b0d:
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   sub AX,[ES:BX+08]
   mov [BP-16],AX
   mov AX,[BP-08]
   cmp AX,[BP-04]
   jle L1e3e0b26
jmp near L1e3e0b29
L1e3e0b26:
   mov AX,[BP-04]
L1e3e0b29:
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   sub AX,[ES:BX+08]
   mov [BP-14],AX
   mov AX,[ES:BX+04]
   mov [BP-12],AX
   mov AX,DI
   neg AX
   push AX
   xor AX,AX
   push AX
   push [ES:BX+06]
   push [BP-16]
   push AX
   push [BP-18]
   push [offset _gamevp+02]
   push BX
   call far _scroll
   add SP,+10
jmp near L1e3e0bcb
L1e3e0b61:
   or DI,DI
   jnz L1e3e0bcb
   mov word ptr [BP-18],0000
   mov AX,[BP-0E]
   cmp AX,[BP-0A]
   jge L1e3e0b74
jmp near L1e3e0b77
L1e3e0b74:
   mov AX,[BP-0A]
L1e3e0b77:
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   sub AX,[ES:BX+0A]
   mov [BP-16],AX
   mov AX,[BP-06]
   cmp AX,[BP-02]
   jle L1e3e0b90
jmp near L1e3e0b93
L1e3e0b90:
   mov AX,[BP-02]
L1e3e0b93:
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   sub AX,[ES:BX+0A]
   mov [BP-14],AX
   mov AX,[ES:BX+06]
   mov [BP-12],AX
   xor AX,AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [BP-16]
   push [ES:BX+04]
   push [BP-18]
   xor AX,AX
   push AX
   push [offset _gamevp+02]
   push BX
   call far _scroll
   add SP,+10
L1e3e0bcb:
   mov AX,[BP-10]
   mov [BP-1C],AX
jmp near L1e3e0c1e
L1e3e0bd3:
   mov AX,[BP-0E]
   mov [BP-1A],AX
jmp near L1e3e0c13
L1e3e0bdb:
   push [BP-1A]
   push [BP-1C]
   call far _drawcell
   pop CX
   pop CX
   mov BX,[BP-1C]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-1A]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,7FFF
   push AX
   push [BP-1A]
   push [BP-1C]
   push CS
   call near offset _setboard
   add SP,+06
   inc word ptr [BP-1A]
L1e3e0c13:
   mov AX,[BP-1A]
   cmp AX,[BP-06]
   jl L1e3e0bdb
   inc word ptr [BP-1C]
L1e3e0c1e:
   mov AX,[BP-1C]
   cmp AX,[BP-08]
   jl L1e3e0bd3
   or SI,SI
   jnz L1e3e0c93
   mov AX,DI
   neg AX
   push AX
   xor AX,AX
   push AX
   les BX,[offset _gamevp]
   push [ES:BX+06]
   push [BP-14]
   push AX
   push [BP-16]
   push [offset _gamevp+02]
   push BX
   call far _scroll
   add SP,+10
   les BX,[offset _gamevp]
   add [ES:BX+0A],DI
   xor AX,AX
   push AX
   push AX
   push AX
   mov AL,[offset _objs]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
   mov AX,DI
   neg AX
   push AX
   xor AX,AX
   push AX
   les BX,[offset _gamevp]
   push [ES:BX+06]
   push [BP-12]
   push AX
   push [BP-14]
   push [offset _gamevp+02]
   push BX
   call far _scroll
   add SP,+10
jmp near L1e3e0d3f
L1e3e0c93:
   or DI,DI
   jnz L1e3e0d03
   xor AX,AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [BP-14]
   les BX,[offset _gamevp]
   push [ES:BX+04]
   push [BP-16]
   xor AX,AX
   push AX
   push [offset _gamevp+02]
   push BX
   call far _scroll
   add SP,+10
   les BX,[offset _gamevp]
   add [ES:BX+08],SI
   xor AX,AX
   push AX
   push AX
   push AX
   mov AL,[offset _objs]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
   xor AX,AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [BP-12]
   les BX,[offset _gamevp]
   push [ES:BX+04]
   push [BP-14]
   xor AX,AX
   push AX
   push [offset _gamevp+02]
   push BX
   call far _scroll
   add SP,+10
jmp near L1e3e0d3f
L1e3e0d03:
   mov AX,DI
   neg AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [offset _gamevp+02]
   push [offset _gamevp]
   call far _scrollvp
   add SP,+08
   les BX,[offset _gamevp]
   add [ES:BX+08],SI
   add [ES:BX+0A],DI
   xor AX,AX
   push AX
   push AX
   push AX
   mov AL,[offset _objs]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
L1e3e0d3f:
   mov AX,4000
   push AX
   push DI
   push SI
   push CS
   call near offset _modjunglescroll
   add SP,+06
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_refresh: ;; 1e3e0d52
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   push DI
   cmp word ptr [BP+06],+00
   jnz L1e3e0d63
jmp near L1e3e0f7b
L1e3e0d63:
   cmp word ptr [offset _statmodflg],+00
   jz L1e3e0d7b
   call far _drawstats
   mov AX,[offset _pagedraw]
   inc AX
   mov CL,0E
   shl AX,CL
   and [offset _statmodflg],AX
L1e3e0d7b:
   mov AX,[offset _scrollxd]
   add AX,[offset _oldscrollxd]
   jnz L1e3e0d8d
   mov AX,[offset _scrollyd]
   add AX,[offset _oldscrollyd]
   jz L1e3e0dec
L1e3e0d8d:
   mov AX,[offset _oldscrollxd]
   les BX,[offset _gamevp]
   sub [ES:BX+08],AX
   mov AX,[offset _oldscrollyd]
   sub [ES:BX+0A],AX
   mov AX,[offset _scrollxd]
   add AX,[offset _oldscrollxd]
   mov [BP-04],AX
   mov AX,[offset _scrollyd]
   add AX,[offset _oldscrollyd]
   mov [BP-02],AX
   neg AX
   push AX
   mov AX,[BP-04]
   neg AX
   push AX
   push [offset _gamevp+02]
   push BX
   call far _scrollvp
   add SP,+08
   mov AX,[BP-04]
   les BX,[offset _gamevp]
   add [ES:BX+08],AX
   mov AX,[BP-02]
   add [ES:BX+0A],AX
   mov AX,C000
   push AX
   push [BP-02]
   push [BP-04]
   push CS
   call near offset _modjunglescroll
   add SP,+06
L1e3e0dec:
   mov AX,[offset _scrollxd]
   mov [offset _oldscrollxd],AX
   mov AX,[offset _scrollyd]
   mov [offset _oldscrollyd],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnxs]
   cmp AX,007F
   jge L1e3e0e1b
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnxs]
jmp near L1e3e0e1e
L1e3e0e1b:
   mov AX,007F
L1e3e0e1e:
   mov [BP-0C],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnys]
   dec AX
   cmp AX,003F
   jge L1e3e0e46
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnys]
   dec AX
jmp near L1e3e0e49
L1e3e0e46:
   mov AX,003F
L1e3e0e49:
   mov [BP-0A],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1e3e0e61
   xor AX,AX
jmp near L1e3e0e70
L1e3e0e61:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1e3e0e70:
   mov [BP-08],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1e3e0e88
   xor AX,AX
jmp near L1e3e0e97
L1e3e0e88:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1e3e0e97:
   mov [BP-06],AX
   mov SI,[BP-0C]
jmp near L1e3e0efb
L1e3e0e9f:
   mov DI,[BP-0A]
jmp near L1e3e0ef5
L1e3e0ea4:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   test word ptr [ES:BX],C000
   jz L1e3e0ef4
   push DI
   push SI
   call far _drawcell
   pop CX
   pop CX
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   mov DX,[offset _pagedraw]
   inc DX
   mov CL,0E
   shl DX,CL
   xor DX,FFFF
   and AX,DX
   push AX
   push DI
   push SI
   push CS
   call near offset _setboard
   add SP,+06
L1e3e0ef4:
   dec DI
L1e3e0ef5:
   cmp DI,[BP-06]
   jge L1e3e0ea4
   dec SI
L1e3e0efb:
   cmp SI,[BP-08]
   jge L1e3e0e9f
   mov AX,[offset _numobjs]
   dec AX
   mov [BP-0E],AX
jmp near L1e3e0f6d
L1e3e0f09:
   mov AX,[BP-0E]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+15],C000
   jz L1e3e0f6a
   xor AX,AX
   push AX
   push AX
   push [BP-0E]
   mov AX,[BP-0E]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
   mov AX,[offset _pagedraw]
   inc AX
   mov CL,0E
   shl AX,CL
   xor AX,FFFF
   push AX
   mov AX,[BP-0E]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   and [ES:BX+15],AX
L1e3e0f6a:
   dec word ptr [BP-0E]
L1e3e0f6d:
   cmp word ptr [BP-0E],+00
   jge L1e3e0f09
   call far _pageflip
jmp near L1e3e11f5
L1e3e0f7b:
   cmp word ptr [offset _statmodflg],+00
   jz L1e3e0f8d
   call far _drawstats
   mov word ptr [offset _statmodflg],0000
L1e3e0f8d:
   mov word ptr [BP-10],0000
jmp near L1e3e0fab
L1e3e0f94:
   mov AX,[BP-10]
   mov DX,0014
   mul DX
   mov BX,AX
   add BX,offset _updtab
   push DS
   pop ES
   mov byte ptr [ES:BX],FF
   inc word ptr [BP-10]
L1e3e0fab:
   cmp word ptr [BP-10],0080
   jl L1e3e0f94
   cmp word ptr [offset _scrollxd],+00
   jnz L1e3e0fc0
   cmp word ptr [offset _scrollyd],+00
   jz L1e3e0fce
L1e3e0fc0:
   push [offset _scrollyd]
   push [offset _scrollxd]
   push CS
   call near offset _junglescroll
   pop CX
   pop CX
L1e3e0fce:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnxs]
   dec AX
   cmp AX,007F
   jge L1e3e0ff3
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnxs]
   dec AX
jmp near L1e3e0ff6
L1e3e0ff3:
   mov AX,007F
L1e3e0ff6:
   mov [BP-0C],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnys]
   dec AX
   cmp AX,003F
   jge L1e3e101e
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnys]
   dec AX
jmp near L1e3e1021
L1e3e101e:
   mov AX,003F
L1e3e1021:
   mov [BP-0A],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1e3e1039
   xor AX,AX
jmp near L1e3e1048
L1e3e1039:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1e3e1048:
   mov [BP-08],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1e3e1060
   xor AX,AX
jmp near L1e3e106f
L1e3e1060:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1e3e106f:
   mov [BP-06],AX
   mov word ptr [BP-0E],0000
jmp near L1e3e1121
L1e3e107a:
   mov AX,[BP-0E]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+15],C000
   jnz L1e3e1095
jmp near L1e3e111e
L1e3e1095:
   mov AX,[BP-0E]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov SI,[ES:BX+01]
   mov CL,04
   sar SI,CL
   cmp SI,[BP-08]
   jge L1e3e10b5
   mov SI,[BP-08]
L1e3e10b5:
   mov word ptr [BP-10],0000
jmp near L1e3e10bf
L1e3e10bc:
   inc word ptr [BP-10]
L1e3e10bf:
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   add BX,offset _updtab
   push DS
   pop ES
   add BX,[BP-10]
   cmp byte ptr [ES:BX],FF
   jnz L1e3e10bc
   mov AL,[BP-0E]
   push AX
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   add BX,offset _updtab
   push DS
   pop ES
   add BX,[BP-10]
   pop AX
   mov [ES:BX],AL
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   add BX,offset _updtab
   push DS
   pop ES
   add BX,[BP-10]
   mov byte ptr [ES:BX+01],FF
   mov AX,[BP-0E]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   and word ptr [ES:BX+15],3FFF
L1e3e111e:
   inc word ptr [BP-0E]
L1e3e1121:
   mov AX,[BP-0E]
   cmp AX,[offset _numobjs]
   jge L1e3e112d
jmp near L1e3e107a
L1e3e112d:
   mov SI,[BP-0C]
jmp near L1e3e11ed
L1e3e1133:
   mov DI,[BP-0A]
jmp near L1e3e117d
L1e3e1138:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   test word ptr [ES:BX],8000
   jz L1e3e117c
   push DI
   push SI
   call far _drawcell
   pop CX
   pop CX
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   push AX
   push DI
   push SI
   push CS
   call near offset _setboard
   add SP,+06
L1e3e117c:
   dec DI
L1e3e117d:
   cmp DI,[BP-06]
   jge L1e3e1138
   mov word ptr [BP-10],0000
jmp near L1e3e11ce
L1e3e1189:
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   add BX,offset _updtab
   push DS
   pop ES
   add BX,[BP-10]
   mov AL,[ES:BX]
   mov AH,00
   mov [BP-0E],AX
   xor AX,AX
   push AX
   push AX
   push [BP-0E]
   mov AX,[BP-0E]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
   inc word ptr [BP-10]
L1e3e11ce:
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   add BX,offset _updtab
   push DS
   pop ES
   add BX,[BP-10]
   cmp byte ptr [ES:BX],FF
   jz L1e3e11ec
   cmp word ptr [BP-10],+14
   jl L1e3e1189
L1e3e11ec:
   dec SI
L1e3e11ed:
   cmp SI,[BP-08]
   jl L1e3e11f5
jmp near L1e3e1133
L1e3e11f5:
   cmp word ptr [offset _pl+2a],+00
   jz L1e3e1208
   mov word ptr [offset _pl+2a],0000
   or word ptr [offset _statmodflg],C000
L1e3e1208:
   sti
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_updbkgnd: ;; 1e3e120f
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,[BP-08]
   add AX,[offset _scrnxs]
   cmp AX,007F
   jge L1e3e1246
   mov AX,[BP-08]
   add AX,[offset _scrnxs]
jmp near L1e3e1249
L1e3e1246:
   mov AX,007F
L1e3e1249:
   mov [BP-04],AX
   mov AX,[BP-06]
   add AX,[offset _scrnys]
   cmp AX,003F
   jge L1e3e1261
   mov AX,[BP-06]
   add AX,[offset _scrnys]
jmp near L1e3e1264
L1e3e1261:
   mov AX,003F
L1e3e1264:
   mov [BP-02],AX
   mov SI,[BP-08]
jmp near L1e3e12eb
L1e3e126d:
   mov DI,[BP-06]
jmp near L1e3e12e5
L1e3e1272:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-0A],AX
   mov BX,AX
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   test word ptr [ES:BX+02],0020
   jz L1e3e12e4
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   push AX
   mov AX,0002
   push AX
   push DI
   push SI
   call far _msg_block
   add SP,+06
   or AX,AX
   jz L1e3e12d0
   mov AX,0001
jmp near L1e3e12d2
L1e3e12d0:
   xor AX,AX
L1e3e12d2:
   mov DX,C000
   mul DX
   pop DX
   or DX,AX
   push DX
   push DI
   push SI
   push CS
   call near offset _setboard
   add SP,+06
L1e3e12e4:
   inc DI
L1e3e12e5:
   cmp DI,[BP-02]
   jle L1e3e1272
   inc SI
L1e3e12eb:
   cmp SI,[BP-04]
   jg L1e3e12f3
jmp near L1e3e126d
L1e3e12f3:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_updobjs: ;; 1e3e12f9
   push BP
   mov BP,SP
   sub SP,+1A
   push SI
   push DI
   mov word ptr [offset _numscrnobjs],0001
   mov word ptr [offset _scrnobjs],0000
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   add AX,FFA0
   mov [BP-08],AX
   mov AX,[ES:BX+08]
   add AX,[ES:BX+04]
   add AX,0060
   mov [BP-06],AX
   mov AX,[ES:BX+0A]
   add AX,FFD0
   mov [BP-04],AX
   mov AX,[ES:BX+0A]
   add AX,[ES:BX+06]
   add AX,0030
   mov [BP-02],AX
   mov SI,0001
jmp near L1e3e1402
L1e3e1347:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   cmp AX,[BP-08]
   jge L1e3e1377
jmp near L1e3e1401
L1e3e1377:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,[BP-06]
   jg L1e3e1401
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   cmp AX,[BP-04]
   jl L1e3e1401
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP-02]
   jg L1e3e1401
   mov BX,[offset _numscrnobjs]
   shl BX,1
   mov [BX+offset _scrnobjs],SI
   inc word ptr [offset _numscrnobjs]
   mov AX,[offset _pagedraw]
   mov CL,0E
   shl AX,CL
   xor AX,FFFF
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   and [ES:BX+15],AX
L1e3e1401:
   inc SI
L1e3e1402:
   cmp SI,[offset _numobjs]
   jge L1e3e1413
   cmp word ptr [offset _numscrnobjs],00C0
   jge L1e3e1413
jmp near L1e3e1347
L1e3e1413:
   mov word ptr [offset _scrollxd],0000
   mov word ptr [offset _scrollyd],0000
   mov AX,[offset _objs+01]
   mov [offset _oldx0],AX
   mov AX,[offset _objs+03]
   mov [offset _oldy0],AX
   mov word ptr [BP-1A],0000
jmp near L1e3e1767
L1e3e1433:
   mov BX,[BP-1A]
   shl BX,1
   mov SI,[BX+offset _scrnobjs]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov [BP-14],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-12],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+09]
   mov [BP-10],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   mov [BP-0E],AX
   cmp word ptr [BP+06],+00
   jz L1e3e14ef
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jle L1e3e14c3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+1D]
L1e3e14c3:
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   push SI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
   or AX,AX
   jz L1e3e1504
L1e3e14ef:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1e3e1504:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],0008
   jnz L1e3e1526
jmp near L1e3e16c8
L1e3e1526:
   mov word ptr [BP-18],0000
jmp near L1e3e16bc
L1e3e152e:
   mov BX,[BP-18]
   shl BX,1
   mov DI,[BX+offset _scrnobjs]
   cmp DI,SI
   jnz L1e3e153e
jmp near L1e3e16b9
L1e3e153e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+01]
   jg L1e3e1580
jmp near L1e3e16b9
L1e3e1580:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+01]
   jg L1e3e15c2
jmp near L1e3e16b9
L1e3e15c2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+03]
   jg L1e3e1604
jmp near L1e3e16b9
L1e3e1604:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+03]
   jle L1e3e16b9
   push DI
   mov AX,0001
   push AX
   push SI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
   push SI
   mov AX,0001
   push AX
   push DI
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1e3e16b9:
   inc word ptr [BP-18]
L1e3e16bc:
   mov AX,[BP-18]
   cmp AX,[offset _numscrnobjs]
   jg L1e3e16c8
jmp near L1e3e152e
L1e3e16c8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+15],C000
   jnz L1e3e16e2
jmp near L1e3e1764
L1e3e16e2:
   mov AX,[BP-14]
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   mov AX,[BP-12]
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov AX,[BP-14]
   add AX,[BP-10]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,[BP-12]
   add AX,[BP-0E]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   mov AX,[BP-04]
   mov [BP-0A],AX
jmp near L1e3e175c
L1e3e171e:
   mov AX,[BP-08]
   mov [BP-0C],AX
jmp near L1e3e1751
L1e3e1726:
   mov BX,[BP-0C]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-0A]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   or AX,C000
   push AX
   push [BP-0A]
   push [BP-0C]
   push CS
   call near offset _setboard
   add SP,+06
   inc word ptr [BP-0C]
L1e3e1751:
   mov AX,[BP-0C]
   cmp AX,[BP-06]
   jl L1e3e1726
   inc word ptr [BP-0A]
L1e3e175c:
   mov AX,[BP-0A]
   cmp AX,[BP-02]
   jl L1e3e171e
L1e3e1764:
   inc word ptr [BP-1A]
L1e3e1767:
   mov AX,[BP-1A]
   cmp AX,[offset _numscrnobjs]
   jge L1e3e1773
jmp near L1e3e1433
L1e3e1773:
   mov word ptr [BP-1A],0000
jmp near L1e3e1878
L1e3e177b:
   mov BX,[BP-1A]
   shl BX,1
   mov SI,[BX+offset _scrnobjs]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov [BP-0C],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-0A],AX
   mov AX,[BP-0C]
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   mov AX,[BP-0A]
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,[BP-0C]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   add AX,[BP-0A]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   mov word ptr [BP-16],0000
   mov AX,[BP-04]
   mov [BP-0A],AX
jmp near L1e3e1852
L1e3e1811:
   mov AX,[BP-08]
   mov [BP-0C],AX
jmp near L1e3e1847
L1e3e1819:
   cmp word ptr [BP-16],+00
   jnz L1e3e183a
   mov BX,[BP-0C]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-0A]
   shl AX,1
   add BX,AX
   test word ptr [ES:BX],C000
   jz L1e3e183f
L1e3e183a:
   mov AX,0001
jmp near L1e3e1841
L1e3e183f:
   xor AX,AX
L1e3e1841:
   mov [BP-16],AX
   inc word ptr [BP-0C]
L1e3e1847:
   mov AX,[BP-0C]
   cmp AX,[BP-06]
   jl L1e3e1819
   inc word ptr [BP-0A]
L1e3e1852:
   mov AX,[BP-0A]
   cmp AX,[BP-02]
   jl L1e3e1811
   cmp word ptr [BP-16],+00
   jz L1e3e1875
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1e3e1875:
   inc word ptr [BP-1A]
L1e3e1878:
   mov AX,[BP-1A]
   cmp AX,[offset _numscrnobjs]
   jge L1e3e1884
jmp near L1e3e177b
L1e3e1884:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_killobj: ;; 1e3e188a
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov byte ptr [ES:BX],03
   pop BP
ret far

_addobj: ;; 1e3e18b9
   push BP
   mov BP,SP
   mov AL,[BP+06]
   push AX
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX],AL
   mov AX,[BP+08]
   push AX
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+01],AX
   mov AX,[BP+0A]
   push AX
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov BX,[BP+06]
   shl BX,1
   mov AX,[BX+offset _kindxl]
   push AX
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov BX,[BP+06]
   shl BX,1
   mov AX,[BX+offset _kindyl]
   push AX
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+15],0000
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+19],0000
   mov word ptr [ES:BX+17],0000
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1D],0000
   mov AX,[offset _numobjs]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   cmp word ptr [offset _numobjs],0100
   jge L1e3e1a32
   inc word ptr [offset _numobjs]
L1e3e1a32:
   mov AX,[offset _numobjs]
   dec AX
   pop BP
ret far

_addinv: ;; 1e3e1a38
   push BP
   mov BP,SP
   cmp word ptr [offset _pl+04],+0F
   jge L1e3e1a59
   or word ptr [offset _statmodflg],C000
   mov AX,[BP+06]
   mov BX,[offset _pl+04]
   shl BX,1
   mov [BX+offset _pl+06],AX
   inc word ptr [offset _pl+04]
L1e3e1a59:
   pop BP
ret far

_takeinv: ;; 1e3e1a5b
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
jmp near L1e3e1a9e
L1e3e1a64:
   mov BX,SI
   shl BX,1
   mov AX,[BX+offset _pl+06]
   cmp AX,[BP+06]
   jnz L1e3e1a9d
   mov DI,SI
   inc DI
jmp near L1e3e1a88
L1e3e1a76:
   mov BX,DI
   shl BX,1
   mov AX,[BX+offset _pl+06]
   mov BX,DI
   dec BX
   shl BX,1
   mov [BX+offset _pl+06],AX
   inc DI
L1e3e1a88:
   cmp DI,[offset _pl+04]
   jl L1e3e1a76
   dec word ptr [offset _pl+04]
   or word ptr [offset _statmodflg],C000
   mov AX,0001
jmp near L1e3e1aa6
L1e3e1a9d:
   inc SI
L1e3e1a9e:
   cmp SI,[offset _pl+04]
   jl L1e3e1a64
   xor AX,AX
L1e3e1aa6:
   pop DI
   pop SI
   pop BP
ret far

_invcount: ;; 1e3e1aaa
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   mov SI,DI
jmp near L1e3e1acc
L1e3e1ab5:
   mov BX,SI
   shl BX,1
   mov AX,[BX+offset _pl+06]
   cmp AX,[BP+06]
   jnz L1e3e1ac7
   mov AX,0001
jmp near L1e3e1ac9
L1e3e1ac7:
   xor AX,AX
L1e3e1ac9:
   add DI,AX
   inc SI
L1e3e1acc:
   cmp SI,[offset _pl+04]
   jl L1e3e1ab5
   mov AX,DI
   pop DI
   pop SI
   pop BP
ret far

_initinv: ;; 1e3e1ad8
   mov word ptr [offset _pl+02],0006
L1e3e1ade:
   xor AX,AX
   push AX
   push CS
   call near offset _takeinv
   pop CX
   or AX,AX
   jnz L1e3e1ade
ret far

_moveobj: ;; 1e3e1aeb
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   cmp word ptr [BP+0A],+00
   jge L1e3e1b03
   mov word ptr [BP+0A],0000
jmp near L1e3e1b3b
L1e3e1b03:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,03F0
   mov DX,[ES:BX+0B]
   sub AX,DX
   cmp AX,[BP+0A]
   jge L1e3e1b3b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,03F0
   mov DX,[ES:BX+0B]
   sub AX,DX
   mov [BP+0A],AX
L1e3e1b3b:
   or DI,DI
   jge L1e3e1b43
   xor DI,DI
jmp near L1e3e1b77
L1e3e1b43:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,07F0
   mov DX,[ES:BX+09]
   sub AX,DX
   cmp AX,DI
   jge L1e3e1b77
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,07F0
   mov AX,[ES:BX+09]
   sub DI,AX
L1e3e1b77:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov [ES:BX+01],DI
   mov AX,[BP+0A]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
   pop DI
   pop SI
   pop BP
ret far

_standfloor: ;; 1e3e1ba6
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov DI,[BP+06]
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,[BP+08]
   mov [BP-0A],AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov SI,[ES:BX+03]
   add SI,[BP+0A]
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   add AX,SI
   test AX,000F
   jz L1e3e1bfd
jmp near L1e3e1c83
L1e3e1bfd:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   add AX,SI
   dec AX
   mov BX,0010
   cwd
   idiv BX
   inc AX
   mov SI,AX
   mov AX,[BP-0A]
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,[BP-0A]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov AX,[BP-06]
   mov [BP-02],AX
jmp near L1e3e1c8a
L1e3e1c4e:
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov BX,[ES:BX]
   and BX,3FFF
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov AX,[ES:BX+02]
   and AX,0003
   mov [BP-08],AX
   cmp AX,0003
   jnz L1e3e1c87
L1e3e1c83:
   xor AX,AX
jmp near L1e3e1c95
L1e3e1c87:
   inc word ptr [BP-02]
L1e3e1c8a:
   mov AX,[BP-02]
   cmp AX,[BP-04]
   jl L1e3e1c4e
   mov AX,0001
L1e3e1c95:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_trymove: ;; 1e3e1c9b
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP+0A]
   jge L1e3e1cc2
   or DI,0002
L1e3e1cc2:
   push DI
   push [BP+0A]
   push [BP+08]
   push SI
   call far _cando
   add SP,+08
   cmp AX,DI
   jnz L1e3e1cea
   push [BP+0A]
   push [BP+08]
   push SI
   push CS
   call near offset _moveobj
   add SP,+06
   mov AX,0001
jmp near L1e3e1d7a
L1e3e1cea:
   push DI
   push [BP+0A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   cmp AX,DI
   jnz L1e3e1d31
   push [BP+0A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   push CS
   call near offset _moveobj
   add SP,+06
   mov AX,0002
jmp near L1e3e1d7a
L1e3e1d31:
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   push [BP+08]
   push SI
   call far _cando
   add SP,+08
   cmp AX,DI
   jnz L1e3e1d78
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+03]
   push [BP+08]
   push SI
   push CS
   call near offset _moveobj
   add SP,+06
   mov AX,0004
jmp near L1e3e1d7a
L1e3e1d78:
   xor AX,AX
L1e3e1d7a:
   pop DI
   pop SI
   pop BP
ret far

_justmove: ;; 1e3e1d7e
   push BP
   mov BP,SP
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far _cando
   mov SP,BP
   or AX,AX
   jz L1e3e1dad
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _moveobj
   mov SP,BP
   mov AX,0001
jmp near L1e3e1daf
L1e3e1dad:
   xor AX,AX
L1e3e1daf:
   pop BP
ret far

_onscreen: ;; 1e3e1db1
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   les BX,[offset _gamevp]
   cmp AX,[ES:BX+08]
   jge L1e3e1ded
jmp near L1e3e1e66
L1e3e1ded:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   les BX,[offset _gamevp]
   cmp AX,[ES:BX+0A]
   jl L1e3e1e66
   mov AX,[ES:BX+08]
   add AX,[ES:BX+04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+01]
   jl L1e3e1e66
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   add AX,[ES:BX+06]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+03]
   jl L1e3e1e66
   mov AX,0001
jmp near L1e3e1e68
L1e3e1e66:
   xor AX,AX
L1e3e1e68:
   pop SI
   pop BP
ret far

_trymovey: ;; 1e3e1e6b
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,0003
   push DI
   push [BP+0A]
   push [BP+08]
   push SI
   call far _cando
   add SP,+08
   cmp AX,DI
   jnz L1e3e1eb2
   push [BP+0A]
   push [BP+08]
   push SI
   push CS
   call near offset _moveobj
   add SP,+06
   mov AX,[offset _dx1]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L1e3e1f09
L1e3e1eb2:
   push DI
   push [BP+0A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far _cando
   add SP,+08
   cmp AX,DI
   jnz L1e3e1f0e
   push [BP+0A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   push CS
   call near offset _moveobj
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
L1e3e1f09:
   mov AX,0001
jmp near L1e3e1f25
L1e3e1f0e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   xor AX,AX
L1e3e1f25:
   pop DI
   pop SI
   pop BP
ret far

_crawl: ;; 1e3e1f29
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+01]
   add DI,[BP+08]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,[BP+0A]
   mov [BP-02],AX
   push [BP+0A]
   push [BP+08]
   push SI
   push CS
   call near offset _standfloor
   add SP,+06
   or AX,AX
   jz L1e3e1f9c
   mov AX,0001
   push AX
   push [BP-02]
   push DI
   push SI
   call far _cando
   add SP,+08
   cmp AX,0001
   jnz L1e3e1f9c
   push [BP-02]
   push DI
   push SI
   push CS
   call near offset _moveobj
   add SP,+06
   mov AX,0001
jmp near L1e3e1f9e
L1e3e1f9c:
   xor AX,AX
L1e3e1f9e:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_addscore: ;; 1e3e1fa4
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   push [BP+0A]
   push DI
   mov AX,001B
   push AX
   push CS
   call near offset _addobj
   add SP,+06
   mov SI,AX
   or SI,SI
   jnz L1e3e1fc4
jmp near L1e3e2041
L1e3e1fc4:
   mov AX,[BP+06]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0010
   cmp DI,[offset _objs+01]
   jle L1e3e1ffc
   mov AX,0001
jmp near L1e3e1ffe
L1e3e1ffc:
   xor AX,AX
L1e3e1ffe:
   push AX
   cmp DI,[offset _objs+01]
   jge L1e3e200a
   mov AX,0001
jmp near L1e3e200c
L1e3e200a:
   xor AX,AX
L1e3e200c:
   pop DX
   sub DX,AX
   shl DX,1
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0003
   push SI
   push CS
   call near offset _setobjsize
   pop CX
L1e3e2041:
   or word ptr [offset _statmodflg],C000
   mov AX,[BP+06]
   cwd
   add [offset _pl+26],AX
   adc [offset _pl+26+02],DX
X1e3e2052:
   test BL,[BX+5E]
   pop BP
ret far
_addtext: ;; 1e3e2057 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push SI
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push CS
   call near offset _addobj
   add SP,+06
   mov SI,AX
   or SI,SI
   jz L1e3e20de
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0040
   push [BP+08]
   push [BP+06]
   call far _strdup
   pop CX
   pop CX
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   pop DX
   mov [ES:BX+19],DX
   mov [ES:BX+17],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFF
   push SI
   push CS
   call near offset _setobjsize
   pop CX
L1e3e20de:
   pop SI
   pop BP
ret far

_sendtrig: ;; 1e3e20e1
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L1e3e2148
L1e3e20e9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+offset _kindflags],0100
   jz L1e3e2147
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[BP+06]
   jnz L1e3e2147
   push [BP+0A]
   push [BP+08]
   push SI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
L1e3e2147:
   inc SI
L1e3e2148:
   cmp SI,[offset _numobjs]
   jl L1e3e20e9
   pop SI
   pop BP
ret far

_setorigin: ;; 1e3e2151
   mov AX,[offset _scrnxs]
   shl AX,1
   shl AX,1
   shl AX,1
   mov DX,[offset _objs+01]
   sub DX,AX
   and DX,FFF8
   les BX,[offset _gamevp]
   mov [ES:BX+08],DX
   cmp word ptr [ES:BX+08],+00
   jge L1e3e217b
   mov word ptr [ES:BX+08],0000
jmp near L1e3e21a1
L1e3e217b:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov DX,0080
   sub DX,[offset _scrnxs]
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jle L1e3e21a1
   mov AX,0080
   sub AX,[offset _scrnxs]
   mov CL,04
   shl AX,CL
   mov [ES:BX+08],AX
L1e3e21a1:
   mov AX,[offset _scrnys]
   shl AX,1
   shl AX,1
   shl AX,1
   mov DX,[offset _objs+03]
   add DX,+10
   sub DX,AX
   les BX,[offset _gamevp]
   mov [ES:BX+0A],DX
   cmp word ptr [ES:BX+0A],+00
   jge L1e3e21ca
   mov word ptr [ES:BX+0A],0000
jmp near L1e3e21f0
L1e3e21ca:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov DX,0041
   sub DX,[offset _scrnys]
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jle L1e3e21f0
   mov AX,0041
   sub AX,[offset _scrnys]
   mov CL,04
   shl AX,CL
   mov [ES:BX+0A],AX
L1e3e21f0:
   mov word ptr [offset _oldscrollxd],0000
   mov word ptr [offset _oldscrollyd],0000
ret far

_cando: ;; 1e3e21fd
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   push DI
   mov AX,[BP+08]
   mov CL,04
   sar AX,CL
   mov [BP-0A],AX
   mov AX,[BP+0A]
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,[BP+08]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   add AX,[BP+0A]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   pop AX
   add AX,[BX+offset _kindyl]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov word ptr [BP-0E],0002
   mov word ptr [BP-0C],FFFF
   mov SI,[BP-06]
jmp near L1e3e22f1
L1e3e22a6:
   cmp SI,[BP-04]
   jl L1e3e22b0
   mov word ptr [BP-0E],0000
L1e3e22b0:
   mov DI,[BP-0A]
jmp near L1e3e22eb
L1e3e22b5:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov BX,[ES:BX]
   and BX,3FFF
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov AX,[ES:BX+02]
   or AX,[BP-0E]
   and AX,[BP+0C]
   mov [BP-10],AX
   and [BP-0C],AX
   inc DI
L1e3e22eb:
   cmp DI,[BP-08]
   jl L1e3e22b5
   inc SI
L1e3e22f1:
   cmp SI,[BP-02]
   jl L1e3e22a6
   mov AX,[BP-0C]
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_objdo: ;; 1e3e22ff
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov word ptr [BP-0A],FFFF
   mov AX,[BP+08]
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   mov AX,[BP+0A]
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,[BP+08]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   add AX,[BP+0A]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   mov DI,[BP-04]
jmp near L1e3e23a2
L1e3e2367:
   mov SI,[BP-08]
jmp near L1e3e239c
L1e3e236c:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov BX,[ES:BX]
   and BX,3FFF
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov AX,[ES:BX+02]
   and AX,[BP+0C]
   and [BP-0A],AX
   inc SI
L1e3e239c:
   cmp SI,[BP-06]
   jl L1e3e236c
   inc DI
L1e3e23a2:
   cmp DI,[BP-02]
   jl L1e3e2367
   mov AX,[BP-0A]
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_touchbkgnd: ;; 1e3e23b0
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov BX,[ES:BX+0D]
   shl BX,1
   test word ptr [BX+offset _stateinfo],0002
   jz L1e3e23db
jmp near L1e3e24cf
L1e3e23db:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   mov AX,[BP-04]
   mov [BP-0A],AX
jmp near L1e3e24c7
L1e3e247b:
   mov DI,[BP-08]
jmp near L1e3e24bf
L1e3e2480:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-0A]
   shl AX,1
   add BX,AX
   mov BX,[ES:BX]
   and BX,3FFF
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   test word ptr [ES:BX+02],0008
   jz L1e3e24be
   mov AX,0001
   push AX
   push [BP-0A]
   push DI
   call far _msg_block
   add SP,+06
L1e3e24be:
   inc DI
L1e3e24bf:
   cmp DI,[BP-06]
   jl L1e3e2480
   inc word ptr [BP-0A]
L1e3e24c7:
   mov AX,[BP-0A]
   cmp AX,[BP-02]
   jl L1e3e247b
L1e3e24cf:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_purgeobjs: ;; 1e3e24d5
   push SI
   push DI
   xor DI,DI
   mov SI,DI
jmp near L1e3e2556
L1e3e24de:
   cmp SI,DI
   jz L1e3e2506
   mov AX,001F
   push AX
   push DS
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,offset _objs
   push AX
   push DS
   mov AX,DI
   mov DX,001F
   mul DX
   add AX,offset _objs
   push AX
   call far _memcpy
   add SP,+0A
L1e3e2506:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],03
   jnz L1e3e2554
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1e3e2555
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far _free
   pop CX
   pop CX
jmp near L1e3e2555
L1e3e2554:
   inc DI
L1e3e2555:
   inc SI
L1e3e2556:
   cmp SI,[offset _numobjs]
   jge L1e3e255f
jmp near L1e3e24de
L1e3e255f:
   mov [offset _numobjs],DI
   pop DI
   pop SI
ret far

_updbotmsg: ;; 1e3e2566
   cmp byte ptr [offset _botmsg],00
   jz L1e3e257e
   dec word ptr [offset _bottime]
   jge L1e3e257e
   mov byte ptr [offset _botmsg],00
   or word ptr [offset _statmodflg],C000
L1e3e257e:
ret far

_hitplayer: ;; 1e3e257f
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jnz L1e3e25b4
   mov BX,[offset _objs+0d]
   shl BX,1
   test word ptr [BX+offset _stateinfo],0002
   jnz L1e3e25b4
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   push CS
   call near offset _p_ouch
   mov SP,BP
L1e3e25b4:
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1D],0003
   pop BP
ret far

_fishdo: ;; 1e3e25cc
   push BP
   mov BP,SP
   mov AX,2001
   push AX
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _objdo
   mov SP,BP
   cmp AX,2001
   jnz L1e3e25fb
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _moveobj
   mov SP,BP
   mov AX,0001
jmp near L1e3e25fd
L1e3e25fb:
   xor AX,AX
L1e3e25fd:
   pop BP
ret far

_pointvect: ;; 1e3e25ff
   push BP
   mov BP,SP
   push SI
   push DI
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,[BP+08]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   sub DI,[ES:BX+01]
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov SI,[ES:BX+03]
   mov AX,[BP+08]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   sub SI,[ES:BX+03]
   or DI,DI
   jnz L1e3e2661
   or SI,SI
   jnz L1e3e265f
jmp near L1e3e26e4
L1e3e265f:
jmp near L1e3e26c3
L1e3e2661:
   or SI,SI
   jz L1e3e268c
   mov AX,DI
   cwd
   xor AX,DX
   sub AX,DX
   mov DX,SI
   or DX,DX
   jge L1e3e2674
   neg DX
L1e3e2674:
   cmp AX,DX
   jle L1e3e26af
   mov AX,SI
   mul word ptr [BP+12]
   mov DX,DI
   or DX,DX
   jge L1e3e2685
   neg DX
L1e3e2685:
   mov BX,DX
   cwd
   idiv BX
   mov SI,AX
L1e3e268c:
   or DI,DI
   jle L1e3e2695
   mov AX,0001
jmp near L1e3e2697
L1e3e2695:
   xor AX,AX
L1e3e2697:
   push AX
   or DI,DI
   jge L1e3e26a1
   mov AX,0001
jmp near L1e3e26a3
L1e3e26a1:
   xor AX,AX
L1e3e26a3:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov DI,AX
jmp near L1e3e26e4
L1e3e26af:
   mov AX,DI
   mul word ptr [BP+12]
   mov DX,SI
   or DX,DX
   jge L1e3e26bc
   neg DX
L1e3e26bc:
   mov BX,DX
   cwd
   idiv BX
   mov DI,AX
L1e3e26c3:
   or SI,SI
   jle L1e3e26cc
   mov AX,0001
jmp near L1e3e26ce
L1e3e26cc:
   xor AX,AX
L1e3e26ce:
   push AX
   or SI,SI
   jge L1e3e26d8
   mov AX,0001
jmp near L1e3e26da
L1e3e26d8:
   xor AX,AX
L1e3e26da:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov SI,AX
L1e3e26e4:
   les BX,[BP+0A]
   mov [ES:BX],DI
   les BX,[BP+0E]
   mov [ES:BX],SI
   pop DI
   pop SI
   pop BP
ret far

_vectdist: ;; 1e3e26f4
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,[BP+08]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+01]
   cwd
   xor AX,DX
   sub AX,DX
   push AX
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,[BP+08]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+03]
   cwd
   xor AX,DX
   sub AX,DX
   mov DX,AX
   pop AX
   add AX,DX
   pop BP
ret far

_trybreakwall: ;; 1e3e275d
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov word ptr [BP-02],0000
   mov AX,[BP+08]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
jmp near L1e3e2807
L1e3e2778:
   mov AX,[BP+0A]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
jmp near L1e3e27e2
L1e3e2785:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,00A7
   jnz L1e3e27e1
   xor AX,AX
   push AX
   push DI
   push SI
   push CS
   call near offset _setboard
   add SP,+06
   mov AX,[BP-02]
   inc word ptr [BP-02]
   or AX,AX
   jnz L1e3e27e1
   mov AX,0005
   push AX
   mov AX,DI
   mov CL,04
   shl AX,CL
   push AX
   mov AX,SI
   mov CL,04
   shl AX,CL
   push AX
   call far _explode1
   add SP,+06
   mov AX,0031
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L1e3e27e1:
   inc DI
L1e3e27e2:
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   add AX,[BP+0A]
   mov BX,0010
   cwd
   idiv BX
   cmp AX,DI
   jl L1e3e2806
jmp near L1e3e2785
L1e3e2806:
   inc SI
L1e3e2807:
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,[BP+08]
   mov BX,0010
   cwd
   idiv BX
   cmp AX,SI
   jl L1e3e282b
jmp near L1e3e2778
L1e3e282b:
   mov AX,[BP-02]
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

;; === External Library Modules ===
Segment 20c1 ;; WRX_CORE
;; (@) Unnamed near calls: B20c14d45 B20c15477 B20c15573 B20c15596 B20c15681 B20c156ea B20c157ae
;; (@) Unnamed near calls: B20c158b4 B20c15a12 B20c15b26 B20c15b85 B20c1614b B20c1623f B20c162c2
;; (@) Unnamed near calls: B20c164a6 B20c16700 B20c16725 B20c168e7 B20c1695d
Y20c10004:	byte	;; ExtendedWx
Y20c10005:	db "XXXXXXXXXXXXXXXXXXXXXX"	;; VidBuf
Y20c1001b:	word	;; JoyPixX
Y20c1001d:	word	;; JoyPixY
Y20c1001f:	ds 0004	;; JoyButton
Y20c10023:	word	;; JoyPixDx
Y20c10025:	word	;; JoyPixDy
Y20c10027:	db 01,11,4f,00,f1,f2,53,74,00,00
Y20c10031:	db 08,00,08,02,08,04,08,0b,08,0d,08,0f,08,16,08,18,08,1a
Y20c10043:	dw 0000,0000,0000,0000,0000,0000,0000,0000,0000,a675,a0b8,9659,8d3c,852a,7df8,7782
		dw 71ad,69ed,6552,5f1e,59a1,54be,505c,4b2c,47b4,438c,3fd8,3bc1,38d6,3592,32a9,2f8f
		dw 2cd0,2a5f,27d6,25e4,2394,2188,1fb4,1de0,1c3f,1aa2,1931,17c7,1668,152f,1400,12de
		dw 11ca,10d3,0fda,0efc,0e1f,0d5a,0c98,0be3,0b3b,0a97,0a00,096f,08e9,0869,07f0,077e
		dw 0712,06ad,064c,05f1,059b,054b,0500,04b7,0473,0433,03f7,03be,0388,0356,0326,02f8
		dw 02ce,02a5,027f,025b,023a,021a,01fb,01df,01c4,01ab,0193,017c,0167,0152,013f,012d
		dw 011d,010d,00fd,00ef,00e2,00d5,00c9,00be,00b3,00a9,009f,0096,008e,0086,007e,0077
		dw 0071,006a,0064,005f,0059,0054,004f,004b,0047,0043,003f,003b,0038,0035,0032,002f
Y20c10143:	;; struct {
		;;    word AmVibrato, Level, AttackDecay, SustainRelease, Waveform;
		;;    byte FeedbackAlgorithm;
		;; } SbiTab[0x80];
		db 01,01, 4f,12, f1,d3, 50,7c, 00,00, 06
		db 02,01, 50,12, f1,d2, 50,76, 00,00, 06
		db 01,01, 4b,17, f1,d2, 50,76, 00,00, 06
		db 13,01, 50,11, f1,d2, 50,76, 00,00, 06
		db 32,01, 92,8f, ff,ff, 11,13, 00,00, 0a
		db 34,03, 92,0f, ff,ff, 10,04, 00,00, 0a
		db 34,03, 92,14, ff,ff, 10,04, 00,00, 0a
		db 53,51, 4e,00, f1,d2, 00,86, 00,00, 06
		db 28,21, cf,0d, f8,c0, e5,ff, 00,00, 00
		db e2,e1, ca,15, f8,c0, e5,0e, 00,00, 08
		db 2c,a1, d4,1c, f9,c0, ff,ff, 00,00, 00
		db 2b,21, ca,13, f8,c0, e5,ff, 00,00, 00
		db 29,21, cd,14, f0,e0, 91,86, 00,00, 02
		db 24,21, d0,14, f0,e0, 01,86, 00,00, 02
		db 23,21, c8,10, f0,e0, 01,86, 00,00, 02
		db 64,61, c9,14, b0,f0, 01,86, 00,00, 02
		db 33,15, 85,94, a1,72, 10,23, 00,00, 08
		db 31,15, 85,94, a1,73, 10,33, 00,00, 08
		db 31,16, 81,94, a1,c2, 30,74, 00,00, 08
		db 03,02, 8a,94, f0,f4, 7b,7b, 00,00, 08
		db 03,01, 8a,99, f0,f4, 7b,7b, 00,00, 08
		db 23,01, 8a,94, f2,f4, 7b,7b, 00,00, 08
		db 32,12, 80,95, 01,72, 10,33, 00,00, 08
		db 32,14, 80,90, 01,73, 10,33, 00,00, 08
		db 31,21, 16,14, 73,80, 8e,9e, 00,00, 0e
		db 30,21, 16,10, 73,80, 7e,9e, 00,00, 0e
		db 31,21, 94,15, 33,a0, 73,97, 00,00, 0e
		db 31,21, 94,13, d3,a0, 73,97, 00,00, 0e
		db 31,32, 45,11, f1,f2, 53,27, 00,00, 06
		db 13,15, 0c,1a, f2,f2, 01,b6, 00,00, 08
		db 11,11, 0c,15, f2,f2, 01,b6, 00,00, 08
		db 11,11, 0a,10, fe,f2, 04,bd, 00,00, 08
		db 16,e1, 4d,11, fa,f1, 11,f1, 00,00, 08
		db 16,f1, 40,17, ba,24, 11,31, 00,00, 08
		db 61,e1, a7,8e, 72,50, 8e,1a, 00,00, 02
		db 18,e1, 4d,13, 32,51, 13,e3, 00,00, 08
		db 17,31, c0,92, 12,13, 41,31, 00,00, 06
		db 03,21, 8f,90, f5,f3, 55,33, 00,00, 00
		db 13,e1, 4d,12, fa,f1, 11,f1, 00,00, 08
		db 11,f1, 43,10, 20,31, 15,f8, 00,00, 08
		db 11,e4, 03,52, 82,f0, 97,f2, 00,00, 08
		db 05,14, 40,0f, d1,51, 53,71, 00,00, 06
		db f1,21, 01,12, 77,81, 17,18, 00,00, 02
		db f1,e1, 18,17, 32,f1, 11,13, 00,00, 00
		db 73,71, 48,13, f1,f1, 53,06, 00,00, 08
		db 71,61, 8d,53, 71,72, 11,15, 00,00, 06
		db d7,d2, 4f,14, f2,f1, 61,b2, 00,00, 08
		db 01,01, 11,13, f0,f0, ff,f8, 00,00, 0a
		db 31,61, 8b,10, 41,22, 11,13, 00,00, 06
		db 31,61, 8b,10, ff,44, 21,15, 00,00, 0a
		db 31,61, 8b,10, 41,32, 11,15, 00,00, 02
		db 71,21, 1c,10, fd,e7, 13,d6, 00,00, 0e
		db 71,21, 1c,10, 51,54, 03,67, 00,00, 0e
		db 71,21, 1c,10, 51,54, 03,17, 00,00, 0e
		db 71,21, 1c,10, 54,53, 15,49, 00,00, 0e
		db 71,61, 56,10, 51,54, 03,17, 00,00, 0e
		db 71,21, 1c,10, 51,54, 03,17, 00,00, 0e
		db 02,01, 29,90, f5,f2, 75,f3, 00,00, 00
		db 02,01, 29,90, f0,f4, 75,33, 00,00, 00
		db 01,11, 49,10, f1,f1, 53,74, 00,00, 06
		db 01,11, 89,10, f1,f1, 53,74, 00,00, 06
		db 02,11, 89,10, f1,f1, 53,74, 00,00, 06
		db 02,11, 80,10, f1,f1, 53,74, 00,00, 06
		db 01,08, 40,50, f1,f1, 53,53, 00,00, 00
		db 21,21, 15,90, d3,c3, 2c,2c, 00,00, 0a
		db 01,21, 18,90, d4,c4, f2,8a, 00,00, 0a
		db 01,11, 4e,10, f0,f4, 7b,c8, 00,00, 04
		db 01,11, 44,10, f0,f3, ab,ab, 00,00, 04
		db 53,11, 0e,10, f4,f1, c8,bb, 00,00, 04
		db 53,11, 0b,10, f2,f2, c8,c5, 00,00, 04
		db 21,21, 15,10, b4,94, 4c,ac, 00,00, 0a
		db 21,21, 15,10, 94,64, 1c,ac, 00,00, 0a
		db 21,a1, 16,90, 77,60, 8f,2a, 00,00, 06
		db 21,a1, 19,90, 77,60, bf,2a, 00,00, 06
		db a1,e2, 13,90, d6,60, af,2a, 00,00, 02
		db a2,e2, 1d,90, 95,60, 24,2a, 00,00, 02
		db 32,61, 9a,90, 51,60, 19,39, 00,00, 0c
		db a4,e2, 12,90, f4,60, 30,2a, 00,00, 02
		db 21,21, 16,10, 63,63, 0e,0e, 00,00, 0c
		db 31,21, 16,10, 63,63, 0a,0b, 00,00, 0c
		db 21,21, 1b,10, 63,63, 0a,0b, 00,00, 0c
		db 20,21, 1b,10, 63,63, 0a,0b, 00,00, 0c
		db 32,61, 1c,90, 82,60, 18,07, 00,00, 0c
		db 32,e1, 18,90, 51,62, 14,36, 00,00, 0c
		db 31,22, c3,10, 87,8b, 17,0e, 00,00, 02
		db 71,22, c3,14, 8e,8b, 17,0e, 00,00, 02
		db 70,22, 8d,10, 6e,6b, 17,0e, 00,00, 02
		db 24,31, 4f,10, f2,52, 06,06, 00,00, 0e
		db 31,61, 1b,10, 64,d0, 07,67, 00,00, 0e
		db 31,61, 1b,10, 61,d2, 06,36, 00,00, 0c
		db 31,61, 1f,10, 31,50, 06,36, 00,00, 0c
		db 31,61, 1f,10, 41,a0, 06,36, 00,00, 0c
		db 21,21, 9a,90, 53,a0, 56,16, 00,00, 0e
		db 21,21, 9a,90, 53,a0, 56,16, 00,00, 0e
		db 61,21, 19,10, 53,a0, 58,18, 00,00, 0c
		db 61,21, 19,10, 73,a0, 57,17, 00,00, 0c
		db 21,21, 1b,10, 71,a1, a6,96, 00,00, 0e
		db 85,a1, 91,10, f5,f0, 44,45, 00,00, 06
		db 07,61, 51,10, f5,f0, 33,25, 00,00, 06
		db 13,11, 8c,90, ff,ff, 21,03, 00,00, 0e
		db 38,b1, 8c,50, f3,f5, 0d,33, 00,00, 0e
		db 87,22, 91,10, f5,f0, 55,54, 00,00, 06
		db b3,90, 4a,10, b6,d1, 32,31, 00,00, 0e
		db 04,c2, 00,10, fe,f6, f0,b5, 00,00, 0e
		db 05,01, 4e,90, da,f0, 15,13, 00,00, 0a
		db 31,32, 44,10, f2,f0, 9a,27, 00,00, 06
		db b0,d7, c4,90, a4,40, 02,42, 00,00, 00
		db ca,cc, 84,10, f0,59, f0,62, 00,00, 0c
		db 30,35, 35,10, f5,f0, f0,9b, 00,00, 02
		db b4,d7, 87,90, a4,40, 02,42, 00,00, 06
		db 07,05, 40,00, 09,f6, 53,96, 00,00, 0e
		db 09,01, 4e,10, da,f1, 25,15, 00,00, 0a
		db 06,00, 09,10, f4,f6, a0,46, 00,00, 0e
		db 07,00, 00,10, f0,5c, f0,dc, 00,00, 0e
		db 1c,0c, 1e,10, e5,5d, 5b,fa, 00,00, 0e
		db 11,01, 8a,50, f1,f1, 11,b3, 00,00, 06
		db 00,00, 40,10, d1,f2, 53,56, 00,00, 0e
		db 32,11, 44,10, f8,f5, ff,7f, 00,00, 0e
		db 00,02, 40,10, 09,f7, 53,94, 00,00, 0e
		db 11,01, 86,90, f2,a0, a8,a8, 00,00, 08
		db 00,13, 50,10, f2,f2, 70,72, 00,00, 0e
		db f0,e0, 00,d0, 11,11, 11,11, 00,00, 0e
		db 07,12, 4f,10, f2,f2, 60,72, 00,00, 08
		db 00,00, 0b,10, a8,d6, 4c,4f, 00,00, 00
		db 00,00, 0d,10, e8,a5, ef,ff, 00,00, 06
		db 31,16, 87,90, a1,7d, 11,46, 00,00, 08
		db 30,10, 90,10, f4,f4, 49,33, 00,00, 0c
		db 24,31, 54,10, 55,50, fd,2d, 00,00, 0e
Y20c106c3:	db 10,10,01,08,01,08,10,01,10,01,04,01,04,04,02,04
		db 02,01,01,04,04,01,04,04,04,04,04,04,01,01,01,01,04,04
Y20c106e5:	db e0,bd,00,08,38,a6,09,b6,0b,50,00,c6,a8,70,4c,90
		db 00,30,00,f0,04,53,d6,73,4f,93,00,33,00,f3,e0,bd
		db 00,08,e0,bd,00,08,03,a7,0a,b7,0d,51,01,c7,f9,71
		db 8c,91,01,31,00,f1,e0,bd,00,08,e0,bd,00,08,57,a8
		db 09,b8,00,52,01,c8,f7,72,b5,92,04,32,00,f2,e0,bd
		db 00,08,e0,bd,00,08,07,54,f7,74,bf,94,0c,34,00,f4
		db e0,bd,00,08,e0,bd,00,08,0d,55,f5,75,a5,95,01,35
		db 00,f5,e0,bd,00,08,ff,ff
Y20c1075d:	byte
Y20c1075e:	dw 016b,0181,0198,01b0,01ca,01e5,0202,0220,0241,0263,0287,02ae
Y20c10776:	db 00,01,02,08,09,0a,10,11,12
Y20c1077f:	db 03,04,05,0b,0c,0d,13,14,15
Y20c10788:	db 16,16,16,16,16,16,16,16,16,16,16,16,16
Y20c10795:	ds 0010
Y20c107a5:	ds 2*0009	;; ResetWx
Y20c107b7:	ds 0010	;; ModeWx
Y20c107c7:	db 7f,7f,7f,7f,7f,7f,7f,7f,7f,7f,7f,7f,7f,7f,7f,7f	;; ConfigPortWx
Y20c107d7:	ds 0009	;; SoundOnWx
Y20c107e0:	ds 0009	;; LevelWx
Y20c107e9:	db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"	;; WxXs
Y20c1081c:	byte	;; StrCheckWx
;; WORX toolkit for driver-free sound interfaces with CMF files and other early 1990's standard formats.
;; PC Magazine, 1993-06-15, p. 57
;; https://books.google.com/books?id=jMKfH6i9OcYC&lpg=PA77&ots=nd-NZ5yIxK&pg=PA77#v=onepage&q&f=false
;; The library functions are in assembly and called from through the 80x86 interrupt 0x63. 
;; Example: DSPReset call interrupt 0x63 with AX = 0x01, BX = 0, ES = 0, DI = 0.
;; The function table is set up from _CORE_STARTWORX (with AX ranging from 0x01 to 0x3b).
;; Interrupt 0x63 with AX = 0x01 calls the internal assembly language routine for DSPReset.
Y20c1081d:	db "WORX TOOLKIT VERSION 2.01(F)COPYRIGHT 1993 BY MYSTIC SOFTWARE"
Y20c1085a:	word	;; ErrorWx
Y20c1085c:	dw ffff	;; TimeDeltaWx
Y20c1085e:	dword	;; TimeLeftWx
Y20c10862:	dword	;; TimeSetWx
Y20c10866:	byte	;; TimedOutWx
Y20c10867:	word	;; PhaseWx
Y20c10869:	word	;; MidiBeatWx
Y20c1086b:	word	;; WxItems
Y20c1086d:	word	;; FrequencyWx
Y20c1086f:	byte	;; DoCmWx
Y20c10870:	word	;; SegWx
Y20c10872:	word	;; OffWx
Y20c10874:	db 01	;; DoLoopWx
Y20c10875:	ds 2*0020	;; WxBlock
Y20c108b5:	ds 0080	;;
Y20c10935:	ds 2*0020	;;
Y20c10975:	byte	;; MidiPlaying
Y20c10976:	ds 2*0010	;;
Y20c10996:	db f4	;;
Y20c10997:	db 02,02,02,02,01,01,02,00
Y20c1099f:	word
Y20c109a1:	word
Y20c109a3:	dword	;; ExInt00
Y20c109a7:	byte
Y20c109a8:	db 01	;; AudioMode
Y20c109a9:	byte	;; MidiSpeaker
Y20c109aa:	word
Y20c109ac:	word
Y20c109ae:	word
Y20c109b0:	byte
Y20c109b1:	byte
Y20c109b2:	byte
Y20c109b3:	byte
Y20c109b4:	byte
Y20c109b5:	byte
Y20c109b6:	byte
Y20c109b7:	dword	;; ExInt07
Y20c109bb:	word
Y20c109bd:	word
Y20c109bf:	ds 2*0010	;; WorxTab2
Y20c109df:	byte
Y20c109e0:	db 14,75,77,17
Y20c109e4:	db 14,74,76,16
Y20c109e8:	word
Y20c109ea:	db 7f
Y20c109eb:	word
Y20c109ed:	byte
Y20c109ee:	word
Y20c109f0:	word
Y20c109f2:	byte
Y20c109f3:	db 64
Y20c109f4:	word
Y20c109f6:	word
Y20c109f8:	byte
Y20c109f9:	byte
Y20c109fa:	word
Y20c109fc:	byte
Y20c109fd:	word
Y20c109ff:	word
Y20c10a01:	db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
		db 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80
Y20c14a01:	dw ffff	;; WxVocIx
Y20c14a03:	db "Creative Voice File",1a,1a,00,0a,01,29,11,01,0a,00,00,a0,00,80,80,80,80,80,80,80,80,00	;; WxVocStr
Y20c14a2c:	byte	;; WxIntNum
Y20c14a2d:	db 0a,07,05,03,02,ff,14,75,77,17,14,74,76,16	;; WxIntTab
Y20c14a3b:	byte	;; WxMode
Y20c14a3c:	dword	;; WxIntVec
Y20c14a40:	dw 0210	;; OutPortWx
Y20c14a42:	byte	;; SoundingWx
Y20c14a43:	dw ffff	;; WorxFD
Y20c14a45:	word	;; ResourceWx
Y20c14a47:	;; WorxBuf
		dword	;; 00
		ds 0004	;; 04
		dword	;; 08
		ds 000d	;; 0c
Y20c14a60:	byte	;; WorxFileOpen
Y20c14a61:	dword	;; WxExInt63
Y20c14a65:	ds 2*0046	;; WorxTab

B20c14af1: ;; CvtStringWx
   push AX
   push BX
   xor BX,BX
L20c14af5:
   cmp byte ptr [ES:BX+DI],00
   jz L20c14afe
   inc BX
jmp near L20c14af5
L20c14afe:
   cmp BX,+00
   jz L20c14b1a
   mov AH,[ES:DI]
   mov [ES:DI],BL
L20c14b09:
   mov AL,[ES:BX+DI]
   mov [ES:BX+DI+01],AL
   dec BX
   cmp BX,+00
   ja L20c14b09
   mov [ES:DI+01],AH
L20c14b1a:
   pop BX
   pop AX
ret near

B20c14b1d: ;; LoadWxXs
   push CX
   push DS
   push SI
   mov CL,[ES:DI]
   xor CH,CH
   mov SI,DI
   mov DI,offset Y20c107e9
   push DS
   push ES
   pop DS
   pop ES
   inc SI
   cld
   repz movsb
   xor CL,CL
   mov [ES:DI],CL
   pop SI
   pop DS
   pop CX
   mov DI,offset Y20c107e9
ret near

B20c14b3e: ;; Worx26
   mov byte ptr [CS:offset Y20c1081c],01
ret near

_CORE_STARTWORX: ;; 20c14b45
   cli
   push AX
   push BX
   push DI
   push SI
   push DS
   push ES
   mov BX,CS
   mov DS,BX
   mov byte ptr [CS:offset Y20c1081c],00
   cld
   call near B20c15c2e
   mov AL,63
   call near B20c161fc
   mov [CS:offset Y20c14a61],DI
   mov AX,ES
   mov [CS:offset Y20c14a61+02],AX
   mov DI,offset B20c150f3
   mov AX,CS
   mov ES,AX
   mov AL,63
   call near B20c161e3
   mov DI,offset Y20c14a65
   mov AX,DS
   mov ES,AX
   mov AX,0000
   stosw ;; Worx00
   mov AX,offset B20c16324
   stosw ;; Worx01: DSPResetWx
   mov AX,offset B20c1649a
   stosw ;; Worx02: ForceConfigWx
   mov AX,offset B20c15082
   stosw ;; Worx03: GetErrorWx
   mov AX,offset B20c1646a
   stosw ;; Worx04: DSPCloseWx
   mov AX,offset B20c165fb
   stosw ;; Worx05: PlayVOCFileWx
   mov AX,offset B20c1655c
   stosw ;; Worx06: PlayVOCBlockWx
   mov AX,offset B20c162e1
   stosw ;; Worx07: StopVOCWx
   mov AX,offset B20c16135
   stosw ;; Worx08: VOCPlayingWx
   mov AX,offset B20c15094
   stosw ;; Worx09: SetRealTimeWx
   mov AX,offset B20c150c1
   stosw ;; Worx0A: ResetRealTimeWx
   mov AX,offset B20c150e5
   stosw ;; Worx0B: TimerDoneWx
   mov AX,offset B20c15d6a
   stosw ;; Worx0C: PlayMIDBlockWx
   mov AX,offset B20c15bd1
   stosw ;; Worx0D: StopSequenceWx
   mov AX,offset B20c16128
   stosw ;; Worx0E: SequencePlayingWx
   mov AX,offset B20c1553a
   stosw ;; Worx0F: LoadSBIItemWx
   mov AX,offset B20c15b14
   stosw ;; Worx10: GoNoteWx
   mov AX,offset B20c15b1c
   stosw ;; Worx11: StopNoteWx
   mov AX,offset B20c15b7c
   stosw ;; Worx12: ProgramChangeWx
   mov AX,offset B20c14ff8
   stosw ;; Worx13: SetAudioModeWx
   mov AX,offset B20c15288
   stosw ;; Worx14: StartResourceWx
   mov AX,offset B20c15438
   stosw ;; Worx15: StopPWMWx
   mov AX,offset B20c14ffd
   stosw ;; Worx16: SetMIDISpeakerWx
   mov AX,offset B20c1518d
   stosw ;; Worx17: OpenElementWx
   mov AX,offset B20c15124
   stosw ;; Worx18: ElementReadWx
   mov AX,offset B20c152db
   stosw ;; Worx19: CloseWorxFWx
   mov AX,offset B20c152f7
   stosw ;; Worx1A: ElementGetsWx
   mov AX,offset B20c1533c
   stosw ;; Worx1B: PlayPWMBlockWx
   mov AX,offset B20c1532b
   stosw ;; Worx1C: PWMPlayingWx
   mov AX,offset B20c15bac
   stosw ;; Worx1D: SetLoopModeWx
   mov AX,offset B20c15e90
   stosw ;; Worx1E: PlayCMFBlockWx
   mov AX,offset B20c16144
   stosw ;; Worx1F: ContinueSequenceWx
   mov AX,offset B20c154d7
   stosw ;; Worx20: SetMasterVolumeWx
   mov AX,offset B20c15519
   stosw ;; Worx21: SetVOCVolumeWx
   mov AX,offset B20c154f8
   stosw ;; Worx22: SetFMVolumeWx
   mov AX,offset B20c15011
   stosw ;; Worx23: AdLibDetectWx
   mov AX,offset B20c14f9d
   stosw ;; Worx24
   mov AX,offset B20c14fd2
   stosw ;; Worx25: CloseWorxDriverWx
   mov AX,offset B20c14b3e
   stosw ;; Worx26
   mov AX,offset B20c14d00
   stosw ;; Worx27: GetLastVOCMarkerWx
   mov AX,offset B20c14cf9
   stosw ;; Worx28: SetVOCIndexWx
   mov AX,offset B20c15cfc
   stosw ;; Worx29: JoyStickUpdateWx
   mov AX,offset B20c15cb9
   stosw ;; Worx2A: JoyStickXWx
   mov AX,offset B20c15cd3
   stosw ;; Worx2B: JoyStickYWx
   mov AX,offset B20c15ced
   stosw ;; Worx2C: JoyStickButtonWx
   mov AX,offset B20c1613f
   stosw ;; Worx2D: GetMIDIBeatWx
   mov AX,offset B20c15bb8
   stosw ;; Worx2E: WorxOff
   mov AX,offset B20c15f81
   stosw ;; Worx2F
   mov AX,offset B20c15f7b
   stosw ;; Worx30: GetTimeDeltaWx
   mov AX,offset B20c150ec
   stosw ;; Worx31: EnableExtenderModeWx
   mov AX,0000
   stosw ;; Worx32: StartPoly
   mov AX,0000
   stosw ;; Worx33: PlaySMPItemL
   mov AX,0000
   stosw ;; Worx34: ClosePoly
   mov AX,0000
   stosw ;; Worx35: PlaySMPItemH
   mov AX,0000
   stosw ;; Worx36: PolyCellStatus
   mov AX,offset B20c164a0
   stosw ;; Worx37: DSPPortSettingWx
   mov AX,offset B20c16747
   stosw ;; Worx38: ResetMPU401Wx
   mov AX,offset B20c16793
   stosw ;; Worx39: LoadIBKFileWx
   mov AX,offset B20c167e9
   stosw ;; Worx3A: PlayWAVBlockWx
   mov AX,offset B20c1686a
   stosw ;; Worx3B: PlayWAVFileWx
   mov AX,C0BD
   call near B20c1565b
   call near B20c1565b
   mov AX,0008
   call near B20c1565b
   mov BX,0000
L20c14c7f:
   call near B20c14f59
   inc BL
   cmp BL,09
   jnz L20c14c7f
   mov AX,C0BD
   call near B20c1565b
   mov AX,0008
   call near B20c1565b
   mov AX,0001
   call near B20c1565b
   inc AX
   call near B20c1565b
   inc AX
   call near B20c1565b
   inc AX
   call near B20c1565b
   add AX,0004
   call near B20c1565b
   mov DI,offset Y20c109bf
   mov AX,DS
   mov ES,AX
   mov AX,offset B20c14f43
   stosw ;; Worx00B
   mov AX,offset B20c14e7d
   stosw ;; Worx01B
   mov AX,offset B20c14db9
   stosw ;; Worx02_09B
   mov AX,offset B20c14d43
   stosw ;; Worx03B
   mov AX,offset B20c14d06
   stosw ;; Worx04B
   mov AX,offset B20c14cf7
   stosw ;; Worx05B
   mov AX,offset B20c14cf5
   stosw ;; Worx06B
   mov AX,offset B20c14cf3
   stosw ;; Worx07B
   mov AX,offset B20c14cf1
   stosw ;; Worx08B
   mov AX,offset B20c14db9
   stosw ;; Worx02_09B
   mov AX,1000
   call near B20c161b7
   mov word ptr [CS:offset Y20c1085c],0800
   pop ES
   pop DS
   pop SI
   pop DI
   pop BX
   pop AX
   sti
ret far

B20c14cf1: ;; Worx08B
   stc
ret near
B20c14cf3: ;; Worx07B
   stc
ret near
B20c14cf5: ;; Worx06B
   stc
ret near
B20c14cf7: ;; Worx05B
   stc
ret near

B20c14cf9: ;; Worx28: SetVOCIndexWx
   mov [CS:offset Y20c14a01],BX
   clc
ret near

B20c14d00: ;; Worx27: GetLastVOCMarkerWx
   mov AX,[CS:offset Y20c109fa]
   clc
ret near

B20c14d06: ;; Worx04B
   cmp byte ptr [CS:offset Y20c14a3b],00
   jz L20c14d1b
   mov DI,offset Y20c107e9
   mov AX,DS
   mov ES,AX
   mov BX,0003
   call near B20c15124
L20c14d1b:
   mov AX,[ES:DI]
   add DI,+02
   mov [CS:offset Y20c109fa],AX
   mov AL,[ES:DI]
   mov [CS:offset Y20c109fc],AL
   inc DI
   add word ptr [CS:offset Y20c109f6],+03
   mov word ptr [CS:offset Y20c109fd],0000
   mov word ptr [CS:offset Y20c109ff],0000
   stc
ret near

B20c14d43: ;; Worx03B
   stc
ret near

B20c14d45:
   cmp CX,+00
   ja L20c14d4b
ret near
L20c14d4b:
   cli
   mov AL,40
   call near B20c162c2
   mov AL,[CS:offset Y20c109f3]
   call near B20c162c2
   mov AL,05
   out 0A,AL
   xor AL,AL
   out 0C,AL
   mov AL,49
   out 0B,AL
   test byte ptr [CS:offset Y20c109df],01
   jz L20c14d73
   mov AX,[CS:offset Y20c109f0]
jmp near L20c14d77
X20c14d72:
   nop
L20c14d73:
   mov AX,[CS:offset Y20c109ee]
L20c14d77:
   out 02,AL
   xchg AH,AL
   out 02,AL
   mov AL,[CS:offset Y20c109ed]
   out 83,AL
   mov AX,CX
   out 03,AL
   xchg AL,AH
   out 03,AL
   mov AL,01
   out 0A,AL
   mov BL,[CS:offset Y20c109f2]
   xor BH,BH
   cmp byte ptr [CS:offset Y20c109fc],01
   ja L20c14da4
   mov SI,offset Y20c109e0
jmp near L20c14da7
X20c14da3:
   nop
L20c14da4:
   mov SI,offset Y20c109e4
L20c14da7:
   mov AL,[BX+SI]
   call near B20c162c2
   mov AX,CX
   dec AX
   call near B20c162c2
   xchg AL,AH
   call near B20c162c2
   sti
ret near

B20c14db9: ;; Worx02_09B
L20c14db9:
   push DS
   mov CX,[CS:offset Y20c109e8]
   call near B20c14d45
   mov CX,1000
   cmp byte ptr [CS:offset Y20c109ff],00
   ja L20c14ddb
   cmp word ptr [CS:offset Y20c109fd],1000
   jnb L20c14ddb
   mov CX,[CS:offset Y20c109fd]
L20c14ddb:
   sub [CS:offset Y20c109fd],CX
   sbb byte ptr [CS:offset Y20c109ff],00
   add [CS:offset Y20c109f6],CX
   push DI
   xor byte ptr [CS:offset Y20c109df],01
   test byte ptr [CS:offset Y20c109df],01
   jnz L20c14e02
   mov DI,[CS:offset Y20c109ee]
jmp near L20c14e07
X20c14e01:
   nop
L20c14e02:
   mov DI,[CS:offset Y20c109f0]
L20c14e07:
   pop SI
   push ES
   mov AH,[CS:offset Y20c109ed]
   shl AH,1
   shl AH,1
   shl AH,1
   shl AH,1
   xor AL,AL
   mov ES,AX
   pop DS
   cmp byte ptr [CS:offset Y20c14a3b],00
   jz L20c14e2b
   mov BX,CX
   call near B20c15124
jmp near L20c14e3d
X20c14e2a:
   nop
L20c14e2b:
   cli
   push CX
   shr CX,1
   cld
   repz movsw
   jnb L20c14e35
   movsb
L20c14e35:
   pop CX
   sti
   cmp CX,1000
   jz L20c14e3d
L20c14e3d:
   pop DS
   mov [CS:offset Y20c109e8],CX
   cmp CX,1000
   jz L20c14e7b
   cmp byte ptr [CS:offset Y20c14a3b],00
   jz L20c14e5a
   mov BX,0001
   call near B20c15124
jmp near L20c14e65
X20c14e59:
   nop
L20c14e5a:
   mov DI,[CS:offset Y20c109f6]
   mov AX,[CS:offset Y20c109f4]
   mov ES,AX
L20c14e65:
   mov AL,[ES:DI]
   cmp word ptr [CS:offset Y20c14a01],-01
   jz L20c14e72
   xor AL,AL
L20c14e72:
   mov [CS:offset Y20c109fc],AL
   inc word ptr [CS:offset Y20c109f6]
L20c14e7b:
   clc
ret near

B20c14e7d: ;; Worx01B
   push DS
   cmp byte ptr [CS:offset Y20c14a3b],00
   jz L20c14e93
   mov DI,offset Y20c107e9
   mov AX,DS
   mov ES,AX
   mov BX,0002
   call near B20c15124
L20c14e93:
   mov byte ptr [CS:offset Y20c109f8],01
   mov AX,[ES:DI]
   add word ptr [CS:offset Y20c109f6],+02
   add DI,+02
   sub word ptr [CS:offset Y20c109fd],+02
   sbb byte ptr [CS:offset Y20c109ff],00
   mov [CS:offset Y20c109f3],AL
   mov [CS:offset Y20c109f2],AH
   mov CX,1000
   cmp byte ptr [CS:offset Y20c109ff],00
   ja L20c14ed3
   cmp word ptr [CS:offset Y20c109fd],1000
   jnb L20c14ed3
   mov CX,[CS:offset Y20c109fd]
L20c14ed3:
   push DI
   sub [CS:offset Y20c109fd],CX
   sbb byte ptr [CS:offset Y20c109ff],00
   add [CS:offset Y20c109f6],CX
   mov [CS:offset Y20c109e8],CX
   test byte ptr [CS:offset Y20c109df],01
   jnz L20c14ef9
   mov DI,[CS:offset Y20c109ee]
jmp near L20c14efe
X20c14ef8:
   nop
L20c14ef9:
   mov DI,[CS:offset Y20c109f0]
L20c14efe:
   pop SI
   push ES
   mov AH,[CS:offset Y20c109ed]
   shl AH,1
   shl AH,1
   shl AH,1
   shl AH,1
   xor AL,AL
   mov ES,AX
   pop DS
   cmp byte ptr [CS:offset Y20c14a3b],00
   jz L20c14f22
   mov BX,CX
   call near B20c15124
jmp near L20c14f2e
X20c14f21:
   nop
L20c14f22:
   cli
   push CX
   shr CX,1
   cld
   repz movsw
   jnb L20c14f2c
   movsb
L20c14f2c:
   pop CX
   sti
L20c14f2e:
   pop DS
   mov byte ptr [CS:offset Y20c109fc],09
   mov DI,[CS:offset Y20c109f6]
   mov AX,[CS:offset Y20c109f4]
   mov ES,AX
jmp near L20c14db9

B20c14f43: ;; Worx00B
   mov CX,[CS:offset Y20c109e8]
   mov byte ptr [CS:offset Y20c109fc],FF
   jcxz L20c14f54
   call near B20c14d45
ret near
L20c14f54:
   call near B20c162e1
   clc
ret near

B20c14f59: ;; ConfigSoundPort
   mov DX,0020
   mov CX,0005
   mov SI,offset Y20c10027
L20c14f62:
   mov AH,[SI]
   inc SI
   mov DI,offset Y20c10776
   add DI,BX
   mov AL,[DI]
   add AL,DL
   call near B20c1565b
   mov AH,[SI]
   inc SI
   mov DI,offset Y20c1077f
   add DI,BX
   mov AL,[DI]
   add AL,DL
   call near B20c1565b
   add DL,20
   cmp DL,A0
   jnz L20c14f8a
   mov DL,E0
L20c14f8a:
   loop L20c14f62
   mov DI,offset Y20c10031
   push BX
   shl BL,1
   add DI,BX
   pop BX
   mov AX,[DI]
   xchg AH,AL
   call near B20c1565b
ret near

B20c14f9d: ;; Worx24
   mov BX,1234
   mov DX,5678
ret near

_CORE_CLOSEWORX: ;; 20c14fa4
   push AX
   push BX
   push CX
   push DI
   push ES
   push DS
   mov AX,CS
   mov DS,AX
   call near B20c15bd1
   call near B20c15573
   call near B20c15bb8
   mov DI,[CS:offset Y20c14a61]
   mov AX,[CS:offset Y20c14a61+02]
   mov ES,AX
   mov AL,63
   call near B20c161e3
   call near B20c152db
   pop DS
   pop ES
   pop DI
   pop CX
   pop BX
   pop AX
   clc
ret far

B20c14fd2: ;; Worx25: CloseWorxDriverWx
   push AX
   push CX
   push DI
   push ES
   call near B20c15bd1
   call near B20c15573
   call near B20c15bb8
   mov DI,[CS:offset Y20c14a61]
   mov AX,[CS:offset Y20c14a61+02]
   mov ES,AX
   mov AL,63
   call near B20c161e3
   call near B20c152db
   pop ES
   pop DI
   pop CX
   pop AX
   clc
ret near

B20c14ff8: ;; Worx13: SetAudioModeWx
   mov [CS:offset Y20c109a8],AL
ret near

B20c14ffd: ;; Worx16: SetMIDISpeakerWx
   mov [CS:offset Y20c109a9],AL
ret near

B20c15002: ;; GetAdLibVec
   push AX
   push CX
   push DX
   mov CX,08FF
L20c15008:
   in AL,DX
   in AL,DX
   in AL,DX
   loop L20c15008
   pop DX
   pop CX
   pop AX
ret near

B20c15011: ;; Worx23: AdLibDetectWx
   push BX
   push DX
   mov DX,0388
   mov AL,04
   out DX,AL
   call near B20c15002
   mov DX,0389
   mov AL,60
   out DX,AL
   call near B20c15002
   mov AL,80
   out DX,AL
   call near B20c15002
   mov DX,0388
   in AL,DX
   mov BL,AL
   mov AL,02
   out DX,AL
   call near B20c15002
   mov DX,0389
   mov AL,FF
   out DX,AL
   call near B20c15002
   mov DX,0388
   mov AL,04
   out DX,AL
   call near B20c15002
   mov DX,0389
   mov AL,21
   out DX,AL
   call near B20c15002
   mov DX,0388
   in AL,DX
   mov BH,AL
   mov AL,04
   out DX,AL
   call near B20c15002
   mov DX,0389
   mov AL,60
   out DX,AL
   call near B20c15002
   mov DX,0389
   mov AL,80
   out DX,AL
   call near B20c15002
   and BX,E0E0
   and BH,BL
   xor AX,AX
   cmp BH,00
   jnz L20c1507e
   inc AX
L20c1507e:
   pop DX
   pop BX
   clc
ret near

B20c15082: ;; Worx03: GetErrorWx
   push DS
   mov AX,CS
   mov DS,AX
   mov AX,[CS:offset Y20c1085a]
   mov word ptr [CS:offset Y20c1085a],0000
   pop DS
ret near

B20c15094: ;; Worx09: SetRealTimeWx
   push BX
   push DX
   push DS
   mov AX,CS
   mov DS,AX
   mov AX,BX
   xor DX,DX
   mov BX,04A9
   mul BX
   mov [CS:offset Y20c1085e],AX
   mov [CS:offset Y20c1085e+02],DX
   mov [CS:offset Y20c10862],AX
   mov [CS:offset Y20c10862+02],DX
   mov byte ptr [CS:offset Y20c10866],00
   clc
   pop DS
   pop DX
   pop AX
ret near

B20c150c1: ;; Worx0A: ResetRealTimeWx
   push AX
   push DX
   push DS
   mov AX,CS
   mov DS,AX
   mov AX,[CS:offset Y20c10862]
   add [CS:offset Y20c1085e],AX
   mov AX,[CS:offset Y20c10862+02]
   adc [CS:offset Y20c1085e+02],AX
   mov byte ptr [CS:offset Y20c10866],00
   clc
   pop DS
   pop DX
   pop AX
ret near

B20c150e5: ;; Worx0B: TimerDoneWx
   xor AH,AH
   mov AL,[CS:offset Y20c10866]
ret near

B20c150ec: ;; Worx31: EnableExtenderModeWx
   mov byte ptr [CS:offset Y20c10004],01
ret near

B20c150f3: ;; CallWorx (interrupt call)
   sti
   push CX
   push DS
   push ES
   push SI
   push AX
   push CS
   pop DS
   cmp byte ptr [CS:offset Y20c10004],00
   jz L20c15105
   mov ES,DX
L20c15105:
   xor AL,AL
   xchg AL,AH
   mov SI,offset Y20c14a65
   shl AX,1
   add SI,AX
   mov AX,[SI]
   cmp AX,0000
   pop AX
   jz L20c1511f
   call near [SI]
   jnb L20c1511f
   mov AX,FFFF
L20c1511f:
   pop SI
   pop ES
   pop DS
   pop CX
iret

B20c15124: ;; Worx18: ElementReadWx
   push BX
   push CX
   push DX
   push DS
   push DI
   push ES
   mov CX,CS
   mov DS,CX
   push BX
   mov AX,4201
   xor CX,CX
   xor DX,DX
   mov BX,[CS:offset Y20c14a43]
   int 21
   mov SI,offset Y20c14a47
   sub AX,[SI+08]
   sbb DX,[SI+0A]
   cmp DX,[SI+02]
   jb L20c15156
   cmp AX,[SI]
   jb L20c15156
   xor AX,AX
   xor DX,DX
jmp near L20c15184
X20c15155:
   nop
L20c15156:
   xchg BX,AX
   xchg CX,DX
   mov AX,[SI]
   mov DX,[SI+02]
   sub AX,BX
   sbb DX,CX
   pop BX
   cmp DX,+00
   ja L20c1516e
   cmp BX,AX
   jbe L20c1516e
   mov BX,AX
L20c1516e:
   push DS
   mov CX,BX
   mov DX,DI
   mov BX,[CS:offset Y20c14a43]
   mov AX,ES
   mov DS,AX
   mov AH,3F
   int 21
   pop DS
jmp near L20c15186
X20c15183:
   nop
L20c15184:
   pop BX
   stc
L20c15186:
   pop ES
   pop DI
   pop DS
   pop DX
   pop CX
   pop BX
ret near

B20c1518d: ;; Worx17: OpenElementWx
   push BX
   push CX
   push SI
   push DI
   push ES
   call near B20c16182
   cmp byte ptr [CS:offset Y20c1081c],00
   jz L20c151a0
   call near B20c14b1d
L20c151a0:
   cmp byte ptr [CS:offset Y20c14a60],00
   jnz L20c15218
   mov AX,[CS:offset Y20c14a43]
   cmp AX,FFFF
   jz L20c151c9
   mov word ptr [CS:offset Y20c14a43],FFFF
   mov BX,AX
   mov AH,3E
   xor AL,AL
   int 21
   jnb L20c151c9
   mov [CS:offset Y20c1085a],AX
jmp near L20c1527b
L20c151c9:
   push DS
   push DX
   mov AX,ES
   mov DS,AX
   mov AX,3D00
   mov DX,DI
   int 21
   pop DX
   pop DS
   jnb L20c151e1
   mov [CS:offset Y20c1085a],AX
jmp near L20c1527b
L20c151e1:
   mov [CS:offset Y20c14a43],AX
   mov BX,AX
   mov AX,4202
   xor CX,CX
   xor DX,DX
   int 21
   mov SI,offset Y20c14a47
   mov [SI],AX
   mov [SI+02],DX
   mov word ptr [SI+08],0000
   mov word ptr [SI+0A],0000
   mov BX,[CS:offset Y20c14a43]
   mov AX,4200
   xor CX,CX
   xor DX,DX
   int 21
   mov AX,[SI]
   mov DX,[SI+02]
jmp near L20c15282

X20c15217:
   nop
L20c15218:
   call near B20c16700
   mov AX,4200
   mov BX,[CS:offset Y20c14a43]
   xor CX,CX
   mov DX,0002
   int 21
   jb L20c15282
   mov CX,[CS:offset Y20c14a45]
L20c15231:
   jcxz L20c1527b
   push CX
   mov CX,0019
   mov DX,offset Y20c14a47
   mov BX,[CS:offset Y20c14a43]
   mov AH,3F
   int 21
   pop CX
   dec CX
   xor BX,BX
   mov SI,DX
   add SI,+0C
L20c1524c:
   lodsb
   cmp AL,00
   jz L20c15259
   cmp AL,[ES:BX+DI]
   jnz L20c15231
   inc BX
jmp near L20c1524c
L20c15259:
   cmp byte ptr [ES:BX+DI],00
   jz L20c15261
jmp near L20c15231
L20c15261:
   mov SI,offset Y20c14a47
   mov DX,[SI+08]
   mov CX,[SI+0A]
   mov BX,[CS:offset Y20c14a43]
   mov AX,4200
   int 21
   mov AX,[SI]
   mov DX,[SI+02]
   jnb L20c15282
L20c1527b:
   stc
   mov DX,FFFF
   mov AX,FFFF
L20c15282:
   pop ES
   pop DI
   pop SI
   pop CX
   pop BX
ret near

B20c15288: ;; Worx14: StartResourceWx
   push BX
   push CX
   push DX
   push ES
   call near B20c16182
   cmp byte ptr [CS:offset Y20c1081c],00
   jz L20c1529a
   call near B20c14b1d
L20c1529a:
   push DS
   mov DX,DI
   mov AX,ES
   mov DS,AX
   mov AX,3D00
   int 21
   pop DS
   jnb L20c152b1
   mov [CS:offset Y20c1085a],AX
   stc
jmp near L20c152d6
X20c152b0:
   nop
L20c152b1:
   mov [CS:offset Y20c14a43],AX
   mov BX,AX
   mov AH,3F
   mov CX,0002
   mov DX,offset Y20c14a45
   int 21
   jnb L20c152cb
   mov [CS:offset Y20c1085a],AX
   stc
jmp near L20c152d6
X20c152ca:
   nop
L20c152cb:
   mov byte ptr [CS:offset Y20c14a60],01
   mov AX,[CS:offset Y20c14a45]
   clc
L20c152d6:
   pop ES
   pop DX
   pop CX
   pop BX
ret near

B20c152db: ;; Worx19: CloseWorxFWx
   mov BX,[CS:offset Y20c14a43]
   cmp BX,-01
   jz L20c152e9
   mov AH,3E
   int 21
L20c152e9:
   mov byte ptr [CS:offset Y20c14a60],00
   mov word ptr [CS:offset Y20c14a43],FFFF
ret near

A20c152f7: ;; Worx1A: ElementGetsWx
   push AX
   push BX
   push CX
   push DI
   mov CL,AL
   xor CH,CH
L20c152ff:
   jcxz L20c15316
   mov BX,0001
   call near B20c15124
   cmp AX,0000
   jz L20c15317
   cmp byte ptr [ES:DI],0A
   jz L20c15316
   inc DI
   dec CX
jmp near L20c152ff
L20c15316:
   inc DI
L20c15317:
   mov byte ptr [ES:DI],00
   pop DI
   pop CX
   pop BX
   pop AX
   cmp byte ptr [CS:offset Y20c1081c],00
   jz L20c1532a
   call near B20c14af1
L20c1532a:
ret near

B20c1532b: ;; Worx1C: PWMPlayingWx
   push DS
   mov AX,CS
   mov DS,AX
   mov AL,[CS:offset Y20c109b6]
   xor AH,AH
   and AX,0001
   pop DS
   clc
ret near

B20c1533c: ;; Worx1B: PlayPWMBlockWx
   cli
   push DI
   push DS
   push ES
   mov AX,CS
   mov DS,AX
   cmp byte ptr [CS:offset Y20c109b6],00
   jz L20c1534f
   call near B20c15438
L20c1534f:
   call near B20c16182
   add DI,+0A
   mov [CS:offset Y20c109bb],DI
   mov AX,ES
   mov [CS:offset Y20c109bd],AX
   mov AX,[ES:DI]
   cmp AX,FFFF
   jz L20c153c9
   mov AL,08
   call near B20c161fc
   mov [CS:offset Y20c109b7],DI
   mov AX,ES
   mov [CS:offset Y20c109b7+02],AX
   mov DI,offset A20c153ce
   mov AX,CS
   mov ES,AX
   mov AL,08
   call near B20c161e3
   mov AL,B0
   out 43,AL
   mov DI,[CS:offset Y20c109bb]
   mov AX,[CS:offset Y20c109bd]
   mov [CS:offset L20c153d1+1],AX
   mov ES,AX
   mov AX,[ES:DI]
   mov [CS:offset L20c153d8+1],AX
   add DI,+02
   mov AL,[ES:DI]
   inc DI
   out 42,AL
   xor AL,AL
   out 42,AL
   in AL,61
   or AL,03
   out 61,AL
   mov AX,DI
   mov [CS:offset L20c153dd+2],AX
   dec word ptr [CS:offset L20c153d8+1]
   mov AL,50
   xor AH,AH
   call near B20c161b7
   mov AL,01
   mov [CS:offset Y20c109b6],AL
L20c153c9:
   pop ES
   pop DS
   pop DI
   sti
ret near

A20c153ce: ;; Int08Fn (interrupt call)
   cli
   push AX
   push ES
L20c153d1: ;; (@) Self-modifying code point at L20c153d1+1.
   mov AX,0000	;; (@) B8 [0000]
   mov ES,AX
   xor AX,AX
L20c153d8: ;; (@) Self-modifying code point at L20c153d8+1.
   cmp AX,0000	;; (@) 3D [0000]
   jz L20c153f8
L20c153dd: ;; (@) Self-modifying code point at L20c153dd+1.
   mov AL,[ES:0000]	;; (@) 26A0 [0000]
   out 42,AL
   xor AL,AL
   out 42,AL
   dec word ptr [CS:offset L20c153d8+1]
   inc word ptr [CS:offset L20c153dd+2]
   mov AL,20
   out 20,AL
   pop ES
   pop AX
iret
L20c153f8:
   push DI
   push DS
   mov AX,CS
   mov DS,AX
   mov AL,34
   out 43,AL
   mov AX,[CS:offset Y20c1085c]
   call near B20c161b7
   in AL,61
   and AL,FC
   out 61,AL
   mov AX,[CS:offset Y20c109aa]
   out 42,AL
   xchg AL,AH
   out 42,AL
   xor AL,AL
   mov [CS:offset Y20c109b6],AL
   mov DI,[CS:offset Y20c109b7]
   mov AX,[CS:offset Y20c109b7+02]
   mov ES,AX
   mov AL,08
   call near B20c161e3
   mov AL,20
   out 20,AL
   pop DS
   pop DI
   pop ES
   pop AX
iret

B20c15438: ;; Worx15: StopPWMWx
   cli
   push AX
   push ES
   push DI
   push DS
   mov AX,CS
   mov DS,AX
   mov AL,34
   out 43,AL
   mov AX,[CS:offset Y20c1085c]
   call near B20c161b7
   in AL,61
   and AL,FC
   out 61,AL
   mov AX,[CS:offset Y20c109aa]
   out 42,AL
   xchg AL,AH
   out 42,AL
   xor AL,AL
   mov [CS:offset Y20c109b6],AL
   mov DI,[CS:offset Y20c109b7]
   mov AX,[CS:offset Y20c109b7+02]
   mov ES,AX
   mov AL,08
   call near B20c161e3
   pop DS
   pop DI
   pop ES
   pop AX
ret near

B20c15477:
   mov DI,[CS:offset Y20c109f6]
   mov AX,[CS:offset Y20c109f4]
   mov ES,AX
L20c15482:
   mov AX,[CS:offset Y20c109fd]
   add AL,[CS:offset Y20c109ff]
   cmp AX,0000
   ja L20c154bd
   cmp byte ptr [CS:offset Y20c14a3b],00
   jz L20c154a5
   mov DI,offset Y20c107e9
   mov AX,DS
   mov ES,AX
   mov BX,0003
   call near B20c15124
L20c154a5:
   mov AX,[ES:DI]
   mov [CS:offset Y20c109fd],AX
   mov AL,[ES:DI+02]
   mov [CS:offset Y20c109ff],AL
   add word ptr [CS:offset Y20c109f6],+03
   add DI,+03
L20c154bd:
   mov BL,[CS:offset Y20c109fc]
   xor BH,BH
   cmp BX,+09
   jbe L20c154cb
   xor BX,BX
L20c154cb:
   shl BX,1
   mov SI,offset Y20c109bf
   add SI,BX
   call near [SI]
   jb L20c15482
ret near

B20c154d7: ;; Worx20: SetMasterVolumeWx
   cmp byte ptr [CS:offset Y20c14a42],01
   jb L20c154f2
   mov DX,[CS:offset Y20c14a40]
   add DX,+04
   mov AL,22
   out DX,AL
   inc DX
   mov AL,BL
   out DX,AL
   xor AX,AX
   clc
ret near
L20c154f2:
   xor AX,AX
   not AX
   clc
ret near

B20c154f8: ;; Worx22: SetFMVolumeWx
   cmp byte ptr [CS:offset Y20c14a42],01
   jb L20c15513
   mov DX,[CS:offset Y20c14a40]
   add DX,+04
   mov AL,26
   out DX,AL
   inc DX
   mov AL,BL
   out DX,AL
   xor AX,AX
   clc
ret near
L20c15513:
   xor AX,AX
   not AX
   clc
ret near

B20c15519: ;; Worx21: SetVOCVolumeWx
   cmp byte ptr [CS:offset Y20c14a42],01
   jb L20c15534
   mov DX,[CS:offset Y20c14a40]
   add DX,+04
   mov AL,04
   out DX,AL
   inc DX
   mov AL,BL
   out DX,AL
   xor AX,AX
   clc
ret near
L20c15534:
   xor AX,AX
   not AX
   clc
ret near

B20c1553a: ;; Worx0F: LoadSBIItemWx
   push BX
   push CX
   push SI
   push DI
   push DS
   push ES
   mov AX,[ES:DI]
   cmp AX,4253
   jz L20c1554c
   stc
jmp near L20c1556c
X20c1554b:
   nop
L20c1554c:
   mov AX,CS
   mov DS,AX
   mov SI,offset Y20c10143
   push DS
   push ES
   pop DS
   pop ES
   push DI
   push SI
   pop DI
   pop SI
   mov AX,000B
   mul BX
   add DI,AX
   add SI,+24
   mov CX,000B
   cld
   repz movsb
   clc
L20c1556c:
   pop ES
   pop DS
   pop DI
   pop SI
   pop CX
   pop BX
ret near

B20c15573:
   xor CX,CX
L20c15575:
   mov AL,A0
   add AL,CL
   mov AH,00
   call near B20c1565b
   mov AL,B0
   add AL,CL
   mov AH,00
   call near B20c1565b
   inc CX
   cmp CX,[CS:offset Y20c109ae]
   jb L20c15575
   mov AX,00BD
   call near B20c1565b
ret near

B20c15596:
   push AX
   push BX
   push DI
   push DX
   push SI
   mov SI,offset Y20c10143
   push BX
   mov AX,000B
   xor BH,BH
   mul BX
   add SI,AX
   pop BX
   xchg BL,BH
   xor BH,BH
   mov AL,[SI]
   mov AH,20
   add AH,[CS:BX+offset Y20c10776]
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AL,[SI]
   mov AH,20
   add AH,[CS:BX+offset Y20c1077f]
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AL,[SI]
   mov AH,40
   add AH,[CS:BX+offset Y20c10776]
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AL,[SI]
   mov AH,40
   add AH,[CS:BX+offset Y20c1077f]
   mov [CS:BX+offset Y20c107e0],AL
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AL,[SI]
   mov DI,offset Y20c10776
   mov AH,60
   add AH,[BX+DI]
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AL,[SI]
   mov DI,offset Y20c1077f
   mov AH,60
   add AH,[BX+DI]
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AL,[SI]
   mov DI,offset Y20c10776
   mov AH,80
   add AH,[BX+DI]
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AL,[SI]
   mov DI,offset Y20c1077f
   mov AH,80
   add AH,[BX+DI]
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AL,[SI]
   mov DI,offset Y20c10776
   mov AH,E0
   add AH,[BX+DI]
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AL,[SI]
   mov DI,offset Y20c1077f
   mov AH,E0
   add AH,[BX+DI]
   xchg AL,AH
   call near B20c1565b
   inc SI
   mov AX,00C0
   add AX,BX
   xchg AL,AH
   lodsb
   xchg AH,AL
   call near B20c1565b
   pop SI
   pop DX
   pop DI
   pop BX
   pop AX
ret near

B20c1565b: ;; PutAdLib
   push AX
   push BX
   push CX
   push DX
   mov DX,0388
   out DX,AL
   mov CX,0064
L20c15666:
   in AL,DX
   loop L20c15666
   inc DX
   xchg AL,AH
   out DX,AL
   mov CX,001E
L20c15670:
   in AX,40
   mov BX,AX
L20c15674:
   in AX,40
   cmp AX,BX
   jz L20c15674
   loop L20c15670
   pop DX
   pop CX
   pop BX
   pop AX
ret near

B20c15681:
   cmp byte ptr [CS:offset Y20c109a8],02
   jnz L20c156a6
   mov BL,00
L20c1568b:
   mov AL,B0
   or AL,BL
   call near B20c16725
   mov AL,7B
   call near B20c16725
   mov AL,00
   call near B20c16725
   inc BL
   cmp BL,10
   jb L20c1568b
jmp near L20c156b4
X20c156a5:
   nop
L20c156a6:
   cmp byte ptr [CS:offset Y20c109a8],00
   jnz L20c156b4
   in AL,61
   and AL,FD
   out 61,AL
L20c156b4:
   push BX
   xor CX,CX
   mov BH,AH
L20c156b9:
   mov SI,offset Y20c107a5
   push CX
   shl CX,1
   add SI,CX
   pop CX
   lodsw
   cmp BH,AH
   jnz L20c156e2
   mov AL,A0
   add AL,CL
   xor AH,AH
   call near B20c1565b
   mov AL,B0
   add AL,CL
   xor AH,AH
   call near B20c1565b
   mov SI,offset Y20c107d7
   add SI,CX
   mov AL,00
   mov [SI],AL
L20c156e2:
   inc CX
   cmp CX,+09
   jb L20c156b9
   pop BX
ret near

B20c156ea:
   mov AH,AL
   and AH,0F
   cmp BH,7B
   jnz L20c156fa
   call near B20c15681
jmp near L20c157ad
L20c156fa:
   cmp BH,07
   jnz L20c1570b
   xchg AH,BL
   xor BH,BH
   mov [CS:BX+offset Y20c107c7],AH
jmp near L20c157ad
L20c1570b:
   cmp BH,67
   jnz L20c1578a
   cmp BL,00
   jz L20c1571d
   cmp BL,01
   jz L20c15744
jmp near L20c157ad
L20c1571d:
   mov byte ptr [CS:offset Y20c109b5],C0
   mov byte ptr [CS:offset Y20c1075d],00
   mov AX,C0BD
   call near B20c1565b
   mov SI,offset Y20c107a5
   mov word ptr [SI+0C],FFFF
   mov word ptr [SI+0E],FFFF
   mov word ptr [SI+10],FFFF
jmp near L20c157ad
X20c15743:
   nop
L20c15744:
   mov byte ptr [CS:offset Y20c109b5],E0
   mov byte ptr [CS:offset Y20c1075d],01
   mov AX,E0BD
   call near B20c1565b
   mov BX,10FF
   mov SI,offset Y20c107a5
   mov [SI+0C],BX
   mov [SI+0E],BX
   mov [SI+10],BX
   mov SI,offset Y20c106e5
L20c15768:
   lodsw
   xchg AH,AL
   cmp AX,FFFF
   jz L20c15775
   call near B20c1565b
jmp near L20c15768
L20c15775:
   mov AX,E0BD
   call near B20c1565b
   mov AX,0008
   call near B20c1565b
   mov byte ptr [CS:offset Y20c109b5],E0
jmp near L20c157ad
X20c15789:
   nop
L20c1578a:
   cmp BH,69
   jz L20c15797
   cmp BH,68
   jz L20c15797
jmp near L20c157ad
X20c15796:
   nop
L20c15797:
   xor BH,BH
   mov SI,offset Y20c10795
   mov CL,BL
   mov BL,[CS:offset Y20c109b0]
   cmp BH,68
   jnz L20c157ab
   or CL,80
L20c157ab:
   mov [BX+SI],CL
L20c157ad:
ret near

B20c157ae:
   cmp byte ptr [CS:offset Y20c109a8],02
   jnz L20c157e8
   push AX
   push BX
   push CX
   push BX
   mov BL,AL
   shr BL,1
   shr BL,1
   shr BL,1
   shr BL,1
   sub BL,08
   xor BH,BH
   mov CL,[CS:BX+offset Y20c10997]
   xor CH,CH
   pop BX
   call near B20c16725
   jcxz L20c157e4
   dec CX
   mov AL,BH
   call near B20c16725
   jcxz L20c157e4
   dec CX
   mov AL,BL
   call near B20c16725
L20c157e4:
   pop CX
   pop BX
   pop AX
ret near
L20c157e8:
   push AX
   mov AH,AL
   and AH,F0
   and AL,0F
   mov [CS:offset Y20c109b0],AL
   mov [CS:offset Y20c109b4],AH
   mov [CS:offset Y20c109b1],BH
   mov [CS:offset Y20c109b2],BL
   cmp byte ptr [CS:offset Y20c109b4],90
   jbe L20c15827
   cmp byte ptr [CS:offset Y20c109b4],B0
   ja L20c15819
   call near B20c156ea
jmp near L20c1585a
X20c15818:
   nop
L20c15819:
   cmp byte ptr [CS:offset Y20c109b4],C0
   ja L20c1585a
   call near B20c15b85
jmp near L20c1585a
X20c15826:
   nop
L20c15827:
   test byte ptr [CS:offset Y20c109b5],20
   jz L20c1584a
   cmp byte ptr [CS:offset Y20c1075d],01
   jnz L20c15842
   cmp byte ptr [CS:offset Y20c109b0],09
   jz L20c15857
jmp near L20c1584a
X20c15841:
   nop
L20c15842:
   cmp byte ptr [CS:offset Y20c109b0],0B
   jnb L20c15857
L20c1584a:
   mov AL,[CS:offset Y20c109b1]
   add AL,[CS:offset Y20c10996]
   mov [CS:offset Y20c109b1],AL
L20c15857:
   call near B20c158b4
L20c1585a:
   clc
   pop AX
ret near
L20c1585d:
   push AX
   push BX
   push SI
   in AL,61
   test AL,02
   jz L20c1586a
   and AL,FD
   out 61,AL
L20c1586a:
   mov AL,[CS:offset Y20c109a9]
   cmp [CS:offset Y20c109b0],AL
   jnz L20c158af
   cmp byte ptr [CS:offset Y20c109b4],90
   jnz L20c158af
   cmp byte ptr [CS:offset Y20c109b2],00
   jz L20c158af
   cmp byte ptr [CS:offset Y20c109b1],09
   jb L20c158af
   xor BX,BX
   mov BL,[CS:offset Y20c109b1]
   shl BX,1
   mov SI,offset Y20c10043
   mov AL,B6
   out 43,AL
   mov AX,[BX+SI]
   mov [CS:offset Y20c109aa],AX
   out 42,AL
   xchg AL,AH
   out 42,AL
   in AL,61
   or AL,03
   out 61,AL
L20c158af:
   clc
   pop SI
   pop BX
   pop AX
ret near

B20c158b4:
   cmp byte ptr [CS:offset Y20c109a8],00
   jz L20c1585d
   mov word ptr [CS:offset Y20c109ae],0009
   test byte ptr [CS:offset Y20c109b5],20
   jz L20c15929
   mov word ptr [CS:offset Y20c109ae],0006
   cmp byte ptr [CS:offset Y20c1075d],01
   jnz L20c158e2
   cmp byte ptr [CS:offset Y20c109b0],09
   jz L20c15908
L20c158e2:
   cmp byte ptr [CS:offset Y20c109b0],0B
   jb L20c15929
   mov AH,10
   mov CL,[CS:offset Y20c109b0]
   sub CL,0B
   shr AH,CL
   xor [CS:offset Y20c109b5],AH
   mov AH,[CS:offset Y20c109b5]
   mov AL,BD
   call near B20c1565b
jmp near L20c15a11
L20c15908:
   mov BL,[CS:offset Y20c109b1]
   sub BL,23
   xor BH,BH
   mov SI,offset Y20c106c3
   mov AH,[BX+SI]
   xor [CS:offset Y20c109b5],AH
   mov AH,[CS:offset Y20c109b5]
   mov AL,BD
   call near B20c1565b
jmp near L20c15a11
L20c15929:
   cmp byte ptr [CS:offset Y20c109b4],80
   ja L20c1596d
L20c15931:
   mov CX,[CS:offset Y20c109ae]
   xor BX,BX
   mov SI,offset Y20c107a5
L20c1593b:
   shl BX,1
   mov AX,[BX+SI]
   shr BX,1
   cmp AH,[CS:offset Y20c109b0]
   jz L20c1594e
L20c15948:
   inc BX
   loop L20c1593b
jmp near L20c15a11
L20c1594e:
   mov SI,offset Y20c107d7
   mov AL,[BX+SI]
   cmp AL,[CS:offset Y20c109b1]
   jz L20c1595f
   mov SI,offset Y20c107a5
jmp near L20c15948
L20c1595f:
   mov [CS:offset Y20c109b3],BL
   call near B20c15a12
   mov byte ptr [BX+SI],00
jmp near L20c15a11
L20c1596d:
   cmp byte ptr [CS:offset Y20c109b2],00
   jz L20c15931
   xor CX,CX
   mov SI,offset Y20c107a5
L20c1597a:
   lodsw
   cmp AH,[CS:offset Y20c109b0]
   jz L20c159bd
   inc CX
   cmp CX,[CS:offset Y20c109ae]
   jnz L20c1597a
L20c1598a:
   xor CX,CX
   mov SI,offset Y20c107a5
L20c1598f:
   lodsw
   cmp AH,FF
   jz L20c159bd
   inc CX
   cmp CX,[CS:offset Y20c109ae]
   jnz L20c1598f
   xor BX,BX
L20c1599f:
   mov SI,offset Y20c107d7
   cmp byte ptr [BX+SI],00
   jz L20c159b2
   inc BX
   cmp BX,[CS:offset Y20c109ae]
   jb L20c1599f
jmp near L20c15a11
X20c159b1:
   nop
L20c159b2:
   mov SI,offset Y20c107a5
   shl BX,1
   mov word ptr [BX+SI],FFFF
jmp near L20c1596d
L20c159bd:
   push SI
   mov SI,offset Y20c107d7
   add SI,CX
   cmp byte ptr [SI],00
   pop SI
   jz L20c159d3
   inc CX
   cmp CX,[CS:offset Y20c109ae]
   jnz L20c1597a
jmp near L20c1598a
L20c159d3:
   xor CH,CH
   mov DX,BX
   mov [CS:offset Y20c109b3],CL
   mov BL,[CS:offset Y20c109b0]
   mov AH,BL
   xor BH,BH
   mov SI,offset Y20c107b7
   mov CH,[BX+SI]
   cmp CH,AL
   jz L20c15a0d
   mov SI,offset Y20c107a5
   mov BL,[CS:offset Y20c109b3]
   xor BH,BH
   shl BL,1
   mov AL,CH
   mov AH,[CS:offset Y20c109b0]
   mov [BX+SI],AX
   mov BH,[CS:offset Y20c109b3]
   mov BL,AL
   call near B20c15596
L20c15a0d:
   call near B20c15a12
ret near
L20c15a11:
ret near

B20c15a12:
   push BX
   push DX
   push SI
   mov DH,[CS:offset Y20c109b1]
   mov BL,[CS:offset Y20c109b3]
   xor BH,BH
   mov [CS:BX+offset Y20c107d7],DH
   mov BH,DH
   dec BH
   mov AL,BH
   xor AH,AH
   mov BX,000C
   xor DX,DX
   div BX
   mov BX,AX
   mov CL,DL
   mov SI,offset Y20c1075e
   shl DX,1
   add SI,DX
   mov DX,[SI]
   push BX
   mov SI,offset Y20c10795
   xor BH,BH
   mov BL,[CS:offset Y20c109b0]
   mov AL,[BX+SI]
   cmp AL,00
   jz L20c15a7b
   mov CH,AL
   mov SI,offset Y20c10788
   mov BL,CL
   cmp AL,80
   jb L20c15a5f
   inc SI
L20c15a5f:
   mov BL,[BX+SI]
   mul BL
   shl AX,1
   xchg AH,AL
   xor AH,AH
   cmp CH,80
   jnz L20c15a75
   add AX,DX
   mov DX,AX
jmp near L20c15a7b

X20c15a74:
   nop
L20c15a75:
   neg AX
   add AX,DX
   mov DX,AX
L20c15a7b:
   pop BX
   mov AL,A0
   add AL,[CS:offset Y20c109b3]
   mov AH,DL
   call near B20c1565b
   mov AL,B0
   add AL,[CS:offset Y20c109b3]
   and DH,03
   shl BX,1
   shl BX,1
   cmp byte ptr [CS:offset Y20c109b4],80
   jz L20c15ab9
   cmp byte ptr [CS:offset Y20c109b2],00
   jz L20c15ab9
   test byte ptr [CS:offset Y20c109b5],20
   jz L20c15ab6
   cmp byte ptr [CS:offset Y20c109b0],0B
   jnb L20c15ab9
L20c15ab6:
   or BL,20
L20c15ab9:
   or BL,DH
   mov AH,BL
   call near B20c1565b
   mov BL,[CS:offset Y20c109b3]
   xor BH,BH
   push CX
   mov AH,[CS:BX+offset Y20c107e0]
   and AH,3F
   mov AL,3F
   sub AL,AH
   mov BL,[CS:offset Y20c109b0]
   xor BH,BH
   mov CL,[CS:BX+offset Y20c107c7]
   cmp CL,60
   jb L20c15ae7
   mov CL,5F
L20c15ae7:
   add CL,20
   shl CL,1
   mul CL
   pop CX
   inc AH
   mov AL,3F
   sub AL,AH
   mov BL,[CS:offset Y20c109b3]
   xor BH,BH
   mov AH,[CS:BX+offset Y20c107e0]
   and AH,C0
   or AH,AL
   mov AL,40
   add AL,[CS:BX+offset Y20c1077f]
   call near B20c1565b
   pop SI
   pop DX
   pop BX
ret near

B20c15b14: ;; Worx10: GoNoteWx
   and AL,0F
   or AL,90
   call near B20c157ae
ret near

B20c15b1c: ;; Worx11: StopNoteWx
   and AL,0F
   or AL,80
   xor BL,BL
   call near B20c157ae
ret near

B20c15b26:
   push AX
   push DI
   push ES
   mov byte ptr [CS:offset Y20c109b5],C0
   mov AX,C0BD
   call near B20c1565b
   mov BH,00
   mov BL,00
L20c15b39:
   call near B20c15596
   inc BH
   cmp BH,09
   jb L20c15b39
   mov DI,offset Y20c107b7
   mov AX,DS
   mov ES,AX
   mov AL,00
   mov CX,0010
   cld
   repz stosb
   mov DI,offset Y20c10795
   mov AX,DS
   mov ES,AX
   mov AL,00
   mov CX,0010
   cld
   repz stosb
   mov DI,offset Y20c107d7
   xor AL,AL
   mov CX,0009
   cld
   repz stosb
   mov DI,offset Y20c107a5
   mov AX,FFFF
   mov CX,0009
   cld
   repz stosw
   pop ES
   pop DI
   pop AX
ret near

B20c15b7c: ;; Worx12: ProgramChangeWx
   mov [CS:offset Y20c109b0],AL
   mov [CS:offset Y20c109b1],BL

B20c15b85:
   push AX
   push BX
   push SI
   test byte ptr [CS:offset Y20c109b5],20
   jz L20c15b98
   cmp byte ptr [CS:offset Y20c109b0],B0
   jnb L20c15ba8
L20c15b98:
   mov SI,offset Y20c107b7
   mov BL,[CS:offset Y20c109b0]
   xor BH,BH
   mov AL,[CS:offset Y20c109b1]
   mov [BX+SI],AL
L20c15ba8:
   pop SI
   pop BX
   pop AX
ret near

B20c15bac: ;; Worx1D: SetLoopModeWx
   push AX
   mov AX,CS
   mov DS,AX
   mov [CS:offset Y20c10874],BL
   pop AX
ret near

B20c15bb8: ;; Worx2E: WorxOff
   cli
   mov DI,[CS:offset Y20c109a3]
   mov AX,[CS:offset Y20c109a3+02]
   mov ES,AX
   mov AL,00
   call near B20c16215
   mov AX,FFFF
   call near B20c161b7
   sti
ret near

B20c15bd1: ;; Worx0D: StopSequenceWx
   push AX
   push CX
   call near B20c15681
   xor AL,AL
   mov [CS:offset Y20c10975],AL
   mov AL,[CS:offset Y20c109b5]
   and AL,E0
   cmp AL,E0
   jz L20c15c04
   mov CX,0009
   mov AX,00A0
L20c15bec:
   call near B20c1565b
   inc AL
   loop L20c15bec
   mov CX,0009
   mov AX,00B0
L20c15bf9:
   call near B20c1565b
   inc AL
   loop L20c15bf9
   clc
   pop CX
   pop AX
ret near
L20c15c04:
   mov AX,C0BD
   call near B20c1565b
   mov AX,0008
   call near B20c1565b
   mov CX,0006
   mov AX,00A0
L20c15c16:
   call near B20c1565b
   inc AL
   loop L20c15c16
   mov CX,0006
   mov AX,00B0
L20c15c23:
   call near B20c1565b
   inc AL
   loop L20c15c23
   pop CX
   pop AX
   clc
ret near

B20c15c2e: ;; WorxOn
   cli
   mov AL,00
   call near B20c1622a
   mov [CS:offset Y20c109a3],DI
   mov AX,ES
   mov [CS:offset Y20c109a3+02],ES
   mov DI,offset A20c15c4e
   mov AX,CS
   mov ES,AX
   mov AL,00
   call near B20c16215
   sti
ret near

A20c15c4e: ;; Int00Fn (interrupt call)
   push AX
   push BP
   push BX
   push CX
   push DX
   push ES
   push DS
   push SI
   push DI
   pushf
   mov AX,CS
   mov DS,AX
   mov AX,[CS:offset Y20c1085c]
   sub [CS:offset Y20c1085e],AX
   sbb word ptr [CS:offset Y20c1085e+02],+00
   jnb L20c15c73
   mov byte ptr [CS:offset Y20c10866],01
L20c15c73:
   cmp byte ptr [CS:offset Y20c109a8],03
   call near B20c15f81
   inc byte ptr [CS:offset Y20c109a7]
   inc word ptr [CS:offset Y20c1099f]
   push BX
   mov AX,[CS:offset Y20c1099f]
   mov BX,[CS:offset Y20c109a1]
   cmp AX,BX
   pop BX
   jb L20c15caa
   xor AX,AX
   mov [CS:offset Y20c1099f],AX
   mov BX,offset Y20c109a3
   call far [BX]
   pop DI
   pop SI
   pop DS
   pop ES
   pop DX
   pop CX
   pop BX
   pop BP
   pop AX
iret
L20c15caa:
   mov AL,20
   out 20,AL
   popf
   pop DI
   pop SI
   pop DS
   pop ES
   pop DX
   pop CX
   pop BX
   pop BP
   pop AX
iret

B20c15cb9: ;; Worx2A: JoyStickXWx
   mov AX,[CS:offset Y20c1001b]
   mov BX,0040
   mul BX
   xor DX,DX
   mov BX,[CS:offset Y20c10023]
   cmp BX,+00
   stc
   jz L20c15cd2
   div BX
   clc
L20c15cd2:
ret near

B20c15cd3: ;; Worx2B: JoyStickYWx
   mov AX,[CS:offset Y20c1001d]
   mov BX,0040
   mul BX
   xor DX,DX
   mov BX,[CS:offset Y20c10025]
   cmp BX,+00
   stc
   jz L20c15cec
   div BX
   clc
L20c15cec:
ret near

B20c15ced: ;; Worx2C: JoyStickButtonWx
   push SI
   mov SI,offset Y20c1001f
   xor AH,AH
   add SI,AX
   mov AL,[SI]
   xor AH,AH
   pop SI
   clc
ret near

B20c15cfc: ;; Worx29: JoyStickUpdateWx
   push AX
   push DX
   mov DX,0201
   mov word ptr [CS:offset Y20c1001b],0000
   mov word ptr [CS:offset Y20c1001d],0000
   in AL,DX
   mov SI,offset Y20c1001f
   add SI,+03
   mov CX,0004
L20c15d19:
   xor AH,AH
   shl AL,1
   jb L20c15d21
   mov AH,01
L20c15d21:
   mov [SI],AH
   dec SI
   loop L20c15d19
   mov CX,0028
L20c15d29:
   out DX,AL
   loop L20c15d29
   mov CX,0320
L20c15d2f:
   mov DX,0201
   in AL,DX
   mov BL,AL
   and BL,01
   xor BH,BH
   add [CS:offset Y20c1001b],BX
   mov BL,AL
   shr BL,1
   and BL,01
   xor BH,BH
   add [CS:offset Y20c1001d],BX
   loop L20c15d2f
   cmp word ptr [CS:offset Y20c10023],+00
   jnz L20c15d67
   mov AX,[CS:offset Y20c1001b]
   mov [CS:offset Y20c10023],AX
   mov AX,[CS:offset Y20c1001d]
   mov [CS:offset Y20c10025],AX
L20c15d67:
   pop DX
   pop AX
ret near

B20c15d6a: ;; Worx0C: PlayMIDBlockWx
   push SI
   push DI
   push DS
   call near B20c16182
   push ES
   mov AX,CS
   mov DS,AX
   call near B20c15b26
   xor AL,AL
   mov [CS:offset Y20c10975],AL
   cmp byte ptr [CS:offset Y20c1075d],01
   jnz L20c15d8f
   mov byte ptr [CS:offset Y20c109b5],E0
jmp near L20c15d95
X20c15d8e:
   nop
L20c15d8f:
   mov byte ptr [CS:offset Y20c109b5],C0
L20c15d95:
   mov [CS:offset Y20c10872],DI
   mov SI,DI
   mov AX,ES
   mov DS,AX
   lodsw
   cmp AX,544D
   jnz L20c15e06
   lodsw
   cmp AX,6468
   jnz L20c15e06
   mov AX,CS
   mov DS,AX
   mov ES,AX
   mov DI,offset Y20c10875
   mov CX,0020
   xor AX,AX
   cld
   repz stosw
   pop ES
   mov AX,ES
   mov [CS:offset Y20c10870],AX
   mov DI,SI
   mov AX,[ES:DI]
   add DI,+02
   mov AX,[ES:DI]
   add DI,+02
   mov AX,[ES:DI]
   add DI,+02
   cmp AH,01
   ja L20c15e06
   mov AX,[ES:DI]
   add DI,+02
   xchg AL,AH
   mov [CS:offset Y20c1086b],AX
   mov AX,[ES:DI]
   add DI,+02
   xchg AL,AH
   mov [CS:offset Y20c1086d],AX
   mov CX,[CS:offset Y20c1086b]
   mov word ptr [CS:offset Y20c109ac],0000
   jcxz L20c15e0d
jmp near L20c15e2c

X20c15e05:
   nop
L20c15e06:
   stc
   mov AX,BX
   pop DS
   pop DI
   pop SI
ret near
L20c15e0d:
   mov byte ptr [CS:offset Y20c1086f],00
   mov byte ptr [CS:offset Y20c10975],01
   mov word ptr [CS:offset Y20c10867],0000
   mov word ptr [CS:offset Y20c10869],0000
   clc
   pop DS
   pop DI
   pop SI
ret near
L20c15e2c:
   jcxz L20c15e0d
   mov AX,[ES:DI]
   add DI,+02
   cmp AX,544D
   jnz L20c15e06
   mov AX,[ES:DI]
   add DI,+02
   cmp AX,6B72
   jnz L20c15e06
   mov AX,[ES:DI]
   add DI,+02
   mov AX,[ES:DI]
   add DI,+02
   xchg AH,AL
   mov BX,AX
   push BX
   push DI
   call near B20c1614b
   mov SI,offset Y20c108b5
   mov BX,[CS:offset Y20c109ac]
   shl BX,1
   shl BX,1
   mov [BX+SI],AX
   mov [BX+SI+02],DX
   mov SI,offset Y20c10935
   mov BX,[CS:offset Y20c109ac]
   shl BX,1
   mov [BX+SI],DI
   mov SI,offset Y20c10875
   mov word ptr [BX+SI],0001
   pop DI
   pop BX
   add DI,BX
   inc word ptr [CS:offset Y20c109ac]
   dec CX
jmp near L20c15e2c
L20c15e89:
   stc
   mov AX,BX
   pop DS
   pop DI
   pop SI
ret near

B20c15e90: ;; Worx1E: PlayCMFBlockWx
   push SI
   push DI
   push DS
   call near B20c16182
   push ES
   mov AX,CS
   mov DS,AX
   mov AX,ES
   mov [CS:offset Y20c10870],AX
   mov [CS:offset Y20c10872],DI
   mov DX,DI
   call near B20c15b26
   mov [CS:offset Y20c10975],AL
   mov SI,DI
   mov AX,ES
   mov DS,AX
   lodsw
   cmp AX,5443
   jnz L20c15e89
   lodsw
   cmp AX,464D
   jnz L20c15e89
   mov AX,CS
   mov DS,AX
   mov ES,AX
   mov DI,offset Y20c10875
   mov CX,0020
   xor AX,AX
   cld
   repz stosw
   pop ES
   mov DI,SI
   add DI,+02
   mov AX,[ES:DI]
   push AX
   add DI,+02
   mov BX,[ES:DI]
   add DI,+02
   mov AX,[ES:DI]
   mov [CS:offset Y20c1086d],AX
   add DI,+02
   push BX
   push DX
   mov BX,[ES:DI]
   mov DX,0012
   mov AX,34DC
   div BX
   call near B20c161b7
   mov [CS:offset Y20c1085c],AX
   pop DX
   pop BX
   add DI,+02
   add DI,+02
   add DI,+02
   add DI,+02
   add DI,+10
   mov CX,[ES:DI]
   add DI,+02
   mov DI,DX
   pop AX
   add DI,AX
   mov SI,DI
   mov DI,offset Y20c10143
   push DS
   push ES
   pop DS
   pop ES
L20c15f28:
   jcxz L20c15f37
   push CX
   mov CX,000B
   cld
   repz movsb
   add SI,+05
   pop CX
   loop L20c15f28
L20c15f37:
   mov DI,DX
   add DI,BX
   push ES
   push DS
   pop ES
   pop DS
   call near B20c1614b
   mov SI,offset Y20c108b5
   mov [SI],AX
   mov [SI+02],DX
   mov AX,0001
   mov [CS:offset Y20c1086b],AX
   mov [CS:offset Y20c10875],AX
   mov [CS:offset Y20c10975],AL
   mov [CS:offset Y20c10935],DI
jmp near L20c15f61

X20c15f60:
   nop
L20c15f61:
   mov BL,01
   mov [CS:offset Y20c1086f],BL
   mov word ptr [CS:offset Y20c10867],0000
   mov word ptr [CS:offset Y20c10869],0000
   clc
   pop DS
   pop DI
   pop SI
ret near

B20c15f7b: ;; Worx30: GetTimeDeltaWx
   mov AX,[CS:offset Y20c1085c]
   clc
ret near

B20c15f81: ;; Worx2F
   mov AX,CS
   mov DS,AX
   cmp byte ptr [CS:offset Y20c10975],00
   jnz L20c15f8e
ret near
L20c15f8e:
   inc word ptr [CS:offset Y20c10867]
   mov AX,[CS:offset Y20c10867]
   cmp AX,[CS:offset Y20c1086d]
   jb L20c15faa
   mov word ptr [CS:offset Y20c10867],0000
   inc word ptr [CS:offset Y20c10869]
L20c15faa:
   mov word ptr [CS:offset Y20c109ac],0000
L20c15fb1:
   mov DX,[CS:offset Y20c109ac]
   cmp DX,[CS:offset Y20c1086b]
   jnz L20c15fbe
ret near
L20c15fbe:
   mov BX,[CS:offset Y20c109ac]
   shl BX,1
   mov SI,offset Y20c10875
   cmp word ptr [BX+SI],+00
   jnz L20c15fd4
   inc word ptr [CS:offset Y20c109ac]
jmp near L20c15fb1
L20c15fd4:
   mov SI,offset Y20c108b5
   mov BX,[CS:offset Y20c109ac]
   shl BX,1
   shl BX,1
   clc
   mov AX,[BX+SI]
   add AX,[BX+SI+02]
   cmp AX,0001
   jbe L20c15ff9
   sub word ptr [BX+SI],+01
   sbb word ptr [BX+SI+02],+00
   inc word ptr [CS:offset Y20c109ac]
jmp near L20c15fb1
L20c15ff9:
   mov SI,offset Y20c10935
   mov BX,[CS:offset Y20c109ac]
   shl BX,1
   mov DI,[BX+SI]
   mov AX,[CS:offset Y20c10870]
   mov ES,AX
L20c1600b:
   mov AL,[ES:DI]
   inc DI
   cmp AL,FF
   jz L20c1608a
   cmp AL,80
   jnb L20c1601b
   dec DI
jmp near L20c1602a
X20c1601a:
   nop
L20c1601b:
   push BX
   mov BX,[CS:offset Y20c109ac]
   mov SI,offset Y20c10976
   mov [BX+SI],AL
   pop BX
jmp near L20c16036
X20c16029:
   nop
L20c1602a:
   push BX
   mov BX,[CS:offset Y20c109ac]
   mov SI,offset Y20c10976
   mov AL,[BX+SI]
   pop BX
L20c16036:
   mov BL,AL
   shr BL,1
   shr BL,1
   shr BL,1
   shr BL,1
   sub BL,08
   mov SI,offset Y20c10997
   xor BH,BH
   mov CL,[BX+SI]
   xor CH,CH
   jcxz L20c1605a
   mov BH,[ES:DI]
   inc DI
   dec CL
   jcxz L20c1605a
   mov BL,[ES:DI]
   inc DI
L20c1605a:
   call near B20c157ae
L20c1605d:
   call near B20c1614b
   cmp AX,0000
   ja L20c1606a
   cmp DX,+00
   jz L20c1600b
L20c1606a:
   mov SI,offset Y20c108b5
   mov BX,[CS:offset Y20c109ac]
   shl BX,1
   shl BX,1
   mov [BX+SI],AX
   mov [BX+SI+02],DX
   mov SI,offset Y20c10935
   shr BX,1
   mov [BX+SI],DI
   inc word ptr [CS:offset Y20c109ac]
jmp near L20c15fb1
L20c1608a:
   mov AL,[ES:DI]
   inc DI
   cmp AL,2F
   jz L20c160cd
   cmp AL,51
   jz L20c160a0
   xor AH,AH
   mov AL,[ES:DI]
   inc DI
   add DI,AX
jmp near L20c1605d
L20c160a0:
   inc DI
   push DX
   mov DL,[ES:DI]
   inc DI
   xor DH,DH
   mov AX,[ES:DI]
   add DI,+02
   xchg AH,AL
   mov BX,[CS:offset Y20c1086d]
   div BX
   mov BX,1E73
   mul BX
   mov AX,DX
   mov BX,000A
   mul BX
   call near B20c161b7
   mov [CS:offset Y20c1085c],AX
   pop DX
jmp near L20c1605d
L20c160cd:
   inc DI
   inc DI
   mov SI,offset Y20c10875
   mov BX,[CS:offset Y20c109ac]
   shl BX,1
   mov word ptr [BX+SI],0000
   mov SI,offset Y20c10875
   xor BX,BX
   mov CX,[CS:offset Y20c1086b]
L20c160e7:
   push BX
   shl BX,1
   cmp word ptr [BX+SI],+00
   pop BX
   jnz L20c160f6
   inc BX
   loop L20c160e7
jmp near L20c160fe
X20c160f5:
   nop
L20c160f6:
   inc word ptr [CS:offset Y20c109ac]
jmp near L20c15fb1
L20c160fe:
   mov AL,[CS:offset Y20c10874]
   cmp AL,00
   jz L20c16121
   mov AX,[CS:offset Y20c10870]
   mov ES,AX
   mov DI,[CS:offset Y20c10872]
   mov AL,[CS:offset Y20c1086f]
   cmp AL,01
   jz L20c1611d
   call near B20c15d6a
ret near
L20c1611d:
   call near B20c15e90
ret near
L20c16121:
   mov AL,00
   mov [CS:offset Y20c10975],AL
ret near

B20c16128: ;; Worx0E: SequencePlayingWx
   push DS
   mov AX,CS
   mov DS,AX
   mov AL,[CS:offset Y20c10975]
   xor AH,AH
   pop DS
ret near

B20c16135: ;; Worx08: VOCPlayingWx
   xor AH,AH
   mov AL,[CS:offset Y20c109f8]
   and AX,0001
ret near

B20c1613f: ;; Worx2D: GetMIDIBeatWx
   mov AX,[CS:offset Y20c10869]
ret near

B20c16144: ;; Worx1F: ContinueSequenceWx
   mov byte ptr [CS:offset Y20c10975],01
ret near

B20c1614b:
   push BX
   push CX
   xor AX,AX
   xor DX,DX
L20c16151:
   mov BL,[ES:DI]
   inc DI
   mov BH,BL
   and BL,7F
   or AL,BL
   cmp BH,80
   jb L20c1617f
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
jmp near L20c16151
L20c1617f:
   pop CX
   pop BX
ret near

B20c16182: ;; FlattenSeg
   push AX
   push DX
   mov AX,ES
   xor DX,DX
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   add AX,DI
   adc DX,+00
   mov DI,AX
   and DI,+0F
   shr DX,1
   rcr AX,1
   shr DX,1
   rcr AX,1
   shr DX,1
   rcr AX,1
   shr DX,1
   rcr AX,1
   mov ES,AX
   pop DX
   pop AX
ret near

B20c161b7: ;; SetTimer
   push AX
   push BX
   push DS
   mov BX,CS
   mov DS,BX
   push AX
   push BX
   push DX
   mov BX,AX
   xor DX,DX
   mov AX,FFFF
   div BX
   mov [CS:offset Y20c109a1],AX
   mov [CS:offset Y20c1099f],AX
   pop DX
   pop BX
   mov AL,34
   out 43,AL
   pop AX
   out 40,AL
   mov AL,AH
   out 40,AL
   pop DS
   pop BX
   pop AX
ret near

B20c161e3: ;; SetIntVec
   push AX
   push DI
   push ES
   push ES
   push DI
   xor AH,AH
   shl AX,1
   shl AX,1
   mov DI,AX
   xor AX,AX
   mov ES,AX
   pop AX
   stosw
   pop AX
   stosw
   pop ES
   pop DI
   pop AX
ret near

B20c161fc: ;; GetIntVec
   push AX
   push DS
   push SI
   xor AH,AH
   shl AX,1
   shl AX,1
   mov SI,AX
   xor AX,AX
   mov DS,AX
   lodsw
   mov DI,AX
   lodsw
   mov ES,AX
   pop SI
   pop DS
   pop AX
ret near

B20c16215: ;; SetUserIntVec
   push AX
   cmp AL,08
   jnb L20c16221
   add AL,08
   call near B20c161e3
   pop AX
ret near
L20c16221:
   sub AL,08
   add AL,70
   call near B20c161e3
   pop AX
ret near

B20c1622a: ;; GetUserIntVec
   push AX
   cmp AL,08
   jnb L20c16236
   add AL,08
   call near B20c161fc
   pop AX
ret near
L20c16236:
   sub AL,08
   add AL,70
   call near B20c161fc
   pop AX
ret near

B20c1623f:
   push AX
   push BX
   push CX
   push DX
   cmp AL,08
   jnb L20c16267
   cmp AL,02
   jz L20c16261
   mov CL,AL
   mov BL,01
   shl BL,CL
   in AL,21
   and AL,BL
   cmp AL,BL
   jnz L20c16292
   not BL
   in AL,21
   and AL,BL
   out 21,AL
L20c16261:
   pop DX
   pop CX
   pop BX
   pop AX
   clc
ret near
L20c16267:
   sub AL,08
   mov CL,AL
   mov BL,01
   shl BL,CL
   mov DX,00A1
   in AL,DX
   and AL,BL
   cmp AL,BL
   jnz L20c16292
   not BL
   mov DX,00A1
   in AL,DX
   and AL,BL
   out DX,AL
   mov AL,67
   out A0,AL
   mov AX,0002
   call near B20c1623f
   pop DX
   pop CX
   pop BX
   pop AX
   clc
ret near
L20c16292:
   pop DX
   pop CX
   pop BX
   pop AX
   stc
ret near

B20c16298: ;; MaskUserInt
   push AX
   push BX
   push DX
   cmp AL,08
   jnb L20c162af
   mov CL,AL
   mov BL,01
   shl BL,CL
   in AL,21
   or AL,BL
   out 21,AL
   pop DX
   pop BX
   pop AX
ret near
L20c162af:
   sub AL,08
   mov CL,AL
   mov BL,01
   shl BL,CL
   mov DX,00A1
   in AL,DX
   or AL,BL
   out DX,AL
   pop DX
   pop BX
   pop AX
ret near

B20c162c2:
   push AX
   push CX
   push DX
   mov AH,AL
   mov DX,[CS:offset Y20c14a40]
   add DX,+0C
   mov CX,FFFF
L20c162d2:
   jcxz L20c162da
   dec CX
   in AL,DX
   test AL,80
   jnz L20c162d2
L20c162da:
   mov AL,AH
   out DX,AL
   pop DX
   pop CX
   pop AX
ret near

B20c162e1: ;; Worx07: StopVOCWx
   cli
   push AX
   push BX
   push DS
   push DX
   mov AX,CS
   mov DS,AX
   mov DX,[CS:offset Y20c14a40]
   add DX,+0E
   in AL,DX
   cmp byte ptr [CS:offset Y20c109f8],00
   jz L20c16310
   mov byte ptr [CS:offset Y20c109f8],00
   cli
   mov AL,D0
   call near B20c162c2
   mov AL,05
   out 0A,AL
   mov AL,00
   out 0C,AL
   sti
L20c16310:
   mov byte ptr [CS:offset Y20c109f9],00
   pop DX
   pop DS
   pop BX
   pop AX
ret near
L20c1631b:
   add AX,2000
   adc DX,+00
jmp near L20c1634c
X20c16323:
   nop

B20c16324: ;; Worx01: DSPResetWx
   push ES
   mov AX,DS
   xor DX,DX
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   shl AX,1
   rcl DX,1
   mov BX,offset Y20c10a01
   add AX,BX
   adc DX,+00
   mov BX,0000
   sub BX,2000
   cmp AX,BX
   ja L20c1631b
L20c1634c:
   mov [CS:offset Y20c109eb],DX
   push CX
   mov CL,0C
   shl word ptr [CS:offset Y20c109eb],CL
   pop CX
   mov [CS:offset Y20c109ed],DL
   mov [CS:offset Y20c109ee],AX
   add AX,1000
   mov [CS:offset Y20c109f0],AX
   push AX
   push CX
   push DI
   push ES
   mov DI,offset Y20c10a01
   mov AX,DS
   mov ES,AX
   mov CX,2000
   mov AX,8080
   repz stosw
   pop ES
   pop DI
   pop CX
   pop AX
L20c16381:
   call near B20c164a6
   jnb L20c163a4
   mov DX,[CS:offset Y20c14a40]
   add DX,+10
   mov [CS:offset Y20c14a40],DX
   cmp DX,0300
   jz L20c1639b
jmp near L20c16381
L20c1639b:
   mov byte ptr [CS:offset Y20c14a2c],00
   pop ES
   stc
ret near
L20c163a4:
   mov DX,[CS:offset Y20c14a40]
   add DX,+04
   xor AL,AL
   out DX,AL
   inc DX
   out DX,AL
   dec DX
   mov AL,22
   out DX,AL
   inc DX
   mov AL,55
   out DX,AL
   dec DX
   mov AL,22
   out DX,AL
   inc DX
   in AL,DX
   cmp AL,55
   jnz L20c163d8
   mov byte ptr [CS:offset Y20c14a42],01
   mov BL,FF
   call near B20c154d7
   mov BL,FF
   call near B20c154f8
   mov BL,FF
   call near B20c15519
L20c163d8:
   mov SI,offset Y20c14a2d
L20c163db:
   call near B20c162e1
   call near B20c164a6
   mov CX,008F
L20c163e4:
   in AL,40
   in AL,40
   mov BL,AL
L20c163ea:
   in AL,40
   in AL,40
   cmp BL,AL
   jz L20c163ea
   loop L20c163e4
   mov AL,[SI]
   cmp AL,FF
   jz L20c16454
   call near B20c1623f
   jb L20c16451
   call near B20c1622a
   mov [CS:offset Y20c14a3c],DI
   mov BX,ES
   mov [CS:offset Y20c14a3c+02],BX
   mov AL,[SI]
   mov [CS:offset Y20c14a2c],AL
   mov DI,offset A20c164ee
   mov BX,CS
   mov ES,BX
   call near B20c16215
   push SI
   mov DI,offset Y20c14a03
   mov AX,DS
   mov ES,AX
   call near B20c1655c
   pop SI
   mov CX,0001
L20c1642d:
   push CX
   mov CX,FFFF
L20c16431:
   loop L20c16431
   pop CX
   loop L20c1642d
   cmp byte ptr [CS:offset Y20c109f8],00
   jz L20c1645b
   mov DI,[CS:offset Y20c14a3c]
   mov AX,[CS:offset Y20c14a3c+02]
   mov ES,AX
   mov AL,[SI]
   call near B20c16298
   call near B20c16215
L20c16451:
   inc SI
jmp near L20c163db
L20c16454:
   xor AX,AX
   not AX
   pop ES
   stc
ret near
L20c1645b:
   call near B20c162e1
   mov AL,D1
   call near B20c162c2
   mov AL,[SI]
   xor AH,AH
   pop ES
   clc
ret near

B20c1646a: ;; Worx04: DSPCloseWx
   cli
   push AX
   push BX
   push DI
   push ES
   push DS
   mov AX,CS
   mov DS,AX
   mov AL,[CS:offset Y20c14a2c]
   cmp AL,00
   jz L20c16492
   call near B20c16298
   mov AL,[CS:offset Y20c14a2c]
   mov DI,[CS:offset Y20c14a3c]
   mov BX,[CS:offset Y20c14a3c+02]
   mov ES,BX
   call near B20c16215
L20c16492:
   clc
   pop DS
   pop ES
   pop DI
   pop BX
   pop AX
   sti
ret near

B20c1649a: ;; Worx02: ForceConfigWx
   mov [CS:offset Y20c14a40],BX
ret near

B20c164a0: ;; Worx37: DSPPortSettingWx
   mov AX,[CS:offset Y20c14a40]
   clc
ret near

B20c164a6:
   push AX
   push DX
   mov DX,[CS:offset Y20c14a40]
   add DX,+06
   mov AL,01
   out DX,AL
   mov CX,00C8
L20c164b6:
   loop L20c164b6
   xor AL,AL
   out DX,AL
   mov CX,00C8
   mov DX,[CS:offset Y20c14a40]
   add DX,+0E
L20c164c6:
   in AL,DX
   cmp AL,80
   jnb L20c164d1
   loop L20c164c6
L20c164cd:
   stc
   pop DX
   pop AX
ret near
L20c164d1:
   mov DX,[CS:offset Y20c14a40]
   add DX,+0A
   in AL,DX
   cmp AL,AA
   jnz L20c164cd
   mov AL,D3
   call near B20c162c2
   mov CX,0FFF
L20c164e6:
   in AL,DX
   in AL,DX
   loop L20c164e6
   clc
   pop DX
   pop AX
ret near

A20c164ee:
   cli
   push AX
   push BX
   push CX
   push DI
   push DS
   push DX
   push ES
   push SI
   mov AX,CS
   mov DS,AX
   mov DX,[CS:offset Y20c14a40]
   add DX,+0E
   in AL,DX
   mov AL,20
   out 20,AL
   out A0,AL
   sti
   cmp byte ptr [CS:offset Y20c14a3b],02
   jb L20c1652e
   mov CX,[CS:offset Y20c109e8]
   jcxz L20c16550
   call near B20c14d45
   xor byte ptr [CS:offset Y20c109df],01
   call near B20c168e7
   mov [CS:offset Y20c109e8],CX
jmp near L20c16553

X20c1652d:
   nop
L20c1652e:
   cmp byte ptr [CS:offset Y20c109fc],FF
   jz L20c16550
   cmp byte ptr [CS:offset Y20c109f9],00
   ja L20c16550
   mov byte ptr [CS:offset Y20c109f9],01
   call near B20c15477
   mov byte ptr [CS:offset Y20c109f9],00
jmp near L20c16553

X20c1654f:
   nop
L20c16550:
   call near B20c162e1
L20c16553:
   pop SI
   pop ES
   pop DX
   pop DS
   pop DI
   pop CX
   pop BX
   pop AX
iret

B20c1655c: ;; Worx06: PlayVOCBlockWx
   call near B20c162e1
   mov byte ptr [CS:offset Y20c14a3b],00
   mov [CS:offset Y20c109ea],BL
   mov word ptr [CS:offset Y20c109fd],0000
   mov byte ptr [CS:offset Y20c109ff],00
   call near B20c16182
   mov AX,ES
   mov [CS:offset Y20c109f4],AX
   mov [CS:offset Y20c109f6],DI
   cmp byte ptr [ES:DI],43
   jz L20c16593
L20c1658b:
   mov byte ptr [CS:offset Y20c109f9],00
   stc
ret near
L20c16593:
   cmp byte ptr [ES:DI+01],72
   jnz L20c1658b
   add word ptr [CS:offset Y20c109f6],+1A
   cmp word ptr [CS:offset Y20c14a01],-01
   jz L20c165e2
L20c165a8:
   mov DI,[CS:offset Y20c109f6]
   cmp byte ptr [ES:DI],00
   jz L20c1658b
   cmp byte ptr [ES:DI],04
   jnz L20c165d1
   mov BX,[ES:DI+04]
   mov [CS:offset Y20c109fa],BX
   cmp [CS:offset Y20c14a01],BX
   jz L20c165e2
   add word ptr [CS:offset Y20c109f6],+06
jmp near L20c165a8
L20c165d1:
   mov BX,[ES:DI+01]
   add [CS:offset Y20c109f6],BX
   add word ptr [CS:offset Y20c109f6],+04
jmp near L20c165a8
L20c165e2:
   mov DI,[CS:offset Y20c109f6]
   mov AL,[ES:DI]
   mov [CS:offset Y20c109fc],AL
   add word ptr [CS:offset Y20c109f6],+01
   call near B20c15477
   xor AX,AX
   clc
ret near

B20c165fb: ;; Worx05: PlayVOCFileWx
   call near B20c162e1
   mov byte ptr [CS:offset Y20c14a3b],01
   mov [CS:offset Y20c109ea],BL
   mov word ptr [CS:offset Y20c109fd],0000
   mov byte ptr [CS:offset Y20c109ff],00
   call near B20c16182
   call near B20c1518d
   mov DI,offset Y20c107e9
   mov AX,DS
   mov ES,AX
   mov BX,001A
   call near B20c15124
   cmp byte ptr [ES:DI],43
   jz L20c16637
L20c1662f:
   mov byte ptr [CS:offset Y20c109f8],00
   stc
ret near
L20c16637:
   cmp byte ptr [ES:DI+01],72
   jnz L20c1662f
   cmp word ptr [CS:offset Y20c14a01],-01
   jz L20c1668d
   mov DI,offset Y20c107e9
   mov CX,DS
   mov ES,CX
L20c1664d:
   mov BX,0004
   call near B20c15124
   cmp byte ptr [ES:DI],00
   jz L20c1662f
   cmp byte ptr [ES:DI],04
   jnz L20c16676
   mov BX,0002
   call near B20c15124
   mov BX,[ES:DI]
   mov [CS:offset Y20c109fa],BX
   cmp [CS:offset Y20c14a01],BX
   jz L20c1668d
jmp near L20c1664d
L20c16676:
   mov BX,[CS:offset Y20c14a43]
   mov DX,[ES:DI+01]
   mov CL,[ES:DI+03]
   xor CH,CH
   mov AL,01
   mov AH,42
   int 21
jmp near L20c1664d
L20c1668d:
   mov BX,0001
   call near B20c15124
   mov AL,[ES:DI]
   mov [CS:offset Y20c109fc],AL
   call near B20c15477
   xor AX,AX
   clc
ret near

X20c166a1:
   push AX
   push BX
   push CX
   push DI
   push ES
   cmp byte ptr [CS:offset Y20c109f2],00
   ja L20c166fa
   cmp byte ptr [CS:offset Y20c109ea],FF
   jz L20c166fa
   mov CX,[CS:offset Y20c109e8]
   test byte ptr [CS:offset Y20c109df],01
   jz L20c166cb
   mov DI,[CS:offset Y20c109ee]
jmp near L20c166d0

X20c166ca:
   nop
L20c166cb:
   mov DI,[CS:offset Y20c109f0]
L20c166d0:
   mov AH,[CS:offset Y20c109ed]
   xor AL,AL
   shl AH,1
   shl AH,1
   shl AH,1
   shl AH,1
   mov ES,AX
   mov BL,[CS:offset Y20c109ea]
   xor BH,BH
L20c166e8:
   mov AL,[ES:DI]
   xor AH,AH
   sub AX,0080
   imul BX
   add AH,80
   xchg AL,AH
   stosb
   loop L20c166e8
L20c166fa:
   pop ES
   pop DI
   pop CX
   pop BX
   pop AX
ret near

B20c16700:
   push AX
   push CX
   push SI
   push DI
   push ES
   push DS
   push ES
   pop DS
   push DI
   pop SI
   cld
jmp near L20c16719

X20c1670d:
   nop
L20c1670e:
   sub AL,61
   cmp AL,19
   ja L20c16719
   add AL,41
   mov [SI-01],AL
L20c16719:
   lodsb
   and AL,AL
   jnz L20c1670e
   pop DS
   pop ES
   pop DI
   pop SI
   pop CX
   pop AX
ret near

B20c16725:
   push AX
   push CX
   push DX
   mov AH,AL
   mov CX,FFFF
   mov DX,0331
L20c16730:
   jcxz L20c16742
   dec CX
   in AL,DX
   test AL,40
   jnz L20c16730
   mov AL,AH
   mov DX,0330
   out DX,AL
   pop DX
   pop CX
   pop AX
ret near
L20c16742:
   pop DX
   pop CX
   pop AX
   stc
ret near

B20c16747: ;; Worx38: ResetMPU401Wx
   xor BX,BX
L20c16749:
   cmp BX,+03
   jnb L20c16791
   inc BX
   mov DX,0331
   mov CX,FFFF
L20c16755:
   jcxz L20c16791
   dec CX
   in AL,DX
   test AL,40
   jnz L20c16755
   mov DX,0331
   mov AL,FF
   out DX,AL
   mov DX,0331
   mov CX,FFFF
L20c16769:
   jcxz L20c16791
   dec CX
   in AL,DX
   test AL,80
   jnz L20c16769
   mov DX,0330
   in AL,DX
   cmp AL,FE
   jnz L20c16749
   mov DX,0331
   mov CX,FFFF
L20c1677f:
   jcxz L20c16791
   dec CX
   in AL,DX
   test AL,40
   jnz L20c1677f
   mov DX,0331
   mov AL,3F
   out DX,AL
   xor AX,AX
   clc
ret near
L20c16791:
   stc
ret near

B20c16793: ;; Worx39: LoadIBKFileWx
   push BX
   push CX
   push DI
   push SI
   call near B20c16182
   xor BX,BX
   mov SI,offset Y20c10143
   add DI,+04
L20c167a2:
   mov CX,000B
L20c167a5:
   mov AL,[ES:DI]
   inc DI
   mov [SI],AL
   inc SI
   loop L20c167a5
   add DI,+05
   inc BX
   cmp BX,0080
   jb L20c167a2
   pop SI
   pop DI
   pop CX
   pop BX
ret near

Y20c167bd:	db "RIFF",00,00,00,00,"WAVEfmt ",00,00,00,00,00,00,00,00
Y20c167d5:	word	;; WavDiv
Y20c167d7:	ds 000a
Y20c167e1:	db "data"
Y20c167e5:	word
Y20c167e7:	word

B20c167e9: ;; Worx3A: PlayWAVBlockWx
   push DI
   push SI
   call near B20c16182
   mov CX,002C
   shr CX,1
   mov SI,offset Y20c167bd
L20c167f6:
   mov AX,[ES:DI]
   mov [SI],AX
   add SI,+02
   add DI,+02
   loop L20c167f6
   mov AX,ES
   mov [CS:offset Y20c109f4],AX
   mov [CS:offset Y20c109f6],DI
   mov byte ptr [CS:offset Y20c109fc],00
   mov AX,[CS:offset Y20c167e5]
   mov [CS:offset Y20c109fd],AX
   mov AX,[CS:offset Y20c167e7]
   mov [CS:offset Y20c109ff],AX
   mov byte ptr [CS:offset Y20c109f2],00
   mov AX,4240
   mov DX,000F
   mov BX,[CS:offset Y20c167d5]
   div BX
   mov BX,0100
   sub BX,AX
   mov [CS:offset Y20c109f3],BL
   mov byte ptr [CS:offset Y20c14a3b],02
   mov byte ptr [CS:offset Y20c109df],00
   call near B20c168e7
   call near B20c14d45
   mov byte ptr [CS:offset Y20c109f8],01
   mov byte ptr [CS:offset Y20c109df],01
   call near B20c168e7
   mov [CS:offset Y20c109e8],CX
   pop SI
   pop DI
ret near

B20c1686a: ;; Worx3B: PlayWAVFileWx
   push DI
   push ES
   push SI
   call near B20c16182
   call near B20c1518d
   jb L20c168df
   mov DI,offset Y20c167bd
   mov AX,DS
   mov ES,AX
   mov BX,002C
   call near B20c15124
   mov byte ptr [CS:offset Y20c109fc],00
   mov AX,[CS:offset Y20c167e5]
   mov [CS:offset Y20c109fd],AX
   mov AX,[CS:offset Y20c167e7]
   mov [CS:offset Y20c109ff],AX
   mov byte ptr [CS:offset Y20c109f2],00
   mov AX,4240
   mov DX,000F
   mov BX,[CS:offset Y20c167d5]
   div BX
   mov BX,0100
   sub BX,AX
   mov [CS:offset Y20c109f3],BL
   mov byte ptr [CS:offset Y20c14a3b],03
   mov byte ptr [CS:offset Y20c109df],00
   call near B20c168e7
   call near B20c14d45
   mov byte ptr [CS:offset Y20c109f8],01
   mov byte ptr [CS:offset Y20c109df],01
   call near B20c168e7
   mov [CS:offset Y20c109e8],CX
   pop SI
   pop ES
   pop DI
ret near
L20c168df:
   pop SI
   pop ES
   pop DI
   stc
   mov AX,FFFF
ret near

B20c168e7:
   push DI
   push SI
   mov CX,1000
   mov AX,[CS:offset Y20c109fd]
   mov DX,[CS:offset Y20c109ff]
   cmp DX,+00
   ja L20c16903
   cmp AX,1000
   jnb L20c16903
   mov CX,AX
   jcxz L20c1695a
L20c16903:
   sub [CS:offset Y20c109fd],CX
   sbb word ptr [CS:offset Y20c109ff],+00
   test byte ptr [CS:offset Y20c109df],01
   jz L20c1691e
   mov DI,[CS:offset Y20c109f0]
jmp near L20c16923
X20c1691d:
   nop
L20c1691e:
   mov DI,[CS:offset Y20c109ee]
L20c16923:
   mov AH,[CS:offset Y20c109ed]
   xor AL,AL
   shl AX,1
   shl AX,1
   shl AX,1
   shl AX,1
   mov ES,AX
   cmp byte ptr [CS:offset Y20c14a3b],02
   jz L20c16944
   mov BX,CX
   call near B20c15124
jmp near L20c16955
X20c16943:
   nop
L20c16944:
   push CX
   push DS
   mov SI,[CS:offset Y20c109f6]
   mov AX,[CS:offset Y20c109f4]
   mov DS,AX
   repz movsb
   pop DS
   pop CX
L20c16955:
   add [CS:offset Y20c109f6],CX
L20c1695a:
   pop SI
   pop DI
ret near

B20c1695d:
   push AX
   push BX
   push CX
   push SI
L20c16961:
   mov AL,[CS:SI]
   cmp AL,00
   jz L20c16973
   mov BL,07
   mov BH,00
   mov AH,0E
   int 10
   inc SI
jmp near L20c16961
L20c16973:
   pop SI
   pop CX
   pop BX
   pop AX
ret near

X20c16978:
   push AX
   push BX
   push CX
   push DX
   mov CL,0C
   mov BX,AX
   shr BX,CL
   and BL,0F
   add BL,30
   cmp BL,3A
   jl L20c16990
   add BL,07
L20c16990:
   mov [CS:offset Y20c10005],BL
   mov CL,08
   mov BX,AX
   shr BX,CL
   and BL,0F
   add BL,30
   cmp BL,3A
   jl L20c169a9
   add BL,07
L20c169a9:
   mov [CS:offset Y20c10005+01],BL
   mov CL,04
   mov BX,AX
   shr BX,CL
   and BL,0F
   add BL,30
   cmp BL,3A
   jl L20c169c2
   add BL,07
L20c169c2:
   mov [CS:offset Y20c10005+02],BL
   mov CL,00
   mov BX,AX
   shr BX,CL
   and BL,0F
   add BL,30
   cmp BL,3A
   jl L20c169db
   add BL,07
L20c169db:
   mov [CS:offset Y20c10005+03],BL
   mov [CS:offset Y20c10005+04],CL
   mov SI,offset Y20c10005
   call near B20c1695d
   pop DX
   pop CX
   pop BX
   pop AX
ret near

Segment 2760 ;; WRX_SHEL
_WORX_CALL: ;; 27600000
   push BP
   mov BP,SP
   sub SP,+18
   mov AX,[BP+0C]
   mov [BP-08],AX
   mov AL,[BP+08]
   mov [BP-18],AL
   mov AL,[BP+06]
   mov [BP-17],AL
   mov AX,[BP+0A]
   mov [BP-16],AX
   mov AX,[BP+0E]
   mov [BP-0E],AX
   push SS
   lea AX,[BP-08]
   push AX
   push SS
   lea AX,[BP-18]
   push AX
   push SS
   lea AX,[BP-18]
   push AX
   mov AX,0063
   push AX
   call far _int86x
   add SP,+0E
   mov AX,[BP-18]
   mov [offset _WORX_AX],AX
   mov AX,[BP-08]
   mov [offset _WORX_ES],AX
   mov AX,[BP-16]
   mov [offset _WORX_BX],AX
   mov AX,[BP-12]
   mov [offset _WORX_DX],AX
   mov AX,[BP-0E]
   mov [offset _WORX_DI],AX
   mov AX,[offset _WORX_AX]
jmp near L27600062
L27600062:
   mov SP,BP
   pop BP
ret far

_CloseWorx: ;; 27600066
   push BP
   mov BP,SP
   call far _CORE_CLOSEWORX
   pop BP
ret far

_GetMIDIBeat: ;; 27600070 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,2D
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L2760008b
L2760008b:
   pop BP
ret far

_ContinueSequence: ;; 2760008d ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,1F
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_SetAudioMode: ;; 276000a8 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[BP+06]
   push AX
   mov AL,13
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_LoadIBKFile: ;; 276000c4 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+04
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _LoadOneShot
   nop
   pop CX
   pop CX
   mov [BP-04],AX
   mov [BP-02],DX
   mov AX,[BP-04]
   or AX,[BP-02]
   jnz L276000ec
   mov AX,FFFF
jmp near L27600106
X276000ea:
jmp near L27600102
L276000ec:
   push [BP-04]
   push [BP-02]
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,39
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
L27600102:
   xor AX,AX
jmp near L27600106
L27600106:
   mov SP,BP
   pop BP
ret far

_EnableExtenderMode: ;; 2760010a ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,31
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_SetMIDISpeaker: ;; 27600125 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[BP+06]
   push AX
   mov AL,16
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_ResetMPU401: ;; 27600141 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,38
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L2760015c
L2760015c:
   pop BP
ret far

_SetMasterVolume: ;; 2760015e
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[BP+06]
   mov AH,00
   mov CL,04
   shl AX,CL
   mov DL,[BP+08]
   mov DH,00
   or AX,DX
   push AX
   mov AL,00
   push AX
   mov AL,20
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L27600187
L27600187:
   pop BP
ret far

_GetLastVOCMarker: ;; 27600189 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,27
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L276001a4
L276001a4:
   pop BP
ret far

_SetVOCIndex: ;; 276001a6 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push [BP+06]
   mov AL,00
   push AX
   mov AL,28
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_SetVOCVolume: ;; 276001c1 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[BP+06]
   mov AH,00
   mov CL,04
   shl AX,CL
   mov DL,[BP+08]
   mov DH,00
   or AX,DX
   push AX
   mov AL,00
   push AX
   mov AL,21
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L276001ea
L276001ea:
   pop BP
ret far

_SetFMVolume: ;; 276001ec
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[BP+06]
   mov AH,00
   mov CL,04
   shl AX,CL
   mov DL,[BP+08]
   mov DH,00
   or AX,DX
   push AX
   mov AL,00
   push AX
   mov AL,22
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L27600215
L27600215:
   pop BP
ret far

_JoyStickUpdate: ;; 27600217 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,29
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_JoyStickButton: ;; 27600232 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[BP+06]
   push AX
   mov AL,2C
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L2760024e
L2760024e:
   pop BP
ret far

_JoyStickX: ;; 27600250 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,2A
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L2760026b
L2760026b:
   pop BP
ret far

_JoyStickY: ;; 2760026d ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,2B
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L27600288
L27600288:
   pop BP
ret far

_AdlibDetect: ;; 2760028a
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,23
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L276002a5
L276002a5:
   pop BP
ret far

_DSPPortSetting: ;; 276002a7 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,37
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L276002c2
L276002c2:
   pop BP
ret far

_DSPClose: ;; 276002c4
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,04
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_DSPReset: ;; 276002df
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,01
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L276002fa
L276002fa:
   pop BP
ret far

_ElementGets: ;; 276002fc ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+06]
   push [BP+08]
   xor AX,AX
   push AX
   mov AL,[BP+0A]
   push AX
   mov AL,1A
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   les BX,[BP+06]
   cmp byte ptr [ES:BX],00
   jnz L27600327
   xor DX,DX
   xor AX,AX
jmp near L2760032f
X27600325:
jmp near L2760032f
L27600327:
   mov DX,[BP+08]
   mov AX,[BP+06]
jmp near L2760032f
L2760032f:
   pop BP
ret far

_ElementRead: ;; 27600331
   push BP
   mov BP,SP
   push SI
   push [BP+06]
   push [BP+08]
   push [BP+0A]
   mov AL,00
   push AX
   mov AL,18
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   mov SI,AX
   cmp SI,-01
   jnz L27600358
   xor AX,AX
jmp near L2760035d
X27600356:
jmp near L2760035d
L27600358:
   mov AX,[offset _WORX_AX]
jmp near L2760035d
L2760035d:
   pop SI
   pop BP
ret far

_ForceConfig: ;; 27600360 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push [BP+06]
   mov AL,[BP+08]
   push AX
   mov AL,02
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L2760037c
L2760037c:
   pop BP
ret far

_GetSequence: ;; 2760037e
   push BP
   mov BP,SP
   sub SP,+08
   mov word ptr [BP-04],0000
   mov word ptr [BP-02],0000
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _OpenElement
   nop
   pop CX
   pop CX
   mov [BP-08],AX
   mov [BP-06],DX
   cmp word ptr [BP-06],+00
   jl L276003ea
   jg L276003af
   cmp word ptr [BP-08],+00
   jbe L276003ea
L276003af:
   xor AX,AX
   push AX
   push [BP-08]
   call far _farmalloc
   pop CX
   pop CX
   mov [BP-04],AX
   mov [BP-02],DX
   mov AX,[BP-04]
   or AX,[BP-02]
   jnz L276003d0
   xor DX,DX
   xor AX,AX
jmp near L276003f8
L276003d0:
   push [BP-08]
   push [BP-02]
   push [BP-04]
   push CS
   call near offset _ElementRead
   add SP,+06
   mov [BP-08],AX
   mov word ptr [BP-06],0000
jmp near L276003f0
L276003ea:
   xor DX,DX
   xor AX,AX
jmp near L276003f8
L276003f0:
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L276003f8
L276003f8:
   mov SP,BP
   pop BP
ret far

_GoNote: ;; 276003fc ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[BP+08]
   mov AH,00
   mov CL,08
   shl AX,CL
   mov DL,[BP+0A]
   mov DH,00
   or AX,DX
   push AX
   mov AL,[BP+06]
   push AX
   mov AL,10
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_LoadOneShot: ;; 27600426
   push BP
   mov BP,SP
   sub SP,+08
   mov word ptr [BP-04],0000
   mov word ptr [BP-02],0000
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _OpenElement
   nop
   pop CX
   pop CX
   mov [BP-08],AX
   mov [BP-06],DX
   cmp word ptr [BP-06],+00
   jl L2760048a
   jg L27600457
   cmp word ptr [BP-08],+00
   jbe L2760048a
L27600457:
   xor AX,AX
   push AX
   push [BP-08]
   call far _farmalloc
   pop CX
   pop CX
   mov [BP-04],AX
   mov [BP-02],DX
   mov AX,[BP-04]
   or AX,[BP-02]
   jnz L27600478
   xor DX,DX
   xor AX,AX
jmp near L27600498
L27600478:
   push [BP-08]
   push [BP-02]
   push [BP-04]
   push CS
   call near offset _ElementRead
   add SP,+06
jmp near L27600490
L2760048a:
   xor DX,DX
   xor AX,AX
jmp near L27600498
L27600490:
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L27600498
L27600498:
   mov SP,BP
   pop BP
ret far

_LoadSBIFile: ;; 2760049c ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,0084
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _OpenElement
   nop
   pop CX
   pop CX
   mov [BP-04],AX
   mov [BP-02],DX
   cmp word ptr [BP-02],+00
   jl L276004ee
   jg L276004c4
   cmp word ptr [BP-04],+00
   jbe L276004ee
L276004c4:
   push [BP-04]
   push SS
   lea AX,[BP-0084]
   push AX
   push CS
   call near offset _ElementRead
   add SP,+06
   lea AX,[BP-0084]
   push AX
   push SS
   mov AL,[BP+0A]
   cbw
   push AX
   mov AL,00
   push AX
   mov AL,0F
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L276004f3
L276004ee:
   mov AX,FFFF
jmp near L276004f7
L276004f3:
   xor AX,AX
jmp near L276004f7
L276004f7:
   mov SP,BP
   pop BP
ret far

_OpenElement: ;; 276004fb
   push BP
   mov BP,SP
   push [BP+06]
   push [BP+08]
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,17
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   mov DX,[offset _WORX_DX]
   xor AX,AX
   add AX,[offset _WORX_AX]
   adc DX,+00
jmp near L27600523
L27600523:
   pop BP
ret far

_PlayPWMBlock: ;; 27600525 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L27600535
   mov AX,FFFF
jmp near L2760054d
L27600535:
   push [BP+06]
   push [BP+08]
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,1B
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L2760054d
L2760054d:
   pop BP
ret far

_PlayVOCBlock: ;; 2760054f
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L2760055f
   mov AX,FFFF
jmp near L27600577
L2760055f:
   push [BP+06]
   push [BP+08]
   push [BP+0A]
   mov AL,00
   push AX
   mov AL,06
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L27600577
L27600577:
   pop BP
ret far

_PlayWAVBlock: ;; 27600579 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L27600589
   mov AX,FFFF
jmp near L276005a1
L27600589:
   push [BP+06]
   push [BP+08]
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,3A
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L276005a1
L276005a1:
   pop BP
ret far

_PlayCMFBlock: ;; 276005a3
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L276005b0
jmp near L276005c6
L276005b0:
   push [BP+06]
   push [BP+08]
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,1E
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
L276005c6:
   pop BP
ret far

_PlayMIDBlock: ;; 276005c8 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L276005d5
jmp near L276005eb
L276005d5:
   push [BP+06]
   push [BP+08]
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,0C
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
L276005eb:
   pop BP
ret far

_PlayVOCFile: ;; 276005ed ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+06]
   push [BP+08]
   push [BP+0A]
   mov AL,00
   push AX
   mov AL,05
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L27600608
L27600608:
   pop BP
ret far

_PlayWAVFile: ;; 2760060a ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+06]
   push [BP+08]
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,3B
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L27600625
L27600625:
   pop BP
ret far

_ProgramChange: ;; 27600627 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AX,[BP+08]
   and AX,00FF
   push AX
   mov AL,[BP+06]
   push AX
   mov AL,12
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_ResetRealTime: ;; 27600647 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,0A
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_SequencePlaying: ;; 27600662 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,0E
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L2760067d
L2760067d:
   pop BP
ret far

_SetLoopMode: ;; 2760067f
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push [BP+06]
   mov AL,00
   push AX
   mov AL,1D
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_SetRealTime: ;; 2760069a ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push [BP+06]
   mov AL,00
   push AX
   mov AL,09
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L276006b5
L276006b5:
   pop BP
ret far

_StartResource: ;; 276006b7 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+06]
   push [BP+08]
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,14
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   mov AX,[offset _WORX_AX]
jmp near L276006d5
L276006d5:
   pop BP
ret far

_StartWorx: ;; 276006d7
   push BP
   mov BP,SP
   call far _CORE_STARTWORX
   pop BP
ret far

_StopNote: ;; 276006e1 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[BP+08]
   mov AH,00
   and AX,00FF
   mov CL,08
   shl AX,CL
   push AX
   mov AL,[BP+06]
   push AX
   mov AL,11
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_StopSequence: ;; 27600707
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,0D
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_StopVOC: ;; 27600722 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,07
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_StopPWM: ;; 2760073d ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,15
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_TimerDone: ;; 27600758 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,0B
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L27600773
L27600773:
   pop BP
ret far

_VOCPlaying: ;; 27600775
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,08
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L27600790
L27600790:
   pop BP
ret far

_PWMPlaying: ;; 27600792 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,1C
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L276007ad
L276007ad:
   pop BP
ret far

_CloseWorxDriver: ;; 276007af ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push CS
   call near offset _DSPClose
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,25
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   pop BP
ret far

_StartPoly: ;; 276007ce ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push SI
   mov SI,FFFF
   push CS
   call near offset _DSPReset
   mov SI,AX
   or SI,SI
   jle L276007f3
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push SI
   mov AL,00
   push AX
   mov AL,32
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
L276007f3:
   mov AX,SI
jmp near L276007f7
L276007f7:
   pop SI
   pop BP
ret far

_ClosePoly: ;; 276007fa ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,00
   push AX
   mov AL,34
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   push CS
   call near offset _DSPClose
   pop BP
ret far

_PlaySMPBlock: ;; 27600819 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+06]
   push [BP+08]
   xor AX,AX
   push AX
   mov AL,[BP+0A]
   push AX
   mov AL,33
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AX,[BP+0A]
   mov CL,08
   shl AX,CL
   or AX,[BP+0C]
   push AX
   mov AL,00
   push AX
   mov AL,35
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
   xor AX,AX
jmp near L27600855
L27600855:
   pop BP
ret far

_PolyCellStatus: ;; 27600857 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[BP+06]
   push AX
   mov AL,36
   push AX
   push CS
   call near offset _WORX_CALL
   add SP,+0A
jmp near L27600873
L27600873:
   pop BP
ret far

;; === Compiler Library Modules ===
Segment 27e7 ;; IOERROR
__IOERROR: ;; 27e70005
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   or SI,SI
   jl L27e70024
   cmp SI,+58
   jbe L27e70018
L27e70015:
   mov SI,0057
L27e70018:
   mov [offset __doserrno],SI
   mov AL,[SI+offset __dosErrorToSV]
   cbw
   xchg SI,AX
jmp near L27e70031
L27e70024:
   neg SI
   cmp SI,+23
   ja L27e70015
   mov word ptr [offset __doserrno],FFFF
L27e70031:
   mov AX,SI
   mov [offset _errno],AX
   mov AX,FFFF
jmp near L27e7003b
L27e7003b:
   pop SI
   pop BP
ret far 0002

Segment 27eb ;; EXIT, SETARGV, SETENVP
A27eb0000:
ret far

_exit: ;; 27eb0001
   push BP
   mov BP,SP
jmp near L27eb0012
L27eb0006:
   mov BX,[offset __atexitcnt]
   shl BX,1
   shl BX,1
   call far [BX+offset __atexittbl]
L27eb0012:
   mov AX,[offset __atexitcnt]
   dec word ptr [offset __atexitcnt]
   or AX,AX
   jnz L27eb0006
   call far [offset __exitbuf]
   call far [offset __exitfopen]
   call far [offset __exitopen]
   push [BP+06]
   call far __exit
   pop CX
   pop BP
ret far

Segment 27ee ;; ATEXIT
_atexit: ;; 27ee0004 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   cmp word ptr [offset __atexitcnt],+20
   jnz L27ee0013
   mov AX,0001
jmp near L27ee0031
L27ee0013:
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov BX,[offset __atexitcnt]
   shl BX,1
   shl BX,1
   mov [BX+offset __atexittbl+02],DX
   mov [BX+offset __atexittbl],AX
   inc word ptr [offset __atexitcnt]
   xor AX,AX
jmp near L27ee0031
L27ee0031:
   pop BP
ret far

Segment 27f1 ;; FMALLOC
;; (@) Unnamed far routines accessed by near calls: A27f10080 A27f10130 A27f1019e
_malloc: ;; 27f10003
   push BP
   mov BP,SP
   mov AX,[BP+06]
   xor DX,DX
   push DX
   push AX
   call far _farmalloc
   mov SP,BP
jmp near L27f10016
L27f10016:
   pop BP
ret far

__pull_free_block: ;; 27f10018
   push BP
   mov BP,SP
   sub SP,+04
   les BX,[BP+06]
   mov DX,[ES:BX+0E]
   mov AX,[ES:BX+0C]
   mov [offset __rover+02],DX
   mov [offset __rover],AX
   mov CX,[BP+08]
   mov BX,[BP+06]
   call far PCMP@
   jnz L27f1004b
   mov word ptr [offset __rover+02],0000
   mov word ptr [offset __rover],0000
jmp near L27f1007c
L27f1004b:
   les BX,[BP+06]
   les BX,[ES:BX+08]
   mov [BP-02],ES
   mov [BP-04],BX
   mov DX,[BP-02]
   mov AX,[BP-04]
   les BX,[offset __rover]
   mov [ES:BX+0A],DX
   mov [ES:BX+08],AX
   mov DX,[offset __rover+02]
   mov AX,[offset __rover]
   les BX,[BP-04]
   mov [ES:BX+0E],DX
   mov [ES:BX+0C],AX
L27f1007c:
   mov SP,BP
   pop BP
ret far

A27f10080:
   push BP
   mov BP,SP
   sub SP,+04
   mov DX,[BP+0C]
   mov AX,[BP+0A]
   les BX,[BP+06]
   sub [ES:BX],AX
   sbb [ES:BX+02],DX
   les BX,[BP+06]
   mov CX,[ES:BX+02]
   mov BX,[ES:BX]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far PADD@
   mov [BP-02],DX
   mov [BP-04],AX
   mov DX,[BP+0C]
   mov AX,[BP+0A]
   add AX,0001
   adc DX,+00
   les BX,[BP-04]
   mov [ES:BX+02],DX
   mov [ES:BX],AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   les BX,[BP-04]
   mov [ES:BX+06],DX
   mov [ES:BX+04],AX
   mov CX,[BP+08]
   mov BX,[BP+06]
   mov DX,[offset __last+02]
   mov AX,[offset __last]
   call far PCMP@
   jnz L27f100f9
   les BX,[BP-04]
   mov [offset __last+02],ES
   mov [offset __last],BX
jmp near L27f10121
L27f100f9:
   mov DX,[BP-02]
   mov AX,[BP-04]
   mov CX,[BP+0C]
   mov BX,[BP+0A]
   call far PADD@
   mov [BP+08],DX
   mov [BP+06],AX
   mov DX,[BP-02]
   mov AX,[BP-04]
   les BX,[BP+06]
   mov [ES:BX+06],DX
   mov [ES:BX+04],AX
L27f10121:
   mov DX,[BP-02]
   mov AX,[BP-04]
   add AX,0008
jmp near L27f1012c
L27f1012c:
   mov SP,BP
   pop BP
ret far

A27f10130:
   push BP
   mov BP,SP
   sub SP,+04
   push [BP+08]
   push [BP+06]
   call far __sbrk
   pop CX
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   cmp word ptr [BP-02],-01
   jnz L27f1015b
   cmp word ptr [BP-04],-01
   jnz L27f1015b
   xor DX,DX
   xor AX,AX
jmp near L27f1019a
L27f1015b:
   mov DX,[offset __last+02]
   mov AX,[offset __last]
   les BX,[BP-04]
   mov [ES:BX+06],DX
   mov [ES:BX+04],AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0001
   adc DX,+00
   les BX,[BP-04]
   mov [ES:BX+02],DX
   mov [ES:BX],AX
   les BX,[BP-04]
   mov [offset __last+02],ES
   mov [offset __last],BX
   mov DX,[offset __last+02]
   mov AX,[offset __last]
   add AX,0008
jmp near L27f1019a
L27f1019a:
   mov SP,BP
   pop BP
ret far

A27f1019e:
   push BP
   mov BP,SP
   sub SP,+04
   push [BP+08]
   push [BP+06]
   call far __sbrk
   pop CX
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   cmp word ptr [BP-02],-01
   jnz L27f101c9
   cmp word ptr [BP-04],-01
   jnz L27f101c9
   xor DX,DX
   xor AX,AX
jmp near L27f10200
L27f101c9:
   les BX,[BP-04]
   mov [offset __first+02],ES
   mov [offset __first],BX
   les BX,[BP-04]
   mov [offset __last+02],ES
   mov [offset __last],BX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0001
   adc DX,+00
   les BX,[BP-04]
   mov [ES:BX+02],DX
   mov [ES:BX],AX
   mov DX,[BP-02]
   mov AX,[BP-04]
   add AX,0008
jmp near L27f10200
L27f10200:
   mov SP,BP
   pop BP
ret far

_farmalloc: ;; 27f10204
   push BP
   mov BP,SP
   sub SP,+04
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L27f10219
   xor DX,DX
   xor AX,AX
jmp near L27f1030f
L27f10219:
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0017
   adc DX,+00
   and AX,FFF0
   and DX,FFFF
   mov [BP+08],DX
   mov [BP+06],AX
   xor CX,CX
   xor BX,BX
   mov DX,[offset __first+02]
   mov AX,[offset __first]
   call far PCMP@
   jnz L27f10253
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A27f1019e
   pop CX
   pop CX
jmp near L27f1030f
L27f10253:
   mov DX,[offset __rover+02]
   mov AX,[offset __rover]
   mov [BP-02],DX
   mov [BP-04],AX
   xor CX,CX
   xor BX,BX
   call far PCMP@
   jnz L27f1026e
jmp near L27f10301
L27f1026e:
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   mov CX,[BP+08]
   mov BX,[BP+06]
   add BX,+30
   adc CX,+00
   cmp DX,CX
   jb L27f102a3
   jnz L27f1028e
   cmp AX,BX
   jb L27f102a3
L27f1028e:
   push [BP+08]
   push [BP+06]
   push [BP-02]
   push [BP-04]
   push CS
   call near offset A27f10080
   add SP,+08
jmp near L27f1030f
L27f102a3:
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   cmp DX,[BP+08]
   jb L27f102dc
   jnz L27f102b9
   cmp AX,[BP+06]
   jb L27f102dc
L27f102b9:
   push [BP-02]
   push [BP-04]
   push CS
   call near offset __pull_free_block
   pop CX
   pop CX
   les BX,[BP-04]
   add word ptr [ES:BX],+01
   adc word ptr [ES:BX+02],+00
   mov DX,[BP-02]
   mov AX,[BP-04]
   add AX,0008
jmp near L27f1030f
L27f102dc:
   les BX,[BP-04]
   les BX,[ES:BX+0C]
   mov [BP-02],ES
   mov [BP-04],BX
   mov CX,[offset __rover+02]
   mov BX,[offset __rover]
   mov DX,[BP-02]
   mov AX,[BP-04]
   call far PCMP@
   jz L27f10301
jmp near L27f1026e
L27f10301:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A27f10130
   pop CX
   pop CX
jmp near L27f1030f
L27f1030f:
   mov SP,BP
   pop BP
ret far

Segment 2822 ;; FBRK, PADD, PCMP
;; (@) Unnamed near calls: B28220003
B28220003:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   inc SI
   sub SI,[offset __psp]
   mov AX,SI
   add AX,003F
   mov CL,06
   shr AX,CL
   mov SI,AX
   cmp SI,[offset Y2a172a56]
   jnz L28220031
   les BX,[BP+04]
   mov [offset __brklvl+02],ES
   mov [offset __brklvl],BX
   mov AX,0001
jmp near L2822008d
L28220031:
   mov CL,06
   shl SI,CL
   mov DI,[offset __heaptop+02]
   mov AX,SI
   add AX,[offset __psp]
   cmp AX,DI
   jbe L28220049
   mov SI,DI
   sub SI,[offset __psp]
L28220049:
   push SI
   push [offset __psp]
   call far _setblock
   pop CX
   pop CX
   mov DI,AX
   cmp DI,-01
   jnz L28220077
   mov AX,SI
   mov CL,06
   shr AX,CL
   mov [offset Y2a172a56],AX
   les BX,[BP+04]
   mov [offset __brklvl+02],ES
   mov [offset __brklvl],BX
   mov AX,0001
jmp near L2822008d
X28220075:
jmp near L2822008d
L28220077:
   mov AX,[offset __psp]
   add AX,DI
   xor DX,DX
   mov DX,AX
   xor AX,AX
   mov [offset __heaptop+02],DX
   mov [offset __heaptop],AX
   xor AX,AX
jmp near L2822008d
L2822008d:
   pop DI
   pop SI
   pop BP
ret near 0004

__brk: ;; 28220093
   push BP
   mov BP,SP
   mov CX,[offset __heapbase+02]
   mov BX,[offset __heapbase]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far PCMP@
   jb L282200cd
   mov CX,[offset __heaptop+02]
   mov BX,[offset __heaptop]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far PCMP@
   ja L282200cd
   push [BP+08]
   push [BP+06]
   call near B28220003
   or AX,AX
   jnz L282200d4
L282200cd:
   mov AX,FFFF
jmp near L282200d8
X282200d2:
jmp near L282200d8
L282200d4:
   xor AX,AX
jmp near L282200d8
L282200d8:
   pop BP
ret far

__sbrk: ;; 282200da
   push BP
   mov BP,SP
   sub SP,+08
   mov DX,[offset __brklvl+02]
   mov AX,[offset __brklvl]
   mov CX,[BP+08]
   mov BX,[BP+06]
   call far PADD@
   mov [BP-06],DX
   mov [BP-08],AX
   mov CX,[offset __heapbase+02]
   mov BX,[offset __heapbase]
   mov DX,[BP-06]
   mov AX,[BP-08]
   call far PCMP@
   jb L28220122
   mov CX,[offset __heaptop+02]
   mov BX,[offset __heaptop]
   mov DX,[BP-06]
   mov AX,[BP-08]
   call far PCMP@
   jbe L2822012a
L28220122:
   mov DX,FFFF
   mov AX,FFFF
jmp near L28220151
L2822012a:
   les BX,[offset __brklvl]
   mov [BP-02],ES
   mov [BP-04],BX
   push [BP-06]
   push [BP-08]
   call near B28220003
   or AX,AX
   jnz L28220149
   mov DX,FFFF
   mov AX,FFFF
jmp near L28220151
L28220149:
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L28220151
L28220151:
   mov SP,BP
   pop BP
ret far

Segment 2837 ;; SETBLOCK, CTYPE
_setblock: ;; 28370005
   push BP
   mov BP,SP
   mov AH,4A
   mov BX,[BP+08]
   mov ES,[BP+06]
   int 21
   jb L28370019
   mov AX,FFFF
jmp near L28370023
L28370019:
   push BX
   push AX
   call far __IOERROR
   pop AX
jmp near L28370023
L28370023:
   pop BP
ret far

Segment 2839 ;; OPEN
;; (@) Unnamed near calls: B28390005 B28390024
B28390005:
   push BP
   mov BP,SP
   push DS
   mov CX,[BP+04]
   mov AH,3C
   lds DX,[BP+06]
   int 21
   pop DS
   jb L28390018
jmp near L28390020
L28390018:
   push AX
   call far __IOERROR
jmp near L28390020
L28390020:
   pop BP
ret near 0006

B28390024:
   push BP
   mov BP,SP
   mov BX,[BP+04]
   sub CX,CX
   sub DX,DX
   mov AH,40
   int 21
jmp near L28390034
L28390034:
   pop BP
ret near 0002

_open: ;; 28390038
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov DI,[BP+0A]
   test DI,C000
   jnz L28390051
   mov AX,[offset __fmode]
   and AX,C000
   or DI,AX
L28390051:
   test DI,0100
   jnz L2839005a
jmp near L283900f9
L2839005a:
   mov AX,[offset __notUmask]
   and [BP+0C],AX
   mov AX,[BP+0C]
   test AX,0180
   jnz L28390071
   mov AX,0001
   push AX
   call far __IOERROR
L28390071:
   xor AX,AX
   push AX
   push [BP+08]
   push [BP+06]
   call far __chmod
   add SP,+06
   mov [BP-04],AX
   cmp AX,FFFF
   jnz L2839009d
   test word ptr [BP+0C],0080
   jz L28390095
   xor AX,AX
jmp near L28390098
L28390095:
   mov AX,0001
L28390098:
   mov [BP-04],AX
jmp near L283900b3
L2839009d:
   test DI,0400
   jz L283900b1
   mov AX,0050
   push AX
   call far __IOERROR
jmp near L2839019f
X283900af:
jmp near L283900b3
L283900b1:
jmp near L283900f9
L283900b3:
   test DI,00F0
   jz L283900dd
   push [BP+08]
   push [BP+06]
   xor AX,AX
   push AX
   call near B28390005
   mov SI,AX
   mov AX,SI
   or AX,AX
   jge L283900d2
   mov AX,SI
jmp near L2839019f
L283900d2:
   push SI
   call far __close
   pop CX
jmp near L283900fe
X283900db:
jmp near L283900f6
L283900dd:
   push [BP+08]
   push [BP+06]
   push [BP-04]
   call near B28390005
   mov SI,AX
   mov AX,SI
   or AX,AX
   jge L283900f6
   mov AX,SI
jmp near L2839019f
L283900f6:
jmp near L2839017a
L283900f9:
   mov word ptr [BP-04],0000
L283900fe:
   push DI
   push [BP+08]
   push [BP+06]
   call far __open
   add SP,+06
   mov SI,AX
   mov AX,SI
   or AX,AX
   jl L2839017a
   xor AX,AX
   push AX
   push SI
   call far _ioctl
   pop CX
   pop CX
   mov [BP-02],AX
   test AX,0080
   jz L2839014e
   or DI,2000
   test DI,8000
   jz L2839014c
   mov AX,[BP-02]
   and AX,00FF
   or AX,0020
   xor DX,DX
   push DX
   push AX
   mov AX,0001
   push AX
   push SI
   call far _ioctl
   add SP,+08
L2839014c:
jmp near L28390158
L2839014e:
   test DI,0200
   jz L28390158
   push SI
   call near B28390024
L28390158:
   cmp word ptr [BP-04],+00
   jz L2839017a
   test DI,00F0
   jz L2839017a
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   push [BP+08]
   push [BP+06]
   call far __chmod
   add SP,+08
L2839017a:
   or SI,SI
   jl L2839019b
   test DI,0300
   jz L28390189
   mov AX,1000
jmp near L2839018b
L28390189:
   xor AX,AX
L2839018b:
   mov DX,DI
   and DX,F8FF
   or AX,DX
   mov BX,SI
   shl BX,1
   mov [BX+offset __openfd],AX
L2839019b:
   mov AX,SI
jmp near L2839019f
L2839019f:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 2853 ;; OPENA, FILES2, FMODE
__open: ;; 28530005
   push BP
   mov BP,SP
   push SI
   mov AL,01
   mov CX,[BP+0A]
   test CX,0002
   jnz L2853001e
   mov AL,02
   test CX,0004
   jnz L2853001e
   mov AL,00
L2853001e:
   push DS
   lds DX,[BP+06]
   mov CL,F0
   and CL,[BP+0A]
   or AL,CL
   mov AH,3D
   int 21
   pop DS
   jb L28530047
   mov SI,AX
   mov AX,[BP+0A]
   and AX,F8FF
   or AX,8000
   mov BX,SI
   shl BX,1
   mov [BX+offset __openfd],AX
   mov AX,SI
jmp near L2853004f
L28530047:
   push AX
   call far __IOERROR
jmp near L2853004f
L2853004f:
   pop SI
   pop BP
ret far

Segment 2858 ;; IOCTL
_ioctl: ;; 28580002
   push BP
   mov BP,SP
   push DS
   mov AH,44
   mov AL,[BP+08]
   mov BX,[BP+06]
   mov CX,[BP+0E]
   lds DX,[BP+0A]
   int 21
   pop DS
   jb L28580025
   cmp word ptr [BP+08],+00
   jnz L28580023
   mov AX,DX
jmp near L2858002d
L28580023:
jmp near L2858002d
L28580025:
   push AX
   call far __IOERROR
jmp near L2858002d
L2858002d:
   pop BP
ret far

Segment 285a ;; CLOSE
_close: ;; 285a000f
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   or SI,SI
   jl L285a001f
   cmp SI,+14
   jl L285a002a
L285a001f:
   mov AX,0006
   push AX
   call far __IOERROR
jmp near L285a003d
L285a002a:
   mov BX,SI
   shl BX,1
   mov word ptr [BX+offset __openfd],FFFF
   push SI
   call far __close
   pop CX
jmp near L285a003d
L285a003d:
   pop SI
   pop BP
ret far

Segment 285e ;; CLOSEA
__close: ;; 285e0000
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AH,3E
   mov BX,SI
   int 21
   jb L285e001b
   shl BX,1
   mov word ptr [BX+offset __openfd],FFFF
   xor AX,AX
jmp near L285e0023
L285e001b:
   push AX
   call far __IOERROR
jmp near L285e0023
L285e0023:
   pop SI
   pop BP
ret far

Segment 2860 ;; READ
_read: ;; 28600006
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov AX,[BP+0C]
   inc AX
   cmp AX,0002
   jb L28600024
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+offset __openfd],0200
   jz L28600029
L28600024:
   xor AX,AX
jmp near L286000c5
L28600029:
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far __read
   add SP,+08
   mov [BP-04],AX
   mov AX,[BP-04]
   inc AX
   cmp AX,0002
   jb L28600056
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+offset __openfd],8000
   jz L2860005c
L28600056:
   mov AX,[BP-04]
jmp near L286000c5
X2860005b:
   nop
L2860005c:
   mov CX,[BP-04]
   les SI,[BP+08]
   mov DI,SI
   mov BX,SI
   cld
L28600067:
   ES:lodsb
   cmp AL,1A
   jz L2860009d
   cmp AL,0D
   jz L28600076
   stosb
   loop L28600067
jmp near L28600095
L28600076:
   loop L28600067
   push ES
   push BX
   mov AX,0001
   push AX
   lea AX,[BP-01]
   push SS
   push AX
   push [BP+06]
   call far __read
   add SP,+08
   pop BX
   pop ES
   cld
   mov AL,[BP-01]
   stosb
L28600095:
   cmp DI,BX
   jnz L2860009b
jmp near L28600029
L2860009b:
jmp near L286000bf
L2860009d:
   push BX
   mov AX,0002
   push AX
   neg CX
   sbb AX,AX
   push AX
   push CX
   push [BP+06]
   call far _lseek
   add SP,+08
   mov BX,[BP+06]
   shl BX,1
   or word ptr [BX+offset __openfd],0200
   pop BX
L286000bf:
   mov AX,DI
   sub AX,BX
jmp near L286000c5
L286000c5:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 286c ;; READA
__read: ;; 286c000b
   push BP
   mov BP,SP
   push DS
   mov AH,3F
   mov BX,[BP+06]
   mov CX,[BP+0C]
   lds DX,[BP+08]
   int 21
   pop DS
   jb L286c0021
jmp near L286c0029
L286c0021:
   push AX
   call far __IOERROR
jmp near L286c0029
L286c0029:
   pop BP
ret far

Segment 286e ;; WRITE
_write: ;; 286e000b
   push BP
   mov BP,SP
   sub SP,008E
   push SI
   push DI
   mov AX,[BP+0C]
   inc AX
   cmp AX,0002
   jnb L286e0022
   xor AX,AX
jmp near L286e016b
L286e0022:
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+offset __openfd],8000
   jz L286e0046
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far __write
   add SP,+08
jmp near L286e016b
L286e0046:
   mov BX,[BP+06]
   shl BX,1
   and word ptr [BX+offset __openfd],FDFF
   les BX,[BP+08]
   mov [BP-0084],ES
   mov [BP-0086],BX
   mov AX,[BP+0C]
   mov [BP-008a],AX
   mov BX,SS
   mov ES,BX
   lea BX,[BP-0082]
   mov [BP-008c],ES
   mov [BP-008e],BX
jmp near L286e0117
L286e0076:
   dec word ptr [BP-008a]
   les BX,[BP-0086]
   inc word ptr [BP-0086]
   mov AL,[ES:BX]
   mov [BP-0087],AL
   cmp AL,0A
   jnz L286e0099
   les BX,[BP-008e]
   mov byte ptr [ES:BX],0D
   inc word ptr [BP-008e]
L286e0099:
   mov AL,[BP-0087]
   les BX,[BP-008e]
   mov [ES:BX],AL
   inc word ptr [BP-008e]
   mov AX,[BP-008e]
   mov CX,SS
   lea BX,[BP-0082]
   xor DX,DX
   sub AX,BX
   sbb DX,+00
   or DX,DX
   jl L286e0117
   jnz L286e00c4
   cmp AX,0080
   jb L286e0117
L286e00c4:
   mov AX,[BP-008e]
   mov CX,SS
   lea BX,[BP-0082]
   xor DX,DX
   sub AX,BX
   sbb DX,+00
   mov SI,AX
   push SI
   push SS
   lea AX,[BP-0082]
   push AX
   push [BP+06]
   call far __write
   add SP,+08
   mov DI,AX
   mov AX,DI
   cmp AX,SI
   jz L286e0107
   or DI,DI
   jnb L286e00fa
   mov AX,FFFF
jmp near L286e0105
L286e00fa:
   mov AX,[BP+0C]
   sub AX,[BP-008a]
   add AX,DI
   sub AX,SI
L286e0105:
jmp near L286e016b
L286e0107:
   mov BX,SS
   mov ES,BX
   lea BX,[BP-0082]
   mov [BP-008c],ES
   mov [BP-008e],BX
L286e0117:
   cmp word ptr [BP-008a],+00
   jz L286e0121
jmp near L286e0076
L286e0121:
   mov AX,[BP-008e]
   mov CX,SS
   lea BX,[BP-0082]
   xor DX,DX
   sub AX,BX
   sbb DX,+00
   mov SI,AX
   mov AX,SI
   or AX,AX
   jbe L286e0166
   push SI
   push SS
   lea AX,[BP-0082]
   push AX
   push [BP+06]
   call far __write
   add SP,+08
   mov DI,AX
   mov AX,DI
   cmp AX,SI
   jz L286e0166
   or DI,DI
   jnb L286e015d
   mov AX,FFFF
jmp near L286e0164
L286e015d:
   mov AX,[BP+0C]
   add AX,DI
   sub AX,SI
L286e0164:
jmp near L286e016b
L286e0166:
   mov AX,[BP+0C]
jmp near L286e016b
L286e016b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 2885 ;; WRITEA
__write: ;; 28850001
   push BP
   mov BP,SP
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+offset __openfd],0800
   jz L28850023
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push [BP+06]
   call far _lseek
   mov SP,BP
L28850023:
   push DS
   mov AH,40
   mov BX,[BP+06]
   mov CX,[BP+0C]
   lds DX,[BP+08]
   int 21
   pop DS
   jb L28850043
   push AX
   mov BX,[BP+06]
   shl BX,1
   or word ptr [BX+offset __openfd],1000
   pop AX
jmp near L2885004b
L28850043:
   push AX
   call far __IOERROR
jmp near L2885004b
L2885004b:
   pop BP
ret far

Segment 2889 ;; LSEEK
_lseek: ;; 2889000d
   push BP
   mov BP,SP
   mov BX,[BP+06]
   shl BX,1
   and word ptr [BX+offset __openfd],FDFF
   mov AH,42
   mov AL,[BP+0C]
   mov BX,[BP+06]
   mov CX,[BP+0A]
   mov DX,[BP+08]
   int 21
   jb L2889002f
jmp near L28890038
L2889002f:
   push AX
   call far __IOERROR
   cwd
jmp near L28890038
L28890038:
   pop BP
ret far

Segment 288c ;; LTOA, LXMUL
__LONGTOA: ;; 288c000a
   push BP
   mov BP,SP
   sub SP,+22
   push SI
   push DI
   push ES
   les DI,[BP+0C]
   mov BX,[BP+0A]
   cmp BX,+24
   ja L288c007a
   cmp BL,02
   jb L288c007a
   mov AX,[BP+10]
   mov CX,[BP+12]
   or CX,CX
   jge L288c003f
   cmp byte ptr [BP+08],00
   jz L288c003f
   mov byte ptr [ES:DI],2D
   inc DI
   neg CX
   neg AX
   sbb CX,+00
L288c003f:
   lea SI,[BP-22]
   jcxz L288c0054
L288c0044:
   xchg CX,AX
   sub DX,DX
   div BX
   xchg CX,AX
   div BX
   mov [SS:SI],DL
   inc SI
   jcxz L288c005c
jmp near L288c0044
L288c0054:
   sub DX,DX
   div BX
   mov [SS:SI],DL
   inc SI
L288c005c:
   or AX,AX
   jnz L288c0054
   lea CX,[BP-22]
   neg CX
   add CX,SI
   cld
L288c0068:
   dec SI
   mov AL,[SS:SI]
   sub AL,0A
   jnb L288c0074
   add AL,3A
jmp near L288c0077
L288c0074:
   add AL,[BP+06]
L288c0077:
   stosb
   loop L288c0068
L288c007a:
   mov AL,00
   stosb
   pop ES
   mov DX,[BP+0E]
   mov AX,[BP+0C]
jmp near L288c0086
L288c0086:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far 000E

_itoa: ;; 288c008e
   push BP
   mov BP,SP
   cmp word ptr [BP+0C],+0A
   jnz L288c009d
   mov AX,[BP+06]
   cwd
jmp near L288c00a2
L288c009d:
   mov AX,[BP+06]
   xor DX,DX
L288c00a2:
   push DX
   push AX
   push [BP+0A]
   push [BP+08]
   push [BP+0C]
   mov AL,01
   push AX
   mov AL,61
   push AX
   push CS
   call near offset __LONGTOA
jmp near L288c00b9
L288c00b9:
   pop BP
ret far

_ultoa: ;; 288c00bb ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0C]
   push [BP+0A]
   push [BP+0E]
   mov AL,00
   push AX
   mov AL,61
   push AX
   push CS
   call near offset __LONGTOA
jmp near L288c00d9
L288c00d9:
   pop BP
ret far

_ltoa: ;; 288c00db
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0C]
   push [BP+0A]
   push [BP+0E]
   cmp word ptr [BP+0E],+0A
   jnz L288c00f8
   mov AX,0001
jmp near L288c00fa
L288c00f8:
   xor AX,AX
L288c00fa:
   push AX
   mov AL,61
   push AX
   push CS
   call near offset __LONGTOA
jmp near L288c0104
L288c0104:
   pop BP
ret far

Segment 289c ;; UNLINK
_unlink: ;; 289c0006
   push BP
   mov BP,SP
   push DS
   mov AH,41
   lds DX,[BP+06]
   int 21
   pop DS
   jb L289c0018
   xor AX,AX
jmp near L289c0020
L289c0018:
   push AX
   call far __IOERROR
jmp near L289c0020
L289c0020:
   pop BP
ret far

Segment 289e ;; STRCAT
_strcat: ;; 289e0002
   push BP
   mov BP,SP
   push SI
   push DI
   cld
   push DS
   les DI,[BP+06]
   mov DX,DI
   xor AL,AL
   mov CX,FFFF
   repnz scasb
   push ES
   lea SI,[DI-01]
   les DI,[BP+0A]
   mov CX,FFFF
   repnz scasb
   not CX
   sub DI,CX
   push ES
   pop DS
   pop ES
   xchg SI,DI
   test SI,0001
   jz L289e0032
   movsb
   dec CX
L289e0032:
   shr CX,1
   repz movsw
   jnb L289e0039
   movsb
L289e0039:
   mov AX,DX
   mov DX,ES
   pop DS
jmp near L289e0040
L289e0040:
   pop DI
   pop SI
   pop BP
ret far

Segment 28a2 ;; STRLEN
_strlen: ;; 28a20004
   push BP
   mov BP,SP
   push SI
   push DI
   cld
   les DI,[BP+06]
   xor AL,AL
   mov CX,FFFF
   repnz scasb
   mov AX,CX
   not AX
   dec AX
jmp near L28a2001b
L28a2001b:
   pop DI
   pop SI
   pop BP
ret far

Segment 28a3 ;; STRCMP
_strcmp: ;; 28a3000f
   push BP
   mov BP,SP
   push SI
   push DI
   mov DX,DS
   cld
   xor AX,AX
   mov BX,AX
   les DI,[BP+0A]
   mov SI,DI
   xor AL,AL
   mov CX,FFFF
   repnz scasb
   not CX
   mov DI,SI
   lds SI,[BP+06]
   repz cmpsb
   mov AL,[SI-01]
   mov BL,[ES:DI-01]
   sub AX,BX
   mov DS,DX
jmp near L28a3003d
L28a3003d:
   pop DI
   pop SI
   pop BP
ret far

Segment 28a7 ;; STRCPY
_strcpy: ;; 28a70001
   push BP
   mov BP,SP
   push SI
   push DI
   cld
   les DI,[BP+0A]
   mov SI,DI
   xor AL,AL
   mov CX,FFFF
   repnz scasb
   not CX
   push DS
   push ES
   pop DS
   les DI,[BP+06]
   repz movsb
   pop DS
   mov DX,[BP+08]
   mov AX,[BP+06]
jmp near L28a70026
L28a70026:
   pop DI
   pop SI
   pop BP
ret far

Segment 28a9 ;; MEMCPY
_memcpy: ;; 28a9000a
   push BP
   mov BP,SP
   push SI
   push DI
   mov DX,DS
   les DI,[BP+06]
   lds SI,[BP+0A]
   mov CX,[BP+0E]
   shr CX,1
   cld
   repz movsw
   jnb L28a90022
   movsb
L28a90022:
   mov DS,DX
   mov DX,[BP+08]
   mov AX,[BP+06]
jmp near L28a9002c
L28a9002c:
   pop DI
   pop SI
   pop BP
ret far

Segment 28ac ;; MEMSET
_setmem: ;; 28ac0000
   push BP
   mov BP,SP
   push SI
   push DI
   les DI,[BP+06]
   mov CX,[BP+0A]
   mov AL,[BP+0C]
   mov AH,AL
   cld
   test DI,0001
   jz L28ac001b
   jcxz L28ac0022
   stosb
   dec CX
L28ac001b:
   shr CX,1
   repz stosw
   jnb L28ac0022
   stosb
L28ac0022:
   pop DI
   pop SI
   pop BP
ret far

_memset: ;; 28ac0026
   push BP
   mov BP,SP
   push [BP+0A]
   push [BP+0C]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _setmem
   mov SP,BP
   mov DX,[BP+08]
   mov AX,[BP+06]
jmp near L28ac0043
L28ac0043:
   pop BP
ret far

Segment 28b0 ;; MOVMEM
_movmem: ;; 28b00005
   push BP
   mov BP,SP
   push SI
   push DI
   push DS
   mov CX,[BP+0C]
   mov BX,[BP+0A]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far PCMP@
   jnb L28b00024
   std
   mov AX,0001
jmp near L28b00027
L28b00024:
   cld
   xor AX,AX
L28b00027:
   lds SI,[BP+06]
   les DI,[BP+0A]
   mov CX,[BP+0E]
   or AX,AX
   jz L28b0003a
   add SI,CX
   dec SI
   add DI,CX
   dec DI
L28b0003a:
   test DI,0001
   jz L28b00044
   jcxz L28b00053
   movsb
   dec CX
L28b00044:
   sub SI,AX
   sub DI,AX
   shr CX,1
   repz movsw
   jnb L28b00053
   add SI,AX
   add DI,AX
   movsb
L28b00053:
   cld
   pop DS
   pop DI
   pop SI
   pop BP
ret far

_memmove: ;; 28b00059
   push BP
   mov BP,SP
   push [BP+0E]
   push [BP+08]
   push [BP+06]
   push [BP+0C]
   push [BP+0A]
   push CS
   call near offset _movmem
   mov SP,BP
   mov DX,[BP+08]
   mov AX,[BP+06]
   pop BP
ret far

Segment 28b7 ;; CHMODA, CVTFAK, REALCVT
__chmod: ;; 28b70009
   push BP
   mov BP,SP
   push DS
   mov AH,43
   mov AL,[BP+0A]
   mov CX,[BP+0C]
   lds DX,[BP+06]
   int 21
   pop DS
   jb L28b70020
   xchg CX,AX
jmp near L28b70028
L28b70020:
   push AX
   call far __IOERROR
jmp near L28b70028
L28b70028:
   pop BP
ret far

Segment 28b9 ;; VPRINTER
;; (@) Unnamed near calls: B28b9000a B28b90049 B28b90056 B28b9005f
B28b9000a:
   push BP
   mov BP,SP
   mov DX,[BP+04]
   mov CX,0F04
   mov BX,offset Y2a172bbf
   cld
   mov AL,DH
   shr AL,CL
   xlat
   stosb
   mov AL,DH
   and AL,CH
   xlat
   stosb
   mov AL,DL
   shr AL,CL
   xlat
   stosb
   mov AL,DL
   and AL,CH
   xlat
   stosb
jmp near L28b90031
L28b90031:
   pop BP
ret near 0002

__VPRINTER: ;; 28b90035
   push BP
   mov BP,SP
   sub SP,0096
   push SI
   push DI
   mov word ptr [BP-56],0000
   mov byte ptr [BP-53],50
jmp near L28b90086

B28b90049:
   push DI
   mov CX,FFFF
   xor AL,AL
   repnz scasb
   not CX
   dec CX
   pop DI
ret near

B28b90056:
   mov [SS:DI],AL
   inc DI
   dec byte ptr [BP-53]
   jle L28b90085

B28b9005f:
   push BX
   push CX
   push DX
   push ES
   lea AX,[BP-52]
   sub DI,AX
   push SS
   lea AX,[BP-52]
   push AX
   push DI
   push [BP+10]
   push [BP+0E]
   call far [BP+12]
   mov byte ptr [BP-53],50
   add [BP-56],DI
   lea DI,[BP-52]
   pop ES
   pop DX
   pop CX
   pop BX
L28b90085:
ret near
L28b90086:
   push ES
   cld
   lea DI,[BP-52]
   mov [BP-0094],DI
L28b9008f:
   mov DI,[BP-0094]
L28b90093:
   les SI,[BP+0A]
L28b90096:
   ES:lodsb
   or AL,AL
   jz L28b900ae
   cmp AL,25
   jz L28b900b1
L28b900a0:
   mov [SS:DI],AL
   inc DI
   dec byte ptr [BP-53]
   jg L28b90096
   call near B28b9005f
jmp near L28b90096
L28b900ae:
jmp near L28b90545
L28b900b1:
   mov [BP-0088],SI
   ES:lodsb
   cmp AL,25
   jz L28b900a0
   mov [BP-0094],DI
   xor CX,CX
   mov [BP-008a],CX
   mov word ptr [BP-0096],0020
   mov [BP-008b],CL
   mov word ptr [BP-0090],FFFF
   mov word ptr [BP-008e],FFFF
jmp near L28b900df
L28b900dd:
   ES:lodsb
L28b900df:
   xor AH,AH
   mov DX,AX
   mov BX,AX
   sub BL,20
   cmp BL,60
   jnb L28b90134
   mov BL,[BX+offset Y2a172bd0-01]
   mov AX,BX
   cmp AX,0017
   jbe L28b900fb
jmp near L28b9052f
L28b900fb:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y28b90104]
Y28b90104:	dw L28b9014f,L28b90137,L28b90190,L28b90143,L28b901b8,L28b901c2,L28b90204,L28b9020e
		dw L28b9021e,L28b90176,L28b90254,L28b9022e,L28b90232,L28b90236,L28b902de,L28b90397
		dw L28b90334,L28b90356,L28b90500,L28b9052f,L28b9052f,L28b9052f,L28b90162,L28b9016c
L28b90134:
jmp near L28b9052f
L28b90137:
   cmp CH,00
   ja L28b90134
   or word ptr [BP-0096],+01
jmp near L28b900dd
L28b90143:
   cmp CH,00
   ja L28b90134
   or word ptr [BP-0096],+02
jmp near L28b900dd
L28b9014f:
   cmp CH,00
   ja L28b90134
   cmp byte ptr [BP-008b],2B
   jz L28b9015f
   mov [BP-008b],DL
L28b9015f:
jmp near L28b900dd
L28b90162:
   and word ptr [BP-0096],-21
   mov CH,05
jmp near L28b900dd
L28b9016c:
   or word ptr [BP-0096],+20
   mov CH,05
jmp near L28b900dd
L28b90176:
   cmp CH,00
   ja L28b901c2
   test word ptr [BP-0096],0002
   jnz L28b901a7
   or word ptr [BP-0096],+08
   mov CH,01
jmp near L28b900dd
L28b9018d:
jmp near L28b9052f
L28b90190:
   push ES
   les DI,[BP+06]
   mov AX,[ES:DI]
   add word ptr [BP+06],+02
   pop ES
   cmp CH,02
   jnb L28b901aa
   mov [BP-0090],AX
   mov CH,03
L28b901a7:
jmp near L28b900dd
L28b901aa:
   cmp CH,04
   jnz L28b9018d
   mov [BP-008e],AX
   inc CH
jmp near L28b900dd
L28b901b8:
   cmp CH,04
   jnb L28b9018d
   mov CH,04
jmp near L28b900dd
L28b901c2:
   xchg DX,AX
   sub AL,30
   cbw
   cmp CH,02
   ja L28b901e6
   mov CH,02
   xchg AX,[BP-0090]
   or AX,AX
   jl L28b901a7
   shl AX,1
   mov DX,AX
   shl AX,1
   shl AX,1
   add AX,DX
   add [BP-0090],AX
jmp near L28b900dd
L28b901e6:
   cmp CH,04
   jnz L28b9018d
   xchg AX,[BP-008e]
   or AX,AX
   jl L28b901a7
   shl AX,1
   mov DX,AX
   shl AX,1
   shl AX,1
   add AX,DX
   add [BP-008e],AX
jmp near L28b900dd
L28b90204:
   or word ptr [BP-0096],+10
   mov CH,05
jmp near L28b900dd
L28b9020e:
   or word ptr [BP-0096],0100
   and word ptr [BP-0096],-11
   mov CH,05
jmp near L28b900dd
L28b9021e:
   and word ptr [BP-0096],-11
   or word ptr [BP-0096],0080
   mov CH,05
jmp near L28b900dd
L28b9022e:
   mov BH,08
jmp near L28b9023c
L28b90232:
   mov BH,0A
jmp near L28b90241
L28b90236:
   mov BH,10
   mov BL,E9
   add BL,DL
L28b9023c:
   mov byte ptr [BP-008b],00
L28b90241:
   mov byte ptr [BP-0091],00
   mov [BP-0092],DL
   les DI,[BP+06]
   mov AX,[ES:DI]
   xor DX,DX
jmp near L28b90266
L28b90254:
   mov BH,0A
   mov byte ptr [BP-0091],01
   mov [BP-0092],DL
   les DI,[BP+06]
   mov AX,[ES:DI]
   cwd
L28b90266:
   inc DI
   inc DI
   mov [BP+0A],SI
   test word ptr [BP-0096],0010
   jz L28b90278
   mov DX,[ES:DI]
   inc DI
   inc DI
L28b90278:
   mov [BP+06],DI
   lea DI,[BP-0085]
   or AX,AX
   jnz L28b902b6
   or DX,DX
   jnz L28b902b6
   cmp word ptr [BP-008e],+00
   jnz L28b902bb
   mov DI,[BP-0094]
   mov CX,[BP-0090]
   jcxz L28b902b3
   cmp CX,-01
   jz L28b902b3
   mov AX,[BP-0096]
   and AX,0008
   jz L28b902aa
   mov DL,30
jmp near L28b902ac
L28b902aa:
   mov DL,20
L28b902ac:
   mov AL,DL
   call near B28b90056
   loop L28b902ac
L28b902b3:
jmp near L28b90093
L28b902b6:
   or word ptr [BP-0096],+04
L28b902bb:
   push DX
   push AX
   push SS
   push DI
   mov AL,BH
   cbw
   push AX
   mov AL,[BP-0091]
   push AX
   push BX
   call far __LONGTOA
   push SS
   pop ES
   mov DX,[BP-008e]
   or DX,DX
   jg L28b902db
jmp near L28b903fa
L28b902db:
jmp near L28b9040a
L28b902de:
   mov [BP-0092],DL
   mov [BP+0A],SI
   lea DI,[BP-0086]
   les BX,[BP+06]
   push [ES:BX]
   inc BX
   inc BX
   mov [BP+06],BX
   test word ptr [BP-0096],0020
   jz L28b9030c
   push [ES:BX]
   inc BX
   inc BX
   mov [BP+06],BX
   push SS
   pop ES
   call near B28b9000a
   mov AL,3A
   stosb
L28b9030c:
   push SS
   pop ES
   call near B28b9000a
   mov byte ptr [SS:DI],00
   mov byte ptr [BP-0091],00
   and word ptr [BP-0096],-05
   lea CX,[BP-0086]
   sub DI,CX
   xchg CX,DI
   mov DX,[BP-008e]
   cmp DX,CX
   jg L28b90331
   mov DX,CX
L28b90331:
jmp near L28b903fa
L28b90334:
   mov [BP+0A],SI
   mov [BP-0092],DL
   les DI,[BP+06]
   mov AX,[ES:DI]
   add word ptr [BP+06],+02
   push SS
   pop ES
   lea DI,[BP-0085]
   xor AH,AH
   mov [ES:DI],AX
   mov CX,0001
jmp near L28b90434
L28b90356:
   mov [BP+0A],SI
   mov [BP-0092],DL
   les DI,[BP+06]
   test word ptr [BP-0096],0020
   jnz L28b90375
   mov DI,[ES:DI]
   add word ptr [BP+06],+02
   push DS
   pop ES
   or DI,DI
jmp near L28b90380
L28b90375:
   les DI,[ES:DI]
   add word ptr [BP+06],+04
   mov AX,ES
   or AX,DI
L28b90380:
   jnz L28b90387
   push DS
   pop ES
   mov DI,offset Y2a172bb8
L28b90387:
   call near B28b90049
   cmp CX,[BP-008e]
   jbe L28b90394
   mov CX,[BP-008e]
L28b90394:
jmp near L28b90434
L28b90397:
   mov [BP+0A],SI
   mov [BP-0092],DL
   les DI,[BP+06]
   mov CX,[BP-008e]
   or CX,CX
   jge L28b903ac
   mov CX,0006
L28b903ac:
   push ES
   push DI
   push CX
   push SS
   lea BX,[BP-0085]
   push BX
   push DX
   mov AX,0001
   and AX,[BP-0096]
   push AX
   mov AX,[BP-0096]
   test AX,0080
   jz L28b903d1
   mov AX,0002
   mov word ptr [BP-02],0004
jmp near L28b903e8
L28b903d1:
   test AX,0100
   jz L28b903e0
   mov AX,0008
   mov word ptr [BP-02],000A
jmp near L28b903e8
L28b903e0:
   mov word ptr [BP-02],0008
   mov AX,0006
L28b903e8:
   push AX
   call far __REALCVT
   mov AX,[BP-02]
   add [BP+06],AX
   push SS
   pop ES
   lea DI,[BP-0085]
L28b903fa:
   test word ptr [BP-0096],0008
   jz L28b90415
   mov DX,[BP-0090]
   or DX,DX
   jle L28b90415
L28b9040a:
   call near B28b90049
   sub DX,CX
   jle L28b90415
   mov [BP-008a],DX
L28b90415:
   mov AL,[BP-008b]
   or AL,AL
   jz L28b90431
   cmp byte ptr [ES:DI],2D
   jz L28b90431
   sub word ptr [BP-008a],+01
   adc word ptr [BP-008a],+00
   dec DI
   mov [ES:DI],AL
L28b90431:
   call near B28b90049
L28b90434:
   mov SI,DI
   mov DI,[BP-0094]
   mov BX,[BP-0090]
   mov AX,0005
   and AX,[BP-0096]
   cmp AX,0005
   jnz L28b90460
   mov AH,[BP-0092]
   cmp AH,6F
   jnz L28b90463
   cmp word ptr [BP-008a],+00
   jg L28b90460
   mov word ptr [BP-008a],0001
L28b90460:
jmp near L28b90481
X28b90462:
   nop
L28b90463:
   cmp AH,78
   jz L28b9046d
   cmp AH,58
   jnz L28b90481
L28b9046d:
   or word ptr [BP-0096],+40
   dec BX
   dec BX
   sub word ptr [BP-008a],+02
   jge L28b90481
   mov word ptr [BP-008a],0000
L28b90481:
   add CX,[BP-008a]
   test word ptr [BP-0096],0002
   jnz L28b90499
jmp near L28b90495
L28b9048f:
   mov AL,20
   call near B28b90056
   dec BX
L28b90495:
   cmp BX,CX
   jg L28b9048f
L28b90499:
   test word ptr [BP-0096],0040
   jz L28b904ad
   mov AL,30
   call near B28b90056
   mov AL,[BP-0092]
   call near B28b90056
L28b904ad:
   mov DX,[BP-008a]
   or DX,DX
   jle L28b904dc
   sub CX,DX
   sub BX,DX
   mov AL,[ES:SI]
   cmp AL,2D
   jz L28b904c8
   cmp AL,20
   jz L28b904c8
   cmp AL,2B
   jnz L28b904cf
L28b904c8:
   ES:lodsb
   call near B28b90056
   dec CX
   dec BX
L28b904cf:
   xchg CX,DX
   jcxz L28b904da
L28b904d3:
   mov AL,30
   call near B28b90056
   loop L28b904d3
L28b904da:
   xchg CX,DX
L28b904dc:
   jcxz L28b904f0
   sub BX,CX
L28b904e0:
   ES:lodsb
   mov [SS:DI],AL
   inc DI
   dec byte ptr [BP-53]
   jg L28b904ee
   call near B28b9005f
L28b904ee:
   loop L28b904e0
L28b904f0:
   or BX,BX
   jle L28b904fd
   mov CX,BX
L28b904f6:
   mov AL,20
   call near B28b90056
   loop L28b904f6
L28b904fd:
jmp near L28b90093
L28b90500:
   mov [BP+0A],SI
   les DI,[BP+06]
   test word ptr [BP-0096],0020
   jnz L28b90519
   mov DI,[ES:DI]
   add word ptr [BP+06],+02
   push DS
   pop ES
jmp near L28b90520
L28b90519:
   les DI,[ES:DI]
   add word ptr [BP+06],+04
L28b90520:
   mov AX,0050
   sub AL,[BP-53]
   add AX,[BP-56]
   mov [ES:DI],AX
jmp near L28b9008f
L28b9052f:
   mov SI,[BP-0088]
   mov ES,[BP+0C]
   mov DI,[BP-0094]
   mov AL,25
L28b9053c:
   call near B28b90056
   ES:lodsb
   or AL,AL
   jnz L28b9053c
L28b90545:
   cmp byte ptr [BP-53],50
   jge L28b9054e
   call near B28b9005f
L28b9054e:
   pop ES
   mov AX,[BP-56]
jmp near L28b90554
L28b90554:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far 0010

Segment 290e ;; CORELEFT
_coreleft: ;; 290e000c
   call far _farcoreleft
jmp near L290e0013
L290e0013:
ret far

Segment 290f ;; FCORELFT
_farcoreleft: ;; 290f0004
   mov DX,[offset __heaptop+02]
   mov AX,[offset __heaptop]
   mov CX,[offset __brklvl+02]
   mov BX,[offset __brklvl]
   call far PSBP@
   add AX,FFF8
   adc DX,-01
jmp near L290f0020
L290f0020:
ret far

Segment 2911 ;; FFREE
;; (@) Unnamed far routines accessed by near calls: A29110013 A291100b2 A2911012a A2911020f
_free: ;; 29110001
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   call far _farfree
   mov SP,BP
   pop BP
ret far

A29110013:
   push BP
   mov BP,SP
   sub SP,+04
   xor CX,CX
   xor BX,BX
   mov DX,[offset __rover+02]
   mov AX,[offset __rover]
   call far PCMP@
   jz L29110081
   les BX,[offset __rover]
   les BX,[ES:BX+0C]
   mov [BP-02],ES
   mov [BP-04],BX
   mov DX,[BP+08]
   mov AX,[BP+06]
   les BX,[offset __rover]
   mov [ES:BX+0E],DX
   mov [ES:BX+0C],AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   les BX,[BP-04]
   mov [ES:BX+0A],DX
   mov [ES:BX+08],AX
   mov DX,[BP-02]
   mov AX,[BP-04]
   les BX,[BP+06]
   mov [ES:BX+0E],DX
   mov [ES:BX+0C],AX
   mov DX,[offset __rover+02]
   mov AX,[offset __rover]
   les BX,[BP+06]
   mov [ES:BX+0A],DX
   mov [ES:BX+08],AX
jmp near L291100ae
L29110081:
   les BX,[BP+06]
   mov [offset __rover+02],ES
   mov [offset __rover],BX
   mov DX,[BP+08]
   mov AX,[BP+06]
   les BX,[BP+06]
   mov [ES:BX+0A],DX
   mov [ES:BX+08],AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   les BX,[BP+06]
   mov [ES:BX+0E],DX
   mov [ES:BX+0C],AX
L291100ae:
   mov SP,BP
   pop BP
ret far

A291100b2:
   push BP
   mov BP,SP
   sub SP,+04
   les BX,[BP+0A]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   les BX,[BP+06]
   add [ES:BX],AX
   adc [ES:BX+02],DX
   mov CX,[BP+0C]
   mov BX,[BP+0A]
   mov DX,[offset __last+02]
   mov AX,[offset __last]
   call far PCMP@
   jnz L291100ed
   les BX,[BP+06]
   mov [offset __last+02],ES
   mov [offset __last],BX
jmp near L29110119
L291100ed:
   les BX,[BP+0A]
   mov CX,[ES:BX+02]
   mov BX,[ES:BX]
   mov DX,[BP+0C]
   mov AX,[BP+0A]
   call far PADD@
   mov [BP-02],DX
   mov [BP-04],AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   les BX,[BP-04]
   mov [ES:BX+06],DX
   mov [ES:BX+04],AX
L29110119:
   push [BP+0C]
   push [BP+0A]
   call far __pull_free_block
   pop CX
   pop CX
   mov SP,BP
   pop BP
ret far

A2911012a:
   push BP
   mov BP,SP
   sub SP,+04
   mov CX,[offset __last+02]
   mov BX,[offset __last]
   mov DX,[offset __first+02]
   mov AX,[offset __first]
   call far PCMP@
   jnz L29110172
   push [offset __first+02]
   push [offset __first]
   call far __brk
   pop CX
   pop CX
   mov word ptr [offset __last+02],0000
   mov word ptr [offset __last],0000
   xor BX,BX
   mov ES,BX
   xor BX,BX
   mov [offset __first+02],ES
   mov [offset __first],BX
jmp near L2911020b
L29110172:
   les BX,[offset __last]
   les BX,[ES:BX+04]
   mov [BP-02],ES
   mov [BP-04],BX
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   and AX,0001
   and DX,0000
   or DX,AX
   jnz L291101f1
   push [BP-02]
   push [BP-04]
   call far __pull_free_block
   pop CX
   pop CX
   mov CX,[offset __first+02]
   mov BX,[offset __first]
   mov DX,[BP-02]
   mov AX,[BP-04]
   call far PCMP@
   jnz L291101d3
   mov word ptr [offset __last+02],0000
   mov word ptr [offset __last],0000
   xor BX,BX
   mov ES,BX
   xor BX,BX
   mov [offset __first+02],ES
   mov [offset __first],BX
jmp near L291101e2
L291101d3:
   les BX,[BP-04]
   les BX,[ES:BX+04]
   mov [offset __last+02],ES
   mov [offset __last],BX
L291101e2:
   push [BP-02]
   push [BP-04]
   call far __brk
   pop CX
   pop CX
jmp near L2911020b
L291101f1:
   push [offset __last+02]
   push [offset __last]
   call far __brk
   pop CX
   pop CX
   les BX,[BP-04]
   mov [offset __last+02],ES
   mov [offset __last],BX
L2911020b:
   mov SP,BP
   pop BP
ret far

A2911020f:
   push BP
   mov BP,SP
   sub SP,+08
   les BX,[BP+06]
   sub word ptr [ES:BX],+01
   sbb word ptr [ES:BX+02],+00
   les BX,[BP+06]
   mov CX,[ES:BX+02]
   mov BX,[ES:BX]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far PADD@
   mov [BP-06],DX
   mov [BP-08],AX
   les BX,[BP+06]
   les BX,[ES:BX+04]
   mov [BP-02],ES
   mov [BP-04],BX
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   and AX,0001
   and DX,0000
   or DX,AX
   jnz L291102a3
   mov CX,[offset __first+02]
   mov BX,[offset __first]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far PCMP@
   jz L291102a3
   les BX,[BP+06]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   les BX,[BP-04]
   add [ES:BX],AX
   adc [ES:BX+02],DX
   mov DX,[BP-02]
   mov AX,[BP-04]
   les BX,[BP-08]
   mov [ES:BX+06],DX
   mov [ES:BX+04],AX
   les BX,[BP-04]
   mov [BP+08],ES
   mov [BP+06],BX
jmp near L291102af
L291102a3:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A29110013
   pop CX
   pop CX
L291102af:
   les BX,[BP-08]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   and AX,0001
   and DX,0000
   or DX,AX
   jnz L291102d7
   push [BP-06]
   push [BP-08]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A291100b2
   add SP,+08
L291102d7:
   mov SP,BP
   pop BP
ret far

_farfree: ;; 291102db
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L291102e8
jmp near L29110323
L291102e8:
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov CX,FFFF
   mov BX,FFF8
   call far PADD@
   mov [BP+08],DX
   mov [BP+06],AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   cmp DX,[offset __last+02]
   jnz L29110317
   cmp AX,[offset __last]
   jnz L29110317
   push CS
   call near offset A2911012a
jmp near L29110323
L29110317:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A2911020f
   mov SP,BP
L29110323:
   pop BP
ret far

Segment 2943 ;; CREATA
;; (@) Unnamed near calls: B29430005
B29430005:
   push BP
   mov BP,SP
   push SI
   push DS
   mov AH,[BP+06]
   mov CX,[BP+08]
   lds DX,[BP+0A]
   int 21
   pop DS
   jb L29430029
   mov SI,AX
   mov AX,[BP+04]
   mov BX,SI
   shl BX,1
   mov [BX+offset __openfd],AX
   mov AX,SI
jmp near L29430031
L29430029:
   push AX
   call far __IOERROR
jmp near L29430031
L29430031:
   pop SI
   pop BP
ret near 000A

__creat: ;; 29430036
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0A]
   mov AL,3C
   push AX
   mov AX,8004
   push AX
   call near B29430005
jmp near L2943004e
L2943004e:
   pop BP
ret far

_creattemp: ;; 29430050 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0A]
   mov AL,5A
   push AX
   mov AX,[offset __fmode]
   or AX,0004
   push AX
   call near B29430005
jmp near L2943006b
L2943006b:
   pop BP
ret far

_creatnew: ;; 2943006d ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0A]
   mov AL,5B
   push AX
   mov AX,[offset __fmode]
   or AX,0004
   push AX
   call near B29430005
jmp near L29430088
L29430088:
   pop BP
ret far

Segment 294b ;; FLENGTH
_filelength: ;; 294b000a
   push BP
   mov BP,SP
   sub SP,+04
   mov AX,4201
   mov BX,[BP+06]
   xor CX,CX
   xor DX,DX
   int 21
   jb L294b0042
   push DX
   push AX
   mov AX,4202
   xor CX,CX
   xor DX,DX
   int 21
   mov [BP-04],AX
   mov [BP-02],DX
   pop DX
   pop CX
   jb L294b0042
   mov AX,4200
   int 21
   jb L294b0042
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L294b004b
L294b0042:
   push AX
   call far __IOERROR
   cwd
jmp near L294b004b
L294b004b:
   mov SP,BP
   pop BP
ret far

Segment 294f ;; CRTINIT, CLRSCR
_clrscr: ;; 294f000f
   mov AL,06
   push AX
   push [offset __video]
   push [offset __video+01]
   push [offset __video+02]
   push [offset __video+03]
   mov AL,00
   push AX
   call far __SCROLL
   mov DL,[offset __video]
   mov DH,[offset __video+01]
   mov AH,02
   mov BH,00
   call far __VideoInt
ret far

Segment 2952 ;; COLOR
_textcolor: ;; 2952000c
   push BP
   mov BP,SP
   mov AL,[offset __video+04]
   and AL,70
   mov DL,[BP+06]
   and DL,8F
   or AL,DL
   mov [offset __video+04],AL
   pop BP
ret far

_textbackground: ;; 29520021
   push BP
   mov BP,SP
   mov AL,[offset __video+04]
   and AL,8F
   mov DL,[BP+06]
   mov CL,04
   shl DL,CL
   and DL,7F
   or AL,DL
   mov [offset __video+04],AL
   pop BP
ret far

_textattr: ;; 2952003a ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AL,[BP+06]
   mov [offset __video+04],AL
   pop BP
ret far

_highvideo: ;; 29520045 ;; (@) Unaccessed.
   or byte ptr [offset __video+04],08
ret far

_lowvideo: ;; 2952004b ;; (@) Unaccessed.
   and byte ptr [offset __video+04],F7
ret far

_normvideo: ;; 29520051 ;; (@) Unaccessed.
   mov AL,[offset __video+05]
   mov [offset __video+04],AL
ret far

Segment 2957 ;; CPRINTF
__CPUTN: ;; 29570008
   push BP
   mov BP,SP
   sub SP,+08
   mov byte ptr [BP-03],00
   call far __wherexy
   mov AH,00
   mov [BP-08],AX
   call far __wherexy
   mov CL,08
   shr AX,CL
   mov AH,00
   mov [BP-06],AX
jmp near L29570126
L2957002d:
   les BX,[BP+0C]
   inc word ptr [BP+0C]
   mov AL,[ES:BX]
   mov [BP-03],AL
   mov AH,00
   sub AX,0007
   cmp AX,0006
   ja L29570089
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y2957004c]
Y2957004c:	dw L2957005a,L2957006b,L29570089,L29570084,L29570089,L29570089,L2957007a
L2957005a:
   mov AH,0E
   mov AL,07
   call far __VideoInt
   mov AL,[BP-03]
   mov AH,00
jmp near L29570149
L2957006b:
   mov AL,[offset __video]
   mov AH,00
   cmp AX,[BP-08]
   jge L29570078
   dec word ptr [BP-08]
L29570078:
jmp near L295700e9
L2957007a:
   mov AL,[offset __video]
   mov AH,00
   mov [BP-08],AX
jmp near L295700e9
L29570084:
   inc word ptr [BP-06]
jmp near L295700e9
L29570089:
   cmp byte ptr [offset __video+09],00
   jnz L295700c2
   cmp word ptr [offset _directvideo],+00
   jz L295700c2
   mov AH,[offset __video+04]
   mov AL,[BP-03]
   mov [BP-02],AX
   mov AX,[BP-08]
   inc AX
   push AX
   mov AX,[BP-06]
   inc AX
   push AX
   call far __VPTR
   push DX
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   mov AX,0001
   push AX
   call far __VRAM
jmp near L295700e4
L295700c2:
   mov DL,[BP-08]
   mov DH,[BP-06]
   mov AH,02
   mov BH,00
   call far __VideoInt
   mov BL,[offset __video+04]
   mov AL,[BP-03]
   mov AH,09
   mov BH,00
   mov CX,0001
   call far __VideoInt
L295700e4:
   inc word ptr [BP-08]
jmp near L295700e9
L295700e9:
   mov AL,[offset __video+02]
   mov AH,00
   cmp AX,[BP-08]
   jge L295700fe
   mov AL,[offset __video]
   mov AH,00
   mov [BP-08],AX
   inc word ptr [BP-06]
L295700fe:
   mov AL,[offset __video+03]
   mov AH,00
   cmp AX,[BP-06]
   jge L29570126
   mov AL,06
   push AX
   push [offset __video]
   push [offset __video+01]
   push [offset __video+02]
   push [offset __video+03]
   mov AL,01
   push AX
   call far __SCROLL
   dec word ptr [BP-06]
L29570126:
   mov AX,[BP+0A]
   dec word ptr [BP+0A]
   or AX,AX
   jz L29570133
jmp near L2957002d
L29570133:
   mov DL,[BP-08]
   mov DH,[BP-06]
   mov AH,02
   mov BH,00
   call far __VideoInt
   mov AL,[BP-03]
   mov AH,00
jmp near L29570149
L29570149:
   mov SP,BP
   pop BP
ret far 000A

_cprintf: ;; 2957014f ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push CS
   mov AX,offset __CPUTN
   push AX
   xor AX,AX
   push AX
   push AX
   push [BP+08]
   push [BP+06]
   push SS
   lea AX,[BP+0A]
   push AX
   call far __VPRINTER
jmp near L2957016d
L2957016d:
   pop BP
ret far

Segment 296d ;; CPUTS
_cputs: ;; 296d000f
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+08]
   push [BP+06]
   call far _strlen
   pop CX
   pop CX
   push AX
   xor AX,AX
   push AX
   push AX
   call far __CPUTN
jmp near L296d0031
L296d0031:
   pop BP
ret far

Segment 2970 ;; ATOL
_atol: ;; 29700003
   push BP
   mov BP,SP
   push SI
   push DI
   push ES
   push BP
   les SI,[BP+06]
   cld
   sub AX,AX
   cwd
   mov CX,000A
   mov BH,00
   mov DI,offset __ctype+01
L29700019:
   mov BL,[ES:SI]
   inc SI
   test byte ptr [BX+DI],01
   jnz L29700019
   mov BP,0000
   cmp BL,2B
   jz L29700030
   cmp BL,2D
   jnz L29700034
   inc BP
L29700030:
   mov BL,[ES:SI]
   inc SI
L29700034:
   cmp BL,39
   ja L29700068
   sub BL,30
   jb L29700068
   mul CX
   add AX,BX
   adc DL,DH
   jz L29700030
jmp near L2970005a
L29700048:
   mov DI,DX
   mov CX,000A
   mul CX
   xchg DI,AX
   xchg DX,CX
   mul DX
   xchg DX,AX
   xchg DI,AX
   add AX,BX
   adc DX,CX
L2970005a:
   mov BL,[ES:SI]
   inc SI
   cmp BL,39
   ja L29700068
   sub BL,30
   jnb L29700048
L29700068:
   dec BP
   jl L29700072
   neg DX
   neg AX
   sbb DX,+00
L29700072:
   pop BP
   pop ES
jmp near L29700076
L29700076:
   pop DI
   pop SI
   pop BP
ret far

_atoi: ;; 2970007a ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _atol
   mov SP,BP
jmp near L2970008b
L2970008b:
   pop BP
ret far

Y2970008d:	db 00,00,00

Segment 2979 ;; DELAY
;; (@) Unnamed near calls: B2979005d
Y29790000:	word	;; DelayT

_delay: ;; 29790002
   dec SP
   dec SP
   push BP
   mov BP,SP
   push SI
   push DI
   push DS
   push ES
   mov CX,[BP+08]
   mov AX,[CS:offset Y29790000]
   or AX,AX
   jnz L29790039
   mov AX,segment Y0040006c
   mov ES,AX
   mov BX,[ES:offset Y0040006c]
   call near B2979005d
   sub BX,[ES:offset Y0040006c]
   neg BX
   mov AX,0037
   mul BX
   cmp CX,AX
   jbe L29790051
   sub CX,AX
   mov AX,[CS:offset Y29790000]
L29790039:
   xor BX,BX
   mov ES,BX
   mov DL,[ES:BX]
   jcxz L29790051
L29790042:
   mov SI,CX
   mov CX,AX
L29790046:
   cmp DL,[ES:BX]
   jnz L2979004b
L2979004b:
   loop L29790046
   mov CX,SI
   loop L29790042
L29790051:
   mov AX,[CS:offset Y29790000]
   pop ES
   pop DS
   pop DI
   pop SI
   pop BP
   inc SP
   inc SP
ret far

B2979005d:
   push BX
   push CX
   push DX
   push ES
   mov AX,segment Y0040006c
   mov ES,AX
   mov BX,offset Y0040006c
   mov AL,[ES:BX]
   mov CX,FFFF
L2979006f:
   mov DL,[ES:BX]
   cmp AL,DL
   jz L2979006f
L29790076:
   cmp DL,[ES:BX]
   jnz L2979007d
   loop L29790076
L2979007d:
   neg CX
   dec CX
   mov AX,0037
   xchg CX,AX
   xor DX,DX
   div CX
   mov [CS:offset Y29790000],AX
L2979008c:
   mov AL,[ES:BX]
   mov CX,FFFF
L29790092:
   mov DL,[ES:BX]
   cmp AL,DL
   jz L29790092
   push BX
   push DX
   mov AX,0037
   push AX
   call far _delay
   pop AX
   pop DX
   pop BX
   cmp DL,[ES:BX]
   jz L297900b3
   dec word ptr [CS:offset Y29790000]
jmp near L2979008c
L297900b3:
   pop ES
   pop DX
   pop CX
   pop BX
ret near

Segment 2984 ;; GETVECT
_getvect: ;; 29840008
   push BP
   mov BP,SP
   mov AH,35
   mov AL,[BP+06]
   int 21
   mov AX,BX
   mov DX,ES
jmp near L29840018
L29840018:
   pop BP
ret far

_setvect: ;; 2984001a
   push BP
   mov BP,SP
   mov AH,25
   mov AL,[BP+06]
   push DS
   lds DX,[BP+08]
   int 21
   pop DS
   pop BP
ret far

Segment 2986 ;; GOTOXY
_gotoxy: ;; 2986000b
   push BP
   mov BP,SP
   sub SP,+02
   mov AL,[BP+08]
   add AL,FF
   mov [BP-02],AL
   mov AL,[offset __video+01]
   add [BP-02],AL
   mov AL,[BP+06]
   add AL,FF
   mov [BP-01],AL
   mov AL,[offset __video]
   add [BP-01],AL
   mov AL,[BP-02]
   cmp AL,[offset __video+01]
   jb L29860051
   mov AL,[BP-02]
   cmp AL,[offset __video+03]
   ja L29860051
   mov AL,[BP-01]
   cmp AL,[offset __video]
   jb L29860051
   mov AL,[BP-01]
   cmp AL,[offset __video+02]
   jbe L29860053
L29860051:
jmp near L29860062
L29860053:
   mov DL,[BP-01]
   mov DH,[BP-02]
   mov AH,02
   mov BH,00
   call far __VideoInt
L29860062:
   mov SP,BP
   pop BP
ret far

Segment 298c ;; GPTEXT
_gettext: ;; 298c0006
   push BP
   mov BP,SP
   push SI
   push DI
   push [BP+06]
   push [BP+08]
   push [BP+0A]
   push [BP+0C]
   call far __VALIDATEXY
   or AX,AX
   jnz L298c0024
   xor AX,AX
jmp near L298c0059
L298c0024:
   mov DI,[BP+0A]
   sub DI,[BP+06]
   inc DI
   mov SI,[BP+08]
jmp near L298c004f
L298c0030:
   push [BP+10]
   push [BP+0E]
   push [BP+06]
   push SI
   call far __VPTR
   push DX
   push AX
   push DI
   call far __SCREENIO
   mov AX,DI
   shl AX,1
   add [BP+0E],AX
   inc SI
L298c004f:
   cmp SI,[BP+0C]
   jle L298c0030
   mov AX,0001
jmp near L298c0059
L298c0059:
   pop DI
   pop SI
   pop BP
ret far

_puttext: ;; 298c005d
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+0A]
   sub DI,[BP+06]
   inc DI
   mov SI,[BP+08]
jmp near L298c008d
L298c006e:
   push [BP+06]
   push SI
   call far __VPTR
   push DX
   push AX
   push [BP+10]
   push [BP+0E]
   push DI
   call far __SCREENIO
   mov AX,DI
   shl AX,1
   add [BP+0E],AX
   inc SI
L298c008d:
   cmp SI,[BP+0C]
   jle L298c006e
   mov AX,0001
jmp near L298c0097
L298c0097:
   pop DI
   pop SI
   pop BP
ret far

Segment 2995 ;; INT86
_int86: ;; 2995000b ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+08
   push SS
   lea AX,[BP-08]
   push AX
   call far _segread
   pop CX
   pop CX
   push SS
   lea AX,[BP-08]
   push AX
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far _int86x
   add SP,+0E
jmp near L2995003b
L2995003b:
   mov SP,BP
   pop BP
ret far

_int86x: ;; 2995003f
   push BP
   mov BP,SP
   sub SP,+0E
   push SI
   push DI
   push DS
   lea CX,[BP-0A]
   mov [BP-0E],CX
   mov [BP-0C],SS
   mov byte ptr [BP-0A],55
   mov byte ptr [BP-09],CD
   mov AX,[BP+06]
   mov [BP-08],AL
   mov word ptr [BP-07],CB5D
   cmp AL,25
   jb L2995007d
   cmp AL,26
   ja L2995007d
   mov byte ptr [BP-07],36
   mov word ptr [BP-06],068F
   mov [BP-04],CX
   mov word ptr [BP-02],CB5D
L2995007d:
   lds SI,[BP+10]
   push [SI]
   push [SI+06]
   lds SI,[BP+08]
   mov AX,[SI]
   mov BX,[SI+02]
   mov CX,[SI+04]
   mov DX,[SI+06]
   mov DI,[SI+0A]
   mov SI,[SI+08]
   pop DS
   pop ES
   call far [BP-0E]
   pushf
   pushf
   push SI
   push DS
   push ES
   lds SI,[BP+10]
   pop [SI]
   pop [SI+06]
   lds SI,[BP+0C]
   pop [SI+08]
   pop [SI+0E]
   pop [SI+0C]
   and word ptr [SI+0C],+01
   mov [SI+0A],DI
   mov [SI+06],DX
   mov [SI+04],CX
   mov [SI+02],BX
   mov [SI],AX
   pop DS
   jz L299500d4
   push AX
   push AX
   call far __IOERROR
   pop AX
L299500d4:
jmp near L299500d6
L299500d6:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 29a2 ;; INTR, LDIV, LRSH
;; (@) Unnamed far routines accessed by near calls: A29a20053
_intr: ;; 29a2000c
   push BP
   mov BP,SP
   sub SP,+12
   push SI
   push DI
   push BP
   push DS
   pushf
   lea CX,[BP-0E]
   mov [BP-12],CX
   mov [BP-10],SS
   mov word ptr [BP-0E],6E8B
   mov byte ptr [BP-0C],E2
   mov byte ptr [BP-0B],CD
   mov AX,[BP+06]
   mov [BP-0A],AL
   cmp AL,25
   jb L29a20054
   cmp AL,26
   ja L29a20054
   mov byte ptr [BP-09],36
   mov word ptr [BP-08],068F
   mov [BP-06],CX
   mov byte ptr [BP-04],CA
   mov word ptr [BP-03],0002
jmp near L29a2005d

X29a20052:
   nop

A29a20053:
iret
L29a20054:
   mov byte ptr [BP-09],CA
   mov word ptr [BP-08],0002
L29a2005d:
   lds DI,[BP+08]
   push DS
   push DI
   mov AX,[DI]
   mov BX,[DI+02]
   mov CX,[DI+04]
   mov DX,[DI+06]
   push [DI+08]
   mov SI,[DI+0A]
   mov ES,[DI+10]
   lds DI,[DI+0C]
   call far [BP-12]
   push DS
   push DI
   push BP
   pushf
   mov BP,SP
   lds DI,[BP+08]
   mov [DI],AX
   mov [DI+02],BX
   mov [DI+04],CX
   mov [DI+06],DX
   mov [DI+0A],SI
   mov [DI+10],ES
   pop [DI+12]
   pop [DI+08]
   pop [DI+0C]
   pop [DI+0E]
   add SP,+04
   push CS
   call near offset A29a20053
   pop DS
   pop BP
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 29ad ;; MOVETEXT
_movetext: ;; 29ad0001
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov SI,[BP+08]
   push [BP+06]
   push SI
   push [BP+0A]
   push [BP+0C]
   call far __VALIDATEXY
   or AX,AX
   jz L29ad0041
   push [BP+0E]
   push [BP+10]
   mov AX,[BP+0A]
   sub AX,[BP+06]
   add AX,[BP+0E]
   push AX
   mov AX,[BP+0C]
   sub AX,SI
   add AX,[BP+10]
   push AX
   call far __VALIDATEXY
   or AX,AX
   jnz L29ad0045
L29ad0041:
   xor AX,AX
jmp near L29ad00a7
L29ad0045:
   mov [BP-06],SI
   mov AX,[BP+0C]
   mov [BP-04],AX
   mov word ptr [BP-02],0001
   cmp SI,[BP+10]
   jge L29ad0066
   mov AX,[BP+0C]
   mov [BP-06],AX
   mov [BP-04],SI
   mov word ptr [BP-02],FFFF
L29ad0066:
   mov DI,[BP-06]
jmp near L29ad0098
L29ad006b:
   push [BP+0E]
   mov AX,DI
   sub AX,SI
   add AX,[BP+10]
   push AX
   call far __VPTR
   push DX
   push AX
   push [BP+06]
   push DI
   call far __VPTR
   push DX
   push AX
   mov AX,[BP+0A]
   sub AX,[BP+06]
   inc AX
   push AX
   call far __SCREENIO
   add DI,[BP-02]
L29ad0098:
   mov AX,[BP-04]
   add AX,[BP-02]
   cmp AX,DI
   jnz L29ad006b
   mov AX,0001
jmp near L29ad00a7
L29ad00a7:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 29b7 ;; OUTPORT
_outport: ;; 29b7000d
   push BP
   mov BP,SP
   mov DX,[BP+06]
   mov AX,[BP+08]
   out DX,AX
   pop BP
ret far

_outportb: ;; 29b70019 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov DX,[BP+06]
   mov AL,[BP+08]
   out DX,AL
   pop BP
ret far

Segment 29b9 ;; PSBP, RAND
_srand: ;; 29b90005
   push BP
   mov BP,SP
   mov AX,[BP+06]
   xor DX,DX
   mov [offset Y2a172c48+02],DX
   mov [offset Y2a172c48],AX
   pop BP
ret far

_rand: ;; 29b90016
   mov DX,[offset Y2a172c48+02]
   mov AX,[offset Y2a172c48]
   mov CX,015A
   mov BX,4E35
   call far LXMUL@
   add AX,0001
   adc DX,+00
   mov [offset Y2a172c48+02],DX
   mov [offset Y2a172c48],AX
   mov AX,[offset Y2a172c48+02]
   and AX,7FFF
jmp near L29b9003d
L29b9003d:
ret far

Segment 29bc ;; SCOPY, SCROLL
;; (@) Unnamed near calls: B29bc000e
B29bc000e:
   push BP
   mov BP,SP
   mov CH,[offset __video+04]
   mov CL,20
jmp near L29bc0026
L29bc0019:
   les BX,[BP+08]
   mov [ES:BX],CX
   add word ptr [BP+08],+02
   inc word ptr [BP+06]
L29bc0026:
   mov AX,[BP+06]
   cmp AX,[BP+04]
   jle L29bc0019
   pop BP
ret near 0008

__SCROLL: ;; 29bc0032
   push BP
   mov BP,SP
   sub SP,00A0
   cmp byte ptr [offset __video+09],00
   jz L29bc0043
jmp near L29bc018d
L29bc0043:
   cmp word ptr [offset _directvideo],+00
   jnz L29bc004d
jmp near L29bc018d
L29bc004d:
   cmp byte ptr [BP+06],01
   jz L29bc0056
jmp near L29bc018d
L29bc0056:
   inc byte ptr [BP+0E]
   inc byte ptr [BP+0C]
   inc byte ptr [BP+0A]
   inc byte ptr [BP+08]
   cmp byte ptr [BP+10],06
   jz L29bc006b
jmp near L29bc00fc
L29bc006b:
   mov AL,[BP+0C]
   mov AH,00
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   mov AL,[BP+08]
   mov AH,00
   push AX
   mov AL,[BP+0A]
   mov AH,00
   push AX
   mov AL,[BP+0C]
   mov AH,00
   inc AX
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   call far _movetext
   add SP,+0C
   push SS
   lea AX,[BP-00a0]
   push AX
   mov AL,[BP+08]
   mov AH,00
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   mov AL,[BP+08]
   mov AH,00
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   call far _gettext
   add SP,+0C
   push SS
   lea AX,[BP-00a0]
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   mov AL,[BP+0A]
   mov AH,00
   push AX
   call near B29bc000e
   push SS
   lea AX,[BP-00a0]
   push AX
   mov AL,[BP+08]
   mov AH,00
   push AX
   mov AL,[BP+0A]
   mov AH,00
   push AX
   mov AL,[BP+08]
   mov AH,00
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   call far _puttext
   add SP,+0C
jmp near L29bc018b
L29bc00fc:
   mov AL,[BP+0C]
   mov AH,00
   inc AX
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   mov AL,[BP+08]
   mov AH,00
   dec AX
   push AX
   mov AL,[BP+0A]
   mov AH,00
   push AX
   mov AL,[BP+0C]
   mov AH,00
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   call far _movetext
   add SP,+0C
   push SS
   lea AX,[BP-00a0]
   push AX
   mov AL,[BP+0C]
   mov AH,00
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   mov AL,[BP+0C]
   mov AH,00
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   call far _gettext
   add SP,+0C
   push SS
   lea AX,[BP-00a0]
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   mov AL,[BP+0A]
   mov AH,00
   push AX
   call near B29bc000e
   push SS
   lea AX,[BP-00a0]
   push AX
   mov AL,[BP+0C]
   mov AH,00
   push AX
   mov AL,[BP+0A]
   mov AH,00
   push AX
   mov AL,[BP+0C]
   mov AH,00
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   call far _puttext
   add SP,+0C
L29bc018b:
jmp near L29bc01a8
L29bc018d:
   mov BH,[offset __video+04]
   mov AH,[BP+10]
   mov AL,[BP+06]
   mov CH,[BP+0C]
   mov CL,[BP+0E]
   mov DH,[BP+08]
   mov DL,[BP+0A]
   call far __VideoInt
L29bc01a8:
   mov SP,BP
   pop BP
ret far 000C

Segment 29d6 ;; SCREEN
;; (@) Unnamed near calls: B29d6000e B29d6004e B29d60086
B29d6000e:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   mov SI,[BP+04]
   shr SI,1
   mov AX,SI
   mov DL,[offset __video+08]
   mov DH,00
   mov BX,DX
   xor DX,DX
   div BX
   mov [BP-02],AL
   mov AL,[BP-02]
   mov AH,00
   mov DL,[offset __video+08]
   mov DH,00
   mul DX
   mov DX,SI
   sub DL,AL
   mov [BP-01],DL
   mov AH,[BP-02]
   mov AL,[BP-01]
jmp near L29d60047
L29d60047:
   pop SI
   mov SP,BP
   pop BP
ret near 0004

B29d6004e:
   push BP
   mov BP,SP
   les BX,[BP+08]
   mov DX,[ES:BX]
   les BX,[BP+04]
   cmp DX,[ES:BX]
   jz L29d6006e
   mov BH,00
   mov AH,02
   call far __VideoInt
   les BX,[BP+04]
   mov [ES:BX],DX
L29d6006e:
   inc DL
   mov AL,DL
   cmp AL,[offset __video+08]
   jb L29d6007c
   inc DH
   mov DL,00
L29d6007c:
   les BX,[BP+08]
   mov [ES:BX],DX
   pop BP
ret near 0008

B29d60086:
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   call far __wherexy
   mov DI,AX
   mov AX,DI
   mov [BP-06],AX
   mov AX,[BP+0C]
   cmp AX,[offset __video+0d]
   jnz L29d600a8
   mov AX,0001
jmp near L29d600aa
L29d600a8:
   xor AX,AX
L29d600aa:
   mov [BP-04],AX
   or AX,AX
   jz L29d600bd
   push [BP+0C]
   push [BP+0A]
   call near B29d6000e
   mov [BP-0A],AX
L29d600bd:
   mov AX,[BP+08]
   cmp AX,[offset __video+0d]
   jnz L29d600cb
   mov AX,0001
jmp near L29d600cd
L29d600cb:
   xor AX,AX
L29d600cd:
   mov [BP-02],AX
   or AX,AX
   jz L29d600e0
   push [BP+08]
   push [BP+06]
   call near B29d6000e
   mov [BP-08],AX
L29d600e0:
jmp near L29d6013b
L29d600e2:
   cmp word ptr [BP-02],+00
   jz L29d60102
   push SS
   lea AX,[BP-08]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   call near B29d6004e
   mov BH,00
   mov AH,08
   call far __VideoInt
   mov SI,AX
jmp near L29d6010c
L29d60102:
   les BX,[BP+06]
   mov SI,[ES:BX]
   add word ptr [BP+06],+02
L29d6010c:
   cmp word ptr [BP-04],+00
   jz L29d60131
   push SS
   lea AX,[BP-0A]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   call near B29d6004e
   mov AX,SI
   mov BL,AH
   mov CX,0001
   mov BH,00
   mov AH,09
   call far __VideoInt
jmp near L29d6013b
L29d60131:
   les BX,[BP+0A]
   mov [ES:BX],SI
   add word ptr [BP+0A],+02
L29d6013b:
   mov AX,[BP+04]
   dec word ptr [BP+04]
   or AX,AX
   jnz L29d600e2
   mov DX,DI
   mov BH,00
   mov AH,02
   call far __VideoInt
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret near 000A

__SCREENIO: ;; 29d60158
   push BP
   mov BP,SP
   cmp byte ptr [offset __video+09],00
   jnz L29d6017f
   cmp word ptr [offset _directvideo],+00
   jz L29d6017f
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far __VRAM
jmp near L29d60191
L29d6017f:
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call near B29d60086
L29d60191:
   pop BP
ret far 000A

__VALIDATEXY: ;; 29d60195
   push BP
   mov BP,SP
   mov AL,[offset __video+08]
   mov AH,00
   mov CX,AX
   mov AL,[offset __video+07]
   mov AH,00
   mov DX,AX
   mov AX,[BP+0C]
   cmp AX,CX
   ja L29d601d7
   mov AX,[BP+08]
   cmp AX,CX
   ja L29d601d7
   mov AX,[BP+0C]
   cmp AX,[BP+08]
   jg L29d601d7
   mov AX,[BP+0A]
   cmp AX,DX
   ja L29d601d7
   mov AX,[BP+06]
   cmp AX,DX
   ja L29d601d7
   mov AX,[BP+0A]
   cmp AX,[BP+06]
   jg L29d601d7
   mov AX,0001
jmp near L29d601d9
L29d601d7:
   xor AX,AX
L29d601d9:
jmp near L29d601db
L29d601db:
   pop BP
ret far 0008

Segment 29f3 ;; SEGREAD
_segread: ;; 29f3000f
   push BP
   mov BP,SP
   push SI
   mov AX,ES
   les SI,[BP+06]
   mov [ES:SI],AX
   mov [ES:SI+02],CS
   mov [ES:SI+04],SS
   mov [ES:SI+06],DS
   mov ES,AX
   pop SI
   pop BP
ret far

Segment 29f5 ;; SOUND
_sound: ;; 29f5000c
   push BP
   mov BP,SP
   mov BX,[BP+06]
   mov AX,34DD
   mov DX,0012
   cmp DX,BX
   jnb L29f50036
   div BX
   mov BX,AX
   in AL,61
   test AL,03
   jnz L29f5002e
   or AL,03
   out 61,AL
   mov AL,B6
   out 43,AL
L29f5002e:
   mov AL,BL
   out 42,AL
   mov AL,BH
   out 42,AL
L29f50036:
   pop BP
ret far

_nosound: ;; 29f50038
   in AL,61
   and AL,FC
   out 61,AL
ret far

Segment 29f8 ;; STRDUP
_strdup: ;; 29f8000f
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push [BP+08]
   push [BP+06]
   call far _strlen
   pop CX
   pop CX
   mov SI,AX
   inc SI
   push SI
   call far _malloc
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   or DX,AX
   jz L29f8004c
   push SI
   push [BP+08]
   push [BP+06]
   push [BP-02]
   push [BP-04]
   call far _memcpy
   add SP,+0A
L29f8004c:
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L29f80054
L29f80054:
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 29fd ;; STRUPR
_strupr: ;; 29fd0009
   push BP
   mov BP,SP
   push SI
   cld
   push DS
   lds SI,[BP+06]
   mov DX,SI
jmp near L29fd0021
L29fd0016:
   sub AL,61
   cmp AL,19
   ja L29fd0021
   add AL,41
   mov [SI-01],AL
L29fd0021:
   lodsb
   and AL,AL
   jnz L29fd0016
   mov AX,DX
   mov DX,DS
   pop DS
   pop SI
   pop BP
ret far

Segment 29ff ;; TOUPPER
_toupper: ;; 29ff000e
   push BP
   mov BP,SP
   cmp word ptr [BP+06],-01
   jnz L29ff001c
   mov AX,FFFF
jmp near L29ff003d
L29ff001c:
   mov AL,[BP+06]
   mov AH,00
   mov BX,AX
   test byte ptr [BX+offset __ctype+01],08
   jz L29ff0036
   mov AL,[BP+06]
   mov AH,00
   add AX,FFE0
jmp near L29ff003d
X29ff0034:
jmp near L29ff003d
L29ff0036:
   mov AL,[BP+06]
   mov AH,00
jmp near L29ff003d
L29ff003d:
   pop BP
ret far

Segment 2a02 ;; VRAM
__VPTR: ;; 2a02000f
   push BP
   mov BP,SP
   mov AX,[BP+06]
   dec AX
   mov DL,[offset __video+08]
   mov DH,00
   mul DX
   add AX,[offset __video+0b]
   mov DX,[BP+08]
   dec DX
   add AX,DX
   shl AX,1
   mov DX,[offset __video+0d]
jmp near L2a020030
L2a020030:
   pop BP
ret far 0004

__VRAM: ;; 2a020034
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov AL,[offset __video+0a]
   mov AH,00
   mov [BP-02],AX
   push DS
   mov CX,[BP+06]
   jcxz L2a0200a4
   les DI,[BP+0C]
   lds SI,[BP+08]
   cld
   cmp SI,DI
   jnb L2a02005f
   mov AX,CX
   dec AX
   shl AX,1
   add SI,AX
   add DI,AX
   std
L2a02005f:
   cmp word ptr [BP-02],+00
   jnz L2a020069
   repz movsw
jmp near L2a0200a4
L2a020069:
   mov DX,03DA
   mov AX,ES
   mov BX,DS
   cmp AX,BX
   jz L2a020085
L2a020074:
   cli
L2a020075:
   in AL,DX
   ror AL,1
   jb L2a020075
L2a02007a:
   in AL,DX
   ror AL,1
   jnb L2a02007a
   movsw
   sti
   loop L2a020074
jmp near L2a0200a4
L2a020085:
   cli
L2a020086:
   in AL,DX
   ror AL,1
   jb L2a020086
L2a02008b:
   in AL,DX
   ror AL,1
   jnb L2a02008b
   lodsw
   sti
   mov BX,AX
L2a020094:
   in AL,DX
   ror AL,1
   jb L2a020094
L2a020099:
   in AL,DX
   ror AL,1
   jnb L2a020099
   mov AX,BX
   stosw
   sti
   loop L2a020085
L2a0200a4:
   cld
   pop DS
jmp near L2a0200a8
L2a0200a8:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far 000A

Segment 2a0d ;; WHEREXY
__wherexy: ;; 2a0d0000
   mov AH,03
   mov BH,00
   call far __VideoInt
   mov AX,DX
jmp near L2a0d000d
L2a0d000d:
ret far

_wherex: ;; 2a0d000e ;; (@) Unaccessed.
   push CS
   call near offset __wherexy
   mov AH,00
   mov DL,[offset __video]
   mov DH,00
   sub AX,DX
   inc AX
jmp near L2a0d001f
L2a0d001f:
ret far

_wherey: ;; 2a0d0020 ;; (@) Unaccessed.
   push CS
   call near offset __wherexy
   mov CL,08
   shr AX,CL
   mov AH,00
   mov DL,[offset __video+01]
   mov DH,00
   sub AX,DX
   inc AX
jmp near L2a0d0035
L2a0d0035:
ret far

Segment 2a10 ;; WINDOW
_window: ;; 2a100006
   push BP
   mov BP,SP
   dec word ptr [BP+06]
   dec word ptr [BP+0A]
   dec word ptr [BP+08]
   dec word ptr [BP+0C]
   cmp word ptr [BP+06],+00
   jl L2a100045
   mov AL,[offset __video+08]
   mov AH,00
   cmp AX,[BP+0A]
   jle L2a100045
   cmp word ptr [BP+08],+00
   jl L2a100045
   mov AL,[offset __video+07]
   mov AH,00
   cmp AX,[BP+0C]
   jle L2a100045
   mov AX,[BP+0A]
   sub AX,[BP+06]
   jl L2a100045
   mov AX,[BP+0C]
   sub AX,[BP+08]
   jge L2a100047
L2a100045:
jmp near L2a10006e
L2a100047:
   mov AL,[BP+06]
   mov [offset __video],AL
   mov AL,[BP+0A]
   mov [offset __video+02],AL
   mov AL,[BP+08]
   mov [offset __video+01],AL
   mov AL,[BP+0C]
   mov [offset __video+03],AL
   mov DL,[BP+06]
   mov DH,[BP+08]
   mov AH,02
   mov BH,00
   call far __VideoInt
L2a10006e:
   pop BP
ret far

Segment 2a17 ;; Data And BSS Areas
;; Data Area
A2a170000:
Y2a170000:	dword
Y2a170004:	db "Turbo-C - Copyright (c) 1988 Borland Intl.",00
Y2a17002f:	db "Divide error\r\n"
Y2a17003d:	db "Abnormal program termination\r\n"
__Int0Vector:	dword	;; 2a17005b
__Int4Vector:	dword	;; 2a17005f
__Int5Vector:	dword	;; 2a170063
__Int6Vector:	dword	;; 2a170067
__argc:		word	;; 2a17006b
__argv:		dword	;; 2a17006d
_environ:	dword	;; 2a170071
__envLng:	word	;; 2a170075
__envseg:	word	;; 2a170077
__envSize:	word	;; 2a170079
__psp:		word	;; 2a17007b
__version:	;; 2a17007d
__osmajor:	byte	;; 2a17007d
__osminor:	byte	;; 2a17007e	;; (@) Unaccessed. Aliased through __version.
_errno:		word	;; 2a17007f
__8087:		word	;; 2a170081
__StartTime:	dword	;; 2a170083
__heapbase:	dword	;; 2a170087
__brklvl:	dword	;; 2a17008b
__heaptop:	dword	;; 2a17008f
X2a170093:	byte	;; 2a170093	;; (@) Unaccessed; alignment padding?
_egatab:	;; 2a170094 ;; 00-0f match _vgapal entries 00-0f.
		db 00,01,02,03,04,05,06,07,08,09,0a,0b,0c,0d,0e,0f
		db 00,08,08,07,07,07,0f,0f,00,04,0c,0c,08,08,02,06
		db 06,0c,02,02,02,06,06,0e,02,02,02,02,06,0e,0a,0a
		db 0a,0e,0e,0a,0a,0a,0e,0e,00,00,00,04,04,05,00,00
		db 00,04,0c,0c,08,08,07,06,04,0c,02,02,02,06,06,06
		db 02,02,02,02,06,06,0a,0a,0a,0e,0e,0a,0a,0a,0e,0e
		db 00,00,04,04,0c,0c,00,00,04,04,0c,0c,08,08,08,06
		db 06,0c,02,02,08,08,06,06,02,02,02,02,06,06,0a,0a
		db 0a,0e,0e,09,09,09,0e,0e,01,01,05,05,04,02,01,01
		db 05,05,0d,0d,01,01,08,05,05,0c,03,03,07,07,07,0c
		db 03,03,03,07,07,0e,02,02,03,07,07,0a,0a,0a,0e,0e
		db 01,01,01,05,0d,0d,01,01,01,05,0d,0d,01,01,05,05
		db 0d,0d,09,09,09,05,05,0e,03,03,03,07,07,0f,04,04
		db 0b,07,07,0b,0b,0b,0f,0f,09,09,09,05,0d,0d,09,09
		db 09,05,0d,0d,09,09,09,05,05,0d,09,09,09,09,05,0d
		db 0b,0b,03,03,0d,0d,0b,0b,0d,0f,0d,0d,0d,0f,0f,00
_vgapal:	;; 2a170194 ;; Format: RR,GG,BB
		db 00,00,00, 00,00,2a, 00,2a,00, 00,2a,2a, 2a,00,00, 2a,00,2a, 2a,15,00, 2a,2a,2a
		db 15,15,15, 15,15,3f, 15,3f,15, 15,3f,3f, 3f,15,15, 3f,15,3f, 3f,3f,15, 3f,3f,3f
		db 07,07,07, 0e,0e,0e, 1b,1b,1b, 20,20,20, 25,25,25, 2f,2f,2f, 34,34,34, 39,39,39
		db 19,0a,00, 25,0a,00, 32,0a,00, 3f,0a,00, 00,15,00, 0c,15,00, 19,15,00, 25,15,00
		db 32,15,00, 3f,15,00, 00,1f,00, 0c,1f,00, 19,1f,00, 25,1f,00, 32,1f,00, 3f,1f,00
		db 00,2a,00, 0c,2a,00, 19,2a,00, 25,2a,00, 32,2a,00, 3f,2a,00, 0c,34,00, 19,34,00
		db 25,34,00, 32,34,00, 3f,34,00, 0c,3f,00, 19,3f,00, 25,3f,00, 32,3f,00, 3f,3f,00
		db 00,00,0c, 0c,00,0c, 19,00,0c, 25,00,0c, 32,00,0c, 3f,00,0c, 00,0a,0c, 0c,0a,0c
		db 19,0a,0c, 25,0a,0c, 32,0a,0c, 3f,0a,0c, 00,15,0c, 0c,15,0c, 19,15,0c, 25,15,0c
		db 32,15,0c, 3f,15,0c, 00,1f,0c, 0c,1f,0c, 19,1f,0c, 25,1f,0c, 32,1f,0c, 3f,1f,0c
		db 00,2a,0c, 0c,2a,0c, 19,2a,0c, 25,2a,0c, 32,2a,0c, 3f,2a,0c, 0c,34,0c, 19,34,0c
		db 25,34,0c, 32,34,0c, 3f,34,0c, 0c,3f,0c, 19,3f,0c, 25,3f,0c, 32,3f,0c, 3f,3f,0c
		db 00,00,19, 0c,00,19, 19,00,19, 25,00,19, 32,00,19, 3f,00,19, 00,0a,19, 0c,0a,19
		db 19,0a,19, 25,0a,19, 32,0a,19, 3f,0a,19, 00,15,19, 0c,15,19, 19,15,19, 25,15,19
		db 32,15,19, 3f,15,19, 00,1f,19, 0c,1f,19, 19,1f,19, 25,1f,19, 32,1f,19, 3f,1f,19
		db 00,2a,19, 0c,2a,19, 19,2a,19, 25,2a,19, 32,2a,19, 3f,2a,19, 0c,34,19, 19,34,19
		db 25,34,19, 32,34,19, 3f,34,19, 0c,3f,19, 19,3f,19, 25,3f,19, 32,3f,19, 3f,3f,19
		db 00,00,25, 0c,00,25, 19,00,25, 25,00,25, 32,00,25, 3f,00,25, 00,0a,25, 0c,0a,25
		db 19,0a,25, 25,0a,25, 32,0a,25, 3f,0a,25, 00,15,25, 0c,15,25, 19,15,25, 25,15,25
		db 32,15,25, 3f,15,25, 00,1f,25, 0c,1f,25, 19,1f,25, 25,1f,25, 32,1f,25, 3f,1f,25
		db 00,2a,25, 0c,2a,25, 19,2a,25, 25,2a,25, 32,2a,25, 3f,2a,25, 0c,34,25, 19,34,25
		db 25,34,25, 32,34,25, 3f,34,25, 0c,3f,25, 19,3f,25, 25,3f,25, 32,3f,25, 3f,3f,25
		db 00,00,32, 0c,00,32, 19,00,32, 25,00,32, 32,00,32, 3f,00,32, 00,0a,32, 0c,0a,32
		db 19,0a,32, 25,0a,32, 32,0a,32, 3f,0a,32, 00,15,32, 0c,15,32, 19,15,32, 25,15,32
		db 32,15,32, 3f,15,32, 00,1f,32, 0c,1f,32, 19,1f,32, 25,1f,32, 32,1f,32, 3f,1f,32
		db 00,2a,32, 0c,2a,32, 19,2a,32, 25,2a,32, 32,2a,32, 3f,2a,32, 0c,34,32, 19,34,32
		db 25,34,32, 32,34,32, 3f,34,32, 0c,3f,32, 19,3f,32, 25,3f,32, 32,3f,32, 3f,3f,32
		db 00,00,3f, 0c,00,3f, 19,00,3f, 25,00,3f, 32,00,3f, 3f,00,3f, 00,0a,3f, 0c,0a,3f
		db 19,0a,3f, 25,0a,3f, 32,0a,3f, 3f,0a,3f, 00,15,3f, 0c,15,3f, 19,15,3f, 25,15,3f
		db 32,15,3f, 3f,15,3f, 00,1f,3f, 0c,1f,3f, 19,1f,3f, 25,1f,3f, 32,1f,3f, 3f,1f,3f
		db 00,2a,3f, 0c,2a,3f, 19,2a,3f, 25,2a,3f, 32,2a,3f, 3f,2a,3f, 0c,34,3f, 19,34,3f
		db 25,34,3f, 32,34,3f, 3f,34,3f, 0c,3f,3f, 19,3f,3f, 25,3f,3f, 32,3f,3f, 3f,3f,3f
_DacWrite:	dw 03c8	;; 2a170494
_DacRead:	dw 03c7	;; 2a170496
_DacData:	dw 03c9	;; 2a170498
_input_status_1:	dw 03da	;; 2a17049a	;; (@) Unaccessed.
_vbi_mask:	dw 0008	;; 2a17049c
Y2a17049e:	db "\r\nVideo mode: C)ga E)ga V)ga? ",00
X2a1704bd:	byte	;; (@) Unaccessed; alignment padding?
Y2a1704be:	db " ",00
_systime:	dword	;; 2a1704c0
_macptr:	dword	;; 2a1704c4
Y2a1704c8:	word	;; 2a1704c8	;; CtrlTime	;; Local to _checkctrl0
Y2a1704ca:	word	;; 2a1704ca	;; ExDx1	;; Local to _recmac
Y2a1704cc:	word	;; 2a1704cc	;; ExDy1	;; Local to _recmac
Y2a1704ce:	word	;; 2a1704ce	;; ExFire1	;; Local to _recmac
Y2a1704d0:	word	;; 2a1704d0	;; ExFire2	;; Local to _recmac
Y2a1704d2:	word	;; 2a1704d2	;; ExGameOut	;; Local to _recmac
Y2a1704d4:	db "\r\n",00
Y2a1704d7:	db "\r\nJoystick calibration:  Press ESCAPE to abort.\r\n",00
Y2a170509:	db "  Center joystick and press button: ",00
Y2a17052e:	db "  Move joystick to UPPER LEFT corner and press button: ",00
Y2a170566:	db "  Move joystick to LOWER RIGHT corner and press button: ",00
Y2a17059f:	db "  Calibration failed - try again (y/N)? ",00
Y2a1705c8:	db "\r\n",00
Y2a1705cb:	db "\r\nGame controller:  K)eyboard,  J)oystick?  ",00
Y2a1705f8:	db "\r\n",00,00
_path:		ds 0040	;; 2a1705fc
_nosnd:		word	;; 2a17063c
_cfgdemo:	word	;; 2a17063e
Y2a170640:	db "\r\n\r\nDetecting your hardward...\r\n",00
Y2a170661:	db "\r\nIf your system locks, reboot and type:\r\n",00
Y2a17068c:	db "   ",00
Y2a170690:	db " /NOSB  (No Sound Blaster card)\r\n",00
Y2a1706b2:	db "   ",00
Y2a1706b6:	db " /SB    (With a Sound Blaster)\r\n",00
Y2a1706d7:	db "   ",00
Y2a1706db:	db " /NOSND (If all else fails)\r\n",00
Y2a1706f9:	db "/TEST",00
Y2a1706ff:	db "/NOSB",00
Y2a170705:	db "/SB",00
Y2a170709:	db "/NOSND",00
Y2a170710:	db "/DEMO",00
Y2a170716:	db "\r\n",00
Y2a170719:	db " Your configuration:\r\n",00
Y2a170730:	db "    Digital Sound Blaster sound effects ON\r\n",00
Y2a17075d:	db "    No digitized sound effects\r\n",00
Y2a17077e:	db "    Sound Blaster musical sound track ON\r\n",00
Y2a1707a9:	db "    No musical sound track\r\n",00
Y2a1707c6:	db "    A joystick\r\n",00
Y2a1707d7:	db "    No joystick\r\n",00
Y2a1707e9:	db "    CGA graphics (You're missing some\r\n",00
Y2a170811:	db "    hot 256-color VGA scenery!)\r\n",00
Y2a170833:	db "    16-color EGA graphics\r\n",00
Y2a17084f:	db "    256-color VGA graphics\r\n",00
Y2a17086c:	db "\r\n",00
Y2a17086f:	db "  Press ENTER if this is correct\r\n",00
Y2a170892:	db "      or press 'C' to configure: ",00
Y2a1708b4:	db "\r\n",00
Y2a1708b7:	db " No Sound Blaster-compatible music card has been\r\n",00
Y2a1708ea:	db " detected.\r\n\r\n",00
Y2a1708f9:	db " Press any key to continue...",00
Y2a170917:	db "\r\n\r\n",00
Y2a17091c:	db " A Sound Blaster card was detected, but your CPU is\r\n",00
Y2a170952:	db " too slow to support digitized sound.  Digital sound\r\n",00
Y2a170989:	db " is now OFF.\r\n\r\n",00
Y2a17099a:	db " Press any key to continue...",00
Y2a1709b8:	db " A Sound Blaster card has been detected.\r\n\r\n",00
Y2a1709e5:	db " This game will play high-quality digital sound\r\n",00
Y2a170a17:	db " through your Sound Blaster if you wish.\r\n\r\n",00
Y2a170a44:	db " Warning:  There's a teeny chance this will cause\r\n",00
Y2a170a78:	db " problems if you have less than 640K of RAM, or\r\n",00
Y2a170aaa:	db " if your computer is not totally compatible.\r\n\r\n",00
Y2a170adb:	db " Do you want digital sound? ",00
Y2a170af8:	db "\r\n\r\n\r\n",00
Y2a170aff:	db " This game features a Sound Blaster-compatible\r\n",00
Y2a170b30:	db " musical sound track.\r\n\r\n\r\n",00
Y2a170b4c:	db " Do you want the musical sound track? ",00
Y2a170b73:	db "\r\n",00
Y2a170b76:	db "\r\n",00
Y2a170b79:	db " Please tell us about your graphics:\r\n",00
Y2a170ba0:	db "     CGA 4-color graphics\r\n",00
Y2a170bbc:	db "     EGA 16-color graphics\r\n",00
Y2a170bd9:	db "     VGA 256-color graphics\r\n",00
Y2a170bf7:	db "\r\n",00
Y2a170bfa:	db " Note: If you have a slow old computer, CGA\r\n",00
Y2a170c28:	db "       graphics are recommended.\r\n",00
X2a170c4b:	byte	;; (@) Unaccessed; alignment padding?
Y2a170c4c:	db "\screen",00
Y2a170c54:	db ".RAW",00
Y2a170c59:	db "\screen",00
Y2a170c61:	db ".MAP",00
Y2a170c66:	db " ",00
Y2a170c68:	db " ",00
Y2a170c6a:	db "\r\n",00
X2a170c6d:	byte	;; 2a170c6d	;; (@) Unaccessed; alignment padding?
_soundoff:	dw 0001	;; 2a170c6e
_soundf:	dw 0001	;; 2a170c70
_makesound:	word	;; 2a170c72
_myclock:	dd Y0040006c	;; 2a170c74
_SetDSP:	word	;; 2a170c78
_SetWORX:	word	;; 2a170c7a
_vocuse:	word	;; 2a170c7c
_freq:		dword	;; 2a170c7e
_dur:		dword	;; 2a170c82
_headersize:	dw 0280	;; 2a170c86
_vocflag:	dw 0001	;; 2a170c88
_musicflag:	dw 0001	;; 2a170c8a
_vocfilehandle:	dw ffff	;; 2a170c8c
_song:		dword	;; 2a170c8e
_oldint8:	dword	;; 2a170c92
_worxint8:	dword	;; 2a170c96
_vochdr:	;; 2a170c9a
		db "Creative Voice File",1a,1a,00,0a,01,29,11,01,5d,2d,00,aa,00
_notetable:	;; 2a170cba
		dw 0040,0043,0047,004c,0050,0055,005a,005f,0065,006b,0072,0079,0000,0000,0000,0000
		dw 0080,0087,008f,0098,00a1,00aa,00b5,00bf,00cb,00d7,00e4,00f2,0000,0000,0000,0000
		dw 0100,010f,011f,0130,0142,0155,016a,017f,0196,01ae,01c8,01e3,0000,0000,0000,0000
		dw 0200,021e,023e,0260,0285,02ab,02d4,02ff,032c,035d,0390,03c7,0000,0000,0000,0000
		dw 0400,043c,047d,04c1,050a,0556,05a8,05fe,0659,06ba,0721,078d,0000,0000,0000,0000
		dw 0800,0879,08fa,0983,0a14,0aad,0b50,0bfc,0cb2,0d74,0e41,0f1a,0000,0000,0000,0000
		dw 1000,10f3,11f5,1306,1428,155b,16a0,17f9,1965,1ae8,1c82,1e34,0000,0000,0000,0000
		dw 2000,21e7,23eb,260d,2851,2ab7,2d41,2ff2,32cb,35d1,3904,3d1e,0000,0000,0000,0000
		dw 4000,43ce,47d6,4c1b,50a2,556e,5a82,5fe4,6597,6ba2,7208,78d0,0000,0000,0000,0000
Y2a170dda:	db "AUDIO.EPC",00 ;; 2a170dda
_first_nokey:	dw 0001	;; 2a170de4
_first_opendoor:	dw 0001	;; 2a170de6
_first_apple:	dw 0001	;; 2a170de8
_first_knife:	dw 0001	;; 2a170dea
_first_key:	dw 0001	;; 2a170dec
_first_openmapdoor:	dw 0001	;; 2a170dee
_first_nogem:	dw 0001	;; 2a170df0
Y2a170df2:	dw 0000,0001,0002,0001				;; 2a170df2 ;; FlySeq0
Y2a170dfa:	dw 0001,0002,0001,0000,ffff,fffe,ffff,0000	;; 2a170dfa ;; FlySeq1
Y2a170e0a:	dw 0000,0001,0002,0003,0002,0001,0009,0009	;; 2a170e0a ;; FloatSeq
Y2a170e1a:	dw 0004,0004,0004,0004,0004,0004,ffff,ffff	;; 2a170e1a ;; PhoenixSeq
Y2a170e2a:	dw 0000,0001,0002,0003,0002,0001		;; 2a170e2a ;; DemonSeq
Y2a170e36:	dw 0000,0001,0002,0001				;; 2a170e36 ;; FatSoSeq
Y2a170e3e:	db "PLAYER",00
Y2a170e45:	db "APPLE",00
Y2a170e4b:	db "KNIFE",00
Y2a170e51:	db "KILLME",00
Y2a170e58:	db "BIGANT",00
Y2a170e5f:	db "FLY",00
Y2a170e63:	db "MACROTRIG",00
Y2a170e6d:	db "DEMON",00
Y2a170e73:	db "BUNNY",00
Y2a170e79:	db "INCHWORM",00
Y2a170e82:	db "ZAPPER",00
Y2a170e89:	db "BOBSLUG",00
Y2a170e91:	db "CHECKPT",00
Y2a170e99:	db "PAUL",00
Y2a170e9e:	db "KEY",00
Y2a170ea2:	db "PAD",00
Y2a170ea6:	db "WISEMAN",00
Y2a170eae:	db "FATSO",00
Y2a170eb4:	db "FIREBALL",00
Y2a170ebd:	db "CLOUD",00
Y2a170ec3:	db "TEXT6",00
Y2a170ec9:	db "TEXT8",00
Y2a170ecf:	db "FROG",00
Y2a170ed4:	db "TINY",00
Y2a170ed9:	db "DOOR",00
Y2a170ede:	db "FALLDOOR",00
Y2a170ee7:	db "BRIDGER",00
Y2a170eef:	db "SCORE",00
Y2a170ef5:	db "TOKEN",00
Y2a170efb:	db "ANT",00
Y2a170eff:	db "PHOENIX",00
Y2a170f07:	db "FIRE",00
Y2a170f0c:	db "SWITCH",00
Y2a170f13:	db "GEM",00
Y2a170f17:	db "TXTMSG",00
Y2a170f1e:	db "BOULDER",00
Y2a170f26:	db "EXPL1",00
Y2a170f2c:	db "EXPL2",00
Y2a170f32:	db "STALAG",00
Y2a170f39:	db "SNAKE",00
Y2a170f3f:	db "SEAROCK",00
Y2a170f47:	db "BOLL",00
Y2a170f4c:	db "MEGA",00
Y2a170f51:	db "BAT",00
Y2a170f55:	db "KNIGHT",00
Y2a170f5c:	db "BEENEST",00
Y2a170f64:	db "BEESWARM",00
Y2a170f6d:	db "CRAB",00
Y2a170f72:	db "CROC",00
Y2a170f77:	db "EPIC",00
Y2a170f7c:	db "SPINBLAD",00
Y2a170f85:	db "SKULL",00
Y2a170f8b:	db "BUTTON",00
Y2a170f92:	db "PAC",00
Y2a170f96:	db "JILLFISH",00
Y2a170f9f:	db "JILLSPIDER",00
Y2a170faa:	db "JILLBIRD",00
Y2a170fb3:	db "JILLFROG",00
Y2a170fbc:	db "BUBBLE",00
Y2a170fc3:	db "JELLYFISH",00
Y2a170fcd:	db "BADFISH",00
Y2a170fd5:	db "ELEV",00
Y2a170fda:	db "FIREBULLET",00
Y2a170fe5:	db "FISHBULLET",00
Y2a170ff0:	db "EYE",00
Y2a170ff4:	db "VINECLIMB",00
Y2a170ffe:	db "FLAG",00
Y2a171003:	db "MAPDEMO",00
Y2a17100b:	db "ROMAN",00
Y2a171011:	db "APPLES GIVE YOU HEALTH",00
Y2a171028:	db "YOU FOUND A KNIFE!",00
Y2a17103b:	db "YOU FOUND A KEY!",00
Y2a17104c:	db "THE GATE OPENS",00
Y2a17105b:	db "YOU NEED A GEM TO PASS",00
Y2a171072:	db "THE DOOR OPENS",00
Y2a171081:	db "THE DOOR IS LOCKED",00
_first_switch:	dw 0001	;; 2a171094
_first_elev:	dw 0001	;; 2a171096
_first_hitknight:	dw 0001	;; 2a171098
_first_touchgem:	dw 0001	;; 2a17109a
_inv_shape:	;; 2a17109c
		dw 0026,000c,000d,000b,000e,000f,0012,0014,0023,0024,0025
_inv_xfm:	;; 2a1710b2
		dw 0001,0000,0000,0000,0001,0001,0000,0001,0000,0000,0000
_inv_getmsg:	;; 2a1710c8
		dd Y2a171230,Y2a171236,Y2a17124d,Y2a17125f,Y2a17126f,Y2a171275,Y2a17127f,Y2a17128f
		dd _xblademsg,Y2a171297,Y2a1712ab
_inv_first:	;; 2a1710f4
		dw 0001,0001,0001,0001,ffff,ffff,ffff,ffff,0001,0001,0001
Y2a17110a:	;; 2a17110a ;; Expl2Seq
		dw 0020,001f,001e,001d,001c,001d,001e,001f,0020
Y2a17111c:	;; 2a17111c ;; SnakeSeq0
		dw 0000,0001,0000,0002
Y2a171124:	;; 2a171124 ;; SnakeSeq1
		dw 0003,0005,0004,0006
Y2a17112c:	;; 2a17112c ;; SnakeSeq2
		dw 0007,0007,0008,0008
Y2a171134:	;; 2a171134 ;; BollSeq
		dw 0004,0006,0008,000a,000c,000e
Y2a171140:	;; 2a171140 ;; BatSeq0
		dw 0000,0008,0000,0008
Y2a171148:	;; 2a171148 ;; BatSeq1
		dw 0001,0002,0003,0002
Y2a171150:	;; 2a171150 ;; KnightSeq0
		dw 0008,0008,0000,0000,0000,0000,0000,0000,0000,0000,0008
Y2a171166:	;; 2a171166 ;; KnightSeq1
		dw 0000,0000,0001,0002,0003,0004,0004,0003,0002,0001,0000
Y2a17117c:	;; 2a17117c ;; BeeSwarmSeq
		dw 0000,0000,0000,0000,0001,0001,0001,0001
		dw 0002,0002,0002,0002,0003,0003,0003,0003
		dw 0003,0003,0003,0003,0003,0002,0002,0002
		dw 0002,0001,0001,0001,0001,0000,0000,0000
Y2a1711bc:	;; 2a1711bc ;; CrocSeq0
		dw 0004,0005,0006,0007
Y2a1711c4:	;; 2a1711c4 ;; CrocSeq1
		dw 0000,0001,0002,0003
Y2a1711cc:	;; 2a1711cc ;; SkullSeq0
		dw 0003,0004,0005,0006,0007,0006,0005,0004
Y2a1711dc:	;; 2a1711dc ;; SkullSeq1
		dw 0000,0001,0002,0001
Y2a1711e4:	;; 2a1711e4 ;; JellyFishSeq
		dw 0009,000a,000b,000c,000d,000e,000d,000c,000b,000a 2a17110a ;;
Y2a1711f8:	;; 2a1711f8 ;; BadFishSeq
		dw 0000,0001,0002,0001
Y2a171200:	;; 2a171200 ;; FireBulletSeq
		dw 0003,0002,0001,0001,0000,ffff,ffff,fffe
		dw fffe,fffd,fffd,fffe,fffe,ffff,ffff,0000
		dw 0001,0001,0002,0003
Y2a171228:	;; 2a171228 ;; MapSeq0
		dw 0010,0014
Y2a17122c:	;; 2a17122c ;; MapSeq1
		dw 0004,0003
Y2a171230:	db "FOOF!",00
Y2a171236:	db "USE KEYS TO OPEN DOORS",00
Y2a17124d:	db "YOU FOUND A KNIFE",00
Y2a17125f:	db "YOU FOUND A GEM",00
Y2a17126f:	db "POOF!",00
Y2a171275:	db "ZZZZZZZT!",00
Y2a17127f:	db "A BAG OF COINS!",00
Y2a17128f:	db "KABOOM!",00
Y2a171297:	db "EXTRA JUMPING POWER",00
Y2a1712ab:	db "SHIELD OF INVINCIBILITY",00
Y2a1712c3:	db "Press UP/DOWN to toggle switch",00
Y2a1712e2:	db "USE GEMS TO OPEN DOORS ON THE MAP",00
Y2a171304:	db "YOUR FEEBLE ATTEMPT FAILS.",00
Y2a17131f:	db "Press UP/DOWN to use elevator",00,00
_blinkshtab:	;; 2a17133e
		dw 0008,0008,0008,0008,0009,000a,000b,000c,0026,0026,0026,0026,0026,000b,000a,0009
_pooftab:	;; 2a17135e
		dw ffff,fffe,ffff,0000
_fidgetseq:	;; 2a171366
		dw 0013,0013,0013,0013
		dw 0013,0010,0012,0010
		dw 0013,0010,0012,0010
		dw 0012,0012,0012,0012
Y2a171386:	;; 2a171386 ;; PlayerSeq0
		db 18,18,19,1a,1a,19,19
Y2a17138d:	;; 2a17138d ;; PlayerSeq1
		db 04,00,00,06,04,04,00
Y2a171394:	;; 2a171394 ;; PlayerSeq2
		db 48,49,48,49,48,48,49,48,49,49,48,48,48,49,49,49,4a,4a,4a,4a,4a
Y2a1713a9:	;; 2a1713a9 ;; FishSeq
		dw 0000,0001,0002,0001
Y2a1713b1:	;; 2a1713b1 ;; BirdSeq
		dw 0000,0001,0002,0003,0002,0001
X2a1713bd:	byte	;; 2a1713bd	;; (@) Unaccessed; alignment padding?
__stklen:	dw 1000	;; 2a1713be
_debug:		word	;; 2a1713c0
_swrite:	word	;; 2a1713c2
_designflag:	word	;; 2a1713c4
_turtle:	word	;; 2a1713c6
_mirrortab:	;; 2a1713c8
		db 00,00,00,00,00,00,00,17,00,1c,00,00,00,18,1c,00
		db 00,00,00,00,30,00,00,00,00,00,05,30,00,17,18,12
		db 10,00,03,00,0c,00,08,00,29,00,20,08,18,0a,00,23
		db 00,30
Y2a1713fa:	word	;; 2a1713fa ;; Moves ;; Local to loadsavewin().
Y2a1713fc:	;; 2a1713fc ;; QwertyTab ;; Local to noisemaker().
		db "1234567890-="
		db "QWERTYUIOP[]"
		db "ASDFGHJKL;'"
		db "ZXCVBNM,./"
		db 01,02,03,04,05,06
		db 00
Y2a171430:	db "JUMP   ",00
Y2a171438:	db "KNIFE  ",00
Y2a171440:	db "       ",00
Y2a171448:	db "       ",00
Y2a171450:	db "       ",00
Y2a171458:	db "FLAP   ",00
Y2a171460:	db "FIRE   ",00
Y2a171468:	db "HOP    ",00
Y2a171470:	db "LEAP   ",00
Y2a171478:	db "SWIM   ",00
Y2a171480:	db "SHOOT  ",00
Y2a171488:	db "       ",00
Y2a171490:	db "       ",00
Y2a171498:	db "____________",00
Y2a1714a5:	db "Help",00
Y2a1714aa:	db "N",00
Y2a1714ac:	db "Q",00
Y2a1714ae:	db "S",00
Y2a1714b0:	db "R",00
Y2a1714b2:	db "T",00
Y2a1714b4:	db "NOISE",00
Y2a1714ba:	db "QUIT",00
Y2a1714bf:	db "SAVE",00
Y2a1714c4:	db "RESTORE",00
Y2a1714cc:	db "TURTLE",00
Y2a1714d3:	db "HEALTH",00
Y2a1714da:	db "SCORE",00
Y2a1714e0:	db "LEVEL",00
Y2a1714e6:	db "MAP",00
Y2a1714ea:	db "     ",00
Y2a1714f0:	db "                                    ",00
Y2a171515:	db "PRESS F1 FOR HELP!",00
Y2a171528:	db "YOU LEFT WITHOUT FINDING A GEM!",00
Y2a171548:	db "temp.mac",00
Y2a171551:	db "temp.mac",00
Y2a17155a:	db "A NEW RELEASE FROM",00
Y2a17156d:	db "PRODUCED BY",00
Y2a171579:	db "NOW LOADING, PLEASE WAIT...",00
Y2a171595:	db "____________",00
Y2a1715a2:	db "HI SCORES",00
Y2a1715ac:	db "____________",00
Y2a1715b9:	db "____________",00
Y2a1715c6:	db "PRESS",00
Y2a1715cc:	db "TO ABORT",00
Y2a1715d5:	db "ESCAPE",00
Y2a1715dc:	db " ",00
Y2a1715de:	db "LOAD GAME",00
Y2a1715e8:	db "<empty>",00
Y2a1715f0:	db ".",00
Y2a1715f2:	db "m.",00
Y2a1715f5:	db "SAVE GAME",00
Y2a1715ff:	db "",00
Y2a171600:	db ".",00
Y2a171602:	db "m.",00
Y2a171605:	db "INVENTORY",00
Y2a17160f:	db "CONTROLS",00
Y2a171618:	;; 2a171618 ;; QuitMenu1
		db "7REALLY QUIT?\r4YES\r2NO\r",00
Y2a171630:	;; 2a171630 ;; QuitMenu2
		db "YN",00
Y2a171633:	db "temp",00
Y2a171638:	db " Yikes!  An error has occured.  Please report this code:  ",00
Y2a171673:	db "-",00
Y2a171675:	db "\r\n",00
Y2a171678:	db "\r\n",00
Y2a17167b:	db "\r\n\r\n",00
Y2a171680:	db "   Problem: You don't have enough free RAM to run this game properly.\r\n",00
Y2a1716c8:	db " Solutions: Boot from a blank floppy disk\r\n",00
Y2a1716f4:	db "            Run this game without any TSR's in memory\r\n",00
Y2a17172c:	db "            Buy more memory (640K is required)\r\n",00
Y2a17175d:	db "            Turn off the digital Sound Blaster effects -- they eat up RAM\r\n",00
Y2a1717a9:	db " The problem may be due to not enough free RAM or disk space.",00
X2a1717e7:	byte	;; 2a1717e7	;; (@) Unaccessed; alignment padding?
Y2a1717e8:	word	;; 2a1717e8	;; Local to _initinfo
Y2a1717ea:	word	;; 2a1717ea	;; ObjX ;; Local to _objdesign
Y2a1717ec:	db "kind:            ",00
Y2a1717fe:	db "stat:            ",00
Y2a171810:	db "  xd:            ",00
Y2a171822:	db "  yd:            ",00
Y2a171834:	db " cnt:            ",00
Y2a171846:	db "Text Inside",00
Y2a171852:	db "NONE",00
Y2a171857:	db "obj:Add Oov",00
Y2a171863:	db " Del Paste",00
Y2a17186e:	db " Kopy Mod",00
Y2a171878:	db "Kind:",00
Y2a17187e:	db "Put:",00
Y2a171883:	db "Clear?",00
Y2a17188a:	db "Load:",00
Y2a171890:	db "Dis Y:",00
Y2a171897:	db "New board?",00
Y2a1718a2:	db "Save:",00
_xdemoflag:	word	;; 2a1718a8
_pgmname:	db "JILL1",00		;; 2a1718aa
_xshafile:	db "jill1.sha",00	;; 2a1718b0
_xvocfile:	db "jill1.vcl",00	;; 2a1718ba
_cfgfname:	db "jill1.cfg",00	;; 2a1718c4
_dmafile:	db "jill.dma",00	;; 2a1718ce
_mapboard:	db "map.jn1",00		;; 2a1718d7
_introboard:	db "intro.jn1",00	;; 2a1718df
_xintrosong:	db "funky.ddt",00	;; 2a1718e9
_xknightmsg:	db "The knight slices Jill in half",00	;; 2a1718f3
_xmsgdelay:	word	;; 2a171912
_xblademsg:	db "YOU FIND A SPINNING BLADE",00	;; 2a171914
_xbladename:	db "BLADE  ",00		;; 2a17192e
_savepfx:	db "jn1save",00		;; 2a171936
_erroraddr:	db " Epic MegaGames, 10406 Holbrook Drive, Potomac MD 20854",00	;; 2a17193e
_facetable:	dw 0018	;; 2a171976
_xstartlevel:	dw 007f	;; 2a171978
_xbordercol:	dw 0001	;; 2a17197a
_menu1:		;; 2a17197c
		db '7', "PICK A CHOICE:\r"
		db '2', "PLAY\r"
		db '2', "RESTORE\r"
		db '5', "STORY\r"
		db '5', "INSTRUCTIONS\r"
		db '5', "ORDERING INFO\r"
		db '5', "CREDITS\r"
		db '3', "DEMO\r"
		db '3', "NOISEMAKER\r"
		db '6', "EPIC'S BBS\r"
		db '4', "QUIT\r"
		db 00
_menu2:		db "PRSIOCDNEQ",05,10,00	;; 2a1719ed
_menuc:		dw 000a				;; 2a1719fa
_demoboard:	;; 2a1719fc
		dd Y2a17272d,Y2a172737,Y2a172738,Y2a172739,Y2a17273a,Y2a17273b,Y2a17273c,Y2a17273d,Y2a17273e,Y2a17273f
_demolvl:	;; 2a171a24
		db 64,00,00,00,00,00,00,00,00,00
_demoname:	;; 2a171a2e
		dd Y2a172740,Y2a17274c,Y2a17274d,Y2a17274e,Y2a17274f,Y2a172750,Y2a172751,Y2a172752,Y2a172753,Y2a172754

;; The format is determined by the uncrunch routine in the UNCRUNCH segment and is as follows:
;;	Initialize Attr = 0, Beg = ExP
;;	Do the following for InP (with lead byte Ch = *InP):
;;	00-0f (00+Fg): Set Attr[0-3] = Fg
;;	10-17 (10+Bg): Set Attr[4-6] = Bg
;;	18: Carriage return: ExP = Beg += 0x50 words;
;;	19 J: Copy *ExP++ = Attr:' ' J+1 times
;;	1a J Ch: Copy *ExP++ = Attr:Ch J+1 times
;;	1b: Flip Attr[7]: blink on/off
;;	20-ff (Ch): Copy *ExP++ = Attr:Ch
;;	b3 │, b4 ┤, b9: ╣, ba ║, bb ╗, bc ╝, bf ┐
;;	c0 └, c1 ┴, c2 ┬, c3 ├, c4 ─, c5 ┼, c8 ╚, c9 ╔, ca ╩, cb ╦, cc ╠, cd ═, ce ╬
;;	d9 ┘, da ┌, db █, dc ▄, dd ȳ, de Ȳ, df ▀
_JILLB:		;; 2a171a56
		db 03,10,19,19, 0f,dc,dc,dc, 08,dc, 19,07, 0f,dc,dc,dc, 08,dc,"  ", 0f,dc,dc,dc, 08,dc, 18
		db 19,19,0f, db, 07,db,db, 03,db, 19,04, 00,db,"  ", 0f,db, 07,db,db, 03,db,"  ", 0f,db, 07,db,db, 03,db, 18
		db "  ", 0b,"A", 0a,"n ", 0b,"E", 0a,"p", 0b,"i", 0a,"c ", 0e,"M", 0c,"e", 0e,"g", 0c,"a", 0e,"G", 0c,"a", 0e,"m", 0c,"e", 0e,"s"
		db 19,06, 0f,db, 07,db,db, 03,db,"  ", 0f,dc,dc,dc, 08,dc,"  ", 0f,db, 07,db,db, 03,db,"  ", 0f,db, 07,db,db, 03,db
		db 19,03, 0f,"S", 0b,"h", 0f,"a", 0b,"r", 0f,"e", 0b,"w", 0f,"a", 0b,"r", 0f,"e "
		db 0d,"P", 09,"r", 0d,"o", 09,"d", 0d,"u", 09,"c", 0d,"t", 09,"i", 0d,"o", 09,"n", 18
		db 19,14, 0f,1a,04,dc, db, 07,db,db, 03,db,"  ", 0f,db, 07,db,db, 03,db,"  "
		db 0f,db, 07,db,db, 03,db,"  ", 0f,db, 07,db,db, 03,db, 18,19,03, 04,1a,10,dc
		db 0f,db, 07,1a,06,db, 03,db, 04,dc,dc, 0f,db, 07,db,db, 03,db, 04,dc,dc
		db 0f,db, 07,db,db, 03,db, 04,dc,dc, 0f,db, 07,db,db, 03,db, 04,1a,1c,dc, 18
		db 19,03, 14," ", 0c,db, 1a,0e,df, 08,df, 03,1a, 07,df, 0c,df,df, 08,df, 03,df,df,df, 0c,df,df
		db 08,df, 03,df,df,df, 0c,df,df, 08,df, 03,df,df,df, 0c,1a,1a,df,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db," ", 11,19,42, 04,10,db, 0c,14,db, 04,10,db, 18
		db 19,03, 14," ", 0c,db, 0f,dc,dc,dc, 08,dc, 0c,1a,04,dc, 0f,1a,09,dc, 08,dc
		db 0c,1a,0c,dc, 0f,dc,dc,dc, 08,dc, 0c,1a,1f,dc, db, 04,10,db, 18
		db 19,03, df,df, 0f,db, 07,db,db, 03,db, 04,1a,04,df
		db 0f,db, 17," ", 0c,"OF  THE "
		db 03,10,db, 04,1a,0c,df, 0f,db, 07,db,db, 03,db, 04,1a,21,df, 18
		db 19,05, 0f,db, 07,db,db, 03,db, 19,04,08, df, 03,1a,09,df
		db 19,0c, 0f,db, 07,db,db, 03,db,"  ", 0f,db, 17,1a,05,df, 08,13,df, 10,"  "
		db 0b,fe," ", 09,"T", 0d,"i", 09,"m ", 0d,"S", 09,"w", 0d,"e", 09,"e", 0d,"n", 09,"e", 0d,"y", 18
		db 19,05, 0f,db, 07,db,db, 03,db,"  ", 0f,dc,dc, 08,dc," ", 0f,dc,dc, 08,dc,"  ", 0f,1a,04,dc, 08,dc
		db 19,02, 0f,db, 17,1a,04,df, 08,13,df, 10,"  ", 0f,db, 07,db,db, 03,db,"  ", 0f,db, 07,db, 03,db,df,df
		db 0f,db, 07,db, 03,db,"  ", 0d,fe," "
		db 0a,"J", 0c,"o", 0a,"h", 0c,"n ", 0a,"P", 0c,"a", 0a,"l", 0c,"l", 0a,"e", 0c,"t", 0a,"t", 0c,"-"
		db 0a,"P", 0c,"l", 0a,"o", 0c,"w", 0a,"r", 0c,"i", 0a,"g", 0c,"h", 0a,"t", 18
		db 19,05, 0f,db, 07,db,db, 03,db,"  ", 0f,db, 07,db, 03,db," ", 0f,db, 07,db, 03,db,"  ", 0f,db, 07,1a,03,db
		db 03,17,df, 08,13,df, 10,"  ", 0f,db, 07,db, 03,db,df, 0f,db, 07,db, 03,db,"  ", 0f,db, 07,db,db, 03,db,"  "
		db 0f,db, 07,db, 0f,17,1a, 03,df, 07,10,db, 03,db,"  ", 0b,fe," "
		db 09,"D", 0d,"a", 09,"n ", 0d,"F", 09,"r", 0d,"o", 09,"e", 0d,"l", 09,"i", 0d,"c", 09,"h", 18
		db " ", 0f,1a,04,dc, db, 07,db,db, 03,db,"  ", 0f,db, 07,db, 03,db," ", 0f,db, 07,db, 03,db,"  ", 0f,db, 07,db, 03,db,df
		db 0f,db, 07,db, 03,db,"  ", 0f,db, 07,db, 0f,17,df,df,df, 07,10,db, 03,db,"  "
		db 0f,db, 07,db,db, 03,db,"  ", 0f,db, 07,db, 03,db, 19,06, 0d,fe," "
		db 0a,"J", 0c,"o", 0a,"e ", 0c,"H", 0a,"i", 0c,"t", 0a,"c", 0c,"h", 0a,"e", 0c,"n", 0a,"s", 18
		db " ", 0f,db, 07,1a,06,db, 03,db,"  ", 0f,db, 07,db,db, 0f,17,df,df, 07,10,db, 03,db,"  "
		db 0f,db, 07,db, 03,db," ", 0f,db, 07,db, 03,db,"  ", 08,df, 03,1a,03,df, 07,db, 03,db,"  "
		db 0f,db, 07,db,db, 03,db,"  ", 0f,db, 07,db, 0f,17,1a,04,df, 08,13,df, 18
		db 10," ",df, 03,1a,07,df, "  ", 08,df, 03,1a,05,df, "  ", 08,df, 03,df,df," ", 08,df, 03,df,df,"  "
		db 0f,db, 17,1a,03,df, 07,10,db, 03,db,"  ", 08,df, 03,df,df,df,"  ", 08,df, 03,1a,06,df
		db "  ", 0b,"(", 0a,"c", 0b,") E", 0a,"p", 0b,"i", 0a,"c "
		db 0e,"M", 0c,"e", 0e,"g", 0c,"a", 0e,"G", 0c,"a", 0e,"m", 0c,"e", 0e,"s ", 0c,"1", 0e,"9", 0c,"9", 0e,"2", 07,":", 18
		db 19,1d, 08,df, 03,1a,05,df, 19,03
		db 0f,"T", 0b,"h", 0f,"e ", 0d,"N", 09,"e", 0d,"w ", 0f,"N", 0b,"a", 0f,"m", 0b,"e "
		db 0d,"i", 09,"n ", 0f,"C", 0b,"o", 0f,"m", 0b,"p", 0f,"u", 0b,"t", 0f,"e", 0b,"r "
		db 0d,"E", 09,"n", 0d,"t", 09,"e", 0d,"r", 09,"t", 0d,"a", 09,"i", 0d,"n", 09,"m", 0d,"e", 09,"n", 0d,"t", 18
		db 00
_JILLE:		;; 2a171f3b
		db 0c,10,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 18
		db 19,18, 0a,"Thanks for playing Jill of the Jungle ", 0f,"VOLUME I", 0a,".", 18
		db " ", 08,1a,13,dc, 07,dc, 18
		db " ", 08,db, 14," ", 0c,1a,04,dc, 19,0c
		db 08,10,db, 19,02, 09,"If you've enjoyed this game,  please ", 0e,"copy ", 09,"it and give", 18
		db " ", 08,db, 14," ", 0c,db, 19,08, df, 19,06
		db 08,10,db, 19,02, 09,"Jill to all of your friends!  If you have a modem,", 18
		db " ", 08,db, 14," ", 0c,db,df,df,df," ",db,df,df,db," ",de,dd," ",db,df,df,"  "
		db 08,10,db, 19,02, 0e,"upload ", 09,"this game on all of your local bulletin boards", 18
		db " ", 08,db, 14," ", 0c,db, 1a,03,dc, db,dc,dc,db," ",db,db," ",db,dc,dc,"  "
		db 08,10,db, 19,02, 09,"and post messages about it to spread the word.", 18
		db " ", 08,db, 14,19,05, 0c,db, 19,0b, 08,10,db, 18
		db " ", 17,df, 14,1a,12,dc, 10,db, 19,02, 0d,"We are Epic MegaGames and we're here to provide you", 18
		db " ", 09,1a,21,dc, 03,dc, 19,02, 0d,"with top quality computer entertainment.", 18
		db " ", 09,db, 11," ", 03,da,c4,c2,c4,bf, 19,08, da,c4,c4,c4, 19,0d
		db 09,db, 10,19,02, 0d,"Look at our catalog (CATALOG.EXE) for", 18
		db " ", 09,db, 11," ", 03,b3," ",b3," ",b3,da,c4,bf,da,c4,bf,da,c4,bf,b3
		db 19,02, da,c4,bf," ",c2,c2,bf,da,c4,bf,da,c4,c4," "
		db 09,db, 10,19,02, 0d,"information about our other products.", 18
		db " ", 09,db, 11," ", 03,b3, 19,02, b3,b3,c4,d9,b3," ",b3,b3," ",b3,b3," ",c4,bf,b3," ",b3," "
		db 1a,03,b3, c4,d9,c0,c4,bf," ", 09,db, 18
		db 10," ",db, 11," ", 03,b3, 19,02, b3,c0,c4,c4,c0,c4,b3,c0,c4,b3,c0,c4,c4,d9,c0,c4,b3," ",d9," ",d9,c0
		db 1a,03,c4, d9," "
		db 09,db, 10,19,02, "Want more ", 0e,"adventure", 09,"?  You can register", 18
		db " ",db, 11,19,08, 03,c4,c4,d9, 19,14
		db 09,db, 10,19,02, "and order all ",0c,"THREE ", 09,"volumes in the", 18
		db " ", 03,df, 09,1a,21,df, 19,02, "series for ", 0b,"just $30 ", 09,"+ ", 0b,"$2 ", 09,"p&h.  Print", 18
		db "the order form for details (PRINTME) or you can order toll-free by calling", 18
		db 0b,"1-800-972-7434 ", 09,"(orders only!)  Your adventures will lead you through ", 0a,"Jill of", 18
		db "the Jungle", 09,",  ", 0a,"Jill Goes Underground", 09,",  ", 0a,"and Jill Saves the Prince ", 09,"in this Epic", 18
		db "Mega Arcade-Adventure trilogy!", 18
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 18
		db 19,2a, dc, 19,03, 07,"Thanks,", 18
		db 19,28, 0c,dc, 14,df,dc,df, 10,dc, 18
		db 19,29, df, 14,dc, 10,df, 19,02, 0f,"Tim Sweeney ", 07,"(author of Jill)", 18
		db 18
		db 00
_e_len:		word	;; 2a172661
_b_len:		dw 04e4	;; 2a172663
_v_producer:	db "Tim Sweeney",00		;; 2a172665
_v_publisher:	db "Epic MegaGames",00		;; 2a172671
_v_movename:	db "Move Jill",00		;; 2a172680
_v_title:	db "Jill of the Jungle",00	;; 2a17268a
_fidgetmsg:	;; 2a17269d
		dd Y2a172755,Y2a172768,Y2a172786,Y2a1727a3
_leveltxt:	;; 2a1726ad
		dd Y2a1727c0,Y2a1727dd,Y2a1727ff,Y2a17281e,Y2a172833,Y2a172835,Y2a172837,Y2a172854
		dd Y2a17286e,Y2a17288e,Y2a1728ac,Y2a1728d4,Y2a1728f6,Y2a172920,Y2a172940,Y2a172959
		dd Y2a17298a,Y2a17298c,Y2a172990,Y2a172994,Y2a172998,Y2a1729ba,Y2a1729be,Y2a1729c2
		dd Y2a1729c6,Y2a1729ca,Y2a1729ce,Y2a1729d2,Y2a1729d6,Y2a1729da,Y2a1729de,Y2a1729df
Y2a17272d:	db "intro.jn1",00
Y2a172737:	db "",00
Y2a172738:	db "",00
Y2a172739:	db "",00
Y2a17273a:	db "",00
Y2a17273b:	db "",00
Y2a17273c:	db "",00
Y2a17273d:	db "",00
Y2a17273e:	db "",00
Y2a17273f:	db "",00
Y2a172740:	db "jn1demo.mac",00
Y2a17274c:	db "",00
Y2a17274d:	db "",00
Y2a17274e:	db "",00
Y2a17274f:	db "",00
Y2a172750:	db "",00
Y2a172751:	db "",00
Y2a172752:	db "",00
Y2a172753:	db "",00
Y2a172754:	db "",00
Y2a172755:	db "Look, an airplane!",00
Y2a172768:	db "Are you just gonna sit there?",00
Y2a172786:	db "Have you seen Jill anywhere?",00
Y2a1727a3:	db "Hey,  your shoes are untied.",00
Y2a1727c0:	db "JILL ENTERS\rTHE\rJUNGLE MAP.\r",00
Y2a1727dd:	db "JILL BOUNDS\rTHROUGH\rTHE BOULDERS\r",00
Y2a1727ff:	db "JILL JOURNEYS\rINTO\rTHE FOREST\r",00
Y2a17281e:	db "JILL ENTERS\rTHE HUT\r",00
Y2a172833:	db "\r",00
Y2a172835:	db "\r",00
Y2a172837:	db "JILL DASHES INTO\rTHE CASTLE\r",00
Y2a172854:	db "JILL EXPLORES\rTHE FOREST\r",00
Y2a17286e:	db "JILL SNEAKS\rINTO\rARG'S DUNGEON\r",00
Y2a17288e:	db "JILL ENTERS\rTHE\rPHOENIX MAZE\r",00
Y2a1728ac:	db "JILL VENTURES\rINTO THE\rKNIGHT'S PUZZLE\r",00
Y2a1728d4:	db "JILL CREEPS INTO\rTHE DARK FOREST\r",00
Y2a1728f6:	db "JILL SPLASHES INTO\rTHE UNDERGROUND\rRIVER\r",00
Y2a172920:	db "JILL ENTERS\rYET\rANOTHER PUZZLE\r",00
Y2a172940:	db "JILL ENTERS\rTHE PLATEAU\r",00
Y2a172959:	db "JILL REACHES\rTHE ENDING\r\rNOW SIT BACK\rAND ENJOY\r",00
Y2a17298a:	db "\r",00
Y2a17298c:	db "17\r",00
Y2a172990:	db "18\r",00
Y2a172994:	db "19\r",00
Y2a172998:	db "JILL BOUNDS INTO\rTHE BONUS LEVEL\r",00
Y2a1729ba:	db "21\r",00
Y2a1729be:	db "22\r",00
Y2a1729c2:	db "23\r",00
Y2a1729c6:	db "24\r",00
Y2a1729ca:	db "25\r",00
Y2a1729ce:	db "26\r",00
Y2a1729d2:	db "27\r",00
Y2a1729d6:	db "28\r",00
Y2a1729da:	db "29\r",00
Y2a1729de:	db "",00
Y2a1729df:	db "",00
__doserrno:	word	;; 2a1729e0
__dosErrorToSV:	;; 2a1729e2
		db 00,13,02,02,04,05,06,08,08,08,14,15,05,13,ff,16
		db 05,11,02,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff
		db 05,05,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff
		db ff,ff,0f,ff,23,02,ff,0f,ff,ff,ff,ff,13,ff,ff,02
		db 02,05,0f,02,ff,ff,ff,13,ff,ff,ff,ff,ff,ff,ff,ff
		db 23,ff,ff,ff,ff,23,ff,13,ff,00
__exitbuf:	dd A27eb0000	;; 2a172a3c
__exitfopen:	dd A27eb0000	;; 2a172a40
__exitopen:	dd A27eb0000	;; 2a172a44
__atexitcnt:	word	;; 2a172a48
__first:	dword	;; 2a172a4a
__last:		dword	;; 2a172a4e
__rover:	dword	;; 2a172a52
Y2a172a56:	word	;; 2a172a56	;; PspN ;; Local to B28220003();
__ctype:	;; 2a172a58 ;; The actual table is at 2a172a59.
		db 00	;; __ctype[-1]
		db 20,20,20,20,20,20,20,20,20,21,21,21,21,21,20,20
		db 20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20
		db 01,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40
		db 02,02,02,02,02,02,02,02,02,02,40,40,40,40,40,40
		db 40,14,14,14,14,14,14,04,04,04,04,04,04,04,04,04
		db 04,04,04,04,04,04,04,04,04,04,04,40,40,40,40,40
		db 40,18,18,18,18,18,18,08,08,08,08,08,08,08,08,08
		db 08,08,08,08,08,08,08,08,08,08,08,40,40,40,40,20
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
X2a172b59:	byte	;; 2a172b59	;; (@) Not directly accssed; alignment padding?
__openfd:	;; 2a172b5a
		dw 2001,2002,2002,a004,a002,ffff,ffff,ffff
		dw ffff,ffff,ffff,ffff,ffff,ffff,ffff,ffff
		dw ffff,ffff,ffff,ffff
__fmode:	dw 4000	;; 2a172b82
__notUmask:	dw ffff	;; 2a172b84
Y2a172b86:	db "print scanf : floating point formats not linked\r\n",00
Y2a172bb8:	db "(null)",00
Y2a172bbf:	db "0123456789ABCDEF",00
Y2a172bd0:	;; CTypeTab ;; Local to __VPRINTER
		db 14,14,01,14,15,14,14,14,14,02,00,14,03,04,14,09
		db 05,05,05,05,05,05,05,05,05,14,14,14,14,14,14,14
		db 14,14,14,14,0f,17,0f,08,14,14,14,07,14,16,14,14
		db 14,14,14,14,14,14,14,0d,14,14,14,14,14,14,14,14
		db 14,14,10,0a,0f,0f,0f,08,0a,14,14,06,14,12,0b,0e
		db 14,14,11,14,0c,14,14,0d,14,14,14,14,14,14,14,00
__video:	;; 2a172c30
		ds 000b
		ds 2*0002
_directvideo:	dw 0001	;; 2a172c3f
Y2a172c41:	db "COMPAQ",00
Y2a172c48:	dd 00000001		;; 2a172c48	;; RandSeed.
Y2a172c4c:	dw offset A076a019f	;; 2a172c4c	;; CheckFP0()	;; Local to __turboCrt/__cvtfak.
Y2a172c4e:	dw offset A076a019f	;; 2a172c4e	;; CheckFP1()	;; Local to __exit().
Y2a172c50:	dw offset __c0crtinit	;; 2a172c50	;; InitCRT()	;; Local to __turboCrt/__cvtfak.
__RealCvtVector:	dd A076a03a9	;; 2a172c52
__ScanTodVector:	dd A076a03ae,A076a03ae,A076a03ae	;; 2a172c56	;; (@) Unaccessed.

;; BSS Area
Y2a172c62:	;; 2a172c62	;; (@) Beginning of the BSS segment.
;; Object Shape Table (externally stored in _shafile).
_shlen:		ds 2*0080	;; 2a172c62
_shafile:	word		;; 2a172d62
_colortab:	ds 0100		;; 2a172d64
_shm_fname:	ds 0050		;; 2a172e64
_shm_want:	ds 2*0040	;; 2a172eb4
_shoffset:	ds 4*0080	;; 2a172f34
_shm_flags:	ds 2*0040	;; 2a173134
_shm_tbllen:	ds 2*0040	;; 2a1731b4
_shm_tbladdr:	ds 4*0040	;; 2a173234
_LOST:		dword		;; 2a173334
_cmtab:		ds 2*0004*0100	;; 2a173338
_mainvp:	ds 0010		;; 2a173b38
_origmode:	word		;; 2a173b48
_pagemode:	word		;; 2a173b4a
_pixvalue:	byte		;; 2a173b4c
_pagelen:	word		;; 2a173b4d
_drawofs:	word		;; 2a173b4f
_showofs:	word		;; 2a173b51
_x_ourmode:	byte		;; 2a173b53
_pageshow:	word		;; 2a173b54
_pagedraw:	word		;; 2a173b56
_pixelsperbyte:	word		;; 2a173b58
_oldint9:	dword		;; 2a173b5a
_bhead:		dword		;; 2a173b5e
_btail:		dword		;; 2a173b62
_k_ctrl:	byte		;; 2a173b66
_k_alt:		byte		;; 2a173b67
_keydown:	ds 2*0100	;; 2a173b68
_bioscall:	byte		;; 2a173d68
_k_shift:	byte		;; 2a173d69
_k_numlock:	byte		;; 2a173d6a
_k_rshift:	byte		;; 2a173d6b
_k_lshift:	byte		;; 2a173d6c
X2a173d6d:	byte		;; 2a173d6d	;; (@) Unaccessed; alignment padding?
_curhi:		word		;; 2a173d6e
_curlo:		word		;; 2a173d70
_curback:	word		;; 2a173d72
_cursorchar:	word		;; 2a173d74
Y2a173d76:	word		;; 2a173d76	;; ExTicks	;; Local to _getmac().
Y2a173d78:	word		;; 2a173d78	;; NextTicks	;; Local to _getmac().
_dx1:		word		;; 2a173d7a
_dy1:		word		;; 2a173d7c
_fire1:		word		;; 2a173d7e
_flow1:		word		;; 2a173d80
_fire2:		word		;; 2a173d82
_joyxc:		word		;; 2a173d84
_joyyc:		word		;; 2a173d86
_joyyd:		word		;; 2a173d88
_key:		word		;; 2a173d8a
_dx1old:	word		;; 2a173d8c
_dy1old:	word		;; 2a173d8e
_joyxl:		word		;; 2a173d90
_keybuf:	ds 0100		;; 2a173d92
_joyxr:		word		;; 2a173e92
_dx1hold:	word		;; 2a173e94
_dy1hold:	word		;; 2a173e96
_joyyu:		word		;; 2a173e98
_mactime:	word		;; 2a173e9a
_maclen:	word		;; 2a173e9c
_joyflag:	word		;; 2a173e9e
_macofs:	word		;; 2a173ea0
_fire1off:	word		;; 2a173ea2
_fire2off:	word		;; 2a173ea4
_macfname:	ds 0020		;; 2a173ea6
_macrecord:	word		;; 2a173ec6
_joyxsense:	word		;; 2a173ec8
_joyysense:	word		;; 2a173eca
_macplay:	word		;; 2a173ecc
_macabort:	word		;; 2a173ece
_macaborted:	word		;; 2a173ed0
_cf:		ds 0016		;; 2a173ed2
X2a173ee8:	ds 0040		;; 2a173ee8	;; (@) Unaccessed. Padding space in _cf.
_SOUNDS:	dword		;; 2a173f28
_memvoc:	dword		;; 2a173f2c
_oldpri:	word		;; 2a173f30
_vocpri:	word		;; 2a173f32	;; (@) Unaccessed.
_vocused:	ds 2*0032	;; 2a173f34
_vocrate:	ds 2*0032	;; 2a173f98
_vocnum:	ds 0032		;; 2a173ffc
_voclen:	ds 2*0032	;; 2a17402e
_textmsg:	dword		;; 2a174092
_soundmac:	ds 4*0080	;; 2a174096
_textlen:	ds 2*0028	;; 2a174296
_vocposn:	ds 4*0032	;; 2a1742e6
_oldfreq:	word		;; 2a1743ae
_clockrate:	word		;; 2a1743b0
_soundlen:	word		;; 2a1743b2
_textposn:	ds 4*0028	;; 2a1743b4
_soundptr:	word		;; 2a174454
_textmsglen:	word		;; 2a174456
_clockcount:	word		;; 2a174458
_soundcount:	word		;; 2a17445a
_notepriority:	word		;; 2a17445c
_samppriority:	word		;; 2a17445e	;; (@) Unaccessed.
_lastwater:	word		;; 2a174460
_fidgetnum:	word		;; 2a174462
_oldx0:		word		;; 2a174464
_oldy0:		word		;; 2a174466
_bd:		ds 2*0080*0040	;; 2a174468
_pl:		;; 2a178468
		word		;; 00
		word		;; 02
		word		;; 04
		ds 2*0010	;; 06
		dword		;; 26
		word		;; 2a
		dword		;; 2c
		ds 0016		;; 30
_info:		ds 8*0258	;; 2a1784ae
_objs:		ds 001f*0102	;; 2a17976e
_hiname:	ds 000c*000a	;; 2a17b6ac
_botmsg:	ds 003c		;; 2a17b724
_botvp:		ds 0010		;; 2a17b760
_cmdvp:		dword		;; 2a17b770
_botcol:	word		;; 2a17b774
_bottime:	word		;; 2a17b776
_kindxl:	ds 2*0045	;; 2a17b778
_kindyl:	ds 2*0045	;; 2a17b802
_hiscore:	ds 4*000a	;; 2a17b88c
_gamevp:	dword		;; 2a17b8b4
_ourwin:	ds 0058		;; 2a17b8b8
_kindmsg:	ds 4*0045	;; 2a17b910
_oursong:	ds 0020		;; 2a17ba24
_statvp:	dword		;; 2a17ba44
_tempvp:	ds 0010		;; 2a17ba48
_demonum:	word		;; 2a17ba58
_scrnxs:	word		;; 2a17ba5a
_scrnys:	word		;; 2a17ba5c
_kindname:	ds 4*0045	;; 2a17ba5e
_scrollxd:	word		;; 2a17bb72
_scrollyd:	word		;; 2a17bb74
_savename:	ds 0006*000c	;; 2a17bb76
_tempname:	ds 0040		;; 2a17bbbe
_curlevel:	ds 0020		;; 2a17bbfe
_numobjs:	word		;; 2a17bc1e
_newlevel:	ds 0020		;; 2a17bc20
_kindtable:	ds 2*0045	;; 2a17bc40
_kindscore:	ds 2*0045	;; 2a17bcca
_levelwin:	ds 0058		;; 2a17bd54
_gameover:	word		;; 2a17bdac
_scrnobjs:	ds 2*00c0	;; 2a17bdae
_oldvgapal:	ds 0003*0100	;; 2a17bf2e
_stateinfo:	ds 2*0006	;; 2a17c22e
_statmodflg:	word		;; 2a17c23a
_gamecount:	word		;; 2a17c23c
_kindflags:	ds 2*0045	;; 2a17c23e
_oldscrollxd:	word		;; 2a17c2c8
_oldscrollyd:	word		;; 2a17c2ca
_oldlevelnum:	word		;; 2a17c2cc
_numscrnobjs:	word		;; 2a17c2ce
_levelmsgclock:	word		;; 2a17c2d0
_disy:		word		;; 2a17c2d2
_updtab:	ds 0080*0014	;; 2a17c2d4
_WORX_AX:	word		;; 2a17ccd4
_WORX_BX:	word		;; 2a17ccd6
_WORX_DX:	word		;; 2a17ccd8
_WORX_DI:	word		;; 2a17ccda
_WORX_ES:	word		;; 2a17ccdc
_RSC_AREA:	dword		;; 2a17ccde
__atexittbl:	ds 4*0020	;; 2a17cce2
Y2a17cd62:	word		;; 2a17cd62	;; VideoIntBP	;; Local to __VideoInt().
Y2a17cd64:	;; 2a17cd64	;; (@) End of the BSS segment.
X2a17cd64:	ds 000c		;; 2a17cd64	;; (@) Unaccessed.

Segment 36ee ;; Stack Area
emws_limitSP:		ds 00c0	;; 2a17cd70 ;; 36ee0000
emws_initialSP:		ds 000c	;; 2a17ce30 ;; 36ee00c0
emws_saveVector:	dword	;; 2a17ce3c ;; 36ee00cc
emws_nmiVector:		dword	;; 2a17ce40 ;; 36ee00d0
emws_status:		word	;; 2a17ce44 ;; 36ee00d4
emws_control:		word	;; 2a17ce46 ;; 36ee00d6
emws_TOS:		word	;; 2a17ce48 ;; 36ee00d8
emws_adjust:		word	;; 2a17ce4a ;; 36ee00da
emws_fixSeg:		word	;; 2a17ce4c ;; 36ee00dc
emws_BPsafe:		word	;; 2a17ce4e ;; 36ee00de
emws_stamp:		dword	;; 2a17ce50 ;; 36ee00e0
emws_version:		dw ffff	;; 2a17ce54 ;; 36ee00e4
emuTop@:		;; 2a17ce56 ;; 36ee00e6
