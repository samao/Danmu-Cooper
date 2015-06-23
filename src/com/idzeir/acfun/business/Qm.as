/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 2:56:03 PM			
 * ===================================
 */

package com.idzeir.acfun.business
{
	import flash.events.EventDispatcher;
	
	[Event(name="completeQm", type="com.idzeir.acfun.business.QmEvent")]
	
	[Event(name="breakQm", type="com.idzeir.acfun.business.QmEvent")]
	
	/**
	 * 业务管理实现 
	 */	
	public class Qm extends EventDispatcher implements IQm
	{
		private var _map:Vector.<IQueue> = new Vector.<IQueue>();
		
		private static var _instance:Qm;
		
		public function Qm()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public static function getInstance():Qm
		{
			return _instance ||= new Qm();
		}
		
		public function push(queue:IQueue,clear:Boolean = false):void
		{
			clear&&(_map.length = 0);
			_map.push(queue);
		}
		
		public function excute(start:int = 0):void
		{
			_map.splice(0,start);
			
			next();
		}
		
		public function next():void
		{
			if(_map.length>0)
			{
				_map.shift().enter(this);
				return;
			}
			
			if(this.hasEventListener(QmEvent.COMPLETE_QM))
			{
				this.dispatchEvent(new QmEvent(QmEvent.COMPLETE_QM));
			}
		}
		
		public function breakQm():void
		{
			if(this.hasEventListener(QmEvent.BREAK_QM))
			{
				this.dispatchEvent(new QmEvent(QmEvent.BREAK_QM));
			}
		}
	}
}