# awk实例


## 截取字符串

* 截取每行字符串中url字符串

```
awk '{for(i=1;i<=NF;i++)if($i~"^/") print $i}'

```

* 截取每段字符串中的数字

```
awk -F "[^0-9]+" '{for(i=1;i<=NF;i++) print $i}'

```

