      SUBROUTINE XSCSRT(DNU1,NUDIFF,MU1,MU2,THETA,P,Q,R,IP,IQ,IR,C1,IC1
     1   ,C2,IC2)
C***BEGIN PROLOGUE   XSCSRT
C***DATE WRITTEN   820728   (YYMMDD)
C***REVISION DATE  850805   (YYMMDD)
C***CATEGORY NO.  C3a2,C9
C***KEYWORDS  LEGENDRE FUNCTIONS
C***AUTHOR  SMITH, JOHN M. (NBS AND GEORGE MASON UNIVERSITY)
C***PURPOSE  TO COMPUTE CHECK VALUES FOR LEGENDRE FUNCTIONS
C***DESCRIPTION
C
C        SUBROUTINE XSCSRT CALCULATES CASORATI (CROSS PRODUCT)
C        CHECK VALUES AND STORES THEM IN ARRAYS C1 AND C2 WITH
C        EXPONENTS IN ARRAYS IC1 AND IC2.  CALCULATIONS ARE BASED
C        ON PREVIOUSLY CALCULATED LEGENDRE FUNCTIONS OF THE
C        FIRST KIND (NEGATIVE ORDER) IN ARRAY P, THE SECOND KIND
C        IN ARRAY Q, THE FIRST KIND (POSITIVE ORDER) IN ARRAY R.
C        RESULTS SHOULD BE 1.0 TO WITHIN ROUNDOFF ERROR.
C
C***REFERENCES  OLVER AND SMITH,J.COMPUT.PHYSICS,51(1983),N0.3,502-518.
C***ROUTINES CALLED  XSADD, XSADJ, XSRED
C***END PROLOGUE  XSCSRT
      REAL C1,C2,DMU,DMU1,NU,DNU1,DNU2,P,Q,R,THETA,SX,X1,X2
      DIMENSION P(*),IP(*),Q(*),IQ(*),R(*),IR(*)
      DIMENSION C1(*),IC1(*),C2(*),IC2(*)
C
C         PLACE ALL INPUT IN ADJUSTED FORM.
C
C***FIRST EXECUTABLE STATEMENT   XSCSRT
      L=NUDIFF+(MU2-MU1)+1
      LM1=L-1
      DNU2=DNU1+NUDIFF
      DO 500 I=1,L
      CALL XSADJ(P(I),IP(I))
      CALL XSADJ(Q(I),IQ(I))
      CALL XSADJ(R(I),IR(I))
  500 CONTINUE
C
C         CHECKS FOR FIXED MU, VARIABLE NU
C
      IF(MU2.GT.MU1) GO TO 700
      DMU1=(FLOAT(MU1))
      DO 650 I=1,LM1
      C1(I)=0.
      C2(I)=0.
      NU=DNU1+(FLOAT(I))-1.
C
C         CASORATI 2
C
C         (MU+NU+1)*P(-MU,NU+1,X)*Q(MU,NU,X)
C               +(MU-NU-1)*P(-MU,NU,X)*Q(MU,NU+1,X)=COS(MU*PI)
C
      X1=P(I+1)*Q(I)
      IX1=IP(I+1)+IQ(I)
      CALL XSADJ(X1,IX1)
      X2=P(I)*Q(I+1)
      IX2=IP(I)+IQ(I+1)
      CALL XSADJ(X2,IX2)
      X1=(DMU1+NU+1.)*X1
      X2=(DMU1-NU-1.)*X2
      CALL XSADD(X1,IX1,X2,IX2,C1(I),IC1(I))
      CALL XSADJ(C1(I),IC1(I))
C
C         MULTIPLY BY (-1)**MU SO THAT CHECK VALUE IS 1.
C
      C1(I)=C1(I)*(FLOAT((-1)**MU1))
C
C         CASORATI 1
C
C         P(MU,NU+1,X)*Q(MU,NU,X)-P(MU,NU,X)*Q(MU,NU+1,X)=
C               GAMMA(NU+MU+1)/GAMMA(NU-MU+2)
C
      IF(DMU1.GE.NU+1..AND.AMOD(NU,1.).EQ.0.) GO TO 630
      X1=R(I+1)*Q(I)
      IX1=IR(I+1)+IQ(I)
      CALL XSADJ(X1,IX1)
      X2=R(I)*Q(I+1)
      IX2=IR(I)+IQ(I+1)
      CALL XSADJ(X2,IX2)
      CALL XSADD(X1,IX1,-X2,IX2,C2(I),IC2(I))
C
C         DIVIDE BY (NU+MU),(NU+MU-1),(NU+MU-2),....(NU-MU+2),
C         SO THAT CHECK VALUE IS 1.
C
      K=2*MU1-1
      DO 620 J=1,K
      IF(K.LE.0) GO TO 620
      C2(I)=C2(I)/(NU+DMU1+1.-(FLOAT(J)))
  620 CALL XSADJ(C2(I),IC2(I))
      IF(K.LE.0) C2(I)=(NU+1.)*C2(I)
      GO TO 650
  630 C2(I)=0.
      IC2(I)=0
  650 CONTINUE
      GO TO 800
C
C         CHECKS FOR FIXED NU, VARIABLE MU
C
  700 CONTINUE
      SX=SIN(THETA)
      DO 750 I=1,LM1
      C1(I)=0.
      C2(I)=0.
C
C         CASORATI 4
C
C         (MU+NU+1)*(MU-NU)*P(-(MU+1),NU,X)*Q(MU,NU,X)
C              -P(-MU,NU,X)*Q(MU+1,NU,X)=COS(MU*PI)/SQRT(1-X**2)
C
      MU=MU1+I-1
      DMU=(FLOAT(MU))
      X1=P(I+1)*Q(I)
      IX1=IP(I+1)+IQ(I)
      CALL XSADJ(X1,IX1)
      X2=P(I)*Q(I+1)
      IX2=IP(I)+IQ(I+1)
      CALL XSADJ(X2,IX2)
      X1=(DMU+DNU1+1.)*(DMU-DNU1)*X1
C
C         MULTIPLY BY SQRT(1-X**2)*(-1)**MU SO THAT CHECK VALUE IS 1.
C
      CALL XSADD(X1,IX1,-X2,IX2,C1(I),IC1(I))
      C1(I)=SX*C1(I)*(FLOAT((-1)**MU))
      CALL XSADJ(C1(I),IC1(I))
C
C         CASORATI 3
C
C         P(MU+1,NU,X)*Q(MU,NU,X)-P(MU,NU,X)*Q(MU+1,NU,X)=
C               GAMMA(NU+MU+1)/(GAMMA(NU-MU+1)*SQRT(1-X**2))
C
      IF(DMU.GE.DNU1+1..AND.AMOD(DNU1,1.).EQ.0.) GO TO 750
      X1=R(I+1)*Q(I)
      IX1=IR(I+1)+IQ(I)
      CALL XSADJ(X1,IX1)
      X2=R(I)*Q(I+1)
      IX2=IR(I)+IQ(I+1)
      CALL XSADJ(X2,IX2)
      CALL XSADD(X1,IX1,-X2,IX2,C2(I),IC2(I))
C
C         MULTIPLY BY SQRT(1-X**2) AND THEN DIVIDE BY
C         (NU+MU),(NU+MU-1),(NU+MU-2),...,(NU-MU+1) SO THAT
C         CHECK VALUE IS 1.
C
      C2(I)=C2(I)*SX
      K=2*MU
      IF(K.LE.0) GO TO 750
      DO 740 J=1,K
      C2(I)=C2(I)/(DNU1+DMU+1.-(FLOAT(J)))
  740 CALL XSADJ(C2(I),IC2(I))
  750 CONTINUE
C
C         PLACE RESULTS IN REDUCED FORM.
C
  800 DO 810 I=1,LM1
      CALL XSRED(C1(I),IC1(I))
      CALL XSRED(C2(I),IC2(I))
  810 CONTINUE
      RETURN
      END
