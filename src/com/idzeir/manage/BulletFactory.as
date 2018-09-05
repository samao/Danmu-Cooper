/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 16, 2015 10:40:30 PM			
 * ===================================
 */

package com.idzeir.manage
{
	import com.idzeir.view.FadeOutBullet;
	import com.idzeir.view.FixedFadeBullet;
	import com.idzeir.view.IBullet;
	import com.idzeir.view.MoveBullet;
	
	import flash.utils.Dictionary;
	
	/**
	 * 弹幕显示对象工厂
	 */	
	public class BulletFactory implements IBulletFactory
	{
		/**
		 * 弹幕字典 
		 */		
		private var _map:Dictionary = new Dictionary(true);
		/**
		 * 当前显示的弹幕 
		 */		
		private var _useMap:Vector.<IBullet> = new Vector.<IBullet>();
		
		private static var _instance:BulletFactory;
		
		public function BulletFactory()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public static function getInstance():BulletFactory
		{
			return _instance ||= new BulletFactory();
		}
		
		public function create(type:String):IBullet
		{
			var pool:Vector.<IBullet> = _map[type] ||= new Vector.<IBullet>();
			if(pool.length == 0)
			{
				var bullet:IBullet;
				switch(type)
				{
					case BulletType.FADE_OUT_TOP:
					case BulletType.FADE_OUT_BOTTOM:
						bullet = new FadeOutBullet();
						break;
					case BulletType.RIGHT_TO_LEFT:
						bullet = new MoveBullet();
						break;
					case BulletType.FIXED_FADE_OUT:
						bullet = new FixedFadeBullet();
						break;
					default:
						//默认都是从右到左
						//bullet = new MoveBullet();
						break;
				}
				pool.push(bullet);
			}
			//Log.debug("弹幕提取");
			return pool.shift();
		}
		
		public function recyle(value:IBullet):void
		{
			var pool:Vector.<IBullet> = _map[value.bulletType] ||= new Vector.<IBullet>();
			pool.push(value);
			//Log.debug("弹幕回收:",value);
			if(_useMap.indexOf(value)!=-1)
			{
				_useMap.splice(_useMap.indexOf(value),1);
			}
		}
		
		public function get useMap():Vector.<IBullet>
		{
			return _useMap;
		}
		
		public function getUseByName(name:String):IBullet
		{
			if(name)
			{
			
			for each(var i:IBullet in _useMap)
			{
				if(i.getBullet().mode == BulletType.FIXED_FADE_OUT&&i.getBullet().name == name)
				{
					return i;
				}
			}}
			return null;
		}
		
		/**
		 * 返回弹幕池统计信息
		 */		
		public function toString():String
		{
			var poolTotal:uint = 0;
			for each(var i:Vector.<IBullet> in _map)
			{
				poolTotal += i.length;
			}
			return "使用弹幕："+_useMap.length+" 创建弹幕："+(poolTotal+_useMap.length);
		}
	}
}
