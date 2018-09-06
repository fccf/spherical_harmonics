
# 球谐函数模块 [sh_value](./src/lib/sh_value.f90)

通过 f2py 可以将 fortran 模块生成动态链接库，直接在 python 中使用。通过以下命令生成动态库 **sh.so**, 然后在 pyhton 使用该模块，并对该模块进行验证。
>f2py -c sh_value.f90 -m sh

## 勒让得多项式
通过 [plot_pl](./tools/plot_pl.py) 画出勒让得多项式的图像对其进行验证

- LegendrePolynomial
  ![LegendrePolynomial](./data/LegendrePolynomial.png)

## 连带勒让得多项式
通过 [plot_plm](./tools/plot_plm.py) 画出连带勒让得多项式的图像对其进行验证
- AssociateLegendrePolynomial
  ![AssociateLegendrePolynomial](./data/AssociateLegendrePolynomial.png)

## 球谐函数
通过 [plot_ylm](./tools/plot_ylm.py) 画出球谐函数的图像对其进行验证
- SphericalHarmonics
  ![SphericalHarmonics](./data/SphericalHarmonics.png)

# 球谐函数递推关系模块[sh_recurrence](./src/lib/sh_recurrence.F90)

球谐函数存在如下递推关系：

$Ω_x\vec{Y}(Ω) = \mathbf{A}_x\vec{Y}(Ω)$

$Ω_y\vec{Y}(Ω) = \mathbf{A}_y\vec{Y}(Ω)$

$Ω_z\vec{Y}(Ω) = \mathbf{A}_z\vec{Y}(Ω)$

其中矩阵 $ \mathbf{A}_x,  \mathbf{A}_y,  \mathbf{A}_z$ 分别为 $x,y,z$ 方向上的递推关系矩阵。



## 球谐函数正交关系

$ \mathbf{A} = \int_{\Omega} \vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega$

![A](./data/A.png)

## x方向递推关系

$ \mathbf{A}_x = \int_{\Omega} Ω_x\vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega$

![Ax](./data/Ax.png)

## y方向递推关系

$ \mathbf{A}_y = \int_{\Omega} Ω_y\vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega$

![Ay](./data/Ay.png)

## z方向递推关系
$ \mathbf{A}_z = \int_{\Omega} Ω_z\vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega$

![Az](./data/Az.png)
