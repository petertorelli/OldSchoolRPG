     2   1    1:D     1 (*$L PRINTER: *)
     3   1    1:D     1 (* "$S++" OPTION BEFORE "$L" *)
     4   1    1:D     1 (*$R-*)
     5   1    1:D     1 (*$I-*)
     6   1    1:D     1 (*$V-*)
     7   1    1:D     1 
     8   1    1:D     1 (*
     9   1    1:D     1   WIZARDRY I (PROVING GROUNDS), WIZARDRY.CODE
    10   1    1:D     1   REVERSE ENGINEERED BY:
    11   1    1:D     1     
    12   1    1:D     1     THOMAS WILLIAM EWERS
    13   1    1:D     1       (MAR - JUN 2014)
    14   1    1:D     1 *)
    15   1    1:D     1 
    16   1    1:D     1 
    17   1    1:D     1 PROGRAM WIZARDRY;
    18   1    1:D     3 
    19   1    1:D     3   CONST
    20   1    1:D     3         BLOCKSZ = 512;
    21   1    1:D     3         DRIVE1  = 4;
    22   1    1:D     3         CRETURN = 13;
    23   1    1:D     3         
    24   1    1:D     3   TYPE
    25   1    1:D     3   
    26   1    1:D     3         TXGOTO = (XDONE,    XTRAININ, XCASTLE,  XGILGAMS, XINSPECT, XBOLTAC,
    27   1    1:D     3                   XCANT,    XRUNNER,  XCOMBAT,  XNEWMAZE, XCHK4WIN, XREWARD,
    28   1    1:D     3                   XINSPCT2, XEQUIP6,  XEQPDSP,  XREORDER, XCEMETRY, XINSPCT3,
    29   1    1:D     3                   XBCK2CMP, XBCK2ROL, XCMP2EQ6, XUNUSED,  XREWARD2, XSCNMSG,
    30   1    1:D     3                   XCAMPSTF, XEDGTOWN, XINSAREA, XBK2CMP2);
    31   1    1:D     3                   
    32   1    1:D     3         TWIZLONG = RECORD
    33   1    1:D     3             LOW  : INTEGER;
    34   1    1:D     3             MID  : INTEGER;
    35   1    1:D     3             HIGH : INTEGER;
    36   1    1:D     3           END;
    37   1    1:D     3                    
    38   1    1:D     3         TRACE = (NORACE, HUMAN, ELF, DWARF, GNOME, HOBBIT);
    39   1    1:D     3         
    40   1    1:D     3         TCLASS = (FIGHTER, MAGE, PRIEST, THIEF,
    41   1    1:D     3                   BISHOP, SAMURAI, LORD, NINJA);
    42   1    1:D     3           
    43   1    1:D     3         TALIGN = (UNALIGN, GOOD, NEUTRAL, EVIL);
    44   1    1:D     3           
    45   1    1:D     3         TSTATUS = (OK, AFRAID, ASLEEP, PLYZE, 
    46   1    1:D     3                    STONED, DEAD, ASHES, LOST);
    47   1    1:D     3         
    48   1    1:D     3         TATTRIB = (STRENGTH, IQ, PIETY, VITALITY, AGILITY, LUCK);
    49   1    1:D     3         
    50   1    1:D     3         TSPELL7G = ARRAY[ 1..7] OF INTEGER;
    51   1    1:D     3         
    52   1    1:D     3         THPREC = RECORD
    53   1    1:D     3             LEVEL   : INTEGER;
    54   1    1:D     3             HPFAC   : INTEGER;
    55   1    1:D     3             HPMINAD : INTEGER;
    56   1    1:D     3           END;
    57   1    1:D     3                  
    58   1    1:D     3         TCHAR = RECORD
    59   1    1:D     3             NAME     : STRING[ 15];
    60   1    1:D     3             PASSWORD : STRING[ 15];
    61   1    1:D     3             INMAZE   : BOOLEAN;
    62   1    1:D     3             RACE     : TRACE;
    63   1    1:D     3             CLASS    : TCLASS;
    64   1    1:D     3             AGE      : INTEGER;
    65   1    1:D     3             STATUS   : TSTATUS;
    66   1    1:D     3             ALIGN    : TALIGN;
    67   1    1:D     3             ATTRIB   : PACKED ARRAY[ STRENGTH..LUCK] OF 0..18;
    68   1    1:D     3             LUCKSKIL : PACKED ARRAY[ 0..4] OF 0..31;
    69   1    1:D     3             GOLD     : TWIZLONG;
    70   1    1:D     3             POSS     : RECORD
    71   1    1:D     3                 POSSCNT : INTEGER;
    72   1    1:D     3                 POSSESS : ARRAY[ 1..8] OF RECORD
    73   1    1:D     3                     EQUIPED : BOOLEAN;
    74   1    1:D     3                     CURSED  : BOOLEAN;
    75   1    1:D     3                     IDENTIF : BOOLEAN;
    76   1    1:D     3                     EQINDEX : INTEGER;
    77   1    1:D     3                   END;
    78   1    1:D     3               END;
    79   1    1:D     3             EXP      : TWIZLONG;
    80   1    1:D     3             MAXLEVAC : INTEGER;
    81   1    1:D     3             CHARLEV  : INTEGER;
    82   1    1:D     3             HPLEFT   : INTEGER;
    83   1    1:D     3             HPMAX    : INTEGER;
    84   1    1:D     3             SPELLSKN : PACKED ARRAY[ 0..49] OF BOOLEAN;
    85   1    1:D     3             MAGESP   : TSPELL7G;
    86   1    1:D     3             PRIESTSP : TSPELL7G;
    87   1    1:D     3             HPCALCMD : INTEGER;
    88   1    1:D     3             ARMORCL  : INTEGER;
    89   1    1:D     3             HEALPTS  : INTEGER;
    90   1    1:D     3             CRITHITM : BOOLEAN;
    91   1    1:D     3             SWINGCNT : INTEGER;
    92   1    1:D     3             HPDAMRC  : THPREC;
    93   1    1:D     3             WEPVSTY2 : PACKED ARRAY[ 0..1, 0..13] OF BOOLEAN;
    94   1    1:D     3             WEPVSTY3 : PACKED ARRAY[ 0..1, 0..6] OF BOOLEAN;
    95   1    1:D     3             WEPVSTYP : PACKED ARRAY[ 0..13] OF BOOLEAN;
    96   1    1:D     3             LOSTXYL  : RECORD CASE INTEGER OF
    97   1    1:D     3                 1:  (LOCATION : ARRAY[ 1..4] OF INTEGER);
    98   1    1:D     3                 2:  (POISNAMT : ARRAY[ 1..4] OF INTEGER);
    99   1    1:D     3                 3:  (AWARDS   : ARRAY[ 1..4] OF INTEGER);
   100   1    1:D     3               END;
   101   1    1:D     3           END;
   102   1    1:D     3               
   103   1    1:D     3         TOBJTYPE = (WEAPON, ARMOR, SHIELD, HELMET, GAUNTLET,
   104   1    1:D     3                     SPECIAL, MISC);
   105   1    1:D     3                           
   106   1    1:D     3         TOBJREC = RECORD
   107   1    1:D     3             NAME     : STRING[ 15];
   108   1    1:D     3             NAMEUNK  : STRING[ 15];
   109   1    1:D     3             OBJTYPE  : TOBJTYPE;
   110   1    1:D     3             ALIGN    : TALIGN;
   111   1    1:D     3             CURSED   : BOOLEAN;
   112   1    1:D     3             SPECIAL  : INTEGER;
   113   1    1:D     3             CHANGETO : INTEGER;
   114   1    1:D     3             CHGCHANC : INTEGER;
   115   1    1:D     3             PRICE    : TWIZLONG;
   116   1    1:D     3             BOLTACXX : INTEGER;
   117   1    1:D     3             SPELLPWR : INTEGER;
   118   1    1:D     3             CLASSUSE : PACKED ARRAY[ TCLASS] OF BOOLEAN;
   119   1    1:D     3             HEALPTS  : INTEGER;
   120   1    1:D     3             WEPVSTY2 : PACKED ARRAY[ 0..15] OF BOOLEAN;
   121   1    1:D     3             WEPVSTY3 : PACKED ARRAY[ 0..15] OF BOOLEAN;
   122   1    1:D     3             ARMORMOD : INTEGER;
   123   1    1:D     3             WEPHITMD : INTEGER;
   124   1    1:D     3             WEPHPDAM : THPREC;
   125   1    1:D     3             XTRASWNG : INTEGER;
   126   1    1:D     3             CRITHITM : BOOLEAN;
   127   1    1:D     3             WEPVSTYP : PACKED ARRAY[ 0..13] OF BOOLEAN;
   128   1    1:D     3           END;
   129   1    1:D     3 
   130   1    1:D     3         TWALL = (OPEN, WALL, DOOR, HIDEDOOR);
   131   1    1:D     3    
   132   1    1:D     3         TSQUARE = (NORMAL, STAIRS, PIT, CHUTE, SPINNER, DARK, TRANSFER,
   133   1    1:D     3                    OUCHY, BUTTONZ, ROCKWATE, FIZZLE, SCNMSG, ENCOUNTE);
   134   1    1:D     3    
   135   1    1:D     3         TMAZE = RECORD
   136   1    1:D     3             W : PACKED ARRAY[ 0..19] OF PACKED ARRAY[ 0..19] OF TWALL;
   137   1    1:D     3             S : PACKED ARRAY[ 0..19] OF PACKED ARRAY[ 0..19] OF TWALL;
   138   1    1:D     3             E : PACKED ARRAY[ 0..19] OF PACKED ARRAY[ 0..19] OF TWALL;
   139   1    1:D     3             N : PACKED ARRAY[ 0..19] OF PACKED ARRAY[ 0..19] OF TWALL;
   140   1    1:D     3             
   141   1    1:D     3             FIGHTS : PACKED ARRAY[ 0..19] OF PACKED ARRAY[ 0..19] OF 0..1;
   142   1    1:D     3                        
   143   1    1:D     3             SQREXTRA : PACKED ARRAY[ 0..19] OF PACKED ARRAY[ 0..19] OF 0..15;
   144   1    1:D     3                        
   145   1    1:D     3             SQRETYPE : PACKED ARRAY[ 0..15] OF TSQUARE;
   146   1    1:D     3             
   147   1    1:D     3             AUX0   : PACKED ARRAY[ 0..15] OF INTEGER;
   148   1    1:D     3             AUX1   : PACKED ARRAY[ 0..15] OF INTEGER;
   149   1    1:D     3             AUX2   : PACKED ARRAY[ 0..15] OF INTEGER;
   150   1    1:D     3                        
   151   1    1:D     3             ENMYCALC : PACKED ARRAY[ 1..3] OF RECORD
   152   1    1:D     3                          MINENEMY : INTEGER;
   153   1    1:D     3                          MULTWORS : INTEGER;
   154   1    1:D     3                          WORSE01  : INTEGER;
   155   1    1:D     3                          RANGE0N  : INTEGER;
   156   1    1:D     3                          PERCWORS : INTEGER;
   157   1    1:D     3                        END;
   158   1    1:D     3           END;
   159   1    1:D     3         
   160   1    1:D     3         TENEMY = RECORD
   161   1    1:D     3             NAMEUNK  : STRING[ 15];
   162   1    1:D     3             NAMEUNKS : STRING[ 15];
   163   1    1:D     3             NAME     : STRING[ 15];
   164   1    1:D     3             NAMES    : STRING[ 15];
   165   1    1:D     3             PIC      : INTEGER;
   166   1    1:D     3             CALC1    : TWIZLONG;
   167   1    1:D     3             HPREC    : THPREC;
   168   1    1:D     3             CLASS    : INTEGER;
   169   1    1:D     3             AC       : INTEGER;
   170   1    1:D     3             RECSN    : INTEGER;
   171   1    1:D     3             RECS     : ARRAY[ 1..7] OF THPREC;
   172   1    1:D     3             EXPAMT   : TWIZLONG;
   173   1    1:D     3             DRAINAMT : INTEGER;
   174   1    1:D     3             HEALPTS  : INTEGER;
   175   1    1:D     3             REWARD1  : INTEGER;
   176   1    1:D     3             REWARD2  : INTEGER;
   177   1    1:D     3             ENMYTEAM : INTEGER;
   178   1    1:D     3             TEAMPERC : INTEGER;
   179   1    1:D     3             MAGSPELS : INTEGER;
   180   1    1:D     3             PRISPELS : INTEGER;
   181   1    1:D     3             UNIQUE   : INTEGER;
   182   1    1:D     3             BREATHE  : INTEGER;
   183   1    1:D     3             UNAFFCT  : INTEGER;
   184   1    1:D     3             WEPVSTY3 : PACKED ARRAY[ 0..15] OF BOOLEAN;
   185   1    1:D     3             SPPC     : PACKED ARRAY[ 0..15] OF BOOLEAN;
   186   1    1:D     3           END;
   187   1    1:D     3                  
   188   1    1:D     3         TENEMY2 = RECORD
   189   1    1:D     3             A : RECORD
   190   1    1:D     3                     IDENTIFI : BOOLEAN;
   191   1    1:D     3                     ALIVECNT : INTEGER;
   192   1    1:D     3                     ENMYCNT  : INTEGER;
   193   1    1:D     3                     ENEMYID  : INTEGER;
   194   1    1:D     3                     TEMP04   : ARRAY[ 0..8] OF RECORD
   195   1    1:D     3                         VICTIM   : INTEGER;
   196   1    1:D     3                         SPELLHSH : INTEGER;
   197   1    1:D     3                         AGILITY  : INTEGER;
   198   1    1:D     3                         HPLEFT   : INTEGER;
   199   1    1:D     3                         ARMORCL  : INTEGER;
   200   1    1:D     3                         INAUDCNT : INTEGER;
   201   1    1:D     3                         STATUS   : TSTATUS;
   202   1    1:D     3                       END;
   203   1    1:D     3                   END;
   204   1    1:D     3                 
   205   1    1:D     3             B : TENEMY;
   206   1    1:D     3           END;
   207   1    1:D     3                    
   208   1    1:D     3         TEXP = ARRAY[ FIGHTER..NINJA] OF ARRAY[ 0..12] OF TWIZLONG;
   209   1    1:D     3         
   210   1    1:D     3         TBCD = ARRAY[ 0..13] OF INTEGER;
   211   1    1:D     3                    
   212   1    1:D     3         TSPEL012 = (GENERIC, PERSON, GROUP);
   213   1    1:D     3         
   214   1    1:D     3         TZSCN = (ZZERO, ZMAZE, ZENEMY, ZREWARD, ZOBJECT,
   215   1    1:D     3                         ZCHAR, ZSPCCHRS, ZEXP);
   216   1    1:D     3                    
   217   1    1:D     3         TSCNTOC = RECORD
   218   1    1:D     3             GAMENAME : STRING[ 40];
   219   1    1:D     3             RECPER2B : ARRAY[ ZZERO..ZEXP] OF INTEGER;
   220   1    1:D     3             RECPERDK : ARRAY[ ZZERO..ZEXP] OF INTEGER;
   221   1    1:D     3             UNUSEDXX : ARRAY[ ZZERO..ZEXP] OF INTEGER;
   222   1    1:D     3             BLOFF    : ARRAY[ ZZERO..ZEXP] OF INTEGER;
   223   1    1:D     3             RACE     : ARRAY[ NORACE..HOBBIT]         OF STRING[ 9];
   224   1    1:D     3             CLASS    : PACKED ARRAY[ FIGHTER..NINJA]  OF STRING[ 9];
   225   1    1:D     3             STATUS   : ARRAY[ OK..LOST]               OF STRING[ 8];
   226   1    1:D     3             ALIGN    : PACKED ARRAY[ UNALIGN..EVIL]   OF STRING[ 9];
   227   1    1:D     3             SPELLHSH : PACKED ARRAY[ 0..50] OF INTEGER;
   228   1    1:D     3             SPELLGRP : PACKED ARRAY[ 0..50] OF 0..7;
   229   1    1:D     3             SPELL012 : PACKED ARRAY[ 0..50] OF TSPEL012;
   230   1    1:D     3           END;
   231   1    1:D     3     
   232   1    1:D     3         TBATRSLT = RECORD
   233   1    1:D     3             ENMYCNT : ARRAY[ 1..4] OF INTEGER;
   234   1    1:D     3             ENMYID  : ARRAY[ 1..4] OF INTEGER;
   235   1    1:D     3             DRAINED : ARRAY[ 0..5] OF BOOLEAN;
   236   1    1:D     3           END;
   237   1    1:D     3           
   238   1    1:D     3         TCHRIMAG = PACKED ARRAY[ 0..7] OF 0..255;
   239   1    1:D     3         
   240   1    1:D     3         
   241   1    1:D     3   VAR
   242   1    1:D     3   
   243   1    1:D     3        PARTYCNT : INTEGER;
   244   1    1:D     4        CACHEBL  : INTEGER;
   245   1    1:D     5        SCNTOCBL : INTEGER;
   246   1    1:D     6        LLBASE04 : INTEGER;  (* REALLY BASE.06 IN WIZ1, BUT IS BASE04 IN LOL *)
   247   1    1:D     7        TIMEDLAY : INTEGER;
   248   1    1:D     8        CACHEWRI : BOOLEAN;
   249   1    1:D     9        INCHAR   : CHAR;
   250   1    1:D    10        XGOTO    : TXGOTO;
   251   1    1:D    11        XGOTO2   : TXGOTO;
   252   1    1:D    12        ATTK012  : INTEGER;
   253   1    1:D    13        FIZZLES  : INTEGER;
   254   1    1:D    14        CHSTALRM : INTEGER;
   255   1    1:D    15        LIGHT    : INTEGER;
   256   1    1:D    16        ACMOD2   : INTEGER;
   257   1    1:D    17        ENSTRENG : INTEGER;
   258   1    1:D    18        BASE12   : RECORD CASE INTEGER OF      (* BASE291 IN LOL *)
   259   1    1:D    18                     1: (MYSTRENG : INTEGER);
   260   1    1:D    18                     2: (GOTOX    : TXGOTO);
   261   1    1:D    18                   END;
   262   1    1:D    19        ENEMYINX : INTEGER;
   263   1    1:D    20        SAVELEV  : INTEGER;
   264   1    1:D    21        SAVEY    : INTEGER;
   265   1    1:D    22        SAVEX    : INTEGER;
   266   1    1:D    23        DIRECTIO : INTEGER;
   267   1    1:D    24        MAZELEV  : INTEGER;
   268   1    1:D    25        MAZEY    : INTEGER;
   269   1    1:D    26        MAZEX    : INTEGER;
   270   1    1:D    27        ENCB4RUN : BOOLEAN;
   271   1    1:D    28        FIGHTMAP : PACKED ARRAY[ 0..19, 0..19] OF BOOLEAN;
   272   1    1:D    68        CHARDISK : ARRAY[ 0..5] OF INTEGER;
   273   1    1:D    74        CHARACTR : ARRAY[ 0..5] OF TCHAR;
   274   1    1:D   698        SCNTOC   : TSCNTOC;
   275   1    1:D   950        IOCACHE  : PACKED ARRAY[ 0..1023] OF CHAR;
   276   1    1:D  1462        CHARSET  : PACKED ARRAY[ 0..63] OF TCHRIMAG;
   277   1    1:D  1718        BASE06B6 : INTEGER; (* UNUSED *)
   278   1    1:D  1719        MEMPTR   : RECORD CASE INTEGER OF
   279   1    1:D  1719                     1: (I : INTEGER);
   280   1    1:D  1719                     2: (P : ^INTEGER);
   281   1    1:D  1719                   END;
   282   1    1:D  1720        
   283   1    1:D  1720 
   284   1    1:D  1720 (* ---------- BEGIN FORWARD DECLARATIONS ---------- *)
   285   1    1:D  1720 
   286   1    2:D     1 PROCEDURE PRINTBEL; FORWARD;                   (* P010002 *)
   287   1    2:D     1 
   288   1    3:D     3 FUNCTION GETREC( DATATYPE: TZSCN;              (* P010003 *)
   289   1    3:D     4                  DATAINDX: INTEGER;
   290   1    3:D     5                  DATASIZE: INTEGER) : INTEGER; FORWARD;
   291   1    3:D     6                  
   292   1    4:D     3 FUNCTION GETRECW( DATATYPE: TZSCN;             (* P010004 *)
   293   1    4:D     4                   DATAINDX: INTEGER;
   294   1    4:D     5                   DATASIZE: INTEGER) : INTEGER; FORWARD;
   295   1    4:D     6                   
   296   1    5:D     1 PROCEDURE ADDLONGS( VAR FIRST:  TWIZLONG;      (* P010005 *)
   297   1    5:D     2                     VAR SECOND: TWIZLONG); FORWARD;
   298   1    5:D     3                     
   299   1    6:D     1 PROCEDURE SUBLONGS( VAR FIRST:  TWIZLONG;      (* P010006 *)
   300   1    6:D     2                     VAR SECOND: TWIZLONG); FORWARD;
   301   1    6:D     3                     
   302   1    7:D     1 PROCEDURE BCD2LONG( VAR LONGNUM: TWIZLONG;     (* P010007 *)
   303   1    7:D     2                     VAR BCDNUM:  TBCD); FORWARD;
   304   1    7:D     3                     
   305   1    8:D     1 PROCEDURE LONG2BCD( VAR LONGNUM: TWIZLONG;     (* P010008 *)
   306   1    8:D     2                     VAR BCDNUM:  TBCD); FORWARD;
   307   1    8:D     3                    
   308   1    9:D     1 PROCEDURE MULTLONG( VAR LONGNUM: TWIZLONG;     (* P010009 *)
   309   1    9:D     2                     VAR INTNUM:  INTEGER); FORWARD;
   310   1    9:D     3 
   311   1   10:D     1 PROCEDURE DIVLONG( VAR LONGNUM: TWIZLONG;      (* P01000A *)
   312   1   10:D     2                    VAR INTNUM:  INTEGER); FORWARD;
   313   1   10:D     3 
   314   1   11:D     3 FUNCTION TESTLONG( FIRST:  TWIZLONG;           (* P01000B *)
   315   1   11:D     4                    SECOND: TWIZLONG) : INTEGER; FORWARD;
   316   1   11:D    11 
   317   1   12:D     1 PROCEDURE PRNTLONG( LONGNUM: TWIZLONG); FORWARD;  (* P01000C *)
   318   1   12:D     5                          
   319   1   13:D     1 PROCEDURE GETKEY; FORWARD;                     (* P01000D *)
   320   1   13:D     1 
   321   1   14:D     1 PROCEDURE GETLINE( VAR GTSTRING: STRING); FORWARD; (* P01000E *)
   322   1   14:D     2 
   323   1   15:D     3 FUNCTION GETCHARX( DSPNAMES: BOOLEAN;          (* P01000F *)
   324   1   15:D     4                    SOLICIT: STRING) : INTEGER; FORWARD;
   325   1   15:D    46 
   326   1   16:D     1 PROCEDURE CENTSTR( ASTRING: STRING); FORWARD;  (* P010010 *)
   327   1   16:D    43 
   328   1   17:D     1 PROCEDURE PAUSE1; FORWARD;                     (* P010011 *)
   329   1   17:D     1 
   330   1   18:D     1 PROCEDURE PAUSE2; FORWARD;                     (* P010012 *)
   331   1   18:D     1 
   332   1   19:D     1 PROCEDURE CLEARPIC; FORWARD;                   (* P010013 *)
   333   1   19:D     1 
   334   1   20:D     1 PROCEDURE GRAPHICS; FORWARD;                   (* P010014 *)
   335   1   20:D     1 
   336   1   21:D     1 PROCEDURE TEXTMODE; FORWARD;                   (* P010015 *)
   337   1   21:D     1 
   338   1   22:D     1 PROCEDURE PRINTCHR( ACHAR: CHAR); FORWARD;     (* P010016 *)
   339   1   22:D     2 
   340   1   23:D     1 PROCEDURE PRINTSTR( ASTRING: STRING); FORWARD; (* P010017 *)
   341   1   23:D    43 
   342   1   24:D     1 PROCEDURE PRINTNUM( ANUM: INTEGER;             (* P010018 *)
   343   1   24:D     2                     FIELDSZ: INTEGER); FORWARD;
   344   1   24:D     3 
   345   1   25:D     1 PROCEDURE GETSTR( VAR ASTRING: STRING;         (* P010019 *)
   346   1   25:D     2                       WINXPOS: INTEGER;
   347   1   25:D     3                       WINYPOS: INTEGER); FORWARD;
   348   1   25:D     4 
   349   1   25:D     4 
   350   1   25:D     4 (* ---------- END FORWARD DECLARATIONS ---------- *)
   351   1   25:D     4 
   352   1   25:D     4 (* ---------- BEGIN EXTERNALS ------------------- *)
   353   1   25:D     4 
   354   1   25:D     4 
   355   1   26:D     1 PROCEDURE CLRPICT( A1:  INTEGER;               (* P01001A *)
   356   1   26:D     2                    A2:  INTEGER;
   357   1   26:D     3                    A3:  INTEGER;
   358   1   26:D     4                    A4:  INTEGER); EXTERNAL;
   359   1   26:D     5 
   360   1   26:D     5   (* WHEN A4 === 100, THEN CLEAR PICTURE
   361   1   26:D     5      WHEN A4 <> 100 AND A4 <> 101 THEN:
   362   1   26:D     5      
   363   1   26:D     5      DRAWING MAZE USES THIS FOR DRAWING PICTURE (82 X 79 PIXELS).
   364   1   26:D     5      
   365   1   26:D     5        $0679 = A1   X LOWER BOUNDS (FIRST TIME IT IS 0)
   366   1   26:D     5        $06F9 = A2   Y LOWER BOUNDS (0 ALWAYS)
   367   1   26:D     5        $0779 = A3   X UPPER BOUNDS (FIRST TIME IT IS 81)
   368   1   26:D     5        $07F9 = A4   Y UPPER BOUNDS (79 ALWAYS)
   369   1   26:D     5           ...AND NO PICTURE CLEARING           *)
   370   1   26:D     5        
   371   1   27:D     1 PROCEDURE DRAWLINE( X:       INTEGER;          (* P01001B *)
   372   1   27:D     2                     Y:       INTEGER;
   373   1   27:D     3                     DELTAH:  INTEGER;
   374   1   27:D     4                     DELTAV:  INTEGER;
   375   1   27:D     5                     LINELEN: INTEGER); EXTERNAL;
   376   1   27:D     6  
   377   1   28:D     3 FUNCTION RANDOM : INTEGER;  EXTERNAL;          (* P01001C *)
   378   1   28:D     3 
   379   1   28:D     3   (* RETURNS A VALUE FROM 0 TO 32,767 *)
   380   1   28:D     3   
   381   1   28:D     3 
   382   1   29:D     3 FUNCTION KEYAVAIL : BOOLEAN; EXTERNAL;         (* P01001D *)
   383   1   29:D     3 
   384   1   30:D     1 PROCEDURE CLRRECT( X:      INTEGER;            (* P01001E *)
   385   1   30:D     2                    Y:      INTEGER;
   386   1   30:D     3                    WIDTH:  INTEGER;
   387   1   30:D     4                    HEIGHT: INTEGER); EXTERNAL;
   388   1   30:D     5 
   389   1   31:D     1 PROCEDURE MVCURSOR( X: INTEGER;                (* P01001F *)
   390   1   31:D     2                     Y: INTEGER); EXTERNAL;
   391   1   31:D     3                    
   392   1   31:D     3     (* STORE X AT $4F9.  (SLOT #1 RAM SPACE)
   393   1   31:D     3        STORE Y AT $579.  (SLOT #1 RAM SPACE)
   394   1   31:D     3        
   395   1   31:D     3        MVCURSOR( 40, Y)  TURN ON GRAPHICS MODE
   396   1   31:D     3        MVCURSOR( 50, Y)  TURN ON TEXT MODE
   397   1   31:D     3        MVCURSOR( 60, Y)  JUMP TO $2002  (COPY PROTECTION)
   398   1   31:D     3        MVCURSOR( 70, Y)  CRASH AND BURN (COPY PROTECTION)
   399   1   31:D     3        MVCURSOR( 80, Y)  ADJUST RANDOM # (UNTIL KEY IS AVAILABLE)
   400   1   31:D     3                                       $47A, $47B, $47C, $47D  (???)
   401   1   31:D     3                            RNG USES:  $47A, $4FA, $57A, $5FB  (!!!)  *)
   402   1   31:D     3        
   403   1   31:D     3                     
   404   1   32:D     1 PROCEDURE PRGRCHR( VAR A1: TCHRIMAG); EXTERNAL; (* P010020 *)
   405   1   32:D     2 
   406   1   32:D     2   (* PRINT A CHARACTER TO HI RES SCREEN *)
   407   1   32:D     2 
   408   1   32:D     2 (* ---------- END EXTERNALS --------------------- *)
   409   1   32:D     2 
   410   1   32:D     2 (* ---------- BEGIN SEGMENTS -------------------- *)
   411   1   32:D     2 
   411   1   32:D     2 (*$I WIZ1C:UTILITIE  *)
   412   1   32:D     2 
   413   7    1:D     1 SEGMENT PROCEDURE UTILITIE;  (* P010101 *)
   414   7    1:D     1 
   415   7    1:D     1   VAR
   416   7    1:D     1        CHARI : INTEGER;
   417   7    1:D     2        CHARX : INTEGER;  (* MULTIPLE USES   SVBASE04, SAVBASE4, ETC.
   418   7    1:D     3                                             SAVECAST, ETC. *)
   419   7    1:D     3        EQUIPALL : BOOLEAN;
   420   7    1:D     4 
   421   7    1:D     4 
   422   7    2:D     1   PROCEDURE RDSPELLS;  (* P010102 *)
   423   7    2:D     1   
   424   7    2:D     1     CONST
   425   7    2:D     1          SCNMAGE = 4;
   426   7    2:D     1          SCNPRST = 5;
   427   7    2:D     1   
   428   7    2:D     1     VAR
   429   7    2:D     1          SPELLGRP : INTEGER;
   430   7    2:D     2          SPLISTX  : INTEGER;
   431   7    2:D     3          DSKSPLNM : INTEGER;
   432   7    2:D     4          SPELLX   : INTEGER;
   433   7    2:D     5          
   434   7    2:D     5          
   435   7    3:D     1     PROCEDURE LISTSPLS;  (* P010103 *)
   436   7    3:D     1     
   437   7    3:D     1       VAR
   438   7    3:D     1            SPELLNM : STRING;
   439   7    3:D    42            CHPTR   : INTEGER;
   440   7    3:D    43            
   441   7    3:D    43            
   442   7    4:D     1       PROCEDURE PRSPELL( SPELLNM: STRING);  (* P010104 *)
   443   7    4:D    43       
   444   7    4:0     0         BEGIN
   445   7    4:1     0           IF SPELLNM[ 1] = '*' THEN
   446   7    4:2    13             BEGIN
   447   7    4:3    13               SPELLNM := COPY( SPELLNM, 2, LENGTH( SPELLNM) - 1);
   448   7    4:3    33               SPLISTX := SPLISTX + 1
   449   7    4:2    36             END;
   450   7    4:1    41           GOTOXY( 10 * (SPLISTX DIV 20), 2 + SPLISTX MOD 20);
   451   7    4:1    58           IF CHARACTR[ CHARX].SPELLSKN[ SPELLX] THEN
   452   7    4:2    76             BEGIN
   453   7    4:3    76               WRITE( SPELLNM);
   454   7    4:3    85               SPLISTX := SPLISTX + 1
   455   7    4:2    88             END;
   456   7    4:1    93           SPELLX := SPELLX + 1
   457   7    4:0    96         END;  (* PRSPELL *)
   458   7    4:0   114         
   459   7    4:0   114         
   460   7    5:D     1       PROCEDURE SPRETURN;  (* P010105 *)
   461   7    5:D     1       
   462   7    5:0     0         BEGIN
   463   7    5:1     0           GOTOXY( 0, 23);
   464   7    5:1     5           WRITE( 'L)EAVE WHEN READY');
   465   7    5:1    32           REPEAT
   466   7    5:2    32             GOTOXY( 41, 0);
   467   7    5:2    37             GETKEY
   468   7    5:1    37           UNTIL INCHAR = 'L';
   469   7    5:1    45           INCHAR := CHR( 0)
   470   7    5:0    46         END;  (* SPRETURN *)
   471   7    5:0    62       
   472   7    5:0    62       
   473   7    3:0     0       BEGIN  (* LISTSPLS *)
   474   7    3:1     0         MOVELEFT( IOCACHE[ GETREC( ZZERO, 0, SIZEOF( TSCNTOC))],
   475   7    3:1    13                   SCNTOC,
   476   7    3:1    17                   SIZEOF( TSCNTOC));
   477   7    3:1    22         UNITREAD( DRIVE1, IOCACHE, BLOCKSZ, SCNTOCBL + DSKSPLNM, 0);
   478   7    3:1    38         CHPTR := 0;
   479   7    3:1    41         SPLISTX := 0;
   480   7    3:1    45         WHILE IOCACHE[ CHPTR] <> CHR( CRETURN) DO
   481   7    3:2    55           BEGIN
   482   7    3:3    55             LLBASE04 := 0;
   483   7    3:3    58             WHILE IOCACHE[ CHPTR] <> CHR( CRETURN) DO
   484   7    3:4    68               BEGIN
   485   7    3:5    68                 LLBASE04 := LLBASE04 + 1;
   486   7    3:5    73                 SPELLNM[ LLBASE04] :=  IOCACHE[ CHPTR];
   487   7    3:5    83                 CHPTR := CHPTR + 1
   488   7    3:4    85               END;
   489   7    3:3    91             SPELLNM[ 0] := CHR( LLBASE04);
   490   7    3:3    96             PRSPELL( SPELLNM);
   491   7    3:3   100             CHPTR := CHPTR + 1
   492   7    3:2   102           END;
   493   7    3:1   108         UNITREAD( DRIVE1, IOCACHE, SIZEOF( IOCACHE), SCNTOCBL, 0);
   494   7    3:1   120         SPRETURN
   495   7    3:0   120       END;  (* LISTSPLS *)
   496   7    3:0   138       
   497   7    3:0   138       
   498   7    6:D     1     PROCEDURE PRPRIEST;  (* P010106 *)
   499   7    6:D     1     
   500   7    6:0     0       BEGIN
   501   7    6:1     0         WRITE( CHR( 12));
   502   7    6:1     8         WRITE( 'KNOWN PRIEST SPELLS');
   503   7    6:1    37         DSKSPLNM := SCNPRST;
   504   7    6:1    41         SPELLX := 22;
   505   7    6:1    45         LISTSPLS
   506   7    6:0    45       END;  (* PRPRIEST *)
   507   7    6:0    60       
   508   7    6:0    60       
   509   7    7:D     1     PROCEDURE PRMAGE;  (* P010107 *)
   510   7    7:D     1     
   511   7    7:0     0       BEGIN
   512   7    7:1     0         DSKSPLNM := SCNMAGE;
   513   7    7:1     4         SPELLX := 1;
   514   7    7:1     8         WRITE( CHR(12));
   515   7    7:1    16         WRITE( 'KNOWN MAGE SPELLS');
   516   7    7:1    43         LISTSPLS
   517   7    7:0    43       END;  (* PRMAGE *)
   518   7    7:0    58       
   519   7    7:0    58     
   520   7    2:0     0     BEGIN  (* RDSPELLS *)
   521   7    2:1     0       CHARX := LLBASE04;
   522   7    2:1     4       REPEAT
   523   7    2:2     4         WRITE( CHR(12));
   524   7    2:2    12         WRITE( 'MAGE   SPELLS LEFT = ');
   525   7    2:2    43         WRITE( CHARACTR[ CHARX].MAGESP[ 1]);
   526   7    2:2    65         SPELLGRP := 1 + 1;
   527   7    2:2    70         WHILE SPELLGRP <= 7 DO
   528   7    2:3    75           BEGIN
   529   7    2:4    75             WRITE( '/');
   530   7    2:4    83             WRITE( CHARACTR[ CHARX].MAGESP[ SPELLGRP]);
   531   7    2:4   105             SPELLGRP := SPELLGRP + 1
   532   7    2:3   106           END;
   533   7    2:2   112         WRITELN;
   534   7    2:2   118         WRITE( 'PRIEST SPELLS LEFT = ');
   535   7    2:2   149         WRITE( CHARACTR[ CHARX].PRIESTSP[ 1]);
   536   7    2:2   171         SPELLGRP := 1 + 1;
   537   7    2:2   176         WHILE SPELLGRP <= 7 DO
   538   7    2:3   181           BEGIN
   539   7    2:4   181             WRITE( '/');
   540   7    2:4   189             WRITE( CHARACTR[ CHARX].PRIESTSP[ SPELLGRP]);
   541   7    2:4   211             SPELLGRP := SPELLGRP + 1
   542   7    2:3   212           END;
   543   7    2:2   218         WRITELN;
   544   7    2:2   224         WRITELN;
   545   7    2:2   230         WRITELN( 'YOU MAY SEE M)AGE OR P)RIEST SPELL BOOKS');
   546   7    2:2   286         WRITELN( 'OR L)EAVE.' :22);
   547   7    2:2   312         GOTOXY( 41, 15);
   548   7    2:2   317         GETKEY;
   549   7    2:2   320         CASE INCHAR OF
   550   7    2:2   323           'M' :  PRMAGE;
   551   7    2:2   327           'P' :  PRPRIEST;
   552   7    2:2   331         END
   553   7    2:1   346       UNTIL INCHAR = 'L';
   554   7    2:1   351       INCHAR := CHR( 0);
   555   7    2:1   354       XGOTO := XBK2CMP2;
   556   7    2:1   357       LLBASE04 := CHARX;
   557   7    2:1   362       EXIT( UTILITIE)
   558   7    2:0   366     END;  (* RDSPELLS *)
   559   7    2:0   384     
   560   7    2:0   384 
   561   7    8:D     1   PROCEDURE IDITEM;  (* P010108 *)
   562   7    8:D     1   
   563   7    8:D     1     VAR
   564   7    8:D     1          ITEMX    : INTEGER;
   565   7    8:D     2          OBJECT   : TOBJREC;
   566   7    8:D    41   
   567   7    8:D    41   
   568   7    9:D     1     PROCEDURE EXITIDIT;  (* P010109 *)
   569   7    9:D     1     
   570   7    9:0     0       BEGIN
   571   7    9:1     0         LLBASE04 := CHARX;
   572   7    9:1     5         EXIT( UTILITIE)
   573   7    9:0     9       END;  (* EXITIDIT *)
   574   7    9:0    22     
   575   7    9:0    22     
   576   7    8:0     0     BEGIN (* IDITEM *)
   577   7    8:1     0       CHARX := LLBASE04;
   578   7    8:1     4       XGOTO := XBK2CMP2;
   579   7    8:1     7       REPEAT
   580   7    8:2     7         GOTOXY( 0, 18);
   581   7    8:2    12         WRITE( CHR(11));
   582   7    8:2    20         WRITE( 'IDENTIFY WHAT ITEM (0=EXIT) ? >');
   583   7    8:2    61         GETKEY;
   584   7    8:2    64         ITEMX := ORD( INCHAR) - ORD( '0');
   585   7    8:2    69         IF ITEMX =  0 THEN
   586   7    8:3    74           EXITIDIT
   587   7    8:1    74       UNTIL (ITEMX > 0) OR (ITEMX <= CHARACTR[ CHARX].POSS.POSSCNT);
   588   7    8:1    93       IF CHARACTR[ CHARX].POSS.POSSESS[ ITEMX].IDENTIF THEN
   589   7    8:2   110         EXITIDIT;
   590   7    8:1   112       CHARACTR[ CHARX].POSS.POSSESS[ ITEMX].IDENTIF :=
   591   7    8:1   128         (RANDOM MOD 100) < (10 +  5 * CHARACTR[ CHARX].CHARLEV);
   592   7    8:1   150       IF CHARACTR[ CHARX].POSS.POSSESS[ ITEMX].IDENTIF THEN
   593   7    8:2   167         CENTSTR( 'SUCCESS!')
   594   7    8:1   178       ELSE
   595   7    8:2   183         CENTSTR( 'FAILURE');
   596   7    8:1   196       IF (RANDOM MOD 100) < (35 - (3 * CHARACTR[ CHARX].CHARLEV)) THEN
   597   7    8:2   219         BEGIN
   598   7    8:3   219           MOVELEFT( IOCACHE[ GETREC(
   599   7    8:3   222                       ZOBJECT,
   600   7    8:3   223                       CHARACTR[ CHARX].POSS.POSSESS[ ITEMX].EQINDEX,
   601   7    8:3   238                       SIZEOF( TOBJREC))],
   602   7    8:3   244                     OBJECT,
   603   7    8:3   247                     SIZEOF( TOBJREC));
   604   7    8:3   250           CHARACTR[ CHARX].POSS.POSSESS[ ITEMX].CURSED := OBJECT.CURSED;
   605   7    8:3   269           XGOTO := XEQPDSP
   606   7    8:2   269         END;
   607   7    8:1   272       EXITIDIT
   608   7    8:0   272     END;  (* IDITEM *)
   609   7    8:0   288     
   610   7   10:D     1   PROCEDURE KANDIFND;  (* P01010A *)
   611   7   10:D     1   
   612   7   10:D     1     VAR
   613   7   10:D     1         CHARXDSK  : INTEGER;
   614   7   10:D     2         LOCSTRING : STRING;
   615   7   10:D    43         LOSTCHAR  : TCHAR;
   616   7   10:D   147   
   617   7   10:D   147   
   618   7   11:D     1     PROCEDURE EXITKAND;  (* P01010B *)
   619   7   11:D     1     
   620   7   11:0     0       BEGIN
   621   7   11:1     0         WRITELN;
   622   7   11:1     6         WRITELN( 'L)EAVE WHEN READY');
   623   7   11:1    39         GOTOXY( 41, 0);
   624   7   11:1    44         REPEAT
   625   7   11:2    44           GETKEY;
   626   7   11:1    47         UNTIL INCHAR = 'L';
   627   7   11:1    52         INCHAR := 'A';
   628   7   11:1    55         LLBASE04 := CHARX;
   629   7   11:1    60         XGOTO := XBK2CMP2;
   630   7   11:1    63         EXIT( UTILITIE)
   631   7   11:0    67       END;  (* EXITKAND *)
   632   7   11:0    82       
   633   7   11:0    82       
   634   7   12:D     1     PROCEDURE KANDILOC;  (* P01010C *)
   635   7   12:D     1     
   636   7   12:0     0       BEGIN
   637   7   12:1     0         IF LOSTCHAR.STATUS = LOST THEN
   638   7   12:2     7           EXIT( KANDILOC);
   639   7   12:1    11         IF LOSTCHAR.STATUS < DEAD THEN
   640   7   12:2    18           WRITELN( 'STILL WITH US!')
   641   7   12:1    48         ELSE
   642   7   12:2    50           BEGIN
   643   7   12:3    50             IF (LOSTCHAR.LOSTXYL.LOCATION[ 1] = 0) AND
   644   7   12:3    62                (LOSTCHAR.LOSTXYL.LOCATION[ 2] = 0) AND
   645   7   12:3    75                (LOSTCHAR.LOSTXYL.LOCATION[ 3] = 0)     THEN
   646   7   12:4    90               WRITELN( 'IN THE MOURGE')
   647   7   12:3   119             ELSE
   648   7   12:4   121               IF LOSTCHAR.LOSTXYL.LOCATION[ 3] <= 0 THEN
   649   7   12:5   135                 BEGIN
   650   7   12:6   135                   WRITELN( 'UNREACHABLE!')
   651   7   12:5   163                 END
   652   7   12:4   163               ELSE
   653   7   12:5   165                 BEGIN
   654   7   12:6   165                   WRITE( 'IN THE ');
   655   7   12:6   182                   
   656   7   12:6   182                   IF LOSTCHAR.LOSTXYL.LOCATION[ 2] > 9 THEN
   657   7   12:7   196                     WRITE( 'NORTH ')
   658   7   12:6   212                   ELSE
   659   7   12:7   214                     WRITE( 'SOUTH ');
   660   7   12:7   230                     
   661   7   12:6   230                   IF LOSTCHAR.LOSTXYL.LOCATION[ 1] > 9 THEN
   662   7   12:7   244                     WRITE( 'EAST')
   663   7   12:6   258                   ELSE
   664   7   12:7   260                     WRITE( 'WEST');
   665   7   12:7   274                     
   666   7   12:6   274                   WRITE( ' OF LEVEL ');
   667   7   12:6   294                   WRITELN(  LOSTCHAR.LOSTXYL.LOCATION[ 3]);
   668   7   12:5   317                 END
   669   7   12:2   317           END;
   670   7   12:1   317         EXITKAND
   671   7   12:0   317       END;  (* KANDILOC *)
   672   7   12:0   338       
   673   7   12:0   338       
   674   7   10:0     0     BEGIN  (* KANDIFND *)
   675   7   10:1     0       CHARX :=  LLBASE04;
   676   7   10:1     4       WRITE( CHR(12));
   677   7   10:1    12       WRITELN( 'LOCATE BODIES');
   678   7   10:1    41       WRITELN;
   679   7   10:1    47       WRITE('FIND WHO ? >');
   680   7   10:1    69       GETLINE( LOCSTRING);
   681   7   10:1    74       WRITE( CHR(12));
   682   7   10:1    82       WRITE( 'THE SOUL OF ');
   683   7   10:1   104       WRITE( LOCSTRING);
   684   7   10:1   113       WRITELN( ' IS..');
   685   7   10:1   134       WRITELN;
   686   7   10:1   140       FOR CHARXDSK := 0 TO SCNTOC.RECPERDK[ ZCHAR] - 1 DO
   687   7   10:2   162         BEGIN
   688   7   10:3   162           MOVELEFT( IOCACHE[ GETREC( ZCHAR, CHARXDSK, SIZEOF( TCHAR))],
   689   7   10:3   175                     LOSTCHAR,
   690   7   10:3   178                     SIZEOF( TCHAR));
   691   7   10:3   183           IF LOSTCHAR.NAME = LOCSTRING THEN
   692   7   10:4   191             KANDILOC
   693   7   10:2   191         END;
   694   7   10:1   200       WRITELN( 'LOST FOREVER!');
   695   7   10:1   229       EXITKAND
   696   7   10:0   229     END;   (* KANDIFND *)
   697   7   10:0   246     
   698   7   10:0   246 
   699   7   13:D     1     PROCEDURE DUMAPIC;  (* P01010D *)
   700   7   13:D     1     
   701   7   13:0     0       BEGIN
   702   7   13:1     0         XGOTO := XBK2CMP2;
   703   7   13:1     3         IF MAZELEV = 10 THEN
   704   7   13:2     9           BEGIN
   705   7   13:3     9             WRITE( CHR( 12));
   706   7   13:3    17             WRITELN( 'ENCHANTMENTS PREVENT SPELL FROM WORKING');
   707   7   13:3    72             EXIT( UTILITIE)
   708   7   13:2    76           END;
   709   7   13:1    76         CHARX := LLBASE04;
   710   7   13:1    80         WRITE( CHR( 12));
   711   7   13:1    88         WRITELN( 'PARTY LOCATION:');
   712   7   13:1   119         WRITELN;
   713   7   13:1   125         WRITE( 'THE PARTY IS FACING ');
   714   7   13:1   155         CASE DIRECTIO OF
   715   7   13:1   159           0:  WRITELN( 'NORTH.');
   716   7   13:1   183           1:  WRITELN( 'EAST.');
   717   7   13:1   206           2:  WRITELN( 'SOUTH.');
   718   7   13:1   230           3:  WRITELN( 'WEST.');
   719   7   13:1   253         END;
   720   7   13:1   268         WRITELN;
   721   7   13:1   274         WRITE( 'YOU ARE ');
   722   7   13:1   292         WRITE( MAZEX);
   723   7   13:1   301         WRITELN( ' SQUARES EAST AND');
   724   7   13:1   334         WRITE( MAZEY);
   725   7   13:1   343         WRITELN( ' SQUARES NORTH OF THE STAIRS');
   726   7   13:1   387         WRITE( 'TO THE CASTLE, AND ');
   727   7   13:1   416         WRITE( MAZELEV);
   728   7   13:1   425         WRITELN( ' LEVELS');
   729   7   13:1   448         WRITELN( 'BELOW IT.');
   730   7   13:1   473         WRITELN;
   731   7   13:1   479         WRITELN( 'L)EAVE WHEN READY');
   732   7   13:1   512         REPEAT
   733   7   13:2   512           GOTOXY( 41, 0);
   734   7   13:2   517           GETKEY
   735   7   13:1   517         UNTIL INCHAR = 'L';
   736   7   13:1   525         INCHAR := 'A';
   737   7   13:1   528         LLBASE04 := CHARX;
   738   7   13:1   533         EXIT( UTILITIE)
   739   7   13:0   537       END;  (* DUMAPIC *)
   740   7   13:0   552   
   741   7   13:0   552 
   742   7   14:D     1   PROCEDURE MALOR;    (* P01010E *)
   743   7   14:D     1   
   744   7   14:D     1     VAR
   745   7   14:D     1          DELTAUD  : INTEGER;
   746   7   14:D     2          DELTANS  : INTEGER;
   747   7   14:D     3          DELTAEW  : INTEGER;
   748   7   14:D     4   
   749   7   14:D     4   
   750   7   15:D     1     PROCEDURE TELEPORT;  (* P01010F *)
   751   7   15:D     1     
   752   7   16:D     1       PROCEDURE ROCK;  (* P010110 *)
   753   7   16:D     1       
   754   7   16:D     1         VAR
   755   7   16:D     1              X : INTEGER;
   756   7   16:D     2       
   757   7   16:0     0         BEGIN
   758   7   16:1     0           WRITELN( 'YOU LANDED IN SOLID ROCK OUTSIDE THE');
   759   7   16:1    52           WRITELN( 'DUNGEON - YOU ARE LOST FOREVER!');
   760   7   16:1    99           FOR X := 0 TO PARTYCNT - 1 DO
   761   7   16:2   112             BEGIN
   762   7   16:3   112               CHARACTR[ X].INMAZE := FALSE;
   763   7   16:3   121               CHARACTR[ X].STATUS := LOST
   764   7   16:2   128             END;
   765   7   16:1   137           XGOTO := XCEMETRY;
   766   7   16:1   140           EXIT( UTILITIE)
   767   7   16:0   144         END;
   768   7   16:0   158               
   769   7   16:0   158         
   770   7   17:D     1       PROCEDURE VOLCANO;  (* P010111 *)
   771   7   17:D     1       
   772   7   17:D     1         VAR
   773   7   17:D     1              X : INTEGER;
   774   7   17:D     2       
   775   7   17:0     0         BEGIN
   776   7   17:1     0           WRITELN( 'YOU MATERIALIZED IN MID-AIR AND FELL');
   777   7   17:1    52           WRITELN( 'TO A PAINFUL DEATH!');
   778   7   17:1    87           FOR X := 0 TO PARTYCNT - 1 DO
   779   7   17:2   100             IF CHARACTR[ X].STATUS < DEAD THEN
   780   7   17:3   111               CHARACTR[ X].STATUS := DEAD;
   781   7   17:1   127           MAZELEV := 0;
   782   7   17:1   130           XGOTO := XCHK4WIN;
   783   7   17:1   133           EXIT( UTILITIE)
   784   7   17:0   137         END;
   785   7   17:0   152         
   786   7   17:0   152         
   787   7   18:D     1       PROCEDURE MOAT;   (* P010112 *)
   788   7   18:D     1       
   789   7   18:D     1         VAR
   790   7   18:D     1              X : INTEGER;
   791   7   18:D     2       
   792   7   18:0     0         BEGIN
   793   7   18:1     0           WRITELN( 'YOU APPEARED IN THE CASTLE MOAT AND');
   794   7   18:1    51           WRITELN( 'PROBABLY DROWNED!');
   795   7   18:1    84           FOR X := 0 TO PARTYCNT - 1 DO
   796   7   18:2    97             IF CHARACTR[ X].STATUS < DEAD THEN
   797   7   18:3   108               IF (RANDOM MOD 25) > CHARACTR[ X].ATTRIB[ AGILITY] THEN
   798   7   18:4   130                 CHARACTR[ X].STATUS := DEAD;
   799   7   18:1   146           MAZELEV := 0;
   800   7   18:1   149           XGOTO := XCHK4WIN;
   801   7   18:1   152           EXIT( UTILITIE)
   802   7   18:0   156         END;
   803   7   18:0   170     
   804   7   18:0   170     
   805   7   19:D     1       PROCEDURE TOSHOPS;  (* P010113 *)
   806   7   19:D     1       
   807   7   19:0     0         BEGIN
   808   7   19:1     0           XGOTO := XCHK4WIN;
   809   7   19:1     3           EXIT( UTILITIE)
   810   7   19:0     7         END;
   811   7   19:0    20     
   812   7   19:0    20     
   813   7   20:D     1       PROCEDURE BOUNCE;  (* P010114 *)
   814   7   20:D     1       
   815   7   20:0     0         BEGIN
   816   7   20:1     0           WRITELN( 'YOU BOUNCED BACK TO WHERE YOU WERE!');
   817   7   20:1    51           EXIT( UTILITIE)
   818   7   20:0    55         END;
   819   7   20:0    68     
   820   7   20:0    68     
   821   7   15:0     0       BEGIN (* TELEPORT *)
   822   7   15:1     0         WRITE( CHR(12));
   823   7   15:1     8         XGOTO := XNEWMAZE;
   824   7   15:1    11         IF MAZELEV + DELTAUD = SCNTOC.RECPERDK[ ZMAZE] THEN
   825   7   15:2    27           BOUNCE;
   826   7   15:1    29         MAZEX := MAZEX + DELTAEW;
   827   7   15:1    37         MAZEY := MAZEY + DELTANS;
   828   7   15:1    45         MAZELEV := MAZELEV + DELTAUD;
   829   7   15:1    53         IF ( (MAZEX < 0) OR (MAZEX > 19) OR
   830   7   15:1    62              (MAZEY < 0) OR (MAZEY > 19) OR
   831   7   15:1    72              (MAZELEV > SCNTOC.RECPERDK[ ZMAZE]))
   832   7   15:1    83            AND
   833   7   15:1    83            (MAZELEV > 0) THEN
   834   7   15:2    90             ROCK
   835   7   15:1    90         ELSE
   836   7   15:2    94           BEGIN
   837   7   15:3    94             IF MAZELEV < 0 THEN
   838   7   15:4   100               VOLCANO
   839   7   15:3   100             ELSE
   840   7   15:4   104               IF MAZELEV = 0 THEN
   841   7   15:5   110                 IF (MAZEX = 0) AND (MAZEY = 0) THEN
   842   7   15:6   121                   TOSHOPS
   843   7   15:5   121                 ELSE
   844   7   15:6   125                   MOAT
   845   7   15:2   125           END;
   846   7   15:1   127         EXIT( UTILITIE)
   847   7   15:0   131       END;
   848   7   15:0   144   
   849   7   15:0   144   
   850   7   14:0     0     BEGIN (* MALOR *)
   851   7   14:1     0       CHARX := LLBASE04;
   852   7   14:1     4       WRITE( CHR(12));
   853   7   14:1    12       WRITELN( 'PARTY TELEPORT:');
   854   7   14:1    43       WRITELN;
   855   7   14:1    49       WRITELN( 'ENTER NSEWU OR D TO  SET DISPLACEMENT,');
   856   7   14:1   103       WRITELN( 'THEN [RETURN] TO TELEPORT, OR [ESC] TO');
   857   7   14:1   157       WRITELN( 'CHICKEN OUT!');
   858   7   14:1   185       WRITELN;
   859   7   14:1   191       WRITELN( '# SQUARES EAST  =');
   860   7   14:1   224       WRITELN( '# SQUARES NORTH =');
   861   7   14:1   257       WRITELN( '# SQUARES DOWN  =');
   862   7   14:1   290       DELTAEW := 0;
   863   7   14:1   293       DELTANS := 0;
   864   7   14:1   296       DELTAUD := 0;
   865   7   14:1   299       REPEAT
   866   7   14:2   299         GOTOXY( 18, 6);
   867   7   14:2   304         WRITE( DELTAEW : 4);
   868   7   14:2   312         GOTOXY( 18, 7);
   869   7   14:2   317         WRITE( DELTANS : 4);
   870   7   14:2   325         GOTOXY( 18, 8);
   871   7   14:2   330         WRITE( DELTAUD : 4);
   872   7   14:2   338         GOTOXY( 41, 0);
   873   7   14:2   343         GETKEY;
   874   7   14:2   346         IF INCHAR = CHR( CRETURN) THEN
   875   7   14:3   351           TELEPORT
   876   7   14:2   351         ELSE
   877   7   14:3   355           BEGIN
   878   7   14:4   355             CASE INCHAR OF
   879   7   14:4   358               'N': DELTANS := DELTANS + 1;
   880   7   14:4   365               'S': DELTANS := DELTANS - 1;
   881   7   14:4   372               'E': DELTAEW := DELTAEW + 1;
   882   7   14:4   379               'W': DELTAEW := DELTAEW - 1;
   883   7   14:4   386               'D': DELTAUD := DELTAUD + 1;
   884   7   14:4   393               'U': DELTAUD := DELTAUD - 1;
   885   7   14:4   400             END
   886   7   14:3   448           END
   887   7   14:1   448       UNTIL INCHAR = CHR( 27);
   888   7   14:1   453       XGOTO := XBK2CMP2;
   889   7   14:1   456       LLBASE04 := CHARX;
   890   7   14:1   461       EXIT( UTILITIE)
   891   7   14:0   465     END;
   892   7   14:0   480     
   893   7   14:0   480 
   894   7   21:D     1   PROCEDURE NEWMAZE;  (* P010115 *)
   895   7   21:D     1   
   896   7   21:D     1     VAR
   897   7   21:D     1          MAZEMAP  : TMAZE;
   898   7   21:D   448          UNUSED   : ARRAY[ 0..2] OF INTEGER;
   899   7   21:D   451          
   900   7   21:D   451   
   901   7   22:D     1     PROCEDURE FIGHTS;  (* P010116 *)
   902   7   22:D     1     
   903   7   22:D     1       VAR
   904   7   22:D     1            FIGHTY : INTEGER;
   905   7   22:D     2            FIGHTX : INTEGER;
   906   7   22:D     3            Y      : INTEGER;
   907   7   22:D     4            X      : INTEGER;
   908   7   22:D     5     
   909   7   22:D     5     
   910   7   23:D     1       PROCEDURE FINDSPOT;  (* P010117 *)
   911   7   23:D     1       
   912   7   23:D     1         VAR
   913   7   23:D     1             Y1 : INTEGER;
   914   7   23:D     2             X1 : INTEGER;
   915   7   23:D     3       
   916   7   23:0     0         BEGIN (* FINDSPOT *)
   917   7   23:1     0           X1 := RANDOM MOD 20;
   918   7   23:1     9           Y1 := RANDOM MOD 20;
   919   7   23:1    18           FIGHTX := X1;
   920   7   23:1    22           FIGHTY := Y1;
   921   7   23:1    26           REPEAT
   922   7   23:2    26             IF MAZEMAP.FIGHTS[ FIGHTX][ FIGHTY] = 1 THEN
   923   7   23:3    46               IF NOT (FIGHTMAP[ FIGHTX][ FIGHTY]) THEN
   924   7   23:4    63                 BEGIN
   925   7   23:5    63                   EXIT( FINDSPOT)
   926   7   23:4    67                 END;
   927   7   23:2    67             FIGHTX := FIGHTX + 1;
   928   7   23:2    75             IF FIGHTX > 19 THEN
   929   7   23:3    82               BEGIN
   930   7   23:4    82                 FIGHTX := 0;
   931   7   23:4    86                 FIGHTY := FIGHTY + 1;
   932   7   23:4    94                 IF FIGHTY > 19 THEN
   933   7   23:5   101                   FIGHTY := 0
   934   7   23:3   101               END;
   935   7   23:1   105           UNTIL (FIGHTX = X1) AND (FIGHTY = Y1);
   936   7   23:1   118           EXIT( FIGHTS)
   937   7   23:0   122         END;   (* FINDSPOT *)
   938   7   23:0   136         
   939   7   23:0   136         
   940   7   24:D     1       PROCEDURE FILLROOM( X : INTEGER; Y : INTEGER);  (* P010118 *)
   941   7   24:D     3         
   942   7   24:0     0         BEGIN
   943   7   24:0     0         
   944   7   24:1     0           X := (X + 20) MOD 20;
   945   7   24:1     7           Y := (Y + 20) MOD 20;
   946   7   24:1    14           IF (MAZEMAP.FIGHTS[ X][ Y] = 0) OR
   947   7   24:1    28              FIGHTMAP[ X][ Y] THEN
   948   7   24:2    41              BEGIN
   949   7   24:3    41                EXIT( FILLROOM)
   950   7   24:2    45              END;
   951   7   24:2    45              
   952   7   24:1    45           FIGHTMAP[ X][ Y] := TRUE;
   953   7   24:1    56           
   954   7   24:1    56           IF MAZEMAP.N[ X][ Y] = OPEN THEN
   955   7   24:2    72             FILLROOM( X, Y + 1);
   956   7   24:2    78             
   957   7   24:1    78           IF MAZEMAP.E[ X][ Y] = OPEN THEN
   958   7   24:2    93             FILLROOM( X + 1, Y);
   959   7   24:2    99             
   960   7   24:1    99           IF MAZEMAP.S[ X][ Y] = OPEN THEN
   961   7   24:2   114             FILLROOM( X, Y - 1);
   962   7   24:2   120             
   963   7   24:1   120           IF MAZEMAP.W[ X][ Y] = OPEN THEN
   964   7   24:2   135             FILLROOM( X - 1, Y)
   965   7   24:2   139             
   966   7   24:0   139         END;   (* FILLROOM *)
   967   7   24:0   154     
   968   7   24:0   154     
   969   7   22:0     0       BEGIN (* FIGHTS *)
   970   7   22:1     0         FILLCHAR( FIGHTMAP, 80, 0);
   971   7   22:1     7         FOR X := 1 TO 9 DO
   972   7   22:2    18           BEGIN
   973   7   22:3    18             FINDSPOT;
   974   7   22:3    20             FILLROOM( FIGHTX, FIGHTY)
   975   7   22:2    22           END;
   976   7   22:2    31           
   977   7   22:1    31         FOR X := 0 TO 19 DO
   978   7   22:2    42           BEGIN
   979   7   22:3    42             FOR Y := 0 TO 19 DO
   980   7   22:4    53               BEGIN
   981   7   22:5    53                 IF MAZEMAP.SQRETYPE[ MAZEMAP.SQREXTRA[ X][ Y]] = ENCOUNTE THEN
   982   7   22:6    77                   FILLROOM( X, Y)
   983   7   22:4    79               END;
   984   7   22:2    88           END;
   985   7   22:0    95       END;  (* FIGHTS *)
   986   7   22:0   114   
   987   7   22:0   114   
   988   7   21:0     0     BEGIN (* NEWMAZE *)
   989   7   21:1     0       IF MAZELEV = 0 THEN
   990   7   21:2     6         BEGIN
   991   7   21:3     6           WRITE( CHR(12));
   992   7   21:3    14           XGOTO := XCHK4WIN;
   993   7   21:3    17           EXIT( UTILITIE)
   994   7   21:2    21         END;
   995   7   21:2    21         
   996   7   21:1    21       IF MAZELEV < 0 THEN
   997   7   21:2    27         BEGIN
   998   7   21:3    27           MAZELEV := 1;
   999   7   21:3    30           XGOTO := XEQUIP6
  1000   7   21:2    30         END
  1001   7   21:1    33       ELSE
  1002   7   21:2    35         BEGIN
  1003   7   21:3    35           XGOTO := XRUNNER
  1004   7   21:2    35         END;
  1005   7   21:1    38       MOVELEFT( IOCACHE[ GETREC( ZMAZE, MAZELEV - 1, SIZEOF( TMAZE))],
  1006   7   21:1    54                 MAZEMAP,
  1007   7   21:1    57                 SIZEOF( TMAZE));
  1008   7   21:1    62       FIGHTS;
  1009   7   21:1    64       CLRRECT( 1, 11, 38, 4);
  1010   7   21:1    71       EXIT( UTILITIE)
  1011   7   21:0    75     END;  (* NEWMAZE *)
  1012   7   21:0    88     
  1013   7   21:0    88 (*$I WIZ1C:UTILITIE  *)
  1013   7   21:0    88 (*$I WIZ1B:UTILITIE2 *)
  1014   7   21:0    88 
  1015   7   25:D     1 PROCEDURE EQUIPCHR( CHARI : INTEGER);  (* P010119 *)
  1016   7   25:D     2     
  1017   7   25:D     2     VAR
  1018   7   25:D     2          UNARMED  : BOOLEAN;
  1019   7   25:D     3          CANUSE   : ARRAY[ TOBJTYPE] OF BOOLEAN;
  1020   7   25:D    10          UNUSED   : BOOLEAN;
  1021   7   25:D    11          TEMPX    : INTEGER; (* MULTIPLE USES *)
  1022   7   25:D    12          POSSI    : INTEGER;
  1023   7   25:D    13          POSSCNT  : INTEGER;
  1024   7   25:D    14          LUCKI    : INTEGER;
  1025   7   25:D    15          OBJI     : TOBJTYPE;
  1026   7   25:D    16          OBJECT   : TOBJREC;
  1027   7   25:D    55          OBJLIST  : ARRAY[ 1..8] OF INTEGER;
  1028   7   25:D    63          
  1029   7   25:D    63     
  1030   7   26:D     1     PROCEDURE CHSPCPOW;  (* P01011A *)
  1031   7   26:D     1       
  1032   7   26:D     1       
  1033   7   27:D     1         PROCEDURE SPCPOWER;  (* P01011B *)
  1034   7   27:D     1         
  1035   7   27:D     1           VAR
  1036   7   27:D     1                SPCTEMP  : INTEGER;
  1037   7   27:D     2                GOLD50K  : TWIZLONG;
  1038   7   27:D     5         
  1039   7   27:D     5         
  1040   7   28:D     1           PROCEDURE SPC1TO12( ATTR2MOD: INTEGER;  (* P01011C *)
  1041   7   28:D     2                               MODAMT:   INTEGER);
  1042   7   28:D     3           
  1043   7   28:D     3             VAR
  1044   7   28:D     3                  ATTRX : TATTRIB;
  1045   7   28:D     4           
  1046   7   28:0     0             BEGIN
  1047   7   28:1     0               ATTRX := STRENGTH;
  1048   7   28:1     3               WHILE ATTR2MOD > 1 DO
  1049   7   28:2     8                 BEGIN
  1050   7   28:3     8                   ATTRX := SUCC( ATTRX);
  1051   7   28:3    13                   ATTR2MOD := ATTR2MOD - 1
  1052   7   28:2    14                 END;
  1053   7   28:1    20               SPCTEMP := CHARACTR[ CHARI].ATTRIB[ ATTRX] + MODAMT;
  1054   7   28:1    39               IF (SPCTEMP > 2) AND (SPCTEMP < 19) THEN
  1055   7   28:2    52                 CHARACTR[ CHARI].ATTRIB[ ATTRX] := SPCTEMP;
  1056   7   28:0    69             END;
  1057   7   28:0    84           
  1058   7   28:0    84         
  1059   7   27:0     0           BEGIN  (* SPCPOWER *)
  1060   7   27:1     0             FILLCHAR( GOLD50K, 6, 0);
  1061   7   27:1     7             GOLD50K.MID := 5;
  1062   7   27:1    10             WRITE( CHR( 12));
  1063   7   27:1    18             WRITELN( 'WILL YOU INVOKE THE SPECIAL POWER OF');
  1064   7   27:1    70             WRITE( 'YOUR ');
  1065   7   27:1    85             IF CHARACTR[ CHARI].POSS.POSSESS[ POSSI].IDENTIF THEN
  1066   7   27:2   104               WRITE( OBJECT.NAME)
  1067   7   27:1   114             ELSE
  1068   7   27:2   116               WRITE( OBJECT.NAMEUNK);
  1069   7   27:1   126             WRITE( ' (Y/N) ? >');
  1070   7   27:1   146             REPEAT
  1071   7   27:2   146               GETKEY
  1072   7   27:1   146             UNTIL (INCHAR = 'Y') OR (INCHAR = 'N');
  1073   7   27:1   158             IF INCHAR = 'N' THEN
  1074   7   27:2   163               EXIT( SPCPOWER);
  1075   7   27:1   167             IF (RANDOM MOD 100) < OBJECT.CHGCHANC THEN
  1076   7   27:2   180               CHARACTR[ CHARI].POSS.POSSESS[ POSSI].EQINDEX :=
  1077   7   27:2   198                 OBJECT.CHANGETO;
  1078   7   27:1   202             IF OBJECT.SPECIAL < 7 THEN
  1079   7   27:2   209               BEGIN
  1080   7   27:3   209                 SPC1TO12( OBJECT.SPECIAL, 1)
  1081   7   27:2   213               END
  1082   7   27:1   215             ELSE
  1083   7   27:2   217               BEGIN
  1084   7   27:3   217                 IF OBJECT.SPECIAL < 13 THEN
  1085   7   27:4   224                   SPC1TO12( OBJECT.SPECIAL - 6, - 1)
  1086   7   27:3   231                 ELSE 
  1087   7   27:4   235                   BEGIN
  1088   7   27:5   235                     WITH CHARACTR[ CHARI] DO
  1089   7   27:6   244                       BEGIN
  1090   7   27:7   244                         CASE OBJECT.SPECIAL OF
  1091   7   27:7   249                           13: IF AGE > 1040 THEN
  1092   7   27:9   258                                 AGE := AGE - 52;
  1093   7   27:7   269                           14: AGE := AGE + 52;
  1094   7   27:7   280                           15: CLASS := SAMURAI;
  1095   7   27:7   287                           16: CLASS := LORD;
  1096   7   27:7   294                           17: CLASS := NINJA;
  1097   7   27:7   301                           18: ADDLONGS( GOLD, GOLD50K);
  1098   7   27:7   311                           19: ADDLONGS( EXP, GOLD50K);
  1099   7   27:7   321                           20: STATUS := LOST;
  1100   7   27:7   328                           21: BEGIN
  1101   7   27:9   328                                 STATUS := OK;
  1102   7   27:9   333                                 HPLEFT := HPMAX;
  1103   7   27:9   340                                 LOSTXYL.POISNAMT[ 1] := 0
  1104   7   27:8   348                               END;
  1105   7   27:7   352                           22: HPMAX := HPMAX + 1;
  1106   7   27:7   363                           23: BEGIN
  1107   7   27:7   363                                 (* LOOKS LIKE BUG!  PARTYCNT - 1  !!! *)
  1108   7   27:9   363                                 FOR SPCTEMP := 0 TO PARTYCNT DO
  1109   7   27:0   374                                     CHARACTR[ SPCTEMP].HPLEFT :=
  1110   7   27:0   381                                       CHARACTR[ SPCTEMP].HPMAX
  1111   7   27:8   386                               END;
  1112   7   27:7   398                         END
  1113   7   27:6   428                     END
  1114   7   27:4   428                   END
  1115   7   27:2   428               END;
  1116   7   27:0   428           END;  (* SPCPOWER *)
  1117   7   27:0   452       
  1118   7   27:0   452       
  1119   7   26:0     0         BEGIN (* CHSPCPOW *)
  1120   7   26:1     0           FOR POSSI := 1 TO CHARACTR[ CHARI].POSS.POSSCNT DO
  1121   7   26:2    22             IF CHARACTR[ CHARI].POSS.POSSESS[ POSSI].EQINDEX > 0 THEN
  1122   7   26:3    43               BEGIN
  1123   7   26:4    43                 MOVELEFT( IOCACHE[ GETREC( 
  1124   7   26:4    46                             ZOBJECT,
  1125   7   26:4    47                             CHARACTR[ CHARI].POSS.POSSESS[ POSSI].EQINDEX,
  1126   7   26:4    64                             SIZEOF( TOBJREC))],
  1127   7   26:4    70                           OBJECT,
  1128   7   26:4    74                           SIZEOF( TOBJREC));
  1129   7   26:4    77                 IF OBJECT.SPECIAL > 0 THEN
  1130   7   26:5    84                   SPCPOWER
  1131   7   26:3    84               END;
  1132   7   26:0    96         END;
  1133   7   26:0   110     
  1134   7   26:0   110     
  1135   7   29:D     1       PROCEDURE NORMPOW;  (* P01011D *)
  1136   7   29:D     1       
  1137   7   29:D     1         VAR
  1138   7   29:D     1              TEMPX : INTEGER;
  1139   7   29:D     2              TEMPY : INTEGER;
  1140   7   29:D     3              POSSX : INTEGER;
  1141   7   29:D     4       
  1142   7   29:0     0         BEGIN
  1143   7   29:1     0           FILLCHAR( CANUSE, 14, 0);
  1144   7   29:1     8           FOR POSSX := 1 TO CHARACTR[ CHARI].POSS.POSSCNT DO
  1145   7   29:2    27             BEGIN
  1146   7   29:3    27               MOVELEFT( IOCACHE[ GETREC( ZOBJECT,
  1147   7   29:3    31                                          CHARACTR[ CHARI].
  1148   7   29:3    38                                            POSS.POSSESS[ POSSX].EQINDEX,
  1149   7   29:3    46                                          SIZEOF( TOBJREC))],
  1150   7   29:3    52                         OBJECT,
  1151   7   29:3    56                         SIZEOF( TOBJREC));
  1152   7   29:3    59               IF OBJECT.CLASSUSE[ CHARACTR[ CHARI].CLASS] THEN
  1153   7   29:4    77                 CANUSE[ OBJECT.OBJTYPE] := TRUE;
  1154   7   29:3    87               IF CHARACTR[ CHARI].HEALPTS < OBJECT.HEALPTS THEN
  1155   7   29:4   102                 CHARACTR[ CHARI].HEALPTS := OBJECT.HEALPTS;
  1156   7   29:3   115               FOR TEMPX := 0 TO 13 DO
  1157   7   29:4   126                 CHARACTR[ CHARI].WEPVSTY2[ 0][ TEMPX] :=
  1158   7   29:4   142                 CHARACTR[ CHARI].WEPVSTY2[ 0][ TEMPX] OR OBJECT.WEPVSTY2[ TEMPX];
  1159   7   29:3   176               FOR TEMPY := 0 TO 6 DO
  1160   7   29:4   187                 CHARACTR[ CHARI].WEPVSTY3[ 0][ TEMPY] :=
  1161   7   29:4   203                 CHARACTR[ CHARI].WEPVSTY3[ 0][ TEMPY] OR OBJECT.WEPVSTY3[ TEMPY]
  1162   7   29:2   227             END
  1163   7   29:0   237         END;  (* NORMPOW *)
  1164   7   29:0   264         
  1165   7   29:0   264         
  1166   7   30:D     1       PROCEDURE ARMORPOW( CHARX: INTEGER;  (* P01011E *)
  1167   7   30:D     2                           POSSX: INTEGER;
  1168   7   30:D     3                           OBJID: INTEGER);
  1169   7   30:D     4       
  1170   7   30:D     4         VAR
  1171   7   30:D     4              MP04XX : INTEGER;  (* UNUSED *)
  1172   7   30:D     5       
  1173   7   30:0     0         BEGIN
  1174   7   30:1     0           UNARMED := FALSE;
  1175   7   30:1     4           MOVELEFT( IOCACHE[ GETREC( ZOBJECT,
  1176   7   30:1     8                                      OBJID,
  1177   7   30:1     9                                      SIZEOF( TOBJREC))],
  1178   7   30:1    15                     OBJECT,
  1179   7   30:1    19                     SIZEOF( TOBJREC));
  1180   7   30:1    22           WITH CHARACTR[ CHARX] DO
  1181   7   30:2    29             BEGIN
  1182   7   30:3    29               POSS.POSSESS[ POSSX].CURSED := OBJECT.CURSED;
  1183   7   30:3    43               IF (OBJECT.ALIGN = UNALIGN) OR (OBJECT.ALIGN = ALIGN) THEN
  1184   7   30:4    58                 BEGIN
  1185   7   30:5    58                   IF OBJECT.XTRASWNG > SWINGCNT THEN
  1186   7   30:6    67                     SWINGCNT := OBJECT.XTRASWNG;
  1187   7   30:5    74                   ARMORCL := ARMORCL - OBJECT.ARMORMOD;
  1188   7   30:5    85                   HPCALCMD := HPCALCMD + OBJECT.WEPHITMD;
  1189   7   30:5    96                   IF OBJECT.OBJTYPE = WEAPON THEN
  1190   7   30:6   103                     BEGIN
  1191   7   30:7   103                       LLBASE04 := HPDAMRC.HPMINAD;
  1192   7   30:7   108                       HPDAMRC := OBJECT.WEPHPDAM;
  1193   7   30:7   116                       HPDAMRC.HPMINAD := HPDAMRC.HPMINAD + LLBASE04;
  1194   7   30:7   125                       CRITHITM := CRITHITM OR OBJECT.CRITHITM;
  1195   7   30:7   136                       WEPVSTYP := OBJECT.WEPVSTYP
  1196   7   30:6   139                     END
  1197   7   30:4   144                 END
  1198   7   30:3   144               ELSE
  1199   7   30:4   146                 BEGIN
  1200   7   30:5   146                   HPCALCMD := HPCALCMD - 1;
  1201   7   30:5   155                   ARMORCL := ARMORCL + 1;
  1202   7   30:5   164                   CRITHITM := FALSE;
  1203   7   30:5   169                   POSS.POSSESS[ POSSX].CURSED := TRUE
  1204   7   30:4   179                 END
  1205   7   30:2   181             END;
  1206   7   30:0   181         END;  (* ARMORPOW *)
  1207   7   30:0   194         
  1208   7   30:0   194         
  1209   7   31:D     1       PROCEDURE ARM4CHAR;  (* P01011F *)
  1210   7   31:D     1       
  1211   7   31:D     1       VAR
  1212   7   31:D     1            POSSX : INTEGER;
  1213   7   31:D     2       
  1214   7   31:0     0         BEGIN
  1215   7   31:1     0           FOR POSSX := 1 TO CHARACTR[ CHARI].POSS.POSSCNT DO
  1216   7   31:2    19             IF CHARACTR[ CHARI].POSS.POSSESS[ POSSX].EQUIPED THEN
  1217   7   31:3    36               ARMORPOW( CHARI, POSSX,
  1218   7   31:3    40                                  CHARACTR[ CHARI].POSS.POSSESS[ POSSX].EQINDEX)
  1219   7   31:0    55         END;
  1220   7   31:0    78         
  1221   7   31:0    78         
  1222   7   32:D     1       PROCEDURE DOEQUIP;  (* P010120 *)
  1223   7   32:D     1       
  1224   7   32:D     1       
  1225   7   33:D     1         PROCEDURE EQUIPONE;  (* P010121 *)
  1226   7   33:D     1         
  1227   7   33:0     0           BEGIN
  1228   7   33:1     0             REPEAT
  1229   7   33:2     0               GOTOXY( 0, 15);
  1230   7   33:2     5               WRITE( CHR( 11));
  1231   7   33:2    13               WRITE( 'WHICH ONE ([RET] FOR NONE) ? >');
  1232   7   33:2    53               GETKEY;
  1233   7   33:2    56               IF INCHAR = CHR( CRETURN) THEN
  1234   7   33:3    61                 EXIT( EQUIPONE);
  1235   7   33:2    65               POSSI := ORD( INCHAR) - ORD( '0')
  1236   7   33:1    67             UNTIL (POSSI > 0) AND (POSSI <= POSSCNT);
  1237   7   33:1    86             CHARACTR[ CHARI].POSS.POSSESS[ OBJLIST[ POSSI]].EQUIPED := TRUE;
  1238   7   33:1   112             ARMORPOW( CHARI,
  1239   7   33:1   115                       OBJLIST[ POSSI],
  1240   7   33:1   126                       CHARACTR[ CHARI].POSS.POSSESS[ OBJLIST[ POSSI]].EQINDEX)
  1241   7   33:0   151           END;  (* EQUIPONE *)
  1242   7   33:0   168       
  1243   7   33:0   168       
  1244   7   34:D     1         PROCEDURE CURSBELL( CURSSTR : STRING);  (* P010122 *)
  1245   7   34:D    43         
  1246   7   34:D    43           VAR
  1247   7   34:D    43                X : INTEGER;
  1248   7   34:D    44         
  1249   7   34:0     0           BEGIN
  1250   7   34:1     0             FOR X := 1 TO LENGTH( CURSSTR) DO
  1251   7   34:2    21               BEGIN
  1252   7   34:3    21                 WRITE( CURSSTR[ X]);
  1253   7   34:3    33                 WRITE( CHR( 7));
  1254   7   34:3    41                 WRITE( CHR( 7))
  1255   7   34:2    49               END;
  1256   7   34:0    57           END;
  1257   7   34:0    72         
  1258   7   34:0    72         
  1259   7   32:0     0         BEGIN (* DOEQUIP *)
  1260   7   32:1     0           IF NOT CANUSE[ OBJI] THEN
  1261   7   32:2    12             EXIT (DOEQUIP);
  1262   7   32:1    16           WRITE( CHR( 12));
  1263   7   32:1    24           WRITE( 'SELECT ');
  1264   7   32:1    41           CASE OBJI OF
  1265   7   32:1    46               WEAPON : WRITE( 'WEAPON');
  1266   7   32:1    64                ARMOR : WRITE( 'ARMOR');
  1267   7   32:1    81               SHIELD : WRITE( 'SHIELD');
  1268   7   32:1    99               HELMET : WRITE( 'HELMET');
  1269   7   32:1   117             GAUNTLET : WRITE( 'GAUNTLETS');
  1270   7   32:1   138                 MISC : WRITE( 'MISC. ITEM');
  1271   7   32:1   160           END;
  1272   7   32:1   182           WRITE( ' FOR ');
  1273   7   32:1   197           WRITELN( CHARACTR[ CHARI].NAME);
  1274   7   32:1   217           WRITELN;
  1275   7   32:1   223           WRITELN;
  1276   7   32:1   229           POSSCNT := 0;
  1277   7   32:1   233           FOR POSSI := 1 TO CHARACTR[ CHARI].POSS.POSSCNT DO
  1278   7   32:2   255             BEGIN
  1279   7   32:3   255               IF CHARACTR[ CHARI].POSS.POSSESS[ POSSI].EQINDEX > 0 THEN
  1280   7   32:4   276                 BEGIN
  1281   7   32:5   276                   MOVELEFT( IOCACHE[ GETREC(
  1282   7   32:5   279                                 ZOBJECT,
  1283   7   32:5   280                                 CHARACTR[ CHARI].POSS.POSSESS[ POSSI].EQINDEX,
  1284   7   32:5   297                                 SIZEOF( TOBJREC))],
  1285   7   32:5   303                             OBJECT,
  1286   7   32:5   307                             SIZEOF( TOBJREC));
  1287   7   32:5   310                   IF (OBJECT.OBJTYPE = OBJI) AND
  1288   7   32:5   317                      (OBJECT.CLASSUSE[ CHARACTR[ CHARI].CLASS]) THEN
  1289   7   32:6   336                     BEGIN
  1290   7   32:7   336                       POSSCNT := POSSCNT + 1;
  1291   7   32:7   344                       OBJLIST[ POSSCNT] := POSSI;
  1292   7   32:7   358                       WRITE( ' ' :10);
  1293   7   32:7   366                       WRITE( POSSCNT : 1);
  1294   7   32:7   376                       WRITE( ')');
  1295   7   32:7   384                       IF CHARACTR[ CHARI].POSS.POSSESS[ POSSI].CURSED THEN
  1296   7   32:8   403                         WRITE( '-')
  1297   7   32:7   411                       ELSE IF CHARACTR[ CHARI].POSS.POSSESS[ POSSI].IDENTIF
  1298   7   32:8   429                                                                          THEN
  1299   7   32:9   432                         WRITE( ' ')
  1300   7   32:8   440                       ELSE
  1301   7   32:9   442                         WRITE( '?');
  1302   7   32:7   450                       IF CHARACTR[ CHARI].POSS.POSSESS[ POSSI].IDENTIF THEN
  1303   7   32:8   469                         WRITELN( OBJECT.NAME)
  1304   7   32:7   485                       ELSE
  1305   7   32:8   487                         WRITELN( OBJECT.NAMEUNK);
  1306   7   32:6   503                     END
  1307   7   32:4   503                 END
  1308   7   32:2   503             END;
  1309   7   32:2   513             
  1310   7   32:1   513             TEMPX := 0;
  1311   7   32:1   517             FOR POSSI := 1 TO POSSCNT DO
  1312   7   32:2   533               IF CHARACTR[ CHARI].POSS.POSSESS[ OBJLIST[ POSSI]].CURSED THEN
  1313   7   32:3   560                 TEMPX := POSSI;
  1314   7   32:1   576             IF TEMPX = 0 THEN
  1315   7   32:2   583               EQUIPONE;
  1316   7   32:2   585               
  1317   7   32:1   585             TEMPX := 0;
  1318   7   32:1   589             FOR POSSI := 1 TO POSSCNT DO
  1319   7   32:2   605               IF CHARACTR[ CHARI].POSS.POSSESS[ OBJLIST[ POSSI]].CURSED THEN
  1320   7   32:3   632                 TEMPX := POSSI;
  1321   7   32:1   648             IF TEMPX > 0 THEN
  1322   7   32:2   655               BEGIN
  1323   7   32:3   655                 GOTOXY( 7, 23);
  1324   7   32:3   660                 CURSBELL( '** CURSED **');
  1325   7   32:3   677                 CHARACTR[ CHARI].POSS.POSSESS[ OBJLIST[ TEMPX]].EQUIPED :=
  1326   7   32:3   701                                                                           TRUE;
  1327   7   32:3   703                 ARMORPOW( CHARI,
  1328   7   32:3   706                           OBJLIST[ TEMPX],
  1329   7   32:3   717                        CHARACTR[ CHARI].POSS.POSSESS[ OBJLIST[ TEMPX]].EQINDEX)
  1330   7   32:2   742               END
  1331   7   32:0   744         END;  (* DOEQUIP *)
  1332   7   32:0   768         
  1333   7   32:0   768         
  1334   7   35:D     1       PROCEDURE UPLCKSKL( LSSUB:    INTEGER;  (* P010123 *)
  1335   7   35:D     2                           LSMODAMT: INTEGER);
  1336   7   35:D     3       
  1337   7   35:0     0         BEGIN
  1338   7   35:1     0           LSMODAMT := CHARACTR[ CHARI].LUCKSKIL[ LSSUB] - LSMODAMT;
  1339   7   35:1    18           IF LSMODAMT < 1 THEN
  1340   7   35:2    23             LSMODAMT := 1;
  1341   7   35:1    26           CHARACTR[ CHARI].LUCKSKIL[ LSSUB] := LSMODAMT
  1342   7   35:0    39         END;
  1343   7   35:0    54         
  1344   7   35:0    54         
  1345   7   36:D     1       PROCEDURE INITSTUF;  (* P010124 *)
  1346   7   36:D     1       
  1347   7   36:D     1         VAR
  1348   7   36:D     1              X : INTEGER;
  1349   7   36:D     2              Y : INTEGER;
  1350   7   36:D     3       
  1351   7   36:0     0         BEGIN
  1352   7   36:1     0           WITH CHARACTR[ CHARI] DO
  1353   7   36:2     9             BEGIN
  1354   7   36:3     9               FOR X := 0 TO 13 DO
  1355   7   36:4    20                 BEGIN
  1356   7   36:5    20                   WEPVSTY2[ 0][ X] := FALSE;
  1357   7   36:5    32                   WEPVSTY2[ 1][ X] := FALSE;
  1358   7   36:5    44                   WEPVSTYP[ X] := FALSE
  1359   7   36:4    51                 END;
  1360   7   36:3    60               FOR Y := 0 TO 6 DO
  1361   7   36:4    71                 BEGIN
  1362   7   36:5    71                   WEPVSTY3[ 0][ Y] := FALSE;
  1363   7   36:5    83                   WEPVSTY3[ 1][ Y] := FALSE
  1364   7   36:4    93                 END
  1365   7   36:2    95             END
  1366   7   36:0   102         END;
  1367   7   36:0   118         
  1368   7   36:0   118         
  1369   7   25:0     0       BEGIN  (* EQUIPCHR *)
  1370   7   25:1     0         WITH CHARACTR[ CHARI] DO
  1371   7   25:2     7           BEGIN
  1372   7   25:3     7             TEMPX := (20 - CHARLEV DIV 5) - (ATTRIB[ LUCK] DIV 6);
  1373   7   25:3    29             IF TEMPX < 1 THEN
  1374   7   25:4    34               TEMPX := 1;
  1375   7   25:3    37             FOR LUCKI := 0 TO 4 DO
  1376   7   25:4    49               LUCKSKIL[ LUCKI] := TEMPX;
  1377   7   25:4    66               
  1378   7   25:3    66             CASE CLASS OF
  1379   7   25:3    72             
  1380   7   25:3    72               FIGHTER :   UPLCKSKL( 0, 3);
  1381   7   25:3    78                  MAGE :   UPLCKSKL( 4, 3);
  1382   7   25:3    84                PRIEST :   UPLCKSKL( 1, 3);
  1383   7   25:3    90                 THIEF :   UPLCKSKL( 3, 3);
  1384   7   25:3    96                 
  1385   7   25:3    96                BISHOP : BEGIN
  1386   7   25:5    96                           UPLCKSKL( 2, 2);
  1387   7   25:5   100                           UPLCKSKL( 4, 2);
  1388   7   25:5   104                           UPLCKSKL( 1, 2);
  1389   7   25:4   108                         END;
  1390   7   25:4   110                         
  1391   7   25:3   110               SAMURAI : BEGIN
  1392   7   25:5   110                           UPLCKSKL( 0, 2);
  1393   7   25:5   114                           UPLCKSKL( 4, 2);
  1394   7   25:4   118                         END;
  1395   7   25:4   120                         
  1396   7   25:3   120                  LORD : BEGIN
  1397   7   25:5   120                           UPLCKSKL( 0, 2);
  1398   7   25:5   124                           UPLCKSKL( 1, 2);
  1399   7   25:4   128                         END;
  1400   7   25:4   130                           
  1401   7   25:3   130                 NINJA : BEGIN
  1402   7   25:5   130                           UPLCKSKL( 0, 3);
  1403   7   25:5   134                           UPLCKSKL( 1, 2);
  1404   7   25:5   138                           UPLCKSKL( 2, 4);
  1405   7   25:5   142                           UPLCKSKL( 3, 3);
  1406   7   25:5   146                           UPLCKSKL( 4, 2);
  1407   7   25:4   150                         END;
  1408   7   25:4   152                
  1409   7   25:3   152             END;
  1410   7   25:3   176             
  1411   7   25:3   176             CASE RACE OF
  1412   7   25:3   182                HUMAN:  UPLCKSKL( 0, 1);
  1413   7   25:3   188                  ELF:  UPLCKSKL( 2, 2);
  1414   7   25:3   194                DWARF:  UPLCKSKL( 3, 4);
  1415   7   25:3   200                GNOME:  UPLCKSKL( 1, 2);
  1416   7   25:3   206               HOBBIT:  UPLCKSKL( 4, 3);
  1417   7   25:3   212             END;
  1418   7   25:3   230             
  1419   7   25:3   230             IF NOT EQUIPALL THEN
  1420   7   25:4   236               FOR TEMPX := 1 TO 8 DO
  1421   7   25:5   248                 POSS.POSSESS[ TEMPX].EQUIPED := FALSE;
  1422   7   25:5   266             
  1423   7   25:3   266             IF (CLASS = PRIEST) OR
  1424   7   25:3   272                (CLASS = FIGHTER) OR
  1425   7   25:3   279                (CLASS >= SAMURAI) THEN
  1426   7   25:4   288               HPCALCMD := 2 + CHARLEV DIV 3
  1427   7   25:3   297             ELSE
  1428   7   25:4   303               HPCALCMD := CHARLEV DIV 5;
  1429   7   25:4   314             
  1430   7   25:3   314             HPDAMRC.LEVEL   := 2;
  1431   7   25:3   320             HPDAMRC.HPFAC   := 2;
  1432   7   25:3   326             HPDAMRC.HPMINAD := 0;
  1433   7   25:3   332             
  1434   7   25:3   332             IF ATTRIB[ STRENGTH] > 15 THEN
  1435   7   25:4   345               BEGIN
  1436   7   25:5   345                 HPCALCMD := HPCALCMD + ATTRIB[ STRENGTH] - 15;
  1437   7   25:5   366                 HPDAMRC.HPMINAD := ATTRIB[ STRENGTH] - 15
  1438   7   25:4   379               END
  1439   7   25:3   382             ELSE
  1440   7   25:4   384               IF ATTRIB[ STRENGTH] < 6 THEN
  1441   7   25:5   397                 HPCALCMD := HPCALCMD + ATTRIB[ STRENGTH] - 6;
  1442   7   25:5   418             
  1443   7   25:3   418             HEALPTS := 0;
  1444   7   25:3   424             
  1445   7   25:3   424             CRITHITM := CLASS = NINJA;
  1446   7   25:3   435             
  1447   7   25:3   435             SWINGCNT := 1;
  1448   7   25:3   441             
  1449   7   25:3   441             IF CLASS = NINJA THEN
  1450   7   25:4   449               HPDAMRC.HPFAC := 4;
  1451   7   25:4   455               
  1452   7   25:3   455             ARMORCL := 10;
  1453   7   25:3   461               
  1454   7   25:3   461             IF (CLASS = FIGHTER) OR
  1455   7   25:3   467                (CLASS >= SAMURAI) THEN
  1456   7   25:4   476               SWINGCNT := SWINGCNT + (CHARLEV DIV 5) + ORD( (CLASS = NINJA)); 
  1457   7   25:4   499               
  1458   7   25:3   499             IF SWINGCNT > 10 THEN
  1459   7   25:4   507               SWINGCNT := 10;
  1460   7   25:4   513               
  1461   7   25:3   513             INITSTUF;
  1462   7   25:3   515             NORMPOW;
  1463   7   25:3   517             UNARMED := TRUE
  1464   7   25:2   517           END;
  1465   7   25:2   520             
  1466   7   25:1   520           IF NOT EQUIPALL THEN
  1467   7   25:2   526             BEGIN
  1468   7   25:3   526               FOR OBJI := WEAPON TO GAUNTLET DO
  1469   7   25:4   538                 DOEQUIP;
  1470   7   25:3   547               OBJI := MISC;
  1471   7   25:3   550               DOEQUIP;
  1472   7   25:3   552               CHSPCPOW
  1473   7   25:2   552             END
  1474   7   25:1   554           ELSE
  1475   7   25:2   556             ARM4CHAR;
  1476   7   25:2   558           
  1477   7   25:1   558           IF CHARACTR[ CHARI].CLASS = NINJA THEN
  1478   7   25:2   569             IF UNARMED THEN
  1479   7   25:3   572               CHARACTR[ CHARI].ARMORCL := (CHARACTR[ CHARI].ARMORCL -
  1480   7   25:3   586                 (CHARACTR[ CHARI].CHARLEV DIV 3)) - 2
  1481   7   25:0   596       END;  (* EQUIPCHR *)
  1482   7   25:0   618 
  1483   7   25:0   618 
  1484   7   25:0   618 
  1485   7   37:D     1     PROCEDURE EQUIP6;  (* P010125 *)
  1486   7   37:D     1     
  1487   7   37:D     1       VAR
  1488   7   37:D     1            PARTYX : INTEGER;
  1489   7   37:D     2            
  1490   7   37:0     0       BEGIN
  1491   7   37:1     0         EQUIPALL := TRUE;
  1492   7   37:1     4         FOR PARTYX := 0 TO (PARTYCNT - 1) DO
  1493   7   37:2    17           EQUIPCHR( PARTYX);
  1494   7   37:1    27         IF XGOTO = XEQUIP6 THEN
  1495   7   37:2    32           XGOTO := XINSPCT2
  1496   7   37:1    32         ELSE
  1497   7   37:2    37           BEGIN
  1498   7   37:3    37             XGOTO := XRUNNER;
  1499   7   37:3    40             GRAPHICS
  1500   7   37:2    40           END
  1501   7   37:0    43       END;
  1502   7   37:0    58       
  1503   7   37:0    58       
  1504   7   38:D     1     PROCEDURE EQUIP1( CHARX : INTEGER);  (* P010126 *)
  1505   7   38:D     2     
  1506   7   38:0     0       BEGIN
  1507   7   38:1     0         EQUIPALL := FALSE;
  1508   7   38:1     4         EQUIPCHR( CHARX);
  1509   7   38:1     7         XGOTO := XBCK2CMP;
  1510   7   38:1    10         LLBASE04 := CHARX
  1511   7   38:0    10       END;
  1512   7   38:0    26       
  1513   7   38:0    26       
  1514   7   38:0    26 
  1515   7   39:D     1     PROCEDURE REORDER;  (* P010127 *)
  1516   7   39:D     1     
  1517   7   39:D     1       VAR
  1518   7   39:D     1            SWITCH   : INTEGER;
  1519   7   39:D     2            PARTYNUM : INTEGER;
  1520   7   39:D     3            PARTYX   : INTEGER;
  1521   7   39:D     4            CHARREC  : TCHAR;
  1522   7   39:D   108            DONE     : BOOLEAN;
  1523   7   39:D   109            LIST     : ARRAY[ 0..5] OF INTEGER;
  1524   7   39:D   115            
  1525   7   39:0     0       BEGIN
  1526   7   39:1     0         XGOTO := XINSPCT2;
  1527   7   39:1     3         IF PARTYCNT < 2 THEN
  1528   7   39:2     8           EXIT( REORDER);
  1529   7   39:1    12         GOTOXY( 0, 11);
  1530   7   39:1    17         WRITE( CHR( 11));
  1531   7   39:1    25         WRITE( 'REORDERING' :25);
  1532   7   39:1    45         FOR PARTYX := 0 TO PARTYCNT - 1 DO
  1533   7   39:2    59           BEGIN
  1534   7   39:3    59             LIST[ PARTYX] := 99;
  1535   7   39:3    66             GOTOXY( 0, 13 + PARTYX);
  1536   7   39:3    73             WRITE( (PARTYX + 1) :1);
  1537   7   39:3    83             WRITE( ')')
  1538   7   39:2    91           END;
  1539   7   39:1    98         FOR PARTYX := 0 TO PARTYCNT - 2 DO
  1540   7   39:2   112           BEGIN
  1541   7   39:3   112             REPEAT
  1542   7   39:4   112               DONE := FALSE;
  1543   7   39:4   115               GOTOXY( 1, 13 + PARTYX);
  1544   7   39:4   122               WRITE( '   ');
  1545   7   39:4   135               GOTOXY( 1, 13 + PARTYX);
  1546   7   39:4   142               WRITE( '>>');
  1547   7   39:4   154               GETKEY;
  1548   7   39:4   157               PARTYNUM := ORD( INCHAR) - ORD( '1');
  1549   7   39:4   162               IF (PARTYNUM >= 0) AND (PARTYNUM < PARTYCNT) THEN
  1550   7   39:5   171                 IF LIST[ PARTYNUM] = 99 THEN
  1551   7   39:6   181                   BEGIN
  1552   7   39:7   181                     LIST[ PARTYNUM] := PARTYX;
  1553   7   39:7   188                     DONE := TRUE
  1554   7   39:6   188                   END
  1555   7   39:3   191             UNTIL DONE;
  1556   7   39:3   195             GOTOXY( 1, 13 + PARTYX);
  1557   7   39:3   202             WRITE( ') ');
  1558   7   39:3   214             WRITE( CHARACTR[ PARTYNUM].NAME)
  1559   7   39:2   226           END;
  1560   7   39:1   233         FOR PARTYX := 0 TO PARTYCNT - 2 DO
  1561   7   39:2   247           FOR PARTYNUM := PARTYX + 1 TO PARTYCNT - 1 DO
  1562   7   39:3   263             IF LIST[ PARTYNUM] < LIST[ PARTYX] THEN
  1563   7   39:4   278               BEGIN
  1564   7   39:5   278                 CHARREC := CHARACTR[ PARTYX];
  1565   7   39:5   287                 CHARACTR[ PARTYX] := CHARACTR[ PARTYNUM];
  1566   7   39:5   299                 CHARACTR[ PARTYNUM] := CHARREC;
  1567   7   39:5   308                 SWITCH := CHARDISK[ PARTYX];
  1568   7   39:5   316                 CHARDISK[ PARTYX] := CHARDISK[ PARTYNUM];
  1569   7   39:5   328                 CHARDISK[ PARTYNUM] := SWITCH;
  1570   7   39:5   335                 SWITCH := LIST[ PARTYX];
  1571   7   39:5   343                 LIST[ PARTYX] := LIST[ PARTYNUM];
  1572   7   39:5   355                 LIST[ PARTYNUM] := SWITCH
  1573   7   39:4   360               END;
  1574   7   39:1   376         GOTOXY( 1, 13 + PARTYCNT - 1);
  1575   7   39:1   385         WRITE( ') ');
  1576   7   39:1   397         WRITE( CHARACTR[ PARTYCNT - 1].NAME)
  1577   7   39:0   411       END; (* REORDER *)
  1578   7   39:0   436 
  1579   7   39:0   436 (*$I WIZ1B:UTILITIE2 *)
  1579   7   39:0   436 (*$I WIZ1B:UTILITIE3 *)
  1580   7   39:0   436     
  1581   7    1:0     0   BEGIN (* UTILITIE *)
  1582   7    1:0     0   
  1583   7    1:1     0     IF XGOTO <> XNEWMAZE THEN
  1584   7    1:2     5       TEXTMODE;
  1585   7    1:2     8       
  1586   7    1:1     8     CASE XGOTO OF
  1587   7    1:1    11     
  1588   7    1:1    11       XCAMPSTF:
  1589   7    1:2    11                 CASE BASE12.GOTOX OF
  1590   7    1:2    15                   XDONE    : RDSPELLS;
  1591   7    1:2    19                   XTRAININ : IDITEM;
  1592   7    1:2    23                   XCASTLE  : KANDIFND;
  1593   7    1:2    27                   XGILGAMS : DUMAPIC;
  1594   7    1:2    31                   XINSPECT : MALOR;
  1595   7    1:2    35                 END;
  1596   7    1:2    54         
  1597   7    1:1    54       XNEWMAZE:  NEWMAZE;
  1598   7    1:1    58       
  1599   7    1:1    58       XEQUIP6,
  1600   7    1:1    58       XCMP2EQ6:  EQUIP6;
  1601   7    1:1    62       
  1602   7    1:1    62       XREORDER:  REORDER;
  1603   7    1:1    66       
  1604   7    1:1    66       XEQPDSP:   IF LLBASE04 >= 0 THEN
  1605   7    1:3    71                    EQUIP1( LLBASE04)
  1606   7    1:2    72                  ELSE
  1607   7    1:3    76                    BEGIN
  1608   7    1:4    76                      FOR CHARI := 0 TO PARTYCNT - 1 DO
  1609   7    1:5    89                        EQUIP1( CHARI);
  1610   7    1:4    99                      XGOTO := XINSPCT2
  1611   7    1:3    99                    END;
  1612   7    1:1   104     END;
  1613   7    1:1   144 
  1614   7    1:0   144   END; (* UTILITIE *)
  1615   7    1:0   158 (*$I WIZ1B:UTILITIE3 *)
  1616   7    1:0   158 
  1616   7    1:0   158 (*$I WIZ1B:SHOPS     *)
  1617   7    1:0   158   
  1618   8    1:D     1 SEGMENT PROCEDURE SHOPS;  (* P010201 *)
  1619   8    1:D     1   
  1620   8    2:D     1     PROCEDURE CANT;  (* P010202 *)
  1621   8    2:D     1     
  1622   8    2:D     1       VAR
  1623   8    2:D     1            WHOHELP  : INTEGER;
  1624   8    2:D     2            UNUSEDXX : INTEGER;
  1625   8    2:D     3            WHOPAY   : INTEGER;
  1626   8    2:D     4            WHOHELPX : INTEGER;
  1627   8    2:D     5            DISABLED : STRING;
  1628   8    2:D    46            WHO      : TCHAR;
  1629   8    2:D   150     
  1630   8    2:D   150       
  1631   8    3:D     1       PROCEDURE CANTSHOP;  (* P010203 *)
  1632   8    3:D     1       
  1633   8    3:D     1       
  1634   8    4:D     1         PROCEDURE DSP2STR( STR1: STRING; STR2: STRING);  (* P010204 *)
  1635   8    4:D    85         
  1636   8    4:0     0           BEGIN
  1637   8    4:1     0             CENTSTR( CONCAT('** ', STR1, STR2, ' **') );
  1638   8    4:1    62             EXIT( CANTSHOP)
  1639   8    4:0    66           END;
  1640   8    4:0    78           
  1641   8    4:0    78           
  1642   8    5:D     1         PROCEDURE WELCOME;  (* P010205 *)
  1643   8    5:D     1         
  1644   8    5:0     0           BEGIN
  1645   8    5:1     0             GOTOXY( 0, 13);
  1646   8    5:1     5             WRITE( CHR( 11));
  1647   8    5:1    13             WRITELN( ' WELCOME TO THE TEMPLE OF RADIANT CANT!');
  1648   8    5:1    68             WRITELN;
  1649   8    5:1    74             WRITE( 'WHO ARE YOU HELPING ? >');
  1650   8    5:1   107             GETLINE( DISABLED);
  1651   8    5:1   113             IF DISABLED = '' THEN
  1652   8    5:2   123               EXIT( CANT);
  1653   8    5:1   127             WHOHELPX := 0;
  1654   8    5:1   131             MOVELEFT( IOCACHE[ GETREC( ZCHAR, WHOHELPX, SIZEOF( TCHAR))],
  1655   8    5:1   146                       WHO,
  1656   8    5:1   150                       SIZEOF( TCHAR));
  1657   8    5:1   155             WHILE (WHOHELPX < SCNTOC.RECPERDK[ ZCHAR]) AND
  1658   8    5:1   166                   (DISABLED <> WHO.NAME) DO
  1659   8    5:2   177               BEGIN
  1660   8    5:3   177                 WHOHELPX := WHOHELPX + 1;
  1661   8    5:3   185                 MOVELEFT( IOCACHE[ GETREC( ZCHAR, WHOHELPX, SIZEOF( TCHAR))],
  1662   8    5:3   200                           WHO,
  1663   8    5:3   204                           SIZEOF( TCHAR))
  1664   8    5:2   209               END;
  1665   8    5:1   211             IF WHOHELPX = SCNTOC.RECPERDK[ ZCHAR] THEN
  1666   8    5:2   224               DSP2STR( '', 'WHO?');
  1667   8    5:2   236             
  1668   8    5:1   236             IF ((WHO.LOSTXYL.LOCATION[ 1] +
  1669   8    5:1   246                  WHO.LOSTXYL.LOCATION[ 2] +
  1670   8    5:1   257                  WHO.LOSTXYL.LOCATION[ 3] ) <> 0)
  1671   8    5:1   270                      OR
  1672   8    5:1   270                  WHO.INMAZE THEN
  1673   8    5:2   276               DSP2STR( WHO.NAME, ' IS NOT HERE');
  1674   8    5:1   296             IF WHO.STATUS = LOST THEN
  1675   8    5:2   303               DSP2STR( WHO.NAME, ' IS LOST');
  1676   8    5:1   319             IF WHO.STATUS = OK THEN
  1677   8    5:2   326               DSP2STR( WHO.NAME, ' IS OK');
  1678   8    5:1   340             WHOHELP := WHOHELPX
  1679   8    5:0   340           END;
  1680   8    5:0   360           
  1681   8    5:0   360           
  1682   8    6:D     1         PROCEDURE PAYCANT;  (* P010206 *)
  1683   8    6:D     1         
  1684   8    6:D     1           VAR
  1685   8    6:D     1                PAYAMT : TWIZLONG;
  1686   8    6:D     4         
  1687   8    6:D     4         
  1688   8    7:D     1           PROCEDURE GETPAYER;  (* P010207 *)
  1689   8    7:D     1           
  1690   8    7:0     0             BEGIN
  1691   8    7:1     0               PAYAMT.HIGH := 0;
  1692   8    7:1     4               PAYAMT.MID := 0;
  1693   8    7:1     8               CASE WHO.STATUS OF
  1694   8    7:1    13                 PLYZE  : PAYAMT.LOW := 100;
  1695   8    7:1    19                 STONED : PAYAMT.LOW := 200;
  1696   8    7:1    27                 DEAD   : PAYAMT.LOW := 250;
  1697   8    7:1    35                 ASHES  : PAYAMT.LOW := 500;
  1698   8    7:1    43               END;
  1699   8    7:1    58               MULTLONG( PAYAMT, WHO.CHARLEV);
  1700   8    7:1    67               GOTOXY( 0, 17);
  1701   8    7:1    72               WRITE( CHR( 11));
  1702   8    7:1    80               WRITE( 'THE DONATION WILL BE ');
  1703   8    7:1   111               PRNTLONG( PAYAMT);
  1704   8    7:1   117               WRITELN;
  1705   8    7:1   123               WHOPAY := GETCHARX( FALSE, 'WHO WILL TITHE');
  1706   8    7:1   149               IF WHOPAY = -1 THEN
  1707   8    7:2   157                 EXIT( CANTSHOP);
  1708   8    7:1   161               IF TESTLONG( PAYAMT, CHARACTR[ WHOPAY].GOLD) > 0 THEN
  1709   8    7:2   182                 DSP2STR( '', 'CHEAP APOSTATES! OUT!');
  1710   8    7:1   211               SUBLONGS( CHARACTR[ WHOPAY].GOLD, PAYAMT)
  1711   8    7:0   223             END;
  1712   8    7:0   238             
  1713   8    7:0   238             
  1714   8    8:D     1           PROCEDURE DOCANT;  (* P010208 *)
  1715   8    8:D     1           
  1716   8    8:D     1           
  1717   8    9:D     1             PROCEDURE ASHLOST;  (* P010209 *)
  1718   8    9:D     1             
  1719   8    9:0     0               BEGIN
  1720   8    9:1     0                 IF WHO.STATUS = DEAD THEN
  1721   8    9:2     7                   WHO.STATUS := ASHES
  1722   8    9:1     7                 ELSE
  1723   8    9:2    13                   WHO.STATUS := LOST;
  1724   8    9:1    17                 WHO.INMAZE := FALSE;
  1725   8    9:1    21                 MOVELEFT( WHO,
  1726   8    9:1    25                           IOCACHE[ GETRECW( ZCHAR, WHOHELP, SIZEOF( TCHAR))],
  1727   8    9:1    40                           SIZEOF( TCHAR));
  1728   8    9:1    45                 WRITELN;
  1729   8    9:1    51                 IF WHO.STATUS = LOST THEN
  1730   8    9:2    58                   DSP2STR( WHO.NAME, ' WILL BE BURIED') 
  1731   8    9:1    79                 ELSE
  1732   8    9:2    83                   DSP2STR( WHO.NAME, ' NEEDS KADORTO NOW')
  1733   8    9:0   107               END; (* ASHLOST *)
  1734   8    9:0   122               
  1735   8    9:0   122               
  1736   8    8:0     0             BEGIN (* DOCANT *)
  1737   8    8:1     0               GOTOXY( 0, 17);
  1738   8    8:1     5               WRITE( CHR( 11));
  1739   8    8:1    13               WRITE( 'MURMUR - ');
  1740   8    8:1    32               PAUSE2;
  1741   8    8:1    35               WRITE( 'CHANT - ');
  1742   8    8:1    53               PAUSE2;
  1743   8    8:1    56               WRITE( 'PRAY - ');
  1744   8    8:1    73               PAUSE2;
  1745   8    8:1    76               WRITE( 'INVOKE!');
  1746   8    8:1    93               WRITELN;
  1747   8    8:1    99               
  1748   8    8:1    99               IF WHO.STATUS = DEAD THEN
  1749   8    8:2   106                 BEGIN
  1750   8    8:3   106                   IF (RANDOM MOD 100) > (50 + 3 * WHO.ATTRIB[ VITALITY]) THEN
  1751   8    8:4   128                     ASHLOST
  1752   8    8:3   128                   ELSE
  1753   8    8:4   132                     WHO.HPLEFT := 1
  1754   8    8:2   132                 END
  1755   8    8:1   136               ELSE IF WHO.STATUS = ASHES THEN
  1756   8    8:3   145                 BEGIN
  1757   8    8:4   145                   IF (RANDOM MOD 100) > (40 + 3 * WHO.ATTRIB[ VITALITY]) THEN
  1758   8    8:5   167                     ASHLOST
  1759   8    8:4   167                   ELSE
  1760   8    8:5   171                     WHO.HPLEFT := WHO.HPMAX
  1761   8    8:3   171                 END;
  1762   8    8:3   177                 
  1763   8    8:1   177               WHO.AGE := WHO.AGE + (RANDOM MOD 52) + 1;
  1764   8    8:1   193               WHO.STATUS := OK;
  1765   8    8:1   197               MOVELEFT( WHO, 
  1766   8    8:1   201                         IOCACHE[ GETRECW( ZCHAR, WHOHELP, SIZEOF( TCHAR))],
  1767   8    8:1   216                         SIZEOF( TCHAR));
  1768   8    8:1   221               WRITELN;
  1769   8    8:1   227               DSP2STR( WHO.NAME, ' IS WELL')
  1770   8    8:0   241             END;
  1771   8    8:0   256             
  1772   8    8:0   256             
  1773   8    6:0     0           BEGIN (* PAYCANT *)
  1774   8    6:1     0             GETPAYER;
  1775   8    6:1     2             DOCANT
  1776   8    6:0     2           END;
  1777   8    6:0    16           
  1778   8    6:0    16           
  1779   8    3:0     0         BEGIN (* CANTSHOP *)
  1780   8    3:1     0           WELCOME;
  1781   8    3:1     2           PAYCANT
  1782   8    3:0     2         END;
  1783   8    3:0    16         
  1784   8    3:0    16         
  1785   8    2:0     0       BEGIN (* CANT *)
  1786   8    2:1     0         XGOTO := XCASTLE;
  1787   8    2:1     3         REPEAT
  1788   8    2:2     3           CANTSHOP
  1789   8    2:1     3         UNTIL FALSE;
  1790   8    2:1     8         EXIT( SHOPS)
  1791   8    2:0    12       END; (* CANT *)
  1792   8    2:0    26   
  1793   8    2:0    26   
  1794   8   10:D     1     PROCEDURE BOLTAC;  (* P01020A *)
  1795   8   10:D     1     
  1796   8   10:D     1       VAR
  1797   8   10:D     1            INVENTX  : INTEGER;
  1798   8   10:D     2            HALFPRIC : INTEGER;
  1799   8   10:D     3            OBJECT   : TOBJREC;
  1800   8   10:D    42            CHARI    : INTEGER;
  1801   8   10:D    43            UNUSEDXX : ARRAY[ 1..41] OF INTEGER;
  1802   8   10:D    84            
  1803   8   10:D    84            
  1804   8   11:D     1       PROCEDURE DOPLAYER;  (* P01020B *)
  1805   8   11:D     1       
  1806   8   11:D     1         CONST
  1807   8   11:D     1         
  1808   8   11:D     1         (* ACTION *)
  1809   8   11:D     1              SELL     = 0;
  1810   8   11:D     1              UNCURSE  = 1;
  1811   8   11:D     1              IDENTIFY = 2;
  1812   8   11:D     1              BUY      = 3;
  1813   8   11:D     1              POOLGOLD = 4;
  1814   8   11:D     1              LEAVE    = 5;
  1815   8   11:D     1       
  1816   8   11:D     1         VAR
  1817   8   11:D     1             OBJLIST  : ARRAY[ 1..6] OF INTEGER;
  1818   8   11:D     7             UNUSEDXX : INTEGER;
  1819   8   11:D     8             UNUSEDYY : INTEGER;
  1820   8   11:D     9             POSSCNT  : INTEGER;
  1821   8   11:D    10       
  1822   8   11:D    10       
  1823   8   12:D     1         PROCEDURE DOBUY;  (* P01020C *)
  1824   8   12:D     1         
  1825   8   12:D     1           VAR
  1826   8   12:D     1                NOTPURCH : BOOLEAN;
  1827   8   12:D     2                SCROLDIR : INTEGER;
  1828   8   12:D     3                BUYX     : INTEGER;
  1829   8   12:D     4         
  1830   8   12:D     4             
  1831   8   13:D     1           PROCEDURE SCROLPOS;  (* P01020D *)
  1832   8   13:D     1           
  1833   8   13:D     1             VAR
  1834   8   13:D     1                  X : INTEGER;
  1835   8   13:D     2           
  1836   8   13:0     0             BEGIN
  1837   8   13:1     0               INVENTX := OBJLIST[ 6] - 1;
  1838   8   13:1    14               FOR X := 1 TO 6 DO
  1839   8   13:2    25                 BEGIN
  1840   8   13:3    25                   GOTOXY( 0, 12 + X);
  1841   8   13:3    32                   WRITE( CHR( 29));
  1842   8   13:3    40                   REPEAT
  1843   8   13:4    40                     INVENTX := INVENTX + 1;
  1844   8   13:4    48                     IF INVENTX >= SCNTOC.RECPERDK[ ZOBJECT] THEN
  1845   8   13:5    61                       INVENTX := 1;
  1846   8   13:4    65                     MOVELEFT( IOCACHE[ GETREC( ZOBJECT,
  1847   8   13:4    69                                                INVENTX,
  1848   8   13:4    72                                                SIZEOF( TOBJREC))],
  1849   8   13:4    78                               OBJECT,
  1850   8   13:4    82                               SIZEOF( TOBJREC));
  1851   8   13:3    85                   UNTIL (OBJECT.BOLTACXX <> 0) AND
  1852   8   13:3    90                         (NOT OBJECT.CURSED);
  1853   8   13:3    97                   OBJLIST[ X] := INVENTX;
  1854   8   13:3   109                   WRITE( X : 1);
  1855   8   13:3   117                   WRITE( ')');
  1856   8   13:3   125                   WRITE( OBJECT.NAME : 15);
  1857   8   13:3   135                   WRITE( ' ');
  1858   8   13:3   143                   PRNTLONG( OBJECT.PRICE);
  1859   8   13:3   149                   IF NOT OBJECT.CLASSUSE[ CHARACTR[ CHARI].CLASS] THEN
  1860   8   13:4   168                     WRITE( ' UNUSABLE')
  1861   8   13:2   187                 END
  1862   8   13:0   187             END;
  1863   8   13:0   212             
  1864   8   13:0   212             
  1865   8   14:D     1           PROCEDURE SCROLNEG;  (* P01020E *)
  1866   8   14:D     1           
  1867   8   14:D     1             VAR
  1868   8   14:D     1                  X : INTEGER;
  1869   8   14:D     2           
  1870   8   14:0     0             BEGIN
  1871   8   14:1     0               INVENTX := OBJLIST[ 1] + 1;
  1872   8   14:1    14               FOR X := 6 DOWNTO 1 DO
  1873   8   14:2    25                 BEGIN
  1874   8   14:3    25                   GOTOXY( 0, 12 + X);
  1875   8   14:3    32                   WRITE( CHR( 29));
  1876   8   14:3    40                   REPEAT
  1877   8   14:4    40                     INVENTX := INVENTX - 1;
  1878   8   14:4    48                     IF INVENTX < 1 THEN
  1879   8   14:5    55                       INVENTX := SCNTOC.RECPERDK[ ZOBJECT] - 1;
  1880   8   14:4    67                     MOVELEFT( IOCACHE[ GETREC( ZOBJECT,
  1881   8   14:4    71                                                INVENTX,
  1882   8   14:4    74                                                SIZEOF( TOBJREC))],
  1883   8   14:4    80                               OBJECT,
  1884   8   14:4    84                               SIZEOF( TOBJREC))
  1885   8   14:3    87                   UNTIL (OBJECT.BOLTACXX <> 0) AND
  1886   8   14:3    92                         (NOT OBJECT.CURSED);
  1887   8   14:3    99                   OBJLIST[ X] := INVENTX;
  1888   8   14:3   111                   WRITE( X : 1);
  1889   8   14:3   119                   WRITE( ')');
  1890   8   14:3   127                   WRITE( OBJECT.NAME : 15);
  1891   8   14:3   137                   WRITE( ' ');
  1892   8   14:3   145                   PRNTLONG( OBJECT.PRICE);
  1893   8   14:3   151                   IF NOT OBJECT.CLASSUSE[ CHARACTR[ CHARI].CLASS] THEN
  1894   8   14:4   170                     WRITE( ' UNUSABLE')
  1895   8   14:2   189                 END
  1896   8   14:0   189             END;
  1897   8   14:0   214           
  1898   8   14:0   214           
  1899   8   15:D     1           PROCEDURE PURCHASE;  (* P01020F *)
  1900   8   15:D     1           
  1901   8   15:D     1             VAR
  1902   8   15:D     1                  INSERTX : INTEGER;
  1903   8   15:D     2           
  1904   8   15:D     2           
  1905   8   16:D     1             PROCEDURE AASTRAA( ASTR: STRING);  (* P010210 *)
  1906   8   16:D    43             
  1907   8   16:0     0               BEGIN
  1908   8   16:1     0                 CENTSTR( CONCAT( '** ', ASTR, ' **'));
  1909   8   16:1    45                 EXIT( PURCHASE);
  1910   8   16:0    49               END;
  1911   8   16:0    62               
  1912   8   16:0    62               
  1913   8   15:0     0             BEGIN (* PURCHASE *)
  1914   8   15:1     0               REPEAT
  1915   8   15:2     0                 NOTPURCH := FALSE;
  1916   8   15:2     4                 GOTOXY( 0, 21);
  1917   8   15:2     9                 WRITELN( CHR( 11));
  1918   8   15:2    23                 WRITE( 'PURCHASE WHICH ITEM ([RETURN] EXITS) ? >');
  1919   8   15:2    73                 GETKEY;
  1920   8   15:2    76                 BUYX := ORD( INCHAR) - ORD( '0');
  1921   8   15:2    82                 IF INCHAR = CHR( CRETURN) THEN
  1922   8   15:3    87                   EXIT( PURCHASE);
  1923   8   15:1    91               UNTIL (BUYX > 0) AND (BUYX <= 6);
  1924   8   15:1   104               
  1925   8   15:1   104               MOVELEFT( IOCACHE[ GETREC( ZOBJECT,
  1926   8   15:1   108                                          OBJLIST[ BUYX],
  1927   8   15:1   119                                          SIZEOF( TOBJREC))],
  1928   8   15:1   125                         OBJECT,
  1929   8   15:1   129                         SIZEOF( TOBJREC));
  1930   8   15:1   132                         
  1931   8   15:1   132               IF OBJECT.BOLTACXX = 0 THEN
  1932   8   15:2   139                 AASTRAA( 'YOU BOUGHT THE LAST ONE')
  1933   8   15:1   165               ELSE IF CHARACTR[ CHARI].POSS.POSSCNT = 8 THEN
  1934   8   15:3   182                 AASTRAA( 'YOU CANT CARRY ANYTHING MORE')
  1935   8   15:2   213               ELSE IF TESTLONG( CHARACTR[ CHARI].GOLD, OBJECT.PRICE) < 0 THEN
  1936   8   15:4   238                 AASTRAA( 'YOU CANNOT AFFORD IT');
  1937   8   15:4   263                 
  1938   8   15:1   263               IF NOT (OBJECT.CLASSUSE[ CHARACTR[ CHARI].CLASS]) THEN
  1939   8   15:2   282                 BEGIN
  1940   8   15:3   282                   GOTOXY( 0, 22);
  1941   8   15:3   287                   WRITE( CHR( 11));
  1942   8   15:3   295                   WRITE( 'UNUSABLE ITEM - CONFIRM BUY (Y/N) ? >');
  1943   8   15:3   342                   REPEAT
  1944   8   15:4   342                     GETKEY
  1945   8   15:3   342                   UNTIL (INCHAR = 'Y') OR (INCHAR = 'N');
  1946   8   15:3   354                   IF INCHAR = 'N' THEN
  1947   8   15:4   359                     AASTRAA( 'WE ALL MAKE MISTAKES')
  1948   8   15:2   382                 END
  1949   8   15:1   384               ELSE
  1950   8   15:2   386                 INCHAR := ' ';
  1951   8   15:1   389               SUBLONGS( CHARACTR[ CHARI].GOLD, OBJECT.PRICE);
  1952   8   15:1   404               INSERTX := CHARACTR[ CHARI].POSS.POSSCNT + 1;
  1953   8   15:1   417               
  1954   8   15:1   417               WITH CHARACTR[ CHARI].POSS.POSSESS[ INSERTX] DO
  1955   8   15:2   433                 BEGIN
  1956   8   15:3   433                   EQUIPED := FALSE;
  1957   8   15:3   436                   IDENTIF := TRUE;
  1958   8   15:3   441                   CURSED  := FALSE;
  1959   8   15:3   446                   EQINDEX := OBJLIST[ BUYX];
  1960   8   15:2   461                 END;
  1961   8   15:1   461               CHARACTR[ CHARI].POSS.POSSCNT := INSERTX;
  1962   8   15:1   472               IF OBJECT.BOLTACXX > 0 THEN
  1963   8   15:2   479                 OBJECT.BOLTACXX := OBJECT.BOLTACXX - 1;
  1964   8   15:1   487               MOVELEFT( OBJECT,
  1965   8   15:1   491                         IOCACHE[ GETRECW( ZOBJECT,
  1966   8   15:1   495                                           OBJLIST[ BUYX],
  1967   8   15:1   506                                           SIZEOF( TOBJREC))],
  1968   8   15:1   512                         SIZEOF( TOBJREC));
  1969   8   15:1   515               IF ORD( INCHAR) = ORD( 'Y') THEN
  1970   8   15:2   520                 AASTRAA( 'ITS YOUR MONEY')
  1971   8   15:1   537               ELSE
  1972   8   15:2   541                 AASTRAA( 'JUST WHAT YOU NEEDED')
  1973   8   15:0   564             END; (* PURCHASE *)
  1974   8   15:0   582             
  1975   8   15:0   582             
  1976   8   12:0     0           BEGIN (* DOBUY *)
  1977   8   12:1     0             INVENTX := 1;
  1978   8   12:1     4             NOTPURCH := TRUE;
  1979   8   12:1     7             OBJLIST[ 1] := 1;
  1980   8   12:1    17             OBJLIST[ 6] := 1;
  1981   8   12:1    27             SCROLDIR := 1;
  1982   8   12:1    30             GOTOXY( 0, 13);
  1983   8   12:1    35             WRITE( CHR(11));
  1984   8   12:1    43             REPEAT
  1985   8   12:2    43               IF NOTPURCH THEN
  1986   8   12:3    46                 IF SCROLDIR = 1 THEN
  1987   8   12:4    51                   SCROLPOS
  1988   8   12:3    51                 ELSE
  1989   8   12:4    55                   SCROLNEG;
  1990   8   12:2    57               NOTPURCH := TRUE;
  1991   8   12:2    60               SCROLDIR := 1;
  1992   8   12:2    63               GOTOXY(  0, 20);
  1993   8   12:2    68               WRITE( CHR( 11));
  1994   8   12:2    76               WRITE( 'YOU HAVE ');
  1995   8   12:2    95               PRNTLONG( CHARACTR[ CHARI].GOLD);
  1996   8   12:2   107               WRITELN( ' GOLD');
  1997   8   12:2   128               WRITELN( 'YOU MAY P)URCHASE, SCROLL');
  1998   8   12:2   169               WRITE( ' ' :8);
  1999   8   12:2   177               WRITELN( 'F)ORWARD OR B)ACK, GO TO THE');
  2000   8   12:2   221               WRITE( ' ' :8);
  2001   8   12:2   229               WRITE( 'S)TART, OR L)EAVE');
  2002   8   12:2   256               GOTOXY( 41, 0);
  2003   8   12:2   261               REPEAT
  2004   8   12:3   261                 GETKEY
  2005   8   12:2   261               UNTIL (INCHAR = 'P') OR (INCHAR = 'F') OR
  2006   8   12:2   271                     (INCHAR = 'B') OR (INCHAR = 'S') OR
  2007   8   12:2   279                     (INCHAR = 'L');
  2008   8   12:2   285               
  2009   8   12:2   285               CASE INCHAR OF
  2010   8   12:2   288                 'P': PURCHASE;
  2011   8   12:2   292                 'S': OBJLIST[ 6] := 1;
  2012   8   12:2   304                 'B': SCROLDIR := - 1;
  2013   8   12:2   310               END
  2014   8   12:1   354             UNTIL INCHAR = 'L'
  2015   8   12:0   355           END;
  2016   8   12:0   376           
  2017   8   12:0   376           
  2018   8   17:D     1         PROCEDURE SELLIDUN( ACTION: INTEGER);  (* P010211 *)
  2019   8   17:D     2         
  2020   8   17:D     2           VAR
  2021   8   17:D     2                UNUSEDXX : ARRAY[ 1..3] OF INTEGER;
  2022   8   17:D     5                TRANOBJX : INTEGER;
  2023   8   17:D     6         
  2024   8   17:D     6         
  2025   8   18:D     1           PROCEDURE LISTPOSS;  (* P010212 *)
  2026   8   18:D     1           
  2027   8   18:0     0             BEGIN
  2028   8   18:1     0               GOTOXY( 0, 13);
  2029   8   18:1     5               WRITE( CHR( 11));
  2030   8   18:1    13               POSSCNT := CHARACTR[ CHARI].POSS.POSSCNT;
  2031   8   18:1    25               FOR TRANOBJX := 1 TO POSSCNT DO
  2032   8   18:2    41                 BEGIN
  2033   8   18:3    41                   OBJLIST[ TRANOBJX] :=
  2034   8   18:3    51                     CHARACTR[ CHARI].POSS.POSSESS[ TRANOBJX].EQINDEX;
  2035   8   18:3    69                   MOVELEFT( IOCACHE[ GETREC( ZOBJECT,
  2036   8   18:3    73                                              OBJLIST[ TRANOBJX],
  2037   8   18:3    84                                              SIZEOF( TOBJREC))],
  2038   8   18:3    90                             OBJECT,
  2039   8   18:3    94                             SIZEOF( TOBJREC));
  2040   8   18:3    97                   WRITE( TRANOBJX : 1);
  2041   8   18:3   107                   WRITE( CHR( 41));
  2042   8   18:3   115                   IF CHARACTR[ CHARI].POSS.POSSESS[ TRANOBJX].IDENTIF THEN
  2043   8   18:4   134                     WRITE( OBJECT.NAME : 15)
  2044   8   18:3   144                   ELSE
  2045   8   18:4   146                     WRITE( OBJECT.NAMEUNK : 15);
  2046   8   18:3   156                   WRITE( ' ');
  2047   8   18:3   164                   DIVLONG( OBJECT.PRICE, HALFPRIC);
  2048   8   18:3   173                   IF ACTION = SELL THEN
  2049   8   18:4   180                     BEGIN
  2050   8   18:5   180                       IF NOT (CHARACTR[ CHARI].POSS.POSSESS[ TRANOBJX].IDENTIF)
  2051   8   18:5   196                       THEN
  2052   8   18:6   200                         BEGIN
  2053   8   18:7   200                           OBJECT.PRICE.HIGH := 0;
  2054   8   18:7   204                           OBJECT.PRICE.MID  := 0;
  2055   8   18:7   208                           OBJECT.PRICE.LOW  := 1
  2056   8   18:6   208                         END
  2057   8   18:4   212                     END;
  2058   8   18:3   212                   PRNTLONG(  OBJECT.PRICE);
  2059   8   18:3   218                   WRITELN
  2060   8   18:2   218                 END
  2061   8   18:0   224             END;
  2062   8   18:0   250             
  2063   8   18:0   250             
  2064   8   19:D     1           PROCEDURE TRANSACT;  (* P010213 *)
  2065   8   19:D     1           
  2066   8   19:D     1             VAR
  2067   8   19:D     1                  POSSX : INTEGER;
  2068   8   19:D     2           
  2069   8   19:D     2           
  2070   8   20:D     1             PROCEDURE AASTRAA( ASTR: STRING);  (* P010214 *)
  2071   8   20:D    43             
  2072   8   20:0     0               BEGIN
  2073   8   20:1     0                 CENTSTR( ASTR);
  2074   8   20:1    10                 EXIT( TRANSACT)
  2075   8   20:0    14               END;
  2076   8   20:0    26               
  2077   8   20:0    26               
  2078   8   19:0     0             BEGIN (* TRANSACT *)
  2079   8   19:1     0               MOVELEFT( IOCACHE[ GETREC( ZOBJECT,
  2080   8   19:1     4                                          OBJLIST[ TRANOBJX],
  2081   8   19:1    15                                          SIZEOF( TOBJREC))],
  2082   8   19:1    21                         OBJECT,
  2083   8   19:1    25                         SIZEOF( TOBJREC));
  2084   8   19:1    28               DIVLONG( OBJECT.PRICE, HALFPRIC);
  2085   8   19:1    37               IF ACTION = SELL THEN
  2086   8   19:2    44                 BEGIN
  2087   8   19:3    44                   IF NOT CHARACTR[ CHARI].POSS.POSSESS[ TRANOBJX].IDENTIF THEN
  2088   8   19:4    64                     BEGIN
  2089   8   19:5    64                       OBJECT.PRICE.HIGH := 0;
  2090   8   19:5    68                       OBJECT.PRICE.MID  := 0;
  2091   8   19:5    72                       OBJECT.PRICE.LOW  := 1
  2092   8   19:4    72                     END;
  2093   8   19:3    76                   IF CHARACTR[ CHARI].POSS.POSSESS[ TRANOBJX].CURSED THEN
  2094   8   19:4    95                     AASTRAA( '** WE DONT BUY CURSED ITEMS **')
  2095   8   19:2   128                 END
  2096   8   19:1   130               ELSE
  2097   8   19:2   132                 BEGIN
  2098   8   19:3   132                   IF NOT (CHARACTR[ CHARI].POSS.POSSESS[ TRANOBJX].CURSED) AND
  2099   8   19:3   150                      (ACTION = UNCURSE) THEN
  2100   8   19:4   158                     AASTRAA( '** THAT IS NOT A CURSED ITEM **');
  2101   8   19:4   194                     
  2102   8   19:3   194                   IF CHARACTR[ CHARI].POSS.POSSESS[ TRANOBJX].IDENTIF AND
  2103   8   19:3   211                       (ACTION = IDENTIFY) THEN
  2104   8   19:4   219                     AASTRAA( '** THAT HAS BEEN IDENTIFIED **');
  2105   8   19:4   254                     
  2106   8   19:3   254                   IF TESTLONG( CHARACTR[ CHARI].GOLD, OBJECT.PRICE) < 0 THEN
  2107   8   19:4   275                     AASTRAA( '** YOU CANT AFFORD THE FEE **');
  2108   8   19:2   309                 END;
  2109   8   19:2   309               
  2110   8   19:1   309               IF ACTION = SELL THEN
  2111   8   19:2   316                 ADDLONGS( CHARACTR[ CHARI].GOLD, OBJECT.PRICE)
  2112   8   19:1   328               ELSE
  2113   8   19:2   333                 SUBLONGS( CHARACTR[ CHARI].GOLD, OBJECT.PRICE);
  2114   8   19:2   348                 
  2115   8   19:1   348               IF ACTION = IDENTIFY THEN
  2116   8   19:2   355                 CHARACTR[ CHARI].POSS.POSSESS[ TRANOBJX].IDENTIF := TRUE
  2117   8   19:1   373               ELSE
  2118   8   19:2   377                 BEGIN
  2119   8   19:3   377                   IF TRANOBJX < CHARACTR[ CHARI].POSS.POSSCNT THEN
  2120   8   19:4   392                     FOR POSSX := (TRANOBJX + 1) TO
  2121   8   19:4   399                                    CHARACTR[ CHARI].POSS.POSSCNT DO
  2122   8   19:5   415                       CHARACTR[ CHARI].POSS.POSSESS[ POSSX - 1] :=
  2123   8   19:5   431                         CHARACTR[ CHARI].POSS.POSSESS[ POSSX];
  2124   8   19:5   454                         
  2125   8   19:3   454                   CHARACTR[ CHARI].POSS.POSSCNT :=
  2126   8   19:3   463                                              CHARACTR[ CHARI].POSS.POSSCNT - 1;
  2127   8   19:3   475                   MOVELEFT( IOCACHE[ GETREC( ZOBJECT,
  2128   8   19:3   479                                              OBJLIST[ TRANOBJX],
  2129   8   19:3   490                                              SIZEOF( TOBJREC))],
  2130   8   19:3   496                             OBJECT,
  2131   8   19:3   500                             SIZEOF( TOBJREC));
  2132   8   19:3   503                   IF ACTION = SELL THEN
  2133   8   19:4   510                     IF OBJECT.BOLTACXX > - 1 THEN
  2134   8   19:5   518                       OBJECT.BOLTACXX := OBJECT.BOLTACXX + 1;
  2135   8   19:5   526                     
  2136   8   19:3   526                   MOVELEFT( OBJECT,
  2137   8   19:3   530                             IOCACHE[ GETRECW( ZOBJECT,
  2138   8   19:3   534                                               OBJLIST[ TRANOBJX],
  2139   8   19:3   545                                               SIZEOF( TOBJREC))],
  2140   8   19:3   551                             SIZEOF( TOBJREC));
  2141   8   19:2   554                 END;
  2142   8   19:2   554                 
  2143   8   19:1   554               CENTSTR( '** ANYTHING ELSE, SIRE? **');
  2144   8   19:1   586               LISTPOSS
  2145   8   19:0   586             END; (* TRANSACT *)
  2146   8   19:0   606             
  2147   8   19:0   606             
  2148   8   17:0     0           BEGIN (* SELLIDUN *)
  2149   8   17:1     0             LISTPOSS;
  2150   8   17:1     2             REPEAT
  2151   8   17:2     2               IF POSSCNT = 0 THEN
  2152   8   17:3     9                 EXIT( SELLIDUN);
  2153   8   17:2    13               GOTOXY(  0, 22);
  2154   8   17:2    18               IF ACTION = SELL THEN
  2155   8   17:3    23                 BEGIN
  2156   8   17:4    23                   WRITE( CHR( 11));
  2157   8   17:4    31                   WRITE( 'WHICH DO YOU WISH TO SELL ? >')
  2158   8   17:3    70                 END
  2159   8   17:2    70               ELSE IF ACTION = UNCURSE THEN
  2160   8   17:4    77                 BEGIN
  2161   8   17:5    77                   WRITE( CHR( 11));
  2162   8   17:5    85                   WRITE( 'WHICH DO YOU WISH UNCURSED ? >')
  2163   8   17:4   125                 END
  2164   8   17:3   125               ELSE
  2165   8   17:4   127                 BEGIN
  2166   8   17:5   127                   WRITE( CHR( 11));
  2167   8   17:5   135                   WRITE( 'WHICH DO YOU WISH IDENTIFIED ? >')
  2168   8   17:4   177                 END;
  2169   8   17:2   177               GETKEY;
  2170   8   17:2   180               IF ORD( INCHAR) = CRETURN THEN
  2171   8   17:3   185                 EXIT( SELLIDUN);
  2172   8   17:2   189               TRANOBJX := ORD( INCHAR) - ORD( '0');
  2173   8   17:2   194               IF (TRANOBJX > 0) AND (TRANOBJX <= POSSCNT) THEN
  2174   8   17:3   205                 TRANSACT
  2175   8   17:1   205             UNTIL FALSE
  2176   8   17:0   207           END;
  2177   8   17:0   224           
  2178   8   17:0   224           
  2179   8   11:0     0         BEGIN (* DOPLAYER *)
  2180   8   11:1     0           REPEAT
  2181   8   11:2     0             GOTOXY( 0, 13);
  2182   8   11:2     5             WRITE( CHR( 11));
  2183   8   11:2    13             WRITE( '      WELCOME ');
  2184   8   11:2    37             WRITE(  CHARACTR[ CHARI].NAME);
  2185   8   11:2    51             WRITELN;
  2186   8   11:2    57             WRITE( '     YOU HAVE ');
  2187   8   11:2    81             PRNTLONG( CHARACTR[ CHARI].GOLD);
  2188   8   11:2    93             WRITELN( ' GOLD');
  2189   8   11:2   114             WRITELN;
  2190   8   11:2   120             WRITELN( 'YOU MAY B)UY  AN ITEM,');
  2191   8   11:2   158             WRITELN( '        S)ELL AN ITEM, HAVE AN ITEM');
  2192   8   11:2   209             WRITELN( '        U)NCURSED,  OR HAVE AN ITEM');
  2193   8   11:2   260             WRITELN( '        I)DENTIFIED, OR L)EAVE');
  2194   8   11:2   306             GOTOXY( 41, 0);
  2195   8   11:2   311             GETKEY;
  2196   8   11:2   314                            
  2197   8   11:2   314             CASE INCHAR OF
  2198   8   11:2   317               'U': SELLIDUN( UNCURSE);
  2199   8   11:2   322               'I': SELLIDUN( IDENTIFY);
  2200   8   11:2   327               'S': SELLIDUN( SELL);
  2201   8   11:2   332               'B': DOBUY;
  2202   8   11:2   336               'L': EXIT( DOPLAYER);
  2203   8   11:2   342             END
  2204   8   11:1   390           UNTIL FALSE
  2205   8   11:0   390         END; (* DOPLAYER *)
  2206   8   11:0   408         
  2207   8   11:0   408         
  2208   8   10:0     0       BEGIN (* BOLTAC *)
  2209   8   10:1     0         HALFPRIC := 2;
  2210   8   10:1     3         XGOTO := XCASTLE;
  2211   8   10:1     6         REPEAT
  2212   8   10:2     6           GOTOXY( 0, 13);
  2213   8   10:2    11           WRITE( CHR( 11));
  2214   8   10:2    19           WRITE( '       WELCOME TO THE TRADING POST');
  2215   8   10:2    63           WRITELN;
  2216   8   10:2    69           CHARI := GETCHARX( FALSE, 'WHO WILL ENTER');
  2217   8   10:2    94           IF CHARI = -1 THEN
  2218   8   10:3   101             EXIT( SHOPS);
  2219   8   10:3   105           
  2220   8   10:2   105           IF (CHARI < PARTYCNT) THEN
  2221   8   10:3   111             DOPLAYER
  2222   8   10:1   111         UNTIL FALSE
  2223   8   10:0   113       END;
  2224   8   10:0   130       
  2225   8   10:0   130       
  2226   8   10:0   130 (*$I WIZ1B:SHOPS     *)
  2226   8   10:0   130 (*$I WIZ1A:SHOPS2    *)
  2227   8   10:0   130 
  2228   8   21:D     1     PROCEDURE CEMETARY;  (* P010215 *)
  2229   8   21:D     1     
  2230   8   21:D     1       VAR
  2231   8   21:D     1            TWO : INTEGER;
  2232   8   21:D     2            
  2233   8   21:D     2            
  2234   8   22:D     1       PROCEDURE TOMBSTON( CHARI: INTEGER);  (* P010216 *)
  2235   8   22:D     2       
  2236   8   22:D     2         VAR
  2237   8   22:D     2             TOMBY : INTEGER;
  2238   8   22:D     3             TOMBX : INTEGER;
  2239   8   22:D     4         
  2240   8   22:D     4         
  2241   8   23:D     1         PROCEDURE DSPTOMBL( TOMBCHRS: STRING);  (* P010217 *)
  2242   8   23:D    43           
  2243   8   23:0     0           BEGIN
  2244   8   23:1     0             MVCURSOR( TOMBX, TOMBY);
  2245   8   23:1    14             PRINTSTR( TOMBCHRS);
  2246   8   23:1    19             TOMBY := TOMBY + 1
  2247   8   23:0    22           END;
  2248   8   23:0    40           
  2249   8   23:0    40           
  2250   8   22:0     0         BEGIN  (* TOMBSTON *)
  2251   8   22:1     0           TOMBX := 20 * (CHARI MOD 2);
  2252   8   22:1     7           TOMBY :=  6 * (CHARI DIV 2);
  2253   8   22:1    14           UNITREAD( DRIVE1, CHARSET, BLOCKSZ, SCNTOCBL + 2, 0);
  2254   8   22:1    28           MVCURSOR( TOMBX, TOMBY);
  2255   8   22:1    33           
  2256   8   22:1    33           DSPTOMBL( '+,-.');  (*  CHR(43)  CHR(44)  CHR(45)  CHR(46)  *)
  2257   8   22:1    42           DSPTOMBL( '/012');  (*  CHR(47)  CHR(48)  CHR(49)  CHR(50)  *)  
  2258   8   22:1    51           DSPTOMBL( '3456');  (*  CHR(51)  CHR(52)  CHR(53)  CHR(54)  *)
  2259   8   22:1    60           DSPTOMBL( '789:');  (*  CHR(55)  CHR(56)  CHR(57)  CHR(58)  *)
  2260   8   22:1    69           DSPTOMBL( ';<=>');  (*  CHR(59)  CHR(60)  CHR(61)  CHR(62)  *)
  2261   8   22:1    78           DSPTOMBL( '?XYZ');  (*  CHR(63)  CHR(88)  CHR(89)  CHR(90)  *)
  2262   8   22:1    87                               (* NOTE LAST LINE JUMPS TO XYZ *)
  2263   8   22:1    87                               
  2264   8   22:1    87           UNITREAD( DRIVE1, CHARSET, BLOCKSZ, SCNTOCBL + 1, 0);
  2265   8   22:1   101           MVCURSOR( TOMBX + 1, TOMBY - 2);
  2266   8   22:1   110           PRINTNUM( CHARACTR[ CHARI].AGE DIV 52, 2);
  2267   8   22:1   123           MVCURSOR( TOMBX + 4, TOMBY - 4);
  2268   8   22:1   132           PRINTSTR( CHARACTR[ CHARI].NAME)
  2269   8   22:0   137         END;  (* TOMBSTON *)
  2270   8   22:0   152         
  2271   8   22:0   152         
  2272   8   24:D     1       PROCEDURE BADSTUFF;  (* P010218 *)
  2273   8   24:D     1       
  2274   8   24:D     1       
  2275   8   25:D     1         PROCEDURE BREAKPOS;  (* P010219 *)
  2276   8   25:D     1         
  2277   8   25:D     1           VAR
  2278   8   25:D     1                X     : INTEGER;
  2279   8   25:D     2                POSSX : INTEGER;
  2280   8   25:D     3         
  2281   8   25:0     0           BEGIN
  2282   8   25:1     0             WITH CHARACTR[ LLBASE04] DO
  2283   8   25:2     7               BEGIN
  2284   8   25:3     7                 FOR POSSX := 1 TO POSS.POSSCNT DO
  2285   8   25:4    20                   IF NOT POSS.POSSESS[ POSSX].CURSED THEN
  2286   8   25:5    32                     IF (RANDOM MOD 21 > ATTRIB[ LUCK]) THEN
  2287   8   25:6    50                       POSS.POSSESS[ POSSX].EQINDEX := 0;
  2288   8   25:3    69                 X := 0;
  2289   8   25:3    72                 FOR POSSX := 1 TO POSS.POSSCNT DO
  2290   8   25:4    85                   IF POSS.POSSESS[ POSSX].EQINDEX <> 0 THEN
  2291   8   25:5    98                     BEGIN
  2292   8   25:6    98                       X := X + 1;
  2293   8   25:6   103                       POSS.POSSESS[ X] := POSS.POSSESS[ POSSX]
  2294   8   25:5   119                     END;
  2295   8   25:3   128                 POSS.POSSCNT := X
  2296   8   25:2   131             END
  2297   8   25:0   133           END;
  2298   8   25:0   150           
  2299   8   25:0   150           
  2300   8   24:0     0         BEGIN (* BADSTUFF *)
  2301   8   24:1     0           TWO := 2;
  2302   8   24:1     4           FOR LLBASE04 := 0 TO PARTYCNT - 1 DO
  2303   8   24:2    17             BEGIN
  2304   8   24:3    17               IF CHARACTR[ LLBASE04].STATUS <> LOST THEN
  2305   8   24:4    28                 BEGIN
  2306   8   24:5    28                   WITH CHARACTR[ LLBASE04] DO
  2307   8   24:6    35                     BEGIN
  2308   8   24:7    35                       IF STATUS < DEAD THEN
  2309   8   24:8    42                         STATUS := DEAD;
  2310   8   24:7    47                       INMAZE := FALSE;
  2311   8   24:7    52                       DIVLONG( GOLD, TWO);
  2312   8   24:7    61                       BREAKPOS;
  2313   8   24:7    63                       IF (RANDOM MOD 50) < MAZELEV THEN
  2314   8   24:8    75                         BEGIN
  2315   8   24:9    75                           LOSTXYL.LOCATION[ 1] := -1;
  2316   8   24:9    86                           LOSTXYL.LOCATION[ 2] := -1;
  2317   8   24:9    97                           LOSTXYL.LOCATION[ 3] := -1
  2318   8   24:8   105                         END
  2319   8   24:7   108                       ELSE
  2320   8   24:8   110                         BEGIN
  2321   8   24:9   110                           LOSTXYL.LOCATION[ 1] := MAZEX;
  2322   8   24:9   121                           LOSTXYL.LOCATION[ 2] := MAZEY;
  2323   8   24:9   132                           LOSTXYL.LOCATION[ 3] := MAZELEV
  2324   8   24:8   140                         END;
  2325   8   24:7   143                       MOVELEFT( CHARACTR[ LLBASE04],
  2326   8   24:7   149                                 IOCACHE[ GETRECW( ZCHAR,
  2327   8   24:7   153                                                   CHARDISK[ LLBASE04],
  2328   8   24:7   159                                                   SIZEOF( TCHAR))],
  2329   8   24:7   167                                 SIZEOF( TCHAR))
  2330   8   24:6   172                     END
  2331   8   24:4   172                 END
  2332   8   24:2   172             END;  (* END FOR *)
  2333   8   24:2   179             
  2334   8   24:1   179           MOVELEFT( IOCACHE[ GETREC(  ZZERO, 0, SIZEOF( TSCNTOC))],
  2335   8   24:1   192                     SCNTOC,
  2336   8   24:1   196                     SIZEOF( TSCNTOC))
  2337   8   24:0   201         END;
  2338   8   24:0   220         
  2339   8   24:0   220         
  2340   8   21:0     0       BEGIN (* CEMETARY *)
  2341   8   21:1     0         BADSTUFF;
  2342   8   21:1     2         CLRRECT( 0, 0, 40, 24);
  2343   8   21:1     9         GRAPHICS;
  2344   8   21:1    12         FOR LLBASE04 := 0 TO PARTYCNT - 1 DO
  2345   8   21:2    25           TOMBSTON( LLBASE04);
  2346   8   21:1    35         UNITREAD( DRIVE1, CHARSET, BLOCKSZ, SCNTOCBL + 2, 0);
  2347   8   21:1    49         MVCURSOR( 0, 19);
  2348   8   21:1    54         PRINTCHR( CHR(33));         (* UPPER LEFT CORNER  *)
  2349   8   21:1    58         FOR LLBASE04 := 1 TO 38 DO
  2350   8   21:2    69           PRINTCHR( CHR(34));       (* HORIZONTAL LINE    *)
  2351   8   21:1    80         PRINTCHR( CHR(35));         (* UPPER RIGHT CORNER *)
  2352   8   21:1    84         MVCURSOR( 0, 20);
  2353   8   21:1    89         PRINTCHR( CHR(36));         (* VERTICAL BAR       *)
  2354   8   21:1    93         MVCURSOR( 39, 20);
  2355   8   21:1    98         PRINTCHR( CHR(36));
  2356   8   21:1   102         MVCURSOR( 0, 21);
  2357   8   21:1   107         PRINTCHR( CHR(39));
  2358   8   21:1   111         FOR LLBASE04 := 1 TO 38 DO
  2359   8   21:2   122           PRINTCHR( CHR(34));
  2360   8   21:1   133         PRINTCHR( CHR(40));
  2361   8   21:1   137         MVCURSOR( 0, 22);
  2362   8   21:1   142         PRINTCHR( CHR(36));
  2363   8   21:1   146         MVCURSOR( 39, 22);
  2364   8   21:1   151         PRINTCHR( CHR(36));
  2365   8   21:1   155         MVCURSOR( 0, 23);
  2366   8   21:1   160         PRINTCHR( CHR(37));
  2367   8   21:1   164         FOR LLBASE04 := 1 TO 38 DO
  2368   8   21:2   175           PRINTCHR( CHR(34));
  2369   8   21:1   186         PRINTCHR( CHR(38));
  2370   8   21:1   190         UNITREAD( DRIVE1, CHARSET, BLOCKSZ, SCNTOCBL + 1, 0);
  2371   8   21:1   204         MVCURSOR( 1, 20);
  2372   8   21:1   209         PRINTSTR( 'YOUR ENTIRE PARTY HAS BEEN SLAUGHTERED');
  2373   8   21:1   253         MVCURSOR( 1, 22);
  2374   8   21:1   258         PRINTSTR( '  PRESS RETURN TO LEAVE THE CEMETERY  ');
  2375   8   21:1   302         PARTYCNT := 0;
  2376   8   21:1   305         REPEAT
  2377   8   21:2   305           GETKEY
  2378   8   21:1   305         UNTIL INCHAR = CHR( CRETURN);
  2379   8   21:1   313         WRITE( CHR( 12));
  2380   8   21:1   321         GOTOXY( 41, 0);
  2381   8   21:1   326         LLBASE04 := -2;
  2382   8   21:1   330         XGOTO := XSCNMSG;
  2383   8   21:1   333         EXIT( SHOPS)
  2384   8   21:0   337       END;
  2385   8   21:0   360   
  2386   8   21:0   360   
  2387   8   26:D     1     PROCEDURE EDGETOWN;  (* P01021A *)
  2388   8   26:D     1     
  2389   8   26:D     1     
  2390   8   27:D     1       PROCEDURE ENTMAZE;  (* P01021B *)
  2391   8   27:D     1       
  2392   8   27:D     1         VAR
  2393   8   27:D     1              X : INTEGER;
  2394   8   27:D     2       
  2395   8   27:0     0         BEGIN
  2396   8   27:1     0           GOTOXY( 0, 13);
  2397   8   27:1     5           WRITELN( CHR(11));
  2398   8   27:1    19           WRITELN( 'ENTERING' :24);
  2399   8   27:1    43           WRITELN( SCNTOC.GAMENAME : 20 + LENGTH( SCNTOC.GAMENAME) DIV 2);
  2400   8   27:1    67           GOTOXY( 41, 0);
  2401   8   27:1    72           XGOTO := XNEWMAZE;
  2402   8   27:1    75           MAZEX    :=  0;
  2403   8   27:1    78           MAZEY    :=  0;
  2404   8   27:1    81           MAZELEV  := -1;
  2405   8   27:1    85           DIRECTIO :=  0;
  2406   8   27:1    88           EXIT( SHOPS)
  2407   8   27:0    92         END;
  2408   8   27:0   104         
  2409   8   27:0   104         
  2410   8   28:D     1       PROCEDURE UPDCHARS;  (* P01021C *)
  2411   8   28:D     1       
  2412   8   28:D     1         VAR
  2413   8   28:D     1              X : INTEGER;
  2414   8   28:D     2       
  2415   8   28:0     0         BEGIN
  2416   8   28:1     0           FOR X := 0 TO PARTYCNT - 1 DO
  2417   8   28:2    13             BEGIN
  2418   8   28:3    13               CHARACTR[ X].INMAZE := FALSE;
  2419   8   28:3    22               MOVELEFT( CHARACTR[ X],
  2420   8   28:3    28                         IOCACHE[ GETRECW( ZCHAR,
  2421   8   28:3    32                                           CHARDISK[ X],
  2422   8   28:3    38                                           SIZEOF( TCHAR))],
  2423   8   28:3    46                         SIZEOF( TCHAR));
  2424   8   28:2    51             END;
  2425   8   28:1    58           PARTYCNT := 0;
  2426   8   28:1    61           MOVELEFT( IOCACHE[ GETREC( ZZERO, 0, SIZEOF( TSCNTOC))],
  2427   8   28:1    74                     X,
  2428   8   28:1    77                     2);
  2429   8   28:1    80           EXIT( SHOPS)
  2430   8   28:0    84         END;  (* UPDCHARS *)
  2431   8   28:0    98         
  2432   8   28:0    98         
  2433   8   26:0     0       BEGIN (* EDGETOWN *)
  2434   8   26:1     0         GOTOXY( 0, 13);
  2435   8   26:1     5         IF PARTYCNT = 0 THEN
  2436   8   26:2    10           BEGIN
  2437   8   26:3    10             WRITE( CHR( 11));
  2438   8   26:3    18             WRITELN( 'YOU MAY GO TO THE T)RAINING GROUNDS,');
  2439   8   26:3    70             WRITELN( 'RETURN TO THE C)ASTLE, OR L)EAVE THE');
  2440   8   26:3   122             WRITELN( 'GAME.') 
  2441   8   26:2   143           END
  2442   8   26:1   143         ELSE
  2443   8   26:2   145           BEGIN
  2444   8   26:3   145             WRITE( CHR( 11));
  2445   8   26:3   153             WRITELN( 'YOU MAY ENTER THE M)AZE, THE T)RAINING');
  2446   8   26:3   207             WRITELN( 'GROUNDS, C)ASTLE,  OR L)EAVE THE GAME.')
  2447   8   26:2   261           END;
  2448   8   26:1   261         REPEAT
  2449   8   26:2   261           GOTOXY( 41, 0);
  2450   8   26:2   266           GETKEY
  2451   8   26:1   266         UNTIL (INCHAR = 'T') OR (INCHAR = 'C') OR (INCHAR = 'L') OR
  2452   8   26:1   280               ((INCHAR = 'M') AND (PARTYCNT > 0));
  2453   8   26:1   290           
  2454   8   26:1   290         IF INCHAR = 'M' THEN
  2455   8   26:2   295           ENTMAZE
  2456   8   26:1   295         ELSE IF INCHAR = 'T' THEN
  2457   8   26:3   304           BEGIN
  2458   8   26:4   304             XGOTO := XTRAININ;
  2459   8   26:4   307             UPDCHARS
  2460   8   26:3   307           END
  2461   8   26:2   309         ELSE IF INCHAR = 'L' THEN
  2462   8   26:4   316           BEGIN
  2463   8   26:5   316             XGOTO := XDONE;
  2464   8   26:5   319             UPDCHARS
  2465   8   26:4   319           END
  2466   8   26:3   321         ELSE
  2467   8   26:4   323           BEGIN
  2468   8   26:5   323             XGOTO := XCASTLE;
  2469   8   26:5   326             EXIT( SHOPS)
  2470   8   26:4   330           END
  2471   8   26:0   330       END;
  2472   8   26:0   346   
  2473   8   26:0   346   
  2474   8   29:D     1     PROCEDURE CHK4WIN;  (* P01021D *)
  2475   8   29:D     1     
  2476   8   29:D     1       VAR
  2477   8   29:D     1           POSSI    : INTEGER;   (* MULTIPLE USES *)
  2478   8   29:D     2           CHARX    : INTEGER;
  2479   8   29:D     3           THISCHAR : TCHAR;
  2480   8   29:D   107           WONGAME  : BOOLEAN;
  2481   8   29:D   108           
  2482   8   29:D   108           
  2483   8   30:D     1       PROCEDURE CONGRATS;  (* P01021E *)
  2484   8   30:D     1     
  2485   8   30:D     1         VAR
  2486   8   30:D     1              EXPBONUS : TWIZLONG;
  2487   8   30:D     4              AWARDOVR : PACKED ARRAY[ 0..15] OF BOOLEAN;
  2488   8   30:D     5       
  2489   8   30:0     0         BEGIN
  2490   8   30:1     0           EXPBONUS.HIGH := 0;
  2491   8   30:1     3           EXPBONUS.LOW  := 0;
  2492   8   30:1     6           EXPBONUS.MID  := 25;
  2493   8   30:1     9           FOR CHARX := 0 TO PARTYCNT - 1 DO
  2494   8   30:2    25             BEGIN
  2495   8   30:3    25               CHARACTR[ CHARX].POSS.POSSCNT := 0;
  2496   8   30:3    36               CHARACTR[ CHARX].GOLD.HIGH := 0;
  2497   8   30:3    47               CHARACTR[ CHARX].GOLD.MID  := 0;
  2498   8   30:3    58               ADDLONGS( CHARACTR[ CHARX].EXP, EXPBONUS);
  2499   8   30:3    72               MOVELEFT( CHARACTR[ CHARX].LOSTXYL.AWARDS[ 4], AWARDOVR, 2);
  2500   8   30:3    93               AWARDOVR[ 0] := TRUE;
  2501   8   30:3   101               MOVELEFT( AWARDOVR, CHARACTR[ CHARX].LOSTXYL.AWARDS[ 4], 2)
  2502   8   30:2   122             END;
  2503   8   30:1   132           WRITE( CHR( 12));
  2504   8   30:1   140           WRITELN( '*** CONGRATULATIONS ***' : 32);
  2505   8   30:1   179           TEXTMODE;
  2506   8   30:1   182           WRITELN;
  2507   8   30:1   188           WRITELN( 'YOU HAVE COMPLETED YOUR QUEST AND THE');
  2508   8   30:1   241           WRITELN( 'AMULET IS NOW BACK IN THE HANDS OF');
  2509   8   30:1   291           WRITELN( 'YOUR BENIFICENT RULER, TREBOR.');
  2510   8   30:1   337           WRITELN;
  2511   8   30:1   343           WRITELN( 'IN RETURN FOR THIS, HE GRANTS YOU A');
  2512   8   30:1   394           WRITELN( 'BOON OF 250,000 EXPERIENCE POINTS');
  2513   8   30:1   443           WRITELN( 'EACH!');
  2514   8   30:1   464           WRITELN;
  2515   8   30:1   470           WRITELN( 'ADDITIONALLY, YOU WILL BE INITIATED');
  2516   8   30:1   521           WRITELN( 'INTO THE OVERLORD''S HONOR GUARD AND');
  2517   8   30:1   572           WRITELN( 'THUS WILL BE ENTITLED TO WEAR THE');
  2518   8   30:1   621           WRITELN( 'CHEVRON (>) OF THIS RANK EVERMORE.');
  2519   8   30:1   671           WRITELN;
  2520   8   30:1   677           WRITELN( 'HOWEVER, YOU MUST GIVE UP ALL YOUR');
  2521   8   30:1   727           WRITELN( 'EQUIPMENT AND MOST OF YOUR MONEY TO');
  2522   8   30:1   778           WRITELN( 'PAY FOR YOUR INITIATION.');
  2523   8   30:1   818           WRITELN;
  2524   8   30:1   824           WRITELN( 'PRESS [RETURN], HONORED ONES');
  2525   8   30:1   868           GOTOXY( 41, 0);
  2526   8   30:1   873           READLN( INPUT);
  2527   8   30:1   879           WRITE( CHR( 12))
  2528   8   30:0   887         END;
  2529   8   30:0   902         
  2530   8   30:0   902         
  2531   8   29:0     0       BEGIN (* CHK4WIN *)
  2532   8   29:1     0         WONGAME := FALSE;
  2533   8   29:1     3         FOR CHARX := 0 TO PARTYCNT -1 DO
  2534   8   29:2    17           BEGIN
  2535   8   29:3    17             FOR POSSI := 1 TO CHARACTR[ CHARX].POSS.POSSCNT DO
  2536   8   29:4    35               IF CHARACTR[ CHARX].POSS.POSSESS[ POSSI].EQINDEX = 94 THEN
  2537   8   29:5    52                 WONGAME := TRUE;
  2538   8   29:3    62             CHARACTR[ CHARX].LOSTXYL.LOCATION[ 1] := 0;
  2539   8   29:3    76             CHARACTR[ CHARX].LOSTXYL.LOCATION[ 2] := 0;
  2540   8   29:3    90             CHARACTR[ CHARX].LOSTXYL.LOCATION[ 3] := 0
  2541   8   29:2   102           END;
  2542   8   29:1   111         IF WONGAME THEN
  2543   8   29:2   115           CONGRATS;
  2544   8   29:1   117         FOR CHARX := 0 TO PARTYCNT - 1 DO
  2545   8   29:2   131           BEGIN
  2546   8   29:3   131             CHARACTR[ CHARX].INMAZE :=
  2547   8   29:3   138               CHARACTR[ CHARX].STATUS = OK;
  2548   8   29:3   148             MOVELEFT( CHARACTR[ CHARX],
  2549   8   29:3   154                       IOCACHE[ GETRECW( ZCHAR,
  2550   8   29:3   158                                         CHARDISK[ CHARX],
  2551   8   29:3   164                                         SIZEOF( TCHAR))],
  2552   8   29:3   172                       SIZEOF( TCHAR))
  2553   8   29:2   177           END;
  2554   8   29:2   184           
  2555   8   29:1   184         MOVELEFT( IOCACHE[ GETREC( ZZERO, 0, SIZEOF( TSCNTOC))],
  2556   8   29:1   197                   CHARX,
  2557   8   29:1   200                   2);
  2558   8   29:1   203         CHARX := 0;
  2559   8   29:1   206         POSSI := 0;
  2560   8   29:1   209         WHILE CHARX < PARTYCNT DO
  2561   8   29:2   214           BEGIN
  2562   8   29:3   214             CHARACTR[ POSSI] := CHARACTR[ CHARX];
  2563   8   29:3   226             CHARDISK[ POSSI] := CHARDISK[ CHARX];
  2564   8   29:3   238             IF CHARACTR[ POSSI].STATUS = OK THEN
  2565   8   29:4   249               POSSI := POSSI + 1;
  2566   8   29:3   254             CHARX := CHARX + 1
  2567   8   29:2   255           END;
  2568   8   29:1   261         PARTYCNT := POSSI;
  2569   8   29:1   264         XGOTO := XCASTLE;
  2570   8   29:1   267         EXIT( SHOPS)
  2571   8   29:0   271     END;  (* CHK4WIN *)
  2572   8   29:0   292   
  2573   8   29:0   292   
  2574   8    1:0     0     BEGIN (* SHOPS *)
  2575   8    1:0     0     
  2576   8    1:1     0       CASE XGOTO OF
  2577   8    1:1     3         XCEMETRY:  CEMETARY;
  2578   8    1:1     7            XCANT:  CANT;
  2579   8    1:1    11          XBOLTAC:  BOLTAC;
  2580   8    1:1    15         XCHK4WIN:  CHK4WIN;
  2581   8    1:1    19         XEDGTOWN:  EDGETOWN;
  2582   8    1:1    23       END;
  2583   8    1:1    72       
  2584   8    1:0    72     END;  (* SHOPS *)
  2585   8    1:0    84   
  2586   8    1:0    84 (*$I WIZ1A:SHOPS2    *)
  2587   8    1:0    84 
  2587   8    1:0    84 (*$I WIZ1B:SPECIALS  *)
  2588   8    1:0    84     
  2589   9    1:D     1 SEGMENT PROCEDURE SPECIALS;   (* P010301 *)
  2590   9    1:D     1     
  2591   9    1:D     1     CONST
  2592   9    1:D     1           SERIALBL = 5;
  2593   9    1:D     1   
  2594   9    1:D     1     VAR
  2595   9    1:D     1          SPCINDEX : INTEGER;
  2596   9    1:D     2          UNUSED   : INTEGER;
  2597   9    1:D     3          NUM2000  : RECORD CASE INTEGER OF
  2598   9    1:D     3                       1: (I: INTEGER);
  2599   9    1:D     3                       2: (P: ^INTEGER);
  2600   9    1:D     3                     END;
  2601   9    1:D     4   
  2602   9    1:D     4   
  2603   9    2:D     1     PROCEDURE INSPECT;  (* P010302 *)
  2604   9    2:D     1     
  2605   9    2:D     1       VAR
  2606   9    2:D     1            PICKCNT  : INTEGER;
  2607   9    2:D     2            PICKLIST : ARRAY[ 1..6] OF INTEGER;
  2608   9    2:D     8            UNUSEDXX : INTEGER;
  2609   9    2:D     9            PICKCHAR : INTEGER;
  2610   9    2:D    10            PICKREC  : TCHAR;
  2611   9    2:D   114            MAZE     : TMAZE;
  2612   9    2:D   561            INMYROOM : PACKED ARRAY[ 0..19] OF PACKED ARRAY[ 0..19] OF BOOLEAN;
  2613   9    2:D   601            CHECKED  : PACKED ARRAY[ 0..19] OF PACKED ARRAY[ 0..19] OF BOOLEAN;
  2614   9    2:D   641            
  2615   9    2:D   641         
  2616   9    2:D   641         
  2617   9    3:D     1       PROCEDURE LOOKLOST;  (* P010303 *)
  2618   9    3:D     1       
  2619   9    3:D     1       
  2620   9    4:D     1         PROCEDURE FOUNDLOS;  (* P010304 *)
  2621   9    4:D     1         
  2622   9    4:0     0           BEGIN
  2623   9    4:1     0             IF PICKCNT = 5 THEN
  2624   9    4:2     7               EXIT( LOOKLOST);
  2625   9    4:1    11             PICKCNT := PICKCNT + 1;
  2626   9    4:1    19             PICKLIST[ PICKCNT] := PICKCHAR;
  2627   9    4:1    33             WRITE( PICKCNT : 1);
  2628   9    4:1    43             WRITE( ') ');
  2629   9    4:1    55             WRITE( PICKREC.NAME);
  2630   9    4:1    65             WRITELN
  2631   9    4:0    65           END;  (* FOUNDLOS *)
  2632   9    4:0    84           
  2633   9    4:0    84           
  2634   9    3:0     0         BEGIN  (* LOOKLOST *)
  2635   9    3:1     0           PICKCNT := 0;
  2636   9    3:1     4           WRITE( CHR( 12));
  2637   9    3:1    12           WRITELN( 'FOUND:');
  2638   9    3:1    34           WRITELN;
  2639   9    3:1    40           WRITELN;
  2640   9    3:1    46           WRITELN;
  2641   9    3:1    52           FOR PICKCHAR := 0 TO SCNTOC.RECPERDK[ ZCHAR] - 1 DO
  2642   9    3:2    74             BEGIN
  2643   9    3:3    74               MOVELEFT( IOCACHE[ GETREC( ZCHAR, PICKCHAR, SIZEOF( TCHAR))],
  2644   9    3:3    89                         PICKREC,
  2645   9    3:3    93                         SIZEOF( TCHAR));
  2646   9    3:3    98               IF NOT PICKREC.INMAZE THEN
  2647   9    3:4   104                 IF PICKREC.LOSTXYL.LOCATION[ 3] = MAZELEV THEN
  2648   9    3:5   118                   IF INMYROOM[ PICKREC.LOSTXYL.LOCATION[ 1],
  2649   9    3:5   133                                PICKREC.LOSTXYL.LOCATION[ 2] ] THEN
  2650   9    3:6   148                     FOUNDLOS
  2651   9    3:2   148             END;
  2652   9    3:1   160           IF PICKCNT = 0 THEN
  2653   9    3:2   167             WRITELN( '** NO ONE **')
  2654   9    3:0   195         END;  (* LOOKLOST *)
  2655   9    3:0   210         
  2656   9    3:0   210         
  2657   9    5:D     1       PROCEDURE PICKUP;  (* P010305 *)
  2658   9    5:D     1       
  2659   9    5:0     0         BEGIN
  2660   9    5:1     0           IF PARTYCNT = 6 THEN
  2661   9    5:2     5             BEGIN
  2662   9    5:3     5               GOTOXY( 0, 20);
  2663   9    5:3    10               WRITE( CHR( 11));
  2664   9    5:3    18               WRITELN( 'YOU HAVE 6 - PRESS [RET]');
  2665   9    5:3    58               GOTOXY( 41, 0);
  2666   9    5:3    63               REPEAT
  2667   9    5:4    63                 GETKEY
  2668   9    5:3    63               UNTIL INCHAR = CHR( CRETURN);
  2669   9    5:3    71               EXIT( PICKUP)
  2670   9    5:2    75             END;
  2671   9    5:2    75               
  2672   9    5:1    75           REPEAT
  2673   9    5:2    75             GOTOXY( 0, 20);
  2674   9    5:2    80             WRITE( CHR( 11));
  2675   9    5:2    88             WRITE( 'GET WHO (0=EXIT) >');
  2676   9    5:2   116             GETKEY;
  2677   9    5:2   119             PICKCHAR := ORD( INCHAR) - ORD( '0');
  2678   9    5:2   125             IF PICKCHAR = 0 THEN
  2679   9    5:3   132               EXIT( PICKUP)
  2680   9    5:1   136           UNTIL (PICKCHAR > 0) AND (PICKCHAR <= PICKCNT);
  2681   9    5:1   151           
  2682   9    5:1   151           IF PICKLIST[ PICKCHAR] = -1 THEN
  2683   9    5:2   167             EXIT( PICKUP);
  2684   9    5:1   171           MOVELEFT( IOCACHE[ GETREC( ZCHAR,
  2685   9    5:1   175                                      PICKLIST[ PICKCHAR],
  2686   9    5:1   186                                      SIZEOF( TCHAR))],
  2687   9    5:1   194                     CHARACTR[ PARTYCNT],
  2688   9    5:1   200                     SIZEOF( TCHAR));
  2689   9    5:1   205           CHARDISK[ PARTYCNT] := PICKLIST[ PICKCHAR];
  2690   9    5:1   222           CHARACTR[ PARTYCNT].LOSTXYL.LOCATION[ 1] := 0;
  2691   9    5:1   236           CHARACTR[ PARTYCNT].LOSTXYL.LOCATION[ 2] := 0;
  2692   9    5:1   250           CHARACTR[ PARTYCNT].LOSTXYL.LOCATION[ 3] := 0;
  2693   9    5:1   264           CHARACTR[ PARTYCNT].INMAZE := TRUE;
  2694   9    5:1   273           MOVELEFT( CHARACTR[ PARTYCNT],
  2695   9    5:1   279                     IOCACHE[ GETRECW( ZCHAR,
  2696   9    5:1   283                                       PICKLIST[ PICKCHAR],
  2697   9    5:1   294                                       SIZEOF( TCHAR))],
  2698   9    5:1   302                     SIZEOF( TCHAR));
  2699   9    5:1   307           PICKLIST[ PICKCHAR] := - 1;
  2700   9    5:1   320           PARTYCNT := PARTYCNT + 1;
  2701   9    5:1   325           GOTOXY( 0, 3 + PICKCHAR);
  2702   9    5:1   334           WRITE( CHR( 29))
  2703   9    5:0   342         END;  (* PICKUP *)
  2704   9    5:0   358         
  2705   9    5:0   358         
  2706   9    6:D     1       PROCEDURE EXPLROOM;  (* P010306 *)
  2707   9    6:D     1       
  2708   9    6:D     1         VAR
  2709   9    6:D     1              VERT     : INTEGER;
  2710   9    6:D     2              HORZ     : INTEGER;
  2711   9    6:D     3              DONELOOK : BOOLEAN;
  2712   9    6:D     4       
  2713   9    6:D     4       
  2714   9    7:D     1         PROCEDURE CHECKLOC( X:    INTEGER;    (* P010307 *)
  2715   9    7:D     2                             Y:    INTEGER;
  2716   9    7:D     3                             WALL: TWALL);
  2717   9    7:D     4         
  2718   9    7:0     0           BEGIN
  2719   9    7:1     0             IF WALL <> OPEN THEN
  2720   9    7:2     5               EXIT( CHECKLOC);
  2721   9    7:1     9             X := (X + 20) MOD 20;
  2722   9    7:1    16             Y := (Y + 20) MOD 20;
  2723   9    7:1    23             IF INMYROOM[ X][ Y] THEN
  2724   9    7:2    37               EXIT( CHECKLOC);
  2725   9    7:1    41             DONELOOK := FALSE;
  2726   9    7:1    45             INMYROOM[ X][ Y] := TRUE
  2727   9    7:0    56           END;  (* CHECKLOC *)
  2728   9    7:0    70           
  2729   9    7:0    70           
  2730   9    6:0     0         BEGIN (* EXPLROOM *)
  2731   9    6:1     0           MOVELEFT( IOCACHE[ GETREC( ZMAZE, MAZELEV - 1, SIZEOF( TMAZE))],
  2732   9    6:1    16                     MAZE,
  2733   9    6:1    20                     SIZEOF( TMAZE));
  2734   9    6:1    25           FILLCHAR( INMYROOM, 80, 0);
  2735   9    6:1    34           INMYROOM[ MAZEX][ MAZEY] := TRUE;
  2736   9    6:1    49           FILLCHAR( CHECKED, 80, 0);
  2737   9    6:1    58           REPEAT
  2738   9    6:2    58             WRITE( '.');
  2739   9    6:2    66             DONELOOK := TRUE;
  2740   9    6:2    69             FOR HORZ := 0 TO 19 DO
  2741   9    6:3    80               FOR VERT := 0 TO 19 DO
  2742   9    6:4    91                 IF INMYROOM[ HORZ][ VERT] THEN
  2743   9    6:5   105                   IF NOT CHECKED[ HORZ][ VERT] THEN
  2744   9    6:6   120                     BEGIN
  2745   9    6:7   120                       CHECKLOC( HORZ + 1, VERT, MAZE.E[ HORZ][ VERT]);
  2746   9    6:7   138                       CHECKLOC( HORZ - 1, VERT, MAZE.W[ HORZ][ VERT]);
  2747   9    6:7   155                       CHECKLOC( HORZ, VERT - 1, MAZE.S[ HORZ][ VERT]);
  2748   9    6:7   173                       CHECKLOC( HORZ, VERT + 1, MAZE.N[ HORZ][ VERT]);
  2749   9    6:7   191                       CHECKED[ HORZ][ VERT] := TRUE
  2750   9    6:6   202                     END
  2751   9    6:1   204           UNTIL DONELOOK
  2752   9    6:0   218         END;  (* EXPLROOM *)
  2753   9    6:0   242         
  2754   9    6:0   242         
  2755   9    2:0     0       BEGIN (* INSPECT *)
  2756   9    2:1     0         WRITE( CHR( 12));
  2757   9    2:1     8         WRITE( 'LOOKING');
  2758   9    2:1    25         TEXTMODE;
  2759   9    2:1    28         EXPLROOM;
  2760   9    2:1    30         LOOKLOST;
  2761   9    2:1    32         REPEAT
  2762   9    2:2    32           GOTOXY( 0, 20);
  2763   9    2:2    37           WRITE( 'OPTIONS: ');
  2764   9    2:2    56           IF PICKCNT > 0 THEN
  2765   9    2:3    61             WRITE( 'P)ICK UP, ');
  2766   9    2:2    81           WRITE( 'L)EAVE');
  2767   9    2:2    97           REPEAT
  2768   9    2:3    97             GOTOXY( 41, 0);
  2769   9    2:3   102             GETKEY
  2770   9    2:2   102           UNTIL (INCHAR = 'P') OR (INCHAR = 'L');
  2771   9    2:2   114           IF INCHAR = 'P' THEN
  2772   9    2:3   119             IF PICKCNT > 0 THEN
  2773   9    2:4   124               PICKUP;
  2774   9    2:1   126         UNTIL INCHAR = 'L';
  2775   9    2:1   131         XGOTO := XRUNNER;
  2776   9    2:1   134         GRAPHICS;
  2777   9    2:1   137         EXIT( SPECIALS)
  2778   9    2:0   141       END;  (* INSPECT *)
  2779   9    2:0   158       
  2780   9    2:0   158       
  2781   9    8:D     3     FUNCTION FINDFILE( DRIVE:  INTEGER;  (* P010308 *)
  2782   9    8:D     4                        FILENM: STRING) : INTEGER;
  2783   9    8:D    46                        
  2784   9    8:D    46       TYPE
  2785   9    8:D    46            DIRENTRY = RECORD
  2786   9    8:D    46              FIRSTBLK : INTEGER;
  2787   9    8:D    46              LASTBLK  : INTEGER;
  2788   9    8:D    46              FILEKIND : PACKED RECORD
  2789   9    8:D    46                  FT : (VOLHEAD, BADBLK, MACH6502, TEXT, DEBUG,
  2790   9    8:D    46                        DATA, GRAFFILE, FOTOFILE, SUBDIR);
  2791   9    8:D    46                END;
  2792   9    8:D    46              FILENAME : STRING[ 7];
  2793   9    8:D    46              VOLLB    : INTEGER;
  2794   9    8:D    46              FILECNT  : INTEGER;
  2795   9    8:D    46              LOADTIM  : INTEGER;
  2796   9    8:D    46              BOOTDATE : INTEGER;
  2797   9    8:D    46              RES1     : INTEGER;
  2798   9    8:D    46              RES2     : INTEGER;
  2799   9    8:D    46          END;
  2800   9    8:D    46                
  2801   9    8:D    46       VAR
  2802   9    8:D    46            DIR   : ARRAY[ 0..3] OF DIRENTRY;
  2803   9    8:D    98            FILEI : INTEGER;
  2804   9    8:D    99            FILEX : INTEGER;
  2805   9    8:D   100                        
  2806   9    8:0     0       BEGIN
  2807   9    8:1     0         NUM2000.I := 8192;
  2808   9    8:1    11         UNITREAD( DRIVE, DIR, 104, 2, 0);
  2809   9    8:1    20         IF IORESULT <> 0 THEN
  2810   9    8:2    26           FINDFILE := - ABS( IORESULT)
  2811   9    8:1    29         ELSE
  2812   9    8:2    34           BEGIN
  2813   9    8:3    34             FILEI := 0;
  2814   9    8:3    37             FOR FILEX := 1 TO DIR[ 0].FILECNT DO
  2815   9    8:4    56               IF (DIR[ FILEX].FILEKIND.FT >= BADBLK) AND
  2816   9    8:4    69                  (DIR[ FILEX].FILEKIND.FT <= FOTOFILE) THEN
  2817   9    8:5    85                 IF DIR[ FILEX].FILENAME = FILENM THEN
  2818   9    8:6    99                   FILEI := FILEX;
  2819   9    8:3   111             IF FILEI = 0 THEN
  2820   9    8:4   117               FINDFILE := - 9
  2821   9    8:3   117             ELSE
  2822   9    8:4   123               FINDFILE := DIR[ FILEI].FIRSTBLK
  2823   9    8:2   129           END
  2824   9    8:0   132       END;  (* FINDFILE *)
  2825   9    8:0   146       
  2826   9    8:0   146       
  2827   9    8:0   146       
  2828   9    9:D     1     PROCEDURE INITGAME;  (* P010309 *)
  2829   9    9:D     1     
  2830   9    9:D     1       VAR
  2831   9    9:D     1            CPTEMP   : INTEGER;                 (* COPY PROTECTION CODE USES *)
  2832   9    9:D     2            UNUSED   : INTEGER;                 (* CP CODE *)
  2833   9    9:D     3            SAVEI    : INTEGER;                 (* CP CODE *)
  2834   9    9:D     4            SYNCH    : ARRAY[ 0..3] OF INTEGER; (* CP CODE *)
  2835   9    9:D     8            
  2836   9    9:D     8            DUPLSER : STRING[ 7];
  2837   9    9:D    12            MASTSER : STRING[ 7];
  2838   9    9:D    16     
  2839   9    9:D    16     
  2840   9   10:D     1     PROCEDURE MAZESCRN;  (* P01030A *)
  2841   9   10:D     1       
  2842   9   10:D     1       
  2843   9   11:D     1         PROCEDURE HORZHYPH;  (* P01030B *)
  2844   9   11:D     1         
  2845   9   11:0     0           BEGIN
  2846   9   11:1     0             FOR LLBASE04 := 1 TO 38 DO
  2847   9   11:2    11               PRINTCHR( CHR( 34))        (* HYPHEN GRAPHIC *)
  2848   9   11:0    12           END;
  2849   9   11:0    36           
  2850   9   11:0    36           
  2851   9   12:D     1         PROCEDURE HORZLINE( LINE : INTEGER);  (* P01030C *)
  2852   9   12:D     2         
  2853   9   12:0     0           BEGIN
  2854   9   12:1     0             MVCURSOR( 0, LINE);
  2855   9   12:1     5             PRINTCHR( CHR( 39));         (* TILTED "T" ON LEFT OF LINE  *)
  2856   9   12:1     9             HORZHYPH;
  2857   9   12:1    11             PRINTCHR( CHR( 40))          (* TILTED "T" ON RIGHT OF LINE *)
  2858   9   12:0    12           END;
  2859   9   12:0    28           
  2860   9   12:0    28           
  2861   9   13:D     1         PROCEDURE SCRNOUTL;  (* P01030D *)
  2862   9   13:D     1         
  2863   9   13:0     0           BEGIN
  2864   9   13:1     0             MVCURSOR( 0, 0);
  2865   9   13:1     5             PRINTCHR( CHR( 33));         (* UPPER LEFT CORNER *)
  2866   9   13:1     9             FOR LLBASE04 := 1 TO 38 DO
  2867   9   13:2    20               PRINTCHR( CHR( 34));       (* HYPHEN *)
  2868   9   13:1    31             PRINTCHR( CHR( 35));         (* UPPER RIGHT CORNER *)
  2869   9   13:1    35             FOR LLBASE04 := 1 TO 22 DO
  2870   9   13:2    46               BEGIN
  2871   9   13:3    46                 MVCURSOR( 0, LLBASE04);
  2872   9   13:3    51                 PRINTCHR( CHR( 36));     (* VERTICAL BAR ON LEFT  *)
  2873   9   13:3    55                 MVCURSOR( 39, LLBASE04);
  2874   9   13:3    60                 PRINTCHR( CHR( 36))      (* VERTICAL BAR ON RIGHT *)
  2875   9   13:2    61               END;
  2876   9   13:1    71             MVCURSOR( 0, 23);
  2877   9   13:1    76             PRINTCHR( CHR( 37));         (* BOTTOM LEFT CORNER *)
  2878   9   13:1    80             FOR LLBASE04 := 1 TO 38 DO
  2879   9   13:2    91               PRINTCHR( CHR( 34));       (* HYPHEN *)
  2880   9   13:1   102             PRINTCHR( CHR( 38))          (* BOTTOM RIGHT CORNER *)
  2881   9   13:0   103           END;
  2882   9   13:0   124           
  2883   9   13:0   124           
  2884   9   14:D     1         PROCEDURE INITSCRN;  (* P01030E *)
  2885   9   14:D     1         
  2886   9   14:D     1           VAR
  2887   9   14:D     1                UNUSED : ARRAY[ 0..1] OF INTEGER;
  2888   9   14:D     3               
  2889   9   14:0     0           BEGIN
  2890   9   14:1     0             CLRRECT( 0, 0, 40, 24);
  2891   9   14:1     7             UNITREAD( DRIVE1, CHARSET, BLOCKSZ, SCNTOCBL + 2, 0);
  2892   9   14:1    21             SCRNOUTL;
  2893   9   14:1    23             HORZLINE( 10);
  2894   9   14:1    26             HORZLINE( 15);
  2895   9   14:1    29             MVCURSOR( 12, 0);           
  2896   9   14:1    34             PRINTCHR( CHR( 91));         (* TILTED "T" TOP OF LINE *)
  2897   9   14:1    38             FOR LLBASE04 := 1 TO 9 DO
  2898   9   14:2    49               BEGIN
  2899   9   14:3    49                 MVCURSOR( 12, LLBASE04);
  2900   9   14:3    54                 PRINTCHR( CHR( 92))      (* VERTICAL BAR *)
  2901   9   14:2    55               END;
  2902   9   14:1    65             MVCURSOR( 12, 5);
  2903   9   14:1    70             PRINTCHR( CHR( 93));         (* TILTED "T" LEFT OF LINE *)
  2904   9   14:1    74             FOR LLBASE04 := 13 TO 38 DO
  2905   9   14:2    85               PRINTCHR( CHR( 34));       (* HYPHEN *)
  2906   9   14:1    96             PRINTCHR( CHR( 40));         (* TILTED "T" RIGHT OF LINE *)
  2907   9   14:1   100             MVCURSOR( 12, 10);
  2908   9   14:1   105             PRINTCHR( CHR( 94));         (* TILTED "T" BOTTOM OF LINE *)
  2909   9   14:1   109             UNITREAD( DRIVE1, CHARSET, BLOCKSZ, SCNTOCBL + 1, 0);
  2910   9   14:1   123             MVCURSOR( 1, 16);
  2911   9   14:1   128             PRINTSTR( '# CHARACTER NAME  CLASS AC HITS STATUS')
  2912   9   14:0   169           END;
  2913   9   14:0   188           
  2914   9   10:0     0         BEGIN (* MAZESCRN *)
  2915   9   10:1     0           CLRRECT( 0, 0, 40, 24);  (* REPEATED IN INITSCRN!? *)
  2916   9   10:1     7           INITSCRN
  2917   9   10:0     7         END;
  2918   9   10:0    22         
  2919   9   10:0    22         
  2920   9   15:D     1       PROCEDURE GTSERIAL;  (* P01030F *)
  2921   9   15:D     1       
  2922   9   15:D     1         (* GOOFY TRACK SYNCH COPYPROTECTION CODE *)
  2923   9   15:D     1       
  2924   9   15:0     0         BEGIN
  2925   9   15:1     0           UNITREAD( DRIVE1, IOCACHE, BLOCKSZ, SERIALBL, 0);
  2926   9   15:1    12           CPTEMP := 31;  (* OFFSET TO MANGLED SYNCH COUNTS *)
  2927   9   15:1    16           FOR SAVEI := 10 TO 13 DO
  2928   9   15:2    30             BEGIN
  2929   9   15:3    30               MOVELEFT( IOCACHE[ CPTEMP], SYNCH[ (SAVEI - 10)], 2);
  2930   9   15:3    50               CPTEMP := CPTEMP + 2 * (SYNCH[ SAVEI - 10] MOD 13) + 5
  2931   9   15:2    69             END;
  2932   9   15:1    84           MOVELEFT( IOCACHE, MASTSER, 8)
  2933   9   15:0    95         END;
  2934   9   15:0   110         
  2935   9   15:0   110         
  2936   9   16:D     1       PROCEDURE COPYPROT;  (* P010310 *)
  2937   9   16:D     1       
  2938   9   16:D     1         VAR
  2939   9   16:D     1              CPCALC   : INTEGER;
  2940   9   16:D     2              TRIES    : INTEGER;
  2941   9   16:D     3              GOODCOPY : BOOLEAN;
  2942   9   16:D     4       
  2943   9   16:0     0         BEGIN
  2944   9   16:1     0           FOR TRIES := 1 TO 5 DO
  2945   9   16:2    11             BEGIN
  2946   9   16:3    11                GOODCOPY := TRUE;
  2947   9   16:3    14               FOR SAVEI := 10 TO 13 DO
  2948   9   16:4    28                 BEGIN
  2949   9   16:5    28                   UNITREAD( DRIVE1, IOCACHE, BLOCKSZ, 8 * SAVEI, 0);
  2950   9   16:5    44                   MVCURSOR( 60, 0);  (* JUMP TO $2002 AND EXECUTE *)
  2951   9   16:5    49                   CPTEMP := NUM2000.P^;  (* SYNCH COUNT FROM $2002
  2952   9   16:5    56                                               READING DISK TRACKS *)
  2953   9   16:5    56                   IF SAVEI = 10 THEN
  2954   9   16:6    63                     CPCALC := CPTEMP - SYNCH[ 10 - 10];
  2955   9   16:5    78                   CPTEMP := CPTEMP - CPCALC;
  2956   9   16:5    86                   IF ABS( CPTEMP -  SYNCH[ SAVEI - 10]) > 29 THEN
  2957   9   16:6   106                      GOODCOPY := FALSE;
  2958   9   16:4   109                 END;
  2959   9   16:3   119               IF GOODCOPY THEN
  2960   9   16:4   122                 EXIT( COPYPROT);
  2961   9   16:2   126             END;
  2962   9   16:2   133             
  2963   9   16:1   133           MVCURSOR( 70, 0);  (* CRASH AND BURN *)
  2964   9   16:1   138           HALT
  2965   9   16:0   138         END;
  2966   9   16:0   156         
  2967   9   16:0   156         
  2968   9   16:0   156         
  2969   9    9:0     0       BEGIN (* INITGAME *)
  2970   9    9:0     0       
  2971   9    9:1     0         IF LLBASE04 = -1 THEN
  2972   9    9:2     6           BEGIN
  2973   9    9:3     6             REPEAT
  2974   9    9:4     6               WRITE( CHR( 12));
  2975   9    9:4    14               GOTOXY( 0, 11);
  2976   9    9:4    19               WRITE( ' SCENARIO MASTER IN DRV 1, PRESS [RET]');
  2977   9    9:4    67               REPEAT
  2978   9    9:5    67                 GOTOXY( 41, 0);
  2979   9    9:5    72                 GETKEY
  2980   9    9:4    72               UNTIL INCHAR = CHR( CRETURN);
  2981   9    9:4    80               SCNTOCBL := FINDFILE( DRIVE1, 'SCENARIO.DATA')
  2982   9    9:3    97             UNTIL SCNTOCBL >= 0;
  2983   9    9:3   108             
  2984   9    9:3   108             UNITREAD( DRIVE1, NUM2000.P^, BLOCKSZ, SCNTOCBL + 3, 0);
  2985   9    9:3   122                 (* SCNTOCBL + 3 FOLLOWS MAGE AND PRIEST SPELL NAMES *)
  2986   9    9:3   122                 (* COPY PROTECTION CODE GETS LOADED TO $2000        *)
  2987   9    9:3   122             GTSERIAL; (* AND SOME COPY PROTECTION *)
  2988   9    9:3   124             COPYPROT; (* MORE COPY PROTECTION     *)
  2989   9    9:3   126             
  2990   9    9:3   126             REPEAT
  2991   9    9:4   126               WRITE( CHR( 12));
  2992   9    9:4   134               GOTOXY( 0, 11);
  2993   9    9:4   139               WRITE( ' MASTER/DUPLICATE IN DRV 1, PRESS [RET]');
  2994   9    9:4   188               REPEAT
  2995   9    9:5   188                 GOTOXY( 41, 0);
  2996   9    9:5   193                 GETKEY
  2997   9    9:4   193               UNTIL INCHAR = CHR( CRETURN);
  2998   9    9:4   201               SCNTOCBL := FINDFILE( DRIVE1, 'SCENARIO.DATA');
  2999   9    9:4   224               UNITREAD( DRIVE1, IOCACHE, BLOCKSZ, SERIALBL, 0);
  3000   9    9:4   236               MOVELEFT( IOCACHE, DUPLSER, 8)
  3001   9    9:3   246             UNTIL (SCNTOCBL >= 0) AND (MASTSER = DUPLSER);
  3002   9    9:3   258             
  3003   9    9:3   258             TIMEDLAY := 2000;
  3004   9    9:3   263             CACHEWRI := FALSE;
  3005   9    9:3   266             CACHEBL := 0;
  3006   9    9:3   269             UNITREAD( DRIVE1, IOCACHE, SIZEOF( IOCACHE), SCNTOCBL, 0);
  3007   9    9:3   281             MOVELEFT( IOCACHE, SCNTOC, SIZEOF( TSCNTOC))
  3008   9    9:2   294           END;
  3009   9    9:2   294           
  3010   9    9:1   294         XGOTO := XCASTLE;
  3011   9    9:1   297         WRITE( CHR( 12));
  3012   9    9:1   305         TEXTMODE;
  3013   9    9:1   308         MAZESCRN;
  3014   9    9:1   310         MAZEX    := 0;
  3015   9    9:1   313         MAZEY    := 0;
  3016   9    9:1   316         MAZELEV  := 0;
  3017   9    9:1   319         PARTYCNT := 0;
  3018   9    9:1   322         DIRECTIO := 0;
  3019   9    9:1   325         ACMOD2   := 0;
  3020   9    9:1   328         EXIT( SPECIALS)
  3021   9    9:0   332       END;
  3022   9    9:0   354     
  3023   9    9:0   354 (*$I WIZ1B:SPECIALS  *)
  3023   9    9:0   354 (*$I WIZ1B:SPECIALS2 *)
  3024   9    9:0   354   
  3025   9   17:D     1 PROCEDURE SPCMISC;  (* P010311 *)
  3026   9   17:D     1   
  3027   9   17:D     1     VAR
  3028   9   17:D     1          MESSAGE  : PACKED ARRAY[ 0..511] OF CHAR;
  3029   9   17:D   257          
  3030   9   17:D   257          STRBUFF  : RECORD
  3031   9   17:D   257                       BUFF: STRING[ 38];
  3032   9   17:D   257                       ENDMSG : BOOLEAN;
  3033   9   17:D   257                     END;
  3034   9   17:D   278                     
  3035   9   17:D   278          LINECNT  : INTEGER;
  3036   9   17:D   279          MSGX     : INTEGER;
  3037   9   17:D   280          MSGBLK   : INTEGER;
  3038   9   17:D   281          CURMSGBL : INTEGER;
  3039   9   17:D   282          MSGBLK0  : INTEGER;
  3040   9   17:D   283          BOUNCEFL : INTEGER; (* MULTIPLE USES;  FIRST CHAR "FEE" 2CG *)
  3041   9   17:D   284          AUX0     : INTEGER; (* MULTIPLE USES:  EQINDEX, RANDOM 0-6, MSG INDEX
  3042   9   17:D   285                                                 AUX0 *)
  3043   9   17:D   285          AUX1     : INTEGER; (* MULTIPLE USES:  AUX1, MSG INDEX, ....*)
  3044   9   17:D   286          AUX2     : INTEGER;
  3045   9   17:D   287          MAZEFLOR : TMAZE;
  3046   9   17:D   734   
  3047   9   17:D   734       
  3048   9   18:D     1     PROCEDURE DECRYPTM( MSGINDEX: INTEGER);  (* P010312 *)
  3049   9   18:D     2     
  3050   9   18:0     0       BEGIN
  3051   9   18:1     0         MSGBLK := MSGINDEX DIV 12;
  3052   9   18:1     7         MSGX := 42 * (MSGINDEX MOD 12);
  3053   9   18:1    16         IF MSGBLK <> CURMSGBL THEN
  3054   9   18:2    27           BEGIN
  3055   9   18:3    27             UNITREAD( DRIVE1, MESSAGE, BLOCKSZ, MSGBLK0 + MSGBLK, 0);
  3056   9   18:3    47             CURMSGBL := MSGBLK
  3057   9   18:2    47           END;
  3058   9   18:1    55         MOVELEFT( MESSAGE[ MSGX], STRBUFF.BUFF, 42)
  3059   9   18:0    70       END;
  3060   9   18:0    82     
  3061   9   18:0    82     
  3062   9   19:D     1     PROCEDURE DOMSG( MSGLINEX: INTEGER;   (* P010313 *)
  3063   9   19:D     2                      PRESSRET: BOOLEAN);
  3064   9   19:D     3     
  3065   9   19:D     3     
  3066   9   20:D     1       PROCEDURE DO1LINE;  (* P010314 *)
  3067   9   20:D     1       
  3068   9   20:0     0         BEGIN
  3069   9   20:1     0           IF LINECNT = 15 THEN
  3070   9   20:2     8             BEGIN
  3071   9   20:3     8               CLRRECT( 13, 6, 26, 4);
  3072   9   20:3    15               MVCURSOR( 19, 7);
  3073   9   20:3    20               PRINTSTR( '[RET] FOR MORE');
  3074   9   20:3    40               UNITCLEAR( 1);
  3075   9   20:3    43               REPEAT
  3076   9   20:4    43                 GETKEY
  3077   9   20:3    43               UNTIL INCHAR = CHR( CRETURN);
  3078   9   20:3    51               CLRRECT( 13, 6, 26, 4);
  3079   9   20:3    58               CLRRECT( 1, 11, 38, 4);
  3080   9   20:3    65               LINECNT := 11;
  3081   9   20:2    70             END;
  3082   9   20:1    70           DECRYPTM( MSGLINEX);
  3083   9   20:1    75           MVCURSOR( 1, LINECNT);
  3084   9   20:1    83           PRINTSTR( STRBUFF.BUFF);
  3085   9   20:1    90           MSGLINEX := MSGLINEX + 1;
  3086   9   20:1    98           LINECNT := LINECNT + 1
  3087   9   20:0   102         END;  (* DO1LINE *)
  3088   9   20:0   122         
  3089   9   20:0   122         
  3090   9   19:0     0       BEGIN (* DOMSG *)
  3091   9   19:1     0         LINECNT := 11;
  3092   9   19:1     5         REPEAT
  3093   9   19:2     5           DO1LINE
  3094   9   19:1     5         UNTIL STRBUFF.ENDMSG;
  3095   9   19:1    13         IF PRESSRET THEN
  3096   9   19:2    16           BEGIN
  3097   9   19:3    16             CLRRECT( 13, 6, 26, 4);
  3098   9   19:3    23             MVCURSOR( 21, 7);
  3099   9   19:3    28             PRINTSTR( 'PRESS [RET]');
  3100   9   19:3    45             UNITCLEAR( 1);
  3101   9   19:3    48             REPEAT
  3102   9   19:4    48               GETKEY;
  3103   9   19:3    51             UNTIL INCHAR = CHR( CRETURN);
  3104   9   19:3    56             CLRRECT( 13, 6, 26, 4)
  3105   9   19:2    60           END;
  3106   9   19:0    63       END;  (* DOMSG *)
  3107   9   19:0    80       
  3108   9   19:0    80       
  3109   9   21:D     3     FUNCTION GOTITEM( CHARX: INTEGER;  (* P010315 *)
  3110   9   21:D     4                       ITEMX: INTEGER) : BOOLEAN;
  3111   9   21:D     5     
  3112   9   21:D     5       VAR
  3113   9   21:D     5            POSSX : INTEGER;
  3114   9   21:D     6            
  3115   9   21:0     0       BEGIN
  3116   9   21:1     0         GOTITEM := FALSE;
  3117   9   21:1     3         WITH CHARACTR[ CHARX] DO
  3118   9   21:2    10           BEGIN
  3119   9   21:3    10             IF POSS.POSSCNT = 8 THEN
  3120   9   21:4    17               EXIT( GOTITEM);
  3121   9   21:3    21             FOR POSSX := 1 TO POSS.POSSCNT DO
  3122   9   21:4    34               IF POSS.POSSESS[ POSSX].EQINDEX = ITEMX THEN
  3123   9   21:5    47                 EXIT( GOTITEM);
  3124   9   21:3    58             CLRRECT( 1, 11, 38, 4);
  3125   9   21:3    65             MVCURSOR( 1, 11);
  3126   9   21:3    70             PRINTSTR( CHARACTR[ CHARX].NAME);
  3127   9   21:3    78             PRINTSTR( ' GOT ITEM');
  3128   9   21:3    93             POSSX := POSS.POSSCNT + 1;
  3129   9   21:3   100             POSS.POSSCNT := POSSX;
  3130   9   21:3   105             POSS.POSSESS[ POSSX].EQINDEX := ITEMX;
  3131   9   21:3   117             POSS.POSSESS[ POSSX].EQUIPED := FALSE;
  3132   9   21:3   127             POSS.POSSESS[ POSSX].CURSED  := FALSE
  3133   9   21:2   137           END;
  3134   9   21:1   139         GOTITEM := TRUE
  3135   9   21:0   139       END;
  3136   9   21:0   156       
  3137   9   21:0   156       
  3138   9   22:D     1     PROCEDURE TRYGET;  (* P010316 *)
  3139   9   22:D     1     
  3140   9   22:D     1       VAR
  3141   9   22:D     1            GOTONE : BOOLEAN;
  3142   9   22:D     2            CHARX  : INTEGER;
  3143   9   22:D     3            
  3144   9   22:0     0       BEGIN
  3145   9   22:1     0         GOTONE := FALSE;
  3146   9   22:1     3         FOR CHARX := 0 TO PARTYCNT - 1 DO
  3147   9   22:2    16           IF NOT GOTONE THEN
  3148   9   22:3    20             GOTONE := GOTITEM( CHARX, AUX0)
  3149   9   22:0    25       END;
  3150   9   22:0    52       
  3151   9   22:0    52       
  3152   9   23:D     1     PROCEDURE WHOWADE;  (* P010317 *)
  3153   9   23:D     1     
  3154   9   23:D     1       VAR
  3155   9   23:D     1            WADEX : INTEGER;
  3156   9   23:D     2            
  3157   9   23:D     2            
  3158   9   24:D     1       PROCEDURE MAKWORSE( THISSTAT: TSTATUS);  (* P010318 *)
  3159   9   24:D     2       
  3160   9   24:0     0         BEGIN
  3161   9   24:1     0           IF THISSTAT > CHARACTR[ WADEX].STATUS THEN
  3162   9   24:2    13             CHARACTR[ WADEX].STATUS := THISSTAT
  3163   9   24:0    22         END;
  3164   9   24:0    36         
  3165   9   24:0    36         
  3166   9   23:0     0       BEGIN (* WHOWADE *)
  3167   9   23:1     0         CLRRECT( 1, 11, 38, 4);
  3168   9   23:1     7         MVCURSOR( 2, 12);
  3169   9   23:1    12         PRINTSTR( '#) TO WADE, [RET] EXITS');
  3170   9   23:1    41         WADEX := GETCHARX( FALSE, '');
  3171   9   23:1    52         IF WADEX < 0 THEN
  3172   9   23:2    57           EXIT( WHOWADE);
  3173   9   23:2    61           
  3174   9   23:1    61         IF AUX0 = -1 THEN
  3175   9   23:2    70           AUX0 := RANDOM MOD 7;
  3176   9   23:2    81           
  3177   9   23:1    81         CASE AUX0 OF
  3178   9   23:1    87           0:  BEGIN
  3179   9   23:3    87                 IF CHARACTR[ WADEX].STATUS < DEAD THEN
  3180   9   23:4    98                   BEGIN
  3181   9   23:5    98                     CHARACTR[ WADEX].STATUS := OK;
  3182   9   23:5   107                     CHARACTR[ WADEX].HPMAX  := CHARACTR[ WADEX].HPMAX - 8;
  3183   9   23:5   124                     CHARACTR[ WADEX].HPLEFT := CHARACTR[ WADEX].HPMAX;
  3184   9   23:5   139                     IF CHARACTR[ WADEX].HPMAX <= 0 THEN
  3185   9   23:6   150                       MAKWORSE( DEAD);
  3186   9   23:4   153                   END;
  3187   9   23:2   153               END;
  3188   9   23:2   155               
  3189   9   23:1   155           1:  BEGIN
  3190   9   23:3   155                 IF (CHARACTR[ WADEX].ATTRIB[ IQ] = 3) OR
  3191   9   23:3   169                    (CHARACTR[ WADEX].ATTRIB[ PIETY] = 3) THEN
  3192   9   23:4   186                   MAKWORSE( DEAD)
  3193   9   23:3   187                 ELSE
  3194   9   23:4   191                   BEGIN
  3195   9   23:5   191                     CHARACTR[ WADEX].AGE := CHARACTR[ WADEX].AGE - 52;
  3196   9   23:5   208                     CHARACTR[ WADEX].ATTRIB[ IQ] :=
  3197   9   23:5   219                       CHARACTR[ WADEX].ATTRIB[ IQ] - 1;
  3198   9   23:5   234                     CHARACTR[ WADEX].ATTRIB[ PIETY] :=
  3199   9   23:5   245                       CHARACTR[ WADEX].ATTRIB[ PIETY] - 1
  3200   9   23:4   257                   END
  3201   9   23:2   260               END;
  3202   9   23:2   262             
  3203   9   23:1   262           2:  CHARACTR[ WADEX].LOSTXYL.POISNAMT[ 1] := 1;
  3204   9   23:1   278           3:  MAKWORSE( ASLEEP);
  3205   9   23:1   283           4:  MAKWORSE( PLYZE);
  3206   9   23:1   288           5:  MAKWORSE( STONED);
  3207   9   23:1   293           6:  IF CHARACTR[ WADEX].STATUS = DEAD THEN
  3208   9   23:3   304                 IF (RANDOM MOD 10 < 3) THEN
  3209   9   23:4   315                   BEGIN
  3210   9   23:5   315                     CHARACTR[ WADEX].STATUS := OK;
  3211   9   23:5   324                     CHARACTR[ WADEX].HPLEFT := CHARACTR[ WADEX].HPMAX
  3212   9   23:4   336                   END
  3213   9   23:3   339                 ELSE
  3214   9   23:4   341                   CHARACTR[ WADEX].STATUS := ASHES;
  3215   9   23:1   352         END
  3216   9   23:0   374       END;  (* WHOWADE *)
  3217   9   23:0   390       
  3218   9   23:0   390       
  3219   9   23:0   390       
  3220   9   25:D     1     PROCEDURE GETYN;  (* P010319 *)
  3221   9   25:D     1     
  3222   9   25:0     0       BEGIN
  3223   9   25:1     0         CLRRECT( 1, 11, 38, 4);
  3224   9   25:1     7         MVCURSOR( 1, 11);
  3225   9   25:1    12         PRINTSTR( 'SEARCH (Y/N) ?');
  3226   9   25:1    32         REPEAT
  3227   9   25:2    32           GETKEY
  3228   9   25:1    32         UNTIL (INCHAR = 'Y') OR (INCHAR = 'N');
  3229   9   25:1    44         IF INCHAR = 'N' THEN
  3230   9   25:2    49           EXIT( SPECIALS);
  3231   9   25:1    53         IF AUX0 > 0 THEN
  3232   9   25:2    61           BEGIN
  3233   9   25:3    61             ATTK012 := 0;
  3234   9   25:3    64             ENEMYINX := AUX0;
  3235   9   25:3    70             XGOTO := XCOMBAT
  3236   9   25:2    70           END
  3237   9   25:1    73         ELSE
  3238   9   25:2    75           BEGIN
  3239   9   25:3    75             AUX0 := ABS( AUX0);
  3240   9   25:3    84             TRYGET
  3241   9   25:2    84           END;
  3242   9   25:0    86       END;
  3243   9   25:0   100     
  3244   9   25:0   100       
  3245   9   26:D     1     PROCEDURE BOUNCEBK;  (* P01031A *)
  3246   9   26:D     1     
  3247   9   26:0     0       BEGIN
  3248   9   26:1     0         CASE DIRECTIO OF
  3249   9   26:1     4           0:  MAZEY := MAZEY - 1;
  3250   9   26:1    12           1:  MAZEX := MAZEX - 1;
  3251   9   26:1    20           2:  MAZEY := MAZEY + 1;
  3252   9   26:1    28           3:  MAZEX := MAZEX + 1;
  3253   9   26:1    36         END;
  3254   9   26:1    52         MAZEY := (MAZEY + 20) MOD 20;
  3255   9   26:1    60         MAZEX := (MAZEX + 20) MOD 20;
  3256   9   26:1    68         IF AUX1 >= 0 THEN
  3257   9   26:2    76             DOMSG( AUX1, FALSE)
  3258   9   26:0    81       END;
  3259   9   26:0    96   
  3260   9   26:0    96   
  3261   9   27:D     1     PROCEDURE ITM2PASS;  (* P01031B *)
  3262   9   27:D     1     
  3263   9   27:D     1     VAR
  3264   9   27:D     1          POSX  : INTEGER;
  3265   9   27:D     2          CHARX : INTEGER;
  3266   9   27:D     3          
  3267   9   27:0     0       BEGIN
  3268   9   27:1     0         FOR CHARX := 0 TO PARTYCNT - 1 DO
  3269   9   27:2    13           WITH CHARACTR[ CHARX] DO
  3270   9   27:3    20             BEGIN
  3271   9   27:4    20               FOR POSX := 1 TO POSS.POSSCNT DO
  3272   9   27:5    33                 IF POSS.POSSESS[ POSX].EQINDEX = AUX0 THEN
  3273   9   27:6    49                   EXIT( SPECIALS)
  3274   9   27:3    53             END;
  3275   9   27:1    67         BOUNCEBK
  3276   9   27:0    67       END;
  3277   9   27:0    86       
  3278   9   27:0    86       
  3279   9   28:D     1     PROCEDURE CHKALIGN;  (* P01031C *)
  3280   9   28:D     1     
  3281   9   28:D     1       VAR
  3282   9   28:D     1            CHARX : INTEGER;
  3283   9   28:D     2            
  3284   9   28:0     0       BEGIN
  3285   9   28:1     0         FOR CHARX := 0 TO PARTYCNT - 1 DO
  3286   9   28:2    13           WITH CHARACTR[ CHARX] DO
  3287   9   28:3    20             BEGIN
  3288   9   28:4    20               CASE ALIGN OF
  3289   9   28:4    25               
  3290   9   28:4    25                    GOOD:  IF (AUX0 = 0) OR (AUX0 = 2) OR
  3291   9   28:5    38                              (AUX0 = 4) OR (AUX0 = 6) THEN
  3292   9   28:6    54                             BOUNCEBK;
  3293   9   28:6    58                         
  3294   9   28:4    58                 NEUTRAL:  IF (AUX0 = 0) OR (AUX0 = 1) OR
  3295   9   28:5    71                              (AUX0 = 4) OR (AUX0 = 5) THEN
  3296   9   28:6    87                             BOUNCEBK;
  3297   9   28:6    91                         
  3298   9   28:4    91                    EVIL:  IF (AUX0 < 4) THEN
  3299   9   28:6    99                             BOUNCEBK
  3300   9   28:4    99               END
  3301   9   28:3   116             END
  3302   9   28:0   116       END;  (* CHKALIGN *)
  3303   9   28:0   138       
  3304   9   28:0   138       
  3305   9   29:D     1     PROCEDURE CHKAUX0;  (* P01031D *)
  3306   9   29:D     1     
  3307   9   29:0     0       BEGIN
  3308   9   29:1     0         IF AUX0 = 99 THEN
  3309   9   29:2     8           LIGHT := LIGHT + 50
  3310   9   29:1     9         ELSE IF AUX0 = -99 THEN
  3311   9   29:3    24           LIGHT := 0
  3312   9   29:2    24         ELSE
  3313   9   29:3    29           ACMOD2 := AUX0
  3314   9   29:0    29       END;  (* CHKAUX0 *)
  3315   9   29:0    48       
  3316   9   29:0    48       
  3317   9   30:D     1     PROCEDURE BCK2SHOP;  (* P01031E *)
  3318   9   30:D     1     
  3319   9   30:0     0       BEGIN
  3320   9   30:1     0         MAZELEV := 0;
  3321   9   30:1     3         WRITE( CHR(12));
  3322   9   30:1    11         XGOTO := XNEWMAZE
  3323   9   30:0    11       END;
  3324   9   30:0    26         
  3325   9   30:0    26         
  3326   9   31:D     1     PROCEDURE RIDDLES;  (* P01031F *)
  3327   9   31:D     1     
  3328   9   31:D     1       VAR
  3329   9   31:D     1            ANSWER : STRING[ 40];
  3330   9   31:D    22     
  3331   9   31:0     0       BEGIN
  3332   9   31:1     0         CLRRECT( 1, 11, 38, 4);
  3333   9   31:1     7         MVCURSOR( 1, 11);
  3334   9   31:1    12         PRINTSTR( 'ANSWER ?');
  3335   9   31:1    26         GETSTR( ANSWER, 1, 13);
  3336   9   31:1    33         DECRYPTM( AUX0);
  3337   9   31:1    39         CLRRECT( 1, 11, 38, 4);
  3338   9   31:1    46         MVCURSOR( 1, 11);
  3339   9   31:1    51         IF STRBUFF.BUFF <> ANSWER THEN
  3340   9   31:2    61           BEGIN
  3341   9   31:3    61             AUX1 := - 1;
  3342   9   31:3    67             PRINTSTR( 'WRONG!');
  3343   9   31:3    79             BOUNCEBK
  3344   9   31:2    79           END
  3345   9   31:1    81         ELSE
  3346   9   31:2    83           PRINTSTR( 'RIGHT!')
  3347   9   31:0    92       END;
  3348   9   31:0   108 
  3349   9   31:0   108 
  3350   9   32:D     1     PROCEDURE FEEIS;  (* P010320 *)
  3351   9   32:D     1     
  3352   9   32:D     1       VAR
  3353   9   32:D     1            GOLDTOT : TWIZLONG;
  3354   9   32:D     4            FEE     : TWIZLONG;
  3355   9   32:D     7     
  3356   9   32:D     7     
  3357   9   33:D     1       PROCEDURE FEE2LONG;  (* P010321 *)
  3358   9   33:D     1       
  3359   9   33:D     1         VAR
  3360   9   33:D     1              MULT10 : INTEGER;
  3361   9   33:D     2              STRX   : INTEGER;
  3362   9   33:D     3       
  3363   9   33:0     0         BEGIN
  3364   9   33:1     0           IF STRBUFF.BUFF[ 1] >= '@' THEN
  3365   9   33:2    10             BEGIN
  3366   9   33:3    10               BOUNCEFL := ORD( STRBUFF.BUFF[ 1]) - ORD( 'A') + 1;
  3367   9   33:3    24               STRBUFF.BUFF := COPY( STRBUFF.BUFF, 2,
  3368   9   33:3    35                                     ORD( STRBUFF.BUFF[ 0]) - 1)
  3369   9   33:2    48             END
  3370   9   33:1    50           ELSE
  3371   9   33:2    52             BOUNCEFL := 0;
  3372   9   33:1    57           FILLCHAR( FEE, 6, 0);
  3373   9   33:1    65           MULT10 := 10;
  3374   9   33:1    68           FOR STRX := 1 TO LENGTH( STRBUFF.BUFF) DO
  3375   9   33:2    84             BEGIN
  3376   9   33:3    84               MULTLONG( FEE, MULT10);
  3377   9   33:3    92               FEE.LOW := FEE.LOW + ORD( STRBUFF.BUFF[ STRX]) - ORD( '0')
  3378   9   33:2   103             END
  3379   9   33:0   107         END;
  3380   9   33:0   128         
  3381   9   33:0   128         
  3382   9   34:D     1       PROCEDURE CHKGOLD;  (* P010322 *)
  3383   9   34:D     1       
  3384   9   34:D     1         VAR
  3385   9   34:D     1              CHARX : INTEGER;
  3386   9   34:D     2       
  3387   9   34:0     0         BEGIN
  3388   9   34:1     0           FILLCHAR( GOLDTOT, 6, 0);
  3389   9   34:1     8           FOR CHARX := 0 TO PARTYCNT - 1 DO
  3390   9   34:2    21             ADDLONGS( GOLDTOT, CHARACTR[ CHARX].GOLD);
  3391   9   34:1    41           IF TESTLONG( GOLDTOT, FEE) <> -1 THEN
  3392   9   34:2    57             EXIT( CHKGOLD);
  3393   9   34:1    61           PRINTSTR( 'NOT ENOUGH $');
  3394   9   34:1    79           IF BOUNCEFL = 0 THEN
  3395   9   34:2    87             BOUNCEBK;
  3396   9   34:1    89           EXIT( SPECIALS)
  3397   9   34:0    93         END;
  3398   9   34:0   108         
  3399   9   34:0   108         
  3400   9   35:D     1       PROCEDURE PAYGOLD;  (* P010323 *)
  3401   9   35:D     1       
  3402   9   35:D     1         VAR
  3403   9   35:D     1              CHARX : INTEGER;
  3404   9   35:D     2       
  3405   9   35:0     0         BEGIN
  3406   9   35:1     0           FILLCHAR( GOLDTOT, 6, 0);
  3407   9   35:1     8           FOR CHARX := 0 TO PARTYCNT - 1 DO
  3408   9   35:2    21             BEGIN
  3409   9   35:3    21               IF FEE <> GOLDTOT THEN
  3410   9   35:4    32                 IF TESTLONG( FEE, CHARACTR[ CHARX].GOLD) = 1 THEN
  3411   9   35:5    51                   BEGIN
  3412   9   35:6    51                     SUBLONGS( FEE, CHARACTR[ CHARX].GOLD);
  3413   9   35:6    64                     FILLCHAR( CHARACTR[ CHARX].GOLD, 6, 0)
  3414   9   35:5    76                   END
  3415   9   35:4    76                 ELSE
  3416   9   35:5    78                   BEGIN
  3417   9   35:6    78                     SUBLONGS( CHARACTR[ CHARX].GOLD, FEE);
  3418   9   35:6    91                     FILLCHAR( FEE, 6, 0)
  3419   9   35:5    99                   END
  3420   9   35:2    99             END;
  3421   9   35:1   106           PRINTSTR( 'THANKS!')
  3422   9   35:0   116         END;
  3423   9   35:0   134         
  3424   9   35:0   134         
  3425   9   32:0     0       BEGIN (* FEEIS *)
  3426   9   32:1     0         DECRYPTM( AUX0);
  3427   9   32:1     6         FEE2LONG;
  3428   9   32:1     8         CLRRECT( 1, 11, 38, 4);
  3429   9   32:1    15         MVCURSOR( 1, 11);
  3430   9   32:1    20         PRINTSTR( 'FEE IS ');
  3431   9   32:1    33         PRINTSTR( STRBUFF.BUFF);
  3432   9   32:1    40         MVCURSOR( 1, 13);
  3433   9   32:1    45         PRINTSTR( 'PAY (Y/N) ?');
  3434   9   32:1    62         REPEAT
  3435   9   32:2    62           GETKEY
  3436   9   32:1    62         UNTIL (INCHAR = 'Y') OR (INCHAR = 'N');
  3437   9   32:1    74         AUX1 := -1;
  3438   9   32:1    80         IF INCHAR = 'N' THEN
  3439   9   32:2    85           BEGIN
  3440   9   32:3    85             IF BOUNCEFL = 0 THEN
  3441   9   32:4    93                BOUNCEBK;
  3442   9   32:3    95             EXIT( SPECIALS)
  3443   9   32:2    99           END
  3444   9   32:1    99         ELSE
  3445   9   32:2   101           BEGIN
  3446   9   32:3   101             CLRRECT( 1, 11, 38, 4);
  3447   9   32:3   108             MVCURSOR( 1, 11);
  3448   9   32:3   113             CHKGOLD;
  3449   9   32:3   115             PAYGOLD;
  3450   9   32:3   117             IF BOUNCEFL > 0 THEN
  3451   9   32:4   125               BEGIN
  3452   9   32:5   125                 MAZEX   := MAZEFLOR.AUX2[ BOUNCEFL];
  3453   9   32:5   138                 MAZEY   := MAZEFLOR.AUX1[ BOUNCEFL];
  3454   9   32:5   151                 MAZELEV := MAZEFLOR.AUX0[ BOUNCEFL];
  3455   9   32:5   164                 XGOTO := XNEWMAZE
  3456   9   32:4   164               END
  3457   9   32:2   167           END
  3458   9   32:0   167       END;
  3459   9   32:0   182       
  3460   9   32:0   182       
  3461   9   36:D     1     PROCEDURE LOOKOUT;  (* P010324 *)
  3462   9   36:D     1     
  3463   9   36:D     1       VAR
  3464   9   36:D     1            Y  : INTEGER;
  3465   9   36:D     2            X  : INTEGER;
  3466   9   36:D     3            Y2 : INTEGER;
  3467   9   36:D     4            X2 : INTEGER;
  3468   9   36:D     5            
  3469   9   36:0     0       BEGIN
  3470   9   36:1     0         FOR X2 := - AUX0 TO AUX0 DO
  3471   9   36:2    18           FOR Y2 := - AUX0 TO AUX0 DO
  3472   9   36:3    36             BEGIN
  3473   9   36:4    36               X := (MAZEX + X2 + 20) MOD 20;
  3474   9   36:4    46               Y := (MAZEY + Y2 + 20) MOD 20;
  3475   9   36:4    56               FIGHTMAP[ X, Y] := TRUE
  3476   9   36:3    65             END;
  3477   9   36:1    81         FIGHTMAP[ MAZEX, MAZEY] := FALSE
  3478   9   36:0    92       END;
  3479   9   36:0   110       
  3480   9   36:0   110       
  3481   9   37:D     1     PROCEDURE SWITCHLOC;  (* P010325 *)
  3482   9   37:D     1     
  3483   9   37:D     1       VAR
  3484   9   37:D     1            BEENHERE : PACKED ARRAY[ 0..19] OF PACKED ARRAY[ 0..19] OF BOOLEAN;
  3485   9   37:D    41            UNUSED1  : INTEGER;
  3486   9   37:D    42            UNUSED2  : INTEGER;
  3487   9   37:D    43            UNUSED3  : INTEGER;
  3488   9   37:D    44            DOORCNT  : INTEGER;  (* DOORS GONE THROUGH *)
  3489   9   37:D    45     
  3490   9   37:D    45     
  3491   9   38:D     1       PROCEDURE SWITCH( VAR FIRST:  INTEGER;  (* P010326 *)
  3492   9   38:D     2                         VAR SECOND: INTEGER);
  3493   9   38:D     3       
  3494   9   38:D     3         VAR
  3495   9   38:D     3              SAVE : INTEGER;
  3496   9   38:D     4       
  3497   9   38:0     0         BEGIN
  3498   9   38:1     0           SAVE   := FIRST;
  3499   9   38:1     4           FIRST  := SECOND;
  3500   9   38:1     8           SECOND := SAVE
  3501   9   38:0     9         END;
  3502   9   38:0    24         
  3503   9   38:0    24         
  3504   9   39:D     1       PROCEDURE FINDDOOR;  (* P010327 *)
  3505   9   39:D     1     
  3506   9   39:D     1         VAR
  3507   9   39:D     1              LIMITMOV : INTEGER;  (* LIMIT DOORS (ROOMS) MOVED THROUGH *)
  3508   9   39:D     2     
  3509   9   39:D     2     
  3510   9   40:D     3         FUNCTION P010328( X : INTEGER; Y : INTEGER) : BOOLEAN;  (* P010328 *)
  3511   9   40:D     5         
  3512   9   40:D     5         
  3513   9   41:D     1           PROCEDURE TRYADJ( X : INTEGER; Y : INTEGER);  (* P010329 *)
  3514   9   41:D     3             
  3515   9   41:D     3             
  3516   9   42:D     1             PROCEDURE CHK4DOOR( WALLTYPE : TWALL;  (* P01032A *)
  3517   9   42:D     2                                 MOVETOX  : INTEGER;
  3518   9   42:D     3                                 MOVETOY  : INTEGER);
  3519   9   42:D     4             
  3520   9   42:0     0               BEGIN (* CHK4DOOR *)
  3521   9   42:1     0                 IF (WALLTYPE = OPEN) OR (WALLTYPE = WALL) THEN
  3522   9   42:2     9                   EXIT( CHK4DOOR);
  3523   9   42:1    13                 IF WALLTYPE = HIDEDOOR THEN
  3524   9   42:2    18                   IF (RANDOM MOD 100) < 65 THEN
  3525   9   42:3    29                     EXIT( CHK4DOOR);
  3526   9   42:3    33                     
  3527   9   42:3    33                 (* EITHER A DOOR OR SOMETIMES A HIDDEN DOOR *)
  3528   9   42:3    33                     
  3529   9   42:1    33                 MOVETOX := (MOVETOX + 20) MOD 20;
  3530   9   42:1    40                 MOVETOY := (MOVETOY + 20) MOD 20;
  3531   9   42:1    47                 IF (DOORCNT = 0) OR
  3532   9   42:1    52                   (NOT (BEENHERE[ MOVETOX][ MOVETOY])
  3533   9   42:1    62                    AND ((RANDOM MOD 100) > (65 - LIMITMOV))) THEN
  3534   9   42:2    81                    BEGIN
  3535   9   42:3    81                      SAVEX := X;
  3536   9   42:3    86                      SAVEY := Y;
  3537   9   42:3    91                      MAZEX := MOVETOX;
  3538   9   42:3    94                      MAZEY := MOVETOY;
  3539   9   42:3    97                      DOORCNT := DOORCNT + 1;
  3540   9   42:3   105                      P010328 := TRUE;
  3541   9   42:3   109                      EXIT( P010328)
  3542   9   42:2   113                    END;
  3543   9   42:0   113               END;  (* CHK4DOOR *)
  3544   9   42:0   126               
  3545   9   42:0   126               
  3546   9   41:0     0             BEGIN (* TRYADJ *)
  3547   9   41:1     0               X := (X + 20) MOD 20;
  3548   9   41:1     7               Y := (Y + 20) MOD 20;
  3549   9   41:1    14               IF BEENHERE[ X][ Y] THEN
  3550   9   41:2    27                 EXIT( TRYADJ);
  3551   9   41:1    31               IF MAZEFLOR.SQRETYPE[ MAZEFLOR.SQREXTRA[ X][ Y]] <> NORMAL THEN
  3552   9   41:2    55                 BEGIN
  3553   9   41:3    55                   MAZEX := X;
  3554   9   41:3    58                   MAZEY := Y;
  3555   9   41:3    61                   EXIT( FINDDOOR)
  3556   9   41:2    65                 END;
  3557   9   41:2    65                 
  3558   9   41:1    65               BEENHERE[ X][ Y] := TRUE;
  3559   9   41:1    77               
  3560   9   41:1    77               CHK4DOOR( MAZEFLOR.N[ X][ Y], X, Y + 1);
  3561   9   41:1    95               CHK4DOOR( MAZEFLOR.S[ X][ Y], X, Y - 1);
  3562   9   41:1   113               CHK4DOOR( MAZEFLOR.E[ X][ Y], X + 1, Y);
  3563   9   41:1   131               CHK4DOOR( MAZEFLOR.W[ X][ Y], X - 1, Y);
  3564   9   41:1   149               
  3565   9   41:1   149               IF MAZEFLOR.N[ X][ Y] = OPEN THEN
  3566   9   41:2   165                 TRYADJ( X, Y + 1);
  3567   9   41:1   171               IF MAZEFLOR.W[ X][ Y] = OPEN THEN
  3568   9   41:2   187                 TRYADJ( X - 1, Y);
  3569   9   41:1   193               IF MAZEFLOR.E[ X][ Y] = OPEN THEN
  3570   9   41:2   209                 TRYADJ( X + 1, Y);
  3571   9   41:1   215               IF MAZEFLOR.S[ X][ Y] = OPEN THEN
  3572   9   41:2   231                 TRYADJ( X, Y - 1)
  3573   9   41:0   235             END;  (* TRYADJ *)
  3574   9   41:0   250         
  3575   9   41:0   250         
  3576   9   40:0     0           BEGIN (* P010328 *)
  3577   9   40:1     0             P010328 := FALSE;
  3578   9   40:1     3             TRYADJ( X, Y)
  3579   9   40:0     5           END;  (* P010328 *)
  3580   9   40:0    20           
  3581   9   40:0    20           
  3582   9   40:0    20           
  3583   9   39:0     0         BEGIN  (* FINDDOOR *)
  3584   9   39:1     0           LIMITMOV := 0;
  3585   9   39:1     3           WHILE  (DOORCNT = 0) OR
  3586   9   39:1     8                  ((RANDOM MOD 65) >  LIMITMOV) DO
  3587   9   39:2    20             BEGIN
  3588   9   39:3    20               IF NOT P010328( MAZEX, MAZEY) THEN
  3589   9   39:4    31                 EXIT( FINDDOOR);
  3590   9   39:3    35               LIMITMOV := LIMITMOV + 10;
  3591   9   39:2    40             END;
  3592   9   39:0    42         END;
  3593   9   39:0    56       
  3594   9   39:0    56       
  3595   9   37:0     0       BEGIN  (* SWITCHLOC *)
  3596   9   37:1     0         XGOTO2 := XCOMBAT;
  3597   9   37:1     3         XGOTO := XRUNNER;
  3598   9   37:1     6         FILLCHAR( BEENHERE, 80, 0);
  3599   9   37:1    13         DOORCNT := 0;
  3600   9   37:1    16         MAZEFLOR.SQREXTRA[ MAZEX][ MAZEY] := 0;
  3601   9   37:1    31         FINDDOOR;
  3602   9   37:1    33         DIRECTIO := RANDOM MOD 4;
  3603   9   37:1    42         EXIT( SPECIALS);
  3604   9   37:0    46       END;  (* SWITCHLOC *)
  3605   9   37:0    58       
  3606   9   37:0    58       
  3607   9   17:0     0     BEGIN  (* SPCMISC *)
  3608   9   17:1     0       MOVELEFT( IOCACHE[ GETREC( ZMAZE, MAZELEV - 1, SIZEOF( TMAZE))],
  3609   9   17:1    16                 MAZEFLOR,
  3610   9   17:1    20                 SIZEOF( TMAZE));
  3611   9   17:1    25       BOUNCEFL := SPCINDEX;
  3612   9   17:1    31       IF BOUNCEFL = 0 THEN
  3613   9   17:2    38         SWITCHLOC;
  3614   9   17:1    40       XGOTO2 := XSCNMSG;
  3615   9   17:1    43       CLRRECT( 1, 11, 38, 4);
  3616   9   17:1    50       MSGBLK0 := FINDFILE( DRIVE1, 'SCENARIO.MESGS');
  3617   9   17:1    75       IF MSGBLK0 < 0 THEN
  3618   9   17:2    82         BEGIN
  3619   9   17:3    82           MVCURSOR( 1, 11);
  3620   9   17:3    87           PRINTSTR( 'MESGS LOST');
  3621   9   17:3   103           EXIT( SPECIALS);
  3622   9   17:2   107         END;
  3623   9   17:1   107       CURMSGBL := 0;
  3624   9   17:1   111       UNITREAD( DRIVE1, MESSAGE, BLOCKSZ, MSGBLK0, 0);
  3625   9   17:1   124       AUX2 := MAZEFLOR.AUX2[ BOUNCEFL];
  3626   9   17:1   136       AUX1 := MAZEFLOR.AUX1[ BOUNCEFL];
  3627   9   17:1   148       AUX0 := MAZEFLOR.AUX0[ BOUNCEFL];
  3628   9   17:1   160       XGOTO := XRUNNER;
  3629   9   17:1   163       IF AUX2 = 0 THEN
  3630   9   17:2   170         EXIT( SPECIALS);
  3631   9   17:1   174       IF (AUX2 = 1) OR (AUX2 = 4) OR (AUX2 = 8) THEN
  3632   9   17:2   193         BEGIN
  3633   9   17:3   193           IF AUX0 = 0 THEN
  3634   9   17:4   200             EXIT( SPECIALS)
  3635   9   17:3   204           ELSE
  3636   9   17:4   206             BEGIN
  3637   9   17:5   206               IF AUX2 <> 4 THEN
  3638   9   17:6   213                 BEGIN
  3639   9   17:7   213                   IF AUX0 > 0 THEN
  3640   9   17:8   220                     MAZEFLOR.AUX0[ BOUNCEFL] := AUX0 - 1;
  3641   9   17:7   234                   IF AUX0 = 1 THEN
  3642   9   17:8   241                     MAZEFLOR.SQRETYPE[ BOUNCEFL] := NORMAL;
  3643   9   17:6   252                 END
  3644   9   17:5   252               ELSE
  3645   9   17:6   254                 IF AUX0 < 0 THEN
  3646   9   17:7   261                   IF AUX0 > -1000 THEN
  3647   9   17:8   271                     MAZEFLOR.AUX0[ BOUNCEFL] := 0
  3648   9   17:7   279                   ELSE
  3649   9   17:8   283                     AUX0 := AUX0 + 1000;
  3650   9   17:5   293               MOVELEFT( MAZEFLOR,
  3651   9   17:5   297                         IOCACHE[ GETRECW( ZMAZE, MAZELEV - 1, SIZEOF( TMAZE))],
  3652   9   17:5   313                         SIZEOF( TMAZE))
  3653   9   17:4   318             END
  3654   9   17:2   318         END;
  3655   9   17:2   318         
  3656   9   17:1   318       CLRRECT( 1, 11, 38, 4);
  3657   9   17:1   325       IF NOT ( (AUX2 = 5) OR (AUX2 = 6) ) THEN
  3658   9   17:2   339         DOMSG( AUX1,
  3659   9   17:2   342                  (AUX2 = 2)  OR (AUX2 = 3) OR (AUX2 = 4) OR
  3660   9   17:2   359                  (AUX2 = 10) OR (AUX2 = 11) OR (AUX2 = 12));
  3661   9   17:1   379       CASE AUX2 OF
  3662   9   17:1   384          2: TRYGET;
  3663   9   17:1   388          3: WHOWADE;
  3664   9   17:1   392          4: GETYN;
  3665   9   17:1   396          5: ITM2PASS;
  3666   9   17:1   400          6: CHKALIGN;
  3667   9   17:1   404          7: CHKAUX0;
  3668   9   17:1   408          8: BCK2SHOP;
  3669   9   17:1   412          9: LOOKOUT;
  3670   9   17:1   416         10: RIDDLES;
  3671   9   17:1   420         11: FEEIS;
  3672   9   17:1   424       END;
  3673   9   17:0   452     END;  (* SPCMISC *)
  3674   9   17:0   464     
  3675   9    1:0     0   BEGIN  (* SPECIALS *)
  3676   9    1:0     0   
  3677   9    1:1     0     IF XGOTO = XINSAREA THEN
  3678   9    1:2     5       INSPECT;
  3679   9    1:1     7     XGOTO := XGOTO2;
  3680   9    1:1    10     SPCINDEX := LLBASE04;
  3681   9    1:1    13     IF SPCINDEX < 0 THEN
  3682   9    1:2    18       INITGAME
  3683   9    1:1    18     ELSE
  3684   9    1:2    22       SPCMISC
  3685   9    1:2    22 
  3686   9    1:0    22   END;  (* SPECIALS *)
  3687   9    1:0    36 (*$I WIZ1B:SPECIALS2 *)
  3688   9    1:0    36 
  3688   9    1:0    36 (*$I WIZ1B:COMBAT    *)
  3689  10    1:D     1   SEGMENT PROCEDURE COMBAT;  (* P010401 *)
  3690  10    1:D     1 
  3691  10    1:D     1     CONST
  3692  10    1:D     1     
  3693  10    1:D     1         HALITO   =  4178;
  3694  10    1:D     1         MOGREF   =  2409;
  3695  10    1:D     1         KATINO   =  3983;
  3696  10    1:D     1         DUMAPIC  =  3245;
  3697  10    1:D     1         
  3698  10    1:D     1         DILTO    =  3340;
  3699  10    1:D     1         SOPIC    =  1953;
  3700  10    1:D     1         
  3701  10    1:D     1         MAHALITO =  6181;
  3702  10    1:D     1         MOLITO   =  4731;
  3703  10    1:D     1         
  3704  10    1:D     1         MORLIS   =  4744;
  3705  10    1:D     1         DALTO    =  3180;
  3706  10    1:D     1         LAHALITO =  6156;
  3707  10    1:D     1         
  3708  10    1:D     1         MAMORLIS =  7525;
  3709  10    1:D     1         MAKANITO =  6612;
  3710  10    1:D     1         MADALTO  =  4925;
  3711  10    1:D     1         
  3712  10    1:D     1         LAKANITO =  6587;
  3713  10    1:D     1         ZILWAN   =  4573;
  3714  10    1:D     1         MASOPIC  =  3990;
  3715  10    1:D     1         HAMAN    =  1562;
  3716  10    1:D     1         
  3717  10    1:D     1         MALOR    =  3128;
  3718  10    1:D     1         MAHAMAN  =  2597;
  3719  10    1:D     1         TILTOWAI = 11157;
  3720  10    1:D     1         
  3721  10    1:D     1         
  3722  10    1:D     1         KALKI    =  1449;
  3723  10    1:D     1         DIOS     =  2301;
  3724  10    1:D     1         BADIOS   =  3675;
  3725  10    1:D     1         MILWA    =  2889;
  3726  10    1:D     1         PORFIC   =  2287;
  3727  10    1:D     1         
  3728  10    1:D     1         MATU     =  3139;
  3729  10    1:D     1         CALFO    =     0; (* 1717 *)
  3730  10    1:D     1         MANIFO   =  2619;
  3731  10    1:D     1         MONTINO  =  5970;
  3732  10    1:D     1         
  3733  10    1:D     1         LOMILWA  =  5333;
  3734  10    1:D     1         DIALKO   =  2718;
  3735  10    1:D     1         LATUMAPI =  6491;
  3736  10    1:D     1         BAMATU   =  5169;
  3737  10    1:D     1         
  3738  10    1:D     1         DIAL     =   761;
  3739  10    1:D     1         BADIAL   =  1253;
  3740  10    1:D     1         LATUMOFI =  9463;
  3741  10    1:D     1         MAPORFIC =  4322;
  3742  10    1:D     1         
  3743  10    1:D     1         DIALMA   =  1614;
  3744  10    1:D     1         BADIALMA =  2446;
  3745  10    1:D     1         LITOKAN  =  4396;
  3746  10    1:D     1         KANDI    =  1185; (* 1885 *)
  3747  10    1:D     1         DI       =   180;
  3748  10    1:D     1         BADI     =   382;
  3749  10    1:D     1         
  3750  10    1:D     1         LORTO    =  4296;
  3751  10    1:D     1         MADI     =   547;
  3752  10    1:D     1         MABADI   =   759;
  3753  10    1:D     1         LOKTOFEI =  8330;
  3754  10    1:D     1         
  3755  10    1:D     1         MALIKTO  =  5514;
  3756  10    1:D     1         KADORTO  =  6673;
  3757  10    1:D     1         
  3758  10    1:D     1     VAR
  3759  10    1:D     1          CINITFL1 : INTEGER;
  3760  10    1:D     2          SURPRISE : INTEGER;
  3761  10    1:D     3          DONEFIGH : BOOLEAN;
  3762  10    1:D     4          PREBATOR : ARRAY[ 0..5] OF INTEGER;
  3763  10    1:D    10          DRAINED  : ARRAY[ 0..5] OF BOOLEAN;
  3764  10    1:D    16          BATTLERC : ARRAY[ 0..4] OF TENEMY2;
  3765  10    1:D   746 
  3766  10    1:D   746     
  3767  10    1:D   746 (* CINIT *)
  3768  10    1:D   746     
  3769  11    1:D     1     SEGMENT PROCEDURE CINIT;  (* P010501 *)
  3770  11    1:D     1       
  3771  11    1:D     1       
  3772  11    2:D     1       PROCEDURE ENEMYPIC( ENEMYID : INTEGER);  (* P010502 *)
  3773  11    2:D     2       
  3774  11    2:D     2         VAR
  3775  11    2:D     2              PICLINE  : INTEGER;
  3776  11    2:D     3              UNUSED   : INTEGER;
  3777  11    2:D     4              SCRNADDR : RECORD CASE INTEGER OF
  3778  11    2:D     4                  1: (I: INTEGER);
  3779  11    2:D     4                  2: (P: ^INTEGER);
  3780  11    2:D     4                END;
  3781  11    2:D     5                      
  3782  11    2:0     0         BEGIN
  3783  11    2:1     0           CLRPICT( 0, 0, 0, 100);  (* CLEAR PICTURE *)
  3784  11    2:1     7           IF ENEMYID < 0 THEN
  3785  11    2:2    12             BEGIN
  3786  11    2:3    12               ENEMYID := 0;  (* NO MONSTER PICTURE (?) SO USE FIRST ONE *)
  3787  11    2:3    15               WRITE( CHR(7)) (*   AND RING THE BELL                     *)
  3788  11    2:2    23             END;
  3789  11    2:1    23           FOR PICLINE := 23 TO 72 DO
  3790  11    2:2    34             BEGIN
  3791  11    2:3    34               SCRNADDR.I := (8193 +  (1024 *  (PICLINE MOD 8))) +
  3792  11    2:3    45                             (128 * ((PICLINE MOD 64) DIV 8)) +
  3793  11    2:3    55                             40 * (PICLINE DIV 64);
  3794  11    2:3    63               MOVELEFT( IOCACHE[ ENEMYID], SCRNADDR.P^, 10);
  3795  11    2:3    72               ENEMYID := ENEMYID + 10    (* 10 BYTES === 70 PIXELS PER LINE *)
  3796  11    2:2    73             END;
  3797  11    2:0    84         END;
  3798  11    2:0    98         
  3799  11    2:0    98         
  3800  11    3:D     1       PROCEDURE SVREWARD;  (* P010503 *)
  3801  11    3:D     1       
  3802  11    3:D     1         VAR
  3803  11    3:D     1              BATRESLT : TBATRSLT;
  3804  11    3:D    15              UNUSEDX  : INTEGER;
  3805  11    3:D    16              X        : INTEGER;
  3806  11    3:D    17              
  3807  11    3:D    17              
  3808  11    3:0     0         BEGIN
  3809  11    3:1     0           FOR X := 0 TO PARTYCNT - 1 DO
  3810  11    3:2    14             IF (CHARACTR[ X].STATUS = ASLEEP) OR
  3811  11    3:2    23                (CHARACTR[ X].STATUS = AFRAID) THEN
  3812  11    3:3    35               CHARACTR[ X].STATUS := OK;
  3813  11    3:3    51               
  3814  11    3:1    51           MOVELEFT( IOCACHE[ GETREC( ZZERO, 0, SIZEOF( SCNTOC))],
  3815  11    3:1    64                     LLBASE04,
  3816  11    3:1    67                     2);
  3817  11    3:1    70           MOVELEFT( DRAINED, BATRESLT.DRAINED, 12);
  3818  11    3:1    80           FOR X := 1 TO 4 DO
  3819  11    3:2    92             BEGIN
  3820  11    3:3    92               BATRESLT.ENMYID[ X] := BATTLERC[ X].A.ENEMYID;
  3821  11    3:3   108               BATRESLT.ENMYCNT[ X] := BATTLERC[ X].A.ENMYCNT
  3822  11    3:2   122             END;
  3823  11    3:2   131             
  3824  11    3:1   131           MOVELEFT( BATRESLT, IOCACHE, SIZEOF( TBATRSLT))
  3825  11    3:0   141         END;
  3826  11    3:0   158         
  3827  11    3:0   158         
  3828  11    3:0   158         
  3829  11    4:D     1       PROCEDURE INITATTK;  (* P010504 *)
  3830  11    4:D     1       
  3831  11    4:D     1         VAR
  3832  11    4:D     1              UNUSEDWW : INTEGER;
  3833  11    4:D     2              UNUSEDXX : INTEGER;
  3834  11    4:D     3              UNUSEDYY : INTEGER;
  3835  11    4:D     4              UNUSEDZZ : INTEGER;
  3836  11    4:D     5              CHARX    : INTEGER;
  3837  11    4:D     6              GROUPI   : INTEGER;
  3838  11    4:D     7       
  3839  11    4:D     7       
  3840  11    5:D     1         PROCEDURE INITGRUP;  (* P010505 *)
  3841  11    5:D     1         
  3842  11    6:D     1           PROCEDURE ENGROUPS( ENMYI:    INTEGER;     (* P010506 *)
  3843  11    6:D     2                               ENMYGRUP: INTEGER);
  3844  11    6:D     3           
  3845  11    6:0     0             BEGIN
  3846  11    6:1     0               REPEAT
  3847  11    6:2     0                 MOVELEFT( IOCACHE[ GETREC( ZENEMY, ENMYI, SIZEOF( TENEMY))],
  3848  11    6:2    13                           BATTLERC[ ENMYGRUP].B,
  3849  11    6:2    23                           SIZEOF( TENEMY));
  3850  11    6:2    28                           
  3851  11    6:2    28                 IF BATTLERC[ ENMYGRUP].B.UNIQUE = 0 THEN
  3852  11    6:3    42                   ENMYI := BATTLERC[ ENMYGRUP].B.ENMYTEAM;
  3853  11    6:3    54                 
  3854  11    6:1    54               UNTIL BATTLERC[ ENMYGRUP].B.UNIQUE <> 0;
  3855  11    6:1    68               
  3856  11    6:1    68               BATTLERC[ ENMYGRUP].A.ENEMYID := ENMYI;
  3857  11    6:1    79               IF ENMYGRUP < 4 THEN
  3858  11    6:2    84                 IF BATTLERC[ ENMYGRUP].B.ENMYTEAM >= 0 THEN
  3859  11    6:3    98                   IF ENMYGRUP <= MAZELEV THEN
  3860  11    6:4   104                     IF RANDOM MOD 100 < BATTLERC[ ENMYGRUP].B.TEAMPERC THEN
  3861  11    6:5   124                       ENGROUPS( BATTLERC[ ENMYGRUP].B.ENMYTEAM, ENMYGRUP + 1)
  3862  11    6:0   137             END;
  3863  11    6:0   154             
  3864  11    6:0   154             
  3865  11    6:0   154             
  3866  11    7:D     3           FUNCTION ENEMYCNT( HPREC: THPREC) : INTEGER;  (* P010507 *)
  3867  11    7:D     7           
  3868  11    7:0     0             BEGIN
  3869  11    7:1     0               LLBASE04 := HPREC.HPMINAD;
  3870  11    7:1     8               WHILE HPREC.LEVEL > 0 DO
  3871  11    7:2    13                 BEGIN
  3872  11    7:3    13                   LLBASE04 := LLBASE04 + (RANDOM MOD HPREC.HPFAC) + 1;
  3873  11    7:3    26                   HPREC.LEVEL := HPREC.LEVEL - 1
  3874  11    7:2    27                 END;
  3875  11    7:1    33               ENEMYCNT := LLBASE04
  3876  11    7:0    33             END;
  3877  11    7:0    50             
  3878  11    7:0    50         
  3879  11    5:0     0           BEGIN (* INITGRUP *)
  3880  11    5:1     0             FOR GROUPI := 1 TO 4 DO
  3881  11    5:2    14               BEGIN
  3882  11    5:3    14                 BATTLERC[ GROUPI].A.ENMYCNT  := 0;
  3883  11    5:3    27                 BATTLERC[ GROUPI].A.ALIVECNT := 0;
  3884  11    5:3    40                 BATTLERC[ GROUPI].A.ENEMYID  := -1
  3885  11    5:2    51               END;
  3886  11    5:1    64             ENGROUPS( ENEMYINX, 1);
  3887  11    5:1    69             
  3888  11    5:1    69             ENEMYINX := BATTLERC[ 1].A.ENEMYID;
  3889  11    5:1    79             ENEMYPIC( GETREC( ZSPCCHRS, BATTLERC[ 1].B.PIC, 512));
  3890  11    5:1    99             
  3891  11    5:1    99             FOR GROUPI := 1 TO 4 DO
  3892  11    5:2   113               BEGIN
  3893  11    5:3   113                 IF BATTLERC[ GROUPI].A.ENEMYID <> -1 THEN
  3894  11    5:4   128                   BEGIN
  3895  11    5:5   128                     BATTLERC[ GROUPI].A.ENMYCNT := 
  3896  11    5:5   139                       ENEMYCNT( BATTLERC[ GROUPI].B.CALC1);
  3897  11    5:5   155                     IF BATTLERC[ GROUPI].A.ENMYCNT > (4 + MAZELEV) THEN
  3898  11    5:6   172                       BATTLERC[ GROUPI].A.ENMYCNT := 4 + MAZELEV;
  3899  11    5:5   188                     IF BATTLERC[ GROUPI].A.ENMYCNT > 9 THEN
  3900  11    5:6   202                       BATTLERC[ GROUPI].A.ENMYCNT := 9;
  3901  11    5:5   215                     IF BATTLERC[ GROUPI].A.ENMYCNT < 1 THEN
  3902  11    5:6   229                       BATTLERC[ GROUPI].A.ENMYCNT := 1;
  3903  11    5:5   242                     BATTLERC[ GROUPI].A.ALIVECNT :=
  3904  11    5:5   253                       BATTLERC[ GROUPI].A.ENMYCNT;
  3905  11    5:5   264                     BATTLERC[ GROUPI].A.IDENTIFI := FALSE;
  3906  11    5:5   275                     
  3907  11    5:5   275                     FOR CHARX := 0 TO (BATTLERC[ GROUPI].A.ENMYCNT - 1) DO
  3908  11    5:6   300                       WITH BATTLERC[ GROUPI].A.TEMP04[ CHARX] DO
  3909  11    5:7   318                         BEGIN
  3910  11    5:8   318                           ARMORCL  := 0;
  3911  11    5:8   323                           INAUDCNT := 0;
  3912  11    5:8   328                           HPLEFT   :=
  3913  11    5:8   331                                     ENEMYCNT( BATTLERC[ GROUPI].B.HPREC);
  3914  11    5:8   347                           STATUS   := OK
  3915  11    5:7   350                         END
  3916  11    5:4   352                   END
  3917  11    5:2   362                 END;
  3918  11    5:2   372                 
  3919  11    5:0   372           END;  (* INITGRUP *)
  3920  11    5:0   394         
  3921  11    5:0   394         
  3922  11    8:D     1         PROCEDURE INTPARTY;  (* P010508 *)
  3923  11    8:D     1         
  3924  11    8:0     0           BEGIN
  3925  11    8:1     0             BATTLERC[ 0].A.ENMYCNT := PARTYCNT;
  3926  11    8:1    11             BATTLERC[ 0].A.ALIVECNT := PARTYCNT;
  3927  11    8:1    22             FOR CHARX := 0 TO (PARTYCNT - 1) DO
  3928  11    8:2    38               BEGIN
  3929  11    8:3    38                 WITH BATTLERC[ 0].A.TEMP04[ CHARX] DO
  3930  11    8:4    54                   BEGIN
  3931  11    8:5    54                     ARMORCL  := 0;
  3932  11    8:5    59                     INAUDCNT := 0;
  3933  11    8:5    64                     HPLEFT   := CHARACTR[ CHARX].HPLEFT;
  3934  11    8:5    77                     STATUS   := CHARACTR[ CHARX].STATUS;
  3935  11    8:5    90                     CHARACTR[ CHARX].WEPVSTY3[ 1] :=
  3936  11    8:5   102                       CHARACTR[ CHARX].WEPVSTY3[ 0];
  3937  11    8:5   116                     CHARACTR[ CHARX].WEPVSTY2[ 1] :=
  3938  11    8:5   128                       CHARACTR[ CHARX].WEPVSTY2[ 0]
  3939  11    8:4   140                   END
  3940  11    8:2   142               END
  3941  11    8:0   142           END;
  3942  11    8:0   166           
  3943  11    8:0   166           
  3944  11    9:D     1         PROCEDURE FRIENDLY;  (* P010509 *)
  3945  11    9:D     1         
  3946  11    9:D     1           VAR
  3947  11    9:D     1               GOODLEAV : BOOLEAN; (* MULTIPLE USES *)
  3948  11    9:D     2               UNUSEDYY : BOOLEAN;
  3949  11    9:D     3               ZERO99   : INTEGER;
  3950  11    9:D     4               INDEX    : INTEGER;
  3951  11    9:D     5         
  3952  11    9:0     0           BEGIN (* FRIENDLY *)
  3953  11    9:1     0             GOODLEAV := FALSE;
  3954  11    9:1     3             FOR INDEX := 0 TO PARTYCNT - 1 DO
  3955  11    9:2    16               BEGIN
  3956  11    9:3    16                 GOODLEAV := GOODLEAV OR (CHARACTR[ INDEX].ALIGN = GOOD)
  3957  11    9:2    26               END;
  3958  11    9:1    36             IF NOT GOODLEAV THEN
  3959  11    9:2    40               EXIT( FRIENDLY);
  3960  11    9:2    44             
  3961  11    9:1    44             ZERO99  := RANDOM MOD 100;
  3962  11    9:1    53             INDEX := 50;
  3963  11    9:1    56             CASE BATTLERC[ 1].B.CLASS OF
  3964  11    9:1    67               0:  INDEX := 60;
  3965  11    9:1    72               1:  INDEX := 55;
  3966  11    9:1    77               2:  INDEX := 65;
  3967  11    9:1    82               3:  INDEX := 53;
  3968  11    9:1    87               4:  INDEX := 80;
  3969  11    9:1    92               
  3970  11    9:1    92               7:  INDEX := 75;
  3971  11    9:1    97             END;
  3972  11    9:1   120             IF (ZERO99 > INDEX) OR (ZERO99 < 50) THEN
  3973  11    9:2   129               EXIT( FRIENDLY);
  3974  11    9:2   133               
  3975  11    9:1   133             FOR INDEX := 1 TO 4 DO
  3976  11    9:2   144               BATTLERC[ INDEX].A.IDENTIFI := TRUE;
  3977  11    9:1   160             CLRRECT( 1, 11, 38, 4);
  3978  11    9:1   167             MVCURSOR( 1, 11);
  3979  11    9:1   172             PRINTSTR( 'A FRIENDLY GROUP OF ');
  3980  11    9:1   198             PRINTSTR( BATTLERC[ 1].B.NAMES);
  3981  11    9:1   210             PRINTSTR( '.');
  3982  11    9:1   214             MVCURSOR( 1, 12);
  3983  11    9:1   219             PRINTSTR( 'THEY HAIL YOU IN WELCOME!');
  3984  11    9:1   250             MVCURSOR( 1, 14);
  3985  11    9:1   255             PRINTSTR( 'YOU MAY F)IGHT OR L)EAVE IN PEACE.');
  3986  11    9:1   295             SURPRISE := 0;
  3987  11    9:1   299             REPEAT
  3988  11    9:2   299               GETKEY
  3989  11    9:1   299             UNTIL (INCHAR = 'F') OR (INCHAR = 'L');
  3990  11    9:1   311             IF INCHAR = 'L' THEN
  3991  11    9:2   316               BEGIN
  3992  11    9:3   316                 XGOTO := XRUNNER;
  3993  11    9:3   319                 EXIT( COMBAT)
  3994  11    9:2   323               END;
  3995  11    9:1   323             FOR INDEX := 0 TO PARTYCNT - 1 DO
  3996  11    9:2   336               IF CHARACTR[ INDEX].ALIGN = GOOD THEN
  3997  11    9:3   347                 IF (RANDOM MOD 2000) = 565 THEN
  3998  11    9:4   362                   CHARACTR[ INDEX].ALIGN := EVIL
  3999  11    9:0   369           END;  (* FRIENDLY *)
  4000  11    9:0   398         
  4001  11    9:0   398         
  4002  11    4:0     0         BEGIN  (* INITATTK *)
  4003  11    4:1     0           CLRRECT( 13, 1, 26, 4);
  4004  11    4:1     7           CLRRECT( 13, 6, 26, 4);
  4005  11    4:1    14           CLRRECT( 1, 11, 38, 4);
  4006  11    4:1    21           INITGRUP;
  4007  11    4:1    23           INTPARTY;
  4008  11    4:1    25           FILLCHAR( DRAINED, 12, 0);
  4009  11    4:1    33           FOR LLBASE04 := 0 TO PARTYCNT - 1 DO
  4010  11    4:2    46             PREBATOR[ LLBASE04] := CHARDISK[ LLBASE04];
  4011  11    4:1    66           IF (RANDOM MOD 100) > 80 THEN
  4012  11    4:2    77             SURPRISE := 1
  4013  11    4:1    77           ELSE IF (RANDOM MOD 100) > 80 THEN
  4014  11    4:3    94             SURPRISE := 2
  4015  11    4:2    94           ELSE
  4016  11    4:3   100             SURPRISE := 0;
  4017  11    4:1   104           FRIENDLY
  4018  11    4:0   104         END;  (* INITATTK *)
  4019  11    4:0   120         
  4020  11    4:0   120       
  4021  11    1:0     0       BEGIN (* CINIT *)
  4022  11    1:1     0         IF CINITFL1 = 0 THEN
  4023  11    1:2     7           INITATTK
  4024  11    1:1     7         ELSE
  4025  11    1:2    11           SVREWARD
  4026  11    1:0    11       END;  (* CINIT *)
  4027  11    1:0    26   
  4028  11    1:0    26 (*$I WIZ1B:COMBAT    *)
  4028  11    1:0    26 (*$I WIZ1B:COMBAT2   *)
  4029  12    1:D     1     SEGMENT PROCEDURE CUTIL;
  4030  12    1:D     1 
  4031  12    1:D     1 
  4032  12    2:D     1       PROCEDURE CACTION;  (* P010602 *)
  4033  12    2:D     1       
  4034  12    2:D     1         VAR
  4035  12    2:D     1              SPLGRCNT : ARRAY[ 0..5] OF INTEGER;
  4036  12    2:D     7              BDISPELL : BOOLEAN;
  4037  12    2:D     8              MYCHARX  : INTEGER;
  4038  12    2:D     9              AGIL1TEN : INTEGER;
  4039  12    2:D    10              
  4040  12    2:D    10           
  4041  12    3:D     1         PROCEDURE WHICHGRP( SOLICIT:   STRING;   (* P010603 *)
  4042  12    3:D     2                             SPELLHSH:  INTEGER);
  4043  12    3:D    44                             
  4044  12    3:D    44         
  4045  12    3:0     0           BEGIN
  4046  12    3:1     0             IF BATTLERC[ 2].A.ALIVECNT = 0 THEN
  4047  12    3:2    17               BEGIN
  4048  12    3:3    17                 BATTLERC[ 0].A.TEMP04[ MYCHARX].VICTIM := 1;
  4049  12    3:3    33                 BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := SPELLHSH;
  4050  12    3:3    51                 EXIT( WHICHGRP)
  4051  12    3:2    55               END;
  4052  12    3:1    55             MVCURSOR( 26 - ( LENGTH( SOLICIT) DIV 2), 8);
  4053  12    3:1    67             PRINTSTR( SOLICIT);
  4054  12    3:1    72             REPEAT
  4055  12    3:2    72               GETKEY
  4056  12    3:1    72             UNTIL ((INCHAR >= '1') AND (INCHAR < '5')) OR
  4057  12    3:1    82                    (INCHAR = CHR( CRETURN));
  4058  12    3:1    88             IF INCHAR = CHR( CRETURN) THEN
  4059  12    3:2    93               BEGIN
  4060  12    3:3    93                 BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := -999;
  4061  12    3:3   114                 EXIT( WHICHGRP)
  4062  12    3:2   118               END;
  4063  12    3:1   118             IF BATTLERC[ ORD( INCHAR) - ORD( '0')].A.ALIVECNT = 0 THEN
  4064  12    3:2   132               BEGIN
  4065  12    3:3   132                 BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := -999;
  4066  12    3:3   153                 EXIT( WHICHGRP)
  4067  12    3:2   157               END;
  4068  12    3:1   157             BATTLERC[ 0].A.TEMP04[ MYCHARX].VICTIM := ORD( INCHAR) - ORD( '0');
  4069  12    3:1   175             BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := SPELLHSH;
  4070  12    3:1   193             CLRRECT( 13, 8, 26, 2)
  4071  12    3:0   197           END;
  4072  12    3:0   214           
  4073  12    3:0   214           
  4074  12    4:D     1         PROCEDURE USEITEM;  (* P010604 *)
  4075  12    4:D     1         
  4076  12    4:D     1           VAR
  4077  12    4:D     1                BUSEABLE : ARRAY[ 1..8] OF BOOLEAN;
  4078  12    4:D     9                POSSX    : INTEGER;
  4079  12    4:D    10                OBJECT   : TOBJREC;
  4080  12    4:D    49         
  4081  12    4:D    49         
  4082  12    5:D     1           PROCEDURE READOBJT;  (* P010605 *)
  4083  12    5:D     1           
  4084  12    5:0     0             BEGIN
  4085  12    5:1     0               MOVELEFT( 
  4086  12    5:1     0                 IOCACHE[ GETREC(
  4087  12    5:1     3                         ZOBJECT,
  4088  12    5:1     4                         CHARACTR[ MYCHARX].POSS.POSSESS[ POSSX].EQINDEX,
  4089  12    5:1    21                         SIZEOF( TOBJREC))],
  4090  12    5:1    27                 OBJECT,
  4091  12    5:1    31                 SIZEOF( TOBJREC))
  4092  12    5:0    34             END;
  4093  12    5:0    46             
  4094  12    5:0    46             
  4095  12    6:D     1           PROCEDURE DSPITEMS;  (* P010606 *)
  4096  12    6:D     1           
  4097  12    6:D     1             VAR
  4098  12    6:D     1                  ITEMCNT : INTEGER;
  4099  12    6:D     2           
  4100  12    6:0     0             BEGIN
  4101  12    6:1     0               CLRRECT( 1, 11, 38, 4);
  4102  12    6:1     7               ITEMCNT := 0;
  4103  12    6:1    10               FOR POSSX := 1 TO CHARACTR[ MYCHARX].POSS.POSSCNT DO
  4104  12    6:2    32                 BEGIN
  4105  12    6:3    32                   BUSEABLE[ POSSX] := FALSE;
  4106  12    6:3    44                   MVCURSOR( 1 + 19 * ((POSSX - 1) MOD 2),
  4107  12    6:3    55                            11 + (POSSX - 1) DIV 2);
  4108  12    6:3    67                   READOBJT;
  4109  12    6:3    69                   IF OBJECT.SPELLPWR > 0 THEN
  4110  12    6:4    76                     IF (OBJECT.OBJTYPE = SPECIAL) OR
  4111  12    6:4    81                        (CHARACTR[ MYCHARX].POSS.POSSESS[ POSSX].EQUIPED) THEN
  4112  12    6:5   101                       BEGIN
  4113  12    6:6   101                         ITEMCNT := ITEMCNT + 1;
  4114  12    6:6   106                         BUSEABLE[ POSSX] := TRUE;
  4115  12    6:6   118                         PRINTNUM( POSSX, 1);
  4116  12    6:6   125                         PRINTSTR( ') ');
  4117  12    6:6   133                         IF CHARACTR[ MYCHARX].POSS.POSSESS[ POSSX].IDENTIF THEN
  4118  12    6:7   152                           PRINTSTR( OBJECT.NAME)
  4119  12    6:6   155                         ELSE
  4120  12    6:7   160                           PRINTSTR( OBJECT.NAMEUNK)
  4121  12    6:5   163                       END
  4122  12    6:2   166                 END;
  4123  12    6:1   176               IF ITEMCNT = 0 THEN
  4124  12    6:2   181                 EXIT( USEITEM);
  4125  12    6:1   185               MVCURSOR( 13, 8);
  4126  12    6:1   190               PRINTSTR( 'WHICH ITEM (RETURN EXITS)?')
  4127  12    6:0   219             END;
  4128  12    6:0   238             
  4129  12    6:0   238             
  4130  12    7:D     1           PROCEDURE CHGITEM;  (* P010607 *)
  4131  12    7:D     1           
  4132  12    7:0     0             BEGIN
  4133  12    7:1     0               IF (RANDOM MOD 100) >= OBJECT.CHGCHANC THEN
  4134  12    7:2    13                 EXIT( CHGITEM);
  4135  12    7:1    17               WITH CHARACTR[ MYCHARX].POSS.POSSESS[ POSSX] DO
  4136  12    7:2    35                 BEGIN
  4137  12    7:3    35                   EQINDEX := OBJECT.CHANGETO;
  4138  12    7:3    42                   IDENTIF := FALSE
  4139  12    7:2    45                 END;
  4140  12    7:0    47             END;
  4141  12    7:0    60             
  4142  12    7:0    60             
  4143  12    8:D     1           PROCEDURE UIGENERC( SPELLHSH: INTEGER);  (* P010608 *)
  4144  12    8:D     2           
  4145  12    8:0     0             BEGIN
  4146  12    8:1     0               BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := SPELLHSH;
  4147  12    8:1    18               BATTLERC[ 0].A.TEMP04[ MYCHARX].VICTIM := -1;
  4148  12    8:1    35               CHGITEM
  4149  12    8:0    35             END;
  4150  12    8:0    50             
  4151  12    8:0    50             
  4152  12    9:D     1           PROCEDURE UIPERSON( SPELLHSH: INTEGER);  (* P010609 *)
  4153  12    9:D     2           
  4154  12    9:0     0             BEGIN
  4155  12    9:1     0               MVCURSOR( 15, 8);
  4156  12    9:1     5               PRINTSTR( 'USE ITEM ON PERSON # ?');
  4157  12    9:1    33               REPEAT
  4158  12    9:2    33                 GETKEY
  4159  12    9:1    33               UNTIL (INCHAR >= '1') AND (INCHAR <= CHR( ORD('0') + PARTYCNT));
  4160  12    9:1    47               BATTLERC[ 0].A.TEMP04[ MYCHARX].VICTIM :=
  4161  12    9:1    61                  ORD( INCHAR) - ORD('0') - 1;
  4162  12    9:1    67               BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := SPELLHSH;
  4163  12    9:1    85               CHGITEM
  4164  12    9:0    85             END;
  4165  12    9:0   102             
  4166  12    9:0   102             
  4167  12   10:D     1           PROCEDURE UIGROUP( SPELLHSH : INTEGER);  (* P01060A *)
  4168  12   10:D     2           
  4169  12   10:0     0             BEGIN
  4170  12   10:1     0               WHICHGRP( 'USE ITEM ON WHAT GROUP # ?', SPELLHSH);
  4171  12   10:1    32               CHGITEM
  4172  12   10:0    32             END;
  4173  12   10:0    46             
  4174  12   10:0    46             
  4175  12    4:0     0           BEGIN (* USEITEM *)
  4176  12    4:1     0             IF CHARACTR[ MYCHARX].POSS.POSSCNT = 0 THEN
  4177  12    4:2    13               EXIT( USEITEM);
  4178  12    4:1    17             DSPITEMS;
  4179  12    4:1    19             
  4180  12    4:1    19             REPEAT
  4181  12    4:2    19               GETKEY;
  4182  12    4:2    22               POSSX := ORD( INCHAR) - ORD( '0');
  4183  12    4:2    27               IF INCHAR = CHR( CRETURN) THEN
  4184  12    4:3    32                 EXIT( USEITEM)
  4185  12    4:1    36             UNTIL (POSSX > 0) AND
  4186  12    4:1    39                   (POSSX <= CHARACTR[ MYCHARX].POSS.POSSCNT) AND
  4187  12    4:1    51                   (BUSEABLE[ POSSX]);
  4188  12    4:1    62             READOBJT;
  4189  12    4:1    64             CLRRECT( 13, 6, 26, 4);
  4190  12    4:1    71             LLBASE04 := SCNTOC.SPELLHSH[ OBJECT.SPELLPWR];
  4191  12    4:1    81             CASE SCNTOC.SPELL012[ OBJECT.SPELLPWR] OF
  4192  12    4:1    92               GENERIC:  UIGENERC( LLBASE04);
  4193  12    4:1    97                PERSON:  UIPERSON( LLBASE04);
  4194  12    4:1   102                 GROUP:  UIGROUP(  LLBASE04);
  4195  12    4:1   107             END
  4196  12    4:0   120           END; (* USEITEM *)
  4197  12    4:0   134           
  4198  12    4:0   134           
  4199  12   11:D     1         PROCEDURE GETSPELL;  (* P01060B *)
  4200  12   11:D     1         
  4201  12   11:D     1           VAR
  4202  12   11:D     1               SPELLNAM : STRING[ 14];
  4203  12   11:D     9               SPELLCST : INTEGER;
  4204  12   11:D    10               SPELNAML : INTEGER;
  4205  12   11:D    11               SPELCHRA : INTEGER;
  4206  12   11:D    12               SPELNAMI : INTEGER;
  4207  12   11:D    13         
  4208  12   11:D    13         
  4209  12   12:D     1           PROCEDURE DOSPELL;  (* P01060C *)
  4210  12   12:D     1           
  4211  12   12:D     1             VAR
  4212  12   12:D     1                  SPELLX : INTEGER;
  4213  12   12:D     2                  
  4214  12   12:D     2                  
  4215  12   13:D     1             PROCEDURE CASTCHK( SPELLI:  INTEGER;  (* P01060D *)
  4216  12   13:D     2                                SPELLGR: INTEGER);
  4217  12   13:D     3             
  4218  12   13:0     0               BEGIN
  4219  12   13:1     0                 IF CHARACTR[ MYCHARX].SPELLSKN[ SPELLI] THEN
  4220  12   13:2    16                   IF (SPELLI < 22) AND 
  4221  12   13:2    19                      (CHARACTR[ MYCHARX].MAGESP[ SPELLGR] > 0) THEN
  4222  12   13:3    39                        SPLGRCNT[ MYCHARX] := SPELLGR
  4223  12   13:2    47                   ELSE
  4224  12   13:3    51                       IF CHARACTR[ MYCHARX].PRIESTSP[ SPELLGR] > 0 THEN
  4225  12   13:4    70                           SPLGRCNT[ MYCHARX] := SPELLGR + 10;
  4226  12   13:4    82               
  4227  12   13:1    82                 MVCURSOR( 13, 9);
  4228  12   13:1    87                 IF SPLGRCNT[ MYCHARX] > 0 THEN
  4229  12   13:2   100                   EXIT( CASTCHK)
  4230  12   13:1   104                 ELSE
  4231  12   13:2   106                   IF CHARACTR[ MYCHARX].SPELLSKN[ SPELLI] THEN
  4232  12   13:3   122                     PRINTSTR( 'SPELL POINTS EXHAUSTED')
  4233  12   13:2   147                   ELSE
  4234  12   13:3   152                     PRINTSTR( 'YOU DONT KNOW THAT SPELL');
  4235  12   13:1   182                 PAUSE1;
  4236  12   13:1   185                 EXIT( GETSPELL)
  4237  12   13:0   189               END;
  4238  12   13:0   202               
  4239  12   13:0   202               
  4240  12   14:D     1             PROCEDURE SPGENERC( SPELLI:  INTEGER;  (* P01060E *)
  4241  12   14:D     2                                 SPELLGR: INTEGER);
  4242  12   14:D     3             
  4243  12   14:0     0               BEGIN
  4244  12   14:1     0                 CASTCHK( SPELLI, SPELLGR);
  4245  12   14:1     4                 BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := SPELLCST;
  4246  12   14:1    24                 BATTLERC[ 0].A.TEMP04[ MYCHARX].VICTIM := -1
  4247  12   14:0    38               END;
  4248  12   14:0    54               
  4249  12   14:0    54               
  4250  12   15:D     1             PROCEDURE SPPERSON( SPELLI:  INTEGER;  (* P01060F *)
  4251  12   15:D     2                                 SPELLGR: INTEGER);
  4252  12   15:D     3             
  4253  12   15:0     0               BEGIN
  4254  12   15:1     0                 CASTCHK( SPELLI, SPELLGR);
  4255  12   15:1     4                 MVCURSOR( 13, 8);
  4256  12   15:1     9                 PRINTSTR( ' CAST SPELL ON PERSON # ?');
  4257  12   15:1    40                 REPEAT
  4258  12   15:2    40                   GETKEY
  4259  12   15:1    40                 UNTIL (INCHAR >=  '1') AND
  4260  12   15:1    46                       (ORD (INCHAR) <= ( (ORD('0') + PARTYCNT) ));
  4261  12   15:1    54                 BATTLERC[ 0].A.TEMP04[ MYCHARX].VICTIM := 
  4262  12   15:1    68                   ORD( INCHAR) - ORD( '0') - 1;
  4263  12   15:1    74                 BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := SPELLCST;
  4264  12   15:1    94                 CLRRECT( 13, 8, 26, 1)
  4265  12   15:0    98               END;
  4266  12   15:0   116               
  4267  12   15:0   116               
  4268  12   16:D     1             PROCEDURE SPGROUP( SPELLI:  INTEGER;  (* P010610 *)
  4269  12   16:D     2                                SPELLGR: INTEGER);
  4270  12   16:D     3             
  4271  12   16:0     0               BEGIN
  4272  12   16:1     0                 CASTCHK( SPELLI, SPELLGR);
  4273  12   16:1     4                 WHICHGRP( 'CAST SPELL ON GROUP #?', SPELLCST)
  4274  12   16:0    32               END;
  4275  12   16:0    46               
  4276  12   16:0    46               
  4277  12   12:0     0             BEGIN (* DOSPELL *)
  4278  12   12:1     0               FOR SPELLX := 0 TO 50 DO
  4279  12   12:2    11                 IF SPELLCST = SCNTOC.SPELLHSH[ SPELLX] THEN
  4280  12   12:3    24                   CASE SCNTOC.SPELL012[ SPELLX] OF
  4281  12   12:3    34                     GENERIC:  SPGENERC( SPELLX, SCNTOC.SPELLGRP[ SPELLX]);
  4282  12   12:3    47                      PERSON:  SPPERSON( SPELLX, SCNTOC.SPELLGRP[ SPELLX]);
  4283  12   12:3    60                       GROUP:  SPGROUP(  SPELLX, SCNTOC.SPELLGRP[ SPELLX]);
  4284  12   12:3    73                   END
  4285  12   12:0    86             END;  (* DOSPELL *)
  4286  12   12:0   108             
  4287  12   12:0   108             
  4288  12   11:0     0           BEGIN  (* GETSPELL *)
  4289  12   11:1     0             MVCURSOR( 13, 8);
  4290  12   11:1     5             PRINTSTR( 'SPELL NAME ? >');
  4291  12   11:1    25             GETSTR( SPELLNAM, 27, 8);
  4292  12   11:1    32             SPELNAML := LENGTH( SPELLNAM);
  4293  12   11:1    38             IF SPELNAML = 0 THEN
  4294  12   11:2    43               EXIT( GETSPELL);
  4295  12   11:1    47             SPELLCST := SPELNAML;
  4296  12   11:1    50             FOR SPELNAMI := 1 TO SPELNAML DO
  4297  12   11:2    61               BEGIN
  4298  12   11:3    61                 SPELCHRA := ORD( SPELLNAM[ SPELNAMI]) - 64;
  4299  12   11:3    69                 SPELLCST := SPELLCST + (SPELCHRA * SPELCHRA * SPELNAMI)
  4300  12   11:2    75               END;
  4301  12   11:1    85             CLRRECT( 13, 8, 26, 1);
  4302  12   11:1    92             DOSPELL
  4303  12   11:0    92           END; (* GETSPELL *)
  4304  12   11:0   108           
  4305  12   11:0   108           
  4306  12   17:D     1         PROCEDURE RUNAWAY;  (* P010611 *)
  4307  12   17:D     1         
  4308  12   17:D     1           VAR
  4309  12   17:D     1                TEMP : INTEGER;  (* MULTIPLE USES *)
  4310  12   17:D     2         
  4311  12   17:D     2         
  4312  12   18:D     1           PROCEDURE RUNFAILD;  (* P010612 *)
  4313  12   18:D     1           
  4314  12   18:0     0             BEGIN
  4315  12   18:1     0               FOR TEMP := 0 TO PARTYCNT - 1 DO
  4316  12   18:2    16                 BATTLERC[ 0].A.TEMP04[ TEMP].AGILITY := -1;
  4317  12   18:1    45               EXIT( CACTION)
  4318  12   18:0    49             END;
  4319  12   18:0    64             
  4320  12   18:0    64             
  4321  12   17:0     0           BEGIN (* RUNAWAY *)
  4322  12   17:1     0             CLRRECT( 13, 6, 26, 4);
  4323  12   17:1     7             TEMP := 38 - 3 * MAZELEV;
  4324  12   17:1    15             IF PARTYCNT < 4 THEN
  4325  12   17:2    20               TEMP := TEMP + 20 - 5 * PARTYCNT;
  4326  12   17:1    29             IF BASE12.MYSTRENG > ENSTRENG THEN
  4327  12   17:2    36               TEMP := TEMP + 20;
  4328  12   17:1    41             IF MAZELEV = 10 THEN
  4329  12   17:2    47               TEMP := -1;
  4330  12   17:1    51             IF (RANDOM MOD 100) > TEMP THEN
  4331  12   17:2    62               RUNFAILD;
  4332  12   17:1    64             FOR TEMP := 1 TO 4 DO
  4333  12   17:2    75               BEGIN
  4334  12   17:3    75                 BATTLERC[ TEMP].A.ALIVECNT := 0;
  4335  12   17:3    86                 BATTLERC[ TEMP].A.ENMYCNT := 0
  4336  12   17:2    95               END;
  4337  12   17:1   104             XGOTO := XREWARD2;
  4338  12   17:1   107             DONEFIGH := TRUE;
  4339  12   17:1   111             EXIT( CUTIL)
  4340  12   17:0   115           END; (* RUNAWAY *)
  4341  12   17:0   130         
  4342  12   17:0   130         
  4343  12   19:D     1         PROCEDURE DOSUPRIS;  (* P010613 *)
  4344  12   19:D     1         
  4345  12   19:0     0           BEGIN
  4346  12   19:1     0             CLRRECT( 13, 6, 26, 4);
  4347  12   19:1     7             CLRRECT( 1, 11, 38, 4);
  4348  12   19:1    14             MVCURSOR( 1, 12);
  4349  12   19:1    19           
  4350  12   19:1    19             IF SURPRISE = 1 THEN
  4351  12   19:2    26               PRINTSTR( 'YOU SURPRISED THE MONSTERS!')
  4352  12   19:1    56             ELSE
  4353  12   19:2    61               IF SURPRISE = 2 THEN
  4354  12   19:3    68                 PRINTSTR( 'THE MONSTERS SURPRISED YOU!');
  4355  12   19:1   101             IF SURPRISE <> 0 THEN
  4356  12   19:2   108               BEGIN
  4357  12   19:3   108                 WRITE( CHR( 7));
  4358  12   19:3   116                 WRITE( CHR( 7));
  4359  12   19:3   124                 WRITE( CHR( 7));
  4360  12   19:3   132                 PAUSE2;
  4361  12   19:3   135                 PAUSE2
  4362  12   19:2   135               END
  4363  12   19:0   138           END;
  4364  12   19:0   150           
  4365  12   19:0   150           
  4366  12    2:0     0         BEGIN (* CACTION *)
  4367  12    2:1     0           DOSUPRIS;
  4368  12    2:1     2           MYCHARX := 0;
  4369  12    2:1     5           FILLCHAR( SPLGRCNT, 12, 0);
  4370  12    2:1    12           WHILE MYCHARX < PARTYCNT DO
  4371  12    2:2    17             BEGIN
  4372  12    2:3    17               REPEAT
  4373  12    2:3    17             
  4374  12    2:4    17                 IF (BATTLERC[ 0].A.TEMP04[ MYCHARX].STATUS = OK) AND
  4375  12    2:4    32                    (SURPRISE <> 2) THEN
  4376  12    2:5    40                   BEGIN
  4377  12    2:6    40                     BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := -999;
  4378  12    2:6    59                     REPEAT
  4379  12    2:7    59                       AGIL1TEN := RANDOM MOD 10;
  4380  12    2:7    68                       CASE CHARACTR[ MYCHARX].ATTRIB[ AGILITY] OF
  4381  12    2:7    82                           3:  AGIL1TEN := AGIL1TEN + 3;
  4382  12    2:7    89                         4,5:  AGIL1TEN := AGIL1TEN + 2;
  4383  12    2:7    96                         6,7:  AGIL1TEN := AGIL1TEN + 1;
  4384  12    2:7   103                          15:  AGIL1TEN := AGIL1TEN - 1;
  4385  12    2:7   110                          16:  AGIL1TEN := AGIL1TEN - 2;
  4386  12    2:7   117                          17:  AGIL1TEN := AGIL1TEN - 3;
  4387  12    2:7   124                          18:  AGIL1TEN := AGIL1TEN - 4;
  4388  12    2:7   131                       END;
  4389  12    2:7   170                       IF AGIL1TEN < 1 THEN
  4390  12    2:8   175                         AGIL1TEN := 1
  4391  12    2:7   175                       ELSE
  4392  12    2:8   180                         IF AGIL1TEN > 10 THEN
  4393  12    2:9   185                           AGIL1TEN := 10;
  4394  12    2:7   188                       BATTLERC[ 0].A.TEMP04[ MYCHARX].AGILITY := AGIL1TEN;
  4395  12    2:7   204                       UNITCLEAR( 1);
  4396  12    2:7   207                       MVCURSOR( 13, 6);
  4397  12    2:7   212                       PRINTSTR( CHARACTR[ MYCHARX].NAME);
  4398  12    2:7   220                       PRINTSTR( '''S OPTIONS');
  4399  12    2:7   236                       MVCURSOR( 13, 8);
  4400  12    2:7   241                       IF MYCHARX < 3 THEN
  4401  12    2:8   246                         BEGIN
  4402  12    2:9   246                           PRINTSTR( 'F)IGHT  ')
  4403  12    2:8   257                         END;
  4404  12    2:7   260                       PRINTSTR( 'S)PELL  P)ARRY');
  4405  12    2:7   280                       MVCURSOR( 13, 9);
  4406  12    2:7   285                       PRINTSTR( 'R)UN    U)SE    ');
  4407  12    2:7   307                       BDISPELL := FALSE;
  4408  12    2:7   310                       IF (CHARACTR[ MYCHARX].CLASS = PRIEST)
  4409  12    2:7   319                          OR
  4410  12    2:7   319                          ((CHARACTR[ MYCHARX].CLASS = LORD) AND 
  4411  12    2:7   328                           (CHARACTR[ MYCHARX].CHARLEV > 8)) 
  4412  12    2:7   338                          OR
  4413  12    2:7   339                          ((CHARACTR[ MYCHARX].CLASS = BISHOP) AND
  4414  12    2:7   348                           (CHARACTR[ MYCHARX].CHARLEV > 3)) THEN
  4415  12    2:7   361                           
  4416  12    2:8   361                           BEGIN
  4417  12    2:9   361                             BDISPELL := TRUE;
  4418  12    2:9   364                             PRINTSTR( 'D)ISPELL ')
  4419  12    2:8   376                           END;
  4420  12    2:8   379                           
  4421  12    2:7   379                       REPEAT
  4422  12    2:8   379                         GETKEY
  4423  12    2:7   379                       UNTIL (INCHAR = 'F') OR (INCHAR = 'S') OR
  4424  12    2:7   389                             (INCHAR = 'P') OR (INCHAR = 'U') OR
  4425  12    2:7   397                             (INCHAR = 'D') OR (INCHAR = 'R') OR
  4426  12    2:7   405                             (INCHAR = 'B');
  4427  12    2:7   411                             
  4428  12    2:7   411                       CLRRECT( 13, 8, 26, 2);
  4429  12    2:7   418                       SPLGRCNT[ MYCHARX] := 0;
  4430  12    2:7   425                           
  4431  12    2:7   425                       CASE INCHAR OF
  4432  12    2:7   428                       
  4433  12    2:7   428                         'D':  IF BDISPELL THEN
  4434  12    2:9   431                                 WHICHGRP( 'DISPELL WHICH GROUP# ?', -5);
  4435  12    2:9   462                               
  4436  12    2:7   462                         'R':  RUNAWAY;
  4437  12    2:7   466                         
  4438  12    2:7   466                         'F':  IF MYCHARX < 3 THEN
  4439  12    2:9   471                                 WHICHGRP( 'FIGHT AGAINST GROUP# ?', -1);
  4440  12    2:9   502                               
  4441  12    2:7   502                         'P':  BEGIN
  4442  12    2:9   502                                  BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH := 0;
  4443  12    2:9   518                                  BATTLERC[ 0].A.TEMP04[ MYCHARX].AGILITY := -1;
  4444  12    2:8   535                               END;
  4445  12    2:8   537                               
  4446  12    2:7   537                         'S':  GETSPELL;
  4447  12    2:7   541                               
  4448  12    2:7   541                         'U':  BEGIN
  4449  12    2:9   541                                 USEITEM;
  4450  12    2:9   543                                 CLRRECT( 1, 11, 38, 4)
  4451  12    2:8   547                               END;
  4452  12    2:8   552                         
  4453  12    2:7   552                         'B':  IF MYCHARX > 0 THEN
  4454  12    2:9   557                                 BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH :=
  4455  12    2:9   571                                   -100;
  4456  12    2:7   576                       END;
  4457  12    2:7   624                       
  4458  12    2:7   624                     CLRRECT( 13, 6, 26, 4);
  4459  12    2:6   631                     UNTIL BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH <> -999;
  4460  12    2:6   651                     IF BATTLERC[ 0].A.TEMP04[ MYCHARX].SPELLHSH = -100 THEN
  4461  12    2:7   669                       MYCHARX := -1;
  4462  12    2:5   673                   END
  4463  12    2:4   673                 ELSE
  4464  12    2:5   675                   BATTLERC[ 0].A.TEMP04[ MYCHARX].AGILITY := -1;
  4465  12    2:5   692                   
  4466  12    2:4   692                 MYCHARX := MYCHARX + 1
  4467  12    2:4   693                   
  4468  12    2:3   693               UNTIL MYCHARX = PARTYCNT;
  4469  12    2:3   702               
  4470  12    2:3   702               IF SURPRISE <> 2 THEN
  4471  12    2:4   709                 BEGIN
  4472  12    2:5   709                   MVCURSOR( 14, 6);
  4473  12    2:5   714                   PRINTSTR( 'PRESS [RETURN] TO FIGHT,');
  4474  12    2:5   744                   MVCURSOR( 25, 7);
  4475  12    2:5   749                   PRINTSTR( 'OR');
  4476  12    2:5   757                   MVCURSOR( 14, 8);
  4477  12    2:5   762                   PRINTSTR( 'GO B)ACK TO REDO OPTIONS');
  4478  12    2:5   792                   
  4479  12    2:5   792                   REPEAT
  4480  12    2:6   792                     GETKEY
  4481  12    2:5   792                   UNTIL (INCHAR = CHR( CRETURN)) OR (INCHAR = 'B');
  4482  12    2:5   804                   
  4483  12    2:5   804                   IF INCHAR = 'B' THEN
  4484  12    2:6   809                     MYCHARX := 0
  4485  12    2:4   809                 END;
  4486  12    2:3   812                 CLRRECT( 13, 6, 26, 4);
  4487  12    2:3   819                 CLRRECT( 1, 11, 38, 4)
  4488  12    2:2   823             END; (* WHILE LOOP *)
  4489  12    2:2   828           
  4490  12    2:1   828           FOR MYCHARX := 0 TO PARTYCNT - 1 DO
  4491  12    2:2   841             BEGIN
  4492  12    2:3   841               IF SPLGRCNT[ MYCHARX] > 0 THEN
  4493  12    2:4   851                 BEGIN
  4494  12    2:5   851                   IF SPLGRCNT[ MYCHARX] > 10 THEN
  4495  12    2:6   861                    CHARACTR[ MYCHARX].PRIESTSP[ SPLGRCNT[ MYCHARX] - 10]
  4496  12    2:6   880                    := CHARACTR[ MYCHARX].PRIESTSP[ SPLGRCNT[ MYCHARX] - 10] - 1
  4497  12    2:5   900                   ELSE
  4498  12    2:6   905                    CHARACTR[ MYCHARX].MAGESP[ SPLGRCNT[ MYCHARX]]
  4499  12    2:6   922                    := CHARACTR[ MYCHARX].MAGESP[ SPLGRCNT[ MYCHARX]] - 1
  4500  12    2:4   940                 END
  4501  12    2:2   943             END;
  4502  12    2:0   950         END;  (* CACTION *)
  4503  12    2:0   982         
  4504  12    2:0   982 
  4505  12   20:D     1       PROCEDURE ENATTACK;  (* P010614 *)
  4506  12   20:D     1       
  4507  12   20:D     1         VAR
  4508  12   20:D     1             UNUSEDXX : INTEGER;
  4509  12   20:D     2             ATTCKTYP : INTEGER;
  4510  12   20:D     3             CHARX    : INTEGER;
  4511  12   20:D     4             ENEMYX   : INTEGER;
  4512  12   20:D     5             GROUPI   : INTEGER;
  4513  12   20:D     6       
  4514  12   20:D     6       
  4515  12   21:D     3         FUNCTION CANATTCK : BOOLEAN;  (* P010615 *)
  4516  12   21:D     3         
  4517  12   21:0     0           BEGIN
  4518  12   21:1     0             CANATTCK :=
  4519  12   21:1     0              (NOT CHARACTR[ CHARX].WEPVSTY2[ 1][ BATTLERC[ GROUPI].B.CLASS])
  4520  12   21:1    28                OR
  4521  12   21:1    28              ((RANDOM MOD 100) < 50)
  4522  12   21:0    37           END;
  4523  12   21:0    52           
  4524  12   21:0    52           
  4525  12   22:D     1         PROCEDURE ENEMYSPL;  (* P010616 *)
  4526  12   22:D     1         
  4527  12   22:D     1         
  4528  12   23:D     1           PROCEDURE SPELLEZR( VAR SPELLGR: INTEGER);  (* P010617 *)
  4529  12   23:D     2           
  4530  12   23:0     0             BEGIN
  4531  12   23:1     0               IF RANDOM MOD (BATTLERC[ GROUPI].A.ALIVECNT + 2) = 0 THEN
  4532  12   23:2    22                 SPELLGR := SPELLGR - 1
  4533  12   23:0    25             END;
  4534  12   23:0    40             
  4535  12   23:0    40             
  4536  12   24:D     1           PROCEDURE GETMAGSP( SPELLLEV: INTEGER);  (* P010618 *)
  4537  12   24:D     2           
  4538  12   24:D     2             VAR
  4539  12   24:D     2                  SPELLCAS : INTEGER;
  4540  12   24:D     3                  TWOTHIRD : BOOLEAN;
  4541  12   24:D     4           
  4542  12   24:0     0             BEGIN
  4543  12   24:1     0               WHILE (SPELLLEV > 1) AND ( (RANDOM MOD 100) > 70) DO
  4544  12   24:2    15                 SPELLLEV := SPELLLEV - 1;
  4545  12   24:1    22               TWOTHIRD := (RANDOM MOD 100) > 33;
  4546  12   24:1    33               SPELLEZR( BATTLERC[ GROUPI].B.MAGSPELS);
  4547  12   24:1    47               
  4548  12   24:1    47               CASE SPELLLEV OF
  4549  12   24:1    50               
  4550  12   24:1    50                 1:  IF TWOTHIRD THEN
  4551  12   24:3    53                       SPELLCAS := KATINO
  4552  12   24:2    53                     ELSE
  4553  12   24:3    60                       SPELLCAS := HALITO;
  4554  12   24:3    67                       
  4555  12   24:1    67                 2:  IF TWOTHIRD THEN
  4556  12   24:3    70                       SPELLCAS := DILTO
  4557  12   24:2    70                     ELSE
  4558  12   24:3    77                       SPELLCAS := HALITO;  (* BUG *)
  4559  12   24:3    84                       
  4560  12   24:1    84                 3:  IF TWOTHIRD THEN
  4561  12   24:3    87                       SPELLCAS := MOLITO
  4562  12   24:2    87                     ELSE
  4563  12   24:3    94                       SPELLCAS := MAHALITO;
  4564  12   24:3   101                       
  4565  12   24:1   101                 4:  IF TWOTHIRD THEN
  4566  12   24:3   104                       SPELLCAS := DALTO
  4567  12   24:2   104                     ELSE
  4568  12   24:3   111                       SPELLCAS := LAHALITO;  (* ...HMMM *)
  4569  12   24:3   118                       
  4570  12   24:1   118                 5:  IF TWOTHIRD THEN
  4571  12   24:3   121                       SPELLCAS := LAHALITO   (* ...HMMM *)
  4572  12   24:2   121                     ELSE
  4573  12   24:3   128                       SPELLCAS := MADALTO;
  4574  12   24:3   135                       
  4575  12   24:1   135                 6:  IF TWOTHIRD THEN
  4576  12   24:3   138                       SPELLCAS := MADALTO    (* ...HMMM *)
  4577  12   24:2   138                     ELSE
  4578  12   24:3   145                       SPELLCAS := ZILWAN;
  4579  12   24:3   152                       
  4580  12   24:1   152                 7:  SPELLCAS := TILTOWAI;
  4581  12   24:1   159               END;
  4582  12   24:1   180               
  4583  12   24:1   180               ATTCKTYP := SPELLCAS
  4584  12   24:0   180             END;  (* GETMAGSP *)
  4585  12   24:0   198             
  4586  12   24:0   198             
  4587  12   25:D     1           PROCEDURE GETPRISP( SPELLLEV : INTEGER);  (* P010619 *)
  4588  12   25:D     2           
  4589  12   25:D     2             VAR
  4590  12   25:D     2                  SPELLCAS : INTEGER;
  4591  12   25:D     3                  TWOTHIRD : BOOLEAN;
  4592  12   25:D     4                  
  4593  12   25:0     0             BEGIN
  4594  12   25:1     0               TWOTHIRD := (RANDOM MOD 100) > 33;
  4595  12   25:1    11               SPELLEZR( BATTLERC[ GROUPI].B.PRISPELS);
  4596  12   25:1    25               
  4597  12   25:1    25               CASE SPELLLEV OF
  4598  12   25:1    28               
  4599  12   25:1    28                 1:  SPELLCAS := BADIOS;
  4600  12   25:1    35                 
  4601  12   25:1    35                 2:  SPELLCAS := MONTINO;
  4602  12   25:1    42                 
  4603  12   25:1    42                 3:  IF TWOTHIRD THEN
  4604  12   25:3    45                       SPELLCAS := BADIOS
  4605  12   25:2    45                     ELSE
  4606  12   25:3    52                       SPELLCAS := BADIAL;
  4607  12   25:3    59                       
  4608  12   25:1    59                 4:  SPELLCAS := BADIAL;
  4609  12   25:1    66                 
  4610  12   25:1    66                 5:  IF TWOTHIRD THEN
  4611  12   25:3    69                       SPELLCAS := BADIALMA
  4612  12   25:2    69                     ELSE
  4613  12   25:3    76                       SPELLCAS := BADI;
  4614  12   25:3    83                       
  4615  12   25:1    83                 6:  IF TWOTHIRD THEN
  4616  12   25:3    86                       SPELLCAS := LORTO
  4617  12   25:2    86                     ELSE
  4618  12   25:3    93                       SPELLCAS := MABADI;
  4619  12   25:3   100                       
  4620  12   25:1   100                 7:  SPELLCAS := MABADI;
  4621  12   25:1   107               END;
  4622  12   25:1   128               
  4623  12   25:1   128               ATTCKTYP := SPELLCAS
  4624  12   25:0   128             END;  (* GETPRISP *)
  4625  12   25:0   144             
  4626  12   25:0   144             
  4627  12   22:0     0           BEGIN (* ENEMYSPL *)
  4628  12   22:1     0             IF BATTLERC[ GROUPI].B.MAGSPELS > 0 THEN
  4629  12   22:2    16               IF (RANDOM MOD 100) < 75 THEN
  4630  12   22:3    27                 GETMAGSP( BATTLERC[ GROUPI].B.MAGSPELS);
  4631  12   22:3    41                 
  4632  12   22:1    41             IF ATTCKTYP = 0 THEN
  4633  12   22:2    48               IF BATTLERC[ GROUPI].B.PRISPELS > 0 THEN
  4634  12   22:3    64                 IF (RANDOM MOD 100) < 75 THEN
  4635  12   22:4    75                   GETPRISP( BATTLERC[ GROUPI].B.PRISPELS);
  4636  12   22:0    89           END;  (* ENEMYSPL *)
  4637  12   22:0   102           
  4638  12   22:0   102           
  4639  12   26:D     1         PROCEDURE YELLHELP;  (* P01061A *)
  4640  12   26:D     1         
  4641  12   26:0     0           BEGIN
  4642  12   26:1     0             IF BATTLERC[ GROUPI].B.SPPC[ 6] THEN
  4643  12   26:2    19               IF BATTLERC[ GROUPI].A.ALIVECNT < 5 THEN
  4644  12   26:3    33                 IF (RANDOM MOD 100) < 75 THEN
  4645  12   26:4    44                   ATTCKTYP := -4
  4646  12   26:0    44           END;
  4647  12   26:0    62           
  4648  12   26:0    62           
  4649  12   27:D     1         PROCEDURE RUNENMY;  (* P01061B *)
  4650  12   27:D     1         
  4651  12   27:0     0           BEGIN
  4652  12   27:1     0             IF NOT (BATTLERC[ GROUPI].B.SPPC[ 5]) THEN
  4653  12   27:2    20               EXIT( RUNENMY);
  4654  12   27:1    24             IF BASE12.MYSTRENG > ENSTRENG THEN
  4655  12   27:2    31               IF (RANDOM MOD 100) < 65 THEN
  4656  12   27:3    42                 ATTCKTYP := -2
  4657  12   27:0    42           END;
  4658  12   27:0    60           
  4659  12   27:0    60           
  4660  12   28:D     1         PROCEDURE BREATHES;  (* P01061C *)
  4661  12   28:D     1         
  4662  12   28:0     0           BEGIN
  4663  12   28:1     0             IF BATTLERC[ GROUPI].B.BREATHE > 0 THEN
  4664  12   28:2    16               IF (RANDOM MOD 100) < 60 THEN
  4665  12   28:3    27                 ATTCKTYP := -3
  4666  12   28:0    27           END;
  4667  12   28:0    44           
  4668  12   29:D     1         PROCEDURE ADVANCE;  (* P01061D *)
  4669  12   29:D     1         
  4670  12   29:D     1           VAR
  4671  12   29:D     1                ADVSTREN : ARRAY[ 1..4] OF INTEGER;
  4672  12   29:D     5                ENEMYX   : INTEGER;
  4673  12   29:D     6                GROUPI   : INTEGER;
  4674  12   29:D     7                TEMPE2   : TENEMY2;
  4675  12   29:D   153           
  4676  12   29:D   153           
  4677  12   30:D     1           PROCEDURE MOVETEXT( GROUPI : INTEGER);  (* P01061E *)
  4678  12   30:D     2           
  4679  12   30:D     2             (* MOVE STRINGS OF TEXT AROUND ON THE SCREEN 
  4680  12   30:D     2                FOR THE VARIOUS MONSTER GROUP NAMES       *)
  4681  12   30:D     2           
  4682  12   30:D     2             TYPE
  4683  12   30:D     2                  MEMVAR = RECORD CASE INTEGER OF
  4684  12   30:D     2                     1:  (I: INTEGER);
  4685  12   30:D     2                     2:  (A: ARRAY[ 0..10] OF INTEGER);
  4686  12   30:D     2                    END;
  4687  12   30:D     2                    
  4688  12   30:D     2                  MEMVAR2 = RECORD CASE INTEGER OF
  4689  12   30:D     2                     1:  (I: INTEGER);
  4690  12   30:D     2                     2:  (P: ^INTEGER);
  4691  12   30:D     2                    END;
  4692  12   30:D     2                    
  4693  12   30:D     2             VAR
  4694  12   30:D     2                  LINEX    : INTEGER;
  4695  12   30:D     3                  PIX      : INTEGER;
  4696  12   30:D     4                  SAVEROW  : ARRAY[ 0..7] OF MEMVAR;
  4697  12   30:D    92                  LINEPTRS : ARRAY[ 0..15] OF MEMVAR2;
  4698  12   30:D   108             
  4699  12   30:0     0             BEGIN
  4700  12   30:0     0             
  4701  12   30:0     0               (* SET UP POINTERS TO 2 TEXT ROWS.  EACH ROW IS 8 PIXELS. *)
  4702  12   30:0     0             
  4703  12   30:1     0               LINEPTRS[ 0].I :=  8192 + 128 *  GROUPI      + 16;
  4704  12   30:1    17               LINEPTRS[ 8].I :=  8192 + 128 * (GROUPI + 1) + 16;
  4705  12   30:1    36               FOR PIX := 1 TO 7 DO
  4706  12   30:2    48                 BEGIN
  4707  12   30:3    48                   LINEPTRS[ PIX].I :=     LINEPTRS[ PIX - 1].I + 1024;
  4708  12   30:3    66                   LINEPTRS[ PIX + 8].I := LINEPTRS[ PIX + 7].I + 1024
  4709  12   30:2    81                 END;
  4710  12   30:1    93               WRITE( CHR( 7));
  4711  12   30:1   101               
  4712  12   30:1   101               (* SAVE UPPER ROW OF TEXT *)
  4713  12   30:1   101               
  4714  12   30:1   101               FOR PIX := 0 TO 7 DO
  4715  12   30:2   113                 MOVELEFT( LINEPTRS[ PIX].P^, SAVEROW[ PIX].I, 22);
  4716  12   30:2   136                  
  4717  12   30:2   136                 (* IS 22 LARGE ENOUGH *)
  4718  12   30:2   136                 
  4719  12   30:2   136               (* CLEAR UPPER OF THE TWO ROWS *)
  4720  12   30:2   136                 
  4721  12   30:1   136               FOR PIX := 0 TO 7 DO
  4722  12   30:2   148                 FILLCHAR( LINEPTRS[ PIX].P^, 22, 0);
  4723  12   30:1   166               WRITE( CHR( 7));
  4724  12   30:1   174               
  4725  12   30:1   174               (* MOVE LOWER ROW OF TEXT UPWARD A PIXEL AT A TIME *)
  4726  12   30:1   174               
  4727  12   30:1   174               FOR PIX := 7 DOWNTO 0 DO
  4728  12   30:2   186                 BEGIN
  4729  12   30:3   186                   FOR LINEX := PIX TO PIX + 7 DO
  4730  12   30:4   200                     MOVELEFT( LINEPTRS[ LINEX + 1].P^, LINEPTRS[ LINEX].P^, 22);
  4731  12   30:3   226                   FILLCHAR( LINEPTRS[ PIX + 8].P^, 22, 0)
  4732  12   30:2   239                 END;
  4733  12   30:1   246               WRITE( CHR( 7));
  4734  12   30:1   254               
  4735  12   30:1   254               (* MOVE SAVED ROW OF TEXT TO LOWER ROW *)
  4736  12   30:1   254               
  4737  12   30:1   254               FOR PIX := 0 TO 7 DO
  4738  12   30:2   266                 MOVELEFT( SAVEROW[ PIX].I, LINEPTRS[ PIX + 8].P^, 22);
  4739  12   30:0   291             END;
  4740  12   30:0   316             
  4741  12   30:0   316             
  4742  12   29:0     0           BEGIN (* ADVANCE *)
  4743  12   29:1     0             FOR GROUPI := 1 TO 4 DO
  4744  12   29:2    14               BEGIN
  4745  12   29:3    14                 ADVSTREN[ GROUPI] := 0;
  4746  12   29:3    23                 FOR ENEMYX := 0 TO BATTLERC[ GROUPI].A.ALIVECNT - 1 DO
  4747  12   29:4    46                   IF BATTLERC[ GROUPI].A.TEMP04[ ENEMYX].STATUS = OK THEN
  4748  12   29:5    63                     ADVSTREN[ GROUPI] := ADVSTREN[ GROUPI]
  4749  12   29:5    77                                 + BATTLERC[ GROUPI].A.TEMP04[ ENEMYX].HPLEFT
  4750  12   29:5    90                                 - 3 * (BATTLERC[ GROUPI].B.MAGSPELS + 
  4751  12   29:5   103                                        BATTLERC[ GROUPI].B.PRISPELS);
  4752  12   29:5   124                                          
  4753  12   29:3   124                 IF ADVSTREN[ GROUPI] > 1000 THEN
  4754  12   29:4   138                   ADVSTREN[ GROUPI] := 1000
  4755  12   29:3   145                 ELSE IF ADVSTREN[ GROUPI] < 1 THEN
  4756  12   29:5   163                   ADVSTREN[ GROUPI] := 1;
  4757  12   29:2   172               END;
  4758  12   29:2   179             
  4759  12   29:1   179             FOR GROUPI := 4 DOWNTO 2 DO
  4760  12   29:2   193               BEGIN
  4761  12   29:3   193                 IF BATTLERC[ GROUPI].A.ALIVECNT > 0 THEN
  4762  12   29:4   205                   BEGIN
  4763  12   29:5   205                     IF (RANDOM MOD 100) <= 
  4764  12   29:5   212                        30 + ((20 * ADVSTREN[ GROUPI]) DIV ADVSTREN[ GROUPI - 1]) THEN
  4765  12   29:5   238                        
  4766  12   29:6   238                       BEGIN
  4767  12   29:7   238                         MVCURSOR( 1, 15 - GROUPI);
  4768  12   29:7   245                         PRINTSTR( 'THE ');
  4769  12   29:7   255                         IF BATTLERC[ GROUPI].A.IDENTIFI THEN
  4770  12   29:8   265                           PRINTSTR( BATTLERC[ GROUPI].B.NAMES)
  4771  12   29:7   274                         ELSE
  4772  12   29:8   279                           PRINTSTR( BATTLERC[ GROUPI].B.NAMEUNKS);
  4773  12   29:7   291                         PRINTSTR( ' ADVANCE!');
  4774  12   29:7   306                         MOVETEXT( GROUPI - 1);
  4775  12   29:7   311                         PAUSE1;
  4776  12   29:7   314                         
  4777  12   29:7   314                         ENEMYX                := ADVSTREN[ GROUPI];
  4778  12   29:7   324                         ADVSTREN[ GROUPI]     := ADVSTREN[ GROUPI - 1];
  4779  12   29:7   342                         ADVSTREN[ GROUPI - 1] := ENEMYX;
  4780  12   29:7   353                         
  4781  12   29:7   353                         TEMPE2                := BATTLERC[ GROUPI];
  4782  12   29:7   365                         BATTLERC[ GROUPI]     := BATTLERC[ GROUPI - 1];
  4783  12   29:7   384                         BATTLERC[ GROUPI - 1] := TEMPE2
  4784  12   29:6   393                       END;
  4785  12   29:4   398                   END;
  4786  12   29:2   398               END;
  4787  12   29:1   405             CLRRECT( 1, 11, 38, 4)
  4788  12   29:0   409           END;  (* ADVANCE *)
  4789  12   29:0   438           
  4790  12   29:0   438           
  4791  12   20:0     0         BEGIN (* ENATTACK *)
  4792  12   20:1     0           ADVANCE;
  4793  12   20:1     2           FOR GROUPI := 1 TO 4 DO
  4794  12   20:2    13             BEGIN
  4795  12   20:3    13               IF BATTLERC[ GROUPI].A.ALIVECNT > 0 THEN
  4796  12   20:4    25                 FOR ENEMYX := 0 TO (BATTLERC[ GROUPI].A.ALIVECNT - 1) DO
  4797  12   20:5    45                   WITH BATTLERC[ GROUPI] DO
  4798  12   20:6    54                     BEGIN
  4799  12   20:7    54                     IF (A.TEMP04[ ENEMYX].STATUS = OK) AND
  4800  12   20:7    63                        (SURPRISE <> 1) THEN
  4801  12   20:8    71                       BEGIN
  4802  12   20:9    71                         A.TEMP04[ ENEMYX].AGILITY := (RANDOM MOD 8) + 2;
  4803  12   20:9    89                         IF PARTYCNT = 1 THEN
  4804  12   20:0    94                           CHARX := 0
  4805  12   20:9    94                         ELSE
  4806  12   20:0    99                           BEGIN
  4807  12   20:1    99                             CHARX := PARTYCNT - 1;
  4808  12   20:1   104                             WHILE BATTLERC[ 0].A.TEMP04[ CHARX].STATUS >=
  4809  12   20:1   117                                     DEAD DO 
  4810  12   20:2   121                               CHARX := CHARX - 1;
  4811  12   20:1   128                             CHARX := RANDOM MOD (CHARX + 1)
  4812  12   20:0   136                           END;
  4813  12   20:9   139                         A.TEMP04[ ENEMYX].VICTIM := CHARX;
  4814  12   20:9   147                         A.TEMP04[ ENEMYX].SPELLHSH := 0;
  4815  12   20:9   157                         ATTCKTYP := 0;
  4816  12   20:9   160                         IF CANATTCK THEN
  4817  12   20:0   166                           BEGIN
  4818  12   20:1   166                             ENEMYSPL;
  4819  12   20:1   168                             IF ATTCKTYP = 0 THEN
  4820  12   20:2   173                               BREATHES;
  4821  12   20:1   175                             IF ATTCKTYP = 0 THEN
  4822  12   20:2   180                               YELLHELP;
  4823  12   20:1   182                             IF ATTCKTYP = 0 THEN
  4824  12   20:2   187                               RUNENMY;
  4825  12   20:1   189                             IF ATTCKTYP > 0 THEN
  4826  12   20:2   194                               IF CHARACTR[ CHARX].WEPVSTY3[ 1][ 6] THEN
  4827  12   20:3   211                                 A.TEMP04[ ENEMYX].AGILITY := -1;
  4828  12   20:1   222                             IF ATTCKTYP = 0 THEN
  4829  12   20:2   227                               IF (ENEMYX <= 4 - GROUPI) OR
  4830  12   20:2   232                                  ((60 - 10 * GROUPI) <= (RANDOM MOD 100)) THEN
  4831  12   20:3   248                                 BEGIN
  4832  12   20:4   248                                   CHARX := CHARX MOD 3;
  4833  12   20:4   253                                   IF CANATTCK THEN
  4834  12   20:5   259                                     BEGIN
  4835  12   20:6   259                                       ATTCKTYP := -1;
  4836  12   20:6   263                                       A.TEMP04[ ENEMYX].VICTIM := CHARX
  4837  12   20:5   269                                     END
  4838  12   20:4   271                                   ELSE
  4839  12   20:5   273                                     A.TEMP04[ ENEMYX].AGILITY := -1;
  4840  12   20:3   284                                 END
  4841  12   20:0   284                           END;
  4842  12   20:9   284                         A.TEMP04[ ENEMYX].SPELLHSH := ATTCKTYP
  4843  12   20:8   292                       END
  4844  12   20:7   294                     ELSE
  4845  12   20:8   296                       A.TEMP04[ ENEMYX].AGILITY := -1
  4846  12   20:6   304                 END
  4847  12   20:2   307             END
  4848  12   20:0   314           END;  (* ENATTACK *)
  4849  12   20:0   348         
  4850  12   20:0   348         
  4851  12   20:0   348 (*$I WIZ1B:COMBAT2   *)
  4851  12   20:0   348 (*$I WIZ1B:COMBAT3   *)
  4852  12   31:D     1     PROCEDURE HEAL;  (* P01061F *)
  4853  12   31:D     1       
  4854  12   31:D     1         VAR
  4855  12   31:D     1              MVUPLIVE : INTEGER;
  4856  12   31:D     2              T1       : INTEGER; (* MULTIPLE USES *)
  4857  12   31:D     3              T2       : INTEGER; (* MULTIPLE USES *)
  4858  12   31:D     4              
  4859  12   31:D     4       
  4860  12   32:D     1         PROCEDURE TRYHEAL( HEALCHAN: INTEGER);  (* P010620 *)
  4861  12   32:D     2         
  4862  12   32:0     0           BEGIN
  4863  12   32:1     0             IF HEALCHAN > 50 THEN
  4864  12   32:2     5               HEALCHAN := 50;
  4865  12   32:1     8             IF (RANDOM MOD 100) <= HEALCHAN THEN
  4866  12   32:2    19               BATTLERC[ T2].A.TEMP04[ T1].STATUS := OK
  4867  12   32:0    37           END;
  4868  12   32:0    52           
  4869  12   32:0    52           
  4870  12   33:D     1         PROCEDURE HEALENMY;  (* P010621 *)
  4871  12   33:D     1         
  4872  12   33:D     1           VAR
  4873  12   33:D     1                ENEMYRC : TENEMY2;
  4874  12   33:D   147         
  4875  12   33:0     0           BEGIN
  4876  12   33:1     0             FOR T2 := 1 TO 4 DO
  4877  12   33:2    17               BEGIN
  4878  12   33:3    17                 IF BATTLERC[ T2].A.ALIVECNT > 0 THEN
  4879  12   33:4    31                   BEGIN
  4880  12   33:5    31                     T1 := 0;
  4881  12   33:5    35                     MVUPLIVE := 0;
  4882  12   33:5    39                     WHILE MVUPLIVE < BATTLERC[ T2].A.ALIVECNT DO
  4883  12   33:6    55                       BEGIN
  4884  12   33:7    55                         BATTLERC[ T2].A.TEMP04[ T1] :=
  4885  12   33:7    71                           BATTLERC[ T2].A.TEMP04[ MVUPLIVE];
  4886  12   33:7    89                         MVUPLIVE := MVUPLIVE + 1;
  4887  12   33:7    97                         IF BATTLERC[ T2].A.TEMP04[ T1].STATUS < DEAD THEN
  4888  12   33:8   118                           BEGIN
  4889  12   33:9   118                             CASE BATTLERC[ T2].A.TEMP04[ T1].STATUS OF
  4890  12   33:9   137                             
  4891  12   33:9   137                               AFRAID:
  4892  12   33:0   137                                TRYHEAL( 10 * BATTLERC[ T2].B.HPREC.LEVEL);
  4893  12   33:0   154                                
  4894  12   33:9   154                               ASLEEP:
  4895  12   33:0   154                                TRYHEAL( 20 * BATTLERC[ T2].B.HPREC.LEVEL);
  4896  12   33:0   171                                
  4897  12   33:9   171                               PLYZE:
  4898  12   33:0   171                                TRYHEAL(  7 * BATTLERC[ T2].B.HPREC.LEVEL);
  4899  12   33:9   188                             END;
  4900  12   33:9   202                             
  4901  12   33:9   202                             BATTLERC[ T2].A.TEMP04[ T1].HPLEFT :=
  4902  12   33:9   220                               BATTLERC[ T2].A.TEMP04[ T1].HPLEFT +
  4903  12   33:9   237                               BATTLERC[ T2].B.HEALPTS;
  4904  12   33:9   251                             T1 := T1 + 1
  4905  12   33:8   254                           END
  4906  12   33:6   259                       END;
  4907  12   33:5   261                     BATTLERC[ T2].A.ALIVECNT := T1
  4908  12   33:4   272                   END
  4909  12   33:2   276               END;
  4910  12   33:2   286               
  4911  12   33:1   286             FOR T1 := 1 TO 3 DO
  4912  12   33:2   303               BEGIN
  4913  12   33:3   303                 FOR T2 := T1 + 1 TO 4 DO
  4914  12   33:4   324                   IF (BATTLERC[ T1].A.ALIVECNT = 0) AND
  4915  12   33:4   336                      (BATTLERC[ T2].A.ALIVECNT > 0)    THEN
  4916  12   33:5   351                     BEGIN
  4917  12   33:6   351                       ENEMYRC := BATTLERC[ T1];
  4918  12   33:6   365                       BATTLERC[ T1] := BATTLERC[ T2];
  4919  12   33:6   386                       BATTLERC[ T2] := ENEMYRC
  4920  12   33:5   395                     END
  4921  12   33:2   400               END;
  4922  12   33:2   420             
  4923  12   33:1   420             T2 := 0;
  4924  12   33:1   424             FOR T1 := 1 TO 4 DO
  4925  12   33:2   441               IF BATTLERC[ T1].A.ALIVECNT > 0 THEN
  4926  12   33:3   455                 T2 := T1;
  4927  12   33:1   471             DONEFIGH := (T2 = 0)
  4928  12   33:0   476           END;  (* HEALENMY *)
  4929  12   33:0   510           
  4930  12   33:0   510           
  4931  12   34:D     1         PROCEDURE HEALPRTY;  (* P010622 *)
  4932  12   34:D     1         
  4933  12   34:0     0           BEGIN
  4934  12   34:1     0             T2 := 0;
  4935  12   34:1     4             FOR T1 := 0 TO PARTYCNT - 1 DO
  4936  12   34:2    20               BEGIN
  4937  12   34:3    20                 IF BATTLERC[ 0].A.TEMP04[ T1].STATUS < DEAD THEN
  4938  12   34:4    39                   BEGIN
  4939  12   34:5    39                     IF (RANDOM MOD 4) = 2 THEN
  4940  12   34:6    50                       BATTLERC[ 0].A.TEMP04[ T1].HPLEFT :=
  4941  12   34:6    66                         BATTLERC[ 0].A.TEMP04[ T1].HPLEFT +
  4942  12   34:6    81                         CHARACTR[ T1].HEALPTS -
  4943  12   34:6    91                         CHARACTR[ T1].LOSTXYL.POISNAMT[ 1];
  4944  12   34:6   108                       
  4945  12   34:5   108                     IF BATTLERC[ 0].A.TEMP04[ T1].HPLEFT > 
  4946  12   34:5   123                       CHARACTR[ T1].HPMAX THEN
  4947  12   34:6   135                        BATTLERC[ 0].A.TEMP04[ T1].HPLEFT :=
  4948  12   34:6   151                          CHARACTR[ T1].HPMAX;
  4949  12   34:6   161                          
  4950  12   34:5   161                     IF BATTLERC[ 0].A.TEMP04[ T1].HPLEFT <= 0 THEN
  4951  12   34:6   180                       BEGIN
  4952  12   34:7   180                         BATTLERC[ 0].A.TEMP04[ T1].STATUS := DEAD;
  4953  12   34:7   198                         BATTLERC[ 0].A.TEMP04[ T1].HPLEFT := 0;
  4954  12   34:7   216                         MVCURSOR( 1, 12);
  4955  12   34:7   221                         PRINTSTR( CHARACTR[ T1].NAME);
  4956  12   34:7   231                         PRINTSTR( ' JUST DIED!');
  4957  12   34:7   248                         PAUSE2;
  4958  12   34:7   251                         CLRRECT( 1, 12, 38, 1);
  4959  12   34:6   258                       END;
  4960  12   34:6   258            
  4961  12   34:5   258                     CASE BATTLERC[ 0].A.TEMP04[ T1].STATUS OF
  4962  12   34:5   275                       ASLEEP:  TRYHEAL( 10 * CHARACTR[ T1].CHARLEV);
  4963  12   34:5   290                       AFRAID:  TRYHEAL(  5 * CHARACTR[ T1].CHARLEV);
  4964  12   34:5   305                     END;
  4965  12   34:4   316                   END
  4966  12   34:2   316                 END;
  4967  12   34:2   326                 
  4968  12   34:1   326               FOR T1 := 0 TO PARTYCNT - 1 DO
  4969  12   34:2   342                 BEGIN
  4970  12   34:3   342                   CHARACTR[ T1].HPLEFT := BATTLERC[ 0].A.TEMP04[ T1].HPLEFT;
  4971  12   34:3   367                   CHARACTR[ T1].STATUS := BATTLERC[ 0].A.TEMP04[ T1].STATUS
  4972  12   34:2   390                 END
  4973  12   34:0   392           END;  (* HEALPRTY *)
  4974  12   34:0   422           
  4975  12   34:0   422           
  4976  12   35:D     1         PROCEDURE HEALHEAR;  (* P010623 *)
  4977  12   35:D     1         
  4978  12   35:D     1         
  4979  12   36:D     1           PROCEDURE DECINAUD( GROUPI:   INTEGER;  (* P01061B *)
  4980  12   36:D     2                               ALIVECNT: INTEGER);
  4981  12   36:D     3           
  4982  12   36:D     3             VAR
  4983  12   36:D     3                  X : INTEGER;
  4984  12   36:D     4           
  4985  12   36:0     0             BEGIN
  4986  12   36:1     0               FOR X := 0 TO ALIVECNT - 1 DO
  4987  12   36:2    13                 IF BATTLERC[ GROUPI].A.TEMP04[ ALIVECNT].INAUDCNT > 0 THEN
  4988  12   36:3    30                    BATTLERC[ GROUPI].A.TEMP04[ ALIVECNT].INAUDCNT :=
  4989  12   36:3    44                    BATTLERC[ GROUPI].A.TEMP04[ ALIVECNT].INAUDCNT - 1
  4990  12   36:0    57             END;  (* DECINAUD *)
  4991  12   36:0    82             
  4992  12   36:0    82             
  4993  12   35:0     0           BEGIN (* HEALHEAR *)
  4994  12   35:1     0             DECINAUD( 0, PARTYCNT);
  4995  12   35:1     4             DECINAUD( 1, BATTLERC[ 1].A.ALIVECNT);
  4996  12   35:1    15             DECINAUD( 2, BATTLERC[ 2].A.ALIVECNT);
  4997  12   35:1    26             DECINAUD( 3, BATTLERC[ 3].A.ALIVECNT)
  4998  12   35:0    35           END; (* HEALHEAR *)
  4999  12   35:0    50           
  5000  12   35:0    50           
  5001  12   31:0     0         BEGIN (* HEAL *)
  5002  12   31:1     0           HEALENMY;
  5003  12   31:1     2           HEALPRTY;
  5004  12   31:1     4           HEALHEAR
  5005  12   31:0     4         END;
  5006  12   31:0    18       
  5007  12   31:0    18       
  5008  12   37:D     1       PROCEDURE DSPENEMY;  (* P010625 *)
  5009  12   37:D     1       
  5010  12   37:D     1         VAR
  5011  12   37:D     1              ENMYGROK : INTEGER;
  5012  12   37:D     2              ENMYGRI  : INTEGER;
  5013  12   37:D     3              ENMYIND  : INTEGER;
  5014  12   37:D     4       
  5015  12   37:0     0         BEGIN
  5016  12   37:1     0           ENSTRENG := 0;
  5017  12   37:1     3           FOR ENMYGRI := 1 TO 4 DO
  5018  12   37:2    14             BEGIN
  5019  12   37:3    14               CLRRECT( 13, ENMYGRI, 26, 1);
  5020  12   37:3    21               IF BATTLERC[ ENMYGRI].A.ALIVECNT > 0 THEN
  5021  12   37:4    33                 BEGIN
  5022  12   37:5    33                   ENMYGROK := 0;
  5023  12   37:5    36                   FOR ENMYIND := 0 TO BATTLERC[ ENMYGRI].A.ALIVECNT - 1 DO
  5024  12   37:6    56                     IF BATTLERC[ ENMYGRI].A.TEMP04[ ENMYIND].STATUS = OK THEN
  5025  12   37:7    73                       ENMYGROK := ENMYGROK + 1;
  5026  12   37:5    85                   ENSTRENG := ENSTRENG + ENMYGROK *
  5027  12   37:5    88                                          (BATTLERC[ ENMYGRI].B.HPREC.LEVEL);
  5028  12   37:5   101                   MVCURSOR( 13, ENMYGRI);
  5029  12   37:5   106                   PRINTNUM( ENMYGRI, 1);
  5030  12   37:5   111                   PRINTSTR( ') ');
  5031  12   37:5   119                   PRINTNUM( BATTLERC[ ENMYGRI].A.ALIVECNT, 1);
  5032  12   37:5   131                   PRINTSTR( ' ');
  5033  12   37:5   135                   IF BATTLERC[ ENMYGRI].A.IDENTIFI THEN
  5034  12   37:6   145                     IF BATTLERC[ ENMYGRI].A.ALIVECNT > 1 THEN
  5035  12   37:7   157                       PRINTSTR( BATTLERC[ ENMYGRI].B.NAMES)
  5036  12   37:6   166                     ELSE
  5037  12   37:7   171                       PRINTSTR( BATTLERC[ ENMYGRI].B.NAME)
  5038  12   37:5   180                   ELSE
  5039  12   37:6   185                     IF BATTLERC[ ENMYGRI].A.ALIVECNT > 1 THEN
  5040  12   37:7   197                       PRINTSTR( BATTLERC[ ENMYGRI].B.NAMEUNKS)
  5041  12   37:6   206                     ELSE
  5042  12   37:7   211                       PRINTSTR( BATTLERC[ ENMYGRI].B.NAMEUNK);
  5043  12   37:5   223                   PRINTSTR( ' (');
  5044  12   37:5   231                   PRINTNUM( ENMYGROK, 1);
  5045  12   37:5   236                   PRINTCHR( ')')
  5046  12   37:4   237                 END
  5047  12   37:2   240             END
  5048  12   37:0   240         END;
  5049  12   37:0   268         
  5050  12   37:0   268         
  5051  12   38:D     1       PROCEDURE DSPPARTY;  (* P010626 *)
  5052  12   38:D     1       
  5053  12   38:D     1         VAR
  5054  12   38:D     1              UNUSEDXX : INTEGER;
  5055  12   38:D     2              TEMPXYZ  : INTEGER;  (* MULTIPLE USES *)
  5056  12   38:D     3              PARTYI   : INTEGER;
  5057  12   38:D     4              STATUSOK : BOOLEAN;
  5058  12   38:D     5       
  5059  12   38:D     5       
  5060  12   39:D     1         PROCEDURE PRSTATUS;  (* P010627 *)
  5061  12   39:D     1         
  5062  12   39:0     0           BEGIN
  5063  12   39:1     0             STATUSOK :=  STATUSOK OR (CHARACTR[ PARTYI].STATUS < DEAD);
  5064  12   39:1    18             IF CHARACTR[ PARTYI].STATUS = OK THEN
  5065  12   39:2    31               IF CHARACTR[ PARTYI].LOSTXYL.POISNAMT[ 1] > 0 THEN
  5066  12   39:3    50                 PRINTSTR( 'POISON')
  5067  12   39:2    59               ELSE
  5068  12   39:3    64                 PRINTNUM( CHARACTR[ PARTYI].HPMAX, 4)
  5069  12   39:1    74             ELSE
  5070  12   39:2    79               PRINTSTR( SCNTOC.STATUS[ CHARACTR[ PARTYI].STATUS])
  5071  12   39:0    93           END; (* PRSTATUS *)
  5072  12   39:0   108           
  5073  12   39:0   108           
  5074  12   40:D     1         PROCEDURE SWAP2CHR( X: INTEGER;  (* P010628 *)
  5075  12   40:D     2                             Y: INTEGER);
  5076  12   40:D     3         
  5077  12   40:D     3           VAR
  5078  12   40:D     3                TEMPCHAR : TCHAR;
  5079  12   40:D   107                TEMPX    : BOOLEAN;
  5080  12   40:D   108         
  5081  12   40:0     0           BEGIN
  5082  12   40:1     0             TEMPCHAR := CHARACTR[ X];
  5083  12   40:1     9             CHARACTR[ X] := CHARACTR[ Y];
  5084  12   40:1    21             CHARACTR[ Y] := TEMPCHAR;
  5085  12   40:1    30             
  5086  12   40:1    30             LLBASE04 := CHARDISK[ X];
  5087  12   40:1    38             CHARDISK[ X] := CHARDISK[ Y];
  5088  12   40:1    50             CHARDISK[ Y] := LLBASE04;
  5089  12   40:1    57             
  5090  12   40:1    57             TEMPX := DRAINED[ X];
  5091  12   40:1    66             DRAINED[ X] := DRAINED[ Y];
  5092  12   40:1    80             DRAINED[ Y] := TEMPX;
  5093  12   40:1    89             
  5094  12   40:1    89             BATTLERC[ 0].A.TEMP04[ 6] := BATTLERC[ 0].A.TEMP04[ X];
  5095  12   40:1   115             BATTLERC[ 0].A.TEMP04[ X] := BATTLERC[ 0].A.TEMP04[ Y];
  5096  12   40:1   141             BATTLERC[ 0].A.TEMP04[ Y] := BATTLERC[ 0].A.TEMP04[ 6]
  5097  12   40:1   165           
  5098  12   40:0   165           END; (* SWAP2CHR *)
  5099  12   40:0   180         
  5100  12   40:0   180         
  5101  12   38:0     0         BEGIN (* DSPPARTY *)
  5102  12   38:1     0           FOR PARTYI := 0 TO PARTYCNT - 2 DO
  5103  12   38:2    13             FOR TEMPXYZ := PARTYI + 1 TO PARTYCNT - 1 DO
  5104  12   38:3    28               IF PREBATOR[ PARTYI] = CHARDISK[ TEMPXYZ] THEN
  5105  12   38:4    44                 SWAP2CHR( PARTYI, TEMPXYZ);
  5106  12   38:4    62           
  5107  12   38:1    62           FOR PARTYI := 0 TO PARTYCNT - 2 DO
  5108  12   38:2    75             FOR TEMPXYZ := PARTYI + 1 TO PARTYCNT - 1 DO
  5109  12   38:3    90               IF CHARACTR[ PARTYI].STATUS > CHARACTR[ TEMPXYZ].STATUS THEN
  5110  12   38:4   107                 SWAP2CHR( PARTYI, TEMPXYZ);
  5111  12   38:4   125                 
  5112  12   38:1   125           BASE12.MYSTRENG := 0;
  5113  12   38:1   128           BATTLERC[ 0].A.ALIVECNT := 0;
  5114  12   38:1   139           FOR PARTYI := 0 TO PARTYCNT - 1 DO
  5115  12   38:2   152             BEGIN
  5116  12   38:3   152               IF CHARACTR[ PARTYI].STATUS = OK THEN
  5117  12   38:4   163                 BASE12.MYSTRENG := BASE12.MYSTRENG +
  5118  12   38:4   165                                     CHARACTR[ PARTYI].CHARLEV;
  5119  12   38:3   175               IF CHARACTR[ PARTYI].STATUS < DEAD THEN
  5120  12   38:4   186                 BATTLERC[ 0].A.ALIVECNT := BATTLERC[ 0].A.ALIVECNT + 1
  5121  12   38:2   203             END;
  5122  12   38:2   213             
  5123  12   38:1   213           CLRRECT( 1, 17, 38, 6);
  5124  12   38:1   220           
  5125  12   38:1   220           STATUSOK := FALSE;
  5126  12   38:1   223           FOR PARTYI := 0 TO PARTYCNT - 1 DO
  5127  12   38:2   236             BEGIN
  5128  12   38:3   236               IF (RANDOM MOD 99) < (CHARACTR[ PARTYI].ATTRIB[ IQ] +
  5129  12   38:3   255                                     CHARACTR[ PARTYI].ATTRIB[ PIETY] +
  5130  12   38:3   268                                     CHARACTR[ PARTYI].CHARLEV)  THEN
  5131  12   38:4   279                 BATTLERC[ (RANDOM MOD 4) + 1].A.IDENTIFI := TRUE;
  5132  12   38:3   296               MVCURSOR( 1, 17 + PARTYI);
  5133  12   38:3   303               PRINTNUM( PARTYI + 1, 1);
  5134  12   38:3   310               PRINTSTR( ' ');
  5135  12   38:3   314               PRINTSTR( CHARACTR[ PARTYI].NAME);
  5136  12   38:3   322               MVCURSOR( 19, 17 + PARTYI);
  5137  12   38:3   329               PRINTSTR( COPY( SCNTOC.ALIGN[ CHARACTR[ PARTYI].ALIGN], 1, 1));
  5138  12   38:3   353               PRINTCHR( '-');
  5139  12   38:3   357               PRINTSTR( COPY( SCNTOC.CLASS[ CHARACTR[ PARTYI].CLASS], 1, 3));
  5140  12   38:3   381               LLBASE04 := CHARACTR[ PARTYI].ARMORCL -
  5141  12   38:3   388                         ACMOD2 -
  5142  12   38:3   390                         BATTLERC[ 0].A.TEMP04[ PARTYI].ARMORCL;
  5143  12   38:3   406               IF LLBASE04 >= 0 THEN
  5144  12   38:4   411                 PRINTNUM( LLBASE04, 3)
  5145  12   38:3   413               ELSE
  5146  12   38:4   418                 IF LLBASE04 > - 10 THEN
  5147  12   38:5   424                   BEGIN
  5148  12   38:6   424                     PRINTSTR( ' -');
  5149  12   38:6   432                     PRINTNUM( ABS( LLBASE04), 1)
  5150  12   38:5   435                   END
  5151  12   38:4   438                 ELSE
  5152  12   38:5   440                   PRINTSTR( ' LO');
  5153  12   38:3   449               PRINTNUM( CHARACTR[ PARTYI].HPLEFT, 5);
  5154  12   38:3   460               TEMPXYZ := CHARACTR[ PARTYI].HEALPTS -
  5155  12   38:3   467                          CHARACTR[ PARTYI].LOSTXYL.POISNAMT[ 1];
  5156  12   38:3   483               IF TEMPXYZ = 0 THEN
  5157  12   38:4   488                 PRINTCHR( ' ')
  5158  12   38:3   489               ELSE IF TEMPXYZ < 0 THEN
  5159  12   38:5   499                 PRINTCHR( '-')
  5160  12   38:4   500               ELSE
  5161  12   38:5   505                 PRINTCHR( '+');
  5162  12   38:3   509               PRSTATUS;
  5163  12   38:2   511             END;
  5164  12   38:1   518           IF NOT STATUSOK THEN
  5165  12   38:2   522             EXIT( COMBAT);
  5166  12   38:0   526         END; (* DSPPARTY *)
  5167  12   38:0   552         
  5168  12   38:0   552         
  5169  12    1:0     0       BEGIN (* CUTIL *)
  5170  12    1:1     0         HEAL;
  5171  12    1:1     2         DSPPARTY;
  5172  12    1:1     4         DSPENEMY;
  5173  12    1:1     6         IF DONEFIGH THEN
  5174  12    1:2    11           EXIT( CUTIL);
  5175  12    1:1    15         ENATTACK;
  5176  12    1:1    17         CACTION;
  5177  12    1:1    19         SURPRISE := 0
  5178  12    1:0    19       END;  (* CUTIL *)
  5179  12    1:0    36   
  5180  12    1:0    36 (*$I WIZ1B:COMBAT3   *)
  5180  12    1:0    36 (*$I WIZ1B:COMBAT4   *)
  5181  12    1:0    36 (* MELEE *)
  5182  12    1:0    36 
  5183  13    1:D     1 SEGMENT PROCEDURE MELEE;  (* P010701 *)
  5184  13    1:D     1 
  5185  13    1:D     1   VAR
  5186  13    1:D     1          VICTIM   : INTEGER;
  5187  13    1:D     2          ATTACKTY : INTEGER;
  5188  13    1:D     3          BATI     : INTEGER;
  5189  13    1:D     4          BATG     : INTEGER;
  5190  13    1:D     5          AGILELEV : INTEGER;
  5191  13    1:D     6   
  5192  13    1:D     6 (* CASTASPE *)
  5193  13    1:D     6 
  5194  14    1:D     1     SEGMENT PROCEDURE CASTASPE;  (* P010801 *)
  5195  14    1:D     1     
  5196  14    1:D     1       TYPE
  5197  14    1:D     1            THITHEAL = RECORD
  5198  14    1:D     1                HITS     : INTEGER;
  5199  14    1:D     1                HITRANGE : INTEGER;
  5200  14    1:D     1                HITMIN   : INTEGER;
  5201  14    1:D     1              END;
  5202  14    1:D     1                     
  5203  14    1:D     1       VAR
  5204  14    1:D     1            SPELL    : INTEGER;
  5205  14    1:D     2            CASTI    : INTEGER;
  5206  14    1:D     3            CASTGR   : INTEGER;
  5207  14    1:D     4            
  5208  14    1:D     4            
  5209  14    2:D     1       PROCEDURE DSPNAMES( GROUPI:  INTEGER;  (* P010802 *)
  5210  14    2:D     2                           MYCHARI: INTEGER);
  5211  14    2:D     3       
  5212  14    2:0     0         BEGIN
  5213  14    2:1     0           IF GROUPI = 0 THEN
  5214  14    2:2     5             PRINTSTR( CHARACTR[ MYCHARI].NAME)
  5215  14    2:1    10           ELSE
  5216  14    2:2    15             IF BATTLERC[ GROUPI].A.IDENTIFI THEN
  5217  14    2:3    25               PRINTSTR( BATTLERC[ GROUPI].B.NAME)
  5218  14    2:2    34             ELSE
  5219  14    2:3    39               PRINTSTR( BATTLERC[ GROUPI].B.NAMEUNK);
  5220  14    2:1    51           PRINTSTR( ' ');
  5221  14    2:0    55         END;
  5222  14    2:0    68         
  5223  14    2:0    68         
  5224  14    3:D     1       PROCEDURE UNAFFECT( GROUPI: INTEGER;
  5225  14    3:D     2                           CHARX:  INTEGER;
  5226  14    3:D     3                           DAMPTS: INTEGER);  (* P010803 *)
  5227  14    3:D     4       
  5228  14    3:0     0         BEGIN
  5229  14    3:1     0           CLRRECT( 1, 12, 38, 3);
  5230  14    3:1     7           IF BATTLERC[ GROUPI].A.TEMP04[ CHARX].STATUS >= DEAD THEN
  5231  14    3:2    24             EXIT( UNAFFECT);
  5232  14    3:1    28           MVCURSOR( 1, 12);
  5233  14    3:1    33           DSPNAMES( GROUPI, CHARX);
  5234  14    3:1    37           IF GROUPI <> 0 THEN
  5235  14    3:2    42             BEGIN
  5236  14    3:3    42               IF BATTLERC[ GROUPI].B.UNAFFCT > (RANDOM MOD 100) THEN
  5237  14    3:4    62                  DAMPTS := 0;
  5238  14    3:2    65             END;
  5239  14    3:1    65           IF DAMPTS = 0 THEN
  5240  14    3:2    70             PRINTSTR( 'IS UNAFFECTED!')
  5241  14    3:1    87           ELSE
  5242  14    3:2    92             BEGIN
  5243  14    3:3    92               PRINTSTR( 'TAKES ');
  5244  14    3:3   104               PRINTNUM( DAMPTS, 4);
  5245  14    3:3   109               PRINTSTR( ' DAMAGE');
  5246  14    3:3   122               WITH BATTLERC[ GROUPI].A.TEMP04[ CHARX] DO
  5247  14    3:4   136                 BEGIN
  5248  14    3:5   136                   HPLEFT := HPLEFT - DAMPTS;
  5249  14    3:5   144                   IF HPLEFT <= 0 THEN
  5250  14    3:6   150                     BEGIN
  5251  14    3:7   150                       HPLEFT := 0;
  5252  14    3:7   155                       STATUS := DEAD;
  5253  14    3:7   160                       MVCURSOR( 1, 14);
  5254  14    3:7   165                       DSPNAMES( GROUPI, CHARX);
  5255  14    3:7   169                       PRINTSTR( 'DIES!')
  5256  14    3:6   177                     END
  5257  14    3:4   180                 END
  5258  14    3:2   180             END;
  5259  14    3:1   180           PAUSE1
  5260  14    3:0   180         END;
  5261  14    3:0   196         
  5262  14    3:0   196         
  5263  14    4:D     1       PROCEDURE ISISNOT( GROUPI:    INTEGER;  (* P010804 *)
  5264  14    4:D     2                          CHARI:     INTEGER;
  5265  14    4:D     3                          ISNOTCHN:  INTEGER;
  5266  14    4:D     4                          SDAMTYPE:  STRING;
  5267  14    4:D     5                          DAMTYPE:   INTEGER);
  5268  14    4:D    47       
  5269  14    4:0     0         BEGIN
  5270  14    4:1     0           MVCURSOR( 1, 13);
  5271  14    4:1    10           DSPNAMES( GROUPI, CHARI);
  5272  14    4:1    14           
  5273  14    4:1    14           IF (RANDOM MOD 100) < ISNOTCHN THEN
  5274  14    4:2    25             PRINTSTR( 'IS NOT ')
  5275  14    4:1    35           ELSE
  5276  14    4:2    40             BEGIN
  5277  14    4:3    40               PRINTSTR( 'IS ');
  5278  14    4:3    49               CASE DAMTYPE OF
  5279  14    4:3    52               
  5280  14    4:3    52                 0, 3:  BATTLERC[ GROUPI].A.TEMP04[ CHARI].STATUS := ASLEEP;
  5281  14    4:3    70                 
  5282  14    4:3    70                    1:  BATTLERC[ GROUPI].A.TEMP04[ CHARI].INAUDCNT :=
  5283  14    4:4    84                          (RANDOM MOD 4) + 2;
  5284  14    4:4    96                          
  5285  14    4:3    96                    2:  BEGIN
  5286  14    4:5    96                          BATTLERC[ GROUPI].A.TEMP04[ CHARI].STATUS := DEAD;
  5287  14    4:5   112                          BATTLERC[ GROUPI].A.TEMP04[ CHARI].HPLEFT := 0
  5288  14    4:4   126                        END
  5289  14    4:3   128               END
  5290  14    4:2   146             END;
  5291  14    4:1   146           PRINTSTR( SDAMTYPE);
  5292  14    4:1   151           PAUSE1;
  5293  14    4:1   154           CLRRECT( 1, 13, 38, 1)
  5294  14    4:0   158         END;
  5295  14    4:0   174         
  5296  14    4:0   174         
  5297  14    5:D     3       FUNCTION CALCPTS( HITHEAL: THITHEAL) : INTEGER;  (* P010805 *)
  5298  14    5:D     7       
  5299  14    5:D     7         VAR
  5300  14    5:D     7              POINTS : INTEGER;
  5301  14    5:D     8              
  5302  14    5:0     0         BEGIN
  5303  14    5:1     0           POINTS := 0;
  5304  14    5:1     8           WHILE HITHEAL.HITS > 0 DO
  5305  14    5:2    13             BEGIN
  5306  14    5:3    13               POINTS := POINTS + (RANDOM MOD HITHEAL.HITRANGE) + 1;
  5307  14    5:3    26               HITHEAL.HITS := HITHEAL.HITS - 1
  5308  14    5:2    27             END;
  5309  14    5:1    33           CALCPTS := POINTS + HITHEAL.HITMIN
  5310  14    5:0    34         END;
  5311  14    5:0    52         
  5312  14    5:0    52         
  5313  14    6:D     1       PROCEDURE MODAC( GROUPI: INTEGER;  (* P010806 *)
  5314  14    6:D     2                        ACMOD:  INTEGER;
  5315  14    6:D     3                        CHARF:  INTEGER;
  5316  14    6:D     4                        CHARL:  INTEGER);
  5317  14    6:D     5                          
  5318  14    6:D     5         VAR
  5319  14    6:D     5              X : INTEGER;
  5320  14    6:D     6       
  5321  14    6:0     0         BEGIN
  5322  14    6:1     0           FOR X := CHARF TO CHARL DO
  5323  14    6:2    11             BATTLERC[ GROUPI].A.TEMP04[ X].ARMORCL :=
  5324  14    6:2    25               BATTLERC[ GROUPI].A.TEMP04[ X].ARMORCL + ACMOD;
  5325  14    6:0    48         END;
  5326  14    6:0    62         
  5327  14    6:0    62         
  5328  14    7:D     1       PROCEDURE DOHEAL( GROUPI:   INTEGER;   (* P010807 *)
  5329  14    7:D     2                         CHARI:    INTEGER;
  5330  14    7:D     3                         HITCNT:   INTEGER;
  5331  14    7:D     4                         HITRANGE: INTEGER);
  5332  14    7:D     5       
  5333  14    7:D     5         VAR
  5334  14    7:D     5              HITHEAL : THITHEAL;
  5335  14    7:D     8              POINTS  : INTEGER;
  5336  14    7:D     9       
  5337  14    7:0     0         BEGIN
  5338  14    7:1     0           HITHEAL.HITS     := HITCNT;
  5339  14    7:1     3           HITHEAL.HITRANGE := HITRANGE;
  5340  14    7:1     6           HITHEAL.HITMIN   := 0;
  5341  14    7:1     9           POINTS := CALCPTS( HITHEAL);
  5342  14    7:1    17           BATTLERC[ GROUPI].A.TEMP04[ CHARI].HPLEFT :=
  5343  14    7:1    31             BATTLERC[ GROUPI].A.TEMP04[ CHARI].HPLEFT + POINTS;
  5344  14    7:1    47           IF CHARACTR[ CHARI].HPMAX < 
  5345  14    7:1    54                BATTLERC[ GROUPI].A.TEMP04[ CHARI].HPLEFT THEN
  5346  14    7:2    70             BATTLERC[ GROUPI].A.TEMP04[ CHARI].HPLEFT :=
  5347  14    7:2    84               CHARACTR[ CHARI].HPMAX;
  5348  14    7:1    92           DSPNAMES( GROUPI, CHARI);
  5349  14    7:1    96           IF CHARACTR[ CHARI].HPMAX =
  5350  14    7:1   103                BATTLERC[ GROUPI].A.TEMP04[ CHARI].HPLEFT THEN
  5351  14    7:2   119             PRINTSTR( 'IS FULLY HEALED')
  5352  14    7:1   137           ELSE
  5353  14    7:2   142             PRINTSTR( 'IS PARTIALLY HEALED')
  5354  14    7:0   164         END;
  5355  14    7:0   180         
  5356  14    7:0   180         
  5357  14    8:D     1       PROCEDURE DOHITS( GROUPI:   INTEGER;  (* P010808 *)
  5358  14    8:D     2                         CHARI:    INTEGER;
  5359  14    8:D     3                         HITCNT:   INTEGER;
  5360  14    8:D     4                         HITRANGE: INTEGER);
  5361  14    8:D     5       
  5362  14    8:D     5         VAR
  5363  14    8:D     5             HITHEAL : THITHEAL;
  5364  14    8:D     8             POINTS  : INTEGER;
  5365  14    8:D     9       
  5366  14    8:0     0         BEGIN
  5367  14    8:1     0           HITHEAL.HITS     := HITCNT;
  5368  14    8:1     3           HITHEAL.HITRANGE := HITRANGE;
  5369  14    8:1     6           HITHEAL.HITMIN   := 0;
  5370  14    8:1     9           POINTS := CALCPTS( HITHEAL);
  5371  14    8:1    17           IF GROUPI > 0 THEN
  5372  14    8:2    22             IF BATTLERC[ GROUPI].B.UNAFFCT > 0 THEN
  5373  14    8:3    36               IF (RANDOM MOD 100) < BATTLERC[ GROUPI].B.UNAFFCT THEN
  5374  14    8:4    56                 POINTS := 0;
  5375  14    8:1    59           UNAFFECT( GROUPI, CHARI, POINTS)
  5376  14    8:0    62         END;
  5377  14    8:0    76         
  5378  14    8:0    76         
  5379  14    9:D     1       PROCEDURE DOHOLD;  (* P010809 *)
  5380  14    9:D     1       
  5381  14    9:D     1         VAR
  5382  14    9:D     1             CHARX : INTEGER;
  5383  14    9:D     2             
  5384  14    9:0     0         BEGIN
  5385  14    9:1     0           FOR CHARX := 0 TO BATTLERC[ CASTGR].A.ALIVECNT - 1 DO
  5386  14    9:2    22             IF BATTLERC[ CASTGR].A.TEMP04[ CHARX].STATUS <= ASLEEP THEN
  5387  14    9:3    41               IF CASTGR = 0 THEN
  5388  14    9:4    48                 ISISNOT( CASTGR,
  5389  14    9:4    51                          CHARX,
  5390  14    9:4    52                          50 + 10 * CHARACTR[ CHARX].CHARLEV,
  5391  14    9:4    63                          'HELD',
  5392  14    9:4    70                          0)
  5393  14    9:3    71               ELSE
  5394  14    9:4    75                 ISISNOT( CASTGR,
  5395  14    9:4    78                          CHARX,
  5396  14    9:4    79                          50 + 10 * BATTLERC[ CASTGR].B.HPREC.LEVEL,
  5397  14    9:4    94                          'HELD',
  5398  14    9:4   101                          0)
  5399  14    9:4   102                  
  5400  14    9:0   102         END;
  5401  14    9:0   126         
  5402  14    9:0   126         
  5403  14   10:D     1       PROCEDURE DOSILENC;  (* P01080A *)
  5404  14   10:D     1       
  5405  14   10:D     1         VAR
  5406  14   10:D     1              CHARX : INTEGER;
  5407  14   10:D     2       
  5408  14   10:0     0         BEGIN
  5409  14   10:1     0           FOR CHARX := 0 TO BATTLERC[ CASTGR].A.ALIVECNT - 1 DO
  5410  14   10:2    22             IF CASTGR = 0 THEN
  5411  14   10:3    29               ISISNOT( CASTGR,
  5412  14   10:3    32                        CHARX,
  5413  14   10:3    33                         100 - 5 * CHARACTR[ CHARX].LUCKSKIL[ 4],
  5414  14   10:3    49                        'SILENCED',
  5415  14   10:3    60                        1)
  5416  14   10:2    61             ELSE
  5417  14   10:3    65               ISISNOT( CASTGR,
  5418  14   10:3    68                        CHARX,
  5419  14   10:3    69                        10 * BATTLERC[ CASTGR].B.HPREC.LEVEL, 
  5420  14   10:3    82                        'SILENCED',
  5421  14   10:3    93                        1)
  5422  14   10:0    94         END;
  5423  14   10:0   118         
  5424  14   10:0   118         
  5425  14   11:D     1       PROCEDURE DODISRUP;  (* P01080B *)
  5426  14   11:D     1       
  5427  14   11:0     0         BEGIN
  5428  14   11:1     0           MVCURSOR( 1, 13);
  5429  14   11:1     5           PRINTSTR( 'SPELL DISRUPTED')
  5430  14   11:0    23         END;
  5431  14   11:0    38         
  5432  14   11:0    38         
  5433  14   12:D     1       PROCEDURE DOSLAIN( GROUPI: INTEGER;  (* P01080C *)
  5434  14   12:D     2                          CHARI:  INTEGER);
  5435  14   12:D     3       
  5436  14   12:D     3         VAR
  5437  14   12:D     3              CHNOTSLN : INTEGER;
  5438  14   12:D     4       
  5439  14   12:0     0         BEGIN
  5440  14   12:1     0           IF GROUPI = 0 THEN
  5441  14   12:2     5             CHNOTSLN := CHARACTR[ CHARI].CHARLEV
  5442  14   12:1    10           ELSE
  5443  14   12:2    16             CHNOTSLN := BATTLERC[ GROUPI].B.HPREC.LEVEL;
  5444  14   12:1    27           ISISNOT( GROUPI, CHARI, 10 * CHNOTSLN, 'SLAIN', 2)
  5445  14   12:0    41         END;
  5446  14   12:0    56         
  5447  14   12:0    56         
  5448  14   13:D     1       PROCEDURE DOSLEPT;  (* P01080D *)
  5449  14   13:D     1       
  5450  14   13:D     1         VAR
  5451  14   13:D     1              CHARX : INTEGER;
  5452  14   13:D     2       
  5453  14   13:0     0         BEGIN
  5454  14   13:1     0           FOR CHARX := 0 TO BATTLERC[ CASTGR].A.ALIVECNT - 1 DO
  5455  14   13:2    22             IF BATTLERC[ CASTGR].A.TEMP04[ CHARX].STATUS < ASLEEP THEN
  5456  14   13:3    41               IF CASTGR > 0 THEN
  5457  14   13:4    48                 BEGIN
  5458  14   13:5    48                 IF BATTLERC[ CASTGR].B.SPPC[ 4] THEN
  5459  14   13:6    67                   ISISNOT( CASTGR,
  5460  14   13:6    70                            CHARX,
  5461  14   13:6    71                            20 * BATTLERC[ CASTGR].B.HPREC.LEVEL,
  5462  14   13:6    84                            'SLEPT',
  5463  14   13:6    92                            3)
  5464  14   13:4    93                 END
  5465  14   13:3    95               ELSE
  5466  14   13:4    97                 ISISNOT( CASTGR,
  5467  14   13:4   100                          CHARX,
  5468  14   13:4   101                          20 * CHARACTR[ CHARX].CHARLEV,
  5469  14   13:4   110                          'SLEPT',
  5470  14   13:4   118                          3)
  5471  14   13:0   119         END;
  5472  14   13:0   142         
  5473  14   13:0   142         
  5474  14   14:D     1       PROCEDURE HAMMAHAM( MAHAMFLG: INTEGER);  (* P01080E *)
  5475  14   14:D     2       
  5476  14   14:D     2         VAR
  5477  14   14:D     2              TEMP2    : INTEGER;  (* MULTIPLE USES *)
  5478  14   14:D     3              TEMP1    : INTEGER;  (* MULTIPLE USES *)
  5479  14   14:D     4       
  5480  14   14:D     4       
  5481  14   15:D     1         PROCEDURE HAMCURE;  (* P01080F *)
  5482  14   15:D     1         
  5483  14   15:D     1           VAR
  5484  14   15:D     1                HITHEAL : THITHEAL;
  5485  14   15:D     4         
  5486  14   15:0     0           BEGIN
  5487  14   15:1     0             PRINTSTR( 'DIALKO''S PARTY 3 TIMES');
  5488  14   15:1    28             HITHEAL.HITS := 9;
  5489  14   15:1    31             HITHEAL.HITRANGE := 8;
  5490  14   15:1    34             HITHEAL.HITMIN := 0;
  5491  14   15:1    37             FOR TEMP1 := 0 TO PARTYCNT - 1 DO
  5492  14   15:2    53               IF BATTLERC[ 0].A.TEMP04[ TEMP1].STATUS < DEAD THEN
  5493  14   15:3    72                 BEGIN
  5494  14   15:4    72                   WITH  BATTLERC[ 0].A.TEMP04[ TEMP1] DO
  5495  14   15:5    88                     BEGIN
  5496  14   15:6    88                       STATUS := OK;
  5497  14   15:6    93                       INAUDCNT := 0;
  5498  14   15:6    98                       HPLEFT := HPLEFT + CALCPTS( HITHEAL);
  5499  14   15:6   111                       IF HPLEFT > CHARACTR[ TEMP1].HPMAX THEN
  5500  14   15:7   125                         HPLEFT := CHARACTR[ TEMP1].HPMAX;
  5501  14   15:5   138                     END
  5502  14   15:3   138                 END
  5503  14   15:0   138           END;
  5504  14   15:0   162           
  5505  14   15:0   162           
  5506  14   16:D     1         PROCEDURE HAMSILEN;  (* P010810 *)
  5507  14   16:D     1         
  5508  14   16:0     0           BEGIN
  5509  14   16:1     0             PRINTSTR( 'SILENCES MONSTERS!');
  5510  14   16:1    24             FOR TEMP1 := 1 TO 3 DO
  5511  14   16:2    38               FOR TEMP2 := 0 TO BATTLERC[ TEMP1].A.ALIVECNT - 1 DO
  5512  14   16:3    63                 BATTLERC[ TEMP1].A.TEMP04[ TEMP2].INAUDCNT :=
  5513  14   16:3    81                   5 + (RANDOM MOD 5)
  5514  14   16:0    89           END;
  5515  14   16:0   128           
  5516  14   16:0   128           
  5517  14   17:D     1         PROCEDURE HAMMAGIC;  (* P010811 *)
  5518  14   17:D     1         
  5519  14   17:0     0           BEGIN
  5520  14   17:1     0             PRINTSTR( 'ZAPS MONSTER MAGIC RESISTANCE!');
  5521  14   17:1    36             FOR TEMP1 := 1 TO 3 DO
  5522  14   17:2    50               BEGIN
  5523  14   17:3    50                 BATTLERC[ TEMP1].B.UNAFFCT := 0
  5524  14   17:2    62               END
  5525  14   17:0    64           END;
  5526  14   17:0    88           
  5527  14   17:0    88           
  5528  14   18:D     1         PROCEDURE HAMTELEP;  (* P010812 *)    (* NAME IS FROM MESSAGE *)
  5529  14   18:D     1         
  5530  14   18:0     0           BEGIN
  5531  14   18:1     0             PRINTSTR( 'DESTROYS MONSTERS!');
  5532  14   18:1    24             FOR TEMP1 := 1 TO 4 DO
  5533  14   18:2    38               BEGIN
  5534  14   18:3    38                 FOR TEMP2 := 0 TO BATTLERC[ TEMP1].A.ALIVECNT - 1 DO
  5535  14   18:4    63                   BEGIN
  5536  14   18:5    63                     BATTLERC[ TEMP1].A.TEMP04[ TEMP2].STATUS := DEAD;
  5537  14   18:5    83                     BATTLERC[ TEMP1].A.TEMP04[ TEMP2].HPLEFT := 0
  5538  14   18:4   101                   END;
  5539  14   18:3   113                 BATTLERC[ TEMP1].A.ALIVECNT := 0
  5540  14   18:2   124               END
  5541  14   18:0   126           END;
  5542  14   18:0   152           
  5543  14   18:0   152           
  5544  14   19:D     1         PROCEDURE HAMHEAL;  (* P010813 *)
  5545  14   19:D     1         
  5546  14   19:0     0           BEGIN
  5547  14   19:1     0             PRINTSTR( 'HEALS PARTY!');
  5548  14   19:1    18             FOR TEMP1 := 0 TO PARTYCNT - 1 DO
  5549  14   19:2    34               IF BATTLERC[ 0].A.TEMP04[ TEMP1].STATUS < DEAD THEN
  5550  14   19:3    53                 BEGIN
  5551  14   19:4    53                   WITH BATTLERC[ 0].A.TEMP04[ TEMP1] DO
  5552  14   19:5    69                     BEGIN
  5553  14   19:6    69                       STATUS := OK;
  5554  14   19:6    74                       INAUDCNT := 0;
  5555  14   19:6    79                       HPLEFT := CHARACTR[ TEMP1].HPMAX
  5556  14   19:5    89                     END;
  5557  14   19:3    92                 END
  5558  14   19:0    92           END;
  5559  14   19:0   116           
  5560  14   19:0   116           
  5561  14   20:D     1         PROCEDURE HAMPROT; (* P010814 *)
  5562  14   20:D     1         
  5563  14   20:0     0           BEGIN
  5564  14   20:1     0             PRINTSTR( 'SHIELDS PARTY');
  5565  14   20:1    19             FOR TEMP1 := 0 TO PARTYCNT - 1 DO
  5566  14   20:2    35               IF CHARACTR[ TEMP1].ARMORCL > -10 THEN
  5567  14   20:3    49                 CHARACTR[ TEMP1].ARMORCL := -10
  5568  14   20:0    58           END;
  5569  14   20:0    86           
  5570  14   20:0    86           
  5571  14   21:D     1         PROCEDURE HAMALIVE;  (* P010815 *)
  5572  14   21:D     1         
  5573  14   21:0     0           BEGIN
  5574  14   21:1     0             PRINTSTR( 'RESSURECTS AND ');
  5575  14   21:1    21             FOR TEMP1 := 0 TO PARTYCNT - 1 DO
  5576  14   21:2    37               IF BATTLERC[ 0].A.TEMP04[ TEMP1].STATUS <> LOST THEN
  5577  14   21:3    56                 BATTLERC[ 0].A.TEMP04[ TEMP1].STATUS := OK;
  5578  14   21:1    84             HAMHEAL
  5579  14   21:0    84           END;
  5580  14   21:0   100       
  5581  14   21:0   100       
  5582  14   22:D     1         PROCEDURE HAMMANGL;  (* P010816 *)
  5583  14   22:D     1         
  5584  14   22:D     1           VAR
  5585  14   22:D     1                SPELLI : INTEGER;
  5586  14   22:D     2               
  5587  14   22:0     0           BEGIN (* HAMMANGL *)
  5588  14   22:1     0             MVCURSOR( 1, 14);
  5589  14   22:1     5             PRINTSTR( 'BUT HIS SPELL BOOKS ARE MANGLED!');
  5590  14   22:1    43             FOR SPELLI := 1 TO 50 DO
  5591  14   22:2    54               BEGIN
  5592  14   22:3    54                 IF (RANDOM MOD 100) > 50 THEN
  5593  14   22:4    65                   CHARACTR[ TEMP1].SPELLSKN[ SPELLI] := FALSE
  5594  14   22:2    78               END
  5595  14   22:0    80           END; (* HAMMANGL *)
  5596  14   22:0   102       
  5597  14   22:0   102       
  5598  14   14:0     0         BEGIN  (* HAMMAHAM *)
  5599  14   14:1     0           IF MAHAMFLG = 7 THEN
  5600  14   14:2     5             PRINTSTR( 'MA');
  5601  14   14:1    13           PRINTSTR( 'HAMAN IS INTONED AND...');
  5602  14   14:1    42           PAUSE2;
  5603  14   14:1    45           MVCURSOR( 1, 13);
  5604  14   14:1    50           IF CHARACTR[ BATI].CHARLEV < 13 THEN
  5605  14   14:2    63             BEGIN
  5606  14   14:3    63               PRINTSTR( 'FAILS!');
  5607  14   14:3    75               EXIT( HAMMAHAM)
  5608  14   14:2    79             END;
  5609  14   14:1    79           CHARACTR[ BATI].CHARLEV := CHARACTR[ BATI].CHARLEV - 1;
  5610  14   14:1   100           DRAINED[ BATI] := TRUE;
  5611  14   14:1   110           
  5612  14   14:1   110           CASE RANDOM MOD 3 * MAHAMFLG OF     (* MAHAMFLG IS 6 OR 7 *)
  5613  14   14:1   121              0,  1,  2,  3,  4,  5:  HAMCURE;   (*     1? 2? 3? 4? 5? *)
  5614  14   14:1   125                  7,  8,  9, 10, 11:  HAMSILEN;  (*     8? 9? 10? 11?  *)
  5615  14   14:1   129                     12, 13, 22, 23:  HAMMAGIC;  (*    13?, 22?, 23?   *)
  5616  14   14:1   133                         14, 20, 21:  HAMTELEP;  (*    14?, 20?        *)
  5617  14   14:1   137                          6, 15, 19:  HAMHEAL;   (*    15?, 19?        *)
  5618  14   14:1   141                                 17:  HAMPROT;   (*    17?      DEAD CODE    *)
  5619  14   14:1   145                             16, 18:  HAMALIVE;  (*    16?, 18? DEAD CODE    *)
  5620  14   14:1   149                             
  5621  14   14:1   149           (* MAYBE THEY WANTED "RANDOM MOD (3 * MAHAMFLG)",
  5622  14   14:1   149              AND MAHAMFLG = 6 OR 8 DEPENDING ON SPELL *)
  5623  14   14:1   149                             
  5624  14   14:1   149                             
  5625  14   14:1   149           END;
  5626  14   14:1   204           IF (RANDOM MOD CHARACTR[ BATI].CHARLEV) = 5 THEN
  5627  14   14:2   223             HAMMANGL
  5628  14   14:0   223         END;   (* HAMMAHAM *)
  5629  14   14:0   238         
  5630  14   14:0   238         
  5631  14   23:D     1       PROCEDURE HITGROUP( GROUPI:  INTEGER;  (* P010817 *)
  5632  14   23:D     2                           HITSX:   INTEGER;
  5633  14   23:D     3                           HITSR:   INTEGER;
  5634  14   23:D     4                           TEMP99I: INTEGER);
  5635  14   23:D     5       
  5636  14   23:D     5         VAR
  5637  14   23:D     5              CHARI : INTEGER;
  5638  14   23:D     6       
  5639  14   23:0     0         BEGIN
  5640  14   23:1     0           IF BATTLERC[ GROUPI].A.ALIVECNT > 0 THEN
  5641  14   23:2    12             FOR CHARI := 0 TO BATTLERC[ GROUPI].A.ALIVECNT - 1 DO
  5642  14   23:3    32               BEGIN
  5643  14   23:4    32                 IF GROUPI = 0 THEN
  5644  14   23:5    37                   BATTLERC[ 0].B.WEPVSTY3 := CHARACTR[ CHARI].WEPVSTY3[ 1];
  5645  14   23:4    59                 IF BATTLERC[ GROUPI].B.WEPVSTY3[ TEMP99I] THEN
  5646  14   23:5    76                   DOHITS( GROUPI, CHARI, HITSX DIV 2 + 1, HITSR)
  5647  14   23:4    84                 ELSE
  5648  14   23:5    88                   DOHITS( GROUPI, CHARI, HITSX, HITSR)
  5649  14   23:3    92               END
  5650  14   23:0    94         END;
  5651  14   23:0   116         
  5652  14   23:0   116         
  5653  14   24:D     1       PROCEDURE SLOKTOFE;  (* P010818 *)
  5654  14   24:D     1       
  5655  14   24:D     1         VAR
  5656  14   24:D     1              POSSX :  INTEGER;
  5657  14   24:D     2              TEMPXX : INTEGER; (* MULTIPLE USES *)
  5658  14   24:D     3       
  5659  14   24:0     0         BEGIN
  5660  14   24:1     0           IF (RANDOM MOD 100) >  2 * CHARACTR[ BATI].CHARLEV THEN
  5661  14   24:2    21             BEGIN
  5662  14   24:3    21               MVCURSOR( 1, 13);
  5663  14   24:3    26               PRINTSTR( 'LOKTOFEIT FAILS!');
  5664  14   24:3    48               EXIT( SLOKTOFE)
  5665  14   24:2    52             END;
  5666  14   24:1    52           FOR TEMPXX := 0 TO PARTYCNT - 1 DO
  5667  14   24:2    65             BEGIN
  5668  14   24:3    65               FOR POSSX := 1 TO CHARACTR[ TEMPXX].POSS.POSSCNT DO
  5669  14   24:4    82                 WITH CHARACTR[ TEMPXX].POSS.POSSESS[ POSSX] DO
  5670  14   24:5    96                   BEGIN
  5671  14   24:6    96                     EQINDEX := 0;
  5672  14   24:6   101                     IDENTIF := FALSE;
  5673  14   24:6   106                     CURSED  := FALSE;
  5674  14   24:6   111                     EQUIPED := FALSE
  5675  14   24:5   112                   END;
  5676  14   24:3   121               CHARACTR[ TEMPXX].POSS.POSSCNT := 0;
  5677  14   24:3   130               CHARACTR[ TEMPXX].GOLD.HIGH := 0;
  5678  14   24:3   139               CHARACTR[ TEMPXX].GOLD.MID  := 0
  5679  14   24:2   146             END;
  5680  14   24:1   155           XGOTO := XCHK4WIN;
  5681  14   24:1   158           WRITE( CHR( 12));
  5682  14   24:1   166           TEXTMODE;
  5683  14   24:1   169           EXIT( COMBAT)(* EXITCOMB *)
  5684  14   24:0   173         END;
  5685  14   24:0   190         
  5686  14   24:0   190         
  5687  14   25:D     1       PROCEDURE SMAKANIT;  (* P010819 *)
  5688  14   25:D     1         
  5689  14   25:D     1         VAR
  5690  14   25:D     1              ENEMYX  : INTEGER;
  5691  14   25:D     2              GROUPI  : INTEGER;
  5692  14   25:D     3              
  5693  14   25:D     3           
  5694  14   25:0     0         BEGIN (* SMAKANIT *)
  5695  14   25:1     0           FOR GROUPI := 1 TO 4 DO
  5696  14   25:2    11             BEGIN
  5697  14   25:3    11               IF BATTLERC[ GROUPI].A.ALIVECNT > 0 THEN
  5698  14   25:4    23                 BEGIN
  5699  14   25:5    23                   MVCURSOR( 1, 13);
  5700  14   25:5    28                   IF BATTLERC[ GROUPI].A.IDENTIFI THEN
  5701  14   25:6    38                     PRINTSTR( BATTLERC[ GROUPI].B.NAMES)
  5702  14   25:5    47                   ELSE
  5703  14   25:6    52                     PRINTSTR(BATTLERC[ GROUPI].B.NAMEUNKS);
  5704  14   25:6    64                               
  5705  14   25:5    64                   IF BATTLERC[ GROUPI].B.CLASS = 10 THEN
  5706  14   25:6    77                     PRINTSTR( ' ARE UNAFFECTED!')
  5707  14   25:5    96                   ELSE
  5708  14   25:6   101                     IF BATTLERC[ GROUPI].B.HPREC.LEVEL > 7 THEN
  5709  14   25:7   114                       PRINTSTR( ' SURVIVE!')
  5710  14   25:6   126                     ELSE
  5711  14   25:7   131                       BEGIN
  5712  14   25:8   131                         PRINTSTR( ' PERISH!');
  5713  14   25:8   145                         FOR ENEMYX := 0 TO BATTLERC[ GROUPI].A.ALIVECNT DO
  5714  14   25:9   163                           BEGIN
  5715  14   25:0   163                             WITH BATTLERC[ GROUPI].A.TEMP04[ ENEMYX] DO
  5716  14   25:1   177                               BEGIN
  5717  14   25:2   177                                 HPLEFT := 0;
  5718  14   25:2   182                                 STATUS := DEAD
  5719  14   25:1   185                               END
  5720  14   25:9   187                           END
  5721  14   25:7   187                       END;
  5722  14   25:5   194                   PAUSE1;
  5723  14   25:5   197                   CLRRECT( 1, 13, 38, 1)
  5724  14   25:4   201                 END
  5725  14   25:2   204             END
  5726  14   25:0   204         END;  (* SMAKANIT *)
  5727  14   25:0   232         
  5728  14   25:0   232         
  5729  14   26:D     1       PROCEDURE SMALOR;  (* P01081A *)
  5730  14   26:D     1       
  5731  14   26:D     1         VAR
  5732  14   26:D     1              UNUSEDXX : INTEGER;
  5733  14   26:D     2              UNUSEDYY : INTEGER;
  5734  14   26:D     3              
  5735  14   26:0     0         BEGIN
  5736  14   26:1     0           MAZEX := RANDOM MOD 20;
  5737  14   26:1     9           MAZEY := RANDOM MOD 20;
  5738  14   26:1    18           WHILE (RANDOM MOD 100) < 30 DO
  5739  14   26:2    29             MAZELEV := MAZELEV - 1;
  5740  14   26:1    37           WHILE (RANDOM MOD 100) < 10 DO
  5741  14   26:2    48             MAZELEV := MAZELEV - 1;
  5742  14   26:1    56           IF MAZELEV < SCNTOC.RECPERDK[ ZMAZE] THEN
  5743  14   26:2    68             MAZELEV := SCNTOC.RECPERDK[ ZMAZE];
  5744  14   26:1    77           CLRRECT( 13, 1, 26, 4);
  5745  14   26:1    84           IF MAZELEV = 0 THEN
  5746  14   26:2    90             BEGIN
  5747  14   26:3    90               XGOTO := XCHK4WIN;
  5748  14   26:3    93               WRITE( CHR(12));
  5749  14   26:3   101               TEXTMODE
  5750  14   26:2   101             END
  5751  14   26:1   104           ELSE
  5752  14   26:2   106             XGOTO := XNEWMAZE;
  5753  14   26:1   109           EXIT( COMBAT)
  5754  14   26:0   113         END;
  5755  14   26:0   130         
  5756  14   26:0   130         
  5757  14   27:D     1       PROCEDURE DOPRIEST;  (* P01081B *)
  5758  14   27:D     1       
  5759  14   27:D     1         VAR
  5760  14   27:D     1              GROUPI : INTEGER;
  5761  14   27:D     2       
  5762  14   27:0     0         BEGIN
  5763  14   27:1     0           IF SPELL = KALKI THEN
  5764  14   27:2     9             MODAC( 0, 1, 0, PARTYCNT - 1);
  5765  14   27:1    17           IF SPELL = DIOS THEN
  5766  14   27:2    26             DOHEAL( 0, CASTGR, 1, 8);
  5767  14   27:1    34           IF SPELL = BADIOS THEN
  5768  14   27:2    43             DOHITS( CASTGR, CASTI, 1, 8);
  5769  14   27:1    53           IF SPELL = MILWA THEN
  5770  14   27:2    62             LIGHT := LIGHT + 15 + (RANDOM MOD 15);
  5771  14   27:1    75           IF SPELL = PORFIC THEN
  5772  14   27:2    84             MODAC( 0, 4, BATI, BATI);
  5773  14   27:1    94           IF SPELL = MATU THEN
  5774  14   27:2   103             MODAC( 0, 2, 0, PARTYCNT - 1);
  5775  14   27:1   111           IF SPELL = MANIFO THEN
  5776  14   27:2   120             DOHOLD;
  5777  14   27:1   122           IF SPELL = MONTINO THEN
  5778  14   27:2   131             DOSILENC;
  5779  14   27:1   133           IF SPELL = LOMILWA THEN
  5780  14   27:2   142             LIGHT := 32000;
  5781  14   27:1   147           IF SPELL = DIALKO THEN
  5782  14   27:2   156             BEGIN
  5783  14   27:3   156               DSPNAMES( 0, CASTGR);
  5784  14   27:3   162               IF (BATTLERC[ 0].A.TEMP04[ CASTGR].STATUS = PLYZE) OR
  5785  14   27:3   179                  (BATTLERC[ 0].A.TEMP04[ CASTGR].STATUS = ASLEEP) THEN
  5786  14   27:4   199                 BEGIN
  5787  14   27:5   199                   BATTLERC[ 0].A.TEMP04[ CASTGR].STATUS := OK;
  5788  14   27:5   217                   PRINTSTR( 'IS CURED!')
  5789  14   27:4   229                 END
  5790  14   27:3   232               ELSE
  5791  14   27:4   234                 PRINTSTR( 'IS NOT HELPED!');
  5792  14   27:2   254             END;
  5793  14   27:1   254           IF SPELL = LATUMAPI THEN
  5794  14   27:2   263             BEGIN
  5795  14   27:3   263               FOR GROUPI := 1 TO 4 DO
  5796  14   27:4   274                 BATTLERC[ LLBASE04].A.IDENTIFI := TRUE;  (* BUG? WITH BASE04*)
  5797  14   27:2   290             END;
  5798  14   27:1   290           IF SPELL = BAMATU THEN
  5799  14   27:2   299             MODAC( 0, 4, 0, PARTYCNT - 1);
  5800  14   27:1   307           IF SPELL = DIAL THEN
  5801  14   27:2   316             DOHEAL( 0, CASTGR, 2, 8);
  5802  14   27:1   324           IF SPELL = BADIAL THEN
  5803  14   27:2   333             DOHITS( CASTGR, CASTI, 2, 8);
  5804  14   27:1   343           IF SPELL = LATUMOFI THEN
  5805  14   27:2   352             BEGIN
  5806  14   27:3   352               DSPNAMES( 0, CASTGR);
  5807  14   27:3   358               PRINTSTR( 'IS UNPOISONED!');
  5808  14   27:3   378               CHARACTR[ CASTGR].LOSTXYL.POISNAMT[ 1] := 0
  5809  14   27:2   392             END;
  5810  14   27:1   394           IF SPELL = MAPORFIC THEN
  5811  14   27:2   403             ACMOD2 := 2;
  5812  14   27:1   406           IF SPELL = DIALMA THEN
  5813  14   27:2   415             DOHEAL( 0, CASTGR, 3, 8);
  5814  14   27:1   423           IF SPELL = BADIALMA THEN
  5815  14   27:2   432             DOHITS( CASTGR, CASTI, 3, 8);
  5816  14   27:1   442           IF SPELL = LITOKAN THEN
  5817  14   27:2   451             HITGROUP( CASTGR, 3, 8, 1);
  5818  14   27:1   459           IF SPELL = KANDI THEN
  5819  14   27:2   468             DODISRUP;
  5820  14   27:1   470           IF SPELL = DI THEN
  5821  14   27:2   479             DODISRUP;
  5822  14   27:1   481           IF SPELL = BADI THEN
  5823  14   27:2   490             DOSLAIN( CASTGR, CASTI);
  5824  14   27:1   498           IF SPELL = LORTO THEN
  5825  14   27:2   507             HITGROUP( CASTGR, 6, 6, 0);
  5826  14   27:1   515           IF SPELL = MADI THEN
  5827  14   27:2   524             BEGIN
  5828  14   27:3   524               BATTLERC[ 0].A.TEMP04[ CASTGR].HPLEFT :=
  5829  14   27:3   540                 CHARACTR[ CASTGR].HPMAX;
  5830  14   27:3   550               IF BATTLERC[ 0].A.TEMP04[ CASTGR].STATUS < DEAD THEN
  5831  14   27:4   569                 BATTLERC[ 0].A.TEMP04[ CASTGR].STATUS := OK;
  5832  14   27:3   587               CHARACTR[ CASTGR].LOSTXYL.POISNAMT[ 1] := 0;
  5833  14   27:3   603               DOHEAL( 0, CASTGR, 1, 1)
  5834  14   27:2   609             END;
  5835  14   27:1   611           IF SPELL = MABADI THEN
  5836  14   27:2   620             BEGIN
  5837  14   27:3   620               CLRRECT( 1, 12, 38, 3);
  5838  14   27:3   627               MVCURSOR( 1, 12);
  5839  14   27:3   632               DSPNAMES( CASTGR, CASTI);
  5840  14   27:3   640               PRINTSTR( ' IS HIT BY MABADI!');
  5841  14   27:3   664                BATTLERC[ CASTGR].A.TEMP04[ CASTI].HPLEFT := 
  5842  14   27:3   682                  1 + (RANDOM MOD 8);
  5843  14   27:2   692             END;
  5844  14   27:1   692           IF SPELL = LOKTOFEI THEN
  5845  14   27:2   701             SLOKTOFE;
  5846  14   27:1   703           IF SPELL = MALIKTO THEN
  5847  14   27:2   712             FOR GROUPI := 1 TO 4 DO
  5848  14   27:3   723               HITGROUP( GROUPI, 12, 6, 0);
  5849  14   27:1   736           IF SPELL = KADORTO THEN
  5850  14   27:2   745             DODISRUP
  5851  14   27:0   745         END;
  5852  14   27:0   764         
  5853  14   27:0   764         
  5854  14   28:D     1       PROCEDURE DOMAGE;  (* P01081C *)
  5855  14   28:D     1       
  5856  14   28:D     1         VAR
  5857  14   28:D     1              GROUPI : INTEGER;  (* MULTIPLE USES *)
  5858  14   28:D     2       
  5859  14   28:0     0         BEGIN
  5860  14   28:1     0           IF SPELL = HALITO THEN
  5861  14   28:2     9             DOHITS( CASTGR, CASTI, 1, 8);
  5862  14   28:1    19           IF SPELL = MOGREF THEN
  5863  14   28:2    28             MODAC( 0, 2, BATI, BATI);
  5864  14   28:1    38           IF SPELL = KATINO THEN
  5865  14   28:2    47             DOSLEPT;
  5866  14   28:1    49           IF SPELL = DILTO THEN
  5867  14   28:2    58             MODAC( CASTGR, -2, 0, BATTLERC[ CASTGR].A.ALIVECNT - 1);
  5868  14   28:1    78           IF SPELL = SOPIC THEN
  5869  14   28:2    87             MODAC( 0, 4, BATI, BATI);
  5870  14   28:1    97           IF SPELL = MAHALITO THEN
  5871  14   28:2   106             HITGROUP( CASTGR, 4, 6, 1);
  5872  14   28:1   114           IF SPELL = MOLITO THEN
  5873  14   28:2   123             HITGROUP( CASTGR, 3, 6, 0);
  5874  14   28:1   131           IF SPELL = MORLIS THEN
  5875  14   28:2   140             MODAC( CASTGR, -3, 0, BATTLERC[ CASTGR].A.ALIVECNT - 1);
  5876  14   28:1   160           IF SPELL = DALTO THEN
  5877  14   28:2   169             HITGROUP( CASTGR, 6, 6, 2);
  5878  14   28:1   177           IF SPELL = LAHALITO THEN
  5879  14   28:2   186             HITGROUP( CASTGR, 6, 6, 1);
  5880  14   28:1   194           IF SPELL = MAMORLIS THEN
  5881  14   28:2   203             FOR GROUPI := 1 TO 4 DO
  5882  14   28:3   214               MODAC( GROUPI, -3, 1, BATTLERC[ GROUPI].A.ALIVECNT);
  5883  14   28:1   235           IF SPELL = MAKANITO THEN
  5884  14   28:2   244             SMAKANIT;
  5885  14   28:1   246           IF SPELL = MADALTO THEN
  5886  14   28:2   255             HITGROUP( CASTGR, 8, 8, 2);
  5887  14   28:1   263           IF SPELL = LAKANITO THEN
  5888  14   28:2   272             FOR GROUPI := 0 TO BATTLERC[ CASTGR].A.ALIVECNT - 1 DO
  5889  14   28:3   294               IF BATTLERC[ CASTGR].A.TEMP04[ GROUPI].STATUS < DEAD THEN
  5890  14   28:4   313                 ISISNOT( CASTGR, GROUPI, 6 * BATTLERC[ CASTGR].B.HPREC.LEVEL,
  5891  14   28:4   330                          'SMOTHERED', 2);
  5892  14   28:1   352           IF SPELL = ZILWAN THEN
  5893  14   28:2   361             IF BATTLERC[ CASTGR].B.CLASS = 10 THEN
  5894  14   28:3   376               DOHITS( CASTGR, CASTI, 10, 200);
  5895  14   28:1   388           IF SPELL = MASOPIC THEN
  5896  14   28:2   397             MODAC( 0, 4, 0, PARTYCNT - 1);
  5897  14   28:1   405           IF SPELL = HAMAN THEN
  5898  14   28:2   414             HAMMAHAM( 6);
  5899  14   28:1   417           IF SPELL = MALOR THEN
  5900  14   28:2   426             SMALOR;
  5901  14   28:1   428           IF SPELL = MAHAMAN THEN
  5902  14   28:2   437             HAMMAHAM( 7);
  5903  14   28:1   440           IF SPELL = TILTOWAIT THEN
  5904  14   28:2   449             IF BATG = 0 THEN
  5905  14   28:3   456               FOR GROUPI := 1 TO 4 DO
  5906  14   28:4   467                 HITGROUP( GROUPI, 10, 15, 0)
  5907  14   28:2   471             ELSE
  5908  14   28:3   482               HITGROUP( 0, 10, 15, 0)
  5909  14   28:0   486         END;
  5910  14   28:0   506         
  5911  14   28:0   506         
  5912  14   29:D     1       PROCEDURE EXITCAST( EXITSTR: STRING);  (* P01081D *)
  5913  14   29:D    43       
  5914  14   29:0     0         BEGIN
  5915  14   29:1     0           MVCURSOR( 1, 12);
  5916  14   29:1    10           PRINTSTR( EXITSTR);
  5917  14   29:1    15           EXIT( CASTASPE)
  5918  14   29:0    19         END;
  5919  14   29:0    32         
  5920  14   29:0    32         
  5921  14    1:0     0       BEGIN  (* CASTASPE P010801 *)
  5922  14    1:1     0         DSPNAMES( BATG, BATI);
  5923  14    1:1     8         PRINTSTR( 'CASTS A SPELL');
  5924  14    1:1    27         IF BATTLERC[ BATG].A.TEMP04[ BATI].INAUDCNT > 0 THEN
  5925  14    1:2    48           EXITCAST( 'WHICH FAILS TO BECOME AUDIBLE!');
  5926  14    1:1    83         IF FIZZLES > 0 THEN
  5927  14    1:2    88           EXITCAST( 'WHICH FIZZLES OUT');
  5928  14    1:1   110         IF BATG = 0 THEN
  5929  14    1:2   117           BEGIN
  5930  14    1:3   117             CASTGR := BATTLERC[ 0].A.TEMP04[ BATI].VICTIM;
  5931  14    1:3   134             IF (CASTGR > 0) AND (CASTGR < 5) THEN
  5932  14    1:4   143               IF BATTLERC[ CASTGR].A.ALIVECNT > 0 THEN
  5933  14    1:5   155                 CASTI := BATI MOD BATTLERC[ CASTGR].A.ALIVECNT;
  5934  14    1:3   169             SPELL := BATTLERC[ 0].A.TEMP04[ BATI].SPELLHSH;
  5935  14    1:2   186           END
  5936  14    1:1   186         ELSE
  5937  14    1:2   188           BEGIN
  5938  14    1:3   188             CASTGR := 0;
  5939  14    1:3   191             CASTI  := BATTLERC[ BATG].A.TEMP04[ BATI].VICTIM;
  5940  14    1:3   210             SPELL  := BATTLERC[ BATG].A.TEMP04[ BATI].SPELLHSH
  5941  14    1:2   226           END;
  5942  14    1:1   229         MVCURSOR( 1, 12);
  5943  14    1:1   234         DOMAGE;
  5944  14    1:1   236         DOPRIEST
  5945  14    1:0   236       END;   (* CASTASPE P010801 *)
  5946  14    1:0   250     
  5947  14    1:0   250 (*$I WIZ1B:COMBAT4   *)
  5947  14    1:0   250 (*$I WIZ1B:COMBAT5   *)
  5948  14    1:0   250 
  5949  15    1:D     1 SEGMENT PROCEDURE SWINGASW;  (* P010901 *)
  5950  15    1:D     1     
  5951  15    1:D     1     
  5952  15    2:D     1     PROCEDURE ARMATTK;  (* P010902 *)
  5953  15    2:D     1       
  5954  15    2:0     0         BEGIN
  5955  15    2:1     0           CASE (RANDOM MOD 5) OF
  5956  15    2:1     9             0:  PRINTSTR( 'SWINGS');
  5957  15    2:1    23             1:  PRINTSTR( 'THRUSTS');
  5958  15    2:1    38             2:  PRINTSTR( 'STABS');
  5959  15    2:1    51             3:  PRINTSTR( 'SLASHES');
  5960  15    2:1    66             4:  PRINTSTR( 'CHOPS')
  5961  15    2:1    74           END
  5962  15    2:0    96         END;
  5963  15    2:0   108       
  5964  15    2:0   108       
  5965  15    3:D     1     PROCEDURE PRNAME( GROUPI: INTEGER;  (* P010903 *)
  5966  15    3:D     2                       CHARX:  INTEGER);
  5967  15    3:D     3                      
  5968  15    3:0     0       BEGIN
  5969  15    3:1     0         IF GROUPI = 0 THEN
  5970  15    3:2     5           PRINTSTR(  CHARACTR[ CHARX].NAME)
  5971  15    3:1    10         ELSE IF BATTLERC[ GROUPI].A.IDENTIFI THEN
  5972  15    3:3    25           PRINTSTR(  BATTLERC[ GROUPI].B.NAME)
  5973  15    3:2    34         ELSE
  5974  15    3:3    39           PRINTSTR( BATTLERC[ GROUPI].B.NAMEUNK);
  5975  15    3:1    51         PRINTSTR( ' ')
  5976  15    3:0    52       END;
  5977  15    3:0    68         
  5978  15    3:0    68 
  5979  15    4:D     1       PROCEDURE UNAFFECT( GROUPI: INTEGER;
  5980  15    4:D     2                           CHARI:  INTEGER;
  5981  15    4:D     3                           HITDAM: INTEGER);  (* P010904 *)
  5982  15    4:D     4       
  5983  15    4:D     4         (* COMBINATION OF UNAFFECT AND BREATHDM IN LOL *)
  5984  15    4:D     4       
  5985  15    4:0     0         BEGIN
  5986  15    4:1     0           CLRRECT( 1, 12, 38, 3);
  5987  15    4:1     7           IF BATTLERC[ GROUPI].A.TEMP04[ CHARI].STATUS >= DEAD THEN
  5988  15    4:2    24             EXIT( UNAFFECT);
  5989  15    4:1    28           MVCURSOR( 1, 12);
  5990  15    4:1    33           PRNAME( GROUPI, CHARI);
  5991  15    4:1    37           IF GROUPI <> 0 THEN
  5992  15    4:2    42             BEGIN
  5993  15    4:3    42               IF BATTLERC[ GROUPI].B.UNAFFCT > (RANDOM MOD 100) THEN
  5994  15    4:4    62                  HITDAM := 0;
  5995  15    4:2    65             END;
  5996  15    4:1    65           IF HITDAM = 0 THEN
  5997  15    4:2    70             PRINTSTR( 'IS UNAFFECTED!')
  5998  15    4:1    87           ELSE
  5999  15    4:2    92             BEGIN
  6000  15    4:3    92               PRINTSTR( 'TAKES ');
  6001  15    4:3   104               PRINTNUM( HITDAM, 4);
  6002  15    4:3   109               PRINTSTR( ' DAMAGE');
  6003  15    4:3   122               WITH BATTLERC[ GROUPI].A.TEMP04[ CHARI] DO
  6004  15    4:4   136                 BEGIN
  6005  15    4:5   136                   HPLEFT := HPLEFT - HITDAM;
  6006  15    4:5   144                   IF HPLEFT <= 0 THEN
  6007  15    4:6   150                     BEGIN
  6008  15    4:7   150                       HPLEFT := 0;
  6009  15    4:7   155                       STATUS := DEAD;
  6010  15    4:7   160                       MVCURSOR( 1, 14);
  6011  15    4:7   165                       PRNAME( GROUPI, CHARI);
  6012  15    4:7   169                       PRINTSTR( 'IS SLAIN!');
  6013  15    4:6   184                     END
  6014  15    4:4   184                 END
  6015  15    4:2   184             END;
  6016  15    4:1   184           PAUSE1
  6017  15    4:0   184         END;
  6018  15    4:0   200         
  6019  15    4:0   200         
  6020  15    5:D     3       FUNCTION CALCHP( AHPREC: THPREC) : INTEGER;  (* P010905 *)
  6021  15    5:D     7                            
  6022  15    5:D     7         VAR
  6023  15    5:D     7              HITPTS : INTEGER;
  6024  15    5:D     8              
  6025  15    5:0     0         BEGIN
  6026  15    5:1     0           HITPTS := 0;
  6027  15    5:1     8           WHILE AHPREC.LEVEL > 0 DO
  6028  15    5:2    13             BEGIN
  6029  15    5:3    13               HITPTS := HITPTS + (RANDOM MOD AHPREC.HPFAC) + 1;
  6030  15    5:3    26               AHPREC.LEVEL := AHPREC.LEVEL - 1
  6031  15    5:2    27             END;
  6032  15    5:1    33           CALCHP := HITPTS + AHPREC.HPMINAD
  6033  15    5:0    34         END;
  6034  15    5:0    52         
  6035  15    5:0    52         
  6036  15    6:D     1       PROCEDURE DOBREATH;  (* P010906 *)
  6037  15    6:D     1       
  6038  15    6:D     1         VAR
  6039  15    6:D     1              UNUSED : INTEGER;
  6040  15    6:D     2              HITDAM : INTEGER;
  6041  15    6:D     3              CHARX  : INTEGER;
  6042  15    6:D     4       
  6043  15    6:0     0         BEGIN
  6044  15    6:1     0           PRINTSTR(  'BREATHES!');
  6045  15    6:1    15           FOR CHARX := 0 TO PARTYCNT - 1 DO
  6046  15    6:2    28             BEGIN
  6047  15    6:3    28               IF BATTLERC[ 0].A.TEMP04[ CHARX].STATUS < DEAD THEN
  6048  15    6:4    45                 BEGIN
  6049  15    6:5    45                   CLRRECT( 1, 12, 38, 3);
  6050  15    6:5    52                   MVCURSOR( 1, 12);
  6051  15    6:5    57                   HITDAM := BATTLERC[ BATG].A.TEMP04[ BATI].HPLEFT DIV 2;
  6052  15    6:5    78                   IF (RANDOM MOD 20) >= CHARACTR[ CHARX].LUCKSKIL[ 3] THEN
  6053  15    6:6   100                     HITDAM := (HITDAM + 1) DIV 2;
  6054  15    6:5   107                   IF CHARACTR[ CHARX].WEPVSTY3[ 1][ BATTLERC[ BATG].B.BREATHE] 
  6055  15    6:5   132                       THEN
  6056  15    6:6   135                     HITDAM := (HITDAM + 1) DIV 2;
  6057  15    6:5   142                   UNAFFECT( 0, CHARX, HITDAM)
  6058  15    6:4   145                 END
  6059  15    6:2   147             END
  6060  15    6:0   147         END;
  6061  15    6:0   168     
  6062  15    6:0   168         
  6063  15    6:0   168       
  6064  15    7:D     1       PROCEDURE DOFIGHT;  (* P010907 *)
  6065  15    7:D     1       
  6066  15    8:D     1         PROCEDURE DAM2ME;  (* P010908 *)
  6067  15    8:D     1         
  6068  15    8:D     1           VAR
  6069  15    8:D     1                HPCALCPC : INTEGER;
  6070  15    8:D     2                RECSI    : INTEGER;
  6071  15    8:D     3                MYVICTIM : INTEGER;
  6072  15    8:D     4                HPDAMAGE : INTEGER;
  6073  15    8:D     5                HITSCNT  : INTEGER;
  6074  15    8:D     6         
  6075  15    8:D     6         
  6076  15    9:D     1           PROCEDURE CASEDAMG;  (* P010909 *)
  6077  15    9:D     1           
  6078  15   10:D     1             PROCEDURE DRAINLEV;  (* P01090A *)
  6079  15   10:D     1             
  6080  15   10:0     0               BEGIN 
  6081  15   10:1     0                 IF CHARACTR[ MYVICTIM].WEPVSTY3[ 1][ 4] THEN
  6082  15   10:2    19                   EXIT( DRAINLEV);
  6083  15   10:1    23                 CHARACTR[ MYVICTIM].CHARLEV := CHARACTR[ MYVICTIM].CHARLEV -
  6084  15   10:1    41                   BATTLERC[ BATG].B.DRAINAMT;
  6085  15   10:1    55                 MVCURSOR( 1, 14);
  6086  15   10:1    60                 CLRRECT( 1, 14, 38, 1);
  6087  15   10:1    67                 PRINTNUM( BATTLERC[ BATG].B.DRAINAMT, 2);
  6088  15   10:1    83                 IF BATTLERC[ BATG].B.DRAINAMT = 1 THEN
  6089  15   10:2    99                   PRINTSTR( ' LEVEL')
  6090  15   10:1   108                 ELSE
  6091  15   10:2   113                   PRINTSTR( ' LEVELS');
  6092  15   10:1   126                 PRINTSTR( ' ARE DRAINED!');
  6093  15   10:1   145                 IF CHARACTR[ MYVICTIM].CHARLEV < 1 THEN
  6094  15   10:2   158                   BEGIN
  6095  15   10:3   158                     CHARACTR[ MYVICTIM].CHARLEV := 0;
  6096  15   10:3   169                     BATTLERC[ 0].A.TEMP04[ MYVICTIM].HPLEFT := 0;
  6097  15   10:3   187                     BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS := LOST
  6098  15   10:2   203                   END
  6099  15   10:1   205                 ELSE
  6100  15   10:2   207                   BEGIN
  6101  15   10:3   207                     CHARACTR[ MYVICTIM].HPMAX := 
  6102  15   10:3   216                       (CHARACTR[ MYVICTIM].HPMAX DIV
  6103  15   10:3   225                        CHARACTR[ MYVICTIM].MAXLEVAC) *
  6104  15   10:3   235                                                    CHARACTR[ MYVICTIM].CHARLEV;
  6105  15   10:3   246                     CHARACTR[ MYVICTIM].MAXLEVAC :=
  6106  15   10:3   255                                                    CHARACTR[ MYVICTIM].CHARLEV;
  6107  15   10:3   265                     IF CHARACTR[ MYVICTIM].HPLEFT >
  6108  15   10:3   274                                                  CHARACTR[ MYVICTIM].HPMAX THEN
  6109  15   10:4   286                       CHARACTR[ MYVICTIM].HPLEFT := CHARACTR[ MYVICTIM].HPMAX;
  6110  15   10:3   305                     DRAINED[ MYVICTIM] := TRUE
  6111  15   10:2   313                   END;
  6112  15   10:1   315                 PAUSE1
  6113  15   10:0   315               END;   (* DRAINLEV *)
  6114  15   10:0   330               
  6115  15   10:0   330               
  6116  15   11:D     1             PROCEDURE RESULT( ATTK0123: INTEGER;  (* P01090B *)
  6117  15   11:D     2                               STONFLAG: INTEGER;
  6118  15   11:D     3                               POISSTON: INTEGER;
  6119  15   11:D     4                               DAMSTR:   STRING);
  6120  15   11:D    46             
  6121  15   11:D    46               VAR
  6122  15   11:D    46                    CHANCBAD : INTEGER;
  6123  15   11:D    47             
  6124  15   11:0     0               BEGIN
  6125  15   11:1     0                 IF (RANDOM MOD 20) >
  6126  15   11:1    12                                   CHARACTR[ MYVICTIM].LUCKSKIL[ STONFLAG] THEN
  6127  15   11:2    29                   EXIT( RESULT);
  6128  15   11:1    33                 IF ATTK0123 = 3 THEN
  6129  15   11:2    38                   BEGIN
  6130  15   11:3    38                     CHANCBAD := BATTLERC[ BATG].B.HPREC.LEVEL * 2;
  6131  15   11:3    53                     IF CHANCBAD > 50 THEN
  6132  15   11:4    59                       CHANCBAD := 50;
  6133  15   11:3    62                     IF (RANDOM MOD 100) > CHANCBAD THEN
  6134  15   11:4    74                       EXIT( RESULT)
  6135  15   11:2    78                   END;
  6136  15   11:1    78                 IF POISSTON > 0 THEN
  6137  15   11:2    83                   IF CHARACTR[ MYVICTIM].WEPVSTY3[ 1][ POISSTON] THEN
  6138  15   11:3   102                     EXIT( RESULT);
  6139  15   11:1   106                 IF CHARACTR[ MYVICTIM].STATUS >= DEAD THEN
  6140  15   11:2   119                   EXIT( RESULT);
  6141  15   11:1   123                 CLRRECT( 1, 14, 38, 1);
  6142  15   11:1   130                 MVCURSOR( 1, 14);
  6143  15   11:1   135                 PRNAME( 0, MYVICTIM);
  6144  15   11:1   141                 PRINTSTR( 'IS ');
  6145  15   11:1   150                 PRINTSTR( DAMSTR );
  6146  15   11:1   155                 CASE ATTK0123 OF
  6147  15   11:1   158                 
  6148  15   11:1   158                   0:  IF BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS < STONED THEN
  6149  15   11:3   177                         BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS := STONED;
  6150  15   11:3   197                 
  6151  15   11:1   197                   1:  CHARACTR[ MYVICTIM].LOSTXYL.POISNAMT[ 1] := 1;
  6152  15   11:1   215                      
  6153  15   11:1   215                   2:  IF BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS < PLYZE THEN
  6154  15   11:3   234                         BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS := PLYZE;
  6155  15   11:3   254                        
  6156  15   11:1   254                   3:  BEGIN
  6157  15   11:3   254                         BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS := DEAD;
  6158  15   11:3   272                         BATTLERC[ 0].A.TEMP04[ MYVICTIM].HPLEFT := 0
  6159  15   11:2   288                       END
  6160  15   11:1   290                 END;
  6161  15   11:1   308                 PAUSE1
  6162  15   11:0   308               END;  (* RESULT *)
  6163  15   11:0   326             
  6164  15   11:0   326             
  6165  15    9:0     0             BEGIN  (* CASEDAMG *)
  6166  15    9:1     0               WITH BATTLERC[ BATG].B DO
  6167  15    9:2    13                 BEGIN
  6168  15    9:3    13                   IF SPPC[ 1] THEN
  6169  15    9:4    23                     RESULT( 1, 0, 3, 'POISONED');
  6170  15    9:3    39                   IF SPPC[ 2] THEN
  6171  15    9:4    49                     RESULT( 2, 0, 0, 'PARALYZED');
  6172  15    9:3    66                   IF SPPC[ 0] THEN
  6173  15    9:4    76                     RESULT( 0, 1, 5, 'STONED');
  6174  15    9:4    90                     
  6175  15    9:3    90                   IF DRAINAMT > 0 THEN
  6176  15    9:4    97                     DRAINLEV;
  6177  15    9:4    99                     
  6178  15    9:3    99                   IF SPPC[ 3] THEN
  6179  15    9:4   109                     RESULT( 3, 0, 0, 'CRITICALLY HIT')
  6180  15    9:2   129                 END
  6181  15    9:0   131             END;  (* CASEDAMG *)
  6182  15    9:0   144             
  6183  15    9:0   144             
  6184  15   12:D     1           PROCEDURE ATTKSTRG;  (* P01090C *)
  6185  15   12:D     1           
  6186  15   13:D     1             PROCEDURE RIPBITCL;  (* P01090D *)
  6187  15   13:D     1             
  6188  15   13:0     0               BEGIN
  6189  15   13:1     0                 CASE (RANDOM MOD 5) OF
  6190  15   13:1     9                   0:  PRINTSTR( 'TEARS');
  6191  15   13:1    22                   1:  PRINTSTR( 'RIPS');
  6192  15   13:1    34                   2:  PRINTSTR( 'GNAWS');
  6193  15   13:1    47                   3:  PRINTSTR( 'BITES');
  6194  15   13:1    60                   4:  PRINTSTR( 'CLAWS')
  6195  15   13:1    68                 END
  6196  15   13:0    90               END;
  6197  15   13:0   102               
  6198  15   13:0   102               
  6199  15   14:D     1             PROCEDURE ARMRIP;  (* P01090E *)
  6200  15   14:D     1             
  6201  15   14:0     0               BEGIN
  6202  15   14:1     0                 IF (RANDOM MOD 2) = 1 THEN
  6203  15   14:2    11                   RIPBITCL
  6204  15   14:1    11                 ELSE
  6205  15   14:2    15                   ARMATTK
  6206  15   14:0    15               END;
  6207  15   14:0    30             
  6208  15   14:0    30             
  6209  15   12:0     0             BEGIN (* ATTKSTRG *)
  6210  15   12:1     0               CASE BATTLERC[ BATG].B.CLASS OF
  6211  15   12:1    13                 0, 1, 2, 3, 4, 5, 10, 11: ARMATTK;
  6212  15   12:1    17                             6, 8, 12, 13: RIPBITCL;
  6213  15   12:1    21                                     7, 9: ARMRIP;
  6214  15   12:1    25               END
  6215  15   12:0    60             END;
  6216  15   12:0    72           
  6217  15   12:0    72           
  6218  15    8:0     0           BEGIN (* DAM2ME *)
  6219  15    8:1     0             IF BATTLERC[ 0].A.TEMP04[ VICTIM].STATUS >= DEAD THEN
  6220  15    8:2    19               EXIT( DAM2ME);
  6221  15    8:1    23             PRNAME( BATG, BATI);
  6222  15    8:1    31             ATTKSTRG;
  6223  15    8:1    33             PRINTSTR( ' AT');
  6224  15    8:1    42             MVCURSOR( 1, 12);
  6225  15    8:1    47             PRINTSTR( CHARACTR[ VICTIM].NAME);
  6226  15    8:1    57             MYVICTIM := VICTIM;
  6227  15    8:1    62             IF BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS < DEAD THEN
  6228  15    8:2    79               BEGIN
  6229  15    8:3    79                 HPCALCPC :=
  6230  15    8:3    79                   20
  6231  15    8:3    79                   - CHARACTR[ MYVICTIM].ARMORCL 
  6232  15    8:3    85                   - BATTLERC[ BATG].B.HPREC.LEVEL
  6233  15    8:3    97                   + ACMOD2
  6234  15    8:3   100                   + BATTLERC[ 0].A.TEMP04[ MYVICTIM].ARMORCL
  6235  15    8:3   114                   + 2 * (ORD( BATTLERC[ BATG].A.TEMP04[ MYVICTIM].SPELLHSH = 0));
  6236  15    8:3   138               
  6237  15    8:3   138                 IF HPCALCPC < 1 THEN
  6238  15    8:4   143                   HPCALCPC := 1
  6239  15    8:3   143                 ELSE
  6240  15    8:4   148                   IF HPCALCPC > 19 THEN
  6241  15    8:5   153                     HPCALCPC := 19;
  6242  15    8:3   156                 HPDAMAGE := 0;
  6243  15    8:3   159                 HITSCNT := 0;
  6244  15    8:3   162                 MVCURSOR( 1, 13);
  6245  15    8:3   167                 FOR RECSI := 1 TO BATTLERC[ BATG].B.RECSN DO
  6246  15    8:4   188                   IF (RANDOM MOD 20) >= HPCALCPC THEN
  6247  15    8:5   199                     BEGIN
  6248  15    8:6   199                       HPDAMAGE := HPDAMAGE +
  6249  15    8:6   200                        CALCHP( BATTLERC[ BATG].B.RECS[ RECSI]);
  6250  15    8:6   223                       HITSCNT := HITSCNT + 1
  6251  15    8:5   224                     END;
  6252  15    8:3   235                 IF BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS = ASLEEP THEN
  6253  15    8:4   252                   HPDAMAGE := HPDAMAGE * 2;
  6254  15    8:3   257                 IF HPDAMAGE = 0 THEN
  6255  15    8:4   262                     PRINTSTR( 'AND MISSES!')
  6256  15    8:3   276                 ELSE
  6257  15    8:4   281                   BEGIN
  6258  15    8:5   281                     PRINTSTR( 'AND HITS ');
  6259  15    8:5   296                     PRINTNUM( HITSCNT, 3);
  6260  15    8:5   301                     PRINTSTR( ' TIMES FOR ');
  6261  15    8:5   318                     PRINTNUM( HPDAMAGE, 3);
  6262  15    8:5   323                     PRINTSTR( ' DAMAGE');
  6263  15    8:5   336                     CASEDAMG
  6264  15    8:4   336                   END;
  6265  15    8:4   338                 
  6266  15    8:3   338                 BATTLERC[ 0].A.TEMP04[ MYVICTIM].HPLEFT :=
  6267  15    8:3   352                   BATTLERC[ 0].A.TEMP04[ MYVICTIM].HPLEFT - HPDAMAGE;
  6268  15    8:3   368                 IF BATTLERC[ 0].A.TEMP04[ MYVICTIM].HPLEFT <= 0 THEN
  6269  15    8:4   385                   BEGIN
  6270  15    8:5   385                     CLRRECT( 1, 14, 38, 1);
  6271  15    8:5   392                     MVCURSOR( 1, 14);
  6272  15    8:5   397                     PRINTSTR( CHARACTR[ MYVICTIM].NAME);
  6273  15    8:5   405                     PRINTSTR( ' IS SLAIN!');
  6274  15    8:5   421                     BATTLERC[ 0].A.TEMP04[ MYVICTIM].HPLEFT := 0;
  6275  15    8:5   437                     IF BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS < DEAD THEN
  6276  15    8:6   454                       BATTLERC[ 0].A.TEMP04[ MYVICTIM].STATUS := DEAD
  6277  15    8:4   468                   END
  6278  15    8:2   470               END
  6279  15    8:0   470           END;  (* DAM2ME *)
  6280  15    8:0   486           
  6281  15    8:0   486           
  6282  15   15:D     1         PROCEDURE DAM2ENMY;  (* P01090F *)
  6283  15   15:D     1         
  6284  15   15:D     1           VAR
  6285  15   15:D     1                HPCALCPC : INTEGER;
  6286  15   15:D     2                TEMPX    : INTEGER;  (* MULTIPLE USES *)
  6287  15   15:D     3                SINGLEX  : INTEGER;
  6288  15   15:D     4                HPDAMAGE : INTEGER;
  6289  15   15:D     5                HITSCNT  : INTEGER;
  6290  15   15:D     6         
  6291  15   15:0     0           BEGIN
  6292  15   15:1     0             SINGLEX := BATI MOD BATTLERC[ VICTIM].A.ALIVECNT;
  6293  15   15:1    16             IF BATTLERC[ VICTIM].A.TEMP04[ SINGLEX].STATUS < DEAD THEN
  6294  15   15:2    35               BEGIN
  6295  15   15:3    35                 PRNAME( BATG, BATI);
  6296  15   15:3    43                 ARMATTK;
  6297  15   15:3    45                 PRINTSTR( ' AT A');
  6298  15   15:3    56                 MVCURSOR( 1, 12);
  6299  15   15:3    61                 PRNAME( VICTIM, BATI);
  6300  15   15:3    69                 HPCALCPC := 21
  6301  15   15:3    69                               - BATTLERC[ VICTIM].B.AC
  6302  15   15:3    79                               - CHARACTR[ BATI].HPCALCMD
  6303  15   15:3    89                               + BATTLERC[ VICTIM].A.TEMP04[ SINGLEX].ARMORCL
  6304  15   15:3   106                               - 3 * VICTIM;
  6305  15   15:3   116                 IF HPCALCPC < 1 THEN
  6306  15   15:4   121                   HPCALCPC := 1
  6307  15   15:3   121                 ELSE
  6308  15   15:4   126                   IF HPCALCPC > 19 THEN
  6309  15   15:5   131                     HPCALCPC := 19;
  6310  15   15:3   134                 HPDAMAGE := 0;
  6311  15   15:3   137                 MVCURSOR( 1, 13);
  6312  15   15:3   142                 HITSCNT := 0;
  6313  15   15:3   145                 FOR TEMPX := 1 TO CHARACTR[ BATI].SWINGCNT DO
  6314  15   15:4   164                   IF (RANDOM MOD 20) >= HPCALCPC THEN
  6315  15   15:5   175                     BEGIN
  6316  15   15:6   175                       HPDAMAGE := HPDAMAGE + CALCHP( CHARACTR[ BATI].HPDAMRC);
  6317  15   15:6   192                       HITSCNT := HITSCNT + 1
  6318  15   15:5   193                     END;
  6319  15   15:3   204                 IF BATTLERC[ VICTIM].A.TEMP04[ SINGLEX].STATUS = ASLEEP THEN
  6320  15   15:4   223                   HPDAMAGE := 2 * HPDAMAGE;
  6321  15   15:3   228                 IF CHARACTR[ BATI].WEPVSTYP[ BATTLERC[ VICTIM].B.CLASS] THEN
  6322  15   15:4   254                   HPDAMAGE := 2 * HPDAMAGE;
  6323  15   15:3   259                 IF HPDAMAGE = 0 THEN
  6324  15   15:4   264                   PRINTSTR( 'AND MISSES')
  6325  15   15:3   277                 ELSE
  6326  15   15:4   282                   BEGIN
  6327  15   15:5   282                     PRINTSTR( 'AND HITS ');
  6328  15   15:5   297                     PRINTNUM( HITSCNT, 3);
  6329  15   15:5   302                     PRINTSTR( ' TIMES FOR ');
  6330  15   15:5   319                     PRINTNUM( HPDAMAGE, 3);
  6331  15   15:5   324                     PRINTSTR( ' DAMAGE!');
  6332  15   15:4   338                   END;
  6333  15   15:3   338                 BATTLERC[ VICTIM].A.TEMP04[ SINGLEX].HPLEFT :=
  6334  15   15:3   354                   BATTLERC[ VICTIM].A.TEMP04[ SINGLEX].HPLEFT - HPDAMAGE;
  6335  15   15:3   372                 IF (CHARACTR[ BATI].CRITHITM) AND (HPDAMAGE > 0) THEN
  6336  15   15:4   387                   BEGIN
  6337  15   15:5   387                     TEMPX := CHARACTR[ BATI].CHARLEV * 2;
  6338  15   15:5   400                     IF TEMPX > 50 THEN
  6339  15   15:6   405                       TEMPX := 50;
  6340  15   15:5   408                     IF (RANDOM MOD 100) < TEMPX THEN
  6341  15   15:6   419                       IF (RANDOM MOD 35) >
  6342  15   15:6   426                          BATTLERC[ VICTIM].B.HPREC.LEVEL + 10 THEN
  6343  15   15:7   442                         BEGIN
  6344  15   15:8   442                           MVCURSOR( 1, 14);
  6345  15   15:8   447                           PRINTSTR( 'A CRITICAL HIT!');
  6346  15   15:8   468                           WRITE( '');
  6347  15   15:8   481                           BATTLERC[ VICTIM].A.TEMP04[ SINGLEX].HPLEFT := 0;
  6348  15   15:8   499                           PAUSE1;
  6349  15   15:8   502                           CLRRECT( 1, 14, 38, 1)
  6350  15   15:7   506                         END;
  6351  15   15:4   509                   END;
  6352  15   15:3   509                 IF BATTLERC[ VICTIM].A.TEMP04[ SINGLEX].HPLEFT <= 0 THEN
  6353  15   15:4   528                   BEGIN
  6354  15   15:5   528                     MVCURSOR( 1, 14);
  6355  15   15:5   533                     PRNAME( 0, BATI);
  6356  15   15:5   539                     PRINTSTR( 'KILLS ONE!');
  6357  15   15:5   555                     BATTLERC[ VICTIM].A.TEMP04[ SINGLEX].HPLEFT := 0;
  6358  15   15:5   573                     BATTLERC[ VICTIM].A.TEMP04[ SINGLEX].STATUS := DEAD
  6359  15   15:4   589                   END
  6360  15   15:2   591               END
  6361  15   15:0   591           END;
  6362  15   15:0   608           
  6363  15   15:0   608           
  6364  15    7:0     0         BEGIN  (* DOFIGHT *)
  6365  15    7:1     0           IF BATG = 0 THEN
  6366  15    7:2     7             DAM2ENMY
  6367  15    7:1     7           ELSE
  6368  15    7:2    11             DAM2ME
  6369  15    7:0    11         END;
  6370  15    7:0    26         
  6371  15    7:0    26       
  6372  15    7:0    26       
  6373  15   16:D     1       PROCEDURE YELLHELP;  (* P010910 *)
  6374  15   16:D     1       
  6375  15   16:D     1         VAR
  6376  15   16:D     1              YHTEMP2 : INTEGER;
  6377  15   16:D     2       
  6378  15   16:D     2       
  6379  15   17:D     1         PROCEDURE NONECOME;  (* P010911 *)
  6380  15   17:D     1         
  6381  15   17:0     0           BEGIN
  6382  15   17:1     0             PRINTSTR( 'BUT NONE COMES!');
  6383  15   17:1    21             EXIT( YELLHELP)
  6384  15   17:0    25           END;
  6385  15   17:0    38         
  6386  15   17:0    38         
  6387  15   16:0     0         BEGIN  (* YELLHELP *)
  6388  15   16:1     0           PRINTSTR( 'CALLS FOR HELP!');
  6389  15   16:1    21           MVCURSOR( 1, 12);
  6390  15   16:1    26           IF BATTLERC[ BATG].A.ALIVECNT = 9 THEN
  6391  15   16:2    40             NONECOME;
  6392  15   16:1    42           IF (RANDOM MOD 200) > 10 * BATTLERC[ BATG].B.HPREC.LEVEL THEN
  6393  15   16:2    67             NONECOME;
  6394  15   16:1    69           PRINTSTR( 'AND IS HEARD!');
  6395  15   16:1    88           YHTEMP2 := BATTLERC[ BATG].A.ALIVECNT;
  6396  15   16:1   100           BATTLERC[ BATG].A.ALIVECNT := YHTEMP2 + 1;
  6397  15   16:1   115           BATTLERC[ BATG].A.ENMYCNT := BATTLERC[ BATG].A.ENMYCNT + 1;
  6398  15   16:1   139           WITH BATTLERC[ BATG].A.TEMP04[ YHTEMP2] DO
  6399  15   16:2   155             BEGIN
  6400  15   16:3   155               AGILITY  := -1;
  6401  15   16:3   161               SPELLHSH := 0;
  6402  15   16:3   166               INAUDCNT := BATTLERC[ BATG].A.TEMP04[ BATI].INAUDCNT;
  6403  15   16:3   187               ARMORCL  := 0;
  6404  15   16:3   192               HPLEFT   := CALCHP( BATTLERC[ BATG].B.HPREC);
  6405  15   16:3   211               STATUS   := OK;
  6406  15   16:2   216             END
  6407  15   16:0   216         END;  (* YELLHELP *)
  6408  15   16:0   228         
  6409  15   16:0   228         
  6410  15   18:D     1       PROCEDURE DORUN;  (* P010912 *)
  6411  15   18:D     1       
  6412  15   18:0     0         BEGIN
  6413  15   18:1     0           PRINTSTR( 'FLEES!');
  6414  15   18:1    12           BATTLERC[ BATG].A.ENMYCNT := BATTLERC[ BATG].A.ENMYCNT - 1;
  6415  15   18:1    36           WITH BATTLERC[ BATG].A.TEMP04[ BATI] DO
  6416  15   18:2    54             BEGIN
  6417  15   18:3    54               STATUS := DEAD;
  6418  15   18:3    59               HPLEFT := 0
  6419  15   18:2    62             END
  6420  15   18:0    64         END;
  6421  15   18:0    76         
  6422  15   18:0    76         
  6423  15   19:D     1       PROCEDURE DODISPEL;  (* P010913 *)
  6424  15   19:D     1       
  6425  15   19:D     1         VAR
  6426  15   19:D     1              DISPLCNT : INTEGER;
  6427  15   19:D     2              CHARX    : INTEGER;
  6428  15   19:D     3              DISPCALC : INTEGER;
  6429  15   19:D     4              
  6430  15   19:0     0         BEGIN
  6431  15   19:1     0           PRINTSTR( 'DISPELLS!');
  6432  15   19:1    15           DISPCALC := 50 + 5 * CHARACTR[ BATI].CHARLEV -
  6433  15   19:1    28                       10 * BATTLERC[ VICTIM].B.HPREC.LEVEL;
  6434  15   19:1    44                       
  6435  15   19:1    44           CASE CHARACTR[ BATI].CLASS OF
  6436  15   19:1    55             LORD:    DISPCALC := DISPCALC - 40;
  6437  15   19:1    62             BISHOP:  DISPCALC := DISPCALC - 20;
  6438  15   19:1    69           END;
  6439  15   19:1    82           
  6440  15   19:1    82           DISPLCNT := 0;
  6441  15   19:1    85           FOR CHARX := 0 TO BATTLERC[ VICTIM].A.ALIVECNT - 1 DO
  6442  15   19:2   107             IF BATTLERC[ VICTIM].A.TEMP04[ CHARX].STATUS = OK THEN
  6443  15   19:3   126               IF (RANDOM MOD 100) < DISPCALC THEN
  6444  15   19:4   137                 IF BATTLERC[ VICTIM].B.CLASS = 10 THEN
  6445  15   19:5   152                   BEGIN
  6446  15   19:6   152                     DISPLCNT := DISPLCNT + 1;
  6447  15   19:6   157                     BATTLERC[ VICTIM].A.ENMYCNT := 
  6448  15   19:6   168                       BATTLERC[ VICTIM].A.ENMYCNT - 1;
  6449  15   19:6   181                     BATTLERC[ VICTIM].A.TEMP04[ CHARX].STATUS := DEAD;
  6450  15   19:6   199                     BATTLERC[ VICTIM].A.TEMP04[ CHARX].HPLEFT := 0
  6451  15   19:5   215                   END;
  6452  15   19:1   224           MVCURSOR( 1, 12);
  6453  15   19:1   229           IF DISPLCNT = 0 THEN
  6454  15   19:2   234             PRINTSTR( 'TO NO AVAIL!')
  6455  15   19:1   249           ELSE
  6456  15   19:2   254             IF DISPLCNT = 1 THEN
  6457  15   19:3   259               PRINTSTR( '1 DISSOLVES!')
  6458  15   19:2   274             ELSE
  6459  15   19:3   279               BEGIN
  6460  15   19:4   279                 PRINTNUM( DISPLCNT, 1);
  6461  15   19:4   284                 PRINTSTR( ' DISSOLVE!')
  6462  15   19:3   297               END
  6463  15   19:0   300         END;
  6464  15   19:0   314         
  6465  15   19:0   314         
  6466  15    1:0     0       BEGIN  (* SWINGASW P010901 *)
  6467  15    1:1     0         IF ATTACKTY < -1 THEN
  6468  15    1:2     8           PRNAME( BATG, BATI);
  6469  15    1:1    16         CASE ATTACKTY OF
  6470  15    1:1    21           -5:  DODISPEL;
  6471  15    1:1    25           -4:  YELLHELP;
  6472  15    1:1    29           -3:  DOBREATH;
  6473  15    1:1    33           -2:  DORUN;
  6474  15    1:1    37           -1:  DOFIGHT;
  6475  15    1:1    41         END
  6476  15    1:0    58       END;   (* SWINGASW P010901 *)
  6477  15    1:0    70       
  6478  15    1:0    70       
  6479  13    1:0     0     BEGIN (* MELEE *)
  6480  13    1:1     0       FOR AGILELEV := 1 TO 10 DO
  6481  13    1:2    11         FOR BATG := 0 TO 4 DO
  6482  13    1:3    22           FOR BATI := 0 TO BATTLERC[ BATG].A.ALIVECNT - 1 DO
  6483  13    1:4    42             IF BATTLERC[ BATG].A.TEMP04[ BATI].STATUS = OK THEN
  6484  13    1:5    59               IF BATTLERC[ BATG].A.TEMP04[ BATI].AGILITY = AGILELEV THEN
  6485  13    1:6    76                 BEGIN
  6486  13    1:7    76                   VICTIM := BATTLERC[ BATG].A.TEMP04[ BATI].VICTIM;
  6487  13    1:7    91                   ATTACKTY := BATTLERC[ BATG].A.TEMP04[ BATI].SPELLHSH;
  6488  13    1:7   106                   MVCURSOR( 1, 11);
  6489  13    1:7   111                   IF (ATTACKTY >= -5) AND
  6490  13    1:7   115                      (ATTACKTY <   0) THEN
  6491  13    1:8   121                     SWINGASW                (* -5..-1 *)
  6492  13    1:7   121                   ELSE IF ATTACKTY > 0 THEN
  6493  13    1:9   131                     CASTASPE;
  6494  13    1:7   134                   IF ATTACKTY <> 0 THEN
  6495  13    1:8   139                     BEGIN
  6496  13    1:9   139                       PAUSE1;
  6497  13    1:9   142                       CLRRECT( 1, 11, 38, 4)
  6498  13    1:8   146                     END
  6499  13    1:6   149                 END
  6500  13    1:0   149     END;  (* MELEE *)
  6501  13    1:0   192     
  6502  13    1:0   192     
  6503  13    1:0   192 (* COMBAT SEGMENT *)
  6504  13    1:0   192       
  6505  13    1:0   192       
  6506  13    1:0   192     
  6507  10    1:0     0     BEGIN (* COMBAT P010401 *)
  6508  10    1:0     0     
  6509  10    1:1     0       DONEFIGH := FALSE;
  6510  10    1:1     3       CINITFL1 := 0;
  6511  10    1:1     6       CINIT;
  6512  10    1:1     9       XGOTO := XREWARD;
  6513  10    1:1    12       REPEAT
  6514  10    1:2    12         CUTIL;
  6515  10    1:2    15         IF NOT DONEFIGH THEN
  6516  10    1:3    19           MELEE;
  6517  10    1:1    22       UNTIL DONEFIGH;
  6518  10    1:1    25       CINITFL1 := 2;
  6519  10    1:1    28       CINIT
  6520  10    1:0    28     END;  (* COMBAT *)
  6521  10    1:0    46   
  6522  10    1:0    46 (*$I WIZ1B:COMBAT5   *)
  6523  10    1:0    46 
  6523  10    1:0    46 (*$I WIZ1C:CASTLE    *)
  6524  16    1:D     1   SEGMENT PROCEDURE CASTLE;     (* P010A01 *)
  6525  16    1:D     1   
  6526  16    1:D     1     TYPE
  6527  16    1:D     1          BYTE = PACKED ARRAY[ 0..1] OF 0..255;
  6528  16    1:D     1          
  6529  16    1:D     1     VAR
  6530  16    1:D     1          CPCALLED : RECORD CASE INTEGER OF  (* COPY PROTECTION CALLED *)
  6531  16    1:D     1            1: (I: INTEGER);
  6532  16    1:D     1            2: (P: ^BYTE);
  6533  16    1:D     1          END;
  6534  16    1:D     2       
  6535  16    1:D     2       
  6536  16    2:D     1     PROCEDURE GETPASS( VAR PASSWORD: STRING);  (* P010A02 *)
  6537  16    2:D     2                         
  6538  16    2:D     2       VAR
  6539  16    2:D     2            UNUSEDXX : INTEGER;
  6540  16    2:D     3            RANDX    : INTEGER;
  6541  16    2:D     4            CHRCNT   : INTEGER;
  6542  16    2:D     5                         
  6543  16    2:0     0       BEGIN
  6544  16    2:1     0         CHRCNT := 0;
  6545  16    2:1     3         REPEAT
  6546  16    2:2     3           GETKEY;
  6547  16    2:2     6           IF INCHAR <> CHR( CRETURN) THEN
  6548  16    2:3    11             IF CHRCNT < 15 THEN
  6549  16    2:4    16               BEGIN
  6550  16    2:5    16                 FOR RANDX := 0 TO (RANDOM MOD 2) DO
  6551  16    2:6    33                   WRITE( CHR( 88));
  6552  16    2:5    48                 CHRCNT := CHRCNT + 1;
  6553  16    2:5    53                 PASSWORD[ CHRCNT] := INCHAR
  6554  16    2:4    55               END
  6555  16    2:3    57             ELSE
  6556  16    2:4    59               WRITE( CHR(7))
  6557  16    2:1    67         UNTIL INCHAR = CHR( CRETURN);
  6558  16    2:1    72         WRITELN;
  6559  16    2:1    78         PASSWORD[ 0] := CHR( CHRCNT)
  6560  16    2:0    81       END;  (* GETPASS *)
  6561  16    2:0    98       
  6562  16    2:0    98       
  6563  16    3:D     1     PROCEDURE CHARINFO( CHARX: INTEGER);  (* P010A03 *)
  6564  16    3:D     2     
  6565  16    3:0     0       BEGIN
  6566  16    3:1     0         GOTOXY( 0, 5 + CHARX);
  6567  16    3:1     7         WRITE( CHR( 29));      (* ??? *)
  6568  16    3:1    15         WRITE( (CHARX + 1): 2);
  6569  16    3:1    25         WRITE( ' ');
  6570  16    3:1    33         WRITE( CHARACTR[ CHARX].NAME);
  6571  16    3:1    45         GOTOXY( 19, 5 + CHARX);
  6572  16    3:1    52         WRITE( COPY( SCNTOC.ALIGN[ CHARACTR[ CHARX].ALIGN], 1, 1));
  6573  16    3:1    80         WRITE( '-');
  6574  16    3:1    88         WRITE( COPY( SCNTOC.CLASS[ CHARACTR[ CHARX].CLASS], 1, 3));
  6575  16    3:1   116         WRITE( ' ');
  6576  16    3:1   124         IF CHARACTR[ CHARX].ARMORCL > - 10 THEN
  6577  16    3:2   136           WRITE( CHARACTR[ CHARX].ARMORCL :2)
  6578  16    3:1   150         ELSE
  6579  16    3:2   152           WRITE( 'LO');
  6580  16    3:1   164         WRITE( CHARACTR[ CHARX].HPLEFT :5);
  6581  16    3:1   178         WRITE( ' ');
  6582  16    3:1   186         IF CHARACTR[ CHARX].STATUS = OK THEN
  6583  16    3:2   197           IF CHARACTR[ CHARX].LOSTXYL.POISNAMT[ 1] <> 0 THEN
  6584  16    3:3   214             WRITELN( 'POISON')
  6585  16    3:2   236           ELSE
  6586  16    3:3   238             WRITELN( CHARACTR[ CHARX].HPMAX :4)
  6587  16    3:1   258         ELSE
  6588  16    3:2   260           WRITELN( SCNTOC.STATUS[ CHARACTR[ CHARX].STATUS])
  6589  16    3:0   285       END;
  6590  16    3:0   298       
  6591  16    3:0   298       
  6592  16    4:D     1     PROCEDURE DSPTITLE( TITLESTR: STRING); (* P010A04 *)
  6593  16    4:D    43     
  6594  16    4:0     0       BEGIN
  6595  16    4:1     0         IF CPCALLED.P^[ 0] <> 10 THEN
  6596  16    4:2    14           MVCURSOR( 70, 0);  (* CRASH AND BURN *)
  6597  16    4:1    19         GOTOXY( 0, 1);
  6598  16    4:1    24         WRITE( '! CASTLE');
  6599  16    4:1    42         WRITE( TITLESTR :30);
  6600  16    4:1    51         WRITE( ' !')
  6601  16    4:0    63       END;
  6602  16    4:0    76       
  6603  16    4:0    76       
  6604  16    5:D     1     PROCEDURE DSPPARTY( TITLE : STRING);  (* P010A05 *)
  6605  16    5:D    43     
  6606  16    5:D    43       VAR
  6607  16    5:D    43            CHARX : INTEGER;
  6608  16    5:D    44     
  6609  16    5:0     0       BEGIN
  6610  16    5:1     0         GOTOXY( 0, 0);
  6611  16    5:1    10         WRITELN( '+--------------------------------------+');
  6612  16    5:1    66         DSPTITLE( TITLE);
  6613  16    5:1    70         WRITELN;
  6614  16    5:1    76         WRITELN( '+----------- CURRENT PARTY: -----------+');
  6615  16    5:1   132         WRITELN;
  6616  16    5:1   138         WRITELN( ' # CHARACTER NAME  CLASS AC HITS STATUS' );
  6617  16    5:1   193         
  6618  16    5:1   193         FOR CHARX := 0 TO 5 DO
  6619  16    5:2   206           IF CHARX < PARTYCNT THEN
  6620  16    5:3   212             CHARINFO( CHARX)
  6621  16    5:2   214           ELSE
  6622  16    5:3   218             WRITELN( CHR( 29));
  6623  16    5:1   240         WRITELN( '+--------------------------------------+');
  6624  16    5:1   296         WRITE( CHR( 11))
  6625  16    5:0   304       END;  (* DSPPARTY *)
  6626  16    5:0   318       
  6627  16    5:0   318       
  6628  16    6:D     1     PROCEDURE GILGAMSH;  (*  P010A06 *)
  6629  16    6:D     1     
  6630  16    6:D     1       VAR
  6631  16    6:D     1            PRTYALGN : TALIGN;
  6632  16    6:D     2     
  6633  16    6:D     2     
  6634  16    7:D     1       PROCEDURE GETALIGN;  (* P010A07 *)
  6635  16    7:D     1       
  6636  16    7:0     0         BEGIN
  6637  16    7:1     0           PRTYALGN := NEUTRAL;
  6638  16    7:1     4           FOR LLBASE04 := 0 TO PARTYCNT - 1 DO
  6639  16    7:2    17             IF CHARACTR[ LLBASE04].ALIGN <> NEUTRAL THEN
  6640  16    7:3    28               PRTYALGN := CHARACTR[ LLBASE04].ALIGN
  6641  16    7:0    33         END;  (* GETALIGN *)
  6642  16    7:0    60         
  6643  16    7:0    60         
  6644  16    8:D     1       PROCEDURE GILGMENU;  (* P010A08 *)
  6645  16    8:D     1       
  6646  16    8:D     1         VAR
  6647  16    8:D     1              UNUSED : INTEGER;
  6648  16    8:D     2       
  6649  16    8:D     2       
  6650  16    8:0     0         BEGIN (* P010A08 *)
  6651  16    8:1     0           GOTOXY( 0, 13);
  6652  16    8:1     5           WRITE( CHR( 11));
  6653  16    8:1    13           WRITE( 'YOU MAY ');
  6654  16    8:1    31           IF PARTYCNT < 6 THEN
  6655  16    8:2    36             BEGIN
  6656  16    8:3    36               WRITE( 'A)DD A MEMBER');
  6657  16    8:3    59               IF PARTYCNT = 0 THEN
  6658  16    8:4    64                 WRITELN
  6659  16    8:3    64               ELSE
  6660  16    8:4    72                 WRITELN( ',');
  6661  16    8:3    86               WRITE( ' ' :8);
  6662  16    8:2    94             END;
  6663  16    8:1    94           IF PARTYCNT > 0 THEN
  6664  16    8:2    99             BEGIN
  6665  16    8:3    99               WRITELN( 'R)EMOVE A MEMBER,');
  6666  16    8:3   132               WRITE( ' ' :8);
  6667  16    8:3   140               WRITELN( '#) SEE A MEMBER,')
  6668  16    8:2   172             END
  6669  16    8:1   172           ELSE
  6670  16    8:2   174             BEGIN
  6671  16    8:3   174               WRITELN( CHR( 29));
  6672  16    8:3   188               WRITELN( CHR( 29))
  6673  16    8:2   202             END;
  6674  16    8:1   202           WRITELN;
  6675  16    8:1   208           WRITELN( 'OR PRESS [RETURN] TO LEAVE');
  6676  16    8:1   250           WRITE( CHR(11))
  6677  16    8:0   258         END;  (* P010A08 *)
  6678  16    8:0   270         
  6679  16    8:0   270         
  6680  16    9:D     1       PROCEDURE ADDPARTY;  (* P010A09 *)
  6681  16    9:D     1       
  6682  16    9:D     1         VAR
  6683  16    9:D     1              CHARI    : INTEGER;
  6684  16    9:D     2              CHARNAME : STRING;  (* MULTIPLE USES *)
  6685  16    9:D    43              
  6686  16    9:D    43 
  6687  16   10:D     1         PROCEDURE EXITADDP( EXITSTR: STRING);  (* P010A09 *)
  6688  16   10:D    43         
  6689  16   10:0     0           BEGIN
  6690  16   10:1     0             CENTSTR( EXITSTR);
  6691  16   10:1    10             EXIT( ADDPARTY)
  6692  16   10:0    14           END;  (* EXITADDP *)
  6693  16   10:0    26           
  6694  16   10:0    26           
  6695  16    9:0     0         BEGIN (* ADDPARTY *)
  6696  16    9:1     0           GOTOXY( 0, 19);
  6697  16    9:1     5           WRITE( 'WHO WILL JOIN ? >');
  6698  16    9:1    32           GETLINE( CHARNAME);
  6699  16    9:1    37           IF (CHARNAME = '') OR (LENGTH( CHARNAME) > 15) THEN
  6700  16    9:2    53             EXIT( ADDPARTY);
  6701  16    9:1    57           CHARI := 0;
  6702  16    9:1    60           MOVELEFT( IOCACHE[ GETREC( ZCHAR, CHARI, SIZEOF( TCHAR))],
  6703  16    9:1    73                     CHARACTR[ PARTYCNT],
  6704  16    9:1    79                     SIZEOF( TCHAR));
  6705  16    9:1    84           WHILE (CHARI < SCNTOC.RECPERDK[ ZCHAR]) AND
  6706  16    9:1    93                 ( (CHARNAME <> CHARACTR[ PARTYCNT].NAME) OR
  6707  16    9:1   102                   (CHARACTR[ PARTYCNT].STATUS = LOST) ) DO
  6708  16    9:2   115             BEGIN
  6709  16    9:3   115               CHARI := CHARI + 1;
  6710  16    9:3   120               MOVELEFT( IOCACHE[ GETREC( ZCHAR, CHARI, SIZEOF( TCHAR))],
  6711  16    9:3   133                         CHARACTR[ PARTYCNT],
  6712  16    9:3   139                         SIZEOF( TCHAR))
  6713  16    9:2   144             END;
  6714  16    9:1   146           IF CHARI = SCNTOC.RECPERDK[ ZCHAR] THEN
  6715  16    9:2   157             EXITADDP( '** WHO? **')
  6716  16    9:1   170           ELSE
  6717  16    9:2   174             IF CHARACTR[ PARTYCNT].INMAZE OR
  6718  16    9:2   181                (CHARACTR[ PARTYCNT].LOSTXYL.LOCATION[ 3] <> 0) THEN
  6719  16    9:3   199               EXITADDP( '** OUT **')
  6720  16    9:2   211             ELSE
  6721  16    9:3   215               IF (PRTYALGN <> NEUTRAL) THEN
  6722  16    9:4   222                 IF (CHARACTR[ PARTYCNT].ALIGN <> NEUTRAL) THEN
  6723  16    9:5   233                   IF (PRTYALGN <> CHARACTR[ PARTYCNT].ALIGN) THEN
  6724  16    9:6   246                     EXITADDP( '** BAD ALIGNMENT **');
  6725  16    9:1   270           GOTOXY( 0, 20);
  6726  16    9:1   275           WRITE( 'ENTER PASSWORD  >');
  6727  16    9:1   302           GETPASS(  CHARNAME);
  6728  16    9:1   306           GOTOXY( 0, 21);
  6729  16    9:1   311           IF CHARNAME <> CHARACTR[ PARTYCNT].PASSWORD THEN
  6730  16    9:2   324             EXITADDP( '** THATS NOT IT **');
  6731  16    9:1   347           CHARDISK[ PARTYCNT] := CHARI;
  6732  16    9:1   354           CHARACTR[ PARTYCNT].INMAZE := TRUE;
  6733  16    9:1   363           MOVELEFT( CHARACTR[ PARTYCNT],
  6734  16    9:1   369                     IOCACHE[ GETRECW( ZCHAR, CHARI, SIZEOF( TCHAR))],
  6735  16    9:1   382                     SIZEOF( TCHAR));
  6736  16    9:1   387           IF IORESULT > 0 THEN
  6737  16    9:2   393             EXITADDP( '** WRITE-PROTECT CHEAT! **');
  6738  16    9:1   424           PARTYCNT := PARTYCNT + 1;
  6739  16    9:1   429           GETALIGN;
  6740  16    9:1   431           MOVELEFT( IOCACHE[ GETREC( ZZERO, 0, SIZEOF( TSCNTOC))],
  6741  16    9:1   444                     SCNTOC,
  6742  16    9:1   448                     SIZEOF( TSCNTOC));
  6743  16    9:1   453           CHARINFO( PARTYCNT - 1);
  6744  16    9:0   458         END;  (* ADDPARTY *)
  6745  16    9:0   472         
  6746  16    9:0   472         
  6747  16   11:D     1       PROCEDURE REMOVE;  (* P010A0B *)
  6748  16   11:D     1       
  6749  16   11:D     1         VAR
  6750  16   11:D     1              CHARX : INTEGER;
  6751  16   11:D     2              CHARI : INTEGER;
  6752  16   11:D     3       
  6753  16   11:0     0         BEGIN
  6754  16   11:1     0           CHARI := GETCHARX( FALSE, 'WHO WILL LEAVE');
  6755  16   11:1    25           IF (CHARI < 0) OR (CHARI = PARTYCNT) THEN
  6756  16   11:2    34             EXIT( REMOVE);
  6757  16   11:1    38           CHARACTR[ CHARI].INMAZE := FALSE;
  6758  16   11:1    47           MOVELEFT( CHARACTR[ CHARI],
  6759  16   11:1    53                     IOCACHE[ GETRECW( ZCHAR,
  6760  16   11:1    57                                       CHARDISK[ CHARI],
  6761  16   11:1    63                                       SIZEOF( TCHAR))],
  6762  16   11:1    71                     SIZEOF( TCHAR));
  6763  16   11:1    76           IF CHARI <> (PARTYCNT - 1) THEN
  6764  16   11:2    83             FOR CHARX := (CHARI + 1) TO (PARTYCNT - 1) DO
  6765  16   11:3    98               BEGIN
  6766  16   11:4    98                 CHARACTR[ CHARX - 1] := CHARACTR[ CHARX];
  6767  16   11:4   112                 CHARDISK[ CHARX - 1] := CHARDISK[ CHARX]
  6768  16   11:3   124               END;
  6769  16   11:1   133           PARTYCNT := PARTYCNT - 1;
  6770  16   11:1   138           GETALIGN;
  6771  16   11:1   140           DSPPARTY( 'TAVERN')
  6772  16   11:0   149         END;   (* REMOVE *)
  6773  16   11:0   166         
  6774  16   11:0   166         
  6775  16   12:D     1       PROCEDURE EXITCASL;  (* P010A0C *)
  6776  16   12:D     1       
  6777  16   12:D     1         VAR
  6778  16   12:D     1              UNUSEDX : INTEGER;
  6779  16   12:D     2              
  6780  16   12:0     0         BEGIN
  6781  16   12:1     0           LLBASE04 := ORD( INCHAR) - ORD( '1');
  6782  16   12:1     5           IF (LLBASE04 < 0) OR (LLBASE04 >= PARTYCNT) THEN
  6783  16   12:2    14             EXIT( EXITCASL);
  6784  16   12:1    18           MAZELEV := -1;
  6785  16   12:1    22           XGOTO := XINSPECT;
  6786  16   12:1    25           EXIT( CASTLE)
  6787  16   12:0    29         END;
  6788  16   12:0    42         
  6789  16   12:0    42         
  6790  16    6:0     0       BEGIN  (* GILGAMSH *)
  6791  16    6:1     0         GETALIGN;
  6792  16    6:1     2         DSPTITLE( 'TAVERN');
  6793  16    6:1    13         REPEAT
  6794  16    6:2    13           UNITCLEAR( 1);
  6795  16    6:2    16           GILGMENU;
  6796  16    6:2    18           GOTOXY( 41, 0);
  6797  16    6:2    23           GETKEY;
  6798  16    6:2    26           IF INCHAR = CHR( CRETURN) THEN
  6799  16    6:3    31             EXIT( GILGAMSH);
  6800  16    6:2    35           CASE INCHAR OF
  6801  16    6:2    38             'A':  IF PARTYCNT < 6 THEN
  6802  16    6:4    43                     ADDPARTY;
  6803  16    6:4    47                    
  6804  16    6:2    47             'R':  IF PARTYCNT > 0 THEN
  6805  16    6:4    52                     REMOVE;
  6806  16    6:4    56                    
  6807  16    6:2    56             '1', '2', '3', '4', '5', '6':
  6808  16    6:3    56                   IF PARTYCNT > 0 THEN
  6809  16    6:4    61                     EXITCASL;
  6810  16    6:2    65           END
  6811  16    6:1   140         UNTIL FALSE
  6812  16    6:0   140       END;   (* GILGAMSH *)
  6813  16    6:0   158       
  6814  16    6:0   158       
  6815  16   13:D     1     PROCEDURE GOBOLTAC;  (* P010A0D *)
  6816  16   13:D     1     
  6817  16   13:0     0       BEGIN
  6818  16   13:1     0         DSPTITLE( 'SHOP');
  6819  16   13:1     9         XGOTO := XBOLTAC;
  6820  16   13:1    12         XGOTO2 := XBOLTAC;
  6821  16   13:1    15         EXIT( CASTLE)
  6822  16   13:0    19       END;
  6823  16   13:0    32       
  6824  16   13:0    32       
  6825  16   14:D     1     PROCEDURE GOTEMPLE;  (* P010A0E *)
  6826  16   14:D     1     
  6827  16   14:0     0       BEGIN
  6828  16   14:1     0         DSPTITLE( 'TEMPLE');
  6829  16   14:1    11         XGOTO := XCANT;
  6830  16   14:1    14         XGOTO2 := XBOLTAC;
  6831  16   14:1    17         EXIT( CASTLE)
  6832  16   14:0    21       END;
  6833  16   14:0    34     
  6834  16   14:0    34 (*$I WIZ1C:CASTLE    *)
  6834  16   14:0    34 (*$I WIZ1C:CASTLE2   *)
  6835  16   14:0    34     
  6836  16   15:D     1     PROCEDURE ADVNTINN;  (* P010A0F *)
  6837  16   15:D     1     
  6838  16   15:D     1       CONST
  6839  16   15:D     1            STABLES  = 65;
  6840  16   15:D     1            COTS     = 66;
  6841  16   15:D     1            ECONOMY  = 67;
  6842  16   15:D     1            MERCHANT = 68;
  6843  16   15:D     1            ROYAL    = 69;
  6844  16   15:D     1            
  6845  16   15:D     1       VAR
  6846  16   15:D     1            PARTYX : INTEGER;
  6847  16   15:D     2     
  6848  16   15:D     2     
  6849  16   16:D     1       PROCEDURE GETWHO;  (* P010A10 *)
  6850  16   16:D     1       
  6851  16   16:0     0         BEGIN
  6852  16   16:1     0           DSPTITLE( 'INN');
  6853  16   16:1     8           GOTOXY( 0, 13);
  6854  16   16:1    13           WRITE( CHR( 11));
  6855  16   16:1    21           PARTYX := GETCHARX( FALSE, 'WHO WILL STAY');
  6856  16   16:1    46           IF PARTYX < 0 THEN
  6857  16   16:2    53             EXIT( ADVNTINN)
  6858  16   16:0    57         END;
  6859  16   16:0    70         
  6860  16   16:0    70         
  6861  16   17:D     1       PROCEDURE INNMENU;  (* P010A11 *)
  6862  16   17:D     1       
  6863  16   17:0     0         BEGIN
  6864  16   17:1     0           GOTOXY( 0, 13);
  6865  16   17:1     5           WRITE( CHR( 11));
  6866  16   17:1    13           WRITE( '   WELCOME ');
  6867  16   17:1    34           WRITE( CHARACTR[ PARTYX].NAME);
  6868  16   17:1    48           WRITELN( '. WE HAVE:');
  6869  16   17:1    74           WRITELN;
  6870  16   17:1    80           WRITELN(  '[A] THE STABLES (FREE!)');
  6871  16   17:1   119           WRITELN(  '[B] COTS. 10 GP/WEEK.');
  6872  16   17:1   156           WRITELN(  '[C] ECONOMY ROOMS. 50 GP/WEEK.');
  6873  16   17:1   202           WRITELN(  '[D] MERCHANT SUITES. 200 GP/WEEK.');
  6874  16   17:1   251           WRITELN(  '[E] ROYAL SUITES. 500 GP/WEEK.');
  6875  16   17:1   297           WRITE(    '    OR [RETURN] TO LEAVE')
  6876  16   17:0   331         END;
  6877  16   17:0   344         
  6878  16   17:0   344         
  6879  16   18:D     1       PROCEDURE SETSPELS;  (* P010A12 *)
  6880  16   18:D     1       
  6881  16   18:D     1       
  6882  16   19:D     1         PROCEDURE SPLPERLV( VAR SPELGRPS: TSPELL7G;  (* P010A13 *)
  6883  16   19:D     2                                 LEVELMOD: INTEGER;
  6884  16   19:D     3                                 LEVMOD2:  INTEGER);
  6885  16   19:D     4                            
  6886  16   19:D     4           VAR
  6887  16   19:D     4                UNUSEDXX : INTEGER;
  6888  16   19:D     5                SPGRPI   : INTEGER;
  6889  16   19:D     6                SPELLCNT : INTEGER;
  6890  16   19:D     7         
  6891  16   19:0     0           BEGIN
  6892  16   19:1     0             SPELLCNT :=  CHARACTR[ PARTYX].CHARLEV - LEVELMOD;
  6893  16   19:1    13             IF SPELLCNT <=0 THEN
  6894  16   19:2    18               EXIT (SPLPERLV);
  6895  16   19:1    22             SPGRPI := 1;
  6896  16   19:1    25             WHILE (SPGRPI >= 1) AND (SPGRPI <= 7) AND (SPELLCNT > 0) DO
  6897  16   19:2    38               BEGIN
  6898  16   19:3    38                 IF SPELLCNT > SPELGRPS[ SPGRPI] THEN
  6899  16   19:4    49                   SPELGRPS[ SPGRPI] := SPELLCNT;
  6900  16   19:3    57                 SPGRPI := SPGRPI + 1;
  6901  16   19:3    62                 SPELLCNT := SPELLCNT - LEVMOD2
  6902  16   19:2    63               END;
  6903  16   19:1    69             FOR SPGRPI := 1 TO 7 DO
  6904  16   19:2    80               IF SPELGRPS[ SPGRPI] > 9 THEN
  6905  16   19:3    91                 SPELGRPS[ SPGRPI] := 9
  6906  16   19:0    97           END;  (* SPLPERLV *)
  6907  16   19:0   122           
  6908  16   19:0   122           
  6909  16   20:D     1         PROCEDURE NWPRIEST( MOD1: INTEGER;  (* P010A14 *)
  6910  16   20:D     2                             MOD2: INTEGER);
  6911  16   20:D     3         
  6912  16   20:0     0           BEGIN
  6913  16   20:1     0             SPLPERLV( CHARACTR[ PARTYX].PRIESTSP, MOD1, MOD2)
  6914  16   20:0    11           END;
  6915  16   20:0    26           
  6916  16   20:0    26           
  6917  16   21:D     1         PROCEDURE NWMAGE( MOD1: INTEGER;  (* P010A15 *)
  6918  16   21:D     2                           MOD2: INTEGER);
  6919  16   21:D     3         
  6920  16   21:0     0           BEGIN
  6921  16   21:1     0             SPLPERLV( CHARACTR[ PARTYX].MAGESP, MOD1, MOD2)
  6922  16   21:0    11           END;
  6923  16   21:0    26           
  6924  16   21:0    26           
  6925  16   22:D     1         PROCEDURE MINSPCNT( VAR SPLGRPS:  TSPELL7G;  (* P010A16 *)
  6926  16   22:D     2                                 GROUPI:   INTEGER;
  6927  16   22:D     3                                 LOWINDX:  INTEGER;
  6928  16   22:D     4                                 HIGHINDX: INTEGER);
  6929  16   22:D     5                            
  6930  16   22:D     5           VAR
  6931  16   22:D     5                SPELLI   : INTEGER;
  6932  16   22:D     6                SPELKNOW : INTEGER;
  6933  16   22:D     7                            
  6934  16   22:0     0           BEGIN
  6935  16   22:1     0             SPELKNOW := 0;
  6936  16   22:1     3             FOR SPELLI := LOWINDX TO HIGHINDX DO
  6937  16   22:2    14               IF CHARACTR[ PARTYX].SPELLSKN[ SPELLI] THEN
  6938  16   22:3    30                 SPELKNOW := SPELKNOW + 1;
  6939  16   22:1    42             SPLGRPS[ GROUPI] := SPELKNOW
  6940  16   22:0    48           END;
  6941  16   22:0    64           
  6942  16   22:0    64           
  6943  16   23:D     1         PROCEDURE MINMAG;  (* P010A17 *)
  6944  16   23:D     1         
  6945  16   23:0     0           BEGIN
  6946  16   23:1     0             WITH CHARACTR[ PARTYX] DO
  6947  16   23:2     9               BEGIN
  6948  16   23:3     9                 MINSPCNT( MAGESP, 1,  1,  4);
  6949  16   23:3    17                 MINSPCNT( MAGESP, 2,  5,  6);
  6950  16   23:3    25                 MINSPCNT( MAGESP, 3,  7,  8);
  6951  16   23:3    33                 MINSPCNT( MAGESP, 4,  9, 11);
  6952  16   23:3    41                 MINSPCNT( MAGESP, 5, 12, 14);
  6953  16   23:3    49                 MINSPCNT( MAGESP, 6, 15, 18);
  6954  16   23:3    57                 MINSPCNT( MAGESP, 7, 19, 21)
  6955  16   23:2    63               END
  6956  16   23:0    65           END;
  6957  16   23:0    78           
  6958  16   23:0    78           
  6959  16   24:D     1         PROCEDURE MINPRI;  (* P010A18 *)
  6960  16   24:D     1         
  6961  16   24:0     0           BEGIN
  6962  16   24:1     0             WITH CHARACTR[ PARTYX] DO
  6963  16   24:2     9               BEGIN
  6964  16   24:3     9                 MINSPCNT( PRIESTSP, 1, 22, 26);
  6965  16   24:3    17                 MINSPCNT( PRIESTSP, 2, 27, 30);
  6966  16   24:3    25                 MINSPCNT( PRIESTSP, 3, 31, 34);
  6967  16   24:3    33                 MINSPCNT( PRIESTSP, 4, 35, 38);
  6968  16   24:3    41                 MINSPCNT( PRIESTSP, 5, 39, 44);
  6969  16   24:3    49                 MINSPCNT( PRIESTSP, 6, 45, 48);
  6970  16   24:3    57                 MINSPCNT( PRIESTSP, 7, 49, 50)
  6971  16   24:2    63               END
  6972  16   24:0    65           END;  (* MINPRI *)
  6973  16   24:0    78       
  6974  16   24:0    78       
  6975  16   18:0     0         BEGIN  (* SETSPELS *)
  6976  16   18:1     0           MINPRI;
  6977  16   18:1     2           MINMAG;
  6978  16   18:1     4           CASE CHARACTR[ PARTYX].CLASS OF
  6979  16   18:1    15              PRIEST:  NWPRIEST( 0, 2);
  6980  16   18:1    21                MAGE:  NWMAGE(   0, 2);
  6981  16   18:1    27              BISHOP:  BEGIN
  6982  16   18:3    27                         NWPRIEST( 3, 4);
  6983  16   18:3    31                         NWMAGE(   0, 4)
  6984  16   18:2    33                       END;
  6985  16   18:1    37                LORD:  NWPRIEST( 3, 2);
  6986  16   18:1    43             SAMURAI:  NWMAGE(   3, 3)
  6987  16   18:1    45           END
  6988  16   18:0    68         END;  (* SETSPELS *)
  6989  16   18:0    80         
  6990  16   18:0    80         
  6991  16   25:D     1       PROCEDURE CHNEWLEV;  (* P010A19 *)
  6992  16   25:D     1       
  6993  16   25:D     1         VAR
  6994  16   25:D     1              EXP2NEXT : TEXP;
  6995  16   25:D   313              UNUSEDXX : TWIZLONG;
  6996  16   25:D   316              BIGLEV   : INTEGER;
  6997  16   25:D   317              EXPNXTLV : TWIZLONG;
  6998  16   25:D   320       
  6999  16   25:D   320       
  7000  16   26:D     1         PROCEDURE MADELEV;  (* P010A1A *)
  7001  16   26:D     1         
  7002  16   26:D     1           VAR
  7003  16   26:D     1                CHARLEV  : INTEGER;
  7004  16   26:D     2                NEWHPMAX : INTEGER;
  7005  16   26:D     3         
  7006  16   26:D     3         
  7007  16   27:D     3           FUNCTION MOREHP : INTEGER;  (* P010A1B *)
  7008  16   27:D     3           
  7009  16   27:D     3             VAR
  7010  16   27:D     3                  HITPTS : INTEGER;
  7011  16   27:D     4           
  7012  16   27:0     0             BEGIN
  7013  16   27:1     0               CASE CHARACTR[ PARTYX].CLASS OF
  7014  16   27:1    11                 FIGHTER, LORD:         HITPTS := RANDOM MOD 10;
  7015  16   27:1    22                 PRIEST, SAMURAI:       HITPTS := RANDOM MOD 8;
  7016  16   27:1    33                 THIEF, BISHOP, NINJA:  HITPTS := RANDOM MOD 6;
  7017  16   27:1    44                 MAGE:                  HITPTS := RANDOM MOD 4;
  7018  16   27:1    55               END;
  7019  16   27:1    78               
  7020  16   27:1    78               HITPTS := HITPTS + 1;
  7021  16   27:1    83               
  7022  16   27:1    83               CASE CHARACTR[ PARTYX].ATTRIB[ VITALITY] OF
  7023  16   27:1    99                 3:     HITPTS := HITPTS - 2;
  7024  16   27:1   106                 4, 5:  HITPTS := HITPTS - 1;
  7025  16   27:1   113                 16:    HITPTS := HITPTS + 1;
  7026  16   27:1   120                 17:    HITPTS := HITPTS + 2;
  7027  16   27:1   127                 18:    HITPTS := HITPTS + 3;
  7028  16   27:1   134               END;
  7029  16   27:1   174               
  7030  16   27:1   174               IF HITPTS < 1 THEN
  7031  16   27:2   179                 HITPTS := 1;
  7032  16   27:1   182               MOREHP := HITPTS
  7033  16   27:0   182             END;  (* MOREHP *)
  7034  16   27:0   198             
  7035  16   27:0   198             
  7036  16   28:D     1           PROCEDURE TRYLEARN;  (* P010A1C *)
  7037  16   28:D     1           
  7038  16   28:D     1             VAR
  7039  16   28:D     1                  IQPIETY : TATTRIB;
  7040  16   28:D     2                  LEARNED : BOOLEAN;
  7041  16   28:D     3           
  7042  16   28:D     3           
  7043  16   29:D     1             PROCEDURE TRY2LRN( LOWINDX:  INTEGER;  (* P010A1D *)
  7044  16   29:D     2                                HIGHINDX: INTEGER);
  7045  16   29:D     3             
  7046  16   29:D     3               VAR
  7047  16   29:D     3                    SPELLI   : INTEGER;
  7048  16   29:D     4                    SPLKNOWN : BOOLEAN;
  7049  16   29:D     5             
  7050  16   29:0     0               BEGIN
  7051  16   29:1     0                 SPLKNOWN := FALSE;
  7052  16   29:1     3                 FOR SPELLI := LOWINDX TO HIGHINDX DO
  7053  16   29:2    14                   SPLKNOWN := SPLKNOWN OR CHARACTR[ PARTYX].SPELLSKN[ SPELLI];
  7054  16   29:1    39                 FOR SPELLI := LOWINDX TO HIGHINDX DO
  7055  16   29:2    50                   IF NOT (CHARACTR[ PARTYX].SPELLSKN[ SPELLI]) THEN
  7056  16   29:3    67                     IF ((RANDOM MOD 30) <
  7057  16   29:3    74                         CHARACTR[ PARTYX].ATTRIB[ IQPIETY]) OR
  7058  16   29:3    91                        (NOT SPLKNOWN) THEN
  7059  16   29:4    96                       BEGIN
  7060  16   29:5    96                         LEARNED := TRUE;
  7061  16   29:5   100                         SPLKNOWN := TRUE;
  7062  16   29:5   103                         CHARACTR[ PARTYX].SPELLSKN[ SPELLI] := TRUE
  7063  16   29:4   116                       END
  7064  16   29:0   118               END;  (* TRY2LRN *)
  7065  16   29:0   142               
  7066  16   29:0   142               
  7067  16   30:D     1             PROCEDURE TRYMAGE;  (* P010A1E *)
  7068  16   30:D     1             
  7069  16   30:0     0               BEGIN
  7070  16   30:1     0                 IQPIETY := IQ;
  7071  16   30:1     4                 WITH CHARACTR[ PARTYX] DO
  7072  16   30:2    13                   BEGIN
  7073  16   30:3    13                     IF MAGESP[ 1] > 0 THEN
  7074  16   30:4    26                       TRY2LRN( 1, 4);
  7075  16   30:3    30                     IF MAGESP[ 2] > 0 THEN
  7076  16   30:4    43                       TRY2LRN( 5, 6);
  7077  16   30:3    47                     IF MAGESP[ 3] > 0 THEN
  7078  16   30:4    60                       TRY2LRN( 7, 8);
  7079  16   30:3    64                     IF MAGESP[ 4] > 0 THEN
  7080  16   30:4    77                       TRY2LRN( 9, 11);
  7081  16   30:3    81                     IF MAGESP[ 5] > 0 THEN
  7082  16   30:4    94                       TRY2LRN( 12, 14);
  7083  16   30:3    98                     IF MAGESP[ 6] > 0 THEN
  7084  16   30:4   111                       TRY2LRN( 15, 18);
  7085  16   30:3   115                     IF MAGESP[ 7] > 0 THEN
  7086  16   30:4   128                       TRY2LRN( 19, 21)
  7087  16   30:2   130                   END
  7088  16   30:0   132               END;  (* TRYMAGE *)
  7089  16   30:0   144               
  7090  16   30:0   144               
  7091  16   31:D     1             PROCEDURE TRYPRI;  (* P010A1F *)
  7092  16   31:D     1             
  7093  16   31:0     0               BEGIN
  7094  16   31:1     0                 IQPIETY := PIETY;
  7095  16   31:1     4                 WITH CHARACTR[ PARTYX] DO
  7096  16   31:2    13                   BEGIN
  7097  16   31:3    13                     IF PRIESTSP[ 1] > 0 THEN
  7098  16   31:4    26                       TRY2LRN( 22, 26);
  7099  16   31:3    30                     IF PRIESTSP[ 2] > 0 THEN
  7100  16   31:4    43                       TRY2LRN( 27, 30);
  7101  16   31:3    47                     IF PRIESTSP[ 3] > 0 THEN
  7102  16   31:4    60                       TRY2LRN( 31, 34);
  7103  16   31:3    64                     IF PRIESTSP[ 4] > 0 THEN
  7104  16   31:4    77                       TRY2LRN( 35, 38);
  7105  16   31:3    81                     IF PRIESTSP[ 5] > 0 THEN
  7106  16   31:4    94                       TRY2LRN( 39, 44);
  7107  16   31:3    98                     IF PRIESTSP[ 6] > 0 THEN
  7108  16   31:4   111                       TRY2LRN( 45, 48);
  7109  16   31:3   115                     IF PRIESTSP[ 7] > 0 THEN
  7110  16   31:4   128                       TRY2LRN( 49, 50)
  7111  16   31:2   130                   END
  7112  16   31:0   132               END;  (* TRYPRI *)
  7113  16   31:0   144               
  7114  16   31:0   144               
  7115  16   28:0     0             BEGIN  (* TRYLEARN *)
  7116  16   28:1     0               LEARNED := FALSE;
  7117  16   28:1     3               TRYMAGE;
  7118  16   28:1     5               TRYPRI;
  7119  16   28:1     7               IF LEARNED THEN
  7120  16   28:2    10                 WRITELN( 'YOU LEARNED NEW SPELLS!!!!');
  7121  16   28:1    52               SETSPELS
  7122  16   28:0    52             END;   (* TRYLEARN *)
  7123  16   28:0    66         
  7124  16   28:0    66         
  7125  16   32:D     1           PROCEDURE GAINLOST;  (* P010A20 *)
  7126  16   32:D     1           
  7127  16   32:D     1             VAR
  7128  16   32:D     1                  ATTRVAL : INTEGER;
  7129  16   32:D     2                  ATTRIBX : TATTRIB;
  7130  16   32:D     3           
  7131  16   32:D     3           
  7132  16   33:D     1             PROCEDURE PRATTRIB;  (* P010A21 *)
  7133  16   33:D     1             
  7134  16   33:0     0               BEGIN
  7135  16   33:1     0                 CASE ATTRIBX OF
  7136  16   33:1     5                   STRENGTH:  WRITELN( 'STRENGTH');
  7137  16   33:1    31                         IQ:  WRITELN( 'I.Q.');
  7138  16   33:1    53                      PIETY:  WRITELN( 'PIETY');
  7139  16   33:1    76                   VITALITY:  WRITELN( 'VITALITY');
  7140  16   33:1   102                    AGILITY:  WRITELN( 'AGILITY');
  7141  16   33:1   127                       LUCK:  WRITELN( 'LUCK');
  7142  16   33:1   149                 END;
  7143  16   33:0   168               END;  (* PRATTRIB *)
  7144  16   33:0   184               
  7145  16   33:0   184               
  7146  16   34:D     1             PROCEDURE OLDAGE;  (* P010A22 *)
  7147  16   34:D     1             
  7148  16   34:0     0               BEGIN
  7149  16   34:1     0                 WRITE(  '** YOU HAVE DIED OF OLD AGE **');
  7150  16   34:1    40                 WRITELN;
  7151  16   34:1    46                 CHARACTR[ PARTYX].STATUS := LOST;
  7152  16   34:1    57                 CHARACTR[ PARTYX].HPLEFT := 0;
  7153  16   34:1    68                 EXIT( GAINLOST)
  7154  16   34:0    72               END;
  7155  16   34:0    84           
  7156  16   34:0    84           
  7157  16   32:0     0             BEGIN (* GAINLOST *)
  7158  16   32:1     0               FOR ATTRIBX := STRENGTH TO LUCK DO
  7159  16   32:2    11                 BEGIN
  7160  16   32:3    11                   IF (RANDOM MOD 4) <> 0 THEN
  7161  16   32:4    22                     BEGIN
  7162  16   32:5    22                       ATTRVAL := CHARACTR[ PARTYX].ATTRIB[ ATTRIBX];
  7163  16   32:5    38                       IF (RANDOM MOD 130) <
  7164  16   32:5    47                          (CHARACTR[ PARTYX].AGE DIV 52) THEN
  7165  16   32:6    61                         IF (ATTRVAL = 18) AND
  7166  16   32:6    64                            ((RANDOM MOD 6) <> 4) THEN
  7167  16   32:6    76                           (* NOTHING *)
  7168  16   32:6    76                         ELSE
  7169  16   32:7    78                           BEGIN
  7170  16   32:8    78                             ATTRVAL := ATTRVAL - 1;
  7171  16   32:8    83                             WRITE(  'YOU LOST ');
  7172  16   32:8   102                             PRATTRIB;
  7173  16   32:8   104                             IF ATTRIBX = VITALITY THEN
  7174  16   32:9   109                               IF ATTRVAL = 2 THEN
  7175  16   32:0   114                                 OLDAGE
  7176  16   32:7   114                           END
  7177  16   32:5   116                       ELSE
  7178  16   32:6   118                         BEGIN
  7179  16   32:7   118                           IF ATTRVAL <> 18 THEN
  7180  16   32:8   123                             BEGIN
  7181  16   32:9   123                               ATTRVAL := ATTRVAL + 1;
  7182  16   32:9   128                               WRITE(  'YOU GAINED ');
  7183  16   32:9   149                               PRATTRIB
  7184  16   32:8   149                             END
  7185  16   32:6   151                         END;
  7186  16   32:5   151                       CHARACTR[ PARTYX].ATTRIB[ ATTRIBX] := ATTRVAL
  7187  16   32:4   164                     END
  7188  16   32:2   166                 END
  7189  16   32:0   166             END;  (* GAINLOST *)
  7190  16   32:0   192         
  7191  16   32:0   192         
  7192  16   26:0     0           BEGIN  (* MADELEV *)
  7193  16   26:1     0             WRITE( 'YOU MADE A LEVEL!');
  7194  16   26:1    27             WRITELN;
  7195  16   26:1    33             CHARACTR[ PARTYX].CHARLEV := CHARACTR[ PARTYX].CHARLEV + 1;
  7196  16   26:1    54             IF CHARACTR[ PARTYX].CHARLEV > CHARACTR[ PARTYX].MAXLEVAC THEN
  7197  16   26:2    75               CHARACTR[ PARTYX].MAXLEVAC := CHARACTR[ PARTYX].CHARLEV;
  7198  16   26:1    94             SETSPELS;
  7199  16   26:1    96             TRYLEARN;
  7200  16   26:1    98             GAINLOST;
  7201  16   26:1   100             
  7202  16   26:1   100             NEWHPMAX := 0;
  7203  16   26:1   103             FOR CHARLEV := 1 TO CHARACTR[ PARTYX].CHARLEV DO
  7204  16   26:2   122               NEWHPMAX := NEWHPMAX + MOREHP;
  7205  16   26:1   137             IF CHARACTR[ PARTYX].CLASS = SAMURAI THEN
  7206  16   26:2   150               NEWHPMAX := NEWHPMAX + MOREHP;
  7207  16   26:1   158             IF NEWHPMAX <= CHARACTR[ PARTYX].HPMAX THEN
  7208  16   26:2   171               NEWHPMAX := CHARACTR[ PARTYX].HPMAX + 1;
  7209  16   26:1   184             CHARACTR[ PARTYX].HPMAX := NEWHPMAX
  7210  16   26:0   193         END;  (* MADELEV *)
  7211  16   26:0   210         
  7212  16   26:0   210         
  7213  16   25:0     0         BEGIN (* CHNEWLEV *)
  7214  16   25:1     0           MOVELEFT( IOCACHE[ GETREC( ZEXP, 0, SIZEOF( TEXP))],
  7215  16   25:1    13                     EXP2NEXT,
  7216  16   25:1    16                     SIZEOF( TEXP));
  7217  16   25:1    21           WITH CHARACTR[ PARTYX] DO
  7218  16   25:2    31             BEGIN
  7219  16   25:3    31               IF CHARLEV <= 12 THEN
  7220  16   25:4    40                 EXPNXTLV := EXP2NEXT[ CLASS][ CHARLEV]
  7221  16   25:3    59               ELSE
  7222  16   25:4    63                 BEGIN
  7223  16   25:5    63                   EXPNXTLV := EXP2NEXT[ CLASS][ 12];
  7224  16   25:5    80                   FOR BIGLEV := 13 TO CHARLEV DO
  7225  16   25:6   101                     ADDLONGS( EXPNXTLV, EXP2NEXT[ CLASS][ 0])
  7226  16   25:4   116                 END;
  7227  16   25:4   129                 
  7228  16   25:3   129               IF TESTLONG( EXPNXTLV, EXP) <= 0 THEN
  7229  16   25:4   146                 MADELEV
  7230  16   25:3   146               ELSE
  7231  16   25:4   150                 BEGIN
  7232  16   25:5   150                   WRITE( 'YOU NEED ');
  7233  16   25:5   169                   SUBLONGS( EXPNXTLV, EXP);
  7234  16   25:5   180                   PRNTLONG( EXPNXTLV);
  7235  16   25:5   186                   WRITELN( ' MORE');
  7236  16   25:5   207                   WRITELN( 'EXPERIENCE POINTS TO MAKE LEVEL')
  7237  16   25:4   254                 END
  7238  16   25:2   254             END
  7239  16   25:0   254         END;  (* CHNEWLEV *)
  7240  16   25:0   268         
  7241  16   25:0   268         
  7242  16   35:D     1       PROCEDURE TAKENAP( HPADD:   INTEGER;  (* P010A23 *)
  7243  16   35:D     2                          GOLDAMT: INTEGER);
  7244  16   35:D     3       
  7245  16   35:D     3         VAR
  7246  16   35:D     3              GOLD4NAP : TWIZLONG;
  7247  16   35:D     6              PAUSEX   : INTEGER;
  7248  16   35:D     7       
  7249  16   35:D     7       
  7250  16   36:D     1         PROCEDURE HEALHP;  (* P010A24 *)
  7251  16   36:D     1         
  7252  16   36:0     0           BEGIN
  7253  16   36:1     0             GOTOXY( 0, 13);
  7254  16   36:1     5             CHARACTR[ PARTYX].HPLEFT := CHARACTR[ PARTYX].HPLEFT + HPADD;
  7255  16   36:1    28             IF CHARACTR[ PARTYX].HPLEFT > CHARACTR[ PARTYX].HPMAX THEN
  7256  16   36:2    49               CHARACTR[ PARTYX].HPLEFT := CHARACTR[ PARTYX].HPMAX;
  7257  16   36:1    68             SUBLONGS( CHARACTR[ PARTYX].GOLD, GOLD4NAP);
  7258  16   36:1    83             WRITE( CHARACTR[ PARTYX].NAME);
  7259  16   36:1    97             WRITELN( ' IS HEALING UP');
  7260  16   36:1   127             WRITELN;
  7261  16   36:1   133             WRITELN;
  7262  16   36:1   139             WRITE( '         HIT POINTS (');
  7263  16   36:1   170             WRITE( CHARACTR[ PARTYX].HPLEFT);
  7264  16   36:1   186             WRITE( '/');
  7265  16   36:1   194             WRITE( CHARACTR[ PARTYX].HPMAX);
  7266  16   36:1   210             WRITE( ')');
  7267  16   36:1   218             WRITELN;
  7268  16   36:1   224             WRITELN;
  7269  16   36:1   230             WRITE( '               GOLD  ');
  7270  16   36:1   261             PRNTLONG( CHARACTR[ PARTYX].GOLD);
  7271  16   36:1   273             GOTOXY( 41, 10);
  7272  16   36:1   278             FOR PAUSEX := 1 TO 500 DO
  7273  16   36:0   294               ;
  7274  16   36:0   304             
  7275  16   36:0   304           END;  (* HEALHP *)
  7276  16   36:0   318           
  7277  16   36:0   318           
  7278  16   35:0     0         BEGIN  (* TAKENAP *)
  7279  16   35:1     0           GOLD4NAP.HIGH := 0;
  7280  16   35:1     3           GOLD4NAP.MID  := 0;
  7281  16   35:1     6           GOLD4NAP.LOW  := GOLDAMT;
  7282  16   35:1     9           GOTOXY( 0, 13);
  7283  16   35:1    14           WRITE( CHR( 11));
  7284  16   35:1    22           IF GOLDAMT > 0 THEN
  7285  16   35:2    27             WHILE (TESTLONG( CHARACTR[ PARTYX].GOLD, GOLD4NAP) >= 0) AND
  7286  16   35:2    45                   (CHARACTR[ PARTYX].HPLEFT < CHARACTR[ PARTYX].HPMAX) AND
  7287  16   35:2    65                    (NOT KEYAVAIL) DO
  7288  16   35:3    74               HEALHP
  7289  16   35:1    74           ELSE
  7290  16   35:2    80             BEGIN
  7291  16   35:3    80               WRITE( CHARACTR[ PARTYX].NAME);
  7292  16   35:3    94               WRITELN( ' IS NAPPING');
  7293  16   35:2   121             END;
  7294  16   35:1   121           IF KEYAVAIL THEN
  7295  16   35:2   128             BEGIN
  7296  16   35:3   128               GOTOXY( 41, 0);
  7297  16   35:3   133               GETKEY
  7298  16   35:2   133             END;
  7299  16   35:1   136           GOTOXY( 0, 13);
  7300  16   35:1   141           WRITE( CHR(11));
  7301  16   35:1   149           CHNEWLEV;
  7302  16   35:1   151           SETSPELS;
  7303  16   35:1   153           GOTOXY(  0, 23);
  7304  16   35:1   158           WRITE(  'PRESS [RETURN] TO LEAVE');
  7305  16   35:1   191           GOTOXY( 41, 0);
  7306  16   35:1   196           REPEAT
  7307  16   35:2   196             GETKEY
  7308  16   35:1   196           UNTIL INCHAR = CHR( CRETURN);
  7309  16   35:1   204           INCHAR := CHR( 0)
  7310  16   35:0   205         END;   (* TAKENAP *)
  7311  16   35:0   224         
  7312  16   35:0   224         
  7313  16   15:0     0       BEGIN  (* ADVNTINN *)
  7314  16   15:1     0         REPEAT
  7315  16   15:2     0           GETWHO;
  7316  16   15:2     2           IF CHARACTR[ PARTYX].STATUS = OK THEN
  7317  16   15:3    13             REPEAT
  7318  16   15:4    13               UNITCLEAR( 1);
  7319  16   15:4    16               INNMENU;
  7320  16   15:4    18               GOTOXY( 41, 0);
  7321  16   15:4    23               GETKEY;
  7322  16   15:4    26               CASE ORD( INCHAR) OF
  7323  16   15:4    29                  STABLES:  TAKENAP(  0,   0);
  7324  16   15:4    35                     COTS:  TAKENAP(  1,  10);
  7325  16   15:4    41                  ECONOMY:  TAKENAP(  3,  50);
  7326  16   15:4    47                 MERCHANT:  TAKENAP(  7, 200);
  7327  16   15:4    55                    ROYAL:  TAKENAP( 10, 500);
  7328  16   15:4    63               END;
  7329  16   15:4    80               CHARINFO( PARTYX)
  7330  16   15:3    81             UNTIL (INCHAR = CHR( CRETURN)) OR
  7331  16   15:3    86                   (CHARACTR[ PARTYX].STATUS <> OK)
  7332  16   15:1    95         UNTIL FALSE
  7333  16   15:0    98       END;  (* ADVNTINN *)
  7334  16   15:0   118       
  7335  16   15:0   118       
  7336  16   37:D     1     PROCEDURE EXTCASTL;  (* P010A25 *)
  7337  16   37:D     1     
  7338  16   37:0     0       BEGIN
  7339  16   37:1     0         DSPTITLE( 'EXIT');
  7340  16   37:1     9         XGOTO := XEDGTOWN;
  7341  16   37:1    12         EXIT( CASTLE)
  7342  16   37:0    16       END;
  7343  16   37:0    28       
  7344  16   37:0    28       
  7345  16   38:D     1     PROCEDURE P010A26;  (* P010A26 *)
  7346  16   38:D     1     
  7347  16   38:0     0       BEGIN
  7348  16   38:1     0         GOTOXY( 0, 13);
  7349  16   38:1     5         WRITE( CHR( 11));
  7350  16   38:1    13         WRITE( ' ' : 13);
  7351  16   38:1    21         WRITELN( 'YOU MAY GO TO:');
  7352  16   38:1    51         WRITELN;
  7353  16   38:1    57         WRITELN( 'THE A)DVENTURER''S INN, G)ILGAMESH''');
  7354  16   38:1   107         WRITELN( 'TAVERN, B)OLTAC''S TRADING POST, THE');
  7355  16   38:1   158         WRITELN( 'TEMPLE OF C)ANT, OR THE E)DGE OF TOWN.')
  7356  16   38:0   212       END;
  7357  16   38:0   224       
  7358  16   38:0   224     
  7359  16    1:0     0     BEGIN  (* CASTLE  P010A01 *)
  7360  16    1:1     0       ACMOD2   := 0;
  7361  16    1:1     3       LIGHT    := 0;
  7362  16    1:1     6       CHSTALRM := 0;
  7363  16    1:1     9       
  7364  16    1:1     9       CPCALLED.I := 1145;  (* $0479  SLOT#1 RAM SPACE *)
  7365  16    1:1    14       
  7366  16    1:1    14       ATTK012  := 0;
  7367  16    1:1    17       FIZZLES  := 0;
  7368  16    1:1    20       TEXTMODE;
  7369  16    1:1    23       IF CPCALLED.P^[ 0] <> 10 THEN
  7370  16    1:2    30         MVCURSOR( 70, 0);  (* CRASH AND BURN *)
  7371  16    1:1    35       IF XGOTO2 <> XBOLTAC THEN
  7372  16    1:2    40         DSPPARTY( '');
  7373  16    1:1    45       XGOTO2 := XGILGAMS;
  7374  16    1:1    48       IF XGOTO = XGILGAMS THEN
  7375  16    1:2    53         GILGAMSH;
  7376  16    1:1    55       REPEAT
  7377  16    1:2    55         DSPTITLE( 'MARKET');
  7378  16    1:2    66         P010A26;
  7379  16    1:2    68         REPEAT
  7380  16    1:3    68           REPEAT
  7381  16    1:4    68             GOTOXY( 41, 0);
  7382  16    1:4    73             GETKEY
  7383  16    1:3    73           UNTIL (INCHAR = 'A') OR (INCHAR = 'G') OR (INCHAR = 'B') OR
  7384  16    1:3    87                 (INCHAR = 'C') OR (INCHAR = 'E');
  7385  16    1:2    97         UNTIL (PARTYCNT > 0) OR (INCHAR = 'E') OR (INCHAR = 'G');
  7386  16    1:2   110               
  7387  16    1:2   110         CASE INCHAR OF
  7388  16    1:2   113           'G':  GILGAMSH;
  7389  16    1:2   117           'A':  ADVNTINN;
  7390  16    1:2   121           'C':  GOTEMPLE;
  7391  16    1:2   125           'B':  GOBOLTAC;
  7392  16    1:2   129           'E':  EXTCASTL
  7393  16    1:2   129         END
  7394  16    1:1   154       UNTIL FALSE
  7395  16    1:0   154     END;   (* CASTLE  P010A01 *)
  7396  16    1:0   176   
  7397  16    1:0   176 (*$I WIZ1C:CASTLE2   *)
  7398  16    1:0   176                       
  7398  16    1:0   176 (*$I WIZ1C:ROLLER    *)
  7399  17    1:D     1 SEGMENT PROCEDURE ROLLER;   (* P010B01 *)
  7400  17    1:D     1   
  7401  17    1:D     1     VAR
  7402  17    1:D     1          CHARREC  : TCHAR;
  7403  17    1:D   105          TEMPX    : INTEGER;  (* MULTIPLE USES *)
  7404  17    1:D   106          CHARACX  : INTEGER;
  7405  17    1:D   107          PTSLEFT  : INTEGER;
  7406  17    1:D   108          CHARNAME : STRING;
  7407  17    1:D   149          CHG2LST  : ARRAY[ FIGHTER..NINJA] OF BOOLEAN;
  7408  17    1:D   157          BASEATTR : ARRAY[ STRENGTH..LUCK] OF INTEGER;
  7409  17    1:D   163          SIXATTR2 : ARRAY[ STRENGTH..LUCK] OF INTEGER;
  7410  17    1:D   169   
  7411  17    1:D   169   
  7412  17    2:D     1     PROCEDURE GETPASS( VAR PASSWORD: STRING);  (* P010B02 *)
  7413  17    2:D     2     
  7414  17    2:D     2       VAR
  7415  17    2:D     2            UNUSEDXX : INTEGER;
  7416  17    2:D     3            RANDX    : INTEGER;
  7417  17    2:D     4            CHRCNT   : INTEGER;
  7418  17    2:D     5       
  7419  17    2:0     0       BEGIN
  7420  17    2:1     0         CHRCNT := 0;
  7421  17    2:1     3         REPEAT
  7422  17    2:2     3           GETKEY;
  7423  17    2:2     6           IF INCHAR <> CHR( CRETURN) THEN
  7424  17    2:3    11             IF CHRCNT < 15 THEN
  7425  17    2:4    16               BEGIN
  7426  17    2:5    16                 FOR RANDX := 0 TO (RANDOM MOD 2) DO
  7427  17    2:6    33                   WRITE( CHR( 88));
  7428  17    2:5    48                 CHRCNT := CHRCNT + 1;
  7429  17    2:5    53                 PASSWORD[ CHRCNT] := INCHAR
  7430  17    2:4    55               END
  7431  17    2:3    57             ELSE
  7432  17    2:4    59               WRITE( CHR( 7));
  7433  17    2:1    67         UNTIL INCHAR = CHR( CRETURN);
  7434  17    2:1    72         WRITELN;
  7435  17    2:1    78         PASSWORD[ 0] := CHR( CHRCNT)
  7436  17    2:0    81       END;
  7437  17    2:0    98       
  7438  17    2:0    98       
  7439  17    3:D     3     FUNCTION GTCHGLST : BOOLEAN;  (* P010B03 *)
  7440  17    3:D     3     
  7441  17    3:0     0       BEGIN
  7442  17    3:1     0         CHG2LST[ FIGHTER] :=  SIXATTR2[ STRENGTH] >= 11;
  7443  17    3:1    18         
  7444  17    3:1    18         CHG2LST[ MAGE]    :=  SIXATTR2[ IQ] >= 11;
  7445  17    3:1    36         
  7446  17    3:1    36         CHG2LST[ PRIEST]  := (SIXATTR2[ PIETY] >= 11)   AND
  7447  17    3:1    53                              (CHARREC.ALIGN <> NEUTRAL);
  7448  17    3:1    60                              
  7449  17    3:1    60         CHG2LST[ THIEF]   := (SIXATTR2[ AGILITY] >= 11) AND
  7450  17    3:1    77                              (CHARREC.ALIGN <> GOOD);
  7451  17    3:1    84                              
  7452  17    3:1    84         CHG2LST[ BISHOP]  := (SIXATTR2[ IQ] >= 12)      AND
  7453  17    3:1   101                              (SIXATTR2[ PIETY] >= 12)   AND
  7454  17    3:1   112                              (CHARREC.ALIGN <> NEUTRAL);
  7455  17    3:1   119                             
  7456  17    3:1   119         CHG2LST[ SAMURAI] := (SIXATTR2[ STRENGTH] >= 15) AND
  7457  17    3:1   136                              (SIXATTR2[ IQ] >= 11)       AND
  7458  17    3:1   147                              (SIXATTR2[ PIETY] >= 10)    AND
  7459  17    3:1   158                              (SIXATTR2[ VITALITY] >= 14) AND
  7460  17    3:1   169                              (SIXATTR2[ AGILITY] >= 10)  AND
  7461  17    3:1   180                              (CHARREC.ALIGN <> EVIL);
  7462  17    3:1   187                             
  7463  17    3:1   187         CHG2LST[ LORD]    := (SIXATTR2[ STRENGTH] >= 15) AND
  7464  17    3:1   204                              (SIXATTR2[ IQ] >= 12)       AND
  7465  17    3:1   215                              (SIXATTR2[ PIETY] >= 12)    AND
  7466  17    3:1   226                              (SIXATTR2[ VITALITY] >= 15) AND
  7467  17    3:1   237                              (SIXATTR2[ AGILITY] >= 14)  AND
  7468  17    3:1   248                              (SIXATTR2[ LUCK] >= 15)     AND
  7469  17    3:1   259                              (CHARREC.ALIGN = GOOD);
  7470  17    3:1   266                              
  7471  17    3:1   266         CHG2LST[ NINJA]   := (SIXATTR2[ STRENGTH] >= 17) AND
  7472  17    3:1   283                              (SIXATTR2[ IQ] >= 17)       AND
  7473  17    3:1   294                              (SIXATTR2[ PIETY] >= 17)    AND
  7474  17    3:1   305                              (SIXATTR2[ VITALITY] >= 17) AND
  7475  17    3:1   316                              (SIXATTR2[ AGILITY] >= 17)  AND
  7476  17    3:1   327                              (SIXATTR2[ LUCK] >= 17)     AND
  7477  17    3:1   338                              (CHARREC.ALIGN = EVIL);
  7478  17    3:1   345                             
  7479  17    3:1   345         GTCHGLST := CHG2LST[ FIGHTER] OR
  7480  17    3:1   353                     CHG2LST[ MAGE]    OR
  7481  17    3:1   362                     CHG2LST[ PRIEST]  OR
  7482  17    3:1   371                     CHG2LST[ THIEF]   OR
  7483  17    3:1   380                     CHG2LST[ BISHOP]  OR
  7484  17    3:1   389                     CHG2LST[ LORD]    OR
  7485  17    3:1   398                     CHG2LST[ SAMURAI] OR
  7486  17    3:1   407                     CHG2LST[ NINJA]
  7487  17    3:0   414       END;
  7488  17    3:0   430       
  7489  17    3:0   430       
  7490  17    4:D     1     PROCEDURE SETBASE;  (* P010B04 *)
  7491  17    4:D     1     
  7492  17    5:D     1       PROCEDURE SETXBASE( BASESTR: STRING);  (* P010B05 *)
  7493  17    5:D    43       
  7494  17    5:D    43         VAR
  7495  17    5:D    43              ATTRI : INTEGER;
  7496  17    5:D    44              ATTR  : TATTRIB;
  7497  17    5:D    45       
  7498  17    5:0     0         BEGIN
  7499  17    5:1     0           ATTR := STRENGTH;
  7500  17    5:1     8           FOR ATTRI := 1 TO 6 DO
  7501  17    5:2    21             BEGIN
  7502  17    5:3    21               BASEATTR[ ATTR] := ORD( BASESTR[ ATTRI]) - ORD( '0');
  7503  17    5:3    37               ATTR := SUCC( ATTR)
  7504  17    5:2    41             END
  7505  17    5:0    43         END;  (* SETXBASE *)
  7506  17    5:0    66         
  7507  17    5:0    66         
  7508  17    4:0     0       BEGIN  (* SETBASE *)
  7509  17    4:1     0         CASE CHARREC.RACE OF            (*  S, I, P, V, A, L *)
  7510  17    4:1     5            HUMAN:  SETXBASE( '885889'); (*  8  8  5  8  8  9 *)
  7511  17    4:1    18              ELF:  SETXBASE( '7::696'); (*  7 10 10  6  9  6 *)
  7512  17    4:1    31            DWARF:  SETXBASE( ':7::56'); (* 10  7 10 10  5  6 *)
  7513  17    4:1    44            GNOME:  SETXBASE( '77:8:7'); (*  7  7 10  8 10  7 *)
  7514  17    4:1    57           HOBBIT:  SETXBASE( '5776:?')  (*  5  7  7  6 10 15 *)
  7515  17    4:1    66         END
  7516  17    4:0    88       END;  (* SETBASE *)
  7517  17    4:0   100       
  7518  17    4:0   100       
  7519  17    6:D     1     PROCEDURE GETCHARC( VAR BUFFER: TCHAR;  (* P010B06 *)
  7520  17    6:D     2                             CHINDX: INTEGER);
  7521  17    6:D     3     
  7522  17    6:0     0       BEGIN
  7523  17    6:1     0         MOVELEFT( IOCACHE[ GETREC(  ZCHAR, CHINDX, SIZEOF( TCHAR))],
  7524  17    6:1    13                   BUFFER,
  7525  17    6:1    15                   SIZEOF( TCHAR))
  7526  17    6:0    20       END;
  7527  17    6:0    32       
  7528  17    6:0    32       
  7529  17    7:D     1     PROCEDURE PUTCHARC( VAR BUFFER: TCHAR;  (* P010B07 *)
  7530  17    7:D     2                             CHINDX: INTEGER);
  7531  17    7:D     3     
  7532  17    7:0     0       BEGIN
  7533  17    7:1     0         MOVELEFT( BUFFER,
  7534  17    7:1     2                   IOCACHE[ GETRECW( ZCHAR, CHINDX, SIZEOF( TCHAR))],
  7535  17    7:1    15                   SIZEOF( TCHAR))
  7536  17    7:0    20       END;
  7537  17    7:0    32       
  7538  17    7:0    32       
  7539  17    8:D     1     PROCEDURE GTSCNTOC;  (* P010B08 *)
  7540  17    8:D     1     
  7541  17    8:0     0       BEGIN
  7542  17    8:1     0         MOVELEFT( IOCACHE[ GETREC( ZZERO, 0, SIZEOF( SCNTOC))],
  7543  17    8:1    13                   SCNTOC,
  7544  17    8:1    17                   SIZEOF( SCNTOC))
  7545  17    8:0    22       END;
  7546  17    8:0    34       
  7547  17    8:0    34       
  7548  17    9:D     1     PROCEDURE MAKECHAR;  (* P010B09 *)
  7549  17    9:D     1       
  7550  17    9:D     1       
  7551  17   10:D     1       PROCEDURE INITCHAR;  (* P010B0A *)
  7552  17   10:D     1       
  7553  17   10:D     1         VAR
  7554  17   10:D     1              LSI    : INTEGER;
  7555  17   10:D     2              UNUSED : INTEGER;
  7556  17   10:D     3       
  7557  17   10:0     0         BEGIN
  7558  17   10:1     0           FILLCHAR( CHARREC, SIZEOF( CHARREC), 0);
  7559  17   10:1    10           CHARREC.NAME := CHARNAME;
  7560  17   10:1    18           CHARREC.AGE := (18 * 52) + (RANDOM MOD 300);
  7561  17   10:1    34           CHARREC.GOLD.LOW := 90 + (RANDOM MOD 100);
  7562  17   10:1    46           CHARREC.STATUS := OK;
  7563  17   10:1    50           FOR LSI := 0 TO 4 DO
  7564  17   10:2    61             BEGIN
  7565  17   10:3    61               CHARREC.LUCKSKIL[ LSI] := 16
  7566  17   10:2    68             END;
  7567  17   10:1    77           CHARREC.MAXLEVAC := 1;
  7568  17   10:1    81           CHARREC.CHARLEV := 1;
  7569  17   10:1    85           CHARREC.ARMORCL := 10
  7570  17   10:0    85         END;
  7571  17   10:0   104       
  7572  17   10:0   104       
  7573  17   11:D     1       PROCEDURE P010B0B;
  7574  17   11:D     1       
  7575  17   11:0     0         BEGIN
  7576  17   11:1     0           GOTOXY( 0, 15);
  7577  17   11:1     5           WRITE( CHR( 11))
  7578  17   11:0    13         END;
  7579  17   11:0    26         
  7580  17   11:0    26         
  7581  17   12:D     1       PROCEDURE P010B0C;
  7582  17   12:D     1       
  7583  17   12:0     0         BEGIN
  7584  17   12:1     0           GOTOXY( 0, 15);
  7585  17   12:1     5           WRITE( CHR( 29))
  7586  17   12:0    13         END;
  7587  17   12:0    26         
  7588  17   12:0    26         
  7589  17   13:D     1       PROCEDURE MAKEMENU;  (* P010B0D *)
  7590  17   13:D     1       
  7591  17   13:D     1         VAR
  7592  17   13:D     1              PASSWD : STRING;
  7593  17   13:D    42              
  7594  17   13:0     0         BEGIN
  7595  17   13:1     0           WRITE( CHR( 12));
  7596  17   13:1     8           WRITE(   'NAME ': 10);
  7597  17   13:1    23           WRITELN( CHARREC.NAME);
  7598  17   13:1    39           WRITELN( 'PASSWORD': 9);
  7599  17   13:1    63           WRITELN( 'RACE': 9);
  7600  17   13:1    83           WRITELN( 'POINTS': 9);
  7601  17   13:1   105           WRITELN;
  7602  17   13:1   111           WRITELN( 'STRENGTH': 9);
  7603  17   13:1   135           WRITELN( 'I.Q.': 9);
  7604  17   13:1   155           WRITELN( 'PIETY': 9);
  7605  17   13:1   176           WRITELN( 'VITALITY': 9);
  7606  17   13:1   200           WRITELN( 'AGILITY': 9);
  7607  17   13:1   223           WRITELN( 'LUCK': 9);
  7608  17   13:1   243           WRITELN;
  7609  17   13:1   249           WRITELN( 'ALIGNMENT');
  7610  17   13:1   274           WRITELN( 'CLASS': 9);
  7611  17   13:1   295           WRITELN;
  7612  17   13:1   301           
  7613  17   13:1   301           REPEAT
  7614  17   13:2   301             P010B0B;
  7615  17   13:2   303             WRITELN( 'ENTER A PASSWORD ([RET] FOR NONE)');
  7616  17   13:2   352             GOTOXY( 10, 1);
  7617  17   13:2   357             WRITE( CHR( 29));
  7618  17   13:2   365             GOTOXY( 10, 1);
  7619  17   13:2   370             GETPASS( CHARNAME);
  7620  17   13:2   375             IF LENGTH( CHARNAME) > 15 THEN
  7621  17   13:3   384               CHARNAME := COPY( CHARNAME, 1, 15);
  7622  17   13:2   401             P010B0B;
  7623  17   13:2   403             WRITELN( 'ENTER IT AGAIN TO BE SURE');
  7624  17   13:2   444             GOTOXY( 10, 1);
  7625  17   13:2   449             WRITE( CHR( 29));
  7626  17   13:2   457             GOTOXY( 10, 1);
  7627  17   13:2   462             GETPASS( PASSWD);
  7628  17   13:1   466           UNTIL PASSWD = CHARNAME;
  7629  17   13:1   475           CHARREC.PASSWORD := CHARNAME
  7630  17   13:0   478         END;
  7631  17   13:0   498         
  7632  17   13:0   498         
  7633  17   14:D     1       PROCEDURE CHOSRACE;  (* P010B0E *)
  7634  17   14:D     1       
  7635  17   14:D     1         VAR
  7636  17   14:D     1              UNUSED : INTEGER;
  7637  17   14:D     2              RACEI  : TRACE;
  7638  17   14:D     3       
  7639  17   14:0     0         BEGIN
  7640  17   14:1     0           P010B0B;
  7641  17   14:1     2           GOTOXY( 0, 17);
  7642  17   14:1     7           FOR RACEI := HUMAN TO HOBBIT DO
  7643  17   14:2    18             BEGIN
  7644  17   14:3    18               WRITE( CHR( ORD( '@') + ORD( RACEI)));
  7645  17   14:3    28               WRITE( ') ' );
  7646  17   14:3    40               WRITELN( SCNTOC.RACE[ RACEI])
  7647  17   14:2    59             END;
  7648  17   14:1    66           REPEAT
  7649  17   14:2    66             P010B0C;
  7650  17   14:2    68             WRITE( 'CHOOSE A RACE >');
  7651  17   14:2    93             GETKEY
  7652  17   14:1    93           UNTIL (INCHAR >= 'A') AND (INCHAR <= 'E');
  7653  17   14:1   105           GOTOXY( 10, 2);
  7654  17   14:1   110           CHARREC.RACE := HUMAN;
  7655  17   14:1   114           WHILE INCHAR > 'A' DO
  7656  17   14:2   119             BEGIN
  7657  17   14:3   119               INCHAR := PRED( INCHAR);
  7658  17   14:3   124               CHARREC.RACE := SUCC( CHARREC.RACE)
  7659  17   14:2   129             END;
  7660  17   14:1   134           WRITE( SCNTOC.RACE[ CHARREC.RACE]);
  7661  17   14:1   149           SETBASE
  7662  17   14:0   149         END;
  7663  17   14:0   170         
  7664  17   14:0   170         
  7665  17   15:D     1       PROCEDURE GIVEPTS;  (* P010B0F *)
  7666  17   15:D     1       
  7667  17   15:D     1         VAR
  7668  17   15:D     1              UNUSED  : INTEGER;
  7669  17   15:D     2              CANCHG  : BOOLEAN;
  7670  17   15:D     3              ATTRIBX : TATTRIB;
  7671  17   15:D     4              CLASSX  : TCLASS;
  7672  17   15:D     5         
  7673  17   15:D     5         
  7674  17   16:D     1         PROCEDURE PTSMENU;  (* P010B10 *)
  7675  17   16:D     1         
  7676  17   16:0     0           BEGIN
  7677  17   16:1     0             GOTOXY( 0, 15);
  7678  17   16:1     5             WRITE( CHR( 11));
  7679  17   16:1    13             WRITELN( 'ENTER [+,-] TO ALTER A SCORE,');
  7680  17   16:1    58             WRITELN( '      [RET] TO GO TO NEXT SCORE,');
  7681  17   16:1   106             WRITELN( '      [ESC] TO GO ON WHEN POINTS USED UP');
  7682  17   16:1   162             PTSLEFT := 7 + (RANDOM MOD 4);
  7683  17   16:1   174             WHILE (PTSLEFT < 20) AND ((RANDOM MOD 11) = 10) DO
  7684  17   16:2   191               PTSLEFT := PTSLEFT + 10;
  7685  17   16:1   201             SIXATTR2 := BASEATTR;
  7686  17   16:1   211             FOR ATTRIBX := STRENGTH TO LUCK DO
  7687  17   16:2   225               BEGIN
  7688  17   16:3   225                 GOTOXY( 10, 5 + ORD( ATTRIBX));
  7689  17   16:3   234                 WRITE( SIXATTR2[ ATTRIBX] :2)
  7690  17   16:2   251               END;
  7691  17   16:1   261             ATTRIBX:= STRENGTH;
  7692  17   16:1   265             CANCHG := FALSE
  7693  17   16:0   265           END;  (* PTSMENU *)
  7694  17   16:0   286         
  7695  17   16:0   286         
  7696  17   15:0     0         BEGIN (* GIVEPTS *)
  7697  17   15:1     0           PTSMENU;
  7698  17   15:1     2           REPEAT
  7699  17   15:2     2             GOTOXY( 13, 5 + ORD( ATTRIBX));
  7700  17   15:2     9             WRITE( '<--');
  7701  17   15:2    22             REPEAT
  7702  17   15:3    22               GOTOXY( 10, 3);
  7703  17   15:3    27               WRITE( PTSLEFT :2);
  7704  17   15:3    37               GOTOXY( 41, 0);
  7705  17   15:3    42               GETKEY;
  7706  17   15:3    45               IF ( (INCHAR = '+') OR (INCHAR = ';') ) AND
  7707  17   15:3    52                  (SIXATTR2[ ATTRIBX] < 18) AND
  7708  17   15:3    63                  (PTSLEFT > 0) THEN
  7709  17   15:3    71                  
  7710  17   15:4    71                 BEGIN
  7711  17   15:5    71                   SIXATTR2[ ATTRIBX] := SIXATTR2[ ATTRIBX] + 1;
  7712  17   15:5    89                   PTSLEFT := PTSLEFT - 1
  7713  17   15:4    92                 END
  7714  17   15:3    97               ELSE
  7715  17   15:4    99                 BEGIN
  7716  17   15:5    99                   IF ( (INCHAR = '-') OR (INCHAR = '=') ) AND
  7717  17   15:5   106                      (SIXATTR2[ ATTRIBX] > BASEATTR[ ATTRIBX]) THEN
  7718  17   15:6   126                      BEGIN
  7719  17   15:7   126                        SIXATTR2[ ATTRIBX] := SIXATTR2[ ATTRIBX] - 1;
  7720  17   15:7   144                        PTSLEFT := PTSLEFT + 1
  7721  17   15:6   147                      END;
  7722  17   15:4   152                 END;
  7723  17   15:3   152               IF (INCHAR = '+') OR (INCHAR = '-') OR (INCHAR = ';') OR
  7724  17   15:3   163                  (INCHAR = '=') THEN
  7725  17   15:4   169                 BEGIN
  7726  17   15:5   169                   GOTOXY( 10, 5 + ORD( ATTRIBX));
  7727  17   15:5   176                   WRITE( SIXATTR2[ ATTRIBX] : 2);
  7728  17   15:5   191                   CANCHG := GTCHGLST;
  7729  17   15:5   197                   FOR CLASSX := FIGHTER TO NINJA DO
  7730  17   15:6   208                     BEGIN
  7731  17   15:7   208                       GOTOXY( 20, 5 + ORD( CLASSX));
  7732  17   15:7   215                       IF CHG2LST[ CLASSX] THEN
  7733  17   15:8   225                         BEGIN
  7734  17   15:9   225                           WRITE( CHR( ORD( 'A') + ORD( CLASSX)));
  7735  17   15:9   235                           WRITE( ') ' );
  7736  17   15:9   247                           WRITE( SCNTOC.CLASS[ CLASSX])
  7737  17   15:8   260                         END
  7738  17   15:7   260                       ELSE
  7739  17   15:8   262                         WRITE( CHR( 29))
  7740  17   15:6   270                     END;
  7741  17   15:4   277                 END;
  7742  17   15:2   277             UNTIL  (INCHAR = CHR( 27)) OR (INCHAR = CHR( CRETURN));
  7743  17   15:2   286             IF INCHAR = CHR( CRETURN) THEN
  7744  17   15:3   291               BEGIN
  7745  17   15:4   291                 GOTOXY( 13, 5 + ORD( ATTRIBX));
  7746  17   15:4   298                 WRITE( '   ');
  7747  17   15:4   311                 IF ATTRIBX < LUCK THEN
  7748  17   15:5   316                    ATTRIBX:= SUCC( ATTRIBX)
  7749  17   15:4   319                 ELSE
  7750  17   15:5   323                    ATTRIBX:= STRENGTH;
  7751  17   15:3   326               END;
  7752  17   15:1   326           UNTIL (INCHAR = CHR( 27)) AND CANCHG AND (PTSLEFT = 0);
  7753  17   15:1   339           REPEAT
  7754  17   15:2   339             REPEAT
  7755  17   15:3   339               P010B0B;
  7756  17   15:3   341               WRITE( 'CHOOSE A CLASS >');
  7757  17   15:3   367               GETKEY
  7758  17   15:2   367             UNTIL (INCHAR >= 'A') AND (INCHAR <= 'H');
  7759  17   15:2   379             CLASSX := FIGHTER;
  7760  17   15:2   382             WHILE INCHAR > 'A' DO
  7761  17   15:3   387               BEGIN
  7762  17   15:4   387                 CLASSX := SUCC( CLASSX);
  7763  17   15:4   392                 INCHAR := PRED( INCHAR)
  7764  17   15:3   395               END;
  7765  17   15:1   399           UNTIL CHG2LST[ CLASSX];
  7766  17   15:1   409           GOTOXY( 10, 13);
  7767  17   15:1   414           WRITE( SCNTOC.CLASS[ CLASSX]);
  7768  17   15:1   427           CHARREC.CLASS := CLASSX;
  7769  17   15:1   431           FOR ATTRIBX := STRENGTH TO LUCK DO
  7770  17   15:2   442             CHARREC.ATTRIB[ ATTRIBX] := SIXATTR2[ ATTRIBX]
  7771  17   15:0   456         END;  (* GIVEPTS *)
  7772  17   15:0   492       
  7773  17   15:0   492       
  7774  17   17:D     1       PROCEDURE CHOSALIG;  (* P010B11 *)
  7775  17   17:D     1       
  7776  17   17:D     1         VAR
  7777  17   17:D     1              ALIGNX : TALIGN;
  7778  17   17:D     2              
  7779  17   17:0     0         BEGIN
  7780  17   17:1     0           P010B0B;
  7781  17   17:1     2           GOTOXY( 0, 17);
  7782  17   17:1     7           FOR ALIGNX := GOOD TO EVIL DO
  7783  17   17:2    18             BEGIN
  7784  17   17:3    18               WRITE( CHR(  ORD( '@') + ORD( ALIGNX)));
  7785  17   17:3    28               WRITE( ') ' );
  7786  17   17:3    40               WRITELN( SCNTOC.ALIGN[ ALIGNX])
  7787  17   17:2    59             END;
  7788  17   17:1    66           REPEAT
  7789  17   17:2    66             P010B0C;
  7790  17   17:2    68             WRITE( 'CHOOSE AN ALIGNMENT >');
  7791  17   17:2    99             GETKEY;
  7792  17   17:1   102           UNTIL (INCHAR >= 'A') AND (INCHAR <= 'C');
  7793  17   17:1   111           IF INCHAR = 'A' THEN
  7794  17   17:2   116             CHARREC.ALIGN := GOOD
  7795  17   17:1   116           ELSE IF INCHAR = 'B' THEN
  7796  17   17:3   127             CHARREC.ALIGN := NEUTRAL
  7797  17   17:2   127           ELSE
  7798  17   17:3   133             CHARREC.ALIGN := EVIL;
  7799  17   17:1   137           GOTOXY( 10, 12);
  7800  17   17:1   142           WRITE( SCNTOC.ALIGN[ CHARREC.ALIGN])
  7801  17   17:0   157         END;
  7802  17   17:0   174         
  7803  17   17:0   174         
  7804  17   18:D     1       PROCEDURE KEEPCHYN;  (* P010B12 *)
  7805  17   18:D     1       
  7806  17   18:D     1         VAR
  7807  17   18:D     1              VITHPMOD : INTEGER;
  7808  17   18:D     2              CLSHPMOD : INTEGER;
  7809  17   18:D     3              
  7810  17   18:0     0         BEGIN
  7811  17   18:1     0           REPEAT
  7812  17   18:2     0             P010B0B;
  7813  17   18:2     2             WRITE( 'KEEP THIS CHARACTER (Y/N)? >');
  7814  17   18:2    40             GETKEY
  7815  17   18:1    40           UNTIL (INCHAR = 'Y') OR (INCHAR = 'N');
  7816  17   18:1    52           IF INCHAR = 'N' THEN
  7817  17   18:2    57             EXIT( MAKECHAR);
  7818  17   18:1    61           IF (CHARREC.CLASS = MAGE) OR (CHARREC.CLASS = BISHOP) THEN
  7819  17   18:2    74             BEGIN
  7820  17   18:3    74               CHARREC.SPELLSKN[ 3] := TRUE;
  7821  17   18:3    83               CHARREC.SPELLSKN[ 1] := TRUE;
  7822  17   18:3    92               CHARREC.MAGESP[ 1] := 2
  7823  17   18:2   100             END;
  7824  17   18:1   102           IF (CHARREC.CLASS = PRIEST) THEN
  7825  17   18:2   109             BEGIN
  7826  17   18:3   109               CHARREC.SPELLSKN[ 23] := TRUE;
  7827  17   18:3   118               CHARREC.SPELLSKN[ 24] := TRUE;
  7828  17   18:3   127               CHARREC.PRIESTSP[ 1] := 2
  7829  17   18:2   135             END;
  7830  17   18:1   137           CASE CHARREC.CLASS OF
  7831  17   18:1   142                    FIGHTER, LORD:  CLSHPMOD := 10;
  7832  17   18:1   147                           PRIEST:  CLSHPMOD :=  8;
  7833  17   18:1   152             THIEF, BISHOP, NINJA:  CLSHPMOD :=  6;
  7834  17   18:1   157                             MAGE:  CLSHPMOD :=  4;
  7835  17   18:1   162                          SAMURAI:  CLSHPMOD := 16;
  7836  17   18:1   167           END;
  7837  17   18:1   190           
  7838  17   18:1   190           VITHPMOD := 0;
  7839  17   18:1   193           CASE CHARREC.ATTRIB[ VITALITY] OF
  7840  17   18:1   203                3:  VITHPMOD := -2;
  7841  17   18:1   209             4, 5:  VITHPMOD := -1;
  7842  17   18:1   215               16:  VITHPMOD :=  1;
  7843  17   18:1   220               17:  VITHPMOD :=  2;
  7844  17   18:1   225               18:  VITHPMOD :=  3;
  7845  17   18:1   230           END;
  7846  17   18:1   270           
  7847  17   18:1   270           CLSHPMOD := CLSHPMOD + VITHPMOD;
  7848  17   18:1   275           FOR LLBASE04 := 1 TO 2 DO
  7849  17   18:2   286             IF (RANDOM MOD 2) = 1 THEN
  7850  17   18:3   297               CLSHPMOD := (9 * CLSHPMOD) DIV 10;
  7851  17   18:1   311           IF CLSHPMOD < 2 THEN
  7852  17   18:2   316              CLSHPMOD:= 2;
  7853  17   18:1   319           CHARREC.HPMAX := CLSHPMOD;
  7854  17   18:1   323           CHARREC.HPLEFT := CLSHPMOD
  7855  17   18:0   323         END;
  7856  17   18:0   344       
  7857  17   18:0   344       
  7858  17    9:0     0       BEGIN (* MAKECHAR *)
  7859  17    9:1     0         INITCHAR;
  7860  17    9:1     2         MAKEMENU;
  7861  17    9:1     4         CHOSRACE;
  7862  17    9:1     6         CHOSALIG;
  7863  17    9:1     8         GIVEPTS;
  7864  17    9:1    10         KEEPCHYN;
  7865  17    9:1    12         PUTCHARC( CHARREC, CHARACX)
  7866  17    9:0    18       END;  (* MAKECHAR *)
  7867  17    9:0    32       
  7868  17    9:0    32       
  7869  17    9:0    32       
  7870  17   19:D     1     PROCEDURE CREATE;  (* P010B13 *)
  7871  17   19:D     1     
  7872  17   19:D     1       VAR
  7873  17   19:D     1            CHARRECI : INTEGER;
  7874  17   19:D     2     
  7875  17   19:D     2     
  7876  17   20:D     1       PROCEDURE EXITCREA( EXITSTR : STRING);  (* P010B14 *)
  7877  17   20:D    43       
  7878  17   20:0     0         BEGIN
  7879  17   20:1     0           WRITELN;
  7880  17   20:1    11           WRITELN;
  7881  17   20:1    17           WRITELN( EXITSTR);
  7882  17   20:1    32           WRITELN;
  7883  17   20:1    38           WRITELN( 'PRESS ANY KEY TO CONTINUE');
  7884  17   20:1    79           GOTOXY( 41, 0);
  7885  17   20:1    84           GETKEY;
  7886  17   20:1    87           EXIT( CREATE)
  7887  17   20:0    91         END;  (* EXITCREA *)
  7888  17   20:0   104         
  7889  17   20:0   104         
  7890  17   19:0     0       BEGIN (* CREATE *)
  7891  17   19:1     0         CHARACX := -1;
  7892  17   19:1     5         FOR CHARRECI := 0 TO SCNTOC.RECPERDK[ ZCHAR] - 1 DO
  7893  17   19:2    24           BEGIN
  7894  17   19:3    24             IF CHARACX < 0 THEN
  7895  17   19:4    31               BEGIN
  7896  17   19:5    31               GETCHARC( CHARREC, CHARRECI);
  7897  17   19:5    37               IF CHARREC.STATUS = LOST THEN
  7898  17   19:6    44                 CHARACX := CHARRECI
  7899  17   19:4    44               END;
  7900  17   19:2    48           END;
  7901  17   19:1    55         IF CHARACX = -1 THEN
  7902  17   19:2    63           EXITCREA( 'THERE IS NO ROOM LEFT - TRY DELETING');
  7903  17   19:1   104         WRITELN;
  7904  17   19:1   110         WRITELN;
  7905  17   19:1   116         WRITELN( 'THAT CHARACTER DOES NOT EXIST. DO YOU');
  7906  17   19:1   169         WRITE(   'WANT TO CREATE IT (Y/N) ?> ');
  7907  17   19:1   206         REPEAT
  7908  17   19:2   206           WRITE( CHR(8));
  7909  17   19:2   214           GETKEY
  7910  17   19:1   214         UNTIL (INCHAR = 'Y') OR (INCHAR = 'N');
  7911  17   19:1   226         IF INCHAR = 'N' THEN
  7912  17   19:2   231           EXIT( CREATE);
  7913  17   19:1   235         MAKECHAR
  7914  17   19:0   235       END;  (* CREATE *)
  7915  17   19:0   254       
  7916  17   19:0   254       
  7917  17   21:D     1     PROCEDURE DSP20NM;  (* P010B15 *)
  7918  17   21:D     1     
  7919  17   21:D     1       VAR
  7920  17   21:D     1            UNUSED  : INTEGER;
  7921  17   21:D     2            LINECNT : INTEGER;
  7922  17   21:D     3            CHARI   : INTEGER;
  7923  17   21:D     4     
  7924  17   21:0     0       BEGIN
  7925  17   21:1     0         WRITE( CHR( 12));
  7926  17   21:1     8         WRITELN( 'NAMES IN USE:');
  7927  17   21:1    37         WRITELN( '----------------------------------------');
  7928  17   21:1    93         LINECNT := 0;
  7929  17   21:1    96         FOR CHARI := 0 TO SCNTOC.RECPERDK[ ZCHAR] - 1 DO
  7930  17   21:2   115           BEGIN
  7931  17   21:3   115             GETCHARC( CHARREC, CHARI);
  7932  17   21:3   121             IF CHARREC.STATUS <> LOST THEN
  7933  17   21:4   128               BEGIN
  7934  17   21:5   128                 LINECNT := LINECNT + 1;
  7935  17   21:5   133                 GOTOXY( 0, LINECNT + 1);
  7936  17   21:5   140                 WRITE( CHARREC.NAME);
  7937  17   21:5   150                 WRITE( ' LEVEL ');
  7938  17   21:5   167                 WRITE( CHARREC.CHARLEV);
  7939  17   21:5   177                 WRITE( ' ');
  7940  17   21:5   185                 WRITE( SCNTOC.RACE[ CHARREC.RACE]);
  7941  17   21:5   200                 WRITE( ' ');
  7942  17   21:5   208                 WRITE( SCNTOC.CLASS[ CHARREC.CLASS]);
  7943  17   21:5   223                 WRITE( ' (' );
  7944  17   21:5   235                 WRITE( SCNTOC.STATUS[ CHARREC.STATUS]);
  7945  17   21:5   250                 WRITE( ')' );
  7946  17   21:5   258                 IF CHARREC.INMAZE OR (CHARREC.LOSTXYL.LOCATION[ 1] <> 0) THEN
  7947  17   21:6   275                   WRITE( ' OUT');
  7948  17   21:4   289               END;
  7949  17   21:2   289           END;
  7950  17   21:2   296           
  7951  17   21:1   296         GOTOXY( 0, 22);
  7952  17   21:1   301         WRITELN( '----------------------------------------');
  7953  17   21:1   357         WRITE( 'YOU MAY L)EAVE WHEN READY');
  7954  17   21:1   392         REPEAT
  7955  17   21:2   392           GOTOXY( 41, 0);
  7956  17   21:2   397           GETKEY
  7957  17   21:1   397         UNTIL INCHAR = 'L';
  7958  17   21:1   405         INCHAR := CHR( 0)
  7959  17   21:0   406       END;
  7960  17   21:0   428       
  7961  17   21:0   428       
  7962  17   22:D     1     PROCEDURE TRAINING;  (* P010B16 *)
  7963  17   22:D     1     
  7964  17   22:D     1     VAR
  7965  17   22:D     1          
  7966  17   22:D     1          PASSSTR  : STRING;
  7967  17   22:D    42     
  7968  17   22:D    42     
  7969  17   23:D     1       PROCEDURE LOSECHAR;  (* P010B17 *)
  7970  17   23:D     1       
  7971  17   23:0     0         BEGIN
  7972  17   23:1     0           CHARREC.STATUS := LOST;
  7973  17   23:1     4           CHARREC.INMAZE := FALSE;
  7974  17   23:1     8           PUTCHARC( CHARREC, CHARACX);
  7975  17   23:1    16           GTSCNTOC
  7976  17   23:0    16         END;
  7977  17   23:0    30         
  7978  17   23:0    30         
  7979  17   24:D     1       PROCEDURE INSPECT;  (* P010B18 *)
  7980  17   24:D     1       
  7981  17   24:0     0         BEGIN
  7982  17   24:1     0           PARTYCNT := 1;
  7983  17   24:1     3           CHARACTR[ 0] := CHARREC;
  7984  17   24:1    13           CHARDISK[ 0] := CHARACX;
  7985  17   24:1    22           XGOTO := XINSPCT3;
  7986  17   24:1    25           EXIT( ROLLER)
  7987  17   24:0    29         END;
  7988  17   24:0    42         
  7989  17   24:0    42         
  7990  17   25:D     1       PROCEDURE RUSUREYN( DELSTR: STRING);  (* P010B19 *)
  7991  17   25:D    43       
  7992  17   25:0     0         BEGIN
  7993  17   25:1     0           REPEAT
  7994  17   25:2     5             WRITE( CHR(12));
  7995  17   25:2    13             WRITE( 'ARE YOU SURE YOU WANT TO ');
  7996  17   25:2    48             WRITE( DELSTR);
  7997  17   25:2    57             WRITE( ' (Y/N) ?' );
  7998  17   25:2    75             GETKEY
  7999  17   25:1    75           UNTIL (INCHAR = 'Y') OR (INCHAR = 'N')
  8000  17   25:0    84         END;
  8001  17   25:0   102         
  8002  17   25:0   102         
  8003  17   26:D     1       PROCEDURE DELCHAR;  (* P010B1A *)
  8004  17   26:D     1       
  8005  17   26:0     0         BEGIN
  8006  17   26:1     0           RUSUREYN( 'DELETE');
  8007  17   26:1    11           IF INCHAR = 'N' THEN
  8008  17   26:2    16             EXIT( DELCHAR);
  8009  17   26:1    20           LOSECHAR;
  8010  17   26:1    22           EXIT( TRAINING)
  8011  17   26:0    26         END;
  8012  17   26:0    38         
  8013  17   26:0    38         
  8014  17   27:D     1       PROCEDURE CHGCLASS;  (* P010B1B *)
  8015  17   27:D     1       
  8016  17   27:D     1         VAR
  8017  17   27:D     1              ATTRIBI  : TATTRIB;
  8018  17   27:D     2              CHGLSTX  : BOOLEAN;  (* NOT USED *)
  8019  17   27:D     3              CLASSX   : TCLASS;
  8020  17   27:D     4       
  8021  17   27:0     0         BEGIN  (* CHGCLASS *)
  8022  17   27:1     0           GOTOXY( 0, 2);
  8023  17   27:1     5           WRITELN( CHR( 11));
  8024  17   27:1    19           FOR ATTRIBI := STRENGTH TO LUCK DO
  8025  17   27:2    30             SIXATTR2[ ATTRIBI] := CHARREC.ATTRIB[ ATTRIBI];
  8026  17   27:1    53           CHGLSTX := GTCHGLST;
  8027  17   27:1    59           
  8028  17   27:1    59           FOR CLASSX := FIGHTER TO NINJA DO
  8029  17   27:2    70             IF CHG2LST[ CLASSX] AND
  8030  17   27:2    78                NOT ( CLASSX = CHARREC.CLASS) THEN
  8031  17   27:3    87               BEGIN
  8032  17   27:4    87                 WRITE( CHR( ORD('A') + ORD( CLASSX)));
  8033  17   27:4    97                 WRITE( ') ');
  8034  17   27:4   109                 WRITELN( SCNTOC.CLASS[ CLASSX]);
  8035  17   27:3   128               END;
  8036  17   27:1   135           WRITELN;
  8037  17   27:1   141           WRITELN( 'PRESS [LETTER] TO CHANGE CLASS');
  8038  17   27:1   187           WRITELN( '[RET] TO NOT CHANGE CLASS' : 34);
  8039  17   27:1   228           REPEAT
  8040  17   27:2   228             REPEAT
  8041  17   27:3   228               GOTOXY( 41, 0);
  8042  17   27:3   233               GETKEY
  8043  17   27:2   233             UNTIL (INCHAR = CHR( CRETURN)) OR
  8044  17   27:2   239                    ((ORD( INCHAR) >= ORD( 'A')) AND
  8045  17   27:2   242                     (ORD( INCHAR) <= ORD( 'H')));
  8046  17   27:2   249             IF INCHAR = CHR( CRETURN) THEN
  8047  17   27:3   254               EXIT( CHGCLASS);
  8048  17   27:2   258             CLASSX := FIGHTER;
  8049  17   27:2   261             WHILE INCHAR > 'A' DO
  8050  17   27:3   266               BEGIN
  8051  17   27:4   266                 CLASSX := SUCC( CLASSX);
  8052  17   27:4   271                 INCHAR := PRED( INCHAR)
  8053  17   27:3   274               END;
  8054  17   27:1   278           UNTIL CHG2LST[ CLASSX] AND ( NOT( CLASSX = CHARREC.CLASS));
  8055  17   27:1   295           
  8056  17   27:1   295           SETBASE;
  8057  17   27:1   297           FOR ATTRIBI := STRENGTH TO LUCK DO
  8058  17   27:2   308             CHARREC.ATTRIB[ ATTRIBI] := BASEATTR[ ATTRIBI];
  8059  17   27:1   331           CHARREC.CLASS := CLASSX;
  8060  17   27:1   335           CHARREC.CHARLEV := 1;
  8061  17   27:1   339           CHARREC.EXP.HIGH := 0;
  8062  17   27:1   343           CHARREC.EXP.MID  := 0;
  8063  17   27:1   347           CHARREC.EXP.LOW  := 0;
  8064  17   27:1   351           CHARREC.AGE := CHARREC.AGE + 52 * (RANDOM MOD 3) + 252;
  8065  17   27:1   371           IF CLASSX = MAGE THEN
  8066  17   27:2   376             CHARREC.SPELLSKN[ 3] := TRUE
  8067  17   27:1   383           ELSE IF CLASSX = PRIEST THEN
  8068  17   27:3   392             CHARREC.SPELLSKN[ 23] := TRUE;
  8069  17   27:1   401           FOR TEMPX := 1 TO 7 DO
  8070  17   27:2   415             BEGIN
  8071  17   27:3   415               CHARREC.MAGESP[   TEMPX] := 0;
  8072  17   27:3   427               CHARREC.PRIESTSP[ TEMPX] := 0
  8073  17   27:2   437             END;
  8074  17   27:1   449           FOR TEMPX := 1 TO CHARREC.POSS.POSSCNT DO
  8075  17   27:2   465             IF NOT CHARREC.POSS.POSSESS[ TEMPX].CURSED THEN
  8076  17   27:3   479               CHARREC.POSS.POSSESS[ TEMPX].EQUIPED := FALSE;
  8077  17   27:1   501           PUTCHARC( CHARREC, CHARACX);
  8078  17   27:1   509           GTSCNTOC
  8079  17   27:0   509         END;  (* CHGCLASS *)
  8080  17   27:0   540         
  8081  17   27:0   540 
  8082  17   28:D     1       PROCEDURE CHGPASS;  (* P010B1C *)
  8083  17   28:D     1       
  8084  17   28:D     1         VAR
  8085  17   28:D     1              NEWPASS2 : STRING[ 40];
  8086  17   28:D    22              NEWPASS1 : STRING[ 40];
  8087  17   28:D    43       
  8088  17   28:0     0         BEGIN;
  8089  17   28:1     0           WRITE( CHR(12));
  8090  17   28:1     8           WRITE( 'ENTER NEW PASSWORD ([RET] FOR NONE)');
  8091  17   28:1    53           REPEAT
  8092  17   28:2    53             GOTOXY( 10, 2);
  8093  17   28:2    58             GETPASS(  NEWPASS1)
  8094  17   28:1    60           UNTIL LENGTH( NEWPASS1) <= 15;
  8095  17   28:1    70           WRITE( CHR( 12));
  8096  17   28:1    78           WRITE( 'ENTER AGAIN TO BE SURE');
  8097  17   28:1   110           REPEAT
  8098  17   28:2   110             GOTOXY( 10, 2);
  8099  17   28:2   115             GETPASS( NEWPASS2)
  8100  17   28:1   117           UNTIL LENGTH( NEWPASS2) <= 15;
  8101  17   28:1   127           WRITE( CHR( 12));
  8102  17   28:1   135           IF NEWPASS1 = NEWPASS2 THEN
  8103  17   28:2   143             BEGIN
  8104  17   28:3   143               CHARREC.PASSWORD := NEWPASS1;
  8105  17   28:3   150               PUTCHARC( CHARREC, CHARACX);
  8106  17   28:3   158               GTSCNTOC;
  8107  17   28:3   160               WRITE( 'PASSWORD CHANGED - ')
  8108  17   28:2   189             END
  8109  17   28:1   189           ELSE
  8110  17   28:2   191             BEGIN
  8111  17   28:3   191               WRITELN( 'THEY ARE NOT THE SAME - YOUR PASSWORD');
  8112  17   28:3   244               WRITELN( 'HAS NOT BEEN CHANGED!');
  8113  17   28:3   281               WRITELN
  8114  17   28:2   281             END;
  8115  17   28:1   287           WRITE( 'PRESS [RET]');
  8116  17   28:1   308           GOTOXY( 41, 0);
  8117  17   28:1   313           READLN
  8118  17   28:0   313         END;
  8119  17   28:0   336 
  8120  17   28:0   336         
  8121  17   22:0     0       BEGIN  (* TRAINING *)
  8122  17   22:1     0         PARTYCNT := 0;
  8123  17   22:1     3         IF XGOTO <> XBCK2ROL THEN
  8124  17   22:2     8           BEGIN
  8125  17   22:3     8             REPEAT
  8126  17   22:4     8               GOTOXY( 9, 10);
  8127  17   22:4    13               WRITE( 'PASSWORD >');
  8128  17   22:4    33               GETPASS( PASSSTR)
  8129  17   22:3    35             UNTIL LENGTH( PASSSTR) <= 15;
  8130  17   22:3    45             IF PASSSTR <> CHARREC.PASSWORD THEN
  8131  17   22:4    54               EXIT( TRAINING)
  8132  17   22:2    58           END
  8133  17   22:1    58         ELSE
  8134  17   22:2    60           BEGIN
  8135  17   22:3    60             XGOTO := XTRAININ;
  8136  17   22:3    63             CHARREC := CHARACTR[ 0];
  8137  17   22:3    73             CHARACX := CHARDISK[ 0]
  8138  17   22:2    78           END;
  8139  17   22:2    82         
  8140  17   22:1    82         REPEAT
  8141  17   22:2    82           WRITE( CHR( 12));
  8142  17   22:2    90           WRITE( CHARREC.NAME);
  8143  17   22:2   100           WRITE( ' LEVEL ');
  8144  17   22:2   117           WRITE( CHARREC.CHARLEV);
  8145  17   22:2   127           WRITE( ' ');
  8146  17   22:2   135           WRITE( SCNTOC.RACE[ CHARREC.RACE]);
  8147  17   22:2   150           WRITE( ' ');
  8148  17   22:2   158           WRITE( SCNTOC.CLASS[ CHARREC.CLASS]);
  8149  17   22:2   173           WRITE( ' (' );
  8150  17   22:2   185           WRITE( SCNTOC.STATUS[ CHARREC.STATUS]);
  8151  17   22:2   200           WRITELN( ')' );
  8152  17   22:2   214           WRITELN;
  8153  17   22:2   220           
  8154  17   22:2   220           WRITELN( 'YOU MAY I)NSPECT THIS CHARACTER,');
  8155  17   22:2   268           WRITELN( 'D)ELETE  THIS CHARACTER,' : 32);
  8156  17   22:2   308           WRITELN( 'R)EROLL  THIS CHARACTER,' : 32);
  8157  17   22:2   348           WRITELN( 'C)HANGE  CLASS,' : 23);
  8158  17   22:2   379           WRITELN( 'S)ET NEW PASSWORD, OR' : 29);
  8159  17   22:2   416           WRITELN( '  PRESS [RET] TO LEAVE');
  8160  17   22:2   454           
  8161  17   22:2   454           GOTOXY( 41, 0);
  8162  17   22:2   459           GETKEY;
  8163  17   22:2   462           IF INCHAR = CHR( CRETURN) THEN
  8164  17   22:3   467             EXIT( TRAINING);
  8165  17   22:2   471           CASE INCHAR OF
  8166  17   22:2   474             'I':  INSPECT;
  8167  17   22:2   478             'D':  DELCHAR;
  8168  17   22:2   482             'C':  CHGCLASS;
  8169  17   22:2   486             'R':  BEGIN
  8170  17   22:4   486                     RUSUREYN( 'REROLL');
  8171  17   22:4   497                     IF INCHAR = 'Y' THEN
  8172  17   22:5   502                       BEGIN
  8173  17   22:6   502                         CHARNAME := CHARREC.NAME;
  8174  17   22:6   510                         LOSECHAR;
  8175  17   22:6   512                         MAKECHAR
  8176  17   22:5   512                       END;
  8177  17   22:3   514                   END;
  8178  17   22:2   516             'S':  CHGPASS;
  8179  17   22:2   520           END;  
  8180  17   22:2   562           
  8181  17   22:1   562         UNTIL FALSE
  8182  17   22:0   562       END;   (* TRAINING *)
  8183  17   22:0   582       
  8184  17   22:0   582       
  8185  17    1:0     0     BEGIN  (* P010B01  ROLLER *)
  8186  17    1:1     0       IF XGOTO = XBCK2ROL THEN
  8187  17    1:2     5         TRAINING;
  8188  17    1:1     7       REPEAT
  8189  17    1:2     7         WRITE( CHR( 12));
  8190  17    1:2    15         WRITE(   ' ' :12);
  8191  17    1:2    23         WRITELN( 'TRAINING GROUNDS');
  8192  17    1:2    55         WRITELN;
  8193  17    1:2    61         WRITELN( 'YOU MAY ENTER A CHARACTER NAME TO ADD,');
  8194  17    1:2   115         WRITE(   ' ' :8);
  8195  17    1:2   123         WRITELN( 'INSPECT OR EDIT,');
  8196  17    1:2   155         WRITELN;
  8197  17    1:2   161         WRITE(   ' ' :8);
  8198  17    1:2   169         WRITELN( '"*ROSTER" TO SEE ROSTER,');
  8199  17    1:2   209         WRITELN;
  8200  17    1:2   215         WRITELN( 'OR PRESS [RET] FOR CASTLE.' : 33);
  8201  17    1:2   257         REPEAT
  8202  17    1:3   257           GOTOXY( 13, 9);
  8203  17    1:3   262           WRITE( CHR( 11));
  8204  17    1:3   270           WRITE( 'NAME >');
  8205  17    1:3   286           GETLINE( CHARNAME);
  8206  17    1:3   291           IF  CHARNAME = '' THEN
  8207  17    1:4   300             BEGIN
  8208  17    1:5   300               WRITE( CHR( 12));
  8209  17    1:5   308               XGOTO := XCASTLE;
  8210  17    1:5   311               EXIT( ROLLER)
  8211  17    1:4   315             END;
  8212  17    1:2   315         UNTIL LENGTH( CHARNAME) <= 15;
  8213  17    1:2   323         
  8214  17    1:2   323         IF CHARNAME = '*ROSTER' THEN
  8215  17    1:3   339           DSP20NM
  8216  17    1:2   339         ELSE
  8217  17    1:3   343           BEGIN
  8218  17    1:4   343             CHARACX := -1;
  8219  17    1:4   347             FOR TEMPX := 0 TO SCNTOC.RECPERDK[ ZCHAR] - 1 DO
  8220  17    1:5   370               IF CHARACX < 0 THEN
  8221  17    1:6   376                 BEGIN
  8222  17    1:7   376                   GETCHARC( CHARREC, TEMPX);
  8223  17    1:7   382                   IF CHARREC.STATUS <> LOST THEN
  8224  17    1:8   388                     IF CHARREC.NAME = CHARNAME THEN
  8225  17    1:9   396                       CHARACX := TEMPX
  8226  17    1:6   396                 END;
  8227  17    1:4   408             IF CHARACX < 0 THEN
  8228  17    1:5   414               CREATE
  8229  17    1:4   414             ELSE
  8230  17    1:5   418               TRAINING
  8231  17    1:3   418           END
  8232  17    1:1   420       UNTIL FALSE
  8233  17    1:0   420     END;   (* ROLLER *)
  8234  17    1:0   442   
  8235  17    1:0   442 (*$I WIZ1C:ROLLER    *)
  8236  17    1:0   442 
  8236  17    1:0   442 (*$I WIZ1C:CAMP      *)
  8237  18    1:D     1 SEGMENT PROCEDURE CAMP;  (* P010C01 *)
  8238  18    1:D     1 
  8239  18    1:D     1     VAR
  8240  18    1:D     1          OBJIDS   : ARRAY[ 0..7] OF INTEGER;
  8241  18    1:D     9          OBJNAMES : ARRAY[ 0..7] OF ARRAY[ FALSE..TRUE] OF STRING[ 15];
  8242  18    1:D   137          CURSEDXX : PACKED ARRAY[ 0..7] OF BOOLEAN;
  8243  18    1:D   138          CANUSE   : PACKED ARRAY[ 0..7] OF BOOLEAN;
  8244  18    1:D   139          DISPSTAT : BOOLEAN;
  8245  18    1:D   140          OBJI     : INTEGER;
  8246  18    1:D   141          
  8247  18    1:D   141     
  8248  18    2:D     1     PROCEDURE AASTRAA( ASTRA: STRING);  (* P010C02 *)
  8249  18    2:D    43     
  8250  18    2:0     0       BEGIN
  8251  18    2:1     0         CENTSTR( CONCAT( '** ', ASTRA, ' **'));
  8252  18    2:0    45       END;
  8253  18    2:0    58       
  8254  18    2:0    58       
  8255  18    3:D     1     PROCEDURE INSPECT;  (* P010C03 *)
  8256  18    3:D     1     
  8257  18    3:D     1       VAR
  8258  18    3:D     1            UNUSEDXX : INTEGER;
  8259  18    3:D     2            CAMPCHAR : INTEGER;
  8260  18    3:D     3          
  8261  18    3:D     3          
  8262  18    4:D     1       PROCEDURE DSPSPELS;  (* P010C04 *)
  8263  18    4:D     1       
  8264  18    4:D     1         VAR
  8265  18    4:D     1              INDX : INTEGER;
  8266  18    4:D     2       
  8267  18    4:0     0         BEGIN
  8268  18    4:1     0           WITH CHARACTR[ CAMPCHAR] DO
  8269  18    4:2     9             BEGIN
  8270  18    4:3     9               GOTOXY(  0, 9);
  8271  18    4:3    14               WRITE( ' ' : 7);
  8272  18    4:3    22               WRITE( ' MAGE ');
  8273  18    4:3    38               FOR INDX := 1 TO 7 DO
  8274  18    4:4    49                 BEGIN
  8275  18    4:5    49                   WRITE( MAGESP[ INDX]);
  8276  18    4:5    65                   IF INDX < 7 THEN
  8277  18    4:6    70                     WRITE( '/')
  8278  18    4:4    78                 END;
  8279  18    4:3    85               WRITELN;
  8280  18    4:3    91               WRITE( ' ' :6);
  8281  18    4:3    99               WRITE( 'PRIEST ');
  8282  18    4:3   116               FOR INDX := 1 TO 7 DO
  8283  18    4:4   127                 BEGIN
  8284  18    4:5   127                   WRITE( PRIESTSP[ INDX]);
  8285  18    4:5   143                   IF INDX < 7 THEN
  8286  18    4:6   148                     WRITE( '/')
  8287  18    4:4   156                 END
  8288  18    4:2   156             END
  8289  18    4:0   163         END;
  8290  18    4:0   180         
  8291  18    4:0   180         
  8292  18    5:D     1       PROCEDURE DSPITEMS;  (* P010C05 *)
  8293  18    5:D     1       
  8294  18    5:D     1       VAR
  8295  18    5:D     1            ITEMX   : INTEGER;
  8296  18    5:D     2            OBJECT  : TOBJREC;
  8297  18    5:D    41            
  8298  18    5:0     0         BEGIN
  8299  18    5:1     0           GOTOXY( 0, 12);
  8300  18    5:1     5           WRITE( '*=EQUIP, -=CURSED, ?=UNKNOWN, #=UNUSABLE');
  8301  18    5:1    55           FOR ITEMX := 14 TO 17 DO
  8302  18    5:2    67             BEGIN
  8303  18    5:3    67               GOTOXY( 0, ITEMX);
  8304  18    5:3    72               WRITE( CHR( 29))
  8305  18    5:2    80             END;
  8306  18    5:2    87             
  8307  18    5:1    87           WITH CHARACTR[ CAMPCHAR] DO
  8308  18    5:2    96             BEGIN
  8309  18    5:3    96               IF POSS.POSSCNT = 0 THEN
  8310  18    5:4   104                 EXIT( DSPITEMS);
  8311  18    5:4   108             
  8312  18    5:3   108               FOR ITEMX := 1 TO POSS.POSSCNT DO
  8313  18    5:4   123                 BEGIN
  8314  18    5:5   123                   GOTOXY( 20 -  20 * (ITEMX MOD 2),
  8315  18    5:5   130                           14 + ((ITEMX - 1) DIV 2) );
  8316  18    5:5   140                   IF OBJIDS[ ITEMX - 1] <>
  8317  18    5:5   149                        POSS.POSSESS[ ITEMX].EQINDEX  THEN
  8318  18    5:6   162                     BEGIN
  8319  18    5:7   162                       MOVELEFT( IOCACHE[ GETREC(
  8320  18    5:7   165                                    ZOBJECT,
  8321  18    5:7   166                                    POSS.POSSESS[ ITEMX].EQINDEX,
  8322  18    5:7   176                                    SIZEOF( TOBJREC))],
  8323  18    5:7   182                                 OBJECT,
  8324  18    5:7   185                                 SIZEOF( TOBJREC));
  8325  18    5:7   188                       OBJIDS[ ITEMX - 1] := POSS.POSSESS[ ITEMX].EQINDEX;
  8326  18    5:7   207                       OBJNAMES[ ITEMX - 1][ TRUE]  := OBJECT.NAME;
  8327  18    5:7   224                       OBJNAMES[ ITEMX - 1][ FALSE] := OBJECT.NAMEUNK;
  8328  18    5:7   241                       CANUSE[ ITEMX - 1] := OBJECT.CLASSUSE[ CLASS];
  8329  18    5:7   262                       CURSEDXX[ ITEMX - 1] := OBJECT.CURSED
  8330  18    5:6   272                     END;
  8331  18    5:6   275                     
  8332  18    5:5   275                   WRITE( ITEMX :1);
  8333  18    5:5   283                   WRITE( ')');
  8334  18    5:5   291                   IF POSS.POSSESS[ ITEMX].EQUIPED THEN
  8335  18    5:6   303                     IF CURSEDXX[ ITEMX - 1] THEN
  8336  18    5:7   316                       WRITE( '-')
  8337  18    5:6   324                     ELSE
  8338  18    5:7   326                       WRITE( '*')
  8339  18    5:5   334                   ELSE
  8340  18    5:6   336                     IF POSS.POSSESS[ ITEMX].IDENTIF THEN
  8341  18    5:7   348                       IF CANUSE[ ITEMX - 1] THEN
  8342  18    5:8   361                         WRITE( ' ')
  8343  18    5:7   369                       ELSE
  8344  18    5:8   371                         WRITE( '#')  (* WAS '^' IN LOL *)
  8345  18    5:6   379                     ELSE
  8346  18    5:7   381                       WRITE( '?');
  8347  18    5:5   389                   WRITE( OBJNAMES[ ITEMX - 1][ POSS.POSSESS[ ITEMX].IDENTIF])
  8348  18    5:4   418                 END
  8349  18    5:2   418             END
  8350  18    5:0   425         END;
  8351  18    5:0   444         
  8352  18    5:0   444         
  8353  18    6:D     1       PROCEDURE CASTSPEL( SPELHASH: INTEGER);  (* P010C06 *)
  8354  18    6:D     2         
  8355  18    6:D     2         CONST
  8356  18    6:D     2 
  8357  18    6:D     2               HALITO   =  4178;
  8358  18    6:D     2               MOGREF   =  2409;
  8359  18    6:D     2               KATINO   =  3983;
  8360  18    6:D     2               DUMAPIC  =  3245;
  8361  18    6:D     2               
  8362  18    6:D     2               DILTO    =  3340;
  8363  18    6:D     2               SOPIC    =  1953;
  8364  18    6:D     2               
  8365  18    6:D     2               MAHALITO =  6181;
  8366  18    6:D     2               MOLITO   =  4731;
  8367  18    6:D     2               
  8368  18    6:D     2               MORLIS   =  4744;
  8369  18    6:D     2               DALTO    =  3180;
  8370  18    6:D     2               LAHALITO =  6156;
  8371  18    6:D     2               
  8372  18    6:D     2               MAMORLIS =  7525;
  8373  18    6:D     2               MAKANITO =  6612;
  8374  18    6:D     2               MADALTO  =  4925;
  8375  18    6:D     2               
  8376  18    6:D     2               LAKANITO =  6587;
  8377  18    6:D     2               ZILWAN   =  4573;
  8378  18    6:D     2               MASOPIC  =  3990;
  8379  18    6:D     2               HAMAN    =  1562;
  8380  18    6:D     2               
  8381  18    6:D     2               MALOR    =  3128;
  8382  18    6:D     2               MAHAMAN  =  2597;
  8383  18    6:D     2               TILTOWAI = 11157;
  8384  18    6:D     2               
  8385  18    6:D     2               
  8386  18    6:D     2               KALKI    =  1449;
  8387  18    6:D     2               DIOS     =  2301;
  8388  18    6:D     2               BADIOS   =  3675;
  8389  18    6:D     2               MILWA    =  2889;
  8390  18    6:D     2               PORFIC   =  2287;
  8391  18    6:D     2               
  8392  18    6:D     2               MATU     =  3139;
  8393  18    6:D     2               CALFO    =     0; (* 1717 *)
  8394  18    6:D     2               MANIFO   =  2619;
  8395  18    6:D     2               MONTINO  =  5970;
  8396  18    6:D     2               
  8397  18    6:D     2               LOMILWA  =  5333;
  8398  18    6:D     2               DIALKO   =  2718;
  8399  18    6:D     2               LATUMAPI =  6491;
  8400  18    6:D     2               BAMATU   =  5169;
  8401  18    6:D     2               
  8402  18    6:D     2               DIAL     =   761;
  8403  18    6:D     2               BADIAL   =  1253;
  8404  18    6:D     2               LATUMOFI =  9463;
  8405  18    6:D     2               MAPORFIC =  4322;
  8406  18    6:D     2               
  8407  18    6:D     2               DIALMA   =  1614;
  8408  18    6:D     2               BADIALMA =  2446;
  8409  18    6:D     2               LITOKAN  =  4396;
  8410  18    6:D     2               KANDI    =  1185; (* 1885 *)
  8411  18    6:D     2               DI       =   180;
  8412  18    6:D     2               BADI     =   382;
  8413  18    6:D     2               
  8414  18    6:D     2               LORTO    =  4296;
  8415  18    6:D     2               MADI     =   547;
  8416  18    6:D     2               MABADI   =   759;
  8417  18    6:D     2               LOKTOFEI =  8330;
  8418  18    6:D     2               
  8419  18    6:D     2               MALIKTO  =  5514;
  8420  18    6:D     2               KADORTO  =  6673;
  8421  18    6:D     2         
  8422  18    6:D     2         VAR
  8423  18    6:D     2              USEITEM  : BOOLEAN;
  8424  18    6:D     3              SPELNAME : STRING;
  8425  18    6:D    44              UNUSEDXX : INTEGER;
  8426  18    6:D    45              HASHCALC : INTEGER;
  8427  18    6:D    46              SPELLI   : INTEGER;
  8428  18    6:D    47              HEALME   : INTEGER;
  8429  18    6:D    48       
  8430  18    6:D    48       
  8431  18    7:D     1         PROCEDURE EXITCAST( EXITSTR: STRING);  (* P010C07 *)
  8432  18    7:D    43         
  8433  18    7:0     0           BEGIN
  8434  18    7:1     0             AASTRAA( EXITSTR);
  8435  18    7:1     9             DSPSPELS;
  8436  18    7:1    11             EXIT( CASTSPEL)
  8437  18    7:0    15           END;
  8438  18    7:0    28           
  8439  18    7:0    28           
  8440  18    8:D     1         PROCEDURE HEALWHO;  (* P010C08 *)
  8441  18    8:D     1         
  8442  18    8:D     1           VAR
  8443  18    8:D     1                UNUSED : ARRAY[ 0..41] OF INTEGER;
  8444  18    8:D    43         
  8445  18    8:0     0           BEGIN
  8446  18    8:1     0             HEALME := GETCHARX( TRUE, 'CAST ON WHO');
  8447  18    8:1    23             IF HEALME = -1 THEN
  8448  18    8:2    31               EXITCAST( 'NOT IN THE PARTY')
  8449  18    8:0    50           END;
  8450  18    8:0    64           
  8451  18    8:0    64           
  8452  18    9:D     1         PROCEDURE CHKSPCNT( PRIESTGR: INTEGER; (* P010C09 *)
  8453  18    9:D     2                             SPELLIDX: INTEGER);
  8454  18    9:D     3         
  8455  18    9:0     0           BEGIN
  8456  18    9:1     0             IF USEITEM THEN
  8457  18    9:2     5               EXIT( CHKSPCNT);
  8458  18    9:1     9             IF (CHARACTR[ CAMPCHAR].PRIESTSP[ PRIESTGR] <= 0) OR
  8459  18    9:1    26                (NOT CHARACTR[ CAMPCHAR].SPELLSKN[ SPELLIDX]) THEN
  8460  18    9:2    44               EXITCAST( 'YOU CANT CAST IT')
  8461  18    9:0    63           END;
  8462  18    9:0    78           
  8463  18    9:0    78           
  8464  18   10:D     1         PROCEDURE DECPRIEST( PRIESTGR: INTEGER);  (* P010C0A *)
  8465  18   10:D     2         
  8466  18   10:0     0           BEGIN
  8467  18   10:1     0             IF NOT USEITEM THEN
  8468  18   10:2     6               CHARACTR[ CAMPCHAR].PRIESTSP[ PRIESTGR] :=
  8469  18   10:2    20                 CHARACTR[ CAMPCHAR].PRIESTSP[ PRIESTGR] - 1;
  8470  18   10:1    38             IF FIZZLES > 0 THEN
  8471  18   10:2    43               EXITCAST( 'SPELL HAS NO EFFECT')
  8472  18   10:0    65           END;
  8473  18   10:0    80           
  8474  18   10:0    80           
  8475  18   11:D     1         PROCEDURE DOHEAL( HPTRIES:  INTEGER;  (* P010C0B *)
  8476  18   11:D     2                           MAXHPTRY: INTEGER;
  8477  18   11:D     3                           PRIESTGR: INTEGER;
  8478  18   11:D     4                           SPELLIDX: INTEGER);
  8479  18   11:D     5         
  8480  18   11:D     5           VAR
  8481  18   11:D     5                HPHEALED : INTEGER;
  8482  18   11:D     6         
  8483  18   11:0     0           BEGIN
  8484  18   11:1     0             CHKSPCNT( PRIESTGR, SPELLIDX);
  8485  18   11:1     4             HEALWHO;
  8486  18   11:1     6             DECPRIEST( PRIESTGR);
  8487  18   11:1     9             HPHEALED := 0;
  8488  18   11:1    12             IF HPTRIES = -1 THEN
  8489  18   11:2    18               BEGIN
  8490  18   11:2    18                   (* MADI *)
  8491  18   11:3    18                 HPHEALED := CHARACTR[ HEALME].HPMAX;
  8492  18   11:3    29                 CHARACTR[ HEALME].LOSTXYL.POISNAMT[ 1] := 0;
  8493  18   11:3    45                 IF CHARACTR[ HEALME].STATUS < DEAD THEN
  8494  18   11:4    58                   CHARACTR[ HEALME].STATUS := OK
  8495  18   11:2    67               END
  8496  18   11:1    69             ELSE
  8497  18   11:2    71               WHILE HPTRIES > 0 DO
  8498  18   11:3    76                 BEGIN
  8499  18   11:4    76                   HPHEALED := HPHEALED + (RANDOM MOD MAXHPTRY) + 1;
  8500  18   11:4    89                   HPTRIES := HPTRIES - 1
  8501  18   11:3    90                 END;
  8502  18   11:1    96             CHARACTR[ HEALME].HPLEFT := CHARACTR[ HEALME].HPLEFT + HPHEALED;
  8503  18   11:1   117             IF CHARACTR[ HEALME].HPLEFT > CHARACTR[ HEALME].HPMAX THEN
  8504  18   11:2   138               CHARACTR[ HEALME].HPLEFT := CHARACTR[ HEALME].HPMAX;
  8505  18   11:1   157             GOTOXY( 0, 23);
  8506  18   11:1   162             WRITE( 'CURED ');
  8507  18   11:1   178             WRITE( HPHEALED);
  8508  18   11:1   186             WRITE( ' HP - NOW ');
  8509  18   11:1   206             WRITE( CHARACTR[ HEALME].HPLEFT);
  8510  18   11:1   222             WRITE( '/');
  8511  18   11:1   230             WRITE( CHARACTR[ HEALME].HPMAX);
  8512  18   11:1   246             GOTOXY( 41, 0);
  8513  18   11:1   251             PAUSE2;
  8514  18   11:1   254             DSPSPELS;
  8515  18   11:1   256             EXIT( CASTSPEL)
  8516  18   11:0   260           END;  (* DOHEAL *)
  8517  18   11:0   274           
  8518  18   11:0   274           
  8519  18   12:D     1         PROCEDURE DOKANDI;  (* P010C0C *)
  8520  18   12:D     1         
  8521  18   12:0     0           BEGIN
  8522  18   12:1     0             CHKSPCNT( 5, 42);
  8523  18   12:1     4             DECPRIEST( 5);
  8524  18   12:1     7             DISPSTAT := TRUE;
  8525  18   12:1    12             LLBASE04 := CAMPCHAR;
  8526  18   12:1    17             BASE12.GOTOX := XCASTLE;
  8527  18   12:1    20             XGOTO := XCAMPSTF;
  8528  18   12:1    23             EXIT( CAMP)
  8529  18   12:0    27           END;
  8530  18   12:0    40           
  8531  18   12:0    40           
  8532  18   13:D     1         PROCEDURE DODIKADO( DIKADOXX: INTEGER);  (* P010C0D *)
  8533  18   13:D     2         
  8534  18   13:D     2         
  8535  18   14:D     1           PROCEDURE DIKADORT;  (* P010C0E *)
  8536  18   14:D     1           
  8537  18   14:0     0             BEGIN
  8538  18   14:1     0               IF (RANDOM MOD 100) <=
  8539  18   14:1     7                  4 * CHARACTR[ HEALME].ATTRIB[ VITALITY] THEN
  8540  18   14:2    26                 BEGIN
  8541  18   14:3    26                   CHARACTR[ HEALME].STATUS := OK;
  8542  18   14:3    37                   IF DIKADOXX = 5 THEN
  8543  18   14:4    44                     CHARACTR[ HEALME].HPLEFT := 1
  8544  18   14:3    53                   ELSE
  8545  18   14:4    57                     CHARACTR[ HEALME].HPLEFT := 
  8546  18   14:4    66                       CHARACTR[ HEALME].HPMAX;
  8547  18   14:3    76                   IF CHARACTR[ HEALME].ATTRIB[ VITALITY] = 3 THEN
  8548  18   14:4    94                     CHARACTR[ HEALME].STATUS := LOST
  8549  18   14:3   103                   ELSE
  8550  18   14:4   107                     CHARACTR[ HEALME].ATTRIB[ VITALITY] :=
  8551  18   14:4   120                       CHARACTR[ HEALME].ATTRIB[ VITALITY] - 1
  8552  18   14:2   134                 END;
  8553  18   14:1   137               IF CHARACTR[ HEALME].STATUS = OK THEN
  8554  18   14:2   150                 EXITCAST( 'EXCELSIOR')
  8555  18   14:1   162               ELSE
  8556  18   14:2   166                 BEGIN
  8557  18   14:3   166                   CHARACTR[ HEALME].STATUS := SUCC( CHARACTR[ HEALME].STATUS);
  8558  18   14:3   187                   EXITCAST( 'OOPPS!')
  8559  18   14:2   196                 END
  8560  18   14:0   198             END;  (* DIKADORT *)
  8561  18   14:0   210             
  8562  18   14:0   210             
  8563  18   13:0     0           BEGIN  (* DODIKADO *)
  8564  18   13:1     0             IF DIKADOXX = 5 THEN
  8565  18   13:2     5               CHKSPCNT( DIKADOXX, 43)
  8566  18   13:1     7             ELSE
  8567  18   13:2    11               CHKSPCNT( DIKADOXX, 50);
  8568  18   13:1    15             HEALWHO;
  8569  18   13:1    17             DECPRIEST( DIKADOXX);
  8570  18   13:1    20             IF DIKADOXX = 5 THEN
  8571  18   13:2    25               BEGIN
  8572  18   13:3    25                 IF CHARACTR[ HEALME].STATUS = DEAD THEN
  8573  18   13:4    38                   DIKADORT
  8574  18   13:3    38                 ELSE
  8575  18   13:4    42                   IF CHARACTR[ HEALME].STATUS = ASHES THEN
  8576  18   13:5    55                     EXITCAST( '"KADORTO" NEEDED')
  8577  18   13:2    74               END
  8578  18   13:1    76             ELSE
  8579  18   13:2    78               IF (CHARACTR[ HEALME].STATUS = DEAD) OR
  8580  18   13:2    89                  (CHARACTR[ HEALME].STATUS = ASHES) THEN
  8581  18   13:3   103                 DIKADORT
  8582  18   13:2   103               ELSE
  8583  18   13:3   107                 IF CHARACTR[ HEALME].STATUS = LOST THEN
  8584  18   13:4   120                   EXITCAST( 'LOST');
  8585  18   13:1   129             EXITCAST( 'NOT DEAD')
  8586  18   13:0   140           END;  (* DODIKADO *)
  8587  18   13:0   154           
  8588  18   13:0   154           
  8589  18   15:D     1         PROCEDURE DODUMAPI;  (* P010C0F *)
  8590  18   15:D     1         
  8591  18   15:0     0           BEGIN
  8592  18   15:1     0             IF NOT (USEITEM) THEN
  8593  18   15:2     6               IF (CHARACTR[ CAMPCHAR].MAGESP[ 1] = 0) OR
  8594  18   15:2    23                  NOT CHARACTR[ CAMPCHAR].SPELLSKN[ 4] THEN
  8595  18   15:3    41                 EXITCAST( 'YOU CANT CAST IT');
  8596  18   15:1    62             IF FIZZLES > 0 THEN
  8597  18   15:2    67               EXITCAST( 'SPELL FAILS');
  8598  18   15:1    83             IF NOT USEITEM THEN
  8599  18   15:2    89               CHARACTR[ CAMPCHAR].MAGESP[ 1] :=
  8600  18   15:2   103                 CHARACTR[ CAMPCHAR].MAGESP[ 1] - 1;
  8601  18   15:1   121             LLBASE04 := CAMPCHAR;
  8602  18   15:1   126             BASE12.GOTOX := XGILGAMS;
  8603  18   15:1   129             XGOTO := XCAMPSTF;
  8604  18   15:1   132             EXIT( CAMP)
  8605  18   15:0   136           END;  (* DODUMAPI *)
  8606  18   15:0   148           
  8607  18   15:0   148           
  8608  18   16:D     1         PROCEDURE DOMALOR;  (* P010C10 *)
  8609  18   16:D     1         
  8610  18   16:0     0           BEGIN
  8611  18   16:1     0             IF NOT USEITEM THEN
  8612  18   16:2     6               IF (CHARACTR[ CAMPCHAR].MAGESP[ 7] = 0) OR
  8613  18   16:2    23                  (NOT CHARACTR[ CAMPCHAR].SPELLSKN[ 19]) THEN
  8614  18   16:3    41                 EXITCAST( 'YOU CANT CAST IT');
  8615  18   16:1    62             IF FIZZLES > 0 THEN
  8616  18   16:2    67               EXITCAST( 'SPELL FAILS');
  8617  18   16:1    83             IF NOT USEITEM THEN
  8618  18   16:2    89               CHARACTR[ CAMPCHAR].MAGESP[ 7] :=
  8619  18   16:2   103                 CHARACTR[ CAMPCHAR].MAGESP[ 7] - 1;
  8620  18   16:1   121             LLBASE04 := CAMPCHAR;
  8621  18   16:1   126             BASE12.GOTOX := XINSPECT;
  8622  18   16:1   129             XGOTO := XCAMPSTF;
  8623  18   16:1   132             EXIT( CAMP)
  8624  18   16:0   136           END;  (* DOMALOR *)
  8625  18   16:0   148           
  8626  18   16:0   148           
  8627  18    6:0     0         BEGIN (* CASTSPEL *)
  8628  18    6:1     0           DISPSTAT := FALSE;
  8629  18    6:1     5           USEITEM := SPELHASH > 0;
  8630  18    6:1    10           IF SPELHASH = -1 THEN
  8631  18    6:2    16             BEGIN
  8632  18    6:3    16               GOTOXY( 0, 18);
  8633  18    6:3    21               WRITE( CHR( 11));
  8634  18    6:3    29               WRITE( 'WHAT SPELL ? >' : 24);
  8635  18    6:3    53               GETLINE( SPELNAME);
  8636  18    6:3    58               SPELHASH := LENGTH( SPELNAME);
  8637  18    6:3    64               FOR SPELLI := 1 TO LENGTH( SPELNAME) DO
  8638  18    6:4    80                 BEGIN
  8639  18    6:5    80                   HASHCALC := ORD( SPELNAME[ SPELLI]) - 64;
  8640  18    6:5    89                   SPELHASH := SPELHASH + HASHCALC * HASHCALC * SPELLI
  8641  18    6:4    95                 END;
  8642  18    6:2   109             END;
  8643  18    6:2   109             
  8644  18    6:1   109           GOTOXY( 41, 0);
  8645  18    6:1   114           WRITE( SPELHASH : 6);
  8646  18    6:1   122           WRITE( ' ');
  8647  18    6:1   130           
  8648  18    6:1   130           IF SPELHASH = DIOS THEN
  8649  18    6:2   137             DOHEAL( 1, 8, 1, 23)
  8650  18    6:1   141           ELSE IF SPELHASH = MILWA THEN
  8651  18    6:3   152             BEGIN
  8652  18    6:4   152               CHKSPCNT( 1, 25);
  8653  18    6:4   156               DECPRIEST( 1);
  8654  18    6:4   159               LIGHT := 15 + (RANDOM MOD 15)
  8655  18    6:3   167             END
  8656  18    6:2   170           ELSE IF SPELHASH = DUMAPIC THEN
  8657  18    6:4   179             DODUMAPI
  8658  18    6:3   179           ELSE IF SPELHASH = KANDI THEN
  8659  18    6:5   190             DOKANDI
  8660  18    6:4   190           ELSE IF SPELHASH = LOMILWA THEN
  8661  18    6:6   201             BEGIN
  8662  18    6:7   201               CHKSPCNT( 3, 31);
  8663  18    6:7   205               DECPRIEST( 3);
  8664  18    6:7   208               LIGHT := 32000
  8665  18    6:6   208             END
  8666  18    6:5   213           ELSE IF SPELHASH = LATUMOFI THEN
  8667  18    6:7   222             BEGIN
  8668  18    6:8   222               CHKSPCNT( 4, 37);
  8669  18    6:8   226               HEALWHO;
  8670  18    6:8   228               DECPRIEST( 4);
  8671  18    6:8   231               CHARACTR[ HEALME].LOSTXYL.POISNAMT[ 1] := 0
  8672  18    6:7   244             END
  8673  18    6:6   246           ELSE IF SPELHASH = DIALKO THEN
  8674  18    6:8   255             BEGIN
  8675  18    6:9   255               CHKSPCNT( 3, 32);
  8676  18    6:9   259               HEALWHO;
  8677  18    6:9   261               DECPRIEST( 3);
  8678  18    6:9   264               IF (CHARACTR[ HEALME].STATUS = PLYZE) OR
  8679  18    6:9   274                  (CHARACTR[ HEALME].STATUS = ASLEEP) THEN
  8680  18    6:0   287                 CHARACTR[ HEALME].STATUS := OK;
  8681  18    6:8   297             END
  8682  18    6:7   297           ELSE IF SPELHASH = DIAL THEN
  8683  18    6:9   306             DOHEAL( 2, 8, 4, 35)
  8684  18    6:8   310           ELSE IF SPELHASH = MAPORFIC THEN
  8685  18    6:0   321             BEGIN
  8686  18    6:1   321               CHKSPCNT( 4, 38);
  8687  18    6:1   325               DECPRIEST( 4);
  8688  18    6:1   328               ACMOD2 := 2
  8689  18    6:0   328             END
  8690  18    6:9   331           ELSE IF SPELHASH = DIALMA THEN
  8691  18    6:1   340             DOHEAL( 3, 8, 5, 39)
  8692  18    6:0   344           ELSE IF SPELHASH = DI THEN
  8693  18    6:2   355             DODIKADO( 5)
  8694  18    6:1   356           ELSE IF SPELHASH = MADI THEN
  8695  18    6:3   367             DOHEAL( -1, -1, 6, 46)
  8696  18    6:2   373           ELSE IF SPELHASH = KADORTO THEN
  8697  18    6:4   384             DODIKADO( 7)
  8698  18    6:3   385           ELSE IF SPELHASH = MALOR THEN
  8699  18    6:5   396             DOMALOR
  8700  18    6:4   396           ELSE
  8701  18    6:5   400             EXITCAST( 'WHAT?');
  8702  18    6:1   410           EXITCAST( 'DONE!')
  8703  18    6:0   418         END;  (* CASTSPEL *)
  8704  18    6:0   446         
  8705  18    6:0   446         
  8706  18   17:D     1       PROCEDURE USEITEM;  (* P010C11 *)
  8707  18   17:D     1         
  8708  18   17:D     1         VAR
  8709  18   17:D     1              THEITEM  : TOBJREC;
  8710  18   17:D    40              UNUSEDXX : INTEGER;
  8711  18   17:D    41              UNUSEDYY : INTEGER;
  8712  18   17:D    42              UNUSEDZZ : INTEGER;
  8713  18   17:D    43              ITEMX    : INTEGER;
  8714  18   17:D    44              
  8715  18   17:D    44              
  8716  18   18:D     1         PROCEDURE EXITUSE( EXITSTR: STRING);  (* P010C12 *)
  8717  18   18:D    43         
  8718  18   18:0     0           BEGIN
  8719  18   18:1     0             AASTRAA( EXITSTR);
  8720  18   18:1     9             EXIT( USEITEM)
  8721  18   18:0    13           END;
  8722  18   18:0    26           
  8723  18   18:0    26           
  8724  18   17:0     0         BEGIN (* USEITEM *)
  8725  18   17:1     0           DISPSTAT := FALSE;
  8726  18   17:1     5           REPEAT
  8727  18   17:2     5             GOTOXY( 0, 18);
  8728  18   17:2    10             WRITE( CHR( 11));
  8729  18   17:2    18             WRITE( 'USE ITEM (0=EXIT) ? >');
  8730  18   17:2    49             GETKEY;
  8731  18   17:2    52             WRITELN;
  8732  18   17:2    58             ITEMX := ORD( INCHAR) - ORD( '0');
  8733  18   17:2    63             IF ITEMX = 0 THEN
  8734  18   17:3    69               EXIT( USEITEM);
  8735  18   17:1    73           UNTIL (ITEMX > 0) AND
  8736  18   17:1    77                 (ITEMX <= CHARACTR[ CAMPCHAR].POSS.POSSCNT);
  8737  18   17:1    92           MOVELEFT( IOCACHE[ GETREC(
  8738  18   17:1    95                        ZOBJECT,
  8739  18   17:1    96                        CHARACTR[ CAMPCHAR].POSS.POSSESS[ ITEMX].EQINDEX,
  8740  18   17:1   112                        SIZEOF( TOBJREC))],
  8741  18   17:1   118                     THEITEM,
  8742  18   17:1   121                     SIZEOF( TOBJREC));
  8743  18   17:1   124           IF THEITEM.SPELLPWR = 0 THEN
  8744  18   17:2   130             EXITUSE( 'POWERLESS');
  8745  18   17:1   144           IF THEITEM.OBJTYPE <> SPECIAL THEN
  8746  18   17:2   150             IF NOT CHARACTR[ CAMPCHAR].POSS.POSSESS[ ITEMX].EQUIPED THEN
  8747  18   17:3   169               EXITUSE( 'NOT EQUIPPED');
  8748  18   17:1   186           IF (RANDOM MOD 100) < THEITEM.CHGCHANC THEN
  8749  18   17:2   198             CHARACTR[ CAMPCHAR].POSS.POSSESS[ ITEMX].EQINDEX := 
  8750  18   17:2   215               THEITEM.CHANGETO;
  8751  18   17:1   218           CASTSPEL( SCNTOC.SPELLHSH[ THEITEM.SPELLPWR])
  8752  18   17:0   226         END;  (* USEITEM *)
  8753  18   17:0   242         
  8754  18   17:0   242         
  8755  18   17:0   242 
  8756  18   17:0   242       
  8757  18   19:D     1   PROCEDURE DROPITEM;  (* P010C13 *)
  8758  18   19:D     1       
  8759  18   19:D     1       VAR
  8760  18   19:D     1            UNUSEDXX : INTEGER;
  8761  18   19:D     2            UNUSEDYY : INTEGER;
  8762  18   19:D     3            POSSX    : INTEGER;
  8763  18   19:D     4            POSSI    : INTEGER;
  8764  18   19:D     5         
  8765  18   19:D     5         
  8766  18   20:D     1         PROCEDURE EXITDROP( EXITSTR: STRING);  (* P010C14 *)
  8767  18   20:D    43         
  8768  18   20:0     0           BEGIN
  8769  18   20:1     0             AASTRAA( EXITSTR);
  8770  18   20:1     9             EXIT( DROPITEM)
  8771  18   20:0    13           END;
  8772  18   20:0    26           
  8773  18   20:0    26           
  8774  18   19:0     0         BEGIN  (* DROPITEM *)
  8775  18   19:1     0           DISPSTAT := FALSE;
  8776  18   19:1     5           REPEAT
  8777  18   19:2     5             GOTOXY( 0, 18);
  8778  18   19:2    10             WRITE( CHR( 11));
  8779  18   19:2    18             WRITE(  'DROP ITEM (0=EXIT) ? >');
  8780  18   19:2    50             GETKEY;
  8781  18   19:2    53             POSSI := ORD( INCHAR) - ORD( '0');
  8782  18   19:2    58             IF POSSI = 0 THEN
  8783  18   19:3    63               EXIT( DROPITEM);
  8784  18   19:1    67           UNTIL (POSSI > 0) AND
  8785  18   19:1    70                 (POSSI <= CHARACTR[ CAMPCHAR].POSS.POSSCNT);
  8786  18   19:1    84           IF CHARACTR[ CAMPCHAR].POSS.POSSESS[ POSSI].CURSED THEN
  8787  18   19:2   101             EXITDROP( 'CURSED');
  8788  18   19:1   112           IF CHARACTR[ CAMPCHAR].POSS.POSSESS[ POSSI].EQUIPED THEN
  8789  18   19:2   129             EXITDROP( 'EQUIPPED');
  8790  18   19:1   142           FOR POSSX := POSSI + 1 TO CHARACTR[ CAMPCHAR].POSS.POSSCNT DO
  8791  18   19:2   163             CHARACTR[ CAMPCHAR].POSS.POSSESS[ POSSX - 1] :=
  8792  18   19:2   179               CHARACTR[ CAMPCHAR].POSS.POSSESS[ POSSX];
  8793  18   19:1   202           CHARACTR[ CAMPCHAR].POSS.POSSCNT :=
  8794  18   19:1   211                                           CHARACTR[ CAMPCHAR].POSS.POSSCNT - 1;
  8795  18   19:1   223           DSPITEMS;
  8796  18   19:1   225           EXITDROP( 'DROPPED')
  8797  18   19:0   235         END;  (* DROPITEM *)
  8798  18   19:0   254         
  8799  18   19:0   254 (*$I WIZ1C:CAMP      *)
  8799  18   19:0   254 (*$I WIZ1C:CAMP2     *)
  8800  18   19:0   254       
  8801  18   21:D     1     PROCEDURE IDENTIFY;  (* P010C15 *)
  8802  18   21:D     1       
  8803  18   21:D     1         VAR
  8804  18   21:D     1              UNUSEDXX : INTEGER;
  8805  18   21:D     2              
  8806  18   21:D     2              
  8807  18   22:D     1       PROCEDURE EXITIDNT( EXITSTR: STRING);  (* P010C16 *)
  8808  18   22:D    43         
  8809  18   22:0     0           BEGIN
  8810  18   22:1     0             AASTRAA( EXITSTR);
  8811  18   22:1     9             EXIT( IDENTIFY)
  8812  18   22:0    13           END;
  8813  18   22:0    26           
  8814  18   22:0    26           
  8815  18   21:0     0         BEGIN (* IDENTIFY *)
  8816  18   21:1     0           DISPSTAT := FALSE;
  8817  18   21:1     5           IF CHARACTR[ CAMPCHAR].CLASS <> BISHOP THEN
  8818  18   21:2    18               EXITIDNT( 'NOT BISHOP');
  8819  18   21:1    33           LLBASE04 := CAMPCHAR;
  8820  18   21:1    38           BASE12.GOTOX := XTRAININ;
  8821  18   21:1    41           XGOTO := XCAMPSTF;
  8822  18   21:1    44           EXIT( CAMP)
  8823  18   21:0    48         END;  (* IDENTIFY *)
  8824  18   21:0    60         
  8825  18   21:0    60         
  8826  18   23:D     1       PROCEDURE DOTRADE;  (* P010C17 *)
  8827  18   23:D     1       
  8828  18   23:D     1         VAR
  8829  18   23:D     1              GOLD2TRA : TWIZLONG;
  8830  18   23:D     4              TRADETO  : INTEGER;
  8831  18   23:D     5              GOLDSTR  : STRING;
  8832  18   23:D    46              GOLDX    : INTEGER;
  8833  18   23:D    47              TEMP0001 : INTEGER; (* MULTIPLE USES *)
  8834  18   23:D    48              ITEMX    : INTEGER;
  8835  18   23:D    49              
  8836  18   23:D    49              
  8837  18   24:D     1         PROCEDURE EXITTRAD( EXITSTR: STRING);  (* P010C18 *)
  8838  18   24:D    43         
  8839  18   24:0     0           BEGIN
  8840  18   24:1     0             AASTRAA( EXITSTR);
  8841  18   24:1     9             EXIT( DOTRADE)
  8842  18   24:0    13           END;
  8843  18   24:0    26           
  8844  18   24:0    26           
  8845  18   25:D     1         PROCEDURE TRADGOLD;  (* P010C19 *)
  8846  18   25:D     1         
  8847  18   25:D     1           VAR
  8848  18   25:D     1                TEMPGOLD : TWIZLONG;
  8849  18   25:D     4                MULT10   : INTEGER;
  8850  18   25:D     5         
  8851  18   25:0     0           BEGIN
  8852  18   25:1     0             GOTOXY( 0, 18);
  8853  18   25:1     5             WRITE( CHR( 11));
  8854  18   25:1    13             WRITE( 'AMT OF GOLD ? >');
  8855  18   25:1    38             GETLINE( GOLDSTR);
  8856  18   25:1    44             FILLCHAR( TEMPGOLD, 6, 0);
  8857  18   25:1    51             FILLCHAR( GOLD2TRA, 6, 0);
  8858  18   25:1    59             TEMP0001 := 0;
  8859  18   25:1    63             MULT10 := 10;
  8860  18   25:1    66             FOR GOLDX := 1 TO LENGTH( GOLDSTR) DO
  8861  18   25:2    84               IF (ORD( GOLDSTR[ GOLDX]) < ORD( '0')) OR
  8862  18   25:2    93                  (ORD( GOLDSTR[ GOLDX]) > ORD( '9')) OR
  8863  18   25:2   103                  (GOLDX > 12) OR
  8864  18   25:2   109                  (TEMP0001 = -1)    THEN
  8865  18   25:3   118                 TEMP0001 := -1
  8866  18   25:2   118               ELSE
  8867  18   25:3   125                 BEGIN
  8868  18   25:4   125                   MULTLONG( GOLD2TRA, MULT10);
  8869  18   25:4   133                   TEMPGOLD.LOW := ORD( GOLDSTR[ GOLDX]) - ORD( '0');
  8870  18   25:4   144                   ADDLONGS( GOLD2TRA, TEMPGOLD)
  8871  18   25:3   149                 END;
  8872  18   25:1   162             IF TEMP0001 = -1 THEN
  8873  18   25:2   170               EXITTRAD( 'BAD AMT');
  8874  18   25:1   182             IF TESTLONG( CHARACTR[ CAMPCHAR].GOLD, GOLD2TRA) < 0 THEN
  8875  18   25:2   203               EXITTRAD( 'NOT ENOUGH $');
  8876  18   25:1   220             ADDLONGS( CHARACTR[ TRADETO].GOLD, GOLD2TRA);
  8877  18   25:1   235             SUBLONGS( CHARACTR[ CAMPCHAR].GOLD, GOLD2TRA)
  8878  18   25:0   247           END;  (* TRADGOLD *)
  8879  18   25:0   264           
  8880  18   25:0   264           
  8881  18   26:D     1         PROCEDURE TRADITEM;  (* P010C1A *)
  8882  18   26:D     1         
  8883  18   26:0     0           BEGIN
  8884  18   26:1     0             REPEAT
  8885  18   26:2     0               REPEAT
  8886  18   26:3     0                 GOTOXY( 0, 18);
  8887  18   26:3     5                 WRITE( CHR( 11));
  8888  18   26:3    13                 WRITE( 'WHAT ITEM ([RET] EXITS) ? >');
  8889  18   26:3    50                 GETKEY;
  8890  18   26:3    53                 ITEMX := ORD( INCHAR) - ORD( '0');
  8891  18   26:3    59                 IF INCHAR = CHR( CRETURN) THEN
  8892  18   26:4    64                   EXIT( DOTRADE)
  8893  18   26:2    68               UNTIL (ITEMX > 0) AND
  8894  18   26:2    73                     (ITEMX <= CHARACTR[ CAMPCHAR].POSS.POSSCNT);
  8895  18   26:2    89               IF CHARACTR[ TRADETO].POSS.POSSCNT = 8 THEN
  8896  18   26:3   102                 EXITTRAD( 'FULL');
  8897  18   26:2   111               IF CHARACTR[ CAMPCHAR].POSS.POSSESS[ ITEMX].CURSED THEN
  8898  18   26:3   130                 EXITTRAD( 'CURSED');
  8899  18   26:2   141               IF CHARACTR[ CAMPCHAR].POSS.POSSESS[ ITEMX].EQUIPED THEN
  8900  18   26:3   160                 EXITTRAD( 'EQUIPPED');
  8901  18   26:2   173               TEMP0001 := CHARACTR[ TRADETO].POSS.POSSCNT + 1;
  8902  18   26:2   187               CHARACTR[ TRADETO].POSS.POSSESS[ TEMP0001] :=
  8903  18   26:2   203                 CHARACTR[ CAMPCHAR].POSS.POSSESS[ ITEMX];
  8904  18   26:2   221               CHARACTR[ TRADETO].POSS.POSSCNT := TEMP0001;
  8905  18   26:2   234               FOR TEMP0001 := ITEMX + 1 TO CHARACTR[ CAMPCHAR].POSS.POSSCNT DO
  8906  18   26:3   260                 CHARACTR[ CAMPCHAR].POSS.POSSESS[ TEMP0001 - 1] :=
  8907  18   26:3   278                   CHARACTR[ CAMPCHAR].POSS.POSSESS[ TEMP0001];
  8908  18   26:2   306               CHARACTR[ CAMPCHAR].POSS.POSSCNT :=
  8909  18   26:2   315                                           CHARACTR[ CAMPCHAR].POSS.POSSCNT - 1;
  8910  18   26:2   327               DSPITEMS
  8911  18   26:1   327             UNTIL FALSE
  8912  18   26:0   329           END;  (* TRADITEM *)
  8913  18   26:0   350       
  8914  18   26:0   350       
  8915  18   23:0     0         BEGIN (* DOTRADE *)
  8916  18   23:1     0           DISPSTAT := FALSE;
  8917  18   23:1     5           REPEAT
  8918  18   23:2     5             TRADETO := GETCHARX( TRUE, 'TRADE WITH');
  8919  18   23:2    26             IF TRADETO = -1 THEN
  8920  18   23:3    32               EXIT( DOTRADE);
  8921  18   23:1    36           UNTIL TRADETO <> CAMPCHAR;
  8922  18   23:1    43           TRADGOLD;
  8923  18   23:1    45           TRADITEM
  8924  18   23:0    45         END;  (* DOTRADE *)
  8925  18   23:0    62         
  8926  18   23:0    62         
  8927  18   27:D     1       PROCEDURE CAMPDO;  (* P010C1B *)
  8928  18   27:D     1       
  8929  18   27:D     1         VAR
  8930  18   27:D     1              MENUTYPE : INTEGER;
  8931  18   27:D     2       
  8932  18   27:D     2       
  8933  18   28:D     1         PROCEDURE CAMPMENU;  (* P010C1C *)
  8934  18   28:D     1         
  8935  18   28:D     1         
  8936  18   29:D     1           PROCEDURE DSPSTATS;  (* P010C1D *)
  8937  18   29:D     1 
  8938  18   29:D     1 
  8939  18   30:D     1             PROCEDURE CHEVRONS;  (* P010C1E *)
  8940  18   30:D     1       
  8941  18   30:D     1               VAR
  8942  18   30:D     1                    INDX     : INTEGER;
  8943  18   30:D     2                    LOSTXYL4 : PACKED ARRAY[ 0..15] OF BOOLEAN;
  8944  18   30:D     3             
  8945  18   30:0     0               BEGIN
  8946  18   30:1     0                 MOVELEFT( CHARACTR[ CAMPCHAR].LOSTXYL.AWARDS[ 4], LOSTXYL4, 2);
  8947  18   30:1    21                 WRITE( '"');   (* 1 DOUBLE QUOTE *)
  8948  18   30:1    29                 FOR INDX := 0 TO 15 DO
  8949  18   30:2    40                   IF LOSTXYL4[ INDX] THEN
  8950  18   30:3    49                     WRITE( COPY( '>!$#&*<?BCPKODG@', INDX + 1, 1) );
  8951  18   30:1    93                 WRITE(  '" ')
  8952  18   30:0   105               END;  (* CHEVRONS *)
  8953  18   30:0   120         
  8954  18   30:0   120         
  8955  18   30:0   120         
  8956  18   29:0     0             BEGIN  (* DSPSTATS *)
  8957  18   29:1     0               WITH CHARACTR[ CAMPCHAR] DO
  8958  18   29:2     9                 BEGIN
  8959  18   29:3     9                   WRITE( CHR( 12));
  8960  18   29:3    17                   WRITE( NAME);
  8961  18   29:3    25                   WRITE( ' ');
  8962  18   29:3    33                   IF LOSTXYL.AWARDS[ 4] > 0 THEN
  8963  18   29:4    46                     CHEVRONS;
  8964  18   29:3    48                   WRITE( SCNTOC.RACE[ RACE]);
  8965  18   29:3    63                   WRITE( ' ');
  8966  18   29:3    71                   WRITE( COPY( SCNTOC.ALIGN[ ALIGN], 1, 1) );
  8967  18   29:3    95                   WRITE( '-');
  8968  18   29:3   103                   WRITE( SCNTOC.CLASS[ CLASS]);
  8969  18   29:3   118                   WRITELN;
  8970  18   29:3   124                   WRITELN;
  8971  18   29:3   130                   WRITE( 'STRENGTH' :12);
  8972  18   29:3   148                   WRITE( ATTRIB[ STRENGTH] :3);
  8973  18   29:3   163                   WRITE( 'GOLD ' :9);
  8974  18   29:3   178                   PRNTLONG( GOLD);
  8975  18   29:3   184                   WRITELN;
  8976  18   29:3   190                   WRITE( 'I.Q.' :12);
  8977  18   29:3   204                   WRITE( ATTRIB[ IQ] :3);
  8978  18   29:3   219                   WRITE( 'EXP ' :9);
  8979  18   29:3   233                   PRNTLONG( EXP);
  8980  18   29:3   239                   WRITELN;
  8981  18   29:3   245                   WRITE( 'PIETY' :12);
  8982  18   29:3   260                   WRITE( ATTRIB[ PIETY] :3);
  8983  18   29:3   275                   WRITELN;
  8984  18   29:3   281                   WRITE( 'VITALITY' :12);
  8985  18   29:3   299                   WRITE( ATTRIB[ VITALITY] :3);
  8986  18   29:3   314                   WRITE( 'LEVEL ' :9);
  8987  18   29:3   330                   WRITE( CHARLEV :3);
  8988  18   29:3   340                   WRITE( 'AGE ' :9);
  8989  18   29:3   354                   WRITE( (AGE DIV 52) :3);
  8990  18   29:3   366                   WRITELN;
  8991  18   29:3   372                   WRITE( 'AGILITY' :12);
  8992  18   29:3   389                   WRITE( ATTRIB[ AGILITY] :3);
  8993  18   29:3   404                   WRITE( 'HITS ' :9);
  8994  18   29:3   419                   WRITE( HPLEFT :3);
  8995  18   29:3   429                   WRITE( '/');
  8996  18   29:3   437                   WRITE( HPMAX :3);
  8997  18   29:3   447                   WRITE( 'AC' :4);
  8998  18   29:3   459                   WRITE( (ARMORCL - ACMOD2) :4);
  8999  18   29:3   471                   WRITELN;
  9000  18   29:3   477                   WRITE( 'LUCK' : 12);
  9001  18   29:3   491                   WRITE( ATTRIB[ LUCK] :3);
  9002  18   29:3   506                   WRITE( 'STATUS ' :9);
  9003  18   29:3   523                   WRITE( SCNTOC.STATUS[ STATUS]);
  9004  18   29:3   538                   IF LOSTXYL.POISNAMT[ 1] > 0 THEN
  9005  18   29:4   551                     WRITE( ' & POISONED');
  9006  18   29:3   572                   WRITELN;
  9007  18   29:3   578                   DSPSPELS;
  9008  18   29:3   580                   DSPITEMS
  9009  18   29:2   580                 END
  9010  18   29:0   582             END;
  9011  18   29:0   594         
  9012  18   29:0   594         
  9013  18   28:0     0           BEGIN  (* CAMPMENU *)
  9014  18   28:1     0             WITH CHARACTR[ CAMPCHAR] DO
  9015  18   28:2     9               BEGIN
  9016  18   28:3     9                 IF DISPSTAT THEN
  9017  18   28:4    15                   DSPSTATS;
  9018  18   28:3    17                 GOTOXY( 0, 18);
  9019  18   28:3    22                 IF XGOTO = XINSPCT3 THEN
  9020  18   28:4    27                   MENUTYPE := 0
  9021  18   28:3    27                 ELSE IF XGOTO = XINSPECT THEN
  9022  18   28:5    38                   MENUTYPE := 1
  9023  18   28:4    38                 ELSE IF STATUS = OK THEN
  9024  18   28:6    51                   MENUTYPE := 2
  9025  18   28:5    51                 ELSE
  9026  18   28:6    57                   MENUTYPE := 1;
  9027  18   28:6    61                   
  9028  18   28:3    61                 IF MENUTYPE = 2 THEN
  9029  18   28:4    68                   BEGIN
  9030  18   28:5    68                     WRITE( CHR( 11));
  9031  18   28:5    76                     WRITELN( 'YOU MAY E)QUIP, D)ROP AN ITEM, T)RADE,');
  9032  18   28:5   130                     WRITE( ' ' :8);
  9033  18   28:5   138                     WRITELN( 'R)EAD SPELL BOOKS, CAST S)PELLS,');
  9034  18   28:5   186                     WRITE( ' ' :8);
  9035  18   28:5   194                     WRITELN( 'U)SE AN ITEM, I)DENTIFY AN ITEM,');
  9036  18   28:5   242                     WRITE( ' ' :8);
  9037  18   28:5   250                     WRITELN( 'OR L)EAVE.')
  9038  18   28:4   276                   END
  9039  18   28:3   276                 ELSE IF MENUTYPE = 1 THEN
  9040  18   28:5   285                   BEGIN
  9041  18   28:6   285                     WRITE( CHR( 11));
  9042  18   28:6   293                     WRITELN( 'YOU MAY E)QUIP, D)ROP AN ITEM, T)RADE,');
  9043  18   28:6   347                     WRITE( ' ' :8);
  9044  18   28:6   355                     WRITELN( 'R)EAD SPELL BOOKS, OR L)EAVE.')
  9045  18   28:5   400                   END
  9046  18   28:4   400                 ELSE
  9047  18   28:5   402                   BEGIN
  9048  18   28:6   402                     WRITE( CHR( 11));
  9049  18   28:6   410                     WRITELN( 'YOU MAY R)EAD SPELL BOOKS OR L)EAVE.')
  9050  18   28:5   462                   END;
  9051  18   28:2   462               END
  9052  18   28:0   462           END;  (* CAMPMENU *)
  9053  18   28:0   478           
  9054  18   28:0   478           
  9055  18   27:0     0         BEGIN (* CAMPDO *)
  9056  18   27:1     0           CAMPMENU;
  9057  18   27:1     2           DISPSTAT := TRUE;
  9058  18   27:1     7           REPEAT
  9059  18   27:2     7             GOTOXY( 41, 0);
  9060  18   27:2    12             GETKEY
  9061  18   27:1    12           UNTIL (INCHAR = 'R') OR (INCHAR = 'L') OR
  9062  18   27:1    22                 ((MENUTYPE > 0) AND
  9063  18   27:1    25                  ((INCHAR = 'T') OR (INCHAR = 'D') OR (INCHAR = 'E'))) OR
  9064  18   27:1    38                 ((MENUTYPE > 1) AND
  9065  18   27:1    41                  ((INCHAR = 'I') OR (INCHAR = 'S') OR (INCHAR = 'U')));
  9066  18   27:1    56           
  9067  18   27:1    56           CASE INCHAR OF
  9068  18   27:1    59             'L':  EXIT( CAMPDO);
  9069  18   27:1    65             'E':  IF MENUTYPE > 0 THEN
  9070  18   27:3    70                     BEGIN
  9071  18   27:4    70                       XGOTO := XEQPDSP;
  9072  18   27:4    73                       LLBASE04 := CAMPCHAR;
  9073  18   27:4    78                       EXIT( CAMP)
  9074  18   27:3    82                     END;
  9075  18   27:1    84             'R':  BEGIN
  9076  18   27:3    84                     XGOTO := XCAMPSTF;
  9077  18   27:3    87                     BASE12.GOTOX := XDONE;
  9078  18   27:3    90                     LLBASE04 := CAMPCHAR;
  9079  18   27:3    95                     EXIT( CAMP)
  9080  18   27:2    99                   END;
  9081  18   27:1   101             'D':  IF MENUTYPE > 0 THEN
  9082  18   27:3   106                     DROPITEM;
  9083  18   27:1   110             'I':  IF MENUTYPE = 2 THEN
  9084  18   27:3   115                     IDENTIFY;
  9085  18   27:1   119             'S':  IF MENUTYPE = 2 THEN
  9086  18   27:3   124                     CASTSPEL( -1);
  9087  18   27:1   130             'U':  IF MENUTYPE = 2 THEN
  9088  18   27:3   135                     USEITEM;
  9089  18   27:1   139             'T':  DOTRADE
  9090  18   27:1   139            END
  9091  18   27:0   186         END;  (* CAMPDO *)
  9092  18   27:0   200         
  9093  18   27:0   200         
  9094  18    3:0     0       BEGIN  (* INSPECT *)
  9095  18    3:1     0         CAMPCHAR := LLBASE04;
  9096  18    3:1     3         XGOTO2 := XGOTO;
  9097  18    3:1     6         WRITE( CHR( 12));
  9098  18    3:1    14         REPEAT
  9099  18    3:2    14           CAMPDO;
  9100  18    3:1    16         UNTIL INCHAR = 'L';
  9101  18    3:1    21         WRITE( CHR( 12))
  9102  18    3:0    29       END;   (* INSPECT *)
  9103  18    3:0    44       
  9104  18    3:0    44       
  9105  18   31:D     1   PROCEDURE CAMPMEN2;  (* P010C1F *)
  9106  18   31:D     1   
  9107  18   31:D     1     VAR
  9108  18   31:D     1          CHARX : INTEGER;
  9109  18   31:D     2       
  9110  18   31:D     2       
  9111  18   32:D     1     PROCEDURE DSP1LINE( CHARX: INTEGER);  (* P010C20 *)
  9112  18   32:D     2     
  9113  18   32:0     0       BEGIN
  9114  18   32:1     0         GOTOXY(  0, 3 + CHARX);
  9115  18   32:1     7         WRITE( CHR( 29));
  9116  18   32:1    15         WRITE( (CHARX + 1) : 2);
  9117  18   32:1    25         WRITE( ' ');
  9118  18   32:1    33         WRITE( CHARACTR[ CHARX].NAME);
  9119  18   32:1    45         GOTOXY( 19, 3 + CHARX);
  9120  18   32:1    52         WRITE( COPY( SCNTOC.ALIGN[ CHARACTR[ CHARX].ALIGN], 1, 1));
  9121  18   32:1    80         WRITE( '-');
  9122  18   32:1    88         WRITE( COPY( SCNTOC.CLASS[ CHARACTR[ CHARX].CLASS], 1, 3));
  9123  18   32:1   116         WRITE( ' ');
  9124  18   32:1   124         IF CHARACTR[ CHARX].ARMORCL - ACMOD2 > -10 THEN
  9125  18   32:2   138           WRITE( (CHARACTR[ CHARX].ARMORCL - ACMOD2) : 2)
  9126  18   32:1   154         ELSE
  9127  18   32:2   156           WRITE( 'LO');
  9128  18   32:1   168         WRITE( CHARACTR[ CHARX].HPLEFT : 5);
  9129  18   32:1   182         LLBASE04 := CHARACTR[ CHARX].HEALPTS -
  9130  18   32:1   189                     CHARACTR[ CHARX].LOSTXYL.POISNAMT[ 1];
  9131  18   32:1   205         IF LLBASE04 > 0 THEN
  9132  18   32:2   210           WRITE( '+')
  9133  18   32:1   218         ELSE IF LLBASE04 < 0 THEN
  9134  18   32:3   225           WRITE( '-')
  9135  18   32:2   233         ELSE
  9136  18   32:3   235           WRITE( ' ');
  9137  18   32:3   243                     
  9138  18   32:1   243         IF CHARACTR[ CHARX].STATUS = OK THEN
  9139  18   32:2   254           IF CHARACTR[ CHARX].LOSTXYL.POISNAMT[ 1] <> 0 THEN
  9140  18   32:3   271             WRITELN( 'POISON')
  9141  18   32:2   293           ELSE
  9142  18   32:3   295             WRITELN( CHARACTR[ CHARX].HPMAX :4)
  9143  18   32:1   315         ELSE
  9144  18   32:2   317           WRITELN( SCNTOC.STATUS[ CHARACTR[ CHARX].STATUS]);
  9145  18   32:0   342       END;
  9146  18   32:0   354       
  9147  18   32:0   354       
  9148  18   31:0     0     BEGIN (* CAMPMEN2 *)
  9149  18   31:1     0       WRITE( CHR( 12));
  9150  18   31:1     8       WRITELN( 'CAMP' :22);
  9151  18   31:1    28       WRITELN;
  9152  18   31:1    34       WRITELN( ' # CHARACTER NAME  CLASS AC HITS STATUS');
  9153  18   31:1    89       FOR CHARX := 0 TO PARTYCNT - 1 DO
  9154  18   31:2   102         BEGIN
  9155  18   31:3   102           DSP1LINE( CHARX)
  9156  18   31:2   103         END;
  9157  18   31:1   112       GOTOXY( 0, 12);
  9158  18   31:1   117       WRITELN( 'YOU MAY R)EORDER, E)QUIP, D)ISBAND,');
  9159  18   31:1   168       WRITE( ' ' :8);
  9160  18   31:1   176       WRITELN( '#) TO INSPECT, OR');
  9161  18   31:1   209       WRITE( ' ' :8);
  9162  18   31:1   217       WRITELN( 'L)EAVE THE CAMP.')
  9163  18   31:0   249     END;  (* CAMPMEN2 *)
  9164  18   31:0   264       
  9165  18   31:0   264       
  9166  18   33:D     1   PROCEDURE DISBAND;  (* P010C21 *)
  9167  18   33:D     1   
  9168  18   33:D     1   
  9169  18   34:D     1     PROCEDURE CONFIRM( NULLRE :STRING);  (* P010C22 *)
  9170  18   34:D    43     
  9171  18   34:0     0       BEGIN (* CONFIRM *)
  9172  18   34:1     0         WRITE( CHR( 12));
  9173  18   34:1    13         WRITE( NULLRE);
  9174  18   34:1    22         WRITE( 'CONFIRM (Y/N) ?');
  9175  18   34:1    47         REPEAT
  9176  18   34:2    47           GOTOXY( 41, 0);
  9177  18   34:2    52           READ( INCHAR)
  9178  18   34:1    60         UNTIL (INCHAR = 'Y') OR (INCHAR = 'N');
  9179  18   34:1    69         IF INCHAR = 'N' THEN
  9180  18   34:2    74           EXIT( DISBAND)
  9181  18   34:0    78       END;  (* CONFIRM *)
  9182  18   34:0    92       
  9183  18   34:0    92       
  9184  18   33:0     0     BEGIN (* DISBAND *)
  9185  18   33:1     0       CONFIRM( '');
  9186  18   33:1     5       CONFIRM( 'RE-');
  9187  18   33:1    13       FOR LLBASE04 := 0 TO PARTYCNT - 1 DO
  9188  18   33:2    26         BEGIN
  9189  18   33:3    26           WITH CHARACTR[ LLBASE04] DO
  9190  18   33:4    33             BEGIN
  9191  18   33:5    33               INMAZE := FALSE;
  9192  18   33:5    38               LOSTXYL.LOCATION[ 1] := MAZEX;
  9193  18   33:5    49               LOSTXYL.LOCATION[ 2] := MAZEY;
  9194  18   33:5    60               LOSTXYL.LOCATION[ 3] := MAZELEV;
  9195  18   33:5    71               AGE := AGE + 25;
  9196  18   33:5    80               MOVELEFT( CHARACTR[ LLBASE04],
  9197  18   33:5    86                         IOCACHE[ GETRECW(
  9198  18   33:5    89                                          ZCHAR,
  9199  18   33:5    90                                          CHARDISK[ LLBASE04],
  9200  18   33:5    96                                          SIZEOF( TCHAR))],
  9201  18   33:5   104                         SIZEOF( TCHAR) )
  9202  18   33:4   109             END
  9203  18   33:2   109         END;
  9204  18   33:2   116         
  9205  18   33:1   116         MOVELEFT( IOCACHE[ GETREC( ZZERO, 0, SIZEOF( TSCNTOC))], 
  9206  18   33:1   129                   SCNTOC,
  9207  18   33:1   133                   SIZEOF( TSCNTOC) );
  9208  18   33:1   138         LLBASE04 := -2;
  9209  18   33:1   142         XGOTO := XSCNMSG;
  9210  18   33:1   145         EXIT( CAMP)
  9211  18   33:0   149     END;  (* DISBAND *)
  9212  18   33:0   164         
  9213  18   33:0   164         
  9214  18    1:0     0     BEGIN  (* CAMP *)
  9215  18    1:1     0       DISPSTAT := TRUE;
  9216  18    1:1     4       FOR OBJI := 1 TO 8 DO
  9217  18    1:2    21         OBJIDS[ OBJI - 1] := -1;
  9218  18    1:1    43       TEXTMODE;
  9219  18    1:1    46       IF (XGOTO = XBCK2CMP) OR
  9220  18    1:1    49          (XGOTO = XBK2CMP2) THEN
  9221  18    1:2    55         BEGIN
  9222  18    1:3    55           XGOTO := XGOTO2;
  9223  18    1:3    58           IF XGOTO = XINSPCT2 THEN
  9224  18    1:4    63             INSPECT
  9225  18    1:2    63         END;
  9226  18    1:1    65       IF XGOTO = XINSPECT THEN
  9227  18    1:2    70         BEGIN
  9228  18    1:3    70           INSPECT;
  9229  18    1:3    72           XGOTO := XGILGAMS;
  9230  18    1:3    75           EXIT( CAMP)
  9231  18    1:2    79         END;
  9232  18    1:1    79       IF XGOTO = XINSPCT3 THEN
  9233  18    1:2    84         BEGIN
  9234  18    1:3    84           LLBASE04 := 0;
  9235  18    1:3    87           INSPECT;
  9236  18    1:3    89           XGOTO := XBCK2ROL;
  9237  18    1:3    92           EXIT( CAMP)
  9238  18    1:2    96         END;
  9239  18    1:2    96       
  9240  18    1:1    96       REPEAT
  9241  18    1:2    96         UNITCLEAR( 1);
  9242  18    1:2    99         CAMPMEN2;
  9243  18    1:2   101         GOTOXY( 41, 0);
  9244  18    1:2   106         GETKEY;
  9245  18    1:2   109         IF (INCHAR > '0') AND (INCHAR <= CHR( ORD( '0') + PARTYCNT)) THEN
  9246  18    1:3   120           BEGIN
  9247  18    1:4   120             LLBASE04 := ORD( INCHAR) - ORD( '1');
  9248  18    1:4   125             FOR OBJI := 1 TO 8 DO
  9249  18    1:5   142               OBJIDS[ OBJI - 1] := -1;
  9250  18    1:4   164             INSPECT
  9251  18    1:3   164           END
  9252  18    1:2   166         ELSE
  9253  18    1:3   168           BEGIN
  9254  18    1:4   168             CASE INCHAR OF
  9255  18    1:4   171              'R':  BEGIN
  9256  18    1:6   171                      XGOTO := XREORDER;
  9257  18    1:6   174                      EXIT( CAMP)
  9258  18    1:5   178                    END;
  9259  18    1:4   180              'L':  BEGIN
  9260  18    1:6   180                      XGOTO := XCMP2EQ6;
  9261  18    1:6   183                      EXIT( CAMP)
  9262  18    1:5   187                    END;
  9263  18    1:4   189              'E':  BEGIN
  9264  18    1:6   189                      XGOTO := XEQPDSP;
  9265  18    1:6   192                      LLBASE04 := -1;
  9266  18    1:6   196                      EXIT( CAMP)
  9267  18    1:5   200                    END;
  9268  18    1:4   202              'D':  DISBAND;
  9269  18    1:4   206             END;
  9270  18    1:3   244           END;
  9271  18    1:3   244           
  9272  18    1:1   244       UNTIL FALSE
  9273  18    1:0   244     END;  (* CAMP *)
  9274  18    1:0   266   
  9275  18    1:0   266 (*$I WIZ1C:CAMP2     *)
  9276  18    1:0   266                         
  9276  18    1:0   266 (*$I WIZ1C:REWARDS   *)
  9277  18    1:0   266     
  9278  19    1:D     1 SEGMENT PROCEDURE REWARDS;    (* P010D01 *)
  9279  19    1:D     1     
  9280  19    1:D     1     VAR
  9281  19    1:D     1          EXPPERCH : TWIZLONG;
  9282  19    1:D     4          ALIVECNT : INTEGER;
  9283  19    1:D     5          ONEORTWO : INTEGER;
  9284  19    1:D     6          REWARDI  : INTEGER;
  9285  19    1:D     7          TRAP3TYP : INTEGER;
  9286  19    1:D     8   
  9287  19    1:D     8       
  9288  19    2:D     1     PROCEDURE PIC2SCRN( BUFFERI: INTEGER);  (* P010D02 *)
  9289  19    2:D     2     
  9290  19    2:D     2       TYPE
  9291  19    2:D     2            BYTE = PACKED ARRAY[ 0..1] OF CHAR;
  9292  19    2:D     2     
  9293  19    2:D     2       VAR
  9294  19    2:D     2            PIXLIN : INTEGER;
  9295  19    2:D     3            UNUSED : INTEGER;
  9296  19    2:D     4            MEMLOC : RECORD CASE INTEGER OF
  9297  19    2:D     4                1 : (I : INTEGER);
  9298  19    2:D     4                2 : (P : ^BYTE);
  9299  19    2:D     4              END;
  9300  19    2:D     5            
  9301  19    2:0     0       BEGIN
  9302  19    2:1     0         CLRPICT( 0, 0, 0, 100);  (* CLEAR PICTURE *)
  9303  19    2:1     7         FOR PIXLIN := 23 TO 72 DO
  9304  19    2:2    18           BEGIN
  9305  19    2:3    18             MEMLOC.I := 8193 + 1024 * (PIXLIN MOD 8) +
  9306  19    2:3    29                         128 * ((PIXLIN MOD 64) DIV 8) +
  9307  19    2:3    39                         40 * (PIXLIN DIV 64);
  9308  19    2:3    47             MOVELEFT( IOCACHE[ BUFFERI], MEMLOC.P^, 10);
  9309  19    2:3    56             BUFFERI := BUFFERI + 10
  9310  19    2:2    57           END;
  9311  19    2:0    68       END;  (* PIC2SCRN *)
  9312  19    2:0    82       
  9313  19    2:0    82       
  9314  19    3:D     1     PROCEDURE PRLONG2( VAR MP01 : TWIZLONG);  (* P010D03 *)
  9315  19    3:D     2     
  9316  19    3:D     2       VAR
  9317  19    3:D     2            BCDNUM   : TBCD;
  9318  19    3:D    16            NONZEROI : INTEGER;
  9319  19    3:D    17            SUPPRESI : INTEGER;
  9320  19    3:D    18            
  9321  19    3:0     0       BEGIN
  9322  19    3:1     0         LONG2BCD( MP01, BCDNUM);
  9323  19    3:1     6         SUPPRESI := 1;
  9324  19    3:1     9         WHILE (SUPPRESI < 12) AND (BCDNUM[ SUPPRESI] = 0) DO
  9325  19    3:2    25           SUPPRESI := SUPPRESI + 1;
  9326  19    3:1    33         FOR NONZEROI := SUPPRESI TO 12 DO
  9327  19    3:2    46           PRINTCHR( CHR( BCDNUM[ NONZEROI] + ORD( '0')))
  9328  19    3:0    54       END;
  9329  19    3:0    80       
  9330  19    3:0    80       
  9331  19    4:D     1     PROCEDURE ENMYREWD;  (* P010D04 *)
  9332  19    4:D     1     
  9333  19    4:D     1       VAR
  9334  19    4:D     1            ENEMY : TENEMY;
  9335  19    4:D    80     
  9336  19    4:0     0       BEGIN
  9337  19    4:1     0         MOVELEFT( IOCACHE[ GETREC( ZENEMY, ENEMYINX, SIZEOF( TENEMY))],
  9338  19    4:1    14                   ENEMY,
  9339  19    4:1    17                   SIZEOF( TENEMY));
  9340  19    4:1    22         IF ENEMY.UNIQUE > 0 THEN
  9341  19    4:2    28           BEGIN
  9342  19    4:3    28             ENEMY.UNIQUE := ENEMY.UNIQUE - 1;
  9343  19    4:3    34             MOVELEFT( ENEMY,
  9344  19    4:3    37                       IOCACHE[ GETRECW( ZENEMY, ENEMYINX, SIZEOF( TENEMY))],
  9345  19    4:3    51                       SIZEOF( TENEMY))
  9346  19    4:2    56           END;
  9347  19    4:1    56         ONEORTWO := 1;
  9348  19    4:1    60         IF ATTK012 = 0 THEN
  9349  19    4:2    65           REWARDI := ENEMY.REWARD1
  9350  19    4:1    65         ELSE IF ATTK012 = 1 THEN
  9351  19    4:3    77           BEGIN
  9352  19    4:4    77             REWARDI := ENEMY.REWARD1;
  9353  19    4:4    82             ONEORTWO := 2
  9354  19    4:3    82           END
  9355  19    4:2    86         ELSE
  9356  19    4:3    88           REWARDI := ENEMY.REWARD2
  9357  19    4:0    88       END;  (* ENMYREWD *)
  9358  19    4:0   106       
  9359  19    4:0   106       
  9360  19    5:D     1     PROCEDURE FOUNDITM( FNDCHARX: INTEGER;  (* P010D05 *)
  9361  19    5:D     2                         POSSX   : INTEGER;
  9362  19    5:D     3                         ITEMINDX: INTEGER);
  9363  19    5:D     4     
  9364  19    5:D     4       VAR
  9365  19    5:D     4            OBJECTRC : TOBJREC;
  9366  19    5:D    43     
  9367  19    5:D    43         
  9368  19    5:0     0       BEGIN  (* FOUNDITM *)
  9369  19    5:1     0         MOVELEFT( IOCACHE[ GETREC( ZOBJECT,
  9370  19    5:1     4                                    ITEMINDX,
  9371  19    5:1     5                                    SIZEOF( TOBJREC))],
  9372  19    5:1    11                   OBJECTRC,
  9373  19    5:1    14                   SIZEOF( TOBJREC));
  9374  19    5:1    17         CLRRECT( 1, 11, 38, 4);
  9375  19    5:1    24         MVCURSOR( 1, 12);
  9376  19    5:1    29         PRINTSTR( CHARACTR[ FNDCHARX].NAME);
  9377  19    5:1    37         PRINTSTR( ' FOUND - ');
  9378  19    5:1    52         PRINTSTR( OBJECTRC.NAMEUNK);
  9379  19    5:1    57         WITH CHARACTR[ FNDCHARX].POSS DO
  9380  19    5:2    66           BEGIN
  9381  19    5:3    66             POSSX := POSSCNT + 1;
  9382  19    5:3    73             POSSESS[ POSSX].EQUIPED := FALSE;
  9383  19    5:3    84             POSSESS[ POSSX].IDENTIF := FALSE;
  9384  19    5:3    97             POSSESS[ POSSX].CURSED  := FALSE;
  9385  19    5:3   110             POSSESS[ POSSX].EQINDEX := ITEMINDX;
  9386  19    5:3   123             POSSCNT := POSSX
  9387  19    5:2   125           END
  9388  19    5:0   127       END;   (* FOUNDITM *)
  9389  19    5:0   140       
  9390  19    5:0   140       
  9391  19    6:D     1     PROCEDURE CHSTGOLD;  (* P010D06 *)
  9392  19    6:D     1 
  9393  19    6:D     1       TYPE
  9394  19    6:D     1       
  9395  19    6:D     1         TREWARDX = RECORD
  9396  19    6:D     1             REWDPERC : INTEGER;
  9397  19    6:D     1             BITEM    : INTEGER;
  9398  19    6:D     1             REWDCALC : RECORD CASE INTEGER OF
  9399  19    6:D     1                 1: (GOLD:  RECORD
  9400  19    6:D     1                       TRIES   : INTEGER;
  9401  19    6:D     1                       AVEAMT  : INTEGER;
  9402  19    6:D     1                       MINADD  : INTEGER;
  9403  19    6:D     1                       MULTX   : INTEGER;
  9404  19    6:D     1                       TRIES2  : INTEGER;
  9405  19    6:D     1                       AVEAMT2 : INTEGER;
  9406  19    6:D     1                       MINADD2 : INTEGER;
  9407  19    6:D     1                     END);
  9408  19    6:D     1                 2: (ITEM:  RECORD
  9409  19    6:D     1                       MININDX  : INTEGER;
  9410  19    6:D     1                       MFACTOR  : INTEGER;
  9411  19    6:D     1                       MAXTIMES : INTEGER;
  9412  19    6:D     1                       RANGE    : INTEGER;
  9413  19    6:D     1                       PERCBIGR : INTEGER;
  9414  19    6:D     1                       UNUSEDXX : INTEGER;
  9415  19    6:D     1                       UNUSEDYY : INTEGER;
  9416  19    6:D     1                     END);
  9417  19    6:D     1               END;
  9418  19    6:D     1           END;
  9419  19    6:D     1           
  9420  19    6:D     1         TREWARD = RECORD
  9421  19    6:D     1             BCHEST   : BOOLEAN;
  9422  19    6:D     1             BTRAPTYP : PACKED ARRAY[ 0..7] OF BOOLEAN;
  9423  19    6:D     1             REWRDCNT : INTEGER;
  9424  19    6:D     1             REWARDXX : ARRAY[ 1..9] OF TREWARDX;
  9425  19    6:D     1           END;
  9426  19    6:D     1       
  9427  19    6:D     1       VAR
  9428  19    6:D     1            CHRXCHST : INTEGER;
  9429  19    6:D     2            INDX     : INTEGER;
  9430  19    6:D     3            GOLD2ONE : TWIZLONG;
  9431  19    6:D     6            REWARDZ  : TREWARD;
  9432  19    6:D    90     
  9433  19    6:D    90     
  9434  19    7:D     1       PROCEDURE RDREWARD;  (* P010D07 *)
  9435  19    7:D     1       
  9436  19    7:0     0         BEGIN
  9437  19    7:1     0           MOVELEFT( IOCACHE[ GETREC( ZREWARD, REWARDI, SIZEOF( TREWARD))],
  9438  19    7:1    15                     REWARDZ,
  9439  19    7:1    19                     SIZEOF( TREWARD))
  9440  19    7:0    24         END;
  9441  19    7:0    36         
  9442  19    7:0    36         
  9443  19    8:D     1       PROCEDURE ACHEST;  (* P010D08 *)
  9444  19    8:D     1       
  9445  19    8:D     1         VAR
  9446  19    8:D     1              WHOTRIED : ARRAY[ 0..5] OF BOOLEAN;
  9447  19    8:D     7              TRAPTYPE : INTEGER;
  9448  19    8:D     8              
  9449  19    8:D     8              
  9450  19    9:D     1         PROCEDURE GTTRAPTY;  (* P010D09 *)
  9451  19    9:D     1         
  9452  19    9:D     1         VAR
  9453  19    9:D     1              BTRAPPED : BOOLEAN;
  9454  19    9:D     2              UNUSEDXX : INTEGER;
  9455  19    9:D     3              UNUSEDYY : INTEGER;
  9456  19    9:D     4              ZERO99   : INTEGER;
  9457  19    9:D     5         
  9458  19    9:0     0           BEGIN
  9459  19    9:1     0             BTRAPPED := FALSE;
  9460  19    9:1     3             FOR TRAPTYPE := 0 TO 7 DO
  9461  19    9:2    17               IF REWARDZ.BTRAPTYP[ TRAPTYPE] THEN
  9462  19    9:3    29                 BTRAPPED := TRUE;
  9463  19    9:1    42             TRAP3TYP := (RANDOM MOD 5);
  9464  19    9:1    52             IF NOT BTRAPPED THEN
  9465  19    9:2    56               TRAPTYPE := 0
  9466  19    9:1    56             ELSE
  9467  19    9:2    62               IF (RANDOM MOD 15) > (4 + MAZELEV) THEN
  9468  19    9:3    76                 TRAPTYPE := 0
  9469  19    9:2    76               ELSE
  9470  19    9:3    82                 BEGIN
  9471  19    9:4    82                   ZERO99 := RANDOM MOD 100;
  9472  19    9:4    91                   TRAPTYPE := 0;
  9473  19    9:4    95                   WHILE ZERO99 > 0 DO
  9474  19    9:4   100                     
  9475  19    9:5   100                     REPEAT
  9476  19    9:6   100                       IF TRAPTYPE < 7 THEN
  9477  19    9:7   107                         BEGIN
  9478  19    9:8   107                           IF TRAPTYPE = 3 THEN
  9479  19    9:9   114                             ZERO99 := ZERO99 - 5
  9480  19    9:8   115                           ELSE
  9481  19    9:9   121                             ZERO99 := ZERO99 - 1;
  9482  19    9:8   126                           TRAPTYPE := TRAPTYPE + 1
  9483  19    9:7   129                         END
  9484  19    9:6   134                       ELSE
  9485  19    9:7   136                         TRAPTYPE := 0 + 1
  9486  19    9:5   137                     UNTIL REWARDZ.BTRAPTYP[ TRAPTYPE]
  9487  19    9:5   151                     
  9488  19    9:3   151                 END
  9489  19    9:0   156           END;  (* GTTRAPTY *)
  9490  19    9:0   174           
  9491  19    9:0   174           
  9492  19   10:D     1         PROCEDURE EXITRWDS;  (* P010D0A *)
  9493  19   10:D     1         
  9494  19   10:0     0           BEGIN
  9495  19   10:1     0             EXIT( REWARDS)
  9496  19   10:0     4           END;
  9497  19   10:0    16           
  9498  19   10:0    16           
  9499  19   11:D     1         PROCEDURE PRTRAPTY( TRAPTYPE: INTEGER;  (* P010D0B *)
  9500  19   11:D     2                             TRAP3TY:  INTEGER);
  9501  19   11:D     3           
  9502  19   11:D     3           VAR
  9503  19   11:D     3                UNUSEDXX : INTEGER;
  9504  19   11:D     4         
  9505  19   11:0     0           BEGIN
  9506  19   11:1     0             CASE TRAPTYPE OF
  9507  19   11:1     3               0:  PRINTSTR( 'TRAPLESS CHEST');
  9508  19   11:1    25               1:  PRINTSTR( 'POISON NEEDLE');
  9509  19   11:1    46               2:  PRINTSTR( 'GAS BOMB');
  9510  19   11:1    62               3:  CASE TRAP3TY OF
  9511  19   11:2    65                     0:  PRINTSTR( 'CROSSBOW BOLT');
  9512  19   11:2    86                     1:  PRINTSTR( 'EXPLODING BOX');
  9513  19   11:2   107                     2:  PRINTSTR( 'SPLINTERS');
  9514  19   11:2   124                     3:  PRINTSTR( 'BLADES');
  9515  19   11:2   138                     4:  PRINTSTR( 'STUNNER');
  9516  19   11:2   153                   END;
  9517  19   11:1   172               4:  PRINTSTR( 'TELEPORTER');
  9518  19   11:1   190               5:  PRINTSTR( 'ANTI-MAGE');
  9519  19   11:1   207               6:  PRINTSTR( 'ANTI-PRIEST');
  9520  19   11:1   226               7:  PRINTSTR( 'ALARM');
  9521  19   11:1   239             END;
  9522  19   11:1   262             PAUSE2
  9523  19   11:0   262           END;  (* PRTRAPTY *)
  9524  19   11:0   282           
  9525  19   11:0   282           
  9526  19   12:D     1         PROCEDURE DOTRAPDM;  (* P010D0C *)
  9527  19   12:D     1         
  9528  19   12:D     1           VAR
  9529  19   12:D     1                UNUSEDXX : INTEGER;
  9530  19   12:D     2                UNUSEDYY : INTEGER;
  9531  19   12:D     3                CHARX    : INTEGER;
  9532  19   12:D     4         
  9533  19   12:D     4         
  9534  19   13:D     1           PROCEDURE HPDAMAGE( CHARXHIT: INTEGER;  (* P010D0D *)
  9535  19   13:D     2                               HITCNT:   INTEGER;
  9536  19   13:D     3                               HITDAM:   INTEGER);
  9537  19   13:D     4           
  9538  19   13:D     4             VAR
  9539  19   13:D     4                  TOTDAM : INTEGER;
  9540  19   13:D     5           
  9541  19   13:0     0             BEGIN
  9542  19   13:1     0               TOTDAM := 0;
  9543  19   13:1     3               WHILE HITCNT > 0 DO
  9544  19   13:2     8                 BEGIN
  9545  19   13:3     8                   TOTDAM := TOTDAM + (RANDOM MOD HITDAM) + 1;
  9546  19   13:3    21                   HITCNT := HITCNT - 1
  9547  19   13:2    22                 END;
  9548  19   13:1    28               CHARACTR[ CHARXHIT].HPLEFT := CHARACTR[ CHARXHIT].HPLEFT - TOTDAM;
  9549  19   13:1    45               IF CHARACTR[ CHARXHIT].HPLEFT < 1 THEN
  9550  19   13:2    56                 BEGIN
  9551  19   13:3    56                   CHARACTR[ CHARXHIT].HPLEFT := 0;
  9552  19   13:3    65                   CHARACTR[ CHARXHIT].STATUS := DEAD;
  9553  19   13:3    74                   CLRRECT( 1, 11, 38, 4);
  9554  19   13:3    81                   MVCURSOR( 1, 12);
  9555  19   13:3    86                   PRINTSTR( CHARACTR[ CHARXHIT].NAME);
  9556  19   13:3    94                   PRINTSTR( ' DIES!');
  9557  19   13:3   106                   ALIVECNT := ALIVECNT - 1;
  9558  19   13:3   114                   IF ALIVECNT = 0 THEN
  9559  19   13:4   121                     BEGIN
  9560  19   13:5   121                       XGOTO := XCEMETRY;
  9561  19   13:5   124                       EXIT( REWARDS)
  9562  19   13:4   128                     END
  9563  19   13:2   128                 END
  9564  19   13:0   128             END;  (* HPDAMAGE *)
  9565  19   13:0   142             
  9566  19   13:0   142             
  9567  19   14:D     1           PROCEDURE ANTIPM( BMAGEDAM: BOOLEAN);  (* P010D0E *)
  9568  19   14:D     2           
  9569  19   14:D     2            VAR
  9570  19   14:D     2                 PLYZSTON : BOOLEAN;
  9571  19   14:D     3                 CHARPM   : INTEGER;
  9572  19   14:D     4           
  9573  19   14:D     4           
  9574  19   15:D     1             PROCEDURE ISSTONED;  (* P010D0F *)
  9575  19   15:D     1             
  9576  19   15:0     0               BEGIN
  9577  19   15:1     0                 IF CHARACTR[ CHARPM].STATUS < STONED THEN
  9578  19   15:2    13                   CHARACTR[ CHARPM].STATUS := STONED
  9579  19   15:0    22               END;
  9580  19   15:0    36               
  9581  19   15:0    36               
  9582  19   16:D     1             PROCEDURE ISPLYZE;  (* P010D10 *)
  9583  19   16:D     1             
  9584  19   16:0     0               BEGIN
  9585  19   16:1     0                 IF CHARACTR[ CHARPM].STATUS < PLYZE THEN
  9586  19   16:2    13                   CHARACTR[ CHARPM].STATUS := PLYZE
  9587  19   16:0    22               END;
  9588  19   16:0    36               
  9589  19   16:0    36               
  9590  19   14:0     0             BEGIN  (* ANTIPM *)
  9591  19   14:1     0               FOR CHARPM := 0 TO PARTYCNT - 1 DO
  9592  19   14:2    13                 BEGIN
  9593  19   14:3    13                   PLYZSTON := (RANDOM MOD 20) < CHARACTR[ CHARPM].LUCKSKIL[ 4];
  9594  19   14:3    35                   
  9595  19   14:3    35                   CASE CHARACTR[ CHARPM].CLASS OF
  9596  19   14:3    44                   
  9597  19   14:3    44                        MAGE:  IF BMAGEDAM THEN
  9598  19   14:5    47                                 IF PLYZSTON THEN
  9599  19   14:6    50                                   ISPLYZE
  9600  19   14:5    50                                 ELSE
  9601  19   14:6    54                                   ISSTONED;
  9602  19   14:6    58                                   
  9603  19   14:3    58                     SAMURAI:  IF BMAGEDAM THEN
  9604  19   14:5    61                                 IF NOT PLYZSTON THEN
  9605  19   14:6    65                                   ISPLYZE;
  9606  19   14:6    69                                  
  9607  19   14:3    69                      PRIEST:  IF NOT BMAGEDAM THEN
  9608  19   14:5    73                                 IF PLYZSTON THEN
  9609  19   14:6    76                                   ISPLYZE
  9610  19   14:5    76                                 ELSE
  9611  19   14:6    80                                   ISSTONED;
  9612  19   14:6    84                                   
  9613  19   14:3    84                      BISHOP:  IF NOT BMAGEDAM THEN
  9614  19   14:5    88                                 IF NOT PLYZSTON THEN  (* IF NOT SET... *)
  9615  19   14:6    92                                   ISPLYZE;
  9616  19   14:3    96                   END
  9617  19   14:2   114                 END
  9618  19   14:0   114             END;   (* ANTIPM *)
  9619  19   14:0   136           
  9620  19   14:0   136           
  9621  19   17:D     1           PROCEDURE TYPE3DAM;  (* P010D11 *)
  9622  19   17:D     1           
  9623  19   17:D     1           
  9624  19   18:D     1             PROCEDURE HPDAMALL( CHANCHIT: INTEGER;  (* P010D12 *)
  9625  19   18:D     2                                 HITCNT:   INTEGER;
  9626  19   18:D     3                                 HITDAM:   INTEGER);
  9627  19   18:D     4                                
  9628  19   18:D     4               VAR
  9629  19   18:D     4                    CHARXHIT : INTEGER;
  9630  19   18:D     5             
  9631  19   18:0     0               BEGIN
  9632  19   18:1     0                 FOR CHARXHIT := 0 TO PARTYCNT - 1 DO
  9633  19   18:2    13                   IF (RANDOM MOD 100) < CHANCHIT THEN
  9634  19   18:3    24                     HPDAMAGE( CHARXHIT, HITCNT, HITDAM)
  9635  19   18:2    27                   ELSE
  9636  19   18:3    31                     IF (RANDOM MOD 100) < CHANCHIT THEN
  9637  19   18:4    42                       HPDAMAGE( CHARXHIT, HITCNT, (HITDAM DIV 2) + 1)
  9638  19   18:0    49               END;  (* HPDAMALL *)
  9639  19   18:0    72               
  9640  19   18:0    72               
  9641  19   17:0     0             BEGIN (* TYPE3DAM *)
  9642  19   17:1     0               CASE TRAP3TYP OF
  9643  19   17:1     5                 0:  HPDAMAGE( CHRXCHST, MAZELEV, 8);  (* CROSSBOW BOLT *)
  9644  19   17:1    15                 1:  HPDAMALL(       50, MAZELEV, 8);  (* EXPLODING BOX *)
  9645  19   17:1    23                 2:  HPDAMALL(       70, MAZELEV, 6);  (* SPLINTERS     *)
  9646  19   17:1    31                 3:  HPDAMALL(       30, MAZELEV, 12); (* BLADES        *)
  9647  19   17:1    39                 4:  CHARACTR[ CHRXCHST].STATUS := PLYZE;  (* STUNNER       *)
  9648  19   17:1    52               END
  9649  19   17:0    70             END;  (* TYPE3DAM *)
  9650  19   17:0    82         
  9651  19   17:0    82         
  9652  19   12:0     0           BEGIN (* DOTRAPDM *)
  9653  19   12:1     0             CLRRECT( 13, 8, 26, 2);
  9654  19   12:1     7             MVCURSOR( 13, 8);
  9655  19   12:1    12             IF TRAPTYPE <> 0 THEN
  9656  19   12:2    19               BEGIN
  9657  19   12:3    19                 PRINTSTR( 'OOPPS! A ');
  9658  19   12:3    34                 PRTRAPTY( TRAPTYPE, TRAP3TYP)
  9659  19   12:2    40               END
  9660  19   12:1    42             ELSE
  9661  19   12:2    44               PRINTSTR( 'THE CHEST WAS NOT TRAPPED');
  9662  19   12:1    75             PAUSE2;
  9663  19   12:1    78             
  9664  19   12:1    78             CASE TRAPTYPE OF
  9665  19   12:1    83             
  9666  19   12:1    83               1:  (* POISON *)
  9667  19   12:1    83               
  9668  19   12:2    83                     CHARACTR[ CHRXCHST].LOSTXYL.POISNAMT[ 1] :=
  9669  19   12:2    97                       CHARACTR[ CHRXCHST].LOSTXYL.POISNAMT[ 1] + 1;
  9670  19   12:2   117                    
  9671  19   12:1   117               2:  (* GAS *)
  9672  19   12:1   117               
  9673  19   12:2   117                     FOR CHARX := 0 TO PARTYCNT - 1 DO
  9674  19   12:3   130                       IF (RANDOM MOD 20) < CHARACTR[ CHARX].LUCKSKIL[ 3] THEN
  9675  19   12:4   152                         CHARACTR[ CHARX].LOSTXYL.POISNAMT[ 1] := 1;
  9676  19   12:4   175                         
  9677  19   12:1   175               3:  (* CROSSBOW BOLT *)
  9678  19   12:1   175                   (* EXPLODING     *)
  9679  19   12:1   175                   (* SPLINTERS     *)
  9680  19   12:1   175                   (* BLADES        *)
  9681  19   12:1   175                   (* STUNNER       *)
  9682  19   12:1   175                   
  9683  19   12:2   175                     TYPE3DAM;
  9684  19   12:2   179                 
  9685  19   12:1   179               4:  (* TELEPORTER    *)
  9686  19   12:1   179               
  9687  19   12:2   179                     BEGIN
  9688  19   12:3   179                       MAZEX := RANDOM MOD (19 + 1);
  9689  19   12:3   190                       MAZEY := RANDOM MOD (19 + 1);
  9690  19   12:3   201                       DIRECTIO := RANDOM MOD 4
  9691  19   12:2   206                     END;
  9692  19   12:2   212                     
  9693  19   12:1   212               5:  (* ANTI-MAGE *)
  9694  19   12:1   212                   
  9695  19   12:2   212                     ANTIPM( TRUE);
  9696  19   12:2   217                 
  9697  19   12:1   217               6:  (* ANTI-PRIEST *)
  9698  19   12:1   217               
  9699  19   12:2   217                     ANTIPM( FALSE);
  9700  19   12:2   222                 
  9701  19   12:1   222               7:  (* ALARM *)
  9702  19   12:1   222               
  9703  19   12:2   222                     BEGIN
  9704  19   12:3   222                       CHSTALRM := 1;
  9705  19   12:3   225                       EXIT( REWARDS)
  9706  19   12:2   229                     END;
  9707  19   12:1   231             END;
  9708  19   12:1   252             
  9709  19   12:1   252             EXIT( ACHEST)
  9710  19   12:0   256           END;  (* DOTRAPDAM *)
  9711  19   12:0   274           
  9712  19   12:0   274           
  9713  19   19:D     1         PROCEDURE PRTRAP;  (* P010D13 *)
  9714  19   19:D     1         
  9715  19   19:0     0           BEGIN
  9716  19   19:1     0             CLRRECT( 13, 8, 26, 2);
  9717  19   19:1     7             MVCURSOR( 13, 8);
  9718  19   19:1    12             PRTRAPTY( TRAPTYPE, TRAP3TYP);
  9719  19   19:1    20             PAUSE2
  9720  19   19:0    20           END;
  9721  19   19:0    36           
  9722  19   19:0    36           
  9723  19   20:D     1         PROCEDURE PRRNDTRP;  (* P010D14 *)
  9724  19   20:D     1         
  9725  19   20:D     1           VAR
  9726  19   20:D     1                RNDX   : INTEGER;
  9727  19   20:D     2                LOOPER : INTEGER;
  9728  19   20:D     3                TRAP   : INTEGER;
  9729  19   20:D     4         
  9730  19   20:0     0           BEGIN
  9731  19   20:1     0             TRAP := 0;
  9732  19   20:1     3             RNDX := RANDOM MOD 50;
  9733  19   20:1    12             FOR LOOPER := 1 TO RNDX DO
  9734  19   20:2    23               IF TRAP = 7 THEN
  9735  19   20:3    28                 TRAP := 0
  9736  19   20:2    28               ELSE
  9737  19   20:3    33                 TRAP := TRAP + 1;
  9738  19   20:1    45             CLRRECT( 13, 8, 26, 2);
  9739  19   20:1    52             MVCURSOR( 13, 8);
  9740  19   20:1    57             PRTRAPTY( TRAP, RANDOM MOD 5);
  9741  19   20:1    67             PAUSE2
  9742  19   20:0    67           END;  (* PRRNDTRP *)
  9743  19   20:0    84           
  9744  19   20:0    84           
  9745  19   21:D     1         PROCEDURE INSPCHST;  (* P010D15 *)
  9746  19   21:D     1         
  9747  19   21:D     1           VAR
  9748  19   21:D     1                UNUSEDXX : INTEGER;
  9749  19   21:D     2                CHNCGOOD : INTEGER;
  9750  19   21:D     3                CHARINSP : INTEGER;
  9751  19   21:D     4                
  9752  19   21:0     0           BEGIN
  9753  19   21:1     0             CLRRECT( 13, 8, 26, 2);
  9754  19   21:1     7             MVCURSOR( 15, 8);
  9755  19   21:1    12             PRINTSTR( 'WHO (#) WILL INSPECT?');
  9756  19   21:1    39             GETKEY;
  9757  19   21:1    42             CHARINSP := ORD( INCHAR) - ORD( '0') - 1;
  9758  19   21:1    49             
  9759  19   21:1    49             IF (CHARINSP < 0) OR (CHARINSP >= PARTYCNT) THEN
  9760  19   21:2    58               EXIT( INSPCHST);
  9761  19   21:1    62             IF CHARACTR[ CHARINSP].STATUS <> OK THEN
  9762  19   21:2    73               EXIT( INSPCHST);
  9763  19   21:1    77             IF WHOTRIED[ CHARINSP] THEN
  9764  19   21:2    86               BEGIN
  9765  19   21:3    86                 CLRRECT( 13, 8, 26, 1);
  9766  19   21:3    93                 MVCURSOR( 16, 8);
  9767  19   21:3    98                 PRINTSTR( 'YOU ALREADY LOOKED!');
  9768  19   21:3   123                 PAUSE2;
  9769  19   21:3   126                 EXIT( INSPCHST)
  9770  19   21:2   130               END;
  9771  19   21:1   130             WHOTRIED[ CHARINSP] := TRUE;
  9772  19   21:1   138             CHNCGOOD := CHARACTR[ CHARINSP].ATTRIB[ AGILITY];
  9773  19   21:1   152             IF CHARACTR[ CHARINSP].CLASS = THIEF THEN
  9774  19   21:2   163               CHNCGOOD := CHNCGOOD * 6
  9775  19   21:1   164             ELSE
  9776  19   21:2   170               IF CHARACTR[ CHARINSP].CLASS = NINJA THEN
  9777  19   21:3   181                 CHNCGOOD := CHNCGOOD * 4;
  9778  19   21:1   186             IF CHNCGOOD > 95 THEN
  9779  19   21:2   191               CHNCGOOD := 95;
  9780  19   21:1   194             CHRXCHST := CHARINSP;
  9781  19   21:1   198             IF (RANDOM MOD 100) < CHNCGOOD THEN
  9782  19   21:2   209               PRTRAP
  9783  19   21:1   209             ELSE
  9784  19   21:2   213               IF (RANDOM MOD 20) > CHARACTR[ CHARINSP].ATTRIB[ AGILITY] THEN
  9785  19   21:3   235                 DOTRAPDM
  9786  19   21:2   235               ELSE
  9787  19   21:3   239                 PRRNDTRP;
  9788  19   21:0   241           END;  (* INSPCHST *)
  9789  19   21:0   254           
  9790  19   21:0   254           
  9791  19   22:D     1         PROCEDURE CALFOCH;  (* P010D16 *)
  9792  19   22:D     1         
  9793  19   22:0     0           BEGIN
  9794  19   22:1     0             CLRRECT( 13, 8, 26, 2);
  9795  19   22:1     7             MVCURSOR( 14, 8);
  9796  19   22:1    12             PRINTSTR( 'WHO (#) WILL CAST CALFO?');
  9797  19   22:1    42             GETKEY;
  9798  19   22:1    45             CHRXCHST := ORD( INCHAR) - ORD( '0') - 1;
  9799  19   22:1    53             
  9800  19   22:1    53             IF (CHRXCHST < 0) OR (CHRXCHST >= PARTYCNT) THEN
  9801  19   22:2    66               EXIT( CALFOCH);
  9802  19   22:1    70             IF NOT (CHARACTR[ CHRXCHST].SPELLSKN[ 28]) THEN
  9803  19   22:2    87               EXIT( CALFOCH);
  9804  19   22:1    91             IF CHARACTR[ CHRXCHST].PRIESTSP[ 2] = 0 THEN
  9805  19   22:2   110               EXIT( CALFOCH);
  9806  19   22:1   114             IF CHARACTR[ CHRXCHST].STATUS <> OK THEN
  9807  19   22:2   127               EXIT( CALFOCH);
  9808  19   22:1   131             WITH CHARACTR[ CHRXCHST] DO
  9809  19   22:2   140               BEGIN
  9810  19   22:3   140                 PRIESTSP[ 2] := PRIESTSP[ 2] - 1;
  9811  19   22:3   160                 IF (RANDOM MOD 100) < 95 THEN
  9812  19   22:4   171                   PRTRAP
  9813  19   22:3   171                 ELSE
  9814  19   22:4   175                   PRRNDTRP
  9815  19   22:2   175               END
  9816  19   22:0   177           END;  (* CALFOCH *)
  9817  19   22:0   190           
  9818  19   22:0   190           
  9819  19   23:D     1         PROCEDURE DISARMTR;  (* P010D17 *)
  9820  19   23:D     1         
  9821  19   23:D     1           VAR
  9822  19   23:D     1                UNUSEDXX : INTEGER;
  9823  19   23:D     2                UNUSEDYY : INTEGER;
  9824  19   23:D     3                UNUSEDZZ : INTEGER;
  9825  19   23:D     4                TRAPSTR  : STRING;
  9826  19   23:D    45         
  9827  19   23:D    45         
  9828  19   24:D     1           PROCEDURE DISARM;  (* P010D18 *)
  9829  19   24:D     1           
  9830  19   24:0     0             BEGIN
  9831  19   24:1     0               CLRRECT( 13, 8, 26, 2);
  9832  19   24:1     7               MVCURSOR( 18, 8);
  9833  19   24:1    12               IF (RANDOM MOD 70) < 
  9834  19   24:1    19                  (  CHARACTR[ CHRXCHST].CHARLEV
  9835  19   24:1    26                   - MAZELEV
  9836  19   24:1    28                   + (50 * ORD( ((CHARACTR[ CHRXCHST].CLASS = THIEF) OR
  9837  19   24:1    43                                 (CHARACTR[ CHRXCHST].CLASS = NINJA)))
  9838  19   24:1    55                     )
  9839  19   24:1    56                  ) THEN
  9840  19   24:2    60                 BEGIN
  9841  19   24:3    60                   PRINTSTR( 'YOU DISARMED IT!');
  9842  19   24:3    82                   PAUSE2;
  9843  19   24:3    85                   EXIT( ACHEST)
  9844  19   24:2    89                 END
  9845  19   24:1    89               ELSE
  9846  19   24:2    91                 IF (RANDOM MOD 20) < CHARACTR[ CHRXCHST].ATTRIB[ AGILITY] THEN
  9847  19   24:3   115                   BEGIN
  9848  19   24:4   115                     PRINTSTR( 'DISARM FAILED!!');
  9849  19   24:4   136                     PAUSE2;
  9850  19   24:4   139                     EXIT( DISARMTR)
  9851  19   24:3   143                   END
  9852  19   24:2   143                 ELSE
  9853  19   24:3   145                   BEGIN
  9854  19   24:4   145                     PRINTSTR( 'YOU SET IT OFF!');
  9855  19   24:4   166                     PAUSE2;
  9856  19   24:4   169                     DOTRAPDM
  9857  19   24:3   169                   END
  9858  19   24:0   171             END;  (* DISARM *)
  9859  19   24:0   184           
  9860  19   24:0   184           
  9861  19   23:0     0           BEGIN  (* DISARMTR *)
  9862  19   23:1     0             CLRRECT( 13, 8, 26, 2);
  9863  19   23:1     7             MVCURSOR( 16, 8);
  9864  19   23:1    12             PRINTSTR( 'WHO (#) WILL DISARM?');
  9865  19   23:1    38             GETKEY;
  9866  19   23:1    41             CHRXCHST := ORD( INCHAR) - ORD( '0') - 1;
  9867  19   23:1    49             
  9868  19   23:1    49             IF (CHRXCHST < 0) OR (CHRXCHST >= PARTYCNT) THEN
  9869  19   23:2    62               EXIT( DISARMTR);
  9870  19   23:1    66             IF CHARACTR[ CHRXCHST].STATUS <> OK THEN
  9871  19   23:2    79               EXIT( DISARMTR);
  9872  19   23:1    83             CLRRECT( 13, 8, 26, 2);
  9873  19   23:1    90             MVCURSOR( 13, 8);
  9874  19   23:1    95             PRINTSTR( 'WHAT TRAP >');
  9875  19   23:1   112             GETSTR( TRAPSTR, 24, 8);
  9876  19   23:1   119             IF (TRAPSTR = 'POISON NEEDLE') AND (TRAPTYPE = 1) THEN
  9877  19   23:2   147               DISARM
  9878  19   23:1   147             ELSE IF (TRAPSTR = 'GAS BOMB') AND (TRAPTYPE = 2) THEN
  9879  19   23:3   174               DISARM
  9880  19   23:2   174             ELSE IF TRAPTYPE = 3 THEN
  9881  19   23:4   185               BEGIN
  9882  19   23:5   185                 CASE TRAP3TYP OF
  9883  19   23:5   190                   0:  IF TRAPSTR = 'CROSSBOW BOLT' THEN
  9884  19   23:7   212                         DISARM;
  9885  19   23:7   216                        
  9886  19   23:5   216                   1:  IF TRAPSTR = 'EXPLODING BOX' THEN
  9887  19   23:7   238                         DISARM;
  9888  19   23:7   242                        
  9889  19   23:5   242                   2:  IF TRAPSTR = 'SPLINTERS' THEN
  9890  19   23:7   260                         DISARM;
  9891  19   23:7   264                        
  9892  19   23:5   264                   3:  IF TRAPSTR = 'BLADES' THEN
  9893  19   23:7   279                         DISARM;
  9894  19   23:7   283                        
  9895  19   23:5   283                   4:  IF TRAPSTR = 'STUNNER' THEN
  9896  19   23:7   299                         DISARM;
  9897  19   23:5   303                 END;
  9898  19   23:5   320                 
  9899  19   23:5   320                 (* DOTRAPDM *)
  9900  19   23:4   320               END
  9901  19   23:3   320             ELSE IF (TRAPSTR = 'TELEPORTER') AND (TRAPTYPE = 4) THEN
  9902  19   23:5   347               DISARM
  9903  19   23:4   347             ELSE IF (TRAPSTR = 'ANTI-MAGE') AND (TRAPTYPE = 5) THEN
  9904  19   23:6   375               DISARM
  9905  19   23:5   375             ELSE IF (TRAPSTR = 'ANTI-PRIEST') AND (TRAPTYPE = 6) THEN
  9906  19   23:7   405               DISARM
  9907  19   23:6   405             ELSE IF (TRAPSTR = 'ALARM') AND (TRAPTYPE = 7) THEN
  9908  19   23:8   429               DISARM
  9909  19   23:7   429             ELSE
  9910  19   23:8   433               DOTRAPDM
  9911  19   23:0   433           END;   (* DISARMTR *)
  9912  19   23:0   454           
  9913  19   23:0   454           
  9914  19   25:D     1         PROCEDURE OPENCHST;  (* P010D19 *)
  9915  19   25:D     1         
  9916  19   25:0     0           BEGIN
  9917  19   25:1     0             CLRRECT( 13, 8, 26, 2);
  9918  19   25:1     7             MVCURSOR( 17, 8);
  9919  19   25:1    12             PRINTSTR( 'WHO (#) WILL OPEN?');
  9920  19   25:1    36             GETKEY;
  9921  19   25:1    39             CHRXCHST := ORD( INCHAR) - ORD( '0') - 1;
  9922  19   25:1    47             
  9923  19   25:1    47             IF (CHRXCHST < 0) OR (CHRXCHST >= PARTYCNT) THEN
  9924  19   25:2    60               EXIT( OPENCHST);
  9925  19   25:1    64             IF CHARACTR[ CHRXCHST].STATUS <> OK THEN
  9926  19   25:2    77               EXIT( OPENCHST);
  9927  19   25:1    81             IF TRAPTYPE = 0 THEN
  9928  19   25:2    88               EXIT( ACHEST);
  9929  19   25:1    92             IF (RANDOM MOD 1000) < CHARACTR[ CHRXCHST].CHARLEV THEN
  9930  19   25:2   113               EXIT( ACHEST);
  9931  19   25:1   117             DOTRAPDM
  9932  19   25:0   117           END;  (* OPENCHST *)
  9933  19   25:0   132           
  9934  19   25:0   132           
  9935  19    8:0     0         BEGIN (* ACHEST *)
  9936  19    8:1     0           PIC2SCRN( GETREC( ZSPCCHRS, 18, 512));
  9937  19    8:1    12           FILLCHAR( WHOTRIED, 12, 0);
  9938  19    8:1    19           GTTRAPTY;
  9939  19    8:1    21           CLRRECT( 13, 6, 26, 4);
  9940  19    8:1    28           MVCURSOR( 13, 6);
  9941  19    8:1    33           PRINTSTR( 'A CHEST! YOU MAY:');
  9942  19    8:1    56           REPEAT
  9943  19    8:2    56             CLRRECT( 13, 8, 26, 2);
  9944  19    8:2    63             MVCURSOR( 13, 8);
  9945  19    8:2    68             PRINTSTR( 'O)PEN     C)ALFO   L)EAVE');
  9946  19    8:2    99             MVCURSOR( 13, 9);
  9947  19    8:2   104             PRINTSTR( 'I)NSPECT  D)ISARM');
  9948  19    8:2   127             GETKEY;
  9949  19    8:2   130             
  9950  19    8:2   130             IF      INCHAR = 'O' THEN
  9951  19    8:3   135               OPENCHST
  9952  19    8:2   135             ELSE IF INCHAR = 'L' THEN
  9953  19    8:4   144               EXITRWDS
  9954  19    8:3   144             ELSE IF INCHAR = 'I' THEN
  9955  19    8:5   153               INSPCHST
  9956  19    8:4   153             ELSE IF INCHAR = 'C' THEN
  9957  19    8:6   162               CALFOCH
  9958  19    8:5   162             ELSE IF INCHAR = 'D' THEN
  9959  19    8:7   171               DISARMTR
  9960  19    8:1   171           UNTIL FALSE
  9961  19    8:0   173         END;  (* ACHEST *)
  9962  19    8:0   190         
  9963  19    8:0   190         
  9964  19   26:D     1       PROCEDURE GETREWRD( REWARDM: TREWARDX);  (* P010D1A *)
  9965  19   26:D    11       
  9966  19   26:D    11         VAR
  9967  19   26:D    11              ITEMINDX : INTEGER;
  9968  19   26:D    12              CHARIIII : INTEGER;
  9969  19   26:D    13              CHARXXXX : INTEGER;  (* MULTIPLE USES *)
  9970  19   26:D    14       
  9971  19   26:D    14       
  9972  19   27:D     3         FUNCTION CALCULAT( TRIES:  INTEGER;  (* P010D1B *)
  9973  19   27:D     4                            AVEAMT: INTEGER;
  9974  19   27:D     5                            MINADD: INTEGER) : INTEGER;
  9975  19   27:D     6         
  9976  19   27:D     6           VAR
  9977  19   27:D     6                TOTAL : INTEGER;
  9978  19   27:D     7                
  9979  19   27:0     0           BEGIN
  9980  19   27:1     0             TOTAL := MINADD;
  9981  19   27:1     3             WHILE TRIES > 0 DO
  9982  19   27:2     8               BEGIN
  9983  19   27:3     8                 TOTAL := TOTAL + (RANDOM MOD AVEAMT) + 1;
  9984  19   27:3    21                 TRIES := TRIES - 1
  9985  19   27:2    22               END;
  9986  19   27:1    28             CALCULAT := TOTAL
  9987  19   27:0    28           END;  (* CALCULAT *)
  9988  19   27:0    46           
  9989  19   27:0    46           
  9990  19   28:D     1         PROCEDURE GOLDREWD;  (* P010D1C *)
  9991  19   28:D     1         
  9992  19   28:D     1         VAR
  9993  19   28:D     1              GOLDAMT : TWIZLONG;
  9994  19   28:D     4         
  9995  19   28:0     0           BEGIN
  9996  19   28:1     0             FILLCHAR( GOLDAMT, 6, 0);
  9997  19   28:1     7             GOLDAMT.LOW := CALCULAT( REWARDM.REWDCALC.GOLD.TRIES,
  9998  19   28:1    10                                      REWARDM.REWDCALC.GOLD.AVEAMT,
  9999  19   28:1    13                                      REWARDM.REWDCALC.GOLD.MINADD);
 10000  19   28:1    22             MULTLONG( GOLDAMT, REWARDM.REWDCALC.GOLD.MULTX);
 10001  19   28:1    30             CHARXXXX := CALCULAT( REWARDM.REWDCALC.GOLD.TRIES2,
 10002  19   28:1    33                                   REWARDM.REWDCALC.GOLD.AVEAMT2,
 10003  19   28:1    36                                   REWARDM.REWDCALC.GOLD.MINADD2);
 10004  19   28:1    46             MULTLONG( GOLDAMT, CHARXXXX);
 10005  19   28:1    54             MULTLONG( GOLDAMT, ONEORTWO);
 10006  19   28:1    62             ADDLONGS( GOLD2ONE, GOLDAMT)
 10007  19   28:0    67           END;  (* GOLDREWD *)
 10008  19   28:0    82           
 10009  19   28:0    82           
 10010  19   29:D     1         PROCEDURE ITEMREWD;  (* P010D1D *)
 10011  19   29:D     1         
 10012  19   29:0     0           BEGIN
 10013  19   29:1     0             CHARXXXX := RANDOM MOD PARTYCNT;
 10014  19   29:1    10             WHILE CHARACTR[ CHARXXXX].STATUS <> OK DO
 10015  19   29:2    23               CHARXXXX := (CHARXXXX + 1) MOD PARTYCNT;
 10016  19   29:1    35             IF CHARACTR[ CHARXXXX].POSS.POSSCNT = 8 THEN
 10017  19   29:2    48               EXIT( ITEMREWD);  (* IF RANDOM CHARACTER IS OK AND HAS 8 
 10018  19   29:2    52                                    POSSESSIONS,  THEN EXIT !! *)
 10019  19   29:1    52             CHARIIII := 0;
 10020  19   29:1    56             WHILE (CALCULAT( 01, 100, 1) <
 10021  19   29:1    63                                      REWARDM.REWDCALC.ITEM.PERCBIGR) AND
 10022  19   29:1    67                   (CHARIIII < REWARDM.REWDCALC.ITEM.MAXTIMES) DO
 10023  19   29:2    77               CHARIIII := CHARIIII + 1;
 10024  19   29:1    87             ITEMINDX := REWARDM.REWDCALC.ITEM.MININDX +
 10025  19   29:1    90                (CALCULATE( 1, REWARDM.REWDCALC.ITEM.RANGE, 1)) +
 10026  19   29:1   100                (REWARDM.REWDCALC.ITEM.MFACTOR * CHARIIII);
 10027  19   29:1   111             FOUNDITM( CHARXXXX, CHARIIII, ITEMINDX);
 10028  19   29:1   122             PAUSE2
 10029  19   29:0   122           END;  (* ITEMREWD *)
 10030  19   29:0   142           
 10031  19   29:0   142           
 10032  19   26:0     0         BEGIN  (* GETREWRD *)
 10033  19   26:1     0           IF REWARDM.REWDPERC < (RANDOM MOD 100) THEN
 10034  19   26:2    16             EXIT( GETREWRD);
 10035  19   26:1    20           IF REWARDM.BITEM = 0 THEN
 10036  19   26:2    25             GOLDREWD
 10037  19   26:1    25           ELSE
 10038  19   26:2    29             ITEMREWD
 10039  19   26:0    29         END;   (* GETREWRD *)
 10040  19   26:0    44         
 10041  19   26:0    44         
 10042  19   30:D     1       PROCEDURE GIVEGOLD;  (* P010D1E *)
 10043  19   30:D     1       
 10044  19   30:0     0         BEGIN
 10045  19   30:1     0           DIVLONG( GOLD2ONE, ALIVECNT);
 10046  19   30:1     9           CLRRECT( 1, 11, 38, 4);
 10047  19   30:1    16           MVCURSOR( 1, 12);
 10048  19   30:1    21           PRINTSTR( 'EACH SHARE IS WORTH ');
 10049  19   30:1    47           PRLONG2( GOLD2ONE);
 10050  19   30:1    52           PRINTSTR( ' GP!');
 10051  19   30:1    62           FOR INDX := 0 TO PARTYCNT - 1 DO
 10052  19   30:2    78             IF CHARACTR[ INDX].STATUS = OK THEN
 10053  19   30:3    91               ADDLONGS( CHARACTR[ INDX].GOLD, GOLD2ONE);
 10054  19   30:1   116           PAUSE2
 10055  19   30:0   116         END;  (* GIVEGOLD *)
 10056  19   30:0   134         
 10057  19   30:0   134         
 10058  19    6:0     0       BEGIN (* CHSTGOLD *)
 10059  19    6:1     0         FILLCHAR( GOLD2ONE, 6, 0);
 10060  19    6:1     7         ENMYREWD;
 10061  19    6:1     9         RDREWARD;
 10062  19    6:1    11         UNITCLEAR( 1);
 10063  19    6:1    14         IF REWARDZ.BCHEST AND (CHSTALRM <> 1) THEN
 10064  19    6:2    21           BEGIN
 10065  19    6:3    21             ACHEST;
 10066  19    6:3    23             CLRRECT( 3, 5, 9, 5)
 10067  19    6:2    27           END
 10068  19    6:1    30         ELSE
 10069  19    6:2    32           CHSTALRM := 0;
 10070  19    6:1    35         CLRRECT( 1, 11, 38, 4);
 10071  19    6:1    42         PIC2SCRN( GETREC( ZSPCCHRS, 19, 512));
 10072  19    6:1    54         FOR INDX := 1 TO REWARDZ.REWRDCNT DO
 10073  19    6:2    66           GETREWRD( REWARDZ.REWARDXX[ INDX]);
 10074  19    6:1    82         GIVEGOLD
 10075  19    6:0    82       END;  (* CHSTGOLD *)
 10076  19    6:0    98     
 10077  19    6:0    98 (*$I WIZ1C:REWARDS   *)
 10077  19    6:0    98 (*$I WIZ1C:REWARDS2  *)
 10078  19    6:0    98     
 10079  19   31:D     1   PROCEDURE GIVEEXP;  (* P010D1F *)
 10080  19   31:D     1   
 10081  19   31:D     1     VAR
 10082  19   31:D     1          WEPSTY3I : INTEGER;
 10083  19   31:D     2          SPPCI    : INTEGER;
 10084  19   31:D     3          BATRESLT : TBATRSLT;
 10085  19   31:D    17          CHARXXX  : INTEGER;  (* MULTIPLE USES *)
 10086  19   31:D    18          KILLEXP  : TWIZLONG; (* MULTIPLE USES *)
 10087  19   31:D    21                   
 10088  19   31:D    21                   
 10089  19   32:D     1     PROCEDURE CNTALIVE;  (* P010D20 *)
 10090  19   32:D     1     
 10091  19   32:0     0       BEGIN
 10092  19   32:1     0         ALIVECNT := 0;
 10093  19   32:1     4         FOR LLBASE04 := 0 TO PARTYCNT - 1 DO
 10094  19   32:2    17           IF CHARACTR[ LLBASE04].STATUS = OK THEN
 10095  19   32:3    28             ALIVECNT := ALIVECNT + 1;
 10096  19   32:1    43         IF ALIVECNT = 0 THEN
 10097  19   32:2    50           BEGIN
 10098  19   32:3    50             XGOTO := XCEMETRY;
 10099  19   32:3    53             EXIT( REWARDS)
 10100  19   32:2    57           END
 10101  19   32:0    57       END;  (* CNTALIVE *)
 10102  19   32:0    72       
 10103  19   32:0    72       
 10104  19   33:D     1     PROCEDURE CALC1EXP;  (* P010D21 *)
 10105  19   33:D     1     
 10106  19   33:D     1       VAR
 10107  19   33:D     1             MULT2040 : INTEGER;
 10108  19   33:D     2     
 10109  19   33:D     2     
 10110  19   34:D     1       PROCEDURE TOTALEXP;  (* P010D22 *)
 10111  19   34:D     1       
 10112  19   34:D     1         VAR
 10113  19   34:D     1              ENEMYREC : TENEMY;
 10114  19   34:D    80       
 10115  19   35:D     1           PROCEDURE CALCKILL;  (* P010D23 *)
 10116  19   35:D     1           
 10117  19   35:D     1             VAR
 10118  19   35:D     1                  KILLEXPX: TWIZLONG;
 10119  19   35:D     4           
 10120  19   35:D     4           
 10121  19   36:D     1             PROCEDURE SETKILLX( AMOUNT : INTEGER);  (* P010D24 *)
 10122  19   36:D     2             
 10123  19   36:0     0               BEGIN (* SETKILLX *)
 10124  19   36:1     0                 KILLEXPX.HIGH := 0;
 10125  19   36:1     4                 KILLEXPX.MID  := 0;
 10126  19   36:1     8                 KILLEXPX.LOW  := AMOUNT
 10127  19   36:0     8               END;  (* SETKILLX *)
 10128  19   36:0    24               
 10129  19   36:0    24               
 10130  19   37:D     1             PROCEDURE MLTADDKX( MULTIPLY : INTEGER;  (* P010D25 *)
 10131  19   37:D     2                                 AMOUNT   : INTEGER);
 10132  19   37:D     3                                
 10133  19   37:0     0               BEGIN (* MLTADDKX *)
 10134  19   37:1     0                 IF MULTIPLY = 0 THEN
 10135  19   37:2     5                   EXIT( MLTADDKX);
 10136  19   37:1     9                 SETKILLX( AMOUNT);
 10137  19   37:1    12                 WHILE MULTIPLY > 1 DO
 10138  19   37:2    17                   BEGIN
 10139  19   37:3    17                     MULTIPLY := MULTIPLY - 1;
 10140  19   37:3    22                     ADDLONGS( KILLEXPX, KILLEXPX)
 10141  19   37:2    28                   END;
 10142  19   37:1    33                 ADDLONGS( KILLEXP, KILLEXPX)
 10143  19   37:0    39               END;  (* MLTADDKX *)
 10144  19   37:0    56               
 10145  19   37:0    56           
 10146  19   35:0     0             BEGIN (* CALCKILL *)
 10147  19   35:1     0               FILLCHAR( KILLEXP, 6, CHR( 0));
 10148  19   35:1     8               FILLCHAR( KILLEXPX, 6, CHR( 0));
 10149  19   35:1    15               SETKILLX( ENEMYREC.HPREC.LEVEL * ENEMYREC.HPREC.HPFAC);
 10150  19   35:1    24               IF ENEMYREC.BREATHE = 0 THEN
 10151  19   35:2    31                 MULT2040:= 20
 10152  19   35:1    31               ELSE
 10153  19   35:2    37                 MULT2040:= 40;
 10154  19   35:1    41               MULTLONG( KILLEXPX, MULT2040);
 10155  19   35:1    49               ADDLONGS( KILLEXP, KILLEXPX);
 10156  19   35:1    57               MLTADDKX( ENEMYREC.MAGSPELS, 35);
 10157  19   35:1    63               MLTADDKX( ENEMYREC.PRISPELS, 35);
 10158  19   35:1    69               MLTADDKX( ENEMYREC.DRAINAMT, 200);
 10159  19   35:1    77               MLTADDKX( ENEMYREC.HEALPTS, 90);
 10160  19   35:1    83               
 10161  19   35:1    83               SETKILLX( 40 * (11 - ENEMYREC.AC));
 10162  19   35:1    92               ADDLONGS( KILLEXP, KILLEXPX);
 10163  19   35:1   100               IF ENEMYREC.RECSN > 1 THEN
 10164  19   35:2   107                 MLTADDKX( ENEMYREC.RECSN, 30);
 10165  19   35:1   113               IF ENEMYREC.UNAFFCT > 0 THEN
 10166  19   35:2   120                 MLTADDKX( (ENEMYREC.UNAFFCT DIV 10) + 1, 40);
 10167  19   35:1   130               LLBASE04 := 0;
 10168  19   35:1   133               FOR WEPSTY3I := 1 TO 6 DO
 10169  19   35:2   147                 IF ENEMYREC.WEPVSTY3[ WEPSTY3I] THEN
 10170  19   35:3   159                   LLBASE04 := LLBASE04 + 1;
 10171  19   35:1   174               MLTADDKX( LLBASE04, 35);
 10172  19   35:1   178               LLBASE04 := 0;
 10173  19   35:1   181               FOR SPPCI := 0 TO 6 DO
 10174  19   35:2   195                 IF ENEMYREC.SPPC[ SPPCI] THEN
 10175  19   35:3   207                   LLBASE04 := LLBASE04 + 1;
 10176  19   35:1   222               MLTADDKX( LLBASE04, 40)
 10177  19   35:0   224             END;  (* CALCKILL *)
 10178  19   35:0   242             
 10179  19   34:0     0         BEGIN (* TOTALEXP *)
 10180  19   34:1     0           MOVELEFT( IOCACHE[ GETREC( ZENEMY,
 10181  19   34:1     4                                      BATRESLT.ENMYID[ CHARXXX],
 10182  19   34:1    15                                      SIZEOF( TENEMY))],
 10183  19   34:1    23                     ENEMYREC,
 10184  19   34:1    26                     SIZEOF( TENEMY));
 10185  19   34:1    31           CALCKILL;   (* KILLEXP := ENEMYREC.EXPAMT;  LOL *)
 10186  19   34:1    33 
 10187  19   34:1    33           MULTLONG( KILLEXP, BATRESLT.ENMYCNT[ CHARXXX]);
 10188  19   34:1    49           ADDLONGS( EXPPERCH, KILLEXP)
 10189  19   34:0    55         END;  (* TOTALEXP *)
 10190  19   34:0    70       
 10191  19   34:0    70       
 10192  19   33:0     0       BEGIN  (* CALC1EXP *)
 10193  19   33:1     0         FILLCHAR( EXPPERCH, 6, 0);
 10194  19   33:1     8         FOR CHARXXX := 1 TO 4 DO
 10195  19   33:2    22           IF BATRESLT.ENMYID[ CHARXXX] >= 0 THEN
 10196  19   33:3    37             TOTALEXP;
 10197  19   33:1    49         DIVLONG( EXPPERCH, ALIVECNT)
 10198  19   33:0    55       END;   (* CALC1EXP *)
 10199  19   33:0    72       
 10200  19   33:0    72       
 10201  19   38:D     1     PROCEDURE CHKDRAIN;  (* P010D26 *)
 10202  19   38:D     1     
 10203  19   38:D     1       VAR
 10204  19   38:D     1            EXPTABLE : TEXP;
 10205  19   38:D   313            
 10206  19   38:D   313            
 10207  19   39:D     1       PROCEDURE DROPLEVL( VAR CHAREXP:  TWIZLONG;  (* P010D27 *)
 10208  19   39:D     2                               CURRLEVL: INTEGER;
 10209  19   39:D     3                               CLASS:    TCLASS);
 10210  19   39:D     4                          
 10211  19   39:0     0         BEGIN
 10212  19   39:1     0           MVCURSOR( 1, 13);
 10213  19   39:1     5           PRINTSTR( 'HE HAD ');
 10214  19   39:1    18           PRLONG2( CHAREXP);
 10215  19   39:1    21           PRINTSTR( ' EP');
 10216  19   39:1    30         
 10217  19   39:1    30           CURRLEVL := CURRLEVL - 1;
 10218  19   39:1    35           IF CURRLEVL = 0 THEN
 10219  19   39:2    40             FILLCHAR( CHAREXP, 6, 0)
 10220  19   39:1    46           ELSE
 10221  19   39:2    48             IF CURRLEVL < 13 THEN
 10222  19   39:3    53               CHAREXP := EXPTABLE[ CLASS][ CURRLEVL]
 10223  19   39:2    63             ELSE
 10224  19   39:3    67               BEGIN
 10225  19   39:4    67                 CHAREXP := EXPTABLE[ CLASS][ 12];
 10226  19   39:4    79                 FOR CHARXXX := 13 TO CURRLEVL DO
 10227  19   39:5    93                   ADDLONGS( CHAREXP, EXPTABLE[ CLASS][ 0])
 10228  19   39:3   103               END;
 10229  19   39:1   116           ADDLONGS( CHAREXP, KILLEXP);
 10230  19   39:1   123           MVCURSOR( 1, 14);
 10231  19   39:1   128           PRINTSTR( 'HE HAS ');
 10232  19   39:1   141           PRLONG2( CHAREXP);
 10233  19   39:1   144           PRINTSTR( ' EP NOW');
 10234  19   39:1   157           PAUSE2
 10235  19   39:0   157         END;  (* DROPLEVL *)
 10236  19   39:0   174         
 10237  19   39:0   174         
 10238  19   38:0     0       BEGIN (* CHKDRAIN *)
 10239  19   38:1     0         MOVELEFT( IOCACHE[ GETREC( ZEXP, 0, SIZEOF( TEXP))],
 10240  19   38:1    13                   EXPTABLE,
 10241  19   38:1    16                   SIZEOF( TEXP));
 10242  19   38:1    21         KILLEXP.HIGH := 0;
 10243  19   38:1    25         KILLEXP.MID  := 0;
 10244  19   38:1    29         KILLEXP.LOW  := 1;
 10245  19   38:1    33         FOR CHARXXX := 0 TO PARTYCNT - 1 DO
 10246  19   38:2    52           BEGIN
 10247  19   38:3    52             IF  BATRESLT.DRAINED[ CHARXXX] THEN
 10248  19   38:4    63               BEGIN
 10249  19   38:5    63                 CLRRECT( 1, 11, 38, 4);
 10250  19   38:5    70                 MVCURSOR( 1, 11);
 10251  19   38:5    75                 PRINTSTR( CHARACTR[ CHARXXX].NAME);
 10252  19   38:5    85                 PRINTSTR( ' WAS DRAINED!');
 10253  19   38:5   104                 DROPLEVL( CHARACTR[ CHARXXX].EXP,
 10254  19   38:5   113                           CHARACTR[ CHARXXX].CHARLEV,
 10255  19   38:5   122                           CHARACTR[ CHARXXX].CLASS)
 10256  19   38:4   131               END
 10257  19   38:2   133           END;
 10258  19   38:1   143         CLRRECT( 1, 11, 38, 4);
 10259  19   38:1   150         IF XGOTO = XREWARD2 THEN
 10260  19   38:2   155           EXIT( GIVEEXP);
 10261  19   38:1   159         FOR CHARXXX := 0 TO PARTYCNT - 1 DO
 10262  19   38:2   178           IF CHARACTR[ CHARXXX].STATUS = OK THEN
 10263  19   38:3   191             EXIT( CHKDRAIN);
 10264  19   38:1   205         XGOTO := XCEMETRY;
 10265  19   38:1   208         EXIT( REWARDS)
 10266  19   38:0   212       END;  (* CHKDRAIN *)
 10267  19   38:0   228       
 10268  19   38:0   228       
 10269  19   31:0     0     BEGIN  (* GIVEEXP *)
 10270  19   31:1     0       MOVELEFT( IOCACHE, BATRESLT, SIZEOF( TBATRSLT));
 10271  19   31:1    10       CACHEWRI := FALSE;
 10272  19   31:1    13       CNTALIVE;
 10273  19   31:1    15       CHKDRAIN;
 10274  19   31:1    17       CALC1EXP;
 10275  19   31:1    19       CLRRECT( 13, 1, 26, 4);
 10276  19   31:1    26       MVCURSOR( 13, 1);
 10277  19   31:1    31       PRINTSTR( 'FOR KILLING THE MONSTERS');
 10278  19   31:1    61       MVCURSOR( 13, 2);
 10279  19   31:1    66       PRINTSTR( 'EACH SURVIVOR GETS ');
 10280  19   31:1    91       PRLONG2( EXPPERCH);
 10281  19   31:1    96       MVCURSOR( 13, 3);
 10282  19   31:1   101       PRINTSTR( 'EXPERIENCE POINTS');
 10283  19   31:1   124       PAUSE2;
 10284  19   31:1   127       FOR LLBASE04 := 0 TO PARTYCNT - 1 DO
 10285  19   31:2   141         IF CHARACTR[ LLBASE04].STATUS = OK THEN
 10286  19   31:3   152           ADDLONGS( CHARACTR[ LLBASE04].EXP, EXPPERCH)
 10287  19   31:0   162     END;   (* GIVEEXP *)
 10288  19   31:0   186   
 10289  19   31:0   186   
 10290  19    1:0     0   BEGIN  (* REWARDS *)
 10291  19    1:0     0     
 10292  19    1:1     0     CASE XGOTO OF
 10293  19    1:1     3     
 10294  19    1:1     3        XREWARD:  BEGIN
 10295  19    1:3     3                    XGOTO := XRUNNER;
 10296  19    1:3     6                    GIVEEXP;
 10297  19    1:3     8                    CHSTGOLD
 10298  19    1:2     8                  END;
 10299  19    1:2    12                  
 10300  19    1:1    12       XREWARD2:  BEGIN
 10301  19    1:3    12                    GIVEEXP;
 10302  19    1:3    14                    LLBASE04 := 0;
 10303  19    1:3    17                    XGOTO := XSCNMSG
 10304  19    1:2    17                  END
 10305  19    1:1    20     END
 10306  19    1:0    54   END;  (* REWARDS *)
 10307  19    1:0    66   
 10308  19    1:0    66 (*$I WIZ1C:REWARDS2  *)
 10309  19    1:0    66                       
 10309  19    1:0    66 (*$I WIZ1C:RUNNER    *)
 10310  20    1:D     1 SEGMENT PROCEDURE RUNNER;     (* P010E01 *)
 10311  20    1:D     1   
 10312  20    1:D     1     CONST
 10313  20    1:D     1          NORTH = 0;
 10314  20    1:D     1          EAST  = 1;
 10315  20    1:D     1          SOUTH = 2;
 10316  20    1:D     1          WEST  = 3;
 10317  20    1:D     1   
 10318  20    1:D     1     VAR
 10319  20    1:D     1          QUICKPLT : BOOLEAN;
 10320  20    1:D     2          INITTURN : BOOLEAN;
 10321  20    1:D     3          NEEDDRMZ : BOOLEAN;
 10322  20    1:D     4          MAZE     : TMAZE;
 10323  20    1:D   451          
 10324  20    1:D   451          
 10325  20    2:D     1     PROCEDURE DRAWMAZE;  (* P010E02 *)
 10326  20    2:D     1     
 10327  20    2:D     1       VAR
 10328  20    2:D     1            GOTLIGHT : BOOLEAN;
 10329  20    2:D     2            WALHEIGH : INTEGER;
 10330  20    2:D     3            DOORFRAM : INTEGER;
 10331  20    2:D     4            DOORWIDT : INTEGER; (* 1/2 DOOR WIDTH *)
 10332  20    2:D     5            WALWIDTH : INTEGER; (* 1/2 WALL WIDTH *)
 10333  20    2:D     6            
 10334  20    2:D     6            (* IMAGINE A SMALLER BOX DRAWN INSIDE AN OUTER BOX.  THE OUTER BOX
 10335  20    2:D     6               HAS UPPER LEFT CORNER AS 0,0 AND LOWER RIGHT CORNER AS 81,78.
 10336  20    2:D     6               THE INSIDE BOX HAS COORDINATES (UL, UL) AND (LR, LR).       *)
 10337  20    2:D     6               
 10338  20    2:D     6            LR  : INTEGER; (* LOWER RIGHT INNER BOX BOUNDARY *)
 10339  20    2:D     7            UL  : INTEGER; (* UPPER LEFT  INNER BOX BOUNDARY *)
 10340  20    2:D     8            
 10341  20    2:D     8            SQREDESC : INTEGER;
 10342  20    2:D     9            XUPPER   : INTEGER;
 10343  20    2:D    10            XLOWER   : INTEGER;
 10344  20    2:D    11            
 10345  20    2:D    11            Y4DRAW   : INTEGER;
 10346  20    2:D    12            X4DRAW   : INTEGER;
 10347  20    2:D    13            LIGHTDIS : INTEGER;
 10348  20    2:D    14            WALLTYPE : TWALL;
 10349  20    2:D    15     
 10350  20    2:D    15         
 10351  20    3:D     1       PROCEDURE SHFTPOS( VAR X:        INTEGER;  (* P010E03 *)
 10352  20    3:D     2                          VAR Y:        INTEGER;
 10353  20    3:D     3                              RIGHSHFT: INTEGER;
 10354  20    3:D     4                              FRWDSHFT: INTEGER);
 10355  20    3:D     5       
 10356  20    3:0     0         BEGIN
 10357  20    3:1     0           CASE DIRECTIO OF
 10358  20    3:1     4             NORTH:  BEGIN
 10359  20    3:3     4                       X := X + RIGHSHFT;
 10360  20    3:3    10                       Y := Y + FRWDSHFT
 10361  20    3:2    13                     END;
 10362  20    3:2    18                     
 10363  20    3:1    18              EAST:  BEGIN
 10364  20    3:3    18                       X := X + FRWDSHFT;
 10365  20    3:3    24                       Y := Y - RIGHSHFT
 10366  20    3:2    27                     END;
 10367  20    3:2    32                     
 10368  20    3:1    32             SOUTH:  BEGIN
 10369  20    3:3    32                       X := X - RIGHSHFT;
 10370  20    3:3    38                       Y := Y - FRWDSHFT
 10371  20    3:2    41                     END;
 10372  20    3:2    46                     
 10373  20    3:1    46              WEST:  BEGIN
 10374  20    3:3    46                       X := X - FRWDSHFT;
 10375  20    3:3    52                       Y := Y + RIGHSHFT
 10376  20    3:2    55                     END;
 10377  20    3:1    60           END;
 10378  20    3:1    76           X := (X + 20) MOD 20;
 10379  20    3:1    84           Y := (Y + 20) MOD 20
 10380  20    3:0    89         END;  (* SHFTPOS *)
 10381  20    3:0   104         
 10382  20    3:0   104         
 10383  20    3:0   104       
 10384  20    4:D     3         FUNCTION FRWDVIEW( DELTAR: INTEGER) : TWALL;  (* P010E04 *)
 10385  20    4:D     4         
 10386  20    4:D     4           VAR
 10387  20    4:D     4                Y : INTEGER;
 10388  20    4:D     5                X : INTEGER;
 10389  20    4:D     6                
 10390  20    4:0     0           BEGIN
 10391  20    4:1     0             X := X4DRAW;
 10392  20    4:1     5             Y := Y4DRAW;
 10393  20    4:1    10             SHFTPOS( X, Y, DELTAR, 0);
 10394  20    4:1    18             CASE DIRECTIO OF
 10395  20    4:1    22               NORTH:  FRWDVIEW := MAZE.N[ X][ Y];
 10396  20    4:1    38                EAST:  FRWDVIEW := MAZE.E[ X][ Y];
 10397  20    4:1    53               SOUTH:  FRWDVIEW := MAZE.S[ X][ Y];
 10398  20    4:1    68                WEST:  FRWDVIEW := MAZE.W[ X][ Y];
 10399  20    4:1    83             END
 10400  20    4:0    98           END;  (* FRWDVIEW *)
 10401  20    4:0   110           
 10402  20    4:0   110           
 10403  20    5:D     3         FUNCTION LEFTVIEW( DELTAR: INTEGER) : TWALL;  (* P010E05 *)
 10404  20    5:D     4         
 10405  20    5:D     4           VAR
 10406  20    5:D     4                Y : INTEGER;
 10407  20    5:D     5                X : INTEGER;
 10408  20    5:D     6                
 10409  20    5:0     0           BEGIN
 10410  20    5:1     0             X := X4DRAW;
 10411  20    5:1     5             Y := Y4DRAW;
 10412  20    5:1    10             SHFTPOS( X, Y, DELTAR, 0);
 10413  20    5:1    18             CASE DIRECTIO OF
 10414  20    5:1    22               NORTH:  LEFTVIEW := MAZE.W[ X][ Y];
 10415  20    5:1    37                EAST:  LEFTVIEW := MAZE.N[ X][ Y];
 10416  20    5:1    53               SOUTH:  LEFTVIEW := MAZE.E[ X][ Y];
 10417  20    5:1    68                WEST:  LEFTVIEW := MAZE.S[ X][ Y];
 10418  20    5:1    83             END
 10419  20    5:0    98           END;  (* LEFTVIEW *)
 10420  20    5:0   110           
 10421  20    5:0   110           
 10422  20    6:D     3         FUNCTION RIGHVIEW( DELTAR: INTEGER) : TWALL;  (* P010E06 *) 
 10423  20    6:D     4         
 10424  20    6:D     4           VAR
 10425  20    6:D     4                Y : INTEGER;
 10426  20    6:D     5                X : INTEGER;
 10427  20    6:D     6                
 10428  20    6:0     0           BEGIN
 10429  20    6:1     0             X := X4DRAW;
 10430  20    6:1     5             Y := Y4DRAW;
 10431  20    6:1    10             SHFTPOS( X, Y, DELTAR, 0);
 10432  20    6:1    18             CASE DIRECTIO OF
 10433  20    6:1    22               NORTH:  RIGHVIEW := MAZE.E[ X][ Y];
 10434  20    6:1    37                EAST:  RIGHVIEW := MAZE.S[ X][ Y];
 10435  20    6:1    52               SOUTH:  RIGHVIEW := MAZE.W[ X][ Y];
 10436  20    6:1    67                WEST:  RIGHVIEW := MAZE.N[ X][ Y];
 10437  20    6:1    83             END
 10438  20    6:0    98           END;  (* RIGHVIEW *)
 10439  20    6:0   110           
 10440  20    6:0   110           
 10441  20    7:D     1         PROCEDURE DRAWLEFT;  (* P010E07 *)
 10442  20    7:D     1         
 10443  20    7:0     0           BEGIN
 10444  20    7:1     0             XLOWER := UL;
 10445  20    7:1     6             DRAWLINE( UL, UL, -1, -1, WALWIDTH);             (* TOP EDGE *)
 10446  20    7:1    22             DRAWLINE( UL, UL,  0,  1, WALHEIGH);             (* RIGHT EDGE *)
 10447  20    7:1    36             DRAWLINE( UL, LR, -1,  1, WALWIDTH);             (* BOTTOM EDGE *)
 10448  20    7:1    51             DRAWLINE( UL - WALWIDTH, UL - WALWIDTH,          (* LEFT EDGE *)
 10449  20    7:1    65                                0,  1, WALHEIGH + WALHEIGH);
 10450  20    7:1    77             IF (WALLTYPE = OPEN) OR
 10451  20    7:1    82                (WALLTYPE = WALL) OR 
 10452  20    7:1    88                ((WALLTYPE = HIDEDOOR) AND
 10453  20    7:1    93                 (NOT GOTLIGHT AND ((RANDOM MOD 6) <> 3))) THEN
 10454  20    7:2   111               EXIT( DRAWLEFT);
 10455  20    7:2   115               
 10456  20    7:2   115             (* DRAW THE DOOR:  TOP, RIGHT, LEFT *)
 10457  20    7:2   115               
 10458  20    7:1   115             DRAWLINE( UL - DOORFRAM, UL, -1, -1, DOORWIDT);
 10459  20    7:1   135             DRAWLINE( UL - DOORFRAM, UL,  0,  1, WALHEIGH + DOORFRAM);
 10460  20    7:1   157             DRAWLINE( UL - DOORFRAM - DOORWIDT, UL - DOORWIDT, 0, 1,
 10461  20    7:1   177                         WALHEIGH + WALWIDTH + DOORFRAM)
 10462  20    7:0   188           END;
 10463  20    7:0   204           
 10464  20    7:0   204           
 10465  20    8:D     1         PROCEDURE DRAWRIGH;  (* P010E08 *)
 10466  20    8:D     1         
 10467  20    8:0     0           BEGIN
 10468  20    8:1     0             XUPPER := LR;
 10469  20    8:1     6             DRAWLINE( LR, UL, 1, -1, WALWIDTH);
 10470  20    8:1    21             DRAWLINE( LR, UL, 0,  1, WALHEIGH);
 10471  20    8:1    35             DRAWLINE( LR, LR, 1,  1, WALWIDTH);
 10472  20    8:1    49             DRAWLINE( LR + WALWIDTH, UL - WALWIDTH,
 10473  20    8:1    63                               0,  1, WALHEIGH + WALHEIGH);
 10474  20    8:1    75             IF (WALLTYPE = OPEN) OR
 10475  20    8:1    80                (WALLTYPE = WALL) OR 
 10476  20    8:1    86                ((WALLTYPE = HIDEDOOR) AND
 10477  20    8:1    91                 (NOT GOTLIGHT AND ((RANDOM MOD 6) <> 3))) THEN
 10478  20    8:2   109               EXIT( DRAWRIGH);
 10479  20    8:2   113               
 10480  20    8:2   113             (* DRAW THE DOOR *)
 10481  20    8:2   113               
 10482  20    8:1   113             DRAWLINE( LR + DOORFRAM, UL, 1, -1, DOORWIDT);
 10483  20    8:1   132             DRAWLINE( LR + DOORFRAM, UL, 0,  1,
 10484  20    8:1   144                       WALHEIGH + DOORFRAM);
 10485  20    8:1   154             DRAWLINE( LR + DOORFRAM + DOORWIDT, UL - DOORWIDT,
 10486  20    8:1   172                                          0,  1, WALHEIGH + WALWIDTH + DOORFRAM)
 10487  20    8:0   185           END;
 10488  20    8:0   200           
 10489  20    8:0   200           
 10490  20    9:D     1         PROCEDURE DRAWFRNT( FRNTWALL : TWALL; LRCENT : INTEGER); (* P010E09 *)
 10491  20    9:D     3         
 10492  20    9:D     3         
 10493  20    9:D     3           (* DRAW FRONT FACING WALL PANEL:  TOP, LEFT, RIGHT, BOTTOM.
 10494  20    9:D     3              (WHY DOES RIGHT EDGE HAVE +1 FOR LENGTH???)              *)
 10495  20    9:D     3         
 10496  20    9:0     0           BEGIN
 10497  20    9:1     0             DRAWLINE( UL + LRCENT, UL,            1, 0, WALHEIGH);
 10498  20    9:1    16             DRAWLINE( UL + LRCENT, UL,            0, 1, WALHEIGH);
 10499  20    9:1    32             DRAWLINE( UL + LRCENT + WALHEIGH, UL, 0, 1, WALHEIGH + 1);
 10500  20    9:1    54             DRAWLINE( UL + LRCENT, UL + WALHEIGH, 1, 0, WALHEIGH);
 10501  20    9:1    74             IF (FRNTWALL = OPEN) OR
 10502  20    9:1    77                (FRNTWALL = WALL) OR 
 10503  20    9:1    81                ((FRNTWALL = HIDEDOOR) AND
 10504  20    9:1    84                 (NOT GOTLIGHT AND ((RANDOM MOD 6) <> 3))) THEN
 10505  20    9:2   102               EXIT( DRAWFRNT);
 10506  20    9:2   106               
 10507  20    9:2   106             (* DRAW DOOR:  LEFT, RIGHT, TOP *)
 10508  20    9:2   106              
 10509  20    9:1   106             DRAWLINE( UL + LRCENT + DOORFRAM, LR,
 10510  20    9:1   118                         0, -1, WALWIDTH + DOORWIDT + DOORFRAM);
 10511  20    9:1   135                         
 10512  20    9:1   135             DRAWLINE( UL + LRCENT + WALWIDTH + DOORWIDT + DOORFRAM, LR,
 10513  20    9:1   155                         0, -1, WALWIDTH + DOORWIDT + DOORFRAM);
 10514  20    9:1   172                         
 10515  20    9:1   172             DRAWLINE( UL + LRCENT + DOORFRAM,
 10516  20    9:1   181                         LR - WALWIDTH - DOORWIDT- DOORFRAM,
 10517  20    9:1   196                         1,  0, WALWIDTH + DOORWIDT + 1)
 10518  20    9:0   207           END;
 10519  20    9:0   222           
 10520  20    9:0   222         
 10521  20    2:0     0       BEGIN (* DRAWMAZE *)
 10522  20    2:1     0         GOTLIGHT := LIGHT > 0;
 10523  20    2:1     5         IF GOTLIGHT THEN
 10524  20    2:2     8           BEGIN
 10525  20    2:3     8             IF QUICKPLT THEN
 10526  20    2:4    13               LIGHTDIS := 3
 10527  20    2:3    13             ELSE
 10528  20    2:4    18                 LIGHTDIS := 5;
 10529  20    2:3    21             LIGHT := LIGHT - 1
 10530  20    2:2    22           END
 10531  20    2:1    26         ELSE
 10532  20    2:2    28           LIGHTDIS := 2;
 10533  20    2:2    31         
 10534  20    2:1    31         UL :=  8;
 10535  20    2:1    34         LR := 72;
 10536  20    2:1    37         WALWIDTH := 32;
 10537  20    2:1    40         DOORWIDT := 16;
 10538  20    2:1    43         DOORFRAM :=  8;
 10539  20    2:1    46         WALHEIGH := 64;
 10540  20    2:1    49         
 10541  20    2:1    49         X4DRAW := MAZEX;
 10542  20    2:1    53         Y4DRAW := MAZEY;
 10543  20    2:1    57         CLEARPIC;
 10544  20    2:1    60         XLOWER := 0;
 10545  20    2:1    63         XUPPER := 81;
 10546  20    2:1    66         WHILE LIGHTDIS > 0 DO
 10547  20    2:2    71           BEGIN
 10548  20    2:3    71             SQREDESC := MAZE.SQREXTRA[ X4DRAW][ Y4DRAW];
 10549  20    2:3    85             IF MAZE.SQRETYPE[ SQREDESC] = DARK THEN
 10550  20    2:4    98               EXIT( DRAWMAZE)
 10551  20    2:3   102             ELSE
 10552  20    2:4   104               IF MAZE.SQRETYPE[ SQREDESC] = TRANSFER THEN
 10553  20    2:5   117                 IF MAZE.AUX0[ SQREDESC] = MAZELEV THEN
 10554  20    2:6   130                   BEGIN
 10555  20    2:7   130                     X4DRAW := MAZE.AUX2[ SQREDESC];
 10556  20    2:7   140                     Y4DRAW := MAZE.AUX1[ SQREDESC]
 10557  20    2:6   147                   END;
 10558  20    2:6   150             
 10559  20    2:3   150             CLRPICT( XLOWER, 0, XUPPER, 79);
 10560  20    2:3   157             
 10561  20    2:3   157               (* $0679 := XLOWER
 10562  20    2:3   157                  $06F9 := 0
 10563  20    2:3   157                  $0779 := XUPPER
 10564  20    2:3   157                  $07F9 := 79
 10565  20    2:3   157                  
 10566  20    2:3   157                  THESE MEMORY LOCATIONS ARE ACCESSED BY DRAWLINE.
 10567  20    2:3   157                  
 10568  20    2:3   157                  WITH THESE PARAMETERS, THERE IS NO PICTURE CLEARING. *)
 10569  20    2:3   157             
 10570  20    2:3   157             WALLTYPE := LEFTVIEW( 0);
 10571  20    2:3   164             IF WALLTYPE <> OPEN THEN
 10572  20    2:4   169                 DRAWLEFT
 10573  20    2:3   169             ELSE
 10574  20    2:4   173               BEGIN
 10575  20    2:5   173                 WALLTYPE := FRWDVIEW( -1);  (* STEP LEFT ONE SQUARE *)
 10576  20    2:5   181                 IF WALLTYPE <> OPEN THEN
 10577  20    2:6   186                   BEGIN
 10578  20    2:7   186                     DRAWFRNT( WALLTYPE, -( 2 * WALWIDTH));
 10579  20    2:7   193                     XLOWER := UL
 10580  20    2:6   193                   END;
 10581  20    2:4   196               END;
 10582  20    2:4   196             
 10583  20    2:3   196             WALLTYPE := RIGHVIEW( 0);
 10584  20    2:3   203             IF WALLTYPE <> OPEN THEN
 10585  20    2:4   208               DRAWRIGH
 10586  20    2:3   208             ELSE
 10587  20    2:4   212               BEGIN
 10588  20    2:5   212                 WALLTYPE := FRWDVIEW( 1);  (* STEP RIGHT ONE SQUARE *)
 10589  20    2:5   219                 IF WALLTYPE <> OPEN THEN
 10590  20    2:6   224                   BEGIN
 10591  20    2:7   224                     DRAWFRNT( WALLTYPE, 2 * WALWIDTH);
 10592  20    2:7   230                     XUPPER := LR
 10593  20    2:6   230                   END;
 10594  20    2:4   233               END;
 10595  20    2:4   233             
 10596  20    2:3   233             WALLTYPE := FRWDVIEW( 0);
 10597  20    2:3   240             IF WALLTYPE <> OPEN THEN
 10598  20    2:4   245               BEGIN
 10599  20    2:5   245                 DRAWFRNT( WALLTYPE, 0);
 10600  20    2:5   249                 EXIT( DRAWMAZE)
 10601  20    2:4   253               END;
 10602  20    2:4   253             
 10603  20    2:3   253             WALWIDTH := WALWIDTH DIV 2;
 10604  20    2:3   258             DOORWIDT := WALWIDTH DIV 2;
 10605  20    2:3   263             WALHEIGH := WALWIDTH * 2;
 10606  20    2:3   268             DOORFRAM := WALWIDTH DIV 4;
 10607  20    2:3   273             UL := UL + WALWIDTH;
 10608  20    2:3   278             LR := LR - WALWIDTH;
 10609  20    2:3   283             
 10610  20    2:3   283             SHFTPOS( X4DRAW, Y4DRAW, 0, 1);  (* STEP FORWARD *)
 10611  20    2:3   291             LIGHTDIS := LIGHTDIS - 1
 10612  20    2:3   292               
 10613  20    2:2   292           END; (* WHILE *)
 10614  20    2:0   298       END;  (* DRAWMAZE *)
 10615  20    2:0   314 (*$I WIZ1C:RUNNER    *)
 10615  20    2:0   314 (*$I WIZ1C:RUNNER2   *)
 10616  20    2:0   314     
 10617  20   10:D     1     PROCEDURE READMAZE;  (* P010E0A *)
 10618  20   10:D     1     
 10619  20   10:0     0       BEGIN
 10620  20   10:1     0         MOVELEFT( IOCACHE[ GETREC( ZMAZE, MAZELEV - 1, SIZEOF( TMAZE))],
 10621  20   10:1    16                   MAZE,
 10622  20   10:1    20                   SIZEOF( TMAZE))
 10623  20   10:0    25       END;
 10624  20   10:0    38       
 10625  20   10:0    38     
 10626  20   11:D     1     PROCEDURE PRSTATS;  (* P010E0B *)
 10627  20   11:D     1     
 10628  20   11:D     1       VAR
 10629  20   11:D     1           SAVE1    : INTEGER;
 10630  20   11:D     2           TEMPX    : INTEGER;  (* MULTIPLE USES *)
 10631  20   11:D     3           CHARX    : INTEGER;
 10632  20   11:D     4           CHARREC  : TCHAR;
 10633  20   11:D   108           ANYALIVE : BOOLEAN;
 10634  20   11:D   109     
 10635  20   11:D   109     
 10636  20   12:D     1       PROCEDURE PRSTATUS;  (* P010E0C *)
 10637  20   12:D     1       
 10638  20   12:0     0         BEGIN
 10639  20   12:1     0           IF CHARACTR[ CHARX].STATUS = OK THEN
 10640  20   12:2    13             BEGIN
 10641  20   12:3    13               ANYALIVE := TRUE;
 10642  20   12:3    17               IF CHARACTR[ CHARX].LOSTXYL.POISNAMT[ 1] = 0 THEN
 10643  20   12:4    36                 PRINTNUM( CHARACTR[ CHARX].HPMAX, 4)
 10644  20   12:3    46               ELSE
 10645  20   12:4    51                 PRINTSTR( 'POISON')
 10646  20   12:2    60             END
 10647  20   12:1    63           ELSE
 10648  20   12:2    65             PRINTSTR( SCNTOC.STATUS[ CHARACTR[ CHARX].STATUS])
 10649  20   12:0    79         END;  (* PRSTATUS *)
 10650  20   12:0    94         
 10651  20   12:0    94         
 10652  20   11:0     0       BEGIN  (* PRSTATS *)
 10653  20   11:1     0         FOR CHARX := 0 TO PARTYCNT - 2 DO
 10654  20   11:2    14           BEGIN
 10655  20   11:3    14             FOR TEMPX := CHARX + 1 TO PARTYCNT - 1 DO
 10656  20   11:4    30               BEGIN
 10657  20   11:5    30                 IF CHARACTR[ CHARX].STATUS > CHARACTR[ TEMPX].STATUS THEN
 10658  20   11:6    47                   BEGIN
 10659  20   11:7    47                     CHARREC := CHARACTR[ CHARX];
 10660  20   11:7    56                     CHARACTR[ CHARX] := CHARACTR[ TEMPX];
 10661  20   11:7    68                     CHARACTR[ TEMPX] := CHARREC;
 10662  20   11:7    77                     
 10663  20   11:7    77                     SAVE1 := CHARDISK[ CHARX];
 10664  20   11:7    85                     CHARDISK[ CHARX] := CHARDISK[ TEMPX];
 10665  20   11:7    97                     CHARDISK[ TEMPX] := SAVE1
 10666  20   11:6   102                   END
 10667  20   11:4   104               END;
 10668  20   11:2   111           END;
 10669  20   11:2   118           
 10670  20   11:1   118         CLRRECT( 1, 17, 38, 6);
 10671  20   11:1   125       
 10672  20   11:1   125         ANYALIVE := FALSE;
 10673  20   11:1   128         FOR CHARX := 0 TO PARTYCNT - 1 DO
 10674  20   11:2   142           BEGIN
 10675  20   11:2   142           
 10676  20   11:3   142             WITH CHARACTR[ CHARX] DO
 10677  20   11:4   149               BEGIN
 10678  20   11:5   149                 MVCURSOR( 1, 17 + CHARX);
 10679  20   11:5   156                 PRINTNUM( CHARX + 1, 1);
 10680  20   11:5   163                 PRINTSTR( ' ');
 10681  20   11:5   167                 PRINTSTR( NAME);
 10682  20   11:5   172                 MVCURSOR( 19, 17 + CHARX);
 10683  20   11:5   179                 PRINTSTR( COPY( SCNTOC.ALIGN[ CHARACTR[ CHARX].ALIGN], 1, 1));
 10684  20   11:5   203                 PRINTCHR( '-');
 10685  20   11:5   207                 PRINTSTR( COPY( SCNTOC.CLASS[ CLASS], 1, 3));
 10686  20   11:5   228                 LLBASE04 := ARMORCL - ACMOD2;
 10687  20   11:5   236                 IF LLBASE04 >= 0 THEN
 10688  20   11:6   241                   PRINTNUM( LLBASE04, 3)
 10689  20   11:5   243                 ELSE
 10690  20   11:6   248                   IF LLBASE04 > - 10 THEN
 10691  20   11:7   254                     BEGIN
 10692  20   11:8   254                       PRINTSTR( ' -');
 10693  20   11:8   262                       PRINTNUM( ABS( LLBASE04), 1)
 10694  20   11:7   265                     END
 10695  20   11:6   268                   ELSE
 10696  20   11:7   270                     PRINTSTR( ' LO');
 10697  20   11:5   279                 IF STATUS >= DEAD THEN
 10698  20   11:6   287                   HPLEFT := 0;
 10699  20   11:6   293                   
 10700  20   11:5   293                 PRINTNUM( HPLEFT, 5);
 10701  20   11:5   301                 TEMPX := CHARACTR[ CHARX].HEALPTS -
 10702  20   11:5   308                            CHARACTR[ CHARX].LOSTXYL.POISNAMT[ 1];
 10703  20   11:5   324                 IF TEMPX = 0 THEN
 10704  20   11:6   329                   PRINTCHR( ' ')
 10705  20   11:5   330                 ELSE IF TEMPX < 0 THEN
 10706  20   11:7   340                   PRINTCHR( '-')
 10707  20   11:6   341                 ELSE
 10708  20   11:7   346                   PRINTCHR( '+');
 10709  20   11:5   350                 PRSTATUS;
 10710  20   11:4   352               END;  (* 'WITH' *)
 10711  20   11:2   352           END;  (* 'FOR' *)
 10712  20   11:2   359               
 10713  20   11:1   359           IF NOT ANYALIVE THEN
 10714  20   11:2   364             BEGIN
 10715  20   11:3   364               XGOTO := XCEMETRY;
 10716  20   11:3   367               EXIT( RUNNER)
 10717  20   11:2   371             END
 10718  20   11:2   371           
 10719  20   11:0   371       END;   (* PRSTATS *)
 10720  20   11:0   392       
 10721  20   11:0   392       
 10722  20   11:0   392       
 10723  20   13:D     1     PROCEDURE ENCOUNTR;  (* P010E0D *)
 10724  20   13:D     1     
 10725  20   13:D     1       VAR
 10726  20   13:D     1            ENCTYPE  : INTEGER;
 10727  20   13:D     2            ENEMYI   : INTEGER;
 10728  20   13:D     3            ENCCALC  : INTEGER;
 10729  20   13:D     4     
 10730  20   13:0     0       BEGIN
 10731  20   13:1     0         ENCB4RUN := TRUE;
 10732  20   13:1     3         CLRRECT( 1, 11, 38, 4);
 10733  20   13:1    10         MVCURSOR( 14, 12);
 10734  20   13:1    15         PRINTSTR( 'AN ENCOUNTER');
 10735  20   13:1    33         ENCTYPE := 1;
 10736  20   13:1    36         WHILE ((RANDOM MOD 4) = 2) AND (ENCTYPE < 3) DO
 10737  20   13:2    51           ENCTYPE := ENCTYPE + 1;
 10738  20   13:1    58         WITH MAZE.ENMYCALC[ ENCTYPE] DO
 10739  20   13:2    69           BEGIN
 10740  20   13:3    69             ENCCALC := 0;
 10741  20   13:3    72             WHILE ((RANDOM MOD 100) < PERCWORS) AND
 10742  20   13:3    82                    (ENCCALC < WORSE01) DO
 10743  20   13:4    89               ENCCALC := ENCCALC + 1;
 10744  20   13:3    96             ENEMYI := MINENEMY +
 10745  20   13:3    98                         (RANDOM MOD RANGE0N) +
 10746  20   13:3   107                         (MULTWORS * ENCCALC);
 10747  20   13:3   114             IF CHSTALRM = 1 THEN
 10748  20   13:4   119               ATTK012 := 2
 10749  20   13:3   119             ELSE
 10750  20   13:4   124               IF MAZE.FIGHTS[ MAZEX][ MAZEY] = 1 THEN
 10751  20   13:5   142                 IF FIGHTMAP[ MAZEX][ MAZEY] THEN
 10752  20   13:6   156                   ATTK012 := 2
 10753  20   13:5   156                 ELSE
 10754  20   13:6   161                   ATTK012 := 1
 10755  20   13:4   161               ELSE
 10756  20   13:5   166                 ATTK012 := 0;
 10757  20   13:3   169             ENEMYINX := ENEMYI;
 10758  20   13:3   172             XGOTO := XCOMBAT;
 10759  20   13:3   175             EXIT( RUNNER)
 10760  20   13:2   179           END
 10761  20   13:0   179       END;  (* ENCOUNTR *)
 10762  20   13:0   196       
 10763  20   13:0   196       
 10764  20   14:D     1     PROCEDURE RUNMAIN;  (* P010E0E *)
 10765  20   14:D     1     
 10766  20   14:D     1     
 10767  20   15:D     1       PROCEDURE EXITRUN( MAZELVL: INTEGER);  (* P010E0F *)
 10768  20   15:D     2       
 10769  20   15:0     0         BEGIN
 10770  20   15:1     0           MAZELEV := MAZELVL;
 10771  20   15:1     3           CLEARPIC;
 10772  20   15:1     6           XGOTO := XNEWMAZE;
 10773  20   15:1     9           EXIT( RUNNER)
 10774  20   15:0    13         END;  (* EXITRUN *)
 10775  20   15:0    26         
 10776  20   15:0    26         
 10777  20   16:D     1       PROCEDURE SPECSQAR;  (* P010E10 *)
 10778  20   16:D     1       
 10779  20   16:D     1         VAR
 10780  20   16:D     1              SQTYPE : INTEGER;
 10781  20   16:D     2       
 10782  20   16:D     2       
 10783  20   17:D     1         PROCEDURE SPINDIR;  (* P010E11 *)
 10784  20   17:D     1         
 10785  20   17:0     0           BEGIN
 10786  20   17:1     0             DIRECTIO := RANDOM MOD 4;
 10787  20   17:1     9             DRAWMAZE
 10788  20   17:0     9           END;
 10789  20   17:0    24           
 10790  20   17:0    24           
 10791  20   18:D     1         PROCEDURE QUIETXFR;  (* P010E12 *)
 10792  20   18:D     1         
 10793  20   18:0     0           BEGIN
 10794  20   18:1     0             MAZEX := MAZE.AUX2[ SQTYPE];
 10795  20   18:1    12             MAZEY := MAZE.AUX1[ SQTYPE];
 10796  20   18:1    24             IF MAZELEV <> MAZE.AUX0[ SQTYPE] THEN
 10797  20   18:2    39               EXITRUN( MAZE.AUX0[ SQTYPE])
 10798  20   18:0    49           END;  (* QUIETXFR *)
 10799  20   18:0    64           
 10800  20   18:0    64           
 10801  20   19:D     1         PROCEDURE ACHUTE;  (* P010E13 *)
 10802  20   19:D     1         
 10803  20   19:0     0           BEGIN
 10804  20   19:1     0             PRINTSTR( 'A CHUTE!');
 10805  20   19:1    14             QUIETXFR
 10806  20   19:0    14           END;
 10807  20   19:0    28           
 10808  20   19:0    28           
 10809  20   20:D     1         PROCEDURE STAIRSYN;  (* P010E14 *)
 10810  20   20:D     1         
 10811  20   20:0     0           BEGIN
 10812  20   20:1     0             PRINTSTR( 'STAIRS GOING ');
 10813  20   20:1    19             IF MAZELEV > MAZE.AUX0[ SQTYPE] THEN
 10814  20   20:2    34               PRINTSTR( 'UP.')
 10815  20   20:1    40             ELSE
 10816  20   20:2    45               PRINTSTR( 'DOWN.');
 10817  20   20:1    56             MVCURSOR( 1, 12);
 10818  20   20:1    61             PRINTSTR( 'TAKE THEM (Y/N) ?');
 10819  20   20:1    84             REPEAT
 10820  20   20:2    84               GETKEY
 10821  20   20:1    84             UNTIL (INCHAR = 'Y') OR (INCHAR = 'N');
 10822  20   20:1    96             IF INCHAR = 'Y' THEN
 10823  20   20:2   101               QUIETXFR
 10824  20   20:0   101           END;  (* STAIRSYN *)
 10825  20   20:0   118           
 10826  20   20:0   118           
 10827  20   21:D     1         PROCEDURE VERYDARK;  (* P010E15 *)
 10828  20   21:D     1         
 10829  20   21:0     0           BEGIN
 10830  20   21:1     0             MVCURSOR( 2, 5);
 10831  20   21:1     5             PRINTSTR( 'IT''S VERY');
 10832  20   21:1    20             MVCURSOR( 2, 6);
 10833  20   21:1    25             PRINTSTR( 'DARK HERE');
 10834  20   21:1    40             LIGHT := 0
 10835  20   21:0    40           END;  (* VERYDARK *)
 10836  20   21:0    56           
 10837  20   21:0    56           
 10838  20   22:D     1         PROCEDURE ROCKWATR;  (* P010E16 *)
 10839  20   22:D     1         
 10840  20   22:D     1           VAR
 10841  20   22:D     1                HPDAM   : INTEGER;
 10842  20   22:D     2                HPTIMES : INTEGER;
 10843  20   22:D     3                PARTYI  : INTEGER;
 10844  20   22:D     4             
 10845  20   22:0     0           BEGIN (* ROCKWATR *)
 10846  20   22:1     0             WRITE( CHR( 7));
 10847  20   22:1     8             PAUSE2;
 10848  20   22:1    11             FOR PARTYI := 0 TO PARTYCNT - 1 DO
 10849  20   22:2    24               BEGIN
 10850  20   22:3    24                 IF CHARACTR[ PARTYI].STATUS < DEAD THEN
 10851  20   22:4    35                   BEGIN
 10852  20   22:5    35                     IF ((RANDOM MOD 25) + MAZELEV) > 
 10853  20   22:5    45                        CHARACTR[ PARTYI].ATTRIB[ AGILITY] THEN
 10854  20   22:6    60                       BEGIN
 10855  20   22:7    60                         HPDAM := MAZE.AUX0[ SQTYPE];
 10856  20   22:7    72                         FOR HPTIMES := 1 TO MAZE.AUX2[ SQTYPE] DO
 10857  20   22:8    92                           HPDAM := HPDAM + (RANDOM MOD MAZE.AUX1[ SQTYPE]) + 1;
 10858  20   22:7   121                         CHARACTR[ PARTYI].HPLEFT := CHARACTR[ PARTYI].HPLEFT -
 10859  20   22:7   135                                                                          HPDAM;
 10860  20   22:7   138                         IF CHARACTR[ PARTYI].HPLEFT < 0 THEN
 10861  20   22:8   149                           BEGIN
 10862  20   22:9   149                             CHARACTR[ PARTYI].HPLEFT := 0;
 10863  20   22:9   158                             CHARACTR[ PARTYI].STATUS := DEAD;
 10864  20   22:9   167                             CLRRECT( 1, 11, 38, 1);
 10865  20   22:9   174                             MVCURSOR( 1, 11);
 10866  20   22:9   179                             PRINTSTR( CHARACTR[ PARTYI].NAME);
 10867  20   22:9   187                             PRINTSTR( ' DIED');
 10868  20   22:9   198                             PAUSE2
 10869  20   22:8   198                           END;
 10870  20   22:6   201                       END;
 10871  20   22:4   201                   END;
 10872  20   22:2   201               END;
 10873  20   22:1   208             PRSTATS
 10874  20   22:0   208           END;  (* ROCKWATR *)
 10875  20   22:0   232         
 10876  20   22:0   232           
 10877  20   23:D     1         PROCEDURE APIT;  (* P010E17 *)
 10878  20   23:D     1         
 10879  20   23:0     0           BEGIN
 10880  20   23:1     0             PRINTSTR( 'A PIT!');
 10881  20   23:1    12             ROCKWATR
 10882  20   23:0    12           END;
 10883  20   23:0    26           
 10884  20   23:0    26           
 10885  20   24:D     1         PROCEDURE OUCH;  (* P010E18 *)
 10886  20   24:D     1         
 10887  20   24:0     0           BEGIN
 10888  20   24:1     0             PRINTSTR( 'OUCH!');
 10889  20   24:1    11             ROCKWATR
 10890  20   24:0    11           END;
 10891  20   24:0    26           
 10892  20   24:0    26           
 10893  20   25:D     1         PROCEDURE DOSCNMSG;  (* P010E19 *)
 10894  20   25:D     1         
 10895  20   25:0     0           BEGIN
 10896  20   25:1     0             LLBASE04 := SQTYPE;
 10897  20   25:1     5             XGOTO := XSCNMSG;
 10898  20   25:1     8             XGOTO2 := XRUNNER;
 10899  20   25:1    11             EXIT( RUNNER)
 10900  20   25:0    15           END;  (* DOSCNMSG *)
 10901  20   25:0    28           
 10902  20   25:0    28           
 10903  20   26:D     1         PROCEDURE CHENCOUN;  (* P010E1A *)
 10904  20   26:D     1         
 10905  20   26:D     1           VAR
 10906  20   26:D     1                UNUSEDXX : INTEGER;
 10907  20   26:D     2                UNUSEDYY : INTEGER;
 10908  20   26:D     3         
 10909  20   26:0     0           BEGIN
 10910  20   26:1     0             IF MAZE.AUX0[ SQTYPE] = 0 THEN
 10911  20   26:2    14               EXIT( CHENCOUN);
 10912  20   26:1    18             IF NOT FIGHTMAP[ MAZEX][ MAZEY] THEN
 10913  20   26:2    33               EXIT( CHENCOUN);
 10914  20   26:1    37             MVCURSOR( 14, 12);
 10915  20   26:1    42             PRINTSTR( 'AN ENCOUNTER');
 10916  20   26:1    60             ENCB4RUN := FALSE;
 10917  20   26:1    63             ATTK012 := 2;
 10918  20   26:1    66             XGOTO := XCOMBAT;
 10919  20   26:1    69             ENEMYINX := MAZE.AUX2[ SQTYPE];
 10920  20   26:1    81             IF MAZE.AUX1[ SQTYPE] > 1 THEN
 10921  20   26:2    95               ENEMYINX := ENEMYINX + (RANDOM MOD MAZE.AUX1[ SQTYPE]);
 10922  20   26:1   116             IF MAZE.AUX0[ SQTYPE] > 0 THEN
 10923  20   26:2   130               BEGIN
 10924  20   26:3   130                 MAZE.AUX0[ SQTYPE] := MAZE.AUX0[ SQTYPE] - 1;
 10925  20   26:3   152                 IF MAZE.AUX0[ SQTYPE] = 0 THEN
 10926  20   26:4   166                   MAZE.SQRETYPE[ SQTYPE] := NORMAL;
 10927  20   26:3   178                 MOVELEFT( MAZE,  
 10928  20   26:3   182                           IOCACHE[ GETRECW( ZMAZE, MAZELEV - 1, SIZEOF( TMAZE))],
 10929  20   26:3   198                           SIZEOF( TMAZE));
 10930  20   26:2   203               END;
 10931  20   26:1   203             EXIT( RUNNER)
 10932  20   26:0   207           END;  (* CHENCOUN *)
 10933  20   26:0   220           
 10934  20   26:0   220           
 10935  20   27:D     1         PROCEDURE BUTTONS;  (* P010E1B *)
 10936  20   27:D     1         
 10937  20   27:D     1           VAR
 10938  20   27:D     1                MAXBUT   : INTEGER;
 10939  20   27:D     2                MINBUT   : INTEGER;
 10940  20   27:D     3                UNUSEDXX : INTEGER;
 10941  20   27:D     4                UNUSEDYY : INTEGER;
 10942  20   27:D     5                
 10943  20   27:0     0           BEGIN
 10944  20   27:1     0             MINBUT := MAZE.AUX2[ SQTYPE];
 10945  20   27:1    12             MAXBUT := MAZE.AUX1[ SQTYPE];
 10946  20   27:1    24             PRINTSTR( 'THERE ARE BUTTONS ON THE WALL');
 10947  20   27:1    59             MVCURSOR( 1, 12);
 10948  20   27:1    64             PRINTSTR( 'MARKED A THROUGH ');
 10949  20   27:1    87             PRINTCHR( CHR( ORD('A') + MAXBUT - MINBUT));
 10950  20   27:1    95             PRINTCHR( '.');
 10951  20   27:1    99             MVCURSOR( 1, 14);
 10952  20   27:1   104             PRINTSTR( 'PRESS ONE (OR RETURN TO LEAVE THEM)');
 10953  20   27:1   145             REPEAT
 10954  20   27:2   145               GETKEY
 10955  20   27:1   145             UNTIL (INCHAR = CHR( CRETURN)) OR 
 10956  20   27:1   151                   ( (INCHAR >= 'A') AND 
 10957  20   27:1   154                     (INCHAR <= CHR( ORD('A') + MAXBUT - MINBUT)));
 10958  20   27:1   165             CLRRECT( 1, 11, 38, 4);
 10959  20   27:1   172             IF INCHAR = CHR( CRETURN) THEN
 10960  20   27:2   177               EXIT( BUTTONS);
 10961  20   27:1   181             IF MAZE.AUX0[ SQTYPE] > 0 THEN
 10962  20   27:2   195               BEGIN
 10963  20   27:3   195                 MAZEX := RANDOM MOD 20;
 10964  20   27:3   204                 MAZEY := RANDOM MOD 20
 10965  20   27:2   209               END;
 10966  20   27:1   213             EXITRUN( MINBUT + ORD( INCHAR) - ORD( 'A'))
 10967  20   27:0   218           END;  (* BUTTONS *)
 10968  20   27:0   234           
 10969  20   27:0   234           
 10970  20   16:0     0         BEGIN  (* SPECSQAR *)
 10971  20   16:1     0           CLRRECT( 1, 11, 38, 4);
 10972  20   16:1     7           MVCURSOR( 1, 11);
 10973  20   16:1    12           SQTYPE := MAZE.SQREXTRA[ MAZEX][ MAZEY];
 10974  20   16:1    28           FIZZLES := 0;
 10975  20   16:1    31           NEEDDRMZ:= TRUE;
 10976  20   16:1    35           CASE MAZE.SQRETYPE[ SQTYPE] OF
 10977  20   16:1    46           
 10978  20   16:1    46               FIZZLE:  FIZZLES := 1;
 10979  20   16:1    51               
 10980  20   16:1    51             ROCKWATE:  BEGIN
 10981  20   16:3    51                          MAZELEV := -99;
 10982  20   16:3    55                          XGOTO := XNEWMAZE;
 10983  20   16:3    58                          EXIT( RUNNER)
 10984  20   16:2    62                        END;
 10985  20   16:2    64                        
 10986  20   16:1    64              BUTTONZ:  BUTTONS;
 10987  20   16:1    68              
 10988  20   16:1    68               STAIRS:  IF INITTURN THEN
 10989  20   16:3    73                          STAIRSYN;
 10990  20   16:3    77                          
 10991  20   16:1    77                  PIT:  IF INITTURN THEN
 10992  20   16:3    82                          APIT;
 10993  20   16:3    86                          
 10994  20   16:1    86                OUCHY:  OUCH;
 10995  20   16:1    90                
 10996  20   16:1    90                CHUTE:  ACHUTE;
 10997  20   16:1    94                
 10998  20   16:1    94              SPINNER:  IF INITTURN THEN
 10999  20   16:3    99                          SPINDIR;
 11000  20   16:1   103             TRANSFER:  QUIETXFR;
 11001  20   16:1   107             
 11002  20   16:1   107                 DARK:  VERYDARK;
 11003  20   16:1   111                 
 11004  20   16:1   111               SCNMSG:  DOSCNMSG;
 11005  20   16:1   115               
 11006  20   16:1   115             ENCOUNTE:  CHENCOUN;
 11007  20   16:1   119           END
 11008  20   16:0   150         END;   (* SPECSQAR *)
 11009  20   16:0   162       
 11010  20   16:0   162 
 11011  20   28:D     1     PROCEDURE UPDATEHP;  (* P010E1C *)
 11012  20   28:D     1     
 11013  20   28:D     1       VAR
 11014  20   28:D     1            UNUSEDXX : INTEGER;
 11015  20   28:D     2            CHARX    : INTEGER;
 11016  20   28:D     3            
 11017  20   28:0     0       BEGIN
 11018  20   28:1     0         FOR CHARX := 0 TO PARTYCNT - 1 DO
 11019  20   28:2    13           WITH CHARACTR[ CHARX] DO
 11020  20   28:3    20             BEGIN
 11021  20   28:3    20             
 11022  20   28:4    20               IF (RANDOM MOD 4) = 2 THEN
 11023  20   28:5    31                 HPLEFT := HPLEFT - LOSTXYL.POISNAMT[ 1] + HEALPTS;
 11024  20   28:4    52               IF HPLEFT <= 0 THEN
 11025  20   28:5    59                 BEGIN
 11026  20   28:6    59                   LOSTXYL.POISNAMT[ 1] := 0;
 11027  20   28:6    69                   IF STATUS < DEAD THEN
 11028  20   28:7    76                     BEGIN
 11029  20   28:8    76                       MVCURSOR( 1, 11);
 11030  20   28:8    81                       PRINTSTR( NAME);
 11031  20   28:8    85                       PRINTSTR( ' DIED');
 11032  20   28:8    96                       PAUSE2;
 11033  20   28:8    99                       CLRRECT( 1, 11, 38, 1);
 11034  20   28:8   106                       HPLEFT := 0;
 11035  20   28:8   111                       STATUS := DEAD;
 11036  20   28:8   116                       PRSTATS
 11037  20   28:7   116                     END
 11038  20   28:5   118                 END
 11039  20   28:4   118               ELSE
 11040  20   28:5   120                 IF HPLEFT > HPMAX THEN
 11041  20   28:6   129                   HPLEFT := HPMAX
 11042  20   28:3   132             END
 11043  20   28:0   136       END;  (* UPDATEHP *)
 11044  20   28:0   160       
 11045  20   28:0   160       
 11046  20   29:D     1       PROCEDURE MOVEFRWD;  (* P010E1D *)
 11047  20   29:D     1       
 11048  20   29:0     0         BEGIN
 11049  20   29:1     0           NEEDDRMZ := TRUE;
 11050  20   29:1     4           INITTURN := TRUE;
 11051  20   29:1     8           SAVEX    := MAZEX;
 11052  20   29:1    12           SAVEY    := MAZEY;
 11053  20   29:1    16           SAVELEV  := MAZELEV;
 11054  20   29:1    20           CASE DIRECTIO OF
 11055  20   29:1    24             NORTH:  MAZEY := MAZEY + 1;
 11056  20   29:1    32              EAST:  MAZEX := MAZEX + 1;
 11057  20   29:1    40             SOUTH:  MAZEY := MAZEY - 1;
 11058  20   29:1    48              WEST:  MAZEX := MAZEX - 1;
 11059  20   29:1    56           END;
 11060  20   29:1    72           MAZEY := (MAZEY + 20) MOD 20;
 11061  20   29:1    80           MAZEX := (MAZEX + 20) MOD 20
 11062  20   29:0    84         END;  (* MOVEFRWD *)
 11063  20   29:0   100         
 11064  20   29:0   100         
 11065  20   30:D     1       PROCEDURE BUMPWALL;  (* P010E1E *)
 11066  20   30:D     1       
 11067  20   30:0     0         BEGIN
 11068  20   30:1     0           CLRRECT( 4, 3, 5, 1);
 11069  20   30:1     7           MVCURSOR( 4, 3);
 11070  20   30:1    12           PRINTSTR( 'OUCH!');
 11071  20   30:1    23           WRITE( CHR( 7))
 11072  20   30:0    31         END;
 11073  20   30:0    44         
 11074  20   30:0    44         
 11075  20   31:D     1       PROCEDURE FORWRD;  (* P010E1F *)
 11076  20   31:D     1       
 11077  20   31:0     0         BEGIN
 11078  20   31:1     0           CASE DIRECTIO OF
 11079  20   31:1     4             NORTH:  IF MAZE.N[ MAZEX][ MAZEY] = OPEN THEN
 11080  20   31:3    22                       MOVEFRWD;
 11081  20   31:3    26                       
 11082  20   31:1    26              EAST:  IF MAZE.E[ MAZEX][ MAZEY] = OPEN THEN
 11083  20   31:3    43                       MOVEFRWD;
 11084  20   31:3    47                       
 11085  20   31:1    47             SOUTH:  IF MAZE.S[ MAZEX][ MAZEY] = OPEN THEN
 11086  20   31:3    64                       MOVEFRWD;
 11087  20   31:3    68                       
 11088  20   31:1    68              WEST:  IF MAZE.W[ MAZEX][ MAZEY] = OPEN THEN
 11089  20   31:3    85                       MOVEFRWD;
 11090  20   31:1    89           END;
 11091  20   31:1   104           IF NOT INITTURN THEN
 11092  20   31:2   110             BUMPWALL
 11093  20   31:0   110         END;  (* FORWRD *)
 11094  20   31:0   124         
 11095  20   31:0   124         
 11096  20   32:D     1       PROCEDURE KICK;  (* P010E20 *)
 11097  20   32:D     1       
 11098  20   32:0     0         BEGIN
 11099  20   32:1     0           CASE DIRECTIO OF
 11100  20   32:1     4             NORTH:  IF MAZE.N[ MAZEX][ MAZEY] <> WALL THEN
 11101  20   32:3    22                       MOVEFRWD;
 11102  20   32:3    26                       
 11103  20   32:1    26              EAST:  IF MAZE.E[ MAZEX][ MAZEY] <> WALL THEN
 11104  20   32:3    43                       MOVEFRWD;
 11105  20   32:3    47                       
 11106  20   32:1    47             SOUTH:  IF MAZE.S[ MAZEX][ MAZEY] <> WALL THEN
 11107  20   32:3    64                       MOVEFRWD;
 11108  20   32:3    68                       
 11109  20   32:1    68              WEST:  IF MAZE.W[ MAZEX][ MAZEY] <> WALL THEN
 11110  20   32:3    85                       MOVEFRWD;
 11111  20   32:1    89           END;
 11112  20   32:1   104           IF NOT INITTURN THEN
 11113  20   32:2   110             BUMPWALL
 11114  20   32:0   110         END;  (* KICK *)
 11115  20   32:0   124         
 11116  20   32:0   124         
 11117  20   33:D     1       PROCEDURE DOTURN( LEFTRIGH: INTEGER);  (* P010E21 *)
 11118  20   33:D     2       
 11119  20   33:0     0         BEGIN
 11120  20   33:1     0           NEEDDRMZ := TRUE;
 11121  20   33:1     4           DIRECTIO := (DIRECTIO + LEFTRIGH) MOD 4
 11122  20   33:0     8         END;
 11123  20   33:0    24         
 11124  20   33:0    24         
 11125  20   34:D     1       PROCEDURE SETTIME;  (* P010E22 *)
 11126  20   34:D     1       
 11127  20   34:D     1         VAR
 11128  20   34:D     1              TIMEVAL : INTEGER;
 11129  20   34:D     2              TIMESTR : STRING;
 11130  20   34:D    43       
 11131  20   35:D     1         PROCEDURE EXITTIME;  (* P010E23 *)
 11132  20   35:D     1         
 11133  20   35:0     0           BEGIN
 11134  20   35:1     0             CLRRECT( 1, 13, 38, 1);
 11135  20   35:1     7             EXIT( SETTIME)
 11136  20   35:0    11           END;
 11137  20   35:0    24           
 11138  20   35:0    24           
 11139  20   34:0     0         BEGIN  (* SETTIME *)
 11140  20   34:1     0           MVCURSOR( 1, 13);
 11141  20   34:1     5           PRINTSTR( 'NEW DELAY (1-5000) >');
 11142  20   34:1    31           GETSTR( TIMESTR, 21, 13);
 11143  20   34:1    38           TIMEVAL := 0;
 11144  20   34:1    41           IF LENGTH( TIMESTR) > 4 THEN
 11145  20   34:2    49             EXITTIME;
 11146  20   34:1    51           FOR LLBASE04 := 1 TO LENGTH( TIMESTR) DO
 11147  20   34:2    66             IF (TIMESTR[ LLBASE04] >= '0') AND
 11148  20   34:2    72                (TIMESTR[ LLBASE04] <= '9') THEN
 11149  20   34:3    81               TIMEVAL := 10 * TIMEVAL + ORD( TIMESTR[ LLBASE04]) - ORD( '0')
 11150  20   34:2    90             ELSE
 11151  20   34:3    95               EXITTIME;
 11152  20   34:1   104           IF (TIMEVAL > 0) AND
 11153  20   34:1   107              (TIMEVAL <= 5000) THEN
 11154  20   34:2   115                TIMEDLAY := TIMEVAL;
 11155  20   34:1   118           EXITTIME
 11156  20   34:0   118         END;  (* SETTIME *)
 11157  20   34:0   134         
 11158  20   34:0   134         
 11159  20   36:D     1       PROCEDURE QUIKPLOT;  (* P010E24 *)
 11160  20   36:D     1       
 11161  20   36:0     0         BEGIN
 11162  20   36:1     0           MVCURSOR( 1, 13);
 11163  20   36:1     5           PRINTSTR( 'QUICK PLOT ');
 11164  20   36:1    22           QUICKPLT := NOT QUICKPLT;
 11165  20   36:1    29           IF QUICKPLT THEN
 11166  20   36:2    34             PRINTSTR( 'ON')
 11167  20   36:1    39           ELSE
 11168  20   36:2    44             PRINTSTR( 'OFF');
 11169  20   36:1    53           DRAWMAZE;
 11170  20   36:1    55           CLRRECT( 1, 13, 38, 1)
 11171  20   36:0    59         END;
 11172  20   36:0    74         
 11173  20   36:0    74         
 11174  20   37:D     1       PROCEDURE RUNINIT;  (* P010E25 *)
 11175  20   37:D     1       
 11176  20   37:0     0         BEGIN
 11177  20   37:1     0           CLRRECT( 13, 1, 26, 4);
 11178  20   37:1     7           CLRRECT( 13, 6, 26, 4);
 11179  20   37:1    14           MVCURSOR( 13, 1);
 11180  20   37:1    19           PRINTSTR( 'F)ORWARD  C)AMP    S)TATUS');
 11181  20   37:1    51           MVCURSOR( 13, 2);
 11182  20   37:1    56           PRINTSTR( 'L)EFT     Q)UICK   A<-W->D');
 11183  20   37:1    88           MVCURSOR( 13, 3);
 11184  20   37:1    93           PRINTSTR( 'R)IGHT    T)IME    CLUSTER');
 11185  20   37:1   125           MVCURSOR( 13, 4);
 11186  20   37:1   130           PRINTSTR( 'K)ICK     I)NSPECT');
 11187  20   37:1   154           MVCURSOR( 13, 7);
 11188  20   37:1   159           PRINTSTR( 'SPELLS :');
 11189  20   37:1   173           GRAPHICS;
 11190  20   37:1   176           PRSTATS;
 11191  20   37:1   178           NEEDDRMZ := TRUE;
 11192  20   37:1   182           INITTURN := TRUE
 11193  20   37:0   182         END;  (* RUNINIT *)
 11194  20   37:0   198     
 11195  20   37:0   198     
 11196  20   14:0     0       BEGIN (* RUNMAIN *)
 11197  20   14:1     0         RUNINIT;
 11198  20   14:1     2         REPEAT
 11199  20   14:2     2           MVCURSOR( 22, 7);
 11200  20   14:2     7           IF LIGHT > 0 THEN
 11201  20   14:3    12             PRINTSTR( 'LIGHT')
 11202  20   14:2    20           ELSE
 11203  20   14:3    25             PRINTSTR( '     ');
 11204  20   14:3    36             
 11205  20   14:2    36           MVCURSOR( 22, 8);
 11206  20   14:2    41           IF ACMOD2 > 0 THEN
 11207  20   14:3    46             PRINTSTR( 'PROTECT')
 11208  20   14:2    56           ELSE
 11209  20   14:3    61             PRINTSTR( '       ');
 11210  20   14:3    74             
 11211  20   14:2    74           IF NEEDDRMZ THEN
 11212  20   14:3    79             DRAWMAZE;
 11213  20   14:2    81           IF MAZE.SQRETYPE[ MAZE.SQREXTRA[ MAZEX][ MAZEY]] <> NORMAL THEN
 11214  20   14:3   107             IF XGOTO2 <> XSCNMSG THEN
 11215  20   14:4   112               IF INITTURN THEN
 11216  20   14:5   117                 SPECSQAR;
 11217  20   14:2   119           IF XGOTO2 <> XSCNMSG THEN
 11218  20   14:3   124             IF INITTURN THEN
 11219  20   14:4   129               CLRRECT( 1, 11, 38, 4);
 11220  20   14:2   136           XGOTO2 := XRUNNER;
 11221  20   14:2   139           NEEDDRMZ := FALSE;
 11222  20   14:2   143           
 11223  20   14:2   143           IF (((RANDOM MOD 99) = 35)      OR
 11224  20   14:2   152               (CHSTALRM = 1)              OR
 11225  20   14:2   156               (FIGHTMAP[ MAZEX][ MAZEY])) OR
 11226  20   14:2   169              
 11227  20   14:2   169              (INITTURN AND (INCHAR = CHR( 75)) AND
 11228  20   14:2   176              (MAZE.FIGHTS[ MAZEX][ MAZEY] = 1)) AND
 11229  20   14:2   193              ((RANDOM MOD 8) = 3)
 11230  20   14:2   202           THEN
 11231  20   14:3   206             ENCOUNTR;
 11232  20   14:3   208             
 11233  20   14:2   208           IF INITTURN THEN
 11234  20   14:3   213             UPDATEHP;
 11235  20   14:2   215           INITTURN := FALSE;
 11236  20   14:2   219           
 11237  20   14:2   219           GETKEY;
 11238  20   14:2   222           CASE INCHAR OF
 11239  20   14:2   225           
 11240  20   14:2   225             'F', 'W':  FORWRD;
 11241  20   14:2   229             
 11242  20   14:2   229             'A', 'L':  DOTURN( 3);
 11243  20   14:2   234             
 11244  20   14:2   234             'D', 'R':  DOTURN( 1);
 11245  20   14:2   239             
 11246  20   14:2   239                  'K':  KICK;
 11247  20   14:2   243                  
 11248  20   14:2   243                  'S':  PRSTATS;
 11249  20   14:2   247                  
 11250  20   14:2   247                  'T':  SETTIME;
 11251  20   14:2   251                  
 11252  20   14:2   251                  'Q':  QUIKPLOT;
 11253  20   14:2   255                  
 11254  20   14:2   255                  'C':  BEGIN
 11255  20   14:4   255                          XGOTO := XINSPCT2;
 11256  20   14:4   258                          WRITE( CHR( 12));
 11257  20   14:4   266                          EXIT( RUNNER)
 11258  20   14:3   270                        END;
 11259  20   14:3   272                        
 11260  20   14:2   272                  'I':  BEGIN
 11261  20   14:4   272                          XGOTO := XINSAREA;
 11262  20   14:4   275                          WRITE( CHR( 12));
 11263  20   14:4   283                          EXIT( RUNNER)
 11264  20   14:3   287                        END;
 11265  20   14:2   289           END
 11266  20   14:1   342         UNTIL FALSE
 11267  20   14:0   342       END;  (* RUNMAIN *)
 11268  20   14:0   360       
 11269  20   14:0   360       
 11270  20   38:D     1     PROCEDURE CLROOMFG( XLOOP: INTEGER;  (* P010026 *)
 11271  20   38:D     2                         YLOOP: INTEGER);
 11272  20   38:D     3     
 11273  20   38:D     3            
 11274  20   38:0     0       BEGIN  (* CLROOMFG *)
 11275  20   38:1     0         XLOOP := (XLOOP + 20) MOD 20;
 11276  20   38:1     7         YLOOP := (YLOOP + 20) MOD 20;
 11277  20   38:1    14         IF NOT FIGHTMAP[ XLOOP][ YLOOP] THEN
 11278  20   38:2    27           EXIT( CLROOMFG);
 11279  20   38:2    31           
 11280  20   38:1    31         FIGHTMAP[ XLOOP][ YLOOP] := FALSE;
 11281  20   38:1    42         
 11282  20   38:1    42         IF MAZE.N[ XLOOP][ YLOOP] = OPEN THEN
 11283  20   38:2    58           CLROOMFG( XLOOP, YLOOP + 1);
 11284  20   38:1    64         IF MAZE.E[ XLOOP][ YLOOP] = OPEN THEN
 11285  20   38:2    79           CLROOMFG( XLOOP + 1, YLOOP);
 11286  20   38:1    85         IF MAZE.S[ XLOOP][ YLOOP] = OPEN THEN
 11287  20   38:2   100           CLROOMFG( XLOOP, YLOOP - 1);
 11288  20   38:1   106         IF MAZE.W[ XLOOP][ YLOOP] = OPEN THEN
 11289  20   38:2   121           CLROOMFG( XLOOP - 1, YLOOP);
 11290  20   38:0   127       END;   (* CLROOMFG *)
 11291  20   38:0   140       
 11292  20   38:0   140       
 11293  20   38:0   140       
 11294  20    1:0     0     BEGIN  (* RUNNER *)
 11295  20    1:1     0       QUICKPLT := FALSE;
 11296  20    1:1     3       READMAZE;
 11297  20    1:1     5       CLROOMFG( MAZEX, MAZEY);
 11298  20    1:1    11       REPEAT
 11299  20    1:2    11         RUNMAIN
 11300  20    1:1    11       UNTIL FALSE
 11301  20    1:0    13     END;
 11302  20    1:0    30   
 11303  20    1:0    30 (*$I WIZ1C:RUNNER2   *)
 11304  20    1:0    30 
 11305  20    1:0    30 (* ---------- END SEGMENTS ---------------------- *)
 11306  20    1:0    30 
 11306  20    1:0    30 (*$I WIZ1A:WIZ2.TEXT *)
 11307  20    1:0    30 
 11308   1    2:D     1   PROCEDURE PRINTBEL;  (* P010002 *)
 11309   1    2:D     1   
 11310   1    2:0     0     BEGIN
 11311   1    2:1     0       WRITE( CHR( 7));
 11312   1    2:1     8       WRITE( CHR( 7));
 11313   1    2:1    16       WRITE( CHR( 7))
 11314   1    2:0    24     END;
 11315   1    2:0    36 
 11316   1    2:0    36 
 11317   1    3:D     3   FUNCTION GETREC;  (* P010003 *)
 11318   1    3:D     6   
 11319   1    3:D     6     VAR
 11320   1    3:D     6          BUFFADDR : INTEGER;
 11321   1    3:D     7          DSKBLOCK : INTEGER;
 11322   1    3:D     8                         
 11323   1    3:0     0     BEGIN
 11324   1    3:1     0       DSKBLOCK := SCNTOC.BLOFF[ DATATYPE] +
 11325   1    3:1     7                   2 *  (DATAINDX DIV SCNTOC.RECPER2BL[ DATATYPE]);
 11326   1    3:1    21       BUFFADDR := DATASIZE * (DATAINDX MOD SCNTOC.RECPER2BL[ DATATYPE]);
 11327   1    3:1    34       IF CACHEBL <> DSKBLOCK THEN
 11328   1    3:2    39         BEGIN
 11329   1    3:3    39           IF CACHEWRI THEN
 11330   1    3:4    42             REPEAT
 11331   1    3:5    42               UNITWRITE( DRIVE1, IOCACHE, SIZEOF( IOCACHE),
 11332   1    3:5    50                          (CACHEBL + SCNTOCBL), 0)
 11333   1    3:4    56             UNTIL IORESULT = 0;
 11334   1    3:3    62           CACHEWRI := FALSE;
 11335   1    3:3    65           CACHEBL := DSKBLOCK;
 11336   1    3:3    68           REPEAT
 11337   1    3:4    68             UNITREAD( DRIVE1, IOCACHE, SIZEOF( IOCACHE),
 11338   1    3:4    76                       (CACHEBL + SCNTOCBL), 0)
 11339   1    3:3    82           UNTIL IORESULT = 0
 11340   1    3:2    84         END;
 11341   1    3:1    88       GETREC := BUFFADDR
 11342   1    3:0    88     END;
 11343   1    3:0   108          
 11344   1    3:0   108 
 11345   1    4:D     3   FUNCTION GETRECW;  (* P010004 *)
 11346   1    4:D     6     
 11347   1    4:D     6     VAR
 11348   1    4:D     6          BUFFADDR : INTEGER;
 11349   1    4:D     7          DSKBLOCK : INTEGER;
 11350   1    4:D     8                         
 11351   1    4:0     0     BEGIN
 11352   1    4:0     0     
 11353   1    4:1     0       DSKBLOCK := SCNTOC.BLOFF[ DATATYPE] +
 11354   1    4:1     7                   2 *  (DATAINDX DIV SCNTOC.RECPER2BL[ DATATYPE]);
 11355   1    4:1    21       BUFFADDR := DATASIZE * (DATAINDX MOD SCNTOC.RECPER2BL[ DATATYPE]);
 11356   1    4:1    34       IF CACHEBL <> DSKBLOCK THEN
 11357   1    4:2    39         BEGIN
 11358   1    4:3    39           IF CACHEWRI THEN
 11359   1    4:4    42             REPEAT
 11360   1    4:5    42               UNITWRITE( DRIVE1, IOCACHE, SIZEOF( IOCACHE),
 11361   1    4:5    50                          (CACHEBL + SCNTOCBL), 0)
 11362   1    4:4    56             UNTIL IORESULT = 0;
 11363   1    4:3    62           CACHEBL := DSKBLOCK;
 11364   1    4:3    65           REPEAT
 11365   1    4:4    65             UNITREAD( DRIVE1, IOCACHE, SIZEOF( IOCACHE),
 11366   1    4:4    73                       (CACHEBL + SCNTOCBL), 0)
 11367   1    4:3    79           UNTIL IORESULT = 0;
 11368   1    4:2    85         END;
 11369   1    4:1    85       CACHEWRI := TRUE;
 11370   1    4:1    88       GETRECW := BUFFADDR
 11371   1    4:0    88     END;
 11372   1    4:0   108     
 11373   1    4:0   108     
 11374   1    5:D     1   PROCEDURE ADDLONGS;  (* P010005 *)
 11375   1    5:D     3   
 11376   1    5:0     0     BEGIN
 11377   1    5:1     0       FIRST.LOW := FIRST.LOW + SECOND.LOW;
 11378   1    5:1     7       IF FIRST.LOW >= 10000 THEN
 11379   1    5:2    15         BEGIN
 11380   1    5:3    15           FIRST.MID := FIRST.MID + 1;
 11381   1    5:3    23           FIRST.LOW := FIRST.LOW - 10000
 11382   1    5:2    26         END;
 11383   1    5:2    31         
 11384   1    5:1    31       FIRST.MID := FIRST.MID + SECOND.MID;
 11385   1    5:1    40       IF FIRST.MID >= 10000 THEN
 11386   1    5:2    48         BEGIN
 11387   1    5:3    48           FIRST.HIGH := FIRST.HIGH + 1;
 11388   1    5:3    56           FIRST.MID := FIRST.MID - 10000
 11389   1    5:2    61         END;
 11390   1    5:2    66         
 11391   1    5:1    66       FIRST.HIGH := FIRST.HIGH + SECOND.HIGH;
 11392   1    5:1    75       IF FIRST.HIGH >= 10000 THEN
 11393   1    5:2    83         BEGIN
 11394   1    5:3    83           FIRST.HIGH := 9999;
 11395   1    5:3    90           FIRST.MID  := 9999;
 11396   1    5:3    97           FIRST.LOW  := 9999
 11397   1    5:2    98         END
 11398   1    5:0   102     END;
 11399   1    5:0   114     
 11400   1    5:0   114     
 11401   1    6:D     1   PROCEDURE SUBLONGS;  (* P010006 *)
 11402   1    6:D     3   
 11403   1    6:0     0     BEGIN
 11404   1    6:1     0       FIRST.LOW := FIRST.LOW - SECOND.LOW;
 11405   1    6:1     7       IF FIRST.LOW < 0 THEN
 11406   1    6:2    13         BEGIN
 11407   1    6:3    13           FIRST.MID := FIRST.MID - 1;
 11408   1    6:3    21           FIRST.LOW := FIRST.LOW + 10000
 11409   1    6:2    24         END;
 11410   1    6:2    29       
 11411   1    6:1    29       FIRST.MID := FIRST.MID - SECOND.MID;
 11412   1    6:1    38       IF FIRST.MID < 0 THEN
 11413   1    6:2    44         BEGIN
 11414   1    6:3    44           FIRST.HIGH := FIRST.HIGH - 1;
 11415   1    6:3    52           FIRST.MID := FIRST.MID + 10000
 11416   1    6:2    57         END;
 11417   1    6:2    62         
 11418   1    6:1    62       FIRST.HIGH := FIRST.HIGH - SECOND.HIGH;
 11419   1    6:1    71       IF FIRST.HIGH < 0 THEN
 11420   1    6:2    77         BEGIN
 11421   1    6:3    77           FIRST.HIGH := 0;
 11422   1    6:3    82           FIRST.MID  := 0;
 11423   1    6:3    87           FIRST.LOW  := 0
 11424   1    6:2    88         END
 11425   1    6:0    90     END;
 11426   1    6:0   102 
 11427   1    6:0   102 
 11428   1    8:D     1   PROCEDURE LONG2BCD;  (* P010008 *)
 11429   1    8:D     3   
 11430   1    8:D     3     VAR
 11431   1    8:D     3          DIGITX : INTEGER;
 11432   1    8:D     4   
 11433   1    8:D     4   
 11434   1   33:D     1     PROCEDURE INT2BCD( PARTLONG: INTEGER);  (* P010021 *)
 11435   1   33:D     2     
 11436   1   34:D     1       PROCEDURE PUTDIGIT( POWOF10: INTEGER);  (* P010022 *)
 11437   1   34:D     2       
 11438   1   34:0     0         BEGIN
 11439   1   34:1     0           BCDNUM[ DIGITX] := PARTLONG DIV POWOF10;
 11440   1   34:1    14           DIGITX := DIGITX + 1;
 11441   1   34:1    22           PARTLONG := PARTLONG MOD POWOF10
 11442   1   34:0    25         END;
 11443   1   34:0    42     
 11444   1   34:0    42     
 11445   1   33:0     0       BEGIN  (* INT2BCD *)
 11446   1   33:1     0         PUTDIGIT( 1000);
 11447   1   33:1     5         PUTDIGIT(  100);
 11448   1   33:1     8         PUTDIGIT(   10);
 11449   1   33:1    11         PUTDIGIT(    1)
 11450   1   33:0    12       END;   (* INT2BCD *)
 11451   1   33:0    26       
 11452   1   33:0    26       
 11453   1    8:0     0     BEGIN  (* LONG2BCD *)
 11454   1    8:1     0       BCDNUM[ 0] := 0;
 11455   1    8:1     6       DIGITX := 1;
 11456   1    8:1     9       INT2BCD( LONGNUM.HIGH);
 11457   1    8:1    13       INT2BCD( LONGNUM.MID);
 11458   1    8:1    17       INT2BCD( LONGNUM.LOW)
 11459   1    8:0    19     END;  (* LONG2BCD *)
 11460   1    8:0    34 
 11461   1    8:0    34 
 11462   1    7:D     1   PROCEDURE BCD2LONG;  (* P010007 *)
 11463   1    7:D     3   
 11464   1    7:D     3     VAR
 11465   1    7:D     3          DIGITX : INTEGER;
 11466   1    7:D     4   
 11467   1    7:D     4   
 11468   1   35:D     1     PROCEDURE BCD2INT( VAR LONGPART: INTEGER);  (* P010023 *)
 11469   1   35:D     2   
 11470   1   35:D     2   
 11471   1   36:D     1       PROCEDURE GETDIGIT;  (* P010024 *)
 11472   1   36:D     1       
 11473   1   36:0     0         BEGIN
 11474   1   36:1     0           LONGPART := (10 * LONGPART) + BCDNUM[ DIGITX];
 11475   1   36:1    20           DIGITX := DIGITX + 1
 11476   1   36:0    23         END;
 11477   1   36:0    40         
 11478   1   36:0    40         
 11479   1   35:0     0       BEGIN  (* BCD2INT *)
 11480   1   35:1     0         LONGPART := 0;
 11481   1   35:1     3         GETDIGIT;
 11482   1   35:1     5         GETDIGIT;
 11483   1   35:1     7         GETDIGIT;
 11484   1   35:1     9         GETDIGIT
 11485   1   35:0     9       END;
 11486   1   35:0    24       
 11487   1   35:0    24       
 11488   1    7:0     0     BEGIN  (* BCD2LONG *)
 11489   1    7:1     0       FILLCHAR( LONGNUM, 6, 0);
 11490   1    7:1     6       DIGITX := 1;
 11491   1    7:1     9       BCD2INT( LONGNUM.HIGH);
 11492   1    7:1    14       BCD2INT( LONGNUM.MID);
 11493   1    7:1    19       BCD2INT( LONGNUM.LOW)
 11494   1    7:0    20     END;  (* BCD2LONG *)
 11495   1    7:0    34 
 11496   1    7:0    34 
 11497   1    9:D     1   PROCEDURE MULTLONG;  (* P010009 *)
 11498   1    9:D     3   
 11499   1    9:D     3     VAR
 11500   1    9:D     3          UNUSEDXX : INTEGER;
 11501   1    9:D     4          UNUSEDYY : INTEGER;
 11502   1    9:D     5          DIGITX   : INTEGER;
 11503   1    9:D     6          BCDNUM   : TBCD;
 11504   1    9:D    20          
 11505   1    9:0     0     BEGIN
 11506   1    9:1     0       LONG2BCD( LONGNUM, BCDNUM);
 11507   1    9:1     5       FOR DIGITX := 12 DOWNTO 1 DO
 11508   1    9:2    17         BCDNUM[ DIGITX] := BCDNUM[ DIGITX] * INTNUM;
 11509   1    9:1    39       FOR DIGITX := 12 DOWNTO 1 DO
 11510   1    9:2    51         IF BCDNUM[ DIGITX] > 9 THEN
 11511   1    9:3    61           BEGIN
 11512   1    9:4    61             BCDNUM[ DIGITX - 1] := BCDNUM[ DIGITX - 1] +
 11513   1    9:4    76                                    BCDNUM[ DIGITX] DIV 10;
 11514   1    9:4    86             BCDNUM[ DIGITX] := BCDNUM[ DIGITX] MOD 10
 11515   1    9:3    97           END;
 11516   1    9:1   107       BCD2LONG( LONGNUM, BCDNUM)
 11517   1    9:0   110     END;  (* MULTLONG *)
 11518   1    9:0   128 
 11519   1    9:0   128 
 11520   1   10:D     1   PROCEDURE DIVLONG;  (* P01000A *)
 11521   1   10:D     3 
 11522   1   10:D     3     VAR
 11523   1   10:D     3          NXTDIGIT : INTEGER;
 11524   1   10:D     4          DIGITX   : INTEGER;
 11525   1   10:D     5          BCDNUM   : TBCD;
 11526   1   10:D    19 
 11527   1   10:0     0     BEGIN
 11528   1   10:1     0       LONG2BCD( LONGNUM, BCDNUM);
 11529   1   10:1     5       FOR DIGITX := 1 TO 12 DO
 11530   1   10:2    17         BEGIN
 11531   1   10:3    17           NXTDIGIT := BCDNUM[ DIGITX] DIV INTNUM;
 11532   1   10:3    28           BCDNUM[ DIGITX + 1] := BCDNUM[ DIGITX + 1] + 
 11533   1   10:3    43                                  (10 * (BCDNUM[ DIGITX] - NXTDIGIT * INTNUM));
 11534   1   10:3    58           BCDNUM[ DIGITX] := NXTDIGIT
 11535   1   10:2    63         END;
 11536   1   10:1    72       BCD2LONG( LONGNUM, BCDNUM)
 11537   1   10:0    75     END;  (* DIVLONG *)
 11538   1   10:0    92 
 11539   1   10:0    92 
 11540   1   11:D     3   FUNCTION TESTLONG;  (* P01000B *)
 11541   1   11:D    11                     
 11542   1   37:D     1     PROCEDURE LTEQGT( FIRSTX:  INTEGER;  (* P01002E *)
 11543   1   37:D     2                       SECONDX: INTEGER);
 11544   1   37:D     3     
 11545   1   37:0     0       BEGIN
 11546   1   37:1     0         IF FIRSTX = SECONDX THEN
 11547   1   37:2     5           EXIT( LTEQGT)
 11548   1   37:1     9         ELSE
 11549   1   37:2    11           BEGIN
 11550   1   37:3    11             IF FIRSTX > SECONDX THEN
 11551   1   37:4    16               TESTLONG := 1
 11552   1   37:3    16             ELSE
 11553   1   37:4    22               TESTLONG := -1
 11554   1   37:2    22           END;
 11555   1   37:1    27         EXIT( TESTLONG)
 11556   1   37:0    31       END; (* LTEQGT *)
 11557   1   37:0    44       
 11558   1   37:0    44   
 11559   1   11:0     0     BEGIN  (* TESTLONG *)
 11560   1   11:1     0       LTEQGT( FIRST.HIGH, SECOND.HIGH);
 11561   1   11:1    14       LTEQGT( FIRST.MID,  SECOND.MID);
 11562   1   11:1    18       LTEQGT( FIRST.LOW,  SECOND.LOW);
 11563   1   11:1    22       TESTLONG := 0
 11564   1   11:0    22     END;
 11565   1   11:0    38 
 11566   1   11:0    38 
 11567   1   12:D     1   PROCEDURE PRNTLONG;  (* P01000C *)
 11568   1   12:D     5                      
 11569   1   12:D     5     VAR
 11570   1   12:D     5          BCDNUM   : TBCD;
 11571   1   12:D    19          NONSPCX  : INTEGER;
 11572   1   12:D    20          LEADSPCX : INTEGER;
 11573   1   12:D    21   
 11574   1   12:0     0     BEGIN
 11575   1   12:1     0       LONG2BCD( LONGNUM, BCDNUM);
 11576   1   12:1    11       LEADSPCX := 1;
 11577   1   12:1    14       WHILE (LEADSPCX < 12) AND (BCDNUM[ LEADSPCX] = 0) DO
 11578   1   12:2    30         BEGIN
 11579   1   12:3    30           LEADSPCX := LEADSPCX + 1;
 11580   1   12:3    36           WRITE( ' ')
 11581   1   12:2    44         END;
 11582   1   12:1    46       FOR NONSPCX := LEADSPCX TO 12 DO
 11583   1   12:2    60         WRITE(  BCDNUM[ NONSPCX] : 1)
 11584   1   12:0    74     END;  (* PRNTLONG *)
 11585   1   12:0    98 
 11586   1   12:0    98 
 11587   1   13:D     1   PROCEDURE GETKEY;  (* P01000D *)
 11588   1   13:D     1   
 11589   1   13:D     1     CONST
 11590   1   13:D     1          SYSTERM = 2;
 11591   1   13:D     1          
 11592   1   13:D     1     VAR
 11593   1   13:D     1          INBUF : PACKED ARRAY[ 0..1] OF CHAR;
 11594   1   13:D     2   
 11595   1   13:D     2   
 11596   1   13:0     0     BEGIN
 11597   1   13:1     0       MVCURSOR( 80, 0);  (* ADJUST RANDOM #, AND RETURN WHEN A CHAR IS AVAIL *)
 11598   1   13:1     4       UNITREAD( SYSTERM, INBUF, 1, 0, 0);
 11599   1   13:1    13       INCHAR := INBUF[ 0];
 11600   1   13:1    19       IF EOLN THEN
 11601   1   13:2    29         INCHAR := CHR( CRETURN)
 11602   1   13:0    30     END;  (* GETKEY *)
 11603   1   13:0    44 
 11604   1   13:0    44 
 11605   1   14:D     1   PROCEDURE GETLINE;  (* P01000E *)
 11606   1   14:D     2   
 11607   1   14:D     2     VAR
 11608   1   14:D     2          IPOS : INTEGER;
 11609   1   14:D     3          
 11610   1   14:0     0     BEGIN
 11611   1   14:1     0       IPOS := 0;
 11612   1   14:1     3       REPEAT
 11613   1   14:2     3         GETKEY;
 11614   1   14:2     5         IF (INCHAR >= CHR( 32)) AND
 11615   1   14:2     8            (INCHAR <= CHR( 90)) AND
 11616   1   14:2    12            (IPOS < 40) THEN
 11617   1   14:3    18           BEGIN
 11618   1   14:4    18              IPOS:= IPOS + 1;
 11619   1   14:4    23             GTSTRING[ IPOS] := INCHAR;
 11620   1   14:4    27             WRITE( INCHAR)
 11621   1   14:3    35           END
 11622   1   14:2    35         ELSE
 11623   1   14:3    37           BEGIN
 11624   1   14:4    37             IF INCHAR = CHR( 8) THEN
 11625   1   14:5    42               BEGIN
 11626   1   14:6    42                 IF IPOS > 0 THEN
 11627   1   14:7    47                   BEGIN
 11628   1   14:8    47                     WRITE( INCHAR);
 11629   1   14:8    55                     WRITE( ' ');
 11630   1   14:8    63                     WRITE( INCHAR);
 11631   1   14:8    71                     IPOS := IPOS -1
 11632   1   14:7    72                   END;
 11633   1   14:5    76               END;
 11634   1   14:3    76           END;
 11635   1   14:1    76       UNTIL INCHAR = CHR( CRETURN);
 11636   1   14:1    81       GTSTRING[ 0] := CHR( IPOS)
 11637   1   14:0    84     END;
 11638   1   14:0   100     
 11639   1   14:0   100     
 11640   1   15:D     3    FUNCTION GETCHARX;  (* P01000F *)
 11641   1   15:D    46   
 11642   1   15:0     0     BEGIN
 11643   1   15:1     0       GOTOXY( 0, 18);
 11644   1   15:1    10       WRITE( CHR( 11));
 11645   1   15:1    18       IF DSPNAMES THEN
 11646   1   15:2    21         BEGIN
 11647   1   15:3    21           FOR LLBASE04 := 0 TO PARTYCNT - 1 DO
 11648   1   15:4    35             BEGIN
 11649   1   15:5    35               GOTOXY( 20 * (LLBASE04 MOD 2), 20 + (LLBASE04 DIV 2));
 11650   1   15:5    48               WRITE( LLBASE04 + 1 :1);
 11651   1   15:5    58               WRITE( ') ' );
 11652   1   15:5    70               WRITE( CHARACTR[ LLBASE04].NAME);
 11653   1   15:4    82             END;
 11654   1   15:2    89         END;
 11655   1   15:1    89       REPEAT
 11656   1   15:2    89         GOTOXY( 0, 18);
 11657   1   15:2    94         WRITE( CHR( 29));
 11658   1   15:2   102         WRITE( SOLICIT);
 11659   1   15:2   111         WRITE( ' ([RETURN] EXITS) >');
 11660   1   15:2   140         GETKEY;
 11661   1   15:2   142         LLBASE04 := ORD( INCHAR) - ORD( '0');
 11662   1   15:1   147       UNTIL ((LLBASE04 > 0) AND (LLBASE04 <= PARTYCNT)) OR
 11663   1   15:1   154             (INCHAR = CHR( 13));
 11664   1   15:1   160       IF INCHAR = CHR( CRETURN) THEN
 11665   1   15:2   165         LLBASE04 := 0;
 11666   1   15:1   168       GETCHARX := LLBASE04 - 1
 11667   1   15:0   169     END;
 11668   1   15:0   190   
 11669   1   15:0   190   
 11670   1   17:D     1   PROCEDURE PAUSE1;   (* P010011 *)
 11671   1   17:D     1   
 11672   1   17:0     0     BEGIN
 11673   1   17:1     0       FOR LLBASE04 := 0 TO TIMEDLAY DO
 11674   1   17:2    11         BEGIN
 11675   1   17:2    11         END;
 11676   1   17:0    18     END;
 11677   1   17:0    32     
 11678   1   17:0    32     
 11679   1   18:D     1   PROCEDURE PAUSE2;   (* P010012 *)
 11680   1   18:D     1   
 11681   1   18:0     0     BEGIN
 11682   1   18:1     0       FOR LLBASE04 := 0 TO 3000 DO
 11683   1   18:2    13         BEGIN
 11684   1   18:2    13         END
 11685   1   18:0    13     END;
 11686   1   18:0    34     
 11687   1   18:0    34     
 11688   1   16:D     1   PROCEDURE CENTSTR;  (* P010010 *)
 11689   1   16:D    43   
 11690   1   16:0     0     BEGIN
 11691   1   16:1     0       GOTOXY( 20 - (LENGTH( ASTRING) DIV 2), 23);
 11692   1   16:1    17       WRITE( ASTRING);
 11693   1   16:1    26       GOTOXY( 41, 0);
 11694   1   16:1    31       PAUSE2
 11695   1   16:0    31     END;
 11696   1   16:0    46     
 11697   1   16:0    46     
 11698   1   19:D     1   PROCEDURE CLEARPIC;  (* P010013 *)
 11699   1   19:D     1   
 11700   1   19:0     0     BEGIN
 11701   1   19:1     0       CLRPICT( 0, 0, 0, 100)    (* 100 === CLEAR PICTURE *)
 11702   1   19:0     4     END;
 11703   1   19:0    18     
 11704   1   19:0    18     
 11705   1   20:D     1   PROCEDURE GRAPHICS;  (* P010014 *)
 11706   1   20:D     1   
 11707   1   20:0     0     BEGIN
 11708   1   20:1     0       MVCURSOR( 40, 0)    (* GRAPHICS MODE *)
 11709   1   20:0     2     END;
 11710   1   20:0    16     
 11711   1   20:0    16     
 11712   1   21:D     1   PROCEDURE TEXTMODE;  (* P010015 *)
 11713   1   21:D     1   
 11714   1   21:0     0     BEGIN
 11715   1   21:1     0       MVCURSOR( 50, 0)    (* TEXT MODE *)
 11716   1   21:0     2     END;
 11717   1   21:0    16     
 11718   1   21:0    16     
 11719   1   22:D     1   PROCEDURE PRINTCHR;  (* P010016 *)
 11720   1   22:D     2   
 11721   1   22:0     0     BEGIN
 11722   1   22:1     0       PRGRCHR( CHARSET[ ORD( ACHAR) - 32])
 11723   1   22:0     8     END;
 11724   1   22:0    22     
 11725   1   22:0    22     
 11726   1   23:D     1   PROCEDURE PRINTSTR;  (* P010017 *)
 11727   1   23:D    43   
 11728   1   23:D    43     VAR
 11729   1   23:D    43          IPOS : INTEGER;
 11730   1   23:D    44   
 11731   1   23:0     0     BEGIN
 11732   1   23:1     0       FOR IPOS := 1 TO LENGTH( ASTRING) DO
 11733   1   23:2    21         BEGIN
 11734   1   23:3    21           PRGRCHR( CHARSET[ ORD( ASTRING[ IPOS]) - 32])
 11735   1   23:2    33         END;
 11736   1   23:0    43     END;
 11737   1   23:0    58     
 11738   1   23:0    58     
 11739   1   24:D     1   PROCEDURE PRINTNUM;  (* P010018 *)
 11740   1   24:D     3   
 11741   1   24:D     3     VAR
 11742   1   24:D     3          DIGITS : STRING[ 5];
 11743   1   24:D     6          DIGITX : INTEGER;
 11744   1   24:D     7          
 11745   1   24:0     0     BEGIN
 11746   1   24:1     0       IF ANUM < 0 THEN
 11747   1   24:2     5         ANUM := 0;
 11748   1   24:1     8       IF FIELDSZ > 5 THEN
 11749   1   24:2    13         FIELDSZ := 5;
 11750   1   24:1    16       IF FIELDSZ < 1 THEN
 11751   1   24:2    21         FIELDSZ := 1;
 11752   1   24:1    24       FOR DIGITX := 5 DOWNTO 1 DO
 11753   1   24:2    35         BEGIN
 11754   1   24:3    35            DIGITS[  DIGITX]  :=  CHR( 48 +  (ANUM MOD 10));
 11755   1   24:3    44            ANUM := ANUM DIV 10
 11756   1   24:2    45         END;
 11757   1   24:1    56       DIGITX := 1;
 11758   1   24:1    59       WHILE  (DIGITX < 5) AND (DIGITS[ DIGITX] = CHR( 48)) DO
 11759   1   24:2    71         BEGIN
 11760   1   24:3    71           DIGITS[ DIGITX] := CHR( 32);
 11761   1   24:3    76            DIGITX:= DIGITX + 1
 11762   1   24:2    77         END;
 11763   1   24:1    83       FOR DIGITX := (6 - FIELDSZ) TO 5 DO
 11764   1   24:2    96         BEGIN
 11765   1   24:3    96           PRINTCHR( DIGITS[ DIGITX])
 11766   1   24:2   100         END;
 11767   1   24:0   109     END;
 11768   1   24:0   128     
 11769   1   24:0   128     
 11770   1   25:D     1   PROCEDURE GETSTR;
 11771   1   25:D     4   
 11772   1   25:D     4     VAR
 11773   1   25:D     4          UNUSEDXX : INTEGER;
 11774   1   25:D     5          UNUSEDYY : INTEGER;
 11775   1   25:D     6          IPOS     : INTEGER;
 11776   1   25:D     7          
 11777   1   25:0     0     BEGIN
 11778   1   25:1     0       IPOS := 0;
 11779   1   25:1     3       REPEAT
 11780   1   25:2     3         MVCURSOR( WINXPOS + IPOS, WINYPOS);
 11781   1   25:2     9         PRINTCHR( CHR( 64));
 11782   1   25:2    12         GETKEY;
 11783   1   25:2    14         IF INCHAR = CHR( 27) THEN
 11784   1   25:3    19           BEGIN
 11785   1   25:4    19             CLRRECT( WINXPOS, WINYPOS, IPOS + 1, 1);
 11786   1   25:4    27             IPOS := 0
 11787   1   25:3    27           END
 11788   1   25:2    30         ELSE
 11789   1   25:3    32           BEGIN
 11790   1   25:4    32             IF (INCHAR = CHR( 8)) AND (IPOS > 0) THEN
 11791   1   25:5    41               BEGIN
 11792   1   25:6    41                 CLRRECT( WINXPOS + IPOS, WINYPOS, 1, 1);
 11793   1   25:6    49                 IPOS := IPOS - 1
 11794   1   25:5    50               END
 11795   1   25:4    54             ELSE
 11796   1   25:5    56               BEGIN
 11797   1   25:6    56                 IF (INCHAR <> CHR( CRETURN)) AND (ORD( INCHAR) >= 32) THEN
 11798   1   25:7    65                   BEGIN
 11799   1   25:8    65                     MVCURSOR( WINXPOS + IPOS, WINYPOS);
 11800   1   25:8    71                     PRINTCHR( INCHAR);
 11801   1   25:8    74                     IPOS := IPOS + 1;
 11802   1   25:8    79                     ASTRING[ IPOS] := INCHAR
 11803   1   25:7    81                   END
 11804   1   25:5    83               END
 11805   1   25:3    83           END
 11806   1   25:1    83       UNTIL INCHAR = CHR( CRETURN);
 11807   1   25:1    88       ASTRING[ 0] := CHR( IPOS)
 11808   1   25:0    91     END;
 11809   1   25:0   106 
 11810   1   25:0   106 (*$I WIZ1A:WIZ2.TEXT *)
 11811   1   25:0   106 
 11812   1   25:0   106 (* ----- BEGIN WIZARDRY MAINLINE ----- *)
 11813   1   25:0   106 
 11814   1    1:0     0 BEGIN  (* P010001 *)
 11815   1    1:0     0   
 11816   1    1:1     0   MEMPTR.I := 16384;  (* $4000 *)
 11817   1    1:1     8   RELEASE( MEMPTR.P);
 11818   1    1:1    13   
 11819   1    1:1    13   REPEAT
 11820   1    1:2    13     LLBASE04 := -1;
 11821   1    1:2    17     SPECIALS;
 11822   1    1:2    20     REPEAT
 11823   1    1:3    20       CASE XGOTO OF
 11824   1    1:3    23       
 11825   1    1:3    23        XSCNMSG,
 11826   1    1:3    23        XINSAREA:  SPECIALS;
 11827   1    1:3    28        
 11828   1    1:3    28        XCASTLE,
 11829   1    1:3    28        XGILGAMS:  CASTLE;
 11830   1    1:3    33        
 11831   1    1:3    33        XBOLTAC,
 11832   1    1:3    33        XCANT,
 11833   1    1:3    33        XCHK4WIN,
 11834   1    1:3    33        XCEMETRY,
 11835   1    1:3    33        XEDGTOWN:  SHOPS;
 11836   1    1:3    38        
 11837   1    1:3    38        XNEWMAZE,
 11838   1    1:3    38        XEQUIP6,
 11839   1    1:3    38        XEQPDSP,
 11840   1    1:3    38        XREORDER,
 11841   1    1:3    38        XCMP2EQ6,
 11842   1    1:3    38        XCAMPSTF:  UTILITIE;
 11843   1    1:3    43        
 11844   1    1:3    43        XTRAININ,
 11845   1    1:3    43        XBCK2ROL:  ROLLER;
 11846   1    1:3    48        
 11847   1    1:3    48        XRUNNER:   RUNNER;
 11848   1    1:3    53        
 11849   1    1:3    53        XREWARD,
 11850   1    1:3    53        XREWARD2:  REWARDS;
 11851   1    1:3    58        
 11852   1    1:3    58        XCOMBAT,
 11853   1    1:3    58        XUNUSED:   COMBAT;
 11854   1    1:3    63        
 11855   1    1:3    63        XINSPECT,
 11856   1    1:3    63        XINSPCT2,
 11857   1    1:3    63        XINSPCT3,
 11858   1    1:3    63        XBCK2CMP,
 11859   1    1:3    63        XBK2CMP2:  CAMP;
 11860   1    1:3    68        
 11861   1    1:3    68       END;
 11862   1    1:2   130     UNTIL XGOTO = XDONE;
 11863   1    1:2   135     
 11864   1    1:2   135     WRITE( CHR( 12));
 11865   1    1:2   143     GOTOXY( 0, 10);
 11866   1    1:2   148     WRITE( '    PRESS [RETURN] FOR MORE WIZARDRY    ');
 11867   1    1:2   198     READLN
 11868   1    1:1   198   UNTIL FALSE
 11869   1    1:0   204 END.
