/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Oct 19, 2015 2:18:14 PM			
 * ===================================
 */

package com.idzeir.acfun.manage
{
	import com.idzeir.acfun.utils.Log;
	
	import flash.utils.Dictionary;
	
	/**
	 * 弹幕过滤管理器
	 * @author iDzeir
	 */	
	public class FilterManager implements IFilterManager
	{
		private static var _instance:FilterManager;
		/**
		 * 敏感词 
		 */		
		private var _wordsMap:Vector.<String> = new Vector.<String>();
		/**
		 * 封禁用户 
		 */		
		private var _userMap:Dictionary = new Dictionary(true);
		/**
		 * 敏感词正则 
		 */		
		private var _regExp:RegExp;
		
		public function FilterManager()
		{
		}
		
		public static function getInstance():FilterManager
		{
			return _instance ||= new FilterManager();
		}
		
		public function checkWords(value:String):String
		{
			if(value)return value.replace(_regExp,"█");
			return value;
		}
		
		public function checkUser(value:String):Boolean
		{
			if(_userMap.hasOwnProperty(value)&&_userMap[value])
				return false;
			return true;
		}
		
		public function updateBan(value:String):void
		{
			_wordsMap.length = 0;
			try{
				var words:Array = JSON.parse(value) as Array;
			}catch(e:Error){
				Log.warn("敏感词库数据有问题忽略敏感词");
				words = [];
			}
			words.forEach(function(e:*,index:int,arr:Array):void
			{
				if(e!=""&&_wordsMap.indexOf(e)==-1)
					_wordsMap.push(e);
			});
			_regExp = new RegExp(_wordsMap.join("|"),"ig");
		}
		
		public function updateBlacklist(value:String):void
		{
			try{
				var words:Array = JSON.parse(value) as Array;
			}catch(e:Error){
				Log.warn("黑名单数据有问题忽略黑名单");
				words = [];
			}
			words.forEach(function(e:*,index:int,arr:Array):void
			{
				_userMap[e] = true;
			});
		}
		
		public function toString():String
		{
			var blacklist:Function = function():String{
				var str:Array = [];
				for(var i:String in _userMap)
				{
					str.push(i);
				}
				return str.join(",")
			}
			return "敏感词："+_wordsMap.join(",")+"" +
				"\n封禁用户:"+blacklist();
		}
	}
}