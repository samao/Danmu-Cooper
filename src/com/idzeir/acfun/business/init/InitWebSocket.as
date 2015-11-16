/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 3:00:12 PM			
 * ===================================
 */

package com.idzeir.acfun.business.init
{
	import com.idzeir.acfun.business.BaseInit;
	import com.idzeir.acfun.business.IQm;
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.websocket.WebSocket;
	import com.idzeir.acfun.websocket.WebSocketErrorEvent;
	import com.idzeir.acfun.websocket.WebSocketEvent;

	public class InitWebSocket extends BaseInit
	{

		private var _websocket:WebSocket;
		/**
		 * 重连ws时间 
		 */		
		private var _retryDelay:int = 3000;
		//重试次数
		private var _retryTotal:int = 0;
		/**
		 * 缓存没有发出去的数据 
		 */		
		private var _map:Vector.<String> = new Vector.<String>();
		private var _authed:Boolean = false;
		
		public function InitWebSocket()
		{
		}
		
		override public function enter(qm:IQm):void
		{
			super.enter(qm);
			$.e.dispatchEvent(new GlobalEvent(EventType.PROGRESS,"连接聊天服务器"));
			_websocket = new WebSocket($.c.websocketUri+"/"+$.v.danmakuId,"*",null,20000);
			Log.info("连接websocket",_websocket.uri);
			
			_websocket.addEventListener(WebSocketEvent.OPEN,onConnectOpen);
			_websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL,onConnectFail);
			_websocket.addEventListener(WebSocketEvent.CLOSED,onConnectClosed);
			_websocket.addEventListener(WebSocketEvent.MESSAGE,onMessage);
			
			$.e.addEventListener(EventType.SEND,function(e:GlobalEvent):void
			{
				send(JSON.stringify(e.info));
			});
			
			connect();
		}
		
		/**
		 * 接收消息
		 * @param e
		 */		
		private function onMessage(e:WebSocketEvent):void
		{
			try{
				Log.debug("收到服务器数据:",e.message.utf8Data);
				var respond:Object = JSON.parse(e.message.utf8Data);
			}catch(error:Error){
				Log.warn("JSONError：websocket返回数据无法JSON",error.message);
				return;
			}
			respond&&handleMessage(respond);
		}
		/**
		 * 成功连接ws
		 * @param e
		 */		
		private function onConnectOpen(e:WebSocketEvent):void
		{
			Log.info("websocket连接成功");
			
			$.t.call(10000,ping);
			
			sendAuthor();
		}
		/**
		 * ws关闭
		 * @param e
		 */		
		private function onConnectClosed(e:WebSocketEvent):void
		{
			Log.info("websocket连接关闭");
			breakQm();
			retry();
		}
		
		/**
		 * 连接失败
		 * @param e
		 */		
		private function onConnectFail(e:WebSocketEvent):void
		{
			Log.info("websocket连接失败");
			retry();
		}
		
		/**
		 * 尝试重连
		 */		
		private function retry():void
		{
			if($.t.has(connect))
			{
				return;
			}
			if(++_retryTotal>12)
			{
				breakQm();
				Log.warn("websocket连接重试达到上限，不再重连");
				return;
			}
			$.t.call(_retryDelay,connect,1);
		}
		/**
		 * 验证是否为可发送消息状态
		 * @return 
		 */		
		private function vaild():Boolean
		{
			return _websocket&&_websocket.connected&&_authed;
		}
		
		private function send(value:String):void
		{
			if(vaild())
			{
				_websocket.sendUTF(value);
				return;
			}
			_map.push(value);
		}
		
		/**
		 * 心跳
		 */		
		private function ping():void
		{
			_websocket&&_websocket.ping();
		}
		
		/**
		 * 连接ws
		 */		
		private function connect():void
		{
			if($.t.has(ping))
			{
				Log.info("websocket重连:",_retryTotal);
				$.t.remove(ping);
			}
			_authed = false;
			_websocket.connect();
		}
		
		/**
		 * 清除缓存的发送信息（不包括用户登录验证信息）；
		 */		
		private function flush():void
		{
			while(_map.length>0)
			{
				send(_map.shift());
			}
		}
		
		private function dispose(result:String = ""):void
		{
			try{
				_websocket.removeEventListener(WebSocketEvent.OPEN,onConnectOpen);
				_websocket.removeEventListener(WebSocketErrorEvent.CONNECTION_FAIL,onConnectFail);
				_websocket.removeEventListener(WebSocketEvent.CLOSED,onConnectClosed);
				_websocket.removeEventListener(WebSocketEvent.MESSAGE,onMessage);
			}catch(e:Error){}
			
			_websocket = null;
			$.e.dispatchEvent(new GlobalEvent(EventType.DISPOSE,result));
		}
		
		private function handleMessage(value:Object):void
		{
			//服务器和用户交互状态反馈
			if(value.hasOwnProperty("status"))
			{
				switch(value["status"])
				{
					case RespondType.SERVER_AUTHED:
						Log.info("服务器验证成功：",value.msg);
						var author:Object = JSON.parse(value.msg);
						//重置用户信息
						$.u.id = author["uid"];
						$.fc.set("client",author['client']);
						$.fc.set("client_ck",author['client_ck']);
						_authed = true;
						flush();
						complete();
						break;
					case RespondType.SERVER_REDIRECT:
						//切换到备用ws服务器
						Log.info("服务器负载转移：",value["msg"]);
						break;
					case RespondType.SEND_OK:
					case RespondType.ONLINE_LIST:
					case RespondType.ONLINE_NUMBER:
					case RespondType.SEND_REPORT_OK:
					case RespondType.SEND_REPORT_OK_2:
						break;
					case RespondType.SERVER_CLOSE:
						dispose($.l.get(value["status"]));
						break;
					case RespondType.SEND_FAIL_FORBIDDEN:
					case RespondType.SEND_FAIL_FORBIDDEN_GUEST:
					case RespondType.SEND_FAIL_FORBIDDEN_LEVEL:
					case RespondType.SEND_FAIL_FORBIDDEN_SPECIAL_LEVEL:
					case RespondType.SEND_FAIL_SENSITIVE:
						Log.error("发送弹幕失败:",JSON.stringify(value));
						$.e.dispatchEvent(new GlobalEvent(EventType.ERROR,{"message":$.l.get(value["status"])}));
						break;
					default:
						Log.warn("未处理websocket消息：","status:",value["status"],JSON.stringify(value));
						break;
				}
			}
			
			if(value.hasOwnProperty("action")){
				try{
					//收到服务器交互指令
					switch(value["action"])
					{
						case RespondAction.POST:
							//接收到弹幕，包括自己的弹幕
							$.e.dispatchEvent(new GlobalEvent(EventType.RECIVE,JSON.parse(value["command"])));
							break;
						case RespondAction.VOW:
							//服务器公告信息
							$.e.dispatchEvent(new GlobalEvent(EventType.RECIVE,JSON.parse(value["command"])));
							break;
						default:
							Log.warn("未处理websocket消息：","action:",value["action"],JSON.stringify(value));
							break;
					}
				}catch(e:Error){
					Log.error("接收websocket消息处理出错：",e.message,e.getStackTrace());
				}
				return;
			}
			
			Log.warn("未知websocket消息:","原始内容：",value,"JSON化：",JSON.stringify(value));
		}
		
		private function sendAuthor():void
		{
			var handshakeData:Object = {};
			handshakeData['vid'] = $.f.vid;
			handshakeData['vlength'] = $.v.videoLength;
			handshakeData['time'] = new Date().time;
			
			if($.supportCookie)
			{
				//游客登录时候client 和 client_ck 为空字符串
				handshakeData['client'] = $.fc.get("client")||"";
				handshakeData['client_ck'] = $.fc.get("client_ck")||"";
				
				handshakeData['uid'] = $.fc.get("auth_key");//1368971//JavascriptAPI.getCookie("auth_key");
				handshakeData['uid_ck'] = $.fc.get("auth_key_ac_sha1")//1469459601//JavascriptAPI.getCookie("auth_key_ac_sha1");
			}
			//if (isNaN(Number(handshakeData['uid'])) || handshakeData['uid']==null) delete handshakeData['uid'];
			//if (isNaN(Number(handshakeData['uid_ck'])) || handshakeData['uid_ck']==null) delete handshakeData['uid_ck'];			
			Log.debug("发送认证信息",JSON.stringify(handshakeData));
			_websocket.sendUTF(JSON.stringify({action : "auth",command:JSON.stringify(handshakeData)}));
		}
	}
}

class RespondAction
{
	/** 弹幕接收 */	
	public static const POST:String = "post";
	/** 系统消息接收 */	
	public static const VOW:String = "vow";
}

class RespondType
{
	public static const SEND_REPORT_OK:String = '102';
	public static const SEND_REPORT_OK_2:String = '101';
	
	public static const SERVER_AUTHED:String = '202';
	public static const BAN_LIST:String = '210';
	public static const SEND_OK:String = '200';
	
	/** 服务器地址重定向 **/
	public static const SERVER_REDIRECT:String = '302';
	
	/** 禁言  **/
	public static const SEND_FAIL_FORBIDDEN:String = '401';
	/**高级弹幕等级限制**/
	public static const SEND_FAIL_FORBIDDEN_SPECIAL_LEVEL:String = '401.3';
	/**普通弹幕等级限制**/
	public static const SEND_FAIL_FORBIDDEN_LEVEL:String = '401.6';
	/**游客限制**/
	public static const SEND_FAIL_FORBIDDEN_GUEST:String = '401.9';
	/** 敏感词  **/
	public static const SEND_FAIL_SENSITIVE:String = '403';
	/** 服务器主动关闭（不重连）  **/
	public static const SERVER_CLOSE:String = '404';
	
	public static const SEND_FAIL_SERVER:String = '500';
	
	public static const ONLINE_NUMBER:String = '600';
	public static const ONLINE_LIST:String = '601';
}