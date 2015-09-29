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
	import com.idzeir.components.Style;
	
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 错误消息反馈
	 * @author iDzeir
	 */	
	public class ErrorRespondText extends TextField
	{
		/**
		 * 错误队列 
		 */		
		private var _map:Vector.<String> = new Vector.<String>();
		/**
		 * 是否正在显示
		 */		
		private var _busy:Boolean = false;
		/**
		 * 每个错误消息展示的毫秒数 
		 */		
		private const DELAY:uint = 2000;
		/**
		 * 错误消失点 
		 */		
		private var _missPoint:Point = new Point();
		
		public function ErrorRespondText()
		{
			super();
			
			$.e.addEventListener(EventType.ERROR,function(e:GlobalEvent):void
			{
				appendText(e.info.message+"\n")
			});
			
			this.alpha = .8
			this.selectable = this.mouseEnabled = false;
			this.autoSize = "left";
			this.defaultTextFormat = new TextFormat(Style.font,12,0xFFFFFF,true);
			this.filters = [new GlowFilter(0x999999,1,1,1,1,1)];
			
			this.addEventListener(Event.ADDED_TO_STAGE,function():void
			{
				removeEventListener(Event.ADDED_TO_STAGE,arguments.callee);
				_missPoint.x = stage.stageWidth + 5;
				_missPoint.y = stage.stageHeight - 100;
				y = _missPoint.y;
				visible = false;
				
				stage&&initStage();
			});
		}
		
		private function initStage():void
		{
			stage.addEventListener(Event.RESIZE,function():void
			{
				_missPoint.x = stage.stageWidth + 5;
				_missPoint.y = stage.stageHeight - 100;
				y = _missPoint.y;
			});
		}
		
		override public function appendText(newText:String):void
		{
			if(_busy)
			{
				_map.push(newText);
				return;
			}
			show(newText);
		}
		
		private function show(newText:String):void
		{
			super.htmlText = newText;
			visible = true;
			_busy = true;
			x = _missPoint.x;
			$.a.fromTo(this,.5,{x:_missPoint.x},{x:_missPoint.x - width - 30,onComplete:miss});
		}
		
		/**
		 * 错误消息消失
		 */		
		private function miss():void
		{
			$.t.call(DELAY,function():void
			{
				text = "";
				visible = false;
				if(_map.length>0)
				{
					show(_map.shift());
				}else{
					_busy = false;
				}
			},1);
		}		
		
	}
}