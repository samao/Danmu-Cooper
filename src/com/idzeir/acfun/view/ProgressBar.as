/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 17, 2015 2:21:52 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.utils.FontUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 初始化进度条
	 */	
	public class ProgressBar extends Sprite
	{
		private var _info:TextField;
		
		public function ProgressBar()
		{
			super();
			
			var tf:TextFormat = new TextFormat(FontUtil.fontName,12,0xffffff,true)
			
			$.e.addEventListener(EventType.PROGRESS,function(e:GlobalEvent):void
			{
				_info ||= new TextField();
				_info.mouseEnabled = false;
				_info.autoSize = "left";
				_info.defaultTextFormat = tf;
				_info.htmlText = e.info;
				addChild(_info);
				algin();
			});
		}
		
		private function algin():void
		{
			if(stage)
			{
				_info.x = stage.stageWidth - _info.width >> 1;
				_info.y = stage.stageHeight - _info.height >> 1;
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			}
		}
		
		protected function onAdded(event:Event):void
		{
			stage.addEventListener(Event.RESIZE,resizeHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		
		protected function onRemove(event:Event):void
		{
			stage.removeEventListener(Event.RESIZE,resizeHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		
		protected function resizeHandler(event:Event):void
		{
			algin();
		}
	}
}