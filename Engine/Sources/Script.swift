public enum Script: String {
    case
    reader = "GoPrivacyApp_reader",
    location = "GoPrivacyApp_location"
    
    public static let js = """
// storage
localStorage.clear();
sessionStorage.clear();

// location
navigator.geolocation.getCurrentPosition = async function(success, error, options) {
    try {
        var promise = await window.webkit.messageHandlers.\(location.rawValue).postMessage("\(location.rawValue)");

        if (success != null, promise != null) {
            var position = {
               coords: {
                   latitude: promise[0],
                   longitude: promise[1],
                   accuracy: promise[2]
               }
            };
            success(position);
        }
    } catch(e) {
        error(e);
    }
};

// scroll
const _privacy_incognit_splitted = location.hostname.split(".");
if (_privacy_incognit_splitted.length > 1) {
    switch (_privacy_incognit_splitted[_privacy_incognit_splitted.length - 2]) {
    case "google":
            var style = document.createElement('style');
            style.innerHTML = ":root, body { overflow-y: visible !important; }";
            document.head.appendChild(style);
            break;
    case "twitter":
            var style = document.createElement('style');
            style.innerHTML = ":root, html, body { overflow-y: visible !important; }";
            document.head.appendChild(style);
            break;
    case "youtube":
            var style = document.createElement('style');
            style.innerHTML = "body { position: unset !important; }";
            document.head.appendChild(style);
            break;
    case "instagram":
            var style = document.createElement('style');
            style.innerHTML = ":root, html, body, .E3X2T { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "reuters":
            var style = document.createElement('style');
            style.innerHTML = ":root, html, body { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "thelocal":
            var style = document.createElement('style');
            style.innerHTML = ".tp-modal-open { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "pinterest":
            document.body.setAttribute("style", "overflow-y: visible !important");
            break;
    case "bbc":
            var style = document.createElement('style');
            style.innerHTML = "body { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "reddit":
            var style = document.createElement('style');
            style.innerHTML = "body, .scroll-disabled { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "bloomberg":
            var style = document.createElement('style');
            style.innerHTML = "body { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    default:
            break;
    }
}

// favicon
function GoPrivacyApp_favicon() {
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

    window.webkit.messageHandlers.GoPrivacyApp_favicon.postMessage(icon);
}

GoPrivacyApp_favicon();
"""
}
