Segment 0040 ;; DOS Segment.
Y00400000:
Y0040001a: word	;; 0040001a	;; Handler queue head.
Y0040001c: word ;; 0040001c	;; Handler queue tail.
Y00400063: word	;; 00400063	;; Port number.
Y0040006c: word	;; 0040006c	;; Clock.

;; CS:IP = 0000:0000, SS:SP = 2943:00e6
;; Relocated to 076a under Linux; previously to 140c under Windows.

;; === Top-Level Runtime System ===
Segment 076a ;; C0L:C0L
__turboCrt: ;; 076a0000 ;; (@) Unaccessed.
__cvtfak: ;; 076a0000 ;; (@) Unaccessed.
   mov DX,segment A24dc0000
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
   mov DI,offset Y24dc28ce
   mov CX,offset Y24dcbd02
   sub CX,DI
   repz stosb ;; (@) Initialize the BSS segment to 0.
   push CS
   call near [offset Y24dc28b8]
   call far __setargv
   call far __setenvp
   mov AH,00
   int 1A
   mov [offset __StartTime],DX
   mov [offset __StartTime+02],CX
   push CS
   call near [offset Y24dc28bc]
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
   call near [offset Y24dc28ba]
   mov BP,SP
   mov AH,4C
   mov AL,[BP+04]
   int 21		;; (@) No return.

B076a0125:		;; (@) No return.
   mov CX,000E
   nop
   mov DX,offset Y24dc002f
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
   mov DX,offset Y24dc003d

B076a01b6: ;; 076a01b6	;; (@) No return.
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
   pop [CS:offset Y076a01ca+2]
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
   cmp byte ptr [offset __osmajor],03
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
   mov DX,offset Y24dc27f2+00
jmp near L076a03b1

A076a03ae:
   mov DX,offset Y24dc27f2+05
L076a03b1:
   mov CX,0005
   nop
   mov AH,40
   mov BX,0002
   int 21
   mov CX,0027
   nop
   mov DX,offset Y24dc27f2+0a
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
   mov [offset Y24dcbd00],BP
   int 10
   mov BP,[offset Y24dcbd00]
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
   mov AX,offset Y24dc28ad
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
   mov [offset __video+00],AL
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

Y076a05b3:	db "Stack overflow!\r\n$"

OVERFLOW@: ;; 076a05c5
   mov AX,CS
   mov DS,AX
   mov DX,offset Y076a05b3
   mov AH,09
   int 21
jmp far __exit

PSBP@: ;; 076a05d5
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

SCOPY@: ;; 076a05fa
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
Segment 07cb ;; COPYFILE.C:COPYFILE
_copyfile: ;; 07cb0006
   push BP
   mov BP,SP
   sub SP,+0A
   mov AX,1000
   push AX
   call far _malloc
   pop CX
   mov [BP-04],DX
   mov [BP-06],AX
   mov AX,[BP-06]
   or AX,[BP-04]
   jnz L07cb0027
jmp near L07cb00b3
L07cb0027:
   mov AX,8001
   push AX
   push [BP+08]
   push [BP+06]
   call far __open
   add SP,+06
   mov [BP-0A],AX
   cmp word ptr [BP-0A],+00
   jl L07cb00a6
   xor AX,AX
   push AX
   push [BP+0C]
   push [BP+0A]
   call far __creat
   add SP,+06
   mov [BP-08],AX
   cmp word ptr [BP-08],+00
   jl L07cb009d
L07cb005c:
   mov AX,1000
   push AX
   push [BP-04]
   push [BP-06]
   push [BP-0A]
   call far __read
   add SP,+08
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jle L07cb008e
   push [BP-02]
   push [BP-04]
   push [BP-06]
   push [BP-08]
   call far __write
   add SP,+08
L07cb008e:
   cmp word ptr [BP-02],+00
   jg L07cb005c
   push [BP-08]
   call far __close
   pop CX
L07cb009d:
   push [BP-0A]
   call far __close
   pop CX
L07cb00a6:
   push [BP-04]
   push [BP-06]
   call far _free
   pop CX
   pop CX
L07cb00b3:
   mov SP,BP
   pop BP
ret far

Segment 07d6 ;; SHM.C:SHM
_shm_init: ;; 07d60007
   push BP
   mov BP,SP
   sub SP,+02
   push [BP+08]
   push [BP+06]
   push DS
   mov AX,offset _shm_fname
   push AX
   call far _strcpy
   add SP,+08
   mov word ptr [BP-02],0000
jmp near L07d60048
L07d60027:
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+offset _shm_want],0000
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _shm_tbladdr+2],0000
   mov word ptr [BX+offset _shm_tbladdr+0],0000
   inc word ptr [BP-02]
L07d60048:
   cmp word ptr [BP-02],+40
   jl L07d60027
   mov SP,BP
   pop BP
ret far

_init8bit: ;; 07d60052
   push BP
   mov BP,SP
   sub SP,+02
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L07d60070
   cmp AX,0002
   jz L07d6008f
   cmp AX,0004
   jz L07d600a7
jmp near L07d600c4
L07d60070:
   mov word ptr [BP-02],0000
jmp near L07d60086
L07d60077:
   mov AL,[BP-02]
   and AL,03
   mov BX,[BP-02]
   mov [BX+offset _colortab],AL
   inc word ptr [BP-02]
L07d60086:
   cmp word ptr [BP-02],0100
   jl L07d60077
jmp near L07d600c4
L07d6008f:
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
jmp near L07d600c4
L07d600a7:
   mov word ptr [BP-02],0000
jmp near L07d600bb
L07d600ae:
   mov AL,[BP-02]
   mov BX,[BP-02]
   mov [BX+offset _colortab],AL
   inc word ptr [BP-02]
L07d600bb:
   cmp word ptr [BP-02],0100
   jl L07d600ae
jmp near L07d600c4
L07d600c4:
   mov word ptr [BP-02],0000
jmp near L07d600d8
L07d600cb:
   mov AL,[BP-02]
   mov BX,[BP-02]
   mov [BX+offset _colortab],AL
   inc word ptr [BP-02]
L07d600d8:
   cmp word ptr [BP-02],0100
   jl L07d600cb
   mov SP,BP
   pop BP
ret far

_xlate_table: ;; 07d600e3
   push BP
   mov BP,SP
   sub SP,+30
   mov byte ptr [BP-30],00
   mov byte ptr [BP-2F],01
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-30]
   push AX
   call far _memcpy
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-2E]
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-28]
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-26]
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
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-2F]
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
   jnz L07d601c8
   mov AX,[BP-28]
   add AX,0010
   mov [BP-22],AX
   mov word ptr [BP-0C],0003
   mov word ptr [BP-0A],0000
jmp near L07d60213
L07d601c8:
   cmp byte ptr [offset _x_ourmode],01
   jnz L07d601e4
   mov AX,[BP-28]
   add AX,0010
   mov [BP-22],AX
   mov word ptr [BP-0C],0003
   mov word ptr [BP-0A],0004
jmp near L07d60213
L07d601e4:
   cmp byte ptr [offset _x_ourmode],02
   jnz L07d60200
   mov AX,[BP-26]
   add AX,0010
   mov [BP-22],AX
   mov word ptr [BP-0C],000F
   mov word ptr [BP-0A],0008
jmp near L07d60213
L07d60200:
   mov AX,[BP-24]
   add AX,0010
   mov [BP-22],AX
   mov word ptr [BP-0C],00FF
   mov word ptr [BP-0A],0010
L07d60213:
   test word ptr [BP-14],0001
   jz L07d60244
   mov byte ptr [BP-1B],00
jmp near L07d60231
L07d60220:
   mov AL,[BP-1B]
   mov DL,[BP-1B]
   mov DH,00
   mov BX,DX
   mov [BX+offset _colortab],AL
   inc byte ptr [BP-1B]
L07d60231:
   mov AX,0001
   mov CL,[BP-2F]
   shl AX,CL
   mov DL,[BP-1B]
   mov DH,00
   cmp AX,DX
   jg L07d60220
jmp near L07d602a1
L07d60244:
   cmp byte ptr [BP-2F],08
   jnz L07d60250
   push CS
   call near offset _init8bit
jmp near L07d602a1
L07d60250:
   mov byte ptr [BP-1B],00
jmp near L07d60290
L07d60256:
   mov AX,0004
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-2C]
   push AX
   call far _memcpy
   add SP,+0A
   add word ptr [BP+08],+04
   mov DX,[BP-2A]
   mov AX,[BP-2C]
   mov CL,[BP-0A]
   call far LXRSH@
   and AL,[BP-0C]
   mov DL,[BP-1B]
   mov DH,00
   mov BX,DX
   mov [BX+offset _colortab],AL
   inc byte ptr [BP-1B]
L07d60290:
   mov AX,0001
   mov CL,[BP-2F]
   shl AX,CL
   mov DL,[BP-1B]
   mov DH,00
   cmp AX,DX
   jg L07d60256
L07d602a1:
   push [BP-22]
   call far _malloc
   pop CX
   mov [BP-06],DX
   mov [BP-08],AX
   mov AX,[BP-08]
   or AX,[BP-06]
   jnz L07d602c2
   mov AX,0009
   push AX
   call far _rexit
   pop CX
L07d602c2:
   mov AX,[BP-22]
   mov BX,[BP+06]
   shl BX,1
   mov [BX+offset _shm_tbllen],AX
   mov DX,[BP-06]
   mov AX,[BP-08]
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   mov [BX+offset _shm_tbladdr+2],DX
   mov [BX+offset _shm_tbladdr+0],AX
   mov AX,[BP-14]
   mov BX,[BP+06]
   shl BX,1
   mov [BX+offset _shm_flags],AX
   mov word ptr [BP-04],0000
   mov AL,[BP-30]
   mov AH,00
   shl AX,1
   shl AX,1
   mov [BP-02],AX
   mov byte ptr [BP-1B],00
jmp near L07d6076a
L07d60307:
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-1F]
   push AX
   call far _memcpy
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-1D]
   push AX
   call far _memcpy
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-1C]
   push AX
   call far _memcpy
   add SP,+0A
   inc word ptr [BP+08]
   les BX,[BP+0C]
   mov [BP-10],ES
   mov [BP-12],BX
   mov AL,[BP-1C]
   mov AH,00
   or AX,AX
   jz L07d60373
   cmp AX,0001
   jz L07d603a5
   cmp AX,0002
   jz L07d603a7
jmp near L07d603a9
L07d60373:
   mov AL,[BP-1F]
   mov AH,00
   mov DL,[BP-1D]
   mov DH,00
   mul DX
   push AX
   push [BP+0A]
   push [BP+08]
   push [BP-10]
   push [BP-12]
   call far _memcpy
   add SP,+0A
   mov AL,[BP-1F]
   mov AH,00
   mov DL,[BP-1D]
   mov DH,00
   mul DX
   add [BP+08],AX
jmp near L07d603a9
L07d603a5:
jmp near L07d603a9
L07d603a7:
jmp near L07d603a9
L07d603a9:
   cmp byte ptr [BP-2F],08
   jnz L07d603e0
   cmp byte ptr [BP-1F],40
   jnz L07d603e0
   cmp byte ptr [BP-1D],0C
   jnz L07d603e0
   cmp byte ptr [offset _x_ourmode],04
   jnz L07d603e0
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
jmp near L07d603e0
L07d603e0:
   cmp byte ptr [offset _x_ourmode],00
   jz L07d603f1
   cmp byte ptr [offset _x_ourmode],01
   jz L07d603f1
jmp near L07d604cc
L07d603f1:
   mov AL,[BP-1F]
   mov AH,00
   add AX,0003
   mov BX,0004
   cwd
   idiv BX
   mov [BP-1E],AL
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
   mov AL,[BP-1E]
   les BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   mov AL,[BP-1D]
   les BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   mov byte ptr [BP-0D],00
   mov word ptr [BP-18],0000
jmp near L07d604bc
L07d6044b:
   mov word ptr [BP-1A],0000
jmp near L07d604af
L07d60452:
   les BX,[BP-12]
   add BX,[BP-1A]
   mov AL,[BP-1F]
   mov AH,00
   mul word ptr [BP-18]
   add BX,AX
   mov AL,[ES:BX]
   mov AH,00
   mov BX,AX
   mov AL,[BX+offset _colortab]
   mov [BP-0E],AL
   mov AL,[BP-1A]
   and AL,03
   shl AL,1
   mov CL,06
   sub CL,AL
   mov AL,[BP-0E]
   shl AL,CL
   or [BP-0D],AL
   mov AX,[BP-1A]
   and AX,0003
   cmp AX,0003
   jz L07d60499
   mov AL,[BP-1F]
   mov AH,00
   dec AX
   cmp AX,[BP-1A]
   jnz L07d604ac
L07d60499:
   mov AL,[BP-0D]
   les BX,[BP-08]
   add BX,[BP-02]
   mov [ES:BX],AL
   inc word ptr [BP-02]
   mov byte ptr [BP-0D],00
L07d604ac:
   inc word ptr [BP-1A]
L07d604af:
   mov AL,[BP-1F]
   mov AH,00
   cmp AX,[BP-1A]
   jg L07d60452
   inc word ptr [BP-18]
L07d604bc:
   mov AL,[BP-1D]
   mov AH,00
   cmp AX,[BP-18]
   jle L07d604c9
jmp near L07d6044b
L07d604c9:
jmp near L07d60767
L07d604cc:
   cmp byte ptr [offset _x_ourmode],02
   jz L07d604dd
   cmp byte ptr [offset _x_ourmode],03
   jz L07d604dd
jmp near L07d6065a
L07d604dd:
   mov AL,[BP-1F]
   mov [BP-1E],AL
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
   mov AL,[BP-1E]
   les BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   mov AL,[BP-1D]
   les BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   test word ptr [BP-14],0004
   jz L07d6052b
jmp near L07d605aa
L07d6052b:
   mov word ptr [BP-18],0000
jmp near L07d6059d
L07d60532:
   mov word ptr [BP-1A],0000
jmp near L07d60590
L07d60539:
   les BX,[BP-12]
   add BX,[BP-1A]
   mov AL,[BP-1F]
   mov AH,00
   mul word ptr [BP-18]
   add BX,AX
   mov AL,[ES:BX]
   mov AH,00
   mov BX,AX
   mov AL,[BX+offset _colortab]
   les BX,[BP-12]
   add BX,[BP-1A]
   mov DL,[BP-1F]
   mov DH,00
   push AX
   mov AX,DX
   mul word ptr [BP-18]
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
   add word ptr [BP-1A],+02
L07d60590:
   mov AL,[BP-1F]
   mov AH,00
   cmp AX,[BP-1A]
   jg L07d60539
   inc word ptr [BP-18]
L07d6059d:
   mov AL,[BP-1D]
   mov AH,00
   cmp AX,[BP-18]
   jg L07d60532
jmp near L07d60657
L07d605aa:
   mov word ptr [BP-16],0008
jmp near L07d6064e
L07d605b2:
   mov word ptr [BP-18],0000
jmp near L07d6063e
L07d605ba:
   mov byte ptr [BP-0D],00
   mov word ptr [BP-1A],0000
jmp near L07d60631
L07d605c5:
   les BX,[BP-12]
   add BX,[BP-1A]
   mov AL,[BP-1F]
   mov AH,00
   mul word ptr [BP-18]
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
   jz L07d605f4
   mov AX,0001
jmp near L07d605f6
L07d605f4:
   xor AX,AX
L07d605f6:
   mov DL,[BP-1A]
   and DL,07
   mov CL,07
   sub CL,DL
   shl AL,CL
   or [BP-0D],AL
   mov AX,[BP-1A]
   and AX,0007
   cmp AX,0007
   jz L07d6061b
   mov AL,[BP-1F]
   mov AH,00
   dec AX
   cmp AX,[BP-1A]
   jnz L07d6062e
L07d6061b:
   mov AL,[BP-0D]
   les BX,[BP-08]
   add BX,[BP-02]
   mov [ES:BX],AL
   inc word ptr [BP-02]
   mov byte ptr [BP-0D],00
L07d6062e:
   inc word ptr [BP-1A]
L07d60631:
   mov AL,[BP-1F]
   mov AH,00
   cmp AX,[BP-1A]
   jg L07d605c5
   inc word ptr [BP-18]
L07d6063e:
   mov AL,[BP-1D]
   mov AH,00
   cmp AX,[BP-18]
   jle L07d6064b
jmp near L07d605ba
L07d6064b:
   sar word ptr [BP-16],1
L07d6064e:
   cmp word ptr [BP-16],+00
   jle L07d60657
jmp near L07d605b2
L07d60657:
jmp near L07d60767
L07d6065a:
   mov AL,[BP-1F]
   mov [BP-1E],AL
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
   mov AL,[BP-1E]
   les BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   mov AL,[BP-1D]
   les BX,[BP-08]
   add BX,[BP-04]
   mov [ES:BX],AL
   inc word ptr [BP-04]
   test word ptr [BP-14],0004
   jnz L07d606fc
   mov word ptr [BP-18],0000
jmp near L07d606f0
L07d606ac:
   mov word ptr [BP-1A],0000
jmp near L07d606e3
L07d606b3:
   les BX,[BP-12]
   add BX,[BP-1A]
   mov AL,[BP-1F]
   mov AH,00
   mul word ptr [BP-18]
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
   inc word ptr [BP-1A]
L07d606e3:
   mov AL,[BP-1F]
   mov AH,00
   cmp AX,[BP-1A]
   jg L07d606b3
   inc word ptr [BP-18]
L07d606f0:
   mov AL,[BP-1D]
   mov AH,00
   cmp AX,[BP-18]
   jg L07d606ac
jmp near L07d60767
L07d606fc:
   mov word ptr [BP-16],0003
jmp near L07d60761
L07d60703:
   mov word ptr [BP-18],0000
jmp near L07d60754
L07d6070a:
   mov word ptr [BP-1A],0000
jmp near L07d60747
L07d60711:
   mov AX,[BP-1A]
   add AX,[BP-16]
   les BX,[BP-12]
   add BX,AX
   mov AL,[BP-1F]
   mov AH,00
   mul word ptr [BP-18]
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
   add word ptr [BP-1A],+04
L07d60747:
   mov AL,[BP-1F]
   mov AH,00
   cmp AX,[BP-1A]
   jg L07d60711
   inc word ptr [BP-18]
L07d60754:
   mov AL,[BP-1D]
   mov AH,00
   cmp AX,[BP-18]
   jg L07d6070a
   dec word ptr [BP-16]
L07d60761:
   cmp word ptr [BP-16],+00
   jge L07d60703
L07d60767:
   inc byte ptr [BP-1B]
L07d6076a:
   mov AL,[BP-1B]
   cmp AL,[BP-30]
   jnb L07d60775
jmp near L07d60307
L07d60775:
   mov SP,BP
   pop BP
ret far

_shm_do: ;; 07d60779
   push BP
   mov BP,SP
   sub SP,0508
   mov AX,1000
   push AX
   call far _malloc
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   mov AX,[BP-04]
   or AX,[BP-02]
   jnz L07d607a2
   mov AX,0009
   push AX
   call far _rexit
   pop CX
L07d607a2:
   mov word ptr [BP-06],0000
jmp near L07d607c4
L07d607a9:
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   lea AX,[BP+FCF8]
   add BX,AX
   mov word ptr [SS:BX+02],0000
   mov word ptr [SS:BX],0000
   inc word ptr [BP-06]
L07d607c4:
   cmp word ptr [BP-06],+40
   jl L07d607a9
   mov AX,8001
   push AX
   push DS
   mov AX,offset _shm_fname
   push AX
   call far __open
   add SP,+06
   mov [BP-08],AX
   mov AX,0200
   push AX
   push SS
   lea AX,[BP+FAF8]
   push AX
   push [BP-08]
   call far _read
   add SP,+08
   or AX,AX
   jnz L07d60801
   mov AX,0009
   push AX
   call far _rexit
   pop CX
L07d60801:
   mov AX,0100
   push AX
   push SS
   lea AX,[BP+FEF8]
   push AX
   push [BP-08]
   call far _read
   add SP,+08
   mov word ptr [BP-06],0000
jmp near L07d60929
L07d6081e:
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+offset _shm_want],+00
   jnz L07d60867
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr+0]
   or AX,[BX+offset _shm_tbladdr+2]
   jz L07d60864
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   push [BX+offset _shm_tbladdr+2]
   push [BX+offset _shm_tbladdr+0]
   call far _free
   pop CX
   pop CX
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _shm_tbladdr+2],0000
   mov word ptr [BX+offset _shm_tbladdr+0],0000
L07d60864:
jmp near L07d60926
L07d60867:
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr+0]
   or AX,[BX+offset _shm_tbladdr+2]
   jz L07d6087b
jmp near L07d60926
L07d6087b:
   mov BX,[BP-06]
   shl BX,1
   lea AX,[BP+FEF8]
   add BX,AX
   cmp word ptr [SS:BX],+00
   jnz L07d6088f
jmp near L07d60926
L07d6088f:
   xor AX,AX
   push AX
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   lea AX,[BP+FAF8]
   add BX,AX
   push [SS:BX+02]
   push [SS:BX]
   push [BP-08]
   call far _lseek
   add SP,+08
   mov BX,[BP-06]
   shl BX,1
   lea AX,[BP+FEF8]
   add BX,AX
   push [SS:BX]
   call far _malloc
   pop CX
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   lea CX,[BP+FCF8]
   add BX,CX
   mov [SS:BX+02],DX
   mov [SS:BX],AX
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   lea AX,[BP+FCF8]
   add BX,AX
   mov AX,[SS:BX]
   or AX,[SS:BX+02]
   jnz L07d608f9
   mov AX,0009
   push AX
   call far _rexit
   pop CX
L07d608f9:
   mov BX,[BP-06]
   shl BX,1
   lea AX,[BP+FEF8]
   add BX,AX
   push [SS:BX]
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   lea AX,[BP+FCF8]
   add BX,AX
   push [SS:BX+02]
   push [SS:BX]
   push [BP-08]
   call far _read
   add SP,+08
L07d60926:
   inc word ptr [BP-06]
L07d60929:
   cmp word ptr [BP-06],+40
   jge L07d60932
jmp near L07d6081e
L07d60932:
   push [BP-08]
   call far _close
   pop CX
   mov word ptr [BP-06],0000
jmp near L07d6099a
L07d60942:
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   lea AX,[BP+FCF8]
   add BX,AX
   mov AX,[SS:BX]
   or AX,[SS:BX+02]
   jz L07d60997
   push [BP-02]
   push [BP-04]
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   lea AX,[BP+FCF8]
   add BX,AX
   push [SS:BX+02]
   push [SS:BX]
   push [BP-06]
   push CS
   call near offset _xlate_table
   add SP,+0A
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   lea AX,[BP+FCF8]
   add BX,AX
   push [SS:BX+02]
   push [SS:BX]
   call far _free
   pop CX
   pop CX
L07d60997:
   inc word ptr [BP-06]
L07d6099a:
   cmp word ptr [BP-06],+40
   jl L07d60942
   push [BP-02]
   push [BP-04]
   call far _free
   pop CX
   pop CX
   mov SP,BP
   pop BP
ret far

_shm_exit: ;; 07d609b1
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0000
jmp near L07d609fb
L07d609be:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr+0]
   or AX,[BX+offset _shm_tbladdr+2]
   jz L07d609f8
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+offset _shm_tbladdr+2]
   push [BX+offset _shm_tbladdr+0]
   call far _free
   pop CX
   pop CX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _shm_tbladdr+2],0000
   mov word ptr [BX+offset _shm_tbladdr+0],0000
L07d609f8:
   inc word ptr [BP-02]
L07d609fb:
   cmp word ptr [BP-02],+40
   jl L07d609be
   mov SP,BP
   pop BP
ret far

Segment 0876 ;; GR.C:GR
_pixaddr_cga: ;; 08760005
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
   mov SI,0002
   cwd
   idiv SI
   mov DX,0050
   mul DX
   cwd
   add BX,AX
   adc CX,DX
   add BX,+00
   adc CX,B800
   les DI,[BP+0A]
   mov [ES:DI+02],CX
   mov [ES:DI],BX
   mov AL,[BP+06]
   and AL,03
   shl AL,1
   les BX,[BP+0E]
   mov [ES:BX],AL
   pop BP
ret far

_pixaddr_ega: ;; 08760058
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
   les DI,[BP+0A]
   mov [ES:DI+02],CX
   mov [ES:DI],BX
   mov AL,[BP+06]
   and AL,07
   les BX,[BP+0E]
   mov [ES:BX],AL
   pop BP
ret far

_pixaddr_vga: ;; 0876009c
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
   les DI,[BP+0A]
   mov [ES:DI+02],CX
   mov [ES:DI],BX
   mov AL,[BP+06]
   and AL,03
   les BX,[BP+0E]
   mov [ES:BX],AL
   pop BP
ret far

_drawshape: ;; 087600de
   push BP
   mov BP,SP
   sub SP,+10
   mov AX,[BP+0A]
   and AX,00FF
   mov [BP-04],AX
   mov AX,[BP+0A]
   mov CL,08
   sar AX,CL
   mov [BP-02],AX
   test word ptr [BP-02],0040
   jz L0876010a
   mov word ptr [BP-06],0003
   xor word ptr [BP-02],0040
jmp near L08760119
L0876010a:
   mov BX,[BP-02]
   shl BX,1
   mov AX,[BX+offset _shm_flags]
   and AX,0001
   mov [BP-06],AX
L08760119:
   cmp word ptr [BP-02],+00
   jle L08760125
   cmp word ptr [BP-02],+40
   jl L08760128
L08760125:
jmp near L087602c1
L08760128:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr+0]
   or AX,[BX+offset _shm_tbladdr+2]
   jnz L08760170
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+offset _shm_want],0001
   call far _shm_do
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _shm_tbladdr+0]
   or AX,[BX+offset _shm_tbladdr+2]
   jnz L08760170
   mov DX,[offset _LOST+2]
   mov AX,[offset _LOST+0]
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov [BX+offset _shm_tbladdr+2],DX
   mov [BX+offset _shm_tbladdr+0],AX
L08760170:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov DX,[BX+offset _shm_tbladdr+2]
   mov AX,[BX+offset _shm_tbladdr+0]
   cmp DX,[offset _LOST+2]
   jnz L0876018e
   cmp AX,[offset _LOST+0]
   jnz L0876018e
jmp near L087602c1
L0876018e:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   les BX,[BX+offset _shm_tbladdr]
   mov AX,[BP-04]
   shl AX,1
   shl AX,1
   add BX,AX
   mov [BP-0E],ES
   mov [BP-10],BX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   les BX,[BX+offset _shm_tbladdr]
   push ES
   push BX
   les BX,[BP-10]
   pop AX
   pop DX
   add AX,[ES:BX]
   mov [BP-0A],DX
   mov [BP-0C],AX
   les BX,[BP-10]
   mov AL,[ES:BX+02]
   mov [BP-08],AL
   les BX,[BP-10]
   mov AL,[ES:BX+03]
   mov [BP-07],AL
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   sub [BP+0C],AX
   les BX,[BP+06]
   mov AX,[ES:BX+0A]
   sub [BP+0E],AX
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   cmp AX,[BP+0E]
   jg L087601fa
jmp near L087602c1
L087601fa:
   mov AL,[BP-07]
   mov AH,00
   add AX,[BP+0E]
   jge L08760207
jmp near L087602c1
L08760207:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+0C]
   jg L08760216
jmp near L087602c1
L08760216:
   mov AL,[BP-08]
   mov AH,00
   mul word ptr [offset _pixelsperbyte]
   add AX,[BP+0C]
   jge L08760227
jmp near L087602c1
L08760227:
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L08760240
   cmp AX,0002
   jz L0876026b
   cmp AX,0004
   jz L08760296
jmp near L087602c1
L08760240:
   push [BP-06]
   push [BP-0A]
   push [BP-0C]
   mov AL,[BP-07]
   mov AH,00
   push AX
   mov AL,[BP-08]
   mov AH,00
   push AX
   push [BP+0E]
   push [BP+0C]
   push [BP+08]
   push [BP+06]
   call far _ldrawsh_cga
   add SP,+12
jmp near L087602c1
L0876026b:
   push [BP-06]
   push [BP-0A]
   push [BP-0C]
   mov AL,[BP-07]
   mov AH,00
   push AX
   mov AL,[BP-08]
   mov AH,00
   push AX
   push [BP+0E]
   push [BP+0C]
   push [BP+08]
   push [BP+06]
   call far _ldrawsh_ega
   add SP,+12
jmp near L087602c1
L08760296:
   push [BP-06]
   push [BP-0A]
   push [BP-0C]
   mov AL,[BP-07]
   mov AH,00
   push AX
   mov AL,[BP-08]
   mov AH,00
   push AX
   push [BP+0E]
   push [BP+0C]
   push [BP+08]
   push [BP+06]
   call far _ldrawsh_vga
   add SP,+12
jmp near L087602c1
L087602c1:
   mov SP,BP
   pop BP
ret far

_plot: ;; 087602c5 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   cmp word ptr [BP+0A],+00
   jge L087602d1
jmp near L08760379
L087602d1:
   cmp word ptr [BP+0C],+00
   jge L087602da
jmp near L08760379
L087602da:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+0A]
   jg L087602e9
jmp near L08760379
L087602e9:
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   cmp AX,[BP+0C]
   jg L087602f8
jmp near L08760379
L087602f8:
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L08760310
   cmp AX,0002
   jz L08760334
   cmp AX,0004
   jz L08760358
jmp near L08760379
L08760310:
   mov AL,[BP+0E]
   and AL,03
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   push AX
   call far _plot_cga
   mov SP,BP
jmp near L08760379
L08760334:
   mov AL,[BP+0E]
   and AL,0F
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   push AX
   call far _plot_ega
   mov SP,BP
jmp near L08760379
L08760358:
   push [BP+0E]
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   push AX
   call far _plot_vga
   mov SP,BP
jmp near L08760379
L08760379:
   pop BP
ret far

_linex: ;; 0876037b ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L08760396
   cmp AX,0002
   jz L087603ae
   cmp AX,0004
   jz L087603b0
jmp near L087603b2
L08760396:
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far _line_cga
   mov SP,BP
jmp near L087603b2
L087603ae:
jmp near L087603b2
L087603b0:
jmp near L087603b2
L087603b2:
   pop BP
ret far

_waitsafe: ;; 087603b4
   push BP
   mov BP,SP
L087603b7:
   mov DX,03DA
   in AL,DX
   test AL,08
   jz L087603b7
   pop BP
ret far

_setcm_cga: ;; 087603c1
   push BP
   mov BP,SP
   sub SP,+0E
   mov AX,[BP+10]
   mov CL,08
   shl AX,CL
   or AX,[BP+08]
   mov [BP-0E],AX
   mov AX,[BP+12]
   mov CL,08
   shl AX,CL
   or AX,[BP+0A]
   mov [BP-0C],AX
   mov AX,[BP+14]
   mov CL,08
   shl AX,CL
   or AX,[BP+0C]
   mov [BP-0A],AX
   mov AX,[BP+16]
   mov CL,08
   shl AX,CL
   or AX,[BP+0E]
   mov [BP-08],AX
   mov word ptr [BP-02],0000
jmp near L08760458
L08760402:
   mov word ptr [BP-04],0000
   mov word ptr [BP-06],0000
jmp near L08760433
L0876040e:
   mov BX,[BP-02]
   mov CL,[BP-06]
   shr BX,CL
   and BX,0003
   shl BX,1
   lea AX,[BP-0E]
   add BX,AX
   mov AX,[SS:BX]
   mov CL,[BP-06]
   shl AX,CL
   or AX,[BP-04]
   mov [BP-04],AX
   add word ptr [BP-06],+02
L08760433:
   cmp word ptr [BP-06],+08
   jl L0876040e
   mov AX,[BP-04]
   mov BX,[BP+06]
   mov CL,09
   shl BX,CL
   add BX,offset _cmtab
   push AX
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   inc word ptr [BP-02]
L08760458:
   cmp word ptr [BP-02],0100
   jb L08760402
   mov SP,BP
   pop BP
ret far

_fontcolor_cga: ;; 08760463
   push BP
   mov BP,SP
   sub SP,+04
   mov word ptr [BP-04],0000
   mov word ptr [BP-02],0000
jmp near L08760478
L08760475:
   inc word ptr [BP-04]
L08760478:
   mov AX,[BP+06]
   cmp AX,[BP-04]
   jz L08760475
   mov AX,[BP+08]
   cmp AX,[BP-04]
   jz L08760475
   mov AX,[BP+0A]
   cmp AX,[BP-04]
   jz L08760475
   cmp word ptr [BP+0A],-01
   jnz L087604da
jmp near L0876049b
L08760498:
   inc word ptr [BP-02]
L0876049b:
   mov AX,[BP+06]
   cmp AX,[BP-02]
   jz L08760498
   mov AX,[BP+08]
   cmp AX,[BP-02]
   jz L08760498
   mov AX,[BP-04]
   cmp AX,[BP-02]
   jz L08760498
   xor AX,AX
   push AX
   mov AX,0003
   push AX
   mov AX,0003
   push AX
   xor AX,AX
   push AX
   push [BP-02]
   push [BP+08]
   push [BP+06]
   push [BP-04]
   mov AX,0001
   push AX
   push CS
   call near offset _setcm_cga
   add SP,+12
jmp near L08760500
L087604da:
   mov AX,0003
   push AX
   mov AX,0003
   push AX
   mov AX,0003
   push AX
   xor AX,AX
   push AX
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push [BP-04]
   mov AX,0001
   push AX
   push CS
   call near offset _setcm_cga
   add SP,+12
L08760500:
   mov SP,BP
   pop BP
ret far

_fontcolor_ega: ;; 08760504
   push BP
   mov BP,SP
   mov word ptr [offset _cmtab+1*0200],0010
   mov AX,[BP+08]
   mov [offset _cmtab+1*0200+02],AX
   mov AX,[BP+06]
   mov [offset _cmtab+1*0200+04],AX
   cmp word ptr [BP+0A],-01
   jnz L08760527
   mov word ptr [offset _cmtab+1*0200+06],0010
jmp near L0876052d
L08760527:
   mov AX,[BP+0A]
   mov [offset _cmtab+1*0200+06],AX
L0876052d:
   pop BP
ret far

_fontcolor_vga: ;; 0876052f
   push BP
   mov BP,SP
   mov word ptr [offset _cmtab+1*0200],00FF
   mov AX,[BP+08]
   mov [offset _cmtab+1*0200+02],AX
   mov AX,[BP+06]
   mov [offset _cmtab+1*0200+04],AX
   cmp word ptr [BP+0A],-01
   jnz L08760552
   mov word ptr [offset _cmtab+1*0200+06],00FF
jmp near L08760558
L08760552:
   mov AX,[BP+0A]
   mov [offset _cmtab+1*0200+06],AX
L08760558:
   pop BP
ret far

_fntcolor: ;; 0876055a
   push BP
   mov BP,SP
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L08760575
   cmp AX,0002
   jz L087605a1
   cmp AX,0004
   jz L087605b2
jmp near L087605c3
L08760575:
   cmp word ptr [BP+0A],-01
   jnz L0876058e
   push [BP+0A]
   mov AX,0002
   push AX
   mov AX,0002
   push AX
   push CS
   call near offset _fontcolor_cga
   mov SP,BP
jmp near L0876059f
L0876058e:
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   mov AX,0003
   push AX
   push CS
   call near offset _fontcolor_cga
   mov SP,BP
L0876059f:
jmp near L087605c3
L087605a1:
   push [BP+0A]
   push [BP+06]
   push [BP+08]
   push CS
   call near offset _fontcolor_ega
   mov SP,BP
jmp near L087605c3
L087605b2:
   push [BP+0A]
   push [BP+06]
   push [BP+08]
   push CS
   call near offset _fontcolor_vga
   mov SP,BP
jmp near L087605c3
L087605c3:
   pop BP
ret far

_initcolortabs_cga: ;; 087605c5
   push BP
   mov BP,SP
   mov AX,0003
   push AX
   mov AX,0003
   push AX
   mov AX,0003
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
   xor AX,AX
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
   mov AX,0003
   push AX
   mov AX,0003
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   push CS
   call near offset _setcm_cga
   add SP,+12
   mov AX,0003
   push AX
   mov AX,0003
   push AX
   mov AX,0003
   push AX
   mov AX,0003
   push AX
   mov AX,0003
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
   pop BP
ret far

_initcolortabs_ega: ;; 08760654
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0000
jmp near L08760687
L08760661:
   mov AX,[BP-02]
   mov BX,[BP-02]
   shl BX,1
   mov [BX+offset _cmtab],AX
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+offset _cmtab+2*0200],0000
   mov AX,[BP-02]
   mov BX,[BP-02]
   shl BX,1
   mov [BX+offset _cmtab+3*0200],AX
   inc word ptr [BP-02]
L08760687:
   cmp word ptr [BP-02],+10
   jl L08760661
   mov word ptr [offset _cmtab],0010
   mov word ptr [offset _cmtab+2*0200],0010
   mov SP,BP
   pop BP
ret far

_initcolortabs_vga: ;; 0876069d
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0000
jmp near L087606d0
L087606aa:
   mov AX,[BP-02]
   mov BX,[BP-02]
   shl BX,1
   mov [BX+offset _cmtab],AX
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+offset _cmtab+2*0200],0000
   mov AX,[BP-02]
   mov BX,[BP-02]
   shl BX,1
   mov [BX+offset _cmtab+3*0200],AX
   inc word ptr [BP-02]
L087606d0:
   cmp word ptr [BP-02],0100
   jl L087606aa
   mov word ptr [offset _cmtab],00FF
   mov word ptr [offset _cmtab+2*0200],00FF
   mov SP,BP
   pop BP
ret far

_setpages: ;; 087606e7
   push BP
   mov BP,SP
   mov AX,[offset _pageshow]
   mul word ptr [offset _pagelen]
   mov [offset _showofs],AX
   mov AX,[offset _pagedraw]
   mul word ptr [offset _pagelen]
   mov [offset _drawofs],AX
   pop BP
ret far

_setpagemode: ;; 08760700
   push BP
   mov BP,SP
   cmp word ptr [BP+06],+00
   jz L0876072b
   test byte ptr [offset _x_ourmode],FE
   jz L0876072b
   mov word ptr [offset _pagemode],0001
   mov AX,0001
   sub AX,[offset _pageshow]
   mov [offset _pagedraw],AX
   push CS
   call near offset _setpages
   call far _lcopypage
jmp near L0876073d
L0876072b:
   mov word ptr [offset _pagemode],0000
   mov AX,[offset _pageshow]
   mov [offset _pagedraw],AX
   mov AX,[offset _showofs]
   mov [offset _drawofs],AX
L0876073d:
   pop BP
ret far

_getportnum: ;; 0876073f
   push BP
   mov BP,SP
   mov BX,0040
   mov ES,BX
   mov BX,0063
   mov AX,[ES:BX]
jmp near L0876074f
L0876074f:
   pop BP
ret far

_pageflip: ;; 08760751
   push BP
   mov BP,SP
   sub SP,+02
   test byte ptr [offset _x_ourmode],FE
   jz L087607bb
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
   mov [BP-02],AX
L0876077f:
   mov DX,03DA
   in AL,DX
   test AL,08
   jnz L0876077f
   mov AX,[offset _showofs]
   and AX,FF00
   add AX,000C
   push AX
   push [BP-02]
   call far _outport
   pop CX
   pop CX
   mov AX,[offset _showofs]
   and AX,00FF
   mov CL,08
   shl AX,CL
   add AX,000D
   push AX
   push [BP-02]
   call far _outport
   pop CX
   pop CX
L087607b3:
   mov DX,03DA
   in AL,DX
   test AL,08
   jz L087607b3
L087607bb:
   mov SP,BP
   pop BP
ret far

_wait_vbi: ;; 087607bf ;; (@) Unaccessed.
   push BP
   mov BP,SP
   cmp byte ptr [offset _x_ourmode],04
   jz L087607cb
jmp near L087607db
L087607cb:
   mov DX,03DA
   in AL,DX
   test AL,08
   jnz L087607cb
L087607d3:
   mov DX,03DA
   in AL,DX
   test AL,08
   jz L087607d3
L087607db:
   pop BP
ret far

_vga_setpal: ;; 087607dd
   push BP
   mov BP,SP
   sub SP,+06
   mov word ptr [BP-06],0000
   mov word ptr [BP-04],0100
   cmp byte ptr [offset _x_ourmode],04
   jz L087607f7
jmp near L0876086f
L087607f7:
   cmp word ptr [BP-06],0100
   jg L0876080f
   cmp word ptr [BP-06],+00
   jl L0876080f
   mov AX,[BP-06]
   add AX,[BP-04]
   cmp AX,0100
   jle L08760811
L0876080f:
jmp near L0876086f
L08760811:
   push CS
   call near offset _waitsafe
   mov AX,[BP-06]
   mov [BP-02],AX
jmp near L08760864
L0876081d:
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
L08760864:
   mov AX,[BP-06]
   add AX,[BP-04]
   cmp AX,[BP-02]
   ja L0876081d
L0876086f:
   mov SP,BP
   pop BP
ret far

_readpal: ;; 08760873 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+06
   mov word ptr [BP-06],0000
   mov word ptr [BP-04],0100
   cmp byte ptr [offset _x_ourmode],04
   jz L0876088d
jmp near L0876092c
L0876088d:
   cmp word ptr [BP-06],0100
   jle L08760899
   mov AX,0001
jmp near L0876089b
L08760899:
   xor AX,AX
L0876089b:
   push AX
   cmp word ptr [BP-06],+00
   jge L087608a7
   mov AX,0001
jmp near L087608a9
L087608a7:
   xor AX,AX
L087608a9:
   pop DX
   or DX,AX
   push DX
   mov AX,[BP-06]
   add AX,[BP-04]
   cmp AX,0100
   jle L087608bd
   mov AX,0001
jmp near L087608bf
L087608bd:
   xor AX,AX
L087608bf:
   pop DX
   or DX,AX
   jz L087608c6
jmp near L0876092c
L087608c6:
   mov AX,[BP-06]
   mov [BP-02],AX
jmp near L08760921
L087608ce:
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
   inc AX
   les BX,[BP+06]
   add BX,AX
   pop AX
   mov [ES:BX],AL
   inc word ptr [BP-02]
L08760921:
   mov AX,[BP-06]
   add AX,[BP-04]
   cmp AX,[BP-02]
   ja L087608ce
L0876092c:
   mov SP,BP
   pop BP
ret far

_clrpal: ;; 08760930
   push BP
   mov BP,SP
   sub SP,+06
   mov word ptr [BP-04],0000
   mov word ptr [BP-02],0100
   cmp byte ptr [offset _x_ourmode],04
   jz L0876094a
jmp near L087609b6
L0876094a:
   cmp word ptr [BP-04],0100
   jle L08760956
   mov AX,0001
jmp near L08760958
L08760956:
   xor AX,AX
L08760958:
   push AX
   cmp word ptr [BP-04],+00
   jge L08760964
   mov AX,0001
jmp near L08760966
L08760964:
   xor AX,AX
L08760966:
   pop DX
   or DX,AX
   push DX
   mov AX,[BP-04]
   add AX,[BP-02]
   cmp AX,0100
   jle L0876097a
   mov AX,0001
jmp near L0876097c
L0876097a:
   xor AX,AX
L0876097c:
   pop DX
   or DX,AX
   jz L08760983
jmp near L087609b6
L08760983:
   mov AX,[BP-04]
   mov [BP-06],AX
jmp near L087609ab
L0876098b:
   mov AL,[BP-06]
   mov DX,[offset _DacWrite]
   out DX,AL
   mov AL,00
   mov DX,[offset _DacData]
   out DX,AL
   mov AL,00
   mov DX,[offset _DacData]
   out DX,AL
   mov AL,00
   mov DX,[offset _DacData]
   out DX,AL
   inc word ptr [BP-06]
L087609ab:
   mov AX,[BP-04]
   add AX,[BP-02]
   cmp AX,[BP-06]
   ja L0876098b
L087609b6:
   mov SP,BP
   pop BP
ret far

_fadein: ;; 087609ba
   push BP
   mov BP,SP
   sub SP,0306
   cmp byte ptr [offset _x_ourmode],04
   jz L087609cb
jmp near L08760a3e
L087609cb:
   mov word ptr [BP-02],0000
jmp near L08760a38
L087609d2:
   mov word ptr [BP-04],0000
jmp near L08760a02
L087609d9:
   mov BX,[BP-04]
   mov AL,[BX+offset _vgapal+0]
   mov AH,00
   mov [BP-06],AX
   mov AX,[BP-06]
   mul word ptr [BP-02]
   mov CL,06
   sar AX,CL
   mov [BP-06],AX
   mov AL,[BP-06]
   lea BX,[BP+FCFA]
   add BX,[BP-04]
   mov [SS:BX],AL
   inc word ptr [BP-04]
L08760a02:
   cmp word ptr [BP-04],0300
   jl L087609d9
   push CS
   call near offset _waitsafe
   mov AL,00
   mov DX,[offset _DacWrite]
   out DX,AL
   mov word ptr [BP-04],0000
jmp near L08760a2d
L08760a1b:
   lea BX,[BP+FCFA]
   add BX,[BP-04]
   mov AL,[SS:BX]
   mov DX,[offset _DacData]
   out DX,AL
   inc word ptr [BP-04]
L08760a2d:
   cmp word ptr [BP-04],0300
   jl L08760a1b
   add word ptr [BP-02],+02
L08760a38:
   cmp word ptr [BP-02],+40
   jl L087609d2
L08760a3e:
   mov SP,BP
   pop BP
ret far

_setcolor: ;; 08760a42 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AL,[BP+06]
   mov DX,[offset _DacWrite]
   out DX,AL
   mov AL,[BP+08]
   mov DX,[offset _DacData]
   out DX,AL
   mov AL,[BP+0A]
   mov DX,[offset _DacData]
   out DX,AL
   mov AL,[BP+0C]
   mov DX,[offset _DacData]
   out DX,AL
   pop BP
ret far

_fadeout: ;; 08760a67
   push BP
   mov BP,SP
   sub SP,0306
   cmp byte ptr [offset _x_ourmode],04
   jz L08760a78
jmp near L08760aeb
L08760a78:
   mov word ptr [BP-02],003F
jmp near L08760ae5
L08760a7f:
   mov word ptr [BP-06],0000
jmp near L08760aaf
L08760a86:
   mov BX,[BP-06]
   mov AL,[BX+offset _vgapal+0]
   mov AH,00
   mov [BP-04],AX
   mov AX,[BP-04]
   mul word ptr [BP-02]
   mov CL,06
   sar AX,CL
   mov [BP-04],AX
   mov AL,[BP-04]
   lea BX,[BP+FCFA]
   add BX,[BP-06]
   mov [SS:BX],AL
   inc word ptr [BP-06]
L08760aaf:
   cmp word ptr [BP-06],0300
   jl L08760a86
   push CS
   call near offset _waitsafe
   mov AL,00
   mov DX,[offset _DacWrite]
   out DX,AL
   mov word ptr [BP-06],0000
jmp near L08760ada
L08760ac8:
   lea BX,[BP+FCFA]
   add BX,[BP-06]
   mov AL,[SS:BX]
   mov DX,[offset _DacData]
   out DX,AL
   inc word ptr [BP-06]
L08760ada:
   cmp word ptr [BP-06],0300
   jl L08760ac8
   sub word ptr [BP-02],+02
L08760ae5:
   cmp word ptr [BP-02],+00
   jge L08760a7f
L08760aeb:
   mov SP,BP
   pop BP
ret far

_gr_config: ;; 08760aef
   push BP
   mov BP,SP
   sub SP,+02
   push DS
   mov AX,offset Y24dc049e
   push AX
   call far _cputs
   pop CX
   pop CX
L08760b01:
   call far _k_read
   push AX
   call far _toupper
   pop CX
   mov [BP-02],AX
   cmp word ptr [BP-02],+43
   jz L08760b28
   cmp word ptr [BP-02],+45
   jz L08760b28
   cmp word ptr [BP-02],+56
   jz L08760b28
   cmp word ptr [BP-02],+1B
   jnz L08760b01
L08760b28:
   mov AX,[BP-02]
   mov CX,0004
   mov BX,offset Y08760b40
L08760b31:
   cmp AX,[CS:BX]
   jz L08760b3c
   inc BX
   inc BX
   loop L08760b31
jmp near L08760b69
L08760b3c:
jmp near [CS:BX+08]

Y08760b40:	dw 001b,0043,0045,0056
Y08760b48:	dw L08760b65,L08760b50,L08760b57,L08760b5e

L08760b50:
   mov byte ptr [offset _x_ourmode],00
jmp near L08760b69
L08760b57:
   mov byte ptr [offset _x_ourmode],02
jmp near L08760b69
L08760b5e:
   mov byte ptr [offset _x_ourmode],04
jmp near L08760b69
L08760b65:
   xor AX,AX
jmp near L08760b6e
L08760b69:
   mov AX,0001
jmp near L08760b6e
L08760b6e:
   mov SP,BP
   pop BP
ret far

_gr_init: ;; 08760b72
   push BP
   mov BP,SP
   sub SP,+16
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
   mov word ptr [offset _mainvp+00],0000
   mov word ptr [offset _mainvp+02],0000
   mov word ptr [offset _mainvp+04],0140
   mov word ptr [offset _mainvp+06],00C8
   mov word ptr [offset _mainvp+08],0000
   mov word ptr [offset _mainvp+0A],0000
   mov AL,[offset _x_ourmode]
   mov AH,00
   or AX,AX
   jz L08760bf2
   cmp AX,0002
   jz L08760c4b
   cmp AX,0004
   jnz L08760bef
jmp near L08760ce9
L08760bef:
jmp near L08760dca
L08760bf2:
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
   mov AL,00
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clrvp
   add SP,+06
jmp near L08760dca
L08760c4b:
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
   mov word ptr [BP-16],0000
jmp near L08760c9e
L08760c78:
   mov word ptr [BP-14],1000
   mov AX,[BP-16]
   mov CL,08
   shl AX,CL
   add AX,[BP-16]
   mov [BP-12],AX
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   inc word ptr [BP-16]
L08760c9e:
   cmp word ptr [BP-16],+10
   jl L08760c78
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
   mov AL,00
   push AX
   push DS
   mov AX,offset _mainvp
   push AX
   call far _clrvp
   add SP,+06
jmp near L08760dca
L08760ce9:
   mov word ptr [offset _pagelen],4000
   mov byte ptr [offset _x_ourmode],04
   mov word ptr [BP-16],0000
jmp near L08760d21
L08760cfb:
   mov word ptr [BP-14],1000
   mov AX,[BP-16]
   mov CL,08
   shl AX,CL
   add AX,[BP-16]
   mov [BP-12],AX
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far _intr
   add SP,+06
   inc word ptr [BP-16]
L08760d21:
   cmp word ptr [BP-16],+10
   jl L08760cfb
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
jmp near L08760dca
L08760dca:
   mov AX,0001
   push AX
   call far _malloc
   pop CX
   mov [offset _LOST+2],DX
   mov [offset _LOST+0],AX
   mov SP,BP
   pop BP
ret far

_gr_exit: ;; 08760ddf
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

Segment 0956 ;; GAMEGRL.C:GRL
_ldrawsh_cga: ;; 09560003
   push BP
   mov BP,SP
   sub SP,+1C
   push SI
   push DI
   cmp word ptr [BP+0C],+00
   jl L09560026
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   mov [BP-10],AX
   mov AX,[BP+10]
   mov [BP-08],AX
jmp near L09560044
L09560026:
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
L09560044:
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov DX,[BP+0C]
   add DX,[BP+10]
   cmp AX,DX
   jg L09560067
   les BX,[BP+06]
   mov AX,[BP+0C]
   add AX,[BP+10]
   mov DX,[ES:BX+06]
   sub AX,DX
   sub [BP-08],AX
L09560067:
   cmp word ptr [BP-08],+00
   jg L09560070
jmp near L0956026b
L09560070:
   test word ptr [BP-10],0001
   jz L0956007c
   mov AX,E050
jmp near L0956007f
L0956007c:
   mov AX,2000
L0956007f:
   mov [BP-06],AX
   cmp word ptr [BP+16],+03
   jz L0956008b
jmp near L09560172
L0956008b:
   test word ptr [BP+0A],0003
   jz L09560095
jmp near L09560172
L09560095:
   cmp word ptr [BP+0A],+00
   jl L095600b4
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-12],AX
   mov AX,[BP+0E]
   mov [BP-0A],AX
   mov word ptr [BP-02],0000
jmp near L095600e0
L095600b4:
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
L095600e0:
   mov AX,[BP+0E]
   shl AX,1
   shl AX,1
   add AX,[BP+0A]
   les BX,[BP+06]
   cmp AX,[ES:BX+04]
   jl L09560127
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
L09560127:
   cmp word ptr [BP-0A],+00
   jg L09560130
jmp near L0956026b
L09560130:
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
L0956015a:
   mov CX,AX
   repz movsb
   add DI,[BP-06]
   sub DI,AX
   xor word ptr [BP-06],C050
   add SI,BX
   dec DX
   jnz L0956015a
   pop ES
   pop DS
jmp near L0956026b
L09560172:
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
   jl L095601e0
   mov AX,[BP-0C]
   inc AX
   jge L095601e4
L095601e0:
   xor AX,AX
jmp near L095601e7
L095601e4:
   mov AX,FF00
L095601e7:
   mov [BP-04],AX
   mov AX,[BP-16]
   mov [BP-1A],AX
jmp near L09560263

X095601f2:
   nop
L095601f3:
   mov AX,[BP-18]
   mov [BP-1C],AX
   push ES
   mov DX,[BP-04]
   mov BX,0000
L09560200:
   push BX
   mov DL,DH
   xor DH,DH
   cmp BX,[BP-0E]
   jl L09560211
   cmp BX,[BP-0C]
   jg L09560211
   mov DH,FF
L09560211:
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
   jge L09560254
jmp near L09560200
L09560254:
   mov AX,[BP-06]
   add [BP-18],AX
   xor word ptr [BP-06],C050
   pop ES
   dec word ptr [BP-08]
L09560263:
   cmp word ptr [BP-08],+00
   jle L0956026b
jmp near L095601f3
L0956026b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_ldrawsh_ega: ;; 09560271
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
   jl L095602a8
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   mov [BP-16],AX
   mov AX,[BP+10]
   mov [BP-0E],AX
jmp near L095602c6
L095602a8:
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
L095602c6:
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov DX,[BP+0C]
   add DX,[BP+10]
   cmp AX,DX
   jg L09560300
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
L09560300:
   cmp word ptr [BP-0E],+00
   jg L09560309
jmp near L09560552
L09560309:
   cmp word ptr [BP+16],+03
   jz L09560312
jmp near L09560443
L09560312:
   test word ptr [BP+0A],0007
   jz L0956031c
jmp near L09560443
L0956031c:
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
   jl L09560351
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-18],AX
   mov AX,[BP+0E]
   mov [BP-10],AX
jmp near L09560377
L09560351:
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
L09560377:
   mov AX,[BP+0E]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,[BP+0A]
   les BX,[BP+06]
   cmp AX,[ES:BX+04]
   jl L095603c8
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
L095603c8:
   cmp word ptr [BP-10],+00
   jg L095603d1
jmp near L09560552
L095603d1:
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
L0956040a:
   mov DX,03C4
   mov AL,02
   mov AH,[BP-01]
   out DX,AX
   mov BX,[BP-10]
   les DI,[BP-20]
   add SI,[BP-0C]
   mov DX,[BP-0E]
L0956041f:
   add SI,[BP-08]
   mov CX,BX
L09560424:
   lodsb
   and [ES:DI],AL
   inc DI
   loop L09560424
   add DI,+28
   sub DI,BX
   add SI,[BP-06]
   dec DX
   jnz L0956041f
   add SI,[BP-0A]
   ror byte ptr [BP-01],1
   jnb L0956040a
   pop ES
   pop DS
jmp near L09560552
L09560443:
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
jmp near L0956054a

X095604d7:
   nop
L095604d8:
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
L095604f7:
   push BX
   cmp BX,[BP-14]
   jl L0956052a
   cmp BX,[BP-12]
   jg L0956052a
   les DI,[BP+12]
   mov BX,[ES:DI]
   mov CL,[BP-04]
   shr BX,CL
   and BX,+0F
   mov BH,[BP+16]
   shl BX,1
   mov CX,[BX+offset _cmtab]
   cmp CL,10
   jz L0956052a
   mov AL,08
   mov AH,[BP-02]
   out DX,AX
   les DI,[BP-20]
   and [ES:DI],CL
L0956052a:
   ror byte ptr [BP-02],1
   jnb L09560532
   inc word ptr [BP-20]
L09560532:
   xor byte ptr [BP-04],04
   jnz L0956053b
   inc word ptr [BP+12]
L0956053b:
   pop BX
   inc BX
   cmp BX,[BP+0E]
   jl L095604f7
   pop ES
   add word ptr [BP-1C],+28
   dec word ptr [BP-0E]
L0956054a:
   cmp word ptr [BP-0E],+00
   jle L09560552
jmp near L095604d8
L09560552:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_ldrawsh_vga: ;; 09560558
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
   jl L0956058f
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   mov [BP-16],AX
   mov AX,[BP+10]
   mov [BP-0E],AX
jmp near L095605ad
L0956058f:
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
L095605ad:
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov DX,[BP+0C]
   add DX,[BP+10]
   cmp AX,DX
   jg L095605e7
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
L095605e7:
   cmp word ptr [BP-0E],+00
   jg L095605f0
jmp near L09560830
L095605f0:
   cmp word ptr [BP+16],+03
   jz L095605f9
jmp near L09560738
L095605f9:
   test word ptr [BP+0A],0003
   jz L09560603
jmp near L09560738
L09560603:
   sar word ptr [BP+0E],1
   sar word ptr [BP+0E],1
   sar word ptr [BP-0C],1
   sar word ptr [BP-0C],1
   sar word ptr [BP-0A],1
   sar word ptr [BP-0A],1
   cmp word ptr [BP+0A],+00
   jl L0956062f
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-18],AX
   mov AX,[BP+0E]
   mov [BP-10],AX
jmp near L09560651
L0956062f:
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
L09560651:
   mov AX,[BP+0E]
   shl AX,1
   shl AX,1
   add AX,[BP+0A]
   les BX,[BP+06]
   cmp AX,[ES:BX+04]
   jl L09560698
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
L09560698:
   cmp word ptr [BP-10],+00
   jg L095606a1
jmp near L09560830
L095606a1:
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
L09560703:
   mov DX,03C4
   mov AL,02
   mov AH,[BP-01]
   out DX,AX
   mov BX,[BP-10]
   les DI,[BP-20]
   add SI,[BP-0C]
   mov DX,[BP-0E]
L09560718:
   add SI,[BP-08]
   mov CX,BX
   repz movsb
   add DI,+50
   sub DI,BX
   add SI,[BP-06]
   dec DX
   jnz L09560718
   add SI,[BP-0A]
   ror byte ptr [BP-01],1
   jnb L09560703
   pop ES
   pop DS
   out DX,AX
jmp near L09560830
L09560738:
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
jmp near L09560827
L0956078b:
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
   jnz L095607e2
L095607ab:
   push BX
   cmp BX,[BP-14]
   jl L095607cd
   cmp BX,[BP-12]
   jg L095607cd
   les DI,[BP+12]
   mov CL,[ES:DI]
   cmp CL,00
   jz L095607cd
   mov AL,02
   mov AH,[BP-02]
   out DX,AX
   les DI,[BP-20]
   mov [ES:DI],CL
L095607cd:
   rol byte ptr [BP-02],1
   jnb L095607d5
   inc word ptr [BP-20]
L095607d5:
   inc word ptr [BP+12]
   pop BX
   inc BX
   cmp BX,[BP+0E]
   jl L095607ab
jmp near L0956081f

X095607e1:
   nop
L095607e2:
   push BX
   cmp BX,[BP-14]
   jl L0956080d
   cmp BX,[BP-12]
   jg L0956080d
   les DI,[BP+12]
   mov BX,[ES:DI]
   mov BH,[BP+16]
   shl BX,1
   mov CX,[BX+offset _cmtab]
   cmp CL,FF
   jz L0956080d
   mov AL,02
   mov AH,[BP-02]
   out DX,AX
   les DI,[BP-20]
   mov [ES:DI],CL
L0956080d:
   rol byte ptr [BP-02],1
   jnb L09560815
   inc word ptr [BP-20]
L09560815:
   inc word ptr [BP+12]
   pop BX
   inc BX
   cmp BX,[BP+0E]
   jl L095607e2
L0956081f:
   pop ES
   add word ptr [BP-1C],+50
   dec word ptr [BP-0E]
L09560827:
   cmp word ptr [BP-0E],+00
   jle L09560830
jmp near L0956078b
L09560830:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_ldrawsh_mcga: ;; 09560836 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+18
   push SI
   push DI
   cmp word ptr [BP+0C],+00
   jl L09560859
   les BX,[BP+06]
   mov AX,[ES:BX+02]
   add AX,[BP+0C]
   mov [BP-0E],AX
   mov AX,[BP+10]
   mov [BP-04],AX
jmp near L09560877
L09560859:
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
L09560877:
   les BX,[BP+06]
   mov AX,[ES:BX+06]
   mov DX,[BP+0C]
   add DX,[BP+10]
   cmp AX,DX
   jg L0956089a
   les BX,[BP+06]
   mov AX,[BP+0C]
   add AX,[BP+10]
   mov DX,[ES:BX+06]
   sub AX,DX
   sub [BP-04],AX
L0956089a:
   cmp word ptr [BP-04],+00
   jg L095608a3
jmp near L095609f3
L095608a3:
   cmp word ptr [BP+16],+03
   jz L095608ac
jmp near L09560967
L095608ac:
   cmp word ptr [BP+0A],+00
   jl L095608cb
   les BX,[BP+06]
   mov AX,[ES:BX]
   add AX,[BP+0A]
   mov [BP-10],AX
   mov AX,[BP+0E]
   mov [BP-06],AX
   mov word ptr [BP-02],0000
jmp near L095608eb
L095608cb:
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
L095608eb:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov DX,[BP+0A]
   add DX,[BP+0E]
   cmp AX,DX
   jg L09560920
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
L09560920:
   cmp word ptr [BP-06],+00
   jg L09560929
jmp near L095609f3
L09560929:
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
L09560953:
   mov CX,AX
   repz movsb
   add DI,0140
   sub DI,AX
   add SI,BX
   dec DX
   jnz L09560953
   pop ES
   pop DS
jmp near L095609f3
L09560967:
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
jmp near L095609eb

X095609a3:
   nop
L095609a4:
   les BX,[BP-14]
   mov [BP-16],ES
   mov [BP-18],BX
   push ES
   mov DX,0000
L095609b1:
   cmp DX,[BP-0A]
   jl L095609d6
   cmp DX,[BP-08]
   jg L095609d6
   les DI,[BP+12]
   mov BL,[ES:DI]
   mov BH,[BP+16]
   shl BX,1
   mov AL,[BX+offset _cmtab]
   xor AH,AH
   cmp AL,FF
   jz L095609d6
   les DI,[BP-18]
   mov [ES:DI],AL
L095609d6:
   inc word ptr [BP+12]
   inc word ptr [BP-18]
   inc DX
   cmp DX,[BP+0E]
   jl L095609b1
   pop ES
   add word ptr [BP-14],0140
   dec word ptr [BP-04]
L095609eb:
   cmp word ptr [BP-04],+00
   jle L095609f3
jmp near L095609a4
L095609f3:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_scroll: ;; 095609f9
   push BP
   mov BP,SP
   sub SP,+16
   push SI
   push DI
   cmp word ptr [BP+0A],+00
   jge L09560a0e
   mov word ptr [BP+0A],0000
jmp near L09560a24
L09560a0e:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+0A]
   jge L09560a24
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov [BP+0A],AX
L09560a24:
   cmp word ptr [BP+0E],+00
   jge L09560a31
   mov word ptr [BP+0E],0000
jmp near L09560a47
L09560a31:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+0E]
   jge L09560a47
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov [BP+0E],AX
L09560a47:
   cmp word ptr [BP+0C],+00
   jge L09560a54
   mov word ptr [BP+0C],0000
jmp near L09560a6a
L09560a54:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+0C]
   jge L09560a6a
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov [BP+0C],AX
L09560a6a:
   cmp word ptr [BP+10],+00
   jge L09560a77
   mov word ptr [BP+10],0000
jmp near L09560a8d
L09560a77:
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   cmp AX,[BP+10]
   jge L09560a8d
   les BX,[BP+06]
   mov AX,[ES:BX+04]
   mov [BP+10],AX
L09560a8d:
   mov AX,[BP+0A]
   cmp AX,[BP+0E]
   jge L09560a9d
   mov AX,[BP+0C]
   cmp AX,[BP+10]
   jl L09560aa0
L09560a9d:
jmp near L09560dfe
L09560aa0:
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
   jle L09560ad4
   mov AX,[BP+12]
   sub [BP+0E],AX
jmp near L09560ada
L09560ad4:
   mov AX,[BP+12]
   sub [BP+0A],AX
L09560ada:
   cmp word ptr [BP+14],+00
   jle L09560ae8
   mov AX,[BP+14]
   sub [BP+10],AX
jmp near L09560aee
L09560ae8:
   mov AX,[BP+14]
   sub [BP+0C],AX
L09560aee:
   mov AX,[BP+10]
   sub AX,[BP+0C]
   mov [BP-0C],AX
   mov AX,[BP+0E]
   sub AX,[BP+0A]
   mov [BP-0E],AX
   mov word ptr [BP-08],0001
   mov word ptr [BP-0A],0001
   cmp word ptr [BP+14],+00
   jle L09560b1e
   mov AX,[BP+10]
   dec AX
   mov [BP+0C],AX
   mov word ptr [BP-08],FFFF
jmp near L09560b35
L09560b1e:
   cmp word ptr [BP+14],+00
   jnz L09560b35
   cmp word ptr [BP+12],+00
   jle L09560b35
   mov AX,[BP+0E]
   mov [BP+0A],AX
   mov word ptr [BP-0A],FFFF
L09560b35:
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0006
   jbe L09560b45
jmp near L09560dfe
L09560b45:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y09560b4e]
Y09560b4e:	dw L09560b5c,L09560dfe,L09560c21,L09560dfe,L09560cde,L09560dfe,L09560d88
L09560b5c:
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
   jz L09560bb4
   mov AX,E050
jmp near L09560bb7
L09560bb4:
   mov AX,2000
L09560bb7:
   mov [BP-06],AX
   mov AX,[BP-08]
   dec AX
   mov BX,0002
   cwd
   idiv BX
   add AX,[BP+0C]
   add AX,[BP+14]
   test AX,0001
   jz L09560bd4
   mov AX,E050
jmp near L09560bd7
L09560bd4:
   mov AX,2000
L09560bd7:
   mov [BP-04],AX
   push ES
   push DS
   mov DX,[BP-0C]
   cld
   cmp word ptr [BP-0A],+00
   jge L09560bef
   std
   sub word ptr [BP-16],+02
   sub word ptr [BP-12],+02
L09560bef:
   lds SI,[BP-16]
   les DI,[BP-12]
   mov CX,[BP-0E]
   repz movsw
   mov AX,[BP-06]
   mov BX,[BP-04]
   cmp word ptr [BP-08],+00
   jge L09560c0a
   neg AX
   neg BX
L09560c0a:
   add [BP-16],AX
   add [BP-12],BX
   mov AX,C050
   xor [BP-06],AX
   xor [BP-04],AX
   dec DX
   jnz L09560bef
   pop DS
   pop ES
jmp near L09560dfe
L09560c21:
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
   jge L09560cb3
   std
   dec word ptr [BP-16]
   dec word ptr [BP-12]
L09560cb3:
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
   jnz L09560cb3
   pop DS
   pop ES
jmp near L09560dfe
L09560cde:
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
   cmp word ptr [BP-0A],+00
   jge L09560d5d
   std
   dec word ptr [BP-16]
   dec word ptr [BP-12]
L09560d5d:
   lds SI,[BP-16]
   les DI,[BP-12]
   mov CX,[BP-0E]
   push AX
   push DX
   mov DX,03CE
   mov AX,4105
   out DX,AX
   mov DX,03C4
   mov AX,0F02
   out DX,AX
   pop DX
   pop AX
   repz movsb
   add [BP-16],AX
   add [BP-12],AX
   dec BX
   jnz L09560d5d
   pop DS
   pop ES
jmp near L09560dfe

X09560d87:
   nop
L09560d88:
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
   jge L09560de6
   std
   sub word ptr [BP-16],+02
   sub word ptr [BP-12],+02
L09560de6:
   lds SI,[BP-16]
   les DI,[BP-12]
   mov CX,[BP-0E]
   repz movsw
   add [BP-16],AX
   add [BP-12],AX
   dec BX
   jnz L09560de6
   pop DS
   pop ES
jmp near L09560dfe
L09560dfe:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_lcopypage: ;; 09560e04
   push SI
   push DI
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jz L09560e23
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0004
   jz L09560e23
jmp near L09560e7c

X09560e22:
   nop
L09560e23:
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jnz L09560e42
   mov AX,0105
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
jmp near L09560e52
L09560e42:
   mov AX,4105
   push AX
   mov AX,03CE
   push AX
   call far _outport
   add SP,+04
L09560e52:
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
L09560e7c:
   pop DI
   pop SI
ret far

_scrollvp: ;; 09560e7f
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

_clrvp: ;; 09560eaa
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0006
   jbe L09560ec2
jmp near L095610c5
L09560ec2:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y09560ecb]
Y09560ecb:	dw L09560ed9,L095610c5,L09560f76,L095610c5,L0956101e,L095610c5,L095610c3
L09560ed9:
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
   jz L09560f4d
   mov AX,E050
jmp near L09560f50
L09560f4d:
   mov AX,2000
L09560f50:
   mov [BP-08],AX
   push ES
   cld
   mov DX,[BP-08]
   mov BX,[BP-0A]
   mov AL,[BP-01]
   mov AH,AL
L09560f60:
   les DI,[BP-06]
   mov CX,[BP-0C]
   repz stosw
   add [BP-06],DX
   xor DX,C050
   dec BX
   jnz L09560f60
   pop ES
jmp near L095610c5
L09560f76:
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
L09561008:
   les DI,[BP-06]
   mov AL,[BP+0A]
   mov CX,[BP-0C]
   repz stosb
   add word ptr [BP-06],+28
   dec BX
   jnz L09561008
   pop ES
jmp near L095610c5
L0956101e:
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
L095610ac:
   les DI,[BP-06]
   mov AL,[BP+0A]
   mov AH,AL
   mov CX,[BP-0C]
   repnz stosw
   add word ptr [BP-06],+50
   dec BX
   jnz L095610ac
   pop ES
jmp near L095610c5
L095610c3:
jmp near L095610c5
L095610c5:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Y095610cb:	byte

Segment 0a62 ;; GRASM.ASM:GRASM
A0a62000c:
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

A0a620030:
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

A0a620053:
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

X0a620071:
   xchg AH,AL
   add BX,AX
   shr AX,1
   shr AX,1
   add BX,AX
   mov AX,A000
   mov ES,AX
ret far

_plot_cga: ;; 0a620081
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a62000c
   mov AL,[BP+0A]
   shl AX,CL
   not AH
   and [ES:BX],AH
   or [ES:BX],AL
   mov SP,BP
   pop BP
ret far

_plot_ega: ;; 0a6200a0
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a620030
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

X0a6200d3:
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a620053
   mov AL,[BP+0A]
   mov [ES:BX],AL
   mov SP,BP
   pop BP
ret far

_plot_vga: ;; 0a6200eb
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a620053
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

_readpix_vga: ;; 0a62011a ;; 1a:00
   push BP
   mov BP,SP
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a620053
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

_line_cga: ;; 0a62014e
   push BP
   mov BP,SP
   sub SP,+08
   push SI
   push DI
   mov SI,2000
   mov DI,E050
   mov CX,[BP+0A]
   sub CX,[BP+06]
   jz L0a6201d3
   jns L0a62017a
   neg CX
   mov BX,[BP+0A]
   xchg BX,[BP+06]
   mov [BP+0A],BX
   mov BX,[BP+0C]
   xchg BX,[BP+08]
   mov [BP+0C],BX
L0a62017a:
   mov BX,[BP+0C]
   sub BX,[BP+08]
   jnz L0a620185
jmp near L0a62020a
L0a620185:
   jns L0a62018f
   neg BX
   neg SI
   neg DI
   xchg SI,DI
L0a62018f:
   mov [BP-02],DI
   mov word ptr [BP-08],offset L0a62026e
   cmp BX,CX
   jle L0a6201a2
   mov word ptr [BP-08],offset L0a6202b7
   xchg BX,CX
L0a6201a2:
   shl BX,1
   mov [BP-04],BX
   sub BX,CX
   mov DI,BX
   sub BX,CX
   mov [BP-06],BX
   push CX
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a62000c
   mov AL,[BP+0E]
   shl AX,CL
   mov DX,AX
   not DH
   pop CX
   inc CX
   test BX,2000
   jz L0a6201d0
   xchg SI,[BP-02]
L0a6201d0:
jmp near [BP-08]
L0a6201d3:
   mov AX,[BP+08]
   mov BX,[BP+0C]
   mov CX,BX
   sub CX,AX
   jge L0a6201e3
   neg CX
   mov AX,BX
L0a6201e3:
   inc CX
   mov BX,[BP+06]
   push CX
   call far A0a62000c
   mov AL,[BP+0E]
   shl AX,CL
   not AH
   pop CX
   test BX,SI
   jz L0a6201fb
   xchg SI,DI
L0a6201fb:
   and [ES:BX],AH
   or [ES:BX],AL
   add BX,SI
   xchg SI,DI
   loop L0a6201fb
jmp near L0a6202de
L0a62020a:
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a62000c
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
   mov BX,offset Y0a6202e4
   mov AL,[BP+0E]
   xlat
   or DH,DH
   js L0a62025f
   or CX,CX
   jnz L0a620251
   and DL,DH
jmp near L0a620261
L0a620251:
   mov AH,AL
   and AH,DH
   not DH
   and [ES:DI],DH
   or [ES:DI],AH
   inc DI
   dec CX
L0a62025f:
   repz stosb
L0a620261:
   and AL,DL
   not DL
   and [ES:DI],DL
   or [ES:DI],AL
jmp near L0a6202de

X0a62026d:
   nop
L0a62026e:
   mov AH,[ES:BX]
L0a620271:
   and AH,DH
   or AH,DL
   ror DL,1
   ror DL,1
   ror DH,1
   ror DH,1
   jnb L0a62029c
   or DI,DI
   jns L0a62028d
   add DI,[BP-04]
   loop L0a620271
   mov [ES:BX],AH
jmp near L0a6202de
L0a62028d:
   add DI,[BP-06]
   mov [ES:BX],AH
   add BX,SI
   xchg SI,[BP-02]
   loop L0a62026e
jmp near L0a6202de
L0a62029c:
   mov [ES:BX],AH
   inc BX
   or DI,DI
   jns L0a6202ab
   add DI,[BP-04]
   loop L0a62026e
jmp near L0a6202de
L0a6202ab:
   add DI,[BP-06]
   add BX,SI
   xchg SI,[BP-02]
   loop L0a62026e
jmp near L0a6202de
L0a6202b7:
   and [ES:BX],DH
   or [ES:BX],DL
   add BX,SI
   xchg SI,[BP-02]
   or DI,DI
   jns L0a6202cd
   add DI,[BP-04]
   loop L0a6202b7
jmp near L0a6202de
L0a6202cd:
   add DI,[BP-06]
   ror DL,1
   ror DL,1
   ror DH,1
   ror DH,1
   cmc
   adc BX,+00
   loop L0a6202b7
L0a6202de:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Y0a6202e4:	db 00,55,aa,ff

_drawsh_cga: ;; 0a6202e8 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+02
   push DS
   push SI
   push DI
   mov AX,[BP+08]
   mov BX,[BP+06]
   call far A0a62000c
   mov DI,BX
   mov BX,2000
   test DI,2000
   jz L0a62030a
   mov BX,E050
L0a62030a:
   mov [BP-02],BX
   cmp CL,00
   jnz L0a620337
   mov CX,[BP+0A]
L0a620315:
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
   jnz L0a620315
jmp near L0a62036c

X0a620336:
   nop
L0a620337:
   mov DX,00FF
   ror DX,CL
   mov BX,[BP+0A]
L0a62033f:
   push DI
   push BX
   push DS
   lds SI,[BP+06]
L0a620345:
   and [ES:DI],DX
   lodsb
   xor AH,AH
   rol AX,CL
   or [ES:DI],AX
   inc DI
   dec BX
   jnz L0a620345
   pop DS
   pop BX
   pop DI
   mov CX,[BP+08]
   add CX,BX
   mov [BP+08],CX
   add DI,[BP-02]
   xor word ptr [BP-02],C050
   dec word ptr [BP+0C]
   jnz L0a62033f
L0a62036c:
   pop DI
   pop SI
   pop DS
   mov SP,BP
   pop BP
ret far

Segment 0a99 ;; GAMEKEYBOARD.C:KEYBOARD
_k_pressed: ;; 0a990003
   push BP
   mov BP,SP
   sub SP,+14
   cmp [offset __stklen],SP
   ja L0a990014
   call far OVERFLOW@
L0a990014:
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
   jnz L0a99005d
   mov AX,[BP-14]
   mov CL,08
   shr AX,CL
   or AX,0080
   push AX
   test word ptr [BP-14],00FF
   jnz L0a99004d
   mov DX,0001
jmp near L0a99004f
L0a99004d:
   xor DX,DX
L0a99004f:
   pop AX
   mul DX
   mov DX,[BP-14]
   and DX,00FF
   add AX,DX
jmp near L0a990061
L0a99005d:
   xor AX,AX
jmp near L0a990061
L0a990061:
   mov SP,BP
   pop BP
ret far

_k_read: ;; 0a990065
   push BP
   mov BP,SP
   sub SP,+14
   cmp [offset __stklen],SP
   ja L0a990076
   call far OVERFLOW@
L0a990076:
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
   jnz L0a9900a3
   mov DX,0001
jmp near L0a9900a5
L0a9900a3:
   xor DX,DX
L0a9900a5:
   pop AX
   mul DX
   mov DX,[BP-14]
   and DX,00FF
   add AX,DX
jmp near L0a9900b3
L0a9900b3:
   mov SP,BP
   pop BP
ret far

_k_status: ;; 0a9900b7
   push BP
   mov BP,SP
   sub SP,+14
   cmp [offset __stklen],SP
   ja L0a9900c8
   call far OVERFLOW@
L0a9900c8:
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

_handler: ;; 0a990124
   push AX
   push BX
   push CX
   push DX
   push ES
   push DS
   push SI
   push DI
   push BP
   mov BP,segment A24dc0000
   mov DS,BP
   cmp [offset __stklen],SP
   ja L0a99013d
   call far OVERFLOW@
L0a99013d:
   cli
   xor AX,AX
   in AL,60
   cmp AL,E0
   jnz L0a99014f
   mov word ptr [offset _e0code],0100
jmp near L0a990172
X0a99014e:
   nop
L0a99014f:
   test AL,80
   jnz L0a990163
   mov BX,AX
   mov word ptr [offset _e0code],0000
   mov byte ptr [BX+offset _keydown],01
jmp near L0a990172
X0a990162:
   nop
L0a990163:
   and AL,7F
   mov BX,AX
   mov word ptr [offset _e0code],0000
   mov byte ptr [BX+offset _keydown],00
L0a990172:
   cmp byte ptr [offset _bioscall],01
   jnz L0a990181
   pushf
   call far [offset _oldint9]
jmp near L0a990185
X0a990180:
   nop
L0a990181:
   mov AL,20
   out 20,AL
L0a990185:
jmp near L0a990187
L0a990187:
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

_installhandler: ;; 0a990191
   push BP
   mov BP,SP
   cmp [offset __stklen],SP
   ja L0a99019f
   call far OVERFLOW@
L0a99019f:
   mov word ptr [offset _bhead+2],0040
   mov word ptr [offset _bhead+0],001A
   mov word ptr [offset _btail+2],0040
   mov word ptr [offset _btail+0],001C
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
   mov SP,BP
   mov [offset _oldint9+02],DX
   mov [offset _oldint9],AX
   mov AL,[BP+06]
   mov [offset _bioscall],AL
   push CS
   mov AX,offset _handler
   push AX
   mov AX,0009
   push AX
   call far _setvect
   mov SP,BP
   pop BP
ret far

_removehandler: ;; 0a9901f4
   cmp [offset __stklen],SP
   ja L0a9901ff
   call far OVERFLOW@
L0a9901ff:
   push [offset _oldint9+02]
   push [offset _oldint9]
   mov AX,0009
   push AX
   call far _setvect
   add SP,+06
ret far

_disablebios: ;; 0a990214 ;; (@) Unaccessed.
   cmp [offset __stklen],SP
   ja L0a99021f
   call far OVERFLOW@
L0a99021f:
   mov byte ptr [offset _bioscall],00
ret far

_enablebios: ;; 0a990225 ;; (@) Unaccessed.
   cmp [offset __stklen],SP
   ja L0a990230
   call far OVERFLOW@
L0a990230:
   les BX,[offset _btail]
   mov AX,[ES:BX]
   les BX,[offset _bhead]
   mov [ES:BX],AX
   mov byte ptr [offset _bioscall],01
ret far

_biosstatus: ;; 0a990244 ;; (@) Unaccessed.
   cmp [offset __stklen],SP
   ja L0a99024f
   call far OVERFLOW@
L0a99024f:
   cmp byte ptr [offset _bioscall],00
   jnz L0a99025c
   xor AX,AX
jmp near L0a990261

X0a99025a:
jmp near L0a990261
L0a99025c:
   mov AX,0001
jmp near L0a990261
L0a990261:
ret far

Segment 0abf ;; WIN.C:WIN
_defwin: ;; 0abf0002
   push BP
   mov BP,SP
   mov AX,[BP+16]
   les BX,[BP+06]
   mov [ES:BX],AX
   xor AX,AX
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _initvp
   mov SP,BP
   mov AX,[BP+0A]
   shl AX,1
   shl AX,1
   shl AX,1
   les BX,[BP+06]
   mov [ES:BX+18],AX
   mov AX,[BP+0C]
   les BX,[BP+06]
   mov [ES:BX+1A],AX
   mov AX,[BP+0E]
   mov CL,04
   shl AX,CL
   add AX,0010
   les BX,[BP+06]
   mov [ES:BX+1C],AX
   mov AX,[BP+10]
   mov CL,04
   shl AX,CL
   push AX
   test word ptr [BP+16],0002
   jz L0abf0062
   mov AX,0010
jmp near L0abf0065
L0abf0062:
   mov AX,001C
L0abf0065:
   pop DX
   add DX,AX
   les BX,[BP+06]
   mov [ES:BX+1E],DX
   xor AX,AX
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0028
   push DX
   push AX
   call far _initvp
   mov SP,BP
   mov AX,[BP+0A]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,0008
   les BX,[BP+06]
   mov [ES:BX+28],AX
   test word ptr [BP+16],0002
   jz L0abf00a3
   mov AX,0008
jmp near L0abf00a6
L0abf00a3:
   mov AX,0010
L0abf00a6:
   add AX,[BP+0C]
   les BX,[BP+06]
   mov [ES:BX+2A],AX
   mov AX,[BP+0E]
   mov CL,04
   shl AX,CL
   les BX,[BP+06]
   mov [ES:BX+2C],AX
   mov AX,[BP+10]
   mov CL,04
   shl AX,CL
   les BX,[BP+06]
   mov [ES:BX+2E],AX
   cmp word ptr [BP+12],+00
   jz L0abf00f4
   mov AX,[BP+12]
   mov CL,04
   shl AX,CL
   add AX,0008
   les BX,[BP+06]
   sub [ES:BX+2C],AX
   mov AX,[BP+12]
   mov CL,04
   shl AX,CL
   add AX,0008
   les BX,[BP+06]
   add [ES:BX+28],AX
L0abf00f4:
   mov AX,0008
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0038
   push DX
   push AX
   call far _initvp
   mov SP,BP
   mov AX,[BP+0A]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,0008
   les BX,[BP+06]
   mov [ES:BX+38],AX
   mov AX,[BP+0C]
   add AX,0010
   les BX,[BP+06]
   mov [ES:BX+3A],AX
   mov AX,[BP+12]
   mov CL,04
   shl AX,CL
   les BX,[BP+06]
   mov [ES:BX+3C],AX
   mov AX,[BP+14]
   mov CL,04
   shl AX,CL
   add AX,0005
   les BX,[BP+06]
   mov [ES:BX+3E],AX
   mov AX,0008
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0048
   push DX
   push AX
   call far _initvp
   mov SP,BP
   mov AX,[BP+0A]
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
   les BX,[BP+06]
   mov [ES:BX+4A],AX
   mov AX,[BP+12]
   mov CL,04
   shl AX,CL
   les BX,[BP+06]
   mov [ES:BX+4C],AX
   mov AX,[BP+10]
   mov CL,04
   shl AX,CL
   mov DX,[BP+14]
   mov CL,04
   shl DX,CL
   sub AX,DX
   add AX,FFF5
   les BX,[BP+06]
   mov [ES:BX+4E],AX
   mov AX,[BP+0A]
   les BX,[BP+06]
   mov [ES:BX+04],AX
   mov AX,[BP+0A]
   shl AX,1
   shl AX,1
   shl AX,1
   les BX,[BP+06]
   mov [ES:BX+02],AX
   mov AX,[BP+0C]
   les BX,[BP+06]
   mov [ES:BX+06],AX
   mov AX,[BP+0E]
   les BX,[BP+06]
   mov [ES:BX+0A],AX
   mov AX,[BP+0E]
   mov CL,04
   shl AX,CL
   les BX,[BP+06]
   mov [ES:BX+08],AX
   mov AX,[BP+10]
   les BX,[BP+06]
   mov [ES:BX+0E],AX
   mov AX,[BP+10]
   mov CL,04
   shl AX,CL
   les BX,[BP+06]
   mov [ES:BX+0C],AX
   mov AX,[BP+12]
   les BX,[BP+06]
   mov [ES:BX+12],AX
   mov AX,[BP+12]
   mov CL,04
   shl AX,CL
   les BX,[BP+06]
   mov [ES:BX+10],AX
   mov AX,[BP+14]
   les BX,[BP+06]
   mov [ES:BX+16],AX
   mov AX,[BP+14]
   mov CL,04
   shl AX,CL
   les BX,[BP+06]
   mov [ES:BX+14],AX
   pop BP
ret far

_drawwin: ;; 0abf0234
   push BP
   mov BP,SP
   sub SP,+04
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
   jnz L0abf0259
jmp near L0abf041d
L0abf0259:
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AX,4701
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
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
   xor AX,AX
   push AX
   mov AX,4706
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
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,4708
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   mov word ptr [BP-04],0001
jmp near L0abf0347
L0abf02f4:
   xor AX,AX
   push AX
   mov AX,[BP-04]
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
   mov AX,[BP-04]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,4707
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   inc word ptr [BP-04]
L0abf0347:
   les BX,[BP+06]
   mov AX,[ES:BX+0A]
   shl AX,1
   inc AX
   cmp AX,[BP-04]
   jg L0abf02f4
   mov word ptr [BP-04],0001
jmp near L0abf03b0
L0abf035d:
   mov AX,[BP-04]
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
   mov AX,[BP-04]
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
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   inc word ptr [BP-04]
L0abf03b0:
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   shl AX,1
   inc AX
   cmp AX,[BP-04]
   jg L0abf035d
   mov word ptr [BP-04],0000
jmp near L0abf040c
L0abf03c6:
   mov word ptr [BP-02],0000
jmp near L0abf03fb
L0abf03cd:
   mov AX,[BP-02]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,[BP-04]
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
   inc word ptr [BP-02]
L0abf03fb:
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   shl AX,1
   cmp AX,[BP-02]
   jg L0abf03cd
   inc word ptr [BP-04]
L0abf040c:
   les BX,[BP+06]
   mov AX,[ES:BX+0A]
   shl AX,1
   cmp AX,[BP-04]
   jg L0abf03c6
jmp near L0abf0770
L0abf041d:
   xor AX,AX
   push AX
   xor AX,AX
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
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,4307
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
   xor AX,AX
   push AX
   mov AX,4305
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   mov word ptr [BP-04],0000
jmp near L0abf050f
L0abf0494:
   les BX,[BP+06]
   mov AX,[ES:BX+12]
   cmp AX,[BP-04]
   jz L0abf04a5
   mov AX,0001
jmp near L0abf04a7
L0abf04a5:
   xor AX,AX
L0abf04a7:
   push AX
   cmp word ptr [BP-04],+00
   jnz L0abf04b3
   mov AX,0001
jmp near L0abf04b5
L0abf04b3:
   xor AX,AX
L0abf04b5:
   pop DX
   or DX,AX
   jz L0abf050c
   xor AX,AX
   push AX
   mov AX,[BP-04]
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
   mov AX,[BP-04]
   mov CL,04
   shl AX,CL
   add AX,0008
   push AX
   mov AX,4306
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
L0abf050c:
   inc word ptr [BP-04]
L0abf050f:
   les BX,[BP+06]
   mov AX,[ES:BX+0A]
   cmp AX,[BP-04]
   jle L0abf051e
jmp near L0abf0494
L0abf051e:
   xor AX,AX
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,4303
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   mov word ptr [BP-04],0000
jmp near L0abf05b1
L0abf054a:
   mov AX,[BP-04]
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
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   cmp word ptr [BP-04],+00
   jz L0abf0589
   les BX,[BP+06]
   mov AX,[ES:BX+16]
   cmp AX,[BP-04]
   jz L0abf05ae
L0abf0589:
   mov AX,[BP-04]
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
L0abf05ae:
   inc word ptr [BP-04]
L0abf05b1:
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   cmp AX,[BP-04]
   jg L0abf054a
   les BX,[BP+06]
   test word ptr [ES:BX],0001
   jz L0abf061a
   mov AX,0020
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,430E
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
   add AX,FFF0
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+08]
   add AX,0008
   push AX
   mov AX,430F
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
L0abf061a:
   les BX,[BP+06]
   cmp word ptr [ES:BX+12],+00
   jg L0abf0627
jmp near L0abf0770
L0abf0627:
   xor AX,AX
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+10]
   add AX,0008
   push AX
   mov AX,430A
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   mov word ptr [BP-04],0000
jmp near L0abf0695
L0abf0653:
   cmp word ptr [BP-04],+00
   jz L0abf0665
   les BX,[BP+06]
   mov AX,[ES:BX+16]
   cmp AX,[BP-04]
   jz L0abf0692
L0abf0665:
   mov AX,[BP-04]
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
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
L0abf0692:
   inc word ptr [BP-04]
L0abf0695:
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   cmp AX,[BP-04]
   jg L0abf0653
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   add AX,0010
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+10]
   add AX,0008
   push AX
   mov AX,4308
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   les BX,[BP+06]
   cmp word ptr [ES:BX+14],+00
   jg L0abf06db
jmp near L0abf0770
L0abf06db:
   les BX,[BP+06]
   mov AX,[ES:BX+14]
   add AX,0010
   push AX
   xor AX,AX
   push AX
   mov AX,430D
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   mov word ptr [BP-04],0000
jmp near L0abf0737
L0abf0707:
   les BX,[BP+06]
   mov AX,[ES:BX+14]
   add AX,0010
   push AX
   mov AX,[BP-04]
   mov CL,04
   shl AX,CL
   add AX,0008
   push AX
   mov AX,430C
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
   inc word ptr [BP-04]
L0abf0737:
   les BX,[BP+06]
   mov AX,[ES:BX+12]
   cmp AX,[BP-04]
   jg L0abf0707
   les BX,[BP+06]
   mov AX,[ES:BX+14]
   add AX,0010
   push AX
   les BX,[BP+06]
   mov AX,[ES:BX+10]
   add AX,0008
   push AX
   mov AX,430B
   push AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far _drawshape
   add SP,+0A
L0abf0770:
   mov SP,BP
   pop BP
ret far

_undrawwin: ;; 0abf0774
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

_wprint: ;; 0abf078b
   push BP
   mov BP,SP
   sub SP,+04
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   cmp AX,[offset _curhi]
   jnz L0abf07ab
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   cmp AX,[offset _curback]
   jz L0abf07c7
L0abf07ab:
   les BX,[BP+06]
   push [ES:BX+0E]
   les BX,[BP+06]
   push [ES:BX+0C]
   push [BP+08]
   push [BP+06]
   call far _fontcolor
   add SP,+08
L0abf07c7:
   mov AX,[BP+0E]
   cmp AX,0001
   jz L0abf07d6
   cmp AX,0002
   jz L0abf07dd
jmp near L0abf07e4
L0abf07d6:
   mov word ptr [BP-04],0008
jmp near L0abf07e9
L0abf07dd:
   mov word ptr [BP-04],0006
jmp near L0abf07e9
L0abf07e4:
   mov word ptr [BP-04],0000
L0abf07e9:
   cmp word ptr [BP-04],+00
   jz L0abf083f
   mov word ptr [BP-02],0000
jmp near L0abf082d
L0abf07f6:
   push [BP+0C]
   mov AX,[BP-04]
   mul word ptr [BP-02]
   add AX,[BP+0A]
   push AX
   mov AX,[BP+0E]
   mov CL,08
   shl AX,CL
   les BX,[BP+10]
   add BX,[BP-02]
   push AX
   mov AL,[ES:BX]
   cbw
   and AX,007F
   pop DX
   add DX,AX
   push DX
   push [BP+08]
   push [BP+06]
   call far _drawshape
   add SP,+0A
   inc word ptr [BP-02]
L0abf082d:
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   cmp AX,[BP-02]
   ja L0abf07f6
L0abf083f:
   mov SP,BP
   pop BP
ret far

_wgetkey: ;; 0abf0843
   push BP
   mov BP,SP
   sub SP,+04
   mov byte ptr [BP-03],00
jmp near L0abf0890
L0abf084f:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   mov [BP-02],AX
L0abf0859:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   cmp AX,[BP-02]
   jz L0abf0859
   mov AL,[offset _cursorchar]
   and AL,07
   inc AL
   mov [offset _cursorchar],AL
   mov AL,[offset _cursorchar]
   mov [BP-04],AL
   push SS
   lea AX,[BP-04]
   push AX
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wprint
   add SP,+0E
L0abf0890:
   call far _k_pressed
   or AX,AX
   jz L0abf084f
   push DS
   mov AX,offset Y24dc04be
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
jmp near L0abf08bb
L0abf08bb:
   mov SP,BP
   pop BP
ret far

_winput: ;; 0abf08bf
   push BP
   mov BP,SP
   sub SP,+0A
   mov word ptr [BP-02],0001
   mov AX,[BP+0E]
   cmp AX,0001
   jz L0abf08d9
   cmp AX,0002
   jz L0abf08e0
jmp near L0abf08e7
L0abf08d9:
   mov word ptr [BP-08],0008
jmp near L0abf08ec
L0abf08e0:
   mov word ptr [BP-08],0006
jmp near L0abf08ec
L0abf08e7:
   mov word ptr [BP-08],0000
L0abf08ec:
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
   mov byte ptr [BP-03],00
L0abf090c:
   push [BP+0E]
   push [BP+0C]
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   mul word ptr [BP-08]
   add AX,[BP+0A]
   push AX
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wgetkey
   add SP,+0A
   mov [BP-0A],AX
   cmp word ptr [BP-0A],+20
   jge L0abf093f
jmp near L0abf0a0c
L0abf093f:
   cmp word ptr [BP-0A],0080
   jl L0abf0949
jmp near L0abf0a0c
L0abf0949:
   cmp word ptr [BP-02],+00
   jz L0abf09a9
   mov word ptr [BP-02],0000
jmp near L0abf0963
L0abf0956:
   les BX,[BP+10]
   add BX,[BP-02]
   mov byte ptr [ES:BX],20
   inc word ptr [BP-02]
L0abf0963:
   les BX,[BP+10]
   add BX,[BP-02]
   cmp byte ptr [ES:BX],00
   jnz L0abf0956
   les BX,[BP+10]
   add BX,[BP-02]
   mov byte ptr [ES:BX],20
   inc word ptr [BP-02]
   les BX,[BP+10]
   add BX,[BP-02]
   mov byte ptr [ES:BX],00
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
   les BX,[BP+10]
   mov byte ptr [ES:BX],00
L0abf09a9:
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   cmp AX,[BP+14]
   jnb L0abf0a0a
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   mov [BP-06],AX
   mov AL,[BP-0A]
   les BX,[BP+10]
   add BX,[BP-06]
   mov [ES:BX],AL
   les BX,[BP+10]
   add BX,[BP-06]
   mov byte ptr [ES:BX+01],00
   mov AL,[BP-0A]
   mov [BP-04],AL
   push SS
   lea AX,[BP-04]
   push AX
   push [BP+0E]
   push [BP+0C]
   mov AX,[BP-08]
   mul word ptr [BP-06]
   add AX,[BP+0A]
   push AX
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wprint
   add SP,+0E
L0abf0a0a:
jmp near L0abf0a41
L0abf0a0c:
   cmp word ptr [BP-0A],+08
   jz L0abf0a19
   cmp word ptr [BP-0A],00CB
   jnz L0abf0a41
L0abf0a19:
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   or AX,AX
   jbe L0abf0a41
   push [BP+12]
   push [BP+10]
   call far _strlen
   pop CX
   pop CX
   dec AX
   les BX,[BP+10]
   add BX,AX
   mov byte ptr [ES:BX],00
L0abf0a41:
   mov word ptr [BP-02],0000
   cmp word ptr [BP-0A],+0D
   jz L0abf0a55
   cmp word ptr [BP-0A],+1B
   jz L0abf0a55
jmp near L0abf090c
L0abf0a55:
   mov SP,BP
   pop BP
ret far

_wprintc: ;; 0abf0a59 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   sub SP,+02
   mov AX,[BP+0C]
   cmp AX,0001
   jz L0abf0a6e
   cmp AX,0002
   jz L0abf0a75
jmp near L0abf0a7c
L0abf0a6e:
   mov word ptr [BP-02],0008
jmp near L0abf0a81
L0abf0a75:
   mov word ptr [BP-02],0006
jmp near L0abf0a81
L0abf0a7c:
   mov word ptr [BP-02],0000
L0abf0a81:
   push [BP+10]
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+10]
   push [BP+0E]
   call far _strlen
   pop CX
   pop CX
   mul word ptr [BP-02]
   shr AX,1
   les BX,[BP+06]
   mov DX,[ES:BX+04]
   sub DX,AX
   push DX
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _wprint
   add SP,+0E
   mov SP,BP
   pop BP
ret far

_titlewin: ;; 0abf0aba
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
   les BX,[BP+06]
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

_titletop: ;; 0abf0b0b
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

_titlebot: ;; 0abf0b56
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

_initvp: ;; 0abf0ba8
   push BP
   mov BP,SP
   les BX,[BP+06]
   mov word ptr [ES:BX+08],0000
   les BX,[BP+06]
   mov word ptr [ES:BX+0A],0000
   les BX,[BP+06]
   mov word ptr [ES:BX+0C],0001
   mov AX,[BP+0A]
   les BX,[BP+06]
   mov [ES:BX+0E],AX
   pop BP
ret far

_clearvp: ;; 0abf0bd2
   push BP
   mov BP,SP
   les BX,[BP+06]
   mov AL,[ES:BX+0E]
   push AX
   push [BP+08]
   push [BP+06]
   call far _clrvp
   mov SP,BP
   pop BP
ret far

_fontcolor: ;; 0abf0bec
   push BP
   mov BP,SP
   sub SP,+02
   push [BP+0A]
   call far _abs
   pop CX
   neg AX
   mov [BP+0A],AX
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   or AX,AX
   jz L0abf0c19
   cmp AX,0002
   jz L0abf0c1c
   cmp AX,0004
   jz L0abf0c62
jmp near L0abf0c99
L0abf0c19:
jmp near L0abf0c99
L0abf0c1c:
   cmp word ptr [BP+0A],+00
   jl L0abf0c39
   mov AX,[BP+0A]
   and AX,0007
   add AX,0008
   mov [BP+0A],AX
   mov AX,[BP+0A]
   and AX,0007
   mov [BP-02],AX
jmp near L0abf0c51
L0abf0c39:
   push [BP+0A]
   call far _abs
   pop CX
   and AX,0007
   add AX,0008
   mov [BP+0A],AX
   mov AX,[BP+0A]
   mov [BP-02],AX
L0abf0c51:
   cmp word ptr [BP+0C],-01
   jz L0abf0c60
   mov AX,[BP+0C]
   and AX,000F
   mov [BP+0C],AX
L0abf0c60:
jmp near L0abf0c99
L0abf0c62:
   cmp word ptr [BP+0A],+00
   jl L0abf0c7f
   mov AX,[BP+0A]
   and AX,0007
   add AX,0008
   mov [BP+0A],AX
   mov AX,[BP+0A]
   and AX,0007
   mov [BP-02],AX
jmp near L0abf0c97
L0abf0c7f:
   push [BP+0A]
   call far _abs
   pop CX
   and AX,0007
   add AX,0008
   mov [BP+0A],AX
   mov AX,[BP+0A]
   mov [BP-02],AX
L0abf0c97:
jmp near L0abf0c99
L0abf0c99:
   push [BP+0C]
   push [BP-02]
   push [BP+0A]
   call far _fntcolor
   add SP,+06
   mov AX,[BP+0A]
   les BX,[BP+06]
   mov [ES:BX+0C],AX
   mov AX,[BP+0C]
   les BX,[BP+06]
   mov [ES:BX+0E],AX
   mov AX,[BP+0A]
   mov [offset _curhi],AX
   mov AX,[BP+0C]
   mov [offset _curback],AX
   mov SP,BP
   pop BP
ret far

Segment 0b8b ;; GAMECTRL.C:GAMECTRL
_buttona1: ;; 0b8b000e
   push BP
   mov BP,SP
   mov DX,0201
   in AL,DX
   test AL,10
   jnz L0b8b001e
   mov AX,0001
jmp near L0b8b0020
L0b8b001e:
   xor AX,AX
L0b8b0020:
jmp near L0b8b0022
L0b8b0022:
   pop BP
ret far

_buttona2: ;; 0b8b0024
   push BP
   mov BP,SP
   mov DX,0201
   in AL,DX
   test AL,20
   jnz L0b8b0034
   mov AX,0001
jmp near L0b8b0036
L0b8b0034:
   xor AX,AX
L0b8b0036:
jmp near L0b8b0038
L0b8b0038:
   pop BP
ret far

_readspeed: ;; 0b8b003a
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [offset _systime+2],0000
   mov word ptr [offset _systime+0],0000
   les BX,[offset _myclock]
   mov AL,[ES:BX]
   cbw
   mov [BP-02],AX
L0b8b0057:
   les BX,[offset _myclock]
   mov AL,[ES:BX]
   cbw
   cmp AX,[BP-02]
   jz L0b8b0057
L0b8b0064:
   add word ptr [offset _systime+0],+01
   adc word ptr [offset _systime+2],+00
   les BX,[offset _myclock]
   mov AL,[ES:BX]
   cbw
   sub AX,[BP-02]
   cmp AX,0005
   jl L0b8b0064
   xor DX,DX
   mov AX,0004
   push DX
   push AX
   push [offset _systime+2]
   push [offset _systime+0]
   call far LDIV@
   mov [offset _systime+2],DX
   mov [offset _systime+0],AX
   mov SP,BP
   pop BP
ret far

_readjoy: ;; 0b8b009d
   push BP
   mov BP,SP
   sub SP,+02
   cli
   les BX,[BP+06]
   mov word ptr [ES:BX],0000
   les BX,[BP+0A]
   mov word ptr [ES:BX],0000
   mov word ptr [BP-02],0000
   mov AL,00
   mov DX,0201
   out DX,AL
L0b8b00bf:
   mov DX,0201
   in AL,DX
   mov AH,00
   and AX,0001
   les BX,[BP+06]
   add [ES:BX],AX
   mov DX,0201
   in AL,DX
   mov AH,00
   and AX,0002
   les BX,[BP+0A]
   add [ES:BX],AX
   inc word ptr [BP-02]
   mov DX,0201
   in AL,DX
   test AL,03
   jnz L0b8b00ed
   mov AX,0001
jmp near L0b8b00ef
L0b8b00ed:
   xor AX,AX
L0b8b00ef:
   push AX
   cmp word ptr [BP-02],+00
   jge L0b8b00fb
   mov AX,0001
jmp near L0b8b00fd
L0b8b00fb:
   xor AX,AX
L0b8b00fd:
   pop DX
   or DX,AX
   jz L0b8b00bf
   sti
   les BX,[BP+0A]
   mov AX,[ES:BX]
   mov BX,0002
   cwd
   idiv BX
   les BX,[BP+0A]
   mov [ES:BX],AX
   cmp word ptr [BP-02],+00
   jge L0b8b012b
   les BX,[BP+06]
   mov word ptr [ES:BX],FFFF
   les BX,[BP+0A]
   mov word ptr [ES:BX],FFFF
L0b8b012b:
   mov SP,BP
   pop BP
ret far

_caldir: ;; 0b8b012f
   push BP
   mov BP,SP
   sub SP,+04
   mov word ptr [BP-04],0000
   mov word ptr [BP-02],0000
   push [BP+08]
   push [BP+06]
   call far _cputs
   pop CX
   pop CX
L0b8b014c:
   push [BP+10]
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push CS
   call near offset _readjoy
   add SP,+08
   call far _k_pressed
   or AX,AX
   jz L0b8b0170
   call far _k_read
   mov [BP-02],AX
L0b8b0170:
   cmp word ptr [BP-02],+1B
   jz L0b8b017e
   push CS
   call near offset _buttona1
   or AX,AX
   jz L0b8b014c
L0b8b017e:
   mov AX,0019
   push AX
   call far _delay
   pop CX
   cmp word ptr [BP-02],+1B
   jz L0b8b01b2
   mov word ptr [BP-04],0001
L0b8b0193:
   call far _k_pressed
   or AX,AX
   jz L0b8b01a4
   call far _k_read
   mov [BP-02],AX
L0b8b01a4:
   push CS
   call near offset _buttona1
   or AX,AX
   jz L0b8b01b2
   cmp word ptr [BP-02],+1B
   jnz L0b8b0193
L0b8b01b2:
   mov AX,0019
   push AX
   call far _delay
   pop CX
   push DS
   mov AX,offset Y24dc04d4
   push AX
   call far _cputs
   pop CX
   pop CX
   mov AX,[BP-04]
jmp near L0b8b01cd
L0b8b01cd:
   mov SP,BP
   pop BP
ret far

_joypresent: ;; 0b8b01d1
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
   jle L0b8b0205
   cmp word ptr [BP-02],+00
   jle L0b8b0205
   mov AX,[BP-04]
   mov [offset _joyxsense],AX
   mov AX,[BP-02]
   mov [offset _joyysense],AX
   mov AX,0001
jmp near L0b8b0209
L0b8b0205:
   xor AX,AX
jmp near L0b8b0209
L0b8b0209:
   mov SP,BP
   pop BP
ret far

_calibratejoy: ;; 0b8b020d
   push BP
   mov BP,SP
   sub SP,+02
L0b8b0213:
   mov word ptr [offset _joyflag],0000
   push DS
   mov AX,offset Y24dc04d7
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
   mov AX,offset Y24dc0509
   push AX
   push CS
   call near offset _caldir
   add SP,+0C
   or AX,AX
   jnz L0b8b0242
jmp near L0b8b02f5
L0b8b0242:
   push DS
   mov AX,offset _joyyu
   push AX
   push DS
   mov AX,offset _joyxl
   push AX
   push DS
   mov AX,offset Y24dc052e
   push AX
   push CS
   call near offset _caldir
   add SP,+0C
   or AX,AX
   jnz L0b8b025f
jmp near L0b8b02f5
L0b8b025f:
   push DS
   mov AX,offset _joyyd
   push AX
   push DS
   mov AX,offset _joyxr
   push AX
   push DS
   mov AX,offset Y24dc0566
   push AX
   push CS
   call near offset _caldir
   add SP,+0C
   or AX,AX
   jnz L0b8b027c
jmp near L0b8b02f5
L0b8b027c:
   mov AX,[offset _joyxc]
   sub [offset _joyxl],AX
   mov AX,[offset _joyxc]
   sub [offset _joyxr],AX
   mov AX,[offset _joyyc]
   sub [offset _joyyu],AX
   mov AX,[offset _joyyc]
   sub [offset _joyyd],AX
   cmp word ptr [offset _joyxl],-01
   jge L0b8b02bb
   cmp word ptr [offset _joyxr],+01
   jle L0b8b02bb
   cmp word ptr [offset _joyyu],-01
   jge L0b8b02bb
   cmp word ptr [offset _joyyd],+01
   jle L0b8b02bb
   mov AX,0001
jmp near L0b8b02f9

X0b8b02b9:
jmp near L0b8b02f5
L0b8b02bb:
   push DS
   mov AX,059F
   push AX
   call far _cputs
   pop CX
   pop CX
L0b8b02c7:
   call far _k_pressed
   or AX,AX
   jz L0b8b02c7
   push DS
   mov AX,offset Y24dc05c8
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _k_read
   mov [BP-02],AX
   push [BP-02]
   call far _toupper
   pop CX
   cmp AX,0059
   jnz L0b8b02f5
jmp near L0b8b0213
L0b8b02f5:
   xor AX,AX
jmp near L0b8b02f9
L0b8b02f9:
   mov SP,BP
   pop BP
ret far

_checkctrl: ;; 0b8b02fd
   push BP
   mov BP,SP
   sub SP,+08
   cmp word ptr [offset _macplay],+00
   jz L0b8b0312
   call far _getmac
jmp near L0b8b0586
L0b8b0312:
   mov word ptr [offset _dx1],0000
   mov word ptr [offset _dy1],0000
   mov word ptr [offset _fire1],0000
   mov word ptr [offset _flow1],0000
L0b8b032a:
   mov word ptr [offset _key],0000
   call far _k_pressed
   or AX,AX
   jz L0b8b037d
   call far _k_read
   mov [offset _key],AX
   cmp word ptr [offset _key],+00
   jnz L0b8b034d
   mov AX,0001
jmp near L0b8b034f
L0b8b034d:
   xor AX,AX
L0b8b034f:
   push AX
   cmp word ptr [offset _key],+01
   jnz L0b8b035c
   mov AX,0001
jmp near L0b8b035e
L0b8b035c:
   xor AX,AX
L0b8b035e:
   pop DX
   or DX,AX
   push DX
   cmp word ptr [offset _key],+02
   jnz L0b8b036e
   mov AX,0001
jmp near L0b8b0370
L0b8b036e:
   xor AX,AX
L0b8b0370:
   pop DX
   or DX,AX
   jz L0b8b037d
   call far _k_read
   mov [offset _key],AX
L0b8b037d:
   cmp word ptr [offset _key],+00
   jnz L0b8b0387
jmp near L0b8b041c
L0b8b0387:
   mov AX,[offset _key]
   mov CX,0008
   mov BX,offset Y0b8b03a0
L0b8b0390:
   cmp AX,[CS:BX]
   jz L0b8b039c
   inc BX
   inc BX
   loop L0b8b0390
jmp near L0b8b041c
L0b8b039c:
jmp near [CS:BX+10]

Y0b8b03a0:	dw 0032,0034,0036,0038,00c8,00cb,00cd,00d0
Y0b8b03b0:	dw L0b8b0405,L0b8b03d7,L0b8b03ee,L0b8b03c0,L0b8b03c0,L0b8b03d7,L0b8b03ee,L0b8b0405

L0b8b03c0:
   cmp word ptr [BP+06],+00
   jz L0b8b03c9
jmp near L0b8b032a
L0b8b03c9:
   mov word ptr [offset _dx1],0000
   mov word ptr [offset _dy1],FFFF
jmp near L0b8b041c
L0b8b03d7:
   cmp word ptr [BP+06],+00
   jz L0b8b03e0
jmp near L0b8b032a
L0b8b03e0:
   mov word ptr [offset _dx1],FFFF
   mov word ptr [offset _dy1],0000
jmp near L0b8b041c
L0b8b03ee:
   cmp word ptr [BP+06],+00
   jz L0b8b03f7
jmp near L0b8b032a
L0b8b03f7:
   mov word ptr [offset _dx1],0001
   mov word ptr [offset _dy1],0000
jmp near L0b8b041c
L0b8b0405:
   cmp word ptr [BP+06],+00
   jz L0b8b040e
jmp near L0b8b032a
L0b8b040e:
   mov word ptr [offset _dx1],0000
   mov word ptr [offset _dy1],0001
jmp near L0b8b041c
L0b8b041c:
   call far _k_status
   mov AL,[offset _k_shift]
   cbw
   mov [offset _fire1],AX
   mov AL,[offset _k_alt]
   cbw
   mov [offset _fire2],AX
   cmp word ptr [offset _dx1],+00
   jz L0b8b0439
jmp near L0b8b04e6
L0b8b0439:
   cmp word ptr [offset _dy1],+00
   jz L0b8b0443
jmp near L0b8b04e6
L0b8b0443:
   cmp word ptr [offset _joyflag],+00
   jnz L0b8b044d
jmp near L0b8b04e6
L0b8b044d:
   push SS
   lea AX,[BP-06]
   push AX
   push SS
   lea AX,[BP-08]
   push AX
   push CS
   call near offset _readjoy
   add SP,+08
   mov AX,[BP-08]
   sub AX,[offset _joyxc]
   mov [BP-04],AX
   mov AX,[BP-06]
   sub AX,[offset _joyyc]
   mov [BP-02],AX
   mov AX,[BP-04]
   shl AX,1
   cmp AX,[offset _joyxr]
   jle L0b8b0482
   mov AX,0001
jmp near L0b8b0484
L0b8b0482:
   xor AX,AX
L0b8b0484:
   push AX
   mov AX,[BP-04]
   shl AX,1
   cmp AX,[offset _joyxl]
   jge L0b8b0495
   mov AX,0001
jmp near L0b8b0497
L0b8b0495:
   xor AX,AX
L0b8b0497:
   pop DX
   sub DX,AX
   mov [offset _dx1],DX
   mov AX,[BP-02]
   shl AX,1
   cmp AX,[offset _joyyd]
   jle L0b8b04ae
   mov AX,0001
jmp near L0b8b04b0
L0b8b04ae:
   xor AX,AX
L0b8b04b0:
   push AX
   mov AX,[BP-02]
   shl AX,1
   cmp AX,[offset _joyyu]
   jge L0b8b04c1
   mov AX,0001
jmp near L0b8b04c3
L0b8b04c1:
   xor AX,AX
L0b8b04c3:
   pop DX
   sub DX,AX
   mov [offset _dy1],DX
   push CS
   call near offset _buttona1
   or AX,AX
   jz L0b8b04d8
   mov word ptr [offset _fire1],0001
L0b8b04d8:
   push CS
   call near offset _buttona2
   or AX,AX
   jz L0b8b04e6
   mov word ptr [offset _fire2],0001
L0b8b04e6:
   cmp word ptr [offset _dx1],+00
   jnz L0b8b0542
   cmp word ptr [offset _dy1],+00
   jnz L0b8b0542
   cmp word ptr [BP+06],+00
   jz L0b8b0542
   cmp byte ptr [offset _keydown+0*0100+4B],00
   jnz L0b8b0508
   cmp byte ptr [offset _keydown+1*0100+4B],00
   jz L0b8b050c
L0b8b0508:
   dec word ptr [offset _dx1]
L0b8b050c:
   cmp byte ptr [offset _keydown+0*0100+4D],00
   jnz L0b8b051a
   cmp byte ptr [offset _keydown+1*0100+4D],00
   jz L0b8b051e
L0b8b051a:
   inc word ptr [offset _dx1]
L0b8b051e:
   cmp byte ptr [offset _keydown+0*0100+48],00
   jnz L0b8b052c
   cmp byte ptr [offset _keydown+1*0100+48],00
   jz L0b8b0530
L0b8b052c:
   dec word ptr [offset _dy1]
L0b8b0530:
   cmp byte ptr [offset _keydown+0*0100+50],00
   jnz L0b8b053e
   cmp byte ptr [offset _keydown+1*0100+50],00
   jz L0b8b0542
L0b8b053e:
   inc word ptr [offset _dy1]
L0b8b0542:
   cmp word ptr [offset _fire1],+00
   jz L0b8b0552
   mov AX,[offset _fire1off]
   xor [offset _fire1],AX
jmp near L0b8b0558
L0b8b0552:
   mov word ptr [offset _fire1off],0000
L0b8b0558:
   cmp word ptr [offset _fire2],+00
   jz L0b8b0568
   mov AX,[offset _fire2off]
   xor [offset _fire2],AX
jmp near L0b8b056e
L0b8b0568:
   mov word ptr [offset _fire2off],0000
L0b8b056e:
   mov AX,[offset _dx1]
   mov [offset _dx1old],AX
   mov AX,[offset _dy1]
   mov [offset _dy1old],AX
   cmp word ptr [offset _macrecord],+00
   jz L0b8b0586
   call far _recmac
L0b8b0586:
   mov SP,BP
   pop BP
ret far

_checkctrl0: ;; 0b8b058a
   push BP
   mov BP,SP
L0b8b058d:
   les BX,[offset _myclock]
   mov AL,[ES:BX]
   cbw
   cmp AX,[offset Y24dc04c8]
   jz L0b8b058d
   les BX,[offset _myclock]
   mov AL,[ES:BX]
   cbw
   mov [offset Y24dc04c8],AX
   push [BP+06]
   push CS
   call near offset _checkctrl
   pop CX
   pop BP
ret far

_sensectrlmode: ;; 0b8b05b0 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push CS
   call near offset _joypresent
   mov [offset _joyflag],AX
   pop BP
ret far

_gc_config: ;; 0b8b05bc
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0020
   push CS
   call near offset _joypresent
   or AX,AX
   jz L0b8b062a
   push DS
   mov AX,offset Y24dc05cb
   push AX
   call far _cputs
   pop CX
   pop CX
L0b8b05db:
   call far _k_pressed
   or AX,AX
   jz L0b8b05db
   call far _k_read
   push AX
   call far _toupper
   pop CX
   mov [BP-02],AX
   cmp word ptr [BP-02],+4B
   jz L0b8b0605
   cmp word ptr [BP-02],+4A
   jz L0b8b0605
   cmp word ptr [BP-02],+1B
   jnz L0b8b05db
L0b8b0605:
   push DS
   mov AX,offset Y24dc05f8
   push AX
   call far _cputs
   pop CX
   pop CX
   mov word ptr [offset _joyflag],0000
   mov AX,[BP-02]
   cmp AX,004A
   jz L0b8b0621
jmp near L0b8b062a
L0b8b0621:
   push CS
   call near offset _calibratejoy
   mov [offset _joyflag],AX
jmp near L0b8b062a
L0b8b062a:
   cmp word ptr [BP-02],+1B
   jz L0b8b0635
   mov AX,0001
jmp near L0b8b0637
L0b8b0635:
   xor AX,AX
L0b8b0637:
jmp near L0b8b0639
L0b8b0639:
   mov SP,BP
   pop BP
ret far

_getkey: ;; 0b8b063d
   push BP
   mov BP,SP
L0b8b0640:
   xor AX,AX
   push AX
   push CS
   call near offset _checkctrl
   pop CX
   cmp word ptr [offset _key],+00
   jz L0b8b0640
   pop BP
ret far

_stopmac: ;; 0b8b0651
   push BP
   mov BP,SP
   mov word ptr [offset _macplay],0000
   mov word ptr [offset _macrecord],0000
   mov AX,[offset _macptr]
   or AX,[offset _macptr+02]
   jz L0b8b0684
   push [offset _macptr+02]
   push [offset _macptr]
   call far _free
   pop CX
   pop CX
   mov word ptr [offset _macptr+02],0000
   mov word ptr [offset _macptr],0000
L0b8b0684:
   mov word ptr [offset _macofs],0000
   mov word ptr [offset _mactime],0001
   mov AX,3039
   push AX
   call far _srand
   pop CX
   pop BP
ret far

_playmac: ;; 0b8b069c
   push BP
   mov BP,SP
   sub SP,+02
   push CS
   call near offset _stopmac
   mov word ptr [offset _macaborted],0000
   mov AX,8000
   push AX
   push [BP+08]
   push [BP+06]
   call far __open
   add SP,+06
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jge L0b8b06ca
jmp near L0b8b074b
L0b8b06ca:
   push [BP-02]
   call far _filelength
   pop CX
   mov [offset _maclen],AX
   push [offset _maclen]
   call far _malloc
   pop CX
   mov [offset _macptr+02],DX
   mov [offset _macptr],AX
   mov AX,[offset _macptr]
   or AX,[offset _macptr+02]
   jnz L0b8b06fe
   mov word ptr [offset _macptr+02],0000
   mov word ptr [offset _macptr],0000
jmp near L0b8b0742
L0b8b06fe:
   push [offset _maclen]
   push [offset _macptr+02]
   push [offset _macptr]
   push [BP-02]
   call far __read
   add SP,+08
   or AX,AX
   jl L0b8b0727
   mov word ptr [offset _macplay],0001
   mov word ptr [offset _gamecount],0000
jmp near L0b8b0742
L0b8b0727:
   push [offset _macptr+02]
   push [offset _macptr]
   call far _free
   pop CX
   pop CX
   mov word ptr [offset _macptr+02],0000
   mov word ptr [offset _macptr],0000
L0b8b0742:
   push [BP-02]
   call far __close
   pop CX
L0b8b074b:
   mov SP,BP
   pop BP
ret far

_recordmac: ;; 0b8b074f
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
   mov AX,[offset _macptr]
   or AX,[offset _macptr+02]
   jz L0b8b0794
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
L0b8b0794:
   pop BP
ret far

_macrecend: ;; 0b8b0796
   push BP
   mov BP,SP
   sub SP,+02
   cmp word ptr [offset _macrecord],+00
   jnz L0b8b07a5
jmp near L0b8b07e2
L0b8b07a5:
   xor AX,AX
   push AX
   push DS
   mov AX,offset _macfname
   push AX
   call far __creat
   add SP,+06
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jl L0b8b07de
   push [offset _macofs]
   push [offset _macptr+02]
   push [offset _macptr]
   push [BP-02]
   call far __write
   add SP,+08
   push [BP-02]
   call far __close
   pop CX
L0b8b07de:
   push CS
   call near offset _stopmac
L0b8b07e2:
   mov SP,BP
   pop BP
ret far

_recmac: ;; 0b8b07e6
   push BP
   mov BP,SP
   sub SP,+04
   cmp word ptr [offset _key],+5B
   jnz L0b8b07ff
   mov word ptr [offset _mactime],0000
   mov word ptr [offset _key],0000
L0b8b07ff:
   cmp word ptr [offset _key],+5D
   jnz L0b8b0812
   mov word ptr [offset _mactime],0001
   mov word ptr [offset _key],0000
L0b8b0812:
   cmp word ptr [offset _key],+7D
   jnz L0b8b0820
   push CS
   call near offset _macrecend
jmp near L0b8b09ec
L0b8b0820:
   cmp word ptr [offset _macofs],+00
   jnz L0b8b0845
   mov word ptr [offset Y24dc04ca],0000
   mov word ptr [offset Y24dc04cc],0000
   mov word ptr [offset Y24dc04ce],0000
   mov word ptr [offset Y24dc04d0],0000
   mov AX,[offset _gamecount]
   mov [offset Y24dc04d2],AX
L0b8b0845:
   mov AX,[offset Y24dc04ca]
   cmp AX,[offset _dx1]
   jz L0b8b0853
   mov AX,0001
jmp near L0b8b0855
L0b8b0853:
   xor AX,AX
L0b8b0855:
   push AX
   mov AX,[offset Y24dc04cc]
   cmp AX,[offset _dy1]
   jz L0b8b0864
   mov AX,0001
jmp near L0b8b0866
L0b8b0864:
   xor AX,AX
L0b8b0866:
   shl AL,1
   pop DX
   or DL,AL
   push DX
   mov AX,[offset Y24dc04ce]
   cmp AX,[offset _fire1]
   jz L0b8b087a
   mov AX,0001
jmp near L0b8b087c
L0b8b087a:
   xor AX,AX
L0b8b087c:
   shl AL,1
   shl AL,1
   pop DX
   or DL,AL
   push DX
   mov AX,[offset Y24dc04d0]
   cmp AX,[offset _fire2]
   jz L0b8b0892
   mov AX,0001
jmp near L0b8b0894
L0b8b0892:
   xor AX,AX
L0b8b0894:
   shl AL,1
   shl AL,1
   shl AL,1
   pop DX
   or DL,AL
   push DX
   cmp word ptr [offset _key],+00
   jle L0b8b08b1
   cmp word ptr [offset _key],+7F
   jg L0b8b08b1
   mov AX,0001
jmp near L0b8b08b3
L0b8b08b1:
   xor AX,AX
L0b8b08b3:
   mov CL,04
   shl AL,CL
   pop DX
   or DL,AL
   mov [BP-01],DL
   cmp byte ptr [BP-01],00
   jnz L0b8b08c6
jmp near L0b8b09e0
L0b8b08c6:
   cmp word ptr [offset _macofs],+00
   jz L0b8b0932
   cmp word ptr [offset _mactime],+00
   jnz L0b8b08db
   mov word ptr [BP-04],0001
jmp near L0b8b08e5
L0b8b08db:
   mov AX,[offset _gamecount]
   sub AX,[offset Y24dc04d2]
   mov [BP-04],AX
L0b8b08e5:
   cmp word ptr [BP-04],0080
   jge L0b8b0902
   mov AL,[BP-04]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
jmp near L0b8b0932
L0b8b0902:
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
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b8b0932:
   mov AL,[BP-01]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
   test byte ptr [BP-01],01
   jz L0b8b0960
   mov AL,[offset _dx1]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b8b0960:
   test byte ptr [BP-01],02
   jz L0b8b097a
   mov AL,[offset _dy1]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b8b097a:
   test byte ptr [BP-01],04
   jz L0b8b0994
   mov AL,[offset _fire1]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b8b0994:
   test byte ptr [BP-01],08
   jz L0b8b09ae
   mov AL,[offset _fire2]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b8b09ae:
   test byte ptr [BP-01],10
   jz L0b8b09c8
   mov AL,[offset _key]
   mov DX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [offset _macofs]
L0b8b09c8:
   mov AX,[offset _dx1]
   mov [offset Y24dc04ca],AX
   mov AX,[offset _dy1]
   mov [offset Y24dc04cc],AX
   mov AX,[offset _fire1]
   mov [offset Y24dc04ce],AX
   mov AX,[offset _fire2]
   mov [offset Y24dc04d0],AX
L0b8b09e0:
   cmp word ptr [offset _macofs],7530
   jb L0b8b09ec
   push CS
   call near offset _macrecend
L0b8b09ec:
   mov SP,BP
   pop BP
ret far

_getmac: ;; 0b8b09f0
   push BP
   mov BP,SP
   sub SP,+04
   call far _k_pressed
   or AX,AX
   jz L0b8b0a25
   call far _k_read
   mov [BP-04],AX
   cmp word ptr [offset _macabort],+00
   jz L0b8b0a1b
   cmp word ptr [offset _macabort],+01
   jnz L0b8b0a25
   cmp word ptr [BP-04],+1B
   jnz L0b8b0a25
L0b8b0a1b:
   push CS
   call near offset _stopmac
   mov word ptr [offset _macaborted],0001
L0b8b0a25:
   mov word ptr [offset _key],0000
   cmp word ptr [offset _macofs],+00
   jnz L0b8b0a56
   mov word ptr [offset _dx1],0000
   mov word ptr [offset _dy1],0000
   mov word ptr [offset _fire1],0000
   mov word ptr [offset _fire2],0000
   mov AX,[offset _gamecount]
   mov [offset Y24dc36e2],AX
   mov word ptr [offset Y24dc36e4],0000
L0b8b0a56:
   mov AX,[offset _gamecount]
   sub AX,[offset Y24dc36e2]
   cmp AX,[offset Y24dc36e4]
   jge L0b8b0a66
jmp near L0b8b0b38
L0b8b0a66:
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   mov [BP-01],AL
   inc word ptr [offset _macofs]
   test byte ptr [BP-01],01
   jz L0b8b0a93
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _dx1],AX
   inc word ptr [offset _macofs]
L0b8b0a93:
   test byte ptr [BP-01],02
   jz L0b8b0aad
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _dy1],AX
   inc word ptr [offset _macofs]
L0b8b0aad:
   test byte ptr [BP-01],04
   jz L0b8b0ac7
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _fire1],AX
   inc word ptr [offset _macofs]
L0b8b0ac7:
   test byte ptr [BP-01],08
   jz L0b8b0ae1
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _fire2],AX
   inc word ptr [offset _macofs]
L0b8b0ae1:
   test byte ptr [BP-01],10
   jz L0b8b0afb
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset _key],AX
   inc word ptr [offset _macofs]
L0b8b0afb:
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [offset Y24dc36e4],AX
   inc word ptr [offset _macofs]
   cmp word ptr [offset Y24dc36e4],+00
   jge L0b8b0b38
   mov AX,[offset _macofs]
   les BX,[offset _macptr]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov CL,07
   shl AX,CL
   mov DX,[offset Y24dc36e4]
   and DX,007F
   add AX,DX
   mov [offset Y24dc36e4],AX
   inc word ptr [offset _macofs]
L0b8b0b38:
   mov AX,[offset _macofs]
   cmp AX,[offset _maclen]
   jb L0b8b0b45
   push CS
   call near offset _stopmac
L0b8b0b45:
   mov SP,BP
   pop BP
ret far

_gc_init: ;; 0b8b0b49
   push BP
   mov BP,SP
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
   pop BP
ret far

_gc_exit: ;; 0b8b0ba4
   push BP
   mov BP,SP
   call far _removehandler
   pop BP
ret far

Segment 0c45 ;; UNCRUNCH:UNCRUNCH
_uncrunch: ;; 0c45000e
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
   jcxz L0c45007f
   mov DX,DI
   xor AX,AX
   cld
L0c450029:
   lodsb
   cmp AL,20
   jb L0c450033
   stosw
L0c45002f:
   loop L0c450029
jmp near L0c45007f
L0c450033:
   cmp AL,10
   jnb L0c45003e
   and AH,F0
   or AH,AL
jmp near L0c45002f
L0c45003e:
   cmp AL,18
   jz L0c450055
   jnb L0c45005d
   sub AL,10
   add AL,AL
   add AL,AL
   add AL,AL
   add AL,AL
   and AH,8F
   or AH,AL
jmp near L0c45002f
L0c450055:
   add DX,00A0
   mov DI,DX
jmp near L0c45002f
L0c45005d:
   cmp AL,1B
   jb L0c450068
   jnz L0c45002f
   xor AH,80
jmp near L0c45002f
L0c450068:
   cmp AL,19
   mov BX,CX
   lodsb
   mov CL,AL
   mov AL,20
   jz L0c450075
   lodsb
   dec BX
L0c450075:
   xor CH,CH
   inc CX
   repz stosw
   mov CX,BX
   dec CX
   loopnz L0c450029
L0c45007f:
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

Segment 0c4d ;; CONFIG.C:CONFIG
_cfg_getpath: ;; 0c4d0009
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0000
jmp near L0c4d0082
L0c4d0016:
   mov AX,[BP-02]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strupr
   pop CX
   pop CX
   mov AX,[BP-02]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   les BX,[ES:BX]
   cmp byte ptr [ES:BX],2F
   jnz L0c4d007f
   mov AX,[BP-02]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   les BX,[ES:BX]
   cmp byte ptr [ES:BX+01],50
   jnz L0c4d007f
   mov AX,[BP-02]
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
L0c4d007f:
   inc word ptr [BP-02]
L0c4d0082:
   mov AX,[BP-02]
   cmp AX,[BP+06]
   jl L0c4d0016
   mov SP,BP
   pop BP
ret far

_cfg_init: ;; 0c4d008e
   push BP
   mov BP,SP
   sub SP,+12
   call far _clrscr
   push DS
   mov AX,offset Y24dc0640
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0661
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc068c
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
   mov AX,offset Y24dc0690
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc06b2
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
   mov AX,offset Y24dc06b6
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc06d7
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
   mov AX,offset Y24dc06db
   push AX
   call far _cputs
   pop CX
   pop CX
   mov word ptr [offset _ct_io_addx],0000
   mov word ptr [offset _ct_int_num+2*00],0000
   call far _readspeed
   mov word ptr [BP-12],0000
jmp near L0c4d026b
L0c4d0136:
   mov AX,[BP-12]
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
   mov AX,offset Y24dc06f9
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L0c4d01a1
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   push [offset _systime+2]
   push [offset _systime+0]
   call far _ltoa
   add SP,+0A
   push SS
   lea AX,[BP-10]
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _getkey
jmp near L0c4d0268
L0c4d01a1:
   push DS
   mov AX,offset Y24dc06ff
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L0c4d01d4
   mov word ptr [offset _vocflag],0000
   mov word ptr [offset _musicflag],0000
jmp near L0c4d0268
L0c4d01d4:
   push DS
   mov AX,offset Y24dc0705
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L0c4d0206
   mov word ptr [offset _ct_io_addx],0220
   mov word ptr [offset _ct_int_num+2*00],0003
jmp near L0c4d0268
L0c4d0206:
   push DS
   mov AX,offset Y24dc0709
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L0c4d023e
   mov word ptr [offset _vocflag],0000
   mov word ptr [offset _musicflag],0000
   mov word ptr [offset _nosnd],0001
jmp near L0c4d0268
L0c4d023e:
   push DS
   mov AX,offset Y24dc0710
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L0c4d0268
   mov word ptr [offset _cfgdemo],0001
L0c4d0268:
   inc word ptr [BP-12]
L0c4d026b:
   mov AX,[BP-12]
   cmp AX,[BP+06]
   jge L0c4d0276
jmp near L0c4d0136
L0c4d0276:
   mov SP,BP
   pop BP
ret far

_doconfig: ;; 0c4d027a
   push BP
   mov BP,SP
   sub SP,+12
   mov AX,[offset _cf+2*00]
   mov [BP-12],AX
   cmp word ptr [BP-12],+00
   jz L0c4d028f
jmp near L0c4d0312
L0c4d028f:
   mov AL,[offset _cf+2*08]
   mov [offset _x_ourmode],AL
   call far _joypresent
   mov [offset _joyflag],AX
   cmp word ptr [offset _joyflag],+00
   jnz L0c4d02ac
   mov word ptr [offset _cf+2*01],0000
jmp near L0c4d02f8
L0c4d02ac:
   cmp word ptr [offset _cf+2*01],+00
   jz L0c4d02f8
   mov AX,[offset _cf+2*02]
   mov [offset _joyxl],AX
   mov AX,[offset _cf+2*03]
   mov [offset _joyxc],AX
   mov AX,[offset _cf+2*04]
   mov [offset _joyxr],AX
   mov AX,[offset _cf+2*05]
   mov [offset _joyyu],AX
   mov AX,[offset _cf+2*06]
   mov [offset _joyyc],AX
   mov AX,[offset _cf+2*07]
   mov [offset _joyyd],AX
   xor AX,AX
   push AX
   call far _checkctrl
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L0c4d02ee
   cmp word ptr [offset _dy1],+00
   jz L0c4d02f3
L0c4d02ee:
   mov AX,0001
jmp near L0c4d02f5
L0c4d02f3:
   xor AX,AX
L0c4d02f5:
   or [BP-12],AX
L0c4d02f8:
   cmp word ptr [offset _musicflag],+00
   jnz L0c4d0305
   mov word ptr [offset _cf+2*09],0000
L0c4d0305:
   cmp word ptr [offset _vocflag],+00
   jnz L0c4d0312
   mov word ptr [offset _cf+2*0a],0000
L0c4d0312:
   cmp word ptr [BP-12],+00
   jz L0c4d031b
jmp near L0c4d0440
L0c4d031b:
   call far _clrscr
   push DS
   mov AX,offset Y24dc0716
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0719
   push AX
   call far _cputs
   pop CX
   pop CX
   cmp word ptr [offset _cf+2*0a],+00
   jz L0c4d034d
   push DS
   mov AX,offset Y24dc0730
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0c4d0359
L0c4d034d:
   push DS
   mov AX,offset Y24dc075d
   push AX
   call far _cputs
   pop CX
   pop CX
L0c4d0359:
   cmp word ptr [offset _cf+2*09],+00
   jz L0c4d036e
   push DS
   mov AX,offset Y24dc077e
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0c4d037a
L0c4d036e:
   push DS
   mov AX,offset Y24dc07a9
   push AX
   call far _cputs
   pop CX
   pop CX
L0c4d037a:
   cmp word ptr [offset _cf+2*01],+00
   jz L0c4d038f
   push DS
   mov AX,offset Y24dc07c6
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0c4d039b
L0c4d038f:
   push DS
   mov AX,offset Y24dc07d7
   push AX
   call far _cputs
   pop CX
   pop CX
L0c4d039b:
   cmp byte ptr [offset _x_ourmode],00
   jnz L0c4d03bc
   push DS
   mov AX,offset Y24dc07e9
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0811
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0c4d03dd
L0c4d03bc:
   cmp byte ptr [offset _x_ourmode],02
   jnz L0c4d03d1
   push DS
   mov AX,offset Y24dc0833
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L0c4d03dd
L0c4d03d1:
   push DS
   mov AX,offset Y24dc084f
   push AX
   call far _cputs
   pop CX
   pop CX
L0c4d03dd:
   push DS
   mov AX,offset Y24dc086c
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc086f
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0892
   push AX
   call far _cputs
   pop CX
   pop CX
L0c4d0401:
   call far _getkey
   push [offset _key]
   call far _toupper
   pop CX
   mov [offset _key],AX
   cmp word ptr [offset _key],+0D
   jz L0c4d0428
   cmp word ptr [offset _key],+43
   jz L0c4d0428
   cmp word ptr [offset _key],+1B
   jnz L0c4d0401
L0c4d0428:
   cmp word ptr [offset _key],+43
   jnz L0c4d0434
   mov word ptr [BP-12],0001
L0c4d0434:
   cmp word ptr [offset _key],+1B
   jnz L0c4d0440
   xor AX,AX
jmp near L0c4d072c
L0c4d0440:
   cmp word ptr [BP-12],+00
   jnz L0c4d0449
jmp near L0c4d06c6
L0c4d0449:
   call far _clrscr
   cmp word ptr [offset _vocflag],+00
   jnz L0c4d0491
   cmp word ptr [offset _musicflag],+00
   jnz L0c4d0491
   push DS
   mov AX,offset Y24dc08b4
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc08b7
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc08ea
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc08f9
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _getkey
L0c4d0491:
   cmp word ptr [offset _vocflag],+00
   jz L0c4d04ed
   cmp word ptr [offset _systime+2],+00
   jg L0c4d04ed
   jl L0c4d04a9
   cmp word ptr [offset _systime+0],0FA0
   jnb L0c4d04ed
L0c4d04a9:
   push DS
   mov AX,offset Y24dc0917
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc091c
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0952
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0989
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc099a
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _getkey
jmp near L0c4d05b3
L0c4d04ed:
   cmp word ptr [offset _vocflag],+00
   jnz L0c4d04f7
jmp near L0c4d05b3
L0c4d04f7:
   push DS
   mov AX,offset Y24dc09b8
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc09e5
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0a17
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0a44
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0a78
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0aaa
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0adb
   push AX
   call far _cputs
   pop CX
   pop CX
L0c4d054b:
   call far _getkey
   push [offset _key]
   call far _toupper
   pop CX
   mov [offset _key],AX
   cmp word ptr [offset _key],+7E
   jnz L0c4d0588
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
L0c4d0588:
   cmp word ptr [offset _key],+1B
   jnz L0c4d0594
   xor AX,AX
jmp near L0c4d072c
L0c4d0594:
   cmp word ptr [offset _key],+59
   jz L0c4d05a2
   cmp word ptr [offset _key],+4E
   jnz L0c4d054b
L0c4d05a2:
   cmp word ptr [offset _key],+59
   jnz L0c4d05ae
   mov AX,0001
jmp near L0c4d05b0
L0c4d05ae:
   xor AX,AX
L0c4d05b0:
   mov [offset _cf+2*0a],AX
L0c4d05b3:
   cmp word ptr [offset _musicflag],+00
   jnz L0c4d05bd
jmp near L0c4d062f
L0c4d05bd:
   call far _clrscr
   push DS
   mov AX,offset Y24dc0af8
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0aff
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0b30
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0b4c
   push AX
   call far _cputs
   pop CX
   pop CX
L0c4d05f2:
   call far _getkey
   push [offset _key]
   call far _toupper
   pop CX
   mov [offset _key],AX
   cmp word ptr [offset _key],+1B
   jnz L0c4d0610
   xor AX,AX
jmp near L0c4d072c
L0c4d0610:
   cmp word ptr [offset _key],+59
   jz L0c4d061e
   cmp word ptr [offset _key],+4E
   jnz L0c4d05f2
L0c4d061e:
   cmp word ptr [offset _key],+59
   jnz L0c4d062a
   mov AX,0001
jmp near L0c4d062c
L0c4d062a:
   xor AX,AX
L0c4d062c:
   mov [offset _cf+2*09],AX
L0c4d062f:
   call far _clrscr
   push DS
   mov AX,offset Y24dc0b73
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _gc_config
   or AX,AX
   jnz L0c4d064e
   xor AX,AX
jmp near L0c4d072c
L0c4d064e:
   mov AX,[offset _joyflag]
   mov [offset _cf+2*01],AX
   call far _clrscr
   push DS
   mov AX,offset Y24dc0b76
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0b79
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0ba0
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0bbc
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0bd9
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0bf7
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0bfa
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc0c28
   push AX
   call far _cputs
   pop CX
   pop CX
   call far _gr_config
   or AX,AX
   jnz L0c4d06c6
   xor AX,AX
jmp near L0c4d072c
L0c4d06c6:
   cmp word ptr [offset _systime+2],+00
   jg L0c4d06e3
   jl L0c4d06d7
   cmp word ptr [offset _systime+0],0FA0
   jnb L0c4d06e3
L0c4d06d7:
   mov word ptr [offset _vocflag],0000
   mov word ptr [offset _cf+2*0a],0000
L0c4d06e3:
   mov word ptr [offset _cf+2*00],0000
   mov AX,[offset _cf+2*01]
   mov [offset _joyflag],AX
   mov AX,[offset _joyxl]
   mov [offset _cf+2*02],AX
   mov AX,[offset _joyxc]
   mov [offset _cf+2*03],AX
   mov AX,[offset _joyxr]
   mov [offset _cf+2*04],AX
   mov AX,[offset _joyyu]
   mov [offset _cf+2*05],AX
   mov AX,[offset _joyyc]
   mov [offset _cf+2*06],AX
   mov AX,[offset _joyyd]
   mov [offset _cf+2*07],AX
   mov AL,[offset _x_ourmode]
   mov AH,00
   mov [offset _cf+2*08],AX
   mov AX,[offset _cf+2*0a]
   mov [offset _vocflag],AX
   mov AX,[offset _cf+2*09]
   mov [offset _musicflag],AX
   mov AX,0001
jmp near L0c4d072c
L0c4d072c:
   mov SP,BP
   pop BP
ret far

Segment 0cc0 ;; PIXWRITE.C:PIXWRITE (depends on GRASM?)
_pixwrite: ;; 0cc00000 ;; 24:18
;; Parameters: [BP+06] as n, [BP+06] as x, [BP+07] as h
;; Auto: [BP-10] as a2, [BP-20] as a1, [BP-40] as a, [BP-60] as f, [BP-70] as ns, [BP-72] as y, [BP-74] as oldpagedraw
;; Types: ptrdiff_t: 06, size_t: 0a, p_rec: 20
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
   mov AX,offset Y24dc0c4c
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
   mov AX,offset Y24dc0c54
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
   jz L0cc000bb
   mov AX,[offset _pagedraw]
   mov [BP-74],AX
   mov AX,[offset _pageshow]
   mov [offset _pagedraw],AX
   mov word ptr [BP-72],0000
jmp near L0cc000a7
L0cc0007c:
   xor SI,SI
jmp near L0cc0009e
L0cc00080:
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
L0cc0009e:
   cmp SI,0140
   jl L0cc00080
   inc word ptr [BP-72]
L0cc000a7:
   cmp word ptr [BP-72],00C8
   jl L0cc0007c
   mov AX,[BP-74]
   mov [offset _pagedraw],AX
   push DI
   call far __close
   pop CX
L0cc000bb:
   push DS
   mov AX,offset Y24dc0c59
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
   mov AX,offset Y24dc0c61
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
   jnz L0cc0010b
jmp near L0cc00205
L0cc0010b:
   xor SI,SI
jmp near L0cc001f5
L0cc00110:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,SI
   mov DX,0003
   mul DX
   mov BX,AX
   mov AL,[BX+offset _vgapal+0]
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
   mov AL,[BX+offset _vgapal+1]
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
   mov AL,[BX+offset _vgapal+2]
   mov AH,00
   shl AX,1
   shl AX,1
   push AX
   call far _itoa
   add SP,+08
   push DS
   mov AX,offset Y24dc0c66
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
   mov AX,offset Y24dc0c68
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
   mov AX,offset Y24dc0c6a
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
L0cc001f5:
   cmp SI,0100
   jge L0cc001fe
jmp near L0cc00110
L0cc001fe:
   push DI
   call far __close
   pop CX
L0cc00205:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 0ce0 ;; S.C:S, :::SOUNDS
_bogus_intr: ;; 0ce0000b ;; (@) Unaccessed.
   push AX
   push BX
   push CX
   push DX
   push ES
   push DS
   push SI
   push DI
   push BP
   mov BP,segment A24dc0000
   mov DS,BP
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

_snd_init: ;; 0ce00023
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [offset _textmsg+2],0000
   mov word ptr [offset _textmsg+0],0000
   mov word ptr [BP-02],0000
jmp near L0ce0007b
L0ce0003c:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _vocposn+2],FFFF
   mov word ptr [BX+offset _vocposn+0],FFFF
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+offset _voclen],0000
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+offset _vocrate],0000
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _vocptr+2],0000
   mov word ptr [BX+offset _vocptr+0],0000
   inc word ptr [BP-02]
L0ce0007b:
   cmp word ptr [BP-02],+32
   jl L0ce0003c
   mov word ptr [BP-02],0000
jmp near L0ce0009e
L0ce00088:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _soundmac+2],0000
   mov word ptr [BX+offset _soundmac+0],0000
   inc word ptr [BP-02]
L0ce0009e:
   cmp word ptr [BP-02],0080
   jl L0ce00088
   cmp word ptr [offset _vocflag],+00
   jnz L0ce000af
jmp near L0ce00145
L0ce000af:
   cmp word ptr [offset _musicflag],+00
   jnz L0ce000b9
jmp near L0ce00145
L0ce000b9:
   cmp word ptr [offset _ct_io_addx],+00
   jz L0ce00106
   cmp word ptr [offset _ct_int_num+2*00],+00
   jz L0ce00106
   call far _sbc_scan_card
   mov [BP-02],AX
   test word ptr [BP-02],0006
   jz L0ce00106
   mov word ptr [offset _vocflag],0001
   mov word ptr [offset _musicflag],0001
   test word ptr [BP-02],0002
   jz L0ce000ee
   mov AX,0001
jmp near L0ce000f0
L0ce000ee:
   xor AX,AX
L0ce000f0:
   mov [offset _musicflag],AX
   test word ptr [BP-02],0004
   jz L0ce000ff
   mov AX,0001
jmp near L0ce00101
L0ce000ff:
   xor AX,AX
L0ce00101:
   mov [offset _vocflag],AX
jmp near L0ce00145
L0ce00106:
   mov word ptr [offset _vocflag],0000
   mov word ptr [offset _musicflag],0000
   call far _sbc_scan_card
   mov [BP-02],AX
   test word ptr [BP-02],0003
   jz L0ce00145
   test word ptr [BP-02],0002
   jz L0ce0012d
   mov AX,0001
jmp near L0ce0012f
L0ce0012d:
   xor AX,AX
L0ce0012f:
   mov [offset _musicflag],AX
   test word ptr [BP-02],0004
   jz L0ce0013e
   mov AX,0001
jmp near L0ce00140
L0ce0013e:
   xor AX,AX
L0ce00140:
   mov [offset _vocflag],AX
jmp near L0ce00145
L0ce00145:
   les BX,[BP+06]
   cmp byte ptr [ES:BX],00
   jnz L0ce00157
   mov word ptr [offset _vocflag],0000
jmp near L0ce001e4
L0ce00157:
   mov AX,8001
   push AX
   push [BP+08]
   push [BP+06]
   call far __open
   add SP,+06
   mov [offset _vocfilehandle],AX
   cmp word ptr [offset _vocfilehandle],-01
   jnz L0ce0017b
   mov word ptr [offset _vocflag],0000
jmp near L0ce001e4
L0ce0017b:
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
L0ce001e4:
   mov SP,BP
   pop BP
ret far

_snd_play: ;; 0ce001e8
   push BP
   mov BP,SP
   cmp word ptr [offset _vocflag],+00
   jz L0ce0025c
   mov BX,[BP+08]
   cmp byte ptr [BX+offset _mirrortab],00
   jz L0ce00207
   mov BX,[BP+08]
   mov AL,[BX+offset _mirrortab]
   cbw
   mov [BP+08],AX
L0ce00207:
   cmp word ptr [offset _xvoclen],+00
   jz L0ce00217
   mov AX,[BP+06]
   cmp AX,[offset _vocpri]
   jl L0ce0025a
L0ce00217:
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _vocptr+0]
   or AX,[BX+offset _vocptr+2]
   jz L0ce0025a
   cmp word ptr [BP+08],+32
   jge L0ce0025a
   cmp word ptr [offset _soundf],+00
   jz L0ce0025a
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   les BX,[BX+offset _vocptr+0]
   mov [offset _xvocptr+2],ES
   mov [offset _xvocptr+0],BX
   mov BX,[BP+08]
   shl BX,1
   mov AX,[BX+offset _voclen]
   mov [offset _xvoclen],AX
   mov AX,[BP+06]
   mov [offset _vocpri],AX
L0ce0025a:
jmp near L0ce0029f
L0ce0025c:
   cmp word ptr [BP+08],0080
   jge L0ce0029f
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _soundmac+0]
   or AX,[BX+offset _soundmac+2]
   jz L0ce0029f
   mov AX,[offset _freq]
   or AX,[offset _freq+02]
   jz L0ce0029f
   mov AX,[offset _dur]
   or AX,[offset _dur+02]
   jz L0ce0029f
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   push [BX+offset _soundmac+2]
   push [BX+offset _soundmac+0]
   push [BP+06]
   call far _soundadd
   mov SP,BP
L0ce0029f:
   pop BP
ret far

_snd_do: ;; 0ce002a1
   push BP
   mov BP,SP
   sub SP,+04
   call far _nosound
   mov AX,0008
   push AX
   call far _getvect
   pop CX
   mov [offset _timer8int+02],DX
   mov [offset _timer8int],AX
   mov [offset _bogus8int+2],CS
   mov word ptr [offset _bogus8int+0],000B
   mov [offset _music8int+2],CS
   mov word ptr [offset _music8int+0],000B
   cmp word ptr [offset _nosnd],+00
   jz L0ce002e0
   mov word ptr [offset _xclockrate],0000
jmp near L0ce0030b
L0ce002e0:
   cmp word ptr [offset _vocflag],+00
   jz L0ce002ff
   mov DX,[offset _ct_io_addx]
   add DX,+0C
   mov AL,D1
   out DX,AL
   mov word ptr [offset _xclockrate],014D
   mov word ptr [offset _countmax],0010
jmp near L0ce0030b
L0ce002ff:
   mov word ptr [offset _xclockrate],0040
   mov word ptr [offset _countmax],0004
L0ce0030b:
   cmp word ptr [offset _musicflag],+00
   jz L0ce0035c
   push [offset _bogus8int+2]
   push [offset _bogus8int+0]
   mov AX,0008
   push AX
   call far _setvect
   add SP,+06
   call far _sbfm_init
   or AX,AX
   jnz L0ce00337
   mov word ptr [offset _musicflag],0000
jmp near L0ce00348
L0ce00337:
   mov AX,0008
   push AX
   call far _getvect
   pop CX
   mov [offset _music8int+2],DX
   mov [offset _music8int+0],AX
L0ce00348:
   push [offset _timer8int+02]
   push [offset _timer8int]
   mov AX,0008
   push AX
   call far _setvect
   add SP,+06
L0ce0035c:
   cmp word ptr [offset _vocflag],+00
   jnz L0ce00366
jmp near L0ce00415
L0ce00366:
   mov word ptr [BP-02],0000
jmp near L0ce00409
L0ce0036e:
   mov BX,[BP-02]
   shl BX,1
   cmp word ptr [BX+offset _voclen],+00
   jnz L0ce0037d
jmp near L0ce00406
L0ce0037d:
   mov BX,[BP-02]
   shl BX,1
   push [BX+offset _voclen]
   call far _malloc
   pop CX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov [BX+offset _vocptr+2],DX
   mov [BX+offset _vocptr+0],AX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _vocptr+0]
   or AX,[BX+offset _vocptr+2]
   jz L0ce00406
   xor AX,AX
   push AX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+offset _vocposn+2]
   push [BX+offset _vocposn+0]
   push [offset _vocfilehandle]
   call far _lseek
   add SP,+08
   mov BX,[BP-02]
   shl BX,1
   push [BX+offset _voclen]
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+offset _vocptr+2]
   push [BX+offset _vocptr+0]
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
   cmp AX,FFFF
   jnz L0ce00406
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _vocptr+2],0000
   mov word ptr [BX+offset _vocptr+0],0000
L0ce00406:
   inc word ptr [BP-02]
L0ce00409:
   cmp word ptr [BP-02],+32
   jge L0ce00412
jmp near L0ce0036e
L0ce00412:
jmp near L0ce004d8
L0ce00415:
   mov AX,4080
   push AX
   call far _malloc
   pop CX
   mov [offset _freq+02],DX
   mov [offset _freq],AX
   mov AX,4080
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
   mov word ptr [BP-02],0000
jmp near L0ce004ce
L0ce00454:
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
   cmp word ptr [BP-04],+00
   jz L0ce004b8
   push [BP-04]
   call far _malloc
   pop CX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov [BX+offset _soundmac+2],DX
   mov [BX+offset _soundmac+0],AX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _soundmac+0]
   or AX,[BX+offset _soundmac+2]
   jz L0ce004b6
   push [BP-04]
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+offset _soundmac+2]
   push [BX+offset _soundmac+0]
   push [offset _vocfilehandle]
   call far _read
   add SP,+08
L0ce004b6:
jmp near L0ce004cb
L0ce004b8:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+offset _soundmac+2],0000
   mov word ptr [BX+offset _soundmac+0],0000
L0ce004cb:
   inc word ptr [BP-02]
L0ce004ce:
   cmp word ptr [BP-02],0080
   jge L0ce004d8
jmp near L0ce00454
L0ce004d8:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   cwd
   mov DX,AX
   xor AX,AX
   mov [offset _longclock+02],DX
   mov [offset _longclock],AX
   cmp word ptr [offset _xclockrate],+00
   jnz L0ce00507
   mov word ptr [offset _sampf],0000
   mov word ptr [offset _xclockrate],0001
   mov word ptr [offset _soundoff],0001
jmp near L0ce00586
L0ce00507:
   cmp word ptr [offset _xclockrate],+01
   jbe L0ce00586
   mov AX,[offset _xclockrate]
   xor DX,DX
   push DX
   push AX
   mov DX,0001
   xor AX,AX
   push DX
   push AX
   call far LDIV@
   mov [offset _xclockval],AX
   mov AX,[offset _xclockrate]
   xor DX,DX
   push DX
   push AX
   mov DX,0001
   xor AX,AX
   push DX
   push AX
   call far LDIV@
   push DX
   push AX
   mov AX,[offset _countmax]
   cwd
   pop BX
   pop CX
   call far LXMUL@
   mov [offset _xtickrate],AX
   mov word ptr [offset _digi8int+2],segment _digi_intr
   mov word ptr [offset _digi8int+0],offset _digi_intr
   push [offset _digi8int+2]
   push [offset _digi8int+0]
   mov AX,0008
   push AX
   call far _setvect
   add SP,+06
   mov word ptr [offset _soundoff],0000
   mov word ptr [offset _sampf],0001
   push [offset _xclockval]
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   call far _timerset
   add SP,+06
L0ce00586:
   mov SP,BP
   pop BP
ret far

_text_get: ;; 0ce0058a
   push BP
   mov BP,SP
   mov word ptr [offset _textmsg+2],0000
   mov word ptr [offset _textmsg+0],0000
   mov BX,[BP+06]
   shl BX,1
   cmp word ptr [BX+offset _textlen],+00
   jz L0ce00610
   mov BX,[BP+06]
   shl BX,1
   mov AX,[BX+offset _textlen]
   mov [offset _textmsglen],AX
   push [offset _textmsglen]
   call far _malloc
   pop CX
   mov [offset _textmsg+2],DX
   mov [offset _textmsg+0],AX
   mov AX,[offset _textmsg+0]
   or AX,[offset _textmsg+2]
   jz L0ce00610
   xor AX,AX
   push AX
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   push [BX+offset _textposn+2]
   push [BX+offset _textposn+0]
   push [offset _vocfilehandle]
   call far _lseek
   mov SP,BP
   push [offset _textmsglen]
   push [offset _textmsg+2]
   push [offset _textmsg+0]
   push [offset _vocfilehandle]
   call far _read
   mov SP,BP
   cmp AX,FFFF
   jnz L0ce00610
   mov word ptr [offset _textmsg+2],0000
   mov word ptr [offset _textmsg+0],0000
L0ce00610:
   pop BP
ret far

_snd_exit: ;; 0ce00612
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
   jz L0ce00647
   push [offset _freq+02]
   push [offset _freq]
   call far _free
   pop CX
   pop CX
L0ce00647:
   mov AX,[offset _dur]
   or AX,[offset _dur+02]
   jz L0ce0065f
   push [offset _dur+02]
   push [offset _dur]
   call far _free
   pop CX
   pop CX
L0ce0065f:
   mov word ptr [BP-02],0000
jmp near L0ce00690
L0ce00666:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _vocptr+0]
   or AX,[BX+offset _vocptr+2]
   jz L0ce0068d
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+offset _vocptr+2]
   push [BX+offset _vocptr+0]
   call far _free
   pop CX
   pop CX
L0ce0068d:
   inc word ptr [BP-02]
L0ce00690:
   cmp word ptr [BP-02],+32
   jl L0ce00666
   mov word ptr [BP-02],0000
jmp near L0ce006c7
L0ce0069d:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+offset _soundmac+0]
   or AX,[BX+offset _soundmac+2]
   jz L0ce006c4
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+offset _soundmac+2]
   push [BX+offset _soundmac+0]
   call far _free
   pop CX
   pop CX
L0ce006c4:
   inc word ptr [BP-02]
L0ce006c7:
   cmp word ptr [BP-02],0080
   jl L0ce0069d
   cmp word ptr [offset _vocfilehandle],+00
   jl L0ce006df
   push [offset _vocfilehandle]
   call far _close
   pop CX
L0ce006df:
   cmp word ptr [offset _musicflag],+00
   jz L0ce006eb
   call far _sbfm_terminate
L0ce006eb:
   mov AX,[offset _timer8int]
   or AX,[offset _timer8int+02]
   jz L0ce00708
   push [offset _timer8int+02]
   push [offset _timer8int]
   mov AX,0008
   push AX
   call far _setvect
   add SP,+06
L0ce00708:
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   call far _timerset
   add SP,+06
   mov SP,BP
   pop BP
ret far

_load_file: ;; 0ce0071e
   push BP
   mov BP,SP
   sub SP,+0C
   mov word ptr [BP-06],0000
   mov AX,[offset _music_buffer]
   or AX,[offset _music_buffer+02]
   jz L0ce0074d
   push [offset _music_buffer+02]
   push [offset _music_buffer]
   call far _free
   pop CX
   pop CX
   mov word ptr [offset _music_buffer+02],0000
   mov word ptr [offset _music_buffer],0000
L0ce0074d:
   push SS
   lea AX,[BP-08]
   push AX
   mov AX,0001
   push AX
   push [BP+08]
   push [BP+06]
   call far _open
   add SP,+0A
   mov [BP-08],AX
   cmp word ptr [BP-08],+00
   jl L0ce007ca
   push [BP-08]
   call far _filelength
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   push [BP-04]
   call far _malloc
   pop CX
   mov [BP-0A],DX
   mov [BP-0C],AX
   mov AX,[BP-0C]
   or AX,[BP-0A]
   jz L0ce007c1
   les BX,[BP-0C]
   mov [offset _music_buffer+02],ES
   mov [offset _music_buffer],BX
   mov word ptr [BP-06],0001
   mov AX,8000
   push AX
   push [BP-0A]
   push [BP-0C]
   push [BP-08]
   call far __read
   add SP,+08
   or AX,AX
   jg L0ce007c1
   mov word ptr [BP-06],0000
L0ce007c1:
   push [BP-08]
   call far __close
   pop CX
L0ce007ca:
   mov AX,[BP-06]
jmp near L0ce007cf
L0ce007cf:
   mov SP,BP
   pop BP
ret far

_playbuffer: ;; 0ce007d3
   push BP
   mov BP,SP
   sub SP,+0A
   les BX,[offset _music_buffer]
   mov AX,[ES:BX+06]
   les BX,[offset _music_buffer]
   add BX,AX
   mov [BP-06],ES
   mov [BP-08],BX
   les BX,[offset _music_buffer]
   mov AX,[ES:BX+08]
   les BX,[offset _music_buffer]
   add BX,AX
   mov [BP-02],ES
   mov [BP-04],BX
   call far _sbfm_reset
   les BX,[offset _music_buffer]
   mov AX,[ES:BX+0C]
   cwd
   push DX
   push AX
   mov DX,0012
   mov AX,34DC
   push DX
   push AX
   call far LDIV@
   mov [BP-0A],AX
   cmp word ptr [offset _vocflag],+00
   jz L0ce00830
   mov AX,[BP-0A]
   mov [offset _musicval],AX
jmp near L0ce00842
L0ce00830:
   mov AX,[BP-0A]
   mov BX,0004
   cwd
   idiv BX
   mov DX,[BP-0A]
   sub DX,AX
   mov [offset _musicval],DX
L0ce00842:
   mov word ptr [offset _musiccount],0000
   cmp word ptr [BP-08],+00
   jz L0ce00865
   les BX,[offset _music_buffer]
   mov AL,[ES:BX+24]
   push AX
   push [BP-06]
   push [BP-08]
   call far _sbfm_instrument
   add SP,+06
L0ce00865:
   push [BP-02]
   push [BP-04]
   call far _sbfm_play_music
   pop CX
   pop CX
   sti
   push [offset _xclockval]
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   call far _timerset
   add SP,+06
   mov SP,BP
   pop BP
ret far

_sb_update: ;; 0ce0088a
   cmp word ptr [offset _musicflag],+00
   jnz L0ce00893
jmp near L0ce008a7
L0ce00893:
   cmp word ptr [offset _ct_music_status],+00
   jnz L0ce008a7
   mov AX,[offset _music_buffer]
   or AX,[offset _music_buffer+02]
   jz L0ce008a7
   push CS
   call near offset _playbuffer
L0ce008a7:
ret far

_sb_playing: ;; 0ce008a8
   cmp word ptr [offset _musicflag],+00
   jnz L0ce008b4
   mov AX,0001
jmp near L0ce008c4
L0ce008b4:
   cmp word ptr [offset _ct_music_status],+00
   jz L0ce008c0
   mov AX,0001
jmp near L0ce008c2
L0ce008c0:
   xor AX,AX
L0ce008c2:
jmp near L0ce008c4
L0ce008c4:
ret far

_sb_shutup: ;; 0ce008c5 ;; (@) Unaccessed.
   cmp word ptr [offset _musicflag],+00
   jz L0ce008dd
   call far _sbfm_stop_music
   mov word ptr [offset _music_buffer+02],0000
   mov word ptr [offset _music_buffer],0000
L0ce008dd:
ret far

_sb_playtune: ;; 0ce008de
   push BP
   mov BP,SP
   cmp word ptr [offset _musicflag],+00
   jnz L0ce008ea
jmp near L0ce008fe
L0ce008ea:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _load_file
   mov SP,BP
   or AX,AX
   jz L0ce008fe
   push CS
   call near offset _playbuffer
L0ce008fe:
   pop BP
ret far

_sampadd: ;; 0ce00900
   push BP
   mov BP,SP
   sub SP,+0E
   cmp word ptr [offset _soundoff],+00
   jz L0ce00910
jmp near L0ce00a01
L0ce00910:
   cmp word ptr [offset _makesound],+00
   jz L0ce00930
   mov AX,[BP+06]
   cmp AX,[offset _samppriority]
   jl L0ce00927
   cmp word ptr [offset _samppriority],-01
   jnz L0ce00930
L0ce00927:
   cmp word ptr [BP+06],-01
   jz L0ce00930
jmp near L0ce00a01
L0ce00930:
   cmp word ptr [BP+06],+00
   jge L0ce0093d
   cmp word ptr [offset _makesound],+00
   jnz L0ce00955
L0ce0093d:
   mov AX,[BP+06]
   mov [offset _samppriority],AX
   mov word ptr [offset _soundptr],0000
   mov word ptr [offset _soundlen],0000
   mov word ptr [offset _soundcount],0000
L0ce00955:
   mov word ptr [BP-0E],0000
   mov BX,[BP+10]
   add BX,+10
   shl BX,1
   mov AX,[BX+offset _notetable]
   cwd
   mov [BP-02],DX
   mov [BP-04],AX
   mov word ptr [offset _makesound],0001
L0ce00973:
   mov AX,[BP-0E]
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   mov AX,[ES:BX]
   cwd
   mov [BP-06],DX
   mov [BP-08],AX
   inc word ptr [BP-0E]
   cmp word ptr [BP-06],-01
   jnz L0ce009a8
   cmp word ptr [BP-08],-01
   jnz L0ce009a8
   mov AX,[offset _soundlen]
   shl AX,1
   les BX,[offset _freq]
   add BX,AX
   mov word ptr [ES:BX],FFFF
jmp near L0ce009d8
L0ce009a8:
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
L0ce009d8:
   mov AX,[BP+0E]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
   mov AX,[BP-0E]
   cmp AX,[BP+0C]
   jge L0ce00a01
   cmp word ptr [offset _soundlen],2000
   jge L0ce00a01
jmp near L0ce00973
L0ce00a01:
   mov SP,BP
   pop BP
ret far

_soundadd: ;; 0ce00a05
   push BP
   mov BP,SP
   sub SP,+0A
   mov word ptr [BP-06],FFFF
   cmp word ptr [offset _soundoff],+00
   jz L0ce00a1a
jmp near L0ce00c01
L0ce00a1a:
   cmp word ptr [offset _makesound],+00
   jz L0ce00a3a
   mov AX,[BP+06]
   cmp AX,[offset _notepriority]
   jl L0ce00a31
   cmp word ptr [offset _notepriority],-01
   jnz L0ce00a3a
L0ce00a31:
   cmp word ptr [BP+06],-01
   jz L0ce00a3a
jmp near L0ce00c01
L0ce00a3a:
   cmp word ptr [BP+06],+00
   jge L0ce00a47
   cmp word ptr [offset _makesound],+00
   jnz L0ce00a5f
L0ce00a47:
   mov word ptr [offset _makesound],0000
   mov word ptr [offset _soundptr],0000
   mov word ptr [offset _soundlen],0000
   mov word ptr [offset _soundcount],0000
L0ce00a5f:
   mov AX,[BP+06]
   mov [offset _notepriority],AX
   mov word ptr [BP-0A],0000
L0ce00a6a:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],F0
   jnz L0ce00a95
   inc word ptr [BP-0A]
   cmp word ptr [offset _sampf],+00
   jz L0ce00a92
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-06],AX
   inc word ptr [BP-0A]
jmp near L0ce00a95
L0ce00a92:
   inc word ptr [BP-0A]
L0ce00a95:
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
   jnz L0ce00af6
   mov BX,[BP-08]
   shl BX,1
   mov AX,[BX+offset _notetable]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _freq]
   add BX,DX
   mov [ES:BX],AX
   mov AX,[BP-04]
   mul word ptr [offset _xclockrate]
   mov DX,[offset _soundlen]
   shl DX,1
   les BX,[offset _dur]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [offset _soundlen]
   mov word ptr [offset _makesound],0001
jmp near L0ce00bea
L0ce00af6:
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+offset Y24dce5f6],+01
   jge L0ce00b07
   mov AX,0001
jmp near L0ce00b10
L0ce00b07:
   mov BX,[BP-06]
   shl BX,1
   mov AX,[BX+offset Y24dce5f6]
L0ce00b10:
   mov CL,07
   shl AX,CL
   push AX
   mov AX,[BP-04]
   mul word ptr [offset _xclockrate]
   pop DX
   sub AX,DX
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jle L0ce00b8b
   push [BP-08]
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+offset Y24dce5f6],+01
   jge L0ce00b3c
   mov AX,0001
jmp near L0ce00b45
L0ce00b3c:
   mov BX,[BP-06]
   shl BX,1
   mov AX,[BX+offset Y24dce5f6]
L0ce00b45:
   push AX
   mov AX,0080
   push AX
   push DS
   mov AX,[BP-06]
   mov CL,07
   shl AX,CL
   shl AX,1
   add AX,offset _SOUNDS
   push AX
   mov AX,FFFF
   push AX
   push CS
   call near offset _sampadd
   add SP,+0C
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
jmp near L0ce00bea
L0ce00b8b:
   push [BP-08]
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+offset Y24dce5f6],+01
   jge L0ce00b9f
   mov AX,0001
jmp near L0ce00ba8
L0ce00b9f:
   mov BX,[BP-06]
   shl BX,1
   mov AX,[BX+offset Y24dce5f6]
L0ce00ba8:
   push AX
   mov AX,[BP-04]
   mul word ptr [offset _xclockrate]
   push AX
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+offset Y24dce5f6],+01
   jge L0ce00bc2
   mov BX,0001
jmp near L0ce00bcb
L0ce00bc2:
   mov BX,[BP-06]
   shl BX,1
   mov BX,[BX+offset Y24dce5f6]
L0ce00bcb:
   pop AX
   xor DX,DX
   div BX
   push AX
   push DS
   mov AX,[BP-06]
   mov CL,07
   shl AX,CL
   shl AX,1
   add AX,offset _SOUNDS
   push AX
   mov AX,FFFF
   push AX
   push CS
   call near offset _sampadd
   add SP,+0C
L0ce00bea:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],00
   jz L0ce00c01
   cmp word ptr [offset _soundlen],2000
   jge L0ce00c01
jmp near L0ce00a6a
L0ce00c01:
   mov SP,BP
   pop BP
ret far

_soundstop: ;; 0ce00c05 ;; (@) Unaccessed.
   mov word ptr [offset _makesound],0000
   call far _nosound
ret far

_timerset: ;; 0ce00c11
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0040
   mov AL,[BP+06]
   mov CL,06
   shl AL,CL
   mov DL,[BP+08]
   shl DL,1
   add AL,DL
   add AL,30
   mov DX,[BP-02]
   add DX,+03
   out DX,AL
   mov DX,[BP-02]
   add DX,[BP+06]
   mov AL,[BP+0A]
   out DX,AL
   mov AX,[BP+0A]
   mov CL,08
   shr AX,CL
   mov DX,[BP-02]
   add DX,[BP+06]
   out DX,AL
   mov SP,BP
   pop BP
ret far

_our_pc_sound: ;; 0ce00c4f
   push BP
   mov BP,SP
   sub SP,+02
   cmp word ptr [offset _makesound],+00
   jz L0ce00cc8
   dec word ptr [offset _soundcount]
   cmp word ptr [offset _soundcount],+00
   jg L0ce00cc8
   mov AX,[offset _soundptr]
   cmp AX,[offset _soundlen]
   jl L0ce00c7d
   mov word ptr [offset _makesound],0000
   call far _nosound
jmp near L0ce00cc8
L0ce00c7d:
   mov AX,[offset _soundptr]
   shl AX,1
   les BX,[offset _freq]
   add BX,AX
   mov AX,[ES:BX]
   mov [BP-02],AX
   cmp word ptr [BP-02],-01
   jnz L0ce00c9b
   call far _nosound
jmp near L0ce00cad
L0ce00c9b:
   mov AX,[BP-02]
   cmp AX,[offset _oldfreq]
   jz L0ce00cad
   push [BP-02]
   call far _sound
   pop CX
L0ce00cad:
   mov AX,[offset _soundptr]
   shl AX,1
   les BX,[offset _dur]
   add BX,AX
   mov AX,[ES:BX]
   mov [offset _soundcount],AX
   inc word ptr [offset _soundptr]
   mov AX,[BP-02]
   mov [offset _oldfreq],AX
L0ce00cc8:
   mov SP,BP
   pop BP
ret far

Segment 0dac ;; DIGI.ASM:DIGI
_digi_intr: ;; 0dac000c
   sti
   push DS
   push AX
   mov AX,segment A24dc0000
   mov DS,AX
   dec word ptr [offset _intrcount]
   cmp word ptr [offset _intrcount],+00
   jle L0dac0062
   cmp word ptr [offset _soundf],+00
   jz L0dac0062
   cmp word ptr [offset _vocflag],+00
   jz L0dac007b
   cmp word ptr [offset _xvoclen],+00
   jz L0dac0062
   push DX
   push ES
   push BX
   mov DX,[offset _ct_io_addx]
   add DX,+0C
   in AL,DX
   test AL,80
   jnz L0dac005f
   cli
   mov AL,10
   out DX,AL
   les BX,[offset _xvocptr]
   inc word ptr [offset _xvocptr]
   mov AH,[ES:BX]
   dec word ptr [offset _xvoclen]
L0dac0056:
   in AL,DX
   test AL,80
   jnz L0dac0056
   mov AL,AH
   out DX,AL
   sti
L0dac005f:
   pop BX
   pop ES
   pop DX
L0dac0062:
   dec word ptr [offset _countdown]
   cmp word ptr [offset _countdown],+00
   jnz L0dac0070
jmp near L0dac008f

X0dac006f:
   nop
L0dac0070:
   mov AL,20
   out 20,AL
   inc word ptr [offset _intrcount]
   pop AX
   pop DS
iret
L0dac007b:
   push AX
   push BX
   push CX
   push DX
   push ES
   push SI
   push DI
   call far [offset _pc_sound]
   pop DI
   pop SI
   pop ES
   pop DX
   pop CX
   pop BX
   pop AX
jmp near L0dac0062
L0dac008f:
   push BP
   push BX
   push CX
   push DX
   push ES
   push SI
   push DI
   mov AX,[offset _countmax]
   mov [offset _countdown],AX
   mov CX,[offset _xtickrate]
   add [offset _longclock],CX
   adc word ptr [offset _longclock+02],+00
   add [offset _timercount],CX
   jnb L0dac00b4
   pushf
   call far [offset _timer8int]
L0dac00b4:
   sub [offset _musiccount],CX
   jnb L0dac00d7
   pushf
   call far [offset _music8int]
   mov BX,[offset _musicval]
   mov [offset _musiccount],BX
   mov DX,0043
   mov AL,34
   out DX,AL
   mov DX,0040
   mov AX,[offset _xclockval]
   out DX,AL
   xchg AL,AH
   out DX,AL
L0dac00d7:
   pop DI
   pop SI
   pop ES
   pop DX
   pop CX
   pop BX
   pop BP
jmp near L0dac0070

Segment 0dba ;; JOBJ.C:JOBJ
_initobjinfo: ;; 0dba0000
   push BP
   mov BP,SP
   mov word ptr [offset _kindmsg+4*00+2],segment _msg_player
   mov word ptr [offset _kindmsg+4*00+0],offset _msg_player
   mov word ptr [offset _kindxl+2*00],0010
   mov word ptr [offset _kindyl+2*00],0020
   mov [offset _kindname+4*00+2],DS
   mov word ptr [offset _kindname+4*00+0],offset Y24dc0e22
   mov word ptr [offset _kindflags+2*00],0008
   mov word ptr [offset _kindtable+2*00],0008
   mov word ptr [offset _kindscore+2*00],0000
   mov word ptr [offset _kindmsg+4*01+2],segment _msg_apple
   mov word ptr [offset _kindmsg+4*01+0],offset _msg_apple
   mov word ptr [offset _kindxl+2*01],000C
   mov word ptr [offset _kindyl+2*01],000C
   mov [offset _kindname+4*01+2],DS
   mov word ptr [offset _kindname+4*01+0],offset Y24dc0e29
   mov word ptr [offset _kindflags+2*01],0000
   mov word ptr [offset _kindtable+2*01],0009
   mov word ptr [offset _kindscore+2*01],000C
   mov word ptr [offset _kindmsg+4*02+2],segment _msg_knife
   mov word ptr [offset _kindmsg+4*02+0],offset _msg_knife
   mov word ptr [offset _kindxl+2*02],000A
   mov word ptr [offset _kindyl+2*02],000A
   mov [offset _kindname+4*02+2],DS
   mov word ptr [offset _kindname+4*02+0],offset Y24dc0e2f
   mov word ptr [offset _kindflags+2*02],4008
   mov word ptr [offset _kindtable+2*02],000D
   mov word ptr [offset _kindscore+2*02],0000
   mov word ptr [offset _kindmsg+4*03+2],segment _msg_null
   mov word ptr [offset _kindmsg+4*03+0],offset _msg_null
   mov word ptr [offset _kindxl+2*03],0000
   mov word ptr [offset _kindyl+2*03],0000
   mov [offset _kindname+4*03+2],DS
   mov word ptr [offset _kindname+4*03+0],offset Y24dc0e35
   mov word ptr [offset _kindflags+2*03],0000
   mov word ptr [offset _kindtable+2*03],0000
   mov word ptr [offset _kindscore+2*03],0000
   mov word ptr [offset _kindmsg+4*04+2],segment _msg_bigant
   mov word ptr [offset _kindmsg+4*04+0],offset _msg_bigant
   mov word ptr [offset _kindxl+2*04],0018
   mov word ptr [offset _kindyl+2*04],0010
   mov [offset _kindname+4*04+2],DS
   mov word ptr [offset _kindname+4*04+0],offset Y24dc0e3c
   mov word ptr [offset _kindflags+2*04],0480
   mov word ptr [offset _kindtable+2*04],003B
   mov word ptr [offset _kindscore+2*04],0008
   mov word ptr [offset _kindmsg+4*05+2],segment _msg_fly
   mov word ptr [offset _kindmsg+4*05+0],offset _msg_fly
   mov word ptr [offset _kindxl+2*05],0010
   mov word ptr [offset _kindyl+2*05],000E
   mov [offset _kindname+4*05+2],DS
   mov word ptr [offset _kindname+4*05+0],offset Y24dc0e43
   mov word ptr [offset _kindflags+2*05],0080
   mov word ptr [offset _kindtable+2*05],003C
   mov word ptr [offset _kindscore+2*05],0003
   mov word ptr [offset _kindmsg+4*06+2],segment _msg_macrotrig
   mov word ptr [offset _kindmsg+4*06+0],offset _msg_macrotrig
   mov word ptr [offset _kindxl+2*06],0000
   mov word ptr [offset _kindyl+2*06],0000
   mov [offset _kindname+4*06+2],DS
   mov word ptr [offset _kindname+4*06+0],offset Y24dc0e47
   mov word ptr [offset _kindflags+2*06],0008
   mov word ptr [offset _kindtable+2*06],0000
   mov word ptr [offset _kindscore+2*06],0000
   mov word ptr [offset _kindmsg+4*07+2],segment _msg_demon
   mov word ptr [offset _kindmsg+4*07+0],offset _msg_demon
   mov word ptr [offset _kindxl+2*07],0020
   mov word ptr [offset _kindyl+2*07],0020
   mov [offset _kindname+4*07+2],DS
   mov word ptr [offset _kindname+4*07+0],offset Y24dc0e51
   mov word ptr [offset _kindflags+2*07],0000
   mov word ptr [offset _kindtable+2*07],002B
   mov word ptr [offset _kindscore+2*07],0014
   mov word ptr [offset _kindmsg+4*08+2],segment _msg_frog
   mov word ptr [offset _kindmsg+4*08+0],offset _msg_frog
   mov word ptr [offset _kindxl+2*08],0008
   mov word ptr [offset _kindyl+2*08],0008
   mov [offset _kindname+4*08+2],DS
   mov word ptr [offset _kindname+4*08+0],offset Y24dc0e57
   mov word ptr [offset _kindflags+2*08],0480
   mov word ptr [offset _kindtable+2*08],003A
   mov word ptr [offset _kindscore+2*08],0002
   mov word ptr [offset _kindmsg+4*09+2],segment _msg_inchworm
   mov word ptr [offset _kindmsg+4*09+0],offset _msg_inchworm
   mov word ptr [offset _kindxl+2*09],0010
   mov word ptr [offset _kindyl+2*09],0008
   mov [offset _kindname+4*09+2],DS
   mov word ptr [offset _kindname+4*09+0],offset Y24dc0e5d
   mov word ptr [offset _kindflags+2*09],0480
   mov word ptr [offset _kindtable+2*09],0016
   mov word ptr [offset _kindscore+2*09],0003
   mov word ptr [offset _kindmsg+4*0a+2],segment _msg_zapper
   mov word ptr [offset _kindmsg+4*0a+0],offset _msg_zapper
   mov word ptr [offset _kindxl+2*0a],0020
   mov word ptr [offset _kindyl+2*0a],0010
   mov [offset _kindname+4*0a+2],DS
   mov word ptr [offset _kindname+4*0a+0],offset Y24dc0e66
   mov word ptr [offset _kindflags+2*0a],0000
   mov word ptr [offset _kindtable+2*0a],001C
   mov word ptr [offset _kindscore+2*0a],0000
   mov word ptr [offset _kindmsg+4*0b+2],segment _msg_bobslug
   mov word ptr [offset _kindmsg+4*0b+0],offset _msg_bobslug
   mov word ptr [offset _kindxl+2*0b],0018
   mov word ptr [offset _kindyl+2*0b],0018
   mov [offset _kindname+4*0b+2],DS
   mov word ptr [offset _kindname+4*0b+0],offset Y24dc0e6d
   mov word ptr [offset _kindflags+2*0b],0400
   mov word ptr [offset _kindtable+2*0b],0034
   mov word ptr [offset _kindscore+2*0b],0005
   mov word ptr [offset _kindmsg+4*0c+2],segment _msg_checkpt
   mov word ptr [offset _kindmsg+4*0c+0],offset _msg_checkpt
   mov word ptr [offset _kindxl+2*0c],0010
   mov word ptr [offset _kindyl+2*0c],0010
   mov [offset _kindname+4*0c+2],DS
   mov word ptr [offset _kindname+4*0c+0],offset Y24dc0e75
   mov word ptr [offset _kindflags+2*0c],0040
   mov word ptr [offset _kindtable+2*0c],0000
   mov word ptr [offset _kindscore+2*0c],0000
   mov word ptr [offset _kindmsg+4*0d+2],segment _msg_paul
   mov word ptr [offset _kindmsg+4*0d+0],offset _msg_paul
   mov word ptr [offset _kindxl+2*0d],0018
   mov word ptr [offset _kindyl+2*0d],0020
   mov [offset _kindname+4*0d+2],DS
   mov word ptr [offset _kindname+4*0d+0],offset Y24dc0e7d
   mov word ptr [offset _kindflags+2*0d],0000
   mov word ptr [offset _kindtable+2*0d],0039
   mov word ptr [offset _kindscore+2*0d],0000
   mov word ptr [offset _kindmsg+4*0e+2],segment _msg_key
   mov word ptr [offset _kindmsg+4*0e+0],offset _msg_key
   mov word ptr [offset _kindxl+2*0e],0010
   mov word ptr [offset _kindyl+2*0e],0008
   mov [offset _kindname+4*0e+2],DS
   mov word ptr [offset _kindname+4*0e+0],offset Y24dc0e82
   mov word ptr [offset _kindflags+2*0e],0000
   mov word ptr [offset _kindtable+2*0e],000E
   mov word ptr [offset _kindscore+2*0e],0000
   mov word ptr [offset _kindmsg+4*0f+2],segment _msg_pad
   mov word ptr [offset _kindmsg+4*0f+0],offset _msg_pad
   mov word ptr [offset _kindxl+2*0f],0010
   mov word ptr [offset _kindyl+2*0f],0010
   mov [offset _kindname+4*0f+2],DS
   mov word ptr [offset _kindname+4*0f+0],offset Y24dc0e86
   mov word ptr [offset _kindflags+2*0f],0000
   mov word ptr [offset _kindtable+2*0f],0000
   mov word ptr [offset _kindscore+2*0f],0000
   mov word ptr [offset _kindmsg+4*10+2],segment _msg_wiseman
   mov word ptr [offset _kindmsg+4*10+0],offset _msg_wiseman
   mov word ptr [offset _kindxl+2*10],0010
   mov word ptr [offset _kindyl+2*10],0018
   mov [offset _kindname+4*10+2],DS
   mov word ptr [offset _kindname+4*10+0],offset Y24dc0e8a
   mov word ptr [offset _kindflags+2*10],0040
   mov word ptr [offset _kindtable+2*10],000B
   mov word ptr [offset _kindscore+2*10],0000
   mov word ptr [offset _kindmsg+4*11+2],segment _msg_fatso
   mov word ptr [offset _kindmsg+4*11+0],offset _msg_fatso
   mov word ptr [offset _kindxl+2*11],0014
   mov word ptr [offset _kindyl+2*11],001C
   mov [offset _kindname+4*11+2],DS
   mov word ptr [offset _kindname+4*11+0],offset Y24dc0e92
   mov word ptr [offset _kindflags+2*11],0480
   mov word ptr [offset _kindtable+2*11],002C
   mov word ptr [offset _kindscore+2*11],000C
   mov word ptr [offset _kindmsg+4*12+2],segment _msg_fireball
   mov word ptr [offset _kindmsg+4*12+0],offset _msg_fireball
   mov word ptr [offset _kindxl+2*12],0010
   mov word ptr [offset _kindyl+2*12],0010
   mov [offset _kindname+4*12+2],DS
   mov word ptr [offset _kindname+4*12+0],offset Y24dc0e98
   mov word ptr [offset _kindflags+2*12],0000
   mov word ptr [offset _kindtable+2*12],001A
   mov word ptr [offset _kindscore+2*12],0000
   mov word ptr [offset _kindmsg+4*13+2],segment _msg_cloud
   mov word ptr [offset _kindmsg+4*13+0],offset _msg_cloud
   mov word ptr [offset _kindxl+2*13],0010
   mov word ptr [offset _kindyl+2*13],0010
   mov [offset _kindname+4*13+2],DS
   mov word ptr [offset _kindname+4*13+0],offset Y24dc0ea1
   mov word ptr [offset _kindflags+2*13],0000
   mov word ptr [offset _kindtable+2*13],000A
   mov word ptr [offset _kindscore+2*13],0000
   mov word ptr [offset _kindmsg+4*14+2],segment _msg_text6
   mov word ptr [offset _kindmsg+4*14+0],offset _msg_text6
   mov word ptr [offset _kindxl+2*14],0006
   mov word ptr [offset _kindyl+2*14],0007
   mov [offset _kindname+4*14+2],DS
   mov word ptr [offset _kindname+4*14+0],offset Y24dc0ea7
   mov word ptr [offset _kindflags+2*14],0040
   mov word ptr [offset _kindtable+2*14],0000
   mov word ptr [offset _kindscore+2*14],0000
   mov word ptr [offset _kindmsg+4*15+2],segment _msg_text8
   mov word ptr [offset _kindmsg+4*15+0],offset _msg_text8
   mov word ptr [offset _kindxl+2*15],0008
   mov word ptr [offset _kindyl+2*15],0008
   mov [offset _kindname+4*15+2],DS
   mov word ptr [offset _kindname+4*15+0],offset Y24dc0ead
   mov word ptr [offset _kindflags+2*15],0040
   mov word ptr [offset _kindtable+2*15],0000
   mov word ptr [offset _kindscore+2*15],0000
   mov word ptr [offset _kindmsg+4*16+2],segment _msg_frog
   mov word ptr [offset _kindmsg+4*16+0],offset _msg_frog
   mov word ptr [offset _kindxl+2*16],000E
   mov word ptr [offset _kindyl+2*16],000A
   mov [offset _kindname+4*16+2],DS
   mov word ptr [offset _kindname+4*16+0],offset Y24dc0eb3
   mov word ptr [offset _kindflags+2*16],0480
   mov word ptr [offset _kindtable+2*16],003F
   mov word ptr [offset _kindscore+2*16],000F
   mov word ptr [offset _kindmsg+4*17+2],segment _msg_tiny
   mov word ptr [offset _kindmsg+4*17+0],offset _msg_tiny
   mov word ptr [offset _kindxl+2*17],0004
   mov word ptr [offset _kindyl+2*17],000A
   mov [offset _kindname+4*17+2],DS
   mov word ptr [offset _kindname+4*17+0],offset Y24dc0eb8
   mov word ptr [offset _kindflags+2*17],0008
   mov word ptr [offset _kindtable+2*17],0010
   mov word ptr [offset _kindscore+2*17],0000
   mov word ptr [offset _kindmsg+4*18+2],segment _msg_door
   mov word ptr [offset _kindmsg+4*18+0],offset _msg_door
   mov word ptr [offset _kindxl+2*18],0010
   mov word ptr [offset _kindyl+2*18],0018
   mov [offset _kindname+4*18+2],DS
   mov word ptr [offset _kindname+4*18+0],offset Y24dc0ebd
   mov word ptr [offset _kindflags+2*18],0100
   mov word ptr [offset _kindtable+2*18],0000
   mov word ptr [offset _kindscore+2*18],0000
   mov word ptr [offset _kindmsg+4*19+2],segment _msg_falldoor
   mov word ptr [offset _kindmsg+4*19+0],offset _msg_falldoor
   mov word ptr [offset _kindxl+2*19],0010
   mov word ptr [offset _kindyl+2*19],0010
   mov [offset _kindname+4*19+2],DS
   mov word ptr [offset _kindname+4*19+0],offset Y24dc0ec2
   mov word ptr [offset _kindflags+2*19],0100
   mov word ptr [offset _kindtable+2*19],000E
   mov word ptr [offset _kindscore+2*19],0000
   mov word ptr [offset _kindmsg+4*1a+2],segment _msg_bridger
   mov word ptr [offset _kindmsg+4*1a+0],offset _msg_bridger
   mov word ptr [offset _kindxl+2*1a],0000
   mov word ptr [offset _kindyl+2*1a],0000
   mov [offset _kindname+4*1a+2],DS
   mov word ptr [offset _kindname+4*1a+0],offset Y24dc0ecb
   mov word ptr [offset _kindflags+2*1a],0100
   mov word ptr [offset _kindtable+2*1a],0000
   mov word ptr [offset _kindscore+2*1a],0000
   mov word ptr [offset _kindmsg+4*1b+2],segment _msg_score
   mov word ptr [offset _kindmsg+4*1b+0],offset _msg_score
   mov word ptr [offset _kindxl+2*1b],0004
   mov word ptr [offset _kindyl+2*1b],0005
   mov [offset _kindname+4*1b+2],DS
   mov word ptr [offset _kindname+4*1b+0],offset Y24dc0ed3
   mov word ptr [offset _kindflags+2*1b],0000
   mov word ptr [offset _kindtable+2*1b],0000
   mov word ptr [offset _kindscore+2*1b],0000
   mov word ptr [offset _kindmsg+4*1c+2],segment _msg_token
   mov word ptr [offset _kindmsg+4*1c+0],offset _msg_token
   mov word ptr [offset _kindxl+2*1c],0010
   mov word ptr [offset _kindyl+2*1c],0010
   mov [offset _kindname+4*1c+2],DS
   mov word ptr [offset _kindname+4*1c+0],offset Y24dc0ed9
   mov word ptr [offset _kindflags+2*1c],0008
   mov word ptr [offset _kindtable+2*1c],0000
   mov word ptr [offset _kindscore+2*1c],0000
   mov word ptr [offset _kindmsg+4*1d+2],segment _msg_ant
   mov word ptr [offset _kindmsg+4*1d+0],offset _msg_ant
   mov word ptr [offset _kindxl+2*1d],0020
   mov word ptr [offset _kindyl+2*1d],0010
   mov [offset _kindname+4*1d+2],DS
   mov word ptr [offset _kindname+4*1d+0],offset Y24dc0edf
   mov word ptr [offset _kindflags+2*1d],0480
   mov word ptr [offset _kindtable+2*1d],000A
   mov word ptr [offset _kindscore+2*1d],0006
   mov word ptr [offset _kindmsg+4*1e+2],segment _msg_phoenix
   mov word ptr [offset _kindmsg+4*1e+0],offset _msg_phoenix
   mov word ptr [offset _kindxl+2*1e],0010
   mov word ptr [offset _kindyl+2*1e],0010
   mov [offset _kindname+4*1e+2],DS
   mov word ptr [offset _kindname+4*1e+0],offset Y24dc0ee3
   mov word ptr [offset _kindflags+2*1e],0480
   mov word ptr [offset _kindtable+2*1e],000B
   mov word ptr [offset _kindscore+2*1e],0004
   mov word ptr [offset _kindmsg+4*1f+2],segment _msg_fire
   mov word ptr [offset _kindmsg+4*1f+0],offset _msg_fire
   mov word ptr [offset _kindxl+2*1f],0010
   mov word ptr [offset _kindyl+2*1f],0020
   mov [offset _kindname+4*1f+2],DS
   mov word ptr [offset _kindname+4*1f+0],offset Y24dc0eeb
   mov word ptr [offset _kindflags+2*1f],0000
   mov word ptr [offset _kindtable+2*1f],000C
   mov word ptr [offset _kindscore+2*1f],0000
   mov word ptr [offset _kindmsg+4*20+2],segment _msg_switch
   mov word ptr [offset _kindmsg+4*20+0],offset _msg_switch
   mov word ptr [offset _kindxl+2*20],0010
   mov word ptr [offset _kindyl+2*20],0010
   mov [offset _kindname+4*20+2],DS
   mov word ptr [offset _kindname+4*20+0],offset Y24dc0ef0
   mov word ptr [offset _kindflags+2*20],0008
   mov word ptr [offset _kindtable+2*20],003C
   mov word ptr [offset _kindscore+2*20],0000
   mov word ptr [offset _kindmsg+4*21+2],segment _msg_gem
   mov word ptr [offset _kindmsg+4*21+0],offset _msg_gem
   mov word ptr [offset _kindxl+2*21],0010
   mov word ptr [offset _kindyl+2*21],0010
   mov [offset _kindname+4*21+2],DS
   mov word ptr [offset _kindname+4*21+0],offset Y24dc0ef7
   mov word ptr [offset _kindflags+2*21],0000
   mov word ptr [offset _kindtable+2*21],0009
   mov word ptr [offset _kindscore+2*21],0017
   mov word ptr [offset _kindmsg+4*22+2],segment _msg_txtmsg
   mov word ptr [offset _kindmsg+4*22+0],offset _msg_txtmsg
   mov word ptr [offset _kindxl+2*22],0010
   mov word ptr [offset _kindyl+2*22],0010
   mov [offset _kindname+4*22+2],DS
   mov word ptr [offset _kindname+4*22+0],offset Y24dc0efb
   mov word ptr [offset _kindflags+2*22],0008
   mov word ptr [offset _kindtable+2*22],000E
   mov word ptr [offset _kindscore+2*22],0000
   mov word ptr [offset _kindmsg+4*23+2],segment _msg_boulder
   mov word ptr [offset _kindmsg+4*23+0],offset _msg_boulder
   mov word ptr [offset _kindxl+2*23],0010
   mov word ptr [offset _kindyl+2*23],0010
   mov [offset _kindname+4*23+2],DS
   mov word ptr [offset _kindname+4*23+0],offset Y24dc0f02
   mov word ptr [offset _kindflags+2*23],0000
   mov word ptr [offset _kindtable+2*23],0000
   mov word ptr [offset _kindscore+2*23],0000
   mov word ptr [offset _kindmsg+4*24+2],segment _msg_expl1
   mov word ptr [offset _kindmsg+4*24+0],offset _msg_expl1
   mov word ptr [offset _kindxl+2*24],0010
   mov word ptr [offset _kindyl+2*24],0020
   mov [offset _kindname+4*24+2],DS
   mov word ptr [offset _kindname+4*24+0],offset Y24dc0f0a
   mov word ptr [offset _kindflags+2*24],0000
   mov word ptr [offset _kindtable+2*24],002E
   mov word ptr [offset _kindscore+2*24],0000
   mov word ptr [offset _kindmsg+4*25+2],segment _msg_expl2
   mov word ptr [offset _kindmsg+4*25+0],offset _msg_expl2
   mov word ptr [offset _kindxl+2*25],0010
   mov word ptr [offset _kindyl+2*25],0020
   mov [offset _kindname+4*25+2],DS
   mov word ptr [offset _kindname+4*25+0],offset Y24dc0f10
   mov word ptr [offset _kindflags+2*25],0000
   mov word ptr [offset _kindtable+2*25],000E
   mov word ptr [offset _kindscore+2*25],0000
   mov word ptr [offset _kindmsg+4*26+2],segment _msg_stalag
   mov word ptr [offset _kindmsg+4*26+0],offset _msg_stalag
   mov word ptr [offset _kindxl+2*26],0010
   mov word ptr [offset _kindyl+2*26],0010
   mov [offset _kindname+4*26+2],DS
   mov word ptr [offset _kindname+4*26+0],offset Y24dc0f16
   mov word ptr [offset _kindflags+2*26],0100
   mov word ptr [offset _kindtable+2*26],0000
   mov word ptr [offset _kindscore+2*26],0000
   mov word ptr [offset _kindmsg+4*27+2],segment _msg_snake
   mov word ptr [offset _kindmsg+4*27+0],offset _msg_snake
   mov word ptr [offset _kindxl+2*27],0038
   mov word ptr [offset _kindyl+2*27],0010
   mov [offset _kindname+4*27+2],DS
   mov word ptr [offset _kindname+4*27+0],offset Y24dc0f1d
   mov word ptr [offset _kindflags+2*27],0400
   mov word ptr [offset _kindtable+2*27],000F
   mov word ptr [offset _kindscore+2*27],0023
   mov word ptr [offset _kindmsg+4*28+2],segment _msg_searock
   mov word ptr [offset _kindmsg+4*28+0],offset _msg_searock
   mov word ptr [offset _kindxl+2*28],0010
   mov word ptr [offset _kindyl+2*28],0010
   mov [offset _kindname+4*28+2],DS
   mov word ptr [offset _kindname+4*28+0],offset Y24dc0f23
   mov word ptr [offset _kindflags+2*28],0000
   mov word ptr [offset _kindtable+2*28],000E
   mov word ptr [offset _kindscore+2*28],0000
   mov word ptr [offset _kindmsg+4*29+2],segment _msg_boll
   mov word ptr [offset _kindmsg+4*29+0],offset _msg_boll
   mov word ptr [offset _kindxl+2*29],000E
   mov word ptr [offset _kindyl+2*29],000E
   mov [offset _kindname+4*29+2],DS
   mov word ptr [offset _kindname+4*29+0],offset Y24dc0f2b
   mov word ptr [offset _kindflags+2*29],0000
   mov word ptr [offset _kindtable+2*29],001F
   mov word ptr [offset _kindscore+2*29],0000
   mov word ptr [offset _kindmsg+4*2a+2],segment _msg_mega
   mov word ptr [offset _kindmsg+4*2a+0],offset _msg_mega
   mov word ptr [offset _kindxl+2*2a],0014
   mov word ptr [offset _kindyl+2*2a],0018
   mov [offset _kindname+4*2a+2],DS
   mov word ptr [offset _kindname+4*2a+0],offset Y24dc0f30
   mov word ptr [offset _kindflags+2*2a],0100
   mov word ptr [offset _kindtable+2*2a],0021
   mov word ptr [offset _kindscore+2*2a],0000
   mov word ptr [offset _kindmsg+4*2b+2],segment _msg_bat
   mov word ptr [offset _kindmsg+4*2b+0],offset _msg_bat
   mov word ptr [offset _kindxl+2*2b],001A
   mov word ptr [offset _kindyl+2*2b],0020
   mov [offset _kindname+4*2b+2],DS
   mov word ptr [offset _kindname+4*2b+0],offset Y24dc0f35
   mov word ptr [offset _kindflags+2*2b],0480
   mov word ptr [offset _kindtable+2*2b],0023
   mov word ptr [offset _kindscore+2*2b],0004
   mov word ptr [offset _kindmsg+4*2c+2],segment _msg_knight
   mov word ptr [offset _kindmsg+4*2c+0],offset _msg_knight
   mov word ptr [offset _kindxl+2*2c],0020
   mov word ptr [offset _kindyl+2*2c],0020
   mov [offset _kindname+4*2c+2],DS
   mov word ptr [offset _kindname+4*2c+0],offset Y24dc0f39
   mov word ptr [offset _kindflags+2*2c],0100
   mov word ptr [offset _kindtable+2*2c],0024
   mov word ptr [offset _kindscore+2*2c],0000
   mov word ptr [offset _kindmsg+4*2d+2],segment _msg_beenest
   mov word ptr [offset _kindmsg+4*2d+0],offset _msg_beenest
   mov word ptr [offset _kindxl+2*2d],0010
   mov word ptr [offset _kindyl+2*2d],0010
   mov [offset _kindname+4*2d+2],DS
   mov word ptr [offset _kindname+4*2d+0],offset Y24dc0f40
   mov word ptr [offset _kindflags+2*2d],0000
   mov word ptr [offset _kindtable+2*2d],0025
   mov word ptr [offset _kindscore+2*2d],000B
   mov word ptr [offset _kindmsg+4*2e+2],segment _msg_beeswarm
   mov word ptr [offset _kindmsg+4*2e+0],offset _msg_beeswarm
   mov word ptr [offset _kindxl+2*2e],0010
   mov word ptr [offset _kindyl+2*2e],0010
   mov [offset _kindname+4*2e+2],DS
   mov word ptr [offset _kindname+4*2e+0],offset Y24dc0f48
   mov word ptr [offset _kindflags+2*2e],0000
   mov word ptr [offset _kindtable+2*2e],0025
   mov word ptr [offset _kindscore+2*2e],0000
   mov word ptr [offset _kindmsg+4*2f+2],segment _msg_crab
   mov word ptr [offset _kindmsg+4*2f+0],offset _msg_crab
   mov word ptr [offset _kindxl+2*2f],0010
   mov word ptr [offset _kindyl+2*2f],0010
   mov [offset _kindname+4*2f+2],DS
   mov word ptr [offset _kindname+4*2f+0],offset Y24dc0f51
   mov word ptr [offset _kindflags+2*2f],0480
   mov word ptr [offset _kindtable+2*2f],0026
   mov word ptr [offset _kindscore+2*2f],0002
   mov word ptr [offset _kindmsg+4*30+2],segment _msg_croc
   mov word ptr [offset _kindmsg+4*30+0],offset _msg_croc
   mov word ptr [offset _kindxl+2*30],0040
   mov word ptr [offset _kindyl+2*30],0008
   mov [offset _kindname+4*30+2],DS
   mov word ptr [offset _kindname+4*30+0],offset Y24dc0f56
   mov word ptr [offset _kindflags+2*30],0480
   mov word ptr [offset _kindtable+2*30],0027
   mov word ptr [offset _kindscore+2*30],0003
   mov word ptr [offset _kindmsg+4*31+2],segment _msg_epic
   mov word ptr [offset _kindmsg+4*31+0],offset _msg_epic
   mov word ptr [offset _kindxl+2*31],0020
   mov word ptr [offset _kindyl+2*31],0010
   mov [offset _kindname+4*31+2],DS
   mov word ptr [offset _kindname+4*31+0],offset Y24dc0f5b
   mov word ptr [offset _kindflags+2*31],0000
   mov word ptr [offset _kindtable+2*31],0028
   mov word ptr [offset _kindscore+2*31],0023
   mov word ptr [offset _kindmsg+4*32+2],segment _msg_spinblad
   mov word ptr [offset _kindmsg+4*32+0],offset _msg_spinblad
   mov word ptr [offset _kindxl+2*32],0010
   mov word ptr [offset _kindyl+2*32],0010
   mov [offset _kindname+4*32+2],DS
   mov word ptr [offset _kindname+4*32+0],offset Y24dc0f60
   mov word ptr [offset _kindflags+2*32],4008
   mov word ptr [offset _kindtable+2*32],002D
   mov word ptr [offset _kindscore+2*32],0000
   mov word ptr [offset _kindmsg+4*33+2],segment _msg_skull
   mov word ptr [offset _kindmsg+4*33+0],offset _msg_skull
   mov word ptr [offset _kindxl+2*33],0016
   mov word ptr [offset _kindyl+2*33],001A
   mov [offset _kindname+4*33+2],DS
   mov word ptr [offset _kindname+4*33+0],offset Y24dc0f69
   mov word ptr [offset _kindflags+2*33],0100
   mov word ptr [offset _kindtable+2*33],002F
   mov word ptr [offset _kindscore+2*33],0000
   mov word ptr [offset _kindmsg+4*34+2],segment _msg_button
   mov word ptr [offset _kindmsg+4*34+0],offset _msg_button
   mov word ptr [offset _kindxl+2*34],0010
   mov word ptr [offset _kindyl+2*34],0010
   mov [offset _kindname+4*34+2],DS
   mov word ptr [offset _kindname+4*34+0],offset Y24dc0f6f
   mov word ptr [offset _kindflags+2*34],0008
   mov word ptr [offset _kindtable+2*34],0031
   mov word ptr [offset _kindscore+2*34],0000
   mov word ptr [offset _kindmsg+4*35+2],segment _msg_pac
   mov word ptr [offset _kindmsg+4*35+0],offset _msg_pac
   mov word ptr [offset _kindxl+2*35],0010
   mov word ptr [offset _kindyl+2*35],0010
   mov [offset _kindname+4*35+2],DS
   mov word ptr [offset _kindname+4*35+0],offset Y24dc0f76
   mov word ptr [offset _kindflags+2*35],0400
   mov word ptr [offset _kindtable+2*35],0032
   mov word ptr [offset _kindscore+2*35],0000
   mov word ptr [offset _kindmsg+4*36+2],segment _msg_jillfish
   mov word ptr [offset _kindmsg+4*36+0],offset _msg_jillfish
   mov word ptr [offset _kindxl+2*36],0018
   mov word ptr [offset _kindyl+2*36],0010
   mov [offset _kindname+4*36+2],DS
   mov word ptr [offset _kindname+4*36+0],offset Y24dc0f7a
   mov word ptr [offset _kindflags+2*36],0008
   mov word ptr [offset _kindtable+2*36],0033
   mov word ptr [offset _kindscore+2*36],0000
   mov word ptr [offset _kindmsg+4*37+2],segment _msg_jillspider
   mov word ptr [offset _kindmsg+4*37+0],offset _msg_jillspider
   mov word ptr [offset _kindxl+2*37],0010
   mov word ptr [offset _kindyl+2*37],0010
   mov [offset _kindname+4*37+2],DS
   mov word ptr [offset _kindname+4*37+0],offset Y24dc0f83
   mov word ptr [offset _kindflags+2*37],0008
   mov word ptr [offset _kindtable+2*37],0000
   mov word ptr [offset _kindscore+2*37],0000
   mov word ptr [offset _kindmsg+4*38+2],segment _msg_jillbird
   mov word ptr [offset _kindmsg+4*38+0],offset _msg_jillbird
   mov word ptr [offset _kindxl+2*38],0010
   mov word ptr [offset _kindyl+2*38],0010
   mov [offset _kindname+4*38+2],DS
   mov word ptr [offset _kindname+4*38+0],offset Y24dc0f8e
   mov word ptr [offset _kindflags+2*38],0008
   mov word ptr [offset _kindtable+2*38],000B
   mov word ptr [offset _kindscore+2*38],0000
   mov word ptr [offset _kindmsg+4*39+2],segment _msg_jillfrog
   mov word ptr [offset _kindmsg+4*39+0],offset _msg_jillfrog
   mov word ptr [offset _kindxl+2*39],000E
   mov word ptr [offset _kindyl+2*39],000A
   mov [offset _kindname+4*39+2],DS
   mov word ptr [offset _kindname+4*39+0],offset Y24dc0f97
   mov word ptr [offset _kindflags+2*39],0008
   mov word ptr [offset _kindtable+2*39],003F
   mov word ptr [offset _kindscore+2*39],0000
   mov word ptr [offset _kindmsg+4*3a+2],segment _msg_bubble
   mov word ptr [offset _kindmsg+4*3a+0],offset _msg_bubble
   mov word ptr [offset _kindxl+2*3a],0008
   mov word ptr [offset _kindyl+2*3a],0008
   mov [offset _kindname+4*3a+2],DS
   mov word ptr [offset _kindname+4*3a+0],offset Y24dc0fa0
   mov word ptr [offset _kindflags+2*3a],0000
   mov word ptr [offset _kindtable+2*3a],0033
   mov word ptr [offset _kindscore+2*3a],0000
   mov word ptr [offset _kindmsg+4*3b+2],segment _msg_jellyfish
   mov word ptr [offset _kindmsg+4*3b+0],offset _msg_jellyfish
   mov word ptr [offset _kindxl+2*3b],0010
   mov word ptr [offset _kindyl+2*3b],0018
   mov [offset _kindname+4*3b+2],DS
   mov word ptr [offset _kindname+4*3b+0],offset Y24dc0fa7
   mov word ptr [offset _kindflags+2*3b],0000
   mov word ptr [offset _kindtable+2*3b],0033
   mov word ptr [offset _kindscore+2*3b],0000
   mov word ptr [offset _kindmsg+4*3c+2],segment _msg_badfish
   mov word ptr [offset _kindmsg+4*3c+0],offset _msg_badfish
   mov word ptr [offset _kindxl+2*3c],001C
   mov word ptr [offset _kindyl+2*3c],0010
   mov [offset _kindname+4*3c+2],DS
   mov word ptr [offset _kindname+4*3c+0],offset Y24dc0fb1
   mov word ptr [offset _kindflags+2*3c],0000
   mov word ptr [offset _kindtable+2*3c],0033
   mov word ptr [offset _kindscore+2*3c],0007
   mov word ptr [offset _kindmsg+4*3d+2],segment _msg_elev
   mov word ptr [offset _kindmsg+4*3d+0],offset _msg_elev
   mov word ptr [offset _kindxl+2*3d],0010
   mov word ptr [offset _kindyl+2*3d],0010
   mov [offset _kindname+4*3d+2],DS
   mov word ptr [offset _kindname+4*3d+0],offset Y24dc0fb9
   mov word ptr [offset _kindflags+2*3d],0100
   mov word ptr [offset _kindtable+2*3d],0000
   mov word ptr [offset _kindscore+2*3d],0000
   mov word ptr [offset _kindmsg+4*3e+2],segment _msg_firebullet
   mov word ptr [offset _kindmsg+4*3e+0],offset _msg_firebullet
   mov word ptr [offset _kindxl+2*3e],0010
   mov word ptr [offset _kindyl+2*3e],0010
   mov [offset _kindname+4*3e+2],DS
   mov word ptr [offset _kindname+4*3e+0],offset Y24dc0fbe
   mov word ptr [offset _kindflags+2*3e],4008
   mov word ptr [offset _kindtable+2*3e],001A
   mov word ptr [offset _kindscore+2*3e],0000
   mov word ptr [offset _kindmsg+4*3f+2],segment _msg_fishbullet
   mov word ptr [offset _kindmsg+4*3f+0],offset _msg_fishbullet
   mov word ptr [offset _kindxl+2*3f],000C
   mov word ptr [offset _kindyl+2*3f],0005
   mov [offset _kindname+4*3f+2],DS
   mov word ptr [offset _kindname+4*3f+0],offset Y24dc0fc9
   mov word ptr [offset _kindflags+2*3f],4008
   mov word ptr [offset _kindtable+2*3f],0033
   mov word ptr [offset _kindscore+2*3f],0000
   mov word ptr [offset _kindmsg+4*40+2],segment _msg_eyes
   mov word ptr [offset _kindmsg+4*40+0],offset _msg_eyes
   mov word ptr [offset _kindxl+2*40],0010
   mov word ptr [offset _kindyl+2*40],000C
   mov [offset _kindname+4*40+2],DS
   mov word ptr [offset _kindname+4*40+0],offset Y24dc0fd4
   mov word ptr [offset _kindflags+2*40],0180
   mov word ptr [offset _kindtable+2*40],003E
   mov word ptr [offset _kindscore+2*40],0003
   mov word ptr [offset _kindmsg+4*41+2],segment _msg_vineclimb
   mov word ptr [offset _kindmsg+4*41+0],offset _msg_vineclimb
   mov word ptr [offset _kindxl+2*41],0010
   mov word ptr [offset _kindyl+2*41],0008
   mov [offset _kindname+4*41+2],DS
   mov word ptr [offset _kindname+4*41+0],offset Y24dc0fd8
   mov word ptr [offset _kindflags+2*41],0000
   mov word ptr [offset _kindtable+2*41],003D
   mov word ptr [offset _kindscore+2*41],0000
   mov word ptr [offset _kindmsg+4*42+2],segment _msg_flag
   mov word ptr [offset _kindmsg+4*42+0],offset _msg_flag
   mov word ptr [offset _kindxl+2*42],0024
   mov word ptr [offset _kindyl+2*42],0010
   mov [offset _kindname+4*42+2],DS
   mov word ptr [offset _kindname+4*42+0],offset Y24dc0fe2
   mov word ptr [offset _kindflags+2*42],0008
   mov word ptr [offset _kindtable+2*42],0005
   mov word ptr [offset _kindscore+2*42],0000
   mov word ptr [offset _kindmsg+4*43+2],segment _msg_mapdemo
   mov word ptr [offset _kindmsg+4*43+0],offset _msg_mapdemo
   mov word ptr [offset _kindxl+2*43],0040
   mov word ptr [offset _kindyl+2*43],0010
   mov [offset _kindname+4*43+2],DS
   mov word ptr [offset _kindname+4*43+0],offset Y24dc0fe7
   mov word ptr [offset _kindflags+2*43],0000
   mov word ptr [offset _kindtable+2*43],0003
   mov word ptr [offset _kindscore+2*43],0000
   mov word ptr [offset _kindmsg+4*44+2],segment _msg_roman
   mov word ptr [offset _kindmsg+4*44+0],offset _msg_roman
   mov word ptr [offset _kindxl+2*44],0010
   mov word ptr [offset _kindyl+2*44],0020
   mov [offset _kindname+4*44+2],DS
   mov word ptr [offset _kindname+4*44+0],offset Y24dc0fef
   mov word ptr [offset _kindflags+2*44],0480
   mov word ptr [offset _kindtable+2*44],002C
   mov word ptr [offset _kindscore+2*44],000C
   pop BP
ret far

_msg_null: ;; 0dba0e09
   push BP
   mov BP,SP
   xor AX,AX
   pop BP
ret far

_msg_apple: ;; 0dba0e10
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba0e2e
   cmp AX,0001
   jnz L0dba0e26
jmp near L0dba0efb
L0dba0e26:
   cmp AX,0002
   jz L0dba0e8c
jmp near L0dba0ff3
L0dba0e2e:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba0ff3
L0dba0e8c:
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
   jle L0dba0ebb
   mov AX,0001
jmp near L0dba0ebe
L0dba0ebb:
   mov AX,FFFF
L0dba0ebe:
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
   jnz L0dba0ef6
   mov AX,0001
jmp near L0dba0ef8
L0dba0ef6:
   xor AX,AX
L0dba0ef8:
jmp near L0dba0ff3
L0dba0efb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L0dba0f6e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jnz L0dba0f4f
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
L0dba0f4f:
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
jmp near L0dba0ff0
L0dba0f6e:
   cmp word ptr [BP+0A],+00
   jz L0dba0f79
   xor AX,AX
jmp near L0dba0ff3
L0dba0f79:
   cmp word ptr [offset _pl+2*01],+08
   jge L0dba0f84
   inc word ptr [offset _pl+2*01]
L0dba0f84:
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
   jz L0dba0ff0
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y24dc0ff5
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_apple],0000
L0dba0ff0:
   mov AX,0001
L0dba0ff3:
   pop SI
   pop BP
ret far

_msg_knife: ;; 0dba0ff6
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov DI,[BP+0A]
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba101b
   cmp AX,0001
   jnz L0dba1013
jmp near L0dba12a2
L0dba1013:
   cmp AX,0002
   jz L0dba1061
jmp near L0dba13bb
L0dba101b:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba13bb
L0dba1061:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jg L0dba107a
jmp near L0dba1237
L0dba107a:
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
   jg L0dba10a6
jmp near L0dba1199
L0dba10a6:
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
   jle L0dba10fe
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0008
jmp near L0dba1129
L0dba10fe:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],-08
   jg L0dba1129
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],FFF8
L0dba1129:
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
   jle L0dba116e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0004
jmp near L0dba1199
L0dba116e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-04
   jg L0dba1199
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFC
L0dba1199:
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
   jle L0dba1215
   mov AX,0001
jmp near L0dba1217
L0dba1215:
   xor AX,AX
L0dba1217:
   pop DX
   or DX,AX
   jnz L0dba121f
jmp near L0dba13b8
L0dba121f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],FFFF
jmp near L0dba13b8
L0dba1237:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-01
   jnz L0dba129d
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
   jz L0dba1285
jmp near L0dba13b8
L0dba1285:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
jmp near L0dba13b8
L0dba129d:
   xor AX,AX
jmp near L0dba13bb
L0dba12a2:
   or DI,DI
   jz L0dba12a9
jmp near L0dba132e
L0dba12a9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jle L0dba12d8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+0A
   jg L0dba12d8
jmp near L0dba13b8
L0dba12d8:
   mov AX,0002
   push AX
   call far _invcount
   pop CX
   cmp AX,0003
   jl L0dba12ea
jmp near L0dba13b8
L0dba12ea:
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
   jnz L0dba1314
jmp near L0dba13b8
L0dba1314:
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y24dc100c
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_knife],0000
jmp near L0dba13b8
L0dba132e:
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
   jz L0dba13b8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jle L0dba13b8
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
L0dba13b8:
   mov AX,0001
L0dba13bb:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_nullkind: ;; 0dba13c1 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   pop BP
ret far

_msg_bigant: ;; 0dba13c6
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba13e8
   cmp AX,0001
   jnz L0dba13dd
jmp near L0dba14c5
L0dba13dd:
   cmp AX,0002
   jnz L0dba13e5
jmp near L0dba14d8
L0dba13e5:
jmp near L0dba159c
L0dba13e8:
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
   jnz L0dba1441
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0dba1421
   mov AX,0001
jmp near L0dba1423
L0dba1421:
   xor AX,AX
L0dba1423:
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
jmp near L0dba148b
L0dba1441:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dba1471
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
jmp near L0dba148b
L0dba1471:
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
L0dba148b:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba159c
L0dba14c5:
   cmp word ptr [BP+0A],+00
   jz L0dba14ce
jmp near L0dba159c
L0dba14ce:
   push SI
   call far _hitplayer
   pop CX
jmp near L0dba159c
L0dba14d8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0dba14f1
jmp near L0dba1586
L0dba14f1:
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
   jle L0dba1522
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dba1522:
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
   jnz L0dba1599
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
jmp near L0dba1599
L0dba1586:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L0dba1599:
   mov AX,0001
L0dba159c:
   pop DI
   pop SI
   pop BP
ret far

_msg_ant: ;; 0dba15a0
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba15c2
   cmp AX,0001
   jnz L0dba15b7
jmp near L0dba16a7
L0dba15b7:
   cmp AX,0002
   jnz L0dba15bf
jmp near L0dba16ba
L0dba15bf:
jmp near L0dba177e
L0dba15c2:
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
   jnz L0dba161b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dba15fb
   mov AX,0001
jmp near L0dba15fd
L0dba15fb:
   xor AX,AX
L0dba15fd:
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
jmp near L0dba166d
L0dba161b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dba1652
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
jmp near L0dba166d
L0dba1652:
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
L0dba166d:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba177e
L0dba16a7:
   cmp word ptr [BP+0A],+00
   jz L0dba16b0
jmp near L0dba177e
L0dba16b0:
   push SI
   call far _hitplayer
   pop CX
jmp near L0dba177e
L0dba16ba:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0dba16d3
jmp near L0dba1768
L0dba16d3:
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
   jle L0dba1704
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dba1704:
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
   jnz L0dba177b
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
jmp near L0dba177b
L0dba1768:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L0dba177b:
   mov AX,0001
L0dba177e:
   pop DI
   pop SI
   pop BP
ret far

_msg_fly: ;; 0dba1782
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
   mov AX,offset Y24dc0dd6
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-10]
   push AX
   push DS
   mov AX,offset Y24dc0dde
   push AX
   mov CX,0010
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L0dba17cb
   cmp AX,0001
   jnz L0dba17c0
jmp near L0dba1850
L0dba17c0:
   cmp AX,0002
   jnz L0dba17c8
jmp near L0dba18a3
L0dba17c8:
jmp near L0dba197c
L0dba17cb:
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
   jle L0dba1811
   mov AX,0004
jmp near L0dba1813
L0dba1811:
   xor AX,AX
L0dba1813:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba197c
L0dba1850:
   cmp word ptr [BP+0A],+00
   jz L0dba1859
jmp near L0dba197c
L0dba1859:
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
jmp near L0dba197c
L0dba18a3:
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
   jnz L0dba194d
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
L0dba194d:
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
L0dba197c:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_phoenix: ;; 0dba1982
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
   mov AX,offset Y24dc0dee
   push AX
   mov CX,0010
   call far SCOPY@
   push SS
   lea AX,[BP-10]
   push AX
   push DS
   mov AX,offset Y24dc0dfe
   push AX
   mov CX,0010
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L0dba19cb
   cmp AX,0001
   jnz L0dba19c0
jmp near L0dba1a6c
L0dba19c0:
   cmp AX,0002
   jnz L0dba19c8
jmp near L0dba1ac8
L0dba19c8:
jmp near L0dba1c26
L0dba19cb:
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
   jge L0dba1a28
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
jmp near L0dba1a2a
L0dba1a28:
   xor AX,AX
L0dba1a2a:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba1c26
L0dba1a6c:
   cmp word ptr [BP+0A],+00
   jz L0dba1a75
jmp near L0dba1c26
L0dba1a75:
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
jmp near L0dba1c26
L0dba1ac8:
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
   jnz L0dba1b04
   xor AX,AX
jmp near L0dba1c26
L0dba1b04:
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
   jz L0dba1b72
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+07
   jle L0dba1b87
L0dba1b72:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dba1b87:
   push [BP-22]
   push DI
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jz L0dba1bea
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
   jnz L0dba1c23
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0006
jmp near L0dba1c23
L0dba1bea:
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
L0dba1c23:
   mov AX,0001
L0dba1c26:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_inchworm: ;; 0dba1c2c
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba1c4e
   cmp AX,0001
   jnz L0dba1c43
jmp near L0dba1cc9
L0dba1c43:
   cmp AX,0002
   jnz L0dba1c4b
jmp near L0dba1cdc
L0dba1c4b:
jmp near L0dba1d87
L0dba1c4e:
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
   jge L0dba1c72
   mov AX,0001
jmp near L0dba1c74
L0dba1c72:
   xor AX,AX
L0dba1c74:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba1d87
L0dba1cc9:
   cmp word ptr [BP+0A],+00
   jz L0dba1cd2
jmp near L0dba1d87
L0dba1cd2:
   push SI
   call far _hitplayer
   pop CX
jmp near L0dba1d87
L0dba1cdc:
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
   jnz L0dba1d85
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
   jnz L0dba1d80
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
L0dba1d80:
   mov AX,0001
jmp near L0dba1d87
L0dba1d85:
   xor AX,AX
L0dba1d87:
   pop DI
   pop SI
   pop BP
ret far

_msg_zapper: ;; 0dba1d8b
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba1da7
   cmp AX,0001
   jz L0dba1dff
   cmp AX,0002
   jz L0dba1e10
jmp near L0dba1e44
L0dba1da7:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba1e44
L0dba1dff:
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   call far _p_ouch
   pop CX
   pop CX
jmp near L0dba1e44
L0dba1e10:
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
   jle L0dba1e41
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dba1e41:
   mov AX,0001
L0dba1e44:
   pop DI
   pop SI
   pop BP
ret far

_msg_bobslug: ;; 0dba1e48
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba1e6a
   cmp AX,0001
   jnz L0dba1e5f
jmp near L0dba1ef3
L0dba1e5f:
   cmp AX,0002
   jnz L0dba1e67
jmp near L0dba1f06
L0dba1e67:
jmp near L0dba1fda
L0dba1e6a:
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
   jle L0dba1e9f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   add DI,AX
jmp near L0dba1eb9
L0dba1e9f:
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
L0dba1eb9:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba1fda
L0dba1ef3:
   cmp word ptr [BP+0A],+00
   jz L0dba1efc
jmp near L0dba1fda
L0dba1efc:
   push SI
   call far _hitplayer
   pop CX
jmp near L0dba1fda
L0dba1f06:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dba1f5a
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
   jz L0dba1f42
jmp near L0dba1fd7
L0dba1f42:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
jmp near L0dba1fd7
L0dba1f5a:
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
   jz L0dba1f7c
   xor AX,AX
jmp near L0dba1fda
L0dba1f7c:
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
   jl L0dba1fd7
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
L0dba1fd7:
   mov AX,0001
L0dba1fda:
   pop DI
   pop SI
   pop BP
ret far

_msg_checkpt: ;; 0dba1fde
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba2002
   cmp AX,0001
   jnz L0dba1ff7
jmp near L0dba2167
L0dba1ff7:
   cmp AX,0002
   jnz L0dba1fff
jmp near L0dba2092
L0dba1fff:
jmp near L0dba22c1
L0dba2002:
   cmp word ptr [offset _designflag],+00
   jnz L0dba200c
jmp near L0dba22c1
L0dba200c:
   mov AX,FFFF
   push AX
   mov AX,0005
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _wprint
   add SP,+0E
jmp near L0dba22c1
L0dba2092:
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
   jg L0dba20c3
jmp near L0dba2191
L0dba20c3:
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
   jl L0dba20e5
jmp near L0dba2191
L0dba20e5:
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
   jg L0dba2116
jmp near L0dba2191
L0dba2116:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[offset _objs+03]
   add DX,[offset _objs+0B]
   cmp AX,DX
   jge L0dba2191
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
jmp near L0dba2191
L0dba2167:
   cmp word ptr [BP+0A],+00
   jz L0dba2170
jmp near L0dba22c1
L0dba2170:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+03
   jnz L0dba2196
   call far _macrecend
   mov word ptr [offset _gameover],0002
L0dba2191:
   xor AX,AX
jmp near L0dba22c1
L0dba2196:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[offset _pl+2*00]
   jnz L0dba21b2
jmp near L0dba22c1
L0dba21b2:
   cmp word ptr [offset _vocflag],+00
   jz L0dba21be
   mov AX,0005
jmp near L0dba21d4
L0dba21be:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   add AX,0032
L0dba21d4:
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
   jz L0dba220c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov [offset _pl+2*00],AX
L0dba220c:
   cmp byte ptr [offset _objs],17
   jnz L0dba2246
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
jmp near L0dba2281
L0dba2246:
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
   mov word ptr [offset _objs+0D],0004
   mov word ptr [offset _objs+11],0000
L0dba2281:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L0dba22be
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
L0dba22be:
   mov AX,0001
L0dba22c1:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_paul: ;; 0dba22c6
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba22e1
   cmp AX,0001
   jz L0dba2335
   cmp AX,0002
   jz L0dba2335
jmp near L0dba2337
L0dba22e1:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba2337
L0dba2335:
   xor AX,AX
L0dba2337:
   pop DI
   pop SI
   pop BP
ret far

_msg_wiseman: ;; 0dba233b
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba235d
   cmp AX,0001
   jnz L0dba2352
jmp near L0dba2497
L0dba2352:
   cmp AX,0002
   jnz L0dba235a
jmp near L0dba23d8
L0dba235a:
jmp near L0dba24ed
L0dba235d:
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
   jle L0dba2380
   mov AX,0001
jmp near L0dba2382
L0dba2380:
   xor AX,AX
L0dba2382:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba24ed
L0dba23d8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jz L0dba23f1
jmp near L0dba2484
L0dba23f1:
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
   jnz L0dba247f
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
L0dba247f:
   mov AX,0001
jmp near L0dba24ed
L0dba2484:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
L0dba2497:
   cmp word ptr [BP+0A],+00
   jnz L0dba24ed
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jnz L0dba24d7
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
L0dba24d7:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+1D],0003
L0dba24ed:
   pop DI
   pop SI
   pop BP
ret far

_msg_bridger: ;; 0dba24f1
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
   jnz L0dba254e
   mov AX,008C
jmp near L0dba2551
L0dba254e:
   mov AX,01B0
L0dba2551:
   mov [BP-08],AX
   mov word ptr [BP-06],0000
   mov AX,[BP+08]
   cmp AX,0005
   jbe L0dba2564
jmp near L0dba2675
L0dba2564:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y0dba256d]

Y0dba256d:	dw L0dba2579,L0dba2675,L0dba2675,L0dba2604,L0dba25f2,L0dba25c8

L0dba2579:
   cmp word ptr [offset _designflag],+00
   jnz L0dba2583
jmp near L0dba2675
L0dba2583:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba2675
L0dba25c8:
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
jmp near L0dba2675
L0dba25f2:
   mov word ptr [BP-06],0001
   mov AX,[BP-08]
   mov [BP-0C],AX
   mov word ptr [BP-0A],0000
jmp near L0dba2675
L0dba2604:
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
   jnz L0dba262f
   mov word ptr [BP-0A],0000
   mov AX,[BP-08]
   mov [BP-0C],AX
jmp near L0dba2651
L0dba262f:
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
L0dba2651:
   mov word ptr [BP-06],0001
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],0F
   jnz L0dba2675
   push [BP+0A]
   call far _killobj
   pop CX
L0dba2675:
   cmp word ptr [BP-06],+00
   jnz L0dba267e
jmp near L0dba2774
L0dba267e:
   cmp word ptr [BP-0A],+00
   jz L0dba2687
jmp near L0dba2751
L0dba2687:
   mov word ptr [BP-04],FFFF
jmp near L0dba2700
L0dba268e:
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
   jnz L0dba26fc
   mov AX,[BP-02]
   mov [BP-0A],AX
L0dba26fc:
   add word ptr [BP-04],+02
L0dba2700:
   cmp word ptr [BP-04],+01
   jle L0dba268e
jmp near L0dba2751
L0dba2708:
   mov AX,[BP-0A]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,[BP-0E]
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
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
L0dba2751:
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
   jz L0dba2708
   mov AX,0001
jmp near L0dba2776
L0dba2774:
   xor AX,AX
L0dba2776:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_key: ;; 0dba277c
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba279b
   cmp AX,0001
   jnz L0dba2793
jmp near L0dba283f
L0dba2793:
   cmp AX,0002
   jz L0dba27f1
jmp near L0dba288a
L0dba279b:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba288a
L0dba27f1:
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
   jnz L0dba2839
   mov DI,0001
jmp near L0dba283b
L0dba2839:
   xor DI,DI
L0dba283b:
   mov AX,DI
jmp near L0dba288a
L0dba283f:
   cmp word ptr [BP+0A],+00
   jz L0dba2849
   xor AX,AX
jmp near L0dba288a
L0dba2849:
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
   jz L0dba2887
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y24dc101f
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_key],0000
L0dba2887:
   mov AX,0001
L0dba288a:
   pop DI
   pop SI
   pop BP
ret far

_msg_pad: ;; 0dba288e
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba28aa
   cmp AX,0001
   jz L0dba28fc
   cmp AX,0002
   jz L0dba28f8
jmp near L0dba295b
L0dba28aa:
   cmp word ptr [offset _designflag],+00
   jnz L0dba28b4
jmp near L0dba295b
L0dba28b4:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba295b
L0dba28f8:
   xor AX,AX
jmp near L0dba295b
L0dba28fc:
   cmp word ptr [BP+0A],+00
   jnz L0dba2958
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],-01
   jnz L0dba291d
   mov DI,0004
jmp near L0dba293b
L0dba291d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L0dba2938
   mov DI,0005
jmp near L0dba293b
L0dba2938:
   mov DI,0003
L0dba293b:
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
L0dba2958:
   mov AX,0001
L0dba295b:
   pop DI
   pop SI
   pop BP
ret far

_msg_demon: ;; 0dba295f
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,offset Y24dc0e0e
   push AX
   mov CX,000C
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L0dba2995
   cmp AX,0001
   jnz L0dba298a
jmp near L0dba2c7e
L0dba298a:
   cmp AX,0002
   jnz L0dba2992
jmp near L0dba2a23
L0dba2992:
jmp near L0dba2d49
L0dba2995:
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
   jge L0dba2a06
   mov AX,0001
jmp near L0dba2a08
L0dba2a06:
   xor AX,AX
L0dba2a08:
   shl AX,1
   shl AX,1
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba2d49
L0dba2a23:
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
   jl L0dba2a54
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dba2a54:
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
   jz L0dba2ac5
   call far _rand
   mov BX,0024
   cwd
   idiv BX
   or DX,DX
   jz L0dba2ac5
jmp near L0dba2c49
L0dba2ac5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L0dba2ade
jmp near L0dba2c49
L0dba2ade:
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
   jnz L0dba2bed
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
jmp near L0dba2c49
L0dba2bed:
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
L0dba2c49:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L0dba2c64
   mov AX,0001
jmp near L0dba2c66
L0dba2c64:
   xor AX,AX
L0dba2c66:
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
jmp near L0dba2d46
L0dba2c7e:
   cmp word ptr [BP+0A],+00
   jnz L0dba2ca4
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L0dba2ca4
   push SI
   call far _hitplayer
   pop CX
jmp near L0dba2d46
L0dba2ca4:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],32
   jz L0dba2cbd
jmp near L0dba2d46
L0dba2cbd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dba2d31
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
   jle L0dba2cff
   push SI
   call far _explode2
   pop CX
   push SI
   call far _killobj
   pop CX
jmp near L0dba2d31
L0dba2cff:
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
L0dba2d31:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0004
L0dba2d46:
   mov AX,0001
L0dba2d49:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_fatso: ;; 0dba2d4e
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
   mov AX,offset Y24dc0e1a
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L0dba2d85
   cmp AX,0001
   jnz L0dba2d7a
jmp near L0dba2e12
L0dba2d7a:
   cmp AX,0002
   jnz L0dba2d82
jmp near L0dba2e25
L0dba2d82:
jmp near L0dba2f4e
L0dba2d85:
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
   jle L0dba2da9
   mov AX,0001
jmp near L0dba2dab
L0dba2da9:
   xor AX,AX
L0dba2dab:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba2f4e
L0dba2e12:
   cmp word ptr [BP+0A],+00
   jz L0dba2e1b
jmp near L0dba2f4e
L0dba2e1b:
   push SI
   call far _hitplayer
   pop CX
jmp near L0dba2f4e
L0dba2e25:
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
   jl L0dba2e56
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dba2e56:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jz L0dba2e72
   xor AX,AX
jmp near L0dba2f4e
L0dba2e72:
   call far _rand
   mov BX,001E
   cwd
   idiv BX
   or DX,DX
   jnz L0dba2eed
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
L0dba2eed:
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
   jnz L0dba2f3c
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
jmp near L0dba2f4b
L0dba2f3c:
   mov AX,0011
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L0dba2f4b:
   mov AX,0001
L0dba2f4e:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_roman: ;; 0dba2f54
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba2f78
   cmp AX,0001
   jnz L0dba2f6d
jmp near L0dba2ffa
L0dba2f6d:
   cmp AX,0002
   jnz L0dba2f75
jmp near L0dba3026
L0dba2f75:
jmp near L0dba3126
L0dba2f78:
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
   jle L0dba2f9b
   mov AX,0001
jmp near L0dba2f9d
L0dba2f9b:
   xor AX,AX
L0dba2f9d:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba3126
L0dba2ffa:
   cmp word ptr [BP+0A],+00
   jz L0dba3003
jmp near L0dba3126
L0dba3003:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L0dba301c
jmp near L0dba3126
L0dba301c:
   push SI
   call far _hitplayer
   pop CX
jmp near L0dba3126
L0dba3026:
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
   jnz L0dba30c5
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
L0dba30c5:
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
   jnz L0dba3114
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
jmp near L0dba3123
L0dba3114:
   mov AX,0011
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L0dba3123:
   mov AX,0001
L0dba3126:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_fireball: ;; 0dba312b
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba3146
   cmp AX,0001
   jz L0dba31a4
   cmp AX,0002
   jz L0dba31c0
jmp near L0dba3268
L0dba3146:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba3268
L0dba31a4:
   cmp word ptr [BP+0A],+00
   jz L0dba31ad
jmp near L0dba3268
L0dba31ad:
   push SI
   call far _hitplayer
   pop CX
   xor AX,AX
   push AX
   call far _explode2
   pop CX
jmp near L0dba3268
L0dba31c0:
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L0dba31ce
jmp near L0dba325e
L0dba31ce:
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
   jl L0dba31ff
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dba31ff:
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
   jnz L0dba3265
L0dba325e:
   push SI
   call far _killobj
   pop CX
L0dba3265:
   mov AX,0001
L0dba3268:
   pop SI
   pop BP
ret far

_msg_cloud: ;; 0dba326b
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba3285
   cmp AX,0002
   jz L0dba32c2
jmp near L0dba3381
L0dba3285:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba3381
L0dba32c2:
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
   jz L0dba337f
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
   jnz L0dba337a
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
L0dba337a:
   mov AX,0001
jmp near L0dba3381
L0dba337f:
   xor AX,AX
L0dba3381:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_text6: ;; 0dba3387
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba33a0
   cmp AX,0002
   jnz L0dba339d
jmp near L0dba345a
L0dba339d:
jmp near L0dba3493
L0dba33a0:
   cmp byte ptr [offset _x_ourmode],00
   jnz L0dba33cf
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _fontcolor
   add SP,+08
jmp near L0dba3405
L0dba33cf:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _fontcolor
   add SP,+08
L0dba3405:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _wprint
   add SP,+0E
jmp near L0dba3493
L0dba345a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jle L0dba3491
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   jg L0dba3491
   push SI
   call far _killobj
   pop CX
   mov AX,0001
jmp near L0dba3493
L0dba3491:
   xor AX,AX
L0dba3493:
   pop SI
   pop BP
ret far

_msg_score: ;; 0dba3496
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba34b3
   cmp AX,0002
   jnz L0dba34b0
jmp near L0dba355a
L0dba34b0:
jmp near L0dba35e9
L0dba34b3:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
jmp near L0dba3550
L0dba3507:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
   inc DI
L0dba3550:
   cmp byte ptr [SS:BP+DI-0A],00
   jnz L0dba3507
jmp near L0dba35e9
L0dba355a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   jl L0dba357a
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L0dba3583
L0dba357a:
   push SI
   call far _killobj
   pop CX
jmp near L0dba35e9
L0dba3583:
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
L0dba35e9:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_text8: ;; 0dba35ef
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba3608
   cmp AX,0002
   jnz L0dba3605
jmp near L0dba36c0
L0dba3605:
jmp near L0dba36f9
L0dba3608:
   cmp byte ptr [offset _x_ourmode],00
   jnz L0dba3637
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _fontcolor
   add SP,+08
jmp near L0dba366d
L0dba3637:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _fontcolor
   add SP,+08
L0dba366d:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _wprint
   add SP,+0E
jmp near L0dba36f9
L0dba36c0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jle L0dba36f7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   jg L0dba36f7
   push SI
   call far _killobj
   pop CX
   mov AX,0001
jmp near L0dba36f9
L0dba36f7:
   xor AX,AX
L0dba36f9:
   pop SI
   pop BP
ret far

_msg_frog: ;; 0dba36fc
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov SI,[BP+06]
   xor DI,DI
   mov AX,[BP+08]
   cmp AX,DI
   jz L0dba3723
   cmp AX,0001
   jnz L0dba3718
jmp near L0dba3800
L0dba3718:
   cmp AX,0002
   jnz L0dba3720
jmp near L0dba3813
L0dba3720:
jmp near L0dba3a08
L0dba3723:
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
   jge L0dba375e
   mov AX,0001
jmp near L0dba3760
L0dba375e:
   xor AX,AX
L0dba3760:
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
   jnz L0dba37c4
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L0dba379c
   mov AX,0001
jmp near L0dba379e
L0dba379c:
   xor AX,AX
L0dba379e:
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
   jg L0dba37bc
   mov AX,0001
jmp near L0dba37be
L0dba37bc:
   xor AX,AX
L0dba37be:
   pop DX
   add DX,AX
   add [BP-06],DX
L0dba37c4:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba3a08
L0dba3800:
   cmp word ptr [BP+0A],+00
   jz L0dba3809
jmp near L0dba3a08
L0dba3809:
   push SI
   call far _hitplayer
   pop CX
jmp near L0dba3a08
L0dba3813:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dba38a7
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
   jg L0dba3848
jmp near L0dba3a06
L0dba3848:
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
jmp near L0dba3a06
L0dba38a7:
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
   jle L0dba38db
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000A
L0dba38db:
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
   jz L0dba3946
jmp near L0dba3a06
L0dba3946:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L0dba3974
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
jmp near L0dba3a06
L0dba3974:
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
L0dba3a06:
   mov AX,DI
L0dba3a08:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_door: ;; 0dba3a0e
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
   jz L0dba3a6a
   cmp AX,0002
   jnz L0dba3a5f
jmp near L0dba3ba5
L0dba3a5f:
   cmp AX,0003
   jnz L0dba3a67
jmp near L0dba3be4
L0dba3a67:
jmp near L0dba3da8
L0dba3a6a:
   cmp word ptr [offset _designflag],+00
   jz L0dba3ab3
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
L0dba3ab3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dba3acc
jmp near L0dba3da8
L0dba3acc:
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
   push [offset _info+8*A1+00]
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   push [offset _info+8*A2+00]
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
jmp near L0dba3da8
L0dba3ba5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0dba3bfa
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
   jle L0dba3bde
   push SI
   call far _killobj
   pop CX
L0dba3bde:
   mov AX,0001
jmp near L0dba3da8
L0dba3be4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0dba3bff
L0dba3bfa:
   xor AX,AX
jmp near L0dba3da8
L0dba3bff:
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
   jz L0dba3c20
jmp near L0dba3cea
L0dba3c20:
   mov AX,0003
   push AX
   call far _takeinv
   pop CX
   or AX,AX
   jnz L0dba3c31
jmp near L0dba3cc6
L0dba3c31:
   mov AX,0024
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
   cmp word ptr [offset _first_openmapdoor],+00
   jz L0dba3c5e
   mov word ptr [offset _first_openmapdoor],0000
   mov AX,0001
   push AX
   push DS
   mov AX,offset Y24dc1030
   push AX
   call far _putbotmsg
   add SP,+06
L0dba3c5e:
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
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   push SI
   call far _killobj
   pop CX
jmp near L0dba3da8
L0dba3cc6:
   cmp word ptr [offset _first_nogem],+00
   jnz L0dba3cd0
jmp near L0dba3da8
L0dba3cd0:
   mov AX,0001
   push AX
   push DS
   mov AX,offset Y24dc103f
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_nogem],0000
jmp near L0dba3da8
L0dba3cea:
   mov AX,0001
   push AX
   call far _takeinv
   pop CX
   or AX,AX
   jnz L0dba3cfb
jmp near L0dba3d8a
L0dba3cfb:
   cmp word ptr [offset _first_opendoor],+00
   jz L0dba3d19
   mov word ptr [offset _first_opendoor],0000
   mov AX,0001
   push AX
   push DS
   mov AX,offset Y24dc1056
   push AX
   call far _putbotmsg
   add SP,+06
L0dba3d19:
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
jmp near L0dba3d82
L0dba3d44:
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
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,[BP-02]
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   inc word ptr [BP-04]
L0dba3d82:
   cmp word ptr [BP-04],+01
   jle L0dba3d44
jmp near L0dba3da8
L0dba3d8a:
   cmp word ptr [offset _first_nokey],+00
   jz L0dba3da8
   mov word ptr [offset _first_nokey],0000
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y24dc1065
   push AX
   call far _putbotmsg
   add SP,+06
L0dba3da8:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_falldoor: ;; 0dba3dae
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dba3dd0
   cmp AX,0002
   jz L0dba3e0d
   cmp AX,0003
   jnz L0dba3dcd
jmp near L0dba3f65
L0dba3dcd:
jmp near L0dba3fe5
L0dba3dd0:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L0dba3fe5
L0dba3e0d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dba3e28
   xor AX,AX
jmp near L0dba3fe5
L0dba3e28:
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
   jnz L0dba3e62
jmp near L0dba3ee4
L0dba3e62:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jz L0dba3e7c
jmp near L0dba3f5f
L0dba3e7c:
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
   mov AX,[ES:BX+13]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,[BP-02]
   dec AX
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
jmp near L0dba3f5f
L0dba3ee4:
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
   mov AX,[ES:BX+13]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   push SI
   call far _killobj
   pop CX
L0dba3f5f:
   mov AX,0001
jmp near L0dba3fe5
L0dba3f65:
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
L0dba3fe5:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 11b8 ;; JOBJ2.C:JOBJ2
_msg_token: ;; 11b8000b
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+0A]
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b8002d
   cmp AX,0001
   jnz L11b80025
jmp near L11b800d5
L11b80025:
   cmp AX,0002
   jz L11b80083
jmp near L11b80217
L11b8002d:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b80217
L11b80083:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+06
   jnz L11b800d0
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
jmp near L11b80217
L11b800d0:
   xor AX,AX
jmp near L11b80217
L11b800d5:
   or DI,DI
   jz L11b800dc
jmp near L11b801cf
L11b800dc:
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
   jz L11b80114
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
jmp near L11b801c7
L11b80114:
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
   jz L11b80174
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
L11b80174:
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
   jnz L11b801a7
   mov AX,0006
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jnz L11b801c7
L11b801a7:
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
L11b801c7:
   or word ptr [offset _statmodflg],C000
jmp near L11b80215
L11b801cf:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],44
   jz L11b801f9
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],07
   jnz L11b80215
L11b801f9:
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
L11b80215:
jmp near L11b80217
L11b80217:
   pop DI
   pop SI
   pop BP
ret far

_msg_fire: ;; 11b8021b
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b8023c
   cmp AX,0001
   jnz L11b80231
jmp near L11b80319
L11b80231:
   cmp AX,0002
   jnz L11b80239
jmp near L11b802c0
L11b80239:
jmp near L11b80363
L11b8023c:
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
   jle L11b802a2
   mov AX,0001
jmp near L11b802a4
L11b802a2:
   xor AX,AX
L11b802a4:
   mov DX,0006
   mul DX
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b80363
L11b802c0:
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
   jge L11b802f2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jge L11b802f9
L11b802f2:
   push SI
   call far _killobj
   pop CX
L11b802f9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L11b80315
   mov AX,0001
jmp near L11b80317
L11b80315:
   xor AX,AX
L11b80317:
jmp near L11b80363
L11b80319:
   cmp word ptr [BP+0A],+00
   jnz L11b80361
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jz L11b80361
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
L11b80361:
jmp near L11b80363
L11b80363:
   pop SI
   pop BP
ret far

_msg_switch: ;; 11b80366
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jnz L11b80377
jmp near L11b80511
L11b80377:
   cmp AX,0001
   jz L11b80387
   cmp AX,0002
   jnz L11b80384
jmp near L11b80566
L11b80384:
jmp near L11b8056a
L11b80387:
   cmp word ptr [BP+0A],+00
   jz L11b80390
jmp near L11b8050c
L11b80390:
   cmp word ptr [offset _dy1],+00
   jz L11b803ad
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L11b803ad:
   cmp word ptr [offset _first_switch],+00
   jz L11b803cb
   mov word ptr [offset _first_switch],0000
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y24dc12a7
   push AX
   call far _putbotmsg
   add SP,+06
L11b803cb:
   cmp word ptr [offset _dy1],+00
   jl L11b803d5
jmp near L11b8046d
L11b803d5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jz L11b803ee
jmp near L11b8046d
L11b803ee:
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
   jnz L11b8044a
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
jmp near L11b8046a
L11b8044a:
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
L11b8046a:
jmp near L11b8050c
L11b8046d:
   cmp word ptr [offset _dy1],+00
   jg L11b80477
jmp near L11b8050c
L11b80477:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11b80490
jmp near L11b8050c
L11b80490:
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
   jnz L11b804ec
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
jmp near L11b8050c
L11b804ec:
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
L11b8050c:
   mov AX,0001
jmp near L11b8056a
L11b80511:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b8056a
L11b80566:
   xor AX,AX
jmp near L11b8056a
L11b8056a:
   pop SI
   pop BP
ret far

_msg_gem: ;; 11b8056d
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b8058b
   cmp AX,0001
   jnz L11b80583
jmp near L11b80636
L11b80583:
   cmp AX,0002
   jz L11b805ec
jmp near L11b806ae
L11b8058b:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b806ae
L11b805ec:
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
jmp near L11b806ae
L11b80636:
   cmp word ptr [BP+0A],+00
   jnz L11b806ac
   cmp word ptr [offset _first_touchgem],+00
   jz L11b8065a
   mov word ptr [offset _first_touchgem],0000
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y24dc12c6
   push AX
   call far _putbotmsg
   add SP,+06
L11b8065a:
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
L11b806ac:
jmp near L11b806ae
L11b806ae:
   pop SI
   pop BP
ret far

_msg_boulder: ;; 11b806b1
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b806cc
   cmp AX,0001
   jz L11b8071c
   cmp AX,0002
   jz L11b8072c
jmp near L11b809e8
L11b806cc:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b809e8
L11b8071c:
   cmp word ptr [BP+0A],+00
   jnz L11b80729
   push SI
   call far _hitplayer
   pop CX
L11b80729:
jmp near L11b809e8
L11b8072c:
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
   jz L11b80769
jmp near L11b80865
L11b80769:
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
   jle L11b8079b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11b8079b:
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
   jz L11b80862
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
L11b80862:
jmp near L11b809e3
L11b80865:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jz L11b8088a
   mov AX,002D
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L11b8088a:
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
   jnz L11b8090c
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
L11b8090c:
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
   jle L11b8093b
   mov AX,0001
jmp near L11b8093e
L11b8093b:
   mov AX,FFFF
L11b8093e:
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
   jz L11b809e3
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
L11b809e3:
   mov AX,0001
jmp near L11b809e8
L11b809e8:
   pop SI
   pop BP
ret far

_explode2: ;; 11b809eb
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

_explode1: ;; 11b80a63
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L11b80aeb
L11b80a6c:
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
L11b80aeb:
   cmp SI,[BP+0A]
   jge L11b80af3
jmp near L11b80a6c
L11b80af3:
   pop SI
   pop BP
ret far

_msg_expl1: ;; 11b80af6
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b80b0c
   cmp AX,0002
   jz L11b80b87
jmp near L11b80c49
L11b80b0c:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b80c49
L11b80b87:
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
   jge L11b80bae
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11b80bb8
L11b80bae:
   push SI
   call far _killobj
   pop CX
jmp near L11b80c44
L11b80bb8:
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
   jle L11b80be9
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11b80be9:
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
L11b80c44:
   mov AX,0001
jmp near L11b80c49
L11b80c49:
   pop SI
   pop BP
ret far

_msg_expl2: ;; 11b80c4c
   push BP
   mov BP,SP
   sub SP,+12
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-12]
   push AX
   push DS
   mov AX,offset Y24dc10ee
   push AX
   mov CX,0012
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11b80c77
   cmp AX,0002
   jz L11b80cd7
jmp near L11b80d0a
L11b80c77:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b80d0a
L11b80cd7:
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
   jge L11b80cfe
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11b80d05
L11b80cfe:
   push SI
   call far _killobj
   pop CX
L11b80d05:
   mov AX,0001
jmp near L11b80d0a
L11b80d0a:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_stalag: ;; 11b80d0f
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   cmp AX,0005
   jbe L11b80d21
jmp near L11b80e83
L11b80d21:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y11b80d2a]

Y11b80d2a:	dw L11b80d36,L11b80d73,L11b80d8b,L11b80e3e,L11b80e83,L11b80e3e

L11b80d36:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b80e83
L11b80d73:
   cmp word ptr [BP+0A],+00
   jnz L11b80d88
   mov AX,0002
   push AX
   mov AX,0002
   push AX
   call far _p_ouch
   pop CX
   pop CX
L11b80d88:
jmp near L11b80e83
L11b80d8b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11b80da4
jmp near L11b80e3a
L11b80da4:
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
   jnz L11b80e03
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
L11b80e03:
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
   jle L11b80e35
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0010
L11b80e35:
   mov AX,0001
jmp near L11b80e83
L11b80e3a:
   xor AX,AX
jmp near L11b80e83
L11b80e3e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11b80e78
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
L11b80e78:
   push [BP+0A]
   call far _killobj
   pop CX
jmp near L11b80e83
L11b80e83:
   pop SI
   pop BP
ret far

_msg_snake: ;; 11b80e86
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
   mov AX,offset Y24dc1100
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-12]
   push AX
   push DS
   mov AX,offset Y24dc1108
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-0A]
   push AX
   push DS
   mov AX,offset Y24dc1110
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[offset _kindtable+2*27]
   mov CL,08
   shl AX,CL
   mov [BP-02],AX
   mov AX,[BP+08]
   or AX,AX
   jz L11b80eeb
   cmp AX,0001
   jnz L11b80ee0
jmp near L11b8126d
L11b80ee0:
   cmp AX,0002
   jnz L11b80ee8
jmp near L11b811c5
L11b80ee8:
jmp near L11b81316
L11b80eeb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jg L11b80f04
jmp near L11b81061
L11b80f04:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
   mov DI,0001
jmp near L11b80fe0
L11b80f79:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
   inc DI
L11b80fe0:
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
   jl L11b81003
jmp near L11b80f79
L11b81003:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b811c2
L11b81061:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
   mov DI,0001
jmp near L11b81128
L11b810c0:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
   inc DI
L11b81128:
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
   jl L11b8114b
jmp near L11b810c0
L11b8114b:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
L11b811c2:
jmp near L11b81316
L11b811c5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11b811ee
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L11b811ee:
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
   jnz L11b81267
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
L11b81267:
   mov AX,0001
jmp near L11b81316
L11b8126d:
   cmp word ptr [BP+0A],+00
   jnz L11b81280
   push SI
   call far _hitplayer
   pop CX
   mov AX,0001
jmp near L11b81316
L11b81280:
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
   jz L11b81314
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11b81314
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
   jge L11b81305
   push SI
   call far _playerkill
   pop CX
jmp near L11b81314
L11b81305:
   mov AX,001F
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L11b81314:
jmp near L11b81316
L11b81316:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_boll: ;; 11b8131c
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
   mov AX,offset Y24dc1118
   push AX
   mov CX,000C
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11b81368
   cmp AX,0001
   jz L11b813be
   cmp AX,0002
   jz L11b813ce
jmp near L11b8170f
L11b81368:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b8170f
L11b813be:
   cmp word ptr [BP+0A],+00
   jnz L11b813cb
   push SI
   call far _hitplayer
   pop CX
L11b813cb:
jmp near L11b8170f
L11b813ce:
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
jmp near L11b814af
L11b81440:
   mov BX,DI
   shl BX,1
   mov AX,[BX+offset _scrnobjs]
   mov [BP-18],AX
   mov AX,[BP-18]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],29
   jnz L11b814ae
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
   jle L11b814ae
   push [BP-18]
   push SI
   call far _vectdist
   pop CX
   pop CX
   mov [BP-12],AX
   mov AX,[BP-12]
   cmp AX,[BP-14]
   jge L11b814ae
   mov AX,[BP-18]
   mov [BP-16],AX
   mov AX,[BP-12]
   mov [BP-14],AX
L11b814ae:
   inc DI
L11b814af:
   cmp DI,[offset _numscrnobjs]
   jl L11b81440
   cmp word ptr [BP-16],+00
   jl L11b814d5
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
L11b814d5:
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
   jle L11b81518
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],000C
L11b81518:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],-0C
   jge L11b81543
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],FFF4
L11b81543:
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
   jle L11b81586
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11b81586:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-0C
   jge L11b815b1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
L11b815b1:
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
   jnz L11b81624
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
L11b81624:
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
   jz L11b81670
jmp near L11b8170a
L11b81670:
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
   jnz L11b8170a
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
L11b8170a:
   mov AX,0001
jmp near L11b8170f
L11b8170f:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_mega: ;; 11b81715
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b81733
   cmp AX,0002
   jz L11b81789
   cmp AX,0003
   jnz L11b81730
jmp near L11b8188c
L11b81730:
jmp near L11b818a6
L11b81733:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b818a6
L11b81789:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11b817a4
   xor AX,AX
jmp near L11b818a6
L11b817a4:
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
   jle L11b817e3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0010
L11b817e3:
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
   jz L11b81831
   mov AX,0001
jmp near L11b818a6
L11b81831:
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
   jnz L11b81878
   xor AX,AX
jmp near L11b818a6
L11b81878:
   mov AX,001C
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
   mov AX,0001
jmp near L11b818a6
L11b8188c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,0001
jmp near L11b818a6
L11b818a6:
   pop SI
   pop BP
ret far

_msg_bat: ;; 11b818a9
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
   mov AX,offset Y24dc1124
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,offset Y24dc112c
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11b81903
   cmp AX,0001
   jnz L11b818f8
jmp near L11b819d9
L11b818f8:
   cmp AX,0002
   jnz L11b81900
jmp near L11b819e9
L11b81900:
jmp near L11b81c69
L11b81903:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11b81923
   mov word ptr [BP-14],0006
   mov DI,0002
jmp near L11b81996
L11b81923:
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
   jge L11b81989
   mov AX,0001
jmp near L11b8198b
L11b81989:
   xor AX,AX
L11b8198b:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   add [BP-16],DX
L11b81996:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b81c69
L11b819d9:
   cmp word ptr [BP+0A],+00
   jnz L11b819e6
   push SI
   call far _hitplayer
   pop CX
L11b819e6:
jmp near L11b81c69
L11b819e9:
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
   jnz L11b81a95
   call far _rand
   mov BX,0028
   cwd
   idiv BX
   or DX,DX
   jz L11b81a3f
   xor AX,AX
jmp near L11b81c69
L11b81a3f:
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
jmp near L11b81c64
L11b81a95:
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
   cmp word ptr [BP-12],+01
   jnz L11b81b6e
   call far _rand
   mov BX,0023
   cwd
   idiv BX
   or DX,DX
   jnz L11b81b32
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
L11b81b32:
   call far _rand
   mov BX,0014
   cwd
   idiv BX
   or DX,DX
   jnz L11b81b6b
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
L11b81b6b:
jmp near L11b81c64
L11b81b6e:
   cmp word ptr [BP-12],+02
   jnz L11b81ba1
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
jmp near L11b81c64
L11b81ba1:
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
   jnz L11b81c3a
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11b81c3a
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
jmp near L11b81c64
L11b81c3a:
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
L11b81c64:
   mov AX,0001
jmp near L11b81c69
L11b81c69:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_knight: ;; 11b81c6f
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
   mov AX,offset Y24dc1134
   push AX
   mov CX,0016
   call far SCOPY@
   push SS
   lea AX,[BP-16]
   push AX
   push DS
   mov AX,offset Y24dc114a
   push AX
   mov CX,0016
   call far SCOPY@
   mov AX,[BP+08]
   cmp AX,0005
   jbe L11b81cb1
jmp near L11b81ec8
L11b81cb1:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y11b81cba]

Y11b81cba:	dw L11b81cc6,L11b81e4a,L11b81d3f,L11b81e02,L11b81e32,L11b81e1a

L11b81cc6:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b81ec8
L11b81d3f:
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
   jnz L11b81d7f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L11b81d7f:
   test word ptr [offset _gamecount],0001
   jz L11b81db1
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
   jnz L11b81db6
L11b81db1:
   xor AX,AX
jmp near L11b81ec8
L11b81db6:
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
   jl L11b81dfc
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
L11b81dfc:
   mov AX,0001
jmp near L11b81ec8
L11b81e02:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],000A
jmp near L11b81ec8
L11b81e1a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0006
jmp near L11b81ec8
L11b81e32:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
jmp near L11b81ec8
L11b81e4a:
   cmp word ptr [BP+0A],+00
   jnz L11b81e88
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L11b81e88
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
jmp near L11b81ec6
L11b81e88:
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
   jz L11b81ec6
   cmp word ptr [offset _first_hitknight],+00
   jz L11b81ec6
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y24dc12e8
   push AX
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _first_hitknight],0000
L11b81ec6:
jmp near L11b81ec8
L11b81ec8:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_beenest: ;; 11b81ece
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
   jz L11b81ef8
   cmp AX,0001
   jnz L11b81eed
jmp near L11b81f81
L11b81eed:
   cmp AX,0002
   jnz L11b81ef5
jmp near L11b8201d
L11b81ef5:
jmp near L11b82120
L11b81ef8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+01
   jnz L11b81f11
   inc DI
jmp near L11b81f47
L11b81f11:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+02
   jnz L11b81f47
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11b81f42
   mov AX,0003
jmp near L11b81f45
L11b81f42:
   mov AX,0002
L11b81f45:
   add DI,AX
L11b81f47:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b82120
L11b81f81:
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
   jz L11b8201a
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
L11b8201a:
jmp near L11b82120
L11b8201d:
   mov AX,[offset _gamecount]
   and AX,0003
   cmp AX,0002
   jz L11b8202b
jmp near L11b8211b
L11b8202b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jnz L11b8209a
   call far _rand
   mov BX,0020
   cwd
   idiv BX
   or DX,DX
   jnz L11b82092
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
jmp near L11b82097
L11b82092:
   xor AX,AX
jmp near L11b82120
L11b82097:
jmp near L11b8211b
L11b8209a:
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
   jle L11b8211b
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
L11b8211b:
   mov AX,0001
jmp near L11b82120
L11b82120:
   pop DI
   pop SI
   pop BP
ret far

_msg_beeswarm: ;; 11b82124
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
   mov AX,offset Y24dc1160
   push AX
   mov CX,0040
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11b82163
   cmp AX,0001
   jnz L11b82158
jmp near L11b821d6
L11b82158:
   cmp AX,0002
   jnz L11b82160
jmp near L11b821e6
L11b82160:
jmp near L11b823a8
L11b82163:
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
   jle L11b82192
   mov AX,0003
jmp near L11b82194
L11b82192:
   xor AX,AX
L11b82194:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b823a8
L11b821d6:
   cmp word ptr [BP+0A],+00
   jnz L11b821e3
   push SI
   call far _hitplayer
   pop CX
L11b821e3:
jmp near L11b823a8
L11b821e6:
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
   jle L11b8221d
   push SI
   call far _killobj
   pop CX
   mov AX,0001
jmp near L11b823a8
L11b8221d:
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
   jle L11b8224e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L11b8224e:
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
   mov AX,0001
jmp near L11b823a8
L11b823a8:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_crab: ;; 11b823ae
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
   jz L11b823d2
   cmp AX,0001
   jz L11b82421
   cmp AX,0002
   jz L11b82431
jmp near L11b82756
L11b823d2:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b82756
L11b82421:
   cmp word ptr [BP+0A],+00
   jnz L11b8242e
   push SI
   call far _hitplayer
   pop CX
L11b8242e:
jmp near L11b82756
L11b82431:
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
   jz L11b82476
jmp near L11b8258a
L11b82476:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L11b824b5
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
L11b824b5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jnz L11b82527
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
   jnz L11b82527
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   or DX,DX
   jnz L11b82527
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L11b82527:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11b8258a
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
   jnz L11b8258a
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
L11b8258a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jz L11b825a3
jmp near L11b82751
L11b825a3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11b825e0
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
L11b825e0:
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
   jnz L11b82698
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
L11b82698:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jz L11b826b2
jmp near L11b82751
L11b826b2:
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
   jz L11b826ec
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
jmp near L11b82751
L11b826ec:
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
   jz L11b82751
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
L11b82751:
   mov AX,0001
jmp near L11b82756
L11b82756:
   pop DI
   pop SI
   pop BP
ret far

_msg_croc: ;; 11b8275a
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
   mov AX,offset Y24dc11a0
   push AX
   mov CX,0008
   call far SCOPY@
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,offset Y24dc11a8
   push AX
   mov CX,0008
   call far SCOPY@
   mov DI,[offset _kindtable+2*30]
   mov CL,08
   shl DI,CL
   mov AX,[BP+08]
   or AX,AX
   jz L11b827ab
   cmp AX,0001
   jnz L11b827a0
jmp near L11b829d8
L11b827a0:
   cmp AX,0002
   jnz L11b827a8
jmp near L11b82930
L11b827a8:
jmp near L11b82aaf
L11b827ab:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jg L11b827c4
jmp near L11b82877
L11b827c4:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b8292d
L11b82877:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
L11b8292d:
jmp near L11b82aaf
L11b82930:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11b82959
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L11b82959:
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
   jnz L11b829d2
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
L11b829d2:
   mov AX,0001
jmp near L11b82aaf
L11b829d8:
   cmp word ptr [BP+0A],+00
   jnz L11b829eb
   push SI
   call far _hitplayer
   pop CX
   mov AX,0001
jmp near L11b82aaf
L11b829eb:
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
   jnz L11b82a18
jmp near L11b82aad
L11b82a18:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11b82a31
jmp near L11b82aad
L11b82a31:
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
   jle L11b82aa6
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
jmp near L11b82aad
L11b82aa6:
   push SI
   call far _playerkill
   pop CX
L11b82aad:
jmp near L11b82aaf
L11b82aaf:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_epic: ;; 11b82ab5
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b82ad0
   cmp AX,0001
   jz L11b82b21
   cmp AX,0002
   jz L11b82b1b
jmp near L11b82bd2
L11b82ad0:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b82bd2
L11b82b1b:
   mov AX,0001
jmp near L11b82bd2
L11b82b21:
   cmp word ptr [BP+0A],+00
   jz L11b82b2a
jmp near L11b82bd0
L11b82b2a:
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
   jle L11b82bc1
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
jmp near L11b82bd0
L11b82bc1:
   mov AX,0020
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L11b82bd0:
jmp near L11b82bd2
L11b82bd2:
   pop SI
   pop BP
ret far

_msg_spinblad: ;; 11b82bd5
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
   jz L11b82c01
   cmp AX,0001
   jz L11b82c57
   cmp AX,0002
   jnz L11b82bfe
jmp near L11b82cbe
L11b82bfe:
jmp near L11b830de
L11b82c01:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b830de
L11b82c57:
   cmp word ptr [BP+0A],+00
   jnz L11b82c7c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+07
   jle L11b82c7c
   push SI
   call far _killobj
   pop CX
jmp near L11b82cbb
L11b82c7c:
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
   jz L11b82cbb
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
L11b82cbb:
jmp near L11b830de
L11b82cbe:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11b82cd9
   mov AX,0001
jmp near L11b82cdb
L11b82cd9:
   xor AX,AX
L11b82cdb:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11b82cf7
   mov AX,0001
jmp near L11b82cf9
L11b82cf7:
   xor AX,AX
L11b82cf9:
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
   jge L11b82d50
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11b82d5d
L11b82d50:
   push SI
   call far _killobj
   pop CX
   mov AX,0001
jmp near L11b830de
L11b82d5d:
   mov word ptr [BP-0A],FFFF
   mov word ptr [BP-08],7FFF
   xor DI,DI
jmp near L11b82dc5
L11b82d6b:
   mov BX,DI
   shl BX,1
   mov AX,[BX+offset _scrnobjs]
   mov [BP-0C],AX
   mov AX,[BP-0C]
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
   jz L11b82dc4
   cmp word ptr [BP-0C],+00
   jz L11b82dc4
   push [BP-0C]
   push SI
   call far _vectdist
   pop CX
   pop CX
   mov [BP-06],AX
   mov AX,[BP-06]
   cmp AX,[BP-08]
   jge L11b82dc4
   cmp word ptr [BP-06],+60
   jge L11b82dc4
   mov AX,[BP-0C]
   mov [BP-0A],AX
   mov AX,[BP-06]
   mov [BP-08],AX
L11b82dc4:
   inc DI
L11b82dc5:
   cmp DI,[offset _numscrnobjs]
   jl L11b82d6b
   cmp word ptr [BP-0A],+00
   jl L11b82deb
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
L11b82deb:
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
   jle L11b82e33
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],000C
L11b82e33:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],-0C
   jge L11b82e5e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],FFF4
L11b82e5e:
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
   jle L11b82ea1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11b82ea1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-0C
   jge L11b82ecc
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
L11b82ecc:
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
   jnz L11b82fb4
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
L11b82fb4:
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
   jnz L11b8309f
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
   jz L11b83075
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
   jnz L11b8309f
L11b83075:
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
L11b8309f:
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
   jnz L11b830d9
   push SI
   call far _killobj
   pop CX
L11b830d9:
   mov AX,0001
jmp near L11b830de
L11b830de:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_skull: ;; 11b830e4
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
   mov AX,offset Y24dc11b0
   push AX
   mov CX,0010
   call far SCOPY@
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,offset Y24dc11c0
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11b83135
   cmp AX,0002
   jnz L11b8312a
jmp near L11b83272
L11b8312a:
   cmp AX,0003
   jnz L11b83132
jmp near L11b832be
L11b83132:
jmp near L11b83316
L11b83135:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   jnz L11b831b0
jmp near L11b8326f
L11b831b0:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
L11b8326f:
jmp near L11b83316
L11b83272:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11b8328d
   xor AX,AX
jmp near L11b83316
L11b8328d:
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
   mov AX,0001
jmp near L11b83316
L11b832be:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11b83312
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
   mov AX,0001
jmp near L11b83316
L11b83312:
   xor AX,AX
jmp near L11b83316
L11b83316:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_button: ;; 11b8331c
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b8333d
   cmp AX,0001
   jnz L11b83332
jmp near L11b833b7
L11b83332:
   cmp AX,0002
   jnz L11b8333a
jmp near L11b8348d
L11b8333a:
jmp near L11b834ba
L11b8333d:
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
   jle L11b8339c
   mov AX,0001
jmp near L11b8339e
L11b8339c:
   xor AX,AX
L11b8339e:
   shl AX,1
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b834ba
L11b833b7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jz L11b833d0
jmp near L11b83473
L11b833d0:
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
   jnz L11b83444
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
   mov AX,002C
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L11b83473
L11b83444:
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
   mov AX,002C
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L11b83473:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0003
   mov AX,0001
jmp near L11b834ba
L11b8348d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L11b834b6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0F]
L11b834b6:
   xor AX,AX
jmp near L11b834ba
L11b834ba:
   pop SI
   pop BP
ret far

_msg_pac: ;; 11b834bd
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
   jz L11b83518
   cmp AX,0001
   jz L11b834e9
   cmp AX,0002
   jnz L11b834e6
jmp near L11b835a5
L11b834e6:
jmp near L11b838e9
L11b834e9:
   cmp word ptr [BP+0A],+00
   jnz L11b834f8
   push SI
   call far _hitplayer
   pop CX
jmp near L11b83515
L11b834f8:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],3E
   jnz L11b83515
   push SI
   call far _killobj
   pop CX
L11b83515:
jmp near L11b838e9
L11b83518:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11b83533
   inc word ptr [BP-0C]
jmp near L11b83569
L11b83533:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L11b8354f
   add word ptr [BP-0C],+03
jmp near L11b83569
L11b8354f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11b83569
   add word ptr [BP-0C],+02
L11b83569:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b838e9
L11b835a5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jz L11b835bf
jmp near L11b83889
L11b835bf:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jz L11b835d9
jmp near L11b83889
L11b835d9:
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
   mov AX,[BP-06]
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
   jle L11b83649
   mov DI,0001
jmp near L11b8364b
L11b83649:
   xor DI,DI
L11b8364b:
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11b83667
   mov AX,0001
jmp near L11b83669
L11b83667:
   xor AX,AX
L11b83669:
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
   jle L11b83687
   mov AX,0001
jmp near L11b83689
L11b83687:
   xor AX,AX
L11b83689:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11b836a5
   mov AX,0001
jmp near L11b836a7
L11b836a5:
   xor AX,AX
L11b836a7:
   pop DX
   sub DX,AX
   mov [BP-04],DX
   or DI,DI
   jnz L11b836d0
   cmp word ptr [BP-04],+00
   jnz L11b836d0
   call far _rand
   mov BX,0002
   cwd
   idiv BX
   or DX,DX
   jnz L11b836cb
   mov DI,0001
jmp near L11b836d0
L11b836cb:
   mov word ptr [BP-04],0001
L11b836d0:
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
   jnz L11b836f7
jmp near L11b83834
L11b836f7:
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
   mov DI,[BP-04]
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
   jnz L11b8374b
jmp near L11b83834
L11b8374b:
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
   jnz L11b83786
jmp near L11b83834
L11b83786:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11b837a1
   mov DI,0001
jmp near L11b837a3
L11b837a1:
   xor DI,DI
L11b837a3:
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11b837bf
   mov AX,0001
jmp near L11b837c1
L11b837bf:
   xor AX,AX
L11b837c1:
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
   jle L11b837e1
   mov AX,0001
jmp near L11b837e3
L11b837e1:
   xor AX,AX
L11b837e3:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11b837ff
   mov AX,0001
jmp near L11b83801
L11b837ff:
   xor AX,AX
L11b83801:
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
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0A]
   jz L11b83834
   xor DI,DI
   mov word ptr [BP-04],0000
L11b83834:
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
L11b83889:
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
jmp near L11b838e9
L11b838e9:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_bubble: ;; 11b838ef
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b83905
   cmp AX,0002
   jz L11b8395e
jmp near L11b83a0f
L11b83905:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b83a0f
L11b8395e:
   call far _rand
   mov BX,000F
   cwd
   idiv BX
   or DX,DX
   jnz L11b83980
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
L11b83980:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+02
   jg L11b839a1
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11b839aa
L11b839a1:
   push SI
   call far _killobj
   pop CX
jmp near L11b83a0a
L11b839aa:
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
   jnz L11b83a0a
   push SI
   call far _killobj
   pop CX
L11b83a0a:
   mov AX,0001
jmp near L11b83a0f
L11b83a0f:
   pop SI
   pop BP
ret far

_msg_jellyfish: ;; 11b83a12
   push BP
   mov BP,SP
   sub SP,+14
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-14]
   push AX
   push DS
   mov AX,offset Y24dc11c8
   push AX
   mov CX,0014
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11b83a45
   cmp AX,0001
   jnz L11b83a3d
jmp near L11b83d50
L11b83a3d:
   cmp AX,0002
   jz L11b83aa6
jmp near L11b83db9
L11b83a45:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b83db9
L11b83aa6:
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
   jl L11b83ad7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L11b83ad7:
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
   jge L11b83b08
   mov DX,0001
jmp near L11b83b0a
L11b83b08:
   xor DX,DX
L11b83b0a:
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
   jle L11b83b3e
   mov AX,0006
jmp near L11b83b51
L11b83b3e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
L11b83b51:
   cmp AX,FFFA
   jge L11b83b5b
   mov AX,FFFA
jmp near L11b83b89
L11b83b5b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+06
   jle L11b83b76
   mov AX,0006
jmp near L11b83b89
L11b83b76:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
L11b83b89:
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
   jge L11b83bc8
   mov AX,0001
jmp near L11b83bca
L11b83bc8:
   xor AX,AX
L11b83bca:
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
   jle L11b83c05
   mov AX,0006
jmp near L11b83c18
L11b83c05:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
L11b83c18:
   cmp AX,FFFA
   jge L11b83c22
   mov AX,FFFA
jmp near L11b83c50
L11b83c22:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+06
   jle L11b83c3d
   mov AX,0006
jmp near L11b83c50
L11b83c3d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
L11b83c50:
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
   jnz L11b83cd8
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
L11b83cd8:
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
   jnz L11b83d4b
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
L11b83d4b:
   mov AX,0001
jmp near L11b83db9
L11b83d50:
   cmp word ptr [BP+0A],+00
   jnz L11b83d5f
   push SI
   call far _hitplayer
   pop CX
jmp near L11b83db7
L11b83d5f:
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
   jz L11b83db7
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
L11b83db7:
jmp near L11b83db9
L11b83db9:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_badfish: ;; 11b83dbe
   push BP
   mov BP,SP
   sub SP,+08
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,offset Y24dc11dc
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11b83df4
   cmp AX,0001
   jnz L11b83de9
jmp near L11b84066
L11b83de9:
   cmp AX,0002
   jnz L11b83df1
jmp near L11b83e82
L11b83df1:
jmp near L11b8409e
L11b83df4:
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
   jle L11b83e61
   mov AX,0001
jmp near L11b83e63
L11b83e61:
   xor AX,AX
L11b83e63:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   add DX,+0F
   push DX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b8409e
L11b83e82:
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
   jz L11b83ea7
jmp near L11b83f32
L11b83ea7:
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
   jnz L11b83f0d
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
jmp near L11b83f32
L11b83f0d:
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
L11b83f32:
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
   jnz L11b83fa5
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
L11b83fa5:
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
   jnz L11b84018
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
L11b84018:
   call far _rand
   mov BX,0004
   cwd
   idiv BX
   or DX,DX
   jnz L11b84061
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
L11b84061:
   mov AX,0001
jmp near L11b8409e
L11b84066:
   cmp word ptr [BP+0A],+00
   jnz L11b84075
   push SI
   call far _hitplayer
   pop CX
jmp near L11b8409c
L11b84075:
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
   jz L11b8409c
   push SI
   call far _playerkill
   pop CX
L11b8409c:
jmp near L11b8409e
L11b8409e:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_elev: ;; 11b840a3
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
   jnz L11b840e9
jmp near L11b843e6
L11b840e9:
   cmp AX,0001
   jz L11b840f9
   cmp AX,0002
   jnz L11b840f6
jmp near L11b842fb
L11b840f6:
jmp near L11b84422
L11b840f9:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],00
   jz L11b84112
jmp near L11b842f5
L11b84112:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0006
   cmp word ptr [offset _first_elev],+00
   jz L11b84145
   mov word ptr [offset _first_elev],0000
   mov AX,0002
   push AX
   push DS
   mov AX,offset Y24dc1303
   push AX
   call far _putbotmsg
   add SP,+06
L11b84145:
   cmp word ptr [offset _dy1],+00
   jl L11b8414f
jmp near L11b841f8
L11b8414f:
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
   jz L11b8418d
   mov AX,001D
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L11b8418d:
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
   jz L11b841f5
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
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C08A
L11b841f5:
jmp near L11b842dd
L11b841f8:
   cmp word ptr [offset _dy1],+00
   jg L11b84202
jmp near L11b842dd
L11b84202:
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
   jz L11b84240
   mov AX,001E
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L11b84240:
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
   jnz L11b842dd
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
   or AX,C000
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,DI
   inc AX
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
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
L11b842dd:
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
L11b842f5:
   mov AX,0001
jmp near L11b84422
L11b842fb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11b84324
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L11b84324:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11b8433d
jmp near L11b843e2
L11b8433d:
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
   jz L11b8435f
jmp near L11b843e2
L11b8435f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],-01
   jz L11b843e2
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
   or AX,C000
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,DI
   inc AX
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
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
   mov AX,0001
jmp near L11b84422
L11b843e2:
   xor AX,AX
jmp near L11b84422
L11b843e6:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b84422
L11b84422:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_firebullet: ;; 11b84428
   push BP
   mov BP,SP
   sub SP,+28
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-28]
   push AX
   push DS
   mov AX,offset Y24dc11e4
   push AX
   mov CX,0028
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11b8445b
   cmp AX,0001
   jnz L11b84453
jmp near L11b8465f
L11b84453:
   cmp AX,0002
   jz L11b844b1
jmp near L11b846a3
L11b8445b:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b846a3
L11b844b1:
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11b844c9
   push SI
   call far _killobj
   pop CX
   mov AX,0001
jmp near L11b846a3
L11b844c9:
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
   jl L11b84526
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
L11b84526:
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
   jnz L11b84637
   push SI
   call far _killobj
   pop CX
jmp near L11b8465a
L11b84637:
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
   jl L11b8465a
   push SI
   call far _killobj
   pop CX
L11b8465a:
   mov AX,0001
jmp near L11b846a3
L11b8465f:
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
   jz L11b8469e
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
L11b8469e:
   mov AX,0001
jmp near L11b846a3
L11b846a3:
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_fishbullet: ;; 11b846a8
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b846be
   cmp AX,0002
   jz L11b84722
jmp near L11b8478d
L11b846be:
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
   jle L11b84707
   mov AX,0001
jmp near L11b84709
L11b84707:
   xor AX,AX
L11b84709:
   pop DX
   add DX,AX
   add DX,+15
   push DX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b8478d
L11b84722:
   push SI
   call far _onscreen
   pop CX
   or AX,AX
   jnz L11b84738
   push SI
   call far _killobj
   pop CX
   xor AX,AX
jmp near L11b8478d
L11b84738:
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
   jnz L11b84788
   push SI
   call far _killobj
   pop CX
L11b84788:
   mov AX,0001
jmp near L11b8478d
L11b8478d:
   pop SI
   pop BP
ret far

_msg_searock: ;; 11b84790
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b847a6
   cmp AX,0002
   jz L11b847e9
jmp near L11b8483a
L11b847a6:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b8483a
L11b847e9:
   call far _rand
   mov BX,000C
   cwd
   idiv BX
   or DX,DX
   jnz L11b84836
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
jmp near L11b8483a
L11b84836:
   xor AX,AX
jmp near L11b8483a
L11b8483a:
   pop SI
   pop BP
ret far

_msg_eyes: ;; 11b8483d
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
   jz L11b84862
   cmp AX,0002
   jnz L11b8485f
jmp near L11b84908
L11b8485f:
jmp near L11b849ae
L11b84862:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b849ae
L11b84908:
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
   jle L11b8492f
   mov word ptr [BP-02],0001
jmp near L11b8493a
L11b8492f:
   mov AX,[BP-02]
   dec AX
   jz L11b8493a
   mov word ptr [BP-02],FFFF
L11b8493a:
   cmp word ptr [BP-04],-02
   jge L11b84945
   mov word ptr [BP-04],FFFE
L11b84945:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   cmp AX,[BP-04]
   jnz L11b84975
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
   cmp AX,[BP-02]
   jz L11b849aa
L11b84975:
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
jmp near L11b849ae
L11b849aa:
   xor AX,AX
jmp near L11b849ae
L11b849ae:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_vineclimb: ;; 11b849b4
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b849d3
   cmp AX,0001
   jz L11b84a31
   cmp AX,0002
   jnz L11b849d0
jmp near L11b84a8f
L11b849d0:
jmp near L11b84ba9
L11b849d3:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b84ba9
L11b84a31:
   cmp word ptr [BP+0A],+00
   jnz L11b84a8c
   mov BX,[offset _objs+0D]
   shl BX,1
   test word ptr [BX+offset _stateinfo],0002
   jnz L11b84a85
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
   jnz L11b84a79
   push [offset _objs+03]
   mov AX,[offset _objs+01]
   add AX,0008
   push AX
   xor AX,AX
   push AX
   call far _justmove
   add SP,+06
   mov DI,AX
L11b84a79:
   mov word ptr [offset _objs+0D],0000
   mov word ptr [offset _objs+0F],0000
L11b84a85:
   push SI
   call far _hitplayer
   pop CX
L11b84a8c:
jmp near L11b84ba9
L11b84a8f:
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
   jnz L11b84ae6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0002
L11b84ae6:
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
   jnz L11b84b7a
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
jmp near L11b84ba4
L11b84b7a:
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
L11b84ba4:
   mov AX,0001
jmp near L11b84ba9
L11b84ba9:
   pop DI
   pop SI
   pop BP
ret far

_msg_flag: ;; 11b84bad
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b84bcb
   cmp AX,0001
   jnz L11b84bc3
jmp near L11b84c7f
L11b84bc3:
   cmp AX,0002
   jz L11b84c2d
jmp near L11b84d2d
L11b84bcb:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L11b84d2d
L11b84c2d:
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
   jl L11b84c5e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L11b84c5e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L11b84c7a
   mov AX,0001
jmp near L11b84c7c
L11b84c7a:
   xor AX,AX
L11b84c7c:
jmp near L11b84d2d
L11b84c7f:
   cmp word ptr [BP+0A],+00
   jz L11b84c88
jmp near L11b84d28
L11b84c88:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11b84ca1
jmp near L11b84d28
L11b84ca1:
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
L11b84d28:
   mov AX,0001
jmp near L11b84d2d
L11b84d2d:
   pop SI
   pop BP
ret far

_msg_macrotrig: ;; 11b84d30
   push BP
   mov BP,SP
   mov AX,[BP+08]
   or AX,AX
   jz L11b84d41
   cmp AX,0001
   jz L11b84d43
jmp near L11b84d48
L11b84d41:
jmp near L11b84d48
L11b84d43:
   mov AX,0001
jmp near L11b84d48
L11b84d48:
   pop BP
ret far

_msg_txtmsg: ;; 11b84d4a
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11b84d65
   cmp AX,0001
   jz L11b84d93
   cmp AX,0002
   jz L11b84d68
jmp near L11b84df2
L11b84d65:
jmp near L11b84df2
L11b84d68:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11b84d91
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L11b84d91:
jmp near L11b84df2
L11b84d93:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11b84ddb
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
L11b84ddb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0008
jmp near L11b84df2
L11b84df2:
   pop SI
   pop BP
ret far

_msg_mapdemo: ;; 11b84df5
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
   mov AX,offset Y24dc120c
   push AX
   mov CX,0004
   call far SCOPY@
   push SS
   lea AX,[BP-04]
   push AX
   push DS
   mov AX,offset Y24dc1210
   push AX
   mov CX,0004
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L11b84e36
   cmp AX,0002
   jnz L11b84e33
jmp near L11b84ed7
L11b84e33:
jmp near L11b84f2b
L11b84e36:
   cmp byte ptr [offset _x_ourmode],00
   jnz L11b84e40
jmp near L11b84ed5
L11b84e40:
   xor DI,DI
jmp near L11b84eb1
L11b84e44:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
   inc DI
L11b84eb1:
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
   jle L11b84ed5
jmp near L11b84e44
L11b84ed5:
jmp near L11b84f2b
L11b84ed7:
   cmp word ptr [offset _designflag],+00
   jnz L11b84f26
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
L11b84f26:
   mov AX,0001
jmp near L11b84f2b
L11b84f2b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 16ab ;; JOBJ3.C:JOBJ3
_msg_block: ;; 16ab0001
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
   jnz L16ab004c
jmp near L16ab04a8
L16ab004c:
   cmp AX,0001
   jz L16ab005c
   cmp AX,0002
   jnz L16ab0059
jmp near L16ab010d
L16ab0059:
jmp near L16ab085e
L16ab005c:
   cmp SI,0186
   jl L16ab0083
   cmp SI,018B
   jg L16ab0083
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
jmp near L16ab010a
L16ab0083:
   cmp SI,0141
   jz L16ab00a1
   cmp SI,0142
   jz L16ab00a1
   cmp SI,0155
   jz L16ab00a1
   cmp SI,0156
   jz L16ab00a1
   cmp SI,00A6
   jnz L16ab00b2
L16ab00a1:
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   call far _p_ouch
   pop CX
   pop CX
jmp near L16ab010a
L16ab00b2:
   cmp SI,0190
   jl L16ab00dd
   cmp SI,0197
   jg L16ab00dd
   cmp byte ptr [offset _objs],39
   jz L16ab00db
   cmp byte ptr [offset _objs],36
   jz L16ab00db
   mov AX,0001
   push AX
   mov AX,0010
   push AX
   call far _p_ouch
   pop CX
   pop CX
L16ab00db:
jmp near L16ab010a
L16ab00dd:
   cmp SI,0198
   jl L16ab010a
   cmp SI,01A3
   jg L16ab010a
   mov AX,[offset _gamecount]
   sub AX,[offset _lastwater]
   cmp AX,000A
   jle L16ab0104
   mov AX,0004
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L16ab0104:
   mov AX,[offset _gamecount]
   mov [offset _lastwater],AX
L16ab010a:
jmp near L16ab085e
L16ab010d:
   cmp SI,0186
   jge L16ab0116
jmp near L16ab0199
L16ab0116:
   cmp SI,018A
   jle L16ab011f
jmp near L16ab0199
L16ab011f:
   cmp word ptr [BP-0A],+00
   jnz L16ab0199
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
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
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
   jle L16ab0190
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C186
L16ab0190:
   mov AX,0001
jmp near L16ab0862

X16ab0196:
jmp near L16ab04a5
L16ab0199:
   cmp SI,00BE
   jnz L16ab01b2
   cmp word ptr [BP-0A],+01
   jnz L16ab01aa
   mov AX,0001
jmp near L16ab01ac
L16ab01aa:
   xor AX,AX
L16ab01ac:
jmp near L16ab0862

X16ab01af:
jmp near L16ab04a5
L16ab01b2:
   cmp SI,+6E
   jnz L16ab01c6
   cmp word ptr [BP-0A],+03
   jnz L16ab01c6
   mov AX,0001
jmp near L16ab0862

X16ab01c3:
jmp near L16ab04a5
L16ab01c6:
   cmp SI,00A6
   jnz L16ab01db
   cmp word ptr [BP-0A],+01
   jnz L16ab01db
   mov AX,0001
jmp near L16ab0862

X16ab01d8:
jmp near L16ab04a5
L16ab01db:
   cmp SI,0081
   jnz L16ab0232
   mov AX,[offset _gamecount]
   and AX,0007
   cmp AX,0002
   jnz L16ab0232
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   sar AX,1
   and AX,000F
   mov [BP-0A],AX
   or word ptr [offset _info+8*81+02],0002
   mov BX,[BP-0A]
   shl BX,1
   mov AX,[BX+offset _blinkshtab]
   mov DX,[offset _info+8*81+00]
   and DX,FF00
   add AX,DX
   mov [offset _info+8*81+00],AX
   cmp word ptr [BP-0A],+08
   jl L16ab0223
   cmp word ptr [BP-0A],+0D
   jl L16ab0229
L16ab0223:
   xor word ptr [offset _info+8*81+02],0002
L16ab0229:
   mov AX,0001
jmp near L16ab0862

X16ab022f:
jmp near L16ab04a5
L16ab0232:
   cmp SI,015F
   jz L16ab0241
   cmp SI,0160
   jz L16ab0241
jmp near L16ab02e9
L16ab0241:
   cmp SI,0160
   jnz L16ab0254
   mov AX,[offset _gamecount]
   sub AX,DI
   and AX,001F
   mov [BP-04],AX
jmp near L16ab025f
L16ab0254:
   mov AX,[offset _gamecount]
   add AX,DI
   and AX,001F
   mov [BP-04],AX
L16ab025f:
   cmp word ptr [BP-04],+10
   jge L16ab026e
   mov AX,0001
jmp near L16ab0862

X16ab026b:
jmp near L16ab02e6
L16ab026e:
   cmp word ptr [BP-04],+10
   jnz L16ab02e6
   cmp SI,015F
   jnz L16ab02aa
   mov AX,[BP-06]
   sub AX,[offset _kindyl+2*1f]
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
   mov word ptr [ES:BX+07],FFFF
jmp near L16ab02d7
L16ab02aa:
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
L16ab02d7:
   mov AX,001A
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
L16ab02e6:
jmp near L16ab04a5
L16ab02e9:
   cmp SI,+21
   jnz L16ab0341
   mov AX,[offset _gamecount]
   and AX,003F
   mov DX,DI
   and DX,003F
   cmp AX,DX
   jnz L16ab0341
   mov AX,[BP-06]
   sub AX,[offset _kindyl+2*1f]
   add AX,0008
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
   mov word ptr [ES:BX+07],FFFF
   mov AX,001A
   push AX
   mov AX,0003
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L16ab04a5
L16ab0341:
   cmp SI,0190
   jge L16ab034a
jmp near L16ab048a
L16ab034a:
   cmp SI,01A5
   jle L16ab0353
jmp near L16ab048a
L16ab0353:
   test word ptr [BP-0A],0001
   jnz L16ab035d
jmp near L16ab048a
L16ab035d:
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
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
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
   jbe L16ab03b6
jmp near L16ab0482
L16ab03b6:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y16ab03bf]

Y16ab03bf:	dw L16ab03e5,L16ab0482,L16ab0482,L16ab0482,L16ab0400,L16ab0482,L16ab0482,L16ab0482
		dw L16ab041a,L16ab0482,L16ab0482,L16ab0482,L16ab0434,L16ab0482,L16ab0482,L16ab044e
		dw L16ab0482,L16ab0482,L16ab0468

L16ab03e5:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C190
jmp near L16ab0482
L16ab0400:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C194
jmp near L16ab0482
L16ab041a:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C198
jmp near L16ab0482
L16ab0434:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C19C
jmp near L16ab0482
L16ab044e:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C1A0
jmp near L16ab0482
L16ab0468:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C1A3
jmp near L16ab0482
L16ab0482:
   mov AX,0001
jmp near L16ab0862

X16ab0488:
jmp near L16ab04a5
L16ab048a:
   cmp SI,+14
   jl L16ab04a5
   cmp SI,+17
   jg L16ab04a5
   mov AX,[offset _gamecount]
   and AX,0007
   cmp AX,0002
   jnz L16ab04a5
   mov AX,0001
jmp near L16ab0862
L16ab04a5:
jmp near L16ab085e
L16ab04a8:
   cmp SI,015F
   jz L16ab04b4
   cmp SI,0160
   jnz L16ab051c
L16ab04b4:
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
   jnz L16ab04db
   mov AX,[offset _gamecount]
   sub AX,DI
   and AX,001F
   mov [BP-04],AX
jmp near L16ab04e6
L16ab04db:
   mov AX,[offset _gamecount]
   add AX,DI
   and AX,001F
   mov [BP-04],AX
L16ab04e6:
   cmp word ptr [BP-04],+10
   jge L16ab0500
   mov AX,[BP-04]
   mov BX,0004
   cwd
   idiv BX
   mov BX,AX
   shl BX,1
   mov AX,[BX+offset _pooftab]
   add [BP-02],AX
L16ab0500:
   push [BP-06]
   push [BP-08]
   push [BP-02]
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab051c:
   cmp SI,+64
   jl L16ab0594
   cmp SI,+66
   jg L16ab0594
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab0594:
   cmp SI,+67
   jl L16ab060c
   cmp SI,+69
   jg L16ab060c
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab060c:
   cmp SI,00BE
   jnz L16ab063a
   push [BP-06]
   push [BP-08]
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   and AX,0003
   add AX,[offset _info+8*BE+00]
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab063a:
   cmp SI,00A6
   jnz L16ab0668
   push [BP-06]
   push [BP-08]
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   and AX,0003
   add AX,[offset _info+8*A6+00]
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab0668:
   cmp SI,+6E
   jnz L16ab0695
   push [BP-06]
   push [BP-08]
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   and AX,0003
   add AX,[offset _info+8*6E+00]
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab0695:
   cmp SI,+2D
   jnz L16ab06c8
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab06c8:
   cmp SI,+14
   jge L16ab06d0
jmp near L16ab085c
L16ab06d0:
   cmp SI,+17
   jle L16ab06d8
jmp near L16ab085c
L16ab06d8:
   mov AX,[offset _gamecount]
   sar AX,1
   sar AX,1
   sar AX,1
   sub AX,[BP+08]
   mov BX,0003
   cwd
   idiv BX
   mov [BP-04],DX
   cmp word ptr [BP-04],+00
   jge L16ab06f7
   add word ptr [BP-04],+03
L16ab06f7:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
   mov word ptr [BP-04],0001
   mov word ptr [BP-02],0000
   mov AX,[BP+08]
   dec AX
   mov [BP-06],AX
jmp near L16ab077e
L16ab0735:
   mov AX,DI
   dec AX
   mov [BP-08],AX
jmp near L16ab0773
L16ab073d:
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
   jl L16ab0762
   cmp SI,+17
   jle L16ab0768
L16ab0762:
   mov AX,[BP-04]
   add [BP-02],AX
L16ab0768:
   mov AX,[BP-04]
   shl AX,1
   mov [BP-04],AX
   inc word ptr [BP-08]
L16ab0773:
   mov AX,DI
   inc AX
   cmp AX,[BP-08]
   jge L16ab073d
   inc word ptr [BP-06]
L16ab077e:
   mov AX,[BP+08]
   inc AX
   cmp AX,[BP-06]
   jge L16ab0735
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
   jnz L16ab07c2
   push [BP-06]
   push [BP-08]
   mov AX,2A05
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab07c2:
   mov AX,[BP-02]
   and AX,000A
   cmp AX,000A
   jnz L16ab07e9
   push [BP-06]
   push [BP-08]
   mov AX,2A01
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab07e9:
   mov AX,[BP-02]
   and AX,0022
   cmp AX,0022
   jnz L16ab0810
   push [BP-06]
   push [BP-08]
   mov AX,2A02
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab0810:
   mov AX,[BP-02]
   and AX,0088
   cmp AX,0088
   jnz L16ab0837
   push [BP-06]
   push [BP-08]
   mov AX,2A03
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L16ab085c
L16ab0837:
   mov AX,[BP-02]
   and AX,00A0
   cmp AX,00A0
   jnz L16ab085c
   push [BP-06]
   push [BP-08]
   mov AX,2A04
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
L16ab085c:
jmp near L16ab085e
L16ab085e:
   xor AX,AX
jmp near L16ab0862
L16ab0862:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1731 ;; JPLAYER.C:JPLAYER
_calc_scroll: ;; 17310008
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov SI,0008
   cmp word ptr [offset _objs+09],+04
   jnz L1731002a
   mov AL,[offset _x_ourmode]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jz L1731002a
   mov SI,0004
L1731002a:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   add AX,0058
   cmp AX,[offset _objs+01]
   jle L1731004f
   les BX,[offset _gamevp]
   cmp word ptr [ES:BX+08],+08
   jl L1731004d
   mov AX,SI
   neg AX
   mov [offset _scrollxd],AX
L1731004d:
jmp near L17310086
L1731004f:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov DX,[offset _scrnxs]
   mov CL,04
   shl DX,CL
   add AX,DX
   add AX,FF98
   cmp AX,[offset _objs+01]
   jge L17310086
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov DX,0080
   sub DX,[offset _scrnxs]
   dec DX
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jge L17310086
   mov [offset _scrollxd],SI
L17310086:
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
   jge L173100b5
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
jmp near L173100c6
L173100b5:
   mov AX,[offset _scrnys]
   mov CL,04
   shl AX,CL
   push AX
   mov AX,[offset _objs+03]
   pop DX
   sub AX,DX
   add AX,0060
L173100c6:
   or AX,AX
   jge L173100ce
   xor DI,DI
jmp near L1731010d
L173100ce:
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
   jge L173100fd
   mov DI,0040
   sub DI,[offset _scrnys]
   inc DI
   mov CL,04
   shl DI,CL
jmp near L1731010d
L173100fd:
   mov AX,[offset _scrnys]
   mov CL,04
   shl AX,CL
   mov DI,[offset _objs+03]
   sub DI,AX
   add DI,+60
L1731010d:
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[offset _objs+03]
   add DX,-20
   cmp AX,DX
   jge L17310132
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
jmp near L17310138
L17310132:
   mov AX,[offset _objs+03]
   add AX,FFE0
L17310138:
   or AX,AX
   jge L17310140
   xor AX,AX
jmp near L1731016b
L17310140:
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[offset _objs+03]
   add DX,-20
   cmp AX,DX
   jge L17310165
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
jmp near L1731016b
L17310165:
   mov AX,[offset _objs+03]
   add AX,FFE0
L1731016b:
   mov [BP-04],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   add AX,[BP+06]
   mov [BP-02],AX
   mov AX,[BP-02]
   cmp AX,DI
   jl L17310193
   mov AX,[BP-02]
   cmp AX,[BP-04]
   jg L17310193
   mov AX,[BP+06]
   mov [offset _scrollyd],AX
jmp near L173101cd
L17310193:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   cmp AX,[BP-04]
   jle L173101b2
   les BX,[offset _gamevp]
   mov AX,[BP-04]
   mov DX,[ES:BX+0A]
   sub AX,DX
   mov [offset _scrollyd],AX
jmp near L173101cd
L173101b2:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   cmp AX,DI
   jge L173101cd
   les BX,[offset _gamevp]
   mov AX,DI
   mov DX,[ES:BX+0A]
   sub AX,DX
   mov [offset _scrollyd],AX
L173101cd:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_player: ;; 173101d3
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
   mov AX,offset Y24dc136a
   push AX
   mov CX,0007
   call far SCOPY@
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,offset Y24dc1371
   push AX
   mov CX,0007
   call far SCOPY@
   push SS
   lea AX,[BP-18]
   push AX
   push DS
   mov AX,offset Y24dc1378
   push AX
   mov CX,0015
   call far SCOPY@
   mov word ptr [BP-02],0000
   cmp word ptr [BP+08],+00
   jz L1731022f
jmp near L17310836
L1731022f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   cmp AX,0005
   jbe L1731024a
jmp near L1731078d
L1731024a:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y17310253]

Y17310253:	dw L1731025f,L1731078d,L173104b8,L17310594,L173105b5,L1731066e

L1731025f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jge L173102e2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L17310290
   add DI,+3C
jmp near L173102b2
L17310290:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jle L173102ab
   mov AX,0008
jmp near L173102ad
L173102ab:
   xor AX,AX
L173102ad:
   add AX,0024
   add DI,AX
L173102b2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-04
   jz L173102de
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-05
   jnz L173102df
L173102de:
   inc DI
L173102df:
jmp near L173104b5
L173102e2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L173102fe
   add DI,+13
jmp near L173104b5
L173102fe:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+03
   jnz L1731031a
   add DI,+3D
jmp near L173104b5
L1731031a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L17310336
   add DI,+12
jmp near L173104b5
L17310336:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L1731037e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17310365
jmp near L17310442
L17310365:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+03
   jge L1731037e
jmp near L17310442
L1731037e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+14
   jge L173103ce
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L173103ce
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jle L173103c5
   mov AX,0001
jmp near L173103c7
L173103c5:
   xor AX,AX
L173103c7:
   add AX,0014
   add DI,AX
jmp near L1731043f
L173103ce:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],010C
   jle L17310420
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
jmp near L1731043f
L17310420:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],0096
   jle L1731043c
   add DI,+11
jmp near L1731043f
L1731043c:
   add DI,+10
L1731043f:
jmp near L173104b5
L17310442:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+08
   jnz L1731047c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L17310473
   mov AX,0001
jmp near L17310475
L17310473:
   xor AX,AX
L17310475:
   add AX,0014
   add DI,AX
jmp near L173104b5
L1731047c:
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
   jle L173104ae
   mov AX,0008
jmp near L173104b0
L173104ae:
   xor AX,AX
L173104b0:
   pop DX
   add DX,AX
   add DI,DX
L173104b5:
jmp near L1731078d
L173104b8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L17310524
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jnz L173104e9
   add DI,+38
jmp near L17310522
L173104e9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+01
   jnz L17310504
   add DI,+39
jmp near L17310522
L17310504:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L1731051f
   add DI,+3A
jmp near L17310522
L1731051f:
   add DI,+3C
L17310522:
jmp near L17310591
L17310524:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jnz L1731053f
   add DI,+20
jmp near L17310578
L1731053f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+01
   jnz L1731055a
   add DI,+21
jmp near L17310578
L1731055a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L17310575
   add DI,+22
jmp near L17310578
L17310575:
   add DI,+24
L17310578:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L17310591
   add DI,+08
L17310591:
jmp near L1731078d
L17310594:
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
jmp near L1731078d
L173105b5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+10
   jge L173105d0
   add DI,+13
jmp near L173105ee
L173105d0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+18
   jge L173105eb
   add DI,+10
jmp near L173105ee
L173105eb:
   add DI,+12
L173105ee:
   mov AX,0010
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   push DS
   mov AX,offset _tempvp
   push AX
   call far _memcpy
   add SP,+0A
   les BX,[offset _gamevp]
   mov AX,[offset _objs+03]
   add AX,[offset _objs+0B]
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
   mov AX,0001
jmp near L17311dec
L1731066e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jnz L173106c7
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
   mov AX,0001
jmp near L17311dec

X173106c4:
jmp near L1731078b
L173106c7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   or AX,AX
   jz L173106eb
   cmp AX,0001
   jz L1731070c
   cmp AX,0002
   jz L1731072c
jmp near L1731078b
L173106eb:
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
jmp near L1731078b
L1731070c:
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
jmp near L1731078b
L1731072c:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
   mov AX,0001
jmp near L17311dec
L1731078b:
jmp near L1731078d
L1731078d:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   jle L17310833
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
L17310833:
jmp near L17311dec
L17310836:
   cmp word ptr [BP+08],+02
   jz L1731083f
jmp near L17311dcc
L1731083f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   cmp AX,0005
   jbe L1731085a
jmp near L17311acd
L1731085a:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y17310863]

Y17310863:	dw L1731086f,L17311acd,L17311387,L17311704,L1731113a,L173111e1

L1731086f:
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
   jnz L173108d0
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
L173108d0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jz L1731093e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L17310901
   mov AX,0001
jmp near L17310903
L17310901:
   xor AX,AX
L17310903:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L1731091f
   mov AX,0001
jmp near L17310921
L1731091f:
   xor AX,AX
L17310921:
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
L1731093e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jge L17310987
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-01
   jnz L17310984
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],0003
L17310984:
jmp near L17310ce5
L17310987:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L173109a0
jmp near L17310b4b
L173109a0:
   cmp word ptr [offset _dx1],+00
   jz L173109f9
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
   mov word ptr [BP-2C],0001
jmp near L17311acd
X173109f6:
jmp near L17310ac5
L173109f9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],012C
   jle L17310a42
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
   mov word ptr [BP-2C],0001
jmp near L17310ac5
L17310a42:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],010C
   jl L17310a60
   mov word ptr [BP-2C],0001
jmp near L17310ac5
L17310a60:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],0102
   jnz L17310aaa
   call far _rand
   mov BX,0004
   cwd
   idiv BX
   mov [offset _fidgetnum],DX
   mov AX,0002
   push AX
   mov BX,[offset _fidgetnum]
   shl BX,1
   shl BX,1
   push [BX+offset _fidgetmsg+2]
   push [BX+offset _fidgetmsg+0]
   call far _putbotmsg
   add SP,+06
   mov word ptr [offset _bottime],0019
jmp near L17310ac5
L17310aaa:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+03
   jnz L17310ac5
   mov word ptr [BP-2C],0001
L17310ac5:
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
   jnz L17310b48
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
L17310b48:
jmp near L17310ce5
L17310b4b:
   cmp word ptr [offset _dx1],+00
   jnz L17310b55
jmp near L17310c75
L17310b55:
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
   jz L17310b76
jmp near L17310c21
L17310b76:
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
   jz L17310bed
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
L17310bed:
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
jmp near L17310c73
L17310c21:
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
L17310c73:
jmp near L17310ce5
L17310c75:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+02
   jl L17310ce5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jz L17310ce5
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
L17310ce5:
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
   jnz L17310d68
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
L17310d68:
   cmp word ptr [offset _key],+20
   jz L17310d72
jmp near L17310e4a
L17310d72:
   mov AX,0006
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jnz L17310d83
jmp near L17310e4a
L17310d83:
   mov AX,[offset _objs+03]
   add AX,0010
   push AX
   mov AX,[offset _objs+1B]
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
   jz L17310e3f
   mov word ptr [BP-2A],0000
jmp near L17310e34
L17310dfb:
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],1C
   jnz L17310e31
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+06
   jnz L17310e31
   push [BP-2A]
   call far _killobj
   pop CX
L17310e31:
   inc word ptr [BP-2A]
L17310e34:
   mov AX,[offset _numobjs]
   dec AX
   cmp AX,[BP-2A]
   jg L17310dfb
jmp near L17310e4a
L17310e3f:
   mov AX,[offset _numobjs]
   dec AX
   push AX
   call far _killobj
   pop CX
L17310e4a:
   cmp word ptr [offset _fire1],+00
   jnz L17310e54
jmp near L17310edb
L17310e54:
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
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L17311137
L17310edb:
   cmp word ptr [offset _dy1],+00
   jnz L17310ee5
jmp near L17311137
L17310ee5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jz L17310eff
jmp near L17310fef
L17310eff:
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
   jnz L17310f44
jmp near L17310fef
L17310f44:
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
   jnz L17310fef
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
L17310fef:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L17311008
jmp near L17311137
L17311008:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17311021
jmp near L17311137
L17311021:
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
   jge L17311046
   mov AX,FFFD
jmp near L17311061
L17311046:
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
L17311061:
   cmp AX,0003
   jge L173110a8
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
   jge L1731108b
   mov AX,FFFD
jmp near L173110a6
L1731108b:
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
L173110a6:
jmp near L173110ab
L173110a8:
   mov AX,0003
L173110ab:
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
   jle L1731111c
   mov word ptr [BP-02],0002
jmp near L17311137
L1731111c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-01
   jge L17311137
   mov word ptr [BP-02],FFFE
L17311137:
jmp near L17311acd
L1731113a:
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
   jl L173111de
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
   mov word ptr [BP-2C],0001
L173111de:
jmp near L17311acd
L173111e1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jz L173111fa
jmp near L173112bd
L173111fa:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+02
   jz L17311213
jmp near L173112bd
L17311213:
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
   jge L17311244
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
jmp near L17311247
L17311244:
   mov AX,0010
L17311247:
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
   jz L173112ba
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+11],FFFF
L173112ba:
jmp near L1731136e
L173112bd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+01
   jnz L17311348
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+02
   jnz L17311348
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
jmp near L1731136e
L17311348:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+14
   jl L1731136e
   mov word ptr [offset _pl+2*01],0006
   mov AX,0001
   push AX
   call far _p_reenter
   pop CX
L1731136e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,0001
jmp near L17311dec
L17311387:
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
   jnz L17311421
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
   jnz L17311421
   mov word ptr [BP-2C],0001
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
   mov word ptr [ES:BX+0F],0006
jmp near L17311acd
L17311421:
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
   jg L17311440
jmp near L17311701
L17311440:
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
   jle L1731147f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0010
L1731147f:
   cmp word ptr [offset _dx1],+00
   jz L173114b3
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
L173114b3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+08
   jle L173114de
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
L173114de:
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
   jz L17311537
jmp near L17311701
L17311537:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L17311550
jmp near L17311673
L17311550:
   mov word ptr [BP-2A],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jnz L17311573
   mov word ptr [BP-2A],0001
jmp near L173115bf
L17311573:
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
   jnz L173115bf
   mov word ptr [BP-2A],0001
L173115bf:
   cmp word ptr [BP-2A],+01
   jz L173115c8
jmp near L17311670
L173115c8:
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
   jl L1731160d
   mov AX,FFF9
jmp near L17311610
L1731160d:
   mov AX,FFFC
L17311610:
   push AX
   cmp word ptr [offset _dx1],+00
   jz L1731161d
   mov AX,0001
jmp near L1731161f
L1731161d:
   xor AX,AX
L1731161f:
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
L17311670:
jmp near L17311701
L17311673:
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
   jnz L173116bc
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
jmp near L17311701
L173116bc:
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
   jnz L17311701
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L17311701:
jmp near L17311acd
L17311704:
   cmp word ptr [offset _dx1],+00
   jnz L1731170e
jmp near L17311851
L1731170e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jnz L17311727
jmp near L1731184e
L17311727:
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
   jnz L1731176e
jmp near L1731184e
L1731176e:
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
   jz L17311839
   mov word ptr [offset _fire1off],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L1731184e
L17311839:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFC
L1731184e:
jmp near L17311acb
L17311851:
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
   jnz L17311891
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
L17311891:
   cmp word ptr [offset _dy1],+00
   jnz L1731189b
jmp near L17311a73
L1731189b:
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
   jge L173118d9
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
jmp near L173118dd
L173118d9:
   add word ptr [BP-2E],+04
L173118dd:
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
   jnz L1731196f
   cmp word ptr [offset _dy1],+00
   jle L17311929
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
jmp near L17311943
L17311929:
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
L17311943:
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
   jnz L1731196f
   mov word ptr [BP-2E],0000
L1731196f:
   cmp word ptr [BP-2E],+00
   jnz L17311978
jmp near L17311a73
L17311978:
   cmp word ptr [offset _dy1],+00
   jge L173119c4
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
   jl L173119c2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
L173119c2:
jmp near L173119d9
L173119c4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0002
L173119d9:
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
   jz L17311a73
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
L17311a73:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L17311aa0
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0005
jmp near L17311acb
L17311aa0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jle L17311acb
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0006
L17311acb:
jmp near L17311acd
L17311acd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17311b0b
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
L17311b0b:
   cmp word ptr [offset _fire2],+00
   jnz L17311b15
jmp near L17311d73
L17311b15:
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
   jnz L17311b35
jmp near L17311d73
L17311b35:
   mov word ptr [offset _fire2off],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L17311b54
jmp near L17311d73
L17311b54:
   mov word ptr [BP-30],0000
   mov word ptr [BP-2A],0000
jmp near L17311b89
L17311b60:
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
   jnz L17311b81
   mov AX,0001
jmp near L17311b83
L17311b81:
   xor AX,AX
L17311b83:
   add [BP-30],AX
   inc word ptr [BP-2A]
L17311b89:
   mov AX,[BP-2A]
   cmp AX,[offset _numscrnobjs]
   jl L17311b60
   mov AX,0008
   push AX
   call far _invcount
   pop CX
   cmp AX,[BP-30]
   jg L17311ba4
jmp near L17311c3a
L17311ba4:
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
jmp near L17311d73
L17311c3a:
   mov AX,0002
   push AX
   call far _takeinv
   pop CX
   or AX,AX
   jnz L17311c4b
jmp near L17311d64
L17311c4b:
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
   cmp word ptr [BP-2A],+00
   jnz L17311cac
jmp near L17311d62
L17311cac:
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
   jnz L17311d40
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
jmp near L17311d62
L17311d40:
   push [BP-2A]
   call far _killobj
   pop CX
   mov AX,0002
   push AX
   call far _addinv
   pop CX
   mov AX,0008
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L17311d62:
jmp near L17311d73
L17311d64:
   mov AX,0008
   push AX
   mov AX,0002
   push AX
   call far _snd_play
   pop CX
   pop CX
L17311d73:
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
   jz L17311db4
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
L17311db4:
   xor AX,AX
   push AX
   call far _touchbkgnd
   pop CX
   push [BP-02]
   push CS
   call near offset _calc_scroll
   pop CX
   mov AX,[BP-2C]
jmp near L17311dec

X17311dca:
jmp near L17311dec
L17311dcc:
   cmp word ptr [BP+08],+01
   jnz L17311dec
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
jmp near L17311de8
L17311de8:
   xor AX,AX
jmp near L17311dec
L17311dec:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_tiny: ;; 17311df2
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
   jz L17311e10
   mov DI,0001
L17311e10:
   mov AX,[BP+08]
   or AX,AX
   jz L17311e22
   cmp AX,0002
   jnz L17311e1f
jmp near L17311ef3
L17311e1f:
jmp near L173120fc
L17311e22:
   mov word ptr [BP-02],1000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17311e79
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
   jge L17311e6f
   mov AX,0008
jmp near L17311e71
L17311e6f:
   xor AX,AX
L17311e71:
   pop DX
   add DX,AX
   add [BP-02],DX
jmp near L17311eb4
L17311e79:
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
   jge L17311eab
   mov AX,0006
jmp near L17311eae
L17311eab:
   mov AX,0004
L17311eae:
   pop DX
   add DX,AX
   add [BP-02],DX
L17311eb4:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L173120fc
L17311ef3:
   cmp word ptr [offset _dx1],+00
   jnz L17311f04
   cmp word ptr [offset _dy1],+00
   jnz L17311f04
jmp near L173120a5
L17311f04:
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
   jnz L17311f52
jmp near L17312010
L17311f52:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jnz L17311f6b
jmp near L17312010
L17311f6b:
   cmp word ptr [offset _dx1],+00
   jle L17311fa3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+10
   jle L17311fa3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   mov word ptr [offset _dx1],0000
jmp near L17312010
L17311fa3:
   cmp word ptr [offset _dx1],+00
   jge L17311fdb
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+10
   jge L17311fdb
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov word ptr [offset _dx1],0000
jmp near L17312010
L17311fdb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+10
   jnz L17312010
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
L17312010:
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
   jz L173120a5
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
L173120a5:
   xor AX,AX
   push AX
   push CS
   call near offset _calc_scroll
   pop CX
   cmp word ptr [offset _scrollxd],+00
   jle L173120d0
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
jmp near L173120f1
L173120d0:
   cmp word ptr [offset _scrollxd],+00
   jge L173120f1
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
L173120f1:
   xor AX,AX
   push AX
   call far _touchbkgnd
   pop CX
jmp near L173120fc
L173120fc:
   mov AX,0001
jmp near L17312101
L17312101:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_jillfish: ;; 17312107
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
   mov AX,offset Y24dc138d
   push AX
   mov CX,0008
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L17312140
   cmp AX,0002
   jnz L1731213d
jmp near L173121c0
L1731213d:
jmp near L17312706
L17312140:
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
   jle L173121a2
   mov AX,0001
jmp near L173121a4
L173121a2:
   xor AX,AX
L173121a4:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   push DX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L17312706
L173121c0:
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
   jz L1731225c
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
L1731225c:
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
   jnz L17312283
jmp near L17312385
L17312283:
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
   jge L173122a4
   mov AX,0001
jmp near L173122a6
L173122a4:
   xor AX,AX
L173122a6:
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
   jnz L17312307
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
L17312307:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jle L17312332
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L17312335
L17312332:
   mov AX,FFF8
L17312335:
   cmp AX,0008
   jle L1731233f
   mov AX,0008
jmp near L1731236d
L1731233f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jle L1731236a
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L1731236d
L1731236a:
   mov AX,FFF8
L1731236d:
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
jmp near L17312414
L17312385:
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
   jle L173123c4
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L173123c7
L173123c4:
   mov AX,FFF0
L173123c7:
   cmp AX,0010
   jle L173123d1
   mov AX,0010
jmp near L173123ff
L173123d1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-10
   jle L173123fc
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L173123ff
L173123fc:
   mov AX,FFF0
L173123ff:
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
L17312414:
   cmp word ptr [offset _fire1],+00
   jz L1731244b
   cmp word ptr [BP-10],+00
   jz L1731244b
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
L1731244b:
   cmp word ptr [offset _fire2],+00
   jnz L17312455
jmp near L17312566
L17312455:
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
   jge L173124ac
   mov AX,0001
jmp near L173124ae
L173124ac:
   xor AX,AX
L173124ae:
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
   jle L173124e0
   mov AX,0001
jmp near L173124e2
L173124e0:
   xor AX,AX
L173124e2:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L173124fe
   mov AX,0001
jmp near L17312500
L173124fe:
   xor AX,AX
L17312500:
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
   jle L17312525
   mov AX,0001
jmp near L17312527
L17312525:
   xor AX,AX
L17312527:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L17312543
   mov AX,0001
jmp near L17312545
L17312543:
   xor AX,AX
L17312545:
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
L17312566:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+08
   jle L17312593
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0008
jmp near L173125be
L17312593:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jge L173125be
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF8
L173125be:
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
   jz L17312633
jmp near L173126da
L17312633:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L17312656
   mov AX,DI
   add AX,0010
   and AX,FFF0
   mov [BP-0C],AX
jmp near L1731268c
L17312656:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L1731268c
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
L1731268c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jz L173126da
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
   jnz L173126da
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L173126da:
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
jmp near L17312706
L17312706:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_jillspider: ;; 1731270c
   push BP
   mov BP,SP
   mov AX,[BP+08]
   or AX,AX
   jz L1731271d
   cmp AX,0002
   jz L1731271f
jmp near L17312723
L1731271d:
jmp near L17312723
L1731271f:
   xor AX,AX
jmp near L17312723
L17312723:
   pop BP
ret far

_msg_jillfrog: ;; 17312725
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L17312742
   cmp AX,0002
   jnz L1731273f
jmp near L17312800
L1731273f:
jmp near L17312a62
L17312742:
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
   jle L17312764
   xor AX,AX
jmp near L17312767
L17312764:
   mov AX,0003
L17312767:
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
   jnz L173127c4
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L1731279e
   mov AX,0002
jmp near L173127a0
L1731279e:
   xor AX,AX
L173127a0:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L173127bc
   mov AX,0001
jmp near L173127be
L173127bc:
   xor AX,AX
L173127be:
   pop DX
   add DX,AX
   add [BP-04],DX
L173127c4:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L17312a62
L17312800:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L1731283e
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
L1731283e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],0007
   jnz L1731286b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L17312889
L1731286b:
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
jmp near L173128a7
L17312889:
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
L173128a7:
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
   jz L1731293b
   cmp word ptr [offset _fire1],+00
   jnz L173128ef
   cmp word ptr [offset _fire2],+00
   jz L17312915
L173128ef:
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
jmp near L17312939
L17312915:
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
L17312939:
jmp near L1731296c
L1731293b:
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
   jle L1731296c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L1731296c:
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
   jz L173129d2
jmp near L17312a55
L173129d2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L173129ff
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
jmp near L17312a55
L173129ff:
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
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L17312a55:
   xor AX,AX
   push AX
   push CS
   call near offset _calc_scroll
   pop CX
   mov AX,0001
jmp near L17312a62
L17312a62:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_msg_jillbird: ;; 17312a68
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
   mov AX,offset Y24dc1395
   push AX
   mov CX,000C
   call far SCOPY@
   mov AX,[BP+08]
   or AX,AX
   jz L17312a97
   cmp AX,0002
   jnz L17312a94
jmp near L17312b1e
L17312a94:
jmp near L17312f38
L17312a97:
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
   jge L17312ada
   mov AX,0004
jmp near L17312adc
L17312ada:
   xor AX,AX
L17312adc:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L17312f38
L17312b1e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17312b5c
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
L17312b5c:
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
   jl L17312b8d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L17312b8d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+01],0007
   jnz L17312bba
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L17312bd8
L17312bba:
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
jmp near L17312bf6
L17312bd8:
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
L17312bf6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   inc word ptr [ES:BX+07]
   cmp word ptr [offset _fire1],+00
   jnz L17312c17
   cmp word ptr [offset _fire2],+00
   jz L17312c41
L17312c17:
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
L17312c41:
   cmp word ptr [offset _fire2],+00
   jnz L17312c4b
jmp near L17312d51
L17312c4b:
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
   jle L17312c8e
   mov AX,0001
jmp near L17312c90
L17312c8e:
   xor AX,AX
L17312c90:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L17312cac
   mov AX,0001
jmp near L17312cae
L17312cac:
   xor AX,AX
L17312cae:
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
   jle L17312cf5
   mov AX,0001
jmp near L17312cf7
L17312cf5:
   xor AX,AX
L17312cf7:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L17312d13
   mov AX,0001
jmp near L17312d15
L17312d13:
   xor AX,AX
L17312d15:
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
L17312d51:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+08
   jle L17312d7e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0008
jmp near L17312da9
L17312d7e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jge L17312da9
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF8
L17312da9:
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
   jnz L17312e03
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov DI,[ES:BX+01]
L17312e03:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L17312e1c
jmp near L17312ee4
L17312e1c:
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
   push [BP-10]
   push DI
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jz L17312e5b
jmp near L17312ee4
L17312e5b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L17312e7f
   mov AX,[BP-10]
   add AX,0010
   and AX,FFF0
   mov [BP-0E],AX
jmp near L17312eb6
L17312e7f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L17312eb6
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
L17312eb6:
   mov AX,[BP-0E]
   cmp AX,[BP-10]
   jz L17312ecf
   push [BP-0E]
   push DI
   push SI
   call far _justmove
   add SP,+06
   or AX,AX
   jnz L17312ee4
L17312ecf:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L17312ee4:
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
   jz L17312f2b
   mov AX,0001
   push AX
   mov AX,0100
   push AX
   call far _p_ouch
   pop CX
   pop CX
L17312f2b:
   xor AX,AX
   push AX
   push CS
   call near offset _calc_scroll
   pop CX
   mov AX,0001
jmp near L17312f38
L17312f38:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_playerxfm: ;; 17312f3e
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   xor SI,SI
   mov word ptr [BP-0A],0000
   mov AL,[offset _objs]
   cbw
   mov [BP-08],AX
   mov AX,[offset _objs+09]
   mov [BP-06],AX
   mov AX,[offset _objs+0B]
   mov [BP-04],AX
   mov AX,[BP+06]
   cmp AX,0004
   jz L17312f74
   cmp AX,0005
   jz L17312f7b
   cmp AX,0007
   jz L17312f82
jmp near L17312f89
L17312f74:
   mov word ptr [BP-0A],0039
jmp near L17312f89
L17312f7b:
   mov word ptr [BP-0A],0038
jmp near L17312f89
L17312f82:
   mov word ptr [BP-0A],0036
jmp near L17312f89
L17312f89:
   mov AL,[offset _objs]
   cbw
   cmp AX,[BP-0A]
   jnz L17312f95
jmp near L1731309e
L17312f95:
   mov AL,[BP-0A]
   mov [offset _objs],AL
   mov BX,[BP-0A]
   shl BX,1
   mov AX,[BX+offset _kindxl]
   mov [offset _objs+09],AX
   mov BX,[BP-0A]
   shl BX,1
   mov AX,[BX+offset _kindyl]
   mov [offset _objs+0B],AX
   mov AX,[offset _objs+01]
   and AX,FFF8
   mov [BP-02],AX
   mov DI,[offset _objs+03]
   add DI,[BP-04]
   sub DI,[offset _objs+0B]
   mov AX,0001
   push AX
   push DI
   push [BP-02]
   xor AX,AX
   push AX
   call far _cando
   add SP,+08
   or AX,AX
   jz L17312fe3
   mov SI,0001
jmp near L17313001
L17312fe3:
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
   jz L17313001
   mov SI,0001
L17313001:
   or SI,SI
   jnz L17313008
jmp near L1731308c
L17313008:
   push [BP+06]
   call far _addinv
   pop CX
   mov [offset _objs+03],DI
   mov AX,[BP-02]
   mov [offset _objs+01],AX
   mov word ptr [offset _objs+0D],0000
   mov word ptr [offset _objs+0F],0000
   mov word ptr [offset _objs+13],0000
   mov word ptr [offset _objs+05],0000
   mov word ptr [offset _objs+07],0000
   xor SI,SI
jmp near L17313056
L1731303d:
   mov BX,SI
   shl BX,1
   cmp word ptr [BX+offset _inv_xfm],+00
   jz L17313055
jmp near L1731304a
L1731304a:
   push SI
   call far _takeinv
   pop CX
   or AX,AX
   jnz L1731304a
L17313055:
   inc SI
L17313056:
   cmp SI,+0B
   jl L1731303d
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
jmp near L1731309e
L1731308c:
   mov AL,[BP-08]
   mov [offset _objs],AL
   mov AX,[BP-06]
   mov [offset _objs+09],AX
   mov AX,[BP-04]
   mov [offset _objs+0B],AX
L1731309e:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1a3b ;; JUNGLE.C:JUNGLE
_fin: ;; 1a3b0004
   push BP
   mov BP,SP
   mov AX,0016
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   call far _fadein
   pop BP
ret far

_fout: ;; 1a3b001d
   push BP
   mov BP,SP
   mov AX,0015
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
   call far _fadeout
   pop BP
ret far

_drawkeys: ;; 1a3b0036
   push BP
   mov BP,SP
   mov AL,[offset _objs]
   cbw
   mov CX,0006
   mov BX,offset Y1a3b0053
L1a3b0043:
   cmp AX,[CS:BX]
   jz L1a3b004f
   inc BX
   inc BX
   loop L1a3b0043
jmp near L1a3b0315
L1a3b004f:
jmp near [CS:BX+0C]

Y1a3b0053:	dw 0000,0017,0036,0037,0038,0039
		dw L1a3b006b,L1a3b012c,L1a3b0255,L1a3b02bb,L1a3b0189,L1a3b01ef

L1a3b006b:
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y24dc1414
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
   jz L1a3b00d6
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
jmp near L1a3b0315
L1a3b00d6:
   mov AX,0002
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jz L1a3b0108
   push DS
   mov AX,offset Y24dc141c
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
jmp near L1a3b0315
L1a3b0108:
   push DS
   mov AX,offset Y24dc1424
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
jmp near L1a3b0315
L1a3b012c:
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y24dc142c
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
   mov AX,offset Y24dc1434
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
jmp near L1a3b0315
L1a3b0189:
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
   mov AX,offset Y24dc143c
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
   mov AX,offset Y24dc1444
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
jmp near L1a3b0315
L1a3b01ef:
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
   mov AX,offset Y24dc144c
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
   mov AX,offset Y24dc1454
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
jmp near L1a3b0315
L1a3b0255:
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
   mov AX,offset Y24dc145c
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
   mov AX,offset Y24dc1464
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
jmp near L1a3b0315
L1a3b02bb:
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y24dc146c
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
   mov AX,offset Y24dc1474
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
L1a3b0315:
   pop BP
ret far

_drawcmds: ;; 1a3b0317
   push BP
   mov BP,SP
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
   mov AX,offset Y24dc147c
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
   mov AX,offset Y24dc1489
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
   mov AX,offset Y24dc148e
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
   mov AX,offset Y24dc1490
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
   mov AX,offset Y24dc1492
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
   mov AX,offset Y24dc1494
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
   mov AX,offset Y24dc1496
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
   mov AX,offset Y24dc1498
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
   mov AX,offset Y24dc149e
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
   mov AX,offset Y24dc14a3
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
   mov AX,offset Y24dc14a8
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
   mov AX,offset Y24dc14b0
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
   pop BP
ret far

_putbotmsg: ;; 1a3b05af
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

_drawstats: ;; 1a3b05d8
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
   cmp word ptr [offset _pl+2*15],+00
   jz L1a3b0656
   mov AX,0004
   push AX
   mov AX,FFFB
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _fontcolor
   add SP,+08
jmp near L1a3b066e
L1a3b0656:
   mov AX,0008
   push AX
   mov AX,FFFB
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _fontcolor
   add SP,+08
L1a3b066e:
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc14b7
   push AX
   mov AX,0002
   push AX
   push AX
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _wprint
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,FFFC
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _fontcolor
   add SP,+08
   xor SI,SI
jmp near L1a3b06d8
L1a3b06b4:
   mov AX,0002
   push AX
   mov AX,SI
   mov DX,0003
   mul DX
   add AX,002A
   push AX
   mov AX,0E2A
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _drawshape
   add SP,+0A
   inc SI
L1a3b06d8:
   mov AX,[offset _pl+2*01]
   dec AX
   cmp AX,SI
   jg L1a3b06b4
   mov AX,0002
   push AX
   mov AX,[offset _pl+2*01]
   dec AX
   mov DX,0003
   mul DX
   add AX,0028
   push AX
   mov AX,0E2B
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _drawshape
   add SP,+0A
   push DS
   mov AX,offset Y24dc14be
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0021
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _wprint
   add SP,+0E
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   push [offset _pl+2*14]
   push [offset _pl+2*13]
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
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _wprint
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,FFFE
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y24dc14c4
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0001
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _wprint
   add SP,+0E
   cmp word ptr [offset _pl+2*00],+7F
   jnz L1a3b07c8
   push DS
   mov AX,offset Y24dc14ca
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far _strcpy
   add SP,+08
jmp near L1a3b07df
L1a3b07c8:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   mov AX,[offset _pl+2*00]
   cwd
   push DX
   push AX
   call far _ltoa
   add SP,+0A
L1a3b07df:
   push SS
   lea AX,[BP-20]
   push AX
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   mov AX,0001
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _wprint
   add SP,+0E
   cmp word ptr [offset _debug],+00
   jz L1a3b0859
   cmp word ptr [offset _swrite],+00
   jnz L1a3b0859
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
   mov AX,offset Y24dc14ce
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
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _wprint
   add SP,+0E
L1a3b0859:
   xor SI,SI
jmp near L1a3b089f
L1a3b085d:
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
   mov BX,[BX+offset _pl+2*03]
   shl BX,1
   mov AX,[BX+offset _inv_shape]
   add AX,0E00
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _drawshape
   add SP,+0A
   inc SI
L1a3b089f:
   cmp SI,[offset _pl+2*02]
   jl L1a3b085d
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

_zapobjs: ;; 1a3b08fc
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L1a3b093c
L1a3b0904:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1a3b093b
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
L1a3b093b:
   inc SI
L1a3b093c:
   cmp SI,[offset _numobjs]
   jl L1a3b0904
   call far _initobjs
   pop SI
   pop BP
ret far

_loadcfg: ;; 1a3b094a
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
   jl L1a3b099e
   push DI
   call far _filelength
   pop CX
   or DX,DX
   jg L1a3b09ec
   jnz L1a3b099e
   or AX,AX
   ja L1a3b09ec
L1a3b099e:
   xor SI,SI
jmp near L1a3b09c8
L1a3b09a2:
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
   mov word ptr [BX+offset _hiscore+2],0000
   mov word ptr [BX+offset _hiscore+0],0000
   inc SI
L1a3b09c8:
   cmp SI,+0A
   jl L1a3b09a2
   xor SI,SI
jmp near L1a3b09e5
L1a3b09d1:
   mov AX,SI
   mov DX,000C
   mul DX
   mov BX,AX
   add BX,offset _savename
   push DS
   pop ES
   mov byte ptr [ES:BX],00
   inc SI
L1a3b09e5:
   cmp SI,+06
   jl L1a3b09d1
jmp near L1a3b0a38
L1a3b09ec:
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
   jge L1a3b0a3e
L1a3b0a38:
   mov word ptr [offset _cf+2*00],0001
L1a3b0a3e:
   push DI
   call far _close
   pop CX
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_savecfg: ;; 1a3b0a4b
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
   jl L1a3b0ad4
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
L1a3b0ad4:
   push SI
   call far _close
   pop CX
   pop SI
   mov SP,BP
   pop BP
ret far

_loadboard: ;; 1a3b0ae0
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov SI,0009
jmp near L1a3b0af8
L1a3b0aed:
   mov BX,SI
   shl BX,1
   mov word ptr [BX+offset _shm_want],0000
   inc SI
L1a3b0af8:
   cmp SI,+40
   jl L1a3b0aed
   mov word ptr [offset _shm_want+2*0E],0001
   mov word ptr [offset _shm_want+2*2E],0001
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
   jnz L1a3b0b54
   mov AX,0001
   push AX
   call far _rexit
   pop CX
L1a3b0b54:
   mov AX,0002
   push AX
   push DS
   mov AX,offset _numobjs
   push AX
   push DI
   call far _read
   add SP,+08
   or AX,AX
   jnz L1a3b0b74
   mov AX,0002
   push AX
   call far _rexit
   pop CX
L1a3b0b74:
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
   jnz L1a3b0b99
   mov AX,0003
   push AX
   call far _rexit
   pop CX
L1a3b0b99:
   mov AX,0046
   push AX
   push DS
   mov AX,offset _pl
   push AX
   push DI
   call far _read
   add SP,+08
   or AX,AX
   jnz L1a3b0bb9
   mov AX,0004
   push AX
   call far _rexit
   pop CX
L1a3b0bb9:
   xor SI,SI
jmp near L1a3b0c34
L1a3b0bbd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1a3b0c33
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
L1a3b0c33:
   inc SI
L1a3b0c34:
   cmp SI,[offset _numobjs]
   jl L1a3b0bbd
   push DI
   call far __close
   pop CX
   mov word ptr [BP-04],0000
jmp near L1a3b0c95
L1a3b0c48:
   mov word ptr [BP-02],0000
jmp near L1a3b0c8c
L1a3b0c4f:
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
L1a3b0c8c:
   cmp word ptr [BP-02],+40
   jl L1a3b0c4f
   inc word ptr [BP-04]
L1a3b0c95:
   cmp word ptr [BP-04],0080
   jl L1a3b0c48
   xor SI,SI
jmp near L1a3b0cc4
L1a3b0ca0:
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
L1a3b0cc4:
   cmp SI,[offset _numobjs]
   jl L1a3b0ca0
   call far _shm_do
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_saveboard: ;; 1a3b0cd5
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
   jge L1a3b0cfe
   mov AX,0014
   push AX
   call far _rexit
   pop CX
L1a3b0cfe:
   mov AX,4000
   push AX
   push DS
   mov AX,offset _bd
   push AX
   push SI
   call far _write
   add SP,+08
   or AX,AX
   jge L1a3b0d1e
   mov AX,0005
   push AX
   call far _rexit
   pop CX
L1a3b0d1e:
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
jmp near L1a3b0dcf
L1a3b0d5d:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1a3b0dce
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
L1a3b0dce:
   inc DI
L1a3b0dcf:
   cmp DI,[offset _numobjs]
   jl L1a3b0d5d
   push SI
   call far __close
   pop CX
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_numlines: ;; 1a3b0de2
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   mov SI,DI
jmp near L1a3b0e01
L1a3b0ded:
   les BX,[offset _textmsg]
   cmp byte ptr [ES:BX+SI],0D
   jnz L1a3b0dfc
   mov AX,0001
jmp near L1a3b0dfe
L1a3b0dfc:
   xor AX,AX
L1a3b0dfe:
   add DI,AX
   inc SI
L1a3b0e01:
   cmp SI,[offset _textmsglen]
   jl L1a3b0ded
   mov AX,DI
   pop DI
   pop SI
   pop BP
ret far

_getline: ;; 1a3b0e0d
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov word ptr [BP-04],0007
   xor SI,SI
   mov DI,SI
jmp near L1a3b0e34
L1a3b0e20:
   les BX,[offset _textmsg]
   cmp byte ptr [ES:BX+SI],0D
   jnz L1a3b0e2f
   mov AX,0001
jmp near L1a3b0e31
L1a3b0e2f:
   xor AX,AX
L1a3b0e31:
   add DI,AX
   inc SI
L1a3b0e34:
   cmp DI,[BP+06]
   jge L1a3b0e42
   cmp SI,[offset _textmsglen]
   jl L1a3b0e20
jmp near L1a3b0e42
L1a3b0e41:
   inc SI
L1a3b0e42:
   les BX,[offset _textmsg]
   cmp byte ptr [ES:BX+SI],20
   jge L1a3b0e52
   cmp byte ptr [ES:BX+SI],0D
   jnz L1a3b0e41
L1a3b0e52:
   les BX,[offset _textmsg]
   cmp byte ptr [ES:BX+SI],30
   jl L1a3b0e6d
   cmp byte ptr [ES:BX+SI],37
   jg L1a3b0e6d
   mov AL,[ES:BX+SI]
   cbw
   add AX,FFD0
   mov [BP-04],AX
   inc SI
L1a3b0e6d:
   xor DI,DI
jmp near L1a3b0e96
L1a3b0e71:
   cmp word ptr [BP+0C],+00
   jz L1a3b0e8b
   mov AL,[BP-01]
   cbw
   push AX
   call far _toupper
   pop CX
   les BX,[BP+08]
   mov [ES:BX+DI],AL
   inc DI
jmp near L1a3b0e95
L1a3b0e8b:
   mov AL,[BP-01]
   les BX,[BP+08]
   mov [ES:BX+DI],AL
   inc DI
L1a3b0e95:
   inc SI
L1a3b0e96:
   les BX,[offset _textmsg]
   mov AL,[ES:BX+SI]
   mov [BP-01],AL
   cmp AL,0D
   jz L1a3b0eaf
   cmp SI,[offset _textmsglen]
   jge L1a3b0eaf
   cmp DI,+4D
   jl L1a3b0e71
L1a3b0eaf:
   les BX,[BP+08]
   mov byte ptr [ES:BX+DI],00
   mov AX,[BP-04]
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_printline: ;; 1a3b0ebf
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
   mov AX,offset Y24dc14d4
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

_ourdelay: ;; 1a3b0f3e
   push BP
   mov BP,SP
   push SI
   les BX,[offset _myclock]
   mov SI,[ES:BX]
L1a3b0f49:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,SI
   cmp AX,[offset _xmsgdelay]
   jl L1a3b0f49
   pop SI
   pop BP
ret far

_dotextmsg: ;; 1a3b0f5b
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
   mov AX,[offset _textmsg+0]
   or AX,[offset _textmsg+2]
   jnz L1a3b0f85
jmp near L1a3b1236
L1a3b0f85:
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   xor AX,AX
   push AX
   push AX
   push AX
   mov AX,[offset _ourwin+28+2*03]
   mov BX,0010
   cwd
   idiv BX
   add AX,FFFC
   push AX
   mov AX,[offset _ourwin+28+2*02]
   cwd
   idiv BX
   add AX,FFFD
   push AX
   mov AX,[offset _ourwin+28+2*01]
   add AX,BX
   push AX
   mov AX,[offset _ourwin+28+2*00]
   mov BX,0008
   cwd
   idiv BX
   inc AX
   inc AX
   push AX
   push SS
   lea AX,[BP+FF52]
   push AX
   call far _defwin
   add SP,+12
   push SS
   lea AX,[BP+FF52]
   push AX
   call far _drawwin
   pop CX
   pop CX
   mov AX,0001
   push AX
   mov AX,0007
   push AX
   push SS
   lea AX,[BP+FF7A]
   push AX
   call far _fontcolor
   add SP,+08
   push SS
   lea AX,[BP+FF7A]
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
   lea AX,[BP+FF6A]
   push AX
   call far _fontcolor
   add SP,+08
   push SS
   lea AX,[BP-50]
   push AX
   push SS
   lea AX,[BP+FF52]
   push AX
   call far _titlewin
   add SP,+08
   xor AX,AX
   push AX
   mov AX,0007
   push AX
   push SS
   lea AX,[BP+FF7A]
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
   jle L1a3b1063
jmp near L1a3b10f0
L1a3b1063:
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
jmp near L1a3b1094
L1a3b107e:
   push SI
   push [BP-54]
   push SS
   lea AX,[BP+FF7A]
   push AX
   push CS
   call near offset _printline
   add SP,+08
   add word ptr [BP-54],+06
   inc SI
L1a3b1094:
   cmp SI,[BP-56]
   jl L1a3b107e
   call far _pageflip
   push CS
   call near offset _ourdelay
L1a3b10a2:
   mov AX,0001
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L1a3b10a2
   cmp word ptr [offset _dy1],+00
   jnz L1a3b10a2
   cmp word ptr [offset _key],+00
   jnz L1a3b10a2
   cmp word ptr [offset _fire1],+00
   jnz L1a3b10a2
L1a3b10c8:
   mov AX,0001
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _key],+20
   jnz L1a3b10dc
jmp near L1a3b121c
L1a3b10dc:
   cmp word ptr [offset _key],+0D
   jnz L1a3b10e6
jmp near L1a3b121c
L1a3b10e6:
   cmp word ptr [offset _fire1],+00
   jz L1a3b10c8
jmp near L1a3b121c
L1a3b10f0:
   xor DI,DI
   mov [BP-54],DI
   mov SI,0001
jmp near L1a3b1110
L1a3b10fa:
   push SI
   push [BP-54]
   push SS
   lea AX,[BP+FF7A]
   push AX
   push CS
   call near offset _printline
   add SP,+08
   add word ptr [BP-54],+06
   inc SI
L1a3b1110:
   cmp SI,[BP-52]
   jle L1a3b10fa
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   mov word ptr [offset _fire1off],0001
L1a3b1129:
   mov AX,0001
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L1a3b1129
   cmp word ptr [offset _dy1],+00
   jnz L1a3b1129
   cmp word ptr [offset _key],+00
   jnz L1a3b1129
   push CS
   call near offset _ourdelay
L1a3b114c:
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _key],00D1
   jnz L1a3b1162
   mov AX,0001
jmp near L1a3b1164
L1a3b1162:
   xor AX,AX
L1a3b1164:
   push AX
   cmp word ptr [offset _key],00C9
   jnz L1a3b1172
   mov AX,0001
jmp near L1a3b1174
L1a3b1172:
   xor AX,AX
L1a3b1174:
   pop DX
   sub DX,AX
   add [offset _dx1],DX
   mov AX,[offset _dx1]
   add AX,[offset _dy1]
   jge L1a3b11b4
   or DI,DI
   jle L1a3b11b4
   dec DI
   mov AX,0006
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP+FF7A]
   push AX
   call far _scrollvp
   add SP,+08
   mov AX,DI
   inc AX
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP+FF7A]
   push AX
   push CS
   call near offset _printline
   add SP,+08
jmp near L1a3b11fa
L1a3b11b4:
   mov AX,[offset _dx1]
   add AX,[offset _dy1]
   jle L1a3b11fa
   mov AX,DI
   add AX,[BP-52]
   cmp AX,[BP-56]
   jge L1a3b11fa
   inc DI
   mov AX,FFFA
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP+FF7A]
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
   lea AX,[BP+FF7A]
   push AX
   push CS
   call near offset _printline
   add SP,+08
L1a3b11fa:
   cmp word ptr [offset _key],+0D
   jz L1a3b1212
   cmp word ptr [offset _key],+1B
   jz L1a3b1212
   cmp word ptr [offset _fire1],+00
   jnz L1a3b1212
jmp near L1a3b114c
L1a3b1212:
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
L1a3b121c:
   call far _moddrawboard
   push [offset _textmsg+2]
   push [offset _textmsg+0]
   call far _free
   pop CX
   pop CX
   mov word ptr [offset _key],0000
L1a3b1236:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_initboard: ;; 1a3b123c
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
jmp near L1a3b1267
L1a3b1245:
   xor DI,DI
jmp near L1a3b1261
L1a3b1249:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C000
   inc DI
L1a3b1261:
   cmp DI,+40
   jl L1a3b1249
   inc SI
L1a3b1267:
   cmp SI,0080
   jl L1a3b1245
   les BX,[offset _gamevp]
   mov word ptr [ES:BX+08],0000
   mov word ptr [ES:BX+0A],0000
   pop DI
   pop SI
   pop BP
ret far

_putlevelmsg: ;; 1a3b1281
   push BP
   mov BP,SP
   sub SP,+52
   push SI
   push DI
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   mov [offset _levelmsgclock],AX
   cmp word ptr [BP+06],+20
   jl L1a3b129c
jmp near L1a3b13d2
L1a3b129c:
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   les BX,[BX+offset _leveltxt]
   mov [offset _textmsg+2],ES
   mov [offset _textmsg+0],BX
   push [offset _textmsg+2]
   push BX
   call far _strlen
   pop CX
   pop CX
   mov [offset _textmsglen],AX
   mov AX,[offset _textmsg+0]
   or AX,[offset _textmsg+2]
   jnz L1a3b12ca
jmp near L1a3b13d2
L1a3b12ca:
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
   jnz L1a3b1348
   cmp word ptr [offset _facetable],+00
   jz L1a3b1348
   xor SI,SI
jmp near L1a3b1343
L1a3b1313:
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
L1a3b1343:
   cmp SI,+10
   jl L1a3b1313
L1a3b1348:
   push CS
   call near offset _numlines
   mov DI,AX
   mov AX,DI
   dec AX
   mov DX,0006
   mul DX
   push AX
   mov AX,[offset _levelwin+2E]
   pop DX
   sub AX,DX
   mov BX,0002
   cwd
   idiv BX
   mov [BP-02],AX
   xor SI,SI
jmp near L1a3b13c4
L1a3b136a:
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
   mov DX,[offset _levelwin+2C]
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
L1a3b13c4:
   cmp SI,DI
   jl L1a3b136a
   call far _pageflip
   call far _moddrawboard
L1a3b13d2:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_donelevelmsg: ;; 1a3b13d8
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
L1a3b13df:
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   cmp word ptr [offset _key],+00
   jnz L1a3b13df
L1a3b13ef:
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
   jz L1a3b1431
   cmp word ptr [offset _key],+0D
   jz L1a3b1431
   cmp DI,+02
   jl L1a3b142c
   cmp word ptr [offset _key],+00
   jnz L1a3b1431
   cmp word ptr [offset _fire1],+00
   jnz L1a3b1431
L1a3b142c:
   cmp DI,+04
   jl L1a3b1434
L1a3b1431:
   mov SI,0001
L1a3b1434:
   or SI,SI
   jz L1a3b13ef
   pop DI
   pop SI
   pop BP
ret far

_drawcell: ;; 1a3b143c
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   or SI,SI
   jge L1a3b1451
jmp near L1a3b14d3
L1a3b1451:
   cmp SI,0080
   jl L1a3b145a
jmp near L1a3b14d3
L1a3b145a:
   or DI,DI
   jl L1a3b14d3
   cmp DI,+40
   jge L1a3b14d3
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
   jnz L1a3b14c6
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
jmp near L1a3b14d3
L1a3b14c6:
   xor AX,AX
   push AX
   push DI
   push SI
   call far _msg_block
   add SP,+06
L1a3b14d3:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_drawboard: ;; 1a3b14d9
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
jmp near L1a3b1504
L1a3b14e2:
   xor DI,DI
jmp near L1a3b14fe
L1a3b14e6:
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
   inc DI
L1a3b14fe:
   cmp DI,+40
   jl L1a3b14e6
   inc SI
L1a3b1504:
   cmp SI,0080
   jl L1a3b14e2
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
   pop BP
ret far

_moddrawboard: ;; 1a3b1526
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
jmp near L1a3b1551
L1a3b152f:
   xor DI,DI
jmp near L1a3b154b
L1a3b1533:
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
   inc DI
L1a3b154b:
   cmp DI,+40
   jl L1a3b1533
   inc SI
L1a3b1551:
   cmp SI,0080
   jl L1a3b152f
   or word ptr [offset _statmodflg],C000
   pop DI
   pop SI
   pop BP
ret far

_play: ;; 1a3b1561
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
   mov AX,offset Y24dc14f9
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
L1a3b15aa:
   sti
   cmp byte ptr [offset _newlevel],00
   jnz L1a3b15b5
jmp near L1a3b17b3
L1a3b15b5:
   cmp byte ptr [offset _newlevel],2A
   jnz L1a3b15f0
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
jmp near L1a3b166b
L1a3b15f0:
   cmp byte ptr [offset _newlevel],23
   jnz L1a3b1618
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
jmp near L1a3b1650
L1a3b1618:
   cmp byte ptr [offset _newlevel],26
   jnz L1a3b167f
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
L1a3b1650:
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
   jnz L1a3b1677
L1a3b166b:
   push DS
   mov AX,offset _newlevel
   push AX
   call far _sb_playtune
   pop CX
   pop CX
L1a3b1677:
   mov byte ptr [offset _newlevel],00
jmp near L1a3b17b3
L1a3b167f:
   cmp byte ptr [offset _newlevel],21
   jz L1a3b1689
jmp near L1a3b1768
L1a3b1689:
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
   mov AX,[offset _pl+2*13]
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
   mov [offset _pl+2*14],DX
   mov [offset _pl+2*13],AX
   push DS
   mov AX,offset _tempname
   push AX
   call far _unlink
   pop CX
   pop CX
jmp near L1a3b16d4
L1a3b16ca:
   mov AX,0003
   push AX
   call far _addinv
   pop CX
L1a3b16d4:
   mov AX,DI
   dec DI
   or AX,AX
   jg L1a3b16ca
   mov byte ptr [offset _newlevel],00
   xor AX,AX
   push AX
   call far _p_reenter
   pop CX
   push [offset _pl+2*00]
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
   jz L1a3b170f
jmp near L1a3b1715
L1a3b170f:
   cmp word ptr [BP-06],+00
   jle L1a3b171f
L1a3b1715:
   push DI
   call far _killobj
   pop CX
jmp near L1a3b17af
L1a3b171f:
   mov AX,0004
   push AX
   push DS
   mov AX,offset Y24dc150c
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
   mov word ptr [offset _pl+2*00],0000
jmp near L1a3b17af
L1a3b1768:
   mov AX,[offset _pl+2*00]
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
   mov AX,[offset _pl+2*13]
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
   mov [offset _pl+2*14],DX
   mov [offset _pl+2*13],AX
   mov byte ptr [offset _newlevel],00
   mov AX,[offset _oldlevelnum]
   mov [offset _pl+2*00],AX
   xor AX,AX
   push AX
   call far _p_reenter
   pop CX
L1a3b17af:
   push CS
   call near offset _donelevelmsg
L1a3b17b3:
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
   jnz L1a3b17e4
jmp near L1a3b18cf
L1a3b17e4:
   cmp SI,+2F
   jnz L1a3b1830
   cmp word ptr [BP-04],+02
   jnz L1a3b1830
   xor SI,SI
   cmp AX,0030
   jz L1a3b1802
   cmp AX,0043
   jz L1a3b181e
   cmp AX,0052
   jz L1a3b1810
jmp near L1a3b182a
L1a3b1802:
   cmp word ptr [offset _macrecord],+00
   jz L1a3b182a
   call far _macrecend
jmp near L1a3b182a
L1a3b1810:
   push DS
   mov AX,offset Y24dc152c
   push AX
   call far _recordmac
   pop CX
   pop CX
jmp near L1a3b182a
L1a3b181e:
   push DS
   mov AX,offset Y24dc1535
   push AX
   call far _playmac
   pop CX
   pop CX
L1a3b182a:
   mov word ptr [offset _key],0000
L1a3b1830:
   mov AX,[offset _key]
   cmp AX,SI
   jnz L1a3b183c
   inc word ptr [BP-04]
jmp near L1a3b1845
L1a3b183c:
   mov word ptr [BP-04],0001
   mov SI,[offset _key]
L1a3b1845:
   cmp SI,+58
   jnz L1a3b188a
   cmp word ptr [BP-04],+03
   jnz L1a3b188a
   xor SI,SI
   mov word ptr [offset _pl+2*01],0008
   mov AX,000A
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jnz L1a3b1870
   mov AX,000A
   push AX
   call far _addinv
   pop CX
L1a3b1870:
   mov AX,0001
   push AX
   call far _invcount
   pop CX
   or AX,AX
   jnz L1a3b18a2
   mov AX,0001
   push AX
   call far _addinv
   pop CX
jmp near L1a3b18a2
L1a3b188a:
   cmp SI,+5A
   jnz L1a3b18aa
   cmp word ptr [BP-04],+03
   jnz L1a3b18aa
   xor SI,SI
   mov AX,[offset _debug]
   neg AX
   sbb AX,AX
   inc AX
   mov [offset _debug],AX
L1a3b18a2:
   or word ptr [offset _statmodflg],C000
jmp near L1a3b18cf
L1a3b18aa:
   cmp SI,+57
   jnz L1a3b18cf
   cmp word ptr [BP-04],+03
   jnz L1a3b18cf
   call far _getkey
   mov AX,[offset _key]
   add AX,FFD0
   push AX
   call far _pixwrite
   pop CX
   mov word ptr [offset _swrite],0001
   xor SI,SI
L1a3b18cf:
   mov AX,[offset _key]
   cmp AX,004E
   jz L1a3b18e3
   cmp AX,0050
   jz L1a3b1903
   cmp AX,0054
   jz L1a3b18f0
jmp near L1a3b1934
L1a3b18e3:
   mov AX,[offset _soundf]
   neg AX
   sbb AX,AX
   inc AX
   mov [offset _soundf],AX
jmp near L1a3b18fb
L1a3b18f0:
   mov AX,[offset _turtle]
   neg AX
   sbb AX,AX
   inc AX
   mov [offset _turtle],AX
L1a3b18fb:
   or word ptr [offset _statmodflg],C000
jmp near L1a3b1934
L1a3b1903:
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   call far _sb_update
   cmp word ptr [offset _key],+00
   jnz L1a3b1934
   cmp word ptr [offset _fire1],+00
   jnz L1a3b1934
   cmp word ptr [offset _fire2],+00
   jnz L1a3b1934
   cmp word ptr [offset _dx1],+00
   jnz L1a3b1934
   cmp word ptr [offset _dy1],+00
   jz L1a3b1903
L1a3b1934:
   cmp word ptr [BP+06],+00
   jz L1a3b1963
   cmp word ptr [offset _xdemoflag],+00
   jnz L1a3b1963
   mov AX,0043
   push AX
   call far _countobj
   pop CX
   or AX,AX
   jnz L1a3b1963
   push [offset _objs+03]
   push [offset _objs+01]
   mov AX,0043
   push AX
   call far _addobj
   add SP,+06
L1a3b1963:
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
   mov BX,offset Y1a3b19a6
L1a3b1996:
   cmp AX,[CS:BX]
   jz L1a3b19a2
   inc BX
   inc BX
   loop L1a3b1996
jmp near L1a3b1a46
L1a3b19a2:
jmp near [CS:BX+0A]

Y1a3b19a6:	dw 001b,0051,0052,0053,00bb
		dw L1a3b1a27,L1a3b1a27,L1a3b19e1,L1a3b19ba,L1a3b1a1c

L1a3b19ba:
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
jmp near L1a3b1a14
L1a3b19e1:
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
L1a3b1a14:
   mov word ptr [offset _key],0020
jmp near L1a3b1a46
L1a3b1a1c:
   mov AX,0001
   push AX
   push CS
   call near offset _dotextmsg
   pop CX
jmp near L1a3b1a46
L1a3b1a27:
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
L1a3b1a46:
   cmp word ptr [BP+06],+00
   jz L1a3b1a59
   cmp word ptr [offset _macplay],+00
   jnz L1a3b1a59
   mov word ptr [offset _gameover],0001
L1a3b1a59:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,[BP-0A]
   mov DX,[offset _turtle]
   inc DX
   cmp AX,DX
   jl L1a3b1a59
   cmp word ptr [offset _gameover],+00
   jnz L1a3b1a76
jmp near L1a3b15aa
L1a3b1a76:
   mov word ptr [offset _key],0000
   cmp word ptr [offset _gameover],+02
   jnz L1a3b1a8d
   mov AX,00C8
   push AX
   call far _pageview
   pop CX
L1a3b1a8d:
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   cmp word ptr [BP+06],+00
   jnz L1a3b1aa6
   mov AX,0001
   push AX
   call far _printhi
   pop CX
L1a3b1aa6:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_pleasewait: ;; 1a3b1aac
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
   jnz L1a3b1ad4
   cmp byte ptr [offset _x_ourmode],04
   jnz L1a3b1ad4
jmp near L1a3b1cbb
L1a3b1ad4:
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
   mov AX,offset Y24dc153e
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
   mov AX,offset Y24dc1551
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
   mov AX,offset Y24dc155d
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
   jz L1a3b1c17
jmp near L1a3b1ca5
L1a3b1c17:
   xor SI,SI
jmp near L1a3b1c9d
L1a3b1c1c:
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
L1a3b1c9d:
   cmp SI,+05
   jg L1a3b1ca5
jmp near L1a3b1c1c
L1a3b1ca5:
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   call far _fadein
jmp near L1a3b1de5
L1a3b1cbb:
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
jmp near L1a3b1d0d
L1a3b1cda:
   xor DI,DI
jmp near L1a3b1d07
L1a3b1cde:
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
L1a3b1d07:
   cmp DI,+0C
   jl L1a3b1cde
   inc SI
L1a3b1d0d:
   cmp SI,+13
   jl L1a3b1cda
   call far _clrpal
   call far _pageflip
   call far _fadein
   les BX,[offset _myclock]
   mov SI,[ES:BX]
L1a3b1d28:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,SI
   cmp AX,0050
   jl L1a3b1d28
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
   mov word ptr [offset _shm_want+2*2F],0001
   mov word ptr [offset _shm_want+2*22],0000
   call far _shm_do
   xor SI,SI
jmp near L1a3b1da8
L1a3b1d75:
   xor DI,DI
jmp near L1a3b1da2
L1a3b1d79:
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
L1a3b1da2:
   cmp DI,+0C
   jl L1a3b1d79
   inc SI
L1a3b1da8:
   cmp SI,+13
   jl L1a3b1d75
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   call far _clrpal
   call far _pageflip
   call far _fadein
   les BX,[offset _myclock]
   mov SI,[ES:BX]
L1a3b1dcc:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,SI
   cmp AX,003C
   jl L1a3b1dcc
   mov word ptr [offset _shm_want+2*2F],0000
   call far _shm_do
L1a3b1de5:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_printhi: ;; 1a3b1deb
   push BP
   mov BP,SP
   sub SP,+14
   push SI
   push DI
   cmp word ptr [BP+06],+00
   jz L1a3b1dfe
   mov AX,0004
jmp near L1a3b1e01
L1a3b1dfe:
   mov AX,0008
L1a3b1e01:
   mov [BP-02],AX
   cmp word ptr [BP+06],+00
   jnz L1a3b1e0d
jmp near L1a3b1eb0
L1a3b1e0d:
   mov DI,000A
jmp near L1a3b1e13
L1a3b1e12:
   dec DI
L1a3b1e13:
   or DI,DI
   jle L1a3b1e34
   mov BX,DI
   dec BX
   shl BX,1
   shl BX,1
   mov DX,[BX+offset _hiscore+2]
   mov AX,[BX+offset _hiscore+0]
   cmp DX,[offset _pl+2*14]
   jl L1a3b1e12
   jnz L1a3b1e34
   cmp AX,[offset _pl+2*13]
   jb L1a3b1e12
L1a3b1e34:
   cmp DI,+0A
   jl L1a3b1e40
   mov word ptr [BP+06],0000
jmp near L1a3b1eb0
L1a3b1e40:
   mov SI,0008
jmp near L1a3b1e84
L1a3b1e45:
   mov BX,SI
   shl BX,1
   shl BX,1
   mov DX,[BX+offset _hiscore+2]
   mov AX,[BX+offset _hiscore+0]
   mov BX,SI
   inc BX
   shl BX,1
   shl BX,1
   mov [BX+offset _hiscore+2],DX
   mov [BX+offset _hiscore+0],AX
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
L1a3b1e84:
   cmp SI,DI
   jge L1a3b1e45
   mov DX,[offset _pl+2*14]
   mov AX,[offset _pl+2*13]
   mov BX,DI
   shl BX,1
   shl BX,1
   mov [BX+offset _hiscore+2],DX
   mov [BX+offset _hiscore+0],AX
   mov AX,DI
   mov DX,000A
   mul DX
   mov BX,AX
   add BX,offset _hiname
   push DS
   pop ES
   mov byte ptr [ES:BX],00
L1a3b1eb0:
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
   mov AX,offset Y24dc1579
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
   mov AX,offset Y24dc1586
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
jmp near L1a3b1f76
L1a3b1f46:
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
L1a3b1f76:
   cmp SI,+0A
   jl L1a3b1f46
   push [BP-02]
   mov AX,0006
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   xor SI,SI
jmp near L1a3b2015
L1a3b1f97:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   mov BX,SI
   shl BX,1
   shl BX,1
   push [BX+offset _hiscore+2]
   push [BX+offset _hiscore+0]
   call far _ltoa
   add SP,+0A
   mov word ptr [BP-14],0000
jmp near L1a3b2008
L1a3b1fbd:
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
L1a3b2008:
   lea BX,[BP-12]
   add BX,[BP-14]
   cmp byte ptr [SS:BX],00
   jnz L1a3b1fbd
   inc SI
L1a3b2015:
   cmp SI,+0A
   jge L1a3b201d
jmp near L1a3b1f97
L1a3b201d:
   cmp word ptr [BP+06],+00
   jnz L1a3b2026
jmp near L1a3b20f7
L1a3b2026:
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
   push [BX+offset _hiscore+0]
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
   jnb L1a3b209d
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
jmp near L1a3b20a0
L1a3b209d:
   mov SI,000C
L1a3b20a0:
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
   jnz L1a3b20eb
   push CS
   call near offset _loadcfg
jmp near L1a3b20ef
L1a3b20eb:
   push CS
   call near offset _savecfg
L1a3b20ef:
   xor AX,AX
   push AX
   push CS
   call near offset _printhi
   pop CX
L1a3b20f7:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_loadsavewin: ;; 1a3b20fd
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
   mov AX,offset Y24dc1590
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
   mov AX,offset Y24dc159d
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
jmp near L1a3b2213
L1a3b21d3:
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
L1a3b2213:
   cmp word ptr [BP-10],+06
   jl L1a3b21d3
   mov word ptr [BP-10],0000
jmp near L1a3b229a
L1a3b2220:
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
   jz L1a3b226c
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
jmp near L1a3b2297
L1a3b226c:
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
L1a3b2297:
   inc word ptr [BP-10]
L1a3b229a:
   cmp word ptr [BP-10],+06
   jge L1a3b22a3
jmp near L1a3b2220
L1a3b22a3:
   mov AX,0001
   push AX
   mov AX,0002
   push AX
   push [offset _cmdvp+02]
   push [offset _cmdvp]
   call far _fontcolor
   add SP,+08
   push DS
   mov AX,offset Y24dc15aa
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
   mov AX,offset Y24dc15b0
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
   mov AX,offset Y24dc15b9
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
L1a3b234e:
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
   mov AX,[offset Y24dc13de]
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
L1a3b239c:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   cmp AX,SI
   jz L1a3b239c
   push DS
   mov AX,offset Y24dc15c0
   push AX
   mov AX,0002
   push AX
   mov AX,[offset Y24dc13de]
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
   mov AX,[offset Y24dc13de]
   add AX,[offset _dx1]
   add AX,[offset _dy1]
   cmp AX,0005
   jge L1a3b23ee
   mov AX,[offset Y24dc13de]
   add AX,[offset _dx1]
   add AX,[offset _dy1]
jmp near L1a3b23f1
L1a3b23ee:
   mov AX,0005
L1a3b23f1:
   or AX,AX
   jge L1a3b23f9
   xor AX,AX
jmp near L1a3b2419
L1a3b23f9:
   mov AX,[offset Y24dc13de]
   add AX,[offset _dx1]
   add AX,[offset _dy1]
   cmp AX,0005
   jge L1a3b2416
   mov AX,[offset Y24dc13de]
   add AX,[offset _dx1]
   add AX,[offset _dy1]
jmp near L1a3b2419
L1a3b2416:
   mov AX,0005
L1a3b2419:
   mov [offset Y24dc13de],AX
   cmp word ptr [offset _fire1],+00
   jnz L1a3b2434
   cmp word ptr [offset _key],+0D
   jz L1a3b2434
   cmp word ptr [offset _key],+1B
   jz L1a3b2434
jmp near L1a3b234e
L1a3b2434:
   cmp word ptr [offset _key],+1B
   jnz L1a3b2440
   mov AX,FFFF
jmp near L1a3b2443
L1a3b2440:
   mov AX,[offset Y24dc13de]
L1a3b2443:
   pop SI
   mov SP,BP
   pop BP
ret far

_loadgame: ;; 1a3b2448
   push BP
   mov BP,SP
   sub SP,+50
   push SI
   push DI
   push DS
   mov AX,offset Y24dc15cc
   push AX
   push DS
   mov AX,offset Y24dc15c2
   push AX
   push CS
   call near offset _loadsavewin
   add SP,+08
   mov SI,AX
   or SI,SI
   jge L1a3b246a
jmp near L1a3b2573
L1a3b246a:
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
   jnz L1a3b2484
jmp near L1a3b2573
L1a3b2484:
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
   mov AX,offset Y24dc15d4
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
   mov AX,offset Y24dc15d6
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
   jz L1a3b2563
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
L1a3b2563:
   push SS
   lea AX,[BP-40]
   push AX
   push CS
   call near offset _loadboard
   pop CX
   pop CX
   mov AX,0001
jmp near L1a3b2575
L1a3b2573:
   xor AX,AX
L1a3b2575:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_savegame: ;; 1a3b257b
   push BP
   mov BP,SP
   sub SP,+5C
   push SI
   push DI
   push DS
   mov AX,offset Y24dc15e3
   push AX
   push DS
   mov AX,offset Y24dc15d9
   push AX
   push CS
   call near offset _loadsavewin
   add SP,+08
   mov SI,AX
   or SI,SI
   jge L1a3b259d
jmp near L1a3b26fb
L1a3b259d:
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
   jnz L1a3b25ed
jmp near L1a3b26fb
L1a3b25ed:
   push SS
   lea AX,[BP-0C]
   push AX
   call far _strlen
   pop CX
   pop CX
   or AX,AX
   jnz L1a3b2600
jmp near L1a3b26fb
L1a3b2600:
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
   mov AX,offset Y24dc15e4
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
   mov AX,offset Y24dc15e6
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
   jz L1a3b26f7
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
L1a3b26f7:
   push CS
   call near offset _savecfg
L1a3b26fb:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_drawgamewin: ;; 1a3b2701
   push BP
   mov BP,SP
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
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _fontcolor
   add SP,+08
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _clearvp
   pop CX
   pop CX
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _fontcolor
   add SP,+08
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _clearvp
   pop CX
   pop CX
   mov AX,FFFF
   push AX
   push [offset _xbordercol]
   push DS
   mov AX,B27C
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
   mov AX,offset Y24dc15e9
   push AX
   push DS
   mov AX,offset _ourwin
   push AX
   call far _titlebot
   add SP,+08
   push DS
   mov AX,offset Y24dc15f3
   push AX
   push DS
   mov AX,offset _ourwin
   push AX
   call far _titletop
   add SP,+08
   pop BP
ret far

_noisemaker: ;; 1a3b27de
   push BP
   mov BP,SP
   sub SP,+34
   push SI
   push SS
   lea AX,[BP-34]
   push AX
   push DS
   mov AX,13E0
   push AX
   mov CX,0034
   call far SCOPY@
   mov word ptr [offset _fire1off],0000
L1a3b27fd:
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
jmp near L1a3b2837
L1a3b281c:
   mov AL,[SS:BP+SI-34]
   cbw
   cmp AX,[offset _key]
   jnz L1a3b2836
   mov AX,SI
   inc AX
   push AX
   mov AX,0001
   push AX
   call far _snd_play
   pop CX
   pop CX
L1a3b2836:
   inc SI
L1a3b2837:
   cmp byte ptr [SS:BP+SI-34],00
   jnz L1a3b281c
   cmp word ptr [offset _key],+0D
   jz L1a3b284c
   cmp word ptr [offset _key],+1B
   jnz L1a3b27fd
L1a3b284c:
   pop SI
   mov SP,BP
   pop BP
ret far

_pageview: ;; 1a3b2851
   push BP
   mov BP,SP
   sub SP,+12
   push SI
   push DI
   mov word ptr [offset _scrnxs],0014
   mov word ptr [offset _scrnys],000D
L1a3b2865:
   mov SI,FFFF
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
   push CS
   call near offset _fout
   xor DI,DI
jmp near L1a3b28aa
L1a3b287a:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],0C
   jnz L1a3b28a9
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[BP+06]
   jnz L1a3b28a9
   mov SI,DI
L1a3b28a9:
   inc DI
L1a3b28aa:
   cmp DI,[offset _numobjs]
   jl L1a3b287a
   or SI,SI
   jg L1a3b28b7
jmp near L1a3b29c4
L1a3b28b7:
   mov AX,0010
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _memcpy
   add SP,+0A
   cmp word ptr [BP+06],+63
   jnz L1a3b295a
   push CS
   call near offset _noisemaker
jmp near L1a3b2995
L1a3b295a:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   mov [BP-02],AX
   mov word ptr [offset _fire1off],0001
L1a3b296a:
   xor AX,AX
   push AX
   call far _checkctrl0
   pop CX
   call far _sb_update
   cmp word ptr [offset _key],+00
   jnz L1a3b2986
   cmp word ptr [offset _fire1],+00
   jz L1a3b296a
L1a3b2986:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,[BP-02]
   cmp AX,0012
   jl L1a3b296a
L1a3b2995:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L1a3b29c4
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+05]
   mov [BP+06],AX
jmp near L1a3b2865
L1a3b29c4:
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

_domenu: ;; 1a3b29fe
   push BP
   mov BP,SP
   sub SP,00B2
   push SI
   push DI
   xor DI,DI
   mov [BP-54],DI
   mov word ptr [BP-52],0001
   les BX,[BP+06]
   mov [offset _textmsg+2],ES
   mov [offset _textmsg+0],BX
   push [offset _textmsg+2]
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
   lea AX,[BP+FF4E]
   push AX
   call far _defwin
   add SP,+12
   push SS
   lea AX,[BP+FF4E]
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
jmp near L1a3b2adb
L1a3b2a81:
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
   lea AX,[BP+FF76]
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
   jl L1a3b2ac3
   mov AX,0001
jmp near L1a3b2ac5
L1a3b2ac3:
   xor AX,AX
L1a3b2ac5:
   mul word ptr [BP+14]
   add AX,0004
   push AX
   push SS
   lea AX,[BP+FF76]
   push AX
   call far _wprint
   add SP,+0E
   dec SI
L1a3b2adb:
   or SI,SI
   jge L1a3b2a81
   call far _pageflip
   xor AX,AX
   push AX
   call far _setpagemode
   pop CX
   xor SI,SI
L1a3b2aef:
   call far _sb_update
   inc DI
   mov AX,DI
   cmp AX,000C
   jl L1a3b2afe
   xor DI,DI
L1a3b2afe:
   test DI,0001
   jnz L1a3b2b0b
   mov AX,[BP-52]
   cmp AX,SI
   jz L1a3b2b66
L1a3b2b0b:
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
   lea AX,[BP+FF76]
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
   lea AX,[BP+FF76]
   push AX
   call far _drawshape
   add SP,+0A
L1a3b2b66:
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
   jz L1a3b2bd9
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,[BP-54]
   cwd
   xor AX,DX
   sub AX,DX
   cmp AX,0001
   jle L1a3b2bd9
   mov AX,[ES:BX]
   mov [BP-54],AX
   mov AX,[offset _dx1]
   add AX,[offset _dy1]
   add SI,AX
   or SI,SI
   jge L1a3b2bb3
   xor AX,AX
jmp near L1a3b2bb5
L1a3b2bb3:
   mov AX,SI
L1a3b2bb5:
   mov DX,[BP+10]
   dec DX
   cmp AX,DX
   jle L1a3b2bc3
   mov AX,[BP+10]
   dec AX
jmp near L1a3b2bcd
L1a3b2bc3:
   or SI,SI
   jge L1a3b2bcb
   xor AX,AX
jmp near L1a3b2bcd
L1a3b2bcb:
   mov AX,SI
L1a3b2bcd:
   mov SI,AX
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   mov [BP-5A],AX
L1a3b2bd9:
   les BX,[offset _myclock]
   mov AX,[ES:BX]
   sub AX,[BP-5A]
   cmp AX,012C
   jle L1a3b2bf7
   cmp word ptr [BP+12],+00
   jz L1a3b2bf7
   mov word ptr [offset _key],0044
jmp near L1a3b2c69
L1a3b2bf7:
   mov word ptr [BP-58],0000
   cmp word ptr [offset _key],+1B
   jnz L1a3b2c09
   mov word ptr [offset _key],0051
L1a3b2c09:
   cmp word ptr [offset _key],+0D
   jz L1a3b2c1e
   cmp word ptr [offset _key],+20
   jz L1a3b2c1e
   cmp word ptr [offset _fire1],+00
   jz L1a3b2c2f
L1a3b2c1e:
   les BX,[BP+0A]
   mov AL,[ES:BX+SI]
   cbw
   mov [offset _key],AX
   mov word ptr [BP-58],0001
jmp near L1a3b2c60
L1a3b2c2f:
   mov word ptr [BP-56],0000
jmp near L1a3b2c4e
L1a3b2c36:
   les BX,[BP+0A]
   add BX,[BP-56]
   mov AL,[ES:BX]
   cbw
   cmp AX,[offset _key]
   jnz L1a3b2c4b
   mov word ptr [BP-58],0001
L1a3b2c4b:
   inc word ptr [BP-56]
L1a3b2c4e:
   push [BP+0C]
   push [BP+0A]
   call far _strlen
   pop CX
   pop CX
   cmp AX,[BP-56]
   ja L1a3b2c36
L1a3b2c60:
   cmp word ptr [BP-58],+00
   jnz L1a3b2c69
jmp near L1a3b2aef
L1a3b2c69:
   mov AX,[offset _key]
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_askquit: ;; 1a3b2c72
   push BP
   mov BP,SP
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
   mov AX,offset Y24dc1614
   push AX
   push DS
   mov AX,offset Y24dc15fc
   push AX
   push CS
   call near offset _domenu
   add SP,+14
   cmp word ptr [offset _key],+59
   jnz L1a3b2cb8
   mov AX,0001
jmp near L1a3b2cba
L1a3b2cb8:
   xor AX,AX
L1a3b2cba:
   pop BP
ret far

_dodemo: ;; 1a3b2cbc
   push BP
   mov BP,SP
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
L1a3b2ce7:
   cmp word ptr [offset _demonum],+00
   jz L1a3b2cfc
   push CS
   call near offset _fout
   mov AX,0001
   push AX
   call far _setpagemode
   pop CX
L1a3b2cfc:
   mov BX,[offset _demonum]
   cmp byte ptr [BX+offset _demolvl],00
   jnz L1a3b2d0d
   mov word ptr [offset _demonum],0000
L1a3b2d0d:
   mov BX,[offset _demonum]
   shl BX,1
   shl BX,1
   push [BX+offset _demoboard+2]
   push [BX+offset _demoboard+0]
   push CS
   call near offset _loadboard
   pop CX
   pop CX
   mov BX,[offset _demonum]
   mov AL,[BX+offset _demolvl]
   cbw
   mov [offset _pl+2*00],AX
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
   push [BX+offset _demoname+2]
   push [BX+offset _demoname+0]
   call far _playmac
   pop CX
   pop CX
   cmp word ptr [offset _macplay],+00
   jz L1a3b2d80
   mov AX,0001
   push AX
   push CS
   call near offset _play
   pop CX
   call far _stopmac
   inc word ptr [offset _demonum]
jmp near L1a3b2d86
L1a3b2d80:
   mov word ptr [offset _macaborted],0001
L1a3b2d86:
   cmp word ptr [offset _macaborted],+00
   jnz L1a3b2d90
jmp near L1a3b2ce7
L1a3b2d90:
   pop BP
ret far

_jmenu: ;; 1a3b2d92
   push BP
   mov BP,SP
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
L1a3b2da4:
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
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _fontcolor
   add SP,+08
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _clearvp
   pop CX
   pop CX
   cmp word ptr [offset _facetable],+00
   jz L1a3b2e3e
   cmp byte ptr [offset _x_ourmode],04
   jnz L1a3b2e3e
   xor SI,SI
jmp near L1a3b2e37
L1a3b2e04:
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
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _drawshape
   add SP,+0A
   inc SI
L1a3b2e37:
   cmp SI,+10
   jl L1a3b2e04
jmp near L1a3b2e84
L1a3b2e3e:
   push [offset _leveltxt+4*1E+2]
   push [offset _leveltxt+4*1E+0]
   mov AX,0002
   push AX
   mov AX,001C
   push AX
   xor AX,AX
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _wprint
   add SP,+0E
   push [offset _leveltxt+4*1F+2]
   push [offset _leveltxt+4*1F+0]
   mov AX,0002
   push AX
   mov AX,0024
   push AX
   xor AX,AX
   push AX
   push [offset _statvp+2]
   push [offset _statvp+0]
   call far _wprint
   add SP,+0E
L1a3b2e84:
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
   jnz L1a3b2ef0
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
jmp near L1a3b3070
L1a3b2ef0:
   cmp word ptr [offset _key],+1B
   jz L1a3b2efe
   cmp word ptr [offset _key],+51
   jnz L1a3b2f04
L1a3b2efe:
   mov DI,0001
jmp near L1a3b3070
L1a3b2f04:
   cmp word ptr [offset _key],+50
   jnz L1a3b2f48
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
   mov [offset _pl+2*00],AX
   xor AX,AX
   push AX
   call far _p_reenter
   pop CX
   push CS
   call near offset _drawboard
jmp near L1a3b2fd1
L1a3b2f48:
   cmp word ptr [offset _key],+10
   jnz L1a3b2f88
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
jmp near L1a3b3070
L1a3b2f88:
   cmp word ptr [offset _key],+45
   jnz L1a3b2f9b
   mov AX,0014
   push AX
   push CS
   call near offset _pageview
   pop CX
jmp near L1a3b3070
L1a3b2f9b:
   cmp word ptr [offset _key],+52
   jnz L1a3b2fed
   push CS
   call near offset _loadgame
   or AX,AX
   jnz L1a3b2fad
jmp near L1a3b3070
L1a3b2fad:
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
L1a3b2fd1:
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
jmp near L1a3b3047
L1a3b2fed:
   cmp word ptr [offset _key],+53
   jnz L1a3b2fff
   xor AX,AX
   push AX
   push CS
   call near offset _pageview
   pop CX
jmp near L1a3b3070
L1a3b2fff:
   cmp word ptr [offset _key],+49
   jnz L1a3b3011
   mov AX,0001
   push AX
   push CS
   call near offset _dotextmsg
   pop CX
jmp near L1a3b3070
L1a3b3011:
   cmp word ptr [offset _key],+4F
   jz L1a3b301f
   cmp word ptr [offset _key],+48
   jnz L1a3b302a
L1a3b301f:
   mov AX,0008
   push AX
   push CS
   call near offset _pageview
   pop CX
jmp near L1a3b3070
L1a3b302a:
   cmp word ptr [offset _key],+43
   jnz L1a3b303c
   mov AX,000C
   push AX
   push CS
   call near offset _pageview
   pop CX
jmp near L1a3b3070
L1a3b303c:
   cmp word ptr [offset _key],+44
   jnz L1a3b3060
   push CS
   call near offset _dodemo
L1a3b3047:
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
jmp near L1a3b3070
L1a3b3060:
   cmp word ptr [offset _key],+4E
   jnz L1a3b3070
   mov AX,0063
   push AX
   push CS
   call near offset _pageview
   pop CX
L1a3b3070:
   or DI,DI
   jnz L1a3b3077
jmp near L1a3b2da4
L1a3b3077:
   pop DI
   pop SI
   pop BP
ret far

_main: ;; 1a3b307b
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
   mov AX,offset Y24dc1617
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
   jnz L1a3b3139
jmp near L1a3b3347
L1a3b3139:
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
   mov word ptr [offset _shm_want+2*0E],0001
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
   mov [offset _gamevp+2],DS
   mov word ptr [offset _gamevp+0],offset _ourwin+28
   mov [offset _cmdvp+02],DS
   mov word ptr [offset _cmdvp],offset _ourwin+38
   mov [offset _statvp+2],DS
   mov word ptr [offset _statvp+0],offset _ourwin+48
   mov word ptr [offset _botvp+08],0000
   mov word ptr [offset _botvp+0A],0000
   mov word ptr [offset _botvp+00],0000
   mov word ptr [offset _botvp+02],00BC
   mov word ptr [offset _botvp+04],0140
   mov word ptr [offset _botvp+06],000C
   mov word ptr [offset _scrnxs],000F
   mov word ptr [offset _scrnys],000B
   cmp word ptr [offset _facetable],+00
   jz L1a3b3298
   cmp byte ptr [offset _x_ourmode],04
   jnz L1a3b3298
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
   mov AX,[offset _levelwin+2A]
   mov [offset _levelwin+3A],AX
   mov AX,[offset _levelwin+2E]
   mov [offset _levelwin+3E],AX
jmp near L1a3b32b9
L1a3b3298:
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
L1a3b32b9:
   call far _initinfo
   call far _initobjinfo
   push CS
   call near offset _initboard
   call far _initobjs
   cmp word ptr [offset _xdemoflag],+00
   jz L1a3b3304
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
jmp near L1a3b3328
L1a3b3304:
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
L1a3b3328:
   push CS
   call near offset _fout
   push DS
   mov AX,offset _ourwin
   push AX
   call far _undrawwin
   mov SP,BP
   call far _shm_exit
   call far _gr_exit
   call far _snd_exit
L1a3b3347:
   call far _gc_exit
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
   jz L1a3b33a5
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
L1a3b33a5:
   pop BP
ret far

_rexit: ;; 1a3b33a7
   push BP
   mov BP,SP
   sub SP,+0C
   call far _shm_exit
   call far _gr_exit
   call far _snd_exit
   call far _gc_exit
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
   mov AX,offset Y24dc161c
   push AX
   call far _cputs
   pop CX
   pop CX
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-0C]
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
   mov AX,offset Y24dc1656
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc165a
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
   mov AX,offset Y24dc165d
   push AX
   call far _cputs
   pop CX
   pop CX
   cmp word ptr [BP+06],+09
   jnz L1a3b34a1
   push DS
   mov AX,offset Y24dc1662
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc16aa
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc16d6
   push AX
   call far _cputs
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc170e
   push AX
   call far _cputs
   pop CX
   pop CX
   cmp word ptr [offset _vocflag],+00
   jz L1a3b34ad
   push DS
   mov AX,offset Y24dc173f
   push AX
   call far _cputs
   pop CX
   pop CX
jmp near L1a3b34ad
L1a3b34a1:
   push DS
   mov AX,offset Y24dc178b
   push AX
   call far _cputs
   pop CX
   pop CX
L1a3b34ad:
   mov AX,0001
   push AX
   call far _exit
   pop CX
   mov SP,BP
   pop BP
ret far

Segment 1d86 ;; JINFO.C:JINFO
_initinfo: ;; 1d86000b
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov DI,4006
   mov word ptr [BP-06],0000
jmp near L1d860060
L1d86001d:
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
   mov word ptr [ES:BX+04],offset Y24dc17ca
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   mov [ES:BX+02],DI
   inc word ptr [BP-06]
L1d860060:
   cmp word ptr [BP-06],0258
   jl L1d86001d
   mov AX,8000
   push AX
   push DS
   mov AX,offset _dmafile
   push AX
   call far _open
   add SP,+06
   mov SI,AX
jmp near L1d86013d
L1d86007d:
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
L1d86013d:
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   push SI
   call far _read
   add SP,+08
   or AX,AX
   jle L1d860156
jmp near L1d86007d
L1d860156:
   mov word ptr [BP-06],0000
jmp near L1d86016b
L1d86015d:
   mov BX,[BP-06]
   shl BX,1
   mov word ptr [BX+offset _stateinfo],0000
   inc word ptr [BP-06]
L1d86016b:
   cmp word ptr [BP-06],+06
   jl L1d86015d
   or word ptr [offset _stateinfo+2*4],0002
   or word ptr [offset _stateinfo+2*0],0001
   or word ptr [offset _stateinfo+2*2],0001
   or word ptr [offset _stateinfo+2*3],0000
   or word ptr [offset _stateinfo+2*5],0002
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1d9f ;; DESIGN.C:DESIGN
_infname: ;; 1d9f0005
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

_printobjinfo: ;; 1d9f0051
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   mov SI,[BP+06]
   push DS
   mov AX,offset Y24dc17ce
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
   push [BX+offset _kindname+2]
   push [BX+offset _kindname+0]
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
   mov AX,offset Y24dc17e0
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
   mov AX,offset Y24dc17f2
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
   mov AX,offset Y24dc1804
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
   mov AX,offset Y24dc1816
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
   jz L1d9f025a
   push DS
   mov AX,offset Y24dc1828
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
L1d9f025a:
   pop SI
   mov SP,BP
   pop BP
ret far

_objdesign: ;; 1d9f025f
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
jmp near L1d9f02e9
L1d9f028f:
   mov AX,[BP-4A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,DI
   jnz L1d9f02e6
   mov AX,[BP-4A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP+08]
   jnz L1d9f02e6
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
L1d9f02e6:
   inc word ptr [BP-4A]
L1d9f02e9:
   mov AX,[BP-4A]
   cmp AX,[offset _numobjs]
   jl L1d9f028f
   cmp SI,-01
   jnz L1d9f02ff
   mov [BP-42],DS
   mov word ptr [BP-44],offset Y24dc1834
L1d9f02ff:
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc1839
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
   mov AX,offset Y24dc1845
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
   mov AX,offset Y24dc1850
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
   mov AX,offset Y24dc185a
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
   jbe L1d9f03d7
jmp near L1d9f04f9
L1d9f03d7:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y1d9f03e0]

Y1d9f03e0:	dw L1d9f0400,L1d9f04f9,L1d9f04f9,L1d9f041c,L1d9f04f9,L1d9f04f9,L1d9f04f9,L1d9f04f9
		dw L1d9f04f9,L1d9f04f9,L1d9f04e8,L1d9f04f9,L1d9f04f2,L1d9f04f9,L1d9f04b3,L1d9f0439

L1d9f0400:
   mov SI,[offset _numobjs]
   push [BP+08]
   push DI
   mov AX,0003
   push AX
   call far _addobj
   add SP,+06
L1d9f0414:
   mov word ptr [BP-46],0001
jmp near L1d9f04f9
L1d9f041c:
   or SI,SI
   jg L1d9f0423
jmp near L1d9f099b
L1d9f0423:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov byte ptr [ES:BX],03
jmp near L1d9f099b
L1d9f0439:
   push [BP+08]
   push DI
   mov AX,[offset Y24dc17cc]
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
   mov AX,[offset Y24dc17cc]
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
jmp near L1d9f099b
L1d9f04b3:
   mov AX,[offset Y24dc17cc]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov [ES:BX+01],DI
   mov AX,[BP+08]
   push AX
   mov AX,[offset Y24dc17cc]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
   call far _drawboard
jmp near L1d9f099b
L1d9f04e8:
   or SI,SI
   jl L1d9f04f9
   mov [offset Y24dc17cc],SI
jmp near L1d9f04f9
L1d9f04f2:
   or SI,SI
   jl L1d9f04f9
jmp near L1d9f0414
L1d9f04f9:
   cmp word ptr [BP-46],+00
   jnz L1d9f0502
jmp near L1d9f09a0
L1d9f0502:
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
   push [BX+offset _kindname+2]
   push [BX+offset _kindname+0]
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
jmp near L1d9f05a6
L1d9f056a:
   mov BX,[BP-4A]
   shl BX,1
   shl BX,1
   push [BX+offset _kindname+2]
   push [BX+offset _kindname+0]
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L1d9f05a3
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
jmp near L1d9f05ac
L1d9f05a3:
   inc word ptr [BP-4A]
L1d9f05a6:
   cmp word ptr [BP-4A],+45
   jl L1d9f056a
L1d9f05ac:
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
   jz L1d9f061f
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
L1d9f061f:
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
   jz L1d9f0692
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
L1d9f0692:
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
   jz L1d9f0705
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
L1d9f0705:
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
   jz L1d9f0778
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
L1d9f0778:
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
   jnz L1d9f07fa
jmp near L1d9f096d
L1d9f07fa:
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
   jnz L1d9f081c
   mov word ptr [BP-48],0001
jmp near L1d9f0821
L1d9f081c:
   mov word ptr [BP-48],0002
L1d9f0821:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jnz L1d9f0840
   mov byte ptr [BP-40],00
jmp near L1d9f0864
L1d9f0840:
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
L1d9f0864:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
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
   jz L1d9f0913
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
L1d9f0913:
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
L1d9f096d:
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
   mov word ptr [BX+offset _shm_want+2*00],0001
   call far _shm_do
L1d9f099b:
   mov AX,0001
jmp near L1d9f09a2
L1d9f09a0:
   xor AX,AX
L1d9f09a2:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_design: ;; 1d9f09a8
   push BP
   mov BP,SP
   sub SP,+4A
   push SI
   push DI
   mov word ptr [BP-4A],0000
   mov word ptr [BP-46],0001
   mov word ptr [BP-42],0000
   mov word ptr [offset _disy],0000
   mov word ptr [offset _designflag],0001
   mov byte ptr [BP-40],00
   mov byte ptr [BP-20],00
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
L1d9f09f0:
   cmp word ptr [BP-42],+00
   jz L1d9f0a21
   mov AX,[BP-46]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   push SI
   push DI
   call far _drawcell
   pop CX
   pop CX
   mov word ptr [BP-4A],0001
L1d9f0a21:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _drawshape
   add SP,+0A
L1d9f0a49:
   xor AX,AX
   push AX
   call far _checkctrl
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L1d9f0a6d
   cmp word ptr [offset _dy1],+00
   jnz L1d9f0a6d
   cmp word ptr [offset _key],+00
   jnz L1d9f0a6d
   cmp word ptr [BP-4A],+00
   jz L1d9f0a49
L1d9f0a6d:
   mov word ptr [BP-4A],0000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
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
   jnz L1d9f0ab1
   cmp word ptr [offset _dy1],+00
   jnz L1d9f0ab1
jmp near L1d9f0bff
L1d9f0ab1:
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
   jge L1d9f0ade
   xor DI,DI
L1d9f0ade:
   cmp DI,0080
   jl L1d9f0ae7
   mov DI,007F
L1d9f0ae7:
   or SI,SI
   jge L1d9f0aed
   xor SI,SI
L1d9f0aed:
   cmp SI,+40
   jl L1d9f0af5
   mov SI,003F
L1d9f0af5:
   mov AX,DI
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   cmp AX,[ES:BX+08]
   jge L1d9f0b24
   mov AX,[offset _scrnxs]
   shl AX,1
   shl AX,1
   shl AX,1
   sub [ES:BX+08],AX
   cmp word ptr [ES:BX+08],+00
   jge L1d9f0b1f
   mov word ptr [ES:BX+08],0000
L1d9f0b1f:
   call far _drawboard
L1d9f0b24:
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
   jg L1d9f0b7d
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
   jl L1d9f0b78
   mov AX,0080
   sub AX,[offset _scrnxs]
   mov CL,04
   shl AX,CL
   add AX,0008
   mov [ES:BX+08],AX
L1d9f0b78:
   call far _drawboard
L1d9f0b7d:
   mov AX,SI
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   cmp AX,[ES:BX+0A]
   jge L1d9f0bac
   mov AX,[offset _scrnys]
   shl AX,1
   shl AX,1
   shl AX,1
   sub [ES:BX+0A],AX
   cmp word ptr [ES:BX+0A],+00
   jge L1d9f0ba7
   mov word ptr [ES:BX+0A],0000
L1d9f0ba7:
   call far _drawboard
L1d9f0bac:
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
   jg L1d9f0bff
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
   jl L1d9f0bfa
   mov AX,0040
   sub AX,[offset _scrnys]
   inc AX
   mov CL,04
   shl AX,CL
   mov [ES:BX+0A],AX
L1d9f0bfa:
   call far _drawboard
L1d9f0bff:
   push [offset _key]
   call far _toupper
   pop CX
   mov CX,000E
   mov BX,offset Y1d9f0c1f
L1d9f0c0f:
   cmp AX,[CS:BX]
   jz L1d9f0c1b
   inc BX
   inc BX
   loop L1d9f0c0f
jmp near L1d9f1019
L1d9f0c1b:
jmp near [CS:BX+1C]

Y1d9f0c1f:	dw 0009,000d,0020,0048,0049,004b,004c
		dw 004e,004f,0053,0056,0059,005a,0060
		dw L1d9f0d2e,L1d9f0c57,L1d9f0d5a,L1d9f0dcf,L1d9f0d7f,L1d9f0d3c,L1d9f0ed2
		dw L1d9f0fc9,L1d9f0e8e,L1d9f0ff6,L1d9f0d98,L1d9f0f50,L1d9f0e9c,L1d9f0f12

L1d9f0c57:
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc1860
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
   lea AX,[BP-40]
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
   lea AX,[BP-40]
   push AX
   call far _strupr
   pop CX
   pop CX
   mov word ptr [BP-44],0000
jmp near L1d9f0d25
L1d9f0cb1:
   mov BX,[BP-44]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   push [ES:BX+06]
   push [ES:BX+04]
   push SS
   lea AX,[BP-40]
   push AX
   call far _strcmp
   add SP,+08
   or AX,AX
   jnz L1d9f0d22
   mov AX,[BP-44]
   mov [BP-46],AX
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   mov BX,[BP-44]
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
   mov word ptr [BX+offset _shm_want+2*00],0001
   call far _shm_do
jmp near L1d9f0d77
L1d9f0d22:
   inc word ptr [BP-44]
L1d9f0d25:
   cmp word ptr [BP-44],0258
   jl L1d9f0cb1
jmp near L1d9f0d77
L1d9f0d2e:
   mov AX,[BP-42]
   neg AX
   sbb AX,AX
   inc AX
   mov [BP-42],AX
jmp near L1d9f1019
L1d9f0d3c:
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
   mov [BP-46],AX
jmp near L1d9f1019
L1d9f0d5a:
   mov AX,[BP-46]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
L1d9f0d77:
   mov word ptr [BP-4A],0001
jmp near L1d9f1019
L1d9f0d7f:
   mov word ptr [offset _pl+2*14],0000
   mov word ptr [offset _pl+2*13],0064
   mov AX,0001
   push AX
   call far _printhi
   pop CX
jmp near L1d9f1019
L1d9f0d98:
   cmp word ptr [offset _pl+2*02],+00
   jnz L1d9f0daa
   xor AX,AX
   push AX
   call far _addinv
   pop CX
jmp near L1d9f0db5
L1d9f0daa:
   mov word ptr [offset _pl+2*02],0000
   call far _initinv
L1d9f0db5:
   mov word ptr [offset _pl+2*14],0000
   mov word ptr [offset _pl+2*13],0000
   mov word ptr [offset _pl+2*00],0000
   call far _drawstats
jmp near L1d9f1019
L1d9f0dcf:
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
   mov [BP-44],AX
   mov [BP-48],DI
jmp near L1d9f0e1b
L1d9f0def:
   mov AX,[BP-46]
   or AX,C000
   mov BX,[BP-48]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   push SI
   push [BP-48]
   call far _drawcell
   pop CX
   pop CX
   dec word ptr [BP-48]
L1d9f0e1b:
   mov BX,[BP-48]
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
   cmp AX,[BP-44]
   jz L1d9f0def
   mov AX,DI
   inc AX
   mov [BP-48],AX
jmp near L1d9f0e6d
L1d9f0e41:
   mov AX,[BP-46]
   or AX,C000
   mov BX,[BP-48]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   push SI
   push [BP-48]
   call far _drawcell
   pop CX
   pop CX
   inc word ptr [BP-48]
L1d9f0e6d:
   mov BX,[BP-48]
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
   cmp AX,[BP-44]
   jz L1d9f0e41
jmp near L1d9f1019
L1d9f0e8e:
   push SI
   push DI
   push CS
   call near offset _objdesign
   pop CX
   pop CX
   mov [BP-4A],AX
jmp near L1d9f1019
L1d9f0e9c:
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,offset Y24dc1865
   push AX
   push CS
   call near offset _infname
   add SP,+08
   mov AL,[BP-20]
   cbw
   push AX
   call far _toupper
   pop CX
   cmp AX,0059
   jz L1d9f0ec0
jmp near L1d9f1019
L1d9f0ec0:
   call far _initboard
   call far _initobjs
L1d9f0eca:
   call far _drawboard
jmp near L1d9f1019
L1d9f0ed2:
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,offset Y24dc186c
   push AX
   push CS
   call near offset _infname
   add SP,+08
   cmp byte ptr [BP-20],00
   jnz L1d9f0eec
jmp near L1d9f1019
L1d9f0eec:
   push SS
   lea AX,[BP-20]
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
jmp near L1d9f0eca
L1d9f0f12:
   xor AX,AX
   push AX
   call far _checkctrl
   pop CX
   cmp word ptr [offset _dx1],+00
   jnz L1d9f0f29
   cmp word ptr [offset _dy1],+00
   jz L1d9f0f12
L1d9f0f29:
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _scrollvp
   add SP,+08
jmp near L1d9f1019
L1d9f0f50:
   push DS
   mov AX,offset _ourwin+48
   push AX
   call far _clearvp
   pop CX
   pop CX
   push DS
   mov AX,offset Y24dc1872
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
   lea AX,[BP-40]
   push AX
   push [offset _disy]
   call far _itoa
   add SP,+08
   mov AX,0010
   push AX
   push SS
   lea AX,[BP-40]
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
   lea AX,[BP-40]
   push AX
   call far _atol
   pop CX
   pop CX
   mov [offset _disy],AX
   push SS
   lea AX,[BP-40]
   push AX
   call far _strupr
   pop CX
   pop CX
jmp near L1d9f1019
L1d9f0fc9:
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,offset Y24dc1879
   push AX
   push CS
   call near offset _infname
   add SP,+08
   mov AL,[BP-20]
   cbw
   push AX
   call far _toupper
   pop CX
   cmp AX,0059
   jnz L1d9f1019
   call far _zapobjs
   call far _initboard
jmp near L1d9f1019
L1d9f0ff6:
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,offset Y24dc1884
   push AX
   push CS
   call near offset _infname
   add SP,+08
   cmp byte ptr [BP-20],00
   jz L1d9f1019
   push SS
   lea AX,[BP-20]
   push AX
   call far _saveboard
   pop CX
   pop CX
L1d9f1019:
   cmp word ptr [offset _key],+1B
   jz L1d9f1023
jmp near L1d9f09f0
L1d9f1023:
   mov word ptr [offset _key],0000
   mov word ptr [offset _designflag],0000
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1ea2 ;; JMAN.C:JMAN
_initobjs: ;; 1ea20005
   push BP
   mov BP,SP
   mov word ptr [offset _numobjs],0001
   mov byte ptr [offset _objs],00
   mov word ptr [offset _objs+01],0020
   mov word ptr [offset _objs+03],0020
   mov word ptr [offset _objs+05],0000
   mov word ptr [offset _objs+07],0000
   mov word ptr [offset _objs+0D],0000
   mov word ptr [offset _objs+0F],0000
   mov word ptr [offset _objs+11],0000
   mov word ptr [offset _objs+13],0000
   mov AX,[offset _kindxl]
   mov [offset _objs+09],AX
   mov AX,[offset _kindyl]
   mov [offset _objs+0B],AX
   mov word ptr [offset _objs+1B],0000
   mov word ptr [offset _objs+1D],0000
   mov word ptr [offset _objs+19],0000
   mov word ptr [offset _objs+17],0000
   mov word ptr [offset _pl+2*02],0000
   mov word ptr [offset _pl+2*00],0001
   call far _initinv
   mov AL,00
   push AX
   mov AX,0016
   push AX
   push DS
   mov AX,offset _pl+2*18
   push AX
   call far _setmem
   add SP,+08
   pop BP
ret far

_playerkill: ;; 1ea2008e
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

_countobj: ;; 1ea200ef
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   xor SI,SI
jmp near L1ea2011c
L1ea200fa:
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
   jnz L1ea20117
   mov AX,0001
jmp near L1ea20119
L1ea20117:
   xor AX,AX
L1ea20119:
   add DI,AX
   inc SI
L1ea2011c:
   cmp SI,[offset _numobjs]
   jl L1ea200fa
   mov AX,DI
jmp near L1ea20126
L1ea20126:
   pop DI
   pop SI
   pop BP
ret far

_notemod: ;; 1ea2012a
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
jmp near L1ea201fb
L1ea201d5:
   mov DI,[BP-0A]
jmp near L1ea201f3
L1ea201da:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
   inc DI
L1ea201f3:
   cmp DI,[BP-08]
   jl L1ea201da
   inc word ptr [BP-02]
L1ea201fb:
   mov AX,[BP-02]
   cmp AX,[BP-04]
   jl L1ea201d5
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_setobjsize: ;; 1ea20209
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
   jz L1ea202af
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
L1ea202af:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],14
   jnz L1ea202e3
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
jmp near L1ea20374
L1ea202e3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],15
   jnz L1ea20317
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
jmp near L1ea20374
L1ea20317:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],1B
   jnz L1ea20374
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
L1ea20374:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_findcheckpt: ;; 1ea2037a
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L1ea203b4
L1ea20382:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],0C
   jnz L1ea203b3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[BP+06]
   jnz L1ea203b3
   mov AX,SI
jmp near L1ea203be
L1ea203b3:
   inc SI
L1ea203b4:
   cmp SI,[offset _numobjs]
   jl L1ea20382
   xor AX,AX
jmp near L1ea203be
L1ea203be:
   pop SI
   pop BP
ret far

_dolevelsong: ;; 1ea203c1
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   push [offset _pl+2*00]
   push CS
   call near offset _findcheckpt
   pop CX
   mov SI,AX
   or SI,SI
   jg L1ea203db
jmp near L1ea20465
L1ea203db:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1ea20465
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   les BX,[ES:BX+17]
   cmp byte ptr [ES:BX],2A
   jz L1ea2043f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   les BX,[ES:BX+17]
   cmp byte ptr [ES:BX],23
   jz L1ea2043f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   les BX,[ES:BX+17]
   cmp byte ptr [ES:BX],26
   jnz L1ea20465
L1ea2043f:
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
jmp near L1ea204be
L1ea20465:
   xor AX,AX
   push AX
   push CS
   call near offset _findcheckpt
   pop CX
   mov [BP-02],AX
   mov AX,[BP-02]
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
   jz L1ea20499
   cmp DI,+23
   jz L1ea20499
   cmp DI,+26
   jnz L1ea204be
L1ea20499:
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
L1ea204be:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_p_reenter: ;; 1ea204c4
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   or word ptr [offset _statmodflg],C000
   push [offset _pl+2*00]
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
   jz L1ea20514
   sub word ptr [BP-0A],+10
L1ea20514:
   or SI,SI
   jle L1ea20577
   cmp word ptr [BP+06],+00
   jz L1ea20577
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L1ea20577
   mov DX,[offset _pl+2*17]
   mov AX,[offset _pl+2*16]
   mov [BP-02],DX
   mov [BP-04],AX
   mov AX,[offset _pl+2*00]
   mov [BP-06],AX
   push DS
   mov AX,offset _curlevel
   push AX
   call far _loadboard
   pop CX
   pop CX
   mov AX,[BP-06]
   mov [offset _pl+2*00],AX
   mov DX,[BP-02]
   mov AX,[BP-04]
   mov [offset _pl+2*14],DX
   mov [offset _pl+2*13],AX
   mov word ptr [offset _pl+2*01],0006
   push [offset _pl+2*00]
   push CS
   call near offset _findcheckpt
   pop CX
   mov SI,AX
L1ea20577:
   mov DX,[offset _pl+2*14]
   mov AX,[offset _pl+2*13]
   mov [offset _pl+2*17],DX
   mov [offset _pl+2*16],AX
   push CS
   call near offset _dolevelsong
   and word ptr [BP-0C],FFF8
   mov AX,[BP-0C]
   mov [offset _objs+01],AX
   mov AX,[BP-0A]
   mov [offset _objs+03],AX
   call far _setorigin
   xor DI,DI
jmp near L1ea205cc
L1ea205a3:
   mov word ptr [BP-08],0000
jmp near L1ea205c5
L1ea205aa:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-08]
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
   inc word ptr [BP-08]
L1ea205c5:
   cmp word ptr [BP-08],+40
   jl L1ea205aa
   inc DI
L1ea205cc:
   cmp DI,0080
   jl L1ea205a3
   mov word ptr [offset _objs+0D],0004
   mov word ptr [offset _objs+11],0000
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_p_ouch: ;; 1ea205e4
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   cmp byte ptr [offset _objs],17
   jnz L1ea205f9
jmp near L1ea206ad
L1ea205f9:
   cmp byte ptr [offset _objs],00
   jnz L1ea20611
   mov BX,[offset _objs+0D]
   shl BX,1
   test word ptr [BX+offset _stateinfo+2*0],0002
   jz L1ea20611
jmp near L1ea206ad
L1ea20611:
   mov AX,000A
   push AX
   call far _invcount
   pop CX
   sub SI,AX
   or SI,SI
   jg L1ea20624
jmp near L1ea206ad
L1ea20624:
   or word ptr [offset _statmodflg],C000
   sub [offset _pl+2*01],SI
   mov word ptr [offset _pl+2*15],0001
   cmp word ptr [offset _pl+2*01],+00
   jle L1ea2064c
   mov AX,0013
   push AX
   mov AX,0004
   push AX
   call far _snd_play
   pop CX
   pop CX
jmp near L1ea206ad
L1ea2064c:
   mov word ptr [offset _pl+2*01],0000
   mov byte ptr [offset _objs],00
   mov word ptr [offset _objs+09],0010
   mov word ptr [offset _objs+0B],0020
   mov word ptr [offset _objs+0D],0005
   mov word ptr [offset _objs+11],0000
   mov [offset _objs+0F],DI
   cmp DI,+01
   jnz L1ea20682
   mov AX,[offset _objs+03]
   dec AX
   and AX,FFF0
   mov [offset _objs+03],AX
L1ea20682:
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
L1ea206ad:
   pop DI
   pop SI
   pop BP
ret far

_seekplayer: ;; 1ea206b1
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
   jge L1ea206d6
   mov AX,0001
jmp near L1ea206d8
L1ea206d6:
   xor AX,AX
L1ea206d8:
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
   jle L1ea206f7
   mov AX,0001
jmp near L1ea206f9
L1ea206f7:
   xor AX,AX
L1ea206f9:
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
   jge L1ea20720
   mov AX,0001
jmp near L1ea20722
L1ea20720:
   xor AX,AX
L1ea20722:
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
   jle L1ea20741
   mov AX,0001
jmp near L1ea20743
L1ea20741:
   xor AX,AX
L1ea20743:
   pop DX
   sub DX,AX
   les BX,[BP+0C]
   mov [ES:BX],DX
   pop SI
   pop BP
ret far

_modjunglescroll: ;; 1ea2074f
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   cmp word ptr [BP+06],+00
   jg L1ea20760
jmp near L1ea2082f
L1ea20760:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   les BX,[offset _gamevp]
   add AX,[ES:BX+04]
   sub AX,[BP+06]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-02],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   les BX,[offset _gamevp]
   add AX,[ES:BX+04]
   dec AX
   mov BX,0010
   cwd
   idiv BX
   cmp AX,007F
   jge L1ea207b1
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   les BX,[offset _gamevp]
   add AX,[ES:BX+04]
   dec AX
   mov BX,0010
   cwd
   idiv BX
jmp near L1ea207b4
L1ea207b1:
   mov AX,007F
L1ea207b4:
   mov [BP-04],AX
   mov DI,[BP-02]
jmp near L1ea20828
L1ea207bc:
   mov word ptr [BP-0C],0000
jmp near L1ea2081e
L1ea207c3:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   add AX,[BP-0C]
   cmp AX,003F
   jge L1ea207ee
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
   add SI,[BP-0C]
jmp near L1ea207f1
L1ea207ee:
   mov SI,003F
L1ea207f1:
   mov AX,[BP+0A]
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   or [ES:BX],AX
   cmp word ptr [BP+0A],4000
   jnz L1ea2081b
   push SI
   push DI
   call far _drawcell
   pop CX
   pop CX
L1ea2081b:
   inc word ptr [BP-0C]
L1ea2081e:
   mov AX,[offset _scrnys]
   inc AX
   cmp AX,[BP-0C]
   jg L1ea207c3
   inc DI
L1ea20828:
   cmp DI,[BP-04]
   jle L1ea207bc
jmp near L1ea20899
L1ea2082f:
   cmp word ptr [BP+06],+00
   jge L1ea20899
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-0A],AX
   mov word ptr [BP-0C],0000
jmp near L1ea20890
L1ea2084d:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
   add SI,[BP-0C]
   mov AX,[BP+0A]
   mov BX,[BP-0A]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   or [ES:BX],AX
   cmp word ptr [BP+0A],4000
   jnz L1ea2088d
   push SI
   push [BP-0A]
   call far _drawcell
   pop CX
   pop CX
L1ea2088d:
   inc word ptr [BP-0C]
L1ea20890:
   mov AX,[offset _scrnys]
   inc AX
   cmp AX,[BP-0C]
   jg L1ea2084d
L1ea20899:
   cmp word ptr [BP+08],+00
   jg L1ea208a2
jmp near L1ea20956
L1ea208a2:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   les BX,[offset _gamevp]
   add AX,[ES:BX+06]
   mov [BP-08],AX
   mov AX,[BP-08]
   dec AX
   mov BX,0010
   cwd
   idiv BX
   cmp AX,003F
   jge L1ea208d0
   mov AX,[BP-08]
   dec AX
   mov BX,0010
   cwd
   idiv BX
jmp near L1ea208d3
L1ea208d0:
   mov AX,003F
L1ea208d3:
   mov [BP-06],AX
   mov AX,[BP-08]
   sub AX,[BP+08]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
jmp near L1ea2094e
L1ea208e6:
   xor DI,DI
jmp near L1ea20945
L1ea208ea:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
   cmp AX,007F
   jge L1ea20911
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
jmp near L1ea20914
L1ea20911:
   mov AX,007F
L1ea20914:
   mov [BP-0A],AX
   mov AX,[BP+0A]
   mov BX,[BP-0A]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   or [ES:BX],AX
   cmp word ptr [BP+0A],4000
   jnz L1ea20944
   push SI
   push [BP-0A]
   call far _drawcell
   pop CX
   pop CX
L1ea20944:
   inc DI
L1ea20945:
   mov AX,[offset _scrnxs]
   inc AX
   cmp AX,DI
   jg L1ea208ea
   inc SI
L1ea2094e:
   cmp SI,[BP-06]
   jle L1ea208e6
jmp near L1ea209f2
L1ea20956:
   cmp word ptr [BP+08],+00
   jl L1ea2095f
jmp near L1ea209f2
L1ea2095f:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
jmp near L1ea209d9
L1ea20971:
   xor DI,DI
jmp near L1ea209d0
L1ea20975:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
   cmp AX,007F
   jge L1ea2099c
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
jmp near L1ea2099f
L1ea2099c:
   mov AX,007F
L1ea2099f:
   mov [BP-0A],AX
   mov AX,[BP+0A]
   mov BX,[BP-0A]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   or [ES:BX],AX
   cmp word ptr [BP+0A],4000
   jnz L1ea209cf
   push SI
   push [BP-0A]
   call far _drawcell
   pop CX
   pop CX
L1ea209cf:
   inc DI
L1ea209d0:
   mov AX,[offset _scrnxs]
   inc AX
   cmp AX,DI
   jg L1ea20975
   inc SI
L1ea209d9:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   sub AX,[BP+08]
   dec AX
   mov BX,0010
   cwd
   idiv BX
   cmp AX,SI
   jl L1ea209f2
jmp near L1ea20971
L1ea209f2:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_junglescroll: ;; 1ea209f8
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
   add AX,[offset _objs+0B]
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
   add AX,[offset _objs+0B]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   or SI,SI
   jz L1ea20a79
jmp near L1ea20af3
L1ea20a79:
   mov word ptr [BP-18],0000
   mov AX,[BP-10]
   cmp AX,[BP-0C]
   jge L1ea20a8b
   mov AX,[BP-10]
jmp near L1ea20a8e
L1ea20a8b:
   mov AX,[BP-0C]
L1ea20a8e:
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   sub AX,[ES:BX+08]
   mov [BP-16],AX
   mov AX,[BP-08]
   cmp AX,[BP-04]
   jle L1ea20aaa
   mov AX,[BP-08]
jmp near L1ea20aad
L1ea20aaa:
   mov AX,[BP-04]
L1ea20aad:
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   sub AX,[ES:BX+08]
   mov [BP-14],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+04]
   mov [BP-12],AX
   mov AX,DI
   neg AX
   push AX
   xor AX,AX
   push AX
   les BX,[offset _gamevp]
   push [ES:BX+06]
   push [BP-16]
   xor AX,AX
   push AX
   push [BP-18]
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _scroll
   add SP,+10
jmp near L1ea20b71
L1ea20af3:
   or DI,DI
   jz L1ea20afa
jmp near L1ea20b71
L1ea20afa:
   mov word ptr [BP-18],0000
   mov AX,[BP-0E]
   cmp AX,[BP-0A]
   jge L1ea20b0c
   mov AX,[BP-0E]
jmp near L1ea20b0f
L1ea20b0c:
   mov AX,[BP-0A]
L1ea20b0f:
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   sub AX,[ES:BX+0A]
   mov [BP-16],AX
   mov AX,[BP-06]
   cmp AX,[BP-02]
   jle L1ea20b2b
   mov AX,[BP-06]
jmp near L1ea20b2e
L1ea20b2b:
   mov AX,[BP-02]
L1ea20b2e:
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   sub AX,[ES:BX+0A]
   mov [BP-14],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+06]
   mov [BP-12],AX
   xor AX,AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [BP-16]
   les BX,[offset _gamevp]
   push [ES:BX+04]
   push [BP-18]
   xor AX,AX
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _scroll
   add SP,+10
L1ea20b71:
   mov AX,[BP-10]
   mov [BP-1C],AX
jmp near L1ea20bb5
L1ea20b79:
   mov AX,[BP-0E]
   mov [BP-1A],AX
jmp near L1ea20baa
L1ea20b81:
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
   and word ptr [ES:BX],7FFF
   inc word ptr [BP-1A]
L1ea20baa:
   mov AX,[BP-1A]
   cmp AX,[BP-06]
   jl L1ea20b81
   inc word ptr [BP-1C]
L1ea20bb5:
   mov AX,[BP-1C]
   cmp AX,[BP-08]
   jl L1ea20b79
   or SI,SI
   jnz L1ea20c38
   mov AX,DI
   neg AX
   push AX
   xor AX,AX
   push AX
   les BX,[offset _gamevp]
   push [ES:BX+06]
   push [BP-14]
   xor AX,AX
   push AX
   push [BP-16]
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _scroll
   add SP,+10
   les BX,[offset _gamevp]
   add [ES:BX+0A],DI
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
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
   xor AX,AX
   push AX
   push [BP-14]
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _scroll
   add SP,+10
jmp near L1ea20cf6
L1ea20c38:
   or DI,DI
   jnz L1ea20cb2
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _scroll
   add SP,+10
   les BX,[offset _gamevp]
   add [ES:BX+08],SI
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
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
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _scroll
   add SP,+10
jmp near L1ea20cf6
L1ea20cb2:
   mov AX,DI
   neg AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _scrollvp
   add SP,+08
   les BX,[offset _gamevp]
   add [ES:BX+08],SI
   les BX,[offset _gamevp]
   add [ES:BX+0A],DI
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[offset _objs]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+offset _kindmsg]
   add SP,+06
L1ea20cf6:
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

_pagedjunglescroll: ;; 1ea20d09
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   mov AX,DI
   neg AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [offset _gamevp+2]
   push [offset _gamevp+0]
   call far _scrollvp
   add SP,+08
   les BX,[offset _gamevp]
   add [ES:BX+08],SI
   les BX,[offset _gamevp]
   add [ES:BX+0A],DI
   mov AX,C000
   push AX
   push DI
   push SI
   push CS
   call near offset _modjunglescroll
   add SP,+06
   pop DI
   pop SI
   pop BP
ret far

_refresh: ;; 1ea20d4f
   push BP
   mov BP,SP
   sub SP,0A0C
   push SI
   push DI
   cmp word ptr [BP+06],+00
   jnz L1ea20d61
jmp near L1ea20f65
L1ea20d61:
   cmp word ptr [offset _statmodflg],+00
   jz L1ea20d79
   call far _drawstats
   mov AX,[offset _pagedraw]
   inc AX
   mov CL,0E
   shl AX,CL
   and [offset _statmodflg],AX
L1ea20d79:
   mov AX,[offset _scrollxd]
   add AX,[offset _oldscrollxd]
   jnz L1ea20d8b
   mov AX,[offset _scrollyd]
   add AX,[offset _oldscrollyd]
   jz L1ea20db7
L1ea20d8b:
   mov AX,[offset _oldscrollxd]
   les BX,[offset _gamevp]
   sub [ES:BX+08],AX
   mov AX,[offset _oldscrollyd]
   les BX,[offset _gamevp]
   sub [ES:BX+0A],AX
   mov AX,[offset _scrollyd]
   add AX,[offset _oldscrollyd]
   push AX
   mov AX,[offset _scrollxd]
   add AX,[offset _oldscrollxd]
   push AX
   push CS
   call near offset _pagedjunglescroll
   pop CX
   pop CX
L1ea20db7:
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
   jge L1ea20dea
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnxs]
jmp near L1ea20ded
L1ea20dea:
   mov AX,007F
L1ea20ded:
   mov [BP+F5F8],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnys]
   dec AX
   cmp AX,003F
   jge L1ea20e1a
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnys]
   dec AX
jmp near L1ea20e1d
L1ea20e1a:
   mov AX,003F
L1ea20e1d:
   mov [BP+F5FA],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1ea20e36
   xor AX,AX
jmp near L1ea20e45
L1ea20e36:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1ea20e45:
   mov [BP+F5FC],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1ea20e5e
   xor AX,AX
jmp near L1ea20e6d
L1ea20e5e:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1ea20e6d:
   mov [BP+F5FE],AX
   mov SI,[BP+F5F8]
jmp near L1ea20edb
L1ea20e77:
   mov AX,[BP+F5FA]
   mov [BP+F5F4],AX
jmp near L1ea20ed0
L1ea20e81:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+F5F4]
   shl AX,1
   add BX,AX
   test word ptr [ES:BX],C000
   jz L1ea20ecc
   push [BP+F5F4]
   push SI
   call far _drawcell
   pop CX
   pop CX
   mov AX,[offset _pagedraw]
   inc AX
   mov CL,0E
   shl AX,CL
   xor AX,FFFF
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push AX
   push DS
   pop ES
   mov AX,[BP+F5F4]
   shl AX,1
   add BX,AX
   pop AX
   and [ES:BX],AX
L1ea20ecc:
   dec word ptr [BP+F5F4]
L1ea20ed0:
   mov AX,[BP+F5F4]
   cmp AX,[BP+F5FE]
   jge L1ea20e81
   dec SI
L1ea20edb:
   cmp SI,[BP+F5FC]
   jge L1ea20e77
   mov AX,[offset _numobjs]
   dec AX
   mov [BP+F5F6],AX
jmp near L1ea20f56
L1ea20eeb:
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+15],C000
   jz L1ea20f52
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push [BP+F5F6]
   mov AX,[BP+F5F6]
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
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   pop AX
   and [ES:BX+15],AX
L1ea20f52:
   dec word ptr [BP+F5F6]
L1ea20f56:
   cmp word ptr [BP+F5F6],+00
   jge L1ea20eeb
   call far _pageflip
jmp near L1ea211bb
L1ea20f65:
   cmp word ptr [offset _statmodflg],+00
   jz L1ea20f77
   call far _drawstats
   mov word ptr [offset _statmodflg],0000
L1ea20f77:
   xor DI,DI
jmp near L1ea20f91
L1ea20f7b:
   mov AX,DI
   mov DX,0014
   mul DX
   mov BX,AX
   lea AX,[BP+F600]
   add BX,AX
   push SS
   pop ES
   mov byte ptr [ES:BX],FF
   inc DI
L1ea20f91:
   cmp DI,0080
   jl L1ea20f7b
   cmp word ptr [offset _scrollxd],+00
   jnz L1ea20fa5
   cmp word ptr [offset _scrollyd],+00
   jz L1ea20fb3
L1ea20fa5:
   push [offset _scrollyd]
   push [offset _scrollxd]
   push CS
   call near offset _junglescroll
   pop CX
   pop CX
L1ea20fb3:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnxs]
   dec AX
   mov [BP+F5F8],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[offset _scrnys]
   dec AX
   mov [BP+F5FA],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1ea20ff2
   xor AX,AX
jmp near L1ea21001
L1ea20ff2:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1ea21001:
   mov [BP+F5FC],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1ea2101a
   xor AX,AX
jmp near L1ea21029
L1ea2101a:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1ea21029:
   mov [BP+F5FE],AX
   mov word ptr [BP+F5F6],0000
jmp near L1ea210de
L1ea21036:
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+15],C000
   jnz L1ea21052
jmp near L1ea210da
L1ea21052:
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov SI,[ES:BX+01]
   mov CL,04
   sar SI,CL
   cmp SI,[BP+F5FC]
   jge L1ea21075
   mov SI,[BP+F5FC]
L1ea21075:
   xor DI,DI
jmp near L1ea2107a
L1ea21079:
   inc DI
L1ea2107a:
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   lea AX,[BP+F600]
   add BX,AX
   push SS
   pop ES
   cmp byte ptr [ES:BX+DI],FF
   jnz L1ea21079
   mov AL,[BP+F5F6]
   push AX
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   lea AX,[BP+F600]
   add BX,AX
   push SS
   pop ES
   pop AX
   mov [ES:BX+DI],AL
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   lea AX,[BP+F600]
   add BX,AX
   push SS
   pop ES
   add BX,DI
   mov byte ptr [ES:BX+01],FF
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   and word ptr [ES:BX+15],3FFF
L1ea210da:
   inc word ptr [BP+F5F6]
L1ea210de:
   mov AX,[BP+F5F6]
   cmp AX,[offset _numobjs]
   jge L1ea210eb
jmp near L1ea21036
L1ea210eb:
   mov SI,[BP+F5F8]
jmp near L1ea211b2
L1ea210f2:
   mov AX,[BP+F5FA]
   mov [BP+F5F4],AX
jmp near L1ea21140
L1ea210fc:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP+F5F4]
   shl AX,1
   add BX,AX
   test word ptr [ES:BX],8000
   jz L1ea2113c
   push [BP+F5F4]
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
   mov AX,[BP+F5F4]
   shl AX,1
   add BX,AX
   and word ptr [ES:BX],3FFF
L1ea2113c:
   dec word ptr [BP+F5F4]
L1ea21140:
   mov AX,[BP+F5F4]
   cmp AX,[BP+F5FE]
   jge L1ea210fc
   xor DI,DI
jmp near L1ea21195
L1ea2114e:
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   lea AX,[BP+F600]
   add BX,AX
   push SS
   pop ES
   mov AL,[ES:BX+DI]
   mov AH,00
   mov [BP+F5F6],AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push [BP+F5F6]
   mov AX,[BP+F5F6]
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
   inc DI
L1ea21195:
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   lea AX,[BP+F600]
   add BX,AX
   push SS
   pop ES
   cmp byte ptr [ES:BX+DI],FF
   jz L1ea211b1
   cmp DI,+14
   jl L1ea2114e
L1ea211b1:
   dec SI
L1ea211b2:
   cmp SI,[BP+F5FC]
   jl L1ea211bb
jmp near L1ea210f2
L1ea211bb:
   cmp word ptr [offset _pl+2*15],+00
   jz L1ea211ce
   mov word ptr [offset _pl+2*15],0000
   or word ptr [offset _statmodflg],C000
L1ea211ce:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_updbkgnd: ;; 1ea211d4
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
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,[BP-08]
   add AX,[offset _scrnxs]
   cmp AX,007F
   jge L1ea2120f
   mov AX,[BP-08]
   add AX,[offset _scrnxs]
jmp near L1ea21212
L1ea2120f:
   mov AX,007F
L1ea21212:
   mov [BP-04],AX
   mov AX,[BP-06]
   add AX,[offset _scrnys]
   cmp AX,003F
   jge L1ea2122a
   mov AX,[BP-06]
   add AX,[offset _scrnys]
jmp near L1ea2122d
L1ea2122a:
   mov AX,003F
L1ea2122d:
   mov [BP-02],AX
   mov SI,[BP-08]
jmp near L1ea212a8
L1ea21235:
   mov DI,[BP-06]
jmp near L1ea212a2
L1ea2123a:
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
   mov BX,[BP-0A]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,offset _info
   push DS
   pop ES
   test word ptr [ES:BX+02],0020
   jz L1ea212a1
   mov AX,0002
   push AX
   push DI
   push SI
   call far _msg_block
   add SP,+06
   or AX,AX
   jz L1ea21283
   mov AX,0001
jmp near L1ea21285
L1ea21283:
   xor AX,AX
L1ea21285:
   mov DX,C000
   mul DX
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
   or [ES:BX],AX
L1ea212a1:
   inc DI
L1ea212a2:
   cmp DI,[BP-02]
   jle L1ea2123a
   inc SI
L1ea212a8:
   cmp SI,[BP-04]
   jg L1ea212b0
jmp near L1ea21235
L1ea212b0:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_updobjs: ;; 1ea212b6
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
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   les BX,[offset _gamevp]
   add AX,[ES:BX+04]
   add AX,0060
   mov [BP-06],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   add AX,FFD0
   mov [BP-04],AX
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   les BX,[offset _gamevp]
   add AX,[ES:BX+06]
   add AX,0030
   mov [BP-02],AX
   mov SI,0001
jmp near L1ea213d3
L1ea21318:
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
   jge L1ea21348
jmp near L1ea213d2
L1ea21348:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,[BP-06]
   jg L1ea213d2
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
   jl L1ea213d2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP-02]
   jg L1ea213d2
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
L1ea213d2:
   inc SI
L1ea213d3:
   cmp SI,[offset _numobjs]
   jge L1ea213e4
   cmp word ptr [offset _numscrnobjs],00C0
   jge L1ea213e4
jmp near L1ea21318
L1ea213e4:
   mov word ptr [offset _scrollxd],0000
   mov word ptr [offset _scrollyd],0000
   mov AX,[offset _objs+01]
   mov [offset _oldx0],AX
   mov AX,[offset _objs+03]
   mov [offset _oldy0],AX
   mov word ptr [BP-1A],0000
jmp near L1ea2173d
L1ea21404:
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
   jz L1ea214d7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jle L1ea21494
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   dec word ptr [ES:BX+1D]
L1ea21494:
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
   jz L1ea214d5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1ea214d5:
jmp near L1ea214ec
L1ea214d7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1ea214ec:
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
   jnz L1ea2150e
jmp near L1ea216b0
L1ea2150e:
   mov word ptr [BP-18],0000
jmp near L1ea216a4
L1ea21516:
   mov BX,[BP-18]
   shl BX,1
   mov DI,[BX+offset _scrnobjs]
   cmp DI,SI
   jnz L1ea21526
jmp near L1ea216a1
L1ea21526:
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
   jg L1ea21568
jmp near L1ea216a1
L1ea21568:
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
   jg L1ea215aa
jmp near L1ea216a1
L1ea215aa:
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
   jg L1ea215ec
jmp near L1ea216a1
L1ea215ec:
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
   jle L1ea216a1
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
L1ea216a1:
   inc word ptr [BP-18]
L1ea216a4:
   mov AX,[BP-18]
   cmp AX,[offset _numscrnobjs]
   jg L1ea216b0
jmp near L1ea21516
L1ea216b0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   test word ptr [ES:BX+15],C000
   jz L1ea2173a
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
jmp near L1ea21732
L1ea21703:
   mov AX,[BP-08]
   mov [BP-0C],AX
jmp near L1ea21727
L1ea2170b:
   mov BX,[BP-0C]
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,[BP-0A]
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
   inc word ptr [BP-0C]
L1ea21727:
   mov AX,[BP-0C]
   cmp AX,[BP-06]
   jl L1ea2170b
   inc word ptr [BP-0A]
L1ea21732:
   mov AX,[BP-0A]
   cmp AX,[BP-02]
   jl L1ea21703
L1ea2173a:
   inc word ptr [BP-1A]
L1ea2173d:
   mov AX,[BP-1A]
   cmp AX,[offset _numscrnobjs]
   jge L1ea21749
jmp near L1ea21404
L1ea21749:
   mov word ptr [BP-1A],0000
jmp near L1ea2184e
L1ea21751:
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
jmp near L1ea21828
L1ea217e7:
   mov AX,[BP-08]
   mov [BP-0C],AX
jmp near L1ea2181d
L1ea217ef:
   cmp word ptr [BP-16],+00
   jnz L1ea21810
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
   jz L1ea21815
L1ea21810:
   mov AX,0001
jmp near L1ea21817
L1ea21815:
   xor AX,AX
L1ea21817:
   mov [BP-16],AX
   inc word ptr [BP-0C]
L1ea2181d:
   mov AX,[BP-0C]
   cmp AX,[BP-06]
   jl L1ea217ef
   inc word ptr [BP-0A]
L1ea21828:
   mov AX,[BP-0A]
   cmp AX,[BP-02]
   jl L1ea217e7
   cmp word ptr [BP-16],+00
   jz L1ea2184b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1ea2184b:
   inc word ptr [BP-1A]
L1ea2184e:
   mov AX,[BP-1A]
   cmp AX,[offset _numscrnobjs]
   jge L1ea2185a
jmp near L1ea21751
L1ea2185a:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_killobj: ;; 1ea21860
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

_addobj: ;; 1ea2188f
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
   jge L1ea21a08
   inc word ptr [offset _numobjs]
L1ea21a08:
   mov AX,[offset _numobjs]
   dec AX
jmp near L1ea21a0e
L1ea21a0e:
   pop BP
ret far

_addinv: ;; 1ea21a10
   push BP
   mov BP,SP
   cmp word ptr [offset _pl+2*02],+0F
   jl L1ea21a1c
jmp near L1ea21a33
L1ea21a1c:
   or word ptr [offset _statmodflg],C000
   mov AX,[BP+06]
   mov BX,[offset _pl+2*02]
   shl BX,1
   mov [BX+offset _pl+2*03],AX
   inc word ptr [offset _pl+2*02]
L1ea21a33:
   pop BP
ret far

_takeinv: ;; 1ea21a35
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
jmp near L1ea21a78
L1ea21a3e:
   mov BX,SI
   shl BX,1
   mov AX,[BX+offset _pl+2*03]
   cmp AX,[BP+06]
   jnz L1ea21a77
   mov DI,SI
   inc DI
jmp near L1ea21a62
L1ea21a50:
   mov BX,DI
   shl BX,1
   mov AX,[BX+offset _pl+2*03]
   mov BX,DI
   dec BX
   shl BX,1
   mov [BX+offset _pl+2*03],AX
   inc DI
L1ea21a62:
   cmp DI,[offset _pl+2*02]
   jl L1ea21a50
   dec word ptr [offset _pl+2*02]
   or word ptr [offset _statmodflg],C000
   mov AX,0001
jmp near L1ea21a82
L1ea21a77:
   inc SI
L1ea21a78:
   cmp SI,[offset _pl+2*02]
   jl L1ea21a3e
   xor AX,AX
jmp near L1ea21a82
L1ea21a82:
   pop DI
   pop SI
   pop BP
ret far

_invcount: ;; 1ea21a86
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   xor SI,SI
jmp near L1ea21aa8
L1ea21a91:
   mov BX,SI
   shl BX,1
   mov AX,[BX+offset _pl+2*03]
   cmp AX,[BP+06]
   jnz L1ea21aa3
   mov AX,0001
jmp near L1ea21aa5
L1ea21aa3:
   xor AX,AX
L1ea21aa5:
   add DI,AX
   inc SI
L1ea21aa8:
   cmp SI,[offset _pl+2*02]
   jl L1ea21a91
   mov AX,DI
jmp near L1ea21ab2
L1ea21ab2:
   pop DI
   pop SI
   pop BP
ret far

_initinv: ;; 1ea21ab6
   push BP
   mov BP,SP
   mov word ptr [offset _pl+2*01],0006
jmp near L1ea21ac3
L1ea21ac1:
jmp near L1ea21ac3
L1ea21ac3:
   xor AX,AX
   push AX
   push CS
   call near offset _takeinv
   pop CX
   or AX,AX
   jnz L1ea21ac1
   pop BP
ret far

_moveobj: ;; 1ea21ad1
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   cmp word ptr [BP+0A],+00
   jge L1ea21ae9
   mov word ptr [BP+0A],0000
jmp near L1ea21b21
L1ea21ae9:
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
   jge L1ea21b21
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
L1ea21b21:
   or DI,DI
   jge L1ea21b29
   xor DI,DI
jmp near L1ea21b5d
L1ea21b29:
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
   jge L1ea21b5d
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
L1ea21b5d:
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

_standfloor: ;; 1ea21b8c
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
   jz L1ea21be5
   xor AX,AX
jmp near L1ea21c80
L1ea21be5:
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
jmp near L1ea21c73
L1ea21c36:
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
   cmp word ptr [BP-08],+03
   jnz L1ea21c70
   xor AX,AX
jmp near L1ea21c80
L1ea21c70:
   inc word ptr [BP-02]
L1ea21c73:
   mov AX,[BP-02]
   cmp AX,[BP-04]
   jl L1ea21c36
   mov AX,0001
jmp near L1ea21c80
L1ea21c80:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_trymove: ;; 1ea21c86
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
   jge L1ea21cad
   or DI,0002
L1ea21cad:
   push DI
   push [BP+0A]
   push [BP+08]
   push SI
   call far _cando
   add SP,+08
   cmp AX,DI
   jnz L1ea21cd8
   push [BP+0A]
   push [BP+08]
   push SI
   push CS
   call near offset _moveobj
   add SP,+06
   mov AX,0001
jmp near L1ea21d6c

X1ea21cd5:
jmp near L1ea21d68
L1ea21cd8:
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
   jnz L1ea21d21
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
jmp near L1ea21d6c

X1ea21d1f:
jmp near L1ea21d68
L1ea21d21:
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
   jnz L1ea21d68
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
jmp near L1ea21d6c
L1ea21d68:
   xor AX,AX
jmp near L1ea21d6c
L1ea21d6c:
   pop DI
   pop SI
   pop BP
ret far

_justmove: ;; 1ea21d70
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
   jz L1ea21d9f
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _moveobj
   mov SP,BP
   mov AX,0001
jmp near L1ea21da3
L1ea21d9f:
   xor AX,AX
jmp near L1ea21da3
L1ea21da3:
   pop BP
ret far

_onscreen: ;; 1ea21da5
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
   jge L1ea21de1
jmp near L1ea21e66
L1ea21de1:
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
   jl L1ea21e66
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   les BX,[offset _gamevp]
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
   jl L1ea21e66
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   les BX,[offset _gamevp]
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
   jl L1ea21e66
   mov AX,0001
jmp near L1ea21e6a
L1ea21e66:
   xor AX,AX
jmp near L1ea21e6a
L1ea21e6a:
   pop SI
   pop BP
ret far

_trymovey: ;; 1ea21e6d
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
   jnz L1ea21eb9
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
   mov AX,0001
jmp near L1ea21f2e

X1ea21eb7:
jmp near L1ea21f15
L1ea21eb9:
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
   jnz L1ea21f15
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
   mov AX,0001
jmp near L1ea21f2e
L1ea21f15:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   xor AX,AX
jmp near L1ea21f2e
L1ea21f2e:
   pop DI
   pop SI
   pop BP
ret far

_crawl: ;; 1ea21f32
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
   jz L1ea21fa5
   mov AX,0001
   push AX
   push [BP-02]
   push DI
   push SI
   call far _cando
   add SP,+08
   cmp AX,0001
   jnz L1ea21fa5
   push [BP-02]
   push DI
   push SI
   push CS
   call near offset _moveobj
   add SP,+06
   mov AX,0001
jmp near L1ea21fa9
L1ea21fa5:
   xor AX,AX
jmp near L1ea21fa9
L1ea21fa9:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_addscore: ;; 1ea21faf
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
   jnz L1ea21fcf
jmp near L1ea2204c
L1ea21fcf:
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
   jle L1ea22007
   mov AX,0001
jmp near L1ea22009
L1ea22007:
   xor AX,AX
L1ea22009:
   push AX
   cmp DI,[offset _objs+01]
   jge L1ea22015
   mov AX,0001
jmp near L1ea22017
L1ea22015:
   xor AX,AX
L1ea22017:
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
L1ea2204c:
   or word ptr [offset _statmodflg],C000
   mov AX,[BP+06]
   cwd
   add [offset _pl+2*13],AX
   adc [offset _pl+2*14],DX
   pop DI
   pop SI
   pop BP
ret far

_addtext: ;; 1ea22062 ;; (@) Unaccessed.
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
   jz L1ea220e9
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
L1ea220e9:
   pop SI
   pop BP
ret far

_sendtrig: ;; 1ea220ec
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L1ea22153
L1ea220f4:
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
   jz L1ea22152
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[BP+06]
   jnz L1ea22152
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
L1ea22152:
   inc SI
L1ea22153:
   cmp SI,[offset _numobjs]
   jl L1ea220f4
   pop SI
   pop BP
ret far

_setorigin: ;; 1ea2215c
   push BP
   mov BP,SP
   mov AX,[offset _scrnxs]
   shl AX,1
   shl AX,1
   shl AX,1
   mov DX,[offset _objs+01]
   sub DX,AX
   and DX,FFF8
   les BX,[offset _gamevp]
   mov [ES:BX+08],DX
   les BX,[offset _gamevp]
   cmp word ptr [ES:BX+08],+00
   jge L1ea22191
   les BX,[offset _gamevp]
   mov word ptr [ES:BX+08],0000
jmp near L1ea221bb
L1ea22191:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+08]
   mov DX,0080
   sub DX,[offset _scrnxs]
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jle L1ea221bb
   mov AX,0080
   sub AX,[offset _scrnxs]
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   mov [ES:BX+08],AX
L1ea221bb:
   mov AX,[offset _scrnys]
   shl AX,1
   shl AX,1
   shl AX,1
   mov DX,[offset _objs+03]
   add DX,+10
   sub DX,AX
   les BX,[offset _gamevp]
   mov [ES:BX+0A],DX
   les BX,[offset _gamevp]
   cmp word ptr [ES:BX+0A],+00
   jge L1ea221ec
   les BX,[offset _gamevp]
   mov word ptr [ES:BX+0A],0000
jmp near L1ea22216
L1ea221ec:
   les BX,[offset _gamevp]
   mov AX,[ES:BX+0A]
   mov DX,0041
   sub DX,[offset _scrnys]
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jle L1ea22216
   mov AX,0041
   sub AX,[offset _scrnys]
   mov CL,04
   shl AX,CL
   les BX,[offset _gamevp]
   mov [ES:BX+0A],AX
L1ea22216:
   mov word ptr [offset _oldscrollxd],0000
   mov word ptr [offset _oldscrollyd],0000
   pop BP
ret far

_cando: ;; 1ea22224
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
jmp near L1ea2231b
L1ea222cd:
   cmp SI,[BP-04]
   jl L1ea222d7
   mov word ptr [BP-0E],0000
L1ea222d7:
   mov DI,[BP-0A]
jmp near L1ea22315
L1ea222dc:
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
   mov AX,[BP-10]
   and [BP-0C],AX
   inc DI
L1ea22315:
   cmp DI,[BP-08]
   jl L1ea222dc
   inc SI
L1ea2231b:
   cmp SI,[BP-02]
   jl L1ea222cd
   mov AX,[BP-0C]
jmp near L1ea22325
L1ea22325:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_objdo: ;; 1ea2232b
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
jmp near L1ea223ce
L1ea22393:
   mov SI,[BP-08]
jmp near L1ea223c8
L1ea22398:
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
L1ea223c8:
   cmp SI,[BP-06]
   jl L1ea22398
   inc DI
L1ea223ce:
   cmp DI,[BP-02]
   jl L1ea22393
   mov AX,[BP-0A]
jmp near L1ea223d8
L1ea223d8:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_touchbkgnd: ;; 1ea223de
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
   test word ptr [BX+offset _stateinfo+2*0],0002
   jz L1ea22409
jmp near L1ea224fd
L1ea22409:
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
jmp near L1ea224f5
L1ea224a9:
   mov DI,[BP-08]
jmp near L1ea224ed
L1ea224ae:
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
   jz L1ea224ec
   mov AX,0001
   push AX
   push [BP-0A]
   push DI
   call far _msg_block
   add SP,+06
L1ea224ec:
   inc DI
L1ea224ed:
   cmp DI,[BP-06]
   jl L1ea224ae
   inc word ptr [BP-0A]
L1ea224f5:
   mov AX,[BP-0A]
   cmp AX,[BP-02]
   jl L1ea224a9
L1ea224fd:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

_purgeobjs: ;; 1ea22503
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   xor SI,SI
jmp near L1ea22587
L1ea2250f:
   cmp SI,DI
   jz L1ea22537
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
L1ea22537:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   cmp byte ptr [ES:BX],03
   jnz L1ea22585
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,offset _objs
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1ea22583
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
L1ea22583:
jmp near L1ea22586
L1ea22585:
   inc DI
L1ea22586:
   inc SI
L1ea22587:
   cmp SI,[offset _numobjs]
   jge L1ea22590
jmp near L1ea2250f
L1ea22590:
   mov [offset _numobjs],DI
   pop DI
   pop SI
   pop BP
ret far

_updbotmsg: ;; 1ea22598
   push BP
   mov BP,SP
   cmp byte ptr [offset _botmsg],00
   jz L1ea225b3
   dec word ptr [offset _bottime]
   jge L1ea225b3
   mov byte ptr [offset _botmsg],00
   or word ptr [offset _statmodflg],C000
L1ea225b3:
   pop BP
ret far

_hitplayer: ;; 1ea225b5
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
   jnz L1ea225ea
   mov BX,[offset _objs+0D]
   shl BX,1
   test word ptr [BX+offset _stateinfo+2*0],0002
   jnz L1ea225ea
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   push CS
   call near offset _p_ouch
   mov SP,BP
L1ea225ea:
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

_fishdo: ;; 1ea22602
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
   jnz L1ea22631
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _moveobj
   mov SP,BP
   mov AX,0001
jmp near L1ea22635
L1ea22631:
   xor AX,AX
jmp near L1ea22635
L1ea22635:
   pop BP
ret far

_pointvect: ;; 1ea22637
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
   jnz L1ea226b8
   or SI,SI
   jz L1ea226b5
   or SI,SI
   jle L1ea2269d
   mov AX,0001
jmp near L1ea2269f
L1ea2269d:
   xor AX,AX
L1ea2269f:
   push AX
   or SI,SI
   jge L1ea226a9
   mov AX,0001
jmp near L1ea226ab
L1ea226a9:
   xor AX,AX
L1ea226ab:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov SI,AX
L1ea226b5:
jmp near L1ea2275f
L1ea226b8:
   or SI,SI
   jnz L1ea226e0
   or DI,DI
   jle L1ea226c5
   mov AX,0001
jmp near L1ea226c7
L1ea226c5:
   xor AX,AX
L1ea226c7:
   push AX
   or DI,DI
   jge L1ea226d1
   mov AX,0001
jmp near L1ea226d3
L1ea226d1:
   xor AX,AX
L1ea226d3:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov DI,AX
jmp near L1ea2275f
L1ea226e0:
   mov AX,DI
   cwd
   xor AX,DX
   sub AX,DX
   mov DX,SI
   or DX,DX
   jge L1ea226ef
   neg DX
L1ea226ef:
   cmp AX,DX
   jle L1ea2272a
   mov AX,SI
   mul word ptr [BP+12]
   mov DX,DI
   or DX,DX
   jge L1ea22700
   neg DX
L1ea22700:
   mov BX,DX
   cwd
   idiv BX
   mov SI,AX
   or DI,DI
   jle L1ea22710
   mov AX,0001
jmp near L1ea22712
L1ea22710:
   xor AX,AX
L1ea22712:
   push AX
   or DI,DI
   jge L1ea2271c
   mov AX,0001
jmp near L1ea2271e
L1ea2271c:
   xor AX,AX
L1ea2271e:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov DI,AX
jmp near L1ea2275f
L1ea2272a:
   mov AX,DI
   mul word ptr [BP+12]
   mov DX,SI
   or DX,DX
   jge L1ea22737
   neg DX
L1ea22737:
   mov BX,DX
   cwd
   idiv BX
   mov DI,AX
   or SI,SI
   jle L1ea22747
   mov AX,0001
jmp near L1ea22749
L1ea22747:
   xor AX,AX
L1ea22749:
   push AX
   or SI,SI
   jge L1ea22753
   mov AX,0001
jmp near L1ea22755
L1ea22753:
   xor AX,AX
L1ea22755:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov SI,AX
L1ea2275f:
   les BX,[BP+0A]
   mov [ES:BX],DI
   les BX,[BP+0E]
   mov [ES:BX],SI
   pop DI
   pop SI
   pop BP
ret far

_vectdist: ;; 1ea2276f
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
jmp near L1ea227d8
L1ea227d8:
   pop BP
ret far

_trybreakwall: ;; 1ea227da
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
jmp near L1ea2288f
L1ea227f5:
   mov AX,[BP+0A]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
jmp near L1ea2286a
L1ea22802:
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
   jnz L1ea22869
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,offset _bd
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C000
   mov AX,[BP-02]
   inc word ptr [BP-02]
   or AX,AX
   jnz L1ea22869
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
L1ea22869:
   inc DI
L1ea2286a:
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
   jl L1ea2288e
jmp near L1ea22802
L1ea2288e:
   inc SI
L1ea2288f:
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
   jl L1ea228b3
jmp near L1ea227f5
L1ea228b3:
   mov AX,[BP-02]
jmp near L1ea228b8
L1ea228b8:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 212d ;; JVOL2C.C:JVOL2C
SBC_READ_DSP_TIME: ;; 212d000e
   push DS
   push AX
   mov AX,segment A24dc0000
   mov DS,AX
   pop AX
   push CX
   push DX
   mov DX,[offset _ct_io_addx]
   add DL,0E
   mov CX,0200
L212d0022:
   in AL,DX
   or AL,AL
   js L212d002c
   loop L212d0022
   stc
jmp near L212d0031
L212d002c:
   sub DL,04
   in AL,DX
   clc
L212d0031:
   pop DX
   pop CX
   pop DS
ret near

SBC_WRITE_DSP_TIME: ;; 212d0035
   push DS
   push AX
   mov AX,segment A24dc0000
   mov DS,AX
   pop AX
   push CX
   push DX
   mov DX,[offset _ct_io_addx]
   add DL,0C
   mov CX,0200
   mov AH,AL
L212d004b:
   in AL,DX
   or AL,AL
   jns L212d0055
   loop L212d004b
   stc
jmp near L212d0059
L212d0055:
   mov AL,AH
   out DX,AL
   clc
L212d0059:
   pop DX
   pop CX
   pop DS
ret near

SBC_READ_DSP: ;; 212d005d ;; (@) Unaccessed.
   push DS
   push AX
   mov AX,segment A24dc0000
   mov DS,AX
   pop AX
   push DX
   mov DX,[offset _ct_io_addx]
   add DL,0E
L212d006d:
   in AL,DX
   or AL,AL
   js L212d0074
jmp near L212d006d
L212d0074:
   sub DL,04
   in AL,DX
   pop DX
   pop DS
ret near

SBC_WRITE_DSP: ;; 212d007b ;; (@) Unaccessed.
   push DS
   push AX
   mov AX,segment A24dc0000
   mov DS,AX
   pop AX
   push DX
   mov DX,[offset _ct_io_addx]
   add DX,+0C
   mov AH,AL
L212d008d:
   in AL,DX
   or AL,AL
   jns L212d0094
jmp near L212d008d
L212d0094:
   mov AL,AH
   out DX,AL
   pop DX
   pop DS
ret near

SET_INT_VECTOR: ;; 212d009a
   pushf
   push DS
   shl BX,1
   shl BX,1
   cli
   push AX
   sub AX,AX
   mov DS,AX
   pop AX
   mov [BX],AX
   mov [BX+02],DX
   pop DS
   popf
ret near

GET_INT_VECTOR: ;; 212d00af
   pushf
   push DS
   shl BX,1
   shl BX,1
   cli
   sub AX,AX
   mov DS,AX
   mov AX,[BX]
   mov DX,[BX+02]
   pop DS
   popf
ret near

ENABLE_8259: ;; 212d00c2 ;; (@) Unaccessed.
   push AX
   push CX
   mov CX,[offset _ct_int_num+2*00]
   mov AH,01
   shl AH,CL
   not AH
   pushf
   cli
   in AL,21
   and AL,AH
   out 21,AL
   popf
   pop CX
   pop AX
ret near

DISABLE_8259: ;; 212d00da ;; (@) Unaccessed.
   push AX
   push CX
   mov CX,[offset _ct_int_num+2*00]
   mov AH,01
   shl AH,CL
   pushf
   cli
   in AL,21
   or AL,AH
   out 21,AL
   popf
   pop CX
   pop AX
ret near

_ct_scan_card: ;; 212d00f0
_sbc_scan_card: ;; 212d00f0
   push DS
   mov AX,segment A24dc0000
   mov DS,AX
   push SI
   mov SI,0220
L212d00fa:
   mov [offset _ct_io_addx],SI
   call far _sbc_check_card
   or AX,AX
   jnz L212d011b
   add SI,+10
   cmp SI,0260
   jbe L212d00fa
   mov word ptr [offset _ct_io_addx],0210
   call far _sbc_check_card
L212d011b:
   pop SI
   pop DS
ret far

_ct_card_here: ;; 212d011e
_sbc_check_card: ;; 212d011e
   push DS
   push AX
   mov AX,segment A24dc0000
   mov DS,AX
   pop AX
   sub BX,BX
   mov DX,[offset _ct_io_addx]
   add DL,06
   mov AL,C6
   out DX,AL
   sub AL,AL
   add DL,04
   out DX,AL
   in AL,DX
   cmp AL,C6
   jnz L212d0153
   sub DL,04
   mov AL,39
   out DX,AL
   sub AL,AL
   add DL,04
   out DX,AL
   in AL,DX
   cmp AL,39
   jnz L212d0153
   mov BX,0001
jmp near L212d0179
L212d0153:
   call far _sbc_dsp_reset
   jb L212d0179
   mov AL,E0
   call near SBC_WRITE_DSP_TIME
   jb L212d0179
   mov AL,C6
   call near SBC_WRITE_DSP_TIME
   jb L212d0179
   call near SBC_READ_DSP_TIME
   jb L212d0179
   cmp AL,39
   jnz L212d0179
   mov BX,0004
   push BX
   call near B212d01d9
   pop BX
L212d0179:
   mov AX,0100
   call near B212d0256
   mov AX,0460
   call near B212d0256
   mov AX,0480
   call near B212d0256
   mov AL,00
   call near B212d01b8
   jb L212d01b4
   mov AX,02FF
   call near B212d0256
   mov AX,0421
   call near B212d0256
   mov AL,C0
   call near B212d01b8
   jb L212d01b4
   mov AX,0460
   call near B212d0256
   mov AX,0480
   call near B212d0256
   add BX,+02
L212d01b4:
   mov AX,BX
   pop DS
ret far

B212d01b8:
   push CX
   push DX
   mov CX,0040
   mov AH,AL
   and AH,E0
   mov DX,[offset _ct_io_addx]
   add DL,08
L212d01c9:
   in AL,DX
   and AL,E0
   cmp AH,AL
   jz L212d01d5
   loop L212d01c9
   stc
jmp near L212d01d6
L212d01d5:
   clc
L212d01d6:
   pop DX
   pop CX
ret near

B212d01d9:
   push BP
   sub SP,+04
   mov BP,SP
   mov BX,0008
   call near GET_INT_VECTOR
   mov [BP+00],AX
   mov [BP+02],DX
   cli
   in AL,21
   mov [offset _ct_int_num+2*01],AX
   mov AL,FE
   out 21,AL
   mov AX,1B58
   call near B212d027f
   mov BX,0008
   mov DX,CS
   mov AX,028C
   call near SET_INT_VECTOR
   sub AX,AX
   sub CX,CX
   sti
L212d020b:
   or AX,AX
   jz L212d020b
L212d020f:
   or AX,AX
   jnz L212d020f
L212d0213:
   nop
   inc CX
   or AX,AX
   jz L212d0213
   cli
   mov AX,[offset _ct_int_num+2*01]
   out 21,AL
   mov AX,FFFF
   call near B212d027f
   sti
   mov BX,0008
   mov DX,[BP+02]
   mov AX,[BP+00]
   call near SET_INT_VECTOR
   mov AX,CX
   shl CX,1
   shl CX,1
   shl CX,1
   add AX,CX
   mov CL,0A
   shr AX,CL
   mov [offset _ct_int_num+2*01],AX
   mov CX,AX
   shl AX,1
   add CX,AX
   shl AX,1
   add CX,AX
   mov [offset _ct_int_num+2*02],CX
   add SP,+04
   pop BP
ret near

B212d0256:
   push AX
   push CX
   push DX
   mov DX,[offset _ct_io_addx]
   add DL,08
   xchg AH,AL
   out DX,AL
   mov CX,[offset _ct_int_num+2*01]
L212d0267:
   nop
   dec CX
   or CX,CX
   jnz L212d0267
   inc DX
   mov AL,AH
   out DX,AL
   mov CX,[offset _ct_int_num+2*02]
L212d0275:
   nop
   dec CX
   or CX,CX
   jnz L212d0275
   pop DX
   pop CX
   pop AX
ret near

B212d027f:
   push AX
   mov AL,36
   out 43,AL
   pop AX
   out 40,AL
   mov AL,AH
   out 40,AL
ret near

X212d028c:
   not AX
   push AX
   mov AL,20
   out 20,AL
   pop AX
iret

Y212d0295:	byte

_sbc_dsp_reset: ;; 212d0296
   push DS
   mov AX,segment A24dc0000
   mov DS,AX
   mov DX,[offset _ct_io_addx]
   add DL,06
   mov AL,01
   out DX,AL
   sub AL,AL
L212d02a8:
   dec AL
   jnz L212d02a8
   out DX,AL
   mov CX,0020
L212d02b0:
   call near SBC_READ_DSP_TIME
   jb L212d02bd
   cmp AL,AA
   jnz L212d02bd
   sub AX,AX
jmp near L212d02c3
L212d02bd:
   loop L212d02b0
   stc
   mov AX,0001
L212d02c3:
   pop DS
ret far

Y212d02c5:	byte

_sbfm_init: ;; 212d02c6
   push DS
   mov AX,segment A24dc0000
   mov DS,AX
   mov AX,[offset _ct_io_addx]
   mov BX,FFFD
   call far SBFM_CMF_DRV
   mov BX,FFFF
   call far SBFM_CMF_DRV
   jb L212d02fd
   mov DX,segment A24dc0000
   mov AX,offset _ct_music_status
   mov BX,0001
   call far SBFM_CMF_DRV
   mov [CS:offset Y212d0301+2],DX
   mov [CS:offset Y212d0301],AX
   mov AX,0001
jmp near L212d02ff
L212d02fd:
   sub AX,AX
L212d02ff:
   pop DS
ret far

Y212d0301:	dword

_sbfm_status_addx: ;; 212d0305 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov BX,0001
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_play_music: ;; 212d0318
   push BP
   mov BP,SP
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov BX,0006
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_instrument: ;; 212d032b
   push BP
   mov BP,SP
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov CX,[BP+0A]
   mov BX,0002
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_reset: ;; 212d0341
   push BP
   mov BP,SP
   mov BX,0008
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_sys_speed: ;; 212d034e ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov BX,0003
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_song_speed: ;; 212d035e ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov BX,0004
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_stop_music: ;; 212d036e
   mov BX,0007
   call far SBFM_CMF_DRV
ret far

_sbfm_version: ;; 212d0377 ;; (@) Unaccessed.
   mov BX,0000
   call far SBFM_CMF_DRV
ret far

_sbfm_transpose: ;; 212d0380 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov BX,0005
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_pause_music: ;; 212d0390 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov BX,0009
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_resume_music: ;; 212d039d ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov BX,000A
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_read_status: ;; 212d03aa ;; (@) Unaccessed.
   pushf
   push DS
   mov AX,segment A24dc0000
   mov DS,AX
   sub AX,AX
   cli
   cmp byte ptr [offset _ct_music_status],00
   jz L212d03c1
   mov AL,FF
   xchg AL,[offset _ct_music_status]
L212d03c1:
   pop DS
   popf
ret far

_sbfm_terminate: ;; 212d03c4
   mov BX,FFFE
   call far SBFM_CMF_DRV
   mov BX,0001
   mov DX,[CS:offset Y212d0301+2]
   mov AX,[CS:offset Y212d0301]
   call far SBFM_CMF_DRV
ret far

X212d03de:
   push BP
   mov BP,SP
   call far SBFM_CMF_DRV
   pop BP
ret far

_sbfm_channel_map: ;; 212d03e8 ;; (@) Unaccessed.
   mov BX,000C
   call far SBFM_CMF_DRV
ret far

_sbfm_fading: ;; 212d03f1 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push DI
   mov AX,[BP+06]
   mov DX,[BP+08]
   mov CX,[BP+0A]
   mov DI,[BP+0C]
   mov BX,000E
   call far SBFM_CMF_DRV
   pop DI
   pop BP
ret far

X212d040c:	dword	;; (@) Unaccessed.

;; === External Library Modules ===
Segment 216e ;; SBCRWIO.ASM, VECTOR.ASM, SCANCARD.ASM, MUSDATA.ASM, SBCDATA.ASM, CARDHERE.ASM, DSPRESET.ASM, CMFASM.ASM, CMFDRV.ASM
SBFM_CMF_DRV: ;; 216e0000
jmp near B216e110f

X216e0003:	db "FMDRV",00	;; (@) Unaccessed.
Y216e0009:	dw 0220
Y216e000b:	byte
Y216e000c:	dw 0114
Y216e000e:	ds 4*0008
Y216e002e:	word
Y216e0030:	word
Y216e0032:	word
Y216e0034:	word
Y216e0036:	word
Y216e0038:	word
Y216e003a:	word
Y216e003c:	word
Y216e003e:	word
Y216e0040:	word
Y216e0042:	word
Y216e0044:	dword
Y216e0048:	db 21,21,d1,07,a3,a4,46,25,00,00,0a,00,00,00,00,00
		db 22,22,0f,0f,f6,f6,95,36,00,00,0a,00,00,00,00,00
		db e1,e1,00,00,44,54,24,34,02,02,07,00,00,00,00,00
		db a5,b1,d2,80,81,f1,03,05,00,00,02,00,00,00,00,04
		db 71,22,c5,05,6e,8b,17,0e,00,00,02,00,00,00,00,04
		db 32,21,16,80,73,75,24,57,00,00,0e,00,00,00,00,04
		db 01,11,4f,00,f1,d2,53,74,00,00,06,00,00,00,00,04
		db 07,12,4f,00,f2,f2,60,72,00,00,08,00,00,00,00,04
		db 31,a1,1c,80,51,54,03,67,00,00,0e,00,00,00,00,04
		db 31,a1,1c,80,41,92,0b,3b,00,00,0e,00,00,00,00,04
		db 31,16,87,80,a1,7d,11,43,00,00,08,00,00,00,00,04
		db 30,b1,c8,80,d5,61,19,1b,00,00,0c,00,00,00,00,04
		db f1,21,01,0d,97,f1,17,18,00,00,08,00,00,00,00,04
		db 32,16,87,80,a1,7d,10,33,00,00,08,00,00,00,00,04
		db 01,12,4f,00,71,52,53,7c,00,00,0a,00,00,00,00,04
		db 02,03,8d,03,d7,f5,37,18,00,00,04,00,00,00,00,00
Y216e0148:	ds 000b
Y216e0153:	ds 000b
Y216e015e:	ds 000b
Y216e0169:	ds 000b
Y216e0174:	ds 000b
Y216e017f:	ds 000b
Y216e018a:	ds 2*000b
Y216e01a0:	ds 2*000b
Y216e01b6:	db 63
Y216e01b7:	db 63
Y216e01b8:	word
Y216e01ba:	word
Y216e01bc:	byte
Y216e01bd:	db 00,01,02,08,09,0a,10,11,12
Y216e01c6:	db 01,11,4f,00,f1
Y216e01cb:	db f2,53,74,00,00
Y216e01d0:	db 08,10,14,12,15
Y216e01d5:	db 11,10,08,04,02,01,06,07,08,08,07
Y216e01e0:	byte
Y216e01e1:	byte
Y216e01e2:	byte
Y216e01e3:	byte
Y216e01e4:	byte
Y216e01e5:	byte
Y216e01e6:	byte
Y216e01e7:	byte
X216e01e8:	byte	;; (@) Unaccessed.
Y216e01e9:	ds 0010
Y216e01f9:	ds 2*0010
Y216e0219:	db 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
Y216e0229:	dw offset B216e0d29,offset B216e0da0,offset B216e0f8d,offset B216e0efa
		dw offset B216e0f90,offset B216e0f8e,offset B216e0f8d,offset B216e100a
Y216e0239:	dw offset B216e0f10,offset B216e0f16,offset B216e0f3c,offset B216e0f3a
Y216e0241:	dw offset B216e1017,offset B216e0f8f,offset B216e0f8d,offset B216e0f8e
		dw offset B216e0f8f,offset B216e0f8f,offset B216e0f8f,offset B216e102d
		dw offset B216e0f8f,offset B216e0f8f,offset B216e0f8f,offset B216e0f8f
		dw offset B216e1038,offset B216e0f8f,offset B216e0f8f,offset B216e103c
Y216e0261:	dw offset B216e116d,offset B216e1171,offset B216e1184,offset B216e11c6
		dw offset B216e11ca,offset B216e11d3,offset B216e0c39,offset B216e11b6
		dw offset B216e0c00,offset B216e0c98,offset B216e0cad,offset B216e11d9
		dw offset B216e11e6,offset B216e11ed,offset B216e11fb
Y216e027f:	dw offset B216e1487,offset B216e149d,offset B216e14a6
Y216e0285:	db 00,01,02,03,04,05,06,07,08,09,0a,0b,00,01,02,03
		db 04,05,06,07,08,09,0a,0b,10,11,12,13,14,15,16,17
		db 18,19,1a,1b,20,21,22,23,24,25,26,27,28,29,2a,2b
		db 30,31,32,33,34,35,36,37,38,39,3a,3b,40,41,42,43
		db 44,45,46,47,48,49,4a,4b,50,51,52,53,54,55,56,57
		db 58,59,5a,5b,60,61,62,63,64,65,66,67,68,69,6a,6b
		db 70,71,72,73,74,75,76,77,78,79,7a,7b,70,71,72,73
		db 74,75,76,77,78,79,7a,7b,7b,7b,7b,7b,7b,7b,7b,7b
Y216e0305:	dw 0157,0157,0158,0158,0158,0158,0159,0159,0159,015a,015a,015a,015b,015b,015b,015c
		dw 015c,015c,015d,015d,015d,015d,015e,015e,015e,015f,015f,015f,0160,0160,0160,0161
		dw 0161,0161,0162,0162,0162,0163,0163,0163,0164,0164,0164,0164,0165,0165,0165,0166
		dw 0166,0166,0167,0167,0167,0168,0168,0168,0169,0169,0169,016a,016a,016a,016b,016b
		dw 016b,016c,016c,016c,016d,016d,016d,016e,016e,016e,016f,016f,016f,0170,0170,0170
		dw 0171,0171,0171,0172,0172,0172,0173,0173,0173,0174,0174,0174,0175,0175,0175,0176
		dw 0176,0176,0177,0177,0177,0178,0178,0178,0179,0179,0179,017a,017a,017a,017b,017b
		dw 017b,017c,017c,017c,017d,017d,017d,017e,017e,017e,017f,017f,0180,0180,0180,0181
		dw 0181,0181,0182,0182,0182,0183,0183,0183,0184,0184,0184,0185,0185,0185,0186,0186
		dw 0187,0187,0187,0188,0188,0188,0189,0189,0189,018a,018a,018a,018b,018b,018b,018c
		dw 018c,018d,018d,018d,018e,018e,018e,018f,018f,018f,0190,0190,0191,0191,0191,0192
		dw 0192,0192,0193,0193,0193,0194,0194,0195,0195,0195,0196,0196,0196,0197,0197,0197
		dw 0198,0198,0199,0199,0199,019a,019a,019a,019b,019b,019c,019c,019c,019d,019d,019d
		dw 019e,019e,019e,019f,019f,01a0,01a0,01a0,01a1,01a1,01a1,01a2,01a2,01a3,01a3,01a3
		dw 01a4,01a4,01a5,01a5,01a5,01a6,01a6,01a6,01a7,01a7,01a8,01a8,01a8,01a9,01a9,01a9
		dw 01aa,01aa,01ab,01ab,01ab,01ac,01ac,01ad,01ad,01ad,01ae,01ae,01ae,01af,01af,01b0
		dw 01b0,01b0,01b1,01b1,01b2,01b2,01b2,01b3,01b3,01b4,01b4,01b4,01b5,01b5,01b6,01b6
		dw 01b6,01b7,01b7,01b8,01b8,01b8,01b9,01b9,01ba,01ba,01ba,01bb,01bb,01bc,01bc,01bc
		dw 01bd,01bd,01be,01be,01be,01bf,01bf,01c0,01c0,01c0,01c1,01c1,01c2,01c2,01c2,01c3
		dw 01c3,01c4,01c4,01c4,01c5,01c5,01c6,01c6,01c6,01c7,01c7,01c8,01c8,01c9,01c9,01c9
		dw 01ca,01ca,01cb,01cb,01cb,01cc,01cc,01cd,01cd,01cd,01ce,01ce,01cf,01cf,01d0,01d0
		dw 01d0,01d1,01d1,01d2,01d2,01d3,01d3,01d3,01d4,01d4,01d5,01d5,01d5,01d6,01d6,01d7
		dw 01d7,01d8,01d8,01d8,01d9,01d9,01da,01da,01db,01db,01db,01dc,01dc,01dd,01dd,01de
		dw 01de,01de,01df,01df,01e0,01e0,01e1,01e1,01e1,01e2,01e2,01e3,01e3,01e4,01e4,01e5
		dw 01e5,01e5,01e6,01e6,01e7,01e7,01e8,01e8,01e8,01e9,01e9,01ea,01ea,01eb,01eb,01ec
		dw 01ec,01ec,01ed,01ed,01ee,01ee,01ef,01ef,01f0,01f0,01f0,01f1,01f1,01f2,01f2,01f3
		dw 01f3,01f4,01f4,01f5,01f5,01f5,01f6,01f6,01f7,01f7,01f8,01f8,01f9,01f9,01fa,01fa
		dw 01fa,01fb,01fb,01fc,01fc,01fd,01fd,01fe,01fe,01ff,01ff,01ff,0200,0200,0201,0201
		dw 0202,0202,0203,0203,0204,0204,0205,0205,0206,0206,0206,0207,0207,0208,0208,0209
		dw 0209,020a,020a,020b,020b,020c,020c,020d,020d,020e,020e,020e,020f,020f,0210,0210
		dw 0211,0211,0212,0212,0213,0213,0214,0214,0215,0215,0216,0216,0217,0217,0218,0218
		dw 0219,0219,021a,021a,021a,021b,021b,021c,021c,021d,021d,021e,021e,021f,021f,0220
		dw 0220,0221,0221,0222,0222,0223,0223,0224,0224,0225,0225,0226,0226,0227,0227,0228
		dw 0228,0229,0229,022a,022a,022b,022b,022c,022c,022d,022d,022e,022e,022f,022f,0230
		dw 0230,0231,0231,0232,0232,0233,0233,0234,0234,0235,0235,0236,0236,0237,0237,0238
		dw 0238,0239,0239,023a,023b,023b,023c,023c,023d,023d,023e,023e,023f,023f,0240,0240
		dw 0241,0241,0242,0242,0243,0243,0244,0244,0245,0245,0246,0246,0247,0248,0248,0249
		dw 0249,024a,024a,024b,024b,024c,024c,024d,024d,024e,024e,024f,024f,0250,0251,0251
		dw 0252,0252,0253,0253,0254,0254,0255,0255,0256,0256,0257,0258,0258,0259,0259,025a
		dw 025a,025b,025b,025c,025c,025d,025e,025e,025f,025f,0260,0260,0261,0261,0262,0262
		dw 0263,0264,0264,0265,0265,0266,0266,0267,0267,0268,0269,0269,026a,026a,026b,026b
		dw 026c,026c,026d,026e,026e,026f,026f,0270,0270,0271,0272,0272,0273,0273,0274,0274
		dw 0275,0275,0276,0277,0277,0278,0278,0279,0279,027a,027b,027b,027c,027c,027d,027d
		dw 027e,027f,027f,0280,0280,0281,0282,0282,0283,0283,0284,0284,0285,0286,0286,0287
		dw 0287,0288,0289,0289,028a,028a,028b,028b,028c,028d,028d,028e,028e,028f,0290,0290
		dw 0291,0291,0292,0293,0293,0294,0294,0295,0296,0296,0297,0297,0298,0299,0299,029a
		dw 029a,029b,029c,029c,029d,029d,029e,029f,029f,02a0,02a0,02a1,02a2,02a2,02a3,02a3
		dw 02a4,02a5,02a5,02a6,02a6,02a7,02a8,02a8,02a9,02aa,02aa,02ab,02ab,02ac,02ad,02ad

B216e0905:
   pushf
   push DS
   push AX
   sub AX,AX
   mov DS,AX
   pop AX
   shl BX,1
   shl BX,1
   cli
   mov [BX],AX
   mov [BX+02],DX
   pop DS
   popf
ret near

B216e091a:
   pushf
   push DS
   sub AX,AX
   mov DS,AX
   shl BX,1
   shl BX,1
   cli
   mov AX,[BX]
   mov DX,[BX+02]
   pop DS
   popf
ret near

B216e092d:
   mov [offset Y216e0036],AX
   mov AL,36
   out 43,AL
   mov AL,[offset Y216e0036]
   out 40,AL
   mov AL,AH
   out 40,AL
ret near

B216e093e:
   push AX
   push CX
   push DX
   mov DX,[offset Y216e0009]
   xchg AH,AL
   out DX,AL
   mov CX,[offset Y216e002e]
L216e094c:
   nop
   dec CX
   or CX,CX
   jnz L216e094c
   inc DX
   mov AL,AH
   out DX,AL
   mov CX,[offset Y216e0030]
L216e095a:
   nop
   dec CX
   or CX,CX
   jnz L216e095a
   pop DX
   pop CX
   pop AX
ret near

B216e0964:
   pushf
   cli
   mov BX,0008
L216e0969:
   mov AH,83
   add AL,BL
   mov AL,13
   call near B216e093e
   cmp byte ptr [BX+offset Y216e0148],7F
   ja L216e0993
   shl BX,1
   mov DX,[BX+offset Y216e018a]
   shr BX,1
   mov AH,A0
   add AH,BL
   mov AL,DL
   call near B216e093e
   mov AH,B0
   add AH,BL
   mov AL,DH
   call near B216e093e
L216e0993:
   dec BL
   jns L216e0969
   cmp byte ptr [offset Y216e01e7],00
   jz L216e09ab
   and byte ptr [offset Y216e01e6],E0
   mov AL,[offset Y216e01e6]
   mov AH,BD
   call near B216e093e
L216e09ab:
   popf
ret near

B216e09ad:
   push ES
   push DI
   push SI
   mov CX,CS
   mov ES,CX
   mov CX,0010
   mov DI,offset Y216e01e9
   sub AL,AL
   repz stosb
   mov CX,000B
   mov AL,FF
   mov DI,offset Y216e0148
   repz stosb
   mov DI,offset Y216e01bd
   mov BL,00
L216e09cd:
   call near B216e0bee
   mov AX,0800
   call near B216e093e
   mov AH,[DI]
   mov CX,0004
   mov SI,offset Y216e01c6
L216e09de:
   add AH,20
   lodsb
   call near B216e093e
   add AH,03
   lodsb
   call near B216e093e
   sub AH,03
   loop L216e09de
   add AH,60
   lodsb
   call near B216e093e
   add AH,03
   lodsb
   call near B216e093e
   mov AH,[DI]
   add AH,BL
   lodsb
   call near B216e093e
   inc DI
   inc BL
   cmp BL,09
   jb L216e09cd
   pop SI
   pop DI
   pop ES
ret near

B216e0a13:
   push DS
   push BX
   lds BX,[offset Y216e000e+4*06]
   mov [BX],AL
   pop BX
   pop DS
ret near

B216e0a1e:
   push ES
   push CX
   push DI
   cmp AL,[offset Y216e01e0]
   jb L216e0a2a
jmp near L216e0b1b
L216e0a2a:
   cbw
   shl AX,1
   shl AX,1
   shl AX,1
   shl AX,1
   les DI,[offset Y216e000e+4*02]
   add DI,AX
   mov AL,[ES:DI+03]
   cmp byte ptr [offset Y216e01e7],00
   jz L216e0a4d
   cmp BL,07
   jb L216e0a4d
   mov AL,[ES:DI+02]
L216e0a4d:
   mov AH,AL
   and AX,C03F
   mov [BX+offset Y216e0169],AH
   sub AL,3F
   neg AL
   mov [BX+offset Y216e017f],AL
   mul byte ptr [offset Y216e01b6]
   add AL,AL
   adc AH,00
   mov [BX+offset Y216e0174],AH
   cmp byte ptr [offset Y216e01e7],00
   jz L216e0a77
   cmp BX,+06
   ja L216e0add
L216e0a77:
   mov AH,[BX+offset Y216e01bd]
   add AH,20
   mov AL,[ES:DI]
   inc DI
   call near B216e093e
   add AH,03
   mov AL,[ES:DI]
   inc DI
   call near B216e093e
   sub AH,03
   add AH,20
   mov AL,[ES:DI]
   inc DI
   call near B216e093e
   inc DI
   mov CX,0002
L216e0aa0:
   add AH,20
   mov AL,[ES:DI]
   inc DI
   call near B216e093e
   add AH,03
   mov AL,[ES:DI]
   inc DI
   call near B216e093e
   sub AH,03
   loop L216e0aa0
   add AH,60
   mov AL,[ES:DI]
   inc DI
   call near B216e093e
   add AH,03
   mov AL,[ES:DI]
   inc DI
   call near B216e093e
   sub AH,03
   mov AH,BL
   add AH,C0
   mov AL,[ES:DI]
   call near B216e093e
jmp near L216e0b1b
L216e0add:
   mov AH,[BX+offset Y216e01cb]
   add AH,20
   mov AL,[ES:DI]
   inc DI
   inc DI
   call near B216e093e
   add AH,20
   inc DI
   inc DI
   mov CX,0002
L216e0af4:
   add AH,20
   mov AL,[ES:DI]
   inc DI
   inc DI
   call near B216e093e
   loop L216e0af4
   add AH,60
   mov AL,[ES:DI]
   inc DI
   inc DI
   call near B216e093e
   mov AH,[BX+offset Y216e01d5]
   add AH,C0
   mov AL,[ES:DI]
   call near B216e093e
jmp near L216e0b1b
L216e0b1b:
   pop DI
   pop CX
   pop ES
ret near

B216e0b1f:
   push SI
   push BX
   push DS
   sub BX,BX
   sub DX,DX
   lds SI,[offset Y216e000e+4*03]
L216e0b2a:
   lodsb
   push AX
   and AL,7F
   cbw
   add BX,AX
   adc DX,+00
   pop AX
   or AL,AL
   jns L216e0b45
   mov AL,07
L216e0b3b:
   shl BX,1
   rcl DX,1
   dec AL
   jnz L216e0b3b
jmp near L216e0b2a
L216e0b45:
   pop DS
   mov AX,BX
   mov [offset Y216e000e+4*03],SI
   pop BX
   pop SI
ret near

B216e0b4f:
   push CX
   add [offset Y216e000e+4*03+0],AX
   jnb L216e0b5c
   add word ptr [offset Y216e000e+4*03+2],1000
L216e0b5c:
   mov CL,04
   mov DH,DL
   sub DL,DL
   shl DX,CL
   add [offset Y216e000e+4*03+2],DX
   mov SI,[offset Y216e000e+4*03+0]
   pop CX
ret near

B216e0b6e:
   push ES
   mov CX,DS
   mov ES,CX
   mov CX,[offset Y216e003a]
   mov AH,AL
   or AL,80
   mov DI,offset Y216e0148
   repnz scasb
   jz L216e0be6
   mov CX,[offset Y216e003a]
   mov AL,FF
   mov DI,offset Y216e0148
   repnz scasb
   jz L216e0be6
   mov CX,[offset Y216e003a]
   mov AL,7F
   mov DI,offset Y216e0148
L216e0b98:
   cmp AL,[DI]
   jb L216e0ba1
   inc DI
   loop L216e0b98
jmp near L216e0ba4
L216e0ba1:
   inc DI
jmp near L216e0be6
L216e0ba4:
   push SI
   sub SI,SI
   mov CX,[offset Y216e003a]
   mov DI,offset Y216e01a0
   mov AX,DI
L216e0bb0:
   mov DX,[DI]
   sub DX,[offset Y216e0040]
   neg DX
   cmp DX,SI
   jbe L216e0bc0
   mov SI,DX
   mov AX,DI
L216e0bc0:
   inc DI
   inc DI
   dec CX
   jnz L216e0bb0
   sub AX,offset Y216e01a0
   mov BX,AX
   mov AX,[BX+offset Y216e018a]
   shr BX,1
   mov DH,A0
   xchg DH,AH
   add AH,BL
   call near B216e093e
   add AH,10
   mov AL,DH
   call near B216e093e
   mov AX,BX
   pop SI
jmp near L216e0bec
L216e0be6:
   sub DI,offset Y216e0148+1
   mov AX,DI
L216e0bec:
   pop ES
ret near

B216e0bee:
   mov word ptr [offset Y216e003a],0009
   mov AX,00C0
   mov [offset Y216e01e6],AX
   mov AH,BD
   call near B216e093e
ret near

B216e0c00:
   mov byte ptr [offset Y216e01b6],FF
   mov byte ptr [offset Y216e01b7],FF
   call near B216e1198
   call near B216e0bee
   mov CX,0008
   mov DI,offset Y216e0219
   mov AX,0101
   repz stosw
   mov byte ptr [offset Y216e01e0],10
   mov word ptr [offset Y216e000e+4*02+0],offset Y216e0048
   mov [offset Y216e000e+4*02+2],DS
   call near B216e09ad
   mov word ptr [offset Y216e0034],48D3
   sub AX,AX
   mov [offset Y216e0042],AX
ret near

B216e0c39:
   mov CX,AX
   mov AX,FFFE
   cmp byte ptr [offset Y216e01e1],00
   jnz L216e0c97
   mov [offset Y216e000e+4*04+0],CX
   mov [offset Y216e000e+4*04+2],DX
   mov [offset Y216e000e+4*03+0],CX
   mov [offset Y216e000e+4*03+2],DX
   mov CX,0010
   sub AX,AX
   mov DI,offset Y216e01f9
   repz stosw
   mov CX,0009
   mov AL,FF
   mov DI,offset Y216e0148
   repz stosb
   call near B216e0b1f
   mov [offset Y216e000e+4*05+0],AX
   mov [offset Y216e000e+4*05+2],DX
   mov word ptr [offset Y216e0040],0000
   mov AX,[offset Y216e0034]
   call near B216e092d
   mov word ptr [offset Y216e0038],0000
   call near B216e0bee
   pushf
   cli
   mov byte ptr [offset Y216e01e1],01
   mov AL,FF
   call near B216e0a13
   popf
   sub AX,AX
L216e0c97:
ret near

B216e0c98:
   mov AX,FFFD
   cmp byte ptr [offset Y216e01e1],01
   jnz L216e0cac
   mov byte ptr [offset Y216e01e1],02
   call near B216e0964
   sub AX,AX
L216e0cac:
ret near

B216e0cad:
   mov AX,FFFC
   cmp byte ptr [offset Y216e01e1],02
   jnz L216e0cbe
   mov byte ptr [offset Y216e01e1],01
   sub AX,AX
L216e0cbe:
ret near

B216e0cbf:
   push ES
   inc word ptr [offset Y216e0040]
   mov AX,[offset Y216e000e+4*03+0]
   shr AX,1
   shr AX,1
   shr AX,1
   shr AX,1
   add [offset Y216e000e+4*03+2],AX
   and word ptr [offset Y216e000e+4*03+0],+0F
L216e0cd8:
   les SI,[offset Y216e000e+4*03]
   mov AL,[ES:SI]
   or AL,AL
   jns L216e0cfa
   inc SI
   mov AH,AL
   and AL,0F
   mov [offset Y216e003c],AL
   shr AH,1
   shr AH,1
   shr AH,1
   shr AH,1
   sub AH,08
   mov [offset Y216e003e],AH
L216e0cfa:
   mov BX,[offset Y216e003e]
   shl BX,1
   call near [BX+offset Y216e0229]
   mov [offset Y216e000e+4*03],SI
   cmp byte ptr [offset Y216e01e1],00
   jz L216e0d27
   call near B216e0b1f
   mov [offset Y216e000e+4*05+0],AX
   mov [offset Y216e000e+4*05+2],DX
   or AX,DX
   jz L216e0cd8
   sub word ptr [offset Y216e000e+4*05+0],+01
   sbb word ptr [offset Y216e000e+4*05+2],+00
L216e0d27:
   pop ES
ret near

B216e0d29:
   mov AX,[ES:SI]
   inc SI
   inc SI
   mov [offset Y216e01e2],AL
   mov [offset Y216e01e3],AH
L216e0d35:
   push ES
   mov AX,DS
   mov ES,AX
   mov CX,[offset Y216e003a]
   mov AH,[offset Y216e003c]
   cmp CL,06
   ja L216e0d64
   cmp AH,0B
   jb L216e0d64
   sub BH,BH
   mov BL,AH
   mov AL,[BX+offset Y216e01cb]
   not AL
   and AL,[offset Y216e01e6]
   mov [offset Y216e01e6],AL
   mov AH,BD
   call near B216e093e
jmp near L216e0d9c
L216e0d64:
   mov AL,[offset Y216e01e2]
   mov DI,offset Y216e015e
L216e0d6a:
   repnz scasb
   jnz L216e0d9c
   mov BX,DI
   sub BX,offset Y216e015e+1
   cmp AH,[BX+offset Y216e0148]
   jz L216e0d7e
   jcxz L216e0d9c
jmp near L216e0d6a
L216e0d7e:
   or byte ptr [BX+offset Y216e0148],80
   shl BX,1
   mov AX,[BX+offset Y216e018a]
   shr BX,1
   mov DL,AH
   mov AH,A0
   add AH,BL
   call near B216e093e
   mov AL,DL
   add AH,10
   call near B216e093e
L216e0d9c:
   pop ES
ret near
L216e0d9e:
jmp near L216e0d35

B216e0da0:
   mov AX,[ES:SI]
   inc SI
   inc SI
   mov [offset Y216e01e2],AL
   mov [offset Y216e01e3],AH
   or AH,AH
   jz L216e0d9e
   mov AL,[offset Y216e003c]
   mov BL,AL
   sub BH,BH
   cmp BH,[BX+offset Y216e0219]
   jz L216e0e21
   cmp byte ptr [offset Y216e01e7],00
   jz L216e0dcd
   cmp AL,0B
   jb L216e0dcd
   call near B216e0e22
jmp near L216e0e21
L216e0dcd:
   call near B216e0b6e
   mov BX,AX
   mov AL,[offset Y216e003c]
   xchg AL,[BX+offset Y216e0148]
   and AL,7F
   cmp AL,[offset Y216e003c]
   jz L216e0dec
   mov DI,[offset Y216e003c]
   mov AL,[DI+offset Y216e01e9]
   call near B216e0a1e
L216e0dec:
   mov CL,[offset Y216e01e3]
   or CL,80
   mov AL,[BX+offset Y216e0174]
   mul CL
   mov AL,3F
   sub AL,AH
   or AL,[BX+offset Y216e0169]
   mov AH,[BX+offset Y216e01bd]
   add AH,43
   call near B216e093e
   call near B216e0e75
   mov DL,AH
   mov AH,A0
   add AH,BL
   call near B216e093e
   mov AL,DL
   or AL,20
   add AH,10
   call near B216e093e
L216e0e21:
ret near

B216e0e22:
   sub AL,05
   cbw
   mov BX,AX
   mov AL,[BX+offset Y216e01d0]
   or [offset Y216e01e6],AL
   mov CL,[offset Y216e01e3]
   or CL,80
   mov AL,[BX+offset Y216e0174]
   mul CL
   mov AL,3F
   sub AL,AH
   or AL,[BX+offset Y216e0169]
   mov AH,[BX+offset Y216e01cb]
   cmp BL,06
   jnz L216e0e50
   add AH,03
L216e0e50:
   add AH,40
   call near B216e093e
   call near B216e0e75
   mov DL,AH
   mov AH,A0
   add AH,[BX+offset Y216e01d5]
   call near B216e093e
   mov AL,DL
   add AH,10
   call near B216e093e
   mov AL,[offset Y216e01e6]
   mov AH,BD
   call near B216e093e
ret near

B216e0e75:
   mov AL,[offset Y216e01e2]
   mov [BX+offset Y216e015e],AL
   cbw
   mov DI,[offset Y216e0042]
   add DI,AX
   jns L216e0e89
   sub DI,DI
jmp near L216e0e92
L216e0e89:
   cmp DI,0080
   jb L216e0e92
   mov DI,007F
L216e0e92:
   mov AL,[DI+offset Y216e0285]
   mov [BX+offset Y216e0153],AL
   call near B216e0e9e
ret near

B216e0e9e:
   mov DL,AL
   and DL,70
   shr DL,1
   shr DL,1
   and AL,0F
   cbw
   xchg AL,AH
   shr AX,1
   shr AX,1
   mov DI,[offset Y216e003c]
   shl DI,1
   add AX,[DI+offset Y216e01f9]
   jns L216e0eca
   add AX,0300
   sub DL,04
   jns L216e0edf
   sub DL,DL
   sub AX,AX
jmp near L216e0edf
L216e0eca:
   cmp AX,0300
   jb L216e0edf
   sub AX,0300
   add DL,04
   cmp DL,1C
   jbe L216e0edf
   mov AX,02FF
   mov DL,1C
L216e0edf:
   shl AX,1
   mov DI,AX
   mov AX,[DI+offset Y216e0305]
   or AH,DL
   shl BX,1
   mov [BX+offset Y216e018a],AX
   mov CX,[offset Y216e0040]
   mov [BX+offset Y216e01a0],CX
   shr BX,1
ret near

B216e0efa:
   mov AX,[ES:SI]
   inc SI
   inc SI
   sub AL,66
   cmp AL,04
   jnb L216e0f0f
   mov BL,AL
   sub BH,BH
   shl BX,1
   call near [BX+offset Y216e0239]
L216e0f0f:
ret near

B216e0f10:
   mov AL,AH
   call near B216e0a13
ret near

B216e0f16:
   push AX
   call near B216e09ad
   pop AX
   mov CX,09C0
   mov [offset Y216e01e7],AH
   or AH,AH
   jz L216e0f29
   mov CX,06E0
L216e0f29:
   mov [offset Y216e01e6],CL
   mov [offset Y216e003a],CH
   mov AL,[offset Y216e01e6]
   mov AH,BD
   call near B216e093e
ret near

B216e0f3a:
   neg AH
B216e0f3c:
   push ES
   mov BX,CS
   mov ES,BX
   mov AL,AH
   cbw
   sar AX,1
   sar AX,1
   mov BX,[offset Y216e003c]
   shl BX,1
   mov [BX+offset Y216e01f9],AX
   shr BX,1
   mov CX,[offset Y216e003a]
   mov DI,offset Y216e0148
   mov AL,BL
L216e0f5d:
   repnz scasb
   jnz L216e0f8b
   push AX
   push CX
   push DI
   sub DI,offset Y216e0148+1
   mov BX,DI
   mov AL,[BX+offset Y216e0153]
   call near B216e0e9e
   mov DL,AH
   mov AH,A0
   add AH,BL
   call near B216e093e
   mov AL,DL
   or AL,20
   add AH,10
   call near B216e093e
   pop DI
   pop CX
   pop AX
   or CX,CX
   jnz L216e0f5d
L216e0f8b:
   pop ES
ret near

B216e0f8d:
   inc SI
B216e0f8e:
   inc SI
B216e0f8f:
ret near

B216e0f90:
   mov AL,[ES:SI]
   inc SI
L216e0f94:
   cmp AL,[offset Y216e01e0]
   jb L216e0fa0
   sub AL,[offset Y216e01e0]
jmp near L216e0f94
L216e0fa0:
   mov BX,[offset Y216e003c]
   add BX,offset Y216e01e9
   mov [BX],AL
   push ES
   mov AX,DS
   mov ES,AX
   cmp byte ptr [offset Y216e01e7],00
   jz L216e0fcd
   cmp word ptr [offset Y216e003c],+0B
   jb L216e0fcd
   mov BX,[offset Y216e003c]
   mov AL,[BX+offset Y216e01e9]
   sub BL,05
   call near B216e0a1e
jmp near L216e1008
L216e0fcd:
   mov CX,[offset Y216e003a]
   mov AL,[offset Y216e003c]
   or AL,80
   mov DI,offset Y216e0148
L216e0fd9:
   repnz scasb
   jnz L216e0fe5
   mov byte ptr [DI-01],FF
   or CX,CX
   jnz L216e0fd9
L216e0fe5:
   mov CX,[offset Y216e003a]
   mov DI,offset Y216e0148
L216e0fec:
   mov AL,[offset Y216e003c]
   repnz scasb
   jnz L216e1008
   mov BX,[offset Y216e003c]
   mov AL,[BX+offset Y216e01e9]
   mov BX,DI
   sub BX,offset Y216e0148+1
   call near B216e0a1e
   or CX,CX
   jnz L216e0fec
L216e1008:
   pop ES
ret near

B216e100a:
   mov BL,[offset Y216e003c]
   sub BH,BH
   shl BX,1
   call near [BX+offset Y216e0241]
ret near

B216e1017:
   mov [offset Y216e000e+4*03],SI
   cmp word ptr [offset Y216e000e+4*07+2],+00
   jz L216e1026
   call far [offset Y216e000e+4*07+0]
L216e1026:
   call near B216e0b1f
   call near B216e0b4f
ret near

B216e102d:
   mov [offset Y216e000e+4*03],SI
   call near B216e0b1f
   call near B216e0b4f
ret near

B216e1038:
   call near B216e1198
ret near

B216e103c:
   mov AL,[ES:SI]
   inc SI
   cmp AL,2F
   jnz L216e1047
   call near B216e1198
L216e1047:
   mov [offset Y216e000e+4*03],SI
   call near B216e0b1f
   call near B216e0b4f
ret near

A216e1052:
   push DS
   push ES
   push AX
   push BX
   push CX
   push DX
   push DI
   push SI
   push BP
   mov AX,CS
   mov DS,AX
   mov ES,AX
   cmp byte ptr [offset Y216e01e1],01
   jnz L216e10a8
   mov AX,[offset Y216e01b6]
   cmp AL,AH
   jz L216e1080
   dec word ptr [offset Y216e01b8]
   jnz L216e1080
   mov CX,[offset Y216e01ba]
   mov [offset Y216e01b8],CX
   call near B216e12a0
L216e1080:
   sub word ptr [offset Y216e000e+4*05+0],+01
   sbb word ptr [offset Y216e000e+4*05+2],+00
   jnb L216e10a8
   mov [offset Y216e0044+2],SS
   mov [offset Y216e0044+0],SP
   cli
   mov AX,CS
   mov SS,AX
   mov SP,offset Y216e1337
   cld
   call near B216e0cbf
   mov SS,[offset Y216e0044+2]
   mov SP,[offset Y216e0044+0]
L216e10a8:
   mov CX,[offset Y216e0032]
   mov AX,[offset Y216e0036]
   add [offset Y216e0038],AX
   jb L216e10bb
   cmp [offset Y216e0038],CX
   jb L216e10cc
L216e10bb:
   sub [offset Y216e0038],CX
   pushf
   call far [offset Y216e000e+4*00]
   cmp [offset Y216e0038],CX
   ja L216e10bb
jmp near L216e10d0
L216e10cc:
   mov AL,20
   out 20,AL
L216e10d0:
   pop BP
   pop SI
   pop DI
   pop DX
   pop CX
   pop BX
   pop AX
   pop ES
   pop DS
iret

A216e10da:
   push DS
   push ES
   push AX
   push BX
   push CX
   push DX
   push DI
   push SI
   push BP
   mov AX,CS
   mov DS,AX
   mov ES,AX
   cld
   in AL,60
   or AL,AL
   js L216e1101
   cmp AL,83
   jnz L216e1101
   mov AH,02
   int 16
   and AL,0C
   cmp AL,0C
   jnz L216e1101
   call near B216e0964
L216e1101:
   pop BP
   pop SI
   pop DI
   pop DX
   pop CX
   pop BX
   pop AX
   pop ES
   pop DS
jmp far [CS:offset Y216e000e+4*01]

B216e110f:	;; (@) No return.
   push DS
   push ES
   push AX
   push BX
   push CX
   push DX
   push DI
   push SI
   push BP
   mov BP,SP
   mov AX,CS
   mov DS,AX
   mov ES,AX
   mov AX,[BP+0C]
   cmp byte ptr [offset Y216e01e4],00
   jnz L216e115e
   mov byte ptr [offset Y216e01e4],01
   sti
   cld
   mov word ptr [BP+0C],FFFF
   or BX,BX
   js L216e1147
   cmp BX,+0F
   jnb L216e1157
   shl BX,1
   call near [BX+offset Y216e0261]
jmp near L216e1154
L216e1147:
   not BX
   cmp BX,+03
   jnb L216e1157
   shl BX,1
   call near [BX+offset Y216e027f]
L216e1154:
   mov [BP+0C],AX
L216e1157:
   mov byte ptr [offset Y216e01e4],00
jmp near L216e1163
L216e115e:
   mov word ptr [BP+0C],FFF8
L216e1163:
   pop BP
   pop SI
   pop DI
   pop DX
   pop CX
   pop BX
   pop AX
   pop ES
   pop DS
ret far

B216e116d:
   mov AX,[offset Y216e000c]
ret near

B216e1171:
   xchg DX,[offset Y216e000e+4*06+2]
   xchg AX,[offset Y216e000e+4*06+0]
   mov [BP+06],DX
   push AX
   sub AX,AX
   call near B216e0a13
   pop AX
ret near

B216e1184:
   mov [offset Y216e01e0],CL
   mov [offset Y216e000e+4*02+2],DX
   mov [offset Y216e000e+4*02+0],AX
   call near B216e0bee
   call near B216e09ad
   sub AX,AX
ret near

B216e1198:
   cmp byte ptr [offset Y216e01e1],00
   jz L216e11b5
   pushf
   cli
   sub AL,AL
   mov [offset Y216e01e1],AL
   mov AX,[offset Y216e0032]
   call near B216e092d
   call near B216e0964
   sub AX,AX
   call near B216e0a13
   popf
L216e11b5:
ret near

B216e11b6:
   mov AX,FFFD
   cmp byte ptr [offset Y216e01e1],00
   jz L216e11c5
   call near B216e1198
   sub AX,AX
L216e11c5:
ret near

B216e11c6:
   mov [offset Y216e0032],AX
ret near

B216e11ca:
   mov [offset Y216e0034],AX
   call near B216e092d
   sub AX,AX
ret near

B216e11d3:
   mov [offset Y216e0042],AX
   sub AX,AX
ret near

B216e11d9:
   pushf
   cli
   mov [offset Y216e000e+4*07+2],DX
   mov [offset Y216e000e+4*07+0],AX
   sub AX,AX
   popf
ret near

B216e11e6:
   mov [BP+06],CS
   mov AX,offset Y216e0219
ret near

B216e11ed:
   pushf
   cli
   mov DX,[offset Y216e000e+4*03+2]
   mov AX,[offset Y216e000e+4*03+0]
   mov [BP+06],DX
   popf
ret near

B216e11fb:
   push DX
   push AX
   mov [offset Y216e01ba],DI
   mov [offset Y216e01b8],DI
   mov AX,CX
   call near B216e1265
   mov AH,64
   call near B216e1276
   mov [offset Y216e01bc],AL
   pop AX
   cli
   cmp AX,FFFF
   jnz L216e121e
   mov AL,[offset Y216e01b6]
jmp near L216e1226
L216e121e:
   call near B216e1265
   mov AH,64
   call near B216e1276
L216e1226:
   mov [offset Y216e01b6],AL
   mov [offset Y216e01b7],AL
   sti
   mov CX,000B
   mov DI,offset Y216e0174
   mov SI,offset Y216e017f
   mov DL,AL
L216e1238:
   lodsb
   mul DL
   add AL,AL
   adc AH,00
   mov AL,AH
   stosb
   loop L216e1238
   pop AX
   call near B216e1265
   mov AH,64
   call near B216e1276
   mov [offset Y216e01b7],AL
ret near

X216e1252:	;; (@) Unaccessed.
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   mov AX,[BX+offset Y216e000e+0]
   mov DX,[BX+offset Y216e000e+2]
   mov [BP+06],DX
ret near

B216e1265:
   or AX,AX
   jns L216e126d
   sub AX,AX
jmp near L216e1275
L216e126d:
   cmp AX,0064
   jb L216e1275
   mov AX,0063
L216e1275:
ret near

B216e1276:
   push CX
   push DX
   mov DH,AH
   sub AH,AH
   div DH
   xchg AL,AH
   sub DL,DL
   mov CX,0008
L216e1285:
   shl DL,1
   shl AL,1
   jb L216e128f
   cmp AL,DH
   jb L216e1294
L216e128f:
   or DL,01
   sub AL,DH
L216e1294:
   loop L216e1285
   shl AL,1
   adc DL,00
   mov AL,DL
   pop DX
   pop CX
ret near

B216e12a0:
   mov CL,[offset Y216e01bc]
   mov AX,[offset Y216e01b6]
   cmp AL,AH
   jb L216e12b1
   sub AL,CL
   jnb L216e12b7
jmp near L216e12b5
L216e12b1:
   add AL,CL
   jnb L216e12b7
L216e12b5:
   mov AL,AH
L216e12b7:
   mov [offset Y216e01b6],AL
   mov DL,AL
   mov SI,offset Y216e017f
   mov DI,offset Y216e0174
   mov CX,000B
L216e12c5:
   lodsb
   mul DL
   add AL,AL
   adc AH,00
   mov AL,AH
   stosb
   loop L216e12c5
ret near

Y216e12d3:	ds 0064	;; (@) Stack base.
Y216e1337:	;; (@) Stack top.

B216e1337:
   push CX
   push DX
   mov CX,0040
   mov AH,AL
   and AH,E0
   mov DX,[offset Y216e0009]
L216e1345:
   in AL,DX
   and AL,E0
   cmp AH,AL
   jz L216e1351
   loop L216e1345
   stc
jmp near L216e1352
L216e1351:
   clc
L216e1352:
   pop DX
   pop CX
ret near

B216e1355:
   mov AX,0100
   call near B216e093e
   mov AX,0460
   call near B216e093e
   mov AX,0480
   call near B216e093e
   mov AL,00
   call near B216e1337
   jb L216e138e
   mov AX,02FF
   call near B216e093e
   mov AX,0421
   call near B216e093e
   mov AL,C0
   call near B216e1337
   jb L216e138e
   mov AX,0460
   call near B216e093e
   mov AX,0480
   call near B216e093e
   clc
L216e138e:
ret near

A216e138f:
   not AX
   push AX
   mov AL,20
   out 20,AL
   pop AX
iret

B216e1398:
   mov BX,0008
   call near B216e091a
   mov [offset Y216e000e+4*00+0],AX
   mov [offset Y216e000e+4*00+2],DX
   cli
   in AL,21
   mov [offset Y216e002e],AX
   mov AL,FE
   out 21,AL
   mov AX,1B58
   call near B216e092d
   mov BX,0008
   mov DX,CS
   mov AX,offset A216e138f
   call near B216e0905
   sub AX,AX
   sub CX,CX
   sti
L216e13c5:
   or AX,AX
   jz L216e13c5
L216e13c9:
   or AX,AX
   jnz L216e13c9
L216e13cd:
   nop
   inc CX
   or AX,AX
   jz L216e13cd
   cli
   mov AX,[offset Y216e002e]
   out 21,AL
   mov AX,[offset Y216e0032]
   call near B216e092d
   sti
   mov BX,0008
   mov DX,[offset Y216e000e+4*00+2]
   mov AX,[offset Y216e000e+4*00+0]
   call near B216e0905
   mov AX,CX
   shr CX,1
   add AX,CX
   mov CL,0A
   shr AX,CL
   mov [offset Y216e002e],AX
   mov CX,AX
   shl CX,1
   add AX,CX
   shl CX,1
   add AX,CX
   mov [offset Y216e0030],AX
   add word ptr [offset Y216e0009],+08
ret near

B216e140d:
   mov word ptr [offset Y216e0032],FFFF
   mov word ptr [offset Y216e0036],FFFF
   mov word ptr [offset Y216e0034],48D3
   mov [offset Y216e000e+4*06+2],CS
   mov word ptr [offset Y216e000e+4*06+0],offset Y216e01e5
   mov AX,0120
   call near B216e093e
   mov AX,0800
   call near B216e093e
   call near B216e0c00
   sub AX,AX
ret near

B216e143b:
   mov BX,0008
   call near B216e091a
   mov [offset Y216e000e+4*00+2],DX
   mov [offset Y216e000e+4*00+0],AX
   mov BX,0008
   mov DX,CS
   mov AX,offset A216e1052
   call near B216e0905
   mov BX,0009
   call near B216e091a
   mov [offset Y216e000e+4*01+2],DX
   mov [offset Y216e000e+4*01+0],AX
   mov BX,0009
   mov DX,CS
   mov AX,offset A216e10da
   call near B216e0905
ret near

B216e146c:
   mov BX,0008
   mov DX,[offset Y216e000e+4*00+2]
   mov AX,[offset Y216e000e+4*00+0]
   call near B216e0905
   mov BX,0009
   mov DX,[offset Y216e000e+4*01+2]
   mov AX,[offset Y216e000e+4*01+0]
   call near B216e0905
ret near

B216e1487:
   call near B216e1398
   call near B216e1355
   jb L216e149a
   call near B216e140d
   call near B216e143b
   mov AX,0001
jmp near L216e149c
L216e149a:
   sub AX,AX
L216e149c:
ret near

B216e149d:
   call near B216e1198
   call near B216e146c
   sub AX,AX
ret near

B216e14a6:
   mov [offset Y216e0009],AX
   sub AX,AX
ret near

;; === Compiler Library Modules ===
Segment 22b8 ;; IOERROR
__IOERROR: ;; 22b8000c
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   or SI,SI
   jl L22b8002b
   cmp SI,+58
   jbe L22b8001f
L22b8001c:
   mov SI,0057
L22b8001f:
   mov [offset __doserrno],SI
   mov AL,[SI+offset __dosErrorToSV]
   cbw
   xchg SI,AX
jmp near L22b80038
L22b8002b:
   neg SI
   cmp SI,+23
   ja L22b8001c
   mov word ptr [offset __doserrno],FFFF
L22b80038:
   mov AX,SI
   mov [offset _errno],AX
   mov AX,FFFF
jmp near L22b80042
L22b80042:
   pop SI
   pop BP
ret far 0002

Segment 22bc ;; EXIT
A22bc0007:
ret far

_exit: ;; 22bc0008
   push BP
   mov BP,SP
jmp near L22bc0019
L22bc000d:
   mov BX,[offset __atexitcnt]
   shl BX,1
   shl BX,1
   call far [BX+offset __atexittbl]
L22bc0019:
   mov AX,[offset __atexitcnt]
   dec word ptr [offset __atexitcnt]
   or AX,AX
   jnz L22bc000d
   call far [offset __exitbuf]
   call far [offset __exitfopen]
   call far [offset __exitopen]
   push [BP+06]
   call far __exit
   pop CX
   pop BP
ret far

Segment 22bf ;; SETARGV, SETENVP, ATEXIT
_atexit: ;; 22bf000b ;; (@) Unaccessed.
   push BP
   mov BP,SP
   cmp word ptr [offset __atexitcnt],+20
   jnz L22bf001a
   mov AX,0001
jmp near L22bf0038
L22bf001a:
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov BX,[offset __atexitcnt]
   shl BX,1
   shl BX,1
   mov [BX+offset __atexittbl+2],DX
   mov [BX+offset __atexittbl+0],AX
   inc word ptr [offset __atexitcnt]
   xor AX,AX
jmp near L22bf0038
L22bf0038:
   pop BP
ret far

Segment 22c2 ;; FMALLOC
_malloc: ;; 22c2000a
   push BP
   mov BP,SP
   mov AX,[BP+06]
   xor DX,DX
   push DX
   push AX
   call far _farmalloc
   mov SP,BP
jmp near L22c2001d
L22c2001d:
   pop BP
ret far

__pull_free_block: ;; 22c2001f
   push BP
   mov BP,SP
   sub SP,+04
   les BX,[BP+06]
   mov DX,[ES:BX+0E]
   mov AX,[ES:BX+0C]
   mov [offset __rover+2],DX
   mov [offset __rover+0],AX
   mov CX,[BP+08]
   mov BX,[BP+06]
   call far PCMP@
   jnz L22c20052
   mov word ptr [offset __rover+2],0000
   mov word ptr [offset __rover+0],0000
jmp near L22c20083
L22c20052:
   les BX,[BP+06]
   les BX,[ES:BX+08]
   mov [BP-02],ES
   mov [BP-04],BX
   mov DX,[BP-02]
   mov AX,[BP-04]
   les BX,[offset __rover+0]
   mov [ES:BX+0A],DX
   mov [ES:BX+08],AX
   mov DX,[offset __rover+2]
   mov AX,[offset __rover+0]
   les BX,[BP-04]
   mov [ES:BX+0E],DX
   mov [ES:BX+0C],AX
L22c20083:
   mov SP,BP
   pop BP
ret far

A22c20087:
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
   mov DX,[offset __last+2]
   mov AX,[offset __last+0]
   call far PCMP@
   jnz L22c20100
   les BX,[BP-04]
   mov [offset __last+2],ES
   mov [offset __last+0],BX
jmp near L22c20128
L22c20100:
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
L22c20128:
   mov DX,[BP-02]
   mov AX,[BP-04]
   add AX,0008
jmp near L22c20133
L22c20133:
   mov SP,BP
   pop BP
ret far

A22c20137:
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
   jnz L22c20162
   cmp word ptr [BP-04],-01
   jnz L22c20162
   xor DX,DX
   xor AX,AX
jmp near L22c201a1
L22c20162:
   mov DX,[offset __last+2]
   mov AX,[offset __last+0]
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
   mov [offset __last+2],ES
   mov [offset __last+0],BX
   mov DX,[offset __last+2]
   mov AX,[offset __last+0]
   add AX,0008
jmp near L22c201a1
L22c201a1:
   mov SP,BP
   pop BP
ret far

A22c201a5:
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
   jnz L22c201d0
   cmp word ptr [BP-04],-01
   jnz L22c201d0
   xor DX,DX
   xor AX,AX
jmp near L22c20207
L22c201d0:
   les BX,[BP-04]
   mov [offset __first+2],ES
   mov [offset __first+0],BX
   les BX,[BP-04]
   mov [offset __last+2],ES
   mov [offset __last+0],BX
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
jmp near L22c20207
L22c20207:
   mov SP,BP
   pop BP
ret far

_farmalloc: ;; 22c2020b
   push BP
   mov BP,SP
   sub SP,+04
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L22c20220
   xor DX,DX
   xor AX,AX
jmp near L22c20316
L22c20220:
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
   mov DX,[offset __first+2]
   mov AX,[offset __first+0]
   call far PCMP@
   jnz L22c2025a
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A22c201a5
   pop CX
   pop CX
jmp near L22c20316
L22c2025a:
   mov DX,[offset __rover+2]
   mov AX,[offset __rover+0]
   mov [BP-02],DX
   mov [BP-04],AX
   xor CX,CX
   xor BX,BX
   call far PCMP@
   jnz L22c20275
jmp near L22c20308
L22c20275:
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   mov CX,[BP+08]
   mov BX,[BP+06]
   add BX,+30
   adc CX,+00
   cmp DX,CX
   jb L22c202aa
   jnz L22c20295
   cmp AX,BX
   jb L22c202aa
L22c20295:
   push [BP+08]
   push [BP+06]
   push [BP-02]
   push [BP-04]
   push CS
   call near offset A22c20087
   add SP,+08
jmp near L22c20316
L22c202aa:
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   cmp DX,[BP+08]
   jb L22c202e3
   jnz L22c202c0
   cmp AX,[BP+06]
   jb L22c202e3
L22c202c0:
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
jmp near L22c20316
L22c202e3:
   les BX,[BP-04]
   les BX,[ES:BX+0C]
   mov [BP-02],ES
   mov [BP-04],BX
   mov CX,[offset __rover+2]
   mov BX,[offset __rover+0]
   mov DX,[BP-02]
   mov AX,[BP-04]
   call far PCMP@
   jz L22c20308
jmp near L22c20275
L22c20308:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A22c20137
   pop CX
   pop CX
jmp near L22c20316
L22c20316:
   mov SP,BP
   pop BP
ret far

Segment 22f3 ;; FBRK, PADD, PCMP
B22f3000a:
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
   cmp SI,[offset Y24dc26c2]
   jnz L22f30038
   les BX,[BP+04]
   mov [offset __brklvl+02],ES
   mov [offset __brklvl],BX
   mov AX,0001
jmp near L22f30094
L22f30038:
   mov CL,06
   shl SI,CL
   mov DI,[offset __heaptop+02]
   mov AX,SI
   add AX,[offset __psp]
   cmp AX,DI
   jbe L22f30050
   mov SI,DI
   sub SI,[offset __psp]
L22f30050:
   push SI
   push [offset __psp]
   call far _setblock
   pop CX
   pop CX
   mov DI,AX
   cmp DI,-01
   jnz L22f3007e
   mov AX,SI
   mov CL,06
   shr AX,CL
   mov [offset Y24dc26c2],AX
   les BX,[BP+04]
   mov [offset __brklvl+02],ES
   mov [offset __brklvl],BX
   mov AX,0001
jmp near L22f30094

X22f3007c:
jmp near L22f30094
L22f3007e:
   mov AX,[offset __psp]
   add AX,DI
   xor DX,DX
   mov DX,AX
   xor AX,AX
   mov [offset __heaptop+02],DX
   mov [offset __heaptop],AX
   xor AX,AX
jmp near L22f30094
L22f30094:
   pop DI
   pop SI
   pop BP
ret near 0004

__brk: ;; 22f3009a
   push BP
   mov BP,SP
   mov CX,[offset __heapbase+02]
   mov BX,[offset __heapbase]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far PCMP@
   jb L22f300d4
   mov CX,[offset __heaptop+02]
   mov BX,[offset __heaptop]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far PCMP@
   ja L22f300d4
   push [BP+08]
   push [BP+06]
   call near B22f3000a
   or AX,AX
   jnz L22f300db
L22f300d4:
   mov AX,FFFF
jmp near L22f300df

X22f300d9:
jmp near L22f300df
L22f300db:
   xor AX,AX
jmp near L22f300df
L22f300df:
   pop BP
ret far

__sbrk: ;; 22f300e1
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
   jb L22f30129
   mov CX,[offset __heaptop+02]
   mov BX,[offset __heaptop]
   mov DX,[BP-06]
   mov AX,[BP-08]
   call far PCMP@
   jbe L22f30131
L22f30129:
   mov DX,FFFF
   mov AX,FFFF
jmp near L22f30158
L22f30131:
   les BX,[offset __brklvl]
   mov [BP-02],ES
   mov [BP-04],BX
   push [BP-06]
   push [BP-08]
   call near B22f3000a
   or AX,AX
   jnz L22f30150
   mov DX,FFFF
   mov AX,FFFF
jmp near L22f30158
L22f30150:
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L22f30158
L22f30158:
   mov SP,BP
   pop BP
ret far

Segment 2308 ;; SETBLOCK, CTYPE
_setblock: ;; 2308000c
   push BP
   mov BP,SP
   mov AH,4A
   mov BX,[BP+08]
   mov ES,[BP+06]
   int 21
   jb L23080020
   mov AX,FFFF
jmp near L2308002a
L23080020:
   push BX
   push AX
   call far __IOERROR
   pop AX
jmp near L2308002a
L2308002a:
   pop BP
ret far

Segment 230a ;; OPEN
B230a000c:
   push BP
   mov BP,SP
   push DS
   mov CX,[BP+04]
   mov AH,3C
   lds DX,[BP+06]
   int 21
   pop DS
   jb L230a001f
jmp near L230a0027
L230a001f:
   push AX
   call far __IOERROR
jmp near L230a0027
L230a0027:
   pop BP
ret near 0006

B230a002b:
   push BP
   mov BP,SP
   mov BX,[BP+04]
   sub CX,CX
   sub DX,DX
   mov AH,40
   int 21
jmp near L230a003b
L230a003b:
   pop BP
ret near 0002

_open: ;; 230a003f
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov DI,[BP+0A]
   test DI,C000
   jnz L230a0058
   mov AX,[offset __fmode]
   and AX,C000
   or DI,AX
L230a0058:
   test DI,0100
   jnz L230a0061
jmp near L230a0100
L230a0061:
   mov AX,[offset __notUmask]
   and [BP+0C],AX
   mov AX,[BP+0C]
   test AX,0180
   jnz L230a0078
   mov AX,0001
   push AX
   call far __IOERROR
L230a0078:
   xor AX,AX
   push AX
   push [BP+08]
   push [BP+06]
   call far __chmod
   add SP,+06
   mov [BP-04],AX
   cmp AX,FFFF
   jnz L230a00a4
   test word ptr [BP+0C],0080
   jz L230a009c
   xor AX,AX
jmp near L230a009f
L230a009c:
   mov AX,0001
L230a009f:
   mov [BP-04],AX
jmp near L230a00ba
L230a00a4:
   test DI,0400
   jz L230a00b8
   mov AX,0050
   push AX
   call far __IOERROR
jmp near L230a01a6
X230a00b6:
jmp near L230a00ba
L230a00b8:
jmp near L230a0100
L230a00ba:
   test DI,00F0
   jz L230a00e4
   push [BP+08]
   push [BP+06]
   xor AX,AX
   push AX
   call near B230a000c
   mov SI,AX
   mov AX,SI
   or AX,AX
   jge L230a00d9
   mov AX,SI
jmp near L230a01a6
L230a00d9:
   push SI
   call far __close
   pop CX
jmp near L230a0105
X230a00e2:
jmp near L230a00fd
L230a00e4:
   push [BP+08]
   push [BP+06]
   push [BP-04]
   call near B230a000c
   mov SI,AX
   mov AX,SI
   or AX,AX
   jge L230a00fd
   mov AX,SI
jmp near L230a01a6
L230a00fd:
jmp near L230a0181
L230a0100:
   mov word ptr [BP-04],0000
L230a0105:
   push DI
   push [BP+08]
   push [BP+06]
   call far __open
   add SP,+06
   mov SI,AX
   mov AX,SI
   or AX,AX
   jl L230a0181
   xor AX,AX
   push AX
   push SI
   call far _ioctl
   pop CX
   pop CX
   mov [BP-02],AX
   test AX,0080
   jz L230a0155
   or DI,2000
   test DI,8000
   jz L230a0153
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
L230a0153:
jmp near L230a015f
L230a0155:
   test DI,0200
   jz L230a015f
   push SI
   call near B230a002b
L230a015f:
   cmp word ptr [BP-04],+00
   jz L230a0181
   test DI,00F0
   jz L230a0181
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   push [BP+08]
   push [BP+06]
   call far __chmod
   add SP,+08
L230a0181:
   or SI,SI
   jl L230a01a2
   test DI,0300
   jz L230a0190
   mov AX,1000
jmp near L230a0192
L230a0190:
   xor AX,AX
L230a0192:
   mov DX,DI
   and DX,F8FF
   or AX,DX
   mov BX,SI
   shl BX,1
   mov [BX+offset __openfd],AX
L230a01a2:
   mov AX,SI
jmp near L230a01a6
L230a01a6:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 2324 ;; OPENA
__open: ;; 2324000c
   push BP
   mov BP,SP
   push SI
   mov AL,01
   mov CX,[BP+0A]
   test CX,0002
   jnz L23240025
   mov AL,02
   test CX,0004
   jnz L23240025
   mov AL,00
L23240025:
   push DS
   lds DX,[BP+06]
   mov CL,F0
   and CL,[BP+0A]
   or AL,CL
   mov AH,3D
   int 21
   pop DS
   jb L2324004e
   mov SI,AX
   mov AX,[BP+0A]
   and AX,F8FF
   or AX,8000
   mov BX,SI
   shl BX,1
   mov [BX+offset __openfd],AX
   mov AX,SI
jmp near L23240056
L2324004e:
   push AX
   call far __IOERROR
jmp near L23240056
L23240056:
   pop SI
   pop BP
ret far

Segment 2329 ;; FILES2, FMODE, IOCTL
_ioctl: ;; 23290009
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
   jb L2329002c
   cmp word ptr [BP+08],+00
   jnz L2329002a
   mov AX,DX
jmp near L23290034
L2329002a:
jmp near L23290034
L2329002c:
   push AX
   call far __IOERROR
jmp near L23290034
L23290034:
   pop BP
ret far

Segment 232c ;; CLOSE
_close: ;; 232c0006
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   or SI,SI
   jl L232c0016
   cmp SI,+14
   jl L232c0021
L232c0016:
   mov AX,0006
   push AX
   call far __IOERROR
jmp near L232c0034
L232c0021:
   mov BX,SI
   shl BX,1
   mov word ptr [BX+offset __openfd],FFFF
   push SI
   call far __close
   pop CX
jmp near L232c0034
L232c0034:
   pop SI
   pop BP
ret far

Segment 232f ;; CLOSEA
__close: ;; 232f0007 ;; 21:00
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AH,3E
   mov BX,SI
   int 21
   jb L232f0022
   shl BX,1
   mov word ptr [BX+offset __openfd],FFFF
   xor AX,AX
jmp near L232f002a
L232f0022:
   push AX
   call far __IOERROR
jmp near L232f002a
L232f002a:
   pop SI
   pop BP
ret far

Segment 2331 ;; READ
_read: ;; 2331000d
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov AX,[BP+0C]
   inc AX
   cmp AX,0002
   jb L2331002b
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+offset __openfd],0200
   jz L23310030
L2331002b:
   xor AX,AX
jmp near L233100cc
L23310030:
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
   jb L2331005d
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+offset __openfd],8000
   jz L23310063
L2331005d:
   mov AX,[BP-04]
jmp near L233100cc

X23310062:
   nop
L23310063:
   mov CX,[BP-04]
   les SI,[BP+08]
   mov DI,SI
   mov BX,SI
   cld
L2331006e:
   ES:lodsb
   cmp AL,1A
   jz L233100a4
   cmp AL,0D
   jz L2331007d
   stosb
   loop L2331006e
jmp near L2331009c
L2331007d:
   loop L2331006e
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
L2331009c:
   cmp DI,BX
   jnz L233100a2
jmp near L23310030
L233100a2:
jmp near L233100c6
L233100a4:
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
L233100c6:
   mov AX,DI
   sub AX,BX
jmp near L233100cc
L233100cc:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 233e ;; READA
__read: ;; 233e0002
   push BP
   mov BP,SP
   push DS
   mov AH,3F
   mov BX,[BP+06]
   mov CX,[BP+0C]
   lds DX,[BP+08]
   int 21
   pop DS
   jb L233e0018
jmp near L233e0020
L233e0018:
   push AX
   call far __IOERROR
jmp near L233e0020
L233e0020:
   pop BP
ret far

Segment 2340 ;; WRITE
_write: ;; 23400002 ;; 22:00
   push BP
   mov BP,SP
   sub SP,008E
   push SI
   push DI
   mov AX,[BP+0C]
   inc AX
   cmp AX,0002
   jnb L23400019
   xor AX,AX
jmp near L23400162
L23400019:
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+offset __openfd],8000
   jz L2340003d
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far __write
   add SP,+08
jmp near L23400162
L2340003d:
   mov BX,[BP+06]
   shl BX,1
   and word ptr [BX+offset __openfd],FDFF
   les BX,[BP+08]
   mov [BP+FF7C],ES
   mov [BP+FF7A],BX
   mov AX,[BP+0C]
   mov [BP+FF76],AX
   mov BX,SS
   mov ES,BX
   lea BX,[BP+FF7E]
   mov [BP+FF74],ES
   mov [BP+FF72],BX
jmp near L2340010e
L2340006d:
   dec word ptr [BP+FF76]
   les BX,[BP+FF7A]
   inc word ptr [BP+FF7A]
   mov AL,[ES:BX]
   mov [BP+FF79],AL
   cmp AL,0A
   jnz L23400090
   les BX,[BP+FF72]
   mov byte ptr [ES:BX],0D
   inc word ptr [BP+FF72]
L23400090:
   mov AL,[BP+FF79]
   les BX,[BP+FF72]
   mov [ES:BX],AL
   inc word ptr [BP+FF72]
   mov AX,[BP+FF72]
   mov CX,SS
   lea BX,[BP+FF7E]
   xor DX,DX
   sub AX,BX
   sbb DX,+00
   or DX,DX
   jl L2340010e
   jnz L234000bb
   cmp AX,0080
   jb L2340010e
L234000bb:
   mov AX,[BP+FF72]
   mov CX,SS
   lea BX,[BP+FF7E]
   xor DX,DX
   sub AX,BX
   sbb DX,+00
   mov SI,AX
   push SI
   push SS
   lea AX,[BP+FF7E]
   push AX
   push [BP+06]
   call far __write
   add SP,+08
   mov DI,AX
   mov AX,DI
   cmp AX,SI
   jz L234000fe
   or DI,DI
   jnb L234000f1
   mov AX,FFFF
jmp near L234000fc
L234000f1:
   mov AX,[BP+0C]
   sub AX,[BP+FF76]
   add AX,DI
   sub AX,SI
L234000fc:
jmp near L23400162
L234000fe:
   mov BX,SS
   mov ES,BX
   lea BX,[BP+FF7E]
   mov [BP+FF74],ES
   mov [BP+FF72],BX
L2340010e:
   cmp word ptr [BP+FF76],+00
   jz L23400118
jmp near L2340006d
L23400118:
   mov AX,[BP+FF72]
   mov CX,SS
   lea BX,[BP+FF7E]
   xor DX,DX
   sub AX,BX
   sbb DX,+00
   mov SI,AX
   mov AX,SI
   or AX,AX
   jbe L2340015d
   push SI
   push SS
   lea AX,[BP+FF7E]
   push AX
   push [BP+06]
   call far __write
   add SP,+08
   mov DI,AX
   mov AX,DI
   cmp AX,SI
   jz L2340015d
   or DI,DI
   jnb L23400154
   mov AX,FFFF
jmp near L2340015b
L23400154:
   mov AX,[BP+0C]
   add AX,DI
   sub AX,SI
L2340015b:
jmp near L23400162
L2340015d:
   mov AX,[BP+0C]
jmp near L23400162
L23400162:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 2356 ;; WRITEA
__write: ;; 23560008
   push BP
   mov BP,SP
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+offset __openfd],0800
   jz L2356002a
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push [BP+06]
   call far _lseek
   mov SP,BP
L2356002a:
   push DS
   mov AH,40
   mov BX,[BP+06]
   mov CX,[BP+0C]
   lds DX,[BP+08]
   int 21
   pop DS
   jb L2356004a
   push AX
   mov BX,[BP+06]
   shl BX,1
   or word ptr [BX+offset __openfd],1000
   pop AX
jmp near L23560052
L2356004a:
   push AX
   call far __IOERROR
jmp near L23560052
L23560052:
   pop BP
ret far

Segment 235b ;; LSEEK
_lseek: ;; 235b0004
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
   jb L235b0026
jmp near L235b002f
L235b0026:
   push AX
   call far __IOERROR
   cwd
jmp near L235b002f
L235b002f:
   pop BP
ret far

Segment 235e ;; LTOA, LXMUL
__LONGTOA: ;; 235e0001
   push BP
   mov BP,SP
   sub SP,+22
   push SI
   push DI
   push ES
   les DI,[BP+0C]
   mov BX,[BP+0A]
   cmp BX,+24
   ja L235e0071
   cmp BL,02
   jb L235e0071
   mov AX,[BP+10]
   mov CX,[BP+12]
   or CX,CX
   jge L235e0036
   cmp byte ptr [BP+08],00
   jz L235e0036
   mov byte ptr [ES:DI],2D
   inc DI
   neg CX
   neg AX
   sbb CX,+00
L235e0036:
   lea SI,[BP-22]
   jcxz L235e004b
L235e003b:
   xchg CX,AX
   sub DX,DX
   div BX
   xchg CX,AX
   div BX
   mov [SS:SI],DL
   inc SI
   jcxz L235e0053
jmp near L235e003b
L235e004b:
   sub DX,DX
   div BX
   mov [SS:SI],DL
   inc SI
L235e0053:
   or AX,AX
   jnz L235e004b
   lea CX,[BP-22]
   neg CX
   add CX,SI
   cld
L235e005f:
   dec SI
   mov AL,[SS:SI]
   sub AL,0A
   jnb L235e006b
   add AL,3A
jmp near L235e006e
L235e006b:
   add AL,[BP+06]
L235e006e:
   stosb
   loop L235e005f
L235e0071:
   mov AL,00
   stosb
   pop ES
   mov DX,[BP+0E]
   mov AX,[BP+0C]
jmp near L235e007d
L235e007d:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far 000E

_itoa: ;; 235e0085 ;; 23:00
   push BP
   mov BP,SP
   cmp word ptr [BP+0C],+0A
   jnz L235e0094
   mov AX,[BP+06]
   cwd
jmp near L235e0099
L235e0094:
   mov AX,[BP+06]
   xor DX,DX
L235e0099:
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
jmp near L235e00b0
L235e00b0:
   pop BP
ret far

_ultoa: ;; 235e00b2 ;; (@) Unaccessed.
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
jmp near L235e00d0
L235e00d0:
   pop BP
ret far

_ltoa: ;; 235e00d2
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0C]
   push [BP+0A]
   push [BP+0E]
   cmp word ptr [BP+0E],+0A
   jnz L235e00ef
   mov AX,0001
jmp near L235e00f1
L235e00ef:
   xor AX,AX
L235e00f1:
   push AX
   mov AL,61
   push AX
   push CS
   call near offset __LONGTOA
jmp near L235e00fb
L235e00fb:
   pop BP
ret far

Segment 236d ;; UNLINK
_unlink: ;; 236d000d
   push BP
   mov BP,SP
   push DS
   mov AH,41
   lds DX,[BP+06]
   int 21
   pop DS
   jb L236d001f
   xor AX,AX
jmp near L236d0027
L236d001f:
   push AX
   call far __IOERROR
jmp near L236d0027
L236d0027:
   pop BP
ret far

Segment 236f ;; STRCAT
_strcat: ;; 236f0009 ;; 1d:00
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
   jz L236f0039
   movsb
   dec CX
L236f0039:
   shr CX,1
   repz movsw
   jnb L236f0040
   movsb
L236f0040:
   mov AX,DX
   mov DX,ES
   pop DS
jmp near L236f0047
L236f0047:
   pop DI
   pop SI
   pop BP
ret far

Segment 2373 ;; STRLEN
_strlen: ;; 2373000b ;; 1f:00
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
jmp near L23730022
L23730022:
   pop DI
   pop SI
   pop BP
ret far

Segment 2375 ;; STRCMP
_strcmp: ;; 23750006
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
jmp near L23750034
L23750034:
   pop DI
   pop SI
   pop BP
ret far

Segment 2378 ;; STRCPY
_strcpy: ;; 23780008 ;; 1b:00
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
jmp near L2378002d
L2378002d:
   pop DI
   pop SI
   pop BP
ret far

Segment 237b ;; MEMCPY
_memcpy: ;; 237b0001
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
   jnb L237b0019
   movsb
L237b0019:
   mov DS,DX
   mov DX,[BP+08]
   mov AX,[BP+06]
jmp near L237b0023
L237b0023:
   pop DI
   pop SI
   pop BP
ret far

Segment 237d ;; MEMSET
_setmem: ;; 237d0007
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
   jz L237d0022
   jcxz L237d0029
   stosb
   dec CX
L237d0022:
   shr CX,1
   repz stosw
   jnb L237d0029
   stosb
L237d0029:
   pop DI
   pop SI
   pop BP
ret far

_memset: ;; 237d002d
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
jmp near L237d004a
L237d004a:
   pop BP
ret far

Segment 2381 ;; MOVMEM
_movmem: ;; 2381000c
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
   jnb L2381002b
   std
   mov AX,0001
jmp near L2381002e
L2381002b:
   cld
   xor AX,AX
L2381002e:
   lds SI,[BP+06]
   les DI,[BP+0A]
   mov CX,[BP+0E]
   or AX,AX
   jz L23810041
   add SI,CX
   dec SI
   add DI,CX
   dec DI
L23810041:
   test DI,0001
   jz L2381004b
   jcxz L2381005a
   movsb
   dec CX
L2381004b:
   sub SI,AX
   sub DI,AX
   shr CX,1
   repz movsw
   jnb L2381005a
   add SI,AX
   add DI,AX
   movsb
L2381005a:
   cld
   pop DS
   pop DI
   pop SI
   pop BP
ret far

_memmove: ;; 23810060
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

Segment 2389 ;; CHMODA, CVTFAK, REALCVT
__chmod: ;; 23890000
   push BP
   mov BP,SP
   push DS
   mov AH,43
   mov AL,[BP+0A]
   mov CX,[BP+0C]
   lds DX,[BP+06]
   int 21
   pop DS
   jb L23890017
   xchg CX,AX
jmp near L2389001f
L23890017:
   push AX
   call far __IOERROR
jmp near L2389001f
L2389001f:
   pop BP
ret far

Segment 238b ;; VPRINTER
B238b0001:
   push BP
   mov BP,SP
   mov DX,[BP+04]
   mov CX,0F04
   mov BX,offset Y24dc282b
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
jmp near L238b0028
L238b0028:
   pop BP
ret near 0002

__VPRINTER: ;; 238b002c
   push BP
   mov BP,SP
   sub SP,0096
   push SI
   push DI
   mov word ptr [BP-56],0000
   mov byte ptr [BP-53],50
jmp near L238b007d

B238b0040:
   push DI
   mov CX,FFFF
   xor AL,AL
   repnz scasb
   not CX
   dec CX
   pop DI
ret near

B238b004d:
   mov [SS:DI],AL
   inc DI
   dec byte ptr [BP-53]
   jle L238b007c

B238b0056:
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
L238b007c:
ret near
L238b007d:
   push ES
   cld
   lea DI,[BP-52]
   mov [BP+FF6C],DI
L238b0086:
   mov DI,[BP+FF6C]
L238b008a:
   les SI,[BP+0A]
L238b008d:
   ES:lodsb
   or AL,AL
   jz L238b00a5
   cmp AL,25
   jz L238b00a8
L238b0097:
   mov [SS:DI],AL
   inc DI
   dec byte ptr [BP-53]
   jg L238b008d
   call near B238b0056
jmp near L238b008d
L238b00a5:
jmp near L238b053c
L238b00a8:
   mov [BP+FF78],SI
   ES:lodsb
   cmp AL,25
   jz L238b0097
   mov [BP+FF6C],DI
   xor CX,CX
   mov [BP+FF76],CX
   mov word ptr [BP+FF6A],0020
   mov [BP+FF75],CL
   mov word ptr [BP+FF70],FFFF
   mov word ptr [BP+FF72],FFFF
jmp near L238b00d6
L238b00d4:
   ES:lodsb
L238b00d6:
   xor AH,AH
   mov DX,AX
   mov BX,AX
   sub BL,20
   cmp BL,60
   jnb L238b012b
   mov BL,[BX+offset Y24dc283b]
   mov AX,BX
   cmp AX,0017
   jbe L238b00f2
jmp near L238b0526
L238b00f2:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y238b00fb]

Y238b00fb:	dw L238b0146,L238b012e,L238b0187,L238b013a,L238b01af,L238b01b9,L238b01fb,L238b0205
		dw L238b0215,L238b016d,L238b024b,L238b0225,L238b0229,L238b022d,L238b02d5,L238b038e
		dw L238b032b,L238b034d,L238b04f7,L238b0526,L238b0526,L238b0526,L238b0159,L238b0163

L238b012b:
jmp near L238b0526
L238b012e:
   cmp CH,00
   ja L238b012b
   or word ptr [BP+FF6A],+01
jmp near L238b00d4
L238b013a:
   cmp CH,00
   ja L238b012b
   or word ptr [BP+FF6A],+02
jmp near L238b00d4
L238b0146:
   cmp CH,00
   ja L238b012b
   cmp byte ptr [BP+FF75],2B
   jz L238b0156
   mov [BP+FF75],DL
L238b0156:
jmp near L238b00d4
L238b0159:
   and word ptr [BP+FF6A],-21
   mov CH,05
jmp near L238b00d4
L238b0163:
   or word ptr [BP+FF6A],+20
   mov CH,05
jmp near L238b00d4
L238b016d:
   cmp CH,00
   ja L238b01b9
   test word ptr [BP+FF6A],0002
   jnz L238b019e
   or word ptr [BP+FF6A],+08
   mov CH,01
jmp near L238b00d4
L238b0184:
jmp near L238b0526
L238b0187:
   push ES
   les DI,[BP+06]
   mov AX,[ES:DI]
   add word ptr [BP+06],+02
   pop ES
   cmp CH,02
   jnb L238b01a1
   mov [BP+FF70],AX
   mov CH,03
L238b019e:
jmp near L238b00d4
L238b01a1:
   cmp CH,04
   jnz L238b0184
   mov [BP+FF72],AX
   inc CH
jmp near L238b00d4
L238b01af:
   cmp CH,04
   jnb L238b0184
   mov CH,04
jmp near L238b00d4
L238b01b9:
   xchg DX,AX
   sub AL,30
   cbw
   cmp CH,02
   ja L238b01dd
   mov CH,02
   xchg AX,[BP+FF70]
   or AX,AX
   jl L238b019e
   shl AX,1
   mov DX,AX
   shl AX,1
   shl AX,1
   add AX,DX
   add [BP+FF70],AX
jmp near L238b00d4
L238b01dd:
   cmp CH,04
   jnz L238b0184
   xchg AX,[BP+FF72]
   or AX,AX
   jl L238b019e
   shl AX,1
   mov DX,AX
   shl AX,1
   shl AX,1
   add AX,DX
   add [BP+FF72],AX
jmp near L238b00d4
L238b01fb:
   or word ptr [BP+FF6A],+10
   mov CH,05
jmp near L238b00d4
L238b0205:
   or word ptr [BP+FF6A],0100
   and word ptr [BP+FF6A],-11
   mov CH,05
jmp near L238b00d4
L238b0215:
   and word ptr [BP+FF6A],-11
   or word ptr [BP+FF6A],0080
   mov CH,05
jmp near L238b00d4
L238b0225:
   mov BH,08
jmp near L238b0233
L238b0229:
   mov BH,0A
jmp near L238b0238
L238b022d:
   mov BH,10
   mov BL,E9
   add BL,DL
L238b0233:
   mov byte ptr [BP+FF75],00
L238b0238:
   mov byte ptr [BP+FF6F],00
   mov [BP+FF6E],DL
   les DI,[BP+06]
   mov AX,[ES:DI]
   xor DX,DX
jmp near L238b025d
L238b024b:
   mov BH,0A
   mov byte ptr [BP+FF6F],01
   mov [BP+FF6E],DL
   les DI,[BP+06]
   mov AX,[ES:DI]
   cwd
L238b025d:
   inc DI
   inc DI
   mov [BP+0A],SI
   test word ptr [BP+FF6A],0010
   jz L238b026f
   mov DX,[ES:DI]
   inc DI
   inc DI
L238b026f:
   mov [BP+06],DI
   lea DI,[BP+FF7B]
   or AX,AX
   jnz L238b02ad
   or DX,DX
   jnz L238b02ad
   cmp word ptr [BP+FF72],+00
   jnz L238b02b2
   mov DI,[BP+FF6C]
   mov CX,[BP+FF70]
   jcxz L238b02aa
   cmp CX,-01
   jz L238b02aa
   mov AX,[BP+FF6A]
   and AX,0008
   jz L238b02a1
   mov DL,30
jmp near L238b02a3
L238b02a1:
   mov DL,20
L238b02a3:
   mov AL,DL
   call near B238b004d
   loop L238b02a3
L238b02aa:
jmp near L238b008a
L238b02ad:
   or word ptr [BP+FF6A],+04
L238b02b2:
   push DX
   push AX
   push SS
   push DI
   mov AL,BH
   cbw
   push AX
   mov AL,[BP+FF6F]
   push AX
   push BX
   call far __LONGTOA
   push SS
   pop ES
   mov DX,[BP+FF72]
   or DX,DX
   jg L238b02d2
jmp near L238b03f1
L238b02d2:
jmp near L238b0401
L238b02d5:
   mov [BP+FF6E],DL
   mov [BP+0A],SI
   lea DI,[BP+FF7A]
   les BX,[BP+06]
   push [ES:BX]
   inc BX
   inc BX
   mov [BP+06],BX
   test word ptr [BP+FF6A],0020
   jz L238b0303
   push [ES:BX]
   inc BX
   inc BX
   mov [BP+06],BX
   push SS
   pop ES
   call near B238b0001
   mov AL,3A
   stosb
L238b0303:
   push SS
   pop ES
   call near B238b0001
   mov byte ptr [SS:DI],00
   mov byte ptr [BP+FF6F],00
   and word ptr [BP+FF6A],-05
   lea CX,[BP+FF7A]
   sub DI,CX
   xchg CX,DI
   mov DX,[BP+FF72]
   cmp DX,CX
   jg L238b0328
   mov DX,CX
L238b0328:
jmp near L238b03f1
L238b032b:
   mov [BP+0A],SI
   mov [BP+FF6E],DL
   les DI,[BP+06]
   mov AX,[ES:DI]
   add word ptr [BP+06],+02
   push SS
   pop ES
   lea DI,[BP+FF7B]
   xor AH,AH
   mov [ES:DI],AX
   mov CX,0001
jmp near L238b042b
L238b034d:
   mov [BP+0A],SI
   mov [BP+FF6E],DL
   les DI,[BP+06]
   test word ptr [BP+FF6A],0020
   jnz L238b036c
   mov DI,[ES:DI]
   add word ptr [BP+06],+02
   push DS
   pop ES
   or DI,DI
jmp near L238b0377
L238b036c:
   les DI,[ES:DI]
   add word ptr [BP+06],+04
   mov AX,ES
   or AX,DI
L238b0377:
   jnz L238b037e
   push DS
   pop ES
   mov DI,offset Y24dc2824
L238b037e:
   call near B238b0040
   cmp CX,[BP+FF72]
   jbe L238b038b
   mov CX,[BP+FF72]
L238b038b:
jmp near L238b042b
L238b038e:
   mov [BP+0A],SI
   mov [BP+FF6E],DL
   les DI,[BP+06]
   mov CX,[BP+FF72]
   or CX,CX
   jge L238b03a3
   mov CX,0006
L238b03a3:
   push ES
   push DI
   push CX
   push SS
   lea BX,[BP+FF7B]
   push BX
   push DX
   mov AX,0001
   and AX,[BP+FF6A]
   push AX
   mov AX,[BP+FF6A]
   test AX,0080
   jz L238b03c8
   mov AX,0002
   mov word ptr [BP-02],0004
jmp near L238b03df
L238b03c8:
   test AX,0100
   jz L238b03d7
   mov AX,0008
   mov word ptr [BP-02],000A
jmp near L238b03df
L238b03d7:
   mov word ptr [BP-02],0008
   mov AX,0006
L238b03df:
   push AX
   call far __REALCVT
   mov AX,[BP-02]
   add [BP+06],AX
   push SS
   pop ES
   lea DI,[BP+FF7B]
L238b03f1:
   test word ptr [BP+FF6A],0008
   jz L238b040c
   mov DX,[BP+FF70]
   or DX,DX
   jle L238b040c
L238b0401:
   call near B238b0040
   sub DX,CX
   jle L238b040c
   mov [BP+FF76],DX
L238b040c:
   mov AL,[BP+FF75]
   or AL,AL
   jz L238b0428
   cmp byte ptr [ES:DI],2D
   jz L238b0428
   sub word ptr [BP+FF76],+01
   adc word ptr [BP+FF76],+00
   dec DI
   mov [ES:DI],AL
L238b0428:
   call near B238b0040
L238b042b:
   mov SI,DI
   mov DI,[BP+FF6C]
   mov BX,[BP+FF70]
   mov AX,0005
   and AX,[BP+FF6A]
   cmp AX,0005
   jnz L238b0457
   mov AH,[BP+FF6E]
   cmp AH,6F
   jnz L238b045a
   cmp word ptr [BP+FF76],+00
   jg L238b0457
   mov word ptr [BP+FF76],0001
L238b0457:
jmp near L238b0478

X238b0459:
   nop
L238b045a:
   cmp AH,78
   jz L238b0464
   cmp AH,58
   jnz L238b0478
L238b0464:
   or word ptr [BP+FF6A],+40
   dec BX
   dec BX
   sub word ptr [BP+FF76],+02
   jge L238b0478
   mov word ptr [BP+FF76],0000
L238b0478:
   add CX,[BP+FF76]
   test word ptr [BP+FF6A],0002
   jnz L238b0490
jmp near L238b048c
L238b0486:
   mov AL,20
   call near B238b004d
   dec BX
L238b048c:
   cmp BX,CX
   jg L238b0486
L238b0490:
   test word ptr [BP+FF6A],0040
   jz L238b04a4
   mov AL,30
   call near B238b004d
   mov AL,[BP+FF6E]
   call near B238b004d
L238b04a4:
   mov DX,[BP+FF76]
   or DX,DX
   jle L238b04d3
   sub CX,DX
   sub BX,DX
   mov AL,[ES:SI]
   cmp AL,2D
   jz L238b04bf
   cmp AL,20
   jz L238b04bf
   cmp AL,2B
   jnz L238b04c6
L238b04bf:
   ES:lodsb
   call near B238b004d
   dec CX
   dec BX
L238b04c6:
   xchg CX,DX
   jcxz L238b04d1
L238b04ca:
   mov AL,30
   call near B238b004d
   loop L238b04ca
L238b04d1:
   xchg CX,DX
L238b04d3:
   jcxz L238b04e7
   sub BX,CX
L238b04d7:
   ES:lodsb
   mov [SS:DI],AL
   inc DI
   dec byte ptr [BP-53]
   jg L238b04e5
   call near B238b0056
L238b04e5:
   loop L238b04d7
L238b04e7:
   or BX,BX
   jle L238b04f4
   mov CX,BX
L238b04ed:
   mov AL,20
   call near B238b004d
   loop L238b04ed
L238b04f4:
jmp near L238b008a
L238b04f7:
   mov [BP+0A],SI
   les DI,[BP+06]
   test word ptr [BP+FF6A],0020
   jnz L238b0510
   mov DI,[ES:DI]
   add word ptr [BP+06],+02
   push DS
   pop ES
jmp near L238b0517
L238b0510:
   les DI,[ES:DI]
   add word ptr [BP+06],+04
L238b0517:
   mov AX,0050
   sub AL,[BP-53]
   add AX,[BP-56]
   mov [ES:DI],AX
jmp near L238b0086
L238b0526:
   mov SI,[BP+FF78]
   mov ES,[BP+0C]
   mov DI,[BP+FF6C]
   mov AL,25
L238b0533:
   call near B238b004d
   ES:lodsb
   or AL,AL
   jnz L238b0533
L238b053c:
   cmp byte ptr [BP-53],50
   jge L238b0545
   call near B238b0056
L238b0545:
   pop ES
   mov AX,[BP-56]
jmp near L238b054b
L238b054b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far 0010

Segment 23e0 ;; CORELEFT, FCORELFT
_coreleft: ;; 23e00003
   call far _farcoreleft
jmp near L23e0000a
L23e0000a:
ret far

_farcoreleft: ;; 23e0000b
   mov DX,[offset __heaptop+02]
   mov AX,[offset __heaptop]
   mov CX,[offset __brklvl+02]
   mov BX,[offset __brklvl]
   call far PSBP@
   add AX,FFF8
   adc DX,-01
jmp near L23e00027
L23e00027:
ret far

Segment 23e2 ;; FFREE
_free: ;; 23e20008
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   call far _farfree
   mov SP,BP
   pop BP
ret far

A23e2001a:
   push BP
   mov BP,SP
   sub SP,+04
   xor CX,CX
   xor BX,BX
   mov DX,[offset __rover+2]
   mov AX,[offset __rover+0]
   call far PCMP@
   jz L23e20088
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
   mov DX,[offset __rover+2]
   mov AX,[offset __rover+0]
   les BX,[BP+06]
   mov [ES:BX+0A],DX
   mov [ES:BX+08],AX
jmp near L23e200b5
L23e20088:
   les BX,[BP+06]
   mov [offset __rover+2],ES
   mov [offset __rover+0],BX
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
L23e200b5:
   mov SP,BP
   pop BP
ret far

A23e200b9:
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
   mov DX,[offset __last+2]
   mov AX,[offset __last+0]
   call far PCMP@
   jnz L23e200f4
   les BX,[BP+06]
   mov [offset __last+2],ES
   mov [offset __last+0],BX
jmp near L23e20120
L23e200f4:
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
L23e20120:
   push [BP+0C]
   push [BP+0A]
   call far __pull_free_block
   pop CX
   pop CX
   mov SP,BP
   pop BP
ret far

A23e20131:
   push BP
   mov BP,SP
   sub SP,+04
   mov CX,[offset __last+2]
   mov BX,[offset __last+0]
   mov DX,[offset __first+2]
   mov AX,[offset __first+0]
   call far PCMP@
   jnz L23e20179
   push [offset __first+2]
   push [offset __first+0]
   call far __brk
   pop CX
   pop CX
   mov word ptr [offset __last+2],0000
   mov word ptr [offset __last+0],0000
   xor BX,BX
   mov ES,BX
   xor BX,BX
   mov [offset __first+2],ES
   mov [offset __first+0],BX
jmp near L23e20212
L23e20179:
   les BX,[offset __last+0]
   les BX,[ES:BX+04]
   mov [BP-02],ES
   mov [BP-04],BX
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   and AX,0001
   and DX,0000
   or DX,AX
   jnz L23e201f8
   push [BP-02]
   push [BP-04]
   call far __pull_free_block
   pop CX
   pop CX
   mov CX,[offset __first+2]
   mov BX,[offset __first+0]
   mov DX,[BP-02]
   mov AX,[BP-04]
   call far PCMP@
   jnz L23e201da
   mov word ptr [offset __last+2],0000
   mov word ptr [offset __last+0],0000
   xor BX,BX
   mov ES,BX
   xor BX,BX
   mov [offset __first+2],ES
   mov [offset __first+0],BX
jmp near L23e201e9
L23e201da:
   les BX,[BP-04]
   les BX,[ES:BX+04]
   mov [offset __last+2],ES
   mov [offset __last+0],BX
L23e201e9:
   push [BP-02]
   push [BP-04]
   call far __brk
   pop CX
   pop CX
jmp near L23e20212
L23e201f8:
   push [offset __last+2]
   push [offset __last+0]
   call far __brk
   pop CX
   pop CX
   les BX,[BP-04]
   mov [offset __last+2],ES
   mov [offset __last+0],BX
L23e20212:
   mov SP,BP
   pop BP
ret far

A23e20216:
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
   jnz L23e202aa
   mov CX,[offset __first+2]
   mov BX,[offset __first+0]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far PCMP@
   jz L23e202aa
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
jmp near L23e202b6
L23e202aa:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A23e2001a
   pop CX
   pop CX
L23e202b6:
   les BX,[BP-08]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   and AX,0001
   and DX,0000
   or DX,AX
   jnz L23e202de
   push [BP-06]
   push [BP-08]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A23e200b9
   add SP,+08
L23e202de:
   mov SP,BP
   pop BP
ret far

_farfree: ;; 23e202e2
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L23e202ef
jmp near L23e2032a
L23e202ef:
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov CX,FFFF
   mov BX,FFF8
   call far PADD@
   mov [BP+08],DX
   mov [BP+06],AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   cmp DX,[offset __last+2]
   jnz L23e2031e
   cmp AX,[offset __last+0]
   jnz L23e2031e
   push CS
   call near offset A23e20131
jmp near L23e2032a
L23e2031e:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A23e20216
   mov SP,BP
L23e2032a:
   pop BP
ret far

Segment 2414 ;; CREATA
B2414000c:
   push BP
   mov BP,SP
   push SI
   push DS
   mov AH,[BP+06]
   mov CX,[BP+08]
   lds DX,[BP+0A]
   int 21
   pop DS
   jb L24140030
   mov SI,AX
   mov AX,[BP+04]
   mov BX,SI
   shl BX,1
   mov [BX+offset __openfd],AX
   mov AX,SI
jmp near L24140038
L24140030:
   push AX
   call far __IOERROR
jmp near L24140038
L24140038:
   pop SI
   pop BP
ret near 000A

__creat: ;; 2414003d ;; 1e:00
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0A]
   mov AL,3C
   push AX
   mov AX,8004
   push AX
   call near B2414000c
jmp near L24140055
L24140055:
   pop BP
ret far

_creattemp: ;; 24140057 ;; (@) Unaccessed.
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
   call near B2414000c
jmp near L24140072
L24140072:
   pop BP
ret far

_creatnew: ;; 24140074 ;; (@) Unaccessed.
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
   call near B2414000c
jmp near L2414008f
L2414008f:
   pop BP
ret far

Segment 241d ;; FLENGTH
_filelength: ;; 241d0001
   push BP
   mov BP,SP
   sub SP,+04
   mov AX,4201
   mov BX,[BP+06]
   xor CX,CX
   xor DX,DX
   int 21
   jb L241d0039
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
   jb L241d0039
   mov AX,4200
   int 21
   jb L241d0039
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L241d0042
L241d0039:
   push AX
   call far __IOERROR
   cwd
jmp near L241d0042
L241d0042:
   mov SP,BP
   pop BP
ret far

Segment 2421 ;; CRTINIT, CLRSCR
_clrscr: ;; 24210006
   mov AL,06
   push AX
   push [offset __video+00]
   push [offset __video+01]
   push [offset __video+02]
   push [offset __video+03]
   mov AL,00
   push AX
   call far __SCROLL
   mov DL,[offset __video+00]
   mov DH,[offset __video+01]
   mov AH,02
   mov BH,00
   call far __VideoInt
ret far

Segment 2424 ;; COLOR
_textcolor: ;; 24240003
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

_textbackground: ;; 24240018
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

_textattr: ;; 24240031 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov AL,[BP+06]
   mov [offset __video+04],AL
   pop BP
ret far

_highvideo: ;; 2424003c ;; (@) Unaccessed.
   or byte ptr [offset __video+04],08
ret far

_lowvideo: ;; 24240042 ;; (@) Unaccessed.
   and byte ptr [offset __video+04],F7
ret far

_normvideo: ;; 24240048 ;; (@) Unaccessed.
   mov AL,[offset __video+05]
   mov [offset __video+04],AL
ret far

Segment 2428 ;; CPRINTF
__CPUTN: ;; 2428000f
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
jmp near L2428012d
L24280034:
   les BX,[BP+0C]
   inc word ptr [BP+0C]
   mov AL,[ES:BX]
   mov [BP-03],AL
   mov AH,00
   sub AX,0007
   cmp AX,0006
   ja L24280090
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y24280053]

Y24280053:	dw L24280061,L24280072,L24280090,L2428008b,L24280090,L24280090,L24280081

L24280061:
   mov AH,0E
   mov AL,07
   call far __VideoInt
   mov AL,[BP-03]
   mov AH,00
jmp near L24280150
L24280072:
   mov AL,[offset __video+00]
   mov AH,00
   cmp AX,[BP-08]
   jge L2428007f
   dec word ptr [BP-08]
L2428007f:
jmp near L242800f0
L24280081:
   mov AL,[offset __video+00]
   mov AH,00
   mov [BP-08],AX
jmp near L242800f0
L2428008b:
   inc word ptr [BP-06]
jmp near L242800f0
L24280090:
   cmp byte ptr [offset __video+09],00
   jnz L242800c9
   cmp word ptr [offset _directvideo],+00
   jz L242800c9
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
jmp near L242800eb
L242800c9:
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
L242800eb:
   inc word ptr [BP-08]
jmp near L242800f0
L242800f0:
   mov AL,[offset __video+02]
   mov AH,00
   cmp AX,[BP-08]
   jge L24280105
   mov AL,[offset __video+00]
   mov AH,00
   mov [BP-08],AX
   inc word ptr [BP-06]
L24280105:
   mov AL,[offset __video+03]
   mov AH,00
   cmp AX,[BP-06]
   jge L2428012d
   mov AL,06
   push AX
   push [offset __video+00]
   push [offset __video+01]
   push [offset __video+02]
   push [offset __video+03]
   mov AL,01
   push AX
   call far __SCROLL
   dec word ptr [BP-06]
L2428012d:
   mov AX,[BP+0A]
   dec word ptr [BP+0A]
   or AX,AX
   jz L2428013a
jmp near L24280034
L2428013a:
   mov DL,[BP-08]
   mov DH,[BP-06]
   mov AH,02
   mov BH,00
   call far __VideoInt
   mov AL,[BP-03]
   mov AH,00
jmp near L24280150
L24280150:
   mov SP,BP
   pop BP
ret far 000A

_cprintf: ;; 24280156 ;; (@) Unaccessed.
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
jmp near L24280174
L24280174:
   pop BP
ret far

Segment 243f ;; CPUTS
_cputs: ;; 243f0006
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
jmp near L243f0028
L243f0028:
   pop BP
ret far

Segment 2441 ;; ABS
_abs: ;; 2441000a
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,AX
   jge L24410016
   neg AX
L24410016:
jmp near L24410018
L24410018:
   pop BP
ret far

Segment 2442 ;; ATOL
_atol: ;; 2442000a
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
L24420020:
   mov BL,[ES:SI]
   inc SI
   test byte ptr [BX+DI],01
   jnz L24420020
   mov BP,0000
   cmp BL,2B
   jz L24420037
   cmp BL,2D
   jnz L2442003b
   inc BP
L24420037:
   mov BL,[ES:SI]
   inc SI
L2442003b:
   cmp BL,39
   ja L2442006f
   sub BL,30
   jb L2442006f
   mul CX
   add AX,BX
   adc DL,DH
   jz L24420037
jmp near L24420061
L2442004f:
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
L24420061:
   mov BL,[ES:SI]
   inc SI
   cmp BL,39
   ja L2442006f
   sub BL,30
   jnb L2442004f
L2442006f:
   dec BP
   jl L24420079
   neg DX
   neg AX
   sbb DX,+00
L24420079:
   pop BP
   pop ES
jmp near L2442007d
L2442007d:
   pop DI
   pop SI
   pop BP
ret far

_atoi: ;; 24420081 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push CS
   call near offset _atol
   mov SP,BP
jmp near L24420092
L24420092:
   pop BP
ret far

Y24420094:	ds 000c

Segment 244c ;; DELAY
Y244c0000:	word

_delay: ;; 244c0002
   dec SP
   dec SP
   push BP
   mov BP,SP
   push SI
   push DI
   push DS
   push ES
   mov CX,[BP+08]
   mov AX,[CS:offset Y244c0000]
   or AX,AX
   jnz L244c0039
   mov AX,0040
   mov ES,AX
   mov BX,[ES:006C]
   call near B244c005d
   sub BX,[ES:006C]
   neg BX
   mov AX,0037
   mul BX
   cmp CX,AX
   jbe L244c0051
   sub CX,AX
   mov AX,[CS:offset Y244c0000]
L244c0039:
   xor BX,BX
   mov ES,BX
   mov DL,[ES:BX]
   jcxz L244c0051
L244c0042:
   mov SI,CX
   mov CX,AX
L244c0046:
   cmp DL,[ES:BX]
   jnz L244c004b
L244c004b:
   loop L244c0046
   mov CX,SI
   loop L244c0042
L244c0051:
   mov AX,[CS:offset Y244c0000]
   pop ES
   pop DS
   pop DI
   pop SI
   pop BP
   inc SP
   inc SP
ret far

B244c005d:
   push BX
   push CX
   push DX
   push ES
   mov AX,0040
   mov ES,AX
   mov BX,006C
   mov AL,[ES:BX]
   mov CX,FFFF
L244c006f:
   mov DL,[ES:BX]
   cmp AL,DL
   jz L244c006f
L244c0076:
   cmp DL,[ES:BX]
   jnz L244c007d
   loop L244c0076
L244c007d:
   neg CX
   dec CX
   mov AX,0037
   xchg CX,AX
   xor DX,DX
   div CX
   mov [CS:offset Y244c0000],AX
L244c008c:
   mov AL,[ES:BX]
   mov CX,FFFF
L244c0092:
   mov DL,[ES:BX]
   cmp AL,DL
   jz L244c0092
   push BX
   push DX
   mov AX,0037
   push AX
   call far _delay
   pop AX
   pop DX
   pop BX
   cmp DL,[ES:BX]
   jz L244c00b3
   dec word ptr [CS:offset Y244c0000]
jmp near L244c008c
L244c00b3:
   pop ES
   pop DX
   pop CX
   pop BX
ret near

Segment 2457 ;; GETVECT
_getvect: ;; 24570008
   push BP
   mov BP,SP
   mov AH,35
   mov AL,[BP+06]
   int 21
   mov AX,BX
   mov DX,ES
jmp near L24570018
L24570018:
   pop BP
ret far

_setvect: ;; 2457001a
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

Segment 2459 ;; GOTOXY
_gotoxy: ;; 2459000b
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
   mov AL,[offset __video+00]
   add [BP-01],AL
   mov AL,[BP-02]
   cmp AL,[offset __video+01]
   jb L24590051
   mov AL,[BP-02]
   cmp AL,[offset __video+03]
   ja L24590051
   mov AL,[BP-01]
   cmp AL,[offset __video+00]
   jb L24590051
   mov AL,[BP-01]
   cmp AL,[offset __video+02]
   jbe L24590053
L24590051:
jmp near L24590062
L24590053:
   mov DL,[BP-01]
   mov DH,[BP-02]
   mov AH,02
   mov BH,00
   call far __VideoInt
L24590062:
   mov SP,BP
   pop BP
ret far

Segment 245f ;; GPTEXT
_gettext: ;; 245f0006
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
   jnz L245f0024
   xor AX,AX
jmp near L245f0059
L245f0024:
   mov DI,[BP+0A]
   sub DI,[BP+06]
   inc DI
   mov SI,[BP+08]
jmp near L245f004f
L245f0030:
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
L245f004f:
   cmp SI,[BP+0C]
   jle L245f0030
   mov AX,0001
jmp near L245f0059
L245f0059:
   pop DI
   pop SI
   pop BP
ret far

_puttext: ;; 245f005d
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+0A]
   sub DI,[BP+06]
   inc DI
   mov SI,[BP+08]
jmp near L245f008d
L245f006e:
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
L245f008d:
   cmp SI,[BP+0C]
   jle L245f006e
   mov AX,0001
jmp near L245f0097
L245f0097:
   pop DI
   pop SI
   pop BP
ret far

Segment 2468 ;; INTR, LDIV, LRSH
_intr: ;; 2468000b
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
   jb L24680053
   cmp AL,26
   ja L24680053
   mov byte ptr [BP-09],36
   mov word ptr [BP-08],068F
   mov [BP-06],CX
   mov byte ptr [BP-04],CA
   mov word ptr [BP-03],0002
jmp near L2468005c

X24680051:
   nop

A24680052:
iret
L24680053:
   mov byte ptr [BP-09],CA
   mov word ptr [BP-08],0002
L2468005c:
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
   call near offset A24680052
   pop DS
   pop BP
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 2473 ;; MOVETEXT
_movetext: ;; 24730000
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
   jz L24730040
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
   jnz L24730044
L24730040:
   xor AX,AX
jmp near L247300a6
L24730044:
   mov [BP-06],SI
   mov AX,[BP+0C]
   mov [BP-04],AX
   mov word ptr [BP-02],0001
   cmp SI,[BP+10]
   jge L24730065
   mov AX,[BP+0C]
   mov [BP-06],AX
   mov [BP-04],SI
   mov word ptr [BP-02],FFFF
L24730065:
   mov DI,[BP-06]
jmp near L24730097
L2473006a:
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
L24730097:
   mov AX,[BP-04]
   add AX,[BP-02]
   cmp AX,DI
   jnz L2473006a
   mov AX,0001
jmp near L247300a6
L247300a6:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 247d ;; OUTPORT
_outport: ;; 247d000c
   push BP
   mov BP,SP
   mov DX,[BP+06]
   mov AX,[BP+08]
   out DX,AX
   pop BP
ret far

_outportb: ;; 247d0018 ;; (@) Unaccessed.
   push BP
   mov BP,SP
   mov DX,[BP+06]
   mov AL,[BP+08]
   out DX,AL
   pop BP
ret far

Segment 247f ;; OVERFLOW, PSBP, RAND, SCOPY
_srand: ;; 247f0004
   push BP
   mov BP,SP
   mov AX,[BP+06]
   xor DX,DX
   mov [offset Y24dc28b4+2],DX
   mov [offset Y24dc28b4+0],AX
   pop BP
ret far

_rand: ;; 247f0015
   mov DX,[offset Y24dc28b4+2]
   mov AX,[offset Y24dc28b4+0]
   mov CX,015A
   mov BX,4E35
   call far LXMUL@
   add AX,0001
   adc DX,+00
   mov [offset Y24dc28b4+2],DX
   mov [offset Y24dc28b4+0],AX
   mov AX,[offset Y24dc28b4+2]
   and AX,7FFF
jmp near L247f003c
L247f003c:
ret far

Segment 2482 ;; SCROLL
B2482000d:
   push BP
   mov BP,SP
   mov CH,[offset __video+04]
   mov CL,20
jmp near L24820025
L24820018:
   les BX,[BP+08]
   mov [ES:BX],CX
   add word ptr [BP+08],+02
   inc word ptr [BP+06]
L24820025:
   mov AX,[BP+06]
   cmp AX,[BP+04]
   jle L24820018
   pop BP
ret near 0008

__SCROLL: ;; 24820031
   push BP
   mov BP,SP
   sub SP,00A0
   cmp byte ptr [offset __video+09],00
   jz L24820042
jmp near L2482018c
L24820042:
   cmp word ptr [offset _directvideo],+00
   jnz L2482004c
jmp near L2482018c
L2482004c:
   cmp byte ptr [BP+06],01
   jz L24820055
jmp near L2482018c
L24820055:
   inc byte ptr [BP+0E]
   inc byte ptr [BP+0C]
   inc byte ptr [BP+0A]
   inc byte ptr [BP+08]
   cmp byte ptr [BP+10],06
   jz L2482006a
jmp near L248200fb
L2482006a:
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
   lea AX,[BP+FF60]
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
   lea AX,[BP+FF60]
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   mov AL,[BP+0A]
   mov AH,00
   push AX
   call near B2482000d
   push SS
   lea AX,[BP+FF60]
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
jmp near L2482018a
L248200fb:
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
   lea AX,[BP+FF60]
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
   lea AX,[BP+FF60]
   push AX
   mov AL,[BP+0E]
   mov AH,00
   push AX
   mov AL,[BP+0A]
   mov AH,00
   push AX
   call near B2482000d
   push SS
   lea AX,[BP+FF60]
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
L2482018a:
jmp near L248201a7
L2482018c:
   mov BH,[offset __video+04]
   mov AH,[BP+10]
   mov AL,[BP+06]
   mov CH,[BP+0C]
   mov CL,[BP+0E]
   mov DH,[BP+08]
   mov DL,[BP+0A]
   call far __VideoInt
L248201a7:
   mov SP,BP
   pop BP
ret far 000C

Segment 249c ;; SCREEN
B249c000d:
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
jmp near L249c0046
L249c0046:
   pop SI
   mov SP,BP
   pop BP
ret near 0004

B249c004d:
   push BP
   mov BP,SP
   les BX,[BP+08]
   mov DX,[ES:BX]
   les BX,[BP+04]
   cmp DX,[ES:BX]
   jz L249c006d
   mov BH,00
   mov AH,02
   call far __VideoInt
   les BX,[BP+04]
   mov [ES:BX],DX
L249c006d:
   inc DL
   mov AL,DL
   cmp AL,[offset __video+08]
   jb L249c007b
   inc DH
   mov DL,00
L249c007b:
   les BX,[BP+08]
   mov [ES:BX],DX
   pop BP
ret near 0008

B249c0085:
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
   jnz L249c00a7
   mov AX,0001
jmp near L249c00a9
L249c00a7:
   xor AX,AX
L249c00a9:
   mov [BP-04],AX
   or AX,AX
   jz L249c00bc
   push [BP+0C]
   push [BP+0A]
   call near B249c000d
   mov [BP-0A],AX
L249c00bc:
   mov AX,[BP+08]
   cmp AX,[offset __video+0d]
   jnz L249c00ca
   mov AX,0001
jmp near L249c00cc
L249c00ca:
   xor AX,AX
L249c00cc:
   mov [BP-02],AX
   or AX,AX
   jz L249c00df
   push [BP+08]
   push [BP+06]
   call near B249c000d
   mov [BP-08],AX
L249c00df:
jmp near L249c013a
L249c00e1:
   cmp word ptr [BP-02],+00
   jz L249c0101
   push SS
   lea AX,[BP-08]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   call near B249c004d
   mov BH,00
   mov AH,08
   call far __VideoInt
   mov SI,AX
jmp near L249c010b
L249c0101:
   les BX,[BP+06]
   mov SI,[ES:BX]
   add word ptr [BP+06],+02
L249c010b:
   cmp word ptr [BP-04],+00
   jz L249c0130
   push SS
   lea AX,[BP-0A]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   call near B249c004d
   mov AX,SI
   mov BL,AH
   mov CX,0001
   mov BH,00
   mov AH,09
   call far __VideoInt
jmp near L249c013a
L249c0130:
   les BX,[BP+0A]
   mov [ES:BX],SI
   add word ptr [BP+0A],+02
L249c013a:
   mov AX,[BP+04]
   dec word ptr [BP+04]
   or AX,AX
   jnz L249c00e1
   mov DX,DI
   mov BH,00
   mov AH,02
   call far __VideoInt
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret near 000A

__SCREENIO: ;; 249c0157
   push BP
   mov BP,SP
   cmp byte ptr [offset __video+09],00
   jnz L249c017e
   cmp word ptr [offset _directvideo],+00
   jz L249c017e
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far __VRAM
jmp near L249c0190
L249c017e:
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call near B249c0085
L249c0190:
   pop BP
ret far 000A

__VALIDATEXY: ;; 249c0194
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
   ja L249c01d6
   mov AX,[BP+08]
   cmp AX,CX
   ja L249c01d6
   mov AX,[BP+0C]
   cmp AX,[BP+08]
   jg L249c01d6
   mov AX,[BP+0A]
   cmp AX,DX
   ja L249c01d6
   mov AX,[BP+06]
   cmp AX,DX
   ja L249c01d6
   mov AX,[BP+0A]
   cmp AX,[BP+06]
   jg L249c01d6
   mov AX,0001
jmp near L249c01d8
L249c01d6:
   xor AX,AX
L249c01d8:
jmp near L249c01da
L249c01da:
   pop BP
ret far 0008

Segment 24b9 ;; SOUND
_sound: ;; 24b9000e
   push BP
   mov BP,SP
   mov BX,[BP+06]
   mov AX,34DD
   mov DX,0012
   cmp DX,BX
   jnb L24b90038
   div BX
   mov BX,AX
   in AL,61
   test AL,03
   jnz L24b90030
   or AL,03
   out 61,AL
   mov AL,B6
   out 43,AL
L24b90030:
   mov AL,BL
   out 42,AL
   mov AL,BH
   out 42,AL
L24b90038:
   pop BP
ret far

_nosound: ;; 24b9003a
   in AL,61
   and AL,FC
   out 61,AL
ret far

Segment 24bd ;; STRDUP
_strdup: ;; 24bd0001
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
   jz L24bd003e
   push SI
   push [BP+08]
   push [BP+06]
   push [BP-02]
   push [BP-04]
   call far _memcpy
   add SP,+0A
L24bd003e:
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L24bd0046
L24bd0046:
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 24c1 ;; STRUPR
_strupr: ;; 24c1000b
   push BP
   mov BP,SP
   push SI
   cld
   push DS
   lds SI,[BP+06]
   mov DX,SI
jmp near L24c10023
L24c10018:
   sub AL,61
   cmp AL,19
   ja L24c10023
   add AL,41
   mov [SI-01],AL
L24c10023:
   lodsb
   and AL,AL
   jnz L24c10018
   mov AX,DX
   mov DX,DS
   pop DS
   pop SI
   pop BP
ret far

Segment 24c4 ;; TOUPPER
_toupper: ;; 24c40000
   push BP
   mov BP,SP
   cmp word ptr [BP+06],-01
   jnz L24c4000e
   mov AX,FFFF
jmp near L24c4002f
L24c4000e:
   mov AL,[BP+06]
   mov AH,00
   mov BX,AX
   test byte ptr [BX+offset __ctype+01],08
   jz L24c40028
   mov AL,[BP+06]
   mov AH,00
   add AX,FFE0
jmp near L24c4002f

X24c40026:
jmp near L24c4002f
L24c40028:
   mov AL,[BP+06]
   mov AH,00
jmp near L24c4002f
L24c4002f:
   pop BP
ret far

Segment 24c7 ;; VRAM
__VPTR: ;; 24c70001
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
jmp near L24c70022
L24c70022:
   pop BP
ret far 0004

__VRAM: ;; 24c70026
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
   jcxz L24c70096
   les DI,[BP+0C]
   lds SI,[BP+08]
   cld
   cmp SI,DI
   jnb L24c70051
   mov AX,CX
   dec AX
   shl AX,1
   add SI,AX
   add DI,AX
   std
L24c70051:
   cmp word ptr [BP-02],+00
   jnz L24c7005b
   repz movsw
jmp near L24c70096
L24c7005b:
   mov DX,03DA
   mov AX,ES
   mov BX,DS
   cmp AX,BX
   jz L24c70077
L24c70066:
   cli
L24c70067:
   in AL,DX
   ror AL,1
   jb L24c70067
L24c7006c:
   in AL,DX
   ror AL,1
   jnb L24c7006c
   movsw
   sti
   loop L24c70066
jmp near L24c70096
L24c70077:
   cli
L24c70078:
   in AL,DX
   ror AL,1
   jb L24c70078
L24c7007d:
   in AL,DX
   ror AL,1
   jnb L24c7007d
   lodsw
   sti
   mov BX,AX
L24c70086:
   in AL,DX
   ror AL,1
   jb L24c70086
L24c7008b:
   in AL,DX
   ror AL,1
   jnb L24c7008b
   mov AX,BX
   stosw
   sti
   loop L24c70077
L24c70096:
   cld
   pop DS
jmp near L24c7009a
L24c7009a:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far 000A

Segment 24d1 ;; WHEREXY
__wherexy: ;; 24d10002
   mov AH,03
   mov BH,00
   call far __VideoInt
   mov AX,DX
jmp near L24d1000f
L24d1000f:
ret far

_wherex: ;; 24d10010 ;; (@) Unaccessed.
   push CS
   call near offset __wherexy
   mov AH,00
   mov DL,[offset __video+00]
   mov DH,00
   sub AX,DX
   inc AX
jmp near L24d10021
L24d10021:
ret far

_wherey: ;; 24d10022 ;; (@) Unaccessed.
   push CS
   call near offset __wherexy
   mov CL,08
   shr AX,CL
   mov AH,00
   mov DL,[offset __video+01]
   mov DH,00
   sub AX,DX
   inc AX
jmp near L24d10037
L24d10037:
ret far

Segment 24d4 ;; WINDOW
_window: ;; 24d40008
   push BP
   mov BP,SP
   dec word ptr [BP+06]
   dec word ptr [BP+0A]
   dec word ptr [BP+08]
   dec word ptr [BP+0C]
   cmp word ptr [BP+06],+00
   jl L24d40047
   mov AL,[offset __video+08]
   mov AH,00
   cmp AX,[BP+0A]
   jle L24d40047
   cmp word ptr [BP+08],+00
   jl L24d40047
   mov AL,[offset __video+07]
   mov AH,00
   cmp AX,[BP+0C]
   jle L24d40047
   mov AX,[BP+0A]
   sub AX,[BP+06]
   jl L24d40047
   mov AX,[BP+0C]
   sub AX,[BP+08]
   jge L24d40049
L24d40047:
jmp near L24d40070
L24d40049:
   mov AL,[BP+06]
   mov [offset __video+00],AL
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
L24d40070:
   pop BP
ret far

X24d40072:	ds 2*0007	;; (@) Unaccessed.

Segment 24dc ;; Data And BSS Areas
;; Data Area
A24dc0000:
X24dc0000:	dword	;; (@) Unaccessed.
X24dc0004:	db "Turbo-C - Copyright (c) 1988 Borland Intl.",00	;; (@) Unaccessed.
Y24dc002f:	db "Divide error\r\n"
Y24dc003d:	db "Abnormal program termination\r\n"
__Int0Vector:	dword	;; 24dc005b
__Int4Vector:	dword	;; 24dc005f
__Int5Vector:	dword	;; 24dc0063
__Int6Vector:	dword	;; 24dc0067
__argc:		word	;; 24dc006b
__argv:		dword	;; 24dc006d
_environ:	dword	;; 24dc0071
__envLng:	word	;; 24dc0075
__envseg:	word	;; 24dc0077
__envSize:	word	;; 24dc0079
__psp:		word	;; 24dc007b
__version:	;; 24dc007d
__osmajor:	byte	;; 24dc007d
__osminor:	byte	;; 24dc007e ;; (@) Unaccessed. Aliased through __version.
_errno:		word	;; 24dc007f
__8087:		word	;; 24dc0081
__StartTime:	dword	;; 24dc0083
__heapbase:	dword	;; 24dc0087
__brklvl:	dword	;; 24dc008b
__heaptop:	dword	;; 24dc008f
X24dc0093:	byte	;; 24dc0093 ;; (@) Unaccessed; alignment padding.
_egatab:	;; 24dc0094
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
_vgapal:	;; 24dc0194	;; 20:00
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
_DacWrite:	dw 03c8	;; 24dc0494
_DacRead:	dw 03c7	;; 24dc0496
_DacData:	dw 03c9	;; 24dc0498
_input_status_1:	dw 03da	;; 24dc049a ;; (@) Unaccessed.
_vbi_mask:	dw 0008 ;; 24dc049c ;; (@) Unaccessed.
Y24dc049e:	db "\r\nVideo mode: C)ga E)ga V)ga? ",00	;; 24dc049e
X24dc04bd:	byte	;; 24dc04bd				;; (@) Unaccessed; alignment padding?
Y24dc04be:	db " ",00	;; 24dc04be
_systime:	dword	;; 24dc04c0
_macptr:	dword	;; 24dc04c4
Y24dc04c8:	word	;; 24dc04c8	;; CtrlTime	;; Local to _checkctrl.
Y24dc04ca:	word	;; 24dc04ca	;; ExDx1	;; Local to _recmac.
Y24dc04cc:	word	;; 24dc04cc	;; ExDy1	;; Local to _recmac.
Y24dc04ce:	word	;; 24dc04ce	;; ExFire1	;; Local to _recmac.
Y24dc04d0:	word	;; 24dc04d0	;; ExFire2	;; Local to _recmac.
Y24dc04d2:	word	;; 24dc04d2	;; ExGameOut	;; Local to _recmac.
Y24dc04d4:	db "\r\n",00
Y24dc04d7:	db "\r\nJoystick calibration:  Press ESCAPE to abort.\r\n",00
Y24dc0509:	db "  Center joystick and press button: ",00
Y24dc052e:	db "  Move joystick to UPPER LEFT corner and press button: ",00
Y24dc0566:	db "  Move joystick to LOWER RIGHT corner and press button: ",00
Y24dc059f:	db "   Calibration failed - try again (y/N)? ",00
Y24dc05c8:	db "\r\n",00
Y24dc05cb:	db "\r\nGame controller:  K)eyboard,  J)oystick?  ",00
Y24dc05f8:	db "\r\n",00
X24dc05fb:	byte	;; 24dc05fb	;; (@) Unaccessed; alignment padding?
_path:		ds 0040	;; 24dc05fc
_nosnd:		word	;; 24dc063c
_cfgdemo:	word	;; 24dc063e
Y24dc0640:	db "\r\n\r\nDetecting your hardward\r\n",00
Y24dc0661:	db "\r\nIf your system locks, reboot and type:\r\n",00
Y24dc068c:	db "   ",00
Y24dc0690:	db " /NOSB  (No Sound Blaster card).\r\n",00
Y24dc06b2:	db "   ",00
Y24dc06b6:	db " /SB    (With a Sound Blaster)\r\n",00
Y24dc06d7:	db "   ",00
Y24dc06db:	db " /NOSND (If all else fails)\r\n",00
Y24dc06f9:	db "/test",00
Y24dc06ff:	db "/NOSB",00
Y24dc0705:	db "/SB",00
Y24dc0709:	db "/NOSND",00
Y24dc0710:	db "/DEMO",00
Y24dc0716:	db "\r\n",00
Y24dc0719:	db " Your configration:\r\n",00
Y24dc0730:	db "    Digital Sound Blaster sound effects ON\r\n",00
Y24dc075d:	db "    No digitized sound effects\r\n",00
Y24dc077e:	db "    Sound Blaster musical sound track ON\r\n",00
Y24dc07a9:	db "    No musical sound track\r\n",00
Y24dc07c6:	db "    A joystick\r\n",00
Y24dc07d7:	db "    No joystick\r\n",00
Y24dc07e9:	db "    CGA graphics (You're missing some\r\n",00
Y24dc0811:	db "    hot 256-color VGA scenery!)\r\n",00
Y24dc0833:	db "    16-color EGA graphics\r\n",00
Y24dc084f:	db "    256-color VGA graphics\r\n",00
Y24dc086c:	db "\r\n",00
Y24dc086f:	db "  Press ENTER if this is correct\r\n",00
Y24dc0892:	db "     or press 'C' to configure: ",00
Y24dc08b4:	db "\r\n",00
Y24dc08b7:	db " No Sound Blaster compatible music card has been\r\n",00
Y24dc08ea:	db " detected.\r\n\r\n",00
Y24dc08f9:	db " Press any key to continue...",00
Y24dc0917:	db "\r\n\r\n",00
Y24dc091c:	db " A Sound Blaster card was detected, but your CPU is\r\n",00
Y24dc0952:	db " too slow to support digitized sound.  Digital sound\r\n",00
Y24dc0989:	db " is now OFF\r\n\r\n",00
Y24dc099a:	db " Press any key to continue...",00
Y24dc09b8:	db " A Sound Blaster card has been detected.\r\n\r\n",00
Y24dc09e5:	db " This game will play high quality digital sound\r\n",00
Y24dc0a17:	db " through your Sound Blaster if you wish.\r\n\r\n",00
Y24dc0a44:	db " Warning:  There's a teeny chance this will cause\r\n",00
Y24dc0a78:	db "  problems if you have less than 640K of RAM, or\r\n",00
Y24dc0aaa:	db " if your computer is not totally compatible.\r\n\r\n",00
Y24dc0adb:	db " Do you want digital sound? ",00
Y24dc0af8:	db "\r\n\r\n\r\n",00
Y24dc0aff:	db " This game features a Sound Blaster-compatible\r\n",00
Y24dc0b30:	db " musical sound track.\r\n\r\n\r\n",00
Y24dc0b4c:	db " Do you want the musical sound track? ",00
Y24dc0b73:	db "\r\n",00
Y24dc0b76:	db "\r\n",00
Y24dc0b79:	db " Please tell us about your graphics:\r\n",00
Y24dc0ba0:	db "     CGA 4-color graphics\r\n",00
Y24dc0bbc:	db "     EGA 16-color graphics\r\n",00
Y24dc0bd9:	db "     VGA 256-color graphics\r\n",00
Y24dc0bf7:	db "\r\n",00
Y24dc0bfa:	db " Note: If you have a slow old coomputer, CGA\r\n",00
Y24dc0c28:	db "       graphics are recommended.\r\n",00
X24dc0c4b:	byte		;; 24dc0c4b	;; (@) Unaccessed; alignment padding?
Y24dc0c4c:	db "\\screen",00
Y24dc0c54:	db ".RAW",00
Y24dc0c59:	db "\\screen",00
Y24dc0c61:	db ".MAP",00
Y24dc0c66:	db " ",00
Y24dc0c68:	db " ",00
Y24dc0c6a:	db "\r\n",00
X24dc0c6d:	byte		;; 24dc0c6d	;; (@) Unaccessed; alignment padding?
_soundoff:	dw 0001		;; 24dc0c6e
_soundf:	dw 0001		;; 24dc0c70
_makesound:	word		;; 24dc0c72
_myclock:	dd Y0040006c	;; 24dc0c74
_timer8int:	dword		;; 24dc0c78
_pc_sound:	dd _our_pc_sound	;; 24dc0c7c
_xvoclen:	word		;; 24dc0c80
_longclock:	dword		;; 24dc0c82
_notetable:	;; 24dc0c86
		dw 0040,0043,0047,004c,0050,0055,005a,005f,0065,006b,0072,0079,0000,0000,0000,0000
		dw 0080,0087,008f,0098,00a1,00aa,00b5,00bf,00cb,00d7,00e4,00f2,0000,0000,0000,0000
		dw 0100,010f,011f,0130,0142,0155,016a,017f,0196,01ae,01c8,01e3,0000,0000,0000,0000
		dw 0200,021e,023e,0260,0285,02ab,02d4,02ff,032c,035d,0390,03c7,0000,0000,0000,0000
		dw 0400,043c,047d,04c1,050a,0556,05a8,05fe,0659,06ba,0721,078d,0000,0000,0000,0000
		dw 0800,0879,08fa,0983,0a14,0aad,0b50,0bfc,0cb2,0d74,0e41,0f1a,0000,0000,0000,0000
		dw 1000,10f3,11f5,1306,1428,155b,16a0,17f9,1965,1ae8,1c82,1e34,0000,0000,0000,0000
		dw 2000,21e7,23eb,260d,2851,2ab7,2d41,2ff2,32cb,35d1,3904,3d1e,0000,0000,0000,0000
		dw 4000,43ce,47d6,4c1b,50a2,556e,5a82,5fe4,6597,6ba2,7208,78d0,0000,0000,0000,0000
_intrcount:	dw 0010	;; 24dc0da6
_musiccount:	word	;; 24dc0da8
_musicval:	word	;; 24dc0daa
_timercount:	word	;; 24dc0dac
_countdown:	dw 0001	;; 24dc0dae
_countmax:	dw 0001	;; 24dc0db0
_toggle:	byte	;; 24dc0db2 ;; (@) Unaccessed.
_freq:		dword	;; 24dc0db3
_dur:		dword	;; 24dc0db7
_headersize:	dw 0280	;; 24dc0dbb
_vocflag:	dw 0001	;; 24dc0dbd
_musicflag:	dw 0001	;; 24dc0dbf
_vocfilehandle:	dw ffff	;; 24dc0dc1
_music_buffer:	dword	;; 24dc0dc3
_transpose:	byte	;; 24dc0dc7 ;; (@) Unaccessed.
_first_nokey:		dw 0001	;; 24dc0dc8
_first_opendoor:	dw 0001	;; 24dc0dca
_first_apple:		dw 0001	;; 24dc0dcc
_first_knife:		dw 0001	;; 24dc0dce
_first_key:		dw 0001	;; 24dc0dd0
_first_openmapdoor:	dw 0001	;; 24dc0dd2
_first_nogem:		dw 0001	;; 24dc0dd4
Y24dc0dd6:	dw 0000,0001,0002,0001
Y24dc0dde:	dw 0001,0002,0001,0000,ffff,fffe,ffff,0000
Y24dc0dee:	dw 0000,0001,0002,0003,0002,0001,0009,0009
Y24dc0dfe:	dw 0004,0004,0004,0004,0004,0004,ffff,ffff
Y24dc0e0e:	dw 0000,0001,0002,0003,0002,0001
Y24dc0e1a:	dw 0000,0001,0002,0001
Y24dc0e22:	db "PLAYER",00
Y24dc0e29:	db "APPLE",00
Y24dc0e2f:	db "KNIFE",00
Y24dc0e35:	db "KILLME",00
Y24dc0e3c:	db "BIGANT",00
Y24dc0e43:	db "FLY",00
Y24dc0e47:	db "MACROTRIG",00
Y24dc0e51:	db "DEMON",00
Y24dc0e57:	db "BUNNY",00
Y24dc0e5d:	db "INCHWORM",00
Y24dc0e66:	db "ZAPPER",00
Y24dc0e6d:	db "BOBSLUG",00
Y24dc0e75:	db "CHECKPT",00
Y24dc0e7d:	db "PAUL",00
Y24dc0e82:	db "KEY",00
Y24dc0e86:	db "PAD",00
Y24dc0e8a:	db "WISEMAN",00
Y24dc0e92:	db "FATSO",00
Y24dc0e98:	db "FIREBALL",00
Y24dc0ea1:	db "CLOUD",00
Y24dc0ea7:	db "TEXT6",00
Y24dc0ead:	db "TEXT8",00
Y24dc0eb3:	db "FROG",00
Y24dc0eb8:	db "TINY",00
Y24dc0ebd:	db "DOOR",00
Y24dc0ec2:	db "FALLDOOR",00
Y24dc0ecb:	db "BRIDGER",00
Y24dc0ed3:	db "SCORE",00
Y24dc0ed9:	db "TOKEN",00
Y24dc0edf:	db "ANT",00
Y24dc0ee3:	db "PHOENIX",00
Y24dc0eeb:	db "FIRE",00
Y24dc0ef0:	db "SWITCH",00
Y24dc0ef7:	db "GEM",00
Y24dc0efb:	db "TXTMSG",00
Y24dc0f02:	db "BOULDER",00
Y24dc0f0a:	db "EXPL1",00
Y24dc0f10:	db "EXPL2",00
Y24dc0f16:	db "STALAG",00
Y24dc0f1d:	db "SNAKE",00
Y24dc0f23:	db "SEAROCK",00
Y24dc0f2b:	db "BOLL",00
Y24dc0f30:	db "MEGA",00
Y24dc0f35:	db "BAT",00
Y24dc0f39:	db "KNIGHT",00
Y24dc0f40:	db "BEENEST",00
Y24dc0f48:	db "BEESWARM",00
Y24dc0f51:	db "CRAB",00
Y24dc0f56:	db "CROC",00
Y24dc0f5b:	db "EPIC",00
Y24dc0f60:	db "SPINBLAD",00
Y24dc0f69:	db "SKULL",00
Y24dc0f6f:	db "BUTTON",00
Y24dc0f76:	db "PAC",00
Y24dc0f7a:	db "JILLFISH",00
Y24dc0f83:	db "JILLSPIDER",00
Y24dc0f8e:	db "JILLBIRD",00
Y24dc0f97:	db "JJILFROG",00
Y24dc0fa0:	db "BUBBLE",00
Y24dc0fa7:	db "JELLYFISH",00
Y24dc0fb1:	db "BADFISH",00
Y24dc0fb9:	db "ELEV",00
Y24dc0fbe:	db "FIREBULLET",00
Y24dc0fc9:	db "FISHBULLET",00
Y24dc0fd4:	db "EYE",00
Y24dc0fd8:	db "VINECLIMB",00
Y24dc0fe2:	db "FLAG",00
Y24dc0fe7:	db "MAPDEMO",00
Y24dc0fef:	db "ROMAN",00
Y24dc0ff5:	db "APPLES GIVE YOU HEALTH",00
Y24dc100c:	db "YOU FOUND A KNIFE!",00
Y24dc101f:	db "YOU FOUND A KEY!",00
Y24dc1030:	db "THE GATE OPENS",00
Y24dc103f:	db "YOU NEED A GEM TO PASS",00
Y24dc1056:	db "THE DOOR OPENS",00
Y24dc1065:	db "THE DOOR IS LOCKED",00
_first_switch:		dw 0001	;; 24dc1078
_first_elev:		dw 0001	;; 24dc107a
_first_hitknight:	dw 0001	;; 24dc107c
_first_touchgem:	dw 0001	;; 24dc107e
_inv_shape:	;; 24dc1080
		dw 0026,000c,000d,000b,000e,000f,0012,0014,0023,0024,0025
_inv_xfm:	;; 24dc1096
		dw 0001,0000,0000,0000,0001,0001,0000,0001,0000,0000,0000
_inv_getmsg:	;; 24dc10ac
		dd Y24dc1214,Y24dc121a,Y24dc1231,Y24dc1243,Y24dc1253,Y24dc1259,Y24dc1263,Y24dc1273
		dd _xblademsg,Y24dc127b,Y24dc128f
_inv_first:	;; 24dc10d8
		dw 0001,0001,0001,0001,ffff,ffff,ffff,ffff,0001,0001,0001
Y24dc10ee:	dw 0020,001f,001e,001d,001c,001d,001e,001f,0020
Y24dc1100:	dw 0000,0001,0000,0002
Y24dc1108:	dw 0003,0005,0004,0006
Y24dc1110:	dw 0007,0007,0008,0008
Y24dc1118:	dw 0004,0006,0008,000a,000c,000e
Y24dc1124:	dw 0000,0008,0000,0008
Y24dc112c:	dw 0001,0002,0003,0002
Y24dc1134:	dw 0008,0008,0000,0000,0000,0000,0000,0000,0000,0000,0008
Y24dc114a:	dw 0000,0000,0001,0002,0003,0004,0004,0003,0002,0001,0000
Y24dc1160:	dw 0000,0000,0000,0000,0001,0001,0001,0001,0002,0002,0002,0002,0003,0003,0003,0003
		dw 0003,0003,0003,0003,0003,0002,0002,0002,0002,0001,0001,0001,0001,0000,0000,0000
Y24dc11a0:	dw 0004,0005,0006,0007
Y24dc11a8:	dw 0000,0001,0002,0003
Y24dc11b0:	dw 0003,0004,0005,0006,0007,0006,0005,0004
Y24dc11c0:	dw 0000,0001,0002,0001
Y24dc11c8:	dw 0009,000a,000b,000c,000d,000e,000d,000c,000b,000a
Y24dc11dc:	dw 0000,0001,0002,0001
Y24dc11e4:	dw 0003,0002,0001,0001,0000,ffff,ffff,fffe,fffe,fffd,fffd,fffe,fffe,ffff,ffff,0000
		dw 0001,0001,0002,0003
Y24dc120c:	dw 0010,0014
Y24dc1210:	dw 0004,0003
Y24dc1214:	db "FOOF!",00
Y24dc121a:	db "USE KEYS TO OPEN DOORS",00
Y24dc1231:	db "YOU FOUND A KNIFE",00
Y24dc1243:	db "YOU FOUND A GEM",00
Y24dc1253:	db "POOF!",00
Y24dc1259:	db "ZZZZZZZT!",00
Y24dc1263:	db "A BAG OF COINS!",00
Y24dc1273:	db "KABOOM!",00
Y24dc127b:	db "EXTRA JUMPING POWER",00
Y24dc128f:	db "SHIELD OF INVINCIBILITY",00
Y24dc12a7:	db "Press UP/DOWN to toggle switch",00
Y24dc12c6:	db "USE GEMS TO OPEN DOORS ON THE MAP",00
Y24dc12e8:	db "YOUR FEEBLE ATTEMPT FAILS.",00
Y24dc1303:	db "Press UP/DOWN to use elevator",00
_blinkshtab:	;; 24dc1322
		dw 0008,0008,0008,0008,0009,000a,000b,000c,0026,0026,0026,0026,0026,000b,000a,0009
_pooftab:	;; 24dc1342
		dw ffff,fffe,ffff,0000
_fidgetseq:	;; 24dc134a
		dw 0013,0013,0013,0013
		dw 0013,0010,0012,0010
		dw 0013,0010,0012,0010
		dw 0012,0012,0012,0012
Y24dc136a:	db 18,18,19,1a,1a,19,19
Y24dc1371:	db 04,00,00,06,04,04,00
Y24dc1378:	db 48,49,48,49,48,48,49,48,49,49,48,48,48,49,49,49,4a,4a,4a,4a,4a
Y24dc138d:	dw 0000,0001,0002,0001
Y24dc1395:	dw 0000,0001,0002,0003,0002,0001
X24dc13a1:	byte	;; 24dc13a1 ;; (@) Unaccessed; alignment padding.
__stklen:	dw 4000	;; 24dc13a2
_debug:		word	;; 24dc13a4
_swrite:	word	;; 24dc13a6
_designflag:	word	;; 24dc13a8
_turtle:	word	;; 24dc13aa
_mirrortab:	;; 24dc13ac
		db 00,00,00,00,00,00,00,17,00,1c
		db 00,00,00,18,1c,00,00,00,00,00
		db 30,00,00,00,00,00,05,30,00,17
		db 18,12,10,00,03,00,0c,00,08,00
		db 29,00,20,08,18,0a,00,23,00,30
Y24dc13de:	word	;; 24dc13de ;; Moves
Y24dc13e0:	;; 24dc13e0 ;; QwertyTab
		db "1234567890-="
		db "QWERTYUIOP[]"
		db "ASDFGHJKL;'"
		db "ZXCVBNM,./"
		db 01,02,03,04,05,06
		db 00
Y24dc1414:	db "JUMP   ",00
Y24dc141c:	db "KNIFE  ",00
Y24dc1424:	db "       ",00
Y24dc142c:	db "       ",00
Y24dc1434:	db "       ",00
Y24dc143c:	db "FLAP   ",00
Y24dc1444:	db "FIRE   ",00
Y24dc144c:	db "HOP    ",00
Y24dc1454:	db "LEAP   ",00
Y24dc145c:	db "SWIM   ",00
Y24dc1464:	db "SHOOT  ",00
Y24dc146c:	db "       ",00
Y24dc1474:	db "       ",00
Y24dc147c:	db "____________",00
Y24dc1489:	db "Help",00
Y24dc148e:	db "N",00
Y24dc1490:	db "Q",00
Y24dc1492:	db "S",00
Y24dc1494:	db "R",00
Y24dc1496:	db "T",00
Y24dc1498:	db "NOISE",00
Y24dc149e:	db "QUIT",00
Y24dc14a3:	db "SAVE",00
Y24dc14a8:	db "RESTORE",00
Y24dc14b0:	db "TURTLE",00
Y24dc14b7:	db "HEALTH",00
Y24dc14be:	db "SCORE",00
Y24dc14c4:	db "LEVEL",00
Y24dc14ca:	db "MAP",00
Y24dc14ce:	db "      ",00
Y24dc14d4:	db "                                    ",00
Y24dc14f9:	db "PRESS F1 FOR HELP!",00
Y24dc150c:	db "YOU LEFT WITHOUT FINDING A GEM!",00
Y24dc152c:	db "temp.mac",00
Y24dc1535:	db "temp.mac",00
Y24dc153e:	db "A NEW RELEASE FROM",00
Y24dc1551:	db "PRODUCED BY",00
Y24dc155d:	db "NOW LOADING, PLEASE WAIT...",00
Y24dc1579:	db "____________",00
Y24dc1586:	db "HI SCORES",00
Y24dc1590:	db "____________",00
Y24dc159d:	db "____________",00
Y24dc15aa:	db "PRESS",00
Y24dc15b0:	db "TO ABORT",00
Y24dc15b9:	db "ESCAPE",00
Y24dc15c0:	db " ",00
Y24dc15c2:	db "LOAD GAME",00
Y24dc15cc:	db "<empty>",00
Y24dc15d4:	db ".",00
Y24dc15d6:	db "m.",00
Y24dc15d9:	db "SAVE GAME",00
Y24dc15e3:	db "",00
Y24dc15e4:	db ".",00
Y24dc15e6:	db "m.",00
Y24dc15e9:	db "INVENTORY",00
Y24dc15f3:	db "CONTROLS",00
Y24dc15fc:	db '7', "REALLY QUIT?\r"
		db '4', "YES\r"
		db '2', "NO\r"
		db 00
Y24dc1614:	db "YN",00
Y24dc1617:	db "temp",00
Y24dc161c:	db " Yikes, this game is goofed!  Please report this code:  <",00
Y24dc1656:	db ">\r\n",00
Y24dc165a:	db "\r\n",00
Y24dc165d:	db "\r\n\r\n",00
Y24dc1662:	db "   Problem: you don't have enough free RAM to run t his game properly.\r\n",00
Y24dc16aa:	db " Solutions: Boot from a blank floppy disk\r\n",00
Y24dc16d6:	db "            Run this game without any TSR's in memory\r\n",00
Y24dc170e:	db "            Buy more memory (640K is required)\r\n",00
Y24dc173f:	db "             Turn off the digital Sound Blaster effects -- they eat up RAM\r\n",00
Y24dc178b:	db " The problem may be due to not enough free RAM or disk space.",00
X24dc17c9:	byte	;; 24dc17c9	;; (@) Unaccessed; alignment padding?
Y24dc17ca:	word
Y24dc17cc:	word
Y24dc17ce:	db "kind:            ",00
Y24dc17e0:	db "stat:            ",00
Y24dc17f2:	db "  xd:            ",00
Y24dc1804:	db "  yd:            ",00
Y24dc1816:	db " cnt:            ",00
Y24dc1828:	db "Text Inside",00
Y24dc1834:	db "NONE",00
Y24dc1839:	db "obj:Add Oov",00
Y24dc1845:	db "Del Paste",00
Y24dc1850:	db "Kopy Mod",00
Y24dc185a:	db "Kind:",00
Y24dc1860:	db "Put:",00
Y24dc1865:	db "Clear?",00
Y24dc186c:	db "Load:",00
Y24dc1872:	db "Dis Y:",00
Y24dc1879:	db "New board?",00
Y24dc1884:	db "Save:",00
_xdemoflag:	word			;; 24dc188a
_pgmname:	db "JILL2",00		;; 24dc188c
_xshafile:	db "jill2.sha",00	;; 24dc1892
_xvocfile:	db "jill2.vcl",00	;; 24dc189c
_cfgfname:	db "jill2.cfg",00	;; 24dc18a6
_dmafile:	db "jill.dma",00	;; 24dc18b0
_mapboard:	db "0.jn2",00		;; 24dc18b9
_introboard:	db "intro.jn2",00	;; 24dc18bf
_xintrosong:	db "peaks.ddt",00	;; 24dc18c9
_xknightmsg:	db "The knight slices Jill in half",00	;; 24dc18d3
_xmsgdelay:	word			;; 24dc18f2
_xblademsg:	db "YOU FIND A SPINNING BLADE",00	;; 24dc18f4
_xbladename:	db "BLADE  ",00		;; 24dc190e
_savepfx:	db "jn2save",00		;; 24dc1916
_erroraddr:	;; 24dc191e
		db " Epic MegaGames, 10406 Holbrook Drive, Potomac MD 20854",00
_facetable:	dw 0018	;; 24dc1956
_xstartlevel:	word	;; 24dc1958
_xbordercol:	dw 0007	;; 24dc195a
_menu1:		;; 24dc195c
		db '7', "PICK A CHOICE:\r"
		db '2', "PLAY\r"
		db '2', "RESTORE\r"
		db '5', "STORY\r"
		db '5', "INSTRUCTIONS\r"
		db '5', "CREDITS\r"
		db '3', "DEMO\r"
		db '3', "NOISEMAKER\r"
		db '4', "QUIT\r"
		db 00
_menu2:		;; 24dc19b2
		db "PRSICDNQ",05,10,00
_menuc:		dw 0008	;; 24dc19bd
_demoboard:	;; 24dc19bf
		dd Y24dc23ee,Y24dc23f4,Y24dc23fa,Y24dc2401,Y24dc2402,Y24dc2403,Y24dc2404,Y24dc2405,Y24dc2406,Y24dc2407
_demolvl:	;; 24dc19e7
		db 03,09,11,00,00,00,00,00,00,00
_demoname:	;; 24dc19f1
		dd Y24dc2408,Y24dc2414,Y24dc2420,Y24dc242c,Y24dc242d,Y24dc242e,Y24dc242f,Y24dc2430,Y24dc2431,Y24dc2432

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
_JILLB:		;; 24dc1a19
		db 03,10,19,1b, 0f,c9,cd,cd,bb,"  ",c9,cd,cd,bb,"  ",c9,cd,cd,bb,"  ",c9,cd,cd,bb, 18
		db " ", 0c,"Epic MegaGames Presents"
		db 19,03, 0f,ba,"  ",ba,"  ",c8,cd,cd,bc,"  ",ba,"  ",ba,"  ",ba,"  ",ba
		db 19,03, da,c4,c4,c4,bf," ",da,c4,c4,bf," ",da,c4,c4,c4," ",da,c4,c4,bf, 18
		db " ", 0c,"A Commercial Production"
		db 19,03, 0f,ba,"  ",ba,"  ",c9,cd,cd,bb,"  ",ba,"  ",ba,"  ",ba,"  ",ba
		db 19,03, b3,"  ",c4,bf," ",b3,"  ",b3," ",c3,c4,c4,"  ",c0,c4,c4,bf, 18
		db 19,16, c9, 1a,03,cd, bc,"  ",ba,"  ",ba,"  ",ba,"  ",ba,"  ",ba,"  ",ba,"  ",ba
		db 19,03, c0,c4,c4,c4,d9," ",c0,c4,c4,d9," ",c0,c4,c4,c4," ",c0,c4,c4,d9, 18
		db "  ", 02,1a,06,db, 12,1a,0a,db, "  ",db
		db 0f,ba, 02,1a,06,db, 0f,ba, 02,db,db, 0f,ba, 02,db,db, 0f,ba, 02,db,db
		db 0f,ba, 02,db,db, 0f,ba, 02,db,db, 0f,ba, 02,db,db, 0f,ba, 02,db,db
		db 10,1a,19,db, 18
		db "  ",db,db, 06,1a,0e,db, 16,19,03, 0f,c8, 1a,06,cd, bc, 06,db,db, 0f,c8,cd,cd,bc
		db 06,db,db, 0f,c8,cd,cd,bc, 06,db,db, 0f,c8,cd,cd,bc, 06,db,db, 10,1a,17,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,db,db, 11,19,43, 10,db,db, 02,db,db, 18
		db "  ",db,db, 06,1a,47,db, 02,db,db, 18
		db "  ", 1a,4b,db, 18
		db 18
		db 0f,d2, 19,02, d2, 19,08, d2, 19,26, d2, 19,0c, 07,"Tim Sweeney", 18
		db 0f,ba, 19,02, ba, 19,08, ba, 19,26, ba,"  ", 07,"John Pallett-Plowright", 18
		db 0f,ba, 19,02, ba," ",c9,cd,cd,bb," ",c9,cd,cd,b9," ",c9,cd,cd,cd,bb," ",c9,cd,cd,b8
		db " ",c9,cd,cd,bb," ",c9,cd,cd,b8,c9,cd,cd,bb," ",d2,"  ",d2," ",c9,cd,cd,bb," ",c9,cd,cd,b9
		db 19,0b, 07,"Dan Froelich", 18
		db 0f,ba, 19,02, ba," ",ba,"  ",ba," ",ba,"  ",ba," ",ba,cd,cd,cd,bc," ",ba
		db 19,03, ba,"  ",ba," ",ba, 19,02, ba,"  ",ba," ",ba,"  ",ba," ",ba,"  ",ba," ",ba,"  ",ba
		db 19,0b, 07,"Joe Hitchens", 18
		db 0f,c8,cd,cd,cd,bc," ",d0,"  ",d0," ",c8,cd,cd,bc," ",c8, 1a,03,cd, " ",d0
		db 19,03, c8,cd,cd,b9," ",d0
		db 19,02, c8,cd,cd,bc," ",c8,cd,cd,bc," ",d0,"  ",d0," ",c8,cd,cd,bc, 18
		db 19,1a, cd,cd,cd,bc," ", 0b,"Copyright 1992 Epic MegaGames", 18
		db 00
_JILLE:		;; 24dc1d4c
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
		db 19,1a, 0a,"Thank you for playing Jill goes Underground!", 18
		db " ", 08,1a,13,dc, 07,dc, 18
		db " ", 08,db, 14," ", 0c,1a,04,dc, 19,0c
		db 08,10,db, 19,02, 09,"This is the second volume of the Jill series from Epic", 18
		db " ", 08,db, 14," ", 0c,db, 19,08, df, 19,06
		db 08,10,db, 19,02, 09,"MegaGames.  Please do not copy or distribute this", 18
		db " ", 08,db, 14," ", 0c,db,df,df,df," ",db,df,df,db," ",de,dd," ",db,df,df,"  "
		db 08,10,db, 19,02, 09,"program -- it is NOT shareware.  But please do share", 18
		db " ", 08,db, 14," ", 0c,db, 1a,03,dc, db,dc,dc,db," ",db,db," ",db,dc,dc,"  "
		db 08,10,db, 19,02, 09,"volume one (Jill of the Jungle) with your friends.", 18
		db " ", 08,db, 14,19,05, 0c,db, 19,0b
		db 08,10,db, 19,02, 09,"Only volume one is shareware.", 18
		db " ", 08,17,df, 14,1a,12,dc, 10,db, 18
		db " ", 09,1a,21,dc, 03,dc, 18
		db " ", 09,db, 11," ", 03,da,c4,c2,c4,bf, 19,08, da,c4,c4,c4, 19,0d
		db 09,db, 10,19,02, 0d,"We are Epic MegaGames and we're here to", 18
		db " ", 09,db, 11," ", 03,b3," ",b3," ",b3,da,c4,bf,da,c4,bf,da,c4,bf,b3
		db 19,02, da,c4,bf," ",c2,c2,bf,da,c4,bf,da,c4,c4," "
		db 09,db, 10,19,02, 0d,"bring you top quality computer", 18
		db " ", 09,db, 11," ", 03,b3, 19,02, b3,b3,c4,d9,b3," ",b3,b3," ",b3,b3," ",c4,bf,b3," ",b3," "
		db 1a,03,b3, c4,d9,c0,c4,bf," "
		db 09,db, 10,19,02, 0d,"entertainment at great prices!  Look in", 18
		db " ", 09,db, 11," ", 03,b3, 19,02, b3,c0,c4,c4,c0,c4,b3,c0,c4,b3,c0,c4,c4,d9,c0,c4,b3," ",d9," ",d9,c0
		db 1a,03,c4, d9," ", 09,db, 10,19,02, 0d,"our catalog (CATALOG.EXE) for information", 18
		db " ", 09,db, 11,19,08, 03,c4,c4,d9, 19,14, 09,db, 10,19,02, 0d,"about our other hot products.", 18
		db " ", 03,df, 09,1a,21,df, 18
		db 18
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
		db 18
		db 18
		db 18
		db 00
_e_len:		word	;; 24dc231f
_b_len:		dw 0332	;; 24dc2321
_v_producer:	db "Tim Sweeney",00		;; 24dc2323
_v_publisher:	db "Epic MegaGames",00		;; 24dc232f
_v_movename:	db "Move Jill",00		;; 24dc233e
_v_title:	db "Jill Goes Underground",00	;; 24dc2348
_fidgetmsg:	;; 24dc235e
		dd Y24dc2433,Y24dc2446,Y24dc2464,Y24dc2481
_leveltxt:	;; 24dc236e
		dd Y24dc249e,Y24dc249f,Y24dc24b6,Y24dc24b7,Y24dc24d7,Y24dc24d9,Y24dc24db,Y24dc24dd
		dd Y24dc24df,Y24dc24e1,Y24dc2508,Y24dc2527,Y24dc2545,Y24dc2547,Y24dc256a,Y24dc258c
		dd Y24dc25bd,Y24dc25e1,Y24dc25fa,Y24dc25fc,Y24dc25fe,Y24dc261c,Y24dc2620,Y24dc2624
		dd Y24dc2628,Y24dc262c,Y24dc2630,Y24dc2634,Y24dc2638,Y24dc263c,Y24dc2640,Y24dc2641
Y24dc23ee:	db "3.jn2",00
Y24dc23f4:	db "9.jn2",00
Y24dc23fa:	db "17.jn2",00
Y24dc2401:	db "",00
Y24dc2402:	db "",00
Y24dc2403:	db "",00
Y24dc2404:	db "",00
Y24dc2405:	db "",00
Y24dc2406:	db "",00
Y24dc2407:	db "",00
Y24dc2408:	db "jn2dem1.mac",00
Y24dc2414:	db "jn2dem2.mac",00
Y24dc2420:	db "jn2dem3.mac",00
Y24dc242c:	db "",00
Y24dc242d:	db "",00
Y24dc242e:	db "",00
Y24dc242f:	db "",00
Y24dc2430:	db "",00
Y24dc2431:	db "",00
Y24dc2432:	db "",00
Y24dc2433:	db "Look, an airplane!",00
Y24dc2446:	db "Are you just gonna sit there?",00
Y24dc2464:	db "Have you seen Jill anywhere?",00
Y24dc2481:	db "Hey,  your shoes are untied.",00
Y24dc249e:	db "",00
Y24dc249f:	db "JILL GOES\rUNDERGROUND\r",00
Y24dc24b6:	db "",00
Y24dc24b7:	db "JILL ENTERS\rMONTEZUMA'S\rCASTLE\r",00
Y24dc24d7:	db "\r",00
Y24dc24d9:	db "\r",00
Y24dc24db:	db "\r",00
Y24dc24dd:	db "\r",00
Y24dc24df:	db "\r",00
Y24dc24e1:	db "JILL DESCENDS\rINTO THE\rDEPTHS OR\rHECK\r",00
Y24dc2508:	db "JILL RUNS INTO\rTHE RED PUZZLE\r",00
Y24dc2527:	db "JILL SWIMS TO\rTHE WATERWORLD\r",00
Y24dc2545:	db "\r",00
Y24dc2547:	db "JILL DRIFTS\rINTO THE\rDEMONIC MAZE\r",00
Y24dc256a:	db "JILL BOUNDS\rINTO\rTHE BONUS LEVEL\r",00
Y24dc258c:	db "JILL WANDERS\rINTO THE LAND\rOF ETERNAL\rWEIRDNESS\r",00
Y24dc25bd:	db "JILL JUMPS\rINTO A STICKY\rSITUATION\r",00
Y24dc25e1:	db "JILL BETTER\rTHINK FAST!\r",00
Y24dc25fa:	db "\r",00
Y24dc25fc:	db "\r",00
Y24dc25fe:	db "JILL ESCAPES\rTHE UNDERGROUND\r",00
Y24dc261c:	db "21\r",00
Y24dc2620:	db "22\r",00
Y24dc2624:	db "23\r",00
Y24dc2628:	db "24\r",00
Y24dc262c:	db "25\r",00
Y24dc2630:	db "26\r",00
Y24dc2634:	db "27\r",00
Y24dc2638:	db "28\r",00
Y24dc263c:	db "29\r",00
Y24dc2640:	db "",00
Y24dc2641:	db "",00
_ct_music_status:	word	;; 24dc2642
_ct_io_addx:		dw 0220	;; 24dc2644
_ct_int_num:		ds 2*0003	;; 24dc2646
__doserrno:	word	;; 24dc264c
__dosErrorToSV:	;; 24dc264e
		db 00,13,02,02,04,05,06,08,08,08,14,15,05,13,ff,16
		db 05,11,02,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff
		db 05,05,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff
		db ff,ff,0f,ff,23,02,ff,0f,ff,ff,ff,ff,13,ff,ff,02
		db 02,05,0f,02,ff,ff,ff,13,ff,ff,ff,ff,ff,ff,ff,ff
		db 23,ff,ff,ff,ff,23,ff,13,ff,00
__exitbuf:	dd A22bc0007	;; 24dc26a8
__exitfopen:	dd A22bc0007	;; 24dc26ac
__exitopen:	dd A22bc0007	;; 24dc26b0
__atexitcnt:	word	;; 24dc26b4
__first:	dword	;; 24dc26b6
__last:		dword	;; 24dc26ba
__rover:	dword	;; 24dc26be
Y24dc26c2:	word	;; 24dc26c2 ;; PspN ;; Local to B22f3000a().
__ctype:	byte	;; 24dc26c4 ;; Offset by 1 to allow for _ctype[-1].
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
X24dc27c5:	byte	;; 24dc27c5	;; (@) Unaccessed; alignment padding?
__openfd:	;; 24dc27c6
		dw 2001,2002,2002,a004,a002,ffff,ffff,ffff
		dw ffff,ffff,ffff,ffff,ffff,ffff,ffff,ffff
		dw ffff,ffff,ffff,ffff
__fmode:	dw 4000	;; 24dc27ee
__notUmask:	dw ffff	;; 24dc27f0
Y24dc27f2:	db "print scanf : floating point formats not linked\r\n",00
Y24dc2824:	db "(null)",00
Y24dc282b:	db "0123456789ABCDEF"
Y24dc283b:	db 00
		db 14,14,01,14,15,14,14,14,14,02,00,14,03,04,14,09
		db 05,05,05,05,05,05,05,05,05,14,14,14,14,14,14,14
		db 14,14,14,14,0f,17,0f,08,14,14,14,07,14,16,14,14
		db 14,14,14,14,14,14,14,0d,14,14,14,14,14,14,14,14
		db 14,14,10,0a,0f,0f,0f,08,0a,14,14,06,14,12,0b,0e
		db 14,14,11,14,0c,14,14,0d,14,14,14,14,14,14,14,00
__video:	;; 24dc289c
		byte	;; 00
		byte	;; 01
		byte	;; 02
		byte	;; 03
		byte	;; 04
		byte	;; 05
		byte	;; 06
		byte	;; 07
		byte	;; 08
		byte	;; 09
		byte	;; 0a
		word	;; 0b
		word	;; 0d
_directvideo:	dw 0001	;; 24dc28ab
Y24dc28ad:	db "COMPAQ",00		;; 24dc28ad
Y24dc28b4:	dd 00000001		;; 24dc28b4	;; RandSeed
Y24dc28b8:	dw offset A076a019f	;; 24dc28b8
Y24dc28ba:	dw offset A076a019f	;; 24dc28ba
Y24dc28bc:	dw offset __c0crtinit	;; 24dc28bc
__RealCvtVector:	;; 24dc28be
			dd A076a03a9
__ScanTodVector:	;; 24dc28c2	;; (@) Unaccessed.
			dd A076a03ae,A076a03ae,A076a03ae

;; BSS Area
Y24dc28ce:	;; BegBSS	;; (@) Beginning of the BSS segment.
_colortab:	ds 0100	;; 24dc28ce
_shm_fname:	ds 0050	;; 24dc29ce
_shm_want:	ds 0080	;; 24dc2a1e
_shm_flags:	ds 0080	;; 24dc2a9e
_shm_tbllen:	ds 0080	;; 24dc2b1e
_shm_tbladdr:	ds 0100	;; 24dc2b9e
_LOST:		dword	;; 24dc2c9e
_cmtab:		ds 2*4*0100	;; 24dc2ca2
_mainvp:	ds 0010	;; 24dc34a2
_origmode:	word	;; 24dc34b2
_pagemode:	word	;; 24dc34b4
_pixvalue:	byte	;; 24dc34b6	;; 02:00
_pagelen:	word	;; 24dc34b7
_drawofs:	word	;; 24dc34b9
_showofs:	word	;; 24dc34bb
_x_ourmode:	byte	;; 24dc34bd
_pageshow:	word	;; 24dc34be	;; 04:00
_pagedraw:	word	;; 24dc34c0	;; 04:00
_pixelsperbyte:	word	;; 24dc34c2
_oldint9:	dword	;; 24dc34c4
_bhead:		dword	;; 24dc34c8
_btail:		dword	;; 24dc34cc
_e0code:	word	;; 24dc34d0
_k_ctrl:	byte	;; 24dc34d2
_k_alt:		byte	;; 24dc34d3
_keydown:	ds 2*0100	;; 24dc34d4
_bioscall:	byte	;; 24dc36d4
_k_shift:	byte	;; 24dc36d5
_k_numlock:	byte	;; 24dc36d6
_k_rshift:	byte	;; 24dc36d7
_k_lshift:	byte	;; 24dc36d8
X24dc36d9:	byte	;; 24dc36d9	;; (@) Unaccessed; alignment padding?
_curhi:		word	;; 24dc36da
_curlo:		word	;; 24dc36dc	;; (@) Unaccessed.
_curback:	word	;; 24dc36de
_cursorchar:	word	;; 24dc36e0
Y24dc36e2:	word	;; 24dc36e2	;; ExTicks	;; Local to _getmac().
Y24dc36e4:	word	;; 24dc36e4	;; NextTicks	;; Local to _getmac().
_dx1:		word	;; 24dc36e6
_dy1:		word	;; 24dc36e8
_fire1:		word	;; 24dc36ea
_flow1:		word	;; 24dc36ec
_fire2:		word	;; 24dc36ee
_joyxc:		word	;; 24dc36f0
_joyyc:		word	;; 24dc36f2
_joyyd:		word	;; 24dc36f4
_key:		word	;; 24dc36f6
_dx1old:	word	;; 24dc36f8
_dy1old:	word	;; 24dc36fa
_joyxl:		word	;; 24dc36fc
_keybuf:	ds 0100	;; 24dc36fe
_joyxr:		word	;; 24dc37fe
_dx1hold:	word	;; 24dc3800
_dy1hold:	word	;; 24dc3802
_joyyu:		word	;; 24dc3804
_mactime:	word	;; 24dc3806
_maclen:	word	;; 24dc3808
_joyflag:	word	;; 24dc380a
_macofs:	word	;; 24dc380c
_fire1off:	word	;; 24dc380e
_fire2off:	word	;; 24dc3810
_macfname:	ds 0020	;; 24dc3812
_macrecord:	word	;; 24dc3832
_joyxsense:	word	;; 24dc3834
_joyysense:	word	;; 24dc3836
_macplay:	word	;; 24dc3838
_macabort:	word	;; 24dc383a
_macaborted:	word	;; 24dc383c
_cf:		ds 2*000b	;; 24dc383e
X24dc3854:	ds 0040		;; 24dc3854	;; (@) Unaccessed. Padding space in _cf.
_sampf:		word		;; 24dc3894
_vocpri:	word		;; 24dc3896
_vocrate:	ds 2*0032	;; 24dc3898
_voclen:	ds 2*0032	;; 24dc38fc
_textmsg:	dword		;; 24dc3960
_vocptr:	ds 4*0032	;; 24dc3964
_zsndpri:	word		;; 24dc3a2c	;; (@) Unaccessed.
_soundmac:	ds 4*0080	;; 24dc3a2e
_textlen:	ds 2*0028	;; 24dc3c2e
_vocposn:	ds 4*0032	;; 24dc3c7e
_zsndnum:	word		;; 24dc3d46	;; (@) Unaccessed.
_oldfreq:	word		;; 24dc3d48
_xvocptr:	dword		;; 24dc3d4a
_soundlen:	word		;; 24dc3d4e	;; (@) Unaccessed.
_textposn:	ds 4*0028	;; 24dc3d50
_xtickrate:	word	;; 24dc3df0
_digi8int:	dword	;; 24dc3df2
_soundptr:	word	;; 24dc3df6
_xclockval:	word	;; 24dc3df8
_xclockrate:	word	;; 24dc3dfa
_bogus8int:	dword	;; 24dc3dfc
_music8int:	dword	;; 24dc3e00
_textmsglen:	word	;; 24dc3e04
_soundcount:	word	;; 24dc3e06
_notepriority:	word	;; 24dc3e08
_samppriority:	word	;; 24dc3e0a
_lastwater:	word	;; 24dc3e0c
_fidgetnum:	word	;; 24dc3e0e
_oldx0:		word	;; 24dc3e10
_oldy0:		word	;; 24dc3e12
_bd:		ds 2*0080*0040	;; 24dc3e14
_pl:		ds 0046	;; 24dc7e14
_info:		ds 8*0258	;; 24dc7e5a
_objs:		ds 1f*0102	;; 24dc911a
_hiname:	ds 000c*000a	;; 24dcb058
_botmsg:	ds 003c	;; 24dcb0d0
_botvp:		ds 0010	;; 24dcb10c
_cmdvp:		dword	;; 24dcb11c
_botcol:	word	;; 24dcb120
_bottime:	word	;; 24dcb122
_kindxl:	ds 2*0045	;; 24dcb124
_kindyl:	ds 2*0045	;; 24dcb1ae
_hiscore:	ds 4*000a	;; 24dcb238
_gamevp:	dword	;; 24dcb260
_ourwin:	ds 0058	;; 24dcb264
_kindmsg:	ds 4*0045	;; 24dcb2bc
_oursong:	ds 0020	;; 24dcb3d0
_statvp:	dword	;; 24dcb3f0
_tempvp:	ds 0010	;; 24dcb3f4
_demonum:	word	;; 24dcb404
_scrnxs:	word	;; 24dcb406
_scrnys:	word	;; 24dcb408
_kindname:	ds 4*0045	;; 24dcb40a
_scrollxd:	word	;; 24dcb51e
_scrollyd:	word	;; 24dcb520
_savename:	ds 0006*000c	;; 24dcb522
_tempname:	ds 0040	;; 24dcb56a
_curlevel:	ds 0020	;; 24dcb5aa
_numobjs:	word	;; 24dcb5ca
_newlevel:	ds 0020	;; 24dcb5cc
_kindtable:	ds 2*0045	;; 24dcb5ec
_kindscore:	ds 2*0045	;; 24dcb676
_levelwin:	ds 0058	;; 24dcb700
_gameover:	word	;; 24dcb758
_scrnobjs:	ds 2*00c0	;; 24dcb75a
_oldvgapal:	ds 0300	;; 24dcb8da
_stateinfo:	ds 2*0006	;; 24dcbbda
_statmodflg:	word	;; 24dcbbe6
_gamecount:	word	;; 24dcbbe8
_kindflags:	ds 2*0045	;; 24dcbbea
_oldscrollxd:	word	;; 24dcbc74
_oldscrollyd:	word	;; 24dcbc76
_oldlevelnum:	word	;; 24dcbc78
_numscrnobjs:	word	;; 24dcbc7a
_levelmsgclock:	word	;; 24dcbc7c
_disy:		word	;; 24dcbc7e
__atexittbl:	ds 4*0020	;; 24dcbc80
Y24dcbd00:	word	;; 24dcbd00	;; VideoIntBP	;; Local to __VideoInt().
Y24dcbd02:	;; EndBSS	;; (@) End of the BSS segment.
		ds 000e

;; Segment 30ad ;; Stack Area
emws_limitSP:		ds 00c0	;; 30ad0000 ;; 24dcbd10
emws_initialSP:		ds 000c	;; 30ad00c0 ;; 24dcbdd0
emws_saveVector:	dword	;; 30ad00cc ;; 24dcbddc
emws_nmiVector:		dword	;; 30ad00d0 ;; 24dcbde0
emws_status:		word	;; 30ad00d4 ;; 24dcbde4
emws_control:		word	;; 30ad00d6 ;; 24dcbde6
emws_TOS:		word	;; 30ad00d8 ;; 24dcbde8
emws_adjust:		word	;; 30ad00da ;; 24dcbdea
emws_fixSeg:		word	;; 30ad00dc ;; 24dcbdec
emws_BPsafe:		word	;; 30ad00de ;; 24dcbdee
emws_stamp:		dword	;; 30ad00e0 ;; 24dcbdf0
emws_version:		dw ffff	;; 30ad00e4 ;; 24dcbdf4
emuTop@:		;; 30ad00e6 ;; 24dcbdf6

;; === External Data Module ===
;; Segment 30bb ;; Sound Segment
_SOUNDS:	;; 30bb0006 ;; 30ad00e6 ;; 24dcbdf6
		dw 0180,0182,0184,0186,0188,018a,018c,018e,0190,0192,0194,0196,0198,019a,019c,019e
		dw 01a0,019f,019e,019d,019c,019b,019a,0199,0198,0197,0196,0195,0194,0193,0192,0191
		dw 0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192
		dw 0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192
		dw 0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192
		dw 0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192
		dw 0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192
		dw 0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192,0190,0192
		dw 0000,0000,0020,0002,0040,0006,0060,000c,0080,0014,00a0,001e,00c0,002a,00e0,0038
		dw 0100,0048,0120,005a,0140,006e,0160,0084,0180,009c,01a0,00b6,01c0,00d2,01e0,00f0
		dw 0200,0110,0220,0132,0240,0156,0260,017c,0280,01a4,02a0,01ce,02c0,01fa,02e0,0228
		dw 0300,0258,0320,028a,0340,02be,0360,02f4,0380,032c,03a0,0366,03c0,03a2,03e0,03e0
		dw 0400,0420,0420,0462,0440,04a6,0460,04ec,0480,0534,04a0,057e,04c0,05ca,04e0,0618
		dw 0500,0668,0520,06ba,0540,070e,0560,0764,0580,07bc,05a0,0816,05c0,0872,05e0,08d0
		dw 0600,0930,0620,0992,0640,09f6,0660,0a5c,0680,0ac4,06a0,0b2e,06c0,0b9a,06e0,0c08
		dw 0700,0c78,0720,0cea,0740,0d5e,0760,0dd4,0780,0e4c,07a0,0ec6,07c0,0f42,07e0,0fc0
		dw 0000,0001,0008,001b,0040,007d,00d8,0157,0200,02d9,03e8,0533,06c0,0895,0ab8,0d2f
		dw 1000,1331,16c8,1acb,1f40,242d,2998,2f87,3600,3d09,44a8,4ce3,55c0,5f45,6978,745f
		dw 8000,8c61,9988,a77b,b640,c5dd,d658,e7b7,fa00,0d39,2168,3693,4cc0,63f5,7c38,958f
		dw b000,cb91,e848,062b,2540,458d,6718,89e7,ae00,d369,fa28,2243,4bc0,76a5,a2f8,d0bf
		dw 0000,30c1,6308,96db,cc40,033d,3bd8,7617,b200,ef99,2ee8,6ff3,b2c0,f755,3db8,85ef
		dw d000,1bf1,69c8,b98b,0b40,5eed,b498,0c47,6600,c1c9,1fa8,7fa3,e1c0,4605,ac78,151f
		dw 8000,ed21,5c88,ce3b,4240,b89d,3158,ac77,2a00,a9f9,2c68,b153,38c0,c2b5,4f38,de4f
		dw 7000,0451,9b48,34eb,d140,704d,1218,b6a7,5e00,0829,b528,6503,17c0,cd65,85f8,417f
		dw 0270,0268,0260,0258,0250,0248,0241,0239,0232,022a,0223,021b,0214,020d,0206,01ff
		dw 01f8,01f1,01ea,01e3,01dc,01d5,01cf,01c8,01c2,01bb,01b5,01ae,01a8,01a2,019c,0196
		dw 0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190
		dw 0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190
		dw 0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190
		dw 0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190
		dw 0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190
		dw 0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190,0190
		dw 0022,000d,044a,006d,048d,02c7,010f,0281,0356,0118,0384,0056,0165,03c5,0225,0088
		dw 021d,00cf,040c,0080,017b,0356,02cf,0128,03be,0275,03b0,0268,01dd,0015,00f7,0053
		dw 036d,022a,0175,01d2,018d,021f,02ea,0019,012c,0173,0273,008f,024d,0008,0103,0218
		dw 01e3,00f2,00d9,000a,010d,013e,019f,00c8,00c5,0187,0011,01b8,0060,0189,005f,00f9
		dw 006e,0186,00cb,00b1,00b3,005a,0005,002b,00e4,00f2,00fa,0067,0052,001a,0092,00a5
		dw 0002,0099,009c,004f,003e,0007,0064,003c,0073,007b,0038,0050,000c,005e,001c,000b
		dw 004f,0015,004f,0038,000a,0045,0006,001a,0018,0017,002f,0028,000f,0002,0003,000f
		dw 000b,0016,0002,0010,000a,0004,0008,0001,0000,0001,0001,0001,0001,0000,0000,0000
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,07d0,08ca,09c4,0abe,0bb8,0cb2,0dac,0ea6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,07d0,08ca,09c4,0abe,0bb8,0cb2,0dac,0ea6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,07d0,08ca,09c4,0abe,0bb8,0cb2,0dac,0ea6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,07d0,08ca,09c4,0abe,0bb8,0cb2,0dac,0ea6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,07d0,08ca,09c4,0abe,0bb8,0cb2,0dac,0ea6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,07d0,08ca,09c4,0abe,0bb8,0cb2,0dac,0ea6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,07d0,08ca,09c4,0abe,0bb8,0cb2,0dac,0ea6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,07d0,08ca,09c4,0abe,0bb8,0cb2,0dac,0ea6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6
		dw 0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6,0000,00fa,01f4,02ee,03e8,04e2,05dc,06d6
		dw 01b7,036f,06df,0dbf,01b7,036f,06df,0dbf,01b7,036f,06df,0dbf,01b7,036f,06df,0dbf
		dw ffff,036f,06df,0dbf,01b7,036f,06df,0dbf,ffff,036f,06df,0dbf,01b7,036f,06df,0dbf
		dw ffff,ffff,06df,0dbf,01b7,036f,06df,0dbf,ffff,ffff,06df,0dbf,01b7,036f,06df,0dbf
		dw ffff,ffff,ffff,0dbf,01b7,036f,06df,0dbf,ffff,ffff,ffff,0dbf,01b7,036f,06df,0dbf
		dw ffff,ffff,ffff,ffff,01b7,036f,06df,0dbf,ffff,ffff,ffff,ffff,01b7,036f,06df,0dbf
		dw ffff,ffff,ffff,ffff,ffff,036f,06df,0dbf,ffff,ffff,ffff,ffff,ffff,036f,06df,0dbf
		dw ffff,ffff,ffff,ffff,ffff,ffff,06df,0dbf,ffff,ffff,ffff,ffff,ffff,ffff,06df,0dbf
		dw ffff,ffff,ffff,ffff,ffff,ffff,ffff,0dbf,ffff,ffff,ffff,ffff,ffff,ffff,ffff,0dbf
		dw 00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000
		dw 00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000
		dw 00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000
		dw 00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000
		dw 00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000
		dw 00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000
		dw 00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000
		dw 00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000,00c8,0000,0000,0000
		dw 0140,0000,0000,0000,0138,0000,0000,0000,0130,0000,0000,0000,0128,0000,0000,0000
		dw 0120,0000,0000,0000,0118,0000,0000,0000,0110,0000,0000,0000,0108,0000,0000,0000
		dw 0100,0000,0000,0000,00f8,0000,0000,0000,00f0,0000,0000,0000,00e8,0000,0000,0000
		dw 00e0,0000,0000,0000,00d8,0000,0000,0000,00d0,0000,0000,0000,00c8,0000,0000,0000
		dw 00c0,0000,0000,0000,00b8,0000,0000,0000,00b0,0000,0000,0000,00a8,0000,0000,0000
		dw 00a0,0000,0000,0000,0098,0000,0000,0000,0090,0000,0000,0000,0088,0000,0000,0000
		dw 0080,0000,0000,0000,0078,0000,0000,0000,0070,0000,0000,0000,0068,0000,0000,0000
		dw 0060,0000,0000,0000,0058,0000,0000,0000,0050,0000,0000,0000,0048,0000,0000,0000
		dw 0320,0322,0323,0322,0320,031e,031d,031e,0320,0322,0323,0322,0320,031e,031d,031e
		dw 0320,0322,0323,0322,0320,031e,031d,031e,0320,0322,0323,0322,0320,031e,031d,031e
		dw 0320,0322,0323,0322,0320,031e,031d,031e,0320,0322,0323,0322,0320,031e,031d,031e
		dw 0320,0322,0323,0322,0320,031e,031d,031e,0320,0322,0323,0322,0320,031e,031d,031e
		dw 0320,0322,0323,0322,0320,031e,031d,031e,0320,0322,0323,0322,0320,031e,031d,031e
		dw 0320,0322,0323,0322,0320,031e,031d,031e,0320,0322,0323,0322,0320,031e,031d,031e
		dw 0320,0322,0323,0322,0320,031e,031d,031e,0320,0322,0323,0322,0320,031e,031d,031e
		dw 0320,0322,0323,0322,0320,031e,031d,031e,0320,0322,0323,0322,0320,031e,031d,031e
		dw 0300,0305,030a,030d,0310,030f,030e,030b,0308,0305,0302,0301,0300,0303,0306,030b
		dw 0310,0315,031a,031d,0320,031f,031e,031b,0318,0315,0312,0311,0310,0313,0316,031b
		dw 0320,0324,0328,032a,032c,032a,0328,0324,0320,031c,0318,0316,0314,0316,0318,031c
		dw 0320,0324,0328,032a,032c,032a,0328,0324,0320,031c,0318,0316,0314,0316,0318,031c
		dw 0320,0324,0328,032a,032c,032a,0328,0324,0320,031c,0318,0316,0314,0316,0318,031c
		dw 0320,0324,0328,032a,032c,032a,0328,0324,0320,031c,0318,0316,0314,0316,0318,031c
		dw 0320,0324,0328,032a,032c,032a,0328,0324,0320,031c,0318,0316,0314,0316,0318,031c
		dw 0320,0324,0328,032a,032c,032a,0328,0324,0320,031c,0318,0316,0314,0316,0318,031c
		dw 0000,0000,0000,0000,0320,0000,0000,0000,0640,0000,0000,0000,0960,0000,0000,0000
		dw 0c80,0000,0000,0000,0fa0,0000,0000,0000,12c0,0000,0000,0000,15e0,0000,0000,0000
		dw 1900,0000,0000,0000,1c20,0000,0000,0000,1f40,0000,0000,0000,2260,0000,0000,0000
		dw 2580,0000,0000,0000,28a0,0000,0000,0000,2bc0,0000,0000,0000,2ee0,0000,0000,0000
		dw 3200,0000,0000,0000,3520,0000,0000,0000,3840,0000,0000,0000,3b60,0000,0000,0000
		dw 3e80,0000,0000,0000,41a0,0000,0000,0000,44c0,0000,0000,0000,47e0,0000,0000,0000
		dw 4b00,0000,0000,0000,4e20,0000,0000,0000,5140,0000,0000,0000,5460,0000,0000,0000
		dw 5780,0000,0000,0000,5aa0,0000,0000,0000,5dc0,0000,0000,0000,60e0,0000,0000,0000
		dw 0280,0285,028a,028f,0294,0299,029e,02a3,02a8,02ad,02b2,02b7,02bc,02c1,02c6,02cb
		dw 02d0,02d5,02da,02df,02e4,02e9,02ee,02f3,02f8,02fd,0302,0307,030c,0311,0316,031b
		dw 0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320
		dw 0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320
		dw 0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320
		dw 0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320
		dw 0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320
		dw 0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320,0320
		dw 0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8
		dw 0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980
		dw 0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800
		dw 0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8
		dw 0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980
		dw 0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800
		dw 0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8
		dw 0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980,0800,0bf8,0980
		dw 0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8
		dw 0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10
		dw 0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800
		dw 0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8
		dw 0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10
		dw 0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800
		dw 0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8
		dw 0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10,0800,0bf8,0a10
		dw 0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800
		dw 0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8
		dw 0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8
		dw 0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800
		dw 0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8
		dw 0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8
		dw 0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800
		dw 0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8,0bf8,0800,0aa8
		dw 0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800
		dw 0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8
		dw 0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70
		dw 0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800
		dw 0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8
		dw 0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70
		dw 0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800
		dw 0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8,0d70,0800,0aa8
		dw 05e0,05e3,05e6,05e9,05f0,05f3,05f6,05f9,0600,0603,0606,0609,060e,0611,0614,0617
		dw 061c,061f,0622,0625,0626,0629,062c,062f,0630,0633,0636,0639,0638,063b,063e,0641
		dw 0640,0640,0640,0640,063c,063c,063c,063c,0638,0638,0638,0638,0636,0636,0636,0636
		dw 0634,0634,0634,0634,0636,0636,0636,0636,0638,0638,0638,0638,063c,063c,063c,063c
		dw 0640,0640,0640,0640,0644,0644,0644,0644,0648,0648,0648,0648,064a,064a,064a,064a
		dw 064c,064c,064c,064c,064a,064a,064a,064a,0648,0648,0648,0648,0644,0644,0644,0644
		dw 0640,0640,0640,0640,063c,063c,063c,063c,0638,0638,0638,0638,0636,0636,0636,0636
		dw 0634,0634,0634,0634,0636,0636,0636,0636,0638,0638,0638,0638,063c,063c,063c,063c
		dw 1000,1000,1000,1000,1000,1000,1000,1000,1540,1540,1540,1540,1540,1540,1540,1540
		dw 1000,1000,1000,1000,1000,1000,1000,1000,1540,1540,1540,1540,1540,1540,1540,1540
		dw 1000,1000,1000,1000,1000,1000,1000,1000,1540,1540,1540,1540,1540,1540,1540,1540
		dw 1000,1000,1000,1000,1000,1000,1000,1000,1540,1540,1540,1540,1540,1540,1540,1540
		dw 1000,1000,1000,1000,1000,1000,1000,1000,1540,1540,1540,1540,1540,1540,1540,1540
		dw 1000,1000,1000,1000,1000,1000,1000,1000,1540,1540,1540,1540,1540,1540,1540,1540
		dw 1000,1000,1000,1000,1000,1000,1000,1000,1540,1540,1540,1540,1540,1540,1540,1540
		dw 1000,1000,1000,1000,1000,1000,1000,1000,1540,1540,1540,1540,1540,1540,1540,1540
		dw 0000,0204,0304,0383,0020,0214,030c,0387,0040,0224,0314,038b,0060,0234,031c,038f
		dw 0080,0244,0324,0393,00a0,0254,032c,0397,00c0,0264,0334,039b,00e0,0274,033c,039f
		dw 0100,0284,0344,03a3,0120,0294,034c,03a7,0140,02a4,0354,03ab,0160,02b4,035c,03af
		dw 0180,02c4,0364,03b3,01a0,02d4,036c,03b7,01c0,02e4,0374,03bb,01e0,02f4,037c,03bf
		dw 0200,0304,0384,03c3,0220,0314,038c,03c7,0240,0324,0394,03cb,0260,0334,039c,03cf
		dw 0280,0344,03a4,03d3,02a0,0354,03ac,03d7,02c0,0364,03b4,03db,02e0,0374,03bc,03df
		dw 0300,0384,03c4,03e3,0320,0394,03cc,03e7,0340,03a4,03d4,03eb,0360,03b4,03dc,03ef
		dw 0380,03c4,03e4,03f3,03a0,03d4,03ec,03f7,03c0,03e4,03f4,03fb,03e0,03f4,03fc,03ff
		dw 0800,0285,07e0,028f,07c0,0299,07a0,02a3,0780,02ad,0760,02b7,0740,02c1,0720,02cb
		dw 0700,02d5,06e0,02df,06c0,02e9,06a0,02f3,0680,02fd,0660,0307,0640,0311,0620,031b
		dw 0600,0320,05e0,0320,05c0,0320,05a0,0320,0580,0320,0560,0320,0540,0320,0520,0320
		dw 0500,0320,04e0,0320,04c0,0320,04a0,0320,0480,0320,0460,0320,0440,0320,0420,0320
		dw 0400,0320,03e0,0320,03c0,0320,03a0,0320,0380,0320,0360,0320,0340,0320,0320,0320
		dw 0300,0320,02e0,0320,02c0,0320,02a0,0320,0280,0320,0260,0320,0240,0320,0220,0320
		dw 0200,0320,01e0,0320,01c0,0320,01a0,0320,0180,0320,0160,0320,0140,0320,0120,0320
		dw 0100,0320,00e0,0320,00c0,0320,00a0,0320,0080,0320,0060,0320,0040,0320,0020,0320
		dw 0000,0285,0020,028f,0040,0299,0060,02a3,0080,02ad,00a0,02b7,00c0,02c1,00e0,02cb
		dw 0100,02d5,0120,02df,0140,02e9,0160,02f3,0180,02fd,01a0,0307,01c0,0311,01e0,031b
		dw 0200,0320,0220,0320,0240,0320,0260,0320,0280,0320,02a0,0320,02c0,0320,02e0,0320
		dw 0300,0320,0320,0320,0340,0320,0360,0320,0380,0320,03a0,0320,03c0,0320,03e0,0320
		dw 0400,0320,0420,0320,0440,0320,0460,0320,0480,0320,04a0,0320,04c0,0320,04e0,0320
		dw 0500,0320,0520,0320,0540,0320,0560,0320,0580,0320,05a0,0320,05c0,0320,05e0,0320
		dw 0600,0320,0620,0320,0640,0320,0660,0320,0680,0320,06a0,0320,06c0,0320,06e0,0320
		dw 0700,0320,0720,0320,0740,0320,0760,0320,0780,0320,07a0,0320,07c0,0320,07e0,0320
		dw 0328,0338,0347,0328,0325,0326,032f,0334,0323,0334,0332,0330,0327,0324,033c,0334
		dw 0341,0325,0329,0323,0320,0340,0339,032b,0347,0336,0338,033f,0320,033e,0335,0330
		dw 0337,0325,0322,0340,0341,0346,032c,0321,0335,0335,032c,0336,0322,032e,0346,0339
		dw 0329,0323,0340,0344,0325,0325,0347,0323,0322,033a,033d,0341,0333,0327,033e,033a
		dw 0337,0340,033c,0331,032d,0326,032f,033b,032e,0339,0332,0323,0323,032e,0333,033f
		dw 033f,0321,0333,032b,0337,0346,032e,0324,0330,032d,033b,0327,0340,032c,0326,0322
		dw 0339,0341,0325,033c,032a,0327,0338,0330,0346,0338,0326,0330,0342,0335,033d,0337
		dw 033a,0322,0320,032f,0334,033c,032f,032c,0331,033f,033a,0338,0328,032b,0346,0321
		dw 0325,0534,047a,0396,0552,035a,04d6,04ca,0452,0348,04e4,044f,03c4,0343,0337,049f
		dw 04a1,047d,036a,03ed,04b7,0378,049b,0462,0487,0499,038d,03a6,0331,0324,03a0,0415
		dw 03c4,040a,0438,03be,03b1,0402,0383,0356,0392,039a,037b,035e,03c5,0322,034e,0383
		dw 037e,0392,0354,033b,038b,0383,0372,032a,033f,032b,0350,0324,0326,0338,0328,0320
		dw 0320,0321,032d,0321,0323,0326,0353,0352,0325,0374,036d,036d,037d,0359,0391,0381
		dw 0339,0399,0337,0349,03ca,03dc,035e,03e9,033d,0395,03be,03ab,0342,0351,037f,043a
		dw 03f0,0352,0378,037d,0464,0331,045e,0379,0497,03bc,0369,03e5,04ac,0463,03d0,0429
		dw 0365,034a,04c8,032a,0471,0505,0537,040c,043e,0490,0406,03f0,04d0,03a0,04b7,0352
		dw 0320,0322,0322,0322,0328,0326,0323,0325,032d,0322,0325,032e,0338,032d,0334,032c
		dw 0325,0325,0328,0337,0330,0323,032a,034c,0342,0339,0341,0340,0344,0331,0357,032e
		dw 035a,0326,0363,035d,0331,0328,0351,035c,032c,032b,0320,032f,032a,0368,0322,037a
		dw 035c,0348,033a,0333,036d,034f,037b,0353,036a,0360,035b,036f,0380,0347,032e,0366
		dw 039f,0325,036f,0367,0335,0321,035e,0358,035e,0374,0394,035f,032e,037d,0333,039e
		dw 035a,0385,0382,0346,0321,03a4,0329,0383,0396,0369,032f,03a5,03ca,036c,03da,03be
		dw 03c6,0332,034e,0352,03e3,0385,0366,032b,03b7,03a2,03dc,0375,0341,035e,03e1,0369
		dw 039a,03c6,039a,03e9,0356,03af,037b,0356,03bc,03d2,03bc,03e9,037a,03b5,03be,03ac
		dw 0000,0400,0400,0400,01f0,0400,0400,0400,03c0,0400,0400,0400,0570,0400,0400,0400
		dw 0700,0400,0400,0400,0870,0400,0400,0400,09c0,0400,0400,0400,0af0,0400,0400,0400
		dw 0c00,0400,0400,0400,0cf0,0400,0400,0400,0dc0,0400,0400,0400,0e70,0400,0400,0400
		dw 0f00,0400,0400,0400,0f70,0400,0400,0400,0fc0,0400,0400,0400,0ff0,0400,0400,0400
		dw 1000,0400,0400,0400,0ff0,0400,0400,0400,0fc0,0400,0400,0400,0f70,0400,0400,0400
		dw 0f00,0400,0400,0400,0e70,0400,0400,0400,0dc0,0400,0400,0400,0cf0,0400,0400,0400
		dw 0c00,0400,0400,0400,0af0,0400,0400,0400,09c0,0400,0400,0400,0870,0400,0400,0400
		dw 0700,0400,0400,0400,0570,0400,0400,0400,03c0,0400,0400,0400,01f0,0400,0400,0400
		dw 0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640
		dw ffff,0640,0640,0640,0640,0640,0640,0640,ffff,0640,0640,0640,0640,0640,0640,0640
		dw ffff,ffff,0640,0640,0640,0640,0640,0640,ffff,ffff,0640,0640,0640,0640,0640,0640
		dw ffff,ffff,ffff,0640,0640,0640,0640,0640,ffff,ffff,ffff,0640,0640,0640,0640,0640
		dw ffff,ffff,ffff,ffff,0640,0640,0640,0640,ffff,ffff,ffff,ffff,0640,0640,0640,0640
		dw ffff,ffff,ffff,ffff,ffff,0640,0640,0640,ffff,ffff,ffff,ffff,ffff,0640,0640,0640
		dw ffff,ffff,ffff,ffff,ffff,ffff,0640,0640,ffff,ffff,ffff,ffff,ffff,ffff,0640,0640
		dw ffff,ffff,ffff,ffff,ffff,ffff,ffff,0640,ffff,ffff,ffff,ffff,ffff,ffff,ffff,0640
		dw 0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640
		dw 0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640
		dw 0640,063e,0644,063a,0648,0636,064c,0632,0650,062e,0654,062a,0658,0626,065c,0622
		dw 0660,061e,0664,061a,0668,0616,066c,0612,0670,060e,0674,060a,0678,0606,067c,0602
		dw 0680,05fe,0684,05fa,0688,05f6,068c,05f2,0690,05ee,0694,05ea,0698,05e6,069c,05e2
		dw 06a0,05de,06a4,05da,06a8,05d6,06ac,05d2,06b0,05ce,06b4,05ca,06b8,05c6,06bc,05c2
		dw 06c0,05be,06c4,05ba,06c8,05b6,06cc,05b2,06d0,05ae,06d4,05aa,06d8,05a6,06dc,05a2
		dw 06e0,059e,06e4,059a,06e8,0596,06ec,0592,06f0,058e,06f4,058a,06f8,0586,06fc,0582
		dw 0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640,0640
		dw ffff,0640,0640,0640,0640,0640,0640,0640,ffff,0640,0640,0640,0640,0640,0640,0640
		dw ffff,ffff,0640,0640,0640,0640,0640,0640,ffff,ffff,0640,0640,0640,0640,0640,0640
		dw ffff,ffff,ffff,0640,0640,0640,0640,0640,ffff,ffff,ffff,0640,0640,0640,0640,0640
		dw ffff,ffff,ffff,ffff,0640,0640,0640,0640,ffff,ffff,ffff,ffff,0640,0640,0640,0640
		dw ffff,ffff,ffff,ffff,ffff,0640,0640,0640,ffff,ffff,ffff,ffff,ffff,0640,0640,0640
		dw ffff,ffff,ffff,ffff,ffff,ffff,0640,0640,ffff,ffff,ffff,ffff,ffff,ffff,0640,0640
		dw ffff,ffff,ffff,ffff,ffff,ffff,ffff,0640,ffff,ffff,ffff,ffff,ffff,ffff,ffff,0640
		dw 0147,011d,0144,010e,0107,015a,00fe,011f,011f,012f,0129,013a,00fb,013b,014a,0111
		dw 0108,011c,012b,013b,0158,0147,010b,0152,0123,0137,0148,0147,0142,0110,0106,0155
		dw 0136,015d,0141,011b,0157,0105,0145,011e,0144,00fe,013d,0151,0105,0153,0115,0112
		dw 0128,0108,0121,0121,0151,012b,012a,0124,015d,0105,0147,014e,010c,0100,0150,0138
		dw 0125,0103,012d,0149,0133,0100,00fa,0114,00fd,0105,0125,012f,012e,014e,0140,0145
		dw 0139,012e,0101,0124,0116,0117,010f,0131,0137,0142,013a,012d,0115,0127,0116,015d
		dw 0133,011a,0107,0104,011f,0120,013d,0116,0129,0144,012e,013c,0135,0154,0143,011e
		dw 0118,0151,012c,013d,011c,010c,0136,00fa,0120,00fc,0137,00fe,0119,0101,0134,0138
		dw 0640,063f,063a,0639,0640,0640,0643,0648,0642,0642,063b,0634,062d,062d,0634,0635
		dw 0637,0638,0637,063b,0642,0646,0642,0642,0640,0646,0645,063f,0637,0637,063a,0641
		dw 0640,0638,0633,063b,0636,063b,0636,0637,0632,063a,063e,0646,0647,0641,063f,063e
		dw 0641,063f,0644,063e,0638,0630,0634,0634,0631,0633,062d,062f,0629,0630,0638,0640
		dw 063f,0641,063a,0632,0639,063c,0644,0646,064c,0650,0648,064f,0655,0659,065f,0664
		dw 065e,065f,0658,0651,064d,0651,0652,0657,065a,0658,0658,0656,0658,0651,064a,064b
		dw 0649,0649,064b,0648,0643,064a,0647,064a,0643,063f,0643,063b,0639,0632,0634,063b
		dw 0643,063c,0642,063b,0643,0644,0640,0646,0644,063e,063c,063e,0637,063d,0644,063f
		dw 031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f
		dw 031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f
		dw 031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f
		dw 031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f
		dw 031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f
		dw 031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f
		dw 031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f
		dw 031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f,031f,063f
		dw 0800,0800,0800,0800,07fe,07ff,0804,0803,07f8,07fb,080c,0807,07ee,07f6,0818,080e
		dw 07e0,07ee,0828,0816,07ce,07e5,083c,0821,07b8,07d9,0854,082d,079e,07cc,0870,083c
		dw 0780,07bc,0890,084c,075e,07ab,08b4,085f,0738,0797,08dc,0873,070e,0782,0908,088a
		dw 06e0,076a,0938,08a2,06ae,0751,096c,08bd,0678,0735,09a4,08d9,063e,0718,09e0,08f8
		dw 0600,06f8,0a20,0918,05be,06d7,0a64,093b,0578,06b3,0aac,095f,052e,068e,0af8,0986
		dw 04e0,0666,0b48,09ae,048e,063d,0b9c,09d9,0438,0611,0bf4,0a05,03de,05e4,0c50,0a34
		dw 0380,05b4,0cb0,0a64,031e,0583,0d14,0a97,02b8,054f,0d7c,0acb,024e,051a,0de8,0b02
		dw 01e0,04e2,0e58,0b3a,016e,04a9,0ecc,0b75,00f8,046d,0f44,0bb1,007e,0430,0fc0,0bf0
		dw 0400,0010,0410,0030,0420,0050,0430,0070,0440,0090,0450,00b0,0460,00d0,0470,00f0
		dw 0480,0110,0490,0130,04a0,0150,04b0,0170,04c0,0190,04d0,01b0,04e0,01d0,04f0,01f0
		dw 0500,0210,0510,0230,0520,0250,0530,0270,0540,0290,0550,02b0,0560,02d0,0570,02f0
		dw 0580,0310,0590,0330,05a0,0350,05b0,0370,05c0,0390,05d0,03b0,05e0,03d0,05f0,03f0
		dw 0600,0410,0610,0430,0620,0450,0630,0470,0640,0490,0650,04b0,0660,04d0,0670,04f0
		dw 0680,0510,0690,0530,06a0,0550,06b0,0570,06c0,0590,06d0,05b0,06e0,05d0,06f0,05f0
		dw 0700,0610,0710,0630,0720,0650,0730,0670,0740,0690,0750,06b0,0760,06d0,0770,06f0
		dw 0780,0710,0790,0730,07a0,0750,07b0,0770,07c0,0790,07d0,07b0,07e0,07d0,07f0,07f0
		dw 0000,0001,0080,0009,0100,0019,0180,0031,0200,0051,0280,0079,0300,00a9,0380,00e1
		dw 0400,0121,0480,0169,0500,01b9,0580,0211,0600,0271,0680,02d9,0700,0349,0780,03c1
		dw 0800,0441,0880,04c9,0900,0559,0980,05f1,0a00,0691,0a80,0739,0b00,07e9,0b80,08a1
		dw 0c00,0961,0c80,0a29,0d00,0af9,0d80,0bd1,0e00,0cb1,0e80,0d99,0f00,0e89,0f80,0f81
		dw 1000,1081,1080,1189,1100,1299,1180,13b1,1200,14d1,1280,15f9,1300,1729,1380,1861
		dw 1400,19a1,1480,1ae9,1500,1c39,1580,1d91,1600,1ef1,1680,2059,1700,21c9,1780,2341
		dw 1800,24c1,1880,2649,1900,27d9,1980,2971,1a00,2b11,1a80,2cb9,1b00,2e69,1b80,3021
		dw 1c00,31e1,1c80,33a9,1d00,3579,1d80,3751,1e00,3931,1e80,3b19,1f00,3d09,1f80,3f01
		dw 0000,0001,0080,0009,0100,0019,0180,0031,0200,0051,0280,0079,0300,00a9,0380,00e1
		dw 0400,0121,0480,0169,0500,01b9,0580,0211,0600,0271,0680,02d9,0700,0349,0780,03c1
		dw 0800,0441,0880,04c9,0900,0559,0980,05f1,0a00,0691,0a80,0739,0b00,07e9,0b80,08a1
		dw 0c00,0961,0c80,0a29,0d00,0af9,0d80,0bd1,0e00,0cb1,0e80,0d99,0f00,0e89,0f80,0f81
		dw 1000,1081,1080,1189,1100,1299,1180,13b1,1200,14d1,1280,15f9,1300,1729,1380,1861
		dw 1400,19a1,1480,1ae9,1500,1c39,1580,1d91,1600,1ef1,1680,2059,1700,21c9,1780,2341
		dw 1800,24c1,1880,2649,1900,27d9,1980,2971,1a00,2b11,1a80,2cb9,1b00,2e69,1b80,3021
		dw 1c00,31e1,1c80,33a9,1d00,3579,1d80,3751,1e00,3931,1e80,3b19,1f00,3d09,1f80,3f01
		dw 0800,0800,0800,0800,07fe,07ff,0804,0803,07f8,07fb,080c,0807,07ee,07f6,0818,080e
		dw 07e0,07ee,0828,0816,07ce,07e5,083c,0821,07b8,07d9,0854,082d,079e,07cc,0870,083c
		dw 0780,07bc,0890,084c,075e,07ab,08b4,085f,0738,0797,08dc,0873,070e,0782,0908,088a
		dw 06e0,076a,0938,08a2,06ae,0751,096c,08bd,0678,0735,09a4,08d9,063e,0718,09e0,08f8
		dw 0600,06f8,0a20,0918,05be,06d7,0a64,093b,0578,06b3,0aac,095f,052e,068e,0af8,0986
		dw 04e0,0666,0b48,09ae,048e,063d,0b9c,09d9,0438,0611,0bf4,0a05,03de,05e4,0c50,0a34
		dw 0380,05b4,0cb0,0a64,031e,0583,0d14,0a97,02b8,054f,0d7c,0acb,024e,051a,0de8,0b02
		dw 01e0,04e2,0e58,0b3a,016e,04a9,0ecc,0b75,00f8,046d,0f44,0bb1,007e,0430,0fc0,0bf0
		dw 0800,0800,0800,0800,07fe,07ff,0804,0803,07f8,07fb,080c,0807,07ee,07f6,0818,080e
		dw 07e0,07ee,0828,0816,07ce,07e5,083c,0821,07b8,07d9,0854,082d,079e,07cc,0870,083c
		dw 0780,07bc,0890,084c,075e,07ab,08b4,085f,0738,0797,08dc,0873,070e,0782,0908,088a
		dw 06e0,076a,0938,08a2,06ae,0751,096c,08bd,0678,0735,09a4,08d9,063e,0718,09e0,08f8
		dw 0600,06f8,0a20,0918,05be,06d7,0a64,093b,0578,06b3,0aac,095f,052e,068e,0af8,0986
		dw 04e0,0666,0b48,09ae,048e,063d,0b9c,09d9,0438,0611,0bf4,0a05,03de,05e4,0c50,0a34
		dw 0380,05b4,0cb0,0a64,031e,0583,0d14,0a97,02b8,054f,0d7c,0acb,024e,051a,0de8,0b02
		dw 01e0,04e2,0e58,0b3a,016e,04a9,0ecc,0b75,00f8,046d,0f44,0bb1,007e,0430,0fc0,0bf0
		dw 0000,0000,0002,0000,0003,0002,0004,0000,0005,0008,0002,0008,0007,0004,0008,0000
		dw 0008,000e,000f,0008,000b,0002,0001,0008,0017,0014,0017,0004,0012,0008,0002,0000
		dw 0002,0008,0012,0020,000d,0022,0014,0008,0027,0020,001b,0018,0017,0018,001b,0020
		dw 0027,0030,0008,0014,0022,0032,000d,0020,0035,0012,002a,0008,0023,0002,0020,0000
		dw 0021,0002,0026,0008,002f,0012,003c,0020,0004,0032,0017,0048,002e,0014,0049,0030
		dw 0017,0050,0038,0020,0008,0046,002f,0018,0001,0044,002e,0018,0002,004a,0035,0020
		dw 000b,0058,0044,0030,001c,0008,005b,0048,0035,0022,000f,0068,0056,0044,0032,0020
		dw 000e,006e,005d,004c,003b,002a,0019,0008,0070,0060,0050,0040,0030,0020,0010,0000
Y24dce5f6:	;; 30bb2806 ;; 30ad28e6 ;; 24dce5f6
		dw 0004,0008,0004,0002,0001,0004,0004,0004,000c,0002,0010,0010,0006,0002,0010,0010
		dw 0010,0010,0004,0004,0004,0001,0001,0001,0001,0001,0004,0004,0006,0002,0001,0001
		dw 0001,0004,0004,0002,0001,0001,0001,0001
