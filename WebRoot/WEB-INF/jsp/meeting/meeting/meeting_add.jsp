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

							<form action="meeting/${msg}.do" name="Form" id="Form"
								method="post">
								<input type="hidden" name="MEEING_ID" id="MEEING_ID"
									value="${pd.MEEING_ID}" />
									<input type="hidden" name="SERVICETYPE_ID" id="SERVICETYPE_ID"
									value="2cb289f548e24c86b8381cbc28fa22ba" /><!-- 默认会议ID -->
								<div id="zhongxin" style="padding-top: 13px;">
									<table id="table_report"
										class="table table-striped table-bordered table-hover">
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">服务类型:</td>
											<td><input type="text" readonly="readonly" value="会议" /></td>
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
												style="width: 98%" ></select></td>
										</tr>
										<tr>
											<td
												style="width: 100px; text-align: right; padding-top: 13px;">会议室地址:</td>
											<td><select class="chosen-select form-control"
												name="MEETINGROOM_ID" id="MEETINGROOM_ID" data-placeholder="请选择部门"
												style="vertical-align: top;" style="width:98%;"
												>
													<option value=""></option>
													<c:forEach items="${meetingrooms}" var="dep">
														<option value="${dep.MEETINGROOM_ID}">${dep.AREA}</option>
													</c:forEach>
											</select></td>
										</tr>
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">会议名称:</td>
											<td><input type="text" name="MEETING_NAME" id="MEETING_NAME"
												value="${pd.MEETING_NAME}" maxlength="2048" placeholder="这里输入会议名称"
												title="会议名称" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 100px; text-align: right; padding-top: 13px;">开始时间:</td>
											<td><input type="text" class="_datetime" name="START_DATE" value="" id="startdatetimepicker"/></td>
										</tr>
										<tr>
											<td
												style="width: 100px; text-align: right; padding-top: 13px;">结束时间:</td>
											<td><input type="text" class="_datetime"  name="END_DATE" value="" id="enddatetimepicker"/></td>
										</tr>
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">会议描述:</td>
											<td><input type="text" name="INFOR" id="INFOR"
												value="${pd.INFOR}" maxlength="2048" placeholder="这里输入会议描述"
												title="会议描述" style="width: 98%;" /></td>
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
	<script src="static/ace/js/date-time/datetimepicker.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<script type="text/javascript">
		$(top.hangge());
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
			if ($("#USER_ID").val() == "") {
				$("#USER_ID").tips({
					side : 3,
					msg : '请选择申请人',
					bg : '#AE81FF',
					time : 2
				});
				$("#USER_ID").focus();
				return false;
			}
			if ($("#startdatetimepicker").val() == "") {
				$("#startdatetimepicker").tips({
					side : 3,
					msg : '请选择会议开始时间',
					bg : '#AE81FF',
					time : 2
				});
				$("#startdatetimepicker").focus();
				return false;
			}
			if ($("#enddatetimepicker").val() == "") {
				$("#enddatetimepicker").tips({
					side : 3,
					msg : '请选择会议结束时间',
					bg : '#AE81FF',
					time : 2
				});
				$("#enddatetimepicker").focus();
				return false;
			}
			if ($("#MEETINGROOM_ID").val() == "") {
				$("#MEETINGROOM_ID").tips({
					side : 3,
					msg : '请输入会议室',
					bg : '#AE81FF',
					time : 2
				});
				$("#MEETINGROOM_ID").focus();
				return false;
			}
			if ($("#MEETING_NAME").val() == "") {
				$("#MEETING_NAME").tips({
					side : 3,
					msg : '请输入会议名称',
					bg : '#AE81FF',
					time : 2
				});
				$("#MEETING_NAME").focus();
				return false;
			}
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
			$('._datetime').datetimepicker({
			      lang:"ch",           //语言选择中文
			      format:"Y-m-d H:i",      //格式化日期
			      step:5,
			      todayButton:true    //关闭选择今天按钮
			});
			$("#materialNames").hide();
		});
	</script>
</body>
</html>