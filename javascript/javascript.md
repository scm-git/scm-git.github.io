# [王孝东的个人空间](https://scm-git.github.io/)
## Javascript
* 1.jQuery判断复选框是否选中：
  ```javascript
  isChecked = $( "#checkBoxId").is( ":checked" );
  ```

* 2.jQuery全选/取消全选
  ```javascript
  $("#selectAllPrinter").change(function(){
     $("input[name='printerSn']").prop("checked", this.checked);
  });
  ```
  不要用`attr`方法
  
* 3.ajax请求时session过期处理
  * 服务端判断请求是否是ajax请求：
    ```java
    String xRequestedWith = request.getHeader("x-requested-with");
    if (xRequestedWith != null && xRequestedWith.equalsIgnoreCase("XMLHttpRequest")) {
         response.getWriter().print("sessionTimeout");
         return false;
    }
    ```
    
  * 页面设置ajax全局选项，可以使用jQuery的API：
    ```javascript
    // 设置ajax全局选项
    var SESSION_TIMEOUT = "sessionTimeout";      // session失效字符串，后台判断session失效时设置得字符串值
    $.ajaxSetup({
         contentType:"application/x-www-form-urlencoded;charset=utf-8",
         complete:function(data,TS){
              // session失效后，ajax提交请求直接跳转到登录页面
              if(data.responseText == SESSION_TIMEOUT){
                   window.location.href="/login.html"; // 如果server返回SESSION_TIMEOUT字符串，跳转到登录页面
              }
         }
    });
    ```

* 4.[canvas](./canvas.htmls)