/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jul 8, 2015 5:05:53 PM			
 * ===================================
 */

package com.idzeir.acfun.view
{
	import com.idzeir.acfun.manage.BulletType;
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.vo.BulletVo;
	
	import flash.geom.Point;
	
	/**
	 * 高级弹幕显示对象
	 */	
	public class FixedFadeBullet extends BaseBullet
	{
		private var _dur:int = 30;
		
		public function FixedFadeBullet()
		{
			super();
		}
		
		override public function update(time:int=0):void
		{
			if(--_dur)
			{
				this.removeFromParent();
			}
		}
		
		override public function bullet(value:BulletVo, point:Point=null):IBullet
		{
			Log.warn("高级弹幕功能开发中，暂时无法显示");
			_dur = 30;
			return this;
		}
		
		override public function get bulletType():String
		{
			return BulletType.FIXED_FADE_OUT;
		}
	}
}