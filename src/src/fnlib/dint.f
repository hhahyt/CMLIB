       DOUBLE PRECISION FUNCTION DINT (X)
C***BEGIN PROLOGUE   DINT
C***REVISION  OCTOBER 1, 1980
C***CATEGORY NO.  M2
C***KEYWORD(S) TRUNCATION,GREATEST INTEGER,DOUBLE PRECISION
C***AUTHOR  FULLERTON W. (LASL)
C***DATE WRITTEN  AUGUST 1979
C***PURPOSE  TO FIND THE LARGEST INTEGER WHOSE MAGNITUDE DOES
C            NOT EXCEED X AND CONVERT TO DOUBLE PRECISION.
C***DESCRIPTION
C AUGUST 1979 EDITION. W. FULLERTON, LOS ALAMOS SCIENTIFIC LABORATORY.
C INSTALLED ON THE VAX BY DOLORES MONTANO, C-3, 5/80.
C
C DINT IS THE DOUBLE PRECISION EQUIVALENT OF AINT. THIS PORTABLE
C VERSION IS QUITE EFFICIENT WHEN THE ARGUMENT IS REASONABLY SMALL (A
C COMMON CASE), AND SO NO FASTER MACHINE-DEPENDENT VERSION IS NEEDED.
C
C
C***REFERENCE(S)
C***ROUTINES CALLED  D1MACH,I1MACH,R1MACH,XERROR
C***END PROLOGUE
       DOUBLE PRECISION X,XSCL,SCALE,XBIG,XMAX,PART,D1MACH
       DATA NPART,SCALE,XBIG,XMAX /0, 3*0.0D0 /
C***FIRST EXECUTABLE STATEMENT    DINT
       IF(NPART.NE.0) GO TO 10
       IBASE = I1MACH(7)
       NDIGD = I1MACH(14)
       NDIGI = MIN0(I1MACH(8),I1MACH(11)) - 1
       NMAX  = 1.0D0/D1MACH(4)
       XBIG  = AMIN1 (FLOAT(I1MACH(9)),1.0/R1MACH(4))
       IF (IBASE.NE.I1MACH(10)) CALL XERROR (
     1   'DINT   ALGORITHM ERROR. INTEGER BASE NE REAL BASE', 49, 2, 2)
C
       NPART = (NDIGD + NDIGI -1) / NDIGI
       SCALE = IBASE**NDIGI
C
 10    IF(X.LT.(-XBIG) .OR. X.GT.XBIG) GO TO 20
C
       DINT=INT(SNGL(X))
       RETURN
C
 20    XSCL = DABS(X)
       IF(XSCL.GT.XMAX) GO TO 50
C
       DO 30 I=1,NPART
       XSCL=XSCL/SCALE
 30    CONTINUE
C
       DO 40 I=1,NPART
       XSCL = XSCL*SCALE
       IPART=XSCL
       PART=IPART
       XSCL=XSCL - PART
       DINT = DINT * SCALE + PART
 40    CONTINUE
C
       IF(X.LT.0.0D0) DINT = -DINT
       RETURN
C
 50     CALL XERROR ('DINT    DABS(X) MAY BE TOO BIG TO BE REPRESENTED
     1AS AN EXACT INTEGER', 67, 1, 1)
       DINT=X
       RETURN
C
       END