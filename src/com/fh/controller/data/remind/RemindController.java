package com.fh.controller.data.remind;

import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.entity.Page;
import com.fh.entity.system.Menu;
import com.fh.util.AppUtil;
import com.fh.util.ObjectExcelView;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.util.RightsHelper;
import com.fh.util.Tools;
import com.fh.service.data.remind.RemindManager;
import com.fh.service.system.menu.MenuManager;
import com.fh.service.system.user.UserManager;

/**
 * 说明：提醒处理（注册提醒，会议提醒，工单提醒） 创建人：FH Q313596790 创建时间：2016-11-09
 */
@Controller
@RequestMapping(value = "/remind")
public class RemindController extends BaseController {

    String menuUrl = "remind/list.do"; // 菜单地址(权限用)

    @Resource(name = "remindService")
    private RemindManager remindService;

    @Resource(name = "menuService")
    private MenuManager menuService;

    @Resource(name = "userService")
    private UserManager userService;

    /**
     * 保存
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/save")
    public ModelAndView save() throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "新增Remind");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
            return null;
        } // 校验权限
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        pd.put("REMIND_ID", this.get32UUID()); // 主键
        remindService.save(pd);
        mv.addObject("msg", "success");
        mv.setViewName("save_result");
        return mv;
    }
    /**
     * 保存检验
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/check")
    @ResponseBody
    public Object check() throws Exception {
        PageData pd = new PageData();
        pd = this.getPageData();
        List<PageData> pds = remindService.selectName(pd);
        return pds != null && pds.size()>0 ?0:1;
    }

    /**
     * 删除
     * @param out
     * @throws Exception
     */
    @RequestMapping(value = "/delete")
    public void delete(PrintWriter out) throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "删除Remind");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
            return;
        } // 校验权限
        PageData pd = new PageData();
        pd = this.getPageData();
        remindService.delete(pd);
        out.write("success");
        out.close();
    }

    /**
     * 修改
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/edit")
    public ModelAndView edit() throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "修改Remind");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "edit")) {
            return null;
        } // 校验权限
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        remindService.edit(pd);
        mv.addObject("msg", "success");
        mv.setViewName("save_result");
        return mv;
    }

    /**
     * 列表
     * @param page
     * @throws Exception
     */
    @RequestMapping(value = "/list")
    public ModelAndView list(Page page) throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "列表Remind");
        // if(!Jurisdiction.buttonJurisdiction(menuUrl, "cha")){return null;}
        // //校验权限(无权查看时页面会有提示,如果不注释掉这句代码就无法进入列表页面,所以根据情况是否加入本句代码)
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        String keywords = pd.getString("keywords"); // 关键词检索条件
        if (null != keywords && !"".equals(keywords)) {
            pd.put("keywords", keywords.trim());
        }
        page.setPd(pd);
        List<PageData> varList = remindService.list(page); // 列出Remind列表
        mv.setViewName("data/remind/remind_list");
        mv.addObject("varList", varList);
        mv.addObject("pd", pd);
        mv.addObject("QX", Jurisdiction.getHC()); // 按钮权限
        return mv;
    }

    /**
     * 去新增页面
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/goAdd")
    public ModelAndView goAdd() throws Exception {
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        PageData data = new PageData();
        List<PageData> userList = userService.listAllUser(new PageData());
        int menuId = 0;
        switch (pd.getString("type")) {
            case "10001":// 注册提醒
                  menuId = 41;
//                data.put("MENU_ID", 41);// 系统用户菜单ID
//                data = menuService.getMenuById(data); // 获取所有菜单
                break;
            case "10002":// 工单提醒
                menuId = 578;
//                data.put("MENU_ID", 41);// 工单管理菜单ID
//                data = menuService.getMenuById(data); // 获取所有菜单
                break;
            case "10003":// 会议提醒
                menuId = 256;
//                data.put("MENU_ID", 41);// 会议管理菜单ID
//                data = menuService.getMenuById(data); // 获取所有菜单
                break;
            default:
                break;
        }
        List<PageData> users = new ArrayList<PageData>();
        for (PageData pageData : userList) {
            String roleRights = data!=null ? (String)pageData.get("RIGHTS") : ""; 
            if(Tools.notEmpty(roleRights) && RightsHelper.testRights(roleRights, menuId)){
                users.add(pageData);
            }
        }
        mv.addObject("users", users);
        mv.setViewName("data/remind/remind_edit");
        mv.addObject("msg", "save");
        mv.addObject("pd", pd);
        return mv;
    }

    /**
     * 去修改页面
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/goEdit")
    public ModelAndView goEdit() throws Exception {
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        pd = remindService.findById(pd); // 根据ID读取
        List<PageData> userList = userService.listAllUser(new PageData());
        PageData data = new PageData();
        int menuId = 0;
        switch (pd.getString("type")) {
            case "10001":// 注册提醒
                  menuId = 41;
//                data.put("MENU_ID", 41);// 系统用户菜单ID
//                data = menuService.getMenuById(data); // 获取所有菜单
                break;
            case "10002":// 工单提醒
                menuId = 578;
//                data.put("MENU_ID", 41);// 工单管理菜单ID
//                data = menuService.getMenuById(data); // 获取所有菜单
                break;
            case "10003":// 会议提醒
                menuId = 256;
//                data.put("MENU_ID", 41);// 会议管理菜单ID
//                data = menuService.getMenuById(data); // 获取所有菜单
                break;
            default:
                break;
        }
        List<PageData> users = new ArrayList<PageData>();
        for (PageData pageData : userList) {
            String roleRights = data!=null ? (String)pageData.get("RIGHTS") : ""; 
            if(Tools.notEmpty(roleRights) && RightsHelper.testRights(roleRights, menuId)){
                users.add(pageData);
            }
        }
        mv.addObject("users", users);
        mv.setViewName("data/remind/remind_edit");
        mv.addObject("msg", "edit");
        mv.addObject("pd", pd);
        return mv;
    }

    /**
     * 批量删除
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/deleteAll")
    @ResponseBody
    public Object deleteAll() throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "批量删除Remind");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
            return null;
        } // 校验权限
        PageData pd = new PageData();
        Map<String, Object> map = new HashMap<String, Object>();
        pd = this.getPageData();
        List<PageData> pdList = new ArrayList<PageData>();
        String DATA_IDS = pd.getString("DATA_IDS");
        if (null != DATA_IDS && !"".equals(DATA_IDS)) {
            String ArrayDATA_IDS[] = DATA_IDS.split(",");
            remindService.deleteAll(ArrayDATA_IDS);
            pd.put("msg", "ok");
        } else {
            pd.put("msg", "no");
        }
        pdList.add(pd);
        map.put("list", pdList);
        return AppUtil.returnObject(pd, map);
    }

    /**
     * 导出到excel
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/excel")
    public ModelAndView exportExcel() throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "导出Remind到excel");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "cha")) {
            return null;
        }
        ModelAndView mv = new ModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        Map<String, Object> dataMap = new HashMap<String, Object>();
        List<String> titles = new ArrayList<String>();
        titles.add("备注2"); // 1
        titles.add("备注3"); // 2
        dataMap.put("titles", titles);
        List<PageData> varOList = remindService.listAll(pd);
        List<PageData> varList = new ArrayList<PageData>();
        for (int i = 0; i < varOList.size(); i++) {
            PageData vpd = new PageData();
            vpd.put("var1", varOList.get(i).getString("TYPE")); // 1
            vpd.put("var2", varOList.get(i).getString("USER_ID")); // 2
            varList.add(vpd);
        }
        dataMap.put("varList", varList);
        ObjectExcelView erv = new ObjectExcelView();
        mv = new ModelAndView(erv, dataMap);
        return mv;
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        binder.registerCustomEditor(Date.class, new CustomDateEditor(format, true));
    }
}
