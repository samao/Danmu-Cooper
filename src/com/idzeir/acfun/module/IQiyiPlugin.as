/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Oct 10, 2015 4:09:00 PM			
 * ===================================
 */

package com.idzeir.acfun.module
{
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.view.BaseStage;
	
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
	
	/**
	 * 爱奇艺播放器代理组件
	 * @author iDzeir
	 */	
	public class IQiyiPlugin extends BaseStage implements IPlugin
	{
		private var _vid:String;
		private var _videoId:String;
		private var loader:Loader;
		
		public var _player:Object;
		
		private var isStartPlay:Boolean = false;
		
		private var lastTime:Number = 0;
		
		public function IQiyiPlugin()
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
		
		public function hooks(coopURL:String,stageParams:Object):void
		{
			if(loader)
			{
				return;
			}
			var url:String = coopURL+"?coop=coop_acfun&cid=qc_100001_300144&gpu=false&";
			
			var checker:Function = function():void
			{
				if(stage)
				{
					$.t.remove(checker);
					loader = new Loader();
					Log.info("加载合作播放器：",coopURL);
					
					var vars:URLVariables = new URLVariables();
					for (var i:* in stageParams)
					{
						if (i != "cid")
						{
							vars[i] = stageParams[i];
						}
					}
					var _loc_4:* = stageParams["sourceId"] || stageParams["vid"] || "a3bbe7c38991ab25132a11ae9abdaaca";
					this.vid = stageParams["sourceId"] || stageParams["vid"] || "a3bbe7c38991ab25132a11ae9abdaaca";
					vars["vid"] = _loc_4;
					this.cid = stageParams["videoId"] || "iqiyi" + this.vid;
					
					loader.load(new URLRequest(url+vars.toString()),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPlayerComplete,false,0,true);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function():void
					{
						Log.error("爱奇艺视频播放器加载失败");
					},false,0,true);
				}
			}
			$.t.call(100,checker)
		}
		
		protected function onPlayerComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onPlayerComplete);
			
			var getPlayer:Function = function():void
			{
				try{
					var facade:Object = loader.contentLoaderInfo.applicationDomain.getDefinition("org.puremvc.as3.patterns.facade.Facade");
					_player = facade.getInstance().retrieveProxy("com.qiyi.player.share.body.model.PlayerProxy").curActor.corePlayer;
				}catch(e:Error){}
			}
				
			var checkPlayer:Function = function():void
			{
				getPlayer();
				
				if(_player!=null)
				{
					_player.addEventListener("corePlayerStatusChanged",function(e:Event):void
					{
						switch(e["data"]["status"])
						{
							case StatusType.PLAYING:
								if($.t.has(updateTime))
								{
									$.t.remove(updateTime);
								}
								$.t.call(200,updateTime);
								dispatchEvent(new Event("onResume"));
								break;
							case StatusType.PAUSED:
								dispatchEvent(new Event("onPause"));
								break;
							case StatusType.STOPED:
								dispatchEvent(new Event("onStop"));
								break;
							case StatusType.ALREADY_PLAY:
								dispatchEvent(new Event("onPlay"));
								break;
						}
					});
					
					$.t.remove(checkPlayer);
				}
			}
			
			$.t.call(200,checkPlayer);
			
			addChild(event.target.content as DisplayObject);
		}
				
		private function updateTime():void
		{
			dispatchEvent(new Event("play_progress"));
		}
		
		public function get time():Number
		{
			if(!_player||!_player.currentTime)return 0;
			return _player.currentTime/1000;
		}
	}
}

class StatusType
{
	private static var begin:int = 0;
	public static const BEGIN:int = begin;
	public static const IDLE:int = begin;
	public static const ALREADY_LOAD_MOVIE:int = ++begin;
	public static const ALREADY_READY:int = ++begin + 1;
	public static const ALREADY_START_LOAD:int = ++begin;
	public static const ALREADY_PLAY:int = ++begin;
	public static const PLAYING:int = ++begin;//5
	public static const PAUSED:int = ++begin;//6
	public static const SEEKING:int = ++begin;
	public static const WAITING:int = ++begin;
	public static const STOPPING:int = ++begin;
	public static const STOPED:int = ++begin;
	public static const FAILED:int = ++begin;
	public static const WAITING_START_LOAD:int = ++begin;
	public static const WAITING_PLAY:int = ++begin;
	public static const META_START_LOAD_CALLED:int = ++begin;
	public static const HISTORY_START_LOAD_CALLED:int = ++begin;
	public static const P2P_CORE_START_LOAD_CALLED:int = ++begin;
	public static const END:int = ++begin;
	public static const COUNT:int = END - BEGIN;
}