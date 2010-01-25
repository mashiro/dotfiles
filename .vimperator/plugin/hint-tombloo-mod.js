var PLUGIN_INFO =
<VimperatorPlugin>
<name>{NAME}</name>
<description>Hint mode for Tombloo</description>
<author>motemen</author>
<version>0.1</version>
<minVersion>2.0pre</minVersion>
<maxVersion>2.0pre</maxVersion>
<updateURL>http://svn.coderepos.org/share/lang/javascript/vimperator-plugins/trunk/hint-tombloo.js</updateURL>
<detail><![CDATA[
== SETTINGS ==

let g:hint_tombloo_key   = 'R'
let g:hint_tombloo_xpath = '//img'

== MAPPINGS ==
;R :
    Share target element by Tombloo

]]></detail>
</VimperatorPlugin>;

(function () {

var hintKey = liberator.globalVariables.hint_tombloo_key   || 'R';
var hintXPath = liberator.globalVariables.hint_tombloo_xpath || '//img';
var hintSpecifiedList = liberator.globalVariables.hint_tombloo_specified_list;

hints.addMode(
    hintKey,
    'Share by Tombloo',
    function (elem) {
        var tomblooService = Cc['@brasil.to/tombloo-service;1'].getService().wrappedJSObject.Tombloo.Service;

        var d = window.content.document;
        var w = window.content.wrappedJSObject;
        var context = {
            document: d,
            window:   w,
            title:    d.title,
            target:   elem,
        };
        for (let p in w.location) {
            context[p] = w.location[p];
        }

        var extractors = tomblooService.check(context);

		var specified;
		for (var i = 0; i < hintSpecifiedList.length; ++i) {
			var url = hintSpecifiedList[i][0];
			if (buffer.URL.match(url)) {
				specified = hintSpecifiedList[i];
				break;
			}
		}

		if (specified) {
			var name = specified[1];
			var show = specified.length >= 2 ? specified[2] : true;
			var extractor;
			for (var i = 0; i < extractors.length; ++i) {
				if (extractors[i].name.match(name)) {
					extractor = extractors[i];
					break;
				}
			}
			if (extractor) {
				tomblooService.share(context, extractor, show);
				return;
			}
		}

		liberator.modules.commandline.input(
			'Extractor: ',
			function (string) {
				var extractor;
				for (let i = 0; i < extractors.length; i++) {
					if (extractors[i].name == string) {
						extractor = extractors[i];
						break;
					}
				}
				if (!extractor) return;

				tomblooService.share(context, extractor, true);
			},
			{
				completer: function (context) {
					context.title = ['Tombloo Extractors'];
					context.completions = extractors.map(
						function (_) [ _.name, _.name ]
					);
				}
			}
		);
    },
    function () hintXPath
);

})();
