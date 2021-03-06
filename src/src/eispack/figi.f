      SUBROUTINE FIGI(NM,N,T,D,E,E2,IERR)
C***BEGIN PROLOGUE  FIGI
C***DATE WRITTEN   760101   (YYMMDD)
C***REVISION DATE  830518   (YYMMDD)
C***CATEGORY NO.  D4C1C
C***KEYWORDS  EIGENVALUES,EIGENVECTORS,EISPACK
C***AUTHOR  SMITH, B. T., ET AL.
C***PURPOSE  Transforms certain real non-symmetric tridiagonal matrix
C            to symmetric tridiagonal matrix.
C***DESCRIPTION
C
C     Given a NONSYMMETRIC TRIDIAGONAL matrix such that the products
C     of corresponding pairs of off-diagonal elements are all
C     non-negative, this subroutine reduces it to a symmetric
C     tridiagonal matrix with the same eigenvalues.  If, further,
C     a zero product only occurs when both factors are zero,
C     the reduced matrix is similar to the original matrix.
C
C     On INPUT
C
C        NM must be set to the row dimension of two-dimensional
C          array parameters as declared in the calling program
C          dimension statement.
C
C        N is the order of the matrix.
C
C        T contains the input matrix.  Its subdiagonal is
C          stored in the last N-1 positions of the first column,
C          its diagonal in the N positions of the second column,
C          and its superdiagonal in the first N-1 positions of
C          the third column.  T(1,1) and T(N,3) are arbitrary.
C
C     On OUTPUT
C
C        T is unaltered.
C
C        D contains the diagonal elements of the symmetric matrix.
C
C        E contains the subdiagonal elements of the symmetric
C          matrix in its last N-1 positions.  E(1) is not set.
C
C        E2 contains the squares of the corresponding elements of E.
C          E2 may coincide with E if the squares are not needed.
C
C        IERR is set to
C          Zero       for normal return,
C          N+I        if T(I,1)*T(I-1,3) is negative,
C          -(3*N+I)   if T(I,1)*T(I-1,3) is zero with one factor
C                     non-zero.  In this case, the eigenvectors of
C                     the symmetric matrix are not simply related
C                     to those of  T  and should not be sought.
C
C     Questions and comments should be directed to B. S. Garbow,
C     APPLIED MATHEMATICS DIVISION, ARGONNE NATIONAL LABORATORY
C     ------------------------------------------------------------------
C***REFERENCES  B. T. SMITH, J. M. BOYLE, J. J. DONGARRA, B. S. GARBOW,
C                 Y. IKEBE, V. C. KLEMA, C. B. MOLER, *MATRIX EIGEN-
C                 SYSTEM ROUTINES - EISPACK GUIDE*, SPRINGER-VERLAG,
C                 1976.
C***ROUTINES CALLED  (NONE)
C***END PROLOGUE  FIGI
C
      INTEGER I,N,NM,IERR
      REAL T(NM,3),D(N),E(N),E2(N)
C
C***FIRST EXECUTABLE STATEMENT  FIGI
      IERR = 0
C
      DO 100 I = 1, N
         IF (I .EQ. 1) GO TO 90
         E2(I) = T(I,1) * T(I-1,3)
         IF (E2(I)) 1000, 60, 80
   60    IF (T(I,1) .EQ. 0.0E0 .AND. T(I-1,3) .EQ. 0.0E0) GO TO 80
C     .......... SET ERROR -- PRODUCT OF SOME PAIR OF OFF-DIAGONAL
C                ELEMENTS IS ZERO WITH ONE MEMBER NON-ZERO ..........
         IERR = -(3 * N + I)
   80    E(I) = SQRT(E2(I))
   90    D(I) = T(I,2)
  100 CONTINUE
C
      GO TO 1001
C     .......... SET ERROR -- PRODUCT OF SOME PAIR OF OFF-DIAGONAL
C                ELEMENTS IS NEGATIVE ..........
 1000 IERR = N + I
 1001 RETURN
      END
