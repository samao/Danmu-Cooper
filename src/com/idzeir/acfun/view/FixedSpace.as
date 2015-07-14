/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jul 10, 2015 5:12:25 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 高级弹幕空间
	 */	
	public class FixedSpace extends Sprite
	{
		public function FixedSpace()
		{
			super();
			this.mouseEnabled = false;
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		public function resize(w:Number, h:Number):void
		{
			
		} 
		
		protected function onAdded(event:Event):void
		{
			stage.addEventListener(Event.RESIZE,function():void
			{
				resize(stage.stageWidth,stage.stageHeight-40);
			});
		}
	}
}