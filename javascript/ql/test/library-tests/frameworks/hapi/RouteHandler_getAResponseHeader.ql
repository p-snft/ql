import semmle.javascript.frameworks.Express

from Hapi::RouteHandler rh, string name
select rh, name, rh.getAResponseHeader(name)
