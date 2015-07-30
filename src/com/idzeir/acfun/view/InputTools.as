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
	import com.adobe.utils.StringUtil;
	import com.idzeir.acfun.components.HBox;
	import com.idzeir.acfun.components.LabelButton;
	import com.idzeir.acfun.components.LabelButtonStyle;
	import com.idzeir.acfun.components.Style;
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.manage.BulletType;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.utils.NodeUtil;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
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

		private var _tipsTxt:TextField;
		
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
			
			var sendBut:LabelButton = new LabelButton($.l.get("comment_send_but"),function():void
			{
				send();
			});
			
			var colors:Array = $.g.xml..button.@colors.split(",");
			Log.debug("工具栏按钮颜色：",JSON.stringify(colors))
			
			sendBut.style = new LabelButtonStyle(parseInt(colors[0]),parseInt(colors[1]),parseInt(colors[2]),parseInt(colors[3]),parseInt(colors[4]),parseInt(colors[5]));
			addChild(sendBut);
			
			var option:LabelButton = new LabelButton($.l.get("comment_option_but"),function():void
			{
				//Log.debug("设置");
				$.e.dispatchEvent(new GlobalEvent(EventType.SWITCH_OPTION));
			});
			option.style = sendBut.style;
			addChild(option);
			
			var close:LabelButton = new LabelButton($.l.get("comment_close_but"),function():void
			{
				//Log.debug("关闭弹幕");
				$.e.dispatchEvent(new GlobalEvent(EventType.SWITCH_BULLET));
				close.label = close.label == $.l.get("comment_close_but")?$.l.get("comment_open_but"):$.l.get("comment_close_but");
			});
			close.style = sendBut.style;
			addChild(close);
			
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
			
			var inputColors:Array = $.g.xml..label.@colors.split(",");
			_tipsTxt = new TextField();
			_tipsTxt.autoSize = "left";
			_tipsTxt.textColor = inputColors&&inputColors.length>2?parseInt(inputColors[2]):0x999999;
			_tipsTxt.mouseEnabled = false;
			_tipsTxt.defaultTextFormat = new TextFormat(Style.font);
			_tipsTxt.htmlText = $.l.get("send_text_tips");
			_tipsTxt.x = this._gap + 3;
			_tipsTxt.y = this.bounds.height - _tipsTxt.height >> 1;
			_tipsTxt.alpha = .5;
			//_tipsTxt.filters = [new DropShadowFilter(1,45,0xFFFFFF,1,1,1)];
			this.addRawChild(_tipsTxt);
			
			addTextListener();
			
			if($.g.xml..input.@used == "0")
			{
				sendBut.mouseEnabled = _inputTxt.mouseEnabled = false;
				_tipsTxt.htmlText = $.l.get("used_input_tips");
			}
		}
		
		private function stopEvent(e:Event):void
		{
			if(stage.focus == _inputTxt)
			{
				e.stopImmediatePropagation();
				e.stopPropagation();
			}
		}
		
		/**
		 * 添加输入文本监听事件
		 */		
		private function addTextListener():void
		{
			
			_inputTxt.addEventListener(FocusEvent.FOCUS_IN,function():void
			{
				_tipsTxt.visible = false;
				$.k.cancelKeys = [Keyboard.SPACE,Keyboard.LEFT,Keyboard.RIGHT];
			});
			_inputTxt.addEventListener(FocusEvent.FOCUS_OUT,function():void
			{
				if(_inputTxt.text.length == 0)
				{
					_tipsTxt.visible = true;
				}else{
					_tipsTxt.visible = false;
				}
				$.k.cancelKeys = [];
			});
		}
		
		override public function set width(value:Number):void
		{
			var min:int = super.width - _inputTxt.width;
			if(value>min)
			{
				_inputTxt.width = value - min;
			}
			this.update();
		}
		
		/**
		 * 发送弹幕
		 */		
		private function send():void
		{
			if(StringUtil.remove(_inputTxt.text," ").length == 0) return;
			
			var d:Object = {};
			var c:Object = {};
			c.mode = _styles[_style.style];
			c.color = _style.color;
			c.size = _sizes[_style.size];
			c.user = $.u.id;
			c.message = _inputTxt.text;
			c.time = new Date().time;
			//比当前时间少1s防止重复显示
			c.stime = NodeUtil.get($.b.timeNode).stime - 1;
			
			d.action = "post";
			d.command = JSON.stringify(c);
			
			$.e.dispatchEvent(new GlobalEvent(EventType.SEND,d));
			Log.debug("发送弹幕：",_inputTxt.text,"弹幕样式："+_styles[_style.style]+"弹幕大小："+_sizes[_style.size],"弹幕颜色：0x"+_style.color.toString(16));
			_inputTxt.text = "";
		}
	}
}