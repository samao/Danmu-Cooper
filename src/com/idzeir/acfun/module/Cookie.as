/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 29, 2015 11:24:54 AM			
 * ===================================
 */

package com.idzeir.acfun.module
{
	import com.idzeir.acfun.view.BaseStage;
	
	/**
	 * 同步web cookie 和 flash cookie
	 */	
	[SWF(width="1",height="1")]
	public class Cookie extends BaseStage
	{
		public function Cookie()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false;
		}
	}
}