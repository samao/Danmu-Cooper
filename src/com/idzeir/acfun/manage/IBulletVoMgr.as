/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 8, 2015 12:41:47 PM			
 * ===================================
 */

package com.idzeir.acfun.manage
{
	import com.idzeir.acfun.vo.Node;
	
	public interface IBulletVoMgr
	{
		function add(value:Node):void;
		
		function seek(value:Number):Node;
		
		function get timeNode():Node;
		
		function nextTime():void;
		
		//function searchAfter():Node;
		
		//function searchBefore():Node;
		/**
		 * 以next方式插入
		 */		
		//function insert(value:Node):Node;
		/**
		 * 以pre方式插入
		 */		
		//function insertBefore(value:Node):Node;
	}
}