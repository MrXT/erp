package com.fh.controller.app.appuser;

import java.io.File;
import java.io.FileInputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fh.controller.base.BaseController;
import com.fh.service.system.appuser.AppuserManager;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.FileUpload;
import com.fh.util.IoUtils;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;
import com.fh.util.PathUtil;
import com.fh.util.Tools;
import com.fh.util.Watermark;

/**
 * @author FH Q313596790 会员-接口类 相关参数协议： 00 请求失败 01 请求成功 02 返回空值 03 请求协议参数不完整 04
 *         用户名或密码错误 05 FKEY验证失败
 */
@Controller
@RequestMapping(value = "/appuser")
public class IntAppuserController extends BaseController {

    @Resource(name = "appuserService")
    private AppuserManager appuserService;

    /**
     * 根据用户名获取会员信息
     * @return
     */
    @RequestMapping(value = "/getAppuserByUm")
    @ResponseBody
    public Object getAppuserByUsernmae() {
        logBefore(logger, "根据用户名获取会员信息");
        Map<String, Object> map = new HashMap<String, Object>();
        PageData pd = new PageData();
        pd = this.getPageData();
        String result = "00";
        try {
            if (Tools.checkKey("USERNAME", pd.getString("FKEY"))) { // 检验请求key值是否合法
                if (AppUtil.checkParam("getAppuserByUsernmae", pd)) { // 检查参数
                    pd = appuserService.findByUsername(pd);
                    map.put("pd", pd);
                    result = (null == pd) ? "02" : "01";
                } else {
                    result = "03";
                }
            } else {
                result = "05";
            }
        } catch (Exception e) {
            logger.error(e.toString(), e);
        } finally {
            map.put("result", result);
            logAfter(logger);
        }
        return AppUtil.returnObject(new PageData(), map);
    }

    /**
     * 新增
     * @param file
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/savePic")
    @ResponseBody
    public Object save(@RequestParam(required = false,value="file") MultipartFile file) throws Exception {
        String ffile = DateUtil.getDays(), fileName = "";
        if (null != file && !file.isEmpty()) {
            String filePath = PathUtil.getPath() + Const.FILEPATHIMG + ffile; // 文件上传路径
            fileName = FileUpload.fileUp(file, filePath, this.get32UUID()); // 执行上传
        } else {
            System.out.println("上传失败");
        }
        return ffile + "/" + fileName;
    }
    /**
     * 新增
     * @param file
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveFile")
    @ResponseBody
    public Object saveFile(@RequestParam(required = false,value="file") MultipartFile file) throws Exception {
        String ffile = DateUtil.getDays(), fileName = "";
        if (null != file && !file.isEmpty()) {
            String filePath = PathUtil.getPath() + Const.FILEPATHFILE + ffile; // 文件上传路径
            fileName = FileUpload.fileUp(file, filePath, this.get32UUID()); // 执行上传
        } else {
            System.out.println("上传失败");
        }
        return ffile + "/" + fileName;
    }
    /**
     * 新增
     * @param file
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getPic")
    public void save(String path, HttpServletResponse response) throws Exception {
        String filePath = PathUtil.getPath() + Const.FILEPATHIMG + path; // 文件上传路径
        File file = new File(filePath);
        if(!file.exists()){
            file = new File(PathUtil.getPath() + Const.FILEPATHIMG +"watermark.png");
        }
        IoUtils.copyTo(new FileInputStream(file), response.getOutputStream());
        
    }
    /**
     * 新增
     * @param file
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getFile")
    public void getFile(String path, HttpServletResponse response) throws Exception {
        String filePath = PathUtil.getPath() + Const.FILEPATHFILE + path; // 文件上传路径
        File file = new File(filePath);
        if(!file.exists()){
            file = new File(PathUtil.getPath() + Const.FILEPATHIMG +"watermark.png");
        }
        response.addHeader("Content-Disposition", "attachment;filename=" + new String(file.getName().getBytes()));
        response.addHeader("Content-Length", "" + file.length());
        response.setContentType("application/octet-stream");
        IoUtils.copyTo(new FileInputStream(file), response.getOutputStream());
        
    }

}
