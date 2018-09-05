/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv
 * ===================================
 */

package com.idzeir.vo
{
	/**
	 * xml逻辑生成的逻辑处理对象
	 */	
	public class LogicEventVo
	{
		private var _type:String;
		private var _handler:String;
		private var _arg:String;
		
		public function LogicEventVo(type:String,handler:String,arg:String = null)
		{
			_type = type;
			_handler = handler;
			_arg = arg;
		}

		public function get arg():String
		{
			return _arg;
		}

		public function get handler():String
		{
			return _handler;
		}

		public function get type():String
		{
			return _type;
		}

	}
}