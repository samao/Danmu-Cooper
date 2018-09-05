/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 3, 2015 10:33:58 PM			
 * ===================================
 */

package com.idzeir.coop
{
	import com.idzeir.vo.LogicEventVo;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	/**
	 * 业务逻辑数据实现
	 */	
	public final class Logic extends EventDispatcher implements ILogic
	{
		private var _xml:XML;
		private var _playerURL:String;
		private var _proxy:String = "";
		private var _eventTarget:String;
		private var _checks:Vector.<String>;
		private var _logicEvents:Vector.<LogicEventVo>;
		//弹幕上下边距
		private var _gap:Point = new Point();
		
		private static var _instance:Logic;
		
		public function Logic(target:IEventDispatcher=null)
		{
			super(target);
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public function get gap():Point
		{
			return _gap;
		}

		public function get proxy():String
		{
			return _proxy;
		}

		public static function getInstance():Logic
		{
			return _instance ||= new Logic();
		}
		
		public function get playerURL():String
		{
			return _playerURL;
		}
		
		public function get eventTarget():String
		{
			return _eventTarget;
		}
		
		public function get checks():Vector.<String>
		{
			return _checks;
		}
		
		public function get logicEvents():Vector.<LogicEventVo>
		{
			return _logicEvents;
		}
		
		public function update(xml:XML):void
		{
			_xml = xml.copy();
			
			_playerURL = _xml.address.text();
			_proxy = _xml.address.@proxy;
			
			_checks ||= new Vector.<String>();
			_checks.length = 0;
			var checksXML:XMLList = _xml.core.check;
			for each(var i:XML in checksXML)
			{
				_checks.push(i.@exist);
			}
			
			_logicEvents ||= new Vector.<LogicEventVo>();
			_logicEvents.length = 0;
			var logicEventXML:XMLList = _xml.core.dispatch.event;
			for each(i in logicEventXML)
			{
				_logicEvents.push(new LogicEventVo(i.@type,i.text(),i.@from));
			}
			
			_gap.x = parseInt(_xml..comment.@top);
			_gap.y = parseInt(_xml..comment.@bottom);
			
			_eventTarget = _xml.core.dispatch.@target;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
	}
}
