/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 3, 2015 10:10:13 PM			
 * ===================================
 */

package com.idzeir.business.init
{
	import com.idzeir.business.BaseInit;
	import com.idzeir.business.IQm;
	import com.idzeir.events.EventType;
	import com.idzeir.events.GlobalEvent;
	import com.idzeir.utils.Log;
	import com.idzeir.utils.RequestUtil;
	
	
	public class InitXMLLogic extends BaseInit
	{
		public function InitXMLLogic()
		{
			super();
		}
		
		override public function enter(qm:IQm):void
		{
			super.enter(qm);
			$.e.dispatchEvent(new GlobalEvent(EventType.PROGRESS,"加载播放器逻辑"));
			const URL:String = "conf/"+$.v.sourceType+".xml";
			Log.info("加载逻辑配置",URL);
			RequestUtil.load(URL,null,function(value:String):void
			{
				Log.debug(XML(value).toXMLString());
				$.g.update(XML(value));
				complete();
			},function(value:Object):void
			{
				Log.error("加载逻辑配置失败：",JSON.stringify(value));
			});
		}
	}
}
