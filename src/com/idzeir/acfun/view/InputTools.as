/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 23, 2015 2:08:48 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.utils.Log;
	
	import flash.ui.Keyboard;
	
	public class InputTools extends HBox
	{

		private var _inputTxt:InTextField;
		
		public function InputTools()
		{
			super();
			this.gap = 10;
			this.algin = HBox.MIDDLE;
			
			addChildren();
		}
		
		private function addChildren():void
		{
			_inputTxt = new InTextField();
			_inputTxt.width = 500;
			addChild(_inputTxt);
			addChild(new LabelButton("<font color='#ffffff' size='14'>发送</font>",function():void{
				Log.debug("发送");
			}));
			addChild(new LabelButton("<font color='#ffffff' size='14'>设置</font>",function():void{
				Log.debug("设置");
			}));
			addChild(new LabelButton("<font color='#ffffff' size='14'>关闭弹幕</font>",function():void{
				Log.debug("关闭弹幕");
			}));
			
			$.k.listener(flash.ui.Keyboard.ENTER,function():void
			{
				Log.debug("回车发送");
			});
		}
		
		private function send():void
		{
			$.e.dispatchEvent(new GlobalEvent(EventType.SEND,_inputTxt.text));
			_inputTxt.text = "";
		}
	}
}