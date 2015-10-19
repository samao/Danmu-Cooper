/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 4:31:02 PM			
 * ===================================
 */

package com.idzeir.acfun.vo
{
	
	/**
	 * 配置信息
	 */	
	public class ConfigVo implements IConfigVo
	{
		private var _host:String = "localhost";
		private var _getVideoUrl:String = "";
		private var _staticUrl:String = "";
		private var _websocketUri:String = "";
		private var _ban:String = "";
		private var _blacklist:String = "";
		
		
		private static var _instance:ConfigVo;
		
		public function ConfigVo()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}

		public static function getInstance():ConfigVo
		{
			return _instance ||= new ConfigVo();
		}
		
		public function get getVideoUrl():String
		{
			return _getVideoUrl;
		}

		public function get staticUrl():String
		{
			return _staticUrl;
		}
		
		public function get websocketUri():String
		{
			return _websocketUri;
		}
		
		public function get blacklist():String
		{
			return _blacklist;
		}
		
		public function get ban():String
		{
			return _ban;
		}

		public function update(value:Object):IConfigVo
		{
			value.hasOwnProperty("host")&&(_host = value["host"]);
			value.hasOwnProperty("getVideoUrl")&&(_getVideoUrl = value["getVideoUrl"]);
			value.hasOwnProperty("staticUrl")&&(_staticUrl = value["staticUrl"]);
			value.hasOwnProperty("websocketUri")&&(_websocketUri = value["websocketUri"]);
			value.hasOwnProperty("ban")&&(_ban = value["ban"]);
			value.hasOwnProperty("blacklist")&&(_blacklist = value["blacklist"]);
			
			return this;
		}
		
		public function toString():String
		{
			return "========配置信息：\nhost:"+_host+"" +
				"\ngetVideoUrl:"+_getVideoUrl+"" +
				"\nstaticUrl"+_staticUrl+"" +
				"\nwebsocketUri:"+_websocketUri+"" +
				"\nban:" + _ban +""+
				"\nblacklist:" + _blacklist +"" +
				"\n========(end)";
		}
	}
}