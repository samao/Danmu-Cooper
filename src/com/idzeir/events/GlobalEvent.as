/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv
 * ===================================
 */

package com.idzeir.events
{
	import flash.events.Event;
	
	
	public class GlobalEvent extends Event
	{
		private var _info:* = null;
		
		public function GlobalEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_info = data;
		}
		
		/**
		 * 时间传递的信息 
		 */
		public function get info():*
		{
			return _info;
		}

		override public function clone():Event
		{
			return new GlobalEvent(type,_info,bubbles,cancelable);
		}
	}
}