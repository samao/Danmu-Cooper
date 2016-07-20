/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 24, 2015 4:23:03 PM			
 * ===================================
 */

package com.idzeir.acfun.module
{
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.view.BaseStage;
	import com.idzeir.components.v2.HBox;
	import com.idzeir.components.v2.LabelButton;
	import com.idzeir.components.v2.LabelButtonStyle;
	import com.idzeir.components.v2.Radio;
	import com.idzeir.components.v2.RadioGroup;
	import com.idzeir.components.v2.Style;
	import com.idzeir.components.v2.VBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 弹幕配置面板
	 */	
	public class DanmuOption extends BaseStage
	{
		/** 是否已经打开 */
		private var _open:Boolean = false;

		private var _colorSelect:Shape;
		
		private var _styleGroup:RadioGroup;

		private var _sizeGroup:RadioGroup;

		private var _selectColor:uint;
		
		/**
		 * 弹幕配置在flash cookie中的保存字段
		 */		
		private const _DANMU_CONFIG_:String = "danmu_config";

		private var _config:Number;
		
		public function DanmuOption()
		{
			super();
		}
		
		override protected function onAdded(e:Event):void
		{
			super.onAdded(e);
			this.graphics.lineStyle(1,0x333333);
			this.graphics.beginFill(0x000000,.8);
			this.graphics.drawRect(0,0,300,240);
			this.graphics.endFill();
			
			var _box:VBox = new VBox();
			_box.gap = 8;
			
			_sizeGroup = new RadioGroup();
			var bigRadio:Radio = new Radio();
			bigRadio.label = $.l.get("setting_size_big");
			var midRadio:Radio = new Radio();
			midRadio.label = $.l.get("setting_size_normal");
			var smallRadio:Radio = new Radio();
			smallRadio.label = $.l.get("setting_size_small");
			_sizeGroup.group = [smallRadio,midRadio,bigRadio];
			//_sizeGroup.index = (_config>>27)&0x3;
			
			var size:TextField = new TextField();
			size.defaultTextFormat = new TextFormat(Style.font);
			size.autoSize = "left";
			size.textColor = 0xFFFFFF;
			size.text = $.l.get("setting_size_label");
			var sizeBox:HBox = new HBox();
			sizeBox.algin = HBox.MIDDLE;
			sizeBox.addChild(size);
			sizeBox.addChild(_sizeGroup);
			_box.addChild(sizeBox);
			
			_styleGroup = new RadioGroup();
			var topRadio:Radio = new Radio();
			topRadio.label = $.l.get("setting_style_top");
			var moveRadio:Radio = new Radio();
			moveRadio.label = $.l.get("setting_style_move");
			var bottomRadio:Radio = new Radio();
			bottomRadio.label = $.l.get("setting_style_bottom");
			_styleGroup.group = [topRadio,moveRadio,bottomRadio];
			//_styleGroup.index = (_config>>24)&0x3;
			
			var style:TextField = new TextField();
			style.defaultTextFormat = new TextFormat(Style.font);
			style.autoSize = "left";
			style.textColor = 0xFFFFFF;
			style.text = $.l.get("setting_style_label");
			var styleBox:HBox = new HBox();
			styleBox.algin = HBox.MIDDLE;
			styleBox.addChild(style);
			styleBox.addChild(_styleGroup);
			_box.addChild(styleBox);
			
			var color:TextField = new TextField();
			color.defaultTextFormat = new TextFormat(Style.font);
			color.autoSize = "left";
			color.textColor = 0xFFFFFF;
			color.text = $.l.get("setting_color_label");
			
			const BORDER:int = 1;
			const SIZE:int = 15;
			var _colorSelectBox:Sprite = new Sprite();
			_colorSelectBox.graphics.beginFill(0xFFFFFF);
			_colorSelectBox.graphics.drawRect(0,0,SIZE,SIZE);
			_colorSelectBox.graphics.endFill();
			
			_colorSelect = new Shape();
			_colorSelect.graphics.beginFill(0x000000);
			_colorSelect.graphics.drawRect(BORDER,BORDER,SIZE-2*BORDER,SIZE-2*BORDER);
			_colorSelect.graphics.endFill();
			_colorSelectBox.addChild(_colorSelect);
			
			var colorBox:HBox = new HBox();
			colorBox.algin = HBox.MIDDLE;
			colorBox.addChild(color);
			colorBox.addChild(_colorSelectBox);
			
			
			_box.addChild(colorBox);
			_box.addChild(createColorPicker());
			
			_box.x = this.width - _box.width >> 1;
			_box.y = this.height - _box.height >> 1;
			
			var closeBut:LabelButton = new LabelButton("<font size='14'>×</font>",function():void
			{
				Log.debug("关闭设置面板");
				close();
			});
			closeBut.background = false;
			closeBut.style = new LabelButtonStyle(0xFFFFFF,null,null,null,0xFF0000);
			closeBut.x = this.width - closeBut.width - 5;
			closeBut.y = 0;
			
			this.addChild(closeBut);
			this.addChild(_box);
			
			this.x = -this.width - 50;
			this.y = stage.stageHeight - this.height - Number($.g.xml..option.@bottom[0]);
			
			_styleGroup.addEventListener(Event.CHANGE,onOptionChange);
			_sizeGroup.addEventListener(Event.CHANGE,onOptionChange);
			$.e.addEventListener(EventType.SWITCH_OPTION,onSwitch);
			
			stage.addEventListener(Event.RESIZE,function():void
			{
				y = stage.stageHeight - height - Number($.g.xml..option.@bottom[0]);
			});
			
			applyConfig();
		}
		
		private function createColorPicker():Sprite
		{
			const WIDTH:int = 14;
			const HEIGHT:int = 10
			const ROW:int = 18;
			const COL:int = 12;
			
			var colorPicker:Sprite = new Sprite();
			var bitmap:Bitmap = new Bitmap();
			var bmd:BitmapData = new BitmapData(ROW*WIDTH,COL*HEIGHT,true,0x00FFFFFF);
			var rect:Rectangle = new Rectangle(0,0,WIDTH-1,HEIGHT-1);
			
			for(var i:int = 0;i<ROW;++i)
			{
				for(var j:int = 0;j<COL;++j)
				{
					rect.x = i*WIDTH+1;
					rect.y = j*HEIGHT+1;
					var OFFX:uint = uint(i/6)*0x330000+uint(i%6)*0x003300;
					var OFFY:uint = uint(j/6)*0x003300+uint(j%6)*0x000033;
					var color:uint = OFFX|OFFY|(j>5?0xFF990000:0xFF000000);
					bmd.fillRect(rect,color);
				}
			}
			
			bitmap.bitmapData = bmd;
			colorPicker.addChild(bitmap);
			
			colorPicker.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
			{
				selectColor = bmd.getPixel((uint(e.localX/WIDTH)+.5)*WIDTH,(uint(e.localY/HEIGHT)+.5)*HEIGHT);
			});
			
			var box:Shape = new Shape();
			box.graphics.lineStyle(1,0xFFFFFF);
			box.graphics.drawRect(0,0,WIDTH,HEIGHT);
			box.graphics.endFill();
			box.visible = false;
			
			colorPicker.addChild(box);
			
			colorPicker.addEventListener(MouseEvent.MOUSE_MOVE,function(e:MouseEvent):void
			{
				box.visible = true;
				box.x = (uint(e.localX/WIDTH))*WIDTH;
				box.y = (uint(e.localY/HEIGHT))*HEIGHT;
			});
			
			colorPicker.addEventListener(MouseEvent.ROLL_OUT,function():void
			{
				box.visible = false;
			})
			
			return colorPicker;
		}
		
		private function onOptionChange(e:Event = null):void
		{
			var save:uint = _sizeGroup.index<<27|_styleGroup.index<<24|_selectColor;
			var color:int = save&0xFFFFFF;
			var style:uint = (save>>24)&0x3;
			var size:uint = (save>>27)&0x3;
			Log.debug("保存弹幕配置数据",size,style,color.toString(16));
			$.fc.set(_DANMU_CONFIG_,save);
			$.e.dispatchEvent(new GlobalEvent(EventType.OPTION_CHANGE,{size:_sizeGroup.index,style:_styleGroup.index,color:_selectColor}));
		}
		
		public function set selectColor(value:uint):void
		{
			_selectColor = value;
			var ct:ColorTransform = new ColorTransform();
			ct.color = value;
			_colorSelect.transform.colorTransform = ct;
			onOptionChange();
		}
		
		private function close():void
		{
			$.a.to(this,.5,{x:-this.width - 50});
			_open = false;
		}
		
		private function onSwitch(e:GlobalEvent):void
		{
			if(!_open)
			{
				$.a.fromTo(this,.5,{x:-this.width - 50},{x:Number($.g.xml..option.@left)});
			}else{
				$.a.to(this,.5,{x:-this.width - 50});
			}
			_open = !_open;
		}
		
		/**
		 * 按照cookie初始化配置信息，没有cookie的话执行默认配置
		 */		
		private function applyConfig():void
		{
			if($.supportCookie)
			{
				_config = $.fc.get(_DANMU_CONFIG_);
				_sizeGroup.index = (_config>>27)&0x3;
				_styleGroup.index = (_config>>24)&0x3;
				selectColor = _config&0xFFFFFF;
			}else{
				_sizeGroup.index = 1;
				_styleGroup.index = 1;
				selectColor = 0x000000;
			}
		}
	}
}