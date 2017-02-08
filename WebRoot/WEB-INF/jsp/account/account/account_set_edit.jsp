<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
	<head>
	<base href="<%=basePath%>">
	<!-- 下拉框 -->
	<link rel="stylesheet" href="static/ace/css/chosen.css" />
	<!-- jsp文件头和头部 -->
	<%@ include file="../../system/index/top.jsp"%>
	<!-- 日期框 -->
	<link rel="stylesheet" href="static/ace/css/datepicker.css" />
	<link rel="stylesheet" href="static/ace/css/datetimepicker.css" />
</head>
<body class="no-skin">
<!-- /section:basics/navbar.layout -->
<div class="main-container" id="main-container">
	<!-- /section:basics/sidebar -->
	<div class="main-content">
		<div class="main-content-inner">
			<div class="page-content">
				<div class="row">
					<div class="col-xs-12">
					
					<form action="account/${msg }.do" name="Form" id="Form" method="post">
						<input type="hidden" name="comsumeTimeslotId" id="comsumeTimeslotId" value="${pd.comsumeTimeslotId}"/>
						<div id="zhongxin" style="padding-top: 13px;">
						<table id="table_report" class="table table-striped table-bordered table-hover">
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">开始时间:</td>
								<td><input type="text" class="_datetime" name="startDate" value="${pd.startDate}" id="startDate"  maxlength="32" placeholder="这里输入开始时间" title="余额" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">结束时间:</td>
								<td><input type="text" class="_datetime" name="endDate" value="${pd.endDate}" id="endDate"  maxlength="32" placeholder="这里输入结束时间" title="余额" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">首次消费:</td>
								<td><input type="text" name="firstMoney" id="firstMoney" value="${pd.firstMoney}"  maxlength="32" placeholder="这里输入首次消费金额" title="余额" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">再次消费:</td>
								<td><input type="text" name="secondMoney" id="secondMoney" value="${pd.secondMoney}"  maxlength="32" placeholder="这里输入再次消费金额" title="余额" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="text-align: center;" colspan="10">
									<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
									<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
								</td>
							</tr>
						</table>
						</div>
						<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
					</form>
					</div>
					<!-- /.col -->
				</div>
				<!-- /.row -->
			</div>
			<!-- /.page-content -->
		</div>
	</div>
	<!-- /.main-content -->
</div>
<!-- /.main-container -->


	<!-- 页面底部js¨ -->
	<%@ include file="../../system/index/foot.jsp"%>
	<!-- 下拉框 -->
	<script src="static/ace/js/chosen.jquery.js"></script>
	<!-- 日期框 -->
	<script src="static/ace/js/date-time/bootstrap-datepicker.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<script src="static/ace/js/date-time/datetimepicker.js"></script>
		<script type="text/javascript">
		$(top.hangge());
		//保存
		function save(){
			if($("#startDate").val()==""){
				$("#startDate").tips({
					side:3,
		            msg:'请输入开始时间',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#startDate").focus();
			return false;
			}
			if($("#endDate").val()==""){
				$("#endDate").tips({
					side:3,
		            msg:'请输入结束时间',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#endDate").focus();
			return false;
			}
			if($("#firstMoney").val()==""){
				$("#firstMoney").tips({
					side:3,
		            msg:'请输入首次消费金额',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#firstMoney").focus();
			return false;
			}
			if($("#secondMoney").val()==""){
				$("#secondMoney").tips({
					side:3,
		            msg:'请输入再次消费金额',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#secondMoney").focus();
			return false;
			}
			$("#Form").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
		}
		
		$(function() {
			//日期框
			$('.date-picker').datepicker({autoclose: true,todayHighlight: true});
			$('._datetime').datetimepicker({
			      lang:"ch",           //语言选择中文
			      format:"H:i",      //格式化日期
			      step:30,
			      todayButton:true    //关闭选择今天按钮
			});
		});

		</script>
</body>
</html>