*SJACFD
      SUBROUTINE SJACFD
     +   (N,NP,M,BETA,
     +   X,LDX,DELTA,XPLUSD,LDXPD,FUN,
     +   SS,TT,LDTT,EPSMAC,PV,STP,
     +   IFIXB,FJACB,LDFJB,ISODR,
     +   IFIXX,LDIFX,FJACX,LDFJX,NFEV,IFLAG)
C***BEGIN PROLOGUE  SJACFD
C***REFER TO  SODR,SODRC
C***ROUTINES CALLED  SZERO
C***DATE WRITTEN   860529   (YYMMDD)
C***REVISION DATE  870204   (YYMMDD)
C***CATEGORY NO.  G2E,I1B1
C***KEYWORDS  ORTHOGONAL DISTANCE REGRESSION,
C             NONLINEAR LEAST SQUARES,
C             ERRORS IN VARIABLES
C***AUTHOR  BOGGS, PAUL T.
C             OPTIMIZATION GROUP/SCIENTIFIC COMPUTING DIVISION
C             NATIONAL BUREAU OF STANDARDS, GAITHERSBURG, MD 20899
C           BYRD, RICHARD H.
C             DEPARTMENT OF COMPUTER SCIENCE
C             UNIVERSITY OF COLORADO, BOULDER, CO 80309
C           DONALDSON, JANET R.
C             OPTIMIZATION GROUP/SCIENTIFIC COMPUTING DIVISION
C             NATIONAL BUREAU OF STANDARDS, BOULDER, CO 80303-3328
C           SCHNABEL, ROBERT B.
C             DEPARTMENT OF COMPUTER SCIENCE
C             UNIVERSITY OF COLORADO, BOULDER, CO 80309
C             AND
C             OPTIMIZATION GROUP/SCIENTIFIC COMPUTING DIVISION
C             NATIONAL BUREAU OF STANDARDS, BOULDER, CO 80303-3328
C***PURPOSE  COMPUTE FINITE DIFFERENCE APPROXIMATIONS TO THE
C            JACOBIAN WRT THE ESTIMATED BETAS AND WRT THE DELTAS
C***END PROLOGUE  SJACFD
C
C  EXTERNALS
C
      EXTERNAL FUN
C        THE NAME OF USER-SUPPLIED ROUTINE FOR COMPUTING THE MODEL.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE SECTION V.B,
C        ARGUMENT FUN.)
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      REAL BETA(NP)
C        THE FUNCTION PARAMETERS.
      REAL BETAJ
C        THE J-TH FUNCTION PARAMETER.
      REAL DELTA(N,M)
C        THE ESTIMATED ERRORS IN THE INDEPENDENT VARIABLES.
      LOGICAL DOIT
C        THE INDICATOR VARIABLE USED TO SPECIFY WHETHER THE DERIVATIVE
C        WRT A GIVEN BETA OR X NEEDS TO BE COMPUTED (DOIT=TRUE) OR NOT
C        (DOIT=FALSE).
      REAL EPSMAC
C        THE VALUE OF MACHINE PRECISION.
      REAL FJACB(LDFJB,NP)
C        THE JACOBIAN WITH RESPECT TO BETA.
      REAL FJACX(LDFJX,M)
C        THE JACOBIAN WITH RESPECT TO X.
      INTEGER I
C        AN INDEXING VARIABLE.
      INTEGER IFIXB(NP)
C        THE INDICATOR VALUES USED TO DESIGNATE WHETHER THE INDIVIDUAL
C        ELEMENTS OF BETA ARE FIXED AT THEIR INPUT VALUES OR NOT.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER IFIXX(LDIFX,M)
C        THE INDICATOR VALUES USED TO DESIGNATE WHETHER THE INDIVIDUAL
C        ELEMENTS OF DELTA ARE FIXED AT THEIR INPUT VALUES OR NOT.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER IFLAG
C        AN INDICATOR VARIABLE, USED PRIMARILY TO DESIGNATE THAT THE
C        USER WISHES THE COMPUTATIONS STOPPED.
      LOGICAL ISODR
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THE SOLUTION
C        IS TO BE FOUND BY ODR (ISODR=.TRUE.) OR BY OLS (ISODR=.FALSE.).
      INTEGER J
C        AN INDEXING VARIABLE.
      INTEGER JFX
C        AN INDEXING VARIABLE.
      INTEGER LDFJB
C        THE LEADING DIMENSION OF ARRAY FJACB.
      INTEGER LDFJX
C        THE LEADING DIMENSION OF ARRAY FJACX.
      INTEGER LDIFX
C        THE LEADING DIMENSION OF ARRAY IFIXX.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER LDTT
C        THE LEADING DIMENSION OF ARRAY TT.
      INTEGER LDX
C        THE LEADING DIMENSION OF ARRAY X.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER LDXPD
C        THE LEADING DIMENSION OF ARRAY XPLUSD.
      INTEGER M
C        THE NUMBER OF COLUMNS OF DATA IN THE INDEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER N
C        THE NUMBER OF OBSERVATIONS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER NFEV
C        THE NUMBER OF FUNCTION EVALUATIONS.
      INTEGER NP
C        THE NUMBER OF FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      REAL ONE
C        THE VALUE 1.0E0.
      REAL PV(N)
C        THE PREDICTED VALUES OF THE MODEL FUNCTION AT THE CURRENT
C        POINT.
      REAL SQREPS
C        THE SQUARE ROOT OF MACHINE PRECISION.
      REAL SS(NP)
C        THE SCALE USED FOR THE ESTIMATED BETA'S.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      REAL STP(N)
C        THE STEP USED TO COMPUTE FINITE DIFFERENCE DERIVATIVES.
      REAL TT(LDTT,M)
C        THE SCALE USED FOR THE DELTA'S.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      REAL TYPJ
C        THE TYPICAL SIZE OF THE J-TH UNKNOWN BETA OR DELTA.
      REAL X(LDX,M)
C        THE INDEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      REAL XPLUSD(LDXPD,M)
C        THE ARRAY X + DELTA.
      REAL ZERO
C          THE VALUE 0.0E0.
C
C
      DATA ZERO,ONE/0.0E0,1.0E0/
C
C
C***FIRST EXECUTABLE STATEMENT  SJACFD
C
C
C  SET THE RELATIVE STEP SIZE FOR COMPUTING THE JACOBIANS
C
      SQREPS = SQRT(EPSMAC)
C
C  COMPUTE THE PREDICTED VALUES OF THE FUNCTION AT THE GIVEN POINT
C
      CALL FUN(N,NP,M,BETA,XPLUSD,LDXPD,PV,IFLAG)
      IF (IFLAG.LT.0) THEN
         RETURN
      END IF
      NFEV = NFEV + 1
C
C  COMPUTE THE JACOBIAN WRT THE ESTIMATED BETAS
C
      JFX = 0
      DO 20 J=1,NP
         IF (IFIXB(1).GE.0) THEN
            IF (IFIXB(J).EQ.0) THEN
               DOIT = .FALSE.
            ELSE
               DOIT = .TRUE.
            END IF
         ELSE
            DOIT = .TRUE.
         END IF
         IF (DOIT) THEN
            JFX = JFX + 1
            BETAJ = BETA(J)
            IF (SS(1).GT.ZERO) THEN
               TYPJ = ONE/SS(JFX)
            ELSE
               TYPJ = ONE/ABS(SS(1))
            END IF
            STP(J) = BETAJ + SQREPS*SIGN(ONE,BETAJ)*MAX(ABS(BETAJ),TYPJ)
            STP(J) = STP(J) - BETAJ
            BETA(J) = BETAJ + STP(J)
            CALL FUN(N,NP,M,BETA,XPLUSD,LDXPD,FJACB(1,JFX),IFLAG)
            IF (IFLAG.LT.0) THEN
               RETURN
            END IF
            NFEV = NFEV + 1
            DO 10 I=1,N
               FJACB(I,JFX) = (FJACB(I,JFX)-PV(I))/STP(J)
   10       CONTINUE
            BETA(J) = BETAJ
         END IF
   20 CONTINUE
C
C  COMPUTE THE JACOBIAN WRT THE X'S
C
      IF (ISODR) THEN
         DO 50 J=1,M
            IF (IFIXX(1,1).GE.0) THEN
               IF (LDIFX.EQ.1) THEN
                  IF (IFIXX(1,J).EQ.0) THEN
                     DOIT = .FALSE.
                  ELSE
                     DOIT = .TRUE.
                  END IF
               ELSE
                  DOIT = .TRUE.
               END IF
            ELSE
               DOIT = .TRUE.
            END IF
            IF (.NOT.DOIT) THEN
               CALL SZERO(N,1,FJACX(1,J),N)
            ELSE
               DO 30 I=1,N
                  IF (TT(1,1).GT.ZERO) THEN
                     IF (LDTT.EQ.1) THEN
                        TYPJ = ONE/TT(1,J)
                     ELSE
                        TYPJ = ONE/TT(I,J)
                     END IF
                  ELSE
                     TYPJ = ABS(ONE/TT(1,1))
                  END IF
                  STP(I) = XPLUSD(I,J) + SQREPS*SIGN(ONE,XPLUSD(I,J))*
     +                     MAX(ABS(XPLUSD(I,J)),TYPJ)
                  STP(I) = STP(I) - XPLUSD(I,J)
                  XPLUSD(I,J) = XPLUSD(I,J) + STP(I)
   30          CONTINUE
               CALL FUN(N,NP,M,BETA,XPLUSD,LDXPD,FJACX(1,J),IFLAG)
               IF (IFLAG.LT.0) THEN
                  RETURN
               END IF
               NFEV = NFEV + 1
               DO 40 I=1,N
                  FJACX(I,J) = (FJACX(I,J)-PV(I))/STP(I)
                  XPLUSD(I,J) = X(I,J) + DELTA(I,J)
   40          CONTINUE
            END IF
   50    CONTINUE
      END IF
C
      RETURN
      END
