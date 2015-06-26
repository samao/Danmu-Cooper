/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 26, 2015 6:09:49 PM			
 * ===================================
 */

package com.idzeir.acfun.manage
{
	
	public class LanguagePack implements ILanguagePack
	{
		private static var _instance:LanguagePack;
		/**
		 * 语言包xml 
		 */		
		private static var _xml:XML;
		
		public function LanguagePack()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public static function getInstance(value:XML = null):LanguagePack
		{
			if(!_instance)
			{
				if(value==null)
				{
					throw new Error("未提供初始化语言包数据");
				}
				_instance = new LanguagePack();
			}
			if(value != null)
			{
				update(value);
			}
			return _instance;
		}
		
		private static function update(value:XML):void
		{
			_xml = value;
		}
		
		public function get(value:String):String
		{
			return _xml.l.(@key == value).toString()||"::NULL::";
		}
	}
}