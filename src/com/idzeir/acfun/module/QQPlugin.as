/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Sep 11, 2015 11:14:29 AM			
 * ===================================
 */

package com.idzeir.acfun.module
{
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.view.BaseStage;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	
	public class QQPlugin extends BaseStage implements IPlugin
	{
		public static const PLAYER_URL:String = "http://static.video.qq.com/TPswfout.swf";
		private var _vid:String;
		private var _videoId:String;
		private var loader:Loader;
		
		public var _player:Object;
		
		public function QQPlugin()
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
					loader.load(new URLRequest(coopURL),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPlayerComplete);
				}
				Log.warn("--------");
			}
			$.t.call(100,checker)
			
		}
		
		override protected function onAdded(e:Event):void
		{
			super.onAdded(e);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//干掉优酷水印及推荐
			/*stage.addEventListener(Event.ADDED,function(event:Event):void{
				var obj:DisplayObject = event.target as DisplayObject;
				if (obj.toString().search("Logo") != -1)
					obj.parent.removeChild(obj);
			});*/
			
			
			_vid = stage.loaderInfo.parameters["vid"] || "XNzM0ODU2MDY0";
			_videoId = stage.loaderInfo.parameters["videoId"] || "888856";
		}
		
		public function get time():Number
		{
			if(_player)
				return _player.swf_getPlaytime();
			return 0;
		}
		
		protected function onPlayerComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onPlayerComplete);
			
			_player = event.target.content;
			_player.swf_setPlayInfo({showfull:true,activeFullScreen:true});
			_player.swf_setSize(stage.stageWidth,stage.stageHeight);
			_player.swf_play(_vid);
			
			_player.addEventListener("SCREEN_FULL",function():void
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;	
			});
			_player.addEventListener("SCREEN_NORMAL",function():void
			{
				stage.displayState = StageDisplayState.NORMAL;	
			});
			
			$.t.call(1000,function():void
			{
				_player.dispatchEvent(new Event("PLAY_PROGRESS"));
			});
			
			stage.addEventListener(Event.RESIZE,function():void
			{
				_player.swf_setSize(stage.stageWidth,stage.stageHeight);
			});
			var p:Object = loader.content;
			addChildAt(p as DisplayObject,0);
		}
	}
}