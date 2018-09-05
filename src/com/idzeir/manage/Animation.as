/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 24, 2015 5:01:58 PM			
 * ===================================
 */

package com.idzeir.manage
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	public class Animation implements IAnimation
	{
		private static var _instance:Animation;
		
		public function Animation()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public static function getInstance():Animation
		{
			return _instance ||= new Animation();
		}
		
		public function fromTo(target:Object,duration:Number,fromVars:Object,toVars:Object):TweenMax
		{
			TweenMax.killTweensOf(target);
			fromVars.ease = com.greensock.easing.Back.easeIn;
			return TweenMax.fromTo(target,duration,fromVars,toVars);
		}
		
		public function to(target:Object,duration:Number,vars:Object):TweenMax
		{
			TweenMax.killTweensOf(target);
			vars.ease = com.greensock.easing.Back.easeIn;
			return TweenMax.to(target,duration,vars);
		}
	}
}
