package tiled.com;

import haxe.xml.*;

class TProps {
    
    private var internal : Map<String,String>;

	/*
	<properties>
		<property name="name1" value="value1"/>
		<property name="name2" value="value2"/>
		...
	</properties>
	*/
    public static function fromXML(xml : Xml) {
        var n = new haxe.xml.Access(xml);
        var props = new TProps();
        if(n.hasNode.properties) {
            for(p in n.node.properties.nodes.property) {
                props.setProp(p.att.name, p.att.value);
            }
        }
        return props;
    }

    public function new() {
        this.internal = new Map();
    }

    public function setProp(name, v) {
		internal.set(name, v);
	}
    public inline function hasProp(name) {
		return internal.exists(name);
	}

	public function getPropStr(name) : Null<String> {
		return internal.get(name);
	}

	public function getPropInt(name) : Int {
		var v = getPropStr(name);
		return v==null ? 0 : Std.parseInt(v);
	}

	public function getPropFloat(name) : Float {
		var v = getPropStr(name);
		return v==null ? 0 : Std.parseFloat(v);
	}

	public function getPropBool(name) : Bool {
		var v = getPropStr(name);
		return v=="true";
    }
}