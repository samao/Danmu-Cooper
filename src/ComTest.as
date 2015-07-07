/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Jul 7, 2015 6:08:59 PM			
 * ===================================
 */

package
{
	import com.idzeir.acfun.view.List;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class ComTest extends Sprite
	{
		public function ComTest()
		{
			super();
			
			var list:List = new List();
			list.dateProvider = ["C++中文版primer","高质量程序设计指南C++","C++标准程序库","Google的C++编码规范","Effective C++"];
			this.addChild(list);
			
			list.addEventListener(Event.SELECT,function():void
			{
				trace(list.selected);
			});
		}
	}
}