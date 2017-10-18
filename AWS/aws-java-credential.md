# [王孝东的个人空间](https://scm-git.github.io/)
## AWS 开发
获取Client，Client中已包括credential

```java
package com.hpe.foxcloud.core.aws.util;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.auth.profile.internal.AwsProfileNameLoader;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder;
import com.amazonaws.services.identitymanagement.AmazonIdentityManagement;
import com.amazonaws.services.identitymanagement.AmazonIdentityManagementClientBuilder;
import com.hpe.foxcloud.core.aws.config.AwsClientConfigure;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * Created by wanxiaod on 9/13/2017.
 */
@Component
public class AwsClientUtil {

    @Autowired
    private AwsClientConfigure awsClientConfigure;

    @Value("${cloud.aws.region.static}")
    private String configureRegion;

    /**
     * 获取EC2的客户端：如果配置文件中配置了代理，则同时也为AmazonEC2客户端配置代理
     * @param region
     * @param awsAccessKeyId
     * @param awsSecretAccessKey
     * @return
     */
    public AmazonEC2 getAmazonEC2Client(String region, String awsAccessKeyId, String awsSecretAccessKey, String profile){
        AWSCredentialsProvider awsCredentialsProvider = getAwsCredentialsProvider(awsAccessKeyId, awsSecretAccessKey, profile);
        ClientConfiguration clientConfiguration = getClientConfiguration();

        // 如果没有传入region参数，则将region设置为配置的值(cloud.aws.region.static)
        if(StringUtils.isEmpty(region)){
            region = configureRegion;
        }

        AmazonEC2 amazonEC2Client = AmazonEC2ClientBuilder.standard().withCredentials(awsCredentialsProvider).withClientConfiguration(clientConfiguration).withRegion(region).build();

        return amazonEC2Client;
    }

    /**
     * 获取AWS EC2 Client,不带profile参数
     * @param region
     * @param awsAccessKeyId
     * @param awsSecretAccessKey
     * @return
     */
    public AmazonEC2 getAmazonEC2Client(String region, String awsAccessKeyId, String awsSecretAccessKey){
        return getAmazonEC2Client(region, awsAccessKeyId, awsSecretAccessKey, null);
    }

    /**
     * 获取AWS IAM客户端：如果配置文件中配置了代理，则同时也为IAM客户端配置代理
     * @param region
     * @param awsAccessKeyId
     * @param awsSecretAccessKey
     * @param profile
     * @return
     */
    public AmazonIdentityManagement getAmazonIdentityManagement(String region, String awsAccessKeyId, String awsSecretAccessKey, String profile){
        AWSCredentialsProvider awsCredentialsProvider = getAwsCredentialsProvider(awsAccessKeyId, awsSecretAccessKey, profile);
        ClientConfiguration clientConfiguration = getClientConfiguration();

        // 如果没有传入region参数，则将region设置为配置的值(cloud.aws.region.static)
        if(StringUtils.isEmpty(region)){
            region = configureRegion;
        }

        AmazonIdentityManagement amazonIdentityManagement = AmazonIdentityManagementClientBuilder.standard().withCredentials(awsCredentialsProvider).withClientConfiguration(clientConfiguration).withRegion(region).build();

        return amazonIdentityManagement;
    }

    /**
     * 获取AWS客户端配置，包括代理主机，端口
     * @return
     */
    private ClientConfiguration getClientConfiguration(){
        ClientConfiguration clientConfiguration = new ClientConfiguration();
        clientConfiguration.setProxyHost(awsClientConfigure.getProxyHost());
        clientConfiguration.setProxyPort(awsClientConfigure.getProxyPort());
        return clientConfiguration;
    }

    /**
     *
     * 1. 首先根据awsAccessKeyId和awsSecretAccessKey配置获取credentials
     * 2. 如果awsAccessKeyId或者awsSecretAccessKey为空，则使用传入的profile参数，如果传入的profile参数也为空，则使用default的profile
     *
     * @param awsAccessKeyId
     * @param awsSecretAccessKey
     * @param profile
     * @return
     */
    private AWSCredentialsProvider getAwsCredentialsProvider(String awsAccessKeyId, String awsSecretAccessKey, String profile){
        AWSCredentialsProvider awsCredentialsProvider;

        if(StringUtils.isNotEmpty(awsAccessKeyId) && StringUtils.isNotEmpty(awsSecretAccessKey)) {
            BasicAWSCredentials awsCredentials = new BasicAWSCredentials(awsAccessKeyId, awsSecretAccessKey);
            awsCredentialsProvider = new AWSStaticCredentialsProvider(awsCredentials);
        } else {
            // 存储在~/.aws/credentials文件中的profile: 例如：[xiaodong]
            if (StringUtils.isEmpty(profile)){  // 如果传入的profile为空，则使用默认的profile: default
                profile = AwsProfileNameLoader.DEFAULT_PROFILE_NAME;
            }
            awsCredentialsProvider = new ProfileCredentialsProvider(profile);
        }

        return awsCredentialsProvider;
    }

}
```

代理配置：
```java
package com.hpe.foxcloud.core.aws.config;

import com.amazonaws.ClientConfiguration;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Created by wanxiaod on 9/13/2017.
 */

@Component
@ConfigurationProperties(prefix = "foxcloud.aws.clientConfigure", ignoreInvalidFields = true)
@Data
public class AwsClientConfigure{
    private String proxyHost;
    private int proxyPort;
}
```

application.yml:
```yaml
server:
  port: 9166
logging:
  path: /hpe/logs/hpe_micro/core/

foxcloud:
  aws:
    clientConfigure:
      proxyHost: web-proxy.sgp.hp.com
      proxyPort: 8080

cloud:
  aws:
    region:
      static: us-west-1
```
代理配置根据实际情况看是需要配置，通常在公司内网需要配置代理。另外需要配置一个初始的region：`cloud.aws.region.static`，如果不配置，启动时会报错
