/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 29, 2015 6:02:20 PM			
 * ===================================
 */

package com.idzeir.utils
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * 发灰滤镜工具
	 */	
	public class GlayUtil
	{
		public static function filter(value:DisplayObject):void
		{
			//发灰滤镜 
			const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter(
				[
					0.3086, 0.6094, 0.082, 0, 0, 
					0.3086, 0.6094, 0.082, 0, 0, 
					0.3086, 0.6094, 0.082, 0, 0,
					0, 0, 0, 1, 0, 
					0, 0, 0, 0, 1]);
			
			value.filters = [GRAY_FILTER];
		}
		
		public static function clear(value:DisplayObject):void
		{
			value.filters = [];
		}
	}
}
