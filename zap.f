*** S/P ZAP - CHANGE LES ARGUMENTS DU LABEL A LA SORTIE
*
      SUBROUTINE ZAP(TV, NV, LBL, DATE, IP1, IP2, IP3)
      IMPLICIT NONE 
      INTEGER  TV, NV, LBL(*), DATE, IP1, IP2, IP3
*
*AUTEURS
*VERSION ORIGINALE Y. BOURASSA JUL 91
*REVISION      001 "      "    JUL 92 COUPE DW DE DATE
*              002 "      "    OCT 92 PADING DU LABEL
*LANGUAGA FTN77
*  
*ARGUMENTS
*ENTRE   TV   -  TYPEVAR 
*  "     NV   -  NOMVAR  
*  "     LBL  -  ETIKET  
*  "     DATE -  DATE
*  "     IP1  -  IP1 
*  "     IP2  -  IP2
*  "     IP3  -  IP3
*
      INTEGER   NMR, NMS, NME, NMN, NMM, NMD
      PARAMETER(NMR=12, NMS=25, NME=20, NMN=40, NMM=10, NMD=20)
      COMMON/LOGIQ/  SCRI, XPRES, ESAIS, DM1, DEBUG, SELEC, BOX, DIAG,
     x               INTERAC, ZA
      LOGICAL        SCRI, XPRES, ESAIS, DM1, DEBUG, SELEC, BOX, DIAG,
     x               INTERAC, ZA
      COMMON/FICHES/ NP, FIXD, ECR, SSEQ, VS, OUVS, DSEQ, VD, OUVD
      INTEGER        NP
      LOGICAL            FIXD, ECR, SSEQ, VS, OUVS, DSEQ, VD, OUVD
      COMMON /CHAR/  NS, ND, SNOM, DNOM, ZE, ETI, ETIS(10,NMD), 
     X               ZT, TYP, TYPS(10,NMD), GTY, GTYS(NMD), GTYPS,
     X               ZN, NOM, NOMS(10,NMD), ETAT
      CHARACTER *1   GTY, GTYS, GTYPS
      CHARACTER *2   ZT, TYP, TYPS
      CHARACTER *4   ZN, NOM, NOMS
      CHARACTER *6   ETAT
      CHARACTER *12  ZE, ETI, ETIS
      CHARACTER *128 NS, ND
      CHARACTER *15  SNOM, DNOM
      COMMON/DESRS/  JOURS(4), NREQ, SAUV, DESEXC(NMD), SATISF(NMD),
     X               NEXC, REQ(11,4,NMD), SUP(8,NMD), NIS, NJS, NKS,
     X               IG1S, IG2S, IG3S, IG4S, REQN(NMD), REQT(NMD),
     X               REQE(NMD), Z1, Z2, Z3, ZD
      INTEGER        NREQ, SAUV, DESEXC, SATISF, NEXC, REQ, SUP, NIS, 
     X               NJS, NKS, IG1S, IG2S, IG3S, IG4S, REQN, REQT, REQE,
     X               JOURS, Z1, Z2, Z3, ZD
*MODULE
*  
      EXTERNAL     FSTCVT, ARGDOPE, HOLACAR
**
      INTEGER      FSTCVT, ARGDOPE, I, LIS(10)
      CHARACTER *1 G
      CHARACTER *2 T
      CHARACTER *4 N
      CHARACTER *12 E
      DATA         LIS/10*0/
      ZA = .FALSE.
      ZD = -1
      Z1 = -1
      Z2 = -1
      Z3 = -1
      ZT = '??'
      ZN = '????'
      ZE = '????????????' 
      GO TO(70, 60, 50, 40, 30, 20, 10) NP
   10 IF(IP3 .NE. -1) THEN
         ZA = .TRUE.
         Z3 = IP3
         IF( DEBUG ) WRITE(6,*)' ZIP3 = ',Z3
      ENDIF
   20 IF(IP2 .NE. -1) THEN
         ZA = .TRUE.
         Z2 = IP2
         IF( DEBUG ) WRITE(6,*)' ZIP2 = ',Z2
      ENDIF
   30 IF(IP1 .NE. -1) THEN
         ZA = .TRUE.
         Z1 = IP1
         IF( DEBUG ) WRITE(6,*)' ZIP1 = ',Z1
      ENDIF
   40 IF(DATE .NE. -1) THEN
         ZA = .TRUE.
         ZD = DATE - DATE/1000000000*1000000000
         IF( DEBUG ) WRITE(6,*)' ZDAT = ',ZD
      ENDIF
   50 IF(LBL(1) .NE. -1) THEN
         I = ARGDOPE(3, LIS, 10)
         CALL HOLACAR(ZE, LIS, I, LBL, 12)
         IF(ZE .NE. '????????????') THEN
            ZA = .TRUE.
            IF( DEBUG ) WRITE(6,*)' ZETIKET= -',ZE,'-'
         ENDIF
      ENDIF
   60 IF(NV .NE. -1) THEN
         I = FSTCVT(NV, -1, -1, -1, ZN, T, E, G, .TRUE.)
         IF(ZN .NE. '????') THEN
            ZA = .TRUE.
            IF( DEBUG ) WRITE(6,*)' ZNOM= -',ZN,'-'
         ENDIF
      ENDIF
   70 IF(TV .NE. -1) THEN
         I = FSTCVT(-1, TV, -1, -1, N, ZT, E, G, .TRUE.)
            IF(ZT .NE. '??') THEN
            ZA = .TRUE.
            IF( DEBUG ) WRITE(6,*)' ZTYP= -',ZT,' -'
         ENDIF
      ENDIF
      RETURN 
      END 