/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 5:17:56 PM			
 * ===================================
 */

package com.idzeir.acfun.utils
{
	
	internal final class Watcher
	{
		public var url:String,params:Object,ok:Function,fail:Function;
		
		private static var _map:Vector.<Watcher> = new Vector.<Watcher>();
		
		public function Watcher()
		{
			
		}
		
		public static function create():Watcher
		{
			if(_map.length == 0)
			{
				_map.push(new Watcher());
			}
			return _map.shift();
		}
		
		public function clear():void
		{
			url = null;
			ok = null;
			fail = null;
			_map.push(this);
		}
		
		public function update(url:String,params:Object,ok:Function,fail:Function):Watcher
		{
			this.url = url;
			this.params = params;
			this.ok = ok;
			this.fail = fail;
			return this;
		}
	}
}