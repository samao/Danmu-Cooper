/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Sep 18, 2015 5:50:22 PM			
 * ===================================
 */

package com.idzeir.acfun.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
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
					ExternalInterface.call("window.open",url,window);	
				}catch(e:Error){
					navigateToURL(new URLRequest(url),window);
				}
			}else{
				navigateToURL(new URLRequest(url),window);
			}
		}
	}
}