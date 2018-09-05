/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 3, 2015 11:19:38 PM			
 * ===================================
 */

package com.idzeir.business
{
	import flash.events.Event;
	
	
	public class QmEvent extends Event
	{
		/**
		 * 队列执行完毕 
		 */		
		public static const COMPLETE_QM:String = "completeQm";
		/**
		 * 队列异常退出 
		 */		
		public static const BREAK_QM:String = "breakQm";
		
		public function QmEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
