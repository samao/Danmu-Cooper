/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 23, 2015 2:24:28 PM			
 * ===================================
 */

package com.idzeir.manage
{
	import flash.display.Stage;
	
	public interface IKeys
	{
		/**
		 * 监听键盘事件
		 * @param value 按键
		 * @param handler 处理函数
		 */		
		function listener(value:int,handler:Function):void;
		/**
		 * 移除键盘事件 
		 * @param handler 处理函数
		 */		
		function remove(value:int):void;
		/**
		 * 配置监听舞台
		 */		
		function set stage(value:Stage):void;
		/**
		 * 永久屏蔽按键组键盘事件
		 */		
		function set cancelKeys(values:Array):void;
	}
}
