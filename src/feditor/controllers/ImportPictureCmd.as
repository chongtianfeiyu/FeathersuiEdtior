package feditor.controllers 
{
	import feditor.models.ColorDropperProxy;
	import feditor.NS;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
    
    /**
     * ...
     * @author gray
     */
    public class ImportPictureCmd extends SimpleCommand 
    {
        public static const MAX_SIZE:int = 2048;
        private var fileRef:FileReference;
        
        
        public function ImportPictureCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            fileRef = new FileReference();
            fileRef.browse([new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png")]);
            fileRef.addEventListener(Event.SELECT, fileSelectHandler);
            fileRef.addEventListener(Event.COMPLETE, fileCompleteHandler);
        }
        
        private function fileSelectHandler(e:Event):void 
        {
            fileRef.removeEventListener(Event.SELECT, fileSelectHandler);
            fileRef.load();
        }
        
        private function fileCompleteHandler(e:Event):void 
        {
            fileRef.removeEventListener(Event.COMPLETE, fileCompleteHandler);
            var bytes:ByteArray = fileRef.data;
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void { 
                loader.contentLoaderInfo.removeEventListener(e.type, arguments.callee);
                var bmpdata:BitmapData = Bitmap(loader.content).bitmapData;
                
                if (bmpdata.height > MAX_SIZE || bmpdata.width > MAX_SIZE)
                {
                    //TODO scale
                    var scale:Number = bmpdata.width < bmpdata.height?MAX_SIZE / bmpdata.height:MAX_SIZE/bmpdata.width;
                    
                    var matrix:Matrix = new Matrix();
                    matrix.scale(scale, scale);
                    
                    var bitmapCopy:BitmapData = new BitmapData(bmpdata.width*scale,bmpdata.height*scale,true,0);
                    bitmapCopy.draw(bmpdata, matrix,null,null,null,true);
                    
                    bmpdata = bitmapCopy;
                }
                
                if (bmpdata)
                {
					dropperProxy.setSource(bmpdata);
                    var img:Image = new Image(Texture.fromBitmapData(bmpdata));
                    img.smoothing = TextureSmoothing.BILINEAR;
                    sendNotification(NS.NOTE_IMPORT_PICTURE, img);
                }
            } );
            
            loader.loadBytes(bytes);
        }
		
		private function get dropperProxy():ColorDropperProxy
		{
			return facade.retrieveProxy(ColorDropperProxy.NAME) as ColorDropperProxy;
		}
    }

}