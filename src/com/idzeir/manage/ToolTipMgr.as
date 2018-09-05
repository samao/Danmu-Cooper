/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	2016,5:29:02 PM		
 * ===================================
 */

package com.idzeir.manage
{
	import com.idzeir.components.v2.Style;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * tips管理器
	 */	
	public class ToolTipMgr implements IToolTipMgr
	{
		private var _map:Dictionary = new Dictionary(true);
		
		private static var _instance:ToolTipMgr;
		
		private static var _tipBox:Sprite;
		
		private static var _tipTxt:TextField;
		
		private var _active:*;
		
		public function ToolTipMgr()
		{
			
		}
		
		public static function getInstance():ToolTipMgr
		{
			return _instance ||= new ToolTipMgr();
		}
		
		public function setupLayer(layer:Sprite):void
		{
			_tipBox ||= layer;
			_tipTxt ||= new TextField();
			_tipTxt.autoSize = "left";
			_tipTxt.defaultTextFormat = new TextFormat(Style.font,12,0xFFFFFF);
			_tipTxt.mouseEnabled = _tipTxt.selectable = false;
			_tipBox.addChild(_tipTxt);
			layer.mouseChildren = layer.mouseEnabled = false;
		}
		
		public function add(target:InteractiveObject, tips:String):void
		{
			_map[target] = tips;
			!has(target)&&bind(target,true);
			if(_active==target)
			{
				_tipTxt.text = tips;
			}
		}
		
		public function remove(target:InteractiveObject):void
		{
			has(target)&&bind(target,false);
		}
		
		/**
		 * tip对象的事件绑定
		 * @param target 交互对象
		 * @param destroy 绑定还是解绑
		 */		
		private function bind(target:InteractiveObject,destroy:Boolean = false):void
		{
			if(destroy)
			{
				//删除注册
				target.addEventListener(MouseEvent.ROLL_OVER,overHandler);
				target.addEventListener(MouseEvent.ROLL_OUT,outHandler);
			}else{
				//添加注册
				target.removeEventListener(MouseEvent.ROLL_OVER,overHandler);
				target.removeEventListener(MouseEvent.ROLL_OUT,outHandler);
			}
		}
		
		private function overHandler(e:MouseEvent):void
		{
			_active = e.currentTarget;
			_tipTxt.visible = true;
			_tipTxt.text = _map[e.currentTarget];
			/*_tipTxt.background = true;
			_tipTxt.backgroundColor = 0x000000;
			_tipTxt.border = true;
			_tipTxt.borderColor = 0x999999;*/
			updatePos(e.stageX,e.stageY,e.currentTarget);
			_tipBox.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
		}
		
		private function outHandler(e:MouseEvent):void
		{
			_active = null;
			_tipTxt.visible = false;
			_tipTxt.text = "";
			_tipTxt.background = false;
			_tipTxt.border = false;
			_tipBox.graphics.clear();
			_tipBox.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
		}
		
		private function moveHandler(e:MouseEvent):void
		{
			updatePos(e.stageX,e.stageY,e.currentTarget);
		}
		
		private function updatePos(xpos:Number,ypos:Number,tar:*):void
		{
			var rect:Rectangle = (tar as DisplayObject).getBounds((tar as DisplayObject).stage);
			_tipTxt.x = rect.left+(rect.width - _tipTxt.width >>1);
			_tipTxt.y = (rect.top - _tipTxt.height - 10);
			
			const SPACE:uint = 2;
			var bgRect:Rectangle = _tipTxt.getBounds(_tipBox);
			_tipBox.graphics.clear();
			_tipBox.graphics.lineStyle(1,0xFFFFFF,.5)
			_tipBox.graphics.beginFill(0x000000,.8);
			_tipBox.graphics.drawRoundRect(bgRect.left - SPACE,bgRect.top - SPACE,bgRect.width + 2 * SPACE,bgRect.height + 2 * SPACE,5,5);
			_tipBox.graphics.endFill();
		}
		
		private function has(target:InteractiveObject):Boolean
		{
			return _map.hasOwnProperty(target);
		}
	}
}
