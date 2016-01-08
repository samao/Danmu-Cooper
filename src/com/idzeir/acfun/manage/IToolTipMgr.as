/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	2016,5:24:41 PM		
 * ===================================
 */

package com.idzeir.acfun.manage
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;

	/**
	 * tips全局注册
	 */	
	public interface IToolTipMgr
	{
		/**
		 * 注册tip
		 * @param target 要显示tip的对象
		 * @param tips tip内容text.htmlText
		 */		
		function add(target:InteractiveObject,tips:String):void;
		/**
		 * 删除tip注册
		 * @param target
		 */		
		function remove(target:InteractiveObject):void;
		/**
		 * 设置tip容器 
		 * @param layer
		 * @return 
		 */		
		function setupLayer(layer:DisplayObjectContainer):void
	}
}