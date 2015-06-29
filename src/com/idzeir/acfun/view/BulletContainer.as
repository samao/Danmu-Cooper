/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 9, 2015 3:08:08 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.manage.BulletType;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.utils.NodeUtil;
	import com.idzeir.acfun.vo.BulletVo;
	import com.idzeir.acfun.vo.Node;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 弹幕显示容器
	 */	
	public class BulletContainer extends Sprite
	{
		/**
		 * 顶部固定容器 
		 */		
		private var _topBox:VBox;
		private var _bottomBox:VBox;
		/**
		 * 移动弹幕容器 
		 */		
		private var _moveBox:Sprite;
		
		private var _lastTime:int = 0;
		
		private const HGAP:int = 30;
		private const VGAP:int = 35;
		/**
		 * 更新的频率 
		 */		
		private const FRAME:int = 10;
		
		private var _useMap:Vector.<LineBox> = new Vector.<LineBox>();
		private var _isRunning:Boolean = false;
		/**
		 * 弹幕太多无法显示暂时缓存数据 
		 */		
		private var _overMap:Vector.<Node> = new Vector.<Node>();
		
		/**
		 * 两次更新时间介个此时间之内都会不会seek跳过，直接显示 
		 */		
		private const BLOCK_TIME:int = 3;
		
		public function BulletContainer()
		{
			super();
			Log.info("初始化弹幕显示容器");
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		public function start():void
		{
			if(!$.t.has(update))
			{
				$.t.call(FRAME,update);
			}
			_isRunning = true;
		}
		
		public function pause():void
		{
			_isRunning = false;
		}
		
		public function resume():void
		{
			_isRunning = true;
		}
		
		public function stop():void
		{
			if($.t.has(update))
			{
				$.t.remove(update);
			}
			_isRunning = false;
		}
		
		public function time(value:Number):void
		{
			if(value == _lastTime)return;
			//此处seek会丢失显示
			if(Math.abs(value - _lastTime)>BLOCK_TIME)
			{
				//seek
				$.b.seek(value);
				//清理正在显示的数据
				clear();
			}
			
			_lastTime = value;
			var node:Node = $.b.timeNode;
			
			var index:int = 0;
			while(node&&(NodeUtil.get(node)).stime<=value)
			{
				addBullet(node,index++);
				$.b.nextTime();
				node = $.b.timeNode;
			}
		}
		
		/**
		 * 清理舞台现有的弹幕
		 */		
		private function clear():void
		{
			for each(var i:LineBox in _useMap)
			{
				i.removeChildren();
			}
		}
		
		protected function onAdded(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			_topBox ||= new VBox();
			_topBox.algin = VBox.CENTER;
			
			_moveBox ||= new Sprite();
			
			_bottomBox ||=new VBox();
			_bottomBox.algin = VBox.CENTER;
			
			for(var i:uint = 0;i<stage.stageHeight;i=i+VGAP)
			{
				var lineBox:LineBox = LineBox.create(0,i,stage.stageWidth,VGAP);
				_moveBox.addChild(lineBox);
				_useMap.push(lineBox);
			}
			this.addChild(_moveBox);
			this.addChild(_topBox);
			this.addChild(_bottomBox);
			//this.addChild(new BulletProfile());
			
			$.e.addEventListener(EventType.SWITCH_BULLET,function():void
			{
				visible = !visible;
			});
			
			$.e.addEventListener(EventType.RECIVE,function(e:GlobalEvent):void
			{
				Log.debug("收到websocket数据:",JSON.stringify(e.info))
				
				var bullet:BulletVo = new BulletVo();
				bullet.color = int(e.info.color);
				bullet.commentId = e.info.commentid;
				bullet.mode = e.info.mode;
				bullet.message = e.info.message;
				bullet.stime = Number(e.info.stime);
				bullet.size = Number(e.info.size);
				bullet.user = e.info.user;
				
				var node:Node = new Node(bullet);
				$.b.add(node);
				addBullet(node);
			});
		}
		
		protected function update():void
		{
			if(!_isRunning)return;
			
			for each(var i:IBullet in $.ui.useMap)
			{
				i.update();
			}
		}
		
		/**
		 * 添加弹幕显示 
		 * @param value 弹幕数据
		 * @param index 弹幕显示距离，同一时间显示多个弹幕，出现的x偏移量
		 */		
		private function addBullet(value:Node,index:int = 0):void
		{
			//Log.debug("显示弹幕:",NodeUtil.get(value).mode,NodeUtil.get(value).message);
			switch(NodeUtil.get(value).mode)
			{
				case BulletType.FADE_OUT_TOP:
					addTopBullet(value);
					break;
				case BulletType.FADE_OUT_BOTTOM:
					addBottomBullet(value);
					break;
				default:
					addMoveBullet(value,index);
					break;
			}
		}
		
		private function addBottomBullet(value:Node):void
		{
			//Log.debug("固定底部弹幕",NodeUtil.get(value).message);
			const BUTTOM_BAR_H:int = 50;
			_bottomBox.addChild($.ui.create(BulletType.FADE_OUT_BOTTOM).bullet(NodeUtil.get(value),new Point()).warp);
			_bottomBox.x = stage.stageWidth - _bottomBox.width>>1;
			_bottomBox.y = stage.stageHeight - _bottomBox.height - BUTTOM_BAR_H;
		}
		
		private function addTopBullet(value:Node):void
		{
			//Log.debug("固定顶部弹幕",NodeUtil.get(value).message);
			_topBox.addChildAt($.ui.create(BulletType.FADE_OUT_TOP).bullet(NodeUtil.get(value),new Point()).warp,0);
			_topBox.x = stage.stageWidth - _topBox.width>>1;
		}
			
		/**
		 * 添加移动弹幕
		 * @param value
		 * @param index
		 */		
		private function addMoveBullet(value:Node,index:int = 0):void
		{
			//Log.debug("移动弹幕",NodeUtil.get(value).message);
			//偏移量
			const OFFX:int = 5;
			for each(var i:LineBox in _useMap)
			{
				var rect:Rectangle = i.getBounds(this);
				
				if((rect.right + HGAP)<=stage.stageWidth)
				{
					i.addChild($.ui.create(BulletType.RIGHT_TO_LEFT).bullet(NodeUtil.get(value),new Point(stage.stageWidth+index*OFFX,VGAP)).warp);
					return;
				}
			}
			
			Log.warn("弹幕太多无法显示,等待空间",NodeUtil.get(value).message);
			addToOverMap(value);
		}
		
		/**
		 * 没有空间显示，加入等待队列
		 */		
		private function addToOverMap(value:Node):void
		{
			_overMap.push(value);
			checkOverMap();
		}
		
		/**
		 * 迭代延时循环添加弹幕
		 */		
		private function checkOverMap():void
		{
			if(_overMap.length > 0)
			{
				addBullet(_overMap.shift());
				$.t.call(1,checkOverMap,1,true);
			}
		}
	}
}
import flash.display.Sprite;


class LineBox extends Sprite
{
	private static var _map:Vector.<LineBox> = new Vector.<LineBox>();
	
	public static function create(xpos:int,ypos:int,w:int,h:int):LineBox
	{
		if(_map.length == 0)
		{
			var box:LineBox = new LineBox();
			box.mouseEnabled = false;
			box.mouseChildren = false;
			box.graphics.beginFill(Math.random()*0xffffff,0);
			box.graphics.drawRect(0,0,0,h);
			box.graphics.endFill();
			box.x = xpos;
			box.y = ypos;
			_map.push(box);
		}
		return _map.shift();
	}
	
	public function recyle():void
	{
		this.removeChildren();
		_map.push(this);
	}
	
	public static function get map():Vector.<LineBox>
	{
		return _map;
	}
}