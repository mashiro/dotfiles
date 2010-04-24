(function() {
Tombloo.Service.extractors.register([
{
	name : 'Photo - pixiv',
	ICON : 'http://www.pixiv.net/favicon.ico',
	check : function(ctx){
		return ctx.onImage && ctx.target.src.match(/^http:\/\/img\d.+?\.pixiv\.net\/img\//);
	},
	extract : function(ctx){
		var hostURL = 'http://www.pixiv.net/';
		var illustURL = /^http:\/\/www\.pixiv\.net\/member_illust.php\?mode=/;
		var mangaURL =  /^http:\/\/www\.pixiv\.net\/member_illust.php\?mode=manga/;
		if(!ctx.href.match(illustURL)){
		//実行元がイラストページではなかった場合、リンク先のイラストページを取得して足りない情報を得る
			var deferred = request(ctx.link.href).addCallback(function(res){
				var responseHTML = convertToHTMLDocument(res.responseText);
			//実行元タイトルをイラストページのタイトルに入れ替え
				ctx.title = $x('//title/text()', responseHTML);
			//イラストに設定されたリンクを取得
				var linkHREF = $x("id('tag_area')/following-sibling::*/a[contains(@href,'mode=')]/@href",responseHTML);
			//実行元アドレスをイラストページのアドレスに入れ替え
				ctx.href = ctx.link.href;
			//相対アドレスが取得されていた場合、ホスト部を補間
				if(!linkHREF.match(/^http:\/\//)) linkHREF = hostURL + linkHREF;
			//イラストに設定されたリンクのアドレスを返す
				return linkHREF;
			});
		}else{
		//実行元がイラストページだった場合、必要な情報は得られるのでリンク先から取得する必要は無い
		//succeedは成功したdeferredが返る。設定した引数はcallbackの引数になる。
		//すでに必要な値が揃ってる場合と、requestして情報を取ってこなきゃいけない場合が同じように書ける。
			var deferred = succeed(ctx.href);
		}

		return deferred.addCallback(function(linkHREF){
			if(linkHREF.match(mangaURL) || $x('//a[contains(@href, "mode=manga")]')){
			//マンガ形式だった場合、1枚目の画像を設定
				var itemUrl = ctx.target.src.replace(/_(?:m|s|100)\.([^.]+)$/,'_p0.$1');
			}else{
				var itemUrl = ctx.target.src.replace(/_(?:m|s|100)\.([^.]+)$/,'.$1');
			}

			return download(itemUrl, getTempDir(), false).addCallback(function(file){
					return {
						type	: 'photo',
						item	: ctx.title,
						itemUrl : itemUrl,
						file	: file,
					}
			});
		});
	}
}
],'Photo');
})();
