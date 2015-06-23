/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 4:38:41 PM			
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
	
	public class InitConfigData extends BaseInit
	{
		public function InitConfigData()
		{
			super();
		}
		
		override public function enter(qm:IQm):void
		{
			super.enter(qm);
			$.e.dispatchEvent(new GlobalEvent(EventType.PROGRESS,"加载配置信息"));
			const CONFIG_URL:String = "conf/config.json";
			Log.info("加载配置信息",CONFIG_URL);
			RequestUtil.load(CONFIG_URL,null,function(value:String):void
			{
				try{
					var o:Object = JSON.parse(value);
				}catch(e:Error){
					Log.error("JSONError:",CONFIG_URL)
					dispatchEvent(new GlobalEvent(EventType.ERROR,{"message":"JSONError:"+CONFIG_URL}));
					return;
				}
				Log.debug(JSON.stringify(o));
				$.c.update(o);
				complete();
			},function(value:Object):void
			{
				Log.error("加载配置失败：",JSON.stringify(value));
				dispatchEvent(new GlobalEvent(EventType.ERROR,{"message":"加载配置失败："+CONFIG_URL}));
			});
		}
	}
}