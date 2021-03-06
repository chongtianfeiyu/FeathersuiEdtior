package feditor.events 
{
    import feathers.events.FeathersEventType;
    /**
     * ...
     * @author gray
     */
    public class EventType
    {
        public static const PREVIEW:String = "preview";
        public static const SELECT_CMP:String = "select_cmp";
		public static const UNSELECT_CMP:String = "unselect_cmp";
        public static const ASSET_PLACE:String = "asset_place";
		
		public static const DRAG_RECT:String = "drag_select";
		public static const DROPPER:String = "dropper";
		
		public static const REFRESH:String = "refresh";
    }

}