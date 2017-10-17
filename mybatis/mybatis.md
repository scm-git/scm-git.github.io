# [王孝东的个人空间](https://scm-git.github.io/)
##MyBatis

###MyBatis Generator with maven plugin
在maven中引入MyBatis Generator插件，在命令行中直接执行命令即可生产MyBatis的相关DAO，Model以及Mapper文件
```xml
<project>
    ...
    <build>
    ...
    <plugins>
    ...
    <plugin>
        <groupId>org.mybatis.generator</groupId>
        <artifactId>mybatis-generator-maven-plugin</artifactId>
        <version>1.3.5</version>
    </plugin>
    ...
    </plugins>
    ...
    </build>
    ...
</project>
```
加入mybatis-generator-maven-plugin之后，可以执行如下命令：
* 不带参数执行：
  ```bash
  mvn mybatis-generator:generate
  ```

* 带参数执行
  ```bash
  mvn -Dmybatis.generator.overwrite=true mybatis-generator:generate
  ```
  
MybatisGenerator.xml文件示例：
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE generatorConfiguration PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN" "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd" >
<generatorConfiguration>
    <context id="WechatPublicPrinting">

        <!-- 生成的Java文件的编码 -->
        <property name="javaFileEncoding" value="UTF-8" />
    
        <!-- 格式化java代码 -->
        <property name="javaFormatter"
            value="org.mybatis.generator.api.dom.DefaultJavaFormatter" />
        <!-- 格式化XML代码 -->
        <property name="xmlFormatter"
            value="org.mybatis.generator.api.dom.DefaultXmlFormatter" />
    
        <plugin type="org.mybatis.generator.plugins.SerializablePlugin"/>
        <plugin type="org.mybatis.generator.plugins.EqualsHashCodePlugin" />
        <plugin type="org.mybatis.generator.plugins.ToStringPlugin"/>
        <plugin type="org.mybatis.generator.plugins.RenameExampleClassPlugin">
            <property name="searchString" value="Example$" />
            <property name="replaceString" value="Criteria" />
        </plugin>
    
        <plugin type="com.hpe.wephoto.common.mybatis.plugin.MapperClassNamePlugin" />
        <plugin type="com.hpe.wephoto.common.mybatis.plugin.MapperMethodNamePlugin" />
        <plugin type="com.hpe.wephoto.common.mybatis.plugin.BeanImplementationPlugin" />
    
        <!-- 去除自动生成的注释 -->
        <commentGenerator>
            <property name="suppressAllComments" value="true" />
            <property name="suppressDate" value="true" />
        </commentGenerator>
        <jdbcConnection driverClass="com.mysql.jdbc.Driver"
            connectionURL="jdbc:mysql://localhost:3306/cloud_wechat_print"
            userId="wxpp" password="xxxxxx" />
    
        <!-- 数据表对应的model 层 -->
        <javaModelGenerator targetPackage="com.hpe.wephoto.common.model"
            targetProject="./src/main/java">
        </javaModelGenerator>
    
        <!-- sql mapper 映射配置文件 -->
        <sqlMapGenerator targetPackage="mybatis.mapper" targetProject="./src/main/resources" />
    
        <!-- 生成DAO对象 -->
        <javaClientGenerator targetPackage="com.hpe.wephoto.common.dao"
            targetProject="./src/main/java" type="XMLMAPPER">
        </javaClientGenerator>
    
        <table schema="cloud_wechat_print" tableName="t_advertisement_print_stat" >
            <generatedKey column="id" sqlStatement="MySql" identity="true" />
        </table>
    </context>
</generatorConfiguration>
```

###MyBatis常用技巧
* 1.使用用like查询时，需要自己拼"%"作为前后的模糊匹配
  * 如果使用自带的criteria， 则可以如下： UserCriteria.createCriteria.andNameLike("%"+name+"%"); 然后使用UserDAO.selectByCriteria()方法查询
  * 如果使用map等自己构造的参数，并使用自己编写的SQL语句查询时，传入的参数同样需要先拼接好占位符"%",例如方法：`UserDAO.selectByUserName(@Param("userName") String userName);`则传入的userName的值应该如下：
    `String userName = "%"+"wxd"+"%"`; 然后调用`userDAO.selectByUserName(userName);` UserMapper.xml文件中则需要传入：`#{userName}`

* 传入`java.util.Map`作为入参时，判断map中是否存在该key，可以使用`_parameter.containsKey('fooKey')`方法，某些版本也可以直接使用`fooKey != null`，但是某些时候不行，可能是版本的原因，没验证过，但是`_parameter.containsKey`是肯定可以的
  * `<if test = "fooKey != null"> FOO_KEY = #{fooKey}</if>`： 某些版本可行
  * `<if test = "_parameter.containsKey('fooKey')" >FOO_KEY = #{fooKey} </if>`: 所有版本都可行

* 联合查询：
  * 1.定义Result:
  
    ```xml
    <resultMap id="FullResultMap" type="com.hpe.wephoto.common.model.TPrinter">
    <id column="TPRINTER_ID" jdbcType="BIGINT" property="id" />
    <result column="TPRINTER_NAME" jdbcType="VARCHAR" property="name" />
    <result column="TPRINTER_DISPLAY_NAME" jdbcType="VARCHAR" property="displayName" />
    <result column="TPRINTER_SN" jdbcType="VARCHAR" property="sn" />
    <result column="TPRINTER_ADDRESS_ID" jdbcType="BIGINT" property="addressId" />
    <result column="TPRINTER_OWNER_ID" jdbcType="BIGINT" property="ownerId" />
    <result column="TPRINTER_TECHNIAN_ID" jdbcType="BIGINT" property="technianId" />
    <result column="TPRINTER_QR_URL" jdbcType="VARCHAR" property="qrUrl" />
    <result column="TPRINTER_EXPIRE_DATE" jdbcType="TIMESTAMP" property="expireDate" />
    <result column="TPRINTER_CREATE_DATE" jdbcType="TIMESTAMP" property="createDate" />
    <result column="TPRINTER_UPDATE_DATE" jdbcType="TIMESTAMP" property="updateDate" />
    <result column="TPRINTER_ADVERTISEMENT_PLAN_ID" jdbcType="BIGINT" property="advertisementPlanId" />
    <result column="TPRINTER_COMPANY_ID" jdbcType="BIGINT" property="companyId" />
    <result column="TPRINTER_PIN_CODE" jdbcType="VARCHAR" property="pinCode" />
    <result column="TPRINTER_PINCODE_STATUS" jdbcType="VARCHAR" property="pincodeStatus" />
    <result column="TPRINTER_WECHAT_ACCOUNT_ID" jdbcType="VARCHAR" property="wechatAccountId" />
    <result column="TPRINTER_USER_ID" jdbcType="BIGINT" property="userId" />
    
    <association property="tUser" javaType="com.hpe.wephoto.common.model.TUser">
        <result column="USER_NAME" jdbcType="VARCHAR" property="name"/>
    </association>
    
    <association property="tCompany" javaType="com.hpe.wephoto.common.model.TCompany">
        <result column="COM_NAME" jdbcType="VARCHAR" property="name"/>
    </association>
    
    <association property="tWechat" javaType="com.hpe.wephoto.common.model.TWechat">
        <result column="WE_ACCOUNT_NAME" jdbcType="VARCHAR" property="accountName"/>
    </association>
    
    <association property="technianUser" javaType="com.hpe.wephoto.common.model.TUser">
        <result column="TE_USER_NAME" jdbcType="VARCHAR" property="name"/>
    </association>
    
    <association property="tAdvertisementPlan" javaType="com.hpe.wephoto.common.model.TAdvertisementPlan">
        <result column="ADVERTISEMENT_PLAN_NAME" jdbcType="VARCHAR" property="name"/>
    </association>
    
    <association property="tAdvertisement" javaType="com.hpe.wephoto.common.model.TAdvertisement">
        <result column="ADVERTISEMENT_NAME" jdbcType="VARCHAR" property="name"/>
    </association>
    
    <association property="tAddress" javaType="com.hpe.wephoto.common.model.TAddress">
        <result column="ADDR_DESCRIPTION" jdbcType="VARCHAR" property="description" />
    </association>
    
    </resultMap>
    ```
  * 2.编写SQL
    ```xml
    <select id="selectFullInfoByCriteria" parameterType="java.util.Map" resultMap="FullResultMap">
      select
      P.ID AS TPRINTER_ID,
      P.NAME AS TPRINTER_NAME,
      P.SN AS TPRINTER_SN,
      P.DISPLAY_NAME AS TPRINTER_DISPLAY_NAME,
      P.ADDRESS_ID AS TPRINTER_ADDRESS_ID,
      P.OWNER_ID AS TPRINTER_OWNER_ID,
      P.TECHNIAN_ID AS TPRINTER_TECHNIAN_ID,
      P.QR_URL AS TPRINTER_QR_URL,
      P.EXPIRE_DATE AS TPRINTER_EXPIRE_DATE,
      P.CREATE_DATE AS TPRINTER_CREATE_DATE,
      P.UPDATE_DATE AS TPRINTER_UPDATE_DATE,
      P.ADVERTISEMENT_PLAN_ID AS TPRINTER_ADVERTISEMENT_PLAN_ID,
      P.COMPANY_ID AS TPRINTER_COMPANY_ID,
      P.PIN_CODE AS TPRINTER_PIN_CODE,
      P.PINCODE_STATUS AS TPRINTER_PINCODE_STATUS,
      P.OWNER_COMPANY_ID AS TPRINTER_OWNER_COMPANY_ID,
      P.USER_ID AS TPRINTER_USER_ID,
      P.WECHAT_ACCOUNT_ID AS TPRINTER_WECHAT_ACCOUNT_ID,
      U.NAME AS USER_NAME,
      TE.NAME AS TE_USER_NAME,
      COM.NAME AS COM_NAME,
      WE.ACCOUNT_NAME AS WE_ACCOUNT_NAME,
      AP.NAME AS ADVERTISEMENT_PLAN_NAME,
      A.NAME AS ADVERTISEMENT_NAME,
      ADDR.DESCRIPTION AS ADDR_DESCRIPTION
    
      from
    
      t_printer P
        LEFT JOIN t_user U ON P.USER_ID = U.USER_ID
        LEFT JOIN t_user TE ON P.TECHNIAN_ID = TE.USER_ID
        LEFT JOIN t_company COM ON P.COMPANY_ID = COM.COMPANY_ID
        LEFT JOIN t_wechat WE ON P.WECHAT_ACCOUNT_ID = WE.ACCOUNT_ID
        LEFT JOIN t_advertisement_plan AP ON P.ADVERTISEMENT_PLAN_ID = AP.ID
        LEFT JOIN t_advertisement A ON AP.ADVERTISEMENT_ID = A.ID
        LEFT JOIN t_address ADDR ON P.ADDRESS_ID = ADDR.ID
      where 1=1
    
      <if test="userId != null">
        and P.USER_ID = #{userId}
      </if>
      <if test="companyId != null">
        and P.COMPANY_ID = #{companyId,jdbcType=BIGINT}
      </if>
      <if test="technianId != null">
        and P.TECHNIAN_ID = #{technianId}
      </if>
      <if test="wechatAccountId != null">
        and P.WECHAT_ACCOUNT_ID = #{wechatAccountId}
      </if>
      <if test="queryParam != null">
        and
        (P.NAME LIKE #{queryParam}
        or P.SN LIKE #{queryParam}
        or U.NAME LIKE #{queryParam}
        or TE.NAME LIKE #{queryParam}
        or COM.NAME LIKE #{queryParam}
        or WE.ACCOUNT_NAME LIKE #{queryParam}
        or AP.NAME LIKE #{queryParam}
        or A.NAME LIKE #{queryParam}
        or ADDR.DESCRIPTION LIKE #{queryParam})
      </if>
    
      order by P.CREATE_DATE desc
    
      <if test="limitByClause != null" >
        limit ${limitByClause}
      </if>
    </select>
    ```