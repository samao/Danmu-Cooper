/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 9:49:54 PM			
 * ===================================
 */

package com.idzeir.acfun.vo
{
	/**
	 * 视频信息接口
	 */	
	public interface IVideoInfoVo
	{
		/**
		 * 弹幕id
		 */		
		function get danmakuId():String;
		/**
		 * 视频来源
		 */		
		function get sourceType():String;
		/**
		 * 视频时长
		 */		
		function get videoLength():int;
		/**
		 * 更新视频信息
		 */		
		function update(value:Object):IVideoInfoVo;
		/**
		 * 视频ac号
		 * @return 
		 */		
		function get contentId():Number;
	}
}