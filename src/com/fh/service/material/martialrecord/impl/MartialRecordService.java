package com.fh.service.material.martialrecord.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fh.dao.DaoSupport;
import com.fh.entity.Page;
import com.fh.util.PageData;
import com.fh.service.material.martialrecord.MartialRecordManager;

/** 
 * 说明： 物资记录（交接，发放，回收）
 * 创建人：FH Q313596790
 * 创建时间：2016-11-17
 * @version
 */
@Service("martialrecordService")
public class MartialRecordService implements MartialRecordManager{

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/**新增
	 * @param pd
	 * @throws Exception
	 */
	public void save(PageData pd)throws Exception{
		dao.save("MartialRecordMapper.save", pd);
	}
	
	/**删除
	 * @param pd
	 * @throws Exception
	 */
	public void delete(PageData pd)throws Exception{
		dao.delete("MartialRecordMapper.delete", pd);
	}
	
	/**修改
	 * @param pd
	 * @throws Exception
	 */
	public void edit(PageData pd)throws Exception{
		dao.update("MartialRecordMapper.edit", pd);
	}
	
	/**列表
	 * @param page
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> list(Page page)throws Exception{
		return (List<PageData>)dao.findForList("MartialRecordMapper.datalistPage", page);
	}
	
	/**列表(全部)
	 * @param pd
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> listAll(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("MartialRecordMapper.listAll", pd);
	}
	
	/**通过id获取数据
	 * @param pd
	 * @throws Exception
	 */
	public PageData findById(PageData pd)throws Exception{
		return (PageData)dao.findForObject("MartialRecordMapper.findById", pd);
	}
	
	/**通过id获取数据
     * @param pd
     * @throws Exception
     */
    public PageData selectDepartmentByuserId(PageData pd)throws Exception{
        return (PageData)dao.findForObject("MartialRecordMapper.selectDepartmentByuserId", pd);
    }
	
	/**批量删除
	 * @param ArrayDATA_IDS
	 * @throws Exception
	 */
	public void deleteAll(String[] ArrayDATA_IDS)throws Exception{
		dao.delete("MartialRecordMapper.deleteAll", ArrayDATA_IDS);
	}

    @SuppressWarnings("unchecked")
    @Override
    public List<PageData> useList(Page page) throws Exception {
        return (List<PageData>)dao.findForList("MartialRecordMapper.dataUselistPage", page);
    }
	
}

