var partner_id = 'tac';

(function () {
    if (window.location.hostname == 'docs.google.com') {
        return;
    }

    var ATF_THRESHOLD = 1000;
    var tags = [ "IFRAME", "OBJECT", "EMBED" ];
    var sizes = [ { width: 300, height: 250 } ];
    var ads = {"300x250-ATF":"<html>\n<head>\n<style>\n.notice {\n    position: absolute;\n    bottom: 0;\n    right: 0;\n    font: 9px sans-serif;\n    color: #AAA;\n    background-color: #333;\n    padding: 2px;\n}\n#closer {\n    cursor: pointer;\n}\n#closer:hover {\n    text-decoration: underline;\n}\n<\/style>\n<\/head>\n<body style=\"margin:0; width:300px; height:250px; overflow:hidden;\">\n<script type='text\/javascript'><!--\/\/<![CDATA[\n   var m3_u = (location.protocol=='https:'?'https:\/\/ads.panoramtech.net\/server\/www\/delivery\/ajs.php':'http:\/\/ads.panoramtech.net\/server\/www\/delivery\/ajs.php');\n   var m3_r = Math.floor(Math.random()*99999999999);\n   if (!document.MAX_used) document.MAX_used = ',';\n   document.write (\"<scr\"+\"ipt type='text\/javascript' src='\"+m3_u);\n   document.write (\"?zoneid=21\");\n   document.write ('&amp;cb=' + m3_r);\n   if (document.MAX_used != ',') document.write (\"&amp;exclude=\" + document.MAX_used);\n   document.write (document.charset ? '&amp;charset='+document.charset : (document.characterSet ? '&amp;charset='+document.characterSet : ''));\n   document.write (\"&amp;loc=\" + escape(window.location));\n   if (document.referrer) document.write (\"&amp;referer=\" + escape(document.referrer));\n   if (document.context) document.write (\"&context=\" + escape(document.context));\n   if (document.mmm_fo) document.write (\"&amp;mmm_fo=1\");\n   document.write (\"'><\\\/scr\"+\"ipt>\");\n\/\/]]>--><\/script>\n<\/body>\n<\/html>\n","300x25":"<html>\n<head>\n<style>\n.notice {\n    position: absolute;\n    bottom: 0;\n    right: 0;\n    font: 9px sans-serif;\n    color: #AAA;\n    background-color: #333;\n    padding: 2px;\n}\n#closer {\n    cursor: pointer;\n}\n#closer:hover {\n    text-decoration: underline;\n}\n<\/style>\n<\/head>\n<body style=\"margin:0; width:300px; height:250px; overflow:hidden;\">\n<script type='text\/javascript'><!--\/\/<![CDATA[\n   var m3_u = (location.protocol=='https:'?'https:\/\/ads.panoramtech.net\/server\/www\/delivery\/ajs.php':'http:\/\/ads.panoramtech.net\/server\/www\/delivery\/ajs.php');\n   var m3_r = Math.floor(Math.random()*99999999999);\n   if (!document.MAX_used) document.MAX_used = ',';\n   document.write (\"<scr\"+\"ipt type='text\/javascript' src='\"+m3_u);\n   document.write (\"?zoneid=21\");\n   document.write ('&amp;cb=' + m3_r);\n   if (document.MAX_used != ',') document.write (\"&amp;exclude=\" + document.MAX_used);\n   document.write (document.charset ? '&amp;charset='+document.charset : (document.characterSet ? '&amp;charset='+document.characterSet : ''));\n   document.write (\"&amp;loc=\" + escape(window.location));\n   if (document.referrer) document.write (\"&amp;referer=\" + escape(document.referrer));\n   if (document.context) document.write (\"&context=\" + escape(document.context));\n   if (document.mmm_fo) document.write (\"&amp;mmm_fo=1\");\n   document.write (\"'><\\\/scr\"+\"ipt>\");\n\/\/]]>--><\/script>\n<\/body>\n<\/html>\n"};
    var refresh = [];

    var findPos = function(obj) {
        var curleft = curtop = 0;

        if (obj.offsetParent) {
            do {
                curleft += obj.offsetLeft;
                curtop += obj.offsetTop;

            } while (obj = obj.offsetParent);
        }

        return { left: curleft, top:curtop };
    };

    var toArray = function(obj) {
          var array = [];
          // iterate backwards ensuring that length is an UInt32
          for (var i = obj.length >>> 0; i--;) {
                array[i] = obj[i];
          }
          return array;
    };

    var makeCloser = function(iframeId) {
        return function() {
            for (var i = 0; i < refresh.length; i++) {
                if (refresh[i].iframeId == iframeId) {
                    var iframe = document.getElementById(iframeId);
                    if (iframe) {
                        iframe.parentNode.removeChild(iframe);
                    }
                    refresh.splice(i, 1);
                    break;
                }
            }
        };
    }

    for (var i = 0; i < tags.length; i++) {
        var tag = tags[i];

        var elements = toArray(document.getElementsByTagName(tag));

        for (var j = 0; j < elements.length; j++) {
            var element = elements[j];

            var size = null;
            for (var k = 0; k < sizes.length; k++) {
                size = sizes[k];
                if (element.clientWidth == size.width &&
                    element.clientHeight == size.height) {

                    var iframeId = 'pifId-' + Math.floor(Math.random()*99999999999);
                    // swap with iframe
                    var newIFrame = document.createElement("iframe");

                    newIFrame.style.setProperty("border", "none");
                    newIFrame.width = size.width;
                    newIFrame.height = size.height;
                    newIFrame.id = iframeId;
                    var parent = element.parentNode;
                    parent.insertBefore(newIFrame, element);

                    var iframe = (newIFrame.contentWindow) ? newIFrame.contentWindow : (newIFrame.contentDocument.document) ? newIFrame.contentDocument.document : newIFrame.contentDocument;
                    var pos = findPos(element);
                    var adName = null;
                    if (pos.top < ATF_THRESHOLD) {
                        adName = size.width + "x" + size.height + "-ATF";
                    } else {
                        adName = size.width + "x" + size.height;
                    }
                    var savedIFrame = {
                        iframe: iframe,
                        adName: adName,
                        iframeId: iframeId
                    };
                    refresh.push(savedIFrame);

                    iframe.document.open();
                    iframe.document.write(ads[savedIFrame.adName]);
                    iframe.document.close();

                    iframe.onload = (function(i, id) {
                        return function() {
                            // attach closer
                            var closer = i.document.getElementById("closer");
                            if (closer) {
                                closer.addEventListener("click", makeCloser(id));
                            }
                        };
                    })(iframe, savedIFrame.iframeId);
                }
            }
        }
    }

    if (refresh.length > 0) {
        setInterval(function() {
            for (var i = 0; i < refresh.length; i++) {
                var iframe = refresh[i].iframe;
                iframe.document.open();
                iframe.document.write(ads[refresh[i].adName]);
                iframe.document.close();

                iframe.onload = (function(i, id) {
                    return function() {
                        // attach closer
                        var closer = i.document.getElementById("closer");
                        if (closer) {
                            closer.addEventListener("click", makeCloser(id));
                        }
                    };
                })(iframe, refresh[i].iframeId);
            }
        },  Math.floor((Math.random()*25000)+50000));
    }
})();

