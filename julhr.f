*** S/R TROUVE LA DATE JULIENNE EN HEURES A PARTIR D'UN CMC STAMP
      SUBROUTINE JULHR(JDH, CMCD )
      IMPLICIT NONE 
      INTEGER    JDH, CMCD
*ARGUMENTS
* SORTIE  JDH  -  JOUR JULIEN EN HEURES 
* ENTRE   CMCD -  DATE FORMAT CMC
*
*AUTEUR       - Y. R. BOURASSA FEV 86
*REVISION 001 - Y. R. BOURASSA MAI 95 ENLEVVE REFERENCES A 1950
*REVISION 002 - M. Lepine - Mars 98-  Retourne une difference a partir
*                                     du 01 jan 1900
*
*     LANGUAGE FTN77
      INTEGER Debut 
*     Date de depart pour references et calcul de difference (1 jan 1900)
      DATA Debut /010100000/  
      EXTERNAL difdatr
      real *8 nhours
      call difdatr(cmcd,Debut,nhours)
      jdh = nint(nhours)
      RETURN
      END 