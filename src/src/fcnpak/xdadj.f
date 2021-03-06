      SUBROUTINE XDADJ(X,IX)
C***BEGIN PROLOGUE  XDADJ
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
C                  TRANSFORMS (X,IX) SO THAT
C                  RADIX**(-L) .LE. DABS(X) .LT. RADIX**L.
C                  ON MOST COMPUTERS THIS TRANSFORMATION DOES
C                  NOT CHANGE THE MANTISSA OF X PROVIDED RADIX IS
C                  THE NUMBER BASE OF DOUBLE-PRECISION ARITHMETIC.
C
C***REFERENCES  (PROGRAM LISTING FOR XDSET)
C***ROUTINES CALLED  XERROR
C***COMMON BLOCKS    XDBLK2
C***END PROLOGUE  XDADJ
      DOUBLE PRECISION X
      INTEGER IX
      DOUBLE PRECISION RADIX, RADIXL, RAD2L, DLG10R
      INTEGER L, L2, KMAX
      COMMON /XDBLK2/ RADIX, RADIXL, RAD2L, DLG10R, L, L2, KMAX
      SAVE /XDBLK2/
C
C   THE CONDITION IMPOSED ON L AND KMAX BY THIS SUBROUTINE
C IS
C     2*L .LE. KMAX
C
C THIS CONDITION MUST BE MET BY APPROPRIATE CODING
C IN SUBROUTINE XDSET.
C
C***FIRST EXECUTABLE STATEMENT  XDADJ
      IF (X.EQ.0.0D0) GO TO 50
      IF (DABS(X).GE.1.0D0) GO TO 20
      IF (RADIXL*DABS(X).GE.1.0D0) GO TO 60
      X = X*RAD2L
      IF (IX.LT.0) GO TO 10
      IX = IX - L2
      GO TO 70
   10 IF (IX.LT.-KMAX+L2) GO TO 40
      IX = IX - L2
      GO TO 70
   20 IF (DABS(X).LT.RADIXL) GO TO 60
      X = X/RAD2L
      IF (IX.GT.0) GO TO 30
      IX = IX + L2
      GO TO 70
   30 IF (IX.GT.KMAX-L2) GO TO 40
      IX = IX + L2
      GO TO 70
   40 CALL XERROR('Err in XDADJ...overflow in auxiliary index',42,1,1)
      RETURN
   50 IX = 0
   60 IF (IABS(IX).GT.KMAX) GO TO 40
   70 RETURN
      END
