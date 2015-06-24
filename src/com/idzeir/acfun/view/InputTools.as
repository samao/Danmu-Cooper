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
	
	/**
	 * 弹幕工具栏
	 */	
	public class InputTools extends HBox
	{
		/** 输入文本框 */		
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
			
			var send:LabelButton = new LabelButton("发送",function():void
			{
				Log.debug("发送");
			});
			send.style = new LabelButtonStyle(0xFFFFFF,0x666666,null,null,0xFF0000);
			addChild(send);
			
			var option:LabelButton = new LabelButton("设置",function():void
			{
				Log.debug("设置");
			});
			option.style = send.style;
			addChild(option);
			
			var close:LabelButton = new LabelButton("关闭弹幕",function():void
			{
				Log.debug("关闭弹幕");
			});
			close.style = send.style;
			addChild(close);
			
			$.k.listener(flash.ui.Keyboard.ENTER,function():void
			{
				Log.debug("回车发送");
			});
		}
		
		/**
		 * 发送弹幕
		 */		
		private function send():void
		{
			$.e.dispatchEvent(new GlobalEvent(EventType.SEND,_inputTxt.text));
			_inputTxt.text = "";
		}
	}
}