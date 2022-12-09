public enum Script: String {
    case
    favicon = "GoPrivacyApp_favicon",
    dark = "GoPrivacyApp_dark",
    reader = "GoPrivacyApp_reader",
    location = "GoPrivacyApp_location",
    find = "GoPrivacyApp_find"
    
    public static let js = """
// storage
localStorage.clear();
sessionStorage.clear();

// favicon
function \(favicon.rawValue)() {
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

    window.webkit.messageHandlers.\(favicon.rawValue).postMessage(icon + ";" + window.location.href);
}

\(favicon.rawValue)();


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

// finder
function \(find.rawValue)(query) {
    var result = null;
    var item = window.getSelection().anchorNode;

    while (item != null) {
        if (item.querySelectorAll != null) {
            const elements = item.querySelectorAll(query);
            
            for (var i = 0; i < elements.length; i++) {
                const source = elements[i].src;
                
                if (source != null) {
                    result = source;
                    break;
                }
            }
        }
    
        if (result == null) {
            item = item.parentNode;
            
            if (item != null, item.tagName != null) {
                if (item.tagName == "BODY" || item.tagName == "HTML") {
                    item = null;
                }
            }
        } else {
            item = null;
        }
    }
    
    return result;
}

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

// darkmode
function \(dark.rawValue)() {
    function _privacy_incognit_make_dark(element) {
        if (!element.hasAttribute('_privacy_incognit_dark_mode')) {
            element.setAttribute('_privacy_incognit_dark_mode', 1);

            const text_color = getComputedStyle(element).getPropertyValue("color");
            const background_color = getComputedStyle(element).getPropertyValue("background-color");

            if (text_color != "rgb(206, 204, 207)" && text_color != "rgb(124, 170, 223)") {
                if (element.tagName == "A") {
                    element.style.setProperty("color", "#7caadf", "important");
                } else {
                    element.style.setProperty("color", "#cecccf", "important");
                }
            }

            if (getComputedStyle(element).getPropertyValue("box-shadow") != "none") {
                element.style.setProperty("box-shadow", "none", "important");
            }

            if (getComputedStyle(element).getPropertyValue("background").includes("gradient")) {
                element.style.setProperty("background", "none", "important");
            }

            if (background_color != "rgb(37, 34, 40)" && background_color != "rgba(0, 0, 0, 0)" && background_color != "rgb(0, 0, 0)") {
                let alpha = 1;
                const rgba = background_color.match(/[\\d.]+/g);
                if (rgba.length > 3) {
                   alpha = rgba[3];
                }
                element.style.setProperty("background-color", "rgba(37, 34, 40, " + alpha + ")", "important");
            }
        }
    }

    const _privacy_incognit_event = function(_privacy_incognit_event) {
        if (_privacy_incognit_event.animationName == '_privacy_incognit_node') {
            document.body.querySelectorAll(":not([_privacy_incognit_dark_mode])").forEach(_privacy_incognit_make_dark);
        }
    }

    document.addEventListener('webkitAnimationStart', _privacy_incognit_event, false);

    const _privacy_incognit_style = document.createElement('style');
    _privacy_incognit_style.innerHTML = "\
    \
    :root, html, body, header {\
        background-image: none !important;\
        background-color: #252228 !important;\
    }\
    a, a *, :not(a p) {\
        color: #7caadf !important;\
    }\
    :root :not(a, a *), a p {\
        color: #cecccf !important;\
    }\
    * {\
        -webkit-animation-duration: 0.01s;\
        -webkit-animation-name: _privacy_incognit_node;\
        border-color: #454248 !important;\
        outline-color: #454248 !important;\
        box-shadow: none !important;\
    }\
    ::before, ::after {\
        background: none !important;\
    }\
    @-webkit-keyframes _privacy_incognit_node {\
        from {\
            outline-color: #fff;\
        }\
        to {\
            outline-color: #000;\
        }\
    }";

    document.addEventListener('readystatechange', event => {
        switch (event.target.readyState) {
            case "interactive":
                document.head.appendChild(_privacy_incognit_style);
                break;
            case "complete":
                document.body.querySelectorAll(":not([_privacy_incognit_dark_mode])").forEach(_privacy_incognit_make_dark);
                break;
            default:
                break;
        }
    });

    setTimeout(function() {
        document.head.appendChild(_privacy_incognit_style);
    }, 1);
}

"""
}
