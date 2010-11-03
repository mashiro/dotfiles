// ==UserScript==
// @name           Pixiv + Tombloo
// @namespace      http://gist.github.com/660432
// @include        http://www.pixiv.net/*
// ==/UserScript==

// require: https://github.com/retlet/tombloo_scripts/blob/master/extractor.pixivPhoto.js

function boot(ev){
    if(ev) window.removeEventListener('GM_MinibufferLoaded', boot, false);

    var tombloo = GM_Tombloo.Tombloo.Service;
    var win = unsafeWindow;
    var doc = document;
    var Minibuffer = window.Minibuffer;
    var $X = Minibuffer.$X;

    Minibuffer.addCommand({
        name    : 'Share::Photo::Pixiv',
        command : function(stdin){
            stdin.forEach(function(node){
                var target = $X('descendant::img', node)[0] || null;
                if (!target) return;

                var ctx = update({
                    document  : doc,
                    window    : win,
                    selection : '' + win.getSelection(),
                    target    : target,
                    event     : {},
                    title     : null,
                    mouse     : null,
                    menu      : null,
                }, win.location);

                var ext = tombloo.check(ctx)[0];
                tombloo.share(ctx, ext, false);
                Minibuffer.status('Share::Photo::Pixiv'+node.id, 'Share', 100);
            });
            return stdin;
        }
    });

    Minibuffer.addShortcutkey({
        key         : 't',
        description : 'Share by Tombloo',
        command     : function(){
            try { var stdin = Minibuffer.execute('pinned-or-current-node') } catch(e) {}
            Minibuffer.execute('Share::Photo::Pixiv|clear-pin', stdin);
        }
    });

    function update(t, s){
        for(var p in s)
            t[p] = s[p];
        return t;
    }
}

if(window.Minibuffer){
    boot();
} else {
    window.addEventListener('GM_MinibufferLoaded', boot, false);
}
