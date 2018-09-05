/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 29, 2015 11:24:54 AM			
 * ===================================
 */

package com.idzeir.module
{
	import com.idzeir.manage.Cookie;
	import com.idzeir.manage.ICookie;
	import com.idzeir.view.BaseStage;
	
	import flash.events.Event;
	
	/**
	 * 同步web cookie 和 flash cookie
	 */	
	[SWF(width="1",height="1")]
	public class CookieSycn extends BaseStage
	{
		private var _cookie:Cookie;
		
		public function CookieSycn()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false;
			
			_cookie = new Cookie();
			_cookie.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				dispatchEvent(e);
			})
			_cookie.update();
		}
		
		public function get cookie():ICookie
		{
			return _cookie;
		}
	}
}
