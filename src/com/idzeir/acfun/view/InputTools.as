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
	import com.idzeir.acfun.manage.BulletType;
	import com.idzeir.acfun.utils.Log;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * 弹幕工具栏
	 */	
	public class InputTools extends HBox
	{
		/** 输入文本框 */		
		private var _inputTxt:InTextField;
		
		private var _sizes:Array = [16,20,25];
		private var _styles:Array = [BulletType.FADE_OUT_TOP,BulletType.RIGHT_TO_LEFT,BulletType.FADE_OUT_BOTTOM];
		
		/**
		 * 当前使用发送样式 
		 */		
		private var _style:Object = {size:1,style:1,color:0x000000};
		
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
			
			var sendBut:LabelButton = new LabelButton("发送",function():void
			{
				send();
			});
			sendBut.style = new LabelButtonStyle(0xFFFFFF,0x666666,null,null,0xFF0000);
			addChild(sendBut);
			
			var option:LabelButton = new LabelButton("设置",function():void
			{
				//Log.debug("设置");
				$.e.dispatchEvent(new GlobalEvent(EventType.SWITCH_OPTION));
			});
			option.style = sendBut.style;
			addChild(option);
			
			var close:LabelButton = new LabelButton("关闭弹幕",function():void
			{
				//Log.debug("关闭弹幕");
				$.e.dispatchEvent(new GlobalEvent(EventType.SWITCH_BULLET));
				close.label = close.label == "关闭弹幕"?"打开弹幕":"关闭弹幕";
			});
			close.style = sendBut.style;
			addChild(close);
			
			$.k.listener(Keyboard.SPACE,function(e:KeyboardEvent):void
			{
				if(stage.focus == _inputTxt)
				{
					e.stopImmediatePropagation();
					e.stopPropagation();
				}
			});
			$.k.listener(flash.ui.Keyboard.ENTER,function():void
			{
				send();
			});
			
			$.e.addEventListener(EventType.OPTION_CHANGE,function(e:GlobalEvent):void
			{
				_style.color = _inputTxt.textColor = e.info.color;
				_style.size = e.info.size;
				_style.style = e.info.style;
			});
		}
		
		/**
		 * 发送弹幕
		 */		
		private function send():void
		{
			$.e.dispatchEvent(new GlobalEvent(EventType.SEND,_inputTxt.text));
			Log.debug("发送弹幕：",_inputTxt.text,"弹幕样式："+_styles[_style.style]+"弹幕大小："+_sizes[_style.size],"弹幕颜色：0x"+_style.color.toString(16));
			_inputTxt.text = "";
		}
	}
}