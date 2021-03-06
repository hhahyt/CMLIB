      SUBROUTINE MIXOUT(MM, M, N, A, CLAB, RLAB, TITLE, K, DMWORK,
     *                  WORK1, WORK2, OUNIT)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C      PRINTS THE RESULTS FOR EACH ITERATION OF MIXIND
C
C   DESCRIPTION
C   -----------
C
C   1.  SEE SUBROUTINE MIXIND FOR DESCRIPTION OF OUTPUT.
C
C   INPUT PARAMETERS
C   ----------------
C
C   K     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE CURRENT NUMBER OF CLUSTERS.
C
C   FOR OTHER PARAMETERS -- SEE SUBROUTINE MIXIND
C
C   REFERENCE
C   ---------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGE 129.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      INTEGER DMWORK, U, P, PMIX, OUNIT
      DIMENSION A(MM,*), WORK1(DMWORK,*), WORK2(*)
      CHARACTER*4 CLAB(*), RLAB(*)
      CHARACTER*10 TITLE
C
      U = 0
      P = U + N
      PMIX = P + M + 1
      WRITE(OUNIT,1) TITLE,K
    1 FORMAT('1 MIXTURE MODEL FOR',2X,A10,'WITH',I5,' CLUSTERS')
C
C     PRINT VARIANCES
C
      WRITE(OUNIT,2)(WORK2(J),CLAB(J),J=1,N)
    2 FORMAT('0 WITHIN CLUSTER VARIANCES',/5(F15.6,'(',A4,')'))
C
C     PRINT CLUSTER PROBABILITIES
C
      WRITE(OUNIT,3)(KK,KK=1,K)
    3 FORMAT(9X,' CLUSTER', 9(I3,1X,' CLUSTER'))
      WRITE(OUNIT,4)(WORK1(PMIX,KK),KK=1,K)
    4 FORMAT('0 MIXTURE PROBABILITIES',/(7X,10F12.6))
C
C     PRINT MEANS
C
      WRITE(OUNIT,5)
    5 FORMAT('0 CLUSTER MEANS')
      DO 10 J=1,N
   10    WRITE(OUNIT,6) CLAB(J),(WORK1(U+J,KK),KK=1,K)
    6 FORMAT(1X,A4,2X,10F12.4)
C
C     PRINT PROBABILITIES
C
      WRITE(OUNIT,7)
    7 FORMAT('0 BELONGING PROBABILITIES')
      DO 20 I=1,M
   20    WRITE(OUNIT,8) RLAB(I),(WORK1(P+I,KK),KK=1,K)
    8 FORMAT(1X,A4,2X,10F12.6)
      RETURN
      END
