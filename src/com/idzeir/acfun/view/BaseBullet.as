/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 17, 2015 1:45:45 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import com.idzeir.acfun.utils.FontUtil;
	import com.idzeir.acfun.vo.BulletVo;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 弹幕显示ui基类
	 */	
	public class BaseBullet extends TextField implements IBullet
	{
		protected var tf:TextFormat = new TextFormat();
		
		public function BaseBullet()
		{
			super();
			
			this.selectable = false;
			this.autoSize = "left";
			this.tf.font = FontUtil.fontName;
			this.tf.size = 25;
			this.tf.color = 0xffffff;
			this.defaultTextFormat = tf;
			
			this.filters = [new DropShadowFilter(1,-135,0,1,1,1),new DropShadowFilter(1,45,0,1,1,1)];
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			$.u.useMap.push(this);
		}
		
		protected function onRemoved(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			$.u.recyle(this);
		}
		
		public function update(time:int=0):void
		{
			
		}
		
		public function get bulletType():String
		{
			return "-1";
		}
		
		public function bullet(value:BulletVo,point:Point = null):IBullet
		{
			this.tf.size = value.size;
			this.tf.color = value.color;
			
			this.defaultTextFormat = this.tf;
			this.text = value.message;
			//重置位置
			x = y = 0;
			return this
		}
		
		protected function removeFromParent():void
		{
			try
			{
				this.parent.removeChild(this);
			}catch(error:Error){};
		}
		
		public function get warp():DisplayObject
		{
			return this;
		}
	}
}