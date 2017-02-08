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
							<table id="simple-table"
								class="table table-striped table-bordered table-hover"
								style="margin-top: 15px;">
								<thead>
									<tr>
										<th class="center">会议名称</th>
										<th class="center">会议地址</th>
										<th class="center">开始时间</th>
										<th class="center">结束时间</th>
										<th class="center">报名人数</th>
										<th class="center">签到人数</th>
										<th class="center" style="width: 300px;">简介</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="center">${pd.meetingName}</td>
										<td class="center">${pd.area}</td>
										<td class="center">${fn:substring(pd.startDate,0,16)}</td>
										<td class="center">${fn:substring(pd.endDate,0,16)}</td>
										<td class="center" id="applyCount">${pd.applySize}</td>
										<td class="center" id="signCount">${pd.signSize}</td>
										<td class="center" >${pd.infor}</td>
									</tr>
									<tr>
										<td class="center">报名二维码</td>
										<td class="center" colspan="2" id="applyPic"></td>
										<td class="center" ></td>
										<td class="center" >签到二维码</td>
										<td class="center" colspan="2" id="signPic"></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="col-xs-6">
							<div>签到表</div>
							<table id="simple-table"
								class="table table-striped table-bordered table-hover"
								style="margin-top: 5px;">
								<thead>
									<tr>
										<th class="center" style="width: 50px;">序号</th>
										<th class="center">姓名</th>
										<th class="center">部门</th>
										<th class="center">手机</th>
										<th class="center">座机</th>
										<th class="center">签到时间</th>
									</tr>
								</thead>

								<tbody id="apply">
									<!-- 开始循环 -->
									<c:choose>
										<c:when test="${not empty pd.signs}">
											<c:forEach items="${pd.applys}" var="var" varStatus="vs">
												<tr>
													<td class='center' style="width: 30px;">${vs.index+1}</td>
													<td class='center'>${var.name}</td>
													<td class='center'>${var.departmentName}</td>
													<td class='center'>${var.phone}</td>
													<td class='center'>${var.cphone}</td>
													<td class='center'>${var.ctime}</td>
												</tr>

											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr class="main_info">
												<td colspan="100" class="center">没有相关数据</td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>
						<div class="col-xs-6">
							<div>未到表</div>
							<table id="simple-table"
								class="table table-striped table-bordered table-hover"
								style="margin-top: 5px;">
								<thead>
									<tr>
										<th class="center" style="width: 50px;">序号</th>
										<th class="center">姓名</th>
										<th class="center">部门</th>
										<th class="center">手机</th>
										<th class="center">座机</th>
									</tr>
								</thead>

								<tbody id="sign">
									<!-- 开始循环 -->
									<c:choose>
										<c:when test="${not empty pd.noSigns}">
											<c:forEach items="${pd.noSigns}" var="var" varStatus="vs">
												<tr>
													<td class='center' style="width: 30px;">${vs.index+1}</td>
													<td class='center'>${var.name}</td>
													<td class='center'>${var.departmentName}</td>
													<td class='center'>${var.phone}</td>
													<td class='center'>${var.cphone}</td>
												</tr>

											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr class="main_info">
												<td colspan="100" class="center">没有相关数据</td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
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
			var apply={
					"param":{
						"meetingId":'${pd.meetingId}',
						"type":1
					},
					"type":1
			}
			var sign={
					"param":{
						"meetingId":'${pd.meetingId}',
						"type":2
					},
					"type":2
			}
			$.get("tool/createTwoDimensionCode.do",
					{encoderContent:JSON.stringify(apply)},function(result){
						$("#applyPic").html("<img src='uploadFiles/twoDimensionCode/"+result.encoderImgId+"'>");
					});
			$.get("tool/createTwoDimensionCode.do",
					{encoderContent:JSON.stringify(sign)},function(result){
						$("#signPic").html("<img src='uploadFiles/twoDimensionCode/"+result.encoderImgId+"'>");
					});
			setInterval(function(){
				var url = "<%=basePath%>meeting/detailjson.do?meetingId="+'${pd.meetingId}';
				var htmlsign = "";
				var htmlapply = "";
				$.get(url,function(data){
					$.each(data.signs,function(i,apply){
						htmlsign+="<tr>+"
							+"<td class='center' style='width: 30px;'>"+(i+1)+"</td>"
							+"<td class='center'>"+apply.name+"</td>"
							+"<td class='center'>"+apply.departmentName+"</td>"
							+"<td class='center'>"+apply.phone+"</td>"
							+"<td class='center'>"+apply.cphone+"</td>"
							+"<td class='center'>"+apply.ctime+"</td>"
							+"</tr>"
					});
					$.each(data.noSigns,function(i,apply){
						htmlapply+="<tr>+"
							+"<td class='center' style='width: 30px;'>"+(i+1)+"</td>"
							+"<td class='center'>"+apply.name+"</td>"
							+"<td class='center'>"+apply.departmentName+"</td>"
							+"<td class='center'>"+apply.phone+"</td>"
							+"<td class='center'>"+apply.cphone+"</td>"
							+"</tr>"
					});
					$("#sign").html(htmlapply);
					$("#apply").html(htmlsign);
					$("#applyCount").html(data.applys.length);
					$("#signCount").html(data.signs.length);
				});
			},5000);
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
		function del(Id){
			bootbox.confirm("确定要删除吗?", function(result) {
				if(result) {
					top.jzts();
					var url = "<%=basePath%>meeting/delete.do?MEETING_ID="+Id+"&tm="+new Date().getTime();
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
			 diag.Title ="编辑";
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