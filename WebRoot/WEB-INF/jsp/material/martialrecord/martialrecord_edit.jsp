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
					
					<form action="martialrecord/${msg }.do" name="Form" id="Form" method="post">
						<input type="hidden" name="MARTIALRECORD_ID" id="MARTIALRECORD_ID" value="${pd.MARTIALRECORD_ID}"/>
						<div id="zhongxin" style="padding-top: 13px;">
						<table id="table_report" class="table table-striped table-bordered table-hover">
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">品牌:</td>
								<td><input type="text" name="MATERIAL_ID" id="MATERIAL_ID" value="${pd.MATERIAL_ID}" maxlength="100" placeholder="这里输入品牌" title="品牌" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">移交人:</td>
								<td><input type="text" name="FROM_USER_ID" id="FROM_USER_ID" value="${pd.FROM_USER_ID}" maxlength="100" placeholder="这里输入移交人" title="移交人" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">接收人:</td>
								<td><input type="text" name="TO_USER_ID" id="TO_USER_ID" value="${pd.TO_USER_ID}" maxlength="100" placeholder="这里输入接收人" title="接收人" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">移交时间:</td>
								<td><input class="span10 date-picker" name="CTIME" id="CTIME" value="${pd.CTIME}" type="text" data-date-format="yyyy-mm-dd" readonly="readonly" placeholder="移交时间" title="移交时间" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">移交部门:</td>
								<td><input type="text" name="FROM_DEPARTMENT_ID" id="FROM_DEPARTMENT_ID" value="${pd.FROM_DEPARTMENT_ID}" maxlength="100" placeholder="这里输入移交部门" title="移交部门" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">接收部门:</td>
								<td><input type="text" name="TO_DEPARTMENT_ID" id="TO_DEPARTMENT_ID" value="${pd.TO_DEPARTMENT_ID}" maxlength="100" placeholder="这里输入接收部门" title="接收部门" style="width:98%;"/></td>
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
		<script type="text/javascript">
		$(top.hangge());
		//保存
		function save(){
			if($("#MATERIAL_ID").val()==""){
				$("#MATERIAL_ID").tips({
					side:3,
		            msg:'请输入品牌',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#MATERIAL_ID").focus();
			return false;
			}
			if($("#FROM_USER_ID").val()==""){
				$("#FROM_USER_ID").tips({
					side:3,
		            msg:'请输入移交人',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#FROM_USER_ID").focus();
			return false;
			}
			if($("#TO_USER_ID").val()==""){
				$("#TO_USER_ID").tips({
					side:3,
		            msg:'请输入接收人',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#TO_USER_ID").focus();
			return false;
			}
			if($("#CTIME").val()==""){
				$("#CTIME").tips({
					side:3,
		            msg:'请输入移交时间',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#CTIME").focus();
			return false;
			}
			if($("#FROM_DEPARTMENT_ID").val()==""){
				$("#FROM_DEPARTMENT_ID").tips({
					side:3,
		            msg:'请输入移交部门',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#FROM_DEPARTMENT_ID").focus();
			return false;
			}
			if($("#TO_DEPARTMENT_ID").val()==""){
				$("#TO_DEPARTMENT_ID").tips({
					side:3,
		            msg:'请输入接收部门',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#TO_DEPARTMENT_ID").focus();
			return false;
			}
			$("#Form").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
		}
		
		$(function() {
			//日期框
			$('.date-picker').datepicker({autoclose: true,todayHighlight: true});
		});
		</script>
</body>
</html>