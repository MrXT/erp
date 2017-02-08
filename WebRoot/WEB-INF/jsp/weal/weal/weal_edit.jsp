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

							<form action="weal/${msg }.do" enctype="multipart/form-data" name="Form" id="Form"
								method="post">
								<input type="hidden" name="WEAL_ID" id="WEAL_ID"
									value="${pd.WEAL_ID}" /> <input type="hidden" name="STATUS"
									id="STATUS" />
								<div id="zhongxin" style="padding-top: 13px;">
									<table id="table_report"
										class="table table-striped table-bordered table-hover">
										<c:if test="${pd.type !=2}">
											<tr>
												<td
													style="width: 75px; text-align: right; padding-top: 13px;">标题:</td>
												<td><input
													<c:if test="${pd.type==1}">readonly="readonly"</c:if>
													type="text" name="TITLE" id="TITLE" value="${pd.TITLE}"
													maxlength="100" placeholder="这里输入标题" title="标题"
													style="width: 98%;" /></td>
											</tr>
											<tr>
												<td
													style="width: 75px; text-align: right; padding-top: 13px;">报名人数:</td>
												<td style="padding-top: 13px;">${pd.COUNT}</td>
											</tr>
											<tr>
												<td
													style="width: 75px; text-align: right; padding-top: 13px;">福利内容:</td>
												<td><textarea
														<c:if test="${pd.type==1}">readonly="readonly"</c:if>
														name="INFOR" rows="5" cols="10" style="width: 98%;">${pd.INFOR}</textarea>
												</td>
											</tr>
											<c:if test="${pd.type!=1}">
												<tr>
													<td
														style="width: 75px; text-align: right; padding-top: 13px;">图片:</td>
													<td>
														<input type="file" name="files"/><input type="file" name="files"/><input type="file" name="files"/>
													</td>
												</tr>
											</c:if>
											<c:if test="${pd.type==1}">
												<tr>
													<td colspan="2"
														style="padding-top: 13px; text-align: center;">
														 <c:forEach items="${pd.imgurls}" var="imgurl">
														 	<img width="100px" height="100px" src="uploadFiles/uploadImgs/${imgurl}">
														 </c:forEach>
														</td>
												</tr>
												<tr>
													<td colspan="2"
														style="padding-top: 13px; text-align: center;"><a
														href="<%=basePath%>/weal/scanUsers.do?wealId=${pd.WEAL_ID}"
														class="btn btn-btn-primary">查看报名情况</a></td>
												</tr>
											</c:if>
											<tr>
												<td style="text-align: center;" colspan="10"><c:if
														test="${pd.type != 1 }">
														<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
													</c:if> <a class="btn btn-mini btn-danger"
													onclick="top.Dialog.close();">取消</a></td>
											</tr>
										</c:if>
										<c:if test="${pd.type ==2 }">
											<tr>
												<td style="text-align: center;" colspan="10"><a
													class="btn btn-mini btn-primary" onclick="save(1);">通过</a>
													<a class="btn btn-mini btn-danger" onclick="save(-1);">拒绝</a></td>
											</tr>
										</c:if>
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
		function save(status) {
			if ($("#INFOR").val() == "") {
				$("#INFOR").tips({
					side : 3,
					msg : '请输入福利内容',
					bg : '#AE81FF',
					time : 2
				});
				$("#INFOR").focus();
				return false;
			}
			if ($("#CTIME").val() == "") {
				$("#CTIME").tips({
					side : 3,
					msg : '请输入发布时间',
					bg : '#AE81FF',
					time : 2
				});
				$("#CTIME").focus();
				return false;
			}
			if ($("#TITLE").val() == "") {
				$("#TITLE").tips({
					side : 3,
					msg : '请输入标题',
					bg : '#AE81FF',
					time : 2
				});
				$("#TITLE").focus();
				return false;
			}
			$("#STATUS").val(status);
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