# [王孝东的个人空间](https://scm-git.github.io/)

## HashMap源码分析
HashMap.java
```java
public class HashMap<K,V> extends AbstractMap<K,V>
    implements Map<K,V>, Cloneable, Serializable {
    
    // HashMap的默认容量：table数组的默认长度
    static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16

    // table的最大容量，该容量表示table数组的长度，并不是装入的元素个数，因为一个位置上可以有多个元素(Node),每个Node的next属性会保存其后面的Node的地址；因此一个索引位置上可能不止一个Node
    static final int MAXIMUM_CAPACITY = 1 << 30;

    // 默认加载因子；如果没有设置加载因子时，使用该值 
    static final float DEFAULT_LOAD_FACTOR = 0.75f;

    /**
     * The bin count threshold for using a tree rather than list for a
     * bin.  Bins are converted to trees when adding an element to a
     * bin with at least this many nodes. The value must be greater
     * than 2 and should be at least 8 to mesh with assumptions in
     * tree removal about conversion back to plain bins upon
     * shrinkage.
     */
    static final int TREEIFY_THRESHOLD = 8;

    /**
     * The bin count threshold for untreeifying a (split) bin during a
     * resize operation. Should be less than TREEIFY_THRESHOLD, and at
     * most 6 to mesh with shrinkage detection under removal.
     */
    static final int UNTREEIFY_THRESHOLD = 6;

    /**
     * The smallest table capacity for which bins may be treeified.
     * (Otherwise the table is resized if too many nodes in a bin.)
     * Should be at least 4 * TREEIFY_THRESHOLD to avoid conflicts
     * between resizing and treeification thresholds.
     */
    static final int MIN_TREEIFY_CAPACITY = 64;
    
    
    /* ---------------- Fields -------------- */
    
    // 存储所有键值对的数组，所有的键值对被包装成Node放入该数组中
    transient Node<K,V>[] table;

    /**
     * Holds cached entrySet(). Note that AbstractMap fields are used
     * for keySet() and values().
     */
    transient Set<Map.Entry<K,V>> entrySet;

    // Key-Value键值对的数量
    transient int size;

    // HashMap的结果修改次数，比如put, remove等方法会每次增加该值
    transient int modCount;

    // 阈值: threshold = capacity * loadFactor; 当元素个数达到阈值时，HashMap调用resize()方法扩容，每次扩容都会将容量扩大为原来的两倍，扩容时会重新对原来的元素进行定位，并将新的索引位置指向原来的元素
    int threshold;

    // 加载因子：用于设置HashMap的扩容阈值threshold; 表示当Node个数达到多满的程度时，会扩容HashMap
    // 影响HashMap的两个因素：初始容量(initialCapacity)和加载因子(loadFactor)。初始容量是构造方法中直接指定，如果你能大概估计到你的HashMap需要存多少数据，可以在new的时候会其指定初始容量，避免扩容操作
    // 默认的加载因子为0.75；这是一个空间和时间的一个好的平衡点。如果加载因子过小：如0.1；这样会导致只有1/10的index被使用时就会扩容，也就是9/10的索引位会留空，这样会浪费空间；但是你的Node(每个key,value会包装成Node存储在able中)就不容易重复出现在某个索引位上
    // 如果加载因子过大：比如设置为10，这样会导致你某个索引位上会出现多个Node，获取Node时就会造成多次比较。比如初始容量为16，加载因子为10； 就会出现160个Node存放在在16个索引位置上，平均每个都有10个Node，get(key)时就会再比较元素的key，而不能直接通过hash值取出元素
    final float loadFactor;
    
    // 使用key的hashCode生成新的hash值，因为hashCode方法可以被任意重写，为了避免有不好的hashCode()实现，所以需要将hashCode重新hash：
    static final int hash(Object key) {
        int h;
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }
    
    /**
     * Associates the specified value with the specified key in this map.
     * If the map previously contained a mapping for the key, the old
     * value is replaced.
     *
     * @param key key with which the specified value is to be associated
     * @param value value to be associated with the specified key
     * @return the previous value associated with <tt>key</tt>, or
     *         <tt>null</tt> if there was no mapping for <tt>key</tt>.
     *         (A <tt>null</tt> return can also indicate that the map
     *         previously associated <tt>null</tt> with <tt>key</tt>.)
     */
    public V put(K key, V value) {
        return putVal(hash(key), key, value, false, true);
    }

    /**
     * Implements Map.put and related methods
     *
     * @param hash hash for key
     * @param key the key
     * @param value the value to put
     * @param onlyIfAbsent if true, don't change existing value
     * @param evict if false, the table is in creation mode.
     * @return previous value, or null if none
     */
    final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
        Node<K,V>[] tab; Node<K,V> p; int n, i;
        
        tab = table;
        n = tab.lenght;
        
        // 1. 首先查看table是否为空(table是存储节点的数组)
        if (tab == null || n == 0){
            n = (tab = resize()).length;
        }
        
        // 通过位与操作获取该hash值对应的index，位与运算保证结果肯定小于(length-1)
        int index = (n-1) & hash;
        p = tab[index];  //取得该索引位置上的第一个节点(数组索引只能取到第一个Node，(如果还有)后续的Node只能通过Node的next属性依次访问)
        
        if (p == null) {    // 如果该位置上的元素为空，则说明之前没有任何元素放入到该位置上，该元素(p)作为该位置上的第一个node
            tab[index] = newNode(hash, key, value, null);
        } else {    // 不为空，说明之前已经有元素存入该索引位置；(即两个元素的hash值与length-1的位与运行得到同一个index值)
            Node<K,V> e; K k;
            // 判断：当前的Key的hash值和之前的取出的相同位置上的第一个节点p的hash值相等，且他们的key也是相同的；如果为true，则表示Key是同一个对象
            if (p.hash == hash && ((k = p.key) == key || (key != null && key.equals(k)))) {     
                e = p;  // Key对象已存在，条件成立；将原来的Node接待赋值给e,后续会对e进行判断。
            } else if (p instanceof TreeNode) {     // 用于TreeMap的元素判断?? TODO
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
            } else {
                // 遍历该索引位置上的Node链表；for循环中没有退出条件，下面的条件满足时会主动break；
                // 遍历只会出现以下两种情况中的一种，即要么已存在一个key与当前key对象相等，此时用新的value替换原来的value；
                // 要么没有任何key与当前key对象相等，则将新的key对象放入该链表的最后一个Node
                for (int binCount = 0; ; ++binCount) {
                    if ((e = p.next) == null) {     // 判断p.next是否为空
                        // 如果为空，说明没有Node需要继续遍历比较；走到此步，说明没有重复的Key被找到。
                        p.next = newNode(hash, key, value, null);
                        if (binCount >= TREEIFY_THRESHOLD - 1) { // -1 for 1st
                            treeifyBin(tab, hash);
                        }
                        break;      // 将新的键值对放到p.next之后直接跳出循环
                    }
                    
                    //　判断p.next的key对象是否为当前的key对象，如果是，直接跳出循环，后面的if会为原来的Node赋予新的value值
                    if (e.hash == hash && ((k = e.key) == key || (key != null && key.equals(k)))) {
                        break;
                    }
                    
                    p = e;  // 执行到此处，说明前面的条件都为false，将e赋值给p(也就是p=p.next)，然后继续执行下一次for循环。
                }
            }
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;    // 将新的value赋值给已存在的Node
                afterNodeAccess(e);     // 用于TreeMap，HashMap得该方法为空实现。
                return oldValue;       // 直接返回原始的value， 不需要执行后面的操作，因为只是替换了value值，结构没变，也不用判断判断是否需要扩容 
            }
        }
        ++modCount; // 执行到次数，说明没有已存在的key对象，需要添加新的键值对到table中，因此需要增加modCount(操作次数)
        if (++size > threshold)     //检查数量是否达到阈值
            resize();       // 扩容
        afterNodeInsertion(evict);      // for TreeMap
        return null;
    }
    
    public V get(Object key) {
        Node<K,V> e;
        return (e = getNode(hash(key), key)) == null ? null : e.value;
    }

    /**
     * Implements Map.get and related methods
     *
     * @param hash hash for key
     * @param key the key
     * @return the node, or null if none
     */
    final Node<K,V> getNode(int hash, Object key) {
        Node<K,V>[] tab; Node<K,V> first, e; int n; K k;
        if ((tab = table) != null && (n = tab.length) > 0 &&
            (first = tab[(n - 1) & hash]) != null) {
            if (first.hash == hash && // always check first node
                ((k = first.key) == key || (key != null && key.equals(k))))
                return first;
            if ((e = first.next) != null) {
                if (first instanceof TreeNode)
                    return ((TreeNode<K,V>)first).getTreeNode(hash, key);
                do {
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        return e;
                } while ((e = e.next) != null);
            }
        }
        return null;
    }
}
```

hashCode和euqals方法对应HashMap来说是非常重要，添加元素时通常都需要使用hashCode和equals方法来判断键值对的index以及是否已存在当前的key对象；hashCode如此重要，可以参加另一篇[关于hashCode的文章](./hashcode.md)

下面是用于测试HashMap中的hash函数以及观察hash分布情况的示例代码：
```java
public class MapTest<K, V> {

    // 该方法和HashMap中的hash方法完全一致；只是HashMap中的hash方法没有公开出来，不能直接调用，所以参照源码写了一个一样的，用于观察每步的执行结果
    public static int hash(Object key){
        int tableLength = 16;
        int h;
        if(key == null ){
            return 0;
        } else {
            // 通过对象的默认hashCode得到HashMap中的hash值，并查看index分布情况
            h = key.hashCode();
            out.println("h = hashCode:         " + String.format("%1$32s",Integer.toBinaryString(h)).replace(' ','0'));
            out.println("h/16 = hashCode>>>16: " + String.format("%1$32s",Integer.toBinaryString(h>>>16)).replace(' ','0'));
            int hash = h ^ (h >>> 16);
            out.println("hash = h ^ h/16:      " + String.format("%1$32s",Integer.toBinaryString(hash)).replace(' ','0'));
            out.println("last=length-1:        " + String.format("%1$32s",Integer.toBinaryString((tableLength-1))).replace(' ','0'));
            out.println("index=last&hash:      " + String.format("%1$32s",Integer.toBinaryString((tableLength-1) & hash)).replace(' ','0'));
            out.println("index=last&hash:      " + ((tableLength-1) & hash));
            out.println("tableLength:          " + tableLength);
            out.println("hash:                 " + hash);
            out.println("key.toString:         " + key.toString());
            
            // 以下是将对象转换为String后，通过String的hashCode得到HashMap中的hash值，再查看index的分布情况
            // 因为String重写了hashCode方法，得到的hashCode并不是默认的hashCode(默认的hashCode为内存地址)
            int stringH = key.toString().hashCode();
            int stringHash = stringH ^ (stringH >>> 16);
            out.println("key.toString.hashCode:        " + String.format("%1$32s",Integer.toBinaryString(stringH)).replace(' ','0'));
            out.println("key.toString.hashCode>>>16:   " + String.format("%1$32s",Integer.toBinaryString(stringH>>>16)).replace(' ','0'));
            out.println("key.toString.stringHash:      " + String.format("%1$32s",Integer.toBinaryString(stringHash)).replace(' ','0'));
            out.println("last=length-1:                " + String.format("%1$32s",Integer.toBinaryString((tableLength-1))).replace(' ','0'));
            out.println("index=last&stringHash:        " + String.format("%1$32s",Integer.toBinaryString((tableLength-1) & stringHash)).replace(' ','0'));
            out.println("index=last&stringHash:        " + ((tableLength-1) & stringHash));
            out.println("key.toString.hashCode:        " + key.toString().hashCode());
            out.println("key.toString.stringHash:      " + stringHash );
            out.println("==========================================================");
            return hash;
        }
        //return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }

    public void testMap(){
        MapTest mapTest1 = new MapTest();
        MapTest mapTest2 = new MapTest();
        MapTest mapTest3 = new MapTest();
        MapTest mapTest4 = new MapTest();
        MapTest mapTest5 = new MapTest();
        MapTest mapTest6 = new MapTest();
        MapTest mapTest7 = new MapTest();
        MapTest mapTest8 = new MapTest();

        out.println("mapTest1.hash:" + hash(mapTest1));
        out.println("mapTest2.hash:" + hash(mapTest2));
        out.println("mapTest3.hash:" + hash(mapTest3));
        out.println("mapTest4.hash:" + hash(mapTest4));
        out.println("mapTest5.hash:" + hash(mapTest5));
        out.println("mapTest6.hash:" + hash(mapTest6));
        out.println("mapTest7.hash:" + hash(mapTest7));
        out.println("mapTest8.hash:" + hash(mapTest8));

        Map<MapTest, Integer> map = new HashMap<>(4,2);
        map.put(mapTest1,1);
        map.put(mapTest2,1);
        map.put(mapTest3,1);
        map.put(mapTest4,1);
        map.put(mapTest5,1);
        map.put(mapTest6,1);
        map.put(mapTest7,1);
        map.put(mapTest8,1);
        
        map.put(mapTest1,1);    // 测试重复的key

        out.println("map.size:" + map.size());
    }

    public static void main(String[] args){
        new MapTest().testMap();
    }
}
```

测试时，修改tableLength的值，以查看index的不同分布情况；我的结果如下：
```
h = hashCode:         00011011011011010011010110000110
h/16 = hashCode>>>16: 00000000000000000001101101101101
hash = h ^ h/16:      00011011011011010010111011101011
last=length-1:        00000000000000000000000000001000
index=last&hash:      00000000000000000000000000001000
index=last&hash:      8
tableLength:          9
hash:                 460140267
key.toString:         MapTest@1b6d3586
key.toString.hashCode:        00101011001110100000011001110001
key.toString.hashCode>>>16:   00000000000000000010101100111010
key.toString.stringHash:      00101011001110100010110101001011
last=length-1:                00000000000000000000000000001000
index=last&stringHash:        00000000000000000000000000001000
index=last&stringHash:        8
key.toString.hashCode:        725223025
key.toString.stringHash:      725232971
==========================================================
mapTest1.hash:460140267
h = hashCode:         01000101010101000110000101111100
h/16 = hashCode>>>16: 00000000000000000100010101010100
hash = h ^ h/16:      01000101010101000010010000101000
last=length-1:        00000000000000000000000000001000
index=last&hash:      00000000000000000000000000001000
index=last&hash:      8
tableLength:          9
hash:                 1163142184
key.toString:         MapTest@4554617c
key.toString.hashCode:        00010010000011010010111111111001
key.toString.hashCode>>>16:   00000000000000000001001000001101
key.toString.stringHash:      00010010000011010011110111110100
last=length-1:                00000000000000000000000000001000
index=last&stringHash:        00000000000000000000000000000000
index=last&stringHash:        0
key.toString.hashCode:        302854137
key.toString.stringHash:      302857716
==========================================================
mapTest2.hash:1163142184
h = hashCode:         01110100101000010100010010000010
h/16 = hashCode>>>16: 00000000000000000111010010100001
hash = h ^ h/16:      01110100101000010011000000100011
last=length-1:        00000000000000000000000000001000
index=last&hash:      00000000000000000000000000000000
index=last&hash:      0
tableLength:          9
hash:                 1956720675
key.toString:         MapTest@74a14482
key.toString.hashCode:        01011111101101001001001010011001
key.toString.hashCode>>>16:   00000000000000000101111110110100
key.toString.stringHash:      01011111101101001100110100101101
last=length-1:                00000000000000000000000000001000
index=last&stringHash:        00000000000000000000000000001000
index=last&stringHash:        8
key.toString.hashCode:        1605669529
key.toString.stringHash:      1605684525
==========================================================
mapTest3.hash:1956720675
h = hashCode:         00010101010000001110000110011101
h/16 = hashCode>>>16: 00000000000000000001010101000000
hash = h ^ h/16:      00010101010000001111010011011101
last=length-1:        00000000000000000000000000001000
index=last&hash:      00000000000000000000000000001000
index=last&hash:      8
tableLength:          9
hash:                 356578525
key.toString:         MapTest@1540e19d
key.toString.hashCode:        11011000100100011101000001101001
key.toString.hashCode>>>16:   00000000000000001101100010010001
key.toString.stringHash:      11011000100100010000100011111000
last=length-1:                00000000000000000000000000001000
index=last&stringHash:        00000000000000000000000000001000
index=last&stringHash:        8
key.toString.hashCode:        -661532567
key.toString.stringHash:      -661583624
==========================================================
mapTest4.hash:356578525
h = hashCode:         01100111011100110010011110110110
h/16 = hashCode>>>16: 00000000000000000110011101110011
hash = h ^ h/16:      01100111011100110100000011000101
last=length-1:        00000000000000000000000000001000
index=last&hash:      00000000000000000000000000000000
index=last&hash:      0
tableLength:          9
hash:                 1735606469
key.toString:         MapTest@677327b6
key.toString.hashCode:        01001110111101011110010000001000
key.toString.hashCode>>>16:   00000000000000000100111011110101
key.toString.stringHash:      01001110111101011010101011111101
last=length-1:                00000000000000000000000000001000
index=last&stringHash:        00000000000000000000000000001000
index=last&stringHash:        8
key.toString.hashCode:        1324737544
key.toString.stringHash:      1324722941
==========================================================
mapTest5.hash:1735606469
h = hashCode:         00000001010010101110010110100101
h/16 = hashCode>>>16: 00000000000000000000000101001010
hash = h ^ h/16:      00000001010010101110010011101111
last=length-1:        00000000000000000000000000001000
index=last&hash:      00000000000000000000000000001000
index=last&hash:      8
tableLength:          9
hash:                 21685487
key.toString:         MapTest@14ae5a5
key.toString.hashCode:        10011100011111100100110110110000
key.toString.hashCode>>>16:   00000000000000001001110001111110
key.toString.stringHash:      10011100011111101101000111001110
last=length-1:                00000000000000000000000000001000
index=last&stringHash:        00000000000000000000000000001000
index=last&stringHash:        8
key.toString.hashCode:        -1669444176
key.toString.stringHash:      -1669410354
==========================================================
mapTest6.hash:21685487
h = hashCode:         01111111001100010010010001011010
h/16 = hashCode>>>16: 00000000000000000111111100110001
hash = h ^ h/16:      01111111001100010101101101101011
last=length-1:        00000000000000000000000000001000
index=last&hash:      00000000000000000000000000001000
index=last&hash:      8
tableLength:          9
hash:                 2133941099
key.toString:         MapTest@7f31245a
key.toString.hashCode:        01100110001011000100111111001101
key.toString.hashCode>>>16:   00000000000000000110011000101100
key.toString.stringHash:      01100110001011000010100111100001
last=length-1:                00000000000000000000000000001000
index=last&stringHash:        00000000000000000000000000000000
index=last&stringHash:        0
key.toString.hashCode:        1714180045
key.toString.stringHash:      1714170337
==========================================================
mapTest7.hash:2133941099
h = hashCode:         01101101011011110110111000101000
h/16 = hashCode>>>16: 00000000000000000110110101101111
hash = h ^ h/16:      01101101011011110000001101000111
last=length-1:        00000000000000000000000000001000
index=last&hash:      00000000000000000000000000000000
index=last&hash:      0
tableLength:          9
hash:                 1835991879
key.toString:         MapTest@6d6f6e28
key.toString.hashCode:        10011100100010101001110011100101
key.toString.hashCode>>>16:   00000000000000001001110010001010
key.toString.stringHash:      10011100100010100000000001101111
last=length-1:                00000000000000000000000000001000
index=last&stringHash:        00000000000000000000000000001000
index=last&stringHash:        8
key.toString.hashCode:        -1668637467
key.toString.stringHash:      -1668677521
==========================================================
mapTest8.hash:1835991879
map.size:8

Process finished with exit code 0
```