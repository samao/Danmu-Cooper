/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 8, 2015 12:45:56 PM			
 * ===================================
 */

package com.idzeir.vo
{
	import com.idzeir.manage.BulletType;
	import com.idzeir.utils.Log;
	
	/**
	 * 弹幕数据模型
	 */	
	public class BulletVo
	{
		private var _stime:Number;
		private var _color:int;
		private var _mode:String;
		private var _size:int;
		private var _user:String;
		/**
		 * 
		 */		
		private var _time:int;
		private var _message:String;
		private var _commentId:String;
		
		private var _type:String;
		private var _score:String;
		
		//高级弹幕数据 
		private var _addon:Object = null;
		private var _duration:Number;
		private var _url:String = null;
		private var _name:String;
		
		public function BulletVo(value:* = null,type:uint = 1)
		{
			if(value)
			{
				try{
					var cArr:Array = value["c"].split(",");
					_stime = parseFloat(cArr[0]);
					_color = int(cArr[1]);
					_mode = cArr[2];
					_size = int(cArr[3]);
					_user = cArr[4];
					_time = int(cArr[5])*1000;
					_commentId = cArr[6];
				}catch(e:Error){
					Log.warn("弹幕数据不全:type=",type,"数据:value=",JSON.stringify(value));
				}
				_message = value["m"];
				_score = value["score"];
				_type = type.toString();
				
				//高级弹幕配置信息
				if(_mode == BulletType.FIXED_FADE_OUT)
				{
					try{
						var specialData:Object = value["addon"]||JSON.parse(value.m);
						_addon = specialData;
						_duration = getDurationFromAddon();
						_url = specialData.url;
						_message = specialData.n;
					}catch(e:Error){
						Log.warn("高级弹幕数据错误：",e.message);
					}
				}
			}
		}
		
		public function get name():String
		{
			return _addon?addon.name:null;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * 高级弹幕超链接 
		 */
		public function get url():String
		{
			return _url;
		}

		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			_url = value;
		}

		/**
		 * 计算当前高级弹幕持续时间
		 */		
		private function getDurationFromAddon():Number
		{
			var duration:Number = 0;
			const DEF_TIME:int = 3;
			if(this._addon)
			{
				if(_addon.l != null)
					duration += Number(_addon.l);
				else
					duration += DEF_TIME;
				
				if(_addon.z != null)
				{
					for each(var i:Object in _addon.z)
					{
						if(i.l!=null&&Number(i.l)>0)
						{
							duration += Number(i.l);
						}
					}
				}
			}
			return duration;
		}
		
		/**
		 * 高级弹幕持续时间 
		 */
		public function get duration():Number
		{
			return _duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:Number):void
		{
			_duration = value;
		}

		public function get addon():Object
		{
			return _addon;
		}

		public function set addon(value:Object):void
		{
			_addon = value;
		}

		/**
		 * 发送用户 
		 */
		public function get user():String
		{
			return _user;
		}

		/**
		 * @private
		 */
		public function set user(value:String):void
		{
			_user = value;
		}

		/**
		 * 弹幕模式 
		 */
		public function get mode():String
		{
			return _mode;
		}

		/**
		 * @private
		 */
		public function set mode(value:String):void
		{
			_mode = value;
		}

		/**
		 * 颜色 
		 */
		public function get color():int
		{
			return _color;
		}

		/**
		 * @private
		 */
		public function set color(value:int):void
		{
			_color = value;
		}

		/**
		 * 字体大小 
		 */
		public function get size():int
		{
			return _size;
		}

		/**
		 * @private
		 */
		public function set size(value:int):void
		{
			_size = value;
		}

		/**
		 * 弹幕内容 
		 */
		public function get message():String
		{
			return $.fm.checkWords(_message);
		}

		/**
		 * @private
		 */
		public function set message(value:String):void
		{
			_message = value;
		}

		/**
		 * 开始播放时间
		 */
		public function get stime():Number
		{
			return _stime;
		}

		/**
		 * @private
		 */
		public function set stime(value:Number):void
		{
			_stime = value;
		}

		/**
		 * 弹幕id 
		 */
		public function get commentId():String
		{
			return _commentId;
		}

		/**
		 * @private
		 */
		public function set commentId(value:String):void
		{
			_commentId = value;
		}

	}
}
