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

							<form action="version/${msg }.do" name="Form" id="Form"
								method="post">
								<input type="hidden" name="VERSION_ID" id="VERSION_ID"
									value="${pd.VERSION_ID}" />
								<div id="zhongxin" style="padding-top: 13px;">
									<table id="table_report"
										class="table table-striped table-bordered table-hover">
										<tr>
											<td
												style="width: 105px; text-align: right; padding-top: 13px;">版本名称:</td>
											<td><input type="text" name="VERSION_NAME"
												id="VERSION_NAME" value="${pd.VERSION_NAME}" maxlength="100"
												placeholder="这里输入版本名称" title="版本名" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 105px; text-align: right; padding-top: 13px;">文件上传:</td>
											<td><input id="file" type="file" />
												<button id="upload" type="button" onclick="uploadFile()">上传</button>
												<input type="hidden" name="DOWNLOAD_URL" id="DOWNLOAD_URL"
												value="${pd.DOWNLOAD_URL}" maxlength="100"
												placeholder="这里输入备注3" title="备注3" style="width: 98%;" /> <input
												type="hidden" name="VERSION_CODE" value="${pd.VERSION_CODE}" />
											</td>
										</tr>
										<tr>
											<td
												style="width: 105px; text-align: right; padding-top: 13px;">文件类型:</td>
											<td><select name="TYPE" id="TYPE" style="width: 98%;" value="${pd.TYPE}">
<!-- 													<option value="">请选择</option> -->
													<option selected="selected" value="1">安卓</option>
<!-- 													<option value="2">IOS</option> -->
											</select></td>
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
		function save() {
			if ($("#VERSION_NAME").val() == "") {
				$("#VERSION_NAME").tips({
					side : 3,
					msg : '请输入版本名',
					bg : '#AE81FF',
					time : 2
				});
				$("#VERSION_NAME").focus();
				return false;
			}
			if ($("#DOWNLOAD_URL").val() == "" && $("#file").val() == "") {
				$("#file").tips({
					side : 3,
					msg : '请输入选择文件',
					bg : '#AE81FF',
					time : 2
				});
				$("#file").focus();
				return false;
			}
			if ($("#DOWNLOAD_URL").val() == "") {
				$("#DOWNLOAD_URL").tips({
					side : 3,
					msg : '请上传文件',
					bg : '#AE81FF',
					time : 2
				});
				$("#DOWNLOAD_URL").focus();
				return false;
			}
			if ($("#TYPE").val() == "") {
				$("#TYPE").tips({
					side : 3,
					msg : '请选择文件类型',
					bg : '#AE81FF',
					time : 2
				});
				$("#TYPE").focus();
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
		});
		function uploadFile() {
			var formData = new FormData();
			formData.append('file', $('#file')[0].files[0]);
			$.ajax({
				url : '<%=basePath%>appuser/saveFile',
					type : 'POST',
					cache : false,
					data : formData,
					processData : false,
					contentType : false
				}).done(function(res) {
					alert("上传成功");
					$("#DOWNLOAD_URL").val(res);
				}).fail(function(res) {
				});
		}
	</script>
</body>
</html>