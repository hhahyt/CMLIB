      SUBROUTINE CORTH(NM,N,LOW,IGH,AR,AI,ORTR,ORTI)
C***BEGIN PROLOGUE  CORTH
C***DATE WRITTEN   760101   (YYMMDD)
C***REVISION DATE  830518   (YYMMDD)
C***CATEGORY NO.  D4C1B2
C***KEYWORDS  EIGENVALUES,EIGENVECTORS,EISPACK
C***AUTHOR  SMITH, B. T., ET AL.
C***PURPOSE  Reduces complex general matrix to complex upper Hessenberg
C            using unitary similarity transformations.
C***DESCRIPTION
C
C     This subroutine is a translation of a complex analogue of
C     the ALGOL procedure ORTHES, NUM. MATH. 12, 349-368(1968)
C     by Martin and Wilkinson.
C     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 339-358(1971).
C
C     Given a COMPLEX GENERAL matrix, this subroutine
C     reduces a submatrix situated in rows and columns
C     LOW through IGH to upper Hessenberg form by
C     unitary similarity transformations.
C
C     On INPUT
C
C        NM must be set to the row dimension of two-dimensional
C          array parameters as declared in the calling program
C          dimension statement.
C
C        N is the order of the matrix.
C
C        LOW and IGH are integers determined by the balancing
C          subroutine  CBAL.  If  CBAL  has not been used,
C          set LOW=1, IGH=N.
C
C        AR and AI contain the real and imaginary parts,
C          respectively, of the complex input matrix.
C
C     On OUTPUT
C
C        AR and AI contain the real and imaginary parts,
C          respectively, of the Hessenberg matrix.  Information
C          about the unitary transformations used in the reduction
C          is stored in the remaining triangles under the
C          Hessenberg matrix.
C
C        ORTR and ORTI contain further information about the
C          transformations.  Only elements LOW through IGH are used.
C
C     Calls PYTHAG(A,B) for sqrt(A**2 + B**2).
C
C     Questions and comments should be directed to B. S. Garbow,
C     APPLIED MATHEMATICS DIVISION, ARGONNE NATIONAL LABORATORY
C     ------------------------------------------------------------------
C***REFERENCES  B. T. SMITH, J. M. BOYLE, J. J. DONGARRA, B. S. GARBOW,
C                 Y. IKEBE, V. C. KLEMA, C. B. MOLER, *MATRIX EIGEN-
C                 SYSTEM ROUTINES - EISPACK GUIDE*, SPRINGER-VERLAG,
C                 1976.
C***ROUTINES CALLED  PYTHAG
C***END PROLOGUE  CORTH
C
      INTEGER I,J,M,N,II,JJ,LA,MP,NM,IGH,KP1,LOW
      REAL AR(NM,N),AI(NM,N),ORTR(IGH),ORTI(IGH)
      REAL F,G,H,FI,FR,SCALE
      REAL PYTHAG
C
C***FIRST EXECUTABLE STATEMENT  CORTH
      LA = IGH - 1
      KP1 = LOW + 1
      IF (LA .LT. KP1) GO TO 200
C
      DO 180 M = KP1, LA
         H = 0.0E0
         ORTR(M) = 0.0E0
         ORTI(M) = 0.0E0
         SCALE = 0.0E0
C     .......... SCALE COLUMN (ALGOL TOL THEN NOT NEEDED) ..........
         DO 90 I = M, IGH
   90    SCALE = SCALE + ABS(AR(I,M-1)) + ABS(AI(I,M-1))
C
         IF (SCALE .EQ. 0.0E0) GO TO 180
         MP = M + IGH
C     .......... FOR I=IGH STEP -1 UNTIL M DO -- ..........
         DO 100 II = M, IGH
            I = MP - II
            ORTR(I) = AR(I,M-1) / SCALE
            ORTI(I) = AI(I,M-1) / SCALE
            H = H + ORTR(I) * ORTR(I) + ORTI(I) * ORTI(I)
  100    CONTINUE
C
         G = SQRT(H)
         F = PYTHAG(ORTR(M),ORTI(M))
         IF (F .EQ. 0.0E0) GO TO 103
         H = H + F * G
         G = G / F
         ORTR(M) = (1.0E0 + G) * ORTR(M)
         ORTI(M) = (1.0E0 + G) * ORTI(M)
         GO TO 105
C
  103    ORTR(M) = G
         AR(M,M-1) = SCALE
C     .......... FORM (I-(U*UT)/H) * A ..........
  105    DO 130 J = M, N
            FR = 0.0E0
            FI = 0.0E0
C     .......... FOR I=IGH STEP -1 UNTIL M DO -- ..........
            DO 110 II = M, IGH
               I = MP - II
               FR = FR + ORTR(I) * AR(I,J) + ORTI(I) * AI(I,J)
               FI = FI + ORTR(I) * AI(I,J) - ORTI(I) * AR(I,J)
  110       CONTINUE
C
            FR = FR / H
            FI = FI / H
C
            DO 120 I = M, IGH
               AR(I,J) = AR(I,J) - FR * ORTR(I) + FI * ORTI(I)
               AI(I,J) = AI(I,J) - FR * ORTI(I) - FI * ORTR(I)
  120       CONTINUE
C
  130    CONTINUE
C     .......... FORM (I-(U*UT)/H)*A*(I-(U*UT)/H) ..........
         DO 160 I = 1, IGH
            FR = 0.0E0
            FI = 0.0E0
C     .......... FOR J=IGH STEP -1 UNTIL M DO -- ..........
            DO 140 JJ = M, IGH
               J = MP - JJ
               FR = FR + ORTR(J) * AR(I,J) - ORTI(J) * AI(I,J)
               FI = FI + ORTR(J) * AI(I,J) + ORTI(J) * AR(I,J)
  140       CONTINUE
C
            FR = FR / H
            FI = FI / H
C
            DO 150 J = M, IGH
               AR(I,J) = AR(I,J) - FR * ORTR(J) - FI * ORTI(J)
               AI(I,J) = AI(I,J) + FR * ORTI(J) - FI * ORTR(J)
  150       CONTINUE
C
  160    CONTINUE
C
         ORTR(M) = SCALE * ORTR(M)
         ORTI(M) = SCALE * ORTI(M)
         AR(M,M-1) = -G * AR(M,M-1)
         AI(M,M-1) = -G * AI(M,M-1)
  180 CONTINUE
C
  200 RETURN
      END
