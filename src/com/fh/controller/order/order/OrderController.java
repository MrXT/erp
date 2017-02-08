package com.fh.controller.order.order;

import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

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
import com.fh.util.AppUtil;
import com.fh.util.JPush;
import com.fh.util.ObjectExcelView;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.util.Tools;
import com.fh.util.UuidUtil;
import com.fh.service.data.remind.RemindManager;
import com.fh.service.data.servicetype.ServiceTypeManager;
import com.fh.service.department.bs_department.BS_DepartmentManager;
import com.fh.service.department.station.StationManager;
import com.fh.service.meeting.meeting.MeetingManager;
import com.fh.service.order.order.OrderManager;
import com.fh.service.system.user.UserManager;

/**
 * 说明：工单模块 创建人：FH Q313596790 创建时间：2016-11-25
 */
@Controller
@RequestMapping(value = "/order")
public class OrderController extends BaseController {

    String menuUrl = "order/list.do"; // 菜单地址(权限用)

    @Resource(name = "orderService")
    private OrderManager orderService;

    @Resource(name = "meetingService")
    private MeetingManager meetingService;

    @Resource(name = "servicetypeService")
    private ServiceTypeManager servicetypeService;

    @Resource(name = "userService")
    private UserManager userService;

    @Autowired
    private BS_DepartmentManager departmentService;

    @Autowired
    private RemindManager remindService;

    @Autowired
    private StationManager stationService;

    /**
     * 保存
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/save")
    public ModelAndView save(String MATERIAL_NAMES, String MATERIALNAME_IDS) throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "新增Order");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "add")) {
            return null;
        } // 校验权限
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        pd.put("ORDER_ID", this.get32UUID()); // 主键
        pd.put("CTIME", Tools.date2Str(new Date())); // 创建时间
        pd.put("MATERIAL_NAMES", MATERIAL_NAMES);
        pd.put("MATERIALNAME_IDS", MATERIALNAME_IDS);
        orderService.save(pd);
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
    public void delete(PrintWriter out, Page page) throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "删除Order");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "del")) {
            return;
        } // 校验权限
        PageData pd = new PageData();
        pd = this.getPageData();
        if (pd.getString("type").equals("1")) {// 取消工单
            PageData pageDataMeeting = new PageData();
            pageDataMeeting.put("ORDER_ID", pd.getString("ORDER_ID"));
            page.setPd(pageDataMeeting);
            List<PageData> varList = orderService.list(page); // 列出Meeting列表
            PageData meetingDetail = varList.get(0);
            PageData pageData = new PageData();
            pageData.put("meetingId", pd.get("ORDER_ID"));
            List<PageData> users = meetingService.listUserByPd(pageData);
            String[] userIds = new String[users.size()];
            int i = 0;
            for (PageData pageData2 : users) {
                userIds[i] = pageData2.getString("userId");
            }
            String content = meetingDetail.getString("NAME") + "取消了运维工单服务！";
            Map<String, Object> map = new HashMap<>();
            map.put("rid", pd.getString("ORDER_ID"));
            map.put("type", "10006");// 工单通知
            map.put("content", content);
            if (userIds.length != 0 && JPush.sendMsg(userIds, JSONObject.fromObject(map).toString())) {
                for (String userId : userIds) {
                    PageData pa = new PageData();
                    pa.put("MESSAGE_ID", UuidUtil.get32UUID());
                    pa.put("CONTENT", content);
                    pa.put("RID", pd.getString("ORDER_ID"));
                    pa.put("TYPE", "10006");// 工单通知
                    pa.put("USER_ID", userId);
                    meetingService.saveMessage(pa);
                }
            }
        }
        orderService.delete(pd);
        out.write("success");
        out.close();
    }

    /**
     * 修改
     * @param
     * @throws Exception
     */
    @RequestMapping(value = "/edit")
    public ModelAndView edit(String auserIds, Page page) throws Exception {
        logBefore(logger, Jurisdiction.getUsername() + "修改Order");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "edit")) {
            return null;
        } // 校验权限
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        pd.put("distributeId", UuidUtil.get32UUID());
        pd.put("rid", pd.getString("ORDER_ID"));
        pd.put("userId", pd.getString("buserId"));
        pd.put("status", 1);// 已派单
        String[] userIds = auserIds.split(",");
        for (String userId : userIds) {
            PageData pdd = new PageData();
            pdd.put("distributeId", pd.getString("distributeId"));
            pdd.put("userId", userId);
            meetingService.saveUser(pdd);
        }
        PageData pageDataMeeting = new PageData();
        pageDataMeeting.put("ORDER_ID", pd.getString("ORDER_ID"));
        page.setPd(pageDataMeeting);
        List<PageData> varList = orderService.list(page); // 列出Meeting列表
        PageData meetingDetail = varList.get(0);
        pd.put("servicetype_id", meetingDetail.get("SERVICETYPE_ID"));
        pd.put("date", meetingDetail.get("CTIME"));
        meetingService.saveDistibute(pd);
        // SimpleDateFormat dateFormat = new
        // SimpleDateFormat("yyyy-MM-dd HH:mm");
        String important = pd.getString("IMPORTANT");
        String content = meetingDetail.getString("NAME") + "申请了工单服务，类型为" + important + ",请及时处理。联系电话" + meetingDetail.getString("PHONE");
        // XXX出现了“具体故障名称”，类型为“加急还是普通”，请及时处理。联系电话ＸＸＸＸＸＸ
        // String content = "新的会议工单请处理，会议地点：" + meetingDetail.getString("AREA")
        // + ",会议时间："
        // + dateFormat.format(meetingDetail.get("START_DATE")) + "-" +
        // dateFormat.format(meetingDetail.get("END_DATE"));
        Map<String, Object> map = new HashMap<>();
        map.put("rid", pd.getString("ORDER_ID"));
        map.put("type", "10005");
        map.put("content", content);
        if (userIds.length != 0 && JPush.sendMsg(userIds, JSONObject.fromObject(map).toString())) {
            for (String userId : userIds) {
                PageData pa = new PageData();
                pa.put("MESSAGE_ID", UuidUtil.get32UUID());
                pa.put("CONTENT", content);
                pa.put("RID", pd.getString("ORDER_ID"));
                pa.put("TYPE", "10005");// 派单通知
                pa.put("USER_ID", userId);
                meetingService.saveMessage(pa);
            }
        }
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
        logBefore(logger, Jurisdiction.getUsername() + "列表Order");
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
        List<PageData> varList = orderService.list(page); // 列出Order列表
        mv.setViewName("order/order/order_list");
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
        mv.setViewName("order/order/order_add");
        mv.addObject("servicetypes", servicetypeService.listAll(new PageData()));
        mv.addObject("departments", departmentService.listAll(new PageData()));
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
    public ModelAndView goEdit(Page page) throws Exception {
        ModelAndView mv = this.getModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        Integer method = Integer.parseInt(pd.getString("method"));
        if (method == 1) {// 派单
            PageData pageD = new PageData();
            pageD.put("DEPARTMENT_ID", "232321");// 运维部ID
            mv.addObject("stations", stationService.listAll(pageD));
            // pd = meetingService.findById(pd); // 根据ID读取
            mv.setViewName("order/order/order_distribute");
            mv.addObject("msg", "edit");
            mv.addObject("pd", pd);
            return mv;
        }
        if (method == 2) {// 查看
            page.setPd(pd);
            pd = orderService.list(page).get(0);
            PageData pageData = new PageData();
            pageData.put("meetingId", pd.get("ORDER_ID"));
            List<PageData> users = meetingService.listUserByPd(pageData);
            for (PageData pageData2 : users) {
                if (pd.getString("AUSER_ID").equals(pageData2.getString("userId"))) {
                    pd.put("AUSER", pageData2);// 责任人
                }
            }
            pd.put("BUSERS", users);// 运维人员
        }
        mv.setViewName("order/order/order_edit");
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
        logBefore(logger, Jurisdiction.getUsername() + "批量删除Order");
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
            orderService.deleteAll(ArrayDATA_IDS);
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
        logBefore(logger, Jurisdiction.getUsername() + "导出Order到excel");
        if (!Jurisdiction.buttonJurisdiction(menuUrl, "cha")) {
            return null;
        }
        ModelAndView mv = new ModelAndView();
        PageData pd = new PageData();
        pd = this.getPageData();
        Map<String, Object> dataMap = new HashMap<String, Object>();
        List<String> titles = new ArrayList<String>();
        titles.add("问题描述"); // 1
        titles.add("设备名称"); // 2
        titles.add("创建时间"); // 3
        titles.add("申请人"); // 4
        titles.add("服务类型"); // 5
        titles.add("备注8"); // 6
        dataMap.put("titles", titles);
        List<PageData> varOList = orderService.listAll(pd);
        List<PageData> varList = new ArrayList<PageData>();
        for (int i = 0; i < varOList.size(); i++) {
            PageData vpd = new PageData();
            vpd.put("var1", varOList.get(i).getString("INFOR")); // 1
            vpd.put("var2", varOList.get(i).getString("MATERIAL_NAMES")); // 2
            vpd.put("var3", varOList.get(i).getString("CTIME")); // 3
            vpd.put("var4", varOList.get(i).getString("USER_ID")); // 4
            vpd.put("var5", varOList.get(i).getString("SERVICETYPE_ID")); // 5
            vpd.put("var6", varOList.get(i).getString("MATERIALNAME_IDS")); // 6
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
