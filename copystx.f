*** S/P COPYSTX COPIE UN FICHIER STANDARD EN TOUT OU EN PARTIE.
      SUBROUTINE COPYSTX
      IMPLICIT NONE 
*AUTEURS
*         - C. THIBEAULT  FEV 83
*         - Y. BOURASSA   FEV 86
*           "     "       NOV 89 INGORER LISTE OU GANGE DE RECORDS 
*           "     "              CORRIGE BUG QUAND EXPRESS = .TRUE.
*           "     "       OCT 90 ACCEPTE FICHIERS STD89. 
*           "     "       NOV 90 SI MIX DE DESIRE ET EXCLURE, EXCLURE
*                                LES ENREGISTREMENTS DESIRES SEULEMENT.
*           "     "       JUL 91 VERSION ZAPPER
*           "     "       NOV 91 TESTING DES PARAMETRES DE SELECTION DANS 
*                                UN ORDRE DIFFERENT
*           "     "       JAN 92 BUG PREMIERE ALLOCATION MEMOIRE
*Revision 009   M. Lepine - mars 98 - extensions pour fstd98
*Revision 010   M. Lepine - Oct  98 - Ajout du test de nrecmin
*
*LANGAGE  - FTN77
      INTEGER   NMR, NMS, NME, NMN, NMM, NMD
      PARAMETER(NMR=12, NMS=25, NME=20, NMN=40, NMM=10, NMD=20)
      COMMON/LOGIQ/  SCRI, XPRES, ESAIS, DM1, DEBUG, SELEC, BOX, DIAG,
     x               INTERAC, ZA
      LOGICAL        SCRI, XPRES, ESAIS, DM1, DEBUG, SELEC, BOX, DIAG,
     x               INTERAC, ZA
      COMMON/DESRS/  JOURS(4), NREQ, SAUV, DESEXC(NMD), SATISF(NMD),
     X               NEXC, REQ(11,4,NMD), SUP(8,NMD), NIS, NJS, NKS,
     X               IG1S, IG2S, IG3S, IG4S, REQN(NMD), REQT(NMD),
     X               REQE(NMD), Z1, Z2, Z3, ZD
      INTEGER        NREQ, SAUV, DESEXC, SATISF, NEXC, REQ, SUP, NIS, 
     X               NJS, NKS, IG1S, IG2S, IG3S, IG4S, REQN, REQT, REQE,
     X               JOURS, Z1, Z2, Z3, ZD
      COMMON/TAPES / MEOF, COPIES, NDS, NDD, EOF, CEOF, LEOF, LIMITE, 
     X               NFS,  NFSO,   SOURCES(35), NRECMIN
      INTEGER        MEOF, COPIES, NDS, NDD, EOF, CEOF, LEOF, LIMITE, 
     X               NFS,  NFSO,   SOURCES, NRECMIN
      COMMON /KEY/   KLE(60), DEF1(60), DEF2(60), PRINTR
      CHARACTER*8    KLE
      CHARACTER*128           DEF1,     DEF2,     PRINTR
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
      COMMON/FICHES/ NP, FIXD, ECR, SSEQ, VS, OUVS, DSEQ, VD, OUVD
      INTEGER        NP
      LOGICAL            FIXD, ECR, SSEQ, VS, OUVS, DSEQ, VD, OUVD
      COMMON /   / BUFL(1)
      INTEGER      BUFL
*     - BUFL       CHAMP DONT LA LONGUEUR VARIE SELON LES RESSOURCES
*                  NECESSAIRES, LA ROUTINE MEMOIR RESERVE L'ESPASSE
*                  (LINGUEUR INITIALE = 1)
      EXTERNAL     MEMOIRH, FSTPRM, FSTSUI, FSTECR, FSTINF, FSTWEO,
     X             CRITSUP, DESIRE, FSTLUK, FSTFRM, FSTEOF, FSTABT,
     X             JULHR, QQEXIT
      INTEGER      FSTINF, FSTEOF, IG1, XTRA1, NI, I, IREC, DATE, SWA,
     X             FSTPRM, FSTFRM, IG2, XTRA2, NJ, J, DEET,       LNG,
     X             FSTECR, FSTSUI, IG3, XTRA3, NK, K, DLFT, DTYP, UBC,
     X             FSTLUK, FSTWEO, IG4, NBITS, NM,    NPAS, IP(4), IST
      LOGICAL      FIRSTP, BONNE, OK, EXCL
      SAVE         NM, IST
      DATA         NM, IST / 0, 0/
      EXCL   = (NEXC.GT.0) .AND. (NREQ.EQ.NEXC)
      OK     = .NOT.FIXD .AND. .NOT.DM1 
*     EXCL   = .TRUE. TROUVE DES DIRECTIVES EXCLURE SEULEMENT
*     OK     = .TRUE. UNE DATE DANS LES DESIRES ET ENREGISTREMENTS
*                     PAS NECESSAIREMENT VALIDES EN MEME TEMP
*     DM1    = .TRUE. PAS DE DATES DANS LES DESIRES
*     FIXD   = .TRUE. LES ENREGISTREMENTS DU FICHIER SOURCE SONT TOUS 
*                     VALIDES EN MEME TEMPS.
*     BONNE  = .TRUE. SI LA DATE DU PREMIER ENREGISTREMENT ACCEPTABLE 
*     DONC IF(FIXD .AND. .NOT.BONNE) INUTILE DE CHERCHER PLUS LOIN
   10 BONNE  = .FALSE.
      FIRSTP = .TRUE.
*     TROUVE LA CLE DU PROCHAIN ENREGISTREMENT.
      IREC   = FSTINF(SOURCES(1), NI, NJ, NK, -1, ' ', -1, -1, -1,
     X                ' ', ' ')
      IF(IREC .LT. 0) GO TO 160
      IF( DEBUG ) WRITE(6,*)' FIRSTP=',FIRSTP,'  OK=',OK,
     X                      ' BONNE=',BONNE
   20 I = FSTPRM(IREC, DATE, DEET, NPAS, NI, NJ, NK, NBITS, DTYP,
     X           IP(1), IP(2), IP(3), TYP, NOM, ETI, GTY, IG1, IG2,
     X           IG3, IG4, SWA, LNG, DLFT, UBC, XTRA1, XTRA2, XTRA3)
      IF(NBITS.GT.48 .AND. DTYP.EQ.1) THEN
         WRITE(6,*)'IMPOSSIBLE DE COPIER ENREGISTREMENT NO.',IREC,
     X             ' NBITS =',NBITS 
         GO TO 140
      ENDIF
      IF(FIRSTP .OR. OK) THEN 
*        CALCUL DE L'HEURE JULIENNE (AU MOIN DU PREMIER ENREGISTREMENT).
         CALL JULHR(IP(4), DATE)
         IP(4) = IP(4) + (DEET*NPAS+1800)/3600
         IF(DEBUG .AND. FIRSTP) WRITE(6,*)'DATE ENRG. #1= ',DATE,
     X                                    ' JUL. HEURE=',IP(4)
         FIRSTP = .FALSE.
         IF( DEBUG ) WRITE(6,*)' FIRSTP=',FIRSTP,' OK=',OK, 
     X                         ' BONNE=',BONNE
      ENDIF
*     SI ON DEMANDE TOUT LE FICHIER.
      IF( XPRES ) THEN
         BONNE  = .TRUE.
         GO TO 120
      ENDIF
*     VERIFIE SI L'ENREGISTREMENT SATISFAIT UN DESIRE OU EXCLURE
      DO 110 K=1,NREQ
*        TEST DU NOMVAR
         IF(REQN(K) .NE. 0) THEN
            DO 30 J=1,REQN(K)
   30          IF(NOM .EQ. NOMS(J,K)) GO TO 40
            GO TO 110
         ENDIF
*        TEST DES IP1-2-3 ET DE LA DATE
   40    DO 60 J=4,1,-1 
*           SI LE PARAMETRE EST UNIVERSEL
            IF(REQ(11,J,K) .EQ. 0) THEN
               IF(J.EQ.4 .AND. (FIXD.OR.DM1)) BONNE = .TRUE.
            ELSEIF(REQ(11,J,K) .GT. 0) THEN 
*              REQUETE CONTIENT UNE LISTE DE PARAMETRES
               DO 50 I=1,REQ(11,J,K)
                  IF(IP(J) .EQ. REQ(I,J,K)) GO TO 60
   50             CONTINUE
               GO TO 110
            ELSE
*              REQUETE CONTIENT UN INTERVALE AVEC SAUT
                IF(IP(J).GE.REQ(1,J,K) .AND. 
     X            IP(J).LE.REQ(2,J,K) .AND. 
     X            MOD((IP(J)-REQ(1,J,K)),REQ(3,J,K)).EQ.0) GOTO 60
               GO TO 110
            ENDIF
   60       CONTINUE
*        TEST DU TYVAR
         IF(REQT(K) .NE. 0)  THEN
            DO 70 J=1,REQT(K)
   70          IF(TYP .EQ. TYPS(J,K)) GO TO 80
            GO TO 110
         ENDIF
*        TEST DE L'ETIKET
   80    IF(REQE(K) .NE. 0) THEN
            DO 90 J=1,REQE(K)
               IF(ETI .EQ. ETIS(J,K)) GO TO 100
   90          CONTINUE
            GO TO 110
         ENDIF
*        SI LES CRITERES SUPLEMENTAIRES S'APPLIQUENT
  100    IF(SUP(8,K).NE.0  .AND.
     X    ((SUP(1,K).NE.-1 .AND. SUP(1,K).NE.NI)  .OR.
     X     (SUP(2,K).NE.-1 .AND. SUP(2,K).NE.NJ)  .OR.
     X     (SUP(3,K).NE.-1 .AND. SUP(3,K).NE.NK)  .OR.
     X     (GTYS(K).NE.' ' .AND. GTYS(K).NE.GTY)  .OR.
     X     (SUP(4,K).NE.-1 .AND. SUP(4,K).NE.IG1) .OR.
     X     (SUP(5,K).NE.-1 .AND. SUP(5,K).NE.IG2) .OR.
     X     (SUP(6,K).NE.-1 .AND. SUP(6,K).NE.IG3) .OR.
     X     (SUP(7,K).NE.-1 .AND. SUP(7,K).NE.IG4))) GO TO 110
*        TROUVE UN MATCH POUR LA REQUETE(K).
         SATISF(K) = SATISF(K) + 1
*        SI LA DIRECTIVE SATISFAITE EST UN DESIRE
         IF( DESEXC(K) .EQ. -1 ) GO TO 120
*        SI LA DIRECTIVE SATISFAITE EST UN EXCLURE            
         IF( DIAG ) WRITE(6,*)'CLE',IREC, 'TYPRVAR=',TYP,
     X                       ' NOMVAR=',NOM,' ETIKET=',ETI,
     X                       ' IP1,2,3,DATE=',IP,' EXCLU'
         GO TO 140
  110    CONTINUE
*     AUCUNE DES REQUETES SATISFAITE
      IF( .NOT. EXCL ) GO TO 140
*     CONTROLE DE LA MEMOIRE TEMPON AVANT LECTURE
  120 IF(LNG .GT. NM) THEN
         IF(IST .NE. 0) CALL MEMOIRH(BUFL, IST, 0)
         NM = LNG
         CALL MEMOIRH(BUFL, IST, NM)
      ENDIF
      I = FSTLUK(BUFL(IST), IREC, NI, NJ, NK)
      IF( ZA ) THEN
         IF(Z1 .NE. -1)  IP(1) = Z1
         IF(Z2 .NE. -1)  IP(2) = Z2
         IF(Z3 .NE. -1)  IP(3) = Z3
         IF(ZD .NE. -1)  DATE  = ZD
         IF(ZT .NE. '??') THEN
            IF(ZT(1:1) .NE. '?') TYP(1:1) = ZT(1:1)
            IF(ZT(2:2) .NE. '?') TYP(2:2) = ZT(2:2)
         ENDIF
         IF(ZN .NE. '??') THEN
            IF(ZN(1:1) .NE. '?') NOM(1:1) = ZN(1:1)
            IF(ZN(2:2) .NE. '?') NOM(2:2) = ZN(2:2)
            IF(ZN(3:3) .NE. '?') NOM(3:3) = ZN(3:3)
            IF(ZN(4:4) .NE. '?') NOM(4:4) = ZN(4:4)
         ENDIF
         IF(ZE .NE. '????????????') THEN
            DO 130 I=1,12
               IF(ZE(I:I) .NE. '?') ETI(I:I) = ZE(I:I)
  130          CONTINUE
         ENDIF
      ENDIF
      I = FSTECR(BUFL(IST), BUFL(IST), -NBITS, 3, DATE, DEET,
     X           NPAS, NI, NJ, NK, IP(1), IP(2), IP(3), TYP, NOM,
     X           ETI, GTY, IG1, IG2, IG3, IG4, DTYP, ECR)
      COPIES = COPIES + 1
      LIMITE = LIMITE - 1
      IF(LIMITE .EQ. 0) GO TO 180
  140 IF(.NOT.BONNE .AND. FIXD) THEN
         IF( DIAG .OR. DEBUG) WRITE(6,*)'*** DATE DE VALIDATION DU ', 
     X     'PREMIER ENREGITREMENT INACCEPTABLE ***'
*        PREMIERE DATE MAUVAISE ET LES AUTRES SUPPAUSEES PAREILLES.
*        SI LE SOURCE EST RANDOM LA COPIE EST TERMINEE.
*         "  "    "    "  SEQUENTIEL SKIP AU PROCHAIN EOF.
  150    IF(SSEQ .AND. FSTSUI(SOURCES(1), NI, NJ, NK) .NE. 0) GO TO 150
      ELSE
*        PREMIERE DATE BONNE OU DATES SONT PAS TOUTES PAREILLES
         IREC = FSTSUI(SOURCES(1), NI, NJ, NK)
         IF(IREC .GE. 0) GO TO 20
      ENDIF
  160 IF(SSEQ) THEN 
         LEOF = FSTEOF(SOURCES(1))
         print*,'apres fsteof leof=',leof
         IF(DIAG .OR. DEBUG) WRITE(6,*)'RENCONTRE UN EOF',LEOF,
     X                                 ' DANS ', SOURCES(1),'...'
         IF(LEOF.GT.15 .OR. LEOF.LT.1) THEN
            WRITE(6,*) LEOF,' N''EST PAS ACCEPTABLE COMME EOF LOGOQUE'
            CALL FSTABT
         ENDIF
         IF(DSEQ .AND. CEOF.NE.0) THEN
            K = CEOF
            IF(CEOF .LT. 0) K = LEOF
            IF(K .LT. 15) THEN
               I = FSTWEO(3, K)
               IF(I.EQ.0 .AND. (DIAG .OR. DEBUG)) THEN
                  WRITE(6,*)'EOF LOGIQUE ',K,' AJOUTEE AU FICHIER',ND
               ELSEIF(I .NE. 0) THEN
                  WRITE(6,*)'IMPOSSIBLE D''ECRIRE UNE MARQUE DE ',
     X                      'NIVEAU ',K,' DANS ', ND
                  CALL FSTABT 
               ENDIF
            ENDIF
         ENDIF
*        DEVONS-NOUS CONTINUER PASSE LE EOF RENCONTRE DANS SOURCE?
         IF(LEOF .LT. MEOF) GO TO 10
      ENDIF
*     DOIT-ON ECRIRE UN EOF AVANT DE FERMER?
      IF(DSEQ .AND. EOF.GT.0) THEN
         I = FSTWEO(3, EOF)
         IF(I.EQ.0 .AND. (DIAG .OR. DEBUG)) THEN
            WRITE(6,*)' MARQUE DE NIVEAU',K,' ECRITE DANS ', ND
         ELSEIF(I .NE. 0) THEN
            WRITE(6,*)' IMPOSSIBLE D''ECRIRE UNE MARQUE DE NIVEAU',
     X                K,' DANS ', ND
            CALL FSTABT
         ENDIF
      ENDIF
      IF(.NOT.XPRES .AND. (DIAG .OR. DEBUG)) THEN 
         DO 170 I=1,NREQ
*           PRENDRE NOTE DES REQUETES NON SATISFAITES
            IF(SATISF(I) .EQ. 0) WRITE(6,*)'*** ATTENTION REQUETE',
     X         I,' INSATISFAITE ***'
  170       CONTINUE
      ENDIF
  180 WRITE(6,*) COPIES,' ENREGISTREMENT(S) COPIES DANS ', ND
      IF (COPIES .LT. NRECMIN) THEN
         WRITE(6,*) ' NOMBRE MINIMAL D ENREGISTREMENT INSATISFAIT'
         WRITE(6,*) ' NRECMIN=',NRECMIN,' NOMBRE TROUVE = ',COPIES
         CALL QQEXIT(12)
      ENDIF
      RETURN
      END 
