/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Nov 23, 2015 12:16:51 PM			
 * ===================================
 */

package com.idzeir.module
{
	import com.idzeir.utils.Log;
	import com.idzeir.utils.RequestUtil;
	import com.idzeir.view.BaseStage;
	
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
				createRecommend(value);
			},function(value:*):void
			{
				Log.warn("获取推荐视频失败：",JSON.stringify(value));
			});
		}
		
		private function createRecommend(value:String):void
		{
			var data:Object;
			
			try{
				data = JSON.parse(value);
			}catch(e:Error){
				Log.error("推荐视频服务器返回数据出错");
				return;
			}
			
			if(data&&data["status"]==200)
			{
				//组织推荐显示
			}else{
				Log.error("未找到推荐视频");
			}
		}
	}
}
