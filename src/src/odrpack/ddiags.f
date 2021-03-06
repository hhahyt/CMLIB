*DDIAGS
      SUBROUTINE DDIAGS
     +   (N,M,S,LDS,V,LDV,SV,LDSV)
C***BEGIN PROLOGUE  DDIAGS
C***REFER TO  DODR,DODRC
C***ROUTINES CALLED  (NONE)
C***DATE WRITTEN   860529   (YYMMDD)
C***REVISION DATE  870204   (YYMMDD)
C***CATEGORY NO.  G2E,I1B1
C***KEYWORDS  ORTHOGONAL DISTANCE REGRESSION,
C             NONLINEAR LEAST SQUARES,
C             ERRORS IN VARIABLES
C***AUTHOR  BOGGS, PAUL T.
C             OPTIMIZATION GROUP/SCIENTIFIC COMPUTING DIVISION
C             NATIONAL BUREAU OF STANDARDS, GAITHERSBURG, MD 20899
C           BYRD, RICHARD H.
C             DEPARTMENT OF COMPUTER SCIENCE
C             UNIVERSITY OF COLORADO, BOULDER, CO 80309
C           DONALDSON, JANET R.
C             OPTIMIZATION GROUP/SCIENTIFIC COMPUTING DIVISION
C             NATIONAL BUREAU OF STANDARDS, BOULDER, CO 80303-3328
C           SCHNABEL, ROBERT B.
C             DEPARTMENT OF COMPUTER SCIENCE
C             UNIVERSITY OF COLORADO, BOULDER, CO 80309
C             AND
C             OPTIMIZATION GROUP/SCIENTIFIC COMPUTING DIVISION
C             NATIONAL BUREAU OF STANDARDS, BOULDER, CO 80303-3328
C***PURPOSE  SCALE THE VECTOR V BY THE DIAGONAL MATRIX S
C            AND RETURN THE RESULT IN VECTOR SV.
C***END PROLOGUE  DDIAGS
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      INTEGER I
C        AN INDEXING VARIABLE.
      INTEGER J
C        AN INDEXING VARIABLE.
      INTEGER LDS
C        THE LEADING DIMENSION OF ARRAY S.
      INTEGER LDSV
C        THE LEADING DIMENSION OF ARRAY SV.
      INTEGER LDV
C        THE LEADING DIMENSION OF ARRAY V.
      INTEGER M
C        THE NUMBER OF COLUMNS OF DATA IN THE INDEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER N
C        THE NUMBER OF OBSERVATIONS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION S(LDS,M)
C        THE SCALING ARRAY.
      DOUBLE PRECISION SV(LDSV,M)
C        THE SCALED ARRAY.
      DOUBLE PRECISION V(LDV,M)
C        THE ARRAY BEING SCALED.
      DOUBLE PRECISION ZERO
C          THE VALUE 0.0D0.
C
C
      DATA ZERO/0.0D0/
C
C
C***FIRST EXECUTABLE STATEMENT  DDIAGS
C
C
      IF (N.EQ.0 .OR. M.EQ.0) RETURN
C
      IF (S(1,1).LT.ZERO) THEN
         DO 20 J=1,M
            DO 10 I=1,N
               SV(I,J) = ABS(S(1,1))*V(I,J)
   10       CONTINUE
   20    CONTINUE
      ELSE
         IF (LDS.EQ.1) THEN
            DO 40 J=1,M
               DO 30 I=1,N
                  SV(I,J) = S(1,J)*V(I,J)
   30          CONTINUE
   40       CONTINUE
         ELSE
            DO 60 J=1,M
               DO 50 I=1,N
                  SV(I,J) = S(I,J)*V(I,J)
   50          CONTINUE
   60       CONTINUE
         END IF
      END IF
C
      RETURN
      END
