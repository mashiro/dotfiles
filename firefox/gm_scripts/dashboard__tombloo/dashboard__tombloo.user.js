// ==UserScript==
// @name           Dashboard + Tombloo
// @namespace      http://d.hatena.ne.jp/Constellation/
// @description    register reblog command by Tombloo
// @include        http://www.tumblr.com/dashboard*
// @include        http://www.tumblr.com/tumblelog*
// @include        http://www.tumblr.com/show*
// @include        http://www.tumblr.com/iphone*
// ==/UserScript==
//
// Detail : Pinned-node Reblog
//          Pinned-node Local  Download
//
// Command: Tombloo::Reblog
//          Tombloo::Local
//
//

function boot(ev){
  if(ev) window.removeEventListener('GM_MinibufferLoaded', boot, false);

  var tombloo = GM_Tombloo.Tombloo.Service;
  var win = unsafeWindow;
  var doc = document;
  var Minibuffer = window.Minibuffer;
  var $X = Minibuffer.$X;

  [
  // Tombloo Reblog
    {
      name    : 'Tombloo::Reblog',
      command : function(stdin){
        stdin.forEach(function(node){

          var ctx = update({
            document  : doc,
            window    : win,
            selection : '' + win.getSelection(),
            target    : node,
            event     : {},
            title     : null,
            mouse     : null,
            menu      : null,
          }, win.location);

          var ext = tombloo.check(ctx)[0];
          tombloo.share(ctx, ext, false);
          Minibuffer.status('Tombloo::Reblog'+node.id,'Reblog',100);
        });
        return stdin;
      }
    },
  // Tombloo Local Download for Photo Post
    {
      name    : 'Tombloo::Local',
      command : function(stdin){
        stdin.forEach(function(node){
          var target = $X('descendant::img[contains(concat(" ", normalize-space(@class), " "), " image ") or contains(concat(" ", normalize-space(@class), " "), " photo ")]',node)[0] || null;
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
            onImage   : true,
          }, win.location);

          var ps = tombloo.extractors.Photo.extract(ctx);
          ps = update({
            page    : ctx.title,
            pageUrl : ctx.href,
          }, ps);

          Minibuffer.status('Tombloo::Local'+node.id,'Download', 100);
          GM_Tombloo.Local
            .post(ps)
        });
        return stdin;
      }
    },
  ].forEach(Minibuffer.addCommand);

  [
    {
        key : 't',
        description : 'Reblog by Tombloo',
        command : function(){
          try { var stdin = Minibuffer.execute('pinned-or-current-node') }catch(e) {}
          Minibuffer.execute('Tombloo::Reblog|clear-pin',stdin);
        }
    },
    {
        key : 'd',
        description : 'Download by Tombloo',
        command : function(){
          try { var stdin = Minibuffer.execute('pinned-or-current-node') }catch(e) {}
          Minibuffer.execute('Tombloo::Local|clear-pin',stdin);
        }
    }
  ].forEach(Minibuffer.addShortcutkey);

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
