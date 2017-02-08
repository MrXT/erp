package com.fh.service.meeting.meeting.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fh.dao.DaoSupport;
import com.fh.entity.Page;
import com.fh.util.PageData;
import com.fh.service.meeting.meeting.MeetingManager;

/**
 * 说明： 会议管理 创建人：FH Q313596790 创建时间：2016-11-12
 * @version
 */
@Service("meetingService")
public class MeetingService implements MeetingManager {

    @Resource(name = "daoSupport")
    private DaoSupport dao;

    /**
     * 新增
     * @param pd
     * @throws Exception
     */
    public void save(PageData pd) throws Exception {
        dao.save("MeetingMapper.save", pd);
    }

    /**
     * 删除
     * @param pd
     * @throws Exception
     */
    public void delete(PageData pd) throws Exception {
        dao.delete("MeetingMapper.delete", pd);
    }

    /**
     * 修改
     * @param pd
     * @throws Exception
     */
    public void edit(PageData pd) throws Exception {
        dao.update("MeetingMapper.edit", pd);
    }

    /**
     * 列表
     * @param page
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<PageData> list(Page page) throws Exception {
        List<PageData> pds = (List<PageData>) dao.findForList("MeetingMapper.datalistPage", page);
        List<String> orderIds = new ArrayList<String>();
        for (PageData pageData : pds) {
            orderIds.add(pageData.getString("MEETING_ID"));
        }
        if(orderIds.size() != 0){
            page.getPd().put("rids", orderIds);
            List<PageData> timePds = (List<PageData>) dao.findForList("MeetingMapper.timePds", page.getPd());
            for (PageData pageData : pds) {
                for (PageData time : timePds) {
                    if(pageData.getString("MEETING_ID").equals(time.get("rid"))){
                        if(time.getString("type").equals("10005")){//派单
                            pageData.put("distributeTime",time.get("ctime"));
                        }else if(time.getString("type").equals("10008")){//确认
                            pageData.put("okTime",time.get("ctime"));
                        }else if(time.getString("type").equals("10010")){//完成
                            pageData.put("completeTime",time.get("ctime"));
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
        return (List<PageData>) dao.findForList("MeetingMapper.listAll", pd);
    }

    /**
     * 通过id获取数据
     * @param pd
     * @throws Exception
     */
    public PageData findById(PageData pd) throws Exception {
        return (PageData) dao.findForObject("MeetingMapper.findById", pd);
    }

    /**
     * 批量删除
     * @param ArrayDATA_IDS
     * @throws Exception
     */
    public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
        dao.delete("MeetingMapper.deleteAll", ArrayDATA_IDS);
    }

    @Override
    public Object saveDistibute(PageData pd) throws Exception {
        return dao.save("MeetingMapper.saveDistibute", pd);
    }

    @Override
    public void saveUser(PageData pd) throws Exception {
        dao.save("MeetingMapper.saveUser", pd);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PageData> listUserByPd(PageData pageData) throws Exception {
        return (List<PageData>) dao.findForList("MeetingMapper.listUserByPd", pageData);
    }

    @Override
    public void saveMessage(PageData pa) throws Exception {
        dao.save("MeetingMapper.saveMessage", pa);
    }

    @Override
    public PageData detail(PageData pd) throws Exception {
        pd.put("date", new Date());
        pd = (PageData) dao.findForObject("MeetingMapper.detail", pd);
        @SuppressWarnings("unchecked")
        List<PageData> pds = (List<PageData>) dao.findForList("MeetingMapper.selectUsers", pd);
        List<PageData> pdsigns = new ArrayList<PageData>();
        List<PageData> pdapplys = new ArrayList<PageData>();
        for (PageData pageData : pds) {
            if(pageData.get("ctime") != null){
                Date ctime = (Date) pageData.get("ctime");
                pageData.put("ctime", new SimpleDateFormat("yyyy-MM-dd HH:mm").format(ctime));
            }else{
                pageData.put("ctime","");
            }
            if (pageData.get("type").toString().equals("1")) {// 报名
                pdapplys.add(pageData);
            } else if (pageData.get("type").toString().equals("2")) {// 签到
                pdsigns.add(pageData);
            }
        }
        pd.put("signs", pdsigns);
        pd.put("applys", pdapplys);
        pd.put("signSize", pdsigns.size());
        pd.put("applySize", pdapplys.size());
        List<PageData> noSigns = new ArrayList<PageData>();
        for (PageData pageData : pdapplys) {
            boolean isHave = false;
            for (PageData pageData1 : pdsigns) {
                if(pageData.getString("userId").equals(pageData1.getString("userId"))){
                    isHave = true;
                    break;
                }
            }
            if(!isHave){
                noSigns.add(pageData);
            }
            
        }
        pd.put("noSigns", noSigns);
        return pd;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PageData> signs(Page page) throws Exception {
        return (List<PageData>) dao.findForList("MeetingMapper.datasignslistPage", page);
    }

}
