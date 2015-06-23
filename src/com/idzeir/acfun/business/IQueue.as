/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 2:54:26 PM			
 * ===================================
 */

package com.idzeir.acfun.business
{
	
	/**
	 * 具体业务接口
	 */	
	public interface IQueue
	{
		/**
		 * 开始执行业务
		 */		
		function enter(qm:IQm):void;
		/**
		 * 意外退出
		 */		
		function breakQm():void;
		/**
		 * 具体业务接口
		 */		
		function complete():void;
	}
}