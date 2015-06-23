/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 16, 2015 10:36:46 PM			
 * ===================================
 */

package com.idzeir.acfun.manage
{
	import com.idzeir.acfun.view.IBullet;
	
	/**
	 * 弹幕ui管理
	 */	
	public interface IBulletFactory
	{
		/**
		 * 创建弹幕ui
		 * @param type 弹幕类型 BulletUiType
		 * @return 
		 */		
		function create(type:String):IBullet;
		/**
		 * 弹幕回收
		 * @param value
		 */		
		function recyle(value:IBullet):void;
		/**
		 * 当前显示中的弹幕
		 * @return 
		 */		
		function get useMap():Vector.<IBullet>;
	}
}