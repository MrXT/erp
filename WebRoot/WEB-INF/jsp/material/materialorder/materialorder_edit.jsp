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
					<div class="col-xs-12" style="width:450px;height:450px;">
						<img width="100%" height="100%" src="<%=basePath%>appuser/getPic?path=${pd.pic}"/>
					</div>
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
		            msg:'请输入备注2',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#MATERIAL_ID").focus();
			return false;
			}
			if($("#MATERIALTYPE_ID").val()==""){
				$("#MATERIALTYPE_ID").tips({
					side:3,
		            msg:'请输入物资类型',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#MATERIALTYPE_ID").focus();
			return false;
			}
			if($("#APPLY_USER_ID").val()==""){
				$("#APPLY_USER_ID").tips({
					side:3,
		            msg:'请输入申请人',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#APPLY_USER_ID").focus();
			return false;
			}
			if($("#MATERIALNAME_ID").val()==""){
				$("#MATERIALNAME_ID").tips({
					side:3,
		            msg:'请输入物资名称',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#MATERIALNAME_ID").focus();
			return false;
			}
			if($("#REMARK").val()==""){
				$("#REMARK").tips({
					side:3,
		            msg:'请输入申请理由',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#REMARK").focus();
			return false;
			}
			if($("#PICURL").val()==""){
				$("#PICURL").tips({
					side:3,
		            msg:'请输入附件',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#PICURL").focus();
			return false;
			}
			if($("#UTIME").val()==""){
				$("#UTIME").tips({
					side:3,
		            msg:'请输入申请部门',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#UTIME").focus();
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