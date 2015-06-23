/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 16, 2015 3:49:34 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	
	import flash.text.TextField;
	
	
	public class ErrorText extends TextField
	{
		public function ErrorText()
		{
			super();
			
			$.e.addEventListener(EventType.ERROR,function(e:GlobalEvent):void
			{
				appendText(e.info.message+"\n")
			});
			
			this.selectable = this.mouseEnabled = false;
			this.autoSize = "left";
			this.textColor = 0xffffff;
		}
		
		override public function appendText(newText:String):void
		{
			super.appendText(newText);
			if($.t.has(miss))
			{
				$.t.remove(miss);
			}
			$.t.call(2000,miss,1);
		}
		
		/**
		 * 错误消息消失
		 */		
		private function miss():void
		{
			this.text = "";
		}		
		
	}
}