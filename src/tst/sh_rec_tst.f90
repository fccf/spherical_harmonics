program sh_rec_test
  use sh_recurrence
  use string
  implicit none

  integer,parameter :: lmax = 15
  integer,parameter :: d = (lmax+1)*(lmax+1)
  type(recur) :: rec
  real        :: a(d,d),ax(d,d),ay(d,d),az(d,d)
  integer     :: i,j,l1,m1,l2,m2
  integer     :: unit

  rec = sh_rec('x',4,2)
  call rec%print()

  i = 0
  do l1 = 0,lmax
    do m1 = -l1,l1
      i = i+1
      j = 0
      do l2= 0,lmax
        do m2 = -l2,l2
          j = j+1

          a(j,i) = sh_int('1',l1,m1,'1',l2,m2)
          ax(j,i) = sh_int('1',l1,m1,'x',l2,m2)
          ay(j,i) = sh_int('1',l1,m1,'y',l2,m2)
          az(j,i) = sh_int('1',l1,m1,'z',l2,m2)
        end do
      end do

    end do
  end do

  open(newunit = unit, file = '../data/a.txt' )
  do i = 1,d
    write(unit,*) (a(i,j),j=1,d)
  enddo
  close(unit)

  open(newunit = unit, file = '../data/ax.txt' )
  do i = 1,d
    write(unit,*) (ax(i,j),j=1,d)
  enddo
  close(unit)

  open(newunit = unit, file = '../data/ay.txt' )
  do i = 1,d
    write(unit,*) (ay(i,j),j=1,d)
  enddo
  close(unit)

  open(newunit = unit, file = '../data/az.txt' )
  do i = 1,d
    write(unit,*) (az(i,j),j=1,d)
  enddo
  close(unit)

end program sh_rec_test
