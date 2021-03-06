# [王孝东的个人空间](https://scm-git.github.io/)

## Java synchronized关键字详解
### synchronized 关键字的使用方式：
* 修饰静态方法：使用当前类的类对象作为锁
* 修饰非静态方法：使用调用方法的对象本身作为锁
* 修饰代码块：可以指定任意对象作为锁

### 下面分别介绍三种用法的区别：
* **1.修饰静态方法：** 对静态同步方法的调用使用当前类的**类对象**作为锁，也就是说，在多个线程中同时调用**静态同步**方法(包括不同的静态同步方法)时，在某一个时刻只可能有一个同步方法被执行,但是不影响非同步的静态方法，示例代码：
  ```java
  import static java.lang.System.out;
  
  /**
   * Created by wanxiaod on 10/10/2017.
   */
  public class SynchronizeTest {
  
      public static final Object lock = new Object();
  
      private static final int THREAD_SLEEP_TIME = 2000;
  
      private static void sleepThread(){
          try {
              Thread.sleep(THREAD_SLEEP_TIME);
          } catch (InterruptedException e) {
              e.printStackTrace();
          }
      }
  
      public static synchronized void testA1(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA1() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA1() end...");
      }
  
      public static synchronized void testA2(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA2() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA2() end...");
      }
  
      public static void testA3(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA3() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA3() end...");
      }
  
      public static void main(String[] args){
          out.println(System.currentTimeMillis() + ": main startup thread start...");
          for(int i=0; i<10; i++){
              new Thread(() -> SynchronizeTest.testA1(), "A1").start();
              new Thread(() -> SynchronizeTest.testA2(), "A2").start();
              new Thread(() -> SynchronizeTest.testA3(), "A3").start();
          }
          out.println(System.currentTimeMillis() + ": main startup thread end...");
      }
  }
  ```
  
  执行该代码，输出如下：
  ```
  "C:\Program Files\Java\jdk1.8.0_66\bin\java" "-javaagent:C:\Program Files\JetBrains\IntelliJ IDEA 2017.1.2\lib\idea_rt.jar=43763:C:\Program Files\JetBrains\IntelliJ IDEA 2017.1.2\bin" -Dfile.encoding=UTF-8 -classpath "C:\Program Files\Java\jdk1.8.0_66\jre\lib\charsets.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\deploy.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\access-bridge-64.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\cldrdata.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\dnsns.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\jaccess.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\jfxrt.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\localedata.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\nashorn.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\sunec.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\sunjce_provider.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\sunmscapi.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\sunpkcs11.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\zipfs.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\javaws.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\jce.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\jfr.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\jfxswt.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\jsse.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\management-agent.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\plugin.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\resources.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\rt.jar;C:\home\oschina_repo\myapp\out\production\java-core" SynchronizeTest
  1507648923835: main startup thread start...
  1507648923884:A1: static synchronized method: testA1() start...
  1507648923884:A3: static synchronized method: testA3() start...
  1507648923885:A3: static synchronized method: testA3() start...
  1507648923885:A3: static synchronized method: testA3() start...
  1507648923885:A3: static synchronized method: testA3() start...
  1507648923885:A3: static synchronized method: testA3() start...
  1507648923886:A3: static synchronized method: testA3() start...
  1507648923886:A3: static synchronized method: testA3() start...
  1507648923886:A3: static synchronized method: testA3() start...
  1507648923887:A3: static synchronized method: testA3() start...
  1507648923887: main startup thread end...
  1507648923887:A3: static synchronized method: testA3() start...
  1507648925884:A1: static synchronized method: testA1() end...
  1507648925884:A2: static synchronized method: testA2() start...
  1507648925885:A3: static synchronized method: testA3() end...
  1507648925885:A3: static synchronized method: testA3() end...
  1507648925885:A3: static synchronized method: testA3() end...
  1507648925885:A3: static synchronized method: testA3() end...
  1507648925886:A3: static synchronized method: testA3() end...
  1507648925886:A3: static synchronized method: testA3() end...
  1507648925886:A3: static synchronized method: testA3() end...
  1507648925886:A3: static synchronized method: testA3() end...
  1507648925887:A3: static synchronized method: testA3() end...
  1507648925887:A3: static synchronized method: testA3() end...
  1507648927884:A2: static synchronized method: testA2() end...
  1507648927884:A1: static synchronized method: testA1() start...
  1507648929885:A1: static synchronized method: testA1() end...
  1507648929885:A2: static synchronized method: testA2() start...
  1507648931885:A2: static synchronized method: testA2() end...
  1507648931885:A1: static synchronized method: testA1() start...
  1507648933886:A1: static synchronized method: testA1() end...
  1507648933886:A2: static synchronized method: testA2() start...
  1507648935886:A2: static synchronized method: testA2() end...
  1507648935886:A1: static synchronized method: testA1() start...
  1507648937886:A1: static synchronized method: testA1() end...
  1507648937886:A2: static synchronized method: testA2() start...
  1507648939887:A2: static synchronized method: testA2() end...
  1507648939887:A1: static synchronized method: testA1() start...
  1507648941887:A1: static synchronized method: testA1() end...
  1507648941887:A2: static synchronized method: testA2() start...
  1507648943888:A2: static synchronized method: testA2() end...
  1507648943888:A1: static synchronized method: testA1() start...
  1507648945888:A1: static synchronized method: testA1() end...
  1507648945888:A2: static synchronized method: testA2() start...
  1507648947888:A2: static synchronized method: testA2() end...
  1507648947888:A1: static synchronized method: testA1() start...
  1507648949889:A1: static synchronized method: testA1() end...
  1507648949889:A2: static synchronized method: testA2() start...
  1507648951889:A2: static synchronized method: testA2() end...
  1507648951889:A1: static synchronized method: testA1() start...
  1507648953889:A1: static synchronized method: testA1() end...
  1507648953889:A2: static synchronized method: testA2() start...
  1507648955890:A2: static synchronized method: testA2() end...
  1507648955890:A1: static synchronized method: testA1() start...
  1507648957890:A1: static synchronized method: testA1() end...
  1507648957890:A2: static synchronized method: testA2() start...
  1507648959891:A2: static synchronized method: testA2() end...
  1507648959891:A1: static synchronized method: testA1() start...
  1507648961891:A1: static synchronized method: testA1() end...
  1507648961891:A2: static synchronized method: testA2() start...
  1507648963891:A2: static synchronized method: testA2() end...
  
  Process finished with exit code 0
  ```
  这三个方法中都会将线程sleep 2000毫秒，因此查看千位和万位的数字变化，可以证明：非同步的静态方法(testA3)，不会被阻塞，所有线程几乎同时开始执行(看A3线程的起始时间和结束时间)；而testA1和testA2是同步方法，只能串行执行(所有的A1和A2线程都需要等2秒钟结束后，才能开始下一个)

* **2.修饰非静态方法：** 对非静态同步方法的调用，将使用**该对象本身(this)** 作为锁；也就是说，在多个线程同时调用**该对象**的非静态同步方法时，同一时刻只有一个非静态同步方法执行，但是不影响非同步的方法，示例代码：
  ```java
  import static java.lang.System.out;
  
  /**
   * Created by wanxiaod on 10/10/2017.
   */
  public class SynchronizeTest {
  
      public static final Object lock = new Object();
  
      private static final int THREAD_SLEEP_TIME = 2000;
  
      private static void sleepThread(){
          try {
              Thread.sleep(THREAD_SLEEP_TIME);
          } catch (InterruptedException e) {
              e.printStackTrace();
          }
      }
  
      public synchronized void testB1(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB1() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB1() end...");
      }
  
      public synchronized void testB2(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB2() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB2() end...");
      }
  
      public synchronized void testB3(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB3() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB3() end...");
      }
    
      public static void main(String[] args){
  
          SynchronizeTest st = new SynchronizeTest();     //new一个用于执行方法的对象
  
          out.println(System.currentTimeMillis() + ": main startup thread start...");
          for(int i=0; i<10; i++){
              new Thread(() -> st.testB1(), "B1-" + i).start();
              new Thread(() -> st.testB2(), "B2-" + i).start();
              new Thread(() -> st.testB3(), "B3-" + i).start();
          }
          out.println(System.currentTimeMillis() + ": main startup thread end...");
          
      }
  }
  ```
  
  执行结果如下：
  ```
  "C:\Program Files\Java\jdk1.8.0_66\bin\java" "-javaagent:C:\Program Files\JetBrains\IntelliJ IDEA 2017.1.2\lib\idea_rt.jar=44461:C:\Program Files\JetBrains\IntelliJ IDEA 2017.1.2\bin" -Dfile.encoding=UTF-8 -classpath "C:\Program Files\Java\jdk1.8.0_66\jre\lib\charsets.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\deploy.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\access-bridge-64.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\cldrdata.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\dnsns.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\jaccess.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\jfxrt.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\localedata.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\nashorn.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\sunec.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\sunjce_provider.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\sunmscapi.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\sunpkcs11.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\ext\zipfs.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\javaws.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\jce.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\jfr.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\jfxswt.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\jsse.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\management-agent.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\plugin.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\resources.jar;C:\Program Files\Java\jdk1.8.0_66\jre\lib\rt.jar;C:\home\oschina_repo\myapp\out\production\java-core" SynchronizeTest
  1507651601671: main startup thread start...
  1507651601723:B1-0: common synchronized method: testB1() start...
  1507651601724:B3-0: common synchronized method: testB3() start...
  1507651601725:B3-1: common synchronized method: testB3() start...
  1507651601725:B3-2: common synchronized method: testB3() start...
  1507651601725:B3-3: common synchronized method: testB3() start...
  1507651601726:B3-4: common synchronized method: testB3() start...
  1507651601726:B3-5: common synchronized method: testB3() start...
  1507651601727:B3-6: common synchronized method: testB3() start...
  1507651601727:B3-7: common synchronized method: testB3() start...
  1507651601727:B3-8: common synchronized method: testB3() start...
  1507651601727: main startup thread end...
  1507651601728:B3-9: common synchronized method: testB3() start...
  1507651603724:B1-0: common synchronized method: testB1() end...
  1507651603724:B2-9: common synchronized method: testB2() start...
  1507651603725:B3-0: common synchronized method: testB3() end...
  1507651603726:B3-2: common synchronized method: testB3() end...
  1507651603726:B3-1: common synchronized method: testB3() end...
  1507651603727:B3-5: common synchronized method: testB3() end...
  1507651603727:B3-4: common synchronized method: testB3() end...
  1507651603727:B3-3: common synchronized method: testB3() end...
  1507651603728:B3-8: common synchronized method: testB3() end...
  1507651603728:B3-6: common synchronized method: testB3() end...
  1507651603728:B3-7: common synchronized method: testB3() end...
  1507651603729:B3-9: common synchronized method: testB3() end...
  1507651605724:B2-9: common synchronized method: testB2() end...
  1507651605724:B1-9: common synchronized method: testB1() start...
  1507651607725:B1-9: common synchronized method: testB1() end...
  1507651607725:B2-8: common synchronized method: testB2() start...
  1507651609725:B2-8: common synchronized method: testB2() end...
  1507651609725:B1-8: common synchronized method: testB1() start...
  1507651611725:B1-8: common synchronized method: testB1() end...
  1507651611725:B2-7: common synchronized method: testB2() start...
  1507651613726:B2-7: common synchronized method: testB2() end...
  1507651613726:B1-7: common synchronized method: testB1() start...
  1507651615726:B1-7: common synchronized method: testB1() end...
  1507651615726:B2-6: common synchronized method: testB2() start...
  1507651617727:B2-6: common synchronized method: testB2() end...
  1507651617727:B1-6: common synchronized method: testB1() start...
  1507651619727:B1-6: common synchronized method: testB1() end...
  1507651619727:B2-5: common synchronized method: testB2() start...
  1507651621728:B2-5: common synchronized method: testB2() end...
  1507651621728:B1-5: common synchronized method: testB1() start...
  1507651623728:B1-5: common synchronized method: testB1() end...
  1507651623728:B2-4: common synchronized method: testB2() start...
  1507651625728:B2-4: common synchronized method: testB2() end...
  1507651625728:B1-4: common synchronized method: testB1() start...
  1507651627729:B1-4: common synchronized method: testB1() end...
  1507651627729:B2-3: common synchronized method: testB2() start...
  1507651629729:B2-3: common synchronized method: testB2() end...
  1507651629729:B1-3: common synchronized method: testB1() start...
  1507651631730:B1-3: common synchronized method: testB1() end...
  1507651631730:B2-2: common synchronized method: testB2() start...
  1507651633730:B2-2: common synchronized method: testB2() end...
  1507651633730:B1-2: common synchronized method: testB1() start...
  1507651635730:B1-2: common synchronized method: testB1() end...
  1507651635730:B2-1: common synchronized method: testB2() start...
  1507651637731:B2-1: common synchronized method: testB2() end...
  1507651637731:B1-1: common synchronized method: testB1() start...
  1507651639731:B1-1: common synchronized method: testB1() end...
  1507651639731:B2-0: common synchronized method: testB2() start...
  1507651641732:B2-0: common synchronized method: testB2() end...
  
  Process finished with exit code 0
  ```
  这个示例代码和testA类似，只是相应的去掉了方法上的static，但是有一个特别需要注意的地方：main方法中在**for循环外**创建了一个对象`SynchronizeTest st = new SynchronizeTest();`，这个对象尤其关键，线程中的testB1,B2,B3方法都使用该对象调用，也就是该对象自身会作为同步方法testB1和testB2的锁；如果将这个代码放入for循环内，会出现什么结果呢？
  
  从结果可以看出，testB3方法没有被阻塞，10个线程可以同时执行，而testB1和testB2只能串行执行。
  
  回到前面的问题，如果将`SynchronizeTest st = new SynchronizeTest();`放到for循环内部会出现什么情况呢？答案应该是：10个线程的B3都可以同时执行，另外20个线程中有10个线程可以同时执行testB1或者testB2;等2秒之后，最后10个线程可以同时testB1或者testB2。因为for循环内部会创建10个对象，而同一次循环内部的三个线程共用一个对象，所有只有同一次循环下的线程在调用testB1和testB2时会串行执行。

* **3.修饰代码块：** 修饰代码块时，可以灵活指定需要同步的代码块，并且需要指定一个对象作为锁，这个对象可以是任何对象，因此这是最灵活的一种方式；因为这种方式可以指定任意对象作为锁，所以这种方式完全可以取代前面两种方式；示例代码如下：
  ```java
  import static java.lang.System.out;
  
  /**
   * Created by wanxiaod on 10/10/2017.
   */
  public class SynchronizeTest {
  
      public static final Object lock = new Object();
  
      private static final int THREAD_SLEEP_TIME = 2000;
  
      private static void sleepThread(){
          try {
              Thread.sleep(THREAD_SLEEP_TIME);
          } catch (InterruptedException e) {
              e.printStackTrace();
          }
      }
  
      public static synchronized void testA1(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA1() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA1() end...");
      }
  
      public static synchronized void testA2(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA2() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA2() end...");
      }
  
      public static void testA3(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA3() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testA3() end...");
      }
  
      public synchronized void testB1(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB1() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB1() end...");
      }
  
      public synchronized void testB2(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB2() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB2() end...");
      }
  
      public void testB3(){
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB3() start...");
          sleepThread();
          out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": common synchronized method: testB3() end...");
      }
  
      /**
       * 与testB1()效果完全一样：巧妙的使用当前对象this作为锁
       */
      public void testC1(){
          synchronized (this){
              out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": block synchronized method: testC1() start...");
              sleepThread();
              out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": block synchronized method: testC1() end...");
          }
      }
  
      /**
       * 使用一个另外的对象作为锁
       */
      public void testC2(){
          synchronized (lock){
              out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": block synchronized method: testC2() start...");
              sleepThread();
              out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": block synchronized method: testC2() end...");
          }
      }
  
      /**
       * 与testA1()效果完全一样：巧妙的使用SynchronizeTest.class类对象作为锁
       */
      public static void testC3(){
          synchronized (SynchronizeTest.class) {
              out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testC3() start...");
              sleepThread();
              out.println(System.currentTimeMillis() + ":" + Thread.currentThread().getName() + ": static synchronized method: testC3() end...");
          }
      }
  
      public static void main(String[] args){
      
        // 构造testC的代码
    
      }
  }
  ```
  
  第三个示例构造了等价于前面两种方式的实现，并且可以自己指定代码块以及锁；对于需要实现分布式锁的系统只能使用第三种方式，因为分布式锁只能指定一个跨JVM的全局对象作为锁，因此必须使用这种方式。
  
  **总结：其实三种方式归根结底就是一种方式：只是前面两种方式是第三种方式的两个特殊情况，第一个使用固定的当前类的类对象作为锁，第二个使用当前对象作为锁，并且同步的代码块都是整个方法。**
  
  下次在遇到synchronized的面试题时总算可以轻松应对了 :)
