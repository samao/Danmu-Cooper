/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jul 3, 2015 11:48:47 AM			
 * ===================================
 */

package com.idzeir.acfun.module
{
	import com.idzeir.acfun.view.BaseStage;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	
	public class YoukuPlugin extends BaseStage implements IPlugin
	{
		public static const PLAYER_URL:String = "http://static.youku.com/v1.0.0447/v/swf/player_yk.swf";
		private var vid:String;
		private var cid:String;
		private var loader:Loader;
		public var player:Object;
		
		public static const PLAYER_TYPE:String = "youku";
		
		public function YoukuPlugin()
		{
			super();
			this.mouseEnabled = false;
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		
		/**
		 * 第三方播放器的地址
		 * @param value 地址路径
		 */		
		public function hooks(coopURL:String,stageParams:Object):void
		{
			if(loader)
			{
				return;
			}
			var checker:Function = function():void
			{
				if(stage)
				{
					$.t.remove(checker);
					loader = new Loader();
					loader.load(new URLRequest(coopURL.replace("{vid}",vid)),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPlayerComplete);
				}
			}
			$.t.call(100,checker)
			
		}
		
		override protected function onAdded(e:Event):void
		{
			super.onAdded(e);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//干掉优酷水印及推荐
			stage.addEventListener(Event.ADDED,function(event:Event):void{
				var obj:DisplayObject = event.target as DisplayObject;
				if (obj.toString().search("Logo") != -1)
					obj.parent.removeChild(obj);
			});
			
			
			vid = stage.loaderInfo.parameters["sourceId"] || stage.loaderInfo.parameters["vid"] || "XNzM0ODU2MDY0";
			cid = stage.loaderInfo.parameters["videoId"] || (PLAYER_TYPE + vid);
			
			//loader = new Loader();
			//if (Security.sandboxType == Security.REMOTE)			
				//loader.load(new URLRequest(PLAYER_URL.replace("{vid}",vid)),new LoaderContext(false,ApplicationDomain.currentDomain));			
			//else				
			//	loader.load(new URLRequest(PLAYER_URL.replace("{vid}",vid)),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPlayerComplete);
		}
		
		private var _lastTime:Number = 0;
		
		protected function checkPlayer():void
		{
			if (!player && loader.content && loader.content["exProxy"])
			{
				player = loader.content["exProxy"].playerProxy.playerData;
				//$.t.remove(checkPlayer);
			}
			if(_lastTime == time&&time!=player["videoTotalTime"]){
				this.dispatchEvent(new Event("onPause"));
			}else{
				_lastTime = time;
				this.dispatchEvent(new Event("onResume"));
				this.dispatchEvent(new Event("play_progress"));
				
				if(Math.abs(player["videoTotalTime"] - time)<3)
				{
					//_lastTime = 0;
					//this.dispatchEvent(new Event("onStop"));
				}
			}
		}
		
		public function get time():Number
		{
			return player.videoNsTime||0;
		}
		
		protected function onPlayerComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onPlayerComplete);
			$.t.call(200,checkPlayer);
			
			var p:Object = loader.content;
			addChildAt(p as DisplayObject,0);
			
			var layer:Sprite = new Sprite();
			this.addChild(layer);
			
			p.initPlayer(null,{"VideoIDS":vid,"isAutoPlay":true,"allowp2p":false,"ykstreamurl":"http://static.youku.com/v1.0.0435/v/swf/youkustreammnew.swf"},layer);
		}
	}
}