
# 球谐函数模块 [sh_value](./src/lib/sh/sh_value.f90)

## 实值的球谐函数
该模块主要定义了实值的球谐函数如下：

$$Y_{n,m}(\Omega) = \left\{\begin{matrix}
\sqrt{\frac{(2n+1)(n-m)!}{2\pi(n+m)!}}P_{n}^{m}(\mu)cos(m\varphi) & m>0\\
\sqrt{\frac{(2n+1)}{4\pi}}P_{n}(\mu) & m=0 \\
\sqrt{\frac{(2n+1)(n-|m|)!}{2\pi(n+|m|)!}}P_{n}^{|m|}(\mu)sin(|m|\varphi) & m<0
\end{matrix}\right.$$

## f2py
通过 f2py 可以将 fortran 模块生成动态链接库，直接在 python 中使用。通过以下命令生成动态库 **sh.so**, 然后在 pyhton 使用该模块，并对该模块进行验证。
>f2py -c sh_value.f90 -m sh

## 勒让得多项式
通过 [plot_pl](./tools/plot_pl.py) 画出勒让得多项式的图像对其进行验证

- LegendrePolynomial
  ![LegendrePolynomial](http://on08uqozg.bkt.clouddn.com/legendre_polynomial.png)

## 连带勒让得多项式
通过 [plot_plm](../tools/plot_plm.py) 画出连带勒让得多项式的图像对其进行验证
- AssociateLegendrePolynomial
  ![AssociateLegendrePolynomial](http://on08uqozg.bkt.clouddn.com/associate_legendre_polynomial.png)

## 球谐函数
通过 [plot_ylm](../tools/plot_ylm.py) 画出球谐函数的图像对其进行验证
- SphericalHarmonics
  ![SphericalHarmonics](http://on08uqozg.bkt.clouddn.com/spherical_harmonics.png)

# 球谐函数递推关系模块[sh_recurrence](../src/lib/sh/sh_recurrence.f90)

球谐函数存在如下递推关系：

$$Ω_x\vec{Y}(Ω) = \mathbf{A}_x\vec{Y}(Ω)$$

$$Ω_y\vec{Y}(Ω) = \mathbf{A}_y\vec{Y}(Ω)$$

$$Ω_z\vec{Y}(Ω) = \mathbf{A}_z\vec{Y}(Ω)$$

其中矩阵 $ \mathbf{A}_x,  \mathbf{A}_y,  \mathbf{A}_z$ 分别为 $x,y,z$ 方向上的递推关系矩阵，又被称为角度Jacobian矩阵。


## 球谐函数正交关系
定义的球谐函数是正交归一的，内积是一个单位矩阵
$$ \mathbf{A} = \int_{\Omega} \vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega = \mathbf{I}$$

![A](http://on08uqozg.bkt.clouddn.com/A1-tp2.png)

## x方向递推关系

定义 $Y_{n,m}^{’}$ 为不带归一化系数的球谐函数，由连带勒让得多项式和三角函数的乘积组成，其递推关系为：
- m > 0
$$ \eta Y_{n,m}^{’}= \frac{1}{2(2n+1)} [Y_{n-1,m+1}^{’} - Y_{n+1,m+1}^{’} + (n-m+2)(n-m+1) Y_{n+1,m-1}^{’} - (n+m)(n+m-1) Y_{n-1,m-1}^{’}]$$

- m = 0
$$ \eta Y_{n,0}^{’}= \frac{1}{2n+1} [Y_{n-1,1}^{’} - Y_{n+1,1}^{’}]$$

- m = -1
$$ \eta Y_{n,-1}^{’}= \frac{1}{2(2n+1)} [Y_{n-1,-2}^{’} - Y_{n+1,-2}^{’}]$$

- m < -1
$$ \eta Y_{n,m}^{’}= \frac{1}{2(2n+1)} [Y_{n-1,m-1}^{’} - Y_{n+1,m-1}^{’} + (n+m+2)(n+m+1) Y_{n+1,m+1}^{’} - (n-m)(n-m-1) Y_{n-1,m+1}^{’}]$$

通过以上递推关系式，可以直接得到递推关系矩阵$\mathbf{A}_x$。
根据球谐函数正交关系可知 $\mathbf{A}_x$ 可以表示为：
$$ \mathbf{A}_x = \int_{\Omega} Ω_x\vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega$$

$\mathbf{A}_x$ 的稀疏矩阵图可以表示为
![Ax](http://on08uqozg.bkt.clouddn.com/Ax-tp2.png)

## y方向递推关系
非归一化球谐函数  $Y_{n,m}^{’}$ 在y方向的递推关系为
- m > 1
$$ \xi Y_{n,m}^{’}= \frac{1}{2(2n+1)} [Y_{n-1,-m-1}^{’} - Y_{n+1,-m-1}^{’} + (n+m+2)(n+m+1) Y_{n+1,-m+1}^{’} - (n-m)(n-m-1) Y_{n-1,-m+1}^{’}]$$

- m = 1
$$ \xi Y_{n,-1}^{’}= \frac{1}{2(2n+1)} [Y_{n-1,-2}^{’} - Y_{n+1,-2}^{’}]$$

- m = 0
$$ \xi Y_{n,0}^{’}= \frac{1}{2n+1} [Y_{n-1,-1}^{’} - Y_{n+1,-1}^{’}]$$

- m < 0
$$ \xi Y_{n,m}^{’}= \frac{1}{2(2n+1)} [Y_{n+1,-m+1}^{’} - Y_{n-1,-m+1}^{’} + (n+m+2)(n+m+1) Y_{n+1,-m-1}^{’} - (n-m)(n-m-1) Y_{n-1,-m-1}^{’}]$$

递推关系矩阵$ \mathbf{A}_y$为：
$$ \mathbf{A}_y = \int_{\Omega} Ω_y\vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega$$

$ \mathbf{A}_y$的稀疏矩阵图为
![Ay](http://on08uqozg.bkt.clouddn.com/Ay-tp2.png)

## z方向递推关系
非归一化球谐函数  $Y_{n,m}^{’}$ 在z方向的递推关系为
$$\mu Y_{n,m}^{’}=\frac{1}{2n+1}[(n-|m|+1)Y_{n+1,m}^{’}+(n+|m|)Y_{n-1,m}^{’}]$$

递推关系矩阵$ \mathbf{A}_y$为：

$$ \mathbf{A}_{z} = \int_{\Omega} Ω_z\vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega$$

$ \mathbf{A}_z$的稀疏矩阵图为
![Az](http://on08uqozg.bkt.clouddn.com/Az-tp2.png)

# 边界上的角度矩阵

## 边界角度矩阵
边界上的角度矩阵是$x,y,z$方向上的角度矩阵在法线上的投影，定义为
$$ \mathbf{A}_{n} = \int_{\Omega} n \cdot \Omega\vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega = n_x \mathbf{A}_{x} + n_y \mathbf{A}_{y} + n_z \mathbf{A}_{z} $$

法向量 $n = \frac{\sqrt{3}}{3}[1,1,1]^{T}$ 时，矩阵的稀疏矩阵图为
![An](http://on08uqozg.bkt.clouddn.com/An.png)

## 特征值分解
定义出流边界矩阵
$$ \mathbf{A}_{n}^{+} = \int_{n\cdot\Omega>0} n \cdot \Omega\vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega $$

入流边界矩阵
$$ \mathbf{A}_{n}^{-} = \int_{n\cdot\Omega<0} n \cdot \Omega\vec{Y}(Ω) \vec{Y}^{T}(Ω) d\Omega $$

可以通过特征值分解来求解入流边界矩阵与出流矩阵。

$$\mathbf{A}_{n} = \mathbf{V}\Lambda\mathbf{V}^{T}=\mathbf{V}(\Lambda^{+}+\Lambda^{-})\mathbf{V}^{T}=\mathbf{A}_{n}^{+}+\mathbf{A}_{n}^{-}$$

其中 $\Lambda$ 为矩阵的特征值组成的对角矩阵，$\mathbf{A}_{n}^{+}$ 是特征值为正的分量，$\mathbf{A}_{n}^{-}$ 为特征值为负的分量。

法向量 $n = \frac{\sqrt{3}}{3}[1,1,1]^{T}$ 时，入流矩阵和出流矩阵分别为
- 入流矩阵
![Anm](http://on08uqozg.bkt.clouddn.com/Anm.png)

- 出流矩阵
![Anp](http://on08uqozg.bkt.clouddn.com/Anp.png)

## 反射矩阵
反射矩阵是将原方向的角度展开矩反射到反射角度上的角度展开矩，反射矩阵定义为
$$ \mathbf{A}_{r} = \int_{\Omega} \vec{Y}(Ω) \vec{Y}^{T}(\mathbf{H}Ω) d\Omega $$

其中 $\mathbf{H}Ω$ 是 角度 $Ω$ 关于法向量 $n$ 的反射角
$$\mathbf{H} = \mathbf{I} - n n^{T} $$

反射矩阵可以通过数值积分进行求解；当法向量 $n = \frac{\sqrt{3}}{3}[1,1,1]^{T}$ 时，反射矩阵为

![Ar](http://on08uqozg.bkt.clouddn.com/Ar.png)


## 边界条件角度矩阵
真空边界条件中，入流为零，所以边界上的角度矩阵为出流矩阵，即
$$\mathbf{A}_{b} = \mathbf{A}_{n}^{+}$$
![Anp](http://on08uqozg.bkt.clouddn.com/Anp.png)

反射边界条件中，入流为出流的反射，此时边界矩阵为
$$\mathbf{A}_{b} = \mathbf{A}_{n}^{+} + \mathbf{A}_{n}^{-}\mathbf{A}_{r}$$

![Ab](http://on08uqozg.bkt.clouddn.com/Ab.png)

以上都是  $n = \frac{\sqrt{3}}{3}[1,1,1]^{T}$ 时的边界矩阵。

### x方向上边界角度矩阵
- 法向量
 $n = [1,0,0]^{T}$

- 边界角度矩阵
![ax](http://on08uqozg.bkt.clouddn.com/ax.png)

- 入流矩阵
![axm](http://on08uqozg.bkt.clouddn.com/axm.png)

- 出流矩阵
![axp](http://on08uqozg.bkt.clouddn.com/axp.png)

- 反射矩阵
![axr](http://on08uqozg.bkt.clouddn.com/axr.png)

- 反射边界矩阵
![axb](http://on08uqozg.bkt.clouddn.com/axb.png)

### y方向上边界角度矩阵
- 法向量
 $n = [0,1,0]^{T}$

- 边界角度矩阵
![Ay](http://on08uqozg.bkt.clouddn.com/Ay.png)

- 入流矩阵
![Aym](http://on08uqozg.bkt.clouddn.com/Aym.png)

- 出流矩阵
![Ayp](http://on08uqozg.bkt.clouddn.com/Ayp.png)

- 反射矩阵
![Ayr](http://on08uqozg.bkt.clouddn.com/Ayr.png)

- 反射边界矩阵
![Ayb](http://on08uqozg.bkt.clouddn.com/Ayb.png)

### z方向上边界角度矩阵
- 法向量
 $n = [0,0,1]^{T}$

- 边界角度矩阵
![Az](http://on08uqozg.bkt.clouddn.com/Az.png)

- 入流矩阵
![Azm](http://on08uqozg.bkt.clouddn.com/Azm.png)

- 出流矩阵
![Azp](http://on08uqozg.bkt.clouddn.com/Azp.png)

- 反射矩阵
![Azr](http://on08uqozg.bkt.clouddn.com/Azr.png)

- 反射边界矩阵
![Azb](http://on08uqozg.bkt.clouddn.com/Azb.png)
