*** S/R EXDES DECODE LA DATE, LES IP1, IP2 ET IP3 DE LA CARTE
*             DESIRE/EXCLURE
*
      SUBROUTINE EXDES(CLE, N, M)
      IMPLICIT NONE 
      INTEGER    CLE(10), N, M
*ARGUMENTS
* ENTRE   CLE  -  ARGUMENTS DE L'APPEL A DESIRE (IP1,IP2,IP3,DATE)
*   "     N    -  DIMENSION DE CLE
*   "     M    -  PARAMETRE A DECODER 1=IP1 2=IP2 3=IP3 4=DATE
*AUTEURs
*VERSION ORIGINALE  - Y. BOURASSA SEP 90
*REVISION 001         "     "     OCT 90 VERSION QLXINS
*         002         "     "     MAR 92 BUG DANS REQUETE AVEC SAUT
*                                        MAX MIN DIFF. POUR DATE IP1-2-3
*         003         "     "     AVR 92 TEST SUR DATE JULIENNE
*         004         "     "            ALLOUE RANGE INVERSE 
*         005         "     "     MAI 95 ENLEVVE REFERENCES A 1950
*         006         M. Lepine   Mar 98 Traitement des dates > 2000
*         007         M. Lepine   Sep 98 Bug fix stamp limite superieure
*     LANGUAGE FTN77
*
*MODULES
      EXTERNAL JULHR, FSTABT
*
**
      INTEGER   NMR, NMS, NME, NMN, NMM, NMD
      PARAMETER(NMR=12, NMS=25, NME=20, NMN=40, NMM=10, NMD=20)
      COMMON/DESRS/  JOURS(4), NREQ, SAUV, DESEXC(NMD), SATISF(NMD),
     X               NEXC, REQ(11,4,NMD), SUP(8,NMD), NIS, NJS, NKS,
     X               IG1S, IG2S, IG3S, IG4S, REQN(NMD), REQT(NMD),
     X               REQE(NMD), Z1, Z2, Z3, ZD
      INTEGER        NREQ, SAUV, DESEXC, SATISF, NEXC, REQ, SUP, NIS, 
     X               NJS, NKS, IG1S, IG2S, IG3S, IG4S, REQN, REQT, REQE,
     X               JOURS, Z1, Z2, Z3, ZD
      COMMON/FICHES/ NP, FIXD, ECR, SSEQ, VS, OUVS, DSEQ, VD, OUVD
      INTEGER        NP
      LOGICAL            FIXD, ECR, SSEQ, VS, OUVS, DSEQ, VD, OUVD
      INTEGER  I, J, BOT(4), TOP(4)
      SAVE     BOT, TOP
*     LIMITE INFERIEURE = 0 POUR IP1-2-3 & JAN 01 1900 00Z POUR DATE
      DATA     BOT/0,0,0,010100000/
*     LIMITE SUPERIEURE POUR IP1-2-3     & JAN 01 2219 00Z POUR DATE
      DATA     TOP/32767, 32767, 4095, 2008728800/
*     FAUT-IL PRENDRE LA DATE DE LA PERIODE?
      IF(M.EQ.4 .AND. CLE(1).EQ.-4) THEN
         IF(JOURS(4) .EQ. 0) THEN
            WRITE(6,*)' PAS RENCONTRE DE DIRECTIVE PERIODE' 
            CALL FSTABT
         ELSE
            REQ(11,M,NREQ) = JOURS(4)
            DO 10 I=1,3
               REQ(I,M,NREQ) = JOURS(I) 
   10          CONTINUE
            RETURN
         ENDIF
      ENDIF
      IF(N.EQ.1 .OR. ((CLE(1).NE.-2).AND.(CLE(2).NE.-2))) THEN
*        REQUETE = LISTE SE NOMBRES
         REQ(11,M,NREQ) = N
         DO 20 J=1,N
            REQ(J,M,NREQ) = CLE(J)
   20       CONTINUE
      ELSE
         REQ( 1,M,NREQ) = BOT(M)
         REQ( 2,M,NREQ) = TOP(M)
         REQ( 3,M,NREQ) = 1
         REQ(11,M,NREQ) = -1
         IF(CLE(1) .EQ. -2 ) THEN
*           CHANGE REQUETE DE TYPE [@,-----] 
            REQ(2,M,NREQ) = CLE(2)
            IF(N .EQ. 3) THEN
*              CHANGE REQUETE DE TYPE [@,-----,-- ]
               REQ(3,M,NREQ) = CLE(3)
            ELSEIF(N .EQ. 4) THEN
*              CHANGE REQUETE DE TYPE [@,-----,DELTA,--]
               REQ(3,M,NREQ) = CLE(4)
            ENDIF
         ELSE
*           CHANGE REQUETE DE TYPE [-----,@]
            REQ(1,M,NREQ) = CLE(1)
            IF(N.GT.2 .AND. CLE(3).NE.-3) THEN
*              CHANGE REQUETE DE TYPE [-----,@,-----]
               REQ(2,M,NREQ) = CLE(3)
            ENDIF
            IF(N. GT. 3) THEN
               IF(CLE(3) .EQ. -3) THEN
*                 CHANGE REQUETE DE TYPE [-----,@,DELTA,--]
                  REQ(3,M,NREQ) = CLE(4)
               ELSEIF(N .EQ. 4) THEN
*                 CHANGE REQUETE DE TYPE [-----,@,-----,--]
                  REQ(3,M,NREQ) = CLE(4)
               ELSE
*                 CHANGE REQUETE DE TYPE [-----,@,-----,DELTA,--]
                  REQ(3,M,NREQ) = CLE(5)
               ENDIF
            ENDIF
         ENDIF  
      ENDIF
      IF(M .EQ. 4) THEN
         I = REQ(11,M,NREQ)
         IF(I .EQ. -1) I=2
         DO 40 J=1,I
            CALL JULHR(REQ(J,M,NREQ), REQ(J,M,NREQ))
   40       CONTINUE
      ENDIF
      IF(REQ(11,M,NREQ) .EQ. -1) THEN
         J = MAX(REQ(1,M,NREQ), REQ(2,M,NREQ))
         REQ(1,M,NREQ) = MIN(REQ(1,M,NREQ), REQ(2,M,NREQ))
         REQ(2,M,NREQ) = J
      ENDIF
      RETURN
      END 