# awk运算

* 正常加( + )减( - )乘( * )除(/)等运算

```
awk 'BEGIN{print 8*8}'

```

* 小数取整数int()，小数点后舍弃

```

awk 'BEGIN{print int(8/3)}'

```

* 小数取整数，四舍五入加0.5

```

awk 'BEGIN{print int(8/3+0.5)}'
> 3

```

* 保留小数点后指定位数

```

awk 'BEGIN{printf "%.2f\n",8/3}'
>2.67
#变量
a=8
b=3
echo "$a $b" | awk '{printf "%.2f\n",$1/$2}' 
> 2.67

```

