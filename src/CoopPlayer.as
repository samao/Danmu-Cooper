/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 2:45:39 PM			
 * ===================================
 */

package
{
	import com.idzeir.acfun.business.Qm;
	import com.idzeir.acfun.business.QmEvent;
	import com.idzeir.acfun.business.init.InitBulletData;
	import com.idzeir.acfun.business.init.InitConfigData;
	import com.idzeir.acfun.business.init.InitCookieData;
	import com.idzeir.acfun.business.init.InitVideoData;
	import com.idzeir.acfun.business.init.InitWebSocket;
	import com.idzeir.acfun.business.init.InitXMLLogic;
	import com.idzeir.acfun.coop.Logic;
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.manage.Animation;
	import com.idzeir.acfun.manage.BulletFactory;
	import com.idzeir.acfun.manage.BulletVoMgr;
	import com.idzeir.acfun.manage.Keys;
	import com.idzeir.acfun.timer.Ticker;
	import com.idzeir.acfun.utils.FindUtil;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.utils.MenuUtil;
	import com.idzeir.acfun.view.BaseStage;
	import com.idzeir.acfun.view.BulletContainer;
	import com.idzeir.acfun.view.ErrorText;
	import com.idzeir.acfun.view.InputTools;
	import com.idzeir.acfun.view.ProgressBar;
	import com.idzeir.acfun.vo.ConfigVo;
	import com.idzeir.acfun.vo.FlashVarsVo;
	import com.idzeir.acfun.vo.LogicEventVo;
	import com.idzeir.acfun.vo.User;
	import com.idzeir.acfun.vo.VideoInfoVo;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.ui.ContextMenuItem;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	[SWF(backgroundColor="#343434",frameRate="24"]
	/**
	 * 第三方合作播放器
	 */	
	public class CoopPlayer extends BaseStage
	{
		/**
		 * 第三方sdk 
		 */		
		protected var _coopSDK:Object;
		
		private var _timeVo:LogicEventVo;
		/**
		 * 合作播放器ui容器 
		 */		
		private var _apiBox:Sprite;
		
		private var _bullets:BulletContainer;

		private var menuItem:ContextMenuItem;
		/**
		 * 初始化进度显示条 
		 */		
		private var _proBar:ProgressBar;
		/**
		 * 弹幕工具栏
		 */		
		private var _tools:InputTools;
		/**
		 * 弹幕配置面板 
		 */		
		private var _optionLoader:Loader;
		
		public function CoopPlayer()
		{
			
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			
			Log.level = 4;
			Log.useTracer = true;
			
			//屏蔽合作方右键菜单
			const VERSION:String = "AP_NO.20150623";
			
			menuItem = new ContextMenuItem(VERSION,true,false);
			
			initVo();
			
			Log.info("业务流程执行开始");
			//先加载语言包和配置然后才开始初始化界面
			$.q.push(new InitCookieData());
			$.q.push(new InitConfigData());
			
			$.q.addEventListener(QmEvent.COMPLETE_QM,function():void
			{
				$.q.removeEventListener(QmEvent.COMPLETE_QM,arguments.callee);
				initLayer();
				initBusiness();
			});
			$.q.excute();
			
			MenuUtil.hidenContextMenus(this,menuItem);
			
			stage.addEventListener(Event.RESIZE,function():void
			{
				//resize
				if(_tools)
				{
					_tools.visible = stage.displayState != StageDisplayState.FULL_SCREEN
					_tools.x = Number($.g.xml..input.@left[0]);
					_tools.y = stage.stageHeight - _tools.height - Number($.g.xml..input.@bottom[0]);
				}
			});
		}
		
		private function initBusiness():void
		{
			Log.info("初始化弹幕业务数据");
			$.q.push(new InitVideoData());//可能抛出BREAK_QM
			$.q.push(new InitXMLLogic());//可能抛出BREAK_QM
			$.q.push(new InitBulletData());//可能抛出BREAK_QM
			$.q.push(new InitWebSocket());//可能抛出BREAK_QM
			
			$.q.addEventListener(QmEvent.COMPLETE_QM,function():void
			{
				Log.info("业务初始化完成");
				
				initTools();
				//加载弹幕播放器
				loadCommentPlugin();
			});
			$.q.addEventListener(QmEvent.BREAK_QM,function():void
			{
				//无法连接弹幕，直播视频
				loadCoopPlayer();
			});
			$.q.excute();
		}
		
		private function initLayer():void
		{
			Log.info("初始化界面容器");
			_bullets = new BulletContainer()
			
			_apiBox ||= new Sprite();
			_apiBox.mouseEnabled = false;
			_apiBox.addEventListener(Event.ADDED,function(e:Event):void
			{
				//Log.error("api add:",e.target);
				MenuUtil.hidenContextMenus(e.target as InteractiveObject,menuItem);
			});
			
			MenuUtil.hidenContextMenus(_apiBox,menuItem);
			
			this.addChild(_apiBox);
			this.addChild(_bullets);
			
			_proBar ||= new ProgressBar();
			this.addChild(_proBar);
			
			var errorTxt:ErrorText = new ErrorText();
			this.addChild(errorTxt);
		}
		
		private function initTools():void
		{
			Log.info("初始化弹幕发送功能");
			_tools = new InputTools();
			_tools.x = Number($.g.xml..input.@left[0]);
			_tools.y = stage.stageHeight - _tools.height - Number($.g.xml..input.@bottom[0]);
			_tools.visible = false;
			this.addChild(_tools);
			
			const DANMU_OPTION_URL:String = "DanmuOption.swf";
			_optionLoader = new Loader();
			_optionLoader.load(new URLRequest(DANMU_OPTION_URL));
			this.addChild(_optionLoader);
		}
		
		private function loadCommentPlugin():void
		{
			Log.info("加载弹幕播放器");
			//加载第三方播放器
			loadCoopPlayer();
			/**
			 * 单测试弹幕性能
				_bullets.start();
				var t:int = 0;
				setInterval(function():void{
					_bullets.time(t++);
				},1000);
			*/
			return;
		}
		
		private function loadCoopPlayer():void
		{
			Log.info("加载第三方播放器",$.g.playerURL);
			$.e.dispatchEvent(new GlobalEvent(EventType.PROGRESS,"加载第三方播放器"));
			var loader:Loader = new Loader();
			var okHandler:Function = function(e:Event):void
			{
				Log.info("第三方播放器加载成功");
				clearHandler();
				_coopSDK = e.target.content;
				applyLogicXML();
				
				if($.g.proxy!="")_coopSDK["playerURL"]($.g.playerURL,stage.loaderInfo.parameters);
				_apiBox.addChild(_coopSDK as DisplayObject);
			};
			var failHandler:Function = function(e:Event):void
			{
				Log.error("第三方播放器加载失败",$.g.playerURL);
				clearHandler();
			};
			var clearHandler:Function = function():void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,okHandler);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,failHandler);
			}
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,okHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failHandler);
			
			var ldr:LoaderContext = new LoaderContext();
			ldr.applicationDomain = new ApplicationDomain();
			if(ldr["allowCodeImport"])
			{
				ldr["allowCodeImport"] = true;
			}
			loader.load(new URLRequest($.g.proxy==""?$.g.playerURL:$.g.proxy),ldr);
			
			_apiBox.visible = false;
		}
		
		private function applyLogicXML():void
		{
			//1.检查播放器状态
			var id:int = setInterval(function():void
			{
				if(FindUtil.get(_coopSDK,$.g.checks[0]) != null)
				{
					$.g.checks.splice(0,1);
				}
				
				if($.g.checks.length == 0)
				{
					clearInterval(id);
					//2.执行逻辑
					addXMLEvent();
				}
			},100);
		}
		
		private function addXMLEvent():void
		{
			var target:IEventDispatcher = FindUtil.get(_coopSDK,$.g.eventTarget) as IEventDispatcher;
			if(target)
			{
				for each(var i:LogicEventVo in $.g.logicEvents)
				{
					var handler:Function = this[i.handler];
					
					if(handler == onTime)
					{
						_timeVo = i;
					}
					
					handler&&target.addEventListener(i.type,handler);
				}
			}
			//移除进度条
			this.removeChild(_proBar);
			_apiBox.visible = true;
			_tools.visible = true;
			
			if($.f.autoplay)
			{
				this._bullets.start();
			}
		}
		
		private function onTime(e:Event):void
		{
			var time:int;
			if(_timeVo.arg.indexOf("::")==0)
			{
				time = int(FindUtil.get(_coopSDK,_timeVo.arg.replace("::","")));
			}else{
				time = int(FindUtil.get(e,_timeVo.arg));
			}
			//更新弹幕时间
			//Log.debug("当前播放：",time,_bullets.isRunning);
			_bullets.time(time);
		}
		
		
		public function onSeek(value:* = null):void
		{
			Log.debug("SEEK",JSON.stringify(value));
		}
		
		private function onPlay(e:Event):void
		{
			Log.debug("视频播放");
			_bullets.start();
		}
		
		private function onStop(e:Event):void
		{
			Log.debug("视频停止");
			_bullets.stop();
		}
		
		private function onResume(e:Event):void
		{
			_bullets.resume();
		}
		
		private function onPause(e:Event):void
		{
			Log.debug("视频暂停");
			_bullets.pause();
		}
		
		
		/**
		 * 初始化全局对象
		 */		
		protected function initVo():void
		{
			Log.info("数据模型初始化")
			$.q	= Qm.getInstance();
			$.c = ConfigVo.getInstance();
			$.f = FlashVarsVo.getInstance();
			$.v = VideoInfoVo.getInstance();
			$.g = Logic.getInstance();
			$.b = BulletVoMgr.getInstance();
			$.t = Ticker.getInstance();
			$.e = new EventDispatcher();
			$.ui = BulletFactory.getInstance();
			$.k = Keys.getInstance();
			$.a = Animation.getInstance();
			$.u = User.getInstance();
			
			$.f.update(stage.loaderInfo.parameters);
			$.k.stage = stage;
		}
	}
}