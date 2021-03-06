      SUBROUTINE XDCON(X,IX)
C***BEGIN PROLOGUE  XDCON
C***DATE WRITTEN   820712   (YYMMDD)
C***REVISION DATE  831027   (YYMMDD)
C***CATEGORY NO.  A3d
C***KEYWORDS  EXTENDED-RANGE DOUBLE-PRECISION ARITHMETIC
C***AUTHOR  LOZIER, DANIEL W. (NATIONAL BUREAU OF STANDARDS)
C           SMITH, JOHN M. (NBS AND GEORGE MASON UNIVERSITY)
C***PURPOSE  TO PROVIDE DOUBLE-PRECISION FLOATING-POINT ARITHMETIC
C            WITH AN EXTENDED EXPONENT RANGE
C***DESCRIPTION
C     DOUBLE PRECISION X
C     INTEGER IX
C
C                  CONVERTS (X,IX) = X*RADIX**IX
C                  TO DECIMAL FORM IN PREPARATION FOR
C                  PRINTING, SO THAT (X,IX) = X*10**IX
C                  WHERE 1/10 .LE. ABS(X) .LT. 1
C                  IS RETURNED, EXCEPT THAT IF
C                  (DABS(X),IX) IS BETWEEN RADIX**(-2L)
C                  AND RADIX**(2L) THEN THE REDUCED
C                  FORM WITH IX = 0 IS RETURNED.
C
C***REFERENCES (PROGRAM LISTING FOR XDSET)
C***ROUTINES CALLED  XDADJ, XDC210, XDRED
C***COMMON BLOCKS    XDBLK2
C***END PROLOGUE  XDCON
      DOUBLE PRECISION X
      INTEGER IX
C
C   THE CONDITIONS IMPOSED ON L AND KMAX BY THIS SUBROUTINE
C ARE
C    (1) 4 .LE. L .LE. 2**NBITS - 1 - KMAX
C
C    (2) KMAX .LE. ((2**NBITS)-2)/LOG10R - L
C
C THESE CONDITIONS MUST BE MET BY APPROPRIATE CODING
C IN SUBROUTINE XDSET.
C
      DOUBLE PRECISION RADIX, RADIXL, RAD2L, DLG10R
      INTEGER L, L2, KMAX
      COMMON /XDBLK2/ RADIX, RADIXL, RAD2L, DLG10R, L, L2, KMAX
      SAVE /XDBLK2/
C
      DOUBLE PRECISION A, B, Z
C
      DATA ISPACE /1/
C   THE PARAMETER ISPACE IS THE INCREMENT USED IN FORM-
C ING THE AUXILIARY INDEX OF THE DECIMAL EXTENDED-RANGE
C FORM. THE RETURNED VALUE OF IX WILL BE AN INTEGER MULT-
C IPLE OF ISPACE. ISPACE MUST SATISFY 1 .LE. ISPACE .LE.
C L/2. IF A VALUE GREATER THAN 1 IS TAKEN, THE RETURNED
C VALUE OF X WILL SATISFY 10**(-ISPACE) .LE. DABS(X) .LE. 1
C WHEN (DABS(X),IX) .LT. RADIX**(-2L), AND 1/10 .LE. DABS(X)
C .LT. 10**(ISPACE-1) WHEN (DABS(X),IX) .GT. RADIX**(2L).
C
C***FIRST EXECUTABLE STATEMENT  XDCON
      CALL XDRED(X, IX)
      IF (IX.EQ.0) GO TO 150
      CALL XDADJ(X, IX)
C
C CASE 1 IS WHEN (X,IX) IS LESS THAN RADIX**(-2L) IN MAGNITUDE,
C CASE 2 IS WHEN (X,IX) IS GREATER THAN RADIX**(2L) IN MAGNITUDE.
      ITEMP = 1
      ICASE = (3+ISIGN(ITEMP,IX))/2
      GO TO (10, 20), ICASE
   10 IF (DABS(X).LT.1.0D0) GO TO 30
      X = X/RADIXL
      IX = IX + L
      GO TO 30
   20 IF (DABS(X).GE.1.0D0) GO TO 30
      X = X*RADIXL
      IX = IX - L
   30 CONTINUE
C
C AT THIS POINT, RADIX**(-L) .LE. DABS(X) .LT. 1.0D0     IN CASE 1,
C                      1.0D0 .LE. DABS(X) .LT. RADIX**L  IN CASE 2.
      I = DLOG10(DABS(X))/DLG10R
      A = RADIX**I
      GO TO (40, 60), ICASE
   40 IF (A.LE.RADIX*DABS(X)) GO TO 50
      I = I - 1
      A = A/RADIX
      GO TO 40
   50 IF (DABS(X).LT.A) GO TO 80
      I = I + 1
      A = A*RADIX
      GO TO 50
   60 IF (A.LE.DABS(X)) GO TO 70
      I = I - 1
      A = A/RADIX
      GO TO 60
   70 IF (DABS(X).LT.RADIX*A) GO TO 80
      I = I + 1
      A = A*RADIX
      GO TO 70
   80 CONTINUE
C
C AT THIS POINT I IS SUCH THAT
C RADIX**(I-1) .LE. DABS(X) .LT. RADIX**I      IN CASE 1,
C     RADIX**I .LE. DABS(X) .LT. RADIX**(I+1)  IN CASE 2.
      ITEMP = DBLE(FLOAT(ISPACE))/DLG10R
      A = RADIX**ITEMP
      B = 10.0D0**ISPACE
   90 IF (A.LE.B) GO TO 100
      ITEMP = ITEMP - 1
      A = A/RADIX
      GO TO 90
  100 IF (B.LT.A*RADIX) GO TO 110
      ITEMP = ITEMP + 1
      A = A*RADIX
      GO TO 100
  110 CONTINUE
C
C AT THIS POINT ITEMP IS SUCH THAT
C RADIX**ITEMP .LE. 10**ISPACE .LT. RADIX**(ITEMP+1).
      IF (ITEMP.GT.0) GO TO 120
C ITEMP = 0 IF, AND ONLY IF, ISPACE = 1 AND RADIX = 16.0D0
      X = X*RADIX**(-I)
      IX = IX + I
      CALL XDC210(IX, Z, J)
      X = X*Z
      IX = J
      GO TO (130, 140), ICASE
  120 CONTINUE
      I1 = I/ITEMP
      X = X*RADIX**(-I1*ITEMP)
      IX = IX + I1*ITEMP
C
C AT THIS POINT,
C RADIX**(-ITEMP) .LE. DABS(X) .LT. 1.0D0        IN CASE 1,
C           1.0D0 .LE. DABS(X) .LT. RADIX**ITEMP IN CASE 2.
      CALL XDC210(IX, Z, J)
      J1 = J/ISPACE
      J2 = J - J1*ISPACE
      X = X*Z*10.0D0**J2
      IX = J1*ISPACE
C
C AT THIS POINT,
C  10.0D0**(-2*ISPACE) .LE. DABS(X) .LT. 1.0D0                IN CASE 1,
C           10.0D0**-1 .LE. DABS(X) .LT. 10.0D0**(2*ISPACE-1) IN CASE 2.
      GO TO (130, 140), ICASE
  130 IF (B*DABS(X).GE.1.0D0) GO TO 150
      X = X*B
      IX = IX - ISPACE
      GO TO 130
  140 IF (10.0D0*DABS(X).LT.B) GO TO 150
      X = X/B
      IX = IX + ISPACE
      GO TO 140
  150 RETURN
      END
