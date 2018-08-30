# [王孝东的个人空间](https://scm-git.github.io/)
## Shell 脚本常用语法

```shell
# 数字加减用双括号
INDEX=1
INDEX=$((INDEX+1))

#数组
ARR=(”A“ "B") # 定义数组
ARR+="C"  #追加
ARR[3]="D" #赋值
echo "${ARR[@]}" #所有元素
echo "${ARR[*]}" #所有元素
echo "${#ARR[@]}" #素组长度
echo "${ARR[0]}}"   #下标从0开始
#遍历
for ELEMENT in ${ARR[@]}
do
    echo "${ELEMENT}"
done

#字符串处理
# 字符串连接，直接写，不需要任何符号
A1="a1"
A2="${A1}b1"    #a1b1
echo "abcd" | grep "bc” #匹配
echo $?     #能匹配到，输出0，否则输出1; 这个$?一定要紧跟上一条语句，写脚本时经常会出现这个失误
echo "abcd" | grep "ef"
echo $? # 输出1
echo "abc def gh" | cut -f1 -d\ #字符串split，根据空格拆分，详见cut用法
echo "abcd" | sed ’s/a/A/g‘ #字符串替换
echo "${#A1}"   #字符串长度

#文件
```

* [更多字符串处理](http://www.cnblogs.com/chengmo/archive/2010/10/02/1841355.html)
