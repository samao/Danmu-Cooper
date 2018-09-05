/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 16, 2015 10:34:51 AM			
 * ===================================
 */

package com.idzeir.utils
{
	import com.idzeir.vo.BulletVo;
	import com.idzeir.vo.Node;
	
	/**
	 * node转换弹幕数据工具
	 */	
	public class NodeUtil
	{
		public static function get(node:Node):BulletVo
		{
			if(node==null)return null;
			return node.content as BulletVo;
		}
	}
}
