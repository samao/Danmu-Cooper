/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jun 3, 2015 7:05:06 PM			
 * ===================================
 */

package com.idzeir.acfun.vo
{
	
	
	/**
	 * 视频信息
	 */	
	public class VideoInfoVo implements IVideoInfoVo
	{
		private var _danmakuId:String = "";
		private var _sourceType:String ="";
		private var _videoLength:int = 0;
		
		private static var _instance:VideoInfoVo;
		
		public function VideoInfoVo()
		{
			if(_instance)
			{
				throw new Error("单例");
			}
		}
		
		public static function getInstance():VideoInfoVo
		{
			return _instance ||= new VideoInfoVo();
		}
		
		public function get sourceType():String
		{
			return _sourceType;
		}
		public function get danmakuId():String
		{
			return _danmakuId;
		}
		
		public function get videoLength():int
		{
			return _videoLength;
		}

		public function update(value:Object):IVideoInfoVo
		{
			if(value)
			{
				value.hasOwnProperty("danmakuId")&&(_danmakuId = value["danmakuId"]);
				value.hasOwnProperty("sourceType")&&(_sourceType = value["sourceType"]);
				value.hasOwnProperty("videoLength")&&(_videoLength = value["videoLength"]);
			}
			return this
		}
	}
}