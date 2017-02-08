package com.fh.controller.account.account;

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

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.fh.util.DateUtil;
import com.fh.util.ObjectExcelView;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.service.account.account.AccountManager;
import com.fh.service.account.record.RecordManager;
import com.fh.service.department.bs_department.impl.BS_DepartmentService;

/**
 * 说明：account 创建人：FH Q313596790 创建时间：2016-12-01
 */
@Controller
@RequestMapping(value = "/account")
public class AccountController extends BaseController {

    String menuUrl = "account/list.do"; // 菜单地址(权限用)

    @Resource(name = "accountService")
    private AccountManager accountService;

    @Autowired
    private BS_DepartmentService departmentService;
    
    @Autowired
    private RecordManager recordService;

    /**
     * 保存
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/save")
    public ModelAndView save() throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "新增Account");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
            return null;
        } // 校验权限
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        pd.put("ACCOUNT_ID", this.get32UUID()); // 主键
        accountService.save(pd);
        mv.addObject("msg", "success");
        mv.setViewName("save_result");
        return mv;
    }

    /**
     * 删除
     * @param out
     * @throws Exception
     */
    @RequestMapping(value = "/delete")
    public void delete(PrintWriter out) throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "删除Account");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
            return;
        } // 校验权限
        PageData pd = new PageData();
        pd = this.getPageData();
        accountService.delete(pd);
        out.write("success");
        out.close();
    }

    /**
     * 修改
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/edit")
    public ModelAndView edit(HttpSession session) throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "修改Account");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "edit")) {
            return null;
        } // 校验权限
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        Integer money = Integer.parseInt(pd.getString("MONEY"));
        User user = (User) session.getAttribute(Const.SESSION_USER);
        String status = pd.getString("STATUS");
        pd = accountService.findById(pd); // 根据ID读取
        Double balance = Double.parseDouble(pd.get("balance").toString());//余额
        Double rechange = Double.parseDouble(pd.get("rechange").toString());//总共充值
        PageData pageData = new PageData();
        pageData.put("RECORD_USER_ID", pd.getString("USER_ID"));
        pageData.put("HANDLE_USER_ID", user.getUSER_ID());
        pageData.put("MONEY", money);
        if (status != null) {
            pageData.put("TYPE", Integer.parseInt(status));
            if (status.equals("1")) {// 退费
                balance -= money;
                rechange -= money;
                pageData.put("MESSAGE", "成功退费"+money+"元！");
            } else if (status.equals("2")) {// 充值
                balance += money;
                rechange += money;
                pageData.put("MESSAGE", "成功充值"+money+"元！");
            }
        }
        pd.put("BALANCE", balance);
        pd.put("RECHANGE", rechange);
        accountService.edit(pd);
        recordService.save(pageData);
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
        logBefore(logger, Jurisdiction.getUsername() + "列表Account");
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
        List<PageData> varList = accountService.list(page); // 列出Account列表
        mv.setViewName("account/account/account_list");
        mv.addObject("varList", varList);
        mv.addObject("departments", departmentService.listAll(new PageData()));
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
        mv.setViewName("account/account/account_edit");
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
        String status = pd.getString("STATUS");
        pd = accountService.findById(pd); // 根据ID读取
        pd.put("STATUS", status);
        mv.setViewName("account/account/account_edit");
        mv.addObject("msg", "edit");
        mv.addObject("pd", pd);
        return mv;
    }
    /**
     * 去变更用餐消费
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/goSet")
    public ModelAndView goSet() throws Exception {
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        List<PageData> varList = accountService.findAllSet(pd);
        mv.setViewName("account/account/account_set");
        mv.addObject("varList", varList);
        mv.addObject("pd", pd);
        mv.addObject("QX", Jurisdiction.getHC()); // 按钮权限
        return mv;
    }
    
    /**
     * 去变更用餐消费
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/goAddSet")
    public ModelAndView goAddSet() throws Exception {
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        if(StringUtils.isNotBlank(pd.getString("comsumeTimeslotId"))){
            pd = accountService.findAllSet(pd).get(0);
        }
        mv.setViewName("account/account/account_set_edit");
        mv.addObject("msg", "saveSet");
        mv.addObject("pd", pd);
        return mv;
    }
    
    @RequestMapping(value = "/saveSet")
    public ModelAndView saveSet() throws Exception {
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        if(StringUtils.isNotBlank(pd.getString("comsumeTimeslotId"))){
            PageData res = accountService.findAllSet(pd).get(0);
            res.put("startDate", DateUtil.fomatHmDate(pd.get("startDate").toString()));
            res.put("endDate", DateUtil.fomatHmDate(pd.get("endDate").toString()));
            res.put("firstMoney", pd.get("firstMoney"));
            res.put("secondMoney", pd.get("secondMoney"));
            accountService.editSet(res);
        }else{
            PageData res = new PageData();
            res.put("comsumeTimeslotId", this.get32UUID()); // 主键
            res.put("startDate", DateUtil.fomatHmDate(pd.get("startDate").toString()));
            res.put("endDate", DateUtil.fomatHmDate(pd.get("endDate").toString()));
            res.put("firstMoney", pd.get("firstMoney"));
            res.put("secondMoney", pd.get("secondMoney"));
            accountService.saveSet(res);
        }
        mv.addObject("msg", "success");
        mv.setViewName("save_result");
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
        logBefore(logger, Jurisdiction.getUsername() + "批量删除Account");
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
            accountService.deleteAll(ArrayDATA_IDS);
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
        logBefore(logger, Jurisdiction.getUsername() + "导出Account到excel");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "cha")) {
            return null;
        }
        ModelAndView mv = new ModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        Map<String, Object> dataMap = new HashMap<String, Object>();
        List<String> titles = new ArrayList<String>();
        titles.add("姓名"); // 1
        titles.add("余额"); // 2
        dataMap.put("titles", titles);
        List<PageData> varOList = accountService.listAll(pd);
        List<PageData> varList = new ArrayList<PageData>();
        for (int i = 0; i < varOList.size(); i++) {
            PageData vpd = new PageData();
            vpd.put("var1", varOList.get(i).getString("USER_ID")); // 1
            vpd.put("var2", varOList.get(i).get("BALANCE").toString()); // 2
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
