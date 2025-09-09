// STC     SR,Rn          0000 nnnn 0000 0010     SR~Rn
// STC     GBR,Rn         0000 nnnn 0001 0010     GBR ~Rn
// STC     VBR,Rn         0000 nnnn 0010 0010     VBR~Rn
// BRAF    Rm             0000 mmmm 0010 0011      Delayed branch, Rm + PC ~ PC
// BSRF    Rm             0000 mmmm 0000 0011      Delayed branch, PC ~ PR, Rm + PC ~ PC
// MOV.B   Rm,@(R0, Rn)   0000 nnnn mmmm 0100   Rm~ (R0+ Rn) 1
// MOV.W   Rm,@(R0,Rn)    0000 nnnn mmmm 0101   Rm~ (R0+ Rn)
// MUL.L   Rm,Rn* 2       0000 nnnn mmmm 0111     Rn x Rm ~ MACL, 2 to 4*132 x 32 ~ 32 bits
// MUL.L   Rm,Rn          0000 nnnn mmmm 0111     Rn x Rm ~ MACL (32x32→32 bits)
// CLRT                   0000 0000 0000 1000     0~T 0
// CLRMAC                 0000 0000 0010 1000     0 ~ MACH, MACL
// SETT                   0000 0000 0001 1000     1~T
// NOP                    0000 0000 0000 1001     No operation
// STS     MACH,Rn        0000 nnnn 0000 1010     MACH~Rn
// STS     MACL,Rn        0000 nnnn 0001 1010     MACL~Rn
// STS     PR,Rn          0000 nnnn 0010 1010     PR~Rn
// RTS                    0000 0000 0000 1011      Delayed branch, PR ~ PC
// RTE                    0000 0000 0010 1011     Delayed branch, stack area ~ 4 LSBPC/SR
// SLEEP                  0000 0000 0001 1011     Sleep 3•4
// MAC.L   @Rm+,@Rn+      0000 nnnn mmmm 1111     Signed operation of 3/(2 to 4)* 1*2 (Rn) x (Rm) + MAC~MAC32 x 32 + 64~ 64 bits
// MAC.L   @Rm+,@Rn+      0000 nnnn mmmm 1111     (Rn) x (Rm) + MAC ~ MAC (32x32+64→64 bits)

// MOV.L   Rm,@(disp, Rn) 0001 nnnn mmmm dddd   Rm~ (disp x4 +Rn)

// CMP/STR   Rm,Rn        0010 nnnn mmmm 1100     If Rn and Rm have an equivalent byte, 1 ~ T
// DIV0S     Rm,Rn        0010 nnnn mmmm 0111     MSB of Rn ~ Q, MSB of Rm ~ M
// MULS.W    Rm,Rn        0010 nnnn mmmm 1111     Signed Rn x Rm ~ MAC (16x16→32 bits)
// MULU.W    Rm,Rn        0010 nnnn mmmm 1110     Unsigned Rn x Rm ~ MAC (16x16→32 bits)
// CMP/STR   Rm,Rn        0010 nnnn mmmm 1100     If Rn and Rm have an Compariso equivalent byte, 1 ~ n result T
// DIVOS     Rm,Rn        0010 nnnn mmmm 0111     MSB of Rn ~a. Calculation MSB of Rm ~ M, M A resulta~r
// MULS.W    Rm,Rn        0010 nnnn mmmm 1111     Signed operation of 1 to 3*1RnxRm~MAC ·16 x 16 ~ 32 bits
// MULU.W    Rm,Rn        0010 nnnn mmmm 1110     Unsigned operation 1 to 3*1of Rn x Rm -t MAC16 x 16 -t 32 bits
// AND     Rm,Rn          0010 nnnn mmmm 1001     Rn & Rm -t Rn
// OR      Rm,Rn          0010 nnnn mmmm 1011     Rn I Rm -t Rn
// TST     Rrn,Rn         0010 nnnn mmmm 1000     Rn & Rm; if the result is Test 0, 1 -t T result
// XOR     Rm,Rn          0010 nnnn mmmm 1010     Rn I\ Rm.....+ Rn
// MOV.B   Rm,@Rn         0010 nnnn mmmm 0000   Rm~ (Rn)
// MOV.W   Rm,@Rn         0010 nnnn mmmm 0001   Rm~ (Rn)
// MOV.L   Rm,@Rn         0010 nnnn mmmm 0010   Rm~ (Rn)
// MOV.B   Rm,@-Rn        0010 nnnn mmmm 0100   Rn-1 ~Rn, Rm~ (Rn) 1
// MOV.W   Rm,@-Rn        0010 nnnn mmmm 0101   Rn-2 ~ Rn, Rm ~ (Rn) 1
// MOV.L   Rm,@-Rn        0010 nnnn mmmm 0110   Rn-4 ~ Rn, Rm ~ (Rn)

// ADD       Rm,Rn        0011 nnnn mmmm 1100     Rn + Rm ~ Rn
// ADDC      Rm,Rn        0011 nnnn mmmm 1110     Rn + Rm + T ~ Rn, Carry ~ T
// ADDV      Rm,Rn        0011 nnnn mmmm 1111     Rn + Rm ~ Rn, Overflow ~ T
// CMP/EQ    Rm,Rn        0011 nnnn mmmm 0000     If Rn = Rm, 1 ~ T
// CMP/HS    Rm,Rn        0011 nnnn mmmm 0010     If Rn ≥ Rm (unsigned), 1 ~ T
// CMP/GE    Rm,Rn        0011 nnnn mmmm 0011     If Rn ≥ Rm (signed), 1 ~ T
// CMP/HI    Rm,Rn        0011 nnnn mmmm 0110     If Rn > Rm (unsigned), 1 ~ T
// CMP/GT    Rm,Rn        0011 nnnn mmmm 0111     If Rn > Rm (signed), 1 ~ T
// DIV1      Rm,Rn        0011 nnnn mmmm 0100     Single-step division (Rn / Rm)
// DMULS.L   Rm,Rn        0011 nnnn mmmm 1101     Signed Rn x Rm ~ MACH, MACL (32x32→64 bits)
// DMULU.L   Rm,Rn        0011 nnnn mmmm 0101     Unsigned Rn x Rm ~ MACH, MACL (32x32→64 bits)
// SUB       Rm,Rn        0011 nnnn mmmm 1000     Rn - Rm ~ Rn
// SUBC      Rm,Rn        0011 nnnn mmmm 1010     Rn - Rm - T           ~ Rn, Borrow ~ T
// SUBV      Rm,Rn        0011 nnnn mmmm 1011     Rn - Rm ~ Rn, Underflow ~ T
// ADDC      Rm,Rn        0011 nnnn mmmm 1110     Rn + Rm + T ~ Rn, Carry Carry~ T
// ADDV      Rm,Rn        0011 nnnn mmmm 1111     Rn+ Rm~ Rn, Overflow Overflow~ T
// CMP/EQ    Rm,Rn        0011 nnnn mmmm 0000     If Rn =Rm, 1 ~ T Comparison result
// CMP/HS    Rm,Rn        0011 nnnn mmmm 0010     If Rn;o:Rm with Compariso unsigned data, 1 ~ T n result
// CMP/GE    Rm,Rn        0011 nnnn mmmm 0011     If Rn ;o: Rm with Compariso signed data, 1 ~ T n result
// CMP/HI    Rm,Rn        0011 nnnn mmmm 0110     If Rn > Rm with Comparisounsigned data, 1 ~ T n result
// CMP/GT    Rm,Rn        0011 nnnn mmmm 0111     If Rn > Rm with Comparisosigned data, 1 ~ T n result
// DIVl      Rm,Rn        0011 nnnn mmmm 0100     Single-step division Calculation (Rn/Rm) result
// DMULS.L   Rm,Rn* 2     0011 nnnn mmmm 1101     Signed operation of 2 to 4* 1 Rn x Rm ~ MACH,MACL 32 x 32 ~ 64 bits
// DMULU.L   Rm,Rn* 2     0011 nnnn mmmm 0101     Unsigned operation 2 to 4* 1 of Rn x Rm ~MACH,MACL 32 x 32 ~ 64 bits
// SUB       Rm,Rn        0011 nnnn mmmm 1000     Rn-Rm -t Rn
// SUBC      Rm,Rn        0011 nnnn mmmm 1010     Rn-Rm-T -t Rn, Borrow Borrow -t T
// SUBV      Rm,Rn        0011 nnnn mmmm 1011     Rn-Rm -t Rn, Underflow Underflow -t T]

// CMP/PL    Rn           0100 nnnn 0001 0101     If Rn > 0, 1 ~ T
// CMP/PZ    Rn           0100 nnnn 0001 0001     If Rn ≥ 0, 1 ~ T
// DT        Rn           0100 nnnn 0001 0000     Rn - 1 ~ Rn, if Rn == 0, 1 ~ T else 0 ~ T
// MAC.W     @Rm+,@Rn+    0100 nnnn mmmm 1111     (Rn) x (Rm) + MAC ~ MAC (16x16+64→64 bits)
// CMP/PL    Rn           0100 nnnn 0001 0101     If Rn> 0, 1 ~ T Comparison result
// CMP/PZ    Rn           0100 nnnn 0001 0001     If Rn ;o: 0, 1 ~ T Comparison result
// DT        Rn*2         0100 nnnn 0001 0000     Rn - 1 ~ Rn, when ComparisoRn is 0, 1 ~ T. When n resultRn is nonzero, 0 ~ T
// MAC.W     @Rm+,@Rn+    0100 nnnn mmmm 1111     Signed operation of 3/(2)* 1(Rn) x (Rm) + MAC~MAC(SH-2 CPU) 16 x 16 +64 ~ 64 bits(SH-1 CPU) 16 x 16 +42 ~ 42 bits
// TAS.B   @Rn            0100 nnnn 0001 1011     If (Rn) is 0, 1 -t T; 1 -t 4 Test MSB of (Rn) result
// ROTL    Rn             0100 nnnn 0000 0100     MSB of Rn -> T, Rn << 1 | T -> Rn
// ROTR    Rn             0100 nnnn 0000 0101     LSB of Rn -> T, Rn >> 1 | T << 31 -> Rn
// ROTCL   Rn             0100 nnnn 0010 0100     T -> MSB of Rn, Rn << 1 | T -> Rn
// ROTCR   Rn             0100 nnnn 0010 0101     T -> LSB of Rn, Rn >> 1 | T << 31 -> Rn
// SHAL    Rn             0100 nnnn 0010 0000     MSB of Rn -> T, Rn << 1 -> Rn
// SHAR    Rn             0100 nnnn 0010 0001     MSB of Rn -> T, Rn >> 1 (arithmetic) -> Rn
// SHLL    Rn             0100 nnnn 0000 0000     MSB of Rn -> T, Rn << 1 -> Rn
// SHLR    Rn             0100 nnnn 0000 0001     LSB of Rn -> T, Rn >> 1 -> Rn
// SHLL2   Rn             0100 nnnn 0000 1000     Rn << 2 -> Rn
// SHLR2   Rn             0100 nnnn 0000 1001     Rn >> 2 -> Rn
// SHLL8   Rn             0100 nnnn 0001 1000     Rn << 8 -> Rn
// SHLR8   Rn             0100 nnnn 0001 1001     Rn >> 8 -> Rn
// SHLL16  Rn             0100 nnnn 0010 1000     Rn << 16 -> Rn
// SHLR16  Rn             0100 nnnn 0010 1001     Rn >> 16 -> Rn
// JMP    @Rm             0100 mmmm 0010 1011      Delayed branch, Rm ~ PC
// JSR    @Rm             0100 mmmm 0000 1011      Delayed branch, PC ~ PR, Rm ~ PC
// LDC     Rm,SR          0100 mmmm 0000 1110     Rm~SR LSB
// LDC     Rm,GBR         0100 mmmm 0001 1110     Rm~GBR
// LDC     Rm,VBR         0100 mmmm 0010 1110     Rm~VBR
// LDC.L   @Rm+,SR        0100 mmmm 0000 0111     (Rm) ~sR, Rm+4~Rm 3 LSB
// LDC.L   @Rm+,GBR       0100 mmmm 0001 0111     (Rm) ~ GBR, Rm + 4 ~ Rm 3
// LDC.L   @Rm+,VBR       0100 mmmm 0010 0111     (Rm) ~VBR, Rm+4~Rm 3
// LDS     Rm,MACH        0100 mmmm 0000 1010     Rm~MACH
// LDS     Rm,MACL        0100 mmmm 0001 1010     Rm~MACL
// LDS     Rm,PR          0100 mmmm 0010 1010     Rm~PR
// LDS.L   @Rm+,MACH      0100 mmmm 0000 0110     (Rm)~MACH, Rm+4~Rm
// LDS.L   @Rm+,MACL      0100 mmmm 0001 0110     (Rm) ~ MACL, Rm + 4 ~Rm
// LDS.L   @Rm+,PR        0100 mmmm 0010 0110     (Rm)~ PR, Rm +4 ~Rm
// STC.L   SR,@-Rn        0100 nnnn 0000 0011     Rn-4~ Rn, SR~ (Rn) 2
// STC.L   GBR,@-Rn       0100 nnnn 0001 0011     Rn-4~ Rn, GBR ~(Rn) 2
// STC.L   VBR,@-Rn       0100 nnnn 0010 0011     Rn-4~ Rn, VBR ~(Rn) 2
// STS.L   MACH,@-Rn      0100 nnnn 0000 0010     Rn-4~ Rn, MACH ~(Rn)
// STS.L   MACL,@-Rn      0100 nnnn 0001 0010     Rn-4~ Rn, MACL ~(Rn)
// STS.L   PR,@-Rn        0100 nnnn 0010 0010     Rn-4~ Rn, PR~ (Rn)

// MOV.L   @(disp,Rm) ,Rn 0101 nnnn mmmm dddd   (disp x 4 + Rm) ~ Rn 1

// MOV     Rm,Rn          0110 nnnn mmmm 0011   Rm~Rn
// MOV.B   @Rm,Rn         0110 nnnn mmmm 0000   (Rm)~ Sign extension~ Rn
// MOV.W   @Rm,Rn         0110 nnnn mmmm 0001   (Rm) ~Sign extension ~ Rn
// MOV.L   @Rm,Rn         0110 nnnn mmmm 0010   (Rm)~ Rn
// MOV.B   @Rm+,Rn        0110 nnnn mmmm 0100   (Rm) ~Sign extension ~Rn,Rm+ 1 ~Rm
// MOV.W   @Rm+,Rn        0110 nnnn mmmm 0101   (Rm)~ Sign extension~ Rn,Rm +2 ~Rm
// MOV.L   @Rm+,Rn        0110 nnnn mmmm 0110   (Rm) ~Rn, Rm+ 4 ~ Rm
// EXTS.B    Rm,Rn        0110 nnnn mmmm 1110     Sign-extend byte in Rm ~ Rn
// EXTS.W    Rm,Rn        0110 nnnn mmmm 1111     Sign-extend word in Rm ~ Rn
// EXTU.B    Rm,Rn        0110 nnnn mmmm 1100     Zero-extend byte in Rm ~ Rn
// EXTU.W    Rm,Rn        0110 nnnn mmmm 1101     Zero-extend word in Rm ~ Rn
// NEG       Rm,Rn        0110 nnnn mmmm 1011     0 - Rm ~ Rn
// NEGC      Rm,Rn        0110 nnnn mmmm 1010     0 - Rm - T ~ Rn, Borrow ~ T
// EXTS.B    Rm,Rn        0110 nnnn mmmm 1110     A byte in Rm is sign-extended ~ Rn
// EXTS.W    Rm,Rn        0110 nnnn mmmm 1111     A word in Rm is sign-extended ~ Rn
// EXTU.B    Rm,Rn        0110 nnnn mmmm 1100     A byte in Rm is zero-extended ~ Rn
// EXTU.W    Rm,Rn        0110 nnnn mmmm 1101     A word in Rm is zero-extended ~ Rn
// NEG       Rm,Rn        0110 nnnn mmmm 1011     0-Rm -t Rn
// NEGC      Rm,Rn        0110 nnnn mmmm 1010     0-Rm-T -t Rn, BorrowBorrow -t T
// NOT       Rm,Rn        0110 nnnn mmmm 0111     -Rm -t Rn

// ADD       #imm,Rn      0111 nnnn iiii iiii     Rn + imm ~ Rn

// MOV.B   R0,@(disp,Rn)  1000 0000 nnnn dddd   R0~ (disp + Rn)
// MOV.W   R0,@(disp,Rn)  1000 0001 nnnn dddd   R0~ (disp x2 +Rn)
// MOV.B   @(disp,Rm),R0  1000 0100 mmmm dddd   (disp +Rm)~ Sign extension ~ R0
// MOV.W   @(disp,Rm) ,R0 1000 0101 mmmm dddd   (disp x 2 + Rm) ~ Sign extension ~ R0
// CMP/EQ    #imm,R0      1000 1000 iiii iiii     If R0 = imm, 1 ~ T
// CMP/EQ    #irrm,RO     1000 1000 iiii iiii     If RO =imm, 1 ~ T Comparison result
// BF     label           1000 1011 dddd dddd      If T = 0, disp x 2 + PC ~ PC; if T = 1, nop (where label is disp x 2 + PC)
// BF/S   label           1000 1111 dddd dddd      Delayed branch, if T = 0, disp x 2 + PC ~ PC; if T = 1, nop
// BT     label           1000 1001 dddd dddd      If T = 1, disp x 2 + PC ~ PC; if T = 0, nop (where label is disp x 2 + PC)
// BT/S   label           1000 1101 dddd dddd      Delayed branch, if T = 1, disp x 2 + PC ~ PC; if T = 0, nop

// MOV.W   @(disp,PC),Rn  1001 nnnn dddd dddd   (disp x 2 + PC) ~Sign extension ~ Rn

// BRA    label           1010 dddd dddd dddd      Delayed branch, disp x 2 + PC ~ PC

// BSR    label           1011 dddd dddd dddd      Delayed branch, PC ~ PR, disp x 2 + PC ~ PC

// AND    #imm,RO         1100 1001 iiii iiii     RO &imm-t RO
// AND.B  #imm,@(RO, GBR) 1100 1101 iiii iiii     (RO + GBR) & imm -t 3 (RO+ GBR)
// OR     #imm,RO         1100 1011 iiii iiii     RO I imm-t RO
// OR.B   imm,@ (RO, GBR) 1100 1111 iiii iiii     (RO + GBR) I imm -t 3 (RO+ GBR)
// TST    #imm,RO         1100 1000 iiii iiii     RO & imm; if the result Test is 0, 1 -t T result
// TST.B  #irrun,@(RO,GBR)1100 1100 iiii iiii     (RO + GBR) & imm; if 3 Test the result is 0, 1 .....+ T result
// XOR    #irrun,RO       1100 1010 iiii iiii     RO I\ imm --+ RO 1
// XOR.B  #irrun,@(RO,GBR)1100 1110 iiii iiii     (RO + GBR) I\ imm --+ 3(RO+ GBR)
// TRAPA  ltimm           1100 0011 iiii iiii     PC/SR ~ stack area, (imm x 84+ VBR) ~PC

// MOV.L   @(disp,PC),Rn  1101 nnnn dddd dddd   (disp x 4 + PC) ~Rn

// MOV     #imm,Rn        1110 nnnn iiii iiii   imm ~ Sign extension ~ Rn











