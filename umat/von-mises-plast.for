      SUBROUTINE UMAT(STRESS,STATEV,DDSDDE,SSE,SPD,SCD,
     1 RPL,DDSDDT,DRPLDE,DRPLDT,
     2 STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,CMNAME,
     3 NDI,NSHR,NTENS,NSTATV,PROPS,NPROPS,COORDS,DROT,PNEWDT,
     4 CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,KINC)
C
      INCLUDE 'ABAQUS_SYS.INC'
C
      CHARACTER*80 CMNAME
      DIMENSION STRESS(NTENS),STATEV(NSTATV),DDSDDE(NTENS,NTENS),
     1 DDSDDT(NTENS),DRPLDE(NTENS),STRAN(NTENS),DSTRAN(NTENS),
     2 TIME(2),PREDEF(1),DPRED(1),PROPS(NPROPS),COORDS(3),DROT(3,3),
     3 DFGRD0(3,3),DFGRD1(3,3)
C
C ------------------------------------------------------------------
C UMAT: Kelvin-Mandel notataion and spectral decomposition with von-Mises plasticity 
C AUTHOR: Marcus Aßmus
C ------------------------------------------------------------------
      PARAMETER (ONE=1.0D0, TWO=2.0D0, THREE=3.0D0, ZERO=0.0D0)
      REAL*8 SQRT2, E, NU, SIG0, HMOD, XKAPPA, XMU, EV1, EV2
      REAL*8 SMISES, YIELD, DEQPL, FACTOR, SCALAR_NT
      DIMENSION SIG_M(6), DS_M(6), SIG_TR_M(6), N_M(6)
      DIMENSION P1_M(6,6), P2_M(6,6), C_EP_M(6,6), I_M(6,6)
C
      SQRT2 = SQRT(TWO)
C
C     1. RECOVER MATERIAL DATA AND COMPUTE EIGENVALUES
      E    = PROPS(1)
      NU   = PROPS(2)
      SIG0 = PROPS(3)
      HMOD = PROPS(4)
C
      XKAPPA = E / (THREE * (ONE - TWO*NU)) ! Bulk Modulus
      XMU    = E / (TWO * (ONE + NU))       ! Shear Modulus
      EV1    = THREE * XKAPPA               ! Hydrostatic space eigenvalue
      EV2    = TWO * XMU                    ! Deviatoric space eigenvalue
C
C     2. CONVERT ABAQUS VECTORS TO NORMALIZED KELVIN-MANDEL NOTATION
      DO I=1, 3
        SIG_M(I) = STRESS(I)
        DS_M(I)  = DSTRAN(I)
      END DO
      DO I=4, NTENS
        SIG_M(I) = STRESS(I) * SQRT2
        DS_M(I)  = DSTRAN(I) / SQRT2 ! Converts engineering strain to 'tensor' strain
      END DO
C
C     3. DEFINE PURE 4TH-ORDER IDENTITY AND PROJECTORS IN KELVIN NOTATION
      DO I=1, 6
        DO J=1, 6
          I_M(I,J)  = ZERO
          P1_M(I,J) = ZERO
        END DO
        I_M(I,I) = ONE
      END DO
C     Spherical Projector (P1)
      DO I=1, 3
        DO J=1, 3
          P1_M(I,J) = ONE / THREE
        END DO
      END DO
C     Deviatoric Projector (P2 = I - P1)
      DO I=1, 6
        DO J=1, 6
          P2_M(I,J) = I_M(I,J) - P1_M(I,J)
        END DO
      END DO
C
C     4. CALCULATE TRIAL STRESS (PURE SPECTRAL ALGEBRA)
      DO I=1, 6
        SIG_TR_M(I) = SIG_M(I)
        DO J=1, 6
          SIG_TR_M(I) = SIG_TR_M(I) + EV1*P1_M(I,J)*DS_M(J)
     1                              + EV2*P2_M(I,J)*DS_M(J)
        END DO
      END DO
C
C     5. EVALUATE MISES STRESS VIA THE NORMALIZED DEVIATORIC NORM
      SMISES = ZERO
      DO I=1, 6
        DO J=1, 6
          SMISES = SMISES + SIG_TR_M(I)*P2_M(I,J)*SIG_TR_M(J)
        END DO
      END DO
      SMISES = SQRT(THREE * 0.5D0 * SMISES)
      YIELD  = SIG0 + HMOD * STATEV(1)
C
C     6. RETURN MAPPING
      IF (SMISES .GT. YIELD) THEN
        DEQPL     = (SMISES - YIELD) / (THREE * XMU + HMOD)
        STATEV(1) = STATEV(1) + DEQPL
C       Normalized Flow Direction Vector N
        DO I=1, 6
          N_M(I) = ZERO
          DO J=1, 6
            N_M(I) = N_M(I) + P2_M(I,J)*SIG_TR_M(J)
          END DO
          N_M(I) = (THREE / (TWO * SMISES)) * N_M(I)
        END DO
C       Update Stress in Kelvin Space
        DO I=1, 6
          SIG_M(I) = ZERO
          DO J=1, 6
            SIG_M(I) = SIG_M(I) + P1_M(I,J)*SIG_TR_M(J)
     1       + (ONE - (THREE*XMU*DEQPL)/SMISES)*P2_M(I,J)*SIG_TR_M(J)
          END DO
        END DO
C       Spectral Consistent Tangent Tensor in Kelvin Space
        FACTOR    = TWO * XMU * (THREE * XMU * DEQPL) / SMISES
        SCALAR_NT = FOUR * XMU**2 * ((THREE/(TWO*SMISES)) 
     1            - (ONE/(THREE*XMU+HMOD)))
        DO I=1, 6
          DO J=1, 6
            C_EP_M(I,J) = EV1*P1_M(I,J) + (EV2 - FACTOR)*P2_M(I,J)
     1                  - SCALAR_NT*N_M(I)*N_M(J)
          END DO
        END DO
      ELSE
C       Elastic step
        DO I=1, 6
          SIG_M(I) = SIG_TR_M(I)
          DO J=1, 6
            C_EP_M(I,J) = EV1*P1_M(I,J) + EV2*P2_M(I,J)
          END DO
        END DO
      END IF
C
C     7. TRANSFORMATION BACK TO ORIGINAL VOIGT FORMAT FOR ABAQUS
      DO I=1, 3
        STRESS(I) = SIG_M(I)
      END DO
      DO I=4, NTENS
        STRESS(I) = SIG_M(I) / SQRT2
      END DO
C
C     Transform Jacobian Matrix: DDSDDE_Voigt = T^T * C_Kelvin * T
      DO I=1, NTENS
        DO J=1, NTENS
          FACTOR = ONE
          IF (I .GT. 3) FACTOR = FACTOR * SQRT2
          IF (J .GT. 3) FACTOR = FACTOR * SQRT2
          DDSDDE(I,J) = C_EP_M(I,J) / FACTOR
        END DO
      END DO
C
      RETURN
      END
