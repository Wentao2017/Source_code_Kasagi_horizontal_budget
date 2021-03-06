!***********************************************************
!
program post
!
!***********************************************************

implicit none

integer,parameter :: nzb=1
integer,parameter :: nx1=256,ny1=257,nz1=256
character(len=3) suffix,suffix1
character(len=20) nfichier,nfichier1,nchamp
integer :: num,i,j,k,nb_fich,nb_proc_total,nb_proc,longueur,long,itime
integer :: nxyz,count,itime1,itime2,itime3


real(8),dimension(nx1,ny1,nz1) :: umean1,vmean1,wmean1,phimean1,uumean1,vvmean1,wwmean1,phiphimean1
real(8),dimension(nx1,ny1,nz1) :: uvmean1,uwmean1,vwmean1,utmean1,vtmean1,dudx1,dudy1,dudz1,dvdx1, &
                                  dvdy1,dvdz1,dwdx1,dwdy1,dwdz1,dudxdudx1,dudydudy1,dudzdudz1, &
                                  dvdxdvdx1,dvdydvdy1,dvdzdvdz1,dwdxdwdx1,dwdydwdy1,dwdzdwdz1,uuvmean1, &
                                  vvvmean1,vwwmean1,pmean1,pvmean1,dphidx1,dphidxdphidx1,dphidy1, &
                                  dphidydphidy1,dphidz1,dphidzdphidz1,vdpdy1,dpdy1,vvvvmean1
real(8),dimension(nx1,ny1,nz1) :: dudx2,dvdx2,dwdx2,dudy2,dvdy2,dwdy2,dudz2,dvdz2,dwdz2 
real(4),dimension(ny1) :: yp,ypi,ypii
real(8),dimension(nx1,ny1,nz1) :: umean2,vmean2,wmean2,uumean2,vvmean2,wwmean2
!real(8),dimension(nx1,ny1,nz1) :: uvmean2,uwmean2,vwmean2
real(4) :: u_to,u_to1,u_to2,re,xl2,xl3,xnu,x14,x15,pr,alpha,dxp,dzp,Re_tau,Gr_plus
real(4) :: xlx=15.70796,zlz=6.283185,Betaexp=0.001434397
real(8),dimension(ny1,53) :: q_stat


open (15,file='yp.dat',form='formatted',status='unknown')
do j=1,ny1
   read(15,*) yp(j)
print *,yp(j)
enddo
close(15)
print *,'read yp'

itime1=100000


OPEN(11,FILE='umean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) umean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
    ! print *,k,'UX',umean1(nx1/2,ny1/2,k)/itime
    ! print *,k,'UX',umean1(nx1/2,ny1/2,k)/itime1
  ENDDO
  CLOSE(11)
OPEN(11,FILE='vmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) vmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
    ! print *,k,'UY',vmean1(nx1/2,ny1/2,k)/itime
  ENDDO
  CLOSE(11)
OPEN(11,FILE='wmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) wmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
    ! print *,k,'UZ',wmean1(nx1/2,ny1/2,k)/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='uumean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) uumean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UXUX',uumean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='vvmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) vvmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UYUY',vvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='wwmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) wwmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wwmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='uuvmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) uuvmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wwmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='vvvmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) vvvmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wwmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='vwwmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) vwwmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wwmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='vwmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) vwmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wwmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='phimean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) phimean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
  ENDDO
  CLOSE(11)

OPEN(11,FILE='phiphimean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) phiphimean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
  ENDDO
  CLOSE(11)

OPEN(11,FILE='utmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) utmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',utmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='vtmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) vtmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',vtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='uvmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) uvmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)


OPEN(11,FILE='dudx.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dudx1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dudy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dudy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dudz.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dudz1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)


OPEN(11,FILE='dvdx.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dvdx1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dvdy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dvdy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dvdz.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dvdz1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dwdx.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dwdx1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dwdy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dwdy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dwdz.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dwdz1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dudxdudx.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dudxdudx1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dudydudy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dudydudy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dudzdudz.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dudzdudz1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dvdxdvdx.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dvdxdvdx1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dvdydvdy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dvdydvdy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dvdzdvdz.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dvdzdvdz1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dwdxdwdx.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dwdxdwdx1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dwdydwdy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dwdydwdy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dwdzdwdz.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dwdzdwdz1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='pmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) pmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='pvmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) pvmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',uvmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dphidx.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dphidx1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dphidxdphidx.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dphidxdphidx1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dphidy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dphidy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dphidydphidy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dphidydphidy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dphidz.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dphidz1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dphidzdphidz.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dphidzdphidz1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='vdpdy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) vdpdy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='dpdy.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) dpdy1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

OPEN(11,FILE='vvvvmean.dat',FORM='UNFORMATTED',&
       ACCESS='DIRECT', RECL=8, STATUS='OLD')
  COUNT = 1
  DO K=1,nz1
     DO J=1,ny1
        DO I=1,nx1
           READ(11,REC=COUNT) vvvvmean1(I,J,K)
           COUNT = COUNT + 1
        ENDDO
     ENDDO
     !print *,k,'UZUZ',wtmean1(nx1/2,ny1/2,k)!/itime
  ENDDO
  CLOSE(11)

  print *,'READ DATA DONE 1'

do j=1,ny1-1
   ypi(j)=(yp(j)+yp(j+1))/2.
enddo


do j=1,ny1-2
   ypii(j)=(ypi(j)+ypi(j+1))/2.
enddo

umean1=umean1/itime1
vmean1=vmean1/itime1
wmean1=wmean1/itime1
uumean1=uumean1/itime1
vvmean1=vvmean1/itime1
wwmean1=wwmean1/itime1
uuvmean1=uuvmean1/itime1
vvvmean1=vvvmean1/itime1
vwwmean1=vwwmean1/itime1
vwmean1=vwmean1/itime1
phimean1=phimean1/itime1
phiphimean1=phiphimean1/itime1
utmean1=utmean1/itime1
vtmean1=vtmean1/itime1
uvmean1=uvmean1/itime1
dudx1=dudx1/itime1
dudy1=dudy1/itime1
dudz1=dudz1/itime1
dvdx1=dvdx1/itime1
dvdy1=dvdy1/itime1
dvdz1=dvdz1/itime1
dwdx1=dwdx1/itime1
dwdy1=dwdy1/itime1
dwdz1=dwdz1/itime1
dudxdudx1=dudxdudx1/itime1
dudydudy1=dudydudy1/itime1
dudzdudz1=dudzdudz1/itime1
dvdxdvdx1=dvdxdvdx1/itime1
dvdydvdy1=dvdydvdy1/itime1
dvdzdvdz1=dvdzdvdz1/itime1
dwdxdwdx1=dwdxdwdx1/itime1
dwdydwdy1=dwdydwdy1/itime1
dwdzdwdz1=dwdzdwdz1/itime1
pmean1=pmean1/itime1
pvmean1=pvmean1/itime1
dphidx1=dphidx1/itime1
dphidxdphidx1=dphidxdphidx1/itime1
dphidy1=dphidy1/itime1
dphidydphidy1=dphidydphidy1/itime1
dphidz1=dphidz1/itime1
dphidzdphidz1=dphidzdphidz1/itime1
vdpdy1=vdpdy1/itime1
dpdy1=dpdy1/itime1
vvvvmean1=vvvvmean1/itime1

!DO AN AVERAGE IN X AND Z

q_stat=0.
do j=1,ny1
   do k=1,nz1
   do i=1,nx1
      q_stat(j,1)=q_stat(j,1)+umean1(i,j,k)
      q_stat(j,2)=q_stat(j,2)+vmean1(i,j,k)
      q_stat(j,3)=q_stat(j,3)+wmean1(i,j,k)
      q_stat(j,7)=q_stat(j,7)+phimean1(i,j,k)
!      q_stat(j,7)=q_stat(j,7)+phimean1(i,j,k)
      ! Direct Reynolds stresses
      q_stat(j,4)=q_stat(j,4)+uumean1(i,j,k)
      q_stat(j,5)=q_stat(j,5)+vvmean1(i,j,k)
      q_stat(j,6)=q_stat(j,6)+wwmean1(i,j,k)
      q_stat(j,8)=q_stat(j,8)+phiphimean1(i,j,k)
      q_stat(j,9)=q_stat(j,9)+utmean1(i,j,k)
      q_stat(j,10)=q_stat(j,10)+vtmean1(i,j,k)
      q_stat(j,11)=q_stat(j,11)+uvmean1(i,j,k)
      q_stat(j,12)=q_stat(j,12)+dudy1(i,j,k)
      q_stat(j,13)=q_stat(j,13)+uuvmean1(i,j,k)
      q_stat(j,14)=q_stat(j,14)+vvvmean1(i,j,k)
      q_stat(j,15)=q_stat(j,15)+vwwmean1(i,j,k)
      q_stat(j,16)=q_stat(j,16)+vwmean1(i,j,k)
      q_stat(j,18)=q_stat(j,18)+pmean1(i,j,k)
      q_stat(j,19)=q_stat(j,19)+pvmean1(i,j,k)
      q_stat(j,21)=q_stat(j,21)+dudx1(i,j,k)
      q_stat(j,22)=q_stat(j,22)+dudz1(i,j,k)
      q_stat(j,23)=q_stat(j,23)+dvdx1(i,j,k)
      q_stat(j,24)=q_stat(j,24)+dvdy1(i,j,k)
      q_stat(j,25)=q_stat(j,25)+dvdz1(i,j,k)
      q_stat(j,26)=q_stat(j,26)+dwdx1(i,j,k)
      q_stat(j,27)=q_stat(j,27)+dwdy1(i,j,k)
      q_stat(j,28)=q_stat(j,28)+dwdz1(i,j,k)
      q_stat(j,29)=q_stat(j,29)+dudxdudx1(i,j,k)
      q_stat(j,30)=q_stat(j,30)+dudydudy1(i,j,k)
      q_stat(j,31)=q_stat(j,31)+dudzdudz1(i,j,k)
      q_stat(j,32)=q_stat(j,32)+dvdxdvdx1(i,j,k)
      q_stat(j,33)=q_stat(j,33)+dvdydvdy1(i,j,k)
      q_stat(j,34)=q_stat(j,34)+dvdzdvdz1(i,j,k)
      q_stat(j,35)=q_stat(j,35)+dwdxdwdx1(i,j,k)
      q_stat(j,36)=q_stat(j,36)+dwdydwdy1(i,j,k)
      q_stat(j,37)=q_stat(j,37)+dwdzdwdz1(i,j,k)
      q_stat(j,39)=q_stat(j,39)+dphidx1(i,j,k)
      q_stat(j,40)=q_stat(j,40)+dphidxdphidx1(i,j,k)
      q_stat(j,41)=q_stat(j,41)+dphidy1(i,j,k)
      q_stat(j,42)=q_stat(j,42)+dphidydphidy1(i,j,k)
      q_stat(j,43)=q_stat(j,43)+dphidz1(i,j,k)
      q_stat(j,44)=q_stat(j,44)+dphidzdphidz1(i,j,k)
      q_stat(j,47)=q_stat(j,47)+vdpdy1(i,j,k)
      q_stat(j,49)=q_stat(j,49)+dpdy1(i,j,k)
      q_stat(j,52)=q_stat(j,52)+vvvvmean1(i,j,k)
 
   enddo
   enddo
!   print *,j,umean1(nx1/2,j,nz1/2)
!   print 100,q_stat(j,1)/nx1/nz1,q_stat(j,4)/nx1/nz1,q_stat(j,4)/nx1/nz1-q_stat(j,1)/nx1/nz1*q_stat(j,1)/nx1/nz1
enddo
q_stat(:,:)=q_stat(:,:)/nx1/nz1
!   print *,q_stat(:,1)

xnu=1./3510!10322.629 !**********no s'e qu'e son estos num creo que la visco
re=3510!10322.629 !Creo qeu es el reynold usado
pr=0.71
alpha=xnu/pr

!!!!!!!!!!!!
!From hot wall
!!!!!!!!!!!!

   xl3=xnu*(q_stat(2,1)-q_stat(1,1))/(yp(2)-yp(1))
   xl2=sqrt(xl3)/xnu
   print *,'Re_tau = ',xl2
   Re_tau=xl2
   u_to1=xl2
   u_to=u_to1/re
   dxp=xlx/(nx1-1)*xl2
   dzp=zlz/(nz1-1)*xl2

!friction temperature
   x14=-(q_stat(2,7)-q_stat(1,7))/(yp(2)-yp(1))
   x15=x14/(pr*re*u_to) !friction temperature  
   print *,'Theta_tau = ',x15

   Gr_plus = 9.8*Betaexp*x15*(1/Re_tau)**3/xnu**2 

do j=1,ny1
   q_stat(j,13)=-0.5*(q_stat(j,13)-q_stat(j,4)*q_stat(j,2)-2*q_stat(j,11)*q_stat(j,1)+ &
                      q_stat(j,14)-3*q_stat(j,2)*q_stat(j,5)+ &
                      q_stat(j,15)-q_stat(j,2)*q_stat(j,6)-2*q_stat(j,3)*q_stat(j,16))/(u_to*u_to*u_to)   !-0.5*ui'ui'v'
enddo

do j=1,ny1-1
   q_stat(j,13)=(q_stat(j+1,13)-q_stat(j,13))/((yp(j+1)-yp(j))*xl2)             !Turbulent diffusion  
enddo

do j=1,ny1
   q_stat(j,17)=0.5*((q_stat(j,4)-q_stat(j,1)*q_stat(j,1))/(u_to*u_to)+ &
                    (q_stat(j,5)-q_stat(j,2)*q_stat(j,2))/(u_to*u_to)+ &
                    (q_stat(j,6)-q_stat(j,3)*q_stat(j,3))/(u_to*u_to))      !K+
enddo

do j=1,ny1-1
   q_stat(j,17)=(q_stat(j+1,17)-q_stat(j,17))/((yp(j+1)-yp(j))*xl2)
enddo

do j=1,ny1-2
   q_stat(j,17)=(q_stat(j+1,17)-q_stat(j,17))/((ypi(j+1)-ypi(j))*xl2)      !Viscous diffusion 
enddo

do j=1,ny1
   q_stat(j,18)=(q_stat(j,19)-q_stat(j,18)*q_stat(j,2))/(u_to*u_to*u_to)   !p'+v'+
enddo

do j=1,ny1-1
   q_stat(j,18)=-1000*(q_stat(j+1,18)-q_stat(j,18))/((yp(j+1)-yp(j))*xl2)        !Pressure diffusion  
enddo

do j=1,ny1
   q_stat(j,51)=(q_stat(j,14)-3*q_stat(j,2)*q_stat(j,5))/(q_stat(j,5)-q_stat(j,2)*q_stat(j,2))**1.5        !Skewness v 
enddo

do j=1,ny1
   q_stat(j,53)=(q_stat(j,52)-4*q_stat(j,2)*q_stat(j,14)-3*q_stat(j,5)*q_stat(j,5))/(q_stat(j,5)-q_stat(j,2)*q_stat(j,2))**2  !Flatness v 
enddo

do j=1,ny1
   print 100,q_stat(j,1),q_stat(j,4),q_stat(j,4)-q_stat(j,1)*q_stat(j,1),q_stat(j,8)-q_stat(j,7)*q_stat(j,7)
   q_stat(j,4)=sqrt((q_stat(j,4)-q_stat(j,1)*q_stat(j,1)))/u_to
   q_stat(j,5)=sqrt((q_stat(j,5)-q_stat(j,2)*q_stat(j,2)))/u_to
   q_stat(j,6)=sqrt((q_stat(j,6)-q_stat(j,3)*q_stat(j,3)))/u_to
   q_stat(j,8)=sqrt((q_stat(j,8)-q_stat(j,7)*q_stat(j,7)))/x15
   q_stat(j,9)=(q_stat(j,9)-q_stat(j,1)*q_stat(j,7))/(-u_to*x15)
   q_stat(j,10)=(q_stat(j,10)-q_stat(j,2)*q_stat(j,7))/(-u_to*x15)
   q_stat(j,11)=(q_stat(j,11)-q_stat(j,1)*q_stat(j,2))/(u_to*u_to)  
   q_stat(j,38)=-q_stat(j,11)*q_stat(j,12)*xnu/(u_to*u_to)                     !Shear production
   q_stat(j,20)=-Gr_plus*q_stat(j,10)                        !Production by buoyancy
   q_stat(j,21)=-(q_stat(j,29)-q_stat(j,21)*q_stat(j,21)+ &
                  q_stat(j,30)-q_stat(j,12)*q_stat(j,12)+ &
                  q_stat(j,31)-q_stat(j,22)*q_stat(j,22)+ &
                  q_stat(j,32)-q_stat(j,23)*q_stat(j,23)+ & 
                  q_stat(j,33)-q_stat(j,24)*q_stat(j,24)+ & 
                  q_stat(j,34)-q_stat(j,25)*q_stat(j,25)+ &
                  q_stat(j,35)-q_stat(j,26)*q_stat(j,26)+ &
                  q_stat(j,36)-q_stat(j,27)*q_stat(j,27)+ &
                  q_stat(j,37)-q_stat(j,28)*q_stat(j,28))/(u_to*xl2)**2           !Dissipation
   q_stat(j,45)=alpha*(q_stat(j,40)+q_stat(j,42)+q_stat(j,44)-q_stat(j,39)*q_stat(j,39)-q_stat(j,41)*&
                 q_stat(j,41)-q_stat(j,43)*q_stat(j,43))/(x15*x15)
   q_stat(j,46)=q_stat(j,11)*q_stat(j,41)/(q_stat(j,10)*q_stat(j,12))*u_to/x15

enddo

100 format(2F12.6,2F12.6,2F12.6,2F12.6,2F12.6,2F12.6,3x,2F12.6,3x,2F12.6)
!100 format(13F12.6)

  open (144,file='Flow_cf_Nu.dat',form='formatted',status='unknown')
  do j=1,ny1
      write(144,100) yp(j),yp(j)*xl2,((q_stat(j,1)/u_to)+(q_stat(j,1)/u_to))/2.,&
           (q_stat(j,4)+q_stat(j,4))/2.,(q_stat(j,5)+q_stat(j,5))/2.,&
           (q_stat(j,6)+q_stat(j,6))/2.,((q_stat(j,7)/x15)+(q_stat(j,7)/x15))/2.,&
           (q_stat(j,8)+q_stat(j,8))/2.,(q_stat(j,9)+q_stat(j,9))/2.,(q_stat(j,10)+q_stat(j,10))/2.,&
           (q_stat(j,11)+q_stat(j,11))/2.,(q_stat(j,45)+q_stat(j,45))/2.,(q_stat(j,46)+q_stat(j,46))/2.
   enddo
   close(144)

  open (144,file='Flow_budget.dat',form='formatted',status='unknown')
  do j=1,ny1/2
      write(144,100) yp(j),yp(j)*xl2,q_stat(j,38),q_stat(j,20),q_stat(j,21)
   enddo
   close(144)

  open (144,file='Flow_budget2.dat',form='formatted',status='unknown')
  do j=1,ny1/2
      write(144,100) ypi(j),ypi(j)*xl2,q_stat(j,13),q_stat(j,18)
   enddo
   close(144)

  open (144,file='Flow_budget3.dat',form='formatted',status='unknown')
  do j=1,ny1/2
      write(144,100) ypii(j),ypii(j)*xl2,q_stat(j,17)
   enddo
   close(144)

  open (144,file='Flow_skewness_flatness.dat',form='formatted',status='unknown')
  do j=1,ny1/2
      write(144,100) yp(j),yp(j)*xl2,q_stat(j,51),q_stat(j,53)
   enddo
   close(144)

end program post
!******************************************************************
!
subroutine numcar (num,car)
!
!******************************************************************!

character(len=3) car

if (num.ge.100) then
   write (car,1) num
1  format (i3)
else
   if (num.ge.10) then
      write (car,2) num
2     format ('0',i2)
   else
      write (car,3) num
3     format ('00',i1)
   endif
endif

return
end subroutine numcar

!1. y
!2. y+
!3. u+
!4. u_rms
!5. v_rms
!6. w_rms
!7. t+
!8. t_rms
!9. ut
!10. vt
!11. uv
!12. wt
!13. Epsilon_theta_wrong
!14. Epsilon_theta_correct
!15. Prt
