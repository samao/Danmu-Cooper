/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv
 * ===================================
 */

package com.idzeir.module
{
	/**
	 * 第三方播放器代理插件接口
	 * @author iDzeir
	 */	
	public interface IPlugin
	{
		function hooks(coopURL:String,stageParams:Object):void;
	}
}