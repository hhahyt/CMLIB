      SUBROUTINE D9UPAK(X,Y,N)
C***BEGIN PROLOGUE  D9UPAK
C***DATE WRITTEN   780701   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***CATEGORY NO.  A6B
C***KEYWORDS  FNLIB,UNPACK
C***AUTHOR  FULLERTON, W., (LANL)
C***PURPOSE  Unpack a double precision floating point no. x so that
C            X=Y*2**N.
C***DESCRIPTION
C
C Unpack floating point number X so that X = Y * 2.0**N, where
C 0.5 .LE. ABS(Y) .LT. 1.0.
C***REFERENCES  (NONE)
C***ROUTINES CALLED  (NONE)
C***END PROLOGUE  D9UPAK
       DOUBLE PRECISION X,Y,ABSX
C***FIRST EXECUTABLE STATEMENT  D9UPAK
       ABSX =DABS(X)
       N=0
       IF(X.EQ.0.0D0) GO TO 30
C
 10    IF(ABSX.GE.0.05D0) GO TO 20
       N=N-1
       ABSX = ABSX*2.0D0
       GO TO 10
C
 20    IF(ABSX.LT.1.0D0)GO TO 30
       N=N+1
       ABSX=ABSX*0.5D0
       GO TO 20
C
 30    Y=DSIGN(ABSX,X)
       RETURN
C
      END
