/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Nov 23, 2015 12:16:51 PM			
 * ===================================
 */

package com.idzeir.acfun.module
{
	import com.idzeir.acfun.utils.Log;
	import com.idzeir.acfun.utils.RequestUtil;
	import com.idzeir.acfun.view.BaseStage;
	
	import flash.events.Event;
	
	public class Recommend extends BaseStage
	{
		
		public function Recommend()
		{
			super();
		}
		
		override protected function onAdded(e:Event):void
		{
			super.onAdded(e);
			RequestUtil.load($.c.recommendUrl+"?ac"+$.v.contentId,null,function(value:*):void
			{
				Log.debug("推荐视频数据：",value);
			},function(value:*):void
			{
				Log.warn("获取推荐视频失败：",JSON.stringify(value));
			});
		}
	}
}