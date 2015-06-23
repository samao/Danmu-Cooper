/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 15, 2015 4:42:41 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setInterval;
	
	/**
	 * 弹幕性能统计
	 */	
	public class BulletProfile extends Sprite
	{
		private var _txt:TextField;
		
		public function BulletProfile()
		{
			super();
			
			/*this.graphics.beginFill(0x000000,.7);
			this.graphics.drawRect(0,0,300,200);
			this.graphics.endFill();*/
			_txt = new TextField();
			_txt.autoSize = "left";
			_txt.textColor = 0xffffff;
			this.addChild(_txt);
			
			var close:LabelButton = new LabelButton("<font color='#ffffff'>关闭</font>",onClick);
			
			close.x = this.width - close.width - 3;
			close.y = 3;
			//this.addChild(close);
			
			setInterval(function():void
			{
				_txt.text ="创建弹幕: "+(MoveBullet.useMap.length+MoveBullet.unUseMap.length)+" " +
					"\n回收池弹幕: "+MoveBullet.unUseMap.length+" " +
					"\n显示弹幕: " + MoveBullet.useMap.length;
							
			},1000);
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}