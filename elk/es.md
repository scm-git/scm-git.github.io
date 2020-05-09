# [王孝东的个人空间](https://scm-git.github.io/)

## Elastic Search
### 搜索引擎
* 是一个检索服务，主要分全文检索和垂直检索

### Elastic Search
* 是一个分布式的索引库
* 可以对外提供检索服务， http或者transport(7.0已经废弃)协议两种方式对外提供搜索。http就是一个基于json格式的RESTful接口
* 对内就是一个NoSQL数据库，NoSQL
* 底层基于lucene

### ES名称定义：
* 索引：官方说明就是索引，类似于数据库的概念； 一个es中可以创建多个索引；类似mysql的多个库
* 类型(type): 类似于数据库的表， es6.x只有一个type，之前的可以建很多，es7.x就没有这个type了
* 文档(document)：类似于关系型数据库的行
* field：字段
* type的缺点： es是非关系型数据库，没有办法做连接查询，也就是没有办法跨索引查询

### 搜索引擎基础
* 分词： 分词可以说是搜索引擎的基石，分词的好坏直接影响搜索引擎的效果
* NLP：自然语言处理， 回看 数据结构与算法 课程
* 搜索是以词作为最小单元，依靠分词器进行构建，最后会生成一个倒排索引。
* 倒排索引： 
  * value -> docId: 这就是倒排索引; docId常常存在其他存储引擎，比如MySQL, HBase等到
  * 一个value对应很多key，就是一个倒向的HashMap;
  * value是不唯一的，key是唯一，通过不唯一的value来找到一个或多个唯一的key，这就是倒排的意义所在
* 正向索引： HashMap的key -> value结构就是正向索引; 比如有10篇文档，编号依次为1，2，3... 那么：
  * 1 -> doc
  * 2 -> doc
  * 这种key对应一篇文档的形式就是我们所说的正向索引

### TF-IDF
* TF: 词频 一篇doc中包含了多少这个词，包含越多表明越相关 
* DF: 文档频率，包含这个词的文档总算：一个词被多少文档引用，如果一个词配越多的文档引用，那么这个词跟文档的相关度越低，比如每篇文章都有中国人这个词，那么这个词对于每篇文章来说都是一个中性程度的词，无法从这个词区分出所有文档的关联排名
* IDF：DF取反，逆文档频率；也就是1/DF； 如果包含该词的文档越少，也就是DF越小，则IDF越大，则说明该词对这篇文档的重要性就越大。 
* TFIDF： TF * IDF； 主要思想是：如果某个词或短语在一篇文章中出现的频率TF高，并且在其他文章中很少出现(IDF高)，则认为该词或者短语对这篇文件具有很高的类别区分能力；越高的文章就说明区分能力就越强，就排在前面
* ES： 打分排序： BM25算法 tfNom
* TF和DF在分词的时候就已经有了

### ES 环境部署
1. 服务器准备：centos7.4系统:`cat /etc/redhat-release`，JDK 1.8，ES 6.x；如果有自带的openjdk，需要先卸载`rpm -qa | grep java; rpm -e --nodeps *`
2. es安装：
   * 设置内核参数： `/etc/sysctl.conf`：
     ```
     #追加如下两行：
     fs.file-max=65535
     vm.max_map_count=262144
     ``` 
   * 添加之后执行 `sysctl -p`刷新配置文件，`sysctl -a`查看是否生效；如果不成功的，执行如下命令(centos 7.6可能碰到)
     ```
     rm -f /sbin/modprobe
     ln -s /bin/true /sbin/modprobe
     rm -f /sbin/sysctl
     ln -s /bin/true /sbin/sysctl
     ```
   * 设置资源参数：
     ```
     vi /etc/security/limits.conf
     #添加如下内容：* 表示对linux系统的所有用户生效
     * soft nofile 65535
     * hard nofile 131072
     * soft nproc 2048
     * hard nproc 4096
     ```

    * 修改进程数
      ```
      vi /etc/security/limits.d/20-nproc.conf
      #添加如下一行
      * soft nproc 4096
      ```

3. 配置完成后，需要关掉ssh窗口，然后重新打开一个 (7.6好像没有这个问题了)
4. 自己添加一个Linux用户，不能用root用户启动
5. 修改es配置文件： $ES_HOME/config/elasticsearch.yml
   ```
   cluster.name: my-es
   # 名称，最好用末段IP标识节点
   node.name: node-33
   network.host: 0.0.0.0
   # API端口，默认是9200
   http.port: 9200
   # 数据传输端口
   transport.tcp.port: 9300
   # 其他参数保持默认即可，启动后ES会在$ES_HOME目录下生成data和log两个目录
   ```
6. 修改jvm.options文件，主要修改内存大小，根据自己机器来设置 
7. 启动： `./bin/elasticsearch -d`; -d：表示后台运行
8. 查看日志：my-es.log； my-es是配置的集群名称

### ES集群搭建
1. 复制一份ES目录，然后修改config/elasticsearch.yml文件
   ```
   # 集群名字保持一致：
   cluster.name: my-es
   # 这个配置，两个节点都配置一样的，相互发现
   discovery.zen.ping.unicast.hosts: ["127.0.0.1:9300","127.0.0.1:9301"]
   # 然后其他端口各自修改，
   http.port: 9201
   # 数据传输端口
   transport.tcp.port: 9301
   # 节点名字也各自改一个
   node.name: node-33-1
   ```
2. **删除data目录下的所有内容**，否则集群启动会失败

### kibana
1. 下载解压，版本和es的版本保持一致
2. 配置：config/kibana.yml
   ```
   # 端口
   server.port: 15601
   # 对外网访问
   server.host: "0.0.0.0"
   # es的地址
   elasticsearch.hosts: ["http://localhost:9200"]
   ```
3. 启动kibana:  `nohup ./bin/kinaba &`

### 分布式索引介绍
1. number_of_shards: 分片数量， 类似于数据库里面的分库分表，一经定义不可更改。主要响应写操作
2. number_of_replicas: 副本数， 用于备份分片的，和分片里面的数据保持一致，主要响应读操作，副本越多读取越快；可以调整
3. 分布式索引一定要注意分片数量不能更改，所以在创建的时候一定要预先估计好数据大小，一般在8CPU16G的机器上，一个分片不要超过500G。索引会根据分片的配置来均匀的响应用户请求
4. 如果调整了分片那就要重建索引； 因为通过ID%number_of_shards来分片存储，所以分片数改了，就可能取不到了

### Dev Tools
1. 创建索引: 不带参数，默认为每个索引创建5个分片，2个副本，且副本不会在同一个节点上
   ```
   PUT /index1
   {

   }

   ## 指定分片数和副本数
   PUT /index2 
   {
     "number_of_shards": 1,
     "number_of_replicas": 1    
   }

   ## 如果副本数大于节点数据，会给出yellow警告，一个节点下不会存储相同的副本
   PUT /index2/_settings
   {
    "number_of_replicas": 2
   }

   ## 以下操作会报错，shards不允许修改，因为会导致index失效
   PUT /index2/_settings
   {
    "number_of_shards": 3
   }

   ## 删除索引index1
   DELETE /index1 
   {

   }
   
   ## 不指定mapping创建doc数据， _doc就是type，可以任意指定（7.0已废弃type）
   ## _doc/1如果不存在就创建，已存在就更新
   PUT /index2/_doc/1
   {
    "name": "wangxiaodong",
    "age": 30
   }

   ## 查询索引
   GET /index2/_search

   ## 修改文档数据: 这个全量修改，比如下面的age属性没有传值，则结果中就没有age属性了
   ## 每次更新，version都会+1
   PUT /index2/_doc/1
   {
    "name": "wangxiaodong2"
   }

   ## 只修改输入中有的字段，如果没有传的字段就不会修改，也不会删除 
   POST /index2/_doc/1/_update
   {
     "doc": {
       "name": "wangxiaodong3"
     }
   }

   ## 这种方式也可以创建
   ## 多次执行会报错，因为这个指定了是create，不能创建相同ID的doc；
   POST /index2/_doc/3/_create
   {
     "name": "xiaodong",
     "age": 31
   }
  
   ## 删除doc数据
   ## 会删除所有分片的数据
   DELETE /index2/_doc/1

   ## 结构化创建索引
   PUT /test1
   {
    "settings": {

    }
    "mapptings": {
      "_my_doc": {
        "properties": {
          "name": {"type": "text"},
          "age": {"type": "integer"}
        }
      }
    }
   }

   PUT /test1/_my_doc/1
   {
    "name": "wangxiaodong",
    "age": 30
   }

   # 下面这个创建就会失败，因为age已经定义为integer类型，所以20ss会失败
   PUT /test1/_my_doc/2
   {
    "name": "wangxiaodong2",
    "age": "20ss"
   }

   # 下面这个多加了一个gender字段(与定义的结构化索引相比)，也是可以创建成功的
   PUT /test1/_my_doc/2
   {
    "name": "wangxiaodong2",
    "age": "20"
    "gender": "男"
   }
   ```
2. 所有的写请求都会转到master节点，由master节点对doc进行hash取模，根据取模结果来路由到具体的分片中写入；只要把主分片写完就完成了，副本再异步同步master；所以ES并不是实时的，刚写如的索引可能不能马上读取到
3. 读请求可以在任何节点处理，不需要在master节点处理
4. ES的分页全部在内存中完成，所以分片不要太多，ES需要去每个分片中读取数据，然后放到内存中排序
5. es字段的基础数据类型：
   * Text: 字符串类型，可以被分析；
   * Keyword: 不能被分析，只可以精确匹配的字符串类型
   * Date: 日期类型，通常配合format使用，比如{"type": "date", "format": "yyyy-MM-dd"}; 不指定format会出问题
   * long, integer, short
   * boolean
   * array: 数组类型，用得比较少，查询性能可能会有问题
   * object: 一般就是json
   * ip: ip地址
   * geo_point: 地理位置(经纬度): {"lat": "xx", "lon": "yy"}

### ES查询
1. 主键查询:
   ```
   GET /test/_my_doc/1
   ```
2. 查询all:
   ```
   GET /test/_search
   {
     "query": {
       "match_all": {}
     }
   }
   ```
3. 分页查询：
   ```
   # 从0开始，查询1条，类似mysql的 limit 0,1
   # ES有个致命的问题，不能查询太多的分页，因为分页是在内存中完成的；查询太多会导致内存爆炸
   GET /test/_search
   {
     "query": {
       "match_all": {}
     },
     "from": 0,
     "size": 1
   }
   ```
4. 带条件查询
   ```
   GET /test/_search
   {
     "query": {
       "match": {
         "name": "中国"
       }
     }
   }
   ```
5. 带排序
   ```
   GET /test/_search
   {
     "query": {
       "match": {
         "name": "中国"
       }
     },
     "sort": [
       {
         "age": {
           "order": "desc"
         }
       }
     ]
   }
   ```
6. 聚合查询: `aggs`,`sum`,`avg`,`stat`,`min`,`max`等
   ```
    GET /test/_search
    {
      "query": {
        "match": {
          "name": "中国"
        }
      },
      "sort": [
        {
          "age": {
            "order": "desc"
          }
        }
      ],
      "aggs": {
        "group_by_age": {
          "terms": {
            "field": "age"
          }
        }
      }
    }
   ```

7. 其他API
8. analyze
   * **标准分词器**：`standard`，中文把每个字分开，英文按空格分开
     ```
     # ES的默认分词器 standard，把每个字都分开
     GET /test/_analyze
     {
      "field": "name"
      "text": "中国"
     }
     ```
   * **英文分词器**： `english`, 做了一个标准化，英文会提取词干，如：eating -> eat, eated -> eat, running -> run， apples -> appl
     ```
     GET /test/_analyze
     {
      "field": "enname",
      "text": "my name is xiaodong, and I like eating meat and jogging"
     }

     GET /test/_search
     {
      "query": {
        "match": {
          "enname": "eating"
        }
      }
     }
     ```
   * **中文分词器**， ik分词器；从github下载，可以自己添加词语到词库中：`main.dic`; ik装完后需要重启
     ```
     # ik_max_word: 
     # ik_smart: 贪心算法，尽可能分出最长的词
     # 建立索引用ik_max_word, 查询用ik_smart
     PUT /test1
     {
      "settings": {
        "number_of_shards": 1,
        "number_of_replicas": 1
      }
      "mapptings": {
        "_my_doc": {
          "properties": {
            "name": {"type": "text", "analyzer": "ik_max_word"， "search_analyzer": "ik_smart"},
            "sname": {"type": "text", "analyzer": "ik_smart"},
            "enname": {"type": "text", "analyzer": "english"}
            "age": {"type": "integer"}
          }
        }
      }
     }

     GET /test1/_analyze
     {
      "field": "name",
      "text": "武汉市长江大桥"
     }
     GET /test1/_analyze
     {
      "field": "sname",
      "text": "武汉市长江大桥"
     }

     # 查看执行计划
     GET /test1/_validate/query?explain
     {
       "query": {
         "match": {
            "bookName": "通话故事大全"
         }
       }
     }
     ```
   * **建立索引用ik_max_word, 查询用ik_smart**
   * stander分词器的作用：**托底**，在建了IK的字段，再建一个一样的stander的字段。如果IK搜不到就可以搜一个stander分词的，这样保证会有结果，但是慎用，因为占空间，有些特殊的系统可以用。
   * ik还有一个解决办法，叫砍词，比如江大桥，砍掉江就可以搜到结果了
   * 砍词策略可以自定义
   * 既有英文又有中文的，直接选ik

### ES进阶
1. 建立mapping， 原则：
   * 不要使用ES默认的mapping，虽然省事但是不合理
   * 字段类型尽可能精简，只要我们建了索引的字段，ES都会建立倒排，检索时会加载到内存，如果不合理会导致内存爆炸
   * 有些不要检索的字段不要设置`index:true`, es默认为true，更推荐使用es+mysql(or hbase)等形式，将不需要es存储的字段放在其他存储介质中，通过唯一标识和es建立映射
   * IK分词在建立的时候需要注意： 建立索引采用ik_max_word, 检索采用ik_smart
2. 根据数据表创建mapping, 将不检索的字段设置为`index:false`(_my_doc.propeties中设置)
3. 将mysql的数据导入es
   * 通过logstash - mysql
   * 通过canal导入
   * 自己写Java程序来导入 -- 推荐使用这种方式，可以根据自己的需求做到更精准的定制
   * es search-platform代码 TODO
   * 批量添加到ES，
4. ES进阶查询：
   * Match查询: 可以指定operator，默认使用的是:or
   * Term查询: 术语查询，不对查询字段进行分词，必须索引中包含全量词才能查出；使用场景？
   * 匹配度查询: `"minimum_should_match"：2`: 表示结果至少匹配多少个词
     ```
     # 指文档至少匹配两个词
     # explain: true，表示查看score是如何得出的
     GET /test1/_search
     {
      "explain": true,
      "query": {
        "match": {
          "bookName": "故事大全",
          "operator": "or",
          "minimum_should_match": 2
        }
      }
     }
     ```
   * score: 相关度，根据这个值来排序； TF-IDF， tfNom
     ```
     GET /test1/_search
     {
      "explain": true,
      "query": {
        "match": {
          "bookName": "故事大全"
        }
      }
     }
     ```
   * 多字段匹配查询：
     * 对要检索的多个字段加起来建一个大的字段，查询时就只查询这一个字段就可以了；在轻量级的系统可以这样做；不是全文检索时可用
     * 多字段查询
       ```
       # 这个score会取字段中最大者来排序，es会对每个字段分别打分，然后取大者
       # 这个其实是有一个默认的"type"："best_field": 表示取大的字段来排序，丢弃其他小的字段，这种方式用得最少
       # 还有"type": "most_fields"； 表示取各个字段的总和来排序；适合对每个字段都同等查询时使用
       # "type": "cross_field"；表示对搜索的短语进行分词，然后对每个词取最大值相加，得到的score来排序；这种方式特别适合以词为中心的检索
       GET /test/_search
       {
        "explain": true,
        "query": {
          "multi_match": {
            "query": "大自然的旅行故事",
            "fields": ["bookName", "description"],
            "type": "best_field"
          }
        }
       }
       ```
     * 对不同的字段加权：`^10`, 比如 bookName的关键字匹配更能说明相关度，则将bookName的权重加大
       ```
       GET /test/_search
       {
        "query": {
          "multi_match": {
            "query": "大自然的旅行故事",
            "fields": ["bookName^10", "description"]
          }
        }
       }
       ```
     * `"tie_breaker": 0.3`: 表示字段的最大值score+其他字段的score*0.3得出的最终score来排序，其意义在于，不仅考虑最大值字段，也要兼顾其他字段，这样得出的综合score来排序
       ```
       # 比如：bookName算出了score为10分，description为9分，那么这个最终得分为10+9*0.3=12.7
       GET /test/_search
       {
        "query": {
          "multi_match": {
            "query": "大自然的旅行故事",
            "fields": ["bookName", "description"],
            "tie_breaker": 0.3
          }
        }
       }
       ```
   * `query_string`查询:
     ```
     # 查询bookName中同时包含大自然和旅行两个词的doc， 注意AND要用大写；默认是OR
     # 非常适合自定义手动分词的场景
     GET /test/_search
     {
      "query": {
        "query_string": {
          "default_field": "bookName",
          "query": "大自然 AND 旅行"
        }
      }
     }
     ```
   * bool查询: `should` -- 或, `must` -- 与, `must_not` -- 都不包括
     ```
     # 下面的should也可以是must, must_not
     # should表示bookName中包含有安徒生 或者 description中包含丑小鸭
     # must表示两者都必须包含
     # must_not表示两周都不包含，就是must取反
     GET /test/_search
     {
      "query": {
        "bool": {
          "should": [
            {
              "match": {
                "bookName": "安徒生"
              }
            },
            {
              "match": {
                "description": "丑小鸭"
              }
            }
          ]
        }
      }
     }
     ```
   * filter查询：过滤查询
     ```
     # 表示查询评论数为10到200的范围查询
     # 这个查询不会给匹配的doc打分
     GET /test/_search
     {
      "query": {
        "bool": {
          "filter": {
            "range": {
              "commentNum": {
                "gte": 10,
                "lte": 200
              }
            }
          }
        }
      }
     }

     # 下面这个查询会首先对should中的结果进行打分排序，然后再过滤filter
     # 所以需要打分又要过滤就可以在bool查询中来组合使用
     # 此处有一个坑： 如果用的是bool查询的should，那么即使should条件没有匹配到doc，也会执行filter来查询出doc，所以需要该为must
     GET /test/_search
     {
      "query": {
        "bool": {
          "should": [
            {
              "match": {
                "bookName": "安徒生"
              }
            },
            {
              "match": {
                "description": "丑小鸭"
              }
            }
          ],
          "filter": {
            "range": {
              "commentNum": {
                "gte": 10,
                "lte": 200
              }
            }
          }
        }
      }
     }
     ```
   * 自己指定打分函数
     ```
     GET /test/_search
     {
      "explain": true,
      "query": {
        "function_score":  {
          "query":  {
            "multi_match": {
              "query":  "大自然的旅行故事",
              "fields": ["bookName","description"],
              "operator": "or",
              "type": "most_fields"
            }
          }
        },
        "functions": [
          {
            "field_value_factor": {
              "field": "commentNum",
              "modifier": "log2p",
              "factor": 9
            }
          }
        ],
        "score_mode": "sum",
        "boost_mode": "sum"
      }
     }
     ```
5. 同义词
   * 在ES服务器上新加同义词文件
   * 在构建索引的时候设置同义词type
   * 指定mapping的分析器为同义词
   ```
   # analysis-ik/synonyms.txt这个是同义词库的路径配置，相对于config目录
   PUT /test2
   {
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 1,
      "analysis": {
        "filter": {
          "my_synonym_filter": {
            "type": "synonym",
            "synonyms_path": "analysis-ik/synonyms.txt"
          }
        }
      }
    },
    "analyzer": {
      "ik_smart_synonym": {
        "type": "custom",
        "tokenizer": "ik_smart",
        "filter": ["my_synonym_filter"]
      },
      "ik_max_word_synonym": {
        "type": "custom",
        "tokenizer": "ik_max_word",
        "filter": ["my_synonym_filter"]
      }
    },
    "mapping": {
      "_doc": {
        "properties":  {
          "name": {
            "type": "text",
            "analyzer": "ik_max_word_synonym",
            "search_analyzer": "ik_smart_synonym"
          }
        }
      }
    }
   }
   ```
   * 添加了同义词之后，需要重建索引才能生效，并且需要在集群的各个节点上都添加同义词配置
6. 添加词库，注意事项
   * 添加了新的词语到词库，需要重启es，重启时可以滚动重启节点，保持es可用
   * 添加了新词之后，需要重建索引才能生效，所以创建索引时，要考虑拆分，不要全部数据放到一个index上，这样会导致重建时间过长，而且重建时完全不可用
   * 可以通过定时任务来重建或者更新索引；可以考虑增量更新索引，比如通过ID来判断
   * 可以创建两个索引库来备份；重建索引时，可以考虑先使用备份的索引
7. 远程词库
8. Java连接ES的3种方式:
   * Node接入：很少用；基本思想是：把Java工程伪装成一个es的node
   * Transport接入; 7.0废弃; 使用9300端口来做数据传输
   * http接入rest client：主流方式；maven引入Java包时要注意包的版本与es服务器的版本保持一致

### 索引更新机制
1. 索引构建
   * 全量构建：从头全部重新建一边
   * 增量构建：只建或者修改更新的数据
2. 全量构建：如果是文本类的全文检索，因为其数据量庞大不会轻易的全量更新索引，一般以月为单位重建索引。如果是电商类更新较为频繁又要求实时性的系统，一般以天为单位进行重建索引
3. 什么情况下要重建索引：
   * shard数更改，
   * 第一次建数据
   * 增减ES字段
   * 分词词库变更：倒排索引创建时就会使用这些分词，因此修改后就需要重建
   * 时间久了，增量更新可能会丢数据，通常就要重建一遍索引；
4. 一般建两个相同的索引，交替更新，备用的更新，更新完成之后提供使用，然后下次更新另一个
5. **增量构建**: 
   * 准实时性：数据变更后，ES也需要马上变更，否则就会影响用户体验；
   * 性能要求：构建要快
   * 高可用&实现简单
6. 增量构建的常用方案：
   * 单系统中：一般比较简单，插入或者更新数据(mysql/mongodb)时直接更新ES数据(在代码中同时调用ES更新方法)
   * 分布式系统：
     * 使用消息中间件，有更新时将新的数据放入中间件，ES监听MQ，这样可以降低代码耦合度；但是有另一个问题：通常业务系统以及开发完成了，搜索系统是后面才加入的，这样就会导致业务系统修改代码(因为要向MQ发送消息)，这个成本可能也很大；而且每上一个系统，ES就会去对接一次，代价很大
     * 通过数据库层面的更新： 两种方式：1. 通过SQL查询语句定时扫描数据库(updatetime，只适合第一次的全量索引构建)，此种方式不灵活，很慢把握更新的时间间隔。所以有了第二种方式：阿里开源的`canal`中间件

### 阿里Canal
* 消息变动： 数据库的变动
* 源为mysql数据库，oracle只支持部分
* 同步到es或者其他地方

### Canal集成步骤
1. 下载Canal
2. 开启mysql的binlog: mysql的版本不啊哟低于5.6
   * 查看是否开启binlog:
     ```
      show variables like '%bin_log%';
     ```
   * 如果没有开启，则按如下步骤开启，打开`/etc/mysql/my.cnf`或者`my.ini`，配置完成后重启mysql
     ```
     server_id=1
     binlog_format=ROW
     long_bin=mysql_bin.log
     # 下面两个参数可选
     expire-logs-days=14
     max-binlog-size=500m
     ```
3. 为canal配置一个mysql帐号，需要设置repliaction权限
   ```
   create user canal identified by 'canal';
   # 下面这句可能会报权限错误，所以可能需要修改root帐号权限
   grant select, replication slave, replication client on *.* to 'canal'@'%';
   grant all privileges on *.* to 'canal'@'%';
   flush privileges;
   ```
4. 集成canal
   * canal集群需要依赖zookeeper，配置时注意修改`conf/canal.properties`中的`canal.id`；如果是单机部署，则可以不用修改配置项，直接使用默认配置即可;
   * 解压后得到canal主目录，复制其中的example目录，然后修改其中的`instance.properties`文件：
     ```
     # 修改slave id，canal就是伪装成mysql的一个slave来同步binlog的
     canal.instance.mysql.slave=11
     # 目标数据库地址
     canal.instance.master.address=192.168.1.101:3306
     # 用户名密码
     canal.instance.dbUsername=canal
     canal.instance.dbPassword=canal
     ```
   * 启动canal
     ```
     bin/startup.sh
     ```
   * canal集群其实就是一个备份，当工作的节点挂了，另一个才会启用，并不能同时提供服务
   * 重要代码：
     ```
     CanalConnector canalConnector = CanalConnectors.newClusterConnector(Lists.newArrayList(
        new InetSocketAddress("192.168.1.101",11111)), "book","canal","canal");
     canalConnector.connect();
     // 表示监听该库中所有的库和表，
     // 如果要监听的表很多，那么就多初始化几个canalConnector，使用多线程，分别负责其中几个表
     canalConnector.subscribe("*.*"); 
     // 表示只监听mydb库
     // canalConnector.subscribe("mydb.*");
     // 回滚寻找上次中断的位置
     canalConnector.rollback();

     ```
