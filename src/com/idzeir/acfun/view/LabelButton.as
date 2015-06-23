/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 15, 2015 4:46:04 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import com.idzeir.acfun.utils.FontUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * label按钮
	 */	
	public class LabelButton extends Sprite
	{
		
		private var _label:TextField;
		
		public function LabelButton(label:String,click:Function = null)
		{
			super();
			_label = new TextField();
			
			_label.autoSize = "left";
			_label.selectable = false;
			_label.htmlText = label;
			_label.defaultTextFormat = new TextFormat(FontUtil.fontName,12,null,true);
			
			_label.background = true;
			_label.backgroundColor = Math.random()*0xffffff;
			this.addChild(_label);
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			if(click)
			{
				this.addEventListener(MouseEvent.CLICK,click);
			}
		}
	}
}