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
							<table style="width: 100%">
								<tr align="center">
									<td><jsp:include page="../../FusionChartsHTMLRenderer.jsp"
											flush="true">
											<jsp:param name="chartSWF"
												value="static/FusionCharts/Column3D.swf" />
											<jsp:param name="strURL" value="" />
											<jsp:param name="strXML" value="${pd.eval }" />
											<jsp:param name="chartId" value="myNext" />
											<jsp:param name="chartWidth" value="600" />
											<jsp:param name="chartHeight" value="250" />
											<jsp:param name="debugMode" value="false" />
										</jsp:include></td>
								</tr>
							</table>
						</div>
						<div class="col-xs-12">
							<c:if test="${page.pd.isMoney == '1'}">
								<form action="count/money.do" method="post"
									name="Form" id="Form">
							</c:if>
							<c:if test="${page.pd.isMoney == null}">
								<form action="count/material.do" method="post"
									name="Form" id="Form">
							</c:if>
								<table style="">
								<tr>
									<td style="padding-left: 2px;line-height: 30px;">选择类型：<select
										name="status" id="status"
										data-placeholder="请选择" style="vertical-align: top;"
										style="width:88px;">
											<option <c:if test="${page.pd.status == 3 }">selected="selected"</c:if> value="3">固定资产</option>
											<c:if test="${page.pd.isMoney == null}">
												<option <c:if test="${page.pd.status == 0 }">selected="selected"</c:if> value="0">已发放</option>
												<option <c:if test="${page.pd.status == 1 }">selected="selected"</c:if> value="1">补录量</option>
												<option <c:if test="${page.pd.status == 2 }">selected="selected"</c:if> value="2">库存量</option>
											</c:if>
											<c:if test="${page.pd.isMoney == '1'}">
												<option <c:if test="${page.pd.status == 4 }">selected="selected"</c:if> value="4">报损</option>
												<option <c:if test="${page.pd.status == 5 }">selected="selected"</c:if> value="5">报废</option>
											</c:if>
											</select>
											</td>
										<td style="vertical-align: top; padding-left: 2px"><a
											class="btn btn-light btn-xs" onclick="tosearch();" title="检索"><i
												id="nav-search-icon"
												class="ace-icon fa fa-search bigger-110 nav-search-icon blue"></i></a></td>
								</tr>
							</table>
							</form>
							<table id="simple-table"
								class="table table-striped table-bordered table-hover"
								style="margin-top: 5px;">
								<thead>
									<tr>
										<th class="center" style="width: 50px;">序号</th>
										<th class="center">物资类型名</th>
										<th class="center">物资名称</th>
										<th class="center">品牌</th>
										<th class="center">型号</th>
										<th class="center">参数</th>
										<th class="center">入库时间</th>
										<th class="center">序列号</th>
										<th class="center">产品价值</th>
									</tr>
								</thead>

								<tbody>
									<!-- 开始循环 -->
									<c:choose>
										<c:when test="${not empty varList}">
												<c:forEach items="${varList}" var="var" varStatus="vs">
													<tr>
														<td class='center' style="width: 30px;">${vs.index+1}</td>
														<td class='center'>${var.material_type_name}</td>
														<td class='center'>${var.material_name}</td>
														<td class='center'>${var.brand}</td>
														<td class='center'>${var.model}</td>
														<td class='center'>${var.param}</td>
														<td class='center'>${fn:substring(var.ctime,0,10)}</td>
														<td class='center'>${var.serial_number != null?var.serial_number:"-"}</td>
														<td class='center'>${var.price}</td>
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
										<td style="vertical-align: top;"></td>
										<td style="vertical-align: top;"><div class="pagination"
												style="float: right; padding-top: 0px; margin-top: 0px;">${page.pageStr}</div></td>
									</tr>
								</table>
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
			$(top.hangge());
			function tosearch(){
				top.jzts();
				$("#Form").submit();
			}
			//新增
			function scanDetail(key){
				 top.jzts();
				 var diag = new top.Dialog();
				 diag.Drag=true;
				 diag.Title =key;
				 diag.URL = '<%=basePath%>count/scanDetail.do?key=' + key;
				diag.Width = 450;
				diag.Height = 355;
				diag.Modal = true; //有无遮罩窗口
				diag.ShowMaxButton = true; //最大化按钮
				diag.ShowMinButton = true; //最小化按钮
				diag.CancelEvent = function() { //关闭事件
					diag.close();
				};
				diag.show();
			}
		</script>
</body>
</html>