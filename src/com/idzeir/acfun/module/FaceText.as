/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Oct 27, 2015 2:40:29 PM			
 * ===================================
 */

package com.idzeir.acfun.module
{
	import com.idzeir.acfun.view.BaseStage;
	
	import flash.events.Event;
	
	/**
	 * 颜文字模块
	 * @author iDzeir
	 */	
	public class FaceText extends BaseStage
	{
		private var array:Array = ["|∀ﾟ","(´ﾟДﾟ`)","(;´Д`)","(=ﾟωﾟ)=","| ω・´)","|∀` )","(つд⊂)","(ﾟДﾟ≡ﾟДﾟ)?!","(|||ﾟДﾟ)","( ﾟ∀ﾟ)"
			,"(*´∀`)","(*ﾟ∇ﾟ)","(　ﾟ 3ﾟ)","( ´_ゝ`)","(・∀・)","(ゝ∀･)","(〃∀〃)","(*ﾟ∀ﾟ*)","( ﾟ∀。)","σ`∀´)"," ﾟ∀ﾟ)σ","(＞д＜)",
			"(|||ﾟдﾟ)","( ;ﾟдﾟ)","(>д<)","･ﾟ( ﾉд`ﾟ)","( TдT)","(￣∇￣)","(￣3￣)","(￣ . ￣)","(￣艸￣)","(*´ω`*)","(´・ω・`)","(oﾟωﾟo)",
			"(ノﾟ∀ﾟ)ノ","|дﾟ )","┃電柱┃","⊂彡☆))д`)","(´∀((☆ミつ","_(:з」∠)_","(●′ω`●) ","(｡・`ω´･)","(￢ω￢)","(」・ω・)」",
			"Σ( ￣□￣||)","Σ( ° △ °|||)","(*/ω＼*)","(｡ゝω･｡)ゞ","(ノ＝Д＝)ノ┻━┻","┯━┯ノ('－'ノ)","（<ゝω·）~☆ "];
		
		public function FaceText()
		{
			super();
		}
		
		override protected function onAdded(e:Event):void
		{
			super.onAdded(e);
		}
	}
}