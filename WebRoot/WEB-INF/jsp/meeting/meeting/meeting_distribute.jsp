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

							<form action="meeting/${msg }.do" name="Form" id="Form"
								method="post">
								<input type="hidden" name="MEETING_ID" id="MEETING_ID"
									value="${pd.MEETING_ID}" />
									<input type="hidden" name="method" id="method"
									value="${pd.method}" />
								<div id="zhongxin" style="padding-top: 13px;">
									<table id="table_report"
										class="table table-striped table-bordered table-hover">
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">岗位:</td>
											<td><select name="STATION_ID" id="STATION_ID"
												style="width: 98%;" onchange="change(this.value);">
													<option value=""></option>
													<c:forEach items="${stations}" var="dep">
														<option value="${dep.STATION_ID}">${dep.STATION_NAME}</option>
													</c:forEach>
											</select></td>
										</tr>
										<tr>
											<td colspan="2"
												style=" text-align: left; padding-top: 13px;">运维人员:</td>
										</tr>
										<tr>
											<td colspan="2"  id="ausers"> 
												</td>
										</tr>
										<tr>
											<td colspan="2"
												style=" text-align: left; padding-top: 13px;">责任人:</td>
										</tr>
										<tr>
											<td colspan="2" id="busers"> 
												</td>
										</tr>
										<tr>
											<td
												style="width: 75px; text-align: right; padding-top: 13px;">备注:</td>
											<td><input name="remark" type="text"></td>
										</tr>
										<tr>
											<td
												style="width: 100px; text-align: right; padding-top: 13px;">工单紧急情况:</td>
											<td><select name="IMPORTANT" id="IMPORTANT"
												style="width: 98%;">
												<option value=""></option>
												<option value="加急">加急</option>
													<option value="普通">普通</option>
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
		function change(value) {
			var url = 'meeting/getUsersBySId.do?stationId=' + value+"&isFind=true";
			$.get(url, {}, function(result) {
				var html="";
				$.each(result, function(i, user) {
					html += '<input onclick="changeBuserId(this,\''+user.userId+'\',\''+user.name+'\')" type="checkbox" id="'+user.userId+'+'+i+'" name="auserIds" value="'+user.userId+'">'+user.name+'&nbsp;'
				})
				$("#ausers").html(html);
			});
		}
		function changeBuserId(id,userId,name){
			var radio = $("#"+userId+"radio");
			if(id.checked == true&& $("#busers").children("#"+userId+"radio").length==0){
				html = '<span id="'+userId+'radio" ><input  type="radio" name="buserId" value="'+userId+'">'+name+'&nbsp;</span>'
				$("#busers").append(html);
			}
			if(id.checked == false && $("#busers").children("#"+userId+"radio").length!=0){
				radio.remove();
			}
		
				

		}
		//保存
		function save() {
			if ($("#SERVICETYPE_ID").val() == "") {
				$("#SERVICETYPE_ID").tips({
					side : 3,
					msg : '请输入服务类型',
					bg : '#AE81FF',
					time : 2
				});
				$("#SERVICETYPE_ID").focus();
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
			if ($("#USER_ID").val() == "") {
				$("#USER_ID").tips({
					side : 3,
					msg : '请输入申请人',
					bg : '#AE81FF',
					time : 2
				});
				$("#USER_ID").focus();
				return false;
			}
			if ($("#START_DATE").val() == "") {
				$("#START_DATE").tips({
					side : 3,
					msg : '请输入开始时间',
					bg : '#AE81FF',
					time : 2
				});
				$("#START_DATE").focus();
				return false;
			}
			if ($("#END_DATE").val() == "") {
				$("#END_DATE").tips({
					side : 3,
					msg : '请输入结束时间',
					bg : '#AE81FF',
					time : 2
				});
				$("#END_DATE").focus();
				return false;
			}
			if ($("#INFOR").val() == "") {
				$("#INFOR").tips({
					side : 3,
					msg : '请输入备注',
					bg : '#AE81FF',
					time : 2
				});
				$("#INFOR").focus();
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
			var isSelectBuser = false;
			var isSelectAuser = false;
			$.each($("#ausers").children(),function(i,user){
				if(user.checked == true){
					isSelectAuser = true;
				}
			});
			$.each($("#busers>span>input"),function(i,user){
				if(user.checked == true){
					isSelectBuser = true;
				}
			});
			if (!isSelectAuser) {
				$("#ausers").tips({
					side : 3,
					msg : '请选择运维人员',
					bg : '#AE81FF',
					time : 2
				});
				return false;
			}
			if (!isSelectBuser) {
				$("#busers").tips({
					side : 3,
					msg : '请选择责任人',
					bg : '#AE81FF',
					time : 2
				});
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