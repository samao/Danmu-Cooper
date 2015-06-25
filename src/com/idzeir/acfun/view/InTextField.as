/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 23, 2015 10:53:39 AM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import com.idzeir.acfun.utils.FontUtil;
	
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * 输入框
	 */	
	public class InTextField extends TextField
	{
		public function InTextField()
		{
			super();
			this.type = TextFieldType.INPUT;
			this.height = 20;
			this.multiline = false;
			this.wordWrap = false;
			
			this.background = true;
			this.backgroundColor = 0xFFFFFF;
			this.defaultTextFormat = new TextFormat(FontUtil.fontName,12,0x000000,true);
			this.defaultTextFormat.leftMargin = 10;
			this.border = true;
			this.borderColor = 0x33333;
			this.maxChars = 60;
			
			this.filters = [new DropShadowFilter(1,45,0,1,1,1),new DropShadowFilter(1,225,0,1,1,1)];
		}
	}
}