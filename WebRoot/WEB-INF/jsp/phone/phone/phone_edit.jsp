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

							<form action="phone/${msg }.do" name="Form" id="Form"
								method="post">
								<input type="hidden" name="PHONE_ID" id="PHONE_ID"
									value="${pd.PHONE_ID}" />
								<div id="zhongxin" style="padding-top: 13px;">
									<table id="table_report"
										class="table table-striped table-bordered table-hover">
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">座机号码:</td>
											<td>
											<input type="text" name="CPHONE" id="CPHONE"
												<c:if test="${method == 1}">readonly="readonly"</c:if>
												value="${pd.CPHONE}" maxlength="100" placeholder="这里输入座机号码"
												title="座机号码" style="width: 98%;" />
											<input type="hidden" name="USER_ID"
												value="${pd.USER_ID}" maxlength="100" placeholder="这里输入座机号码"
												title="座机号码" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">主线号:</td>
											<td><input type="text" name="MAIN_LINE" id="MAIN_LINE"
												<c:if test="${method == 1}">readonly="readonly"</c:if>
												value="${pd.MAIN_LINE}" maxlength="10" placeholder="这里输入主线号"
												title="主线号" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">备线号:</td>
											<td><input type="text" name="BACK_LINE" id="BACK_LINE"
												<c:if test="${method == 1}">readonly="readonly"</c:if>
												value="${pd.BACK_LINE}" maxlength="10" placeholder="这里输入备线号"
												title="备线号" style="width: 98%;" /></td>
										</tr>
										<c:if test="${method == 1}">
											<tr>
												<td
													style="width: 75px; text-align: right; padding-top: 13px;">部门:</td>
												<td><select name="DEPARTMENT_ID" id="DEPARTMENT_ID"
													style="width: 98%;" onchange="change(this.value);">
														<option value=""></option>
														<c:forEach items="${departments}" var="dep">
															<option value="${dep.BS_DEPARTMENT_ID}">${dep.DEPARTMENT_NAME}</option>
														</c:forEach>
												</select></td>
											</tr>
											<tr>
												<td
													style="width: 75px; text-align: right; padding-top: 13px;">员工:</td>
												<td><select name="USER_ID" id="USER_ID"
													style="width: 98%;">
												</select></td>
											</tr>
										</c:if>
										<c:if test="${method == 2 || method == 1}">
											<tr>
												<td
													style="width: 75px; text-align: right; padding-top: 13px;">备注:</td>
												<td><input type="text" name="REMARK" id="REMARK"
													value="${pd.REMARK}" maxlength="100" placeholder="这里输入姓名"
													title="姓名" style="width: 98%;" /></td>
											</tr>
										</c:if>
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

		function change(value) {
			var url = 'phone/getUsersByDId.do?departmentId=' + value;
			$.get(url, {}, function(result) {
				var html = '<option value=""></option>';
				$.each(result, function(i, user) {
					html += '<option value="'+user.userId+'">' + user.name
							+ '</option>'
				})
				$("#USER_ID").html(html);
			});
		}
		//保存
		function save() {
			if ($("#CPHONE").val() == "") {
				$("#CPHONE").tips({
					side : 3,
					msg : '请输入座机号码',
					bg : '#AE81FF',
					time : 2
				});
				$("#CPHONE").focus();
				return false;
			}
			if ($("#MAIN_LINE").val() == "") {
				$("#MAIN_LINE").tips({
					side : 3,
					msg : '请输入主线号',
					bg : '#AE81FF',
					time : 2
				});
				$("#MAIN_LINE").focus();
				return false;
			}
			if ($("#BACK_LINE").val() == "") {
				$("#BACK_LINE").tips({
					side : 3,
					msg : '请输入备线号',
					bg : '#AE81FF',
					time : 2
				});
				$("#BACK_LINE").focus();
				return false;
			}
			if ($("#USER_ID").val() == "") {
				$("#USER_ID").val(null)
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
		});
	</script>
</body>
</html>