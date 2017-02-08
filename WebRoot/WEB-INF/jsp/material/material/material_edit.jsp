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
<style type="text/css">
	.must{
		color:red;
	}
</style>
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

							<form action="material/${msg }.do" name="Form" id="Form" class="form-horizontal" role="form"
								method="post">
								<input type="hidden" name="MATERIAL_ID" id="MATERIAL_ID"
									value="${pd.MATERIAL_ID}" />
									<input type="hidden" name="STATUS" id="STATUS"
									value="${pd.status}" />
								<div id="zhongxin" style="padding-top: 13px;">
									<table id="table_report"
										class="table table-striped table-bordered table-hover">
										<tr>
											<td
												style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>物资类型名:</td>
											<td><select class="chosen-select form-control"
												name="MATERIALTYPE_ID" id="MATERIALTYPE_ID"
												data-placeholder="请选择" style="vertical-align: top;"
												style="width:98%;" onchange="change(this.value)">
													<option value=""></option>
													<c:forEach items="${types}" var="dep">
														<option value="${dep.MATERIALTYPE_ID}">${dep.MATERIAL_TYPE_NAME}</option>
													</c:forEach>
											</select></td>
										</tr>
										<tr>
											<td
												style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>物资名称:</td>
											<td><select id="MATERIALNAME_ID" name="MATERIALNAME_ID"
												style="width: 98%;">

											</select></td>
										</tr>
										<tr>
											<td
												style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>品牌:</td>
											<td><input type="text" name="BRAND" id="BRAND"
												value="${pd.BRAND}" maxlength="100" placeholder="这里输入品牌"
												title="品牌" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>型号:</td>
											<td><input type="text" name="MODEL" id="MODEL"
												value="${pd.MODEL}" maxlength="100" placeholder="这里输入型号"
												title="型号" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 150px; text-align: right; padding-top: 13px;">参数:</td>
											<td><input type="text" name="PARAM" id="PARAM"
												value="${pd.PARAM}" maxlength="1024" placeholder="这里输入参数"
												title="参数" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>产品价值:</td>
											<td><input type="text" name="PRICE" id="PRICE"
												value="${pd.PRICE}" maxlength="11" placeholder="这里输入产品价值"
												title="产品价值" style="width: 98%;" /></td>
										</tr>
										<c:if test="${pd.status == 0}">
											<tr>
												<td
													style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>产品数量:</td>
												<td><input type="number" name="count"></td>
											</tr>
											<tr>
												<td
													style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>存放办公区:</td>
												<td><input type="text" name="DEPOSIT_OFFICE"
													id="DEPOSIT_OFFICE" value="${pd.DEPOSIT_OFFICE}"
													maxlength="100" placeholder="这里输入存放办公区" title="存放办公区"
													style="width: 98%;" /></td>
											</tr>
											<tr>
												<td
													style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>存放楼层:</td>
												<td><input type="text" name="DEPOSIT_FLOOR"
													id="DEPOSIT_FLOOR" value="${pd.DEPOSIT_FLOOR}"
													maxlength="100" placeholder="这里输入存放楼层" title="存放楼层"
													style="width: 98%;" /></td>
											</tr>
											<tr>
												<td
													style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>存放房间号:</td>
												<td><input type="text" name="DEPOSIT_HOUSE"
													id="DEPOSIT_HOUSE" value="${pd.DEPOSIT_HOUSE}"
													maxlength="100" placeholder="这里输入存放房间号" title="存放房间号"
													style="width: 98%;" /></td>
											</tr>
										</c:if>
										<tr>
											<td
												style="width: 150px; text-align: right; padding-top: 13px;"><span class="must">*</span>是否需要序列号:</td>
											<td><input name="IS_NEED_SERIAL" type="radio"
												class="ace" id="form-field-radio1" checked="checked" value="1" onclick="serialSpan.innerHTML='*'"/> <span
												class="lbl">是</span><input name="IS_NEED_SERIAL"
												type="radio" class="ace" id="form-field-radio1" value="0" onclick="serialSpan.innerHTML=''"/>
												<span class="lbl">否</span></td>
										</tr>
										<c:if test="${pd.status == 6}">
											<tr>
												<td
													style="width: 150px; text-align: right; padding-top: 13px;"><span class="must" id="serialSpan">*</span>序列号:</td>
												<td><input type="hidden" name="count" value="1"><input
													type="text" name="serial_number"></td>
											</tr>
											<tr>
												<td
													style="width: 75px; text-align: right; padding-top: 13px;"><span class="must">*</span>部门名称:</td>
												<td><select name="DEPARTMENT_ID" id="DEPARTMENT_ID" onchange="changeUser(this.value)"
													style="width: 98%;">
														<option></option>
														<c:forEach items="${departments}" var="dep">
															<option value="${dep.BS_DEPARTMENT_ID}">${dep.DEPARTMENT_NAME}</option>
														</c:forEach>
												</select></td>
											</tr>
											<tr>
												<td
													style="width: 75px; text-align: right; padding-top: 13px;"><span class="must">*</span>员工:</td>
												<td><select name="USER_ID" id="USER_ID"
													style="width: 98%;">
												</select></td>
											</tr>
										</c:if>
										<tr>
											<td
												style="width: 150px; text-align: right; padding-top: 13px;">备注:</td>
											<td><input type="text" name="REMARK" id="REMARK"
												value="${pd.REMARK}" maxlength="100" placeholder="这里输入备注"
												title="备注" style="width: 98%;" /></td>
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
		function changeUser(value) {
			var url = 'meeting/getUsersBySId.do?departmentId=' + value;
			$.get(url, {}, function(result) {
				var html="";
				$.each(result, function(i, user) {
					html += '<option value="'+user.userId+'">'
					+ user.name + '</option>'
				})
				$("#USER_ID").html(html);
			});
		}
		function change(value) {
			var url = 'material/queryMaterialnameByTypeId.do?typeId=' + value;
			$.get(url, {}, function(result) {
				var html = '<option value=""></option>';
				$.each(result, function(i, user) {
					html += '<option value="'+user.MATERIALNAME_ID+'">'
							+ user.MATERIAL_NAME + '</option>'
				})
				$("#MATERIALNAME_ID").html(html);
			});
		}
		function save() {
			if ($("#MATERIALTYPE_ID").val() == "") {
				$("#MATERIALTYPE_ID").tips({
					side : 3,
					msg : '请输入物资类型名',
					bg : '#AE81FF',
					time : 2
				});
				$("#MATERIALTYPE_ID").focus();
				return false;
			}
			if ($("#MATERIALNAME_ID").val() == "") {
				$("#MATERIALNAME_ID").tips({
					side : 3,
					msg : '请输入物资名称',
					bg : '#AE81FF',
					time : 2
				});
				$("#MATERIALNAME_ID").focus();
				return false;
			}
			if ($("#BRAND").val() == "") {
				$("#BRAND").tips({
					side : 3,
					msg : '请输入品牌',
					bg : '#AE81FF',
					time : 2
				});
				$("#BRAND").focus();
				return false;
			}
			if ($("#MODEL").val() == "") {
				$("#MODEL").tips({
					side : 3,
					msg : '请输入型号',
					bg : '#AE81FF',
					time : 2
				});
				$("#MODEL").focus();
				return false;
			}
			if ($("#PRICE").val() == "") {
				$("#PRICE").tips({
					side : 3,
					msg : '请输入产品价值',
					bg : '#AE81FF',
					time : 2
				});
				$("#PRICE").focus();
				return false;
			}
			if ($("#DEPOSIT_OFFICE").val() == "") {
				$("#DEPOSIT_OFFICE").tips({
					side : 3,
					msg : '请输入存放办公区',
					bg : '#AE81FF',
					time : 2
				});
				$("#DEPOSIT_OFFICE").focus();
				return false;
			}
			if ($("#DEPOSIT_FLOOR").val() == "") {
				$("#DEPOSIT_FLOOR").tips({
					side : 3,
					msg : '请输入存放楼层',
					bg : '#AE81FF',
					time : 2
				});
				$("#DEPOSIT_FLOOR").focus();
				return false;
			}
			if ($("#DEPOSIT_HOUSE").val() == "") {
				$("#DEPOSIT_HOUSE").tips({
					side : 3,
					msg : '请输入存放房间号',
					bg : '#AE81FF',
					time : 2
				});
				$("#DEPOSIT_HOUSE").focus();
				return false;
			}
			if ($("#USER_ID").val() == "") {
				$("#USER_ID").tips({
					side : 3,
					msg : '请输入使用人',
					bg : '#AE81FF',
					time : 2
				});
				$("#USER_ID").focus();
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
	</script>
</body>
</html>