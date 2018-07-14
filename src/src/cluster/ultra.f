      SUBROUTINE ULTRA(IOBJ, M, K, MT, DMULT, ULT)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C      COMPUTES ULTRAMETRIC FOR THE IOBJ-TH ROW AND COLUMN
C
C   DESCRIPTION
C   -----------
C
C   1.  THE ULTRAMETRIC DISTANCE BETWEEN OBJECTS I AND J IS THE
C       DIAMETER OF THE SMALLEST CLUSTER CONTAINING BOTH I AND J.
C       EQUIVALENTLY, THE ULTRAMETRIC DISTANCE BETWEEN OBJECTS I AND J
C       IS K IF THE TWO LARGEST DISTANCES IN D(I,J), D(I,K), D(J,K) ARE
C       EQUAL.
C
C   2.  THE TREE IS SEARCHED UNTIL IT FINDS THE FIRST NODE IN COMMON TO
C       BOTH OBJECT IOBJ AND OBJECT J FOR J=1,...,M AND ASSIGNS IT AS
C       THE DISTANCE.
C
C   INPUT PARAMETERS
C   ----------------
C
C   IOBJ  INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE OBJECT NUMBER.
C
C   M     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF OBJECTS.
C
C   K     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF NODES OF THE TREE, MUST BE GREATER THAN M.
C
C   MT    VECTOR OF INTEGERS DIMENSIONED AT LEAST K (UNCHANGED ON
C            OUTPUT).
C         MT(I) IS THE ANCESTOR OF OBJECT I IN THE TREE.
C
C   DMULT INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE FIRST DIMENSION OF THE MATRIX ULT.  MUST BE AT LEAST M.
C
C   OUTPUT PARAMETER
C   ----------------
C
C   ULT   REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMULT AND WHOSE
C            SECOND DIMENSION MUST BE AT LEAST M.
C         ULT(I,J) IS THE ULTRAMETRIC DISTANCE BETWEEN OBJECT I AND
C         OBJECT J.
C
C   REFERENCE
C   ---------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGE 190.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      INTEGER DMULT
      DIMENSION ULT(DMULT,*), MT(*)
C
      DO 20 J=1,M
         II=IOBJ
         JJ=J
   10    IF(II.NE.JJ) THEN
            IF(II.LT.JJ) II=MT(II)
            IF(II.GT.JJ) JJ=MT(JJ)
            GO TO 10
         ENDIF
         ULT(J,IOBJ)=II
   20    ULT(IOBJ,J)=II
      RETURN
      END