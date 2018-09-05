/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 3, 2015 9:46:33 PM			
 * ===================================
 */

package
{
	import com.idzeir.business.IQm;
	import com.idzeir.coop.ILogic;
	import com.idzeir.manage.IAnimation;
	import com.idzeir.manage.IBulletFactory;
	import com.idzeir.manage.IBulletVoMgr;
	import com.idzeir.manage.ICookie;
	import com.idzeir.manage.IFilterManager;
	import com.idzeir.manage.IKeys;
	import com.idzeir.manage.ILanguage;
	import com.idzeir.manage.IToolTipMgr;
	import com.idzeir.timer.ITicker;
	import com.idzeir.vo.IConfigVo;
	import com.idzeir.vo.IFlashVarsVo;
	import com.idzeir.vo.IUser;
	import com.idzeir.vo.IVideoInfoVo;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * 工具代理
	 */	
	public class $
	{
		/**
		 * 业务队列管理 
		 */		
		public static var q:IQm;
		/**
		 * flashvars数据 
		 */		
		public static var f:IFlashVarsVo;
		/**
		 * 配置文件数据 
		 */		
		public static var c:IConfigVo;
		/**
		 * 视频信息 
		 */		
		public static var v:IVideoInfoVo;
		/**
		 * 第三方逻辑 
		 */		
		public static var g:ILogic;
		/**
		 * 弹幕数据中心
		 */		
		public static var b:IBulletVoMgr
		/**
		 * 计时器 
		 */		
		public static var t:ITicker;
		/**
		 * 全局事件机制 
		 */		
		public static var e:IEventDispatcher;
		/**
		 * 弹幕显示ui对象工厂 
		 */		
		public static var ui:IBulletFactory;
		/**
		 * 键盘按键管理 
		 */		
		public static var k:IKeys;
		/**
		 * 动画管理 
		 */		
		public static var a:IAnimation;
		/**
		 * 用户个人信息 
		 */		
		public static var u:IUser;
		/**
		 * 语言包信息
		 */		
		public static var l:ILanguage;
		/**
		 * 弹幕过滤管理 
		 */		
		public static var fm:IFilterManager;
		/**
		 * tips管理器
		 */		
		public static var tips:IToolTipMgr;
		/**
		 * flash cookie 
		 */		
		public static var fc:ICookie;
		/**
		 * 检查是否支持flash cookie同步
		 */		
		public static function get supportCookie():Boolean
		{
			return fc!=null;
		}
	}
}
