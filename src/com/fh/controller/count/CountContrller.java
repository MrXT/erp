
package com.fh.controller.count;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fh.controller.base.BaseController;
import com.fh.entity.Page;
import com.fh.service.data.servicetype.ServiceTypeManager;
import com.fh.service.department.bs_department.BS_DepartmentManager;
import com.fh.service.department.bs_department.impl.BS_DepartmentService;
import com.fh.service.department.station.StationManager;
import com.fh.service.material.martialrecord.MartialRecordManager;
import com.fh.service.material.material.MaterialManager;
import com.fh.service.order.order.OrderManager;
import com.fh.service.system.user.UserManager;
import com.fh.util.DateUtil;
import com.fh.util.PageData;
import com.fh.util.ValidateCodeUtil;

@RequestMapping("/count")
@Controller
public class CountContrller extends BaseController{
    @Autowired
    private UserManager userService;
    @Autowired
    private OrderManager orderService;
    
    @Resource(name="materialService")
    private MaterialManager materialService;
    
    @Resource(name="martialrecordService")
    private MartialRecordManager martialrecordService;    
    @Autowired
    private StationManager stationService;
    
    @Autowired
    private ServiceTypeManager seviceTypeService;
    @Autowired
    private BS_DepartmentManager departmentService;
    
    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    
    private Integer numHour =4;
    /**
     * 注册活跃
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/register")
    public String register(ModelMap map) throws Exception{
        PageData pd = userService.queryActiveCount();
        map.addAttribute("pd", pd);
        return "count/count/register";
    }
    /**
     * 注册活跃
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/registerDetail")
    public String registerDetail(ModelMap map,Page page) throws Exception{
        page.setPd(this.getPageData());
        List<PageData> pds = userService.queryActiveDetail(page);
        map.addAttribute("userList", pds);
        map.addAttribute("pd", this.getPageData());
        map.addAttribute("page", page);
        return "count/count/register_detail";
    }
    @RequestMapping("/set")
    @ResponseBody
    public Object set(ModelMap map,String value) throws Exception{
        redisTemplate.opsForValue().set("response", value);
        return "success";
    }
    /**
     * 运维评价统计
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/eval")
    public String eval(ModelMap map,Page page) throws Exception{
        PageData pd = orderService.eval();
        map.addAttribute("pd", pd);
        PageData pageData = this.getPageData();
        if(StringUtils.isBlank(pageData.getString("star"))){
            pageData.put("star", null);
        }
        page.setPd(pageData);
        map.addAttribute("varList", orderService.searchEvel(page));
        map.addAttribute("page",page);
        return "count/count/eval";
    }
    /**
     * 设备维修统计
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/repair")
    public String repair(ModelMap map,Page page) throws Exception{
        PageData pd = orderService.repair();
        map.addAttribute("pd", pd);
        PageData pageData = this.getPageData();
        if(StringUtils.isBlank(pageData.getString("brand"))){
            pageData.put("brand", null);
        }
        page.setPd(pageData);
        map.addAttribute("varList", orderService.searchMaterialOrder(page));
        map.addAttribute("page",page);
        return "count/count/repair";
    }
    /**
     * 设备挂失统计
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/lost")
    public String lost(ModelMap map,Page page) throws Exception{
        PageData pd = orderService.lost();
        map.addAttribute("pd", pd);
        PageData pageData = this.getPageData();
        pageData.put("TYPE",2);
        page.setPd(pageData);
        map.addAttribute("varList", orderService.search(page));
        map.addAttribute("page",page);
        return "count/count/lost";
    }
    /**
     * 运维人员排名
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/work")
    public String work(ModelMap map,String name,String stationId,Page page,HttpServletRequest request) throws Exception{
        PageData pd = new PageData();
        pd.put("name", name);
        pd.put("stationId", stationId);
        String currentPage = request.getParameter("page.currentPage");
        if(currentPage != null){
            page.setCurrentPage(Integer.parseInt(currentPage));
        }
        String showCount = request.getParameter("page.showCount");
        if(showCount != null){
            page.setShowCount(Integer.parseInt(showCount));
        }
        pd.put("DEPARTMENT_ID",232321);//运维部门
        if(redisTemplate.opsForValue().get("response") != null){
            numHour = Integer.parseInt(redisTemplate.opsForValue().get("response"));
        }
        page.setPd(pd);
        List<PageData> pds = orderService.work(page);
        map.addAttribute("stations", stationService.listAll(pd));
        pd.put("hour", numHour);
        map.addAttribute("pd", pd);
        map.addAttribute("page", page);
        map.addAttribute("pds", pds);
        return "count/count/work";
    }
    @RequestMapping("/workDetail")
    public String workDetail(ModelMap map,Page page) throws Exception{
        PageData pd = this.getPageData();
        page.setPd(pd);
        List<PageData> pds = orderService.workDetail(page);
        map.addAttribute("page", page);
        map.addAttribute("pds", pds);
        return "count/count/work_detail";
    }
    /**
     * 申请次数统计
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/apply")
    public String apply(Page page,ModelMap map,String departmentId,String startDate,String endDate,HttpSession session,HttpServletRequest request) throws Exception{
        PageData pd = new PageData();
        pd.put("departmentId", departmentId);
        pd.put("startDate", startDate);
        if(StringUtils.isNotBlank(endDate)){
            pd.put("endDate", new SimpleDateFormat("yyyy-MM-dd").format(new Date(DateUtil.fomatDate(endDate).getTime()+24*60*60*1000)));
        }
        List<PageData> pds = orderService.apply(pd);
        List<PageData> departments = departmentService.listAll(new PageData());
        if(pds.size()>0){
            session.setAttribute("services", pds.get(0).get("services"));
        }else{
            if(StringUtils.isNotBlank(pd.getString("departmentId"))){
                PageData pageData = new PageData();
                for (PageData pas : departments) {
                    if(pas.getString("BS_DEPARTMENT_ID").equals(pd.getString("departmentId"))){
                        pageData.put("departmentName", pas.getString("DEPARTMENT_NAME"));
                        pageData.put("total", 0);
                        pds.add(pageData);
                        break;
                    }
                }
            }
        }
        map.addAttribute("services", session.getAttribute("services"));
        map.addAttribute("departments", departmentService.listAll(new PageData()));
        String currentPage = request.getParameter("page.currentPage");
        if(currentPage != null){
            page.setCurrentPage(Integer.parseInt(currentPage));
        }
        String showCount = request.getParameter("page.showCount");
        if(showCount != null){
            page.setShowCount(Integer.parseInt(showCount));
        }
        page.setTotalResult(pds.size());
        map.addAttribute("pds", pds.subList(page.getCurrentResult(), (page.getCurrentResult()+page.getShowCount() > pds.size()?pds.size():page.getCurrentResult()+page.getShowCount())));
        map.addAttribute("page", page);
        return "count/count/apply";
    }
    /**
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/applyShow")
    public String applyShow(ModelMap map) throws Exception{
        PageData pd = this.getPageData();
        StringBuilder strXML = new StringBuilder("<graph baseFontSize='14' caption='服务类型饼状图' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>");
            for (Object key : pd.keySet()) {
                strXML.append("<set name='"+key+"' value='"+pd.get(key)+"' color='"+ValidateCodeUtil.createRandomCode()+"'/>");
            }
            strXML.append("</graph>");
        map.put("strXML", strXML);
        return "count/count/apply_show";
    }
    /**
     * 申请次数统计
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/applyDetail")
    public String applyDetail(Page page,ModelMap map,String departmentId,String servicetypeId,String startDate,String endDate) throws Exception{
        PageData pd = new PageData();
        pd.put("departmentId", departmentId);
        pd.put("servicetypeId", servicetypeId);
        pd.put("startDate", startDate);
        if(StringUtils.isNotBlank(endDate)){
            pd.put("endDate", new SimpleDateFormat("yyyy-MM-dd").format(new Date(DateUtil.fomatDate(endDate).getTime()+24*60*60*1000)));
        }
        page.setPd(pd);
        List<PageData> pds = orderService.applyDetail(page);
        map.addAttribute("services", seviceTypeService.listAll(new PageData()));
        map.addAttribute("pds", pds);
        map.addAttribute("pd", pd);
        return "count/count/apply_detail";
    }
    /**
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/material")
    public String material(ModelMap map,Page page) throws Exception{
        PageData pd = this.getPageData();
        map.addAttribute("pd",orderService.material(pd));
        if(pd.getString("status") == null){
            pd.put("status", "3");
        }
        if(pd.getString("status").equals("0")){//已发放
            pd.put("STATUS","4");
       }else if(pd.getString("status").equals("1")){//补录量
           pd.put("STATUS","7");
       }
       else if(pd.getString("status").equals("2")){//库存量
           pd.put("STATUS","0,1");
       }
       else if(pd.getString("status").equals("3")){//固定资产
           pd.put("STATUS","0,1,4,7");
       }
        page.setPd(pd);
        List<PageData>  varList = materialService.list11(page);   //列出Material列表
        for (PageData pageData : varList) {
            if(pageData.getString("USER_ID") !=null){
                PageData param = new PageData();
                param.put("USER_ID", pageData.getString("USER_ID"));
                pageData.put("DEPARTMENT_NAME", martialrecordService.selectDepartmentByuserId(param).get("department_name"));
            }
        }
        map.addAttribute("varList", varList);
        map.addAttribute("page", page);
        return "count/count/material";
    }
    /**
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/money")
    public String money(ModelMap map,Page page) throws Exception{
        PageData pd = this.getPageData();
        pd.put("isMoney", "1");//查询资产
        map.addAttribute("pd",orderService.material(pd));
        if(pd.getString("status") == null){
            pd.put("status", "3");
        }
        if(pd.getString("status").equals("0")){//已发放
            pd.put("STATUS","4");
       }else if(pd.getString("status").equals("1")){//补录量
           pd.put("STATUS","7");
       }
       else if(pd.getString("status").equals("2")){//库存量
           pd.put("STATUS","0,1");
       }
       else if(pd.getString("status").equals("3")){//固定资产
           pd.put("STATUS","0,1,4,7");
       }
       else if(pd.getString("status").equals("4")){//报废
           pd.put("STATUS","2");
       }
       else if(pd.getString("status").equals("5")){//报废
           pd.put("STATUS","3");
       }
        page.setPd(pd);
        List<PageData>  varList = materialService.list11(page);   //列出Material列表
        for (PageData pageData : varList) {
            if(pageData.getString("USER_ID") !=null){
                PageData param = new PageData();
                param.put("USER_ID", pageData.getString("USER_ID"));
                pageData.put("DEPARTMENT_NAME", martialrecordService.selectDepartmentByuserId(param).get("department_name"));
            }
        }
        map.addAttribute("varList", varList);
        map.addAttribute("page", page);
        return "count/count/material";
    }
    /**
     * @param map
     * @return
     * @throws Exception 
     */
    @RequestMapping("/scanDetail")
    public String scanDetail(ModelMap map) throws Exception{
        PageData pd = this.getPageData();
        map.addAttribute("pds",orderService.scanDetail(pd));
        return "count/count/scanDetail";
    }
}

