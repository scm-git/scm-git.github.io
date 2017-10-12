# [王孝东的个人空间](https://scm-git.github.io/)

## 关于hash code的问题
1. Object类中提供了hashCode()方法，因此所有的对象都可以通过该方法获取自己的hash code，并且该方法是一个native方法。
   ```java
   public native int hashCode();
   ```
   网上很多资料说这个返回值是一个内存地址(包括Java的权威书籍：《Java核心技术 卷I 基础知识(原书第10版)》 P170也是这么描述的)，而且由于Java的内存回收机制，会按需移动内存中的对象以腾出内存空间，所有会导致移动之后，内存地址发送变化，从而导致该hashCode()方法(没有被重写)的返回值发生变化
   
2. 