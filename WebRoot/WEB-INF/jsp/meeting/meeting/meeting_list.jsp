<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
							
						<!-- 检索  -->
						<form action="meeting/list.do?STATUS=${pd.STATUS}" method="post" name="Form" id="Form">
						<table style="margin-top:5px;">
							<tr>
								<td>
									<div class="nav-search">
										<span class="input-icon">
											<input type="text" placeholder="这里输入姓名" class="nav-search-input" id="nav-search-input" autocomplete="off" name="keywords" value="${pd.keywords }" />
											<i class="ace-icon fa fa-search nav-search-icon"></i>
										</span>
									</div>
								</td>
								<td style="padding-left:2px;"><input class="span10 date-picker" name="lastStart" id="lastStart"  value="" type="text" data-date-format="yyyy-mm-dd" readonly="readonly" style="width:88px;" placeholder="日期" title="日期"/></td>
								<c:if test="${QX.cha == 1 }">
								<td style="vertical-align:top;padding-left:2px"><a class="btn btn-light btn-xs" onclick="tosearch();"  title="检索"><i id="nav-search-icon" class="ace-icon fa fa-search bigger-110 nav-search-icon blue"></i></a></td>
								</c:if>
								<c:if test="${QX.toExcel == 1 }"><td style="vertical-align:top;padding-left:2px;"><a class="btn btn-light btn-xs" onclick="toExcel();" title="导出到EXCEL"><i id="nav-search-icon" class="ace-icon fa fa-download bigger-110 nav-search-icon blue"></i></a></td></c:if>
							</tr>
						</table>
						<!-- 检索  -->
					
						<table id="simple-table" class="table table-striped table-bordered table-hover" style="margin-top:5px;">	
							<thead>
								<tr>
									<th class="center" style="width:50px;">序号</th>
									<th class="center">会议名称</th>
<!-- 									<th class="center">服务类型</th> -->
<!-- 									<th class="center">会议室</th> -->
									<th class="center" width="70px">地址</th>
									<th class="center" width="70px">申请人</th>
									<th class="center">手机</th>
<!-- 									<th class="center">座机</th> -->
<!-- 									<th class="center">部门</th> -->
									<th class="center">会议开始</th>
									<th class="center">会议结束</th>
<!-- 									<th class="center">备注</th> -->
									<th class="center">申请时间</th>
									<c:if test="${pd.STATUS == 1 || pd.STATUS == 2 || pd.STATUS == 3 ||pd.STATUS == 4 }">
										<th class="center">派单时间</th>
										<th class="center">确认时间</th>
									</c:if>
									<c:if test="${pd.STATUS == 3 ||pd.STATUS == 4 }">
										<th class="center">完成时间</th>
									</c:if>
									<c:if test="${pd.STATUS != -1}">
										<th class="center" width="150px">操作</th>
									</c:if>
								</tr>
							</thead>
													
							<tbody>
							<!-- 开始循环 -->	
							<c:choose>
								<c:when test="${not empty varList}">
									<c:if test="${QX.cha == 1 }">
									<c:forEach items="${varList}" var="var" varStatus="vs">
										<tr>
											<td class='center' style="width: 30px;">${vs.index+1}</td>
											<td class='center'>${var.MEETING_NAME}</td>
<%-- 											<td class='center'>${var.SERVICETYPE_NAME}</td> --%>
<%-- 											<td class='center'>${var.MEETINGROOM_NAME}</td> --%>
											<td class='center'>${var.AREA}</td>
											<td class='center'>${var.NAME}</td>
											<td class='center'>${var.PHONE}</td>
<%-- 											<td class='center'>${var.CPHONE}</td> --%>
<%-- 											<td class='center'>${var.DEPARTMENT_NAME}</td> --%>
											<td class='center'>${fn:substring(var.START_DATE,0,16)}</td>
											<td class='center'>${fn:substring(var.END_DATE,0,16)}</td>
											<td class='center'>${fn:substring(var.CTIME,0,16)}</td>
											<c:if test="${pd.STATUS == 1 || pd.STATUS == 2 || pd.STATUS == 3 ||pd.STATUS == 4 }">
												<td class='center'>${var.distributeTime != null?fn:substring(var.distributeTime,0,16):""}</td>
												<td class='center'>${var.okTime != null?fn:substring(var.okTime,0,16):""}</td>
											</c:if>
											<c:if test="${pd.STATUS == 3 ||pd.STATUS == 4 }">
												<td class='center'>${var.completeTime != null?fn:substring(var.completeTime,0,16):""}</td>
											</c:if>
<%-- 											<td class='center' style="width:100px;">${var.INFOR}</td> --%>
											<c:if test="${pd.STATUS != -1}">
											<td class="center">
												<c:if test="${QX.edit != 1 && QX.del != 1 }">
												<span class="label label-large label-grey arrowed-in-right arrowed-in"><i class="ace-icon fa fa-lock" title="无权限"></i></span>
												</c:if>
												<div class="btn-group">
													<c:if test="${QX.edit == 1 && pd.STATUS == 0}">
													<a class="btn btn-xs btn-success" title="派单" onclick="edit('${var.MEETING_ID}',1);">
														<i class="ace-icon fa fa-pencil-square-o bigger-120" title="派单"></i>
													</a>
													<a class="btn btn-xs btn-danger" title="删除" onclick="del('${var.MEETING_ID}',2);">
														<i class="ace-icon fa fa-trash-o bigger-120" title="删除"></i>
													</a>
													</c:if>
													<c:if test="${QX.edit == 1 && (pd.STATUS == 1 || pd.STATUS==2)}">
													<a class="btn btn-xs btn-success" title="查看" onclick="edit('${var.MEETING_ID}',2);">
														查看
													</a>
													<a class="btn btn-xs btn-success" title="取消工单" onclick="del('${var.MEETING_ID}',1);">
														取消工单
													</a>
													</c:if>
													<c:if test="${QX.edit == 1 && (pd.STATUS == 3 || pd.STATUS==4)}">
													<a class="btn btn-xs btn-success" title="查看" onclick="edit('${var.MEETING_ID}',2);">
														查看
													</a>
													<a class="btn btn-xs" ><c:if test="${var.STATUS == 3}">未评价</c:if><c:if test="${var.STATUS == 4}">已评价</c:if> 
													</a>
													</c:if>
												</div>
												<%-- <div class="hidden-md hidden-lg">
													<div class="inline pos-rel">
														<button class="btn btn-minier btn-primary dropdown-toggle" data-toggle="dropdown" data-position="auto">
															<i class="ace-icon fa fa-cog icon-only bigger-110"></i>
														</button>
			
														<ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
															<c:if test="${QX.edit == 1 && pd.STATUS == 0}">
															<li>
																	<a class="btn btn-xs btn-success" title="派单" onclick="edit('${var.MEETING_ID}',1);">
																		<i class="ace-icon fa fa-pencil-square-o bigger-120" title="派单"></i>
																	</a>
															</li>
															<li>
																<a class="btn btn-xs btn-danger" title="删除" onclick="del('${var.MEETING_ID}',2);">
																		<i class="ace-icon fa fa-trash-o bigger-120" title="删除"></i>
																	</a>
															</li>
															</c:if>
															<c:if test="${QX.edit == 1 && (pd.STATUS == 1 || pd.STATUS==2)}">
															<li>
																<a class="btn btn-xs btn-success" title="查看" onclick="edit('${var.MEETING_ID}',2);">
																	查看
																</a>
															</li>
															<li>
																<a class="btn btn-xs btn-success" title="取消工单" onclick="del('${var.MEETING_ID}',1);">
																	取消工单
																</a>
															</li>
															</c:if>
															<c:if test="${QX.edit == 1 && (pd.STATUS == 3 || pd.STATUS==4)}">
															<li>
																<a class="btn btn-xs btn-success" title="查看" onclick="edit('${var.MEETING_ID}',2);">
																	查看
																</a>
															</li>
															<li>
																<a class="btn btn-xs" ><c:if test="${var.STATUS == 3}">未评价</c:if><c:if test="${var.STATUS == 4}">已评价</c:if> 
																</a>
															</li>
															</c:if>
														</ul>
													</div>
												</div> --%>
											</td>
											</c:if>
										</tr>
									
									</c:forEach>
									</c:if>
									<c:if test="${QX.cha == 0 }">
										<tr>
											<td colspan="100" class="center">您无权查看</td>
										</tr>
									</c:if>
								</c:when>
								<c:otherwise>
									<tr class="main_info">
										<td colspan="100" class="center" >没有相关数据</td>
									</tr>
								</c:otherwise>
							</c:choose>
							</tbody>
						</table>
						<div class="page-header position-relative">
						<table style="width:100%;">
							<tr>
								<td style="vertical-align:top;">
									<c:if test="${QX.add == 1 && pd.STATUS == 0}">
									<a class="btn btn-mini btn-success" onclick="add();">新增</a>
									</c:if>
								</td>
								<td style="vertical-align:top;"><div class="pagination" style="float: right;padding-top: 0px;margin-top: 0px;">${page.pageStr}</div></td>
							</tr>
						</table>
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

		<!-- 返回顶部 -->
		<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
			<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
		</a>

	</div>
	<!-- /.main-container -->

	<!-- basic scripts -->
	<!-- 页面底部js¨ -->
	<%@ include file="../../system/index/foot.jsp"%>
	<!-- 删除时确认窗口 -->
	<script src="static/ace/js/bootbox.js"></script>
	<!-- ace scripts -->
	<script src="static/ace/js/ace/ace.js"></script>
	<!-- 下拉框 -->
	<script src="static/ace/js/chosen.jquery.js"></script>
	<!-- 日期框 -->
	<script src="static/ace/js/date-time/bootstrap-datepicker.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<script type="text/javascript">
		$(top.hangge());//关闭加载状态
		//检索
		function tosearch(){
			top.jzts();
			$("#Form").submit();
		}
		$(function() {
		
			//日期框
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true
			});
			
			//下拉框
			if(!ace.vars['touch']) {
				$('.chosen-select').chosen({allow_single_deselect:true}); 
				$(window)
				.off('resize.chosen')
				.on('resize.chosen', function() {
					$('.chosen-select').each(function() {
						 var $this = $(this);
						 $this.next().css({'width': $this.parent().width()});
					});
				}).trigger('resize.chosen');
				$(document).on('settings.ace.chosen', function(e, event_name, event_val) {
					if(event_name != 'sidebar_collapsed') return;
					$('.chosen-select').each(function() {
						 var $this = $(this);
						 $this.next().css({'width': $this.parent().width()});
					});
				});
				$('#chosen-multiple-style .btn').on('click', function(e){
					var target = $(this).find('input[type=radio]');
					var which = parseInt(target.val());
					if(which == 2) $('#form-field-select-4').addClass('tag-input-style');
					 else $('#form-field-select-4').removeClass('tag-input-style');
				});
			}
			
			
			//复选框全选控制
			var active_class = 'active';
			$('#simple-table > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
				var th_checked = this.checked;//checkbox inside "TH" table header
				$(this).closest('table').find('tbody > tr').each(function(){
					var row = this;
					if(th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
					else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
				});
			});
		});
		
		//新增
		function add(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="新增";
			 diag.URL = '<%=basePath%>meeting/goAdd.do';
			 diag.Width = 450;
			 diag.Height = 355;
			 diag.Modal = true;				//有无遮罩窗口
			 diag. ShowMaxButton = true;	//最大化按钮
		     diag.ShowMinButton = true;		//最小化按钮
			 diag.CancelEvent = function(){ //关闭事件
				 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
					 if('${page.currentPage}' == '0'){
						 top.jzts();
						 setTimeout("self.location=self.location",100);
					 }else{
						 nextPage(${page.currentPage});
					 }
				}
				diag.close();
			 };
			 diag.show();
		}
		
		//删除
		function del(Id,type){
			var msg = "";
			if(type == 1){
				msg = "确定要取消么？"
			}
			if(type == 2){
				msg = "确定要删除么？"
			}
			bootbox.confirm(msg, function(result) {
				if(result) {
					top.jzts();
					var url = "<%=basePath%>meeting/delete.do?MEETING_ID="+Id+"&tm="+new Date().getTime()+"&type="+type;
					$.get(url,function(data){
						nextPage(${page.currentPage});
					});
				}
			});
		}
		
		//修改
		function edit(Id,method){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 if(method == 1){
			 	diag.Title ="派单";
			 }else if(method == 2){
				diag.Title ="查看";
			 }
			 diag.URL = '<%=basePath%>meeting/goEdit.do?MEETING_ID='+Id+'&method='+method;
			 diag.Width = 450;
			 diag.Height = 355;
			 diag.Modal = true;				//有无遮罩窗口
			 diag. ShowMaxButton = true;	//最大化按钮
		     diag.ShowMinButton = true;		//最小化按钮 
			 diag.CancelEvent = function(){ //关闭事件
				 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
					 nextPage(${page.currentPage});
				}
				diag.close();
			 };
			 diag.show();
		}
		
		//批量操作
		function makeAll(msg){
			bootbox.confirm(msg, function(result) {
				if(result) {
					var str = '';
					for(var i=0;i < document.getElementsByName('ids').length;i++){
					  if(document.getElementsByName('ids')[i].checked){
					  	if(str=='') str += document.getElementsByName('ids')[i].value;
					  	else str += ',' + document.getElementsByName('ids')[i].value;
					  }
					}
					if(str==''){
						bootbox.dialog({
							message: "<span class='bigger-110'>您没有选择任何内容!</span>",
							buttons: 			
							{ "button":{ "label":"确定", "className":"btn-sm btn-success"}}
						});
						$("#zcheckbox").tips({
							side:1,
				            msg:'点这里全选',
				            bg:'#AE81FF',
				            time:8
				        });
						return;
					}else{
						if(msg == '确定要删除选中的数据吗?'){
							top.jzts();
							$.ajax({
								type: "POST",
								url: '<%=basePath%>meeting/deleteAll.do?tm='+new Date().getTime(),
						    	data: {DATA_IDS:str},
								dataType:'json',
								//beforeSend: validateData,
								cache: false,
								success: function(data){
									 $.each(data.list, function(i, list){
											nextPage(${page.currentPage});
									 });
								}
							});
						}
					}
				}
			});
		};
		
		//导出excel
		function toExcel(){
			window.location.href='<%=basePath%>meeting/excel.do';
		}
	</script>


</body>
</html>