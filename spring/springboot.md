# [王孝东的个人空间](https://scm-git.github.io/)
## Spring [官网](http://spring.io)

### Spring Boot 中Yaml复杂配置
* 1.配置Map, 配置文件如下：
  ```yaml
  foxcloud:
    aws:
      imageRegionMap:
        us-east-1:
          - "ami-8c1be5f6"
          - "ami-c998b6b2"
          - "ami-abe98kde"
        us-east-2:
          - "ami-c5062ba0"
          - "ami-cfdafaaa"
          - "ami-1e785a7b"
        us-west-1:
          - "ami-02eada62"
          - "ami-66eec506"
          - "ami-12586f72"
  ```
  配置类如下：
  ```java
  @Component
  @ConfigurationProperties(prefix = "foxcloud.aws", ignoreInvalidFields = true)
  @Data
  public class AwsImageConfigure {
      private Map<String, List<String>> imageRegionMap;
  }
  ```
  这样就可以根据key(如us-east-1)获取对应的List

* 2.配置对象列表，配置文件如下：
  ```yaml
  foxcloud:
    aws:
      regions:
        -
          regionName: "ap-northeast-1"
          displayName: "亚太区域(东京)"
        -
          regionName: "ap-northeast-2"
          displayName: "亚太区域(首尔)"
        -
          regionName: "ap-south-1"
          displayName: "亚太区域(孟买)"
  ```
  配置类AwsRegionConfigure如下：
  ```java
  @Component
  @ConfigurationProperties(prefix = "foxcloud.aws", ignoreInvalidFields = true)
  @Data
  public class AwsRegionConfigure {
      private List<AwsRegion> regions;
  }
  ```
  配置类AwsRegion如下：
  ```java
  @Component
  @Data
  public class AwsRegion{
      private String regionName;
      private String displayName;
      private String endpoint;
  }
  ```
  这样就能直接通过配置文件构建一个对象列表，便于修改
  