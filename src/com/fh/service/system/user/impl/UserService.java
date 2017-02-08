package com.fh.service.system.user.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fh.dao.DaoSupport;
import com.fh.entity.Page;
import com.fh.entity.system.User;
import com.fh.service.system.user.UserManager;
import com.fh.util.DateUtil;
import com.fh.util.PageData;

/**
 * 系统用户
 * @author fh313596790qq(青苔) 修改时间：2015.11.2
 */
@Service("userService")
public class UserService implements UserManager {

    @Resource(name = "daoSupport")
    private DaoSupport dao;

    @Value("${count}")
    private Integer count;

    @Value("${days}")
    private Integer days;

    /**
     * 登录判断
     * @param pd
     * @return
     * @throws Exception
     */
    public PageData getUserByNameAndPwd(PageData pd) throws Exception {
        return (PageData) dao.findForObject("UserMapper.getUserInfo", pd);
    }

    /**
     * 更新登录时间
     * @param pd
     * @throws Exception
     */
    public void updateLastLogin(PageData pd) throws Exception {
        dao.update("UserMapper.updateLastLogin", pd);
    }

    /**
     * 通过用户ID获取用户信息和角色信息
     * @param USER_ID
     * @return
     * @throws Exception
     */
    public User getUserAndRoleById(String USER_ID) throws Exception {
        return (User) dao.findForObject("UserMapper.getUserAndRoleById", USER_ID);
    }

    /**
     * 通过USERNAEME获取数据
     * @param pd
     * @return
     * @throws Exception
     */
    public PageData findByUsername(PageData pd) throws Exception {
        return (PageData) dao.findForObject("UserMapper.findByUsername", pd);
    }

    /**
     * 列出某角色下的所有用户
     * @param pd
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<PageData> listAllUserByRoldId(PageData pd) throws Exception {
        return (List<PageData>) dao.findForList("UserMapper.listAllUserByRoldId", pd);

    }

    /**
     * 保存用户IP
     * @param pd
     * @throws Exception
     */
    public void saveIP(PageData pd) throws Exception {
        dao.update("UserMapper.saveIP", pd);
    }

    /**
     * 用户列表
     * @param page
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> listUsers(Page page) throws Exception {
        return (List<Map<String, Object>>) dao.findForList("UserMapper.userlistPage", page);
    }

    /**
     * 通过邮箱获取数据
     * @param pd
     * @return
     * @throws Exception
     */
    public PageData findByUE(PageData pd) throws Exception {
        return (PageData) dao.findForObject("UserMapper.findByUE", pd);
    }

    /**
     * 通过编号获取数据
     * @param pd
     * @return
     * @throws Exception
     */
    public PageData findByUN(PageData pd) throws Exception {
        return (PageData) dao.findForObject("UserMapper.findByUN", pd);
    }

    /**
     * 通过id获取数据
     * @param pd
     * @return
     * @throws Exception
     */
    public PageData findById(PageData pd) throws Exception {
        return (PageData) dao.findForObject("UserMapper.findById", pd);
    }

    /**
     * 保存用户
     * @param pd
     * @throws Exception
     */
    public void saveU(PageData pd) throws Exception {
        dao.save("UserMapper.saveU", pd);
    }

    /**
     * 修改用户
     * @param pd
     * @throws Exception
     */
    public void editU(PageData pd) throws Exception {
        if (pd.getString("DEPARTMENT_ID") != null || pd.getString("STATION_ID") != null) {
            dao.update("UserMapper.editUnion", pd);
        }
        if (pd.getString("NAME") != null) {
            dao.update("UserMapper.editU", pd);
        } else {
            dao.update("UserMapper.editStatusAndRole", pd);
        }
        if(!StringUtils.isBlank(pd.getString("CPHONE"))){
            PageData pageData = new PageData();
            pageData.put("USER_ID", pd.getString("USER_ID"));
            pageData.put("CPHONE", pd.getString("CPHONE"));
            dao.update("PhoneMapper.updateUserCPhone", pageData);
        }else{
            PageData pageData = new PageData();
            pageData.put("USER_ID", pd.getString("USER_ID"));
            pageData.put("STATUS", "0");
            dao.update("PhoneMapper.updateUserCPhone", pageData);
        }
    }

    /**
     * 删除用户
     * @param pd
     * @throws Exception
     */
    public void deleteU(PageData pd) throws Exception {
        dao.delete("UserMapper.deleteU", pd);
    }

    /**
     * 批量删除用户
     * @param USER_IDS
     * @throws Exception
     */
    public void deleteAllU(String[] USER_IDS) throws Exception {
        dao.delete("UserMapper.deleteAllU", USER_IDS);
    }

    /**
     * 用户列表(全部)
     * @param USER_IDS
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<PageData> listAllUser(PageData pd) throws Exception {
        return (List<PageData>) dao.findForList("UserMapper.listAllUser", pd);
    }

    /**
     * 获取总数
     * @param pd
     * @throws Exception
     */
    public PageData getUserCount(String value) throws Exception {
        return (PageData) dao.findForObject("UserMapper.getUserCount", value);
    }

    @Override
    public void editStatus(PageData pd) throws Exception {
        dao.update("UserMapper.editStatusAndRole", pd);
    }

    @SuppressWarnings("unchecked")
    @Override
    public Object listUsersBySId(PageData pd) throws Exception {
        return (List<PageData>) dao.findForList("UserMapper.listUsersBySId", pd);
    }

    @Override
    public PageData queryActiveCount() throws Exception {
        PageData result = new PageData();
        PageData allPd = this.getUserCount("");
        Integer allcount = Integer.parseInt(allPd.get("userCount").toString()) - 1;
        PageData pd = new PageData();
        Date date = new Date();
        Date tomorrow = new Date(date.getTime() + 24 * 60 * 60 * 1000);
        long time = days * 24l * 60 * 60 * 1000;
        Date oneMonthBefore = new Date(date.getTime() - time);
        time = 3*days * 24l * 60 * 60 * 1000;
        Date threeMonthBefore = new Date(date.getTime() - time);
        time = 6*days * 24l * 60 * 60 * 1000;
        Date sixMonthBefore = new Date(date.getTime() - time);
        pd.put("startDate", oneMonthBefore);
        pd.put("endDate", tomorrow);
        pd.put("count", count);
        pd = (PageData) dao.findForObject("UserMapper.queryActiveCount", pd);
        String strXML = "<graph baseFontSize='14' caption='当月活跃度' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>"
            + "<set name='活跃人数' value='" + pd.get("count") + "' color='F6BD0F'/>" + "<set name='不活跃人数' value='"
            + (allcount - Integer.parseInt(pd.get("count").toString())) + "' color='AFD8F8'/>" + "</graph>";
        result.put("oneMonth", strXML);

        pd.put("startDate", threeMonthBefore);
        pd.put("endDate", tomorrow);
        pd.put("count", count);
        pd = (PageData) dao.findForObject("UserMapper.queryActiveCount", pd);
        strXML = "<graph baseFontSize='14' caption='本季度活跃度' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>" + "<set name='活跃人数' value='"
            + pd.get("count") + "'  color='F6BD0F'/>" + "<set name='不活跃人数' value='" + (allcount - Integer.parseInt(pd.get("count").toString()))
            + "' color='AFD8F8'/>" + "</graph>";
        result.put("threeMonth", strXML);

        pd.put("startDate", sixMonthBefore);
        pd.put("endDate", tomorrow);
        pd.put("count", count);
        pd = (PageData) dao.findForObject("UserMapper.queryActiveCount", pd);
        strXML = "<graph baseFontSize='14' caption='半年活跃度' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>" + "<set name='活跃人数' value='"
            + pd.get("count") + "' color='F6BD0F'/>" + "<set name='不活跃人数' value='" + (allcount - Integer.parseInt(pd.get("count").toString()))
            + "' color='AFD8F8'/>" + "</graph>";
        result.put("sixMonth", strXML);

        pd.put("status", "1");
        //pd = (PageData) dao.findForObject("UserMapper.getUserCountByCondition", pd);
        //Integer usecounts = Integer.parseInt(pd.get("userCount").toString());
        strXML = "<graph baseFontSize='14' caption='注册统计' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>" + "<set name='激活人数' value='"
            + allPd.get("activeUserCount") + "' color='AFD8F8'/>" + "<set name='未激活人数' value='" +allPd.get("noActiveUserCount")  + "' color='FF8E46'/>" + "</graph>";
        result.put("register", strXML);

        return result;
    }
    /*@Override
    public List<PageData> queryActive(Page page) throws Exception {
        PageData result = new PageData();
        PageData allPd = this.getUserCount("");
        Integer allcount = Integer.parseInt(allPd.get("userCount").toString()) - 1;
        PageData pd = new PageData();
        Date date = new Date();
        Date tomorrow = new Date(date.getTime() + 24 * 60 * 60 * 1000);
        long time = days * 24l * 60 * 60 * 1000;
        Date oneMonthBefore = new Date(date.getTime() - time);
        time = 3*days * 24l * 60 * 60 * 1000;
        Date threeMonthBefore = new Date(date.getTime() - time);
        time = 6*days * 24l * 60 * 60 * 1000;
        Date sixMonthBefore = new Date(date.getTime() - time);
        pd.put("startDate", oneMonthBefore);
        pd.put("endDate", tomorrow);
        pd.put("count", count);
        pd = (PageData) dao.findForObject("UserMapper.queryActiveCount", pd);
        String strXML = "<graph baseFontSize='14' caption='当月活跃度' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>"
            + "<set name='活跃人数' value='" + pd.get("count") + "' color='F6BD0F'/>" + "<set name='不活跃人数' value='"
            + (allcount - Integer.parseInt(pd.get("count").toString())) + "' color='AFD8F8'/>" + "</graph>";
        result.put("oneMonth", strXML);

        pd.put("startDate", threeMonthBefore);
        pd.put("endDate", tomorrow);
        pd.put("count", count);
        pd = (PageData) dao.findForObject("UserMapper.queryActiveCount", pd);
        strXML = "<graph baseFontSize='14' caption='本季度活跃度' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>" + "<set name='活跃人数' value='"
            + pd.get("count") + "'  color='F6BD0F'/>" + "<set name='不活跃人数' value='" + (allcount - Integer.parseInt(pd.get("count").toString()))
            + "' color='AFD8F8'/>" + "</graph>";
        result.put("threeMonth", strXML);

        pd.put("startDate", sixMonthBefore);
        pd.put("endDate", tomorrow);
        pd.put("count", count);
        pd = (PageData) dao.findForObject("UserMapper.queryActiveCount", pd);
        strXML = "<graph baseFontSize='14' caption='半年活跃度' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>" + "<set name='活跃人数' value='"
            + pd.get("count") + "' color='F6BD0F'/>" + "<set name='不活跃人数' value='" + (allcount - Integer.parseInt(pd.get("count").toString()))
            + "' color='AFD8F8'/>" + "</graph>";
        result.put("sixMonth", strXML);

        pd.put("status", "1");
        pd = (PageData) dao.findForObject("UserMapper.getUserCountByCondition", pd);
        Integer usecounts = Integer.parseInt(pd.get("userCount").toString());
        strXML = "<graph baseFontSize='14' caption='注册统计' xAxisName='月份' yAxisName='值' decimalPrecision='0' formatNumberScale='0'>" + "<set name='激活人数' value='"
            + usecounts + "' color='AFD8F8'/>" + "<set name='未激活人数' value='" + (allcount - usecounts) + "' color='FF8E46'/>" + "</graph>";
        result.put("register", strXML);

        return result;
    }*/

    @SuppressWarnings("unchecked")
    @Override
    public List<PageData> queryActiveDetail(Page page) throws Exception {
        Date date = new Date();
        Date tomorrow = new Date(date.getTime() + 24 * 60 * 60 * 1000);
        Date start=null;
        if(page.getPd().getString("type").equals("1")){//当月
            long time = days * 24l * 60 * 60 * 1000;
            start  = new Date(date.getTime() - time);
        }else if(page.getPd().getString("type").equals("2")){//本季度
            long time = 3*days * 24l * 60 * 60 * 1000;
            start  = new Date(date.getTime() - time);
        }else if(page.getPd().getString("type").equals("3")){//半年
            long time = 6*days * 24l * 60 * 60 * 1000;
            start  = new Date(date.getTime() - time);
        }
        page.getPd().put("startDate", start);
        page.getPd().put("endDate", tomorrow);
        page.getPd().put("count", count);
        return (List<PageData>) dao.findForList("UserMapper.dataActivelistPage", page);
    }

}
