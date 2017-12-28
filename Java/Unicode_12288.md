# [王孝东的个人空间](https://scm-git.github.io/)
## Java unicode为12288字符

今天做java字符串处理的时候发现，根据空格split字符串，但是串中的空格却没有被拆分，debug的时候发现这个空格的unicode为12288，网上查了一下，12288的字符为全角的空格字符，因此做split的时候没有被处理
解决办法如下：
```java
// 将全角的空格字符替换为正常的空格字符
str = str.replace((char) 12288,' ');
```

