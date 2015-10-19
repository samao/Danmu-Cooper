/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 3:09:52 PM			
 * ===================================
 */

package com.idzeir.acfun.business
{
	import flash.events.Event;
	
	/**
	 * 业务基类
	 */	
	public class BaseInit implements IQueue
	{
		private var _qm:IQm;
		
		public function BaseInit()
		{
		}
		
		protected function dispatchEvent(e:Event):void
		{
			$.e.dispatchEvent(e);
		}
		
		public function enter(qm:IQm):void
		{
			_qm = qm;
		}
		
		public function breakQm():void
		{
			if(_qm)
			{
				_qm.breakQm();
				_qm = null;
			}
		}
		
		public function complete():void
		{
			_qm.next();
			_qm = null;
		}
	}
}