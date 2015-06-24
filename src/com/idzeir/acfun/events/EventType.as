/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 16, 2015 3:43:18 PM			
 * ===================================
 */

package com.idzeir.acfun.events
{
	
	public final class EventType
	{
		/**
		 * 统一的错误消息
		 * info.message 为错误消息 
		 */		
		public static const ERROR:String = "error";
		/**
		 * 初始化进度 
		 * info 为显示信息 
		 */		
		public static const PROGRESS:String = "progress";
		/**
		 * 发送弹幕事件
		 * info为弹幕信息 
		 */		
		public static const SEND:String = "send";
		/**
		 * 接收实时弹幕
		 * info为弹幕信息 
		 */		
		public static const RECIVE:String = "recive";
		/**
		 * 打开关闭设置面板
		 */		
		public static const SWITCH_OPTION:String = "switchOption";
		/**
		 * 打开弹幕显示
		 */		
		public static const SWITCH_BULLET:String = "switchBullet";
	}
}