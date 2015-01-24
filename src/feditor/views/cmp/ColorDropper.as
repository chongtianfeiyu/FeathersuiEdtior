package feditor.views.cmp 
{
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.TextInput;
	import feathers.layout.HorizontalLayout;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.display.QuadBatch;
	
	/**
	 * ...
	 * @author gray
	 */
	public class ColorDropper extends LayoutGroup 
	{
		private var input:TextInput;
		private var _color:uint;
		private var target:DisplayObject;
		private var bitmapdata:BitmapData;
		
		public function ColorDropper() 
		{
			super();
			
			input = new TextInput();
			input.width = 70;
			addChild(input);
			
			layout = new HorizontalLayout();
		}
		
		public function show(target:DisplayObject,imgData:BitmapData):void
		{
			this.visible = true;
			this.target = target;
			this.bitmapdata = imgData;
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, touchHandler);
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP,nativeMouseEvtHandler);
		}
		
		private function nativeMouseEvtHandler(e:MouseEvent):void 
		{
			System.setClipboard("0x"+this._color.toString(16));
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP,nativeMouseEvtHandler);
		}
		
		private function touchHandler(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(Starling.current.stage);
			if (touch == null || touch.phase == TouchPhase.ENDED)
			{
				hide();
				return;
			}
			else
			{
				if (bitmapdata)
				{
					var posx:int = touch.globalX - target.x;
					var posy:int = touch.globalY - target.y;
					this.x = posx+15;
					this.y = posy+15;
					
					if (posx > 0 && posx < bitmapdata.width && posy > 0 && posy < bitmapdata.height)
					{
						_color = bitmapdata.getPixel(touch.globalX - target.x,touch.globalY - target.y);
					}
					else
					{
						_color = 0;
					}
					
					input.text = "0x" + (color & 0x00ffffff).toString(16);
				}
			}
		}
		
		public function hide():void
		{
			this.visible = false;
			//target = null;
			//bitmapdata = null;
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,touchHandler);
		}
		
		public function get color():uint 
		{
			return _color;
		}
	}

}