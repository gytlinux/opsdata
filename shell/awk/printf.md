# awk-printf函数

打印输出时，可能需要指定字段间的空格数，从而把列排整齐。在print函数中使用制表符并不能保证得到想要的输出，因此，可以用printf函数来格式化特别的输出。

printf函数返回一个带格式的字符串给标准输出，如同C语言中的printf语句一样。printf语句包括一个加引号的控制串，控制串中可能嵌有若干格式说明和修饰符。控制串后面跟一个逗号，之后是一列由逗号分隔的表达式。printf函数根据控制串中的说明编排这些表达式的格式。与print函数不同的是， printf不会在行尾自动换行。因此，如果要换行，就必须在控制串中提供转义字符\n。

每一个百分号和格式说明都必须有一个对应的变量。要打印百分号就必须在控制串中给出两个百分号。请参考print转义字符和printf修饰符。格式说明由百分号引出，另外还列出了printf所用的格式说明符。


* printf转义符

| 转义字符 | 定义 |
| -------- | ---- |
| c | 字符 |
| s | 字符串 | 
| d | 十进制整数 | 
| ld | 十进制长整数 |
| u | 十进制无符号整数 |
| lu | 十进制无符号长整数 |
| x | 十六进制整数 |
| lx | 十六进制长整数 |
| o | 八进制整数 |
| lo | 八进制长整数 |
| e | 用科学记数法(e记数法)表示的浮点数 |
| f | 浮点数 |
| g | 选用e或f中较短的一种形式 |

* printf修饰符

| 字符 | 定义 |
| ---- | ---- |
| - | 左对齐修饰符 |
| # | 显示8进制整数时在前面加个0 <br> 显示16进制时在前面加0x |
| + | 显示使用d、e、f和g转换的整数时，加上正负号+或- |
| 0 | 用0而不是空白符来填充所显示的值 |

* printf格式说明符

| 格式说明符 | 功能 |
| ---------- | ---- |
| %c | 打印单个ASCII 字符 <br> printf("The character is %c\n",x)<br>输出: The character is A |
| %d | 打印一个十进制数<br>printf("The boy is %d years old\n",y)<br>输出：The boy is 15 years old |
| %e | 打印数字的e 记数法形式<br>printf("z is %e\n",z) 打印: z is 2.3e+0 1 |
| %f | 打印一个浮点数<br>printf("z is %f\n", 2.3 * 2)<br>输出: z is 4.600000 |
| %o | 打印数字的八进制<br>printf("y is %o\n",y)<br>输出：z is 17 |
| %s | 打印一个字符串<br>printf("The name of the culprit is %s\n",$1)<br>输出：The name of the culprit is Bob Smith |
| %x | 打印数字的十六进制值<br>printf("y is %x\n",y)<br>输出：x is f |

* printf变量

```
a=1
b=2
echo "$a $b" | awk '{printf "%d\n",$1+$2}'
>3

```
