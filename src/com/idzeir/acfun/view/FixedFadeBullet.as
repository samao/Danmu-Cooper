/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jul 8, 2015 5:05:53 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.idzeir.acfun.manage.BulletType;
	import com.idzeir.acfun.vo.BulletVo;
	import com.idzeir.display.gif.Gif;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	
	/**
	 * 高级弹幕显示对象
	 */	
	public class FixedFadeBullet extends BaseBullet
	{
		/**
		 * 开始时间 
		 */		
		protected var _startTime:Number = 0;
		/**
		 * 持续时间
		 */		
		protected var _duration:Number = 0;
		
		protected var _line:TimelineLite = new TimelineLite({onComplete:onComplete});
		
		public var depth:int = 0;
		
		public function FixedFadeBullet()
		{
			super();
		}
		
		override public function update(time:Number=0):void
		{
			if((time-_startTime)>_duration)
			{
				this.mask = null;
				this.removeFromParent();
			}
		}
		
		public function onComplete():void
		{
			return;
			this.mask = null;
			this.removeFromParent();
			if(this._bulletVo&&this._bulletVo.addon.mask)
			{
				var mask:FixedFadeBullet = $.ui.getUseByName(this._bulletVo.addon.mask) as FixedFadeBullet;
				if(mask)
				{
					mask.onComplete();
				}
			}
		}
		
		override public function bullet(value:BulletVo, point:Point=null):IBullet
		{
			reset();
			
			super.bullet(value,point);
			
			//先不设置3d中心
			this.transform.perspectiveProjection = new PerspectiveProjection();
			this.transform.perspectiveProjection.projectionCenter = new Point(this.getResoultWidth(500),this.getResoultHeight(500));
			
			_duration = value.duration;
			_startTime = value.stime;
			
			var addinf:Object = value.addon;
			if (addinf.dep!=null) depth = addinf.dep;
			
			var fsty:Object = addinf.w||{};
			
			var filer:Array = [];
			if((fsty.l as Array) !=null)
			{
				var fi:Array = fsty.l;					
				var tmp:Object;
				for(var k:uint=0;k<fi.length;k++)
				{
					tmp = fi[k];
					if (tmp is Array)
					{
						filer.push(getFilter(tmp as Array));
					}
					else
					{
						filer.push(getFilter(fi));
						break;
					}	
				}
			}else{
				filer = [new GlowFilter(0, 0.7, 3,3),new DropShadowFilter(2, 45, 0, 0.6),new GlowFilter(0, 0.85, 4, 4, 3, 1, false, false)];
			}
			
			var gif:DisplayObject = null;
			if(fsty.g!=null&&fsty.g.d!=null)
			{
				gif = fsty.g.w==null?getNewData(fsty.g.d):getData(fsty.g.w,fsty.g.h,fsty.g.d);
				gif.filters = filer;
				this.addChild(gif);
			}
			
			//初始状态
			this.x = addinf.p==null?0:getResoultWidth(addinf.p.x);
			this.y = addinf.p==null?0:getResoultHeight(addinf.p.y);
			this.z = addinf.pz==null?0:addinf.pz;
			this.alpha = addinf.a==null?1:addinf.a;
			this.rotationX = addinf.rx==null?0:addinf.rx;
			this.rotationY = addinf.k == null?0:addinf.k;
			this.rotationZ = addinf.r==null?0:addinf.r;
			
			//缩放状态
			this.scaleX = addinf.e==null?1:addinf.e;
			this.scaleY = addinf.f==null?1:addinf.f;
			this.scaleZ = addinf.sz==null?1:addinf.sz;
			
			//先不启用渲染模式
			var BMS:Vector.<String> = new <String>[BlendMode.NORMAL,BlendMode.MULTIPLY,BlendMode.SCREEN,BlendMode.LIGHTEN,BlendMode.DARKEN,BlendMode.DIFFERENCE,BlendMode.ADD,BlendMode.SUBTRACT,BlendMode.INVERT,BlendMode.OVERLAY,BlendMode.HARDLIGHT,BlendMode.LAYER,BlendMode.ALPHA,BlendMode.ERASE];
			if(addinf.bm!=null)
			{
				var bm:int = int(addinf.bm);
				if(bm>0&&bm<BMS.length)
				{
					this.blendMode = BMS[bm];
				}
			}else{
				this.blendMode = BlendMode.NORMAL;
			}
			//先不事先锚点移动
			var cor:int = int(addinf.c);
			if(cor>0)this.transObj(this,cor,addinf.w==null||addinf.w.g==null);
			//动画持续时间
			var life:Number = addinf.l == null?3:addinf.l;
			_line.append(new TweenLite(this,life,{}));
			
			var zinf:Object;
			if(addinf.z!=null)
			{
				for(var i:int = 0;i<addinf.z.length;++i)
				{
					var to:Object = {};
					zinf = addinf.z[i];
					to.x = zinf.x==null?this.x:this.getResoultWidth(zinf.x);
					to.y = zinf.y==null?this.y:this.getResoultHeight(zinf.y);
					to.z = zinf.z==null?this.z:zinf.z;
					if(zinf.c!=null)
					{
						TweenPlugin.activate([TintPlugin]);
						to.tint = zinf.c;
					}
					to.rotationX = zinf.rx==null?this.rotationX:zinf.rx;
					to.rotationY = zinf.e==null?this.rotationY:zinf.e;
					to.rotationZ = zinf.d==null?this.rotationZ:zinf.d;
					
					to.scaleX = zinf.f==null?this.scaleX:zinf.f;
					to.scaleY = zinf.g==null?this.scaleY:zinf.g;
					to.scaleZ = zinf.sz==null?this.scaleZ:zinf.sz;
					
					to.alpha = zinf.t==null?this.alpha:zinf.t;
					
					var partLife:Number = zinf.l==null?life:zinf.l;
					switch(zinf.v)
					{
						case 1:
							to.ease = null;
							break;
						case 2:
							to.ease = Back.easeOut;
							break;
						case 3:
							to.ease = Back.easeIn;
							break
						case 4:
							to.ease = Back.easeInOut;
							break;
						case 5:
							to.ease = Bounce.easeOut;
							break;
						case 6:
							to.ease = Bounce.easeIn;
							break;
						case 7:
							to.ease = Bounce.easeInOut;
							break;
						default:
							to.ease = Linear.easeNone;
							break;
					}
					partLife = Math.max(0.000000001,partLife);
					_line.append(new TweenLite(this,partLife,to));
				}
			}
			
			if(addinf.bg!=null&&addinf.bh == true)
			{
				this.graphics.beginFill(16711680);
				this.graphics.drawCircle(0,0,2);
				this.graphics.endFill();
			}
			this._duration = this._line.duration;
			
			return this;
		}
		
		private function transObj(obj:DisplayObjectContainer,dock:int,textfix:Boolean):void
		{
			var numC:int = obj.numChildren;
			var w:Number = obj.width;
			var h:Number = obj.height;
			if(!textfix)
			{	
				var pic:DisplayObject = obj.getChildAt(0);
				if (pic is Loader)
				{
					if (pic["content"] == null)
					{
						pic["contentLoaderInfo"].addEventListener(Event.COMPLETE,function():void{
							pic["contentLoaderInfo"].removeEventListener(Event.COMPLETE,arguments.callee);
							transObj(obj,dock,textfix);
						});
						return;
					}
					else
					{
						w = pic["content"].width;
						h = pic["content"].height;
					}
				}
				w = obj.getChildAt(0).width;
				h = obj.getChildAt(0).height;
			}
			
			if(numC > 0)
			{
				for(var i:int = 0; i < numC; i++)
				{
					var s:DisplayObject = obj.getChildAt(i);
					switch(dock)
					{
						case 0:
							//this.x = this.y = 0;
							return;
						case 1:
							s.x -= w / 2;
							//this.y = 0;
							break;
						case 2:
							s.x -= w;
							break;
						case 3:
							s.y -= h / 2;
							break;
						case 4:
							s.x -= w / 2;
							s.y -= h / 2;
							break;
						case 5:
							s.x -= w;
							s.y -= h / 2;
							break;
						case 6:
							s.y -= h;
							break;
						case 7:
							s.x -= w / 2;
							s.y -= h;
							break;
						case 8:
							s.x -= w;
							s.y -= h;
							break;
						default:
							//this.x = this.y = 0;
							break;                            
					}
				}
			}
		}
		
		private function getResoultWidth(value:Number):Number
		{
			return value*864/1000;
		}
		
		private function getResoultHeight(value:Number):Number
		{
			return value*(526-40)/1000;
		}
		
		private function getData(w:int,h:int,data:String):DisplayObject
		{
			var baseText:String = data;
			var dec:Base64Decoder = new Base64Decoder();
			dec.decode(baseText);
			var bytes:ByteArray = dec.toByteArray();
			bytes.inflate();
			var bmd:BitmapData = new BitmapData(w,h,true,0);
			bmd.setPixels(new Rectangle(0,0,w,h),bytes);
			return new Bitmap(bmd,"auto",true);
		}
		private function getNewData(sdata:String):DisplayObject
		{
			//解出原始数据
			var dec:Base64Decoder = new Base64Decoder();
			dec.decode(sdata);
			var bytes:ByteArray = dec.toByteArray();
			try{
				var tag:String = bytes.readUTFBytes(3);
			}catch(e:Error){
				tag = "";
			}
			//判断是否gif
			if (tag == "GIF")
			{
				bytes.position = 0;
				var gif:Gif = new Gif();
				gif.smoothing = true;
				gif.loadBytes(bytes);
				return gif;
			}
			else
			{
				bytes.position = 0;
				var loader:Loader = new Loader();				
				loader.loadBytes(bytes);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function():void{
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,arguments.callee);
					(loader.content as Bitmap).smoothing = true;
				},false,0,true);
				return loader;
			}
		}	
		
		private function getFilter(tmp:Array):BitmapFilter
		{
			var filter:BitmapFilter;
			switch(tmp[0])
			{
				case 0:
					filter = new BlurFilter			(tmp[1],tmp[2],tmp[3]);
					break;
				case 1:
					filter = new GlowFilter			(tmp[1],tmp[2],tmp[3],tmp[4],tmp[5],tmp[6],tmp[7],tmp[8]);
					break;
				case 2:
					filter = new DropShadowFilter		(tmp[1],tmp[2],tmp[3],tmp[4],tmp[5],tmp[6],tmp[7],tmp[8],tmp[9],tmp[10],tmp[11]);
					break;
				case 3:
					filter = new BevelFilter			(tmp[1],tmp[2],tmp[3],tmp[4],tmp[5],tmp[6],tmp[7],tmp[8],tmp[9],tmp[10],tmp[11],tmp[12]);
					break;
				case 4:
					filter = new GradientGlowFilter	(tmp[1],tmp[2],tmp[3],tmp[4],tmp[5],tmp[6],tmp[7],tmp[8],tmp[9],tmp[10],tmp[11]);
					break;
				case 5:
					filter = new GradientBevelFilter	(tmp[1],tmp[2],tmp[3],tmp[4],tmp[5],tmp[6],tmp[7],tmp[8],tmp[9],tmp[10],tmp[11]);
					break;
				default:
					break;
			}
			return filter;
		}
		
		private function reset():void
		{
			this.graphics.clear();
			this.removeChildren();
			this.x = this.y = this.z = 0;
			this.rotationX = this.rotationY = this.rotationZ = 0;
			this.scaleX = this.scaleY = this.scaleZ = 1;
			this.alpha = 1;
			this.rotation = 0;
		}
		
		override public function get bulletType():String
		{
			return BulletType.FIXED_FADE_OUT;
		}
	}
}