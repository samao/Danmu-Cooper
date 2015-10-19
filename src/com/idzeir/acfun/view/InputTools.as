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
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.manage.BulletType;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.utils.NodeUtil;
	import com.idzeir.acfun.utils.RefUtil;
	import com.idzeir.components.HBox;
	import com.idzeir.components.ImageButton;
	import com.idzeir.components.Style;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
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
		/**
		 * 是否正在显示 
		 */		
		private var _showing:Boolean = true;
		
		//输入框最小宽度
		private const INPUT_MIN_WIDTH:uint = 30;
		
		private var _setWidth:Number = 0;
		
		public function InputTools()
		{
			super();
			this.gap = 8;
			this.algin = HBox.MIDDLE;
			
			addChildren();
			
			_setWidth = this.width;
		}
		
		private function addChildren():void
		{
			var buttonsXML:XMLList = $.g.xml..buttons;
			
			var logo:ImageButton = new ImageButton();
			logo.setSize(66,20);
			logo.skinUrlMap = buttonsXML.logo.text().split("|");
			
			const authority:String = "acfun.tv";
			const host:String = RefUtil.host;
			
			if(RefUtil.remote&&(host.lastIndexOf(authority)+authority.length)==host.length)
			{
				logo.buttonMode = false;
			}else{
				logo.addEventListener(MouseEvent.CLICK,function():void
				{
					RefUtil.toURL("http://www."+authority);
				});
			}
			
			addChild(logo);
			
			var option:ImageButton = new ImageButton();
			option.setSize(16,16);
			option.skinUrlMap = buttonsXML.set.text().split("|");
			option.addEventListener(MouseEvent.CLICK,function():void
			{
				//Log.debug("设置");
				$.e.dispatchEvent(new GlobalEvent(EventType.SWITCH_OPTION));
			});
			addChild(option);
			
			_inputTxt = new InTextField();
			_inputTxt.width = 500;
			addChild(_inputTxt);
			
			var sendBut:ImageButton = new ImageButton();
			sendBut.setSize(64,25);
			sendBut.skinUrlMap = buttonsXML.send.text().split("|");
			sendBut.addEventListener(MouseEvent.CLICK,function():void
			{
				send();
			});
			
			addChild(sendBut);
			
			var close:ImageButton = new ImageButton();
			close.setSize(16,16);
			var open:Boolean = true;
			var openMap:Array = buttonsXML.open.text().split("|");;
			var closeMap:Array = buttonsXML.close.text().split("|");;
			close.skinUrlMap = openMap;
			close.addEventListener(MouseEvent.CLICK,function():void
			{
				open = !open;
				close.skinUrlMap = open?openMap:closeMap;
				$.e.dispatchEvent(new GlobalEvent(EventType.SWITCH_BULLET));
			});
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
			_tipsTxt.x = _inputTxt.getBounds(this).x + 3;
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
			_setWidth = value;
			var min:int = super.width - _inputTxt.width;
			//输入框小于30像素时候隐藏
			if(value<0||value<(min+INPUT_MIN_WIDTH))
			{
				_showing&&(super.visible = false);
				return;
			}
			
			_showing&&(super.visible = true);
			if(value>min)
			{
				_inputTxt.width = value - min;
			}
			this.update();
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = vaild()?value:false;
			_showing = value;
		}
		
		/**
		 * 检测是否有足够空间显示
		 * @return 
		 */		
		private function vaild():Boolean
		{
			if(_setWidth<0||_setWidth<(super.width - _inputTxt.width+INPUT_MIN_WIDTH))
				return false;
			return true;
		}
		
		/**
		 * 发送弹幕
		 */		
		private function send():void
		{
			if(StringUtil.remove(_inputTxt.text," ").length == 0) 
			{
				$.e.dispatchEvent(new GlobalEvent(EventType.ERROR,{"message":$.l.get("error_send_empty")}));
				return;
			}
			
			if(!$.fm.checkUser($.u.id))
			{
				$.e.dispatchEvent(new GlobalEvent(EventType.ERROR,{"message":$.l.get("error_send_blacklist")}));
				return;
			}
			
			var d:Object = {};
			var c:Object = {};
			c.mode = _styles[_style.style];
			c.color = _style.color;
			c.size = _sizes[_style.size];
			c.user = $.u.id;
			c.message = $.fm.checkWords(_inputTxt.text);
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