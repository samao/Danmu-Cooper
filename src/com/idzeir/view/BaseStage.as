/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 16, 2015 6:07:06 PM			
 * ===================================
 */

package com.idzeir.view
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * 舞台基类每个独立的swf必须对安全域单独进行授权，否则会出现域代码混乱
	 */	
	public class BaseStage extends Sprite
	{
		public function BaseStage()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
	}
}
