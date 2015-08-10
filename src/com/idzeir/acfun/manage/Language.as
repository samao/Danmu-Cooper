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
	
	public class Language implements ILanguage
	{
		private static var _instance:Language;
		/**
		 * 语言包xml 
		 */		
		private static var _xml:XML;
		
		public function Language()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public static function getInstance(value:XML = null):Language
		{
			if(!_instance)
			{
				if(value==null)
				{
					throw new Error("未提供初始化语言包数据");
				}
				_instance = new Language();
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