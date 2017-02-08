package com.fh.service.phone.phone.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fh.dao.DaoSupport;
import com.fh.entity.Page;
import com.fh.util.PageData;
import com.fh.service.phone.phone.PhoneManager;

/** 
 * 说明： 座机管理
 * 创建人：FH Q313596790
 * 创建时间：2016-11-10
 * @version
 */
@Service("phoneService")
public class PhoneService implements PhoneManager{

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/**新增
	 * @param pd
	 * @throws Exception
	 */
	public void save(PageData pd)throws Exception{
		dao.save("PhoneMapper.save", pd);
	}
	
	/**删除
	 * @param pd
	 * @throws Exception
	 */
	public void delete(PageData pd)throws Exception{
		dao.delete("PhoneMapper.delete", pd);
	}
	
	/**修改
	 * @param pd
	 * @throws Exception
	 */
	public void edit(PageData pd)throws Exception{
		dao.update("PhoneMapper.edit", pd);
	}
	
	/**列表
	 * @param page
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> list(Page page)throws Exception{
		return (List<PageData>)dao.findForList("PhoneMapper.datalistPage", page);
	}
	
	/**列表(全部)
	 * @param pd
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> listAll(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("PhoneMapper.listAll", pd);
	}
	
	/**通过id获取数据
	 * @param pd
	 * @throws Exception
	 */
	public PageData findById(PageData pd)throws Exception{
		return (PageData)dao.findForObject("PhoneMapper.findById", pd);
	}
	
	/**批量删除
	 * @param ArrayDATA_IDS
	 * @throws Exception
	 */
	public void deleteAll(String[] ArrayDATA_IDS)throws Exception{
		dao.delete("PhoneMapper.deleteAll", ArrayDATA_IDS);
	}

    @Override
    public Object listUsersByDID(String departmentId)throws Exception {
        PageData pd = new PageData();
        pd.put("departmentId", departmentId);
        return (List<PageData>)dao.findForList("PhoneMapper.listUsersByDID", pd);
    }

    @Override
    public Object deleteUser(PageData pd) throws Exception {
        dao.findForList("PhoneMapper.updateUser", pd);
        return dao.findForList("PhoneMapper.deleteUser", pd);
    }
	
}

