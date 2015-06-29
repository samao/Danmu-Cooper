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
	
	import flash.utils.setInterval;

	public class InitWebSocket extends BaseInit
	{

		private var _websocket:WebSocket;
		
		public function InitWebSocket()
		{
		}
		
		override public function enter(qm:IQm):void
		{
			super.enter(qm);
			$.e.dispatchEvent(new GlobalEvent(EventType.PROGRESS,"连接聊天服务器"));
			_websocket = new WebSocket($.c.websocketUri+"/"+$.v.danmakuId,"*",null,20000);
			Log.info("连接websocket",_websocket.uri);
			_websocket.addEventListener(WebSocketEvent.OPEN,function():void
			{
				Log.info("websocket连接成功");
				
				setInterval(function():void
				{
					_websocket.ping();
				},10000);
				sendAuthor();
			});
			_websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL,function():void
			{
				Log.info("websocket连接失败");
			});
			_websocket.addEventListener(WebSocketEvent.CLOSED,function():void
			{
				Log.info("websocket连接关闭");
			});
			_websocket.addEventListener(WebSocketEvent.MESSAGE,function(e:WebSocketEvent):void
			{
				Log.debug("收到服务器返回消息",e.message.utf8Data);
				try{
					var respond:Object = JSON.parse(e.message.utf8Data);
				}catch(error:Error){
					Log.warn("JSONError:websocket返回数据无法JSON");
					return;
				}
				respond&&handleMessage(respond);
			});
			_websocket.connect();
		}
		
		private function handleMessage(value:Object):void
		{
			//服务器和用户交互状态反馈
			switch(value["status"])
			{
				case RespondType.SERVER_AUTHED:
					Log.info("服务器验证成功");
					$.u.id = JSON.parse(value.msg)["uid"];
					$.e.addEventListener(EventType.SEND,function(e:GlobalEvent):void
					{
						_websocket.sendUTF(JSON.stringify(e.info));
					});
					
					complete();
					break;
				default:
					break;
			}
			
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
						Log.debug("收到服务器action消息");
						break;
				}
			}catch(e:Error){
				Log.error("接收websocket消息处理出错：",e.message,e.getStackTrace());
			}
		}
		
		private function sendAuthor():void
		{
			var handshakeData:Object = {};
			handshakeData['client'] = "";
			handshakeData['client_ck'] = "";
			handshakeData['vid'] = $.f.vid;
			handshakeData['vlength'] = $.v.videoLength;
			handshakeData['time'] = new Date().time;
			if($.supportCookie)
			{
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