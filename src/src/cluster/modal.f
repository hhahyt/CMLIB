      SUBROUTINE MODAL(M, X, Y, XLAB, YLAB, PT, IXMX, IYMX, NBLOKS,
     *                 IWORK, WORK1, DMWRK2, WORK2, DMCWRK, CWORK,
     *                 OUNIT)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C      PRODUCES A BIVARIATE HISTOGRAM
C
C   DESCRIPTION
C   -----------
C
C   1.  A CONTINGENCY TABLE OF SIZE IXMX BY IYMX IS CALCULATED BETWEEN
C       THE TWO VARIABLES.  THEN THE ROUTINE DETERMINES THE BLOCK OF
C       THE TABLE WITH THE SMALLEST AREA WITH A GIVEN FREQUENCY.  THIS
C       BLOCK IS ADDED TO THE BLOCK LIST AND DELETED FROM THE TABLE.
C       THE PROCESS IS REPEATED AND THE SMALLEST BLOCK OF THE NEW TABLE
C       WITH THE GIVEN FREQUENCY IS FOUND.  THE ROUTINE STOPS WHEN THE
C       FREQUENCY OF THE ENTIRE TABLE IS LESS THAN THE GIVEN FREQUENCY.
C
C   2.  THE RESULTS ARE PRINTED ON FORTRAN UNIT OUNIT.  A RECTANGLE
C       ABOUT TWICE THE SIZE OF THE CONTINGENCY TABLE IS PRINTED, AND
C       THEN EACH BLOCK FROM SMALLEST TO LARGEST AREA IS ADDED TO THE
C       DIAGRAM.  IF A BLOCK OVERLAPS AN EXISTING BLOCK, THE SYMBOLS OF
C       THE EXISTING BLOCK WILL BE RETAINED.  THEREFORE, THE SMALLEST
C       BLOCKS WILL APPEAR COMPLETE.
C
C   INPUT PARAMETERS
C   ----------------
C
C   M     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF CASES.
C
C   X     REAL VECTOR DIMENSIONED AT LEAST M (UNCHANGED ON OUTPUT).
C         THE VALUES OF THE CASES FOR THE FIRST VARIABLE.
C
C   Y     REAL VECTOR DIMENSIONED AT LEAST M (UNCHANGED ON OUTPUT).
C         THE VALUES OF THE CASES FOR THE SECOND VARIABLE.
C
C   XLAB  4-CHARACTER VARIABLE (UNCHANGED ON OUTPUT).
C         THE LABEL OF THE FIRST VARIABLE.
C
C   YLAB  4-CHARACTER VARIABLE (UNCHANGED ON OUTPUT).
C         THE LABEL OF THE SECOND VARIABLE.
C
C   PT    REAL SCALAR (UNCHANGED ON OUTPUT).
C         THE FREQUENCY THRESHOLD FOR EACH BLOCK.
C
C   IXMX  INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF ROWS IN THE CONTINGENCY TABLE.
C
C   IYMX  INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF COLUMNS IN THE CONTINGENCY TABLE.
C
C   NBLOKS INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE MAXIMUM NUMBER OF BLOCKS.
C
C   IWORK INTEGER VECTOR DIMENSIONED AT LEAST 4*NBLOKS.
C         WORK VECTOR.
C
C   WORK1 REAL VECTOR DIMENSIONED AT LEAST 3*NBLOKS.
C         WORK VECTOR.
C
C   DMWRK2 INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE FIRST DIMENSION OF THE MATRIX WORK2.  MUST BE AT LEAST
C            IXMX.
C
C   WORK2 REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMWRK2 AND SECOND
C            DIMENSION MUST BE AT LEAST IYMX.
C         WORK MATRIX.
C
C   DMCRWK INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE FIRST DIMENSION OF THE MATRIX CWORK.  MUST BE AT LEAST
C            IXMX+IYMX+1.
C
C   CWORK MATRIX OF 1-CHARACTER VARIABLES WHOSE FIRST DIMENSION MUST BE
C            DMCWRK AND WHOSE SECOND DIMENSION MUST BE AT LEAST
C            IXMX+IYMX+1.
C         WORK MATRIX.
C
C   OUNIT INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         UNIT NUMBER FOR OUTPUT.
C
C   REFERENCES
C   ----------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGES 40, 50-51.
C
C     HARTIGAN, J. A. (1975) PRINTER GRAPHICS FOR CLUSTERING. JOURNAL OF
C        STATISTICAL COMPUTATION AND SIMULATION. VOLUME 4,PAGES 187-213.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      INTEGER DMWRK2, DMCWRK, OUNIT
      DIMENSION X(*), Y(*), WORK1(*), WORK2(DMWRK2,*), IWORK(*)
      CHARACTER*1 CWORK(DMCWRK,*)
      CHARACTER*4 XLAB, YLAB
C
      NB1 = 0
      NB2 = NB1 + NBLOKS
      NB3 = NB2 + NBLOKS
      NB4 = NB3 + NBLOKS
C
C     CALCULATE CONTINGENCY TABLE
C
      CALL TABL(M,X,Y,IXMX,IYMX,DMWRK2,WORK2)
C
C     FIND TOTAL FREQUENCY
C
      PP=0.
      PTOT=0.
      DO 10 I=1,IXMX
         DO 10 J=1,IYMX
   10       PTOT=PTOT+WORK2(I,J)
      K=0
C
C     INITIALIZE BLOCK SIZE
C
      FM=0.
      DO 20 I=1,IXMX
         DO 20 J=1,IYMX
   20       IF(WORK2(I,J).GT.FM) FM=WORK2(I,J)
      IF(FM.EQ.0.) RETURN
      LI=PT/FM
      IF(LI.LT.1) LI=1
      LJ=1
   30 K=K+1
C
C     INITIALIZE BLOCK PARAMETERS
C
      IWORK(NB1+K)=1
      IWORK(NB2+K)=1
      IWORK(NB3+K)=IXMX
      IWORK(NB4+K)=IYMX
      WORK1(NB1+K)=0.
      WORK1(NB2+K)=IXMX*IYMX
      WORK1(NB3+K)=0.
      IF(PP+PT.GT.PTOT) GOTO 90
   40 CONTINUE
      DO 60 I1=1,IXMX
         I2=I1+LI-1
         IF(I2.GT.IXMX) GO TO 60
         DO 50 J1=1,IYMX
C
C     FIND BLOCK EXCEEDING THRESHOLD OF MINIMUM AREA
C
            J2=J1+LJ-1
            IF(J2.GT.IYMX) GO TO 50
            CALL DENSTY(I1,I2,J1,J2,DMWRK2,WORK2,P,A)
            IF(P.GE.PT) THEN
               IF(P/A.GE.WORK1(NB3+K).AND.A.LE.WORK1(NB2+K)) THEN
                  IWORK(NB1+K)=I1
                  IWORK(NB2+K)=J1
                  IWORK(NB3+K)=I2
                  IWORK(NB4+K)=J2
                  WORK1(NB1+K)=P
                  WORK1(NB2+K)=A
                  WORK1(NB3+K)=P/A
               ENDIF
            ENDIF
   50    CONTINUE
   60 CONTINUE
C
C     INCREASE SMALLEST POSSIBLE BLOCK
C
      IF(WORK1(NB1+K).NE.0.) GO TO 80
      II=LI
      JJ=LJ
      MIN=IXMX*IYMX
      DO 70 I=1,IXMX
         DO 70 J=1,IYMX
            ITJ=I*J
            IF((ITJ.GE.LI*LJ.AND.ITJ.LE.MIN).AND.(ITJ.NE.LI*LJ.OR.
     *          J.GT.LJ)) THEN
               II=I
               JJ=J
               MIN=I*J
            ENDIF
   70 CONTINUE
      LI=II
      LJ=JJ
      IF(MIN.LT.IXMX*IYMX) GO TO 40
   80 CONTINUE
C
C     REPLACE FREQUENCIES IN THE CHOSEN BLOCK
C
      CALL PLACE(IWORK(NB1+K),IWORK(NB3+K),IWORK(NB2+K),IWORK(NB4+K),
     *           DMWRK2,WORK2,WORK1(NB3+K))
      PP=PP+WORK1(NB1+K)
      IF(K.LT.50) GO TO 30
   90 IF (OUNIT .GT. 0) THEN
         WRITE(OUNIT,1)XLAB, YLAB
    1    FORMAT('1',A4,'(VERT)   VS   ',A4,'(HORZ)')
         CALL BDRAW(NBLOKS,IWORK,K,IXMX+IYMX+1,DMCWRK,CWORK,OUNIT)
      ENDIF
      RETURN
      END
