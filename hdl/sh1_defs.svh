package sh1

enum logic[2:0] {
    FETCH = 3'd0,
    DECODE = 3'd1,
    EXECUTE = 3'd2,
    MEMORY = 3'd3,
    WRITEBACK = 3'd4
} pipeline_stage_e;

// Control registers are SR, GBR and VBR    
enum logic [1:0] {
    SR  = 2'd0,
    GBR = 2'd1,
    VBR = 2'd2
} control_registers_e;

// SR has 9 flags: T, S, I(4 bits), Q, and M
enum logic [3:0] {
    T = 0,
    S = 1,
    I0 = 4,
    I1 = 5,
    I2 = 6,
    I3 = 7,
    Q = 8,
    M = 9
} sr_flags_e;

// General purpose registers R0-R15 (R15 is also the stack pointer)
enum logic [3:0] {
    R0 = 4'd0,
    R1 = 4'd1,
    R2 = 4'd2,
    R3 = 4'd3,
    R4 = 4'd4,
    R5 = 4'd5,
    R6 = 4'd6,
    R7 = 4'd7,
    R8 = 4'd8,
    R9 = 4'd9,
    R10 = 4'd10,
    R11 = 4'd11,
    R12 = 4'd12,
    R13 = 4'd13,
    R14 = 4'd14,
    R15 = 4'd15
    SP = R15, // Stack Pointer
} general_purpose_registers_e;



endpackage


// ===== Data Transfer Instructions ==========================================
// Instruction            Code                  0peration State
// MOV     #imm,Rn        1110 nnnn iiii iiii   imm ~ Sign extension ~ Rn
// MOV.W   @(disp,PC),Rn  1001 nnnn dddd dddd   (disp x 2 + PC) ~Sign extension ~ Rn
// MOV.L   @(disp,PC),Rn  1101 nnnn dddd dddd   (disp x 4 + PC) ~Rn
// MOV     Rm,Rn          0110 nnnn mmmm 0011   Rm~Rn
// MOV.B   Rm,@Rn         0010 nnnn mmmm 0000   Rm~ (Rn)
// MOV.W   Rm,@Rn         0010 nnnn mmmm 0001   Rm~ (Rn)
// MOV.L   Rm,@Rn         0010 nnnn mmmm 0010   Rm~ (Rn)
// MOV.B   @Rm,Rn         0110 nnnn mmmm 0000   (Rm)~ Sign extension~ Rn
// MOV.W   @Rm,Rn         0110 nnnn mmmm 0001   (Rm) ~Sign extension ~ Rn
// MOV.L   @Rm,Rn         0110 nnnn mmmm 0010   (Rm)~ Rn
// MOV.B   Rm,@-Rn        0010 nnnn mmmm 0100   Rn-1 ~Rn, Rm~ (Rn) 1
// MOV.W   Rm,@-Rn        0010 nnnn mmmm 0101   Rn-2 ~ Rn, Rm ~ (Rn) 1
// MOV.L   Rm,@-Rn        0010 nnnn mmmm 0110   Rn-4 ~ Rn, Rm ~ (Rn)
// MOV.B   @Rm+,Rn        0110 nnnn mmmm 0100   (Rm) ~Sign extension ~Rn,Rm+ 1 ~Rm
// MOV.W   @Rm+,Rn        0110 nnnn mmmm 0101   (Rm)~ Sign extension~ Rn,Rm +2 ~Rm
// MOV.L   @Rm+,Rn        0110 nnnn mmmm 0110   (Rm) ~Rn, Rm+ 4 ~ Rm
// MOV.B   R0,@(disp,Rn)  1000 0000 nnnn dddd   R0~ (disp + Rn)
// MOV.W   R0,@(disp,Rn)  1000 0001 nnnn dddd   R0~ (disp x2 +Rn)
// MOV.L   Rm,@(disp, Rn) 0001 nnnn mmmm dddd   Rm~ (disp x4 +Rn)
// MOV.B   @(disp,Rm),R0  1000 0100 mmmm dddd   (disp +Rm)~ Sign extension ~ R0
// MOV.W   @(disp,Rm) ,R0 1000 0101 mmmm dddd   (disp x 2 + Rm) ~ Sign extension ~ R0
// MOV.L   @(disp,Rm) ,Rn 0101 nnnn mmmm dddd   (disp x 4 + Rm) ~ Rn 1
// MOV.B   Rm,@(R0, Rn)   0000 nnnn mmmm 0100   Rm~ (R0+ Rn) 1
// MOV.W   Rm,@(R0,Rn)    0000 nnnn mmmm 0101   Rm~ (R0+ Rn)

// ===== Arithmetic Instructions =============================================
// Instruction         Code                    Operation State
// ADD       Rm,Rn     0011 nnnn mmmm 1100     Rn + Rm ~ Rn
// ADD       #imm,Rn   0111 nnnn iiii iiii     Rn + imm ~ Rn
// ADDC      Rm,Rn     0011 nnnn mmmm 1110     Rn + Rm + T ~ Rn, Carry ~ T
// ADDV      Rm,Rn     0011 nnnn mmmm 1111     Rn + Rm ~ Rn, Overflow ~ T
// CMP/EQ    #imm,R0   1000 1000 iiii iiii     If R0 = imm, 1 ~ T
// CMP/EQ    Rm,Rn     0011 nnnn mmmm 0000     If Rn = Rm, 1 ~ T
// CMP/HS    Rm,Rn     0011 nnnn mmmm 0010     If Rn ≥ Rm (unsigned), 1 ~ T
// CMP/GE    Rm,Rn     0011 nnnn mmmm 0011     If Rn ≥ Rm (signed), 1 ~ T
// CMP/HI    Rm,Rn     0011 nnnn mmmm 0110     If Rn > Rm (unsigned), 1 ~ T
// CMP/GT    Rm,Rn     0011 nnnn mmmm 0111     If Rn > Rm (signed), 1 ~ T
// CMP/PL    Rn        0100 nnnn 0001 0101     If Rn > 0, 1 ~ T
// CMP/PZ    Rn        0100 nnnn 0001 0001     If Rn ≥ 0, 1 ~ T
// CMP/STR   Rm,Rn     0010 nnnn mmmm 1100     If Rn and Rm have an equivalent byte, 1 ~ T
// DIV1      Rm,Rn     0011 nnnn mmmm 0100     Single-step division (Rn / Rm)
// DIV0S     Rm,Rn     0010 nnnn mmmm 0111     MSB of Rn ~ Q, MSB of Rm ~ M
// DMULS.L   Rm,Rn     0011 nnnn mmmm 1101     Signed Rn x Rm ~ MACH, MACL (32x32→64 bits)
// DMULU.L   Rm,Rn     0011 nnnn mmmm 0101     Unsigned Rn x Rm ~ MACH, MACL (32x32→64 bits)
// DT        Rn        0100 nnnn 0001 0000     Rn - 1 ~ Rn, if Rn == 0, 1 ~ T else 0 ~ T
// EXTS.B    Rm,Rn     0110 nnnn mmmm 1110     Sign-extend byte in Rm ~ Rn
// EXTS.W    Rm,Rn     0110 nnnn mmmm 1111     Sign-extend word in Rm ~ Rn
// EXTU.B    Rm,Rn     0110 nnnn mmmm 1100     Zero-extend byte in Rm ~ Rn
// EXTU.W    Rm,Rn     0110 nnnn mmmm 1101     Zero-extend word in Rm ~ Rn
// MAC.L     @Rm+,@Rn+ 0000 nnnn mmmm 1111     (Rn) x (Rm) + MAC ~ MAC (32x32+64→64 bits)
// MAC.W     @Rm+,@Rn+ 0100 nnnn mmmm 1111     (Rn) x (Rm) + MAC ~ MAC (16x16+64→64 bits)
// MUL.L     Rm,Rn     0000 nnnn mmmm 0111     Rn x Rm ~ MACL (32x32→32 bits)
// MULS.W    Rm,Rn     0010 nnnn mmmm 1111     Signed Rn x Rm ~ MAC (16x16→32 bits)
// MULU.W    Rm,Rn     0010 nnnn mmmm 1110     Unsigned Rn x Rm ~ MAC (16x16→32 bits)
// NEG       Rm,Rn     0110 nnnn mmmm 1011     0 - Rm ~ Rn
// NEGC      Rm,Rn     0110 nnnn mmmm 1010     0 - Rm - T ~ Rn, Borrow ~ T
// SUB       Rm,Rn     0011 nnnn mmmm 1000     Rn - Rm ~ Rn
// SUBC      Rm,Rn     0011 nnnn mmmm 1010     Rn - Rm - T           ~ Rn, Borrow ~ T
// SUBV      Rm,Rn     0011 nnnn mmmm 1011     Rn - Rm ~ Rn, Underflow ~ T
// ADDC      Rm,Rn     0011 nnnn mmmm 1110     Rn + Rm + T ~ Rn, Carry Carry~ T
// ADDV      Rm,Rn     0011 nnnn mmmm 1111     Rn+ Rm~ Rn, Overflow Overflow~ T
// CMP/EQ    #irrm,RO  1000 1000 iiii iiii     If RO =imm, 1 ~ T Comparison result
// CMP/EQ    Rm,Rn     0011 nnnn mmmm 0000     If Rn =Rm, 1 ~ T Comparison result
// CMP/HS    Rm,Rn     0011 nnnn mmmm 0010     If Rn;o:Rm with Compariso unsigned data, 1 ~ T n result
// CMP/GE    Rm,Rn     0011 nnnn mmmm 0011     If Rn ;o: Rm with Compariso signed data, 1 ~ T n result
// CMP/HI    Rm,Rn     0011 nnnn mmmm 0110     If Rn > Rm with Comparisounsigned data, 1 ~ T n result
// CMP/GT    Rm,Rn     0011 nnnn mmmm 0111     If Rn > Rm with Comparisosigned data, 1 ~ T n result
// CMP/PL    Rn        0100 nnnn 0001 0101     If Rn> 0, 1 ~ T Comparison result
// CMP/PZ    Rn        0100 nnnn 0001 0001     If Rn ;o: 0, 1 ~ T Comparison result
// CMP/STR   Rm,Rn     0010 nnnn mmmm 1100     If Rn and Rm have an Compariso equivalent byte, 1 ~ n result T
// DIVl      Rm,Rn     0011 nnnn mmmm 0100     Single-step division Calculation (Rn/Rm) result
// DIVOS     Rm,Rn     0010 nnnn mmmm 0111     MSB of Rn ~a. Calculation MSB of Rm ~ M, M A resulta~r
// DMULS.L   Rm,Rn* 2  0011 nnnn mmmm 1101     Signed operation of 2 to 4* 1 Rn x Rm ~ MACH,MACL 32 x 32 ~ 64 bits
// DMULU.L   Rm,Rn* 2  0011 nnnn mmmm 0101     Unsigned operation 2 to 4* 1 of Rn x Rm ~MACH,MACL 32 x 32 ~ 64 bits
// DT        Rn*2      0100 nnnn 0001 0000     Rn - 1 ~ Rn, when ComparisoRn is 0, 1 ~ T. When n resultRn is nonzero, 0 ~ T
// EXTS.B    Rm,Rn     0110 nnnn mmmm 1110     A byte in Rm is sign-extended ~ Rn
// EXTS.W    Rm,Rn     0110 nnnn mmmm 1111     A word in Rm is sign-extended ~ Rn
// EXTU.B    Rm,Rn     0110 nnnn mmmm 1100     A byte in Rm is zero-extended ~ Rn
// EXTU.W    Rm,Rn     0110 nnnn mmmm 1101     A word in Rm is zero-extended ~ Rn
// MAC.L     @Rm+,@Rn+ 0000 nnnn mmmm 1111     Signed operation of 3/(2 to 4)* 1*2 (Rn) x (Rm) + MAC~MAC32 x 32 + 64~ 64 bits
// MAC.W     @Rm+,@Rn+ 0100 nnnn mmmm 1111     Signed operation of 3/(2)* 1(Rn) x (Rm) + MAC~MAC(SH-2 CPU) 16 x 16 +64 ~ 64 bits(SH-1 CPU) 16 x 16 +42 ~ 42 bits
// MUL.L     Rm,Rn* 2  0000 nnnn mmmm 0111     Rn x Rm ~ MACL, 2 to 4*132 x 32 ~ 32 bits
// MULS.W    Rm,Rn     0010 nnnn mmmm 1111     Signed operation of 1 to 3*1RnxRm~MAC ·16 x 16 ~ 32 bits
// MULU.W    Rm,Rn     0010 nnnn mmmm 1110     Unsigned operation 1 to 3*1of Rn x Rm -t MAC16 x 16 -t 32 bits
// NEG       Rm,Rn     0110 nnnn mmmm 1011     0-Rm -t Rn
// NEGC      Rm,Rn     0110 nnnn mmmm 1010     0-Rm-T -t Rn, BorrowBorrow -t T
// SUB       Rm,Rn     0011 nnnn mmmm 1000     Rn-Rm -t Rn
// SUBC      Rm,Rn     0011 nnnn mmmm 1010     Rn-Rm-T -t Rn, Borrow Borrow -t T
// SUBV      Rm,Rn     0011 nnnn mmmm 1011     Rn-Rm -t Rn, Underflow Underflow -t T]

// ===== Logical Instructions ================================================
// Instruction              Code                    Operation State
// AND     Rm,Rn            0010 nnnn mmmm 1001     Rn & Rm -t Rn
// AND     #imm,RO          1100 1001 iiii iiii     RO &imm-t RO
// AND.B   #imm,@ (RO, GBR) 1100 1101 iiii iiii     (RO + GBR) & imm -t 3 (RO+ GBR)
// NOT     Rm,Rn            OllO nnnn mmmm 0111     -Rm -t Rn
// OR      Rm,Rn            0010 nnnn mmmm 1011     Rn I Rm -t Rn
// OR      #imm,RO          1100 1011 iiii iiii     RO I imm-t RO
// OR.B    #imm,@ (RO, GBR) llOO llll iiii iiii     (RO + GBR) I imm -t 3 (RO+ GBR)
// TAS.B   @Rn              0100 nnnn 0001 1011     If (Rn) is 0, 1 -t T; 1 -t 4 Test MSB of (Rn) result
// TST     Rrn,Rn           0010 nnnn mmmm 1000     Rn & Rm; if the result is Test 0, 1 -t T result
// TST     #imm,RO          1100 1000 iiii iiii     RO & imm; if the result Test is 0, 1 -t T result
// TST.B   #irrun,@(RO,GBR) 1100 1100 iiii iiii     (RO + GBR) & imm; if 3 Test the result is 0, 1 .....+ T result
// XOR     Rm,Rn            0010 nnnn mmmm 1010     Rn I\ Rm.....+ Rn
// XOR     #irrun,RO        1100 1010 iiii iiii     RO I\ imm --+ RO 1
// XOR.B   #irrun,@(RO,GBR) 1100 1110 iiii iiii     (RO + GBR) I\ imm --+ 3(RO+ GBR)

// ===== Shift Instructions ==================================================
// Instruction      Code                    Operation State
// ROTL    Rn       0100 nnnn 0000 0100     MSB of Rn -> T, Rn << 1 | T -> Rn
// ROTR    Rn       0100 nnnn 0000 0101     LSB of Rn -> T, Rn >> 1 | T << 31 -> Rn
// ROTCL   Rn       0100 nnnn 0010 0100     T -> MSB of Rn, Rn << 1 | T -> Rn
// ROTCR   Rn       0100 nnnn 0010 0101     T -> LSB of Rn, Rn >> 1 | T << 31 -> Rn
// SHAL    Rn       0100 nnnn 0010 0000     MSB of Rn -> T, Rn << 1 -> Rn
// SHAR    Rn       0100 nnnn 0010 0001     MSB of Rn -> T, Rn >> 1 (arithmetic) -> Rn
// SHLL    Rn       0100 nnnn 0000 0000     MSB of Rn -> T, Rn << 1 -> Rn
// SHLR    Rn       0100 nnnn 0000 0001     LSB of Rn -> T, Rn >> 1 -> Rn
// SHLL2   Rn       0100 nnnn 0000 1000     Rn << 2 -> Rn
// SHLR2   Rn       0100 nnnn 0000 1001     Rn >> 2 -> Rn
// SHLL8   Rn       0100 nnnn 0001 1000     Rn << 8 -> Rn
// SHLR8   Rn       0100 nnnn 0001 1001     Rn >> 8 -> Rn
// SHLL16  Rn       0100 nnnn 0010 1000     Rn << 16 -> Rn
// SHLR16  Rn       0100 nnnn 0010 1001     Rn >> 16 -> Rn

// ===== Branch Instructions ==================================================
// Instruction      Code                    Operation State
// BF     label     1000 1011 dddd dddd      If T = 0, disp x 2 + PC ~ PC; if T = 1, nop (where label is disp x 2 + PC)
// BF/S   label     1000 1111 dddd dddd      Delayed branch, if T = 0, disp x 2 + PC ~ PC; if T = 1, nop
// BT     label     1000 1001 dddd dddd      If T = 1, disp x 2 + PC ~ PC; if T = 0, nop (where label is disp x 2 + PC)
// BT/S   label     1000 1101 dddd dddd      Delayed branch, if T = 1, disp x 2 + PC ~ PC; if T = 0, nop
// BRA    label     1010 dddd dddd dddd      Delayed branch, disp x 2 + PC ~ PC
// BRAF   Rm        0000 mmmm 0010 0011      Delayed branch, Rm + PC ~ PC
// BSR    label     1011 dddd dddd dddd      Delayed branch, PC ~ PR, disp x 2 + PC ~ PC
// BSRF   Rm        0000 mmmm 0000 0011      Delayed branch, PC ~ PR, Rm + PC ~ PC
// JMP    @Rm       0100 mmmm 0010 1011      Delayed branch, Rm ~ PC
// JSR    @Rm       0100 mmmm 0000 1011      Delayed branch, PC ~ PR, Rm ~ PC
// RTS              0000 0000 0000 1011      Delayed branch, PR ~ PC

// ===== System Control Instructions ============================================
// Instruction       Code                    Operation State
// CLRT              0000 0000 0000 1000     0~T 0
// CLRMAC            0000 0000 0010 1000     0 ~ MACH, MACL
// LDC     Rm,SR     0100 mmmm 0000 1110     Rm~SR LSB
// LDC     Rm,GBR    0100 mmmm 0001 1110     Rm~GBR
// LDC     Rm,VBR    0100 mmmm 0010 1110     Rm~VBR
// LDC.L   @Rm+,SR   0100 mmmm 0000 0111     (Rm) ~sR, Rm+4~Rm 3 LSB
// LDC.L   @Rm+,GBR  0100 mmmm 0001 0111     (Rm) ~ GBR, Rm + 4 ~ Rm 3
// LDC.L   @Rm+,VBR  0100 mmmm 0010 0111     (Rm) ~VBR, Rm+4~Rm 3
// LDS     Rm,MACH   0100 mmmm 0000 1010     Rm~MACH
// LDS     Rm,MACL   0100 mmmm 0001 1010     Rm~MACL
// LDS     Rm,PR     0100 mmmm 0010 1010     Rm~PR
// LDS.L   @Rm+,MACH 0100 mmmm 0000 0110     (Rm)~MACH, Rm+4~Rm
// LDS.L   @Rm+,MACL 0100 mmmm 0001 0110     (Rm) ~ MACL, Rm + 4 ~Rm
// LDS.L   @Rm+,PR   0100 mmmm 0010 0110     (Rm)~ PR, Rm +4 ~Rm
// NOP               0000 0000 0000 1001     No operation
// RTE               0000 0000 0010 1011     Delayed branch, stack area ~ 4 LSBPC/SR
// SETT              0000 0000 0001 1000     1~T
// SLEEP             0000 0000 0001 1011     Sleep 3•4
// STC     SR,Rn     0000 nnnn 0000 0010     SR~Rn
// STC     GBR,Rn    0000 nnnn 0001 0010     GBR ~Rn
// STC     VBR,Rn    0000 nnnn 0010 0010     VBR~Rn
// STC.L   SR,@-Rn   0100 nnnn 0000 0011     Rn-4~ Rn, SR~ (Rn) 2
// STC.L   GBR,@-Rn  0100 nnnn 0001 0011     Rn-4~ Rn, GBR ~(Rn) 2
// STC.L   VBR,@-Rn  0100 nnnn 0010 0011     Rn-4~ Rn, VBR ~(Rn) 2
// STS     MACH,Rn   0000 nnnn 0000 1010     MACH~Rn
// STS     MACL,Rn   0000 nnnn 0001 1010     MACL~Rn
// STS     PR,Rn     0000 nnnn 0010 1010     PR~Rn
// STS.L   MACH,@-Rn 0100 nnnn 0000 0010     Rn-4~ Rn, MACH ~(Rn)
// STS.L   MACL,@-Rn 0100 nnnn 0001 0010     Rn-4~ Rn, MACL ~(Rn)
// STS.L   PR,@-Rn   0100 nnnn 0010 0010     Rn-4~ Rn, PR~ (Rn)
// TRAPA   ltimm     1100 0011 iiii iiii     PC/SR ~ stack area, (imm x 84+ VBR) ~PC