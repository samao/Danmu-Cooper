/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 4, 2015 3:49:59 PM			
 * ===================================
 */

package com.idzeir.acfun.coop
{
	import com.idzeir.acfun.vo.LogicEventVo;
	
	/**
	 * 业务逻辑数据接口
	 */	
	public interface ILogic
	{
		/**
		 * 加载的合作播放器地址
		 */		
		function get playerURL():String;
		/**
		 * 播放器是否存在兼容代理
		 */		
		function get proxy():String;
		/**
		 * 派发事件对象的路径
		 */		
		function get eventTarget():String;
		/**
		 * 业务事件集合
		 */		
		function get logicEvents():Vector.<LogicEventVo>;
		/**
		 * 业务检测集合
		 */		
		function get checks():Vector.<String>;
		/**
		 * 业务xml全部内容
		 */		
		function get xml():XML;
		/**
		 * 更新业务xml
		 */		
		function update(xml:XML):void;
	}
}