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
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.components.v2.Style;
	
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
			
			var colors:Array = $.g.xml..label.@colors.split(",");
			Log.debug("输入框颜色配置：",JSON.stringify(colors),parseInt(colors[0])==0xFFFFFF);
			this.background = true;
			this.backgroundColor = colors&&colors.length>0?parseInt(colors[0]):0xFFFFFF;
			this.defaultTextFormat = new TextFormat(Style.font,12,0x000000,true);
			this.defaultTextFormat.leftMargin = 10;
			if(colors&&colors.length>1&&colors[1]!="null")
			{
				this.border = true;
				this.borderColor = colors&&colors.length>1?parseInt(colors[1]):0x333333;
			}
			this.maxChars = 60;
			
			this.filters = [new DropShadowFilter(1,45,0,1,1,1),new DropShadowFilter(1,225,0,1,1,1)];
		}
	}
}