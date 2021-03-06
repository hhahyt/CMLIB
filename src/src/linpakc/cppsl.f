      SUBROUTINE CPPSL(AP,N,B)
C***BEGIN PROLOGUE  CPPSL
C***DATE WRITTEN   780814   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C***CATEGORY NO.  D2D1B
C***KEYWORDS  COMPLEX,LINEAR ALGEBRA,LINPACK,MATRIX,PACKED,
C             POSITIVE DEFINITE,SOLVE
C***AUTHOR  MOLER, C. B., (U. OF NEW MEXICO)
C***PURPOSE  Solves the COMPLEX HERMITIAN POSITIVE DEFINITE system
C            A*X=B using the factors computed by CPPCO or CPPFA.
C***DESCRIPTION
C
C     CPPSL solves the complex Hermitian positive definite system
C     A * X = B
C     using the factors computed by CPPCO or CPPFA.
C
C     On Entry
C
C        AP      COMPLEX (N*(N+1)/2)
C                the output from CPPCO or CPPFA.
C
C        N       INTEGER
C                the order of the matrix  A .
C
C        B       COMPLEX(N)
C                the right hand side vector.
C
C     On Return
C
C        B       the solution vector  X .
C
C     Error Condition
C
C        A division by zero will occur if the input factor contains
C        a zero on the diagonal.  Technically this indicates
C        singularity but it is usually caused by improper subroutine
C        arguments.  It will not occur if the subroutines are called
C        correctly and  INFO .EQ. 0 .
C
C     To compute  INVERSE(A) * C  where  C  is a matrix
C     with  P  columns
C           CALL CPPCO(AP,N,RCOND,Z,INFO)
C           IF (RCOND is too small .OR. INFO .NE. 0) GO TO ...
C           DO 10 J = 1, P
C              CALL CPPSL(AP,N,C(1,J))
C        10 CONTINUE
C
C     LINPACK.  This version dated 08/14/78 .
C     Cleve Moler, University of New Mexico, Argonne National Lab.
C
C     Subroutines and Functions
C
C     BLAS CAXPY,CDOTC
C***REFERENCES  DONGARRA J.J., BUNCH J.R., MOLER C.B., STEWART G.W.,
C                 *LINPACK USERS  GUIDE*, SIAM, 1979.
C***ROUTINES CALLED  CAXPY,CDOTC
C***END PROLOGUE  CPPSL
      INTEGER N
      COMPLEX AP(*),B(*)
C
      COMPLEX CDOTC,T
      INTEGER K,KB,KK
C***FIRST EXECUTABLE STATEMENT  CPPSL
      KK = 0
      DO 10 K = 1, N
         T = CDOTC(K-1,AP(KK+1),1,B(1),1)
         KK = KK + K
         B(K) = (B(K) - T)/AP(KK)
   10 CONTINUE
      DO 20 KB = 1, N
         K = N + 1 - KB
         B(K) = B(K)/AP(KK)
         KK = KK - K
         T = -B(K)
         CALL CAXPY(K-1,T,AP(KK+1),1,B(1),1)
   20 CONTINUE
      RETURN
      END
