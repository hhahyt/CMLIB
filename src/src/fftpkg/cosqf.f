      SUBROUTINE COSQF(N,X,WSAVE)
C***BEGIN PROLOGUE  COSQF
C***DATE WRITTEN   790601   (YYMMDD)
C***REVISION DATE  830401   (YYMMDD)
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C
C***CATEGORY NO.  J1A3
C***KEYWORDS  FOURIER TRANSFORM
C***AUTHOR  SWARZTRAUBER, P. N., (NCAR)
C***PURPOSE  Forward cosine transform with odd wave numbers.
C***DESCRIPTION
C
C  Subroutine COSQF computes the fast Fourier transform of quarter
C  wave data. That is, COSQF computes the coefficients in a cosine
C  series representation with only odd wave numbers.  The transform
C  is defined below at Output Parameter X
C
C  COSQF is the unnormalized inverse of COSQB since a call of COSQF
C  followed by a call of COSQB will multiply the input sequence X
C  by 4*N.
C
C  The array WSAVE which is used by subroutine COSQF must be
C  initialized by calling subroutine COSQI(N,WSAVE).
C
C
C  Input Parameters
C
C  N       the length of the array X to be transformed.  The method
C          is most efficient when N is a product of small primes.
C
C  X       an array which contains the sequence to be transformed
C
C  WSAVE   a work array which must be dimensioned at least 3*N+15
C          in the program that calls COSQF.  The WSAVE array must be
C          initialized by calling subroutine COSQI(N,WSAVE), and a
C          different WSAVE array must be used for each different
C          value of N.  This initialization does not have to be
C          repeated so long as N remains unchanged.  Thus subsequent
C          transforms can be obtained faster than the first.
C
C  Output Parameters
C
C  X       For I=1,...,N
C
C               X(I) = X(1) plus the sum from K=2 to K=N of
C
C                  2*X(K)*COS((2*I-1)*(K-1)*PI/(2*N))
C
C               A call of COSQF followed by a call of
C               COSQB will multiply the sequence X by 4*N.
C               Therefore COSQB is the unnormalized inverse
C               of COSQF.
C
C  WSAVE   contains initialization calculations which must not
C          be destroyed between calls of COSQF or COSQB.
C***REFERENCES  (NONE)
C***ROUTINES CALLED  COSQF1
C***END PROLOGUE  COSQF
      DIMENSION       X(*)       ,WSAVE(*)
      DATA SQRT2 /1.4142135623731/
C***FIRST EXECUTABLE STATEMENT  COSQF
      IF (N-2) 102,101,103
  101 TSQX = SQRT2*X(2)
      X(2) = X(1)-TSQX
      X(1) = X(1)+TSQX
  102 RETURN
  103 CALL COSQF1 (N,X,WSAVE,WSAVE(N+1))
      RETURN
      END
