/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Oct 29, 2015 5:58:23 PM			
 * ===================================
 */

package com.idzeir.module
{
	import com.idzeir.utils.Log;
	import com.idzeir.view.BaseStage;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	public class PptvPlugin extends BaseStage implements IPlugin
	{
		private var _vid:String;
		private var _videoId:String;
		private var _sourceId:String;
		
		private var loader:Loader;
		
		public var _player:Object;
		
		public function PptvPlugin()
		{
			super();
			this.mouseEnabled = false;
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		
		override protected function onAdded(e:Event):void
		{
			super.onAdded(e);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		public function hooks(coopURL:String, stageParams:Object):void
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
					
					var vars:URLVariables = new URLVariables();
					for (var i:* in stageParams)
					{
						if (i != "cid")
						{
							vars[i] = stageParams[i];
						}
					}
					_vid = stage.loaderInfo.parameters.hasOwnProperty("videoId")?stage.loaderInfo.parameters.videoId : "111134";
					_sourceId = stage.loaderInfo.parameters["sourceId"] ? String(stage.loaderInfo.parameters["sourceId"]) : "0a2enKyep6GhoJzHraGempzJramcnK2dqKE=";
					
					loader.load(new URLRequest(coopURL.replace("{sourceId}",_sourceId)),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPlayerComplete,false,0,true);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function():void
					{
						Log.error("PPTV视频播放器加载失败");
					},false,0,true);
				}
			}
			$.t.call(100,checker)
		}
		
		private function onPlayerComplete(e:Event):void
		{
			_player = e.target.content;
			
			//var tpp:InteractiveObject = _player as InteractiveObject;
			
			_player.addEventListener("onPlayStateChanged",onPlayStateChanged);
			_player.addEventListener("onVideoReady",onVideoReady);
			
			//			tpplayer.addEventListener("VIDEO_RESIZE",videoResizeHandler);// 视频区域大小更改
			addChild(_player as DisplayObject);
		}
		
		private function onVideoReady(e:*):void
		{
			//videoLength = e.param[1].duration;
		}		
		private function onPlayStateChanged(e:*):void{
			//			init加载完成
			//			ready初始化完毕
			//			start开始
			//			buffering缓冲
			//			playing播放
			//			paused暂停
			//			stopped用户手动停止
			//			ended自动播放结束
			switch(e.param[1]){
				case "1":
					break;
				case "2":
					break;
				case "3":
					dispatchEvent(new Event("onPlay"));
					if($.t.has(update))
					{
						$.t.remove(update);
					}
					$.t.call(200,update);
					break;
				case "4":
					break;
				case "5":
					dispatchEvent(new Event("onResume"));
					break;
				case "6":
					dispatchEvent(new Event("onPause"));
					break;
				case "7":
				case "8":
					dispatchEvent(new Event("onStop"));
					break;
			}
			
		}
		
		private function update():void{
			dispatchEvent(new Event("play_progress"))
		}
		
		public function get time():Number
		{
			if(!_player||!_player.playTime)return 0;
			return _player.playTime();
		}
	}
}
