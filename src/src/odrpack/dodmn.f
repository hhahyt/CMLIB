*DODMN
      SUBROUTINE DODMN
     +   (FUN,JAC,
     +   N,NP,NPP,M,JOB,
     +   X,LDX,IFIXX,LDIFX,Y,
     +   BETAC,IFIXB,BETA,BETAN,BETAS,S,
     +   DELTA,DELTAN,DELTAS,T,
     +   F,FN,FS,
     +   FJACB,LDFJB,MSGB,FJACX,LDFJX,MSGX,STP,
     +   W,RHO,LDRHO,SSF,SS,TT,LDTT,
     +   XPLUSD,DDELT,SSS,
     +   WORK,LWORK,IWORK,LIWORK,INFO)
C***BEGIN PROLOGUE  DODMN
C***REFER TO  DODR,DODRC
C***ROUTINES CALLED  DACCES,DCOPY,DDIAGS,DDIAGW,DDOT,DEVFUN,DEVJAC,
C                    DFLAGS,DGETCP,DNRM2,DODLM,DODLMW,DODPCR,
C                    DSTORE,DUNPAC,DWDS,DXPY
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
C***PURPOSE  ITERATIVELY COMPUTE LEAST SQUARES SOLUTION
C***END PROLOGUE  DODMN
C
C  EXTERNALS
C
      EXTERNAL FUN
C        THE NAME OF USER-SUPPLIED ROUTINE FOR COMPUTING THE MODEL.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE SECTION V.B,
C        ARGUMENT FUN.)
      EXTERNAL JAC
C        THE NAME OF USER-SUPPLIED ROUTINE FOR COMPUTING THE JACOBIANS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE SECTION V.B,
C        ARGUMENT JAC.)
C
C  FUNCTION DECLARATIONS
C
      DOUBLE PRECISION DDOT
      DOUBLE PRECISION DNRM2
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      DOUBLE PRECISION ACTRED
C        THE ACTUAL RELATIVE REDUCTION IN THE SUM-OF-SQUARES OF THE
C        WEIGHTED OBSERVATIONAL ERRORS.
      DOUBLE PRECISION ACTRS
C        THE SAVED ACTUAL RELATIVE REDUCTION IN THE SUM-OF-SQUARES
C        OF THE WEIGHTED OBSERVATIONAL ERRORS.
      DOUBLE PRECISION ALPHA
C        THE LEVENBERG-MARQUARDT PARAMETER.
      LOGICAL ANAJAC
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THE JACOBIANS
C        ARE COMPUTED BY FINITE DIFFERENCES (ANAJAC=.FALSE.) OR NOT
C        (ANAJAC=.TRUE.).
      DOUBLE PRECISION BETA(NP)
C        THE FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION BETAC(NP)
C        THE CURRENT ESTIMATED VALUES OF THE UNFIXED BETA'S.
      DOUBLE PRECISION BETAN(NP)
C        THE NEW ESTIMATED VALUES OF THE UNFIXED BETA'S.
      DOUBLE PRECISION BETAS(NP)
C        THE SAVED ESTIMATED VALUES OF THE UNFIXED BETA'S.
      LOGICAL CHKJAC
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THE USER-
C        SUPPLIED JACOBIANS ARE TO BE CHECKED (CHKJAC=.TRUE.) OR NOT
C        (CHKJAC=.FALSE.).
      LOGICAL CNVPAR
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER PARAMETER
C        CONVERGENCE HAS BEEN ATTAINED (CNVPAR=.TRUE.) OR NOT
C        (CNVPAR=.FALSE.).
      LOGICAL CNVSS
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER SUM-OF-SQUARES
C        CONVERGENCE HAS BEEN ATTAINED (CNVSS=.TRUE.) OR NOT
C        (CNVSS=.FALSE.).
      DOUBLE PRECISION DDELT(N,M)
C        THE ARRAY (W*D)**2 * DELTA.
      DOUBLE PRECISION DELTA(N,M)
C        THE ESTIMATED ERRORS IN THE INDEPENDENT VARIABLES.
      DOUBLE PRECISION DELTAN(N,M)
C        THE NEW ESTIMATED ERRORS IN THE INDEPENDENT VARIABLES.
      DOUBLE PRECISION DELTAS(N,M)
C        THE SAVED ESTIMATED ERRORS IN THE INDEPENDENT VARIABLES.
      DOUBLE PRECISION DIRDER
C        THE DIRECTIONAL DERIVATIVE.
      DOUBLE PRECISION EPSMAC
C        THE VALUE OF MACHINE PRECISION.
      DOUBLE PRECISION F(N)
C        THE (WEIGHTED) ESTIMATED VALUES OF EPSILON.
      DOUBLE PRECISION FJACB(LDFJB,NP)
C        THE JACOBIAN WITH RESPECT TO BETA.
      DOUBLE PRECISION FJACX(LDFJX,M)
C        THE JACOBIAN WITH RESPECT TO X.
      DOUBLE PRECISION FN(N)
C        THE NEW (WEIGHTED) ESTIMATED VALUES OF EPSILON.
      DOUBLE PRECISION FS(N)
C        THE SAVED (WEIGHTED) ESTIMATED VALUES OF EPSILON.
      LOGICAL FSTITR
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THIS IS THE
C        FIRST ITERATION (FSTITR=.TRUE.) OR NOT (FSTITR=.FALSE.).
      LOGICAL HEAD
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THE PACKAGE
C        HEADING IS TO BE PRINTED (HEAD=.TRUE.) OR NOT (HEAD=.FALSE.).
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
      INTEGER INFO
C        AN INDICATOR VARIABLE, USED PRIMARILY TO DESIGNATE WHY THE
C        COMPUTATIONS WERE STOPPED.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      LOGICAL INITD
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THE DELTA'S
C        ARE TO BE INITIALIZED TO ZERO (INITD=.TRUE.) OR WHETHER THEY
C        ARE TO BE INITIALIZED TO THE VALUES PASSED VIA THE FIRST N BY M
C        ELEMENTS OF ARRAY WORK (INITD=.FALSE.).
      INTEGER INT2
C        THE NUMBER OF INTERNAL DOUBLING STEPS TAKEN.
      LOGICAL INTDBL
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER INTERNAL
C        DOUBLING IS TO BE USED (INTDBL=.TRUE.) OR NOT (INTDBL=.FALSE.).
      INTEGER IPR1
C        THE VALUE OF THE FOURTH DIGIT (FROM THE RIGHT) OF IPRINT,
C        WHICH CONTROLS THE INITIAL SUMMARY REPORT.
      INTEGER IPR2
C        THE VALUE OF THE THIRD DIGIT (FROM THE RIGHT) OF IPRINT,
C        WHICH CONTROLS THE ITERATION REPORTS.
      INTEGER IPR2F
C        THE VALUE OF THE SECOND DIGIT (FROM THE RIGHT) OF IPRINT,
C        WHICH CONTROLS THE FREQUENCY OF THE ITERATION REPORTS.
      INTEGER IPR3
C        THE VALUE OF THE FIRST DIGIT (FROM THE RIGHT) OF IPRINT,
C        WHICH CONTROLS THE FINAL SUMMARY REPORT.
      INTEGER IRANK
C        THE RANK DEFICIENCY OF THE JACOBIAN WRT BETA.
      LOGICAL ISODR
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THE SOLUTION
C        IS TO BE FOUND BY ODR (ISODR=.TRUE.) OR BY OLS (ISODR=.FALSE.).
      INTEGER IWORK(LIWORK)
C        THE INTEGER WORK SPACE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER JOB
C        THE PROBLEM INITIALIZATION AND COMPUTATIONAL
C        METHOD CONTROL VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER JPVT
C        THE PIVOT VECTOR.
      INTEGER LDFJB
C        THE LEADING DIMENSION OF ARRAY FJACB.
      INTEGER LDFJX
C        THE LEADING DIMENSION OF ARRAY FJACX.
      INTEGER LDIFX
C        THE LEADING DIMENSION OF ARRAY IFIXX.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER LDRHO
C        THE LEADING DIMENSION OF ARRAY RHO.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER LDTT
C        THE LEADING DIMENSION OF ARRAY TT.
      INTEGER LDX
C        THE LEADING DIMENSION OF ARRAY X.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER LIWORK
C        THE LENGTH OF VECTOR IWORK.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      LOGICAL LSTEP
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER A SUCCESSFUL
C        STEP HAS BEEN FOUND (LSTEP=.TRUE.) OR NOT (LSTEP=.FALSE.).
      INTEGER LUNRPT
C        THE LOGICAL UNIT NUMBER USED FOR COMPUTATION REPORTS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER LWORK
C        THE LENGTH OF VECTOR WORK.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER M
C        THE NUMBER OF COLUMNS OF DATA IN THE INDEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER MAXIT
C        THE MAXIMUM NUMBER OF ITERATIONS ALLOWED.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER MSGB(NP)
C        THE ERROR CHECKING RESULTS FOR THE JACOBIAN WRT BETA.
      INTEGER MSGX(M)
C        THE ERROR CHECKING RESULTS FOR THE JACOBIAN WRT X.
      INTEGER N
C        THE NUMBER OF OBSERVATIONS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER NFEV
C        THE NUMBER OF FUNCTION EVALUATIONS.
      INTEGER NJEV
C        THE NUMBER OF JACOBIAN EVALUATIONS.
      INTEGER NLMS
C        THE NUMBER OF LEVENBERG-MARQUARDT STEPS TAKEN.
      INTEGER NP
C        THE NUMBER OF FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER NPP
C        THE NUMBER OF FUNCTION PARAMETERS ACTUALLY BEING ESTIMATED.
      DOUBLE PRECISION OLMAVG
C        THE AVERAGE NUMBER OF LEVENBERG-MARQUARDT STEPS PER ITERATION.
      INTEGER OMEGA
C        THE ARRAY (I-FJACX*INV(P)*TRANS(FJACX))**(-1/2)  WHERE
C        P = TRANS(FJACX)*FJACX + D**2 + ALPHA*TT**2
      DOUBLE PRECISION ONE
C        THE VALUE 1.0D0.
      DOUBLE PRECISION P0001
C        THE VALUE 0.0001D0.
      DOUBLE PRECISION P1
C        THE VALUE 0.1D0.
      DOUBLE PRECISION P25
C        THE VALUE 0.25D0.
      DOUBLE PRECISION P5
C        THE VALUE 0.5D0.
      DOUBLE PRECISION P75
C        THE VALUE 0.75D0.
      DOUBLE PRECISION PARTOL
C        THE PARAMETER CONVERGENCE STOPPING CRITERIA.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION PNORM
C        THE NORM OF THE SCALED ESTIMATED PARAMETERS.
      DOUBLE PRECISION PRERED
C        THE PREDICTED RELATIVE REDUCTION IN THE SUM-OF-SQUARES
C        OF THE WEIGHTED OBSERVATIONAL ERRORS.
      DOUBLE PRECISION PRERS
C        THE SAVED PREDICTED RELATIVE REDUCTION IN THE SUM-OF-SQUARES
C        OF THE WEIGHTED OBSERVATIONAL ERRORS.
      INTEGER QRAUX
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE ARRAY REQUIRED TO RECOVER THE ORTHOGONAL PART OF THE
C        Q-R DECOMPOSITION.
      DOUBLE PRECISION RATIO
C        THE RATIO OF THE ACTUAL RELATIVE REDUCTION TO THE PREDICTED
C        RELATIVE REDUCTION IN THE SUM-OF-SQUARES.
      DOUBLE PRECISION RCOND
C        THE APPROXIMATE RECIPROCAL CONDITION OF TFJACB.
      LOGICAL RESTRT
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THE CALL IS
C        A RESTART (RESTRT=TRUE) OR NOT (RESTRT=FALSE).
      DOUBLE PRECISION RHO(LDRHO,M)
C        THE DELTA WEIGHTS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION RNORM
C        THE NORM OF THE WEIGHTED OBSERVATIONAL ERRORS.
      DOUBLE PRECISION RNORMN
C        THE NORM OF THE NEW WEIGHTED OBSERVATIONAL ERRORS.
      DOUBLE PRECISION RNORMS
C        THE NORM OF THE SAVED WEIGHTED OBSERVATIONAL ERRORS.
      DOUBLE PRECISION S(NP)
C        THE STEP FOR THE ESTIMATED BETA'S.
      DOUBLE PRECISION SS(NP)
C        THE SCALE USED FOR THE ESTIMATED BETA'S.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION SSF(NP)
C        THE SCALE USED FOR THE BETA'S.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION SSS(N+N*M)
C        THE ARRAY USED TO COMPUTED VARIOUS SUMS-OF-SQUARES.
      DOUBLE PRECISION SSTOL
C        THE SUM-OF-SQUARES CONVERGENCE STOPPING CRITERIA.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION STP(N)
C        THE STEP USED TO COMPUTE FINITE DIFFERENCE DERIVATIVES.
      DOUBLE PRECISION T(N,M)
C        THE STEP FOR THE ESTIMATED DELTA'S.
      DOUBLE PRECISION TAU
C        THE TRUST REGION DIAMETER.
      DOUBLE PRECISION TAUFAC
C        THE FACTOR USED TO COMPUTE THE INITIAL TRUST REGION DIAMETER.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION TEMP
C        A TEMPORARY STORAGE LOCATION.
      DOUBLE PRECISION TEMP1
C        A TEMPORARY STORAGE LOCATION.
      DOUBLE PRECISION TEMP2
C        A TEMPORARY STORAGE LOCATION.
      INTEGER TFJACB
C        THE ARRAY INV(DIAG(SQRT(OMEGA(I)),I=1,...,N))*FJACB.
      DOUBLE PRECISION TSNORM
C        THE NORM OF THE SCALED STEP.
      DOUBLE PRECISION TT(LDTT,M)
C        THE SCALE USED FOR THE DELTA'S.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER U
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE APPROXIMATE NULL VECTOR FOR TFJACB.
      DOUBLE PRECISION W(N)
C        THE OBSERVATIONAL ERROR WEIGHTS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION WORK(LWORK)
C        THE DOUBLE PRECISION WORK SPACE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER WRK1
C        THE STARTING LOCATION IN ARRAY WORK OF
C        A WORK ARRAY.
      INTEGER WRK2
C        THE STARTING LOCATION IN ARRAY WORK OF
C        A WORK ARRAY.
      DOUBLE PRECISION X(LDX,M)
C        THE INDEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION XPLUSD(N,M)
C        THE ARRAY X + DELTA.
      DOUBLE PRECISION Y(N)
C        THE DEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER YT
C         THE STARTING LOCATION IN WORK OF
C         THE ARRAY -(DIAG(SQRT(OMEGA(I)),I=1,...,N)*(G1-V*INV(E)*D*G2).
      DOUBLE PRECISION ZERO
C          THE VALUE 0.0D0.
C
C
      DATA ZERO,P0001,P1,P25,P5,P75,ONE
     +    /0.0D0,0.00010D0,0.10D0,0.250D0,0.50D0,0.750D0,1.0D0/
C
C
C***FIRST EXECUTABLE STATEMENT  DODMN
C
C
C  INITIALIZE NECESSARY VARIABLES
C
      CALL DFLAGS(JOB,RESTRT,INITD,ANAJAC,CHKJAC,ISODR)
      CALL DGETCP(N,M,NP,WORK,LWORK,IWORK,LIWORK,
     +   PARTOL,SSTOL,MAXIT,TAUFAC,EPSMAC,
     +   LUNRPT,IPR1,IPR2,IPR2F,IPR3)
      CALL DODLMW(N,M,NP,
     +   JPVT,WRK1,TFJACB,OMEGA,YT,U,QRAUX,WRK2)
C
      IRANK = 0
      INTDBL = .FALSE.
      LSTEP = .TRUE.
      HEAD = .TRUE.
C
      FSTITR = .TRUE.
      IF (RESTRT) THEN
C
C  RESTART: ACCESS VALUES STORED FROM PREVIOUS RUNS
C
         CALL DACCES
     +      (N,M,NP,WORK,LWORK,IWORK,LIWORK,
     +      RNORM,TAU,ALPHA,NFEV,NJEV,INT2,OLMAVG)
         CALL DCOPY(N,FN,1,F,1)
      ELSE
C
C  NOT A RESTART: INITIALIZE VALUES AS APPROPRIATE
C
         NFEV = 0
         NJEV = 0
         INT2 = 0
         OLMAVG = ZERO
         ALPHA = ZERO
C
C  COMPUTE NORM OF THE INITIAL APPROXIMATION AND
C  INITIALIZE TRUST REGION RADIUS
C
         IF (NPP.GE.1) THEN
            CALL DDIAGS(NPP,1,SS,NPP,BETAC,NPP,SSS,NPP)
         END IF
         CALL DDIAGS(N,M,TT,LDTT,DELTA,N,SSS(NPP+1),N)
         PNORM = DNRM2(NPP+N*M,SSS,1)
C
         TAU = -TAUFAC
C
C  EVALUATE THE WEIGHTED EPSILONS AT THE STARTING POINT
C
         CALL DEVFUN(N,NP,M,BETAC,BETA,IFIXB,FUN,
     +               X,LDX,Y,DELTA,N,XPLUSD,N,
     +               W,F,NFEV,IFLAG)
         IF (IFLAG .LT. 0) THEN
            INFO = IFLAG
            OLMAVG = ZERO
            GO TO 40
         END IF
C
C  COMPUTE NORM OF WEIGHTED EPSILONS AND WEIGHTED DELTAS (RNORM)
C
         CALL DCOPY(N,F,1,SSS,1)
         CALL DWDS(N,M,W,RHO,LDRHO,DELTA,N,SSS(N+1),N)
         RNORM = DNRM2(N+N*M,SSS,1)
      END IF
C
C  PRINT INITIAL SUMMARY IF DESIRED
C
      IF (IPR1.NE.0) THEN
         IFLAG = 1
         CALL DODPCR(HEAD,IFLAG,IPR1,FSTITR,LUNRPT,
     +               ANAJAC,CHKJAC,INITD,RESTRT,ISODR,
     +               MSGB,MSGX,
     +               N,M,NP,NPP,
     +               X,LDX,IFIXX,LDIFX,
     +               DELTA,RHO,LDRHO,TT,LDTT,
     +               Y,W,
     +               BETA,IFIXB,SSF,
     +               JOB,TAUFAC,SSTOL,PARTOL,MAXIT,
     +               RNORM,SSS(1+N),SSS,
     +               NJEV,NFEV,ACTRED,PRERED,TAU,PNORM,ALPHA,
     +               F,RCOND,IRANK,INFO)
      END IF
C
C  STOP IF INITIAL ESTIMATES ARE EXACT SOLUTION
C
      IF (RNORM .EQ. ZERO) THEN
         INFO = 1
         OLMAVG = ONE
         GO TO 40
      END IF
C
C  MAIN LOOP
C
   10 CONTINUE
C
C  EVALUATE JACOBIAN
C
      CALL DEVJAC(FUN,JAC,ANAJAC,N,NP,NPP,M,BETAC,BETA,
     +            IFIXB,IFIXX,LDIFX,
     +            X,LDX,DELTA,N,XPLUSD,N,
     +            SS,TT,LDTT,EPSMAC,FN,STP,
     +            FJACB,LDFJB,ISODR,FJACX,LDFJX,W,NJEV,NFEV,IFLAG)
      IF (IFLAG .LT. 0) THEN
         INFO = IFLAG
         OLMAVG = OLMAVG/NFEV
         GO TO 40
      END IF
C
C  COMPUTE DDELT = (W*D)**2 * DELTA
C
      CALL DWDS(N,M,W,RHO,LDRHO,DELTA,N,DDELT,N)
      CALL DWDS(N,M,W,RHO,LDRHO,DDELT,N,DDELT,N)
C
C  SUB LOOP FOR
C     INTERNAL DOUBLING OR
C     COMPUTING NEW STEP WHEN OLD FAILED
C
   20 CONTINUE
C
C  COMPUTE STEPS S AND T
C
      CALL DODLM(N,NP,NPP,M,
     +           F,FJACB,LDFJB,FJACX,LDFJX,
     +           W,RHO,LDRHO,SS,TT,LDTT,DDELT,
     +           ALPHA,TAU,EPSMAC,
     +           SSS,WORK(WRK1),WORK(TFJACB),WORK(OMEGA),WORK(YT),
     +           WORK(U),WORK(QRAUX),WORK(WRK2),IWORK(JPVT),
     +           S,T,NLMS,RCOND,IRANK)
      OLMAVG = OLMAVG+NLMS
C
C  COMPUTE BETAN = BETAC + S
C          DELTAN = DELTA + T
C
      CALL DXPY(NPP,1,BETAC,NPP,S,NPP,BETAN,NPP)
      CALL DXPY(N,M,DELTA,N,T,N,DELTAN,N)
C
C  COMPUTE NORM OF SCALED STEPS S AND T (TSNORM)
C
      IF (NPP.GE.1) THEN
         CALL DDIAGS(NPP,1,SS,NPP,S,NPP,SSS,NPP)
      END IF
      CALL DDIAGS(N,M,TT,LDTT,T,N,SSS(NPP+1),N)
      TSNORM = DNRM2(NPP+N*M,SSS,1)
C
C  COMPUTE SCALED PREDICTED REDUCTION
C
      DO 30 I=1,N
        SSS(I) = DDOT(NPP,FJACB(I,1),LDFJB,S,1) +
     +           DDOT(M,FJACX(I,1),LDFJX,T(I,1),N)
   30 CONTINUE
      CALL DWDS(N,M,W,RHO,LDRHO,T,N,SSS(N+1),N)
      TEMP1 = DNRM2(N+N*M,SSS,1)/RNORM
      TEMP2 = SQRT(ALPHA)*TSNORM/RNORM
      PRERED = TEMP1**2+TEMP2**2/P5
C
      DIRDER = -(TEMP1**2+TEMP2**2)
C
C  EVALUATE WEIGHTED EPSILONS AT NEW POINT
C
      CALL DEVFUN(N,NP,M,BETAN,BETA,IFIXB,FUN,
     +            X,LDX,Y,DELTAN,N,XPLUSD,N,
     +            W,FN,NFEV,IFLAG)
      IF (IFLAG .LT. 0) THEN
         INFO = IFLAG
         OLMAVG = OLMAVG/NFEV
         GO TO 40
      END IF
C
C  COMPUTE NORM OF NEW WEIGHTED EPSILONS AND WEIGHTED DELTAS (RNORMN)
C
      CALL DCOPY(N,FN,1,SSS,1)
      CALL DWDS(N,M,W,RHO,LDRHO,DELTAN,N,SSS(N+1),N)
      RNORMN = DNRM2(N+N*M,SSS,1)
C
C  COMPUTE SCALED ACTUAL REDUCTION
C
      IF (P1*RNORMN.LT.RNORM) THEN
         ACTRED = ONE - (RNORMN/RNORM)**2
      ELSE
         ACTRED = -ONE
      END IF
C
C  COMPUTE RATIO OF ACTUAL REDUCTION TO PREDICTED REDUCTION
C
      IF(PRERED .EQ. ZERO) THEN
         RATIO = ZERO
      ELSE
         RATIO = ACTRED/PRERED
      END IF
C
C  CHECK ON LACK OF REDUCTION IN INTERNAL DOUBLING CASE
C
      IF (INTDBL .AND. RATIO.LT.P0001) THEN
         TAU = TAU*P5
         ALPHA = ALPHA/P5
         CALL DCOPY(NPP,BETAS,1,BETAN,1)
         CALL DCOPY(N*M,DELTAS,1,DELTAN,1)
         CALL DCOPY(N,FS,1,FN,1)
         ACTRED = ACTRS
         PRERED = PRERS
         RNORMN = RNORMS
         RATIO = P5
      END IF
C
C  UPDATE STEP BOUND
C
      INTDBL = .FALSE.
      IF (RATIO.LT.P25) THEN
         IF (ACTRED.GE.ZERO) THEN
            TEMP = P5
         ELSE
            TEMP = P5*DIRDER/(DIRDER+P5*ACTRED)
         END IF
         IF (P1*RNORMN.GE.RNORM .OR. TEMP.LT.P1) THEN
            TEMP = P1
         END IF
         TAU = TEMP*MIN(TAU,TSNORM/P1)
         ALPHA = ALPHA/TEMP
C
      ELSE IF (ALPHA.EQ.ZERO) THEN
         TAU = TSNORM/P5
C
      ELSE IF (RATIO.GE.P75 .AND. NLMS.LE.11) THEN
C
C  STEP QUALIFIES FOR INTERNAL DOUBLING
C     - UPDATE TAU AND ALPHA
C     - SAVE INFORMATION FOR CURRENT POINT
C
         INTDBL = .TRUE.
C
         TAU = TSNORM/P5
         ALPHA = ALPHA*P5
C
         CALL DCOPY(NPP,BETAN,1,BETAS,1)
         CALL DCOPY(N*M,DELTAN,1,DELTAS,1)
         CALL DCOPY(N,FN,1,FS,1)
         ACTRS = ACTRED
         PRERS = PRERED
         RNORMS = RNORMN
      END IF
C
C  IF INTERNAL DOUBLING, SKIP CONVERGENCE CHECKS
C
      IF (INTDBL .AND. TAU.GT.ZERO) THEN
         INT2 = INT2+1
         GO TO 20
      END IF
C
C  CHECK ACCEPTANCE
C
      IF (RATIO.GE.P0001) THEN
         CALL DCOPY(N,FN,1,F,1)
         CALL DCOPY(NPP,BETAN,1,BETAC,1)
         CALL DCOPY(N*M,DELTAN,1,DELTA,1)
         RNORM = RNORMN
         IF (NPP.GE.1) THEN
            CALL DDIAGS(NPP,1,SS,NPP,BETAC,NPP,SSS,NPP)
         END IF
         CALL DDIAGS(N,M,TT,LDTT,DELTA,N,SSS(NPP+1),N)
         PNORM = DNRM2(NPP+N*M,SSS,1)
         LSTEP = .TRUE.
      ELSE
         LSTEP = .FALSE.
      END IF
C
C  TEST CONVERGENCE
C
      INFO = 0
      CNVSS = ABS(ACTRED).LE.SSTOL .AND.
     +        PRERED.LE.SSTOL      .AND.
     +        P5*RATIO.LE.ONE
      CNVPAR = TAU.LE.PARTOL*PNORM
      IF (CNVSS)                            INFO = 1
      IF (CNVPAR)                           INFO = 2
      IF (CNVSS .AND. CNVPAR)               INFO = 3
C
C  PRINT ITERATION REPORT
C
      IF (INFO.NE.0 .OR. LSTEP) THEN
         IF (IPR2.NE.0) THEN
            IF (IPR2F.EQ.1 .OR. MOD(NJEV,IPR2F).EQ.1) THEN
               IFLAG = 2
               CALL DUNPAC(NP,BETAC,BETA,IFIXB)
               CALL DODPCR(HEAD,IFLAG,IPR2,FSTITR,LUNRPT,
     +                     ANAJAC,CHKJAC,INITD,RESTRT,ISODR,
     +                     MSGB,MSGX,
     +                     N,M,NP,NPP,
     +                     X,LDX,IFIXX,LDIFX,
     +                     DELTA,RHO,LDRHO,TT,LDTT,
     +                     Y,W,
     +                     BETA,IFIXB,SSF,
     +                     JOB,TAUFAC,SSTOL,PARTOL,MAXIT,
     +                     RNORM,SSS(1+N),SSS,
     +                     NJEV,NFEV,ACTRED,PRERED,TAU,PNORM,ALPHA,
     +                     F,RCOND,IRANK,INFO)
               FSTITR = .FALSE.
            END IF
         END IF
      END IF
C
C  CHECK IF FINISHED
C
      IF (INFO.EQ.0) THEN
         IF (LSTEP) THEN
C
C  BEGIN NEXT INTERATION UNLESS A STOPPING CRITERIA HAS BEEN MET
C
            IF (NJEV.GE.MAXIT) THEN
               INFO = 4
            ELSE
               GO TO 10
            END IF
         ELSE
C
C  STEP FAILED - RECOMPUTE UNLESS A STOPPING CRITERIA HAS BEEN MET
C
            GO TO 20
         END IF
      END IF
C
   40 CONTINUE
C
C  COMPUTE UNWEIGHTED EPSILONS AND X+DELTA TO RETURN TO USER
C
      CALL DEVFUN(N,NP,M,BETAC,BETA,IFIXB,FUN,
     +            X,LDX,Y,DELTA,N,XPLUSD,N,
     +            -ONE,F,NFEV,IFLAG)
C
C  STORE VARIOUS SCALARS IN WORK ARRAYS FOR RETURN TO USER
C
      OLMAVG = OLMAVG/(NFEV-1)
      CALL DSTORE
     +   (N,M,NP,WORK,LWORK,IWORK,LIWORK,
     +   RNORM,TAU,ALPHA,NFEV,NJEV,INT2,OLMAVG,RCOND,IRANK)
C
C  ENCODE EXISTANCE OF QUESTIONABLE RESULTS INTO INFO
C
      IF (INFO.GE.1) THEN
         IF (MSGB(1).EQ.2 .OR. MSGX(1).EQ.2) THEN
            INFO = INFO + 100
         END IF
         IF (NPP.GE.1 .AND. NPP.EQ.IRANK) THEN
            INFO = INFO + 10
         END IF
      END IF
C
C  PRINT FINAL SUMMARY
C
      IF (IPR3.NE.0) THEN
         IFLAG = 3
C
C  COMPUTE WEIGHTED EPSILONS AND WEIGHTED DELTAS FOR FINAL SUMMARY
C
         CALL DDIAGW(N,1,W,F,N,SSS,N)
         CALL DWDS(N,M,W,RHO,LDRHO,DELTA,N,SSS(N+1),N)
         CALL DODPCR(HEAD,IFLAG,IPR3,FSTITR,LUNRPT,
     +               ANAJAC,CHKJAC,INITD,RESTRT,ISODR,
     +               MSGB,MSGX,
     +               N,M,NP,NPP,
     +               X,LDX,IFIXX,LDIFX,
     +               DELTA,RHO,LDRHO,TT,LDTT,
     +               Y,W,
     +               BETA,IFIXB,SSF,
     +               JOB,TAUFAC,SSTOL,PARTOL,MAXIT,
     +               RNORM,SSS(1+N),SSS,
     +               NJEV,NFEV,ACTRED,PRERED,TAU,PNORM,ALPHA,
     +               F,RCOND,IRANK,INFO)
      END IF
C
      RETURN
C
      END