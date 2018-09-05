/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Sep 18, 2015 5:50:22 PM			
 * ===================================
 */

package com.idzeir.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.Security;
	
	/**
	 * 获取引用
	 * @author iDzeir
	 */	
	public class RefUtil
	{
		/**本地标示*/
		public static const LOCAL:String = "localhost";
		
		public static function get ref():String
		{
			var url:String = LOCAL;
			if(remote)
			{
				if(ExternalInterface.available)
				{
					try{
						url = ExternalInterface.call("function(){return window.location.href}");
					}catch(e:Error){
						url = LOCAL;
					}
				}
			}
			return url;
		}
		/**
		 * 返回主机地址 本地文件返回localhost
		 * @return 
		 */		
		public static function get host():String
		{
			if(remote)
			{
				return ref.match(/.+\.[^\/]+/ig).join();
			}
			return LOCAL;
		}
		/**
		 * 是否是远程文件
		 * @return 
		 */		
		public static function get remote():Boolean
		{
			return Security.sandboxType==flash.system.Security.REMOTE;
		}
		/**
		 * 跳转到界面
		 * @param url
		 */		
		public static function toURL(url:String,window:String = "_blank"):void
		{
			if(ExternalInterface.available)
			{
				try{
					ExternalInterface.call("function(){window.open("+url+","+window+")}");	
				}catch(e:Error){
					navigateToURL(new URLRequest(url),window);
				}
			}else{
				navigateToURL(new URLRequest(url),window);
			}
		}
		/**
		 * 获取页面地址后面的参数
		 * @return 
		 */		
		public static function getUrlVars():Object
		{
			var adress:String = ref;
			try{
				if(adress.indexOf("?")>0)
				{
					return toObject(adress.split("?")[1]);
				}
			}catch(e:Error){}
			return {};
		}
		/**
		 * 将对值串转成Object对象
		 * @param url
		 * @return 
		 */		
		public static function toObject(url:String):Object
		{
			var map:Array = url.split("&");
			var o:Object = {};
			for(var i:uint = 0; i < map.length; ++i)
			{
				var elem:Array = map[i].split("=");
				if(elem.length==2)
				{
					o[elem[0]] = elem[1];
				}
			}
			return o;
		}
	}
}
