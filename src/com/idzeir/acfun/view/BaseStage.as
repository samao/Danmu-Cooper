/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 16, 2015 6:07:06 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	
	/**
	 * 舞台基类
	 */	
	public class BaseStage extends Sprite
	{
		public function BaseStage()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
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