module sh_recurrence
  use string,    only: to_str
  use iso_fortran_env, only: ounit_ => output_unit
  implicit none

  public :: sh_rec
  public :: sh_int
  public :: recur

  private

  real, parameter :: pi_ = 3.141592653589793

  type :: recur
    character            :: omiga= ''   !< direction ['1','x','y','z']
    integer              :: l    = 0    !< spherical harmonics degree
    integer              :: m    = 0    !< spherical harmonics order
    integer              :: num  = 0    !< coeffient number
    integer, allocatable :: l_idx(:)    !< (num)
    integer, allocatable :: m_idx(:)    !< num
    real, allocatable    :: coef(:)     !< num
  contains
    procedure :: add       => recur_add
    procedure :: destory   => recur_destory
    procedure :: print     => recur_print
    final     :: recur_final
  end type recur

contains
  !=============================================================================
  pure subroutine recur_add(this,l,m,c)
    !< add term in recurrence relation
    class(recur), intent(inout) :: this
    integer, intent(in) :: l            !< index l
    integer, intent(in) :: m            !< index m
    real, intent(in)    :: c            !< recurrence coefficient

    if (this%num == 0) then
      this%coef = [real :: ]
      this%l_idx = [integer :: ]
      this%m_idx = [integer :: ]
      this%num = this%num + 1
    else
      this%num = this%num + 1
    end if

    this%l_idx = [this%l_idx,l]
    this%m_idx = [this%m_idx,m]
    this%coef = [this%coef,c]

  end subroutine recur_add
  !=============================================================================
  elemental subroutine recur_destory(this)
    !< destory recur
    class(recur), intent(inout) :: this

    if(allocated(this%l_idx))  deallocate(this%l_idx)
    if(allocated(this%m_idx))  deallocate(this%m_idx)
    if(allocated(this%coef))   deallocate(this%coef)

    this%l = 0
    this%m = 0
    this%num   = 0
    this%omiga = ''

  end subroutine recur_destory
  !=============================================================================
  elemental subroutine recur_final(this)
    type(recur), intent(inout) :: this
    call this%destory()
  end subroutine recur_final
  !=============================================================================
  subroutine recur_print(this,unit)
    !< print recurrence relation
    class(recur), intent(in)    :: this
    integer,intent(in),optional :: unit
    integer :: lunit,i

    lunit = ounit_
    if(present(unit)) lunit = unit

    write(lunit,'(a)',advance='no') 'omiga('//this%omiga//')*'//'Y('//to_str(this%l)//','//to_str(this%m)//') = '
    do i = 1,this%num
      write(lunit,'(a)',advance='no')'('// to_str(this%coef(i))//')*Y('//to_str(this%l_idx(i))//','//to_str(this%m_idx(i))//')'
      if(i/= this%num) write(lunit,'(a)',advance='no') '+'
    end do
    write(lunit,*)
  end subroutine recur_print
  !=============================================================================
  function sh_rec(omiga,n,m) result(this)
    !< add recurrence relation
    character, intent(in) :: omiga !< omiga = '1','x','y'
    integer, intent(in)   :: n     !< degree of spherical harmonics (n>=0)
    integer, intent(in)   :: m     !< order of spherical harmonics (-n<= m <= n)

    type(recur) :: this
    real        :: temp

    if( omiga /= '1' .and. omiga /= 'x'.and. omiga /= 'y'.and.omiga /= 'z') then
      error stop "the range of omiga: ['1','x','y','z']"
    end if

    if(n<0) then
      error stop 'the range of l: [l>=0]'
    end if

    if(abs(m)>n) then
      error stop 'the range of m: [-l<=m<=l]'
    end if

    this%omiga = omiga
    this%l     = n
    this%m     = m

    temp = 0.5/(2*n+1)
    if(omiga=='1')then
      call this%add(n,m,1.0)
      return
    elseif(omiga== 'x')then
      if(m>0)then
        call this%add(n-1,m+1,temp)
        call this%add(n+1,m+1,-temp)
        call this%add(n+1,m-1,temp*(n-m+1)*(n-m+2))
        call this%add(n-1,m-1,-temp*(n+m)*(n+m-1))
        return
      elseif(m==0)then
        call this%add(n-1,m+1,2*temp)
        call this%add(n+1,m+1,-2*temp)
        return
      elseif(m==-1)then
        call this%add(n-1,m-1,temp)
        call this%add(n+1,m-1,-temp)
        return
      elseif(m<-1)then
        call this%add(n-1,m-1,temp)
        call this%add(n+1,m-1,-temp)
        call this%add(n+1,m+1,temp*(n+m+1)*(n+m+2))
        call this%add(n-1,m+1,-temp*(n-m)*(n-m-1))
        return
      endif
    elseif(omiga== 'y')then
      if(m>1)then
        call this%add(n-1,-m-1,temp)
        call this%add(n+1,-m-1,-temp)
        call this%add(n+1,-m+1,-temp*(n-m+1)*(n-m+2))
        call this%add(n-1,-m+1,temp*(n+m)*(n+m-1))
        return
      elseif(m==1)then
        call this%add(n-1,-m-1,temp)
        call this%add(n+1,-m-1,-temp)
        return
      elseif(m==0)then
        call this%add(n-1,-1,2*temp)
        call this%add(n+1,-1,-2*temp)
        return
      elseif(m<0)then
        call this%add(n-1,-m+1,-temp)
        call this%add(n+1,-m+1,temp)
        call this%add(n+1,-m-1,temp*(n+m+1)*(n+m+2))
        call this%add(n-1,-m-1,-temp*(n-m)*(n-m-1))
        return
      endif
    elseif(omiga=='z')then
      call this%add(n+1,m,2*temp*(n-abs(m)+1))
      call this%add(n-1,m,2*temp*(n+abs(m)))
      return
    endif

  end function sh_rec
  !=============================================================================
  function sh_int(omiga1,n1,m1,omiga2,n2,m2) result(res)
    ! the integral of omiga1*sh1*omiga2*sh2
    character, intent(in) :: omiga1,omiga2 !< omiga = '1','x','y'
    integer, intent(in)   :: n1,n2         !< degree of spherical harmonics (n>=0)
    integer, intent(in)   :: m1,m2         !< order of spherical harmonics (-n<= m <= n)

    real        :: res
    type(recur) :: rec1, rec2
    integer     :: i,j

    rec1 = sh_rec(omiga1,n1,m1)
    rec2 = sh_rec(omiga2,n2,m2)

    res = 0.0
    do i = 1,rec1%num
      do j = 1,rec2%num
        if(rec1%l_idx(i) == rec2%l_idx(j).and.&
        rec1%m_idx(i) == rec2%m_idx(j)) then
        res = res + rec1%coef(i)*rec2%coef(j)/&
        (sh_coef(rec1%l_idx(i),rec1%m_idx(i))*sh_coef(rec1%l_idx(i),rec1%m_idx(i)))
      end if
    end do
  end do

  res = res*sh_coef(n1,m1)*sh_coef(n2,m2)

end function sh_int
!=============================================================================
pure real function sh_coef(n,m)
  !< normalize coeffient
  integer,intent(in) :: n,m

  integer :: i
  real :: fact

  fact = 1.0

  if(m == 0) then
    sh_coef = sqrt((2.0*n+1.0)/(4.0*pi_))
  else
    do i = n-abs(m)+1,n+abs(m)
      fact = fact*i
    end do
    sh_coef = sqrt((2.0*n+1.0)/(2.0*pi_*fact))
  endif

end function sh_coef

end module sh_recurrence
