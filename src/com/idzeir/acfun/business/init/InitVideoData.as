/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 4:24:02 PM			
 * ===================================
 */

package com.idzeir.acfun.business.init
{
	import com.idzeir.acfun.business.BaseInit;
	import com.idzeir.acfun.business.IQm;
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.utils.RequestUtil;
	
	public class InitVideoData extends BaseInit
	{
		public function InitVideoData()
		{
			super();
		}
		
		override public function enter(qm:IQm):void
		{
			super.enter(qm);
			$.e.dispatchEvent(new GlobalEvent(EventType.PROGRESS,"读取视频信息"));
			var URL:String = $.c.getVideoUrl+"?id="+$.f.videoId;
			Log.info("加载视频信息",URL);
			RequestUtil.load(URL,null,function(value:String):void
			{
				try{
					var o:Object = JSON.parse(value);
				}catch(e:Error){
					Log.error("JSONError:",URL);
					return;
				}
				
				if(o["success"] == true)
				{
					Log.debug(JSON.stringify(o));
					$.v.update(o);
					complete();
				}else{
					Log.error("服务器返回失败消息：",JSON.stringify(o));
				}
			},function(value:Object):void
			{
				Log.error("加载失败：",JSON.stringify(value));
			});
		}
	}
}