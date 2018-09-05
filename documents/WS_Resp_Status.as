/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Oct 13, 2015 5:49:35 PM			
 * ===================================
 */

package
{
	public class WS_Resp_Status
	{
		/**
		 * 302跳转 
		 */		
		public static const _302:String = "302";
		/**
		 * 格式错误提示（旧）
		 */		
		public static const _FORMAT_ERROR:String = "509";
		/**
		 * 操作成功 
		 */		
		public static const _SEND_OK:String = "200";
		/**
		 * 未授权操作 
		 */		
		public static const _NO_ALLOW:String = "401";
		/**
		 * 临时戒严，低于指定等级的用户禁止发言 msg 带失败原因
		 */		
		public static const _SEND_LIMIT_LEVEL:String = "401.6";
		/**
		 * 临时戒严，游客禁止发言 msg 带失败原因
		 */		
		public static const _SEND_LIMIT_GUEST:String = "401.9";
		/**
		 * 服务器操作中，请勿着急
		 */		
		public static const _PROCESSING:String = "102";
		/**
		 * 通信协议转换成MQ，接入方不用等待成功信息
		 */		
		public static const _SWITCH:String = "101";
		/**
		 * 发送数据出错，msg 带失败原因
		 */		
		public static const _SEND_FORMAT_ERROR:String = "400";
		/**
		 * 服务器数据库错误 
		 */		
		public static const _DATABASE_ERROR:String = "507";
		/**
		 * 服务器错误 
		 */		
		public static const _SERVER_ERROR:String = "503";
		/**
		 * 发送内容包含敏感词 msg可能包含敏感词
		 */		
		public static const _SENSITIVE_WORD:String = "403";
		/**
		 * 发送高级弹幕等级不足 msg带原因和需要的等级
		 */		
		public static const _NOT_HAVE_ENOUGH_LEVEL:String = "401.3";
		
		public static const NULL_409:String = "409";
		public static const NULL_404:String = "404";
	}
}