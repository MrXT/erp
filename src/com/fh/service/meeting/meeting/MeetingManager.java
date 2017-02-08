package com.fh.service.meeting.meeting;

import java.util.List;

import com.fh.entity.Page;
import com.fh.util.PageData;

/** 
 * 说明： 会议管理接口
 * 创建人：FH Q313596790
 * 创建时间：2016-11-12
 * @version
 */
public interface MeetingManager{

	/**新增
	 * @param pd
	 * @throws Exception
	 */
	public void save(PageData pd)throws Exception;
	
	/**删除
	 * @param pd
	 * @throws Exception
	 */
	public void delete(PageData pd)throws Exception;
	
	/**修改
	 * @param pd
	 * @throws Exception
	 */
	public void edit(PageData pd)throws Exception;
	
	/**列表
	 * @param page
	 * @throws Exception
	 */
	public List<PageData> list(Page page)throws Exception;
	
	/**列表(全部)
	 * @param pd
	 * @throws Exception
	 */
	public List<PageData> listAll(PageData pd)throws Exception;
	
	/**通过id获取数据
	 * @param pd
	 * @throws Exception
	 */
	public PageData findById(PageData pd)throws Exception;
	
	/**批量删除
	 * @param ArrayDATA_IDS
	 * @throws Exception
	 */
	public void deleteAll(String[] ArrayDATA_IDS)throws Exception;

    public Object saveDistibute(PageData pd)throws Exception;

    public void saveUser(PageData pd)throws Exception ;

    public List<PageData> listUserByPd(PageData pageData) throws Exception ;

    public void saveMessage(PageData pa)throws Exception ;

    public PageData detail(PageData pd)throws Exception ;

    public List<PageData> signs(Page page)throws Exception ;
	
}

