/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 16, 2015 3:43:18 PM			
 * ===================================
 */

package com.idzeir.events
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
		 * websocket 服务器关闭
		 * info 为关闭原因 
		 */		
		public static const DISPOSE:String = "dispose";
		/**
		 * 打开关闭设置面板
		 */		
		public static const SWITCH_OPTION:String = "switchOption";
		/**
		 * 打开弹幕显示
		 */		
		public static const SWITCH_BULLET:String = "switchBullet";
		/**
		 * 配置面板修改颜色
		 * info为颜色数值
		 */		
		public static const OPTION_CHANGE:String = "optionChange";
	}
}
