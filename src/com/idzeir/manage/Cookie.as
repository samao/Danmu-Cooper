/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 29, 2015 2:44:34 PM			
 * ===================================
 */

package com.idzeir.manage
{
	import com.idzeir.utils.Log;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.Dictionary;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * cookie 管理类
	 */	
	public class Cookie extends EventDispatcher implements ICookie
	{
		private var _map:Dictionary = new Dictionary();
		
		private var _so:SharedObject;
		
		private const _DB_KEY_:String = "AcFun_iDzeir_data";
		
		private const BUFFER_SIZE:uint = 1024;
		
		public function Cookie(target:IEventDispatcher=null)
		{
			super(target);
			_so = SharedObject.getLocal(_DB_KEY_,"/");
			_so.addEventListener(AsyncErrorEvent.ASYNC_ERROR,function():void
			{
				Log.warn("同步cookie失败");
			});
			_so.addEventListener(NetStatusEvent.NET_STATUS,onFlushStatus);
		}
		
		protected function onFlushStatus(e:NetStatusEvent):void
		{
			switch (e.info.code) {
				case "SharedObject.Flush.Success" :
					Log.info("请求cookie空间成功");
					break;
				case "SharedObject.Flush.Failed" :
					Log.info("用户拒绝请求cookie空间");
					break;
			}
		}
		
		public function get(key:String):*
		{
			_so.data.player ||= {};
			return _so.data.player[key];
		}
		
		public function set(key:String,value:*):void
		{
			_so.data.player ||= {};
			_so.data.player[key] = value;
			_so.flush(BUFFER_SIZE);
		}
		
		public function update():void
		{
			if(ExternalInterface.available)
			{
				var cookies:String = ExternalInterface.call("function(){ return document.cookie; }");
				//{"command":"{\"uid\":\"1407552\",\"uid_ck\":\"-2041506475\"}","action":"auth"}
				//cookies = "auth_key=1368971; auth_key_ac_sha1=1469459601; auth_key_ac_sha1_=ebF9oHOxJwrf7XYU8rwwcgSg06Q=; ac_username=%E6%88%91%E2%91%A9%E9%BE%98; ac_userimg=http%3A%2F%2Fstatic.acfun.mm111.net%2Fdotnet%2F20120923%2Fstyle%2Fimage%2Favatar.jpg; Hm_lvt_bc75b9260fe72ee13356c664daa5568c=1434093416,1434340247,1435549666,1435568174; Hm_lpvt_bc75b9260fe72ee13356c664daa5568c=1435568179; clientlanguage=zh_CN";
				if(cookies)
				{
					var cookieMap:Array = cookies.match(/([^ ]+)=([^;]*)/ig);
					for each(var i:String in cookieMap)
					{
						if(i.indexOf("=")!=-1)
						{
							var cookie:Array = i.split("=");
							_map[cookie[0]] = cookie[1];
						}
					}
					flush(true);
				}
			}
		}
		
		/**
		 * 为false时不覆盖原有值
		 */		
		private function flush(bool:Boolean = false):void
		{
			_so.data.player ||= {};
			
			for(var i:String in _map)
			{
				_so.data.player[i] = bool ? _map[i] : _so.data[i]
			}
			
			var flushStatus:String = null;
			try{
				flushStatus = _so.flush(BUFFER_SIZE);
				if (flushStatus) {
					switch (flushStatus) {
						case SharedObjectFlushStatus.FLUSHED : 
							Log.info("同步cookie成功");
							this.dispatchEvent(new Event(Event.COMPLETE));
							break;
						case SharedObjectFlushStatus.PENDING : 
							Log.warn("同步cookie空间不够请求多余空间");
							break;
					}
				}
			}catch(e:Error) {
				Log.warn("同步cookie失败");
			}
		}
	}
}
