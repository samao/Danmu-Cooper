/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Oct 19, 2015 2:12:56 PM			
 * ===================================
 */

package com.idzeir.manage
{
	/**
	 * 敏感词封禁用户管理接口
	 */	
	public interface IFilterManager
	{
		/**
		 * 敏感词过滤
		 * @param value 处理的字符串
		 * @return 将敏感词处理成星号 返回
		 */		
		function checkWords(value:String):String;
		
		/**
		 * 封禁用户验证
		 * @param value 用户标示
		 * @return 正常返回true，封禁返回false
		 */		
		function checkUser(value:String):Boolean;
		/**
		 * 更新敏感词
		 * @param value
		 */		
		function updateBan(value:String):void
		/**
		 * 更新封禁用户
		 * @param value
		 */			
		function updateBlacklist(value:String):void
	}
}
