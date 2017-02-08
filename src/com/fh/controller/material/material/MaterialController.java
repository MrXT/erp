package com.fh.controller.material.material;

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
import com.fh.util.ObjectExcelView;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.util.Tools;
import com.fh.service.department.bs_department.impl.BS_DepartmentService;
import com.fh.service.material.martialrecord.MartialRecordManager;
import com.fh.service.material.material.MaterialManager;
import com.fh.service.material.materialname.MaterialNameManager;
import com.fh.service.material.materialtype.MaterialTypeManager;

/**
 * 说明：物资管理 创建人：FH Q313596790 创建时间：2016-11-17
 */
@Controller
@RequestMapping(value = "/material")
public class MaterialController extends BaseController {

    String menuUrl = "material/list.do"; // 菜单地址(权限用)

    @Resource(name = "materialService")
    private MaterialManager materialService;

    @Resource(name = "materialtypeService")
    private MaterialTypeManager materialtypeService;

    @Resource(name = "materialnameService")
    private MaterialNameManager materialnameService;

    @Resource(name = "martialrecordService")
    private MartialRecordManager martialrecordService;

    @Autowired
    private BS_DepartmentService departmentService;

    /**
     * 保存
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/save")
    public ModelAndView save() throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "新增Material");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
            return null;
        } // 校验权限
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        Integer count = pd.getString("count") != null ? Integer.parseInt(pd.getString("count")) : 0;
        for (int i = 0; i < count; i++) {
            pd.put("MATERIAL_ID", this.get32UUID()); // 主键
            materialService.save(pd);
        }
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
        logBefore(logger, Jurisdiction.getUsername() + "删除Material");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
            return;
        } // 校验权限
        PageData pd = new PageData();
        pd = this.getPageData();
        materialService.delete(pd);
        out.write("success");
        out.close();
    }

    /**
     * 删除
     * @param out
     * @throws Exception
     */
    @RequestMapping(value = "/ok")
    public void ok(PrintWriter out, HttpSession session) throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "删除Material");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
            return;
        } // 校验权限
        PageData pd = new PageData();
        pd = this.getPageData();
        pd = materialService.findById(pd);

        PageData toDepartment = martialrecordService.selectDepartmentByuserId(pd);
        PageData fromDepartent = new PageData();
        fromDepartent.put("USER_ID", ((User) session.getAttribute(Const.SESSION_USER)).getUSER_ID());
        fromDepartent = martialrecordService.selectDepartmentByuserId(fromDepartent);
        PageData pagedata = new PageData();
        pagedata.put("MATERIAL_ID", pd.getString("MATERIAL_ID"));
        pagedata.put("TO_USER_ID", pd.getString("USER_ID"));
        pagedata.put("FROM_USER_ID", ((User) session.getAttribute(Const.SESSION_USER)).getUSER_ID());
        pagedata.put("TO_DEPARTMENT_ID", toDepartment.getString("department_id"));
        pagedata.put("FROM_DEPARTMENT_ID", fromDepartent.getString("department_id"));
        pagedata.put("TYPE", 2);
        pagedata.put("CTIME", new Date());
        martialrecordService.save(pagedata);// 保存一条发放记录

        PageData param = new PageData();
        param.put("STATUS", 7);// 补录确认
        param.put("MATERIAL_ID", pd.getString("MATERIAL_ID"));
        materialService.updateStatus(param);
        out.write("success");
        out.close();
    }

    /**
     * 删除
     * @param out
     * @throws Exception
     */
    @RequestMapping(value = "/updateStatus")
    @ResponseBody
    public Object updateStatus() throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "updateStatusMaterial");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "updateStatus")) {
            return null;
        } // 校验权限
        PageData pd = new PageData();
        pd = this.getPageData();
        String DATA_IDS = pd.getString("DATA_IDS");
        if (null != DATA_IDS && !"".equals(DATA_IDS)) {
            String ArrayDATA_IDS[] = DATA_IDS.split(",");
            pd.put("ids", ArrayDATA_IDS);
        }
        return materialService.updateStatus(pd);
    }

    /**
     * 修改
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/edit")
    public ModelAndView edit() throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "修改Material");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "edit")) {
            return null;
        } // 校验权限
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        materialService.edit(pd);
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
        logBefore(logger, Jurisdiction.getUsername() + "列表Material");
        // if(!Jurisdiction.buttonJurisdiction(menuUrl, "cha")){return null;}
        // //校验权限(无权查看时页面会有提示,如果不注释掉这句代码就无法进入列表页面,所以根据情况是否加入本句代码)
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        String keywords = pd.getString("keywords"); // 关键词检索条件
        if (null != keywords && !"".equals(keywords)) {
            pd.put("keywords", keywords.trim());
        }
        if (pd.getString("status").equals("0")) {
            pd.put("STATUS", "0,5");
        } else if (pd.getString("status").equals("1")) {
            pd.put("STATUS", "1");
        } else if (pd.getString("status").equals("2")) {
            pd.put("STATUS", "2");
        } else if (pd.getString("status").equals("3")) {
            pd.put("STATUS", "3");
        } else if (pd.getString("status").equals("6")) {
            pd.put("STATUS", "6");
        }

        page.setPd(pd);
        List<PageData> varList = materialService.list(page); // 列出Material列表
        for (PageData pageData : varList) {
            if (pageData.getString("USER_ID") != null) {
                PageData param = new PageData();
                param.put("USER_ID", pageData.getString("USER_ID"));
                pageData.put("DEPARTMENT_NAME", martialrecordService.selectDepartmentByuserId(param).get("department_name"));
            }
        }
        mv.setViewName("material/material/material_list");
        mv.addObject("types", materialtypeService.listAll(new PageData()));
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
        mv.setViewName("material/material/material_edit");
        mv.addObject("types", materialtypeService.listAll(new PageData()));
        mv.addObject("departments", departmentService.listAll(new PageData()));
        mv.addObject("msg", "save");
        mv.addObject("pd", pd);
        return mv;
    }

    /**
     * 去新增页面
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/queryMaterialnameByTypeId")
    @ResponseBody
    public Object queryMaterialnameByTypeId() throws Exception {
        PageData pd = new PageData();
        pd = this.getPageData();
        return materialnameService.listAll(pd);
    }

    @RequestMapping(value = "/queryMaterialNameByUserId")
    @ResponseBody
    public Object queryMaterialNameByUserId() throws Exception {
        PageData pd = new PageData();
        pd = this.getPageData();
        return materialService.listAll(pd);
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
        pd = materialService.findById(pd); // 根据ID读取
        mv.setViewName("material/material/material_edit");
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
        logBefore(logger, Jurisdiction.getUsername() + "批量删除Material");
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
            materialService.deleteAll(ArrayDATA_IDS);
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
        logBefore(logger, Jurisdiction.getUsername() + "导出Material到excel");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "cha")) {
            return null;
        }
        ModelAndView mv = new ModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        Map<String, Object> dataMap = new HashMap<String, Object>();
        List<String> titles = new ArrayList<String>();
        titles.add("资产编号"); // 1
        titles.add("资产名称"); // 2
        titles.add("资产分类"); // 1
        titles.add("取得方式"); // 1
        titles.add("品牌"); // 3
        titles.add("资产详细名称"); // 5
        titles.add("规格型号"); // 4
        titles.add("产品序列号"); // 5
        titles.add("计量单位"); // 5
        titles.add("取得时间"); // 5
        titles.add("财务入账日期"); // 5
        titles.add("价值价格"); // 6
        titles.add("使用状况"); // 5
        titles.add("存放区域"); // 7
        titles.add("存放楼层"); // 8
        titles.add("存放房间号"); // 9
        titles.add("使用部门"); // 10
        titles.add("使用人"); // 10
        titles.add("备注一"); // 10
        titles.add("备注二"); // 10
        dataMap.put("titles", titles);
        if (pd.getString("status").equals("0")) {
            pd.put("STATUS", "0,5");
        } else if (pd.getString("status").equals("1")) {
            pd.put("STATUS", "1");
        } else if (pd.getString("status").equals("2")) {
            pd.put("STATUS", "2");
        } else if (pd.getString("status").equals("3")) {
            pd.put("STATUS", "3");
        } else if (pd.getString("status").equals("6")) {
            pd.put("STATUS", "6");
        }
        List<PageData> varOList = materialService.listAll(pd);
        List<PageData> varList = new ArrayList<PageData>();
//        PageData vpd = new PageData();
//        vpd.put("var1", "1");
//        vpd.put("var2", "2");
//        vpd.put("var3", "4");
//        vpd.put("var4", "5");
//        vpd.put("var5", "6");
//        vpd.put("var6", "7");
//        vpd.put("var7", "8");
//        vpd.put("var8", "9");
//        vpd.put("var9", "10");
//        vpd.put("var10", "11");
//        vpd.put("var11", "12");
//        vpd.put("var12", "13");
//        vpd.put("var13", "24");
//        vpd.put("var14", "");
//        vpd.put("var15", "25");
//        vpd.put("var16", "28");
//        vpd.put("var17", "29");
//        vpd.put("var18", "30");
//        vpd.put("var19", "");
//        vpd.put("var20", "");
//        varList.add(vpd);
        for (int i = 0; i < varOList.size(); i++) {
            String status = null;
            Integer statusValue = (Integer) varOList.get(i).get("STATUS");
            switch (statusValue) {
                case 0:
                    status = "（正常）没用";
                    break;
                case 1:
                    status = "没用";
                    break;
                case 2:
                    status = "没用";
                    break;
                case 3:
                    status = "没用";
                    break;
                case 5:
                    status = "（锁定）没用";
                    break;
                case 6:
                    status = "在用";
                    break;

                default:
                    break;
            }
            PageData vpd1 = new PageData();
            vpd1.put("var1", ""); // 1
            vpd1.put("var2", varOList.get(i).getString("MATERIAL_NAME")); // 2
            vpd1.put("var3", varOList.get(i).getString("MATERIAL_TYPE_NAME")); // 3
            vpd1.put("var4", statusValue==6?"补录":"入库"); // 4
            vpd1.put("var5", varOList.get(i).getString("BRAND")); // 5
            vpd1.put("var6", varOList.get(i).getString("MATERIAL_NAME")); // 6
            vpd1.put("var7", varOList.get(i).getString("PARAM")); // 10
            vpd1.put("var8", varOList.get(i).getString("serial_number")); // 7
            vpd1.put("var9", "1"); // 8
            vpd1.put("var10", new SimpleDateFormat("yyyy-MM-dd HH:mm").format(varOList.get(i).get("CTIME"))); // 9
            vpd1.put("var11", "");
            vpd1.put("var12", varOList.get(i).get("PRICE").toString());
            vpd1.put("var13", status);
            vpd1.put("var14", varOList.get(i).getString("DEPOSIT_OFFICE"));
            vpd1.put("var15", varOList.get(i).getString("DEPOSIT_FLOOR"));
            vpd1.put("var16", varOList.get(i).getString("DEPOSIT_HOUSE"));
            vpd1.put("var17", varOList.get(i).getString("DEPARTMENT_NAME"));
            vpd1.put("var18", varOList.get(i).getString("NAME"));
            vpd1.put("var19", "");
            vpd1.put("var20", "");
            varList.add(vpd1);
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
