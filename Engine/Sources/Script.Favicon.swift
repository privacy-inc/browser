extension Script {
    static let _favicon = """
function \(favicon.method) {
    const list = document.querySelectorAll("link[rel*='icon']");
    var icon = null;

    function find(rel) {
        var found = null;
        var maxSize = 0;
        for (var i = 0; i < list.length; i++) {
            if (list[i].getAttribute("rel") == rel && !list[i].href.endsWith('.svg')) {
                var sizes = list[i].getAttribute("sizes");
                var size = 0;
                
                if (sizes != undefined) {
                    var split = sizes.split("x");
                    if (split.length == 2) {
                        size = split[0] / 1;
                    }
                }
                
                if (size > maxSize || maxSize == 0) {
                    found = list[i].href;
                    maxSize = size;
                }
            }
        }
        
        return found;
    }
    
    icon = find("apple-touch-icon");
    
    if (icon == null) {
        icon = find("apple-touch-icon-precomposed");
        
        if (icon == null) {
            icon = find("icon");
            
            if (icon == null) {
                icon = find("shortcut icon");
                
                if (icon == null) {
                    icon = find("alternate icon");
                    
                    if (icon == null) {
                        icon = window.location.origin + "/favicon.ico";
                    }
                }
            }
        }
    }

    return icon;
}
"""
}
