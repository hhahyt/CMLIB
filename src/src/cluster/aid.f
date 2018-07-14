 
      SUBROUTINE AID(MM, M, N, A, CLAB, RLAB, JP, TH, K, DMIWRK, IWORK,
     *               DMWRK1, WORK1, WORK2, OUNIT)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C     FORMS A TREE OF CLUSTERS BY SPLITTING CASES ON VALUES OF
C     INDIVIDUAL VARIABLES TO MINIMIZE THE SUM OF THE SQUARED
C     DEVIATIONS FROM THE CLUSTER MEANS.  THE TREE CAN BE USED TO
C     PREDICT THE VALUE OF A DIFFERENT VARIABLE FOR A NEW CASE.
C
C   DESCRIPTION
C   -----------
C
C   1.  THE ROUTINE STARTS WITH ONE CLUSTER OF ALL CASES, AND AT EACH
C       ITERATION SPLITS A CLUSTER INTO TWO CLUSTERS OF CASES ACCORDING
C       AS A(I,J) > C OR A(I,J) <= C, WHERE A IS THE DATA MATRIX AND I
C       ARE THE CASES.  THE VARIABLE J AND THE CONSTANT C ARE CHOSEN
C       WHICH MINIMIZE THE SUM OF THE SQUARED WITHIN-CLUSTER DEVIATIONS
C       OF THE VARIABLE TO BE PREDICTED.  IF THE REDUCTION IN THE SUM
C       OF SQUARES FOR THE CLUSTER WHICH WAS SPLIT IS GREATER THAN THE
C       THRESHOLD, THE SPLIT IS PERFORMED, OTHERWISE IT IS IGNORED.
C       THIS ROUTINE STOPS WHEN NO CLUSTER CAN BE SPLIT SUCH THAT THE
C       SUM OF SQUARES IS REDUCED BY MORE THAN THE THRESHOLD.
C
C   2.  THE CASES ARE SORTED SUCH THAT EACH CLUSTER IS CONTIGUOUS IN
C       THE ORDER.  THE OUTPUT IS WRITTEN ON FORTRAN UNIT OUNIT AND
C       BEGINS WITH THE PRINTING OF THE SORTED LIST OF THE CASES.
C       THEN, A TREE OF CLUSTERS ARE PRINTED OUT ALONG WITH THEIR
C       SUMMARY STATISTICS.  THE CASES BELONGING TO EACH CLUSTER ARE
C       THE CASES IN THE SORTED ORDER THAT ARE BETWEEN THE FIRST AND
C       LAST CASE.  THE VARIABLE THAT PRODUCES THE OPTIMUM SPLIT OF THE
C       CLUSTER, THE SPLIT POINT, AND THE REDUCTION IN THE SUM OF
C       SQUARES BY THE SPLIT ARE PRINTED.  IF THE REDUCTION IS
C       NEGATIVE, THE SPLIT WAS PERFORMED; OTHERWISE, THE SPLIT WAS
C       IGNORED.  THE MEAN AND THE VARIANCE OF THE PREDICTED VARIABLE
C       AND THE NUMBER OF ELEMENTS FOR EACH CLUSTER ARE ALSO DISPLAYED.
C
C   3.  TO PRODUCE THE TREE, USE THE FIRST CLUSTER AS THE ROOT.  IF THE
C       SUM OF SQUARES REDUCTION IS NEGATIVE, THIS CLUSTER WAS SPLIT ON
C       THE GIVEN SPLIT VARIABLE AT THE SPLIT POINT.  LOOK FOR THE NEXT
C       CLUSTER WITH THE SAME FIRST CASE AND MAKE THAT CLUSTER THE LEFT
C       SON OF THE ROOT.  THIS BRANCH CORRESPONDS TO CASES WHOSE SPLIT
C       VARIABLE HAS A VALUE LESS THAN OR EQUAL TO THE SPLIT POINT.
C       THE RIGHT SON IS THE FIRST CLUSTER IN THE LIST WHOSE LAST CASE
C       IS THE SAME AS THE LAST CASE OF THE ROOT CLUSTER, AND HAS THE
C       VALUE OF THE SPLIT VARIABLE GREATER THAN THE SPLIT POINT.
C       CONTINUE FOR EACH CLUSTER UNTIL NO CLUSTERS ARE SPLIT.  THE
C       NODES AT THE BOTTOM OF THE TREE ARE THE FINAL CLUSTERS.
C
C   4.  FOR AN EXISTING CASE, FIND THE FINAL CLUSTER IT BELONGS TO BY
C       MOVING DOWN THE TREE DETERMINED BY THE SPLITS USING THE KNOWN
C       VALUES.  THEN, THE VALUE FOR THE VARIABLE TO BE PREDICTED FOR
C       THIS CASE IS THE MEAN OF THAT VARIABLE FOR THE CASES IN THAT
C       FINAL CLUSTER.  THIS MEAN VALUE AND ITS VARIANCE IS PRINTED IN
C       THE LAST TWO COLUMNS OF THE OUTPUT.
C
C   INPUT PARAMETERS
C   ----------------
C
C   MM    INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF MATRIX A.  MUST BE AT LEAST M.
C
C   M     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF CASES.
C
C   N     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF VARIABLES.
C
C   A     REAL MATRIX WHOSE FIRST DIMENSION MUST BE MM AND SECOND
C            DIMENSION MUST BE AT LEAST M (CHANGED ON OUTPUT).
C         THE DATA MATRIX.
C
C         A(I,J) IS THE VALUE FOR THE J-TH VARIABLE FOR THE I-TH CASE.
C
C   CLAB  VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST N
C            (CHANGED ON OUTPUT).
C         ORDERED LABELS OF THE COLUMNS.
C
C   RLAB  VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST M
C            (CHANGED ON OUTPUT).
C         ORDERED LABELS OF THE ROWS.
C
C   JP    INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         NUMBER OF VARIABLE TO BE PREDICTED.  MUST BE BETWEEN 1 AND N.
C
C   TH    REAL SCALAR (UNCHANGED ON OUTPUT).
C         THRESHOLD VARIANCE FOR SUM OF SQUARES REDUCTION.
C
C   K     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         MAXIMUM NUMBER OF CLUSTERS TO BE FORMED.  SHOULD BE LESS
C            THAN 2*M.
C
C   DMIWRK INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF MATRIX IWORK.  MUST BE AT LEAST 2.
C
C   IWORK INTEGER MATRIX WHOSE FIRST DIMENSION MUST BE DMIWRK AND SECOND
C            DIMENSION MUST BE AT LEAST K.
C         WORK MATRIX.
C
C   DMWRK1 INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF MATRIX WORK1.  MUST BE AT LEAST 6.
C
C   WORK1 REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMWRK1 AND SECOND
C            DIMENSION MUST BE AT LEAST K.
C         WORK MATRIX.
C
C   WORK2 REAL VECTOR DIMENSIONED AT LEAST 2*M.
C         WORK VECTOR.
C
C   OUNIT INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         UNIT NUMBER FOR OUTPUT.
C
C   REFERENCES
C   ----------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGES 330-346.
C
C     SONQUIST, J. A. (1971).  "MULTIVARIATE MODEL BUILDING: THE
C        VALIDATION OF A SEARCH STRATEGY."  INSTITUTE FOR SOCIAL
C        RESEARCH, THE UNIVERSITY OF MICHIGAN, ANN ARBOR, MICH.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      INTEGER DMIWRK, DMWRK1, OUNIT
      DIMENSION A(MM,*), WORK1(DMWRK1,*), IWORK(DMIWRK,*), WORK2(*)
      CHARACTER*4 CLAB(*), RLAB(*), CC
C
C     INITIALIZE BLOCK ARRAY
C
      KA=0
      IL=1
      IU=M
      JM=JP
      IS=0
   10 IF(KA.LE.K-2) THEN
C
C     DEFINE BLOCKS
C
         KA=KA+1
         IWORK(1,KA)=IL
         IWORK(2,KA)=IS
         KA=KA+1
         IWORK(1,KA)=IS+1
         IWORK(2,KA)=IU
C
C     DEFINE SPLITTING PARAMETERS FOR NEW BLOCKS
C
         KL=KA-1
         DO 40 KK=KL,KA
            LL=IL
            LU=IS
            IF(KK.EQ.KA) THEN
               LL=IS+1
               LU=IU
            ENDIF
            IF(LL.LE.LU) THEN
               WORK1(3,KK)=0.
               DO 20 J=1,N
                  IF(J.NE.JP) THEN
                     NN=LU-LL+1
                     CALL REL(NN,A(LL,JP),A(LL,J),C,SSQ,WORK2(1),
     *                        WORK2(M+1))
                     IF(SSQ.GE.WORK1(3,KK)) THEN
                        WORK1(1,KK)=J
                        WORK1(2,KK)=C
                        WORK1(3,KK)=SSQ
                     ENDIF
                  ENDIF
   20          CONTINUE
               S0=0.
               S1=0.
               S2=0.
               DO 30 I=LL,LU
                  S0=S0+1.
                  S1=S1+A(I,JP)
   30             S2=S2+A(I,JP)**2
               WORK1(4,KK)=S0
               WORK1(5,KK)=S1/S0
               WORK1(6,KK)=S2/S0-(S1/S0)**2
            ENDIF
   40    CONTINUE
C
C     FIND BEST BLOCK TO SPLIT
C
         SM=0.
         DO 50 KK=2,KA
            IF(WORK1(3,KK).GT.SM) THEN
               KM=KK
               SM=WORK1(3,KK)
            ENDIF
   50    CONTINUE
         IF(SM.LT.TH) GO TO 100
C
C     REORDER DATA ACCORDING TO BEST SPLIT
C
         IL=IWORK(1,KM)
         IU=IWORK(2,KM)
         JM=WORK1(1,KM)
         DO 70 I=IL,IU
            DO 70 II=I,IU
               IF(A(I,JM).GT.A(II,JM)) THEN
                  CC = RLAB(I)
                  RLAB(I) = RLAB(II)
                  RLAB(II) = CC
                  DO 60 J=1,N
                     C=A(I,J)
                     A(I,J)=A(II,J)
   60                A(II,J)=C
               ENDIF
   70    CONTINUE
         WORK1(3,KM)=-WORK1(3,KM)
         DO 80 I=IL,IU
   80       IF(A(I,JM).GT.WORK1(2,KM)) GO TO 90
   90    IS=I-1
         GO TO 10
      ENDIF
  100 IF (OUNIT .GT. 0) CALL AIDOUT(MM,M,N,A,CLAB,RLAB,JP,KA,TH,DMIWRK,
     *                              IWORK,DMWRK1,WORK1,OUNIT)
      RETURN
      END