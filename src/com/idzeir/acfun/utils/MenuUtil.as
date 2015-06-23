/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 11:05:53 PM			
 * ===================================
 */

package com.idzeir.acfun.utils
{
	import flash.display.InteractiveObject;
	import flash.ui.ContextMenu;
	
	/**
	 * 右键工具类菜单
	 */	
	public class MenuUtil
	{
		public function MenuUtil()
		{
			throw new Error("工具类");
		}
		
		/**
		 * 隐藏阐述文件的右键
		 * 如果有后续参数添加到右键，为contextMenuItem对象
		 */		
		public static function hidenContextMenus(menuTarget:InteractiveObject,...arg):void
		{
			if(menuTarget)
			{
				menuTarget.contextMenu ||= new ContextMenu();
				menuTarget.contextMenu.hideBuiltInItems();
				menuTarget.contextMenu.customItems.length = 0;
				while(arg.length)
				{
					menuTarget.contextMenu.customItems.push(arg.shift());
				}
			}
		}
	}
}