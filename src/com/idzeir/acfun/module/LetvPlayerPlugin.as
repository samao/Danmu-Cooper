/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jul 1, 2015 6:22:02 PM			
 * ===================================
 */

package com.idzeir.acfun.module
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	/**
	 * 乐视视频播放器兼容模块
	 */	
	public class LetvPlayerPlugin extends Sprite
	{
		public var _player:* = null;
		public var _api:* = null;
		public var _videoInfo:Object;
		
		public function LetvPlayerPlugin()
		{
			super();
			this.mouseEnabled = false;
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		
		public function playerURL(value:String,params:Object):void
		{
			var url:URLRequest = new URLRequest(value);
			var loader:Loader = new Loader();
			var _param:Object = {uu:"2d8c027396","auto_play":1,"start":0,"skinnable":0,"pu":"8e7e683c11"};
			for(var i:String in params)
			{
				_param[i] = params[i];
			}
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function():void{
				//letv sdk加载失败，可能是广告屏蔽等原因
			});
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function():void{
				_player = loader.content;
				_api = _player["api"];				
				_api.addEventListener("playState",onPlayerState);
				//默认码率
				_param["rate"] = "yuanhua";
				_api["setFlashvars"](_param);
			});
			var context:LoaderContext = new LoaderContext();
			//和兼容插件共享一个域，插件和主播放器不同域
			context.applicationDomain = ApplicationDomain.currentDomain;//播放器需要被放到一个安全域中
			if(context.hasOwnProperty("allowCodeImport"))
			{
				context["allowCodeImport"] = true;//允许播放器内部代码执行
			}    
			loader.load(url,context);
			addChild(loader);
		}
		
		private function onPlayerState(event:*):void
		{
			//trace("播放状态：",event.state);
			switch(event["state"])
			{
				case "loopOnKernel":
					this.dispatchEvent(new Event("play_progress"));
					break;
				//case "videoAuthValid":
				case "videoStartReady":
					_videoInfo = _api.getVideoSetting();
					break;
				case "videoStart":
					//多发一次 以免高级弹幕错位
					_videoInfo = _api.getVideoSetting();
					this.dispatchEvent(new Event("onPlay"));
					break;
				case "videoEmpty":
					break;
				case "videoResume":
					this.dispatchEvent(new Event("onResume"));
					break;
				case "videoPause":
					this.dispatchEvent(new Event("onPause"));
					break;
				case "videoFull":
					break;
				case "videoStop":
					this.dispatchEvent(new Event("onStop"));
					break;				
				case "errorInConfig":
				case "errorInLoadPlugins":
				case "errorInKernel":
					break;
				default:
					break;
			}
		}
		
		public function get time():Number
		{
			return _api.getVideoTime();
		}
	}
}