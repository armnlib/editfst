*** S/P DESIRE - EXTRACTION DES ARGUMENTS D'UNE DIRECTIVE "DESIRE"
      SUBROUTINE DESIRE(TC, NV, LBL, DATE, IP1, IP2, IP3)
      IMPLICIT NONE 
      INTEGER  DATE(10), IP1(20), IP2(10), IP3(10), TC(10), NV(10),
     X         LBL(20)
*     AUTEUR YVON R. BOURASSA JAN 86
*              "  "      "    OCT 90 VERSION QLXINS
*              "  "      "    FEV 91 BUG DECODING ETIKET
*Revision 003   M. Lepine - mars 98 - extensions pour fstd98
*Revision 004   M. Lepine - juil 01 - possibilite d'appel a convip
*     LANGUAGA FTN77
*  
*ARGUMENTS
* ENTRE   TC   -  1 A 10 TYPES DE CHAMPS ( 1 CHARACTERE )
*   "     NV   -  1 A 10 NOMS DE VARIABLES ( 1 @A2 CHARACTERES )
*   "     LBL  -  1 A 10 ETIQUETTES ( 1 @A8 CHARACTERES )
*   "     DATE -  1 A 10 DATES OU INTERVALE AVEC SAUT
*   "     IP1  -  1 A 10 IP1    "      "      "    "
*   "     IP2  -  1 A 10 IP2    "      "      "    "
*   "     IP3  -  1 A 10 IP3    "      "      "    "
      INTEGER   NMR, NMS, NME, NMN, NMM, NMD
      PARAMETER(NMR=12, NMS=25, NME=20, NMN=40, NMM=10, NMD=20)
      COMMON/DESRS/  JOURS(4), NREQ, SAUV, DESEXC(NMD), SATISF(NMD),
     X               NEXC, REQ(11,4,NMD), SUP(8,NMD), NIS, NJS, NKS,
     X               IG1S, IG2S, IG3S, IG4S, REQN(NMD), REQT(NMD),
     X               REQE(NMD), Z1, Z2, Z3, ZD
      INTEGER        NREQ, SAUV, DESEXC, SATISF, NEXC, REQ, SUP, NIS, 
     X               NJS, NKS, IG1S, IG2S, IG3S, IG4S, REQN, REQT, REQE,
     X               JOURS, Z1, Z2, Z3, ZD
      CHARACTER*8 LIN128
      PARAMETER   (LIN128='(32A4)')
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
*
*MODULES
      EXTERNAL FSTCVT, ARGDIMS, ARGDOPE, IOPDATM, JULHR, EXDES, FSTABT,
     X         HOLACAR
**  
      INTEGER  FSTCVT, ARGDIMS, ARGDOPE, IOPDATM, I, J, D, LIS(10)
      DATA     LIS/10*0/
      integer  newip1(20), nip1
      D = -1
   10 IF(NREQ .EQ. NMD) THEN
         IF(DIAG .OR. DEBUG)
     X   PRINT*,'** LE MAXIMUM DE',NMD,' REQUETES DEJA ATEINT **' 
         RETURN
      ENDIF
*     COMPTE LES DIRECTIVES DESIRE/EXCLURE
      IF(D .EQ. 0) NEXC = NEXC + 1
      NREQ = NREQ+1 
*     INDICATEUR QUE LA REQUETE NREQ N'EST PAS SATISFAITE
      SATISF(NREQ) = 0
*     INDICATEUR QUE LA REQUETE NREQ EST DESIRE/EXCLURE
      DESEXC(NREQ) = D
      DO 20 J=1,4
      DO 20 I=1,11
   20    REQ(I,J,NREQ) = 0
      REQE(NREQ) = 0
      REQN(NREQ) = 0
      REQT(NREQ) = 0
      IF( DEBUG ) PRINT*,'REQUETE # ',NREQ
      GO TO(110,90,70,60,50,40,30) NP
   30 IF(IP3(1) .NE. -1) THEN 
         CALL EXDES(IP3,  ARGDIMS(7), 3)
         IF( DEBUG ) PRINT*,'IP3 =',(REQ(I,3,NREQ),I=1,11)
      ENDIF
   40 IF(IP2(1) .NE. -1) THEN 
         CALL EXDES(IP2,  ARGDIMS(6), 2)
         IF( DEBUG ) PRINT*,'IP2 =',(REQ(I,2,NREQ),I=1,11)
      ENDIF
   50 IF(IP1(1) .NE. -1) THEN
         if (argdims(5) .gt. 1) then
            print *,'Debug+ appel a ip1_to_newip1'
            call ip1_to_newip1(ip1,ip1,newip1,argdims(5),nip1)
            CALL EXDES(newip1, nip1, 1)
         else
            CALL EXDES(IP1,  ARGDIMS(5), 1)
         endif
         IF( DEBUG ) PRINT*,'IP1 =',(REQ(I,1,NREQ),I=1,11)
      ENDIF
   60 IF(DATE(1) .NE. -1) THEN
         CALL EXDES(DATE, ARGDIMS(4), 4)
         IF( DEBUG ) PRINT*,'DAT =',(REQ(I,4,NREQ),I=1,11)
      ENDIF
   70 IF(LBL(1) .NE. -1) THEN
         REQE(NREQ) = ARGDOPE(3, LIS, 10)
         CALL HOLACAR(ETIS(1,NREQ), LIS, REQE(NREQ), LBL, 12)
         IF( DEBUG ) PRINT*,'ETIKET = ',(ETIS(J,NREQ),J=1,REQE(NREQ))
      ENDIF
   90 IF(NV(1) .NE.-1) THEN
         REQN(NREQ) = ARGDIMS(2)
         DO 100 J=1, ARGDIMS(2)
            I = FSTCVT(NV(J), -1, -1, -1, NOMS(J,NREQ), TYP, ETI, GTY,
     X                .TRUE.)
  100       CONTINUE
         IF( DEBUG ) PRINT*,'NOMVAR = ',(NOMS(J,NREQ),J=1,ARGDIMS(2))
      ENDIF
  110 IF(TC(1) .NE. -1) THEN
         REQT(NREQ) = ARGDIMS(1)
         DO 120 J=1, ARGDIMS(1)
            I = FSTCVT(-1, TC(J), -1, -1, NOM, TYPS(J,NREQ), ETI, GTY,
     X                .TRUE.)
  120       CONTINUE
         IF( DEBUG ) PRINT*,'TYPVAR = ',(TYPS(J,NREQ),J=1,ARGDIMS(1))
      ENDIF
*     APPLIQUE LES CRITERES SUPLEMENTAIRES AU BESOIN
      IF( SCRI ) THEN
         SUP(8,NREQ) = 1
         SUP(1,NREQ) = NIS
         SUP(2,NREQ) = NJS
         SUP(3,NREQ) = NKS
         SUP(4,NREQ) = IG1S
         SUP(5,NREQ) = IG2S
         SUP(6,NREQ) = IG3S
         SUP(7,NREQ) = IG4S
         GTYS(NREQ)  = GTYPS
      ENDIF
      RETURN
*     POUR CHOISIR LES CHAMPS NON VOULUS
      ENTRY EXCLURE(TC, NV, LBL, DATE, IP1, IP2, IP3)
      D = 0
      GO TO 10
      END 
*** S/P ip1_to_newip1 - conversion des ip1 niveaux en ip1 codes
*
      subroutine ip1_to_newip1(ip1,levels,newip1,m,nip1)
      implicit none
      integer m,nip1
      integer ip1(m),newip1(m)
      real levels(m)
*
*AUTEUR M. Lepine - juil 2001
*
*LANGUAGE Fortran 90
*  
*ARGUMENTS
* Entree  ip1    -  liste de niveaux encodes ou non
*   "     m      -  nombre de ip1
* Sortie  newip1 -  liste des niveaux encodes
*   "     nip1   -  nombre de nouveaux niveaux
*
*MODULES
      EXTERNAL convip
*
**  
      character * 80 string
      integer i
      logical initdone
      data initdone /.false./
      save initdone
      nip1 = 1
      i = 1
      do while (i .le. m)
         if ((ip1(i) .gt. 1 000 000) .or.                     
     %       ((ip1(i) .eq. 0) .and. (ip1(i+1) .lt. 0))) then
C            print *,'Debug+ nombre reel =',levels(i),' i = ',i
            if (ip1(i+1) .ge. 0) then
               print *,'Error: invalid ip1 value = ',ip1(i+1)
            else
               if (.not. initdone) then
                  call convip(0,0,0,0,string,.false.)
                  initdone = .true.
               endif
               call convip(newip1(nip1),levels(i),-1*ip1(i+1)-1000,1,
     %                     string,.false.)
C               print *,'Debug+ newip1 =',newip1(nip1)
               i = i + 1
            endif
         else
            newip1(nip1) = ip1(i)
         endif
         nip1 = nip1 + 1
         i = i + 1
      end do
      nip1 = nip1 - 1
C      print *,'Debug+ newip1 =',newip1
      return
      end
