/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 9, 2015 6:33:44 PM			
 * ===================================
 */

package com.idzeir.view
{
	import com.idzeir.manage.BulletType;
	import com.idzeir.vo.BulletVo;
	
	import flash.geom.Point;
	
	/**
	 * 从右到左移动弹幕
	 */	
	public class MoveBullet extends BaseBullet implements IBullet
	{
		/**
		 * 每次更新移动的距离
		 */		
		private const SPEED:Number = 2;
		
		public function MoveBullet()
		{
			super();
		}
		
		override public function update(time:Number = 0):void
		{
			this.x -= SPEED; 
			if(this.x< - this.width)
			{
				this.removeFromParent();
			}
		}
		
		/**
		 * 设置移动弹幕数据
		 * @param value
		 * @param point x用户指定x坐标，y用于指定每行的高度用于居中
		 */		
		override public function bullet(value:BulletVo,point:Point = null):IBullet
		{
			super.bullet(value);
			
			this.x = point.x;
			this.y = point.y - this.height >> 1;
			return this;
		}
		
		override public function get bulletType():String
		{
			return BulletType.RIGHT_TO_LEFT;
		}
	}
}
