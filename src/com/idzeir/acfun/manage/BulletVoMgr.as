/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 8, 2015 12:18:42 PM			
 * ===================================
 */

package com.idzeir.acfun.manage
{
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.utils.NodeUtil;
	import com.idzeir.acfun.vo.BulletVo;
	import com.idzeir.acfun.vo.Node;
	
	/**
	 * 弹幕管理器
	 */	
	public final class BulletVoMgr implements IBulletVoMgr
	{
		private var _timeNode:Node;
		private var _begin:Node;
		
		private static var _instance:BulletVoMgr;
		
		public function BulletVoMgr()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public static function getInstance():BulletVoMgr
		{
			return _instance ||= new BulletVoMgr();
		}
		
		public function add(value:Node):void
		{
			try{
				if(!_begin)
				{
					begin = value;
					return;
				}
				
				if(large(_begin.content,value.content))
				{
					_begin.pre = value;
					begin = value;
				}else{
					var cur:Node = _begin;
					do{
						//到末尾了
						if(!cur.next){
							cur.next = value;
							return;
						}
						//找到位置
						if(large(cur.content,value.content))
						{
							break;
						}
						cur = cur.next;
					}while(cur);
					
					cur.pre = value;
				}
			}catch(e:Error){
				Log.error("添加弹幕报错：",e.message,e.getStackTrace());
			}
		}
		
		private function set begin(node:Node):void
		{
			_timeNode = _begin = node;
		}
		
		/**
		 * 比较是否a大于b
		 * @param a
		 * @param b
		 * @return 
		 */		
		private function large(a:BulletVo,b:BulletVo):Boolean
		{
			return (a.stime - b.stime)>0;
		}
		
		public function seek(value:Number):Node
		{
			var node:Node = timeNode||_begin;
			if(value>(NodeUtil.get(node)).stime)
			{
				//向后
				while(node&&(NodeUtil.get(node)).stime<value)
				{
					if(!node.next)break;
					node = node.next;
				}
			}else{
				//向前
				while(node&&(NodeUtil.get(node)).stime>value)
				{
					if(!node.pre)break;
					node = node.pre;
				}
			}
			_timeNode = node;
			return _timeNode;
		}
		
		public function get timeNode():Node
		{
			return _timeNode;
		}
		
		public function nextTime():void
		{
			_timeNode = _timeNode.next;
		}
		
		public function toString():String
		{
			var s:Array = [];
			var cur:Node = _begin;
			while(cur)
			{
				s.push((NodeUtil.get(cur)).mode);
				cur = cur.next;
			}
			return "Total:"+s.length +" ->"+ s.join("<");
		}
	}
}