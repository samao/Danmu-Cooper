/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jul 10, 2015 5:12:25 PM			
 * ===================================
 */

package com.idzeir.view
{
	import com.adobe.utils.StringUtil;
	import com.idzeir.vo.BulletVo;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 高级弹幕空间
	 */	
	public class FixedSpace extends Sprite
	{
		private var clip:Sprite;		
		private var scaleClip:Sprite;		
		private var videoClip:Sprite;
		
		private var width:Number = 0;
		private var height:Number = 0;
		
		private var videoWidth:Number;
		private var videoHeight:Number;
		
		private const defaultRect:Rectangle = new Rectangle(0,0,864,526-40);
		
		public function FixedSpace()
		{
			this.clip = this;
			scaleClip = new Sprite();
			scaleClip.name = "scaleClip";
			scaleClip.graphics.lineStyle(0,0,0);
			scaleClip.graphics.drawRect(0,0,defaultRect.width,defaultRect.height);
			videoClip = new Sprite();
			videoClip.name = "videoClip";
			videoClip.graphics.lineStyle(0,0,0);
			videoClip.graphics.drawRect(0,0,defaultRect.width,defaultRect.height);
			scaleClip.addChild(videoClip);
			clip.addChild(scaleClip);
			
			this.addEventListener(Event.ADDED_TO_STAGE,function():void
			{
				var m:Sprite = new Sprite();
				m.graphics.beginFill(0);
				m.graphics.drawRect(0,0,defaultRect.width,defaultRect.height);
				m.graphics.endFill();
				mask = m;
				//resize(stage.stageWidth,stage.stageHeight - 40);
			});
			
		}
		
		public function getComment(data:BulletVo):IBullet
		{
			return new FixedFadeBullet().bullet(data,new Point(defaultRect.width,defaultRect.height));
			if (isScaleComment(data))
				return new FixedFadeBullet().bullet(data,new Point(defaultRect.width,defaultRect.height));
			else
				return new FixedFadeBullet().bullet(data);
		}
		
		public function resize(width:Number, height:Number):void
		{
			//this.width = width;
			//this.height = height;
			//计算缩放区域的比例和位置			
			var videoRect:Rectangle = new Rectangle(0,0,videoWidth,videoHeight);
			var rect1:Rectangle = getCenterRectangle(defaultRect,videoRect);
			var rect2:Rectangle = getCenterRectangle(new Rectangle(0,0,width,height),videoRect);
			scaleClip.scaleX = scaleClip.scaleY = rect2.width / rect1.width; 	//直接设置宽度会有副作用
			scaleClip.x = (width - defaultRect.width * scaleClip.scaleX) / 2;
			scaleClip.y = (height - defaultRect.height * scaleClip.scaleY) / 2;
		} 
		
		private function getCenterRectangle(container:Rectangle,target:Rectangle):Rectangle
		{
			var sx:Number = 1;
			var sy:Number = 1;
			if (target.width > 0 && target.height > 0)			
			{
				sx = container.width / target.width;
				sy = container.height / target.height;	
			}
			
			var x:Number,y:Number,w:Number,h:Number;
			if (sx < sy)
			{
				w = target.width * sx;
				h = target.height * sx;
				x = 0;
				y = (container.height - h) / 2;
			}
			else
			{
				w = target.width * sy;
				h = target.height * sy;
				x = (container.width - w) / 2;
				y = 0;
			}
			return new Rectangle(x,y,w,h);
		}
		
		public function start(data:BulletVo,from:Number=0):void
		{
			/** 在终结前不再被渲染 **/
			//data.on = true;
			
			//高级弹幕不同版本
			var clip:Sprite = this.clip;
			if (isScaleComment(data))
			{
				if (isInVideoComment(data))
					clip = videoClip;
				else
					clip = scaleClip;	
			}
			//是否关联父容器
			var parent:FixedFadeBullet = getCommentByName(data.addon.parent);
			if (parent)
				clip = parent;
			
			var cmt:IBullet = getComment(data);
			/** 添加到舞台 **/
			for (var i:int=0;i<clip.numChildren;i++)
			{
				var child:FixedFadeBullet = clip.getChildAt(i) as FixedFadeBullet;
				if (child)
				{
					if (child["depth"] > cmt["depth"])
					{
						break;
					}
				}
			}
			
			//名称为mask开头的默认为遮罩
			if (cmt.getBullet().name&& StringUtil.beginsWith(cmt.getBullet().name,"mask"))
				DisplayObject(cmt).visible = false;
			
			clip.addChildAt(DisplayObject(cmt),i);
			//clip.addChild(cmt.warp);
			
			//是否有遮罩
			var mask:FixedFadeBullet = getCommentByName(data.addon.mask);
			if (mask)
			{
				mask.visible = true;
				mask.cacheAsBitmap = true;
				cmt["cacheAsBitmap"] = true;
				cmt["mask"] = mask;
			}
		}
		
		private function isScaleComment(s:BulletVo):Boolean
		{
			return s.addon["ver"] == 2;
		}
		
		private function isInVideoComment(s:BulletVo):Boolean
		{
			return s.addon["ovph"];
		}
		
		private function getCommentByName(name:String):FixedFadeBullet
		{
			if (name != null && name != "")
			{
				for each (var s:IBullet in $.ui.useMap)
				{
					if (s.getBullet().name == name)
					{
						return s as FixedFadeBullet;
					}
				}				
			}
			return null;
		}
	}
}
