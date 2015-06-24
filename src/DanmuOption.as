/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 24, 2015 4:23:03 PM			
 * ===================================
 */

package
{
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.utils.FontUtil;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.view.BaseStage;
	import com.idzeir.acfun.view.HBox;
	import com.idzeir.acfun.view.LabelButton;
	import com.idzeir.acfun.view.LabelButtonStyle;
	import com.idzeir.acfun.view.Radio;
	import com.idzeir.acfun.view.RadioGroup;
	import com.idzeir.acfun.view.VBox;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 弹幕配置面板
	 */	
	public class DanmuOption extends BaseStage
	{
		/** 是否已经打开 */
		private var _open:Boolean = false;
		
		public function DanmuOption()
		{
			super();
		}
		
		override protected function onAdded(e:Event):void
		{
			super.onAdded(e);
			this.graphics.lineStyle(1,0x333333);
			this.graphics.beginFill(0x000000,.8);
			this.graphics.drawRect(0,0,300,200);
			this.graphics.endFill();
			
			var _box:VBox = new VBox();
			_box.gap = 20;
			
			var sizeGroup:RadioGroup = new RadioGroup();
			var bigRadio:Radio = new Radio();
			bigRadio.label = "大";
			var midRadio:Radio = new Radio();
			midRadio.label = "中";
			var smallRadio:Radio = new Radio();
			smallRadio.label = "小";
			sizeGroup.group = [smallRadio,midRadio,bigRadio];
			var size:TextField = new TextField();
			size.defaultTextFormat = new TextFormat(FontUtil.fontName);
			size.autoSize = "left";
			size.textColor = 0xFFFFFF;
			size.text = "字体大小：";
			var sizeBox:HBox = new HBox();
			sizeBox.algin = HBox.MIDDLE;
			sizeBox.addChild(size);
			sizeBox.addChild(sizeGroup);
			_box.addChild(sizeBox);
			
			var styleGroup:RadioGroup = new RadioGroup();
			var topRadio:Radio = new Radio();
			topRadio.label = "顶部";
			var moveRadio:Radio = new Radio();
			moveRadio.label = "滚动";
			var bottomRadio:Radio = new Radio();
			bottomRadio.label = "底部";
			styleGroup.group = [topRadio,moveRadio,bottomRadio];
			var style:TextField = new TextField();
			style.defaultTextFormat = new TextFormat(FontUtil.fontName);
			style.autoSize = "left";
			style.textColor = 0xFFFFFF;
			style.text = "弹幕样式：";
			var styleBox:HBox = new HBox();
			styleBox.algin = HBox.MIDDLE;
			styleBox.addChild(style);
			styleBox.addChild(styleGroup);
			_box.addChild(styleBox);
			
			var color:TextField = new TextField();
			color.defaultTextFormat = new TextFormat(FontUtil.fontName);
			color.autoSize = "left";
			color.textColor = 0xFFFFFF;
			color.text = "弹幕颜色：";
			var colorPicker:Shape = new Shape();
			colorPicker.graphics.beginFill(0xff00000,.3);
			colorPicker.graphics.drawRect(0,0,200,100);
			colorPicker.graphics.endFill();
			var colorBox:HBox = new HBox();
			colorBox.algin = HBox.TOP;
			colorBox.addChild(color);
			colorBox.addChild(colorPicker);
			_box.addChild(colorBox);
			
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
			this.y = stage.stageHeight - this.height - 80;
			$.e.addEventListener(EventType.SWITCH_OPTION,onSwitch);
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
				$.a.fromTo(this,.5,{x:-this.width - 50},{x:10});
			}else{
				$.a.to(this,.5,{x:-this.width - 50});
			}
			_open = !_open;
		}
	}
}