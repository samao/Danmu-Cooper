/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Oct 19, 2015 12:13:46 PM			
 * ===================================
 */

package com.idzeir.business.init
{
	import com.idzeir.business.BaseInit;
	import com.idzeir.business.IQm;
	import com.idzeir.utils.Log;
	import com.idzeir.utils.RequestUtil;
	
	/**
	 * 过滤词和黑名单业务
	 */	
	public class InitFilterData extends BaseInit
	{
		/**
		 * 敏感词和黑名单
		 */		
		public function InitFilterData()
		{
			super();
		}
		
		override public function enter(qm:IQm):void
		{
			super.enter(qm);
			loadBanJson();
		}
		/**
		 * 加载敏感词库
		 */		
		private function loadBanJson():void
		{
			Log.info("初始化敏感词业务");
			Log.debug("加载敏感词库：",$.c.ban);
			RequestUtil.load($.c.ban,null,function(value:*):void
			{
				Log.info("敏感词库加载完成");
				$.fm.updateBan(value);
				loadBlacklist();
			},function(value:*):void
			{
				Log.warn("敏感词库加载失败：",JSON.stringify(value));
				loadBlacklist();
			});
		}
		/**
		 * 加载黑名单
		 */		
		private function loadBlacklist():void
		{
			Log.info("初始化黑名单业务");
			Log.debug("加载黑名单：",$.c.blacklist);
			RequestUtil.load($.c.blacklist,null,function(value:*):void
			{
				Log.info("黑名单加载完成");
				$.fm.updateBlacklist(value);
				Log.debug("敏感词和封禁用户信息：",$.fm);
				complete();
			},function(value:*):void
			{
				Log.warn("黑名单加载失败：",JSON.stringify(value));
				complete();
			});
		}
	}
}
