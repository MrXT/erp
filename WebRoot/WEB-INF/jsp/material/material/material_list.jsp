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

							<!-- 检索  -->
							<c:if test="${pd.status ==4}">
								<form action="martialrecord/uselist.do" method="post"
									name="Form" id="Form">
							</c:if>
							<c:if test="${pd.status!=4}">
								<form action="material/list.do?status=${pd.status}"
									method="post" name="Form" id="Form">
							</c:if>
							<table style="margin-top: 5px;">
								<tr>
									<td style="vertical-align: top; padding-left: 2px;">物资类型：<select
										name="MATERIALTYPE_ID" id="MATERIALTYPE_ID"
										data-placeholder="请选择" style="vertical-align: top;"
										style="width:88px;" onchange="change(this.value)">
											<option value=""></option>
											<c:forEach items="${types}" var="dep">
												<option value="${dep.MATERIALTYPE_ID}">${dep.MATERIAL_TYPE_NAME}</option>
											</c:forEach>
									</select>&nbsp;物资名称：<select id="MATERIALNAME_ID" name="MATERIALNAME_ID"
										style="width: 88px;">
									</select> &nbsp;<c:if test="${pd.status ==0}">是否锁定：<select
												id="islock" name="islock" style="width: 88px;">
												<option></option>
												<option value="1">是</option>
												<option value="2">否</option>
											</select>
										</c:if>
									</td>
									
									<%-- <td>
											<div class="nav-search">
												<span class="input-icon"> <input type="text"
													placeholder="这里输入关键词" class="nav-search-input"
													id="nav-search-input" autocomplete="off" name="keywords"
													value="${pd.keywords }" placeholder="这里输入关键词" /> <i
													class="ace-icon fa fa-search nav-search-icon"></i>
												</span>
											</div>
										</td>
										<td style="padding-left: 2px;"><input
											class="span10 date-picker" name="lastStart" id="lastStart"
											value="" type="text" data-date-format="yyyy-mm-dd"
											readonly="readonly" style="width: 88px;" placeholder="开始日期"
											title="开始日期" /></td>
										<td style="padding-left: 2px;"><input
											class="span10 date-picker" name="lastEnd" name="lastEnd"
											value="" type="text" data-date-format="yyyy-mm-dd"
											readonly="readonly" style="width: 88px;" placeholder="结束日期"
											title="结束日期" /></td> --%>
									<c:if test="${QX.cha == 1 }">
										<td style="vertical-align: top; padding-left: 2px"><a
											class="btn btn-light btn-xs" onclick="tosearch();" title="检索"><i
												id="nav-search-icon"
												class="ace-icon fa fa-search bigger-110 nav-search-icon blue"></i></a></td>
									</c:if>
									<c:if test="${pd.status != 4}">
										<td style="vertical-align: top; padding-left: 2px;"><a
											class="btn btn-light btn-xs" onclick="toExcel();"
											title="导出到EXCEL"><i id="nav-search-icon"
												class="ace-icon fa fa-download bigger-110 nav-search-icon blue"></i></a></td>
									</c:if>
									<td width="50px"></td>
									<c:if test="${pd.status ==0 }">
									<td style="font-size: 15px;">
									锁定物品不能发放
									</td>
									</c:if>
								</tr>
							</table>
							<!-- 检索  -->

							<table id="simple-table"
								class="table table-striped table-bordered table-hover"
								style="margin-top: 5px;">
								<thead>
									<tr>
										<th class="center" style="width: 35px;"><label
											class="pos-rel"><input type="checkbox" class="ace"
												id="zcheckbox" /><span class="lbl"></span></label></th>
										<th class="center" style="width: 50px;">序号</th>
										<th class="center">物资类型名</th>
										<th class="center">物资名称</th>
										<th class="center">品牌</th>
										<th class="center">型号</th>
										<th class="center">参数</th>
										<th class="center">入库时间</th>
										<c:if test="${pd.status == 4}">
											<th class="center">取得时间</th>
										</c:if>
										<th class="center">产品价值</th>
										<th class="center">序列号</th>
										<th class="center">存放办公区</th>
										<th class="center">存放楼层</th>
										<th class="center">存放房间号</th>
										<th class="center">使用人</th>
										<th class="center">使用部门</th>
										<th class="center">备注</th>
										<th class="center" style="width: 100px;">操作</th>
									</tr>
								</thead>

								<tbody>
									<!-- 开始循环 -->
									<c:choose>
										<c:when test="${not empty varList}">
											<c:if test="${QX.cha == 1 }">
												<c:forEach items="${varList}" var="var" varStatus="vs">
													<tr>
														<td class='center'><label class="pos-rel"><input
																type='checkbox' name='ids' value="${var.material_id}"
																class="ace" /><span class="lbl"></span></label></td>
														<td class='center' style="width: 30px;">${vs.index+1}</td>
														<td class='center'>${var.material_type_name}</td>
														<td class='center'>${var.material_name}</td>
														<td class='center'>${var.brand}</td>
														<td class='center'>${var.model}</td>
														<td class='center'>${var.param}</td>
														<c:if test="${pd.status != 4}">
															<td class='center'>${fn:substring(var.ctime,0,10)}</td>
														</c:if>
														<c:if test="${pd.status == 4}">
															<td class='center'>${fn:substring(var.ctime,0,16)}</td>
															<td class='center'>${fn:substring(var.getTime,0,16)}</td>
														</c:if>
														<td class='center'>${var.price}</td>
														<td class='center'>${(var.serial_number != null && var.serial_number != "null") ?var.serial_number:"-"}</td>
														<td class='center'>${var.deposit_office}</td>
														<td class='center'>${var.deposit_floor}</td>
														<td class='center'>${var.deposit_house}</td>
														<td class='center'>${var.name !=null?var.name:"-" }</td>
														<td class='center'>${var.DEPARTMENT_NAME !=null?var.DEPARTMENT_NAME:"-" }</td>
														<td class='center'>${var.remark}</td>
														<td class="center"><c:if
																test="${QX.edit != 1 && QX.del != 1 }">
																<span
																	class="label label-large label-grey arrowed-in-right arrowed-in"><i
																	class="ace-icon fa fa-lock" title="无权限"></i></span>
															</c:if>
															<div class="btn-group">
																<c:if test="${pd.status ==0 && QX.edit == 1 }">
																	<c:if test="${var.STATUS == 0}">
																		<a class="btn btn-xs btn-danger" title="锁定"
																			onclick="update('${var.material_id}',5);"> 锁定 </a>
																	</c:if>
																	<c:if test="${var.STATUS == 5}">
																		<a class="btn btn-xs btn-success" title="解锁"
																			onclick="update('${var.material_id}',0);"> 解锁 </a>
																	</c:if>
																</c:if>
																<c:if test="${pd.status ==1}">
																	<a class="btn btn-xs btn-success" title="解锁"
																		onclick="update('${var.material_id}',2);"> 报损 </a>
																	<a class="btn btn-xs btn-success" title="解锁"
																		onclick="update('${var.material_id}',3);"> 报废 </a>
																</c:if>
																<c:if test="${pd.status ==6}">
																	<a class="btn btn-xs btn-danger" title="解锁"
																		onclick="del('${var.material_id}');"> 删除 </a>
																	<a class="btn btn-xs btn-success" title="解锁"
																		onclick="ok('${var.material_id}');"> 确认 </a>
																</c:if>
																<c:if test="${pd.status ==3}">
																	<a class="btn btn-xs btn-success" title="解锁"
																		onclick="update('${var.material_id}',2);"> 报损 </a>
																</c:if>
															</div>
															<%-- <div class="hidden-md hidden-lg">
																<div class="inline pos-rel">
																	<button
																		class="btn btn-minier btn-primary dropdown-toggle"
																		data-toggle="dropdown" data-position="auto">
																		<i class="ace-icon fa fa-cog icon-only bigger-110"></i>
																	</button>

																	<ul
																		class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
																		<c:if test="${QX.edit == 1 }">
																			<li><a style="cursor: pointer;"
																				onclick="edit('${var.MATERIAL_ID}');"
																				class="tooltip-success" data-rel="tooltip"
																				title="修改"> <span class="green"> <i
																						class="ace-icon fa fa-pencil-square-o bigger-120"></i>
																				</span>
																			</a></li>
																		</c:if>
																		<c:if test="${QX.del == 1 }">
																			<li><a style="cursor: pointer;"
																				onclick="del('${var.MATERIAL_ID}');"
																				class="tooltip-error" data-rel="tooltip" title="删除">
																					<span class="red"> <i
																						class="ace-icon fa fa-trash-o bigger-120"></i>
																				</span>
																			</a></li>
																		</c:if>
																	</ul>
																</div>
															</div> --%></td>
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
												<td colspan="100" class="center">没有相关数据</td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
							<div class="page-header position-relative">
								<table style="width: 100%;">
									<tr>
										<td style="vertical-align: top;"><c:if
												test="${QX.add == 1 && pd.status == 0 }">
												<a class="btn btn-mini btn-success" onclick="add(0);">入库</a>
											</c:if> <c:if test="${QX.add == 1 && pd.status == 6 }">
												<a class="btn btn-mini btn-success" onclick="add(6);">补录</a>
											</c:if> <c:if test="${QX.edit == 1 && pd.status==0}">
												<a class="btn btn-mini btn-danger"
													onclick="makeAll('确定要锁定选中的数据吗?',5);" title="批量删除">批量锁定</a>
												<a class="btn btn-mini btn-success"
													onclick="makeAll('确定要解锁选中的数据吗?',0);" title="批量删除">批量解锁</a>
											</c:if></td>
										<td style="vertical-align: top;"><div class="pagination"
												style="float: right; padding-top: 0px; margin-top: 0px;">${page.pageStr}</div></td>
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
		<a href="#" id="btn-scroll-up"
			class="btn-scroll-up btn btn-sm btn-inverse"> <i
			class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
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
		//保存
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
		function update(ID,type){
			if(type == 0){
				msg = "解锁";
			}
			if(type == 5){
				msg = "锁定";
			}
			if(type == 2){
				msg = "报损";
			}
			if(type == 3){
				msg = "报废";
			}
			bootbox.confirm("确定要"+msg+"吗?", function(result) {
				if(result) {
					top.jzts();
					var url = "<%=basePath%>material/updateStatus.do?MATERIAL_ID="+ID+"&STATUS="+type;
					$.get(url,function(data){
						nextPage(${page.currentPage});
					});
				}
			});
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
		function add(status){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="新增(*为必填项)";
			 diag.URL = '<%=basePath%>material/goAdd.do?status='+status;
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
		function del(Id){
			bootbox.confirm("确定要删除吗?", function(result) {
				if(result) {
					top.jzts();
					var url = "<%=basePath%>material/delete.do?MATERIAL_ID="+Id+"&tm="+new Date().getTime();
					$.get(url,function(data){
						nextPage(${page.currentPage});
					});
				}
			});
		}
		function ok(Id){
			bootbox.confirm("确定要加入物品使用记录吗?", function(result) {
				if(result) {
					top.jzts();
					var url = "<%=basePath%>material/ok.do?MATERIAL_ID="+Id+"&tm="+new Date().getTime();
					$.get(url,function(data){
						nextPage(${page.currentPage});
					});
				}
			});
		}
		
		//修改
		function edit(Id){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="编辑";
			 diag.URL = '<%=basePath%>material/goEdit.do?MATERIAL_ID='+Id;
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
		function makeAll(msg,status){
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
							top.jzts();
							$.ajax({
								type: "POST",
								url: '<%=basePath%>material/updateStatus.do',
						    	data: {DATA_IDS:str,STATUS:status},
								dataType:'json',
								//beforeSend: validateData,
								cache: false,
								success: function(data){
									nextPage(${page.currentPage});
								}
							});
					}
				}
			});
		};
		
		//导出excel
		function toExcel(){
			window.location.href='<%=basePath%>material/excel.do?status=${pd.status}';
		}
	</script>


</body>
</html>