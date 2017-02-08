
package com.fh.controller.data.area;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@RequestMapping("area")
@Controller
public class AreaController {
    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    @RequestMapping("/save")
    @ResponseBody
    public Object save(String areaName){
        Gson gson = new Gson();  
        List<String> areas = gson.fromJson(redisTemplate.opsForValue().get("areas"), new TypeToken<List<String>>(){}.getType());  
        if(areas == null){
            areas = new ArrayList<String>();
        }
        areas.add(areaName);
        redisTemplate.opsForValue().set("areas",gson.toJson(areas));
        return "success";
    }
    @RequestMapping("/goAdd")
    public String goAdd(ModelMap map){
        return "data/area/area_edit";
    }
    @RequestMapping("/search")
    public String search(String areaName,ModelMap map){
        Gson gson = new Gson();  
        List<String> areas = gson.fromJson(redisTemplate.opsForValue().get("areas"), new TypeToken<List<String>>(){}.getType());  
        map.put("areas", areas);
        return "data/area/area_list";
    }
    @RequestMapping("/delete")
    @ResponseBody
    public Object delete(String areaName){
        Gson gson = new Gson();  
        List<String> areas = gson.fromJson(redisTemplate.opsForValue().get("areas"), new TypeToken<List<String>>(){}.getType());  
        if(areas == null){
            areas = new ArrayList<String>();
        }
        areas.remove(areaName);
        redisTemplate.opsForValue().set("areas",gson.toJson(areas));
        return "success";
    }
}

