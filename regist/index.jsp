<%@ page import="byaero.entity.Entity" %>
<%@ page pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>博鹰售后云系统</title>
    <style>
    *{
    margin: 0;
    padding: 0;
    }
    input{
    outline:none;
    border:0px;

    }
    .warp{
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    right: 0;
    }
    .headtitle{
    height:40px;
    width: 100%;
    line-height:40px;
    text-align: center;
    font-size:20px;
    color: #0080ff;
    border-bottom: 1px solid #cccccc;
    }
    .main{
    width: 325px;
    height: 206px;
    margin:202px auto 0;
    }
    .registBtn{
    margin-top: 40px;
    width: 100%;
    height: 52px;
    line-height:52px;
    background: url("./registImg/regist.png") no-repeat center center;
    -webkit-background-size: 100%;
    background-size: 100%;
    text-align: center;
    color: #ffffff;
    font-size:21px;
    font-weight:bold;
    letter-spacing: 5px;
    }
    .row-z{
    width: 100%;
    height: 50px;
    border-bottom: 1px solid #cccccc;
    }
    .row-z span:nth-child(1){
    width: 85px;
    height: 50px;
    line-height:50px;
    text-align: left;
    padding-left:15px;
    font-size:21px;
    color: #0080ff;
    font-weight:bold;
    }
    .row-z input{
    width: 130px;
    height: 50px;
    font-size:15px;
    color: #808080;
    }
    .display{
    display: inline-block;
    vertical-align: top;
    font-size:0;
    }
    .getCode{
    width: 110px;
    height: 40px;
    margin-top:5px;
    }
    .getCode button{
    width: 100%;
    height: 38px;
    line-height:38px;
    border:1px solid #0080ff;
    border-radius: 4px;
    color: #000;
    text-align: center;
    font-size:18px;
    background: #ffffff;
    }
    </style>
    <script src="zepto.js"></script>
</head>
<body>
    <div class="warp">
    <h1 class="headtitle"><span>注册</span></h1>
    <div class="main">
    <div>
    <div class="row-z">
    <span class="display">姓名</span>
    <input class="display" id="z-name" placeholder="请输入您的姓名"/>
    </div>
    <div class="row-z">
    <span class="display">手机号</span>
    <input class="display" id="z-phone" placeholder="请输入您的手机号"/>
    </div>
    <div class="row-z" style="position: relative;">
    <span class="display">验证码</span>
    <input class="display" id="z-code" placeholder="请输入验证码" style="width: 100px;"/>
    <span class="display getCode" style="position: absolute; right: 4px;top: 0;">
    <button id="get-code">获取验证码</button>
    </span>
    </div>
    </div>
    <div class="registBtn" id="regist"> 注册 </div>
    </div>
    </div>
    <div style="display:none">
        <div>
        <span>OpenID=</span>
        <span id="openId"><%=request.getAttribute(Entity.openID)%></span>
        </div>
        <div>type=<%=request.getAttribute(Entity.type)%></div>
        <div>jobid=<%=request.getAttribute("jobid")%></div>
    </div>


</body>
    <script>
    //获取OpenId
    var OpenId = $('#openId').html();
    //    姓名
    var $name = $('#z-name');
    //手机号
    var phone = $('#z-phone');
    var code = $('#z-code');
    var nameReg = /^[\u4E00-\u9FA5A-Za-z0-9]*$/;
    var phoneReg = /^((\+?86)|(\(\+86\)))?1[3|7|5|8][0-9]\d{8}$/;
    //获取验证码
    var inviteOK = true;
    $('#get-code').on('touchstart',function () {

    if($name.val()==''){
    alert('姓名不能为空！');
    return false;
    }
    if(phone.val()==''){
    alert('手机号码不能为空！');
    return false;
    }
    //验证输入的电话号码是否是11位数字
    if(!phoneReg.test(phone.val())){
    alert('请输入正确的手机号码！');
    return false;
    }
    var time=60;
    var timer=null;
    if(inviteOK)
    {
    $('#get-code').html((time)+'秒后重试')
    .attr("disabled",true);
    timer=setInterval(function()
    {
    inviteOK=false;
    /*时间到1秒 停止定时器 return后 不执行下面代码 否则会变成0秒后再次发送验证码*/
    if(time<=1)
    {
    $('#get-code').html('获取验证码');
    $('#get-code').attr("disabled",false);
    clearInterval(timer);
    inviteOK=true;
    return;
    }
    $('#get-code').html((--time)+'秒后重试')
    },1000)
    }
    //发送验证码
    $.ajax({
    url:'http://123.207.146.65/aftersale/Web/SendVerifiCodeSms.do',
    type:'POST',
    data:{
    'OpenId':OpenId,
    'mobile':phone.val()
    },
    success:function (json) {
    alert('验证码已发送，请注意接收。')
    }
    })
    });
    //注册按钮
    $('#regist').on('touchstart',function () {
    if($name.val()==''){
    alert('姓名不能为空！');
    return false;
    }
    if(!nameReg.test($name.val())){
    alert('姓名不许有特殊符号！');
    return false;
    }
    if(phone.val()==''){
    alert('手机号码不能为空！');
    return false;
    }
    //验证输入的电话号码是否是11位数字
    if(!phoneReg.test(phone.val())){
    alert('请输入正确的手机号码！');
    return false;
    }
    if(code.val()==''){
    alert('验证码不能为空！');
    return false;
    }
    //短信验证码是否正确
    $.ajax({
    url:'http://123.207.146.65/aftersale/Web/Registered.do',
    type:'POST',
    async:false,
    data:{
    'OpenId':OpenId,
    'mobile':phone.val(),
    'name':$name.val(),
    'verifi_code':code.val()
    },
    success:function (json) {
    var json = $.parseJSON(json);
    if(json.code==200){
    alert('注册成功');
    }else{
    alert(json.msg);
    }
    }
    })
    });
    //.test(value)
    //不许有特殊符号 就是除大小写英文，数字和汉字以外的特殊符号return .test(value);
    </script>
</html>
