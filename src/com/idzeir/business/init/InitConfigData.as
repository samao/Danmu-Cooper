/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 3, 2015 4:38:41 PM			
 * ===================================
 */

package com.idzeir.business.init
{
	import com.idzeir.business.BaseInit;
	import com.idzeir.business.IQm;
	import com.idzeir.events.EventType;
	import com.idzeir.events.GlobalEvent;
	import com.idzeir.manage.Language;
	import com.idzeir.utils.Log;
	import com.idzeir.utils.RequestUtil;
	
	import flash.system.Capabilities;
	
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
				loadLanguagePack();
			},function(value:Object):void
			{
				Log.error("加载配置失败：",JSON.stringify(value));
				dispatchEvent(new GlobalEvent(EventType.ERROR,{"message":"加载配置失败："+CONFIG_URL}));
			});
		}
		
		/**
		 * 加载语言包
		 */		
		private function loadLanguagePack():void
		{
			Log.info("加载语言包：",Capabilities.language);
			switch(Capabilities.language)
			{
				case "en":
				case "zh-TW":
				case "zh-CN":
				default:
					//加载中文简体
					const LA_URL:String = "conf/zh-CN.xml";
					RequestUtil.load(LA_URL,null,function(value:String):void
					{
						Log.debug("语言包加载成功：",XML(value).toXMLString());
						$.l = Language.getInstance(XML(value));
						complete();
					},function(value:Object):void
					{
						Log.error("加载语言包失败：",JSON.stringify(value));
						dispatchEvent(new GlobalEvent(EventType.ERROR,{"message":"加载配置失败："+LA_URL}));
					});
					break;
			}
		}
	}
}
