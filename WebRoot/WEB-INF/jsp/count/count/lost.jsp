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

<!-- jsp文件头和头部 -->
<%@ include file="../../system/index/top.jsp"%>

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
							<div><h4>挂失单总数：${pd.total}</h4></div>
							<div class="center">
							<div>
								<table border="0" width="100%">
									<tr>
										<td><jsp:include
												page="../../FusionChartsHTMLRenderer.jsp" flush="true">
												<jsp:param name="chartSWF" value="static/FusionCharts/SSGrid.swf" />
												<jsp:param name="strURL" value="" />
												<jsp:param name="strXML" value="${pd.eval }" />
												<jsp:param name="chartId" value="myNext" />
												<jsp:param name="chartWidth" value="700" />
												<jsp:param name="chartHeight" value="150" />
												<jsp:param name="debugMode" value="false" />
											</jsp:include></td>
									</tr>
								</table>
							</div>
							<%-- <div style="float:right;">
								<table border="0" width="50%">
									<tr>
										<td><jsp:include
												page="../../FusionChartsHTMLRenderer.jsp" flush="true">
												<jsp:param name="chartSWF" value="static/FusionCharts/Pie2D.swf" />
												<jsp:param name="strURL" value="" />
												<jsp:param name="strXML" value="${pd.eval }" />
												<jsp:param name="chartId" value="myNext" />
												<jsp:param name="chartWidth" value="500" />
												<jsp:param name="chartHeight" value="300" />
												<jsp:param name="debugMode" value="false" />
											</jsp:include></td>
									</tr>
								</table>
							</div> --%>
						</div>
						<div>
							<form
								action="count/lost.do" method="post" name="Form" id="Form">
								<table style="margin-top: 5px;">
									<tr>
										<td>
											<div class="nav-search">
												<span class="input-icon"> <input type="text"
													placeholder="这里输入姓名" class="nav-search-input"
													id="nav-search-input" autocomplete="off" name="keywords"
													value="${pd.keywords }" placeholder="这里输入姓名" /> <i
													class="ace-icon fa fa-search nav-search-icon"></i>
												</span>
											</div>
										</td>
											<td style="vertical-align: top; padding-left: 2px"><a
												class="btn btn-light btn-xs" onclick="tosearch();"
												title="检索"><i id="nav-search-icon"
													class="ace-icon fa fa-search bigger-110 nav-search-icon blue"></i></a></td>
									</tr>
								</table>
								<!-- 检索  -->

								<table id="simple-table"
									class="table table-striped table-bordered table-hover"
									style="margin-top: 5px;">
									<thead>
										<tr>
											<th class="center" style="width: 50px;">序号</th>
											<th class="center">物资类型</th>
											<th class="center">物资名称</th>
											<th class="center">申请人</th>
											<th class="center">申请部门</th>
											<th class="center">申请理由</th>
										</tr>
									</thead>
									<tbody>
										<!-- 开始循环 -->
										<c:choose>
											<c:when test="${not empty varList}">
													<c:forEach items="${varList}" var="var" varStatus="vs">
													<tr>
															<td class='center' style="width: 30px;">${vs.index+1}</td>
															<td class='center'>${var.MATERIALTYPE_ID}</td>
															<td class='center'>${var.MATERIALNAME_ID}</td>
															<td class='center'>${var.NAME}</td>
															<td class='center'>${var.DEPARTMENT_NAME}</td>
															<td class='center'>${var.REMARK}</td>
														</tr>

													</c:forEach>
												<c:if test="${QX.cha == 0 }">
													<tr>
														<td colspan="100" class="center">您无权查看</td>
													</tr>
												</c:if>
											</c:when>
											<c:otherwise>
												<tr class="main_info">
													<td colspan="100" class="center">没有相关数据</td>
												</tr>
											</c:otherwise>
										</c:choose>
									</tbody>
								</table>
								<div class="page-header position-relative">
									<table style="width: 100%;">
										<tr>
											<td style="vertical-align: top;"><div class="pagination"
													style="float: right; padding-top: 0px; margin-top: 0px;">${page.pageStr}</div></td>
										</tr>
									</table>
								</div>
							</form>
						</div>
						</div>
						<!-- /.col -->
					</div>
					<!-- /.row -->
				</div>
				<!-- /.page-content -->
			</div>
		</div>
		<!-- /.main-content -->


		<!-- 返回顶部 -->
		<a href="#" id="btn-scroll-up"
			class="btn-scroll-up btn btn-sm btn-inverse"> <i
			class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
		</a>

	</div>
	<!-- /.main-container -->

	<!-- basic scripts -->
	<!-- jsp文件头和头部 -->
	<%@ include file="../../system/index/foot.jsp"%>
	<!-- ace scripts -->
	<script src="static/ace/js/ace/ace.js"></script>
	<!-- inline scripts related to this page -->
	<script type="text/javascript">
		$(top.hangge());//检索
		function tosearch(){
			top.jzts();
			$("#Form").submit();
		}
	</script>
	

</body>
</html>