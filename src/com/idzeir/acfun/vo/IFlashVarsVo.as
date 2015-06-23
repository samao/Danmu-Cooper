/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 9:53:22 PM			
 * ===================================
 */

package com.idzeir.acfun.vo
{
	/**
	 * 页面数据接口
	 */	
	public interface IFlashVarsVo
	{
		/**
		 * 页面传入的vid
		 */		
		function get vid():String;
		/**
		 * 页面传入的videoId
		 */		
		function get videoId():String;
		/**
		 * 页面传入的sourceId
		 */		
		function get sourceId():String;
		/**
		 * 页面传入的type
		 */		
		function get type():String;
		/**
		 * 视频是否自动播放
		 */		
		function get autoplay():Boolean;
		/**
		 * 用页面传入内容更新对象
		 */		
		function update(value:Object):IFlashVarsVo;
	}
}