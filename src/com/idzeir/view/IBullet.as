/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 16, 2015 10:38:00 PM			
 * ===================================
 */

package com.idzeir.view
{
	import com.idzeir.vo.BulletVo;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * 弹幕ui接口
	 */	
	public interface IBullet
	{
		/**
		 * 弹幕位置刷新
		 * @param time
		 */		
		function update(time:Number = 0):void;
		/**
		 * 弹幕类型
		 * @return 
		 */		
		function get bulletType():String;
		/**
		 * 设置弹幕显示内容
		 * @param value
		 * @param point 弹幕初始位置,扩展之后自定义位置
		 * @return 
		 */		
		function bullet(value:BulletVo,point:Point = null):IBullet;
		/**
		 * 获取当前的弹幕数据
		 */		
		function getBullet():BulletVo;
		/**
		 * 返回显示对象
		 * @return 
		 */		
		function get warp():DisplayObject;
		/**
		 * 返回弹幕显示内容
		 */		
		function get content():String;
	}
}
