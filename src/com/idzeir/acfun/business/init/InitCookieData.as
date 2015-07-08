/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 29, 2015 4:15:45 PM			
 * ===================================
 */

package com.idzeir.acfun.business.init
{
	import com.idzeir.acfun.business.BaseInit;
	import com.idzeir.acfun.business.IQm;
	import com.idzeir.acfun.utils.Log;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * 同步cookie 数据
	 */	
	public class InitCookieData extends BaseInit
	{
		public function InitCookieData()
		{
			super();
		}
		
		override public function enter(qm:IQm):void
		{
			super.enter(qm);
			
			var onCompleteHandler:Function = function(event:Event):void
			{
				clear();
				Log.info("加载插件成功");
				$.fc = event.target.content["cookie"];
				complete();
			};
		
			var onError:Function = function(event:IOErrorEvent):void
			{
				Log.warn("加载插件失败：",COOKIE_URL);
				clear();
				complete();
			};
			var clear:Function = function():void
			{
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onCompleteHandler);
			}
			Log.info("加载cookie同步插件");	
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler);
			var COOKIE_URL:String = "cookieSycn.swf";
			loader.load(new URLRequest(COOKIE_URL));
		}
	}
}