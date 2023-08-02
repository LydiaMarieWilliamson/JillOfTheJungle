Segment 0040 ;; DOS Segment.
Y00400000:
Y0040001a: word	;; 0040001a	;; Handler queue head.
Y0040001c: word ;; 0040001c	;; Handler queue tail.
Y00400063: word	;; 00400063	;; Port number.
Y0040006c: word	;; 0040006c	;; Clock.

;; CS:IP = 0000:0000, SS:SP = 295a:00e6
;; Relocated to 076a under Linux; previously to 140c under Windows.

;; === Top-Level Runtime System ===
Segment 076a ;; C0L:C0L
X076a0000:
   mov DX,segment A24f10000
   mov [CS:offset Y076a01c7],DX
   mov AH,30
   int 21
   mov BP,[0002]
   mov BX,[002C]
   mov DS,DX
   mov [007D],AX
   mov [007B],ES
   mov [0077],BX
   mov [0091],BP
   mov word ptr [0081],FFFF
   call near B076a012f
   les DI,[0075]
   mov AX,DI
   mov BX,AX
   mov CX,7FFF
L076a0039:
   cmp word ptr [ES:DI],3738
   jnz L076a0059
   mov DX,[ES:DI+02]
   cmp DL,3D
   jnz L076a0059
   and DH,DF
   inc word ptr [0081]
   cmp DH,59
   jnz L076a0059
   inc word ptr [0081]
L076a0059:
   repnz scasb
   jcxz L076a0099
   inc BX
   cmp [ES:DI],AL
   jnz L076a0039
   or CH,80
   neg CX
   mov [0075],CX
   mov CX,0002
   shl BX,CL
   add BX,+10
   and BX,-10
   mov [0079],BX
   mov DX,SS
   sub BP,DX
   mov DI,[13A2]
   cmp DI,0200
   jnb L076a0090
   mov DI,0200
   mov [13A2],DI
L076a0090:
   mov CL,04
   shr DI,CL
   inc DI
   cmp BP,DI
   jnb L076a009c
L076a0099:
jmp near A076a01af
L076a009c:
   mov BX,DI
   add BX,DX
   mov [0089],BX
   mov [008D],BX
   mov AX,[007B]
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
   mov ES,[CS:offset Y076a01c7]
   mov DI,28FA
   mov CX,BD2E
   sub CX,DI
   repz stosb
   push CS
   call near [28E4]
   call far A076a01d2
   call far A076a02d0
   mov AH,00
   int 1A
   mov [0083],DX
   mov [0085],CX
   push CS
   call near [28E8]
   push [0073]
   push [0071]
   push [006F]
   push [006D]
   push [006B]
   call far A1a4031a3
   push AX
   call far A22d10008

A076a010d:
   mov DS,[CS:offset Y076a01c7]
   call far A076a0172
   push CS
   call near [28E6]
   mov BP,SP
   mov AH,4C
   mov AL,[BP+04]
   int 21

B076a0125:
   mov CX,000E
   nop
   mov DX,002F
jmp near B076a01b6

B076a012f:
   push DS
   mov AX,3500
   int 21
   mov [005B],BX
   mov [005D],ES
   mov AX,3504
   int 21
   mov [005F],BX
   mov [0061],ES
   mov AX,3505
   int 21
   mov [0063],BX
   mov [0065],ES
   mov AX,3506
   int 21
   mov [0067],BX
   mov [0069],ES
   mov AX,2500
   mov DX,CS
   mov DS,DX
   mov DX,0125
   int 21
   pop DS
ret near

A076a0172:
   push DS
   mov AX,2500
   lds DX,[005B]
   int 21
   pop DS
   push DS
   mov AX,2504
   lds DX,[005F]
   int 21
   pop DS
   push DS
   mov AX,2505
   lds DX,[0063]
   int 21
   pop DS
   push DS
   mov AX,2506
   lds DX,[0067]
   int 21
   pop DS
ret far

A076a019f:
   mov word ptr [0081],0000
ret far

X076a01a6:
ret far

B076a01a7:
   mov AH,40
   mov BX,0002
   int 21
ret near

A076a01af:
   mov CX,001E
   nop
   mov DX,003D

B076a01b6:
   mov DS,[CS:offset Y076a01c7]
   call near B076a01a7
   mov AX,0003
   push AX
   call far A076a010d

Y076a01c7:	word
Y076a01c9:	byte
Y076a01ca:	dword
Y076a01ce:	dword

A076a01d2:
   pop [CS:offset Y076a01ca]
   pop [CS:offset Y076a01ca+2]
   mov [CS:offset Y076a01ce],DS
   cld
   mov ES,[007B]
   mov SI,0080
   xor AH,AH
   ES:lodsb
   inc AX
   mov BP,ES
   xchg DX,SI
   xchg BX,AX
   mov SI,[0075]
   add SI,+02
   mov CX,0001
   cmp byte ptr [007D],03
   jb L076a0215
   mov ES,[0077]
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
jmp far A076a01af
L076a028d:
   pop CX
   add CX,DX
   mov DS,[CS:offset Y076a01ce]
   mov [006B],BX
   inc BX
   add BX,BX
   add BX,BX
   mov SI,SP
   mov BP,SP
   sub BP,BX
   jb L076a0288
   mov SP,BP
   mov [006D],BP
   mov [006F],SS
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

A076a02d0:
   mov ES,[0077]
   xor DI,DI
   push ES
   push [0079]
   call far A22d7000a
   add SP,+02
   mov BX,AX
   pop ES
   mov [0071],AX
   mov [0073],DX
   push DS
   mov DS,DX
   or AX,DX
   jnz L076a02f9
jmp far A076a01af
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

A076a0314:
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

X076a0341:
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

A076a036f:
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

A076a0390:
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
   mov DX,281E
jmp near L076a03b1

A076a03ae:
   mov DX,2823
L076a03b1:
   mov CX,0005
   nop
   mov AH,40
   mov BX,0002
   int 21
   mov CX,0027
   nop
   mov DX,2828
   mov AH,40
   int 21
jmp far A076a01af

A076a03cc:
jmp far [28EA]

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
   call far A076a0414
   mov AL,DL
   inc AL
   mov AH,00
jmp near L076a0413
L076a0413:
ret near

A076a0414:
   push SI
   push DI
   mov [BD2C],BP
   int 10
   mov BP,[BD2C]
   pop DI
   pop SI
ret far

A076a0423:
   mov AH,0F
   push CS
   call near offset A076a0414
   push AX
   call far A076a0444
   pop CX
   mov AH,08
   mov BH,00
   push CS
   call near offset A076a0414
   and AH,7F
   mov [28CD],AH
   mov [28CC],AH
ret far

A076a0444:
   push BP
   mov BP,SP
   mov AL,[BP+06]
   cmp AL,03
   jbe L076a0454
   cmp AL,07
   jz L076a0454
   mov AL,03
L076a0454:
   mov [28CE],AL
   mov AH,0F
   push CS
   call near offset A076a0414
   cmp AL,[28CE]
   jz L076a0475
   mov AL,[28CE]
   mov AH,00
   push CS
   call near offset A076a0414
   mov AH,0F
   push CS
   call near offset A076a0414
   mov [28CE],AL
L076a0475:
   mov [28D0],AH
   cmp byte ptr [28CE],03
   jbe L076a048c
   cmp byte ptr [28CE],07
   jz L076a048c
   mov AX,0001
jmp near L076a048e
L076a048c:
   xor AX,AX
L076a048e:
   mov [28D1],AL
   mov byte ptr [28CF],19
   cmp byte ptr [28CE],07
   jz L076a04bd
   mov DX,F000
   mov AX,FFEA
   push DX
   push AX
   push DS
   mov AX,28D9
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
   mov [28D2],AL
   cmp byte ptr [28CE],07
   jnz L076a04ce
   mov AX,B000
jmp near L076a04d1
L076a04ce:
   mov AX,B800
L076a04d1:
   mov [28D5],AX
   mov word ptr [28D3],0000
   mov AL,00
   mov [28C9],AL
   mov [28C8],AL
   mov AL,[28D0]
   add AL,FF
   mov [28CA],AL
   mov byte ptr [28CB],18
   pop BP
ret far

X076a04f1:
ret far

A076a04f2:
   xor CX,CX
jmp near L076a0503
X076a04f6:
   mov CX,0001
jmp near L076a0503
X076a04fb:
   mov CX,0002
jmp near L076a0503
X076a0500:
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

A076a0595:
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

A076a05c5:
   mov AX,CS
   mov DS,AX
   mov DX,offset Y076a05b3
   mov AH,09
   int 21
jmp far A076a010d

A076a05d5:
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

A076a05fa:
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
A07cb0006:
   push BP
   mov BP,SP
   sub SP,+0A
   mov AX,1000
   push AX
   call far A22d7000a
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
   call far A2339000c
   add SP,+06
   mov [BP-0A],AX
   cmp word ptr [BP-0A],+00
   jl L07cb00a6
   xor AX,AX
   push AX
   push [BP+0C]
   push [BP+0A]
   call far A2429003d
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
   call far A23530002
   add SP,+08
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jle L07cb008e
   push [BP-02]
   push [BP-04]
   push [BP-06]
   push [BP-08]
   call far A236b0008
   add SP,+08
L07cb008e:
   cmp word ptr [BP-02],+00
   jg L07cb005c
   push [BP-08]
   call far A23440007
   pop CX
L07cb009d:
   push [BP-0A]
   call far A23440007
   pop CX
L07cb00a6:
   push [BP-04]
   push [BP-06]
   call far A23f70008
   pop CX
   pop CX
L07cb00b3:
   mov SP,BP
   pop BP
ret far

Segment 07d6 ;; SHM.C:SHM
A07d60007:
   push BP
   mov BP,SP
   sub SP,+02
   push [BP+08]
   push [BP+06]
   push DS
   mov AX,29FA
   push AX
   call far A238d0008
   add SP,+08
   mov word ptr [BP-02],0000
jmp near L07d60048
L07d60027:
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+2A4A],0000
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+2BCC],0000
   mov word ptr [BX+2BCA],0000
   inc word ptr [BP-02]
L07d60048:
   cmp word ptr [BP-02],+40
   jl L07d60027
   mov SP,BP
   pop BP
ret far

A07d60052:
   push BP
   mov BP,SP
   sub SP,+02
   mov AL,[34E9]
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
   mov [BX+28FA],AL
   inc word ptr [BP-02]
L07d60086:
   cmp word ptr [BP-02],0100
   jl L07d60077
jmp near L07d600c4
L07d6008f:
   mov AX,0100
   push AX
   push DS
   mov AX,0094
   push AX
   push DS
   mov AX,28FA
   push AX
   call far A23900001
   add SP,+0A
jmp near L07d600c4
L07d600a7:
   mov word ptr [BP-02],0000
jmp near L07d600bb
L07d600ae:
   mov AL,[BP-02]
   mov BX,[BP-02]
   mov [BX+28FA],AL
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
   mov [BX+28FA],AL
   inc word ptr [BP-02]
L07d600d8:
   cmp word ptr [BP-02],0100
   jl L07d600cb
   mov SP,BP
   pop BP
ret far

A07d600e3:
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
   call far A23900001
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-2E]
   push AX
   call far A23900001
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-28]
   push AX
   call far A23900001
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-26]
   push AX
   call far A23900001
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-24]
   push AX
   call far A23900001
   add SP,+0A
   add word ptr [BP+08],+02
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-2F]
   push AX
   call far A23900001
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0002
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-14]
   push AX
   call far A23900001
   add SP,+0A
   add word ptr [BP+08],+02
   cmp byte ptr [34E9],00
   jnz L07d601c8
   mov AX,[BP-28]
   add AX,0010
   mov [BP-22],AX
   mov word ptr [BP-0C],0003
   mov word ptr [BP-0A],0000
jmp near L07d60213
L07d601c8:
   cmp byte ptr [34E9],01
   jnz L07d601e4
   mov AX,[BP-28]
   add AX,0010
   mov [BP-22],AX
   mov word ptr [BP-0C],0003
   mov word ptr [BP-0A],0004
jmp near L07d60213
L07d601e4:
   cmp byte ptr [34E9],02
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
   mov [BX+28FA],AL
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
   call near offset A07d60052
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
   call far A23900001
   add SP,+0A
   add word ptr [BP+08],+04
   mov DX,[BP-2A]
   mov AX,[BP-2C]
   mov CL,[BP-0A]
   call far A076a0595
   and AL,[BP-0C]
   mov DL,[BP-1B]
   mov DH,00
   mov BX,DX
   mov [BX+28FA],AL
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
   call far A22d7000a
   pop CX
   mov [BP-06],DX
   mov [BP-08],AX
   mov AX,[BP-08]
   or AX,[BP-06]
   jnz L07d602c2
   mov AX,0009
   push AX
   call far A1a4034a1
   pop CX
L07d602c2:
   mov AX,[BP-22]
   mov BX,[BP+06]
   shl BX,1
   mov [BX+2B4A],AX
   mov DX,[BP-06]
   mov AX,[BP-08]
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   mov [BX+2BCC],DX
   mov [BX+2BCA],AX
   mov AX,[BP-14]
   mov BX,[BP+06]
   shl BX,1
   mov [BX+2ACA],AX
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
   call far A23900001
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-1D]
   push AX
   call far A23900001
   add SP,+0A
   inc word ptr [BP+08]
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push SS
   lea AX,[BP-1C]
   push AX
   call far A23900001
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
   call far A23900001
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
   cmp byte ptr [34E9],04
   jnz L07d603e0
   mov AX,0300
   push AX
   push [BP-10]
   push [BP-12]
   push DS
   mov AX,0194
   push AX
   call far A23960060
   add SP,+0A
   call far A087607dd
jmp near L07d603e0
L07d603e0:
   cmp byte ptr [34E9],00
   jz L07d603f1
   cmp byte ptr [34E9],01
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
   call far A23900001
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
   mov AL,[BX+28FA]
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
   cmp byte ptr [34E9],02
   jz L07d604dd
   cmp byte ptr [34E9],03
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
   call far A23900001
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
   mov AL,[BX+28FA]
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
   mov AL,[BX+28FA]
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
   mov AL,[BX+28FA]
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
   call far A23900001
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
   mov AL,[BX+28FA]
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
   mov AL,[BX+28FA]
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

A07d60779:
   push BP
   mov BP,SP
   sub SP,0508
   mov AX,1000
   push AX
   call far A22d7000a
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   mov AX,[BP-04]
   or AX,[BP-02]
   jnz L07d607a2
   mov AX,0009
   push AX
   call far A1a4034a1
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
   mov AX,29FA
   push AX
   call far A2339000c
   add SP,+06
   mov [BP-08],AX
   mov AX,0200
   push AX
   push SS
   lea AX,[BP+FAF8]
   push AX
   push [BP-08]
   call far A2346000d
   add SP,+08
   or AX,AX
   jnz L07d60801
   mov AX,0009
   push AX
   call far A1a4034a1
   pop CX
L07d60801:
   mov AX,0100
   push AX
   push SS
   lea AX,[BP+FEF8]
   push AX
   push [BP-08]
   call far A2346000d
   add SP,+08
   mov word ptr [BP-06],0000
jmp near L07d60929
L07d6081e:
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+2A4A],+00
   jnz L07d60867
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   mov AX,[BX+2BCA]
   or AX,[BX+2BCC]
   jz L07d60864
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   push [BX+2BCC]
   push [BX+2BCA]
   call far A23f70008
   pop CX
   pop CX
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   mov word ptr [BX+2BCC],0000
   mov word ptr [BX+2BCA],0000
L07d60864:
jmp near L07d60926
L07d60867:
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   mov AX,[BX+2BCA]
   or AX,[BX+2BCC]
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
   call far A23700004
   add SP,+08
   mov BX,[BP-06]
   shl BX,1
   lea AX,[BP+FEF8]
   add BX,AX
   push [SS:BX]
   call far A22d7000a
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
   call far A1a4034a1
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
   call far A2346000d
   add SP,+08
L07d60926:
   inc word ptr [BP-06]
L07d60929:
   cmp word ptr [BP-06],+40
   jge L07d60932
jmp near L07d6081e
L07d60932:
   push [BP-08]
   call far A23410006
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
   call near offset A07d600e3
   add SP,+0A
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   lea AX,[BP+FCF8]
   add BX,AX
   push [SS:BX+02]
   push [SS:BX]
   call far A23f70008
   pop CX
   pop CX
L07d60997:
   inc word ptr [BP-06]
L07d6099a:
   cmp word ptr [BP-06],+40
   jl L07d60942
   push [BP-02]
   push [BP-04]
   call far A23f70008
   pop CX
   pop CX
   mov SP,BP
   pop BP
ret far

A07d609b1:
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0000
jmp near L07d609fb
L07d609be:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+2BCA]
   or AX,[BX+2BCC]
   jz L07d609f8
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+2BCC]
   push [BX+2BCA]
   call far A23f70008
   pop CX
   pop CX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+2BCC],0000
   mov word ptr [BX+2BCA],0000
L07d609f8:
   inc word ptr [BP-02]
L07d609fb:
   cmp word ptr [BP-02],+40
   jl L07d609be
   mov SP,BP
   pop BP
ret far

Segment 0876 ;; GR.C:GR
A08760005:
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

A08760058:
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
   mov AX,[34E5]
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

A0876009c:
   push BP
   mov BP,SP
   mov AX,[34E5]
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

A087600de:
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
   mov AX,[BX+2ACA]
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
   mov AX,[BX+2BCA]
   or AX,[BX+2BCC]
   jnz L08760170
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+2A4A],0001
   call far A07d60779
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+2BCA]
   or AX,[BX+2BCC]
   jnz L08760170
   mov DX,[2CCC]
   mov AX,[2CCA]
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov [BX+2BCC],DX
   mov [BX+2BCA],AX
L08760170:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov DX,[BX+2BCC]
   mov AX,[BX+2BCA]
   cmp DX,[2CCC]
   jnz L0876018e
   cmp AX,[2CCA]
   jnz L0876018e
jmp near L087602c1
L0876018e:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   les BX,[BX+2BCA]
   mov AX,[BP-04]
   shl AX,1
   shl AX,1
   add BX,AX
   mov [BP-0E],ES
   mov [BP-10],BX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   les BX,[BX+2BCA]
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
   mul word ptr [34EE]
   add AX,[BP+0C]
   jge L08760227
jmp near L087602c1
L08760227:
   mov AL,[34E9]
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
   call far A09560003
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
   call far A09560271
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
   call far A09560558
   add SP,+12
jmp near L087602c1
L087602c1:
   mov SP,BP
   pop BP
ret far

X087602c5:
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
   mov AL,[34E9]
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
   call far A0a620081
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
   call far A0a6200a0
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
   call far A0a6200eb
   mov SP,BP
jmp near L08760379
L08760379:
   pop BP
ret far

X0876037b:
   push BP
   mov BP,SP
   mov AL,[34E9]
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
   call far A0a62014e
   mov SP,BP
jmp near L087603b2
L087603ae:
jmp near L087603b2
L087603b0:
jmp near L087603b2
L087603b2:
   pop BP
ret far

A087603b4:
   push BP
   mov BP,SP
L087603b7:
   mov DX,03DA
   in AL,DX
   test AL,08
   jz L087603b7
   pop BP
ret far

A087603c1:
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
   add BX,2CCE
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

A08760463:
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
   call near offset A087603c1
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
   call near offset A087603c1
   add SP,+12
L08760500:
   mov SP,BP
   pop BP
ret far

A08760504:
   push BP
   mov BP,SP
   mov word ptr [2ECE],0010
   mov AX,[BP+08]
   mov [2ED0],AX
   mov AX,[BP+06]
   mov [2ED2],AX
   cmp word ptr [BP+0A],-01
   jnz L08760527
   mov word ptr [2ED4],0010
jmp near L0876052d
L08760527:
   mov AX,[BP+0A]
   mov [2ED4],AX
L0876052d:
   pop BP
ret far

A0876052f:
   push BP
   mov BP,SP
   mov word ptr [2ECE],00FF
   mov AX,[BP+08]
   mov [2ED0],AX
   mov AX,[BP+06]
   mov [2ED2],AX
   cmp word ptr [BP+0A],-01
   jnz L08760552
   mov word ptr [2ED4],00FF
jmp near L08760558
L08760552:
   mov AX,[BP+0A]
   mov [2ED4],AX
L08760558:
   pop BP
ret far

A0876055a:
   push BP
   mov BP,SP
   mov AL,[34E9]
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
   call near offset A08760463
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
   call near offset A08760463
   mov SP,BP
L0876059f:
jmp near L087605c3
L087605a1:
   push [BP+0A]
   push [BP+06]
   push [BP+08]
   push CS
   call near offset A08760504
   mov SP,BP
jmp near L087605c3
L087605b2:
   push [BP+0A]
   push [BP+06]
   push [BP+08]
   push CS
   call near offset A0876052f
   mov SP,BP
jmp near L087605c3
L087605c3:
   pop BP
ret far

A087605c5:
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
   call near offset A087603c1
   add SP,+12
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   mov AX,0003
   push AX
   push CS
   call near offset A08760463
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
   call near offset A087603c1
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
   call near offset A087603c1
   add SP,+12
   pop BP
ret far

A08760654:
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0000
jmp near L08760687
L08760661:
   mov AX,[BP-02]
   mov BX,[BP-02]
   shl BX,1
   mov [BX+2CCE],AX
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+30CE],0000
   mov AX,[BP-02]
   mov BX,[BP-02]
   shl BX,1
   mov [BX+32CE],AX
   inc word ptr [BP-02]
L08760687:
   cmp word ptr [BP-02],+10
   jl L08760661
   mov word ptr [2CCE],0010
   mov word ptr [30CE],0010
   mov SP,BP
   pop BP
ret far

A0876069d:
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0000
jmp near L087606d0
L087606aa:
   mov AX,[BP-02]
   mov BX,[BP-02]
   shl BX,1
   mov [BX+2CCE],AX
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+30CE],0000
   mov AX,[BP-02]
   mov BX,[BP-02]
   shl BX,1
   mov [BX+32CE],AX
   inc word ptr [BP-02]
L087606d0:
   cmp word ptr [BP-02],0100
   jl L087606aa
   mov word ptr [2CCE],00FF
   mov word ptr [30CE],00FF
   mov SP,BP
   pop BP
ret far

A087606e7:
   push BP
   mov BP,SP
   mov AX,[34EA]
   mul word ptr [34E3]
   mov [34E7],AX
   mov AX,[34EC]
   mul word ptr [34E3]
   mov [34E5],AX
   pop BP
ret far

A08760700:
   push BP
   mov BP,SP
   cmp word ptr [BP+06],+00
   jz L0876072b
   test byte ptr [34E9],FE
   jz L0876072b
   mov word ptr [34E0],0001
   mov AX,0001
   sub AX,[34EA]
   mov [34EC],AX
   push CS
   call near offset A087606e7
   call far A09560e04
jmp near L0876073d
L0876072b:
   mov word ptr [34E0],0000
   mov AX,[34EA]
   mov [34EC],AX
   mov AX,[34E7]
   mov [34E5],AX
L0876073d:
   pop BP
ret far

A0876073f:
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

A08760751:
   push BP
   mov BP,SP
   sub SP,+02
   test byte ptr [34E9],FE
   jz L087607bb
   mov AX,[34EA]
   neg AX
   sbb AX,AX
   inc AX
   mov [34EA],AX
   mov AX,[34EC]
   neg AX
   sbb AX,AX
   inc AX
   mov [34EC],AX
   push CS
   call near offset A087606e7
   push CS
   call near offset A0876073f
   mov [BP-02],AX
L0876077f:
   mov DX,03DA
   in AL,DX
   test AL,08
   jnz L0876077f
   mov AX,[34E7]
   and AX,FF00
   add AX,000C
   push AX
   push [BP-02]
   call far A2492000c
   pop CX
   pop CX
   mov AX,[34E7]
   and AX,00FF
   mov CL,08
   shl AX,CL
   add AX,000D
   push AX
   push [BP-02]
   call far A2492000c
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

X087607bf:
   push BP
   mov BP,SP
   cmp byte ptr [34E9],04
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

A087607dd:
   push BP
   mov BP,SP
   sub SP,+06
   mov word ptr [BP-06],0000
   mov word ptr [BP-04],0100
   cmp byte ptr [34E9],04
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
   call near offset A087603b4
   mov AX,[BP-06]
   mov [BP-02],AX
jmp near L08760864
L0876081d:
   mov AL,[BP-02]
   mov DX,[0494]
   out DX,AL
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   mov BX,AX
   mov AL,[BX+0194]
   mov DX,[0498]
   out DX,AL
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   mov BX,AX
   inc BX
   mov AL,[BX+0194]
   mov DX,[0498]
   out DX,AL
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   mov BX,AX
   inc BX
   inc BX
   mov AL,[BX+0194]
   mov DX,[0498]
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

X08760873:
   push BP
   mov BP,SP
   sub SP,+06
   mov word ptr [BP-06],0000
   mov word ptr [BP-04],0100
   cmp byte ptr [34E9],04
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
   mov DX,[0496]
   out DX,AL
   mov DX,[0498]
   in AL,DX
   push AX
   mov AX,[BP-02]
   mov DX,0003
   mul DX
   les BX,[BP+06]
   add BX,AX
   pop AX
   mov [ES:BX],AL
   mov DX,[0498]
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
   mov DX,[0498]
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

A08760930:
   push BP
   mov BP,SP
   sub SP,+06
   mov word ptr [BP-04],0000
   mov word ptr [BP-02],0100
   cmp byte ptr [34E9],04
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
   mov DX,[0494]
   out DX,AL
   mov AL,00
   mov DX,[0498]
   out DX,AL
   mov AL,00
   mov DX,[0498]
   out DX,AL
   mov AL,00
   mov DX,[0498]
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

A087609ba:
   push BP
   mov BP,SP
   sub SP,0306
   cmp byte ptr [34E9],04
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
   mov AL,[BX+0194]
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
   call near offset A087603b4
   mov AL,00
   mov DX,[0494]
   out DX,AL
   mov word ptr [BP-04],0000
jmp near L08760a2d
L08760a1b:
   lea BX,[BP+FCFA]
   add BX,[BP-04]
   mov AL,[SS:BX]
   mov DX,[0498]
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

X08760a42:
   push BP
   mov BP,SP
   mov AL,[BP+06]
   mov DX,[0494]
   out DX,AL
   mov AL,[BP+08]
   mov DX,[0498]
   out DX,AL
   mov AL,[BP+0A]
   mov DX,[0498]
   out DX,AL
   mov AL,[BP+0C]
   mov DX,[0498]
   out DX,AL
   pop BP
ret far

A08760a67:
   push BP
   mov BP,SP
   sub SP,0306
   cmp byte ptr [34E9],04
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
   mov AL,[BX+0194]
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
   call near offset A087603b4
   mov AL,00
   mov DX,[0494]
   out DX,AL
   mov word ptr [BP-06],0000
jmp near L08760ada
L08760ac8:
   lea BX,[BP+FCFA]
   add BX,[BP-06]
   mov AL,[SS:BX]
   mov DX,[0498]
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

A08760aef:
   push BP
   mov BP,SP
   sub SP,+02
   push DS
   mov AX,049E
   push AX
   call far A24540006
   pop CX
   pop CX
L08760b01:
   call far A0a990065
   push AX
   call far A24d90000
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
		dw L08760b65,L08760b50,L08760b57,L08760b5e
L08760b50:
   mov byte ptr [34E9],00
jmp near L08760b69
L08760b57:
   mov byte ptr [34E9],02
jmp near L08760b69
L08760b5e:
   mov byte ptr [34E9],04
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

A08760b72:
   push BP
   mov BP,SP
   sub SP,+16
   mov word ptr [BP-14],0F00
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far A247d000b
   add SP,+06
   mov AX,[BP-14]
   and AX,00FF
   mov [34DE],AX
   mov word ptr [34E0],0000
   mov word ptr [34EA],0000
   mov word ptr [34EC],0000
   mov word ptr [34E7],0000
   mov word ptr [34E5],0000
   mov word ptr [34CE],0000
   mov word ptr [34D0],0000
   mov word ptr [34D2],0140
   mov word ptr [34D4],00C8
   mov word ptr [34D6],0000
   mov word ptr [34D8],0000
   mov AL,[34E9]
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
   call far A247d000b
   add SP,+06
   mov word ptr [BP-14],0B00
   mov word ptr [BP-12],0001
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far A247d000b
   add SP,+06
   mov AL,11
   mov DX,03D9
   out DX,AL
   push CS
   call near offset A087605c5
   mov byte ptr [34E9],00
   mov word ptr [34EE],0004
   mov AL,00
   push AX
   push DS
   mov AX,34CE
   push AX
   call far A09560eaa
   add SP,+06
jmp near L08760dca
L08760c4b:
   mov word ptr [34E3],2000
   mov byte ptr [34E9],02
   mov word ptr [BP-14],1200
   mov word ptr [BP-12],0031
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far A247d000b
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
   call far A247d000b
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
   call far A247d000b
   add SP,+06
   push CS
   call near offset A08760654
   xor AX,AX
   push AX
   mov AX,0009
   push AX
   mov AX,0001
   push AX
   push CS
   call near offset A08760504
   add SP,+06
   mov word ptr [34EE],0008
   mov AL,00
   push AX
   push DS
   mov AX,34CE
   push AX
   call far A09560eaa
   add SP,+06
jmp near L08760dca
L08760ce9:
   mov word ptr [34E3],4000
   mov byte ptr [34E9],04
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
   call far A247d000b
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
   call far A247d000b
   add SP,+06
   mov word ptr [BP-14],0013
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far A247d000b
   add SP,+06
   push CS
   call near offset A0876069d
   xor AX,AX
   push AX
   mov AX,0022
   push AX
   mov AX,002A
   push AX
   push CS
   call near offset A0876052f
   add SP,+06
   mov word ptr [34EE],0001
   push CS
   call near offset A08760930
   mov AX,0604
   push AX
   mov AX,03C4
   push AX
   call far A2492000c
   pop CX
   pop CX
   mov AX,4005
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   pop CX
   pop CX
   mov AX,0014
   push AX
   mov AX,03D4
   push AX
   call far A2492000c
   pop CX
   pop CX
   mov AX,E317
   push AX
   mov AX,03D4
   push AX
   call far A2492000c
   pop CX
   pop CX
   mov AL,00
   push AX
   push DS
   mov AX,34CE
   push AX
   call far A09560eaa
   add SP,+06
   push CS
   call near offset A087607dd
jmp near L08760dca
L08760dca:
   mov AX,0001
   push AX
   call far A22d7000a
   pop CX
   mov [2CCC],DX
   mov [2CCA],AX
   mov SP,BP
   pop BP
ret far

A08760ddf:
   push BP
   mov BP,SP
   sub SP,+14
   mov AX,[34DE]
   add AX,0000
   mov [BP-14],AX
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0010
   push AX
   call far A247d000b
   add SP,+06
   mov SP,BP
   pop BP
ret far

Segment 0956 ;; GAMEGRL.C:GRL
A09560003:
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
   call far A08760005
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
   call far A08760005
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
   mov BX,[BX+2CCE]
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

A09560271:
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
   call far A08760058
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
   call far A08760058
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
   call far A2492000c
   add SP,+04
   mov AX,0A05
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0F01
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0003
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0007
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
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
   mov CX,[BX+2CCE]
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

A09560558:
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
   call far A0876009c
   add SP,+0C
   mov AX,4005
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0001
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0003
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,FF08
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
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
   call far A0876009c
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
   call far A2492000c
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
   mov CX,[BX+2CCE]
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

X09560836:
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
   call far A0876009c
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
   call far A0876009c
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
   mov AL,[BX+2CCE]
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

A095609f9:
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
   mov AL,[34E9]
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
   call far A08760005
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
   call far A08760005
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
   call far A08760058
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
   call far A08760058
   add SP,+0C
   mov AX,[BP-08]
   mov DX,0028
   mul DX
   mov [BP-08],AX
   mov AX,0105
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0104
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
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
   call far A0876009c
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
   call far A0876009c
   add SP,+0C
   mov AX,4905
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far A2492000c
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
   call far A0876009c
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
   call far A0876009c
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

A09560e04:
   push SI
   push DI
   mov AL,[34E9]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jz L09560e23
   mov AL,[34E9]
   mov AH,00
   and AX,00FE
   cmp AX,0004
   jz L09560e23
jmp near L09560e7c
X09560e22:
   nop
L09560e23:
   mov AL,[34E9]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jnz L09560e42
   mov AX,0105
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
jmp near L09560e52
L09560e42:
   mov AX,4105
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
L09560e52:
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far A2492000c
   add SP,+04
   push ES
   push DS
   cld
   mov CX,[34E3]
   mov SI,[34E7]
   mov DI,[34E5]
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

A09560e7f:
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
   call near offset A095609f9
   mov SP,BP
   pop BP
ret far

A09560eaa:
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   mov AL,[34E9]
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
   call far A08760005
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
   call far A08760058
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
   call far A2492000c
   add SP,+04
   mov AX,0F01
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0003
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,FF08
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far A2492000c
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
   call far A0876009c
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
   call far A2492000c
   add SP,+04
   mov AX,0001
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,4005
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,FF08
   push AX
   mov AX,03CE
   push AX
   call far A2492000c
   add SP,+04
   mov AX,0F02
   push AX
   mov AX,03C4
   push AX
   call far A2492000c
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
   add BX,[34E5]
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
   add BX,[34E5]
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

A0a620081:
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

A0a6200a0:
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

A0a6200eb:
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

A0a62011a:
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
   mov [34E2],AL
ret far

A0a62014e:
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
   mov word ptr [BP-08],026E
   cmp BX,CX
   jle L0a6201a2
   mov word ptr [BP-08],02B7
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
   mov BX,02E4
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

X0a6202e8:
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
A0a990003:
   push BP
   mov BP,SP
   sub SP,+14
   cmp [13A2],SP
   ja L0a990014
   call far A076a05c5
L0a990014:
   mov word ptr [BP-14],0100
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0016
   push AX
   call far A247d000b
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

A0a990065:
   push BP
   mov BP,SP
   sub SP,+14
   cmp [13A2],SP
   ja L0a990076
   call far A076a05c5
L0a990076:
   mov word ptr [BP-14],0000
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0016
   push AX
   call far A247d000b
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

A0a9900b7:
   push BP
   mov BP,SP
   sub SP,+14
   cmp [13A2],SP
   ja L0a9900c8
   call far A076a05c5
L0a9900c8:
   mov word ptr [BP-14],0200
   push SS
   lea AX,[BP-14]
   push AX
   mov AX,0016
   push AX
   call far A247d000b
   add SP,+06
   mov AL,[BP-14]
   and AL,01
   mov [3703],AL
   mov AX,[BP-14]
   shr AX,1
   and AL,01
   mov [3704],AL
   mov AX,[BP-14]
   shr AX,1
   shr AX,1
   and AL,01
   mov [34FE],AL
   mov AX,[BP-14]
   shr AX,1
   shr AX,1
   shr AX,1
   and AL,01
   mov [34FF],AL
   mov AX,[BP-14]
   mov CL,05
   shr AX,CL
   and AL,01
   mov [3702],AL
   mov AL,[3703]
   or AL,[3704]
   mov [3701],AL
   mov SP,BP
   pop BP
ret far

A0a990124:
   push AX
   push BX
   push CX
   push DX
   push ES
   push DS
   push SI
   push DI
   push BP
   mov BP,segment A24f10000
   mov DS,BP
   cmp [13A2],SP
   ja L0a99013d
   call far A076a05c5
L0a99013d:
   cli
   xor AX,AX
   in AL,60
   cmp AL,E0
   jnz L0a99014f
   mov word ptr [34FC],0100
jmp near L0a990172
X0a99014e:
   nop
L0a99014f:
   test AL,80
   jnz L0a990163
   mov BX,AX
   mov word ptr [34FC],0000
   mov byte ptr [BX+3500],01
jmp near L0a990172
X0a990162:
   nop
L0a990163:
   and AL,7F
   mov BX,AX
   mov word ptr [34FC],0000
   mov byte ptr [BX+3500],00
L0a990172:
   cmp byte ptr [3700],01
   jnz L0a990181
   pushf
   call far [34F0]
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

A0a990191:
   push BP
   mov BP,SP
   cmp [13A2],SP
   ja L0a99019f
   call far A076a05c5
L0a99019f:
   mov word ptr [34F6],0040
   mov word ptr [34F4],001A
   mov word ptr [34FA],0040
   mov word ptr [34F8],001C
   xor AX,AX
   push AX
   mov AX,0200
   push AX
   push DS
   mov AX,3500
   push AX
   call far A2392002d
   mov SP,BP
   mov AX,0009
   push AX
   call far A246c0008
   mov SP,BP
   mov [34F2],DX
   mov [34F0],AX
   mov AL,[BP+06]
   mov [3700],AL
   push CS
   mov AX,offset A0a990124
   push AX
   mov AX,0009
   push AX
   call far A246c001a
   mov SP,BP
   pop BP
ret far

A0a9901f4:
   cmp [13A2],SP
   ja L0a9901ff
   call far A076a05c5
L0a9901ff:
   push [34F2]
   push [34F0]
   mov AX,0009
   push AX
   call far A246c001a
   add SP,+06
ret far

X0a990214:
   cmp [13A2],SP
   ja L0a99021f
   call far A076a05c5
L0a99021f:
   mov byte ptr [3700],00
ret far

X0a990225:
   cmp [13A2],SP
   ja L0a990230
   call far A076a05c5
L0a990230:
   les BX,[34F8]
   mov AX,[ES:BX]
   les BX,[34F4]
   mov [ES:BX],AX
   mov byte ptr [3700],01
ret far

X0a990244:
   cmp [13A2],SP
   ja L0a99024f
   call far A076a05c5
L0a99024f:
   cmp byte ptr [3700],00
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
A0abf0002:
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
   call far A0abf0ba8
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
   call far A0abf0ba8
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
   call far A0abf0ba8
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
   call far A0abf0ba8
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

A0abf0234:
   push BP
   mov BP,SP
   sub SP,+04
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far A0abf0bd2
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
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
   call far A087600de
   add SP,+0A
L0abf0770:
   mov SP,BP
   pop BP
ret far

A0abf0774:
   push BP
   mov BP,SP
   mov DX,[BP+08]
   mov AX,[BP+06]
   add AX,0018
   push DX
   push AX
   call far A0abf0bd2
   mov SP,BP
   pop BP
ret far

A0abf078b:
   push BP
   mov BP,SP
   sub SP,+04
   les BX,[BP+06]
   mov AX,[ES:BX+0C]
   cmp AX,[3706]
   jnz L0abf07ab
   les BX,[BP+06]
   mov AX,[ES:BX+0E]
   cmp AX,[370A]
   jz L0abf07c7
L0abf07ab:
   les BX,[BP+06]
   push [ES:BX+0E]
   les BX,[BP+06]
   push [ES:BX+0C]
   push [BP+08]
   push [BP+06]
   call far A0abf0bec
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
   call far A087600de
   add SP,+0A
   inc word ptr [BP-02]
L0abf082d:
   push [BP+12]
   push [BP+10]
   call far A2388000b
   pop CX
   pop CX
   cmp AX,[BP-02]
   ja L0abf07f6
L0abf083f:
   mov SP,BP
   pop BP
ret far

A0abf0843:
   push BP
   mov BP,SP
   sub SP,+04
   mov byte ptr [BP-03],00
jmp near L0abf0890
L0abf084f:
   les BX,[0C74]
   mov AX,[ES:BX]
   mov [BP-02],AX
L0abf0859:
   les BX,[0C74]
   mov AX,[ES:BX]
   cmp AX,[BP-02]
   jz L0abf0859
   mov AL,[370C]
   and AL,07
   inc AL
   mov [370C],AL
   mov AL,[370C]
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
   call near offset A0abf078b
   add SP,+0E
L0abf0890:
   call far A0a990003
   or AX,AX
   jz L0abf084f
   push DS
   mov AX,04BE
   push AX
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A0abf078b
   add SP,+0E
   call far A0a990065
jmp near L0abf08bb
L0abf08bb:
   mov SP,BP
   pop BP
ret far

A0abf08bf:
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
   call near offset A0abf078b
   add SP,+0E
   mov byte ptr [BP-03],00
L0abf090c:
   push [BP+0E]
   push [BP+0C]
   push [BP+12]
   push [BP+10]
   call far A2388000b
   pop CX
   pop CX
   mul word ptr [BP-08]
   add AX,[BP+0A]
   push AX
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A0abf0843
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
   call near offset A0abf078b
   add SP,+0E
   les BX,[BP+10]
   mov byte ptr [ES:BX],00
L0abf09a9:
   push [BP+12]
   push [BP+10]
   call far A2388000b
   pop CX
   pop CX
   cmp AX,[BP+14]
   jnb L0abf0a0a
   push [BP+12]
   push [BP+10]
   call far A2388000b
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
   call near offset A0abf078b
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
   call far A2388000b
   pop CX
   pop CX
   or AX,AX
   jbe L0abf0a41
   push [BP+12]
   push [BP+10]
   call far A2388000b
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

X0abf0a59:
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
   call far A2388000b
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
   call near offset A0abf078b
   add SP,+0E
   mov SP,BP
   pop BP
ret far

A0abf0aba:
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
   call far A2388000b
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
   call near offset A0abf078b
   mov SP,BP
   pop BP
ret far

A0abf0b0b:
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
   call far A2388000b
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
   call near offset A0abf078b
   mov SP,BP
   pop BP
ret far

A0abf0b56:
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
   call far A2388000b
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
   call near offset A0abf078b
   mov SP,BP
   pop BP
ret far

A0abf0ba8:
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

A0abf0bd2:
   push BP
   mov BP,SP
   les BX,[BP+06]
   mov AL,[ES:BX+0E]
   push AX
   push [BP+08]
   push [BP+06]
   call far A09560eaa
   mov SP,BP
   pop BP
ret far

A0abf0bec:
   push BP
   mov BP,SP
   sub SP,+02
   push [BP+0A]
   call far A2456000a
   pop CX
   neg AX
   mov [BP+0A],AX
   mov AL,[34E9]
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
   call far A2456000a
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
   call far A2456000a
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
   call far A0876055a
   add SP,+06
   mov AX,[BP+0A]
   les BX,[BP+06]
   mov [ES:BX+0C],AX
   mov AX,[BP+0C]
   les BX,[BP+06]
   mov [ES:BX+0E],AX
   mov AX,[BP+0A]
   mov [3706],AX
   mov AX,[BP+0C]
   mov [370A],AX
   mov SP,BP
   pop BP
ret far

Segment 0b8b ;; GAMECTRL.C:GAMECTRL
A0b8b000e:
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

A0b8b0024:
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

A0b8b003a:
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [04C2],0000
   mov word ptr [04C0],0000
   les BX,[0C74]
   mov AL,[ES:BX]
   cbw
   mov [BP-02],AX
L0b8b0057:
   les BX,[0C74]
   mov AL,[ES:BX]
   cbw
   cmp AX,[BP-02]
   jz L0b8b0057
L0b8b0064:
   add word ptr [04C0],+01
   adc word ptr [04C2],+00
   les BX,[0C74]
   mov AL,[ES:BX]
   cbw
   sub AX,[BP-02]
   cmp AX,0005
   jl L0b8b0064
   xor DX,DX
   mov AX,0004
   push DX
   push AX
   push [04C2]
   push [04C0]
   call far A076a04f2
   mov [04C2],DX
   mov [04C0],AX
   mov SP,BP
   pop BP
ret far

A0b8b009d:
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

A0b8b012f:
   push BP
   mov BP,SP
   sub SP,+04
   mov word ptr [BP-04],0000
   mov word ptr [BP-02],0000
   push [BP+08]
   push [BP+06]
   call far A24540006
   pop CX
   pop CX
L0b8b014c:
   push [BP+10]
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push CS
   call near offset A0b8b009d
   add SP,+08
   call far A0a990003
   or AX,AX
   jz L0b8b0170
   call far A0a990065
   mov [BP-02],AX
L0b8b0170:
   cmp word ptr [BP-02],+1B
   jz L0b8b017e
   push CS
   call near offset A0b8b000e
   or AX,AX
   jz L0b8b014c
L0b8b017e:
   mov AX,0019
   push AX
   call far A24610002
   pop CX
   cmp word ptr [BP-02],+1B
   jz L0b8b01b2
   mov word ptr [BP-04],0001
L0b8b0193:
   call far A0a990003
   or AX,AX
   jz L0b8b01a4
   call far A0a990065
   mov [BP-02],AX
L0b8b01a4:
   push CS
   call near offset A0b8b000e
   or AX,AX
   jz L0b8b01b2
   cmp word ptr [BP-02],+1B
   jnz L0b8b0193
L0b8b01b2:
   mov AX,0019
   push AX
   call far A24610002
   pop CX
   push DS
   mov AX,04D4
   push AX
   call far A24540006
   pop CX
   pop CX
   mov AX,[BP-04]
jmp near L0b8b01cd
L0b8b01cd:
   mov SP,BP
   pop BP
ret far

A0b8b01d1:
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
   call near offset A0b8b009d
   add SP,+08
   cmp word ptr [BP-04],+00
   jle L0b8b0205
   cmp word ptr [BP-02],+00
   jle L0b8b0205
   mov AX,[BP-04]
   mov [3860],AX
   mov AX,[BP-02]
   mov [3862],AX
   mov AX,0001
jmp near L0b8b0209
L0b8b0205:
   xor AX,AX
jmp near L0b8b0209
L0b8b0209:
   mov SP,BP
   pop BP
ret far

A0b8b020d:
   push BP
   mov BP,SP
   sub SP,+02
L0b8b0213:
   mov word ptr [3836],0000
   push DS
   mov AX,04D7
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,371E
   push AX
   push DS
   mov AX,371C
   push AX
   push DS
   mov AX,0509
   push AX
   push CS
   call near offset A0b8b012f
   add SP,+0C
   or AX,AX
   jnz L0b8b0242
jmp near L0b8b02f5
L0b8b0242:
   push DS
   mov AX,3830
   push AX
   push DS
   mov AX,3728
   push AX
   push DS
   mov AX,052E
   push AX
   push CS
   call near offset A0b8b012f
   add SP,+0C
   or AX,AX
   jnz L0b8b025f
jmp near L0b8b02f5
L0b8b025f:
   push DS
   mov AX,3720
   push AX
   push DS
   mov AX,382A
   push AX
   push DS
   mov AX,0566
   push AX
   push CS
   call near offset A0b8b012f
   add SP,+0C
   or AX,AX
   jnz L0b8b027c
jmp near L0b8b02f5
L0b8b027c:
   mov AX,[371C]
   sub [3728],AX
   mov AX,[371C]
   sub [382A],AX
   mov AX,[371E]
   sub [3830],AX
   mov AX,[371E]
   sub [3720],AX
   cmp word ptr [3728],-01
   jge L0b8b02bb
   cmp word ptr [382A],+01
   jle L0b8b02bb
   cmp word ptr [3830],-01
   jge L0b8b02bb
   cmp word ptr [3720],+01
   jle L0b8b02bb
   mov AX,0001
jmp near L0b8b02f9
X0b8b02b9:
jmp near L0b8b02f5
L0b8b02bb:
   push DS
   mov AX,059F
   push AX
   call far A24540006
   pop CX
   pop CX
L0b8b02c7:
   call far A0a990003
   or AX,AX
   jz L0b8b02c7
   push DS
   mov AX,05C8
   push AX
   call far A24540006
   pop CX
   pop CX
   call far A0a990065
   mov [BP-02],AX
   push [BP-02]
   call far A24d90000
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

A0b8b02fd:
   push BP
   mov BP,SP
   sub SP,+08
   cmp word ptr [3864],+00
   jz L0b8b0312
   call far A0b8b0a18
jmp near L0b8b05ae
L0b8b0312:
   mov word ptr [3712],0000
   mov word ptr [3714],0000
   mov word ptr [3716],0000
   mov word ptr [3718],0000
L0b8b032a:
   mov word ptr [3722],0000
   call far A0a990003
   or AX,AX
   jz L0b8b037d
   call far A0a990065
   mov [3722],AX
   cmp word ptr [3722],+00
   jnz L0b8b034d
   mov AX,0001
jmp near L0b8b034f
L0b8b034d:
   xor AX,AX
L0b8b034f:
   push AX
   cmp word ptr [3722],+01
   jnz L0b8b035c
   mov AX,0001
jmp near L0b8b035e
L0b8b035c:
   xor AX,AX
L0b8b035e:
   pop DX
   or DX,AX
   push DX
   cmp word ptr [3722],+02
   jnz L0b8b036e
   mov AX,0001
jmp near L0b8b0370
L0b8b036e:
   xor AX,AX
L0b8b0370:
   pop DX
   or DX,AX
   jz L0b8b037d
   call far A0a990065
   mov [3722],AX
L0b8b037d:
   cmp word ptr [3722],+00
   jnz L0b8b0387
jmp near L0b8b041c
L0b8b0387:
   mov AX,[3722]
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
		dw L0b8b0405,L0b8b03d7,L0b8b03ee,L0b8b03c0,L0b8b03c0,L0b8b03d7,L0b8b03ee,L0b8b0405
L0b8b03c0:
   cmp word ptr [BP+06],+00
   jz L0b8b03c9
jmp near L0b8b032a
L0b8b03c9:
   mov word ptr [3712],0000
   mov word ptr [3714],FFFF
jmp near L0b8b041c
L0b8b03d7:
   cmp word ptr [BP+06],+00
   jz L0b8b03e0
jmp near L0b8b032a
L0b8b03e0:
   mov word ptr [3712],FFFF
   mov word ptr [3714],0000
jmp near L0b8b041c
L0b8b03ee:
   cmp word ptr [BP+06],+00
   jz L0b8b03f7
jmp near L0b8b032a
L0b8b03f7:
   mov word ptr [3712],0001
   mov word ptr [3714],0000
jmp near L0b8b041c
L0b8b0405:
   cmp word ptr [BP+06],+00
   jz L0b8b040e
jmp near L0b8b032a
L0b8b040e:
   mov word ptr [3712],0000
   mov word ptr [3714],0001
jmp near L0b8b041c
L0b8b041c:
   call far A0a9900b7
   mov AL,[3701]
   cbw
   mov [3716],AX
   mov AL,[34FF]
   cbw
   mov [371A],AX
   cmp word ptr [3712],+00
   jz L0b8b0439
jmp near L0b8b04e6
L0b8b0439:
   cmp word ptr [3714],+00
   jz L0b8b0443
jmp near L0b8b04e6
L0b8b0443:
   cmp word ptr [3836],+00
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
   call near offset A0b8b009d
   add SP,+08
   mov AX,[BP-08]
   sub AX,[371C]
   mov [BP-04],AX
   mov AX,[BP-06]
   sub AX,[371E]
   mov [BP-02],AX
   mov AX,[BP-04]
   shl AX,1
   cmp AX,[382A]
   jle L0b8b0482
   mov AX,0001
jmp near L0b8b0484
L0b8b0482:
   xor AX,AX
L0b8b0484:
   push AX
   mov AX,[BP-04]
   shl AX,1
   cmp AX,[3728]
   jge L0b8b0495
   mov AX,0001
jmp near L0b8b0497
L0b8b0495:
   xor AX,AX
L0b8b0497:
   pop DX
   sub DX,AX
   mov [3712],DX
   mov AX,[BP-02]
   shl AX,1
   cmp AX,[3720]
   jle L0b8b04ae
   mov AX,0001
jmp near L0b8b04b0
L0b8b04ae:
   xor AX,AX
L0b8b04b0:
   push AX
   mov AX,[BP-02]
   shl AX,1
   cmp AX,[3830]
   jge L0b8b04c1
   mov AX,0001
jmp near L0b8b04c3
L0b8b04c1:
   xor AX,AX
L0b8b04c3:
   pop DX
   sub DX,AX
   mov [3714],DX
   push CS
   call near offset A0b8b000e
   or AX,AX
   jz L0b8b04d8
   mov word ptr [3716],0001
L0b8b04d8:
   push CS
   call near offset A0b8b0024
   or AX,AX
   jz L0b8b04e6
   mov word ptr [371A],0001
L0b8b04e6:
   cmp word ptr [3712],+00
   jnz L0b8b0542
   cmp word ptr [3714],+00
   jnz L0b8b0542
   cmp word ptr [BP+06],+00
   jz L0b8b0542
   cmp byte ptr [354B],00
   jnz L0b8b0508
   cmp byte ptr [364B],00
   jz L0b8b050c
L0b8b0508:
   dec word ptr [3712]
L0b8b050c:
   cmp byte ptr [354D],00
   jnz L0b8b051a
   cmp byte ptr [364D],00
   jz L0b8b051e
L0b8b051a:
   inc word ptr [3712]
L0b8b051e:
   cmp byte ptr [3548],00
   jnz L0b8b052c
   cmp byte ptr [3648],00
   jz L0b8b0530
L0b8b052c:
   dec word ptr [3714]
L0b8b0530:
   cmp byte ptr [3550],00
   jnz L0b8b053e
   cmp byte ptr [3650],00
   jz L0b8b0542
L0b8b053e:
   inc word ptr [3714]
L0b8b0542:
   cmp word ptr [3716],+00
   jz L0b8b0552
   mov AX,[383A]
   xor [3716],AX
jmp near L0b8b0558
L0b8b0552:
   mov word ptr [383A],0000
L0b8b0558:
   cmp word ptr [371A],+00
   jz L0b8b0568
   mov AX,[383C]
   xor [371A],AX
jmp near L0b8b056e
L0b8b0568:
   mov word ptr [383C],0000
L0b8b056e:
   mov AX,[3712]
   mov [3724],AX
   mov AX,[3714]
   mov [3726],AX
   cmp word ptr [385E],+00
   jz L0b8b0588
   call far A0b8b080e
jmp near L0b8b05ae
L0b8b0588:
   cmp word ptr [13A4],+00
   jz L0b8b05ae
   cmp word ptr [13A6],+00
   jz L0b8b05ae
   cmp word ptr [3716],+00
   jz L0b8b05ae
   cmp word ptr [371A],+00
   jz L0b8b05ae
   mov AX,000A
   push AX
   call far A0cc20008
   pop CX
L0b8b05ae:
   mov SP,BP
   pop BP
ret far

A0b8b05b2:
   push BP
   mov BP,SP
L0b8b05b5:
   les BX,[0C74]
   mov AL,[ES:BX]
   cbw
   cmp AX,[04C8]
   jz L0b8b05b5
   les BX,[0C74]
   mov AL,[ES:BX]
   cbw
   mov [04C8],AX
   push [BP+06]
   push CS
   call near offset A0b8b02fd
   pop CX
   pop BP
ret far

X0b8b05d8:
   push BP
   mov BP,SP
   push CS
   call near offset A0b8b01d1
   mov [3836],AX
   pop BP
ret far

A0b8b05e4:
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0020
   push CS
   call near offset A0b8b01d1
   or AX,AX
   jz L0b8b0652
   push DS
   mov AX,05CB
   push AX
   call far A24540006
   pop CX
   pop CX
L0b8b0603:
   call far A0a990003
   or AX,AX
   jz L0b8b0603
   call far A0a990065
   push AX
   call far A24d90000
   pop CX
   mov [BP-02],AX
   cmp word ptr [BP-02],+4B
   jz L0b8b062d
   cmp word ptr [BP-02],+4A
   jz L0b8b062d
   cmp word ptr [BP-02],+1B
   jnz L0b8b0603
L0b8b062d:
   push DS
   mov AX,05F8
   push AX
   call far A24540006
   pop CX
   pop CX
   mov word ptr [3836],0000
   mov AX,[BP-02]
   cmp AX,004A
   jz L0b8b0649
jmp near L0b8b0652
L0b8b0649:
   push CS
   call near offset A0b8b020d
   mov [3836],AX
jmp near L0b8b0652
L0b8b0652:
   cmp word ptr [BP-02],+1B
   jz L0b8b065d
   mov AX,0001
jmp near L0b8b065f
L0b8b065d:
   xor AX,AX
L0b8b065f:
jmp near L0b8b0661
L0b8b0661:
   mov SP,BP
   pop BP
ret far

A0b8b0665:
   push BP
   mov BP,SP
L0b8b0668:
   xor AX,AX
   push AX
   push CS
   call near offset A0b8b02fd
   pop CX
   cmp word ptr [3722],+00
   jz L0b8b0668
   pop BP
ret far

A0b8b0679:
   push BP
   mov BP,SP
   mov word ptr [3864],0000
   mov word ptr [385E],0000
   mov AX,[04C4]
   or AX,[04C6]
   jz L0b8b06ac
   push [04C6]
   push [04C4]
   call far A23f70008
   pop CX
   pop CX
   mov word ptr [04C6],0000
   mov word ptr [04C4],0000
L0b8b06ac:
   mov word ptr [3838],0000
   mov word ptr [3832],0001
   mov AX,3039
   push AX
   call far A24940004
   pop CX
   pop BP
ret far

A0b8b06c4:
   push BP
   mov BP,SP
   sub SP,+02
   push CS
   call near offset A0b8b0679
   mov word ptr [3868],0000
   mov AX,8000
   push AX
   push [BP+08]
   push [BP+06]
   call far A2339000c
   add SP,+06
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jge L0b8b06f2
jmp near L0b8b0773
L0b8b06f2:
   push [BP-02]
   call far A24320001
   pop CX
   mov [3834],AX
   push [3834]
   call far A22d7000a
   pop CX
   mov [04C6],DX
   mov [04C4],AX
   mov AX,[04C4]
   or AX,[04C6]
   jnz L0b8b0726
   mov word ptr [04C6],0000
   mov word ptr [04C4],0000
jmp near L0b8b076a
L0b8b0726:
   push [3834]
   push [04C6]
   push [04C4]
   push [BP-02]
   call far A23530002
   add SP,+08
   or AX,AX
   jl L0b8b074f
   mov word ptr [3864],0001
   mov word ptr [BC14],0000
jmp near L0b8b076a
L0b8b074f:
   push [04C6]
   push [04C4]
   call far A23f70008
   pop CX
   pop CX
   mov word ptr [04C6],0000
   mov word ptr [04C4],0000
L0b8b076a:
   push [BP-02]
   call far A23440007
   pop CX
L0b8b0773:
   mov SP,BP
   pop BP
ret far

A0b8b0777:
   push BP
   mov BP,SP
   push CS
   call near offset A0b8b0679
   mov AX,1F40
   push AX
   call far A22d7000a
   pop CX
   mov [04C6],DX
   mov [04C4],AX
   mov AX,[04C4]
   or AX,[04C6]
   jz L0b8b07bc
   mov word ptr [3838],0000
   mov word ptr [385E],0001
   push [BP+08]
   push [BP+06]
   push DS
   mov AX,383E
   push AX
   call far A238d0008
   mov SP,BP
   mov word ptr [BC14],0000
L0b8b07bc:
   pop BP
ret far

A0b8b07be:
   push BP
   mov BP,SP
   sub SP,+02
   cmp word ptr [385E],+00
   jnz L0b8b07cd
jmp near L0b8b080a
L0b8b07cd:
   xor AX,AX
   push AX
   push DS
   mov AX,383E
   push AX
   call far A2429003d
   add SP,+06
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jl L0b8b0806
   push [3838]
   push [04C6]
   push [04C4]
   push [BP-02]
   call far A236b0008
   add SP,+08
   push [BP-02]
   call far A23440007
   pop CX
L0b8b0806:
   push CS
   call near offset A0b8b0679
L0b8b080a:
   mov SP,BP
   pop BP
ret far

A0b8b080e:
   push BP
   mov BP,SP
   sub SP,+04
   cmp word ptr [3722],+5B
   jnz L0b8b0827
   mov word ptr [3832],0000
   mov word ptr [3722],0000
L0b8b0827:
   cmp word ptr [3722],+5D
   jnz L0b8b083a
   mov word ptr [3832],0001
   mov word ptr [3722],0000
L0b8b083a:
   cmp word ptr [3722],+7D
   jnz L0b8b0848
   push CS
   call near offset A0b8b07be
jmp near L0b8b0a14
L0b8b0848:
   cmp word ptr [3838],+00
   jnz L0b8b086d
   mov word ptr [04CA],0000
   mov word ptr [04CC],0000
   mov word ptr [04CE],0000
   mov word ptr [04D0],0000
   mov AX,[BC14]
   mov [04D2],AX
L0b8b086d:
   mov AX,[04CA]
   cmp AX,[3712]
   jz L0b8b087b
   mov AX,0001
jmp near L0b8b087d
L0b8b087b:
   xor AX,AX
L0b8b087d:
   push AX
   mov AX,[04CC]
   cmp AX,[3714]
   jz L0b8b088c
   mov AX,0001
jmp near L0b8b088e
L0b8b088c:
   xor AX,AX
L0b8b088e:
   shl AL,1
   pop DX
   or DL,AL
   push DX
   mov AX,[04CE]
   cmp AX,[3716]
   jz L0b8b08a2
   mov AX,0001
jmp near L0b8b08a4
L0b8b08a2:
   xor AX,AX
L0b8b08a4:
   shl AL,1
   shl AL,1
   pop DX
   or DL,AL
   push DX
   mov AX,[04D0]
   cmp AX,[371A]
   jz L0b8b08ba
   mov AX,0001
jmp near L0b8b08bc
L0b8b08ba:
   xor AX,AX
L0b8b08bc:
   shl AL,1
   shl AL,1
   shl AL,1
   pop DX
   or DL,AL
   push DX
   cmp word ptr [3722],+00
   jle L0b8b08d9
   cmp word ptr [3722],+7F
   jg L0b8b08d9
   mov AX,0001
jmp near L0b8b08db
L0b8b08d9:
   xor AX,AX
L0b8b08db:
   mov CL,04
   shl AL,CL
   pop DX
   or DL,AL
   mov [BP-01],DL
   cmp byte ptr [BP-01],00
   jnz L0b8b08ee
jmp near L0b8b0a08
L0b8b08ee:
   cmp word ptr [3838],+00
   jz L0b8b095a
   cmp word ptr [3832],+00
   jnz L0b8b0903
   mov word ptr [BP-04],0001
jmp near L0b8b090d
L0b8b0903:
   mov AX,[BC14]
   sub AX,[04D2]
   mov [BP-04],AX
L0b8b090d:
   cmp word ptr [BP-04],0080
   jge L0b8b092a
   mov AL,[BP-04]
   mov DX,[3838]
   les BX,[04C4]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [3838]
jmp near L0b8b095a
L0b8b092a:
   mov AL,[BP-04]
   and AL,7F
   or AL,80
   mov DX,[3838]
   les BX,[04C4]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [3838]
   mov AX,[BP-04]
   mov CL,07
   sar AX,CL
   mov DX,[3838]
   les BX,[04C4]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [3838]
L0b8b095a:
   mov AL,[BP-01]
   mov DX,[3838]
   les BX,[04C4]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [3838]
   test byte ptr [BP-01],01
   jz L0b8b0988
   mov AL,[3712]
   mov DX,[3838]
   les BX,[04C4]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [3838]
L0b8b0988:
   test byte ptr [BP-01],02
   jz L0b8b09a2
   mov AL,[3714]
   mov DX,[3838]
   les BX,[04C4]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [3838]
L0b8b09a2:
   test byte ptr [BP-01],04
   jz L0b8b09bc
   mov AL,[3716]
   mov DX,[3838]
   les BX,[04C4]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [3838]
L0b8b09bc:
   test byte ptr [BP-01],08
   jz L0b8b09d6
   mov AL,[371A]
   mov DX,[3838]
   les BX,[04C4]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [3838]
L0b8b09d6:
   test byte ptr [BP-01],10
   jz L0b8b09f0
   mov AL,[3722]
   mov DX,[3838]
   les BX,[04C4]
   add BX,DX
   mov [ES:BX],AL
   inc word ptr [3838]
L0b8b09f0:
   mov AX,[3712]
   mov [04CA],AX
   mov AX,[3714]
   mov [04CC],AX
   mov AX,[3716]
   mov [04CE],AX
   mov AX,[371A]
   mov [04D0],AX
L0b8b0a08:
   cmp word ptr [3838],7530
   jb L0b8b0a14
   push CS
   call near offset A0b8b07be
L0b8b0a14:
   mov SP,BP
   pop BP
ret far

A0b8b0a18:
   push BP
   mov BP,SP
   sub SP,+04
   call far A0a990003
   or AX,AX
   jz L0b8b0a4d
   call far A0a990065
   mov [BP-04],AX
   cmp word ptr [3866],+00
   jz L0b8b0a43
   cmp word ptr [3866],+01
   jnz L0b8b0a4d
   cmp word ptr [BP-04],+1B
   jnz L0b8b0a4d
L0b8b0a43:
   push CS
   call near offset A0b8b0679
   mov word ptr [3868],0001
L0b8b0a4d:
   mov word ptr [3722],0000
   cmp word ptr [3838],+00
   jnz L0b8b0a7e
   mov word ptr [3712],0000
   mov word ptr [3714],0000
   mov word ptr [3716],0000
   mov word ptr [371A],0000
   mov AX,[BC14]
   mov [370E],AX
   mov word ptr [3710],0000
L0b8b0a7e:
   mov AX,[BC14]
   sub AX,[370E]
   cmp AX,[3710]
   jge L0b8b0a8e
jmp near L0b8b0b60
L0b8b0a8e:
   mov AX,[3838]
   les BX,[04C4]
   add BX,AX
   mov AL,[ES:BX]
   mov [BP-01],AL
   inc word ptr [3838]
   test byte ptr [BP-01],01
   jz L0b8b0abb
   mov AX,[3838]
   les BX,[04C4]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [3712],AX
   inc word ptr [3838]
L0b8b0abb:
   test byte ptr [BP-01],02
   jz L0b8b0ad5
   mov AX,[3838]
   les BX,[04C4]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [3714],AX
   inc word ptr [3838]
L0b8b0ad5:
   test byte ptr [BP-01],04
   jz L0b8b0aef
   mov AX,[3838]
   les BX,[04C4]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [3716],AX
   inc word ptr [3838]
L0b8b0aef:
   test byte ptr [BP-01],08
   jz L0b8b0b09
   mov AX,[3838]
   les BX,[04C4]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [371A],AX
   inc word ptr [3838]
L0b8b0b09:
   test byte ptr [BP-01],10
   jz L0b8b0b23
   mov AX,[3838]
   les BX,[04C4]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [3722],AX
   inc word ptr [3838]
L0b8b0b23:
   mov AX,[3838]
   les BX,[04C4]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov [3710],AX
   inc word ptr [3838]
   cmp word ptr [3710],+00
   jge L0b8b0b60
   mov AX,[3838]
   les BX,[04C4]
   add BX,AX
   mov AL,[ES:BX]
   cbw
   mov CL,07
   shl AX,CL
   mov DX,[3710]
   and DX,007F
   add AX,DX
   mov [3710],AX
   inc word ptr [3838]
L0b8b0b60:
   mov AX,[3838]
   cmp AX,[3834]
   jb L0b8b0b6d
   push CS
   call near offset A0b8b0679
L0b8b0b6d:
   mov SP,BP
   pop BP
ret far

A0b8b0b71:
   push BP
   mov BP,SP
   mov word ptr [3712],0000
   mov word ptr [3714],0000
   mov word ptr [3716],0000
   mov word ptr [383A],0000
   mov word ptr [3724],0000
   mov word ptr [3726],0000
   mov word ptr [382C],0000
   mov word ptr [382E],0000
   mov byte ptr [372A],00
   mov word ptr [3864],0000
   mov word ptr [385E],0000
   mov word ptr [3866],0001
   mov word ptr [3836],0000
   mov AL,01
   push AX
   call far A0a990191
   pop CX
   pop BP
ret far

A0b8b0bcc:
   push BP
   mov BP,SP
   call far A0a9901f4
   pop BP
ret far

Segment 0c48 ;; UNCRUNCH:UNCRUNCH
A0c480006:
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
   jcxz L0c480077
   mov DX,DI
   xor AX,AX
   cld
L0c480021:
   lodsb
   cmp AL,20
   jb L0c48002b
   stosw
L0c480027:
   loop L0c480021
jmp near L0c480077
L0c48002b:
   cmp AL,10
   jnb L0c480036
   and AH,F0
   or AH,AL
jmp near L0c480027
L0c480036:
   cmp AL,18
   jz L0c48004d
   jnb L0c480055
   sub AL,10
   add AL,AL
   add AL,AL
   add AL,AL
   add AL,AL
   and AH,8F
   or AH,AL
jmp near L0c480027
L0c48004d:
   add DX,00A0
   mov DI,DX
jmp near L0c480027
L0c480055:
   cmp AL,1B
   jb L0c480060
   jnz L0c480027
   xor AH,80
jmp near L0c480027
L0c480060:
   cmp AL,19
   mov BX,CX
   lodsb
   mov CL,AL
   mov AL,20
   jz L0c48006d
   lodsb
   dec BX
L0c48006d:
   xor CH,CH
   inc CX
   repz stosw
   mov CX,BX
   dec CX
   loopnz L0c480021
L0c480077:
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

Segment 0c50 ;; CONFIG.C:CONFIG
A0c500001:
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [BP-02],0000
jmp near L0c50007a
L0c50000e:
   mov AX,[BP-02]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far A24d6000b
   pop CX
   pop CX
   mov AX,[BP-02]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   les BX,[ES:BX]
   cmp byte ptr [ES:BX],2F
   jnz L0c500077
   mov AX,[BP-02]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   les BX,[ES:BX]
   cmp byte ptr [ES:BX+01],50
   jnz L0c500077
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
   mov AX,05FC
   push AX
   call far A238d0008
   add SP,+08
L0c500077:
   inc word ptr [BP-02]
L0c50007a:
   mov AX,[BP-02]
   cmp AX,[BP+06]
   jl L0c50000e
   mov SP,BP
   pop BP
ret far

A0c500086:
   push BP
   mov BP,SP
   sub SP,+12
   call far A24360006
   push DS
   mov AX,0640
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0661
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,068C
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,188A
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0690
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,06B2
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,188A
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,06B6
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,06D7
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,188A
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,06DB
   push AX
   call far A24540006
   pop CX
   pop CX
   mov word ptr [2670],0000
   mov word ptr [2672],0000
   call far A0b8b003a
   mov word ptr [BP-12],0000
jmp near L0c500263
L0c50012e:
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far A24d6000b
   pop CX
   pop CX
   push DS
   mov AX,06F9
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far A238a0006
   add SP,+08
   or AX,AX
   jnz L0c500199
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   push [04C2]
   push [04C0]
   call far A237300d2
   add SP,+0A
   push SS
   lea AX,[BP-10]
   push AX
   call far A24540006
   pop CX
   pop CX
   call far A0b8b0665
jmp near L0c500260
L0c500199:
   push DS
   mov AX,06FF
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far A238a0006
   add SP,+08
   or AX,AX
   jnz L0c5001cc
   mov word ptr [0DBD],0000
   mov word ptr [0DBF],0000
jmp near L0c500260
L0c5001cc:
   push DS
   mov AX,0705
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far A238a0006
   add SP,+08
   or AX,AX
   jnz L0c5001fe
   mov word ptr [2670],0220
   mov word ptr [2672],0003
jmp near L0c500260
L0c5001fe:
   push DS
   mov AX,0709
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far A238a0006
   add SP,+08
   or AX,AX
   jnz L0c500236
   mov word ptr [0DBD],0000
   mov word ptr [0DBF],0000
   mov word ptr [063C],0001
jmp near L0c500260
L0c500236:
   push DS
   mov AX,0710
   push AX
   mov AX,[BP-12]
   shl AX,1
   shl AX,1
   les BX,[BP+08]
   add BX,AX
   push [ES:BX+02]
   push [ES:BX]
   call far A238a0006
   add SP,+08
   or AX,AX
   jnz L0c500260
   mov word ptr [063E],0001
L0c500260:
   inc word ptr [BP-12]
L0c500263:
   mov AX,[BP-12]
   cmp AX,[BP+06]
   jge L0c50026e
jmp near L0c50012e
L0c50026e:
   mov SP,BP
   pop BP
ret far

A0c500272:
   push BP
   mov BP,SP
   sub SP,+12
   mov AX,[386A]
   mov [BP-12],AX
   cmp word ptr [BP-12],+00
   jz L0c500287
jmp near L0c50030a
L0c500287:
   mov AL,[387A]
   mov [34E9],AL
   call far A0b8b01d1
   mov [3836],AX
   cmp word ptr [3836],+00
   jnz L0c5002a4
   mov word ptr [386C],0000
jmp near L0c5002f0
L0c5002a4:
   cmp word ptr [386C],+00
   jz L0c5002f0
   mov AX,[386E]
   mov [3728],AX
   mov AX,[3870]
   mov [371C],AX
   mov AX,[3872]
   mov [382A],AX
   mov AX,[3874]
   mov [3830],AX
   mov AX,[3876]
   mov [371E],AX
   mov AX,[3878]
   mov [3720],AX
   xor AX,AX
   push AX
   call far A0b8b02fd
   pop CX
   cmp word ptr [3712],+00
   jnz L0c5002e6
   cmp word ptr [3714],+00
   jz L0c5002eb
L0c5002e6:
   mov AX,0001
jmp near L0c5002ed
L0c5002eb:
   xor AX,AX
L0c5002ed:
   or [BP-12],AX
L0c5002f0:
   cmp word ptr [0DBF],+00
   jnz L0c5002fd
   mov word ptr [387C],0000
L0c5002fd:
   cmp word ptr [0DBD],+00
   jnz L0c50030a
   mov word ptr [387E],0000
L0c50030a:
   cmp word ptr [BP-12],+00
   jz L0c500313
jmp near L0c500438
L0c500313:
   call far A24360006
   push DS
   mov AX,0716
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0719
   push AX
   call far A24540006
   pop CX
   pop CX
   cmp word ptr [387E],+00
   jz L0c500345
   push DS
   mov AX,0730
   push AX
   call far A24540006
   pop CX
   pop CX
jmp near L0c500351
L0c500345:
   push DS
   mov AX,075D
   push AX
   call far A24540006
   pop CX
   pop CX
L0c500351:
   cmp word ptr [387C],+00
   jz L0c500366
   push DS
   mov AX,077E
   push AX
   call far A24540006
   pop CX
   pop CX
jmp near L0c500372
L0c500366:
   push DS
   mov AX,07A9
   push AX
   call far A24540006
   pop CX
   pop CX
L0c500372:
   cmp word ptr [386C],+00
   jz L0c500387
   push DS
   mov AX,07C6
   push AX
   call far A24540006
   pop CX
   pop CX
jmp near L0c500393
L0c500387:
   push DS
   mov AX,07D7
   push AX
   call far A24540006
   pop CX
   pop CX
L0c500393:
   cmp byte ptr [34E9],00
   jnz L0c5003b4
   push DS
   mov AX,07E9
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0811
   push AX
   call far A24540006
   pop CX
   pop CX
jmp near L0c5003d5
L0c5003b4:
   cmp byte ptr [34E9],02
   jnz L0c5003c9
   push DS
   mov AX,0833
   push AX
   call far A24540006
   pop CX
   pop CX
jmp near L0c5003d5
L0c5003c9:
   push DS
   mov AX,084F
   push AX
   call far A24540006
   pop CX
   pop CX
L0c5003d5:
   push DS
   mov AX,086C
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,086F
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0892
   push AX
   call far A24540006
   pop CX
   pop CX
L0c5003f9:
   call far A0b8b0665
   push [3722]
   call far A24d90000
   pop CX
   mov [3722],AX
   cmp word ptr [3722],+0D
   jz L0c500420
   cmp word ptr [3722],+43
   jz L0c500420
   cmp word ptr [3722],+1B
   jnz L0c5003f9
L0c500420:
   cmp word ptr [3722],+43
   jnz L0c50042c
   mov word ptr [BP-12],0001
L0c50042c:
   cmp word ptr [3722],+1B
   jnz L0c500438
   xor AX,AX
jmp near L0c500724
L0c500438:
   cmp word ptr [BP-12],+00
   jnz L0c500441
jmp near L0c5006be
L0c500441:
   call far A24360006
   cmp word ptr [0DBD],+00
   jnz L0c500489
   cmp word ptr [0DBF],+00
   jnz L0c500489
   push DS
   mov AX,08B4
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,08B7
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,08EA
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,08F9
   push AX
   call far A24540006
   pop CX
   pop CX
   call far A0b8b0665
L0c500489:
   cmp word ptr [0DBD],+00
   jz L0c5004e5
   cmp word ptr [04C2],+00
   jg L0c5004e5
   jl L0c5004a1
   cmp word ptr [04C0],0FA0
   jnb L0c5004e5
L0c5004a1:
   push DS
   mov AX,0917
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,091C
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0952
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0989
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,099A
   push AX
   call far A24540006
   pop CX
   pop CX
   call far A0b8b0665
jmp near L0c5005ab
L0c5004e5:
   cmp word ptr [0DBD],+00
   jnz L0c5004ef
jmp near L0c5005ab
L0c5004ef:
   push DS
   mov AX,09B8
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,09E5
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0A17
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0A44
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0A78
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0AAA
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0ADB
   push AX
   call far A24540006
   pop CX
   pop CX
L0c500543:
   call far A0b8b0665
   push [3722]
   call far A24d90000
   pop CX
   mov [3722],AX
   cmp word ptr [3722],+7E
   jnz L0c500580
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-10]
   push AX
   call far A23f50003
   push DX
   push AX
   call far A237300d2
   add SP,+0A
   push SS
   lea AX,[BP-10]
   push AX
   call far A24540006
   pop CX
   pop CX
L0c500580:
   cmp word ptr [3722],+1B
   jnz L0c50058c
   xor AX,AX
jmp near L0c500724
L0c50058c:
   cmp word ptr [3722],+59
   jz L0c50059a
   cmp word ptr [3722],+4E
   jnz L0c500543
L0c50059a:
   cmp word ptr [3722],+59
   jnz L0c5005a6
   mov AX,0001
jmp near L0c5005a8
L0c5005a6:
   xor AX,AX
L0c5005a8:
   mov [387E],AX
L0c5005ab:
   cmp word ptr [0DBF],+00
   jnz L0c5005b5
jmp near L0c500627
L0c5005b5:
   call far A24360006
   push DS
   mov AX,0AF8
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0AFF
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0B30
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0B4C
   push AX
   call far A24540006
   pop CX
   pop CX
L0c5005ea:
   call far A0b8b0665
   push [3722]
   call far A24d90000
   pop CX
   mov [3722],AX
   cmp word ptr [3722],+1B
   jnz L0c500608
   xor AX,AX
jmp near L0c500724
L0c500608:
   cmp word ptr [3722],+59
   jz L0c500616
   cmp word ptr [3722],+4E
   jnz L0c5005ea
L0c500616:
   cmp word ptr [3722],+59
   jnz L0c500622
   mov AX,0001
jmp near L0c500624
L0c500622:
   xor AX,AX
L0c500624:
   mov [387C],AX
L0c500627:
   call far A24360006
   push DS
   mov AX,0B73
   push AX
   call far A24540006
   pop CX
   pop CX
   call far A0b8b05e4
   or AX,AX
   jnz L0c500646
   xor AX,AX
jmp near L0c500724
L0c500646:
   mov AX,[3836]
   mov [386C],AX
   call far A24360006
   push DS
   mov AX,0B76
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0B79
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0BA0
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0BBC
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0BD9
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0BF7
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0BFA
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,0C28
   push AX
   call far A24540006
   pop CX
   pop CX
   call far A08760aef
   or AX,AX
   jnz L0c5006be
   xor AX,AX
jmp near L0c500724
L0c5006be:
   cmp word ptr [04C2],+00
   jg L0c5006db
   jl L0c5006cf
   cmp word ptr [04C0],0FA0
   jnb L0c5006db
L0c5006cf:
   mov word ptr [0DBD],0000
   mov word ptr [387E],0000
L0c5006db:
   mov word ptr [386A],0000
   mov AX,[386C]
   mov [3836],AX
   mov AX,[3728]
   mov [386E],AX
   mov AX,[371C]
   mov [3870],AX
   mov AX,[382A]
   mov [3872],AX
   mov AX,[3830]
   mov [3874],AX
   mov AX,[371E]
   mov [3876],AX
   mov AX,[3720]
   mov [3878],AX
   mov AL,[34E9]
   mov AH,00
   mov [387A],AX
   mov AX,[387E]
   mov [0DBD],AX
   mov AX,[387C]
   mov [0DBF],AX
   mov AX,0001
jmp near L0c500724
L0c500724:
   mov SP,BP
   pop BP
ret far

Segment 0cc2 ;; PIXWRITE.C:PIXWRITE
A0cc20008:
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
   call far A23730085
   add SP,+08
   push DS
   mov AX,0C4C
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far A238d0008
   add SP,+08
   push SS
   lea AX,[BP-70]
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,0C54
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far A23840009
   add SP,+08
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far A2429003d
   add SP,+06
   mov DI,AX
   cmp DI,-01
   jz L0cc200c3
   mov AX,[34EC]
   mov [BP-74],AX
   mov AX,[34EA]
   mov [34EC],AX
   mov word ptr [BP-72],0000
jmp near L0cc200af
L0cc20084:
   xor SI,SI
jmp near L0cc200a6
L0cc20088:
   push [BP-72]
   push SI
   call far A0a62011a
   pop CX
   pop CX
   mov AX,0001
   push AX
   push DS
   mov AX,34E2
   push AX
   push DI
   call far A23550002
   add SP,+08
   inc SI
L0cc200a6:
   cmp SI,0140
   jl L0cc20088
   inc word ptr [BP-72]
L0cc200af:
   cmp word ptr [BP-72],00C8
   jl L0cc20084
   mov AX,[BP-74]
   mov [34EC],AX
   push DI
   call far A23440007
   pop CX
L0cc200c3:
   push DS
   mov AX,0C59
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far A238d0008
   add SP,+08
   push SS
   lea AX,[BP-70]
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,0C61
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far A23840009
   add SP,+08
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-60]
   push AX
   call far A2429003d
   add SP,+06
   mov DI,AX
   cmp DI,-01
   jnz L0cc20113
jmp near L0cc2020d
L0cc20113:
   xor SI,SI
jmp near L0cc201fd
L0cc20118:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   mov AX,SI
   mov DX,0003
   mul DX
   mov BX,AX
   mov AL,[BX+0194]
   mov AH,00
   shl AX,1
   shl AX,1
   push AX
   call far A23730085
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
   mov AL,[BX+0195]
   mov AH,00
   shl AX,1
   shl AX,1
   push AX
   call far A23730085
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
   mov AL,[BX+0196]
   mov AH,00
   shl AX,1
   shl AX,1
   push AX
   call far A23730085
   add SP,+08
   push DS
   mov AX,0C66
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   push SS
   lea AX,[BP-20]
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,0C68
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   push SS
   lea AX,[BP-10]
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,0C6A
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   push SS
   lea AX,[BP-40]
   push AX
   call far A2388000b
   pop CX
   pop CX
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   push DI
   call far A23550002
   add SP,+08
   inc SI
L0cc201fd:
   cmp SI,0100
   jge L0cc20206
jmp near L0cc20118
L0cc20206:
   push DI
   call far A23440007
   pop CX
L0cc2020d:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 0ce3 ;; :::SOUNDS, S.C:S
A0ce30003:
   push AX
   push BX
   push CX
   push DX
   push ES
   push DS
   push SI
   push DI
   push BP
   mov BP,segment A24f10000
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

A0ce3001b:
   push BP
   mov BP,SP
   sub SP,+02
   mov word ptr [398E],0000
   mov word ptr [398C],0000
   mov word ptr [BP-02],0000
jmp near L0ce30073
L0ce30034:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+3CAC],FFFF
   mov word ptr [BX+3CAA],FFFF
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+3928],0000
   mov BX,[BP-02]
   shl BX,1
   mov word ptr [BX+38C4],0000
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+3992],0000
   mov word ptr [BX+3990],0000
   inc word ptr [BP-02]
L0ce30073:
   cmp word ptr [BP-02],+32
   jl L0ce30034
   mov word ptr [BP-02],0000
jmp near L0ce30096
L0ce30080:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+3A5C],0000
   mov word ptr [BX+3A5A],0000
   inc word ptr [BP-02]
L0ce30096:
   cmp word ptr [BP-02],0080
   jl L0ce30080
   cmp word ptr [0DBD],+00
   jnz L0ce300a7
jmp near L0ce3013d
L0ce300a7:
   cmp word ptr [0DBF],+00
   jnz L0ce300b1
jmp near L0ce3013d
L0ce300b1:
   cmp word ptr [2670],+00
   jz L0ce300fe
   cmp word ptr [2672],+00
   jz L0ce300fe
   call far A214200ee
   mov [BP-02],AX
   test word ptr [BP-02],0006
   jz L0ce300fe
   mov word ptr [0DBD],0001
   mov word ptr [0DBF],0001
   test word ptr [BP-02],0002
   jz L0ce300e6
   mov AX,0001
jmp near L0ce300e8
L0ce300e6:
   xor AX,AX
L0ce300e8:
   mov [0DBF],AX
   test word ptr [BP-02],0004
   jz L0ce300f7
   mov AX,0001
jmp near L0ce300f9
L0ce300f7:
   xor AX,AX
L0ce300f9:
   mov [0DBD],AX
jmp near L0ce3013d
L0ce300fe:
   mov word ptr [0DBD],0000
   mov word ptr [0DBF],0000
   call far A214200ee
   mov [BP-02],AX
   test word ptr [BP-02],0003
   jz L0ce3013d
   test word ptr [BP-02],0002
   jz L0ce30125
   mov AX,0001
jmp near L0ce30127
L0ce30125:
   xor AX,AX
L0ce30127:
   mov [0DBF],AX
   test word ptr [BP-02],0004
   jz L0ce30136
   mov AX,0001
jmp near L0ce30138
L0ce30136:
   xor AX,AX
L0ce30138:
   mov [0DBD],AX
jmp near L0ce3013d
L0ce3013d:
   les BX,[BP+06]
   cmp byte ptr [ES:BX],00
   jnz L0ce3014f
   mov word ptr [0DBD],0000
jmp near L0ce301dc
L0ce3014f:
   mov AX,8001
   push AX
   push [BP+08]
   push [BP+06]
   call far A2339000c
   add SP,+06
   mov [0DC1],AX
   cmp word ptr [0DC1],-01
   jnz L0ce30173
   mov word ptr [0DBD],0000
jmp near L0ce301dc
L0ce30173:
   mov AX,00C8
   push AX
   push DS
   mov AX,3CAA
   push AX
   push [0DC1]
   call far A2346000d
   add SP,+08
   mov AX,0064
   push AX
   push DS
   mov AX,3928
   push AX
   push [0DC1]
   call far A2346000d
   add SP,+08
   mov AX,0064
   push AX
   push DS
   mov AX,38C4
   push AX
   push [0DC1]
   call far A2346000d
   add SP,+08
   mov AX,00A0
   push AX
   push DS
   mov AX,3D7C
   push AX
   push [0DC1]
   call far A2346000d
   add SP,+08
   mov AX,0050
   push AX
   push DS
   mov AX,3C5A
   push AX
   push [0DC1]
   call far A2346000d
   add SP,+08
L0ce301dc:
   mov SP,BP
   pop BP
ret far

A0ce301e0:
   push BP
   mov BP,SP
   cmp word ptr [0DBD],+00
   jz L0ce30254
   mov BX,[BP+08]
   cmp byte ptr [BX+13AC],00
   jz L0ce301ff
   mov BX,[BP+08]
   mov AL,[BX+13AC]
   cbw
   mov [BP+08],AX
L0ce301ff:
   cmp word ptr [0C80],+00
   jz L0ce3020f
   mov AX,[BP+06]
   cmp AX,[38C2]
   jl L0ce30252
L0ce3020f:
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   mov AX,[BX+3990]
   or AX,[BX+3992]
   jz L0ce30252
   cmp word ptr [BP+08],+32
   jge L0ce30252
   cmp word ptr [0C70],+00
   jz L0ce30252
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   les BX,[BX+3990]
   mov [3D78],ES
   mov [3D76],BX
   mov BX,[BP+08]
   shl BX,1
   mov AX,[BX+3928]
   mov [0C80],AX
   mov AX,[BP+06]
   mov [38C2],AX
L0ce30252:
jmp near L0ce30297
L0ce30254:
   cmp word ptr [BP+08],0080
   jge L0ce30297
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   mov AX,[BX+3A5A]
   or AX,[BX+3A5C]
   jz L0ce30297
   mov AX,[0DB3]
   or AX,[0DB5]
   jz L0ce30297
   mov AX,[0DB7]
   or AX,[0DB9]
   jz L0ce30297
   mov BX,[BP+08]
   shl BX,1
   shl BX,1
   push [BX+3A5C]
   push [BX+3A5A]
   push [BP+06]
   call far A0ce309fd
   mov SP,BP
L0ce30297:
   pop BP
ret far

A0ce30299:
   push BP
   mov BP,SP
   sub SP,+04
   call far A24ce003a
   mov AX,0008
   push AX
   call far A246c0008
   pop CX
   mov [0C7A],DX
   mov [0C78],AX
   mov [3E2A],CS
   mov word ptr [3E28],offset A0ce30003
   mov [3E2E],CS
   mov word ptr [3E2C],offset A0ce30003
   cmp word ptr [063C],+00
   jz L0ce302d8
   mov word ptr [3E26],0000
jmp near L0ce30303
L0ce302d8:
   cmp word ptr [0DBD],+00
   jz L0ce302f7
   mov DX,[2670]
   add DX,+0C
   mov AL,D1
   out DX,AL
   mov word ptr [3E26],014D
   mov word ptr [0DB0],0010
jmp near L0ce30303
L0ce302f7:
   mov word ptr [3E26],0040
   mov word ptr [0DB0],0004
L0ce30303:
   cmp word ptr [0DBF],+00
   jz L0ce30354
   push [3E2A]
   push [3E28]
   mov AX,0008
   push AX
   call far A246c001a
   add SP,+06
   call far A214202c4
   or AX,AX
   jnz L0ce3032f
   mov word ptr [0DBF],0000
jmp near L0ce30340
L0ce3032f:
   mov AX,0008
   push AX
   call far A246c0008
   pop CX
   mov [3E2E],DX
   mov [3E2C],AX
L0ce30340:
   push [0C7A]
   push [0C78]
   mov AX,0008
   push AX
   call far A246c001a
   add SP,+06
L0ce30354:
   cmp word ptr [0DBD],+00
   jnz L0ce3035e
jmp near L0ce3040d
L0ce3035e:
   mov word ptr [BP-02],0000
jmp near L0ce30401
L0ce30366:
   mov BX,[BP-02]
   shl BX,1
   cmp word ptr [BX+3928],+00
   jnz L0ce30375
jmp near L0ce303fe
L0ce30375:
   mov BX,[BP-02]
   shl BX,1
   push [BX+3928]
   call far A22d7000a
   pop CX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov [BX+3992],DX
   mov [BX+3990],AX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+3990]
   or AX,[BX+3992]
   jz L0ce303fe
   xor AX,AX
   push AX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+3CAC]
   push [BX+3CAA]
   push [0DC1]
   call far A23700004
   add SP,+08
   mov BX,[BP-02]
   shl BX,1
   push [BX+3928]
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+3992]
   push [BX+3990]
   push [0DC1]
   call far A2346000d
   add SP,+08
   cmp AX,FFFF
   jnz L0ce303fe
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+3992],0000
   mov word ptr [BX+3990],0000
L0ce303fe:
   inc word ptr [BP-02]
L0ce30401:
   cmp word ptr [BP-02],+32
   jge L0ce3040a
jmp near L0ce30366
L0ce3040a:
jmp near L0ce304d0
L0ce3040d:
   mov AX,4080
   push AX
   call far A22d7000a
   pop CX
   mov [0DB5],DX
   mov [0DB3],AX
   mov AX,4080
   push AX
   call far A22d7000a
   pop CX
   mov [0DB9],DX
   mov [0DB7],AX
   xor AX,AX
   push AX
   mov AX,[0DBB]
   cwd
   push DX
   push AX
   push [0DC1]
   call far A23700004
   add SP,+08
   mov word ptr [BP-02],0000
jmp near L0ce304c6
L0ce3044c:
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push [0DC1]
   call far A2346000d
   add SP,+08
   cmp word ptr [BP-04],+00
   jz L0ce304b0
   push [BP-04]
   call far A22d7000a
   pop CX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov [BX+3A5C],DX
   mov [BX+3A5A],AX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+3A5A]
   or AX,[BX+3A5C]
   jz L0ce304ae
   push [BP-04]
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+3A5C]
   push [BX+3A5A]
   push [0DC1]
   call far A2346000d
   add SP,+08
L0ce304ae:
jmp near L0ce304c3
L0ce304b0:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov word ptr [BX+3A5C],0000
   mov word ptr [BX+3A5A],0000
L0ce304c3:
   inc word ptr [BP-02]
L0ce304c6:
   cmp word ptr [BP-02],0080
   jge L0ce304d0
jmp near L0ce3044c
L0ce304d0:
   les BX,[0C74]
   mov AX,[ES:BX]
   cwd
   mov DX,AX
   xor AX,AX
   mov [0C84],DX
   mov [0C82],AX
   cmp word ptr [3E26],+00
   jnz L0ce304ff
   mov word ptr [38C0],0000
   mov word ptr [3E26],0001
   mov word ptr [0C6E],0001
jmp near L0ce3057e
L0ce304ff:
   cmp word ptr [3E26],+01
   jbe L0ce3057e
   mov AX,[3E26]
   xor DX,DX
   push DX
   push AX
   mov DX,0001
   xor AX,AX
   push DX
   push AX
   call far A076a04f2
   mov [3E24],AX
   mov AX,[3E26]
   xor DX,DX
   push DX
   push AX
   mov DX,0001
   xor AX,AX
   push DX
   push AX
   call far A076a04f2
   push DX
   push AX
   mov AX,[0DB0]
   cwd
   pop BX
   pop CX
   call far A076a0390
   mov [3E1C],AX
   mov word ptr [3E20],segment A0daf0004
   mov word ptr [3E1E],offset A0daf0004
   push [3E20]
   push [3E1E]
   mov AX,0008
   push AX
   call far A246c001a
   add SP,+06
   mov word ptr [0C6E],0000
   mov word ptr [38C0],0001
   push [3E24]
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   call far A0ce30c09
   add SP,+06
L0ce3057e:
   mov SP,BP
   pop BP
ret far

A0ce30582:
   push BP
   mov BP,SP
   mov word ptr [398E],0000
   mov word ptr [398C],0000
   mov BX,[BP+06]
   shl BX,1
   cmp word ptr [BX+3C5A],+00
   jz L0ce30608
   mov BX,[BP+06]
   shl BX,1
   mov AX,[BX+3C5A]
   mov [3E30],AX
   push [3E30]
   call far A22d7000a
   pop CX
   mov [398E],DX
   mov [398C],AX
   mov AX,[398C]
   or AX,[398E]
   jz L0ce30608
   xor AX,AX
   push AX
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   push [BX+3D7E]
   push [BX+3D7C]
   push [0DC1]
   call far A23700004
   mov SP,BP
   push [3E30]
   push [398E]
   push [398C]
   push [0DC1]
   call far A2346000d
   mov SP,BP
   cmp AX,FFFF
   jnz L0ce30608
   mov word ptr [398E],0000
   mov word ptr [398C],0000
L0ce30608:
   pop BP
ret far

A0ce3060a:
   push BP
   mov BP,SP
   sub SP,+02
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   call far A0ce30c09
   add SP,+06
   call far A24ce003a
   mov AX,[0DB3]
   or AX,[0DB5]
   jz L0ce3063f
   push [0DB5]
   push [0DB3]
   call far A23f70008
   pop CX
   pop CX
L0ce3063f:
   mov AX,[0DB7]
   or AX,[0DB9]
   jz L0ce30657
   push [0DB9]
   push [0DB7]
   call far A23f70008
   pop CX
   pop CX
L0ce30657:
   mov word ptr [BP-02],0000
jmp near L0ce30688
L0ce3065e:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+3990]
   or AX,[BX+3992]
   jz L0ce30685
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+3992]
   push [BX+3990]
   call far A23f70008
   pop CX
   pop CX
L0ce30685:
   inc word ptr [BP-02]
L0ce30688:
   cmp word ptr [BP-02],+32
   jl L0ce3065e
   mov word ptr [BP-02],0000
jmp near L0ce306bf
L0ce30695:
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   mov AX,[BX+3A5A]
   or AX,[BX+3A5C]
   jz L0ce306bc
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   push [BX+3A5C]
   push [BX+3A5A]
   call far A23f70008
   pop CX
   pop CX
L0ce306bc:
   inc word ptr [BP-02]
L0ce306bf:
   cmp word ptr [BP-02],0080
   jl L0ce30695
   cmp word ptr [0DC1],+00
   jl L0ce306d7
   push [0DC1]
   call far A23410006
   pop CX
L0ce306d7:
   cmp word ptr [0DBF],+00
   jz L0ce306e3
   call far A214203c2
L0ce306e3:
   mov AX,[0C78]
   or AX,[0C7A]
   jz L0ce30700
   push [0C7A]
   push [0C78]
   mov AX,0008
   push AX
   call far A246c001a
   add SP,+06
L0ce30700:
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   call far A0ce30c09
   add SP,+06
   mov SP,BP
   pop BP
ret far

A0ce30716:
   push BP
   mov BP,SP
   sub SP,+0C
   mov word ptr [BP-06],0000
   mov AX,[0DC3]
   or AX,[0DC5]
   jz L0ce30745
   push [0DC5]
   push [0DC3]
   call far A23f70008
   pop CX
   pop CX
   mov word ptr [0DC5],0000
   mov word ptr [0DC3],0000
L0ce30745:
   push SS
   lea AX,[BP-08]
   push AX
   mov AX,0001
   push AX
   push [BP+08]
   push [BP+06]
   call far A231f003f
   add SP,+0A
   mov [BP-08],AX
   cmp word ptr [BP-08],+00
   jl L0ce307c2
   push [BP-08]
   call far A24320001
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   push [BP-04]
   call far A22d7000a
   pop CX
   mov [BP-0A],DX
   mov [BP-0C],AX
   mov AX,[BP-0C]
   or AX,[BP-0A]
   jz L0ce307b9
   les BX,[BP-0C]
   mov [0DC5],ES
   mov [0DC3],BX
   mov word ptr [BP-06],0001
   mov AX,8000
   push AX
   push [BP-0A]
   push [BP-0C]
   push [BP-08]
   call far A23530002
   add SP,+08
   or AX,AX
   jg L0ce307b9
   mov word ptr [BP-06],0000
L0ce307b9:
   push [BP-08]
   call far A23440007
   pop CX
L0ce307c2:
   mov AX,[BP-06]
jmp near L0ce307c7
L0ce307c7:
   mov SP,BP
   pop BP
ret far

A0ce307cb:
   push BP
   mov BP,SP
   sub SP,+0A
   les BX,[0DC3]
   mov AX,[ES:BX+06]
   les BX,[0DC3]
   add BX,AX
   mov [BP-06],ES
   mov [BP-08],BX
   les BX,[0DC3]
   mov AX,[ES:BX+08]
   les BX,[0DC3]
   add BX,AX
   mov [BP-02],ES
   mov [BP-04],BX
   call far A2142033f
   les BX,[0DC3]
   mov AX,[ES:BX+0C]
   cwd
   push DX
   push AX
   mov DX,0012
   mov AX,34DC
   push DX
   push AX
   call far A076a04f2
   mov [BP-0A],AX
   cmp word ptr [0DBD],+00
   jz L0ce30828
   mov AX,[BP-0A]
   mov [0DAA],AX
jmp near L0ce3083a
L0ce30828:
   mov AX,[BP-0A]
   mov BX,0004
   cwd
   idiv BX
   mov DX,[BP-0A]
   sub DX,AX
   mov [0DAA],DX
L0ce3083a:
   mov word ptr [0DA8],0000
   cmp word ptr [BP-08],+00
   jz L0ce3085d
   les BX,[0DC3]
   mov AL,[ES:BX+24]
   push AX
   push [BP-06]
   push [BP-08]
   call far A21420329
   add SP,+06
L0ce3085d:
   push [BP-02]
   push [BP-04]
   call far A21420316
   pop CX
   pop CX
   sti
   push [3E24]
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   call far A0ce30c09
   add SP,+06
   mov SP,BP
   pop BP
ret far

A0ce30882:
   cmp word ptr [0DBF],+00
   jnz L0ce3088b
jmp near L0ce3089f
L0ce3088b:
   cmp word ptr [266E],+00
   jnz L0ce3089f
   mov AX,[0DC3]
   or AX,[0DC5]
   jz L0ce3089f
   push CS
   call near offset A0ce307cb
L0ce3089f:
ret far

A0ce308a0:
   cmp word ptr [0DBF],+00
   jnz L0ce308ac
   mov AX,0001
jmp near L0ce308bc
L0ce308ac:
   cmp word ptr [266E],+00
   jz L0ce308b8
   mov AX,0001
jmp near L0ce308ba
L0ce308b8:
   xor AX,AX
L0ce308ba:
jmp near L0ce308bc
L0ce308bc:
ret far

X0ce308bd:
   cmp word ptr [0DBF],+00
   jz L0ce308d5
   call far A2142036c
   mov word ptr [0DC5],0000
   mov word ptr [0DC3],0000
L0ce308d5:
ret far

A0ce308d6:
   push BP
   mov BP,SP
   cmp word ptr [0DBF],+00
   jnz L0ce308e2
jmp near L0ce308f6
L0ce308e2:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A0ce30716
   mov SP,BP
   or AX,AX
   jz L0ce308f6
   push CS
   call near offset A0ce307cb
L0ce308f6:
   pop BP
ret far

A0ce308f8:
   push BP
   mov BP,SP
   sub SP,+0E
   cmp word ptr [0C6E],+00
   jz L0ce30908
jmp near L0ce309f9
L0ce30908:
   cmp word ptr [0C72],+00
   jz L0ce30928
   mov AX,[BP+06]
   cmp AX,[3E36]
   jl L0ce3091f
   cmp word ptr [3E36],-01
   jnz L0ce30928
L0ce3091f:
   cmp word ptr [BP+06],-01
   jz L0ce30928
jmp near L0ce309f9
L0ce30928:
   cmp word ptr [BP+06],+00
   jge L0ce30935
   cmp word ptr [0C72],+00
   jnz L0ce3094d
L0ce30935:
   mov AX,[BP+06]
   mov [3E36],AX
   mov word ptr [3E22],0000
   mov word ptr [3D7A],0000
   mov word ptr [3E32],0000
L0ce3094d:
   mov word ptr [BP-0E],0000
   mov BX,[BP+10]
   add BX,+10
   shl BX,1
   mov AX,[BX+0C86]
   cwd
   mov [BP-02],DX
   mov [BP-04],AX
   mov word ptr [0C72],0001
L0ce3096b:
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
   jnz L0ce309a0
   cmp word ptr [BP-08],-01
   jnz L0ce309a0
   mov AX,[3D7A]
   shl AX,1
   les BX,[0DB3]
   add BX,AX
   mov word ptr [ES:BX],FFFF
jmp near L0ce309d0
L0ce309a0:
   mov DX,[BP-06]
   mov AX,[BP-08]
   mov CX,[BP-02]
   mov BX,[BP-04]
   call far A076a0390
   mov CL,0A
   call far A076a0595
   mov [BP-0A],DX
   mov [BP-0C],AX
   mov AX,[BP-0C]
   mov DX,[3D7A]
   shl DX,1
   les BX,[0DB3]
   add BX,DX
   mov [ES:BX],AX
L0ce309d0:
   mov AX,[BP+0E]
   mov DX,[3D7A]
   shl DX,1
   les BX,[0DB7]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [3D7A]
   mov AX,[BP-0E]
   cmp AX,[BP+0C]
   jge L0ce309f9
   cmp word ptr [3D7A],2000
   jge L0ce309f9
jmp near L0ce3096b
L0ce309f9:
   mov SP,BP
   pop BP
ret far

A0ce309fd:
   push BP
   mov BP,SP
   sub SP,+0A
   mov word ptr [BP-06],FFFF
   cmp word ptr [0C6E],+00
   jz L0ce30a12
jmp near L0ce30bf9
L0ce30a12:
   cmp word ptr [0C72],+00
   jz L0ce30a32
   mov AX,[BP+06]
   cmp AX,[3E34]
   jl L0ce30a29
   cmp word ptr [3E34],-01
   jnz L0ce30a32
L0ce30a29:
   cmp word ptr [BP+06],-01
   jz L0ce30a32
jmp near L0ce30bf9
L0ce30a32:
   cmp word ptr [BP+06],+00
   jge L0ce30a3f
   cmp word ptr [0C72],+00
   jnz L0ce30a57
L0ce30a3f:
   mov word ptr [0C72],0000
   mov word ptr [3E22],0000
   mov word ptr [3D7A],0000
   mov word ptr [3E32],0000
L0ce30a57:
   mov AX,[BP+06]
   mov [3E34],AX
   mov word ptr [BP-0A],0000
L0ce30a62:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],F0
   jnz L0ce30a8d
   inc word ptr [BP-0A]
   cmp word ptr [38C0],+00
   jz L0ce30a8a
   les BX,[BP+08]
   add BX,[BP-0A]
   mov AL,[ES:BX]
   cbw
   mov [BP-06],AX
   inc word ptr [BP-0A]
jmp near L0ce30a8d
L0ce30a8a:
   inc word ptr [BP-0A]
L0ce30a8d:
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
   jnz L0ce30aee
   mov BX,[BP-08]
   shl BX,1
   mov AX,[BX+0C86]
   mov DX,[3D7A]
   shl DX,1
   les BX,[0DB3]
   add BX,DX
   mov [ES:BX],AX
   mov AX,[BP-04]
   mul word ptr [3E26]
   mov DX,[3D7A]
   shl DX,1
   les BX,[0DB7]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [3D7A]
   mov word ptr [0C72],0001
jmp near L0ce30be2
L0ce30aee:
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+E616],+01
   jge L0ce30aff
   mov AX,0001
jmp near L0ce30b08
L0ce30aff:
   mov BX,[BP-06]
   shl BX,1
   mov AX,[BX+E616]
L0ce30b08:
   mov CL,07
   shl AX,CL
   push AX
   mov AX,[BP-04]
   mul word ptr [3E26]
   pop DX
   sub AX,DX
   mov [BP-02],AX
   cmp word ptr [BP-02],+00
   jle L0ce30b83
   push [BP-08]
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+E616],+01
   jge L0ce30b34
   mov AX,0001
jmp near L0ce30b3d
L0ce30b34:
   mov BX,[BP-06]
   shl BX,1
   mov AX,[BX+E616]
L0ce30b3d:
   push AX
   mov AX,0080
   push AX
   push DS
   mov AX,[BP-06]
   mov CL,07
   shl AX,CL
   shl AX,1
   add AX,BE16
   push AX
   mov AX,FFFF
   push AX
   push CS
   call near offset A0ce308f8
   add SP,+0C
   mov AX,[3D7A]
   shl AX,1
   les BX,[0DB3]
   add BX,AX
   mov word ptr [ES:BX],FFFF
   mov AX,[BP-02]
   mov DX,[3D7A]
   shl DX,1
   les BX,[0DB7]
   add BX,DX
   mov [ES:BX],AX
   inc word ptr [3D7A]
jmp near L0ce30be2
L0ce30b83:
   push [BP-08]
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+E616],+01
   jge L0ce30b97
   mov AX,0001
jmp near L0ce30ba0
L0ce30b97:
   mov BX,[BP-06]
   shl BX,1
   mov AX,[BX+E616]
L0ce30ba0:
   push AX
   mov AX,[BP-04]
   mul word ptr [3E26]
   push AX
   mov BX,[BP-06]
   shl BX,1
   cmp word ptr [BX+E616],+01
   jge L0ce30bba
   mov BX,0001
jmp near L0ce30bc3
L0ce30bba:
   mov BX,[BP-06]
   shl BX,1
   mov BX,[BX+E616]
L0ce30bc3:
   pop AX
   xor DX,DX
   div BX
   push AX
   push DS
   mov AX,[BP-06]
   mov CL,07
   shl AX,CL
   shl AX,1
   add AX,BE16
   push AX
   mov AX,FFFF
   push AX
   push CS
   call near offset A0ce308f8
   add SP,+0C
L0ce30be2:
   les BX,[BP+08]
   add BX,[BP-0A]
   cmp byte ptr [ES:BX],00
   jz L0ce30bf9
   cmp word ptr [3D7A],2000
   jge L0ce30bf9
jmp near L0ce30a62
L0ce30bf9:
   mov SP,BP
   pop BP
ret far

X0ce30bfd:
   mov word ptr [0C72],0000
   call far A24ce003a
ret far

A0ce30c09:
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

A0ce30c47:
   push BP
   mov BP,SP
   sub SP,+02
   cmp word ptr [0C72],+00
   jz L0ce30cc0
   dec word ptr [3E32]
   cmp word ptr [3E32],+00
   jg L0ce30cc0
   mov AX,[3E22]
   cmp AX,[3D7A]
   jl L0ce30c75
   mov word ptr [0C72],0000
   call far A24ce003a
jmp near L0ce30cc0
L0ce30c75:
   mov AX,[3E22]
   shl AX,1
   les BX,[0DB3]
   add BX,AX
   mov AX,[ES:BX]
   mov [BP-02],AX
   cmp word ptr [BP-02],-01
   jnz L0ce30c93
   call far A24ce003a
jmp near L0ce30ca5
L0ce30c93:
   mov AX,[BP-02]
   cmp AX,[3D74]
   jz L0ce30ca5
   push [BP-02]
   call far A24ce000e
   pop CX
L0ce30ca5:
   mov AX,[3E22]
   shl AX,1
   les BX,[0DB7]
   add BX,AX
   mov AX,[ES:BX]
   mov [3E32],AX
   inc word ptr [3E22]
   mov AX,[BP-02]
   mov [3D74],AX
L0ce30cc0:
   mov SP,BP
   pop BP
ret far

Segment 0daf ;; DIGI.ASM:DIGI
A0daf0004:
   sti
   push DS
   push AX
   mov AX,segment A24f10000
   mov DS,AX
   dec word ptr [0DA6]
   cmp word ptr [0DA6],+00
   jle L0daf005a
   cmp word ptr [0C70],+00
   jz L0daf005a
   cmp word ptr [0DBD],+00
   jz L0daf0073
   cmp word ptr [0C80],+00
   jz L0daf005a
   push DX
   push ES
   push BX
   mov DX,[2670]
   add DX,+0C
   in AL,DX
   test AL,80
   jnz L0daf0057
   cli
   mov AL,10
   out DX,AL
   les BX,[3D76]
   inc word ptr [3D76]
   mov AH,[ES:BX]
   dec word ptr [0C80]
L0daf004e:
   in AL,DX
   test AL,80
   jnz L0daf004e
   mov AL,AH
   out DX,AL
   sti
L0daf0057:
   pop BX
   pop ES
   pop DX
L0daf005a:
   dec word ptr [0DAE]
   cmp word ptr [0DAE],+00
   jnz L0daf0068
jmp near L0daf0087
X0daf0067:
   nop
L0daf0068:
   mov AL,20
   out 20,AL
   inc word ptr [0DA6]
   pop AX
   pop DS
iret
L0daf0073:
   push AX
   push BX
   push CX
   push DX
   push ES
   push SI
   push DI
   call far [0C7C]
   pop DI
   pop SI
   pop ES
   pop DX
   pop CX
   pop BX
   pop AX
jmp near L0daf005a
L0daf0087:
   push BP
   push BX
   push CX
   push DX
   push ES
   push SI
   push DI
   mov AX,[0DB0]
   mov [0DAE],AX
   mov CX,[3E1C]
   add [0C82],CX
   adc word ptr [0C84],+00
   add [0DAC],CX
   jnb L0daf00ac
   pushf
   call far [0C78]
L0daf00ac:
   sub [0DA8],CX
   jnb L0daf00cf
   pushf
   call far [3E2C]
   mov BX,[0DAA]
   mov [0DA8],BX
   mov DX,0043
   mov AL,34
   out DX,AL
   mov DX,0040
   mov AX,[3E24]
   out DX,AL
   xchg AL,AH
   out DX,AL
L0daf00cf:
   pop DI
   pop SI
   pop ES
   pop DX
   pop CX
   pop BX
   pop BP
jmp near L0daf0068

Segment 0dbc ;; JOBJ.C:JOBJ
A0dbc0008:
   push BP
   mov BP,SP
   mov word ptr [B2EA],segment A173601d8
   mov word ptr [B2E8],offset A173601d8
   mov word ptr [B150],0010
   mov word ptr [B1DA],0020
   mov [B438],DS
   mov word ptr [B436],offset Y24f10e22
   mov word ptr [BC16],0008
   mov word ptr [B618],0008
   mov word ptr [B6A2],0000
   mov word ptr [B2EE],segment A0dbc0e1a
   mov word ptr [B2EC],offset A0dbc0e1a
   mov word ptr [B152],000C
   mov word ptr [B1DC],000C
   mov [B43C],DS
   mov word ptr [B43A],offset Y24f10e29
   mov word ptr [BC18],0000
   mov word ptr [B61A],0009
   mov word ptr [B6A4],000C
   mov word ptr [B2F2],segment A0dbc1005
   mov word ptr [B2F0],offset A0dbc1005
   mov word ptr [B154],000A
   mov word ptr [B1DE],000A
   mov [B440],DS
   mov word ptr [B43E],offset Y24f10e2f
   mov word ptr [BC1A],4008
   mov word ptr [B61C],000D
   mov word ptr [B6A6],0000
   mov word ptr [B2F6],segment A0dbc0e11
   mov word ptr [B2F4],offset A0dbc0e11
   mov word ptr [B156],0000
   mov word ptr [B1E0],0000
   mov [B444],DS
   mov word ptr [B442],offset Y24f10e35
   mov word ptr [BC1C],0000
   mov word ptr [B61E],0000
   mov word ptr [B6A8],0000
   mov word ptr [B2FA],segment A0dbc13d5
   mov word ptr [B2F8],offset A0dbc13d5
   mov word ptr [B158],0018
   mov word ptr [B1E2],0010
   mov [B448],DS
   mov word ptr [B446],offset Y24f10e3c
   mov word ptr [BC1E],0480
   mov word ptr [B620],003B
   mov word ptr [B6AA],0008
   mov word ptr [B2FE],segment A0dbc178f
   mov word ptr [B2FC],offset A0dbc178f
   mov word ptr [B15A],0010
   mov word ptr [B1E4],000E
   mov [B44C],DS
   mov word ptr [B44A],offset Y24f10e43
   mov word ptr [BC20],0080
   mov word ptr [B622],003C
   mov word ptr [B6AC],0003
   mov word ptr [B302],segment A11be4d25
   mov word ptr [B300],offset A11be4d25
   mov word ptr [B15C],0000
   mov word ptr [B1E6],0000
   mov [B450],DS
   mov word ptr [B44E],offset Y24f10e47
   mov word ptr [BC22],0008
   mov word ptr [B624],0000
   mov word ptr [B6AE],0000
   mov word ptr [B306],segment A0dbc297a
   mov word ptr [B304],offset A0dbc297a
   mov word ptr [B15E],0020
   mov word ptr [B1E8],0020
   mov [B454],DS
   mov word ptr [B452],offset Y24f10e51
   mov word ptr [BC24],0000
   mov word ptr [B626],002B
   mov word ptr [B6B0],0014
   mov word ptr [B30A],segment A0dbc372f
   mov word ptr [B308],offset A0dbc372f
   mov word ptr [B160],0008
   mov word ptr [B1EA],0008
   mov [B458],DS
   mov word ptr [B456],offset Y24f10e57
   mov word ptr [BC26],0480
   mov word ptr [B628],003A
   mov word ptr [B6B2],0002
   mov word ptr [B30E],segment A0dbc1c39
   mov word ptr [B30C],offset A0dbc1c39
   mov word ptr [B162],0010
   mov word ptr [B1EC],0008
   mov [B45C],DS
   mov word ptr [B45A],offset Y24f10e5d
   mov word ptr [BC28],0480
   mov word ptr [B62A],0016
   mov word ptr [B6B4],0003
   mov word ptr [B312],segment A0dbc1d97
   mov word ptr [B310],offset A0dbc1d97
   mov word ptr [B164],0020
   mov word ptr [B1EE],0010
   mov [B460],DS
   mov word ptr [B45E],offset Y24f10e66
   mov word ptr [BC2A],0000
   mov word ptr [B62C],001C
   mov word ptr [B6B6],0000
   mov word ptr [B316],segment A0dbc1e56
   mov word ptr [B314],offset A0dbc1e56
   mov word ptr [B166],0018
   mov word ptr [B1F0],0018
   mov [B464],DS
   mov word ptr [B462],offset Y24f10e6d
   mov word ptr [BC2C],0400
   mov word ptr [B62E],0034
   mov word ptr [B6B8],0005
   mov word ptr [B31A],segment A0dbc1fe8
   mov word ptr [B318],offset A0dbc1fe8
   mov word ptr [B168],0010
   mov word ptr [B1F2],0010
   mov [B468],DS
   mov word ptr [B466],offset Y24f10e75
   mov word ptr [BC2E],0040
   mov word ptr [B630],0000
   mov word ptr [B6BA],0000
   mov word ptr [B31E],segment A0dbc22d6
   mov word ptr [B31C],offset A0dbc22d6
   mov word ptr [B16A],0018
   mov word ptr [B1F4],0020
   mov [B46C],DS
   mov word ptr [B46A],offset Y24f10e7d
   mov word ptr [BC30],0000
   mov word ptr [B632],0039
   mov word ptr [B6BC],0000
   mov word ptr [B322],segment A0dbc2796
   mov word ptr [B320],offset A0dbc2796
   mov word ptr [B16C],0010
   mov word ptr [B1F6],0008
   mov [B470],DS
   mov word ptr [B46E],offset Y24f10e82
   mov word ptr [BC32],0000
   mov word ptr [B634],000E
   mov word ptr [B6BE],0000
   mov word ptr [B326],segment A0dbc28aa
   mov word ptr [B324],offset A0dbc28aa
   mov word ptr [B16E],0010
   mov word ptr [B1F8],0010
   mov [B474],DS
   mov word ptr [B472],offset Y24f10e86
   mov word ptr [BC34],0000
   mov word ptr [B636],0000
   mov word ptr [B6C0],0000
   mov word ptr [B32A],segment A0dbc2351
   mov word ptr [B328],offset A0dbc2351
   mov word ptr [B170],0010
   mov word ptr [B1FA],0018
   mov [B478],DS
   mov word ptr [B476],offset Y24f10e8a
   mov word ptr [BC36],0040
   mov word ptr [B638],000B
   mov word ptr [B6C2],0000
   mov word ptr [B32E],segment A0dbc2d6e
   mov word ptr [B32C],offset A0dbc2d6e
   mov word ptr [B172],0014
   mov word ptr [B1FC],001C
   mov [B47C],DS
   mov word ptr [B47A],offset Y24f10e92
   mov word ptr [BC38],0480
   mov word ptr [B63A],002C
   mov word ptr [B6C4],000C
   mov word ptr [B332],segment A0dbc3146
   mov word ptr [B330],offset A0dbc3146
   mov word ptr [B174],0010
   mov word ptr [B1FE],0010
   mov [B480],DS
   mov word ptr [B47E],offset Y24f10e98
   mov word ptr [BC3A],0000
   mov word ptr [B63C],001A
   mov word ptr [B6C6],0000
   mov word ptr [B336],segment A0dbc328f
   mov word ptr [B334],offset A0dbc328f
   mov word ptr [B176],0010
   mov word ptr [B200],0010
   mov [B484],DS
   mov word ptr [B482],offset Y24f10ea1
   mov word ptr [BC3C],0000
   mov word ptr [B63E],000A
   mov word ptr [B6C8],0000
   mov word ptr [B33A],segment A0dbc33b2
   mov word ptr [B338],offset A0dbc33b2
   mov word ptr [B178],0006
   mov word ptr [B202],0007
   mov [B488],DS
   mov word ptr [B486],offset Y24f10ea7
   mov word ptr [BC3E],0040
   mov word ptr [B640],0000
   mov word ptr [B6CA],0000
   mov word ptr [B33E],segment A0dbc3620
   mov word ptr [B33C],offset A0dbc3620
   mov word ptr [B17A],0008
   mov word ptr [B204],0008
   mov [B48C],DS
   mov word ptr [B48A],offset Y24f10ead
   mov word ptr [BC40],0040
   mov word ptr [B642],0000
   mov word ptr [B6CC],0000
   mov word ptr [B342],segment A0dbc372f
   mov word ptr [B340],offset A0dbc372f
   mov word ptr [B17C],000E
   mov word ptr [B206],000A
   mov [B490],DS
   mov word ptr [B48E],offset Y24f10eb3
   mov word ptr [BC42],0480
   mov word ptr [B644],003F
   mov word ptr [B6CE],000F
   mov word ptr [B346],segment A17361df7
   mov word ptr [B344],offset A17361df7
   mov word ptr [B17E],0004
   mov word ptr [B208],000A
   mov [B494],DS
   mov word ptr [B492],offset Y24f10eb8
   mov word ptr [BC44],0008
   mov word ptr [B646],0010
   mov word ptr [B6D0],0000
   mov word ptr [B34A],segment A0dbc3a41
   mov word ptr [B348],offset A0dbc3a41
   mov word ptr [B180],0010
   mov word ptr [B20A],0018
   mov [B498],DS
   mov word ptr [B496],offset Y24f10ebd
   mov word ptr [BC46],0100
   mov word ptr [B648],0000
   mov word ptr [B6D2],0000
   mov word ptr [B34E],segment A0dbc3de4
   mov word ptr [B34C],offset A0dbc3de4
   mov word ptr [B182],0010
   mov word ptr [B20C],0010
   mov [B49C],DS
   mov word ptr [B49A],offset Y24f10ec2
   mov word ptr [BC48],0100
   mov word ptr [B64A],000E
   mov word ptr [B6D4],0000
   mov word ptr [B352],segment A0dbc2509
   mov word ptr [B350],offset A0dbc2509
   mov word ptr [B184],0000
   mov word ptr [B20E],0000
   mov [B4A0],DS
   mov word ptr [B49E],offset Y24f10ecb
   mov word ptr [BC4A],0100
   mov word ptr [B64C],0000
   mov word ptr [B6D6],0000
   mov word ptr [B356],segment A0dbc34c3
   mov word ptr [B354],offset A0dbc34c3
   mov word ptr [B186],0004
   mov word ptr [B210],0005
   mov [B4A4],DS
   mov word ptr [B4A2],offset Y24f10ed3
   mov word ptr [BC4C],0000
   mov word ptr [B64E],0000
   mov word ptr [B6D8],0000
   mov word ptr [B35A],segment A11be0000
   mov word ptr [B358],offset A11be0000
   mov word ptr [B188],0010
   mov word ptr [B212],0010
   mov [B4A8],DS
   mov word ptr [B4A6],offset Y24f10ed9
   mov word ptr [BC4E],0008
   mov word ptr [B650],0000
   mov word ptr [B6DA],0000
   mov word ptr [B35E],segment A0dbc15ae
   mov word ptr [B35C],offset A0dbc15ae
   mov word ptr [B18A],0020
   mov word ptr [B214],0010
   mov [B4AC],DS
   mov word ptr [B4AA],offset Y24f10edf
   mov word ptr [BC50],0480
   mov word ptr [B652],000A
   mov word ptr [B6DC],0006
   mov word ptr [B362],segment A0dbc1990
   mov word ptr [B360],offset A0dbc1990
   mov word ptr [B18C],0010
   mov word ptr [B216],0010
   mov [B4B0],DS
   mov word ptr [B4AE],offset Y24f10ee3
   mov word ptr [BC52],0480
   mov word ptr [B654],000B
   mov word ptr [B6DE],0004
   mov word ptr [B366],segment A11be0210
   mov word ptr [B364],offset A11be0210
   mov word ptr [B18E],0010
   mov word ptr [B218],0020
   mov [B4B4],DS
   mov word ptr [B4B2],offset Y24f10eeb
   mov word ptr [BC54],0000
   mov word ptr [B656],000C
   mov word ptr [B6E0],0000
   mov word ptr [B36A],segment A11be035b
   mov word ptr [B368],offset A11be035b
   mov word ptr [B190],0010
   mov word ptr [B21A],0010
   mov [B4B8],DS
   mov word ptr [B4B6],offset Y24f10ef0
   mov word ptr [BC56],0008
   mov word ptr [B658],003C
   mov word ptr [B6E2],0000
   mov word ptr [B36E],segment A11be0562
   mov word ptr [B36C],offset A11be0562
   mov word ptr [B192],0010
   mov word ptr [B21C],0010
   mov [B4BC],DS
   mov word ptr [B4BA],offset Y24f10ef7
   mov word ptr [BC58],0000
   mov word ptr [B65A],0009
   mov word ptr [B6E4],0017
   mov word ptr [B372],segment A11be4d3f
   mov word ptr [B370],offset A11be4d3f
   mov word ptr [B194],0010
   mov word ptr [B21E],0010
   mov [B4C0],DS
   mov word ptr [B4BE],offset Y24f10efb
   mov word ptr [BC5A],0008
   mov word ptr [B65C],000E
   mov word ptr [B6E6],0000
   mov word ptr [B376],segment A11be06a6
   mov word ptr [B374],offset A11be06a6
   mov word ptr [B196],0010
   mov word ptr [B220],0010
   mov [B4C4],DS
   mov word ptr [B4C2],offset Y24f10f02
   mov word ptr [BC5C],0000
   mov word ptr [B65E],0000
   mov word ptr [B6E8],0000
   mov word ptr [B37A],segment A11be0aeb
   mov word ptr [B378],offset A11be0aeb
   mov word ptr [B198],0010
   mov word ptr [B222],0020
   mov [B4C8],DS
   mov word ptr [B4C6],offset Y24f10f0a
   mov word ptr [BC5E],0000
   mov word ptr [B660],002E
   mov word ptr [B6EA],0000
   mov word ptr [B37E],segment A11be0c41
   mov word ptr [B37C],offset A11be0c41
   mov word ptr [B19A],0010
   mov word ptr [B224],0020
   mov [B4CC],DS
   mov word ptr [B4CA],offset Y24f10f10
   mov word ptr [BC60],0000
   mov word ptr [B662],000E
   mov word ptr [B6EC],0000
   mov word ptr [B382],segment A11be0d04
   mov word ptr [B380],offset A11be0d04
   mov word ptr [B19C],0010
   mov word ptr [B226],0010
   mov [B4D0],DS
   mov word ptr [B4CE],offset Y24f10f16
   mov word ptr [BC62],0100
   mov word ptr [B664],0000
   mov word ptr [B6EE],0000
   mov word ptr [B386],segment A11be0e7b
   mov word ptr [B384],offset A11be0e7b
   mov word ptr [B19E],0038
   mov word ptr [B228],0010
   mov [B4D4],DS
   mov word ptr [B4D2],offset Y24f10f1d
   mov word ptr [BC64],0400
   mov word ptr [B666],000F
   mov word ptr [B6F0],0023
   mov word ptr [B38A],segment A11be4785
   mov word ptr [B388],offset A11be4785
   mov word ptr [B1A0],0010
   mov word ptr [B22A],0010
   mov [B4D8],DS
   mov word ptr [B4D6],offset Y24f10f23
   mov word ptr [BC66],0000
   mov word ptr [B668],000E
   mov word ptr [B6F2],0000
   mov word ptr [B38E],segment A11be1311
   mov word ptr [B38C],offset A11be1311
   mov word ptr [B1A2],000E
   mov word ptr [B22C],000E
   mov [B4DC],DS
   mov word ptr [B4DA],offset Y24f10f2b
   mov word ptr [BC68],0000
   mov word ptr [B66A],001F
   mov word ptr [B6F4],0000
   mov word ptr [B392],segment A11be170a
   mov word ptr [B390],offset A11be170a
   mov word ptr [B1A4],0014
   mov word ptr [B22E],0018
   mov [B4E0],DS
   mov word ptr [B4DE],offset Y24f10f30
   mov word ptr [BC6A],0100
   mov word ptr [B66C],0021
   mov word ptr [B6F6],0000
   mov word ptr [B396],segment A11be189e
   mov word ptr [B394],offset A11be189e
   mov word ptr [B1A6],001A
   mov word ptr [B230],0020
   mov [B4E4],DS
   mov word ptr [B4E2],offset Y24f10f35
   mov word ptr [BC6C],0480
   mov word ptr [B66E],0023
   mov word ptr [B6F8],0004
   mov word ptr [B39A],segment A11be1c64
   mov word ptr [B398],offset A11be1c64
   mov word ptr [B1A8],0020
   mov word ptr [B232],0020
   mov [B4E8],DS
   mov word ptr [B4E6],offset Y24f10f39
   mov word ptr [BC6E],0100
   mov word ptr [B670],0024
   mov word ptr [B6FA],0000
   mov word ptr [B39E],segment A11be1ec3
   mov word ptr [B39C],offset A11be1ec3
   mov word ptr [B1AA],0010
   mov word ptr [B234],0010
   mov [B4EC],DS
   mov word ptr [B4EA],offset Y24f10f40
   mov word ptr [BC70],0000
   mov word ptr [B672],0025
   mov word ptr [B6FC],000B
   mov word ptr [B3A2],segment A11be2119
   mov word ptr [B3A0],offset A11be2119
   mov word ptr [B1AC],0010
   mov word ptr [B236],0010
   mov [B4F0],DS
   mov word ptr [B4EE],offset Y24f10f48
   mov word ptr [BC72],0000
   mov word ptr [B674],0025
   mov word ptr [B6FE],0000
   mov word ptr [B3A6],segment A11be23a3
   mov word ptr [B3A4],offset A11be23a3
   mov word ptr [B1AE],0010
   mov word ptr [B238],0010
   mov [B4F4],DS
   mov word ptr [B4F2],offset Y24f10f51
   mov word ptr [BC74],0480
   mov word ptr [B676],0026
   mov word ptr [B700],0002
   mov word ptr [B3AA],segment A11be274f
   mov word ptr [B3A8],offset A11be274f
   mov word ptr [B1B0],0040
   mov word ptr [B23A],0008
   mov [B4F8],DS
   mov word ptr [B4F6],offset Y24f10f56
   mov word ptr [BC76],0480
   mov word ptr [B678],0027
   mov word ptr [B702],0003
   mov word ptr [B3AE],segment A11be2aaa
   mov word ptr [B3AC],offset A11be2aaa
   mov word ptr [B1B2],0020
   mov word ptr [B23C],0010
   mov [B4FC],DS
   mov word ptr [B4FA],offset Y24f10f5b
   mov word ptr [BC78],0000
   mov word ptr [B67A],0028
   mov word ptr [B704],0023
   mov word ptr [B3B2],segment A11be2bca
   mov word ptr [B3B0],offset A11be2bca
   mov word ptr [B1B4],0010
   mov word ptr [B23E],0010
   mov [B500],DS
   mov word ptr [B4FE],offset Y24f10f60
   mov word ptr [BC7A],4008
   mov word ptr [B67C],002D
   mov word ptr [B706],0000
   mov word ptr [B3B6],segment A11be30d9
   mov word ptr [B3B4],offset A11be30d9
   mov word ptr [B1B6],0016
   mov word ptr [B240],001A
   mov [B504],DS
   mov word ptr [B502],offset Y24f10f69
   mov word ptr [BC7C],0100
   mov word ptr [B67E],002F
   mov word ptr [B708],0000
   mov word ptr [B3BA],segment A11be3311
   mov word ptr [B3B8],offset A11be3311
   mov word ptr [B1B8],0010
   mov word ptr [B242],0010
   mov [B508],DS
   mov word ptr [B506],offset Y24f10f6f
   mov word ptr [BC7E],0008
   mov word ptr [B680],0031
   mov word ptr [B70A],0000
   mov word ptr [B3BE],segment A11be34b2
   mov word ptr [B3BC],offset A11be34b2
   mov word ptr [B1BA],0010
   mov word ptr [B244],0010
   mov [B50C],DS
   mov word ptr [B50A],offset Y24f10f76
   mov word ptr [BC80],0400
   mov word ptr [B682],0032
   mov word ptr [B70C],0000
   mov word ptr [B3C2],segment A1736210c
   mov word ptr [B3C0],offset A1736210c
   mov word ptr [B1BC],0018
   mov word ptr [B246],0010
   mov [B510],DS
   mov word ptr [B50E],offset Y24f10f7a
   mov word ptr [BC82],0008
   mov word ptr [B684],0033
   mov word ptr [B70E],0000
   mov word ptr [B3C6],segment A17362711
   mov word ptr [B3C4],offset A17362711
   mov word ptr [B1BE],0010
   mov word ptr [B248],0010
   mov [B514],DS
   mov word ptr [B512],offset Y24f10f83
   mov word ptr [BC84],0008
   mov word ptr [B686],0000
   mov word ptr [B710],0000
   mov word ptr [B3CA],segment A17362a6d
   mov word ptr [B3C8],offset A17362a6d
   mov word ptr [B1C0],0010
   mov word ptr [B24A],0010
   mov [B518],DS
   mov word ptr [B516],offset Y24f10f8e
   mov word ptr [BC86],0008
   mov word ptr [B688],000B
   mov word ptr [B712],0000
   mov word ptr [B3CE],segment A1736272a
   mov word ptr [B3CC],offset A1736272a
   mov word ptr [B1C2],000E
   mov word ptr [B24C],000A
   mov [B51C],DS
   mov word ptr [B51A],offset Y24f10f97
   mov word ptr [BC88],0008
   mov word ptr [B68A],003F
   mov word ptr [B714],0000
   mov word ptr [B3D2],segment A11be38e4
   mov word ptr [B3D0],offset A11be38e4
   mov word ptr [B1C4],0008
   mov word ptr [B24E],0008
   mov [B520],DS
   mov word ptr [B51E],offset Y24f10fa0
   mov word ptr [BC8A],0000
   mov word ptr [B68C],0033
   mov word ptr [B716],0000
   mov word ptr [B3D6],segment A11be3a07
   mov word ptr [B3D4],offset A11be3a07
   mov word ptr [B1C6],0010
   mov word ptr [B250],0018
   mov [B524],DS
   mov word ptr [B522],offset Y24f10fa7
   mov word ptr [BC8C],0000
   mov word ptr [B68E],0033
   mov word ptr [B718],0000
   mov word ptr [B3DA],segment A11be3db3
   mov word ptr [B3D8],offset A11be3db3
   mov word ptr [B1C8],001C
   mov word ptr [B252],0010
   mov [B528],DS
   mov word ptr [B526],offset Y24f10fb1
   mov word ptr [BC8E],0000
   mov word ptr [B690],0033
   mov word ptr [B71A],0007
   mov word ptr [B3DE],segment A11be4098
   mov word ptr [B3DC],offset A11be4098
   mov word ptr [B1CA],0010
   mov word ptr [B254],0010
   mov [B52C],DS
   mov word ptr [B52A],offset Y24f10fb9
   mov word ptr [BC90],0100
   mov word ptr [B692],0000
   mov word ptr [B71C],0000
   mov word ptr [B3E2],segment A11be441d
   mov word ptr [B3E0],offset A11be441d
   mov word ptr [B1CC],0010
   mov word ptr [B256],0010
   mov [B530],DS
   mov word ptr [B52E],offset Y24f10fbe
   mov word ptr [BC92],4008
   mov word ptr [B694],001A
   mov word ptr [B71E],0000
   mov word ptr [B3E6],segment A11be469d
   mov word ptr [B3E4],offset A11be469d
   mov word ptr [B1CE],000C
   mov word ptr [B258],0005
   mov [B534],DS
   mov word ptr [B532],offset Y24f10fc9
   mov word ptr [BC94],4008
   mov word ptr [B696],0033
   mov word ptr [B720],0000
   mov word ptr [B3EA],segment A11be4832
   mov word ptr [B3E8],offset A11be4832
   mov word ptr [B1D0],0010
   mov word ptr [B25A],000C
   mov [B538],DS
   mov word ptr [B536],offset Y24f10fd4
   mov word ptr [BC96],0180
   mov word ptr [B698],003E
   mov word ptr [B722],0003
   mov word ptr [B3EE],segment A11be49a9
   mov word ptr [B3EC],offset A11be49a9
   mov word ptr [B1D2],0010
   mov word ptr [B25C],0008
   mov [B53C],DS
   mov word ptr [B53A],offset Y24f10fd8
   mov word ptr [BC98],0000
   mov word ptr [B69A],003D
   mov word ptr [B724],0000
   mov word ptr [B3F2],segment A11be4ba2
   mov word ptr [B3F0],offset A11be4ba2
   mov word ptr [B1D4],0024
   mov word ptr [B25E],0010
   mov [B540],DS
   mov word ptr [B53E],offset Y24f10fe2
   mov word ptr [BC9A],0008
   mov word ptr [B69C],0005
   mov word ptr [B726],0000
   mov word ptr [B3F6],segment A11be4dea
   mov word ptr [B3F4],offset A11be4dea
   mov word ptr [B1D6],0040
   mov word ptr [B260],0010
   mov [B544],DS
   mov word ptr [B542],offset Y24f10fe7
   mov word ptr [BC9C],0000
   mov word ptr [B69E],0003
   mov word ptr [B728],0000
   mov word ptr [B3FA],segment A0dbc2f73
   mov word ptr [B3F8],offset A0dbc2f73
   mov word ptr [B1D8],0010
   mov word ptr [B262],0020
   mov [B548],DS
   mov word ptr [B546],offset Y24f10fef
   mov word ptr [BC9E],0480
   mov word ptr [B6A0],002C
   mov word ptr [B72A],000C
   pop BP
ret far

A0dbc0e11:
   push BP
   mov BP,SP
   xor AX,AX
jmp near L0dbc0e18
L0dbc0e18:
   pop BP
ret far

A0dbc0e1a:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc0e38
   cmp AX,0001
   jnz L0dbc0e30
jmp near L0dbc0f05
L0dbc0e30:
   cmp AX,0002
   jz L0dbc0e96
jmp near L0dbc1002
L0dbc0e38:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B61A]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc1002
L0dbc0e96:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0dbc0ec5
   mov AX,0001
jmp near L0dbc0ec8
L0dbc0ec5:
   mov AX,FFFF
L0dbc0ec8:
   pop DX
   add DX,AX
   and DX,0007
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L0dbc0f00
   mov AX,0001
jmp near L0dbc0f02
L0dbc0f00:
   xor AX,AX
L0dbc0f02:
jmp near L0dbc1002
L0dbc0f05:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L0dbc0f7b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jnz L0dbc0f59
   mov AX,0019
   push AX
   mov AX,0006
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+0D]
   call far A1a400f8a
   pop CX
L0dbc0f59:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1D],0004
   push SI
   call far A1eb7185d
   pop CX
   mov AX,0001
jmp near L0dbc1002
L0dbc0f7b:
   cmp word ptr [BP+0A],+00
   jz L0dbc0f86
   xor AX,AX
jmp near L0dbc1002
L0dbc0f86:
   cmp word ptr [7E42],+08
   jge L0dbc0f91
   inc word ptr [7E42]
L0dbc0f91:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [B6A4]
   call far A1eb71fac
   add SP,+06
   or word ptr [BC12],C000
   mov AX,000B
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   push SI
   call far A1eb7185d
   pop CX
   cmp word ptr [0DCC],+00
   jz L0dbc0ffd
   mov AX,0002
   push AX
   push DS
   mov AX,0FF5
   push AX
   call far A1a4005b7
   add SP,+06
   mov word ptr [0DCC],0000
L0dbc0ffd:
   mov AX,0001
jmp near L0dbc1002
L0dbc1002:
   pop SI
   pop BP
ret far

A0dbc1005:
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov DI,[BP+0A]
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc102a
   cmp AX,0001
   jnz L0dbc1022
jmp near L0dbc12b3
L0dbc1022:
   cmp AX,0002
   jz L0dbc1070
jmp near L0dbc13c8
L0dbc102a:
   mov AX,[B61C]
   mov CL,08
   shl AX,CL
   mov [BP-06],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-06]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc13c8
L0dbc1070:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jg L0dbc1089
jmp near L0dbc1248
L0dbc1089:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+0E
   jg L0dbc10b5
jmp near L0dbc11a8
L0dbc10b5:
   push SS
   lea AX,[BP-02]
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   call far A1eb706ae
   add SP,+0A
   mov AX,[BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+08
   jle L0dbc110d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0008
jmp near L0dbc1138
L0dbc110d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],-08
   jg L0dbc1138
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],FFF8
L0dbc1138:
   mov AX,[BP-02]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+04
   jle L0dbc117d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0004
jmp near L0dbc11a8
L0dbc117d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-04
   jg L0dbc11a8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFC
L0dbc11a8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71c83
   add SP,+06
   neg AX
   sbb AX,AX
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+40
   jle L0dbc1224
   mov AX,0001
jmp near L0dbc1226
L0dbc1224:
   xor AX,AX
L0dbc1226:
   pop DX
   or DX,AX
   jz L0dbc1240
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],FFFF
L0dbc1240:
   mov AX,0001
jmp near L0dbc13c8
X0dbc1246:
jmp near L0dbc12ae
L0dbc1248:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-01
   jnz L0dbc12ae
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71c83
   add SP,+06
   or AX,AX
   jnz L0dbc12a8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
L0dbc12a8:
   mov AX,0001
jmp near L0dbc13c8
L0dbc12ae:
   xor AX,AX
jmp near L0dbc13c8
L0dbc12b3:
   or DI,DI
   jz L0dbc12ba
jmp near L0dbc1339
L0dbc12ba:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jle L0dbc12e6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+0A
   jle L0dbc1333
L0dbc12e6:
   mov AX,0002
   push AX
   call far A1eb71a83
   pop CX
   cmp AX,0003
   jge L0dbc1333
   mov AX,0002
   push AX
   call far A1eb71a0d
   pop CX
   mov AX,0007
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   push SI
   call far A1eb7185d
   pop CX
   cmp word ptr [0DCE],+00
   jz L0dbc1333
   mov AX,0002
   push AX
   push DS
   mov AX,100C
   push AX
   call far A1a4005b7
   add SP,+06
   mov word ptr [0DCE],0000
L0dbc1333:
   mov AX,0001
jmp near L0dbc13c8
L0dbc1339:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],0080
   jz L0dbc13c3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jle L0dbc13c3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],000F
   push DI
   call far A1eb7008b
   pop CX
   mov AX,000A
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L0dbc13c3:
   mov AX,0001
jmp near L0dbc13c8
L0dbc13c8:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

X0dbc13ce:
   push BP
   mov BP,SP
jmp near L0dbc13d3
L0dbc13d3:
   pop BP
ret far

A0dbc13d5:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc13f7
   cmp AX,0001
   jnz L0dbc13ec
jmp near L0dbc14d4
L0dbc13ec:
   cmp AX,0002
   jnz L0dbc13f4
jmp near L0dbc14e4
L0dbc13f4:
jmp near L0dbc15aa
L0dbc13f7:
   mov DI,[B620]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dbc1450
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0dbc1430
   mov AX,0001
jmp near L0dbc1432
L0dbc1430:
   xor AX,AX
L0dbc1432:
   mov DX,000A
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   add DI,AX
jmp near L0dbc149a
L0dbc1450:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dbc1480
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   add AX,0004
   add DI,AX
jmp near L0dbc149a
L0dbc1480:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,000A
   mov DX,[ES:BX+0D]
   sub AX,DX
   add DI,AX
L0dbc149a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc15aa
L0dbc14d4:
   cmp word ptr [BP+0A],+00
   jnz L0dbc14e1
   push SI
   call far A1eb725b2
   pop CX
L0dbc14e1:
jmp near L0dbc15aa
L0dbc14e4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0dbc14fd
jmp near L0dbc1592
L0dbc14fd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0004
   jle L0dbc152e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dbc152e:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L0dbc1590
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0005
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0dbc1590:
jmp near L0dbc15a5
L0dbc1592:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L0dbc15a5:
   mov AX,0001
jmp near L0dbc15aa
L0dbc15aa:
   pop DI
   pop SI
   pop BP
ret far

A0dbc15ae:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc15d0
   cmp AX,0001
   jnz L0dbc15c5
jmp near L0dbc16b5
L0dbc15c5:
   cmp AX,0002
   jnz L0dbc15cd
jmp near L0dbc16c5
L0dbc15cd:
jmp near L0dbc178b
L0dbc15d0:
   mov DI,[B652]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dbc1629
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dbc1609
   mov AX,0001
jmp near L0dbc160b
L0dbc1609:
   xor AX,AX
L0dbc160b:
   mov DX,0005
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   add DI,AX
jmp near L0dbc167b
L0dbc1629:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dbc1660
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   mov DX,0005
   mul DX
   mov DX,000E
   sub DX,AX
   add DI,DX
jmp near L0dbc167b
L0dbc1660:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   mov DX,0005
   mul DX
   dec AX
   add DI,AX
L0dbc167b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc178b
L0dbc16b5:
   cmp word ptr [BP+0A],+00
   jnz L0dbc16c2
   push SI
   call far A1eb725b2
   pop CX
L0dbc16c2:
jmp near L0dbc178b
L0dbc16c5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0dbc16de
jmp near L0dbc1773
L0dbc16de:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0003
   jle L0dbc170f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dbc170f:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L0dbc1771
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0dbc1771:
jmp near L0dbc1786
L0dbc1773:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L0dbc1786:
   mov AX,0001
jmp near L0dbc178b
L0dbc178b:
   pop DI
   pop SI
   pop BP
ret far

A0dbc178f:
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
   mov AX,0DD6
   push AX
   mov CX,0008
   call far A076a05fa
   push SS
   lea AX,[BP-10]
   push AX
   push DS
   mov AX,0DDE
   push AX
   mov CX,0010
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc17d8
   cmp AX,0001
   jnz L0dbc17cd
jmp near L0dbc185d
L0dbc17cd:
   cmp AX,0002
   jnz L0dbc17d5
jmp near L0dbc18ad
L0dbc17d5:
jmp near L0dbc198a
L0dbc17d8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   and BX,0003
   shl BX,1
   lea AX,[BP-18]
   add BX,AX
   mov DI,[SS:BX]
   mov AX,[B622]
   mov CL,08
   shl AX,CL
   add DI,AX
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0dbc181e
   mov AX,0004
jmp near L0dbc1820
L0dbc181e:
   xor AX,AX
L0dbc1820:
   pop DI
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc198a
L0dbc185d:
   cmp word ptr [BP+0A],+00
   jnz L0dbc18aa
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   call far A11be0a58
   add SP,+06
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   call far A1eb705e1
   pop CX
   pop CX
   push SI
   call far A1eb7185d
   pop CX
L0dbc18aa:
jmp near L0dbc198a
L0dbc18ad:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   mov [BP-1C],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+03]
   mov [BP-1A],AX
   push [BP-1A]
   push [BP-1C]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L0dbc1959
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,000F
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L0dbc1959:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,0001
jmp near L0dbc198a
L0dbc198a:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc1990:
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
   mov AX,0DEE
   push AX
   mov CX,0010
   call far A076a05fa
   push SS
   lea AX,[BP-10]
   push AX
   push DS
   mov AX,0DFE
   push AX
   mov CX,0010
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc19d9
   cmp AX,0001
   jnz L0dbc19ce
jmp near L0dbc1a7a
L0dbc19ce:
   cmp AX,0002
   jnz L0dbc19d6
jmp near L0dbc1ad3
L0dbc19d6:
jmp near L0dbc1c33
L0dbc19d9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-20]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[B654]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dbc1a36
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-10]
   add BX,AX
   mov AX,[SS:BX]
jmp near L0dbc1a38
L0dbc1a36:
   xor AX,AX
L0dbc1a38:
   pop DX
   add DX,AX
   mov [BP-24],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-24]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc1c33
L0dbc1a7a:
   cmp word ptr [BP+0A],+00
   jnz L0dbc1ad0
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   call far A11be0a58
   add SP,+06
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   call far A1eb705e1
   pop CX
   pop CX
   xor AX,AX
   push AX
   call far A11be09e0
   pop CX
   push SI
   call far A1eb7185d
   pop CX
L0dbc1ad0:
jmp near L0dbc1c33
L0dbc1ad3:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L0dbc1b0f
   xor AX,AX
jmp near L0dbc1c33
L0dbc1b0f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+05]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-22],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0006
   jz L0dbc1b7d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+07
   jle L0dbc1b92
L0dbc1b7d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dbc1b92:
   push [BP-22]
   push DI
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jz L0dbc1bf5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+05]
   mov AX,0001
   push AX
   push [BP-22]
   push DI
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L0dbc1bf3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0006
L0dbc1bf3:
jmp near L0dbc1c2e
L0dbc1bf5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,000F
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L0dbc1c2e:
   mov AX,0001
jmp near L0dbc1c33
L0dbc1c33:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc1c39:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc1c5b
   cmp AX,0001
   jnz L0dbc1c50
jmp near L0dbc1cd6
L0dbc1c50:
   cmp AX,0002
   jnz L0dbc1c58
jmp near L0dbc1ce6
L0dbc1c58:
jmp near L0dbc1d93
L0dbc1c5b:
   mov DI,[B62A]
   mov CL,08
   shl DI,CL
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dbc1c7f
   mov AX,0001
jmp near L0dbc1c81
L0dbc1c7f:
   xor AX,AX
L0dbc1c81:
   mov DX,0003
   mul DX
   pop DI
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+11]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc1d93
L0dbc1cd6:
   cmp word ptr [BP+0A],+00
   jnz L0dbc1ce3
   push SI
   call far A1eb725b2
   pop CX
L0dbc1ce3:
jmp near L0dbc1d93
L0dbc1ce6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jnz L0dbc1d8f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   xor word ptr [ES:BX+11],0001
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L0dbc1d8a
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0dbc1d8a:
   mov AX,0001
jmp near L0dbc1d93
L0dbc1d8f:
   xor AX,AX
jmp near L0dbc1d93
L0dbc1d93:
   pop DI
   pop SI
   pop BP
ret far

A0dbc1d97:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc1db3
   cmp AX,0001
   jz L0dbc1e0b
   cmp AX,0002
   jz L0dbc1e1c
jmp near L0dbc1e52
L0dbc1db3:
   mov DI,[B62C]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+13]
   add DI,4000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc1e52
L0dbc1e0b:
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   call far A1eb705e1
   pop CX
   pop CX
jmp near L0dbc1e52
L0dbc1e1c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0004
   jle L0dbc1e4d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dbc1e4d:
   mov AX,0001
jmp near L0dbc1e52
L0dbc1e52:
   pop DI
   pop SI
   pop BP
ret far

A0dbc1e56:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc1e78
   cmp AX,0001
   jnz L0dbc1e6d
jmp near L0dbc1f01
L0dbc1e6d:
   cmp AX,0002
   jnz L0dbc1e75
jmp near L0dbc1f11
L0dbc1e75:
jmp near L0dbc1fe4
L0dbc1e78:
   mov DI,[B62E]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0dbc1ead
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   add DI,AX
jmp near L0dbc1ec7
L0dbc1ead:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,0006
   mov DX,[ES:BX+0D]
   sub AX,DX
   add DI,AX
L0dbc1ec7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc1fe4
L0dbc1f01:
   cmp word ptr [BP+0A],+00
   jnz L0dbc1f0e
   push SI
   call far A1eb725b2
   pop CX
L0dbc1f0e:
jmp near L0dbc1fe4
L0dbc1f11:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dbc1f62
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L0dbc1f5f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L0dbc1f5f:
jmp near L0dbc1fdf
L0dbc1f62:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   xor word ptr [ES:BX+11],0001
   mov AX,[ES:BX+11]
   test AX,0001
   jz L0dbc1f84
   xor AX,AX
jmp near L0dbc1fe4
L0dbc1f84:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,[ES:BX+0D]
   cmp AX,0006
   jl L0dbc1fdf
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0dbc1fdf:
   mov AX,0001
jmp near L0dbc1fe4
L0dbc1fe4:
   pop DI
   pop SI
   pop BP
ret far

A0dbc1fe8:
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc200c
   cmp AX,0001
   jnz L0dbc2001
jmp near L0dbc2171
L0dbc2001:
   cmp AX,0002
   jnz L0dbc2009
jmp near L0dbc209c
L0dbc2009:
jmp near L0dbc22d1
L0dbc200c:
   cmp word ptr [13A8],+00
   jnz L0dbc2016
jmp near L0dbc2099
L0dbc2016:
   mov AX,FFFF
   push AX
   mov AX,0005
   push AX
   push [B28E]
   push [B28C]
   call far A0abf0bec
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A23730085
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0004
   push AX
   push [B28E]
   push [B28C]
   call far A0abf078b
   add SP,+0E
L0dbc2099:
jmp near L0dbc22d1
L0dbc209c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   cmp AX,[9147]
   jg L0dbc20cd
jmp near L0dbc216c
L0dbc20cd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[9147]
   add DX,[914F]
   cmp AX,DX
   jl L0dbc20ef
jmp near L0dbc216c
L0dbc20ef:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   cmp AX,[9149]
   jle L0dbc216c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[9149]
   add DX,[9151]
   cmp AX,DX
   jge L0dbc216c
   mov AX,[9147]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,[9149]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L0dbc216c:
   xor AX,AX
jmp near L0dbc22d1
L0dbc2171:
   cmp word ptr [BP+0A],+00
   jz L0dbc217a
jmp near L0dbc22cf
L0dbc217a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+03
   jnz L0dbc21a0
   call far A0b8b07be
   mov word ptr [B784],0002
   xor AX,AX
jmp near L0dbc22d1
L0dbc21a0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[7E40]
   jnz L0dbc21bc
jmp near L0dbc22cd
L0dbc21bc:
   cmp word ptr [0DBD],+00
   jz L0dbc21c8
   mov AX,0005
jmp near L0dbc21de
L0dbc21c8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   add AX,0032
L0dbc21de:
   push AX
   mov AX,0004
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jz L0dbc2216
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov [7E40],AX
L0dbc2216:
   cmp byte ptr [9146],17
   jnz L0dbc2250
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   xor AX,AX
   push AX
   call far A1eb71ace
   add SP,+06
jmp near L0dbc228b
L0dbc2250:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov [9147],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,FFF0
   mov [9149],AX
   mov word ptr [9153],0004
   mov word ptr [9157],0000
L0dbc228b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L0dbc22c8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push DS
   mov AX,B5F8
   push AX
   call far A238d0008
   add SP,+08
L0dbc22c8:
   mov AX,0001
jmp near L0dbc22d1
L0dbc22cd:
jmp near L0dbc22d1
L0dbc22cf:
jmp near L0dbc22d1
L0dbc22d1:
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc22d6:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc22f1
   cmp AX,0001
   jz L0dbc2349
   cmp AX,0002
   jz L0dbc2345
jmp near L0dbc234d
L0dbc22f1:
   mov DI,[B632]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+0D]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc234d
L0dbc2345:
   xor AX,AX
jmp near L0dbc234d
L0dbc2349:
   xor AX,AX
jmp near L0dbc234d
L0dbc234d:
   pop DI
   pop SI
   pop BP
ret far

A0dbc2351:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc2373
   cmp AX,0001
   jnz L0dbc2368
jmp near L0dbc24ad
L0dbc2368:
   cmp AX,0002
   jnz L0dbc2370
jmp near L0dbc23ee
L0dbc2370:
jmp near L0dbc2505
L0dbc2373:
   mov DI,[B638]
   mov CL,08
   shl DI,CL
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0dbc2396
   mov AX,0001
jmp near L0dbc2398
L0dbc2396:
   xor AX,AX
L0dbc2398:
   mov DX,0005
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0D]
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc2505
L0dbc23ee:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jz L0dbc2407
jmp near L0dbc249a
L0dbc2407:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0001
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L0dbc2495
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0dbc2495:
   mov AX,0001
jmp near L0dbc2505
L0dbc249a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+13]
L0dbc24ad:
   cmp word ptr [BP+0A],+00
   jnz L0dbc2503
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jnz L0dbc24ed
   mov AX,0007
   push AX
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far A1a4005b7
   add SP,+06
L0dbc24ed:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1D],0003
L0dbc2503:
jmp near L0dbc2505
L0dbc2505:
   pop DI
   pop SI
   pop BP
ret far

A0dbc2509:
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
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L0dbc2566
   mov AX,008C
jmp near L0dbc2569
L0dbc2566:
   mov AX,01B0
L0dbc2569:
   mov [BP-08],AX
   mov word ptr [BP-06],0000
   mov AX,[BP+08]
   cmp AX,0005
   jbe L0dbc257c
jmp near L0dbc268c
L0dbc257c:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y0dbc2585]
Y0dbc2585:	dw L0dbc2591,L0dbc268c,L0dbc268c,L0dbc2619,L0dbc2607,L0dbc25dd
L0dbc2591:
   cmp word ptr [13A8],+00
   jz L0dbc25da
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0004
   push AX
   mov AX,0123
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
L0dbc25da:
jmp near L0dbc268c
L0dbc25dd:
   mov word ptr [BP-06],0001
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
jmp near L0dbc268c
L0dbc2607:
   mov word ptr [BP-06],0001
   mov AX,[BP-08]
   mov [BP-0C],AX
   mov word ptr [BP-0A],0000
jmp near L0dbc268c
L0dbc2619:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-0E]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-08]
   jnz L0dbc2644
   mov word ptr [BP-0A],0000
   mov AX,[BP-08]
   mov [BP-0C],AX
jmp near L0dbc2666
L0dbc2644:
   mov AX,[BP-08]
   mov [BP-0A],AX
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-0E]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-0C],AX
L0dbc2666:
   mov word ptr [BP-06],0001
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],0F
   jnz L0dbc268a
   push [BP+0A]
   call far A1eb7185d
   pop CX
L0dbc268a:
jmp near L0dbc268c
L0dbc268c:
   cmp word ptr [BP-06],+00
   jnz L0dbc2695
jmp near L0dbc278c
L0dbc2695:
   cmp word ptr [BP-0A],+00
   jz L0dbc269e
jmp near L0dbc271e
L0dbc269e:
   mov word ptr [BP-04],FFFF
jmp near L0dbc2718
L0dbc26a5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mul word ptr [BP-04]
   mov BX,AX
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,SI
   mov DX,001F
   mul DX
   push ES
   push BX
   mov BX,AX
   add BX,9146
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
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   mov AX,[ES:BX+02]
   and AX,0003
   cmp AX,0003
   jnz L0dbc2714
   mov AX,[BP-02]
   mov [BP-0A],AX
L0dbc2714:
   add word ptr [BP-04],+02
L0dbc2718:
   cmp word ptr [BP-04],+01
   jle L0dbc26a5
L0dbc271e:
jmp near L0dbc2769
L0dbc2720:
   mov AX,[BP-0A]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   add [BP-0E],AX
L0dbc2769:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-0E]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0C]
   jz L0dbc2720
   mov AX,0001
jmp near L0dbc2790
L0dbc278c:
   xor AX,AX
jmp near L0dbc2790
L0dbc2790:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc2796:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc27b5
   cmp AX,0001
   jnz L0dbc27ad
jmp near L0dbc2859
L0dbc27ad:
   cmp AX,0002
   jz L0dbc280b
jmp near L0dbc28a6
L0dbc27b5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   add AX,0E06
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc28a6
L0dbc280b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L0dbc2853
   mov DI,0001
jmp near L0dbc2855
L0dbc2853:
   xor DI,DI
L0dbc2855:
   mov AX,DI
jmp near L0dbc28a6
L0dbc2859:
   cmp word ptr [BP+0A],+00
   jz L0dbc2863
   xor AX,AX
jmp near L0dbc28a6
L0dbc2863:
   mov AX,0001
   push AX
   call far A1eb71a0d
   pop CX
   mov AX,0006
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   push SI
   call far A1eb7185d
   pop CX
   cmp word ptr [0DD0],+00
   jz L0dbc28a1
   mov AX,0002
   push AX
   push DS
   mov AX,101F
   push AX
   call far A1a4005b7
   add SP,+06
   mov word ptr [0DD0],0000
L0dbc28a1:
   mov AX,0001
jmp near L0dbc28a6
L0dbc28a6:
   pop DI
   pop SI
   pop BP
ret far

A0dbc28aa:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc28c6
   cmp AX,0001
   jz L0dbc2915
   cmp AX,0002
   jz L0dbc2911
jmp near L0dbc2976
L0dbc28c6:
   cmp word ptr [13A8],+00
   jz L0dbc290f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0004
   push AX
   mov AX,0140
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
L0dbc290f:
jmp near L0dbc2976
L0dbc2911:
   xor AX,AX
jmp near L0dbc2976
L0dbc2915:
   cmp word ptr [BP+0A],+00
   jnz L0dbc2971
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],-01
   jnz L0dbc2936
   mov DI,0004
jmp near L0dbc2954
L0dbc2936:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L0dbc2951
   mov DI,0005
jmp near L0dbc2954
L0dbc2951:
   mov DI,0003
L0dbc2954:
   push SI
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A1eb720e9
   add SP,+06
L0dbc2971:
   mov AX,0001
jmp near L0dbc2976
L0dbc2976:
   pop DI
   pop SI
   pop BP
ret far

A0dbc297a:
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,0E0E
   push AX
   mov CX,000C
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc29b0
   cmp AX,0001
   jnz L0dbc29a5
jmp near L0dbc2c9c
L0dbc29a5:
   cmp AX,0002
   jnz L0dbc29ad
jmp near L0dbc2a3e
L0dbc29ad:
jmp near L0dbc2d69
L0dbc29b0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   mov DX,[B626]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dbc2a21
   mov AX,0001
jmp near L0dbc2a23
L0dbc2a21:
   xor AX,AX
L0dbc2a23:
   shl AX,1
   shl AX,1
   pop DX
   add DX,AX
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc2d69
L0dbc2a3e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,000C
   jl L0dbc2a6f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dbc2a6f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jz L0dbc2ae0
   call far A24940015
   mov BX,0024
   cwd
   idiv BX
   or DX,DX
   jz L0dbc2ae0
jmp near L0dbc2c64
L0dbc2ae0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L0dbc2af9
jmp near L0dbc2c64
L0dbc2af9:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   xor AX,AX
   push AX
   call far A1eb72634
   add SP,+0E
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0012
   push AX
   call far A1eb7188c
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   push AX
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   call far A24940015
   mov BX,0002
   cwd
   idiv BX
   or DX,DX
   jnz L0dbc2c08
   call far A24940015
   mov BX,0005
   cwd
   idiv BX
   add DX,-02
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far A24940015
   mov BX,0005
   cwd
   idiv BX
   add DX,-02
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
jmp near L0dbc2c64
L0dbc2c08:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L0dbc2c64:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L0dbc2c7f
   mov AX,0001
jmp near L0dbc2c81
L0dbc2c7f:
   xor AX,AX
L0dbc2c81:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   sub [ES:BX+0D],AX
   mov AX,0001
jmp near L0dbc2d69
L0dbc2c9c:
   cmp word ptr [BP+0A],+00
   jnz L0dbc2cc2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L0dbc2cc2
   push SI
   call far A1eb725b2
   pop CX
jmp near L0dbc2d64
L0dbc2cc2:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],32
   jz L0dbc2cdb
jmp near L0dbc2d64
L0dbc2cdb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dbc2d4f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,[ES:BX+11]
   cmp AX,0005
   jle L0dbc2d1d
   push SI
   call far A11be09e0
   pop CX
   push SI
   call far A1eb7185d
   pop CX
jmp near L0dbc2d4f
L0dbc2d1d:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   call far A11be0a58
   add SP,+06
L0dbc2d4f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0004
L0dbc2d64:
   mov AX,0001
jmp near L0dbc2d69
L0dbc2d69:
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc2d6e:
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
   mov AX,0E1A
   push AX
   mov CX,0008
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc2da5
   cmp AX,0001
   jnz L0dbc2d9a
jmp near L0dbc2e32
L0dbc2d9a:
   cmp AX,0002
   jnz L0dbc2da2
jmp near L0dbc2e42
L0dbc2da2:
jmp near L0dbc2f6d
L0dbc2da5:
   mov DI,[B63A]
   mov CL,08
   shl DI,CL
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0dbc2dc9
   mov AX,0001
jmp near L0dbc2dcb
L0dbc2dc9:
   xor AX,AX
L0dbc2dcb:
   mov DX,0003
   mul DX
   pop DI
   add DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc2f6d
L0dbc2e32:
   cmp word ptr [BP+0A],+00
   jnz L0dbc2e3f
   push SI
   call far A1eb725b2
   pop CX
L0dbc2e3f:
jmp near L0dbc2f6d
L0dbc2e42:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0010
   jl L0dbc2e73
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dbc2e73:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jz L0dbc2e8f
   xor AX,AX
jmp near L0dbc2f6d
L0dbc2e8f:
   call far A24940015
   mov BX,001E
   cwd
   idiv BX
   or DX,DX
   jnz L0dbc2f0a
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   call far A1eb706ae
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0dbc2f0a:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L0dbc2f59
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L0dbc2f68
L0dbc2f59:
   mov AX,0011
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L0dbc2f68:
   mov AX,0001
jmp near L0dbc2f6d
L0dbc2f6d:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc2f73:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc2f97
   cmp AX,0001
   jnz L0dbc2f8c
jmp near L0dbc3019
L0dbc2f8c:
   cmp AX,0002
   jnz L0dbc2f94
jmp near L0dbc303f
L0dbc2f94:
jmp near L0dbc3141
L0dbc2f97:
   mov AX,[B6A0]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L0dbc2fba
   mov AX,0001
jmp near L0dbc2fbc
L0dbc2fba:
   xor AX,AX
L0dbc2fbc:
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
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   mov [BP-02],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-02]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc3141
L0dbc3019:
   cmp word ptr [BP+0A],+00
   jnz L0dbc303c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L0dbc303c
   push SI
   call far A1eb725b2
   pop CX
L0dbc303c:
jmp near L0dbc3141
L0dbc303f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   call far A24940015
   mov BX,001E
   cwd
   idiv BX
   or DX,DX
   jnz L0dbc30de
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0007
   push DX
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   push SI
   call far A1eb706ae
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0dbc30de:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L0dbc312d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L0dbc313c
L0dbc312d:
   mov AX,0011
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L0dbc313c:
   mov AX,0001
jmp near L0dbc3141
L0dbc3141:
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc3146:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc3161
   cmp AX,0001
   jz L0dbc31bf
   cmp AX,0002
   jz L0dbc31d8
jmp near L0dbc328c
L0dbc3161:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B63C]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc328c
L0dbc31bf:
   cmp word ptr [BP+0A],+00
   jnz L0dbc31d5
   push SI
   call far A1eb725b2
   pop CX
   xor AX,AX
   push AX
   call far A11be09e0
   pop CX
L0dbc31d5:
jmp near L0dbc328c
L0dbc31d8:
   push SI
   call far A1eb71da2
   pop CX
   or AX,AX
   jnz L0dbc31f0
   push SI
   call far A1eb7185d
   pop CX
   mov AX,0001
jmp near L0dbc328c
L0dbc31f0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0008
   jl L0dbc3221
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L0dbc3221:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L0dbc3287
   push SI
   call far A1eb7185d
   pop CX
L0dbc3287:
   mov AX,0001
jmp near L0dbc328c
L0dbc328c:
   pop SI
   pop BP
ret far

A0dbc328f:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc32a9
   cmp AX,0002
   jz L0dbc32e6
jmp near L0dbc33ac
L0dbc32a9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0E0A
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc33ac
L0dbc32e6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L0dbc332c
jmp near L0dbc33a8
L0dbc332c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+05]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-02],AX
   push [BP-02]
   push DI
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L0dbc33a3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L0dbc33a3:
   mov AX,0001
jmp near L0dbc33ac
L0dbc33a8:
   xor AX,AX
jmp near L0dbc33ac
L0dbc33ac:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc33b2:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc33cb
   cmp AX,0002
   jnz L0dbc33c8
jmp near L0dbc3485
L0dbc33c8:
jmp near L0dbc34c0
L0dbc33cb:
   cmp byte ptr [34E9],00
   jnz L0dbc33fa
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push [B28E]
   push [B28C]
   call far A0abf0bec
   add SP,+08
jmp near L0dbc3430
L0dbc33fa:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push [B28E]
   push [B28C]
   call far A0abf0bec
   add SP,+08
L0dbc3430:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [B28E]
   push [B28C]
   call far A0abf078b
   add SP,+0E
jmp near L0dbc34c0
L0dbc3485:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jle L0dbc34bc
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   jg L0dbc34bc
   push SI
   call far A1eb7185d
   pop CX
   mov AX,0001
jmp near L0dbc34c0
L0dbc34bc:
   xor AX,AX
jmp near L0dbc34c0
L0dbc34c0:
   pop SI
   pop BP
ret far

A0dbc34c3:
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc34e0
   cmp AX,0002
   jnz L0dbc34dd
jmp near L0dbc3587
L0dbc34dd:
jmp near L0dbc361a
L0dbc34e0:
   mov AX,FFFF
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   and AX,0003
   inc AX
   push AX
   push [B28E]
   push [B28C]
   call far A0abf0bec
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+0D]
   call far A23730085
   add SP,+08
   xor DI,DI
jmp near L0dbc357d
L0dbc3534:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   inc DI
L0dbc357d:
   cmp byte ptr [SS:BP+DI-0A],00
   jnz L0dbc3534
jmp near L0dbc361a
L0dbc3587:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   jl L0dbc35a7
   push SI
   call far A1eb71da2
   pop CX
   or AX,AX
   jnz L0dbc35b0
L0dbc35a7:
   push SI
   call far A1eb7185d
   pop CX
jmp near L0dbc3618
L0dbc35b0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+01],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+03],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+07]
   mov AX,0001
jmp near L0dbc361a
L0dbc3618:
jmp near L0dbc361a
L0dbc361a:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc3620:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc3639
   cmp AX,0002
   jnz L0dbc3636
jmp near L0dbc36f1
L0dbc3636:
jmp near L0dbc372c
L0dbc3639:
   cmp byte ptr [34E9],00
   jnz L0dbc3668
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push [B28E]
   push [B28C]
   call far A0abf0bec
   add SP,+08
jmp near L0dbc369e
L0dbc3668:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push [B28E]
   push [B28C]
   call far A0abf0bec
   add SP,+08
L0dbc369e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [B28E]
   push [B28C]
   call far A0abf078b
   add SP,+0E
jmp near L0dbc372c
L0dbc36f1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jle L0dbc3728
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   jg L0dbc3728
   push SI
   call far A1eb7185d
   pop CX
   mov AX,0001
jmp near L0dbc372c
L0dbc3728:
   xor AX,AX
jmp near L0dbc372c
L0dbc372c:
   pop SI
   pop BP
ret far

A0dbc372f:
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov SI,[BP+06]
   xor DI,DI
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc3756
   cmp AX,0001
   jnz L0dbc374b
jmp near L0dbc3833
L0dbc374b:
   cmp AX,0002
   jnz L0dbc3753
jmp near L0dbc3843
L0dbc3753:
jmp near L0dbc3a3b
L0dbc3756:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+B618]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L0dbc3791
   mov AX,0001
jmp near L0dbc3793
L0dbc3791:
   xor AX,AX
L0dbc3793:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   mov [BP-06],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L0dbc37f7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L0dbc37cf
   mov AX,0001
jmp near L0dbc37d1
L0dbc37cf:
   xor AX,AX
L0dbc37d1:
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L0dbc37ef
   mov AX,0001
jmp near L0dbc37f1
L0dbc37ef:
   xor AX,AX
L0dbc37f1:
   pop DX
   add DX,AX
   add [BP-06],DX
L0dbc37f7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-06]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc3a3b
L0dbc3833:
   cmp word ptr [BP+0A],+00
   jnz L0dbc3840
   push SI
   call far A1eb725b2
   pop CX
L0dbc3840:
jmp near L0dbc3a3b
L0dbc3843:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dbc38d4
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0010
   jle L0dbc38d1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   call far A1eb706ae
   add SP,+0A
   mov AX,[BP-04]
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF6
   mov DI,0001
L0dbc38d1:
jmp near L0dbc3a37
L0dbc38d4:
   mov DI,0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+07]
   mov AX,[ES:BX+07]
   cmp AX,000C
   jle L0dbc3908
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],000A
L0dbc3908:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   mov [BP-04],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   mov [BP-02],AX
   push [BP-02]
   push [BP-04]
   push SI
   call far A1eb71c83
   add SP,+06
   test AX,0003
   jz L0dbc3975
jmp near L0dbc3a37
L0dbc3975:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L0dbc39a3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
jmp near L0dbc3a37
L0dbc39a3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[BP-02]
   and AX,FFF0
   add AX,0010
   mov DX,[ES:BX+0B]
   sub AX,DX
   mov [BP-02],AX
   push [BP-02]
   push [BP-04]
   push SI
   call far A1eb71c83
   add SP,+06
   push SS
   lea AX,[BP-02]
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   call far A1eb706ae
   add SP,+0A
   mov AX,[BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   mov AX,0012
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L0dbc3a37:
   mov AX,DI
jmp near L0dbc3a3b
L0dbc3a3b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc3a41:
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-02],AX
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc3a9d
   cmp AX,0002
   jnz L0dbc3a92
jmp near L0dbc3bd8
L0dbc3a92:
   cmp AX,0003
   jnz L0dbc3a9a
jmp near L0dbc3c1c
L0dbc3a9a:
jmp near L0dbc3dde
L0dbc3a9d:
   cmp word ptr [13A8],+00
   jz L0dbc3ae6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0004
   push AX
   mov AX,0E05
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
L0dbc3ae6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dbc3aff
jmp near L0dbc3bd5
L0dbc3aff:
   push [BP-02]
   push DI
   call far A1a401486
   pop CX
   pop CX
   mov AX,[BP-02]
   inc AX
   push AX
   push DI
   call far A1a401486
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+0D]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [838E]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [8396]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,[BP-02]
   dec AX
   push AX
   push DI
   call far A1a401486
   pop CX
   pop CX
   mov AX,[BP-02]
   inc AX
   inc AX
   push AX
   push DI
   call far A1a401486
   pop CX
   pop CX
L0dbc3bd5:
jmp near L0dbc3dde
L0dbc3bd8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dbc3bf3
   xor AX,AX
jmp near L0dbc3dde
L0dbc3bf3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,[ES:BX+0D]
   cmp AX,0010
   jle L0dbc3c16
   push SI
   call far A1eb7185d
   pop CX
L0dbc3c16:
   mov AX,0001
jmp near L0dbc3dde
L0dbc3c1c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L0dbc3c37
   xor AX,AX
jmp near L0dbc3dde
L0dbc3c37:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,00BE
   jz L0dbc3c58
jmp near L0dbc3d1e
L0dbc3c58:
   mov AX,0003
   push AX
   call far A1eb71a32
   pop CX
   or AX,AX
   jnz L0dbc3c69
jmp near L0dbc3cfd
L0dbc3c69:
   mov AX,0024
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   cmp word ptr [0DD2],+00
   jz L0dbc3c96
   mov word ptr [0DD2],0000
   mov AX,0001
   push AX
   push DS
   mov AX,1030
   push AX
   call far A1a4005b7
   add SP,+06
L0dbc3c96:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+05]
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,SI
   mov DX,001F
   mul DX
   push ES
   push BX
   mov BX,AX
   add BX,9146
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
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   push SI
   call far A1eb7185d
   pop CX
jmp near L0dbc3d1b
L0dbc3cfd:
   cmp word ptr [0DD4],+00
   jz L0dbc3d1b
   mov AX,0001
   push AX
   push DS
   mov AX,103F
   push AX
   call far A1a4005b7
   add SP,+06
   mov word ptr [0DD4],0000
L0dbc3d1b:
jmp near L0dbc3ddc
L0dbc3d1e:
   mov AX,0001
   push AX
   call far A1eb71a32
   pop CX
   or AX,AX
   jnz L0dbc3d2f
jmp near L0dbc3dbe
L0dbc3d2f:
   cmp word ptr [0DCA],+00
   jz L0dbc3d4d
   mov word ptr [0DCA],0000
   mov AX,0001
   push AX
   push DS
   mov AX,1056
   push AX
   call far A1a4005b7
   add SP,+06
L0dbc3d4d:
   mov AX,000C
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov word ptr [BP-04],0000
jmp near L0dbc3db6
L0dbc3d78:
   mov BX,DI
   dec BX
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,3E40
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
L0dbc3db6:
   cmp word ptr [BP-04],+01
   jle L0dbc3d78
jmp near L0dbc3ddc
L0dbc3dbe:
   cmp word ptr [0DC8],+00
   jz L0dbc3ddc
   mov word ptr [0DC8],0000
   mov AX,0002
   push AX
   push DS
   mov AX,1065
   push AX
   call far A1a4005b7
   add SP,+06
L0dbc3ddc:
jmp near L0dbc3dde
L0dbc3dde:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A0dbc3de4:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L0dbc3e06
   cmp AX,0002
   jz L0dbc3e43
   cmp AX,0003
   jnz L0dbc3e03
jmp near L0dbc3f98
L0dbc3e03:
jmp near L0dbc401a
L0dbc3e06:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0E10
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L0dbc401a
L0dbc3e43:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L0dbc3e5e
   xor AX,AX
jmp near L0dbc401a
L0dbc3e5e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L0dbc3e98
jmp near L0dbc3f17
L0dbc3e98:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jnz L0dbc3f15
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,[BP-02]
   dec AX
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
L0dbc3f15:
jmp near L0dbc3f92
L0dbc3f17:
   mov AX,000E
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
   push SI
   call far A1eb7185d
   pop CX
L0dbc3f92:
   mov AX,0001
jmp near L0dbc401a
L0dbc3f98:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+01]
   mov CL,04
   sar BX,CL
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,SI
   mov DX,001F
   mul DX
   push ES
   push BX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,000D
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L0dbc401a
L0dbc401a:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 11be ;; JOBJ2.C:JOBJ2
A11be0000:
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+0A]
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be0022
   cmp AX,0001
   jnz L11be001a
jmp near L11be00ca
L11be001a:
   cmp AX,0002
   jz L11be0078
jmp near L11be020c
L11be0022:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   mov AX,[BX+1080]
   add AX,0E00
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be020c
L11be0078:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+06
   jnz L11be00c5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71c83
   add SP,+06
   mov AX,0001
jmp near L11be020c
L11be00c5:
   xor AX,AX
jmp near L11be020c
L11be00ca:
   or DI,DI
   jz L11be00d1
jmp near L11be01c4
L11be00d1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   cmp word ptr [BX+1096],+00
   jz L11be0109
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A17362f43
   pop CX
jmp near L11be01bc
L11be0109:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   cmp word ptr [BX+10D8],+00
   jz L11be0169
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   dec word ptr [BX+10D8]
   mov AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   shl BX,1
   push [BX+10AE]
   push [BX+10AC]
   call far A1a4005b7
   add SP,+06
L11be0169:
   mov AX,0019
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+06
   jnz L11be019c
   mov AX,0006
   push AX
   call far A1eb71a83
   pop CX
   or AX,AX
   jnz L11be01bc
L11be019c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A1eb71a0d
   pop CX
   push SI
   call far A1eb7185d
   pop CX
L11be01bc:
   or word ptr [BC12],C000
jmp near L11be020a
L11be01c4:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],44
   jz L11be01ee
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],07
   jnz L11be020a
L11be01ee:
   push SI
   call far A1eb7185d
   pop CX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0001
L11be020a:
jmp near L11be020c
L11be020c:
   pop DI
   pop SI
   pop BP
ret far

A11be0210:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be0231
   cmp AX,0001
   jnz L11be0226
jmp near L11be030e
L11be0226:
   cmp AX,0002
   jnz L11be022e
jmp near L11be02b5
L11be022e:
jmp near L11be0358
L11be0231:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B656]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L11be0297
   mov AX,0001
jmp near L11be0299
L11be0297:
   xor AX,AX
L11be0299:
   mov DX,0006
   mul DX
   pop DX
   add DX,AX
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be0358
L11be02b5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,000C
   jge L11be02e7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jge L11be02ee
L11be02e7:
   push SI
   call far A1eb7185d
   pop CX
L11be02ee:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L11be030a
   mov AX,0001
jmp near L11be030c
L11be030a:
   xor AX,AX
L11be030c:
jmp near L11be0358
L11be030e:
   cmp word ptr [BP+0A],+00
   jnz L11be0356
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jz L11be0356
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   call far A1eb705e1
   pop CX
   pop CX
   xor AX,AX
   push AX
   call far A11be09e0
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L11be0356:
jmp near L11be0358
L11be0358:
   pop SI
   pop BP
ret far

A11be035b:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jnz L11be036c
jmp near L11be0506
L11be036c:
   cmp AX,0001
   jz L11be037c
   cmp AX,0002
   jnz L11be0379
jmp near L11be055b
L11be0379:
jmp near L11be055f
L11be037c:
   cmp word ptr [BP+0A],+00
   jz L11be0385
jmp near L11be0501
L11be0385:
   cmp word ptr [3714],+00
   jz L11be03a2
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L11be03a2:
   cmp word ptr [1078],+00
   jz L11be03c0
   mov word ptr [1078],0000
   mov AX,0002
   push AX
   push DS
   mov AX,12A7
   push AX
   call far A1a4005b7
   add SP,+06
L11be03c0:
   cmp word ptr [3714],+00
   jl L11be03ca
jmp near L11be0462
L11be03ca:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jz L11be03e3
jmp near L11be0462
L11be03e3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,0017
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+01
   jnz L11be043f
   push SI
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A1eb720e9
   add SP,+06
jmp near L11be045f
L11be043f:
   push SI
   mov AX,0005
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A1eb720e9
   add SP,+06
L11be045f:
jmp near L11be0501
L11be0462:
   cmp word ptr [3714],+00
   jg L11be046c
jmp near L11be0501
L11be046c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11be0485
jmp near L11be0501
L11be0485:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,0018
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+01
   jnz L11be04e1
   push SI
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A1eb720e9
   add SP,+06
jmp near L11be0501
L11be04e1:
   push SI
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A1eb720e9
   add SP,+06
L11be0501:
   mov AX,0001
jmp near L11be055f
L11be0506:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B658]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0D]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be055f
L11be055b:
   xor AX,AX
jmp near L11be055f
L11be055f:
   pop SI
   pop BP
ret far

A11be0562:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be0580
   cmp AX,0001
   jnz L11be0578
jmp near L11be062b
L11be0578:
   cmp AX,0002
   jz L11be05e1
jmp near L11be06a3
L11be0580:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B65A]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be06a3
L11be05e1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   and AX,0001
   neg AX
   sbb AX,AX
   inc AX
jmp near L11be06a3
L11be062b:
   cmp word ptr [BP+0A],+00
   jnz L11be06a1
   cmp word ptr [107E],+00
   jz L11be064f
   mov word ptr [107E],0000
   mov AX,0002
   push AX
   push DS
   mov AX,12C6
   push AX
   call far A1a4005b7
   add SP,+06
L11be064f:
   mov AX,0003
   push AX
   call far A1eb71a0d
   pop CX
   mov AX,0010
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [B6E4]
   call far A1eb71fac
   add SP,+06
   push SI
   call far A1eb7185d
   pop CX
L11be06a1:
jmp near L11be06a3
L11be06a3:
   pop SI
   pop BP
ret far

A11be06a6:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be06c1
   cmp AX,0001
   jz L11be0711
   cmp AX,0002
   jz L11be0721
jmp near L11be09dd
L11be06c1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   add AX,0E18
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be09dd
L11be0711:
   cmp word ptr [BP+0A],+00
   jnz L11be071e
   push SI
   call far A1eb725b2
   pop CX
L11be071e:
jmp near L11be09dd
L11be0721:
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   cmp AX,0003
   jz L11be075e
jmp near L11be085a
L11be075e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,[ES:BX+07]
   cmp AX,000C
   jle L11be0790
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11be0790:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71c83
   add SP,+06
   cmp AX,0001
   jz L11be0857
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   dec AX
   and AX,FFF0
   mov DX,0010
   sub DX,[B220]
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71c83
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
L11be0857:
jmp near L11be09d8
L11be085a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jz L11be087f
   mov AX,002D
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be087f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L11be0901
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   call far A1eb706ae
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be0901:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11be0930
   mov AX,0001
jmp near L11be0933
L11be0930:
   mov AX,FFFF
L11be0933:
   pop DX
   add DX,AX
   and DX,0003
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71c83
   add SP,+06
   cmp AX,0001
   jz L11be09d8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be09d8:
   mov AX,0001
jmp near L11be09dd
L11be09dd:
   pop SI
   pop BP
ret far

A11be09e0:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   sub AX,[B224]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+09]
   sub AX,[B19A]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   push DX
   mov AX,0025
   push AX
   call far A1eb7188c
   add SP,+06
   pop SI
   pop BP
ret far

A11be0a58:
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L11be0ae0
L11be0a61:
   push [BP+08]
   push [BP+06]
   mov AX,0024
   push AX
   call far A1eb7188c
   add SP,+06
   call far A24940015
   mov BX,0007
   cwd
   idiv BX
   add DX,-03
   mov AX,[B5F6]
   dec AX
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far A24940015
   mov BX,000B
   cwd
   idiv BX
   add DX,-08
   mov AX,[B5F6]
   dec AX
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   call far A24940015
   mov BX,0003
   cwd
   idiv BX
   mov AX,[B5F6]
   dec AX
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
   inc SI
L11be0ae0:
   cmp SI,[BP+0A]
   jge L11be0ae8
jmp near L11be0a61
L11be0ae8:
   pop SI
   pop BP
ret far

A11be0aeb:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be0b01
   cmp AX,0002
   jz L11be0b7c
jmp near L11be0c3e
L11be0b01:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B660]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be0c3e
L11be0b7c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0028
   jge L11be0ba3
   push SI
   call far A1eb71da2
   pop CX
   or AX,AX
   jnz L11be0bad
L11be0ba3:
   push SI
   call far A1eb7185d
   pop CX
jmp near L11be0c39
L11be0bad:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+07]
   mov AX,[ES:BX+07]
   cmp AX,000C
   jle L11be0bde
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11be0bde:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71ace
   add SP,+06
L11be0c39:
   mov AX,0001
jmp near L11be0c3e
L11be0c3e:
   pop SI
   pop BP
ret far

A11be0c41:
   push BP
   mov BP,SP
   sub SP,+12
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-12]
   push AX
   push DS
   mov AX,10EE
   push AX
   mov CX,0012
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L11be0c6c
   cmp AX,0002
   jz L11be0ccc
jmp near L11be0cff
L11be0c6c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-12]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[B662]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be0cff
L11be0ccc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0009
   jge L11be0cf3
   push SI
   call far A1eb71da2
   pop CX
   or AX,AX
   jnz L11be0cfa
L11be0cf3:
   push SI
   call far A1eb7185d
   pop CX
L11be0cfa:
   mov AX,0001
jmp near L11be0cff
L11be0cff:
   pop SI
   mov SP,BP
   pop BP
ret far

A11be0d04:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   cmp AX,0005
   jbe L11be0d16
jmp near L11be0e78
L11be0d16:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y11be0d1f]
Y11be0d1f:	dw L11be0d2b,L11be0d68,L11be0d80,L11be0e33,L11be0e78,L11be0e33
L11be0d2b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0E21
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be0e78
L11be0d68:
   cmp word ptr [BP+0A],+00
   jnz L11be0d7d
   mov AX,0002
   push AX
   mov AX,0002
   push AX
   call far A1eb705e1
   pop CX
   pop CX
L11be0d7d:
jmp near L11be0e78
L11be0d80:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11be0d99
jmp near L11be0e2f
L11be0d99:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71e6a
   add SP,+06
   or AX,AX
   jnz L11be0df8
   mov AX,001B
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   push SI
   call far A1eb7185d
   pop CX
L11be0df8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,[ES:BX+07]
   cmp AX,0010
   jle L11be0e2a
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0010
L11be0e2a:
   mov AX,0001
jmp near L11be0e78
L11be0e2f:
   xor AX,AX
jmp near L11be0e78
L11be0e33:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11be0e6d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0002
   mov AX,002F
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be0e6d:
   push [BP+0A]
   call far A1eb7185d
   pop CX
jmp near L11be0e78
L11be0e78:
   pop SI
   pop BP
ret far

A11be0e7b:
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
   mov AX,1100
   push AX
   mov CX,0008
   call far A076a05fa
   push SS
   lea AX,[BP-12]
   push AX
   push DS
   mov AX,1108
   push AX
   mov CX,0008
   call far A076a05fa
   push SS
   lea AX,[BP-0A]
   push AX
   push DS
   mov AX,1110
   push AX
   mov CX,0008
   call far A076a05fa
   mov AX,[B666]
   mov CL,08
   shl AX,CL
   mov [BP-02],AX
   mov AX,[BP+08]
   or AX,AX
   jz L11be0ee0
   cmp AX,0001
   jnz L11be0ed5
jmp near L11be1262
L11be0ed5:
   cmp AX,0002
   jnz L11be0edd
jmp near L11be11ba
L11be0edd:
jmp near L11be130b
L11be0ee0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jg L11be0ef9
jmp near L11be1056
L11be0ef9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-1A]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov DI,0001
jmp near L11be0fd5
L11be0f6e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-12]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   inc DI
L11be0fd5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,FFE8
   mov BX,0008
   cwd
   idiv BX
   cmp AX,DI
   jl L11be0ff8
jmp near L11be0f6e
L11be0ff8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-0A]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be11b7
L11be1056:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov DI,0001
jmp near L11be111d
L11be10b5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-12]
   add BX,AX
   mov AX,[SS:BX]
   add AX,[BP-02]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   inc DI
L11be111d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,FFE8
   mov BX,0008
   cwd
   idiv BX
   cmp AX,DI
   jl L11be1140
jmp near L11be10b5
L11be1140:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,000C
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
L11be11b7:
jmp near L11be130b
L11be11ba:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11be11e3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L11be11e3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L11be125c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be125c:
   mov AX,0001
jmp near L11be130b
L11be1262:
   cmp word ptr [BP+0A],+00
   jnz L11be1275
   push SI
   call far A1eb725b2
   pop CX
   mov AX,0001
jmp near L11be130b
L11be1275:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],4000
   jz L11be1309
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11be1309
   push SI
   call far A1eb70127
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0010
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   sub word ptr [ES:BX+09],+08
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+09],+18
   jge L11be12fa
   push SI
   call far A1eb7008b
   pop CX
jmp near L11be1309
L11be12fa:
   mov AX,001F
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be1309:
jmp near L11be130b
L11be130b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be1311:
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   mov [BP-10],AX
   mov word ptr [BP-0E],0001
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,1118
   push AX
   mov CX,000C
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L11be135d
   cmp AX,0001
   jz L11be13b3
   cmp AX,0002
   jz L11be13c3
jmp near L11be1704
L11be135d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B66A]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be1704
L11be13b3:
   cmp word ptr [BP+0A],+00
   jnz L11be13c0
   push SI
   call far A1eb725b2
   pop CX
L11be13c0:
jmp near L11be1704
L11be13c3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov word ptr [BP-16],FFFF
   mov word ptr [BP-14],0060
   xor DI,DI
jmp near L11be14a4
L11be1435:
   mov BX,DI
   shl BX,1
   mov AX,[BX+B786]
   mov [BP-18],AX
   mov AX,[BP-18]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],29
   jnz L11be14a3
   mov AX,[BP-18]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+13]
   jle L11be14a3
   push [BP-18]
   push SI
   call far A1eb7276c
   pop CX
   pop CX
   mov [BP-12],AX
   mov AX,[BP-12]
   cmp AX,[BP-14]
   jge L11be14a3
   mov AX,[BP-18]
   mov [BP-16],AX
   mov AX,[BP-12]
   mov [BP-14],AX
L11be14a3:
   inc DI
L11be14a4:
   cmp DI,[BCA6]
   jl L11be1435
   cmp word ptr [BP-16],+00
   jl L11be14ca
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
   call far A1eb72634
   add SP,+0E
L11be14ca:
   mov AX,[BP-10]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+0C
   jle L11be150d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],000C
L11be150d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],-0C
   jge L11be1538
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],FFF4
L11be1538:
   mov AX,[BP-0E]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+0C
   jle L11be157b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11be157b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-0C
   jge L11be15a6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
L11be15a6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L11be1619
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be1619:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jz L11be1665
jmp near L11be16ff
L11be1665:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+07]
   and DI,FFF0
   add DI,+10
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   sub DI,[ES:BX+0B]
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L11be16ff
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,0009
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be16ff:
   mov AX,0001
jmp near L11be1704
L11be1704:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be170a:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be1728
   cmp AX,0002
   jz L11be177e
   cmp AX,0003
   jnz L11be1725
jmp near L11be1881
L11be1725:
jmp near L11be189b
L11be1728:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B66C]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be189b
L11be177e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11be1799
   xor AX,AX
jmp near L11be189b
L11be1799:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+10
   jle L11be17d8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0010
L11be17d8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jz L11be1826
   mov AX,0001
jmp near L11be189b
L11be1826:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11be186d
   xor AX,AX
jmp near L11be189b
L11be186d:
   mov AX,001C
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,0001
jmp near L11be189b
L11be1881:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,0001
jmp near L11be189b
L11be189b:
   pop SI
   pop BP
ret far

A11be189e:
   push BP
   mov BP,SP
   sub SP,+16
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[B66E]
   mov CL,08
   shl AX,CL
   mov [BP-16],AX
   mov word ptr [BP-14],0000
   xor DI,DI
   push SS
   lea AX,[BP-10]
   push AX
   push DS
   mov AX,1124
   push AX
   mov CX,0008
   call far A076a05fa
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,112C
   push AX
   mov CX,0008
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L11be18f8
   cmp AX,0001
   jnz L11be18ed
jmp near L11be19ce
L11be18ed:
   cmp AX,0002
   jnz L11be18f5
jmp near L11be19de
L11be18f5:
jmp near L11be1c5e
L11be18f8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11be1918
   mov word ptr [BP-14],0006
   mov DI,0002
jmp near L11be198b
L11be1918:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11be197e
   mov AX,0001
jmp near L11be1980
L11be197e:
   xor AX,AX
L11be1980:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   add [BP-16],DX
L11be198b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,DI
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,[BP-14]
   push AX
   push [BP-16]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be1c5e
L11be19ce:
   cmp word ptr [BP+0A],+00
   jnz L11be19db
   push SI
   call far A1eb725b2
   pop CX
L11be19db:
jmp near L11be1c5e
L11be19de:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11be1a8a
   call far A24940015
   mov BX,0028
   cwd
   idiv BX
   or DX,DX
   jz L11be1a34
   xor AX,AX
jmp near L11be1c5e
L11be1a34:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   call far A24940015
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0002
jmp near L11be1c59
L11be1a8a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71c83
   add SP,+06
   mov [BP-12],AX
   cmp word ptr [BP-12],+01
   jnz L11be1b63
   call far A24940015
   mov BX,0023
   cwd
   idiv BX
   or DX,DX
   jnz L11be1b27
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be1b27:
   call far A24940015
   mov BX,0014
   cwd
   idiv BX
   or DX,DX
   jnz L11be1b60
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11be1b60:
jmp near L11be1c59
L11be1b63:
   cmp word ptr [BP-12],+02
   jnz L11be1b96
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L11be1c59
L11be1b96:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far A24940015
   mov BX,0003
   cwd
   idiv BX
   or DX,DX
   jnz L11be1c2f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11be1c2f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   and AX,FFF0
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71c83
   add SP,+06
jmp near L11be1c59
L11be1c2f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11be1c59:
   mov AX,0001
jmp near L11be1c5e
L11be1c5e:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be1c64:
   push BP
   mov BP,SP
   sub SP,+2C
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[B670]
   mov CL,08
   shl DI,CL
   push SS
   lea AX,[BP-2C]
   push AX
   push DS
   mov AX,1134
   push AX
   mov CX,0016
   call far A076a05fa
   push SS
   lea AX,[BP-16]
   push AX
   push DS
   mov AX,114A
   push AX
   mov CX,0016
   call far A076a05fa
   mov AX,[BP+08]
   cmp AX,0005
   jbe L11be1ca6
jmp near L11be1ebd
L11be1ca6:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y11be1caf]
Y11be1caf:	dw L11be1cbb,L11be1e3f,L11be1d34,L11be1df7,L11be1e27,L11be1e0f
L11be1cbb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+11]
   shl BX,1
   lea AX,[BP-16]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be1ebd
L11be1d34:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+06
   jnz L11be1d74
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L11be1d74:
   test word ptr [BC14],0001
   jz L11be1da6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+11]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+05]
   jnz L11be1dab
L11be1da6:
   xor AX,AX
jmp near L11be1ebd
L11be1dab:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,[ES:BX+11]
   cmp AX,000A
   jl L11be1df1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
L11be1df1:
   mov AX,0001
jmp near L11be1ebd
L11be1df7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],000A
jmp near L11be1ebd
L11be1e0f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0006
jmp near L11be1ebd
L11be1e27:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
jmp near L11be1ebd
L11be1e3f:
   cmp word ptr [BP+0A],+00
   jnz L11be1e7d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L11be1e7d
   mov AX,0007
   push AX
   push DS
   mov AX,18D2
   push AX
   call far A1a4005b7
   add SP,+06
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   call far A1eb705e1
   pop CX
   pop CX
jmp near L11be1ebb
L11be1e7d:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],4000
   jz L11be1ebb
   cmp word ptr [107C],+00
   jz L11be1ebb
   mov AX,0002
   push AX
   push DS
   mov AX,12E8
   push AX
   call far A1a4005b7
   add SP,+06
   mov word ptr [107C],0000
L11be1ebb:
jmp near L11be1ebd
L11be1ebd:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be1ec3:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[B672]
   mov CL,08
   shl DI,CL
   mov AX,[BP+08]
   or AX,AX
   jz L11be1eed
   cmp AX,0001
   jnz L11be1ee2
jmp near L11be1f76
L11be1ee2:
   cmp AX,0002
   jnz L11be1eea
jmp near L11be2012
L11be1eea:
jmp near L11be2115
L11be1eed:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+01
   jnz L11be1f06
   inc DI
jmp near L11be1f3c
L11be1f06:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+02
   jnz L11be1f3c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11be1f37
   mov AX,0003
jmp near L11be1f3a
L11be1f37:
   mov AX,0002
L11be1f3a:
   add DI,AX
L11be1f3c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be2115
L11be1f76:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],4000
   jz L11be200f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [B6FC]
   call far A1eb71fac
   add SP,+06
   mov AX,000A
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push CS
   call near offset A11be0a58
   add SP,+06
   push SI
   call far A1eb7185d
   pop CX
   mov AX,0020
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be200f:
jmp near L11be2115
L11be2012:
   mov AX,[BC14]
   and AX,0003
   cmp AX,0002
   jz L11be2020
jmp near L11be2110
L11be2020:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jnz L11be208f
   call far A24940015
   mov BX,0020
   cwd
   idiv BX
   or DX,DX
   jnz L11be2087
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0001
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   call far A1eb706ae
   add SP,+0A
jmp near L11be208c
L11be2087:
   xor AX,AX
jmp near L11be2115
L11be208c:
jmp near L11be2110
L11be208f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0002
   jle L11be2110
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   call far A1eb7188c
   add SP,+06
L11be2110:
   mov AX,0001
jmp near L11be2115
L11be2115:
   pop DI
   pop SI
   pop BP
ret far

A11be2119:
   push BP
   mov BP,SP
   sub SP,+40
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[B674]
   mov CL,08
   shl DI,CL
   push SS
   lea AX,[BP-40]
   push AX
   push DS
   mov AX,1160
   push AX
   mov CX,0040
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L11be2158
   cmp AX,0001
   jnz L11be214d
jmp near L11be21cb
L11be214d:
   cmp AX,0002
   jnz L11be2155
jmp near L11be21db
L11be2155:
jmp near L11be239d
L11be2158:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11be2187
   mov AX,0003
jmp near L11be2189
L11be2187:
   xor AX,AX
L11be2189:
   pop DX
   add DX,AX
   add DX,+04
   add DI,DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be239d
L11be21cb:
   cmp word ptr [BP+0A],+00
   jnz L11be21d8
   push SI
   call far A1eb725b2
   pop CX
L11be21d8:
jmp near L11be239d
L11be21db:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],00A0
   jle L11be2212
   push SI
   call far A1eb7185d
   pop CX
   mov AX,0001
jmp near L11be239d
L11be2212:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0002
   jle L11be2243
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L11be2243:
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0007
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   mov DX,DS
   add AX,0005
   push DX
   push AX
   push SI
   call far A1eb706ae
   add SP,+0A
   call far A24940015
   mov BX,0002
   cwd
   idiv BX
   mov AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far A24940015
   mov BX,0002
   cwd
   idiv BX
   mov AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71d6d
   add SP,+06
   mov AX,0001
jmp near L11be239d
L11be239d:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be23a3:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[B676]
   mov CL,08
   shl DI,CL
   mov AX,[BP+08]
   or AX,AX
   jz L11be23c7
   cmp AX,0001
   jz L11be2416
   cmp AX,0002
   jz L11be2426
jmp near L11be274b
L11be23c7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   add AX,DI
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be274b
L11be2416:
   cmp word ptr [BP+0A],+00
   jnz L11be2423
   push SI
   call far A1eb725b2
   pop CX
L11be2423:
jmp near L11be274b
L11be2426:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11be246b
jmp near L11be257f
L11be246b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L11be24aa
   call far A24940015
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be24aa:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jnz L11be251c
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L11be251c
   call far A24940015
   mov BX,0002
   cwd
   idiv BX
   or DX,DX
   jnz L11be251c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
L11be251c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11be257f
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L11be257f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be257f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jz L11be2598
jmp near L11be2746
L11be2598:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11be25d5
   call far A24940015
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11be25d5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L11be268d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
L11be268d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jz L11be26a7
jmp near L11be2746
L11be26a7:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jz L11be26e1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
jmp near L11be2746
L11be26e1:
   xor AX,AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jz L11be2746
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be2746:
   mov AX,0001
jmp near L11be274b
L11be274b:
   pop DI
   pop SI
   pop BP
ret far

A11be274f:
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
   mov AX,11A0
   push AX
   mov CX,0008
   call far A076a05fa
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,11A8
   push AX
   mov CX,0008
   call far A076a05fa
   mov DI,[B678]
   mov CL,08
   shl DI,CL
   mov AX,[BP+08]
   or AX,AX
   jz L11be27a0
   cmp AX,0001
   jnz L11be2795
jmp near L11be29cd
L11be2795:
   cmp AX,0002
   jnz L11be279d
jmp near L11be2925
L11be279d:
jmp near L11be2aa4
L11be27a0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jg L11be27b9
jmp near L11be286c
L11be27b9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0020
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-14]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-0C]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be2922
L11be286c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0020
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
L11be2922:
jmp near L11be2aa4
L11be2925:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11be294e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L11be294e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push SI
   call far A1eb71f2f
   add SP,+06
   or AX,AX
   jnz L11be29c7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be29c7:
   mov AX,0001
jmp near L11be2aa4
L11be29cd:
   cmp word ptr [BP+0A],+00
   jnz L11be29e0
   push SI
   call far A1eb725b2
   pop CX
   mov AX,0001
jmp near L11be2aa4
L11be29e0:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   test word ptr [ES:BX+02],4000
   jnz L11be2a0d
jmp near L11be2aa2
L11be2a0d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11be2a26
jmp near L11be2aa2
L11be2a26:
   push SI
   call far A1eb70127
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   call far A1eb706ae
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   mul word ptr [BP-04]
   or AX,AX
   jle L11be2a9b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L11be2aa2
L11be2a9b:
   push SI
   call far A1eb7008b
   pop CX
L11be2aa2:
jmp near L11be2aa4
L11be2aa4:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be2aaa:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be2ac5
   cmp AX,0001
   jz L11be2b16
   cmp AX,0002
   jz L11be2b10
jmp near L11be2bc7
L11be2ac5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B67A]
   mov CL,08
   shl AX,CL
   mov DX,[BC14]
   and DX,0007
   add AX,DX
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be2bc7
L11be2b10:
   mov AX,0001
jmp near L11be2bc7
L11be2b16:
   cmp word ptr [BP+0A],+00
   jz L11be2b1f
jmp near L11be2bc5
L11be2b1f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0019
   push AX
   call far A1eb71fac
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,[ES:BX+0D]
   cmp AX,000A
   jle L11be2bb6
   mov AX,000A
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push CS
   call near offset A11be0a58
   add SP,+06
   push SI
   call far A1eb7185d
   pop CX
   mov AX,0030
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L11be2bc5
L11be2bb6:
   mov AX,0020
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be2bc5:
jmp near L11be2bc7
L11be2bc7:
   pop SI
   pop BP
ret far

A11be2bca:
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
   jz L11be2bf6
   cmp AX,0001
   jz L11be2c4c
   cmp AX,0002
   jnz L11be2bf3
jmp near L11be2cb3
L11be2bf3:
jmp near L11be30d3
L11be2bf6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B67C]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be30d3
L11be2c4c:
   cmp word ptr [BP+0A],+00
   jnz L11be2c71
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+07
   jle L11be2c71
   push SI
   call far A1eb7185d
   pop CX
jmp near L11be2cb0
L11be2c71:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],0400
   jz L11be2cb0
   push SI
   call far A1eb7185d
   pop CX
   push [BP+0A]
   call far A1eb7008b
   pop CX
   mov AX,000A
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be2cb0:
jmp near L11be30d3
L11be2cb3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11be2cce
   mov AX,0001
jmp near L11be2cd0
L11be2cce:
   xor AX,AX
L11be2cd0:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11be2cec
   mov AX,0001
jmp near L11be2cee
L11be2cec:
   xor AX,AX
L11be2cee:
   pop DX
   sub DX,AX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+0F]
   mov AX,[ES:BX+0F]
   cmp AX,0040
   jge L11be2d45
   push SI
   call far A1eb71da2
   pop CX
   or AX,AX
   jnz L11be2d52
L11be2d45:
   push SI
   call far A1eb7185d
   pop CX
   mov AX,0001
jmp near L11be30d3
L11be2d52:
   mov word ptr [BP-0A],FFFF
   mov word ptr [BP-08],7FFF
   xor DI,DI
jmp near L11be2dba
L11be2d60:
   mov BX,DI
   shl BX,1
   mov AX,[BX+B786]
   mov [BP-0C],AX
   mov AX,[BP-0C]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],0400
   jz L11be2db9
   cmp word ptr [BP-0C],+00
   jz L11be2db9
   push [BP-0C]
   push SI
   call far A1eb7276c
   pop CX
   pop CX
   mov [BP-06],AX
   mov AX,[BP-06]
   cmp AX,[BP-08]
   jge L11be2db9
   cmp word ptr [BP-06],+60
   jge L11be2db9
   mov AX,[BP-0C]
   mov [BP-0A],AX
   mov AX,[BP-06]
   mov [BP-08],AX
L11be2db9:
   inc DI
L11be2dba:
   cmp DI,[BCA6]
   jl L11be2d60
   cmp word ptr [BP-0A],+00
   jl L11be2de0
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
   call far A1eb72634
   add SP,+0E
L11be2de0:
   mov word ptr [BP-02],0001
   mov AX,[BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+0C
   jle L11be2e28
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],000C
L11be2e28:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],-0C
   jge L11be2e53
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],FFF4
L11be2e53:
   mov AX,[BP-02]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+0C
   jle L11be2e96
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L11be2e96:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-0C
   jge L11be2ec1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
L11be2ec1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb727d7
   add SP,+06
   mov DX,000A
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+0F],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L11be2fa9
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be2fa9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+07]
   and DI,FFF0
   add DI,+10
   sub DI,[B23E]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L11be3094
   mov AX,0023
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,DI
   jz L11be306a
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L11be3094
L11be306a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11be3094:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L11be30ce
   push SI
   call far A1eb7185d
   pop CX
L11be30ce:
   mov AX,0001
jmp near L11be30d3
L11be30d3:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be30d9:
   push BP
   mov BP,SP
   sub SP,+18
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[B67E]
   mov CL,08
   shl DI,CL
   push SS
   lea AX,[BP-18]
   push AX
   push DS
   mov AX,11B0
   push AX
   mov CX,0010
   call far A076a05fa
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,11C0
   push AX
   mov CX,0008
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L11be312a
   cmp AX,0002
   jnz L11be311f
jmp near L11be3267
L11be311f:
   cmp AX,0003
   jnz L11be3127
jmp near L11be32b3
L11be3127:
jmp near L11be330b
L11be312a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11be31a5
jmp near L11be3264
L11be31a5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0005
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+11]
   shl BX,1
   lea AX,[BP-18]
   add BX,AX
   mov AX,[SS:BX]
   add AX,DI
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0006
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,000A
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
L11be3264:
jmp near L11be330b
L11be3267:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11be3282
   xor AX,AX
jmp near L11be330b
L11be3282:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+11],AX
   mov AX,0001
jmp near L11be330b
L11be32b3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11be3307
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
   mov AX,0021
   push AX
   mov AX,0004
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,0001
jmp near L11be330b
L11be3307:
   xor AX,AX
jmp near L11be330b
L11be330b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be3311:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be3332
   cmp AX,0001
   jnz L11be3327
jmp near L11be33ac
L11be3327:
   cmp AX,0002
   jnz L11be332f
jmp near L11be3482
L11be332f:
jmp near L11be34af
L11be3332:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B680]
   mov CL,08
   shl AX,CL
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+0D]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11be3391
   mov AX,0001
jmp near L11be3393
L11be3391:
   xor AX,AX
L11be3393:
   shl AX,1
   pop DX
   add DX,AX
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be34af
L11be33ac:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jz L11be33c5
jmp near L11be3468
L11be33c5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L11be3439
   push SI
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A1eb720e9
   add SP,+06
   mov AX,002C
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L11be3468
L11be3439:
   push SI
   mov AX,0005
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A1eb720e9
   add SP,+06
   mov AX,002C
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be3468:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0003
   mov AX,0001
jmp near L11be34af
L11be3482:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L11be34ab
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+0F]
L11be34ab:
   xor AX,AX
jmp near L11be34af
L11be34af:
   pop SI
   pop BP
ret far

A11be34b2:
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[B682]
   mov CL,08
   shl AX,CL
   mov [BP-0C],AX
   mov AX,[BP+08]
   or AX,AX
   jz L11be350d
   cmp AX,0001
   jz L11be34de
   cmp AX,0002
   jnz L11be34db
jmp near L11be359a
L11be34db:
jmp near L11be38de
L11be34de:
   cmp word ptr [BP+0A],+00
   jnz L11be34ed
   push SI
   call far A1eb725b2
   pop CX
jmp near L11be350a
L11be34ed:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],3E
   jnz L11be350a
   push SI
   call far A1eb7185d
   pop CX
L11be350a:
jmp near L11be38de
L11be350d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11be3528
   inc word ptr [BP-0C]
jmp near L11be355e
L11be3528:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L11be3544
   add word ptr [BP-0C],+03
jmp near L11be355e
L11be3544:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11be355e
   add word ptr [BP-0C],+02
L11be355e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-0C]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be38de
L11be359a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jz L11be35b4
jmp near L11be387e
L11be35b4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jz L11be35ce
jmp near L11be387e
L11be35ce:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,3E40
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
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11be363e
   mov DI,0001
jmp near L11be3640
L11be363e:
   xor DI,DI
L11be3640:
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11be365c
   mov AX,0001
jmp near L11be365e
L11be365c:
   xor AX,AX
L11be365e:
   pop DI
   sub DI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L11be367c
   mov AX,0001
jmp near L11be367e
L11be367c:
   xor AX,AX
L11be367e:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11be369a
   mov AX,0001
jmp near L11be369c
L11be369a:
   xor AX,AX
L11be369c:
   pop DX
   sub DX,AX
   mov [BP-04],DX
   or DI,DI
   jnz L11be36c5
   cmp word ptr [BP-04],+00
   jnz L11be36c5
   call far A24940015
   mov BX,0002
   cwd
   idiv BX
   or DX,DX
   jnz L11be36c0
   mov DI,0001
jmp near L11be36c5
L11be36c0:
   mov word ptr [BP-04],0001
L11be36c5:
   mov BX,[BP-08]
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-06]
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0A]
   jnz L11be36ec
jmp near L11be3829
L11be36ec:
   call far A24940015
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
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-06]
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0A]
   jnz L11be3740
jmp near L11be3829
L11be3740:
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
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-06]
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0A]
   jnz L11be377b
jmp near L11be3829
L11be377b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11be3796
   mov DI,0001
jmp near L11be3798
L11be3796:
   xor DI,DI
L11be3798:
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L11be37b4
   mov AX,0001
jmp near L11be37b6
L11be37b4:
   xor AX,AX
L11be37b6:
   pop DI
   sub DI,AX
   neg DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L11be37d6
   mov AX,0001
jmp near L11be37d8
L11be37d6:
   xor AX,AX
L11be37d8:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L11be37f4
   mov AX,0001
jmp near L11be37f6
L11be37f4:
   xor AX,AX
L11be37f6:
   pop DX
   sub DX,AX
   neg DX
   mov [BP-04],DX
   mov BX,[BP-08]
   add BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-06]
   add AX,[BP-04]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-0A]
   jz L11be3829
   xor DI,DI
   mov word ptr [BP-04],0000
L11be3829:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mul DI
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mul word ptr [BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11be387e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71c83
   add SP,+06
   mov AX,0001
jmp near L11be38de
L11be38de:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be38e4:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be38fa
   cmp AX,0002
   jz L11be3953
jmp near L11be3a04
L11be38fa:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B68C]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   add AX,0006
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be3a04
L11be3953:
   call far A24940015
   mov BX,000F
   cwd
   idiv BX
   or DX,DX
   jnz L11be3975
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
L11be3975:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+02
   jg L11be3996
   push SI
   call far A1eb71da2
   pop CX
   or AX,AX
   jnz L11be399f
L11be3996:
   push SI
   call far A1eb7185d
   pop CX
jmp near L11be39ff
L11be399f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+13]
   dec AX
   push AX
   call far A24940015
   mov BX,0003
   cwd
   idiv BX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+01]
   dec AX
   push AX
   push SI
   call far A1eb725ff
   add SP,+06
   or AX,AX
   jnz L11be39ff
   push SI
   call far A1eb7185d
   pop CX
L11be39ff:
   mov AX,0001
jmp near L11be3a04
L11be3a04:
   pop SI
   pop BP
ret far

A11be3a07:
   push BP
   mov BP,SP
   sub SP,+14
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-14]
   push AX
   push DS
   mov AX,11C8
   push AX
   mov CX,0014
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L11be3a3a
   cmp AX,0001
   jnz L11be3a32
jmp near L11be3d45
L11be3a32:
   cmp AX,0002
   jz L11be3a9b
jmp near L11be3dae
L11be3a3a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   shl BX,1
   lea AX,[BP-14]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[B68E]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be3dae
L11be3a9b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,000A
   jl L11be3acc
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L11be3acc:
   call far A24940015
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   cwd
   xor AX,DX
   sub AX,DX
   cmp AX,0003
   jge L11be3afd
   mov DX,0001
jmp near L11be3aff
L11be3afd:
   xor DX,DX
L11be3aff:
   inc DX
   pop AX
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+06
   jle L11be3b33
   mov AX,0006
jmp near L11be3b46
L11be3b33:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
L11be3b46:
   cmp AX,FFFA
   jge L11be3b50
   mov AX,FFFA
jmp near L11be3b7e
L11be3b50:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+06
   jle L11be3b6b
   mov AX,0006
jmp near L11be3b7e
L11be3b6b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
L11be3b7e:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   call far A24940015
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
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+02
   jge L11be3bbd
   mov AX,0001
jmp near L11be3bbf
L11be3bbd:
   xor AX,AX
L11be3bbf:
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
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+06
   jle L11be3bfa
   mov AX,0006
jmp near L11be3c0d
L11be3bfa:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
L11be3c0d:
   cmp AX,FFFA
   jge L11be3c17
   mov AX,FFFA
jmp near L11be3c45
L11be3c17:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+06
   jle L11be3c32
   mov AX,0006
jmp near L11be3c45
L11be3c32:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
L11be3c45:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb725ff
   add SP,+06
   or AX,AX
   jnz L11be3ccd
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be3ccd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb725ff
   add SP,+06
   or AX,AX
   jnz L11be3d40
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11be3d40:
   mov AX,0001
jmp near L11be3dae
L11be3d45:
   cmp word ptr [BP+0A],+00
   jnz L11be3d54
   push SI
   call far A1eb725b2
   pop CX
jmp near L11be3dac
L11be3d54:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],4000
   jz L11be3dac
   mov AX,0014
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push CS
   call near offset A11be0a58
   add SP,+06
   push SI
   call far A1eb7185d
   pop CX
L11be3dac:
jmp near L11be3dae
L11be3dae:
   pop SI
   mov SP,BP
   pop BP
ret far

A11be3db3:
   push BP
   mov BP,SP
   sub SP,+08
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,11DC
   push AX
   mov CX,0008
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L11be3de9
   cmp AX,0001
   jnz L11be3dde
jmp near L11be405b
L11be3dde:
   cmp AX,0002
   jnz L11be3de6
jmp near L11be3e77
L11be3de6:
jmp near L11be4093
L11be3de9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+13]
   and BX,0003
   shl BX,1
   lea AX,[BP-08]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[B690]
   mov CL,08
   shl DX,CL
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11be3e56
   mov AX,0001
jmp near L11be3e58
L11be3e56:
   xor AX,AX
L11be3e58:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   add DX,+0F
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be4093
L11be3e77:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   call far A24940015
   mov BX,0014
   cwd
   idiv BX
   or DX,DX
   jz L11be3e9c
jmp near L11be3f27
L11be3e9c:
   call far A24940015
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L11be3f02
   call far A24940015
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
jmp near L11be3f27
L11be3f02:
   call far A24940015
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11be3f27:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb725ff
   add SP,+06
   or AX,AX
   jnz L11be3f9a
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L11be3f9a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb725ff
   add SP,+06
   or AX,AX
   jnz L11be400d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11be400d:
   call far A24940015
   mov BX,0004
   cwd
   idiv BX
   or DX,DX
   jnz L11be4056
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,FFFE
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0006
   push AX
   mov AX,003A
   push AX
   call far A1eb7188c
   add SP,+06
L11be4056:
   mov AX,0001
jmp near L11be4093
L11be405b:
   cmp word ptr [BP+0A],+00
   jnz L11be406a
   push SI
   call far A1eb725b2
   pop CX
jmp near L11be4091
L11be406a:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],4000
   jz L11be4091
   push SI
   call far A1eb7008b
   pop CX
L11be4091:
jmp near L11be4093
L11be4093:
   pop SI
   mov SP,BP
   pop BP
ret far

A11be4098:
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov CL,04
   sar DI,CL
   mov AX,[BP+08]
   or AX,AX
   jnz L11be40de
jmp near L11be43db
L11be40de:
   cmp AX,0001
   jz L11be40ee
   cmp AX,0002
   jnz L11be40eb
jmp near L11be42f0
L11be40eb:
jmp near L11be4417
L11be40ee:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],00
   jz L11be4107
jmp near L11be42ea
L11be4107:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0006
   cmp word ptr [107A],+00
   jz L11be413a
   mov word ptr [107A],0000
   mov AX,0002
   push AX
   push DS
   mov AX,1303
   push AX
   call far A1a4005b7
   add SP,+06
L11be413a:
   cmp word ptr [3714],+00
   jl L11be4144
jmp near L11be41ed
L11be4144:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   cmp AX,[3714]
   jz L11be4182
   mov AX,001D
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be4182:
   mov AX,DI
   add AX,FFFE
   mov CL,04
   shl AX,CL
   push AX
   push [9147]
   xor AX,AX
   push AX
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jz L11be41ea
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,FFF0
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71ace
   add SP,+06
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C08A
L11be41ea:
jmp near L11be42d2
L11be41ed:
   cmp word ptr [3714],+00
   jg L11be41f7
jmp near L11be42d2
L11be41f7:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   cmp AX,[3714]
   jz L11be4235
   mov AX,001E
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be4235:
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,DI
   inc AX
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,008A
   jnz L11be42d2
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,3E40
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71ace
   add SP,+06
   mov AX,DI
   mov CL,04
   shl AX,CL
   push AX
   push [9147]
   xor AX,AX
   push AX
   call far A1eb71d6d
   add SP,+06
L11be42d2:
   mov AX,[3714]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0F],AX
L11be42ea:
   mov AX,0001
jmp near L11be4417
L11be42f0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11be4319
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L11be4319:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11be4332
jmp near L11be43d7
L11be4332:
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,DI
   inc AX
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,008A
   jz L11be4354
jmp near L11be43d7
L11be4354:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],-01
   jz L11be43d7
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,3E40
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71ace
   add SP,+06
   mov AX,0001
jmp near L11be4417
L11be43d7:
   xor AX,AX
jmp near L11be4417
L11be43db:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0E2C
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be4417
L11be4417:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be441d:
   push BP
   mov BP,SP
   sub SP,+28
   push SI
   mov SI,[BP+06]
   push SS
   lea AX,[BP-28]
   push AX
   push DS
   mov AX,11E4
   push AX
   mov CX,0028
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L11be4450
   cmp AX,0001
   jnz L11be4448
jmp near L11be4654
L11be4448:
   cmp AX,0002
   jz L11be44a6
jmp near L11be4698
L11be4450:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B694]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+13]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be4698
L11be44a6:
   push SI
   call far A1eb71da2
   pop CX
   or AX,AX
   jnz L11be44be
   push SI
   call far A1eb7185d
   pop CX
   mov AX,0001
jmp near L11be4698
L11be44be:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+0D]
   mov AX,[ES:BX+0D]
   cmp AX,0014
   jl L11be451b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
L11be451b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb727d7
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L11be462c
   push SI
   call far A1eb7185d
   pop CX
jmp near L11be464f
L11be462c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+0F]
   mov AX,[ES:BX+0F]
   cmp AX,0050
   jl L11be464f
   push SI
   call far A1eb7185d
   pop CX
L11be464f:
   mov AX,0001
jmp near L11be4698
L11be4654:
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],0080
   jz L11be4693
   push SI
   call far A1eb7185d
   pop CX
   push [BP+0A]
   call far A1eb7008b
   pop CX
   mov AX,000A
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be4693:
   mov AX,0001
jmp near L11be4698
L11be4698:
   pop SI
   mov SP,BP
   pop BP
ret far

A11be469d:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be46b3
   cmp AX,0002
   jz L11be4717
jmp near L11be4782
L11be46b3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B696]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L11be46fc
   mov AX,0001
jmp near L11be46fe
L11be46fc:
   xor AX,AX
L11be46fe:
   pop DX
   add DX,AX
   add DX,+15
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be4782
L11be4717:
   push SI
   call far A1eb71da2
   pop CX
   or AX,AX
   jnz L11be472d
   push SI
   call far A1eb7185d
   pop CX
   xor AX,AX
jmp near L11be4782
L11be472d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   push AX
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L11be477d
   push SI
   call far A1eb7185d
   pop CX
L11be477d:
   mov AX,0001
jmp near L11be4782
L11be4782:
   pop SI
   pop BP
ret far

A11be4785:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be479b
   cmp AX,0002
   jz L11be47de
jmp near L11be482f
L11be479b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B668]
   mov CL,08
   shl AX,CL
   add AX,0022
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be482f
L11be47de:
   call far A24940015
   mov BX,000C
   cwd
   idiv BX
   or DX,DX
   jnz L11be482b
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   inc AX
   inc AX
   push AX
   mov AX,003A
   push AX
   call far A1eb7188c
   add SP,+06
   mov AX,0001
jmp near L11be482f
L11be482b:
   xor AX,AX
jmp near L11be482f
L11be482f:
   pop SI
   pop BP
ret far

A11be4832:
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[B698]
   mov CL,08
   shl DI,CL
   mov AX,[BP+08]
   or AX,AX
   jz L11be4857
   cmp AX,0002
   jnz L11be4854
jmp near L11be48fd
L11be4854:
jmp near L11be49a3
L11be4857:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   add AX,0005
   push AX
   mov AX,DI
   inc AX
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be49a3
L11be48fd:
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
   call far A1eb72634
   add SP,+0E
   cmp word ptr [BP-02],+01
   jle L11be4924
   mov word ptr [BP-02],0001
jmp near L11be492f
L11be4924:
   mov AX,[BP-02]
   dec AX
   jz L11be492f
   mov word ptr [BP-02],FFFF
L11be492f:
   cmp word ptr [BP-04],-02
   jge L11be493a
   mov word ptr [BP-04],FFFE
L11be493a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   cmp AX,[BP-04]
   jnz L11be496a
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   cmp AX,[BP-02]
   jz L11be499f
L11be496a:
   mov AX,[BP-04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,0001
jmp near L11be49a3
L11be499f:
   xor AX,AX
jmp near L11be49a3
L11be49a3:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A11be49a9:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be49c8
   cmp AX,0001
   jz L11be4a26
   cmp AX,0002
   jnz L11be49c5
jmp near L11be4a84
L11be49c5:
jmp near L11be4b9e
L11be49c8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B69A]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   pop DX
   add DX,AX
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be4b9e
L11be4a26:
   cmp word ptr [BP+0A],+00
   jnz L11be4a81
   mov BX,[9153]
   shl BX,1
   test word ptr [BX+BC06],0002
   jnz L11be4a7a
   push [9149]
   mov AX,[9147]
   add AX,FFF8
   push AX
   xor AX,AX
   push AX
   call far A1eb71d6d
   add SP,+06
   mov DI,AX
   or DI,DI
   jnz L11be4a6e
   push [9149]
   mov AX,[9147]
   add AX,0008
   push AX
   xor AX,AX
   push AX
   call far A1eb71d6d
   add SP,+06
   mov DI,AX
L11be4a6e:
   mov word ptr [9153],0000
   mov word ptr [9155],0000
L11be4a7a:
   push SI
   call far A1eb725b2
   pop CX
L11be4a81:
jmp near L11be4b9e
L11be4a84:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L11be4adb
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0002
L11be4adb:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72328
   add SP,+08
   or AX,AX
   jnz L11be4b6f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71ace
   add SP,+06
jmp near L11be4b99
L11be4b6f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   neg AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L11be4b99:
   mov AX,0001
jmp near L11be4b9e
L11be4b9e:
   pop DI
   pop SI
   pop BP
ret far

A11be4ba2:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be4bc0
   cmp AX,0001
   jnz L11be4bb8
jmp near L11be4c74
L11be4bb8:
   cmp AX,0002
   jz L11be4c22
jmp near L11be4d22
L11be4bc0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   inc AX
   inc AX
   push AX
   mov AX,[B69C]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L11be4d22
L11be4c22:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0006
   jl L11be4c53
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L11be4c53:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+13],0001
   jnz L11be4c6f
   mov AX,0001
jmp near L11be4c71
L11be4c6f:
   xor AX,AX
L11be4c71:
jmp near L11be4d22
L11be4c74:
   cmp word ptr [BP+0A],+00
   jz L11be4c7d
jmp near L11be4d1d
L11be4c7d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L11be4c96
jmp near L11be4d1d
L11be4c96:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,0006
   push AX
   call far A1eb71fac
   add SP,+06
   mov AX,0020
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,0005
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push CS
   call near offset A11be0a58
   add SP,+06
L11be4d1d:
   mov AX,0001
jmp near L11be4d22
L11be4d22:
   pop SI
   pop BP
ret far

A11be4d25:
   push BP
   mov BP,SP
   mov AX,[BP+08]
   or AX,AX
   jz L11be4d36
   cmp AX,0001
   jz L11be4d38
jmp near L11be4d3d
L11be4d36:
jmp near L11be4d3d
L11be4d38:
   mov AX,0001
jmp near L11be4d3d
L11be4d3d:
   pop BP
ret far

A11be4d3f:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L11be4d5a
   cmp AX,0001
   jz L11be4d88
   cmp AX,0002
   jz L11be4d5d
jmp near L11be4de7
L11be4d5a:
jmp near L11be4de7
L11be4d5d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jle L11be4d86
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+0D]
L11be4d86:
jmp near L11be4de7
L11be4d88:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jnz L11be4dd0
   mov AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far A1a4005b7
   add SP,+06
   mov AX,0014
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L11be4dd0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0008
jmp near L11be4de7
L11be4de7:
   pop SI
   pop BP
ret far

A11be4dea:
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
   mov AX,120C
   push AX
   mov CX,0004
   call far A076a05fa
   push SS
   lea AX,[BP-04]
   push AX
   push DS
   mov AX,1210
   push AX
   mov CX,0004
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L11be4e2b
   cmp AX,0002
   jnz L11be4e28
jmp near L11be4ecc
L11be4e28:
jmp near L11be4f20
L11be4e2b:
   cmp byte ptr [34E9],00
   jnz L11be4e35
jmp near L11be4eca
L11be4e35:
   xor DI,DI
jmp near L11be4ea6
L11be4e39:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+05]
   shl BX,1
   lea AX,[BP-08]
   add BX,AX
   mov AX,[SS:BX]
   mov DX,[B69E]
   mov CL,08
   shl DX,CL
   add AX,DX
   add AX,DI
   add AX,4000
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   inc DI
L11be4ea6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+05]
   shl BX,1
   lea AX,[BP-04]
   add BX,AX
   mov AX,[SS:BX]
   cmp AX,DI
   jle L11be4eca
jmp near L11be4e39
L11be4eca:
jmp near L11be4f20
L11be4ecc:
   cmp word ptr [13A8],+00
   jnz L11be4f1b
   les BX,[B28C]
   mov AX,[ES:BX+08]
   add AX,[B54A]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+01],AX
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   add AX,[B54C]
   add AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
L11be4f1b:
   mov AX,0001
jmp near L11be4f20
L11be4f20:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 16b0 ;; JOBJ3.C:JOBJ3
A16b00006:
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   mov DI,[BP+06]
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov SI,[ES:BX]
   and SI,3FFF
   mov AX,[BC14]
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
   jnz L16b00051
jmp near L16b004ad
L16b00051:
   cmp AX,0001
   jz L16b00061
   cmp AX,0002
   jnz L16b0005e
jmp near L16b00112
L16b0005e:
jmp near L16b00863
L16b00061:
   cmp SI,0186
   jl L16b00088
   cmp SI,018B
   jg L16b00088
   mov AX,0001
   push AX
   mov AX,0010
   push AX
   call far A1eb705e1
   pop CX
   pop CX
   xor AX,AX
   push AX
   call far A11be09e0
   pop CX
jmp near L16b0010f
L16b00088:
   cmp SI,0141
   jz L16b000a6
   cmp SI,0142
   jz L16b000a6
   cmp SI,0155
   jz L16b000a6
   cmp SI,0156
   jz L16b000a6
   cmp SI,00A6
   jnz L16b000b7
L16b000a6:
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   call far A1eb705e1
   pop CX
   pop CX
jmp near L16b0010f
L16b000b7:
   cmp SI,0190
   jl L16b000e2
   cmp SI,0197
   jg L16b000e2
   cmp byte ptr [9146],39
   jz L16b000e0
   cmp byte ptr [9146],36
   jz L16b000e0
   mov AX,0001
   push AX
   mov AX,0010
   push AX
   call far A1eb705e1
   pop CX
   pop CX
L16b000e0:
jmp near L16b0010f
L16b000e2:
   cmp SI,0198
   jl L16b0010f
   cmp SI,01A3
   jg L16b0010f
   mov AX,[BC14]
   sub AX,[3E38]
   cmp AX,000A
   jle L16b00109
   mov AX,0004
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L16b00109:
   mov AX,[BC14]
   mov [3E38],AX
L16b0010f:
jmp near L16b00863
L16b00112:
   cmp SI,0186
   jge L16b0011b
jmp near L16b0019e
L16b0011b:
   cmp SI,018A
   jle L16b00124
jmp near L16b0019e
L16b00124:
   cmp word ptr [BP-0A],+00
   jnz L16b0019e
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,3E40
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
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,018A
   jle L16b00195
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C186
L16b00195:
   mov AX,0001
jmp near L16b00867
X16b0019b:
jmp near L16b004aa
L16b0019e:
   cmp SI,00BE
   jnz L16b001b7
   cmp word ptr [BP-0A],+01
   jnz L16b001af
   mov AX,0001
jmp near L16b001b1
L16b001af:
   xor AX,AX
L16b001b1:
jmp near L16b00867
X16b001b4:
jmp near L16b004aa
L16b001b7:
   cmp SI,+6E
   jnz L16b001cb
   cmp word ptr [BP-0A],+03
   jnz L16b001cb
   mov AX,0001
jmp near L16b00867
X16b001c8:
jmp near L16b004aa
L16b001cb:
   cmp SI,00A6
   jnz L16b001e0
   cmp word ptr [BP-0A],+01
   jnz L16b001e0
   mov AX,0001
jmp near L16b00867
X16b001dd:
jmp near L16b004aa
L16b001e0:
   cmp SI,0081
   jnz L16b00237
   mov AX,[BC14]
   and AX,0007
   cmp AX,0002
   jnz L16b00237
   mov AX,[BC14]
   sar AX,1
   sar AX,1
   sar AX,1
   and AX,000F
   mov [BP-0A],AX
   or word ptr [8290],0002
   mov BX,[BP-0A]
   shl BX,1
   mov AX,[BX+1322]
   mov DX,[828E]
   and DX,FF00
   add AX,DX
   mov [828E],AX
   cmp word ptr [BP-0A],+08
   jl L16b00228
   cmp word ptr [BP-0A],+0D
   jl L16b0022e
L16b00228:
   xor word ptr [8290],0002
L16b0022e:
   mov AX,0001
jmp near L16b00867
X16b00234:
jmp near L16b004aa
L16b00237:
   cmp SI,015F
   jz L16b00246
   cmp SI,0160
   jz L16b00246
jmp near L16b002ee
L16b00246:
   cmp SI,0160
   jnz L16b00259
   mov AX,[BC14]
   sub AX,DI
   and AX,001F
   mov [BP-04],AX
jmp near L16b00264
L16b00259:
   mov AX,[BC14]
   add AX,DI
   and AX,001F
   mov [BP-04],AX
L16b00264:
   cmp word ptr [BP-04],+10
   jge L16b00273
   mov AX,0001
jmp near L16b00867
X16b00270:
jmp near L16b002eb
L16b00273:
   cmp word ptr [BP-04],+10
   jnz L16b002eb
   cmp SI,015F
   jnz L16b002af
   mov AX,[BP-06]
   sub AX,[B218]
   push AX
   push [BP-08]
   mov AX,001F
   push AX
   call far A1eb7188c
   add SP,+06
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFF
jmp near L16b002dc
L16b002af:
   mov AX,[BP-06]
   add AX,0010
   push AX
   push [BP-08]
   mov AX,001F
   push AX
   call far A1eb7188c
   add SP,+06
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0001
L16b002dc:
   mov AX,001A
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L16b002eb:
jmp near L16b004aa
L16b002ee:
   cmp SI,+21
   jnz L16b00346
   mov AX,[BC14]
   and AX,003F
   mov DX,DI
   and DX,003F
   cmp AX,DX
   jnz L16b00346
   mov AX,[BP-06]
   sub AX,[B218]
   add AX,0008
   push AX
   push [BP-08]
   mov AX,001F
   push AX
   call far A1eb7188c
   add SP,+06
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFF
   mov AX,001A
   push AX
   mov AX,0003
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L16b004aa
L16b00346:
   cmp SI,0190
   jge L16b0034f
jmp near L16b0048f
L16b0034f:
   cmp SI,01A5
   jle L16b00358
jmp near L16b0048f
L16b00358:
   test word ptr [BP-0A],0001
   jnz L16b00362
jmp near L16b0048f
L16b00362:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,3E40
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
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   sub AX,0194
   cmp AX,0012
   jbe L16b003bb
jmp near L16b00487
L16b003bb:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y16b003c4]
Y16b003c4:	dw L16b003ea,L16b00487,L16b00487,L16b00487,L16b00405,L16b00487,L16b00487,L16b00487
		dw L16b0041f,L16b00487,L16b00487,L16b00487,L16b00439,L16b00487,L16b00487,L16b00453
		dw L16b00487,L16b00487,L16b0046d
L16b003ea:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C190
jmp near L16b00487
L16b00405:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C194
jmp near L16b00487
L16b0041f:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C198
jmp near L16b00487
L16b00439:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C19C
jmp near L16b00487
L16b00453:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C1A0
jmp near L16b00487
L16b0046d:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+08]
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C1A3
jmp near L16b00487
L16b00487:
   mov AX,0001
jmp near L16b00867
X16b0048d:
jmp near L16b004aa
L16b0048f:
   cmp SI,+14
   jl L16b004aa
   cmp SI,+17
   jg L16b004aa
   mov AX,[BC14]
   and AX,0007
   cmp AX,0002
   jnz L16b004aa
   mov AX,0001
jmp near L16b00867
L16b004aa:
jmp near L16b00863
L16b004ad:
   cmp SI,015F
   jz L16b004b9
   cmp SI,0160
   jnz L16b00521
L16b004b9:
   mov BX,SI
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   mov AX,[ES:BX]
   mov [BP-02],AX
   cmp SI,0160
   jnz L16b004e0
   mov AX,[BC14]
   sub AX,DI
   and AX,001F
   mov [BP-04],AX
jmp near L16b004eb
L16b004e0:
   mov AX,[BC14]
   add AX,DI
   and AX,001F
   mov [BP-04],AX
L16b004eb:
   cmp word ptr [BP-04],+10
   jge L16b00505
   mov AX,[BP-04]
   mov BX,0004
   cwd
   idiv BX
   mov BX,AX
   shl BX,1
   mov AX,[BX+1342]
   add [BP-02],AX
L16b00505:
   push [BP-06]
   push [BP-08]
   push [BP-02]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b00521:
   cmp SI,+64
   jl L16b00599
   cmp SI,+66
   jg L16b00599
   push [BP-06]
   push [BP-08]
   mov BX,DI
   dec BX
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,7E86
   push DS
   pop ES
   push [ES:BX]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   push [BP-06]
   push [BP-08]
   mov BX,SI
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   mov AX,[ES:BX]
   xor AX,4000
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b00599:
   cmp SI,+67
   jl L16b00611
   cmp SI,+69
   jg L16b00611
   push [BP-06]
   push [BP-08]
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,7E86
   push DS
   pop ES
   push [ES:BX]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   push [BP-06]
   push [BP-08]
   mov BX,SI
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   mov AX,[ES:BX]
   xor AX,4000
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b00611:
   cmp SI,00BE
   jnz L16b0063f
   push [BP-06]
   push [BP-08]
   mov AX,[BC14]
   sar AX,1
   sar AX,1
   and AX,0003
   add AX,[8476]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b0063f:
   cmp SI,00A6
   jnz L16b0066d
   push [BP-06]
   push [BP-08]
   mov AX,[BC14]
   sar AX,1
   sar AX,1
   and AX,0003
   add AX,[83B6]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b0066d:
   cmp SI,+6E
   jnz L16b0069a
   push [BP-06]
   push [BP-08]
   mov AX,[BC14]
   sar AX,1
   sar AX,1
   and AX,0003
   add AX,[81F6]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b0069a:
   cmp SI,+2D
   jnz L16b006cd
   push [BP-06]
   push [BP-08]
   mov BX,SI
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   mov AX,[ES:BX]
   xor AX,4000
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b006cd:
   cmp SI,+14
   jge L16b006d5
jmp near L16b00861
L16b006d5:
   cmp SI,+17
   jle L16b006dd
jmp near L16b00861
L16b006dd:
   mov AX,[BC14]
   sar AX,1
   sar AX,1
   sar AX,1
   sub AX,[BP+08]
   mov BX,0003
   cwd
   idiv BX
   mov [BP-04],DX
   cmp word ptr [BP-04],+00
   jge L16b006fc
   add word ptr [BP-04],+03
L16b006fc:
   push [BP-06]
   push [BP-08]
   mov BX,SI
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   mov AX,[ES:BX]
   add AX,[BP-04]
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov word ptr [BP-04],0001
   mov word ptr [BP-02],0000
   mov AX,[BP+08]
   dec AX
   mov [BP-06],AX
jmp near L16b00783
L16b0073a:
   mov AX,DI
   dec AX
   mov [BP-08],AX
jmp near L16b00778
L16b00742:
   mov BX,[BP-08]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-06]
   shl AX,1
   add BX,AX
   mov SI,[ES:BX]
   and SI,3FFF
   cmp SI,+14
   jl L16b00767
   cmp SI,+17
   jle L16b0076d
L16b00767:
   mov AX,[BP-04]
   add [BP-02],AX
L16b0076d:
   mov AX,[BP-04]
   shl AX,1
   mov [BP-04],AX
   inc word ptr [BP-08]
L16b00778:
   mov AX,DI
   inc AX
   cmp AX,[BP-08]
   jge L16b00742
   inc word ptr [BP-06]
L16b00783:
   mov AX,[BP+08]
   inc AX
   cmp AX,[BP-06]
   jge L16b0073a
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
   jnz L16b007c7
   push [BP-06]
   push [BP-08]
   mov AX,2A05
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b007c7:
   mov AX,[BP-02]
   and AX,000A
   cmp AX,000A
   jnz L16b007ee
   push [BP-06]
   push [BP-08]
   mov AX,2A01
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b007ee:
   mov AX,[BP-02]
   and AX,0022
   cmp AX,0022
   jnz L16b00815
   push [BP-06]
   push [BP-08]
   mov AX,2A02
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b00815:
   mov AX,[BP-02]
   and AX,0088
   cmp AX,0088
   jnz L16b0083c
   push [BP-06]
   push [BP-08]
   mov AX,2A03
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L16b00861
L16b0083c:
   mov AX,[BP-02]
   and AX,00A0
   cmp AX,00A0
   jnz L16b00861
   push [BP-06]
   push [BP-08]
   mov AX,2A04
   push AX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
L16b00861:
jmp near L16b00863
L16b00863:
   xor AX,AX
jmp near L16b00867
L16b00867:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1736 ;; JPLAYER.C:JPLAYER
A1736000d:
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov SI,0008
   cmp word ptr [914F],+04
   jnz L1736002f
   mov AL,[34E9]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jz L1736002f
   mov SI,0004
L1736002f:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   add AX,0058
   cmp AX,[9147]
   jle L17360054
   les BX,[B28C]
   cmp word ptr [ES:BX+08],+08
   jl L17360052
   mov AX,SI
   neg AX
   mov [B54A],AX
L17360052:
jmp near L1736008b
L17360054:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov DX,[B432]
   mov CL,04
   shl DX,CL
   add AX,DX
   add AX,FF98
   cmp AX,[9147]
   jge L1736008b
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov DX,0080
   sub DX,[B432]
   dec DX
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jge L1736008b
   mov [B54A],SI
L1736008b:
   mov AX,0040
   sub AX,[B434]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[B434]
   mov CL,04
   shl DX,CL
   mov BX,[9149]
   sub BX,DX
   add BX,+60
   cmp AX,BX
   jge L173600ba
   mov AX,0040
   sub AX,[B434]
   inc AX
   mov CL,04
   shl AX,CL
jmp near L173600cb
L173600ba:
   mov AX,[B434]
   mov CL,04
   shl AX,CL
   push AX
   mov AX,[9149]
   pop DX
   sub AX,DX
   add AX,0060
L173600cb:
   or AX,AX
   jge L173600d3
   xor DI,DI
jmp near L17360112
L173600d3:
   mov AX,0040
   sub AX,[B434]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[B434]
   mov CL,04
   shl DX,CL
   mov BX,[9149]
   sub BX,DX
   add BX,+60
   cmp AX,BX
   jge L17360102
   mov DI,0040
   sub DI,[B434]
   inc DI
   mov CL,04
   shl DI,CL
jmp near L17360112
L17360102:
   mov AX,[B434]
   mov CL,04
   shl AX,CL
   mov DI,[9149]
   sub DI,AX
   add DI,+60
L17360112:
   mov AX,0040
   sub AX,[B434]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[9149]
   add DX,-20
   cmp AX,DX
   jge L17360137
   mov AX,0040
   sub AX,[B434]
   inc AX
   mov CL,04
   shl AX,CL
jmp near L1736013d
L17360137:
   mov AX,[9149]
   add AX,FFE0
L1736013d:
   or AX,AX
   jge L17360145
   xor AX,AX
jmp near L17360170
L17360145:
   mov AX,0040
   sub AX,[B434]
   inc AX
   mov CL,04
   shl AX,CL
   mov DX,[9149]
   add DX,-20
   cmp AX,DX
   jge L1736016a
   mov AX,0040
   sub AX,[B434]
   inc AX
   mov CL,04
   shl AX,CL
jmp near L17360170
L1736016a:
   mov AX,[9149]
   add AX,FFE0
L17360170:
   mov [BP-04],AX
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   add AX,[BP+06]
   mov [BP-02],AX
   mov AX,[BP-02]
   cmp AX,DI
   jl L17360198
   mov AX,[BP-02]
   cmp AX,[BP-04]
   jg L17360198
   mov AX,[BP+06]
   mov [B54C],AX
jmp near L173601d2
L17360198:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   cmp AX,[BP-04]
   jle L173601b7
   les BX,[B28C]
   mov AX,[BP-04]
   mov DX,[ES:BX+0A]
   sub AX,DX
   mov [B54C],AX
jmp near L173601d2
L173601b7:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   cmp AX,DI
   jge L173601d2
   les BX,[B28C]
   mov AX,DI
   mov DX,[ES:BX+0A]
   sub AX,DX
   mov [B54C],AX
L173601d2:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A173601d8:
   push BP
   mov BP,SP
   sub SP,+30
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,[B618]
   mov CL,08
   shl DI,CL
   mov word ptr [BP-2C],0000
   push SS
   lea AX,[BP-28]
   push AX
   push DS
   mov AX,136A
   push AX
   mov CX,0007
   call far A076a05fa
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,1371
   push AX
   mov CX,0007
   call far A076a05fa
   push SS
   lea AX,[BP-18]
   push AX
   push DS
   mov AX,1378
   push AX
   mov CX,0015
   call far A076a05fa
   mov word ptr [BP-02],0000
   cmp word ptr [BP+08],+00
   jz L17360234
jmp near L1736083b
L17360234:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   cmp AX,0005
   jbe L1736024f
jmp near L17360792
L1736024f:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y17360258]
Y17360258:	dw L17360264,L17360792,L173604bd,L17360599,L173605ba,L17360673
L17360264:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jge L173602e7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L17360295
   add DI,+3C
jmp near L173602b7
L17360295:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jle L173602b0
   mov AX,0008
jmp near L173602b2
L173602b0:
   xor AX,AX
L173602b2:
   add AX,0024
   add DI,AX
L173602b7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-04
   jz L173602e3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-05
   jnz L173602e4
L173602e3:
   inc DI
L173602e4:
jmp near L173604ba
L173602e7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L17360303
   add DI,+13
jmp near L173604ba
L17360303:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+03
   jnz L1736031f
   add DI,+3D
jmp near L173604ba
L1736031f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L1736033b
   add DI,+12
jmp near L173604ba
L1736033b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L17360383
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L1736036a
jmp near L17360447
L1736036a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+03
   jge L17360383
jmp near L17360447
L17360383:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+14
   jge L173603d3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jz L173603d3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jle L173603ca
   mov AX,0001
jmp near L173603cc
L173603ca:
   xor AX,AX
L173603cc:
   add AX,0014
   add DI,AX
jmp near L17360444
L173603d3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],010C
   jle L17360425
   mov BX,[3E3A]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,134A
   push DS
   pop ES
   mov AX,SI
   mov DX,001F
   mul DX
   push ES
   push BX
   mov BX,AX
   add BX,9146
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
jmp near L17360444
L17360425:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],0096
   jle L17360441
   add DI,+11
jmp near L17360444
L17360441:
   add DI,+10
L17360444:
jmp near L173604ba
L17360447:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+08
   jnz L17360481
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L17360478
   mov AX,0001
jmp near L1736047a
L17360478:
   xor AX,AX
L1736047a:
   add AX,0014
   add DI,AX
jmp near L173604ba
L17360481:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   and AX,0007
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L173604b3
   mov AX,0008
jmp near L173604b5
L173604b3:
   xor AX,AX
L173604b5:
   pop DX
   add DX,AX
   add DI,DX
L173604ba:
jmp near L17360792
L173604bd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L17360529
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jnz L173604ee
   add DI,+38
jmp near L17360527
L173604ee:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+01
   jnz L17360509
   add DI,+39
jmp near L17360527
L17360509:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L17360524
   add DI,+3A
jmp near L17360527
L17360524:
   add DI,+3C
L17360527:
jmp near L17360596
L17360529:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jnz L17360544
   add DI,+20
jmp near L1736057d
L17360544:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+01
   jnz L1736055f
   add DI,+21
jmp near L1736057d
L1736055f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L1736057a
   add DI,+22
jmp near L1736057d
L1736057a:
   add DI,+24
L1736057d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L17360596
   add DI,+08
L17360596:
jmp near L17360792
L17360599:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+0F]
   lea AX,[BP-28]
   add BX,AX
   mov AL,[SS:BX]
   cbw
   add DI,AX
jmp near L17360792
L173605ba:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+10
   jge L173605d5
   add DI,+13
jmp near L173605f3
L173605d5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+18
   jge L173605f0
   add DI,+10
jmp near L173605f3
L173605f0:
   add DI,+12
L173605f3:
   mov AX,0010
   push AX
   push [B28E]
   push [B28C]
   push DS
   mov AX,B420
   push AX
   call far A23900001
   add SP,+0A
   les BX,[B28C]
   mov AX,[9149]
   add AX,[9151]
   mov DX,[ES:BX+0A]
   sub AX,DX
   mov [B426],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0021
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   sub AX,[ES:BX+11]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push DS
   mov AX,B420
   push AX
   call far A087600de
   add SP,+0A
   mov AX,0001
jmp near L17361df1
L17360673:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jnz L173606cc
   add DI,+42
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,0001
jmp near L17361df1
X173606c9:
jmp near L17360790
L173606cc:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0F]
   or AX,AX
   jz L173606f0
   cmp AX,0001
   jz L17360711
   cmp AX,0002
   jz L17360731
jmp near L17360790
L173606f0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+11]
   mov BX,0004
   cwd
   idiv BX
   add AX,0030
   add DI,AX
jmp near L17360790
L17360711:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+11]
   mov BX,0004
   cwd
   idiv BX
   add AX,0040
   add DI,AX
jmp near L17360790
L17360731:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,0001
jmp near L17361df1
L17360790:
jmp near L17360792
L17360792:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push DI
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jle L17360838
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,001A
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   mov BX,0002
   cwd
   idiv BX
   mov DX,0E29
   sub DX,AX
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
L17360838:
jmp near L17361df1
L1736083b:
   cmp word ptr [BP+08],+02
   jz L17360844
jmp near L17361dd1
L17360844:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   cmp AX,0005
   jbe L1736085f
jmp near L17361ad2
L1736085f:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y17360868]
Y17360868:	dw L17360874,L17361ad2,L1736138c,L17361709,L1736113f,L173611e6
L17360874:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L173608d5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],FFFF
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
L173608d5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jz L17360943
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L17360906
   mov AX,0001
jmp near L17360908
L17360906:
   xor AX,AX
L17360908:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L17360924
   mov AX,0001
jmp near L17360926
L17360924:
   xor AX,AX
L17360926:
   pop DX
   sub DX,AX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   sub [ES:BX+07],AX
   mov word ptr [BP-2C],0001
L17360943:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jge L1736098c
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],-01
   jnz L17360989
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0003
L17360989:
jmp near L17360cea
L1736098c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L173609a5
jmp near L17360b50
L173609a5:
   cmp word ptr [3712],+00
   jz L173609fe
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0007
   mov AX,[3712]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
   mov word ptr [BP-2C],0001
jmp near L17361ad2
X173609fb:
jmp near L17360aca
L173609fe:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],012C
   jle L17360a47
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0014
   mov word ptr [BP-2C],0001
jmp near L17360aca
L17360a47:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],010C
   jl L17360a65
   mov word ptr [BP-2C],0001
jmp near L17360aca
L17360a65:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],0102
   jnz L17360aaf
   call far A24940015
   mov BX,0004
   cwd
   idiv BX
   mov [3E3A],DX
   mov AX,0002
   push AX
   mov BX,[3E3A]
   shl BX,1
   shl BX,1
   push [BX+2315]
   push [BX+2313]
   call far A1a4005b7
   add SP,+06
   mov word ptr [B14E],0019
jmp near L17360aca
L17360aaf:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+03
   jnz L17360aca
   mov word ptr [BP-2C],0001
L17360aca:
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   cmp AX,0003
   jnz L17360b4d
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0002
L17360b4d:
jmp near L17360cea
L17360b50:
   cmp word ptr [3712],+00
   jnz L17360b5a
jmp near L17360c7a
L17360b5a:
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   cmp AX,[3712]
   jz L17360b7b
jmp near L17360c26
L17360b7b:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[3712]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jz L17360bf2
   mov AX,[3712]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+01],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L17360bf2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0F],AX
   mov word ptr [9157],0000
jmp near L17360c78
L17360c26:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+1B],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0004
L17360c78:
jmp near L17360cea
L17360c7a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+02
   jl L17360cea
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jz L17360cea
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
L17360cea:
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   cmp AX,0003
   jnz L17360d6d
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
L17360d6d:
   cmp word ptr [3722],+20
   jz L17360d77
jmp near L17360e4f
L17360d77:
   mov AX,0006
   push AX
   call far A1eb71a83
   pop CX
   or AX,AX
   jnz L17360d88
jmp near L17360e4f
L17360d88:
   mov AX,[9149]
   add AX,0010
   push AX
   mov AX,[9161]
   mov CL,04
   shl AX,CL
   add AX,[9147]
   push AX
   mov AX,001C
   push AX
   call far A1eb7188c
   add SP,+06
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0006
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,[B5F6]
   dec AX
   push AX
   call far A1eb71c83
   add SP,+06
   or AX,AX
   jz L17360e44
   mov word ptr [BP-2A],0000
jmp near L17360e39
L17360e00:
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],1C
   jnz L17360e36
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+06
   jnz L17360e36
   push [BP-2A]
   call far A1eb7185d
   pop CX
L17360e36:
   inc word ptr [BP-2A]
L17360e39:
   mov AX,[B5F6]
   dec AX
   cmp AX,[BP-2A]
   jg L17360e00
jmp near L17360e4f
L17360e44:
   mov AX,[B5F6]
   dec AX
   push AX
   call far A1eb7185d
   pop CX
L17360e4f:
   cmp word ptr [3716],+00
   jnz L17360e59
jmp near L17360ee0
L17360e59:
   mov word ptr [383A],0001
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,0009
   push AX
   call far A1eb71a83
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
   mov AX,[3712]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L1736113c
L17360ee0:
   cmp word ptr [3714],+00
   jnz L17360eea
jmp near L1736113c
L17360eea:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jz L17360f04
jmp near L17360ff4
L17360f04:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[3714]
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L17360f49
jmp near L17360ff4
L17360f49:
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[3714]
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L17360ff4
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[3714]
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71ace
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0003
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0003
L17360ff4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+00
   jz L1736100d
jmp near L1736113c
L1736100d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17361026
jmp near L1736113c
L17361026:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mov DX,[3714]
   shl DX,1
   add AX,DX
   cmp AX,FFFD
   jge L1736104b
   mov AX,FFFD
jmp near L17361066
L1736104b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mov DX,[3714]
   shl DX,1
   add AX,DX
L17361066:
   cmp AX,0003
   jge L173610ad
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mov DX,[3714]
   shl DX,1
   add AX,DX
   cmp AX,FFFD
   jge L17361090
   mov AX,FFFD
jmp near L173610ab
L17361090:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   mov DX,[3714]
   shl DX,1
   add AX,DX
L173610ab:
jmp near L173610b0
L173610ad:
   mov AX,0003
L173610b0:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0003
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+01
   jle L17361121
   mov word ptr [BP-02],0002
jmp near L1736113c
L17361121:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-01
   jge L1736113c
   mov word ptr [BP-02],FFFE
L1736113c:
jmp near L17361ad2
L1736113f:
   mov word ptr [BP-2C],0001
   mov AX,[B150]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov AX,[B1DA]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+20
   jl L173611e3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov word ptr [BP-2C],0001
L173611e3:
jmp near L17361ad2
L173611e6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+00
   jz L173611ff
jmp near L173612c2
L173611ff:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+02
   jz L17361218
jmp near L173612c2
L17361218:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   inc AX
   inc AX
   cmp AX,0010
   jge L17361249
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
   inc AX
   inc AX
jmp near L1736124c
L17361249:
   mov AX,0010
L1736124c:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jz L173612bf
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],FFFF
L173612bf:
jmp near L17361373
L173612c2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+01
   jnz L1736134d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+02
   jnz L1736134d
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+09],0020
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0B],0020
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71ace
   add SP,+06
jmp near L17361373
L1736134d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+11],+14
   jl L17361373
   mov word ptr [7E42],0006
   mov AX,0001
   push AX
   call far A1eb704c1
   pop CX
L17361373:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,0001
jmp near L17361df1
L1736138c:
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+01],000F
   jnz L17361426
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L17361426
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0003
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0006
jmp near L17361ad2
L17361426:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+0F]
   mov AX,[ES:BX+0F]
   cmp AX,0002
   jg L17361445
jmp near L17361706
L17361445:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+10
   jle L17361484
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0010
L17361484:
   cmp word ptr [3712],+00
   jz L173614b8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0002
   mov AX,[3712]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L173614b8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+08
   jle L173614e3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
L173614e3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[3712]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far A1eb71e6a
   add SP,+06
   or AX,AX
   jz L1736153c
jmp near L17361706
L1736153c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L17361555
jmp near L17361678
L17361555:
   mov word ptr [BP-2A],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+03],000F
   jnz L17361578
   mov word ptr [BP-2A],0001
jmp near L173615c4
L17361578:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[3712]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far A1eb71e6a
   add SP,+06
   or AX,AX
   jnz L173615c4
   mov word ptr [BP-2A],0001
L173615c4:
   cmp word ptr [BP-2A],+01
   jz L173615cd
jmp near L17361675
L173615cd:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0006
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+10
   jl L17361612
   mov AX,FFF9
jmp near L17361615
L17361612:
   mov AX,FFFC
L17361615:
   push AX
   cmp word ptr [3712],+00
   jz L17361622
   mov AX,0001
jmp near L17361624
L17361622:
   xor AX,AX
L17361624:
   pop DX
   add DX,AX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+11],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov AX,0002
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L17361675:
jmp near L17361706
L17361678:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP-2E]
   jnz L173616c1
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
jmp near L17361706
L173616c1:
   push [BP-2E]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[3712]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far A1eb71e6a
   add SP,+06
   or AX,AX
   jnz L17361706
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L17361706:
jmp near L17361ad2
L17361709:
   cmp word ptr [3712],+00
   jnz L17361713
jmp near L17361856
L17361713:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jnz L1736172c
jmp near L17361853
L1736172c:
   mov AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[3712]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L17361773
jmp near L17361853
L17361773:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[3712]
   shl DX,1
   shl DX,1
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far A1eb71ace
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0002
   mov AX,[3712]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   cmp word ptr [3716],+00
   jz L1736183e
   mov word ptr [383A],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L17361853
L1736183e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFC
L17361853:
jmp near L17361ad0
L17361856:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jnz L17361896
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
L17361896:
   cmp word ptr [3714],+00
   jnz L173618a0
jmp near L17361a78
L173618a0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-2E],AX
   cmp word ptr [3714],+00
   jge L173618de
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+0F]
   lea AX,[BP-20]
   add BX,AX
   mov AL,[SS:BX]
   cbw
   sub [BP-2E],AX
jmp near L173618e2
L173618de:
   add word ptr [BP-2E],+04
L173618e2:
   mov AX,0001
   push AX
   push [BP-2E]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L17361974
   cmp word ptr [3714],+00
   jle L1736192e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   and AX,FFF0
   add AX,0010
   mov [BP-2E],AX
jmp near L17361948
L1736192e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   dec AX
   and AX,FFF0
   mov [BP-2E],AX
L17361948:
   mov AX,0001
   push AX
   push [BP-2E]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jnz L17361974
   mov word ptr [BP-2E],0000
L17361974:
   cmp word ptr [BP-2E],+00
   jnz L1736197d
jmp near L17361a78
L1736197d:
   cmp word ptr [3714],+00
   jge L173619c9
   mov AX,[3714]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+0F],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jl L173619c7
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
L173619c7:
jmp near L173619de
L173619c9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0002
L173619de:
   mov word ptr [BP-2C],0001
   push [BP-2E]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71ace
   add SP,+06
   mov AX,0004
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jz L17361a78
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
L17361a78:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L17361aa5
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0005
jmp near L17361ad0
L17361aa5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+06
   jle L17361ad0
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0006
L17361ad0:
jmp near L17361ad2
L17361ad2:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17361b10
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+1B],AX
L17361b10:
   cmp word ptr [371A],+00
   jnz L17361b1a
jmp near L17361d78
L17361b1a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+0D]
   shl BX,1
   test word ptr [BX+BC06],0001
   jnz L17361b3a
jmp near L17361d78
L17361b3a:
   mov word ptr [383C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jnz L17361b59
jmp near L17361d78
L17361b59:
   mov word ptr [BP-30],0000
   mov word ptr [BP-2A],0000
jmp near L17361b8e
L17361b65:
   mov BX,[BP-2A]
   shl BX,1
   mov AX,[BX+B786]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],32
   jnz L17361b86
   mov AX,0001
jmp near L17361b88
L17361b86:
   xor AX,AX
L17361b88:
   add [BP-30],AX
   inc word ptr [BP-2A]
L17361b8e:
   mov AX,[BP-2A]
   cmp AX,[BCA6]
   jl L17361b65
   mov AX,0008
   push AX
   call far A1eb71a83
   pop CX
   cmp AX,[BP-30]
   jg L17361ba9
jmp near L17361c3f
L17361ba9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   call far A1eb7188c
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+1B]
   mov DX,0006
   mul DX
   push AX
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,0022
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L17361d78
L17361c3f:
   mov AX,0002
   push AX
   call far A1eb71a32
   pop CX
   or AX,AX
   jnz L17361c50
jmp near L17361d69
L17361c50:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   call far A1eb7188c
   add SP,+06
   mov [BP-2A],AX
   cmp word ptr [BP-2A],+00
   jnz L17361cb1
jmp near L17361d67
L17361cb1:
   mov AX,0001
   push AX
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,[BP-2A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-2A]
   call far A1eb72221
   add SP,+08
   cmp AX,0001
   jnz L17361d45
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+1B]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0003
   mov AX,0003
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L17361d67
L17361d45:
   push [BP-2A]
   call far A1eb7185d
   pop CX
   mov AX,0002
   push AX
   call far A1eb71a0d
   pop CX
   mov AX,0008
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L17361d67:
jmp near L17361d78
L17361d69:
   mov AX,0008
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L17361d78:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+11]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jz L17361db9
   mov word ptr [BP-2C],0001
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+13]
L17361db9:
   xor AX,AX
   push AX
   call far A1eb723db
   pop CX
   push [BP-02]
   push CS
   call near offset A1736000d
   pop CX
   mov AX,[BP-2C]
jmp near L17361df1
X17361dcf:
jmp near L17361df1
L17361dd1:
   cmp word ptr [BP+08],+01
   jnz L17361df1
   mov AX,[BP+0A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
jmp near L17361ded
L17361ded:
   xor AX,AX
jmp near L17361df1
L17361df1:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A17361df7:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov SI,[BP+06]
   mov DI,0003
   mov AL,[34E9]
   mov AH,00
   and AX,00FE
   cmp AX,0002
   jz L17361e15
   mov DI,0001
L17361e15:
   mov AX,[BP+08]
   or AX,AX
   jz L17361e27
   cmp AX,0002
   jnz L17361e24
jmp near L17361ef8
L17361e24:
jmp near L17362101
L17361e27:
   mov word ptr [BP-02],1000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17361e7e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+11]
   and AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L17361e74
   mov AX,0008
jmp near L17361e76
L17361e74:
   xor AX,AX
L17361e76:
   pop DX
   add DX,AX
   add [BP-02],DX
jmp near L17361eb9
L17361e7e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+11]
   and AX,0001
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L17361eb0
   mov AX,0006
jmp near L17361eb3
L17361eb0:
   mov AX,0004
L17361eb3:
   pop DX
   add DX,AX
   add [BP-02],DX
L17361eb9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-02]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L17362101
L17361ef8:
   cmp word ptr [3712],+00
   jnz L17361f09
   cmp word ptr [3714],+00
   jnz L17361f09
jmp near L173620aa
L17361f09:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+11],AX
   mov AX,[3712]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   cmp word ptr [3712],+00
   jnz L17361f57
jmp near L17362015
L17361f57:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+00
   jnz L17361f70
jmp near L17362015
L17361f70:
   cmp word ptr [3712],+00
   jle L17361fa8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+10
   jle L17361fa8
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+13]
   mov word ptr [3712],0000
jmp near L17362015
L17361fa8:
   cmp word ptr [3712],+00
   jge L17361fe0
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+10
   jge L17361fe0
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov word ptr [3712],0000
jmp near L17362015
L17361fe0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+13],+10
   jnz L17362015
   mov AX,DI
   inc AX
   mul word ptr [3712]
   mov [3712],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L17362015:
   mov AX,[3714]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov DX,[3714]
   shl DX,1
   add AX,DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov DX,[3712]
   shl DX,1
   add AX,DX
   push AX
   push SI
   call far A1eb72221
   add SP,+08
   or AX,AX
   jz L173620aa
   mov AX,[3712]
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+01],AX
   mov AX,[3714]
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+03],AX
L173620aa:
   xor AX,AX
   push AX
   push CS
   call near offset A1736000d
   pop CX
   cmp word ptr [B54A],+00
   jle L173620d5
   mov AX,DI
   add AX,0010
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
jmp near L173620f6
L173620d5:
   cmp word ptr [B54A],+00
   jge L173620f6
   mov AX,0010
   sub AX,DI
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
L173620f6:
   xor AX,AX
   push AX
   call far A1eb723db
   pop CX
jmp near L17362101
L17362101:
   mov AX,0001
jmp near L17362106
L17362106:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1736210c:
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[B684]
   mov CL,08
   shl AX,CL
   mov [BP-0A],AX
   push SS
   lea AX,[BP-08]
   push AX
   push DS
   mov AX,138D
   push AX
   mov CX,0008
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L17362145
   cmp AX,0002
   jnz L17362142
jmp near L173621c5
L17362142:
jmp near L1736270b
L17362145:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L173621a7
   mov AX,0001
jmp near L173621a9
L173621a7:
   xor AX,AX
L173621a9:
   mov DX,0003
   mul DX
   pop DX
   add DX,AX
   push DX
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L1736270b
L173621c5:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb725ff
   add SP,+06
   mov [BP-10],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17362261
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0F],AX
L17362261:
   mov AX,[3712]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   cmp word ptr [BP-10],+00
   jnz L17362288
jmp near L1736238a
L17362288:
   mov AX,[3714]
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+02
   jge L173622a9
   mov AX,0001
jmp near L173622ab
L173622a9:
   xor AX,AX
L173622ab:
   pop DX
   add DX,AX
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add [ES:BX+07],AX
   call far A24940015
   mov BX,0004
   cwd
   idiv BX
   or DX,DX
   jnz L1736230c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,FFFE
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,0006
   push AX
   mov AX,003A
   push AX
   call far A1eb7188c
   add SP,+06
L1736230c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jle L17362337
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L1736233a
L17362337:
   mov AX,FFF8
L1736233a:
   cmp AX,0008
   jle L17362344
   mov AX,0008
jmp near L17362372
L17362344:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jle L1736236f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L17362372
L1736236f:
   mov AX,FFF8
L17362372:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
jmp near L17362419
L1736238a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add word ptr [ES:BX+07],+02
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-10
   jle L173623c9
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L173623cc
L173623c9:
   mov AX,FFF0
L173623cc:
   cmp AX,0010
   jle L173623d6
   mov AX,0010
jmp near L17362404
L173623d6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-10
   jle L17362401
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+07]
jmp near L17362404
L17362401:
   mov AX,FFF0
L17362404:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L17362419:
   cmp word ptr [3716],+00
   jz L17362450
   cmp word ptr [BP-10],+00
   jz L17362450
   mov word ptr [383A],0001
   mov AX,0025
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFE
L17362450:
   cmp word ptr [371A],+00
   jnz L1736245a
jmp near L1736256b
L1736245a:
   mov word ptr [383C],0001
   mov AX,0026
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L173624b1
   mov AX,0001
jmp near L173624b3
L173624b1:
   xor AX,AX
L173624b3:
   mov CL,05
   shl AX,CL
   pop DX
   add DX,AX
   add DX,-08
   push DX
   mov AX,003F
   push AX
   call far A1eb7188c
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L173624e5
   mov AX,0001
jmp near L173624e7
L173624e5:
   xor AX,AX
L173624e7:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L17362503
   mov AX,0001
jmp near L17362505
L17362503:
   xor AX,AX
L17362505:
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
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jle L1736252a
   mov AX,0001
jmp near L1736252c
L1736252a:
   xor AX,AX
L1736252c:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jge L17362548
   mov AX,0001
jmp near L1736254a
L17362548:
   xor AX,AX
L1736254a:
   pop DX
   sub DX,AX
   shl DX,1
   shl DX,1
   pop AX
   add AX,DX
   push AX
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L1736256b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+08
   jle L17362598
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0008
jmp near L173625c3
L17362598:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jge L173625c3
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF8
L173625c3:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   mov [BP-0E],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+07]
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jz L17362638
jmp near L173626df
L17362638:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L1736265b
   mov AX,DI
   add AX,0010
   and AX,FFF0
   mov [BP-0C],AX
jmp near L17362691
L1736265b:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L17362691
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,DI
   and AX,FFF0
   add AX,0010
   mov DX,[ES:BX+0B]
   sub AX,DX
   mov [BP-0C],AX
L17362691:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jz L173626df
   push [BP-0C]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L173626df
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L173626df:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   push [BP-0E]
   push SI
   call far A1eb725ff
   add SP,+06
   xor AX,AX
   push AX
   push CS
   call near offset A1736000d
   pop CX
   mov AX,0001
jmp near L1736270b
L1736270b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A17362711:
   push BP
   mov BP,SP
   mov AX,[BP+08]
   or AX,AX
   jz L17362722
   cmp AX,0002
   jz L17362724
jmp near L17362728
L17362722:
jmp near L17362728
L17362724:
   xor AX,AX
jmp near L17362728
L17362728:
   pop BP
ret far

A1736272a:
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov SI,[BP+06]
   mov AX,[BP+08]
   or AX,AX
   jz L17362747
   cmp AX,0002
   jnz L17362744
jmp near L17362805
L17362744:
jmp near L17362a67
L17362747:
   mov AX,[B68A]
   mov CL,08
   shl AX,CL
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1B],+00
   jle L17362769
   xor AX,AX
jmp near L1736276c
L17362769:
   mov AX,0003
L1736276c:
   pop DX
   add DX,AX
   mov [BP-04],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L173627c9
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L173627a3
   mov AX,0002
jmp near L173627a5
L173627a3:
   xor AX,AX
L173627a5:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jg L173627c1
   mov AX,0001
jmp near L173627c3
L173627c1:
   xor AX,AX
L173627c3:
   pop DX
   add DX,AX
   add [BP-04],DX
L173627c9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-04]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L17362a67
L17362805:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17362843
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+1B],AX
L17362843:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+01],0007
   jnz L17362870
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L1736288e
L17362870:
   mov AX,[3712]
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L173628ac
L1736288e:
   mov AX,[3712]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L173628ac:
   mov AX,0003
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   inc AX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   cmp AX,0003
   jz L17362940
   cmp word ptr [3716],+00
   jnz L173628f4
   cmp word ptr [371A],+00
   jz L1736291a
L173628f4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF4
   mov AX,002B
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L1736293e
L1736291a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF8
   mov AX,0012
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L1736293e:
jmp near L17362971
L17362940:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+07]
   mov AX,[ES:BX+07]
   cmp AX,000C
   jle L17362971
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],000C
L17362971:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+05]
   mov [BP-02],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+07]
   push DI
   push [BP-02]
   push SI
   call far A1eb71c83
   add SP,+06
   test AX,0003
   jz L173629d7
jmp near L17362a5a
L173629d7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L17362a04
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
jmp near L17362a5a
L17362a04:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   call far A1eb71c83
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L17362a5a:
   xor AX,AX
   push AX
   push CS
   call near offset A1736000d
   pop CX
   mov AX,0001
jmp near L17362a67
L17362a67:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A17362a6d:
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
   mov AX,1395
   push AX
   mov CX,000C
   call far A076a05fa
   mov AX,[BP+08]
   or AX,AX
   jz L17362a9c
   cmp AX,0002
   jnz L17362a99
jmp near L17362b23
L17362a99:
jmp near L17362f3d
L17362a9c:
   mov AX,[B654]
   mov CL,08
   shl AX,CL
   mov [BP-12],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L17362adf
   mov AX,0004
jmp near L17362ae1
L17362adf:
   xor AX,AX
L17362ae1:
   pop DX
   add DX,AX
   add [BP-12],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [BP-12]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L17362f3d
L17362b23:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L17362b61
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0F],AX
L17362b61:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+13]
   mov AX,[ES:BX+13]
   cmp AX,0006
   jl L17362b92
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
L17362b92:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+01],0007
   jnz L17362bbf
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jnz L17362bdd
L17362bbf:
   mov AX,[3712]
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
jmp near L17362bfb
L17362bdd:
   mov AX,[3712]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L17362bfb:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   inc word ptr [ES:BX+07]
   cmp word ptr [3716],+00
   jnz L17362c1c
   cmp word ptr [371A],+00
   jz L17362c46
L17362c1c:
   mov word ptr [383A],0001
   mov AX,000F
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFA
L17362c46:
   cmp word ptr [371A],+00
   jnz L17362c50
jmp near L17362d56
L17362c50:
   mov word ptr [383C],0001
   mov AX,0022
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L17362c93
   mov AX,0001
jmp near L17362c95
L17362c93:
   xor AX,AX
L17362c95:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L17362cb1
   mov AX,0001
jmp near L17362cb3
L17362cb1:
   xor AX,AX
L17362cb3:
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
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+01]
   push AX
   mov AX,003E
   push AX
   call far A1eb7188c
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jle L17362cfa
   mov AX,0001
jmp near L17362cfc
L17362cfa:
   xor AX,AX
L17362cfc:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0F],+00
   jge L17362d18
   mov AX,0001
jmp near L17362d1a
L17362d18:
   xor AX,AX
L17362d1a:
   pop DX
   sub DX,AX
   shl DX,1
   shl DX,1
   shl DX,1
   mov AX,[B5F6]
   dec AX
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,[3714]
   shl AX,1
   push AX
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L17362d56:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+08
   jle L17362d83
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0008
jmp near L17362dae
L17362d83:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],-08
   jge L17362dae
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFF8
L17362dae:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   add DI,[ES:BX+05]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   push DI
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L17362e08
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+01]
L17362e08:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jnz L17362e21
jmp near L17362ee9
L17362e21:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+07]
   mov [BP-10],AX
   push [BP-10]
   push DI
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jz L17362e60
jmp near L17362ee9
L17362e60:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jge L17362e84
   mov AX,[BP-10]
   add AX,0010
   and AX,FFF0
   mov [BP-0E],AX
jmp near L17362ebb
L17362e84:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+07],+00
   jle L17362ebb
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[BP-10]
   and AX,FFF0
   add AX,0010
   mov DX,[ES:BX+0B]
   sub AX,DX
   mov [BP-0E],AX
L17362ebb:
   mov AX,[BP-0E]
   cmp AX,[BP-10]
   jz L17362ed4
   push [BP-0E]
   push DI
   push SI
   call far A1eb71d6d
   add SP,+06
   or AX,AX
   jnz L17362ee9
L17362ed4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
L17362ee9:
   mov AX,4000
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72328
   add SP,+08
   cmp AX,4000
   jz L17362f30
   mov AX,0001
   push AX
   mov AX,0100
   push AX
   call far A1eb705e1
   pop CX
   pop CX
L17362f30:
   xor AX,AX
   push AX
   push CS
   call near offset A1736000d
   pop CX
   mov AX,0001
jmp near L17362f3d
L17362f3d:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A17362f43:
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   xor SI,SI
   mov word ptr [BP-0A],0000
   mov AL,[9146]
   cbw
   mov [BP-08],AX
   mov AX,[914F]
   mov [BP-06],AX
   mov AX,[9151]
   mov [BP-04],AX
   mov AX,[BP+06]
   cmp AX,0004
   jz L17362f79
   cmp AX,0005
   jz L17362f80
   cmp AX,0007
   jz L17362f87
jmp near L17362f8e
L17362f79:
   mov word ptr [BP-0A],0039
jmp near L17362f8e
L17362f80:
   mov word ptr [BP-0A],0038
jmp near L17362f8e
L17362f87:
   mov word ptr [BP-0A],0036
jmp near L17362f8e
L17362f8e:
   mov AL,[9146]
   cbw
   cmp AX,[BP-0A]
   jnz L17362f9a
jmp near L173630a3
L17362f9a:
   mov AL,[BP-0A]
   mov [9146],AL
   mov BX,[BP-0A]
   shl BX,1
   mov AX,[BX+B150]
   mov [914F],AX
   mov BX,[BP-0A]
   shl BX,1
   mov AX,[BX+B1DA]
   mov [9151],AX
   mov AX,[9147]
   and AX,FFF8
   mov [BP-02],AX
   mov DI,[9149]
   add DI,[BP-04]
   sub DI,[9151]
   mov AX,0001
   push AX
   push DI
   push [BP-02]
   xor AX,AX
   push AX
   call far A1eb72221
   add SP,+08
   or AX,AX
   jz L17362fe8
   mov SI,0001
jmp near L17363006
L17362fe8:
   mov DI,[9149]
   mov AX,0001
   push AX
   push DI
   push [BP-02]
   xor AX,AX
   push AX
   call far A1eb72221
   add SP,+08
   or AX,AX
   jz L17363006
   mov SI,0001
L17363006:
   or SI,SI
   jnz L1736300d
jmp near L17363091
L1736300d:
   push [BP+06]
   call far A1eb71a0d
   pop CX
   mov [9149],DI
   mov AX,[BP-02]
   mov [9147],AX
   mov word ptr [9153],0000
   mov word ptr [9155],0000
   mov word ptr [9159],0000
   mov word ptr [914B],0000
   mov word ptr [914D],0000
   xor SI,SI
jmp near L1736305b
L17363042:
   mov BX,SI
   shl BX,1
   cmp word ptr [BX+1096],+00
   jz L1736305a
jmp near L1736304f
L1736304f:
   push SI
   call far A1eb71a32
   pop CX
   or AX,AX
   jnz L1736304f
L1736305a:
   inc SI
L1736305b:
   cmp SI,+0B
   jl L17363042
   mov AX,000A
   push AX
   push [9149]
   push [9147]
   call far A11be0a58
   add SP,+06
   mov AX,0007
   push AX
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   push [BX+10AE]
   push [BX+10AC]
   call far A1a4005b7
   add SP,+06
jmp near L173630a3
L17363091:
   mov AL,[BP-08]
   mov [9146],AL
   mov AX,[BP-06]
   mov [914F],AX
   mov AX,[BP-04]
   mov [9151],AX
L173630a3:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1a40 ;; JUNGLE.C:JUNGLE
A1a400009:
   push BP
   mov BP,SP
   mov AX,0016
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   call far A087609ba
   pop BP
ret far

A1a400022:
   push BP
   mov BP,SP
   mov AX,0015
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   call far A08760a67
   pop BP
ret far

A1a40003b:
   push BP
   mov BP,SP
   mov AL,[9146]
   cbw
   mov CX,0006
   mov BX,offset Y1a400058
L1a400048:
   cmp AX,[CS:BX]
   jz L1a400054
   inc BX
   inc BX
   loop L1a400048
jmp near L1a40031a
L1a400054:
jmp near [CS:BX+0C]
Y1a400058:	dw 0000,0017,0036,0037,0038,0039
		dw L1a400070,L1a40012f,L1a400258,L1a4002be,L1a40018c,L1a4001f2
L1a400070:
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,1414
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   mov AX,0008
   push AX
   call far A1eb71a83
   pop CX
   or AX,AX
   jz L1a4000da
   push DS
   mov AX,190C
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
jmp near L1a40012c
L1a4000da:
   mov AX,0002
   push AX
   call far A1eb71a83
   pop CX
   or AX,AX
   jz L1a40010b
   push DS
   mov AX,141C
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
jmp near L1a40012c
L1a40010b:
   push DS
   mov AX,1424
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
L1a40012c:
jmp near L1a40031a
L1a40012f:
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,142C
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1434
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
jmp near L1a40031a
L1a40018c:
   mov AX,0008
   push AX
   mov AX,[34EC]
   shl AX,1
   shl AX,1
   mov DX,0007
   sub DX,AX
   push DX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,143C
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1444
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
jmp near L1a40031a
L1a4001f2:
   mov AX,0008
   push AX
   mov AX,[34EC]
   shl AX,1
   shl AX,1
   mov DX,0007
   sub DX,AX
   push DX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,144C
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1454
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
jmp near L1a40031a
L1a400258:
   mov AX,0008
   push AX
   mov AX,[34EC]
   mov DX,0006
   mul DX
   mov DX,0007
   sub DX,AX
   push DX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,145C
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1464
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
jmp near L1a40031a
L1a4002be:
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,146C
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0025
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1474
   push AX
   mov AX,0002
   push AX
   mov AX,0013
   push AX
   mov AX,0021
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
jmp near L1a40031a
L1a40031a:
   pop BP
ret far

A1a40031c:
   push BP
   mov BP,SP
   mov AX,0008
   push AX
   mov AX,0004
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push [B14A]
   push [B148]
   call far A0abf0bd2
   pop CX
   pop CX
   push DS
   mov AX,147C
   push AX
   mov AX,0001
   push AX
   mov AX,0021
   push AX
   xor AX,AX
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,22F3
   push AX
   mov AX,0002
   push AX
   mov AX,0002
   push AX
   mov AX,0005
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,0005
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   mov AX,0009
   push AX
   mov AX,0002
   push AX
   mov AX,0600
   push AX
   push [B14A]
   push [B148]
   call far A087600de
   add SP,+0A
   mov AX,0012
   push AX
   mov AX,0002
   push AX
   mov AX,0601
   push AX
   push [B14A]
   push [B148]
   call far A087600de
   add SP,+0A
   mov AX,001B
   push AX
   mov AX,0002
   push AX
   mov AX,0609
   push AX
   push [B14A]
   push [B148]
   call far A087600de
   add SP,+0A
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,1489
   push AX
   mov AX,0002
   push AX
   mov AX,001C
   push AX
   mov AX,001E
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,0003
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,148E
   push AX
   mov AX,0001
   push AX
   mov AX,002B
   push AX
   mov AX,0001
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1490
   push AX
   mov AX,0001
   push AX
   mov AX,0033
   push AX
   mov AX,0001
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1492
   push AX
   mov AX,0001
   push AX
   mov AX,003B
   push AX
   mov AX,0001
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1494
   push AX
   mov AX,0001
   push AX
   mov AX,0043
   push AX
   mov AX,0001
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1496
   push AX
   mov AX,0001
   push AX
   mov AX,004B
   push AX
   mov AX,0001
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,0002
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,1498
   push AX
   mov AX,0002
   push AX
   mov AX,002C
   push AX
   mov AX,000E
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,149E
   push AX
   mov AX,0002
   push AX
   mov AX,0034
   push AX
   mov AX,000E
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,14A3
   push AX
   mov AX,0002
   push AX
   mov AX,003C
   push AX
   mov AX,000E
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,14A8
   push AX
   mov AX,0002
   push AX
   mov AX,0044
   push AX
   mov AX,000E
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,14B0
   push AX
   mov AX,0002
   push AX
   mov AX,004C
   push AX
   mov AX,000E
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push CS
   call near offset A1a40003b
   call far A1a4005e0
   or word ptr [BC12],C000
   pop BP
ret far

A1a4005b7:
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push DS
   mov AX,B0FC
   push AX
   call far A238d0008
   mov SP,BP
   mov AX,[BP+0A]
   mov [B14C],AX
   mov word ptr [B14E],0050
   or word ptr [BC12],C000
   pop BP
ret far

A1a4005e0:
   push BP
   mov BP,SP
   sub SP,+20
   push SI
   mov AX,0008
   push AX
   mov AX,FFF9
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   mov AX,002B
   push AX
   mov AX,0035
   push AX
   mov AX,[0C70]
   add AX,060A
   push AX
   push [B14A]
   push [B148]
   call far A087600de
   add SP,+0A
   mov AX,004B
   push AX
   mov AX,0035
   push AX
   mov AX,[13AA]
   add AX,060A
   push AX
   push [B14A]
   push [B148]
   call far A087600de
   add SP,+0A
   cmp word ptr [7E6A],+00
   jz L1a40065e
   mov AX,0004
   push AX
   mov AX,FFFB
   push AX
   push [B41E]
   push [B41C]
   call far A0abf0bec
   add SP,+08
jmp near L1a400676
L1a40065e:
   mov AX,0008
   push AX
   mov AX,FFFB
   push AX
   push [B41E]
   push [B41C]
   call far A0abf0bec
   add SP,+08
L1a400676:
   push [B41E]
   push [B41C]
   call far A0abf0bd2
   pop CX
   pop CX
   push DS
   mov AX,14B7
   push AX
   mov AX,0002
   push AX
   mov AX,0002
   push AX
   mov AX,0002
   push AX
   push [B41E]
   push [B41C]
   call far A0abf078b
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,FFFC
   push AX
   push [B41E]
   push [B41C]
   call far A0abf0bec
   add SP,+08
   xor SI,SI
jmp near L1a4006e6
L1a4006c2:
   mov AX,0002
   push AX
   mov AX,SI
   mov DX,0003
   mul DX
   add AX,002A
   push AX
   mov AX,0E2A
   push AX
   push [B41E]
   push [B41C]
   call far A087600de
   add SP,+0A
   inc SI
L1a4006e6:
   mov AX,[7E42]
   dec AX
   cmp AX,SI
   jg L1a4006c2
   mov AX,0002
   push AX
   mov AX,[7E42]
   dec AX
   mov DX,0003
   mul DX
   add AX,0028
   push AX
   mov AX,0E2B
   push AX
   push [B41E]
   push [B41C]
   call far A087600de
   add SP,+0A
   push DS
   mov AX,14BE
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0021
   push AX
   push [B41E]
   push [B41C]
   call far A0abf078b
   add SP,+0E
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   push [7E68]
   push [7E66]
   call far A237300d2
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
   call far A2388000b
   pop CX
   pop CX
   mov DX,0006
   mul DX
   inc AX
   mov DX,0040
   sub DX,AX
   push DX
   push [B41E]
   push [B41C]
   call far A0abf078b
   add SP,+0E
   mov AX,0008
   push AX
   mov AX,FFFE
   push AX
   push [B41E]
   push [B41C]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,14C4
   push AX
   mov AX,0002
   push AX
   mov AX,000A
   push AX
   mov AX,0001
   push AX
   push [B41E]
   push [B41C]
   call far A0abf078b
   add SP,+0E
   cmp word ptr [7E40],+7F
   jnz L1a4007d6
   push DS
   mov AX,14CA
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far A238d0008
   add SP,+08
jmp near L1a4007ed
L1a4007d6:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   mov AX,[7E40]
   cwd
   push DX
   push AX
   call far A237300d2
   add SP,+0A
L1a4007ed:
   push SS
   lea AX,[BP-20]
   push AX
   mov AX,0002
   push AX
   mov AX,0010
   push AX
   mov AX,0001
   push AX
   push [B41E]
   push [B41C]
   call far A0abf078b
   add SP,+0E
   cmp word ptr [13A4],+00
   jz L1a400867
   cmp word ptr [13A6],+00
   jnz L1a400867
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far A23f50003
   push DX
   push AX
   call far A237300d2
   add SP,+0A
   push DS
   mov AX,14CE
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far A23840009
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
   push [B41E]
   push [B41C]
   call far A0abf078b
   add SP,+0E
L1a400867:
   xor SI,SI
jmp near L1a4008b0
L1a40086b:
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
   mov BX,0003
   cwd
   idiv BX
   mov DX,000E
   mul DX
   inc AX
   push AX
   mov BX,SI
   shl BX,1
   mov BX,[BX+7E46]
   shl BX,1
   mov AX,[BX+1080]
   add AX,0E00
   push AX
   push [B41E]
   push [B41C]
   call far A087600de
   add SP,+0A
   inc SI
L1a4008b0:
   cmp SI,[7E44]
   jl L1a40086b
   push CS
   call near offset A1a40003b
   push DS
   mov AX,B138
   push AX
   call far A0abf0bd2
   pop CX
   pop CX
   xor AX,AX
   push AX
   push [B14C]
   push DS
   mov AX,B138
   push AX
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,B0FC
   push AX
   mov AX,0002
   push AX
   mov AX,0002
   push AX
   push DS
   mov AX,B0FC
   push AX
   call far A2388000b
   pop CX
   pop CX
   mov DX,0003
   mul DX
   mov DX,00A0
   sub DX,AX
   push DX
   push DS
   mov AX,B138
   push AX
   call far A0abf078b
   add SP,+0E
   pop SI
   mov SP,BP
   pop BP
ret far

A1a400910:
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L1a400950
L1a400918:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1a40094f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far A23f70008
   pop CX
   pop CX
L1a40094f:
   inc SI
L1a400950:
   cmp SI,[B5F6]
   jl L1a400918
   call far A1eb70002
   pop SI
   pop BP
ret far

A1a40095e:
   push BP
   mov BP,SP
   sub SP,+40
   push SI
   push DI
   push DS
   mov AX,05FC
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A238d0008
   add SP,+08
   push DS
   mov AX,18A4
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   mov AX,8001
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A2339000c
   add SP,+06
   mov DI,AX
   or DI,DI
   jl L1a4009b2
   push DI
   call far A24320001
   pop CX
   or DX,DX
   jg L1a400a06
   jnz L1a4009b2
   or AX,AX
   ja L1a400a06
L1a4009b2:
   xor SI,SI
jmp near L1a4009dc
L1a4009b6:
   mov AX,SI
   mov DX,000A
   mul DX
   mov BX,AX
   add BX,B084
   push DS
   pop ES
   mov byte ptr [ES:BX],00
   mov BX,SI
   shl BX,1
   shl BX,1
   mov word ptr [BX+B266],0000
   mov word ptr [BX+B264],0000
   inc SI
L1a4009dc:
   cmp SI,+0A
   jl L1a4009b6
   xor SI,SI
jmp near L1a4009f9
L1a4009e5:
   mov AX,SI
   mov DX,000C
   mul DX
   mov BX,AX
   add BX,B54E
   push DS
   pop ES
   mov byte ptr [ES:BX],00
   inc SI
L1a4009f9:
   cmp SI,+06
   jl L1a4009e5
   mov word ptr [386A],0001
jmp near L1a400a58
L1a400a06:
   mov AX,0078
   push AX
   push DS
   mov AX,B084
   push AX
   push DI
   call far A2346000d
   add SP,+08
   mov AX,0028
   push AX
   push DS
   mov AX,B264
   push AX
   push DI
   call far A2346000d
   add SP,+08
   mov AX,0048
   push AX
   push DS
   mov AX,B54E
   push AX
   push DI
   call far A2346000d
   add SP,+08
   mov AX,0016
   push AX
   push DS
   mov AX,386A
   push AX
   push DI
   call far A2346000d
   add SP,+08
   or AX,AX
   jge L1a400a58
   mov word ptr [386A],0001
L1a400a58:
   push DI
   call far A23410006
   pop CX
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a400a65:
   push BP
   mov BP,SP
   sub SP,+40
   push SI
   push DS
   mov AX,05FC
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A238d0008
   add SP,+08
   push DS
   mov AX,18A4
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A2429003d
   add SP,+06
   mov SI,AX
   or SI,SI
   jl L1a400aee
   mov AX,0078
   push AX
   push DS
   mov AX,B084
   push AX
   push SI
   call far A23550002
   add SP,+08
   mov AX,0028
   push AX
   push DS
   mov AX,B264
   push AX
   push SI
   call far A23550002
   add SP,+08
   mov AX,0048
   push AX
   push DS
   mov AX,B54E
   push AX
   push SI
   call far A23550002
   add SP,+08
   mov AX,0016
   push AX
   push DS
   mov AX,386A
   push AX
   push SI
   call far A23550002
   add SP,+08
L1a400aee:
   push SI
   call far A23410006
   pop CX
   pop SI
   mov SP,BP
   pop BP
ret far

A1a400afa:
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov SI,0009
jmp near L1a400b12
L1a400b07:
   mov BX,SI
   shl BX,1
   mov word ptr [BX+2A4A],0000
   inc SI
L1a400b12:
   cmp SI,+40
   jl L1a400b07
   mov word ptr [2A66],0001
   mov word ptr [2AA6],0001
   push [BP+08]
   push [BP+06]
   push DS
   mov AX,B5D6
   push AX
   call far A238d0008
   add SP,+08
   push CS
   call near offset A1a400910
   mov AX,8001
   push AX
   push [BP+08]
   push [BP+06]
   call far A2339000c
   add SP,+06
   mov DI,AX
   mov AX,4000
   push AX
   push DS
   mov AX,3E40
   push AX
   push DI
   call far A2346000d
   add SP,+08
   or AX,AX
   jnz L1a400b6e
   mov AX,0001
   push AX
   call far A1a4034a1
   pop CX
L1a400b6e:
   mov AX,0002
   push AX
   push DS
   mov AX,B5F6
   push AX
   push DI
   call far A2346000d
   add SP,+08
   or AX,AX
   jnz L1a400b8e
   mov AX,0002
   push AX
   call far A1a4034a1
   pop CX
L1a400b8e:
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   push AX
   push DS
   mov AX,9146
   push AX
   push DI
   call far A2346000d
   add SP,+08
   or AX,AX
   jnz L1a400bb3
   mov AX,0003
   push AX
   call far A1a4034a1
   pop CX
L1a400bb3:
   mov AX,0046
   push AX
   push DS
   mov AX,7E40
   push AX
   push DI
   call far A2346000d
   add SP,+08
   or AX,AX
   jnz L1a400bd3
   mov AX,0004
   push AX
   call far A1a4034a1
   pop CX
L1a400bd3:
   xor SI,SI
jmp near L1a400c4e
L1a400bd7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1a400c4d
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   push DI
   call far A2346000d
   add SP,+08
   mov AX,[BP-06]
   inc AX
   push AX
   call far A22d7000a
   pop CX
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push DI
   call far A2346000d
   add SP,+08
L1a400c4d:
   inc SI
L1a400c4e:
   cmp SI,[B5F6]
   jl L1a400bd7
   push DI
   call far A23440007
   pop CX
   mov word ptr [BP-04],0000
jmp near L1a400caf
L1a400c62:
   mov word ptr [BP-02],0000
jmp near L1a400ca6
L1a400c69:
   mov BX,[BP-04]
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,7E86
   push DS
   pop ES
   mov BX,[ES:BX]
   mov CL,08
   sar BX,CL
   and BX,003F
   shl BX,1
   mov word ptr [BX+2A4A],0001
   inc word ptr [BP-02]
L1a400ca6:
   cmp word ptr [BP-02],+40
   jl L1a400c69
   inc word ptr [BP-04]
L1a400caf:
   cmp word ptr [BP-04],0080
   jl L1a400c62
   xor SI,SI
jmp near L1a400cde
L1a400cba:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov BX,[BX+B618]
   shl BX,1
   mov word ptr [BX+2A4A],0001
   inc SI
L1a400cde:
   cmp SI,[B5F6]
   jl L1a400cba
   call far A07d60779
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a400cef:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   xor AX,AX
   push AX
   push [BP+08]
   push [BP+06]
   call far A2429003d
   add SP,+06
   mov SI,AX
   or SI,SI
   jge L1a400d18
   mov AX,0014
   push AX
   call far A1a4034a1
   pop CX
L1a400d18:
   mov AX,4000
   push AX
   push DS
   mov AX,3E40
   push AX
   push SI
   call far A23550002
   add SP,+08
   or AX,AX
   jge L1a400d38
   mov AX,0005
   push AX
   call far A1a4034a1
   pop CX
L1a400d38:
   mov AX,0002
   push AX
   push DS
   mov AX,B5F6
   push AX
   push SI
   call far A23550002
   add SP,+08
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   push AX
   push DS
   mov AX,9146
   push AX
   push SI
   call far A23550002
   add SP,+08
   mov AX,0046
   push AX
   push DS
   mov AX,7E40
   push AX
   push SI
   call far A23550002
   add SP,+08
   xor DI,DI
jmp near L1a400de9
L1a400d77:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1a400de8
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far A2388000b
   pop CX
   pop CX
   mov [BP-02],AX
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   push SI
   call far A23550002
   add SP,+08
   mov AX,[BP-02]
   inc AX
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push SI
   call far A23550002
   add SP,+08
L1a400de8:
   inc DI
L1a400de9:
   cmp DI,[B5F6]
   jl L1a400d77
   push SI
   call far A23440007
   pop CX
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a400dfc:
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   xor SI,SI
jmp near L1a400e1b
L1a400e07:
   les BX,[398C]
   cmp byte ptr [ES:BX+SI],0D
   jnz L1a400e16
   mov AX,0001
jmp near L1a400e18
L1a400e16:
   xor AX,AX
L1a400e18:
   add DI,AX
   inc SI
L1a400e1b:
   cmp SI,[3E30]
   jl L1a400e07
   mov AX,DI
jmp near L1a400e25
L1a400e25:
   pop DI
   pop SI
   pop BP
ret far

A1a400e29:
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov word ptr [BP-04],0007
   xor SI,SI
   xor DI,DI
jmp near L1a400e50
L1a400e3c:
   les BX,[398C]
   cmp byte ptr [ES:BX+SI],0D
   jnz L1a400e4b
   mov AX,0001
jmp near L1a400e4d
L1a400e4b:
   xor AX,AX
L1a400e4d:
   add DI,AX
   inc SI
L1a400e50:
   cmp DI,[BP+06]
   jge L1a400e5b
   cmp SI,[3E30]
   jl L1a400e3c
L1a400e5b:
jmp near L1a400e5e
L1a400e5d:
   inc SI
L1a400e5e:
   les BX,[398C]
   cmp byte ptr [ES:BX+SI],20
   jge L1a400e72
   les BX,[398C]
   cmp byte ptr [ES:BX+SI],0D
   jnz L1a400e5d
L1a400e72:
   les BX,[398C]
   cmp byte ptr [ES:BX+SI],30
   jl L1a400e95
   les BX,[398C]
   cmp byte ptr [ES:BX+SI],37
   jg L1a400e95
   les BX,[398C]
   mov AL,[ES:BX+SI]
   cbw
   add AX,FFD0
   mov [BP-04],AX
   inc SI
L1a400e95:
   xor DI,DI
jmp near L1a400ebe
L1a400e99:
   cmp word ptr [BP+0C],+00
   jz L1a400eb3
   mov AL,[BP-01]
   cbw
   push AX
   call far A24d90000
   pop CX
   les BX,[BP+08]
   mov [ES:BX+DI],AL
   inc DI
jmp near L1a400ebd
L1a400eb3:
   mov AL,[BP-01]
   les BX,[BP+08]
   mov [ES:BX+DI],AL
   inc DI
L1a400ebd:
   inc SI
L1a400ebe:
   les BX,[398C]
   mov AL,[ES:BX+SI]
   mov [BP-01],AL
   cmp AL,0D
   jz L1a400ed7
   cmp SI,[3E30]
   jge L1a400ed7
   cmp DI,+4D
   jl L1a400e99
L1a400ed7:
   les BX,[BP+08]
   mov byte ptr [ES:BX+DI],00
   mov AX,[BP-04]
jmp near L1a400ee3
L1a400ee3:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a400ee9:
   push BP
   mov BP,SP
   sub SP,+50
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   push SS
   lea AX,[BP-50]
   push AX
   push [BP+0C]
   push CS
   call near offset A1a400e29
   add SP,+08
   push AX
   push [BP+08]
   push [BP+06]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,14D4
   push AX
   mov AX,0002
   push AX
   push [BP+0A]
   xor AX,AX
   push AX
   push [BP+08]
   push [BP+06]
   call far A0abf078b
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
   call far A2388000b
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
   push [BP+06]
   call far A0abf078b
   add SP,+0E
   mov SP,BP
   pop BP
ret far

A1a400f6d:
   push BP
   mov BP,SP
   push SI
   les BX,[0C74]
   mov SI,[ES:BX]
L1a400f78:
   les BX,[0C74]
   mov AX,[ES:BX]
   sub AX,SI
   cmp AX,[18F1]
   jl L1a400f78
   pop SI
   pop BP
ret far

A1a400f8a:
   push BP
   mov BP,SP
   sub SP,00AE
   push SI
   push DI
   mov word ptr [382C],0001
   mov word ptr [382E],0001
   push [BP+06]
   call far A0ce30582
   pop CX
   mov AX,[398C]
   or AX,[398E]
   jnz L1a400fb4
jmp near L1a40126f
L1a400fb4:
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AX,[B2BE]
   mov BX,0010
   cwd
   idiv BX
   add AX,FFFC
   push AX
   mov AX,[B2BC]
   mov BX,0010
   cwd
   idiv BX
   add AX,FFFD
   push AX
   mov AX,[B2BA]
   add AX,0010
   push AX
   mov AX,[B2B8]
   mov BX,0008
   cwd
   idiv BX
   inc AX
   inc AX
   push AX
   push SS
   lea AX,[BP+FF52]
   push AX
   call far A0abf0002
   add SP,+12
   push SS
   lea AX,[BP+FF52]
   push AX
   call far A0abf0234
   pop CX
   pop CX
   mov AX,0001
   push AX
   mov AX,0007
   push AX
   push SS
   lea AX,[BP+FF7A]
   push AX
   call far A0abf0bec
   add SP,+08
   push SS
   lea AX,[BP+FF7A]
   push AX
   call far A0abf0bd2
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
   call near offset A1a400e29
   add SP,+08
   push AX
   push SS
   lea AX,[BP+FF6A]
   push AX
   call far A0abf0bec
   add SP,+08
   push SS
   lea AX,[BP-50]
   push AX
   push SS
   lea AX,[BP+FF52]
   push AX
   call far A0abf0aba
   add SP,+08
   xor AX,AX
   push AX
   mov AX,0007
   push AX
   push SS
   lea AX,[BP+FF7A]
   push AX
   call far A0abf0bec
   add SP,+08
   mov AX,[BP-80]
   mov BX,0006
   cwd
   idiv BX
   mov [BP-52],AX
   push CS
   call near offset A1a400dfc
   mov [BP-56],AX
   mov AX,[BP-56]
   cmp AX,[BP-52]
   jle L1a40109d
jmp near L1a401127
L1a40109d:
   mov AX,[BP-56]
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
jmp near L1a4010d1
L1a4010bb:
   push SI
   push [BP-54]
   push SS
   lea AX,[BP+FF7A]
   push AX
   push CS
   call near offset A1a400ee9
   add SP,+08
   add word ptr [BP-54],+06
   inc SI
L1a4010d1:
   cmp SI,[BP-56]
   jl L1a4010bb
   call far A08760751
   push CS
   call near offset A1a400f6d
L1a4010df:
   mov AX,0001
   push AX
   call far A0b8b05b2
   pop CX
   cmp word ptr [3712],+00
   jnz L1a4010df
   cmp word ptr [3714],+00
   jnz L1a4010df
   cmp word ptr [3722],+00
   jnz L1a4010df
   cmp word ptr [3716],+00
   jnz L1a4010df
L1a401105:
   mov AX,0001
   push AX
   call far A0b8b05b2
   pop CX
   cmp word ptr [3722],+20
   jz L1a401124
   cmp word ptr [3722],+0D
   jz L1a401124
   cmp word ptr [3716],+00
   jz L1a401105
L1a401124:
jmp near L1a401255
L1a401127:
   xor DI,DI
   mov word ptr [BP-54],0000
   mov SI,0001
jmp near L1a401149
L1a401133:
   push SI
   push [BP-54]
   push SS
   lea AX,[BP+FF7A]
   push AX
   push CS
   call near offset A1a400ee9
   add SP,+08
   add word ptr [BP-54],+06
   inc SI
L1a401149:
   cmp SI,[BP-52]
   jle L1a401133
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   mov word ptr [383A],0001
L1a401162:
   mov AX,0001
   push AX
   call far A0b8b05b2
   pop CX
   cmp word ptr [3712],+00
   jnz L1a401162
   cmp word ptr [3714],+00
   jnz L1a401162
   cmp word ptr [3722],+00
   jnz L1a401162
   push CS
   call near offset A1a400f6d
L1a401185:
   xor AX,AX
   push AX
   call far A0b8b05b2
   pop CX
   cmp word ptr [3722],00D1
   jnz L1a40119b
   mov AX,0001
jmp near L1a40119d
L1a40119b:
   xor AX,AX
L1a40119d:
   push AX
   cmp word ptr [3722],00C9
   jnz L1a4011ab
   mov AX,0001
jmp near L1a4011ad
L1a4011ab:
   xor AX,AX
L1a4011ad:
   pop DX
   sub DX,AX
   add [3712],DX
   mov AX,[3712]
   add AX,[3714]
   jge L1a4011ed
   or DI,DI
   jle L1a4011ed
   dec DI
   mov AX,0006
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP+FF7A]
   push AX
   call far A09560e7f
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
   call near offset A1a400ee9
   add SP,+08
jmp near L1a401233
L1a4011ed:
   mov AX,[3712]
   add AX,[3714]
   jle L1a401233
   mov AX,DI
   add AX,[BP-52]
   cmp AX,[BP-56]
   jge L1a401233
   inc DI
   mov AX,FFFA
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP+FF7A]
   push AX
   call far A09560e7f
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
   call near offset A1a400ee9
   add SP,+08
L1a401233:
   cmp word ptr [3722],+0D
   jz L1a40124b
   cmp word ptr [3722],+1B
   jz L1a40124b
   cmp word ptr [3716],+00
   jnz L1a40124b
jmp near L1a401185
L1a40124b:
   mov AX,0001
   push AX
   call far A08760700
   pop CX
L1a401255:
   call far A1a401571
   push [398E]
   push [398C]
   call far A23f70008
   pop CX
   pop CX
   mov word ptr [3722],0000
L1a40126f:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a401275:
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
jmp near L1a4012a0
L1a40127e:
   xor DI,DI
jmp near L1a40129a
L1a401282:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C000
   inc DI
L1a40129a:
   cmp DI,+40
   jl L1a401282
   inc SI
L1a4012a0:
   cmp SI,0080
   jl L1a40127e
   les BX,[B28C]
   mov word ptr [ES:BX+08],0000
   les BX,[B28C]
   mov word ptr [ES:BX+0A],0000
   pop DI
   pop SI
   pop BP
ret far

A1a4012be:
   push BP
   mov BP,SP
   sub SP,+52
   push SI
   push DI
   les BX,[0C74]
   mov AX,[ES:BX]
   mov [BCA8],AX
   cmp word ptr [BP+06],+20
   jl L1a4012d9
jmp near L1a401412
L1a4012d9:
   mov BX,[BP+06]
   shl BX,1
   shl BX,1
   les BX,[BX+2323]
   mov [398E],ES
   mov [398C],BX
   push [398E]
   push [398C]
   call far A2388000b
   pop CX
   pop CX
   mov [3E30],AX
   mov AX,[398C]
   or AX,[398E]
   jnz L1a40130a
jmp near L1a401412
L1a40130a:
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   push DS
   mov AX,B72C
   push AX
   call far A0abf0234
   pop CX
   pop CX
   mov AX,0001
   push AX
   mov AX,0007
   push AX
   push DS
   mov AX,B754
   push AX
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,B754
   push AX
   call far A0abf0bd2
   pop CX
   pop CX
   cmp byte ptr [34E9],04
   jnz L1a401388
   cmp word ptr [1954],+00
   jz L1a401388
   xor SI,SI
jmp near L1a401383
L1a401353:
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
   mov AX,[1954]
   mov CL,08
   shl AX,CL
   add AX,SI
   add AX,4000
   push AX
   push DS
   mov AX,B764
   push AX
   call far A087600de
   add SP,+0A
   inc SI
L1a401383:
   cmp SI,+10
   jl L1a401353
L1a401388:
   push CS
   call near offset A1a400dfc
   mov DI,AX
   mov AX,DI
   dec AX
   mov DX,0006
   mul DX
   push AX
   mov AX,[B75A]
   pop DX
   sub AX,DX
   mov BX,0002
   cwd
   idiv BX
   mov [BP-02],AX
   xor SI,SI
jmp near L1a401404
L1a4013aa:
   mov AX,0001
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-52]
   push AX
   push SI
   push CS
   call near offset A1a400e29
   add SP,+08
   push AX
   push DS
   mov AX,B754
   push AX
   call far A0abf0bec
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
   call far A2388000b
   pop CX
   pop CX
   mov DX,0006
   mul DX
   mov DX,[B758]
   sub DX,AX
   shr DX,1
   push DX
   push DS
   mov AX,B754
   push AX
   call far A0abf078b
   add SP,+0E
   add word ptr [BP-02],+06
   inc SI
L1a401404:
   cmp SI,DI
   jl L1a4013aa
   call far A08760751
   call far A1a401571
L1a401412:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a401418:
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
L1a40141f:
   xor AX,AX
   push AX
   call far A0b8b05b2
   pop CX
   cmp word ptr [3722],+00
   jnz L1a40141f
L1a40142f:
   xor AX,AX
   push AX
   call far A0b8b05b2
   pop CX
   les BX,[0C74]
   mov AX,[ES:BX]
   sub AX,[BCA8]
   mov BX,0012
   cwd
   idiv BX
   mov DI,AX
   cmp word ptr [3722],+1B
   jz L1a401459
   cmp word ptr [3722],+0D
   jnz L1a40145e
L1a401459:
   mov SI,0001
jmp near L1a40147e
L1a40145e:
   cmp DI,+02
   jl L1a401476
   cmp word ptr [3722],+00
   jnz L1a401471
   cmp word ptr [3716],+00
   jz L1a401476
L1a401471:
   mov SI,0001
jmp near L1a40147e
L1a401476:
   cmp DI,+04
   jl L1a40147e
   mov SI,0001
L1a40147e:
   or SI,SI
   jz L1a40142f
   pop DI
   pop SI
   pop BP
ret far

A1a401486:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   or SI,SI
   jge L1a40149b
jmp near L1a40151e
L1a40149b:
   cmp SI,0080
   jl L1a4014a4
jmp near L1a40151e
L1a4014a4:
   or DI,DI
   jl L1a40151e
   cmp DI,+40
   jge L1a40151e
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-02],AX
   mov BX,[BP-02]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   test word ptr [ES:BX+02],0010
   jnz L1a401511
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
   add BX,7E86
   push DS
   pop ES
   push [ES:BX]
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
jmp near L1a40151e
L1a401511:
   xor AX,AX
   push AX
   push DI
   push SI
   call far A16b00006
   add SP,+06
L1a40151e:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a401524:
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
jmp near L1a40154f
L1a40152d:
   xor DI,DI
jmp near L1a401549
L1a401531:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
   inc DI
L1a401549:
   cmp DI,+40
   jl L1a401531
   inc SI
L1a40154f:
   cmp SI,0080
   jl L1a40152d
   xor AX,AX
   push AX
   call far A1eb712b3
   pop CX
   mov word ptr [BC12],0000
   xor AX,AX
   push AX
   call far A1eb70d4c
   pop CX
   pop DI
   pop SI
   pop BP
ret far

A1a401571:
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
jmp near L1a40159c
L1a40157a:
   xor DI,DI
jmp near L1a401596
L1a40157e:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
   inc DI
L1a401596:
   cmp DI,+40
   jl L1a40157e
   inc SI
L1a40159c:
   cmp SI,0080
   jl L1a40157a
   or word ptr [BC12],C000
   pop DI
   pop SI
   pop BP
ret far

A1a4015ac:
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   xor SI,SI
   mov word ptr [BP-04],0000
   mov AX,0004
   push AX
   push DS
   mov AX,14F9
   push AX
   push CS
   call near offset A1a4005b7
   add SP,+06
   call far A1eb71ab3
   call far A1eb72159
   push CS
   call near offset A1a40031c
   push CS
   call near offset A1a4005e0
   mov byte ptr [B5F8],00
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   call far A1eb703be
   mov word ptr [B784],0000
L1a4015f7:
   sti
   cmp byte ptr [B5F8],00
   jnz L1a401602
jmp near L1a40185c
L1a401602:
   cmp byte ptr [B5F8],2A
   jnz L1a40164e
   push DS
   mov AX,B5F8
   push AX
   call far A2388000b
   pop CX
   pop CX
   push AX
   push DS
   mov AX,B5F9
   push AX
   push DS
   mov AX,B5F8
   push AX
   call far A23960060
   add SP,+0A
   push DS
   mov AX,B5F8
   push AX
   push DS
   mov AX,B3FC
   push AX
   call far A238d0008
   add SP,+08
   push DS
   mov AX,B5F8
   push AX
   call far A0ce308d6
   pop CX
   pop CX
   mov byte ptr [B5F8],00
jmp near L1a40185c
L1a40164e:
   cmp byte ptr [B5F8],23
   jnz L1a4016a3
   push DS
   mov AX,B5F8
   push AX
   call far A2388000b
   pop CX
   pop CX
   push AX
   push DS
   mov AX,B5F9
   push AX
   push DS
   mov AX,B5F8
   push AX
   call far A23960060
   add SP,+0A
   push DS
   mov AX,B5F8
   push AX
   push DS
   mov AX,B3FC
   push AX
   call far A238d0008
   add SP,+08
   call far A0ce308a0
   or AX,AX
   jnz L1a40169b
   push DS
   mov AX,B5F8
   push AX
   call far A0ce308d6
   pop CX
   pop CX
L1a40169b:
   mov byte ptr [B5F8],00
jmp near L1a40185c
L1a4016a3:
   cmp byte ptr [B5F8],26
   jnz L1a40170a
   push DS
   mov AX,B5F8
   push AX
   call far A2388000b
   pop CX
   pop CX
   push AX
   push DS
   mov AX,B5F9
   push AX
   push DS
   mov AX,B5F8
   push AX
   call far A23960060
   add SP,+0A
   mov word ptr [3866],0002
   push DS
   mov AX,B5F8
   push AX
   call far A0b8b06c4
   pop CX
   pop CX
   push DS
   mov AX,B5F8
   push AX
   push DS
   mov AX,B3FC
   push AX
   call far A238d0008
   add SP,+08
   call far A0ce308a0
   or AX,AX
   jnz L1a401702
   push DS
   mov AX,B5F8
   push AX
   call far A0ce308d6
   pop CX
   pop CX
L1a401702:
   mov byte ptr [B5F8],00
jmp near L1a40185c
L1a40170a:
   cmp byte ptr [B5F8],21
   jz L1a401714
jmp near L1a40180e
L1a401714:
   xor AX,AX
   push AX
   push CS
   call near offset A1a4012be
   pop CX
   mov AX,0003
   push AX
   call far A1eb71a83
   pop CX
   mov DI,AX
   mov [BP-06],DI
   mov AX,[7E66]
   mov [BP-02],AX
   push DS
   mov AX,B596
   push AX
   push CS
   call near offset A1a400afa
   pop CX
   pop CX
   mov AX,[BP-02]
   cwd
   mov [7E68],DX
   mov [7E66],AX
   push DS
   mov AX,B596
   push AX
   call far A2382000d
   pop CX
   pop CX
jmp near L1a40175f
L1a401755:
   mov AX,0003
   push AX
   call far A1eb71a0d
   pop CX
L1a40175f:
   mov AX,DI
   dec DI
   or AX,AX
   jg L1a401755
   mov byte ptr [B5F8],00
   xor AX,AX
   push AX
   call far A1eb704c1
   pop CX
   push [7E40]
   call far A1eb70377
   pop CX
   mov DI,AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0D]
   or AX,AX
   jz L1a40179e
   cmp AX,0001
   jz L1a4017a7
jmp near L1a4017ff
L1a40179e:
   push DI
   call far A1eb7185d
   pop CX
jmp near L1a401808
L1a4017a7:
   cmp word ptr [BP-06],+00
   jle L1a4017b6
   push DI
   call far A1eb7185d
   pop CX
jmp near L1a4017fd
L1a4017b6:
   mov AX,0004
   push AX
   push DS
   mov AX,150C
   push AX
   push CS
   call near offset A1a4005b7
   add SP,+06
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   xor AX,AX
   push AX
   call far A1eb71ace
   add SP,+06
   mov word ptr [7E40],0000
L1a4017fd:
jmp near L1a401808
L1a4017ff:
   push DI
   call far A1eb7185d
   pop CX
jmp near L1a401808
L1a401808:
   push CS
   call near offset A1a401418
jmp near L1a40185c
L1a40180e:
   mov AX,[7E40]
   mov [BCA4],AX
   push [BCA4]
   push CS
   call near offset A1a4012be
   pop CX
   push DS
   mov AX,B596
   push AX
   push CS
   call near offset A1a400cef
   pop CX
   pop CX
   mov AX,[7E66]
   mov [BP-02],AX
   push DS
   mov AX,B5F8
   push AX
   push CS
   call near offset A1a400afa
   pop CX
   pop CX
   mov AX,[BP-02]
   cwd
   mov [7E68],DX
   mov [7E66],AX
   mov byte ptr [B5F8],00
   mov AX,[BCA4]
   mov [7E40],AX
   xor AX,AX
   push AX
   call far A1eb704c1
   pop CX
   push CS
   call near offset A1a401418
L1a40185c:
   les BX,[0C74]
   mov AX,[ES:BX]
   mov [BP-0A],AX
   call far A0ce30882
   inc word ptr [BC14]
   mov AX,0001
   push AX
   call far A0b8b02fd
   pop CX
   push [3722]
   call far A24d90000
   pop CX
   mov [3722],AX
   cmp word ptr [3722],+00
   jnz L1a401890
jmp near L1a401986
L1a401890:
   cmp SI,+2F
   jnz L1a4018e1
   cmp word ptr [BP-04],+02
   jnz L1a4018e1
   xor SI,SI
   mov AX,[3722]
   cmp AX,0030
   jz L1a4018b1
   cmp AX,0043
   jz L1a4018cd
   cmp AX,0052
   jz L1a4018bf
jmp near L1a4018db
L1a4018b1:
   cmp word ptr [385E],+00
   jz L1a4018bd
   call far A0b8b07be
L1a4018bd:
jmp near L1a4018db
L1a4018bf:
   push DS
   mov AX,152C
   push AX
   call far A0b8b0777
   pop CX
   pop CX
jmp near L1a4018db
L1a4018cd:
   push DS
   mov AX,1535
   push AX
   call far A0b8b06c4
   pop CX
   pop CX
jmp near L1a4018db
L1a4018db:
   mov word ptr [3722],0000
L1a4018e1:
   mov AX,[3722]
   cmp AX,SI
   jnz L1a4018ed
   inc word ptr [BP-04]
jmp near L1a4018f6
L1a4018ed:
   mov word ptr [BP-04],0001
   mov SI,[3722]
L1a4018f6:
   cmp SI,+58
   jnz L1a401941
   cmp word ptr [BP-04],+03
   jnz L1a401941
   xor SI,SI
   mov word ptr [7E42],0008
   mov AX,000A
   push AX
   call far A1eb71a83
   pop CX
   or AX,AX
   jnz L1a401921
   mov AX,000A
   push AX
   call far A1eb71a0d
   pop CX
L1a401921:
   mov AX,0001
   push AX
   call far A1eb71a83
   pop CX
   or AX,AX
   jnz L1a401939
   mov AX,0001
   push AX
   call far A1eb71a0d
   pop CX
L1a401939:
   or word ptr [BC12],C000
jmp near L1a401986
L1a401941:
   cmp SI,+5A
   jnz L1a401961
   cmp word ptr [BP-04],+03
   jnz L1a401961
   xor SI,SI
   mov AX,[13A4]
   neg AX
   sbb AX,AX
   inc AX
   mov [13A4],AX
   or word ptr [BC12],C000
jmp near L1a401986
L1a401961:
   cmp SI,+57
   jnz L1a401986
   cmp word ptr [BP-04],+03
   jnz L1a401986
   call far A0b8b0665
   mov AX,[3722]
   add AX,FFD0
   push AX
   call far A0cc20008
   pop CX
   mov word ptr [13A6],0001
   xor SI,SI
L1a401986:
   mov AX,[3722]
   cmp AX,004E
   jz L1a40199a
   cmp AX,0050
   jz L1a4019c0
   cmp AX,0054
   jz L1a4019ad
jmp near L1a4019f3
L1a40199a:
   mov AX,[0C70]
   neg AX
   sbb AX,AX
   inc AX
   mov [0C70],AX
   or word ptr [BC12],C000
jmp near L1a4019f3
L1a4019ad:
   mov AX,[13AA]
   neg AX
   sbb AX,AX
   inc AX
   mov [13AA],AX
   or word ptr [BC12],C000
jmp near L1a4019f3
L1a4019c0:
   xor AX,AX
   push AX
   call far A0b8b05b2
   pop CX
   call far A0ce30882
   cmp word ptr [3722],+00
   jnz L1a4019f1
   cmp word ptr [3716],+00
   jnz L1a4019f1
   cmp word ptr [371A],+00
   jnz L1a4019f1
   cmp word ptr [3712],+00
   jnz L1a4019f1
   cmp word ptr [3714],+00
   jz L1a4019c0
L1a4019f1:
jmp near L1a4019f3
L1a4019f3:
   cmp word ptr [BP+06],+00
   jz L1a401a1b
   mov AX,0043
   push AX
   call far A1eb700ec
   pop CX
   or AX,AX
   jnz L1a401a1b
   push [9149]
   push [9147]
   mov AX,0043
   push AX
   call far A1eb7188c
   add SP,+06
L1a401a1b:
   call far A1eb711d1
   mov AX,0001
   push AX
   call far A1eb712b3
   pop CX
   call far A1eb72595
   push [34E0]
   call far A1eb70d4c
   pop CX
   call far A1eb72500
   push [3722]
   call far A24d90000
   pop CX
   mov CX,0005
   mov BX,offset Y1a401a5e
L1a401a4e:
   cmp AX,[CS:BX]
   jz L1a401a5a
   inc BX
   inc BX
   loop L1a401a4e
jmp near L1a401b06
L1a401a5a:
jmp near [CS:BX+0A]
Y1a401a5e:	dw 001b,0051,0052,0053,00bb
		dw L1a401ae5,L1a401ae5,L1a401a9f,L1a401a72,L1a401ada
L1a401a72:
   mov AX,[34EC]
   mov [BP-08],AX
   mov AX,[34EA]
   mov [34EC],AX
   call far A087606e7
   call far A1a40264b
   push CS
   call near offset A1a40031c
   mov AX,[BP-08]
   mov [34EC],AX
   call far A087606e7
   mov word ptr [3722],0020
jmp near L1a401b06
L1a401a9f:
   mov AX,[34EC]
   mov [BP-08],AX
   mov AX,[34EA]
   mov [34EC],AX
   call far A087606e7
   call far A1a402516
   call far A1eb703be
   push CS
   call near offset A1a40031c
   mov AX,[BP-08]
   mov [34EC],AX
   call far A087606e7
   call far A1eb72159
   push CS
   call near offset A1a401571
   mov word ptr [3722],0020
jmp near L1a401b06
L1a401ada:
   mov AX,0001
   push AX
   push CS
   call near offset A1a400f8a
   pop CX
jmp near L1a401b06
L1a401ae5:
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   call far A1a402d52
   mov [B784],AX
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a401571
jmp near L1a401b06
L1a401b06:
   cmp word ptr [BP+06],+00
   jz L1a401b19
   cmp word ptr [3864],+00
   jnz L1a401b19
   mov word ptr [B784],0001
L1a401b19:
jmp near L1a401b1d
L1a401b1b:
jmp near L1a401b1d
L1a401b1d:
   les BX,[0C74]
   mov AX,[ES:BX]
   sub AX,[BP-0A]
   mov DX,[13AA]
   inc DX
   cmp AX,DX
   jl L1a401b1b
   cmp word ptr [B784],+00
   jnz L1a401b3a
jmp near L1a4015f7
L1a401b3a:
   mov word ptr [3722],0000
   cmp word ptr [B784],+02
   jnz L1a401b51
   mov AX,00C8
   push AX
   call far A1a402921
   pop CX
L1a401b51:
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   cmp word ptr [BP+06],+00
   jnz L1a401b6a
   mov AX,0001
   push AX
   call far A1a401eb1
   pop CX
L1a401b6a:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a401b70:
   push BP
   mov BP,SP
   sub SP,+58
   push SI
   push DI
   call far A08760930
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   cmp byte ptr [1890],6F
   jnz L1a401b98
   cmp byte ptr [34E9],04
   jnz L1a401b98
jmp near L1a401d81
L1a401b98:
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   xor AX,AX
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
   call far A0abf0002
   add SP,+12
   push SS
   lea AX,[BP-58]
   push AX
   call far A0abf0234
   pop CX
   pop CX
   mov AX,FFFF
   push AX
   mov AX,000F
   push AX
   push SS
   lea AX,[BP-30]
   push AX
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,153E
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
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,22E4
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
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1551
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
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,22D8
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
   call far A0abf078b
   add SP,+0E
   mov AX,FFFF
   push AX
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-30]
   push AX
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,22FD
   push AX
   mov AX,0001
   push AX
   mov AX,0015
   push AX
   push DS
   mov AX,22FD
   push AX
   call far A2388000b
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
   call far A0abf078b
   add SP,+0E
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   push DS
   mov AX,34CE
   push AX
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,155D
   push AX
   mov AX,0002
   push AX
   mov AX,00A0
   push AX
   mov AX,0040
   push AX
   push DS
   mov AX,34CE
   push AX
   call far A0abf078b
   add SP,+0E
   cmp byte ptr [1890],6F
   jz L1a401cdd
jmp near L1a401d6b
L1a401cdd:
   xor SI,SI
jmp near L1a401d63
L1a401ce2:
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
   mov AX,34CE
   push AX
   call far A087600de
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
   mov AX,34CE
   push AX
   call far A087600de
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
   mov AX,34CE
   push AX
   call far A087600de
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
   mov AX,34CE
   push AX
   call far A087600de
   add SP,+0A
   inc SI
L1a401d63:
   cmp SI,+05
   jg L1a401d6b
jmp near L1a401ce2
L1a401d6b:
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   call far A087609ba
jmp near L1a401eab
L1a401d81:
   mov word ptr [2A8E],0001
   call far A07d60779
   mov AL,00
   push AX
   push DS
   mov AX,34CE
   push AX
   call far A09560eaa
   add SP,+06
   xor SI,SI
jmp near L1a401dd3
L1a401da0:
   xor DI,DI
jmp near L1a401dcd
L1a401da4:
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
   mov AX,34CE
   push AX
   call far A087600de
   add SP,+0A
   inc DI
L1a401dcd:
   cmp DI,+0C
   jl L1a401da4
   inc SI
L1a401dd3:
   cmp SI,+13
   jl L1a401da0
   call far A08760930
   call far A08760751
   call far A087609ba
   les BX,[0C74]
   mov SI,[ES:BX]
L1a401dee:
   les BX,[0C74]
   mov AX,[ES:BX]
   sub AX,SI
   cmp AX,0050
   jl L1a401dee
   call far A08760a67
   mov AL,00
   push AX
   push DS
   mov AX,34CE
   push AX
   call far A09560eaa
   add SP,+06
   call far A08760751
   mov AL,00
   push AX
   push DS
   mov AX,34CE
   push AX
   call far A09560eaa
   add SP,+06
   mov word ptr [2AA8],0001
   mov word ptr [2A8E],0000
   call far A07d60779
   xor SI,SI
jmp near L1a401e6e
L1a401e3b:
   xor DI,DI
jmp near L1a401e68
L1a401e3f:
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
   mov AX,34CE
   push AX
   call far A087600de
   add SP,+0A
   inc DI
L1a401e68:
   cmp DI,+0C
   jl L1a401e3f
   inc SI
L1a401e6e:
   cmp SI,+13
   jl L1a401e3b
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   call far A08760930
   call far A08760751
   call far A087609ba
   les BX,[0C74]
   mov SI,[ES:BX]
L1a401e92:
   les BX,[0C74]
   mov AX,[ES:BX]
   sub AX,SI
   cmp AX,003C
   jl L1a401e92
   mov word ptr [2AA8],0000
   call far A07d60779
L1a401eab:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a401eb1:
   push BP
   mov BP,SP
   sub SP,+14
   push SI
   push DI
   cmp word ptr [BP+06],+00
   jz L1a401ec4
   mov AX,0004
jmp near L1a401ec7
L1a401ec4:
   mov AX,0008
L1a401ec7:
   mov [BP-02],AX
   cmp word ptr [BP+06],+00
   jnz L1a401ed3
jmp near L1a401f76
L1a401ed3:
   mov DI,000A
jmp near L1a401ed9
L1a401ed8:
   dec DI
L1a401ed9:
   or DI,DI
   jle L1a401efa
   mov BX,DI
   dec BX
   shl BX,1
   shl BX,1
   mov DX,[BX+B266]
   mov AX,[BX+B264]
   cmp DX,[7E68]
   jl L1a401ed8
   jnz L1a401efa
   cmp AX,[7E66]
   jb L1a401ed8
L1a401efa:
   cmp DI,+0A
   jl L1a401f06
   mov word ptr [BP+06],0000
jmp near L1a401f76
L1a401f06:
   mov SI,0008
jmp near L1a401f4a
L1a401f0b:
   mov BX,SI
   shl BX,1
   shl BX,1
   mov DX,[BX+B266]
   mov AX,[BX+B264]
   mov BX,SI
   inc BX
   shl BX,1
   shl BX,1
   mov [BX+B266],DX
   mov [BX+B264],AX
   push DS
   mov AX,SI
   mov DX,000A
   mul DX
   add AX,B084
   push AX
   push DS
   mov AX,SI
   inc AX
   mov DX,000A
   mul DX
   add AX,B084
   push AX
   call far A238d0008
   add SP,+08
   dec SI
L1a401f4a:
   cmp SI,DI
   jge L1a401f0b
   mov DX,[7E68]
   mov AX,[7E66]
   mov BX,DI
   shl BX,1
   shl BX,1
   mov [BX+B266],DX
   mov [BX+B264],AX
   mov AX,DI
   mov DX,000A
   mul DX
   mov BX,AX
   add BX,B084
   push DS
   pop ES
   mov byte ptr [ES:BX],00
L1a401f76:
   push [BP-02]
   mov AX,0005
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push [B14A]
   push [B148]
   call far A0abf0bd2
   pop CX
   pop CX
   push DS
   mov AX,1579
   push AX
   mov AX,0001
   push AX
   mov AX,0004
   push AX
   xor AX,AX
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push [BP-02]
   mov AX,0004
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,1586
   push AX
   mov AX,0002
   push AX
   mov AX,0002
   push AX
   mov AX,0004
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push [BP-02]
   mov AX,0002
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   xor SI,SI
jmp near L1a40203f
L1a40200f:
   push DS
   mov AX,SI
   mov DX,000A
   mul DX
   add AX,B084
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
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   inc SI
L1a40203f:
   cmp SI,+0A
   jl L1a40200f
   push [BP-02]
   mov AX,0006
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   xor SI,SI
jmp near L1a4020de
L1a402060:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   mov BX,SI
   shl BX,1
   shl BX,1
   push [BX+B266]
   push [BX+B264]
   call far A237300d2
   add SP,+0A
   mov word ptr [BP-14],0000
jmp near L1a4020d1
L1a402086:
   mov AX,SI
   mov DX,0007
   mul DX
   add AX,000F
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   call far A2388000b
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
   push [B14A]
   push [B148]
   call far A087600de
   add SP,+0A
   inc word ptr [BP-14]
L1a4020d1:
   lea BX,[BP-12]
   add BX,[BP-14]
   cmp byte ptr [SS:BX],00
   jnz L1a402086
   inc SI
L1a4020de:
   cmp SI,+0A
   jge L1a4020e6
jmp near L1a402060
L1a4020e6:
   cmp word ptr [BP+06],+00
   jnz L1a4020ef
jmp near L1a4021c0
L1a4020ef:
   push [BP-02]
   mov AX,0007
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   mov BX,DI
   shl BX,1
   shl BX,1
   push [BX+B264]
   call far A23730085
   add SP,+08
   push SS
   lea AX,[BP-12]
   push AX
   call far A2388000b
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
   jnb L1a402166
   push SS
   lea AX,[BP-12]
   push AX
   call far A2388000b
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
jmp near L1a402169
L1a402166:
   mov SI,000C
L1a402169:
   push SI
   push DS
   mov AX,DI
   mov DX,000A
   mul DX
   add AX,B084
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
   push [B14A]
   push [B148]
   call far A0abf08bf
   add SP,+10
   mov AX,DI
   mov DX,000A
   mul DX
   mov BX,AX
   add BX,B084
   push DS
   pop ES
   cmp byte ptr [ES:BX],00
   jnz L1a4021b4
   push CS
   call near offset A1a40095e
jmp near L1a4021b8
L1a4021b4:
   push CS
   call near offset A1a400a65
L1a4021b8:
   xor AX,AX
   push AX
   push CS
   call near offset A1a401eb1
   pop CX
L1a4021c0:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a4021c6:
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   mov word ptr [382C],0001
   mov word ptr [382E],0001
   mov word ptr [383A],0001
   mov AX,0001
   push AX
   mov AX,0005
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push [B14A]
   push [B148]
   call far A0abf0bd2
   pop CX
   pop CX
   push DS
   mov AX,1590
   push AX
   mov AX,0001
   push AX
   mov AX,0004
   push AX
   xor AX,AX
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,159D
   push AX
   mov AX,0001
   push AX
   mov AX,0038
   push AX
   xor AX,AX
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   mov AX,0001
   push AX
   mov AX,0004
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push [BP+08]
   push [BP+06]
   mov AX,0002
   push AX
   mov AX,0002
   push AX
   mov AX,0006
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   mov AX,0001
   push AX
   mov AX,0003
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   mov word ptr [BP-10],0000
jmp near L1a4022df
L1a40229f:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-0E]
   push AX
   mov AX,[BP-10]
   inc AX
   push AX
   call far A23730085
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
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   inc word ptr [BP-10]
L1a4022df:
   cmp word ptr [BP-10],+06
   jl L1a40229f
   mov word ptr [BP-10],0000
jmp near L1a402366
L1a4022ec:
   push DS
   mov AX,[BP-10]
   mov DX,000C
   mul DX
   add AX,B54E
   push AX
   call far A2388000b
   pop CX
   pop CX
   or AX,AX
   jz L1a402338
   push DS
   mov AX,[BP-10]
   mov DX,000C
   mul DX
   add AX,B54E
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
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
jmp near L1a402363
L1a402338:
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
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
L1a402363:
   inc word ptr [BP-10]
L1a402366:
   cmp word ptr [BP-10],+06
   jge L1a40236f
jmp near L1a4022ec
L1a40236f:
   mov AX,0001
   push AX
   mov AX,0002
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,15AA
   push AX
   mov AX,0002
   push AX
   mov AX,0041
   push AX
   mov AX,000E
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,15B0
   push AX
   mov AX,0002
   push AX
   mov AX,004D
   push AX
   mov AX,0006
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   mov AX,0001
   push AX
   mov AX,0004
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,15B9
   push AX
   mov AX,0002
   push AX
   mov AX,0047
   push AX
   mov AX,000C
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   mov AX,0001
   push AX
   mov AX,0007
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
L1a40241a:
   mov byte ptr [BP-01],00
   xor AX,AX
   push AX
   call far A0b8b05b2
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
   mov AX,[13DE]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,000D
   push AX
   mov AX,0001
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   les BX,[0C74]
   mov SI,[ES:BX]
L1a402468:
   les BX,[0C74]
   mov AX,[ES:BX]
   cmp AX,SI
   jz L1a402468
   push DS
   mov AX,15C0
   push AX
   mov AX,0002
   push AX
   mov AX,[13DE]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,000D
   push AX
   mov AX,0001
   push AX
   push [B14A]
   push [B148]
   call far A0abf078b
   add SP,+0E
   mov AX,[13DE]
   add AX,[3712]
   add AX,[3714]
   cmp AX,0005
   jge L1a4024ba
   mov AX,[13DE]
   add AX,[3712]
   add AX,[3714]
jmp near L1a4024bd
L1a4024ba:
   mov AX,0005
L1a4024bd:
   or AX,AX
   jge L1a4024c5
   xor AX,AX
jmp near L1a4024e5
L1a4024c5:
   mov AX,[13DE]
   add AX,[3712]
   add AX,[3714]
   cmp AX,0005
   jge L1a4024e2
   mov AX,[13DE]
   add AX,[3712]
   add AX,[3714]
jmp near L1a4024e5
L1a4024e2:
   mov AX,0005
L1a4024e5:
   mov [13DE],AX
   cmp word ptr [3716],+00
   jnz L1a402500
   cmp word ptr [3722],+0D
   jz L1a402500
   cmp word ptr [3722],+1B
   jz L1a402500
jmp near L1a40241a
L1a402500:
   cmp word ptr [3722],+1B
   jnz L1a40250c
   mov AX,FFFF
jmp near L1a402511
L1a40250c:
   mov AX,[13DE]
jmp near L1a402511
L1a402511:
   pop SI
   mov SP,BP
   pop BP
ret far

A1a402516:
   push BP
   mov BP,SP
   sub SP,+50
   push SI
   push DI
   push DS
   mov AX,15CC
   push AX
   push DS
   mov AX,15C2
   push AX
   push CS
   call near offset A1a4021c6
   add SP,+08
   mov SI,AX
   or SI,SI
   jge L1a402538
jmp near L1a402641
L1a402538:
   push DS
   mov AX,SI
   mov DX,000C
   mul DX
   add AX,B54E
   push AX
   call far A2388000b
   pop CX
   pop CX
   or AX,AX
   jnz L1a402552
jmp near L1a402641
L1a402552:
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-50]
   push AX
   push SI
   call far A23730085
   add SP,+08
   push DS
   mov AX,05FC
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A238d0008
   add SP,+08
   push DS
   mov AX,1914
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,15D4
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   push SS
   lea AX,[BP-50]
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,05FC
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far A238d0008
   add SP,+08
   push DS
   mov AX,1914
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,15D6
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far A23840009
   add SP,+08
   push SS
   lea AX,[BP-50]
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far A23840009
   add SP,+08
   mov AX,8001
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far A2339000c
   add SP,+06
   mov DI,AX
   cmp DI,-01
   jz L1a402631
   push DI
   call far A23440007
   pop CX
   push DS
   mov AX,B596
   push AX
   call far A2382000d
   pop CX
   pop CX
   push DS
   mov AX,B596
   push AX
   push SS
   lea AX,[BP-20]
   push AX
   call far A07cb0006
   add SP,+08
L1a402631:
   push SS
   lea AX,[BP-40]
   push AX
   push CS
   call near offset A1a400afa
   pop CX
   pop CX
   mov AX,0001
jmp near L1a402645
L1a402641:
   xor AX,AX
jmp near L1a402645
L1a402645:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a40264b:
   push BP
   mov BP,SP
   sub SP,+5C
   push SI
   push DI
   push DS
   mov AX,15E3
   push AX
   push DS
   mov AX,15D9
   push AX
   push CS
   call near offset A1a4021c6
   add SP,+08
   mov SI,AX
   or SI,SI
   jge L1a40266d
jmp near L1a4027cb
L1a40266d:
   push DS
   mov AX,SI
   mov DX,000C
   mul DX
   add AX,B54E
   push AX
   push SS
   lea AX,[BP-0C]
   push AX
   call far A238d0008
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
   push [B14A]
   push [B148]
   call far A0abf08bf
   add SP,+10
   cmp word ptr [3722],+1B
   jnz L1a4026bd
jmp near L1a4027cb
L1a4026bd:
   push SS
   lea AX,[BP-0C]
   push AX
   call far A2388000b
   pop CX
   pop CX
   or AX,AX
   jnz L1a4026d0
jmp near L1a4027cb
L1a4026d0:
   push SS
   lea AX,[BP-0C]
   push AX
   push DS
   mov AX,SI
   mov DX,000C
   mul DX
   add AX,B54E
   push AX
   call far A238d0008
   add SP,+08
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-5C]
   push AX
   push SI
   call far A23730085
   add SP,+08
   push DS
   mov AX,05FC
   push AX
   push SS
   lea AX,[BP-4C]
   push AX
   call far A238d0008
   add SP,+08
   push DS
   mov AX,1914
   push AX
   push SS
   lea AX,[BP-4C]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,15E4
   push AX
   push SS
   lea AX,[BP-4C]
   push AX
   call far A23840009
   add SP,+08
   push SS
   lea AX,[BP-5C]
   push AX
   push SS
   lea AX,[BP-4C]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,05FC
   push AX
   push SS
   lea AX,[BP-2C]
   push AX
   call far A238d0008
   add SP,+08
   push DS
   mov AX,1914
   push AX
   push SS
   lea AX,[BP-2C]
   push AX
   call far A23840009
   add SP,+08
   push DS
   mov AX,15E6
   push AX
   push SS
   lea AX,[BP-2C]
   push AX
   call far A23840009
   add SP,+08
   push SS
   lea AX,[BP-5C]
   push AX
   push SS
   lea AX,[BP-2C]
   push AX
   call far A23840009
   add SP,+08
   push SS
   lea AX,[BP-4C]
   push AX
   push CS
   call near offset A1a400cef
   pop CX
   pop CX
   mov AX,8001
   push AX
   push DS
   mov AX,B596
   push AX
   call far A2339000c
   add SP,+06
   mov DI,AX
   cmp DI,-01
   jz L1a4027c7
   push DI
   call far A23440007
   pop CX
   push SS
   lea AX,[BP-2C]
   push AX
   push DS
   mov AX,B596
   push AX
   call far A07cb0006
   add SP,+08
L1a4027c7:
   push CS
   call near offset A1a400a65
L1a4027cb:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a4027d1:
   push BP
   mov BP,SP
   push DS
   mov AX,34CE
   push AX
   call far A0abf0bd2
   pop CX
   pop CX
   push DS
   mov AX,B290
   push AX
   call far A0abf0234
   pop CX
   pop CX
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [B14A]
   push [B148]
   call far A0abf0bec
   add SP,+08
   push [B14A]
   push [B148]
   call far A0abf0bd2
   pop CX
   pop CX
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [B41E]
   push [B41C]
   call far A0abf0bec
   add SP,+08
   push [B41E]
   push [B41C]
   call far A0abf0bd2
   pop CX
   pop CX
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [B28E]
   push [B28C]
   call far A0abf0bec
   add SP,+08
   push [B28E]
   push [B28C]
   call far A0abf0bd2
   pop CX
   pop CX
   mov AX,FFFF
   push AX
   push [1958]
   push DS
   mov AX,B2A8
   push AX
   call far A0abf0bec
   add SP,+08
   push DS
   mov AX,22FD
   push AX
   push DS
   mov AX,B290
   push AX
   call far A0abf0aba
   add SP,+08
   push DS
   mov AX,15E9
   push AX
   push DS
   mov AX,B290
   push AX
   call far A0abf0b56
   add SP,+08
   push DS
   mov AX,15F3
   push AX
   push DS
   mov AX,B290
   push AX
   call far A0abf0b0b
   add SP,+08
   pop BP
ret far

A1a4028ae:
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
   call far A076a05fa
   mov word ptr [383A],0000
L1a4028cd:
   call far A0ce30882
   xor AX,AX
   push AX
   call far A0b8b05b2
   pop CX
   push [3722]
   call far A24d90000
   pop CX
   mov [3722],AX
   xor SI,SI
jmp near L1a402907
L1a4028ec:
   mov AL,[SS:BP+SI-34]
   cbw
   cmp AX,[3722]
   jnz L1a402906
   mov AX,SI
   inc AX
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L1a402906:
   inc SI
L1a402907:
   cmp byte ptr [SS:BP+SI-34],00
   jnz L1a4028ec
   cmp word ptr [3722],+0D
   jz L1a40291c
   cmp word ptr [3722],+1B
   jnz L1a4028cd
L1a40291c:
   pop SI
   mov SP,BP
   pop BP
ret far

A1a402921:
   push BP
   mov BP,SP
   sub SP,+12
   push SI
   push DI
   mov word ptr [B432],0014
   mov word ptr [B434],000D
L1a402935:
   mov SI,FFFF
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400022
   xor DI,DI
jmp near L1a40297a
L1a40294a:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],0C
   jnz L1a402979
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[BP+06]
   jnz L1a402979
   mov SI,DI
L1a402979:
   inc DI
L1a40297a:
   cmp DI,[B5F6]
   jl L1a40294a
   or SI,SI
   jg L1a402987
jmp near L1a402a94
L1a402987:
   mov AX,0010
   push AX
   push [B28E]
   push [B28C]
   push SS
   lea AX,[BP-12]
   push AX
   call far A23900001
   add SP,+0A
   mov AX,0010
   push AX
   push DS
   mov AX,34CE
   push AX
   push [B28E]
   push [B28C]
   call far A23900001
   add SP,+0A
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   les BX,[B28C]
   mov [ES:BX+08],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   les BX,[B28C]
   mov [ES:BX+0A],AX
   push CS
   call near offset A1a401524
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400009
   mov AX,0010
   push AX
   push SS
   lea AX,[BP-12]
   push AX
   push [B28E]
   push [B28C]
   call far A23900001
   add SP,+0A
   cmp word ptr [BP+06],+63
   jnz L1a402a2a
   push CS
   call near offset A1a4028ae
jmp near L1a402a65
L1a402a2a:
   les BX,[0C74]
   mov AX,[ES:BX]
   mov [BP-02],AX
   mov word ptr [383A],0001
L1a402a3a:
   xor AX,AX
   push AX
   call far A0b8b05b2
   pop CX
   call far A0ce30882
   cmp word ptr [3722],+00
   jnz L1a402a56
   cmp word ptr [3716],+00
   jz L1a402a3a
L1a402a56:
   les BX,[0C74]
   mov AX,[ES:BX]
   sub AX,[BP-02]
   cmp AX,0012
   jl L1a402a3a
L1a402a65:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+05],+00
   jz L1a402a94
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+05]
   mov [BP+06],AX
jmp near L1a402935
L1a402a94:
   mov word ptr [B432],000F
   mov word ptr [B434],000B
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400022
   push CS
   call near offset A1a4027d1
   push CS
   call near offset A1a401524
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400009
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a402ace:
   push BP
   mov BP,SP
   sub SP,00B2
   push SI
   push DI
   xor DI,DI
   mov word ptr [BP-54],0000
   mov word ptr [BP-52],0001
   les BX,[BP+06]
   mov [398E],ES
   mov [398C],BX
   push [398E]
   push [398C]
   call far A2388000b
   pop CX
   pop CX
   mov [3E30],AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push CS
   call near offset A1a400dfc
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
   call far A0abf0002
   add SP,+12
   push SS
   lea AX,[BP+FF4E]
   push AX
   call far A0abf0234
   pop CX
   pop CX
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   les BX,[0C74]
   mov AX,[ES:BX]
   mov [BP-5A],AX
   push CS
   call near offset A1a400dfc
   mov SI,AX
   dec SI
jmp near L1a402bb2
L1a402b58:
   mov AX,FFFF
   push AX
   xor AX,AX
   push AX
   push SS
   lea AX,[BP-50]
   push AX
   push SI
   push CS
   call near offset A1a400e29
   add SP,+08
   push AX
   push SS
   lea AX,[BP+FF76]
   push AX
   call far A0abf0bec
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
   jl L1a402b9a
   mov AX,0001
jmp near L1a402b9c
L1a402b9a:
   xor AX,AX
L1a402b9c:
   mul word ptr [BP+14]
   add AX,0004
   push AX
   push SS
   lea AX,[BP+FF76]
   push AX
   call far A0abf078b
   add SP,+0E
   dec SI
L1a402bb2:
   or SI,SI
   jge L1a402b58
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   xor SI,SI
L1a402bc6:
   call far A0ce30882
   inc DI
   mov AX,DI
   cmp AX,000C
   jl L1a402bd5
   xor DI,DI
L1a402bd5:
   test DI,0001
   jnz L1a402be2
   mov AX,[BP-52]
   cmp AX,SI
   jz L1a402c3d
L1a402be2:
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
   call far A087600de
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
   call far A087600de
   add SP,+0A
L1a402c3d:
   mov [BP-52],SI
   xor AX,AX
   push AX
   call far A0b8b05b2
   pop CX
   push [3722]
   call far A24d90000
   pop CX
   mov [3722],AX
   mov AX,[3712]
   add AX,[3714]
   jz L1a402cb4
   les BX,[0C74]
   mov AX,[ES:BX]
   sub AX,[BP-54]
   cwd
   xor AX,DX
   sub AX,DX
   cmp AX,0001
   jle L1a402cb4
   les BX,[0C74]
   mov AX,[ES:BX]
   mov [BP-54],AX
   mov AX,[3712]
   add AX,[3714]
   add SI,AX
   or SI,SI
   jge L1a402c8e
   xor AX,AX
jmp near L1a402c90
L1a402c8e:
   mov AX,SI
L1a402c90:
   mov DX,[BP+10]
   dec DX
   cmp AX,DX
   jle L1a402c9e
   mov AX,[BP+10]
   dec AX
jmp near L1a402ca8
L1a402c9e:
   or SI,SI
   jge L1a402ca6
   xor AX,AX
jmp near L1a402ca8
L1a402ca6:
   mov AX,SI
L1a402ca8:
   mov SI,AX
   les BX,[0C74]
   mov AX,[ES:BX]
   mov [BP-5A],AX
L1a402cb4:
   les BX,[0C74]
   mov AX,[ES:BX]
   sub AX,[BP-5A]
   cmp AX,012C
   jle L1a402cd5
   cmp word ptr [BP+12],+00
   jz L1a402cd5
   mov word ptr [3722],0044
   mov AX,[3722]
jmp near L1a402d4c
L1a402cd5:
   mov word ptr [BP-58],0000
   cmp word ptr [3722],+1B
   jnz L1a402ce7
   mov word ptr [3722],0051
L1a402ce7:
   cmp word ptr [3722],+0D
   jz L1a402cfc
   cmp word ptr [3722],+20
   jz L1a402cfc
   cmp word ptr [3716],+00
   jz L1a402d0d
L1a402cfc:
   les BX,[BP+0A]
   mov AL,[ES:BX+SI]
   cbw
   mov [3722],AX
   mov word ptr [BP-58],0001
jmp near L1a402d3e
L1a402d0d:
   mov word ptr [BP-56],0000
jmp near L1a402d2c
L1a402d14:
   les BX,[BP+0A]
   add BX,[BP-56]
   mov AL,[ES:BX]
   cbw
   cmp AX,[3722]
   jnz L1a402d29
   mov word ptr [BP-58],0001
L1a402d29:
   inc word ptr [BP-56]
L1a402d2c:
   push [BP+0C]
   push [BP+0A]
   call far A2388000b
   pop CX
   pop CX
   cmp AX,[BP-56]
   ja L1a402d14
L1a402d3e:
   cmp word ptr [BP-58],+00
   jnz L1a402d47
jmp near L1a402bc6
L1a402d47:
   mov AX,[3722]
jmp near L1a402d4c
L1a402d4c:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1a402d52:
   push BP
   mov BP,SP
   mov AX,0016
   push AX
   mov AX,0001
   push AX
   call far A0ce301e0
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
   mov AX,1614
   push AX
   push DS
   mov AX,15FC
   push AX
   push CS
   call near offset A1a402ace
   add SP,+14
   cmp word ptr [3722],+59
   jnz L1a402d98
   mov AX,0001
jmp near L1a402d9a
L1a402d98:
   xor AX,AX
L1a402d9a:
jmp near L1a402d9c
L1a402d9c:
   pop BP
ret far

A1a402d9e:
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   push DS
   mov AX,18BF
   push AX
   push CS
   call near offset A1a400afa
   pop CX
   pop CX
L1a402db0:
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   call far A1eb72159
   push CS
   call near offset A1a401524
   xor AX,AX
   push AX
   push CS
   call near offset A1a401eb1
   pop CX
   push DS
   mov AX,B138
   push AX
   call far A0abf0bd2
   pop CX
   pop CX
   mov AX,0008
   push AX
   mov AX,0007
   push AX
   push [B41E]
   push [B41C]
   call far A0abf0bec
   add SP,+08
   push [B41E]
   push [B41C]
   call far A0abf0bd2
   pop CX
   pop CX
   cmp word ptr [1954],+00
   jz L1a402e4a
   cmp byte ptr [34E9],04
   jnz L1a402e4a
   xor SI,SI
jmp near L1a402e43
L1a402e10:
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
   mov AX,[1954]
   mov CL,08
   shl AX,CL
   add AX,SI
   add AX,4000
   push AX
   push [B41E]
   push [B41C]
   call far A087600de
   add SP,+0A
   inc SI
L1a402e43:
   cmp SI,+10
   jl L1a402e10
jmp near L1a402e90
L1a402e4a:
   push [239D]
   push [239B]
   mov AX,0002
   push AX
   mov AX,001C
   push AX
   xor AX,AX
   push AX
   push [B41E]
   push [B41C]
   call far A0abf078b
   add SP,+0E
   push [23A1]
   push [239F]
   mov AX,0002
   push AX
   mov AX,0024
   push AX
   xor AX,AX
   push AX
   push [B41E]
   push [B41C]
   call far A0abf078b
   add SP,+0E
L1a402e90:
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   mov AX,0008
   push AX
   mov AX,0009
   push AX
   mov AX,0018
   push AX
   mov AX,0001
   push AX
   push [19CB]
   mov AX,0001
   push AX
   push DS
   mov AX,19BF
   push AX
   push DS
   mov AX,195A
   push AX
   push CS
   call near offset A1a402ace
   add SP,+14
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   cmp word ptr [3722],+05
   jnz L1a402eff
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a4027d1
   push CS
   call near offset A1a401524
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   call far A1db409a5
jmp near L1a403198
L1a402eff:
   cmp word ptr [3722],+1B
   jz L1a402f0d
   cmp word ptr [3722],+51
   jnz L1a402f13
L1a402f0d:
   mov DI,0001
jmp near L1a403198
L1a402f13:
   cmp word ptr [3722],+50
   jnz L1a402f88
   mov word ptr [BC14],0000
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400022
   push CS
   call near offset A1a4027d1
   push CS
   call near offset A1a40031c
   push DS
   mov AX,18B7
   push AX
   push CS
   call near offset A1a400afa
   pop CX
   pop CX
   mov AX,[1956]
   mov [7E40],AX
   xor AX,AX
   push AX
   call far A1eb704c1
   pop CX
   push CS
   call near offset A1a401524
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400009
   xor AX,AX
   push AX
   push CS
   call near offset A1a4015ac
   pop CX
   push DS
   mov AX,18C9
   push AX
   call far A0ce308d6
   pop CX
   pop CX
   push DS
   mov AX,18BF
   push AX
   push CS
   call near offset A1a400afa
   pop CX
   pop CX
jmp near L1a403198
L1a402f88:
   cmp word ptr [3722],+10
   jnz L1a402fc8
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a4027d1
   push CS
   call near offset A1a401524
   push CS
   call near offset A1a40031c
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   call far A1eb703be
   mov byte ptr [B5D6],00
   xor AX,AX
   push AX
   push CS
   call near offset A1a4015ac
   pop CX
jmp near L1a403198
L1a402fc8:
   cmp word ptr [3722],+45
   jnz L1a402fdb
   mov AX,0014
   push AX
   push CS
   call near offset A1a402921
   pop CX
jmp near L1a403198
L1a402fdb:
   cmp word ptr [3722],+52
   jnz L1a403042
   push CS
   call near offset A1a402516
   or AX,AX
   jz L1a40303f
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400022
   push CS
   call near offset A1a4027d1
   push CS
   call near offset A1a40031c
   call far A1eb72159
   push CS
   call near offset A1a401524
   call far A1eb703be
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400009
   xor AX,AX
   push AX
   push CS
   call near offset A1a4015ac
   pop CX
   push DS
   mov AX,18C9
   push AX
   call far A0ce308d6
   pop CX
   pop CX
   push DS
   mov AX,18BF
   push AX
   push CS
   call near offset A1a400afa
   pop CX
   pop CX
L1a40303f:
jmp near L1a403198
L1a403042:
   cmp word ptr [3722],+53
   jnz L1a403054
   xor AX,AX
   push AX
   push CS
   call near offset A1a402921
   pop CX
jmp near L1a403198
L1a403054:
   cmp word ptr [3722],+49
   jnz L1a403067
   mov AX,0001
   push AX
   push CS
   call near offset A1a400f8a
   pop CX
jmp near L1a403198
L1a403067:
   cmp word ptr [3722],+4F
   jz L1a403075
   cmp word ptr [3722],+48
   jnz L1a403081
L1a403075:
   mov AX,0008
   push AX
   push CS
   call near offset A1a402921
   pop CX
jmp near L1a403198
L1a403081:
   cmp word ptr [3722],+43
   jnz L1a403094
   mov AX,000C
   push AX
   push CS
   call near offset A1a402921
   pop CX
jmp near L1a403198
L1a403094:
   cmp word ptr [3722],+44
   jz L1a40309e
jmp near L1a403188
L1a40309e:
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   mov word ptr [BC14],0000
   push CS
   call near offset A1a400022
   push CS
   call near offset A1a4027d1
   push CS
   call near offset A1a40031c
   mov word ptr [B430],0000
   mov word ptr [3866],0000
L1a4030c6:
   cmp word ptr [B430],+00
   jz L1a4030db
   push CS
   call near offset A1a400022
   mov AX,0001
   push AX
   call far A08760700
   pop CX
L1a4030db:
   mov BX,[B430]
   cmp byte ptr [BX+19F5],00
   jnz L1a4030ec
   mov word ptr [B430],0000
L1a4030ec:
   mov BX,[B430]
   shl BX,1
   shl BX,1
   push [BX+19CF]
   push [BX+19CD]
   push CS
   call near offset A1a400afa
   pop CX
   pop CX
   mov BX,[B430]
   mov AL,[BX+19F5]
   cbw
   mov [7E40],AX
   xor AX,AX
   push AX
   call far A1eb704c1
   pop CX
   push CS
   call near offset A1a401524
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400009
   mov BX,[B430]
   shl BX,1
   shl BX,1
   push [BX+1A01]
   push [BX+19FF]
   call far A0b8b06c4
   pop CX
   pop CX
   cmp word ptr [3864],+00
   jz L1a40315f
   mov AX,0001
   push AX
   push CS
   call near offset A1a4015ac
   pop CX
   call far A0b8b0679
   inc word ptr [B430]
jmp near L1a403165
L1a40315f:
   mov word ptr [3868],0001
L1a403165:
   cmp word ptr [3868],+00
   jnz L1a40316f
jmp near L1a4030c6
L1a40316f:
   push DS
   mov AX,18C9
   push AX
   call far A0ce308d6
   pop CX
   pop CX
   push DS
   mov AX,18BF
   push AX
   push CS
   call near offset A1a400afa
   pop CX
   pop CX
jmp near L1a403198
L1a403188:
   cmp word ptr [3722],+4E
   jnz L1a403198
   mov AX,0063
   push AX
   push CS
   call near offset A1a402921
   pop CX
L1a403198:
   or DI,DI
   jnz L1a40319f
jmp near L1a402db0
L1a40319f:
   pop DI
   pop SI
   pop BP
ret far

A1a4031a3:
   push BP
   mov BP,SP
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far A0c500001
   mov SP,BP
   push DS
   mov AX,05FC
   push AX
   push DS
   mov AX,B596
   push AX
   call far A238d0008
   mov SP,BP
   push DS
   mov AX,1617
   push AX
   push DS
   mov AX,B596
   push AX
   call far A23840009
   mov SP,BP
   push CS
   call near offset A1a40095e
   call far A24360006
   push [22D6]
   mov DX,B800
   xor AX,AX
   push DX
   push AX
   push DS
   mov AX,1A27
   push AX
   call far A0c480006
   mov SP,BP
   mov AX,0010
   push AX
   mov AX,0046
   push AX
   mov AX,0007
   push AX
   mov AX,000B
   push AX
   call far A24e90008
   mov SP,BP
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   call far A246e000b
   mov SP,BP
   mov AX,000F
   push AX
   call far A24390003
   pop CX
   mov AX,0001
   push AX
   call far A24390018
   pop CX
   call far A24360006
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far A0c500086
   mov SP,BP
   push DS
   mov AX,189A
   push AX
   call far A0ce3001b
   mov SP,BP
   call far A0b8b0b71
   call far A0c500272
   or AX,AX
   jnz L1a403264
jmp near L1a403445
L1a403264:
   call far A08760b72
   call far A08760930
   push CS
   call near offset A1a400a65
   push DS
   mov AX,1890
   push AX
   call far A07d60007
   mov SP,BP
   mov word ptr [2A4C],0001
   mov word ptr [2A4E],0001
   mov word ptr [2A58],0001
   call far A07d60779
   xor AX,AX
   push AX
   mov AX,0009
   push AX
   push DS
   mov AX,34CE
   push AX
   call far A0abf0bec
   mov SP,BP
   mov AX,0300
   push AX
   push DS
   mov AX,0194
   push AX
   push DS
   mov AX,B906
   push AX
   call far A23900001
   mov SP,BP
   push CS
   call near offset A1a401b70
   call far A0ce30299
   push DS
   mov AX,18C9
   push AX
   call far A0ce308d6
   mov SP,BP
   mov word ptr [2A50],0001
   mov word ptr [2A52],0001
   mov word ptr [2A54],0001
   mov word ptr [2A56],0001
   mov word ptr [2A5A],0001
   mov word ptr [2A66],0001
   call far A07d60779
   push CS
   call near offset A1a400022
   mov AX,0300
   push AX
   push DS
   mov AX,B906
   push AX
   push DS
   mov AX,0194
   push AX
   call far A23900001
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
   xor AX,AX
   push AX
   push DS
   mov AX,B290
   push AX
   call far A0abf0002
   mov SP,BP
   mov [B28E],DS
   mov word ptr [B28C],B2B8
   mov [B14A],DS
   mov word ptr [B148],B2C8
   mov [B41E],DS
   mov word ptr [B41C],B2D8
   mov word ptr [B140],0000
   mov word ptr [B142],0000
   mov word ptr [B138],0000
   mov word ptr [B13A],00BC
   mov word ptr [B13C],0140
   mov word ptr [B13E],000C
   mov word ptr [B432],000F
   mov word ptr [B434],000B
   cmp word ptr [1954],+00
   jz L1a4033ca
   cmp byte ptr [34E9],04
   jnz L1a4033ca
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AX,0004
   push AX
   mov AX,0004
   push AX
   mov AX,000B
   push AX
   mov AX,0030
   push AX
   mov AX,000C
   push AX
   push DS
   mov AX,B72C
   push AX
   call far A0abf0002
   mov SP,BP
   mov AX,[B756]
   mov [B766],AX
   mov AX,[B75A]
   mov [B76A],AX
jmp near L1a4033ef
L1a4033ca:
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
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
   mov AX,B72C
   push AX
   call far A0abf0002
   mov SP,BP
L1a4033ef:
   call far A1d9b0008
   call far A0dbc0008
   push CS
   call near offset A1a401275
   call far A1eb70002
   mov AX,0001
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a4027d1
   call far A08760751
   xor AX,AX
   push AX
   call far A08760700
   pop CX
   push CS
   call near offset A1a400009
   push CS
   call near offset A1a402d9e
   push CS
   call near offset A1a400022
   push DS
   mov AX,B290
   push AX
   call far A0abf0774
   mov SP,BP
   call far A07d609b1
   call far A08760ddf
   call far A0ce3060a
L1a403445:
   call far A0b8b0bcc
   mov AX,0019
   push AX
   mov AX,0050
   push AX
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   call far A24e90008
   mov SP,BP
   mov AX,000F
   push AX
   call far A24390003
   pop CX
   xor AX,AX
   push AX
   call far A24390018
   pop CX
   call far A24360006
   push [22D4]
   mov DX,B800
   xor AX,AX
   push DX
   push AX
   push DS
   mov AX,1D02
   push AX
   call far A0c480006
   mov SP,BP
   mov AX,0018
   push AX
   mov AX,0001
   push AX
   call far A246e000b
   mov SP,BP
   pop BP
ret far

A1a4034a1:
   push BP
   mov BP,SP
   sub SP,+0C
   call far A07d609b1
   call far A08760ddf
   call far A0b8b0bcc
   call far A0ce3060a
   mov AX,0019
   push AX
   mov AX,0050
   push AX
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   call far A24e90008
   add SP,+08
   mov AX,000F
   push AX
   call far A24390003
   pop CX
   xor AX,AX
   push AX
   call far A24390018
   pop CX
   call far A24360006
   mov AX,0005
   push AX
   mov AX,0001
   push AX
   call far A246e000b
   pop CX
   pop CX
   push DS
   mov AX,161C
   push AX
   call far A24540006
   pop CX
   pop CX
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-0C]
   push AX
   push [BP+06]
   call far A23730085
   add SP,+08
   push DX
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,1656
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,165A
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,191C
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,165D
   push AX
   call far A24540006
   pop CX
   pop CX
   cmp word ptr [BP+06],+09
   jnz L1a40359e
   push DS
   mov AX,1662
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,16AA
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,16D6
   push AX
   call far A24540006
   pop CX
   pop CX
   push DS
   mov AX,170E
   push AX
   call far A24540006
   pop CX
   pop CX
   cmp word ptr [0DBD],+00
   jz L1a40359c
   push DS
   mov AX,173F
   push AX
   call far A24540006
   pop CX
   pop CX
L1a40359c:
jmp near L1a4035aa
L1a40359e:
   push DS
   mov AX,178B
   push AX
   call far A24540006
   pop CX
   pop CX
L1a4035aa:
   mov AX,0001
   push AX
   call far A22d10008
   pop CX
   mov SP,BP
   pop BP
ret far

Segment 1d9b ;; JINFO.C:JINFO
A1d9b0008:
   push BP
   mov BP,SP
   sub SP,+06
   push SI
   push DI
   mov DI,4006
   mov word ptr [BP-06],0000
jmp near L1d9b005d
L1d9b001a:
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   mov word ptr [ES:BX],4700
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   mov [ES:BX+06],DS
   mov word ptr [ES:BX+04],17CA
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   mov [ES:BX+02],DI
   inc word ptr [BP-06]
L1d9b005d:
   cmp word ptr [BP-06],0258
   jl L1d9b001a
   mov AX,8000
   push AX
   push DS
   mov AX,18AE
   push AX
   call far A231f003f
   add SP,+06
   mov SI,AX
jmp near L1d9b013a
L1d9b007a:
   mov AX,0002
   push AX
   push DS
   mov AX,[BP-06]
   shl AX,1
   shl AX,1
   shl AX,1
   add AX,7E86
   push AX
   push SI
   call far A2346000d
   add SP,+08
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-04]
   push AX
   push SI
   call far A2346000d
   add SP,+08
   mov AX,[BP-04]
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
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
   call far A2346000d
   add SP,+08
   mov AL,[BP-01]
   cbw
   inc AX
   push AX
   call far A22d7000a
   pop CX
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
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
   add BX,7E86
   push DS
   pop ES
   push [ES:BX+06]
   push [ES:BX+04]
   push SI
   call far A2346000d
   add SP,+08
   mov BX,[BP-06]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   les BX,[ES:BX+04]
   mov AL,[BP-01]
   cbw
   add BX,AX
   mov byte ptr [ES:BX],00
L1d9b013a:
   mov AX,0002
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   push SI
   call far A2346000d
   add SP,+08
   or AX,AX
   jle L1d9b0153
jmp near L1d9b007a
L1d9b0153:
   mov word ptr [BP-06],0000
jmp near L1d9b0168
L1d9b015a:
   mov BX,[BP-06]
   shl BX,1
   mov word ptr [BX+BC06],0000
   inc word ptr [BP-06]
L1d9b0168:
   cmp word ptr [BP-06],+06
   jl L1d9b015a
   or word ptr [BC0E],0002
   or word ptr [BC06],0001
   or word ptr [BC0A],0001
   or word ptr [BC0C],0000
   or word ptr [BC10],0002
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1db4 ;; DESIGN.C:DESIGN
A1db40002:
   push BP
   mov BP,SP
   push DS
   mov AX,B2D8
   push AX
   call far A0abf0bd2
   mov SP,BP
   push [BP+08]
   push [BP+06]
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
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
   mov AX,B2D8
   push AX
   call far A0abf08bf
   mov SP,BP
   pop BP
ret far

A1db4004e:
   push BP
   mov BP,SP
   sub SP,+10
   push SI
   mov SI,[BP+06]
   push DS
   mov AX,17CE
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   push [BX+B438]
   push [BX+B436]
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   mov AX,001E
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,17E0
   push AX
   mov AX,0002
   push AX
   mov AX,0006
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+0D]
   call far A23730085
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
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,17F2
   push AX
   mov AX,0002
   push AX
   mov AX,000C
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   call far A23730085
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
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1804
   push AX
   mov AX,0002
   push AX
   mov AX,0012
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+07]
   call far A23730085
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
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1816
   push AX
   mov AX,0002
   push AX
   mov AX,0018
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A23730085
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
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],0040
   jz L1db40257
   push DS
   mov AX,1828
   push AX
   mov AX,0002
   push AX
   mov AX,001E
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
L1db40257:
   pop SI
   mov SP,BP
   pop BP
ret far

A1db4025c:
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
   add AX,[BCAA]
   mov [BP+08],AX
   mov word ptr [BP-4A],0000
jmp near L1db402e6
L1db4028c:
   mov AX,[BP-4A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,DI
   jnz L1db402e3
   mov AX,[BP-4A]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP+08]
   jnz L1db402e3
   mov SI,[BP-4A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   les BX,[BX+B436]
   mov [BP-42],ES
   mov [BP-44],BX
L1db402e3:
   inc word ptr [BP-4A]
L1db402e6:
   mov AX,[BP-4A]
   cmp AX,[B5F6]
   jl L1db4028c
   cmp SI,-01
   jnz L1db402fc
   mov [BP-42],DS
   mov word ptr [BP-44],1834
L1db402fc:
   push DS
   mov AX,B2D8
   push AX
   call far A0abf0bd2
   pop CX
   pop CX
   push DS
   mov AX,1839
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1845
   push AX
   mov AX,0002
   push AX
   mov AX,0006
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,1850
   push AX
   mov AX,0002
   push AX
   mov AX,000C
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   push DS
   mov AX,185A
   push AX
   mov AX,0002
   push AX
   mov AX,0012
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
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
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   mov AX,0002
   push AX
   mov AX,0018
   push AX
   xor AX,AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf0843
   add SP,+0A
   push AX
   call far A24d90000
   pop CX
   mov [3722],AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf0bd2
   pop CX
   pop CX
   mov AX,[3722]
   sub AX,0041
   cmp AX,000F
   jbe L1db403d4
jmp near L1db404f6
L1db403d4:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y1db403dd]
Y1db403dd:	dw L1db403fd,L1db404f6,L1db404f6,L1db40419,L1db404f6,L1db404f6,L1db404f6,L1db404f6
		dw L1db404f6,L1db404f6,L1db404e5,L1db404f6,L1db404ef,L1db404f6,L1db404b0,L1db40436
L1db403fd:
   mov SI,[B5F6]
   push [BP+08]
   push DI
   mov AX,0003
   push AX
   call far A1eb7188c
   add SP,+06
L1db40411:
   mov word ptr [BP-46],0001
jmp near L1db404f6
L1db40419:
   or SI,SI
   jg L1db40420
jmp near L1db40998
L1db40420:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov byte ptr [ES:BX],03
jmp near L1db40998
L1db40436:
   push [BP+08]
   push DI
   mov AX,[17CC]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   push AX
   call far A1eb7188c
   add SP,+06
   mov AX,001F
   push AX
   push DS
   mov AX,[17CC]
   mov DX,001F
   mul DX
   add AX,9146
   push AX
   push DS
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   add AX,9146
   push AX
   call far A23900001
   add SP,+0A
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov [ES:BX+01],DI
   mov AX,[BP+08]
   push AX
   mov AX,[B5F6]
   dec AX
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
jmp near L1db40998
L1db404b0:
   mov AX,[17CC]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov [ES:BX+01],DI
   mov AX,[BP+08]
   push AX
   mov AX,[17CC]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
   call far A1a401524
jmp near L1db40998
L1db404e5:
   or SI,SI
   jl L1db404f6
   mov [17CC],SI
jmp near L1db404f6
L1db404ef:
   or SI,SI
   jl L1db404f6
jmp near L1db40411
L1db404f6:
   cmp word ptr [BP-46],+00
   jnz L1db404ff
jmp near L1db4099d
L1db404ff:
   push SI
   push CS
   call near offset A1db4004e
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   push [BX+B438]
   push [BX+B436]
   push SS
   lea AX,[BP-40]
   push AX
   call far A238d0008
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
   mov AX,B2D8
   push AX
   call far A0abf08bf
   add SP,+10
   push SS
   lea AX,[BP-40]
   push AX
   call far A24d6000b
   pop CX
   pop CX
   mov word ptr [BP-4A],0000
jmp near L1db405a3
L1db40567:
   mov BX,[BP-4A]
   shl BX,1
   shl BX,1
   push [BX+B438]
   push [BX+B436]
   push SS
   lea AX,[BP-40]
   push AX
   call far A238a0006
   add SP,+08
   or AX,AX
   jnz L1db405a0
   mov AL,[BP-4A]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX],AL
jmp near L1db405a9
L1db405a0:
   inc word ptr [BP-4A]
L1db405a3:
   cmp word ptr [BP-4A],+45
   jl L1db40567
L1db405a9:
   push SI
   push CS
   call near offset A1db4004e
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+0D]
   call far A23730085
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
   mov AX,B2D8
   push AX
   call far A0abf08bf
   add SP,+10
   cmp byte ptr [BP-40],00
   jz L1db4061c
   push SS
   lea AX,[BP-40]
   push AX
   call far A2457000a
   pop CX
   pop CX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
L1db4061c:
   push SI
   push CS
   call near offset A1db4004e
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   call far A23730085
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
   mov AX,B2D8
   push AX
   call far A0abf08bf
   add SP,+10
   cmp byte ptr [BP-40],00
   jz L1db4068f
   push SS
   lea AX,[BP-40]
   push AX
   call far A2457000a
   pop CX
   pop CX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
L1db4068f:
   push SI
   push CS
   call near offset A1db4004e
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+07]
   call far A23730085
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
   mov AX,B2D8
   push AX
   call far A0abf08bf
   add SP,+10
   cmp byte ptr [BP-40],00
   jz L1db40702
   push SS
   lea AX,[BP-40]
   push AX
   call far A2457000a
   pop CX
   pop CX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+07],AX
L1db40702:
   push SI
   push CS
   call near offset A1db4004e
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+13]
   call far A23730085
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
   mov AX,B2D8
   push AX
   call far A0abf08bf
   add SP,+10
   cmp byte ptr [BP-40],00
   jz L1db40775
   push SS
   lea AX,[BP-40]
   push AX
   call far A2457000a
   pop CX
   pop CX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+13],AX
L1db40775:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+B150]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+B1DA]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],0040
   jnz L1db407f7
jmp near L1db4096a
L1db407f7:
   push SI
   push CS
   call near offset A1db4004e
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],15
   jnz L1db40819
   mov word ptr [BP-48],0001
jmp near L1db4081e
L1db40819:
   mov word ptr [BP-48],0002
L1db4081e:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jnz L1db4083d
   mov byte ptr [BP-40],00
jmp near L1db40861
L1db4083d:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push SS
   lea AX,[BP-40]
   push AX
   call far A238d0008
   add SP,+08
L1db40861:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+07]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+05]
   push [B28E]
   push [B28C]
   call far A0abf0bec
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push [B28E]
   push [B28C]
   call far A0abf08bf
   add SP,+10
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1db40910
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far A23f70008
   pop CX
   pop CX
L1db40910:
   push SS
   lea AX,[BP-40]
   push AX
   call far A2388000b
   pop CX
   pop CX
   inc AX
   push AX
   call far A22d7000a
   pop CX
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far A238d0008
   add SP,+08
   push SI
   call far A1eb70206
   pop CX
L1db4096a:
   push SI
   push CS
   call near offset A1db4004e
   pop CX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov BX,[BX+B618]
   shl BX,1
   mov word ptr [BX+2A4A],0001
   call far A07d60779
L1db40998:
   mov AX,0001
jmp near L1db4099f
L1db4099d:
   xor AX,AX
L1db4099f:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1db409a5:
   push BP
   mov BP,SP
   sub SP,+4A
   push SI
   push DI
   mov word ptr [BP-4A],0000
   mov word ptr [BP-46],0001
   mov word ptr [BP-42],0000
   mov word ptr [BCAA],0000
   mov word ptr [13A8],0001
   mov byte ptr [BP-40],00
   mov byte ptr [BP-20],00
   call far A1eb72159
   mov AX,[9147]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
   mov AX,[9149]
   cwd
   idiv BX
   mov SI,AX
   call far A1a401524
L1db409ed:
   cmp word ptr [BP-42],+00
   jz L1db40a1e
   mov AX,[BP-46]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   call far A1a401486
   pop CX
   pop CX
   mov word ptr [BP-4A],0001
L1db40a1e:
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
   push [B28E]
   push [B28C]
   call far A087600de
   add SP,+0A
L1db40a46:
   xor AX,AX
   push AX
   call far A0b8b02fd
   pop CX
   cmp word ptr [3712],+00
   jnz L1db40a6a
   cmp word ptr [3714],+00
   jnz L1db40a6a
   cmp word ptr [3722],+00
   jnz L1db40a6a
   cmp word ptr [BP-4A],+00
   jz L1db40a46
L1db40a6a:
   mov word ptr [BP-4A],0000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
   xor AX,AX
   push AX
   call far A1eb712b3
   pop CX
   xor AX,AX
   push AX
   call far A1eb70d4c
   pop CX
   call far A1eb72500
   cmp word ptr [3712],+00
   jnz L1db40aae
   cmp word ptr [3714],+00
   jnz L1db40aae
jmp near L1db40bfc
L1db40aae:
   mov AX,[B432]
   mov BX,0002
   cwd
   idiv BX
   dec AX
   mul word ptr [3716]
   inc AX
   mul word ptr [3712]
   add DI,AX
   mov AX,[B434]
   cwd
   idiv BX
   dec AX
   mul word ptr [3716]
   inc AX
   mul word ptr [3714]
   add SI,AX
   or DI,DI
   jge L1db40adb
   xor DI,DI
L1db40adb:
   cmp DI,0080
   jl L1db40ae4
   mov DI,007F
L1db40ae4:
   or SI,SI
   jge L1db40aea
   xor SI,SI
L1db40aea:
   cmp SI,+40
   jl L1db40af2
   mov SI,003F
L1db40af2:
   mov AX,DI
   mov CL,04
   shl AX,CL
   les BX,[B28C]
   cmp AX,[ES:BX+08]
   jge L1db40b21
   mov AX,[B432]
   shl AX,1
   shl AX,1
   shl AX,1
   sub [ES:BX+08],AX
   cmp word ptr [ES:BX+08],+00
   jge L1db40b1c
   mov word ptr [ES:BX+08],0000
L1db40b1c:
   call far A1a401524
L1db40b21:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov DX,[B432]
   mov CL,04
   shl DX,CL
   add AX,DX
   add AX,FFF0
   mov DX,DI
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jg L1db40b7a
   mov AX,[B432]
   shl AX,1
   shl AX,1
   shl AX,1
   add [ES:BX+08],AX
   mov AX,[ES:BX+08]
   mov DX,0080
   sub DX,[B432]
   mov CL,04
   shl DX,CL
   add DX,+08
   cmp AX,DX
   jl L1db40b75
   mov AX,0080
   sub AX,[B432]
   mov CL,04
   shl AX,CL
   add AX,0008
   mov [ES:BX+08],AX
L1db40b75:
   call far A1a401524
L1db40b7a:
   mov AX,SI
   mov CL,04
   shl AX,CL
   les BX,[B28C]
   cmp AX,[ES:BX+0A]
   jge L1db40ba9
   mov AX,[B434]
   shl AX,1
   shl AX,1
   shl AX,1
   sub [ES:BX+0A],AX
   cmp word ptr [ES:BX+0A],+00
   jge L1db40ba4
   mov word ptr [ES:BX+0A],0000
L1db40ba4:
   call far A1a401524
L1db40ba9:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov DX,[B434]
   dec DX
   mov CL,04
   shl DX,CL
   add AX,DX
   mov DX,SI
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jg L1db40bfc
   mov AX,[B434]
   shl AX,1
   shl AX,1
   shl AX,1
   add [ES:BX+0A],AX
   mov AX,[ES:BX+0A]
   mov DX,0040
   sub DX,[B434]
   inc DX
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jl L1db40bf7
   mov AX,0040
   sub AX,[B434]
   inc AX
   mov CL,04
   shl AX,CL
   mov [ES:BX+0A],AX
L1db40bf7:
   call far A1a401524
L1db40bfc:
   push [3722]
   call far A24d90000
   pop CX
   mov CX,000E
   mov BX,offset Y1db40c1c
L1db40c0c:
   cmp AX,[CS:BX]
   jz L1db40c18
   inc BX
   inc BX
   loop L1db40c0c
jmp near L1db41016
L1db40c18:
jmp near [CS:BX+1C]
Y1db40c1c:	dw 0009,000d,0020,0048,0049,004b,004c
		dw 004e,004f,0053,0056,0059,005a,0060
		dw L1db40d2b,L1db40c54,L1db40d57,L1db40dcc,L1db40d7c,L1db40d39,L1db40ecf
		dw L1db40fc6,L1db40e8b,L1db40ff3,L1db40d95,L1db40f4d,L1db40e99,L1db40f0f
L1db40c54:
   push DS
   mov AX,B2D8
   push AX
   call far A0abf0bd2
   pop CX
   pop CX
   push DS
   mov AX,1860
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
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
   mov AX,B2D8
   push AX
   call far A0abf08bf
   add SP,+10
   push SS
   lea AX,[BP-40]
   push AX
   call far A24d6000b
   pop CX
   pop CX
   mov word ptr [BP-44],0000
jmp near L1db40d22
L1db40cae:
   mov BX,[BP-44]
   shl BX,1
   shl BX,1
   shl BX,1
   add BX,7E86
   push DS
   pop ES
   push [ES:BX+06]
   push [ES:BX+04]
   push SS
   lea AX,[BP-40]
   push AX
   call far A238a0006
   add SP,+08
   or AX,AX
   jnz L1db40d1f
   mov AX,[BP-44]
   mov [BP-46],AX
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,7E86
   push DS
   pop ES
   mov BX,[ES:BX]
   mov CL,08
   sar BX,CL
   and BX,003F
   shl BX,1
   mov word ptr [BX+2A4A],0001
   call far A07d60779
jmp near L1db40d74
L1db40d1f:
   inc word ptr [BP-44]
L1db40d22:
   cmp word ptr [BP-44],0258
   jl L1db40cae
jmp near L1db40d74
L1db40d2b:
   mov AX,[BP-42]
   neg AX
   sbb AX,AX
   inc AX
   mov [BP-42],AX
jmp near L1db41016
L1db40d39:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-46],AX
jmp near L1db41016
L1db40d57:
   mov AX,[BP-46]
   or AX,C000
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   mov [ES:BX],AX
L1db40d74:
   mov word ptr [BP-4A],0001
jmp near L1db41016
L1db40d7c:
   mov word ptr [7E68],0000
   mov word ptr [7E66],0064
   mov AX,0001
   push AX
   call far A1a401eb1
   pop CX
jmp near L1db41016
L1db40d95:
   cmp word ptr [7E44],+00
   jnz L1db40da7
   xor AX,AX
   push AX
   call far A1eb71a0d
   pop CX
jmp near L1db40db2
L1db40da7:
   mov word ptr [7E44],0000
   call far A1eb71ab3
L1db40db2:
   mov word ptr [7E68],0000
   mov word ptr [7E66],0000
   mov word ptr [7E40],0000
   call far A1a4005e0
jmp near L1db41016
L1db40dcc:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   mov [BP-44],AX
   mov [BP-48],DI
jmp near L1db40e18
L1db40dec:
   mov AX,[BP-46]
   or AX,C000
   mov BX,[BP-48]
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   call far A1a401486
   pop CX
   pop CX
   dec word ptr [BP-48]
L1db40e18:
   mov BX,[BP-48]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-44]
   jz L1db40dec
   mov AX,DI
   inc AX
   mov [BP-48],AX
jmp near L1db40e6a
L1db40e3e:
   mov AX,[BP-46]
   or AX,C000
   mov BX,[BP-48]
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   call far A1a401486
   pop CX
   pop CX
   inc word ptr [BP-48]
L1db40e6a:
   mov BX,[BP-48]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,[BP-44]
   jz L1db40e3e
jmp near L1db41016
L1db40e8b:
   push SI
   push DI
   push CS
   call near offset A1db4025c
   pop CX
   pop CX
   mov [BP-4A],AX
jmp near L1db41016
L1db40e99:
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,1865
   push AX
   push CS
   call near offset A1db40002
   add SP,+08
   mov AL,[BP-20]
   cbw
   push AX
   call far A24d90000
   pop CX
   cmp AX,0059
   jz L1db40ebd
jmp near L1db41016
L1db40ebd:
   call far A1a401275
   call far A1eb70002
L1db40ec7:
   call far A1a401524
jmp near L1db41016
L1db40ecf:
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,186C
   push AX
   push CS
   call near offset A1db40002
   add SP,+08
   cmp byte ptr [BP-20],00
   jnz L1db40ee9
jmp near L1db41016
L1db40ee9:
   push SS
   lea AX,[BP-20]
   push AX
   call far A1a400afa
   pop CX
   pop CX
   call far A1eb72159
   mov AX,[9147]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
   mov AX,[9149]
   cwd
   idiv BX
   mov SI,AX
jmp near L1db40ec7
L1db40f0f:
   xor AX,AX
   push AX
   call far A0b8b02fd
   pop CX
   cmp word ptr [3712],+00
   jnz L1db40f26
   cmp word ptr [3714],+00
   jz L1db40f0f
L1db40f26:
   mov AX,[3714]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,[3712]
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   push [B28E]
   push [B28C]
   call far A09560e7f
   add SP,+08
jmp near L1db41016
L1db40f4d:
   push DS
   mov AX,B2D8
   push AX
   call far A0abf0bd2
   pop CX
   pop CX
   push DS
   mov AX,1872
   push AX
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push DS
   mov AX,B2D8
   push AX
   call far A0abf078b
   add SP,+0E
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-40]
   push AX
   push [BCAA]
   call far A23730085
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
   mov AX,B2D8
   push AX
   call far A0abf08bf
   add SP,+10
   push SS
   lea AX,[BP-40]
   push AX
   call far A2457000a
   pop CX
   pop CX
   mov [BCAA],AX
   push SS
   lea AX,[BP-40]
   push AX
   call far A24d6000b
   pop CX
   pop CX
jmp near L1db41016
L1db40fc6:
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,1879
   push AX
   push CS
   call near offset A1db40002
   add SP,+08
   mov AL,[BP-20]
   cbw
   push AX
   call far A24d90000
   pop CX
   cmp AX,0059
   jnz L1db41016
   call far A1a400910
   call far A1a401275
jmp near L1db41016
L1db40ff3:
   push SS
   lea AX,[BP-20]
   push AX
   push DS
   mov AX,1884
   push AX
   push CS
   call near offset A1db40002
   add SP,+08
   cmp byte ptr [BP-20],00
   jz L1db41016
   push SS
   lea AX,[BP-20]
   push AX
   call far A1a400cef
   pop CX
   pop CX
L1db41016:
   cmp word ptr [3722],+1B
   jz L1db41020
jmp near L1db409ed
L1db41020:
   mov word ptr [3722],0000
   mov word ptr [13A8],0000
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 1eb7 ;; JMAN.C:JMAN
A1eb70002:
   push BP
   mov BP,SP
   mov word ptr [B5F6],0001
   mov byte ptr [9146],00
   mov word ptr [9147],0020
   mov word ptr [9149],0020
   mov word ptr [914B],0000
   mov word ptr [914D],0000
   mov word ptr [9153],0000
   mov word ptr [9155],0000
   mov word ptr [9157],0000
   mov word ptr [9159],0000
   mov AX,[B150]
   mov [914F],AX
   mov AX,[B1DA]
   mov [9151],AX
   mov word ptr [9161],0000
   mov word ptr [9163],0000
   mov word ptr [915F],0000
   mov word ptr [915D],0000
   mov word ptr [7E44],0000
   mov word ptr [7E40],0001
   call far A1eb71ab3
   mov AL,00
   push AX
   mov AX,0016
   push AX
   push DS
   mov AX,7E70
   push AX
   call far A23920007
   add SP,+08
   pop BP
ret far

A1eb7008b:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   push [BX+B6A2]
   call far A1eb71fac
   add SP,+06
   push SI
   call far A1eb70127
   pop CX
   push SI
   call far A1eb7185d
   pop CX
   pop SI
   pop BP
ret far

A1eb700ec:
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   xor SI,SI
jmp near L1eb70119
L1eb700f7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   cmp AX,[BP+06]
   jnz L1eb70114
   mov AX,0001
jmp near L1eb70116
L1eb70114:
   xor AX,AX
L1eb70116:
   add DI,AX
   inc SI
L1eb70119:
   cmp SI,[B5F6]
   jl L1eb700f7
   mov AX,DI
jmp near L1eb70123
L1eb70123:
   pop DI
   pop SI
   pop BP
ret far

A1eb70127:
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
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
jmp near L1eb701f8
L1eb701d2:
   mov DI,[BP-0A]
jmp near L1eb701f0
L1eb701d7:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-02]
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
   inc DI
L1eb701f0:
   cmp DI,[BP-08]
   jl L1eb701d7
   inc word ptr [BP-02]
L1eb701f8:
   mov AX,[BP-02]
   cmp AX,[BP-04]
   jl L1eb701d2
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb70206:
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
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+B150]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   mov AX,[BX+B1DA]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1eb702ac
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far A2388000b
   pop CX
   pop CX
   mov DI,AX
L1eb702ac:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],14
   jnz L1eb702e0
   mov AX,DI
   mov DX,0006
   mul DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
jmp near L1eb70371
L1eb702e0:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],15
   jnz L1eb70314
   mov AX,DI
   shl AX,1
   shl AX,1
   shl AX,1
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
jmp near L1eb70371
L1eb70314:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],1B
   jnz L1eb70371
   mov AX,000A
   push AX
   push SS
   lea AX,[BP-08]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+0D]
   call far A23730085
   add SP,+08
   push DX
   push AX
   call far A2388000b
   pop CX
   pop CX
   inc AX
   inc AX
   mul word ptr [B186]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
L1eb70371:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb70377:
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L1eb703b1
L1eb7037f:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],0C
   jnz L1eb703b0
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[BP+06]
   jnz L1eb703b0
   mov AX,SI
jmp near L1eb703bb
L1eb703b0:
   inc SI
L1eb703b1:
   cmp SI,[B5F6]
   jl L1eb7037f
   xor AX,AX
jmp near L1eb703bb
L1eb703bb:
   pop SI
   pop BP
ret far

A1eb703be:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   push [7E40]
   push CS
   call near offset A1eb70377
   pop CX
   mov SI,AX
   or SI,SI
   jg L1eb703d8
jmp near L1eb70462
L1eb703d8:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1eb70462
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   les BX,[ES:BX+17]
   cmp byte ptr [ES:BX],2A
   jz L1eb7043c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   les BX,[ES:BX+17]
   cmp byte ptr [ES:BX],23
   jz L1eb7043c
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   les BX,[ES:BX+17]
   cmp byte ptr [ES:BX],26
   jnz L1eb70462
L1eb7043c:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push DS
   mov AX,B5F8
   push AX
   call far A238d0008
   add SP,+08
jmp near L1eb704bb
L1eb70462:
   xor AX,AX
   push AX
   push CS
   call near offset A1eb70377
   pop CX
   mov [BP-02],AX
   mov AX,[BP-02]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   les BX,[ES:BX+17]
   mov AL,[ES:BX]
   cbw
   mov DI,AX
   cmp DI,+2A
   jz L1eb70496
   cmp DI,+23
   jz L1eb70496
   cmp DI,+26
   jnz L1eb704bb
L1eb70496:
   mov AX,[BP-02]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   push DS
   mov AX,B5F8
   push AX
   call far A238d0008
   add SP,+08
L1eb704bb:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb704c1:
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   or word ptr [BC12],C000
   push [7E40]
   push CS
   call near offset A1eb70377
   pop CX
   mov SI,AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov [BP-0C],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-0A],AX
   cmp byte ptr [9146],17
   jz L1eb70511
   sub word ptr [BP-0A],+10
L1eb70511:
   or SI,SI
   jle L1eb70574
   cmp word ptr [BP+06],+00
   jz L1eb70574
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+0D],+01
   jnz L1eb70574
   mov DX,[7E6E]
   mov AX,[7E6C]
   mov [BP-02],DX
   mov [BP-04],AX
   mov AX,[7E40]
   mov [BP-06],AX
   push DS
   mov AX,B5D6
   push AX
   call far A1a400afa
   pop CX
   pop CX
   mov AX,[BP-06]
   mov [7E40],AX
   mov DX,[BP-02]
   mov AX,[BP-04]
   mov [7E68],DX
   mov [7E66],AX
   mov word ptr [7E42],0006
   push [7E40]
   push CS
   call near offset A1eb70377
   pop CX
   mov SI,AX
L1eb70574:
   mov DX,[7E68]
   mov AX,[7E66]
   mov [7E6E],DX
   mov [7E6C],AX
   push CS
   call near offset A1eb703be
   and word ptr [BP-0C],FFF8
   mov AX,[BP-0C]
   mov [9147],AX
   mov AX,[BP-0A]
   mov [9149],AX
   call far A1eb72159
   xor DI,DI
jmp near L1eb705c9
L1eb705a0:
   mov word ptr [BP-08],0000
jmp near L1eb705c2
L1eb705a7:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-08]
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
   inc word ptr [BP-08]
L1eb705c2:
   cmp word ptr [BP-08],+40
   jl L1eb705a7
   inc DI
L1eb705c9:
   cmp DI,0080
   jl L1eb705a0
   mov word ptr [9153],0004
   mov word ptr [9157],0000
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb705e1:
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   cmp byte ptr [9146],17
   jnz L1eb705f6
jmp near L1eb706aa
L1eb705f6:
   cmp byte ptr [9146],00
   jnz L1eb7060e
   mov BX,[9153]
   shl BX,1
   test word ptr [BX+BC06],0002
   jz L1eb7060e
jmp near L1eb706aa
L1eb7060e:
   mov AX,000A
   push AX
   call far A1eb71a83
   pop CX
   sub SI,AX
   or SI,SI
   jg L1eb70621
jmp near L1eb706aa
L1eb70621:
   or word ptr [BC12],C000
   sub [7E42],SI
   mov word ptr [7E6A],0001
   cmp word ptr [7E42],+00
   jle L1eb70649
   mov AX,0013
   push AX
   mov AX,0004
   push AX
   call far A0ce301e0
   pop CX
   pop CX
jmp near L1eb706aa
L1eb70649:
   mov word ptr [7E42],0000
   mov byte ptr [9146],00
   mov word ptr [914F],0010
   mov word ptr [9151],0020
   mov word ptr [9153],0005
   mov word ptr [9157],0000
   mov [9155],DI
   cmp DI,+01
   jnz L1eb7067f
   mov AX,[9149]
   dec AX
   and AX,FFF0
   mov [9149],AX
L1eb7067f:
   mov word ptr [914D],FFF4
   mov AX,DI
   add AX,0027
   push AX
   mov AX,0004
   push AX
   call far A0ce301e0
   pop CX
   pop CX
   mov AX,000A
   push AX
   push [9149]
   push [9147]
   call far A11be0a58
   add SP,+06
L1eb706aa:
   pop DI
   pop SI
   pop BP
ret far

A1eb706ae:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,[9147]
   jge L1eb706d3
   mov AX,0001
jmp near L1eb706d5
L1eb706d3:
   xor AX,AX
L1eb706d5:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,[9147]
   jle L1eb706f4
   mov AX,0001
jmp near L1eb706f6
L1eb706f4:
   xor AX,AX
L1eb706f6:
   pop DX
   sub DX,AX
   les BX,[BP+08]
   mov [ES:BX],DX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[9149]
   jge L1eb7071d
   mov AX,0001
jmp near L1eb7071f
L1eb7071d:
   xor AX,AX
L1eb7071f:
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[9149]
   jle L1eb7073e
   mov AX,0001
jmp near L1eb70740
L1eb7073e:
   xor AX,AX
L1eb70740:
   pop DX
   sub DX,AX
   les BX,[BP+0C]
   mov [ES:BX],DX
   pop SI
   pop BP
ret far

A1eb7074c:
   push BP
   mov BP,SP
   sub SP,+0C
   push SI
   push DI
   cmp word ptr [BP+06],+00
   jg L1eb7075d
jmp near L1eb7082c
L1eb7075d:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   les BX,[B28C]
   add AX,[ES:BX+04]
   sub AX,[BP+06]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-02],AX
   les BX,[B28C]
   mov AX,[ES:BX+08]
   les BX,[B28C]
   add AX,[ES:BX+04]
   dec AX
   mov BX,0010
   cwd
   idiv BX
   cmp AX,007F
   jge L1eb707ae
   les BX,[B28C]
   mov AX,[ES:BX+08]
   les BX,[B28C]
   add AX,[ES:BX+04]
   dec AX
   mov BX,0010
   cwd
   idiv BX
jmp near L1eb707b1
L1eb707ae:
   mov AX,007F
L1eb707b1:
   mov [BP-04],AX
   mov DI,[BP-02]
jmp near L1eb70825
L1eb707b9:
   mov word ptr [BP-0C],0000
jmp near L1eb7081b
L1eb707c0:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   add AX,[BP-0C]
   cmp AX,003F
   jge L1eb707eb
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
   add SI,[BP-0C]
jmp near L1eb707ee
L1eb707eb:
   mov SI,003F
L1eb707ee:
   mov AX,[BP+0A]
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   or [ES:BX],AX
   cmp word ptr [BP+0A],4000
   jnz L1eb70818
   push SI
   push DI
   call far A1a401486
   pop CX
   pop CX
L1eb70818:
   inc word ptr [BP-0C]
L1eb7081b:
   mov AX,[B434]
   inc AX
   cmp AX,[BP-0C]
   jg L1eb707c0
   inc DI
L1eb70825:
   cmp DI,[BP-04]
   jle L1eb707b9
jmp near L1eb70896
L1eb7082c:
   cmp word ptr [BP+06],+00
   jge L1eb70896
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   mov [BP-0A],AX
   mov word ptr [BP-0C],0000
jmp near L1eb7088d
L1eb7084a:
   les BX,[B28C]
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
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   or [ES:BX],AX
   cmp word ptr [BP+0A],4000
   jnz L1eb7088a
   push SI
   push [BP-0A]
   call far A1a401486
   pop CX
   pop CX
L1eb7088a:
   inc word ptr [BP-0C]
L1eb7088d:
   mov AX,[B434]
   inc AX
   cmp AX,[BP-0C]
   jg L1eb7084a
L1eb70896:
   cmp word ptr [BP+08],+00
   jg L1eb7089f
jmp near L1eb70953
L1eb7089f:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   les BX,[B28C]
   add AX,[ES:BX+06]
   mov [BP-08],AX
   mov AX,[BP-08]
   dec AX
   mov BX,0010
   cwd
   idiv BX
   cmp AX,003F
   jge L1eb708cd
   mov AX,[BP-08]
   dec AX
   mov BX,0010
   cwd
   idiv BX
jmp near L1eb708d0
L1eb708cd:
   mov AX,003F
L1eb708d0:
   mov [BP-06],AX
   mov AX,[BP-08]
   sub AX,[BP+08]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
jmp near L1eb7094b
L1eb708e3:
   xor DI,DI
jmp near L1eb70942
L1eb708e7:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
   cmp AX,007F
   jge L1eb7090e
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
jmp near L1eb70911
L1eb7090e:
   mov AX,007F
L1eb70911:
   mov [BP-0A],AX
   mov AX,[BP+0A]
   mov BX,[BP-0A]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   or [ES:BX],AX
   cmp word ptr [BP+0A],4000
   jnz L1eb70941
   push SI
   push [BP-0A]
   call far A1a401486
   pop CX
   pop CX
L1eb70941:
   inc DI
L1eb70942:
   mov AX,[B432]
   inc AX
   cmp AX,DI
   jg L1eb708e7
   inc SI
L1eb7094b:
   cmp SI,[BP-06]
   jle L1eb708e3
jmp near L1eb709ef
L1eb70953:
   cmp word ptr [BP+08],+00
   jl L1eb7095c
jmp near L1eb709ef
L1eb7095c:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov BX,0010
   cwd
   idiv BX
   mov SI,AX
jmp near L1eb709d6
L1eb7096e:
   xor DI,DI
jmp near L1eb709cd
L1eb70972:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
   cmp AX,007F
   jge L1eb70999
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov BX,0010
   cwd
   idiv BX
   add AX,DI
jmp near L1eb7099c
L1eb70999:
   mov AX,007F
L1eb7099c:
   mov [BP-0A],AX
   mov AX,[BP+0A]
   mov BX,[BP-0A]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,SI
   shl AX,1
   add BX,AX
   pop AX
   or [ES:BX],AX
   cmp word ptr [BP+0A],4000
   jnz L1eb709cc
   push SI
   push [BP-0A]
   call far A1a401486
   pop CX
   pop CX
L1eb709cc:
   inc DI
L1eb709cd:
   mov AX,[B432]
   inc AX
   cmp AX,DI
   jg L1eb70972
   inc SI
L1eb709d6:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   sub AX,[BP+08]
   dec AX
   mov BX,0010
   cwd
   idiv BX
   cmp AX,SI
   jl L1eb709ef
jmp near L1eb7096e
L1eb709ef:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb709f5:
   push BP
   mov BP,SP
   sub SP,+1C
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   mov AX,[3E3C]
   mov CL,04
   sar AX,CL
   mov [BP-10],AX
   mov AX,[3E3E]
   mov CL,04
   sar AX,CL
   mov [BP-0E],AX
   mov AX,[3E3C]
   add AX,[914F]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   mov AX,[3E3E]
   add AX,[9151]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,[9147]
   mov CL,04
   sar AX,CL
   mov [BP-0C],AX
   mov AX,[9149]
   mov CL,04
   sar AX,CL
   mov [BP-0A],AX
   mov AX,[9147]
   add AX,[914F]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov AX,[9149]
   add AX,[9151]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   or SI,SI
   jz L1eb70a76
jmp near L1eb70af0
L1eb70a76:
   mov word ptr [BP-18],0000
   mov AX,[BP-10]
   cmp AX,[BP-0C]
   jge L1eb70a88
   mov AX,[BP-10]
jmp near L1eb70a8b
L1eb70a88:
   mov AX,[BP-0C]
L1eb70a8b:
   mov CL,04
   shl AX,CL
   les BX,[B28C]
   sub AX,[ES:BX+08]
   mov [BP-16],AX
   mov AX,[BP-08]
   cmp AX,[BP-04]
   jle L1eb70aa7
   mov AX,[BP-08]
jmp near L1eb70aaa
L1eb70aa7:
   mov AX,[BP-04]
L1eb70aaa:
   mov CL,04
   shl AX,CL
   les BX,[B28C]
   sub AX,[ES:BX+08]
   mov [BP-14],AX
   les BX,[B28C]
   mov AX,[ES:BX+04]
   mov [BP-12],AX
   mov AX,DI
   neg AX
   push AX
   xor AX,AX
   push AX
   les BX,[B28C]
   push [ES:BX+06]
   push [BP-16]
   xor AX,AX
   push AX
   push [BP-18]
   push [B28E]
   push [B28C]
   call far A095609f9
   add SP,+10
jmp near L1eb70b6e
L1eb70af0:
   or DI,DI
   jz L1eb70af7
jmp near L1eb70b6e
L1eb70af7:
   mov word ptr [BP-18],0000
   mov AX,[BP-0E]
   cmp AX,[BP-0A]
   jge L1eb70b09
   mov AX,[BP-0E]
jmp near L1eb70b0c
L1eb70b09:
   mov AX,[BP-0A]
L1eb70b0c:
   mov CL,04
   shl AX,CL
   les BX,[B28C]
   sub AX,[ES:BX+0A]
   mov [BP-16],AX
   mov AX,[BP-06]
   cmp AX,[BP-02]
   jle L1eb70b28
   mov AX,[BP-06]
jmp near L1eb70b2b
L1eb70b28:
   mov AX,[BP-02]
L1eb70b2b:
   mov CL,04
   shl AX,CL
   les BX,[B28C]
   sub AX,[ES:BX+0A]
   mov [BP-14],AX
   les BX,[B28C]
   mov AX,[ES:BX+06]
   mov [BP-12],AX
   xor AX,AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [BP-16]
   les BX,[B28C]
   push [ES:BX+04]
   push [BP-18]
   xor AX,AX
   push AX
   push [B28E]
   push [B28C]
   call far A095609f9
   add SP,+10
L1eb70b6e:
   mov AX,[BP-10]
   mov [BP-1C],AX
jmp near L1eb70bb2
L1eb70b76:
   mov AX,[BP-0E]
   mov [BP-1A],AX
jmp near L1eb70ba7
L1eb70b7e:
   push [BP-1A]
   push [BP-1C]
   call far A1a401486
   pop CX
   pop CX
   mov BX,[BP-1C]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-1A]
   shl AX,1
   add BX,AX
   and word ptr [ES:BX],7FFF
   inc word ptr [BP-1A]
L1eb70ba7:
   mov AX,[BP-1A]
   cmp AX,[BP-06]
   jl L1eb70b7e
   inc word ptr [BP-1C]
L1eb70bb2:
   mov AX,[BP-1C]
   cmp AX,[BP-08]
   jl L1eb70b76
   or SI,SI
   jnz L1eb70c35
   mov AX,DI
   neg AX
   push AX
   xor AX,AX
   push AX
   les BX,[B28C]
   push [ES:BX+06]
   push [BP-14]
   xor AX,AX
   push AX
   push [BP-16]
   push [B28E]
   push [B28C]
   call far A095609f9
   add SP,+10
   les BX,[B28C]
   add [ES:BX+0A],DI
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[9146]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+B2E8]
   add SP,+06
   mov AX,DI
   neg AX
   push AX
   xor AX,AX
   push AX
   les BX,[B28C]
   push [ES:BX+06]
   push [BP-12]
   xor AX,AX
   push AX
   push [BP-14]
   push [B28E]
   push [B28C]
   call far A095609f9
   add SP,+10
jmp near L1eb70cf3
L1eb70c35:
   or DI,DI
   jnz L1eb70caf
   xor AX,AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [BP-14]
   les BX,[B28C]
   push [ES:BX+04]
   push [BP-16]
   xor AX,AX
   push AX
   push [B28E]
   push [B28C]
   call far A095609f9
   add SP,+10
   les BX,[B28C]
   add [ES:BX+08],SI
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[9146]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+B2E8]
   add SP,+06
   xor AX,AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [BP-12]
   les BX,[B28C]
   push [ES:BX+04]
   push [BP-14]
   xor AX,AX
   push AX
   push [B28E]
   push [B28C]
   call far A095609f9
   add SP,+10
jmp near L1eb70cf3
L1eb70caf:
   mov AX,DI
   neg AX
   push AX
   mov AX,SI
   neg AX
   push AX
   push [B28E]
   push [B28C]
   call far A09560e7f
   add SP,+08
   les BX,[B28C]
   add [ES:BX+08],SI
   les BX,[B28C]
   add [ES:BX+0A],DI
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   mov AL,[9146]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+B2E8]
   add SP,+06
L1eb70cf3:
   mov AX,4000
   push AX
   push DI
   push SI
   push CS
   call near offset A1eb7074c
   add SP,+06
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb70d06:
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
   push [B28E]
   push [B28C]
   call far A09560e7f
   add SP,+08
   les BX,[B28C]
   add [ES:BX+08],SI
   les BX,[B28C]
   add [ES:BX+0A],DI
   mov AX,C000
   push AX
   push DI
   push SI
   push CS
   call near offset A1eb7074c
   add SP,+06
   pop DI
   pop SI
   pop BP
ret far

A1eb70d4c:
   push BP
   mov BP,SP
   sub SP,0A0C
   push SI
   push DI
   cmp word ptr [BP+06],+00
   jnz L1eb70d5e
jmp near L1eb70f62
L1eb70d5e:
   cmp word ptr [BC12],+00
   jz L1eb70d76
   call far A1a4005e0
   mov AX,[34EC]
   inc AX
   mov CL,0E
   shl AX,CL
   and [BC12],AX
L1eb70d76:
   mov AX,[B54A]
   add AX,[BCA0]
   jnz L1eb70d88
   mov AX,[B54C]
   add AX,[BCA2]
   jz L1eb70db4
L1eb70d88:
   mov AX,[BCA0]
   les BX,[B28C]
   sub [ES:BX+08],AX
   mov AX,[BCA2]
   les BX,[B28C]
   sub [ES:BX+0A],AX
   mov AX,[B54C]
   add AX,[BCA2]
   push AX
   mov AX,[B54A]
   add AX,[BCA0]
   push AX
   push CS
   call near offset A1eb70d06
   pop CX
   pop CX
L1eb70db4:
   mov AX,[B54A]
   mov [BCA0],AX
   mov AX,[B54C]
   mov [BCA2],AX
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,[B432]
   cmp AX,007F
   jge L1eb70de7
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,[B432]
jmp near L1eb70dea
L1eb70de7:
   mov AX,007F
L1eb70dea:
   mov [BP+F5F8],AX
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[B434]
   dec AX
   cmp AX,003F
   jge L1eb70e17
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[B434]
   dec AX
jmp near L1eb70e1a
L1eb70e17:
   mov AX,003F
L1eb70e1a:
   mov [BP+F5FA],AX
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1eb70e33
   xor AX,AX
jmp near L1eb70e42
L1eb70e33:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1eb70e42:
   mov [BP+F5FC],AX
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1eb70e5b
   xor AX,AX
jmp near L1eb70e6a
L1eb70e5b:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1eb70e6a:
   mov [BP+F5FE],AX
   mov SI,[BP+F5F8]
jmp near L1eb70ed8
L1eb70e74:
   mov AX,[BP+F5FA]
   mov [BP+F5F4],AX
jmp near L1eb70ecd
L1eb70e7e:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+F5F4]
   shl AX,1
   add BX,AX
   test word ptr [ES:BX],C000
   jz L1eb70ec9
   push [BP+F5F4]
   push SI
   call far A1a401486
   pop CX
   pop CX
   mov AX,[34EC]
   inc AX
   mov CL,0E
   shl AX,CL
   xor AX,FFFF
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,[BP+F5F4]
   shl AX,1
   add BX,AX
   pop AX
   and [ES:BX],AX
L1eb70ec9:
   dec word ptr [BP+F5F4]
L1eb70ecd:
   mov AX,[BP+F5F4]
   cmp AX,[BP+F5FE]
   jge L1eb70e7e
   dec SI
L1eb70ed8:
   cmp SI,[BP+F5FC]
   jge L1eb70e74
   mov AX,[B5F6]
   dec AX
   mov [BP+F5F6],AX
jmp near L1eb70f53
L1eb70ee8:
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+15],C000
   jz L1eb70f4f
   xor AX,AX
   push AX
   xor AX,AX
   push AX
   push [BP+F5F6]
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+B2E8]
   add SP,+06
   mov AX,[34EC]
   inc AX
   mov CL,0E
   shl AX,CL
   xor AX,FFFF
   push AX
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   and [ES:BX+15],AX
L1eb70f4f:
   dec word ptr [BP+F5F6]
L1eb70f53:
   cmp word ptr [BP+F5F6],+00
   jge L1eb70ee8
   call far A08760751
jmp near L1eb711b8
L1eb70f62:
   cmp word ptr [BC12],+00
   jz L1eb70f74
   call far A1a4005e0
   mov word ptr [BC12],0000
L1eb70f74:
   xor DI,DI
jmp near L1eb70f8e
L1eb70f78:
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
L1eb70f8e:
   cmp DI,0080
   jl L1eb70f78
   cmp word ptr [B54A],+00
   jnz L1eb70fa2
   cmp word ptr [B54C],+00
   jz L1eb70fb0
L1eb70fa2:
   push [B54C]
   push [B54A]
   push CS
   call near offset A1eb709f5
   pop CX
   pop CX
L1eb70fb0:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,[B432]
   dec AX
   mov [BP+F5F8],AX
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,[B434]
   dec AX
   mov [BP+F5FA],AX
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1eb70fef
   xor AX,AX
jmp near L1eb70ffe
L1eb70fef:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1eb70ffe:
   mov [BP+F5FC],AX
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
   jge L1eb71017
   xor AX,AX
jmp near L1eb71026
L1eb71017:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   add AX,FFFE
L1eb71026:
   mov [BP+F5FE],AX
   mov word ptr [BP+F5F6],0000
jmp near L1eb710db
L1eb71033:
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+15],C000
   jnz L1eb7104f
jmp near L1eb710d7
L1eb7104f:
   mov AX,[BP+F5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov SI,[ES:BX+01]
   mov CL,04
   sar SI,CL
   cmp SI,[BP+F5FC]
   jge L1eb71072
   mov SI,[BP+F5FC]
L1eb71072:
   xor DI,DI
jmp near L1eb71077
L1eb71076:
   inc DI
L1eb71077:
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   lea AX,[BP+F600]
   add BX,AX
   push SS
   pop ES
   cmp byte ptr [ES:BX+DI],FF
   jnz L1eb71076
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
   add BX,9146
   push DS
   pop ES
   and word ptr [ES:BX+15],3FFF
L1eb710d7:
   inc word ptr [BP+F5F6]
L1eb710db:
   mov AX,[BP+F5F6]
   cmp AX,[B5F6]
   jge L1eb710e8
jmp near L1eb71033
L1eb710e8:
   mov SI,[BP+F5F8]
jmp near L1eb711af
L1eb710ef:
   mov AX,[BP+F5FA]
   mov [BP+F5F4],AX
jmp near L1eb7113d
L1eb710f9:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+F5F4]
   shl AX,1
   add BX,AX
   test word ptr [ES:BX],8000
   jz L1eb71139
   push [BP+F5F4]
   push SI
   call far A1a401486
   pop CX
   pop CX
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP+F5F4]
   shl AX,1
   add BX,AX
   and word ptr [ES:BX],3FFF
L1eb71139:
   dec word ptr [BP+F5F4]
L1eb7113d:
   mov AX,[BP+F5F4]
   cmp AX,[BP+F5FE]
   jge L1eb710f9
   xor DI,DI
jmp near L1eb71192
L1eb7114b:
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
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+B2E8]
   add SP,+06
   inc DI
L1eb71192:
   mov AX,SI
   mov DX,0014
   mul DX
   mov BX,AX
   lea AX,[BP+F600]
   add BX,AX
   push SS
   pop ES
   cmp byte ptr [ES:BX+DI],FF
   jz L1eb711ae
   cmp DI,+14
   jl L1eb7114b
L1eb711ae:
   dec SI
L1eb711af:
   cmp SI,[BP+F5FC]
   jl L1eb711b8
jmp near L1eb710ef
L1eb711b8:
   cmp word ptr [7E6A],+00
   jz L1eb711cb
   mov word ptr [7E6A],0000
   or word ptr [BC12],C000
L1eb711cb:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb711d1:
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov CL,04
   sar AX,CL
   mov [BP-08],AX
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov CL,04
   sar AX,CL
   mov [BP-06],AX
   mov AX,[BP-08]
   add AX,[B432]
   cmp AX,007F
   jge L1eb7120c
   mov AX,[BP-08]
   add AX,[B432]
jmp near L1eb7120f
L1eb7120c:
   mov AX,007F
L1eb7120f:
   mov [BP-04],AX
   mov AX,[BP-06]
   add AX,[B434]
   cmp AX,003F
   jge L1eb71227
   mov AX,[BP-06]
   add AX,[B434]
jmp near L1eb7122a
L1eb71227:
   mov AX,003F
L1eb7122a:
   mov [BP-02],AX
   mov SI,[BP-08]
jmp near L1eb712a5
L1eb71232:
   mov DI,[BP-06]
jmp near L1eb7129f
L1eb71237:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,7E86
   push DS
   pop ES
   test word ptr [ES:BX+02],0020
   jz L1eb7129e
   mov AX,0002
   push AX
   push DI
   push SI
   call far A16b00006
   add SP,+06
   or AX,AX
   jz L1eb71280
   mov AX,0001
jmp near L1eb71282
L1eb71280:
   xor AX,AX
L1eb71282:
   mov DX,C000
   mul DX
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push AX
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   pop AX
   or [ES:BX],AX
L1eb7129e:
   inc DI
L1eb7129f:
   cmp DI,[BP-02]
   jle L1eb71237
   inc SI
L1eb712a5:
   cmp SI,[BP-04]
   jg L1eb712ad
jmp near L1eb71232
L1eb712ad:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb712b3:
   push BP
   mov BP,SP
   sub SP,+1A
   push SI
   push DI
   mov word ptr [BCA6],0001
   mov word ptr [B786],0000
   les BX,[B28C]
   mov AX,[ES:BX+08]
   add AX,FFA0
   mov [BP-08],AX
   les BX,[B28C]
   mov AX,[ES:BX+08]
   les BX,[B28C]
   add AX,[ES:BX+04]
   add AX,0060
   mov [BP-06],AX
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   add AX,FFD0
   mov [BP-04],AX
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   les BX,[B28C]
   add AX,[ES:BX+06]
   add AX,0030
   mov [BP-02],AX
   mov SI,0001
jmp near L1eb713d0
L1eb71315:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   cmp AX,[BP-08]
   jge L1eb71345
jmp near L1eb713cf
L1eb71345:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   cmp AX,[BP-06]
   jg L1eb713cf
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   cmp AX,[BP-04]
   jl L1eb713cf
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP-02]
   jg L1eb713cf
   mov BX,[BCA6]
   shl BX,1
   mov [BX+B786],SI
   inc word ptr [BCA6]
   mov AX,[34EC]
   mov CL,0E
   shl AX,CL
   xor AX,FFFF
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   and [ES:BX+15],AX
L1eb713cf:
   inc SI
L1eb713d0:
   cmp SI,[B5F6]
   jge L1eb713e1
   cmp word ptr [BCA6],00C0
   jge L1eb713e1
jmp near L1eb71315
L1eb713e1:
   mov word ptr [B54A],0000
   mov word ptr [B54C],0000
   mov AX,[9147]
   mov [3E3C],AX
   mov AX,[9149]
   mov [3E3E],AX
   mov word ptr [BP-1A],0000
jmp near L1eb7173a
L1eb71401:
   mov BX,[BP-1A]
   shl BX,1
   mov SI,[BX+B786]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov [BP-14],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   mov [BP-12],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+09]
   mov [BP-10],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   mov [BP-0E],AX
   cmp word ptr [BP+06],+00
   jz L1eb714d4
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jle L1eb71491
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   dec word ptr [ES:BX+1D]
L1eb71491:
   xor AX,AX
   push AX
   mov AX,0002
   push AX
   push SI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+B2E8]
   add SP,+06
   or AX,AX
   jz L1eb714d2
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1eb714d2:
jmp near L1eb714e9
L1eb714d4:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1eb714e9:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],0008
   jnz L1eb7150b
jmp near L1eb716ad
L1eb7150b:
   mov word ptr [BP-18],0000
jmp near L1eb716a1
L1eb71513:
   mov BX,[BP-18]
   shl BX,1
   mov DI,[BX+B786]
   cmp DI,SI
   jnz L1eb71523
jmp near L1eb7169e
L1eb71523:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+01]
   jg L1eb71565
jmp near L1eb7169e
L1eb71565:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+01]
   jg L1eb715a7
jmp near L1eb7169e
L1eb715a7:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+03]
   jg L1eb715e9
jmp near L1eb7169e
L1eb715e9:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+03]
   jle L1eb7169e
   push DI
   mov AX,0001
   push AX
   push SI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+B2E8]
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+B2E8]
   add SP,+06
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1eb7169e:
   inc word ptr [BP-18]
L1eb716a1:
   mov AX,[BP-18]
   cmp AX,[BCA6]
   jg L1eb716ad
jmp near L1eb71513
L1eb716ad:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   test word ptr [ES:BX+15],C000
   jz L1eb71737
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
jmp near L1eb7172f
L1eb71700:
   mov AX,[BP-08]
   mov [BP-0C],AX
jmp near L1eb71724
L1eb71708:
   mov BX,[BP-0C]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-0A]
   shl AX,1
   add BX,AX
   or word ptr [ES:BX],C000
   inc word ptr [BP-0C]
L1eb71724:
   mov AX,[BP-0C]
   cmp AX,[BP-06]
   jl L1eb71708
   inc word ptr [BP-0A]
L1eb7172f:
   mov AX,[BP-0A]
   cmp AX,[BP-02]
   jl L1eb71700
L1eb71737:
   inc word ptr [BP-1A]
L1eb7173a:
   mov AX,[BP-1A]
   cmp AX,[BCA6]
   jge L1eb71746
jmp near L1eb71401
L1eb71746:
   mov word ptr [BP-1A],0000
jmp near L1eb7184b
L1eb7174e:
   mov BX,[BP-1A]
   shl BX,1
   mov SI,[BX+B786]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   mov [BP-0C],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,9146
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
jmp near L1eb71825
L1eb717e4:
   mov AX,[BP-08]
   mov [BP-0C],AX
jmp near L1eb7181a
L1eb717ec:
   cmp word ptr [BP-16],+00
   jnz L1eb7180d
   mov BX,[BP-0C]
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,[BP-0A]
   shl AX,1
   add BX,AX
   test word ptr [ES:BX],C000
   jz L1eb71812
L1eb7180d:
   mov AX,0001
jmp near L1eb71814
L1eb71812:
   xor AX,AX
L1eb71814:
   mov [BP-16],AX
   inc word ptr [BP-0C]
L1eb7181a:
   mov AX,[BP-0C]
   cmp AX,[BP-06]
   jl L1eb717ec
   inc word ptr [BP-0A]
L1eb71825:
   mov AX,[BP-0A]
   cmp AX,[BP-02]
   jl L1eb717e4
   cmp word ptr [BP-16],+00
   jz L1eb71848
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
L1eb71848:
   inc word ptr [BP-1A]
L1eb7184b:
   mov AX,[BP-1A]
   cmp AX,[BCA6]
   jge L1eb71857
jmp near L1eb7174e
L1eb71857:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb7185d:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   or word ptr [ES:BX+15],C000
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov byte ptr [ES:BX],03
   pop BP
ret far

A1eb7188c:
   push BP
   mov BP,SP
   mov AL,[BP+06]
   push AX
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX],AL
   mov AX,[BP+08]
   push AX
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+01],AX
   mov AX,[BP+0A]
   push AX
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0D],0000
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0000
   mov BX,[BP+06]
   shl BX,1
   mov AX,[BX+B150]
   push AX
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+09],AX
   mov BX,[BP+06]
   shl BX,1
   mov AX,[BX+B1DA]
   push AX
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0B],AX
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+0F],0000
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+11],0000
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+15],0000
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+19],0000
   mov word ptr [ES:BX+17],0000
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1B],0000
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1D],0000
   mov AX,[B5F6]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0000
   cmp word ptr [B5F6],0100
   jge L1eb71a05
   inc word ptr [B5F6]
L1eb71a05:
   mov AX,[B5F6]
   dec AX
jmp near L1eb71a0b
L1eb71a0b:
   pop BP
ret far

A1eb71a0d:
   push BP
   mov BP,SP
   cmp word ptr [7E44],+0F
   jl L1eb71a19
jmp near L1eb71a30
L1eb71a19:
   or word ptr [BC12],C000
   mov AX,[BP+06]
   mov BX,[7E44]
   shl BX,1
   mov [BX+7E46],AX
   inc word ptr [7E44]
L1eb71a30:
   pop BP
ret far

A1eb71a32:
   push BP
   mov BP,SP
   push SI
   push DI
   xor SI,SI
jmp near L1eb71a75
L1eb71a3b:
   mov BX,SI
   shl BX,1
   mov AX,[BX+7E46]
   cmp AX,[BP+06]
   jnz L1eb71a74
   mov DI,SI
   inc DI
jmp near L1eb71a5f
L1eb71a4d:
   mov BX,DI
   shl BX,1
   mov AX,[BX+7E46]
   mov BX,DI
   dec BX
   shl BX,1
   mov [BX+7E46],AX
   inc DI
L1eb71a5f:
   cmp DI,[7E44]
   jl L1eb71a4d
   dec word ptr [7E44]
   or word ptr [BC12],C000
   mov AX,0001
jmp near L1eb71a7f
L1eb71a74:
   inc SI
L1eb71a75:
   cmp SI,[7E44]
   jl L1eb71a3b
   xor AX,AX
jmp near L1eb71a7f
L1eb71a7f:
   pop DI
   pop SI
   pop BP
ret far

A1eb71a83:
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   xor SI,SI
jmp near L1eb71aa5
L1eb71a8e:
   mov BX,SI
   shl BX,1
   mov AX,[BX+7E46]
   cmp AX,[BP+06]
   jnz L1eb71aa0
   mov AX,0001
jmp near L1eb71aa2
L1eb71aa0:
   xor AX,AX
L1eb71aa2:
   add DI,AX
   inc SI
L1eb71aa5:
   cmp SI,[7E44]
   jl L1eb71a8e
   mov AX,DI
jmp near L1eb71aaf
L1eb71aaf:
   pop DI
   pop SI
   pop BP
ret far

A1eb71ab3:
   push BP
   mov BP,SP
   mov word ptr [7E42],0006
jmp near L1eb71ac0
L1eb71abe:
jmp near L1eb71ac0
L1eb71ac0:
   xor AX,AX
   push AX
   push CS
   call near offset A1eb71a32
   pop CX
   or AX,AX
   jnz L1eb71abe
   pop BP
ret far

A1eb71ace:
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+08]
   mov SI,[BP+06]
   cmp word ptr [BP+0A],+00
   jge L1eb71ae6
   mov word ptr [BP+0A],0000
jmp near L1eb71b1e
L1eb71ae6:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,03F0
   mov DX,[ES:BX+0B]
   sub AX,DX
   cmp AX,[BP+0A]
   jge L1eb71b1e
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,03F0
   mov DX,[ES:BX+0B]
   sub AX,DX
   mov [BP+0A],AX
L1eb71b1e:
   or DI,DI
   jge L1eb71b26
   xor DI,DI
jmp near L1eb71b5a
L1eb71b26:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,07F0
   mov DX,[ES:BX+09]
   sub AX,DX
   cmp AX,DI
   jge L1eb71b5a
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,07F0
   mov AX,[ES:BX+09]
   sub DI,AX
L1eb71b5a:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov [ES:BX+01],DI
   mov AX,[BP+0A]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+03],AX
   pop DI
   pop SI
   pop BP
ret far

A1eb71b89:
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   add AX,[BP+08]
   mov [BP-0A],AX
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov SI,[ES:BX+03]
   add SI,[BP+0A]
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   add AX,SI
   test AX,000F
   jz L1eb71be2
   xor AX,AX
jmp near L1eb71c7d
L1eb71be2:
   mov AX,DI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
jmp near L1eb71c70
L1eb71c33:
   mov BX,[BP-02]
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,7E86
   push DS
   pop ES
   mov AX,[ES:BX+02]
   and AX,0003
   mov [BP-08],AX
   cmp word ptr [BP-08],+03
   jnz L1eb71c6d
   xor AX,AX
jmp near L1eb71c7d
L1eb71c6d:
   inc word ptr [BP-02]
L1eb71c70:
   mov AX,[BP-02]
   cmp AX,[BP-04]
   jl L1eb71c33
   mov AX,0001
jmp near L1eb71c7d
L1eb71c7d:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb71c83:
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   cmp AX,[BP+0A]
   jge L1eb71caa
   or DI,0002
L1eb71caa:
   push DI
   push [BP+0A]
   push [BP+08]
   push SI
   call far A1eb72221
   add SP,+08
   cmp AX,DI
   jnz L1eb71cd5
   push [BP+0A]
   push [BP+08]
   push SI
   push CS
   call near offset A1eb71ace
   add SP,+06
   mov AX,0001
jmp near L1eb71d69
X1eb71cd2:
jmp near L1eb71d65
L1eb71cd5:
   push DI
   push [BP+0A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   cmp AX,DI
   jnz L1eb71d1e
   push [BP+0A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   push CS
   call near offset A1eb71ace
   add SP,+06
   mov AX,0002
jmp near L1eb71d69
X1eb71d1c:
jmp near L1eb71d65
L1eb71d1e:
   push DI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   push [BP+08]
   push SI
   call far A1eb72221
   add SP,+08
   cmp AX,DI
   jnz L1eb71d65
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+03]
   push [BP+08]
   push SI
   push CS
   call near offset A1eb71ace
   add SP,+06
   mov AX,0004
jmp near L1eb71d69
L1eb71d65:
   xor AX,AX
jmp near L1eb71d69
L1eb71d69:
   pop DI
   pop SI
   pop BP
ret far

A1eb71d6d:
   push BP
   mov BP,SP
   mov AX,0001
   push AX
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far A1eb72221
   mov SP,BP
   or AX,AX
   jz L1eb71d9c
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A1eb71ace
   mov SP,BP
   mov AX,0001
jmp near L1eb71da0
L1eb71d9c:
   xor AX,AX
jmp near L1eb71da0
L1eb71da0:
   pop BP
ret far

A1eb71da2:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+09]
   les BX,[B28C]
   cmp AX,[ES:BX+08]
   jge L1eb71dde
jmp near L1eb71e63
L1eb71dde:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   add AX,[ES:BX+0B]
   les BX,[B28C]
   cmp AX,[ES:BX+0A]
   jl L1eb71e63
   les BX,[B28C]
   mov AX,[ES:BX+08]
   les BX,[B28C]
   add AX,[ES:BX+04]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+01]
   jl L1eb71e63
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   les BX,[B28C]
   add AX,[ES:BX+06]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   cmp AX,[ES:BX+03]
   jl L1eb71e63
   mov AX,0001
jmp near L1eb71e67
L1eb71e63:
   xor AX,AX
jmp near L1eb71e67
L1eb71e67:
   pop SI
   pop BP
ret far

A1eb71e6a:
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
   call far A1eb72221
   add SP,+08
   cmp AX,DI
   jnz L1eb71eb6
   push [BP+0A]
   push [BP+08]
   push SI
   push CS
   call near offset A1eb71ace
   add SP,+06
   mov AX,[3712]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,0001
jmp near L1eb71f2b
X1eb71eb4:
jmp near L1eb71f12
L1eb71eb6:
   push DI
   push [BP+0A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   call far A1eb72221
   add SP,+08
   cmp AX,DI
   jnz L1eb71f12
   push [BP+0A]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+01]
   push SI
   push CS
   call near offset A1eb71ace
   add SP,+06
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   mov AX,0001
jmp near L1eb71f2b
L1eb71f12:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0000
   xor AX,AX
jmp near L1eb71f2b
L1eb71f2b:
   pop DI
   pop SI
   pop BP
ret far

A1eb71f2f:
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
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+01]
   add DI,[BP+08]
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   add AX,[BP+0A]
   mov [BP-02],AX
   push [BP+0A]
   push [BP+08]
   push SI
   push CS
   call near offset A1eb71b89
   add SP,+06
   or AX,AX
   jz L1eb71fa2
   mov AX,0001
   push AX
   push [BP-02]
   push DI
   push SI
   call far A1eb72221
   add SP,+08
   cmp AX,0001
   jnz L1eb71fa2
   push [BP-02]
   push DI
   push SI
   push CS
   call near offset A1eb71ace
   add SP,+06
   mov AX,0001
jmp near L1eb71fa6
L1eb71fa2:
   xor AX,AX
jmp near L1eb71fa6
L1eb71fa6:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb71fac:
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
   call near offset A1eb7188c
   add SP,+06
   mov SI,AX
   or SI,SI
   jnz L1eb71fcc
jmp near L1eb72049
L1eb71fcc:
   mov AX,[BP+06]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+0D],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0010
   cmp DI,[9147]
   jle L1eb72004
   mov AX,0001
jmp near L1eb72006
L1eb72004:
   xor AX,AX
L1eb72006:
   push AX
   cmp DI,[9147]
   jge L1eb72012
   mov AX,0001
jmp near L1eb72014
L1eb72012:
   xor AX,AX
L1eb72014:
   pop DX
   sub DX,AX
   shl DX,1
   mov AX,SI
   mov BX,001F
   push DX
   mul BX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   pop AX
   mov [ES:BX+05],AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],0003
   push SI
   push CS
   call near offset A1eb70206
   pop CX
L1eb72049:
   or word ptr [BC12],C000
   mov AX,[BP+06]
   cwd
   add [7E66],AX
   adc [7E68],DX
   pop DI
   pop SI
   pop BP
ret far

X1eb7205f:
   push BP
   mov BP,SP
   push SI
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push CS
   call near offset A1eb7188c
   add SP,+06
   mov SI,AX
   or SI,SI
   jz L1eb720e6
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+13],0040
   push [BP+08]
   push [BP+06]
   call far A24d20001
   pop CX
   pop CX
   push DX
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+05],0002
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+07],FFFF
   push SI
   push CS
   call near offset A1eb70206
   pop CX
L1eb720e6:
   pop SI
   pop BP
ret far

A1eb720e9:
   push BP
   mov BP,SP
   push SI
   xor SI,SI
jmp near L1eb72150
L1eb720f1:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   test word ptr [BX+BC16],0100
   jz L1eb7214f
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+13]
   cmp AX,[BP+06]
   jnz L1eb7214f
   push [BP+0A]
   push [BP+08]
   push SI
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   call far [BX+B2E8]
   add SP,+06
L1eb7214f:
   inc SI
L1eb72150:
   cmp SI,[B5F6]
   jl L1eb720f1
   pop SI
   pop BP
ret far

A1eb72159:
   push BP
   mov BP,SP
   mov AX,[B432]
   shl AX,1
   shl AX,1
   shl AX,1
   mov DX,[9147]
   sub DX,AX
   and DX,FFF8
   les BX,[B28C]
   mov [ES:BX+08],DX
   les BX,[B28C]
   cmp word ptr [ES:BX+08],+00
   jge L1eb7218e
   les BX,[B28C]
   mov word ptr [ES:BX+08],0000
jmp near L1eb721b8
L1eb7218e:
   les BX,[B28C]
   mov AX,[ES:BX+08]
   mov DX,0080
   sub DX,[B432]
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jle L1eb721b8
   mov AX,0080
   sub AX,[B432]
   mov CL,04
   shl AX,CL
   les BX,[B28C]
   mov [ES:BX+08],AX
L1eb721b8:
   mov AX,[B434]
   shl AX,1
   shl AX,1
   shl AX,1
   mov DX,[9149]
   add DX,+10
   sub DX,AX
   les BX,[B28C]
   mov [ES:BX+0A],DX
   les BX,[B28C]
   cmp word ptr [ES:BX+0A],+00
   jge L1eb721e9
   les BX,[B28C]
   mov word ptr [ES:BX+0A],0000
jmp near L1eb72213
L1eb721e9:
   les BX,[B28C]
   mov AX,[ES:BX+0A]
   mov DX,0041
   sub DX,[B434]
   mov CL,04
   shl DX,CL
   cmp AX,DX
   jle L1eb72213
   mov AX,0041
   sub AX,[B434]
   mov CL,04
   shl AX,CL
   les BX,[B28C]
   mov [ES:BX+0A],AX
L1eb72213:
   mov word ptr [BCA0],0000
   mov word ptr [BCA2],0000
   pop BP
ret far

A1eb72221:
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
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AL,[ES:BX]
   cbw
   mov BX,AX
   shl BX,1
   pop AX
   add AX,[BX+B1DA]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-04],AX
   mov word ptr [BP-0E],0002
   mov word ptr [BP-0C],FFFF
   mov SI,[BP-06]
jmp near L1eb72318
L1eb722ca:
   cmp SI,[BP-04]
   jl L1eb722d4
   mov word ptr [BP-0E],0000
L1eb722d4:
   mov DI,[BP-0A]
jmp near L1eb72312
L1eb722d9:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,7E86
   push DS
   pop ES
   mov AX,[ES:BX+02]
   or AX,[BP-0E]
   and AX,[BP+0C]
   mov [BP-10],AX
   mov AX,[BP-10]
   and [BP-0C],AX
   inc DI
L1eb72312:
   cmp DI,[BP-08]
   jl L1eb722d9
   inc SI
L1eb72318:
   cmp SI,[BP-02]
   jl L1eb722ca
   mov AX,[BP-0C]
jmp near L1eb72322
L1eb72322:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb72328:
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   add AX,[BP+0A]
   add AX,000F
   mov CL,04
   sar AX,CL
   mov [BP-02],AX
   mov DI,[BP-04]
jmp near L1eb723cb
L1eb72390:
   mov SI,[BP-08]
jmp near L1eb723c5
L1eb72395:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,7E86
   push DS
   pop ES
   mov AX,[ES:BX+02]
   and AX,[BP+0C]
   and [BP-0A],AX
   inc SI
L1eb723c5:
   cmp SI,[BP-06]
   jl L1eb72395
   inc DI
L1eb723cb:
   cmp DI,[BP-02]
   jl L1eb72390
   mov AX,[BP-0A]
jmp near L1eb723d5
L1eb723d5:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb723db:
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
   add BX,9146
   push DS
   pop ES
   mov BX,[ES:BX+0D]
   shl BX,1
   test word ptr [BX+BC06],0002
   jz L1eb72406
jmp near L1eb724fa
L1eb72406:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
jmp near L1eb724f2
L1eb724a6:
   mov DI,[BP-08]
jmp near L1eb724ea
L1eb724ab:
   mov BX,DI
   mov CL,07
   shl BX,CL
   add BX,3E40
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
   add BX,7E86
   push DS
   pop ES
   test word ptr [ES:BX+02],0008
   jz L1eb724e9
   mov AX,0001
   push AX
   push [BP-0A]
   push DI
   call far A16b00006
   add SP,+06
L1eb724e9:
   inc DI
L1eb724ea:
   cmp DI,[BP-06]
   jl L1eb724ab
   inc word ptr [BP-0A]
L1eb724f2:
   mov AX,[BP-0A]
   cmp AX,[BP-02]
   jl L1eb724a6
L1eb724fa:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

A1eb72500:
   push BP
   mov BP,SP
   push SI
   push DI
   xor DI,DI
   xor SI,SI
jmp near L1eb72584
L1eb7250c:
   cmp SI,DI
   jz L1eb72534
   mov AX,001F
   push AX
   push DS
   mov AX,SI
   mov DX,001F
   mul DX
   add AX,9146
   push AX
   push DS
   mov AX,DI
   mov DX,001F
   mul DX
   add AX,9146
   push AX
   call far A23900001
   add SP,+0A
L1eb72534:
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp byte ptr [ES:BX],03
   jnz L1eb72582
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+17]
   or AX,[ES:BX+19]
   jz L1eb72580
   mov AX,SI
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   push [ES:BX+19]
   push [ES:BX+17]
   call far A23f70008
   pop CX
   pop CX
L1eb72580:
jmp near L1eb72583
L1eb72582:
   inc DI
L1eb72583:
   inc SI
L1eb72584:
   cmp SI,[B5F6]
   jge L1eb7258d
jmp near L1eb7250c
L1eb7258d:
   mov [B5F6],DI
   pop DI
   pop SI
   pop BP
ret far

A1eb72595:
   push BP
   mov BP,SP
   cmp byte ptr [B0FC],00
   jz L1eb725b0
   dec word ptr [B14E]
   jge L1eb725b0
   mov byte ptr [B0FC],00
   or word ptr [BC12],C000
L1eb725b0:
   pop BP
ret far

A1eb725b2:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   cmp word ptr [ES:BX+1D],+00
   jnz L1eb725e7
   mov BX,[9153]
   shl BX,1
   test word ptr [BX+BC06],0002
   jnz L1eb725e7
   xor AX,AX
   push AX
   mov AX,0001
   push AX
   push CS
   call near offset A1eb705e1
   mov SP,BP
L1eb725e7:
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov word ptr [ES:BX+1D],0003
   pop BP
ret far

A1eb725ff:
   push BP
   mov BP,SP
   mov AX,2001
   push AX
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A1eb72328
   mov SP,BP
   cmp AX,2001
   jnz L1eb7262e
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A1eb71ace
   mov SP,BP
   mov AX,0001
jmp near L1eb72632
L1eb7262e:
   xor AX,AX
jmp near L1eb72632
L1eb72632:
   pop BP
ret far

A1eb72634:
   push BP
   mov BP,SP
   push SI
   push DI
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov DI,[ES:BX+01]
   mov AX,[BP+08]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   sub DI,[ES:BX+01]
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov SI,[ES:BX+03]
   mov AX,[BP+08]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   sub SI,[ES:BX+03]
   or DI,DI
   jnz L1eb726b5
   or SI,SI
   jz L1eb726b2
   or SI,SI
   jle L1eb7269a
   mov AX,0001
jmp near L1eb7269c
L1eb7269a:
   xor AX,AX
L1eb7269c:
   push AX
   or SI,SI
   jge L1eb726a6
   mov AX,0001
jmp near L1eb726a8
L1eb726a6:
   xor AX,AX
L1eb726a8:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov SI,AX
L1eb726b2:
jmp near L1eb7275c
L1eb726b5:
   or SI,SI
   jnz L1eb726dd
   or DI,DI
   jle L1eb726c2
   mov AX,0001
jmp near L1eb726c4
L1eb726c2:
   xor AX,AX
L1eb726c4:
   push AX
   or DI,DI
   jge L1eb726ce
   mov AX,0001
jmp near L1eb726d0
L1eb726ce:
   xor AX,AX
L1eb726d0:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov DI,AX
jmp near L1eb7275c
L1eb726dd:
   mov AX,DI
   cwd
   xor AX,DX
   sub AX,DX
   mov DX,SI
   or DX,DX
   jge L1eb726ec
   neg DX
L1eb726ec:
   cmp AX,DX
   jle L1eb72727
   mov AX,SI
   mul word ptr [BP+12]
   mov DX,DI
   or DX,DX
   jge L1eb726fd
   neg DX
L1eb726fd:
   mov BX,DX
   cwd
   idiv BX
   mov SI,AX
   or DI,DI
   jle L1eb7270d
   mov AX,0001
jmp near L1eb7270f
L1eb7270d:
   xor AX,AX
L1eb7270f:
   push AX
   or DI,DI
   jge L1eb72719
   mov AX,0001
jmp near L1eb7271b
L1eb72719:
   xor AX,AX
L1eb7271b:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov DI,AX
jmp near L1eb7275c
L1eb72727:
   mov AX,DI
   mul word ptr [BP+12]
   mov DX,SI
   or DX,DX
   jge L1eb72734
   neg DX
L1eb72734:
   mov BX,DX
   cwd
   idiv BX
   mov DI,AX
   or SI,SI
   jle L1eb72744
   mov AX,0001
jmp near L1eb72746
L1eb72744:
   xor AX,AX
L1eb72746:
   push AX
   or SI,SI
   jge L1eb72750
   mov AX,0001
jmp near L1eb72752
L1eb72750:
   xor AX,AX
L1eb72752:
   mov DX,AX
   pop AX
   sub AX,DX
   mul word ptr [BP+12]
   mov SI,AX
L1eb7275c:
   les BX,[BP+0A]
   mov [ES:BX],DI
   les BX,[BP+0E]
   mov [ES:BX],SI
   pop DI
   pop SI
   pop BP
ret far

A1eb7276c:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+01]
   push AX
   mov AX,[BP+08]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+03]
   push AX
   mov AX,[BP+08]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
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
jmp near L1eb727d5
L1eb727d5:
   pop BP
ret far

A1eb727d7:
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
jmp near L1eb7288c
L1eb727f2:
   mov AX,[BP+0A]
   mov BX,0010
   cwd
   idiv BX
   mov DI,AX
jmp near L1eb72867
L1eb727ff:
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov AX,[ES:BX]
   and AX,3FFF
   cmp AX,00A7
   jnz L1eb72866
   mov BX,SI
   mov CL,07
   shl BX,CL
   add BX,3E40
   push DS
   pop ES
   mov AX,DI
   shl AX,1
   add BX,AX
   mov word ptr [ES:BX],C000
   mov AX,[BP-02]
   inc word ptr [BP-02]
   or AX,AX
   jnz L1eb72866
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
   call far A11be0a58
   add SP,+06
   mov AX,0031
   push AX
   mov AX,0002
   push AX
   call far A0ce301e0
   pop CX
   pop CX
L1eb72866:
   inc DI
L1eb72867:
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+0B]
   add AX,[BP+0A]
   mov BX,0010
   cwd
   idiv BX
   cmp AX,DI
   jl L1eb7288b
jmp near L1eb727ff
L1eb7288b:
   inc SI
L1eb7288c:
   mov AX,[BP+06]
   mov DX,001F
   mul DX
   mov BX,AX
   add BX,9146
   push DS
   pop ES
   mov AX,[ES:BX+09]
   add AX,[BP+08]
   mov BX,0010
   cwd
   idiv BX
   cmp AX,SI
   jl L1eb728b0
jmp near L1eb727f2
L1eb728b0:
   mov AX,[BP-02]
jmp near L1eb728b5
L1eb728b5:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Y1eb728bb:	byte

Segment 2142 ;; JVOL3.C:JVOL3
B2142000c:
   push DS
   push AX
   mov AX,segment A24f10000
   mov DS,AX
   pop AX
   push CX
   push DX
   mov DX,[2670]
   add DL,0E
   mov CX,0200
L21420020:
   in AL,DX
   or AL,AL
   js L2142002a
   loop L21420020
   stc
jmp near L2142002f
L2142002a:
   sub DL,04
   in AL,DX
   clc
L2142002f:
   pop DX
   pop CX
   pop DS
ret near

B21420033:
   push DS
   push AX
   mov AX,segment A24f10000
   mov DS,AX
   pop AX
   push CX
   push DX
   mov DX,[2670]
   add DL,0C
   mov CX,0200
   mov AH,AL
L21420049:
   in AL,DX
   or AL,AL
   jns L21420053
   loop L21420049
   stc
jmp near L21420057
L21420053:
   mov AL,AH
   out DX,AL
   clc
L21420057:
   pop DX
   pop CX
   pop DS
ret near

X2142005b:
   push DS
   push AX
   mov AX,segment A24f10000
   mov DS,AX
   pop AX
   push DX
   mov DX,[2670]
   add DL,0E
L2142006b:
   in AL,DX
   or AL,AL
   js L21420072
jmp near L2142006b
L21420072:
   sub DL,04
   in AL,DX
   pop DX
   pop DS
ret near

X21420079:
   push DS
   push AX
   mov AX,segment A24f10000
   mov DS,AX
   pop AX
   push DX
   mov DX,[2670]
   add DX,+0C
   mov AH,AL
L2142008b:
   in AL,DX
   or AL,AL
   jns L21420092
jmp near L2142008b
L21420092:
   mov AL,AH
   out DX,AL
   pop DX
   pop DS
ret near

B21420098:
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

B214200ad:
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

X214200c0:
   push AX
   push CX
   mov CX,[2672]
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

X214200d8:
   push AX
   push CX
   mov CX,[2672]
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

A214200ee:
   push DS
   mov AX,segment A24f10000
   mov DS,AX
   push SI
   mov SI,0220
L214200f8:
   mov [2670],SI
   call far A2142011c
   or AX,AX
   jnz L21420119
   add SI,+10
   cmp SI,0260
   jbe L214200f8
   mov word ptr [2670],0210
   call far A2142011c
L21420119:
   pop SI
   pop DS
ret far

A2142011c:
   push DS
   push AX
   mov AX,segment A24f10000
   mov DS,AX
   pop AX
   sub BX,BX
   mov DX,[2670]
   add DL,06
   mov AL,C6
   out DX,AL
   sub AL,AL
   add DL,04
   out DX,AL
   in AL,DX
   cmp AL,C6
   jnz L21420151
   sub DL,04
   mov AL,39
   out DX,AL
   sub AL,AL
   add DL,04
   out DX,AL
   in AL,DX
   cmp AL,39
   jnz L21420151
   mov BX,0001
jmp near L21420177
L21420151:
   call far A21420294
   jb L21420177
   mov AL,E0
   call near B21420033
   jb L21420177
   mov AL,C6
   call near B21420033
   jb L21420177
   call near B2142000c
   jb L21420177
   cmp AL,39
   jnz L21420177
   mov BX,0004
   push BX
   call near B214201d7
   pop BX
L21420177:
   mov AX,0100
   call near B21420254
   mov AX,0460
   call near B21420254
   mov AX,0480
   call near B21420254
   mov AL,00
   call near B214201b6
   jb L214201b2
   mov AX,02FF
   call near B21420254
   mov AX,0421
   call near B21420254
   mov AL,C0
   call near B214201b6
   jb L214201b2
   mov AX,0460
   call near B21420254
   mov AX,0480
   call near B21420254
   add BX,+02
L214201b2:
   mov AX,BX
   pop DS
ret far

B214201b6:
   push CX
   push DX
   mov CX,0040
   mov AH,AL
   and AH,E0
   mov DX,[2670]
   add DL,08
L214201c7:
   in AL,DX
   and AL,E0
   cmp AH,AL
   jz L214201d3
   loop L214201c7
   stc
jmp near L214201d4
L214201d3:
   clc
L214201d4:
   pop DX
   pop CX
ret near

B214201d7:
   push BP
   sub SP,+04
   mov BP,SP
   mov BX,0008
   call near B214200ad
   mov [BP+00],AX
   mov [BP+02],DX
   cli
   in AL,21
   mov [2674],AX
   mov AL,FE
   out 21,AL
   mov AX,1B58
   call near B2142027d
   mov BX,0008
   mov DX,CS
   mov AX,028A
   call near B21420098
   sub AX,AX
   sub CX,CX
   sti
L21420209:
   or AX,AX
   jz L21420209
L2142020d:
   or AX,AX
   jnz L2142020d
L21420211:
   nop
   inc CX
   or AX,AX
   jz L21420211
   cli
   mov AX,[2674]
   out 21,AL
   mov AX,FFFF
   call near B2142027d
   sti
   mov BX,0008
   mov DX,[BP+02]
   mov AX,[BP+00]
   call near B21420098
   mov AX,CX
   shl CX,1
   shl CX,1
   shl CX,1
   add AX,CX
   mov CL,0A
   shr AX,CL
   mov [2674],AX
   mov CX,AX
   shl AX,1
   add CX,AX
   shl AX,1
   add CX,AX
   mov [2676],CX
   add SP,+04
   pop BP
ret near

B21420254:
   push AX
   push CX
   push DX
   mov DX,[2670]
   add DL,08
   xchg AH,AL
   out DX,AL
   mov CX,[2674]
L21420265:
   nop
   dec CX
   or CX,CX
   jnz L21420265
   inc DX
   mov AL,AH
   out DX,AL
   mov CX,[2676]
L21420273:
   nop
   dec CX
   or CX,CX
   jnz L21420273
   pop DX
   pop CX
   pop AX
ret near

B2142027d:
   push AX
   mov AL,36
   out 43,AL
   pop AX
   out 40,AL
   mov AL,AH
   out 40,AL
ret near

X2142028a:
   not AX
   push AX
   mov AL,20
   out 20,AL
   pop AX
iret

Y21420293:	byte

A21420294:
   push DS
   mov AX,segment A24f10000
   mov DS,AX
   mov DX,[2670]
   add DL,06
   mov AL,01
   out DX,AL
   sub AL,AL
L214202a6:
   dec AL
   jnz L214202a6
   out DX,AL
   mov CX,0020
L214202ae:
   call near B2142000c
   jb L214202bb
   cmp AL,AA
   jnz L214202bb
   sub AX,AX
jmp near L214202c1
L214202bb:
   loop L214202ae
   stc
   mov AX,0001
L214202c1:
   pop DS
ret far

Y214202c3:	byte

A214202c4:
   push DS
   mov AX,segment A24f10000
   mov DS,AX
   mov AX,[2670]
   mov BX,FFFD
   call far A21830000
   mov BX,FFFF
   call far A21830000
   jb L214202fb
   mov DX,segment A24f10000
   mov AX,266E
   mov BX,0001
   call far A21830000
   mov [CS:offset Y214202ff+2],DX
   mov [CS:offset Y214202ff],AX
   mov AX,0001
jmp near L214202fd
L214202fb:
   sub AX,AX
L214202fd:
   pop DS
ret far

Y214202ff:	dword

X21420303:
   push BP
   mov BP,SP
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov BX,0001
   call far A21830000
   pop BP
ret far

A21420316:
   push BP
   mov BP,SP
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov BX,0006
   call far A21830000
   pop BP
ret far

A21420329:
   push BP
   mov BP,SP
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov CX,[BP+0A]
   mov BX,0002
   call far A21830000
   pop BP
ret far

A2142033f:
   push BP
   mov BP,SP
   mov BX,0008
   call far A21830000
   pop BP
ret far

X2142034c:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov BX,0003
   call far A21830000
   pop BP
ret far

X2142035c:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov BX,0004
   call far A21830000
   pop BP
ret far

A2142036c:
   mov BX,0007
   call far A21830000
ret far

X21420375:
   mov BX,0000
   call far A21830000
ret far

X2142037e:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   mov BX,0005
   call far A21830000
   pop BP
ret far

X2142038e:
   push BP
   mov BP,SP
   mov BX,0009
   call far A21830000
   pop BP
ret far

X2142039b:
   push BP
   mov BP,SP
   mov BX,000A
   call far A21830000
   pop BP
ret far

X214203a8:
   pushf
   push DS
   mov AX,segment A24f10000
   mov DS,AX
   sub AX,AX
   cli
   cmp byte ptr [266E],00
   jz L214203bf
   mov AL,FF
   xchg AL,[266E]
L214203bf:
   pop DS
   popf
ret far

A214203c2:
   mov BX,FFFE
   call far A21830000
   mov BX,0001
   mov DX,[CS:offset Y214202ff+2]
   mov AX,[CS:offset Y214202ff]
   call far A21830000
ret far

X214203dc:
   push BP
   mov BP,SP
   call far A21830000
   pop BP
ret far

X214203e6:
   mov BX,000C
   call far A21830000
ret far

X214203ef:
   push BP
   mov BP,SP
   push DI
   mov AX,[BP+06]
   mov DX,[BP+08]
   mov CX,[BP+0A]
   mov DI,[BP+0C]
   mov BX,000E
   call far A21830000
   pop DI
   pop BP
ret far

X2142040a:	ds 0006

;; === External Library Modules ===
Segment 2183 ;; SBCRWIO.ASM, VECTOR.ASM, SCANCARD.ASM, MUSDATA.ASM, SBCDATA.ASM, CARDHERE.ASM, DSPRESET.ASM, CMFASM.ASM, CMFDRV.ASM
A21830000:
jmp near L2183110f

Y21830003:	db "FMDRV",00
Y21830009:	dw 0220
Y2183000b:	byte
Y2183000c:	dw 0114
Y2183000e:	ds 4*0008
Y2183002e:	word
Y21830030:	word
Y21830032:	word
Y21830034:	word
Y21830036:	word
Y21830038:	word
Y2183003a:	word
Y2183003c:	word
Y2183003e:	word
Y21830040:	word
Y21830042:	word
Y21830044:	dword
Y21830048:	db 21,21,d1,07,a3,a4,46,25,00,00,0a,00,00,00,00,00
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
Y21830148:	ds 000b
Y21830153:	ds 000b
Y2183015e:	ds 000b
Y21830169:	ds 000b
Y21830174:	ds 000b
Y2183017f:	ds 000b
Y2183018a:	ds 2*000b
Y218301a0:	ds 2*000b
Y218301b6:	db 63
Y218301b7:	db 63
Y218301b8:	word
Y218301ba:	word
Y218301bc:	byte
Y218301bd:	db 00,01,02,08,09,0a,10,11,12
Y218301c6:	db 01,11,4f,00,f1
Y218301cb:	db f2,53,74,00,00
Y218301d0:	db 08,10,14,12,15
Y218301d5:	db 11,10,08,04,02,01,06,07,08,08,07
Y218301e0:	byte
Y218301e1:	byte
Y218301e2:	byte
Y218301e3:	byte
Y218301e4:	byte
Y218301e5:	byte
Y218301e6:	byte
Y218301e7:	byte
Y218301e8:	byte
Y218301e9:	ds 0010
Y218301f9:	ds 2*0010
Y21830219:	db 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
Y21830229:	dw offset B21830d29,offset B21830da0,offset B21830f8d,offset B21830efa
		dw offset B21830f90,offset B21830f8e,offset B21830f8d,offset B2183100a
Y21830239:	dw offset B21830f10,offset B21830f16,offset B21830f3c,offset B21830f3a
Y21830241:	dw offset B21831017,offset B21830f8f,offset B21830f8d,offset B21830f8e
		dw offset B21830f8f,offset B21830f8f,offset B21830f8f,offset B2183102d
		dw offset B21830f8f,offset B21830f8f,offset B21830f8f,offset B21830f8f
		dw offset B21831038,offset B21830f8f,offset B21830f8f,offset B2183103c
Y21830261:	dw offset B2183116d,offset B21831171,offset B21831184,offset B218311c6
		dw offset B218311ca,offset B218311d3,offset B21830c39,offset B218311b6
		dw offset B21830c00,offset B21830c98,offset B21830cad,offset B218311d9
		dw offset B218311e6,offset B218311ed,offset B218311fb
Y2183027f:	dw offset B21831487,offset B2183149d,offset B218314a6
Y21830285:	db 00,01,02,03,04,05,06,07,08,09,0a,0b,00,01,02,03
		db 04,05,06,07,08,09,0a,0b,10,11,12,13,14,15,16,17
		db 18,19,1a,1b,20,21,22,23,24,25,26,27,28,29,2a,2b
		db 30,31,32,33,34,35,36,37,38,39,3a,3b,40,41,42,43
		db 44,45,46,47,48,49,4a,4b,50,51,52,53,54,55,56,57
		db 58,59,5a,5b,60,61,62,63,64,65,66,67,68,69,6a,6b
		db 70,71,72,73,74,75,76,77,78,79,7a,7b,70,71,72,73
		db 74,75,76,77,78,79,7a,7b,7b,7b,7b,7b,7b,7b,7b,7b
Y21830305:	dw 0157,0157,0158,0158,0158,0158,0159,0159,0159,015a,015a,015a,015b,015b,015b,015c
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

B21830905:
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

B2183091a:
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

B2183092d:
   mov [0036],AX
   mov AL,36
   out 43,AL
   mov AL,[0036]
   out 40,AL
   mov AL,AH
   out 40,AL
ret near

B2183093e:
   push AX
   push CX
   push DX
   mov DX,[0009]
   xchg AH,AL
   out DX,AL
   mov CX,[002E]
L2183094c:
   nop
   dec CX
   or CX,CX
   jnz L2183094c
   inc DX
   mov AL,AH
   out DX,AL
   mov CX,[0030]
L2183095a:
   nop
   dec CX
   or CX,CX
   jnz L2183095a
   pop DX
   pop CX
   pop AX
ret near

B21830964:
   pushf
   cli
   mov BX,0008
L21830969:
   mov AH,83
   add AL,BL
   mov AL,13
   call near B2183093e
   cmp byte ptr [BX+0148],7F
   ja L21830993
   shl BX,1
   mov DX,[BX+018A]
   shr BX,1
   mov AH,A0
   add AH,BL
   mov AL,DL
   call near B2183093e
   mov AH,B0
   add AH,BL
   mov AL,DH
   call near B2183093e
L21830993:
   dec BL
   jns L21830969
   cmp byte ptr [01E7],00
   jz L218309ab
   and byte ptr [01E6],E0
   mov AL,[01E6]
   mov AH,BD
   call near B2183093e
L218309ab:
   popf
ret near

B218309ad:
   push ES
   push DI
   push SI
   mov CX,CS
   mov ES,CX
   mov CX,0010
   mov DI,01E9
   sub AL,AL
   repz stosb
   mov CX,000B
   mov AL,FF
   mov DI,0148
   repz stosb
   mov DI,01BD
   mov BL,00
L218309cd:
   call near B21830bee
   mov AX,0800
   call near B2183093e
   mov AH,[DI]
   mov CX,0004
   mov SI,01C6
L218309de:
   add AH,20
   lodsb
   call near B2183093e
   add AH,03
   lodsb
   call near B2183093e
   sub AH,03
   loop L218309de
   add AH,60
   lodsb
   call near B2183093e
   add AH,03
   lodsb
   call near B2183093e
   mov AH,[DI]
   add AH,BL
   lodsb
   call near B2183093e
   inc DI
   inc BL
   cmp BL,09
   jb L218309cd
   pop SI
   pop DI
   pop ES
ret near

B21830a13:
   push DS
   push BX
   lds BX,[0026]
   mov [BX],AL
   pop BX
   pop DS
ret near

B21830a1e:
   push ES
   push CX
   push DI
   cmp AL,[01E0]
   jb L21830a2a
jmp near L21830b1b
L21830a2a:
   cbw
   shl AX,1
   shl AX,1
   shl AX,1
   shl AX,1
   les DI,[0016]
   add DI,AX
   mov AL,[ES:DI+03]
   cmp byte ptr [01E7],00
   jz L21830a4d
   cmp BL,07
   jb L21830a4d
   mov AL,[ES:DI+02]
L21830a4d:
   mov AH,AL
   and AX,C03F
   mov [BX+0169],AH
   sub AL,3F
   neg AL
   mov [BX+017F],AL
   mul byte ptr [01B6]
   add AL,AL
   adc AH,00
   mov [BX+0174],AH
   cmp byte ptr [01E7],00
   jz L21830a77
   cmp BX,+06
   ja L21830add
L21830a77:
   mov AH,[BX+01BD]
   add AH,20
   mov AL,[ES:DI]
   inc DI
   call near B2183093e
   add AH,03
   mov AL,[ES:DI]
   inc DI
   call near B2183093e
   sub AH,03
   add AH,20
   mov AL,[ES:DI]
   inc DI
   call near B2183093e
   inc DI
   mov CX,0002
L21830aa0:
   add AH,20
   mov AL,[ES:DI]
   inc DI
   call near B2183093e
   add AH,03
   mov AL,[ES:DI]
   inc DI
   call near B2183093e
   sub AH,03
   loop L21830aa0
   add AH,60
   mov AL,[ES:DI]
   inc DI
   call near B2183093e
   add AH,03
   mov AL,[ES:DI]
   inc DI
   call near B2183093e
   sub AH,03
   mov AH,BL
   add AH,C0
   mov AL,[ES:DI]
   call near B2183093e
jmp near L21830b1b
L21830add:
   mov AH,[BX+01CB]
   add AH,20
   mov AL,[ES:DI]
   inc DI
   inc DI
   call near B2183093e
   add AH,20
   inc DI
   inc DI
   mov CX,0002
L21830af4:
   add AH,20
   mov AL,[ES:DI]
   inc DI
   inc DI
   call near B2183093e
   loop L21830af4
   add AH,60
   mov AL,[ES:DI]
   inc DI
   inc DI
   call near B2183093e
   mov AH,[BX+01D5]
   add AH,C0
   mov AL,[ES:DI]
   call near B2183093e
jmp near L21830b1b
L21830b1b:
   pop DI
   pop CX
   pop ES
ret near

B21830b1f:
   push SI
   push BX
   push DS
   sub BX,BX
   sub DX,DX
   lds SI,[001A]
L21830b2a:
   lodsb
   push AX
   and AL,7F
   cbw
   add BX,AX
   adc DX,+00
   pop AX
   or AL,AL
   jns L21830b45
   mov AL,07
L21830b3b:
   shl BX,1
   rcl DX,1
   dec AL
   jnz L21830b3b
jmp near L21830b2a
L21830b45:
   pop DS
   mov AX,BX
   mov [001A],SI
   pop BX
   pop SI
ret near

B21830b4f:
   push CX
   add [001A],AX
   jnb L21830b5c
   add word ptr [001C],1000
L21830b5c:
   mov CL,04
   mov DH,DL
   sub DL,DL
   shl DX,CL
   add [001C],DX
   mov SI,[001A]
   pop CX
ret near

B21830b6e:
   push ES
   mov CX,DS
   mov ES,CX
   mov CX,[003A]
   mov AH,AL
   or AL,80
   mov DI,0148
   repnz scasb
   jz L21830be6
   mov CX,[003A]
   mov AL,FF
   mov DI,0148
   repnz scasb
   jz L21830be6
   mov CX,[003A]
   mov AL,7F
   mov DI,0148
L21830b98:
   cmp AL,[DI]
   jb L21830ba1
   inc DI
   loop L21830b98
jmp near L21830ba4
L21830ba1:
   inc DI
jmp near L21830be6
L21830ba4:
   push SI
   sub SI,SI
   mov CX,[003A]
   mov DI,01A0
   mov AX,DI
L21830bb0:
   mov DX,[DI]
   sub DX,[0040]
   neg DX
   cmp DX,SI
   jbe L21830bc0
   mov SI,DX
   mov AX,DI
L21830bc0:
   inc DI
   inc DI
   dec CX
   jnz L21830bb0
   sub AX,01A0
   mov BX,AX
   mov AX,[BX+018A]
   shr BX,1
   mov DH,A0
   xchg DH,AH
   add AH,BL
   call near B2183093e
   add AH,10
   mov AL,DH
   call near B2183093e
   mov AX,BX
   pop SI
jmp near L21830bec
L21830be6:
   sub DI,0149
   mov AX,DI
L21830bec:
   pop ES
ret near

B21830bee:
   mov word ptr [003A],0009
   mov AX,00C0
   mov [01E6],AX
   mov AH,BD
   call near B2183093e
ret near

B21830c00:
   mov byte ptr [01B6],FF
   mov byte ptr [01B7],FF
   call near B21831198
   call near B21830bee
   mov CX,0008
   mov DI,0219
   mov AX,0101
   repz stosw
   mov byte ptr [01E0],10
   mov word ptr [0016],0048
   mov [0018],DS
   call near B218309ad
   mov word ptr [0034],48D3
   sub AX,AX
   mov [0042],AX
ret near

B21830c39:
   mov CX,AX
   mov AX,FFFE
   cmp byte ptr [01E1],00
   jnz L21830c97
   mov [001E],CX
   mov [0020],DX
   mov [001A],CX
   mov [001C],DX
   mov CX,0010
   sub AX,AX
   mov DI,01F9
   repz stosw
   mov CX,0009
   mov AL,FF
   mov DI,0148
   repz stosb
   call near B21830b1f
   mov [0022],AX
   mov [0024],DX
   mov word ptr [0040],0000
   mov AX,[0034]
   call near B2183092d
   mov word ptr [0038],0000
   call near B21830bee
   pushf
   cli
   mov byte ptr [01E1],01
   mov AL,FF
   call near B21830a13
   popf
   sub AX,AX
L21830c97:
ret near

B21830c98:
   mov AX,FFFD
   cmp byte ptr [01E1],01
   jnz L21830cac
   mov byte ptr [01E1],02
   call near B21830964
   sub AX,AX
L21830cac:
ret near

B21830cad:
   mov AX,FFFC
   cmp byte ptr [01E1],02
   jnz L21830cbe
   mov byte ptr [01E1],01
   sub AX,AX
L21830cbe:
ret near

B21830cbf:
   push ES
   inc word ptr [0040]
   mov AX,[001A]
   shr AX,1
   shr AX,1
   shr AX,1
   shr AX,1
   add [001C],AX
   and word ptr [001A],+0F
L21830cd8:
   les SI,[001A]
   mov AL,[ES:SI]
   or AL,AL
   jns L21830cfa
   inc SI
   mov AH,AL
   and AL,0F
   mov [003C],AL
   shr AH,1
   shr AH,1
   shr AH,1
   shr AH,1
   sub AH,08
   mov [003E],AH
L21830cfa:
   mov BX,[003E]
   shl BX,1
   call near [BX+0229]
   mov [001A],SI
   cmp byte ptr [01E1],00
   jz L21830d27
   call near B21830b1f
   mov [0022],AX
   mov [0024],DX
   or AX,DX
   jz L21830cd8
   sub word ptr [0022],+01
   sbb word ptr [0024],+00
L21830d27:
   pop ES
ret near

B21830d29:
   mov AX,[ES:SI]
   inc SI
   inc SI
   mov [01E2],AL
   mov [01E3],AH
L21830d35:
   push ES
   mov AX,DS
   mov ES,AX
   mov CX,[003A]
   mov AH,[003C]
   cmp CL,06
   ja L21830d64
   cmp AH,0B
   jb L21830d64
   sub BH,BH
   mov BL,AH
   mov AL,[BX+01CB]
   not AL
   and AL,[01E6]
   mov [01E6],AL
   mov AH,BD
   call near B2183093e
jmp near L21830d9c
L21830d64:
   mov AL,[01E2]
   mov DI,015E
L21830d6a:
   repnz scasb
   jnz L21830d9c
   mov BX,DI
   sub BX,015F
   cmp AH,[BX+0148]
   jz L21830d7e
   jcxz L21830d9c
jmp near L21830d6a
L21830d7e:
   or byte ptr [BX+0148],80
   shl BX,1
   mov AX,[BX+018A]
   shr BX,1
   mov DL,AH
   mov AH,A0
   add AH,BL
   call near B2183093e
   mov AL,DL
   add AH,10
   call near B2183093e
L21830d9c:
   pop ES
ret near

L21830d9e:
jmp near L21830d35

B21830da0:
   mov AX,[ES:SI]
   inc SI
   inc SI
   mov [01E2],AL
   mov [01E3],AH
   or AH,AH
   jz L21830d9e
   mov AL,[003C]
   mov BL,AL
   sub BH,BH
   cmp BH,[BX+0219]
   jz L21830e21
   cmp byte ptr [01E7],00
   jz L21830dcd
   cmp AL,0B
   jb L21830dcd
   call near B21830e22
jmp near L21830e21
L21830dcd:
   call near B21830b6e
   mov BX,AX
   mov AL,[003C]
   xchg AL,[BX+0148]
   and AL,7F
   cmp AL,[003C]
   jz L21830dec
   mov DI,[003C]
   mov AL,[DI+01E9]
   call near B21830a1e
L21830dec:
   mov CL,[01E3]
   or CL,80
   mov AL,[BX+0174]
   mul CL
   mov AL,3F
   sub AL,AH
   or AL,[BX+0169]
   mov AH,[BX+01BD]
   add AH,43
   call near B2183093e
   call near B21830e75
   mov DL,AH
   mov AH,A0
   add AH,BL
   call near B2183093e
   mov AL,DL
   or AL,20
   add AH,10
   call near B2183093e
L21830e21:
ret near

B21830e22:
   sub AL,05
   cbw
   mov BX,AX
   mov AL,[BX+01D0]
   or [01E6],AL
   mov CL,[01E3]
   or CL,80
   mov AL,[BX+0174]
   mul CL
   mov AL,3F
   sub AL,AH
   or AL,[BX+0169]
   mov AH,[BX+01CB]
   cmp BL,06
   jnz L21830e50
   add AH,03
L21830e50:
   add AH,40
   call near B2183093e
   call near B21830e75
   mov DL,AH
   mov AH,A0
   add AH,[BX+01D5]
   call near B2183093e
   mov AL,DL
   add AH,10
   call near B2183093e
   mov AL,[01E6]
   mov AH,BD
   call near B2183093e
ret near

B21830e75:
   mov AL,[01E2]
   mov [BX+015E],AL
   cbw
   mov DI,[0042]
   add DI,AX
   jns L21830e89
   sub DI,DI
jmp near L21830e92
L21830e89:
   cmp DI,0080
   jb L21830e92
   mov DI,007F
L21830e92:
   mov AL,[DI+0285]
   mov [BX+0153],AL
   call near B21830e9e
ret near

B21830e9e:
   mov DL,AL
   and DL,70
   shr DL,1
   shr DL,1
   and AL,0F
   cbw
   xchg AL,AH
   shr AX,1
   shr AX,1
   mov DI,[003C]
   shl DI,1
   add AX,[DI+01F9]
   jns L21830eca
   add AX,0300
   sub DL,04
   jns L21830edf
   sub DL,DL
   sub AX,AX
jmp near L21830edf
L21830eca:
   cmp AX,0300
   jb L21830edf
   sub AX,0300
   add DL,04
   cmp DL,1C
   jbe L21830edf
   mov AX,02FF
   mov DL,1C
L21830edf:
   shl AX,1
   mov DI,AX
   mov AX,[DI+0305]
   or AH,DL
   shl BX,1
   mov [BX+018A],AX
   mov CX,[0040]
   mov [BX+01A0],CX
   shr BX,1
ret near

B21830efa:
   mov AX,[ES:SI]
   inc SI
   inc SI
   sub AL,66
   cmp AL,04
   jnb L21830f0f
   mov BL,AL
   sub BH,BH
   shl BX,1
   call near [BX+0239]
L21830f0f:
ret near

B21830f10:
   mov AL,AH
   call near B21830a13
ret near

B21830f16:
   push AX
   call near B218309ad
   pop AX
   mov CX,09C0
   mov [01E7],AH
   or AH,AH
   jz L21830f29
   mov CX,06E0
L21830f29:
   mov [01E6],CL
   mov [003A],CH
   mov AL,[01E6]
   mov AH,BD
   call near B2183093e
ret near

B21830f3a:
   neg AH
B21830f3c:
   push ES
   mov BX,CS
   mov ES,BX
   mov AL,AH
   cbw
   sar AX,1
   sar AX,1
   mov BX,[003C]
   shl BX,1
   mov [BX+01F9],AX
   shr BX,1
   mov CX,[003A]
   mov DI,0148
   mov AL,BL
L21830f5d:
   repnz scasb
   jnz L21830f8b
   push AX
   push CX
   push DI
   sub DI,0149
   mov BX,DI
   mov AL,[BX+0153]
   call near B21830e9e
   mov DL,AH
   mov AH,A0
   add AH,BL
   call near B2183093e
   mov AL,DL
   or AL,20
   add AH,10
   call near B2183093e
   pop DI
   pop CX
   pop AX
   or CX,CX
   jnz L21830f5d
L21830f8b:
   pop ES
ret near

B21830f8d:
   inc SI
B21830f8e:
   inc SI
B21830f8f:
ret near

B21830f90:
   mov AL,[ES:SI]
   inc SI
L21830f94:
   cmp AL,[01E0]
   jb L21830fa0
   sub AL,[01E0]
jmp near L21830f94
L21830fa0:
   mov BX,[003C]
   add BX,01E9
   mov [BX],AL
   push ES
   mov AX,DS
   mov ES,AX
   cmp byte ptr [01E7],00
   jz L21830fcd
   cmp word ptr [003C],+0B
   jb L21830fcd
   mov BX,[003C]
   mov AL,[BX+01E9]
   sub BL,05
   call near B21830a1e
jmp near L21831008
L21830fcd:
   mov CX,[003A]
   mov AL,[003C]
   or AL,80
   mov DI,0148
L21830fd9:
   repnz scasb
   jnz L21830fe5
   mov byte ptr [DI-01],FF
   or CX,CX
   jnz L21830fd9
L21830fe5:
   mov CX,[003A]
   mov DI,0148
L21830fec:
   mov AL,[003C]
   repnz scasb
   jnz L21831008
   mov BX,[003C]
   mov AL,[BX+01E9]
   mov BX,DI
   sub BX,0149
   call near B21830a1e
   or CX,CX
   jnz L21830fec
L21831008:
   pop ES
ret near

B2183100a:
   mov BL,[003C]
   sub BH,BH
   shl BX,1
   call near [BX+0241]
ret near

B21831017:
   mov [001A],SI
   cmp word ptr [002C],+00
   jz L21831026
   call far [002A]
L21831026:
   call near B21830b1f
   call near B21830b4f
ret near

B2183102d:
   mov [001A],SI
   call near B21830b1f
   call near B21830b4f
ret near

B21831038:
   call near B21831198
ret near

B2183103c:
   mov AL,[ES:SI]
   inc SI
   cmp AL,2F
   jnz L21831047
   call near B21831198
L21831047:
   mov [001A],SI
   call near B21830b1f
   call near B21830b4f
ret near

A21831052:
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
   cmp byte ptr [01E1],01
   jnz L218310a8
   mov AX,[01B6]
   cmp AL,AH
   jz L21831080
   dec word ptr [01B8]
   jnz L21831080
   mov CX,[01BA]
   mov [01B8],CX
   call near B218312a0
L21831080:
   sub word ptr [0022],+01
   sbb word ptr [0024],+00
   jnb L218310a8
   mov [0046],SS
   mov [0044],SP
   cli
   mov AX,CS
   mov SS,AX
   mov SP,1337
   cld
   call near B21830cbf
   mov SS,[0046]
   mov SP,[0044]
L218310a8:
   mov CX,[0032]
   mov AX,[0036]
   add [0038],AX
   jb L218310bb
   cmp [0038],CX
   jb L218310cc
L218310bb:
   sub [0038],CX
   pushf
   call far [000E]
   cmp [0038],CX
   ja L218310bb
jmp near L218310d0
L218310cc:
   mov AL,20
   out 20,AL
L218310d0:
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

A218310da:
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
   js L21831101
   cmp AL,83
   jnz L21831101
   mov AH,02
   int 16
   and AL,0C
   cmp AL,0C
   jnz L21831101
   call near B21830964
L21831101:
   pop BP
   pop SI
   pop DI
   pop DX
   pop CX
   pop BX
   pop AX
   pop ES
   pop DS
jmp far [CS:offset Y21830012]
L2183110f:
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
   cmp byte ptr [01E4],00
   jnz L2183115e
   mov byte ptr [01E4],01
   sti
   cld
   mov word ptr [BP+0C],FFFF
   or BX,BX
   js L21831147
   cmp BX,+0F
   jnb L21831157
   shl BX,1
   call near [BX+0261]
jmp near L21831154
L21831147:
   not BX
   cmp BX,+03
   jnb L21831157
   shl BX,1
   call near [BX+027F]
L21831154:
   mov [BP+0C],AX
L21831157:
   mov byte ptr [01E4],00
jmp near L21831163
L2183115e:
   mov word ptr [BP+0C],FFF8
L21831163:
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

B2183116d:
   mov AX,[000C]
ret near

B21831171:
   xchg DX,[0028]
   xchg AX,[0026]
   mov [BP+06],DX
   push AX
   sub AX,AX
   call near B21830a13
   pop AX
ret near

B21831184:
   mov [01E0],CL
   mov [0018],DX
   mov [0016],AX
   call near B21830bee
   call near B218309ad
   sub AX,AX
ret near

B21831198:
   cmp byte ptr [01E1],00
   jz L218311b5
   pushf
   cli
   sub AL,AL
   mov [01E1],AL
   mov AX,[0032]
   call near B2183092d
   call near B21830964
   sub AX,AX
   call near B21830a13
   popf
L218311b5:
ret near

B218311b6:
   mov AX,FFFD
   cmp byte ptr [01E1],00
   jz L218311c5
   call near B21831198
   sub AX,AX
L218311c5:
ret near

B218311c6:
   mov [0032],AX
ret near

B218311ca:
   mov [0034],AX
   call near B2183092d
   sub AX,AX
ret near

B218311d3:
   mov [0042],AX
   sub AX,AX
ret near

B218311d9:
   pushf
   cli
   mov [002C],DX
   mov [002A],AX
   sub AX,AX
   popf
ret near

B218311e6:
   mov [BP+06],CS
   mov AX,0219
ret near

B218311ed:
   pushf
   cli
   mov DX,[001C]
   mov AX,[001A]
   mov [BP+06],DX
   popf
ret near

B218311fb:
   push DX
   push AX
   mov [01BA],DI
   mov [01B8],DI
   mov AX,CX
   call near B21831265
   mov AH,64
   call near B21831276
   mov [01BC],AL
   pop AX
   cli
   cmp AX,FFFF
   jnz L2183121e
   mov AL,[01B6]
jmp near L21831226
L2183121e:
   call near B21831265
   mov AH,64
   call near B21831276
L21831226:
   mov [01B6],AL
   mov [01B7],AL
   sti
   mov CX,000B
   mov DI,0174
   mov SI,017F
   mov DL,AL
L21831238:
   lodsb
   mul DL
   add AL,AL
   adc AH,00
   mov AL,AH
   stosb
   loop L21831238
   pop AX
   call near B21831265
   mov AH,64
   call near B21831276
   mov [01B7],AL
ret near

X21831252:
   cbw
   mov BX,AX
   shl BX,1
   shl BX,1
   mov AX,[BX+000E]
   mov DX,[BX+0010]
   mov [BP+06],DX
ret near

B21831265:
   or AX,AX
   jns L2183126d
   sub AX,AX
jmp near L21831275
L2183126d:
   cmp AX,0064
   jb L21831275
   mov AX,0063
L21831275:
ret near

B21831276:
   push CX
   push DX
   mov DH,AH
   sub AH,AH
   div DH
   xchg AL,AH
   sub DL,DL
   mov CX,0008
L21831285:
   shl DL,1
   shl AL,1
   jb L2183128f
   cmp AL,DH
   jb L21831294
L2183128f:
   or DL,01
   sub AL,DH
L21831294:
   loop L21831285
   shl AL,1
   adc DL,00
   mov AL,DL
   pop DX
   pop CX
ret near

B218312a0:
   mov CL,[01BC]
   mov AX,[01B6]
   cmp AL,AH
   jb L218312b1
   sub AL,CL
   jnb L218312b7
jmp near L218312b5
L218312b1:
   add AL,CL
   jnb L218312b7
L218312b5:
   mov AL,AH
L218312b7:
   mov [01B6],AL
   mov DL,AL
   mov SI,017F
   mov DI,0174
   mov CX,000B
L218312c5:
   lodsb
   mul DL
   add AL,AL
   adc AH,00
   mov AL,AH
   stosb
   loop L218312c5
ret near

Y218312d3:	ds 0064

B21831337:
   push CX
   push DX
   mov CX,0040
   mov AH,AL
   and AH,E0
   mov DX,[0009]
L21831345:
   in AL,DX
   and AL,E0
   cmp AH,AL
   jz L21831351
   loop L21831345
   stc
jmp near L21831352
L21831351:
   clc
L21831352:
   pop DX
   pop CX
ret near

B21831355:
   mov AX,0100
   call near B2183093e
   mov AX,0460
   call near B2183093e
   mov AX,0480
   call near B2183093e
   mov AL,00
   call near B21831337
   jb L2183138e
   mov AX,02FF
   call near B2183093e
   mov AX,0421
   call near B2183093e
   mov AL,C0
   call near B21831337
   jb L2183138e
   mov AX,0460
   call near B2183093e
   mov AX,0480
   call near B2183093e
   clc
L2183138e:
ret near

A2183138f:
   not AX
   push AX
   mov AL,20
   out 20,AL
   pop AX
iret

B21831398:
   mov BX,0008
   call near B2183091a
   mov [000E],AX
   mov [0010],DX
   cli
   in AL,21
   mov [002E],AX
   mov AL,FE
   out 21,AL
   mov AX,1B58
   call near B2183092d
   mov BX,0008
   mov DX,CS
   mov AX,offset A2183138f
   call near B21830905
   sub AX,AX
   sub CX,CX
   sti
L218313c5:
   or AX,AX
   jz L218313c5
L218313c9:
   or AX,AX
   jnz L218313c9
L218313cd:
   nop
   inc CX
   or AX,AX
   jz L218313cd
   cli
   mov AX,[002E]
   out 21,AL
   mov AX,[0032]
   call near B2183092d
   sti
   mov BX,0008
   mov DX,[0010]
   mov AX,[000E]
   call near B21830905
   mov AX,CX
   shr CX,1
   add AX,CX
   mov CL,0A
   shr AX,CL
   mov [002E],AX
   mov CX,AX
   shl CX,1
   add AX,CX
   shl CX,1
   add AX,CX
   mov [0030],AX
   add word ptr [0009],+08
ret near

B2183140d:
   mov word ptr [0032],FFFF
   mov word ptr [0036],FFFF
   mov word ptr [0034],48D3
   mov [0028],CS
   mov word ptr [0026],01E5
   mov AX,0120
   call near B2183093e
   mov AX,0800
   call near B2183093e
   call near B21830c00
   sub AX,AX
ret near

B2183143b:
   mov BX,0008
   call near B2183091a
   mov [0010],DX
   mov [000E],AX
   mov BX,0008
   mov DX,CS
   mov AX,offset A21831052
   call near B21830905
   mov BX,0009
   call near B2183091a
   mov [0014],DX
   mov [0012],AX
   mov BX,0009
   mov DX,CS
   mov AX,offset A218310da
   call near B21830905
ret near

B2183146c:
   mov BX,0008
   mov DX,[0010]
   mov AX,[000E]
   call near B21830905
   mov BX,0009
   mov DX,[0014]
   mov AX,[0012]
   call near B21830905
ret near

B21831487:
   call near B21831398
   call near B21831355
   jb L2183149a
   call near B2183140d
   call near B2183143b
   mov AX,0001
jmp near L2183149c
L2183149a:
   sub AX,AX
L2183149c:
ret near

B2183149d:
   call near B21831198
   call near B2183146c
   sub AX,AX
ret near

B218314a6:
   mov [0009],AX
   sub AX,AX
ret near

;; === Compiler Library Modules ===
Segment 22cd ;; IOERROR
A22cd000c:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   or SI,SI
   jl L22cd002b
   cmp SI,+58
   jbe L22cd001f
L22cd001c:
   mov SI,0057
L22cd001f:
   mov [2678],SI
   mov AL,[SI+267A]
   cbw
   xchg SI,AX
jmp near L22cd0038
L22cd002b:
   neg SI
   cmp SI,+23
   ja L22cd001c
   mov word ptr [2678],FFFF
L22cd0038:
   mov AX,SI
   mov [007F],AX
   mov AX,FFFF
jmp near L22cd0042
L22cd0042:
   pop SI
   pop BP
ret far 0002

Segment 22d1 ;; EXIT, SETARGV, SETENVP
A22d10007:
ret far

A22d10008:
   push BP
   mov BP,SP
jmp near L22d10019
L22d1000d:
   mov BX,[26E0]
   shl BX,1
   shl BX,1
   call far [BX+BCAC]
L22d10019:
   mov AX,[26E0]
   dec word ptr [26E0]
   or AX,AX
   jnz L22d1000d
   call far [26D4]
   call far [26D8]
   call far [26DC]
   push [BP+06]
   call far A076a010d
   pop CX
   pop BP
ret far

Segment 22d4 ;; ATEXIT
X22d4000b:
   push BP
   mov BP,SP
   cmp word ptr [26E0],+20
   jnz L22d4001a
   mov AX,0001
jmp near L22d40038
L22d4001a:
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov BX,[26E0]
   shl BX,1
   shl BX,1
   mov [BX+BCAE],DX
   mov [BX+BCAC],AX
   inc word ptr [26E0]
   xor AX,AX
jmp near L22d40038
L22d40038:
   pop BP
ret far

Segment 22d7 ;; FMALLOC
A22d7000a:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   xor DX,DX
   push DX
   push AX
   call far A22d7020b
   mov SP,BP
jmp near L22d7001d
L22d7001d:
   pop BP
ret far

A22d7001f:
   push BP
   mov BP,SP
   sub SP,+04
   les BX,[BP+06]
   mov DX,[ES:BX+0E]
   mov AX,[ES:BX+0C]
   mov [26EC],DX
   mov [26EA],AX
   mov CX,[BP+08]
   mov BX,[BP+06]
   call far A076a036f
   jnz L22d70052
   mov word ptr [26EC],0000
   mov word ptr [26EA],0000
jmp near L22d70083
L22d70052:
   les BX,[BP+06]
   les BX,[ES:BX+08]
   mov [BP-02],ES
   mov [BP-04],BX
   mov DX,[BP-02]
   mov AX,[BP-04]
   les BX,[26EA]
   mov [ES:BX+0A],DX
   mov [ES:BX+08],AX
   mov DX,[26EC]
   mov AX,[26EA]
   les BX,[BP-04]
   mov [ES:BX+0E],DX
   mov [ES:BX+0C],AX
L22d70083:
   mov SP,BP
   pop BP
ret far

A22d70087:
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
   call far A076a0314
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
   mov DX,[26E8]
   mov AX,[26E6]
   call far A076a036f
   jnz L22d70100
   les BX,[BP-04]
   mov [26E8],ES
   mov [26E6],BX
jmp near L22d70128
L22d70100:
   mov DX,[BP-02]
   mov AX,[BP-04]
   mov CX,[BP+0C]
   mov BX,[BP+0A]
   call far A076a0314
   mov [BP+08],DX
   mov [BP+06],AX
   mov DX,[BP-02]
   mov AX,[BP-04]
   les BX,[BP+06]
   mov [ES:BX+06],DX
   mov [ES:BX+04],AX
L22d70128:
   mov DX,[BP-02]
   mov AX,[BP-04]
   add AX,0008
jmp near L22d70133
L22d70133:
   mov SP,BP
   pop BP
ret far

A22d70137:
   push BP
   mov BP,SP
   sub SP,+04
   push [BP+08]
   push [BP+06]
   call far A230800e1
   pop CX
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   cmp word ptr [BP-02],-01
   jnz L22d70162
   cmp word ptr [BP-04],-01
   jnz L22d70162
   xor DX,DX
   xor AX,AX
jmp near L22d701a1
L22d70162:
   mov DX,[26E8]
   mov AX,[26E6]
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
   mov [26E8],ES
   mov [26E6],BX
   mov DX,[26E8]
   mov AX,[26E6]
   add AX,0008
jmp near L22d701a1
L22d701a1:
   mov SP,BP
   pop BP
ret far

A22d701a5:
   push BP
   mov BP,SP
   sub SP,+04
   push [BP+08]
   push [BP+06]
   call far A230800e1
   pop CX
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   cmp word ptr [BP-02],-01
   jnz L22d701d0
   cmp word ptr [BP-04],-01
   jnz L22d701d0
   xor DX,DX
   xor AX,AX
jmp near L22d70207
L22d701d0:
   les BX,[BP-04]
   mov [26E4],ES
   mov [26E2],BX
   les BX,[BP-04]
   mov [26E8],ES
   mov [26E6],BX
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
jmp near L22d70207
L22d70207:
   mov SP,BP
   pop BP
ret far

A22d7020b:
   push BP
   mov BP,SP
   sub SP,+04
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L22d70220
   xor DX,DX
   xor AX,AX
jmp near L22d70316
L22d70220:
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
   mov DX,[26E4]
   mov AX,[26E2]
   call far A076a036f
   jnz L22d7025a
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A22d701a5
   pop CX
   pop CX
jmp near L22d70316
L22d7025a:
   mov DX,[26EC]
   mov AX,[26EA]
   mov [BP-02],DX
   mov [BP-04],AX
   xor CX,CX
   xor BX,BX
   call far A076a036f
   jnz L22d70275
jmp near L22d70308
L22d70275:
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   mov CX,[BP+08]
   mov BX,[BP+06]
   add BX,+30
   adc CX,+00
   cmp DX,CX
   jb L22d702aa
   jnz L22d70295
   cmp AX,BX
   jb L22d702aa
L22d70295:
   push [BP+08]
   push [BP+06]
   push [BP-02]
   push [BP-04]
   push CS
   call near offset A22d70087
   add SP,+08
jmp near L22d70316
L22d702aa:
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   cmp DX,[BP+08]
   jb L22d702e3
   jnz L22d702c0
   cmp AX,[BP+06]
   jb L22d702e3
L22d702c0:
   push [BP-02]
   push [BP-04]
   push CS
   call near offset A22d7001f
   pop CX
   pop CX
   les BX,[BP-04]
   add word ptr [ES:BX],+01
   adc word ptr [ES:BX+02],+00
   mov DX,[BP-02]
   mov AX,[BP-04]
   add AX,0008
jmp near L22d70316
L22d702e3:
   les BX,[BP-04]
   les BX,[ES:BX+0C]
   mov [BP-02],ES
   mov [BP-04],BX
   mov CX,[26EC]
   mov BX,[26EA]
   mov DX,[BP-02]
   mov AX,[BP-04]
   call far A076a036f
   jz L22d70308
jmp near L22d70275
L22d70308:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A22d70137
   pop CX
   pop CX
jmp near L22d70316
L22d70316:
   mov SP,BP
   pop BP
ret far

Segment 2308 ;; FBRK, PADD, PCMP
B2308000a:
   push BP
   mov BP,SP
   push SI
   push DI
   mov SI,[BP+06]
   inc SI
   sub SI,[007B]
   mov AX,SI
   add AX,003F
   mov CL,06
   shr AX,CL
   mov SI,AX
   cmp SI,[26EE]
   jnz L23080038
   les BX,[BP+04]
   mov [008D],ES
   mov [008B],BX
   mov AX,0001
jmp near L23080094
L23080038:
   mov CL,06
   shl SI,CL
   mov DI,[0091]
   mov AX,SI
   add AX,[007B]
   cmp AX,DI
   jbe L23080050
   mov SI,DI
   sub SI,[007B]
L23080050:
   push SI
   push [007B]
   call far A231d000c
   pop CX
   pop CX
   mov DI,AX
   cmp DI,-01
   jnz L2308007e
   mov AX,SI
   mov CL,06
   shr AX,CL
   mov [26EE],AX
   les BX,[BP+04]
   mov [008D],ES
   mov [008B],BX
   mov AX,0001
jmp near L23080094
X2308007c:
jmp near L23080094
L2308007e:
   mov AX,[007B]
   add AX,DI
   xor DX,DX
   mov DX,AX
   xor AX,AX
   mov [0091],DX
   mov [008F],AX
   xor AX,AX
jmp near L23080094
L23080094:
   pop DI
   pop SI
   pop BP
ret near 0004

A2308009a:
   push BP
   mov BP,SP
   mov CX,[0089]
   mov BX,[0087]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far A076a036f
   jb L230800d4
   mov CX,[0091]
   mov BX,[008F]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far A076a036f
   ja L230800d4
   push [BP+08]
   push [BP+06]
   call near B2308000a
   or AX,AX
   jnz L230800db
L230800d4:
   mov AX,FFFF
jmp near L230800df
X230800d9:
jmp near L230800df
L230800db:
   xor AX,AX
jmp near L230800df
L230800df:
   pop BP
ret far

A230800e1:
   push BP
   mov BP,SP
   sub SP,+08
   mov DX,[008D]
   mov AX,[008B]
   mov CX,[BP+08]
   mov BX,[BP+06]
   call far A076a0314
   mov [BP-06],DX
   mov [BP-08],AX
   mov CX,[0089]
   mov BX,[0087]
   mov DX,[BP-06]
   mov AX,[BP-08]
   call far A076a036f
   jb L23080129
   mov CX,[0091]
   mov BX,[008F]
   mov DX,[BP-06]
   mov AX,[BP-08]
   call far A076a036f
   jbe L23080131
L23080129:
   mov DX,FFFF
   mov AX,FFFF
jmp near L23080158
L23080131:
   les BX,[008B]
   mov [BP-02],ES
   mov [BP-04],BX
   push [BP-06]
   push [BP-08]
   call near B2308000a
   or AX,AX
   jnz L23080150
   mov DX,FFFF
   mov AX,FFFF
jmp near L23080158
L23080150:
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L23080158
L23080158:
   mov SP,BP
   pop BP
ret far

Segment 231d ;; SETBLOCK, CTYPE
A231d000c:
   push BP
   mov BP,SP
   mov AH,4A
   mov BX,[BP+08]
   mov ES,[BP+06]
   int 21
   jb L231d0020
   mov AX,FFFF
jmp near L231d002a
L231d0020:
   push BX
   push AX
   call far A22cd000c
   pop AX
jmp near L231d002a
L231d002a:
   pop BP
ret far

Segment 231f ;; OPEN
B231f000c:
   push BP
   mov BP,SP
   push DS
   mov CX,[BP+04]
   mov AH,3C
   lds DX,[BP+06]
   int 21
   pop DS
   jb L231f001f
jmp near L231f0027
L231f001f:
   push AX
   call far A22cd000c
jmp near L231f0027
L231f0027:
   pop BP
ret near 0006

B231f002b:
   push BP
   mov BP,SP
   mov BX,[BP+04]
   sub CX,CX
   sub DX,DX
   mov AH,40
   int 21
jmp near L231f003b
L231f003b:
   pop BP
ret near 0002

A231f003f:
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov DI,[BP+0A]
   test DI,C000
   jnz L231f0058
   mov AX,[281A]
   and AX,C000
   or DI,AX
L231f0058:
   test DI,0100
   jnz L231f0061
jmp near L231f0100
L231f0061:
   mov AX,[281C]
   and [BP+0C],AX
   mov AX,[BP+0C]
   test AX,0180
   jnz L231f0078
   mov AX,0001
   push AX
   call far A22cd000c
L231f0078:
   xor AX,AX
   push AX
   push [BP+08]
   push [BP+06]
   call far A239e0000
   add SP,+06
   mov [BP-04],AX
   cmp AX,FFFF
   jnz L231f00a4
   test word ptr [BP+0C],0080
   jz L231f009c
   xor AX,AX
jmp near L231f009f
L231f009c:
   mov AX,0001
L231f009f:
   mov [BP-04],AX
jmp near L231f00ba
L231f00a4:
   test DI,0400
   jz L231f00b8
   mov AX,0050
   push AX
   call far A22cd000c
jmp near L231f01a6
X231f00b6:
jmp near L231f00ba
L231f00b8:
jmp near L231f0100
L231f00ba:
   test DI,00F0
   jz L231f00e4
   push [BP+08]
   push [BP+06]
   xor AX,AX
   push AX
   call near B231f000c
   mov SI,AX
   mov AX,SI
   or AX,AX
   jge L231f00d9
   mov AX,SI
jmp near L231f01a6
L231f00d9:
   push SI
   call far A23440007
   pop CX
jmp near L231f0105

X231f00e2:
jmp near L231f00fd
L231f00e4:
   push [BP+08]
   push [BP+06]
   push [BP-04]
   call near B231f000c
   mov SI,AX
   mov AX,SI
   or AX,AX
   jge L231f00fd
   mov AX,SI
jmp near L231f01a6
L231f00fd:
jmp near L231f0181
L231f0100:
   mov word ptr [BP-04],0000
L231f0105:
   push DI
   push [BP+08]
   push [BP+06]
   call far A2339000c
   add SP,+06
   mov SI,AX
   mov AX,SI
   or AX,AX
   jl L231f0181
   xor AX,AX
   push AX
   push SI
   call far A233e0009
   pop CX
   pop CX
   mov [BP-02],AX
   test AX,0080
   jz L231f0155
   or DI,2000
   test DI,8000
   jz L231f0153
   mov AX,[BP-02]
   and AX,00FF
   or AX,0020
   xor DX,DX
   push DX
   push AX
   mov AX,0001
   push AX
   push SI
   call far A233e0009
   add SP,+08
L231f0153:
jmp near L231f015f
L231f0155:
   test DI,0200
   jz L231f015f
   push SI
   call near B231f002b
L231f015f:
   cmp word ptr [BP-04],+00
   jz L231f0181
   test DI,00F0
   jz L231f0181
   mov AX,0001
   push AX
   mov AX,0001
   push AX
   push [BP+08]
   push [BP+06]
   call far A239e0000
   add SP,+08
L231f0181:
   or SI,SI
   jl L231f01a2
   test DI,0300
   jz L231f0190
   mov AX,1000
jmp near L231f0192
L231f0190:
   xor AX,AX
L231f0192:
   mov DX,DI
   and DX,F8FF
   or AX,DX
   mov BX,SI
   shl BX,1
   mov [BX+27F2],AX
L231f01a2:
   mov AX,SI
jmp near L231f01a6
L231f01a6:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 2339 ;; OPENA, FILES2, FMODE
A2339000c:
   push BP
   mov BP,SP
   push SI
   mov AL,01
   mov CX,[BP+0A]
   test CX,0002
   jnz L23390025
   mov AL,02
   test CX,0004
   jnz L23390025
   mov AL,00
L23390025:
   push DS
   lds DX,[BP+06]
   mov CL,F0
   and CL,[BP+0A]
   or AL,CL
   mov AH,3D
   int 21
   pop DS
   jb L2339004e
   mov SI,AX
   mov AX,[BP+0A]
   and AX,F8FF
   or AX,8000
   mov BX,SI
   shl BX,1
   mov [BX+27F2],AX
   mov AX,SI
jmp near L23390056
L2339004e:
   push AX
   call far A22cd000c
jmp near L23390056
L23390056:
   pop SI
   pop BP
ret far

Segment 233e ;; IOCTL
A233e0009:
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
   jb L233e002c
   cmp word ptr [BP+08],+00
   jnz L233e002a
   mov AX,DX
jmp near L233e0034
L233e002a:
jmp near L233e0034
L233e002c:
   push AX
   call far A22cd000c
jmp near L233e0034
L233e0034:
   pop BP
ret far

Segment 2341 ;; CLOSE
A23410006:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   or SI,SI
   jl L23410016
   cmp SI,+14
   jl L23410021
L23410016:
   mov AX,0006
   push AX
   call far A22cd000c
jmp near L23410034
L23410021:
   mov BX,SI
   shl BX,1
   mov word ptr [BX+27F2],FFFF
   push SI
   call far A23440007
   pop CX
jmp near L23410034
L23410034:
   pop SI
   pop BP
ret far

Segment 2344 ;; CLOSEA
A23440007:
   push BP
   mov BP,SP
   push SI
   mov SI,[BP+06]
   mov AH,3E
   mov BX,SI
   int 21
   jb L23440022
   shl BX,1
   mov word ptr [BX+27F2],FFFF
   xor AX,AX
jmp near L2344002a
L23440022:
   push AX
   call far A22cd000c
jmp near L2344002a
L2344002a:
   pop SI
   pop BP
ret far

Segment 2346 ;; READ
A2346000d:
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push DI
   mov AX,[BP+0C]
   inc AX
   cmp AX,0002
   jb L2346002b
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+27F2],0200
   jz L23460030
L2346002b:
   xor AX,AX
jmp near L234600cc
L23460030:
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far A23530002
   add SP,+08
   mov [BP-04],AX
   mov AX,[BP-04]
   inc AX
   cmp AX,0002
   jb L2346005d
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+27F2],8000
   jz L23460063
L2346005d:
   mov AX,[BP-04]
jmp near L234600cc
X23460062:
   nop
L23460063:
   mov CX,[BP-04]
   les SI,[BP+08]
   mov DI,SI
   mov BX,SI
   cld
L2346006e:
   ES:lodsb
   cmp AL,1A
   jz L234600a4
   cmp AL,0D
   jz L2346007d
   stosb
   loop L2346006e
jmp near L2346009c
L2346007d:
   loop L2346006e
   push ES
   push BX
   mov AX,0001
   push AX
   lea AX,[BP-01]
   push SS
   push AX
   push [BP+06]
   call far A23530002
   add SP,+08
   pop BX
   pop ES
   cld
   mov AL,[BP-01]
   stosb
L2346009c:
   cmp DI,BX
   jnz L234600a2
jmp near L23460030
L234600a2:
jmp near L234600c6
L234600a4:
   push BX
   mov AX,0002
   push AX
   neg CX
   sbb AX,AX
   push AX
   push CX
   push [BP+06]
   call far A23700004
   add SP,+08
   mov BX,[BP+06]
   shl BX,1
   or word ptr [BX+27F2],0200
   pop BX
L234600c6:
   mov AX,DI
   sub AX,BX
jmp near L234600cc
L234600cc:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 2353 ;; READA
A23530002:
   push BP
   mov BP,SP
   push DS
   mov AH,3F
   mov BX,[BP+06]
   mov CX,[BP+0C]
   lds DX,[BP+08]
   int 21
   pop DS
   jb L23530018
jmp near L23530020
L23530018:
   push AX
   call far A22cd000c
jmp near L23530020
L23530020:
   pop BP
ret far

Segment 2355 ;; WRITE
A23550002:
   push BP
   mov BP,SP
   sub SP,008E
   push SI
   push DI
   mov AX,[BP+0C]
   inc AX
   cmp AX,0002
   jnb L23550019
   xor AX,AX
jmp near L23550162
L23550019:
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+27F2],8000
   jz L2355003d
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far A236b0008
   add SP,+08
jmp near L23550162
L2355003d:
   mov BX,[BP+06]
   shl BX,1
   and word ptr [BX+27F2],FDFF
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
jmp near L2355010e
L2355006d:
   dec word ptr [BP+FF76]
   les BX,[BP+FF7A]
   inc word ptr [BP+FF7A]
   mov AL,[ES:BX]
   mov [BP+FF79],AL
   cmp AL,0A
   jnz L23550090
   les BX,[BP+FF72]
   mov byte ptr [ES:BX],0D
   inc word ptr [BP+FF72]
L23550090:
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
   jl L2355010e
   jnz L235500bb
   cmp AX,0080
   jb L2355010e
L235500bb:
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
   call far A236b0008
   add SP,+08
   mov DI,AX
   mov AX,DI
   cmp AX,SI
   jz L235500fe
   or DI,DI
   jnb L235500f1
   mov AX,FFFF
jmp near L235500fc
L235500f1:
   mov AX,[BP+0C]
   sub AX,[BP+FF76]
   add AX,DI
   sub AX,SI
L235500fc:
jmp near L23550162
L235500fe:
   mov BX,SS
   mov ES,BX
   lea BX,[BP+FF7E]
   mov [BP+FF74],ES
   mov [BP+FF72],BX
L2355010e:
   cmp word ptr [BP+FF76],+00
   jz L23550118
jmp near L2355006d
L23550118:
   mov AX,[BP+FF72]
   mov CX,SS
   lea BX,[BP+FF7E]
   xor DX,DX
   sub AX,BX
   sbb DX,+00
   mov SI,AX
   mov AX,SI
   or AX,AX
   jbe L2355015d
   push SI
   push SS
   lea AX,[BP+FF7E]
   push AX
   push [BP+06]
   call far A236b0008
   add SP,+08
   mov DI,AX
   mov AX,DI
   cmp AX,SI
   jz L2355015d
   or DI,DI
   jnb L23550154
   mov AX,FFFF
jmp near L2355015b
L23550154:
   mov AX,[BP+0C]
   add AX,DI
   sub AX,SI
L2355015b:
jmp near L23550162
L2355015d:
   mov AX,[BP+0C]
jmp near L23550162
L23550162:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 236b ;; WRITEA
A236b0008:
   push BP
   mov BP,SP
   mov BX,[BP+06]
   shl BX,1
   test word ptr [BX+27F2],0800
   jz L236b002a
   mov AX,0002
   push AX
   xor AX,AX
   push AX
   push AX
   push [BP+06]
   call far A23700004
   mov SP,BP
L236b002a:
   push DS
   mov AH,40
   mov BX,[BP+06]
   mov CX,[BP+0C]
   lds DX,[BP+08]
   int 21
   pop DS
   jb L236b004a
   push AX
   mov BX,[BP+06]
   shl BX,1
   or word ptr [BX+27F2],1000
   pop AX
jmp near L236b0052
L236b004a:
   push AX
   call far A22cd000c
jmp near L236b0052
L236b0052:
   pop BP
ret far

Segment 2370 ;; LSEEK
A23700004:
   push BP
   mov BP,SP
   mov BX,[BP+06]
   shl BX,1
   and word ptr [BX+27F2],FDFF
   mov AH,42
   mov AL,[BP+0C]
   mov BX,[BP+06]
   mov CX,[BP+0A]
   mov DX,[BP+08]
   int 21
   jb L23700026
jmp near L2370002f
L23700026:
   push AX
   call far A22cd000c
   cwd
jmp near L2370002f
L2370002f:
   pop BP
ret far

Segment 2373 ;; LTOA, LXMUL
A23730001:
   push BP
   mov BP,SP
   sub SP,+22
   push SI
   push DI
   push ES
   les DI,[BP+0C]
   mov BX,[BP+0A]
   cmp BX,+24
   ja L23730071
   cmp BL,02
   jb L23730071
   mov AX,[BP+10]
   mov CX,[BP+12]
   or CX,CX
   jge L23730036
   cmp byte ptr [BP+08],00
   jz L23730036
   mov byte ptr [ES:DI],2D
   inc DI
   neg CX
   neg AX
   sbb CX,+00
L23730036:
   lea SI,[BP-22]
   jcxz L2373004b
L2373003b:
   xchg CX,AX
   sub DX,DX
   div BX
   xchg CX,AX
   div BX
   mov [SS:SI],DL
   inc SI
   jcxz L23730053
jmp near L2373003b
L2373004b:
   sub DX,DX
   div BX
   mov [SS:SI],DL
   inc SI
L23730053:
   or AX,AX
   jnz L2373004b
   lea CX,[BP-22]
   neg CX
   add CX,SI
   cld
L2373005f:
   dec SI
   mov AL,[SS:SI]
   sub AL,0A
   jnb L2373006b
   add AL,3A
jmp near L2373006e
L2373006b:
   add AL,[BP+06]
L2373006e:
   stosb
   loop L2373005f
L23730071:
   mov AL,00
   stosb
   pop ES
   mov DX,[BP+0E]
   mov AX,[BP+0C]
jmp near L2373007d
L2373007d:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far 000E

A23730085:
   push BP
   mov BP,SP
   cmp word ptr [BP+0C],+0A
   jnz L23730094
   mov AX,[BP+06]
   cwd
jmp near L23730099
L23730094:
   mov AX,[BP+06]
   xor DX,DX
L23730099:
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
   call near offset A23730001
jmp near L237300b0
L237300b0:
   pop BP
ret far

X237300b2:
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
   call near offset A23730001
jmp near L237300d0
L237300d0:
   pop BP
ret far

A237300d2:
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0C]
   push [BP+0A]
   push [BP+0E]
   cmp word ptr [BP+0E],+0A
   jnz L237300ef
   mov AX,0001
jmp near L237300f1
L237300ef:
   xor AX,AX
L237300f1:
   push AX
   mov AL,61
   push AX
   push CS
   call near offset A23730001
jmp near L237300fb
L237300fb:
   pop BP
ret far

Segment 2382 ;; UNLINK
A2382000d:
   push BP
   mov BP,SP
   push DS
   mov AH,41
   lds DX,[BP+06]
   int 21
   pop DS
   jb L2382001f
   xor AX,AX
jmp near L23820027
L2382001f:
   push AX
   call far A22cd000c
jmp near L23820027
L23820027:
   pop BP
ret far

Segment 2384 ;; STRCAT
A23840009:
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
   jz L23840039
   movsb
   dec CX
L23840039:
   shr CX,1
   repz movsw
   jnb L23840040
   movsb
L23840040:
   mov AX,DX
   mov DX,ES
   pop DS
jmp near L23840047
L23840047:
   pop DI
   pop SI
   pop BP
ret far

Segment 2388 ;; STRLEN
A2388000b:
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
jmp near L23880022
L23880022:
   pop DI
   pop SI
   pop BP
ret far

Segment 238a ;; STRCMP
A238a0006:
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
jmp near L238a0034
L238a0034:
   pop DI
   pop SI
   pop BP
ret far

Segment 238d ;; STRCPY
A238d0008:
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
jmp near L238d002d
L238d002d:
   pop DI
   pop SI
   pop BP
ret far

Segment 2390 ;; MEMCPY
A23900001:
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
   jnb L23900019
   movsb
L23900019:
   mov DS,DX
   mov DX,[BP+08]
   mov AX,[BP+06]
jmp near L23900023
L23900023:
   pop DI
   pop SI
   pop BP
ret far

Segment 2392 ;; MEMSET
A23920007:
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
   jz L23920022
   jcxz L23920029
   stosb
   dec CX
L23920022:
   shr CX,1
   repz stosw
   jnb L23920029
   stosb
L23920029:
   pop DI
   pop SI
   pop BP
ret far

A2392002d:
   push BP
   mov BP,SP
   push [BP+0A]
   push [BP+0C]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A23920007
   mov SP,BP
   mov DX,[BP+08]
   mov AX,[BP+06]
jmp near L2392004a
L2392004a:
   pop BP
ret far

Segment 2396 ;; MOVMEM
A2396000c:
   push BP
   mov BP,SP
   push SI
   push DI
   push DS
   mov CX,[BP+0C]
   mov BX,[BP+0A]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far A076a036f
   jnb L2396002b
   std
   mov AX,0001
jmp near L2396002e
L2396002b:
   cld
   xor AX,AX
L2396002e:
   lds SI,[BP+06]
   les DI,[BP+0A]
   mov CX,[BP+0E]
   or AX,AX
   jz L23960041
   add SI,CX
   dec SI
   add DI,CX
   dec DI
L23960041:
   test DI,0001
   jz L2396004b
   jcxz L2396005a
   movsb
   dec CX
L2396004b:
   sub SI,AX
   sub DI,AX
   shr CX,1
   repz movsw
   jnb L2396005a
   add SI,AX
   add DI,AX
   movsb
L2396005a:
   cld
   pop DS
   pop DI
   pop SI
   pop BP
ret far

A23960060:
   push BP
   mov BP,SP
   push [BP+0E]
   push [BP+08]
   push [BP+06]
   push [BP+0C]
   push [BP+0A]
   push CS
   call near offset A2396000c
   mov SP,BP
   mov DX,[BP+08]
   mov AX,[BP+06]
   pop BP
ret far

Segment 239e ;; CHMODA, CVTFAK, REALCVT
A239e0000:
   push BP
   mov BP,SP
   push DS
   mov AH,43
   mov AL,[BP+0A]
   mov CX,[BP+0C]
   lds DX,[BP+06]
   int 21
   pop DS
   jb L239e0017
   xchg CX,AX
jmp near L239e001f
L239e0017:
   push AX
   call far A22cd000c
jmp near L239e001f
L239e001f:
   pop BP
ret far

Segment 23a0 ;; VPRINTER
B23a00001:
   push BP
   mov BP,SP
   mov DX,[BP+04]
   mov CX,0F04
   mov BX,2857
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
jmp near L23a00028
L23a00028:
   pop BP
ret near 0002

A23a0002c:
   push BP
   mov BP,SP
   sub SP,0096
   push SI
   push DI
   mov word ptr [BP-56],0000
   mov byte ptr [BP-53],50
jmp near L23a0007d

B23a00040:
   push DI
   mov CX,FFFF
   xor AL,AL
   repnz scasb
   not CX
   dec CX
   pop DI
ret near

B23a0004d:
   mov [SS:DI],AL
   inc DI
   dec byte ptr [BP-53]
   jle L23a0007c

B23a00056:
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
L23a0007c:
ret near

L23a0007d:
   push ES
   cld
   lea DI,[BP-52]
   mov [BP+FF6C],DI
L23a00086:
   mov DI,[BP+FF6C]
L23a0008a:
   les SI,[BP+0A]
L23a0008d:
   ES:lodsb
   or AL,AL
   jz L23a000a5
   cmp AL,25
   jz L23a000a8
L23a00097:
   mov [SS:DI],AL
   inc DI
   dec byte ptr [BP-53]
   jg L23a0008d
   call near B23a00056
jmp near L23a0008d
L23a000a5:
jmp near L23a0053c
L23a000a8:
   mov [BP+FF78],SI
   ES:lodsb
   cmp AL,25
   jz L23a00097
   mov [BP+FF6C],DI
   xor CX,CX
   mov [BP+FF76],CX
   mov word ptr [BP+FF6A],0020
   mov [BP+FF75],CL
   mov word ptr [BP+FF70],FFFF
   mov word ptr [BP+FF72],FFFF
jmp near L23a000d6
L23a000d4:
   ES:lodsb
L23a000d6:
   xor AH,AH
   mov DX,AX
   mov BX,AX
   sub BL,20
   cmp BL,60
   jnb L23a0012b
   mov BL,[BX+2867]
   mov AX,BX
   cmp AX,0017
   jbe L23a000f2
jmp near L23a00526
L23a000f2:
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y23a000fb]
Y23a000fb:	dw L23a00146,L23a0012e,L23a00187,L23a0013a,L23a001af,L23a001b9,L23a001fb,L23a00205
		dw L23a00215,L23a0016d,L23a0024b,L23a00225,L23a00229,L23a0022d,L23a002d5,L23a0038e
		dw L23a0032b,L23a0034d,L23a004f7,L23a00526,L23a00526,L23a00526,L23a00159,L23a00163
L23a0012b:
jmp near L23a00526
L23a0012e:
   cmp CH,00
   ja L23a0012b
   or word ptr [BP+FF6A],+01
jmp near L23a000d4
L23a0013a:
   cmp CH,00
   ja L23a0012b
   or word ptr [BP+FF6A],+02
jmp near L23a000d4
L23a00146:
   cmp CH,00
   ja L23a0012b
   cmp byte ptr [BP+FF75],2B
   jz L23a00156
   mov [BP+FF75],DL
L23a00156:
jmp near L23a000d4
L23a00159:
   and word ptr [BP+FF6A],-21
   mov CH,05
jmp near L23a000d4
L23a00163:
   or word ptr [BP+FF6A],+20
   mov CH,05
jmp near L23a000d4
L23a0016d:
   cmp CH,00
   ja L23a001b9
   test word ptr [BP+FF6A],0002
   jnz L23a0019e
   or word ptr [BP+FF6A],+08
   mov CH,01
jmp near L23a000d4
L23a00184:
jmp near L23a00526
L23a00187:
   push ES
   les DI,[BP+06]
   mov AX,[ES:DI]
   add word ptr [BP+06],+02
   pop ES
   cmp CH,02
   jnb L23a001a1
   mov [BP+FF70],AX
   mov CH,03
L23a0019e:
jmp near L23a000d4
L23a001a1:
   cmp CH,04
   jnz L23a00184
   mov [BP+FF72],AX
   inc CH
jmp near L23a000d4
L23a001af:
   cmp CH,04
   jnb L23a00184
   mov CH,04
jmp near L23a000d4
L23a001b9:
   xchg DX,AX
   sub AL,30
   cbw
   cmp CH,02
   ja L23a001dd
   mov CH,02
   xchg AX,[BP+FF70]
   or AX,AX
   jl L23a0019e
   shl AX,1
   mov DX,AX
   shl AX,1
   shl AX,1
   add AX,DX
   add [BP+FF70],AX
jmp near L23a000d4
L23a001dd:
   cmp CH,04
   jnz L23a00184
   xchg AX,[BP+FF72]
   or AX,AX
   jl L23a0019e
   shl AX,1
   mov DX,AX
   shl AX,1
   shl AX,1
   add AX,DX
   add [BP+FF72],AX
jmp near L23a000d4
L23a001fb:
   or word ptr [BP+FF6A],+10
   mov CH,05
jmp near L23a000d4
L23a00205:
   or word ptr [BP+FF6A],0100
   and word ptr [BP+FF6A],-11
   mov CH,05
jmp near L23a000d4
L23a00215:
   and word ptr [BP+FF6A],-11
   or word ptr [BP+FF6A],0080
   mov CH,05
jmp near L23a000d4
L23a00225:
   mov BH,08
jmp near L23a00233
L23a00229:
   mov BH,0A
jmp near L23a00238
L23a0022d:
   mov BH,10
   mov BL,E9
   add BL,DL
L23a00233:
   mov byte ptr [BP+FF75],00
L23a00238:
   mov byte ptr [BP+FF6F],00
   mov [BP+FF6E],DL
   les DI,[BP+06]
   mov AX,[ES:DI]
   xor DX,DX
jmp near L23a0025d
L23a0024b:
   mov BH,0A
   mov byte ptr [BP+FF6F],01
   mov [BP+FF6E],DL
   les DI,[BP+06]
   mov AX,[ES:DI]
   cwd
L23a0025d:
   inc DI
   inc DI
   mov [BP+0A],SI
   test word ptr [BP+FF6A],0010
   jz L23a0026f
   mov DX,[ES:DI]
   inc DI
   inc DI
L23a0026f:
   mov [BP+06],DI
   lea DI,[BP+FF7B]
   or AX,AX
   jnz L23a002ad
   or DX,DX
   jnz L23a002ad
   cmp word ptr [BP+FF72],+00
   jnz L23a002b2
   mov DI,[BP+FF6C]
   mov CX,[BP+FF70]
   jcxz L23a002aa
   cmp CX,-01
   jz L23a002aa
   mov AX,[BP+FF6A]
   and AX,0008
   jz L23a002a1
   mov DL,30
jmp near L23a002a3
L23a002a1:
   mov DL,20
L23a002a3:
   mov AL,DL
   call near B23a0004d
   loop L23a002a3
L23a002aa:
jmp near L23a0008a
L23a002ad:
   or word ptr [BP+FF6A],+04
L23a002b2:
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
   call far A23730001
   push SS
   pop ES
   mov DX,[BP+FF72]
   or DX,DX
   jg L23a002d2
jmp near L23a003f1
L23a002d2:
jmp near L23a00401
L23a002d5:
   mov [BP+FF6E],DL
   mov [BP+0A],SI
   lea DI,[BP+FF7A]
   les BX,[BP+06]
   push [ES:BX]
   inc BX
   inc BX
   mov [BP+06],BX
   test word ptr [BP+FF6A],0020
   jz L23a00303
   push [ES:BX]
   inc BX
   inc BX
   mov [BP+06],BX
   push SS
   pop ES
   call near B23a00001
   mov AL,3A
   stosb
L23a00303:
   push SS
   pop ES
   call near B23a00001
   mov byte ptr [SS:DI],00
   mov byte ptr [BP+FF6F],00
   and word ptr [BP+FF6A],-05
   lea CX,[BP+FF7A]
   sub DI,CX
   xchg CX,DI
   mov DX,[BP+FF72]
   cmp DX,CX
   jg L23a00328
   mov DX,CX
L23a00328:
jmp near L23a003f1
L23a0032b:
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
jmp near L23a0042b
L23a0034d:
   mov [BP+0A],SI
   mov [BP+FF6E],DL
   les DI,[BP+06]
   test word ptr [BP+FF6A],0020
   jnz L23a0036c
   mov DI,[ES:DI]
   add word ptr [BP+06],+02
   push DS
   pop ES
   or DI,DI
jmp near L23a00377
L23a0036c:
   les DI,[ES:DI]
   add word ptr [BP+06],+04
   mov AX,ES
   or AX,DI
L23a00377:
   jnz L23a0037e
   push DS
   pop ES
   mov DI,2850
L23a0037e:
   call near B23a00040
   cmp CX,[BP+FF72]
   jbe L23a0038b
   mov CX,[BP+FF72]
L23a0038b:
jmp near L23a0042b
L23a0038e:
   mov [BP+0A],SI
   mov [BP+FF6E],DL
   les DI,[BP+06]
   mov CX,[BP+FF72]
   or CX,CX
   jge L23a003a3
   mov CX,0006
L23a003a3:
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
   jz L23a003c8
   mov AX,0002
   mov word ptr [BP-02],0004
jmp near L23a003df
L23a003c8:
   test AX,0100
   jz L23a003d7
   mov AX,0008
   mov word ptr [BP-02],000A
jmp near L23a003df
L23a003d7:
   mov word ptr [BP-02],0008
   mov AX,0006
L23a003df:
   push AX
   call far A076a03cc
   mov AX,[BP-02]
   add [BP+06],AX
   push SS
   pop ES
   lea DI,[BP+FF7B]
L23a003f1:
   test word ptr [BP+FF6A],0008
   jz L23a0040c
   mov DX,[BP+FF70]
   or DX,DX
   jle L23a0040c
L23a00401:
   call near B23a00040
   sub DX,CX
   jle L23a0040c
   mov [BP+FF76],DX
L23a0040c:
   mov AL,[BP+FF75]
   or AL,AL
   jz L23a00428
   cmp byte ptr [ES:DI],2D
   jz L23a00428
   sub word ptr [BP+FF76],+01
   adc word ptr [BP+FF76],+00
   dec DI
   mov [ES:DI],AL
L23a00428:
   call near B23a00040
L23a0042b:
   mov SI,DI
   mov DI,[BP+FF6C]
   mov BX,[BP+FF70]
   mov AX,0005
   and AX,[BP+FF6A]
   cmp AX,0005
   jnz L23a00457
   mov AH,[BP+FF6E]
   cmp AH,6F
   jnz L23a0045a
   cmp word ptr [BP+FF76],+00
   jg L23a00457
   mov word ptr [BP+FF76],0001
L23a00457:
jmp near L23a00478
X23a00459:
   nop
L23a0045a:
   cmp AH,78
   jz L23a00464
   cmp AH,58
   jnz L23a00478
L23a00464:
   or word ptr [BP+FF6A],+40
   dec BX
   dec BX
   sub word ptr [BP+FF76],+02
   jge L23a00478
   mov word ptr [BP+FF76],0000
L23a00478:
   add CX,[BP+FF76]
   test word ptr [BP+FF6A],0002
   jnz L23a00490
jmp near L23a0048c
L23a00486:
   mov AL,20
   call near B23a0004d
   dec BX
L23a0048c:
   cmp BX,CX
   jg L23a00486
L23a00490:
   test word ptr [BP+FF6A],0040
   jz L23a004a4
   mov AL,30
   call near B23a0004d
   mov AL,[BP+FF6E]
   call near B23a0004d
L23a004a4:
   mov DX,[BP+FF76]
   or DX,DX
   jle L23a004d3
   sub CX,DX
   sub BX,DX
   mov AL,[ES:SI]
   cmp AL,2D
   jz L23a004bf
   cmp AL,20
   jz L23a004bf
   cmp AL,2B
   jnz L23a004c6
L23a004bf:
   ES:lodsb
   call near B23a0004d
   dec CX
   dec BX
L23a004c6:
   xchg CX,DX
   jcxz L23a004d1
L23a004ca:
   mov AL,30
   call near B23a0004d
   loop L23a004ca
L23a004d1:
   xchg CX,DX
L23a004d3:
   jcxz L23a004e7
   sub BX,CX
L23a004d7:
   ES:lodsb
   mov [SS:DI],AL
   inc DI
   dec byte ptr [BP-53]
   jg L23a004e5
   call near B23a00056
L23a004e5:
   loop L23a004d7
L23a004e7:
   or BX,BX
   jle L23a004f4
   mov CX,BX
L23a004ed:
   mov AL,20
   call near B23a0004d
   loop L23a004ed
L23a004f4:
jmp near L23a0008a
L23a004f7:
   mov [BP+0A],SI
   les DI,[BP+06]
   test word ptr [BP+FF6A],0020
   jnz L23a00510
   mov DI,[ES:DI]
   add word ptr [BP+06],+02
   push DS
   pop ES
jmp near L23a00517
L23a00510:
   les DI,[ES:DI]
   add word ptr [BP+06],+04
L23a00517:
   mov AX,0050
   sub AL,[BP-53]
   add AX,[BP-56]
   mov [ES:DI],AX
jmp near L23a00086
L23a00526:
   mov SI,[BP+FF78]
   mov ES,[BP+0C]
   mov DI,[BP+FF6C]
   mov AL,25
L23a00533:
   call near B23a0004d
   ES:lodsb
   or AL,AL
   jnz L23a00533
L23a0053c:
   cmp byte ptr [BP-53],50
   jge L23a00545
   call near B23a00056
L23a00545:
   pop ES
   mov AX,[BP-56]
jmp near L23a0054b
L23a0054b:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far 0010

Segment 23f5 ;; CORELEFT, FCORELFT
A23f50003:
   call far A23f5000b
jmp near L23f5000a
L23f5000a:
ret far

A23f5000b:
   mov DX,[0091]
   mov AX,[008F]
   mov CX,[008D]
   mov BX,[008B]
   call far A076a05d5
   add AX,FFF8
   adc DX,-01
jmp near L23f50027
L23f50027:
ret far

Segment 23f7 ;; FFREE
A23f70008:
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   call far A23f702e2
   mov SP,BP
   pop BP
ret far

A23f7001a:
   push BP
   mov BP,SP
   sub SP,+04
   xor CX,CX
   xor BX,BX
   mov DX,[26EC]
   mov AX,[26EA]
   call far A076a036f
   jz L23f70088
   les BX,[26EA]
   les BX,[ES:BX+0C]
   mov [BP-02],ES
   mov [BP-04],BX
   mov DX,[BP+08]
   mov AX,[BP+06]
   les BX,[26EA]
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
   mov DX,[26EC]
   mov AX,[26EA]
   les BX,[BP+06]
   mov [ES:BX+0A],DX
   mov [ES:BX+08],AX
jmp near L23f700b5
L23f70088:
   les BX,[BP+06]
   mov [26EC],ES
   mov [26EA],BX
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
L23f700b5:
   mov SP,BP
   pop BP
ret far

A23f700b9:
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
   mov DX,[26E8]
   mov AX,[26E6]
   call far A076a036f
   jnz L23f700f4
   les BX,[BP+06]
   mov [26E8],ES
   mov [26E6],BX
jmp near L23f70120
L23f700f4:
   les BX,[BP+0A]
   mov CX,[ES:BX+02]
   mov BX,[ES:BX]
   mov DX,[BP+0C]
   mov AX,[BP+0A]
   call far A076a0314
   mov [BP-02],DX
   mov [BP-04],AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   les BX,[BP-04]
   mov [ES:BX+06],DX
   mov [ES:BX+04],AX
L23f70120:
   push [BP+0C]
   push [BP+0A]
   call far A22d7001f
   pop CX
   pop CX
   mov SP,BP
   pop BP
ret far

A23f70131:
   push BP
   mov BP,SP
   sub SP,+04
   mov CX,[26E8]
   mov BX,[26E6]
   mov DX,[26E4]
   mov AX,[26E2]
   call far A076a036f
   jnz L23f70179
   push [26E4]
   push [26E2]
   call far A2308009a
   pop CX
   pop CX
   mov word ptr [26E8],0000
   mov word ptr [26E6],0000
   xor BX,BX
   mov ES,BX
   xor BX,BX
   mov [26E4],ES
   mov [26E2],BX
jmp near L23f70212
L23f70179:
   les BX,[26E6]
   les BX,[ES:BX+04]
   mov [BP-02],ES
   mov [BP-04],BX
   les BX,[BP-04]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   and AX,0001
   and DX,0000
   or DX,AX
   jnz L23f701f8
   push [BP-02]
   push [BP-04]
   call far A22d7001f
   pop CX
   pop CX
   mov CX,[26E4]
   mov BX,[26E2]
   mov DX,[BP-02]
   mov AX,[BP-04]
   call far A076a036f
   jnz L23f701da
   mov word ptr [26E8],0000
   mov word ptr [26E6],0000
   xor BX,BX
   mov ES,BX
   xor BX,BX
   mov [26E4],ES
   mov [26E2],BX
jmp near L23f701e9
L23f701da:
   les BX,[BP-04]
   les BX,[ES:BX+04]
   mov [26E8],ES
   mov [26E6],BX
L23f701e9:
   push [BP-02]
   push [BP-04]
   call far A2308009a
   pop CX
   pop CX
jmp near L23f70212
L23f701f8:
   push [26E8]
   push [26E6]
   call far A2308009a
   pop CX
   pop CX
   les BX,[BP-04]
   mov [26E8],ES
   mov [26E6],BX
L23f70212:
   mov SP,BP
   pop BP
ret far

A23f70216:
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
   call far A076a0314
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
   jnz L23f702aa
   mov CX,[26E4]
   mov BX,[26E2]
   mov DX,[BP+08]
   mov AX,[BP+06]
   call far A076a036f
   jz L23f702aa
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
jmp near L23f702b6
L23f702aa:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A23f7001a
   pop CX
   pop CX
L23f702b6:
   les BX,[BP-08]
   mov DX,[ES:BX+02]
   mov AX,[ES:BX]
   and AX,0001
   and DX,0000
   or DX,AX
   jnz L23f702de
   push [BP-06]
   push [BP-08]
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A23f700b9
   add SP,+08
L23f702de:
   mov SP,BP
   pop BP
ret far

A23f702e2:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,[BP+08]
   jnz L23f702ef
jmp near L23f7032a
L23f702ef:
   mov DX,[BP+08]
   mov AX,[BP+06]
   mov CX,FFFF
   mov BX,FFF8
   call far A076a0314
   mov [BP+08],DX
   mov [BP+06],AX
   mov DX,[BP+08]
   mov AX,[BP+06]
   cmp DX,[26E8]
   jnz L23f7031e
   cmp AX,[26E6]
   jnz L23f7031e
   push CS
   call near offset A23f70131
jmp near L23f7032a
L23f7031e:
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A23f70216
   mov SP,BP
L23f7032a:
   pop BP
ret far

Segment 2429 ;; CREATA
B2429000c:
   push BP
   mov BP,SP
   push SI
   push DS
   mov AH,[BP+06]
   mov CX,[BP+08]
   lds DX,[BP+0A]
   int 21
   pop DS
   jb L24290030
   mov SI,AX
   mov AX,[BP+04]
   mov BX,SI
   shl BX,1
   mov [BX+27F2],AX
   mov AX,SI
jmp near L24290038
L24290030:
   push AX
   call far A22cd000c
jmp near L24290038
L24290038:
   pop SI
   pop BP
ret near 000A

A2429003d:
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0A]
   mov AL,3C
   push AX
   mov AX,8004
   push AX
   call near B2429000c
jmp near L24290055
L24290055:
   pop BP
ret far

X24290057:
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0A]
   mov AL,5A
   push AX
   mov AX,[281A]
   or AX,0004
   push AX
   call near B2429000c
jmp near L24290072
L24290072:
   pop BP
ret far

X24290074:
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+0A]
   mov AL,5B
   push AX
   mov AX,[281A]
   or AX,0004
   push AX
   call near B2429000c
jmp near L2429008f
L2429008f:
   pop BP
ret far

Segment 2432 ;; FLENGTH
A24320001:
   push BP
   mov BP,SP
   sub SP,+04
   mov AX,4201
   mov BX,[BP+06]
   xor CX,CX
   xor DX,DX
   int 21
   jb L24320039
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
   jb L24320039
   mov AX,4200
   int 21
   jb L24320039
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L24320042
L24320039:
   push AX
   call far A22cd000c
   cwd
jmp near L24320042
L24320042:
   mov SP,BP
   pop BP
ret far

Segment 2436 ;; CRTINIT, CLRSCR
A24360006:
   mov AL,06
   push AX
   push [28C8]
   push [28C9]
   push [28CA]
   push [28CB]
   mov AL,00
   push AX
   call far A24970031
   mov DL,[28C8]
   mov DH,[28C9]
   mov AH,02
   mov BH,00
   call far A076a0414
ret far

Segment 2439 ;; COLOR
A24390003:
   push BP
   mov BP,SP
   mov AL,[28CC]
   and AL,70
   mov DL,[BP+06]
   and DL,8F
   or AL,DL
   mov [28CC],AL
   pop BP
ret far

A24390018:
   push BP
   mov BP,SP
   mov AL,[28CC]
   and AL,8F
   mov DL,[BP+06]
   mov CL,04
   shl DL,CL
   and DL,7F
   or AL,DL
   mov [28CC],AL
   pop BP
ret far

X24390031:
   push BP
   mov BP,SP
   mov AL,[BP+06]
   mov [28CC],AL
   pop BP
ret far

X2439003c:
   or byte ptr [28CC],08
ret far

X24390042:
   and byte ptr [28CC],F7
ret far

X24390048:
   mov AL,[28CD]
   mov [28CC],AL
ret far

Segment 243d ;; CPRINTF
A243d000f:
   push BP
   mov BP,SP
   sub SP,+08
   mov byte ptr [BP-03],00
   call far A24e60002
   mov AH,00
   mov [BP-08],AX
   call far A24e60002
   mov CL,08
   shr AX,CL
   mov AH,00
   mov [BP-06],AX
jmp near L243d012d
L243d0034:
   les BX,[BP+0C]
   inc word ptr [BP+0C]
   mov AL,[ES:BX]
   mov [BP-03],AL
   mov AH,00
   sub AX,0007
   cmp AX,0006
   ja L243d0090
   mov BX,AX
   shl BX,1
jmp near [CS:BX+offset Y243d0053]
Y243d0053:	dw L243d0061,L243d0072,L243d0090,L243d008b,L243d0090,L243d0090,L243d0081
L243d0061:
   mov AH,0E
   mov AL,07
   call far A076a0414
   mov AL,[BP-03]
   mov AH,00
jmp near L243d0150
L243d0072:
   mov AL,[28C8]
   mov AH,00
   cmp AX,[BP-08]
   jge L243d007f
   dec word ptr [BP-08]
L243d007f:
jmp near L243d00f0
L243d0081:
   mov AL,[28C8]
   mov AH,00
   mov [BP-08],AX
jmp near L243d00f0
L243d008b:
   inc word ptr [BP-06]
jmp near L243d00f0
L243d0090:
   cmp byte ptr [28D1],00
   jnz L243d00c9
   cmp word ptr [28D7],+00
   jz L243d00c9
   mov AH,[28CC]
   mov AL,[BP-03]
   mov [BP-02],AX
   mov AX,[BP-08]
   inc AX
   push AX
   mov AX,[BP-06]
   inc AX
   push AX
   call far A24dc0001
   push DX
   push AX
   push SS
   lea AX,[BP-02]
   push AX
   mov AX,0001
   push AX
   call far A24dc0026
jmp near L243d00eb
L243d00c9:
   mov DL,[BP-08]
   mov DH,[BP-06]
   mov AH,02
   mov BH,00
   call far A076a0414
   mov BL,[28CC]
   mov AL,[BP-03]
   mov AH,09
   mov BH,00
   mov CX,0001
   call far A076a0414
L243d00eb:
   inc word ptr [BP-08]
jmp near L243d00f0
L243d00f0:
   mov AL,[28CA]
   mov AH,00
   cmp AX,[BP-08]
   jge L243d0105
   mov AL,[28C8]
   mov AH,00
   mov [BP-08],AX
   inc word ptr [BP-06]
L243d0105:
   mov AL,[28CB]
   mov AH,00
   cmp AX,[BP-06]
   jge L243d012d
   mov AL,06
   push AX
   push [28C8]
   push [28C9]
   push [28CA]
   push [28CB]
   mov AL,01
   push AX
   call far A24970031
   dec word ptr [BP-06]
L243d012d:
   mov AX,[BP+0A]
   dec word ptr [BP+0A]
   or AX,AX
   jz L243d013a
jmp near L243d0034
L243d013a:
   mov DL,[BP-08]
   mov DH,[BP-06]
   mov AH,02
   mov BH,00
   call far A076a0414
   mov AL,[BP-03]
   mov AH,00
jmp near L243d0150
L243d0150:
   mov SP,BP
   pop BP
ret far 000A

X243d0156:
   push BP
   mov BP,SP
   push CS
   mov AX,offset A243d000f
   push AX
   xor AX,AX
   push AX
   push AX
   push [BP+08]
   push [BP+06]
   push SS
   lea AX,[BP+0A]
   push AX
   call far A23a0002c
jmp near L243d0174
L243d0174:
   pop BP
ret far

Segment 2454 ;; CPUTS
A24540006:
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push [BP+08]
   push [BP+06]
   call far A2388000b
   pop CX
   pop CX
   push AX
   xor AX,AX
   push AX
   push AX
   call far A243d000f
jmp near L24540028
L24540028:
   pop BP
ret far

Segment 2456 ;; ABS
A2456000a:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   or AX,AX
   jge L24560016
   neg AX
L24560016:
jmp near L24560018
L24560018:
   pop BP
ret far

Segment 2457 ;; ATOL
A2457000a:
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
   mov DI,26F1
L24570020:
   mov BL,[ES:SI]
   inc SI
   test byte ptr [BX+DI],01
   jnz L24570020
   mov BP,0000
   cmp BL,2B
   jz L24570037
   cmp BL,2D
   jnz L2457003b
   inc BP
L24570037:
   mov BL,[ES:SI]
   inc SI
L2457003b:
   cmp BL,39
   ja L2457006f
   sub BL,30
   jb L2457006f
   mul CX
   add AX,BX
   adc DL,DH
   jz L24570037
jmp near L24570061
L2457004f:
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
L24570061:
   mov BL,[ES:SI]
   inc SI
   cmp BL,39
   ja L2457006f
   sub BL,30
   jnb L2457004f
L2457006f:
   dec BP
   jl L24570079
   neg DX
   neg AX
   sbb DX,+00
L24570079:
   pop BP
   pop ES
jmp near L2457007d
L2457007d:
   pop DI
   pop SI
   pop BP
ret far

X24570081:
   push BP
   mov BP,SP
   push [BP+08]
   push [BP+06]
   push CS
   call near offset A2457000a
   mov SP,BP
jmp near L24570092
L24570092:
   pop BP
ret far

Y24570094:	ds 000c

Segment 2461 ;; DELAY
Y24610000:	word

A24610002:
   dec SP
   dec SP
   push BP
   mov BP,SP
   push SI
   push DI
   push DS
   push ES
   mov CX,[BP+08]
   mov AX,[CS:offset Y24610000]
   or AX,AX
   jnz L24610039
   mov AX,0040
   mov ES,AX
   mov BX,[ES:006C]
   call near B2461005d
   sub BX,[ES:006C]
   neg BX
   mov AX,0037
   mul BX
   cmp CX,AX
   jbe L24610051
   sub CX,AX
   mov AX,[CS:offset Y24610000]
L24610039:
   xor BX,BX
   mov ES,BX
   mov DL,[ES:BX]
   jcxz L24610051
L24610042:
   mov SI,CX
   mov CX,AX
L24610046:
   cmp DL,[ES:BX]
   jnz L2461004b
L2461004b:
   loop L24610046
   mov CX,SI
   loop L24610042
L24610051:
   mov AX,[CS:offset Y24610000]
   pop ES
   pop DS
   pop DI
   pop SI
   pop BP
   inc SP
   inc SP
ret far

B2461005d:
   push BX
   push CX
   push DX
   push ES
   mov AX,0040
   mov ES,AX
   mov BX,006C
   mov AL,[ES:BX]
   mov CX,FFFF
L2461006f:
   mov DL,[ES:BX]
   cmp AL,DL
   jz L2461006f
L24610076:
   cmp DL,[ES:BX]
   jnz L2461007d
   loop L24610076
L2461007d:
   neg CX
   dec CX
   mov AX,0037
   xchg CX,AX
   xor DX,DX
   div CX
   mov [CS:offset Y24610000],AX
L2461008c:
   mov AL,[ES:BX]
   mov CX,FFFF
L24610092:
   mov DL,[ES:BX]
   cmp AL,DL
   jz L24610092
   push BX
   push DX
   mov AX,0037
   push AX
   call far A24610002
   pop AX
   pop DX
   pop BX
   cmp DL,[ES:BX]
   jz L246100b3
   dec word ptr [CS:offset Y24610000]
jmp near L2461008c
L246100b3:
   pop ES
   pop DX
   pop CX
   pop BX
ret near

Segment 246c ;; GETVECT
A246c0008:
   push BP
   mov BP,SP
   mov AH,35
   mov AL,[BP+06]
   int 21
   mov AX,BX
   mov DX,ES
jmp near L246c0018
L246c0018:
   pop BP
ret far

A246c001a:
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

Segment 246e ;; GOTOXY
A246e000b:
   push BP
   mov BP,SP
   sub SP,+02
   mov AL,[BP+08]
   add AL,FF
   mov [BP-02],AL
   mov AL,[28C9]
   add [BP-02],AL
   mov AL,[BP+06]
   add AL,FF
   mov [BP-01],AL
   mov AL,[28C8]
   add [BP-01],AL
   mov AL,[BP-02]
   cmp AL,[28C9]
   jb L246e0051
   mov AL,[BP-02]
   cmp AL,[28CB]
   ja L246e0051
   mov AL,[BP-01]
   cmp AL,[28C8]
   jb L246e0051
   mov AL,[BP-01]
   cmp AL,[28CA]
   jbe L246e0053
L246e0051:
jmp near L246e0062
L246e0053:
   mov DL,[BP-01]
   mov DH,[BP-02]
   mov AH,02
   mov BH,00
   call far A076a0414
L246e0062:
   mov SP,BP
   pop BP
ret far

Segment 2474 ;; GPTEXT
A24740006:
   push BP
   mov BP,SP
   push SI
   push DI
   push [BP+06]
   push [BP+08]
   push [BP+0A]
   push [BP+0C]
   call far A24b10194
   or AX,AX
   jnz L24740024
   xor AX,AX
jmp near L24740059
L24740024:
   mov DI,[BP+0A]
   sub DI,[BP+06]
   inc DI
   mov SI,[BP+08]
jmp near L2474004f
L24740030:
   push [BP+10]
   push [BP+0E]
   push [BP+06]
   push SI
   call far A24dc0001
   push DX
   push AX
   push DI
   call far A24b10157
   mov AX,DI
   shl AX,1
   add [BP+0E],AX
   inc SI
L2474004f:
   cmp SI,[BP+0C]
   jle L24740030
   mov AX,0001
jmp near L24740059
L24740059:
   pop DI
   pop SI
   pop BP
ret far

A2474005d:
   push BP
   mov BP,SP
   push SI
   push DI
   mov DI,[BP+0A]
   sub DI,[BP+06]
   inc DI
   mov SI,[BP+08]
jmp near L2474008d
L2474006e:
   push [BP+06]
   push SI
   call far A24dc0001
   push DX
   push AX
   push [BP+10]
   push [BP+0E]
   push DI
   call far A24b10157
   mov AX,DI
   shl AX,1
   add [BP+0E],AX
   inc SI
L2474008d:
   cmp SI,[BP+0C]
   jle L2474006e
   mov AX,0001
jmp near L24740097
L24740097:
   pop DI
   pop SI
   pop BP
ret far

Segment 247d ;; INTR
A247d000b:
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
   jb L247d0053
   cmp AL,26
   ja L247d0053
   mov byte ptr [BP-09],36
   mov word ptr [BP-08],068F
   mov [BP-06],CX
   mov byte ptr [BP-04],CA
   mov word ptr [BP-03],0002
jmp near L247d005c

X247d0051:
   nop
A247d0052:
iret
L247d0053:
   mov byte ptr [BP-09],CA
   mov word ptr [BP-08],0002
L247d005c:
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
   call near offset A247d0052
   pop DS
   pop BP
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 2488 ;; LDIV, LRSH, MOVETEXT
A24880000:
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
   call far A24b10194
   or AX,AX
   jz L24880040
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
   call far A24b10194
   or AX,AX
   jnz L24880044
L24880040:
   xor AX,AX
jmp near L248800a6
L24880044:
   mov [BP-06],SI
   mov AX,[BP+0C]
   mov [BP-04],AX
   mov word ptr [BP-02],0001
   cmp SI,[BP+10]
   jge L24880065
   mov AX,[BP+0C]
   mov [BP-06],AX
   mov [BP-04],SI
   mov word ptr [BP-02],FFFF
L24880065:
   mov DI,[BP-06]
jmp near L24880097
L2488006a:
   push [BP+0E]
   mov AX,DI
   sub AX,SI
   add AX,[BP+10]
   push AX
   call far A24dc0001
   push DX
   push AX
   push [BP+06]
   push DI
   call far A24dc0001
   push DX
   push AX
   mov AX,[BP+0A]
   sub AX,[BP+06]
   inc AX
   push AX
   call far A24b10157
   add DI,[BP-02]
L24880097:
   mov AX,[BP-04]
   add AX,[BP-02]
   cmp AX,DI
   jnz L2488006a
   mov AX,0001
jmp near L248800a6
L248800a6:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 2492 ;; OUTPORT, OVERFLOW, PSBP
A2492000c:
   push BP
   mov BP,SP
   mov DX,[BP+06]
   mov AX,[BP+08]
   out DX,AX
   pop BP
ret far

X24920018:
   push BP
   mov BP,SP
   mov DX,[BP+06]
   mov AL,[BP+08]
   out DX,AL
   pop BP
ret far

Segment 2494 ;; RAND
A24940004:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   xor DX,DX
   mov [28E2],DX
   mov [28E0],AX
   pop BP
ret far

A24940015:
   mov DX,[28E2]
   mov AX,[28E0]
   mov CX,015A
   mov BX,4E35
   call far A076a0390
   add AX,0001
   adc DX,+00
   mov [28E2],DX
   mov [28E0],AX
   mov AX,[28E2]
   and AX,7FFF
jmp near L2494003c
L2494003c:
ret far

Segment 2497 ;; SCOPY, SCROLL
B2497000d:
   push BP
   mov BP,SP
   mov CH,[28CC]
   mov CL,20
jmp near L24970025
L24970018:
   les BX,[BP+08]
   mov [ES:BX],CX
   add word ptr [BP+08],+02
   inc word ptr [BP+06]
L24970025:
   mov AX,[BP+06]
   cmp AX,[BP+04]
   jle L24970018
   pop BP
ret near 0008

A24970031:
   push BP
   mov BP,SP
   sub SP,00A0
   cmp byte ptr [28D1],00
   jz L24970042
jmp near L2497018c
L24970042:
   cmp word ptr [28D7],+00
   jnz L2497004c
jmp near L2497018c
L2497004c:
   cmp byte ptr [BP+06],01
   jz L24970055
jmp near L2497018c
L24970055:
   inc byte ptr [BP+0E]
   inc byte ptr [BP+0C]
   inc byte ptr [BP+0A]
   inc byte ptr [BP+08]
   cmp byte ptr [BP+10],06
   jz L2497006a
jmp near L249700fb
L2497006a:
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
   call far A24880000
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
   call far A24740006
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
   call near B2497000d
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
   call far A2474005d
   add SP,+0C
jmp near L2497018a
L249700fb:
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
   call far A24880000
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
   call far A24740006
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
   call near B2497000d
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
   call far A2474005d
   add SP,+0C
L2497018a:
jmp near L249701a7
L2497018c:
   mov BH,[28CC]
   mov AH,[BP+10]
   mov AL,[BP+06]
   mov CH,[BP+0C]
   mov CL,[BP+0E]
   mov DH,[BP+08]
   mov DL,[BP+0A]
   call far A076a0414
L249701a7:
   mov SP,BP
   pop BP
ret far 000C

Segment 24b1 ;; SCREEN
B24b1000d:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   mov SI,[BP+04]
   shr SI,1
   mov AX,SI
   mov DL,[28D0]
   mov DH,00
   mov BX,DX
   xor DX,DX
   div BX
   mov [BP-02],AL
   mov AL,[BP-02]
   mov AH,00
   mov DL,[28D0]
   mov DH,00
   mul DX
   mov DX,SI
   sub DL,AL
   mov [BP-01],DL
   mov AH,[BP-02]
   mov AL,[BP-01]
jmp near L24b10046
L24b10046:
   pop SI
   mov SP,BP
   pop BP
ret near 0004

B24b1004d:
   push BP
   mov BP,SP
   les BX,[BP+08]
   mov DX,[ES:BX]
   les BX,[BP+04]
   cmp DX,[ES:BX]
   jz L24b1006d
   mov BH,00
   mov AH,02
   call far A076a0414
   les BX,[BP+04]
   mov [ES:BX],DX
L24b1006d:
   inc DL
   mov AL,DL
   cmp AL,[28D0]
   jb L24b1007b
   inc DH
   mov DL,00
L24b1007b:
   les BX,[BP+08]
   mov [ES:BX],DX
   pop BP
ret near 0008

B24b10085:
   push BP
   mov BP,SP
   sub SP,+0A
   push SI
   push DI
   call far A24e60002
   mov DI,AX
   mov AX,DI
   mov [BP-06],AX
   mov AX,[BP+0C]
   cmp AX,[28D5]
   jnz L24b100a7
   mov AX,0001
jmp near L24b100a9
L24b100a7:
   xor AX,AX
L24b100a9:
   mov [BP-04],AX
   or AX,AX
   jz L24b100bc
   push [BP+0C]
   push [BP+0A]
   call near B24b1000d
   mov [BP-0A],AX
L24b100bc:
   mov AX,[BP+08]
   cmp AX,[28D5]
   jnz L24b100ca
   mov AX,0001
jmp near L24b100cc
L24b100ca:
   xor AX,AX
L24b100cc:
   mov [BP-02],AX
   or AX,AX
   jz L24b100df
   push [BP+08]
   push [BP+06]
   call near B24b1000d
   mov [BP-08],AX
L24b100df:
jmp near L24b1013a
L24b100e1:
   cmp word ptr [BP-02],+00
   jz L24b10101
   push SS
   lea AX,[BP-08]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   call near B24b1004d
   mov BH,00
   mov AH,08
   call far A076a0414
   mov SI,AX
jmp near L24b1010b
L24b10101:
   les BX,[BP+06]
   mov SI,[ES:BX]
   add word ptr [BP+06],+02
L24b1010b:
   cmp word ptr [BP-04],+00
   jz L24b10130
   push SS
   lea AX,[BP-0A]
   push AX
   push SS
   lea AX,[BP-06]
   push AX
   call near B24b1004d
   mov AX,SI
   mov BL,AH
   mov CX,0001
   mov BH,00
   mov AH,09
   call far A076a0414
jmp near L24b1013a
L24b10130:
   les BX,[BP+0A]
   mov [ES:BX],SI
   add word ptr [BP+0A],+02
L24b1013a:
   mov AX,[BP+04]
   dec word ptr [BP+04]
   or AX,AX
   jnz L24b100e1
   mov DX,DI
   mov BH,00
   mov AH,02
   call far A076a0414
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret near 000A

A24b10157:
   push BP
   mov BP,SP
   cmp byte ptr [28D1],00
   jnz L24b1017e
   cmp word ptr [28D7],+00
   jz L24b1017e
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call far A24dc0026
jmp near L24b10190
L24b1017e:
   push [BP+0E]
   push [BP+0C]
   push [BP+0A]
   push [BP+08]
   push [BP+06]
   call near B24b10085
L24b10190:
   pop BP
ret far 000A

A24b10194:
   push BP
   mov BP,SP
   mov AL,[28D0]
   mov AH,00
   mov CX,AX
   mov AL,[28CF]
   mov AH,00
   mov DX,AX
   mov AX,[BP+0C]
   cmp AX,CX
   ja L24b101d6
   mov AX,[BP+08]
   cmp AX,CX
   ja L24b101d6
   mov AX,[BP+0C]
   cmp AX,[BP+08]
   jg L24b101d6
   mov AX,[BP+0A]
   cmp AX,DX
   ja L24b101d6
   mov AX,[BP+06]
   cmp AX,DX
   ja L24b101d6
   mov AX,[BP+0A]
   cmp AX,[BP+06]
   jg L24b101d6
   mov AX,0001
jmp near L24b101d8
L24b101d6:
   xor AX,AX
L24b101d8:
jmp near L24b101da
L24b101da:
   pop BP
ret far 0008

Segment 24ce ;; SOUND
A24ce000e:
   push BP
   mov BP,SP
   mov BX,[BP+06]
   mov AX,34DD
   mov DX,0012
   cmp DX,BX
   jnb L24ce0038
   div BX
   mov BX,AX
   in AL,61
   test AL,03
   jnz L24ce0030
   or AL,03
   out 61,AL
   mov AL,B6
   out 43,AL
L24ce0030:
   mov AL,BL
   out 42,AL
   mov AL,BH
   out 42,AL
L24ce0038:
   pop BP
ret far

A24ce003a:
   in AL,61
   and AL,FC
   out 61,AL
ret far

Segment 24d2 ;; STRDUP
A24d20001:
   push BP
   mov BP,SP
   sub SP,+04
   push SI
   push [BP+08]
   push [BP+06]
   call far A2388000b
   pop CX
   pop CX
   mov SI,AX
   inc SI
   push SI
   call far A22d7000a
   pop CX
   mov [BP-02],DX
   mov [BP-04],AX
   or DX,AX
   jz L24d2003e
   push SI
   push [BP+08]
   push [BP+06]
   push [BP-02]
   push [BP-04]
   call far A23900001
   add SP,+0A
L24d2003e:
   mov DX,[BP-02]
   mov AX,[BP-04]
jmp near L24d20046
L24d20046:
   pop SI
   mov SP,BP
   pop BP
ret far

Segment 24d6 ;; STRUPR
A24d6000b:
   push BP
   mov BP,SP
   push SI
   cld
   push DS
   lds SI,[BP+06]
   mov DX,SI
jmp near L24d60023
L24d60018:
   sub AL,61
   cmp AL,19
   ja L24d60023
   add AL,41
   mov [SI-01],AL
L24d60023:
   lodsb
   and AL,AL
   jnz L24d60018
   mov AX,DX
   mov DX,DS
   pop DS
   pop SI
   pop BP
ret far

Segment 24d9 ;; TOUPPER
A24d90000:
   push BP
   mov BP,SP
   cmp word ptr [BP+06],-01
   jnz L24d9000e
   mov AX,FFFF
jmp near L24d9002f
L24d9000e:
   mov AL,[BP+06]
   mov AH,00
   mov BX,AX
   test byte ptr [BX+26F1],08
   jz L24d90028
   mov AL,[BP+06]
   mov AH,00
   add AX,FFE0
jmp near L24d9002f

X24d90026:
jmp near L24d9002f
L24d90028:
   mov AL,[BP+06]
   mov AH,00
jmp near L24d9002f
L24d9002f:
   pop BP
ret far

Segment 24dc ;; VRAM
A24dc0001:
   push BP
   mov BP,SP
   mov AX,[BP+06]
   dec AX
   mov DL,[28D0]
   mov DH,00
   mul DX
   add AX,[28D3]
   mov DX,[BP+08]
   dec DX
   add AX,DX
   shl AX,1
   mov DX,[28D5]
jmp near L24dc0022
L24dc0022:
   pop BP
ret far 0004

A24dc0026:
   push BP
   mov BP,SP
   sub SP,+02
   push SI
   push DI
   mov AL,[28D2]
   mov AH,00
   mov [BP-02],AX
   push DS
   mov CX,[BP+06]
   jcxz L24dc0096
   les DI,[BP+0C]
   lds SI,[BP+08]
   cld
   cmp SI,DI
   jnb L24dc0051
   mov AX,CX
   dec AX
   shl AX,1
   add SI,AX
   add DI,AX
   std
L24dc0051:
   cmp word ptr [BP-02],+00
   jnz L24dc005b
   repz movsw
jmp near L24dc0096
L24dc005b:
   mov DX,03DA
   mov AX,ES
   mov BX,DS
   cmp AX,BX
   jz L24dc0077
L24dc0066:
   cli
L24dc0067:
   in AL,DX
   ror AL,1
   jb L24dc0067
L24dc006c:
   in AL,DX
   ror AL,1
   jnb L24dc006c
   movsw
   sti
   loop L24dc0066
jmp near L24dc0096
L24dc0077:
   cli
L24dc0078:
   in AL,DX
   ror AL,1
   jb L24dc0078
L24dc007d:
   in AL,DX
   ror AL,1
   jnb L24dc007d
   lodsw
   sti
   mov BX,AX
L24dc0086:
   in AL,DX
   ror AL,1
   jb L24dc0086
L24dc008b:
   in AL,DX
   ror AL,1
   jnb L24dc008b
   mov AX,BX
   stosw
   sti
   loop L24dc0077
L24dc0096:
   cld
   pop DS
jmp near L24dc009a
L24dc009a:
   pop DI
   pop SI
   mov SP,BP
   pop BP
ret far 000A

Segment 24e6 ;; WHEREXY
A24e60002:
   mov AH,03
   mov BH,00
   call far A076a0414
   mov AX,DX
jmp near L24e6000f
L24e6000f:
ret far

X24e60010:
   push CS
   call near offset A24e60002
   mov AH,00
   mov DL,[28C8]
   mov DH,00
   sub AX,DX
   inc AX
jmp near L24e60021
L24e60021:
ret far

X24e60022:
   push CS
   call near offset A24e60002
   mov CL,08
   shr AX,CL
   mov AH,00
   mov DL,[28C9]
   mov DH,00
   sub AX,DX
   inc AX
jmp near L24e60037
L24e60037:
ret far

Segment 24e9 ;; WINDOW
A24e90008:
   push BP
   mov BP,SP
   dec word ptr [BP+06]
   dec word ptr [BP+0A]
   dec word ptr [BP+08]
   dec word ptr [BP+0C]
   cmp word ptr [BP+06],+00
   jl L24e90047
   mov AL,[28D0]
   mov AH,00
   cmp AX,[BP+0A]
   jle L24e90047
   cmp word ptr [BP+08],+00
   jl L24e90047
   mov AL,[28CF]
   mov AH,00
   cmp AX,[BP+0C]
   jle L24e90047
   mov AX,[BP+0A]
   sub AX,[BP+06]
   jl L24e90047
   mov AX,[BP+0C]
   sub AX,[BP+08]
   jge L24e90049
L24e90047:
jmp near L24e90070
L24e90049:
   mov AL,[BP+06]
   mov [28C8],AL
   mov AL,[BP+0A]
   mov [28CA],AL
   mov AL,[BP+08]
   mov [28C9],AL
   mov AL,[BP+0C]
   mov [28CB],AL
   mov DL,[BP+06]
   mov DH,[BP+08]
   mov AH,02
   mov BH,00
   call far A076a0414
L24e90070:
   pop BP
ret far

Y24e90072:	ds 000e

Segment 24f1 ;; Data And BSS Areas
;; Data Area
A24f10000:
Y24f10000:	dword
Y24f10004:	db "Turbo-C - Copyright (c) 1988 Borland Intl.",00
Y24f1002f:	db "Divide error\r\n"
Y24f1003d:	db "Abnormal program termination\r\n"
Y24f1005b:	dword
Y24f1005f:	dword
Y24f10063:	dword
Y24f10067:	dword
Y24f1006b:	word
Y24f1006d:	dword
Y24f10071:	dword
Y24f10075:	word
Y24f10077:	word
Y24f10079:	word
Y24f1007b:	word
Y24f1007d:	byte
X24f1007e:	byte
Y24f1007f:	word
Y24f10081:	word
Y24f10083:	dword
Y24f10087:	dword
Y24f1008b:	dword
Y24f1008f:	dword
Y24f10093:	byte
Y24f10094:	db 00,01,02,03,04,05,06,07,08,09,0a,0b,0c,0d,0e,0f
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
Y24f10194:	db 00,00,00, 00,00,2a, 00,2a,00, 00,2a,2a, 2a,00,00, 2a,00,2a, 2a,15,00, 2a,2a,2a
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
Y24f10494:	dw 03c8
Y24f10496:	dw 03c7
Y24f10498:	dw 03c9
Y24f1049a:	dw 03da
Y24f1049c:	dw 0008
Y24f1049e:	db "\r\nVideo mode: C)ga E)ga V)ga? ",00
X24f104bd:	byte
Y24f104be:	db " ",00
Y24f104c0:	dword
Y24f104c4:	dword
Y24f104c8:	ds 000c
Y24f104d4:	db "\r\n",00
Y24f104d7:	db "\r\nJoystick calibration:  Press ESCAPE to abort.\r\n",00
Y24f10509:	db "  Center joystick and press button: ",00
Y24f1052e:	db "  Move joystick to UPPER LEFT corner and press button: ",00
Y24f10566:	db "  Move joystick to LOWER RIGHT corner and press button: ",00
Y24f1059f:	db "  Calibration failed - try again (y/N)? ",00
Y24f105c8:	db "\r\n",00
Y24f105cb:	db "\r\nGame controller:  K)eyboard,  J)oystick?  ",00
Y24f105f8:	db "\r\n",00
X24f105fb:	byte
Y24f105fc:	ds 0040
Y24f1063c:	word
Y24f1063e:	word
Y24f10640:	db "\r\n\r\nDetecting your hardward...\r\n",00
Y24f10661:	db "\r\nIf your system locks, reboot and type:\r\n",00
Y24f1068c:	db "   ",00
Y24f10690:	db " /NOSB  (No Sound Blaster card)\r\n",00
Y24f106b2:	db "   ",00
Y24f106b6:	db " /SB    (With a Sound Blaster)\r\n",00
Y24f106d7:	db "   ",00
Y24f106db:	db " /NOSND (If all else fails)\r\n",00
Y24f106f9:	db "/TEST",00
Y24f106ff:	db "/NOSB",00
Y24f10705:	db "/SB",00
Y24f10709:	db "/NOSND",00
Y24f10710:	db "/DEMO",00
Y24f10716:	db "\r\n",00
Y24f10719:	db " Your configuration:\r\n",00
Y24f10730:	db "    Digital Sound Blaster sound effects ON\r\n",00
Y24f1075d:	db "    No digitized sound effects\r\n",00
Y24f1077e:	db "    Sound Blaster musical sound track ON\r\n",00
Y24f107a9:	db "    No musical sound track\r\n",00
Y24f107c6:	db "    A joystick\r\n",00
Y24f107d7:	db "    No joystick\r\n",00
Y24f107e9:	db "    CGA graphics (You're missing some\r\n",00
Y24f10811:	db "    hot 256-color VGA scenery!)\r\n",00
Y24f10833:	db "    16-color EGA graphics\r\n",00
Y24f1084f:	db "    256-color VGA graphics\r\n",00
Y24f1086c:	db "\r\n",00
Y24f1086f:	db "  Press ENTER if this is correct\r\n",00
Y24f10892:	db "      or press 'C' to configure: ",00
Y24f108b4:	db "\r\n",00
Y24f108b7:	db " No Sound Blaster-compatible music card has been\r\n",00
Y24f108ea:	db " detected.\r\n\r\n",00
Y24f108f9:	db " Press any key to continue...",00
Y24f10917:	db "\r\n\r\n",00
Y24f1091c:	db " A Sound Blaster card was detected, but your CPU is\r\n",00
Y24f10952:	db " too slow to support digitized sound.  Digital sound\r\n",00
Y24f10989:	db " is now OFF.\r\n\r\n",00
Y24f1099a:	db " Press any key to continue...",00
Y24f109b8:	db " A Sound Blaster card has been detected.\r\n\r\n",00
Y24f109e5:	db " This game will play high-quality digital sound\r\n",00
Y24f10a17:	db " through your Sound Blaster if you wish.\r\n\r\n",00
Y24f10a44:	db " Warning:  There's a teeny chance this will cause\r\n",00
Y24f10a78:	db " problems if you have less than 640K of RAM, or\r\n",00
Y24f10aaa:	db " if your computer is not totally compatible.\r\n\r\n",00
Y24f10adb:	db " Do you want digital sound? ",00
Y24f10af8:	db "\r\n\r\n\r\n",00
Y24f10aff:	db " This game features a Sound Blaster-compatible\r\n",00
Y24f10b30:	db " musical sound track.\r\n\r\n\r\n",00
Y24f10b4c:	db " Do you want the musical sound track? ",00
Y24f10b73:	db "\r\n",00
Y24f10b76:	db "\r\n",00
Y24f10b79:	db " Please tell us about your graphics:\r\n",00
Y24f10ba0:	db "     CGA 4-color graphics\r\n",00
Y24f10bbc:	db "     EGA 16-color graphics\r\n",00
Y24f10bd9:	db "     VGA 256-color graphics\r\n",00
Y24f10bf7:	db "\r\n",00
Y24f10bfa:	db " Note: If you have a slow old computer, CGA\r\n",00
Y24f10c28:	db "       graphics are recommended.\r\n",00
X24f10c4b:	byte
Y24f10c4c:	db "\\screen",00
Y24f10c54:	db ".RAW",00
Y24f10c59:	db "\\screen",00
Y24f10c61:	db ".MAP",00
Y24f10c66:	db " ",00
Y24f10c68:	db " ",00
Y24f10c6a:	db "\r\n",00
Y24f10c6d:	db "",00
Y24f10c6e:	dw 0001
Y24f10c70:	dw 0001
Y24f10c72:	word
Y24f10c74:	dd Y0040006c
Y24f10c78:	dword
Y24f10c7c:	dd A0ce30c47
Y24f10c80:	word
Y24f10c82:	dword
Y24f10c86:	dw 0040,0043,0047,004c,0050,0055,005a,005f,0065,006b,0072,0079,0000,0000,0000,0000
		dw 0080,0087,008f,0098,00a1,00aa,00b5,00bf,00cb,00d7,00e4,00f2,0000,0000,0000,0000
		dw 0100,010f,011f,0130,0142,0155,016a,017f,0196,01ae,01c8,01e3,0000,0000,0000,0000
		dw 0200,021e,023e,0260,0285,02ab,02d4,02ff,032c,035d,0390,03c7,0000,0000,0000,0000
		dw 0400,043c,047d,04c1,050a,0556,05a8,05fe,0659,06ba,0721,078d,0000,0000,0000,0000
		dw 0800,0879,08fa,0983,0a14,0aad,0b50,0bfc,0cb2,0d74,0e41,0f1a,0000,0000,0000,0000
		dw 1000,10f3,11f5,1306,1428,155b,16a0,17f9,1965,1ae8,1c82,1e34,0000,0000,0000,0000
		dw 2000,21e7,23eb,260d,2851,2ab7,2d41,2ff2,32cb,35d1,3904,3d1e,0000,0000,0000,0000
		dw 4000,43ce,47d6,4c1b,50a2,556e,5a82,5fe4,6597,6ba2,7208,78d0,0000,0000,0000,0000
Y24f10da6:	dw 0010
Y24f10da8:	word
Y24f10daa:	word
Y24f10dac:	word
Y24f10dae:	dw 0001
Y24f10db0:	dw 0001
Y24f10db2:	byte
Y24f10db3:	dword
Y24f10db7:	dword
Y24f10dbb:	dw 0280
Y24f10dbd:	dw 0001
Y24f10dbf:	dw 0001
Y24f10dc1:	dw ffff
Y24f10dc3:	dword
Y24f10dc7:	byte
Y24f10dc8:	dw 0001
Y24f10dca:	dw 0001
Y24f10dcc:	dw 0001
Y24f10dce:	dw 0001
Y24f10dd0:	dw 0001
Y24f10dd2:	dw 0001
Y24f10dd4:	dw 0001
Y24f10dd6:	dw 0000,0001,0002,0001
Y24f10dde:	dw 0001,0002,0001,0000,ffff,fffe,ffff,0000
Y24f10dee:	dw 0000,0001,0002,0003,0002,0001,0009,0009
Y24f10dfe:	dw 0004,0004,0004,0004,0004,0004,ffff,ffff
Y24f10e0e:	dw 0000,0001,0002,0003,0002,0001
Y24f10e1a:	dw 0000,0001,0002,0001
Y24f10e22:	db "PLAYER",00
Y24f10e29:	db "APPLE",00
Y24f10e2f:	db "KNIFE",00
Y24f10e35:	db "KILLME",00
Y24f10e3c:	db "BIGANT",00
Y24f10e43:	db "FLY",00
Y24f10e47:	db "MACROTRIG",00
Y24f10e51:	db "DEMON",00
Y24f10e57:	db "BUNNY",00
Y24f10e5d:	db "INCHWORM",00
Y24f10e66:	db "ZAPPER",00
Y24f10e6d:	db "BOBSLUG",00
Y24f10e75:	db "CHECKPT",00
Y24f10e7d:	db "PAUL",00
Y24f10e82:	db "KEY",00
Y24f10e86:	db "PAD",00
Y24f10e8a:	db "WISEMAN",00
Y24f10e92:	db "FATSO",00
Y24f10e98:	db "FIREBALL",00
Y24f10ea1:	db "CLOUD",00
Y24f10ea7:	db "TEXT6",00
Y24f10ead:	db "TEXT8",00
Y24f10eb3:	db "FROG",00
Y24f10eb8:	db "TINY",00
Y24f10ebd:	db "DOOR",00
Y24f10ec2:	db "FALLDOOR",00
Y24f10ecb:	db "BRIDGER",00
Y24f10ed3:	db "SCORE",00
Y24f10ed9:	db "TOKEN",00
Y24f10edf:	db "ANT",00
Y24f10ee3:	db "PHOENIX",00
Y24f10eeb:	db "FIRE",00
Y24f10ef0:	db "SWITCH",00
Y24f10ef7:	db "GEM",00
Y24f10efb:	db "TXTMSG",00
Y24f10f02:	db "BOULDER",00
Y24f10f0a:	db "EXPL1",00
Y24f10f10:	db "EXPL2",00
Y24f10f16:	db "STALAG",00
Y24f10f1d:	db "SNAKE",00
Y24f10f23:	db "SEAROCK",00
Y24f10f2b:	db "BOLL",00
Y24f10f30:	db "MEGA",00
Y24f10f35:	db "BAT",00
Y24f10f39:	db "KNIGHT",00
Y24f10f40:	db "BEENEST",00
Y24f10f48:	db "BEESWARM",00
Y24f10f51:	db "CRAB",00
Y24f10f56:	db "CROC",00
Y24f10f5b:	db "EPIC",00
Y24f10f60:	db "SPINBLAD",00
Y24f10f69:	db "SKULL",00
Y24f10f6f:	db "BUTTON",00
Y24f10f76:	db "PAC",00
Y24f10f7a:	db "JILLFISH",00
Y24f10f83:	db "JILLSPIDER",00
Y24f10f8e:	db "JILLBIRD",00
Y24f10f97:	db "JILLFROG",00
Y24f10fa0:	db "BUBBLE",00
Y24f10fa7:	db "JELLYFISH",00
Y24f10fb1:	db "BADFISH",00
Y24f10fb9:	db "ELEV",00
Y24f10fbe:	db "FIREBULLET",00
Y24f10fc9:	db "FISHBULLET",00
Y24f10fd4:	db "EYE",00
Y24f10fd8:	db "VINECLIMB",00
Y24f10fe2:	db "FLAG",00
Y24f10fe7:	db "MAPDEMO",00
Y24f10fef:	db "ROMAN",00
Y24f10ff5:	db "APPLES GIVE YOU HEALTH",00
Y24f1100c:	db "YOU FOUND A KNIFE!",00
Y24f1101f:	db "YOU FOUND A KEY!",00
Y24f11030:	db "THE GATE OPENS",00
Y24f1103f:	db "YOU NEED A GEM TO PASS",00
Y24f11056:	db "THE DOOR OPENS",00
Y24f11065:	db "THE DOOR IS LOCKED",00
Y24f11078:	dw 0001
Y24f1107a:	dw 0001
Y24f1107c:	dw 0001
Y24f1107e:	dw 0001
Y24f11080:	dw 0026,000c,000d,000b,000e,000f,0012,0014,0023,0024,0025
Y24f11096:	dw 0001,0000,0000,0000,0001,0001,0000,0001,0000,0000,0000
Y24f110ac:	dd Y24f11214,Y24f1121a,Y24f11231,Y24f11243,Y24f11253,Y24f11259,Y24f11263,Y24f11273
		dd Y24f118f3,Y24f1127b,Y24f1128f
Y24f110d8:	dw 0001,0001,0001,0001,ffff,ffff,ffff,ffff,0001,0001,0001
Y24f110ee:	dw 0020,001f,001e,001d,001c,001d,001e,001f,0020
Y24f11100:	dw 0000,0001,0000,0002
Y24f11108:	dw 0003,0005,0004,0006
Y24f11110:	dw 0007,0007,0008,0008
Y24f11118:	dw 0004,0006,0008,000a,000c,000e
Y24f11124:	dw 0000,0008,0000,0008
Y24f1112c:	dw 0001,0002,0003,0002
Y24f11134:	dw 0008,0008,0000,0000,0000,0000,0000,0000,0000,0000,0008
Y24f1114a:	dw 0000,0000,0001,0002,0003,0004,0004,0003,0002,0001,0000
Y24f11160:	dw 0000,0000,0000,0000,0001,0001,0001,0001,0002,0002,0002,0002,0003,0003,0003,0003
		dw 0003,0003,0003,0003,0003,0002,0002,0002,0002,0001,0001,0001,0001,0000,0000,0000
Y24f111a0:	dw 0004,0005,0006,0007
Y24f111a8:	dw 0000,0001,0002,0003
Y24f111b0:	dw 0003,0004,0005,0006,0007,0006,0005,0004
Y24f111c0:	dw 0000,0001,0002,0001
Y24f111c8:	dw 0009,000a,000b,000c,000d,000e,000d,000c,000b,000a
Y24f111dc:	dw 0000,0001,0002,0001
Y24f111e4:	dw 0003,0002,0001,0001,0000,ffff,ffff,fffe,fffe,fffd,fffd,fffe,fffe,ffff,ffff,0000
		dw 0001,0001,0002,0003
Y24f1120c:	dw 0010,0014
Y24f11210:	dw 0004,0003
Y24f11214:	db "FOOF!",00
Y24f1121a:	db "USE KEYS TO OPEN DOORS",00
Y24f11231:	db "YOU FOUND A KNIFE",00
Y24f11243:	db "YOU FOUND A GEM",00
Y24f11253:	db "POOF!",00
Y24f11259:	db "ZZZZZZZT!",00
Y24f11263:	db "A BAG OF COINS!",00
Y24f11273:	db "KABOOM!",00
Y24f1127b:	db "EXTRA JUMPING POWER",00
Y24f1128f:	db "SHIELD OF INVINCIBILITY",00
Y24f112a7:	db "Press UP/DOWN to toggle switch",00
Y24f112c6:	db "USE GEMS TO OPEN DOORS ON THE MAP",00
Y24f112e8:	db "YOUR FEEBLE ATTEMPT FAILS.",00
Y24f11303:	db "Press UP/DOWN to use elevator",00
X24f11321:	byte
Y24f11322:	dw 0008,0008,0008,0008,0009,000a,000b,000c,0026,0026,0026,0026,0026,000b,000a,0009
Y24f11342:	dw ffff,fffe,ffff,0000
Y24f1134a:	dw 0013,0013,0013,0013
		dw 0013,0010,0012,0010
		dw 0013,0010,0012,0010
		dw 0012,0012,0012,0012
Y24f1136a:	db 18,18,19,1a,1a,19,19
Y24f11371:	db 04,00,00,06,04,04,00
Y24f11378:	db 48,49,48,49,48,48,49,48,49,49,48,48,48,49,49,49,4a,4a,4a,4a,4a
Y24f1138d:	dw 0000,0001,0002,0001
Y24f11395:	dw 0000,0001,0002,0003,0002,0001
X24f113a1:	byte
Y24f113a2:	dw 4000
Y24f113a4:	word
Y24f113a6:	word
Y24f113a8:	word
Y24f113aa:	word
Y24f113ac:	db 00,00,00,00,00,00,00,17,00,1c
		db 00,00,00,18,1c,00,00,00,00,00
		db 30,00,00,00,00,00,05,30,00,17
		db 18,12,10,00,03,00,0c,00,08,00
		db 29,00,20,08,18,0a,00,23,00,30
Y24f113de:	word
Y24f113e0:	db "1234567890-="
		db "QWERTYUIOP[]"
		db "ASDFGHJKL;'"
		db "ZXCVBNM,./"
		db 01,02,03,04,05,06,00
Y24f11414:	db "JUMP   ",00
Y24f1141c:	db "KNIFE  ",00
Y24f11424:	db "       ",00
Y24f1142c:	db "       ",00
Y24f11434:	db "       ",00
Y24f1143c:	db "FLAP   ",00
Y24f11444:	db "FIRE   ",00
Y24f1144c:	db "HOP    ",00
Y24f11454:	db "LEAP   ",00
Y24f1145c:	db "SWIM   ",00
Y24f11464:	db "SHOOT  ",00
Y24f1146c:	db "       ",00
Y24f11474:	db "       ",00
Y24f1147c:	db "____________",00
Y24f11489:	db "Help",00
Y24f1148e:	db "N",00
Y24f11490:	db "Q",00
Y24f11492:	db "S",00
Y24f11494:	db "R",00
Y24f11496:	db "T",00
Y24f11498:	db "NOISE",00
Y24f1149e:	db "QUIT",00
Y24f114a3:	db "SAVE",00
Y24f114a8:	db "RESTORE",00
Y24f114b0:	db "TURTLE",00
Y24f114b7:	db "HEALTH",00
Y24f114be:	db "SCORE",00
Y24f114c4:	db "LEVEL",00
Y24f114ca:	db "MAP",00
Y24f114ce:	db "     ",00
Y24f114d4:	db "                                    ",00
Y24f114f9:	db "PRESS F1 FOR HELP!",00
Y24f1150c:	db "YOU LEFT WITHOUT FINDING A GEM!",00
Y24f1152c:	db "temp.mac",00
Y24f11535:	db "temp.mac",00
Y24f1153e:	db "A NEW RELEASE FROM",00
Y24f11551:	db "PRODUCED BY",00
Y24f1155d:	db "NOW LOADING, PLEASE WAIT...",00
Y24f11579:	db "____________",00
Y24f11586:	db "HI SCORES",00
Y24f11590:	db "____________",00
Y24f1159d:	db "____________",00
Y24f115aa:	db "PRESS",00
Y24f115b0:	db "TO ABORT",00
Y24f115b9:	db "ESCAPE",00
Y24f115c0:	db " ",00
Y24f115c2:	db "LOAD GAME",00
Y24f115cc:	db "<empty>",00
Y24f115d4:	db ".",00
Y24f115d6:	db "m.",00
Y24f115d9:	db "SAVE GAME",00
Y24f115e3:	db "",00
Y24f115e4:	db ".",00
Y24f115e6:	db "m.",00
Y24f115e9:	db "INVENTORY",00
Y24f115f3:	db "CONTROLS",00
Y24f115fc:	db "7REALLY QUIT?\r4YES\r2NO\r",00
Y24f11614:	db "YN",00
Y24f11617:	db "temp",00
Y24f1161c:	db " Yikes, this game is goofed!  Please report this code:  <",00
Y24f11656:	db ">\r\n",00
Y24f1165a:	db "\r\n",00
Y24f1165d:	db "\r\n\r\n",00
Y24f11662:	db "   Problem: You don't have enough free RAM to run this game properly.\r\n",00
Y24f116aa:	db " Solutions: Boot from a blank floppy disk\r\n",00
Y24f116d6:	db "            Run this game without any TSR's in memory\r\n",00
Y24f1170e:	db "            Buy more memory (640K is required)\r\n",00
Y24f1173f:	db "            Turn off the digital Sound Blaster effects -- they eat up RAM\r\n",00
Y24f1178b:	db " The problem may be due to not enough free RAM or disk space.",00
Y24f117c9:	byte
Y24f117ca:	word
Y24f117cc:	word
Y24f117ce:	db "kind:            ",00
Y24f117e0:	db "stat:            ",00
Y24f117f2:	db "  xd:            ",00
Y24f11804:	db "  yd:            ",00
Y24f11816:	db " cnt:            ",00
Y24f11828:	db "Text Inside",00
Y24f11834:	db "NONE",00
Y24f11839:	db "obj:Add Oov",00
Y24f11845:	db " Del Paste",00
Y24f11850:	db " Kopy Mod",00
Y24f1185a:	db "Kind:",00
Y24f11860:	db "Put:",00
Y24f11865:	db "Clear?",00
Y24f1186c:	db "Load:",00
Y24f11872:	db "Dis Y:",00
Y24f11879:	db "New board?",00
Y24f11884:	db "Save:",00
Y24f1188a:	db "JILL3",00
Y24f11890:	db "jill3.sha",00
Y24f1189a:	db "jill3.vcl",00
Y24f118a4:	db "jill3.cfg",00
Y24f118ae:	db "jill.dma",00
Y24f118b7:	db "map.jn3",00
Y24f118bf:	db "intro.jn3",00
Y24f118c9:	db "wild.ddt",00
Y24f118d2:	db "The knight slices Jill in half",00
Y24f118f1:	word
Y24f118f3:	db "YOU FIND A THROWING STAR",00
Y24f1190c:	db "BLADE  ",00
Y24f11914:	db "jn3save",00
Y24f1191c:	db " Epic MegaGames, 10406 Holbrook Drive, Potomac MD 20854",00
Y24f11954:	dw 0018
Y24f11956:	word
Y24f11958:	dw 0007
Y24f1195a:	db '7', "PICK A CHOICE:\r"
		db '2', "PLAY\r"
		db '2', "RESTORE\r"
		db '5', "STORY\r"
		db '5', "INSTRUCTIONS\r"
		db '5', "ORDERING INFO\r"
		db '5', "CREDITS\r"
		db '3', "DEMO\r"
		db '3', "NOISEMAKER\r"
		db '4', "QUIT\r"
		db 00
Y24f119bf:	db "PRSIOCDNQ",05,10,00
Y24f119cb:	dw 0009
Y24f119cd:	dd Y24f123a3,Y24f123a9,Y24f123af,Y24f123b6,Y24f123b7,Y24f123b8,Y24f123b9,Y24f123ba,Y24f123bb,Y24f123bc
Y24f119f5:	db 01,05,0c,00,00,00,00,00,00,00
Y24f119ff:	dd Y24f123bd,Y24f123c9,Y24f123d5,Y24f123e1,Y24f123e2,Y24f123e3,Y24f123e4,Y24f123e5,Y24f123e6,Y24f123e7
Y24f11a27:	db 03,10,19,1c, 0a,1a,07,dc, 19,02, dc,dc,dc, 19,02, 1a,03,dc, "  ", 1a,03,dc, 18
		db " ", 0d,"E", 09,"p", 0d,"i", 09,"c"
		db " ", 0c,"M", 0e,"e", 0c,"g", 0e,"a", 0c,"G", 0e,"a", 0c,"m", 0e,"e", 0c,"s"
		db " ", 0b,"P", 0f,"r", 0b,"e", 0f,"s", 0b,"e", 0f,"n", 0b,"t", 0f,"s"
		db 19,09, 0a,dc,dc,dc, 19,09, dc,dc,dc, 19,02, dc,dc,dc, 19,05
		db 09,"Copyright", 18
		db " ", 03,"A"
		db " ", 02,"C", 03,"o", 02,"m", 03,"m", 02,"e", 03,"r", 02,"c", 03,"i", 02,"a", 03,"l"
		db " P", 02,"r", 03,"o", 02,"d", 03,"u", 02,"c", 03,"t", 02,"i", 03,"o", 02,"n"
		db 19,09, 0a,dc,dc,dc,"  ", 1a,03,dc, 19,03, dc,dc,dc, 19,02, dc,dc,dc, 19,07, 09,"1992", 18
		db 19,21, 0a,dc,dc,dc, 19,02, dc,dc,dc, 19,03, dc,dc,dc, 19,02, dc,dc,dc, 18
		db "  ", 0c,14,db,db, 19,16, 0a,dc,dc,dc, 19,02, dc,dc,dc, 19,03, dc,dc,dc, 19,03, dc,dc,dc
		db 19,02, dc,dc,dc, 19,13, 0c,db,db, 18
		db 10,"  ", 14,"  ", 11,19,18, 0a,1a,04,dc, 19,04, 1a,04,dc
		db 19,02, dc,dc,dc, 19,02, dc,dc,dc, 19,13, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 14,"  ", 11,19,47, 14,"  ", 18
		db 10,"  ", 0c,14,db,db, 19,47, db,db, 18
		db 18
		db 10," ", 0e,db,df,df,df," ",db,df,df,db," ",db, 19,02, db," ",db,df,df,df," ",db,df,df,df
		db 19,03, df,df,db,df,df," ",db, 19,02, db," ",db,df,df,df, 18
		db " ",df,df,df,db," ",db,df,df,db," ",df,dc," ",dc,df," ",db,df,df,"  ",df,df,df,db, 19,05, db
		db 19,02, db,df,df,df,db," ",db,df,df, 19,07, 09,cd, 1a,00,10, "  ", 07,"Tim Sweeney", 18
		db " ", 0e,1a,03,df, " ",df,"  ",df, 19,02, df, 19,02, 1a,03,df, " ", 1a,03,df, 19,05, df, 19,02, df
		db 19,02, df," ", 1a,03,df, 19,06, 09,cd, 1a,00,10, "  ", 07,"John Pallett-Plowright", 18
		db 19,06, 0f,db,df,df,dc," ",db,df,df,dc," ",df,db,df," ",db,dc," ",db," ",dc,df,df,dc," ",db,df,df
		db 19,12, 09,cd, 1a,00,10, "  ", 07,"Dan Froelich", 18
		db 19,06, 0f,db,df,df,"  ",db,df,df,dc,"  ",db,"  ",db," ",df,db," ",db,"  ",dc," ",db,df
		db 19,13, 09,cd, 1a,00,10, "  ", 07,"Joe Hitchens", 18
		db 19,06, 0f,df, 19,03, df,"  ",df," ",df,df,df," ",df,"  ",df,"  ",df,df,"  ",df,df,df, 18
		db 00
Y24f11d02:	db 0c,10,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16
		db 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 04,1a,00,16, 0c,1a,00,16, 18
		db 19,1a, 0a,"Thank you for playing Jill Saves the Prince!", 18
		db " ", 08,1a,13,dc, 07,dc, 18
		db " ", 08,db, 14," ", 0c,1a,04,dc, 19,0c
		db 08,10,db, 19,02, 09,"This is the third volume of the Jill series from Epic", 18
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
		db 1a,03,c4, d9," "
		db 09,db, 10,19,02, 0d,"our catalog (CATALOG.EXE) for information", 18
		db " ", 09,db, 11,19,08, 03,c4,c4,d9, 19,14
		db 09,db, 10,19,02, 0d,"about our other hot products.", 18
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
Y24f122d4:	dw 05d1
Y24f122d6:	dw 02da
Y24f122d8:	db "Tim Sweeney",00
Y24f122e4:	db "Epic MegaGames",00
Y24f122f3:	db "Move Jill",00
Y24f122fd:	db "Jill Saves The Prince",00
Y24f12313:	dd Y24f123e8,Y24f123fb,Y24f12419,Y24f12436
Y24f12323:	dd Y24f12453,Y24f1246f,Y24f12487,Y24f124a7,Y24f124c1,Y24f124e3,Y24f124ff,Y24f1251b
		dd Y24f12550,Y24f12574,Y24f12591,Y24f125bc,Y24f125da,Y24f12617,Y24f1263a,Y24f1263c
		dd Y24f1263e,Y24f12640,Y24f12642,Y24f12644,Y24f12646,Y24f12648,Y24f1264c,Y24f12650
		dd Y24f12654,Y24f12658,Y24f1265c,Y24f12660,Y24f12664,Y24f12668,Y24f1266c,Y24f1266d
Y24f123a3:	db "1.jn3",00
Y24f123a9:	db "5.jn3",00
Y24f123af:	db "12.jn3",00
Y24f123b6:	db "",00
Y24f123b7:	db "",00
Y24f123b8:	db "",00
Y24f123b9:	db "",00
Y24f123ba:	db "",00
Y24f123bb:	db "",00
Y24f123bc:	db "",00
Y24f123bd:	db "jn3dem1.mac",00
Y24f123c9:	db "jn3dem2.mac",00
Y24f123d5:	db "jn3dem3.mac",00
Y24f123e1:	db "",00
Y24f123e2:	db "",00
Y24f123e3:	db "",00
Y24f123e4:	db "",00
Y24f123e5:	db "",00
Y24f123e6:	db "",00
Y24f123e7:	db "",00
Y24f123e8:	db "Look, an airplane!",00
Y24f123fb:	db "Are you just gonna sit there?",00
Y24f12419:	db "Have you seen Jill anywhere?",00
Y24f12436:	db "Hey,  your shoes are untied.",00
Y24f12453:	db "JILL ENTERS\rTHE\rJUNGLE MAP\r",00
Y24f1246f:	db "JILL ENTERS\rTHE VALLEY\r",00
Y24f12487:	db "JILL ROAMS\rTHROUGH THE\rVILLAGE\r",00
Y24f124a7:	db "JILL JOURNEYS\rTO THE DAM\r",00
Y24f124c1:	db "JILL DISCOVERS\rTHE SECRET FOREST\r",00
Y24f124e3:	db "JILL BOUNDS INTO\rTHE AERIE\r",00
Y24f124ff:	db "JILL EXPLORES\rTHE AQUEDUCT\r",00
Y24f1251b:	db "JILL BOARDS\rTHE SHIP OF\rTHE GIANT GREEN\rLIZARD MEN!\r",00
Y24f12550:	db "JILL VENTURES\rINTO THE\rMEGA PUZZLE\r",00
Y24f12574:	db "JILL JOURNEYS\rINTO THE JAIL\r",00
Y24f12591:	db "JILL TRYS HER\rLUCK IN THE\rPYRAMID PUZZLE.\r",00
Y24f125bc:	db "JILL LEAPS INTO\rLEVEL ELEVEN\r",00
Y24f125da:	db "IF YOU THINK THE\rNEXT LEVEL IS\rNUMBER TWELVE,\rYOU'RE RIGHT!\r",00
Y24f12617:	db "JILL FINALLY\rDISCOVERS\rTHE CASTLE\r",00
Y24f1263a:	db "\r",00
Y24f1263c:	db "\r",00
Y24f1263e:	db "\r",00
Y24f12640:	db "\r",00
Y24f12642:	db "\r",00
Y24f12644:	db "\r",00
Y24f12646:	db "\r",00
Y24f12648:	db "21\r",00
Y24f1264c:	db "22\r",00
Y24f12650:	db "23\r",00
Y24f12654:	db "24\r",00
Y24f12658:	db "25\r",00
Y24f1265c:	db "26\r",00
Y24f12660:	db "27\r",00
Y24f12664:	db "28\r",00
Y24f12668:	db "29\r",00
Y24f1266c:	db "",00
Y24f1266d:	db "",00
Y24f1266e:	word
Y24f12670:	dw 0220
Y24f12672:	ds 0006
Y24f12678:	word
Y24f1267a:	db 00,13,02,02,04,05,06,08,08,08,14,15,05,13,ff,16
		db 05,11,02,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff
		db 05,05,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff
		db ff,ff,0f,ff,23,02,ff,0f,ff,ff,ff,ff,13,ff,ff,02
		db 02,05,0f,02,ff,ff,ff,13,ff,ff,ff,ff,ff,ff,ff,ff
		db 23,ff,ff,ff,ff,23,ff,13,ff,00
Y24f126d4:	dd A22d10007
Y24f126d8:	dd A22d10007
Y24f126dc:	dd A22d10007
Y24f126e0:	word
Y24f126e2:	dword
Y24f126e6:	dword
Y24f126ea:	dword
Y24f126ee:	word
Y24f126f0:	byte
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
Y24f127f1:	byte
Y24f127f2:	db 01,20,02,20,02,20,04,a0,02,a0
Y24f127fc:	db ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff
		db ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff
Y24f1281a:	dw 4000
Y24f1281c:	dw ffff
Y24f1281e:	db "print scanf : floating point formats not linked\r\n",00
Y24f12850:	db "(null)",00
Y24f12857:	db "0123456789ABCDEF",00
Y24f12868:	db 14,14,01,14,15,14,14,14,14,02,00,14,03,04,14,09
		db 05,05,05,05,05,05,05,05,05,14,14,14,14,14,14,14
		db 14,14,14,14,0f,17,0f,08,14,14,14,07,14,16,14,14
		db 14,14,14,14,14,14,14,0d,14,14,14,14,14,14,14,14
		db 14,14,10,0a,0f,0f,0f,08,0a,14,14,06,14,12,0b,0e
		db 14,14,11,14,0c,14,14,0d,14,14,14,14,14,14,14,00
Y24f128c8:	ds 000f
Y24f128d7:	dw 0001
Y24f128d9:	db "COMPAQ",00
Y24f128e0:	db 01,00,00,00
Y24f128e4:	dw offset A076a019f
Y24f128e6:	dw offset A076a019f
Y24f128e8:	dw offset A076a0423
Y24f128ea:	dd A076a03a9
Y24f128ee:	dd A076a03ae
Y24f128f2:	dd A076a03ae
Y24f128f6:	dd A076a03ae

;; BSS Area
Y24f128fa:	ds 0100
Y24f129fa:	ds 0050
Y24f12a4a:	ds 0080
Y24f12aca:	ds 0080
Y24f12b4a:	ds 0080
Y24f12bca:	ds 0100
Y24f12cca:	dword
Y24f12cce:	ds 0800
Y24f134ce:	ds 0010
Y24f134de:	word
Y24f134e0:	word
Y24f134e2:	byte
Y24f134e3:	word
Y24f134e5:	word
Y24f134e7:	word
Y24f134e9:	byte
Y24f134ea:	word
Y24f134ec:	word
Y24f134ee:	word
Y24f134f0:	dword
Y24f134f4:	dword
Y24f134f8:	dword
Y24f134fc:	word
Y24f134fe:	byte
Y24f134ff:	byte
Y24f13500:	ds 0200
Y24f13700:	byte
Y24f13701:	byte
Y24f13702:	byte
Y24f13703:	byte
Y24f13704:	word
Y24f13706:	word
Y24f13708:	word
Y24f1370a:	word
Y24f1370c:	ds 0006
Y24f13712:	word
Y24f13714:	word
Y24f13716:	word
Y24f13718:	word
Y24f1371a:	word
Y24f1371c:	word
Y24f1371e:	word
Y24f13720:	word
Y24f13722:	word
Y24f13724:	word
Y24f13726:	word
Y24f13728:	word
Y24f1372a:	ds 0100
Y24f1382a:	word
Y24f1382c:	word
Y24f1382e:	word
Y24f13830:	word
Y24f13832:	word
Y24f13834:	word
Y24f13836:	word
Y24f13838:	word
Y24f1383a:	word
Y24f1383c:	word
Y24f1383e:	ds 0020
Y24f1385e:	word
Y24f13860:	word
Y24f13862:	word
Y24f13864:	word
Y24f13866:	word
Y24f13868:	word
Y24f1386a:	ds 0056
Y24f138c0:	word
Y24f138c2:	word
Y24f138c4:	ds 0064
Y24f13928:	ds 0064
Y24f1398c:	dword
Y24f13990:	ds 00c8
Y24f13a58:	word
Y24f13a5a:	ds 0200
Y24f13c5a:	ds 0050
Y24f13caa:	ds 00c8
Y24f13d72:	word
Y24f13d74:	word
Y24f13d76:	dword
Y24f13d7a:	word
Y24f13d7c:	ds 00a0
Y24f13e1c:	word
Y24f13e1e:	dword
Y24f13e22:	word
Y24f13e24:	word
Y24f13e26:	word
Y24f13e28:	dword
Y24f13e2c:	dword
Y24f13e30:	word
Y24f13e32:	word
Y24f13e34:	word
Y24f13e36:	word
Y24f13e38:	word
Y24f13e3a:	word
Y24f13e3c:	word
Y24f13e3e:	word
Y24f13e40:	ds 2*0080*0040
Y24f17e40:	ds 0046
Y24f17e86:	ds 8*0258
Y24f19146:	ds 1f*0102
Y24f1b084:	ds 000c*000a
Y24f1b0fc:	ds 003c
Y24f1b138:	ds 0010
Y24f1b148:	dword
Y24f1b14c:	word
Y24f1b14e:	word
Y24f1b150:	ds 2*0045
Y24f1b1da:	ds 2*0045
Y24f1b264:	ds 0028
Y24f1b28c:	dword
Y24f1b290:	ds 0058
Y24f1b2e8:	ds 4*0045
Y24f1b3fc:	ds 0020
Y24f1b41c:	dword
Y24f1b420:	ds 0010
Y24f1b430:	word
Y24f1b432:	word
Y24f1b434:	word
Y24f1b436:	ds 4*0045
Y24f1b54a:	word
Y24f1b54c:	word
Y24f1b54e:	ds 0048
Y24f1b596:	ds 0040
Y24f1b5d6:	ds 0020
Y24f1b5f6:	word
Y24f1b5f8:	ds 0020
Y24f1b618:	ds 2*0045
Y24f1b6a2:	ds 2*0045
Y24f1b72c:	ds 0058
Y24f1b784:	word
Y24f1b786:	ds 0180
Y24f1b906:	ds 0300
Y24f1bc06:	ds 000c
Y24f1bc12:	word
Y24f1bc14:	word
Y24f1bc16:	ds 2*0045
Y24f1bca0:	word
Y24f1bca2:	word
Y24f1bca4:	word
Y24f1bca6:	word
Y24f1bca8:	word
Y24f1bcaa:	word
Y24f1bcac:	ds 0080
Y24f1bd2c:	word
X24f1bd2e:	ds 0002

Segment 30c4 ;; Stack Area
Y30c40000:	ds 00c0	;; 24f1bd30
Y30c400c0:	ds 000c	;; 24f1bdf0
Y30c400cc:	dword	;; 24f1bdfc
Y30c400d0:	dword	;; 24f1be00
Y30c400d4:	word	;; 24f1be04
Y30c400d6:	word	;; 24f1be06
Y30c400d8:	word	;; 24f1be08
Y30c400da:	word	;; 24f1be0a
Y30c400dc:	word	;; 24f1be0c
Y30c400de:	word	;; 24f1be0e
Y30c400e0:	dword	;; 24f1be10
Y30c400e4:	dw ffff	;; 24f1be14
Y30c400e6:	;; 24f1be16

;; === External Data Module ===
Segment 30d2 ;; Sound Segment
Y30d20006:	;; 30c400e6 ;; 24f1be16
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
Y30d22806:	;; 30c428e6 ;; 24f1e616
		dw 0004,0008,0004,0002,0001,0004,0004,0004,000c,0002,0010,0010,0006,0002,0010,0010
		dw 0010,0010,0004,0004,0004,0001,0001,0001,0001,0001,0004,0004,0006,0002,0001,0001
		dw 0001,0004,0004,0002,0001,0001,0001,0001
