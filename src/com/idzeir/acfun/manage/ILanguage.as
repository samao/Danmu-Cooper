/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 26, 2015 6:07:07 PM			
 * ===================================
 */

package com.idzeir.acfun.manage
{
	/**
	 * 语言包接口
	 */	
	public interface ILanguage
	{
		/**
		 * 获取指定key对应的语言文字
		 */		
		function get(value:String):String;
	}
}