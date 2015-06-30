/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 29, 2015 2:43:19 PM			
 * ===================================
 */

package com.idzeir.acfun.manage
{
	import flash.events.IEventDispatcher;
	/**
	 * cookie 接口
	 */	
	public interface ICookie extends IEventDispatcher
	{
		/**
		 * 获取指定key的cookie值，不存在返回null
		 */		
		function get(key:String):*;
		/**
		 * 设置指定的Flash cookie 有可能覆盖web cookie
		 * @param key 
		 * @param value
		 */		
		function set(key:String,value:*):void;
	}
}