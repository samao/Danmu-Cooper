/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 9:46:33 PM			
 * ===================================
 */

package
{
	import com.idzeir.acfun.business.IQm;
	import com.idzeir.acfun.coop.ILogic;
	import com.idzeir.acfun.manage.IAnimation;
	import com.idzeir.acfun.manage.IBulletFactory;
	import com.idzeir.acfun.manage.IBulletVoMgr;
	import com.idzeir.acfun.manage.IKeys;
	import com.idzeir.acfun.timer.ITicker;
	import com.idzeir.acfun.vo.IConfigVo;
	import com.idzeir.acfun.vo.IFlashVarsVo;
	import com.idzeir.acfun.vo.IVideoInfoVo;
	
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
		public static var l:ILogic;
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
		public static var u:IBulletFactory;
		/**
		 * 键盘按键管理 
		 */		
		public static var k:IKeys;
		/**
		 * 动画管理 
		 */		
		public static var a:IAnimation;
	}
}