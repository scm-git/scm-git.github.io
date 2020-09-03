# [王孝东的个人空间](https://scm-git.github.io/)

## 关于hash code的问题
1. Object类中提供了hashCode()方法，因此所有的对象都可以通过该方法获取自己的hash code，并且该方法是一个native方法。
   ```java
   public native int hashCode();
   ```
   * 网上很多资料说这个返回值是一个内存地址(包括Java的权威书籍：《Java核心技术 卷I 基础知识(原书第10版)》 P170也是这么描述的)，而且由于Java的内存回收机制，会按需移动内存中的对象以腾出内存空间，所以对象被移动之后，内存地址会发生变化，从而导致该hashCode()方法(没有被重写)的返回值也会发生变化，如果hashCode()方法被重写了，可以使用System.identityHashCode(obj)方法来获取原生的hash code.[参见Stack Overflow上的文章](https://stackoverflow.com/questions/1961146/memory-address-of-variables-in-java)
   * [Stack Overflow上还有另外一篇文章](https://stackoverflow.com/questions/3796699/will-hashcode-return-a-different-int-due-to-compaction-of-tenure-space)，该文章的说法是：**原始的hash code在对象的整个生命周期是不会改变的**，即使因为GC而被移动过位置，也会保存原来的hash code。而且这边文章对hash code的实现做了粗略的解释，如下：
     
     ```
     给每个对象添加两个标记位，两个标记位的用法如下：
     1. 当调用对象的hashcode的时候会设置第一个标记位；
     2. 第二个标记位用来说明是使用当前地址作为hash code还是使用已存储的值作为hash code;
     3. 当JVM执行GC并且要重新分配内存地址时，JVM会检测这两个标志，如果第一个标志位为set(即调用过hashCode()方法)，而第二个标志位为unset, 
        JVM会分配一个额外的word给对象，用于存储对象的原始地址，并将第二个flag设置为set；
     4. 此后，当调用hashCode()的时候，将返回这个word存储的原始地址。
     ```
     
     General hashCode contract:
     
     ```
     在一个Java应用中，任何时候调用hashCode()，都需要返回相同的值
     ```
     另外需要认识到一点：hash code并不是一个unique ID，它是可能重复的，也就是hash碰撞。想象这样一个场景：当一个对象object1得到了hash code后被GC移动到一个新的内存地址，现在有一个新的对象object2分配到object1原来的位置上了，再调用object2的hashCode()，这个hashCode是根据object1的初始地址得出的，而object1也缓存这个地址得出的hashcode，所以可能会出现object1和object2的hashcode一样的情况

2. 