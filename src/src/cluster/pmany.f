      SUBROUTINE PMANY(MM, M, N, A, CLAB, TITLE, XMIN, XMAX, NC, IERR,
     *                 OUNIT)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C      PRODUCES A MATRIX OF SCATTER PLOTS BETWEEN Y(I) AND Y(J) FOR
C      I <= I,J => N WHERE N IS THE NUMBER OF VARIABLES.  FOR I=J, A
C      HISTOGRAM FOR VARIABLE I IS PRODUCED
C
C   DESCRIPTION
C   -----------
C
C   1.  THE ROUTINE PRODUCES AN N BY N MATRIX OF PLOTS ON FORTRAN UNIT
C       OUNIT.  THE (I,J)-TH ELEMENT (I<>J) IS A SCATTERPLOT OF
C       VARIABLE I VS.  VARIABLE J.  IF I=J, THE PLOT IS A HISTOGRAM OF
C       VARIABLE I.
C
C   2.  A SINGLE DATA VALUE IS DENOTED BY A PERIOD (.); TWO COINCIDENT
C       DATA VALUES DENOTED BY A COLON (:); THREE COINCIDENT DATA
C       VALUES DENOTED BY A PLUS (+); AND MORE THAN THREE DENOTED BY A
C       FOUR (4).
C
C   INPUT PARAMETERS
C   ----------------
C
C   MM    INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF THE MATRIX A.  MUST BE AT LEAST M.
C
C   M     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF CASES.
C
C   N     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF VARIABLES.
C
C   A     REAL MATRIX WHOSE FIRST DIMENSION MUST BE MM AND SECOND
C            DIMENSION MUST BE AT LEAST N (UNCHANGED ON OUTPUT).
C
C         A(I,J) IS THE VALUE FOR THE J-TH VARIABLE FOR THE I-TH CASE.
C
C   CLAB  VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST N
C            (UNCHANGED ON OUTPUT).
C         THE LABELS OF THE VARIABLES.
C
C   TITLE 10-CHARACTER VARIABLE (UNCHANGED ON OUTPUT).
C         THE TITLE OF THE DATA SET.
C
C   XMIN  INTEGER VECTOR DIMENSIONED AT LEAST N (UNCHANGED ON OUTPUT).
C         XMIN(I) HOLDS THE MINIMUM VALUE TO BE PLOTTED FOR VARIABLE I.
C
C   XMAX  INTEGER VECTOR DIMENSIONED AT LEAST N (UNCHANGED ON OUTPUT).
C         XMAX(I) HOLDS THE MAXIMUM VALUE TO BE PLOTTED FOR VARIABLE I.
C
C         IF XMIN(I) .GE. XMAX(I) ON INPUT, THEIR VALUES WILL BE
C            DETERMINED BY THE ROUTINE.
C
C   NC    INTEGER VECTOR DIMENSIONED AT LEAST N+1 (CHANGED ON OUTPUT).
C         NC(I) HOLDS THE NUMBER OF HORIZONTAL AND VERTICAL SPACES TO BE
C            USED FOR THE I-TH COLUMN OF SCATTER PLOTS.
C
C         IF NC(I) = 0 ON INPUT, THE ROUTINE WILL CALCULATE THE VALUES
C         OF NC WHICH WILL USE THE MAXIMUM OF THE 132 COLUMNS OF THE
C         PRINTER.  SINCE THE PLOTS MUST FIT ON A 132 COLUMN PRINTOUT,
C         SUM(NC(I))+2*N FOR I=1,N MUST BE LESS THAN 122 OR THE ROUTINE
C         WILL RETURN WITH AN ERROR MESSAGE.
C
C   OUNIT INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         UNIT NUMBER FOR OUTPUT.
C
C   OUTPUT PARAMETER
C   ----------------
C
C   IERR  INTEGER SCALAR.
C         ERROR FLAG.
C
C         IF IERR = 0, NO ERROR WAS DETECTED DURING EXECUTION.
C
C         IF IERR = 1, THE SIZE OF THE PLOTS AS SPECIFIED BY NC WILL NOT
C                      FIT ON A 132-COLUMN PRINTER.  DECREASE THE VALUES
C                      OF NC.
C
C   REFERENCES
C   ----------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGES 48-49.
C
C     HARTIGAN, J. A. (1975) PRINTER GRAPHICS FOR CLUSTERING. JOURNAL OF
C        STATISTICAL COMPUTATION AND SIMULATION. VOLUME 4,PAGES 187-213.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      DIMENSION A(MM,*), XMIN(*), XMAX(*), NC(*)
      INTEGER OUNIT
      CHARACTER*4 CLAB(*)
      CHARACTER*10 TITLE
      CHARACTER*132 AAL
      CHARACTER*1 B, H, V, D, T, P,AA(122),AH(122)
      DATA B,H,V,D,T,P/' ','_','!','.',':','+'/
C
      IERR = 0
C
C     ADJUST RANGES
C
      DO 20 J=1,N
         IF(NC(J).LE.0) NC(J)=(122-N*2)/N
         IF(XMIN(J).GE.XMAX(J)) THEN
            CALL RANGE(M,A(1,J),XMIN(J),XMAX(J))
            IF(XMIN(J).EQ.XMAX(J)) RETURN
         ENDIF
   20 CONTINUE
      ISUM=0
      IF (OUNIT .GT. 0) WRITE(OUNIT,8)
C
C     CHECK LENGTH OF OUTPUT
C
      DO 30 I = 1,N
   30   ISUM=ISUM+NC(I)+2
      IF(ISUM+10 .GT. 132) THEN
         IERR = 1
         IF (OUNIT .GT. 0) WRITE(OUNIT,1)
    1    FORMAT(1X, 'PLOTS WILL USE MORE THAN 132 COLUMNS, DECREASE VALU
     *ES OF NC',/,1X,'OR SET ALL VALUES OF NC TO ZERO TO LET ROUTINE CAL
     *CULATE OPTIMAL VALUES OF NC')
         RETURN
      ENDIF
      IF (OUNIT .GT. 0) WRITE(OUNIT,2) TITLE
    2 FORMAT(' ALL PAIRS FROM ',A10)
C
C     SET UP STARTING POINT OF BLOCKS
C
      NC(1)=2
      DO 40 J=2,N+1
   40    NC(J)=NC(J-1)+NC(J)+2
C
C     SET UP HORIZONTAL LABELS OF PLOTS
C
      AAL(1:132)=B
      DO 60 I = 1,N
         IST=(NC(I)+NC(I+1))/2+7
   60    AAL(IST:IST+3)=CLAB(I)(1:4)
C
C     HORIZONTAL LINE OF CHARACTERS
C
      DO 70 I=1,122
   70    AH(I)=B
      DO 80 J=1,N
         JL=NC(J)
         JU=NC(J+1)-3
         DO 80 JJ=JL,JU
   80       AH(JJ)=H
C
C     PLOT A LINE AT A TIME
C
      DO 180 JC=1,N
         IF (OUNIT .GT. 0) THEN
            WRITE(OUNIT,3) AAL
            WRITE(OUNIT,6)(AH(I),I=1,122)
         ENDIF
    3    FORMAT(A132)
C
C     FIND VALUES CONDITIONAL ON JC
C
         JU=NC(JC+1)-NC(JC)-2
         DO 170 JP=1,JU
            DO 90 K=1,122
   90          AA(K)='0'
            DO 110 I=1,M
C
C      FIND VALUES IN THE JP-TH ROW AND PLACE THEM IN THE VECTOR AA
C
               IF(KC(A(I,JC),XMIN(JC),XMAX(JC),JU).EQ.JP) THEN
                  DO 100 J=1,N
                     JJ=NC(J+1)-NC(J)-2
                     K=KC(A(I,J),XMIN(J),XMAX(J),JJ)+NC(J)- 1
  100                AA(K)=CHAR(ICHAR(AA(K))+1)
               ENDIF
  110       CONTINUE
C
C     RECODE AA
C
            JL=NC(JC)
            L=ICHAR(AA(JL+JP-1)) - ICHAR('0')
            L=L+JL-1
            JJU=NC(JC+1)-3
            DO 120 K=JL,JJU
  120          AA(K)='0'
            DO 140 KK=1,3
               DO 130 K=JL,JJU
  130             IF(K.LE.L) AA(K)=CHAR(ICHAR(AA(K))+1)
  140          L=L-JJU+JL-1
            DO 150 K=1,122
               IF(AA(K).GT.'3') AA(K)='4'
               IF(AA(K).EQ.'0') AA(K)=B
               IF(AA(K).EQ.'1') AA(K)=D
               IF(AA(K).EQ.'2') AA(K)=T
  150          IF(AA(K).EQ.'3') AA(K)=P
            AA(1)=V
            DO 160 J=1,N
               AA(NC(J+1)-1)=V
  160          AA(NC(J+1)-2)=V
            AA(NC(N+1)-1)=B
C
C     TYPE AA
C
            IF (OUNIT .GT. 0) THEN
               IF(JP.EQ.1) WRITE(OUNIT,5) XMIN(JC),(AA(J),J=1,122)
               IF(JP.EQ.JU) WRITE(OUNIT,5) XMAX(JC),(AA(J),J=1,122)
               IF(JP.EQ.JU/2+1) WRITE(OUNIT,4) CLAB(JC),(AA(J),J=1,122)
               IF(JP.NE.1.AND.JP.NE.JU.AND.JP.NE.JU/2+1)
     *         WRITE(OUNIT,6) (AA(J),J=1,122)
            ENDIF
    4       FORMAT(5X,A4,1X,122A1)
    5       FORMAT(F10.3,122A1)
    6       FORMAT(10X,122A1)
  170    CONTINUE
         IF (OUNIT .GT. 0) THEN
            WRITE(OUNIT,7)(AH(I),I=1,122)
    7       FORMAT('+',9X,122A1)
            IF(4*((JC-1)/4).EQ.JC-1.AND.JC.NE.1) WRITE(OUNIT,8)
    8       FORMAT('1')
         ENDIF
  180 CONTINUE
      RETURN
      END
