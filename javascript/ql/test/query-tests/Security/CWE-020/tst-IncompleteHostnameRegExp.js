(function() {
	/http:\/\/example.com/; // OK
	/http:\/\/test.example.com/; // NOT OK
	/http:\/\/test\\.example.com/; // OK
	/http:\/\/test.example.net/; // NOT OK
	/http:\/\/test.(example-a|example-b).com/; // NOT OK
	/http:\/\/(.+)\\.example.com/; // NOT OK, but not yet supported with enough precision
	/http:\/\/(\\.+)\\.example.com/; // OK
	/http:\/\/(?:.+)\\.test\\.example.com/; // NOT OK, but not yet supported with enough precision
	/http:\/\/test.example.com\/(?:.*)/; // OK
	new RegExp("http://test.example.com"); // NOT OK
	s.match("http://test.example.com"); // NOT OK

	function id(e) { return e; }
	new RegExp(id(id(id("http://test.example.com")))); // NOT OK

	new RegExp(`test.example.com$`); // NOT OK

	let hostname = 'test.example.com'; // NOT OK
	new RegExp(`${hostname}$`);

	let domain = { hostname: 'test.example.com' };
	new RegExp(domain.hostname);

	function convert(domain) {
		return new RegExp(domain.hostname);
	}
	convert({ hostname: 'test.example.com' }); // NOT OK

	let domains = [ { hostname: 'test.example.com' } ];  // NOT OK, but not yet supported
	function convert(domain) {
		return new RegExp(domain.hostname);
	}
	domains.map(d => convert(d));

	/(.+\.(?:example-a|example-b)\.com)/; // NOT OK, but not yet supported with enough precision
	/^(https?:)?\/\/((service|www).)?example.com(?=$|\/)/; // NOT OK
	/^(http|https):\/\/www.example.com\/p\/f\//; // NOT OK
	/\(http:\/\/sub.example.com\/\)/g; // NOT OK
	/https?:\/\/api.example.com/; // NOT OK
	new RegExp('^http://localhost:8000|' + '^https?://.+\.example\.com'); // NOT OK
	new RegExp('http[s]?:\/\/?sub1\.sub2\.example\.com\/f\/(.+)'); // NOT OK
	/^https:\/\/[a-z]*.example.com$/; // NOT OK
	RegExp('protos?://(localhost|.+.example.net|.+.example-a.com|.+.example-b.com|.+.example.internal)'); // NOT OK

	/example.dev|example.com/; // OK, but still flagged
});
