<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<%@ include file="../index/top.jsp"%>
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
							<form action="user/${msg }.do" name="userForm" id="userForm"
								method="post">
								<input type="hidden" name="USER_ID" id="user_id"
									value="${pd.USER_ID }" />
								<div id="zhongxin" style="padding-top: 13px;">
									<table id="table_report"
										class="table table-striped table-bordered table-hover">
										<tr>
											<td
												style="width: 79px; text-align: right; padding-top: 13px;">姓名:</td>
											<td><input type="text" name="NAME" id="NAME"
												readonly="readonly" value="${pd.NAME }" maxlength="32"
												placeholder="这里输入姓名" title="姓名" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 79px; text-align: right; padding-top: 13px;">手机号码:</td>
											<td><input type="text" name="PHONE" id="PHONE"
												readonly="readonly" value="${pd.PHONE }" maxlength="32"
												placeholder="这里输入姓名" title="姓名" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 79px; text-align: right; padding-top: 13px;">密码:</td>
											<td><input type="password" name="PASSWORD" id="password"
												maxlength="32" placeholder="输入密码" title="密码"
												style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 79px; text-align: right; padding-top: 13px;">确认密码:</td>
											<td><input type="password" name="chkpwd" id="chkpwd"
												maxlength="32" placeholder="确认密码" title="确认密码"
												style="width: 98%;" /></td>
										</tr>
										<c:if test="${fx != 'head'}">
											<tr>
												<td
													style="width: 79px; text-align: right; padding-top: 13px;">角色:</td>
												<td id="juese"><select
													class="form-control" name="ROLE_ID"
													id="role_id" data-placeholder="请选择角色"
													style="vertical-align: top;" style="width:98%;">
														<option value=""></option>
														<c:forEach items="${roleList}" var="role">
															<option value="${role.ROLE_ID }"
																<c:if test="${role.ROLE_ID == pd.ROLE_ID }">selected</c:if>>${role.ROLE_NAME }</option>
														</c:forEach>
												</select></td>
											</tr>
											<tr>
												<td
													style="width: 79px; text-align: right; padding-top: 13px;">部门:</td>
												<td id="juese"><select
													class="chosen-select form-control" name="DEPARTMENT_ID"
													id="role_id" data-placeholder="请选择部门"
													style="vertical-align: top;" style="width:98%;"
													onchange="change(this.value)">
														<option value=""></option>
														<c:forEach items="${departments}" var="dep">
															<c:if test="${pd.DEPARTMENT_ID == dep.BS_DEPARTMENT_ID}">
																<option value="${dep.BS_DEPARTMENT_ID}"
																	selected="selected">${dep.DEPARTMENT_NAME}</option>
															</c:if>
															<c:if test="${pd.DEPARTMENT_ID != dep.BS_DEPARTMENT_ID}">
																<option value="${dep.BS_DEPARTMENT_ID}">${dep.DEPARTMENT_NAME}</option>
															</c:if>

														</c:forEach>
												</select></td>
											</tr>
											<tr>
												<td
													style="width: 79px; text-align: right; padding-top: 13px;">岗位:</td>
												<td id="juese"><select
													class="form-control" name="STATION_ID"
													id="STATION_ID" data-placeholder="请选择岗位"
													style="vertical-align: top;" style="width:98%;">
														<option value=""></option>
														<c:forEach items="${stations}" var="dep">
															<c:if test="${pd.STATION_ID == dep.STATION_ID}">
																<option value="${dep.STATION_ID}"
																	selected="selected">${dep.STATION_NAME}</option>
															</c:if>
															<c:if test="${pd.STATION_ID != dep.STATION_ID}">
																<option value="${dep.STATION_ID }">${dep.STATION_NAME}</option>
															</c:if>

														</c:forEach>
												</select></td>
											</tr>
											<tr>
												<td
													style="width: 79px; text-align: right; padding-top: 13px;">电话薄权限:</td>
												<td id="juese"><select
													class="form-control" name="POSITION"
													id="POSITION" data-placeholder="请选择电话薄权限" 
													style="vertical-align: top;" style="width:98%;" >
														<option value="普通员工" selected="selected">普通员工</option>
														<option value="院领导">全部员工</option>
														<option value="部门领导">部门员工</option>
												</select></td>
											</tr>
											<tr>
											<td
												style="width: 79px; text-align: right; padding-top: 13px;">门牌号:</td>
											<td><input type="text" name="OFFICE_NO" id="OFFICE_NO"
												value="${pd.OFFICE_NO }" maxlength="32"
												placeholder="这里输入门牌号" title="门牌号" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 79px; text-align: right; padding-top: 13px;">座机号:</td>
											<td><input type="text" name="CPHONE" id="CPHONE"
												value="${pd.CPHONE }" maxlength="32" placeholder="这里输入座机号"
												title="邮箱" style="width: 98%;" /></td>
										</tr>
										<tr>
											<td
												style="width: 79px; text-align: right; padding-top: 13px;">个性签名:</td>
											<td><input type="text" name="SIGN" id="SIGN"
												value="${pd.SIGN }" placeholder="这里输入备注" maxlength="64"
												title="备注" style="width: 98%;" /></td>
										</tr>
										</c:if>
										<c:if test="${fx == 'head'}">
											<input name="ROLE_ID" id="role_id" value="${pd.ROLE_ID }"
												type="hidden" />
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
									<br /> <br /> <br /> <br /> <img
										src="static/images/jiazai.gif" /><br />
									<h4 class="lighter block green"></h4>
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
	<!-- basic scripts -->
	<!-- 页面底部js¨ -->
	<%@ include file="../index/foot.jsp"%>
	<!-- ace scripts -->
	<script src="static/ace/js/ace/ace.js"></script>
	<!-- inline scripts related to this page -->
	<!-- 下拉框 -->
	<script src="static/ace/js/chosen.jquery.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
</body>
<script type="text/javascript">
	$(top.hangge());
	function change(value) {
		var url = 'station/queryStationsByDId.do?departmentId=' + value;
		$.get(url, {}, function(result) {
			var html = '<option value=""></option>';
			$.each(result, function(i, user) {
				html += '<option value="'+user.STATION_ID+'">'
						+ user.STATION_NAME + '</option>'
			})
			$("#STATION_ID").html(html);
		});
	}
	$(document).ready(function(){
		if($("#user_id").val()!=""){
			$("#loginname").attr("readonly","readonly");
			$("#loginname").css("color","gray");
		}
		$("#password").val("");
	});
	//保存
	function save(){
		if($("#chkpwd").val() != $("#password").val()){
			$("#password").tips({
				side : 3,
				msg : '密码不一致',
				bg : '#AE81FF',
				time : 2
			});
			$("#password").focus();
			return false;
		}
		if($("#user_id").val()==""){
			hasU();
		}else{
			$("#userForm").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
		}
	}
	function ismail(mail){
		return(new RegExp(/^(?:[a-zA-Z0-9]+[_\-\+\.]?)*[a-zA-Z0-9]+@(?:([a-zA-Z0-9]+[_\-]?)*[a-zA-Z0-9]+\.)+([a-zA-Z]{2,})+$/).test(mail));
		}
	
	//判断用户名是否存在
	function hasU(){
		var USERNAME = $.trim($("#loginname").val());
		$.ajax({
			type: "POST",
			url: '<%=basePath%>user/hasU.do',
	    	data: {USERNAME:USERNAME,tm:new Date().getTime()},
			dataType:'json',
			cache: false,
			success: function(data){
				 if("success" == data.result){
					$("#userForm").submit();
					$("#zhongxin").hide();
					$("#zhongxin2").show();
				 }else{
					$("#loginname").css("background-color","#D16E6C");
					setTimeout("$('#loginname').val('此用户名已存在!')",500);
				 }
			}
		});
	}
	
	//判断邮箱是否存在
	function hasE(USERNAME){
		var EMAIL = $.trim($("#EMAIL").val());
		$.ajax({
			type: "POST",
			url: '<%=basePath%>user/hasE.do',
	    	data: {EMAIL:EMAIL,USERNAME:USERNAME,tm:new Date().getTime()},
			dataType:'json',
			cache: false,
			success: function(data){
				 if("success" != data.result){
					 $("#EMAIL").tips({
							side:3,
				            msg:'邮箱 '+EMAIL+' 已存在',
				            bg:'#AE81FF',
				            time:3
				        });
					 $("#EMAIL").val('');
				 }
			}
		});
	}
	
	//判断编码是否存在
	function hasN(USERNAME){
		var NUMBER = $.trim($("#NUMBER").val());
		$.ajax({
			type: "POST",
			url: '<%=basePath%>user/hasN.do',
			data : {
				NUMBER : NUMBER,
				USERNAME : USERNAME,
				tm : new Date().getTime()
			},
			dataType : 'json',
			cache : false,
			success : function(data) {
				if ("success" != data.result) {
					$("#NUMBER").tips({
						side : 3,
						msg : '编号 ' + NUMBER + ' 已存在',
						bg : '#AE81FF',
						time : 3
					});
					$("#NUMBER").val('');
				}
			}
		});
	}
	$(function() {
		//下拉框
		$("#POSITION").val('${pd.POSITION}');
		if (!ace.vars['touch']) {
			$('.chosen-select').chosen({
				allow_single_deselect : true
			});
			$(window).off('resize.chosen').on('resize.chosen', function() {
				$('.chosen-select').each(function() {
					var $this = $(this);
					$this.next().css({
						'width' : $this.parent().width()
					});
				});
			}).trigger('resize.chosen');
			$(document).on('settings.ace.chosen',
					function(e, event_name, event_val) {
						if (event_name != 'sidebar_collapsed')
							return;
						$('.chosen-select').each(function() {
							var $this = $(this);
							$this.next().css({
								'width' : $this.parent().width()
							});
						});
					});
			$('#chosen-multiple-style .btn').on('click', function(e) {
				var target = $(this).find('input[type=radio]');
				var which = parseInt(target.val());
				if (which == 2)
					$('#form-field-select-4').addClass('tag-input-style');
				else
					$('#form-field-select-4').removeClass('tag-input-style');
			});
		}
	});
</script>
</html>