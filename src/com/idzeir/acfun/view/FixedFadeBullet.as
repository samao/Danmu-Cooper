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
		
		/** 空间分配索引,记录所占用的弹幕空间层 **/
		protected var _index:int;
		protected var fileterOff:Boolean = true;
		private var _color:int;
		private var isInited:Boolean = false;
		private var BMS:Vector.<String> = new <String>[BlendMode.NORMAL,BlendMode.MULTIPLY,BlendMode.SCREEN,BlendMode.LIGHTEN,BlendMode.DARKEN,BlendMode.DIFFERENCE,BlendMode.ADD,BlendMode.SUBTRACT,BlendMode.INVERT,BlendMode.OVERLAY,BlendMode.HARDLIGHT,BlendMode.LAYER,BlendMode.ALPHA,BlendMode.ERASE];
		private var centerPP:PerspectiveProjection;
		public var _width:Number = 864;
		public var _height:Number = 526-40;
		/**
		 * 深度 
		 */		
		public var depth:int=0;
		
		
		public function FixedFadeBullet()
		{
			super();
		}
		
		override public function update(time:Number=0):void
		{
			if((time-_startTime)>_duration)
			{
				_line.clear();
				this.mask = null;
				this.removeFromParent();
				return;
			}
		}
		
		public function onComplete():void
		{
			if(mask!=null&&mask.parent)
			{
				mask.parent.removeChild(mask);
			}
		}
		
		override public function bullet(value:BulletVo, point:Point=null):IBullet
		{
			this.reset();
			
			this.addChild(_txt);
			var W:Number = _width;
			var H:Number = _height;			
			var addinf:Object = value.addon;
			var i:int;
			if (addinf.dep!=null) depth = addinf.dep;			
			var fsty:Object = addinf.w;
			//			fsty = {f:config.font,b:config.bold,l:{t:1,c:0xCC0000,a:1,x:9,y:9,s:2,b:true,k:false}}
			//			fsty = {g:{w:10,h:10,d:'NYzbK0MBHMc9+R88aB5cUrbyJpcX1ExnLqGmXDfD2+aBkge5x9ommzENjbl00Ij2wGjhuCzOw8a0NjNpS6L1M6X28nVefOtb3099+2yLxV6qqvKRRhOkvr5nUqmCVF/vJ4UiIHAoIWyjRHKbksl8uLj4hdebhMfzhmg0gf9w3Cfu75MphvGTVhvC5eUX0tNPkZZmhdXqQyTyAYbZFHgbbndC8IapuzsMuz2OpqYrwRlHLPYj/JJYW+Mhlx/CYgmQWh2iLjWP2Vk/5uYiYFkWZWVKVFZacHsTgdl2DG3/LimVj9TYcQKjnoekQAf/Qxiv0Q+h34i+vIOpGcL4lIsa28+phrELm4e4sA0rth3c8XGw+9dw7nHIEjVgeIKjWvk6FZfqYF4NYuvoDbn5vejtMSFD1Imx0QOoVHroZg5I0WxLZedNYmTiG2cewibLweEIYH45CMfGE1wuH5zO11RJicEkEg1STvY0VZTrqbVliWSyeaquXSCp1Ex1dYtUVGQwZWYO/AE='}}
			if (fsty == null) 
			{	
				// fontStyle
				fsty = {};
			}
			else
			{
				var filer:Array;
				if((fsty.l as Array) !=null)
				{
					var fi:Array = fsty.l;					
					var tmp:Object;
					filer = [];
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
					fileterOff = false;
				}
				
				var gr:DisplayObject = null;
				
				if(fsty.g != null && fsty.g.d != null)
				{
					if (fsty.g.w == null)
					{
						//新版图片弹幕，支持gif动画
						gr = getNewData(fsty.g.d);
					}
					else
					{
						//兼容旧版
						gr = getData(fsty.g.w,fsty.g.h,fsty.g.d);	
					}
					if(addinf.b){gr.scaleX = gr.scaleY = (value.size)/Math.max(fsty.g.w,fsty.g.h)}
					if (gr)
					{
						gr.filters = filer;	//图片弹幕滤镜
						addChild(gr);
					}
				}
				
				//				if(fsty.f==null){fsty.f=config.font;}
				//				if(fsty.b==null){fsty.b=config.bold;}
			}
			
			//			if(addinf.bh!=null&&addinf.bh==true){debug=true;}
			
			/** 字幕形式，是普通字幕还是绘图指令 **/
			var isb:Boolean = (addinf.b == null) ? true:addinf.b;
			if(isb && fileterOff)
			{
				if(value.color == 0)
					filer = [new GlowFilter(16777215, 1, 2,2,1.5,1)];
				else 
					filer = [[new GlowFilter(0, 0.7, 3,3)],[new DropShadowFilter(2, 45, 0, 0.6)],[new GlowFilter(0, 0.85, 4, 4, 3, 1, false, false)]];
			}
			
			var sx:Number = addinf.e||1;
			var sy:Number = addinf.f||1;
			var maxl:Number = addinf.l;
			if(addinf.z!= null)
			{
				var lastSx:Number = sx;
				var lastSy:Number = sy;
				for(i = 0;i<addinf.z.length;i++)
				{                    
					zinf = addinf.z[i];
					
					var update:Boolean = false;
					
					if (zinf.f != null)
					{
						lastSx = zinf.f;						
					}
					else
					{
						if (zinf.l > maxl)
						{					
							sx = lastSx;
							update = true;
						}
					}
					
					if (zinf.g != null)
					{
						lastSy = zinf.g;
					}
					else
					{
						if (zinf.l > maxl)
						{					
							sy = lastSy;
							update = true;
						}
					}
					
					if (update)
						maxl = zinf.l;
				}
				
				if (maxl == 0)
				{
					sx = lastSx;
					sy = lastSy;
				}
			}
			/** 解析出来初始字体，大小，颜色，是否粗体，边界颜色，文字信息 **/
			super.bullet(value,point);
			/** 字幕形式，是普通字幕还是绘图指令 **/
			var commentType:uint = (addinf.t != null ) ? addinf.t : 0;
			
			var xbase:Number = 0,ybase:Number = 0;
			
			/** 初始位置 **/
			if(addinf.p != null)
			{
				this.x = int(addinf.p.x * W / 1000 + xbase);
				this.y = int(addinf.p.y * H / 1000 + ybase);
			}
			
			if(addinf.pz != null)
			{
				this.z = addinf.pz;
			}
			//var stap:CommentPos = (commentObject.p != null) ? new CommentPos(commentObject.p.x,commentObject.p.y) : new CommentPos(0,0);
			//_user = data.user;
			/** 初始透明度 **/
			var startalpha:Number = (addinf.a == null) ? 1:addinf.a;
			
			/** 转角 **/
			//			if(addinf.pz != null){local3d = true;}
			
			if(addinf.rx != null)
			{
				this.rotationX = addinf.rx;			
			}
			if(addinf.k != null)
			{
				this.rotationY = addinf.k;				
			}
			if(addinf.r != null)
			{
				this.rotationZ = addinf.r;
			}
			
			//设置3d中心为视频正中间
			if (centerPP == null)
			{
				var pp:PerspectiveProjection = new PerspectiveProjection();
				pp.projectionCenter = new Point(W/2,H/2);
				centerPP = pp;
			}
			//this.transform.perspectiveProjection = centerPP;
			
			/** XY缩放 **/
			if(addinf.e != null)this.scaleX = addinf.e;
			if(addinf.f != null)this.scaleY = addinf.f;
			if(addinf.sz != null)this.scaleZ = addinf.sz;
			
			if(addinf.bm != null)
			{
				var bm:int = int(addinf.bm);
				if(0<bm && bm<BMS.length){this.blendMode = BMS[bm];}
			}		
			
			/** 生存周期 **/
			var life:Number = (addinf.l != null) ? addinf.l : 3;
			
			/** 锚点 **/
			var cor:int = int(addinf.c);
			if(cor > 0)transObj(this,cor,addinf.w==null||addinf.w.g==null);
			
			/** 初始化 **/
			this.alpha = startalpha ;//* config.alpha;
			
			/** 初始化计算,Sleep无变化参数 */
			_line.append(new TweenLite(this,life,{}));
			var zinf:Object;
			if(addinf.z!= null)
			{
				for(i=0;i<addinf.z.length;i++)
				{                    
					var moveObj:Object = new Object();
					var mt:Number = 3;
					zinf = addinf.z[i];
					if(zinf.x != null)moveObj.x = zinf.x * W / 1000 + xbase;
					if(zinf.y != null)moveObj.y = zinf.y * H / 1000 + ybase;
					if(zinf.z != null)moveObj.z = zinf.z;
					if(zinf.c != null)
					{
						if(!isInited)
						{
							isInited = true;
							TweenPlugin.activate([TintPlugin]);
						}
						moveObj.tint = zinf.c;
					}
					if(zinf.rx != null)
					{moveObj.rotationX = zinf.rx;}
					if(zinf.e != null)
					{moveObj.rotationY = zinf.e;}
					if(zinf.d != null)
					{
						moveObj.rotationZ = zinf.d;
					}
					
					if(zinf.f != null)moveObj.scaleX = zinf.f;
					if(zinf.g != null)moveObj.scaleY = zinf.g;
					if(zinf.sz != null)moveObj.scaleZ = zinf.sz;
					
					if(zinf.t != null)moveObj.alpha = zinf.t;
					
					if(zinf.l != null)mt = zinf.l;
					else mt = 3;
					moveObj.ease = Linear.easeNone;
					if(zinf.v != null)
					{
						/** GLOP EARSE FUNCTIONS**/
						var s:int = zinf.v;
						switch(s)
						{
							case 0:
								break;
							case 1:
								moveObj.ease = null;
								break;
							case 2:
								moveObj.ease = Back.easeOut;
								break;
							case 3:
								moveObj.ease = Back.easeIn;
								break;
							case 4:
								moveObj.ease = Back.easeInOut;
								break;
							case 5:
								moveObj.ease = Bounce.easeOut;
								break;
							case 6:
								moveObj.ease = Bounce.easeIn;
								break;
							case 7:
								moveObj.ease = Bounce.easeInOut;
								break;
							default:
								break;
						}
					}
					if(mt == 0)mt = 0.000000001;
					_line.append(new TweenLite(this,mt,moveObj));
				}
			}
			
			if(addinf.bh!=null&&addinf.bh==true)
			{
				this.graphics.beginFill(16711680);
				this.graphics.drawCircle(0,0,2);
				this.graphics.endFill();
			}
			
			this._startTime = value.stime;
			this._duration = this._line.duration;
			
			this.cacheAsBitmap = false;
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