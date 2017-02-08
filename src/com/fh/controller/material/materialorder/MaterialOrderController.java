package com.fh.controller.material.materialorder;

import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.entity.Page;
import com.fh.entity.system.User;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.ObjectExcelView;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.util.Tools;
import com.fh.service.material.martialrecord.MartialRecordManager;
import com.fh.service.material.material.MaterialManager;
import com.fh.service.material.materialorder.MaterialOrderManager;

/** 
 * 说明：物资工单
 * 创建人：FH Q313596790
 * 创建时间：2016-11-19
 */
@Controller
@RequestMapping(value="/materialorder")
public class MaterialOrderController extends BaseController {
	
	String menuUrl = "materialorder/list.do"; //菜单地址(权限用)
	@Resource(name="materialorderService")
	private MaterialOrderManager materialorderService;
	@Resource(name="materialService")
    private MaterialManager materialService;
	
	@Resource(name="martialrecordService")
    private MartialRecordManager martialrecordService;
	
	/**保存
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/save")
	public ModelAndView save() throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"新增MaterialOrder");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "add")){return null;} //校验权限
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd.put("MATERIALORDER_ID", this.get32UUID());	//主键
		materialorderService.save(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**删除
	 * @param out
	 * @throws Exception
	 */
	@RequestMapping(value="/delete")
	public void delete(PrintWriter out) throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"删除MaterialOrder");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "del")){return;} //校验权限
		PageData pd = new PageData();
		pd = this.getPageData();
		materialorderService.delete(pd);
		out.write("success");
		out.close();
	}
	/**删除
     * @param out
     * @throws Exception
     */
    @RequestMapping(value="/updateStatus")
    @ResponseBody
    public Object updateStatus(HttpSession session) throws Exception{
        logBefore(logger, Jurisdiction.getUsername()+"删除MaterialOrder");
        PageData pd = new PageData();
        pd = this.getPageData();
        pd.put("HANDEL_USER_ID", ((User)session.getAttribute(Const.SESSION_USER)).getUSER_ID());
        String status = pd.getString("STATUS");
        if(status.equals("3")){
            PageData pageData = materialorderService.findById(pd);
            String type = pageData.get("TYPE").toString();
            if(type.equals("2")){//挂失
                PageData pdage = new PageData();
                pdage.put("ids", pageData.getString("MATERIAL_ID").split(","));
                pdage.put("STATUS", 2);//报损
                materialService.updateStatus(pdage);
            }
        }
        return  materialorderService.updateStatus(pd);
    }
	
	/**修改
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/edit")
	public ModelAndView edit() throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"修改MaterialOrder");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "edit")){return null;} //校验权限
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		materialorderService.edit(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**列表
	 * @param page
	 * @throws Exception
	 */
	@RequestMapping(value="/list")
	public ModelAndView list(Page page) throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"列表MaterialOrder");
		//if(!Jurisdiction.buttonJurisdiction(menuUrl, "cha")){return null;} //校验权限(无权查看时页面会有提示,如果不注释掉这句代码就无法进入列表页面,所以根据情况是否加入本句代码)
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		String keywords = pd.getString("keywords");				//关键词检索条件
		if(null != keywords && !"".equals(keywords)){
			pd.put("keywords", keywords.trim());
		}
		page.setPd(pd);
		List<PageData>	varList = materialorderService.list(page);	//列出MaterialOrder列表
		for (PageData pageData : varList) {
		    if(pageData.getString("PICURL") !=null){
		        String[] pics = pageData.getString("PICURL").split(",");
		        pageData.put("pics", pics);
		    }
		    if(pageData.getString("APPLY_USER_ID") !=null){
                PageData param = new PageData();
                param.put("USER_ID", pageData.getString("APPLY_USER_ID"));
                pageData.put("DEPARTMENT_NAME", martialrecordService.selectDepartmentByuserId(param).get("department_name"));
            }
        }
		mv.setViewName("material/materialorder/materialorder_list");
		mv.addObject("varList", varList);
		mv.addObject("pd", pd);
		mv.addObject("QX",Jurisdiction.getHC());	//按钮权限
		return mv;
	}
	
	/**去新增页面
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/goAdd")
	public ModelAndView goAdd()throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		mv.setViewName("material/materialorder/materialorder_edit");
		mv.addObject("msg", "save");
		mv.addObject("pd", pd);
		return mv;
	}	
	
	 /**去修改页面
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/goEdit")
	public ModelAndView goEdit()throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		mv.setViewName("material/materialorder/materialorder_edit");
		mv.addObject("pd", pd);
		return mv;
	}	
	
	 /**批量删除
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/deleteAll")
	@ResponseBody
	public Object deleteAll() throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"批量删除MaterialOrder");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "del")){return null;} //校验权限
		PageData pd = new PageData();		
		Map<String,Object> map = new HashMap<String,Object>();
		pd = this.getPageData();
		List<PageData> pdList = new ArrayList<PageData>();
		String DATA_IDS = pd.getString("DATA_IDS");
		if(null != DATA_IDS && !"".equals(DATA_IDS)){
			String ArrayDATA_IDS[] = DATA_IDS.split(",");
			materialorderService.deleteAll(ArrayDATA_IDS);
			pd.put("msg", "ok");
		}else{
			pd.put("msg", "no");
		}
		pdList.add(pd);
		map.put("list", pdList);
		return AppUtil.returnObject(pd, map);
	}
	
	 /**导出到excel
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/excel")
	public ModelAndView exportExcel() throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"导出MaterialOrder到excel");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "cha")){return null;}
		ModelAndView mv = new ModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		List<String> titles = new ArrayList<String>();
		titles.add("备注2");	//1
		titles.add("物资类型");	//2
		titles.add("申请人");	//3
		titles.add("物资名称");	//4
		titles.add("申请理由");	//5
		titles.add("附件");	//6
		titles.add("申请部门");	//7
		dataMap.put("titles", titles);
		List<PageData> varOList = materialorderService.listAll(pd);
		List<PageData> varList = new ArrayList<PageData>();
		for(int i=0;i<varOList.size();i++){
			PageData vpd = new PageData();
			vpd.put("var1", varOList.get(i).getString("MATERIAL_ID"));	    //1
			vpd.put("var2", varOList.get(i).getString("MATERIALTYPE_ID"));	    //2
			vpd.put("var3", varOList.get(i).getString("APPLY_USER_ID"));	    //3
			vpd.put("var4", varOList.get(i).getString("MATERIALNAME_ID"));	    //4
			vpd.put("var5", varOList.get(i).getString("REMARK"));	    //5
			vpd.put("var6", varOList.get(i).getString("PICURL"));	    //6
			vpd.put("var7", varOList.get(i).getString("UTIME"));	    //7
			varList.add(vpd);
		}
		dataMap.put("varList", varList);
		ObjectExcelView erv = new ObjectExcelView();
		mv = new ModelAndView(erv,dataMap);
		return mv;
	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder){
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(format,true));
	}
}
