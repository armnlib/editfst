*** S/R SAUTSQI
*        POSITIONNE LE FICHIER SEQUENTIEL DN 
*        A UN CERTAIN NIVEAU D'EOF LOGIQUE
      SUBROUTINE SAUTSQI(DN, LEV, NL)
      IMPLICIT   NONE
      INTEGER    DN(*), LEV, NL
*ARGUMENTS
*  ENTRE    - DN    - DATASET NAME DU FICHIER DESTINATION A POSITIONNER
*    "      - LEVEL - NIVEAU DE EOF LIGIQUE RECHERCHE [1]
*    "      - NL    - NOMBRE DE DE CES EOF RECHERCHES 1]
*
*AUTEURS
*VERSION ORIGINALE  C. THIBEAULT, C. CHOUINARD ET M.VALIN (STDSAUT)
*REVISION 001       Y. BOURASSA MARS 86
*         002       "      "    NOV 90 VERSION FTN/SQI
*         003       "      "    FEV 92 LE FICHIER DOIT EXISTER
*         004       "      "    MAR 92 CORRIGE BUG DANS TEST FSTINF
*         005       "      "    MAI 92 SKIP ABORT SI EN INTERACTIF
*
*LANGUAGE   - FTN77 
*
      CHARACTER*8 LIN128
      PARAMETER   (LIN128='(32A4)')
      COMMON/TAPES / MEOF, COPIES, NDS, NDD, EOF, CEOF, LEOF, LIMITE, 
     X               NFS,  NFSO,   SOURCES(35), NRECMIN
      INTEGER        MEOF, COPIES, NDS, NDD, EOF, CEOF, LEOF, LIMITE, 
     X               NFS,  NFSO,   SOURCES, NRECMIN
      COMMON/LOGIQ/  SCRI, XPRES, ESAIS, DM1, DEBUG, SELEC, BOX, DIAG,
     x               INTERAC, ZA
      LOGICAL        SCRI, XPRES, ESAIS, DM1, DEBUG, SELEC, BOX, DIAG,
     x               INTERAC, ZA
      INTEGER   NMR, NMS, NME, NMN, NMM, NMD
      PARAMETER(NMR=12, NMS=25, NME=20, NMN=40, NMM=10, NMD=20)
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
*
*MODULES  
      EXTERNAL      ARGDIMS, FSTINF, FSTEOF, OUVRED, FSTABT 
*
**
      INTEGER       ARGDIMS, FSTINF, FSTEOF, OUVRED, LEVEL,
     X              I, J, K, L, M
      CHARACTER*128 CLE
      CHARACTER*15  SORTE, TAPE
      CHARACTER*3   DND
      DND   = 'SEQ'
      SORTE = 'STD+SEQ+OLD'
*     ASSIGNATION DES PARAMETRES PAR DEFAUT ET OUVRE FICHIER
    1 IF(NP .GT. 1) THEN
         LEVEL = LEV
      ELSE
         LEVEL = 1
      ENDIF
      IF(NP .EQ. 3) THEN
         I = NL
      ELSE
         I = 1
      ENDIF
      WRITE(CLE, LIN128) (DN(M), M=1,ARGDIMS(1))
      IF(CLE.EQ.ND .AND. OUVD) THEN
         IF(INDEX(DNOM, DND). EQ. 0) THEN
            WRITE(6,*)'PROBLEME AVEC FICHIER D= ', ND
            WRITE(6,*)'DEJA OUVERT AVEC   TYPE= ', DNOM
            WRITE(6,*)'TYPE PRESEMT=            ', SORTE
            IF( INTERAC ) THEN
               RETURN
            ELSE
               CALL FSTABT
            ENDIF
         ENDIF
         J = 3
      ELSEIF(CLE.EQ.NS .AND. OUVS) THEN 
         IF(INDEX(SNOM, DND) .EQ. 0) THEN
            WRITE(6,*)'PROBLEME AVEC FICHIER S= ', NS
            WRITE(6,*)'DEJA OUVERT AVEC   TYPE= ', SNOM
            WRITE(6,*)'TYPE PRESEMT=            ', SORTE
            IF( INTERAC ) THEN
               RETURN
            ELSE
               CALL FSTABT
            ENDIF
         ENDIF
         J = SOURCES(1)
      ELSE
         DNOM = SORTE
         K    = OUVRED( CLE )
         IF(K .EQ. 0) THEN
            J    = 3
         ELSE
            PRINT*,'FICNIER N''EXISTE PAS'
            IF( INTERAC ) THEN
               RETURN
            ELSE
               CALL FSTABT
            ENDIF
         ENDIF
      ENDIF
      IF( DIAG .OR. DEBUG ) THEN
         TAPE = CLE
         WRITE(6,600) I, LEVEL, J, TAPE
  600    FORMAT(' SAUTE',I3,' EOF 'I2,' FICHIER',I3,'=',A15,'...')
      ENDIF       
*     SAUTE AU N..IEME EOF DE NIVEAU LEVEL
   10 IF(FSTINF(J, K, L, M, 0, '0', 0, 0, 0, '0', '0') .GE. 0)
     X   GOTO 10
      M = FSTEOF(J) 
      IF(M.LT.1 .OR. M.GT.15) THEN
         PRINT*,' MAUVAISE MARQUE DE FIN DE FICHIER =',M,
     X          ' RENCONTREE DANS TAPE=',J
         CALL FSTABT
      ENDIF
      IF(DIAG .OR. DEBUG) WRITE(6,*)'RENCONTRE UN EOF #',M
      IF(M .LT. LEVEL) GO TO 10
      IF(M .EQ. LEVEL) THEN
         I = I-1
         IF(I .NE. 0) GO TO 10
      ENDIF
      IF(J .EQ. SOURCES(1)) LEOF = M
      RETURN
***   SAUTSEQ OUVRE LE FICHIER 2 (SEQUENTIEL 'SEQ+FTN')
      ENTRY SAUTSEQ(DN, LEV, NL)
      DND   = 'FTN'
      SORTE = 'STD+SEQ+FTN+OLD'
      GO TO 1
      END 
