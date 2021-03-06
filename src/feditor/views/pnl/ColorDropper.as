package feditor.views.pnl {
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.TextInput;
	import feathers.layout.HorizontalLayout;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
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
		private var localPos:Point = new Point();
		private var globalPos:Point = new Point();
		private var image:Image;
		
		public function ColorDropper() 
		{
			super();
			
			input = new TextInput();
			input.width = 85;
			
			image = new Image(Texture.fromColor(10, 10));
			image.x = input.width - 20;
			image.y = 5;
			
			addChild(input);
			addChild(image);
			this.visible = false;
		}
		
		private var _imgScaleX:Number = 0;
		private var _imgScaleY:Number = 0;
		
		public function show(imgData:BitmapData,w:int,h:int):void
		{
			if (imgData == null) return;
			this.visible = true;
			this.x = -300;
			this.bitmapdata = imgData;
			
			_imgScaleX = imgData.width / w;
			_imgScaleY = imgData.height / h;
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private function touchHandler(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(parent);
			if (touch == null)
			{
				return;
			}
			
			if (touch.phase == TouchPhase.ENDED)
			{
				hide();
				dispatchEventWith(Event.SELECT,false,this._color);
				return;
			}
			else
			{
				if (bitmapdata)
				{
					globalPos.x = touch.globalX;
					globalPos.y = touch.globalY;
					
					parent.globalToLocal(globalPos, localPos);
					
					this.x = localPos.x + 15;
					this.y = localPos.y + 15;
					
					if (localPos.x > 0 && localPos.x < bitmapdata.width && localPos.y > 0 && localPos.y < bitmapdata.height)
					{
						_color = bitmapdata.getPixel(localPos.x*_imgScaleX,localPos.y*_imgScaleY);
					}
					else
					{
						_color = 0;
					}
					
					image.color = 0xff000000 | _color;
					input.text = "0x" + (color & 0x00ffffff).toString(16);
				}
			}
		}
		
		public function hide():void
		{
			this.visible = false;
			bitmapdata = null;
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,touchHandler);
		}
		
		public function get color():uint 
		{
			return _color;
		}
	}

}