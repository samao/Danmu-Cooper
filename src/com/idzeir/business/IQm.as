/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv
 * ===================================
 */

package com.idzeir.business
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 业务管理接口
	 */	
	public interface IQm extends IEventDispatcher
	{
		/**
		 * 添加业务队列
		 * @param queue
		 * @param clear 是否清楚之前队列
		 */		
		function push(queue:IQueue,clear:Boolean = false):void;
		/**
		 * 执行下一个业务逻辑
		 */		
		function next():void;
		
		/**
		 * 开始执行业务
		 */		
		function excute(start:int = 0):void;
		
		function breakQm():void;
	}
}