package com.fh.service.order.order.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import com.fh.dao.DaoSupport;
import com.fh.entity.Page;
import com.fh.util.PageData;
import com.fh.util.ValidateCodeUtil;
import com.fh.service.order.order.OrderManager;

/**
 * 说明： 工单模块 创建人：FH Q313596790 创建时间：2016-11-25
 * @version
 */
@Service("orderService")
public class OrderService implements OrderManager {

    @Resource(name = "daoSupport")
    private DaoSupport dao;

    @Value("${numHour}")
    private Integer numHour;

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    /**
     * 新增
     * @param pd
     * @throws Exception
     */
    public void save(PageData pd) throws Exception {
        dao.save("OrderMapper.save", pd);
    }

    /**
     * 删除
     * @param pd
     * @throws Exception
     */
    public void delete(PageData pd) throws Exception {
        dao.delete("OrderMapper.delete", pd);
    }

    /**
     * 修改
     * @param pd
     * @throws Exception
     */
    public void edit(PageData pd) throws Exception {
        dao.update("OrderMapper.edit", pd);
    }

    /**
     * 列表
     * @param page
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<PageData> list(Page page) throws Exception {
        List<PageData> pds = (List<PageData>) dao.findForList("OrderMapper.datalistPage", page);
        List<String> orderIds = new ArrayList<String>();
        for (PageData pageData : pds) {
            orderIds.add(pageData.getString("ORDER_ID"));
        }
        if (orderIds.size() != 0) {
            page.getPd().put("rids", orderIds);
            List<PageData> timePds = (List<PageData>) dao.findForList("OrderMapper.timePds", page.getPd());
            for (PageData pageData : pds) {
                for (PageData time : timePds) {
                    if (pageData.getString("ORDER_ID").equals(time.get("rid"))) {
                        if (time.getString("type").equals("10005")) {// 派单
                            pageData.put("distributeTime", time.get("ctime"));
                        } else if (time.getString("type").equals("10009")) {// 确认
                            pageData.put("okTime", time.get("ctime"));
                        } else if (time.getString("type").equals("10011")) {// 完成
                            pageData.put("completeTime", time.get("ctime"));
                        }
                    }
                }
            }
        }
        return pds;
    }

    /**
     * 列表(全部)
     * @param pd
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<PageData> listAll(PageData pd) throws Exception {
        return (List<PageData>) dao.findForList("OrderMapper.listAll", pd);
    }

    /**
     * 通过id获取数据
     * @param pd
     * @throws Exception
     */
    public PageData findById(PageData pd) throws Exception {
        return (PageData) dao.findForObject("OrderMapper.findById", pd);
    }

    /**
     * 批量删除
     * @param ArrayDATA_IDS
     * @throws Exception
     */
    public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
        dao.delete("OrderMapper.deleteAll", ArrayDATA_IDS);
    }

    @Override
    public PageData eval() throws Exception {
        PageData result = new PageData();
        @SuppressWarnings("unchecked")
        List<PageData> pds = (List<PageData>) dao.findForList("OrderMapper.eval", result);
        for (PageData pageData : pds) {
            result.put(pageData.get("star"), pageData.get("starnum"));
        }
        int total = 0;
        for (Object object : result.keySet()) {
            total += Integer.parseInt(result.get(object).toString());
        }
        String strXML = "<graph baseFontSize='14' caption='评价对比图' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>"
            + "<set name='1星' value='" + (result.get(1) == null ? 0 : result.get(1)) + "' color='F6BD0F'/>" + "<set name='2星' value='"
            + (result.get(2) == null ? 0 : result.get(2)) + "' color='FF8E46'/>" + "<set name='3星' value='"
            + (result.get(3) == null ? 0 : result.get(3)) + "' color='8BBA00'/>" + "<set name='4星' value='"
            + (result.get(4) == null ? 0 : result.get(4)) + "' color='A186BE'/>" + "<set name='5星' value='"
            + (result.get(5) == null ? 0 : result.get(5)) + "' color='008E8E'/>" + "</graph>";
        result.put("eval", strXML);
        result.put("total", total);
        return result;
    }

    @Override
    public PageData repair() throws Exception {
        PageData result = new PageData();
        @SuppressWarnings("unchecked")
        List<PageData> pds = (List<PageData>) dao.findForList("OrderMapper.repair", result);
        if(pds.size()==0){
            result.put("eval", "");
            result.put("total", 0);
            return result;
        }
        List<String> materialIds = new ArrayList<String>();
        for (PageData pageData : pds) {
            if (pageData.getString("materialnameIds") != null) {
                String[] ids = pageData.getString("materialnameIds").split(",");
                for (String string : ids) {
                    materialIds.add(string);
                }
            }
        }
        result.put("materialIds", materialIds);
        @SuppressWarnings("unchecked")
        List<PageData> pageDatas = (List<PageData>) dao.findForList("MaterialMapper.queryMaterialByIds", result);
        Set<String> brands = new HashSet<>();
        for (PageData pageData : pageDatas) {
            brands.add(pageData.getString("brand"));
        }
        for (PageData pageData : pageDatas) {
            for (String brand : brands) {
                if (brand.equals(pageData.getString("brand"))) {
                    result.put(brand, pageData.get("repairNum"));
                    break;
                }
            }
        }
        result.remove("materialIds");
        int total = 0;
        for (Object object : result.keySet()) {
            total += Integer.parseInt(result.get(object).toString());
        }
        Collections.sort(pageDatas, new Comparator<PageData>() {

            @Override
            public int compare(PageData o1, PageData o2) {
                return Integer.parseInt(o2.get("repairNum").toString()) - Integer.parseInt(o1.get("repairNum").toString());
            }
        });
        StringBuilder strXML = new StringBuilder(
            "<graph baseFontSize='14' caption='设备维修对比图' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>");
        int i = 0;
        for (PageData pd : pageDatas) {
            if(i>4){break;}
            strXML.append("<set name='" + pd.getString("brand") + "' value='" + pd.get("repairNum") + "' color='" + ValidateCodeUtil.createRandomCode() + "'/>");
            i++;
        }
        strXML.append("</graph>");
        result.put("eval", strXML);
        result.put("total", total);
        return result;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PageData> work(Page pagePd) throws Exception {
        PageData page = pagePd.getPd();
        if (redisTemplate.opsForValue().get("response") != null) {
            numHour = Integer.parseInt(redisTemplate.opsForValue().get("response"));
        }

        Set<String> userIds = new HashSet<String>();
        Set<String> rIds = new HashSet<String>();
        List<PageData> result = new ArrayList<PageData>();
        @SuppressWarnings("unchecked")
        List<PageData> pageDatas = (List<PageData>) dao.findForList("OrderMapper.work", page);
        for (PageData pageData : pageDatas) {
            userIds.add(pageData.getString("userId"));
        }
        page.put("userIds", userIds);
        List<PageData> alldises = null;
        if (userIds.size() != 0) {
            alldises = (List<PageData>) dao.findForList("OrderMapper.alldis", page);
        } else {
            alldises = new ArrayList<>();
        }
        Map<String, List<String>> userRidMap = new HashMap<String, List<String>>();
        for (String userId : userIds) {
            List<String> userrids = new ArrayList<String>();
            for (PageData pageData : alldises) {
                if (userId.equals(pageData.getString("userId"))) {
                    userrids.add(pageData.getString("rid"));
                }
            }
            userRidMap.put(userId, userrids);
        }
        for (PageData pageData : alldises) {
            rIds.add(pageData.getString("rid"));
        }
        page.put("rids", rIds);
        @SuppressWarnings("unchecked")
        List<PageData> time = null;
        if (rIds.size() != 0) {
            time = (List<PageData>) dao.findForList("OrderMapper.time", page);
        } else {
            time = new ArrayList<PageData>();
        }
        Set<String> rids = new HashSet<String>();
        for (PageData pageData : time) {
            rids.add(pageData.getString("rid"));
        }
        for (String userId : userIds) {
            PageData pd = new PageData();
            pd.put("userId", userId);
            for (PageData pageData : pageDatas) {
                if (pageData.getString("userId").equals(userId)) {
                    pd.put("name", pageData.getString("name"));
                    pd.put("stationName", pageData.getString("stationName"));
                    System.out.println(pageData.get("star"));
                    System.out.println(pageData.get("starNum"));
                    pd.put("star" + pageData.get("star").toString(), pageData.get("starNum"));
                }
            }
            int total = 0;
            int sum = 0;
            for (int j = 1; j <= 5; j++) {
                if (pd.get("star" + j) == null) {
                    pd.put("star" + j, 0);
                } else {
                    total += Integer.parseInt(pd.get("star" + j).toString());
                    sum += j * Integer.parseInt(pd.get("star" + j).toString());
                }
            }
            pd.put("total", total);// 已评价单子数量
            Long allTime = 0l;
            int stadandNum = 0;// 达标数量
            int completeNum = 0;// 完成单子数量
            int okNum = 0;// 确认单子数量
            for (String rid : userRidMap.get(userId)) {
                Date ditTime = null;
                Date meetingOkTime = null;// 会议确认时间
                Date meetingCompleteTime = null;// 会议完成时间
                Date orderOkTime = null;// 工单确认时间
                Date orderCompleteTime = null;// 工单完成时间
                for (PageData pageData : time) {
                    if (pageData.getString("rid").equals(rid)) {
                        if ("10005".equals(pageData.getString("type"))) {
                            ditTime = (Date) pageData.get("ctime");
                        }
                        if ("10008".equals(pageData.getString("type"))) {
                            meetingOkTime = (Date) pageData.get("ctime");
                        }
                        if ("10009".equals(pageData.getString("type"))) {
                            orderOkTime = (Date) pageData.get("ctime");
                        }
                        if ("10010".equals(pageData.getString("type"))) {
                            meetingCompleteTime = (Date) pageData.get("ctime");
                        }
                        if ("10011".equals(pageData.getString("type"))) {
                            orderCompleteTime = (Date) pageData.get("ctime");
                        }
                    }
                }
                if (meetingOkTime != null && ditTime != null) {
                    okNum++;
                    if (meetingOkTime.getTime() - ditTime.getTime() < numHour * 60 * 60 * 1000) {// 小于所规定的响应时间
                        stadandNum++;
                    }
                }
                if (orderOkTime != null && ditTime != null) {
                    okNum++;
                    if (orderOkTime.getTime() - ditTime.getTime() < numHour * 60 * 60 * 1000) {// 小于所规定的响应时间
                        stadandNum++;
                    }
                }
                if (meetingOkTime != null && meetingCompleteTime != null) {
                    allTime += (meetingCompleteTime.getTime() - meetingOkTime.getTime());
                    completeNum++;

                } else if (orderOkTime != null && orderCompleteTime != null) {
                    allTime += (orderCompleteTime.getTime() - orderOkTime.getTime());
                    completeNum++;
                }
            }
            if (completeNum != 0) {
                BigDecimal hourbd = new BigDecimal( completeNum!=0 ? (allTime * 1.0 / (completeNum * 1000 * 60)):0);
                hourbd = hourbd.setScale(2, BigDecimal.ROUND_HALF_UP);// 平均单价时长,精确到分钟
                pd.put("hourLength", hourbd);
                BigDecimal responsebd = new BigDecimal(okNum!=0 ? (stadandNum * 1.0 * 100 / okNum):0);
                responsebd = responsebd.setScale(0, BigDecimal.ROUND_HALF_UP);//
                pd.put("response", responsebd + "%");
            } else {
                pd.put("hourLength", "");
                pd.put("response", "");
            }
            BigDecimal bd = new BigDecimal(sum * 1.0 / total);
            bd = bd.setScale(2, BigDecimal.ROUND_HALF_UP);
            pd.put("avg", bd);
            result.add(pd);
        }
        Collections.sort(result, new Comparator<PageData>() {

            @Override
            public int compare(PageData o1, PageData o2) {
                return Integer.parseInt(o2.get("total").toString()) - Integer.parseInt(o1.get("total").toString());
            }
        });
        pagePd.setTotalResult(result.size());
        return result.subList(pagePd.getCurrentResult(), (pagePd.getCurrentResult()+pagePd.getShowCount() > result.size()?result.size():pagePd.getCurrentResult()+pagePd.getShowCount()));
    }

    @Override
    public List<PageData> apply(PageData page) throws Exception {
        Set<String> departmentIds = new HashSet<String>();
        Set<String> services = new HashSet<String>();
        List<PageData> result = new ArrayList<PageData>();
        @SuppressWarnings("unchecked")
        List<PageData> pageDatas = (List<PageData>) dao.findForList("OrderMapper.apply", page);
        for (PageData pageData : pageDatas) {
            departmentIds.add(pageData.getString("departmentId"));
            services.add(pageData.getString("servicetypeName"));
        }

        for (String departmentId : departmentIds) {
            PageData pd = new PageData();
            pd.put("departmentId", departmentId);
            int total = 0;
            for (PageData pageData : pageDatas) {
                if (pageData.getString("departmentId").equals(departmentId)) {
                    pd.put("departmentName", pageData.getString("departmentName"));
                    pd.put(pageData.getString("servicetypeName"), pageData.get("cnt"));
                    total += Integer.parseInt(pageData.get("cnt").toString());
                }
            }
            pd.put("total", total);
            result.add(pd);
        }
        if (StringUtils.isBlank(page.getString("departmentId"))) {
            List<PageData> other = new ArrayList<PageData>();
            @SuppressWarnings("unchecked")
            List<PageData> departments = (List<PageData>) dao.findForList("BS_DepartmentMapper.listAll", page);
            for (PageData department : departments) {
                boolean isGo = true;
                for (PageData pd : result) {
                    if (pd.getString("departmentId").equals(department.getString("BS_DEPARTMENT_ID"))) {
                        isGo = false;
                        break;
                    }
                }
                if (!isGo) {
                    continue;
                }
                department.put("departmentId", department.getString("BS_DEPARTMENT_ID"));
                department.put("departmentName", department.getString("DEPARTMENT_NAME"));
                department.put("total", 0);
                other.add(department);
            }
            result.addAll(other);
        }
        Collections.sort(result, new Comparator<PageData>() {

            @Override
            public int compare(PageData o1, PageData o2) {
                return Integer.parseInt(o2.get("total").toString()) - Integer.parseInt(o1.get("total").toString());
            }
        });
        if (result.size() > 0) {
            result.get(0).put("services", services);
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PageData> applyDetail(Page page) throws Exception {
        return (List<PageData>) dao.findForList("OrderMapper.dataAlistPage", page);
    }

    @Override
    public PageData lost() throws Exception {
        PageData result = new PageData();
        @SuppressWarnings("unchecked")
        List<PageData> pds = (List<PageData>) dao.findForList("OrderMapper.lost", result);
        int total = 0;
        StringBuilder strXML = new StringBuilder(
            "<graph baseFontSize='14' caption='挂失对比图' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>");
        int i = 0;
        for (PageData pageData : pds) {
            total += (long) pageData.get("count");
            if (i++ <= 4) {
                strXML.append("<set name='" + pageData.getString("name") + "' value='" + pageData.get("count") + "' color='"
                    + ValidateCodeUtil.createRandomCode() + "'/>");
            }
        }
        strXML.append("</graph>");
        result.put("eval", strXML);
        result.put("total", total);
        return result;
    }

    @Override
    public PageData material(PageData pd) throws Exception {
        PageData result = new PageData();
        @SuppressWarnings("unchecked")
        List<PageData> pds = (List<PageData>) dao.findForList("MaterialMapper.material", result);
        Long total = 0l;
        Long num = 0l;// 库存数
        Map<String, Object> map = new HashMap<>();
        StringBuilder strXML = null;
        if (pd.get("isMoney") == null) {
            strXML = new StringBuilder(
                "<graph baseFontSize='14' caption='物资详情图' xAxisName='分类' yAxisName='量数' decimalPrecision='0' formatNumberScale='0'>");
            for (PageData pageData : pds) {
                Integer status = (Integer) pageData.get("status");
                String msg = null;
                if (status == 0 || status == 1) {
                    total += (long) pageData.get("count");
                    num += (Long) pageData.get("count");
                }
                if (status == 4) {
                    total += (long) pageData.get("count");
                    msg = "已发放量";
                    strXML.append("<set name='" + msg + "' value='" + pageData.get("count") + "' color='" + ValidateCodeUtil.createRandomCode()
                        + "'/>");
                    map.put(msg, pageData.get("count"));
                }
                if (status == 7) {
                    total += (long) pageData.get("count");
                    msg = "补录量";
                    strXML.append("<set name='" + msg + "' value='" + pageData.get("count") + "' color='" + ValidateCodeUtil.createRandomCode()
                        + "'/>");
                    map.put(msg, pageData.get("count"));
                }
            }
            strXML.append("<set name='库存量' value='" + num + "' color='" + ValidateCodeUtil.createRandomCode() + "'/>");
            strXML.append("<set name='固定资产量' value='" + total + "' color='" + ValidateCodeUtil.createRandomCode() + "'/>");
            map.put("库存量", num);
            map.put("固定资产量", total);
            strXML.append("</graph>");
        }else{
            double total1 = 0;
            strXML = new StringBuilder(
                "<graph baseFontSize='14' caption='物资资产图' xAxisName='分类' yAxisName='单位（万）' decimalPrecision='0' formatNumberScale='0'>");
            for (PageData pageData : pds) {
                Integer status = (Integer) pageData.get("status");
                String msg = null;
                if (status == 0 || status == 1|| status == 4|| status == 7) {
                    total1 +=((BigDecimal) pageData.get("sum")).doubleValue();
                }
                if (status == 2) {
                    msg = "报损";
                    BigDecimal bd = new BigDecimal(((BigDecimal)pageData.get("sum")).doubleValue()*1.0/10000);
                    bd = bd.setScale(4, BigDecimal.ROUND_HALF_UP);
                    strXML.append("<set name='" + msg + "' value='" +  bd + "' color='" + ValidateCodeUtil.createRandomCode()
                        + "'/>");
                }
                if (status == 3) {
                    msg = "报废";
                    BigDecimal bd = new BigDecimal(((BigDecimal)pageData.get("sum")).doubleValue()*1.0/10000);
                    bd = bd.setScale(4, BigDecimal.ROUND_HALF_UP);
                    strXML.append("<set name='" + msg + "' value='" + bd + "' color='" + ValidateCodeUtil.createRandomCode()
                        + "'/>");
                }
            }
            BigDecimal bd = new BigDecimal(total1*1.0/ 10000);
            bd = bd.setScale(4, BigDecimal.ROUND_HALF_UP);
            strXML.append("<set name='固定资产' value='" + bd + "' color='" + ValidateCodeUtil.createRandomCode() + "'/>");
            strXML.append("</graph>");
        }
        result.put("eval", strXML);
        result.put("map", map);
        result.put("keys", map.keySet());
        return result;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PageData> scanDetail(PageData pd) throws Exception {
        if (pd.getString("key").equals("库存量")) {
            pd.put("type", 1);
        }
        if (pd.getString("key").equals("固定资产量")) {
            pd.put("type", 2);
        }
        if (pd.getString("key").equals("补录量")) {
            pd.put("type", 3);
        }
        if (pd.getString("key").equals("已发放量")) {
            pd.put("type", 4);
        }
        return (List<PageData>) dao.findForList("MaterialMapper.scanDetail", pd);
    }

    @SuppressWarnings("unchecked")
    @Override
    public Object search(Page page) throws Exception {
        return (List<PageData>) dao.findForList("MaterialOrderMapper.datalistPage", page);
    }

    @SuppressWarnings("unchecked")
    @Override
    public Object searchEvel(Page page) throws Exception {
        return (List<PageData>) dao.findForList("OrderMapper.data11listPage", page);
    }

    @Override
    public Object searchMaterialOrder(Page page) throws Exception {
        
        return (List<PageData>) dao.findForList("OrderMapper.data12listPage", page);
    }

    @Override
    public List<PageData> workDetail(Page page) throws Exception {
        
        return (List<PageData>) dao.findForList("OrderMapper.data13listPage", page);
    }

}
