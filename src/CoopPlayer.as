/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 3, 2015 2:45:39 PM			
 * ===================================
 */

package
{
	import com.idzeir.business.Qm;
	import com.idzeir.business.QmEvent;
	import com.idzeir.business.init.InitBulletData;
	import com.idzeir.business.init.InitConfigData;
	import com.idzeir.business.init.InitCookieData;
	import com.idzeir.business.init.InitFilterData;
	import com.idzeir.business.init.InitVideoData;
	import com.idzeir.business.init.InitWebSocket;
	import com.idzeir.business.init.InitXMLLogic;
	import com.idzeir.coop.Logic;
	import com.idzeir.events.EventType;
	import com.idzeir.events.GlobalEvent;
	import com.idzeir.manage.Animation;
	import com.idzeir.manage.BulletFactory;
	import com.idzeir.manage.BulletVoMgr;
	import com.idzeir.manage.FilterManager;
	import com.idzeir.manage.Keys;
	import com.idzeir.manage.ToolTipMgr;
	import com.idzeir.module.IPlugin;
	import com.idzeir.module.Recommend;
	import com.idzeir.profile.Monitor;
	import com.idzeir.timer.Ticker;
	import com.idzeir.utils.FindUtil;
	import com.idzeir.utils.Log;
	import com.idzeir.utils.MenuUtil;
	import com.idzeir.view.BaseStage;
	import com.idzeir.view.BulletContainer;
	import com.idzeir.view.ErrorRespondText;
	import com.idzeir.view.InputTools;
	import com.idzeir.view.ProgressBar;
	import com.idzeir.vo.ConfigVo;
	import com.idzeir.vo.FlashVarsVo;
	import com.idzeir.vo.LogicEventVo;
	import com.idzeir.vo.User;
	import com.idzeir.vo.VideoInfoVo;
	
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
	import flash.system.Security;
	import flash.ui.ContextMenuItem;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	[SWF(backgroundColor="#343434",frameRate="30"]
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

		private var _coreItem:ContextMenuItem;
		private var _versionItem:ContextMenuItem;
		
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
		
		private var _recommentLayer:Recommend;
		
		public function CoopPlayer()
		{
			super();
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			
			CONFIG::release
			{
				const LOG_TAG:String = "log";
				var urlVars:Object = RefUtil.getUrlVars();
				Log.level = urlVars.hasOwnProperty(LOG_TAG)?parseInt(urlVars[LOG_TAG]):0;
			}
			
			CONFIG::debug
			{
				Log.level = 4;
				Log.useTracer = true;
			}
			
			//屏蔽合作方右键菜单
			const VERSION:String = "AcFunPlayer Build:20150623";
			
			_coreItem = new ContextMenuItem(VERSION,true,false);
			_versionItem = new ContextMenuItem("",false,false)
			
			initVo();
			
			Log.info("业务流程执行开始");
			//先加载语言包和配置然后才开始初始化界面
			$.q.push(new InitCookieData());
			$.q.push(new InitConfigData());
			$.q.push(new InitFilterData());
			
			$.q.addEventListener(QmEvent.COMPLETE_QM,function():void
			{
				$.q.removeEventListener(QmEvent.COMPLETE_QM,arguments.callee);
				initLayer();
				initBusiness();
			});
			$.q.excute();
			
			MenuUtil.hidenContextMenus(this,_coreItem,_versionItem);
			
			stage.addEventListener(Event.RESIZE,function():void
			{
				//resize
				if(_tools)
				{
					_tools.visible = stage.displayState != StageDisplayState.FULL_SCREEN
					_tools.x = Number($.g.xml..input.@left[0]);
					_tools.y = stage.stageHeight - _tools.height - Number($.g.xml..input.@bottom[0]);
					_tools.width = stage.stageWidth - Number($.g.xml..input.@left[0]) - Number($.g.xml..input.@right[0]);
				}
				_proBar&&_proBar.algin();
				_bullets&&_bullets.resize();
			});
		}
		
		private function initBusiness():void
		{
			Log.info("初始化弹幕业务数据");
			$.q.push(new InitVideoData());//可能抛出BREAK_QM
			$.q.push(new InitXMLLogic());//可能抛出BREAK_QM
			$.q.push(new InitBulletData());
			$.q.push(new InitWebSocket());//可能抛出BREAK_QM
			
			$.q.addEventListener(QmEvent.COMPLETE_QM,function():void
			{
				Log.info("业务初始化完成");
				
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
				MenuUtil.hidenContextMenus(e.target as InteractiveObject,_coreItem,_versionItem);
			});
			
			MenuUtil.hidenContextMenus(_apiBox,_coreItem,_versionItem);
			
			this.addChild(_apiBox);
			this.addChild(_bullets);
			
			_proBar ||= new ProgressBar();
			this.addChild(_proBar);
			
			var errorTxt:ErrorRespondText = new ErrorRespondText();
			this.addChild(errorTxt);
			
			_recommentLayer ||= new Recommend();
			
			this.addChild(new Monitor());
		}
		
		private function initTools():void
		{
			Log.info("初始化弹幕发送功能");
			_tools = new InputTools();
			_tools.x = Number($.g.xml..input.@left[0]);
			_tools.y = stage.stageHeight - _tools.height - Number($.g.xml..input.@bottom[0]);
			_tools.width = stage.stageWidth - Number($.g.xml..input.@left[0]) - Number($.g.xml..input.@right[0])
			this.addChild(_tools);
			
			const DANMU_OPTION_URL:String = "DanmuOption.swf";
			_optionLoader = new Loader();
			_optionLoader.load(new URLRequest(DANMU_OPTION_URL));
			this.addChild(_optionLoader);
		}
		
		private function loadCommentPlugin():void
		{
			Log.info("开始加载视频播放器");
			
			//加载第三方播放器
			loadCoopPlayer();
			return;
			//单测试弹幕性能
			_bullets.start();
			var t:int = 0;
			$.t.call(1000,function():void{
				_bullets.time(t++);
			},1000)
		}
		
		private function loadCoopPlayer():void
		{
			Log.info("加载第三方播放器",$.g.playerURL);
			$.e.dispatchEvent(new GlobalEvent(EventType.PROGRESS,"加载第三方播放器"));
			var loader:Loader = new Loader();
			var okHandler:Function = function(e:Event):void
			{
				clearHandler();
				_coopSDK = e.target.content;
				applyLogicXML();
				_apiBox.addChild(_coopSDK as DisplayObject);
				
				//加载第三方播放器
				if(!($.g.proxy==""))
				{
					var p:IPlugin = e.target.content as IPlugin;
					if(p)
					{
						p.hooks($.g.playerURL,stage.loaderInfo.parameters);
					}
					Log.info("第三方播放器代理插件加载成功");
					return;
				}
				Log.info("第三方播放器加载成功");
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
			ldr.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
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
			//初始化输入框
			initTools();
			
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
			_tools&&(_tools.visible = true);
			
			var tipLayer:Sprite = new Sprite();
			this.addChild(tipLayer);
			$.tips.setupLayer(tipLayer);
			
			if($.f.autoplay)
			{
				this._bullets.start();
			}
			
			_versionItem.caption ="逻辑版本：" +$.v.sourceType + " " + $.g.xml.@version;
		}
		
		private function onTime(e:Event):void
		{
			var time:Number;
			if(_timeVo.arg.indexOf("::")==0)
			{
				time = Number(FindUtil.get(_coopSDK,_timeVo.arg.replace("::","")));
			}else{
				time = Number(FindUtil.get(e,_timeVo.arg));
			}
			//更新弹幕时间
			//Log.debug("当前播放：",time,_bullets.isRunning);
			_bullets.time(time);
		}
		
		
		public function onSeek(value:* = null):void
		{
			Log.debug("SEEK",JSON.stringify(value));
			showRecommend = false;
		}
		
		private function onPlay(e:Event):void
		{
			Log.debug("视频播放");
			_bullets.start();
			showRecommend = false;
		}
		
		private function onStop(e:Event):void
		{
			Log.debug("视频停止");
			_bullets.stop();
			showRecommend = true;
		}
		
		private function onResume(e:Event):void
		{
			//Log.debug("视频播放恢复");
			_bullets.resume();
			showRecommend = false;
		}
		
		private function onPause(e:Event):void
		{
			//Log.debug("视频暂停");
			_bullets.pause();
		}
		
		private function set showRecommend(bool:Boolean):void
		{
			if(bool)
				this.addChild(_recommentLayer);
			else
				this.contains(_recommentLayer)&&this.removeChild(_recommentLayer);
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
			$.fm = FilterManager.getInstance();
			$.tips = ToolTipMgr.getInstance();
			
			$.f.update(stage.loaderInfo.parameters);
			$.k.stage = stage;
		}
	}
}
