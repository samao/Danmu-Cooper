/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 24, 2015 5:00:37 PM			
 * ===================================
 */

package com.idzeir.acfun.manage
{
	import com.greensock.TweenMax;

	/**
	 * 动画接口
	 */	
	public interface IAnimation
	{
		/**
		 * 动画，每次执行时候会先清除上次未完的动画
		 */		
		function fromTo(target:Object,duration:Number,fromVars:Object,toVars:Object):TweenMax;
		/**
		 * 动画执行到
		 */		
		function to(target:Object,duration:Number,vars:Object):TweenMax;
			
	}
}