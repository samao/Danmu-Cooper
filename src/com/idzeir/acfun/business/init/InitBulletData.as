/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 2:57:58 PM			
 * ===================================
 */

package com.idzeir.acfun.business.init
{
	import com.idzeir.acfun.business.BaseInit;
	import com.idzeir.acfun.business.IQm;
	import com.idzeir.acfun.events.EventType;
	import com.idzeir.acfun.events.GlobalEvent;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.utils.RequestUtil;
	import com.idzeir.acfun.vo.BulletVo;
	import com.idzeir.acfun.vo.Node;
	
	import flash.utils.Dictionary;

	public class InitBulletData extends BaseInit
	{
		/**
		 * 分批请求，每次的条数 
		 */		
		private const PAGE_SIZE:uint = 500;
		/**
		 * 请求的页数 
		 */		
		private var _pageNo:uint = 1;
		/**
		 * 弹幕id记录 
		 */		
		private var _map:Dictionary = new Dictionary(true);
		/**
		 * 弹幕总数 
		 */		
		private var _total:uint = 0;
		/**
		 * 已经提前执行后面进程
		 */
		private var _preComplete:Boolean = false;
		
		public function InitBulletData()
		{
			
		}
		
		override public function enter(qm:IQm):void
		{
			super.enter(qm);
			$.e.dispatchEvent(new GlobalEvent(EventType.PROGRESS,"读取历史弹幕"));
			load();
		}
		
		protected function load():void
		{
			//页数太多提前结束
			//!_preComplete&&_pageNo==10&&complete();
			
			var URL:String = $.c.staticUrl+"/"+$.v.danmakuId+"?pageSize="+PAGE_SIZE+"&pageNo="+_pageNo;
			Log.info("加载历史弹幕",URL);
			RequestUtil.load(URL,null,function(value:String):void
			{
				try{
					var o:Object = JSON.parse(value);
				}catch(e:Error){
					Log.error("JSONError:",URL);
					complete();
					return;
				}
				vaild(o);
			},function(value:Object):void
			{
				Log.error("加载失败：",JSON.stringify(value));
				complete();
			});
		}
		
		override public function complete():void
		{
			!_preComplete&&super.complete();
			//!_preComplete&&Log.info("弹幕数据太多，优先显示视频");
			_preComplete = true;
		}
		
		/**
		 * 检测弹幕数据是否加载完毕
		 */		
		private function vaild(value:Object):void
		{
			if(value)
			{
				if(value[0].length == 0&&value[1].length == 0&&value[2].length == 0)
				{
					--_pageNo;
					Log.info("弹幕文件加载完毕,总共："+_total+" 条");
					//Log.debug("弹幕排序结果时间：",String($.b));
					complete();
					return;
				}
				//提取弹幕数据
				parse(value);
				++_pageNo;
				load();
			}else{
				complete();
			}
		}
		
		/**
		 * 解析弹幕数据
		 */		
		private function parse(o:Object):void
		{
			Log.info("弹幕解析数据");
			for(var i:uint = 0;i<o.length;++i)
			{
				var bNo:Number = o[i].length;
				for(var j:uint = 0;j<bNo;++j)
				{
					var bullet:BulletVo = new BulletVo(o[i][j],i);
					//排除重复弹幕
					if(!_map[bullet.commentId])
					{
						++_total;
						_map[bullet.commentId] = true;
						$.b.add(new Node(bullet));
					}else{
						Log.warn("重复弹幕：",bullet.message);
					}
				}
			}
		}
	}
}