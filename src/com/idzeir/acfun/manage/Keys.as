/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 23, 2015 2:40:57 PM			
 * ===================================
 */

package com.idzeir.acfun.manage
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 键盘事件管理
	 */	
	public class Keys implements IKeys
	{
		private static var _instance:Keys;
		
		private var _map:Dictionary = new Dictionary(true);
		private var _stage:Stage;
		
		public function Keys()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public static function getInstance():Keys
		{
			return _instance ||= new Keys();
		}
		
		public function listener(value:int, handler:Function):void
		{
			_map[value] = handler;
		}
		
		public function remove(value:int):void
		{
			delete _map[value];
		}
		
		public function set stage(value:Stage):void
		{
			if(!_stage)
			{
				_stage = value;
				_stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if(_map.hasOwnProperty(e.keyCode))
			{
				var call:Function = _map[e.keyCode];
				call.apply();
			}
		}
	}
}