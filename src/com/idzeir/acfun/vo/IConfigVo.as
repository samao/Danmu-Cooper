/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 9:49:16 PM			
 * ===================================
 */

package com.idzeir.acfun.vo
{
	/**
	 * 配置信息接口
	 */	
	public interface IConfigVo
	{
		/**
		 * 获取视频信息地址
		 */		
		function get getVideoUrl():String;
		/**
		 * 历史弹幕请求地址
		 */		
		function get staticUrl():String;
		/**
		 * websocket连接地址
		 */		
		function get websocketUri():String;
		
		/**
		 * 加载完json更新配置信息
		 */		
		function update(value:Object):IConfigVo;
		
		/**
		 * 敏感词地址
		 */		
		function get ban():String
			
		/**
		 * 黑名单地址
		 */		
		function get blacklist():String
	}
}