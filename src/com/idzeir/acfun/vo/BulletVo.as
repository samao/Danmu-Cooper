/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 8, 2015 12:45:56 PM			
 * ===================================
 */

package com.idzeir.acfun.vo
{
	import com.idzeir.acfun.utils.Log;
	
	/**
	 * 弹幕数据模型
	 */	
	public class BulletVo
	{
		private var _stime:Number;
		private var _color:int;
		private var _mode:String;
		private var _size:int;
		/**
		 * 发送用户 
		 */		
		private var _user:String;
		/**
		 * 
		 */		
		private var _time:int;
		private var _message:String;
		private var _commentId:String;
		
		private var _type:String;
		private var _score:String;
		
		public function BulletVo(value:*,type:uint)
		{
			//{"c":"885.686,16777215,1,25,2b7k2073538161,1414066687,147f785d-21f7-43f8-ace9-79a7c95dfb78","score":"147f785d-21f7-43f8-ace9-79a7c95dfb78","m":"好基友"}
			//Log.debug("弹幕数据：",JSON.stringify(value));
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
			return _message;
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