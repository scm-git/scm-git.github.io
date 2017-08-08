# [王孝东的个人空间](https://scm-git.github.io/)
### TreeSet排序总结
TreeSet排序常用的两种方式：
1. 通过`TreeSet(Comparator<? super E> comparator)`构造方法指定TreeSet的比较器进行排序
2. 使用TreeSet()构造方法，并对需要添加到set集合中的元素实现Comparable接口进行排序

---
下面通过示例代码详细介绍这两种方法：
### 1. 通过TreeSet(Comparator<? super E> comparator) 构造方法指定TreeSet的比较器进行排序  
* (1). 构造装入TreeSet的Java bean

```java
package src

public class Foo {
    private int num;

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public String toString() {
        return "foo:" + this.getNum() + ",";
    }
}
```
* (2). 自己实现比较器

```java
package src

import java.util.Comparator;

public class MyComparator implements Comparator<Foo> {
    public int compare(Foo f1, Foo f2) {
        if (f1.getNum() > f2.getNum()) {
            return 1;
        } else if (f1.getNum() == f2.getNum()) {
            return 0;
        } else {
            return -1;
        }
    }
}
```

* (3). new TreeSet时指定比较器

```java
TreeSet<Foo> set = new TreeSet(new MyComparator());
```
这样在set.add()元素时就会根据自己定义比较器进行排序了

#### 2. 使用TreeSet()构造方法，并对需要添加到set集合中的元素实现Comparable接口进行排序
这种方法不需要自己写一个比较器，需要对装入set集合中的元素实现Comparable接口，TreeSet集合就根据bean的自然顺序进行排序
* (1). 构造bean，需要实现Comparable接口，并重写compareTo()方法，compareTo方法中定义排序的方式

```
public class Foo implements Comparable {
    private int num;

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public String toString() {
        return "foo:" + this.getNum() + ",";
    }

    public int compareTo(Object obj) {
        if (obj instanceof Foo) {
            Foo foo = (Foo) obj;
            if (this.num > foo.getNum()) {
                return 1;
            } else if (this.num == foo.getNum()) {
                return 0;
            } else {
                return -1;
            }

        }
        return 0;
    }
}
```

* (2). 创建TreeSet时直接使用构造TreeSet()方法

```
TreeSet<Foo> set = new TreeSet(); 
```
不需要指定比较器，这样在执行set.add()方法时，set集合就自动根据bean中compareTo()方法指定的方式进行排序。

两种方法任选其一都能达到目的
