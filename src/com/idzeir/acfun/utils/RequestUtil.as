/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 4:39:46 PM			
 * ===================================
 */

package com.idzeir.acfun.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	
	public class RequestUtil
	{
		private static var _map:Vector.<Watcher> = new Vector.<Watcher>();
		
		private static var _loader:URLLoader;
		private static var _url:URLRequest = new URLRequest();
		
		private static var _current:Watcher = new Watcher();
		
		public function RequestUtil()
		{
			throw new Error("工具类");
		}
		
		/**
		 *	加载工具 
		 * @param url 服务器地址
		 * @param params 默认get不填写，否则按post请求
		 * @param ok 成回调参数为返回的JSON对象
		 * @param fail 失败返回，失败原因Object.type,当前执行的地址Object.info
		 */		
		public static function load(url:String,params:Object = null, ok:Function = null,fail:Function = null):void
		{
			if(_map.length > 0)
			{
				_map.push(Watcher.create().update(url,params,ok,fail));
				return;
			}
			if(!_loader)
			{
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE,onComplete);
				_loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
			}
			
			_current.update(url,params,ok,fail);
			
			_url.method = URLRequestMethod.GET;
			if(params!=null)
			{
				remote&&(params.t = Math.random());
				_url.data = params;
				_url.method = URLRequestMethod.POST;
			}else{
				remote&&(url = url+"?t="+Math.random());
			}
			_url.url = url;
			_loader.load(_url);
		}
		
		private static function get remote():Boolean
		{
			return Security.sandboxType == Security.REMOTE
		}
		
		private static function onComplete(e:Event):void
		{
			try{
				_current.ok&&_current.ok.apply(null,[e.target.data]);
			}catch(error:Error){}
			
			vaild();
		}
		
		private static function onError(e:Event):void
		{
			try
			{
				_current.fail&&_current.fail.apply(null,[{type:e.type,info:_url.url}]);
			}catch(error:Error){}
			
			vaild();
		}
		
		private static function vaild():void
		{
			if(_map.length>0)
			{
				var willExcute:Watcher = _map.shift();
				_current.update(willExcute.url,willExcute.params,willExcute.ok,willExcute.fail);
				
				_url.method = URLRequestMethod.GET;
				if(willExcute.params!=null)
				{
					remote&&(willExcute.params.t = Math.random());
					_url.data = willExcute.params;
					_url.method = URLRequestMethod.POST;
				}else{
					remote&&(willExcute.url = willExcute.url+"?t="+Math.random());
				}
				
				_url.url = willExcute.url;
				_loader.load(_url);
				
				willExcute.clear();
			}
		}
	}
}