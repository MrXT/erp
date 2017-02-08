<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    String path = request.getContextPath();
			String basePath = request.getScheme() + "://"
					+ request.getServerName() + ":" + request.getServerPort()
					+ path + "/";
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

							<form action="order/${msg }.do" name="Form" id="Form"
								method="post">
								<input type="hidden" name="ORDER_ID" id="ORDER_ID"
									value="${pd.ORDER_ID}" />
									<input type="hidden" name="MATERIALNAME_IDS" id="MATERIALNAME_IDS">
								<div id="zhongxin" style="padding-top: 13px;">
									<table id="table_report"
										class="table table-striped table-bordered table-hover">
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">服务类型:</td>
											<td><select name="SERVICETYPE_ID" id="SERVICETYPE_ID"
												style="width: 98%;" onchange="changeType(this.value);">
													<option value=""></option>
													<c:forEach items="${servicetypes}" var="dep">
														<option value="${dep.SERVICETYPE_ID}">${dep.SERVICETYPE_NAME}</option>

													</c:forEach>
											</select></td>
										</tr>
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">申请部门:</td>
											<td><select class="chosen-select form-control"
												name="DEPARTMENT_ID" id="role_id" data-placeholder="请选择部门"
												style="vertical-align: top;" style="width:98%;"
												onchange="change(this.value)">
													<option value=""></option>
													<c:forEach items="${departments}" var="dep">
														<option value="${dep.BS_DEPARTMENT_ID}">${dep.DEPARTMENT_NAME}</option>

													</c:forEach>
											</select></td>
										</tr>
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">申请人:</td>
											<td><select id="USER_ID" name="USER_ID"
												style="width: 98%" onchange="changeUser(this.value);"></select></td>
										</tr>
										<tr id="materialNames">
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">设备名称:</td>
											<td id="MATERIAL_NAMES"></td>
										</tr>
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">问题描述:</td>
											<td><input type="text" name="INFOR" id="INFOR"
												value="${pd.INFOR}" maxlength="2048" placeholder="这里输入问题描述"
												title="问题描述" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td style="text-align: center;" colspan="10"><a
												class="btn btn-mini btn-primary" onclick="save();">保存</a> <a
												class="btn btn-mini btn-danger"
												onclick="top.Dialog.close();">取消</a></td>
										</tr>
									</table>
								</div>
								<div id="zhongxin2" class="center" style="display: none">
									<br /> <br /> <br /> <br /> <br /> <img
										src="static/images/jiazai.gif" /><br />
									<h4 class="lighter block green">提交中...</h4>
								</div>
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
		function changeType(value){
			if(value == '710d2a9f46d54573a416edebb8f18a43'){//设备ID
				$("#materialNames").show();
			}else{
				$("#materialNames").hide();
			}
		}
		function changeUser(value) {
			var url = 'material/queryMaterialNameByUserId.do?USER_ID=' + value;
			$.get(url, {}, function(result) {
				var html="";
				$.each(result, function(i, user) {
					html += '<input id="'+user.MATERIAL_ID+'" onclick="changeBuserId()" type="checkbox"  name="MATERIAL_NAMES" value="'+user.MATERIAL_NAME+'">'+user.MATERIAL_NAME+'&nbsp;'
				})
				$("#MATERIAL_NAMES").html(html);
			});
		}
		function changeBuserId(){
			var value = "";
			$.each($("input[type='checkbox']"),function(i,id){
				if(id.checked == true){
					value += id.id+",";
				}
			});
			if(value.length>0){
				value = value.substring(0,value.length-1);
				$("#MATERIALNAME_IDS").val(value);
			}
		}
		function change(value) {
			var url = 'meeting/getUsersBySId.do?departmentId=' + value;
			$.get(url, {}, function(result) {
				var html = '<option value=""></option>';
				$.each(result, function(i, user) {
					html += '<option value="'+user.userId+'">' + user.name
							+ '</option>'
				})
				$("#USER_ID").html(html);
			});
		}
		function save() {
			$("#Form").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
		}

		$(function() {
			//日期框
			$('.date-picker').datepicker({
				autoclose : true,
				todayHighlight : true
			});
			$("#materialNames").hide();
		});
	</script>
</body>
</html>