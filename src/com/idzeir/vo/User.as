/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.youtu.tv * Created:	Jun 26, 2015 2:29:06 PM			
 * ===================================
 */

package com.idzeir.vo
{
	/**
	 * 用户信息类
	 */	
	public class User implements IUser
	{
		private static var _instance:User;
		
		private var _id:String;
		
		public function User()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public static function getInstance():User
		{
			return _instance ||= new User();
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		public function get id():String
		{
			return _id;
		}
	}
}
