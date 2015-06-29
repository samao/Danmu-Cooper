/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 4, 2015 5:11:01 PM			
 * ===================================
 */

package com.idzeir.acfun.utils
{
	
	public class FindUtil
	{
		public function FindUtil()
		{
			throw new Error("工具类");
		}
		
		/**
		 * 从value中，逐级检索对象
		 * @param value
		 * @param key 以点分割
		 * @return 返回找到的对象
		 */		
		public static function get(value:Object,key:String):*
		{
			if(key == "") return value;
			var keys:Array = key.split(".");
			var o:Object = value;
			while(keys.length>0)
			{
				o = o[keys.shift()];
				if(o == null) return o;
			}
			
			return o;
		}
	}
}