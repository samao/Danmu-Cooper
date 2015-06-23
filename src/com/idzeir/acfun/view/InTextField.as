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
			this.backgroundColor = 0x343434;
			this.defaultTextFormat = new TextFormat(FontUtil.fontName,12,0xffffff,true);
			this.border = true;
			this.borderColor = 0xffffff;
			this.maxChars = 60;
		}
	}
}