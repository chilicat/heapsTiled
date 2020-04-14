package tiled.com;

class TLayer  {
	public var id : Int;
	public var name : String = "";
	public var wid : Int;
	public var hei : Int;
	var props : TProps;
	var tmap : TMap;

	var ids : Array<Int> = [];
	var xFlip : Map<Int,Bool> = new Map();
	var yFlip : Map<Int,Bool> = new Map();
	var content : Map<Int,Int> = new Map();

	public function new(tmap:TMap, name:String, id:Int, w, h) {
		this.tmap = tmap;
		this.name = name;
		this.id = id;
		wid = w;
		hei = h;
	}

	public inline function isXFlipped(cx:Int, cy:Int) return xFlip.get(cx+cy*wid) == true;
	public inline function isYFlipped(cx:Int, cy:Int) return yFlip.get(cx+cy*wid) == true;

	inline function checkBit(v:UInt, bit:Int) : Bool {
		return v&(1<<bit) != 0;
	}

	inline function clearBit(v:UInt, bit:Int) : UInt {
		return v & ( 0xFFFFFFFF - (1<<bit) );
	}

	public function setIds(a:Array<UInt>) {
		// Check for flip bits
		xFlip = new Map();
		yFlip = new Map();
		for(i in 0...a.length) {
			if( checkBit(a[i], 31) ) {
				xFlip.set(i, true);
				a[i] = clearBit(a[i], 31);
			}
			if( checkBit(a[i],30) ) {
				yFlip.set(i,true);
				a[i] = clearBit(a[i], 30);
			}
		}

		// Store IDs
		ids = a;
		content = new Map();
		var i = 0;
		for(id in ids) {
			if( id>0 )
				content.set(i, id);
			i++;
		}
	}

	public inline function getIds() return ids;

	public function hasTile(cx,cy) return content.exists(cx + cy*wid);
	public function getGlobalTileId(cx,cy) {
		return !hasTile(cx,cy) ? -1 : content.get(cx+cy*wid);
	}
	public function getLocalTileId(cx,cy) {
		if( !hasTile(cx,cy) )
			return -1;
		var id = content.get(cx+cy*wid);
		id -= tmap.getTileSet(id).baseId;
		return id;
	}

	public function getProps() : TProps {
		return props;
    }
    
	public function setProps(props : TProps) {
		this.props = props;
	}

	@:deprecated("Use getProps().setProps(name, v)")
	public function setProp(name, v) {
		props.setProp(name, v);
	}

	@:deprecated("Use getProps().hasProp(name, v)")
	public inline function hasProp(name) {
		return props.hasProp(name);
	}

	@:deprecated("Use getProps().getPropStr(name, v)")
	public function getPropStr(name) : Null<String> {
		return props.getPropStr(name);
	}

	@:deprecated("Use getProps().getPropInt(name, v)")
	public function getPropInt(name) : Int {
		return props.getPropInt(name);
	}

	@:deprecated("Use getProps().getPropFloat(name, v)")
	public function getPropFloat(name) : Float {
		return props.getPropFloat(name);
	}

	@:deprecated("Use getProps().getPropBool(name, v)")
	public function getPropBool(name) : Bool {
		return props.getPropBool(name);
	}
}
