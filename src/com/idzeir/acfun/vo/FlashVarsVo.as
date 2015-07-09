/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 6:41:38 PM			
 * ===================================
 */

package com.idzeir.acfun.vo
{
	
	/**
	 * 页面信息
	 */	
	dynamic public class FlashVarsVo implements IFlashVarsVo
	{
		private var _vid:String = "1478973";
		private var _videoId:String;
		private var _sourceId:String;
		private var _type:String;
		private var _autoplay:Boolean = false;
		
		private static var _instance:FlashVarsVo;
		
		public function FlashVarsVo()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public function get autoplay():Boolean
		{
			return _autoplay;
		}

		public function set autoplay(value:Boolean):void
		{
			_autoplay = value;
		}

		public static function getInstance():FlashVarsVo
		{
			return _instance ||= new FlashVarsVo();
		}
		
		public function get vid():String
		{
			return _vid;
		}
		
		public function get videoId():String
		{
			return _videoId;
		}
		
		public function get sourceId():String
		{
			return _sourceId;
		}
		
		public function get type():String
		{
			return _type;
		}

		public function update(value:Object):IFlashVarsVo
		{
			if(value)
			{
				//严格命名字段
				value.hasOwnProperty("vid")&&(this._vid = value["vid"]);
				value.hasOwnProperty("videoId")&&(this._videoId = value["videoId"]);
				value.hasOwnProperty("sourceId")&&(this._sourceId = value["sourceId"]);
				value.hasOwnProperty("type")&&(this._type = value["type"]);
				value.hasOwnProperty("autoplay")&&(this._autoplay = value["autoplay"]);
				
				//未命名字段
				for(var i:String in value)
				{
					if(!this.hasOwnProperty(i))
					{
						this[i] = value[i];
					}
				}
			}
			return this
		}
	}
}