/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 8, 2015 11:55:51 AM			
 * ===================================
 */

package com.idzeir.vo
{
	/**
	 * 链表结构
	 */	
	public class Node
	{
		/**
		 * 上一节点 
		 */		
		private var _pre:Node;
		/**
		 * 下一节点 
		 */		
		private var _next:Node;
		/**
		 * 节点内容 
		 */		
		private var _content:*;
		
		public function Node(content:* = null)
		{
			_content = content;
		}
		
		public function get content():*
		{
			return _content;
		}
		
		public function set content(value:*):void
		{
			this._content = value;
		}

		public function get next():Node
		{
			return _next;
		}

		public function set next(value:Node):void
		{
			value._next = _next;
			value._pre = this;
			
			if(_next)
			{
				_next._pre = value;
			}
			
			_next = value;
		}

		public function get pre():Node
		{
			return _pre;
		}

		public function set pre(value:Node):void
		{
			value._next = this;
			value._pre = _pre;
			
			if(_pre)
			{
				_pre._next = value;
			}
			_pre = value;
		}

	}
}
